package egovframework.ezEKP.ezWebFolder.web;

import java.io.IOException;
import java.io.InputStream;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Properties;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.InputStreamResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.http.client.SimpleClientHttpRequestFactory;
import org.springframework.http.converter.HttpMessageConverter;
import org.springframework.http.converter.ResourceHttpMessageConverter;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.util.UriComponentsBuilder;

import com.google.gson.JsonArray;

import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezWebFolder.vo.DuplicateInfoVO.Type;
import egovframework.let.user.login.vo.LoginSimpleVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.rest.Rest;
import egovframework.let.utl.rest.Rest.Module;
import egovframework.let.utl.rest.Result;

@Controller
public class EzWebFolderController extends EgovFileMngUtil {

	private static final Logger logger = LoggerFactory.getLogger(EzWebFolderController.class);

	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;

	@Autowired
	private Rest rest;

	@RequestMapping(value = "/ezWebFolder/webfolderMain.do", method = RequestMethod.GET)
	public String webfolderMain(@CookieValue("loginCookie") String loginCookie, HttpServletRequest req, Model model) {
		logger.debug("webfolderMain start");

		String leftFrameWidth = "220";
		int width = 0;

		if (req.getParameter("__wwidth") != null) {
			String widthParam = req.getParameter("__wwidth");

			try {
				width = Integer.parseInt(widthParam);

				leftFrameWidth = width < 1180 ? "0" : "220";
			} catch (NumberFormatException e) {
				width = 0;
			}
		}

		model.addAttribute("leftFrameWidth", leftFrameWidth);
		
		try {
			LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
			Result result = rest.gateway(Module.WEBFOLDER, req)
					.url("/rest/ezwebfolder/users/{0}/checkRootFolder", userInfo.getId()).exchangeResult();
			String folderType = req.getParameter("folderType") != null ? commonUtil.stripTagSymbols(commonUtil.stripScriptTagsAndFunctions(req.getParameter("folderType"))) : "C";
			model.addAttribute("folderType", folderType);
			model.addAttribute("status", result.getStatus());
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}

		logger.debug("webfolderMain end");
		return "ezWebFolder/webfolderMain";
	}

	@RequestMapping(value="/ezWebFolder/webfolderLeft.do", method = RequestMethod.GET)
	public String webfolderLeft(@CookieValue("loginCookie") String loginCookie, ModelMap modelMap, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		logger.debug("webfolderLeft start");
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);

		String folderType = request.getParameter("folderType") != null ? request.getParameter("folderType") : "C";
		folderType = commonUtil.stripTagSymbols(commonUtil.stripScriptTagsAndFunctions(folderType));

		Result result = rest.gateway(Module.WEBFOLDER, request).url("/rest/ezwebfolder/check-wfadmin/" + userInfo.getId()).exchangeResult();

		if (result.succeeded()) {
			model.addAttribute("isWfAdmin", result.getData(String.class));
		}

		if (folderType.equals("C")) {
			Result result2 = rest.gateway(Module.WEBFOLDER, request).url("/rest/ezwebfolder/check-folderManager/" + userInfo.getId()).exchangeResult();

			if (result2.succeeded()) {
				JsonArray folderListMap = result2.getDataAsJsonObject().get("folderListMap").getAsJsonArray();
				model.addAttribute("folderListCount", folderListMap.size());
			}
		} else {
			model.addAttribute("folderListCount", 0);
		}

		model.addAttribute("folderType", folderType);

		logger.debug("webfolderLeft end");
		return "ezWebFolder/webfolderLeft";
	}

	@RequestMapping(value="/ezWebFolder/webfolderConfig.do", method = RequestMethod.GET)
	public String webfolderConfig(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		logger.debug("webfolderConfig start");

		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		Result result = rest.gateway(Module.WEBFOLDER, request).url("/rest/ezwebfolder/dept-chief/" + user.getId()).exchangeResult();

		if (result.succeeded()) {
			model.addAttribute("isChief", result.getData());
		}

		logger.debug("webfolderConfig end");
		return "ezWebFolder/webfolderConfig";
	}
	
	@RequestMapping(value="/ezWebFolder/deptChiefSetting.do", method = RequestMethod.GET)
	public String deptChiefConfig(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		logger.debug("deptChiefConfig start");
		logger.debug("deptChiefConfig end");
		return "ezWebFolder/deptChiefConfig";
	}
	
	@RequestMapping(value="/ezWebFolder/wefolderGeneral.do", method = RequestMethod.GET)
	public String webfolderGeneral(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("webfolderGeneral start");

		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		Result result = rest.gateway(Module.WEBFOLDER, request).url("/rest/ezwebfolder/users/{0}/env/list-count", user.getId()).exchangeResult();

		if (result.succeeded()) {
			model.addAttribute("wfListConfig", result.getData());
		}

		logger.debug("webfolderGeneral end");
		return "ezWebFolder/webfolderGeneral";
	}
	
	@RequestMapping(value = "/ezWebFolder/fileDuplicateConfirm.do", method = RequestMethod.GET)
	public String fileDuplicateConfirm(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("fileDuplicateConfirm start");
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);

		String fileName = request.getParameter("fileName");

		String newDate = request.getParameter("newDate");
		String newSize = request.getParameter("newSize");
		String oldDate = request.getParameter("oldDate");
		String oldSize = request.getParameter("oldSize");
		// String oldOwnerId = request.getParameter("oldOwnerId");
		String oldId = request.getParameter("oldId");
		boolean isOne = request.getParameter("isOne") != null;

		Type newType = Type.valueOf(request.getParameter("newType"));
		Type oldType = Type.valueOf(request.getParameter("oldType"));

		// newDate 같은 경우는 업로드일 때를 대비해서 long 형태를 시간으로 변경
		if (newDate == null || newDate.length() < 19) {
			SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

			try {
				newDate = formatter.format(new Date(Long.parseLong(newDate)));
			} catch (Exception e) {
				logger.debug("e.message=" + e.getMessage());
			}
		} else if (newDate.length() == 21) {
			newDate = newDate.substring(0, 19);
		}

		// mysql 끝자리 .0 지우기
		oldDate = Optional.ofNullable(oldDate)
				.filter(str -> str.length() == 21)
				.map(str -> str = str.substring(0, 19))
				.orElse("");

		try {
			newSize = humanReadableByteCount(Long.parseLong(newSize));
		} catch (Exception e) {logger.debug("e.message=" + e.getMessage());}

		try {
			oldSize = humanReadableByteCount(Long.parseLong(oldSize));
		} catch (Exception e) {logger.debug("e.message=" + e.getMessage());}

		model.addAttribute("fileName", fileName);
		model.addAttribute("newDate", newDate);
		model.addAttribute("newSize", newSize);
		model.addAttribute("oldDate", oldDate);
		model.addAttribute("oldSize", oldSize);
		model.addAttribute("isOne", isOne);
		model.addAttribute("isAllFiles", newType == Type.FILE && oldType == Type.FILE);
		model.addAttribute("isFolder", newType == Type.DIRECTORY);

		// 답글 파일이라면 덮어쓰기 버튼이 안나오도록 함
		model.addAttribute("isReply", request.getParameter("isReply") != null);

		// 덮어쓰려는 파일의 권한 체크
		Map<String, Object> checkPermission = new HashMap<>();
		List<Map<String, Object>> checkList = new ArrayList<>();
		Map<String, Object> map = new HashMap<>();
		map.put("checkId", oldId);
		map.put("checkType", "F");

		checkList.add(map);
		checkPermission.put("checkList", checkList);

		JSONObject permissionResult = commonUtil.getJsonFromWebFolderRestApi("/rest/ezwebfolder/users/" + userInfo.getId() + "/checkpermission",
				null, request, "post", new JSONObject(checkPermission));

		model.addAttribute("isAccessible", permissionResult.get("status").equals("ok"));

		logger.debug("fileDuplicateConfirm end");
		return "ezWebFolder/fileDuplicateConfirm";
	}
	
	private String humanReadableByteCount(long bytes) {
		int unit = 1024;

		if (bytes < unit) {
			return bytes + " B";
		}

		int exp = (int) (Math.log(bytes) / Math.log(unit));
		String pre = ("KMGTPE").charAt(exp - 1) + "";

		return String.format("%.1f %sB", bytes / Math.pow(unit, exp), pre);
	}
	
	
	@RequestMapping(value="/ezWebFolder/getDuplicateFiles.do", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	@ResponseBody
	public JSONObject duplicateFileCheck(@CookieValue("loginCookie") String loginCookie, @RequestBody Map<String, Object> parameter, HttpServletRequest request) throws Exception {
		logger.debug("getDuplicateFiles start");

		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);

		JSONObject resultBody = rest.gateway(Module.WEBFOLDER, request)
				.post().url("/rest/ezwebfolder/filemanage/duplicate-check")
				.body(parameter)
				// additional param
				.jsonParam("userId", userInfo.getId())
				.exchangeBody();

		logger.debug("getDuplicateFiles end");
		return resultBody;
	}
	
	@RequestMapping(value="/ezWebFolder/uploadFile.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject uploadFile(MultipartHttpServletRequest request, @CookieValue("loginCookie") String loginCookie, Model model, HttpServletResponse response) throws Exception {
		logger.debug("uploadFile start");
		LoginSimpleVO userInfo         = commonUtil.userInfoSimple(loginCookie);
		List<MultipartFile> multiFiles = request.getFiles("fileToUpload");
		String[] mailAttachArray = Optional.ofNullable(request.getParameterValues("fileToUploadMailAttach")).orElse(new String[0]);

		// nullable
		String nameArray               = request.getParameter("nameArray");
		String folderId                = request.getParameter("folderId");
		String encrypt                 = request.getParameter("encrypt");
		String parentId                = request.getParameter("parentId");
		String gwServerUrl             = config.getProperty("config.webFolderGwServerURL");
		String url                     = gwServerUrl + "/rest/ezwebfolder/filemanage/file-upload";
		
		logger.debug("Folder Id: {}, encrypt: {}, parentId: {}", folderId, encrypt, parentId);
		
		SimpleClientHttpRequestFactory requestFactory = new SimpleClientHttpRequestFactory();
		requestFactory.setBufferRequestBody(false);
		
		RestTemplate restTemplate                       = new RestTemplate(requestFactory);
		List<HttpMessageConverter<?>> messageConverters = restTemplate.getMessageConverters();
		
		for (int i = 0; i < messageConverters.size(); i++) {
			HttpMessageConverter<?> messageConverter = messageConverters.get(i);
			
			if (messageConverter.getClass().equals(ResourceHttpMessageConverter.class)) {
				messageConverters.set(i, new BnkResourceHttpMessageConverter());
			}
		}
		
		MultiValueMap<String, Object> map = new LinkedMultiValueMap<String, Object>();
		Map<String, Object> jsonObject = new HashMap<>();
		List<Object> jsonArray = new ArrayList<>();
		JSONParser jp         = new JSONParser();
		
		boolean useOriginalFileNames = true;
		
		// custom file names
		if (nameArray != null) {
			try {
				List<?> nameList = (List<?>) jp.parse(nameArray);
				
				for (Object fileName : nameList) {
					setNameToNameList(jsonArray, URLEncoder.encode((String) fileName,"UTF-8"));
				}
				
				useOriginalFileNames = false;
			} catch (Exception e) {
				logger.error("nameArray exception", e);
			}
		}
		
		// (1)웹폴더 > 파일업로드 : MultipartFile
		for (MultipartFile file: multiFiles) {
			if (useOriginalFileNames) {
				String fileName = file.getOriginalFilename();
				setNameToNameList(jsonArray, URLEncoder.encode(fileName,"UTF-8"));
			}

			map.add("files", new MultipartFileResource(file.getInputStream(), file.getOriginalFilename()));
		}
		
		// (2)메일 > 첨부파일 > 웹폴더에 업로드 : MimeBodyPart
		for (String fileInfoStr : mailAttachArray) {
			JSONObject fileInfo = (JSONObject) jp.parse(fileInfoStr);
			if (useOriginalFileNames) {
				String fileName = (String) fileInfo.get("originalFilename");
				setNameToNameList(jsonArray, URLEncoder.encode(fileName,"UTF-8"));
			}

			map.add("filesMailAttach", fileInfo);
		}

		// (3)메일 > (이미 저장이 되어 있는)대용량첨부 > 웹폴더에 업로드 : File
		/*for (  : MailAttachLargeArray) {*/

		jsonObject.put("nameArray", jsonArray);
		jsonObject.put("userId", userInfo.getId());
		jsonObject.put("folderId", folderId);
		jsonObject.put("encrypt", encrypt);
		jsonObject.put("parentId", parentId);
		
		map.add("data", new JSONObject(jsonObject));
		
		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.MULTIPART_FORM_DATA);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<MultiValueMap<String, Object>> entity = new HttpEntity<MultiValueMap<String, Object>>(map, headers);
		UriComponentsBuilder builder                     = UriComponentsBuilder.fromHttpUrl(url);
		ResponseEntity<String> result                    = restTemplate.exchange(builder.build().encode().toUri(), HttpMethod.POST, entity, String.class);
		
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		
		logger.debug("uploadFile end");
		return resultBody;
	}
	
	private void setNameToNameList(List<Object> nameList, String originalFilename) {
		Map<String, Object> fileJson = new HashMap<>();

		fileJson.put("originalFilename", originalFilename);
		nameList.add(fileJson);
	}

	@RequestMapping(value="/ezWebFolder/uploadFileOverwrite.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject uploadFileOverwrite(MultipartHttpServletRequest request, @CookieValue("loginCookie") String loginCookie, Model model, HttpServletResponse response) throws Exception {
		logger.debug("uploadFileWrite start");
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		List<MultipartFile> multiFiles = request.getFiles("fileToUpload");
		String[] mailAttachArray = Optional.ofNullable(request.getParameterValues("fileToUploadMailAttach")).orElse(new String[0]);

		String folderId = request.getParameter("folderId");
		String fileIdListStr = request.getParameter("fileIdArray");
		String gwServerUrl = config.getProperty("config.webFolderGwServerURL");
		String url = gwServerUrl + "/rest/ezwebfolder/filemanage/file-upload-overwrite";
		
		logger.debug("Folder Id: " + folderId);
		
		SimpleClientHttpRequestFactory requestFactory = new SimpleClientHttpRequestFactory();
		requestFactory.setBufferRequestBody(false);
		
		RestTemplate restTemplate = new RestTemplate(requestFactory);
		List<HttpMessageConverter<?>> messageConverters = restTemplate.getMessageConverters();
		
		for (int i = 0; i < messageConverters.size(); i++) {
			HttpMessageConverter<?> messageConverter = messageConverters.get(i);
			
			if (messageConverter.getClass().equals(ResourceHttpMessageConverter.class)) {
				messageConverters.set(i, new BnkResourceHttpMessageConverter());
			}
		}
		
		MultiValueMap<String, Object> map = new LinkedMultiValueMap<String, Object>();
		Map<String, Object> jsonObject = new HashMap<>();
		List<Object> nameList = new ArrayList<>();
		JSONParser jp = new JSONParser();
		List<?> fileIdList = (List<?>) jp.parse(fileIdListStr);
		
		// (1)웹폴더 > 파일업로드 : MultipartFile
		for (MultipartFile file: multiFiles) {
			setNameToNameList(nameList, file.getOriginalFilename());

			map.add("files", new MultipartFileResource(file.getInputStream(), file.getOriginalFilename()));
		}
		
		// (2)메일 > 첨부파일 > 웹폴더에 업로드 : MimeBodyPart
		for (String fileInfoStr : mailAttachArray) {
			JSONObject fileInfo = (JSONObject) jp.parse(fileInfoStr);
			setNameToNameList(nameList, (String) fileInfo.get("originalFilename"));

			map.add("filesMailAttach", fileInfo);
		}

		// (3)메일 > (이미 저장이 되어 있는)대용량첨부 > 웹폴더에 업로드 : File
		/*for (  : MailAttachLargeArray) {*/

		jsonObject.put("nameArray", nameList);
		jsonObject.put("userId", userInfo.getId());
		jsonObject.put("folderId", folderId);
		jsonObject.put("fileIdArray", fileIdList);
		
		map.add("data", new JSONObject(jsonObject));
		
		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.MULTIPART_FORM_DATA);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<MultiValueMap<String, Object>> entity = new HttpEntity<MultiValueMap<String, Object>>(map, headers);
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url);
		ResponseEntity<String> result = restTemplate.exchange(builder.build().encode().toUri(), HttpMethod.POST, entity, String.class);
		
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		
		logger.debug("uploadFileWrite end");
		return resultBody;
	}

	@RequestMapping(value="/ezWebFolder/downloadAttach.do", method = RequestMethod.GET, produces="application/zip")
	@ResponseBody
	public void downloadAttach(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("downloadAttach start");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		String fileList = request.getParameter("fileList");
		String folderList = request.getParameter("folderList");

		logger.debug("FileId list: {} || FolderId list: {}", fileList, folderList);

		rest.gateway(Module.WEBFOLDER, request)
				.url("/rest/ezwebfolder/filemanage/file-download")
				.queryParam("userAgent", request.getHeader("User-Agent"))
				.queryParam("userId", user.getId())
				.queryParam("folderList", folderList)
				.queryParam("fileList", fileList)
				.download(response);

		logger.debug("downloadAttach end");
	}

	@RequestMapping(value="/ezWebFolder/deleteConfirm.do", method = RequestMethod.GET)
	public String deleteFileConfirm(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		logger.debug("deleteFileConfirm start");
		String listFileId = request.getParameter("fileList") != null ? request.getParameter("fileList") : "";
		String listFolderId = request.getParameter("folderList") != null ? request.getParameter("folderList") : "";
		
		logger.debug("FileId list: " + listFileId);
		logger.debug("listFolderId list: " + listFolderId);
		
		if ((listFileId.equals("") && listFolderId.equals(""))) {
			logger.debug("Delete File Confirm illegal arguments!");
			return "cmm/error/egovError";
		}
		
		model.addAttribute("folderList", listFolderId);
		model.addAttribute("fileList", listFileId);
		logger.debug("deleteFileConfirm end");
		
		return "/ezWebFolder/fileDelete";
	}

	@RequestMapping(value = "/ezWebFolder/deleteFile.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject deleteFile(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("deleteFile start");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		String listFileId = request.getParameter("fileList");
		String listFolderId = request.getParameter("folderList");

		logger.debug("FileId list: {}", listFileId);

		JSONObject resultBody = rest.gateway(Module.WEBFOLDER, request)
				.delete().url("/rest/ezwebfolder/filefolder-delete")
				.queryParam("userId", user.getId())
				.queryParam("fileList", listFileId)
				.queryParam("folderList", listFolderId)
				.exchangeBody();

		logger.debug("deleteFile end");
		return resultBody;
	}

	@RequestMapping(value="/ezWebFolder/fileRenameConfirm.do", method = RequestMethod.GET)
	public String fileRenameConfirm(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		logger.debug("fileRenameConfirm start");
		String fileId = request.getParameter("fileId") != null ? request.getParameter("fileId") : "";
		String uploadFlag = request.getParameter("isUploading");
		
		if (uploadFlag == null) {
			logger.debug("File Id:  " + fileId);
			
			if (fileId.equals("")) {
				logger.debug("File Rename Confirm illegal arguments!");
				return "cmm/error/egovError";
			}
			
			model.addAttribute("fileId", fileId);
			model.addAttribute("isUploading", false);
		} else {
			logger.debug("Uploading");
			
			model.addAttribute("isUploading", true);
		}

		logger.debug("fileRenameConfirm start");
		return "/ezWebFolder/fileRename";
	}

	@RequestMapping(value="/ezWebFolder/renameFile.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject renameFile(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) {
		logger.debug("renameFile start");
		
		LoginSimpleVO user  = commonUtil.userInfoSimple(loginCookie);
		String fileId       = request.getParameter("fileId");
		String newName      = request.getParameter("newName");
		
		logger.debug("File Id: " + fileId + " || New name: " + newName);
		
		String gwServerUrl  = config.getProperty("config.webFolderGwServerURL");
		String url          = gwServerUrl + "/rest/ezwebfolder/file-rename/fileid/" + fileId;
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
										.queryParam("userId", user.getId())
										.queryParam("newName", newName)
										.queryParam("webFlag","web");
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		RestTemplate rest    = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.PUT, entity, String.class);
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody = new JSONObject();
		try {
			resultBody = (JSONObject) jp.parse(result.getBody());
		} catch (ParseException e) {
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("renameFile end");
		return resultBody;
	}

	@RequestMapping(value="/ezWebFolder/fileMoveConfirm.do", method = RequestMethod.GET)
	public String fileMoveConfirm(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		logger.debug("fileMoveConfirm start");
		LoginSimpleVO user  	= commonUtil.userInfoSimple(loginCookie);
		String fileIdList   	= request.getParameter("fileList")   		!= null ? request.getParameter("fileList")   : "";
		String folderIdList 	= request.getParameter("folderList") 		!= null ? request.getParameter("folderList") : "";
		String mode         	= request.getParameter("mode")       		!= null ? request.getParameter("mode")       : "normal";
		String type         	= request.getParameter("type")       		!= null ? request.getParameter("type")       : "";
		String folderTypeCheck  = request.getParameter("folderTypeCheck") 	!= null ? request.getParameter("folderTypeCheck") : "";
		String folderType  		= request.getParameter("folderType") 		!= null ? request.getParameter("folderType") : "";
		
		logger.debug("FileId list: " + fileIdList + " || FolderId List: " + folderIdList + " || mode: " + mode + " || type: " + type + 
				"|| folderTypeCheck : " + folderTypeCheck);
		
		if (fileIdList.isEmpty() && folderIdList.isEmpty()) {
			logger.debug("File Move Confirm illegal arguments!");
			return "cmm/error/egovError";
		}
		
		Map<String, Object> permissionParams = new HashMap<>();
		permissionParams.put("fileList", fileIdList);
		permissionParams.put("folderList", folderIdList);
		permissionParams.put("adminCheck", mode.equalsIgnoreCase("admin")? true : false);
		
		// 이동 가능한지 (관리자, 담당자, 만든이)
		boolean isPermittedMove = Optional.of(
				commonUtil.getJsonFromWebFolderRestApi("/rest/ezwebfolder/permission-check/" + user.getId(),
						permissionParams, request, "get", null))
				.map(result -> result.get("status").toString())
				.map("ok"::equalsIgnoreCase)
				.orElse(false);
		
		// 복사 가능한지 (관리자, 담당자, 구성원)
		boolean isPermittedCopy = Optional.of(
				commonUtil.getJsonFromWebFolderRestApi("/rest/ezwebfolder/users/" + user.getId() + "/checkpermissions",
						null, request, "post", new JSONObject(permissionParams)))
				.map(result -> result.get("status").toString())
				.map("ok"::equalsIgnoreCase)
				.orElse(false);
		
		// 폴더 없고 파일 하나 일 때 암호화되어있을 때 본인이 생성자라면 true, 아니라면 false
		if (fileIdList != null && !fileIdList.contains(",") && (folderIdList == null || folderIdList.isEmpty())) {
			isPermittedCopy &= Optional.of(
					commonUtil.getJsonFromWebFolderRestApi("/rest/ezwebfolder/users/" + user.getId() + "/checkencryptcreator",
							null, request, "post", new JSONObject(permissionParams)))
					.map(result -> result.get("status").toString())
					.map("ok"::equalsIgnoreCase)
					.orElse(false);
		}

		if (mode.equalsIgnoreCase("admin")){
			String gwServerUrl   = config.getProperty("config.webFolderGwServerURL");
			String url           = gwServerUrl + "/rest/ezwebfolderadmin/company-list/" + user.getId();
			
			HttpHeaders headers  = new HttpHeaders();
			headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
			headers.set("x-user-host", request.getServerName());
			HttpEntity<?> entity = new HttpEntity<>(headers);
			
			UriComponentsBuilder builder  = UriComponentsBuilder.fromHttpUrl(url).queryParam("mode", mode);
			RestTemplate rest             = new RestTemplate();
			ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
			
			JSONParser jp                 = new JSONParser();
			JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
			String status                 = resultBody.get("status").toString();
			
			if (status.equals("ok")) {
				String companyId      = (String) resultBody.get("userCompany");
				JSONArray companyList = (JSONArray) resultBody.get("data");
				model.addAttribute("userCompany", companyId);
				model.addAttribute("list", companyList);
			}
		}
		
		model.addAttribute("fileIdList", fileIdList);
		model.addAttribute("folderIdList", folderIdList);
		model.addAttribute("primary", user.getLang());
		model.addAttribute("mode", mode);
		model.addAttribute("type", type);
		model.addAttribute("folderTypeCheck", folderTypeCheck);
		model.addAttribute("isPermittedMove", isPermittedMove);
		model.addAttribute("isPermittedCopy", isPermittedCopy);
		model.addAttribute("folderType", folderType);
		logger.debug("fileMoveConfirm end");
		
		return "/ezWebFolder/fileMove";
	}

	@RequestMapping(value = "/ezWebFolder/moveFile.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject moveFile(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("moveFile start");
		LoginSimpleVO user  = commonUtil.userInfoSimple(loginCookie);
		String fileList     = request.getParameter("fileList");
		String folderList   = request.getParameter("folderList");
		String nameList     = request.getParameter("nameList");
		String folderId     = request.getParameter("folderId");
		String mode         = request.getParameter("mode");
		String privileges   = request.getParameter("privileges");
		String overwritable = request.getParameter("overwritable");

		logger.debug("FileId list: {} || Folder Id: {} || mode: {} || privileges: {} || nameList: {}", fileList, folderId, mode, privileges, nameList);

		Rest.RestBuilder restBuilder = rest.gateway(Module.WEBFOLDER, request)
				.put().url("/rest/ezwebfolder/filemove/modes/{0}", mode)
				.queryParam("fileList", fileList)
				.queryParam("folderList", folderList)
				.queryParam("userId", user.getId())
				.queryParam("privileges", privileges)
				.queryParam("folderId", folderId);

		if (overwritable != null) {
			restBuilder.queryParam("overwritable", overwritable);
		}

		if (nameList != null) {
			restBuilder.queryParam("nameList", nameList);
		}

		JSONObject resultBody = restBuilder.exchangeBody();

		logger.debug("moveFile end");
		return resultBody;
	}

	@RequestMapping(value = "/ezWebFolder/getFolderTree.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject getFolderTree(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getFolderTree start");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		String companyId   = request.getParameter("companyId");
		String folderId    = request.getParameter("folderId");
		String type        = request.getParameter("type");

		logger.debug("Company Id: {} || Folder Id: {} || Type: {}" + companyId, folderId, type);

		JSONObject resultBody = rest.gateway(Module.WEBFOLDER, request)
				.url("/rest/ezwebfolder/foldersTree")
				.queryParam("userId", user.getId())
				.queryParam("companyId", companyId)
				.queryParam("folderId", folderId)
				.queryParam("type", type)
				.exchangeBody();

		logger.debug("getFolderTree end");
		return resultBody;
	}
	
	@RequestMapping(value = "/ezWebFolder/getDeptTree.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject getDepartTree(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getDepartTree start");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		String companyId = request.getParameter("companyId");
		String deptId = StringUtils.defaultString(request.getParameter("deptId"));

		logger.debug("Company Id: {} || Department Id: {}", companyId, deptId);

		JSONObject resultBody = rest.gateway(Module.WEBFOLDER, request)
				.url("/rest/ezwebfolder/depart-tree")
				.queryParam("userId", user.getId())
				.queryParam("deptId", deptId)
				.queryParam("companyId", companyId)
				.exchangeBody();

		logger.debug("getDepartTree end");
		return resultBody;
	}
	
	@RequestMapping(value = "/ezWebFolder/getSubTree.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject getSubDepartTree(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getSubDepartTree start");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		String deptId = request.getParameter("deptId");
		String level = request.getParameter("level");

		logger.debug("Department Id: {} || Level: {}", deptId, level);

		JSONObject resultBody = rest.gateway(Module.WEBFOLDER, request)
				.url("/rest/ezwebfolder/sub-tree/{0}", deptId)
				.queryParam("userId", user.getId())
				.queryParam("level", level)
				.exchangeBody();

		logger.debug("getSubDepartTree end");
		return resultBody;
	}

	@RequestMapping(value = "/ezWebFolder/getDeptMembers.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject getDeptMembers(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getDeptMembers start");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		String deptId = request.getParameter("deptId");

		logger.debug("Department Id: " + deptId);

		JSONObject resultBody = rest.gateway(Module.WEBFOLDER, request)
				.url("/rest/ezwebfolder/dept-member/{0}", deptId)
				.queryParam("userId", user.getId())
				.exchangeBody();

		logger.debug("getDeptMembers end");
		return resultBody;
	}

	@RequestMapping(value = "/ezWebFolder/getFileFolderTree.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject getFileFolderTree(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getFileFolderTree start");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		String fileList    = request.getParameter("fileList");
		String mode        = request.getParameter("mode");
		String companyId   = request.getParameter("companyId");
		String type        = request.getParameter("type");

		logger.debug("FileId list: {} || mode: {} || CompanyId: {} || type: {}", fileList, mode, companyId, type);

		JSONObject resultBody = rest.gateway(Module.WEBFOLDER, request)
				.url("/rest/ezwebfolder/foldersTree/file")
				.queryParam("userId", user.getId())
				.queryParam("companyId", companyId)
				.queryParam("fileList", fileList)
				.queryParam("type", type)
				.queryParam("mode", mode)
				.exchangeBody();

		logger.debug("getFileFolderTree end");
		return resultBody;
	}
	
	@RequestMapping(value = "/ezWebFolder/saveGeneralList.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject saveListSize(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("saveListSize start");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		String listCount = request.getParameter("listCount");

		logger.debug("List count: {}", listCount);

		JSONObject resultBody = rest.gateway(Module.WEBFOLDER, request)
				.put().url("/rest/ezwebfolder/env/{0}/update", listCount)
				.queryParam("userId", user.getId())
				.exchangeBody();

		logger.debug("saveListSize end");
		return resultBody;
	}

	@RequestMapping(value="/ezWebFolder/savePortletConfig.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject savePortletConfig(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		logger.debug("savePortletConfig start");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		String selectFolderId = request.getParameter("selectFolderId");
		String targetFolderId = request.getParameter("targetFolderId");

		logger.debug("selectFolderId: {}, targetFolderId: {}", selectFolderId, targetFolderId);

		if (targetFolderId.equals(selectFolderId)) {
			Map<String, Object> result = new HashMap<>();
			result.put("status", "ok");
			result.put("code", 0);
			return new JSONObject(result);
		}

		JSONObject resultBody = rest.gateway(Module.WEBFOLDER, request)
				.put().url("/rest/ezwebfolder/env/{0}/{1}PortletFolderId", targetFolderId, selectFolderId.isEmpty() ? "insert" : "update")
				.queryParam("userId", user.getId()).exchangeBody();

		logger.debug("savePortletConfig end");
		return resultBody;
	}
	
	@RequestMapping(value = "/ezWebFolder/getDeptTreeForChief.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject getDepartTreeForChief(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getDepartTreeForChief start");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);

		JSONObject resultBody = rest.gateway(Module.WEBFOLDER, request)
				.url("/rest/ezwebfolder/depart-tree/chief/{0}", user.getId())
				.exchangeBody();

		logger.debug("getDepartTreeForChief end");
		return resultBody;
	}

	@RequestMapping(value = "/ezWebFolder/getSelectedDeptForChief.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject getSelectedDepartsForChief(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getSelectedDepartsForChief start");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);

		JSONObject resultBody = rest.gateway(Module.WEBFOLDER, request)
				.url("/rest/ezwebfolder/selected-dept/chief/{0}", user.getId())
				.exchangeBody();

		logger.debug("getSelectedDepartsForChief end");
		return resultBody;
	}

	@RequestMapping(value = "/ezWebFolder/saveSelectedDeptsForChief.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject updateEnvDeptList(@CookieValue("loginCookie") String loginCookie, @RequestParam("deptList") List<String> deptsList, HttpServletRequest request) throws Exception {
		logger.debug("updateEnvDeptList start");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);

		JSONObject resultBody = rest.gateway(Module.WEBFOLDER, request)
				.put().url("/rest/ezwebfolder/env/dept-list")
				.queryParam("deptList", String.join(",", deptsList))
				.queryParam("userId", user.getId())
				.exchangeBody();

		logger.debug("updateEnvDeptList end");
		return resultBody;
	}

	@RequestMapping(value="/ezWebFolder/checkPermission.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject checkPermission(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		logger.debug("checkPermission start");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		String fileId = request.getParameter("fileId");
		String fileList = request.getParameter("fileList");
		String folderList = StringUtils.defaultString(request.getParameter("folderList"));
		String isRecursive = StringUtils.defaultString(request.getParameter("isRecursive"), "false");

		logger.debug("File Id: {} || FileId list: {},folderList={}", fileId, fileList, folderList);

		JSONObject resultBody = rest.gateway(Module.WEBFOLDER, request)
				.url("/rest/ezwebfolder/permission-check/{0}", user.getId())
				.queryParam("fileList", fileList)
				.queryParam("fileId", fileId)
				.queryParam("folderList", folderList)
				.queryParam("isRecursive", isRecursive)
				.exchangeBody();

		logger.debug("checkPermission end");
		return resultBody;
	}

	@RequestMapping(value="/ezWebFolder/checkPermission_y.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject checkPermission_y(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("checkPermission_y start");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		String fileList = request.getParameter("fileList");
		String folderList = request.getParameter("folderList");

		logger.debug("fileList: {}, folderList: {}", fileList, folderList);

		JSONObject resultBody = rest.gateway(Module.WEBFOLDER, request)
				.post().url("/rest/ezwebfolder/users/{0}/checkpermissions", user.getId())
				.jsonParam("fileList", fileList)
				.jsonParam("folderList", folderList)
				.exchangeBody();

		logger.debug("checkPermission_y end");
		return resultBody;
	}

	@RequestMapping(value="/ezWebFolder/getCapacity.do", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	@ResponseBody
	public JSONObject getFolderCapacity(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getFolderCapacity start");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		String folderId = request.getParameter("folderId");

		JSONObject resultBody = rest.gateway(Module.WEBFOLDER, request)
				.url("/rest/ezwebfolderadmin/capacity/folder/{0}", folderId)
				.queryParam("primary", user.getLang())
				.exchangeBody();

		logger.debug("getFolderCapacity end");
		return resultBody;
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ezWebFolder/fileVersionManage.do", method = RequestMethod.GET)
	public String fileVersionManage(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		logger.debug("fileVersionManage start");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		String userId = user.getId();
		String fileId = request.getParameter("fileId");

		logger.debug("fileId: {}", fileId);

		if (fileId == null) {
			logger.debug("File version manage illegal arguments!");
			return "cmm/error/egovError";
		}

		JSONObject resultBody = rest.gateway(Module.WEBFOLDER, request)
				.url("/rest/ezwebfolder/file/{0}/histories", fileId)
				.queryParam("userId", userId)
				.exchangeBody();

		if ("ok".equals(resultBody.get("status"))) {
			JSONArray histories = (JSONArray) resultBody.get("data");
			boolean isEncrypted = (boolean) resultBody.get("isEncrypted");
			boolean isPermitted = (boolean) resultBody.get("isPermitted");
			boolean isCreator = (boolean) resultBody.get("isCreator");

			histories.forEach(jsonObj -> {
				JSONObject json = (JSONObject) jsonObj;
				json.put("fileSize", humanReadableByteCount((long) json.get("fileSize")));
			});

			model.addAttribute("histories", histories);
			model.addAttribute("isEncrypted", isEncrypted);
			model.addAttribute("isPermitted", isPermitted);
			model.addAttribute("isCreator", isCreator);
			model.addAttribute("usePreview", "1".equalsIgnoreCase(commonUtil.getTenantConfigRest("useImageConvertServer", userId, request)));
		}

		model.addAttribute("primary", user.getLang());
		model.addAttribute("fileId", fileId);

		logger.debug("fileVersionManage end");

		return "/ezWebFolder/fileVersionManage";
	}

	@RequestMapping(value = "/ezWebFolder/restoreVersion.do", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	@ResponseBody
	public JSONObject restoreVersion(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("restoreVersion start");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		String fileId = request.getParameter("fileId");
		String version = request.getParameter("version");

		JSONObject resultBody = rest.gateway(Module.WEBFOLDER, request)
				.put().url("/rest/ezwebfolder/file/{0}/histories/{1}", fileId, version)
				.queryParam("userId", user.getId())
				.exchangeBody();

		logger.debug("restoreVersion end");
		return resultBody;
	}

	@RequestMapping(value = "/ezWebFolder/deleteVersions.do", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	@ResponseBody
	public JSONObject deleteVersion(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("deleteVersion start");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		String fileId = request.getParameter("fileId");
		String versions = request.getParameter("versions");
		boolean isMultiple = versions.contains(",");

		Rest.RestBuilder restBuilder = rest.gateway(Module.WEBFOLDER, request).delete().queryParam("userId", user.getId());

		if (isMultiple) {
			restBuilder.url("/rest/ezwebfolder/file/{0}/histories", fileId).queryParam("versions", versions);
		} else {
			restBuilder.url("/rest/ezwebfolder/file/{0}/histories/{1}", fileId, versions);
		}

		JSONObject resultBody = restBuilder.exchangeBody();

		logger.debug("deleteVersion end");
		return resultBody;
	}

	@RequestMapping(value="/ezWebFolder/downloadVersion.do", method = RequestMethod.GET)
	@ResponseBody
	public void downloadVersion(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("downloadAttach start");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		String userId = user.getId();
		String fileId = request.getParameter("fileId");
		String versions = request.getParameter("versions");

		logger.debug("userId: {}, fildId: {}, versions: {}", userId, fileId, versions);

		rest.gateway(Module.WEBFOLDER, request)
				.url("/rest/ezwebfolder/filemanage/version-download")
				.queryParam("userAgent", request.getHeader("User-Agent"))
				.queryParam("userId", userId)
				.queryParam("fileId", fileId)
				.queryParam("versions", versions)
				.download(response);

		logger.debug("downloadAttach end");
	}

	@RequestMapping(value = "/ezWebFolder/webfolderReply.do", method = RequestMethod.GET)
	public String replyFile(HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		logger.debug("webfolderReply start");
		String fileId = request.getParameter("fileId");

		logger.debug("fileId: {}", fileId);

		if (fileId == null) {
			logger.debug("File version manage illegal arguments!");
			return "cmm/error/egovError";
		}

		model.addAttribute("fileId", fileId);
		logger.debug("webfolderReply end");

		return "/ezWebFolder/webfolderReply";
	}

	@RequestMapping(value="/ezWebFolder/checkNotInherit.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject checkNotInherit(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("checkNotInherit start");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		String fileList = request.getParameter("fileList");
		String folderList = request.getParameter("folderList");

		logger.debug("fileList: {}, folderList: {}", fileList, folderList);

		String url = "/rest/ezwebfolder/users/" + user.getId() + "/checknotinherit";

		Map<String, Object> jsonParams = new HashMap<>();
		jsonParams.put("fileList", fileList);
		jsonParams.put("folderList", folderList);

		JSONObject resultBody = commonUtil.getJsonFromWebFolderRestApi(url, null, request, "post", new JSONObject(jsonParams));

		logger.debug("checkNotInherit end");
		return resultBody;
	}

	@RequestMapping(value = "/ezWebFolder/filePreview.do", method = RequestMethod.GET)
	@ResponseBody
	public Result filePreview(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, @RequestParam(value = "version") Optional<Integer> versionOptional) throws Exception {
		logger.debug("filePreview started.");

		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		String userId = user.getId();
		String fileId = request.getParameter("fileId");

		logger.debug("fileId: {}, userId: {}, version: {}", fileId, userId, versionOptional);

		Result result = rest.gateway(Module.WEBFOLDER, request)
				.url("/rest/ezwebfolder/file/{0}/viewer/{1}", fileId, userId)
				.queryParam("version", versionOptional.orElse(null)).exchangeResult();

		logger.debug("filePreview end");

		return result;
	}

	private class MultipartFileResource extends InputStreamResource {
		private String filename;
		
		public MultipartFileResource(InputStream inputStream, String filename) {
			super(inputStream);
			this.filename = filename;
		}
		
		@Override
		public String getFilename() {
			return this.filename;
		}
		
		@Override
		public long contentLength() throws IOException {
			return -1; // Prevent read the whole stream into memory
		}
	}
	
	private class BnkResourceHttpMessageConverter extends ResourceHttpMessageConverter {
		@Override
		protected Long getContentLength(Resource resource, MediaType contentType) throws IOException {
			Long contentLength = super.getContentLength(resource, contentType);
			
			return contentLength == null || contentLength < 0 ? null : contentLength;
		}
	}
}
