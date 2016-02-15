package egovframework.ezEKP.ezBoard.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;

import egovframework.ezEKP.ezBoard.service.EzBoardAdminService;
import egovframework.ezEKP.ezBoard.service.EzBoardService;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.sim.service.EgovFileScrty;

@Controller
public class EzBoardAdminController {
	
	@Resource(name="loginService")
	private LoginService loginService;
	
	@Resource(name="crypto") 
    private EgovFileScrty egovFileScrty;

	@Resource(name="EzBoardService")
	private EzBoardService ezBoardService;
	
	@Resource(name="EzBoardAdminService")
	private EzBoardAdminService ezBoardAdminService;
	
	@RequestMapping(value="/ezEKP/ezBoardAdmin/web/left_boardSTD.do")
	public String left_boardSTD_admin(@CookieValue("userID") String userID, HttpServletRequest request, ModelMap modelMap, LoginVO loginVO) throws Exception{
		
		String id = egovFileScrty.getUserID(userID);
		
		loginVO.setId(id);
		loginVO.setPassword("LOGIN");		
		LoginVO user = loginService.selectUser(loginVO);
		
		
		
		return "admin/ezBoard/left_boardStd";
	}
	
}
