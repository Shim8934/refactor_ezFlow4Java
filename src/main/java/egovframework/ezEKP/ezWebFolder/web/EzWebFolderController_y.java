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
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String folderType = request.getParameter("folderType")!=null? request.getParameter("folderType"): "";
        //Add more function here
		LOGGER.debug(request.getParameter("folderId"));
		LOGGER.debug("folderType"+ folderType+"은 이거임");
		System.out.println("main.do 에 들어오는 folderId = "+ request.getParameter("folderId"));
		model.addAttribute("folderType", folderType);
        model.addAttribute("folderId", request.getParameter("folderId"));
		model.addAttribute("userId", userInfo.getId());
		model.addAttribute("userName", userInfo.getName());
        model.addAttribute("primary", userInfo.getPrimary());
		return "ezWebFolder/webFolderRight";
	}
	
	
	// getFolderList /ezwebfolder/users/{userId}/folder-list에 가는 메소드 
	@RequestMapping(value = "/ezWebFolder/folderList.do")
	public String getFolderList (@CookieValue("loginCookie") String loginCookie, HttpServletRequest request,
			HttpServletResponse resp, Model model ){
		
		// tenantID, companyId, userId, folderType, folderId
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String folderType = request.getParameter("folderType") != null ? request.getParameter("folderType") : "";
		String folderId = request.getParameter("folderId") != null ? request.getParameter("folderId") : "";
		String gwServerUrl = config.getProperty("config.webFolderGWServerURL");
		String url = gwServerUrl + "/rest/ezwebfolder/users/" +userInfo.getId() + "/folder-list";
		String adminCheck = "";
		
		// admin인지 판단하는 if문 userInfoSimple에서는 찾을수 없음 LoginVO에서 찾을수 있음
//		if ( userInfo..indexOf("c=1") != -1 ) {
//			adminCheck = "ad";
//		}else {
//			adminCheck = "nad";
//		}
		
		
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
			System.out.println("에러라구");
			e.printStackTrace();
		}
		
		String status = resultBody.get("status").toString();
		
		JSONObject data = new JSONObject();
		
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
		
//		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		JSONObject jsonObject = new JSONObject();
		String folderId = request.getParameter("folderId")!=null? request.getParameter("folderId") : "";
		String folderType = request.getParameter("folderType")!=null? request.getParameter("folderType") : "";
		System.out.println("folderType"+folderType);
		int totalCount = Integer.parseInt(request.getParameter("totalCount"));
		int currPage  = Integer.parseInt(request.getParameter("currPage"));
		int listCount = Integer.parseInt(request.getParameter("listCount"));
		int totalPages = Integer.parseInt(request.getParameter("totalPages"));
		int pStart = Integer.parseInt(request.getParameter("pStart"));
		int pEnd = Integer.parseInt(request.getParameter("pEnd"));
		if ( currPage == 0 ) {
			currPage = 1;
		} 
		if ( listCount == 0 ) {
			listCount = 10;
		}
		if ( totalPages == 0 ) {
			totalPages = 1;
		}
		
		
		String searchExt = "" ;
		String searchFileName = "" ;
		String searchStartDate = "" ;
		String searchEndDate = ""  ;
		String searchCreateName = "" ;
		String searchFileType = ""  ;
		String searchPageCount = "" ;
		String searchListCount = "" ;
		// 여기에 userId,  companyId, tenantId 가지고 가기 
		
		
		if (request.getParameter("searchExt") != null ) {
			searchExt = request.getParameter("searchExt");
		}
		
		if (request.getParameter("searchFileName") != null ) {
			searchFileName = request.getParameter("searchFileName");
		}
		
		if (request.getParameter("searchStartDate") != null ) {
			searchStartDate = request.getParameter("searchStartDate");
		}
		
		if (request.getParameter("searchEndDate") != null ) {
			searchEndDate = request.getParameter("searchEndDate");
		}
		if (request.getParameter("searchCreateName") != null ) {
			searchCreateName = request.getParameter("searchCreateName");
		}
		if (request.getParameter("searchFileType") != null ) {
			searchFileType = request.getParameter("searchFileType");
		}
		if (request.getParameter("searchPageCount") != null ) {
			searchPageCount = request.getParameter("searchPageCount");
		}
		if (request.getParameter("searchListCount") != null ) {
			searchListCount = request.getParameter("searchListCount");
		}
		
		String gwServerUrl = config.getProperty("config.webFolderGWServerURL");
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
				.queryParam("pStart", pStart)                       
				.queryParam("pEnd", pEnd);                          
	
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
	public String folderControll (@CookieValue("loginCookie") String loginCookie, HttpServletRequest requtest,
			HttpServletResponse resp , Model model ) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
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
//		if (request.getParameter("folderType") == null || request.getParameter("folderType") =="" ) {
//			LOGGER.debug("fail_folderType is not comming");
//		}else {
//			folderType = request.getParameter("folderType");
//		}
		
		
		
		String serverName = request.getServerName();
		String gwServerUrl = config.getProperty("config.webFolderGWServerURL");
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
		System.out.println(status+": status");
		if (status.equals("ok")) {
			System.out.println("ok");
			model.addAttribute("status","ok");
			model.addAttribute("code",0);
		}else {
			System.out.println(status+" 여기는 controller");
			model.addAttribute("status","error");
			model.addAttribute("code",1);
		}
		return "json";
	}
	
	
	
	/*
	
	get   folderList
	
	get  folderListDetail
	
	post  folderInsert
	
	
	put  folderUpdate
	
	put   folderMove
	
	
	post    folderCopy
	
	delete folderDelete
	
	get   fileList
	
	
	*/
}
