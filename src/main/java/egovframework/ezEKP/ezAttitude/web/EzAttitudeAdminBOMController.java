package egovframework.ezEKP.ezAttitude.web;

import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
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
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import com.google.gson.Gson;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezAttitude.vo.AttitudeConfigVO;
import egovframework.let.user.login.vo.LoginSimpleVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

@Controller
public class EzAttitudeAdminBOMController {
	private static final Logger LOGGER = LoggerFactory.getLogger(EzAttitudeController.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
	@Resource(name="crypto")
	private EgovFileScrty egovFileScrty;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	/**
	 * 관리자 근태규율관리 화면 호출 함수
	 * @throws Exception 
	 */
	@RequestMapping(value = "/admin/ezAttitude/attitudeConfig.do")
	public String attitudeConfig(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		LOGGER.debug("attitudeConfig started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		if (userInfo.getRollInfo().indexOf("c=1") == -1 && userInfo.getRollInfo().indexOf("k=1") == -1) {
			return "cmm/error/adminDenied";
		}
		
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		String url = gwServerUrl + "/rest/ezattitude/companies";
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("userId", userInfo.getId());
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp = new JSONParser();
		
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		
		String status = resultBody.get("status").toString();
		
		JSONArray list = new JSONArray();
		if(status.equals("ok")){
			list = (JSONArray) resultBody.get("data");
			
			model.addAttribute("list", list);
		}
		
		LOGGER.debug("attitudeConfig ended.");
		
		return "admin/ezAttitude/attitudeConfig";
	}
	/**
	 * 관리자 근태규율관리 회사별 설정 호출 함수
	 * @throws Exception 
	 */
	@RequestMapping(value = "/admin/ezAttitude/attitudeConfigInfo.do")
	@ResponseBody
	public JSONObject attitudeConfigInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LOGGER.debug("attitudeConfigInfo started.");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");		
		String url = gwServerUrl + "/rest/ezattitude/companies/" + request.getParameter("companyId") + "/attitudereg";
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("userId", userInfo.getId());
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp = new JSONParser();
		
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		
		String status = resultBody.get("status").toString();
		
		JSONObject dataObject = new JSONObject();
		
		if (status.equals("ok")) {
			dataObject = (JSONObject) resultBody.get("data");
		}
		
		LOGGER.debug("attitudeConfigInfo ended.");
		
		return dataObject;
	}
	/**
	 * 관리자 근태규율관리 회사별 설정 수정 함수
	 * @throws Exception
	 */
	@RequestMapping(value = "/admin/ezAttitude/updateAttitudeConfInfo.do")
	@ResponseBody
	public void updateAttitudeConfInfo(AttitudeConfigVO attitudeConfigVO, @CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LOGGER.debug("updateAttitudeConfInfo started.");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);

		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");		
		String url = gwServerUrl + "/rest/ezattitude/companies/" + request.getParameter("companyId") + "/attitudereg";
									
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		Gson gson = new Gson();
		JSONObject jsonParam = gson.fromJson(gson.toJson(attitudeConfigVO), JSONObject.class);
		
		HttpEntity<?> entity = new HttpEntity<>(jsonParam, headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("userId", userInfo.getId());
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<JSONObject> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.PUT, entity, JSONObject.class);
		
		JSONObject resultBody = result.getBody();
		
		String status = resultBody.get("status").toString();
		
		LOGGER.debug("updateAttitudeConfInfo ended.");
	}
	
	/**
	 * 관리자 유형관리  화면 호출 함수
	 * @throws Exception 
	 */
	@RequestMapping(value = "/admin/ezAttitude/attitudeTypeConfig.do")
	public String attitudeTypeConfig(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		LOGGER.debug("attitudeTypeConfig started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		if (userInfo.getRollInfo().indexOf("c=1") == -1 && userInfo.getRollInfo().indexOf("k=1") == -1) {
			return "cmm/error/adminDenied";
		}
		
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		String url = gwServerUrl + "/rest/ezattitude/companies";
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("userId", userInfo.getId());
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp = new JSONParser();
		
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		
		String status = resultBody.get("status").toString();
		
		JSONArray list = new JSONArray();
		if(status.equals("ok")){
			list = (JSONArray) resultBody.get("data");
			
			LOGGER.debug("list : " + list);
			
			model.addAttribute("list", list);
		}
		
		LOGGER.debug("attitudeTypeConfig ended.");
		
		return "admin/ezAttitude/attitudeTypeConfig";
	}
	
	/**
	 * 관리자 유형관리 설정 정보 호출 함수
	 * @throws Exception 
	 */
	@RequestMapping(value = "/admin/ezAttitude/attitudeTypeConfigInfo.do")
	@ResponseBody
	public JSONArray attitudeTypeConfigInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LOGGER.debug("attitudeTypeConfigInfo started.");
		//TODO===============================================================================================================================================
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		String url = gwServerUrl + "/rest/ezattitude/companies/" + request.getParameter("companyId") + "/attitudetypes";
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("userId", userInfo.getId());
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp = new JSONParser();
		
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
				
		String status = resultBody.get("status").toString();
		
		JSONArray dataList = new JSONArray();
		if (status.equals("ok")) {		
			dataList = (JSONArray) resultBody.get("data");
		}
		
		LOGGER.debug("attitudeTypeConfigInfo ended.");
		
		return dataList;
	}
	
}
