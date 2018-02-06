package egovframework.ezEKP.ezWebFolder.web;

import java.util.Properties;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import com.google.gson.Gson;

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
        //Add more function here
        
		model.addAttribute("userId", userInfo.getId());
		model.addAttribute("userName", userInfo.getName());
        model.addAttribute("primary", userInfo.getPrimary());
        
		return "ezWebFolder/webFolderRight";
	}
	
	
	// getFolderList /ezwebfolder/users/{userId}/folder-list에 가는 메소드 
	@RequestMapping(value = "/ezWebFolder/folderList.do")
	public String getFolderList (@CookieValue("loginCookie") String loginCookie, HttpServletRequest request,
			HttpServletResponse resp, Model model )throws Exception {
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String gwServerUrl = config.getProperty("config.webFolderGWServerURL");
		
		String url = gwServerUrl + "/webfolder/users/" +userInfo.getId() + "/folder-list";
		
		RestTemplate rest = new RestTemplate();
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>( headers );
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url);
						
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp = new JSONParser();
		JSONObject resultBody = (JSONObject)jp.parse(result.getBody());
		LOGGER.debug(resultBody.get("status").toString());		
		LOGGER.debug(resultBody.get("id").toString());		
		LOGGER.debug(resultBody.get("test_GW").toString());		
		
		
//		JSONObject resultBody = result.getBody();
	
		String status = resultBody.get("status").toString();
		
		JSONObject test = new JSONObject();
		
		if (status.equals("ok")) {
			LOGGER.debug(resultBody.get("test_GW").toString());	
			test.put("test",resultBody.get("test_GW").toString());
			model.addAttribute("test", test);
			
		}
		
		return "json";
		
	}
	
	
	// 파일 리스트 가져오기 
	@RequestMapping(value = "/ezWebFolder/fileList.do")
	public String getFileList (@CookieValue("loginCookie") String loginCookie, HttpServletRequest request,
			HttpServletResponse resp, Model model )throws Exception {
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String gwServerUrl = config.getProperty("config.webFolderGWServerURL");
		String url = gwServerUrl + "/webfolder/folders/" +request.getParameter("folderId") + "/file-list";
//		String url = gwServerUrl + "/webfolder/folders/opensol/file-list";
		
		RestTemplate rest = new RestTemplate();
		
		// x-user-host : rest api에는 호스트명이 있어야 한다.
		// 컨트롤러에 구현할때만 그런건가 
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
//		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>( headers );
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
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("tenantId", request.getParameter("tenantId"))
				.queryParam("searchExt", searchExt)
				.queryParam("searchFileName", searchFileName)
				.queryParam("searchStartDate", searchStartDate)
				.queryParam("searchEndDate", searchEndDate)
				.queryParam("searchCreateName",searchCreateName)
				.queryParam("searchFileType", searchFileType)
				.queryParam("searchPageCount", searchPageCount)
				.queryParam("searchListCount", searchListCount);
		
		
		
		// 갔다 돌아옴
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp = new JSONParser();
		JSONObject resultBody = (JSONObject)jp.parse(result.getBody());
		String status = resultBody.get("status").toString();
		
		JSONObject test = new JSONObject();
		
		if (status.equals("ok")) {
			test.put("userInfo", userInfo);
			test.put("fileList",resultBody.get("fileList"));
			LOGGER.debug(test.toJSONString());
			model.addAttribute("fileList",test);
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
