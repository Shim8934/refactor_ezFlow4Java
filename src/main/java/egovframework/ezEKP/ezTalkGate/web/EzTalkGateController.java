package egovframework.ezEKP.ezTalkGate.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import egovframework.ezEKP.ezTalkGate.util.EzTalkGateUtil;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.user.login.web.LoginController;
import egovframework.let.utl.sim.service.EgovFileScrty;

/**
 * 
 * @Description 비즈메카톡 메신저에서 ezEKP 그룹웨어 연동 관련 호출하는 URL 처리를 수행하는 클래스
 * @author dhlee
 *
 */
@Controller
public class EzTalkGateController {

	private static final Logger logger = LoggerFactory.getLogger(EzTalkGateController.class);
	
	@Autowired
	private EzTalkGateUtil ezTalkGateUtil;
	
	@Resource(name = "loginService")
    private LoginService loginService;
	
	@Autowired
	private LoginController loginController;
	
	@RequestMapping("/ezTalkGate/main.do")
	public String ezTalkGateMain(
					@RequestParam String ezTalkId,
					@RequestParam String ezTalkPw,
					@RequestParam String ezTalkSsoType,
					HttpServletRequest request,
					HttpServletResponse response
					) throws Exception {
		String orgId = ezTalkGateUtil.decryptEzTalkAES(ezTalkId);
		String orgPw = ezTalkGateUtil.decryptEzTalkAES(ezTalkPw); 
		
		logger.debug("orgId=" + orgId + ",ezTalkSsoType=" + ezTalkSsoType);
		
        String serverName = request.getServerName();
        int serverPort = request.getServerPort();
        int tenantId = loginService.getTenantId(serverName);
        
        logger.debug("serverName=" + serverName + ",serverPort=" + serverPort + ",tenantId=" + tenantId);
		
		boolean isUserExists = checkIfUserExists(orgId, orgPw, tenantId);
		
		logger.debug("isUserExists=" + isUserExists);
		
		if (isUserExists) {
			String encryptedPw = EgovFileScrty.encryptPassword(orgPw, orgId);
			
			loginController.createLoginCookie(orgId, orgPw, encryptedPw, tenantId, request, response);
			
			if (ezTalkSsoType.equals("mail")) {
				return "redirect:/ezEmail/mailList.do";
			} else if (ezTalkSsoType.equals("approval")) { 
				return "redirect:/ezApprovalG/aprManage.do?listType=1&subQuery=";
			} else if (ezTalkSsoType.equals("portal")) { 
				return "redirect:/ezPortal/portalMain.do";
			} else {
				return "";
			}
		} else {
			return "redirect:/user/login/login.do";
		}
	}
	
	private boolean checkIfUserExists(String id, String pw, int tenantId) throws Exception {
		boolean isUserExists = false;
		
		String encryptedPw = EgovFileScrty.encryptPassword(pw, id);
		
		logger.debug("encryptedPw=" + encryptedPw);
		
		LoginVO loginVO = new LoginVO();	
		
		loginVO.setId(id);
		loginVO.setPassword(encryptedPw);
		loginVO.setTenantId(tenantId);
		
		LoginVO resultVO = loginService.selectUser(loginVO);
		
		logger.debug("resultVO=" + resultVO);
		
		if (resultVO != null && resultVO.getId() != null && !resultVO.getId().equals("")) { 
			isUserExists = true;
		} 
		
		return isUserExists;
	}	
    
}
