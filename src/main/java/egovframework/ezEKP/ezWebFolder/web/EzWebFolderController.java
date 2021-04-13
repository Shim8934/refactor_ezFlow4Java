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
import java.util.Optional;
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
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.http.client.ClientHttpRequest;
import org.springframework.http.client.ClientHttpResponse;
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
import org.springframework.web.client.DefaultResponseErrorHandler;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.RequestCallback;
import org.springframework.web.client.ResponseExtractor;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.util.UriComponentsBuilder;

import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezWebFolder.vo.DuplicateInfoVO.Type;
import egovframework.let.user.login.vo.LoginSimpleVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Controller
public class EzWebFolderController extends EgovFileMngUtil {
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
	private static final Logger logger = LoggerFactory.getLogger(EzWebFolderController.class);

	@RequestMapping(value = "/ezWebFolder/webfolderMain.do", method = RequestMethod.GET)
	public String webfolderMain(@CookieValue("loginCookie") String loginCookie, HttpServletRequest req, Model model) {
		logger.debug("webfolderMain start");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String gwServerUrl = config.getProperty("config.webFolderGwServerURL");
		String url = gwServerUrl + "/rest/ezwebfolder/users/" +userInfo.getId() + "/checkRootFolder";
		String folderType = req.getParameter("folderType")      != null ? commonUtil.stripTagSymbols(commonUtil.stripScriptTagsAndFunctions(req.getParameter("folderType"))) : "C";
		
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
			model.addAttribute("folderType", folderType);
			model.addAttribute("status", status);
		}
		catch (ParseException e) {
			e.printStackTrace();
		}
		
		logger.debug("webfolderMain end");
		return "ezWebFolder/webfolderMain";
	}

	@RequestMapping(value="/ezWebFolder/webfolderLeft.do", method = RequestMethod.GET)
	public String webfolderLeft(@CookieValue("loginCookie") String loginCookie,ModelMap modelMap, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception{
		logger.debug("webfolderLeft start");
		LoginSimpleVO userInfo    = commonUtil.userInfoSimple(loginCookie);
		
		String gwServerUrl = config.getProperty("config.webFolderGwServerURL");
		String url         = gwServerUrl + "/rest/ezwebfolder/check-wfadmin/" + userInfo.getId();
		String folderType = request.getParameter("folderType")      != null ? request.getParameter("folderType") : "C";
		folderType = commonUtil.stripTagSymbols(commonUtil.stripScriptTagsAndFunctions(folderType));
		
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
		
		if (folderType.equals("C")) {
		String gwServerUrl2   = config.getProperty("config.webFolderGwServerURL");
		String url2           = gwServerUrl + "/rest/ezwebfolder/check-folderManager/" + userInfo.getId();
		
		HttpHeaders headers2  = new HttpHeaders();
		headers2.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers2.set("x-user-host", request.getServerName());
		HttpEntity<?> entity2 = new HttpEntity<>(headers2);
		
		UriComponentsBuilder builder2  = UriComponentsBuilder.fromHttpUrl(url2);
		RestTemplate rest2             = new RestTemplate();
		ResponseEntity<String> result2 = rest.exchange(builder2.build().encode().toUri(), HttpMethod.GET, entity2, String.class);
		
		JSONObject resultBody2        = (JSONObject) jp.parse(result2.getBody());
		String status2                 = resultBody2.get("status").toString();
		
			if (status2.equalsIgnoreCase("ok")) {
				JSONArray folderListMap = (JSONArray) resultBody2.get("folderListMap");
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
	
	@RequestMapping(value="/ezWebFolder/deptChiefSetting.do", method = RequestMethod.GET)
	public String deptChiefConfig(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		logger.debug("deptChiefConfig start");
		logger.debug("deptChiefConfig end");
		return "ezWebFolder/deptChiefConfig";
	}
	
	@RequestMapping(value="/ezWebFolder/wefolderGeneral.do", method = RequestMethod.GET)
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
			} catch (Exception ex) {
				// ignore
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
		} catch (Exception ignore) {}

		try {
			oldSize = humanReadableByteCount(Long.parseLong(oldSize));
		} catch (Exception ignore) {}

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
	public String duplicateFileCheck(@CookieValue("loginCookie") String loginCookie, @RequestBody Map<String, Object> parameter, HttpServletRequest request) throws Exception {
		logger.debug("getDuplicateFiles start");

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

		logger.debug("getDuplicateFiles end");
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
		jsonObject.put("encrypt", encrypt);
		jsonObject.put("parentId", parentId);
		
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

	@RequestMapping(value="/ezWebFolder/downloadAttach.do", method = RequestMethod.GET, produces="application/zip")
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
			if (res.getStatusCode() == HttpStatus.FORBIDDEN) {
				return null;
			}

			response.setHeader("Content-Type", "application/zip");
			response.setHeader("Content-Disposition", res.getHeaders().get("Content-Disposition").get(0));
			
			IOUtils.copy(res.getBody(), response.getOutputStream());
			
			response.getOutputStream().flush();
			response.getOutputStream().close();
			
			return null;
		};
		
		rest.setErrorHandler(new DefaultResponseErrorHandler() {
			public void handleError(ClientHttpResponse res) throws IOException {
				try {
					super.handleError(res);
				} catch (HttpClientErrorException e) {
					if (e.getStatusCode() == HttpStatus.FORBIDDEN) {
						response.sendError(403, res.getStatusText());
					}
				}
			};
		});

		rest.execute(builder.build().encode().toUri(), HttpMethod.GET, requestCallback, responseExtractor);
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
			e.printStackTrace();
		}
		
		logger.debug("renameFile end");
		return resultBody.toString();
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
		
		logger.debug("FileId list: " + fileIdList + " || FolderId List: " + folderIdList + " || mode: " + mode + " || type: " + type + 
				"|| folderTypeCheck : " + folderTypeCheck);
		
		if (fileIdList.isEmpty() && folderIdList.isEmpty()) {
			logger.debug("File Move Confirm illegal arguments!");
			return "cmm/error/egovError";
		}
		
		Map<String, Object> permissionParams = new HashMap<>();
		permissionParams.put("fileList", fileIdList);
		permissionParams.put("folderList", folderIdList);
		
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

		model.addAttribute("fileIdList", fileIdList);
		model.addAttribute("folderIdList", folderIdList);
		model.addAttribute("primary", user.getLang());
		model.addAttribute("mode", mode);
		model.addAttribute("type", type);
		model.addAttribute("folderTypeCheck", folderTypeCheck);
		model.addAttribute("isPermittedMove", isPermittedMove);
		model.addAttribute("isPermittedCopy", isPermittedCopy);
		logger.debug("fileMoveConfirm end");
		
		return "/ezWebFolder/fileMove";
	}

	@RequestMapping(value="/ezWebFolder/moveFile.do", method = RequestMethod.POST)
	@ResponseBody
	public String moveFile(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("moveFile start");
		LoginSimpleVO user  = commonUtil.userInfoSimple(loginCookie);
		String fileList     = request.getParameter("fileList");
		String folderList   = request.getParameter("folderList");
		String nameList     = request.getParameter("nameList");
		String folderId     = request.getParameter("folderId");
		String mode         = request.getParameter("mode");
		String privileges   = request.getParameter("privileges");
		String overwritable = request.getParameter("overwritable");
		
		logger.debug("FileId list: " + fileList + " || Folder Id: " + folderId + " || mode: " + mode + " || privileges: " + privileges + " || nameList: " + nameList);
		
		String gwServerUrl  = config.getProperty("config.webFolderGwServerURL");
		String url          = gwServerUrl + "/rest/ezwebfolder/filemove/modes/" + mode;
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
										.queryParam("fileList", fileList)
										.queryParam("folderList", folderList)
										.queryParam("userId", user.getId())
										.queryParam("privileges", privileges)
										.queryParam("folderId", folderId);
		
		if (overwritable != null) {
			builder.queryParam("overwritable", overwritable);
		}
		
		if (nameList != null) {
			builder.queryParam("nameList", nameList);
		}
		
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
	
	@RequestMapping(value="/ezWebFolder/savePortletConfig.do", method = RequestMethod.POST)
	@ResponseBody
	public String savePortletConfig(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		logger.debug("savePortletConfig start");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		String selectFolderId   = request.getParameter("selectFolderId");
		String targetFolderId   = request.getParameter("targetFolderId");
		
		logger.debug("selectFolderId: {}, targetFolderId: {}", selectFolderId, targetFolderId);
		if(targetFolderId.equals(selectFolderId)){
			return "{\"code\":0,\"status\":\"ok\"}";
		}
		
		String gwServerUrl  = config.getProperty("config.webFolderGwServerURL");
		String url          = gwServerUrl + "/rest/ezwebfolder/env/" + targetFolderId 
				+ (selectFolderId.isEmpty()? "/insert" : "/update") + "PortletFolderId";
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url).queryParam("userId", user.getId());
		
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.PUT, entity, String.class);
		
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		
		logger.debug("savePortletConfig end");
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
		String isRecursive = Optional.ofNullable(request.getParameter("isRecursive")).orElse("false");
		
		logger.debug("File Id: " + fileId + " || FileId list: " + fileList + ",folderList=" + folderList);
		
		String gwServerUrl = config.getProperty("config.webFolderGwServerURL");
		String url         = gwServerUrl + "/rest/ezwebfolder/permission-check/" + user.getId();
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
										.queryParam("fileList", fileList)
										.queryParam("fileId", fileId)
										.queryParam("folderList", folderList)
										.queryParam("isRecursive", isRecursive);
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		
		logger.debug("checkPermission end");
		return resultBody.toString();
	}

	@RequestMapping(value="/ezWebFolder/checkPermission_y.do", method = RequestMethod.POST)
	@ResponseBody
	public String checkPermission_y(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("checkPermission_y start");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		String fileList = request.getParameter("fileList");
		String folderList = request.getParameter("folderList");

		logger.debug("fileList: {}, folderList: {}", fileList, folderList);

		String url = "/rest/ezwebfolder/users/" + user.getId() + "/checkpermissions";

		Map<String, Object> jsonParams = new HashMap<>();
		jsonParams.put("fileList", fileList);
		jsonParams.put("folderList", folderList);

		JSONObject resultBody = commonUtil.getJsonFromWebFolderRestApi(url, null, request, "post", new JSONObject(jsonParams));

		logger.debug("checkPermission_y end");
		return resultBody.toString();
	}

	@RequestMapping(value="/ezWebFolder/getCapacity.do", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	@ResponseBody
	public String getFolderCapacity(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		logger.debug("getFolderCapacity start");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		String gwServerUrl = config.getProperty("config.webFolderGwServerURL");
		String folderId = request.getParameter("folderId");
		String url         = gwServerUrl + "/rest/ezwebfolderadmin/capacity/folder/" + folderId;
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder  = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("primary", user.getLang());
		
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		
		logger.debug("getFolderCapacity end");
		return resultBody.toString();
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ezWebFolder/fileVersionManage.do", method = RequestMethod.GET)
	public String fileVersionManage(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		logger.debug("fileVersionManage start");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		String fileId = request.getParameter("fileId");

		logger.debug("fileId: {}", fileId);

		if (fileId == null) {
			logger.debug("File version manage illegal arguments!");
			return "cmm/error/egovError";
		}

		String gwServerUrl = config.getProperty("config.webFolderGwServerURL");
		String url = gwServerUrl + "/rest/ezwebfolder/file/" + fileId + "/histories";

		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		HttpEntity<?> entity = new HttpEntity<>(headers);

		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url).queryParam("userId", user.getId());
		RestTemplate rest = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);

		JSONParser jp = new JSONParser();
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		String status = resultBody.get("status").toString();

		if (status.equals("ok")) {
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
		}

		model.addAttribute("primary", user.getLang());
		model.addAttribute("fileId", fileId);

		logger.debug("fileVersionManage end");

		return "/ezWebFolder/fileVersionManage";
	}

	@RequestMapping(value = "/ezWebFolder/restoreVersion.do", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	@ResponseBody
	public String restoreVersion(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("restoreVersion start");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		String gwServerUrl = config.getProperty("config.webFolderGwServerURL");
		String fileId = request.getParameter("fileId");
		String version = request.getParameter("version");
		String url = gwServerUrl + "/rest/ezwebfolder/file/" + fileId + "/histories/" + version;

		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		HttpEntity<?> entity = new HttpEntity<>(headers);

		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url).queryParam("userId", user.getId());

		RestTemplate rest = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.PUT, entity, String.class);

		logger.debug("restoreVersion end");
		return result.getBody();
	}

	@RequestMapping(value = "/ezWebFolder/deleteVersions.do", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	@ResponseBody
	public String deleteVersion(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("deleteVersion start");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		String gwServerUrl = config.getProperty("config.webFolderGwServerURL");
		String fileId = request.getParameter("fileId");
		String versions = request.getParameter("versions");
		boolean isMultiple = versions.contains(",");

		String url = gwServerUrl + "/rest/ezwebfolder/file/" + fileId + "/histories"
				+ (isMultiple ? "" : "/" + versions);

		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		HttpEntity<?> entity = new HttpEntity<>(headers);

		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url).queryParam("userId", user.getId());

		if (isMultiple) {
			builder.queryParam("versions", versions);
		}

		RestTemplate rest = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.DELETE, entity, String.class);

		logger.debug("deleteVersion end");
		return result.getBody();
	}

	@RequestMapping(value="/ezWebFolder/downloadVersion.do", method = RequestMethod.GET, produces="application/zip")
	public void downloadVersion(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("downloadAttach start");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		String userId = user.getId();
		String fileId = request.getParameter("fileId");
		String versions = request.getParameter("versions");
		String gwServerUrl = config.getProperty("config.webFolderGwServerURL");
		String url = gwServerUrl + "/rest/ezwebfolder/filemanage/version-download";

		logger.debug("userId: {}, fildId: {}, versions: {}", userId, fileId, versions);

		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("userAgent", request.getHeader("User-Agent"))
				.queryParam("userId", userId)
				.queryParam("fileId", fileId)
				.queryParam("versions", versions);

		RestTemplate rest = new RestTemplate();
		RequestCallback requestCallback = new RequestCallback() {
			@Override
			public void doWithRequest(ClientHttpRequest req) throws IOException {
				req.getHeaders().setAccept(Arrays.asList(MediaType.APPLICATION_OCTET_STREAM, MediaType.ALL));
				req.getHeaders().set("x-user-host", request.getServerName());
			}
		};

		// Streams the response instead of loading it all in memory
		ResponseExtractor<Void> responseExtractor = res -> {
			if (res.getStatusCode() == HttpStatus.FORBIDDEN) {
				return null;
			}

			response.setHeader("Content-Type", "application/zip");
			response.setHeader("Content-Disposition", res.getHeaders().get("Content-Disposition").get(0));

			IOUtils.copy(res.getBody(), response.getOutputStream());

			response.getOutputStream().flush();
			response.getOutputStream().close();

			return null;
		};

		rest.setErrorHandler(new DefaultResponseErrorHandler() {
			public void handleError(ClientHttpResponse res) throws IOException {
				try {
					super.handleError(res);
				} catch (HttpClientErrorException e) {
					if (e.getStatusCode() == HttpStatus.FORBIDDEN) {
						response.sendError(403, res.getStatusText());
					}
				}
			};
		});

		rest.execute(builder.build().encode().toUri(), HttpMethod.GET, requestCallback, responseExtractor);
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
	public String checkNotInherit(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
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
