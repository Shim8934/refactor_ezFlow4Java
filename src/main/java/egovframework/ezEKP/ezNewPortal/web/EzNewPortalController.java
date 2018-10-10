package egovframework.ezEKP.ezNewPortal.web;

import java.util.HashMap;
import java.util.Locale;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.w3c.dom.Document;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGService;
import egovframework.ezEKP.ezBoard.service.EzBoardService;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezPersonal.service.EzPersonalService;
import egovframework.ezEKP.ezPoll.service.EzPollService;
import egovframework.ezEKP.ezPortal.service.EzPortalAdminService;
import egovframework.ezEKP.ezPortal.service.EzPortalService;
import egovframework.ezEKP.ezPortal.web.EzPortalController;
import egovframework.ezEKP.ezQuestion.service.EzQuestionService;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

@Controller
public class EzNewPortalController {

private static final Logger logger = LoggerFactory.getLogger(EzNewPortalController.class);
	
	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;
	
	@Resource(name="EzPortalService")
	private EzPortalService ezPortalService;
	
	@Resource(name="EzPortalAdminService")
	private EzPortalAdminService ezPortalAdminService;
	
	@Resource(name = "EzPersonalService")
	private EzPersonalService ezPersonalService;
	
	@Resource(name = "EzQuestionService")
	private EzQuestionService ezQuestionService;
	
	@Resource(name = "EzOrganService")
	private EzOrganService ezOrganService;
	
	@Resource(name = "EzBoardService")
	private EzBoardService ezBoardService;
	
	@Resource(name = "EzApprovalGService")
	private EzApprovalGService ezApprovalGService;
	
	@Resource(name="loginService")
	private LoginService loginService;

	@Resource(name="crypto") 
	private EgovFileScrty egovFileScrty;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Resource(name="EzCommonService")
	private EzCommonService ezCommonService;
	
	@Resource(name = "EzPollService")
	private EzPollService ezPollService;
	/**
	 * 포탈 호출 함수
	 */
	@RequestMapping(value = "/ezNewPortal/newPortalMain.do")
	public String portalMain(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale) throws Exception {
		logger.debug("portalMain Start");
		
		return "/ezNewPortal/newPortalMain";
	}
	
	/**
	 * 포탈 탑메뉴 호출 함수
	 */
	@RequestMapping(value = "/ezNewPortal/newPortalTopMenu.do")
	public String portalTopMenu(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale) throws Exception {
		logger.debug("portalTopMenu Start");
		
		return "/ezNewPortal/newPortalTopMenu";
	}
	
	/**
	 * 포탈 메인 화면 호출 함수
	 */
	@RequestMapping(value = "/ezNewPortal/newPortalPortalPage.do")
	public String portalMainPage(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, HttpServletResponse resp) throws Exception {
		logger.debug("portalMainPage Start");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();
		String url = "/rest/ezPortal/settingInfo/users/" + userId;
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi(url, null, req, "get", null);
		String status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {
			JSONObject data = (JSONObject) resultBody.get("data");
			model.addAttribute("portletOrder", data.get("portletOrder"));
			model.addAttribute("usedTheme", data.get("usedTheme"));
			model.addAttribute("usedFrame", data.get("usedFrame"));
			model.addAttribute("sliderList", data.get("sliderList"));
			model.addAttribute("userPhoto", data.get("userPhoto"));
			model.addAttribute("userName", data.get("userName"));
			model.addAttribute("userTitle", data.get("userTitle"));
			model.addAttribute("deptName", data.get("deptName"));
			model.addAttribute("pollCount", data.get("pollCount"));
			model.addAttribute("circularCount", data.get("circularCount"));
			model.addAttribute("scheduleCount", data.get("scheduleCount"));
		}
		
		logger.debug("portalMainPage End");
		return "/ezNewPortal/newPortalPortalPage";
	}
}
