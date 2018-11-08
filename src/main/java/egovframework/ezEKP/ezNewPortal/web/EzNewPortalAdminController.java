package egovframework.ezEKP.ezNewPortal.web;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.UUID;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.hsqldb.result.Result;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezPersonal.service.EzPersonalService;
import egovframework.let.user.login.vo.LoginSimpleVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Controller
public class EzNewPortalAdminController extends EgovFileMngUtil {

	private static final Logger LOGGER = LoggerFactory.getLogger(EzNewPortalAdminController.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Autowired
	private EzCommonService ezCommonService;
	
	/**
	 * @author 이효진
	 */
	
	/**
	 * 관리자 포탈 메인화면 조회
	 */
	@RequestMapping(value = "/admin/ezNewPortal/portalMain.do")
	public String portalMain(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LOGGER.debug("portalMain started.");

		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			LOGGER.debug("portalMain accessDenied.");
			
			return "cmm/error/adminDenied";
		} else {
			LOGGER.debug("portalMain ended.");
			
			return "/admin/ezNewPortal/portalMain";
		}
	}
	
	/**
	 * 관리자 포탈 Left 화면조회
	 */
	@RequestMapping(value = "/admin/ezNewPortal/portalLeftMenu.do")
	public String portalTopMenu(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LOGGER.debug("portalLeftMenu started.");

		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			LOGGER.debug("portalLeftMenu accessDenied.");
			
			return "cmm/error/adminDenied";
		} else {
			LOGGER.debug("portalLeftMenu ended.");
			
			return "/admin/ezNewPortal/portalLeftMenu";
		}
	}
	
	/**
	 * 관리자 포탈 right 화면조회
	 */
	
	/**
	 * 관리자 포탈 테마관리 화면조회
	 */
	@RequestMapping(value = "/admin/ezNewPortal/portalThemes.do")
	public String portalThemes(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LOGGER.debug("portalThemes started.");

		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			LOGGER.debug("portalThemes accessDenied.");
			
			return "cmm/error/adminDenied";
		} else {
			LOGGER.debug("portalThemes ended.");
			
			return "/admin/ezNewPortal/portalThemes";
		}
	}
	
	/**
	 * 관리자 포탈 메뉴관리 화면조회
	 */
	@RequestMapping(value = "/admin/ezNewPortal/portalMenus.do")
	public String portalMenus(@CookieValue("loginCookie") String loginCookie, HttpServletRequest requset, HttpServletResponse response) throws Exception {
		LOGGER.debug("portalMenus started.");
		
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			LOGGER.debug("portalMenus accessDenied.");
			
			return "cmm/error/adminDenied";
		} else {
			LOGGER.debug("portalMenus ended.");

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
	//TODO 2018-11-06 need시간
	@RequestMapping(value = "/admin/ezNewPortal/portalMenuAuth.do")
	public String portalMenuAuth(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		LOGGER.debug("portalMenuAuth started.");
		
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			LOGGER.debug("portalMenuAuth accessDenied.");
			
			return "cmm/error/adminDenied";
		}
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		
		JSONObject result = commonUtil.getJsonFromRestApi("/rest/ezjournal/depts", param, request, "get", null);
		String status = result.get("status").toString();
		
		if (status.equals("ok")) {
			JSONArray deptList = (JSONArray) result.get("data");
			
			for (int i = 0; i < deptList.size(); i++) {
				JSONObject dept = (JSONObject) deptList.get(i);
				
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
			}
			
			model.addAttribute("deptList", deptList);
			model.addAttribute("userId", userInfo.getId());
		}
		
		model.addAttribute("menuId", request.getParameter("menuId"));
		model.addAttribute("companyId", request.getParameter("companyId"));
		
		LOGGER.debug("portalMenuAuth ended");
		
		return "/admin/ezNewPortal/portalMenuAuth";
	}
	
	
	/** **************************** */
	
	/**
	 * 관리자 포탈 회사목록 조회
	 */
	@RequestMapping(value = "/admin/ezNewPortal/getCompanies.do")
	public String getCompanys(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		LOGGER.debug("getCompanys started.");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		
		String url = "/rest/admin/ezportal/companies";
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, param, request, "get", null);
				
		String status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {
			model.addAttribute("userCompany", resultBody.get("userCompany"));
			model.addAttribute("list", resultBody.get("data"));
		}
		
		LOGGER.debug("getCompanys ended.");
		
		return "json";
	}
	
	/**
	 * 관리자 포탈 테마목록 조회
	 */
	@RequestMapping(value = "/admin/ezNewPortal/getThemes.do")
	public String getPortalThemes(@CookieValue("loginCookie") String loginCookie, @RequestBody Map<String, Object> paramMap, HttpServletRequest request, Model model) throws Exception {
		LOGGER.debug("getPortalThemes started.");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		
		String url = "/rest/admin/ezportal/themes/companies/" + paramMap.get("companyId");
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, param, request, "get", null);
				
		String status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {
			model.addAttribute("list", resultBody.get("data"));
		}
		
		LOGGER.debug("getPortalThemes ended.");
		
		return "json";
	}
	
	/**
	 * 관리자 포탈 테마상세정보 조회
	 */
	@RequestMapping(value = "/admin/ezNewPortal/getThemeInfo.do")
	public String getPortalThemeInfo(@CookieValue("loginCookie") String loginCookie, @RequestBody Map<String, Object> paramMap, HttpServletRequest request, Model model) throws Exception {
		LOGGER.debug("getPortalThemeInfo started.");
		
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
		
		LOGGER.debug("getPortalThemeInfo ended.");
		
		return "json";
	}
	
	/**
	 * 관리자 포탈 테마상세정보 수정
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/admin/ezNewPortal/updateThemeInfo.do")
	public void updateThemeInfo(@CookieValue("loginCookie") String loginCookie, @RequestBody Map<String, Object> paramMap, HttpServletRequest request, Model model) throws Exception {
		LOGGER.debug("updateThemeInfo started.");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		//param.put("themeInfo", paramMap.get("themeInfo"));
		//param.put("frameInfos", paramMap.get("frameInfos"));
		
		JSONObject jsonParam = new JSONObject();
		jsonParam.put("themeInfo", paramMap.get("themeInfo"));
		jsonParam.put("frameInfos", paramMap.get("frameInfos"));
		
		String url = "/rest/admin/ezPortal/themes/" + paramMap.get("themeId") + "/companies/" + paramMap.get("companyId");
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, param, request, "patch", jsonParam);
				
		String status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {
			
		}
		
		LOGGER.debug("updateThemeInfo ended.");
	}
	
	/**
	 * 관리자 포탈 테마상세정보 미리보기 -> 이건 스크립트로 하고
	 */
	
	/**
	 * 관리자 메뉴 목록 조회
	 */
	@RequestMapping(value = "/admin/ezNewPortal/getMenus.do")
	public String getMenus(@CookieValue("loginCookie") String loginCookie, @RequestBody Map<String, Object> paramMap, HttpServletRequest request, Model model) throws Exception {
		LOGGER.debug("getMenus started.");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		
		String url = "/rest/admin/ezPortal/menus/companies/" + paramMap.get("companyId");
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, param, request, "get", null);
		
		String status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {
			model.addAttribute("list", resultBody.get("data"));
		}
		
		LOGGER.debug("getMenus ended.");
		
		return "json";
	}
	
	/**
	 * 관리자 메뉴 상세정보 조회
	 */
	@RequestMapping(value = "/admin/ezNewPortal/getMenuInfo.do")
	public String getMenuInfo(@CookieValue("loginCookie") String loginCookie, @RequestBody Map<String, Object> paramMap, HttpServletRequest request, Model model) throws Exception {
		LOGGER.debug("getMenuInfo started.");
		
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
		
		LOGGER.debug("getMenuInfo ended.");
		
		return "json";
	}
	
	/**
	 * 관리자 메뉴권한목록 조회
	 */
	@RequestMapping(value = "/admin/ezNewPortal/getMenuAuths.do")
	public String getMenuAuths(@CookieValue("loginCookie") String loginCookie, @RequestBody Map<String, Object> paramMap, HttpServletRequest request, Model model) throws Exception {
		LOGGER.debug("getMenuAuths started.");
		
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
		
		LOGGER.debug("getMenuAuths ended.");
		
		return "json";
	}
	
	/**
	 * 관리자 메뉴 수정
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/admin/ezNewPortal/updateMenu.do")
	public void updateMenu(@CookieValue("loginCookie") String loginCookie, @RequestBody Map<String, Object> paramMap, HttpServletRequest request, Model model) throws Exception {
		LOGGER.debug("updateMenu started.");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		
		JSONObject jsonParam = new JSONObject();
		
		//메뉴정보수정
		jsonParam.put("menuInfo", paramMap.get("menuInfo"));
		jsonParam.put("menuNames", paramMap.get("menuNames"));
		
		String url = "/rest/admin/ezPortal/menus/" + paramMap.get("menuId") + "/companies/" + paramMap.get("companyId");
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, param, request, "patch", jsonParam);
		
		String status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {
			
		}
		
		//메뉴권한수정
		jsonParam = new JSONObject();
		jsonParam.put("menuAuths", param.get("menuAuths"));
		
		url = "/rest/admin/ezPortal/menus/" + paramMap.get("menuId") + "/authorities/companies/" + paramMap.get("companyId");
		
		resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, param, request, "patch", jsonParam);
		
		status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {
			
		}
		
		LOGGER.debug("updateMenu ended.");
	}
	
	/**
	 * 관리자 메뉴 추가
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/admin/ezNewPortal/insertMenu.do")
	public void insertMenu(@CookieValue("loginCookie") String loginCookie, @RequestBody Map<String, Object> paramMap, HttpServletRequest request, Model model) throws Exception {
		LOGGER.debug("insertMenu started.");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		
		JSONObject jsonParam = new JSONObject();
		
		//메뉴정보추가
		jsonParam.put("menuInfo", paramMap.get("menuInfo"));
		jsonParam.put("menuNames", paramMap.get("menuNames"));
		jsonParam.put("menuAuths", paramMap.get("menuAuths"));
		
		String url = "/rest/admin/ezPortal/menus/companies/" + paramMap.get("companyId");
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, param, request, "post", jsonParam);
		
		String status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {
			
		}
		
		LOGGER.debug("insertMenu ended.");
	}
	
	/**
	 * 관리자 메뉴 삭제
	 */
	@RequestMapping(value = "/admin/ezNewPortal/deleteMenu.do")
	public void deleteMenu(@CookieValue("loginCookie") String loginCookie, @RequestBody Map<String, Object> paramMap, HttpServletRequest request, Model model) throws Exception {
		LOGGER.debug("deleteMenu started.");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		
		String url = "/rest/admin/ezPortal/menus/" + paramMap.get("menuId") + "/companies/" + paramMap.get("companyId");
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, param, request, "delete", null);
		
		String status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {
			
		}

		LOGGER.debug("deleteMenu ended.");
	}
	
	/**
	 * 관리자 메뉴 순서조정
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/admin/ezNewPortal/updateMenuOrder.do")
	@ResponseBody
	public void updateMenuOrder(@CookieValue("loginCookie") String loginCookie, @RequestBody Map<String, Object> paramMap, HttpServletRequest request, Model model) throws Exception {
		LOGGER.debug("updateMenuOrder started.");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());
		
		JSONObject jsonParam = new JSONObject();
		jsonParam.put("menus", paramMap.get("menus"));
		
		String url = "/rest/admin/ezPortal/menus/order/companies/" + paramMap.get("companyId");
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, param, request, "patch", jsonParam);
		
		String status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {
			
		}
		
		LOGGER.debug("updateMenuOrder ended.");
	}
	
	/** ----------------------------------------------- */
	
	
	/**
	 * @author 구해안
	 */
	/**
	 * 관리자 포탈 메뉴관리 화면조회
	 */
	@RequestMapping(value = "/admin/ezNewPortal/portalPortlets.do")
	public String portalManagePortlets(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		LOGGER.debug("portalPortlets started.");
		
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			LOGGER.debug("portalPortlets accessDenied.");
			
			return "cmm/error/adminDenied";
		} else {
			
			HashMap<String, Object> param = new HashMap<String, Object>();
			param.put("userId", userInfo.getId());
			
			String url = "/rest/admin/ezportal/companies";
			
			JSONObject resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, param, request, "get", null);
					
			String status = resultBody.get("status").toString();
			
			if (status.equals("ok")) {
				model.addAttribute("companyList", resultBody.get("data"));
				model.addAttribute("userCompany", resultBody.get("userCompany"));
				model.addAttribute("lang", resultBody.get("lang"));
			}
			
			LOGGER.debug("portalPortlets ended.");
			return "/admin/ezNewPortal/portalPortlets";
		}
	}
	
	//관리자 로고관리 > 화면 출력
	@RequestMapping(value = "/admin/ezNewPortal/portalLogos.do")
	public String portalManageLogo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		LOGGER.debug("portalManageLogo started.");
		
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			LOGGER.debug("portalManageLogo accessDenied.");
			
			return "cmm/error/adminDenied";
		} else {
        	String isAdmin = userInfo.getRollInfo();
        	boolean adminCheck = false;
        	
        	if (isAdmin.indexOf("c=1") == -1) {
        		adminCheck = false; 
        	} else {
        		adminCheck = true;
        	}
        	
        	model.addAttribute("adminCheck", adminCheck);
			LOGGER.debug("portalManageLogo ended.");
			return "/admin/ezNewPortal/portalLogos";
		}
	}
	
	/**
	 * 관리자 포탈 포틀릿목록 조회
	 */
	@RequestMapping(value = "/admin/ezNewPortal/getPortlets.do")
	@ResponseBody
	public JSONArray getPortalPortlets(@CookieValue("loginCookie") String loginCookie, @RequestBody Map<String, Object> paramMap,
			HttpServletRequest req, Model model) throws Exception {
		LOGGER.debug("getPortalPortlets started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String companyId = paramMap.get("companyId").toString();
		String url = "/rest/admin/ezPortal/portlets/companies/" + companyId;
		
		paramMap.put("userId", userInfo.getId());		
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, paramMap, req, "get", null);
		String result = resultBody.get("status").toString();
		JSONArray json = new JSONArray();
		
		if (result.equals("ok")) {
			JSONObject data = (JSONObject) resultBody.get("data");
			json = (JSONArray) data.get("PortletList");
		}
		LOGGER.debug("json : " + json);
		LOGGER.debug("getPortalPortlets Ended");
		return json;
	}
	
	/**
	 * 관리자 포탈 포틀릿 업데이트
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/admin/ezNewPortal/updatePortlet.do")
	@ResponseBody
	public void updatePortlet(@CookieValue("loginCookie") String loginCookie, HttpServletRequest req, @RequestBody JSONObject json, Model model) throws Exception {
		LOGGER.debug("updatePortlet started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String portletId = json.get("portletId").toString();
		String companyId = json.get("companyId").toString();
		String url = "/rest/admin/ezPortal/portlets/" + portletId + "/companies/" + companyId;
		
		json.put("userId", userInfo.getId());
		
		commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, null, req, "patch", json);
		LOGGER.debug("updatePortlet Ended");
	}
	
	/** ----------------------------------------------- */
	
	/**
	 * @author 유은정
	 */
	
	//메뉴 아이콘 선택 화면 호출
	@RequestMapping(value = "/admin/ezNewPortal/selectMenuIcon.do")
	public String portalMenuIconSelect(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LOGGER.debug("portalMenuIconSelect started.");

		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			LOGGER.debug("portalMenuIconSelect accessDenied.");
			
			return "cmm/error/adminDenied";
		} else {
			LOGGER.debug("portalMenuIconSelect ended.");
			
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
	@RequestMapping(value = "/admin/ezNewPortal/openBoardTree.do")
	public String openBoardTree(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		LOGGER.debug("openBoardTree started.");

		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			LOGGER.debug("openBoardTree accessDenied.");
			
			return "cmm/error/adminDenied";
		} else {
			LOGGER.debug("openBoardTree ended.");
			//게시판이 top인 목록 가져오기
			String userId = userInfo.getId();
			String companyId = request.getParameter("companyId");
			
			Map<String, Object> param = new HashMap<String, Object>();
			param.put("parentBoardId", "top");
			param.put("userId", userId);
			
			String url = "/rest/admin/ezPortal/boards/tree/companies/" + companyId;
			
			JSONObject resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, param, request, "get", null);
			String result = resultBody.get("status").toString();
			
			if (result.equals("ok")) {
				model.addAttribute("boardList", resultBody.get("data"));
				model.addAttribute("companyId", companyId);
				model.addAttribute("portletId", request.getParameter("portletId"));
			}
			
			LOGGER.debug("openBoardTree ended.");
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
	@RequestMapping(value = "/admin/ezNewPortal/getSubBoards.do")
	@ResponseBody
	public JSONArray getSubBoards(@CookieValue("loginCookie") String loginCookie, HttpServletRequest req, @RequestBody Map<String, Object> paramMap, Model model) throws Exception {
		LOGGER.debug("getSubBoards started.");
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
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
		
		LOGGER.debug("getSubBoards ended.");
		return subBoards;
	}
	
	/**
	 * 관리자 포탈 포틀릿 추가
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/admin/ezNewPortal/addPortlet.do")
	@ResponseBody
	public void addPortlets(@CookieValue("loginCookie") String loginCookie, HttpServletRequest req, @RequestBody JSONObject json, Model model) throws Exception {
		LOGGER.debug("addPortlets started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String companyId = json.get("companyId").toString();
		String url = "/rest/admin/ezPortal/portlets/companies/" + companyId;
		
		json.put("userId", userInfo.getId());
		
		commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, null, req, "post", json);
		
		LOGGER.debug("addPortlets Ended");
	}
	
	/**
	 * 관리자 포탈 포틀릿 삭제
	 */
	@RequestMapping(value = "/admin/ezNewPortal/deletePortlet.do")
	@ResponseBody
	public void deletePortlets(@CookieValue("loginCookie") String loginCookie, @RequestBody Map<String, Object> paramMap, HttpServletRequest req, Model model) throws Exception {
		LOGGER.debug("addPortlets started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String portletId = paramMap.get("portletId").toString();
		String companyId = paramMap.get("companyId").toString();
		String url = "/rest/admin/ezPortal/portlets/" + portletId + "/companies/" + companyId;
		System.out.println(portletId);
		System.out.println(companyId);
		
		paramMap.put("userId", userInfo.getId());		
		
		commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, paramMap, req, "delete", null);
		LOGGER.debug("addPortlets Ended");
	}
	
	/**
	 * 관리자 포탈 포틀릿 순서 업데이트
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/admin/ezNewPortal/updatePortletOrder.do")
	@ResponseBody
	public void updatePortletOrder(@CookieValue("loginCookie") String loginCookie, @RequestBody JSONObject json, HttpServletRequest req, Model model) throws Exception {
		LOGGER.debug("updatePortletOrder started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String companyId = json.get("companyId").toString();
		String url = "/rest/admin/ezPortal/portlets/order/companies/" + companyId;
		System.out.println(companyId);
		System.out.println(json.get("portlets"));
		json.put("userId", userInfo.getId());		
		
		commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, null, req, "patch", json);
		LOGGER.debug("updatePortletOrder Ended");
	}
	
	/**
	 * 메뉴 목록 가져오기
	 * @param loginCookie
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/admin/ezNewPortal/openPortalMenu.do")
	public String openPortalMenu(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		LOGGER.debug("openPortalMenu started.");

		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			LOGGER.debug("openBoardTree accessDenied.");
			
			return "cmm/error/adminDenied";
		} else {
			LOGGER.debug("openBoardTree ended.");
			//게시판이 top인 목록 가져오기
			String userId = userInfo.getId();
			String companyId = request.getParameter("companyId");
			
			Map<String, Object> param = new HashMap<String, Object>();
			param.put("userId", userId);
			
			String url = "/rest/admin/ezPortal/menus/companies/" + companyId;
			
			JSONObject resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, param, request, "get", null);
			String result = resultBody.get("status").toString();
			
			if (result.equals("ok")) {
				model.addAttribute("menuList", resultBody.get("data"));
				model.addAttribute("companyId", companyId);
				model.addAttribute("portletId", request.getParameter("portletId"));
			}
			
			LOGGER.debug("openPortalMenu ended.");
			return "/admin/ezNewPortal/portalPortletMenu";
		}
	}
	
	//관리자 로고리스트 불러오기
	@RequestMapping(value = "/admin/ezNewPortal/getCompanyLogos.do")
	@ResponseBody
	public JSONArray getCompanyLogos(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, @RequestBody Map<String, Object> paramMap, Model model) throws Exception {
		LOGGER.debug("getCompanyLogos started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String companyId = paramMap.get("companyId").toString();
		String url = "/rest/admin/ezPortal/logos/companies/" + companyId;
		paramMap.put("userId", userInfo.getId());
		
		JSONArray logoList = new JSONArray();
		JSONObject result = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, paramMap, request, "get", null);
		String status = result.get("status").toString();
		
		if (status.equals("ok")) {
			logoList = (JSONArray) result.get("data");
		}
		
		LOGGER.debug("getCompanyLogos Ended");
		
		return logoList;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/admin/ezNewPortal/uploadLogo.do", produces = "text/plain; charset=utf-8")
	@ResponseBody
	public String updateCompanyLogo(@CookieValue("loginCookie") String loginCookie, MultipartHttpServletRequest request, Model model) throws Exception {
		LOGGER.debug("updateCompanyLogo started");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String companyId = request.getParameter("companyId").toString();
		String url = "/rest/admin/ezPortal/logos/companies/" + companyId;
		String userId = userInfo.getId();
		String logoType = request.getParameter("logoType");
		JSONObject json = new JSONObject();
		json.put("userId", userId);
        json.put("logoType", logoType);
        String logoUrl = "";

        if (logoType.equals("L")) {
        	LoginVO adminCheck = commonUtil.checkAdmin(loginCookie);
        	String isAdmin = adminCheck.getRollInfo();
        	
        	if (isAdmin.indexOf("c=1") == -1) {
        		logoUrl = "rejected";
        		return logoUrl;
        	}
        	
        }
		MultipartFile multiFile = request.getFile("file");
		
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
        pDirPath = realPath + pDirPath;
        
        if (!pDirPath.substring(pDirPath.length() - 1).equals(commonUtil.separator)) {
        	pDirPath = pDirPath + commonUtil.separator;
        }
        
        File file = new File(pDirPath + "uploadFile");

        if (!file.exists()) {
        	file.mkdir();        
        }
        
        String extend = pFileName.substring(pFileName.lastIndexOf(".") + 1);
        String newFileName = pUploadSN + "." + extend;
        
        if (useExtension.toLowerCase().indexOf(extend.toLowerCase()) != -1 || useExtension.equals("*")) {           	
			writeUploadedFile(multiFile, newFileName, pDirPath + "uploadFile");
			
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
		
		LOGGER.debug("logoUrl : " + logoUrl);
		LOGGER.debug("updateCompanyLogo ended");
		
		return logoUrl;
	}
	
	/**
	 * 관리자 포탈 테마상세정보 미리보기 호출
	 */
	@RequestMapping(value = "/admin/ezNewPortal/themePreview.do")
	public String themePreview(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		LOGGER.debug("themePreview started.");

		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			LOGGER.debug("themePreview accessDenied.");
			
			return "cmm/error/adminDenied";
		} else {
			model.addAttribute("themeId", request.getParameter("themeId"));
			model.addAttribute("frameId", request.getParameter("frameId"));
			LOGGER.debug("themePreview ended.");
			return "/admin/ezNewPortal/themePreview";
		}
	}
	
	@RequestMapping(value = "/admin/ezNewPortal/updateCompanyDefaultTheme.do")
	@ResponseBody
	public void updateCompanyDefaultTheme(@CookieValue("loginCookie") String loginCookie, @RequestBody Map<String, Object> paramMap, HttpServletRequest request, Model model) throws Exception {
		LOGGER.debug("updateCompanyDefaultTheme started.");

		LoginVO user = commonUtil.checkAdmin(loginCookie);
		
		if (user == null) {
			LOGGER.debug("updateCompanyDefaultTheme accessDenied.");
			
		} else {
			LoginVO userInfo = commonUtil.userInfo(loginCookie);
			String userId = userInfo.getId();
			String themeId = paramMap.get("themeId").toString();
			String companyId = paramMap.get("companyId").toString();
			
			paramMap.put("userId", userId);
			
			String url = "/rest/admin/ezPortal/themes/" + themeId + "/default/companies/" + companyId;
			System.out.println(url);
			commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, paramMap, request, "patch", null);
			
			LOGGER.debug("updateCompanyDefaultTheme ended.");
		}
	}
}
