package egovframework.ezEKP.ezConn.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import egovframework.ezEKP.ezConn.util.EzConnUtil;
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
	
	@RequestMapping("/ezConn/mailMain.do")
	public String mailMain(
					@RequestParam String id,
					HttpServletRequest request,
					HttpServletResponse response
					) throws Exception {
		logger.debug("mailMain started.");
		String resultPage = "redirect:/user/login/login.do";
		
		try {
			id = ezConnUtil.decryptAES(id);
			
			String orgId = id.split(":")[0];
			String orgPw = id.split(":")[1];
			
			logger.debug("orgId=" + orgId);
			
			String serverName = request.getServerName();
	        int serverPort = request.getServerPort();
	        int tenantId = loginService.getTenantId(serverName);
	        logger.debug("serverName=" + serverName + ",serverPort=" + serverPort + ",tenantId=" + tenantId);
			
			boolean isUserExists = checkIfUserExists(orgId, orgPw, tenantId);
			logger.debug("isUserExists=" + isUserExists);
			
			if (isUserExists) {
				String encryptedPw = EgovFileScrty.encryptPassword(orgPw, orgId);
				
				loginController.createLoginCookie(orgId, orgPw, encryptedPw, tenantId, request, response);
				resultPage = "redirect:/ezEmail/mailMain.do";
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		logger.debug("mailMain ended.");
		return resultPage;
	}
	
	private boolean checkIfUserExists(String id, String pw, int tenantId) throws Exception {
		logger.debug("checkIfUserExists started. id=" + id + ",tenantId=" + tenantId);
		
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
		
		logger.debug("checkIfUserExists ended.");
		
		return isUserExists;
	}	
    
}
