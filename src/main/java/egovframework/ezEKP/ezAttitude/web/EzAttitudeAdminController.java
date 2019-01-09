package egovframework.ezEKP.ezAttitude.web;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.InputStreamResource;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.http.client.SimpleClientHttpRequestFactory;
import org.springframework.http.converter.HttpMessageConverter;
import org.springframework.http.converter.ResourceHttpMessageConverter;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.HandlerMapping;
import org.springframework.web.util.UriComponentsBuilder;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.ibm.icu.text.SimpleDateFormat;
import com.ibm.icu.util.Calendar;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezAttitude.util.ExcelCellRef;
import egovframework.ezEKP.ezAttitude.vo.AdminAttitudeVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeAnnualVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeConfigVO;
import egovframework.ezEKP.ezAttitude.vo.ModApplHistoryVO;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.let.user.login.vo.LoginSimpleVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

/**
 * @author kaoni_dev1
 *
 */
@Controller
public class EzAttitudeAdminController {
	private static final Logger LOGGER = LoggerFactory.getLogger(EzAttitudeController.class);

	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;

	@Resource(name = "crypto")
	private EgovFileScrty egovFileScrty;

	@Resource(name = "EzCommonService")
	private EzCommonService ezCommonService;
	
	@Resource(name = "egovMessageSource")
	private EgovMessageSource egovMessageSource;

	/**
	 * 관리자 근태관리 메인화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezAttitude/attitudeMain.do")
	public String attitudeMain(@CookieValue("loginCookie") String loginCookie,
			LoginVO userInfo) {
		LOGGER.debug("attitudeMain started");

		userInfo = commonUtil.checkAdmin(loginCookie);

		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}

		LOGGER.debug("attitudeMain ended");
		return "/admin/ezAttitude/attitudeMain";
	}

	/**
	 * 관리자 근태관리 좌측 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezAttitude/attitudeLeft.do")
	public String attitudeLeft() {
		return "/admin/ezAttitude/attitudeLeft";
	}

	/**
	 * 관리자 근태관리 우측 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezAttitude/attitudeRight.do")
	public String attitudeRight() {
		return "/admin/ezAttitude/attitudeRight";
	}

	/**
	 * 근태 수정 신청 현황
	 */
	@RequestMapping(value="/admin/ezAttitude/manageAttModAppList.do")
	public String adminGetAttModAppList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model,
			@RequestParam(required=false)String pageNum,
			@RequestParam(required=false)String apprUserName,
			@RequestParam(required=false)String startDate,
			@RequestParam(required=false)String endDate) throws Exception {
		LOGGER.debug("adminAttModAppList started");

		int totalAtt = 0;
		int currentPage = 1;
		int totalPages = 0;
		String adminFlag = "true";
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		LoginVO auth = commonUtil.checkAdmin(loginCookie);
        
        boolean checkAdmin = auth == null ? false : true;
		
        if (!checkAdmin) {
        	return "cmm/error/adminDenied";
        }
        
		String offset = userInfo.getOffset();
		String offsetMin = commonUtil.getMinuteUTC(offset);
		
		
		if (startDate == null || endDate == null) {

			String localDate = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), offset, false).substring(0, 10);
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			Calendar cal = Calendar.getInstance();
			
			
			cal = Calendar.getInstance();
			cal.setTime(sdf.parse(localDate));
			cal.add(Calendar.DAY_OF_MONTH, -7);
			
			startDate = sdf.format(cal.getTime());
			endDate = localDate;
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
		
		JSONArray list = new JSONArray();
		JSONObject data = new JSONObject();

		if (status.equals("ok")) {
			data = (JSONObject) resultBody.get("data");
			list = (JSONArray) data.get("list");
			String adminCompany = (String) data.get("adminCompany");
			
			model.addAttribute("list", list);
			model.addAttribute("adminCompany", adminCompany);
		}
		
		model.addAttribute("userLang", userInfo.getLang());
		model.addAttribute("userTimeSet", offset);
		model.addAttribute("offsetMin", offsetMin);
		model.addAttribute("totalAtt", totalAtt);
		model.addAttribute("currentPage", currentPage);
		model.addAttribute("totalPages", totalPages);
		model.addAttribute("adminFlag", adminFlag);
		model.addAttribute("checkAdmin", checkAdmin);
		model.addAttribute("startDate", startDate);
		model.addAttribute("endDate", endDate);
		
		LOGGER.debug("attModAppList ended");
		
		return "/admin/ezAttitude/attModAppList";
	}
	
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
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String workStartTime = request.getParameter("workStartTime");
		String workEndTime = request.getParameter("workEndTime");
		String closedDay = request.getParameter("closedDay");
		String attitudeModAppl = request.getParameter("attitudeModAppl");
		String closedDateAttitude = request.getParameter("closedDateAttitude");
		
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
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String typeConfigList = request.getParameter("typeList");

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
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String companyId = request.getParameter("companyId");
		
		if (userInfo.getRollInfo().indexOf("c=1") == -1 && userInfo.getRollInfo().indexOf("k=1") == -1) {
			return "cmm/error/adminDenied";
		}
		
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
				
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String attitudetypeId = request.getParameter("typeId");
		String companyId = request.getParameter("companyId");
		
		if (userInfo.getRollInfo().indexOf("c=1") == -1 && userInfo.getRollInfo().indexOf("k=1") == -1) {
			return "cmm/error/adminDenied";
		}
		
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
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String selectedUserIdList = request.getParameter("selectedUserIdList");
		String companyId = request.getParameter("companyId");
		
		if (userInfo.getRollInfo().indexOf("c=1") == -1 && userInfo.getRollInfo().indexOf("k=1") == -1) {
			return "cmm/error/adminDenied";
		}
		
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
			
			//근태유형
			url = gwServerUrl + "/rest/ezattitude/companies/" + userInfo.getCompanyID() + "/attitudetypes";
			
			builder = UriComponentsBuilder.fromHttpUrl(url)
					.queryParam("userId", userInfo.getId())
					.queryParam("isuse", "1");
			
			result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
			
			resultBody = (JSONObject) jp.parse(result.getBody());
			
			status = resultBody.get("status").toString();
			
			JSONArray typeList = new JSONArray();
			
			if(status.equals("ok")){
				typeList = (JSONArray) resultBody.get("data");
			}
			
			model.addAttribute("typeList", typeList);
			
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
		String url = gwServerUrl + "/rest/ezattitude/attitudes/check";
		
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
	 */
	@RequestMapping(value = "/admin/ezAttitude/saveAttitudeAuth.do")
	public String saveAttitudeAuth(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception{
		LOGGER.debug("saveAttitudeAuth started.");
		
		String userId = request.getParameter("userId");
		String userName = request.getParameter("userName");
		String companyId = request.getParameter("companyId");
		String isAllDept = "";
		
		if (userId != null) {
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
			
			model.addAttribute("selectedUser", userId);
			model.addAttribute("selectedUserName", userName);
		}
		
		model.addAttribute("companyId", companyId);
		
		LOGGER.debug("saveAttitudeAuth ended.");

		return "/admin/ezAttitude/saveAttitudeAuth";
	}
	
	/**
	 * 근태권한관리 권한추가 권한자 지정시(조직도)
	 */
	@RequestMapping(value = "/admin/ezAttitude/selectAttitudeAuthor.do")
	public String selectAttitudeAuthor(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception{
		LOGGER.debug("/admin/ezAttitude/selectAttitudeAuthor started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String companyId = request.getParameter("companyId");
		
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
				if (dept.get("isComp").equals("COMP")) {
					dept.put("icon", "icon-company");
				} else{
					dept.put("icon", "icon-dept");
				}
				
				//만약 자신의 부서가 있다면 해당 부서의 내용으로 넣는다.
				if (dept.get("myDept").equals("YES")) {
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
	 */
	@RequestMapping(value = "/admin/ezAttitude/selectAttitudeAuthorDept.do")
	public String selectAttitudeAuthorDept(HttpServletRequest request, Model model,@CookieValue("loginCookie") String loginCookie, HttpServletResponse response) throws Exception {
		LOGGER.debug("selectAttitudeAuthorDept started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String companyId = request.getParameter("companyId");
		
		String userId = null;
		if (request.getParameter("userId") != null) {
			userId = request.getParameter("userId");
			model.addAttribute("selectedUser",userId.trim());
		} else {
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
				.queryParam("userId", userId);
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp = new JSONParser();
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		
		String status = resultBody.get("status").toString();
		LOGGER.debug("status : " + status);
		
		if (status.equals("ok")) {
			JSONArray deptList = (JSONArray) resultBody.get("data");
			
			for (int i = 0; i < deptList.size(); i++) {
				JSONObject dept =  (JSONObject) deptList.get(i);
				if (dept.get("isComp").equals("COMP")) {
					dept.put("icon", "icon-company");
				} else{
					dept.put("icon", "icon-dept");
				}
				
				//만약 자신의 부서가 있다면 해당 부서의 내용으로 넣는다.
				if (dept.get("myDept").equals("YES")) {
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
	 */
	@RequestMapping(value = "/admin/ezAttitude/attitudeAuthorDeptList.do")
	@ResponseBody
	public JSONArray attitudeAuthorDeptList(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie) throws Exception {
		LOGGER.debug("attitudeAuthorDeptList started");
		
		String userId = request.getParameter("userId");
		String companyId = request.getParameter("companyId");
		String isAllDept = "";
		
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
	 */
	@RequestMapping(value = "/admin/ezAttitude/saveAttitudeAuthor.do")
	@ResponseBody
	public String saveAttitudeAuthor(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, HttpServletResponse response) throws IOException, Exception {
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
		LOGGER.debug("getTotalAttCount started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String isAllDept = "";
		String offset = userInfo.getOffset();
		String offsetMin = commonUtil.getMinuteUTC(offset);			
		String sysLang = ezCommonService.getTenantConfig("PrimaryLang", userInfo.getTenantId());

		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		String url = gwServerUrl + "/rest/ezattitude/users/" + userInfo.getId() + "/modifyattitudes/count";
		
		
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
		
		LOGGER.debug("getTotalAttCount ended.");
		
		return totalAtt;
	}
	
	/**
	 * 근무시간관리 부서근무시간수정 화면
	 */
	@RequestMapping(value = "/admin/ezAttitude/editAttitudeDeptConf.do")
	public String editAttitudeDeptConf(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception{
		LOGGER.debug("/admin/ezAttitude/editAttitudeDeptConf started");
		

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String companyId = request.getParameter("companyId");
		
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
				if (dept.get("isComp").equals("COMP")) {
					dept.put("icon", "icon-company");
				} else{
					dept.put("icon", "icon-dept");
				}
				
				//만약 자신의 부서가 있다면 해당 부서의 내용으로 넣는다.
				if (dept.get("myDept").equals("YES")) {
					JSONObject state = new JSONObject();
					state.put("opened", "true");
					state.put("selected", "true");
					dept.put("state", state);
				}
			}
			
			model.addAttribute("deptList", deptList);
			model.addAttribute("companyId", companyId);
		}
		//회사 시작/종료시간
		url = gwServerUrl + "/rest/ezattitude/companies/" + companyId + "/attitudereg";
		
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("userId", userInfo.getId())
				.queryParam("companyId", companyId);
		
		result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		resultBody = (JSONObject) jp.parse(result.getBody());
		
		status = resultBody.get("status").toString();
		
		if(status.equals("ok")){
			jObject = (JSONObject) resultBody.get("data");
			
			model.addAttribute("companyStartTime", jObject.get("workStartTime"));
			model.addAttribute("companyEndTime", jObject.get("workEndTime"));
		}
		
		LOGGER.debug("/admin/ezAttitude/editAttitudeDeptConf ended");
		
		return "/admin/ezAttitude/editAttitudeDeptConf";
	}

	/**
	 * 근무시간관리 부서근무시간 수정
	 */
	@RequestMapping(value = "/admin/ezAttitude/editAttitudeDeptConfig.do")
	@ResponseBody
	public String editAttitudeDeptConfig(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie) throws Exception {
		LOGGER.debug("editAttitudeDeptConfig started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String companyId = request.getParameter("companyId");
		String selectDeptIds = request.getParameter("selectDeptIds");
		String workStartTime = request.getParameter("workStartTime");
		String workEndTime = request.getParameter("workEndTime");
		String gubun = request.getParameter("gubun");
		
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		String url = gwServerUrl + "/rest/users/ezattitude/dept-attitude-confs";
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("companyId", companyId)
				.queryParam("userId", userInfo.getId())
				.queryParam("selectDeptIds", selectDeptIds)
				.queryParam("workStartTime", workStartTime)
				.queryParam("workEndTime", workEndTime)
				.queryParam("gubun", gubun);
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.POST, entity, String.class);
		
		JSONParser jp = new JSONParser();
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		
		String status = resultBody.get("status").toString();
		LOGGER.debug("status : " + status);
		LOGGER.debug("editAttitudeDeptConfig ended");
		
		return status;
	}
	
	/**
	 * 근태 수정 신청 상세
	 */
	@RequestMapping(value="/admin/ezAttitude/attModAppDetail.do")
	public String attModAppDetail(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model,
			@RequestParam(required=true)String attModId,
			@RequestParam(required=false)String companyId,
			@RequestParam(required=false)String applCnt,
			@RequestParam(required=false)String adminFlag,
			@RequestParam(required=false)String pageInfo) throws Exception {
		LOGGER.debug("attModAppDetail started");
		
		String attModDeptId = "";
		String authFlag = "";
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String sysLang = ezCommonService.getTenantConfig("PrimaryLang", userInfo.getTenantId());
		String font = ezCommonService.getTenantConfig("editorFontStyle", userInfo.getTenantId());
		
		if (userInfo.getLang().equals(sysLang))  {
			sysLang = "primary";
		}
		if (companyId == null || companyId.equals("")) {
			companyId = userInfo.getCompanyID();
		}
		
		String deptFlag = "";
		String offset = userInfo.getOffset();
		String offsetMin = commonUtil.getMinuteUTC(offset);
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		String url = gwServerUrl + "/rest/ezattitude/modifyattitude/" + attModId;
									
		if (adminFlag != null) {
			deptFlag = adminFlag;
		}
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("companyId", companyId)
				.queryParam("tenantId", userInfo.getTenantId())
				.queryParam("userId", userInfo.getId())
				.queryParam("sysLang", sysLang)
				.queryParam("applCnt", applCnt)
				.queryParam("offset", offsetMin);
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp = new JSONParser();
		
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		
		String status = resultBody.get("status").toString();
		
		JSONObject data = new JSONObject();
		
		if(status.equals("ok")){
			data = (JSONObject) resultBody.get("data");			
			attModDeptId = (String) data.get("writerDeptId");
			model.addAttribute("data", data);
			
			url = gwServerUrl + "/rest/ezattitude/companies/" + companyId + "/attitudereg";
			
			builder = UriComponentsBuilder.fromHttpUrl(url)
					.queryParam("userId", userInfo.getId());
			
			result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
			
			resultBody = (JSONObject) jp.parse(result.getBody());
			
			status = resultBody.get("status").toString();
			LOGGER.debug("status : " + status);
			
			JSONObject attitudeConfigVO = new JSONObject();
			if (status.equals("ok")) {
				attitudeConfigVO = (JSONObject) resultBody.get("data");
				model.addAttribute("attitudeConfigVO", attitudeConfigVO);
			}
		}		

		
		model.addAttribute("userLang", userInfo.getLang());
		model.addAttribute("userTimeSet", offset);
		model.addAttribute("offsetMin", offsetMin);
		model.addAttribute("adminFlag", adminFlag);
		model.addAttribute("userId", userInfo.getId());
		model.addAttribute("font", font);
		model.addAttribute("authFlag", authFlag);
		model.addAttribute("deptFlag", deptFlag);
		model.addAttribute("pageInfo", pageInfo);
		model.addAttribute("companyId", companyId);
		
		LOGGER.debug("attModAppDetail ended");
		
		return "/admin/ezAttitude/attModAppDetail";
	}
	
	/**
	 * 관리자 근태권한관리 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezAttitude/attitudeAnnualManage.do")
	public String attitudeAnnualManage(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		LOGGER.debug("attitudeAnnualManage started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		if (userInfo.getRollInfo().indexOf("c=1") == -1 && userInfo.getRollInfo().indexOf("k=1") == -1) {
			return "cmm/error/adminDenied";
		}
		
		//회사 리스트
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
		
		LOGGER.debug("attitudeAnnualManage ended.");
		
		return "/admin/ezAttitude/attitudeAnnualManage";
	}
	
	/**
	 * 연차현황관리 전체연차변경 화면
	 */
	@RequestMapping(value = "/admin/ezAttitude/modifyAllAnnualPop.do")
	public String modifyAllAnnualPop(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception{
		LOGGER.debug("modifyAllAnnualPop started.");
		
		String userId = request.getParameter("userId");
		String userName = request.getParameter("userName");
		String companyId = request.getParameter("companyId");
		String isAllDept = "";
		
		if (userId != null) {
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
			
			model.addAttribute("selectedUser", userId);
			model.addAttribute("selectedUserName", userName);
		}
		
		model.addAttribute("companyId", companyId);
		
		LOGGER.debug("modifyAllAnnualPop ended.");

		return "/admin/ezAttitude/modifyAllAnnualPop";
	}
	
	/**
	 * 관리자 연차현황관리 조회
	 * 연차현황관리 개인연차변경 화면
	 */
	@RequestMapping(value = "/admin/ezAttitude/modifyPrsnAnnualPop.do")
	public String modifyPrsnAnnualPop(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception{
		LOGGER.debug("modifyPrsnAnnualPop started.");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String userId = request.getParameter("userId");
		String companyId = request.getParameter("companyId");
		String year = request.getParameter("year");
		String offsetMin = commonUtil.getMinuteUTC(userInfo.getOffset());
		
		if (userId != null) {
			String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
			String url = gwServerUrl + "/rest/ezattitude/users/" + userId + "/modifyPrsnAnnualPop/";
			
			HttpHeaders headers = new HttpHeaders();
			headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
			headers.set("x-user-host", request.getServerName());
			
			HttpEntity<?> entity = new HttpEntity<>(headers);
			UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
					.queryParam("companyId", companyId)
					.queryParam("userId", userId)
					.queryParam("year", year)
					.queryParam("offsetMin", offsetMin);
			
			RestTemplate rest = new RestTemplate();
			
			ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
			
			JSONParser jp = new JSONParser();
			JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
			
			String status = resultBody.get("status").toString();
			
			JSONObject vo = new JSONObject();
			if (status.equals("ok")) {		
				vo = (JSONObject) resultBody.get("data");
				
				model.addAttribute("vo", vo);
			}
			
		}
		
		LOGGER.debug("modifyPrsnAnnualPop ended.");
		
		return "/admin/ezAttitude/modifyPrsnAnnualPop";
	}
	
	/**
	 * 연차현황관리 엑셀업로드팝업
	 */
	@RequestMapping(value = "/admin/ezAttitude/annualExcelUploadPop.do")
	public String annualExcelUploadPop(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception{
		model.addAttribute("companyId", request.getParameter("companyId"));
		return "/admin/ezAttitude/annualExcelUploadPop";
	}
	
	/**
	 * 연차현황관리 엑셀업로드
	 */
	@RequestMapping(value = "/admin/ezAttitude/annualExcelUpload.do", produces = "application/json;charset=utf-8")
	@ResponseBody
	public JSONObject annualExcelUpload(@CookieValue("loginCookie") String loginCookie, MultipartHttpServletRequest request, Model model) throws Exception{
		
		LOGGER.debug("annualExcelUpload started.");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String companyId = request.getParameter("companyId");
		String changeReason = request.getParameter("changeReason");
		String flagCheck = request.getParameter("flagCheck");
		
		Map<String, MultipartFile> files = request.getFileMap();
		MultipartFile tempFile =  files.get("excelFile");
		
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		String url = "";
		url = gwServerUrl + "/rest/ezattitude/annualExcelUpload";
		
		SimpleClientHttpRequestFactory requestFactory = new SimpleClientHttpRequestFactory();
		requestFactory.setBufferRequestBody(false);
		
		RestTemplate restTemplate                       = new RestTemplate(requestFactory);
		List<HttpMessageConverter<?>> messageConverters = restTemplate.getMessageConverters();
		
		for (int i = 0; i < messageConverters.size(); i++) {
			HttpMessageConverter<?> messageConverter = messageConverters.get(i);
			
			if (messageConverter.getClass().equals(ResourceHttpMessageConverter.class)) {
				messageConverters.set(i, new BnkResourceHttpMessageConverter());
			}
		}
		
		MultiValueMap<String, Object> map = new LinkedMultiValueMap<String, Object>();
		JSONObject jsonObject             = new JSONObject();
		
		map.add("files", new MultipartFileResource(tempFile.getInputStream(), tempFile.getOriginalFilename()));
		
		jsonObject.put("changeUserId", userInfo.getId());
		jsonObject.put("companyId", companyId);
		jsonObject.put("changeReason", changeReason);
		jsonObject.put("flagCheck", flagCheck);
		
		map.add("data", jsonObject);
		
		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.MULTIPART_FORM_DATA);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<MultiValueMap<String, Object>> entity = new HttpEntity<MultiValueMap<String, Object>>(map, headers);
		UriComponentsBuilder builder                     = UriComponentsBuilder.fromHttpUrl(url);
		ResponseEntity<String> result                    = restTemplate.exchange(builder.build().encode().toUri(), HttpMethod.POST, entity, String.class);
		
		JSONParser jp         = new JSONParser();
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		
		String status = resultBody.get("status").toString();
		String resultStatus = "";
		
		if (status.equals("ok")) {
			resultStatus = "success";
		} else if (status.equals("failed")) {
			resultStatus = "failed";
		} else {
			resultStatus = "error";
		}
		
		LOGGER.debug("annualExcelUpload ended.");
		
		return resultBody;
	}
	
	/**
	 * 연차현황관리 개인연차변경 화면
	 */
	@RequestMapping(value = "/admin/ezAttitude/annualHistoryPop.do")
	public String annualHistoryPop(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception{
		LOGGER.debug("annualHistoryPop started.");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String userId = request.getParameter("userId");
		String companyId = request.getParameter("companyId");
		String year = request.getParameter("year");
		
		if (userId != null) {
			String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
			String url = gwServerUrl + "/rest/ezattitude/users/" + userId + "/annualHistoryPop/";
			
			HttpHeaders headers = new HttpHeaders();
			headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
			headers.set("x-user-host", request.getServerName());
			
			HttpEntity<?> entity = new HttpEntity<>(headers);
			UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
					.queryParam("companyId", companyId)
					.queryParam("userId", userId)
					.queryParam("year", year);
			
			RestTemplate rest = new RestTemplate();
			
			ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
			
			JSONParser jp = new JSONParser();
			JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
			
			String status = resultBody.get("status").toString();
			
			JSONArray list = new JSONArray();
			if (status.equals("ok")) {		
				list = (JSONArray) resultBody.get("data");
				
				model.addAttribute("resultList", list);
			}
			
		}
		
		LOGGER.debug("annualHistoryPop ended.");
		
		return "/admin/ezAttitude/annualHistoryPop";
	}
	
	/**
	 * 관리자 근태입력관리 조회
	 */
	@RequestMapping(value = "/admin/ezAttitude/attitudeAnnualList.do", produces = "application/json;charset=utf-8")
	@ResponseBody
	public JSONObject getAttitudeAnnualList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LOGGER.debug("/admin/ezAttitude/attitudeAnnualList started.");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String companyId = request.getParameter("companyId");
		String searchUserName = request.getParameter("userName");
		String searchDeptName = request.getParameter("deptName");
		String searchTitle = request.getParameter("title");
		String searchYear= request.getParameter("year");
		String pageNum = request.getParameter("pageNum");
		String listSize = request.getParameter("listSize");
		String orderCell = request.getParameter("orderCell");
		String orderOption = request.getParameter("orderOption");
		String userId = userInfo.getId();
		String offsetMin = commonUtil.getMinuteUTC(userInfo.getOffset());
		
		if (searchYear == null || searchYear == "") {
			searchYear = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), userInfo.getOffset(), false).substring(0, 4);
		}
		
		LOGGER.debug("searchUserName = " + searchUserName + " || searchDeptName = " + searchDeptName + " || searchTitle = " + searchTitle + " || searchYear = " + searchYear + " || pageNum = " + pageNum + " || listSize = " + listSize
				+ " || orderCell = " + orderCell + "orderOption = " + orderOption);
		
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		String url = gwServerUrl + "/rest/ezattitude/attitudes/companies/" + companyId + "/annual";
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("companyId", companyId)
				.queryParam("searchUserName", searchUserName)
				.queryParam("searchDeptName", searchDeptName)
				.queryParam("searchTitle", searchTitle)
				.queryParam("searchYear", searchYear)
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
		
		LOGGER.debug("/admin/ezAttitude/attitudeAnnualList ended");
		
		return jObject;
	}
	
	/**
	 * 근태관리 연차현황관리 전체연차 등록 ,수정
	 */
	@RequestMapping(value = "/admin/ezAttitude/changeAllAnnual.do")
	@ResponseBody
	public String changeAllAnnual(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		LOGGER.debug("changeAllAnnual started.");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String companyId = request.getParameter("companyId");
		String changeReason = request.getParameter("changeReason");
		String flagCheck = request.getParameter("flagCheck");
		String annualCnt = request.getParameter("annualCnt");
		String year = request.getParameter("year");
		
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		String url = "";
		url = gwServerUrl + "/rest/ezattitude/companies/" + companyId + "/changeAllAnnual/";
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);

		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("changeUserId", userInfo.getId())
				.queryParam("changeReason", changeReason)
				.queryParam("flagCheck", flagCheck)
				.queryParam("annualCnt", annualCnt)
				.queryParam("year", year);
				
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<?> result;
		
		result = rest.exchange(builder.build().encode().toUri(), HttpMethod.POST, entity, JSONObject.class);
		JSONObject resultBody = (JSONObject) result.getBody();
		
		String status = resultBody.get("status").toString();
		String resultStatus = "";
		
		if (status.equals("ok")) {
			resultStatus = "success";
		} else if (status.equals("failed")) {
			resultStatus = "failed";
		} else if (status.equals("dive")) {
			resultStatus = "dive";
		} else {
			resultStatus = "error";
		}
		
		LOGGER.debug("changeAllAnnual ended.");
		
		return resultStatus;
	}
	
	
	/**
	 * 근태관리 연차현황관리 전체연차 등록 ,수정
	 */
	@RequestMapping(value = "/admin/ezAttitude/changePrsnAnnual.do")
	@ResponseBody
	public String changePrsnAnnual(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		LOGGER.debug("changePrsnAnnual started.");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String companyId = request.getParameter("companyId");
		String userId = request.getParameter("userId");
		String changeReason = request.getParameter("changeReason");
		String flagCheck = request.getParameter("flagCheck");
		String annualCnt = request.getParameter("annualCnt");
		String year = request.getParameter("year");
		
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		String url = "";
		url = gwServerUrl + "/rest/ezattitude/users/" + userId + "/changePrsnAnnual/";
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("changeUserId", userInfo.getId())
				.queryParam("changeReason", changeReason)
				.queryParam("companyId", companyId)
				.queryParam("annualCnt", annualCnt)
				.queryParam("flagCheck", flagCheck)
				.queryParam("year", year);
		
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<?> result;
		
		result = rest.exchange(builder.build().encode().toUri(), HttpMethod.POST, entity, JSONObject.class);
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
		
		LOGGER.debug("changePrsnAnnual ended.");
		
		return resultStatus;
	}
	
	/**
	 * 엑셀 출력
	 */
	@RequestMapping(value = "/admin/ezAttitude/excelAnnualListExport.do")
	public void excelAnnualListExport(@CookieValue("loginCookie")String loginCookie, HttpServletResponse response, HttpServletRequest request) throws Exception{
		LOGGER.debug("excelAnnualListExport started."); 
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String companyId = request.getParameter("companyId");
		String searchYear = request.getParameter("searchYear");
		String searchUserName = request.getParameter("userName");
		String searchDeptName = request.getParameter("deptName");
		String searchTitle = request.getParameter("title");
		String pageNum = request.getParameter("pageNum");
		String listSize = request.getParameter("listSize");
		String orderCell = request.getParameter("orderCell");
		String orderOption = request.getParameter("orderOption");
		String userId = userInfo.getId();
		String offsetMin = commonUtil.getMinuteUTC(userInfo.getOffset());
		Locale locale = userInfo.getLocale();
		
		
		LOGGER.debug("searchUserName = " + searchUserName + " || searchDeptName = " + searchDeptName + " || searchTitle = " + searchTitle + " || listSize = " + listSize
				+ " || orderCell = " + orderCell + " || orderOption = " + orderOption);
		
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		String url = gwServerUrl + "/rest/ezattitude/attitudes/companies/" + companyId + "/annual";
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("companyId", companyId)
				.queryParam("searchYear", searchYear)
				.queryParam("searchUserName", searchUserName)
				.queryParam("searchDeptName", searchDeptName)
				.queryParam("searchTitle", searchTitle)
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
		
		JSONObject data = new JSONObject();
		
		List<AttitudeAnnualVO> annualList = new ArrayList<AttitudeAnnualVO>();

		Gson gson = new Gson();
		if(status.equals("ok")){
			data = (JSONObject) resultBody.get("data");
			annualList = gson.fromJson(data.get("list").toString(), new TypeToken<List<AttitudeAnnualVO>>(){}.getType()) ;
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
		pFileName = EgovDateUtil.getToday("-") +"_annualReport.xls";
		
		//header
		row.createCell(0).setCellValue("NO");
		row.createCell(1).setCellValue("년도");
		row.createCell(2).setCellValue("사용자 ID");
		row.createCell(3).setCellValue(egovMessageSource.getMessage("ezAttitude.t10", locale));
		row.createCell(4).setCellValue(egovMessageSource.getMessage("ezAttitude.t11", locale));
		row.createCell(5).setCellValue(egovMessageSource.getMessage("ezAttitude.t9", locale));
		row.createCell(6).setCellValue("사용연차 수");
		row.createCell(7).setCellValue("총 연차 수");
		row.getCell(0).setCellStyle(headerStyle);
		row.getCell(1).setCellStyle(headerStyle);
		row.getCell(2).setCellStyle(headerStyle);
		row.getCell(3).setCellStyle(headerStyle);
		row.getCell(4).setCellStyle(headerStyle);
		row.getCell(5).setCellStyle(headerStyle);
		row.getCell(6).setCellStyle(headerStyle);
		row.getCell(7).setCellStyle(headerStyle);
		
		//body
		for (int i = 0 ; i < annualList.size(); i++) { 
			AttitudeAnnualVO vo = annualList.get(i);
			row = sheet.createRow(i + 1);
			
			row.createCell(0).setCellValue(i + 1);
			row.createCell(1).setCellValue(vo.getYear());
			row.createCell(2).setCellValue(vo.getUserId());
			row.createCell(3).setCellValue(vo.getUserName());
			row.createCell(4).setCellValue(vo.getUserTitle());
			row.createCell(5).setCellValue(vo.getUserDeptName());
			row.createCell(6).setCellValue(vo.getUseAnnualCnt());
			row.createCell(7).setCellValue(vo.getTotalAnnualCnt());
			
			row.getCell(0).setCellStyle(bodyStyle);
			row.getCell(1).setCellStyle(bodyStyle);
			row.getCell(2).setCellStyle(bodyStyle);
			row.getCell(3).setCellStyle(bodyStyle);
			row.getCell(4).setCellStyle(bodyStyle);
			row.getCell(5).setCellStyle(bodyStyle);
			row.getCell(6).setCellStyle(bodyStyle);
			row.getCell(7).setCellStyle(bodyStyle);
		}
		//width 조정
		sheet.autoSizeColumn(0);
		sheet.autoSizeColumn(1);
		sheet.autoSizeColumn(2);
		sheet.autoSizeColumn(3);
		sheet.autoSizeColumn(4);
		sheet.autoSizeColumn(5);
		sheet.autoSizeColumn(6);
		sheet.autoSizeColumn(7);
		sheet.setColumnWidth(0, (sheet.getColumnWidth(0)) + 512);
		sheet.setColumnWidth(1, (sheet.getColumnWidth(1)) + 512);
		sheet.setColumnWidth(2, (sheet.getColumnWidth(2)) + 512);
		sheet.setColumnWidth(3, (sheet.getColumnWidth(3)) + 512);
		sheet.setColumnWidth(4, (sheet.getColumnWidth(4)) + 512);
		sheet.setColumnWidth(5, (sheet.getColumnWidth(5)) + 512);
		sheet.setColumnWidth(6, (sheet.getColumnWidth(6)) + 512);
		sheet.setColumnWidth(7, (sheet.getColumnWidth(7)) + 512);
			
		
		response.setHeader("Content-Disposition", "attachment; fileName=\"" + pFileName + ".xls\"");
		workbook.write(response.getOutputStream());
		
		workbook.close();
		
		LOGGER.debug("excelAnnualListExport ended.");
	}
	
	@RequestMapping(value = "/admin/ezAttitude/useAnnualHistoryPop.do")
	public String useAnnualHistoryPop(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception{
		LOGGER.debug("useAnnualHistoryPop started.");
		//해당 사원 정보 (사원이름 직위 부서), 지각 수, 연차 수, 반차들 수, 연차 리스트
		String userId = request.getParameter("userId");
		String year = request.getParameter("year");
		String companyId = request.getParameter("companyId");
				
		model.addAttribute("userId", userId);
		model.addAttribute("year", year);
		model.addAttribute("companyId", companyId);

		
		LOGGER.debug("useAnnualHistoryPop ended.");

		return "/admin/ezAttitude/useAnnualHistoryPop";
	}
	
	@RequestMapping(value = "/admin/ezAttitude/useAnnualHistoryList.do")
	public String useAnnualHistoryList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception{
		LOGGER.debug("useAnnualHistoryList started.");
		//해당 사원 정보 (사원이름 직위 부서), 지각 수, 연차 수, 반차들 수, 연차 리스트
		String userId = request.getParameter("userId");
		String year = request.getParameter("year");
		String companyId = request.getParameter("companyId");
		
		if (userId != null) {
			String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
			String url = gwServerUrl + "/rest/ezattitude/users/" + userId + "/annual";
			
			HttpHeaders headers = new HttpHeaders();
			headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
			headers.set("x-user-host", request.getServerName());
			
			HttpEntity<?> entity = new HttpEntity<>(headers);
			UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
					.queryParam("companyId", companyId)
					.queryParam("year", year)
					.queryParam("userId", userId);
			
			RestTemplate rest = new RestTemplate();
			
			ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
			
			JSONParser jp = new JSONParser();
			JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
			
			String status = resultBody.get("status").toString();
			
			JSONArray userAnnualList = new JSONArray();
			if (status.equals("ok")) {		
				userAnnualList = (JSONArray) resultBody.get("data");
				
				model.addAttribute("list", userAnnualList);
			}
		}
		
		LOGGER.debug("useAnnualHistoryList ended.");
		
		return "json";
	}
	
	private class MultipartFileResource extends InputStreamResource {
		private String filename;
		
		public MultipartFileResource(InputStream inputStream, String filename) {
			super(inputStream);
			this.filename = filename;
		}
		
		@Override
		public String getFilename() {
			return this.filename;
		}
		
		@Override
		public long contentLength() throws IOException {
			return -1; // Prevent read the whole stream into memory
		}
	}
	
	private class BnkResourceHttpMessageConverter extends ResourceHttpMessageConverter {
		@Override
		protected Long getContentLength(org.springframework.core.io.Resource resource, MediaType contentType) throws IOException {
			Long contentLength = super.getContentLength(resource, contentType);
			
			return contentLength == null || contentLength < 0 ? null : contentLength;
		}
	}
}