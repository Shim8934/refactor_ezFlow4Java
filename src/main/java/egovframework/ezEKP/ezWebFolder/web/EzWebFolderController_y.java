package egovframework.ezEKP.ezWebFolder.web;

import java.util.Properties;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import com.google.gson.Gson;

import egovframework.let.user.login.vo.LoginSimpleVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Controller
public class EzWebFolderController_y {

	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
	private static final Logger LOGGER = LoggerFactory.getLogger(EzWebFolderController_y.class);
	
	@RequestMapping(value="/ezWebFolder/main.do")
	public String main (@CookieValue("loginCookie") String loginCookie, HttpServletRequest request,
			HttpServletResponse resp, Model model )throws Exception {
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String folderType = request.getParameter("folderType")!=null? request.getParameter("folderType"): "";
        //Add more function here
		LOGGER.debug("main.do comming folderType is "+ folderType);
		LOGGER.debug("main.do comming folderId is "+ request.getParameter("folderId"));
		model.addAttribute("folderType", folderType);
        model.addAttribute("folderId", request.getParameter("folderId"));
		model.addAttribute("userId", userInfo.getId());
        model.addAttribute("lang", userInfo.getLang());
		return "ezWebFolder/webFolderRight";
	}
	
	// getFolderList /ezwebfolder/users/{userId}/folder-tree에 가는 메소드 
	@RequestMapping(value = "/ezWebFolder/folderList.do")
	public String getFolderList (@CookieValue("loginCookie") String loginCookie, HttpServletRequest request,
			HttpServletResponse resp, Model model ){
		
		// tenantID, companyId, userId, folderType, folderId
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String folderType = request.getParameter("folderType") != null ? request.getParameter("folderType") : "";
		String folderId = request.getParameter("folderId") != null ? request.getParameter("folderId") : "";
		String gwServerUrl = config.getProperty("config.webFolderGwServerURL");
		String url = gwServerUrl + "/rest/ezwebfolder/users/" +userInfo.getId() + "/folder-tree";

		RestTemplate rest = new RestTemplate();
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("host-name", request.getServerName());

		
		HttpEntity<?> entity = new HttpEntity<>( headers );
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("userId", userInfo.getId())
				.queryParam("folderType", folderType)
				.queryParam("folderId", folderId);
//				.queryParam("admin", adminCheck)
		
						
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp = new JSONParser();
		JSONObject resultBody = null;
		try {
			resultBody = (JSONObject)jp.parse(result.getBody());
		} catch (ParseException e) {
			LOGGER.debug("getFolderList status fail" );
			e.printStackTrace();
			model.addAttribute("status","error");
			model.addAttribute("code",1);
			model.addAttribute("data","");
		}
		
		String status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {
			model.addAttribute("status","ok");
			model.addAttribute("code",0);
			model.addAttribute("data",resultBody.get("data"));
		} else {
			model.addAttribute("status","error");
			model.addAttribute("code",1);
			model.addAttribute("data","");
		}

		return "json";
		
	}
	
	// 파일 리스트 가져오기 
	@RequestMapping(value = "/ezWebFolder/fileList.do")
	public String getFileList (@CookieValue("loginCookie") String loginCookie, HttpServletRequest request,
			HttpServletResponse resp, Model model )throws Exception {
		
		LoginSimpleVO userInfo 	= commonUtil.userInfoSimple(loginCookie);
		JSONObject jsonObject 	= new JSONObject();
		
		String folderId 		= request.getParameter("folderId")	        != null ? request.getParameter("folderId") 						: "";
		String folderType		= request.getParameter("folderType")        != null ? request.getParameter("folderType") 					: "";
		
		int totalCount 	        = request.getParameter("totalCount")        != null ? Integer.parseInt(request.getParameter("totalCount"))	: 0;
		int listCount 	        = request.getParameter("listCount")         != null ? Integer.parseInt(request.getParameter("listCount")) 	: 0;
		int currPage 	        = request.getParameter("currPage")	        != null ? Integer.parseInt(request.getParameter("currPage")) 	: 1;
		int totalPages 	        = request.getParameter("totalpages")        != null ? Integer.parseInt(request.getParameter("totalpages")) 	: 1;
		int pStart 		        = request.getParameter("pStart")	        != null ? Integer.parseInt(request.getParameter("pStart"))		: 0;
		
		String searchExt 		= request.getParameter("searchExt")			!= null ? request.getParameter("searchExt") 		            : "" ;
		String searchFileName 	= request.getParameter("searchFileName") 	!= null ? request.getParameter("searchFileName")	            : "" ;
		String searchStartDate 	= request.getParameter("searchStartDate")	!= null ? request.getParameter("searchStartDate") 	            : "" ;
		String searchEndDate 	= request.getParameter("searchEndDate") 	!= null ? request.getParameter("searchEndDate") 	            : "" ;
		String searchCreateName = request.getParameter("searchCreateName") 	!= null ? request.getParameter("searchCreateName") 	            : "" ;
		String searchFileType 	= request.getParameter("searchFileType") 	!= null ? request.getParameter("searchFileType") 	            : "" ;
		String searchPageCount 	= request.getParameter("searchPageCount") 	!= null ? request.getParameter("searchPageCount") 	            : "" ;
		
		LOGGER.debug("folderType : " + folderType + "foderControllder - getFolderList");
		LOGGER.debug("listCount : " + listCount + "currPage" + currPage+ "totalPages"+ totalPages  );
		
		if ( currPage == 0 ) {
			currPage = 1;
		} 
		if ( listCount == 0 ) {
			listCount = 0;
		}
		if ( totalPages == 0 ) {
			totalPages = 1;
		}
		
		// 여기에 userId,  companyId, tenantId 가지고 가기 
		
		String gwServerUrl = config.getProperty("config.webFolderGwServerURL");
		String url = gwServerUrl + "/rest/ezwebfolder/folders/" + folderId + "/file-list";
		
		RestTemplate rest = new RestTemplate();
		
		// host-name : rest api에는 호스트명이 있어야 한다.
		// 컨트롤러에 구현할때만 그런건가 
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("host-name", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>( headers );
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("userId", userInfo.getId())
				.queryParam("folderType", folderType)               
				.queryParam("searchExt", searchExt)                 
				.queryParam("searchFileName", searchFileName)       
				.queryParam("searchStartDate", searchStartDate)     
				.queryParam("searchEndDate", searchEndDate)         
				.queryParam("searchCreateName",searchCreateName)    
				.queryParam("searchFileType", searchFileType)       
				.queryParam("searchPageCount", searchPageCount)     
				.queryParam("totalCount", totalCount)               
				.queryParam("currPage", currPage)                   
				.queryParam("listCount", listCount)                 
				.queryParam("totalPages", totalPages)               
				.queryParam("pStart", pStart);                       
	
//		jsonObject.put("folderType", folderType);
//		jsonObject.put("searchExt", searchExt);
//		jsonObject.put("searchFileName", searchFileName);
//		jsonObject.put("searchStartDate", searchStartDate);
//		jsonObject.put("searchCreateName", searchCreateName);
//		jsonObject.put("searchFileType", searchFileType);
//		jsonObject.put("searchPageCount", searchPageCount);
//		jsonObject.put("totalCount", totalCount);
//		jsonObject.put("currPage", currPage);
//		jsonObject.put("listCount", listCount);
//		jsonObject.put("totalPages", totalPages);
//		jsonObject.put("pStart", pStart);
//		jsonObject.put("pEnd", pEnd);
		// 갔다 돌아옴
 		ResponseEntity<JSONObject> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, JSONObject.class);
 		
 		
		JSONObject resultBody = result.getBody();
		
		String status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {
			model.addAttribute("status","ok");
			model.addAttribute("code",0);
			model.addAttribute("data",resultBody.get("data"));
		}else {
			model.addAttribute("status","error");
			model.addAttribute("code",1);
			model.addAttribute("data","");
		}
		
		return "json";
	}
	
	@RequestMapping(value = "/ezWebFolder/treeTest.do")
	public String treeTest (@CookieValue("loginCookie") String loginCookie, HttpServletRequest request,
			HttpServletResponse resp, Model model )throws Exception {
	
		
		return "ezWebFolder/treeTest";
	}
	

	@RequestMapping( value ="/ezWebFolder/folderManage.do")
	public String folderControll (@CookieValue("loginCookie") String loginCookie, HttpServletRequest request,
			HttpServletResponse resp , Model model ) throws Exception {
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String folderType = request.getParameter("folderType");
		model.addAttribute("userId", userInfo.getId());
		model.addAttribute("folderType", folderType);
		LOGGER.debug("userId : " + userInfo.getId() + "folderType : " + folderType);
		return "ezWebFolder/folderManage";
		
	}
	@RequestMapping( value ="/ezWebFolder/inputNameDlg.do")
	public String inputNameDlg (@CookieValue("loginCookie") String loginCookie, HttpServletRequest requtest,
			HttpServletResponse resp , Model model ) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		return "ezWebFolder/newFolderInput";
		
	}
	
	@RequestMapping( value ="/ezWebFolder/insertFolder.do") 
	public String insertFolder (@CookieValue("loginCookie") String loginCookie, HttpServletRequest request,
			HttpServletResponse resp, Model model )throws Exception {
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String folderUppId = "";
//		String folderType = "";		
		String newFolderName1 = "";
		String newFolderName2 = "";
		
		if (request.getParameter("folderId").equals(null) || request.getParameter("folderId").equals("") ) {
			LOGGER.debug("fail_folderUpperId is not comming");
		}else {
			folderUppId = request.getParameter("folderId");
		}
		if (request.getParameter("newFolderName1").equals(null) || request.getParameter("newFolderName1").equals("")) {
			LOGGER.debug("fail_newFolderName is not comming");
		}else {
			newFolderName1 = request.getParameter("newFolderName1");
		}
		if (request.getParameter("newFolderName2").equals(null) || request.getParameter("newFolderName2").equals("")) {
			LOGGER.debug("fail_newFolderName is not comming");
			newFolderName2 = request.getParameter("newFolderName2");
		}else {
			newFolderName2 = request.getParameter("newFolderName2");
		}
		
		String serverName = request.getServerName();
		String gwServerUrl = config.getProperty("config.webFolderGwServerURL");
		String url = gwServerUrl + "/rest/ezwebfolder/folders";
		
		RestTemplate rest = new RestTemplate();
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("host-name", serverName);
		
		Gson gson = new Gson();
		String jsonString = gson.toJson(userInfo);
		JSONObject jsonObject = gson.fromJson(jsonString, JSONObject.class);
		HttpEntity<Object> entity = new HttpEntity<Object>( jsonObject,headers );
		
		jsonObject.put("userId", userInfo.getId());
		jsonObject.put("folderUppId", folderUppId);
		jsonObject.put("newFolderName1", newFolderName1);
		jsonObject.put("newFolderName2", newFolderName2);
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url);
				
		ResponseEntity<JSONObject> 	result = rest.exchange(builder.build().encode().toUri(), HttpMethod.POST, entity, JSONObject.class);

		
		JSONObject resultBody = result.getBody();
		LOGGER.debug("result: " + resultBody.get("status"));
		
		String status = resultBody.get("status").toString();
		if (status.equals("ok")) {
			LOGGER.debug("status : ok");
			model.addAttribute("status","ok");
			model.addAttribute("code",0);
		}else {
			LOGGER.debug("status : fail");
			model.addAttribute("status","error");
			model.addAttribute("code",1);
		}
		return "json";
	}
	
	@RequestMapping( value ="/ezWebFolder/updateFolder.do") 
	public String updateFolder (@CookieValue("loginCookie") String loginCookie, HttpServletRequest request,
			HttpServletResponse resp, Model model )throws Exception {
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String folderId = "";
		String newFolderName1 = "";
		String newFolderName2 = "";
		
		if (request.getParameter("folderId").equals(null) || request.getParameter("folderId").equals("") ) {
			LOGGER.debug("fail_folderUpperId is not comming");
		}else {
			folderId = request.getParameter("folderId");
		}
		if (request.getParameter("newFolderName1").equals(null) || request.getParameter("newFolderName1").equals("")) {
			LOGGER.debug("fail_newFolderName is not comming");
		}else {
			newFolderName1 = request.getParameter("newFolderName1");
		}
		if (request.getParameter("newFolderName2").equals(null) || request.getParameter("newFolderName2").equals("")) {
			LOGGER.debug("fail_newFolderName is not comming");
			newFolderName2 = request.getParameter("newFolderName2");
		}else {
			newFolderName2 = request.getParameter("newFolderName2");
		}
		
		String serverName = request.getServerName();
		String gwServerUrl = config.getProperty("config.webFolderGwServerURL");
		String url = gwServerUrl + "/rest/ezwebfolder/folders/"+folderId;
		
		RestTemplate rest = new RestTemplate();
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("host-name", serverName);
		
		Gson gson = new Gson();
		String jsonString = gson.toJson(userInfo);
		JSONObject jsonObject = gson.fromJson(jsonString, JSONObject.class);
		HttpEntity<Object> entity = new HttpEntity<Object>( jsonObject,headers );
		
		jsonObject.put("userId", userInfo.getId());
		jsonObject.put("newFolderName1", newFolderName1);
		jsonObject.put("newFolderName2", newFolderName2);
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url);
				
		ResponseEntity<JSONObject> 	result = rest.exchange(builder.build().encode().toUri(), HttpMethod.PUT, entity, JSONObject.class);

		
		JSONObject resultBody = result.getBody();
		LOGGER.debug("result: " + resultBody.get("status"));
		
		return "json";
	}
	
	
	@RequestMapping( value ="/ezWebFolder/folderDelete.do") 
	public String folderDelete (@CookieValue("loginCookie") String loginCookie, HttpServletRequest request,
			HttpServletResponse resp, Model model )throws Exception {
		
		return "ezWebFolder/folderDelete";
		
	}
		
	@RequestMapping( value ="/ezWebFolder/deleteFolder.do", method=RequestMethod.POST) 
	public String deleteFolder (@CookieValue("loginCookie") String loginCookie, HttpServletRequest request,
			HttpServletResponse resp, Model model )throws Exception {
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String folderId = "";
		
		if (request.getParameter("folderId").equals(null) || request.getParameter("folderId").equals("") ) {
			LOGGER.debug("fail_folderUpperId is not comming");
		}else {
			folderId = request.getParameter("folderId");
		}
		
		String serverName = request.getServerName();
		String gwServerUrl = config.getProperty("config.webFolderGwServerURL");
		String url = gwServerUrl + "/rest/ezwebfolder/folders/"+folderId;
		
		RestTemplate rest = new RestTemplate();
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("host-name", serverName);
		
		Gson gson = new Gson();
		String jsonString = gson.toJson(userInfo);
		
		JSONObject jsonObject = gson.fromJson(jsonString, JSONObject.class);
		HttpEntity<Object> entity = new HttpEntity<Object>( jsonObject,headers );
		
		jsonObject.put("id", userInfo.getId());
		jsonObject.put("uppFolderId", request.getParameter("uppFolderId"));
		jsonObject.put("lang", userInfo.getLang());
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url);
		
		ResponseEntity<JSONObject> 	result = rest.exchange(builder.build().encode().toUri(), HttpMethod.DELETE, entity, JSONObject.class);
		
		
		JSONObject resultBody = result.getBody();
		LOGGER.debug("result: " + resultBody.get("status"));
		String res = (String) resultBody.get("status");
		if (res.equals("ok")) {
			LOGGER.debug("deleteFolder status : ok");
			model.addAttribute("status","ok");
			model.addAttribute("code",0);
		}else {
			LOGGER.debug("deleteFolder status : error");
			model.addAttribute("status","error");
			model.addAttribute("code",1);
		}
		return "json";
	}
	
	
	@RequestMapping( value ="/ezWebFolder/folderMove.do") 
	public String folderMove (@CookieValue("loginCookie") String loginCookie, HttpServletRequest request,
			HttpServletResponse resp, Model model )throws Exception {
		
		return "ezWebFolder/folderMoveJsTree";
		
	}
	
	@RequestMapping( value ="/ezWebFolder/moveFolder.do", method=RequestMethod.POST) 
	public String moveFolder (@CookieValue("loginCookie") String loginCookie, HttpServletRequest request,
			HttpServletResponse resp, Model model )throws Exception {
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String folderId = "";
		
		
		if (request.getParameter("folderId").equals(null) || request.getParameter("folderId").equals("") ) {
			LOGGER.debug("fail_folderUpperId is not comming");
		}else {
			folderId = request.getParameter("folderId");
		}
		String serverName  = request.getServerName();
		String gwServerUrl = config.getProperty("config.webFolderGwServerURL");
		String mode        = request.getParameter("mode");
		String url  = "";
		if (mode.equals("folder-copy")) {
			url 		 = gwServerUrl + "/rest/ezwebfolder/folders/"+ folderId + "/"+mode;
		}else if (mode.equals("folder-move")){
			url          = gwServerUrl + "/rest/ezwebfolder/folders/"+folderId + "/"+mode;
		}else {
			LOGGER.debug("mode is not comming");
		}
		RestTemplate rest = new RestTemplate();
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("host-name", serverName);
		
		
		Gson gson = new Gson();
		String jsonString = gson.toJson(userInfo);
		JSONObject jsonObject = gson.fromJson(jsonString, JSONObject.class);
		HttpEntity<Object> entity = new HttpEntity<Object>( jsonObject,headers );
		LOGGER.debug("id : "+ userInfo.getId() + "folderId : "+ request.getParameter("folderId") 
				+ "uppFolderId : "+ request.getParameter("uppFolderId") + "lang : "+ userInfo.getLang());
		jsonObject.put("id", userInfo.getId());
		jsonObject.put("folderId", request.getParameter("folderId"));
		jsonObject.put("uppFolderId", request.getParameter("uppFolderId"));
		jsonObject.put("lang", userInfo.getLang());
//		jsonObject.put("mode", mode);
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url);
		
		ResponseEntity<JSONObject> 	result = rest.exchange(builder.build().encode().toUri(), HttpMethod.PUT, entity, JSONObject.class);
		
		JSONObject resultBody = result.getBody();
		String status               = resultBody.get("status").toString();
		String code                 = resultBody.get("code").toString();
		
		LOGGER.debug("moveFolder status " + status);
		if (status.equals("ok")) {
			LOGGER.debug("Move Folder finishes!");
			model.addAttribute("status",status);
			model.addAttribute("code",code);
		}else {
			LOGGER.debug("move Folder Fail");
			model.addAttribute("status",status);
			model.addAttribute("code",code);
		}
		
		return "json";
		
	}
	
}
