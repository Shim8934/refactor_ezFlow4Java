package egovframework.ezMobile.ezOption.web;

import java.util.Locale;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;

import egovframework.ezMobile.ezOption.service.MOptionService;
import egovframework.ezMobile.ezPortal.web.MPortalController;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

@Controller
public class MOptionController {

private static final Logger logger = LoggerFactory.getLogger(MPortalController.class);
	
	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;
	
	@Resource(name="loginService")
	private LoginService loginService;

	@Resource(name="crypto") 
	private EgovFileScrty egovFileScrty;
	
	@Resource(name = "MOptionService")
	private MOptionService mOptionService;
	
	/**
	 * 모바일 환경설정 페이지 호출 함수
	 */
	@RequestMapping(value = "/mobile/ezOption/ezOptionMain.do")
	public String ezOptionMain(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale) throws Exception {
		logger.debug("optionMain Start");
		logger.debug("optionMain End");
		return "/mobile/ezOption/mOptionMain";
	}
	
	/**
	 * 모바일 환경설정 페이지 호출 함수
	 */
	@RequestMapping(value = "/mobile/ezOption/saveOption.do")
	public String saveOption(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale) throws Exception {
		logger.debug("saveOption Start");
		userInfo = commonUtil.userInfo(loginCookie);
		
		String langFlag = req.getParameter("lang");
		String dpBoardCnt = req.getParameter("dpBoardCnt");
		String resourceChk = req.getParameter("resourceChk");
		String resourceYN = req.getParameter("resourceYN");
		
		if (langFlag == null) {
			langFlag = userInfo.getPrimary();
		}
		
		System.out.println(langFlag);
		System.out.println(dpBoardCnt);
		System.out.println(resourceChk);
		System.out.println(resourceYN);
		
		String result = mOptionService.saveOption(userInfo.getId(), langFlag, dpBoardCnt, resourceChk, resourceYN, userInfo.getTenantId());
		logger.debug("saveOption End");
		return "true";
	}
	
	
	
	
}
