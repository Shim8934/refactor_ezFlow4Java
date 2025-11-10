package egovframework.ezEKP.ezAttitude.web;

import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Date;
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
import org.apache.poi.ss.usermodel.Cell;
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
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.servlet.HandlerMapping;
import org.springframework.web.util.UriComponentsBuilder;
import org.w3c.dom.Document;
import org.w3c.dom.Node;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.ibm.icu.text.SimpleDateFormat;
import com.ibm.icu.util.Calendar;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezAttitude.vo.AdminAttitudeVO;
import egovframework.ezEKP.ezAttitude.vo.AdminAttitudeVO2;
import egovframework.ezEKP.ezAttitude.vo.ModApplHistoryVO;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezMobile.ezOption.service.MOptionService;
import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.let.user.login.vo.LoginSimpleVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

@Controller
public class EzAttitudeController {
	private static final Logger logger = LoggerFactory.getLogger(EzAttitudeController.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
	@Resource(name="crypto")
	private EgovFileScrty egovFileScrty;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Resource(name = "MOptionService")
	private MOptionService mOptionService;
	
	@Autowired
	private EzCommonService ezCommonService;
	
	/**
	 * 사용자 좌측메뉴
	 * 근태정보관리
	 * 근태입력관리 미입력자관리 관리내역
	 */
	@RequestMapping(value="/ezAttitude/attitudeManage.do", method = RequestMethod.GET)
	public String attitudeManage(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception{
		logger.debug("attitudeManage started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String offset = userInfo.getOffset();
		
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		
		String localDate = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), offset, false).substring(0, 10);
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Calendar cal = Calendar.getInstance();
		
		cal = Calendar.getInstance();
		cal.setTime(sdf.parse(localDate));
		cal.add(Calendar.DAY_OF_MONTH, -7);
		
		String searchStartDate = sdf.format(cal.getTime());
		String searchEndDate = localDate;
		
		String url = gwServerUrl + "/rest/ezattitude/users/" + userInfo.getId() + "/attitude-auth/hyo";

		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("companyId", userInfo.getCompanyID())
				.queryParam("listAuthType", "M");
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp = new JSONParser();
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		
		String status = resultBody.get("status").toString();
		
		JSONArray deptList = new JSONArray();

		if(status.equals("ok")){
			deptList = (JSONArray) resultBody.get("data");
		}

		if (deptList.size() < 1) {
			return "cmm/error/accessDenied";
		}
		
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
		
		model.addAttribute("useLang", userInfo.getLang());
		model.addAttribute("typeList", typeList);
		model.addAttribute("deptList", deptList);		
		model.addAttribute("companyId", userInfo.getCompanyID());
		model.addAttribute("selectedDeptID", userInfo.getDeptID());
		model.addAttribute("searchStartDate", searchStartDate.substring(0, 10));
		model.addAttribute("searchEndDate", searchEndDate.substring(0, 10));
		
		logger.debug("attitudeManage ended.");
		
		return "/ezAttitude/attitudeManage";
	}
	
	/**
	 * 사용자 좌측메뉴
	 * 수정신청관리 -> 나의수정신청
	 */
	@RequestMapping(value="/ezAttitude/attModAppList.do", method = RequestMethod.GET)
	public String getAttModAppList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model,
			@RequestParam(required=false)String pageNum,
			@RequestParam(required=false)String apprUserName,
			@RequestParam(required=false)String startDate,
			@RequestParam(required=false)String endDate) throws Exception {
		logger.debug("attModAppList started");
		
		int totalAtt = 0;
		int currentPage = 1;
		int totalPages = 1;
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String sysLang = ezCommonService.getTenantConfig("PrimaryLang", userInfo.getTenantId());

		if (userInfo.getLang().equals(sysLang))  {
			sysLang = "primary";
		}
		
		String offset = userInfo.getOffset();
		String offsetMin = commonUtil.getMinuteUTC(offset);
		
		model.addAttribute("userLang", userInfo.getLang());
		model.addAttribute("userTimeSet", offset);
		model.addAttribute("offsetMin", offsetMin);
		model.addAttribute("totalAtt", totalAtt);
		model.addAttribute("currentPage", currentPage);
		model.addAttribute("totalPages", totalPages);
		model.addAttribute("adminFlag", "false");
		
		logger.debug("attModAppList ended");
		
		return "/ezAttitude/attModAppList";
	}
	
	/**
	 * 사용자 좌측메뉴
	 * 수정신청관리 -> 수정신청관리
	 */
	@RequestMapping(value="/ezAttitude/manageAttModAppList.do", method = RequestMethod.GET)
	public String adminGetAttModAppList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model,
			@RequestParam(required=false)String pageNum,
			@RequestParam(required=false)String apprUserName,
			@RequestParam(required=false)String startDate,
			@RequestParam(required=false)String endDate,
			@RequestParam(required=false)String deptid) throws Exception {
		logger.debug("adminGetAttModAppList started");
		
		String adminFlag = "true";
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String sysLang = ezCommonService.getTenantConfig("PrimaryLang", userInfo.getTenantId());
        
		if (userInfo.getLang().equals(sysLang))  {
			sysLang = "primary";
		}
		
		if (deptid == null) {
			deptid = userInfo.getDeptID(); 
		}
		
		String offset = userInfo.getOffset();
		String offsetMin = commonUtil.getMinuteUTC(offset);
		
		String url = gwServerUrl + "/rest/ezattitude/users/" + userInfo.getId() + "/attitude-auth/hyo";

		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("companyId", userInfo.getCompanyID())
				.queryParam("listAuthType", "M");
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp = new JSONParser();
		
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		
		String status = resultBody.get("status").toString();
		
		JSONArray deptList = new JSONArray();
		
		if(status.equals("ok")){
			deptList = (JSONArray) resultBody.get("data");
		}

		if (deptList.size() < 1) {
			return "cmm/error/accessDenied";
		}
		
		model.addAttribute("selectedDeptID", deptid);
		model.addAttribute("userLang", userInfo.getLang());
		model.addAttribute("userTimeSet", offset);
		model.addAttribute("offsetMin", offsetMin);
		model.addAttribute("adminFlag", adminFlag);
		model.addAttribute("deptList", deptList);
		
		logger.debug("adminGetAttModAppList ended");
		
		return "/ezAttitude/manageAttModAppList";
	}
	
	/**
	 * 근태 미입력자 팝업
	 */
	@RequestMapping(value = "/ezAttitude/popupAbsentedList.do", method = RequestMethod.GET)
	public String popupAbsentedList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("popupAbsentedList started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String searchDeptId = request.getParameter("deptId");
		String date = request.getParameter("date");
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Calendar cal = Calendar.getInstance();
		
		String today = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), userInfo.getOffset(), false).substring(0, 10);
		String searchStartDate = date + "-01";
		String searchEndDate = "";
		logger.debug(today.substring(0, 7));
		logger.debug("date.compareTo(today.substring(0, 7) = " + date.compareTo(today.substring(0, 7)));
		if (date.compareTo(today.substring(0, 7)) == 0) {
			//현재달
			searchEndDate = today;
		} else if (date.compareTo(today.substring(0, 7)) < 0) {
			//이전달
			Date firstDayofMonth = sdf.parse(searchStartDate);
			cal.setTime(firstDayofMonth);
			
			searchEndDate = searchStartDate.substring(0, 8) + Integer.toString(cal.getActualMaximum(Calendar.DAY_OF_MONTH));
		}
		//2018-05-14 이효진 다음달일땐 searchEndDate "" 으로 가져가서 미입력조회없이 tr에 정보없다고 script로
		
		String useExternalMailServer = ezCommonService.getTenantConfig("useExternalMailServer", userInfo.getTenantId());
		if (useExternalMailServer == null || useExternalMailServer.equals("")) {
			useExternalMailServer = "NO";
		}
		
		model.addAttribute("companyId", userInfo.getCompanyID());
		model.addAttribute("searchDeptId", searchDeptId);
		model.addAttribute("searchStartDate", searchStartDate);
		model.addAttribute("searchEndDate", searchEndDate);
		model.addAttribute("useExternalMailServer", useExternalMailServer);
		
		logger.debug("popupAbsentedList ended.");
		
		return "/ezAttitude/popupAbsentedList";
	}
	
	/**
	 * 사용자 근태리스트 출력
	 */
	@RequestMapping(value = "/ezAttitude/getAttitudeList.do", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	@ResponseBody
	public JSONArray getAttitudeList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("/ezAttitude/getAttitudeList started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String userId = userInfo.getId();
		String startDate = request.getParameter("startDate");
		String endDate =request.getParameter("endDate");
		String deptFlag = request.getParameter("deptFlag");
		String typeId = request.getParameter("typeId");
		String selectedDeptID = request.getParameter("selectedDeptID");
		
		if (deptFlag == null) {
			deptFlag = "false";
		}
		if (typeId == null) {
			typeId = "";
		}
		if (selectedDeptID == null) {
			selectedDeptID = "";
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
		logger.debug("status : " + status);
		
		JSONArray list = new JSONArray();
		if (status.equals("ok")) {
			list = (JSONArray) resultBody.get("data");
		}
		
		logger.debug("/ezAttitude/getAttitudeList ended");
		return list;
	}
	
	/**
	 * 사용자 근태 추가 및 수정
	 */
	@RequestMapping(value = "/ezAttitude/attitudeSave.do", method = RequestMethod.POST)
	@ResponseBody
	public String attitudeSave(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("/ezAttitude/attitudeSave started");
		
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
		} else if (mode.equals("admin")){
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
				.queryParam("dateType", dateType)
				.queryParam("mode", mode);
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), (mode.equals("new")) ? HttpMethod.POST : HttpMethod.PUT, entity, String.class);
		
		JSONParser jp = new JSONParser();
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		
		String status = resultBody.get("status").toString();
		logger.debug("status : " + status);
		
		String resultStatus = "";
		if (status.equals("ok")) {
			resultStatus = resultBody.get("data").toString();
			if (!resultStatus.equals("dupl")) {
				resultStatus = "success";
			}
		} else {
			if(resultBody.get("message").toString().equals("error")){
				resultStatus = "outAttError";
			}else {
				resultStatus = "error";				
			}
		}
		
		logger.debug("/ezAttitude/attitudeSave ended");
		
		return resultStatus;
	}
	
	/**
	 * attitude Main
	 */
	@RequestMapping(value = "/ezAttitude/attitudeMain.do", method = RequestMethod.GET)
	public String attitudeMain(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("/ezAttitude/attitudeMain started");

		String leftFrameWidth = "220";
		int width = 0;

		if (request.getParameter("__wwidth") != null) {
			String widthParam = request.getParameter("__wwidth");

			try {
				width = Integer.parseInt(widthParam);

				leftFrameWidth = width < 1180 ? "0" : "220";
			} catch (NumberFormatException e) {
				width = 0;
			}
		}
		
		model.addAttribute("leftFrameWidth", leftFrameWidth);
		
		logger.debug("/ezAttitude/attitudeMain ended");
		return "/ezAttitude/attitudeMain";
	}
	
	/**
	 * attitude Main Left
	 */
	@RequestMapping(value = "/ezAttitude/attitudeLeft.do", method = RequestMethod.GET)
	public String attitudeLeft(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		logger.debug("/ezAttitude/attitudeLeft started");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String userOffset = userInfo.getOffset().split("\\|")[1];
		String isAllDept = "";
		String authFlag = "";
		String serverTime = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), userInfo.getOffset(), false);
		boolean attitudeAdminCheck = false;
		
		if (commonUtil.isAdmin(userInfo.getId(), userInfo.getTenantId(), userInfo.getRollInfo(), "c;k;e")) {
			attitudeAdminCheck = true;
			isAllDept = "Y";
		} else if (commonUtil.isAdmin(userInfo.getId(), userInfo.getTenantId(), userInfo.getRollInfo(), "g")) {
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
		logger.debug("status : " + status);
		
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
		
		for (int i = 0; i < deptList.size(); i++) {
			JSONObject dept = (JSONObject) deptList.get(i);
			authFlag = (String) dept.get("authType");
			
			if (authFlag != null && authFlag.equals("M")) {
				attitudeAdminCheck = true;
			}
		}
		
		if (attitudeAdminCheck == true) {
			String offset = userInfo.getOffset();
			String offsetMin = commonUtil.getMinuteUTC(offset);			
			String sysLang = ezCommonService.getTenantConfig("PrimaryLang", userInfo.getTenantId());
			url = gwServerUrl + "/rest/ezattitude/users/"+ userInfo.getId() +"/modifyattitudes/count";
										
			headers = new HttpHeaders();
			headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
			headers.set("x-user-host", request.getServerName());
			
			entity = new HttpEntity<>(headers);
			
			builder = UriComponentsBuilder.fromHttpUrl(url)
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
			
			rest = new RestTemplate();

			result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);

			jp = new JSONParser();
			
			resultBody = (JSONObject) jp.parse(result.getBody());
			
			status = resultBody.get("status").toString();
			
			if(status.equals("ok")){
				int totalAtt = Integer.parseInt(resultBody.get("data").toString());
				model.addAttribute("totalAtt", totalAtt);
			}
			
			//취소신청 갯수
			url = gwServerUrl + "/rest/ezattitude/users/"+ userInfo.getId() +"/cancelannual/count";
			
			headers = new HttpHeaders();
			headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
			headers.set("x-user-host", request.getServerName());
			
			entity = new HttpEntity<>(headers);
			
			builder = UriComponentsBuilder.fromHttpUrl(url)
					.queryParam("companyId", userInfo.getCompanyID())
					.queryParam("tenantId", userInfo.getTenantId())
					.queryParam("apprUserName", "")
					.queryParam("writerName", "")
					.queryParam("writerDeptName", "")
					.queryParam("startDate", "")
					.queryParam("endDate", "")
					.queryParam("offset", offsetMin)
					.queryParam("pageNum", "")
					.queryParam("type", "0")
					.queryParam("orderCell", "")
					.queryParam("orderOption", "")
					.queryParam("adminFlag", "true")
					.queryParam("deptid", "ALL")
					.queryParam("isAllDept", isAllDept);
			
			rest = new RestTemplate();

			result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);

			jp = new JSONParser();
			
			resultBody = (JSONObject) jp.parse(result.getBody());
			
			status = resultBody.get("status").toString();
			
			if(status.equals("ok")) {
				model.addAttribute("totalAnnual", resultBody.get("data").toString());
			}
		}
		
		model.addAttribute("serverTime", serverTime);
		model.addAttribute("deptList", deptList);
		model.addAttribute("authFlag", authFlag);
		model.addAttribute("userOffset", userOffset);
		model.addAttribute("uselang", userInfo.getLang());
		model.addAttribute("attitudeAdminCheck", attitudeAdminCheck);
		
		logger.debug("/ezAttitude/attitudeLeft ended"); 
		return "/ezAttitude/attitudeLeft";
	}
	
	/**
	 * 개인근태현황 main
	 */
	@RequestMapping(value = "/ezAttitude/attitudeUserMain.do", method = RequestMethod.GET)
	public String attitudeUserMain(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		logger.debug("/ezAttitude/attitudeUserMain started");
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
		logger.debug("status : " + status);
		
		JSONObject attitudeConfigVO = new JSONObject();
		if (status.equals("ok")) {
			attitudeConfigVO = (JSONObject) resultBody.get("data");
			model.addAttribute("attitudeConfigVO", attitudeConfigVO);
			
			//근태유형
			url = gwServerUrl + "/rest/ezattitude/companies/" + userInfo.getCompanyID() + "/attitudetypes";
			
			builder = UriComponentsBuilder.fromHttpUrl(url)
					.queryParam("userId", userInfo.getId())
					.queryParam("typeIdArr", "A11,A12,A13,A21");
			
			result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
			
			resultBody = (JSONObject) jp.parse(result.getBody());
			
			status = resultBody.get("status").toString();
			
			JSONArray typeList = new JSONArray();
			
			if(status.equals("ok")){
				typeList = (JSONArray) resultBody.get("data");
			}
			
			model.addAttribute("A11typeInfo", typeList.get(0));
			model.addAttribute("A12typeInfo", typeList.get(1));
			model.addAttribute("A13typeInfo", typeList.get(2));
			model.addAttribute("A21typeInfo", typeList.get(3));
		}
		
		model.addAttribute("userInfo", userInfo);
		
		String attitudeMapApiKey = ezCommonService.getTenantConfig("attitudeMapApiKey", userInfo.getTenantId());
		model.addAttribute("attitudeMapApiKey", attitudeMapApiKey);
		
		logger.debug("/ezAttitude/attitudeUserMain ended");
		return "/ezAttitude/attitudeUserMain";
	}
	
	/**
	 * 근태타입 리스트
	 */
	@RequestMapping(value = "/ezAttitude/attitudeTypeList.do", method = RequestMethod.GET)
	@ResponseBody
	public JSONArray attitudeTypeList(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		logger.debug("/ezAttitude/attitudeTypeList started");
		
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
		logger.debug("status : " + status);
		
		JSONArray list = new JSONArray();
		if (status.equals("ok")) {
			list = (JSONArray) resultBody.get("data");
		}
		
		logger.debug("/ezAttitude/attitudeTypeList ended");
		return list;
	}
	
	/**
	 * 근태통계 리스트
	 */
	@RequestMapping(value = "/ezAttitude/attitudeStatisList.do", method = RequestMethod.GET)
	@ResponseBody
	public JSONArray attitudeStatisList(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		logger.debug("/ezAttitude/attitudeTypeList started");
		
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
		logger.debug("status : " + status);
		
		JSONArray list = new JSONArray();
		if (status.equals("ok")) {
			list = (JSONArray) resultBody.get("data");
		}
		
		logger.debug("/ezAttitude/attitudeTypeList ended");
		return list;
	}
	
	/**
	 * 회사 휴일정보
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ezAttitude/getHolidayList.do", method = RequestMethod.GET)
	@ResponseBody
	public JSONObject getHolidayList(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		logger.debug("/ezAttitude/getHolidayList started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String userId = userInfo.getId();
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		String url = gwServerUrl + "/rest/ezattitude/companies/" + userInfo.getCompanyID() + "/holidays";
		String isRest = request.getParameter("isRest");
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("userId", userId)
				.queryParam("isRest", isRest);
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp = new JSONParser();
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		
		String status = resultBody.get("status").toString();
		logger.debug("status : " + status);
		
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
			logger.debug("status : " + status);
			
			JSONObject attitudeConfigVO = new JSONObject();
			if (status.equals("ok")) {
				attitudeConfigVO = (JSONObject) resultBody.get("data");
				returnValue.put("attitudeConfigVO", attitudeConfigVO);
			}
		}
		logger.debug("/ezAttitude/getHolidayList ended");
		return returnValue;
	}
	
	/**
	 * 작성화면
	 */
	@RequestMapping(value = "/ezAttitude/attitudeNewItem.do", method = RequestMethod.GET)
	public String attitudeWrite(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		logger.debug("/ezAttitude/attitudeNewItem started");
		
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
		logger.debug("status : " + status);
		
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
				logger.debug("status : " + status);
				
				JSONObject attitudeVO = new JSONObject();
				if (status.equals("ok")) {
					attitudeVO = (JSONObject) resultBody.get("data");
					
					model.addAttribute("attitudeInfo", attitudeVO);
				}
			}
		}
		
		model.addAttribute("userOffset", userOffset);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("attitudeTypeList", attitudeTypeList);
		model.addAttribute("date", date);
		model.addAttribute("mode", mode);
		
		logger.debug("/ezAttitude/attitudeNewItem ended");
		return "ezAttitude/attitudeNewItem";
	}
	
	/**
	 * 수정신청작성화면
	 */
	@RequestMapping(value = "/ezAttitude/attitudeModItem.do", method = RequestMethod.GET)
	public String attitudeModify(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		logger.debug("/ezAttitude/attitudeModItem started");
		
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
		logger.debug("status : " + status);
		
		JSONObject attitudeVO = new JSONObject();
		if (status.equals("ok")) {
			attitudeVO = (JSONObject) resultBody.get("data");

			model.addAttribute("data", attitudeVO);
		}
		logger.debug("attitudeVOtoJSONString : " + attitudeVO.toJSONString());		
		model.addAttribute("userInfo", userInfo);

		logger.debug("/ezAttitude/attitudeModItem ended");
		
		return "ezAttitude/attitudeModItem";
	}
	
	/**
	 * 작성 양식
	 */
	@RequestMapping(value = "/ezAttitude/getFormBody.do", method = RequestMethod.GET)
	@ResponseBody
	public JSONObject getFormBody(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("/ezAttitude/getFormBody started");
		
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
		logger.debug("status : " + status);
		
		JSONObject formVO = new JSONObject();
		if (status.equals("ok")) {
			formVO = (JSONObject) resultBody.get("data");
		}
		
		logger.debug("/ezAttitude/getFormBody ended");
		return formVO;
	}
	
	/**
	 * 근태 상세보기
	 */
	@RequestMapping(value = "/ezAttitude/attitudeItemView.do", method = RequestMethod.GET)
	public String attitudeItemView(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		logger.debug("/ezAttitude/attitudeItemView started");
		
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
		logger.debug("status : " + status);
		
		JSONObject formVO = new JSONObject();
		JSONObject attitudeVO = new JSONObject();
		
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
			logger.debug("status : " + status);
			
			if (status.equals("ok")) {
				attitudeVO = (JSONObject) resultBody.get("data");
				model.addAttribute("attitudeInfo", attitudeVO);
			}
		} 
		model.addAttribute("userId", userInfo.getId());
		model.addAttribute("font", font);
		
		logger.debug("/ezAttitude/attitudeItemView ended");
		return "/ezAttitude/attitudeItemView";
	}
	
	/**
	 * 근태 삭제
	 */
	@RequestMapping(value = "/ezAttitude/attitudeDeleteItem.do", method = RequestMethod.POST)
	@ResponseBody
	public String attitudeDeleteItem(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("/ezAttitude/attitudeDeleteItem started");
		
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
		logger.debug("status : " + status);
		
		String resultStatus = "";
		if (status.equals("ok")) {
			resultStatus = "success";
		} else {
			resultStatus = "error";
		}
		
		logger.debug("/ezAttitude/attitudeDeleteItem ended");
		
		return resultStatus;
	}
	
	/**
	 * 근태 내용
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ezAttitude/getAttitudeItem.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject getAttitudeItem(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("/ezAttitude/getAttitudeItem started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String userId = userInfo.getId();
		String attitudeId = request.getParameter("attitudeId");
		
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		String url = gwServerUrl + "/rest/ezattitude/attitudes/"  + attitudeId; //근태상세보기 가져오기
		
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
		logger.debug("status : " + status);
		
		JSONObject returnValue = new JSONObject();
		JSONObject attitudeVO = new JSONObject();
		if (status.equals("ok")) {
			attitudeVO = (JSONObject) resultBody.get("data");
			returnValue.put("attitudeVO", attitudeVO);
			
			url = gwServerUrl + "/rest/ezattitude/attitudetypes/" + attitudeVO.get("typeId") + "/forms/form"; // form 가져와야됨
			
			builder = UriComponentsBuilder.fromHttpUrl(url)
					.queryParam("userId", userId);
			
			result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
			resultBody = (JSONObject) jp.parse(result.getBody());
			
			status = resultBody.get("status").toString();
			logger.debug("status : " + status);
			
			JSONObject formVO = new JSONObject();
			if (status.equals("ok")) {
				formVO = (JSONObject) resultBody.get("data");
				returnValue.put("formVO", formVO);
			}
		}
		logger.debug("/ezAttitude/getAttitudeItem ended");
		return returnValue;
	}
	
	@RequestMapping(value = "/ezAttitude/getIsAttitude.do", method = RequestMethod.POST)
	@ResponseBody
	public String getIsAttitude(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("/ezAttitude/getIsAttitude started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String selectUserId = request.getParameter("selectUserId");
		String userId = "";
		if (selectUserId != null && !selectUserId.equals("")) { //근태정보관리에서는 선택한 사원의 id 필요.
			userId = selectUserId;
		} else {
			userId = userInfo.getId();
		}
		String typeId = request.getParameter("typeId");
		String startDate = request.getParameter("startDate");
		
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		String url = gwServerUrl + "/rest/ezattitude/attitudes/checkIsAttitude"; //근태상세보기 가져오기
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("userId", userId)
				.queryParam("typeId", typeId)
				.queryParam("startDate", startDate);
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp = new JSONParser();
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		
		String status = resultBody.get("status").toString();
		logger.debug("status : " + status);
		
		String returnValue = "";
		
		if (status.equals("ok")) {
			returnValue = (String) resultBody.get("data");
		}
		logger.debug("/ezAttitude/getIsAttitude ended");
		return returnValue;
	}
	
	@RequestMapping(value = "/ezAttitude/getAttitudeReg.do", method = RequestMethod.GET)
	@ResponseBody
	public JSONObject getAttitudeReg(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		logger.debug("/ezAttitude/attitudeUserMain started");
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
		logger.debug("status : " + status);
		
		JSONObject attitudeConfigVO = new JSONObject();
		if (status.equals("ok")) {
			attitudeConfigVO = (JSONObject) resultBody.get("data");
		}
		
		
		logger.debug("/ezAttitude/attitudeUserMain ended");
		return attitudeConfigVO;
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(value="/ezAttitude/getAttModAppList.do",method=RequestMethod.GET, produces="application/json; charset=UTF-8")
	@ResponseBody
	public JSONObject getAttModAppList(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, Locale locale, ModelMap modelMap,
			@RequestParam(required=false)String apprUserName,
			@RequestParam(required=false)String writerName,
			@RequestParam(required=false)String writerDeptName,
			@RequestParam(required=false)String startDate,
			@RequestParam(required=false)String endDate,
			@RequestParam(required=false)String pageNum,
			@RequestParam(required=false)String type,
			@RequestParam(required=false)String excelReq,
			@RequestParam(required=false)String orderCell,
			@RequestParam(required=false)String orderOption,
			@RequestParam(required=false)String adminFlag,
			@RequestParam(required=false)String checkAdmin,
			@RequestParam(required=false)String writerDeptId,
			@RequestParam(required=false)String companyId) throws Exception {
		
		logger.debug("getAttModAppList started");
		logger.debug("adminFlag = " + adminFlag + " || checkAdmin = " + checkAdmin);
		int currentPage = 1;
		int pageSize = 15;
		int startPoint = 0;
		int endPoint = 15;
		int totalPages = 1;
		int totalAtt = 0;
		String isAllDept = "";
		String authFlag = "";
		
		if (pageNum != null) {
			currentPage = Integer.parseInt(pageNum);
		}
		
		if (excelReq == null) {
			excelReq = "false";
		}
		
		if (adminFlag == null) {
			adminFlag = "false";
		}
		
		if (checkAdmin == null || checkAdmin.trim().equals("")) {
			checkAdmin = "false";
		}
		
		if (checkAdmin.equals("true")) {
			totalPages = 0;
			pageSize = 15;
			startPoint = 0;
			endPoint = 15;
		}
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		if (companyId == null || companyId.equals("")) {
			companyId = userInfo.getCompanyID();
		}
		
		
		
		String offset = userInfo.getOffset();
		String offsetMin = commonUtil.getMinuteUTC(offset);
		
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		String url = gwServerUrl + "/rest/ezattitude/users/"+ userInfo.getId() +"/modifyattitudes/count";
									
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("companyId", companyId)
				.queryParam("tenantId", userInfo.getTenantId())
				.queryParam("apprUserName", apprUserName)
				.queryParam("writerName", writerName)
				.queryParam("writerDeptName", writerDeptName)
				.queryParam("startDate", startDate)
				.queryParam("endDate", endDate)
				.queryParam("offset", offsetMin)
				.queryParam("pageNum", pageNum)
				.queryParam("type", type)
				.queryParam("orderCell", orderCell)
				.queryParam("orderOption", orderOption)
				.queryParam("adminFlag", adminFlag)
				.queryParam("checkAdmin", checkAdmin)
				.queryParam("deptid", writerDeptId)
				.queryParam("isAllDept", isAllDept);
		
		RestTemplate rest = new RestTemplate();

		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);

		JSONParser jp = new JSONParser();
		
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		
		String status = resultBody.get("status").toString();
		
		JSONObject data = new JSONObject();
		JSONArray list = new JSONArray();
		
		if(status.equals("ok")){
			totalAtt = Integer.parseInt(resultBody.get("data").toString());
		}
		totalPages = (totalAtt + pageSize - 1)/pageSize;
		
		gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		url = gwServerUrl + "/rest/ezattitude/users/"+ userInfo.getId() +"/modifyattitudes";
		
		headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		entity = new HttpEntity<>(headers);
		
		if (totalPages == 0) {
			totalPages = 1;
		} else {
			if (currentPage < totalPages) {
				startPoint = (currentPage - 1)*pageSize;
				endPoint = currentPage*pageSize;
			}
			else {
				if (currentPage > totalPages) {
					currentPage = totalPages;
				}
				startPoint = (currentPage - 1) * pageSize;
				endPoint = totalAtt;
			}
		}
		
		logger.debug("startPoint : " + startPoint);
		logger.debug("endPoint : " + endPoint);
		logger.debug("currentPage : " + currentPage);
		logger.debug("totalPages : " + totalPages);
		
		if (excelReq.equals("true")) {
			builder = UriComponentsBuilder.fromHttpUrl(url)
					.queryParam("companyId", companyId)
					.queryParam("tenantId", userInfo.getTenantId())
					.queryParam("apprUserName", apprUserName)
					.queryParam("writerName", writerName)
					.queryParam("writerDeptName", writerDeptName)
					.queryParam("startDate", startDate)
					.queryParam("endDate", endDate)
					.queryParam("offset", offsetMin)
					.queryParam("type", type)
					.queryParam("orderCell", orderCell)
					.queryParam("orderOption", orderOption)
					.queryParam("adminFlag", adminFlag)
					.queryParam("checkAdmin", checkAdmin)
					.queryParam("deptid", writerDeptId)
//					.queryParam("isAllDept", isAllDept);
					.queryParam("listAuthType", "M");
		} else {
			builder = UriComponentsBuilder.fromHttpUrl(url)
					.queryParam("companyId", companyId)
					.queryParam("tenantId", userInfo.getTenantId())
					.queryParam("apprUserName", apprUserName)
					.queryParam("writerName", writerName)
					.queryParam("writerDeptName", writerDeptName)
					.queryParam("startDate", startDate)
					.queryParam("endDate", endDate)
					.queryParam("offset", offsetMin)
					.queryParam("startPoint", startPoint)
					.queryParam("endPoint", endPoint)
					.queryParam("type", type)
					.queryParam("orderCell", orderCell)
					.queryParam("orderOption", orderOption)
					.queryParam("adminFlag", adminFlag)
					.queryParam("checkAdmin", checkAdmin)
					.queryParam("deptid", writerDeptId)
//					.queryParam("isAllDept", isAllDept);
					.queryParam("listAuthType", "M");
		}

		rest = new RestTemplate();
		
		result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		jp = new JSONParser();
		
		resultBody = (JSONObject) jp.parse(result.getBody());
		
		status = resultBody.get("status").toString();
		
		data = new JSONObject();
		JSONObject resultj = new JSONObject();
		list = new JSONArray();
		
		if(status.equals("ok")){
			data = (JSONObject) resultBody.get("data");
			list = (JSONArray) data.get("list");
			resultj.put("list", list);
		}
		
		if (commonUtil.isAdmin(userInfo.getId(), userInfo.getTenantId(), userInfo.getRollInfo(), "c;k;e")) {
			adminFlag = "true";
			//권한부서 리스트
			//c , k , e -> 회사의 모든부서
			isAllDept = "Y";
		} else if (commonUtil.isAdmin(userInfo.getId(), userInfo.getTenantId(), userInfo.getRollInfo(), "g")) {
			adminFlag = "true";
			// g -> 자신의 부서 + auth TB 확인해볼것.
		}
		
		url = gwServerUrl + "/rest/ezattitude/users/" + userInfo.getId() + "/attitude-auth/hyo";
		
		headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		entity = new HttpEntity<>(headers);
		
		builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("companyId", userInfo.getCompanyID())
				.queryParam("userId", userInfo.getId())
				.queryParam("isAllDept", isAllDept);
		
		rest = new RestTemplate();
		
		result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		jp = new JSONParser();
		
		resultBody = (JSONObject) jp.parse(result.getBody());
		
		status = resultBody.get("status").toString();
		
		JSONArray deptList = new JSONArray();
		
		if(status.equals("ok")){
			deptList = (JSONArray) resultBody.get("data");
		}
		for (int i = 0; i < deptList.size(); i++ ){
			JSONObject dept = (JSONObject)deptList.get(i);
			if (dept.get("deptId").equals(writerDeptId)) {
				if (!((String) dept.get("authType")).equals("")) {
					authFlag = (String) dept.get("authType");
				}
			}
		}
		
		resultj.put("startDate", startDate);
		resultj.put("endDate", endDate);
		resultj.put("totalAtt", totalAtt);
		resultj.put("totalPages", totalPages);
		resultj.put("authFlag", authFlag);
		
		logger.debug("getAttModAppList ended");
		
		return resultj;
	}
	
	@RequestMapping(value = "/ezAttitude/saticGetXlsAtt.do", method = RequestMethod.POST)
	@ResponseBody
	public void qstResultsaticGetXlsAtt(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception{
		logger.debug("qstResultsaticGetXlsAtt started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		/* String headerFLAG = "";
		 
		if (request.getParameter("headerFlag") != null) {
			headerFLAG = request.getParameter("headerFlag");
		} */
		  
		// 2023-05-31 이사라 : 시큐어코딩 리소스 close
		try(HSSFWorkbook workbook = new HSSFWorkbook()) {
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
		 
		Row row;
		Cell cell;
		      
		String pFileName = "";
		String strDate = EgovDateUtil.getToday("-");
		// 2025-02-20 조수빈 - #155515 근태관리 > [엑셀다운로드] 시 파일명 수정 필요
		String saveFileName = request.getParameter("saveFileName");
		pFileName = strDate + "_" + null == saveFileName || saveFileName.equals("") ? egovMessageSource.getMessage("ezAttitude.t1", userInfo.getLocale()) : saveFileName;
		  
		String StrAnalysisDate = request.getParameter("saveExcelData").trim().replaceAll("&nbsp;", "").replaceAll("\r\n", "").replaceAll("\n", "").replaceAll("\t", "");
		Document analysisData = commonUtil.convertStringToDocument(StrAnalysisDate);
		Node tbodyNode = analysisData.getElementsByTagName("tbody").item(0);
		Node tableHeadNode;
		Node tableBodyNode;
		 
		tableHeadNode = tbodyNode.getChildNodes().item(0);
		
		sheet = workbook.createSheet("report");
		row = sheet.createRow(0);
		for (int i = 0; i <tableHeadNode.getChildNodes().getLength(); i++) {
			cell = row.createCell(i);
			cell.setCellValue(tableHeadNode.getChildNodes().item(i).getTextContent());
			cell.setCellStyle(headerStyle);
		}
		  //header
		
		for (int i = 1; i < tbodyNode.getChildNodes().getLength() ; i++){
			row = sheet.createRow(i);
			tableBodyNode = tbodyNode.getChildNodes().item(i);
			for (int j = 0; j < tableBodyNode.getChildNodes().getLength(); j++) {
				cell = row.createCell(j);
				cell.setCellValue(tableBodyNode.getChildNodes().item(j).getTextContent());
				cell.setCellStyle(bodyStyle);
			}
		}//body
		
		response.setHeader("Content-Disposition", "attachment; fileName=\"" + URLEncoder.encode(pFileName, "UTF-8") + ".xls\"");
		workbook.write(response.getOutputStream());
		  
		workbook.close();
		  
		logger.debug("qstResultsaticGetXlsAtt ended");
		}
	}
	
	@RequestMapping(value="/ezAttitude/delAttModApp.do" , method= RequestMethod.POST)
	@ResponseBody
	public String delAttModApp(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model,
			@RequestParam(required=false)String idList) throws Exception {
		logger.debug("delAttModApp started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String sysLang = ezCommonService.getTenantConfig("PrimaryLang", userInfo.getTenantId());

		if (userInfo.getLang().equals(sysLang))  {
			sysLang = "primary";
		}
		
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		String url = gwServerUrl + "/rest/ezattitude/users/"+ userInfo.getId() +"/modifyattitudes";
									
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("companyId", userInfo.getCompanyID())
				.queryParam("tenantId", userInfo.getTenantId())
				.queryParam("idList", idList);
		
		RestTemplate rest = new RestTemplate();

		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.DELETE, entity, String.class);
		
		JSONParser jp = new JSONParser();
		
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		
		String status = resultBody.get("status").toString();

		logger.debug("delAttModApp ended");
		return status;
	}
	
	@RequestMapping(value="/ezAttitude/changeAttModApp.do", method= RequestMethod.POST)
	@ResponseBody
	public String changeAttModApp(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model,
			@RequestParam(required=true)String idList,
			@RequestParam(required=true)String changeStatus,
			@RequestParam(required=false)String companyID
			) throws Exception {
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		if (companyID == null || companyID.equals("")) {
			companyID = userInfo.getCompanyID();
		}
		
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		String url = gwServerUrl + "/rest/ezattitude/users/"+ userInfo.getId() +"/modifyattitudes";
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("companyId", companyID)
				.queryParam("tenantId", userInfo.getTenantId())
				.queryParam("idList", idList)
				.queryParam("changeStatus", changeStatus);
		
		RestTemplate rest = new RestTemplate();

		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.PUT, entity, String.class);
		
		JSONParser jp = new JSONParser();
		
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		
		String status = resultBody.get("status").toString();
		
		logger.debug("apprAttModApp ended");
		
		return status;
	}
	
	/**
	 * 근태수정현황 등록
	 */
	@RequestMapping(value="/ezAttitude/saveAttModApp.do" , method= RequestMethod.POST)
	@ResponseBody
	public String saveAttModApp(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model,
			@RequestParam(required=false)String attId,
			@RequestParam(required=false)String changeDate,
			@RequestParam(required=false)String originDate,
			@RequestParam(required=false)String content) throws Exception {
		logger.debug("saveAttModApp started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String sysLang = ezCommonService.getTenantConfig("PrimaryLang", userInfo.getTenantId());

		if (userInfo.getLang().equals(sysLang))  {
			sysLang = "primary";
		}
		
		String offset = userInfo.getOffset();
		String offsetMin = commonUtil.getMinuteUTC(offset);
		
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		String url = gwServerUrl + "/rest/ezattitude/attitudes/" + attId + "/modify-applications";
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("companyId", userInfo.getCompanyID())
				.queryParam("tenantId", userInfo.getTenantId())
				.queryParam("userId", userInfo.getId())
				.queryParam("content", content)
				.queryParam("changeDate", changeDate)
				.queryParam("originDate", originDate)
				.queryParam("offset", offsetMin);
		
		RestTemplate rest = new RestTemplate();

		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.POST, entity, String.class);
		
		JSONParser jp = new JSONParser();
		
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		
		String data = resultBody.get("data").toString();

		logger.debug("saveAttModApp ended");
		
		return data;
	}
	
	/**
	 * 근태수정현황 수정
	 */
	@RequestMapping(value="/ezAttitude/modAttModApp.do" , method= RequestMethod.POST)
	@ResponseBody
	public String modAttModApp(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model,
			@RequestParam(required=false)String attId,
			@RequestParam(required=false)String changeDate,
			@RequestParam(required=false)String content) throws Exception {
		logger.debug("modAttModApp started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String sysLang = ezCommonService.getTenantConfig("PrimaryLang", userInfo.getTenantId());

		if (userInfo.getLang().equals(sysLang))  {
			sysLang = "primary";
		}
		
		String offset = userInfo.getOffset();
		String offsetMin = commonUtil.getMinuteUTC(offset);
		
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		String url = gwServerUrl + "/rest/ezattitude/modifyattitude/" + attId;
									
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("companyId", userInfo.getCompanyID())
				.queryParam("tenantId", userInfo.getTenantId())
				.queryParam("userId", userInfo.getId())
				.queryParam("content", content)
				.queryParam("changeDate", changeDate)
				.queryParam("offset", offsetMin);
		
		RestTemplate rest = new RestTemplate();

		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.POST, entity, String.class);
		
		JSONParser jp = new JSONParser();
		
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		
		String status = resultBody.get("data").toString();

		logger.debug("modAttModApp ended");
		
		return status;
	}
	
	/**
	 * 근태 수정 신청 상세
	 */
	@RequestMapping(value="/ezAttitude/attModAppDetail.do", method = RequestMethod.GET)
	public String attModAppDetail(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model,
			@RequestParam(required=true)String attModId,
			@RequestParam(required=false)String companyId,
			@RequestParam(required=false)String applCnt,
			@RequestParam(required=false)String adminFlag,
			@RequestParam(required=false)String pageInfo) throws Exception {
		logger.debug("attModAppDetail started");
		
		String isAllDept = "";
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
			logger.debug("status : " + status);
			
			JSONObject attitudeConfigVO = new JSONObject();
			if (status.equals("ok")) {
				attitudeConfigVO = (JSONObject) resultBody.get("data");
				model.addAttribute("attitudeConfigVO", attitudeConfigVO);
			}
		}
		
		if (commonUtil.isAdmin(userInfo.getId(), userInfo.getTenantId(), userInfo.getRollInfo(), "c;k;e")) {
			adminFlag = "true";
			isAllDept = "Y";
		} else if (commonUtil.isAdmin(userInfo.getId(), userInfo.getTenantId(), userInfo.getRollInfo(), "g")) {
			adminFlag = "true";
		}
		
		url = gwServerUrl + "/rest/ezattitude/users/" + userInfo.getId() + "/attitude-auth";
		
		headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		entity = new HttpEntity<>(headers);
		
		builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("companyId", companyId)
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
		
		for (int i = 0; i < deptList.size(); i++ ){
			JSONObject dept = (JSONObject)deptList.get(i);
			if (dept.get("deptId").equals(attModDeptId)) {
				if ((String) dept.get("authType") != null && !((String) dept.get("authType")).equals("")) {
					authFlag = (String) dept.get("authType");
				}
				adminFlag = "true";
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
		
		logger.debug("attModAppDetail ended");
		
		return "/ezAttitude/attModAppDetail";
	}
	
	/**
	 * 근태 수정 신청 상세
	 */
	@RequestMapping(value="/ezAttitude/attModAppDet.do", method=RequestMethod.GET, produces="application/json; charset=UTF-8")
	@ResponseBody
	public JSONObject attModAppDetail(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model,
			@RequestParam(required=true)String attModId,
			@RequestParam(required=false)String applCnt) throws Exception {
		logger.debug("attModAppDetail started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String sysLang = ezCommonService.getTenantConfig("PrimaryLang", userInfo.getTenantId());
		// String font = ezCommonService.getTenantConfig("editorFontStyle", userInfo.getTenantId());
		
		if (userInfo.getLang().equals(sysLang))  {
			sysLang = "primary";
		}

		String offset = userInfo.getOffset();
		String offsetMin = commonUtil.getMinuteUTC(offset);
		
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		String url = gwServerUrl + "/rest/ezattitude/modifyattitude/" + attModId;
									
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("companyId", userInfo.getCompanyID())
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
		}
		
		logger.debug("attModAppDetail ended");
		
		return data;
	}
	
	/**
	 * 근태 수정 신청 상세
	 */
	@RequestMapping(value="/ezAttitude/attModAppMod.do", method = RequestMethod.GET)
	public String attModAppMod(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model,
			@RequestParam(required=false)String attModId) throws Exception {
		logger.debug("attModAppMod started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String sysLang = ezCommonService.getTenantConfig("PrimaryLang", userInfo.getTenantId());

		if (userInfo.getLang().equals(sysLang))  {
			sysLang = "primary";
		}
		
		String offset = userInfo.getOffset();
		String offsetMin = commonUtil.getMinuteUTC(offset);
		
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		String url = gwServerUrl + "/rest/ezattitude/modifyattitude/" + attModId;
									
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("companyId", userInfo.getCompanyID())
				.queryParam("tenantId", userInfo.getTenantId())
				.queryParam("userId", userInfo.getId())
				.queryParam("sysLang", sysLang)
				.queryParam("offset", offsetMin);
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp = new JSONParser();
		
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		
		String status = resultBody.get("status").toString();
		
		JSONObject data = new JSONObject();

		if(status.equals("ok")){
			data = (JSONObject) resultBody.get("data");
			model.addAttribute("data", data);
		}
		
		//글쓴이와 사용자의 아이디가 다르면 수정창에 접근 불가.
		if (!userInfo.getId().equals(data.get("writerId"))) {
			return "cmm/error/accessDenied";
		}
		
		model.addAttribute("userLang", userInfo.getLang());
		model.addAttribute("userTimeSet", offset);
		model.addAttribute("offsetMin", offsetMin);
		
		logger.debug("attModAppMod ended");
		
		return "/ezAttitude/attModAppMod";
	}
	
	/**
	 * 부서근태현황 main
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ezAttitude/attitudeDeptMain.do", method = RequestMethod.GET)
	public String attitudeUserMain(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request,
			@RequestParam(required=false)String deptid) throws Exception {
		logger.debug("attitudeUserMain started");
		
		String adminFlag = "false";
		@SuppressWarnings("unused")
		String isAllDept = "";
		String displayFlag = "false";
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		String url = "";
		
		//전체관리자(c), 회사관리자(k), 근태관리자(e) 면 모든부서..
		if (commonUtil.isAdmin(userInfo.getId(), userInfo.getTenantId(), userInfo.getRollInfo(), "c;k;e")) {
			adminFlag = "true";
			isAllDept = "Y";
		} else if (commonUtil.isAdmin(userInfo.getId(), userInfo.getTenantId(), userInfo.getRollInfo(), "g")) {
			adminFlag = "true";
		}
		
		url = gwServerUrl + "/rest/ezattitude/users/" + userInfo.getId() + "/attitude-auth/hyo";
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
//				.queryParam("companyId", userInfo.getCompanyID())
//				.queryParam("isAllDept", isAllDept)
//				.queryParam("userId", userInfo.getId());
				.queryParam("companyId", userInfo.getCompanyID())
				.queryParam("listAuthType", "R")
				.queryParam("userId", userInfo.getId());
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp = new JSONParser();
		
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		
		String status = resultBody.get("status").toString();
		
		JSONArray deptList = new JSONArray();
		
		if(status.equals("ok")){
			deptList = (JSONArray) resultBody.get("data");
			
			url = gwServerUrl + "/rest/ezattitude/companies/" + userInfo.getCompanyID() + "/attitudereg";
			
			builder = UriComponentsBuilder.fromHttpUrl(url)
					.queryParam("userId", userInfo.getId());
			
			result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
			
			resultBody = (JSONObject) jp.parse(result.getBody());
			
			status = resultBody.get("status").toString();
			logger.debug("status : " + status);
			
			JSONObject attitudeConfigVO = new JSONObject();
			if (status.equals("ok")) {
				attitudeConfigVO = (JSONObject) resultBody.get("data");
				model.addAttribute("attitudeConfigVO", attitudeConfigVO);
			}
		}
		
		if (deptList.size() > 1) {
			adminFlag = "true";
			displayFlag = "true";
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
		
		if (myDeptCount == deptList.size()) {
			displayFlag = "false";
		}
		
		model.addAttribute("deptList", deptList);
		model.addAttribute("userInfo", userInfo);
		if (deptid == null) {
			model.addAttribute("selectedDeptID", userInfo.getDeptID());
		} else {
			model.addAttribute("selectedDeptID", deptid);
		}
		model.addAttribute("deptFlag", "true");
		model.addAttribute("adminFlag", adminFlag);
		model.addAttribute("displayFlag", displayFlag);
		
		String attitudeMapApiKey = ezCommonService.getTenantConfig("attitudeMapApiKey", userInfo.getTenantId());
		model.addAttribute("attitudeMapApiKey", attitudeMapApiKey);
		
		logger.debug("attitudeUserMain ended");
		return "/ezAttitude/attitudeUserMain";
	}
	
	@RequestMapping(value="/ezAttitude/getAttHistory.do",method=RequestMethod.GET, produces="application/json; charset=UTF-8")
	@ResponseBody
	public JSONArray getAttHistory(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, Locale locale, ModelMap modelMap,
		@RequestParam(required=true)String attModId,
		@RequestParam(required=false)String companyId) throws Exception {
		
		logger.debug("getAttHistory started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String sysLang = ezCommonService.getTenantConfig("PrimaryLang", userInfo.getTenantId());
		
		if (userInfo.getLang().equals(sysLang))  {
			sysLang = "primary";
		}
		if (companyId == null || companyId.equals("")) {
			companyId = userInfo.getCompanyID();
		}
		
		String offset = userInfo.getOffset();
		String offsetMin = commonUtil.getMinuteUTC(offset);
		
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		String url = gwServerUrl + "/rest/ezattitude/modifyattitude/" + attModId + "/history";
									
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("companyId", companyId)
				.queryParam("tenantId", userInfo.getTenantId())
				.queryParam("userId", userInfo.getId())
				.queryParam("offset", offsetMin);
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp = new JSONParser();
		
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		
		String status = resultBody.get("status").toString();
		
		JSONArray data = new JSONArray();
		
		if(status.equals("ok")){
			data = (JSONArray) resultBody.get("data");
		}
		logger.debug("getAttHistory ended");
		return data;
	}
	
	/**
	 * 관리자 근태조회 리스트 조회
	 */
	@RequestMapping(value = "/ezAttitude/attitudeCheckList.do",method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	@ResponseBody
	public JSONObject getAttitudeCheckList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("/ezAttitude/attitudeCheckList started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String companyId = request.getParameter("companyId");
		String searchUserName = request.getParameter("userName");
		String searchDeptName = request.getParameter("deptName");
		String searchDeptId = request.getParameter("deptId");
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
		String isAdmin = "";
		
		logger.debug("searchUserName = " + searchUserName + " || searchDeptName = " + searchDeptName + " || searchTitle = " + searchTitle + " || searchStartDate = " + searchStartDate
				+ " || searchEndDate = " + searchEndDate + " || searchAttitudeType = " + searchAttitudeType + " || pageNum = " + pageNum + " || listSize = " + listSize
				+ " || orderCell = " + orderCell + "orderOption = " + orderOption + "||searchDeptId =" + searchDeptId);
		
		if (commonUtil.isAdmin(userInfo.getId(), userInfo.getTenantId(), userInfo.getRollInfo(), "c;k;e")) {
			isAdmin = "Y";
		}
		
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
				.queryParam("searchDeptId", searchDeptId)
				.queryParam("searchTitle", searchTitle)
				.queryParam("searchStartDate", searchStartDate)
				.queryParam("searchEndDate", searchEndDate)
				.queryParam("searchAttitudeType", searchAttitudeType)
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
		logger.debug("status : " + status);
		
		JSONObject jObject = new JSONObject();
		if(status.equals("ok")){
			jObject = (JSONObject) resultBody.get("data");
		}
		
		logger.debug("/ezAttitude/attitudeCheckList ended");
		
		return jObject;
	}
	
	/**
	 * 근태 상세보기
	 */
	@RequestMapping(value = "/ezAttitude/attitudeItemDetail.do", method = RequestMethod.GET)
	public String attitudeItemDetail(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		logger.debug("/ezAttitude/attitudeItemDetail started");
		
		String deptId = "";
		@SuppressWarnings("unused")
		String isAllDept = "";
		@SuppressWarnings("unused")
		String adminFlag = "";
		String authFlag = "";
		JSONObject attitudeVO = new JSONObject();
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String font = ezCommonService.getTenantConfig("editorFontStyle", userInfo.getTenantId());
		String userId = userInfo.getId();
		String attitudeId = request.getParameter("attitudeId");
		
		if (attitudeId == null) {
			return "";
		}
		
		String companyID = request.getParameter("companyID");
		String typeId = request.getParameter("typeId");
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		String url = gwServerUrl + "/rest/ezattitude/attitudetypes/" + typeId +"/forms/form";
		
		if (companyID == null || companyID.equals("")) {
			companyID = userInfo.getCompanyID();
		}
		
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
		logger.debug("status : " + status);
		
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
			logger.debug("status : " + status);
			
			if (status.equals("ok")) {
				attitudeVO = (JSONObject) resultBody.get("data");
				model.addAttribute("attitudeInfo", attitudeVO);
			}
		}
		//해당 근태에 대한 부서
		deptId = (String) attitudeVO.get("deptId") == null ? "null" : (String) attitudeVO.get("deptId");
		
		if (commonUtil.isAdmin(userInfo.getId(), userInfo.getTenantId(), userInfo.getRollInfo(), "c;k;e")) {
			adminFlag = "true";
			isAllDept = "Y";
		} else if (commonUtil.isAdmin(userInfo.getId(), userInfo.getTenantId(), userInfo.getRollInfo(), "g")) {
			adminFlag = "true";
		}
		
		url = gwServerUrl + "/rest/ezattitude/users/" + userInfo.getId() + "/attitude-auth/hyo";
		
		headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		entity = new HttpEntity<>(headers);
		
		builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("companyId", companyID)
				.queryParam("listAuthType", "M")
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
		
		//권한 부서 목록에서 부서의 권한을 읽음
		for (int i = 0; i < deptList.size(); i++ ){
			JSONObject dept = (JSONObject)deptList.get(i);
			if (dept.get("deptId").equals(deptId)) {
				authFlag = (String) dept.get("authType");
			}
		}
		
		//자신의 부서와 다르고 권한이 없을 경우에는 접근을 제한한다.		
		//아무런 권한이 없으면 접근을 제한한다.
		if (authFlag.equals("")) {
			return "cmm/error/adminDenied";
		}
	
		model.addAttribute("font", font);
		model.addAttribute("authFlag", authFlag);
		model.addAttribute("userInfo",userInfo);
		
		logger.debug("/ezAttitude/attitudeItemDetail ended");
		return "/ezAttitude/attitudeItemDetail";
	}
	
	/**
	 * 관리자 수정 작성화면
	 */
	@RequestMapping(value = "/ezAttitude/attAdminModItem.do", method = RequestMethod.GET)
	public String attAdminModItem(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		logger.debug("/ezAttitude/attAdminModItem started");
		
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
		logger.debug("status : " + status);
		
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
				logger.debug("status : " + status);
				
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
		
		logger.debug("/ezAttitude/attAdminModItem ended");
		return "ezAttitude/attAdminModItem";
	}
	
	/**
	 *  관리자 작성화면
	 */
	@RequestMapping(value = "/ezAttitude/attAdminNewItem.do", method = RequestMethod.GET)
	public String attAdminNewItem(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		logger.debug("/ezAttitude/attAdminNewItem started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String userId = request.getParameter("userid");
		String date = request.getParameter("date");
		String mode = request.getParameter("mode");
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		String userOffset = userInfo.getOffset().split("\\|")[1];
		String url = gwServerUrl + "/rest/ezattitude/companies/" + userInfo.getCompanyID() +"/attitudetypes";
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		MCommonVO info = mOptionService.commonInfoWeb(request.getServerName(), userId);

		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("loginId", userInfo.getId()) // 관리자의 경우 관리자의 언어 세팅에 맞는 화면 표출 필요.
				.queryParam("userId", userId)
				.queryParam("isuse", 1);
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp = new JSONParser();
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		
		String status = resultBody.get("status").toString();
		logger.debug("status : " + status);
		
		JSONArray attitudeTypeList = new JSONArray();
		if (status.equals("ok")) {
			attitudeTypeList = (JSONArray) resultBody.get("data");
		}
		
		//현재시간
		String time = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), userInfo.getOffset(), false).split(" ")[1];
		
		model.addAttribute("userOffset", userOffset);
		//관리자 정보
		model.addAttribute("userInfo", userInfo);
		//사용자 정보
		model.addAttribute("info", info);
		model.addAttribute("attitudeTypeList", attitudeTypeList);
		model.addAttribute("date", date);
		model.addAttribute("time", time);
		model.addAttribute("mode", mode);
		
		logger.debug("/ezAttitude/attAdminNewItem ended");
		return "ezAttitude/attAdminNewItem";
	}
	
	/**
	 *  관리자 작성화면2
	 */
	@RequestMapping(value = "/ezAttitude/attAdminNewItemTwo.do", method = RequestMethod.GET)
	public String attAdminNewItem2(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		logger.debug("/ezAttitude/attAdminNewItem started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String userId = userInfo.getId();
		String date = request.getParameter("date");
		String mode = request.getParameter("mode");
		String companyID = request.getParameter("companyID");
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		String userOffset = userInfo.getOffset().split("\\|")[1];
		
		if (companyID == null || companyID.equals("")) {
			companyID = userInfo.getCompanyID();
		}
		
		String url = gwServerUrl + "/rest/ezattitude/companies/" + companyID +"/attitudetypes";
		
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
		logger.debug("status : " + status);
		
		JSONArray attitudeTypeList = new JSONArray();
		if (status.equals("ok")) {
			attitudeTypeList = (JSONArray) resultBody.get("data");
		}
		
		//현재시간
		String time = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), userInfo.getOffset(), false).split(" ")[1];
		
		model.addAttribute("userOffset", userOffset);
		//관리자 정보
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("companyID", companyID);
		model.addAttribute("attitudeTypeList", attitudeTypeList);
		model.addAttribute("date", date);
		model.addAttribute("time", time);
		model.addAttribute("mode", mode);
		
		logger.debug("/ezAttitude/attAdminNewItem ended");
		return "ezAttitude/attAdminNewItem2";
	}
	
	/**
	 * 사용자 근태 추가 및 수정
	 */
	@RequestMapping(value = "/ezAttitude/attAdminSave.do", method = RequestMethod.POST)
	@ResponseBody
	public String attAdminSave(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("/ezAttitude/attAdminSave started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		// String attitudeId = request.getParameter("attitudeId");
		String typeId = request.getParameter("typeId");
		String region = request.getParameter("region");
		String mobile = request.getParameter("mobile");
		String bizSub = request.getParameter("bizSub");
		String startDate = request.getParameter("startDate");
		String endDate = request.getParameter("endDate");
		String dateType = request.getParameter("dateType");
		String mode = request.getParameter("mode");
		String content = request.getParameter("content");
		String userId = request.getParameter("userId");
		
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		String url = gwServerUrl;
		
		url += "/rest/ezattitude/users/" + userId + "/attitudes";
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("userId", userId)
				.queryParam("adminId", userInfo.getId())
				.queryParam("typeId", typeId)
				.queryParam("region", region)
				.queryParam("mobile", mobile)
				.queryParam("startDate", startDate)
				.queryParam("endDate", endDate)
				.queryParam("bizSub", bizSub)
				.queryParam("content", content)
				.queryParam("dateType", dateType)
				.queryParam("mode", mode);
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.POST, entity, String.class);
		
		JSONParser jp = new JSONParser();
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		
		String status = resultBody.get("status").toString();
		logger.debug("status : " + status);
		
		String resultStatus = "";
		if (status.equals("ok")) {
			resultStatus = resultBody.get("data").toString();
			if (!resultStatus.equals("dupl")) {
				resultStatus = "success";
			}
		} else {
			resultStatus = "error";
		}
		
		logger.debug("/ezAttitude/attAdminSave ended");
		
		return resultStatus;
	}
	
	/**
	 * 관리자 근태 삭제
	 */
	@RequestMapping(value = "/ezAttitude/adminAttiDelItem.do", method = RequestMethod.POST)
	@ResponseBody
	public String adminAttitudeDeleteItem(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("/ezAttitude/attitudeDeleteItem started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String userId = userInfo.getId();
		String attitudeId = request.getParameter("attitudeId");
		String mode = request.getParameter("mode");
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		
		String url = gwServerUrl + "/rest/ezattitude/attitudes/" + attitudeId;
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("userId", userId)
				.queryParam("mode", mode);
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.DELETE, entity, String.class);
		
		JSONParser jp = new JSONParser();
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		
		String status = resultBody.get("status").toString();
		logger.debug("status : " + status);
		
		String resultStatus = "";
		if (status.equals("ok")) {
			resultStatus = "success";
		} else {
			resultStatus = "error";
		}
		
		logger.debug("/ezAttitude/attitudeDeleteItem ended");
		
		return resultStatus;
	}
	
	/**
	 * 근태작성 - 조직도(받는사람,참조,숨은참조) 화면 호출 함수
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/ezAttitude/attNewReceiverChoose.do", method = RequestMethod.GET)
	public String attNewReceiverChoose(
			@CookieValue("loginCookie") String loginCookie, 
			Locale locale, 
			Model model, 
			HttpServletRequest request) throws Exception{
		logger.debug("attNewReceiverChoose started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		@SuppressWarnings("unused")
		String adminFlag = "";
		String isAllDept = "";
		String defaultWin = request.getParameter("defaultwin") == null ? "To" : request.getParameter("defaultwin").trim();
		String type = request.getParameter("type") == null ? "" : request.getParameter("type").trim();
		String ruleKind = request.getParameter("ruleKind") == null ? "" : request.getParameter("ruleKind").trim();
		String companyID = request.getParameter("companyID") == null ? userInfo.getCompanyID() : request.getParameter("companyID");
		String useOcs = config.getProperty("config.USE_OCS") == null ? "" : config.getProperty("config.USE_OCS");
		String primaryLang = ezCommonService.getTenantConfig("PrimaryLang", userInfo.getTenantId());
		
		
		if (commonUtil.isAdmin(userInfo.getId(), userInfo.getTenantId(), userInfo.getRollInfo(), "c;k;e")) {
			adminFlag = "true";
			isAllDept = "Y";
		} else if (commonUtil.isAdmin(userInfo.getId(), userInfo.getTenantId(), userInfo.getRollInfo(), "g")) {
			adminFlag = "true";
		}
		
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		// 2023-10-18 전인하 - 근태관리 > 근태정보관리 > 근태입력 > 대상자 > 조직도 호출 시 사용되는 restAPI 변경
		String url = gwServerUrl + "/rest/ezattitude/users/" + userInfo.getId() + "/attitude-auth/hyo";
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("companyId", companyID)
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
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("selectedDeptID", userInfo.getDeptID());
		model.addAttribute("defaultWin", defaultWin);
		model.addAttribute("type", type);
		model.addAttribute("ruleKind", ruleKind);
		model.addAttribute("useOcs", useOcs);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("companyID", companyID);
		model.addAttribute("primaryLang", primaryLang);
		
		logger.debug("attNewReceiverChoose ended.");
		return "ezAttitude/attNewReceiverChoose";
	}
	
	/**
	 * 근태입력관리, 미입력자관리, 관리내역 엑셀 출력
	 */
	@RequestMapping(value = {"/ezAttitude/excelAttitudeListExport.do", "/ezAttitude/excelAbsentedListExport.do", "/ezAttitude/excelHistoryListExport.do"}, method = RequestMethod.GET)
	@ResponseBody
	public void excelFileExport(@CookieValue("loginCookie")String loginCookie, HttpServletResponse response, HttpServletRequest request) throws Exception{
		logger.debug("excelFileExport started."); 
		
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
		
		if (searchAttitudeType == null || searchAttitudeType.equals("")) {
			searchAttitudeType = "total";
		}
		
		logger.debug("searchUserName = " + searchUserName + " || searchDeptName = " + searchDeptName + " || searchTitle = " + searchTitle + " || searchDeptId = " + searchDeptId
				+ " || searchStartDate = " + searchStartDate + " || searchEndDate = " + searchEndDate + " || searchAttitudeType = " + searchAttitudeType
				+ " || pageNum = " + pageNum + " || listSize = " + listSize + " || orderCell = " + orderCell + " || orderOption = " + orderOption + " || requestURL = " + requestURL);
		
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		String url = "";
		String reqType = "";
		
		if (requestURL.indexOf("excelAttitudeListExport.do") > -1) {
			reqType = "check";
			url = gwServerUrl + "/rest/ezattitude/attitudes/check";
		} else if (requestURL.indexOf("excelAbsentedListExport.do") > -1) {
			reqType = "absent";
			url = gwServerUrl + "/rest/ezattitude/attitudes/absent";
		} else if (requestURL.indexOf("excelHistoryListExport.do") > -1) {
			reqType = "history";
			url = gwServerUrl + "/rest/ezattitude/attitudes/manageHistories";
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
		logger.debug("status : " + status);
		
		JSONObject data = new JSONObject();
		
		List<AdminAttitudeVO> attitudeList = new ArrayList<AdminAttitudeVO>();
		List<ModApplHistoryVO> historylist = new ArrayList<ModApplHistoryVO>();

		Gson gson = new Gson();
		if(status.equals("ok")){
			data = (JSONObject) resultBody.get("data");
			if (reqType.equals("history")) {
				historylist = gson.fromJson(data.get("list").toString(), new TypeToken<List<ModApplHistoryVO>>(){}.getType()) ;
			} else {
				attitudeList = gson.fromJson(data.get("list").toString(), new TypeToken<List<AdminAttitudeVO>>(){}.getType()) ;
			}
		}
		
		// 2023-05-31 이사라 : 시큐어코딩 리소스 close
		try (HSSFWorkbook workbook = new HSSFWorkbook()) {
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
			bodyStyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
			bodyStyle.setWrapText(true);
			
			HSSFFont font = workbook.createFont();
			font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
			headerStyle.setFont(font);
			
			Row row;
			      
			sheet = workbook.createSheet("report");
			row = sheet.createRow(0);
			
			String pFileName = "";
			
			if (reqType.equals("check")) {
	//			근태조회엑셀
				// 2024-03-12 조수빈 - 파일명 다국어 처리 (한국어의 경우 'YYYY-MM-DD_근태입력관리')
				pFileName = EgovDateUtil.getToday("-") + "_" + egovMessageSource.getMessage("ezAttitude.t5", locale).replaceAll(" ", "_");
				
				//header
				row.createCell(0).setCellValue("NO.");
				row.createCell(1).setCellValue(egovMessageSource.getMessage("ezAttitude.t10", locale));
				row.createCell(2).setCellValue(egovMessageSource.getMessage("ezAttitude.t11", locale));
				row.createCell(3).setCellValue(egovMessageSource.getMessage("ezAttitude.t9", locale));
				row.createCell(4).setCellValue(egovMessageSource.getMessage("ezAttitude.t232", locale));
				row.createCell(5).setCellValue(egovMessageSource.getMessage("ezAttitude.t233", locale));
				row.createCell(6).setCellValue(egovMessageSource.getMessage("ezAttitude.kje22", locale));
				row.createCell(7).setCellValue(egovMessageSource.getMessage("ezAttitude.t115", locale));
				row.createCell(8).setCellValue(egovMessageSource.getMessage("ezPersonal.b3", locale));
				row.createCell(9).setCellValue(egovMessageSource.getMessage("ezPersonal.b2", locale));
				row.createCell(10).setCellValue(egovMessageSource.getMessage("ezAttitude.kje23", locale));
				row.createCell(11).setCellValue(egovMessageSource.getMessage("ezPersonal.b10", locale));
				row.createCell(12).setCellValue(egovMessageSource.getMessage("ezAttitude.t254", locale));
				row.createCell(13).setCellValue(egovMessageSource.getMessage("ezAttitude.t255", locale));
				row.createCell(14).setCellValue(egovMessageSource.getMessage("ezAttitude.t256", locale));
				row.createCell(15).setCellValue(egovMessageSource.getMessage("ezAttitude.kje04", locale));
				row.createCell(16).setCellValue(egovMessageSource.getMessage("ezAttitude.kje28", locale));
				row.createCell(17).setCellValue(egovMessageSource.getMessage("ezPersonal.b8", locale));
				row.createCell(18).setCellValue(egovMessageSource.getMessage("ezAttitude.kje24", locale));
				row.createCell(19).setCellValue(egovMessageSource.getMessage("ezAttitude.kje25", locale));
				row.createCell(20).setCellValue(egovMessageSource.getMessage("ezAttitude.kje26", locale));
				row.createCell(21).setCellValue(egovMessageSource.getMessage("ezAttitude.kje27", locale));
				row.createCell(22).setCellValue(egovMessageSource.getMessage("ezPersonal.b7", locale));
				row.getCell(0).setCellStyle(headerStyle);
				row.getCell(1).setCellStyle(headerStyle);
				row.getCell(2).setCellStyle(headerStyle);
				row.getCell(3).setCellStyle(headerStyle);
				row.getCell(4).setCellStyle(headerStyle);
				row.getCell(5).setCellStyle(headerStyle);
				row.getCell(6).setCellStyle(headerStyle);
				row.getCell(7).setCellStyle(headerStyle);
				row.getCell(8).setCellStyle(headerStyle);
				row.getCell(9).setCellStyle(headerStyle);
				row.getCell(10).setCellStyle(headerStyle);
				row.getCell(11).setCellStyle(headerStyle);
				row.getCell(12).setCellStyle(headerStyle);
				row.getCell(13).setCellStyle(headerStyle);
				row.getCell(14).setCellStyle(headerStyle);
				row.getCell(15).setCellStyle(headerStyle);
				row.getCell(16).setCellStyle(headerStyle);
				row.getCell(17).setCellStyle(headerStyle);
				row.getCell(18).setCellStyle(headerStyle);
				row.getCell(19).setCellStyle(headerStyle);
				row.getCell(20).setCellStyle(headerStyle);
				row.getCell(21).setCellStyle(headerStyle);
				row.getCell(22).setCellStyle(headerStyle);
				
				//2020-06-15 김정언 - 엑셀 출력 형식 변경
				List<AdminAttitudeVO2> attitudeList2 = new ArrayList<AdminAttitudeVO2>();
				AdminAttitudeVO2 avo = null;
				boolean flag = true;
				for (int i = 0; i < attitudeList.size() ; i++) {
					if(flag == true){
						avo = new AdminAttitudeVO2();
						flag = false;
					}
					
					if(i + 1 < attitudeList.size()){
						//다음 행과 비교하여 날짜가 같고 사용자의 이름이 같을 경우
						if(attitudeList.get(i).getStartDate().split(" ")[0].equals(attitudeList.get(i + 1).getStartDate().split(" ")[0]) && attitudeList.get(i).getWriterId().equals(attitudeList.get(i + 1).getWriterId())){
							avo.setWriterId(attitudeList.get(i).getWriterId());
							avo.setUserName(attitudeList.get(i).getUserName());
							avo.setUserTitle(attitudeList.get(i).getUserTitle());
							avo.setDeptName(attitudeList.get(i).getDeptName());
							
							if(attitudeList.get(i).getTypeId().equals("A01")) { //출근
								avo.setStartDate(attitudeList.get(i).getStartDate().split("\\.")[0]);
							}else if(attitudeList.get(i).getTypeId().equals("A02")) { //지각
								avo.setStartDate(attitudeList.get(i).getStartDate().split("\\.")[0] + " (" + egovMessageSource.getMessage("ezAttitude.t113", locale) + ")");
							}else if(attitudeList.get(i).getTypeId().equals("A03")) { //퇴근
								avo.setEndDate(attitudeList.get(i).getStartDate().split("\\.")[0]);
							}else if(attitudeList.get(i).getTypeId().equals("A25")) { //전일퇴근
								String[] startDate = attitudeList.get(i).getStartDate().split(" ");
								String dayAfter = commonUtil.getDayAfter(startDate[0]);
								avo.setEndDate(dayAfter + " " + startDate[1].split("\\.")[0]);
							}else if(attitudeList.get(i).getTypeId().equals("A08")) { //조퇴
								avo.setEndDate(attitudeList.get(i).getStartDate().split("\\.")[0] + " (" + egovMessageSource.getMessage("ezAttitude.t114", locale) + ")");
							}else if(attitudeList.get(i).getTypeId().equals("A07")) { //휴근
								String date = avo.getWorkingHoliday() == null ? attitudeList.get(i).getStartDate().split("\\.")[0] + " ~ " + attitudeList.get(i).getEndDate() : avo.getWorkingHoliday() + "\r\n" + attitudeList.get(i).getStartDate().split("\\.")[0] + " ~ " + attitudeList.get(i).getEndDate();
								avo.setWorkingHoliday(date);
							}else if(attitudeList.get(i).getTypeId().equals("A04")) { //외근
								if(attitudeList.get(i).getDateType().equals("4")) {
									avo.setOutsideWork(attitudeList.get(i).getStartDate().split(" ")[0] + " ~ " + attitudeList.get(i).getEndDate().split(" ")[0]);
								}else {
									String date = avo.getOutsideWork() == null ? attitudeList.get(i).getStartDate().split("\\.")[0] + " ~ " + attitudeList.get(i).getEndDate() : avo.getOutsideWork() + "\r\n" + attitudeList.get(i).getStartDate().split("\\.")[0] + " ~ " + attitudeList.get(i).getEndDate();
									avo.setOutsideWork(date);
								}
							}else if(attitudeList.get(i).getTypeId().equals("A06")) { //외출
								String date = avo.getOuting() == null ? attitudeList.get(i).getStartDate().split("\\.")[0] + " ~ " + attitudeList.get(i).getEndTime() : avo.getOuting() + "\r\n" + attitudeList.get(i).getStartDate().split("\\.")[0] + " ~ " + attitudeList.get(i).getEndTime();
								avo.setOuting(date);
							}else if(attitudeList.get(i).getTypeId().equals("A09")) { //출장
								avo.setBusinessTrip(attitudeList.get(i).getStartDate().split(" ")[0] + " ~ " + attitudeList.get(i).getEndDate().split(" ")[0]);
							}else if(attitudeList.get(i).getTypeId().equals("A10")) { //파견
								avo.setDispatch(attitudeList.get(i).getStartDate().split(" ")[0] + " ~ " + attitudeList.get(i).getEndDate().split(" ")[0]);
							}else if(attitudeList.get(i).getTypeId().equals("A17")) { //결근
								avo.setAbsenteeism(attitudeList.get(i).getStartDate().split(" ")[0]);
							}else if(attitudeList.get(i).getTypeId().equals("A11")) { //연차
								avo.setAnnualLeave(attitudeList.get(i).getStartDate().split(" ")[0] + " ~ " + attitudeList.get(i).getEndDate().split(" ")[0]);
							}else if(attitudeList.get(i).getTypeId().equals("A12")) { //오전반차
								avo.setMorningOff(attitudeList.get(i).getStartDate().split(" ")[0] + " ~ " + attitudeList.get(i).getEndDate().split(" ")[0]);
							}else if(attitudeList.get(i).getTypeId().equals("A13")) { //오후반차
								avo.setAfternoonOff(attitudeList.get(i).getStartDate().split(" ")[0] + " ~ " + attitudeList.get(i).getEndDate().split(" ")[0]);
							}else if(attitudeList.get(i).getTypeId().equals("A14")) { //공가
								avo.setOfficialLeave(attitudeList.get(i).getStartDate().split(" ")[0] + " ~ " + attitudeList.get(i).getEndDate().split(" ")[0]);
							}else if(attitudeList.get(i).getTypeId().equals("A15")) { //오전공가
								avo.setmOfficialLeave(attitudeList.get(i).getStartDate().split(" ")[0] + " ~ " + attitudeList.get(i).getEndDate().split(" ")[0]);
							}else if(attitudeList.get(i).getTypeId().equals("A16")) { //오후공가
								avo.setaOfficialLeave(attitudeList.get(i).getStartDate().split(" ")[0] + " ~ " + attitudeList.get(i).getEndDate().split(" ")[0]);
							}else if(attitudeList.get(i).getTypeId().equals("A18")) { //산휴
								avo.setMaternityLeave(attitudeList.get(i).getStartDate().split(" ")[0] + " ~ " + attitudeList.get(i).getEndDate().split(" ")[0]);
							}else if(attitudeList.get(i).getTypeId().equals("A19")) { //경조
								avo.setCongratulationLeave(attitudeList.get(i).getStartDate().split(" ")[0] + " ~ " + attitudeList.get(i).getEndDate().split(" ")[0]);
							}else if(attitudeList.get(i).getTypeId().equals("A20")) { //병가
								avo.setSickLeave(attitudeList.get(i).getStartDate().split(" ")[0] + " ~ " + attitudeList.get(i).getEndDate().split(" ")[0]);
							}else if(attitudeList.get(i).getTypeId().equals("A21")) { //반반차
								String date = avo.getHalfOff() == null ? attitudeList.get(i).getStartDate().split("\\.")[0] + " ~ " + attitudeList.get(i).getEndDate() : avo.getHalfOff() + "\r\n" + attitudeList.get(i).getStartDate().split("\\.")[0] + " ~ " + attitudeList.get(i).getEndDate();
								avo.setHalfOff(date);
							}else if(attitudeList.get(i).getTypeId().equals("A24")) { //대체휴무
								avo.setAlternateHoliday(attitudeList.get(i).getStartDate().split(" ")[0] + " ~ " + attitudeList.get(i).getEndDate().split(" ")[0]);
							}
						} else {						
							//날짜와 사용자의 이름이 다를 경우
							avo.setWriterId(attitudeList.get(i).getWriterId());
							avo.setUserName(attitudeList.get(i).getUserName());
							avo.setUserTitle(attitudeList.get(i).getUserTitle());
							avo.setDeptName(attitudeList.get(i).getDeptName());
							if(attitudeList.get(i).getTypeId().equals("A01")) { //출근
								avo.setStartDate(attitudeList.get(i).getStartDate().split("\\.")[0]);
							}else if(attitudeList.get(i).getTypeId().equals("A02")) { //지각
								avo.setStartDate(attitudeList.get(i).getStartDate().split("\\.")[0] + " (" + egovMessageSource.getMessage("ezAttitude.t113", locale) + ")");
							}else if(attitudeList.get(i).getTypeId().equals("A03")) { //퇴근
								avo.setEndDate(attitudeList.get(i).getStartDate().split("\\.")[0]);
							}else if(attitudeList.get(i).getTypeId().equals("A25")) { //전일퇴근
								String[] startDate = attitudeList.get(i).getStartDate().split(" ");
								String dayAfter = commonUtil.getDayAfter(startDate[0]);
								avo.setEndDate(dayAfter + " " + startDate[1].split("\\.")[0]);
							}else if(attitudeList.get(i).getTypeId().equals("A08")) { //조퇴
								avo.setEndDate(attitudeList.get(i).getStartDate().split("\\.")[0] + " (" + egovMessageSource.getMessage("ezAttitude.t114", locale) + ")");
							}else if(attitudeList.get(i).getTypeId().equals("A07")) { //휴근
								String date = avo.getWorkingHoliday() == null ? attitudeList.get(i).getStartDate().split("\\.")[0] + " ~ " + attitudeList.get(i).getEndDate() : avo.getWorkingHoliday() + "\r\n" + attitudeList.get(i).getStartDate().split("\\.")[0] + " ~ " + attitudeList.get(i).getEndDate();
								avo.setWorkingHoliday(date);
							}else if(attitudeList.get(i).getTypeId().equals("A04")) { //외근
								if(attitudeList.get(i).getDateType().equals("4")) {
									avo.setOutsideWork(attitudeList.get(i).getStartDate().split(" ")[0] + " ~ " + attitudeList.get(i).getEndDate().split(" ")[0]);
								}else {
									String date = avo.getOutsideWork() == null ? attitudeList.get(i).getStartDate().split("\\.")[0] + " ~ " + attitudeList.get(i).getEndDate() : avo.getOutsideWork() + "\r\n" + attitudeList.get(i).getStartDate().split("\\.")[0] + " ~ " + attitudeList.get(i).getEndDate();
									avo.setOutsideWork(date);
								}
							}else if(attitudeList.get(i).getTypeId().equals("A06")) { //외출
								String date = avo.getOuting() == null ? attitudeList.get(i).getStartDate().split("\\.")[0] + " ~ " + attitudeList.get(i).getEndTime() : avo.getOuting() + "\r\n" + attitudeList.get(i).getStartDate().split("\\.")[0] + " ~ " + attitudeList.get(i).getEndTime();
								avo.setOuting(date);
							}else if(attitudeList.get(i).getTypeId().equals("A09")) { //출장
								avo.setBusinessTrip(attitudeList.get(i).getStartDate().split(" ")[0] + " ~ " + attitudeList.get(i).getEndDate().split(" ")[0]);
							}else if(attitudeList.get(i).getTypeId().equals("A10")) { //파견
								avo.setDispatch(attitudeList.get(i).getStartDate().split(" ")[0] + " ~ " + attitudeList.get(i).getEndDate().split(" ")[0]);
							}else if(attitudeList.get(i).getTypeId().equals("A17")) { //결근
								avo.setAbsenteeism(attitudeList.get(i).getStartDate().split(" ")[0]);
							}else if(attitudeList.get(i).getTypeId().equals("A11")) { //연차
								avo.setAnnualLeave(attitudeList.get(i).getStartDate().split(" ")[0] + " ~ " + attitudeList.get(i).getEndDate().split(" ")[0]);
							}else if(attitudeList.get(i).getTypeId().equals("A12")) { //오전반차
								avo.setMorningOff(attitudeList.get(i).getStartDate().split(" ")[0] + " ~ " + attitudeList.get(i).getEndDate().split(" ")[0]);
							}else if(attitudeList.get(i).getTypeId().equals("A13")) { //오후반차
								avo.setAfternoonOff(attitudeList.get(i).getStartDate().split(" ")[0] + " ~ " + attitudeList.get(i).getEndDate().split(" ")[0]);
							}else if(attitudeList.get(i).getTypeId().equals("A14")) { //공가
								avo.setOfficialLeave(attitudeList.get(i).getStartDate().split(" ")[0] + " ~ " + attitudeList.get(i).getEndDate().split(" ")[0]);
							}else if(attitudeList.get(i).getTypeId().equals("A15")) { //오전공가
								avo.setmOfficialLeave(attitudeList.get(i).getStartDate().split(" ")[0] + " ~ " + attitudeList.get(i).getEndDate().split(" ")[0]);
							}else if(attitudeList.get(i).getTypeId().equals("A16")) { //오후공가
								avo.setaOfficialLeave(attitudeList.get(i).getStartDate().split(" ")[0] + " ~ " + attitudeList.get(i).getEndDate().split(" ")[0]);
							}else if(attitudeList.get(i).getTypeId().equals("A18")) { //산휴
								avo.setMaternityLeave(attitudeList.get(i).getStartDate().split(" ")[0] + " ~ " + attitudeList.get(i).getEndDate().split(" ")[0]);
							}else if(attitudeList.get(i).getTypeId().equals("A19")) { //경조
								avo.setCongratulationLeave(attitudeList.get(i).getStartDate().split(" ")[0] + " ~ " + attitudeList.get(i).getEndDate().split(" ")[0]);
							}else if(attitudeList.get(i).getTypeId().equals("A20")) { //병가
								avo.setSickLeave(attitudeList.get(i).getStartDate().split(" ")[0] + " ~ " + attitudeList.get(i).getEndDate().split(" ")[0]);
							}else if(attitudeList.get(i).getTypeId().equals("A21")) { //반반차
								String date = avo.getHalfOff() == null ? attitudeList.get(i).getStartDate().split("\\.")[0] + " ~ " + attitudeList.get(i).getEndDate() : avo.getHalfOff() + "\r\n" + attitudeList.get(i).getStartDate().split("\\.")[0] + " ~ " + attitudeList.get(i).getEndDate();
								avo.setHalfOff(date);
							}else if(attitudeList.get(i).getTypeId().equals("A24")) { //대체휴무
								avo.setAlternateHoliday(attitudeList.get(i).getStartDate().split(" ")[0] + " ~ " + attitudeList.get(i).getEndDate().split(" ")[0]);
							}
							
							attitudeList2.add(avo);
							flag = true;					
						}
					} else { //마지막 것은 비교하지 않는다.
						avo.setWriterId(attitudeList.get(i).getWriterId());
						avo.setUserName(attitudeList.get(i).getUserName());
						avo.setUserTitle(attitudeList.get(i).getUserTitle());
						avo.setDeptName(attitudeList.get(i).getDeptName());
	
						if(attitudeList.get(i).getTypeId().equals("A01")) { //출근
							avo.setStartDate(attitudeList.get(i).getStartDate().split("\\.")[0]);
						}else if(attitudeList.get(i).getTypeId().equals("A02")) { //지각
							avo.setStartDate(attitudeList.get(i).getStartDate().split("\\.")[0] + " (" + egovMessageSource.getMessage("ezAttitude.t113", locale) + ")");
						}else if(attitudeList.get(i).getTypeId().equals("A03")) { //퇴근
							avo.setEndDate(attitudeList.get(i).getStartDate().split("\\.")[0]);
						}else if(attitudeList.get(i).getTypeId().equals("A25")) { //전일퇴근
							String[] startDate = attitudeList.get(i).getStartDate().split(" ");
							String dayAfter = commonUtil.getDayAfter(startDate[0]);
							avo.setEndDate(dayAfter + " " + startDate[1].split("\\.")[0]);
						}else if(attitudeList.get(i).getTypeId().equals("A08")) { //조퇴
							avo.setEndDate(attitudeList.get(i).getStartDate().split("\\.")[0] + " (" + egovMessageSource.getMessage("ezAttitude.t114", locale) + ")");
						}else if(attitudeList.get(i).getTypeId().equals("A07")) { //휴근
							String date = avo.getWorkingHoliday() == null ? attitudeList.get(i).getStartDate().split("\\.")[0] + " ~ " + attitudeList.get(i).getEndDate() : avo.getWorkingHoliday() + "\r\n" + attitudeList.get(i).getStartDate().split("\\.")[0] + " ~ " + attitudeList.get(i).getEndDate();
							avo.setWorkingHoliday(date);
						}else if(attitudeList.get(i).getTypeId().equals("A04")) { //외근
							if(attitudeList.get(i).getDateType().equals("4")) {
								avo.setOutsideWork(attitudeList.get(i).getStartDate().split(" ")[0] + " ~ " + attitudeList.get(i).getEndDate().split(" ")[0]);
							}else {
								String date = avo.getOutsideWork() == null ? attitudeList.get(i).getStartDate().split("\\.")[0] + " ~ " + attitudeList.get(i).getEndDate() : avo.getOutsideWork() + "\r\n" + attitudeList.get(i).getStartDate().split("\\.")[0] + " ~ " + attitudeList.get(i).getEndDate();
								avo.setOutsideWork(date);
							}
						}else if(attitudeList.get(i).getTypeId().equals("A06")) { //외출
							String date = avo.getOuting() == null ? attitudeList.get(i).getStartDate().split("\\.")[0] + " ~ " + attitudeList.get(i).getEndTime() : avo.getOuting() + "\r\n" + attitudeList.get(i).getStartDate().split("\\.")[0] + " ~ " + attitudeList.get(i).getEndTime();
							avo.setOuting(date);
						}else if(attitudeList.get(i).getTypeId().equals("A09")) { //출장
							avo.setBusinessTrip(attitudeList.get(i).getStartDate().split(" ")[0] + " ~ " + attitudeList.get(i).getEndDate().split(" ")[0]);
						}else if(attitudeList.get(i).getTypeId().equals("A10")) { //파견
							avo.setDispatch(attitudeList.get(i).getStartDate().split(" ")[0] + " ~ " + attitudeList.get(i).getEndDate().split(" ")[0]);
						}else if(attitudeList.get(i).getTypeId().equals("A17")) { //결근
							avo.setAbsenteeism(attitudeList.get(i).getStartDate().split(" ")[0]);
						}else if(attitudeList.get(i).getTypeId().equals("A11")) { //연차
							avo.setAnnualLeave(attitudeList.get(i).getStartDate().split(" ")[0] + " ~ " + attitudeList.get(i).getEndDate().split(" ")[0]);
						}else if(attitudeList.get(i).getTypeId().equals("A12")) { //오전반차
							avo.setMorningOff(attitudeList.get(i).getStartDate().split(" ")[0] + " ~ " + attitudeList.get(i).getEndDate().split(" ")[0]);
						}else if(attitudeList.get(i).getTypeId().equals("A13")) { //오후반차
							avo.setAfternoonOff(attitudeList.get(i).getStartDate().split(" ")[0] + " ~ " + attitudeList.get(i).getEndDate().split(" ")[0]);
						}else if(attitudeList.get(i).getTypeId().equals("A14")) { //공가
							avo.setOfficialLeave(attitudeList.get(i).getStartDate().split(" ")[0] + " ~ " + attitudeList.get(i).getEndDate().split(" ")[0]);
						}else if(attitudeList.get(i).getTypeId().equals("A15")) { //오전공가
							avo.setmOfficialLeave(attitudeList.get(i).getStartDate().split(" ")[0] + " ~ " + attitudeList.get(i).getEndDate().split(" ")[0]);
						}else if(attitudeList.get(i).getTypeId().equals("A16")) { //오후공가
							avo.setaOfficialLeave(attitudeList.get(i).getStartDate().split(" ")[0] + " ~ " + attitudeList.get(i).getEndDate().split(" ")[0]);
						}else if(attitudeList.get(i).getTypeId().equals("A18")) { //산휴
							avo.setMaternityLeave(attitudeList.get(i).getStartDate().split(" ")[0] + " ~ " + attitudeList.get(i).getEndDate().split(" ")[0]);
						}else if(attitudeList.get(i).getTypeId().equals("A19")) { //경조
							avo.setCongratulationLeave(attitudeList.get(i).getStartDate().split(" ")[0] + " ~ " + attitudeList.get(i).getEndDate().split(" ")[0]);
						}else if(attitudeList.get(i).getTypeId().equals("A20")) { //병가
							avo.setSickLeave(attitudeList.get(i).getStartDate().split(" ")[0] + " ~ " + attitudeList.get(i).getEndDate().split(" ")[0]);
						}else if(attitudeList.get(i).getTypeId().equals("A21")) { //반반차
							String date = avo.getHalfOff() == null ? attitudeList.get(i).getStartDate().split("\\.")[0] + " ~ " + attitudeList.get(i).getEndDate() : avo.getHalfOff() + "\r\n" + attitudeList.get(i).getStartDate().split("\\.")[0] + " ~ " + attitudeList.get(i).getEndDate();
							avo.setHalfOff(date);
						}else if(attitudeList.get(i).getTypeId().equals("A24")) { //대체휴무
							avo.setAlternateHoliday(attitudeList.get(i).getStartDate().split(" ")[0] + " ~ " + attitudeList.get(i).getEndDate().split(" ")[0]);
						}
						
						attitudeList2.add(avo);
					}
				}
				
				for (int i = 0 ; i < attitudeList2.size(); i++) { 
					row = sheet.createRow(i + 1);
					
					row.createCell(0).setCellValue(i + 1);
					row.createCell(1).setCellValue(attitudeList2.get(i).getUserName());
					row.createCell(2).setCellValue(attitudeList2.get(i).getUserTitle());
					row.createCell(3).setCellValue(attitudeList2.get(i).getDeptName());
					row.createCell(4).setCellValue(attitudeList2.get(i).getStartDate());					
					row.createCell(5).setCellValue(attitudeList2.get(i).getEndDate());					
					row.createCell(6).setCellValue(attitudeList2.get(i).getWorkingHoliday());								
					row.createCell(7).setCellValue(attitudeList2.get(i).getOutsideWork());
					row.createCell(8).setCellValue(attitudeList2.get(i).getOuting());
					row.createCell(9).setCellValue(attitudeList2.get(i).getBusinessTrip());
					row.createCell(10).setCellValue(attitudeList2.get(i).getDispatch());
					row.createCell(11).setCellValue(attitudeList2.get(i).getAbsenteeism());
					row.createCell(12).setCellValue(attitudeList2.get(i).getAnnualLeave());
					row.createCell(13).setCellValue(attitudeList2.get(i).getMorningOff());
					row.createCell(14).setCellValue(attitudeList2.get(i).getAfternoonOff());
					row.createCell(15).setCellValue(attitudeList2.get(i).getHalfOff());
					row.createCell(16).setCellValue(attitudeList2.get(i).getAlternateHoliday());
					row.createCell(17).setCellValue(attitudeList2.get(i).getOfficialLeave());
					row.createCell(18).setCellValue(attitudeList2.get(i).getmOfficialLeave());
					row.createCell(19).setCellValue(attitudeList2.get(i).getaOfficialLeave());
					row.createCell(20).setCellValue(attitudeList2.get(i).getMaternityLeave());
					row.createCell(21).setCellValue(attitudeList2.get(i).getCongratulationLeave());
					row.createCell(22).setCellValue(attitudeList2.get(i).getSickLeave());
					
					row.getCell(0).setCellStyle(bodyStyle);
					row.getCell(1).setCellStyle(bodyStyle);
					row.getCell(2).setCellStyle(bodyStyle);
					row.getCell(3).setCellStyle(bodyStyle);
					row.getCell(4).setCellStyle(bodyStyle);
					row.getCell(5).setCellStyle(bodyStyle);
					row.getCell(6).setCellStyle(bodyStyle);
					row.getCell(7).setCellStyle(bodyStyle);
					row.getCell(8).setCellStyle(bodyStyle);
					row.getCell(9).setCellStyle(bodyStyle);
					row.getCell(10).setCellStyle(bodyStyle);
					row.getCell(11).setCellStyle(bodyStyle);
					row.getCell(12).setCellStyle(bodyStyle);
					row.getCell(13).setCellStyle(bodyStyle);
					row.getCell(14).setCellStyle(bodyStyle);
					row.getCell(15).setCellStyle(bodyStyle);
					row.getCell(16).setCellStyle(bodyStyle);
					row.getCell(17).setCellStyle(bodyStyle);
					row.getCell(18).setCellStyle(bodyStyle);
					row.getCell(19).setCellStyle(bodyStyle);
					row.getCell(20).setCellStyle(bodyStyle);
					row.getCell(21).setCellStyle(bodyStyle);
					row.getCell(22).setCellStyle(bodyStyle);
				}
				
				// width 조정
				for (int i = 0, len = 23; i < len; i++) {
					sheet.autoSizeColumn(i);
					
					/* 2024-11-05 홍승비 - 엑셀 파일 저장 시 동적인 너비 계산이 setColumnWidth()에서 허용하는 최대 제한을 넘지 않도록 수정 (255 * 256 = 65280) */
					sheet.setColumnWidth(i, Math.min(65280, sheet.getColumnWidth(i) + 512));
				}			
			} else if (reqType.equals("absent")) {
	//			미입력자조회엑셀
				// 2024-03-12 조수빈 - 파일명 다국어 처리 (한국어의 경우 'YYYY-MM-DD_미입력자관리')
				pFileName = EgovDateUtil.getToday("-") + "_" + egovMessageSource.getMessage("ezAttitude.t6", locale);
				
				// header
				row.createCell(0).setCellValue("NO");
				row.createCell(1).setCellValue(egovMessageSource.getMessage("ezAttitude.t133", locale));
				row.createCell(2).setCellValue(egovMessageSource.getMessage("ezAttitude.t10", locale));
				row.createCell(3).setCellValue(egovMessageSource.getMessage("ezAttitude.t11", locale));
				row.createCell(4).setCellValue(egovMessageSource.getMessage("ezAttitude.t9", locale));
				row.getCell(0).setCellStyle(headerStyle);
				row.getCell(1).setCellStyle(headerStyle);
				row.getCell(2).setCellStyle(headerStyle);
				row.getCell(3).setCellStyle(headerStyle);
				row.getCell(4).setCellStyle(headerStyle);
				
				// body
				for (int i = 0 ; i < attitudeList.size(); i++) { 
					AdminAttitudeVO vo = attitudeList.get(i);
					row = sheet.createRow(i + 1);
					
					row.createCell(0).setCellValue(i + 1);
					row.createCell(1).setCellValue(vo.getStartDate());
					row.createCell(2).setCellValue(vo.getUserName());
					row.createCell(3).setCellValue(vo.getUserTitle());
					row.createCell(4).setCellValue(vo.getDeptName());
					
					row.getCell(0).setCellStyle(bodyStyle);
					row.getCell(1).setCellStyle(bodyStyle);
					row.getCell(2).setCellStyle(bodyStyle);
					row.getCell(3).setCellStyle(bodyStyle);
					row.getCell(4).setCellStyle(bodyStyle);
	
				}
				// width 조정
				sheet.autoSizeColumn(0);
				sheet.autoSizeColumn(1);
				sheet.autoSizeColumn(2);
				sheet.autoSizeColumn(3);
				sheet.autoSizeColumn(4);
				sheet.setColumnWidth(0, (sheet.getColumnWidth(0)) + 512);
				sheet.setColumnWidth(1, (sheet.getColumnWidth(1)) + 512);
				sheet.setColumnWidth(2, (sheet.getColumnWidth(2)) + 512);
				sheet.setColumnWidth(3, (sheet.getColumnWidth(3)) + 512);
				sheet.setColumnWidth(4, (sheet.getColumnWidth(4)) + 512);
				
			} else if (reqType.equals("history")) {
	//			관리내역조회엑셀
				// 2024-03-12 조수빈 - 파일명 다국어 처리 (한국어의 경우 'YYYY-MM-DD_관리내역')
				pFileName = EgovDateUtil.getToday("-") + "_" + egovMessageSource.getMessage("ezAttitude.t57", locale);
				
				//header
				row.createCell(0).setCellValue("NO");
				row.createCell(1).setCellValue(egovMessageSource.getMessage("ezAttitude.t10", locale));
				row.createCell(2).setCellValue(egovMessageSource.getMessage("ezAttitude.t11", locale));
				row.createCell(3).setCellValue(egovMessageSource.getMessage("ezAttitude.t9", locale));
				row.createCell(4).setCellValue(egovMessageSource.getMessage("ezAttitude.t149", locale));
				row.createCell(5).setCellValue(egovMessageSource.getMessage("ezAttitude.t134", locale));
				row.createCell(6).setCellValue(egovMessageSource.getMessage("ezAttitude.t62", locale));
				row.createCell(7).setCellValue(egovMessageSource.getMessage("ezAttitude.t63", locale));
				row.getCell(0).setCellStyle(headerStyle);
				row.getCell(1).setCellStyle(headerStyle);
				row.getCell(2).setCellStyle(headerStyle);
				row.getCell(3).setCellStyle(headerStyle); 
				row.getCell(4).setCellStyle(headerStyle);
				row.getCell(5).setCellStyle(headerStyle);
				row.getCell(6).setCellStyle(headerStyle);
				row.getCell(7).setCellStyle(headerStyle);
				
				//body
				for (int i = 0 ; i < historylist.size(); i++) { 
					ModApplHistoryVO vo = historylist.get(i);
					row = sheet.createRow(i + 1);
	
					row.createCell(0).setCellValue(i + 1);
					row.createCell(1).setCellValue(vo.getWriterName());
					row.createCell(2).setCellValue(vo.getWriterTitle());
					row.createCell(3).setCellValue(vo.getWriterDeptName());
					String date = "";
					if (vo.getOriginStartdate() == null || vo.getOriginStartdate().equals("")) {
						date += "미입력";
					} else {
						if (vo.getOriginEnddate() == null || vo.getOriginEnddate().equals("")) {
		   					date += vo.getOriginStartdate();
		   				} else {
		   					date += vo.getOriginStartdate() + " ~ " + vo.getOriginEnddate();
		   				}
					}
					
					if (vo.getChangeStartdate() == null || vo.getChangeStartdate().equals("")) {
						date += " -> 삭제";
					} else {
			   			if (vo.getChangeEnddate() == null || vo.getChangeEnddate().length() == 0) {
			   				date += " -> " + vo.getChangeStartdate();
			   			} else {
			   				date += " -> " + vo.getChangeStartdate() + " ~ " + vo.getChangeEnddate();
			   			}
		   			}
					row.createCell(4).setCellValue(date);
					
					String type = "";
					if (vo.getOriginTypeName() == null || vo.getOriginTypeName().equals("")) {
		   				type += "미입력 -> " + vo.getChangeTypeName();
	    			} else {
	    				if (vo.getChangeTypeName() == null || vo.getChangeTypeName().equals("")) {
	    					type += vo.getOriginTypeName() + " -> 삭제";
	    				} else {
		    				type += vo.getOriginTypeName() + " -> " + vo.getChangeTypeName();
	    				}
	    			}
					
					row.createCell(5).setCellValue(type);
					row.createCell(6).setCellValue(vo.getApprUserName());
					row.createCell(7).setCellValue(vo.getApprDate());
					
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
			}
			
			response.setHeader("Content-Disposition", "attachment; fileName=\"" + URLEncoder.encode(pFileName, "UTF-8") + ".xls\"");
			workbook.write(response.getOutputStream());
			
			//workbook.close();
			
			logger.debug("excelFileExport ended.");
		}
	}
	
	/**
	 * 조직도 부서 및 사원목록 검색 함수
	 */
	@RequestMapping(value = "/ezAttitude/getSearchList.do", produces="text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getSearchList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception{
	    logger.debug("getSearchList started.");

	    LoginVO userInfo = commonUtil.userInfo(loginCookie);
	    
	    String searchlist = request.getParameter("search").trim();
		String celllist = request.getParameter("cell");
		String proplist = request.getParameter("prop");
		String listtype = request.getParameter("type"); // 항상 "user"로 고정
		String companyID = request.getParameter("companyID") == null ? userInfo.getCompanyID() : request.getParameter("companyID");
		String lang = userInfo.getPrimary();
		String page = request.getParameter("page") == null ? "1" : request.getParameter("page");
		
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		String url = gwServerUrl + "/rest/ezAttitude/getSearchList.do";
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("companyID", companyID)
				.queryParam("userId", userInfo.getId())
				.queryParam("searchlist", searchlist)
				.queryParam("celllist", celllist)
				.queryParam("proplist", proplist)
				.queryParam("listtype", listtype)
				.queryParam("lang", lang)
				.queryParam("page", page);
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp = new JSONParser();
		
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		
		String status = resultBody.get("status").toString();
		
		String data = "";
		
		if(status.equals("ok")){
			data = (String) resultBody.get("data");
		}
	    
		userInfo = commonUtil.aprUserInfo(loginCookie);
		
        int tenantID = userInfo.getTenantId();        
        
        logger.debug("tenantID=" + tenantID);       
		
		String XMLResult = data;
		XMLResult = XMLResult.replaceAll("null", "");
		
		logger.debug("getSearchList ended.");
		return XMLResult;
	}
	
	@RequestMapping(value="/ezAttitude/attitudeModHistory.do",method=RequestMethod.GET, produces="application/json; charset=UTF-8")
	public String attitudeModHistory(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response,Model model) throws Exception{
		logger.debug("attitudeModHistory started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String attModId = request.getParameter("attModId");
		String companyId = request.getParameter("companyId");
		
		if (companyId == null || companyId.equals("")) {
			companyId = userInfo.getCompanyID();
		}
		
		model.addAttribute("attModId", attModId);
		model.addAttribute("companyId", companyId);
		
		
		logger.debug("attitudeModHistory ended");
		
		return "/ezAttitude/attitudeModHistory";
	}
	
	@RequestMapping(value = "/ezAttitude/attitudeUserAnnual.do")
	public String attitudeUserAnnual(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception{
		logger.debug("attitudeUserAnnual started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String userId = userInfo.getId();
		String companyId = userInfo.getCompanyID();
		
		if (userId != null) {
			String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
			String url = gwServerUrl + "/rest/ezattitude/companies/" + companyId + "/annualreg";
			
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
			
			JSONObject dataObject = new JSONObject();
			JSONArray typeListData = new JSONArray();
			
			if (status.equals("ok")) {
				dataObject = (JSONObject) resultBody.get("data");
				model.addAttribute("annualconfig", dataObject);
				typeListData = (JSONArray) resultBody.get("typeList");
				model.addAttribute("A11typeInfo", typeListData.get(0));
				model.addAttribute("A12typeInfo", typeListData.get(1));
				model.addAttribute("A13typeInfo", typeListData.get(2));
				model.addAttribute("A21typeInfo", typeListData.get(3));

			}
			
			gwServerUrl = config.getProperty("config.attitudeGwServerURL");
			url = gwServerUrl + "/rest/ezattitude/users/" + userId + "/joindate";
			
			headers = new HttpHeaders();
			headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
			headers.set("x-user-host", request.getServerName());
			
			entity = new HttpEntity<>(headers);
			builder = UriComponentsBuilder.fromHttpUrl(url)
					.queryParam("companyId", companyId);
			
			rest = new RestTemplate();
			
			result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
			
			jp = new JSONParser();
			resultBody = (JSONObject) jp.parse(result.getBody());
			
			status = resultBody.get("status").toString();
			
			if (status.equals("ok")) {
				String joinDate = resultBody.get("data").toString();
				model.addAttribute("joinDate", joinDate);
			}
		}
		
		logger.debug("attitudeUserAnnual ended.");

		return "/ezAttitude/attitudeUserAnnual";
	}
	
	@RequestMapping(value = "/ezAttitude/getUserAnnualList.do")
	public String getUserAnnualList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception{
		logger.debug("getUserAnnualList started.");
		//해당 사원 정보 (사원이름 직위 부서), 지각 수, 연차 수, 반차들 수, 연차 리스트
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		
		String userId = userInfo.getId();
		String companyId = userInfo.getCompanyID();
		String userLang = commonUtil.getPrimaryData(userInfo.getLang(), userInfo.getTenantId());
		String startDate = request.getParameter("startDate");
		String endDate = request.getParameter("endDate");
		String orderCell = request.getParameter("orderCell");
		String orderOption = request.getParameter("orderOption");
		String secondYear = request.getParameter("secondYear");
		
		if (userId != null) {
			String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
			String url = gwServerUrl + "/rest/ezattitude/users/" + userId + "/" + userLang + "/annual";
			
			HttpHeaders headers = new HttpHeaders();
			headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
			headers.set("x-user-host", request.getServerName());
			
			HttpEntity<?> entity = new HttpEntity<>(headers);
			UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
					.queryParam("companyId", companyId)
					.queryParam("startDate", startDate)
					.queryParam("endDate", endDate)
					.queryParam("orderCell", orderCell)
					.queryParam("orderOption", orderOption)
					.queryParam("secondYear", secondYear)
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
		
		logger.debug("getUserAnnualList ended.");
		
		return "json";
	}
	
	/**
	 * 근태통계 리스트
	 */
	@RequestMapping(value = "/ezAttitude/getMonthlyAnnualList.do")
	@ResponseBody
	public JSONArray getMonthlyAnnualList(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		logger.debug("/ezAttitude/getMonthlyAnnualList started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String userId = userInfo.getId();
		String companyId = userInfo.getCompanyID();
		String userOffset = userInfo.getOffset();
		String year = request.getParameter("year");
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		String url = gwServerUrl + "/rest/ezattitude/users/" + userId + "/monthlyannual";
		
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("userId", userId)
				.queryParam("companyId", companyId)
				.queryParam("offset", userOffset)
				.queryParam("year", year);
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp = new JSONParser();
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		
		String status = resultBody.get("status").toString();
		logger.debug("status : " + status);
		
		JSONArray list = new JSONArray();
		if (status.equals("ok")) {
			list = (JSONArray) resultBody.get("data");
		}
		
		logger.debug("/ezAttitude/getMonthlyAnnualList ended");
		return list;
	}
	
	/**
	 * 엑셀 출력
	 */
	@RequestMapping(value = "/ezAttitude/excelUserAnnualExport.do")
	@ResponseBody
	public void excelUserAnnualExport(@CookieValue("loginCookie")String loginCookie, HttpServletResponse response, HttpServletRequest request) throws Exception{
		logger.debug("excelAnnualListExport started."); 
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userLang = userInfo.getLang();
		String userId = userInfo.getId();
		String companyId = userInfo.getCompanyID();
		Locale locale = userInfo.getLocale();
		
		String year = request.getParameter("year");
		
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		String url = gwServerUrl + "/rest/ezattitude/users/" + userId + "/" + userLang + "/annual";
		
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
		logger.debug("status : " + status);
		
		JSONArray data = new JSONArray();
		
		List<AdminAttitudeVO> annualList = new ArrayList<AdminAttitudeVO>();

		Gson gson = new Gson();
		if(status.equals("ok")){
			data = (JSONArray) resultBody.get("data");
			annualList = gson.fromJson(data.toString(), new TypeToken<List<AdminAttitudeVO>>(){}.getType()) ;
		}
		
		// 2023-05-31 이사라 : 시큐어코딩 리소스 close
		try (HSSFWorkbook workbook = new HSSFWorkbook()) {
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
		font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
		headerStyle.setFont(font);
		
		Row row;
		      
		sheet = workbook.createSheet("report");
		row = sheet.createRow(0);
		
		String pFileName = "";
		pFileName = EgovDateUtil.getToday("-") +"_annualReport";
		
		// header
		row.createCell(0).setCellValue("NO");
		row.createCell(1).setCellValue(egovMessageSource.getMessage("ezAttitude.t107", locale));
		row.createCell(2).setCellValue(egovMessageSource.getMessage("ezAttitude.t35", locale));
		row.createCell(3).setCellValue(egovMessageSource.getMessage("ezAttitude.t252", locale));
		row.createCell(4).setCellValue("내용");
		row.getCell(0).setCellStyle(headerStyle);
		row.getCell(1).setCellStyle(headerStyle);
		row.getCell(2).setCellStyle(headerStyle);
		row.getCell(3).setCellStyle(headerStyle);
		row.getCell(4).setCellStyle(headerStyle);
		
		// body
		for (int i = 0 ; i < annualList.size(); i++) { 
			AdminAttitudeVO vo = annualList.get(i);
			row = sheet.createRow(i + 1);
			
			String content = "";
			
			row.createCell(0).setCellValue(i + 1);
			row.createCell(1).setCellValue((vo.getStartDate() == null ? "" : vo.getStartDate().substring(0, 10)) + (vo.getEndDate() == null ? "" : " ~ " + vo.getEndDate().substring(0, 10)));
			row.createCell(2).setCellValue(vo.getTypeName());
			row.createCell(3).setCellValue(vo.getAnnualCnt());
			if(vo.getContent() != null && !vo.getContent().equals("") && vo.getContent().substring(0, 2).equalsIgnoreCase("<p")) {
				content = vo.getContent().substring(vo.getContent().indexOf(">") + 1, vo.getContent().lastIndexOf("<"));
				content = content.replace("<br>", "\n").replace("&nbsp;", " ");
			}
				
			row.createCell(4).setCellValue(content);
			
			row.getCell(0).setCellStyle(bodyStyle);
			row.getCell(1).setCellStyle(bodyStyle);
			row.getCell(2).setCellStyle(bodyStyle);
			row.getCell(3).setCellStyle(bodyStyle);
			row.getCell(4).setCellStyle(bodyStyle);
		}
		// width 조정
		sheet.autoSizeColumn(0);
		sheet.autoSizeColumn(1);
		sheet.autoSizeColumn(2);
		sheet.autoSizeColumn(3);
		sheet.autoSizeColumn(4);
		sheet.setColumnWidth(0, (sheet.getColumnWidth(0)) + 512);
		sheet.setColumnWidth(1, (sheet.getColumnWidth(1)) + 512);
		sheet.setColumnWidth(2, (sheet.getColumnWidth(2)) + 512);
		sheet.setColumnWidth(3, (sheet.getColumnWidth(3)) + 512);
//		sheet.setColumnWidth(4, (sheet.getColumnWidth(4)) + 512); // 내용은 길어질 수 있으므로 하지 않는다. 최댓값을 넘을 경우 에러나기 때문
			
		response.setHeader("Content-Disposition", "attachment; fileName=\"" + pFileName + ".xls\"");
		workbook.write(response.getOutputStream());
		
		//workbook.close();
		
		logger.debug("excelAnnualListExport ended.");
	}
	}
	
	/**
	 * 연차수정신청
	 */
	@RequestMapping(value = "/ezAttitude/attitudeCancelAnnual.do")
	public String attitudeCancelAnnual(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		logger.debug("/ezAttitude/attitudeCancelAnnual started");
		
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
		logger.debug("status : " + status);
		
		JSONObject formVO = new JSONObject();
		JSONObject attitudeVO = new JSONObject();
		
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
			logger.debug("status : " + status);
			
			if (status.equals("ok")) {
				attitudeVO = (JSONObject) resultBody.get("data");
				model.addAttribute("attitudeInfo", attitudeVO);
			}
			
		} 
		model.addAttribute("userId", userInfo.getId());
		model.addAttribute("font", font);
		
		logger.debug("/ezAttitude/attitudeCancelAnnual ended");
		return "/ezAttitude/attitudeCancelAnnual";
	}
	
	/**
	 * 연차수정(취소)신청
	 */
	@RequestMapping(value = "/ezAttitude/getAttitudeAprInfo.do")
	public String getAttitudeAprInfo(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		logger.debug("/ezAttitude/getAttitudeAprInfo started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String userId = userInfo.getId();
		String attitudeId = request.getParameter("attitudeId");
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		RestTemplate rest = new RestTemplate();
		
		JSONParser jp = new JSONParser();
		
		JSONArray aprList = new JSONArray();
		
		String url = gwServerUrl + "/rest/ezattitude/attitudes/" + attitudeId + "/aprinfo"; // 연차결재정보
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("userId", userId);
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		
		String status = resultBody.get("status").toString();
		logger.debug("status : " + status);
		
		if (status.equals("ok")) {
			aprList = (JSONArray) resultBody.get("data");
			model.addAttribute("list", aprList);
		}
		
		logger.debug("/ezAttitude/attitudeCancelAnnual ended");
		return "json";
	}
	
	/**
	 * 근태수정현황 등록
	 */
	@RequestMapping(value="/ezAttitude/saveCancelAnnual.do" , method= RequestMethod.POST)
	@ResponseBody
	public String saveCancelAnnual(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model,
			@RequestParam(required=false)String attitudeId,
			@RequestParam(required=false)String content,
			@RequestParam(required=false)String idList) throws Exception {
		logger.debug("saveCancelAnnual started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String sysLang = ezCommonService.getTenantConfig("PrimaryLang", userInfo.getTenantId());

		if (userInfo.getLang().equals(sysLang))  {
			sysLang = "primary";
		}
		
		String offset = userInfo.getOffset();
		String offsetMin = commonUtil.getMinuteUTC(offset);
		
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		String url = gwServerUrl + "/rest/ezattitude/attitudes/" + attitudeId + "/savecancelannual";
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("companyId", userInfo.getCompanyID())
				.queryParam("tenantId", userInfo.getTenantId())
				.queryParam("userId", userInfo.getId())
				.queryParam("content", content)
				.queryParam("idList", idList)
				.queryParam("loginCookie", loginCookie)
				.queryParam("offset", offsetMin);
		
		RestTemplate rest = new RestTemplate();

		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.POST, entity, String.class);
		
		JSONParser jp = new JSONParser();
		
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		
		String data = resultBody.get("data").toString();

		logger.debug("saveCancelAnnual ended");
		
		return data;
	}
	
	/**
	 * 참조자 조직도 호출 Method
	 */
	@RequestMapping(value = "/ezAttitude/attitudeSelectReference.do")
	public String circularSelectAttendant(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("attitudeSelectReference started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		logger.debug("attitudeSelectReference ended");
		
		model.addAttribute("userID", userInfo.getId());
		model.addAttribute("deptID", userInfo.getDeptID()); //baonk added
		
		return "/ezAttitude/attitudeSelectReference";
	}
	
	/**
	 * 연차취소신청삭제
	 */
	@RequestMapping(value="/ezAttitude/deleteCancelAnnual.do" , method= RequestMethod.POST)
	@ResponseBody
	public String deleteCancelAnnual(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model,
			@RequestParam(required=false)String attitudeId) throws Exception {
		logger.debug("deleteCancelAnnual started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String sysLang = ezCommonService.getTenantConfig("PrimaryLang", userInfo.getTenantId());

		if (userInfo.getLang().equals(sysLang))  {
			sysLang = "primary";
		}
		
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		String url = gwServerUrl + "/rest/ezattitude/users/"+ userInfo.getId() +"/deletecancelannual";
									
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("companyId", userInfo.getCompanyID())
				.queryParam("tenantId", userInfo.getTenantId())
				.queryParam("attitudeId", attitudeId);
		
		RestTemplate rest = new RestTemplate();

		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.DELETE, entity, String.class);
		
		JSONParser jp = new JSONParser();
		
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		
		String status = resultBody.get("status").toString();

		logger.debug("deleteCancelAnnual ended");
		return status;
	}
	
	/**
	 * 사용자 좌측메뉴
	 * 수정신청관리 -> 수정신청관리
	 */
	@RequestMapping(value="/ezAttitude/manageAnnCanAppList.do")
	public String adminGetAnnCanAppList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model,
			@RequestParam(required=false)String pageNum,
			@RequestParam(required=false)String apprUserName,
			@RequestParam(required=false)String startDate,
			@RequestParam(required=false)String endDate,
			@RequestParam(required=false)String deptid) throws Exception {
		logger.debug("adminGetAnnCanAppList started");
		
		String adminFlag = "true";
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String sysLang = ezCommonService.getTenantConfig("PrimaryLang", userInfo.getTenantId());
        
		if (userInfo.getLang().equals(sysLang))  {
			sysLang = "primary";
		}
		
		if (deptid == null) {
			deptid = userInfo.getDeptID(); 
		}
		
		String offset = userInfo.getOffset();
		String offsetMin = commonUtil.getMinuteUTC(offset);
		
		String url = gwServerUrl + "/rest/ezattitude/users/" + userInfo.getId() + "/attitude-auth/hyo";

		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("companyId", userInfo.getCompanyID())
				.queryParam("listAuthType", "M");
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp = new JSONParser();
		
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		
		String status = resultBody.get("status").toString();
		
		JSONArray deptList = new JSONArray();
		
		if(status.equals("ok")){
			deptList = (JSONArray) resultBody.get("data");
		}

		if (deptList.size() < 1) {
			return "cmm/error/accessDenied";
		}
		
		model.addAttribute("selectedDeptID", deptid);
		model.addAttribute("userLang", userInfo.getLang());
		model.addAttribute("userTimeSet", offset);
		model.addAttribute("offsetMin", offsetMin);
		model.addAttribute("adminFlag", adminFlag);
		model.addAttribute("deptList", deptList);
		
		logger.debug("adminGetAnnCanAppList ended");
		
		return "/ezAttitude/manageAnnCanAppList";
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/ezAttitude/getAnnCanAppList.do",method=RequestMethod.GET, produces="application/json; charset=UTF-8")
	@ResponseBody
	public JSONObject getAnnCanAppList(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, Locale locale, ModelMap modelMap,
			@RequestParam(required=false)String apprUserName,
			@RequestParam(required=false)String writerName,
			@RequestParam(required=false)String writerDeptName,
			@RequestParam(required=false)String startDate,
			@RequestParam(required=false)String endDate,
			@RequestParam(required=false)String pageNum,
			@RequestParam(required=false)String type,
			@RequestParam(required=false)String excelReq,
			@RequestParam(required=false)String orderCell,
			@RequestParam(required=false)String orderOption,
			@RequestParam(required=false)String adminFlag,
			@RequestParam(required=false)String checkAdmin,
			@RequestParam(required=false)String writerDeptId,
			@RequestParam(required=false)String companyId) throws Exception {
		
		logger.debug("getAnnCanAppList started");
		logger.debug("adminFlag = " + adminFlag + " || checkAdmin = " + checkAdmin);
		int currentPage = 1;
		int pageSize = 15;
		int startPoint = 0;
		int endPoint = 15;
		int totalPages = 1;
		int totalAtt = 0;
		String isAllDept = "";
		String authFlag = "";
		
		if (pageNum != null) {
			currentPage = Integer.parseInt(pageNum);
		}
		
		if (excelReq == null) {
			excelReq = "false";
		}
		
		if (adminFlag == null) {
			adminFlag = "false";
		}
		
		if (checkAdmin == null || checkAdmin.trim().equals("")) {
			checkAdmin = "false";
		}
		
		if (checkAdmin.equals("true")) {
			totalPages = 0;
			pageSize = 15;
			startPoint = 0;
			endPoint = 15;
		}
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		if (companyId == null || companyId.equals("")) {
			companyId = userInfo.getCompanyID();
		}
		
		
		
		String offset = userInfo.getOffset();
		String offsetMin = commonUtil.getMinuteUTC(offset);
		
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		String url = gwServerUrl + "/rest/ezattitude/users/"+ userInfo.getId() +"/cancelannual/count";
									
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("companyId", companyId)
				.queryParam("tenantId", userInfo.getTenantId())
				.queryParam("apprUserName", apprUserName)
				.queryParam("writerName", writerName)
				.queryParam("writerDeptName", writerDeptName)
				.queryParam("startDate", startDate)
				.queryParam("endDate", endDate)
				.queryParam("offset", offsetMin)
				.queryParam("pageNum", pageNum)
				.queryParam("type", type)
				.queryParam("orderCell", orderCell)
				.queryParam("orderOption", orderOption)
				.queryParam("adminFlag", adminFlag)
				.queryParam("checkAdmin", checkAdmin)
				.queryParam("deptid", writerDeptId)
				.queryParam("isAllDept", isAllDept);
		
		RestTemplate rest = new RestTemplate();

		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);

		JSONParser jp = new JSONParser();
		
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		
		String status = resultBody.get("status").toString();
		
		JSONObject data = new JSONObject();
		JSONArray list = new JSONArray();
		
		if(status.equals("ok")){
			totalAtt = Integer.parseInt(resultBody.get("data").toString());
		}
		totalPages = (totalAtt + pageSize - 1)/pageSize;
		
		gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		url = gwServerUrl + "/rest/ezattitude/users/"+ userInfo.getId() +"/cancelannual";
		
		headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		entity = new HttpEntity<>(headers);
		
		if (totalPages == 0) {
			totalPages = 1;
		} else {
			if (currentPage < totalPages) {
				startPoint = (currentPage - 1)*pageSize;
				endPoint = currentPage*pageSize;
			}
			else {
				if (currentPage > totalPages) {
					currentPage = totalPages;
				}
				startPoint = (currentPage - 1) * pageSize;
				endPoint = totalAtt;
			}
		}
		
		logger.debug("startPoint : " + startPoint);
		logger.debug("endPoint : " + endPoint);
		logger.debug("currentPage : " + currentPage);
		logger.debug("totalPages : " + totalPages);
		
		if (excelReq.equals("true")) {
			builder = UriComponentsBuilder.fromHttpUrl(url)
					.queryParam("companyId", companyId)
					.queryParam("tenantId", userInfo.getTenantId())
					.queryParam("apprUserName", apprUserName)
					.queryParam("writerName", writerName)
					.queryParam("writerDeptName", writerDeptName)
					.queryParam("startDate", startDate)
					.queryParam("endDate", endDate)
					.queryParam("offset", offsetMin)
					.queryParam("type", type)
					.queryParam("orderCell", orderCell)
					.queryParam("orderOption", orderOption)
					.queryParam("adminFlag", adminFlag)
					.queryParam("checkAdmin", checkAdmin)
					.queryParam("deptid", writerDeptId)
//					.queryParam("isAllDept", isAllDept);
					.queryParam("listAuthType", "M");
		} else {
			builder = UriComponentsBuilder.fromHttpUrl(url)
					.queryParam("companyId", companyId)
					.queryParam("tenantId", userInfo.getTenantId())
					.queryParam("apprUserName", apprUserName)
					.queryParam("writerName", writerName)
					.queryParam("writerDeptName", writerDeptName)
					.queryParam("startDate", startDate)
					.queryParam("endDate", endDate)
					.queryParam("offset", offsetMin)
					.queryParam("startPoint", startPoint)
					.queryParam("endPoint", endPoint)
					.queryParam("type", type)
					.queryParam("orderCell", orderCell)
					.queryParam("orderOption", orderOption)
					.queryParam("adminFlag", adminFlag)
					.queryParam("checkAdmin", checkAdmin)
					.queryParam("deptid", writerDeptId)
//					.queryParam("isAllDept", isAllDept);
					.queryParam("listAuthType", "M");
		}

		rest = new RestTemplate();
		
		result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		jp = new JSONParser();
		
		resultBody = (JSONObject) jp.parse(result.getBody());
		
		status = resultBody.get("status").toString();
		
		data = new JSONObject();
		JSONObject resultj = new JSONObject();
		list = new JSONArray();
		
		if(status.equals("ok")){
			data = (JSONObject) resultBody.get("data");
			list = (JSONArray) data.get("list");
			resultj.put("list", list);
		}
		
		if (commonUtil.isAdmin(userInfo.getId(), userInfo.getTenantId(), userInfo.getRollInfo(), "c;k;e")) {
			adminFlag = "true";
			//권한부서 리스트
			//c , k , e -> 회사의 모든부서
			isAllDept = "Y";
		} else if (commonUtil.isAdmin(userInfo.getId(), userInfo.getTenantId(), userInfo.getRollInfo(), "g")) {
			adminFlag = "true";
			// g -> 자신의 부서 + auth TB 확인해볼것.
		}
		
		url = gwServerUrl + "/rest/ezattitude/users/" + userInfo.getId() + "/attitude-auth/hyo";
		
		headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		entity = new HttpEntity<>(headers);
		
		builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("companyId", userInfo.getCompanyID())
				.queryParam("userId", userInfo.getId())
				.queryParam("isAllDept", isAllDept);
		
		rest = new RestTemplate();
		
		result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		jp = new JSONParser();
		
		resultBody = (JSONObject) jp.parse(result.getBody());
		
		status = resultBody.get("status").toString();
		
		JSONArray deptList = new JSONArray();
		
		if(status.equals("ok")){
			deptList = (JSONArray) resultBody.get("data");
		}
		for (int i = 0; i < deptList.size(); i++ ){
			JSONObject dept = (JSONObject)deptList.get(i);
			if (dept.get("deptId").equals(writerDeptId)) {
				if (!((String) dept.get("authType")).equals("")) {
					authFlag = (String) dept.get("authType");
				}
			}
		}
		
		resultj.put("startDate", startDate);
		resultj.put("endDate", endDate);
		resultj.put("totalAtt", totalAtt);
		resultj.put("totalPages", totalPages);
		resultj.put("authFlag", authFlag);
		
		logger.debug("getAnnCanAppList ended");
		
		return resultj;
	}
	
	/**
	 * 근태 수정 신청 상세
	 */
	@RequestMapping(value="/ezAttitude/annCanAppDetail.do")
	public String annCanAppDetail(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model,
			@RequestParam(required=true)String attModId,
			@RequestParam(required=false)String companyId,
			@RequestParam(required=false)String applCnt,
			@RequestParam(required=false)String adminFlag,
			@RequestParam(required=false)String pageInfo) throws Exception {
		logger.debug("annCanAppDetail started");
		
		String isAllDept = "";
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
		String url = gwServerUrl + "/rest/ezattitude/cancelannual/" + attModId;
									
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
			logger.debug("status : " + status);
			
			JSONObject attitudeConfigVO = new JSONObject();
			if (status.equals("ok")) {
				attitudeConfigVO = (JSONObject) resultBody.get("data");
				model.addAttribute("attitudeConfigVO", attitudeConfigVO);
			}
		}
		
		if (commonUtil.isAdmin(userInfo.getId(), userInfo.getTenantId(), userInfo.getRollInfo(), "c;k;e")) {
			adminFlag = "true";
			isAllDept = "Y";
		} else if (commonUtil.isAdmin(userInfo.getId(), userInfo.getTenantId(), userInfo.getRollInfo(), "g")) {
			adminFlag = "true";
		}
		
		url = gwServerUrl + "/rest/ezattitude/users/" + userInfo.getId() + "/attitude-auth";
		
		headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		entity = new HttpEntity<>(headers);
		
		builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("companyId", companyId)
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
		
		for (int i = 0; i < deptList.size(); i++ ){
			JSONObject dept = (JSONObject)deptList.get(i);
			if (dept.get("deptId").equals(attModDeptId)) {
				if ((String) dept.get("authType") != null && !((String) dept.get("authType")).equals("")) {
					authFlag = (String) dept.get("authType");
				}
				adminFlag = "true";
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
		
		logger.debug("annCanAppDetail ended");
		
		return "/ezAttitude/annCanAppDetail";
	}
	
	@RequestMapping(value="/ezAttitude/changeAnnCanApp.do", method= RequestMethod.POST)
	@ResponseBody
	public String changeAnnCanApp(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model,
			@RequestParam(required=true)String idList,
			@RequestParam(required=true)String changeStatus,
			@RequestParam(required=false)String companyID
			) throws Exception {
		
		logger.debug("changeAnnCanApp started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		if (companyID == null || companyID.equals("")) {
			companyID = userInfo.getCompanyID();
		}
		
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		String url = gwServerUrl + "/rest/ezattitude/users/"+ userInfo.getId() +"/cancelannual";
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("companyId", companyID)
				.queryParam("tenantId", userInfo.getTenantId())
				.queryParam("idList", idList)
				.queryParam("changeStatus", changeStatus);
		
		RestTemplate rest = new RestTemplate();

		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.PUT, entity, String.class);
		
		JSONParser jp = new JSONParser();
		
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		
		String status = resultBody.get("status").toString();

		logger.debug("changeAnnCanApp ended");
		
		return status;
	}
	
	@RequestMapping(value="/ezAttitude/annualCanHistory.do",method=RequestMethod.GET, produces="application/json; charset=UTF-8")
	public String annualCanHistory(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response,Model model) throws Exception{
		logger.debug("annualCanHistory started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String attModId = request.getParameter("attModId");
		String companyId = request.getParameter("companyId");
		
		if (companyId == null || companyId.equals("")) {
			companyId = userInfo.getCompanyID();
		}
		
		model.addAttribute("attModId", attModId);
		model.addAttribute("companyId", companyId);
		
		
		logger.debug("annualCanHistory ended");
		
		return "/ezAttitude/annualCanHistory";
	}
	
	@RequestMapping(value="/ezAttitude/getAnnCanHistory.do",method=RequestMethod.GET, produces="application/json; charset=UTF-8")
	@ResponseBody
	public JSONArray getAnnCanHistory(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, Locale locale, ModelMap modelMap,
		@RequestParam(required=true)String attModId,
		@RequestParam(required=false)String companyId) throws Exception {
		
		logger.debug("getAnnCanHistory started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String sysLang = ezCommonService.getTenantConfig("PrimaryLang", userInfo.getTenantId());
		
		if (userInfo.getLang().equals(sysLang))  {
			sysLang = "primary";
		}
		if (companyId == null || companyId.equals("")) {
			companyId = userInfo.getCompanyID();
		}
		
		String offset = userInfo.getOffset();
		String offsetMin = commonUtil.getMinuteUTC(offset);
		
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		String url = gwServerUrl + "/rest/ezattitude/cancelannual/" + attModId + "/history";
									
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("companyId", companyId)
				.queryParam("tenantId", userInfo.getTenantId())
				.queryParam("userId", userInfo.getId())
				.queryParam("offset", offsetMin);
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp = new JSONParser();
		
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		
		String status = resultBody.get("status").toString();
		
		JSONArray data = new JSONArray();
		
		if(status.equals("ok")){
			data = (JSONArray) resultBody.get("data");
		}
		logger.debug("getAnnCanHistory ended");
		return data;
	}

	/* 2024-07-31 홍승비 - 소스코드 상에서 실제로 호출되지 않는 URL로 확인 */
	/** 
	* 개인 연차 총/사용연차 수 (휴가계 기안시 사용)
	*/
	@RequestMapping(value="/ezAttitude/getAnnaulCntInfo.do" , method= RequestMethod.GET)
	@ResponseBody
	public JSONObject getAnnaulCntInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model,
			@RequestParam(required=false)String attitudeId) throws Exception {
		logger.debug("getAnnaulCntInfo started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String userId = userInfo.getId();
		String companyId = userInfo.getCompanyID();
		
		JSONObject vo = new JSONObject();
		if (userId != null) {
			String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
			String url = gwServerUrl + "/rest/ezattitude/users/"+ userInfo.getId() +"/annualcnt";
			
			HttpHeaders headers = new HttpHeaders();
			headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
			headers.set("x-user-host", request.getServerName());
			
			HttpEntity<?> entity = new HttpEntity<>(headers);
			UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
					.queryParam("startDate", request.getParameter("startDate"))
					.queryParam("endDate", request.getParameter("endDate"))
					.queryParam("secondYear", request.getParameter("secondYear"))
					.queryParam("companyId", companyId);
			
			RestTemplate rest = new RestTemplate();
			
			ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
			
			JSONParser jp = new JSONParser();
			JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
			
			String status = resultBody.get("status").toString();
			
			if (status.equals("ok")) {		
				vo = (JSONObject) resultBody.get("data");
			}
			
		}	
		logger.debug("getAnnaulCntInfo ended");
		return vo;
	}
	
	/**
	* 전자결재 연동 (휴가계 기안시 해당 휴가 근태 등록)
	*/
	@RequestMapping(value="/ezAttitude/approvalGConn.do" , method= RequestMethod.POST)
	@ResponseBody
	public String approvalGConn(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("approvalGConn started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		String url = gwServerUrl + "/rest/ezattitude/users/"+ userInfo.getId() +"/approvalconn";
								
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		RestTemplate rest = new RestTemplate();
		ResponseEntity<String> result = null;
		UriComponentsBuilder builder = null;
		
		if (request.getParameter("status").equals("0")) {
			builder = UriComponentsBuilder.fromHttpUrl(url)
					.queryParam("content", request.getParameter("content"))
					.queryParam("mobile", request.getParameter("mobile"))
					.queryParam("attitudeTypeList", request.getParameter("attitudeTypeList"))
					.queryParam("startDateList", request.getParameter("startDateList"))
					.queryParam("endDateList", request.getParameter("endDateList"))
					.queryParam("startTimeList", request.getParameter("startTimeList"))
					.queryParam("endTimeList", request.getParameter("endTimeList"))
					.queryParam("docId", request.getParameter("docId"));	
			result = rest.exchange(builder.build().encode().toUri(), HttpMethod.POST, entity, String.class);
		} else if (request.getParameter("status").equals("1")) {
			builder = UriComponentsBuilder.fromHttpUrl(url)
					.queryParam("status", request.getParameter("status"))
					.queryParam("docId", request.getParameter("docId"));
			result = rest.exchange(builder.build().encode().toUri(), HttpMethod.PUT, entity, String.class);
		} else {
			builder = UriComponentsBuilder.fromHttpUrl(url)
					.queryParam("type", (request.getParameter("type") == null ? "" : request.getParameter("type")))
					.queryParam("docId", request.getParameter("docId"));
			result = rest.exchange(builder.build().encode().toUri(), HttpMethod.DELETE, entity, String.class);	
		}
		
		JSONParser jp = new JSONParser();
		
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		
		String status = resultBody.get("status").toString();

		logger.debug("approvalGConn ended");
		return status;	
	}
	
	@RequestMapping(value = "/ezAttitude/getAttitudeInfo.do")
	public String getAttitudeInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception{
		logger.debug("getAttitudeInfo started.");
		
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
				.queryParam("userId", userId);
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp = new JSONParser();
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		
		String status = resultBody.get("status").toString();
		
		JSONObject attitudeVO = new JSONObject();
		if (status.equals("ok")) {		
			attitudeVO = (JSONObject) resultBody.get("data");
			
			model.addAttribute("attitudeInfo", attitudeVO);
		}
		
		logger.debug("getAttitudeInfo ended.");
		
		return "json";
	}
	
	/** 
	* 휴가일, 근태가 있는 날 리스트
	*/
	@RequestMapping(value="/ezAttitude/getDisabledDays.do" , method= RequestMethod.GET)
	@ResponseBody
	public JSONArray getDisabledDays(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("getDisabledDays started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		String url = gwServerUrl + "/rest/ezattitude/users/"+ userInfo.getId() +"/approvalconn/disableddays";
									
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("year", request.getParameter("year"))
				.queryParam("month", request.getParameter("month"))
				.queryParam("startDate", request.getParameter("startDate"))
				.queryParam("endDate", request.getParameter("endDate"));
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp = new JSONParser();
		
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		
		String status = resultBody.get("status").toString();
		
		JSONArray data = new JSONArray();
		
		if(status.equals("ok")){
			data = (JSONArray) resultBody.get("data");
		}
		logger.debug("getDisabledDays ended");
		return data;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ezAttitude/getAnnualreg.do")
	@ResponseBody
	public JSONObject getAnnualreg(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception{
		logger.debug("attitudeUserAnnual started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String userId = userInfo.getId();
		String companyId = userInfo.getCompanyID();
		
		JSONObject resultObject = new JSONObject();
		if (userId != null) {
			
			String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
			String url = gwServerUrl + "/rest/ezattitude/companies/" + companyId + "/annualreg";
			
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
			
			JSONObject dataObject = new JSONObject();
			
			if (status.equals("ok")) {
				dataObject = (JSONObject) resultBody.get("data");
				resultObject.put("annualconfig", dataObject);
			}
			
			gwServerUrl = config.getProperty("config.attitudeGwServerURL");
			url = gwServerUrl + "/rest/ezattitude/users/" + userId + "/joindate";
			
			headers = new HttpHeaders();
			headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
			headers.set("x-user-host", request.getServerName());
			
			entity = new HttpEntity<>(headers);
			builder = UriComponentsBuilder.fromHttpUrl(url)
					.queryParam("companyId", companyId);
			
			rest = new RestTemplate();
			
			result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
			
			jp = new JSONParser();
			resultBody = (JSONObject) jp.parse(result.getBody());
			
			status = resultBody.get("status").toString();
			
			if (status.equals("ok")) {
				String joinDate = resultBody.get("data").toString();
				resultObject.put("joinDate", joinDate);
			}
		}
		
		logger.debug("getAnnualreg ended.");

		return resultObject;
	}
	
	/** 
	* 휴가일 리스트
	*/
	@RequestMapping(value="/ezAttitude/getHoliDays.do" , method= RequestMethod.GET)
	@ResponseBody
	public JSONArray getHoliDays(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("getHoliDays started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		String url = gwServerUrl + "/rest/ezattitude/users/"+ userInfo.getId() +"/holidays";
									
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("year", request.getParameter("year"))
				.queryParam("month", request.getParameter("month"))
				.queryParam("startDate", request.getParameter("startDate"))
				.queryParam("endDate", request.getParameter("endDate"));
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp = new JSONParser();
		
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		
		String status = resultBody.get("status").toString();
		
		JSONArray data = new JSONArray();
		
		if(status.equals("ok")){
			data = (JSONArray) resultBody.get("data");
		}
		logger.debug("getHoliDays ended");
		return data;
	}
	
	/**
	 * left 취소신청 갯수
	 * @param loginCookie
	 * @param model
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ezAttitude/getTotalAnnualCount.do", method = RequestMethod.GET)
	@ResponseBody
	public String getTotalAttCount(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		logger.debug("getTotalAttCount started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String isAllDept = "";
		String offset = userInfo.getOffset();
		String offsetMin = commonUtil.getMinuteUTC(offset);			

		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		String url = gwServerUrl + "/rest/ezattitude/users/"+ userInfo.getId() +"/cancelannual/count";
		
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
				.queryParam("offset", offsetMin)
				.queryParam("pageNum", "")
				.queryParam("type", "0")
				.queryParam("orderCell", "")
				.queryParam("orderOption", "")
				.queryParam("adminFlag", "true")
				.queryParam("deptid", "ALL")
				.queryParam("isAllDept", isAllDept);
		
		RestTemplate rest = new RestTemplate();

		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);

		JSONParser jp = new JSONParser();
		
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		
		String status = resultBody.get("status").toString();
		
		String totalAnnual = "";
		
		if (status.equals("ok")) {
			totalAnnual = resultBody.get("data").toString();
		}
		
		logger.debug("getTotalAttCount ended.");
		
		return totalAnnual;
	}
	
	/**
	 * 휴일 출/퇴근 체크 컨피그 조회
	 */
	@RequestMapping(value="/ezAttitude/holidayCheck.do", method = RequestMethod.POST)
	@ResponseBody
	public String getHolidayCheckConfig(@CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("getHolidayCheckConfig started.");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);		
		String useHolidayCheckYN = ezCommonService.getTenantConfig("useHolidayCheckYN", userInfo.getTenantId());
		
		logger.debug("getHolidayCheckConfig ended.");
		return useHolidayCheckYN;
	}
}