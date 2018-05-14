package egovframework.ezEKP.ezAttitude.web;

import java.util.Date;
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

import com.ibm.icu.text.SimpleDateFormat;
import com.ibm.icu.util.Calendar;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

@Controller
public class EzAttitudeBHSController {
	private static final Logger LOGGER = LoggerFactory.getLogger(EzAttitudeController.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
	@Autowired
	private EzCommonService ezCommonService;
	
	@Resource(name="crypto")
	private EgovFileScrty egovFileScrty;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	/**
	 * 근태 미입력자 팝업
	 */
	@RequestMapping(value = "/ezAttitude/popupAbsentedList.do")
	public String popupAbsentedList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		LOGGER.debug("popupAbsentedList started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String searchDeptId = request.getParameter("deptId");
		String date = request.getParameter("date");
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Calendar cal = Calendar.getInstance();
		
		String today = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), userInfo.getOffset(), false).substring(0, 10);
		String searchStartDate = date + "-01";
		String searchEndDate = "";
		
		LOGGER.debug(today.substring(0, 7));
		if (date.compareTo(today.substring(0, 7)) == 0) {
			//현재달
			searchEndDate = today;
		} else if (date.compareTo(today.substring(0, 7)) == -1) {
			//이전달
			Date firstDayofMonth = sdf.parse(searchStartDate);
			cal.setTime(firstDayofMonth);
			
			searchEndDate = searchStartDate.substring(0, 8) + Integer.toString(cal.getActualMaximum(Calendar.DAY_OF_MONTH));
		}
		//2018-05-14 이효진 다음달일땐 searchEndDate "" 으로 가져가서 미입력조회없이 tr에 정보없다고 script로
		
		model.addAttribute("companyId", userInfo.getCompanyID());
		model.addAttribute("searchDeptId", searchDeptId);
		model.addAttribute("searchStartDate", searchStartDate);
		model.addAttribute("searchEndDate", searchEndDate);
		
		LOGGER.debug("popupAbsentedList ended.");
		
		return "/ezAttitude/popupAbsentedList";
	}
	
	/**
	 * 사용자 근태리스트 출력
	 */
	@RequestMapping(value = "/ezAttitude/getAttitudeList.do", produces = "application/json;charset=utf-8")
	@ResponseBody
	public JSONArray getAttitudeList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LOGGER.debug("/ezAttitude/getAttitudeList started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String userId = userInfo.getId();
		String startDate = request.getParameter("startDate");
		String endDate =request.getParameter("endDate");
		String deptFlag = "false";
		String typeId = "";
		String selectedDeptID = "";
		
		if (request.getParameter("deptFlag") != null && !request.getParameter("deptFlag").equals("")) {
			deptFlag = request.getParameter("deptFlag");
		}
		
		if (request.getParameter("typeId") != null && !request.getParameter("typeId").equals("")) {
			typeId = request.getParameter("typeId");
		}
		
		if (request.getParameter("selectedDeptID") != null && !request.getParameter("selectedDeptID").equals("")) {
			selectedDeptID = request.getParameter("selectedDeptID");
		}
		
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		String url = gwServerUrl + "/rest/ezattitude/attitudes";
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("userId", userId)
				.queryParam("startDate", startDate)
				.queryParam("endDate", endDate)
				.queryParam("deptFlag", deptFlag)
				.queryParam("typeId", typeId)
				.queryParam("selectedDeptID", selectedDeptID);
		
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
		
		LOGGER.debug("/ezAttitude/getAttitudeList ended");
		return list;
	}
	
	/**
	 * 사용자 근태 추가 및 수정
	 */
	@RequestMapping(value = "/ezAttitude/attitudeSave.do")
	@ResponseBody
	public void attitudeSave(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LOGGER.debug("/ezAttitude/attitudeSave started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String attitudeId = request.getParameter("attitudeId");
		String typeId = request.getParameter("typeId");
		String region = request.getParameter("region");
		String mobile = request.getParameter("mobile");
		String bizSub = request.getParameter("bizSub");
		String startDate = request.getParameter("startDate");
		String endDate = request.getParameter("endDate");
		String dateType = request.getParameter("dateType");
		String mode = request.getParameter("mode");
		String content = request.getParameter("content");
		String userId = userInfo.getId();
		
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		String url = gwServerUrl;
		
		if (mode.equals("new")) {
			url += "/rest/ezattitude/users/" + userId + "/attitudes";
		} else if (mode.equals("mod")){
			url += "/rest/ezattitude/attitudes/" + attitudeId; // update GW url
		}
			
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("userId", userId)
				.queryParam("typeId", typeId)
				.queryParam("region", region)
				.queryParam("mobile", mobile)
				.queryParam("startDate", startDate)
				.queryParam("endDate", endDate)
				.queryParam("bizSub", bizSub)
				.queryParam("content", content)
				.queryParam("dateType", dateType);
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), (mode.equals("new")) ? HttpMethod.POST : HttpMethod.PUT, entity, String.class);
		
		JSONParser jp = new JSONParser();
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		
		String status = resultBody.get("status").toString();
		LOGGER.debug("status : " + status);
		
		if (status.equals("ok")) {
			
		}
		
		LOGGER.debug("/ezAttitude/attitudeSave ended");
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
		String isAllDept = "";
		String authFlag = "";
		boolean attitudeAdminCheck = true;
		
		if ( userInfo.getRollInfo().indexOf("c=1") != -1 ||userInfo.getRollInfo().indexOf("k=1") != -1 || userInfo.getRollInfo().indexOf("wa=1") != -1) {
			attitudeAdminCheck = true;
			isAllDept = "Y";
			
		} else if (userInfo.getRollInfo().indexOf("g=1") != -1) {
			attitudeAdminCheck = true;
		}		
		
		String userId = userInfo.getId();
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		String url = gwServerUrl + "/rest/ezattitude/companies/" + userInfo.getCompanyID() + "/attitudereg";
		
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
		
		JSONObject attitudeConfigVO = new JSONObject();
		if (status.equals("ok")) {
			attitudeConfigVO = (JSONObject) resultBody.get("data");
			model.addAttribute("attitudeConfigVO", attitudeConfigVO);
		}
		
		url = gwServerUrl + "/rest/ezattitude/users/" + userInfo.getId() + "/attitude-auth";
		
		headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		entity = new HttpEntity<>(headers);
		
		builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("companyId", userInfo.getCompanyID())
				.queryParam("isAllDept", isAllDept)
				.queryParam("userId", userInfo.getId());
		
		rest = new RestTemplate();
		
		result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		jp = new JSONParser();
		
		resultBody = (JSONObject) jp.parse(result.getBody());
		
		status = resultBody.get("status").toString();
		
		JSONArray deptList = new JSONArray();
		
		if(status.equals("ok")){
			deptList = (JSONArray) resultBody.get("data");
		}
		
		if (deptList.size() > 1) {
			attitudeAdminCheck = true;
			
			JSONObject dept = new JSONObject();
			
			for (int i = 0; i < deptList.size(); i++) {
				dept = (JSONObject) deptList.get(i);
				authFlag = (String) dept.get("authType");
			}
		}
		
		
		model.addAttribute("deptList", deptList);
		model.addAttribute("authFlag", authFlag);
		model.addAttribute("userOffset", userOffset);
		model.addAttribute("uselang", userInfo.getLang());
		model.addAttribute("attitudeAdminCheck", attitudeAdminCheck);
		
		LOGGER.debug("/ezAttitude/attitudeLeft ended"); 
		return "/ezAttitude/attitudeLeft";
	}
	
	/**
	 * 개인근태현황 main
	 */
	@RequestMapping(value = "/ezAttitude/attitudeUserMain.do")
	public String attitudeUserMain(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		LOGGER.debug("/ezAttitude/attitudeUserMain started");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		model.addAttribute("userInfo", userInfo);
		
		LOGGER.debug("/ezAttitude/attitudeUserMain ended");
		return "/ezAttitude/attitudeUserMain";
	}
	
	/**
	 * 근태타입 리스트
	 */
	@RequestMapping(value = "/ezAttitude/attitudeTypeList.do")
	@ResponseBody
	public JSONArray attitudeTypeList(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		LOGGER.debug("/ezAttitude/attitudeTypeList started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String userId = userInfo.getId();
		String isuse = "1";
		
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		String url = gwServerUrl + "/rest/ezattitude/companies/" + userInfo.getCompanyID() + "/attitudetypes";
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("userId", userId)
				.queryParam("isuse", isuse);
		
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
		
		LOGGER.debug("/ezAttitude/attitudeTypeList ended");
		return list;
	}
	
	/**
	 * 근태통계 리스트
	 */
	@RequestMapping(value = "/ezAttitude/attitudeStatisList.do")
	@ResponseBody
	public JSONArray attitudeStatisList(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		LOGGER.debug("/ezAttitude/attitudeTypeList started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String userId = userInfo.getId();
		String userOffset = userInfo.getOffset();
		String date = request.getParameter("date");
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		String url = gwServerUrl + "/rest/ezattitude/users/" + userId + "/attitude-count";
		String deptFlag = "false";
		String selectedDeptID = "";
		
		if (request.getParameter("selectedDeptID") != null && !request.getParameter("selectedDeptID").equals("")) {
			selectedDeptID = request.getParameter("selectedDeptID");
		}
		
		if (request.getParameter("deptFlag") != null && !request.getParameter("deptFlag").equals("")) {
			deptFlag = request.getParameter("deptFlag");
		}
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("userId", userId)
				.queryParam("offset", userOffset)
				.queryParam("date", date)
				.queryParam("deptFlag", deptFlag)
				.queryParam("selectedDeptID", selectedDeptID);
		
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
		
		LOGGER.debug("/ezAttitude/attitudeTypeList ended");
		return list;
	}
	
	/**
	 * 회사 휴일정보
	 */
	@RequestMapping(value = "/ezAttitude/getHolidayList.do")
	@ResponseBody
	public JSONObject getHolidayList(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		LOGGER.debug("/ezAttitude/getHolidayList started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String userId = userInfo.getId();
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		String url = gwServerUrl + "/rest/ezattitude/companies/" + userInfo.getCompanyID() + "/holidays";
		
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
		
		JSONObject returnValue = new JSONObject();
		JSONArray holidayList = new JSONArray();
		if (status.equals("ok")) {
			holidayList = (JSONArray) resultBody.get("data");
			returnValue.put("holidayList", holidayList);
			
			url = gwServerUrl + "/rest/ezattitude/companies/" + userInfo.getCompanyID() + "/attitudereg";
			
			builder = UriComponentsBuilder.fromHttpUrl(url)
					.queryParam("userId", userId);
			
			result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
			
			resultBody = (JSONObject) jp.parse(result.getBody());
			
			status = resultBody.get("status").toString();
			LOGGER.debug("status : " + status);
			
			JSONObject attitudeConfigVO = new JSONObject();
			if (status.equals("ok")) {
				attitudeConfigVO = (JSONObject) resultBody.get("data");
				returnValue.put("attitudeConfigVO", attitudeConfigVO);
			}
		}
		LOGGER.debug("/ezAttitude/getHolidayList ended");
		return returnValue;
	}
	
	/**
	 * 작성화면
	 */
	@RequestMapping(value = "/ezAttitude/attitudeNewItem.do")
	public String attitudeWrite(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		LOGGER.debug("/ezAttitude/attitudeNewItem started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String userId = userInfo.getId();
		String date = request.getParameter("date");
		String mode = request.getParameter("mode");
		String attitudeId = request.getParameter("attitudeId");
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		String userOffset = userInfo.getOffset().split("\\|")[1];
		String url = gwServerUrl + "/rest/ezattitude/companies/" + userInfo.getCompanyID() +"/attitudetypes";
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("userId", userId)
				.queryParam("isuse", 1);
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp = new JSONParser();
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		
		String status = resultBody.get("status").toString();
		LOGGER.debug("status : " + status);
		
		JSONArray attitudeTypeList = new JSONArray();
		if (status.equals("ok")) {
			attitudeTypeList = (JSONArray) resultBody.get("data");
			
			if (mode != null && mode.equals("mod")) {
				url = gwServerUrl + "/rest/ezattitude/attitudes/" + attitudeId; // 근태상세정보 GW 호출
				
				builder = UriComponentsBuilder.fromHttpUrl(url)
						.queryParam("userId", userId)
						.queryParam("attitudeId", attitudeId);
				
				result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
				resultBody = (JSONObject) jp.parse(result.getBody());
				
				status = resultBody.get("status").toString();
				LOGGER.debug("status : " + status);
				
				JSONObject attitudeVO = new JSONObject();
				if (status.equals("ok")) {
					attitudeVO = (JSONObject) resultBody.get("data");
					
					model.addAttribute("attitudeInfo", attitudeVO);
				}
			}
		}
		
		//현재시간
		String time = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), userInfo.getOffset(), false).split(" ")[1];
		
		model.addAttribute("userOffset", userOffset);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("attitudeTypeList", attitudeTypeList);
		model.addAttribute("date", date);
		model.addAttribute("time", time);
		model.addAttribute("mode", mode);
		
		LOGGER.debug("/ezAttitude/attitudeNewItem ended");
		return "ezAttitude/attitudeNewItem";
	}
	
	/**
	 * 수정신청작성화면
	 */
	@RequestMapping(value = "/ezAttitude/attitudeModItem.do")
	public String attitudeModify(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		LOGGER.debug("/ezAttitude/attitudeModItem started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String userId = userInfo.getId();
		String attitudeId = request.getParameter("attitudeId");
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		
		String url = gwServerUrl + "/rest/ezattitude/attitudes/" + attitudeId; // 근태상세정보 GW 호출
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("userId", userId)
				.queryParam("attitudeId", attitudeId);
		
		RestTemplate rest = new RestTemplate();
		
		JSONParser jp = new JSONParser();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		
		String status = resultBody.get("status").toString();
		LOGGER.debug("status : " + status);
		
		JSONObject attitudeVO = new JSONObject();
		if (status.equals("ok")) {
			attitudeVO = (JSONObject) resultBody.get("data");

			model.addAttribute("data", attitudeVO);
		}
		LOGGER.debug("attitudeVOtoJSONString : " + attitudeVO.toJSONString());		
		model.addAttribute("userInfo", userInfo);

		LOGGER.debug("/ezAttitude/attitudeModItem ended");
		
		return "ezAttitude/attitudeModItem";
	}
	
	/**
	 * 작성 양식
	 */
	@RequestMapping(value = "/ezAttitude/getFormBody.do")
	@ResponseBody
	public JSONObject getFormBody(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LOGGER.debug("/ezAttitude/getFormBody started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String userId = userInfo.getId();
		String typeId = request.getParameter("typeId"); 
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		String url = gwServerUrl + "/rest/ezattitude/attitudetypes/" + typeId +"/forms/form";
		
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
		
		JSONObject formVO = new JSONObject();
		if (status.equals("ok")) {
			formVO = (JSONObject) resultBody.get("data");
		}
		
		LOGGER.debug("/ezAttitude/getFormBody ended");
		return formVO;
	}
	
	/**
	 * 근태 상세보기
	 */
	@RequestMapping(value = "/ezAttitude/attitudeItemView.do")
	public String attitudeItemView(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		LOGGER.debug("/ezAttitude/attitudeItemView started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String font = ezCommonService.getTenantConfig("editorFontStyle", userInfo.getTenantId());
		
		String userId = userInfo.getId();
		String attitudeId = request.getParameter("attitudeId");
		String typeId = request.getParameter("typeId");
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		String url = gwServerUrl + "/rest/ezattitude/attitudetypes/" + typeId +"/forms/form";
		
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
		
		JSONObject formVO = new JSONObject();
		if (status.equals("ok")) {
			formVO = (JSONObject) resultBody.get("data");
			
			model.addAttribute("formInfo", formVO);
			
			url = gwServerUrl + "/rest/ezattitude/attitudes/" + attitudeId; // 근태상세정보 GW 호출
			
			builder = UriComponentsBuilder.fromHttpUrl(url)
					.queryParam("userId", userId)
					.queryParam("attitudeId", attitudeId);
			
			result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
			resultBody = (JSONObject) jp.parse(result.getBody());
			
			status = resultBody.get("status").toString();
			LOGGER.debug("status : " + status);
			
			JSONObject attitudeVO = new JSONObject();
			if (status.equals("ok")) {
				attitudeVO = (JSONObject) resultBody.get("data");
				model.addAttribute("attitudeInfo", attitudeVO);
			}
		} 
		
		model.addAttribute("font", font);
		
		LOGGER.debug("/ezAttitude/attitudeItemView ended");
		return "/ezAttitude/attitudeItemView";
	}
	
	/**
	 * 근태 삭제
	 */
	@RequestMapping(value = "/ezAttitude/attitudeDeleteItem.do")
	@ResponseBody
	public void attitudeDeleteItem(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LOGGER.debug("/ezAttitude/attitudeDeleteItem started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String userId = userInfo.getId();
		String attitudeId = request.getParameter("attitudeId");
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		
		String url = gwServerUrl + "/rest/ezattitude/attitudes/" + attitudeId;
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("userId", userId);
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.DELETE, entity, String.class);
		
		JSONParser jp = new JSONParser();
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		
		String status = resultBody.get("status").toString();
		LOGGER.debug("status : " + status);
		
		if (status.equals("ok")) {
			
		}
		
		LOGGER.debug("/ezAttitude/attitudeDeleteItem ended");
	}
	
	/**
	 * 사원이 속한 회사의 근태규율을 가져오는 메소드
	 */
	@RequestMapping(value = "/ezAttitude/getAttitudeConf.do")
	@ResponseBody
	public JSONObject getAttitudeConf(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LOGGER.debug("/ezAttitude/getAttitudeConf started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String userId = userInfo.getId();
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		String url = gwServerUrl + "/rest/ezattitude/companies/" + userInfo.getCompanyID() + "/attitudereg";
		
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
		
		JSONObject attitudeConfigVO = new JSONObject();
		if (status.equals("ok")) {
			attitudeConfigVO = (JSONObject) resultBody.get("data");
		}
		LOGGER.debug("/ezAttitude/getAttitudeConf ended");
		return attitudeConfigVO;
	}
	
	/**
	 * 수정신청 저장
	 */
	@RequestMapping(value = "/ezAttitude/saveAttModApp.do")
	@ResponseBody
	public void modApplicationSave(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LOGGER.debug("/ezAttitude/modApplicationSave started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String userId = userInfo.getId();
		String attitudeId = request.getParameter("attitudeId");
		String changeDate = request.getParameter("changeDate");
		String content = request.getParameter("content");
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		String url = gwServerUrl + "/rest/ezattitude/attitudes/" + attitudeId + "/modify-applications";
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("userId", userId)
				.queryParam("changeDate", changeDate)
				.queryParam("content", content);
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp = new JSONParser();
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		
		String status = resultBody.get("status").toString();
		LOGGER.debug("status : " + status);
		
		if (status.equals("ok")) {
			
		}
		
		LOGGER.debug("/ezAttitude/modApplicationSave ended");
	}
	
	/**
	 * 근태 내용
	 */
	@RequestMapping(value = "/ezAttitude/getAttitudeItem.do")
	@ResponseBody
	public JSONObject getAttitudeItem(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LOGGER.debug("/ezAttitude/getAttitudeItem started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String userId = userInfo.getId();
		String attitudeId = request.getParameter("attitudeId");
		
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		String url = gwServerUrl + "/rest/ezattitude/attitudes/"  + attitudeId;; //근태상세보기 가져오기
		
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
		
		JSONObject returnValue = new JSONObject();
		JSONObject attitudeVO = new JSONObject();
		if (status.equals("ok")) {
			attitudeVO = (JSONObject) resultBody.get("data");
			returnValue.put("attitudeVO", attitudeVO);
			LOGGER.debug("vovovovovovovovovovovovovo : " + attitudeVO.get("typeId"));
			url = gwServerUrl + "/rest/ezattitude/attitudetypes/" + attitudeVO.get("typeId") + "/forms/form"; // form 가져와야됨
			
			builder = UriComponentsBuilder.fromHttpUrl(url)
					.queryParam("userId", userId);
			
			result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
			resultBody = (JSONObject) jp.parse(result.getBody());
			
			status = resultBody.get("status").toString();
			LOGGER.debug("status : " + status);
			
			JSONObject formVO = new JSONObject();
			if (status.equals("ok")) {
				formVO = (JSONObject) resultBody.get("data");
				returnValue.put("formVO", formVO);
			}
		}
		LOGGER.debug("/ezAttitude/getAttitudeItem ended");
		return returnValue;
	}
}
