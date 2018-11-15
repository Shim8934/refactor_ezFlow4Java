package egovframework.ezMobile.ezSchedule.web;

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
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import com.google.gson.Gson;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezSchedule.vo.ScheduleInfoVO;
import egovframework.ezMobile.ezSchedule.service.MScheduleService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

/** 
 * @Description [Controller] 스케쥴
 * @author 오픈솔루션팀 지정석
 * @Modification Information
 *
 *    수정일        수정자         수정내용
 *    ----------    ------    -------------------
 *    2017.06.14    지정석    신규작성
 *
 * @see
 */

@Controller
public class MScheduleController extends EgovFileMngUtil {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(MScheduleController.class);
	
	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;
		
	@Resource(name="MScheduleService")
	private MScheduleService mScheduleService;
		
	/*@Resource(name="loginService")
	private LoginService loginService;*/

	/*@Resource(name="crypto") 
	private EgovFileScrty egovFileScrty;*/
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
		
	/**
	 * 모바일 client 일정관리 리스트
	 */
	@RequestMapping(value="/mobile/ezSchedule/mScheduleList.do")
	public String mScheduleList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, ModelMap modelMap) throws Exception {
		LOGGER.debug("mScheduleList started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String startDate = request.getParameter("startDate");
		String endDate = request.getParameter("endDate");

		String gwServerUrl = config.getProperty("config.mobileGwServerURL");
		String url = gwServerUrl + "/mobile/ezschedule/list/users/" + userInfo.getId();
				
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);

		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
		        .queryParam("startDate", startDate)
		        .queryParam("endDate", endDate);
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp = new JSONParser();
		
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
				
		String status = resultBody.get("status").toString();
				
		if (status.equals("ok")) {			
			JSONArray scheduleList = (JSONArray) resultBody.get("data");
			
			modelMap.addAttribute("scheduleListCnt", scheduleList.size());
			modelMap.addAttribute("scheduleList", scheduleList);
		}

		LOGGER.debug("mScheduleList ended.");
		
		return "/mobile/ezSchedule/mScheduleList";
	}
	
	/**
	 * 모바일 client 일정관리 상세화면
	 */
	@RequestMapping(value="/mobile/ezSchedule/mScheduleDetail.do")
	public String mScheduleDetail(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, ModelMap modelMap) throws Exception {
		LOGGER.debug("mScheduleDetail started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String gwServerUrl = config.getProperty("config.mobileGwServerURL");		
		String url = gwServerUrl + "/mobile/ezschedule/schedules/" + request.getParameter("scheduleId");
		
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
		
		if (status.equals("ok")) {
			JSONObject dataObject = (JSONObject) resultBody.get("data");
			
			String scheduleInfo = dataObject.get("scheduleInfo").toString();
			String resourceCnt = "";
			String attendantList = "";
			String attachList = "";
			
			if(dataObject.get("resourceCnt") != null) {
				resourceCnt = dataObject.get("resourceCnt").toString();
			}
			
			if(dataObject.get("attendantList") != null) {
				attendantList = dataObject.get("attendantList").toString();
			}		
			
			if(dataObject.get("attachList") != null) {
				attachList = dataObject.get("attachList").toString();
			}

			modelMap.addAttribute("scheduleInfo", scheduleInfo);
			modelMap.addAttribute("resourceCnt", resourceCnt);
			modelMap.addAttribute("attendantList", attendantList);
			modelMap.addAttribute("attachList", attachList);			
		}
		
		LOGGER.debug("mScheduleDetail ended.");
		
		return "/mobile/ezSchedule/mScheduleDetail";
	}
	
	/**
	 * 모바일 client 일정관리 등록
	 */
	@RequestMapping(value="/mobile/ezSchedule/mScheduleInsert.do")
	public void mScheduleInsert(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, ScheduleInfoVO scheduleInfoVO) throws Exception {
		LOGGER.debug("mScheduleInsert started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		scheduleInfoVO.setCreatorId(userInfo.getId());
		
		String gwServerUrl = config.getProperty("config.mobileGwServerURL");
		String url = gwServerUrl + "/mobile/ezschedule/schedules";
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		Gson gson = new Gson();
		JSONObject jsonParam = gson.fromJson(gson.toJson(scheduleInfoVO), JSONObject.class);
		
		HttpEntity<?> entity = new HttpEntity<>(jsonParam, headers);
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<JSONObject> result = rest.postForEntity(url, entity, JSONObject.class);
		
		JSONObject resultBody = result.getBody();
		
		String status = resultBody.get("status").toString();
		
		LOGGER.debug("mScheduleInsert ended.");
	}
	
	/**
	 * 모바일 client 일정관리 수정
	 */
	@RequestMapping(value="/mobile/ezSchedule/mScheduleUpdate.do")
	public void mScheduleUpdate(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, ScheduleInfoVO scheduleInfoVO) throws Exception {
		LOGGER.debug("mScheduleUpdate started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		scheduleInfoVO.setModifierId(userInfo.getId());

		String gwServerUrl = config.getProperty("config.mobileGwServerURL");
		String url = gwServerUrl + "/mobile/ezschedule/schedules/" + request.getParameter("scheduleId");
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		Gson gson = new Gson();
		JSONObject jsonParam = gson.fromJson(gson.toJson(scheduleInfoVO), JSONObject.class);
		
		HttpEntity<?> entity = new HttpEntity<>(jsonParam, headers);
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<JSONObject> result = rest.exchange(url, HttpMethod.PUT, entity, JSONObject.class);
		
		JSONObject resultBody = result.getBody();
		
		String status = resultBody.get("status").toString();
		
		LOGGER.debug("mScheduleUpdate ended.");
	}
	
	/**
	 * 모바일 client 일정관리 삭제(반복포함)
	 */
	@RequestMapping(value="/mobile/ezSchedule/mScheduleDelete.do")
	public void mScheduleDelete(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		LOGGER.debug("mScheduleDelete started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String gwServerUrl = config.getProperty("config.mobileGwServerURL");
		String url = gwServerUrl + "/mobile/ezschedule/schedules/" + request.getParameter("scheduleId");
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);

		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)		        
		        .queryParam("userId", userInfo.getId());
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<JSONObject> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.DELETE, entity, JSONObject.class);
		
		JSONObject resultBody = result.getBody();
		
		String status = resultBody.get("status").toString();
		
		LOGGER.debug("mScheduleDelete ended.");
	}
	
	/**
	 * 모바일 client 일정관리 등록화면
	 */
	@RequestMapping(value="/mobile/ezSchedule/mScheduleInsertForm.do")
	public String mScheduleInsertForm(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, ModelMap modelMap) throws Exception {
		LOGGER.debug("mScheduleInsertForm started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String gwServerUrl = config.getProperty("config.mobileGwServerURL");
		String url = gwServerUrl + "/mobile/ezschedule/type-List/users/" + userInfo.getId();
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);

		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url);
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<JSONObject> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, JSONObject.class);
		
		JSONObject resultBody = result.getBody();
		
		String status = resultBody.get("status").toString();
		
		//Gson gson = new Gson();

		modelMap.addAttribute("isPublic", resultBody.get("isPublic").toString());
		modelMap.addAttribute("scheduleType", resultBody.get("data").toString());
		
		LOGGER.debug("mScheduleInsertForm ended.");
		
		return "/mobile/ezSchedule/mScheduleInsert";
	}
}
