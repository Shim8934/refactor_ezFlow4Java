package egovframework.ezEKP.ezConn.web;

import java.net.URLDecoder;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.TimeZone;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezConn.util.EzConnUtil;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.user.login.web.LoginController;
import egovframework.let.utl.sim.service.EgovFileScrty;

/**
 * 
 * @Description 닷넷 그룹웨어에서 ezEKP 그룹웨어 연동 관련 호출하는 URL 처리를 수행하는 클래스
 * @author skyblue0o0
 *
 */
@Controller
public class EzConnController {

	private static final Logger logger = LoggerFactory.getLogger(EzConnController.class);
	
	@Autowired
	private EzConnUtil ezConnUtil;
	
	@Resource(name = "loginService")
    private LoginService loginService;
	
	@Autowired
	private LoginController loginController;
	
	@Autowired
	private EzOrganAdminService ezOrganAdminService;
	
    @Resource(name="EzCommonService")
	private EzCommonService ezCommonService;
	
	@RequestMapping(value={
						"/ezConn/mailMain.do", "/ezConn/scheduleMain.do",
						"/ezConn/admin/organMain.do", "/ezConn/admin/scheduleMain.do"
						})
	public void mailMain(
					@RequestParam String id,
					HttpServletRequest request,
					HttpServletResponse response
					) throws Exception {
		logger.debug("mailMain started.");
		
		String resultPage = "";
		
		try {
			id = ezConnUtil.decryptAES(id);
			
			String[] params = id.split(":");
			
			String orgId = params[0].toLowerCase();
			String orgPw = params[1];
			
			String userType = "user";
			String userLang = "1";
			String userTimeZone = "235|+09:00";
			
			if (params.length > 2) {
				// 관리자 권한일 때는 admin, 사용자 권한일 때는 user가 전달됨
				userType = params[2];
			}
			
			if (params.length > 3) { 
				userLang = params[3];
			}

			if (params.length > 4) {
				// 235|+09:00 와 같은 형식으로 전달되며 :이 구분자로 사용되는 관계로 URL Encoding 되어 전달되어야 한다.
				userTimeZone = URLDecoder.decode(params[4], "UTF-8");
			}
						
			logger.debug("orgId=" + orgId + ",params.length=" + params.length + ",userType="
					+ userType + ",userLang=" + userLang + ",userTimeZone=" + userTimeZone);
			
			String serverName = request.getServerName();
	        int serverPort = request.getServerPort();
	        int tenantId = loginService.getTenantId(serverName);
	        
	        logger.debug("serverName=" + serverName + ",serverPort=" + serverPort + ",tenantId=" + tenantId);
			
			boolean isUserExists = false;
			
			LoginVO	resultVO = getUserInfo(orgId, orgPw, tenantId);
			
			if (resultVO != null && resultVO.getId() != null && !resultVO.getId().equals("")) { 
				isUserExists = true;
			} 
			
			logger.debug("isUserExists=" + isUserExists);
			
			if (isUserExists) {
				if (params.length > 2) {
					OrganUserVO organUserVO = new OrganUserVO();	
					
					organUserVO.setTenantId(tenantId);
					organUserVO.setCn(resultVO.getId());
					
				    SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			        date.setTimeZone(TimeZone.getTimeZone("GMT"));
			        String nowDate = date.format(new Date()); 
			        organUserVO.setNowDate(nowDate);
					
					if (userType.equals("admin")) {
						// 전체 관리자 권한을 설정한다.
						organUserVO.setExtensionAttribute1("c=1;k=0;g=0;a=0;i=0;n=0;l=0;f=0;w=0;m=0;");
					} else if (userType.equals("dept_admin")) {
						// 부서 관리자 권한을 설정한다.
						organUserVO.setExtensionAttribute1("c=0;k=0;g=1;a=0;i=0;n=0;l=0;f=0;w=0;m=0;");
					} else {
						// 사용자 권한을 설정한다.
						organUserVO.setExtensionAttribute1("c=0;k=0;g=0;a=0;i=0;n=0;l=0;f=0;w=0;m=0;");
					}
					
					ezOrganAdminService.updateDBData_user(organUserVO);
				}
				
				if (params.length > 4) {
					try {
						// 이미 사용자 레코드가 있으면 Exception이 발생한다.
						ezCommonService.insertTblUserLocalInfo(resultVO.getId(), userTimeZone, userLang, tenantId);
					} catch (Exception e) {
						LoginVO userInfo = new LoginVO();
						
						userInfo.setId(resultVO.getId());
						userInfo.setTenantId(tenantId);
						userInfo.setOffset(userTimeZone);
						userInfo.setLang(userLang);		
						
						// Exception이 발생하면 업데이트로 다시 시도해 본다.
						ezCommonService.saveUserLocalInfo(userInfo.getId(), userInfo);
					}
				}
								
				loginController.createLoginCookie(resultVO.getId(), " ", " ", tenantId, request, response);
				
				// IE, Safari의 경우 기존 사이트에서 iframe으로 ezEKP를 연동할 경우
				// 보안 문제로 쿠키 정보가 유실되는 현상이 발생해 다음 헤더를 추가함
				response.setHeader("P3P", "CP=\"Potato\"");
				
				String cmd = request.getParameter("cmd");
				
				logger.debug("cmd=" + cmd);
				
				String requestUri = request.getRequestURI();
				
				logger.debug("requestUri=" + requestUri);
				
				if (cmd != null && cmd.equals("boardDotNet")) {
					String boardID = request.getParameter("boardID");
					String itemID = request.getParameter("itemID");
					
					resultPage = "/ezEmail/mailWrite.do?boardID=" + boardID + "&itemID=" + itemID + "&cmd=boardDotNet";
				} else if (cmd != null && cmd.equals("docsendDotNet")) {
					String docID = request.getParameter("docID");
					String strImgCount = "";
					
					resultPage = "/ezEmail/mailWrite.do?docHref=IMAGE&cmd=" + cmd + "&docID=" + docID + "&imageCnt=" + strImgCount + "&target=APPROVALG";
				} else if (cmd != null && cmd.equals("CommunityDotNet")) {
					String boardID = request.getParameter("boardID");
					String itemID = request.getParameter("itemID");
					
					resultPage = "/ezEmail/mailWrite.do?boardID=" + boardID + "&itemID=" + itemID + "&cmd=CommunityDotNet";
				} else if (cmd != null && cmd.equals("mailWrite")) {
					String emailAddress = request.getParameter("emailAddress") == null ? "" : request.getParameter("emailAddress");
					String name = request.getParameter("name") == null ? "" : request.getParameter("name");
					
					if (!emailAddress.equals("")) {
						name = name.equals("") ? emailAddress : name;
						String msgTo = String.format("%s <%s>", name, emailAddress);
						
						logger.debug("msgTo=" + msgTo);
						
						resultPage = "/ezEmail/mailWrite.do?cmd=NEW&msgto=" + URLEncoder.encode(msgTo, "UTF-8");
					} else {
						resultPage = "/ezEmail/mailWrite.do?cmd=NEW";
					}					
				} else if (cmd != null && cmd.equals("addressWrite")) {
					resultPage = "/ezAddress/addressWrite.do";					
				} else if (cmd != null && cmd.equals("mailRead")) {
					String mailFullPath = request.getParameter("mailFullPath");
					
					resultPage = "/ezEmail/mailRead.do?URL=" + URLEncoder.encode(mailFullPath, "UTF-8");
				} else if (requestUri.equals("/ezConn/scheduleMain.do")) {
					resultPage = "/ezSchedule/scheduleIndex.do?funCode=2";
				} else if (requestUri.equals("/ezConn/admin/organMain.do")) {
					resultPage = "/admin/ezOrgan/organMain.do";
				} else if (requestUri.equals("/ezConn/admin/scheduleMain.do")) {
					resultPage = "/admin/ezSchedule/scheduleMain.do";
				} else {																
					String subCode = "1";
					
					if (request.getParameter("subCode") != null) {
						subCode = request.getParameter("subCode");
					}
					
					resultPage = "/ezEmail/mailMain.do?subCode=" + subCode;
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		logger.debug("mailMain ended.");
		
		response.sendRedirect(resultPage);
	}
	
	private LoginVO getUserInfo(String id, String pw, int tenantId) throws Exception {
		logger.debug("checkIfUserExists started. id=" + id + ",tenantId=" + tenantId);
				
//		String encryptedPw = EgovFileScrty.encryptPassword(pw, id);
		
//		logger.debug("encryptedPw=" + encryptedPw);
		
		LoginVO loginVO = new LoginVO();	
		
		loginVO.setId(id);
		loginVO.setTenantId(tenantId);
		loginVO.setDn("NOPASSWORD");		
		
		LoginVO	resultVO = loginService.selectUser(loginVO);			
		
		logger.debug("resultVO=" + resultVO);
				
		logger.debug("checkIfUserExists ended.");
		
		return resultVO;
	}	
    
	@RequestMapping("/ezConn/approvalMain.do")
	public String approvalMain(
					@RequestParam String id,
					HttpServletRequest request,
					HttpServletResponse response
					) throws Exception {
		logger.debug("approvalMain started.");
		String resultPage = "redirect:/user/login/login.do";
		
		try {
			logger.debug("id=" + id);

			if (id != null && !id.equals("")) {
				int atSignPos = id.indexOf("@");
				
				if (atSignPos != -1) {
					id = id.substring(0, atSignPos);
				}
				
				if (!id.equals("")) {
			        int tenantId = 0;
			        
			        logger.debug("tenantId=" + tenantId);
					
					boolean isUserExists = false;
					
					LoginVO resultVO = getUserInfoById(id, tenantId);
					
					if (resultVO != null && resultVO.getId() != null && !resultVO.getId().equals("")) { 
						isUserExists = true;
					} 
					
					logger.debug("isUserExists=" + isUserExists);
					
					if (isUserExists) {
						loginController.createLoginCookie(resultVO.getId(), "", "", tenantId, request, response);
						
						// IE, Safari의 경우 기존 사이트에서 iframe으로 ezEKP를 연동할 경우
						// 보안 문제로 쿠키 정보가 유실되는 현상이 발생해 다음 헤더를 추가함
						response.setHeader("P3P", "CP=\"Potato\"");
						
						resultPage = "redirect:/ezApprovalG/apprGMain.do";
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		logger.debug("approvalMain ended.");
		
		return resultPage;
	}
	
	private LoginVO getUserInfoById(String id, int tenantId) throws Exception {
		logger.debug("getUserInfoById started. id=" + id + ",tenantId=" + tenantId);
						
		LoginVO loginVO = new LoginVO();	
		
		loginVO.setId(id);
		loginVO.setDn("NOPASSWORD");
		loginVO.setTenantId(tenantId);
		
		LoginVO resultVO = loginService.selectUser(loginVO);
		
		logger.debug("resultVO=" + resultVO);
				
		logger.debug("getUserInfoById ended.");
		
		return resultVO;
	}	
	
	@RequestMapping("/ezConn/changePassword.do")
	@ResponseBody
	public String changePassword(HttpServletRequest request, HttpServletResponse response) {
		logger.debug("changePassword started.");
		String result = "ERROR";
		
		try {
			String id = request.getParameter("id");
			id = ezConnUtil.decryptAES(id);
			logger.debug("id=" + id);
			
			String cn = id.split(":")[0];
			String password = id.split(":")[1];
			int tenantID = 0;
			String domain = ezCommonService.getTenantConfig("DomainName", tenantID);
			
			ezOrganAdminService.setPasswordWithEmailSystem(cn, domain, password, tenantID);
			
			result = "OK";
		} catch (Exception e) {
			result = "ERROR";
		}
		
		logger.debug("changePassword ended. result=" + result);
		return result;
	}
}
