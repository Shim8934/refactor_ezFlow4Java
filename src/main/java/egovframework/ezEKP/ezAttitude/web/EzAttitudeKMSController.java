package egovframework.ezEKP.ezAttitude.web;

import java.util.List;
import java.util.Locale;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFCellStyle;
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
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.servlet.HandlerMapping;
import org.springframework.web.util.UriComponentsBuilder;
import org.w3c.dom.Document;
import org.w3c.dom.Node;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezPoll.vo.PollQuestionVO;
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
		int totalPages = 0;
		int pageSize = 15;
		int startPoint = 0;
		int endPoint = 15;
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String sysLang = ezCommonService.getTenantConfig("PrimaryLang", userInfo.getTenantId());

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
				.queryParam("companyId", userInfo.getCompanyID())
				.queryParam("tenantId", userInfo.getTenantId())
				.queryParam("apprUserName", apprUserName)
				.queryParam("startDate", startDate)
				.queryParam("endDate", endDate)
				.queryParam("sysLang", sysLang)
				.queryParam("offset", offsetMin)
				.queryParam("pageNum", pageNum);
		
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
		url = gwServerUrl + "/rest/ezattitude/users/"+ userInfo.getId() +"/modifyattitudes";
		
		builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("companyId", userInfo.getCompanyID())
				.queryParam("tenantId", userInfo.getTenantId())
				.queryParam("apprUserName", apprUserName)
				.queryParam("startDate", startDate)
				.queryParam("endDate", endDate)
				.queryParam("sysLang", sysLang)
				.queryParam("offset", offsetMin)
				.queryParam("pageNum", pageNum);
		
		if (totalPages == 0 || totalPages == 1) {
			
			result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
			
			jp = new JSONParser();
			
			resultBody = (JSONObject) jp.parse(result.getBody());
			
			status = resultBody.get("status").toString();
			
			data = new JSONObject();
			list = new JSONArray();
			
			if(status.equals("ok")){
				data = (JSONObject) resultBody.get("data");
				list = (JSONArray) data.get("list");
				model.addAttribute("list", list);
			}
		}
		else {
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
			
			builder = UriComponentsBuilder.fromHttpUrl(url)
					.queryParam("companyId", userInfo.getCompanyID())
					.queryParam("tenantId", userInfo.getTenantId())
					.queryParam("apprUserName", apprUserName)
					.queryParam("startDate", startDate)
					.queryParam("endDate", endDate)
					.queryParam("sysLang", sysLang)
					.queryParam("offset", offsetMin)
					.queryParam("pageNum", pageNum)
					.queryParam("startPoint", startPoint)
					.queryParam("endPoint", endPoint);
			
			result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
			
			jp = new JSONParser();
			
			resultBody = (JSONObject) jp.parse(result.getBody());
			
			status = resultBody.get("status").toString();
			
			data = new JSONObject();
			list = new JSONArray();
			
			if(status.equals("ok")){
				data = (JSONObject) resultBody.get("data");
				list = (JSONArray) data.get("list");
				model.addAttribute("list", list);
			}
		}
		
		url = gwServerUrl + "/rest/ezattitude/users/"+ userInfo.getId() +"/modifyattitudes";
		
		result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		jp = new JSONParser();
		
		resultBody = (JSONObject) jp.parse(result.getBody());
		
		status = resultBody.get("status").toString();
		
		data = new JSONObject();
		list = new JSONArray();
		
		if(status.equals("ok")){
			data = (JSONObject) resultBody.get("data");
			list = (JSONArray) data.get("list");
			model.addAttribute("list", list);
		}
		
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
	@RequestMapping(value="/admin/ezAttitude/attModAppList.do")
	public String adminGetAttModAppList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model,
			@RequestParam(required=false)String pageNum,
			@RequestParam(required=false)String apprUserName,
			@RequestParam(required=false)String startDate,
			@RequestParam(required=false)String endDate) throws Exception {
		LOGGER.debug("adminAttModAppList started");
		
		int totalAtt = 0;
		int currentPage = 1;
		int totalPages = 0;
		int pageSize = 15;
		int startPoint = 0;
		int endPoint = 15;
		String adminFlag = "true";
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String sysLang = ezCommonService.getTenantConfig("PrimaryLang", userInfo.getTenantId());

		if (userInfo.getRollInfo().indexOf("wa=1") == -1) {
			return "cmm/error/adminDenied";
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
				.queryParam("companyId", userInfo.getCompanyID())
				.queryParam("tenantId", userInfo.getTenantId())
				.queryParam("apprUserName", apprUserName)
				.queryParam("startDate", startDate)
				.queryParam("endDate", endDate)
				.queryParam("sysLang", sysLang)
				.queryParam("offset", offsetMin)
				.queryParam("pageNum", pageNum)
				.queryParam("adminFlag", adminFlag);
		
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
		url = gwServerUrl + "/rest/ezattitude/users/"+ userInfo.getId() +"/modifyattitudes";
		
		builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("companyId", userInfo.getCompanyID())
				.queryParam("tenantId", userInfo.getTenantId())
				.queryParam("apprUserName", apprUserName)
				.queryParam("startDate", startDate)
				.queryParam("endDate", endDate)
				.queryParam("sysLang", sysLang)
				.queryParam("offset", offsetMin)
				.queryParam("pageNum", pageNum)
				.queryParam("adminFlag", adminFlag);
		
		if (totalPages == 0 || totalPages == 1) {
			
			result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
			
			jp = new JSONParser();
			
			resultBody = (JSONObject) jp.parse(result.getBody());
			
			status = resultBody.get("status").toString();
			
			data = new JSONObject();
			list = new JSONArray();
			
			if(status.equals("ok")){
				data = (JSONObject) resultBody.get("data");
				list = (JSONArray) data.get("list");
				model.addAttribute("list", list);
			}
		}
		else {
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
			
			builder = UriComponentsBuilder.fromHttpUrl(url)
					.queryParam("companyId", userInfo.getCompanyID())
					.queryParam("tenantId", userInfo.getTenantId())
					.queryParam("apprUserName", apprUserName)
					.queryParam("startDate", startDate)
					.queryParam("endDate", endDate)
					.queryParam("sysLang", sysLang)
					.queryParam("offset", offsetMin)
					.queryParam("pageNum", pageNum)
					.queryParam("startPoint", startPoint)
					.queryParam("endPoint", endPoint)
					.queryParam("adminFlag", adminFlag);
			
			result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
			
			jp = new JSONParser();
			
			resultBody = (JSONObject) jp.parse(result.getBody());
			
			status = resultBody.get("status").toString();
			
			data = new JSONObject();
			list = new JSONArray();
			
			if(status.equals("ok")){
				data = (JSONObject) resultBody.get("data");
				list = (JSONArray) data.get("list");
				model.addAttribute("list", list);
			}
		}
		
		url = gwServerUrl + "/rest/ezattitude/users/"+ userInfo.getId() +"/modifyattitudes";
		
		result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		jp = new JSONParser();
		
		resultBody = (JSONObject) jp.parse(result.getBody());
		
		status = resultBody.get("status").toString();
		
		data = new JSONObject();
		list = new JSONArray();
		
		if(status.equals("ok")){
			data = (JSONObject) resultBody.get("data");
			list = (JSONArray) data.get("list");
			model.addAttribute("list", list);
		}
		
		model.addAttribute("userLang", userInfo.getLang());
		model.addAttribute("userTimeSet", offset);
		model.addAttribute("offsetMin", offsetMin);
		model.addAttribute("totalAtt", totalAtt);
		model.addAttribute("currentPage", currentPage);
		model.addAttribute("totalPages", totalPages);
		model.addAttribute("adminFlag", adminFlag);
		
		LOGGER.debug("attModAppList ended");
		
		return "/ezAttitude/attModAppList";
	}
	
	@RequestMapping(value="/ezAttitude/getAttModAppList.do",method=RequestMethod.GET, produces="application/json; charset=UTF-8")
	@ResponseBody
	public JSONObject getAttModAppList(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, Locale locale, ModelMap modelMap,
			@RequestParam(required=false)String apprUserName,
			@RequestParam(required=false)String startDate,
			@RequestParam(required=false)String endDate,
			@RequestParam(required=false)String pageNum,
			@RequestParam(required=false)String type,
			@RequestParam(required=false)String excelReq,
			@RequestParam(required=false)String orderCell,
			@RequestParam(required=false)String orderOption,
			@RequestParam(required=false)String adminFlag) throws Exception {
		
		int currentPage = 1;
		int pageSize = 15;
		int startPoint = 0;
		int endPoint = 15;
		int totalPages = 0;
		int totalAtt = 0;
		
		if (pageNum != null) {
			currentPage = Integer.parseInt(pageNum);
		}
		
		if (excelReq == null) {
			excelReq = "false";
		}
		
		if (adminFlag == null) {
			adminFlag = "false";
		}
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String sysLang = ezCommonService.getTenantConfig("PrimaryLang", userInfo.getTenantId());
		
		if(adminFlag.equals("true")){
			if (userInfo.getRollInfo().indexOf("wa=1") == -1) {
				return new JSONObject();
			}
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
				.queryParam("companyId", userInfo.getCompanyID())
				.queryParam("tenantId", userInfo.getTenantId())
				.queryParam("apprUserName", apprUserName)
				.queryParam("startDate", startDate)
				.queryParam("endDate", endDate)
				.queryParam("sysLang", sysLang)
				.queryParam("offset", offsetMin)
				.queryParam("pageNum", pageNum)
				.queryParam("type", type)
				.queryParam("orderCell", orderCell)
				.queryParam("orderOption", orderOption)
				.queryParam("adminFlag", adminFlag);
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp = new JSONParser();
		
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		
		String status = resultBody.get("status").toString();
		
		JSONObject data = new JSONObject();
		JSONArray list = new JSONArray();
		
		if(status.equals("ok")){
			LOGGER.debug(resultBody.toJSONString());
			totalAtt = Integer.parseInt(resultBody.get("data").toString());
		}
		totalPages = (totalAtt + pageSize - 1)/pageSize;
		
		gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		url = gwServerUrl + "/rest/ezattitude/users/"+ userInfo.getId() +"/modifyattitudes";
		
		headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		entity = new HttpEntity<>(headers);
		
		if (totalPages == 0 || totalPages == 1) {

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
		if (excelReq.equals("true")) {
			builder = UriComponentsBuilder.fromHttpUrl(url)
					.queryParam("companyId", userInfo.getCompanyID())
					.queryParam("tenantId", userInfo.getTenantId())
					.queryParam("apprUserName", apprUserName)
					.queryParam("startDate", startDate)
					.queryParam("endDate", endDate)
					.queryParam("sysLang", sysLang)
					.queryParam("offset", offsetMin)
					.queryParam("type", type)
					.queryParam("orderCell", orderCell)
					.queryParam("orderOption", orderOption)
					.queryParam("adminFlag", adminFlag);
		} else {
			builder = UriComponentsBuilder.fromHttpUrl(url)
					.queryParam("companyId", userInfo.getCompanyID())
					.queryParam("tenantId", userInfo.getTenantId())
					.queryParam("apprUserName", apprUserName)
					.queryParam("startDate", startDate)
					.queryParam("endDate", endDate)
					.queryParam("sysLang", sysLang)
					.queryParam("offset", offsetMin)
					.queryParam("startPoint", startPoint)
					.queryParam("endPoint", endPoint)
					.queryParam("type", type)
					.queryParam("orderCell", orderCell)
					.queryParam("orderOption", orderOption)
					.queryParam("adminFlag", adminFlag);
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
		
		resultj.put("startDate", startDate);
		resultj.put("endDate", endDate);
		resultj.put("totalAtt", totalAtt);
		resultj.put("totalPages", totalPages);
		
		return resultj;
	}
	
	@RequestMapping(value = "/ezAttitude/saticGetXlsAtt.do")
	public void qstResultsaticGetXlsAtt(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception{
		LOGGER.debug("saticGetXlsAtt started");
		
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
		  
		LOGGER.debug("saticGetXlsAtt ended");
	}
	
	@RequestMapping(value="/ezAttitude/delAttModApp.do" , method= RequestMethod.POST)
	@ResponseBody
	public String delAttModApp(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model,
			@RequestParam(required=false)String idList) throws Exception {
		LOGGER.debug("delAttModApp started");
		LOGGER.debug("idList : " + idList);
		
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
			@RequestParam(required=true)String changeStatus
			) throws Exception {
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String sysLang = ezCommonService.getTenantConfig("PrimaryLang", userInfo.getTenantId());

		if (userInfo.getLang().equals(sysLang))  {
			sysLang = "primary";
		}
		
		if (userInfo.getRollInfo().indexOf("wa=1") == -1) {
			return "cmm/error/adminDenied";
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
	
	@RequestMapping(value="/ezAttitude/retAttModApp.do" , method= RequestMethod.POST)
	@ResponseBody
	public String retAttModApp(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model,
			@RequestParam(required=false)String idList) throws Exception {
		LOGGER.debug("retAttModApp started");

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

		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.PUT, entity, String.class);
		
		JSONParser jp = new JSONParser();
		
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		
		String status = resultBody.get("status").toString();

		LOGGER.debug("retAttModApp ended");
		
		return status;
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
		
		String status = resultBody.get("status").toString();

		LOGGER.debug("modAttModApp ended");
		
		return status;
	}
	
	/**
	 * 근태 수정 신청 상세
	 */
	@RequestMapping(value="/ezAttitude/attModAppDetail.do")
	public String attModAppDetail(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model,
			@RequestParam(required=true)String attModId,
			@RequestParam(required=false)String adminFlag) throws Exception {
		LOGGER.debug("attModAppDetail started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String sysLang = ezCommonService.getTenantConfig("PrimaryLang", userInfo.getTenantId());

		if (userInfo.getLang().equals(sysLang))  {
			sysLang = "primary";
		}
		
		if (adminFlag != null) {
			if (adminFlag.equals("true")) {
				if (userInfo.getRollInfo().indexOf("wa=1") == -1) {
					return "cmm/error/adminDenied";
				}
			}
		} else {
			adminFlag = "false";
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
		
		model.addAttribute("userLang", userInfo.getLang());
		model.addAttribute("userTimeSet", offset);
		model.addAttribute("offsetMin", offsetMin);
		model.addAttribute("adminFlag", adminFlag);
		
		LOGGER.debug("attModAppDetail ended");
		
		return "/ezAttitude/attModAppDetail";
	}
	
	/**
	 * 근태 수정 신청 상세
	 */
	@RequestMapping(value="/ezAttitude/attModAppMod.do")
	public String attModAppMod(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model,
			@RequestParam(required=false)String attModId) throws Exception {
		LOGGER.debug("attModAppDetail started");
		
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
		
		model.addAttribute("userLang", userInfo.getLang());
		model.addAttribute("userTimeSet", offset);
		model.addAttribute("offsetMin", offsetMin);
		
		LOGGER.debug("attModAppDetail ended");
		
		return "/ezAttitude/attModAppMod";
	}
	
	/**
	 * 개인근태현황 main
	 */
	@RequestMapping(value = "/ezAttitude/attitudeDeptMain.do")
	public String attitudeUserMain(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		LOGGER.debug("/ezAttitude/attitudeUserMain started");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("deptFlag", "true");
		
		LOGGER.debug("/ezAttitude/attitudeUserMain ended");
		return "/ezAttitude/attitudeUserMain";
	}
}
