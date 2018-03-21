package egovframework.ezEKP.ezAttitude.web;

import java.io.File;
import java.net.URI;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

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

import com.google.gson.Gson;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezAttitude.vo.AttitudeConfigVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeTypeVO;
import egovframework.let.user.login.vo.LoginSimpleVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
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
		if(status.equals("ok")){
			list = (JSONArray) resultBody.get("data");
			
			model.addAttribute("list", list);
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
		if(status.equals("ok")){
			list = (JSONArray) resultBody.get("data");
			
			LOGGER.debug("list : " + list);
			
			model.addAttribute("list", list);
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
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
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
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
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
		JSONArray formList = new JSONArray();
		String typeId = "";
		
		if (status.equals("ok")) {
			data = (JSONObject) resultBody.get("data");
			formList = (JSONArray) data.get("formList");
			typeId = (String) data.get("typeId");
			
			model.addAttribute("formList", formList);
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
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
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
		
		// 수정 /rest/ezattitude/companies/{companyId}/attitudetypes/{attitudetypeId}    PUT
		// 추가 /rest/ezattitude/companies/{companyId}/attitudetypes					   POST
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		String companyId = request.getParameter("companyId");
		String typeId = request.getParameter("typeId");
		String saveMode = request.getParameter("saveMode");
		String typeName = request.getParameter("typeName");
		String typeName2 = request.getParameter("typeName2");
		String imgPath = request.getParameter("imgPath");
		String formId = request.getParameter("formId");
		
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
				.queryParam("imgPath", imgPath)
				.queryParam("formId", formId);
		
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
	
}
