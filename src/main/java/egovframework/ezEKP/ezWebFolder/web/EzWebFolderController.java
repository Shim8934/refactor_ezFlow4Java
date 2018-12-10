package egovframework.ezEKP.ezWebFolder.web;

import java.io.IOException;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.IOUtils;
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
import org.springframework.http.client.ClientHttpRequest;
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
import org.springframework.web.client.RequestCallback;
import org.springframework.web.client.ResponseExtractor;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.util.UriComponentsBuilder;

import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.let.user.login.vo.LoginSimpleVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Controller
public class EzWebFolderController extends EgovFileMngUtil {
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
	private static final Logger logger = LoggerFactory.getLogger(EzWebFolderController.class);

	@RequestMapping(value = "/ezWebFolder/webfolderMain.do")
	public String webfolderMain(@CookieValue("loginCookie") String loginCookie, HttpServletRequest req, Model model) {
		logger.debug("webfolderMain start");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String gwServerUrl = config.getProperty("config.webFolderGwServerURL");
		String url = gwServerUrl + "/rest/ezwebfolder/users/" +userInfo.getId() + "/checkRootFolder";
		
		HttpHeaders headers  = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", req.getServerName());
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder  = UriComponentsBuilder.fromHttpUrl(url);
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody;
		try {
			resultBody    = (JSONObject) jp.parse(result.getBody());
			String status = resultBody.get("status").toString();
		}
		catch (ParseException e) {
			e.printStackTrace();
		}
		
		logger.debug("webfolderMain end");
		return "ezWebFolder/webfolderMain";
	}

	@RequestMapping(value="/ezWebFolder/webfolderLeft.do")
	public String webfolderLeft(@CookieValue("loginCookie") String loginCookie,ModelMap modelMap, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception{
		logger.debug("webfolderLeft start");
		LoginSimpleVO userInfo    = commonUtil.userInfoSimple(loginCookie);
		
		String gwServerUrl = config.getProperty("config.webFolderGwServerURL");
		String url         = gwServerUrl + "/rest/ezwebfolder/check-wfadmin/" + userInfo.getId();
		
		HttpHeaders headers  = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder  = UriComponentsBuilder.fromHttpUrl(url);
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		String status                 = resultBody.get("status").toString();
		
		if (status.equals("ok")) {
			String checkResult = (String) resultBody.get("data");
			model.addAttribute("isWfAdmin", checkResult);
		}
		
		logger.debug("webfolderLeft end");
		return "ezWebFolder/webfolderLeft";
	}

	@RequestMapping(value="/ezWebFolder/webfolderConfig.do")
	public String webfolderConfig(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		logger.debug("webfolderConfig start");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		String gwServerUrl = config.getProperty("config.webFolderGwServerURL");
		String url         = gwServerUrl + "/rest/ezwebfolder/dept-chief/" + user.getId();
		
		HttpHeaders headers  = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder  = UriComponentsBuilder.fromHttpUrl(url);
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		String status                 = resultBody.get("status").toString();
		
		if (status.equals("ok")) {
			String checkResult = (String) resultBody.get("data");
			model.addAttribute("isChief", checkResult);
		}
		
		logger.debug("webfolderConfig end");
		return "ezWebFolder/webfolderConfig";
	}
	
	@RequestMapping(value="/ezWebFolder/deptChiefSetting.do")
	public String deptChiefConfig(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		logger.debug("deptChiefConfig start");
		logger.debug("deptChiefConfig end");
		return "ezWebFolder/deptChiefConfig";
	}
	
	@RequestMapping(value="/ezWebFolder/wefolderGeneral.do")
	public String webfolderGeneral(@CookieValue("loginCookie") String loginCookie,  HttpServletRequest request, Model model) throws Exception {
		logger.debug("webfolderGeneral start");
		
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		String gwServerUrl = config.getProperty("config.webFolderGwServerURL");
		String url         = gwServerUrl + "/rest/ezwebfolder/users/" + user.getId() + "/env/list-count";
		
		HttpHeaders headers  = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder  = UriComponentsBuilder.fromHttpUrl(url);
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		String status                 = resultBody.get("status").toString();
		
		if (status.equals("ok")) {
			JSONObject wfListConfig = (JSONObject) resultBody.get("data");
			model.addAttribute("wfListConfig", wfListConfig);
		}
		
		logger.debug("webfolderGeneral end");
		return "ezWebFolder/webfolderGeneral";
	}
	
	@RequestMapping(value = "/ezWebFolder/fileDuplicatedConfirm.do")
	public String fileDuplicatedConfirm(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("fileDuplicateConfirm start");
		
		boolean isFolder = request.getParameter("isFolder") != null;
		
		logger.debug("Is folder: " + isFolder);
		
		model.addAttribute("isFolder", isFolder);
		
		if (isFolder) {
			model.addAttribute("folderName", request.getParameter("folderName"));
		} else {
			SimpleDateFormat dateFormatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			String newDateStr = request.getParameter("newDate");
			String newSizeStr = request.getParameter("newSize");
			String oldSizeStr = request.getParameter("oldSize");

			try {
				newDateStr = dateFormatter.format(new Date(Long.parseLong(newDateStr)));
			} catch (Exception ex) {
				newDateStr = dateFormatter.format(new Date());
			}

			try {
				newSizeStr = humanReadableByteCount(Long.parseLong(newSizeStr));
			} catch (Exception ex) {
				// ignore
			}

			try {
				oldSizeStr = humanReadableByteCount(Long.parseLong(oldSizeStr));
			} catch (Exception ex) {
				// ignore
			}

			model.addAttribute("fileName", request.getParameter("fileName"));
			model.addAttribute("newDate", newDateStr);
			model.addAttribute("newSize", newSizeStr);
			model.addAttribute("oldDate", request.getParameter("oldDate"));
			model.addAttribute("oldSize", oldSizeStr);

			LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
			String oldOwnerId = request.getParameter("oldOwnerId");
			boolean isOwner = oldOwnerId.equals(userInfo.getId());

			model.addAttribute("isOwner", isOwner);
		}

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
	
	
	@RequestMapping(value="/ezWebFolder/getDuplicatedFiles.do", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	@ResponseBody
	public String duplicateFileCheck(@CookieValue("loginCookie") String loginCookie, @RequestBody Map<String, Object> parameter, HttpServletRequest request) throws Exception {
		logger.debug("getDuplicatedFiles start");

		// user id 추가
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		parameter.put("userId", userInfo.getId());

		String gwServerUrl = config.getProperty("config.webFolderGwServerURL");
		String url = gwServerUrl + "/rest/ezwebfolder/filemanage/duplicate-check";

		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url);

		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());

		HttpEntity<?> entity = new HttpEntity<>(new JSONObject(parameter), headers);
		RestTemplate rest = new RestTemplate();

		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.POST, entity, String.class);
		JSONParser jp = new JSONParser();
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());

		logger.debug("getDuplicatedFiles end");
		return resultBody.toString();
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/ezWebFolder/uploadFile.do", method = RequestMethod.POST)
	@ResponseBody
	public String uploadFile(MultipartHttpServletRequest request, @CookieValue("loginCookie") String loginCookie, Model model, HttpServletResponse response) throws Exception {
		logger.debug("uploadFile start");
		LoginSimpleVO userInfo         = commonUtil.userInfoSimple(loginCookie);
		List<MultipartFile> multiFiles = request.getFiles("fileToUpload");
		// nullable
		String nameArray               = request.getParameter("nameArray");
		String folderId                = request.getParameter("folderId");
		String gwServerUrl             = config.getProperty("config.webFolderGwServerURL");
		String url                     = gwServerUrl + "/rest/ezwebfolder/filemanage/file-upload";
		
		logger.debug("Folder Id: " + folderId);
		
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
		JSONObject jsonObject             = new JSONObject();
		JSONArray jsonArray               = new JSONArray();
		
		boolean useOriginalFileNames = true;
		
		// custom file names
		if (nameArray != null) {
			try {
				List<?> nameList = (List<?>) new JSONParser().parse(nameArray);
				
				for (Object fileName : nameList) {
					JSONObject fileJson = new JSONObject();
					
					fileJson.put("originalFilename", fileName);
					jsonArray.add(fileJson);
				}
				
				useOriginalFileNames = false;
			} catch (Exception ex) {
				// ignore
			}
		}
		
		for (MultipartFile file: multiFiles) {
			if (useOriginalFileNames) {
				JSONObject fileJson = new JSONObject();
				
				fileJson.put("originalFilename", file.getOriginalFilename());
				jsonArray.add(fileJson);
			}

			map.add("files", new MultipartFileResource(file.getInputStream(), file.getOriginalFilename()));
		}
		
		jsonObject.put("nameArray", jsonArray);
		jsonObject.put("userId", userInfo.getId());
		jsonObject.put("folderId", folderId);
		
		map.add("data", jsonObject);
		
		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.MULTIPART_FORM_DATA);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<MultiValueMap<String, Object>> entity = new HttpEntity<MultiValueMap<String, Object>>(map, headers);
		UriComponentsBuilder builder                     = UriComponentsBuilder.fromHttpUrl(url);
		ResponseEntity<String> result                    = restTemplate.exchange(builder.build().encode().toUri(), HttpMethod.POST, entity, String.class);
		
		JSONParser jp         = new JSONParser();
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		
		logger.debug("uploadFile end");
		return resultBody.toString();
	}
	
	@RequestMapping(value="/ezWebFolder/uploadFileOverwrite.do", method = RequestMethod.POST)
	@ResponseBody
	public String uploadFileOverwrite(MultipartHttpServletRequest request, @CookieValue("loginCookie") String loginCookie, Model model, HttpServletResponse response) throws Exception {
		logger.debug("uploadFileWrite start");
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		List<MultipartFile> multiFiles = request.getFiles("fileToUpload");
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
		List<?> fileIdList = (List<?>) new JSONParser().parse(fileIdListStr);
		
		for (MultipartFile file: multiFiles) {
			Map<String, Object> fileJson = new HashMap<>();
			
			fileJson.put("originalFilename", file.getOriginalFilename());
			nameList.add(fileJson);
			map.add("files", new MultipartFileResource(file.getInputStream(), file.getOriginalFilename()));
		}
		
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
		
		JSONParser jp = new JSONParser();
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		
		logger.debug("uploadFileWrite end");
		return resultBody.toString();
	}

	@RequestMapping(value="/ezWebFolder/downloadAttach.do", produces="application/zip")
	public void downloadAttach(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("downloadAttach start");
		LoginSimpleVO user  = commonUtil.userInfoSimple(loginCookie);
		String listFileId   = request.getParameter("fileList");
		String listFolderId = request.getParameter("folderList");
		String gwServerUrl  = config.getProperty("config.webFolderGwServerURL");
		String url          = gwServerUrl + "/rest/ezwebfolder/filemanage/file-download";
		
		logger.debug("FileId list: " + listFileId + " || FolderId list: " + listFolderId);
		
		UriComponentsBuilder builder  = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("userAgent", request.getHeader("User-Agent"))
				.queryParam("userId", user.getId())
				.queryParam("folderList", listFolderId)
				.queryParam("fileList", listFileId);
		
		RestTemplate rest               = new RestTemplate();
		//RequestCallback requestCallback = req -> req.getHeaders().setAccept(Arrays.asList(MediaType.APPLICATION_OCTET_STREAM, MediaType.ALL));
		RequestCallback requestCallback = new RequestCallback() {
			@Override
			public void doWithRequest(ClientHttpRequest req) throws IOException {
				req.getHeaders().setAccept(Arrays.asList(MediaType.APPLICATION_OCTET_STREAM, MediaType.ALL));
				req.getHeaders().set("x-user-host", request.getServerName());
			}
		};
		
		// Streams the response instead of loading it all in memory
		ResponseExtractor<Void> responseExtractor = res -> {
			response.setHeader("Content-Type", "application/zip");
			response.setHeader("Content-Disposition", res.getHeaders().get("Content-Disposition").get(0));
			
			IOUtils.copy(res.getBody(), response.getOutputStream());
			
			response.getOutputStream().flush();
			response.getOutputStream().close();
			
			return null;
		};
		
		rest.execute(builder.build().encode().toUri(), HttpMethod.GET, requestCallback, responseExtractor);
		logger.debug("downloadAttach end");
	}

	@RequestMapping(value="/ezWebFolder/deleteConfirm.do")
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

	@RequestMapping(value="/ezWebFolder/deleteFile.do", method = RequestMethod.POST)
	@ResponseBody
	public String deleteFile(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("deleteFile start");
		LoginSimpleVO user  = commonUtil.userInfoSimple(loginCookie);
		String listFileId   = request.getParameter("fileList");
		String listFolderId = request.getParameter("folderList");
		
		logger.debug("FileId list: " + listFileId);
		
		String gwServerUrl  = config.getProperty("config.webFolderGwServerURL");
		String url          = gwServerUrl + "/rest/ezwebfolder/filefolder-delete";
		
		UriComponentsBuilder builder  = UriComponentsBuilder.fromHttpUrl(url)
										.queryParam("userId", user.getId())
										.queryParam("fileList", listFileId)
										.queryParam("folderList", listFolderId);
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		RestTemplate rest    = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.DELETE, entity, String.class);
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		
		logger.debug("deleteFile end");
		return resultBody.toString();
	}

	@RequestMapping(value="/ezWebFolder/fileRenameConfirm.do")
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
		} else {
			logger.debug("Uploading");
			
			model.addAttribute("isUploading", true);
		}

		logger.debug("fileRenameConfirm start");
		return "/ezWebFolder/fileRename";
	}
	
	@RequestMapping(value="/ezWebFolder/fileDuplicateConfirm.do")
	public String fileDuplicateConfirm(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		logger.debug("fileDuplicateConfirm start");
		String fileId = request.getParameter("fileId") != null ? request.getParameter("fileId") : "";
		
		logger.debug("File Id: " + fileId);
		
		model.addAttribute("fileId", fileId);
		logger.debug("fileRenameConfirm start");
		return "/ezWebFolder/duplicateConfirm";
	}

	@RequestMapping(value="/ezWebFolder/renameFile.do", method = RequestMethod.POST)
	@ResponseBody
	public String renameFile(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) {
		logger.debug("renameFile start");
		
		LoginSimpleVO user  = commonUtil.userInfoSimple(loginCookie);
		String fileId       = request.getParameter("fileId");
		String newName      = request.getParameter("newName");
		
		logger.debug("File Id: " + fileId + " || New name: " + newName);
		
		String gwServerUrl  = config.getProperty("config.webFolderGwServerURL");
		String url          = gwServerUrl + "/rest/ezwebfolder/file-rename/fileid/" + fileId;
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
										.queryParam("userId", user.getId())
										.queryParam("newName", newName);
		
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
			e.printStackTrace();
		}
		
		logger.debug("renameFile end");
		return resultBody.toString();
	}

	@RequestMapping(value="/ezWebFolder/fileMoveConfirm.do")
	public String fileMoveConfirm(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		logger.debug("fileMoveConfirm start");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		String fileIdList  = request.getParameter("fileList")   != null ? request.getParameter("fileList") : "";
		String mode        = request.getParameter("mode")       != null ? request.getParameter("mode")     : "normal";
		String type        = request.getParameter("type")       != null ? request.getParameter("type")     : "";
		
		logger.debug("FileId list: " +fileIdList + " || mode: " + mode + " || type: " + type);
		
		if (fileIdList.equals("")) {
			logger.debug("File Move Confirm illegal arguments!");
			return "cmm/error/egovError";
		}
		
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
		
		model.addAttribute("fileIdList", fileIdList);
		model.addAttribute("primary", user.getLang());
		model.addAttribute("mode", mode);
		model.addAttribute("type", type);
		logger.debug("fileMoveConfirm end");
		
		return "/ezWebFolder/fileMove";
	}

	@RequestMapping(value="/ezWebFolder/moveFile.do", method = RequestMethod.POST)
	@ResponseBody
	public String moveFile(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("moveFile start");
		LoginSimpleVO user  = commonUtil.userInfoSimple(loginCookie);
		String fileList     = request.getParameter("fileList");
		String folderId     = request.getParameter("folderId");
		String mode         = request.getParameter("mode");
		String privileges   = request.getParameter("privileges");
		
		logger.debug("FileId list: " + fileList + " || Folder Id: " + folderId + " || mode: " + mode + " || privileges: " + privileges);
		
		String gwServerUrl  = config.getProperty("config.webFolderGwServerURL");
		String url          = gwServerUrl + "/rest/ezwebfolder/filemove/modes/" + mode;
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
										.queryParam("fileList", fileList)
										.queryParam("userId", user.getId())
										.queryParam("privileges", privileges)
										.queryParam("folderId", folderId);
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		RestTemplate rest    = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.PUT, entity, String.class);
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		
		logger.debug("moveFile end");
		return resultBody.toString();
	}

	@RequestMapping(value="/ezWebFolder/getFolderTree.do", method = RequestMethod.POST)
	@ResponseBody
	public String getFolderTree(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		logger.debug("getFolderTree start");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		String companyId   = request.getParameter("companyId");
		String folderId    = request.getParameter("folderId");
		String type        = request.getParameter("type");
		
		logger.debug("Company Id: " + companyId + " || Folder Id: " + folderId + " || Type: " + type);
		
		String gwServerUrl  = config.getProperty("config.webFolderGwServerURL");
		String url          = gwServerUrl + "/rest/ezwebfolder/foldersTree";
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
										.queryParam("userId", user.getId())
										.queryParam("companyId", companyId)
										.queryParam("folderId", folderId)
										.queryParam("type", type);
		
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		
		logger.debug("getFolderTree end");
		return resultBody.toString();
	}
	
	@RequestMapping(value="/ezWebFolder/getDeptTree.do", method = RequestMethod.POST)
	@ResponseBody
	public String getDepartTree(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		logger.debug("getDepartTree start");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		String companyId   = request.getParameter("companyId");
		String deptId      = request.getParameter("deptId") != null ? request.getParameter("deptId") : "";
		
		logger.debug("Company Id: " + companyId + " || Department Id: " + deptId);
		
		String gwServerUrl  = config.getProperty("config.webFolderGwServerURL");
		String url          = gwServerUrl + "/rest/ezwebfolder/depart-tree";
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
										.queryParam("userId", user.getId())
										.queryParam("deptId", deptId)
										.queryParam("companyId", companyId);
		
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		
		logger.debug("getDepartTree end");
		return resultBody.toString();
	}
	
	@RequestMapping(value="/ezWebFolder/getSubTree.do", method = RequestMethod.POST)
	@ResponseBody
	public String getSubDepartTree(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		logger.debug("getSubDepartTree start");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		String deptId      = request.getParameter("deptId");
		String level       = request.getParameter("level");
		
		logger.debug("Department Id: " + deptId + " || Level: " + level);
		
		String gwServerUrl  = config.getProperty("config.webFolderGwServerURL");
		String url          = gwServerUrl + "/rest/ezwebfolder/sub-tree/" + deptId;
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
										.queryParam("userId", user.getId())
										.queryParam("level", level);
		
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		
		logger.debug("getSubDepartTree end");
		return resultBody.toString();
	}
	
	@RequestMapping(value="/ezWebFolder/getDeptMembers.do", method = RequestMethod.POST)
	@ResponseBody
	public String getDeptMembers(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		logger.debug("getDeptMembers start");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		String deptId      = request.getParameter("deptId");
		
		logger.debug("Department Id: " + deptId);
		
		String gwServerUrl  = config.getProperty("config.webFolderGwServerURL");
		String url          = gwServerUrl + "/rest/ezwebfolder/dept-member/" + deptId;
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url).queryParam("userId", user.getId());
		
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		
		logger.debug("getDeptMembers end");
		return resultBody.toString();
	}

	@RequestMapping(value="/ezWebFolder/getFileFolderTree.do", method = RequestMethod.POST)
	@ResponseBody
	public String getFileFolderTree(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		logger.debug("getFileFolderTree start");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		String fileList    = request.getParameter("fileList");
		String mode        = request.getParameter("mode");
		String companyId   = request.getParameter("companyId");
		String type        = request.getParameter("type");
		
		logger.debug("FileId list: " + fileList + " || mode: " + mode + " || CompanyId: " + companyId + " || type: " + type);
		
		String gwServerUrl  = config.getProperty("config.webFolderGwServerURL");
		String url          = gwServerUrl + "/rest/ezwebfolder/foldersTree/file";
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
										.queryParam("userId", user.getId())
										.queryParam("companyId", companyId)
										.queryParam("fileList", fileList)
										.queryParam("type", type)
										.queryParam("mode", mode);
		
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		
		logger.debug("getFileFolderTree end");
		return resultBody.toString();
	}
	
	@RequestMapping(value="/ezWebFolder/saveGeneralList.do", method = RequestMethod.POST)
	@ResponseBody
	public String saveListSize(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		logger.debug("saveListSize start");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		String listCount   = request.getParameter("listCount");
		
		logger.debug("List count: " + listCount);
		
		String gwServerUrl  = config.getProperty("config.webFolderGwServerURL");
		String url          = gwServerUrl + "/rest/ezwebfolder/env/" + listCount + "/update";
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url).queryParam("userId", user.getId());
		
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.PUT, entity, String.class);
		
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		
		logger.debug("saveListSize end");
		return resultBody.toString();
	}
	
	@RequestMapping(value="/ezWebFolder/getDeptTreeForChief.do", method = RequestMethod.POST)
	@ResponseBody
	public String getDepartTreeForChief(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		logger.debug("getDepartTreeForChief start");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		String gwServerUrl = config.getProperty("config.webFolderGwServerURL");
		String url         = gwServerUrl + "/rest/ezwebfolder/depart-tree/chief/" + user.getId();
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url);
		
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		
		logger.debug("getDepartTreeForChief end");
		return resultBody.toString();
	}
	
	@RequestMapping(value="/ezWebFolder/getSelectedDeptForChief.do", method = RequestMethod.POST)
	@ResponseBody
	public String getSelectedDepartsForChief(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		logger.debug("getSelectedDepartsForChief start");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		String gwServerUrl = config.getProperty("config.webFolderGwServerURL");
		String url         = gwServerUrl + "/rest/ezwebfolder/selected-dept/chief/" + user.getId();
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url);
		
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		
		logger.debug("getSelectedDepartsForChief end");
		return resultBody.toString();
	}
	
	@RequestMapping(value="/ezWebFolder/saveSelectedDeptsForChief.do", method = RequestMethod.POST)
	@ResponseBody
	public String updateEnvDeptList(@CookieValue("loginCookie") String loginCookie, @RequestParam("deptList") List<String> deptsList, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		logger.debug("updateEnvDeptList start");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		String gwServerUrl = config.getProperty("config.webFolderGwServerURL");
		String url         = gwServerUrl + "/rest/ezwebfolder/env/dept-list";
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
										.queryParam("deptList", String.join(",", deptsList))
										.queryParam("userId", user.getId());
		
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.PUT, entity, String.class);
		
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		
		logger.debug("updateEnvDeptList end");
		return resultBody.toString();
	}

	@RequestMapping(value="/ezWebFolder/checkPermission.do", method = RequestMethod.POST)
	@ResponseBody
	public String checkPermission(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		logger.debug("checkPermission start");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		String fileId      = request.getParameter("fileId");
		String fileList    = request.getParameter("fileList");
		String folderList  = request.getParameter("folderList") != null ? request.getParameter("folderList") : "";
		
		logger.debug("File Id: " + fileId + " || FileId list: " + fileList);
		
		String gwServerUrl = config.getProperty("config.webFolderGwServerURL");
		String url         = gwServerUrl + "/rest/ezwebfolder/permission-check/" + user.getId();
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
										.queryParam("fileList", fileList)
										.queryParam("fileId", fileId)
										.queryParam("folderList",folderList);
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		
		logger.debug("checkPermission end");
		return resultBody.toString();
	}

	@RequestMapping(value="/ezWebFolder/getUserCapicity.do", method = RequestMethod.POST)
	@ResponseBody
	public String getUserCapacity(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		logger.debug("getUserCapacity start");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		String gwServerUrl = config.getProperty("config.webFolderGwServerURL");
		String url         = gwServerUrl + "/rest/ezwebfolder/capacity/" + user.getId();
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder  = UriComponentsBuilder.fromHttpUrl(url);
		
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		
		logger.debug("getUserCapacity end");
		return resultBody.toString();
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