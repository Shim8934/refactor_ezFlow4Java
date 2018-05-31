package egovframework.ezEKP.ezAttitude.web;

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
import org.w3c.dom.Element;
import org.w3c.dom.Node;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.ibm.icu.text.SimpleDateFormat;
import com.ibm.icu.util.Calendar;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezAttitude.vo.AdminAttitudeVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeAuthorVO;
import egovframework.ezEKP.ezAttitude.vo.ModApplHistoryVO;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezMobile.ezOption.service.MOptionService;
import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

@Controller
public class EzAttitudeKMSController {
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
	
	@Resource(name = "MOptionService")
	private MOptionService mOptionService;
	
	/**
	 * 근태 수정 신청 현황
	 */
	@RequestMapping(value="/ezAttitude/attModAppList.do")
	public String getAttModAppList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model,
			@RequestParam(required=false)String pageNum,
			@RequestParam(required=false)String apprUserName,
			@RequestParam(required=false)String startDate,
			@RequestParam(required=false)String endDate) throws Exception {
		LOGGER.debug("attModAppList started");
		
		int totalAtt = 0;
		int currentPage = 1;
		int totalPages = 1;
		int pageSize = 15;
		int startPoint = 0;
		int endPoint = 15;
		String type = "all";
		
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
		
		LOGGER.debug("attModAppList ended");
		
		return "/ezAttitude/attModAppList";
	}

	/**
	 * 근태 수정 신청 현황
	 */
	@RequestMapping(value="/ezAttitude/manageAttModAppList.do")
	public String adminGetAttModAppList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model,
			@RequestParam(required=false)String pageNum,
			@RequestParam(required=false)String apprUserName,
			@RequestParam(required=false)String startDate,
			@RequestParam(required=false)String endDate,
			@RequestParam(required=false)String deptid) throws Exception {
		LOGGER.debug("adminGetAttModAppList started");
		
		int totalAtt = 0;
		int currentPage = 1;
		int totalPages = 1;
		int pageSize = 15;
		int startPoint = 0;
		int endPoint = 15;
		String adminFlag = "true";
		String url = "";
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		String isGAdmin = "";
		String authFlag = "";
		String type = "all";
		String isAllDept = "";
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String sysLang = ezCommonService.getTenantConfig("PrimaryLang", userInfo.getTenantId());
		
//		if (userInfo.getRollInfo().indexOf("wa=1") == -1) {
//			return "cmm/error/adminDenied";
//		}
		//근태 관리자가 아니라도 관리자를 볼 수 있다.
        
		if (userInfo.getLang().equals(sysLang))  {
			sysLang = "primary";
		}
		
		if (deptid == null) {
			deptid = userInfo.getDeptID(); 
		}
		
		String offset = userInfo.getOffset();
		String offsetMin = commonUtil.getMinuteUTC(offset);
		
		if ( userInfo.getRollInfo().indexOf("c=1") != -1 ||userInfo.getRollInfo().indexOf("k=1") != -1 || userInfo.getRollInfo().indexOf("wa=1") != -1) {
			adminFlag = "true";
			//권한부서 리스트
			//c , k , wa -> 회사의 모든부서
			isAllDept = "Y";
		} else if (userInfo.getRollInfo().indexOf("g=1") != -1) {
			adminFlag = "true";
			// g -> 자신의 부서 + auth TB 확인해볼것.
		}
		
		url = gwServerUrl + "/rest/ezattitude/users/" + userInfo.getId() + "/attitude-auth";
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("companyId", userInfo.getCompanyID())
				.queryParam("userId", userInfo.getId())
				.queryParam("isAllDept", isAllDept);
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp = new JSONParser();
		
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		
		String status = resultBody.get("status").toString();
		
		JSONArray deptList = new JSONArray();
		
		if(status.equals("ok")){
			deptList = (JSONArray) resultBody.get("data");
		}
		for (int i = 0; i < deptList.size(); i++ ){
			JSONObject dept = (JSONObject)deptList.get(i);
			if (dept.get("deptId").equals(deptid)) {
				if (!((String) dept.get("authType")).equals("")) {
					authFlag = (String) dept.get("authType");
				}
			}
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
		
		model.addAttribute("selectedDeptID", deptid);
		model.addAttribute("userLang", userInfo.getLang());
		model.addAttribute("authFlag", authFlag);
		model.addAttribute("userTimeSet", offset);
		model.addAttribute("offsetMin", offsetMin);
		model.addAttribute("totalAtt", totalAtt);
		model.addAttribute("currentPage", currentPage);
		model.addAttribute("totalPages", totalPages);
		model.addAttribute("adminFlag", adminFlag);
		model.addAttribute("deptList", deptList);
		
		LOGGER.debug("adminGetAttModAppList ended");
		
		return "/ezAttitude/attModAppList";
	}
	
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
		
		LOGGER.debug("getAttModAppList started");
		LOGGER.debug("adminFlag = " + adminFlag + " || checkAdmin = " + checkAdmin);
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
		String sysLang = ezCommonService.getTenantConfig("PrimaryLang", userInfo.getTenantId());
		
		if (companyId == null || companyId.equals("")) {
			companyId = userInfo.getCompanyID();
		}
		
		
		if (userInfo.getLang().equals(sysLang))  {
			sysLang = "primary";
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
				.queryParam("sysLang", sysLang)
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
		
		LOGGER.debug("startPoint : " + startPoint);
		LOGGER.debug("endPoint : " + endPoint);
		LOGGER.debug("currentPage : " + currentPage);
		LOGGER.debug("totalPages : " + totalPages);
		
		if (excelReq.equals("true")) {
			builder = UriComponentsBuilder.fromHttpUrl(url)
					.queryParam("companyId", companyId)
					.queryParam("tenantId", userInfo.getTenantId())
					.queryParam("apprUserName", apprUserName)
					.queryParam("writerName", writerName)
					.queryParam("writerDeptName", writerDeptName)
					.queryParam("startDate", startDate)
					.queryParam("endDate", endDate)
					.queryParam("sysLang", sysLang)
					.queryParam("offset", offsetMin)
					.queryParam("type", type)
					.queryParam("orderCell", orderCell)
					.queryParam("orderOption", orderOption)
					.queryParam("adminFlag", adminFlag)
					.queryParam("checkAdmin", checkAdmin)
					.queryParam("deptid", writerDeptId)
					.queryParam("isAllDept", isAllDept);
		} else {
			builder = UriComponentsBuilder.fromHttpUrl(url)
					.queryParam("companyId", companyId)
					.queryParam("tenantId", userInfo.getTenantId())
					.queryParam("apprUserName", apprUserName)
					.queryParam("writerName", writerName)
					.queryParam("writerDeptName", writerDeptName)
					.queryParam("startDate", startDate)
					.queryParam("endDate", endDate)
					.queryParam("sysLang", sysLang)
					.queryParam("offset", offsetMin)
					.queryParam("startPoint", startPoint)
					.queryParam("endPoint", endPoint)
					.queryParam("type", type)
					.queryParam("orderCell", orderCell)
					.queryParam("orderOption", orderOption)
					.queryParam("adminFlag", adminFlag)
					.queryParam("checkAdmin", checkAdmin)
					.queryParam("deptid", writerDeptId)
					.queryParam("isAllDept", isAllDept);;
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
		
		if (userInfo.getRollInfo().indexOf("c=1") != -1 || userInfo.getRollInfo().indexOf("k=1") != -1 || userInfo.getRollInfo().indexOf("wa=1") != -1) {
			adminFlag = "true";
			//권한부서 리스트
			//c , k , wa -> 회사의 모든부서
			isAllDept = "Y";
		} else if (userInfo.getRollInfo().indexOf("g=1") != -1) {
			adminFlag = "true";
			// g -> 자신의 부서 + auth TB 확인해볼것.
		}
		
		url = gwServerUrl + "/rest/ezattitude/users/" + userInfo.getId() + "/attitude-auth";
		
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
		
		LOGGER.debug("getAttModAppList ended");
		
		return resultj;
	}
	
	@RequestMapping(value = "/ezAttitude/saticGetXlsAtt.do")
	public void qstResultsaticGetXlsAtt(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception{
		LOGGER.debug("qstResultsaticGetXlsAtt started");
		
		String headerFLAG = "";
		 
		if (request.getParameter("headerFlag") != null) {
			headerFLAG = request.getParameter("headerFlag");
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
		 
		Row row;
		Cell cell;
		      
		String pFileName = "";
		String strDate = EgovDateUtil.getToday("-");
		pFileName = strDate+"_Report.xls";
		  
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
		
		response.setHeader("Content-Disposition", "attachment; fileName=\"" + pFileName + ".xls\"");
		workbook.write(response.getOutputStream());
		  
		workbook.close();
		  
		LOGGER.debug("qstResultsaticGetXlsAtt ended");
	}
	
	@RequestMapping(value="/ezAttitude/delAttModApp.do" , method= RequestMethod.POST)
	@ResponseBody
	public String delAttModApp(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model,
			@RequestParam(required=false)String idList) throws Exception {
		LOGGER.debug("delAttModApp started");
		
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

		LOGGER.debug("delAttModApp ended");
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
		String sysLang = ezCommonService.getTenantConfig("PrimaryLang", userInfo.getTenantId());

		String offset = userInfo.getOffset();
		String offsetMin = commonUtil.getMinuteUTC(offset);
		
		if (userInfo.getLang().equals(sysLang))  {
			sysLang = "primary";
		}
		
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
		
		LOGGER.debug("apprAttModApp ended");
		
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
		LOGGER.debug("saveAttModApp started");
		
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

		LOGGER.debug("saveAttModApp ended");
		
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
		LOGGER.debug("modAttModApp started");
		
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

		LOGGER.debug("modAttModApp ended");
		
		return status;
	}
	
	/**
	 * 근태 수정 신청 상세
	 */
	@RequestMapping(value="/ezAttitude/attModAppDetail.do")
	public String attModAppDetail(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model,
			@RequestParam(required=true)String attModId,
			@RequestParam(required=false)String companyId,
			@RequestParam(required=false)String applCnt,
			@RequestParam(required=false)String adminFlag,
			@RequestParam(required=false)String pageInfo) throws Exception {
		LOGGER.debug("attModAppDetail started");
		
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
			LOGGER.debug("status : " + status);
			
			JSONObject attitudeConfigVO = new JSONObject();
			if (status.equals("ok")) {
				attitudeConfigVO = (JSONObject) resultBody.get("data");
				model.addAttribute("attitudeConfigVO", attitudeConfigVO);
			}
		}
		
		if ( userInfo.getRollInfo().indexOf("c=1") != -1 ||userInfo.getRollInfo().indexOf("k=1") != -1 || userInfo.getRollInfo().indexOf("wa=1") != -1) {
			adminFlag = "true";
			isAllDept = "Y";
		} else if (userInfo.getRollInfo().indexOf("g=1") != -1) {
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
				if (!((String) dept.get("authType")).equals("")) {
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
		
		LOGGER.debug("attModAppDetail ended");
		
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
		LOGGER.debug("attModAppDetail started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String sysLang = ezCommonService.getTenantConfig("PrimaryLang", userInfo.getTenantId());
		String font = ezCommonService.getTenantConfig("editorFontStyle", userInfo.getTenantId());
		
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
		
		LOGGER.debug("attModAppDetail ended");
		
		return data;
	}
	
	/**
	 * 근태 수정 신청 상세
	 */
	@RequestMapping(value="/ezAttitude/attModAppMod.do")
	public String attModAppMod(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model,
			@RequestParam(required=false)String attModId) throws Exception {
		LOGGER.debug("attModAppMod started");
		
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
		
		LOGGER.debug("attModAppMod ended");
		
		return "/ezAttitude/attModAppMod";
	}
	
	/**
	 * 부서근태현황 main
	 */
	@RequestMapping(value = "/ezAttitude/attitudeDeptMain.do")
	public String attitudeUserMain(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request,
			@RequestParam(required=false)String deptid) throws Exception {
		LOGGER.debug("attitudeUserMain started");
		
		String adminFlag = "false";
		String isAllDept = "";
		String displayFlag = "false";
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		String url = "";
		
		//전체관리자(c), 회사관리자(k), 부서관리자(g), 근태관리자(wa) 면 모든부서..
		if ( userInfo.getRollInfo().indexOf("c=1") != -1 ||userInfo.getRollInfo().indexOf("k=1") != -1 || userInfo.getRollInfo().indexOf("wa=1") != -1) {
			adminFlag = "true";
			isAllDept = "Y";
		} else if (userInfo.getRollInfo().indexOf("g=1") != -1) {
			adminFlag = "true";
		}
		
		url = gwServerUrl + "/rest/ezattitude/users/" + userInfo.getId() + "/attitude-auth";
		
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
		
		LOGGER.debug("attitudeUserMain ended");
		return "/ezAttitude/attitudeUserMain";
	}
	
	@RequestMapping(value="/ezAttitude/getAttHistory.do",method=RequestMethod.GET, produces="application/json; charset=UTF-8")
	@ResponseBody
	public JSONArray getAttHistory(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, Locale locale, ModelMap modelMap,
		@RequestParam(required=true)String attModId,
		@RequestParam(required=false)String companyId) throws Exception {
		
		LOGGER.debug("getAttHistory started");
		
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
		LOGGER.debug("getAttHistory ended");
		return data;
	}
	
	/**
	 * 관리자 근태조회 리스트 조회
	 */
	@RequestMapping(value = "/ezAttitude/attitudeCheckList.do", produces = "application/json;charset=utf-8")
	@ResponseBody
	public JSONObject getAttitudeCheckList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LOGGER.debug("/ezAttitude/attitudeCheckList started.");
		
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
		
		LOGGER.debug("searchUserName = " + searchUserName + " || searchDeptName = " + searchDeptName + " || searchTitle = " + searchTitle + " || searchStartDate = " + searchStartDate
				+ " || searchEndDate = " + searchEndDate + " || searchAttitudeType = " + searchAttitudeType + " || pageNum = " + pageNum + " || listSize = " + listSize
				+ " || orderCell = " + orderCell + "orderOption = " + orderOption + "||searchDeptId =" + searchDeptId);
		
		if (userInfo.getRollInfo().indexOf("c=1") != -1 ||userInfo.getRollInfo().indexOf("k=1") != -1 || userInfo.getRollInfo().indexOf("wa=1") != -1) {
			isAdmin = "Y";
		}
		
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		String url = gwServerUrl + "/rest/ezattitude/attitudes/check"; // 부서근태조회는 따로 빼두는것이 좋지 않을까...아닌가 쿼리를 잘짜면 되려나
		
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
		LOGGER.debug("status : " + status);
		
		JSONObject jObject = new JSONObject();
		if(status.equals("ok")){
			jObject = (JSONObject) resultBody.get("data");
		}
		
		LOGGER.debug("/ezAttitude/attitudeCheckList ended");
		
		return jObject;
	}
	
	/**
	 * 근태 상세보기
	 */
	@RequestMapping(value = "/ezAttitude/attitudeItemDetail.do")
	public String attitudeItemDetail(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		LOGGER.debug("/ezAttitude/attitudeItemDetail started");
		
		String deptId = "";
		String isAllDept = "";
		String adminFlag = "";
		String authFlag = "";
		JSONObject attitudeVO = new JSONObject();
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String font = ezCommonService.getTenantConfig("editorFontStyle", userInfo.getTenantId());
		String userId = userInfo.getId();
		String attitudeId = request.getParameter("attitudeId");
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
			
			if (status.equals("ok")) {
				attitudeVO = (JSONObject) resultBody.get("data");
				model.addAttribute("attitudeInfo", attitudeVO);
			}
		} 
		deptId = (String) attitudeVO.get("deptId") == null ? "null" : (String) attitudeVO.get("deptId");
		
		if ( userInfo.getRollInfo().indexOf("c=1") != -1 ||userInfo.getRollInfo().indexOf("k=1") != -1 || userInfo.getRollInfo().indexOf("wa=1") != -1) {
			adminFlag = "true";
			isAllDept = "Y";
		} else if (userInfo.getRollInfo().indexOf("g=1") != -1) {
			adminFlag = "true";
		}
		
		url = gwServerUrl + "/rest/ezattitude/users/" + userInfo.getId() + "/attitude-auth";
		
		headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		entity = new HttpEntity<>(headers);
		
		builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("companyId", companyID)
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
		
		int myDeptCount = 0;
		
		for(int i = 0; i < deptList.size(); i++) {
			JSONObject dept = (JSONObject) deptList.get(i);
			if (dept.get("deptId").equals(userInfo.getDeptID())) {
				myDeptCount++;
			}
		}
		
		for(int i = 0; i < deptList.size(); i++) {
			JSONObject dept = (JSONObject) deptList.get(i);
			if (dept.get("mine") != null && dept.get("mine").equals("yes")) {
				dept.put("authType", "R");
			}
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
		
		LOGGER.debug("/ezAttitude/attitudeItemDetail ended");
		return "/ezAttitude/attitudeItemDetail";
	}
	
	/**
	 * 관리자 수정 작성화면
	 */
	@RequestMapping(value = "/ezAttitude/attAdminModItem.do")
	public String attAdminModItem(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		LOGGER.debug("/ezAttitude/attAdminModItem started");
		
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
		
		LOGGER.debug("/ezAttitude/attAdminModItem ended");
		return "ezAttitude/attAdminModItem";
	}
	
	/**
	 *  관리자 작성화면
	 */
	@RequestMapping(value = "/ezAttitude/attAdminNewItem.do")
	public String attAdminNewItem(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		LOGGER.debug("/ezAttitude/attAdminNewItem started");
		
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
		
		LOGGER.debug("/ezAttitude/attAdminNewItem ended");
		return "ezAttitude/attAdminNewItem";
	}
	
	/**
	 *  관리자 작성화면2
	 */
	@RequestMapping(value = "/ezAttitude/attAdminNewItem2.do")
	public String attAdminNewItem2(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		LOGGER.debug("/ezAttitude/attAdminNewItem started");
		
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
		LOGGER.debug("status : " + status);
		
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
		
		LOGGER.debug("/ezAttitude/attAdminNewItem ended");
		return "ezAttitude/attAdminNewItem2";
	}
	
	/**
	 * 사용자 근태 추가 및 수정
	 */
	@RequestMapping(value = "/ezAttitude/attAdminSave.do")
	@ResponseBody
	public String attAdminSave(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LOGGER.debug("/ezAttitude/attAdminSave started");
		
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
		LOGGER.debug("status : " + status);
		
		String resultStatus = "";
		if (status.equals("ok")) {
			resultStatus = resultBody.get("data").toString();
			if (!resultStatus.equals("dupl")) {
				resultStatus = "success";
			}
		} else {
			resultStatus = "error";
		}
		
		LOGGER.debug("/ezAttitude/attAdminSave ended");
		
		return resultStatus;
	}
	
	/**
	 * 관리자 근태 삭제
	 */
	@RequestMapping(value = "/ezAttitude/adminAttiDelItem.do")
	@ResponseBody
	public String attitudeDeleteItem(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LOGGER.debug("/ezAttitude/attitudeDeleteItem started");
		
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
		LOGGER.debug("status : " + status);
		
		String resultStatus = "";
		if (status.equals("ok")) {
			resultStatus = "success";
		} else {
			resultStatus = "error";
		}
		
		LOGGER.debug("/ezAttitude/attitudeDeleteItem ended");
		
		return resultStatus;
	}
	
	/**
	 * 근태작성 - 조직도(받는사람,참조,숨은참조) 화면 호출 함수
	 */
	@RequestMapping(value="/ezAttitude/attNewReceiverChoose.do")
	public String attNewReceiverChoose(
			@CookieValue("loginCookie") String loginCookie, 
			Locale locale, 
			Model model, 
			HttpServletRequest request) throws Exception{
		LOGGER.debug("attNewReceiverChoose started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String adminFlag = "";
		String isAllDept = "";
		String defaultWin = request.getParameter("defaultwin") == null ? "To" : request.getParameter("defaultwin").trim();
		String type = request.getParameter("type") == null ? "" : request.getParameter("type").trim();
		String ruleKind = request.getParameter("ruleKind") == null ? "" : request.getParameter("ruleKind").trim();
		String companyID = request.getParameter("companyID") == null ? userInfo.getCompanyID() : request.getParameter("companyID");
		String useOcs = config.getProperty("config.USE_OCS") == null ? "" : config.getProperty("config.USE_OCS");
		
		
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
		
		LOGGER.debug("attNewReceiverChoose ended.");
		return "ezAttitude/attNewReceiverChoose";
	}
	
	/**
	 * 근태입력관리, 미입력자관리, 관리내역 엑셀 출력
	 */
	@RequestMapping(value = {"/ezAttitude/excelAttitudeListExport.do", "/ezAttitude/excelAbsentedListExport.do", "ezAttitude/excelHistoryListExport.do"})
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
		
		if (searchAttitudeType == null || searchAttitudeType.equals("")) {
			searchAttitudeType = "total";
		}
		
		LOGGER.debug("searchUserName = " + searchUserName + " || searchDeptName = " + searchDeptName + " || searchTitle = " + searchTitle + " || searchDeptId = " + searchDeptId
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
		LOGGER.debug("status : " + status);
		
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
		
		if (reqType.equals("check")) {
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
		} else if (reqType.equals("absent")){
//			미입력자조회엑셀
			pFileName = EgovDateUtil.getToday("-") +"_absentedReport.xls";
			
			//header
			row.createCell(0).setCellValue("NO");
			row.getCell(0).setCellStyle(headerStyle);
			row.createCell(1).setCellValue("날짜");
			row.getCell(1).setCellStyle(headerStyle);
			row.createCell(2).setCellValue("이름");
			row.getCell(2).setCellStyle(headerStyle);
			row.createCell(3).setCellValue("직위");
			row.getCell(3).setCellStyle(headerStyle);
			row.createCell(4).setCellValue("부서");
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
		} else if (reqType.equals("history")){
//			관리내역조회엑셀
			pFileName = EgovDateUtil.getToday("-") +"_historyReport.xls";
			
			//header
			row.createCell(0).setCellValue("NO");
			row.getCell(0).setCellStyle(headerStyle);
			row.createCell(1).setCellValue("이름");
			row.getCell(1).setCellStyle(headerStyle);
			row.createCell(2).setCellValue("직위");
			row.getCell(2).setCellStyle(headerStyle);
			row.createCell(3).setCellValue("부서");
			row.getCell(3).setCellStyle(headerStyle);
			row.createCell(4).setCellValue("일시");
			row.getCell(4).setCellStyle(headerStyle);
			row.createCell(5).setCellValue("근태유형");
			row.getCell(5).setCellStyle(headerStyle);
			row.createCell(6).setCellValue("수정자");
			row.getCell(6).setCellStyle(headerStyle);
			row.createCell(7).setCellValue("수정일시");
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
		}
		
		response.setHeader("Content-Disposition", "attachment; fileName=\"" + pFileName + ".xls\"");
		workbook.write(response.getOutputStream());
		
		workbook.close();
		
		LOGGER.debug("excelFileExport ended.");
	}
	
	/**
	 * 조직도 부서 및 사원목록 검색 함수
	 */
	@RequestMapping(value = "/ezAttitude/getSearchList.do", produces="text/xml;charset=utf-8")
	@ResponseBody
	public String getSearchList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception{
	    LOGGER.debug("getSearchList started.");

	    LoginVO userInfo = commonUtil.userInfo(loginCookie);
	    
	    String searchlist = request.getParameter("search").trim();
		String celllist = request.getParameter("cell");
		String proplist = request.getParameter("prop");
		String listtype = request.getParameter("type");
		String companyID = request.getParameter("companyID") == null ? userInfo.getCompanyID() : request.getParameter("companyID");
		String lang = userInfo.getPrimary();
		String page = request.getParameter("page");
		String infoXML = "";
		
		LOGGER.debug("searchlist=" + searchlist + ",celllist=" + celllist + ",proplist=" + proplist
		        + ",listtype=" + listtype + ",lang=" + lang + ",page=" + page + "companyID=" + companyID);
	    
		
		String offset = userInfo.getOffset();
		String offsetMin = commonUtil.getMinuteUTC(offset);
		
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
        
        LOGGER.debug("tenantID=" + tenantID);       
		
		String XMLResult = data;
		XMLResult = XMLResult.replaceAll("null", "");
		
		LOGGER.debug("getSearchList ended.");
		return XMLResult;
	}
}