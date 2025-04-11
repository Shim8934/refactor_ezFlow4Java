package egovframework.ezEKP.ezNewPortal.web;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import egovframework.ezEKP.ezEmail.logic.IMAPAccess;
import egovframework.ezEKP.ezEmail.util.EzEmailUtil;
import egovframework.ezEKP.ezNewPortal.service.EzNewPortalService;
import egovframework.ezEKP.ezNewPortal.vo.MenuInfoVO;
import egovframework.ezEKP.ezNewPortal.vo.PortalUserSwitchVO;
import org.apache.commons.lang3.StringUtils;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGService;
import egovframework.ezEKP.ezBoard.service.EzBoardService;
import egovframework.ezEKP.ezBoard.vo.BoardListVO;
import egovframework.ezEKP.ezBoard.vo.BoardPropertyVO;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.web.EzEmailConfigController;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezPersonal.service.EzPersonalService;
import egovframework.ezEKP.ezPoll.service.EzPollService;
import egovframework.ezEKP.ezPortal.service.EzPortalAdminService;
import egovframework.ezEKP.ezPortal.service.EzPortalService;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderService_y;
import egovframework.ezEKP.ezWebFolder.vo.FolderTreeVO;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

@Controller
public class EzNewPortalController {

private static final Logger logger = LoggerFactory.getLogger(EzNewPortalController.class);
	
	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;
	
	@Autowired
	private EzEmailConfigController ezEmailConfigController; 

	@Autowired
	private EzWebFolderService_y ezWebFolderService_y;

	@Autowired
	private EzNewPortalService ezNewPortalService;

	@Autowired
	private EzEmailUtil ezEmailUtil;
	@Resource(name="EzPortalService")
	private EzPortalService ezPortalService;
	
	@Resource(name="EzPortalAdminService")
	private EzPortalAdminService ezPortalAdminService;
	
	@Resource(name = "EzPersonalService")
	private EzPersonalService ezPersonalService;
	
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

	@Resource(name = "jspw")
	private String jspw;
	
	/**
	 * 유은정
	 */
	/**
	 * 포탈 호출 함수
	 */
	@RequestMapping(value = "/ezNewPortal/newPortalMain.do", method={RequestMethod.GET, RequestMethod.POST})
	public String portalMain(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, HttpServletResponse resp) throws Exception {
		logger.debug("portalMain Start");
		//초기화면 설정 확인
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();
		String companyId = userInfo.getCompanyID();
		String deptId = userInfo.getDeptID();
		String url = "/rest/ezPortal/startpage/users/" + userId + "?companyId=" + companyId + "&deptId=" + deptId;
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, null, req, "get", null);
		String status = resultBody.get("status").toString();
		String returnUrl = "";
		String useMemo = "";
		String useExternalMailServer = "";
		String useContextmenu = "";
		String useWebHWP = "";
		
		if (status.equals("ok")) {
			JSONObject data = (JSONObject) resultBody.get("data");
			JSONObject startPage = (JSONObject) data.get("startPage");
			JSONObject convertMenu = (JSONObject) data.get("convertMenu");
			logger.debug("convertMenu check: " + convertMenu);
			useMemo = data.get("useMemo").toString();
			useExternalMailServer = data.get("useExternalMailServer").toString();
			useContextmenu = data.get("useContextmenu").toString();
			useWebHWP = data.get("useWebHWP").toString();
			
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

		// 우선 포탈 사용안하면 전자결재를 기본으로 나오도록 함. 수정 필요
		String usePortal = ezCommonService.getTenantConfig("Use_Portal", userInfo.getTenantId());
		if (usePortal != null && usePortal.equals("NO")) {
			returnUrl = "/ezApprovalG/apprGMain.do";
		}
		
		String packageType = commonUtil.getPackageType(userInfo.getTenantId());
		
		if (packageType.equals(CommonUtil.PT_MAIL) || packageType.equals(CommonUtil.PT_BASIC)) {
			useMemo  = "NO";
			returnUrl = "/ezEmail/mailMain.do";
		}
		
		model.addAttribute("useContextmenu", useContextmenu);
		model.addAttribute("useExternalMailServer", useExternalMailServer);
		model.addAttribute("useMemo", useMemo);
		model.addAttribute("mainUrl", returnUrl);
		model.addAttribute("userDeptId", userInfo.getDeptID());
		model.addAttribute("useWebHWP", useWebHWP);

		String useMobileMailOnly = ezCommonService.getTenantConfig("useMobileMailOnly", userInfo.getTenantId());
		model.addAttribute("useMobileMailOnly", useMobileMailOnly);

		logger.debug("returnUrl : " + returnUrl);
		logger.debug("portalMain End");
		return "/ezNewPortal/newPortalMain";
	}
	
	/**
	 * 포탈 탑메뉴 호출 함수
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ezNewPortal/newPortalTopMenu.do", method=RequestMethod.GET)
	public String portalTopMenu(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, HttpServletResponse resp, Locale locale) throws Exception {
		logger.debug("portalTopMenu Start");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();
		String companyId = userInfo.getCompanyID();
		String deptId = userInfo.getDeptID();
		String jobId = StringUtils.isNotBlank(userInfo.getJobId()) ? userInfo.getJobId() : "";
		String url = "/rest/ezPortal/menus/users/" + userId + "?companyId=" + companyId + "&deptId=" + deptId + "&jobId=" + jobId;
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
						Cookie cookie = cookies[j];
						String cookieName = cookie.getName();
						
						if (cookieName.equals("POPUP_" + itemSeq + "_" + userId)) {
							cookieValue = cookies[j].getValue();
						}
					}
					if (cookieValue != null && !cookieValue.equals("")) {
						popupNotiListAfter.remove(popupNoti);
					}
					
					cookieValue = "";
				}
			}
			
			// yy logo를 누르면 이동하는 url 수정 (라이센스가 standard가 아니면 mailMain.do를 호출하도록 수정)
			String logoMainUrl = "/ezNewPortal/newPortalPortalPage.do";
			String packageType = commonUtil.getPackageType(userInfo.getTenantId());
		
			if (packageType.equals(CommonUtil.PT_MAIL) || packageType.equals(CommonUtil.PT_BASIC)) {
				logoMainUrl = "/ezEmail/mailMain.do";
				
				// 20200326 조진호 - 패키지 타입이 메일인 경우 사용자의 최종 로그인 시간과 ip를 탑메뉴 상단에 표기
				String lastLogin = ezOrganService.getLastLogin(userInfo.getId(), userInfo.getTenantId());
				String loginIP = "";
				if (lastLogin != null) {
					lastLogin = EgovDateUtil.convertDate(lastLogin, "yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd HH:mm", "");
					lastLogin = commonUtil.getDateStringInUTC(lastLogin, userInfo.getOffset(), false);
					loginIP = ezOrganService.getLoginIP(userInfo.getId(), userInfo.getTenantId());
				} else {
					lastLogin = "";
					loginIP = "";
				}
				model.addAttribute("lastLogin", lastLogin);
				model.addAttribute("loginIP", loginIP);
			}
			
			String usePortal = ezCommonService.getTenantConfig("Use_Portal", userInfo.getTenantId());
			if(usePortal.equalsIgnoreCase("NO")) {
				JSONArray menuList = (JSONArray) data.get("menuList");
				JSONObject firstMenu = (JSONObject) menuList.get(0);
				logoMainUrl = (String) firstMenu.get("menuUrl");
				//logoMainUrl = "/ezApprovalG/apprGMain.do";
			}

			String switchUserCompany = ezCommonService.getTenantConfig("switchUserCompany", userInfo.getTenantId());
			
			model.addAttribute("packageType", packageType.toLowerCase());
			
			model.addAttribute("logoMainUrl", logoMainUrl);
			model.addAttribute("logoUrl", data.get("logoUrl"));
			model.addAttribute("roleInfo", data.get("roleInfo"));
			model.addAttribute("menuList", data.get("menuList"));
			model.addAttribute("popupNotiList", popupNotiListAfter);
			model.addAttribute("useActiveX", data.get("useActiveX"));
			model.addAttribute("lang",userInfo.getLang());
			model.addAttribute("primary", commonUtil.getPrimaryData(userInfo.getLang(),userInfo.getTenantId()));
			model.addAttribute("primaryLang", ezCommonService.getTenantConfig("PrimaryLang", userInfo.getTenantId()));
			if (data.get("roleInfo").toString().equalsIgnoreCase("admin")) {
				model.addAttribute("utilAdminUrl", data.get("utilAdminUrl"));
			}
			//2019-09-20 메신저 설치 부분 추가
			model.addAttribute("useUtilTalk", data.get("useUtilTalk"));
			if (data.get("useUtilTalk").toString().equalsIgnoreCase("YES")) {
				model.addAttribute("talkFilePath", data.get("talkFilePath"));
			}
			//2019-10-04 통합검색 추가
			model.addAttribute("useTotalSearch", data.get("useTotalSearch"));
			model.addAttribute("switchUserCompany", switchUserCompany);
			model.addAttribute("menuDisplayMode", data.get("menuDisplayMode"));
			model.addAttribute("useColor", data.get("useColor"));
			
			// 유저이미지
			String imgUrl = ezOrganService.getPropertyValue(userId, "extensionAttribute2", userInfo.getTenantId());
			String userPhoto = "";
			if (imgUrl != null && !imgUrl.equals("")) {
				userPhoto = commonUtil.getUploadPath("upload_personal.PHOTO", userInfo.getTenantId()) + commonUtil.separator + imgUrl;
			}
			model.addAttribute("userPhoto", userPhoto);
		}
		
		/* 2024-03-26 한태훈 - 통합알림용 데이터 추가 */
		model.addAttribute("pollingInterval", ezCommonService.getTenantConfig("notiPollingInterval", userInfo.getTenantId()));
		model.addAttribute("lastNotiPollTime", commonUtil.getTodayUTCTime("yyyy-MM-dd HH:mm:ss"));
		
		logger.debug("portalTopMenu End");
		return "/ezNewPortal/newPortalTopMenu";
	}
	
	/**
	 * 사용자 메뉴 순서 변경
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ezNewPortal/updateUserMenuOrder.do", method=RequestMethod.POST)
	@ResponseBody
	public JSONObject updateUserMenuOrder(@RequestBody JSONObject jObj, HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, HttpServletResponse resp) throws Exception {
		logger.debug("updateUserMenuOrder Start");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();
		String companyId = userInfo.getCompanyID();
		String deptId = userInfo.getDeptID();
		String url = "/rest/ezPortal/menus/order/users/" + userId + "?companyId=" + companyId + "&deptId=" + deptId;

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
	@RequestMapping(value = "/ezNewPortal/deleteUserMenuOrder.do", method=RequestMethod.POST)
	@ResponseBody
	public JSONObject deleteUserMenuOrder(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, HttpServletResponse resp) throws Exception {
		logger.debug("deleteUserMenuOrder Start");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();
		String companyId = userInfo.getCompanyID();
		String deptId = userInfo.getDeptID();
		String url = "/rest/ezPortal/menus/order/users/" + userId + "?companyId=" + companyId + "&deptId=" + deptId;
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
	@RequestMapping(value = "/ezNewPortal/getQuickLink.do", method=RequestMethod.GET)
	@ResponseBody
	public JSONObject getQuickLink(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, HttpServletResponse resp) throws Exception {
		logger.debug("getQuickLink Start");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String companyId = userInfo.getCompanyID();
		String url = "/rest/ezPortal/quickLink/company/" + companyId;
		String userId = userInfo.getId();
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userId);
		param.put("deptId", userInfo.getDeptID());
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
	@RequestMapping(value = "/ezNewPortal/getUserFrameList.do", method=RequestMethod.GET)
	@ResponseBody
	public JSONObject getUserFrameList(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, HttpServletResponse resp) throws Exception {
		logger.debug("getUserFrameList Start");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();
		String companyId = userInfo.getCompanyID();
		String deptId = userInfo.getDeptID();
		String url = "/rest/ezPortal/frames/users/" + userId + "?companyId=" + companyId;

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
	@RequestMapping(value = "/ezNewPortal/getUserPortletList.do", method=RequestMethod.GET)
	@ResponseBody
	public JSONObject getUserPortletList(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, HttpServletResponse resp) throws Exception {
		logger.debug("getUserPortletList Start");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String userId = userInfo.getId();

		String companyId = userInfo.getCompanyID();
		String deptId = userInfo.getDeptID();
		String url = "/rest/ezPortal/portlets/users/" + userId + "?companyId=" + companyId + "&deptId=" + deptId;
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
	@RequestMapping(value = "/ezNewPortal/updateUserFrameAndPortelt.do", method=RequestMethod.POST)
	@ResponseBody
	public String updateUserFrameAndPortlet(HttpServletRequest req, @RequestBody JSONObject jObj ,Model model, @CookieValue("loginCookie") String loginCookie, HttpServletResponse resp) throws Exception {
		logger.debug("updateUserFrameAndPortlet Start");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();
		String companyId = userInfo.getCompanyID();
		String result = "success";
		
		// 2024-06-11 조수빈 - 프레임을 하나로 통일하도록 하였으나, 페이징처리 사용 유무 update를 위해 사용함. (프레임은 테마별 기본 값을 넣음)
		/* 사용자 프레임 변경 */
		String url = "/rest/ezPortal/frames/users/" + userId + "?companyId=" + companyId;
		JSONObject resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, null, req, "patch", jObj);
		String status = resultBody.get("status").toString();
		
		
		/* 사용자 포틀릿 사용 변경 */
		url = "/rest/ezPortal/portlets/users/" + userId + "?companyId=" + companyId;
		resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, null, req, "patch", jObj);
		status = resultBody.get("status").toString();
		
		logger.debug("status" + status);
		
		if(status.equals("error")) {
			result = "failure";
		}
		
		logger.debug("updateUserFrameAndPortlet End");
		return result;
	}	
	
	/**
	 * 포탈 메인 화면 호출 함수
	 */
	@RequestMapping(value = "/ezNewPortal/newPortalPortalPage.do", method=RequestMethod.GET)
	public String portalMainPage(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, HttpServletResponse resp, Locale local) throws Exception { // 2023-06-14 한슬기 - 디자인 개선> 테마2 > 상단 영역 메일/웹폴더 용량 표시 추가를 위해 Locale local 추가해주었음
		logger.debug("portalMainPage Start");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();
		String companyId = userInfo.getCompanyID();
		String deptId = userInfo.getDeptID();
		String jobId = StringUtils.isNotBlank(userInfo.getJobId()) ? userInfo.getJobId() : "";
		String url = "/rest/ezPortal/settingInfo/users/" + userId + "?companyId=" + companyId + "&deptId=" + deptId + "&jobId=" + jobId;
		String returnUrl = "/ezNewPortal/";
		JSONObject resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, null, req, "get", null);
		String status = resultBody.get("status").toString();
		String serverTime = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), userInfo.getOffset(), false);
		Calendar cal = Calendar.getInstance();
		String nowMonth = String.valueOf(cal.get(Calendar.MONTH)+1);
		String useMailServer2 =  config.getProperty("config.useMailServer2");

		resp.setHeader("Pragma", "no-cache"); //HTTP 1.0 
		resp.setHeader("Cache-Control", "no-cache"); //HTTP 1.1 
		resp.setHeader("Cache-Control", "no-store"); //HTTP 1.1 
		resp.setDateHeader("Expires", 0L); // Do not cache in proxy server

		if (status.equals("ok")) {
			JSONObject data = (JSONObject) resultBody.get("data");
			boolean useEzWorkspace = "YES".equals(data.get("useEzWorkspace"));
			String usedTheme = data.get("usedTheme").toString();
			
			model.addAttribute("portletOrder", data.get("portletOrder"));
			model.addAttribute("fixedPortletList", data.get("fixedPortletList"));
			model.addAttribute("usedTheme", data.get("usedTheme"));
			model.addAttribute("usedFrame", data.get("usedFrame"));
			model.addAttribute("usePaging", data.get("usePaging"));
			model.addAttribute("sliderList", data.get("sliderList"));
			model.addAttribute("userPhoto", data.get("userPhoto"));
			model.addAttribute("userName", data.get("userName"));
			model.addAttribute("userTitle", data.get("userTitle"));
			model.addAttribute("deptName", data.get("deptName"));
			model.addAttribute("serverTime", serverTime);
			model.addAttribute("nowMonth", nowMonth);
			model.addAttribute("useAttitude", data.get("useAttitude"));
			model.addAttribute("useQuestion", data.get("useQuestion"));
			model.addAttribute("useSurvey", data.get("useSurvey"));
			model.addAttribute("useCircular", data.get("useCircular"));
			model.addAttribute("useMail", data.get("useMail"));
			model.addAttribute("useApproval", data.get("useApproval"));
			model.addAttribute("useSchedule", data.get("useSchedule"));
			model.addAttribute("useEzWorkspace", useEzWorkspace);
			model.addAttribute("lastLogin", data.get("lastLogin"));
			model.addAttribute("userEmail", data.get("userEmail"));
			model.addAttribute("userId", userId);
			model.addAttribute("usePortalAutoRefreshInterval", data.get("usePortalAutoRefreshInterval"));
			model.addAttribute("userLang", userInfo.getPrimary());
			model.addAttribute("userLang2", userInfo.getLang());
			model.addAttribute("lastLoginIP", data.get("lastLoginIP"));
			
			//if (useEzWorkspace) {
				model.addAttribute("workspaceHostUrl", data.get("workspaceHostUrl"));
				model.addAttribute("workspaceContextRootUrl", data.get("workspaceContextRootUrl"));
			//}

			/* 2023-06-05 홍승비 - 게시판, 커뮤니티, 메모, 웹폴더 모듈 사용여부 테넌트 컨피그 추가 */
			model.addAttribute("useBoard", data.get("useBoard"));
			model.addAttribute("useCommunity", data.get("useCommunity"));
			model.addAttribute("useMemo", data.get("useMemo"));
			model.addAttribute("useWebfolder", data.get("useWebfolder"));
			
			// 2023-06-15 한슬기 - 디자인 개선 테마2 > 상단 영역 메일/웹폴더(개인) 용량 표시 추가
			if (usedTheme.equals("2")) {
				
				String mailCapacityInfo = "";
				String webFolderPersonalFolderId = "";
				
				if (data.get("useMail").equals("YES")) {
					// 2023-06-14 한슬기 - 디자인 개선 테마2 > 상단 영역 메일 용량 표시 추가를 위한 메일용량정보(xml)
					mailCapacityInfo = ezEmailConfigController.mailGetUse(loginCookie, local, model, req);

					if ("Y".equalsIgnoreCase(useMailServer2)){
						logger.debug("mailCapacityInfo2 Start");
						String mailCapacityInfo2 = "";
						req.setAttribute("mail2","y");
						mailCapacityInfo2 = ezEmailConfigController.mailGetUse(loginCookie, local, model, req);
						model.addAttribute("mailCapacityInfo2", mailCapacityInfo2);
					}
				}
				
				if (data.get("useWebfolder").equals("YES")) {
					// 2023-06-20 한슬기 - 디자인 개선 테마2 > 웹폴더(개인) 용량표시 추가를 위한 FolderId 값 추출
					webFolderPersonalFolderId = ezWebFolderService_y.getFolderTree(userInfo.getId(), userInfo.getDeptID(),
							userInfo.getCompanyName(), "U", userInfo.getPrimary(), userInfo.getTenantId(), "", false)
							.stream().findFirst().map(FolderTreeVO::getId).orElse("");
					
					// 2024-06-19 조수빈 - 웹폴더를 한 번도 접속하지 않은 사용자의 경우 사용자의 웹폴더 아이디가 없어 사용량이 나타나지 않는 문제 해소
					if (webFolderPersonalFolderId.equals("")) {
						String webFolderUrl = "/rest/ezwebfolder/users/" + userInfo.getId() + "/checkRootFolder";
						// 웹폴더 아이디가 한 번도 발급되지 않은 사용자이면 발급할 수 있도록 api 호출
						JSONObject webFolderResultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.webFolderGwServerURL"), webFolderUrl, null, req, "get", null);
						
						webFolderPersonalFolderId = ezWebFolderService_y.getFolderTree(userInfo.getId(), userInfo.getDeptID(),
								userInfo.getCompanyName(), "U", userInfo.getPrimary(), userInfo.getTenantId(), "", false)
								.stream().findFirst().map(FolderTreeVO::getId).orElse("");
					}
					
				}
				
				model.addAttribute("mailCapacityInfo", mailCapacityInfo);
				model.addAttribute("webFolderPersonalFolderId", webFolderPersonalFolderId);
			}

			// 2023-11-15 박기범 - 포틀릿 사이즈 조절 옵션 추가
			String usePortletSize = ezCommonService.getTenantConfig("usePortletSize", userInfo.getTenantId());
			model.addAttribute("usePortletSize", usePortletSize);
			
			returnUrl += "Theme" + usedTheme;
			logger.debug("returnUrl : " + returnUrl);
		}

		String  switchUserCompany = "";
		if (ezCommonService.getTenantConfig("switchUserCompany", userInfo.getTenantId()) != null){
			switchUserCompany = ezCommonService.getTenantConfig("switchUserCompany", userInfo.getTenantId());
			model.addAttribute("switchUserCompany", switchUserCompany);
		}
		
		//김보미 추가 - calenderMini는 ie와 크롬일 때랑 파일이 틀려서 구분값 필요함.
		boolean checkBrowser;
		if (req.getHeader("User-Agent").indexOf("Trident") > 0 || req.getHeader("User-Agent").toUpperCase().indexOf("MSIE") > 0) {
			checkBrowser = true;
		} else {
			checkBrowser = false;
		}

		if ("Y".equalsIgnoreCase(useMailServer2)){
			String MailServerURL2 = config.getProperty("config.MailServerURL2");
			model.addAttribute("MailServerURL2", MailServerURL2);
		}

		model.addAttribute("checkBrowser", checkBrowser);
		model.addAttribute("useWebHWP", ezCommonService.getTenantConfig("useWebHWP", userInfo.getTenantId()));
		model.addAttribute("companyID", companyId);
		
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
	@RequestMapping(value = "/ezNewPortal/updatePortletOrderUser.do", method=RequestMethod.POST)
	@ResponseBody
	public String updatePortletOrderUser(@RequestBody JSONObject jsonParam, HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, HttpServletResponse resp) throws Exception {
		logger.debug("updatePortletOrderUser Start");
		String result = "success";
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();
		String companyId = userInfo.getCompanyID();
		String url = "/rest/ezPortal/portlets/order/users/" + userId + "?companyId=" + companyId;
		
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
	@RequestMapping(value = "/ezNewPortal/getMonthlyBirthdayEmployees.do", method=RequestMethod.GET)
	@ResponseBody
	public JSONObject getMonthlyBirthdayEmployees(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, HttpServletResponse resp) throws Exception {
		logger.debug("getMonthlyBirthdayEmployees Start");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();
		String birthdayMonth = req.getParameter("birthdayMonth");
		if (!commonUtil.isIntNumber(birthdayMonth)) {
		    logger.debug("birthdayMonth is not int value");
		    return null;
		}
		String url = "/rest/ezPortal/birthday/months/" + birthdayMonth;
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
	
	/**
	 * 이달의 우수사원 정보 가져오기
	 * @param req
	 * @param model
	 * @param loginCookie
	 * @param resp
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ezNewPortal/getMonthlyBestEmployee.do", method=RequestMethod.GET)
	@ResponseBody
	public JSONObject getMonthlyBestEmployee(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, HttpServletResponse resp) throws Exception {
		logger.debug("getMonthlyBestEmployee Start");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();
		String companyID = userInfo.getCompanyID();
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userId);
		
		Calendar cal = Calendar.getInstance();
		int month = cal.get(Calendar.MONTH) + 1;
		
		String url = "/rest/ezPortal/bestEmployee/months/" + month + "/" + companyID;
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, param, req, "get", null);
		String status = resultBody.get("status").toString();
		JSONObject bestEmployee = new JSONObject();
		
		if (status.equals("ok")) {
			bestEmployee.put("bestEmployee", resultBody.get("data"));
		}
		
		logger.debug("getMonthlyBestEmployee End");
		return bestEmployee;
	}
	
	/**
	 * 포틀릿/프레임 개인 설정 화면 호출
	 */
	@RequestMapping(value = "/ezNewPortal/portletSetting.do", method=RequestMethod.GET)
	public String portletSetting(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, HttpServletResponse resp) throws Exception {

		return "/ezNewPortal/portletSetting";
	}
	
	//읽지 않은 메일, 결재할 문서, 전자설문, 오늘일정, 회람판 개수 불러오기
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ezNewPortal/unreadCounts.do", method=RequestMethod.POST)
	@ResponseBody
	public JSONObject getUnreadCounts(HttpServletRequest req, Model model,@RequestBody Map<String, Object> param, @CookieValue("loginCookie") String loginCookie, HttpServletResponse resp) throws Exception {
		logger.debug("getUnreadCounts Start");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();
		String companyId = userInfo.getCompanyID();
		String deptId = userInfo.getDeptID();
		String url = "/rest/ezPortal/settingInfo/unreadCounts/users/" + userId + "?companyId=" + companyId + "&deptId=" + deptId;
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, param, req, "get", null);
		String status = resultBody.get("status").toString();
		JSONObject unreadCounts = new JSONObject();
		
		if (status.equals("ok")) {
			JSONObject data = (JSONObject) resultBody.get("data");
//			unreadCounts.put("pollCount", data.get("pollCount"));
			unreadCounts.put("surveyCnt", data.get("surveyCnt"));
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
	@RequestMapping(value = "/ezNewPortal/userThemeSetting.do", method=RequestMethod.GET)
	public String userThemeSetting(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, HttpServletResponse resp) throws Exception {
		logger.debug("userThemeSetting Start");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("companyId", userInfo.getCompanyID());
		param.put("deptId", userInfo.getDeptID());

		//사용자가 선택 가능한 테마 목록 불러오기
		String themeUrl = "/rest/ezPortal/themes/users/" + userId;
		JSONObject themeResultBody = commonUtil.getJsonFromRestApi(themeUrl, param, req, "get", null);
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
			
			String userLang = userInfo.getLang();
			String imgFolder = "kr";
			
			if (userLang.equals("2")) {
				imgFolder = "us";
			} else if (userLang.equals("3")) {
				imgFolder = "jp";
			} else if (userLang.equals("4")) {
				imgFolder = "cn";
			} else if (userLang.equals("5")) {
				imgFolder = "vn";
			} else if (userLang.equals("6")) {
				imgFolder = "id";
			}
			
			model.addAttribute("usedTheme", usedTheme);
			model.addAttribute("themeList", themeList);
			model.addAttribute("imgFolder", imgFolder);
		}
		
		logger.debug("userThemeSetting End");
		return "/ezNewPortal/userThemeSetting";
	}
	
	//초기화면 설정 화면 호출
	@RequestMapping(value = "/ezNewPortal/userStartPageSetting.do", method=RequestMethod.GET)
	public String userStartPageSetting(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, HttpServletResponse resp) throws Exception {
		logger.debug("userStartPageSetting Start");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();
		
		//초기화면으로 설정할 수 있는 메뉴 호출
		String companyId = userInfo.getCompanyID();
		String deptId = userInfo.getDeptID();
		String jobId = StringUtils.isNotBlank(userInfo.getJobId()) ? userInfo.getJobId() : "";
		String menuUrl = "/rest/ezPortal/menus/users/" + userId + "?companyId=" + companyId + "&deptId=" + deptId + "&jobId=" + jobId;
		JSONObject menuResultBody = commonUtil.getJsonFromRestApi(menuUrl, null, req, "get", null);
		String menuStatus = menuResultBody.get("status").toString();

		if (menuStatus.equals("ok")) {
			JSONObject data = (JSONObject) menuResultBody.get("data");
			
			//logger.debug("TopMenu : " + data.toJSONString()); // 로그정리 : newPortalTopMenu.do (탑메뉴 호출함수)에서 찍어주고 있음으로 주석
			model.addAttribute("menuList", data.get("menuList"));
		}
		
		//현재 사용중인 초기화면 호출
		String startPageUrl = "/rest/ezPortal/startpage/users/" + userId + "?companyId=" + companyId + "&deptId=" + deptId;
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
	@RequestMapping(value = "/ezNewPortal/updateUserStartPage.do", method=RequestMethod.POST)
	@ResponseBody
	public void updateUserStartPage(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, HttpServletResponse resp) throws Exception {
		logger.debug("updateUserStartPage Start");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();
		int menuId = Integer.parseInt(req.getParameter("menuId"));
		String companyId = userInfo.getCompanyID();
		String url = "/rest/ezPortal/startpage/menus/" + menuId + "/users/" + userId + "?companyId=" + companyId;
		
		commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, null, req, "patch", null);
		
		logger.debug("updateUserStartPage End");
	}
	
	//테마 초기화 실행 함수
	@RequestMapping(value = "/ezNewPortal/deleteUserThemeSetting.do", method=RequestMethod.POST)
	@ResponseBody
	public void deleteUserThemeSetting(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, HttpServletResponse resp) throws Exception {
		logger.debug("deleteUserThemeSetting Start");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();
		String companyId = userInfo.getCompanyID();
		String url = "/rest/ezPortal/themes/users/" + userId + "?companyId=" + companyId;
		
		commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, null, req, "delete", null);
		
		logger.debug("deleteUserThemeSetting End");
	}
	
	//사용자 기본 테마 설정 실행 함수
	@RequestMapping(value = "/ezNewPortal/updateUserThemeSetting.do", method=RequestMethod.POST)
	@ResponseBody
	public void updateUserThemeSetting(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, HttpServletResponse resp) throws Exception {
		logger.debug("updateUserThemeSetting Start");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();
		int themeId = Integer.parseInt(req.getParameter("themeId"));
		String companyId = userInfo.getCompanyID();
		String deptId = userInfo.getDeptID();
		String url = "/rest/ezPortal/themes/" + themeId + "/users/" + userId + "?companyId=" + companyId;
		
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
	@RequestMapping(value = "/ezNewPortal/progress.do", method=RequestMethod.GET)
	public String progress() {
		return "/ezNewPortal/portalProgress";
	}

	/**
	 * 포탈 ActiveX 다운로드 목록 호출 함수
	 */
	@RequestMapping(value = "/ezNewPortal/componentListTransfer.do", produces="text/xml;charset=utf-8", method=RequestMethod.GET)
	@ResponseBody
	public String componentListTransfer(HttpServletRequest request, HttpServletResponse response) throws Exception {
		StringBuilder result = new StringBuilder();
		String realPath = commonUtil.getRealPath(request); 
		String path = "xml" + commonUtil.separator + "ezPortal" + commonUtil.separator + "componentlist.xml";
		path = realPath + commonUtil.separator + path;
		try {
			path = commonUtil.detectPathTraversal(path);
			
			File file = new File(path);
			// CWE-404 보안 취약점 대응
			try (BufferedReader br = new BufferedReader(new FileReader(file))) {
				String line = null;
		
				while ((line = br.readLine()) != null) {
					result.append(line);
				}
			}
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		logger.debug("downloadServer="+result.toString().replace("DOWNLOADSERVER", request.getRequestURL().substring(0, request.getRequestURL().indexOf(request.getRequestURI()))));
		return result.toString().replace("DOWNLOADSERVER", request.getRequestURL().substring(0, request.getRequestURL().indexOf(request.getRequestURI())));
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ezNewPortal/getPortalInfo.do", method=RequestMethod.GET)
	@ResponseBody
	public JSONObject getPortalInfo(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, HttpServletResponse resp) throws Exception {
		logger.debug("getPortalInfo Start");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();
		String companyId = userInfo.getCompanyID();
		String deptId = userInfo.getDeptID();
		String jobId = StringUtils.isNotBlank(userInfo.getJobId()) ? userInfo.getJobId() : "";
		String url = "/rest/ezPortal/settingInfo/users/" + userId + "?companyId=" + companyId + "&deptId=" + deptId + "&jobId=" + jobId;
		JSONObject resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, null, req, "get", null);
		String status = resultBody.get("status").toString();
		String serverTime = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), userInfo.getOffset(), false);
		Calendar cal = Calendar.getInstance();
		String nowMonth = String.valueOf(cal.get(Calendar.MONTH)+1);
		
		JSONObject result = new JSONObject();
		
		if (status.equals("ok")) {
			JSONObject data = (JSONObject) resultBody.get("data");
			result = data;
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
			model.addAttribute("useEzWorkspace", data.get("useEzWorkspace"));
			model.addAttribute("lastLogin", data.get("lastLogin"));
			model.addAttribute("userEmail", data.get("userEmail"));
			model.addAttribute("userId", userId);
			model.addAttribute("usePortalAutoRefreshInterval", data.get("usePortalAutoRefreshInterval"));
			
		}
		
		//김보미 추가 - calenderMini는 ie와 크롬일 때랑 파일이 틀려서 구분값 필요함.
		boolean checkBrowser;
		if (req.getHeader("User-Agent").indexOf("Trident") > 0 || req.getHeader("User-Agent").toUpperCase().indexOf("MSIE") > 0) {
			checkBrowser = true;
		} else {
			checkBrowser = false;
		}
		
		result.put("checkBrowser", checkBrowser);
		
		logger.debug("getPortalInfo End");
		return result;
	}
	
	/**
	 * 2019-01-03 김민성
	 * 포탈 - 웹가이드 메인 화면 호출 함수
	 */
	@RequestMapping(value = "/ezNewPortal/help/index.do", method=RequestMethod.GET)
	public String help(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req) throws Exception {
		logger.debug("help started");

		/*
		String topMenuID = "";
		if (req.getParameter("topMenuID") != null && !req.getParameter("topMenuID").equals("")) {
			topMenuID = req.getParameter("topMenuID");
		}
				
		model.addAttribute("lang", userInfo.getLang());
		model.addAttribute("topMenuID", topMenuID);*/
		
		userInfo = commonUtil.userInfo(loginCookie);
		String packageType = commonUtil.getPackageType(userInfo.getTenantId());
		logger.debug("packageType : " + packageType);
		model.addAttribute("packageType", packageType);
		
		logger.debug("help ended");
		return "/ezNewPortal/help/index";
	}
	
	@RequestMapping(value = "/ezNewPortal/help/sub1-1.do", method=RequestMethod.GET)
	public String sub11(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req) throws Exception {
		return "/ezNewPortal/help/sub1-1";
	}
	
	@RequestMapping(value = "/ezNewPortal/help/sub1-2.do", method=RequestMethod.GET)
	public String sub12(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req) throws Exception {
		return "/ezNewPortal/help/sub1-2";
	}
	
	@RequestMapping(value = "/ezNewPortal/help/sub2-1.do", method=RequestMethod.GET)
	public String sub21(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req) throws Exception {
		return "/ezNewPortal/help/sub2-1";
	}
	
	@RequestMapping(value = "/ezNewPortal/help/sub2-2.do", method=RequestMethod.GET)
	public String sub22(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req) throws Exception {
		return "/ezNewPortal/help/sub2-2";
	}
	
	@RequestMapping(value = "/ezNewPortal/help/sub2-3.do", method=RequestMethod.GET)
	public String sub23(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req) throws Exception {
		return "/ezNewPortal/help/sub2-3";
	}
	
	@RequestMapping(value = "/ezNewPortal/help/sub3-1.do", method=RequestMethod.GET)
	public String sub31(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req) throws Exception {
		return "/ezNewPortal/help/sub3-1";
	}
	
	@RequestMapping(value = "/ezNewPortal/help/sub3-2.do", method=RequestMethod.GET)
	public String sub32(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req) throws Exception {
		return "/ezNewPortal/help/sub3-2";
	}
	
	@RequestMapping(value = "/ezNewPortal/help/sub3-3.do", method=RequestMethod.GET)
	public String sub33(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req) throws Exception {
		return "/ezNewPortal/help/sub3-3";
	}
	
	@RequestMapping(value = "/ezNewPortal/help/sub4-1.do", method=RequestMethod.GET)
	public String sub41(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req) throws Exception {
		return "/ezNewPortal/help/sub4-1";
	}
	
	@RequestMapping(value = "/ezNewPortal/help/sub4-2.do", method=RequestMethod.GET)
	public String sub42(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req) throws Exception {
		return "/ezNewPortal/help/sub4-2";
	}
	
	@RequestMapping(value = "/ezNewPortal/help/sub4-3.do", method=RequestMethod.GET)
	public String sub43(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req) throws Exception {
		return "/ezNewPortal/help/sub4-3";
	}
	
	@RequestMapping(value = "/ezNewPortal/help/sub5-1.do", method=RequestMethod.GET)
	public String sub51(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req) throws Exception {
		return "/ezNewPortal/help/sub5-1";
	}
	
	@RequestMapping(value = "/ezNewPortal/help/sub5-2.do", method=RequestMethod.GET)
	public String sub52(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req) throws Exception {
		return "/ezNewPortal/help/sub5-2";
	}
	
	@RequestMapping(value = "/ezNewPortal/help/sub5-3.do", method=RequestMethod.GET)
	public String sub53(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req) throws Exception {
		return "/ezNewPortal/help/sub5-3";
	}
	
	@RequestMapping(value = "/ezNewPortal/help/sub6-1.do", method=RequestMethod.GET)
	public String sub61(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req) throws Exception {
		return "/ezNewPortal/help/sub6-1";
	}
	
	@SuppressWarnings("unchecked")
	@GetMapping(value = "/ezNewPortal/allUserTab.do", produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public JSONObject getAllUserTab(@CookieValue("loginCookie") String loginCookie) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		JSONObject jsonResult = new JSONObject();
		
		String lang = commonUtil.getPrimaryData(userInfo.getLang(), userInfo.getTenantId());
		List<PortalUserSwitchVO> arrayUserJob = ezNewPortalService.getArrayUserJob(lang, userInfo.getId(), userInfo.getTenantId());
		arrayUserJob.forEach(vo -> {
			if ((StringUtils.isBlank(userInfo.getJobId()) && StringUtils.isBlank(vo.getJobId())) || (vo.getCompanyId().equals(userInfo.getCompanyID())
					&& vo.getDeptId().equals(userInfo.getDeptID()) && vo.getJobId().equals(userInfo.getJobId()))) {
				vo.setCurr(true);
				jsonResult.put("currJobInfo", vo);
			} else {
				vo.setCurr(false);
			}
		});
		
		jsonResult.put("userJobList", arrayUserJob);
		jsonResult.put("userName", userInfo.getDisplayName());
		jsonResult.put("userName2", userInfo.getDisplayName2());
		
		return jsonResult;
	}

	@PostMapping(value = "/ezNewPortal/switchAllUserInfo.do", consumes = MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public String switchAllUserInfo(@CookieValue("loginCookie") String loginCookie, @RequestBody PortalUserSwitchVO vo, HttpServletResponse response,
							   HttpServletRequest request) throws Exception {

		ezNewPortalService.switchAllUserInfo(request, response, loginCookie,
				vo.getCompanyId(), vo.getDeptId(), vo.getJobId(), vo.getJobType());
		return "true";
	}
    
    @GetMapping(value = "/ezNewPortal/boardItemListToTopMenu.do")
    @ResponseBody
    public JSONObject boardItemListToTopMenu(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) {
    	logger.debug("started boardItemListToTopMenu");
    	
    	JSONObject json = new JSONObject();
    	LoginVO userInfo = commonUtil.userInfo(loginCookie);
    	String boardId = request.getParameter("boardId") != null ? request.getParameter("boardId") : "";
    	int startRow = 0;
    	int itemCount = 10;
    	try {
    		if ("".equals(boardId)) {
    			throw new Exception();
    		}
			BoardPropertyVO boardPropertyVO = ezBoardService.getBoardProperty(boardId, userInfo.getTenantId());
			String guBun = boardPropertyVO.getGuBun();
			// Q&A 의 일반 유저일 경우 일반 게시판과 다른 리스트
			boolean isQnANormal = "5".equals(guBun);
			if (isQnANormal) {
				// 관리자가 아니면 Q&A 게시판 로직으로 변경
				isQnANormal = !ezBoardService.isBoardAdmin(boardId, userInfo.getId(), userInfo.getDeptID(), userInfo.getCompanyID(), userInfo.getTenantId(), userInfo.getRollInfo());
			}
	
			List<BoardListVO> boardList = null;
			// 권한이 true이면 boardList불러오기
			if (boardId.equals("{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}")) { // 새 게시물일 때
				boolean isAdmin = ezBoardService.isBoardAdmin(boardId, userInfo.getId(), userInfo.getDeptID(), userInfo.getCompanyID(), userInfo.getTenantId(), userInfo.getRollInfo());
				String boardUserType = isAdmin ? "admin" : "user";
				boardList = ezNewPortalService.getNewBoardPortletInfo(userInfo, boardUserType, startRow, itemCount);
			} else {
				boardList = ezNewPortalService.getBoardPortletInfo(userInfo.getId(), userInfo.getTenantId(), boardId, itemCount, userInfo.getCompanyID(), userInfo.getOffset(), isQnANormal);
			}
			
			json.put("status", "ok");
			json.put("message", "success");
			json.put("boardList", boardList);
    	} catch (Exception e) {
    		logger.debug("error in boardItemListToTopMenu");
    		logger.error(e.getMessage(), e);
    		json.put("status", "fail");
    		json.put("message", "fail to get boardItem");
    	}
    	
    	logger.debug("ended boardItemListToTopMenu");
    	return json;
    }

	@ResponseBody
	@GetMapping(value = "/ezNewPortal/allCount.do")
	public ResponseEntity<String> getPortalAllCount(@CookieValue String loginCookie, HttpServletRequest request, Locale locale) {

		logger.debug("allCount started");

		JSONObject result = new JSONObject();

		try {
			LoginVO userInfo = commonUtil.userInfo(loginCookie);
			int tenantID = userInfo.getTenantId();
			String userID = userInfo.getId();
			String companyID = userInfo.getCompanyID();
			String lang = userInfo.getLang();
			String deptID = userInfo.getDeptID();
			userInfo = commonUtil.userInfo(loginCookie);
			
			// 메뉴 권한
			List<MenuInfoVO> menuList = ezNewPortalService.getUserMenuList(companyID, tenantID, lang, userID, deptID);
			String useBoard = ezCommonService.getTenantConfig("useBoard", tenantID);
			String useExternalMailServer = ezCommonService.getTenantConfig("useExternalMailServer", tenantID);
			String useApproval = "";
			String useMail = "";
			String userEmail = userID + "@" + ezCommonService.getTenantConfig("DomainName", tenantID);
			String password = jspw;

			int newBoardCnt = 0;
			int approvalCount = 0;
			int unreadMailCount = 0;
			
			// 결재 사용여부
			for (MenuInfoVO mVO : menuList) {
				if (mVO.getMenuCode() != null && mVO.getMenuCode().equals("approval")) {
					useApproval = "YES";
				}
			}
			
			// 게시판 사용여부
			if (useBoard == null || useBoard.equals("")) {
				useBoard = "YES";
			}
			
			// 메일 사용여부
			if(useExternalMailServer.equalsIgnoreCase("YES")) {
				useMail = "NO";
			} else {
				useMail = "YES";
			}
			
			// 갹 메뉴별 권한에 따른 카운트
			if (useBoard.equals("YES")) {
				String boardId = "{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}";
				boolean isAdmin = ezBoardService.isBoardAdmin(boardId, userID, deptID,companyID, tenantID, userInfo.getRollInfo());
				String boardUserType = isAdmin ? "admin" : "user";
				newBoardCnt = ezBoardService.getNewItemListCount(userInfo);
			}

			if (useApproval.equals("YES")){
				String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", tenantID);
				approvalCount = ezNewPortalService.getApprovalDoingListCount(userID, companyID, tenantID, userInfo.getOffset(), approvalFlag, lang);
			}

			if (useMail.equals("YES")) {
				try {

					String url = "/rest/ezPortal/portlets/unreadMailCount";

					HashMap<String, Object> param = new HashMap<String, Object>();
					param.put("userEmail", userEmail);
					param.put("password", password);
					param.put("locale", locale);

					String useMailServer2 =  config.getProperty("config.useMailServer2");

					JSONObject resultBody = commonUtil.getJsonFromRestApi(url, param, request, "get", null);
					if ("Y".equalsIgnoreCase(useMailServer2)){
						resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.MailServerURL2"), url, param, request, "get", null);
					}

					String result2 = resultBody.get("status").toString();
					if (result2.equals("ok")) {
						String mailCount = String.valueOf(resultBody.get("unreadMailCount"));
						unreadMailCount = Integer.parseInt(mailCount);
						logger.debug("unreadMailCount = " + unreadMailCount);
					}
				} catch (Exception e) {
					logger.debug("e.message=" + e.getMessage());
				}
			}

			result.put("status", "ok");
			result.put("code", 0);
			result.put("newBoardCnt", newBoardCnt);
			result.put("approvalCnt", approvalCount);
			result.put("unreadMailCount", unreadMailCount);
			
		} catch (Exception e) {
			logger.error(e.getMessage(), e);

			result.put("status", "error");
			result.put("code", 1);
			result.put("message", "unread mail count failed");
		}
		
		logger.debug("allCount End");

		return new ResponseEntity<>(result.toString(), HttpStatus.OK);
	}
	
	// 2024-08-21 조수빈 - 사용자 테마/모드 설정 화면 저장
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ezNewPortal/updateUserThemeAndMode.do", method=RequestMethod.POST)
	@ResponseBody
	public String updateUserThemeAndMode(HttpServletRequest req, HttpServletResponse res, @RequestBody JSONObject jObj ,Model model, @CookieValue("loginCookie") String loginCookie, HttpServletResponse resp) throws Exception {
		logger.debug("updateUserThemeAndMode Start");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();
		String companyId = userInfo.getCompanyID();
		String result = "success";
		Map<String, Object> jsonMap = (Map<String, Object>) jObj.get("param");
		int themeId = (int) jsonMap.get("themeId");
		int menuDisplayMode = (int) jsonMap.get("menuDisplayMode");
		int useColor = (int) jsonMap.get("useColor");
		
		// 테마 저장
		String themeUrl = "/rest/ezPortal/themes/" + themeId + "/users/" + userId + "?companyId=" + companyId;
		JSONObject themeResultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), themeUrl, null, req, "patch", jObj);
		String themeStatus = themeResultBody.get("status").toString();
		
		// 모드(색상) 저장
		String modeUrl = "/rest/ezPortal/colorMode/" + useColor + "/users/" + userId + "?companyId=" + companyId;
		JSONObject modeResultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), modeUrl, null, req, "post", jObj);
		String modeStatus = modeResultBody.get("status").toString();
		
		// 메뉴 위치 저장
		String menuUrl = "/rest/ezPortal/setMenuDisplayMode/users/" + userId + "?companyId=" + companyId + "&menuDisplayMode=" + menuDisplayMode;
		JSONObject menuResultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), menuUrl, null, req, "post", jObj);
		String menuStatus = menuResultBody.get("status").toString();
		
		
		logger.debug("themeStatus" + themeStatus + ", modeStatus" + modeStatus + ", menuStatus" + menuStatus);
		
		if(themeStatus.equals("error") || modeStatus.equals("error") || menuStatus.equals("error")) {
			result = "failure";
		}
		
		// 2024-08-28 조수빈 - 유저 색상 테마 정보
		Cookie useColorCk = new Cookie("useColor", Integer.toString(useColor));
		useColorCk.setPath("/");
		res.addCookie(useColorCk);
		
		logger.debug("updateUserThemeAndMode End");
		return result;
	}	
}
