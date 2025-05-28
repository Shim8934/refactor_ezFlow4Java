package egovframework.ezEKP.ezNewPortal.web;

import java.awt.Graphics2D;
import java.awt.RenderingHints;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Properties;
import java.util.UUID;

import javax.annotation.Resource;
import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import egovframework.ezEKP.ezNewPortal.service.EzNewPortalService;
import egovframework.ezEKP.ezSystem.service.EzSystemAdminService;
import egovframework.ezEKP.ezSystem.vo.SystemConfigTypeVO;

import org.apache.commons.lang3.StringUtils;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.multipart.MultipartRequest;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.let.user.login.vo.LoginSimpleVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Controller
public class EzNewPortalAdminController extends EgovFileMngUtil {

	private static final Logger logger = LoggerFactory.getLogger(EzNewPortalAdminController.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Autowired
	private EzCommonService ezCommonService;

	@Autowired
	private EzNewPortalService ezNewPortalService;
	
	@Autowired
	private EzSystemAdminService ezSystemAdminService;

	/**
	 * @author 이효진
	 */
	
	
	/**
	 * 관리자 포탈 메인화면 조회
	 */
	@SuppressWarnings("unused")
	@RequestMapping(value = "/admin/ezNewPortal/portalMain.do", method=RequestMethod.GET)
	public String portalMain(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("portalMain started.");

		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);

		if (userInfo == null) {
			logger.debug("portalMain accessDenied.");

			return "cmm/error/adminDenied";
		}
		
		String packageType = commonUtil.getPackageType(userInfo.getTenantId());
		String usePortal = ezCommonService.getTenantConfig("Use_Portal", userInfo.getTenantId());
		
		if(usePortal == null || usePortal.equals("")) {
			usePortal = "YES";
		}
        
        model.addAttribute("packageType", packageType);
        model.addAttribute("usePortal", usePortal);

		logger.debug("portalMain ended.");

		return "/admin/ezNewPortal/portalMain";
	}
	
	/**
	 * 관리자 포탈 Left 화면조회
	 */
	@SuppressWarnings("unused")
	@RequestMapping(value = "/admin/ezNewPortal/portalLeftMenu.do", method=RequestMethod.GET)
	public String portalTopMenu(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("portalLeftMenu started.");

		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);

		if (userInfo == null) {
			logger.debug("portalLeftMenu accessDenied.");

			return "cmm/error/adminDenied";
		}
		
		String packageType = commonUtil.getPackageType(userInfo.getTenantId());
		String usePortal = ezCommonService.getTenantConfig("Use_Portal", userInfo.getTenantId());
        
        model.addAttribute("packageType", packageType);
        model.addAttribute("usePortal", usePortal);

		logger.debug("portalLeftMenu ended.");

		return "/admin/ezNewPortal/portalLeftMenu";
	}
	
	/**
	 * 관리자 포탈 right 화면조회
	 */
	
	/**
	 * 관리자 포탈 테마관리 화면조회
	 */
	@RequestMapping(value = "/admin/ezNewPortal/portalThemes.do", method=RequestMethod.GET)
	public String portalThemes(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest requset) throws Exception {
		logger.debug("portalThemes started.");

		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		String usePortletSize = ezCommonService.getTenantConfig("usePortletSize", userInfo.getTenantId());
		model.addAttribute("usePortletSize", usePortletSize);

		if ("Y".equals(usePortletSize)) {
			model.addAttribute("allSize", ezNewPortalService.getAllAvailablePortletSize());
		}

		String webType = requset.getParameter("type");

		if (webType != null && webType.equals("mobile")) {
			model.addAttribute("webType", webType);
		}

		if (userInfo == null) {
			logger.debug("portalThemes accessDenied.");
			
			return "cmm/error/adminDenied";
		} else {
			logger.debug("portalThemes ended.");
			
			return "/admin/ezNewPortal/portalThemes";
		}
	}
	
	/**
	 * 관리자 포탈 메뉴관리 화면조회
	 */
	@RequestMapping(value = "/admin/ezNewPortal/portalMenus.do", method=RequestMethod.GET)
	public String portalMenus(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		logger.debug("portalMenus started.");
		
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			logger.debug("portalMenus accessDenied.");
			
			return "cmm/error/adminDenied";
		} else {
			logger.debug("portalMenus ended.");

			// 2023-11-23 조소정 - 관리자 > 포탈 > 메뉴관리 > 일본어, 중국어 사용 여부에 따라 메뉴명 표출/미표출 구현
			model.addAttribute("useJapanese", ezCommonService.getTenantConfig("useJapanese", userInfo.getTenantId()));
			model.addAttribute("useChinese", ezCommonService.getTenantConfig("useChinese", userInfo.getTenantId()));
			model.addAttribute("useVietnamese", ezCommonService.getTenantConfig("useVietnamese", userInfo.getTenantId()));
			model.addAttribute("useIndonesian", ezCommonService.getTenantConfig("useIndonesian", userInfo.getTenantId()));
			model.addAttribute("type", request.getParameter("type"));
			String type = request.getParameter("type") == null ? "" : request.getParameter("type");
			String connectMenuId = type.equals("mobile") ? "-2" : "-1";
			model.addAttribute("connectMenuId", connectMenuId);
			model.addAttribute("userLang", userInfo.getLang());
			
			response.setHeader("Pragma", "no-cache"); //HTTP 1.0
			response.setHeader("Cache-Control", "no-cache"); //HTTP 1.1 
			response.setHeader("Cache-Control", "no-store"); //HTTP 1.1 
			response.setDateHeader("Expires", 0L); // Do not cache in proxy server
			return "/admin/ezNewPortal/portalMenus";
		}
	}
	
	/**
	 * 관리자 메뉴 권한 조직도 화면조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/admin/ezNewPortal/portalMenuAuth.do", method=RequestMethod.GET)
	public String portalMenuAuth(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("portalMenuAuth started.");
		
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			logger.debug("portalMenuAuth accessDenied.");
			
			return "cmm/error/adminDenied";
		}
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		param.put("companyId", request.getParameter("companyId"));
		
		JSONObject result = commonUtil.getJsonFromRestApi("/rest/admin/ezPortal/depts", param, request, "get", null);
		String status = result.get("status").toString();
		
		if (status.equals("ok")) {
			JSONArray deptList = (JSONArray) result.get("data");
			JSONArray resultList = new JSONArray();
			
			for (int i = 0; i < deptList.size(); i++) {
				JSONObject dept = (JSONObject) deptList.get(i);
				
				if (dept.get("parent") != null) {
					if (dept.get("isComp").equals("comp")) {
						dept.put("icon", "icon-company");
					} else {
						dept.put("icon", "icon-dept");
					}
					
					if (dept.get("myDept").equals("yes")) {
						JSONObject state = new JSONObject();
						state.put("selected", "true");
						state.put("opened", "true");
						dept.put("state", state);
					}
					
					resultList.add(dept);
				}
			}
			
			model.addAttribute("deptList", resultList);
			model.addAttribute("userId", userInfo.getId());
		}
		
		model.addAttribute("menuId", request.getParameter("menuId"));
		model.addAttribute("companyId", request.getParameter("companyId"));
		model.addAttribute("mode", request.getParameter("mode"));
		
		logger.debug("portalMenuAuth ended");
		
		return "/admin/ezNewPortal/portalMenuAuth";
	}
	
	
	/** **************************** */
	
	/**
	 * 관리자 포탈 회사목록 조회
	 */
	@RequestMapping(value = "/admin/ezNewPortal/getCompanies.do", method=RequestMethod.GET)
	public String getCompanys(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("getCompanys started.");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		param.put("deptId", userInfo.getDeptID());
		param.put("jobId", userInfo.getJobId());
		
		String url = "/rest/admin/ezportal/companies";
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, param, request, "get", null);
				
		String status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {
			model.addAttribute("userCompany", userInfo.getCompanyID());
			model.addAttribute("list", resultBody.get("data"));
			model.addAttribute("primary", resultBody.get("primary"));
			model.addAttribute("usePrimaryLangOnly", resultBody.get("usePrimaryLangOnly"));
		}
		
		logger.debug("getCompanys ended.");
		
		return "json";
	}
	
	/**
	 * 관리자 포탈 테마목록 조회
	 */
	@RequestMapping(value = "/admin/ezNewPortal/getThemes.do", method=RequestMethod.POST)
	public String getPortalThemes(@CookieValue("loginCookie") String loginCookie, @RequestBody Map<String, Object> paramMap, HttpServletRequest request, Model model) throws Exception {
		logger.debug("getPortalThemes started.");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		
		String companyID = (String) paramMap.get("companyId");
		
		if (companyID == null) {
		    logger.debug("--> companyID is null");
		    return "";
		}
		
		String url = "/rest/admin/ezportal/themes/companies/" + companyID;
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, param, request, "get", null);
				
		String status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {
			model.addAttribute("list", resultBody.get("data"));
			model.addAttribute("userLang", userInfo.getLang());
		}
		
		logger.debug("getPortalThemes ended.");
		
		return "json";
	}
	
	/**
	 * 관리자 포탈 테마상세정보 조회
	 */
	@RequestMapping(value = "/admin/ezNewPortal/getThemeInfo.do", method=RequestMethod.POST)
	public String getPortalThemeInfo(@CookieValue("loginCookie") String loginCookie, @RequestBody Map<String, Object> paramMap, HttpServletRequest request, Model model) throws Exception {
		logger.debug("getPortalThemeInfo started.");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		
		String url = "/rest/admin/ezPortal/themes/" + paramMap.get("themeId") + "/companies/" + paramMap.get("companyId");
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, param, request, "get", null);
				
		String status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {
			JSONObject data = (JSONObject) resultBody.get("data");
			model.addAttribute("themeInfo", data.get("themeInfo"));
			model.addAttribute("frameInfos", data.get("frameInfos"));
		}
		
		//해당테마 권한정보요청
		url = "/rest/admin/ezPortal/themes/" + paramMap.get("themeId") + "/authorities/companies/" + paramMap.get("companyId");
		
		resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, param, request, "get", null);
		
		status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {
			//menuAuths 안에 menuAuthsY, menuAuthsN
			model.addAttribute("themeAuths", resultBody.get("data"));
		}
		
		logger.debug("getPortalThemeInfo ended.");
		
		return "json";
	}
	
	/**
	 * 관리자 포탈 테마상세정보 수정
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/admin/ezNewPortal/updateThemeInfo.do", method=RequestMethod.POST)
	@ResponseBody
	public void updateThemeInfo(@CookieValue("loginCookie") String loginCookie, @RequestBody Map<String, Object> paramMap, HttpServletRequest request, Model model) throws Exception {
		logger.debug("updateThemeInfo started.");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		//param.put("themeInfo", paramMap.get("themeInfo"));
		//param.put("frameInfos", paramMap.get("frameInfos"));
		
		JSONObject jsonParam = new JSONObject();
		jsonParam.put("themeInfo", paramMap.get("themeInfo"));
		jsonParam.put("frameInfos", paramMap.get("frameInfos"));
		
		String url = "/rest/admin/ezPortal/themes/" + paramMap.get("themeId") + "/companies/" + paramMap.get("companyId");
		
		commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, param, request, "patch", jsonParam);
		
		logger.debug("updateThemeAuths started.");
		//포틀릿 권한 추가
		jsonParam = new JSONObject();
		jsonParam.put("themeAuths", paramMap.get("themeAuths"));
		
		//해당포틀릿 권한정보 업데이트
		url = "/rest/admin/ezPortal/themes/" + paramMap.get("themeId") + "/authorities/companies/" + paramMap.get("companyId");
		
		commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, param, request, "patch", jsonParam);
		
		logger.debug("updateThemeAuths ended.");
		logger.debug("updateThemeInfo ended.");
	}
	
	/**
	 * 관리자 포탈 테마상세정보 미리보기 -> 이건 스크립트로 하고
	 */
	
	/**
	 * 관리자 메뉴 목록 조회
	 */
	@RequestMapping(value = "/admin/ezNewPortal/getMenus.do", method=RequestMethod.POST)
	public String getMenus(@CookieValue("loginCookie") String loginCookie, @RequestBody Map<String, Object> paramMap, HttpServletRequest request, Model model) throws Exception {
		logger.debug("getMenus started.");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		param.put("type", paramMap.get("type"));
		
		String url = "/rest/admin/ezPortal/menus/companies/" + paramMap.get("companyId");
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, param, request, "get", null);
		
		String status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {
			model.addAttribute("list", resultBody.get("data"));
		}
		
		logger.debug("getMenus ended.");
		
		return "json";
	}
	
	/**
	 * 관리자 메뉴 상세정보 조회
	 */
	@RequestMapping(value = "/admin/ezNewPortal/getMenuInfo.do", method=RequestMethod.POST)
	public String getMenuInfo(@CookieValue("loginCookie") String loginCookie, @RequestBody Map<String, Object> paramMap, HttpServletRequest request, Model model) throws Exception {
		logger.debug("getMenuInfo started.");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		
		//메뉴정보요청
		String url = "/rest/admin/ezPortal/menus/" + paramMap.get("menuId") + "/companies/" + paramMap.get("companyId");
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, param, request, "get", null);
		
		JSONParser jp = new JSONParser();
		resultBody = (JSONObject) jp.parse(resultBody.toJSONString());
		
		String status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {
			//메뉴정보
			JSONObject data = (JSONObject) resultBody.get("data");
			model.addAttribute("menuInfo", data.get("menuInfo"));
			model.addAttribute("menuNames", data.get("menuNames"));
		}
		
		//해당메뉴 권한정보요청
		url = "/rest/admin/ezPortal/menus/" + paramMap.get("menuId") + "/authorities/companies/" + paramMap.get("companyId");
		
		resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, param, request, "get", null);
		
		status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {
			//menuAuths 안에 menuAuthsY, menuAuthsN
			model.addAttribute("menuAuths", resultBody.get("data"));
		}
		
		logger.debug("getMenuInfo ended.");
		
		return "json";
	}
	
	/**
	 * 관리자 메뉴권한목록 조회
	 */
	@RequestMapping(value = "/admin/ezNewPortal/getMenuAuths.do", method=RequestMethod.POST)
	public String getMenuAuths(@CookieValue("loginCookie") String loginCookie, @RequestBody Map<String, Object> paramMap, HttpServletRequest request, Model model) throws Exception {
		logger.debug("getMenuAuths started.");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		
		//해당메뉴 권한정보요청
		String url = "/rest/admin/ezPortal/menus/" + paramMap.get("menuId") + "/authorities/companies/" + paramMap.get("companyId");
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, param, request, "get", null);
		
		String status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {
			//menuAuths 안에 menuAuthsY, menuAuthsN
			model.addAttribute("menuAuths", resultBody.get("data"));
		}
		
		logger.debug("getMenuAuths ended.");
		
		return "json";
	}
	
	/**
	 * 관리자 메뉴 수정
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/admin/ezNewPortal/updateMenu.do", method=RequestMethod.POST)
	@ResponseBody
	public void updateMenu(@CookieValue("loginCookie") String loginCookie, @RequestBody Map<String, Object> paramMap, HttpServletRequest request, Model model) throws Exception {
		logger.debug("updateMenu started.");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		
		JSONObject jsonParam = new JSONObject();
		
		//메뉴정보수정
		jsonParam.put("menuInfo", paramMap.get("menuInfo"));
		jsonParam.put("menuNames", paramMap.get("menuNames"));
		
		String url = "/rest/admin/ezPortal/menus/" + paramMap.get("menuId") + "/companies/" + paramMap.get("companyId");
		
		commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, param, request, "patch", jsonParam);

		//메뉴권한수정
		jsonParam = new JSONObject();
		jsonParam.put("menuAuths", paramMap.get("menuAuths"));
		
		url = "/rest/admin/ezPortal/menus/" + paramMap.get("menuId") + "/authorities/companies/" + paramMap.get("companyId");
		
		commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, param, request, "patch", jsonParam);
		
		logger.debug("updateMenu ended.");
	}
	
	/**
	 * 관리자 메뉴 추가
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/admin/ezNewPortal/insertMenu.do", method=RequestMethod.POST)
	@ResponseBody
	public void insertMenu(@CookieValue("loginCookie") String loginCookie, @RequestBody Map<String, Object> paramMap, HttpServletRequest request, Model model) throws Exception {
		logger.debug("insertMenu started.");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		
		JSONObject jsonParam = new JSONObject();
		
		//메뉴정보추가
		jsonParam.put("menuInfo", paramMap.get("menuInfo"));
		jsonParam.put("menuNames", paramMap.get("menuNames"));
		jsonParam.put("menuAuths", paramMap.get("menuAuths"));
		
		String url = "/rest/admin/ezPortal/menus/companies/" + paramMap.get("companyId");
		
		commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, param, request, "post", jsonParam);
		
		logger.debug("insertMenu ended.");
	}
	
	/**
	 * 관리자 메뉴 삭제
	 */
	@RequestMapping(value = "/admin/ezNewPortal/deleteMenu.do", method=RequestMethod.POST)
	@ResponseBody
	public void deleteMenu(@CookieValue("loginCookie") String loginCookie, @RequestBody Map<String, Object> paramMap, HttpServletRequest request, Model model) throws Exception {
		logger.debug("deleteMenu started.");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		
		String url = "/rest/admin/ezPortal/menus/" + paramMap.get("menuId") + "/companies/" + paramMap.get("companyId");
		
		commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, param, request, "delete", null);
		
		logger.debug("deleteMenu ended.");
	}
	
	/**
	 * 관리자 메뉴 순서조정
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/admin/ezNewPortal/updateMenuOrder.do", method=RequestMethod.POST)
	@ResponseBody
	public void updateMenuOrder(@CookieValue("loginCookie") String loginCookie, @RequestBody Map<String, Object> paramMap, HttpServletRequest request, Model model) throws Exception {
		logger.debug("updateMenuOrder started.");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		
		JSONObject jsonParam = new JSONObject();
		jsonParam.put("menus", paramMap.get("menus"));
		
		String url = "/rest/admin/ezPortal/menus/order/companies/" + paramMap.get("companyId");
		
		commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, param, request, "patch", jsonParam);
		
		logger.debug("updateMenuOrder ended.");
	}
	
	/** ----------------------------------------------- */
	
	
	/**
	 * @author 구해안
	 */
	/**
	 * 관리자 포탈 메뉴관리 화면조회
	 */
	@RequestMapping(value = "/admin/ezNewPortal/portalPortlets.do", method=RequestMethod.GET)
	public String portalManagePortlets(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("portalPortlets started.");
		
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			logger.debug("portalPortlets accessDenied.");
			
			return "cmm/error/adminDenied";
		} else {
			
			HashMap<String, Object> param = new HashMap<String, Object>();
			param.put("userId", userInfo.getId());
			param.put("deptId", userInfo.getDeptID());
			param.put("jobId", userInfo.getJobId());
			
			String url = "/rest/admin/ezportal/companies";
			
			JSONObject resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, param, request, "get", null);
					
			String status = resultBody.get("status").toString();

			// 2023-11-17 조소정 - 관리자 > 포탈 > 포틀릿관리 > 일본어, 중국어 사용 여부에 따라 포틀릿 추가 시 포틀릿명 표출/미표출 구현
			String useJapanese = ezCommonService.getTenantConfig("useJapanese", userInfo.getTenantId());
			String useChinese = ezCommonService.getTenantConfig("useChinese", userInfo.getTenantId());
			String useVietnamese = ezCommonService.getTenantConfig("useVietnamese", userInfo.getTenantId());
			String useIndonesian = ezCommonService.getTenantConfig("useIndonesian", userInfo.getTenantId());

			if (status.equals("ok")) {
				String usePortletSize = ezCommonService.getTenantConfig("usePortletSize", userInfo.getTenantId());
				model.addAttribute("usePortletSize", usePortletSize);
				model.addAttribute("companyList", resultBody.get("data"));
				model.addAttribute("userCompany", resultBody.get("userCompany"));
				// 2024-08-22 유길상 - 관리자 > 포탈 > 포틀릿 관리 > 포틀릿 저장 시 포틀릿 명 언어 처리 오류로 수정
//				model.addAttribute("lang", resultBody.get("lang"));
				model.addAttribute("lang", userInfo.getLang());
				model.addAttribute("useJapanese", useJapanese);
				model.addAttribute("useChinese", useChinese);
				model.addAttribute("useVietnamese", useVietnamese);
				model.addAttribute("useIndonesian", useIndonesian);
				model.addAttribute("approvalFlag", ezCommonService.getTenantConfig("approvalFlag", userInfo.getTenantId()));
				model.addAttribute("type", request.getParameter("type"));

				if ("Y".equals(usePortletSize)) {
					List<String> allSize = ezNewPortalService.getAllAvailablePortletSize();
					model.addAttribute("allSize", allSize);
				}
				
				String type = request.getParameter("type") == null ? "" : request.getParameter("type");
				String connectMenuId = type.equals("mobile") ? "-2" : "-1";
				model.addAttribute("connectMenuId", connectMenuId);
			}
			
			logger.debug("portalPortlets ended.");
			return "/admin/ezNewPortal/portalPortlets";
		}
	}
	
	//관리자 로고관리 > 화면 출력
	@RequestMapping(value = "/admin/ezNewPortal/portalLogos.do", method=RequestMethod.GET)
	public String portalManageLogo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("portalManageLogo started.");
		
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			logger.debug("portalManageLogo accessDenied.");
			
			return "cmm/error/adminDenied";
		} else {
        	String isAdmin = userInfo.getRollInfo();
        	boolean adminCheck = false;
        	
        	if (isAdmin.indexOf("c=1") == -1) {
        		adminCheck = false; 
        	} else {
        		adminCheck = true;
        	}
        	
			// 2025-03-07 황인경 - 관리자 > 포탈 > 모바일포탈관리 > 로고관리
			String type = "";
			
			if (request.getParameter("type") != null && request.getParameter("type").equals("mobile")) {
				type = "mobile";
				model.addAttribute("mobileCheck", "Y");
			} else {
				model.addAttribute("mobileCheck", "N");
			};
			
        	model.addAttribute("adminCheck", adminCheck);
			logger.debug("portalManageLogo ended.");
			return "/admin/ezNewPortal/portalLogos";
		}
	}
	
	/**
	 * 관리자 포탈 포틀릿목록 조회
	 */
	@RequestMapping(value = "/admin/ezNewPortal/getPortlets.do", method=RequestMethod.POST)
	@ResponseBody
	public JSONArray getPortalPortlets(@CookieValue("loginCookie") String loginCookie, @RequestBody Map<String, Object> paramMap,
			HttpServletRequest req, Model model) throws Exception {
		logger.debug("getPortalPortlets started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String companyId = paramMap.get("companyId").toString();
		String url = "/rest/admin/ezPortal/portlets/companies/" + companyId;
		
		paramMap.put("userId", userInfo.getId());		
		paramMap.put("type", req.getParameter("type"));		
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, paramMap, req, "get", null);
		String result = resultBody.get("status").toString();
		JSONArray json = new JSONArray();
		
		if (result.equals("ok")) {
			JSONObject data = (JSONObject) resultBody.get("data");
			json = (JSONArray) data.get("PortletList");
		}
		logger.debug("json : " + json);
		logger.debug("getPortalPortlets Ended");
		return json;
	}
	
	/**
	 * 관리자 포탈 포틀릿 업데이트
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/admin/ezNewPortal/updatePortlet.do", method=RequestMethod.POST)
	@ResponseBody
	public void updatePortlet(@CookieValue("loginCookie") String loginCookie, HttpServletRequest req, @RequestBody JSONObject json, Model model) throws Exception {
		logger.debug("updatePortlet started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String portletId = json.get("portletId").toString();
		String companyId = json.get("companyId").toString();
		String url = "/rest/admin/ezPortal/portlets/" + portletId + "/companies/" + companyId;
		
		json.put("userId", userInfo.getId());
		
		commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, null, req, "patch", json);
		logger.debug("updatePortlet Ended");
	}
	
	/** ----------------------------------------------- */
	
	/**
	 * @author 유은정
	 */
	
	//메뉴 아이콘 선택 화면 호출
	@RequestMapping(value = "/admin/ezNewPortal/selectMenuIcon.do", method=RequestMethod.GET)
	public String portalMenuIconSelect(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("portalMenuIconSelect started.");

		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			logger.debug("portalMenuIconSelect accessDenied.");
			
			return "cmm/error/adminDenied";
		} else {
			logger.debug("portalMenuIconSelect ended.");
			
			return "/admin/ezNewPortal/portalMenuIconSelect";
		}
	}
	
	/**
	 * 게시판 트리 오픈
	 * @param loginCookie
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/admin/ezNewPortal/openBoardTree.do", method=RequestMethod.GET)
	public String openBoardTree(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("openBoardTree started.");

		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			logger.debug("openBoardTree accessDenied.");
			
			return "cmm/error/adminDenied";
		} else {
			logger.debug("openBoardTree ended.");
			//게시판이 top인 목록 가져오기
			String userId = userInfo.getId();
			String companyId = request.getParameter("companyId");
			String portletBoardId = request.getParameter("portletBoardId");
			
			Map<String, Object> param = new HashMap<String, Object>();
			param.put("parentBoardId", "top");
			param.put("userId", userId);
			param.put("portletBoardId", portletBoardId);
			
			String url = "/rest/admin/ezPortal/boards/tree/companies/" + companyId;
			
			JSONObject resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, param, request, "get", null);
			String result = resultBody.get("status").toString();
			String portletBoardGroupID = resultBody.get("portletBoardGroupID").toString();
			
			if (result.equals("ok")) {
				model.addAttribute("boardList", resultBody.get("data"));
				model.addAttribute("companyId", companyId);
				model.addAttribute("portletId", request.getParameter("portletId"));
				model.addAttribute("portletCode", request.getParameter("code"));
				model.addAttribute("portletBoardId", portletBoardId);
				model.addAttribute("portletBoardGroupID", portletBoardGroupID);
			}
			
			logger.debug("openBoardTree ended.");
			return "/admin/ezNewPortal/portalBoardTree";
		}
	}
	
	/**
	 * 게시판 트리 가져오기
	 * @param loginCookie
	 * @param req
	 * @param paramMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/admin/ezNewPortal/getSubBoards.do", method=RequestMethod.POST)
	@ResponseBody
	public ResponseEntity<JSONArray> getSubBoards(@CookieValue("loginCookie") String loginCookie, HttpServletRequest req, @RequestBody Map<String, Object> paramMap, Model model) throws Exception {
		logger.debug("getSubBoards started.");
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);

		if (userInfo == null) {
			logger.debug("getSubBoards accessDenied.");

			return ResponseEntity.status(HttpStatus.FORBIDDEN).body(new JSONArray());
		}

		String userId = userInfo.getId();
		String companyId = paramMap.get("companyId").toString();
		JSONArray subBoards = new JSONArray();
		
		paramMap.put("userId", userId);
		
		String url = "/rest/admin/ezPortal/boards/tree/companies/" + companyId;

		JSONObject resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, paramMap, req, "get", null);
		String result = resultBody.get("status").toString();
		
		if (result.equals("ok")) {
			subBoards = (JSONArray) resultBody.get("data");
		}
		
		logger.debug("getSubBoards ended.");
		return ResponseEntity.ok().body(subBoards);
	}
	
	/**
	 * 관리자 포탈 포틀릿 추가
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/admin/ezNewPortal/addPortlet.do", method=RequestMethod.POST)
	@ResponseBody
	public void addPortlets(@CookieValue("loginCookie") String loginCookie, HttpServletRequest req, @RequestBody JSONObject json, Model model) throws Exception {
		logger.debug("addPortlets started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String companyId = json.get("companyId").toString();
		String url = "/rest/admin/ezPortal/portlets/companies/" + companyId;
		
		String type = req.getParameter("type");

		json.put("userId", userInfo.getId());
		json.put("type", req.getParameter("type"));
		
		commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, null, req, "post", json);
		
		logger.debug("addPortlets Ended");
	}
	
	/**
	 * 관리자 포탈 포틀릿 삭제
	 */
	@RequestMapping(value = "/admin/ezNewPortal/deletePortlet.do", method=RequestMethod.POST)
	@ResponseBody
	public void deletePortlets(@CookieValue("loginCookie") String loginCookie, @RequestBody Map<String, Object> paramMap, HttpServletRequest req, Model model) throws Exception {
		logger.debug("addPortlets started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String portletId = paramMap.get("portletId").toString();
		String companyId = paramMap.get("companyId").toString();
		String url = "/rest/admin/ezPortal/portlets/" + portletId + "/companies/" + companyId;
		
		paramMap.put("userId", userInfo.getId());		
		
		commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, paramMap, req, "delete", null);
		logger.debug("addPortlets Ended");
	}
	
	/**
	 * 관리자 포탈 포틀릿 순서 업데이트
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/admin/ezNewPortal/updatePortletOrder.do", method=RequestMethod.POST)
	@ResponseBody
	public void updatePortletOrder(@CookieValue("loginCookie") String loginCookie, @RequestBody JSONObject json, HttpServletRequest req, Model model) throws Exception {
		logger.debug("updatePortletOrder started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String companyId = json.get("companyId").toString();
		String url = "/rest/admin/ezPortal/portlets/order/companies/" + companyId;
		
		json.put("userId", userInfo.getId());		
		
		commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, null, req, "patch", json);
		logger.debug("updatePortletOrder Ended");
	}
	
	/**
	 * 메뉴 목록 가져오기
	 * @param loginCookie
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/admin/ezNewPortal/openPortalMenu.do", method=RequestMethod.GET)
	public String openPortalMenu(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("openPortalMenu started.");

		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			logger.debug("openBoardTree accessDenied.");
			
			return "cmm/error/adminDenied";
		} else {
			logger.debug("openBoardTree ended.");
			//게시판이 top인 목록 가져오기
			String userId = userInfo.getId();
			String companyId = request.getParameter("companyId");
			String webType = request.getParameter("type") == null ? "" : request.getParameter("type");
			
			Map<String, Object> param = new HashMap<String, Object>();
			param.put("userId", userId);
			
			String url = "/rest/admin/ezPortal/menus/companies/" + companyId;
			
			JSONObject resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, param, request, "get", null);
			String result = resultBody.get("status").toString();
			
			if (result.equals("ok")) {
				model.addAttribute("menuList", resultBody.get("data"));
				model.addAttribute("companyId", companyId);
				model.addAttribute("portletId", commonUtil.stripScriptTags(request.getParameter("portletId")));
				model.addAttribute("webType", webType);
				String connectMenuID = webType.equals("mobile") ? "-2" : "-1";
				model.addAttribute("connectMenuID", connectMenuID);
			}
			
			logger.debug("openPortalMenu ended.");
			return "/admin/ezNewPortal/portalPortletMenu";
		}
	}
	
	//관리자 로고리스트 불러오기
	@RequestMapping(value = "/admin/ezNewPortal/getCompanyLogos.do", method=RequestMethod.POST)
	@ResponseBody
	public JSONArray getCompanyLogos(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, @RequestBody Map<String, Object> paramMap, Model model) throws Exception {
		logger.debug("getCompanyLogos started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String companyId = paramMap.get("companyId").toString();
		String url = "/rest/admin/ezPortal/logos/companies/" + companyId;
		paramMap.put("userId", userInfo.getId());
		
		// 2025-03-07 황인경 - 관리자 > 포탈 > 모바일포탈관리 > 로고관리
		if (request.getParameter("mobile") != null && !request.getParameter("mobile").equals("")) {
			paramMap.put("mobileCheck", request.getParameter("mobile"));
		} else {
			paramMap.put("mobileCheck", "N");
		}
		
		JSONArray logoList = new JSONArray();
		JSONObject result = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, paramMap, request, "get", null);
		String status = result.get("status").toString();
		
		if (status.equals("ok")) {
			logoList = (JSONArray) result.get("data");
		}
		
		logger.debug("getCompanyLogos Ended");
		
		return logoList;
	}
	
	//로고 업로드
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/admin/ezNewPortal/uploadLogo.do", produces = "text/plain; charset=utf-8", method=RequestMethod.POST)
	@ResponseBody
	public String updateCompanyLogo(@CookieValue("loginCookie") String loginCookie, MultipartHttpServletRequest request) throws Exception {
		logger.debug("updateCompanyLogo started");
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);

		String logoType = request.getParameter("logoType");

		if (userInfo == null || 
		    (!userInfo.getRollInfo().contains("c=1") && ("L".equalsIgnoreCase(logoType) || "ML".equalsIgnoreCase(logoType)))) {
		    return "rejected";
		}

		String companyId = request.getParameter("companyId").toString();
		String url = "/rest/admin/ezPortal/logos/companies/" + companyId;
		String userId = userInfo.getId();
		JSONObject json = new JSONObject();
		json.put("userId", userId);
        json.put("logoType", logoType);
        String logoUrl = "";

		MultipartFile multiFile = request.getFile("file");
		
		String realPath = request.getServletContext().getRealPath("");
		String pFileName = "";
        String sGUID = "";
        String pUploadSN = "";        
        String useExtension = ezCommonService.getTenantConfig("USE_FileExtension", userInfo.getTenantId());
		// 2025-01-17 전인하 - 로고를 저장할 시 전자결재 폴더에도 따로 로고 저장; 유통문서 발송 시 로고로 사용함
		String dirPathForApr = realPath + commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator + userInfo.getCompanyID();
        
        sGUID = UUID.randomUUID().toString();
        pUploadSN = "{" + sGUID + "}";

        if (StringUtils.isNotEmpty(multiFile.getOriginalFilename()) && StringUtils.isNotBlank(multiFile.getOriginalFilename())) {        	
            String _pFileName = multiFile.getOriginalFilename();
            
            if (_pFileName.indexOf(commonUtil.separator) > 0) {
                _pFileName = _pFileName.split("/")[_pFileName.split("/").length - 1];
            }
            
            pFileName = _pFileName;
        }
        
        String pDirPath = commonUtil.getUploadPath("upload_newPortal.ROOT", userInfo.getTenantId());
        pDirPath = realPath + pDirPath;
        
        if (!pDirPath.substring(pDirPath.length() - 1).equals(commonUtil.separator)) {
        	pDirPath = pDirPath + commonUtil.separator;
        }
        
        pDirPath = commonUtil.detectPathTraversal(pDirPath);
        
        File file = new File(pDirPath + "uploadFile");

        if (!file.exists()) {
        	file.mkdirs();        
        }
        
        String extend = pFileName.substring(pFileName.lastIndexOf(".") + 1);
        String newFileName = pUploadSN + "." + extend;
        
		// dhlee : 20220527 - 파일 업로드 시 .으로 끝나는 파일(예: .jsp.)이 무조건 업로드 허용되는 문제 수정
        if ((!extend.isEmpty() && useExtension.toLowerCase().indexOf(extend.toLowerCase()) != -1) || useExtension.equals("*")) {           	
			writeUploadedFile(multiFile, newFileName, pDirPath + "uploadFile");
			writeUploadedFile(multiFile, "logo.gif", dirPathForApr);
			
			String originUrl = "/rest/admin/ezPortal/logos/companies/" + companyId;
			JSONObject originResult = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), originUrl, null, request, "patch", json);
			String originStatus = originResult.get("status").toString();
			
			if (originStatus.equals("ok")) {
				JSONArray logoList = (JSONArray) originResult.get("data");
				int logoListCount = logoList.size();
				
				for (int i = 0; i < logoListCount; i ++) {
					JSONObject logo = (JSONObject) logoList.get(i);
					
					if (logo.get("logoType").equals(logoType)) {
						String filePath = pDirPath + "uploadFile" + logo.get("logoUrl");
						deleteFile(filePath);
					}
				}
			}
        }
        
        json.put("logoUrl", newFileName);
		JSONObject result = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, null, request, "patch", json);
		String status = result.get("status").toString();
		
		if (status.equals("ok")) {
			logoUrl = commonUtil.getUploadPath("upload_newPortal.ROOT", userInfo.getTenantId()) + commonUtil.separator + "uploadFile" + commonUtil.separator + newFileName;
		}
		
		logger.debug("logoUrl : " + logoUrl);
		logger.debug("updateCompanyLogo ended");
		
		return logoUrl;
	}
	
	/**
	 * 관리자 포탈 테마상세정보 미리보기 호출
	 */
	@RequestMapping(value = "/admin/ezNewPortal/themePreview.do", method=RequestMethod.GET)
	public String themePreview(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("themePreview started.");

		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			logger.debug("themePreview accessDenied.");
			
			return "cmm/error/adminDenied";
		} else {
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
			
			model.addAttribute("themeId", request.getParameter("themeId"));
			model.addAttribute("frameId", request.getParameter("frameId"));
			model.addAttribute("imgFolder", imgFolder);
			logger.debug("themePreview ended.");
			return "/admin/ezNewPortal/themePreview";
		}
	}
	
	@RequestMapping(value = "/admin/ezNewPortal/updateCompanyDefaultTheme.do", method=RequestMethod.POST)
	@ResponseBody
	public void updateCompanyDefaultTheme(@CookieValue("loginCookie") String loginCookie, @RequestBody Map<String, Object> paramMap, HttpServletRequest request, Model model) throws Exception {
		logger.debug("updateCompanyDefaultTheme started.");

		LoginVO user = commonUtil.checkAdmin(loginCookie);
		
		if (user == null) {
			logger.debug("updateCompanyDefaultTheme accessDenied.");
			
		} else {
			LoginVO userInfo = commonUtil.userInfo(loginCookie);
			String userId = userInfo.getId();
			String themeId = paramMap.get("themeId").toString();
			String companyId = paramMap.get("companyId").toString();
			
			paramMap.put("userId", userId);
			
			String url = "/rest/admin/ezPortal/themes/" + themeId + "/default/companies/" + companyId;
			
			commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, paramMap, request, "patch", null);
			
			logger.debug("updateCompanyDefaultTheme ended.");
		}
	}
	
	@RequestMapping(value = "/admin/ezNewPortal/deleteLogo.do", method=RequestMethod.POST)
	@ResponseBody
	public void deleteLogo(@CookieValue("loginCookie") String loginCookie, @RequestBody Map<String, Object> paramMap, HttpServletRequest request, Model model) throws Exception {
		logger.debug("deleteLogo started.");

		LoginVO user = commonUtil.checkAdmin(loginCookie);
		
		if (user == null) {
			logger.debug("deleteLogo accessDenied.");
			
		} else {
			LoginVO userInfo = commonUtil.userInfo(loginCookie);
			String userId = userInfo.getId();
			String logoType = paramMap.get("logoType").toString();
			String companyId = paramMap.get("companyId").toString();
			
			paramMap.put("userId", userId);
			
			String url = "/rest/admin/ezPortal/logos/" + logoType + "/companies/" + companyId;
			
			commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, paramMap, request, "delete", null);
			
			logger.debug("deleteLogo ended.");
		}
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/admin/ezNewPortal/resetMenuOrder.do", method=RequestMethod.POST)
	@ResponseBody
	public void resetMenuOrder(@CookieValue("loginCookie") String loginCookie, @RequestBody Map<String, Object> paramMap, HttpServletRequest request, Model model) throws Exception {
		logger.debug("resetMenuOrder started.");

		LoginVO user = commonUtil.checkAdmin(loginCookie);
		
		if (user == null) {
			logger.debug("resetMenuOrder accessDenied.");
			
		} else {
			LoginVO userInfo = commonUtil.userInfo(loginCookie);
			String userId = userInfo.getId();
			String companyId = paramMap.get("companyId").toString();
			
			//default order가져오기 (mode가 reset인 경우 default order로 초기화)			
			paramMap.put("mode", "reset");
			paramMap.put("userId", userId);
			
			JSONObject jsonParam = new JSONObject();
			jsonParam.put("userId", userId);
			jsonParam.put("mode", "reset");
			
			String url = "/rest/admin/ezPortal/menus/order/companies/" + companyId;
			
			commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, paramMap, request, "patch", jsonParam);
			
			
			logger.debug("resetMenuOrder ended.");
		}
	}

	@RequestMapping(value = "/admin/ezNewPortal/getThemePortletList.do", method=RequestMethod.POST)
	@ResponseBody
	public JSONObject getThemePortletList(@CookieValue("loginCookie") String loginCookie, @RequestBody Map<String, Object> paramMap, HttpServletRequest request, Model model) throws Exception {
		logger.debug("getThemePortletList started");
		JSONObject jo = new JSONObject();
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String themeId = paramMap.get("themeId").toString();
		String companyId = paramMap.get("companyId").toString();
		String userId = userInfo.getId();
		
		String url = "/rest/admin/ezPortal/themes/" + themeId + "/portlets/companies/" + companyId;
		paramMap.put("userId", userId);
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, paramMap, request, "get", null);
		String status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {
			jo.put("poList", resultBody.get("data"));
			if (resultBody.containsKey("fixBoard")) {
				jo.put("fixBoard",  resultBody.get("fixBoard"));
			}
		}
		
		logger.debug("getThemePortletList ended");
		return jo;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/admin/ezNewPortal/updateThemePortletUsed.do", method=RequestMethod.POST)
	@ResponseBody
	public void updateThemePortletUsed(@CookieValue("loginCookie") String loginCookie, @RequestBody JSONObject json, HttpServletRequest request, Model model) throws Exception {
		logger.debug("updateThemePortletUsed started");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String themeId = json.get("themeId").toString();
		String companyId = json.get("companyId").toString();
		String userId = userInfo.getId();
		String webType = "web";
		if (json.get("webType") != null) {
			webType = json.get("webType").toString();
		}
		
		String url = "/rest/admin/ezPortal/themes/" + themeId + "/portlets/companies/" + companyId;
		json.put("userId", userId);
		json.put("webType", webType);
		
		commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, null, request, "patch", json);
		
		logger.debug("updateThemePortletUsed ended");
	}
	
	// 2019.06.18 테마별, 포틀릿별 권한 설정 기능 추가
	/**
	 * 관리자 테마권한목록 조회
	 */
	@RequestMapping(value = "/admin/ezNewPortal/getThemeAuths.do", method=RequestMethod.GET)
	@ResponseBody
	public String getThemeAuths(@CookieValue("loginCookie") String loginCookie, @RequestBody Map<String, Object> paramMap, HttpServletRequest request, Model model) throws Exception {
		logger.debug("getThemeAuths started.");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		
		//해당메뉴 권한정보요청
		String url = "/rest/admin/ezPortal/themes/" + paramMap.get("themeId") + "/authorities/companies/" + paramMap.get("companyId");
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, param, request, "get", null);
		
		String status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {
			//menuAuths 안에 menuAuthsY, menuAuthsN
			status = resultBody.get("data").toString();
		}
		
		logger.debug("status : " + status);
		logger.debug("getThemeAuths ended.");
		
		return status;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/admin/ezNewPortal/checkThemeAuths.do", method=RequestMethod.POST)
	public String checkThemeAuths(@CookieValue("loginCookie") String loginCookie, @RequestBody Map<String, Object> paramMap, HttpServletRequest request, Model model) throws Exception {
		logger.debug("checkThemeAuths started.");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		
		JSONObject jsonParam = new JSONObject();
		jsonParam.put("themeAuths", paramMap.get("themeAuths"));
		
		String url = "/rest/admin/ezPortal/themes/" + paramMap.get("themeId") + "/authorities/checks/companies/" + paramMap.get("companyId");
		JSONObject resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, param, request, "patch", jsonParam);
		
		String status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {
			model.addAttribute("authResult", resultBody.get("data"));
		}
		
		logger.debug("checkThemeAuths ended.");
		return "json";
	}
	/**
	 * 관리자 포틀릿권한목록 조회
	 */
	@RequestMapping(value = "/admin/ezNewPortal/getPortletAuths.do", method=RequestMethod.GET)
	public String getPortletAuths(@CookieValue("loginCookie") String loginCookie, @RequestBody Map<String, Object> paramMap, HttpServletRequest request, Model model) throws Exception {
		logger.debug("getPortletAuths started.");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		
		//해당메뉴 권한정보요청
		String url = "/rest/admin/ezPortal/portlets/" + paramMap.get("themeId") + "/authorities/companies/" + paramMap.get("companyId");
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, param, request, "get", null);
		
		String status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {
			//menuAuths 안에 menuAuthsY, menuAuthsN
			model.addAttribute("portletAuths", resultBody.get("data"));
		}
		
		logger.debug("getPortletAuths ended.");
		
		return "json";
	}
	
	//포틀릿 권한 창 열기
	@RequestMapping(value = "/admin/ezNewPortal/openPortletAuthSetting.do", method=RequestMethod.GET)
	public String openPortletAuthSetting(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("openPortletAuthSetting started.");
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			logger.debug("openPortletAuthSetting accessDenied.");
			
			return "cmm/error/adminDenied";
		}
		
		//게시판이 top인 목록 가져오기
		// String userId = userInfo.getId();
		String companyId = request.getParameter("companyId");
		String portletId = request.getParameter("portletId");
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		
		String url = "/rest/admin/ezPortal/portlets/" + portletId + "/authorities/companies/" + companyId;

		JSONObject resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, param, request, "get", null);
		
		String status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {
			//menuAuths 안에 menuAuthsY, menuAuthsN
			model.addAttribute("portletAuths", resultBody.get("data"));
		}
		
		model.addAttribute("companyId", companyId);
		model.addAttribute("portletId", portletId);

		logger.debug("openPortletAuthSetting ended.");
		return "/admin/ezNewPortal/portletAuthSetting";
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/admin/ezNewPortal/updatePortletAuth.do", method=RequestMethod.POST)
	@ResponseBody
	public String updatePortletAuth(@CookieValue("loginCookie") String loginCookie, @RequestBody Map<String, Object> paramMap, HttpServletRequest request, Model model) throws Exception {
		logger.debug("updatePortletAuth started.");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		
		JSONObject jsonParam = new JSONObject();
		jsonParam.put("portletAuths", paramMap.get("portletAuths"));
		
		//포틀릿 업데이트 
		String url = "/rest/admin/ezPortal/portlets/" + paramMap.get("portletId") + "/authorities/companies/" + paramMap.get("companyId");
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, param, request, "patch", jsonParam);
		
		String status = resultBody.get("status").toString();
		
		logger.debug("status : " + status);
		logger.debug("updatePortletAuth ended.");
		
		return status;
	}
	
	// -----------------------------------------------------------------------------
	/**
	 * 슬라이드 이미지 설정 화면
	 * @param loginCookie
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/admin/ezNewPortal/openSlideImageSetting.do", method=RequestMethod.GET)
	public String openSlideImageSetting(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("openSlideImageSetting started.");

		// LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		//게시판이 top인 목록 가져오기
		// String userId = userInfo.getId();
		String companyId = request.getParameter("companyId");
		String portletId = request.getParameter("portletId");
		model.addAttribute("companyId", companyId);
		model.addAttribute("portletId", portletId);
		
		logger.debug("openSlideImageSetting ended.");
		return "/admin/ezNewPortal/portalSlideImageSetting";
	}
	
	/**
	 * 슬라이드 이미지 설정 화면 슬라이드 이미지 목록 출력
	 * @param loginCookie
	 * @param paramMap
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/admin/ezNewPortal/getSlideImages.do", method=RequestMethod.POST)
	public String getSlideImages(@CookieValue("loginCookie") String loginCookie, @RequestBody Map<String, Object> paramMap, HttpServletRequest request, Model model) throws Exception {
		logger.debug("getSlideImages started.");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		
		String url = "/rest/admin/ezportal/slideimages/companies/" + paramMap.get("companyId");
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, param, request, "get", null);
				
		String status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {
			model.addAttribute("list", resultBody.get("data"));
		}
		
		logger.debug("getSlideImages ended.");
		
		return "json";
	}
	
	/**
	 * 슬라이드 이미지 설정 화면 이미지 업로드
	 * @param loginCookie
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/admin/ezNewPortal/uploadSlideImage.do", produces = "text/plain; charset=utf-8", method=RequestMethod.POST)
	@ResponseBody
	public String uploadSlideImage(@CookieValue("loginCookie") String loginCookie, MultipartHttpServletRequest request, Model model) throws Exception {
		logger.debug("uploadSlideImages started.");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String companyId = request.getParameter("companyId").toString();
		String result = "";
		
        String imagePath = "";

		MultipartFile multiFile =  ((MultipartRequest) request).getFile("file");
		
		String realPath = request.getServletContext().getRealPath("");
		String pFileName = "";
        String sGUID = "";
        String pUploadSN = "";        
        String useExtension = ezCommonService.getTenantConfig("USE_FileExtension", userInfo.getTenantId());
        
        sGUID = UUID.randomUUID().toString();
        pUploadSN = "{" + sGUID + "}";

        if (StringUtils.isNotEmpty(multiFile.getOriginalFilename()) && StringUtils.isNotBlank(multiFile.getOriginalFilename())) {        	
            String _pFileName = multiFile.getOriginalFilename();
            
            if (_pFileName.indexOf(commonUtil.separator) > 0) {
                _pFileName = _pFileName.split("/")[_pFileName.split("/").length - 1];
            }
            
            pFileName = _pFileName;
        }
        
        String pDirPath = commonUtil.getUploadPath("upload_newPortal.ROOT", userInfo.getTenantId());
        pDirPath = pDirPath + commonUtil.separator + companyId + commonUtil.separator + "slideImagePortlet";
        
        if (!pDirPath.substring(pDirPath.length() - 1).equals(commonUtil.separator)) {
        	pDirPath = pDirPath + commonUtil.separator;
        }
        
        String slidePath = realPath + pDirPath;
        slidePath = commonUtil.detectPathTraversal(slidePath);
        slidePath = commonUtil.stripScriptTags(slidePath);
        
        File file = new File(slidePath);

        if (!file.exists()) {
        	file.mkdirs();        
        }
        
        String extend = pFileName.substring(pFileName.lastIndexOf(".") + 1);
        String newFileName = pUploadSN + "." + extend;
        
		// dhlee : 20220527 - 파일 업로드 시 .으로 끝나는 파일(예: .jsp.)이 무조건 업로드 허용되는 문제 수정
        if ((!extend.isEmpty() && useExtension.toLowerCase().indexOf(extend.toLowerCase()) != -1) || useExtension.equals("*")) {           	
			writeUploadedFile(multiFile, newFileName, realPath + pDirPath);
			
			imagePath = commonUtil.detectPathTraversal(realPath + pDirPath + newFileName);
			
			File imageFile = new File(imagePath); 
			
			String saveName = UUID.randomUUID() + ".jpg";
			if (imageFile.exists()) {
				BufferedImage inputImage = ImageIO.read(imageFile);
				BufferedImage outputImage = null;
				Graphics2D saveImage = null;
				
				outputImage= new BufferedImage(617, 250, BufferedImage.TYPE_INT_RGB);
				saveImage = outputImage.createGraphics();
				saveImage.drawImage(inputImage, 0, 0, 617, 250, null);
				saveImage.setRenderingHint(RenderingHints.KEY_INTERPOLATION, RenderingHints.VALUE_INTERPOLATION_BICUBIC);
				
				String imagePath2 = realPath + pDirPath + saveName;
				imagePath2 = commonUtil.detectPathTraversal(imagePath2);
				
				File newFile = new File(imagePath2);
				
				ImageIO.write(outputImage, "png" , newFile);
				deleteFile(imagePath);

			}

			result = pDirPath + saveName;
        }

		logger.debug("uploadSlideImages ended.");
		
		return result;
	}
	
	/**
	 * 관리자 슬라이드포틀릿 이미지 설정 저장버튼 클릭시
	 * @param loginCookie
	 * @param paramMap
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/admin/ezNewPortal/saveSlideImages.do", method=RequestMethod.POST)
	public String saveSlideImages(@CookieValue("loginCookie") String loginCookie, @RequestBody Map<String, Object> paramMap, HttpServletRequest request, Model model) throws Exception {
		logger.debug("saveSlideImages started.");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String imagePath = paramMap.get("imagePath").toString();
		String imageUrl = paramMap.get("imageUrl").toString();
		String imageName = paramMap.get("imageName").toString();
		String mode = paramMap.get("mode").toString();
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		param.put("imagePath", imagePath);
		param.put("imageUrl", imageUrl);
		param.put("imageName", imageName);
		
		String url = "";
		String type = "";
		if (mode.equals("new")) {
			url = "/rest/admin/ezportal/slideimages/companies/" + paramMap.get("companyId");
			type = "post";
		} else {
			url = "/rest/admin/ezportal/slideimages/" + paramMap.get("slideId") + "/companies/" + paramMap.get("companyId");
			type = "put";
		}
		
		commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, param, request, type, null);

		logger.debug("saveSlideImages ended.");
		
		return "json";
	}
	
	/**
	 * 관리자 슬라이드포틀릿 이미지 설정 수정버튼 클릭시 슬라이드이미지 정보
	 * @param loginCookie
	 * @param paramMap
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/admin/ezNewPortal/getSlideImageInfo.do", method=RequestMethod.POST)
	public String getSlideImageInfo(@CookieValue("loginCookie") String loginCookie, @RequestBody Map<String, Object> paramMap, HttpServletRequest request, Model model) throws Exception {
		logger.debug("getSlideImageInfo started.");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		
		String url = "/rest/admin/ezportal/slideimages/" + paramMap.get("slideId") + "/companies/" + paramMap.get("companyId");
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, param, request, "get", null);
		
		String status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {
			model.addAttribute("slideInfo", resultBody.get("data"));
		}
		
		logger.debug("getSlideImageInfo ended.");
		
		return "json";
	}
	
	/**
	 * 관리자 슬라이드포틀릿 이미지 설정 삭제버튼
	 * @param loginCookie
	 * @param paramMap
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/admin/ezNewPortal/delSlideImage.do", method=RequestMethod.POST)
	@ResponseBody
	public void deleteSlideImage(@CookieValue("loginCookie") String loginCookie, @RequestBody Map<String, Object> paramMap, HttpServletRequest request, Model model) throws Exception {
		logger.debug("deleteSlideImage started.");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		
		String url = "/rest/admin/ezportal/slideimages/" + paramMap.get("slideId") + "/companies/" + paramMap.get("companyId");
		
		commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, param, request, "delete", null);
		
		logger.debug("deleteSlideImage ended.");
	}
	
	/**
	 * 관리자 슬라이드포틀릿 순서조정
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/admin/ezNewPortal/updateSlideOrder.do", method=RequestMethod.POST)
	@ResponseBody
	public void updateSlideOrder(@CookieValue("loginCookie") String loginCookie, @RequestBody Map<String, Object> paramMap, HttpServletRequest request, Model model) throws Exception {
		logger.debug("updateSlideOrder started.");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		
		JSONObject jsonParam = new JSONObject();
		jsonParam.put("slideList", paramMap.get("slideList"));
		
		String url = "/rest/admin/ezPortal/slideimages/order/companies/" + paramMap.get("companyId");
		
		commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, param, request, "patch", jsonParam);
		
		logger.debug("updateSlideOrder ended.");
	}
	
	/**
	 * 권한 불러올때, 직위직책 리스트, 권한그룹 리스트 불러오기 함수 추가
	 */
	
	//직위, 직책 리스트 불러오기
	@RequestMapping(value = "/admin/ezNewPortal/getTitleList.do", method=RequestMethod.POST)
	@ResponseBody
	public JSONArray getTitleList(@CookieValue("loginCookie") String loginCookie, @RequestBody Map<String, Object> paramMap,
			HttpServletRequest req, Model model) throws Exception {
		logger.debug("getTitleList started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String companyId = paramMap.get("companyId").toString();
		
		String url = "/rest/admin/ezPortal/menus/authorities/titles/companies/" + companyId;
		
		paramMap.put("userId", userInfo.getId());
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, paramMap, req, "get", null);
		String result = resultBody.get("status").toString();
		JSONArray json = new JSONArray();
		
		if (result.equals("ok")) {
			json = (JSONArray) resultBody.get("data");
		}
		logger.debug("json : " + json);
		logger.debug("getTitleList Ended");
		return json;
	}
	
	//권한그룹 리스트 불러오기
	@RequestMapping(value = "/admin/ezNewPortal/getGroupList.do", method=RequestMethod.POST)
	@ResponseBody
	public JSONArray getGroupList(@CookieValue("loginCookie") String loginCookie, @RequestBody Map<String, Object> paramMap,
			HttpServletRequest req, Model model) throws Exception {
		logger.debug("getGroupList started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String companyId = paramMap.get("companyId").toString();
		
		String url = "/rest/admin/ezPortal/menus/authorities/groups/companies/" + companyId;
		
		paramMap.put("userId", userInfo.getId());
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, paramMap, req, "get", null);
		String result = resultBody.get("status").toString();
		JSONArray json = new JSONArray();
		
		if (result.equals("ok")) {
			json = (JSONArray) resultBody.get("data");
		}
		logger.debug("json : " + json);
		logger.debug("getGroupList Ended");
		return json;
	}

	/**
	 * 사원리스트
	 */
	@RequestMapping(value = "/admin/ezNewPortal/userList.do", method = RequestMethod.POST)
	public String userList(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie){
		logger.debug("userList started");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		HashMap<String, Object> param = new HashMap<String, Object>();
		String key = request.getParameter("key");
		param.put("key", key);
		param.put("value", request.getParameter("value"));
		param.put("userId", userInfo.getId());
		param.put("companyId", request.getParameter("companyId"));
		param.put("curPage", request.getParameter("curPage"));

		logger.debug("key : " + request.getParameter("key"));
		logger.debug("value : " + request.getParameter("value"));

		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/admin/ezPortal/users", param, request, "get", null);
		String status = resultBody.get("status").toString();
		if (status.equals("ok")) {
			JSONArray userList = (JSONArray) resultBody.get("data");
			model.addAttribute("listType", request.getParameter("listType"));
			model.addAttribute("userList", userList);

			String keyword = "";
			if (key.equals("DEPARTMENT")) {
//				keyword = (String) ((JSONObject)userList.get(0)).get("deptName");
				keyword = request.getParameter("deptName");
			} else{
				keyword = egovMessageSource.getMessage("ezJournal.t170", userInfo.getLocale());
			}

			model.addAttribute("keyword",keyword);
			model.addAttribute("key", key);
			model.addAttribute("totalCount", resultBody.get("totalCount"));
			model.addAttribute("totalCount2", resultBody.get("totalCount2"));
			model.addAttribute("containLow", resultBody.get("containLow"));
		}

		logger.debug("userList ended");
		return "admin/ezNewPortal/userList";
	}

	@RequestMapping(value = "/admin/ezNewPortal/getAvailablePortletSize.do", produces = MediaType.APPLICATION_JSON_UTF8_VALUE, method=RequestMethod.POST)
	@ResponseBody
	public Map<Integer, List<String>> getAvailablePortletSize(@CookieValue("loginCookie") String loginCookie, @RequestBody Map<String, Object> paramMap) throws IOException {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		int themeId = Integer.parseInt(paramMap.get("themeId").toString());
		String companyId = paramMap.get("companyId").toString();

		return ezNewPortalService.getAvailablePortletSize(themeId, companyId, userInfo.getTenantId());
	}

	// 2023-11-24 황인경 - 관리자 > 포탈 > 포틀릿관리 > 일반게시판 포틀릿 > 카드형일 때 단어지정 팝업창
	@RequestMapping(value = "/admin/ezNewPortal/cardViewPortletWordSetting.do", method=RequestMethod.GET)
	public String cardViewPortletWordSetting(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("cardViewPortletWordSetting started.");

		String companyId = request.getParameter("companyId");
		String portletId = request.getParameter("portletId");
		String fileName = Optional.ofNullable(request.getParameter("fileName")).orElse("");
		model.addAttribute("companyId", companyId);
		model.addAttribute("portletId", portletId);
		model.addAttribute("fileName", fileName);

		logger.debug("cardViewPortletWordSetting ended.");
		return "/admin/ezNewPortal/portalWordSetting";
	}
	
	// [GET] 2024-05-17 한태훈 - 포탈 > 포탈 탑메뉴 위치 회사 설정값 불러오기
	@ResponseBody
	@RequestMapping(value = "/admin/ezNewPortal/getTopMenuDisplayModeForCompany.do", method=RequestMethod.GET)
	public JSONObject getTopMenuDisplayModeForCompany(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("getTopMenuDisplayModeForCompany started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		Map<String, Object> param = new HashMap<String, Object>();
		
		param.put("userId", userInfo.getId());
		param.put("companyId", request.getParameter("companyId"));
		
		JSONObject result = commonUtil.getJsonFromRestApi("/rest/admin/ezNewPortal/company/topMenuMode", param, request, "get", null);
		
		logger.debug("getTopMenuDisplayModeForCompany ended.");
		return result;
	}
	
	// [POST] 2024-05-17 한태훈 - 포탈 > 포탈 탑메뉴 위치 회사 설정값 수정
	@RequestMapping(value = "/admin/ezNewPortal/updateTopMenuDisplayModeForCompany.do", method=RequestMethod.POST)
	@ResponseBody
	public String updateTopMenuDisplayModeForCompany(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("updateTopMenuDisplayModeForCompany started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		Map<String, Object> param = new HashMap<String, Object>();
		
		param.put("userId", userInfo.getId());
		param.put("companyId", request.getParameter("companyId"));
		param.put("type", request.getParameter("type"));
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/admin/ezNewPortal/company/topMenuMode", param, request, "post", null);
		String result = resultBody.get("status").toString();
		logger.debug("updateTopMenuDisplayModeForCompany ended.");
		return result;
	}
	
	/**
	 * Config 트리 오픈
	 * @param loginCookie
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/admin/ezNewPortal/openConfigTree.do", method=RequestMethod.GET)
	public String openConfigTree(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("openBoardTree started.");

		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			logger.debug("openConfigTree accessDenied.");
			
			return "cmm/error/adminDenied";
		} else {
			logger.debug("openConfigTree ended.");
			String companyId = request.getParameter("companyId");
			String typeCode = request.getParameter("typeCode");
			
			Map<String, Object> param = new HashMap<String, Object>();
			param.put("userId", userInfo.getId());
			param.put("companyId", companyId);
			param.put("typeCode", typeCode);
			
			JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/admin/ezPortal/company/systemconfig", param, request, "get", null);
			String status = resultBody.get("status").toString();
			if (status.equals("ok")) {
				JSONArray configTypeList = (JSONArray) resultBody.get("data");
				model.addAttribute("configTypeList", configTypeList);
			}
			
			model.addAttribute("companyId", companyId);
			model.addAttribute("portletId", request.getParameter("portletId"));
			model.addAttribute("typeCode", typeCode);
			
			logger.debug("openConfigTree ended.");
			return "/admin/ezNewPortal/portalConfigTree";
		}
	}
}
