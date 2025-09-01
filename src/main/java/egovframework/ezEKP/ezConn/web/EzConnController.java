package egovframework.ezEKP.ezConn.web;

import java.net.URLDecoder;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;
import java.util.Objects;
import java.util.Optional;
import java.util.TimeZone;

import javax.annotation.Resource;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.util.WebUtils;

import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezConn.util.EzConnUtil;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.user.login.web.LoginController;
import egovframework.let.utl.fcc.service.ClientUtil;
import egovframework.let.utl.fcc.service.CommonUtil;
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

	@Autowired
	private CommonUtil commonUtil;

	@Resource(name = "crypto")
	private EgovFileScrty egovFileScrty;
	
	@RequestMapping(value={
						"/ezConn/mailMain.do", "/ezConn/scheduleMain.do", "/ezConn/scheduleWrite.do",
						"/ezConn/admin/organMain.do", "/ezConn/admin/scheduleMain.do", "/ezConn/scheduleRead.do",
						"/ezConn/scheduleConfig.do", "/ezConn/mailConfig.do", "/ezConn/addressConfig.do",
						"/ezConn/scheduleReceiveAttendant.do", "/ezConn/scheduleReceiveMember.do",
						"/ezConn/portalMain.do", "/ezConn/admin/mailMain.do"
						})
	@ResponseBody
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
				// 2022-10-21 이사라 - 타임존에 + 기호가 없는 경우 추가 ex.235|09:00
				if (userTimeZone.indexOf("+") == -1) {
					String[] resetTimeZone = userTimeZone.split("|");
					userTimeZone = resetTimeZone[0].concat("|+").concat(resetTimeZone[1]);
				}
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
				if (!"masteradmin".equals(orgId) && params.length > 2) {
					OrganUserVO organUserVO = new OrganUserVO();	
					
					organUserVO.setTenantId(tenantId);
					organUserVO.setCn(resultVO.getId());
					
				    SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			        date.setTimeZone(TimeZone.getTimeZone("GMT"));
			        String nowDate = date.format(new Date()); 
			        organUserVO.setNowDate(nowDate);
					
					if (userType.equals("admin")) {
						// 전체 관리자 권한을 설정한다.
						organUserVO.setExtensionAttribute1("c=1;k=0;g=0;a=0;i=0;n=0;l=0;q=0;w=0;m=0;");
					} else if (userType.equals("comp_admin")) {
						// 회사 관리자 권한을 설정한다.
						organUserVO.setExtensionAttribute1("c=0;k=1;g=0;a=0;i=0;n=0;l=0;q=0;w=0;m=0;");
					} else if (userType.equals("dept_admin")) {
						// 부서 관리자 권한을 설정한다.
						organUserVO.setExtensionAttribute1("c=0;k=0;g=1;a=0;i=0;n=0;l=0;q=0;w=0;m=0;");
					} else {
						// 사용자 권한을 설정한다.
						organUserVO.setExtensionAttribute1("c=0;k=0;g=0;a=0;i=0;n=0;l=0;q=0;w=0;m=0;");
					}
					
					ezOrganAdminService.updateDBData_userPermission(organUserVO);
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
								
				// 2022-10-27 이사라 - 로그인 정보 저장
				if (commonUtil.isLoginCookieExists(request, response)) {
					Cookie loginCookie = WebUtils.getCookie(request, "loginCookie");
					String decryptedLoginCookie = egovFileScrty.decryptAES(loginCookie.getValue());

					if (!decryptedLoginCookie.split("///")[1].equals(orgId)) {
						commonUtil.updateLoginInfo(request, resultVO);
						loginController.createLoginCookie(resultVO.getId(), " ", " ", tenantId, request, response, resultVO.getDeptID(), resultVO.getCompanyID());
					}

				} else {
					commonUtil.updateLoginInfo(request, resultVO);
					loginController.createLoginCookie(resultVO.getId(), " ", " ", tenantId, request, response, resultVO.getDeptID(), resultVO.getCompanyID());
				}

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
					String target = request.getParameter("target");
					String strImgCount = "";
					String docType = request.getParameter("doctype") != null ? request.getParameter("doctype") : ""; // 2022-10-07 이사라 - 전자결재G 웹한글기안기 문서의 경우 doctype=hwp로 호출
					
					if ("APPROVALG".equalsIgnoreCase(target)) {
						resultPage = "/ezEmail/mailWrite.do?docHref=IMAGE&cmd=" + cmd + "&docID=" + docID + "&imageCnt=" + strImgCount + "&target=APPROVALG"  + "&docType=" + docType;
					} else {
						resultPage = "/ezEmail/mailWrite.do?docHref=IMAGE&cmd=" + cmd + "&docID=" + docID + "&imageCnt=" + strImgCount + "&target=APPROVAL" + "&docType=" + docType;
					}
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
				} else if (requestUri.equals("/ezConn/addressConfig.do")) {
					resultPage = "/ezEmail/mailConfig.do?flag=address";					
				} else if (requestUri.equals("/ezConn/mailConfig.do")) {
					resultPage = "/ezEmail/mailConfig.do?flag=email&dotnetFlag=yes";					
				} else if (cmd != null && cmd.equals("mailRead")) {
					String mailFullPath = request.getParameter("mailFullPath");
					// 2022-10-11 이사라 - 포틀릿에서 메일을 클릭하여 읽을 때 지원하지 않는 옵션 제외
					String pnFlag = request.getParameter("pnFlag") != null ? request.getParameter("pnFlag") : "Y";
					resultPage = "/ezEmail/mailRead.do?PNFlag=" + pnFlag + "&CONTENTCLASS=IPM.Note&URL=" + URLEncoder.encode(mailFullPath, "UTF-8");
				} else if (requestUri.equals("/ezConn/portalMain.do")) {
					resultPage = "/ezNewPortal/newPortalMain.do";
				} else if (requestUri.equals("/ezConn/scheduleMain.do")) {
					resultPage = "/ezSchedule/scheduleIndex.do?funCode=2";
				} else if (requestUri.equals("/ezConn/scheduleWrite.do")) {
					resultPage = "/ezSchedule/scheduleWrite.do?defaultid=0";
				} else if (requestUri.equals("/ezConn/admin/mailMain.do")) {
					resultPage = "/admin/ezEmail/adminMailMain.do";
				} else if (requestUri.equals("/ezConn/admin/organMain.do")) {
					resultPage = "/admin/ezOrgan/organMain.do";
				} else if (requestUri.equals("/ezConn/admin/scheduleMain.do")) {
					resultPage = "/admin/ezSchedule/scheduleMain.do";
				} else if (requestUri.equals("/ezConn/scheduleRead.do")) {
					String date = request.getParameter("date");
					String repeatcount = request.getParameter("repeatcount"); // 일반일정 : 0 , 반복일정 : 반복회차
					String scheduleid = request.getParameter("scheduleid");
					
					resultPage = "/ezSchedule/scheduleRead.do?id=" + scheduleid + "&date=" + date + "&repeatcount=" + repeatcount;
				} else if (requestUri.equals("/ezConn/scheduleConfig.do")) {
					resultPage = "/ezSchedule/scheduleConfigMain.do?flag=schedule";
				} else if (requestUri.equals("/ezConn/scheduleReceiveAttendant.do")) {
					String serverFlag = request.getParameter("serverFlag");
					resultPage = "/ezSchedule/scheduleReceiveAttendant.do?serverFlag=" + serverFlag;
				} else if (requestUri.equals("/ezConn/scheduleReceiveMember.do")) {
					String serverFlag = request.getParameter("serverFlag");
					resultPage = "/ezSchedule/scheduleReceiveMember.do?serverFlag=" + serverFlag;
				} else {																
					String funCode = request.getParameter("funCode") != null ? request.getParameter("funCode") : "";
					if(funCode.equalsIgnoreCase("")) {
						String subCode = "1";
						if (request.getParameter("subCode") != null) {
							subCode = request.getParameter("subCode");
						}
						resultPage = "/ezEmail/mailMain.do?subCode=" + subCode;
					} else { // 20181218 조진호 - 개인화포탈시 주소록 탑메뉴로 분리
						resultPage = "/ezEmail/mailMain.do?funCode=" + funCode;
					}
				}
			}
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("mailMain ended.");
		
		// CWE-113 보안 취약점 대응
		response.sendRedirect(resultPage.replaceAll("\r", "").replaceAll("\n", ""));
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

	@RequestMapping(value="/ezConn/loginFromTeams.do", method={RequestMethod.GET})
	public String loginFromTeams(@RequestParam String type, ModelMap model) throws Exception {
		model.addAttribute("type", type);
		
		return "/ezConn/loginFromTeams";
	}

	@RequestMapping(value="/ezConn/loginForTeams.do", method={RequestMethod.GET})
	@ResponseBody
	public void loginForTeams(
			@RequestParam String id,
			@RequestParam String cmd,
			HttpServletRequest request,
			HttpServletResponse response
	) throws Exception {
		logger.debug("loginForTeams started. id={},cmd={}", id, cmd);

		String resultPage = "";

		try {
			if (Optional.ofNullable(id).orElse("").isEmpty()) {
				return;	
			}
			
			String[] params = id.split("@");

			String orgId = params[0].toLowerCase();

			logger.debug("orgId=" + orgId);

			String serverName = request.getServerName();
			int serverPort = request.getServerPort();
			int tenantId = loginService.getTenantId(serverName);

			logger.debug("serverName=" + serverName + ",serverPort=" + serverPort + ",tenantId=" + tenantId);

			boolean isUserExists = false;

			LoginVO	resultVO = getUserInfo(orgId, "", tenantId);

			if (resultVO != null && resultVO.getId() != null && !resultVO.getId().equals("")) {
				isUserExists = true;
			}

			logger.debug("isUserExists=" + isUserExists);

			if (isUserExists) {
				// 2022-10-27 이사라 - 로그인 정보 저장
				if (commonUtil.isLoginCookieExists(request, response)) {
					Cookie loginCookie = WebUtils.getCookie(request, "loginCookie");
					String decryptedLoginCookie = commonUtil.getDecryptedLoginCookie(loginCookie != null ? loginCookie.getValue() : "");

					if (!decryptedLoginCookie.split("///")[1].equals(orgId)) {
						commonUtil.updateLoginInfo(request, resultVO);
						loginController.createLoginCookie(resultVO.getId(), " ", " ", tenantId, request, response, resultVO.getDeptID(), resultVO.getCompanyID());
					}

				} else {
					commonUtil.updateLoginInfo(request, resultVO);
					loginController.createLoginCookie(resultVO.getId(), " ", " ", tenantId, request, response, resultVO.getDeptID(), resultVO.getCompanyID());
				}

				// IE, Safari의 경우 기존 사이트에서 iframe으로 ezEKP를 연동할 경우
				// 보안 문제로 쿠키 정보가 유실되는 현상이 발생해 다음 헤더를 추가함
				response.setHeader("P3P", "CP=\"Potato\"");
				
				if (cmd.equals("approval")) {
					resultPage = "/ezApprovalG/apprGMain.do";
				} else if (cmd.equals("board")) {
					resultPage ="/ezBoard/boardMain.do";
				} else if (cmd.equals("orgChart")) {
					resultPage = "/ezOrgan/organMain.do";
				}
			}
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}

		logger.debug("loginForTeams ended.");

		// CWE-113 보안 취약점 대응
		response.sendRedirect(resultPage.replaceAll("\r", "").replaceAll("\n", ""));
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
						loginController.createLoginCookie(resultVO.getId(), "", "", tenantId, request, response,"","");
						
						// IE, Safari의 경우 기존 사이트에서 iframe으로 ezEKP를 연동할 경우
						// 보안 문제로 쿠키 정보가 유실되는 현상이 발생해 다음 헤더를 추가함
						response.setHeader("P3P", "CP=\"Potato\"");
						
						resultPage = "redirect:/ezApprovalG/apprGMain.do";
					}
				}
			}
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
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
		
		// 공유사서함 기능을 사용할 경우 공유사서함 계정으로의 로그인을 막는다.
		String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", tenantId);
		
		if (useSharedMailbox.equals("YES")) {
			if (resultVO != null && resultVO.getDeptID() != null && resultVO.getDeptID().startsWith("shared_mailbox_")) {
				logger.debug("Cannot login with shared mailbox account.");
				
				resultVO = null;
			}
		}
		
		// 2023-05-15 이사라 : NullPointerException 시큐어코딩 - vo null체크로 수정
		//if (resultVO.getId() != null) {
		if (!Objects.isNull(resultVO)) {
			logger.debug("getUserInfoById ended. resultVO.id=" + resultVO.getId());
		} else {
			logger.debug("getUserInfoById ended. resultVO.id=null");			
		}		
		
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

	@RequestMapping("/ezConn/changeLoginCnt.do")
	@ResponseBody
	public String changeLoginCnt(HttpServletRequest request, HttpServletResponse response) {
		logger.debug("changeLoginCnt started.");
		String result = "ERROR";

		try {
			String id = request.getParameter("id");
			id = ezConnUtil.decryptAES(id);
			logger.debug("id=" + id);

			String cn = id.split(":")[0];
			int tenantID = 0;

			ezOrganAdminService.resetLoginCnt(cn, tenantID);

			result = "OK";
		} catch (Exception e) {
			result = "ERROR";
		}

		logger.debug("changeLoginCnt ended. result=" + result);
		return result;
	}
	
	/**
	 * 자체 방식 SSO를 위한 암호화된 인증 스트링을 반환한다. 암호화된 인증 스트링을 전달 받은
	 * 타시스템에서는 복호화한 뒤 사용자 아이디가 존재하는 경우 로그인 과정을 수행한다.(인사연동 및 키공유 필요)
	 * 인증 스트링 구성 = 부서아이디:사용자아이디:타임스탬프:사용자종류
	 * 타임스탬프 형식 = yyyyMMddHHmmss
	 * 사용자종류 형식 = admin(관리자) or user(일반사용자)
	 * @param userId
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value="/ezAuth/getSSOAuthString.do", method=RequestMethod.GET)
	@ResponseBody
	public String getSSOAuthString(@RequestParam String userId, HttpServletRequest request, HttpServletResponse response) {
		logger.debug("getSSOAuthString started. userId=" + userId);
		
		boolean isUserExists = false;
		String result = "ERROR";
		
		try {			
			String serverName = request.getServerName();
	        int tenantId = loginService.getTenantId(serverName);
	        
	        logger.debug("serverName=" + serverName + ",tenantId=" + tenantId);

			LoginVO user = getUserInfoById(userId, tenantId);
			
			if (user != null && user.getId() != null && !user.getId().equals("")) { 
				isUserExists = true;
			} 
			
			logger.debug("isUserExists=" + isUserExists);
			
			if (isUserExists) {			
			    SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
		        String nowDate = sdf.format(new Date()); 
		        String roleInfo = user.getRollInfo();
		        String userType = "user";
				
		        if (roleInfo.indexOf("c=1") != -1 || roleInfo.indexOf("k=1") != -1) {
		        	userType = "admin";
		        }
		        
				String authString = user.getDeptID() + ":" + userId + ":" + nowDate + ":" + userType;
				
				logger.debug("authString=" + authString);
				
				result = ezConnUtil.encryptAES(authString);
			}						
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("getSSOAuthString ended. result=" + result);
		
		return result;
	}
	
	/**
	 * 암호화된 자체 방식 SSO 인증 스트링을 전달 받아 복화화해 사용자를 확인한 후 로그인 처리를 수행한다.
	 * 로그인 처리 후 지정된 URL로 이동한다.
	 * @param id 암호화된 자체 SSO 인증 스트링
	 * @param redirectUrl 로그인 처리 후 이동할 URL
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value="/ezConn/loginWithSSOAuthString.do", method = RequestMethod.GET)
	public String loginWithSSOAuthString(@RequestParam String id, @RequestParam String redirectUrl, HttpServletRequest request, HttpServletResponse response) {
		logger.debug("loginWithSSOAuthString started. id=" + id + ",redirectUrl=" + redirectUrl);		
		
		String resultPage = "";
		
		try {
			if (id != null && !id.isEmpty() && redirectUrl != null && !redirectUrl.isEmpty()) {
				id = ezConnUtil.decryptAES(id);
				
				logger.debug("decryptedId=" + id);
				
				String[] params = id.split(":");
				
				if (params.length >= 4) {
					String userId = params[1];
					String timeStamp = params[2];
					String userType = params[3];
					
					String serverName = request.getServerName();
					int tenantId = loginService.getTenantId(serverName);
					
					logger.debug("userId=" + userId + ",timeStamp=" + timeStamp + ",userType=" + userType + ",tenantId=" + tenantId + ",serverName=" + serverName);
					
					SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
					Date creationTime = sdf.parse(timeStamp);
					Date currentTime = new Date();
					long timeDiff = currentTime.getTime() - creationTime.getTime();
					
					logger.debug("timeDiff=" + timeDiff);
					
					// 인증 스트링이 생성된지 60초이내일 때만 유효한 것으로 처리한다.
					if (timeDiff <= 60*1000) {		
						logger.debug("timeStamp is valid");
						
						LoginVO user = getUserInfoById(userId, tenantId);
						
						if (user != null && user.getId() != null && !user.getId().equals("")) { 
							// 2021-12-29 이사라 : 세션코드 입력 추가
							String sessionCode = request.getSession().getId();
							logger.debug("timeStamp vailable, sessionCode : " + sessionCode);
							user.setSessionCode(sessionCode);
							user.setIp(ClientUtil.getClientIP(request));
							user.setAgent(ClientUtil.getClientInfo(request, "agent"));
							user.setOs(ClientUtil.getClientInfo(request, "os"));
							user.setBrowser(ClientUtil.getClientInfo(request, "browser"));
							user.setTenantId(tenantId);
							user.setStatus("Y");
							
							// sso 접속시에도 로그인 이력 남도록 추가 
							// 2023-05-23 이사라 - 로그인 정보 저장
							if (commonUtil.isLoginCookieExists(request, response)) {
								Cookie loginCookie = WebUtils.getCookie(request, "loginCookie");
								String decryptedLoginCookie = commonUtil.getDecryptedLoginCookie(loginCookie.getValue());

								if (!decryptedLoginCookie.split("///")[1].equals(userId)) {
									commonUtil.updateLoginInfo(request, user);
								}

							} else {
								commonUtil.updateLoginInfo(request, user);
							}
														
							loginController.createLoginCookie(user.getId(), "", "", tenantId, request, response, user.getDeptID(), user.getCompanyID());
						
							resultPage = "redirect:" + redirectUrl;
						}
					} else {
						logger.debug("timeStamp expired");
						// 2021-12-28 이사라 : 로그인 실패 시 이력 남도록 추가 
						LoginVO user = getUserInfoById(userId, tenantId);
						
						if (user != null && user.getId() != null && !user.getId().equals("")) { 
							user.setIp(ClientUtil.getClientIP(request));
							user.setAgent(ClientUtil.getClientInfo(request, "agent"));
							user.setOs(ClientUtil.getClientInfo(request, "os"));
							user.setBrowser(ClientUtil.getClientInfo(request, "browser"));
							user.setTenantId(tenantId);
							user.setStatus("N");
							 
							loginService.insertLog(user);
						}
					}
				}
			}
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("loginWithSSOAuthString ended.");
		
		return resultPage;
	}
	
	@RequestMapping(value="/ezConn/oms/moduleMonitor.do", method = RequestMethod.GET)
	public String cloudOrgan(HttpServletRequest request, HttpServletResponse response) {
		String resultPage = "";
		
		try {
			String id = "masteradmin";
			logger.debug("id=" + id);
			
			if (id != null && !id.equals("")) {
				int atSignPos = id.indexOf("@");
				
				if (atSignPos != -1) {
					id = id.substring(0, atSignPos);
				}
				
				if (!id.equals("")) {
					String serverName = request.getServerName();
					int tenantId = loginService.getTenantId(serverName);
					
					logger.debug("tenantId=" + tenantId + ", serverName=" + serverName);
					
					LoginVO resultVO = getUserInfoById(id, tenantId);
					
					// 2023-05-16 이사라 : NullPointerException 시큐어코딩
					if (Objects.isNull(resultVO)) {
						throw new NullPointerException("cloudOrgan resultVO is null");
					}

					loginController.createLoginCookie(resultVO.getId(), "", "", tenantId, request, response, "", "");
					
					// IE, Safari의 경우 기존 사이트에서 iframe으로 ezEKP를 연동할 경우
					// 보안 문제로 쿠키 정보가 유실되는 현상이 발생해 다음 헤더를 추가함
					response.setHeader("P3P", "CP=\"Potato\"");
					
					resultPage = "redirect:/admin/ezSystem/getModuleMonitor.do";
					
				}
			}
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		
		return resultPage;
	}

	/**
	 * 외부메일가는 url반환하기 위한 작업
	 */
	@RequestMapping(value="/ezAuth/getSSORedirectUrl.do", method=RequestMethod.GET)
	@ResponseBody
	public String getSSORedirectUrl(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request) {
		logger.debug("getSSORedirectUrl started. ");

		String result = "ERROR";

		userInfo = commonUtil.userInfo(loginCookie);

		String redircetDomain = request.getParameter("redirectDomain");
		String redircetResource = request.getParameter("redirectResource");

		try {
			SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
			String nowDate = sdf.format(new Date());
			String roleInfo = userInfo.getRollInfo();
			String userType = "user";

			if (roleInfo.indexOf("c=1") != -1 || roleInfo.indexOf("k=1") != -1) {
				userType = "admin";
			}

			String authString = userInfo.getDeptID() + ":" + userInfo.getId() + ":" + nowDate + ":" + userType;

			logger.debug("authString=" + authString);
			result = redircetDomain + "/ezConn/loginWithSSOAuthString.do?id=";
			result += URLEncoder.encode(ezConnUtil.encryptAES(authString));
			result += "&redirectUrl=" + redircetResource;

		} catch (Exception e) {
			e.printStackTrace();
		}

		logger.debug("getSSORedirectUrl ended. result=" + result);

		return result;
	}
}
