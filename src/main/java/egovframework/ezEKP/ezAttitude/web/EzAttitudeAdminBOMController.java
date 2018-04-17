package egovframework.ezEKP.ezAttitude.web;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.URI;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;
import java.util.UUID;

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
import org.apache.poi.ss.usermodel.Workbook;
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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.util.UriComponentsBuilder;
import org.w3c.dom.Document;
import org.w3c.dom.Node;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezAttitude.vo.AdminAttitudeVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeConfigVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeTypeVO;
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
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		String url = gwServerUrl + "/rest/ezattitude/companies/" + request.getParameter("companyId") + "/attitudetypes";//TODO
		
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
	 * 관리자 유형 사용여부 설정 일괄저장 함수
	 * @throws Exception
	 */
	@RequestMapping(value = "/admin/ezAttitude/saveAttitudeTypeConfig.do")
	@ResponseBody
	public void saveAttitudeTypeConfig(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LOGGER.debug("saveAttitudeTypeConfig started.");
		
		String typeConfigList = request.getParameter("typelist");
		
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
		
		LOGGER.debug("saveAttitudeTypeConfig ended.");
	}
	
	/**
	 * 관리자 유형관리 유형추가 팝업창 호출 함수
	 * @return
	 */
	@RequestMapping(value = "/admin/ezAttitude/addAttitudeType.do")
	public String addAttitudeType(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		LOGGER.debug("addAttitudeType started.");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String companyId = request.getParameter("companyId");
		
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");	
		String url = gwServerUrl + "/rest/ezattitude/companies/" + companyId + "/attitudetypes/info";
		
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
		
		JSONObject data = new JSONObject();
//		JSONArray formList = new JSONArray();
		String typeId = "";
		
		if (status.equals("ok")) {
			data = (JSONObject) resultBody.get("data");
//			formList = (JSONArray) data.get("formList");
			typeId = (String) data.get("typeId");
			
//			model.addAttribute("formList", formList);
			model.addAttribute("typeId", typeId);
			model.addAttribute("companyId", companyId);
		}
		
		LOGGER.debug("addAttitudeType ended.");
		
		return "admin/ezAttitude/saveAttitudeType";
	}
	
	/**
	 * 관리자 유형관리 유형수정 팝업창 호출 함수
	 * @return
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
		
		JSONObject data = new JSONObject();
		JSONArray formList = new JSONArray();
		JSONObject typeInfo = new JSONObject();
		
		if (status.equals("ok")) {
			data = (JSONObject) resultBody.get("data");
			formList = (JSONArray) data.get("formList");
			typeInfo = (JSONObject) data.get("typeInfo");
			
			model.addAttribute("formList", formList);
			model.addAttribute("typeInfo", typeInfo);
			model.addAttribute("companyId", companyId);
		}
		
		LOGGER.debug("showAttitudeType ended.");
		
		return "/admin/ezAttitude/saveAttitudeType";
	}
	/**
	 * 아이콘 업로드 함수
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ezAttitude/iconUpload.do")
	public String iconUpload(@CookieValue("loginCookie") String loginCookie, MultipartHttpServletRequest request, Model model) throws Exception {
		
		LOGGER.debug("iconUpload started.");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		MultipartFile file = request.getFile("file1");
		String typeId = request.getParameter("typeId");
		String companyId = request.getParameter("companyId");

		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");	
		String url = gwServerUrl + "/rest/ezattitude/companies/" + companyId + "/attitudetypes/" + typeId + "/iconupload";
		
		URI uri = URI.create(url); 
//		int maxSize = 0; 
		
		Long fileSize; 
//		maxSize = Integer.parseInt(request.getParameter("maxSize")); 
		JSONObject jsonObject = new JSONObject(); 
		 
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		JSONObject fileJson = new JSONObject();			 
			 
		byte[] bytes = file.getBytes(); 
		fileSize = file.getSize(); 
		String originalFilename = file.getOriginalFilename(); 
		fileJson.put("bytes", bytes); 
		fileJson.put("fileSize", fileSize); 
		fileJson.put("originalFilename", originalFilename); 

		jsonObject.put("fileObject", fileJson);
//		jsonObject.put("maxSize",maxSize); //최대사이즈
		jsonObject.put("userID",userInfo.getId());  
		 
		HttpEntity<JSONObject> entity = new HttpEntity(jsonObject, headers); 
		     
		RestTemplate rest = new RestTemplate(); 
		 
		ResponseEntity<JSONObject> result = rest.exchange(uri, HttpMethod.POST, entity, JSONObject.class); 				
		
		JSONObject resultBody = result.getBody();
		
		String status = resultBody.get("status").toString();
		
		Object filePaths = "";
		if (status.equals("ok")) {
			filePaths = resultBody.get("data");
			
			model.addAttribute("filePaths", filePaths);
		}
		
		LOGGER.debug("iconUpload ended.");
		
		return "/admin/ezAttitude/attitudeTypeIconUpload";
	}
	
	@RequestMapping(value = "/admin/ezAttitude/saveAttitudeType.do")
	public void saveAttutideType(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		
		LOGGER.debug("saveAttutideType started.");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		String companyId = request.getParameter("companyId");
		String typeId = request.getParameter("typeId");
		String saveMode = request.getParameter("saveMode");
		String typeName = request.getParameter("typeName");
		String typeName2 = request.getParameter("typeName2");
		String imgPath = request.getParameter("imgPath");
		
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");	
		String url = "";
		if (saveMode != null && saveMode.equals("modify")) {
			url = gwServerUrl + "/rest/ezattitude/companies/" + companyId + "/attitudetypes/" + typeId;
		} else {
			url = gwServerUrl + "/rest/ezattitude/companies/" + companyId + "/attitudetypes/";
		}
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("userId", userInfo.getId())
				.queryParam("typeId", typeId)
				.queryParam("typeName", typeName)
				.queryParam("typeName2", typeName2)
				.queryParam("imgPath", imgPath);
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<?> result;
		
		if (saveMode != null && saveMode.equals("modify")) {
			result = rest.exchange(builder.build().encode().toUri(), HttpMethod.PUT, entity, JSONObject.class);
		} else {
			result = rest.exchange(builder.build().encode().toUri(), HttpMethod.POST, entity, JSONObject.class);
		}
		
//		JSONObject resultBody = (JSONObject) result.getBody();
		
//		String status = resultBody.get("status").toString();
		
		LOGGER.debug("saveAttutideType ended.");
		
	}
	
	/**
	 * 관리자 사용자별 근태설정 메인화면 호출
	 *//*
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
		
		LOGGER.debug("/admin/ezAttitude/attitudeUserConf ended");
		
		return "/admin/ezAttitude/attitudeUserConf";
	}
	
	*//**
	 * 사용자별 근태설정 리스트 출력
	 *//*
	@RequestMapping(value = "/admin/ezAttitude/attitudeUserConfList.do", produces = "application/json;charset=utf-8")
	@ResponseBody
	public JSONObject getAttitudeUserConfList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception{
		LOGGER.debug("/admin/ezAttitude/attitudeUserConfList started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		String companyId = request.getParameter("companyId");
		String searchUserName = request.getParameter("userName");
		String searchDeptName = request.getParameter("deptName");
		String pageNum = request.getParameter("pageNum");
		String listSize = request.getParameter("listSize");
		String orderCell = request.getParameter("orderCell");
		String orderOption = request.getParameter("orderOption");
		String userId = userInfo.getId();
		String offset = userInfo.getOffset();
		String offsetMin = commonUtil.getMinuteUTC(offset);
		
		LOGGER.debug(companyId);
		
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
	*//**
	 * 사용자 근무시간 설정 화면 출력(조직도 회사/부서리스트 포함)
	 * @param loginCookie
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 *//*
	@RequestMapping(value = "/admin/ezAttitude/saveAttitudeUserConf.do")
	public String saveAttitudeUserConf(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception{
		
		LOGGER.debug("/admin/ezAttitude/saveAttitudeUserConf started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		String companyId = request.getParameter("companyId");
		String userList = request.getParameter("userList");
		
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
				if (dept.get("isComp").equals("comp")) {
					dept.put("icon", "icon-company");
				} else{
					dept.put("icon", "icon-dept");
				}
				if (dept.get("myDept").equals("yes")) {
					JSONObject state = new JSONObject();
					state.put("opened", "true");
					state.put("selected", "true");
					dept.put("state", state);
				}
			}
			
			model.addAttribute("deptList", deptList);
			model.addAttribute("companyId", companyId);
		}
		
		//회사 근무시간 정보
		url = gwServerUrl + "/rest/ezattitude/companies/" + companyId + "/attitudereg";
		
		builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("companyId", companyId)
				.queryParam("userId", userInfo.getId());
		
		result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		resultBody = (JSONObject) jp.parse(result.getBody());
		
		status = resultBody.get("status").toString();
		LOGGER.debug("status : " + status);
		if(status.equals("ok")){
			jObject = (JSONObject) resultBody.get("data");
			
			String workStartTime = (String) jObject.get("workStartTime");
			String workEndTime = (String) jObject.get("workEndTime");
			
			model.addAttribute("workStartTime", workStartTime);
			model.addAttribute("workEndTime", workEndTime);
		}
		
		//선택된 유저 리스트 정보
		if (userList != null) {
			String offset = userInfo.getOffset();
			String offsetMin = commonUtil.getMinuteUTC(offset);
			
			url = gwServerUrl + "/rest/ezattitude/users/users-attitude-confs";
			
			builder = UriComponentsBuilder.fromHttpUrl(url)
					.queryParam("companyId", companyId)
					.queryParam("userId", userInfo.getId())
					.queryParam("userIdList", userList)
					.queryParam("offsetMin", offsetMin);

			result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
			
			resultBody = (JSONObject) jp.parse(result.getBody());
			
			status = resultBody.get("status").toString();
			LOGGER.debug("status : " + status);
			
			if(status.equals("ok")){
				JSONArray jArray = (JSONArray) resultBody.get("data");
				
				model.addAttribute("userList", jArray);
			}
		} else {
			model.addAttribute("userList", "null");
		}
		
		LOGGER.debug("/admin/ezAttitude/saveAttitudeUserConf ended");
		
		return "admin/ezAttitude/saveAttitudeUserConf";
	}*/
	
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
		return "admin/ezAttitude/deptUserList";
	}
	/**
	 * 사원의 근무 시작/종료시간 설정정보 조회
	 * @param request
	 * @param loginCookie
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/admin/ezAttitude/selectUserInfo.do")
	@ResponseBody
	public JSONArray selectUserInfo(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		LOGGER.debug("selectUserInfo started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		String companyId = request.getParameter("companyId");
		String userIdList = request.getParameter("userId");
		String offset = userInfo.getOffset();
		String offsetMin = commonUtil.getMinuteUTC(offset);
		
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		String url = gwServerUrl + "/rest/ezattitude/users/users-attitude-confs";
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("companyId", companyId)
				.queryParam("userId", userInfo.getId())
				.queryParam("userIdList", userIdList)
				.queryParam("offsetMin", offsetMin);

		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp = new JSONParser();
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		
		String status = resultBody.get("status").toString();
		LOGGER.debug("status : " + status);
		
		
		JSONArray jArray = new JSONArray();
		if(status.equals("ok")){
			jArray = (JSONArray) resultBody.get("data");
		}
		
		LOGGER.debug("selectUserInfo ended");
		return jArray;
	}
	/**
	 * 사용자 근태설정 추가/변경
	 * @param request
	 * @param loginCookie
	 */
	@RequestMapping(value = "/admin/ezAttitude/attitudeUserConfSave.do")
	@ResponseBody
	public void attitudeUserConfSave(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie) throws Exception {
		LOGGER.debug("attitudeUserConfSave started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String userConfInfoList = request.getParameter("userConfInfoList");
		
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		String url = gwServerUrl + "/rest/users/ezattitude/user-attitude-confs";
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("userId", userInfo.getId())
				.queryParam("userConfInfoList", userConfInfoList);
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.POST, entity, String.class);
		
		LOGGER.debug("attitudeUserConfSave ended");
	}
	/**
	 * 사용자 근태설정 삭제
	 * @param request
	 * @param loginCookie
	 * @throws Exception 
	 */
	@RequestMapping(value = "/admin/ezAttitude/delAttitudeUserConf.do")
	@ResponseBody
	public void delAttitudeUserConf(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie) throws Exception {
		LOGGER.debug("delAttitudeUserConf started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String selecUserList = request.getParameter("selecUserList");
		
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		String url = gwServerUrl + "/rest/users/ezattitude/user-attitude-confs";
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("userId", userInfo.getId())
				.queryParam("selecUserList", selecUserList);
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.DELETE, entity, String.class);
		
		JSONParser jp = new JSONParser();
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		
		String status = resultBody.get("status").toString();
		LOGGER.debug("status : " + status);
		
		LOGGER.debug("delAttitudeUserConf ended");
	}
	
	/**
	 * 관리자 근태조회 메인화면 호출
	 */
	@RequestMapping(value = "/admin/ezAttitude/attitudeCheck.do")
	public String attitudeCheck(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		LOGGER.debug("/admin/ezAttitude/attitudeDeptConf started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		if (userInfo.getRollInfo().indexOf("c=1") == -1 && userInfo.getRollInfo().indexOf("k=1") == -1) {
			return "cmm/error/adminDenied";
		}
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
		String adminCompany = "";
		String today = "";
		if (status.equals("ok")) {
		
			data = (JSONObject) resultBody.get("data");
			list = (JSONArray) data.get("list");
			adminCompany = (String) data.get("adminCompany");
			today = (String) data.get("today");
			
			model.addAttribute("list", list);
			model.addAttribute("adminCompany", adminCompany);
			model.addAttribute("today", today);
		}
		
		LOGGER.debug("/admin/ezAttitude/attitudeDeptConf ended");
		
		return "/admin/ezAttitude/attitudeCheck";
	}
	
	/**
	 * 관리자 근태조회 리스트 출력
	 */
	@RequestMapping(value = "/admin/ezAttitude/attitudeCheckList.do", produces = "application/json;charset=utf-8")
	@ResponseBody
	public JSONObject getAttitudeCheckList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
//	public JSONArray getAttitudeCheckList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LOGGER.debug("/admin/ezAttitude/attitudeCheckList started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		String companyId = request.getParameter("companyId");
		String pageNum = request.getParameter("pageNum");
		String listSize = request.getParameter("listSize");
		String typeId = request.getParameter("typeId");
		String userIdList = request.getParameter("userIdList");
		String orderCell = request.getParameter("orderCell");
		String orderOption = request.getParameter("orderOption");
		String startDate = request.getParameter("startDate");
		String endDate = request.getParameter("endDate");
		String userId = userInfo.getId();
		String offset = userInfo.getOffset();
		String offsetMin = commonUtil.getMinuteUTC(offset);
		
		LOGGER.debug(companyId);
		
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		String url = gwServerUrl + "/rest/ezattitude/attitudes/bombom"; // 부서근태조회는 따로 빼두는것이 좋지 않을까...아닌가 쿼리를 잘짜면 되려나
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("companyId", companyId)
				.queryParam("userId", userId)
				.queryParam("pageNum", pageNum)
				.queryParam("listSize", listSize)
				.queryParam("typeId", typeId)
				.queryParam("userIdList", userIdList)
				.queryParam("orderCell", orderCell)
				.queryParam("orderOption", orderOption)
				.queryParam("startDate", startDate)
				.queryParam("endDate", endDate)
				.queryParam("offsetMin", offsetMin);
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp = new JSONParser();
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		
		String status = resultBody.get("status").toString();
		LOGGER.debug("status : " + status);
		
		
//		JSONArray jArray = new JSONArray();
//		if(status.equals("ok")){
//			jArray = (JSONArray) resultBody.get("data");
//		}
		JSONObject jObject = new JSONObject();
		if(status.equals("ok")){
			jObject = (JSONObject) resultBody.get("data");
		}
		
		LOGGER.debug("/admin/ezAttitude/attitudeCheckList ended");
		return jObject;
//		return jArray;
	}
	/**
	 * 근태조회 > 조회자 검색(조직도) 화면 출력 메서드
	 */
	@RequestMapping(value = "/admin/ezAttitude/getSearchList.do")
	public String attitudeCheckUserSearch(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		String companyId = request.getParameter("companyId");
		String searchIdList = request.getParameter("searchIdList");
		String searchNameList = request.getParameter("searchNameList");
		if (searchIdList != null && searchNameList != null) {
			model.addAttribute("searchIdList", searchIdList);
			model.addAttribute("searchNameList", searchNameList);
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
				if (dept.get("isComp").equals("comp")) {
					dept.put("icon", "icon-company");
				} else{
					dept.put("icon", "icon-dept");
				}
				if (dept.get("myDept").equals("yes")) {
					JSONObject state = new JSONObject();
					state.put("opened", "true");
					state.put("selected", "true");
					dept.put("state", state);
				}
			}
			
			model.addAttribute("deptList", deptList);
			model.addAttribute("companyId", companyId);
		}
		return "admin/ezAttitude/searchAttitudeCheck";
	}
	
	/**
	 * 근태조회 엑셀 출력
	 * @param loginCookie
	 * @param response
	 * @param request
	 * @param locale
	 * @throws Exception
	 */
	@RequestMapping(value = "/admin/ezAttitude/excelFileExport.do")
	public void excelFileExport(@CookieValue("loginCookie")String loginCookie, HttpServletResponse response, HttpServletRequest request, Locale locale) throws Exception{
		LOGGER.debug("excelFileExport started."); 
		
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie); 
		
		String companyId = request.getParameter("companyId");
		String pageNum = request.getParameter("pageNum");
		String listSize = request.getParameter("listSize");
		String typeId = request.getParameter("typeId");
		String userIdList = request.getParameter("userIdList");
		String orderCell = request.getParameter("orderCell");
		String orderOption = request.getParameter("orderOption");
		String startDate = request.getParameter("startDate");
		String endDate = request.getParameter("endDate");
		String userId = userInfo.getId();
		String offset = userInfo.getOffset();
		String offsetMin = commonUtil.getMinuteUTC(offset);
		
		LOGGER.debug(companyId);
		
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		String url = gwServerUrl + "/rest/ezattitude/attitudes/bombom"; // 부서근태조회는 따로 빼두는것이 좋지 않을까
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("companyId", companyId)
				.queryParam("userId", userId)
				.queryParam("pageNum", pageNum)
				.queryParam("listSize", listSize)
				.queryParam("typeId", typeId)
				.queryParam("userIdList", userIdList)
				.queryParam("orderCell", orderCell)
				.queryParam("orderOption", orderOption)
				.queryParam("startDate", startDate)
				.queryParam("endDate", endDate)
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
		
	///////    엑 셀        //////////////////////////////////////////////////////////
		
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
		
		HSSFFont font = workbook.createFont();
		font.setBoldweight((short) font.BOLDWEIGHT_BOLD);
		headerStyle.setFont(font);
		
		Row row;
		Cell cell;
		      
		String pFileName = "";
		String strDate = EgovDateUtil.getToday("-");
		pFileName = strDate+"_Report.xls";
		
		sheet = workbook.createSheet("report");
		row = sheet.createRow(0);
		
		//header
		row.createCell(0).setCellValue("이름");
		row.getCell(0).setCellStyle(headerStyle);
		row.createCell(1).setCellValue("직급");
		row.getCell(1).setCellStyle(headerStyle);
		row.createCell(2).setCellValue("부서");
		row.getCell(2).setCellStyle(headerStyle);
		row.createCell(3).setCellValue("구분");
		row.getCell(3).setCellStyle(headerStyle);
		row.createCell(4).setCellValue("날짜");
		row.getCell(4).setCellStyle(headerStyle);
		row.createCell(5).setCellValue("시작시간");
		row.getCell(5).setCellStyle(headerStyle);
		row.createCell(6).setCellValue("종료시간");
		row.getCell(6).setCellStyle(headerStyle);
		
		//body
		for (int i = 0 ; i < attitudeList.size(); i++) { 
			AdminAttitudeVO vo = attitudeList.get(i);
			row = sheet.createRow(i + 1);

			row.createCell(0).setCellValue(vo.getUserName());
			row.getCell(0).setCellStyle(bodyStyle);
			row.createCell(1).setCellValue(vo.getUserTitle());
			row.getCell(1).setCellStyle(bodyStyle);
			row.createCell(2).setCellValue(vo.getDeptName());
			row.getCell(2).setCellStyle(bodyStyle);
			row.createCell(3).setCellValue(vo.getTypeName());
			row.getCell(3).setCellStyle(bodyStyle);
			if (vo.getEndDate() != null && vo.getEndDate() != "") {
				row.createCell(4).setCellValue(vo.getStartDate() + " ~ " + vo.getEndDate());
			} else {
				row.createCell(4).setCellValue(vo.getStartDate());
			}
			row.getCell(4).setCellStyle(bodyStyle);
			row.createCell(5).setCellValue(vo.getStartTime());
			row.getCell(5).setCellStyle(bodyStyle);
			if (vo.getEndTime() != null && vo.getEndTime() != "") {
				row.createCell(6).setCellValue(vo.getEndTime());
			} else {
				row.createCell(6).setCellValue("");
			}
			row.getCell(6).setCellStyle(bodyStyle);
		}
		
		//날짜(4번컬럼)는 길면 짤리므로 자동으로 너비조정을 해준다
		sheet.autoSizeColumn(4);
		
		response.setHeader("Content-Disposition", "attachment; fileName=\"" + pFileName + ".xls\"");
		workbook.write(response.getOutputStream());
		  
		workbook.close();
		
		LOGGER.debug("excelFileExport ended.");
	}
	
	
	
	
	
	//여기밑으로 제자리요
	

	/**
	 * 관리자 사용자별 근태설정 메인화면 호출
	 */
	//여기 그냥 화면만 떙기고 리스트는 post로 다시 땅기면
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
	 * 사용자별 근태설정 리스트 출력
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
		String searchCompareValue = request.getParameter("compareValue");
		String pageNum = request.getParameter("pageNum");
		String listSize = request.getParameter("listSize");
		String orderCell = request.getParameter("orderCell");
		String orderOption = request.getParameter("orderOption");
		String userId = userInfo.getId();
		String offsetMin = commonUtil.getMinuteUTC(userInfo.getOffset());
		
		LOGGER.debug("userName : " + searchUserName + " || deptName : " + searchDeptName + " + || searchTitle = " + searchTitle + " || searchStartTime = " + searchStartTime + " || searchEndTime = " + searchEndTime + " || searchCompareValue = " + searchCompareValue + " || pageNum : " + pageNum + " || listSize : " + listSize + " || orderCell : " + orderCell + " || orderOption : " + orderOption);
		
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
				.queryParam("searchCompareValue", searchCompareValue)
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
	 * 사용자 근무시간 설정 화면 출력(조직도 회사/부서리스트 포함)
	 * @param loginCookie
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/admin/ezAttitude/saveAttitudeUserConf.do")
	public String saveAttitudeUserConf(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception{
		
		LOGGER.debug("/admin/ezAttitude/saveAttitudeUserConf started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		String companyId = request.getParameter("companyId");
		String userList = request.getParameter("userList");
		
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
				if (dept.get("isComp").equals("comp")) {
					dept.put("icon", "icon-company");
				} else{
					dept.put("icon", "icon-dept");
				}
				if (dept.get("myDept").equals("yes")) {
					JSONObject state = new JSONObject();
					state.put("opened", "true");
					state.put("selected", "true");
					dept.put("state", state);
				}
			}
			
			model.addAttribute("deptList", deptList);
			model.addAttribute("companyId", companyId);
		}
		
		//회사 근무시간 정보
		url = gwServerUrl + "/rest/ezattitude/companies/" + companyId + "/attitudereg";
		
		builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("companyId", companyId)
				.queryParam("userId", userInfo.getId());
		
		result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		resultBody = (JSONObject) jp.parse(result.getBody());
		
		status = resultBody.get("status").toString();
		LOGGER.debug("status : " + status);
		if(status.equals("ok")){
			jObject = (JSONObject) resultBody.get("data");
			
			String workStartTime = (String) jObject.get("workStartTime");
			String workEndTime = (String) jObject.get("workEndTime");
			
			model.addAttribute("workStartTime", workStartTime);
			model.addAttribute("workEndTime", workEndTime);
		}
		
		//선택된 유저 리스트 정보
		if (userList != null) {
			String offset = userInfo.getOffset();
			String offsetMin = commonUtil.getMinuteUTC(offset);
			
			url = gwServerUrl + "/rest/ezattitude/users/users-attitude-confs";
			
			builder = UriComponentsBuilder.fromHttpUrl(url)
					.queryParam("companyId", companyId)
					.queryParam("userId", userInfo.getId())
					.queryParam("userIdList", userList)
					.queryParam("offsetMin", offsetMin);

			result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
			
			resultBody = (JSONObject) jp.parse(result.getBody());
			
			status = resultBody.get("status").toString();
			LOGGER.debug("status : " + status);
			
			if(status.equals("ok")){
				JSONArray jArray = (JSONArray) resultBody.get("data");
				
				model.addAttribute("userList", jArray);
			}
		} else {
			model.addAttribute("userList", "null");
		}
		
		LOGGER.debug("/admin/ezAttitude/saveAttitudeUserConf ended");
		
		return "admin/ezAttitude/saveAttitudeUserConf";
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
		
		return "admin/ezAttitude/attitudeAuthorManage";
	}
	
	@RequestMapping(value = "/admin/ezAttitude/attitudeAuthList.do")
	@ResponseBody
	public JSONObject getAttitudeAuthList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LOGGER.debug("/admin/ezAttitude/getAttitudeAuthList started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		String companyId = request.getParameter("companyId");
		
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		String url = gwServerUrl + "/rest/ezattitude/";
		
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
		
		if(status.equals("ok")){
			jObject = (JSONObject) resultBody.get("data");
		}
		
		LOGGER.debug("/admin/ezAttitude/getAttitudeAuthList ended");
		
		return jObject;
	} 
}
