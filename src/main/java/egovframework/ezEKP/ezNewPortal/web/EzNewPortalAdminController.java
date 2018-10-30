package egovframework.ezEKP.ezNewPortal.web;

import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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

import egovframework.com.cmm.EgovMessageSource;
import egovframework.let.user.login.vo.LoginSimpleVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Controller
public class EzNewPortalAdminController {

	private static final Logger LOGGER = LoggerFactory.getLogger(EzNewPortalAdminController.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
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
	
	@RequestMapping(value = "/admin/ezNewPortal/portalLogos.do")
	public String portalManageLogo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		LOGGER.debug("portalManageLogo started.");
		
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		return "/admin/ezNewPortal/portalLogos";
	}
	
	/**
	 * 관리자 포탈 포틀릿목록 조회
	 */
	@RequestMapping(value = "/admin/ezNewPortal/getPortlets.do")
	@ResponseBody
	public JSONArray getPortalPortlets(@CookieValue("loginCookie") String loginCookie, HttpServletRequest req, Model model) throws Exception {
		LOGGER.debug("getPortalPortlets started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String companyId = req.getParameter("companyId");
		String url = "/rest/admin/ezPortal/portlets/companies/"+companyId;
		
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());		
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, param, req, "get", null);
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
	 * 관리자 포탈 포틀릿목록 조회
	 */
	@RequestMapping(value = "/admin/ezNewPortal/updatePortlets.do")
	@ResponseBody
	public JSONArray updatePortalPortlets(@CookieValue("loginCookie") String loginCookie, HttpServletRequest req, Model model) throws Exception {
		LOGGER.debug("getPortalPortlets started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String portletId = req.getParameter("portletId");
		String companyId = req.getParameter("companyId");
		String url = "/rest/admin/ezPortal/portlets/"+portletId+"/companies/"+companyId;
		
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userInfo.getId());		
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, param, req, "PATCH", null);
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
}
