package egovframework.ezEKP.ezWebFolder.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpRequest;
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
	public @ResponseBody String getSharingList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
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
	public String webfolderSharedList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception{
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		model.addAttribute("primary", userInfo.getLang());
		return "ezWebFolder/webfolderSharedList";
	}
	
	@RequestMapping(value="/ezWebFolder/getSharedList.do")
	public @ResponseBody String getSharedList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
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
	
	@RequestMapping(value="/ezWebFolder/showShareInfo.do")
	public String showShareInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception{
		String folderFileId = request.getParameter("folderFileId");
		String folderFileType = request.getParameter("folderFileType");
		
		model.addAttribute("folderFileId", folderFileId);
		model.addAttribute("folderFileType", folderFileType);
		return "ezWebFolder/webfolderShareInfo";
	}
	
	@RequestMapping(value="/ezWebFolder/getShareInfo.do", method=RequestMethod.POST)
	public @ResponseBody String getShareInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getShareInfo started.");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		String folderFileId = request.getParameter("folderFileId");
		String folderFileType = request.getParameter("folderFileType");
		
		JSONObject resultBody = commonUtil.getJsonFromWebFolderRestApi("/rest/ezwebfolder/users/" + userInfo.getId() + "/sharing/" + folderFileId + "/" + folderFileType + "/all", null, request, "get", null);
		
		logger.debug("getShareInfo ended.");
		return resultBody.toString();
	}
	
	@RequestMapping(value="/ezWebFolder/getShareUserList.do", method=RequestMethod.POST)
	public @ResponseBody String getShareUserList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getShareUserList started.");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		String folderFileId = request.getParameter("folderFileId");
		String folderFileType = request.getParameter("folderFileType");
		
		JSONObject resultBody = commonUtil.getJsonFromWebFolderRestApi("/rest/ezwebfolder/users/" + userInfo.getId() + "/sharing/" + folderFileId + "/" + folderFileType, null, request, "get", null);
		String result = "";
		
		if (((String) resultBody.get("status")).equals("ok")) {
			JSONObject shareInfo = (JSONObject) resultBody.get("data");
			
			if (shareInfo != null) {
				JSONArray userListJson = (JSONArray) shareInfo.get("userList");
				JSONObject userAndDeptList = new JSONObject();
				JSONArray userList = new JSONArray();
				JSONArray deptList = new JSONArray();
				
				for (int i = 0; i < userListJson.size(); i++) {
					JSONObject orgObj = (JSONObject) userListJson.get(i);
					JSONObject obj = new JSONObject();
					if (((String) orgObj.get("userType")).equals("U")) {
						obj.put("userId", (String) orgObj.get("userId")); 
						obj.put("userName", (String) orgObj.get("userName")); 
						userList.add(obj);
					} else {
						obj.put("deptId", (String) orgObj.get("userId")); 
						obj.put("deptName", (String) orgObj.get("userName")); 
						deptList.add(obj);
					}
				}
				
				userAndDeptList.put("user", userList);
				userAndDeptList.put("dept", deptList);
				
				shareInfo.put("userList", userAndDeptList);
				
				result = resultBody.toString();
			}
		} else {
			result = resultBody.toString();
		}
		
		logger.debug("result: " + result);
		logger.debug("getShareUserList ended.");
		return result;
	}
	
	@RequestMapping(value="/ezWebFolder/addShareView.do")
	public String addShareView(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("addShareView started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String folderFileId = request.getParameter("folderFileId");
		String folderFileType = request.getParameter("folderFileType");
		
		JSONObject resultBody = commonUtil.getJsonFromWebFolderRestApi("/rest/ezwebfolder/users/" + userInfo.getId() + "/sharing/" + folderFileId + "/" + folderFileType, null, request, "get", null);
		
		if (((String) resultBody.get("status")).equals("ok")) {
			JSONObject shareInfo = (JSONObject) resultBody.get("data");
			
			if (shareInfo == null) {
				model.addAttribute("type", "NEW");
			} else {
				model.addAttribute("type", "EDIT");
			}
		}
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("folderFileId", folderFileId);
		model.addAttribute("folderFileType", folderFileType);
		
		logger.debug("addShareView ended.");
		return "/ezWebFolder/shareUsersSelect";
	}
	
	@RequestMapping(value="/ezWebFolder/addShare.do", method=RequestMethod.POST)
	public @ResponseBody String addShare(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, @RequestBody JSONObject jsonParam) throws Exception {
		logger.debug("addShare started.");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		String folderFileId = (String) jsonParam.get("folderFileId");
		String folderFileType = (String) jsonParam.get("folderFileType");
		
		JSONObject resultBody = commonUtil.getJsonFromWebFolderRestApi("/rest/ezwebfolder/users/" + userInfo.getId() + "/sharing/" + folderFileId + "/" + folderFileType, null, request, "get", null);
		
		if (((String) resultBody.get("status")).equals("ok")) {
			JSONObject shareInfo = (JSONObject) resultBody.get("data");
			
			if (shareInfo == null) {
				resultBody = commonUtil.getJsonFromWebFolderRestApi("/rest/ezwebfolder/users/" + userInfo.getId() + "/sharing", null, request, "post", jsonParam);
			} else {
				resultBody = commonUtil.getJsonFromWebFolderRestApi("/rest/ezwebfolder/users/" + userInfo.getId() + "/sharing/" + folderFileId + "/" + folderFileType, null, request, "put", jsonParam);
			}
		}
		
		logger.debug("addShare ended.");
		return  resultBody.toString();
	}
	
	@RequestMapping(value="/ezWebFolder/deleteShare.do", method=RequestMethod.POST)
	public @ResponseBody String deleteShare(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, @RequestBody List<Map<String,String>> jsonParam) throws Exception {
		logger.debug("deleteShare started.");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		JSONObject resultJson = new JSONObject();
		
		if (jsonParam == null || jsonParam.size() == 0) {
			resultJson.put("status", "error");
			resultJson.put("code", "1");
			return resultJson.toString();
		}
		
		String status = "ok";
		String code = "0";
		
		JSONObject resultBody = null;
		Map<String, String> obj = null;
		String folderFileId = null;
		String folderFileType = null;
		
		for (int i = 0; i < jsonParam.size(); i++) {
			obj = (Map<String, String>) jsonParam.get(i);
			folderFileId = obj.get("folderFileId");
			folderFileType = obj.get("folderFileType");
			
			resultBody = commonUtil.getJsonFromWebFolderRestApi("/rest/ezwebfolder/users/" + userInfo.getId() + "/sharing/" + folderFileId + "/" + folderFileType, null, request, "delete", null);
			
			if (!((String) resultBody.get("status")).equals("ok")) {
				status = "error";
				code = "2";
			}
		}
		
		resultJson.put("status", status);
		resultJson.put("code", code);
		
		logger.debug("deleteShare ended.");
		return  resultJson.toString();
	}
	
	@RequestMapping(value="/ezWebFolder/hideShare.do", method=RequestMethod.POST)
	public @ResponseBody String hideShare(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, @RequestBody List<Map<String,String>> jsonParam) throws Exception {
		logger.debug("hideShare started.");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		JSONObject resultJson = new JSONObject();
		
		if (jsonParam == null || jsonParam.size() == 0) {
			resultJson.put("status", "error");
			resultJson.put("code", "1");
			return resultJson.toString();
		}
		
		String status = "ok";
		String code = "0";
		
		JSONObject resultBody = null;
		Map<String, String> obj = null;
		String folderFileId = null;
		String folderFileType = null;
		
		for (int i = 0; i < jsonParam.size(); i++) {
			obj = (Map<String, String>) jsonParam.get(i);
			folderFileId = obj.get("folderFileId");
			folderFileType = obj.get("folderFileType");
			
			resultBody = commonUtil.getJsonFromWebFolderRestApi("/rest/ezwebfolder/users/" + userInfo.getId() + "/shared-hide/" + folderFileId + "/" + folderFileType, null, request, "post", null);
			
			if (!((String) resultBody.get("status")).equals("ok")) {
				status = "error";
				code = "2";
			}
		}
		
		resultJson.put("status", status);
		resultJson.put("code", code);
		
		logger.debug("hideShare ended.");
		return  resultJson.toString();
	}
	
	@RequestMapping(value="/ezWebFolder/showShare.do", method=RequestMethod.POST)
	public @ResponseBody String showShare(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, @RequestBody List<Map<String,String>> jsonParam) throws Exception {
		logger.debug("showShare started.");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		JSONObject resultJson = new JSONObject();
		
		if (jsonParam == null || jsonParam.size() == 0) {
			resultJson.put("status", "error");
			resultJson.put("code", "1");
			return resultJson.toString();
		}
		
		String status = "ok";
		String code = "0";
		
		JSONObject resultBody = null;
		Map<String, String> obj = null;
		String folderFileId = null;
		String folderFileType = null;
		
		for (int i = 0; i < jsonParam.size(); i++) {
			obj = (Map<String, String>) jsonParam.get(i);
			folderFileId = obj.get("folderFileId");
			folderFileType = obj.get("folderFileType");
			
			resultBody = commonUtil.getJsonFromWebFolderRestApi("/rest/ezwebfolder/users/" + userInfo.getId() + "/shared-hide/" + folderFileId + "/" + folderFileType, null, request, "delete", null);
			
			if (!((String) resultBody.get("status")).equals("ok")) {
				status = "error";
				code = "2";
			}
		}
		
		resultJson.put("status", status);
		resultJson.put("code", code);
		
		logger.debug("showShare ended.");
		return  resultJson.toString();
	}
	
	@RequestMapping(value="/ezWebFolder/webfolderHiddenSharedList.do")
	public String webfolderHiddenSharedList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception{
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		model.addAttribute("primary", userInfo.getLang());
		return "ezWebFolder/webfolderHiddenSharedList";
	}
	
	@RequestMapping(value="/ezWebFolder/getHiddenSharedList.do")
	public @ResponseBody String getHiddenSharedList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getHiddenSharedList started.");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("pageNum", orElse(request.getParameter("pageNum"), "1"));
		param.put("pageSize", orElse(request.getParameter("pageSize"), "0"));
		
		JSONObject resultBody = commonUtil.getJsonFromWebFolderRestApi("/rest/ezwebfolder/users/" + userInfo.getId() + "/shared-hide", param, request, "get", null);
		
		logger.debug("getHiddenSharedList ended.");
		return resultBody.toString();
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
		
		Map<String, Object> param = new HashMap<String, Object>();
		
		param.put("tenantId", user.getTenantId());
		param.put("offset", user.getOffset());
		param.put("currPage", Integer.parseInt(orElse(request.getParameter("currPage"), "1")));
		param.put("listCount", Integer.parseInt(orElse(request.getParameter("listCount"), "0")));
		param.put("searchExt", orElse(request.getParameter("searchExt"), "" ));
		param.put("searchFileName", orElse(request.getParameter("searchFileName"), ""));
		param.put("searchCreateName", orElse(request.getParameter("searchCreateName"), ""));
		param.put("searchFileType", orElse(request.getParameter("searchFileType"), ""));
		param.put("endrollStartDate", orElse(request.getParameter("enrollStartDate"), ""));
		param.put("endrollEndDate", orElse(request.getParameter("enrollEndDate"), ""));
		param.put("delStartDate", orElse(request.getParameter("delStartDate"), ""));
		param.put("delEndDate", orElse(request.getParameter("delEndDate"), ""));
		param.put("column", orElse(request.getParameter("column"), ""));
		param.put("order", orElse(request.getParameter("order"), ""));
		param.put("mode", orElse(request.getParameter("mode"), "" ));
		
		JSONObject resultBody = commonUtil.getJsonFromWebFolderRestApi("/rest/ezwebfolder/" + user.getId() + "/getTrashCanList", param, request, "post", null);
		
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
		
		Map<String, Object> param = new HashMap<String, Object>();
		
		param.put("tenantId", user.getTenantId());
		param.put("offset", user.getOffset());
		param.put("userId", user.getId());                 
		param.put("lang", user.getLang());
		param.put("fileList", orElse(request.getParameter("fileList"), ""));               
		param.put("folderList", orElse(request.getParameter("folderList"), ""));               
		
		JSONObject resultBody = commonUtil.getJsonFromWebFolderRestApi("/rest/ezwebfolder/file-permanent-delete", param, request, "delete", null);
		
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
		
		Map<String, Object> param = new HashMap<String, Object>();
		
		param.put("tenantId", user.getTenantId());
		param.put("offset", user.getOffset());
		param.put("userId", user.getId());                 
		param.put("companyId", user.getCompanyID());
		param.put("fileList", orElse(request.getParameter("fileList"), ""));               
		param.put("folderList", orElse(request.getParameter("folderList"), ""));               
		
		JSONObject resultBody = commonUtil.getJsonFromWebFolderRestApi("/rest/ezwebfolder/restore-trashCan", param, request, "post", null);

		String status = resultBody.get("status").toString();
		
		if (status.equals("ok")) {
			String code = resultBody.get("code").toString();
			model.addAttribute("code", code);
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

		Map<String, Object> param = new HashMap<>();
		// search info
		param.put("searchExt", orElse(request.getParameter("searchExt"), ""));
		param.put("searchFileName", orElse(request.getParameter("searchFileName"), ""));
		param.put("searchCreatorName", orElse(request.getParameter("searchCreatorName"), ""));
		param.put("searchFileType", orElse(request.getParameter("searchFileType"), ""));
		param.put("searchStartDate", orElse(request.getParameter("searchStartDate"), ""));
		param.put("searchEndDate", orElse(request.getParameter("searchEndDate"), ""));
		// limit info
		param.put("startIndex", orElse(request.getParameter("startIndex"), "0"));
		param.put("listCount", orElse(request.getParameter("listCount"), "0"));
		
		JSONObject result = commonUtil.getJsonFromWebFolderRestApi("/rest/ezwebfolder/users/" + user.getId() + "/favorites", param, request, "get", null);
		
		logger.debug("getUserFavorites ended.");
		return result.toString();
	}
	
	@RequestMapping(value = "/ezWebFolder/addFavorite.do", method = RequestMethod.POST)
	public @ResponseBody String addUserFavorite(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getFavorites started.");
		
		LoginSimpleVO user	= commonUtil.userInfoSimple(loginCookie);
		String fileList = orElse(request.getParameter("fileList"), "");
		String folderList = orElse(request.getParameter("folderList"), "");
		
		Map<String, Object> param = new HashMap<>();
		// target info
		param.put("fileList", fileList);
		param.put("folderList", folderList);
		
		JSONObject permissionResult = checkPermission(request, user.getId(), fileList, folderList);
		
		if ("error".equals(permissionResult.get("status"))) {
			return permissionResult.toString();
		}
		
		JSONObject result = commonUtil.getJsonFromWebFolderRestApi("/rest/ezwebfolder/users/" + user.getId() + "/favorite", param, request, "post", null);
		
		logger.debug("getFavorites ended.");
		return result.toString();
	}
	
	@RequestMapping(value = "/ezWebFolder/deleteFavorite.do", method = RequestMethod.POST)
	public @ResponseBody String deleteUserFavorite(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("deleteUserFavorite started.");
		
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		
		Map<String, Object> jsonParam = new HashMap<>();
		jsonParam.put("fileList", orElse(request.getParameter("fileList"), ""));
		jsonParam.put("folderList", orElse(request.getParameter("folderList"), ""));
		
		JSONObject result = commonUtil.getJsonFromWebFolderRestApi("/rest/ezwebfolder/users/" + user.getId() + "/favorite", null, request, "delete", new JSONObject(jsonParam));
		
		logger.debug("deleteUserFavorite ended.");
		return result.toString();
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
		
		Map<String, Object> param = new HashMap<String, Object>();
		
		param.put("tenantId", user.getTenantId());
		param.put("offset", user.getOffset());
		param.put("userId", user.getId());                 
		param.put("lang", user.getLang());
		param.put("folderId", orElse(request.getParameter("folderId"), ""));               
		param.put("fileList", orElse(request.getParameter("fileList"), ""));               
		param.put("folderList", orElse(request.getParameter("folderList"), ""));               
		
		JSONObject resultBody = commonUtil.getJsonFromWebFolderRestApi("/rest/ezwebfolder/move-TrashCan", param, request, "post", null);
		
		String status = resultBody.get("status").toString();
		model.addAttribute("status", status);
		
		if (!status.equals("ok")) {
			String reason = resultBody.get("reason").toString();
			model.addAttribute("reason", reason);
		}
		
		logger.debug("status=" + status);
		logger.debug("moveTrashCan ended");
		return "json";		
	}
	
	private JSONObject checkPermission(HttpServletRequest request, String userId, String fileList, String folderList) {
		Map<String, Object> checkPermission = new HashMap<>();
		List<Map<String, Object>> checkList = new ArrayList<>();
		Map<String, Object> map;
		
		String[] fileArray = fileList.split(",");
		String[] folderArray = folderList.split(",");
		
		for (String fileId : fileArray) {
			if (fileId.isEmpty()) {
				continue;
			}
			
			map = new HashMap<>();
			map.put("checkId", fileId);
			map.put("checkType", "F");
			
			checkList.add(map);
		}
		
		for (String folderId : folderArray) {
			if (folderId.isEmpty()) {
				continue;
			}
			
			map = new HashMap<>();
			map.put("checkId", folderId);
			map.put("checkType", "D");
			
			checkList.add(map);
		}
		
		checkPermission.put("checkList"	, checkList);
		
		return commonUtil.getJsonFromWebFolderRestApi("/rest/ezwebfolder/users/" + userId + "/checkpermission", null, request, "post", new JSONObject(checkPermission));
	}
	
	private <T> T orElse(T value, T other) {
		if (other == null) {
			throw new IllegalArgumentException("other is null!");
		}
		
		return value != null ? value : other;
	}
}
