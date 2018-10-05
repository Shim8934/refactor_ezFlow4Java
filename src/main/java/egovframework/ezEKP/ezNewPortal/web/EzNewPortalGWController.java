package egovframework.ezEKP.ezNewPortal.web;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import egovframework.ezEKP.ezBoard.vo.BoardItemVO;
import egovframework.ezEKP.ezBoard.web.EzBoardController;
import egovframework.ezEKP.ezBoard.service.EzBoardAdminService;
import egovframework.ezEKP.ezBoard.service.EzBoardService;
import egovframework.ezEKP.ezBoard.vo.BoardConfigVO;
import egovframework.ezEKP.ezBoard.vo.BoardListVO;
import egovframework.ezEKP.ezBoard.vo.BoardMyFavoriteVO;
import egovframework.ezEKP.ezBoard.vo.BoardVO;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezNewPortal.service.EzNewPortalService;
import egovframework.ezEKP.ezNewPortal.vo.PortletInfoVO;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.ezEKP.ezPoll.vo.PollAnswerVO;
import egovframework.ezEKP.ezPoll.vo.PollQuestionVO;
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
	private EzCommonService ezCommonService;
	
	@Autowired
	private LoginService loginService;
	
	@Resource(name="EzNewPortalService")
	private EzNewPortalService ezNewPortalService;
	
	@Resource(name="EzBoardService")
	private EzBoardService ezBoardService;
	
	@Resource(name="EzBoardAdminService")
	private EzBoardAdminService ezBoardAdminService;
	
	@Resource(name="MOptionService")
	private MOptionService mOptionService;
	
	@Resource(name="EzBoardController")
	private EzBoardController ezBoardController;
	
	@Autowired
	private EzOrganService ezOrganService;
	
	@Autowired
	private EzOrganAdminService ezOrganAdminService;

	/////사용자///////
	/**
	 * 포탈개인화  G/W [GET] 사용자별 개인화 정보 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value= "/rest/ezPortal/settingInfo/users/{userId}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getUserPortalSetting(HttpServletRequest request, @PathVariable String userId) throws Exception {
		LOGGER.debug("ezNewPortal G/W getUserPortalSetting started.");
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
		LOGGER.debug("ezNewPortal G/W getUserPortalSetting ended.");
		return result;
	}
	
	/**
	 * 포탈개인화  G/W [PATCH] 사용자별 포틀릿 순서 변경
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value= "/rest/ezPortal/portlets/order/users/{userId}", method= RequestMethod.PATCH, produces="application/json;charset=utf-8")
	public JSONObject updatePortletOrder(HttpServletRequest request, @PathVariable String userId, @RequestBody JSONObject jsonParam) throws Exception {
		LOGGER.debug("ezNewPortal G/W getMonthlyBirthdayEmployees started.");
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
		LOGGER.debug("ezNewPortal G/W getMonthlyBirthdayEmployees ended.");
		return result;
	}
	
	/**
	 * 포탈개인화  G/W [GET] 월별 생일 사원 목록 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value= "/rest/ezPortal/birthday/months/{month}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getMonthlyBirthdayEmployees(HttpServletRequest request, @PathVariable int month) throws Exception {
		LOGGER.debug("ezNewPortal G/W getMonthlyBirthdayEmployees started.");
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			
			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		LOGGER.debug("ezNewPortal G/W getMonthlyBirthdayEmployees ended.");
		return result;
	}
	
	/**
	 * 포탈개인화  G/W [GET] 이달의 우수 사원 정보 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value= "/rest/ezPortal/bestEmployee/months/{month}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getMonthlyBestEmployee(HttpServletRequest request, @PathVariable int month) throws Exception {
		LOGGER.debug("ezNewPortal G/W getMonthlyBestEmployee started.");
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			
			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		LOGGER.debug("ezNewPortal G/W getMonthlyBestEmployee ended.");
		return result;
	}
	
	/**
	 * 포탈개인화  G/W [GET] 사용자별 테마 목록 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value= "/rest/ezPortal/themes/users/{userId}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getThemeList(HttpServletRequest request, @PathVariable String userId) throws Exception {
		LOGGER.debug("ezNewPortal G/W getThemeList started.");
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
		LOGGER.debug("ezNewPortal G/W getThemeList ended.");
		return result;
	}
	
	/**
	 * 포탈개인화  G/W [GET] 사용자별 메뉴 정보 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value= "/rest/ezPortal/menus/users/{userId}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getUserMenuList(HttpServletRequest request, @PathVariable String userId) throws Exception {
		LOGGER.debug("ezNewPortal G/W getUserMenuList started.");
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
		LOGGER.debug("ezNewPortal G/W getUserMenuList ended.");
		return result;
	}
	
	/**
	 * 포탈개인화  G/W [PATCH] 개인 메뉴 순서 변경
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value= "/rest/ezPortal/menus/order/users/{userId}", method= RequestMethod.PATCH, produces="application/json;charset=utf-8")
	public JSONObject updateUserMenuOrder(HttpServletRequest request, @PathVariable String userId) throws Exception {
		LOGGER.debug("ezNewPortal G/W updateUserMenuOrder started.");
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
		LOGGER.debug("ezNewPortal G/W updateUserMenuOrder ended.");
		return result;
	}
	
	/**
	 * 포탈개인화  G/W [DELETE] 개인 메뉴 순서 초기화
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value= "/rest/ezPortal/menus/order/users/{userId}", method= RequestMethod.DELETE, produces="application/json;charset=utf-8")
	public JSONObject deleteUserMenuOrder(HttpServletRequest request, @PathVariable String userId) throws Exception {
		LOGGER.debug("ezNewPortal G/W deleteUserMenuOrder started.");
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
		LOGGER.debug("ezNewPortal G/W deleteUserMenuOrder ended.");
		return result;
	}
	
	/**
	 * 포탈개인화  G/W [GET] 퀵링크 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value= "/rest/ezPortal/quickLink/company/{companyId}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
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
	 * 포탈개인화  G/W [GET] 테마 프레임 리스트 및 사용자 지정 프레임 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value= "/rest/ezPortal/frames/users/{userId}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
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
	 * 포탈개인화  G/W [PATCH] 사용자 프레임 설정
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value= "/rest/ezPortal/frames/users/{userId}", method= RequestMethod.PATCH, produces="application/json;charset=utf-8")
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
	 * 포탈개인화  G/W [GET] 포틀릿 개인별 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value= "/rest/ezPortal/portlets/users/{userId}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
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
	 * 포탈개인화  G/W [PATCH] 포틀릿 개인별 사용/미사용 설정
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value= "/rest/ezPortal/portlets/users/{userId}", method= RequestMethod.PATCH, produces="application/json;charset=utf-8")
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
	 * 포탈개인화  G/W [PATCH] 사용자별 테마 적용
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value= "/rest/ezPortal/themes/{themeId}/users/{userId}", method= RequestMethod.PATCH, produces="application/json;charset=utf-8")
	public JSONObject updateUserThemeSetting(HttpServletRequest request, @PathVariable String userId, @PathVariable int themeId) throws Exception {
		LOGGER.debug("ezNewPortal G/W updateUserThemeSetting started.");
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
		LOGGER.debug("ezNewPortal G/W updateUserThemeSetting ended.");
		return result;
	}
	
	/**
	 * 포탈개인화  G/W [DELETE] 사용자 테마 설정 초기화
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value= "/rest/ezPortal/themes/users/{userId}", method= RequestMethod.DELETE, produces="application/json;charset=utf-8")
	public JSONObject deleteUserThemeSetting(HttpServletRequest request, @PathVariable String userId) throws Exception {
		LOGGER.debug("ezNewPortal G/W deleteUserThemeSetting started.");
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
		LOGGER.debug("ezNewPortal G/W deleteUserThemeSetting ended.");
		return result;
	}
	
	/////관리자///////
	/**
	 * 포탈개인화  G/W [GET] 회사 목록 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value= "/rest/admin/ezPortal/companies", method= RequestMethod.GET, produces="application/json;charset=utf-8")
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
	 * 포탈개인화  G/W [GET] 회사별 테마 목록 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value= "/rest/admin/ezPortal/themes/companies/{companyId}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getCompanyThemeList(HttpServletRequest request, @PathVariable String companyId) throws Exception {
		LOGGER.debug("ezNewPortal G/W getCompanyList started.");
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
		LOGGER.debug("ezNewPortal G/W getCompanyList ended.");
		return result;
	}
	
	/**
	 * 포탈개인화  G/W [GET] 회사별 테마 상세정보 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value= "/rest/admin/ezPortal/themes/{themeId}/companies/{companyId}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getCompanyThemeInfo(HttpServletRequest request, @PathVariable int themeId, @PathVariable String companyId) throws Exception {
		LOGGER.debug("ezNewPortal G/W getCompanyThemeInfo started.");
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
		LOGGER.debug("ezNewPortal G/W getCompanyThemeInfo ended.");
		return result;
	}
	
	/**
	 * 포탈개인화  G/W [PATCH] 회사별 테마 상세정보 수정
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value= "/rest/admin/ezPortal/themes/{themeId}/companies/{companyId}", method= RequestMethod.PATCH, produces="application/json;charset=utf-8")
	public JSONObject updateCompanyThemeInfo(HttpServletRequest request, @PathVariable int themeId, @PathVariable String companyId) throws Exception {
		LOGGER.debug("ezNewPortal G/W updateCompanyThemeInfo started.");
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
		LOGGER.debug("ezNewPortal G/W updateCompanyThemeInfo ended.");
		return result;
	}
	
	/**
	 * 포탈개인화  G/W [GET] 회사별 테마 미리보기
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value= "/rest/admin/ezPortal/themes/{themeId}/frames/{frameId}/preview/companies/{companyId}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getCompanyThemePreview(HttpServletRequest request,@PathVariable int themeId, @PathVariable int frameId, @PathVariable String companyId) throws Exception {
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
	 * 포탈개인화  G/W [GET] 회사별 메뉴 목록 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value= "/rest/admin/ezPortal/menus/companies/{companyId}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getCompanyMenuList(HttpServletRequest request, @PathVariable String companyId) throws Exception {
		LOGGER.debug("ezNewPortal G/W getCompanyMenuList started.");
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
		LOGGER.debug("ezNewPortal G/W getCompanyMenuList ended.");
		return result;
	}
	
	/**
	 * 포탈개인화  G/W [PATCH] 회사별 메뉴 순서 변경
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value= "/rest/admin/ezPortal/menus/companies/{companyId}", method= RequestMethod.PATCH, produces="application/json;charset=utf-8")
	public JSONObject updateCompanyMenuOrder(HttpServletRequest request, @PathVariable String companyId) throws Exception {
		LOGGER.debug("ezNewPortal G/W updateCompanyMenuOrder started.");
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
		LOGGER.debug("ezNewPortal G/W updateCompanyMenuOrder ended.");
		return result;
	}
	
	/**
	 * 포탈개인화  G/W [GET] 회사별 메뉴 상세정보 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value= "/rest/admin/ezPortal/menus/{menuId}/companies/{companyId}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getCompanyMenuInfo(HttpServletRequest request, @PathVariable String companyId, @PathVariable int menuId) throws Exception {
		LOGGER.debug("ezNewPortal G/W getCompanyMenuInfo started.");
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
		LOGGER.debug("ezNewPortal G/W getCompanyMenuInfo ended.");
		return result;
	}
	
	/**
	 * 포탈개인화  G/W [PATCH] 회사별 메뉴 상세정보 수정
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value= "/rest/admin/ezPortal/menus/{menuId}/companies/{companyId}", method= RequestMethod.PATCH, produces="application/json;charset=utf-8")
	public JSONObject updateCompanyMenuInfo(HttpServletRequest request, @PathVariable String companyId, @PathVariable int menuId) throws Exception {
		LOGGER.debug("ezNewPortal G/W updateCompanyMenuInfo started.");
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
		LOGGER.debug("ezNewPortal G/W updateCompanyMenuInfo ended.");
		return result;
	}
	
	/**
	 * 포탈개인화  G/W [GET] 메뉴별 권한 정보 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value= "/rest/admin/ezPortal/menus/{menuId}/authorities/companies/{companyId}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getCompanyMenuAuth(HttpServletRequest request, @PathVariable int menuId, @PathVariable String companyId) throws Exception {
		LOGGER.debug("ezNewPortal G/W getCompanyMenuAuth started.");
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
		LOGGER.debug("ezNewPortal G/W getCompanyMenuAuth ended.");
		return result;
	}
	
	/**
	 * 포탈개인화  G/W [PATCH] 메뉴별 권한 정보 수정
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value= "/rest/admin/ezPortal/menus/{menuId}/authorities/companies/{companyId}", method= RequestMethod.PATCH, produces="application/json;charset=utf-8")
	public JSONObject updateCompanyMenuAuth(HttpServletRequest request, @PathVariable int menuId, @PathVariable String companyId) throws Exception {
		LOGGER.debug("ezNewPortal G/W updateCompanyMenuAuth started.");
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
		LOGGER.debug("ezNewPortal G/W updateCompanyMenuAuth ended.");
		return result;
	}
	
	/**
	 * 포탈개인화  G/W [POST] 메뉴 추가
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value= "/rest/admin/ezPortal/menus/companies/{companyId}", method= RequestMethod.POST, produces="application/json;charset=utf-8")
	public JSONObject insertCompanyMenu(HttpServletRequest request, @PathVariable String companyId) throws Exception {
		LOGGER.debug("ezNewPortal G/W insertCompanyMenu started.");
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
		LOGGER.debug("ezNewPortal G/W insertCompanyMenu ended.");
		return result;
	}
	
	/**
	 * 포탈개인화  G/W [DELETE] 메뉴 삭제
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value= "/rest/admin/ezPortal/menus/{menuId}/companies/{companyId}", method= RequestMethod.DELETE, produces="application/json;charset=utf-8")
	public JSONObject deleteCompanyMenu(HttpServletRequest request, @PathVariable int menuId, @PathVariable String companyId) throws Exception {
		LOGGER.debug("ezNewPortal G/W deleteCompanyMenu started.");
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
		LOGGER.debug("ezNewPortal G/W deleteCompanyMenu ended.");
		return result;
	}
	
	/**
	 * 포탈개인화  G/W [GET] 회사별 포틀릿 목록 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value= "/rest/admin/ezPortal/portlets/companies/{companyId}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getCompanyPortletList(HttpServletRequest request, @PathVariable String companyId) throws Exception {
		LOGGER.debug("ezNewPortal G/W getCompanyPortletList started.");
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
		LOGGER.debug("ezNewPortal G/W getCompanyPortletList ended.");
		return result;
	}
	
	/**
	 * 포탈개인화  G/W [PATCH] 회사별 포틀릿 순서 변경
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value= "/rest/admin/ezPortal/portlets/order/companies/{companyId}", method= RequestMethod.PATCH, produces="application/json;charset=utf-8")
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
	 * 포탈개인화  G/W [GET] 회사별 포틀릿 상세조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value= "/rest/admin/ezPortal/portlets/{portletId}/companies/{companyId}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
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
	 * 포탈개인화  G/W [POST] 포틀릿 추가
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value= "/rest/admin/ezPortal/portlets/{portletId}/companies/{companyId}", method= RequestMethod.POST, produces="application/json;charset=utf-8")
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
	 * 포탈개인화  G/W [DELETE] 포틀릿 삭제
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value= "/rest/admin/ezPortal/portlets/{portletId}/companies/{companyId}", method= RequestMethod.DELETE, produces="application/json;charset=utf-8")
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
	 * 포탈개인화  G/W [PATCH] 포틀릿 상세정보 변경
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value= "/rest/admin/ezPortal/portlets/{portletId}/companies/{companyId}", method= RequestMethod.PATCH, produces="application/json;charset=utf-8")
	public JSONObject updatePortletInfo(HttpServletRequest request, @PathVariable int portletId, @PathVariable String companyId) throws Exception {
		LOGGER.debug("ezNewPortal G/W updatePortletInfo started.");
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
		LOGGER.debug("ezNewPortal G/W updatePortletInfo ended.");
		return result;
	}
	
	/**
	 * 포탈개인화  G/W [GET] 게시판 트리 호출
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value= "/rest/admin/ezPortal/boards/tree/companies/{companyId}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
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
	 * 포탈개인화  G/W [GET] 로고 불러오기
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value= "/rest/admin/ezPortal/logos/companies/{companyId}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
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
	 * 포탈개인화  G/W [POST] 로고 등록하기
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value= "/rest/admin/ezPortal/logos/companies/{companyId}", method= RequestMethod.POST, produces="application/json;charset=utf-8")
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
	
	/////포틀릿///////
	/**
	 * 포탈개인화  G/W [GET] 포틀릿 - 게시판 즐겨찾기 포틀릿 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value= "/rest/ezPortal/portlets/boardFavorites", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getFavoriteBoardPortlet(HttpServletRequest request) throws Exception {
		LOGGER.debug("ezNewPortal G/W getFavoriteBoardPortlet started.");
		JSONObject result = new JSONObject();
		
		String userId = request.getParameter("userId");
		String type = request.getParameter("type");
    	String boardId = request.getParameter("boardID");
    	String boardType = request.getParameter("boardType");
    	String mode = request.getParameter("mode");
    	int pageNum = Integer.parseInt(request.getParameter("pageNum"));
    	String orderCell = request.getParameter("orderCell");
    	String orderOption = request.getParameter("orderOption");
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			BoardVO boardVO = new BoardVO();
			boardVO.setBoardId(boardId);
			boardVO.setBoardType(boardType);
			boardVO.setMode(mode);
			boardVO.setPageNum(pageNum);
			boardVO.setOrderCell(orderCell);
			boardVO.setOrderOption(orderOption);
			boardVO.setType(type);
			boardVO.setLang(info.getLang());
			boardVO.setTenantID(info.getTenantId());
			
			if (boardId.equals("{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}")) { // 새게시물
    			boardVO.setBoardType("N");
    			BoardConfigVO boardConfigVO = ezBoardService.getPersonalCount(userInfo);
    			int boardCount = ezBoardService.getNewItemListCount(userInfo);
    			int startRow = 1;
    			int endRow = 0;
    			int personalCount_ = boardConfigVO.getListCount();
    			
    			startRow = (personalCount_ * (boardVO.getPageNum() - 1)) + 1;
    			endRow = (personalCount_ * boardVO.getPageNum());
    			
    			BoardListVO boardListVO = new BoardListVO();
    			
    			boardListVO.setUserID(userInfo.getId());
    			boardListVO.setWriterCompanyID(userInfo.getCompanyID());
    			boardListVO.setTenantID(userInfo.getTenantId());
    			boardListVO.setStartRow(startRow);
    			boardListVO.setEndRow(endRow);
    			boardListVO.setTotalCount(boardCount);
//    			boardListVO.setOrderBySub(orderOption1);
//    			boardListVO.setOrderByMain(orderOption2);
    			
//    			result = getNewItemList(boardVO, userInfo);
    		} else { // 일반게시판
//    			result = getBoardListItem(boardVO, userInfo, type);
    		}
			
			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		LOGGER.debug("ezNewPortal G/W getFavoriteBoardPortlet ended.");
		return result;
	}
	
	/**
	 * 포탈개인화  G/W [GET] 포틀릿 - 게시판 즐겨찾기 포틀릿 탭 리스트 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value= "/rest/ezPortal/portlets/boardFavorites/lists", method= RequestMethod.GET, produces="application/json;charset=utf-8")
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
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "");
			result.put("resultList", resultList);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		LOGGER.debug("ezNewPortal G/W getFavoriteBoardPortletList ended.");
		return result;
	}
	
	/**
	 * 포탈개인화  G/W [GET] 포틀릿 - 커뮤니티 포틀릿 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value= "/rest/ezPortal/portlets/community", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getCommunityPortlet(HttpServletRequest request) throws Exception {
		LOGGER.debug("ezNewPortal G/W getCommunityPortlet started.");
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
		LOGGER.debug("ezNewPortal G/W getCommunityPortlet ended.");
		return result;
	}
	/**
	 * 포탈개인화  G/W [GET] 포틀릿 - 받은 메일 포틀릿 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value= "/rest/ezPortal/portlets/receivedMail", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getReceivedMainPortlet(HttpServletRequest request) throws Exception {
		LOGGER.debug("ezNewPortal G/W getReceivedMainPortlet started.");
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
		LOGGER.debug("ezNewPortal G/W getReceivedMainPortlet ended.");
		return result;
	}
	
	/**
	 * 포탈개인화  G/W [GET] 포틀릿 - 투표 정보 포틀릿 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value= "/rest/ezPortal/portlets/vote", method= RequestMethod.GET, produces="application/json;charset=utf-8")
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
			
			//deptpath 구하기
			String deptPath = ezOrganService.getDeptPath(deptId, tenantId);
			
			//진행중인 투표 중 내가 참여하고 있는 투표의 개수
			int voteCount = ezNewPortalService.getVotePortletCount(userId, companyId, deptPath, tenantId);

			JSONObject data = new JSONObject();
			data.put("voteCount", voteCount);
			
			if (voteCount != 0) {
				//투표 정보 가져오기
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
	 * 포탈개인화  G/W [GET] 포틀릿 - 포토게시판 포틀릿 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value= "/rest/ezPortal/portlets/photoBoard", method= RequestMethod.GET, produces="application/json;charset=utf-8")
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
			int portletId = 0; //포토게시판의 포틀릿 아이디
			int startRow = Integer.parseInt(request.getParameter("startRow"));
			int photoCount = Integer.parseInt(request.getParameter("photoCount"));
			
			String deptPath = info.getDeptPathCode();
			deptPath += "everyone," + deptPath + "," + userId;
			JSONObject data = new JSONObject();
			
			//회사의 포토게시판의 포틀릿 정보 가져오기
			PortletInfoVO portlet = ezNewPortalService.getCompanyPortletInfo(companyId, tenantId, portletId);
			//String boardId = portlet.getPortletBoardId();
			String boardId = "{cd73f88d-e415-43ab-314b-990870b8cf81}";			
			data.put("boardId", boardId);
			
			//게시판 권한 체크
			boolean accessCheck = boardAuthCheck(boardId, deptPath, tenantId, companyId, deptId, userId, rollInfo);
			
			if (!accessCheck) { 
				data.put("access", "false");
			} else {
				//권한이 true이면 boardList불러오기
				List<BoardItemVO> photoBoardList = ezNewPortalService.getPhotoBoardPortletInfo(tenantId, boardId, startRow, photoCount);
				
				data.put("access", "true");
				data.put("photoBoardList", photoBoardList);
			}
			
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		LOGGER.debug("ezNewPortal G/W getPhotoBoardPortlet ended.");
		return result;
	}
	
	/**
	 * 포탈개인화  G/W [GET] 포틀릿 - 공지사항 포틀릿 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value= "/rest/ezPortal/portlets/notice", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getNoticePortlet(HttpServletRequest request) throws Exception {
		LOGGER.debug("ezNewPortal G/W getNoticePortlet started.");
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
		LOGGER.debug("ezNewPortal G/W getNoticePortlet ended.");
		return result;
	}
	
	/**
	 * 포탈개인화  G/W [GET] 포틀릿 - 설문조사 포틀릿 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value= "/rest/ezPortal/portlets/poll", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getPollPortlet(HttpServletRequest request) throws Exception {
		LOGGER.debug("ezNewPortal G/W getPollPortlet started.");
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
		LOGGER.debug("ezNewPortal G/W getPollPortlet ended.");
		return result;
	}
	
	/**
	 * 포탈개인화  G/W [GET] 포틀릿 - 전자결재(결재할 문서, 반송 문서, 기안 문서)
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value= "/rest/ezPortal/portlets/approvalList", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getApprovalListPortlet(HttpServletRequest request) throws Exception {
		LOGGER.debug("ezNewPortal G/W getApprovalListPortlet started.");
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
		LOGGER.debug("ezNewPortal G/W getApprovalListPortlet ended.");
		return result;
	}
	
	/**
	 * 포탈개인화  G/W [GET] 포틀릿 - 즐겨찾기 양식
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value= "/rest/ezPortal/portlets/approvalFormFavorites", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getApprovalFormFavoritesPortlet(HttpServletRequest request) throws Exception {
		LOGGER.debug("ezNewPortal G/W getApprovalFormFavoritesPortlet started.");
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
		LOGGER.debug("ezNewPortal G/W getApprovalFormFavoritesPortlet ended.");
		return result;
	}
	
	/**
	 * 포탈개인화  G/W [GET] 포틀릿 - 즐겨찾기양식 (결재할문서 통계)
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value= "/rest/ezPortal/portlets/approvalStatistics", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getApprovalStatisticsPortlet(HttpServletRequest request) throws Exception {
		LOGGER.debug("ezNewPortal G/W getApprovalStatisticsPortlet started.");
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
		LOGGER.debug("ezNewPortal G/W getApprovalStatisticsPortlet ended.");
		return result;
	}
	
	/**
	 * 포탈개인화  G/W [GET] 포틀릿 - 일정관리
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value= "/rest/ezPortal/portlets/schedule", method= RequestMethod.GET, produces="application/json;charset=utf-8")
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
	
	////////board 권한 체크
	public boolean boardAuthCheck(String boardId, String deptPath, int tenantId, String companyId, String deptId, String userId, String rollInfo) {
		LOGGER.debug("boardAuthCheck started");
		boolean authCheck = false;
		String[] deptPathSplit = deptPath.split(",");
		int deptPathCount = deptPathSplit.length;
		String rootBoardID = "top";
		
		try {
			String boardGroupAdmin_FG = ezBoardAdminService.checkIfBoardGroupAdmin(rootBoardID, userId, deptId, companyId, tenantId);
			
			if (rollInfo != null && (boardGroupAdmin_FG.equals("OK") || rollInfo.toLowerCase().indexOf("c=1") > -1 || rollInfo.toLowerCase().indexOf("k=1") > -1 || rollInfo.toLowerCase().indexOf("n=1") > -1)) {
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
