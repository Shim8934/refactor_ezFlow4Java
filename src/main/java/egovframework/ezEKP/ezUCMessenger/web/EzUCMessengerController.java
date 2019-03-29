package egovframework.ezEKP.ezUCMessenger.web;

import java.io.PrintWriter;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezUCMessenger.util.EzUCMessengerUtil;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.user.login.web.LoginController;
import egovframework.let.utl.fcc.service.ClientUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

/**
 * 
 * @Description UCWare 메신저에서 ezEKP 그룹웨어 연동 관련 호출하는 URL 처리를 수행하는 클래스
 * @author skyblue0o0
 *
 */
@Controller
public class EzUCMessengerController {

	private static final Logger logger = LoggerFactory.getLogger(EzUCMessengerController.class);
	
	@Autowired
	private EzUCMessengerUtil ezUCMessengerUtil;
	
	@Resource(name = "loginService")
    private LoginService loginService;
	
	@Resource(name="EzCommonService")
	private EzCommonService ezCommonService;
	
	@Autowired
	private LoginController loginController;
	
    @RequestMapping("/ezUCMessenger/loginCheck.do")
	public void loginCheck(
					@RequestParam String id,
					HttpServletRequest request,
					HttpServletResponse response
					) throws Exception {
		logger.debug("loginCheck started.");
		
		String result = "FALSE";
		
		try {
			id = ezUCMessengerUtil.decryptAES(id);
			
			String orgId = id.split(":")[0];
			String orgPw = id.split(":")[1];
			logger.debug("orgId=" + orgId);
			
			String serverName = request.getServerName();
	        int serverPort = request.getServerPort();
	        int tenantId = loginService.getTenantId(serverName);
	        logger.debug("serverName=" + serverName + ",serverPort=" + serverPort + ",tenantId=" + tenantId);
			
			boolean isUserExists = checkIfUserExistsWithPassword(orgId, orgPw, tenantId, request);
			logger.debug("isUserExists=" + isUserExists);
			
			if (isUserExists) {
				result = "TRUE";
			}
		} catch (Exception e) {
			result = "FALSE";
			e.printStackTrace();
		}
		
		PrintWriter writer = null;
		
		try {
			writer = response.getWriter();
			
			writer.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
			writer.println("<login_check>");
			writer.printf("<result>%s</result>", result);
			writer.println();
			writer.println("<cause></cause>");
			writer.println("</login_check>");
			
			writer.flush();
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			if (writer != null) {
				try { writer.close(); } catch(Exception e) {}
			}
		}
		
		logger.debug("loginCheck ended. result=" + result);
	}
    
	@RequestMapping("/ezUCMessenger/sso.do")
	public String sso(
					@RequestParam String id,
					@RequestParam(required = false) String type,
					HttpServletRequest request,
					HttpServletResponse response
					) throws Exception {
		logger.debug("sso started.");
		
		id = ezUCMessengerUtil.decryptAES(id);
		String orgId = id;
		logger.debug("orgId=" + orgId);
		
        String serverName = request.getServerName();
        int serverPort = request.getServerPort();
        int tenantId = loginService.getTenantId(serverName);
        logger.debug("serverName=" + serverName + ",serverPort=" + serverPort + ",tenantId=" + tenantId);
		
        orgId = getIdIfUserExists(orgId, tenantId);
		logger.debug("orgId=" + orgId);
		
		String redirectUrl = "redirect:/user/login/login.do";
		if (orgId != null) {
			loginController.createLoginCookie(orgId, " ", " ", tenantId, request, response,"","");
			
			if (type == null) { // 홈 화면으로 이동
				redirectUrl = "redirect:/ezPortal/portalMain.do";
			} else if (type.equals("1")) { //메일 화면으로 이동
				redirectUrl = "redirect:/ezPortal/portalMain.do?mode=mail";
			} else if (type.equals("2")) { //전자결재 화면으로 이동
				redirectUrl = "redirect:/ezPortal/portalMain.do?mode=approval";
			} else {
				redirectUrl = "redirect:/ezPortal/portalMain.do";
			}
		}
		
		logger.debug("sso ended.");
		return redirectUrl;
	}
	
	
	private String getIdIfUserExists(String id, int tenantId) throws Exception {
		logger.debug("getIdIfUserExists started. id=" + id + ",tenantId=" + tenantId);
		
		String orgId = null;
		
		// Check if this user exists
		LoginVO loginVO = new LoginVO();	
		loginVO.setId(id);
		loginVO.setTenantId(tenantId);
		loginVO.setDn("NOPASSWORD");
		LoginVO resultVO = loginService.selectUser(loginVO);
		
		// 사용자 ID 혹은 사원번호가 발견된 경우
		if (resultVO != null && resultVO.getId() != null && !resultVO.getId().equals("")) {
			// 공유사서함 기능을 사용할 경우 공유사서함 계정으로의 로그인을 막는다.
			String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", tenantId);
			
			if (useSharedMailbox.equals("YES") && resultVO.getDeptID() != null && resultVO.getDeptID().startsWith("shared_mailbox_")) {
				logger.debug("Cannot login with shared mailbox account.");
			} else {
				// 사용자 ID를 사용해 로그인하는 경우
				if (id.equals(resultVO.getId())) {
					orgId = id;
					
				// 사원번호를 사용해 로그인하는 경우
				} else {
					// Check if his/her tenant allows using employeeID to login
					String useEmpNumberLogin = ezCommonService.getTenantConfig("UseEmpNumberLogin", tenantId);
					logger.debug("useEmpNumberLogin=" + useEmpNumberLogin);
					
					// 사원번호를 사용한 로그인을 허용하는 경우
					if (useEmpNumberLogin.equals("YES")) {
						orgId = resultVO.getId();
					}
				}
			}
		}
		
		logger.debug("getIdIfUserExists ended. orgId=" + orgId);
		return orgId;
	}
    
	private boolean checkIfUserExistsWithPassword(String id, String pw, int tenantId, HttpServletRequest request) throws Exception {
		logger.debug("checkIfUserExistsWithPassword started. id=" + id + ",tenantId=" + tenantId);
		
		boolean isUserExists = false;
		
		// Check if this user exists
		LoginVO loginVO = new LoginVO();	
		loginVO.setId(id);
		loginVO.setTenantId(tenantId);
		loginVO.setDn("NOPASSWORD");
		LoginVO resultVO = loginService.selectUser(loginVO);
		
		// 사용자 ID 혹은 사원번호가 발견된 경우
		if (resultVO != null && resultVO.getId() != null && !resultVO.getId().equals("")) {
			// 공유사서함 기능을 사용할 경우 공유사서함 계정으로의 로그인을 막는다.
			String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", tenantId);
			
			if (useSharedMailbox.equals("YES") && resultVO.getDeptID() != null && resultVO.getDeptID().startsWith("shared_mailbox_")) {
				logger.debug("Cannot login with shared mailbox account.");
			} else {
				// 사용자 ID를 사용해 로그인하는 경우
				if (id.equals(resultVO.getId())) {
					
					String useAD = ezCommonService.getTenantConfig("USE_AD", tenantId);
					logger.debug("useAD=" + useAD);
					
		            // AD를 사용하는 경우(MASTERADMIN 제외)
		            if (!id.equalsIgnoreCase("MASTERADMIN") && useAD.equalsIgnoreCase("YES")) {
		            	String chkADpass = loginService.chkADAndUpdatePassword(id, pw, tenantId);	            	
		            	
		            	if (chkADpass.equalsIgnoreCase("TRUE")) {
		            		isUserExists = true;
		            		
		            		String ip = ClientUtil.getClientIP(request);
		            		String agent = ClientUtil.getClientInfo(request, "agent");
		            		String os = ClientUtil.getClientInfo(request, "os");
		            		String browser = "uc messenger";
		            		logger.debug("ip=" + ip + ",agent=" + agent + ",os=" + os + ",browser=" + browser);
		            		
		    				loginVO.setIp(ip);
		    				
		    				//IP Address,  마지막 login시간 저장
		    				loginService.updateUser(loginVO);
		            		
		            		//접속 로그정보 저장
							resultVO.setIp(ip);
							resultVO.setAgent(agent);
							resultVO.setOs(os);
							resultVO.setBrowser(browser);
							resultVO.setTenantId(tenantId);
			
							if (resultVO.getTitle2() == null) {
								resultVO.setTitle2("");
							}
							
							loginService.insertLog(resultVO);
		            	}
		            	
		            // AD를 사용하지 않는 경우
		            } else {
		            	String encryptedPw = EgovFileScrty.encryptPassword(pw, id);
		            	
		        		loginVO.setId(id);
		        		loginVO.setPassword(encryptedPw);
		        		loginVO.setDn("PASSWORD");
		        		
		        		resultVO = loginService.selectUser(loginVO);
		        		logger.debug("resultVO=" + resultVO);
		        		
		        		if (resultVO != null && resultVO.getId() != null && !resultVO.getId().equals("")) { 
		        			isUserExists = true;
		        			
		        			String ip = ClientUtil.getClientIP(request);
		            		String agent = ClientUtil.getClientInfo(request, "agent");
		            		String os = ClientUtil.getClientInfo(request, "os");
		            		String browser = "uc messenger";
		            		logger.debug("ip=" + ip + ",agent=" + agent + ",os=" + os + ",browser=" + browser);
		            		
		    				loginVO.setIp(ip);
		    				
		    				//IP Address,  마지막 login시간 저장
		    				loginService.updateUser(loginVO);
		            		
		            		//접속 로그정보 저장
							resultVO.setIp(ip);
							resultVO.setAgent(agent);
							resultVO.setOs(os);
							resultVO.setBrowser(browser);
							resultVO.setTenantId(tenantId);
			
							if (resultVO.getTitle2() == null) {
								resultVO.setTitle2("");
							}
							
							loginService.insertLog(resultVO);
		        		}
		            }
					
				// 사원번호를 사용해 로그인하는 경우
				} else {
					
					// Check if his/her tenant allows using employeeID to login
					String useEmpNumberLogin = ezCommonService.getTenantConfig("UseEmpNumberLogin", tenantId);
					logger.debug("useEmpNumberLogin=" + useEmpNumberLogin);
					
					// 사원번호를 사용한 로그인을 허용하는 경우
					if (useEmpNumberLogin.equals("YES")) {
						
						// 실제 사용자 ID를 사용한다.
						id = resultVO.getId();
						
						// AD를 사용하는 경우(MASTERADMIN 제외)
						if (!id.equalsIgnoreCase("MASTERADMIN") && ezCommonService.getTenantConfig("USE_AD", tenantId).equalsIgnoreCase("YES")) {
			            	String chkADpass = loginService.chkADAndUpdatePassword(id, pw, tenantId);	            	
			            	
			            	if (chkADpass.equalsIgnoreCase("TRUE")) {
			            		isUserExists = true;
			            		
			            		String ip = ClientUtil.getClientIP(request);
			            		String agent = ClientUtil.getClientInfo(request, "agent");
			            		String os = ClientUtil.getClientInfo(request, "os");
			            		String browser = "uc messenger";
			            		logger.debug("ip=" + ip + ",agent=" + agent + ",os=" + os + ",browser=" + browser);
			            		
			    				loginVO.setIp(ip);
			    				
			    				//IP Address,  마지막 login시간 저장
			    				loginService.updateUser(loginVO);
			            		
			            		//접속 로그정보 저장
								resultVO.setIp(ip);
								resultVO.setAgent(agent);
								resultVO.setOs(os);
								resultVO.setBrowser(browser);
								resultVO.setTenantId(tenantId);
				
								if (resultVO.getTitle2() == null) {
									resultVO.setTitle2("");
								}
								
								loginService.insertLog(resultVO);
			            	}
			            	
			            // AD를 사용하지 않는 경우
						} else {
							String encryptedPw = EgovFileScrty.encryptPassword(pw, id);
							
				        	loginVO.setId(id);
				        	loginVO.setPassword(encryptedPw);
				            loginVO.setDn("PASSWORD");
				            
				            resultVO = loginService.selectUser(loginVO);
			        		logger.debug("resultVO=" + resultVO);
			        		
			        		if (resultVO != null && resultVO.getId() != null && !resultVO.getId().equals("")) { 
			        			isUserExists = true;
			        			
			        			String ip = ClientUtil.getClientIP(request);
			            		String agent = ClientUtil.getClientInfo(request, "agent");
			            		String os = ClientUtil.getClientInfo(request, "os");
			            		String browser = "uc messenger";
			            		logger.debug("ip=" + ip + ",agent=" + agent + ",os=" + os + ",browser=" + browser);
			            		
			    				loginVO.setIp(ip);
			    				
			    				//IP Address,  마지막 login시간 저장
			    				loginService.updateUser(loginVO);
			            		
			            		//접속 로그정보 저장
								resultVO.setIp(ip);
								resultVO.setAgent(agent);
								resultVO.setOs(os);
								resultVO.setBrowser(browser);
								resultVO.setTenantId(tenantId);
				
								if (resultVO.getTitle2() == null) {
									resultVO.setTitle2("");
								}
								
								loginService.insertLog(resultVO);
			        		}
						}
					}
				}
			}
		}
		
		logger.debug("checkIfUserExistsWithPassword ended.");
		return isUserExists;
	}
	
}
