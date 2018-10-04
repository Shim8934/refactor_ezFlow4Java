package egovframework.ezEKP.ezNewPortal.web;

import java.util.Locale;

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

import egovframework.com.cmm.EgovMessageSource;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Controller
public class EzNewPortalAdminController {

	private static final Logger logger = LoggerFactory.getLogger(EzNewPortalAdminController.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	
	/**
	 * @author 이효진
	 */
	
	/**
	 * 관리자 포탈 메인화면 조회
	 */
	@RequestMapping(value = "/admin/ezNewPortal/portalMain.do")
	public String portalMain(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("portalMain started.");

		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			logger.debug("portalMain accessDenied.");
			
			return "cmm/error/adminDenied";
		} else {
			logger.debug("portalMain ended.");
			
			return "/admin/ezNewPortal/portalMain";
		}
	}
	
	/**
	 * 관리자 포탈 Left 화면조회
	 */
	@RequestMapping(value = "/admin/ezNewPortal/portalLeftMenu.do")
	public String portalTopMenu(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("portalLeftMenu started.");

		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			logger.debug("portalLeftMenu accessDenied.");
			
			return "cmm/error/adminDenied";
		} else {
			logger.debug("portalLeftMenu ended.");
			
			return "/admin/ezNewPortal/portalLeftMenu";
		}
	}
	
	/**
	 * 관리자 포탈 테마목록 화면조회
	 */
	@RequestMapping(value = "/admin/ezNewPortal/portalThemes.do")
	public String portalThemes(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("portalThemes started.");

		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			logger.debug("portalThemes accessDenied.");
			
			return "cmm/error/adminDenied";
		} else {
			logger.debug("portalThemes ended.");
			
			return "/admin/ezNewPortal/portalThemes";
		}
	}
	/** ----------------------------------------------- */
	
	
	/**
	 * @author 구해안
	 */
	
	
	/** ----------------------------------------------- */
}
