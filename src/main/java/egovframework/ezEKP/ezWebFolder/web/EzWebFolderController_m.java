package egovframework.ezEKP.ezWebFolder.web;

import static org.apache.commons.lang3.StringUtils.defaultString;

import java.security.MessageDigest;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Optional;
import java.util.Properties;

import javax.annotation.Resource;
import javax.mail.internet.InternetAddress;
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
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezNotification.service.EzNotificationService;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderService_m;
import egovframework.ezEKP.ezWebFolder.vo.DuplicateInfoVO.Type;
import egovframework.let.user.login.vo.LoginSimpleVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.rest.Rest;
import egovframework.let.utl.rest.Rest.Module;

@Controller
public class EzWebFolderController_m {

	private static final Logger logger = LoggerFactory.getLogger(EzWebFolderController_m.class);

	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
	@Autowired
	private EzWebFolderService_m ezWebFolderService_m;
	
	@Autowired
	private EzCommonService ezCommonService;
	
	@Autowired
	private EzEmailService ezEmailService;
	
	@Resource(name = "egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Resource(name = "EzNotificationService")
	private EzNotificationService ezNotificationService;

	@Autowired
	private Rest rest;

	@RequestMapping(value="/ezWebFolder/webfolderSharingList.do", method = RequestMethod.GET)
	public String webfolderSharingList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String userId = userInfo.getId();

		boolean usePreview = "1".equalsIgnoreCase(commonUtil.getTenantConfigRest("useImageConvertServer", userId, request));
		boolean useVersionHistory = "YES".equalsIgnoreCase(commonUtil.getTenantConfigRest("useWebfolderVersionHistory", userId, request));

		model.addAttribute("primary", userId);
		model.addAttribute("userId", userId);
		model.addAttribute("usePreview", usePreview);
		model.addAttribute("useVersionHistory", useVersionHistory);

		return "ezWebFolder/webfolderSharingList";
	}
	
	@RequestMapping(value="/ezWebFolder/getSharingList.do", method = RequestMethod.POST)
	public @ResponseBody JSONObject getSharingList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getSharingList started.");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("pageNum", orElse(request.getParameter("pageNum"), "1"));
		param.put("pageSize", orElse(request.getParameter("pageSize"), "0"));
		param.put("subSearchFlag", orElse(request.getParameter("subSearchFlag"), "N"));
		param.put("searchFileType", orElse(request.getParameter("searchFileType"), ""));
		param.put("searchExt", orElse(request.getParameter("searchExt"), ""));
		param.put("searchFileName", orElse(request.getParameter("searchFileName"), ""));
		param.put("searchCreatorName", orElse(request.getParameter("searchCreatorName"), ""));
		param.put("searchStartDate", orElse(request.getParameter("searchStartDate"), ""));
		param.put("searchEndDate", orElse(request.getParameter("searchEndDate"), ""));
		param.put("sortType", orElse(request.getParameter("sortType"), ""));
		param.put("sortColumn", orElse(request.getParameter("sortColumn"), ""));
		
		JSONObject resultBody = commonUtil.getJsonFromWebFolderRestApi("/rest/ezwebfolder/users/" + userInfo.getId() + "/sharing", param, request, "get", null);
		
		logger.debug("getSharingList ended.");
		return resultBody;
	}
	
	@RequestMapping(value="/ezWebFolder/webfolderSharedList.do", method = RequestMethod.GET)
	public String webfolderSharedList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String userId = userInfo.getId();

		boolean usePreview = "1".equalsIgnoreCase(commonUtil.getTenantConfigRest("useImageConvertServer", userId, request));
		boolean useVersionHistory = "YES".equalsIgnoreCase(commonUtil.getTenantConfigRest("useWebfolderVersionHistory", userId, request));

		model.addAttribute("primary", userId);
		model.addAttribute("userId", userId);
		model.addAttribute("usePreview", usePreview);
		model.addAttribute("useVersionHistory", useVersionHistory);

		return "ezWebFolder/webfolderSharedList";
	}
	
	@RequestMapping(value="/ezWebFolder/getSharedList.do", method = RequestMethod.POST)
	public @ResponseBody JSONObject getSharedList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getSharedList started.");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("pageNum", orElse(request.getParameter("pageNum"), "1"));
		param.put("pageSize", orElse(request.getParameter("pageSize"), "0"));
		param.put("subSearchFlag", orElse(request.getParameter("subSearchFlag"), "N"));
		param.put("searchFileType", orElse(request.getParameter("searchFileType"), ""));
		param.put("searchExt", orElse(request.getParameter("searchExt"), ""));
		param.put("searchFileName", orElse(request.getParameter("searchFileName"), ""));
		param.put("searchCreatorName", orElse(request.getParameter("searchCreatorName"), ""));
		param.put("searchStartDate", orElse(request.getParameter("searchStartDate"), ""));
		param.put("searchEndDate", orElse(request.getParameter("searchEndDate"), ""));
		param.put("sortType", orElse(request.getParameter("sortType"), ""));
		param.put("sortColumn", orElse(request.getParameter("sortColumn"), ""));
		
		JSONObject resultBody = commonUtil.getJsonFromWebFolderRestApi("/rest/ezwebfolder/users/" + userInfo.getId() + "/shared", param, request, "get", null);
		
		logger.debug("getSharedList ended.");
		return resultBody;
	}
	
	@RequestMapping(value="/ezWebFolder/showShareInfo.do", method = RequestMethod.GET)
	public String showShareInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception{
		String folderFileId = request.getParameter("folderFileId");
		String folderFileType = request.getParameter("folderFileType");
		
		model.addAttribute("folderFileId", folderFileId);
		model.addAttribute("folderFileType", folderFileType);
		return "ezWebFolder/webfolderShareInfo";
	}
	
	@RequestMapping(value="/ezWebFolder/getShareInfo.do", method=RequestMethod.POST)
	public @ResponseBody JSONObject getShareInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getShareInfo started.");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		String folderFileId = request.getParameter("folderFileId");
		String folderFileType = request.getParameter("folderFileType");
		
		JSONObject resultBody = commonUtil.getJsonFromWebFolderRestApi("/rest/ezwebfolder/users/" + userInfo.getId() + "/sharing/" + folderFileId + "/" + folderFileType + "/all", null, request, "get", null);
		
		logger.debug("getShareInfo ended.");
		return resultBody;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/ezWebFolder/getShareUserList.do", method=RequestMethod.POST)
	public @ResponseBody JSONObject getShareUserList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
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
					if (MessageDigest.isEqual(orgObj.get("userType").toString().getBytes(), "U".getBytes())) {
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
		return resultBody;
	}
	
	@RequestMapping(value="/ezWebFolder/addShareView.do", method = RequestMethod.GET)
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
	public @ResponseBody JSONObject addShare(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("addShare started.");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		String folderFileId = request.getParameter("folderFileId");
		String folderFileType = request.getParameter("folderFileType");
		String deptList = request.getParameter("deptList");
		String userList = request.getParameter("userList");
		
		JSONObject resultBody = commonUtil.getJsonFromWebFolderRestApi("/rest/ezwebfolder/users/" + userInfo.getId() + "/sharing/" + folderFileId + "/" + folderFileType, null, request, "get", null);
		
		if (((String) resultBody.get("status")).equals("ok")) {
			JSONObject shareInfo = (JSONObject) resultBody.get("data");
			
			Map<String, Object> param = new HashMap<>();
			param.put("deptList", deptList);
			param.put("userList", userList);
			
			if (shareInfo == null) {
				resultBody = commonUtil.getJsonFromWebFolderRestApi("/rest/ezwebfolder/users/" + userInfo.getId() + "/sharing/" + folderFileId + "/" + folderFileType, param, request, "post", null);
			} else {
				resultBody = commonUtil.getJsonFromWebFolderRestApi("/rest/ezwebfolder/users/" + userInfo.getId() + "/sharing/" + folderFileId + "/" + folderFileType, param, request, "put", null);
			}
		}
		
		logger.debug("addShare ended.");
		return  resultBody;
	}
	
	@RequestMapping(value="/ezWebFolder/deleteShareConfirm.do", method = RequestMethod.GET)
	public String deleteShareConfirm(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception{
		logger.debug("deleteShareConfirm started.");
		
		String type = request.getParameter("type");
		String fileList = orElse(request.getParameter("fileList"), "");
		String folderList = orElse(request.getParameter("folderList"), "");
		logger.debug("type=" + type + ",fileList=" + fileList + ",folderList=" + folderList);
		
		model.addAttribute("type", type);
		model.addAttribute("fileList", fileList);
		model.addAttribute("folderList", folderList);
		
		logger.debug("deleteShareConfirm ended.");
		return "ezWebFolder/webfolderShareDelete";
	}
	
	@RequestMapping(value="/ezWebFolder/deleteShare.do", method=RequestMethod.POST)
	public @ResponseBody JSONObject deleteShare(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("deleteShare started.");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		String fileList = orElse(request.getParameter("fileList"), "");
		String folderList = orElse(request.getParameter("folderList"), "");
		
		Map<String, Object> param = new HashMap<>();
		param.put("fileList", fileList);
		param.put("folderList", folderList);
		
		JSONObject resultBody = commonUtil.getJsonFromWebFolderRestApi("/rest/ezwebfolder/users/" + userInfo.getId() + "/sharing", param, request, "delete", null);
		
		logger.debug("deleteShare ended.");
		return  resultBody;
	}
	
	@RequestMapping(value="/ezWebFolder/hideShare.do", method=RequestMethod.POST)
	public @ResponseBody JSONObject hideShare(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("hideShare started.");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		String fileList = orElse(request.getParameter("fileList"), "");
		String folderList = orElse(request.getParameter("folderList"), "");
		
		Map<String, Object> param = new HashMap<>();
		param.put("fileList", fileList);
		param.put("folderList", folderList);
		
		JSONObject resultBody = commonUtil.getJsonFromWebFolderRestApi("/rest/ezwebfolder/users/" + userInfo.getId() + "/shared-hide", param, request, "post", null);
		
		logger.debug("hideShare ended.");
		return  resultBody;
	}
	
	@RequestMapping(value="/ezWebFolder/showShare.do", method=RequestMethod.POST)
	public @ResponseBody JSONObject showShare(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("showShare started.");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		String fileList = orElse(request.getParameter("fileList"), "");
		String folderList = orElse(request.getParameter("folderList"), "");
		
		Map<String, Object> param = new HashMap<>();
		param.put("fileList", fileList);
		param.put("folderList", folderList);
		
		JSONObject resultBody = commonUtil.getJsonFromWebFolderRestApi("/rest/ezwebfolder/users/" + userInfo.getId() + "/shared-hide", param, request, "delete", null);
		
		logger.debug("showShare ended.");
		return  resultBody;
	}
	
	@RequestMapping(value="/ezWebFolder/webfolderHiddenSharedList.do", method = RequestMethod.GET)
	public String webfolderHiddenSharedList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception{
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		model.addAttribute("primary", userInfo.getLang());
		return "ezWebFolder/webfolderHiddenSharedList";
	}
	
	@RequestMapping(value="/ezWebFolder/getHiddenSharedList.do", method = RequestMethod.POST)
	public @ResponseBody JSONObject getHiddenSharedList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getHiddenSharedList started.");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("pageNum", orElse(request.getParameter("pageNum"), "1"));
		param.put("pageSize", orElse(request.getParameter("pageSize"), "0"));
		param.put("sortType", orElse(request.getParameter("sortType")			, ""));
		param.put("sortColumn", orElse(request.getParameter("sortColumn")			, ""));
		
		JSONObject resultBody = commonUtil.getJsonFromWebFolderRestApi("/rest/ezwebfolder/users/" + userInfo.getId() + "/shared-hide", param, request, "get", null);
		
		logger.debug("getHiddenSharedList ended.");
		return resultBody;
	}
	
	@RequestMapping(value="/ezWebFolder/trashCan.do", method = RequestMethod.GET)
	public String trashCan (@CookieValue("loginCookie") String loginCookie, HttpServletRequest request,
			HttpServletResponse response, Model model )throws Exception {
		logger.debug("trashCan started.");
		
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
		headers.set("x-user-host", requset.getServerName());
		
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
		logger.debug("getTrashCanList started.");
		
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("currPage", Integer.parseInt(orElse(request.getParameter("currPage"), "1")));
		param.put("listCount", Integer.parseInt(orElse(request.getParameter("listCount"), "0")));
		param.put("searchExt", orElse(request.getParameter("searchExt"), "" ));
		param.put("searchFileName", orElse(request.getParameter("searchFileName"), ""));
		param.put("searchCreateName", orElse(request.getParameter("searchCreateName"), ""));
		param.put("searchFileType", orElse(request.getParameter("searchFileType"), ""));
		param.put("enrollStartDate", orElse(request.getParameter("enrollStartDate"), ""));
		param.put("enrollEndDate", orElse(request.getParameter("enrollEndDate"), ""));
		param.put("delStartDate", orElse(request.getParameter("delStartDate"), ""));
		param.put("delEndDate", orElse(request.getParameter("delEndDate"), ""));
		param.put("column", orElse(request.getParameter("column"), ""));
		param.put("order", orElse(request.getParameter("order"), ""));
		param.put("mode", orElse(request.getParameter("mode"), "" ));
		param.put("sortType"		, orElse(request.getParameter("sortType")			, ""));
		param.put("sortColumn"		, orElse(request.getParameter("sortColumn")			, ""));
		
		JSONObject resultBody = commonUtil.getJsonFromWebFolderRestApi("/rest/ezwebfolder/" + user.getId() + "/getTrashCanList", param, request, "post", null);
		
		String status = resultBody.get("status").toString();
		String code = resultBody.get("code").toString();

		if (status.equals("ok")) {
			model.addAttribute("status","ok");
			model.addAttribute("code", code);
			model.addAttribute("data",resultBody.get("data"));
		}else {
			model.addAttribute("status","error");
			model.addAttribute("code", code);
			model.addAttribute("data","");
		}
		
		logger.debug("status=" + status);
		logger.debug("data=" + resultBody.get("data"));
		logger.debug("getTrashCanList ended");
		
		return "json";
	}
	
	@RequestMapping(value="/ezWebFolder/permanentDeleteConfirm.do", method = RequestMethod.GET)
	public String permanentDeleteConfirm(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request,
			HttpServletResponse response, Model model) throws Exception {
		logger.debug("permanentDeleteConfirm started.");

		String versionList = orElse(request.getParameter("versionList"), "");

		logger.debug("fileLise=" + orElse(request.getParameter("fileList"), ""));
		logger.debug("folderList=" + orElse(request.getParameter("folderList"), ""));
		logger.debug("versionList=" + versionList);
		
		model.addAttribute("fileList", orElse(request.getParameter("fileList"), ""));
		model.addAttribute("folderList", orElse(request.getParameter("folderList"), ""));
		model.addAttribute("versionList", versionList);
		
		logger.debug("permanentDeleteConfirm ended.");
		return "ezWebFolder/filePermanentDelete";
	}
	
	@RequestMapping(value="/ezWebFolder/pemanentDeleteFile.do", method = RequestMethod.POST)
	public String pemanentDeleteFile (@CookieValue("loginCookie") String loginCookie, Model model, 
			HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("pemanentDeleteFile started.");
		
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		
		String fileList = orElse(request.getParameter("fileList"), "");
		String folderList = orElse(request.getParameter("folderList"), "");
		String versionList = orElse(request.getParameter("versionList"), "");
		
		Map<String, Object> param = new HashMap<String, Object>();
		
		param.put("userId", user.getId());                 
		param.put("fileList", fileList);               
		param.put("folderList", folderList);     
		param.put("versionList", versionList);
		
		JSONObject resultBody = commonUtil.getJsonFromWebFolderRestApi("/rest/ezwebfolder/file-permanent-delete", param, request, "delete", null);
		
		String status = resultBody.get("status").toString();
		String code = resultBody.get("code").toString();
		
		if (status.equals("ok")) {
			model.addAttribute("status","ok");
			model.addAttribute("code", code);
		} else {
			model.addAttribute("reason", Optional.ofNullable(resultBody.get("reason")).map(Object::toString).orElse(""));
			model.addAttribute("status","error");
			model.addAttribute("code", code);
		}
		
		logger.debug("status=" + status);
		logger.debug("pemanentDeleteFile ended");
		return "json";
	}
	
	@RequestMapping(value="/ezWebFolder/restoreTrashCan.do", method= RequestMethod.POST)
	public String restoreTrashCan (@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("restoreFile started");

		String fileList = orElse(request.getParameter("fileList"), "");
		String folderList = orElse(request.getParameter("folderList"), "");
		String versionList = orElse(request.getParameter("versionList"), "");

		logger.debug("fileList=" + fileList);
		logger.debug("folderList=" + folderList);
		logger.debug("versionList=" + versionList);

		LoginVO user = commonUtil.userInfo(loginCookie);
		
		Map<String, Object> param = new HashMap<String, Object>();
		
		param.put("userId", user.getId());                 
		param.put("companyId", user.getCompanyID());
		param.put("fileList", fileList);               
		param.put("folderList", folderList);
		param.put("versionList", versionList);
		
		JSONObject resultBody = commonUtil.getJsonFromWebFolderRestApi("/rest/ezwebfolder/restore-trashCan", param, request, "post", null);

		String status = resultBody.get("status").toString();
		String code = resultBody.get("code").toString();
		
		if (status.equals("ok")) {
			model.addAttribute("status","ok");
			model.addAttribute("code",code);
			
			if (resultBody.containsKey("duplicateInfoArray")) {
				model.addAttribute("duplicateInfoArray", resultBody.get("duplicateInfoArray"));
			}
			
			if (resultBody.containsKey("hasExceededCapacities")) {
				model.addAttribute("hasExceededCapacities", resultBody.get("hasExceededCapacities"));
			}

			if (resultBody.containsKey("hasAllParentFile")) {
				model.addAttribute("hasAllParentFile", resultBody.get("hasAllParentFile"));
			}

			if (resultBody.containsKey("errorVersions")) {
				model.addAttribute("errorVersions", resultBody.get("errorVersions"));
			}
		}else {
			model.addAttribute("reason", Optional.ofNullable(resultBody.get("reason")).map(Object::toString).orElse(""));
			model.addAttribute("status","error");
			model.addAttribute("code",code);
		}
		
		logger.debug("status=" + status);
		logger.debug("restoreFile ended");
		return "json";
	}
	
	@RequestMapping(value = "/ezWebFolder/favorite.do", method = RequestMethod.GET)
	public String favor(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse resp, Model model) throws Exception {
		logger.debug("favorite started.");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		String userId = user.getId();

		model.addAttribute("userId", userId);

		JSONObject resultBody = commonUtil.getJsonFromWebFolderRestApi("/rest/ezwebfolder/" + userId + "/upload-limit", null, request, "get", null);

		if ("ok".equals(resultBody.get("status"))) {
			model.addAttribute("uploadLimit", (double) resultBody.get("uploadLimit"));
		} else {
			model.addAttribute("uploadLimit", -1);
		}

		boolean usePreview = "1".equalsIgnoreCase(commonUtil.getTenantConfigRest("useImageConvertServer", userId, request));
		boolean useVersionHistory = "YES".equalsIgnoreCase(commonUtil.getTenantConfigRest("useWebfolderVersionHistory", userId, request));

		model.addAttribute("usePreview", usePreview);
		model.addAttribute("useVersionHistory", useVersionHistory);

		logger.debug("favorite ended.");
		return "ezWebFolder/webfolderFavorite";
	}

	@RequestMapping(value = "/ezWebFolder/getFavorites.do", method = RequestMethod.POST)
	public @ResponseBody JSONObject getFavorites(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getFavorites started.");

		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);

		JSONObject result = rest.gateway(Module.WEBFOLDER, request)
				.url("/rest/ezwebfolder/users/{0}/favorites", user.getId())
				// search info
				.queryParam("searchExt", defaultString(request.getParameter("searchExt")))
				.queryParam("searchFileName", defaultString(request.getParameter("searchFileName")))
				.queryParam("searchCreatorName", defaultString(request.getParameter("searchCreatorName")))
				.queryParam("searchFileType", defaultString(request.getParameter("searchFileType")))
				.queryParam("searchStartDate", defaultString(request.getParameter("searchStartDate")))
				.queryParam("searchEndDate", defaultString(request.getParameter("searchEndDate")))
				// limit info
				.queryParam("startIndex", defaultString(request.getParameter("startIndex"), "0"))
				.queryParam("listCount", defaultString(request.getParameter("listCount"), "0"))
				.queryParam("sortType", defaultString(request.getParameter("sortType")))
				.queryParam("sortColumn", defaultString(request.getParameter("sortColumn")))
				.exchangeBody();

		logger.debug("getFavorites ended.");
		return result;
	}

	@RequestMapping(value = "/ezWebFolder/addFavorite.do", method = RequestMethod.POST)
	public @ResponseBody JSONObject addFavorite(@CookieValue("loginCookie") String loginCookie,
			@RequestParam(required = false) String fileList, @RequestParam(required = false) String folderList, HttpServletRequest request) throws Exception {
		logger.debug("addFavorite started.");

		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);

		JSONObject result = rest.gateway(Module.WEBFOLDER, request)
				.post().url("/rest/ezwebfolder/users/{0}/favorite", user.getId())
				.queryParam("fileList", fileList)
				.queryParam("folderList", folderList)
				.exchangeBody();

		logger.debug("addFavorite ended.");
		return result;
	}

	@RequestMapping(value = "/ezWebFolder/deleteFavorite.do", method = RequestMethod.POST)
	public @ResponseBody JSONObject deleteFavorite(@CookieValue("loginCookie") String loginCookie,
			@RequestParam(required = false) String fileList, @RequestParam(required = false) String folderList, HttpServletRequest request) throws Exception {
		logger.debug("deleteFavorite started.");

		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);

		JSONObject result = rest.gateway(Module.WEBFOLDER, request)
				.delete().url("/rest/ezwebfolder/users/{0}/favorite", user.getId())
				.queryParam("fileList", fileList)
				.queryParam("folderList", folderList)
				.exchangeBody();

		logger.debug("deleteFavorite ended.");
		return result;
	}
	
	@RequestMapping(value="/ezWebFolder/moveTrashCanManage.do", method = RequestMethod.GET)
	public String moveTrashCanManage (@CookieValue ("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
	logger.debug("moveTrashCanManage started.");
	
	 String folderType = request.getParameter("folderType");
	 String fileList = orElse(request.getParameter("fileList"), "");
	 String folderList = orElse(request.getParameter("folderList"), "");
	 String isAdmin = orElse(request.getParameter("isAdmin"), "false");
		
	 model.addAttribute("fileList", fileList);               
	 model.addAttribute("folderList", folderList);               
	 model.addAttribute("folderType", folderType);             
	 model.addAttribute("isAdmin", isAdmin);
	
	 logger.debug("fileList=" + fileList + "&folderList=" + folderList + "&folderType=" + folderType + "&isAdmin=" + isAdmin);
	 logger.debug("moveTrashCanManage ended.");
	 return "ezWebFolder/moveTrashCanManage";
	}
	
	@RequestMapping(value = "/ezWebFolder/moveTrashCanForDuplicate.do", method = RequestMethod.POST)
	public @ResponseBody JSONObject moveTrashCan(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request,
			@RequestParam String id, @RequestParam Type type, @RequestParam(required = false) String folderId) throws Exception {
		logger.debug("moveTrashCanForDuplicate started.");
		
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		Map<String, Object> param = new HashMap<String, Object>();
		
		String overwritable = request.getParameter("overwritable");
		String newName = request.getParameter("newName");
		
		boolean isFile = type == Type.FILE;
		
		if (overwritable != null) {
			param.put("overwritable", overwritable);
		}
		
		if (newName != null && isFile) {
			param.put("fileNameList", newName);
		}
		
		param.put(isFile ? "fileList" : "folderList", id);
		param.put("userId", user.getId());
		param.put("folderId", folderId);

		JSONObject resultJson = commonUtil.getJsonFromWebFolderRestApi("/rest/ezwebfolder/move-TrashCan", param, request, "post", null);

		logger.debug("result=" + resultJson);
		logger.debug("moveTrashCanForDuplicate ended");
		return resultJson;
	}
	
	@RequestMapping(value="/ezWebFolder/moveTrashCan.do", method=RequestMethod.POST)
	public @ResponseBody JSONObject moveTrashCan (@CookieValue ("loginCookie")String loginCookie, HttpServletRequest request,
			HttpServletResponse response, Model model) throws Exception {
		logger.debug("moveTrashCan started.");
		
		String fileList = orElse(request.getParameter("fileList"), "");
		String folderList = orElse(request.getParameter("folderList"), "");
		
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
	
		Map<String, Object> param = new HashMap<String, Object>();
		
		param.put("userId", user.getId());                 
		param.put("folderId", orElse(request.getParameter("folderId"), ""));               
		param.put("fileList", fileList);               
		param.put("folderList", folderList);               
		
		JSONObject resultJson = commonUtil.getJsonFromWebFolderRestApi("/rest/ezwebfolder/move-TrashCan", param, request, "post", null);
		
		logger.debug("result=" + resultJson);
		logger.debug("moveTrashCan ended");
		return resultJson;		
	}
	
	@RequestMapping(value = "/ezWebFolder/insertEncryptionFolder.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject insertEncryptionFolder(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request,
			@RequestParam String folderId) throws Exception {
		logger.debug("insertEncryptionFolder started.");

		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		Map<String, Object> param = new HashMap<String, Object>();

		param.put("tenantId", user.getTenantId());

		JSONObject resultJson = commonUtil.getJsonFromWebFolderRestApi("/rest/ezwebfolder/folder/" + folderId + "/encryption",
				param, request, "put", null);

		logger.debug("result={}", resultJson);
		logger.debug("insertEncryptionFolder ended");
		return resultJson;
	}

	@RequestMapping(value = "/ezWebFolder/deleteEncryptionFolder.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject deleteEncryptionFolder(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request,
			@RequestParam String folderId) throws Exception {
		logger.debug("deleteEncryptionFolder started.");

		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		Map<String, Object> param = new HashMap<String, Object>();

		param.put("tenantId", user.getTenantId());

		JSONObject resultJson = commonUtil.getJsonFromWebFolderRestApi("/rest/ezwebfolder/folder/" + folderId + "/encryption",
				param, request, "delete", null);

		logger.debug("result={}", resultJson);
		logger.debug("deleteEncryptionFolder ended");
		return resultJson;
	}

	@RequestMapping(value = "/ezWebFolder/personalPopUpUser.do", method = RequestMethod.GET)
	public String personalPopUpUser(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("w personalPopUpUser started.");

		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		String userID = user.getId();
		String deptID = user.getDeptID();
		String lang = user.getLang();
		String companyID = user.getCompanyID();
		
		String cn = request.getParameter("cn") == null ? "" : request.getParameter("cn");
		String textName = request.getParameter("name") == null ? "" : request.getParameter("name");
		String useOcs = config.getProperty("config.USE_OCS");
		// 2020-11-26 김은실 - (카이스트)회사 폴더별 관리자 지원 기능 
		
		String type = request.getParameter("type"); // 담당자:master, 구성원:member
		type = type.equals("") ? "member" : type;
		String folderManager = type.equals("master") ? "1" : "0";
		logger.debug("type=" + type);
		
		model.addAttribute("type", type);
		model.addAttribute("deptID", deptID);
		model.addAttribute("cn", cn);
		model.addAttribute("textName", textName);
		model.addAttribute("useOcs", useOcs);
		model.addAttribute("companyId", companyID);
		model.addAttribute("folderManager", folderManager);
		model.addAttribute("dept", deptID);
		model.addAttribute("lang", lang);

		logger.debug("w personalPopUpUser ended.");
		return "ezWebFolder/personalPopupUser";
	}
	
	@RequestMapping(value = "/ezWebFolder/applyForWebFolder.do", method = RequestMethod.POST)
	@SuppressWarnings("unchecked")
	@ResponseBody
	public String applyForWebFolder(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Locale locale) throws Exception {
		logger.debug("applyForWebFolder started.");
		
		String returnStr = "OK";

		LoginVO user = commonUtil.userInfo(loginCookie);
		String userId = user.getId();
		int tenantId = user.getTenantId();
		String companyId = user.getCompanyID();
		String userDeptName = user.getDeptName();
		String userName = user.getDisplayName();
		String applicantSUserName = userName + "(" + userDeptName + ")";
		String wfApplicantStr = "[{\"userType\":\"USER\",\"userId\":\""+userId+"\",\"sUserName\":\""+applicantSUserName+"\"}]";
		
		String domainName = ezCommonService.getTenantConfig("DomainName", tenantId);
		logger.debug("userId=" + userId + ", domainName=" + domainName);
		
		String folderName = orElse(request.getParameter("wfName"), "");
		String content = orElse(request.getParameter("wfContent"), "");
		String wfMasterList = orElse(request.getParameter("appMasterArr"), "");
		String wfMemberList = orElse(request.getParameter("appMemberArr"), "");
		logger.debug("folderName=" + folderName);
		
		if (folderName.equals("") || wfMasterList.equals("")) {
			returnStr = "ERROR";
		} else {
			JSONArray memberListArr = new JSONArray();
			convertApplyMemberListToJSONArray(wfMasterList, "master", memberListArr);
			convertApplyMemberListToJSONArray(wfMemberList, "member", memberListArr);
			convertApplyMemberListToJSONArray(wfApplicantStr, "applicant", memberListArr);
			
			JSONObject jsonObjParam = new JSONObject();
			jsonObjParam.put("folderName", folderName);
			jsonObjParam.put("content", content);
			jsonObjParam.put("memberList", memberListArr.toString());

			JSONObject resultJson = commonUtil.getJsonFromWebFolderRestApi("/rest/ezwebfolder/"+userId+"/setApplyHistory",
					null, request, "post", jsonObjParam);
			logger.debug("result={}", resultJson);
			
			if (resultJson != null) {
				returnStr = (String) resultJson.get("status");
				String applyId = (String) resultJson.get("applyId");
				
				if (returnStr.equals("OK")) {
					try {
						// 메일 발송
						InternetAddress from = new InternetAddress();
						from.setPersonal(userName, "UTF-8");
						from.setAddress(user.getEmail());

						List<OrganUserVO> webfolderAdminList = ezWebFolderService_m.getWebFolderAdminUserList(companyId);
						int webfolderAdminListCnt = webfolderAdminList.size();
						InternetAddress[] toArr = new InternetAddress[webfolderAdminListCnt];
						
						int nowi = 0;
						List<Map<String,Object>> notiRecipientList = new ArrayList<Map<String, Object>> ();
						for (OrganUserVO vo : webfolderAdminList) {
							String voMail = vo.getMail();
							String voCn = vo.getCn();
							voMail = voMail.trim().equals("") ? voCn + "@" + domainName : voMail;
							
							InternetAddress addrTemp = new InternetAddress();
							addrTemp.setPersonal(vo.getDisplayName(), "UTF-8");
							addrTemp.setAddress(voMail);
							
							toArr[nowi] = addrTemp;
							nowi++;

							Map<String, Object> recipientMap = new HashMap<String, Object>();
							recipientMap.put("userType", "PERSON");
							recipientMap.put("companyId", companyId);
							recipientMap.put("cn", voCn);
							notiRecipientList.add(recipientMap);
						}
						
						if (notiRecipientList != null && notiRecipientList.size() > 0) {
							String notiSubType = "OPEN_APPLY";
							String linkUrl = "/admin/ezWebFolder/applicationHistoryMain.do";
							String notiStatus = ezNotificationService.sendNoti(request, user.getId(), user.getDisplayName(), notiRecipientList, "WEBFOLDER", notiSubType, folderName, "popup", "1300", "1000", linkUrl, "", "notChkSetting");
							logger.debug("webfolder " +  notiSubType + " noti status : " + notiStatus);
						}
						
						String mailContent = "";
						String mailSubject = String.format(egovMessageSource.getMessage("ezWebFolder.ksa34", locale), folderName);
						String mailConentTemp = "<p><b>${tt}</b> : ${ttVal}</p>";

						mailContent += "<p>" + egovMessageSource.getMessage("ezWebFolder.ksa36", locale) + "</p>"
							+ "<br/>"
							+ mailConentTemp.replace("${tt}", egovMessageSource.getMessage("ezWebFolder.ksa06", locale)).replace("${ttVal}", userName)
							+ "<br/>"
							+ mailConentTemp.replace("${tt}", egovMessageSource.getMessage("ezWebFolder.ksa04", locale)).replace("${ttVal}", commonUtil.cleanValue(folderName))
							+ "<br/>"
							+ mailConentTemp.replace("${tt}", egovMessageSource.getMessage("ezWebFolder.ksa07", locale)).replace("${ttVal}", "")
							+ convertApplyMemberListToUserString(wfMasterList)
							+ "<br/>"
							+ mailConentTemp.replace("${tt}", egovMessageSource.getMessage("ezWebFolder.ksa08", locale)).replace("${ttVal}", "")
							+ convertApplyMemberListToUserString(wfMemberList)
							+ "<br/>"
							+ mailConentTemp.replace("${tt}", egovMessageSource.getMessage("ezWebFolder.ksa14", locale)).replace("${ttVal}", "")
							+ "<pre style=\"font-size: inherit; font-family: inherit;\">" + commonUtil.cleanValue(content) + "</pre><br/>";
						
						mailContent = commonUtil.createNotiMailContent(mailContent, tenantId, locale);
						ezEmailService.sendMail(loginCookie, from, toArr, null, null, mailSubject, mailContent, false);
						
					} catch (Exception e) {
						logger.error(e.getMessage(), e);
						returnStr = "EMAIL_ERROR";
						
						logger.debug("delete webfolderApplyHistory..");
						ezWebFolderService_m.deleteWebFolderApplyHistory(applyId);
					}
				} // ok end
			}
		}
		
		logger.debug("applyForWebFolder ended.");
		return returnStr;
	}
	

	@SuppressWarnings("unchecked")
	private String convertApplyMemberListToUserString(String memberList) throws Exception { // memberList = jsonArray Str
		if (memberList == null || memberList.trim().equals("")) {return ""; }
		
		String userListStr = "";
		String deptListStr = "";
		String jikwiListStr = "";
		String jikchekListStr = "";
		String groupListStr = "";
		
		JSONParser parser = new JSONParser();
		JSONArray jsonArrMaster = (JSONArray) parser.parse(memberList);
		
		for (Object obj : jsonArrMaster) {
			JSONObject jsonObj = (JSONObject) parser.parse(obj.toString());
			String userType = (String) jsonObj.get("userType");
			String userName = (String) jsonObj.get("sUserName");
			
			switch(userType.toLowerCase()){
				case "dept":
					deptListStr += userName + "<br/>";
					break;
				case "jikwi":
					jikwiListStr += userName + "<br/>";
					break;
				case "jikchek":
					jikchekListStr += userName + "<br/>";
					break;
				case "group":
					groupListStr += userName + "<br/>";
					break;
				default :
					userListStr += userName + "<br/>";
					break;
			}
		}
		
		String returnStr = "<p>" + userListStr + deptListStr + jikwiListStr + jikchekListStr + groupListStr + "</p>";
		return returnStr;
	}
	
	@SuppressWarnings("unchecked")
	private JSONArray convertApplyMemberListToJSONArray(String memberList, String memberListItem, JSONArray bJsonArr) throws Exception { // memberList = jsonArray Str
		logger.debug("memberList=" + memberList);
		if (memberList == null || memberList.trim().equals("")) {return bJsonArr; }
		
		String memItem = memberListItem.equals("master") ? "ms" : memberListItem.equals("member") ? "m" : "a";
		
		JSONParser parser = new JSONParser();
		JSONArray jsonArrMaster = (JSONArray) parser.parse(memberList);
		
		for (Object obj : jsonArrMaster) {
			JSONObject jsonObj = (JSONObject) parser.parse(obj.toString());
			
			JSONObject tempJSON = new JSONObject();
			tempJSON.put("memberId", jsonObj.get("userId"));
			tempJSON.put("memberType", jsonObj.get("userType"));
			tempJSON.put("memberItem", memItem);
			tempJSON.put("memberName", jsonObj.get("sUserName"));
			
			bJsonArr.add(tempJSON);
		}
		
		return bJsonArr;
	}
	
	private <T> T orElse(T value, T other) {
		if (other == null) {
			throw new IllegalArgumentException("other is null!");
		}
		
		return value != null ? value : other;
	}
}
