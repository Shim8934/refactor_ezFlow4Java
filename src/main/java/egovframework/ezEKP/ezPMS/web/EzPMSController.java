package egovframework.ezEKP.ezPMS.web;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;

import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

@Controller
public class EzPMSController {
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private EgovFileScrty egovFileScrty;
	
	
	/**
	 * 프로젝트 관리 메인화면 호출함수
	 */
	@RequestMapping(value="/ezPMS/pmsMain.do")
	public String  main() {
		return "ezPMS/pmsMain";
	}
	
	/**
	 * 프로젝트관리 왼쪽화면 호출함수
	 * @return
	 */
	@RequestMapping(value="/ezPMS/pmsLeft.do")
	public String  left() {
		return "ezPMS/pmsLeft";
	}
	
	/**
	 * 메인페이지화면 호출 함수
	 */
	@RequestMapping(value = "/ezPMS/pmsMainPage.do")
	public String mainPage(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		
		return "ezPMS/pmsMainPage";
	}
	
}
