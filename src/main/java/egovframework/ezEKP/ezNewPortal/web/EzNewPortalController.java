package egovframework.ezEKP.ezNewPortal.web;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.w3c.dom.Document;

import com.opencsv.ResultSetColumnNameHelperService;

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
	 * 유은정
	 */
	/**
	 * 포탈 호출 함수
	 */
	@RequestMapping(value = "/ezNewPortal/newPortalMain.do")
	public String portalMain(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale) throws Exception {
		logger.debug("portalMain Start");
		logger.debug("portalMain End");
		return "/ezNewPortal/newPortalMain";
	}
	
	/**
	 * 포탈 탑메뉴 호출 함수
	 */
	@RequestMapping(value = "/ezNewPortal/newPortalTopMenu.do")
	public String portalTopMenu(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, HttpServletResponse resp, Locale locale) throws Exception {
		logger.debug("portalTopMenu Start");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();
		String url = "/rest/ezPortal/menus/users/" + userId;
		JSONObject resultBody = commonUtil.getJsonFromRestApi(url, null, req, "get", null);
		String status = resultBody.get("status").toString();

		if (status.equals("ok")) {
			JSONObject data = (JSONObject) resultBody.get("data");
		}
		
		
		logger.debug("portalTopMenu End");
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
		String returnUrl = "/ezNewPortal/";
		JSONObject resultBody = commonUtil.getJsonFromRestApi(url, null, req, "get", null);
		String status = resultBody.get("status").toString();
		String serverTime = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), userInfo.getOffset(), false);
		Calendar cal = Calendar.getInstance();
		String nowMonth = String.valueOf(cal.get(Calendar.MONTH)+1);
		
		resp.setHeader("Pragma", "no-cache"); //HTTP 1.0 
		resp.setHeader("Cache-Control", "no-cache"); //HTTP 1.1 
		resp.setHeader("Cache-Control", "no-store"); //HTTP 1.1 
		resp.setDateHeader("Expires", 0L); // Do not cache in proxy server

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
			model.addAttribute("serverTime", serverTime);
			model.addAttribute("nowMonth", nowMonth);
			
			String usedTheme = data.get("usedTheme").toString();
			String usedFrame = data.get("usedFrame").toString();
			returnUrl += "Theme" + usedTheme + "_Frame" + usedFrame;
			logger.debug("returnUrl : " + returnUrl);
		}
		
		logger.debug("portalMainPage End");
		return returnUrl;
	}
	
	/**
	 * 사용자 포틀릿 순서 변경 실행
	 * @param req
	 * @param model
	 * @param loginCookie
	 * @param resp
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ezNewPortal/updatePortletOrderUser.do")
	@ResponseBody
	public String updatePortletOrderUser(@RequestBody JSONObject jsonParam, HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, HttpServletResponse resp) throws Exception {
		logger.debug("updatePortletOrderUser Start");
		String result = "success";
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();
		String url = "/rest/ezPortal/portlets/order/users/" + userId;
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi(url, null, req, "patch", jsonParam);
		String status = resultBody.get("status").toString();
		
		if (status.equals("fail")) {
			result = "failed";
		}
		
		logger.debug("updatePortletOrderUser End");
		return result;
	}
	
	/**
	 * 월별 생일자 목록 불러오기
	 * @param req
	 * @param model
	 * @param loginCookie
	 * @param resp
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ezNewPortal/getMonthlyBirthdayEmployees.do")
	@ResponseBody
	public JSONObject getMonthlyBirthdayEmployees(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, HttpServletResponse resp) throws Exception {
		logger.debug("getMonthlyBirthdayEmployees Start");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();
		String url = "/rest/ezPortal/birthday/months/" + req.getParameter("birthdayMonth");
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userId);
		param.put("birthdayCurPage", req.getParameter("birthdayCurPage"));
		param.put("birthdayCount", req.getParameter("birthdayCount"));
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi(url, param, req, "get", null);
		JSONObject birthdayInfo = new JSONObject();
		String status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {
			JSONObject data = (JSONObject) resultBody.get("data");
			birthdayInfo.put("birthdayList", data.get("birthdayList"));
			birthdayInfo.put("birthdayTotalCount", data.get("birthdayListCount"));
			birthdayInfo.put("birthdayCurPage", data.get("birthdayCurPage"));
		}
		
		logger.debug("getMonthlyBirthdayEmployees End");
		return birthdayInfo;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ezNewPortal/getMonthlyBestEmployee.do")
	@ResponseBody
	public JSONObject getMonthlyBestEmployee(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, HttpServletResponse resp) throws Exception {
		logger.debug("getMonthlyBestEmployee Start");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userId);
		
		Calendar cal = Calendar.getInstance();
		int month = cal.get(Calendar.MONTH) + 1;
		
		String url = "/rest/ezPortal/bestEmployee/months/" + month;
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi(url, param, req, "get", null);
		String status = resultBody.get("status").toString();
		JSONObject bestEmployee = new JSONObject();
		
		if (status.equals("ok")) {
			bestEmployee.put("bestEmployee", resultBody.get("data"));
		}
		
		logger.debug("getMonthlyBestEmployee End");
		return bestEmployee;
	}
	
	@RequestMapping(value = "/ezNewPortal/portletSetting.do")
	public String portletSetting(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, HttpServletResponse resp) throws Exception {
		
		return "/ezNewPortal/portletSetting";
	}
	
	//읽지 않은 메일, 결재할 문서, 전자설문, 오늘일정, 회람판 개수 불러오기
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ezNewPortal/unreadCounts.do")
	@ResponseBody
	public JSONObject getUnreadCounts(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, HttpServletResponse resp) throws Exception {
		logger.debug("getUnreadCounts Start");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();		
		String url = "/rest/ezPortal/settingInfo/unreadCounts/users/" + userId;
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi(url, null, req, "get", null);
		String status = resultBody.get("status").toString();
		JSONObject unreadCounts = new JSONObject();
		
		if (status.equals("ok")) {
			JSONObject data = (JSONObject) resultBody.get("data");
			unreadCounts.put("pollCount", data.get("pollCount"));
			unreadCounts.put("circularCount", data.get("circularCount"));
			unreadCounts.put("scheduleCount", data.get("scheduleCount"));
			unreadCounts.put("approvalCount", data.get("approvalCount"));
			unreadCounts.put("unreadMailCount", data.get("unreadMailCount"));
		}
		
		logger.debug("getUnreadCounts End");
		return unreadCounts;
	}
	/**
	 * ----
	 */
}
