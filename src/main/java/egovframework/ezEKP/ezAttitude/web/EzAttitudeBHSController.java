package egovframework.ezEKP.ezAttitude.web;

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
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

@Controller
public class EzAttitudeBHSController {
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
	 * 사용자 근태리스트 출력
	 */
	@RequestMapping(value = "/attitude/getAttitudeList.do", produces = "application/json;charset=utf-8")
	@ResponseBody
	public JSONArray getAttitudeList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LOGGER.debug("/attitude/getAttitudeList started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String userId = userInfo.getId();
		
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		String url = gwServerUrl + "/rest/ezattitude/attitudes";
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("userId", userId);
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp = new JSONParser();
		
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		
		String status = resultBody.get("status").toString();
		LOGGER.debug("status : " + status);
		
		JSONArray list = new JSONArray();
		if (status.equals("ok")) {
			list = (JSONArray) resultBody.get("data");
		}
		
		LOGGER.debug("/attitude/getAttitudeList ended");
		return list;
	}
	
	/**
	 * 사용자 근태 추가 
	 */
	@RequestMapping(value = "/attitude/attitudeSave.do")
	@ResponseBody
	public void attitudeSave(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LOGGER.debug("/attitude/attitudeSave started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String typeId = request.getParameter("typeId");
		String dateType = request.getParameter("dateType");
		String userId = userInfo.getId();
		
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		String url = gwServerUrl + "/rest/ezattitude/users/" + userId + "/attitudes";
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("typeId", typeId)
				.queryParam("dateType", dateType);
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.POST, entity, String.class);
		
		JSONParser jp = new JSONParser();
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		
		String status = resultBody.get("status").toString();
		LOGGER.debug("status : " + status);
		
		if (status.equals("ok")) {
			
		}
		
		LOGGER.debug("/attitude/attitudeSave ended");
	}
	
	/**
	 * attitude Main
	 */
	@RequestMapping(value = "/ezAttitude/attitudeMain.do")
	public String attitudeMain(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LOGGER.debug("/ezAttitude/attitudeMain started");
		LOGGER.debug("/ezAttitude/attitudeMain ended");
		return "/ezAttitude/attitudeMain";
	}
	
	/**
	 * attitude Main Left
	 */
	@RequestMapping(value = "/ezAttitude/attitudeLeft.do")
	public String attitudeLeft(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		LOGGER.debug("/ezAttitude/attitudeLeft started");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String userOffset = userInfo.getOffset().split("\\|")[1];
		boolean attitudeAdminCheck = true;
		
		if (userInfo.getRollInfo().indexOf("d=1") == -1) {
			attitudeAdminCheck = false;
		}
		
		model.addAttribute("userOffset", userOffset);
		model.addAttribute("attitudeAdminCheck", attitudeAdminCheck);
		
		LOGGER.debug("/ezAttitude/attitudeLeft ended");
		return "/ezAttitude/attitudeLeft";
	}
	
	/**
	 * 개인근태현황 main
	 */
	@RequestMapping(value = "/ezAttitude/attitudeUserMain.do")
	public String attitudeUserMain(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userOffset = userInfo.getOffset().split("\\|")[1];
		
		model.addAttribute("userOffset", userOffset);
		return "/ezAttitude/attitudeUserMain";
	}
}
