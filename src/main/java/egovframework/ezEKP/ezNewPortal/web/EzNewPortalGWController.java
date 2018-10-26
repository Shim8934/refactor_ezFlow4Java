package egovframework.ezEKP.ezNewPortal.web;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;
import java.util.TimeZone;

import javax.annotation.Resource;
import javax.mail.Flags;
import javax.mail.Folder;
import javax.mail.Message;
import javax.mail.UIDFolder;
import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGService;
import egovframework.ezEKP.ezApprovalG.vo.ApprGFormVO;
import egovframework.ezEKP.ezBoard.service.EzBoardAdminService;
import egovframework.ezEKP.ezBoard.service.EzBoardService;
import egovframework.ezEKP.ezBoard.vo.BoardItemVO;
import egovframework.ezEKP.ezBoard.vo.BoardListVO;
import egovframework.ezEKP.ezBoard.vo.BoardMyFavoriteVO;
import egovframework.ezEKP.ezBoard.web.EzBoardController;
import egovframework.ezEKP.ezCircular.service.EzCircularService;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezCommunity.vo.CommunityMyCommunityVO;
import egovframework.ezEKP.ezEmail.logic.IMAPAccess;
import egovframework.ezEKP.ezEmail.util.EzEmailUtil;
import egovframework.ezEKP.ezNewPortal.service.EzNewPortalService;
import egovframework.ezEKP.ezNewPortal.vo.FavoriteBoardVO;
import egovframework.ezEKP.ezNewPortal.vo.FrameInfoVO;
import egovframework.ezEKP.ezNewPortal.vo.MenuInfoVO;
import egovframework.ezEKP.ezNewPortal.vo.MenuNameVO;
import egovframework.ezEKP.ezNewPortal.vo.PortalUserInfoVO;
import egovframework.ezEKP.ezNewPortal.vo.PortletInfoVO;
import egovframework.ezEKP.ezNewPortal.vo.PortletNameInfoVO;
import egovframework.ezEKP.ezNewPortal.vo.ThemeInfoVO;
import egovframework.ezEKP.ezNewPortal.vo.UserPortalSettingVO;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.ezEKP.ezPersonal.service.EzPersonalService;
import egovframework.ezEKP.ezPersonal.vo.PersonalGetPopUpListUserVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalLightPollVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalSliderImageVO;
import egovframework.ezEKP.ezPoll.vo.PollAnswerVO;
import egovframework.ezEKP.ezPoll.vo.PollQuestionVO;
import egovframework.ezEKP.ezQuestion.service.EzQuestionService;
import egovframework.ezEKP.ezSchedule.service.EzScheduleService;
import egovframework.ezEKP.ezSchedule.vo.ScheduleCumulerVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleDeptVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleGroupListVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleInfoVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleSecretaryVO;
import egovframework.ezMobile.ezOption.service.MOptionService;
import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@RestController
public class EzNewPortalGWController {
	private static final Logger LOGGER = LoggerFactory.getLogger(EzNewPortalGWController.class);

	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private EzEmailUtil ezEmailUtil;

	@Autowired
	private EzCommonService ezCommonService;

	@Resource(name = "jspw")
	private String jspw;

	@Autowired
	private LoginService loginService;

	@Resource(name = "EzNewPortalService")
	private EzNewPortalService ezNewPortalService;

	@Resource(name = "EzBoardService")
	private EzBoardService ezBoardService;

	@Resource(name = "EzBoardAdminService")
	private EzBoardAdminService ezBoardAdminService;

	@Resource(name = "MOptionService")
	private MOptionService mOptionService;

	@Resource(name = "EzBoardController")
	private EzBoardController ezBoardController;

	@Resource(name = "EzPersonalService")
	private EzPersonalService ezPersonalService;

	@Resource(name = "EzCircularService")
	private EzCircularService ezCircularSerivce;

	@Resource(name = "EzQuestionService")
	private EzQuestionService ezQuestionService;

	@Resource(name = "EzScheduleService")
	private EzScheduleService ezScheduleService;

	@Resource(name = "EzApprovalGService")
	private EzApprovalGService ezApprovalGSerivce;

	@Autowired
	private Properties config;

	@Autowired
	private EzOrganService ezOrganService;

	@Autowired
	private EzOrganAdminService ezOrganAdminService;

	@Resource(name = "egovMessageSource")
	private EgovMessageSource egovMessageSource;

	// ///사용자///////
	/**
	 * 포탈개인화 G/W [GET] 사용자별 개인화 정보 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPortal/settingInfo/users/{userId}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getUserPortalSetting(HttpServletRequest request, @PathVariable String userId, Locale locale) throws Exception {
		LOGGER.debug("ezNewPortal G/W getUserPortalSetting started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			String companyId = info.getCompanyId();
			int tenantId = info.getTenantId();
			String portletLang = info.getLang();
			LOGGER.debug("userId : " + userId + ", companyId : " + companyId + ", tenantId : " + tenantId + "portletLang : " + portletLang);
			
			// 사용자 설정 테마/프레임 가져오기
			UserPortalSettingVO userThemeSetting = ezNewPortalService.getUserPortalSetting(userId, companyId, tenantId);
			LOGGER.debug("usedTheme : " + userThemeSetting.getUsedTheme() + ", usedFrame : " + userThemeSetting.getUsedFrame());
			
			// 사용자 포틀릿 순서 가져오기
			List<PortletInfoVO> portletOrder = ezNewPortalService.getPortletOrderUser(portletLang, userId, tenantId, companyId);

			// 사용자 설정 포틀릿 순서가 없으면 회사의 포틀릿 순서를 따름
			if (portletOrder.isEmpty()) {
				portletOrder = ezNewPortalService.getPortletOrderComp(portletLang, tenantId, companyId);
			}

			// 회사의 슬라이더 이미지 가져오기
			List<PersonalSliderImageVO> sliderList = ezPersonalService.getSilderList(companyId, "USER", null, tenantId);

			String userName = "";
			String userTitle = "";
			String deptName = "";
			String userPhoto = "";

			// 회원정보 불러오기
			if (portletLang.equals("1")) {
				userName = info.getUserName();
				userTitle = info.getTitle();
				deptName = info.getDeptName();
			} else {
				userName = info.getUserName2();
				userTitle = info.getTitle2();
				deptName = info.getDeptName2();
			}
			
			// 유저이미지
			String imgUrl = ezOrganService.getPropertyValue(userId, "extensionAttribute2", tenantId);

			if (imgUrl != null && !imgUrl.equals("")) {
				userPhoto = commonUtil.getUploadPath("upload_personal.PHOTO", tenantId) + commonUtil.separator + imgUrl;
			}

			// 메일, 결재, 일정, 전자설문, 회람판, 근태관리 권한이 있는지 확인
			String useAttitude = "";
			String useQuestion = "";
			String useCircular = "";
			String useMail = "";
			String useApproval = "";
			String useSchedule = "";

			// 1. tenantConfig가 YES인지 -- 회람판(USE_CIRCULAR), 근태관리(USE_ATTITUDE),
			// 전자설문(useQuestion)
			useAttitude = ezCommonService.getTenantConfig("USE_ATTITUDE", info.getTenantId());
			useQuestion = ezCommonService.getTenantConfig("useQuestion", info.getTenantId());
			useCircular = ezCommonService.getTenantConfig("USE_CIRCULAR", info.getTenantId());
			
			// 2. 메뉴에 권한이 있는지 ================ 수정하기 start
			if (useAttitude.equals("NO")) {
				useAttitude = "NO";
			}

			if (useQuestion.equals("NO")) {
				useQuestion = "NO";
			}

			if (useCircular.equals("NO")) {
				useCircular = "NO";
			}

			useMail = "YES";
			useApproval = "YES";
			useSchedule = "YES";
			
			LOGGER.debug("useAttitude : " + useAttitude + ", useQuestion : " + useQuestion + ", useCircular : " + useCircular);
			LOGGER.debug("useMail : " + useMail + ", useApproval : " + useApproval + ", useSchedule : " + useSchedule);
			// =================================== 여기까지 end

			JSONObject data = new JSONObject();
			data.put("usedTheme", userThemeSetting.getUsedTheme());
			data.put("usedFrame", userThemeSetting.getUsedFrame());
			data.put("portletOrder", portletOrder);
			data.put("sliderList", sliderList);
			data.put("userName", userName);
			data.put("userTitle", userTitle);
			data.put("deptName", deptName);
			data.put("userPhoto", userPhoto);
			data.put("useAttitude", useAttitude);
			data.put("useQuestion", useQuestion);
			data.put("useCircular", useCircular);
			data.put("useMail", useMail);
			data.put("useApproval", useApproval);
			data.put("useSchedule", useSchedule);

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		LOGGER.debug("ezNewPortal G/W getUserPortalSetting ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [PATCH] 사용자별 포틀릿 순서 변경
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPortal/portlets/order/users/{userId}", method = RequestMethod.PATCH, produces = "application/json;charset=utf-8")
	public JSONObject updatePortletOrder(HttpServletRequest request, @PathVariable String userId, @RequestBody JSONObject jsonParam) throws Exception {
		LOGGER.debug("ezNewPortal G/W updatePortletOrder started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			List<Map<String, Integer>> portletOrder = (List<Map<String, Integer>>) jsonParam.get("updateOrder");
			String companyId = info.getCompanyId();
			int tenantId = info.getTenantId();
			String portletLang = info.getLang();
			LOGGER.debug("userId : " + userId + ", companyId : " + companyId + ", tenantId : " + tenantId + "portletLang : " + portletLang);
			
			ezNewPortalService.updatePortletOrderUser(userId, companyId, tenantId, portletOrder, portletLang);

			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		LOGGER.debug("ezNewPortal G/W updatePortletOrder ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [GET] 월별 생일 사원 목록 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPortal/birthday/months/{month}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getMonthlyBirthdayEmployees(HttpServletRequest request, @PathVariable int month) throws Exception {
		LOGGER.debug("ezNewPortal G/W getMonthlyBirthdayEmployees started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			String companyId = info.getCompanyId();
			int tenantId = info.getTenantId();
			int curPage = Integer.parseInt(request.getParameter("birthdayCurPage"));
			int count = Integer.parseInt(request.getParameter("birthdayCount"));
			int startRow = curPage * count;
			LOGGER.debug("userId : " + userId + ", companyId : " + companyId + ", tenantId : " + tenantId);
			LOGGER.debug("curPage : " + curPage + ", count : " + count + ", startRow : " + startRow);
			
			int birthdayListCount = ezNewPortalService.getMonthlyBirthdayEmployeesCount(companyId, tenantId, month);
			List<PortalUserInfoVO> birthdayList = ezNewPortalService.getMonthlyBirthdayEmployees(companyId, tenantId, month, count, startRow);
			
			LOGGER.debug("birthdayListCount : " + birthdayListCount);
			int birthdayCurPage = 0;

			if (birthdayListCount != 0) {
				if (startRow > birthdayListCount) {
					birthdayCurPage = 0;
				} else {
					birthdayCurPage += 1;
				}
			}

			JSONObject data = new JSONObject();
			data.put("birthdayList", birthdayList);
			data.put("birthdayListCount", birthdayListCount);
			data.put("birthdayCurPage", birthdayCurPage);

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		LOGGER.debug("ezNewPortal G/W getMonthlyBirthdayEmployees ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [GET] 이달의 우수 사원 정보 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPortal/bestEmployee/months/{month}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getMonthlyBestEmployee(HttpServletRequest request, @PathVariable int month) throws Exception {
		LOGGER.debug("ezNewPortal G/W getMonthlyBestEmployee started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			Calendar cal = Calendar.getInstance();
			String nowYear = String.valueOf(cal.get(Calendar.YEAR));

			String yearAndMonth = nowYear + "-" + month;
			String companyId = info.getCompanyId();
			int tenantId = info.getTenantId();
			
			LOGGER.debug("yearAndMonth : " + yearAndMonth);
			PortalUserInfoVO bestEmployee = ezNewPortalService.getMonthlyBestEmployee(yearAndMonth, companyId, tenantId);

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", bestEmployee);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		LOGGER.debug("ezNewPortal G/W getMonthlyBestEmployee ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [GET] 사용자별 테마 목록 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPortal/themes/users/{userId}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getUserThemeList(HttpServletRequest request, @PathVariable String userId) throws Exception {
		LOGGER.debug("ezNewPortal G/W getUserThemeList started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			String companyId = info.getCompanyId();
			int tenantId = info.getTenantId();
			LOGGER.debug("userId : " + userId + ", companyId : " + companyId + ", tenantId : " + tenantId);
			
			// List<ThemeInfoVO> userThemeList =
			// ezNewPortalService.getUserThemeListr(companyId, tenantId);
			List<ThemeInfoVO> userThemeList = ezNewPortalService.getThemes(false, companyId, tenantId);

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", userThemeList);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		LOGGER.debug("ezNewPortal G/W getUserThemeList ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [GET] 사용자별 메뉴 정보 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPortal/menus/users/{userId}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getUserMenuList(HttpServletRequest request, @PathVariable String userId) throws Exception {
		LOGGER.debug("ezNewPortal G/W getUserMenuList started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			String companyId = info.getCompanyId();
			int tenantId = info.getTenantId();
			String langType = info.getLang();
			String logoType = "portal";
			JSONObject data = new JSONObject();
			/**
			 * 1) 로고
			 */
			String logoUrl = ezNewPortalService.getPortalLogoInfo(companyId, tenantId, logoType);
			LOGGER.debug("logoUrl : " + logoUrl);

			/**
			 * 2) 메인메뉴 및 서브메뉴 - 권한체크 - user 순서가 없을 경우 회사 순서로 진행
			 */
			List<MenuInfoVO> userMenuList = ezNewPortalService.getUserMenuList(companyId, tenantId, langType, userId);
			List<MenuInfoVO> compMenuList = new ArrayList<MenuInfoVO>();
			LOGGER.debug("list.toString() : " + userMenuList.toString());
			if (userMenuList.size() == 0) {
				compMenuList = ezNewPortalService.getCompanyMenuList(companyId, tenantId, langType);
				data.put("menuList", compMenuList);
			} else {
				data.put("menuList", userMenuList);
			}
			/**
			 * 3) 유틸메뉴 - 관리자 권한의 유무 - DB에서 가져오지 말고 그냥 다 출력
			 */
			String roleInfo = "user";
			if (info.getRollInfo().indexOf("c=1") > -1 || info.getRollInfo().indexOf("k=1") > -1) {
				roleInfo = "admin";
				// 권한 없는 사람이 강제로 주소를 치고 들어가는 상황을 대비해 admin 주소는 서버에서 올리는 걸로.
				data.put("utilAdminUrl", "/admin/main.do");
			}
			
			/**
			 * 4) 팝업 공지
			 */
			List<PersonalGetPopUpListUserVO> popupNotiList = ezPersonalService.getPopUpListUser(companyId, tenantId);
			data.put("popupNotiList", popupNotiList);
			
			data.put("logoUrl", logoUrl);
			data.put("roleInfo", roleInfo);
			LOGGER.debug("TopMenu Data : " + data.toJSONString());
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		LOGGER.debug("ezNewPortal G/W getUserMenuList ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [PATCH] 개인 메뉴 순서 변경
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPortal/menus/order/users/{userId}", method = RequestMethod.PATCH, produces = "application/json;charset=utf-8")
	public JSONObject updateUserMenuOrder(HttpServletRequest request, @PathVariable String userId, @RequestBody JSONObject jObj) throws Exception {
		LOGGER.debug("ezNewPortal G/W updateUserMenuOrder started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);	
			String companyId = info.getCompanyId();
			int tenantId = info.getTenantId();
			String langType = info.getLang();			
			JSONObject data = new JSONObject();

			ezNewPortalService.updateUserMenuOrder(info.getCompanyId(), info.getTenantId(), userId, jObj);
			
			// 리스트 다시 받아서 출력
			List<MenuInfoVO> userMenuList = ezNewPortalService.getUserMenuList(companyId, tenantId, langType, userId);
			// List<MenuInfoVO> compMenuList = new ArrayList<MenuInfoVO>();

			data.put("menuList", userMenuList);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		LOGGER.debug("ezNewPortal G/W updateUserMenuOrder ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [DELETE] 개인 메뉴 순서 초기화
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPortal/menus/order/users/{userId}", method = RequestMethod.DELETE, produces = "application/json;charset=utf-8")
	public JSONObject deleteUserMenuOrder(HttpServletRequest request, @PathVariable String userId) throws Exception {
		LOGGER.debug("ezNewPortal G/W deleteUserMenuOrder started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			String companyId = info.getCompanyId();
			int tenantId = info.getTenantId();
			String langType = info.getLang();			
			JSONObject data = new JSONObject();
			
			ezNewPortalService.deleteUserMenuOrder(info.getCompanyId(), info.getTenantId(), userId);
			// 초기화 하면 회사에서 지정한 메뉴 순서로 출력
			List<MenuInfoVO> compMenuList = ezNewPortalService.getCompanyMenuList(companyId, tenantId, langType);
			
			LOGGER.debug("comMenuList: " + compMenuList.toString());
			
			data.put("menuList", compMenuList);
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		LOGGER.debug("ezNewPortal G/W deleteUserMenuOrder ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [GET] 퀵링크 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPortal/quickLink/company/{companyId}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getQuickLinkList(HttpServletRequest request, @PathVariable String companyId) throws Exception {
		LOGGER.debug("ezNewPortal G/W getQuickLinkList started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));

			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		LOGGER.debug("ezNewPortal G/W getQuickLinkList ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [GET] 테마 프레임 리스트 및 사용자 지정 프레임 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPortal/frames/users/{userId}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getUserFrameList(HttpServletRequest request, @PathVariable String userId) throws Exception {
		LOGGER.debug("ezNewPortal G/W getUserFrameList started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);

			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		LOGGER.debug("ezNewPortal G/W getUserFrameList ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [PATCH] 사용자 프레임 설정
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPortal/frames/users/{userId}", method = RequestMethod.PATCH, produces = "application/json;charset=utf-8")
	public JSONObject updateUserFrame(HttpServletRequest request, @PathVariable String userId) throws Exception {
		LOGGER.debug("ezNewPortal G/W updateUserFrame started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);

			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		LOGGER.debug("ezNewPortal G/W updateUserFrame ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [GET] 포틀릿 개인별 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPortal/portlets/users/{userId}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getPortletList(HttpServletRequest request, @PathVariable String userId) throws Exception {
		LOGGER.debug("ezNewPortal G/W getPortletList started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);

			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		LOGGER.debug("ezNewPortal G/W getPortletList ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [PATCH] 포틀릿 개인별 사용/미사용 설정
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPortal/portlets/users/{userId}", method = RequestMethod.PATCH, produces = "application/json;charset=utf-8")
	public JSONObject updateUserPortletSetting(HttpServletRequest request, @PathVariable String userId) throws Exception {
		LOGGER.debug("ezNewPortal G/W updateUserPortletSetting started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);

			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		LOGGER.debug("ezNewPortal G/W updateUserPortletSetting ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [PATCH] 사용자별 테마 적용
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPortal/themes/{themeId}/users/{userId}", method = RequestMethod.PATCH, produces = "application/json;charset=utf-8")
	public JSONObject updateUserThemeSetting(HttpServletRequest request, @PathVariable String userId, @PathVariable int themeId) throws Exception {
		LOGGER.debug("ezNewPortal G/W updateUserThemeSetting started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			String companyId = info.getCompanyId();
			int tenantId = info.getTenantId();
			int frameDefault = Integer.parseInt(request.getParameter("frameDefault"));
			LOGGER.debug("userId : " + userId + ", companyId : " + companyId + ", tenantId : " + tenantId);
			LOGGER.debug("usedTheme : " + themeId + "usedFrame : " + frameDefault);
			
			ezNewPortalService.updateUserThemeSetting(themeId, frameDefault, userId, tenantId, companyId);
			
			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		LOGGER.debug("ezNewPortal G/W updateUserThemeSetting ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [DELETE] 사용자 테마 설정 초기화
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPortal/themes/users/{userId}", method = RequestMethod.DELETE, produces = "application/json;charset=utf-8")
	public JSONObject deleteUserThemeSetting(HttpServletRequest request, @PathVariable String userId) throws Exception {
		LOGGER.debug("ezNewPortal G/W deleteUserThemeSetting started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			String companyId = info.getCompanyId();
			int tenantId = info.getTenantId();
			LOGGER.debug("userId : " + userId + ", companyId : " + companyId + ", tenantId : " + tenantId);
			
			ezNewPortalService.deleteUserThemeSetting(userId, tenantId, companyId);
			
			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		LOGGER.debug("ezNewPortal G/W deleteUserThemeSetting ended.");
		return result;
	}

	// /////////////////////추가////////////////////////
	/**
	 * 포탈개인화 G/W [GET] 사용자별 읽지 않은 메일, 결재할 문서, 전자설문, 오늘일정, 회람판 개수 불러오기
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPortal/settingInfo/unreadCounts/users/{userId}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getUnreadCounts(HttpServletRequest request, @PathVariable String userId, Locale locale) throws Exception {
		LOGGER.debug("ezNewPortal G/W getUnreadCounts started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			String companyId = info.getCompanyId();
			int tenantId = info.getTenantId();
			String portletLang = info.getLang();
			String offset = info.getOffSet();
			String nowDate = commonUtil.getTodayUTCTime("yyyy-MM-dd");
			String idList = "T";
			String deptId = info.getDeptId();
			String offsetMin = commonUtil.getMinuteUTC(info.getOffSet());
			String userEmail = userId + "@" + ezCommonService.getTenantConfig("DomainName", tenantId);
			String password = jspw;
			String useQuestion = request.getParameter("useQuestion");
			String useCircular = request.getParameter("useCircular");
			String useMail = request.getParameter("useMail");
			String useApproval = request.getParameter("useApproval");
			String useSchedule = request.getParameter("useSchedule");
			LOGGER.debug("userId : " + userId + ", companyId : " + companyId + ", tenantId : " + tenantId);
			
			JSONObject data = new JSONObject();

			LOGGER.debug("useQuestion : " + useQuestion + ", useCircular : " + useCircular + ", useMail : " + useMail + ", useApproval : " + useApproval + ", useSchedule : " + useSchedule);

			// 전자 설문 개수 불러오기
			if (useQuestion.equals("YES")) {
				int pollCount = ezQuestionService.wpCountPollCount(userId, tenantId, offset, companyId);

				data.put("pollCount", pollCount);
			}

			// 오늘 일정 개수 불러오기
			if (useSchedule.equals("YES")) {
				String startDate = nowDate + " 00:00:00";
				String endDate = nowDate + " 23:59:59";
				String startTime = commonUtil.getDateStringInUTC(nowDate + " 00:00:00", offset, true);
				String endTime = commonUtil.getDateStringInUTC(nowDate + " 23:59:59", offset, true);
				String indiList = "";
				String pidList = "";
				String pidListSub = "";
				String indiListSub = "";

				List<ScheduleSecretaryVO> tList = ezScheduleService.getPublicScheduleSec(userId, portletLang, tenantId, companyId);
				List<ScheduleDeptVO> dList = ezScheduleService.getPublicScheduleDept(userId, portletLang, tenantId, companyId);
				List<ScheduleCumulerVO> cList = ezScheduleService.getPublicScheduleCumuler(userId, portletLang, tenantId, companyId);
				List<ScheduleGroupListVO> gList = ezScheduleService.getScheduleGroupList(userId, tenantId, companyId);

				indiList = "'" + userId + "'";

				if (tList != null && tList.size() > 0) {
					for (int i = 0; i < tList.size(); i++) {
						if (i == 0) {
							indiListSub += ",";
						}
						ScheduleSecretaryVO schedule = tList.get(i);
						indiListSub += "\'" + schedule.getSecId() + "\',";
					}
				}

				pidList = "'" + deptId + "'," + "'" + companyId + "'";

				if (dList != null && dList.size() > 0) {
					for (int i = 0; i < dList.size(); i++) {
						if (tList == null || tList.size() <= 0) {
							if (i == 0) {
								pidListSub += ",";
							}
						}
						ScheduleDeptVO schedule = dList.get(i);
						pidListSub += "\'" + schedule.getDeptId() + "\',";
					}
				}

				if (cList != null && cList.size() > 0) {
					for (int i = 0; i < cList.size(); i++) {
						if (dList == null || dList.size() <= 0) {
							if (i == 0) {
								pidListSub += ",";
							}
						}
						ScheduleCumulerVO schedule = cList.get(i);
						pidListSub += "\'" + schedule.getDeptId() + "\',";
					}
				}

				if (gList != null && gList.size() > 0) {
					for (int i = 0; i < gList.size(); i++) {
						if ((dList == null || dList.size() <= 0) && (cList == null || cList.size() <= 0)) {
							if (i == 0) {
								pidListSub += ",";
							}
						}
						ScheduleGroupListVO schedule = gList.get(i);
						pidListSub += "\'" + schedule.getGroupId() + "\',";
					}
				}

				if (indiListSub.equals("") || indiListSub == null) {
					indiListSub = ",\'\'";
				} else {
					indiListSub = indiListSub.substring(0, indiListSub.length() - 1);
				}

				indiList += indiListSub;

				if (pidListSub.equals("") || pidListSub == null) {
					pidListSub = ",\'\'";
				} else {
					pidListSub = pidListSub.substring(0, pidListSub.length() - 1);
				}

				pidList += pidListSub;
				List<ScheduleInfoVO> sList = ezScheduleService.getScheduleList(indiList, pidList, "", startTime, endTime, startDate, endDate, "", offsetMin, "", tenantId, companyId, userId);
				int scheduleCount = sList.size();
				data.put("scheduleCount", scheduleCount);
			}

			// 회람판 개수 불러오기
			if (useCircular.equals("YES")) {
				int circularCount = ezCircularSerivce.getListCount("newCircular", userId, tenantId, companyId);
				data.put("circularCount", circularCount);
			}

			// 결재할 문서 개수 불러오기
			if (useApproval.equals("YES")) {
				int approvalCount = ezApprovalGSerivce.getWebPartListCount("1", userId, deptId, "", "COUNT", "", companyId, portletLang, tenantId, offsetMin);
				data.put("approvalCount", approvalCount);
			}

			// 읽지 않은 메일 가져오기
			if (useMail.equals("YES")) {
				IMAPAccess ia = null;
				String folderName = "INBOX";
				int unreadMailCount = 0;

				try {
					ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"), userEmail, password, egovMessageSource, locale, ezEmailUtil);
					unreadMailCount = ia.getUnreadCount(folderName);
				} catch (Exception e) {

				} finally {
					if (ia != null) {
						ia.close();
					}
				}
				data.put("unreadMailCount", unreadMailCount);
			}

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		LOGGER.debug("ezNewPortal G/W getUserPortalSetting ended.");
		return result;
	}
	
	//사용자 초기화면 정보 조회 + 메모 모듈 사용여부 
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPortal/startpage/users/{userId}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getUserStartPage(HttpServletRequest request, @PathVariable String userId) {
		LOGGER.debug("ezNewPortal G/W getUserStartPage started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			String companyId = info.getCompanyId();
			int tenantId = info.getTenantId();
			JSONObject data = new JSONObject();
			LOGGER.debug("userId : " + userId + ", companyId : " + companyId + ", tenantId : " + tenantId);
			
			MenuInfoVO startPage = ezNewPortalService.getUserStartPage(userId, tenantId, companyId);
			//LOGGER.debug("startMenuId : " + startPage.getMenuId());
			
			String useMemo = "";
			useMemo = ezCommonService.getTenantConfig("useMemo", info.getTenantId());
			LOGGER.debug("useMemo : " + useMemo);
			
			data.put("useMemo", useMemo);
			data.put("startPage", startPage);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		LOGGER.debug("ezNewPortal G/W getUserStartPage ended.");
		return result;
	}
	
	//사용자 초기화면 설정 실행
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPortal/startpage/menus/{menuId}/users/{userId}", method = RequestMethod.PATCH, produces = "application/json;charset=utf-8")
	public JSONObject updateUserStartPage (HttpServletRequest request, @PathVariable String userId, @PathVariable int menuId) {
		LOGGER.debug("ezNewPortal G/W getUserStartPage started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			String companyId = info.getCompanyId();
			int tenantId = info.getTenantId();
			LOGGER.debug("userId : " + userId + ", companyId : " + companyId + ", tenantId : " + tenantId);
			LOGGER.debug("menuId : " + menuId);
			
			ezNewPortalService.updateUserStartPage(menuId, userId, tenantId, companyId);
			
			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		LOGGER.debug("ezNewPortal G/W getUserStartPage ended.");
		return result;
	}
	// ///관리자///////
	/**
	 * 포탈개인화 G/W [GET] 회사 목록 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/admin/ezportal/companies", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getCompanyList(HttpServletRequest request) throws Exception {
		LOGGER.debug("ezNewPortal G/W getCompanyList started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");

			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);

			String primary = userInfo.getPrimary();

			List<OrganDeptVO> resultList = new ArrayList<OrganDeptVO>();

			resultList = ezOrganAdminService.getCompanyList(primary, userInfo.getTenantId());

			result.put("data", resultList);
			result.put("userCompany", userInfo.getCompanyID());
			result.put("lang", userInfo.getLang());
			result.put("primary", primary);
			result.put("status", "ok");
			result.put("code", 0);

			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		LOGGER.debug("ezNewPortal G/W getCompanyList ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [GET] 회사별 테마 목록 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/admin/ezportal/themes/companies/{companyId}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getCompanyThemes(HttpServletRequest request, @PathVariable String companyId) throws Exception {
		LOGGER.debug("ezNewPortal G/W getCompanyThemes} started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");

			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);

			List<ThemeInfoVO> themeList = ezNewPortalService.getThemes(true, companyId, userInfo.getTenantId());

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", themeList);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		LOGGER.debug("ezNewPortal G/W getCompanyThemes ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [GET] 회사별 테마 상세정보 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/admin/ezPortal/themes/{themeId}/companies/{companyId}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getCompanyThemeInfo(HttpServletRequest request, @PathVariable int themeId, @PathVariable String companyId) throws Exception {
		LOGGER.debug("ezNewPortal G/W getCompanyThemeInfo started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");

			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			int tenantId = userInfo.getTenantId();
			
			ThemeInfoVO themeInfo = ezNewPortalService.getThemeInfo(themeId, companyId, tenantId);
			List<FrameInfoVO> frameInfos = ezNewPortalService.getFrames(themeId, companyId, tenantId);
			
			JSONObject data = new JSONObject();
			
			data.put("themeInfo", themeInfo);
			data.put("frameInfos", frameInfos);
			
			result.put("data", data);

			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		LOGGER.debug("ezNewPortal G/W getCompanyThemeInfo ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [PATCH] 회사별 테마 상세정보 수정
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/admin/ezPortal/themes/{themeId}/companies/{companyId}", method = RequestMethod.PATCH, produces = "application/json;charset=utf-8")
	public JSONObject updateCompanyThemeInfo(HttpServletRequest request, @PathVariable int themeId, @PathVariable String companyId, @RequestBody JSONObject jsonParam) throws Exception {
		LOGGER.debug("ezNewPortal G/W updateCompanyThemeInfo started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			//이효진 jsonParam 캐스팅 잘되면 냅두고 안되면 나중에 고쳐야지
			JSONParser jp = new JSONParser();
			jsonParam = (JSONObject) jp.parse(jsonParam.toJSONString());
			
			JSONObject themeInfo = (JSONObject) jsonParam.get("themeInfo");
			JSONArray frameInfos = (JSONArray) jsonParam.get("frameInfos");
			LOGGER.debug("frameInfos = " + frameInfos.toString());

			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			int tenantId = userInfo.getTenantId();
			
			ezNewPortalService.updateThemeInfo(themeInfo, frameInfos, companyId, tenantId);

			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		LOGGER.debug("ezNewPortal G/W updateCompanyThemeInfo ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [GET] 회사별 테마 미리보기
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/admin/ezPortal/themes/{themeId}/frames/{frameId}/preview/companies/{companyId}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getCompanyThemePreview(HttpServletRequest request, @PathVariable int themeId, @PathVariable int frameId, @PathVariable String companyId) throws Exception {
		LOGGER.debug("ezNewPortal G/W getCompanyThemePreview started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));

			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		LOGGER.debug("ezNewPortal G/W getCompanyThemePreview ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [GET] 회사별 메뉴 목록 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/admin/ezPortal/menus/companies/{companyId}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getCompanyMenus(HttpServletRequest request, @PathVariable String companyId) throws Exception {
		LOGGER.debug("ezNewPortal G/W getCompanyMenus started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");

			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			
			List<MenuInfoVO> menuInfos = ezNewPortalService.getMenus(companyId, userInfo.getTenantId());

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", menuInfos);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		
		LOGGER.debug("ezNewPortal G/W getCompanyMenus ended.");
		
		return result;
	}

	/**
	 * 포탈개인화 G/W [PATCH] 회사별 메뉴 순서 변경
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/admin/ezPortal/menus/order/companies/{companyId}", method = RequestMethod.PATCH, produces = "application/json;charset=utf-8")
	public JSONObject updateCompanyMenuOrder(HttpServletRequest request, @PathVariable String companyId, @RequestBody JSONObject jsonParam) throws Exception {
		LOGGER.debug("ezNewPortal G/W updateCompanyMenuOrder started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");

			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			
			JSONParser jp = new JSONParser();
			jsonParam = (JSONObject) jp.parse(jsonParam.toJSONString());
			
			JSONArray menus = (JSONArray) jsonParam.get("menus");
			

			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		LOGGER.debug("ezNewPortal G/W updateCompanyMenuOrder ended.");
		return result;
	}
	
	/**
	 * 포탈개인화 G/W [GET] 회사별 메뉴 상세정보 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/admin/ezPortal/menus/{menuId}/companies/{companyId}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getCompanyMenuInfo(HttpServletRequest request, @PathVariable String companyId, @PathVariable int menuId) throws Exception {
		LOGGER.debug("ezNewPortal G/W getCompanyMenuInfo started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");

			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			int tenantId = userInfo.getTenantId();
			
			MenuInfoVO menuInfo = ezNewPortalService.getMenuInfo(menuId, companyId, tenantId);
			List<MenuNameVO> menuNames = ezNewPortalService.getMenuNames(menuId, companyId, tenantId);
			
			JSONObject data = new JSONObject();
			data.put("menuInfo", menuInfo);
			data.put("menuNames", menuNames);

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		LOGGER.debug("ezNewPortal G/W getCompanyMenuInfo ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [PATCH] 회사별 메뉴 상세정보 수정
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/admin/ezPortal/menus/{menuId}/companies/{companyId}", method = RequestMethod.PATCH, produces = "application/json;charset=utf-8")
	public JSONObject updateCompanyMenuInfo(HttpServletRequest request, @PathVariable String companyId, @PathVariable int menuId, @RequestBody JSONObject jsonParam) throws Exception {
		LOGGER.debug("ezNewPortal G/W updateCompanyMenuInfo started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");

			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			
			JSONParser jp = new JSONParser();
			jsonParam = (JSONObject) jp.parse(jsonParam.toJSONString());
			
			JSONObject menuInfo =(JSONObject) jsonParam.get("menuInfo");
			JSONArray menuNames = (JSONArray) jsonParam.get("menuNames");
			
			ezNewPortalService.updateCompanyMenuInfo(menuId, menuInfo, menuNames, companyId, userInfo.getTenantId());

			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		LOGGER.debug("ezNewPortal G/W updateCompanyMenuInfo ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [GET] 메뉴별 권한 정보 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/admin/ezPortal/menus/{menuId}/authorities/companies/{companyId}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getCompanyMenuAuth(HttpServletRequest request, @PathVariable int menuId, @PathVariable String companyId) throws Exception {
		LOGGER.debug("ezNewPortal G/W getCompanyMenuAuth started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");

			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			
			Map<String, Object> resultMap = ezNewPortalService.getMenuAuth(menuId, companyId, userInfo.getTenantId());
			
			JSONObject data = new JSONObject();
			
			data.put("menuAuthsY", resultMap.get("menuAuthsY"));
			data.put("menuAuthsN", resultMap.get("menuAuthsN"));
			
			result.put("data", data);
			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		LOGGER.debug("ezNewPortal G/W getCompanyMenuAuth ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [PATCH] 메뉴별 권한 정보 수정
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/admin/ezPortal/menus/{menuId}/authorities/companies/{companyId}", method = RequestMethod.PATCH, produces = "application/json;charset=utf-8")
	public JSONObject updateCompanyMenuAuth(HttpServletRequest request, @PathVariable int menuId, @PathVariable String companyId, @RequestBody JSONObject jsonParam) throws Exception {
		LOGGER.debug("ezNewPortal G/W updateCompanyMenuAuth started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");

			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			
			JSONParser jp = new JSONParser();
			jsonParam = (JSONObject) jp.parse(jsonParam.toJSONString());
			
			ezNewPortalService.updateMenuAuth(jsonParam, menuId, companyId, userInfo.getTenantId());

			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		LOGGER.debug("ezNewPortal G/W updateCompanyMenuAuth ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [POST] 메뉴 추가
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/admin/ezPortal/menus/companies/{companyId}", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject insertCompanyMenu(HttpServletRequest request, @PathVariable String companyId, @RequestBody JSONObject jsonParam) throws Exception {
		LOGGER.debug("ezNewPortal G/W insertCompanyMenu started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");

			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			
			JSONParser jp = new JSONParser();
			jsonParam = (JSONObject) jp.parse(jsonParam.toJSONString());
			
			JSONObject menuInfo =(JSONObject) jsonParam.get("menuInfo");
			JSONArray menuNames = (JSONArray) jsonParam.get("menuNames");
			JSONObject menuAuths = (JSONObject) jsonParam.get("menuAuths");
			
			ezNewPortalService.insertMenu(menuInfo, menuNames, menuAuths, companyId, userInfo.getTenantId());

			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		LOGGER.debug("ezNewPortal G/W insertCompanyMenu ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [DELETE] 메뉴 삭제
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/admin/ezPortal/menus/{menuId}/companies/{companyId}", method = RequestMethod.DELETE, produces = "application/json;charset=utf-8")
	public JSONObject deleteCompanyMenu(HttpServletRequest request, @PathVariable int menuId, @PathVariable String companyId) throws Exception {
		LOGGER.debug("ezNewPortal G/W deleteCompanyMenu started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");

			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			
			ezNewPortalService.deleteMenu(menuId, companyId, userInfo.getTenantId());

			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		LOGGER.debug("ezNewPortal G/W deleteCompanyMenu ended.");
		return result;
	}
	
	/** 구해안 start
	 * 포탈개인화 G/W [GET] 회사별 포틀릿 목록 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/admin/ezPortal/portlets/companies/{companyId}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getCompanyPortletList(HttpServletRequest request, @PathVariable String companyId) throws Exception {
		LOGGER.debug("ezNewPortal G/W getCompanyPortletList started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			int tenantId = info.getTenantId();

			JSONObject data = new JSONObject();

			List<PortletInfoVO> portletList = ezNewPortalService.getPortletList(companyId, tenantId);
			for (PortletInfoVO pvo : portletList) {
				List<PortletNameInfoVO> portletNameList = ezNewPortalService.getPortletNameList(companyId, tenantId, pvo.getPortletId());
				pvo.setPortletNameList(portletNameList);
			}
						
			data.put("PortletList", portletList);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		LOGGER.debug("ezNewPortal G/W getCompanyPortletList ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [PATCH] 회사별 포틀릿 순서 변경
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/admin/ezPortal/portlets/order/companies/{companyId}", method = RequestMethod.PATCH, produces = "application/json;charset=utf-8")
	public JSONObject updateCompanyPortletOrder(HttpServletRequest request, @PathVariable String companyId) throws Exception {
		LOGGER.debug("ezNewPortal G/W updateCompanyPortletOrder started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));

			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		LOGGER.debug("ezNewPortal G/W updateCompanyPortletOrder ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [GET] 회사별 포틀릿 상세조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/admin/ezPortal/portlets/{portletId}/companies/{companyId}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getPortletInfo(HttpServletRequest request, @PathVariable int portletId, @PathVariable String companyId) throws Exception {
		LOGGER.debug("ezNewPortal G/W getCompanyPortletInfo started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));

			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		LOGGER.debug("ezNewPortal G/W getCompanyPortletInfo ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [POST] 포틀릿 추가
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/admin/ezPortal/portlets/{portletId}/companies/{companyId}", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject insertPortlet(HttpServletRequest request, @PathVariable int portletId, @PathVariable String companyId) throws Exception {
		LOGGER.debug("ezNewPortal G/W insertCompanyPortlet started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));

			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		LOGGER.debug("ezNewPortal G/W insertCompanyPortlet ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [DELETE] 포틀릿 삭제
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/admin/ezPortal/portlets/{portletId}/companies/{companyId}", method = RequestMethod.DELETE, produces = "application/json;charset=utf-8")
	public JSONObject deletePortlet(HttpServletRequest request, @PathVariable int portletId, @PathVariable String companyId) throws Exception {
		LOGGER.debug("ezNewPortal G/W deleteCompanyPortlet started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));

			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		LOGGER.debug("ezNewPortal G/W deleteCompanyPortlet ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [PATCH] 포틀릿 상세정보 변경
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/admin/ezPortal/portlets/{portletId}/companies/{companyId}", method = RequestMethod.PATCH, produces = "application/json;charset=utf-8")
	public JSONObject updatePortletInfo(HttpServletRequest request, @PathVariable int portletId, @PathVariable String companyId) throws Exception {
		LOGGER.debug("ezNewPortal G/W updatePortletInfo started.");
		JSONObject result = new JSONObject();
		String userId = request.getParameter("userId");

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			
			int tenantId = info.getTenantId();
			String portletLang = info.getLang();

			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		LOGGER.debug("ezNewPortal G/W updatePortletInfo ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [GET] 게시판 트리 호출
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/admin/ezPortal/boards/tree/companies/{companyId}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getBoardTree(HttpServletRequest request, @PathVariable String companyId) throws Exception {
		LOGGER.debug("ezNewPortal G/W getBoardTree started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));

			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		LOGGER.debug("ezNewPortal G/W getBoardTree ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [GET] 로고 불러오기
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/admin/ezPortal/logos/companies/{companyId}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getCompanyLogo(HttpServletRequest request, @PathVariable String companyId) throws Exception {
		LOGGER.debug("ezNewPortal G/W getCompanyLogo started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));

			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		LOGGER.debug("ezNewPortal G/W getCompanyLogo ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [POST] 로고 등록하기
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/admin/ezPortal/logos/companies/{companyId}", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject insertCompanyLogo(HttpServletRequest request, @PathVariable String companyId) throws Exception {
		LOGGER.debug("ezNewPortal G/W insertCompanyLogo started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));

			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		LOGGER.debug("ezNewPortal G/W insertCompanyLogo ended.");
		return result;
	}

	// ///포틀릿///////구해안
	/**
	 * 포탈개인화 G/W [GET] 포틀릿 - 게시판 즐겨찾기 포틀릿 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPortal/portlets/boardFavorites", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getFavoriteBoardPortlet(HttpServletRequest request) throws Exception {
		LOGGER.debug("ezNewPortal G/W getFavoriteBoardPortlet started.");
		JSONObject result = new JSONObject();

		String boardId = request.getParameter("boardId");
		int limit = 5;

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));

			JSONObject data = new JSONObject();

			data.put("boardId", boardId);

			if (boardId.equals("{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}")) { // 새게시물

				List<FavoriteBoardVO> favNewList = ezNewPortalService.getFavNewItemList(info.getUserId(), info.getTenantId(), info.getCompanyId(), commonUtil.getTodayUTCTime(""), limit);

				for (FavoriteBoardVO fvo : favNewList) {
					LOGGER.debug("resultList : " + fvo.getItemId());
				}

				data.put("favList", favNewList);

			} else { // 일반게시판

				List<FavoriteBoardVO> favList = ezNewPortalService.getFavItemList(boardId, info.getTenantId(), info.getCompanyId(), limit);

				for (FavoriteBoardVO fvo : favList) {
					LOGGER.debug("resultList : " + fvo.getItemId());
				}

				data.put("favList", favList);
			}

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		LOGGER.debug("ezNewPortal G/W getFavoriteBoardPortlet ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [GET] 포틀릿 - 게시판 즐겨찾기 포틀릿 탭 리스트 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPortal/portlets/boardFavorites/lists", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getFavoriteBoardPortletList(HttpServletRequest request) throws Exception {
		LOGGER.debug("ezNewPortal G/W getFavoriteBoardPortletList started.");
		JSONObject result = new JSONObject();
		String userId = request.getParameter("userId");
		String mode = request.getParameter("mode");

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			String companyId = info.getCompanyId();
			int tenantId = info.getTenantId();

			List<BoardMyFavoriteVO> resultList = ezBoardService.get_favoriteList(userId, mode, companyId, tenantId);

			for (BoardMyFavoriteVO fvo : resultList) {

				LOGGER.debug("resultList : " + fvo.getBoardId());
			}

			JSONObject data = new JSONObject();
			data.put("resultList", resultList);

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		LOGGER.debug("ezNewPortal G/W getFavoriteBoardPortletList ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [GET] 포틀릿 - 커뮤니티 포틀릿 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPortal/portlets/community", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getCommunityPortlet(HttpServletRequest request) throws Exception {
		LOGGER.debug("ezNewPortal G/W getCommunityPortlet started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			LoginVO info = commonUtil.getUserForGw(userId, serverName);

			String companyId = info.getCompanyID();
			int tenantId = info.getTenantId();
			JSONObject data = new JSONObject();
			String lang = info.getLang();

			List<CommunityMyCommunityVO> CommunityList = ezNewPortalService.getCommunityList(lang, companyId, tenantId);

			// int CommuSize = CommunityList.size();
			//
			// if (CommuSize == 0) {
			// data.put("CommunityList", CommunityList);
			// } else if (CommuSize == 1) {
			// data.put("CommunityList", CommunityList);
			// if (CommunityList.get(0).getC_ClubGubun() != null &&
			// CommunityList.get(0).getC_ClubGubun().equals("3")) {
			//
			// String memberChk =
			// ezNewPortalService.getMemberChk(CommunityList.get(0).getC_ClubNo(),
			// userId, tenantId);
			//
			// data.put("memberChk", memberChk);
			// }
			// } else {
			// data.put("CommunityList", CommunityList);
			// for (int i = 0; i < 2; i++) {
			//
			// if (CommunityList.get(i).getC_ClubGubun() != null &&
			// CommunityList.get(i).getC_ClubGubun().equals("3")) {
			// String memberChk0 =
			// ezNewPortalService.getMemberChk(CommunityList.get(i).getC_ClubNo(),
			// userId, tenantId);
			// String memberChk1 =
			// ezNewPortalService.getMemberChk(CommunityList.get(i).getC_ClubNo(),
			// userId, tenantId);
			//
			// data.put("memberChk0", memberChk0);
			// data.put("memberChk1", memberChk1);
			// }
			//
			// String bannerSrc = "";
			//
			// if
			// (CommunityList.get(i).getC_Logo_Thumbnail().trim().indexOf("default_logo_type")
			// > -1) {
			// bannerSrc = "/images/ezCommunity/logo/" +
			// CommunityList.get(i).getC_Logo_Thumbnail().trim();
			// } else {
			// bannerSrc = "/ezCommon/downloadAttach.do?filePath=" +
			// commonUtil.getUploadPath("upload_community.LOGO",
			// tenantId)+commonUtil.separator+CommunityList.get(i).getC_Logo_Thumbnail();
			// }
			// }
			// }
			String commuPath = commonUtil.getUploadPath("upload_community.LOGO", tenantId);

			data.put("CommunityList", CommunityList);
			data.put("CommuSize", CommunityList.size());
			data.put("commuPath", commuPath);

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		LOGGER.debug("ezNewPortal G/W getCommunityPortlet ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [GET] 포틀릿 - 커뮤니티 허가여부
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPortal/portlets/community/permits", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject CommunityPermit(HttpServletRequest request) throws Exception {
		LOGGER.debug("ezNewPortal G/W getCommunityPortlet started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			LoginVO info = commonUtil.getUserForGw(userId, serverName);

			int tenantId = info.getTenantId();
			JSONObject data = new JSONObject();
			String clubNo = request.getParameter("clubNo");

			String memberChk = ezNewPortalService.getCommunityPermit(clubNo, userId, tenantId);

			data.put("memberChk", memberChk);

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		LOGGER.debug("ezNewPortal G/W getCommunityPortlet ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [GET] 포틀릿 - 받은 메일 포틀릿 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPortal/portlets/receivedMail", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getReceivedMainPortlet(HttpServletRequest request) throws Exception {
		LOGGER.debug("ezNewPortal G/W getReceivedMainPortlet started.");
		JSONObject result = new JSONObject();
		JSONObject data = new JSONObject();

		String password = request.getParameter("password");
		String userId = request.getParameter("userId");

		try {
			String serverName = request.getHeader("x-user-host");
			LoginVO info = commonUtil.getUserForGw(userId, serverName);

			Locale locale = info.getLocale();

			// start

			String folderPath = "INBOX";
			IMAPAccess ia = null;

			try {
				// get user credentials

				String domainName = ezCommonService.getTenantConfig("DomainName", info.getTenantId());
				String userAccount = userId + "@" + domainName;

				LOGGER.debug("userEmail=" + userAccount);

				ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"), userAccount, password, egovMessageSource, locale, 40 * 1000,
						20 * 1000, ezEmailUtil);

				long[] storageUsageAndLimit = ia.getStorageUsageAndLimit();

				double mailboxUsage = storageUsageAndLimit[0]; // in KBs
				double mailboxQuota = storageUsageAndLimit[1]; // in KBs

				// 재은 수정
				String[] mailUse = ezEmailUtil.getMailUsage(mailboxUsage, mailboxQuota);
				String mailPercent = "";
				String mailboxDetail = "";
				String mailboxQuotaStr = "";

				if (mailUse != null) {
					mailPercent = mailUse[0];
					mailboxDetail = mailUse[1];
					mailboxQuotaStr = mailUse[2];
				}

				LOGGER.debug("mailPercent=" + mailPercent + ",mailboxDetail=" + mailboxDetail + ",mailboxQuotaStr=" + mailboxQuotaStr);

				Folder folder = ia.getFolder(folderPath);
				folder.open(Folder.READ_ONLY);

				Message[] messages = null;

				// set mailCount
				int mailCount = 7;
				int unreadCount = ia.getUnreadCount(folderPath);
				// if (unreadCount < mailCount) {
				// mailCount = unreadCount;
				// }

				messages = ezEmailUtil.searchFolder(ia, userAccount, folder, "", "", null, null, false, false, false, "receivedDate", false, 0, mailCount, false, null, info.getTenantId());

				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
				sdf.setTimeZone(TimeZone.getTimeZone("GMT"));

				int messagesLength = messages.length;
				List<Map<Object, String>> mailList = new ArrayList<Map<Object, String>>();

				for (int i = 0; i < messagesLength; i++) {
					Message message = messages[i];
					UIDFolder uidFolder = (UIDFolder) message.getFolder();

					// href
					String href = "INBOX/" + uidFolder.getUID(message);

					// received date
					Date receivedDate = message.getReceivedDate();
					String receivedDateStr = sdf.format(receivedDate);
					receivedDateStr = commonUtil.getDateStringInUTC(receivedDateStr, info.getOffset(), false);

					// sender
					String sender = ezEmailUtil.getFromNameOrAddressOfMessage(message);

					// subject
					String subject = ezEmailUtil.getSubject(message);
					subject = (subject != null) ? subject : "";

					if (ezEmailUtil.hasSecureMailFlag(message)) {
						subject = "<img src=\"/images/email/secureMail/security_icon.gif\" width=\"15px\" />" + subject;
					}

					int readFlag = message.isSet(Flags.Flag.SEEN) ? 1 : 0;
					String readClass = "";

					if (readFlag == 0) {
						readClass = "mail_close";
					} else {
						readClass = "mail_open";
					}

					Map<Object, String> mailMap = new HashMap<Object, String>();
					mailMap.put("href", href);
					mailMap.put("receivedDateStr", receivedDateStr.substring(5));
					mailMap.put("sender", sender);
					mailMap.put("subject", subject);
					mailMap.put("readClass", readClass);

					mailList.add(mailMap);
				}
				data.put("mailList", mailList);
				data.put("unreadCount", unreadCount);
				data.put("mailboxQuotaStr", mailboxQuotaStr);
				data.put("mailboxDetail", mailboxDetail);
				data.put("mailPercent", mailPercent);

			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				if (ia != null) {
					ia.close();
				}
			}

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		LOGGER.debug("ezNewPortal G/W getReceivedMainPortlet ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [GET] 포틀릿 - 투표 정보 포틀릿 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPortal/portlets/vote", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getVotePortlet(HttpServletRequest request) throws Exception {
		LOGGER.debug("ezNewPortal G/W getVotePortlet started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			int tenantId = info.getTenantId();
			String companyId = info.getCompanyId();
			String deptId = info.getDeptId();

			// deptpath 구하기
			String deptPath = ezOrganService.getDeptPath(deptId, tenantId);

			// 진행중인 투표 중 내가 참여하고 있는 투표의 개수
			int voteCount = ezNewPortalService.getVotePortletCount(userId, companyId, deptPath, tenantId);

			JSONObject data = new JSONObject();
			data.put("voteCount", voteCount);

			if (voteCount != 0) {
				// 투표 정보 가져오기
				PollQuestionVO pollQuestion = ezNewPortalService.getVotePortletInfo(userId, companyId, deptPath, tenantId);
				int qstId = pollQuestion.getQstId();

				LOGGER.debug("qstId : " + qstId);
				List<PollAnswerVO> pollAnswer = ezNewPortalService.getVotePortletAnswer(qstId, tenantId);
				int pollAnswerCount = 0;

				for (int i = 0; i < pollAnswer.size(); i++) {
					pollAnswerCount += pollAnswer.get(i).getVotesNumber();
				}

				data.put("qstId", qstId);
				data.put("title", pollQuestion.getTitle());
				data.put("pollAnswer", pollAnswer);
				data.put("pollAnswerCount", pollAnswerCount);
			}

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		LOGGER.debug("ezNewPortal G/W getVotePortlet ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [GET] 포틀릿 - 포토게시판 포틀릿 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPortal/portlets/photoBoard", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getPhotoBoardPortlet(HttpServletRequest request) throws Exception {
		LOGGER.debug("ezNewPortal G/W getPhotoBoardPortlet started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			LoginVO info = commonUtil.getUserForGw(userId, serverName);
			String companyId = info.getCompanyID();
			String deptId = info.getDeptID();
			String rollInfo = info.getRollInfo();
			int tenantId = info.getTenantId();
			int portletId = Integer.parseInt(request.getParameter("portletId")); // 포토게시판의
																					// 포틀릿
																					// 아이디
			int startRow = Integer.parseInt(request.getParameter("startRow"));
			int photoCount = Integer.parseInt(request.getParameter("photoCount"));
			String portletLang = info.getLang();
			String deptPath = info.getDeptPathCode();
			deptPath += "everyone," + deptPath + "," + userId;
			JSONObject data = new JSONObject();

			// 회사의 포토게시판의 포틀릿 정보 가져오기
			PortletInfoVO portlet = ezNewPortalService.getCompanyPortletInfo(companyId, tenantId, portletId, portletLang);
			String boardId = portlet.getConnectionUrl();
			data.put("boardId", boardId);
			data.put("portletName", portlet.getPortletName());

			// 게시판 권한 체크
			boolean accessCheck = boardAuthCheck(boardId, deptPath, tenantId, companyId, deptId, userId, rollInfo);

			if (!accessCheck) {
				data.put("access", "false");
			} else {
				// 권한이 true이면 boardList불러오기
				List<BoardItemVO> photoBoardList = ezNewPortalService.getPhotoBoardPortletInfo(tenantId, boardId, startRow, photoCount);

				data.put("access", "true");
				data.put("photoBoardList", photoBoardList);
			}

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		LOGGER.debug("ezNewPortal G/W getPhotoBoardPortlet ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [GET] 포틀릿 - 공지사항 포틀릿 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPortal/portlets/notice", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getNoticePortlet(HttpServletRequest request) throws Exception {
		LOGGER.debug("ezNewPortal G/W getNoticePortlet started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			int tenantId = info.getTenantId();
			String companyId = info.getCompanyId();
			int limit = 3; // 공지사항 갯수

			// 여기에 데이터를 put해서 넘기면 됨.
			JSONObject data = new JSONObject();

			List<BoardListVO> noticeList = new ArrayList<BoardListVO>();
			noticeList = ezNewPortalService.getNoticePortletList(companyId, tenantId, limit);
			data.put("noticeList", noticeList);

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		LOGGER.debug("ezNewPortal G/W getNoticePortlet ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [GET] 포틀릿 - 설문조사 포틀릿 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPortal/portlets/poll", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getPollPortlet(HttpServletRequest request) throws Exception {
		LOGGER.debug("ezNewPortal G/W getPollPortlet started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			String companyId = info.getCompanyId();
			int tenantId = info.getTenantId();
			List<Map<String, Object>> answerList = new ArrayList<Map<String, Object>>();

			PersonalLightPollVO pollInfo = new PersonalLightPollVO();
			pollInfo = ezNewPortalService.getPollPortlet(companyId, tenantId, request.getParameter("userId"));

			int itemSeq = pollInfo.getItemSeq();
			List<PersonalLightPollVO> pollResult = ezNewPortalService.getPollPortletResult(companyId, tenantId, itemSeq);

			answerList = ezNewPortalService.getAssemblePollData(pollInfo, pollResult);

			JSONObject data = new JSONObject();
			data.put("pollInfo", pollInfo);
			data.put("answerList", answerList);

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		LOGGER.debug("ezNewPortal G/W getPollPortlet ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [GET] 포틀릿 - 전자결재(결재할 문서, 반송 문서, 기안 문서)
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezportal/portlets/approvallist", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getApprovalListPortlet(HttpServletRequest request) throws Exception {
		LOGGER.debug("ezNewPortal G/W getApprovalListPortlet started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			LoginVO info = commonUtil.getUserForGw(userId, serverName);

			String type = request.getParameter("type");

			Map<String, Object> resultMap = ezNewPortalService.getApprovalList(userId, info.getCompanyID(), info.getTenantId(), info.getOffset(), type);

			JSONObject data = new JSONObject();
			data.put("resultMap", resultMap);

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		LOGGER.debug("ezNewPortal G/W getApprovalListPortlet ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [GET] 포틀릿 - 즐겨찾기 양식
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezportal/portlets/favoriteforms", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getFavoriteForms(HttpServletRequest request) throws Exception {
		LOGGER.debug("ezNewPortal G/W getFavoriteForms started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			LoginVO info = commonUtil.getUserForGw(userId, serverName);

			List<ApprGFormVO> list = ezNewPortalService.getFavoriteForms(userId, info.getCompanyID(), info.getTenantId());

			JSONObject data = new JSONObject();
			data.put("resultList", list);

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		LOGGER.debug("ezNewPortal G/W getFavoriteForms ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [GET] 포틀릿 - 즐겨찾기양식 (결재할문서 통계)
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezportal/portlets/approvalstatistics", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getApprovalStatisticsPortlet(HttpServletRequest request) throws Exception {
		LOGGER.debug("ezNewPortal G/W getApprovalStatisticsPortlet started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			LoginVO info = commonUtil.getUserForGw(userId, serverName);

			Map<String, Object> resultMap = ezNewPortalService.getApprovalStatistics(userId, info.getCompanyID(), info.getTenantId());

			JSONObject data = new JSONObject();
			data.put("hour", resultMap.get("hour"));
			data.put("day", resultMap.get("day"));
			data.put("week", resultMap.get("week"));
			data.put("month", resultMap.get("month"));
			data.put("other", resultMap.get("other"));

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		LOGGER.debug("ezNewPortal G/W getApprovalStatisticsPortlet ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [GET] 포틀릿 - 일정관리
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPortal/portlets/schedule", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getSchedulePortlet(HttpServletRequest request) throws Exception {
		LOGGER.debug("ezNewPortal G/W getSchedulePortlet started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));

			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		LOGGER.debug("ezNewPortal G/W getSchedulePortlet ended.");
		return result;
	}

	// //////board 권한 체크
	public boolean boardAuthCheck(String boardId, String deptPath, int tenantId, String companyId, String deptId, String userId, String rollInfo) {
		LOGGER.debug("boardAuthCheck started");
		boolean authCheck = false;
		String[] deptPathSplit = deptPath.split(",");
		int deptPathCount = deptPathSplit.length;
		String rootBoardID = "top";

		try {
			String boardGroupAdmin_FG = ezBoardAdminService.checkIfBoardGroupAdmin(rootBoardID, userId, deptId, companyId, tenantId);

			if (rollInfo != null
					&& (boardGroupAdmin_FG.equals("OK") || rollInfo.toLowerCase().indexOf("c=1") > -1 || rollInfo.toLowerCase().indexOf("k=1") > -1 || rollInfo.toLowerCase().indexOf("n=1") > -1)) {
				authCheck = true;
			} else {
				for (int i = 0; i < deptPathCount; i++) {
					String deptPathId = deptPathSplit[i];
					String authCompare = ezNewPortalService.getBoardAuthCheck(boardId, deptPathId, tenantId, companyId);

					if (authCompare != null) {
						if (authCompare.equals("true")) {
							authCheck = true;
						} else {
							authCheck = false;
						}
					}
				}
			}
		} catch (Exception e) {
			LOGGER.debug("boardAuthCheck error");
		}

		LOGGER.debug("authCheck : " + authCheck);
		LOGGER.debug("boardAuthCheck ended");
		return authCheck;
	}
}
