package egovframework.ezEKP.ezAttitude.web;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.Row;
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
import org.springframework.web.servlet.HandlerMapping;
import org.springframework.web.util.UriComponentsBuilder;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.ibm.icu.text.SimpleDateFormat;
import com.ibm.icu.util.Calendar;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezAttitude.vo.AdminAttitudeVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeConfigVO;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.let.user.login.vo.LoginSimpleVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

@Controller
public class EzAttitudeAdminBOMController {
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
	 * 관리자 근태규율관리 화면 호출 함수
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
		JSONObject data = new JSONObject();
		String adminCompany = "";
		
		if (status.equals("ok")) {
			data = (JSONObject) resultBody.get("data");
			list = (JSONArray) data.get("list");
			adminCompany = (String) data.get("adminCompany");
			
			model.addAttribute("list", list);
			model.addAttribute("adminCompany", adminCompany);
		}
		
		LOGGER.debug("attitudeConfig ended.");
		
		return "/admin/ezAttitude/attitudeConfig";
	}
	/**
	 * 관리자 근태규율관리 회사별 설정 호출 함수
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
	 */
	@RequestMapping(value = "/admin/ezAttitude/updateAttitudeConfInfo.do")
	@ResponseBody
	public String updateAttitudeConfInfo(AttitudeConfigVO attitudeConfigVO, @CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LOGGER.debug("updateAttitudeConfInfo started.");
		
		String workStartTime = request.getParameter("workStartTime");
		String workEndTime = request.getParameter("workEndTime");
		String closedDay = request.getParameter("closedDay");
		String attitudeModAppl = request.getParameter("attitudeModAppl");
		String closedDateAttitude = request.getParameter("closedDateAttitude");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);

		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");		
		String url = gwServerUrl + "/rest/ezattitude/companies/" + request.getParameter("companyId") + "/attitudereg";
									
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("userId", userInfo.getId())
				.queryParam("workStartTime", workStartTime)
				.queryParam("workEndTime", workEndTime)
				.queryParam("closedDay", closedDay)
				.queryParam("attitudeModAppl", attitudeModAppl)
				.queryParam("closedDateAttitude", closedDateAttitude);
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<JSONObject> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.PUT, entity, JSONObject.class);
		
		JSONObject resultBody = result.getBody();
		
		String status = resultBody.get("status").toString();
		
		String resultStatus = "";
		if (status.equals("ok")) {
			resultStatus = "success";
		} else {
			resultStatus = "error";
		}
		
		LOGGER.debug("updateAttitudeConfInfo ended.");
		
		return resultStatus;
	}
	
	/**
	 * 근태관리 휴가유형관리 화면조회
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
		JSONObject data = new JSONObject();
		String adminCompany = "";
		if (status.equals("ok")) {
			data = (JSONObject) resultBody.get("data");
			list = (JSONArray) data.get("list");
			adminCompany = (String) data.get("adminCompany");
			
			model.addAttribute("list", list);
			model.addAttribute("adminCompany", adminCompany);
		}
		
		LOGGER.debug("attitudeTypeConfig ended.");
		
		return "/admin/ezAttitude/attitudeTypeConfig";
	}
	
	/**
	 * 근태관리 휴가유형관리 리스트 조회
	 */
	@RequestMapping(value = "/admin/ezAttitude/attitudeTypeConfigInfo.do")
	@ResponseBody
	public JSONArray attitudeTypeConfigInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LOGGER.debug("attitudeTypeConfigInfo started.");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		String url = gwServerUrl + "/rest/ezattitude/companies/" + request.getParameter("companyId") + "/attitudetypes";
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("userId", userInfo.getId())
				.queryParam("isAdmin", "y");
		
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
	/**
	 * 근태관리 휴가유형관리 저장
	 */
	@RequestMapping(value = "/admin/ezAttitude/saveAttitudeTypeConfig.do")
	@ResponseBody
	public String saveAttitudeTypeConfig(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LOGGER.debug("saveAttitudeTypeConfig started.");
		
		String typeConfigList = request.getParameter("typeList");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);

		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");	
		String url = gwServerUrl + "/rest/ezattitude/companies/" + request.getParameter("companyId") + "/attitudetypes";
									
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("userId", userInfo.getId())
				.queryParam("typeConfigList", typeConfigList);
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<JSONObject> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.PUT, entity, JSONObject.class);
		
		JSONObject resultBody = result.getBody();
		
		String status = resultBody.get("status").toString();
		
		String resultStatus = "";
		if (status.equals("ok")) {
			resultStatus = "success";
		} else {
			resultStatus = "error";
		}
		
		LOGGER.debug("status :" + status);
		LOGGER.debug("saveAttitudeTypeConfig ended.");
		
		return resultStatus;
	}
	
	/**
	 * 근태관리 휴가유형관리 휴가유형추가 화면조회
	 */
	@RequestMapping(value = "/admin/ezAttitude/addAttitudeType.do")
	public String addAttitudeType(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		LOGGER.debug("addAttitudeType started.");
		
		String companyId = request.getParameter("companyId");
		
		model.addAttribute("companyId", companyId);
		
		LOGGER.debug("addAttitudeType ended.");
		
		return "/admin/ezAttitude/saveAttitudeType";
	}
	
	/**
	 * 근태관리 휴가유형관리 휴가유형추가,수정 화면 조회
	 */
	@RequestMapping(value = "/admin/ezAttitude/showAttitudeType.do")
	public String  showAttitudeType(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		LOGGER.debug("showAttitudeType started.");
				
		String attitudetypeId = request.getParameter("typeId");
		String companyId = request.getParameter("companyId");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);

		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");	
		String url = gwServerUrl + "/rest/ezattitude/companies/" + companyId + "/attitudetypes/" + attitudetypeId;
									
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
		
		JSONObject typeInfo = new JSONObject();
		
		if (status.equals("ok")) {
			typeInfo = (JSONObject) resultBody.get("data");
			
			model.addAttribute("typeInfo", typeInfo);
			model.addAttribute("companyId", companyId);
		}
		
		LOGGER.debug("showAttitudeType ended.");
		
		return "/admin/ezAttitude/saveAttitudeType";
	}
	
	/**
	 * 근태관리 휴가유형관리 휴가유형 등록 ,수정
	 */
	@RequestMapping(value = "/admin/ezAttitude/saveAttitudeType.do")
	@ResponseBody
	public String saveAttutideType(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		LOGGER.debug("saveAttutideType started.");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		String companyId = request.getParameter("companyId");
		String typeId = request.getParameter("typeId");
		String typeName = request.getParameter("typeName");
		String typeName2 = request.getParameter("typeName2");
		
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		String url = "";
		if (typeId.equals("")) {
			url = gwServerUrl + "/rest/ezattitude/companies/" + companyId + "/attitudetypes/";
		} else {
			url = gwServerUrl + "/rest/ezattitude/companies/" + companyId + "/attitudetypes/" + typeId;
		}
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("userId", userInfo.getId())
				.queryParam("typeId", typeId)
				.queryParam("typeName", typeName)
				.queryParam("typeName2", typeName2);
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<?> result;
		
		if (typeId.equals("")) {
			result = rest.exchange(builder.build().encode().toUri(), HttpMethod.POST, entity, JSONObject.class);
		} else {
			result = rest.exchange(builder.build().encode().toUri(), HttpMethod.PUT, entity, JSONObject.class);
		}
		
		//insert시  count27개 넘으면 status failed로 리턴하게 해놓음
		
		JSONObject resultBody = (JSONObject) result.getBody();
		
		String status = resultBody.get("status").toString();
		
		String resultStatus = "";
		if (status.equals("ok")) {
			resultStatus = "success";
		} else if (status.equals("failed")) {
			resultStatus = "failed";
		} else {
			resultStatus = "error";
		}
		
		LOGGER.debug("saveAttutideType ended.");
		
		return resultStatus;
	}
	/**
	 * 근태유형 삭제
	 * @param loginCookie
	 * @param request
	 * @param model
	 * @throws Exception
	 */
	@RequestMapping(value = "/admin/ezAttitude/deleteAttitudeType.do")
	@ResponseBody
	public String deleteAttutideType(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		
		LOGGER.debug("saveAttutideType started.");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		String companyId = request.getParameter("companyId");
		String typeId = request.getParameter("typeId");
		
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");	
		String url = gwServerUrl + "/rest/ezattitude/companies/" + companyId + "/attitudetypes/" + typeId;
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("userId", userInfo.getId())
				.queryParam("typeId", typeId);
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.DELETE, entity, String.class);
		
		JSONParser jp = new JSONParser();
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		
		String status = resultBody.get("status").toString();
		LOGGER.debug("status : " + status);
		
		String isUse = "";
		if (status.equals("ok")) {			
			isUse = (String) resultBody.get("data");
		}
		
		LOGGER.debug("saveAttutideType ended.");
		
		return isUse;
	}
	
	/**
	 * 사원리스트(조직도)
	 */
	@RequestMapping(value = "/admin/ezAttitude/deptUserList.do")
	public String deptUserList(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, Model model){
		LOGGER.debug("userList started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		HashMap<String, Object> map = new HashMap<String, Object>();
		
		String key = request.getParameter("key");
		map.put("key",key );
		map.put("value", request.getParameter("value"));
		map.put("userId", userInfo.getId());
		LOGGER.debug(request.getParameter("key"));
		LOGGER.debug(request.getParameter("value"));
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezattitude/organtree/users", map, request,"get",null);
//		JSONObject resultBody = commonUtil.getJsonFromRestApi("/rest/ezjournal/users", map, request,"get",null);
		
		String status = resultBody.get("status").toString();
		if (status.equals("ok")) {		
			JSONArray userList = (JSONArray) resultBody.get("data");
			
			model.addAttribute("userList", userList);
			
			String keyword = "";
			if (key.equals("DEPARTMENT") && userList.size()!=0) {
				keyword = (String) ((JSONObject)userList.get(0)).get("deptName");
			} else{
				keyword = "검색";
			}
			LOGGER.debug("keyword : "+keyword);
			int userCount = 0;
			if (userList.size()==0) {
				keyword = "결과없음";
			} else {
				userCount = userList.size();
			}
			model.addAttribute("keyword",keyword);
			model.addAttribute("userCount",userCount);
		}
		
		LOGGER.debug("userList ended");
		return "/admin/ezAttitude/deptUserList";
	}

	/**
	 * 관리자 근무시간관리 화면조회
	 */
	@RequestMapping(value = "/admin/ezAttitude/attitudeUserConf.do")
	public String attitudeUserConf(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception{
		LOGGER.debug("/admin/ezAttitude/attitudeUserConf started");
		
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
		
		LOGGER.debug("status : " + status);
		
		if (status.equals("ok")) {
			JSONObject data = (JSONObject) resultBody.get("data");
			JSONArray list = (JSONArray) data.get("list");
			String adminCompany = (String) data.get("adminCompany");
			
			model.addAttribute("list", list);
			model.addAttribute("adminCompany", adminCompany);
		}
		
		LOGGER.debug("/admin/ezAttitude/attitudeUserConf ended");
		
		return "/admin/ezAttitude/attitudeUserConf";
	}
	
	/**
	 * 근무시간관리 리스트 출력
	 */
	@RequestMapping(value = "/admin/ezAttitude/attitudeUserConfList.do")
	@ResponseBody
	public JSONObject getAttitudeUserConfList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LOGGER.debug("/admin/ezAttitude/attitudeUserConfList started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		String companyId = request.getParameter("companyId");
		String searchUserName = request.getParameter("userName");
		String searchDeptName = request.getParameter("deptName");
		String searchTitle = request.getParameter("title");
		String searchStartTime = request.getParameter("startTime");
		String searchEndTime = request.getParameter("endTime");
		String searchGubun = request.getParameter("gubun");
		String pageNum = request.getParameter("pageNum");
		String listSize = request.getParameter("listSize");
		String orderCell = request.getParameter("orderCell");
		String orderOption = request.getParameter("orderOption");
		String userId = userInfo.getId();
		String offsetMin = commonUtil.getMinuteUTC(userInfo.getOffset());
		
		LOGGER.debug("userName : " + searchUserName + " || deptName : " + searchDeptName + " + || searchTitle = " + searchTitle + " || searchStartTime = " + searchStartTime + " || searchEndTime = " + searchEndTime + " || searchGubun = " + searchGubun + " || pageNum : " + pageNum + " || listSize : " + listSize + " || orderCell : " + orderCell + " || orderOption : " + orderOption);
		
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		String url = gwServerUrl + "/rest/ezattitude/user-attitude-confs";
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("companyId", companyId)
				.queryParam("searchUserName", searchUserName)
				.queryParam("searchDeptName", searchDeptName)
				.queryParam("searchTitle", searchTitle)
				.queryParam("searchStartTime", searchStartTime)
				.queryParam("searchEndTime", searchEndTime)
				.queryParam("searchGubun", searchGubun)
				.queryParam("userId", userId)
				.queryParam("pageNum", pageNum)
				.queryParam("listSize", listSize)
				.queryParam("orderCell", orderCell)
				.queryParam("orderOption", orderOption)
				.queryParam("offsetMin", offsetMin);
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp = new JSONParser();
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		
		String status = resultBody.get("status").toString();
		
		LOGGER.debug("status : " + status);
		
		JSONObject jObject = new JSONObject();
		
		if(status.equals("ok")){
			jObject = (JSONObject) resultBody.get("data");
		}
		
		LOGGER.debug("/admin/ezAttitude/attitudeUserConfList ended");
		
		return jObject;
	}
	/**
	 * 근무시간 수정화면 조회
	 */
	@RequestMapping(value = "/admin/ezAttitude/editAttitudeUserConf.do")
	public String saveAttitudeUserConf(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception{
		
		LOGGER.debug("/admin/ezAttitude/editAttitudeUserConf started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		String selectedUserIdList = request.getParameter("selectedUserIdList");
		String companyId = request.getParameter("companyId");
		
		LOGGER.debug("selectedUserIdList = " + selectedUserIdList);
		
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		String url = gwServerUrl + "/rest/ezattitude/companies/" + companyId + "/attitudereg";
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("userId", userInfo.getId())
				.queryParam("companyId", companyId)
				.queryParam("selectedUserIdList", selectedUserIdList);
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp = new JSONParser();
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		
		String status = resultBody.get("status").toString();
		LOGGER.debug("status : " + status);
		
		result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		resultBody = (JSONObject) jp.parse(result.getBody());
		
		status = resultBody.get("status").toString();
		
		LOGGER.debug("status : " + status);
		
		JSONObject jObject = new JSONObject();
		
		if(status.equals("ok")){
			jObject = (JSONObject) resultBody.get("data");
			
			model.addAttribute("companyStartTime", jObject.get("workStartTime"));
			model.addAttribute("companyEndTime", jObject.get("workEndTime"));
		}
		
		url = gwServerUrl + "/rest/ezattitude/users/users-attitude-confs";
		
		entity = new HttpEntity<>(headers);
		builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("userId", userInfo.getId())
				.queryParam("companyId", companyId)
				.queryParam("selectedUserIdList", selectedUserIdList);
		
		rest = new RestTemplate();
		
		result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		jp = new JSONParser();
		resultBody = (JSONObject) jp.parse(result.getBody());
		
		status = resultBody.get("status").toString();
		LOGGER.debug("status : " + status);
		
		result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		resultBody = (JSONObject) jp.parse(result.getBody());
		
		status = resultBody.get("status").toString();
		
		LOGGER.debug("status : " + status);
		
		jObject = new JSONObject();
		
		if(status.equals("ok")){
			jObject = (JSONObject) resultBody.get("data");
			
			model.addAttribute("vo", jObject);
		}
		
		model.addAttribute("companyId", companyId);
		model.addAttribute("selectedUserIdList", selectedUserIdList);
		
		LOGGER.debug("/admin/ezAttitude/editAttitudeUserConf ended");
		
		return "/admin/ezAttitude/editAttitudeUserConf";
	}
	
	/**
	 * 근무시간관리 근무시간 수정
	 */
	@RequestMapping(value = "/admin/ezAttitude/editAttitudeUserConfig.do")
	@ResponseBody
	public String editAttitudeUserConfig(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie) throws Exception {
		LOGGER.debug("editAttitudeUserConfig started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String companyId = request.getParameter("companyId");
		String selectedUserIdList = request.getParameter("selectedUserIdList");
		String workStartTime = request.getParameter("workStartTime");
		String workEndTime = request.getParameter("workEndTime");
		String gubun = request.getParameter("gubun");
		
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		String url = gwServerUrl + "/rest/users/ezattitude/user-attitude-confs";
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("companyId", companyId)
				.queryParam("userId", userInfo.getId())
				.queryParam("selectedUserIdList", selectedUserIdList)
				.queryParam("workStartTime", workStartTime)
				.queryParam("workEndTime", workEndTime)
				.queryParam("gubun", gubun);
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.POST, entity, String.class);
		
		JSONParser jp = new JSONParser();
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		
		String status = resultBody.get("status").toString();
		LOGGER.debug("status : " + status);
		LOGGER.debug("editAttitudeUserConfig ended");
		
		return status;
	}
	
	/**
	 * 관리자 근태입력관리 화면조회
	 */
	@RequestMapping(value = "/admin/ezAttitude/attitudeCheck.do")
	public String attitudeCheck(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		LOGGER.debug("/admin/ezAttitude/attitudeDeptConf started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String offset = userInfo.getOffset();
		String adminCompany = "";
		
		if (userInfo.getRollInfo().indexOf("c=1") == -1 && userInfo.getRollInfo().indexOf("k=1") == -1) {
			return "cmm/error/adminDenied";
		}
		
		String localDate = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), offset, false).substring(0, 10);
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Calendar cal = Calendar.getInstance();
		
		
		cal = Calendar.getInstance();
		cal.setTime(sdf.parse(localDate));
		cal.add(Calendar.DAY_OF_MONTH, -7);
		
		String searchStartDate = sdf.format(cal.getTime());
		String searchEndDate = localDate;
		
		//회사리스트
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
		LOGGER.debug("status : " + status);
		
		JSONArray list = new JSONArray();
		JSONObject data = new JSONObject();
		
		if (status.equals("ok")) {
			data = (JSONObject) resultBody.get("data");
			list = (JSONArray) data.get("list");
			adminCompany = (String) data.get("adminCompany");
			
			model.addAttribute("list", list);
			model.addAttribute("adminCompany", adminCompany);
			model.addAttribute("searchStartDate", searchStartDate.substring(0, 10));
			model.addAttribute("searchEndDate", searchEndDate.substring(0, 10));
		}
		
		LOGGER.debug("/admin/ezAttitude/attitudeDeptConf ended");
		
		return "/admin/ezAttitude/attitudeCheck";
	}
	
	/**
	 * 관리자 근태입력관리 조회
	 */
	@RequestMapping(value = "/admin/ezAttitude/attitudeCheckList.do", produces = "application/json;charset=utf-8")
	@ResponseBody
	public JSONObject getAttitudeCheckList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LOGGER.debug("/admin/ezAttitude/attitudeCheckList started.");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		String companyId = request.getParameter("companyId");
		String searchUserName = request.getParameter("userName");
		String searchDeptName = request.getParameter("deptName");
		String searchTitle = request.getParameter("title");
		String searchStartDate = request.getParameter("startDate");
		String searchEndDate = request.getParameter("endDate");
		String searchAttitudeType = request.getParameter("attitudeType");
		String pageNum = request.getParameter("pageNum");
		String listSize = request.getParameter("listSize");
		String orderCell = request.getParameter("orderCell");
		String orderOption = request.getParameter("orderOption");
		String userId = userInfo.getId();
		String offsetMin = commonUtil.getMinuteUTC(userInfo.getOffset());
		
		LOGGER.debug("searchUserName = " + searchUserName + " || searchDeptName = " + searchDeptName + " || searchTitle = " + searchTitle + " || searchStartDate = " + searchStartDate
				+ " || searchEndDate = " + searchEndDate + " || searchAttitudeType = " + searchAttitudeType + " || pageNum = " + pageNum + " || listSize = " + listSize
				+ " || orderCell = " + orderCell + "orderOption = " + orderOption);
		
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		String url = gwServerUrl + "/rest/ezattitude/attitudes/bombom"; //
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("companyId", companyId)
				.queryParam("searchUserName", searchUserName)
				.queryParam("searchDeptName", searchDeptName)
				.queryParam("searchTitle", searchTitle)
				.queryParam("searchStartDate", searchStartDate)
				.queryParam("searchEndDate", searchEndDate)
				.queryParam("searchAttitudeType", searchAttitudeType)
				.queryParam("userId", userId)
				.queryParam("pageNum", pageNum)
				.queryParam("listSize", listSize)
				.queryParam("orderCell", orderCell)
				.queryParam("orderOption", orderOption)
				.queryParam("offsetMin", offsetMin);
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp = new JSONParser();
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		
		String status = resultBody.get("status").toString();
		LOGGER.debug("status : " + status);
		
		JSONObject jObject = new JSONObject();
		if(status.equals("ok")){
			jObject = (JSONObject) resultBody.get("data");
		}
		
		LOGGER.debug("/admin/ezAttitude/attitudeCheckList ended");
		
		return jObject;
	}
	
	/**
	 * 근태조회 미입력자관리 화면조회
	 */
	@RequestMapping(value = "/admin/ezAttitude/attitudeAbsented.do")
	public String attitudeAbsented(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		LOGGER.debug("/admin/ezAttitude/attitudeAbsented.do");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String offset = userInfo.getOffset();
		String adminCompany = "";
		
		if (userInfo.getRollInfo().indexOf("c=1") == -1 && userInfo.getRollInfo().indexOf("k=1") == -1) {
			return "cmm/error/adminDenied";
		}
		
		String localDate = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), offset, false).substring(0, 10);
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Calendar cal = Calendar.getInstance();
		
		
		cal = Calendar.getInstance();
		cal.setTime(sdf.parse(localDate));
		cal.add(Calendar.DAY_OF_MONTH, -7);
		
		String searchStartDate = sdf.format(cal.getTime());
		String searchEndDate = localDate;
		
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
		LOGGER.debug("status : " + status);
		
		JSONArray list = new JSONArray();
		JSONObject data = new JSONObject();

		if (status.equals("ok")) {
			data = (JSONObject) resultBody.get("data");
			list = (JSONArray) data.get("list");
			adminCompany = (String) data.get("adminCompany");
			
			model.addAttribute("list", list);
			model.addAttribute("adminCompany", adminCompany);
			model.addAttribute("searchStartDate", searchStartDate.substring(0, 10));
			model.addAttribute("searchEndDate", searchEndDate.substring(0, 10));
		}
		
		LOGGER.debug("/admin/ezAttitude/attitudeAbsented.do");
		
		return "/admin/ezAttitude/attitudeAbsented";
	}
	
	/**
	 * 근태조회 미입력자관리 조회
	 */
	@RequestMapping(value = {"/admin/ezAttitude/getAttitudeAbsentedList.do", "/ezAttitude/getAttitudeAbsentedList.do"})
	@ResponseBody
	public JSONObject getAttitudeAbsentedList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LOGGER.debug("getAttitudeAbsentedList started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String userId = userInfo.getId();
		String offsetMin = commonUtil.getMinuteUTC(userInfo.getOffset());
		String companyId = request.getParameter("companyId");
		String searchUserName = request.getParameter("userName");
		String searchDeptName = request.getParameter("deptName");
		String searchTitle = request.getParameter("title");
		String searchDeptId = request.getParameter("deptId");
		String searchStartDate = request.getParameter("startDate");
		String searchEndDate = request.getParameter("endDate");
		String pageNum = request.getParameter("pageNum");
		String listSize = request.getParameter("listSize");
		String orderCell = request.getParameter("orderCell");
		String orderOption = request.getParameter("orderOption");
		String duplicated = request.getParameter("duplicated");
		String requestURL = (String) request.getAttribute(HandlerMapping.PATH_WITHIN_HANDLER_MAPPING_ATTRIBUTE);
		String isAdmin = "";
		
		if (requestURL.indexOf("/admin/ezAttitude/getAttitudeAbsentedList.do") > -1) {
			isAdmin = "Y";
		}
		
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		String url = gwServerUrl + "/rest/ezattitude/attitudes/absent";
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("companyId", companyId)
				.queryParam("searchUserName", searchUserName)
				.queryParam("searchDeptName", searchDeptName)
				.queryParam("searchTitle", searchTitle)
				.queryParam("searchStartDate", searchStartDate)
				.queryParam("searchEndDate", searchEndDate)
				.queryParam("searchDeptId", searchDeptId)
				.queryParam("userId", userId)
				.queryParam("pageNum", pageNum)
				.queryParam("listSize", listSize)
				.queryParam("orderCell", orderCell)
				.queryParam("orderOption", orderOption)
				.queryParam("duplicated", duplicated)
				.queryParam("offsetMin", offsetMin)
				.queryParam("isAdmin", isAdmin);
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp = new JSONParser();
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		
		String status = resultBody.get("status").toString();
		LOGGER.debug("status : " + status);
		
		JSONObject jObject = new JSONObject();
		if(status.equals("ok")){
			jObject = (JSONObject) resultBody.get("data");
		}
		
		LOGGER.debug("getAttitudeAbsentedList ended.");
		
		return jObject;
	}
	
	/**
	 * 근태입력조회, 근태미입력조회 엑셀 출력
	 */
	@RequestMapping(value = {"/admin/ezAttitude/excelAttitudeListExport.do", "/admin/ezAttitude/excelAbsentedListExport.do"})
	public void excelFileExport(@CookieValue("loginCookie")String loginCookie, HttpServletResponse response, HttpServletRequest request) throws Exception{
		LOGGER.debug("excelFileExport started."); 
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie); 
		
		String companyId = request.getParameter("companyId");
		String searchUserName = request.getParameter("userName");
		String searchDeptName = request.getParameter("deptName");
		String searchTitle = request.getParameter("title");
		String searchDeptId = request.getParameter("deptId");
		String searchStartDate = request.getParameter("startDate");
		String searchEndDate = request.getParameter("endDate");
		String searchAttitudeType = request.getParameter("attitudeType");
		String pageNum = request.getParameter("pageNum");
		String listSize = request.getParameter("listSize");
		String orderCell = request.getParameter("orderCell");
		String orderOption = request.getParameter("orderOption");
		String duplicated = request.getParameter("duplicated");
		String requestURL = (String) request.getAttribute(HandlerMapping.PATH_WITHIN_HANDLER_MAPPING_ATTRIBUTE);
		String userId = userInfo.getId();
		String offsetMin = commonUtil.getMinuteUTC(userInfo.getOffset());
		Locale locale = userInfo.getLocale();
		
		LOGGER.debug("searchUserName = " + searchUserName + " || searchDeptName = " + searchDeptName + " || searchTitle = " + searchTitle + " || searchDeptId = " + searchDeptId
				+ " || searchStartDate = " + searchStartDate + " || searchEndDate = " + searchEndDate + " || searchAttitudeType = " + searchAttitudeType
				+ " || pageNum = " + pageNum + " || listSize = " + listSize + " || orderCell = " + orderCell + "orderOption = " + orderOption);
		
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		String url = "";
		
		if (requestURL.indexOf("excelAttitudeListExport.do") > -1) {
//			근태조회엑셀
			url = gwServerUrl + "/rest/ezattitude/attitudes/bombom";
		} else if (requestURL.indexOf("excelAbsentedListExport.do") > -1) {
//			미입력자엑셀
			url = gwServerUrl + "/rest/ezattitude/attitudes/absent";
		}
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("companyId", companyId)
				.queryParam("searchUserName", searchUserName)
				.queryParam("searchDeptName", searchDeptName)
				.queryParam("searchTitle", searchTitle)
				.queryParam("searchDeptId", searchDeptId)
				.queryParam("searchStartDate", searchStartDate)
				.queryParam("searchEndDate", searchEndDate)
				.queryParam("searchAttitudeType", searchAttitudeType)
				.queryParam("userId", userId)
				.queryParam("pageNum", pageNum)
				.queryParam("listSize", listSize)
				.queryParam("orderCell", orderCell)
				.queryParam("orderOption", orderOption)
				.queryParam("duplicated", duplicated)
				.queryParam("offsetMin", offsetMin);
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp = new JSONParser();
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		
		String status = resultBody.get("status").toString();
		LOGGER.debug("status : " + status);
		
		JSONObject data = new JSONObject();
		List<AdminAttitudeVO> attitudeList = new ArrayList<AdminAttitudeVO>();
		Gson gson = new Gson();
		if(status.equals("ok")){
			data = (JSONObject) resultBody.get("data");
			
			attitudeList = gson.fromJson(data.get("list").toString(), new TypeToken<List<AdminAttitudeVO>>(){}.getType()) ;
		}
		
		HSSFWorkbook workbook = new HSSFWorkbook();
		HSSFSheet sheet;
		  
		HSSFCellStyle headerStyle= workbook.createCellStyle();
		headerStyle.setFillForegroundColor(HSSFColor.GREY_25_PERCENT.index);
		headerStyle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
		headerStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
		headerStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
		headerStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
		headerStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
		  
		HSSFCellStyle bodyStyle= workbook.createCellStyle();
		bodyStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
		bodyStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
		bodyStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
		bodyStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
		bodyStyle.setAlignment(HSSFCellStyle.ALIGN_LEFT);
		
		HSSFFont font = workbook.createFont();
		font.setBoldweight((short) font.BOLDWEIGHT_BOLD);
		headerStyle.setFont(font);
		
		Row row;
		      
		sheet = workbook.createSheet("report");
		row = sheet.createRow(0);
		
		String pFileName = "";
		
		if (requestURL.indexOf("excelAttitudeListExport.do") > -1) {
//			근태조회엑셀
			pFileName = EgovDateUtil.getToday("-") +"_attitudeReport.xls";
			
			//header
			row.createCell(0).setCellValue("NO");
			row.getCell(0).setCellStyle(headerStyle);
			row.createCell(1).setCellValue("이름");
			row.getCell(1).setCellStyle(headerStyle);
			row.createCell(2).setCellValue("직위");
			row.getCell(2).setCellStyle(headerStyle);
			row.createCell(3).setCellValue("부서");
			row.getCell(3).setCellStyle(headerStyle);
			row.createCell(4).setCellValue("날짜");
			row.getCell(4).setCellStyle(headerStyle);
			row.createCell(5).setCellValue("시간");
			row.getCell(5).setCellStyle(headerStyle);
			row.createCell(6).setCellValue(egovMessageSource.getMessage("ezAttitude.t13", locale));
			row.getCell(6).setCellStyle(headerStyle);
			
			//body
			for (int i = 0 ; i < attitudeList.size(); i++) { 
				AdminAttitudeVO vo = attitudeList.get(i);
				row = sheet.createRow(i + 1);
				
				row.createCell(0).setCellValue(i + 1);
				row.createCell(1).setCellValue(vo.getUserName());
				row.createCell(2).setCellValue(vo.getUserTitle());
				row.createCell(3).setCellValue(vo.getDeptName());
				
				if (vo.getEndDate() != null && !vo.getEndDate().equals("")) {
					row.createCell(4).setCellValue(vo.getStartDate() + " ~ " + vo.getEndDate());
				} else {
					row.createCell(4).setCellValue(vo.getStartDate());
				}
				
				if (vo.getEndTime() != null && !vo.getEndTime().equals("")) {
					row.createCell(5).setCellValue(vo.getStartTime() + " ~ " + vo.getEndTime());
				} else {
					row.createCell(5).setCellValue(vo.getStartTime());
				}
				
				row.createCell(6).setCellValue(vo.getTypeName());
				
				row.getCell(0).setCellStyle(bodyStyle);
				row.getCell(1).setCellStyle(bodyStyle);
				row.getCell(2).setCellStyle(bodyStyle);
				row.getCell(3).setCellStyle(bodyStyle);
				row.getCell(4).setCellStyle(bodyStyle);
				row.getCell(5).setCellStyle(bodyStyle);
				row.getCell(6).setCellStyle(bodyStyle);
			}
			
			//width 조정
			sheet.autoSizeColumn(0);
			sheet.autoSizeColumn(1);
			sheet.autoSizeColumn(2);
			sheet.autoSizeColumn(3);
			sheet.autoSizeColumn(4);
			sheet.autoSizeColumn(5);
			sheet.autoSizeColumn(6);
		} else if (requestURL.indexOf("excelAbsentedListExport.do") > -1){
//			미입력자조회엑셀
			pFileName = EgovDateUtil.getToday("-") +"_absentedReport.xls";
			
			//header
			row.createCell(0).setCellValue("NO");
			row.getCell(0).setCellStyle(headerStyle);
			row.createCell(1).setCellValue("이름");
			row.getCell(1).setCellStyle(headerStyle);
			row.createCell(2).setCellValue("직위");
			row.getCell(2).setCellStyle(headerStyle);
			row.createCell(3).setCellValue("부서");
			row.getCell(3).setCellStyle(headerStyle);
			row.createCell(4).setCellValue("날짜");
			row.getCell(4).setCellStyle(headerStyle);
			
			//body
			for (int i = 0 ; i < attitudeList.size(); i++) { 
				AdminAttitudeVO vo = attitudeList.get(i);
				row = sheet.createRow(i + 1);
				
				row.createCell(0).setCellValue(i + 1);
				row.createCell(1).setCellValue(vo.getUserName());
				row.createCell(2).setCellValue(vo.getUserTitle());
				row.createCell(3).setCellValue(vo.getDeptName());
				row.createCell(4).setCellValue(vo.getStartDate());
				
				row.getCell(0).setCellStyle(bodyStyle);
				row.getCell(1).setCellStyle(bodyStyle);
				row.getCell(2).setCellStyle(bodyStyle);
				row.getCell(3).setCellStyle(bodyStyle);
				row.getCell(4).setCellStyle(bodyStyle);
			}
			
			//width 조정
			sheet.autoSizeColumn(0);
			sheet.autoSizeColumn(1);
			sheet.autoSizeColumn(2);
			sheet.autoSizeColumn(3);
			sheet.autoSizeColumn(4);
		}
		
		response.setHeader("Content-Disposition", "attachment; fileName=\"" + pFileName + ".xls\"");
		workbook.write(response.getOutputStream());
		
		workbook.close();
		
		LOGGER.debug("excelFileExport ended.");
	}
	
	/**
	 * 미입력자 메일발송
	 */
	@RequestMapping(value = {"/admin/ezAttitude/absentedListSendMail.do", "/ezAttitude/absentedListSendMail.do"})
	@ResponseBody
	public String absentedListSendMail(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LOGGER.debug("absentedListSendMail started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String userId = userInfo.getId();
		String offsetMin = commonUtil.getMinuteUTC(userInfo.getOffset());
		String companyId = request.getParameter("companyId");
		String searchUserName = request.getParameter("userName");
		String searchDeptName = request.getParameter("deptName");
		String searchTitle = request.getParameter("title");
		String searchStartDate = request.getParameter("startDate");
		String searchEndDate = request.getParameter("endDate");
		String searchDeptId = request.getParameter("deptId");
		String requestURL = (String) request.getAttribute(HandlerMapping.PATH_WITHIN_HANDLER_MAPPING_ATTRIBUTE);
		
		if (requestURL.indexOf("admin") == -1) {
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			Calendar cal = Calendar.getInstance();
			
			String tempDate = commonUtil.getTodayUTCTime("");
			Date firstDayofMonth = sdf.parse(tempDate);
			
			cal.setTime(firstDayofMonth);
			searchStartDate = tempDate.substring(0, 8) + "01";
			searchEndDate = tempDate.substring(0, 8) + Integer.toString(cal.getActualMaximum(Calendar.DAY_OF_MONTH));
		}
		
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		String url = gwServerUrl + "/rest/ezattitude/attitudes/mail";
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("companyId", companyId)
				.queryParam("searchUserName", searchUserName)
				.queryParam("searchDeptName", searchDeptName)
				.queryParam("searchTitle", searchTitle)
				.queryParam("searchStartDate", searchStartDate)
				.queryParam("searchEndDate", searchEndDate)
				.queryParam("searchDeptId", searchDeptId)
				.queryParam("userId", userId)
				.queryParam("offsetMin", offsetMin)
				.queryParam("loginCookie", loginCookie);
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp = new JSONParser();
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		
		String status = resultBody.get("status").toString();
		LOGGER.debug("status : " + status);
		LOGGER.debug("absentedListSendMail ended.");
		
		return status;
	}
	
	/**
	 * 관리자 근태권한관리 화면 호출 함수
	 * @param loginCookie
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/admin/ezAttitude/attitudeAuthorManage.do")
	public String attitudeAuthorManage(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
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
		JSONObject data = new JSONObject();
		String adminCompany = "";
		if (status.equals("ok")) {
		
			data = (JSONObject) resultBody.get("data");
			list = (JSONArray) data.get("list");
			adminCompany = (String) data.get("adminCompany");
			
			model.addAttribute("list", list);
			model.addAttribute("adminCompany", adminCompany);
		}
		
		LOGGER.debug("attitudeTypeConfig ended.");
		
		return "/admin/ezAttitude/attitudeAuthorManage";
	}
	
	/**
	 * 관리자 근태권한관리 리스트 조회하는 함수
	 * @param loginCookie
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/admin/ezAttitude/attitudeAuthList.do")
	@ResponseBody
	public JSONArray getAttitudeAuthList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LOGGER.debug("/admin/ezAttitude/getAttitudeAuthList started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		String companyId = request.getParameter("companyId");
		
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		String url = gwServerUrl + "/rest/ezattitude/companies/" + companyId + "/attitude-auth";
		
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
		
		LOGGER.debug("status : " + status);
		
		JSONArray jArray = new JSONArray();
		
		if(status.equals("ok")){
			jArray = (JSONArray) resultBody.get("data");
			
			for (int i = 0; i < jArray.size(); i++) {				
				JSONObject jo = (JSONObject) jArray.get(i);
				String [] authDeptArr = jo.get("authDeptName").toString().split(",");
				if (authDeptArr.length > 1) {
					jo.replace("authDeptName", authDeptArr[0] + " 외 " + (authDeptArr.length - 1));
				}
				jo.put("authDeptName2", authDeptArr);
			}
		}
		
		LOGGER.debug("/admin/ezAttitude/getAttitudeAuthList ended");
		
		return jArray;
	} 
	
	/**
	 * 관리자 근태권한관리 권한삭제 함수
	 * @param loginCookie
	 * @param request
	 * @throws Exception
	 */
	@RequestMapping(value = "/admin/ezAttitude/deleteAttitudeAuth.do")
	@ResponseBody
	public String deleteAttitudeAuth(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LOGGER.debug("/admin/ezAttitude/deleteAttitudeAuth started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		String selectUserId = request.getParameter("selectUserId");
		String companyId = request.getParameter("companyId");
		
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		String url = gwServerUrl + "/rest/ezattitude/companies/" + companyId + "/attitude-auth";
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("selectUserId", selectUserId)
				.queryParam("userId", userInfo.getId());
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.DELETE, entity, String.class);
		
		JSONParser jp = new JSONParser();
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		
		String status = resultBody.get("status").toString();
		
		String resultStatus = "";
		if (status.equals("ok")) {
			resultStatus = "success";
		} else {
			resultStatus = "error";
		}	
		
		LOGGER.debug("status : " + status);
		
		LOGGER.debug("/admin/ezAttitude/deleteAttitudeAuth ended");
		
		return resultStatus;
	}
	
	/**
	 * 근태권한관리 권한추가 화면
	 * @return
	 */
	@RequestMapping(value = "/admin/ezAttitude/saveAttitudeAuth.do")
	public String saveAttitudeAuth(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception{
		String userId = request.getParameter("userId");
		String companyId = request.getParameter("companyId");
		String isAllDept = "";
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);

		if (userId != null) {
			
			model.addAttribute("selectedUser", userId);
			model.addAttribute("selectedUserName", request.getParameter("userName"));
			
			String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
			String url = gwServerUrl + "/rest/ezattitude/users/" + userId + "/attitude-auth";
			
			HttpHeaders headers = new HttpHeaders();
			headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
			headers.set("x-user-host", request.getServerName());
			
			HttpEntity<?> entity = new HttpEntity<>(headers);
			UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
					.queryParam("companyId", companyId)
					.queryParam("isAllDept", isAllDept)
					.queryParam("userId", userId);
			
			
			RestTemplate rest = new RestTemplate();
			
			ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
			
			JSONParser jp = new JSONParser();
			JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
			
			String status = resultBody.get("status").toString();
			
			JSONArray authorDeptList = new JSONArray();
			if (status.equals("ok")) {		
				authorDeptList = (JSONArray) resultBody.get("data");
				
				model.addAttribute("deptList", authorDeptList);
			}
		}
		
		model.addAttribute("companyId",request.getParameter("companyId"));

		return "/admin/ezAttitude/saveAttitudeAuth";
	}
	
	/**
	 * 근태권한관리 권한추가 권한자 지정시(조직도)
	 * @param loginCookie
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/admin/ezAttitude/selectAttitudeAuthor.do")
	public String selectAttitudeAuthor(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception{
		
		LOGGER.debug("/admin/ezAttitude/selectAttitudeAuthor started");

		String companyId = request.getParameter("companyId");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String userId = null;
		if (request.getParameter("userId") != null) {
			userId = request.getParameter("userId");
			model.addAttribute("selectedUser",userId.trim());
		}else{
			userId = userInfo.getId();
		}
		
		//조직도 회사,부서 리스트
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		String url = gwServerUrl + "/rest/ezattitude/organtree/depts";
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("companyId", companyId)
				.queryParam("userId", userInfo.getId());
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp = new JSONParser();
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		
		String status = resultBody.get("status").toString();
		LOGGER.debug("status : " + status);
				
		JSONObject jObject = new JSONObject();
		if (status.equals("ok")) {
			JSONArray deptList = (JSONArray) resultBody.get("data");
			
			for (int i = 0; i < deptList.size(); i++) {
				JSONObject dept =  (JSONObject) deptList.get(i);
				if (dept.get("isComp").equals("comp") || dept.get("isComp").equals("COMP")) {
					dept.put("icon", "icon-company");
				} else{
					dept.put("icon", "icon-dept");
				}
				
				//만약 자신의 부서가 있다면 해당 부서의 내용으로 넣는다.
				if (dept.get("myDept").equals("yes") || dept.get("myDept").equals("YES")) {
					JSONObject state = new JSONObject();
					state.put("opened", "true");
					state.put("selected", "true");
					dept.put("state", state);
				}
			}
			model.addAttribute("deptList", deptList);
			model.addAttribute("companyId", companyId);
		}
		
		LOGGER.debug("/admin/ezAttitude/selectAttitudeAuthor ended");
		
		return "/admin/ezAttitude/selectAttitudeAuthor";
	}
	
	/**
	 * 관리자 근태권한관리 권한부서 선택하기 (부서리스트)
	 * @throws Exception 
	 */
	@RequestMapping(value = "/admin/ezAttitude/selectAttitudeAuthorDept.do")
	public String selectAttitudeAuthorDept(HttpServletRequest request, Model model,@CookieValue("loginCookie") String loginCookie, HttpServletResponse response) throws Exception{
		LOGGER.debug("selectAttitudeAuthorDept started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String companyId = request.getParameter("companyId");
		String userId =null;
		if (request.getParameter("userId")!=null) {
			userId = request.getParameter("userId");
			model.addAttribute("selectedUser",userId.trim());
		}else{
			userId = userInfo.getId();
		}
		
		//조직도 회사,부서 리스트
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		String url = gwServerUrl + "/rest/ezattitude/organtree/depts";
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("companyId", companyId)
				.queryParam("userId", userInfo.getId());
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp = new JSONParser();
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		
		String status = resultBody.get("status").toString();
		LOGGER.debug("status : " + status);
		
		
		JSONObject jObject = new JSONObject();
		if (status.equals("ok")) {
			JSONArray deptList = (JSONArray) resultBody.get("data");
			
			for (int i = 0; i < deptList.size(); i++) {
				JSONObject dept =  (JSONObject) deptList.get(i);
				if (dept.get("isComp").equals("comp") || dept.get("isComp").equals("COMP")) {
					dept.put("icon", "icon-company");
				} else{
					dept.put("icon", "icon-dept");
				}
				
				//만약 자신의 부서가 있다면 해당 부서의 내용으로 넣는다.
				if (dept.get("myDept").equals("yes") || dept.get("myDept").equals("YES")) {
					JSONObject state = new JSONObject();
					state.put("opened", "true");
					state.put("selected", "true");
					dept.put("state", state);
				}
			}
			model.addAttribute("deptList", deptList);
		}
		
		LOGGER.debug("selectAttitudeAuthorDept ended");
		
		return "/admin/ezAttitude/selectAttitudeAuthorDept";
	}
	
	/**
	 * 해당사원이 열람 할 수 있는 부서 리스트
	 * @throws Exception 
	 */
	@RequestMapping(value = "/admin/ezAttitude/attitudeAuthorDeptList.do")
	@ResponseBody
	public JSONArray attitudeAuthorDeptList(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie) throws Exception{
		LOGGER.debug("attitudeAuthorDeptList started");
		String userId = request.getParameter("userId");
		String companyId = request.getParameter("companyId");
		String isAllDept = "";
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		String url = gwServerUrl + "/rest/ezattitude/users/" + userId + "/attitude-auth";
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("companyId", companyId)
				.queryParam("isAllDept", isAllDept)
				.queryParam("userId", userId);
		
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp = new JSONParser();
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		
		String status = resultBody.get("status").toString();
		
		JSONArray authorDeptList = new JSONArray();
		if (status.equals("ok")) {		
			authorDeptList = (JSONArray) resultBody.get("data");
		}
		
		LOGGER.debug("attitudeAuthorDeptList ended");
		return authorDeptList;
	}
	
	/**
	 * 권한 저장
	 * @param request
	 * @param model
	 * @param loginCookie
	 * @param response
	 * @throws IOException 
	 * @throws Exception 
	 */
	@RequestMapping(value = "/admin/ezAttitude/saveAttitudeAuthor.do")
	@ResponseBody
	public String saveAttitudeAuthor(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, HttpServletResponse response) throws IOException, Exception{
		LOGGER.debug("saveAttitudeAuthor started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		String selectedUser = request.getParameter("selectedUser");
		String companyId = request.getParameter("companyId");
		String deptIds = request.getParameter("deptIds");
		String authTypes = request.getParameter("authTypes");
		
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		String url = gwServerUrl + "/rest/ezattitude/companies/" + companyId + "/attitude-auth";
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("selectedUser", selectedUser)
				.queryParam("deptIds", deptIds)
				.queryParam("authTypes", authTypes)
				.queryParam("userId", userInfo.getId());
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.POST, entity, String.class);
		
		JSONParser jp = new JSONParser();
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		
		String status = resultBody.get("status").toString();
		
		String resultStatus = "";
		if (status.equals("ok")) {
			resultStatus = "success";
		} else {
			resultStatus = "error";
		}
		
		LOGGER.debug("status : " + status);
		
		LOGGER.debug("saveAttitudeAuthor ended");
		
		return resultStatus;
	}
	
	/**
	 * 근태수정관리 근태관리 화면 출력 함수
	 */
	@RequestMapping(value = "/ezAttitude/attitudeHistory.do")
	public String attitudeHistory(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		LOGGER.debug("/ezAttitude/attitudeHistory.do");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String offset = userInfo.getOffset();
		String adminCompany = userInfo.getCompanyID();
		String adminFlag = "false";
		String isAllDept = "";
		
		if (userInfo.getRollInfo().indexOf("c=1") == -1 && userInfo.getRollInfo().indexOf("k=1") == -1) {
			return "cmm/error/adminDenied";
		}

		//전체관리자(c), 회사관리자(k), 부서관리자(g), 근태관리자(wa) 면 모든부서..
		if ( userInfo.getRollInfo().indexOf("c=1") != -1 ||userInfo.getRollInfo().indexOf("k=1") != -1 || userInfo.getRollInfo().indexOf("wa=1") != -1) {
			adminFlag = "true";
			isAllDept = "Y";
		} else if (userInfo.getRollInfo().indexOf("g=1") != -1) {
			adminFlag = "true";
		}
		
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		String url = gwServerUrl + "/rest/ezattitude/users/" + userInfo.getId() + "/attitude-auth";
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("companyId", userInfo.getCompanyID())
				.queryParam("isAllDept", isAllDept)
				.queryParam("userId", userInfo.getId());
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp = new JSONParser();
		
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		
		String status = resultBody.get("status").toString();
		
		JSONArray deptList = new JSONArray();
		
		if(status.equals("ok")){
			deptList = (JSONArray) resultBody.get("data");
		}
		
		if (deptList.size() > 1) {
			adminFlag = "true";
		}
		
		if (adminFlag.equals("false")) {
			return "cmm/error/accessDenied";
		}
		
		int myDeptCount = 0;
		JSONObject dept = new JSONObject();
		
		for(int i = 0; i < deptList.size(); i++) {
			dept = (JSONObject) deptList.get(i);
			if (dept.get("deptId").equals(userInfo.getDeptID())) {
				myDeptCount++;
			}
		}
		
		if (myDeptCount == 1) {
			for(int i = 0; i < deptList.size(); i++) {
				dept = (JSONObject) deptList.get(i);
				if (dept.get("deptId").equals(userInfo.getDeptID())) {
					dept.put("mine", "no");
				}
			}
		}
		model.addAttribute("deptList", deptList);
		model.addAttribute("selectedDept", userInfo.getDeptID());
		
		String localDate = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), offset, false).substring(0, 10);
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Calendar cal = Calendar.getInstance();
		
		String searchStartDate = localDate + " 00:00:00";
		String searchEndDate = localDate + " 23:59:59";
		
		Date startDate = sdf.parse(searchStartDate);
		
		cal = Calendar.getInstance();
		cal.setTime(startDate);
		cal.add(Calendar.DAY_OF_MONTH, -7);
		
		searchStartDate = commonUtil.getDateStringInUTC(sdf.format(cal.getTime()), offset, true);
		searchEndDate = commonUtil.getDateStringInUTC(searchEndDate, offset, true);
		
		model.addAttribute("adminCompany", adminCompany);
		model.addAttribute("searchStartDate", searchStartDate.substring(0, 10));
		model.addAttribute("searchEndDate", searchEndDate.substring(0, 10));
		
		LOGGER.debug("/ezAttitude/attitudeHistory.do");
		
		return "/ezAttitude/attitudeHistory";
	}
	
	/**
	 * 관리내역 리스트 가져오는 함수
	 * @return 
	 */
	@RequestMapping(value = {"/admin/ezAttitude/attitudeHistoryList.do", "/ezAttitude/attitudeHistoryList.do"})
	@ResponseBody
	public JSONObject attitudeHistoryList(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		LOGGER.debug("/ezAttitude/attitudeHistoryList.do");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		String companyId = request.getParameter("companyId");
		String searchUserName = request.getParameter("userName");
		String searchDeptName = request.getParameter("deptName");
		String deptId = request.getParameter("deptId");
		String searchTitle = request.getParameter("title");
		String searchStartDate = request.getParameter("startDate");
		String searchEndDate = request.getParameter("endDate");
		String pageNum = request.getParameter("pageNum");
		String listSize = request.getParameter("listSize");
		String orderCell = request.getParameter("orderCell");
		String orderOption = request.getParameter("orderOption");
		String userId = userInfo.getId();
		String offsetMin = commonUtil.getMinuteUTC(userInfo.getOffset());
		String requestURL = (String) request.getAttribute(HandlerMapping.PATH_WITHIN_HANDLER_MAPPING_ATTRIBUTE);
		String isAdmin = "";
		
		if (requestURL.indexOf("/admin/ezAttitude/attitudeHistoryList.do") > -1) {
			isAdmin = "Y";
		}
		
		LOGGER.debug("searchUserName = " + searchUserName + " || searchDeptName = " + searchDeptName + " || searchTitle = " + searchTitle + " || searchStartDate = " + searchStartDate
				+ " || searchEndDate = " + searchEndDate + " || pageNum = " + pageNum + " || listSize = " + listSize
				+ " || orderCell = " + orderCell + "orderOption = " + orderOption + "||deptId =" + deptId);
		
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		String url = gwServerUrl + "/rest/ezattitude/attitudes/manageHistories";
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("companyId", companyId)
				.queryParam("searchUserName", searchUserName)
				.queryParam("searchDeptName", searchDeptName)
				.queryParam("searchDeptId", deptId)
				.queryParam("searchTitle", searchTitle)
				.queryParam("searchStartDate", searchStartDate)
				.queryParam("searchEndDate", searchEndDate)
				.queryParam("userId", userId)
				.queryParam("pageNum", pageNum)
				.queryParam("listSize", listSize)
				.queryParam("orderCell", orderCell)
				.queryParam("orderOption", orderOption)
				.queryParam("offsetMin", offsetMin)
				.queryParam("isAdmin", isAdmin);
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp = new JSONParser();
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		
		String status = resultBody.get("status").toString();
		LOGGER.debug("status : " + status);
		
		JSONObject data = new JSONObject();
		if(status.equals("ok")){
			data = (JSONObject) resultBody.get("data");
		}
		
		LOGGER.debug("/ezAttitude/attitudeHistoryList.do");
		
		return data;
	}
	
	@RequestMapping(value = "/ezAttitude/getTotalAttCount.do")
	@ResponseBody
	public String getTotalAttCount(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String isAllDept = "";
		String offset = userInfo.getOffset();
		String offsetMin = commonUtil.getMinuteUTC(offset);			
		String sysLang = ezCommonService.getTenantConfig("PrimaryLang", userInfo.getTenantId());

		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		String url = gwServerUrl + "/rest/ezattitude/users/"+ userInfo.getId() +"/modifyattitudes/count";
		
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("companyId", userInfo.getCompanyID())
				.queryParam("tenantId", userInfo.getTenantId())
				.queryParam("apprUserName", "")
				.queryParam("writerName", "")
				.queryParam("writerDeptName", "")
				.queryParam("startDate", "")
				.queryParam("endDate", "")
				.queryParam("sysLang", sysLang)
				.queryParam("offset", offsetMin)
				.queryParam("pageNum", "")
				.queryParam("type", "0")
				.queryParam("adminFlag", "true")
				.queryParam("deptid", "ALL")
				.queryParam("isAllDept", isAllDept);
		
		RestTemplate rest = new RestTemplate();

		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);

		JSONParser jp = new JSONParser();
		
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		
		String status = resultBody.get("status").toString();
		
		String totalAtt = "";
		
		if (status.equals("ok")) {
			totalAtt = resultBody.get("data").toString();
		}
		
		return totalAtt;
	}
	
	
}
