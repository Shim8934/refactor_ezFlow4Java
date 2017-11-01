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

import egovframework.ezEKP.ezUCMessenger.util.EzUCMessengerUtil;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.user.login.web.LoginController;
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
			String timestamp = id.split(":")[2];
			
			logger.debug("orgId=" + orgId + ",timestamp=" + timestamp);
			
			String serverName = request.getServerName();
	        int serverPort = request.getServerPort();
	        int tenantId = loginService.getTenantId(serverName);
	        logger.debug("serverName=" + serverName + ",serverPort=" + serverPort + ",tenantId=" + tenantId);
			
			boolean isUserExists = checkIfUserExists(orgId, orgPw, tenantId);
			logger.debug("isUserExists=" + isUserExists);
			
			if (isUserExists) {
				result = "TRUE";
			}
		} catch (Exception e) {
			result = "FALSE";
			e.printStackTrace();
		}
		
		PrintWriter writer = response.getWriter();
		
		writer.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
		writer.println("<login_check>");
		writer.printf("<result>%s</result>", result);
		writer.println();
		writer.println("<cause></cause>");
		writer.println("</login_check>");
		
		writer.flush();
		writer.close();
		
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
		System.out.println(id);
		id = ezUCMessengerUtil.decryptAES(id);
		
		String orgId = id.split(":")[0];
		String orgPw = id.split(":")[1];
		String timestamp = id.split(":")[2];
		logger.debug("orgId=" + orgId + ",timestamp=" + timestamp + ",type=" + type);
		
        String serverName = request.getServerName();
        int serverPort = request.getServerPort();
        int tenantId = loginService.getTenantId(serverName);
        logger.debug("serverName=" + serverName + ",serverPort=" + serverPort + ",tenantId=" + tenantId);
		
		boolean isUserExists = checkIfUserExists(orgId, orgPw, tenantId);
		logger.debug("isUserExists=" + isUserExists);
		
		String redirectUrl = "redirect:/user/login/login.do";
		if (isUserExists) {
			String encryptedPw = EgovFileScrty.encryptPassword(orgPw, orgId);
			loginController.createLoginCookie(orgId, orgPw, encryptedPw, tenantId, request, response);
			
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
	
	private boolean checkIfUserExists(String id, String pw, int tenantId) throws Exception {
		logger.debug("checkIfUserExists started. id=" + id + ",tenantId=" + tenantId);
		
		boolean isUserExists = false;
		String encryptedPw = EgovFileScrty.encryptPassword(pw, id);
		
		LoginVO loginVO = new LoginVO();	
		
		loginVO.setId(id);
		loginVO.setTenantId(tenantId);
		loginVO.setPassword(encryptedPw);
		
		LoginVO resultVO = loginService.selectUser(loginVO);
		logger.debug("resultVO=" + resultVO);
		
		if (resultVO != null && resultVO.getId() != null && !resultVO.getId().equals("")) { 
			isUserExists = true;
		}
		
		logger.debug("checkIfUserExists ended.");
		return isUserExists;
	}	
    
}
