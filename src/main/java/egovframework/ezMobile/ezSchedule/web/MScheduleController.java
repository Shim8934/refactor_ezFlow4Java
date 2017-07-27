package egovframework.ezMobile.ezSchedule.web;

import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
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
	
	/*@Resource(name="EzCommonService")
	private EzCommonService ezCommonService;*/
	
	/////////////////////////////////////////////// sample start ///////////////////////////////////////////////////
	
	/**
	 * 모바일 client 일정관리 [get] method sample
	 */
	@RequestMapping(value="/mobile/ezSchedule/testList.do")
	public String testList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, ModelMap modelMap, LoginVO userInfo, HttpServletResponse response) throws Exception {
		LOGGER.debug("testList started.");
		
		String gwServerUrl = config.getProperty("config.mobileGwServerURL");		
		String url = gwServerUrl + "/ezschedule/1/gw-testList/fomace";
				
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);	

		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
		        .queryParam("name", "장진혁")
		        .queryParam("email", "fomace@kaoni.com")
		        .queryParam("position", "차장")
		        .queryParam("age", "37");
		
		RestTemplate rest = new RestTemplate();
		
		String sample = rest.getForObject(builder.build().encode().toUri(), String.class);

		LOGGER.debug("testList ended.");
		
		return sample.toString();
	}
	
	/**
	 * 모바일 client 일정관리 [put] method sample
	 */
	@RequestMapping(value="/mobile/ezSchedule/testUpdate.do")
	public void testUpdate(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, ModelMap modelMap, LoginVO userInfo, HttpServletResponse response) throws Exception {
		LOGGER.debug("testUpdate started.");
		
		String gwServerUrl = config.getProperty("config.mobileGwServerURL");
		String url = gwServerUrl + "ezschedule/{scheduleid}/gw-testUpdate/{id}";
		
		RestTemplate rest = new RestTemplate();
		
	    rest.put(url, userInfo, 1, "fomace");
		
	    LOGGER.debug("testUpdate ended.");		
	}
	
	///////////////////////////////////////////////// sample end /////////////////////////////////////////////////////
	
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
		String url = gwServerUrl + "/ezschedule/list/users/" + userInfo.getId();
				
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);

		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
		        .queryParam("startDate", startDate)
		        .queryParam("endDate", endDate);
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<JSONObject> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, JSONObject.class);
		
		JSONObject resultBody = result.getBody();
				
		String status = resultBody.get("status").toString();
		JSONArray scheduleList = new JSONArray();
		
		if (status.equals("ok")) {
			Gson gson = new Gson();
			scheduleList = gson.fromJson(gson.toJson(resultBody.get("data")), JSONArray.class);
			
			modelMap.addAttribute("scheduleListCnt", scheduleList.size());
			modelMap.addAttribute("scheduleList", scheduleList);
		}
System.out.println("status :" + status);		
System.out.println("scheduleList :" + scheduleList);

		LOGGER.debug("mScheduleList ended.");
		
		return "/mobile/ezSchedule/mScheduleList";
	}
	
	/**
	 * 모바일 client 일정관리 등록
	 */
	@RequestMapping(value="/mobile/ezSchedule/mScheduleInsert.do")
	public void mScheduleInsert(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, ScheduleInfoVO scheduleInfoVO) throws Exception {
		LOGGER.debug("mScheduleInsert started.");		
		
		String gwServerUrl = config.getProperty("config.mobileGwServerURL");
		String url = gwServerUrl + "/ezschedule/schedules";
		
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
		
System.out.println(status);		
System.out.println(gson.toJson(resultBody.get("data")));
		
		LOGGER.debug("mScheduleInsert ended.");
	}
	
	/**
	 * 모바일 client 일정관리 수정
	 */
	@RequestMapping(value="/mobile/ezSchedule/mScheduleUpdate.do")
	public void mScheduleUpdate(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, ScheduleInfoVO scheduleInfoVO) throws Exception {
		LOGGER.debug("mScheduleUpdate started.");		
		
		String gwServerUrl = config.getProperty("config.mobileGwServerURL");
		String url = gwServerUrl + "/ezschedule/schedules/" + request.getParameter("scheduleId");
		
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
		
System.out.println(status);		
System.out.println(gson.toJson(resultBody.get("data")));
		
		LOGGER.debug("mScheduleUpdate ended.");
	}
	
	/**
	 * 모바일 client 일정관리 삭제
	 */
	@RequestMapping(value="/mobile/ezSchedule/mScheduleDelete.do")
	public void mScheduleDelete(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, ScheduleInfoVO scheduleInfoVO) throws Exception {
		LOGGER.debug("mScheduleDelete started.");		
		
		String gwServerUrl = config.getProperty("config.mobileGwServerURL");
		String url = gwServerUrl + "/ezschedule/schedules/" + request.getParameter("scheduleId");
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);

		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
		        .queryParam("dateType", request.getParameter("dateType"))
		        .queryParam("userId", request.getParameter("userId"));
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<JSONObject> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.DELETE, entity, JSONObject.class);
		
		JSONObject resultBody = result.getBody();
		
		String status = resultBody.get("status").toString();
		
System.out.println(status);
		
		LOGGER.debug("mScheduleDelete ended.");
	}
}
