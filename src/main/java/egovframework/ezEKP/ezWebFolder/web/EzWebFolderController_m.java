package egovframework.ezEKP.ezWebFolder.web;

import java.util.HashMap;
import java.util.Map;
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
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import egovframework.let.user.login.vo.LoginSimpleVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Controller
public class EzWebFolderController_m {
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
	private static final Logger logger = LoggerFactory.getLogger(EzWebFolderController_m.class);
	
	@RequestMapping(value="/ezWebFolder/webfolderSharingList.do")
	public String webfolderSharingList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception{
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		model.addAttribute("primary", userInfo.getLang());
		return "ezWebFolder/webfolderSharingList";
	}
	
	@RequestMapping(value="/ezWebFolder/getSharingList.do")
	public @ResponseBody String getSharingList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("getSharingList started.");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("pageNum", orElse(request.getParameter("pageNum"), "1"));
		param.put("pageSize", orElse(request.getParameter("pageSize"), "0"));
		param.put("searchFileType", orElse(request.getParameter("searchFileType"), ""));
		param.put("searchExt", orElse(request.getParameter("searchExt"), ""));
		param.put("searchFileName", orElse(request.getParameter("searchFileName"), ""));
		param.put("searchCreatorName", orElse(request.getParameter("searchCreatorName"), ""));
		param.put("searchStartDate", orElse(request.getParameter("searchStartDate"), ""));
		param.put("searchEndDate", orElse(request.getParameter("searchEndDate"), ""));
		
		JSONObject resultBody = commonUtil.getJsonFromWebFolderRestApi("/rest/ezwebfolder/users/" + userInfo.getId() + "/sharing", param, request, "get", null);
		
		logger.debug("getSharingList ended.");
		return resultBody.toString();
	}
	
	@RequestMapping(value="/ezWebFolder/webfolderSharedList.do")
	public String webfolderSharedList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception{
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		model.addAttribute("primary", userInfo.getLang());
		return "ezWebFolder/webfolderSharedList";
	}
	
	@RequestMapping(value="/ezWebFolder/getSharedList.do")
	public @ResponseBody String getSharedList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("getSharedList started.");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("pageNum", orElse(request.getParameter("pageNum"), "1"));
		param.put("pageSize", orElse(request.getParameter("pageSize"), "0"));
		param.put("searchFileType", orElse(request.getParameter("searchFileType"), ""));
		param.put("searchExt", orElse(request.getParameter("searchExt"), ""));
		param.put("searchFileName", orElse(request.getParameter("searchFileName"), ""));
		param.put("searchCreatorName", orElse(request.getParameter("searchCreatorName"), ""));
		param.put("searchStartDate", orElse(request.getParameter("searchStartDate"), ""));
		param.put("searchEndDate", orElse(request.getParameter("searchEndDate"), ""));
		
		JSONObject resultBody = commonUtil.getJsonFromWebFolderRestApi("/rest/ezwebfolder/users/" + userInfo.getId() + "/shared", param, request, "get", null);
		
		logger.debug("getSharedList ended.");
		return resultBody.toString();
	}
	
	@RequestMapping(value="/ezWebFolder/addShareView.do")
	public String addShareView(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("addShareView started.");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		String folderFileId = request.getParameter("folderFileId");
		String folderFileType = request.getParameter("folderFileType");
		
		JSONObject resultBody = commonUtil.getJsonFromWebFolderRestApi("/rest/ezwebfolder/users/" + userInfo.getId() + "/sharing/" + folderFileId + "/" + folderFileType, null, request, "get", null);
		
		if (((String) resultBody.get("status")).equals("ok")) {
			JSONObject shareInfo = (JSONObject) resultBody.get("data");
			
			if (shareInfo == null) {
				model.addAttribute("type", "NEW");
			} else {
				model.addAttribute("type", "EDIT");
				model.addAttribute("shareInfo", shareInfo);
			}
		}
		
		model.addAttribute("userInfo", commonUtil.userInfo(loginCookie));
		model.addAttribute("folderFileId", folderFileId);
		model.addAttribute("folderFileType", folderFileType);
		
		logger.debug("addShareView ended.");
		return "/ezWebFolder/shareUsersSelect";
	}
	
	@RequestMapping(value="/ezWebFolder/addShare.do", method=RequestMethod.POST)
	public @ResponseBody String addShare(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, @RequestBody JSONObject jsonParam, Model model) throws Exception {
		logger.debug("addShare started.");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		JSONObject resultBody = commonUtil.getJsonFromWebFolderRestApi("/rest/ezwebfolder/users/" + userInfo.getId() + "/sharing", null, request, "post", jsonParam);
		
		model.addAttribute("result", resultBody);
		
		logger.debug("addShare ended.");
		return  resultBody.toString();
	}
	
	@RequestMapping(value="/ezWebFolder/trashCan.do")
	public String trashCan (@CookieValue("loginCookie") String loginCookie, HttpServletRequest request,
			HttpServletResponse response, Model model )throws Exception {
		logger.debug("trashCan Started.");
		
		if (loginCookie == null) {
			logger.debug("trashCan illegal arguments!");
			return "cmm/error/egovError";
		}
		
		logger.debug("listCount=" + getUsrListCount(loginCookie, request));
		logger.debug("userInfo=" + commonUtil.userInfoSimple(loginCookie));
		model.addAttribute("listCount", getUsrListCount(loginCookie, request));
		model.addAttribute("userInfo", commonUtil.userInfoSimple(loginCookie));
		
		logger.debug("trashCan ended.");
		return "ezWebFolder/trashCan";
	}
	
	public String getUsrListCount (@CookieValue ("loginCookie") String loginCookie, HttpServletRequest requset) throws Exception {
		logger.debug("getUsrListCount Started.");

		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		String gwServerUrl = config.getProperty("config.webFolderGwServerURL");
		String url = gwServerUrl + "/rest/ezwebfolder/getUserListCount";
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
										.queryParam("tenantId", user.getTenantId())
										.queryParam("userId", user.getId());
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("host-name", requset.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.POST, entity, String.class);
		JSONParser jp = new JSONParser();
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		String listCount = "10";
		
		listCount = (String)resultBody.get("listCount").toString();
		
		logger.debug("getUsrListCount ended.");
		
		return listCount;
	}
	
	@RequestMapping(value="/ezWebFolder/getTrashCanList.do", method = RequestMethod.POST)
	public String getTrashCanList (@CookieValue("loginCookie") String loginCookie, Model model, 
			HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		logger.debug("getTrashCanList Started.");
		
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		String gwServerUrl = config.getProperty("config.webFolderGwServerURL");
		String url = gwServerUrl + "/rest/ezwebfolder/" + user.getId() + "/getTrashCanList";
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
										.queryParam("tenantId", user.getTenantId())
										.queryParam("offset", user.getOffset())
										.queryParam("currPage", Integer.parseInt(orElse(request.getParameter("currPage"), "1")))                   
										.queryParam("listCount", Integer.parseInt(orElse(request.getParameter("listCount"), "0")))
										.queryParam("searchExt", orElse(request.getParameter("searchExt"), "" ))               
										.queryParam("searchFileName", orElse(request.getParameter("searchFileName"), ""))               
										.queryParam("searchCreateName", orElse(request.getParameter("searchCreateName"), ""))               
										.queryParam("searchFileType", orElse(request.getParameter("searchFileType"), ""))               
										.queryParam("endrollStartDate", orElse(request.getParameter("enrollStartDate"), ""))               
										.queryParam("endrollEndDate", orElse(request.getParameter("enrollEndDate"), ""))               
										.queryParam("delStartDate", orElse(request.getParameter("delStartDate"), ""))               
										.queryParam("delEndDate", orElse(request.getParameter("delEndDate"), ""));               
		
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
		String fileList = orElse(request.getParameter("fileList"), "");
		String folderList = orElse(request.getParameter("folderList"), "");
		
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
		String gwServerUrl = config.getProperty("config.webFolderGwServerURL");
		String url = gwServerUrl + "/rest/ezwebfolder/file-permanent-delete";
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
										.queryParam("tenantId", user.getTenantId())
										.queryParam("offset", user.getOffset())
										.queryParam("userId", user.getId())
										.queryParam("lang", user.getLang())
										.queryParam("fileList", orElse(request.getParameter("fileList"), ""))
										.queryParam("folderList", orElse(request.getParameter("folderList"), ""));
		
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
	
	@RequestMapping(value="/ezWebFolder/restoreTrashCan.do", method= RequestMethod.POST)
	public String restoreTrashCan (@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("restoreFile Started");
		
		LoginVO user = commonUtil.userInfo(loginCookie);
		String gwServerUrl = config.getProperty("config.webFolderGwServerURL");
		String url = gwServerUrl + "/rest/ezwebfolder/restore-trashCan";
		
		
		UriComponentsBuilder butilder = UriComponentsBuilder.fromHttpUrl(url)
											.queryParam("tenantId", user.getTenantId())
											.queryParam("userId", user.getId())
											.queryParam("offset", user.getOffset())
											.queryParam("companyId", user.getCompanyID())
											.queryParam("fileList", orElse(request.getParameter("fileList"), ""))
											.queryParam("folderList", orElse(request.getParameter("folderList"), ""));
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("host-name", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(butilder.build().encode().toUri(), HttpMethod.POST, entity, String.class);
		JSONParser jp = new JSONParser();
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		String status = resultBody.get("status").toString();
		
		if (!status.equals("ok")) {
			String reason = resultBody.get("reason").toString();
			model.addAttribute("reason", reason);
		}
		
		
		logger.debug("status=" + status);
		logger.debug("restoreFile ended");
		return "json";
	}
	
	@RequestMapping(value = "/ezWebFolder/favorite.do")
	public String favor(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse resp, Model model) throws Exception {
		logger.debug("favorite started.");
		logger.debug("favorite ended.");
		return "ezWebFolder/webfolderFavorite";
	}

	@RequestMapping(value = "/ezWebFolder/getFavorites.do", method = RequestMethod.POST)
	public @ResponseBody String getUserFavorites(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getUserFavorites started.");
		
		LoginSimpleVO user	= commonUtil.userInfoSimple(loginCookie);
		
		String gwServerUrl	= config.getProperty("config.webFolderGwServerURL");
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
				.queryParam("searchFileType", orElse(request.getParameter("searchFileType"), ""))
				.queryParam("searchStartDate", orElse(request.getParameter("searchStartDate"), ""))
				.queryParam("searchEndDate", orElse(request.getParameter("searchEndDate"), ""))
				// limit info
				.queryParam("startIndex", orElse(request.getParameter("startIndex"), "0"))
				.queryParam("listCount", orElse(request.getParameter("listCount"), "0"));
		
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		logger.debug("getUserFavorites ended.");
		return result.getBody();
	}
	
	@RequestMapping(value = "/ezWebFolder/addFavorite.do", method = RequestMethod.POST)
	public @ResponseBody String addUserFavorite(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getFavorites started.");
		
		LoginSimpleVO user	= commonUtil.userInfoSimple(loginCookie);
		
		String gwServerUrl	= config.getProperty("config.webFolderGwServerURL");
		String requestUrl	= gwServerUrl + "/rest/ezwebfolder/users/" + user.getId() + "/favorite";
		
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
		
		String gwServerUrl	= config.getProperty("config.webFolderGwServerURL");
		String requestUrl	= gwServerUrl + "/rest/ezwebfolder/users/" + user.getId() + "/favorite";
		
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
	
	@RequestMapping(value="/ezWebFolder/moveTrashCanManage.do")
	public String moveTrashCanManage (@CookieValue ("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
	 String folderType = request.getParameter("folderType");
	 String fileList = request.getParameter("fileList");
	 String folderList = request.getParameter("folderList");
	 
	 model.addAttribute("folderType", folderType);
	 model.addAttribute("fileList", fileList);
	 model.addAttribute("folderList", folderList);
	 
	 logger.debug("fileList", fileList);
	 logger.debug("folderList", folderList);
	
	 logger.debug("folderType=" + folderType);
	 return "ezWebFolder/moveTrashCanManage";
	}
	
	@RequestMapping(value="/ezWebFolder/moveTrashCan.do", method=RequestMethod.POST)
	public String moveTrashCan (@CookieValue ("loginCookie")String loginCookie, HttpServletRequest request,
			HttpServletResponse response, Model model) throws Exception {
		logger.debug("moveTrashCan Started.");
		logger.debug("request.getParameter(fileList)=" + request.getParameter("fileList"));
		
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		String gwServerUrl = config.getProperty("config.webFolderGwServerURL");
		String url = gwServerUrl + "/rest/ezwebfolder/move-TrashCan";
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
										.queryParam("tenantId", user.getTenantId())
										.queryParam("offset", user.getOffset())
										.queryParam("userId", user.getId())
										.queryParam("lang", user.getLang())
										.queryParam("folderId", orElse(request.getParameter("folderId"), ""))
										.queryParam("fileList", orElse(request.getParameter("fileList"), ""))
										.queryParam("folderList", orElse(request.getParameter("folderList"), ""));
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("host-name", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.POST, entity, String.class);
		JSONParser jp = new JSONParser();
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		String status = resultBody.get("status").toString();
		
		if (!status.equals("ok")) {
			String reason = resultBody.get("reason").toString();
			model.addAttribute("reason", reason);
		}
		
		logger.debug("status=" + status);
		logger.debug("moveTrashCan ended");
		return "json";		
	}
	
	private <T> T orElse(T value, T other) {
		if (other == null) {
			throw new IllegalArgumentException("other is null!");
		}
		
		return value != null ? value : other;
	}
}
