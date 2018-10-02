package egovframework.ezEKP.ezNewPortal.web;

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

import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezNewPortal.service.EzNewPortalService;
import egovframework.ezMobile.ezOption.service.MOptionService;
import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@RestController
public class EzNewPortalGWController {
	private static final Logger LOGGER = LoggerFactory.getLogger(EzNewPortalGWController.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private EzCommonService ezCommonService;
	
	@Resource(name="ezNewPortalService")
	private EzNewPortalService ezNewPortalService;
	
	@Resource(name="MOptionService")
	private MOptionService mOptionService;

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
		LOGGER.debug("ezNewPortal G/W getFavoriteBoardPortlet ended.");
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
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			
			result.put("status", "ok");
			result.put("code", 0);
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
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			
			result.put("status", "ok");
			result.put("code", 0);
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
}
