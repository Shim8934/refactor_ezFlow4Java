package egovframework.ezEKP.ezNewPortal.web;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.Cookie;
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

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGService;
import egovframework.ezEKP.ezBoard.service.EzBoardService;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezPersonal.service.EzPersonalService;
import egovframework.ezEKP.ezPoll.service.EzPollService;
import egovframework.ezEKP.ezPortal.service.EzPortalAdminService;
import egovframework.ezEKP.ezPortal.service.EzPortalService;
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
	public String portalMain(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, HttpServletResponse resp) throws Exception {
		logger.debug("portalMain Start");
		//초기화면 설정 확인
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();
		String url = "/rest/ezPortal/startpage/users/" + userId;
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, null, req, "get", null);
		String status = resultBody.get("status").toString();
		String returnUrl = "";
		String useMemo = "";
		
		if (status.equals("ok")) {
			JSONObject data = (JSONObject) resultBody.get("data");
			JSONObject startPage = (JSONObject) data.get("startPage");
			useMemo = data.get("useMemo").toString();
			
			if (startPage != null) {
				String startUrl = startPage.get("menuUrl").toString();
				
				if (startUrl == null) {
					returnUrl = "/ezNewPortal/newPortalPortalPage.do";
				} else {
					returnUrl = startUrl;
				}
			} else {
				returnUrl = "/ezNewPortal/newPortalPortalPage.do";
			}
		}
		
		model.addAttribute("useMemo", useMemo);
		model.addAttribute("mainUrl", returnUrl);
		logger.debug("returnUrl : " + returnUrl);
		logger.debug("portalMain End");
		return "/ezNewPortal/newPortalMain";
	}
	
	// 종균 시작
	/**
	 * 포탈 탑메뉴 호출 함수
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ezNewPortal/newPortalTopMenu.do")
	public String portalTopMenu(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, HttpServletResponse resp, Locale locale) throws Exception {
		logger.debug("portalTopMenu Start");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();
		String url = "/rest/ezPortal/menus/users/" + userId;
		JSONObject resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, null, req, "get", null);
		String status = resultBody.get("status").toString();

		if (status.equals("ok")) {
			JSONObject data = (JSONObject) resultBody.get("data");
			
			logger.debug("TopMenu : " + data.toJSONString());
			
			JSONArray popupNotiList = (JSONArray) data.get("popupNotiList");
			int popupNotiListCount = popupNotiList.size();
			JSONArray popupNotiListAfter = new JSONArray();
			popupNotiListAfter.addAll(popupNotiList);
			
			String cookieValue = "";
			
			for (int i = 0; i < popupNotiListCount; i++) {
				JSONObject popupNoti = (JSONObject) popupNotiList.get(i);
				
				int itemSeq = Integer.parseInt(popupNoti.get("itemSeq").toString());
				Cookie[] cookies = req.getCookies();
				
				if (cookies != null) {
					for (int j=0; j<cookies.length; j++) {
						if (cookies[j].getName().equals("POPUP_" + itemSeq + "_" + userId)) {
							cookieValue = cookies[j].getValue();
						}
					}
					if (cookieValue != null && !cookieValue.equals("")) {
						popupNotiListAfter.remove(popupNoti);
					}
				}
			}
			
			
			
			model.addAttribute("logoUrl", data.get("logoUrl"));
			model.addAttribute("roleInfo", data.get("roleInfo"));
			model.addAttribute("menuList", data.get("menuList"));
			model.addAttribute("popupNotiList", popupNotiListAfter);
			model.addAttribute("useActiveX", data.get("useActiveX"));
			if (data.get("roleInfo").toString().equalsIgnoreCase("admin")) {
				model.addAttribute("utilAdminUrl", data.get("utilAdminUrl"));
			}
		}
		
		logger.debug("portalTopMenu End");
		return "/ezNewPortal/newPortalTopMenu";
	}
	
	/**
	 * 사용자 메뉴 순서 변경
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ezNewPortal/updateUserMenuOrder.do")
	@ResponseBody
	public JSONObject updateUserMenuOrder(@RequestBody JSONObject jObj, HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, HttpServletResponse resp) throws Exception {
		logger.debug("updateUserMenuOrder Start");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();
		String url = "/rest/ezPortal/menus/order/users/" + userId;
		JSONObject resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, null, req, "patch", jObj);
		String status = resultBody.get("status").toString();
		String result = "failure";

		JSONObject resultObj = new JSONObject();
		
		if (status.equals("ok")) {
			result = "success";
			resultObj.put("result" , result);
			resultObj.put("data" , resultBody.get("data"));
		}		
		
		logger.debug("updateUserMenuOrder End");
		return resultObj;
	}
	
	/**
	 * 사용자 메뉴 순서 초기화
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ezNewPortal/deleteUserMenuOrder.do")
	@ResponseBody
	public JSONObject deleteUserMenuOrder(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, HttpServletResponse resp) throws Exception {
		logger.debug("deleteUserMenuOrder Start");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();
		String url = "/rest/ezPortal/menus/order/users/" + userId;
		JSONObject resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, null, req, "delete", null);
		String status = resultBody.get("status").toString();
		String result = "failure";

		JSONObject resultObj = new JSONObject();
		
		if (status.equals("ok")) {
			result = "success";
			resultObj.put("result" , result);
			resultObj.put("data" , resultBody.get("data"));
		}		
		
		logger.debug("deleteUserMenuOrder End");
		return resultObj;
	}	
	
	/**
	 *	퀵 링크 가져오기 
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ezNewPortal/getQuickLink.do")
	@ResponseBody
	public JSONObject getQuickLink(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, HttpServletResponse resp) throws Exception {
		logger.debug("getQuickLink Start");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String companyId = userInfo.getCompanyID();
		String url = "/rest/ezPortal/quickLink/company/" + companyId;
		String userId = userInfo.getId();
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userId);
		param.put("page", req.getParameter("page"));

		JSONObject resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, param, req, "GET", null);
		String status = resultBody.get("status").toString();		
		
		JSONObject resultObj = new JSONObject();

		if (status.equals("ok")) {
			resultObj.put("data" , resultBody.get("data"));
		}		
		
		logger.debug("getQuickLink End");
		return resultObj;
	}
	
	/**
	 * 사용자 프레임 리스트 출력
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ezNewPortal/getUserFrameList.do")
	@ResponseBody
	public JSONObject getUserFrameList(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, HttpServletResponse resp) throws Exception {
		logger.debug("getUserFrameList Start");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();		
		String url = "/rest/ezPortal/frames/users/" + userId;	
		JSONObject resultBody = commonUtil.getJsonFromRestApi(url, null, req, "GET", null);
		String status = resultBody.get("status").toString();	
		
		JSONObject resultObj = new JSONObject();

		if (status.equals("ok")) {
			resultObj.put("data" , resultBody.get("data"));
			logger.debug("FrameList: " + resultBody.get("data").toString());
		}		
		logger.debug("getUserFrameList End");
		return resultObj;
	}
	
	/**
	 * 사용자 포틀릿 설정 리스트 출력
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ezNewPortal/getUserPortletList.do")
	@ResponseBody
	public JSONObject getUserPortletList(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, HttpServletResponse resp) throws Exception {
		logger.debug("getUserPortletList Start");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String userId = userInfo.getId();
		
		String url = "/rest/ezPortal/portlets/users/" + userId;	
		JSONObject resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, null, req, "GET", null);
		String status = resultBody.get("status").toString();	
		
		JSONObject resultObj = new JSONObject();

		if (status.equals("ok")) {
			resultObj.put("data" , resultBody.get("data"));
			logger.debug("PortletList: " + resultBody.get("data").toString());
		}			
		
		logger.debug("getUserPortletList End");
		return resultObj;
	}	
	
	/**
	 * 사용자 프레임 변경 & 포틀릿 설정 변경 
	 */
	@RequestMapping(value = "/ezNewPortal/updateUserFrameAndPortelt.do")
	@ResponseBody
	public String updateUserFrameAndPortlet(HttpServletRequest req, @RequestBody JSONObject jObj ,Model model, @CookieValue("loginCookie") String loginCookie, HttpServletResponse resp) throws Exception {
		logger.debug("updateUserFrameAndPortlet Start");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();		
		String result = "success";
		
		/* 사용자 프레임 변경 */
		String url = "/rest/ezPortal/frames/users/" + userId;
		JSONObject resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, null, req, "patch", jObj);
		String status = resultBody.get("status").toString();
		
		
		/* 사용자 포틀릿 사용 변경 */
		url = "/rest/ezPortal/portlets/users/" + userId;
		resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, null, req, "patch", jObj);
		status = resultBody.get("status").toString();
		
		logger.debug("status" + status);
		
		if(status.equals("error")) {
			result = "failure";
		}
		
		logger.debug("updateUserFrameAndPortlet End");
		return result;
	}
	// 종균 끝
	
	
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
		JSONObject resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, null, req, "get", null);
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
			model.addAttribute("useAttitude", data.get("useAttitude"));
			model.addAttribute("useQuestion", data.get("useQuestion"));
			model.addAttribute("useCircular", data.get("useCircular"));
			model.addAttribute("useMail", data.get("useMail"));
			model.addAttribute("useApproval", data.get("useApproval"));
			model.addAttribute("useSchedule", data.get("useSchedule"));
			model.addAttribute("lastLogin", data.get("lastLogin"));
			model.addAttribute("userEmail", data.get("userEmail"));
			
			String usedTheme = data.get("usedTheme").toString();
			returnUrl += "Theme" + usedTheme;
			logger.debug("returnUrl : " + returnUrl);
		}
		
		//김보미 추가 - calenderMini는 ie와 크롬일 때랑 파일이 틀려서 구분값 필요함.
		boolean checkBrowser;
		if (req.getHeader("User-Agent").indexOf("Trident") > 0 || req.getHeader("User-Agent").toUpperCase().indexOf("MSIE") > 0) {
			checkBrowser = true;
		} else {
			checkBrowser = false;
		}
		
		model.addAttribute("checkBrowser", checkBrowser);
		
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
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, null, req, "patch", jsonParam);
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
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, param, req, "get", null);
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
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, param, req, "get", null);
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
	public JSONObject getUnreadCounts(HttpServletRequest req, Model model,@RequestBody Map<String, Object> param, @CookieValue("loginCookie") String loginCookie, HttpServletResponse resp) throws Exception {
		logger.debug("getUnreadCounts Start");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();		
		String url = "/rest/ezPortal/settingInfo/unreadCounts/users/" + userId;
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, param, req, "get", null);
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
	
	//테마 설정 화면 호출
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ezNewPortal/userThemeSetting.do")
	public String userThemeSetting(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, HttpServletResponse resp) throws Exception {
		logger.debug("userThemeSetting Start");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();
		
		//사용자가 선택 가능한 테마 목록 불러오기
		String themeUrl = "/rest/ezPortal/themes/users/" + userId;
		JSONObject themeResultBody = commonUtil.getJsonFromRestApi(themeUrl, null, req, "get", null);
		String themeStatus = themeResultBody.get("status").toString();
		String usedTheme = "";
		
		if (themeStatus.equals("ok")) {
			JSONArray themeList = (JSONArray) themeResultBody.get("data");
			int themeListCount = themeList.size();
			int userThemeMiddleIndex = themeListCount / 2;
			
			for (int i = 0; i < themeListCount; i++) {
				JSONObject theme = (JSONObject) themeList.get(i);
				String themeId = theme.get("themeId").toString();
				
				if ((boolean)theme.get("themeUsed")) {
					usedTheme = themeId;
					themeList.remove(i);
					themeList.add(userThemeMiddleIndex, theme);
				}
			}
			
			model.addAttribute("usedTheme", usedTheme);
			model.addAttribute("themeList", themeList);
		}
		
		logger.debug("userThemeSetting End");
		return "/ezNewPortal/userThemeSetting";
	}
	
	//초기화면 설정 화면 호출
	@RequestMapping(value = "/ezNewPortal/userStartPageSetting.do")
	public String userStartPageSetting(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, HttpServletResponse resp) throws Exception {
		logger.debug("userStartPageSetting Start");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();
		
		//초기화면으로 설정할 수 있는 메뉴 호출
		String menuUrl = "/rest/ezPortal/menus/users/" + userId;
		JSONObject menuResultBody = commonUtil.getJsonFromRestApi(menuUrl, null, req, "get", null);
		String menuStatus = menuResultBody.get("status").toString();

		if (menuStatus.equals("ok")) {
			JSONObject data = (JSONObject) menuResultBody.get("data");
			
			logger.debug("TopMenu : " + data.toJSONString());
			model.addAttribute("menuList", data.get("menuList"));
		}
		
		//현재 사용중인 초기화면 호출
		String startPageUrl = "/rest/ezPortal/startpage/users/" + userId;
		JSONObject startPageResultBody = commonUtil.getJsonFromMemoRestApi(startPageUrl, null, req, "get", null);
		String startPageStatus = startPageResultBody.get("status").toString();
		
		if (startPageStatus.equals("ok")) {
			JSONObject data = (JSONObject) startPageResultBody.get("data");
			JSONObject startPage = (JSONObject) data.get("startPage");
			
			if (startPage == null) {
				model.addAttribute("menuId", 0);
				model.addAttribute("menuUrl", "/ezNewPortal/newPortalPortalPage.do");
			} else {
				model.addAttribute("menuId", startPage.get("menuId"));
				model.addAttribute("menuUrl", startPage.get("menuUrl"));
			}
		}
		
		logger.debug("userStartPageSetting End");
		return "/ezNewPortal/userStartPageSetting";
	}
	
	//사용자 초기화면 설정 실행 함수
	@RequestMapping(value = "/ezNewPortal/updateUserStartPage.do")
	public void updateUserStartPage(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, HttpServletResponse resp) throws Exception {
		logger.debug("updateUserStartPage Start");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();
		int menuId = Integer.parseInt(req.getParameter("menuId"));
		String url = "/rest/ezPortal/startpage/menus/" + menuId + "/users/" + userId;
		
		commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, null, req, "patch", null);
		
		logger.debug("updateUserStartPage End");
	}
	
	//테마 초기화 실행 함수
	@RequestMapping(value = "/ezNewPortal/deleteUserThemeSetting.do")
	public void deleteUserThemeSetting(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, HttpServletResponse resp) throws Exception {
		logger.debug("deleteUserThemeSetting Start");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();
		String url = "/rest/ezPortal/themes/users/" + userId;
		
		commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, null, req, "delete", null);
		
		logger.debug("deleteUserThemeSetting End");
	}
	
	//사용자 기본 테마 설정 실행 함수
	@RequestMapping(value = "/ezNewPortal/updateUserThemeSetting.do")
	public void updateUserThemeSetting(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, HttpServletResponse resp) throws Exception {
		logger.debug("updateUserThemeSetting Start");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();
		int themeId = Integer.parseInt(req.getParameter("themeId"));
		String url = "/rest/ezPortal/themes/" + themeId + "/users/" + userId;
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("frameDefault", req.getParameter("frameDefault"));
		
		commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, param, req, "patch", null);
		
		logger.debug("updateUserThemeSetting End");		
	}
	/**
	 * ----
	 */
	/**
	 * 포탈 ActiveX 다운로드 실행 함수
	 */
	@RequestMapping(value = "/ezNewPortal/progress.do")
	public String progress() {
		return "/ezNewPortal/portalProgress";
	}

	/**
	 * 포탈 ActiveX 다운로드 목록 호출 함수
	 */
	@RequestMapping(value = "/ezNewPortal/componentListTransfer.do", produces="text/xml;charset=utf-8")
	@ResponseBody
	public String componentListTransfer(HttpServletRequest request, HttpServletResponse response) throws Exception {
		StringBuilder result = new StringBuilder();
		String realPath = commonUtil.getRealPath(request); 
		String path = "xml" + commonUtil.separator + "ezPortal" + commonUtil.separator + "componentlist.xml";
		path = realPath + commonUtil.separator + path;
		try {
			File file = new File(path);
			BufferedReader br = new BufferedReader(new FileReader(file));
			String line = null;
	
			while ((line = br.readLine()) != null) {
				result.append(line);
			}
			
			br.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		logger.debug("downloadServer="+result.toString().replace("DOWNLOADSERVER", request.getRequestURL().substring(0, request.getRequestURL().indexOf(request.getRequestURI()))));
		return result.toString().replace("DOWNLOADSERVER", request.getRequestURL().substring(0, request.getRequestURL().indexOf(request.getRequestURI())));
	}
}
