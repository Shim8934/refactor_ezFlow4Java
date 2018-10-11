package egovframework.ezEKP.ezNewPortal.web;

import java.util.HashMap;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

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
	public String portalMenus(@CookieValue("loginCookie") String loginCookie, HttpServletRequest requset) throws Exception {
		LOGGER.debug("portalMenus started.");
		
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			LOGGER.debug("portalMenus accessDenied.");
			
			return "cmm/error/adminDenied";
		} else {
			LOGGER.debug("portalMenus ended.");
			
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
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi(url, param, request, "get", null);
				
		String status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {
			String companyId = (String) resultBody.get("userCompany");
			JSONArray companyList = (JSONArray) resultBody.get("data");
			model.addAttribute("userCompany", companyId);
			model.addAttribute("list", companyList);
		}
		
		LOGGER.debug("getCompanys ended.");
		
		return "json";
	}
	
	/** ----------------------------------------------- */
	
	
	/**
	 * @author 구해안
	 */
	
	
	/** ----------------------------------------------- */
}
