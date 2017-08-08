package egovframework.ezMobile.ezOption.web;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;




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

import com.google.gson.Gson;

import egovframework.ezMobile.ezOption.service.MOptionService;
import egovframework.ezMobile.ezOption.vo.MOptionVO;
import egovframework.ezMobile.ezPortal.web.MPortalController;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

@Controller
public class MOptionController {

private static final Logger logger = LoggerFactory.getLogger(MOptionController.class);
	
	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;
	
	@Resource(name="loginService")
	private LoginService loginService;

	@Resource(name="crypto") 
	private EgovFileScrty egovFileScrty;
	
	@Resource(name = "MOptionService")
	private MOptionService mOptionService;
	
	/**
	 * 모바일 환경설정 페이지 호출 함수
	 */
	@RequestMapping(value = "/mobile/ezOption/ezOptionMain.do")
	public String ezOptionMain(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale) throws Exception {
		logger.debug("optionMain Start");
		logger.debug("optionMain End");
		return "/mobile/ezOption/mOptionMain";
	}
	
	/**
	 * 모바일 환경설정 페이지 호출 함수
	 */
	@RequestMapping(value = "/mobile/ezOption/saveOption.do")
	public String saveOption(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletResponse resp, Locale locale) throws Exception {
		logger.debug("saveOption Start");
		userInfo = commonUtil.userInfo(loginCookie);
		
		String langFlag = req.getParameter("lang");
		String dpBoardCnt = req.getParameter("dpBoardCnt");
		String resourceChk = req.getParameter("resourceChk");
		String resourceYN = req.getParameter("resourceYN");
		
		if (langFlag == null) {
			langFlag = userInfo.getPrimary();
		}
		
		System.out.println(langFlag);
		System.out.println(dpBoardCnt);
		System.out.println(resourceChk);
		System.out.println(resourceYN);
		
		String result = mOptionService.saveOption(userInfo.getId(), langFlag, dpBoardCnt, resourceChk, resourceYN, userInfo.getTenantId());
		logger.debug("saveOption End");
		return "true";
	}
	
	/**
	 * 모바일 환경설정 조회
	 */
	@RequestMapping(value = "/mobile/ezOption/searchOption.do")
	public String searchOption(HttpServletRequest request, Model model,@CookieValue("loginCookie") String loginCookie, MOptionVO optionVO,LoginVO userInfo, HttpServletResponse response) throws Exception {
		logger.debug("searchOption started.");
		Gson gson = new Gson();
		userInfo = commonUtil.userInfo(loginCookie);
		String serverName = request.getServerName();		
		String gwServerUrl = config.getProperty("config.mobileGwServerURL");
		String userId = "";

		
		if(userInfo != null){		
			userId = userInfo.getId();
		}

		//로컬테스트용
		gwServerUrl = "http://localhost:8080";
		String url = gwServerUrl + "/mobile/ezoption/option/users/" + userId;
		logger.debug("userId: " + userId);
		logger.debug(url);
		RestTemplate rest = new RestTemplate();	
		ResponseEntity<JSONObject> result = null;
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url);		
		HttpHeaders headers = new HttpHeaders();
		HttpEntity<Object> entity = null;		
			headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
			headers.set("x-user-host", serverName);
	     entity = new HttpEntity<Object>(headers);	

		result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, JSONObject.class);

		logger.debug("result: " + result);
		
		JSONObject resultBody = result.getBody();
				
		String status = resultBody.get("status").toString();
		//Map<String, Object> scheduleDetail = (Map<String, Object>) resultBody.get("data");
        JSONObject Detail = gson.fromJson((String)resultBody.get("data"), JSONObject.class);
        //logger.debug("scheduleDetail" + scheduleDetail);
			//jsonobject ???
		model.addAttribute("Detail", Detail);
		logger.debug("searchOption ended.");
		
		return "json";
	}
	
	/**
	 * 모바일 환경설정 수정사항 저장
	 */
	@RequestMapping(value = "/mobile/ezOption/updateOption.do")
	public String updteOption(HttpServletRequest request, Model model,@CookieValue("loginCookie") String loginCookie, MOptionVO optionVO,LoginVO userInfo, HttpServletResponse response, Locale locale) throws Exception {
		logger.debug("updateOption started.");
		
		userInfo = commonUtil.userInfo(loginCookie);
		String serverName = request.getServerName();
		
		logger.debug("serverName: " + serverName);
		
		String timeZone = optionVO.getTimeZone();
		String lang = optionVO.getLang();
		String mainType = optionVO.getMainType();
		String listCnt = optionVO.getListCnt();
		String useSearch = optionVO.getUseSearch();
		String useSecurity = optionVO.getUseSecurity();
		String userId = "";
		
		timeZone = "235|+09:00";
		lang = "1";
		mainType = "P";
		listCnt = "10";
		useSearch = "Y";
		useSecurity = "N";
		userId = "naman79";
		
		if(userInfo != null){
			userId = userInfo.getId();			
		}
		
		String gwServerUrl = config.getProperty("config.mobileGwServerURL");
		logger.debug("gwServerUrl: " + gwServerUrl);
		//로컬테스트용
		gwServerUrl = "http://localhost:8080";
		String url = gwServerUrl + "/mobile/ezoption/option/users/" + userId;
		
		optionVO.setTimeZone(timeZone);
		optionVO.setLang(lang);
		optionVO.setListCnt(listCnt);
		optionVO.setMainType(mainType);
		optionVO.setUseSearch(useSearch);
		optionVO.setUseSecurity(useSecurity);
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<JSONObject> result = null;
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url);
		
		HttpHeaders headers = new HttpHeaders();
		HttpEntity<Object> entity = null;		
		Gson gson = new Gson();
		

		
		String jsonString = gson.toJson(optionVO);
		 JSONObject jsonObject = gson.fromJson(jsonString, JSONObject.class);
			headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
			headers.set("x-user-host", serverName);
	     entity = new HttpEntity<Object>(jsonObject, headers);	
		
		result = rest.exchange(builder.build().encode().toUri(), HttpMethod.PUT, entity, JSONObject.class);

		logger.debug("result: " + result);
		
		JSONObject resultBody = result.getBody();
				
		String status = resultBody.get("status").toString();

		model.addAttribute("result", result);
		
		logger.debug("updateOption ended.");
		
		return "json";
	}
	
	
}
