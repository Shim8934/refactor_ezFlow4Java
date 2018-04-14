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
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import egovframework.let.user.login.vo.LoginSimpleVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@SuppressWarnings("unchecked")
@Controller
public class EzWebFolderController_m {
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
	private static final Logger logger = LoggerFactory.getLogger(EzWebFolderController_m.class);
	
	@RequestMapping(value="/ezWebFolder/getSharingList.do")
	public @ResponseBody String getSharingList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("getSharingList started.");
		
		LoginSimpleVO user   = commonUtil.userInfoSimple(loginCookie);
		String gwServerUrl   = config.getProperty("config.webfolderGwServerURL");
		String url           = gwServerUrl + "/rest/ezwebfolder/users/" + user.getId() + "/sharing-list";
		
		HttpHeaders headers  = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("host-name", request.getServerName());
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder  = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("pageNum",           orElse(request.getParameter("pageNum"), "1"))
				.queryParam("pageSize",          orElse(request.getParameter("pageSize"), "0"))
				.queryParam("searchFileType",    orElse(request.getParameter("searchFileType"), ""))
				.queryParam("searchExt",         orElse(request.getParameter("searchExt"), ""))
				.queryParam("searchFileName",    orElse(request.getParameter("searchFileName"), ""))
				.queryParam("searchCreatorName", orElse(request.getParameter("searchCreatorName"), ""))
				.queryParam("searchStartDate",   orElse(request.getParameter("searchStartDate"), ""))
				.queryParam("searchEndDate",     orElse(request.getParameter("searchEndDate"), ""));
		
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		logger.debug("getSharingList ended.");
		return result.getBody();
	}
	
	@RequestMapping(value="/ezWebFolder/getSharedList.do")
	public @ResponseBody String getSharedList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("getSharedList started.");
		
		LoginSimpleVO user   = commonUtil.userInfoSimple(loginCookie);
		String gwServerUrl   = config.getProperty("config.webfolderGwServerURL");
		String url           = gwServerUrl + "/rest/ezwebfolder/users/" + user.getId() + "/shared-list";
		
		HttpHeaders headers  = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("host-name", request.getServerName());
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder  = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("pageNum",           orElse(request.getParameter("pageNum"), "1"))
				.queryParam("pageSize",          orElse(request.getParameter("pageSize"), "0"))
				.queryParam("searchFileType",    orElse(request.getParameter("searchFileType"), ""))
				.queryParam("searchExt",         orElse(request.getParameter("searchExt"), ""))
				.queryParam("searchFileName",    orElse(request.getParameter("searchFileName"), ""))
				.queryParam("searchCreatorName", orElse(request.getParameter("searchCreatorName"), ""))
				.queryParam("searchStartDate",   orElse(request.getParameter("searchStartDate"), ""))
				.queryParam("searchEndDate",     orElse(request.getParameter("searchEndDate"), ""));
		
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		logger.debug("getSharedList ended.");
		return result.getBody();
	}
	
	@RequestMapping(value="/ezWebFolder/trashCan.do")
	public String trashCan (@CookieValue("loginCookie") String loginCookie, HttpServletRequest request,
			HttpServletResponse resp, Model model )throws Exception {
		logger.debug("trashCan Started.");
		
		if (loginCookie == null) {
			logger.debug("trashCan illegal arguments!");
			return "cmm/error/egovError";
		}
		
		logger.debug("userInfo=" + commonUtil.userInfoSimple(loginCookie));
		model.addAttribute("userInfo", commonUtil.userInfoSimple(loginCookie));
		
		logger.debug("trashCan ended.");
		return "ezWebFolder/trashCan";
	}
	
	@RequestMapping(value="/ezWebFolder/getTrashCanList.do", method = RequestMethod.POST)
	public String getTrashCanList (@CookieValue("loginCookie") String loginCookie, Model model, 
			HttpServletRequest request, HttpServletResponse response) throws Exception {
		String userId = request.getParameter("userId") !=null ? request.getParameter("userId") : "";
		int tenantId = request.getParameter("tenantId") !=null ? Integer.parseInt(request.getParameter("tenantId")) : 1;
		String offset = request.getParameter("offset") !=null ? request.getParameter("offset") : "";
		
		int listCount 	        = request.getParameter("listCount")         != null ? Integer.parseInt(request.getParameter("listCount")) 	: 0;
		int currPage 	        = request.getParameter("currPage")	        != null ? Integer.parseInt(request.getParameter("currPage")) 	: 1;
		int totalPages 	        = request.getParameter("totalpages")        != null ? Integer.parseInt(request.getParameter("totalpages")) 	: 1;
		int pStart 		        = request.getParameter("pStart")	        != null ? Integer.parseInt(request.getParameter("pStart"))		: 0;
		
		String searchExt 		= request.getParameter("searchExt")			!= null ? request.getParameter("searchExt") 		            : "" ;
		String searchFileName 	= request.getParameter("searchFileName") 	!= null ? request.getParameter("searchFileName")	            : "" ;
		String searchCreateName = request.getParameter("searchCreateName") 	!= null ? request.getParameter("searchCreateName") 	            : "" ;
		String searchFileType  = request.getParameter("searchFileType")		!= null ? request.getParameter("searchFileType") 	            : "" ;
		String endrollStartDate = request.getParameter("enrollStartDate")	!= null ? request.getParameter("enrollStartDate") 	            : "" ;
		String endrollEndDate 	= request.getParameter("enrollEndDate")		!= null ? request.getParameter("enrollEndDate") 	            : "" ;
		String delStartDate 	= request.getParameter("delStartDate")		!= null ? request.getParameter("delStartDate") 	            	: "" ;
		String delEndDate 		= request.getParameter("delEndDate")		!= null ? request.getParameter("delEndDate") 	            	: "" ;
		
		String gwServerUrl = config.getProperty("config.webFolderGWServerURL");
		String url = gwServerUrl + "/rest/ezwebfolder/" + userId + "/getTrashCanList";
		
		logger.debug("getTrashCanList Started.");
		logger.debug("tenantId=" + userId + ",offset=" + offset);
		logger.debug("userId=" + userId + ",listCount=" + listCount + ",currPage=" + currPage + ",totalPages=" + totalPages + ",pStart=" + pStart);
		
		if ( currPage == 0 ) {
			currPage = 1;
		} 
		
		if ( totalPages == 0 ) {
			totalPages = 1;
		}
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
										.queryParam("tenantId", tenantId)
										.queryParam("offset", offset)
										.queryParam("currPage", currPage)                   
										.queryParam("listCount", listCount)                 
										.queryParam("totalPages", totalPages)               
										.queryParam("pStart", pStart)
										.queryParam("searchExt", searchExt)               
										.queryParam("searchFileName", searchFileName)               
										.queryParam("searchCreateName", searchCreateName)               
										.queryParam("searchFileType", searchFileType)               
										.queryParam("endrollStartDate", endrollStartDate)               
										.queryParam("endrollEndDate", endrollEndDate)               
										.queryParam("delStartDate", delStartDate)               
										.queryParam("delEndDate", delEndDate);               
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("host-name", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.POST, entity, String.class);
		JSONParser jp = new JSONParser();
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
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
		
		logger.debug("status=" + status);
		logger.debug("data=" + resultBody.get("data"));
		logger.debug("getTrashCanList ended");
		
		return "json";
	}
	
	@RequestMapping(value="/ezWebFolder/permanentDeleteConfirm.do")
	public String permanentDeleteConfirm(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request,
			HttpServletResponse response, Model model) throws Exception {
		logger.debug("permanentDeleteConfirm Started.");
		String fileList = request.getParameter("fileList") != null ? request.getParameter("fileList") : "";
		String folderList = request.getParameter("folderList") != null ? request.getParameter("folderList") : "";
		
		if (fileList.equals("")) {
			logger.debug("Delete File Confirm illegal arguments!");
			return "cmm/error/egovError";
		}
		
		model.addAttribute("fileList", fileList);
		model.addAttribute("folderList", folderList);
		
		logger.debug("permanentDeleteConfirm ended.");
		return "ezWebFolder/filePermanentDelete";
	}
	
	@RequestMapping(value="/ezWebFolder/pemanentDeleteFile.do", method = RequestMethod.POST)
	public String pemanentDeleteFile (@CookieValue("loginCookie") String loginCookie, Model model, 
			HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("pemanentDeleteFile Started.");
		
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		String fileList = request.getParameter("fileList");
		String folderList = request.getParameter("folderList");
		String gwServerUrl = config.getProperty("config.webFolderGWServerURL");
		String url = gwServerUrl + "/rest/ezwebfolder/file-permanent-delete";
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
										.queryParam("tenantId", user.getTenantId())
										.queryParam("offset", user.getOffset())
										.queryParam("userId", user.getId())
										.queryParam("lang", user.getLang())
										.queryParam("fileList", fileList)
										.queryParam("folderList", folderList);
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("host-name", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.DELETE, entity, String.class);
		JSONParser jp = new JSONParser();
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		String status = resultBody.get("status").toString();
		
		if (!status.equals("ok")) {
			String reason = resultBody.get("reason").toString();
			model.addAttribute("reason", reason);
		}
		
		logger.debug("status=" + status);
		logger.debug("pemanentDeleteFile ended");
		return "json";
	}
	
	@RequestMapping(value = "/ezWebFolder/favorite.do")
	public String favor(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse resp, Model model) throws Exception {
		logger.debug("favorite started.");

		model.addAttribute("userInfo", commonUtil.userInfo(loginCookie));

		logger.debug("favorite ended.");
		return "ezWebFolder/favorite";
	}

	@RequestMapping(value = "/ezWebFolder/getFavorites.do", method = RequestMethod.POST)
	public @ResponseBody String getUserFavorites(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getUserFavorites started.");
		
		LoginSimpleVO user	= commonUtil.userInfoSimple(loginCookie);
		
		String gwServerUrl	= config.getProperty("config.webfolderGwServerURL");
		String requestUrl	= gwServerUrl + "/rest/ezwebfolder/users/" + user.getId() + "/favorites";
		
		HttpHeaders headers  = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("host-name", request.getServerName());
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder  = UriComponentsBuilder.fromHttpUrl(requestUrl)
				// user info
				.queryParam("offset", user.getOffset())
				.queryParam("primary", commonUtil.getPrimaryData(user.getLang(), user.getTenantId()))
				.queryParam("tenantId", user.getTenantId())
				// search info
				.queryParam("searchExt", orElse(request.getParameter("searchExt"), ""))
				.queryParam("searchFileName", orElse(request.getParameter("searchFileName"), ""))
				.queryParam("searchCreatorName", orElse(request.getParameter("searchCreatorName"), ""))
				.queryParam("searchStartDate", orElse(request.getParameter("searchStartDate"), ""))
				.queryParam("searchEndDate", orElse(request.getParameter("searchEndDate"), ""))
				// limit info
				.queryParam("startIndex", orElse(request.getParameter("startIndex"), ""))
				.queryParam("endIndex", orElse(request.getParameter("endIndex"), ""));
		
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		logger.debug("getUserFavorites ended.");
		return result.getBody();
	}
	
	@RequestMapping(value = "/ezWebFolder/addFavorite.do", method = RequestMethod.POST)
	public @ResponseBody String addUserFavorite(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getFavorites started.");
		
		LoginSimpleVO user	= commonUtil.userInfoSimple(loginCookie);
		
		String gwServerUrl	= config.getProperty("config.webfolderGwServerURL");
		String requestUrl	= gwServerUrl + "/rest/ezwebfolder/users/" + user.getId() + "/favorites";
		
		HttpHeaders headers  = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("host-name", request.getServerName());
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder  = UriComponentsBuilder.fromHttpUrl(requestUrl)
				// user info
				.queryParam("offset", user.getOffset())
				.queryParam("tenantId", user.getTenantId())
				// target info
				.queryParam("targetId", orElse(request.getParameter("targetId"), ""))
				.queryParam("targetType", orElse(request.getParameter("targetType"), ""));
		
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.POST, entity, String.class);
		
		logger.debug("getFavorites ended.");
		return result.getBody();
	}
	
	@RequestMapping(value = "/ezWebFolder/deleteFavorite.do", method = RequestMethod.POST)
	public @ResponseBody String deleteUserFavorite(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("deleteUserFavorite started.");
		
		LoginSimpleVO user	= commonUtil.userInfoSimple(loginCookie);
		
		JSONObject requesetObject = new JSONObject();
		requesetObject.put("targetId", orElse(request.getParameter("targetId"), ""));
		requesetObject.put("targetType", orElse(request.getParameter("targetType"), ""));
		requesetObject.put("tenantId", user.getTenantId());
		
		String gwServerUrl	= config.getProperty("config.webfolderGwServerURL");
		String requestUrl	= gwServerUrl + "/rest/ezwebfolder/users/" + user.getId() + "/favorites";
		
		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.APPLICATION_JSON);
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("host-name", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(requesetObject.toJSONString(), headers);
		
		UriComponentsBuilder builder  = UriComponentsBuilder.fromHttpUrl(requestUrl);
//				// user info
//				.queryParam("offset", user.getOffset())
//				.queryParam("tenantId", user.getTenantId())
//				// target info
//				.queryParam("targetId", orElse(request.getParameter("targetId"), ""))
//				.queryParam("targetType", orElse(request.getParameter("targetType"), ""));
		
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.DELETE, entity, String.class);
		
		logger.debug("deleteUserFavorite ended.");
		return result.getBody();
	}
	
	private <T> T orElse(T value, T other) {
		if (other == null) {
			throw new IllegalArgumentException("other is null!");
		}
		
		return value != null ? value : other;
	}
}
