package egovframework.ezEKP.ezWebFolder.web;

import java.io.IOException;
import java.io.InputStream;
import java.util.Arrays;
import java.util.List;
import java.util.Properties;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.io.IOUtils;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
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
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String gwServerUrl = config.getProperty("config.webFolderGwServerURL");
		String url = gwServerUrl + "/rest/ezwebfolder/users/" +userInfo.getId() + "/checkRootFolder";
		
		HttpHeaders headers  = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("host-name", req.getServerName());
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder  = UriComponentsBuilder.fromHttpUrl(url);
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody;
		try {
			resultBody = (JSONObject) jp.parse(result.getBody());
			String status                 = resultBody.get("status").toString();
		} catch (ParseException e) {
			e.printStackTrace();
		}
		
		return "ezWebFolder/webfolderMain";
	}

	@RequestMapping(value="/ezWebFolder/webfolderLeft.do")
	public String webfolderLeft(@CookieValue("loginCookie") String loginCookie,ModelMap modelMap, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception{
		LoginSimpleVO userInfo    = commonUtil.userInfoSimple(loginCookie);
		
		String gwServerUrl = config.getProperty("config.webFolderGwServerURL");
		String url         = gwServerUrl + "/rest/ezwebfolder/check-wfadmin/" + userInfo.getId();
		
		HttpHeaders headers  = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("host-name", request.getServerName());
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
		
		return "ezWebFolder/webfolderLeft";
	}

	@RequestMapping(value="/ezWebFolder/test.do")
	public String webfolderTest(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception{
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		model.addAttribute("primary", userInfo.getLang());
		return "ezWebFolder/webfolderTest";
	}

	@RequestMapping(value="/ezWebFolder/webfolderConfig.do")
	public String boardConfig(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		String gwServerUrl = config.getProperty("config.webFolderGwServerURL");
		String url         = gwServerUrl + "/rest/ezwebfolder/dept-chief/" + user.getId();
		
		HttpHeaders headers  = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("host-name", request.getServerName());
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
		
		return "ezWebFolder/webfolderConfig";
	}
	
	@RequestMapping(value="/ezWebFolder/deptChiefSetting.do")
	public String deptChiefConfig(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		return "ezWebFolder/deptChiefConfig";
	}
	
	@RequestMapping(value="/ezWebFolder/wefolderGeneral.do")
	public String webfolderGeneral(@CookieValue("loginCookie") String loginCookie,  HttpServletRequest request, Model model) throws Exception {
		logger.debug("webfolderGeneral started");
		
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		String gwServerUrl = config.getProperty("config.webFolderGwServerURL");
		String url         = gwServerUrl + "/rest/ezwebfolder/users/" + user.getId() + "/env/list-count";
		
		HttpHeaders headers  = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("host-name", request.getServerName());
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
		
		logger.debug("webfolderGeneral ended");
		return "ezWebFolder/webfolderGeneral";
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/ezWebFolder/uploadFile.do", method = RequestMethod.POST)
	public String uploadFile(MultipartHttpServletRequest request, @CookieValue("loginCookie") String loginCookie, Model model, HttpServletResponse response) throws Exception {
		logger.debug("Upload file is running!");
		
		LoginSimpleVO userInfo         = commonUtil.userInfoSimple(loginCookie);
		List<MultipartFile> multiFiles = request.getFiles("fileToUpload");
		String folderId                = request.getParameter("folderId");
		String gwServerUrl             = config.getProperty("config.webFolderGwServerURL");
		String url                     = gwServerUrl + "/rest/ezwebfolder/filemanage/file-upload";
		
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
		
		for (MultipartFile file: multiFiles) {
			JSONObject fileJson = new JSONObject();
			
			fileJson.put("originalFilename", file.getOriginalFilename());
			jsonArray.add(fileJson);
			map.add("files", new MultipartFileResource(file.getInputStream(), file.getOriginalFilename()));
		}
		
		jsonObject.put("nameArray", jsonArray);
		jsonObject.put("userId", userInfo.getId());
		jsonObject.put("folderId", folderId);
		
		map.add("data", jsonObject);
		
		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.MULTIPART_FORM_DATA);
		headers.set("host-name", request.getServerName());
		
		HttpEntity<MultiValueMap<String, Object>> entity = new HttpEntity<MultiValueMap<String, Object>>(map, headers);
		UriComponentsBuilder builder                     = UriComponentsBuilder.fromHttpUrl(url);
		ResponseEntity<String> result                    = restTemplate.exchange(builder.build().encode().toUri(), HttpMethod.POST, entity, String.class);
		
		JSONParser jp         = new JSONParser();
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		String status         = resultBody.get("status").toString();
		JSONArray listFileVO  = null;
		
		if (status.equals("ok")) {
			listFileVO = (JSONArray) resultBody.get("data");
			model.addAttribute("listFile", listFileVO);
		}
		else {
			String reason = resultBody.get("reason").toString();
			model.addAttribute("reason", reason);
		}
		
		logger.debug("Upload file finishes!");
		
		return "json";
	}

	@RequestMapping(value="/ezWebFolder/downloadAttach.do", produces="application/zip")
	public void downloadAttach(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("Download attach is running!");
		
		LoginSimpleVO user  = commonUtil.userInfoSimple(loginCookie);
		String listFileId   = request.getParameter("fileList");
		String listFolderId = request.getParameter("folderList");
		String gwServerUrl  = config.getProperty("config.webFolderGwServerURL");
		String url          = gwServerUrl + "/rest/ezwebfolder/filemanage/file-download";
		
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
				req.getHeaders().set("host-name", request.getServerName());
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
	
		logger.debug("Download attach finishes!");
	}

	@RequestMapping(value="/ezWebFolder/deleteConfirm.do")
	public String deleteFileConfirm(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		logger.debug("Delete File Confirm is running!");
		String listFileId = request.getParameter("fileList") != null ? request.getParameter("fileList") : "";
		
		if (listFileId.equals("")) {
			logger.debug("Delete File Confirm illegal arguments!");
			return "cmm/error/egovError";
		}
		
		model.addAttribute("fileList", listFileId);
		logger.debug("Delete File Confirm finishes!");
		
		return "/ezWebFolder/fileDelete";
	}

	@RequestMapping(value="/ezWebFolder/deleteFile.do", method = RequestMethod.POST)
	public String deleteFile(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("Delete File is running!");
		
		LoginSimpleVO user  = commonUtil.userInfoSimple(loginCookie);
		String listFileId   = request.getParameter("fileList");
		String gwServerUrl  = config.getProperty("config.webFolderGwServerURL");
		String url          = gwServerUrl + "/rest/ezwebfolder/file-delete";
		
		UriComponentsBuilder builder  = UriComponentsBuilder.fromHttpUrl(url)
										.queryParam("tenantId", user.getTenantId())
										.queryParam("userId", user.getId())
										.queryParam("fileList", listFileId);
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("host-name", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		RestTemplate rest    = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.DELETE, entity, String.class);
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		String status                 = resultBody.get("status").toString();
		
		if (!status.equals("ok")) {
			String reason = resultBody.get("reason").toString();
			model.addAttribute("reason", reason);
		}
		
		logger.debug("Status: " + status);
		logger.debug("Delete File finishes!");
		
		return "json";
	}

	@RequestMapping(value="/ezWebFolder/fileRenameConfirm.do")
	public String fileRenameConfirm(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		logger.debug("File Rename Confirm is running!");
		String fileId = request.getParameter("fileId") != null ? request.getParameter("fileId") : "";
		
		if (fileId.equals("")) {
			logger.debug("File Rename Confirm illegal arguments!");
			return "cmm/error/egovError";
		}
		
		model.addAttribute("fileId", fileId);
		logger.debug("File Rename Confirm finishes!");
		
		return "/ezWebFolder/fileRename";
	}

	@RequestMapping(value="/ezWebFolder/renameFile.do", method = RequestMethod.POST)
	public void renameFile(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("Rename File is running!");
		
		LoginSimpleVO user  = commonUtil.userInfoSimple(loginCookie);
		String fileId       = request.getParameter("fileId");
		String newName      = request.getParameter("newName");
		String gwServerUrl  = config.getProperty("config.webFolderGwServerURL");
		String url          = gwServerUrl + "/rest/ezwebfolder/file-rename/fileid/" + fileId;
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("tenantId", user.getTenantId())
				.queryParam("userId", user.getId())
				.queryParam("newName", newName);
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("host-name", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		RestTemplate rest    = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.PUT, entity, String.class);
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		String status                 = resultBody.get("status").toString();
		
		logger.debug("Status: " + status);
		
		logger.debug("Rename File finishes!");
	}

	@RequestMapping(value="/ezWebFolder/fileMoveConfirm.do")
	public String fileMoveConfirm(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		logger.debug("File Move Confirm is running!");
		
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		String fileIdList  = request.getParameter("fileList")   != null ? request.getParameter("fileList") : "";
		String mode        = request.getParameter("mode")       != null ? request.getParameter("mode")     : "normal";
		String type        = request.getParameter("type")       != null ? request.getParameter("type")     : "";
		
		if (fileIdList.equals("")) {
			logger.debug("File Move Confirm illegal arguments!");
			return "cmm/error/egovError";
		}
		
		String gwServerUrl   = config.getProperty("config.webFolderGwServerURL");
		String url           = gwServerUrl + "/rest/ezwebfolderadmin/company-list/" + user.getId();
		
		HttpHeaders headers  = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("host-name", request.getServerName());
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
		logger.debug("File Move Confirm finishes!");
		
		return "/ezWebFolder/fileMove";
	}

	@RequestMapping(value="/ezWebFolder/moveFile.do", method = RequestMethod.POST)
	public String moveFile(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("Move File is running!");
		
		LoginSimpleVO user  = commonUtil.userInfoSimple(loginCookie);
		String fileList     = request.getParameter("fileList");
		String folderId     = request.getParameter("folderId");
		String mode         = request.getParameter("mode");
		String privileges   = request.getParameter("privileges");
		
		String gwServerUrl  = config.getProperty("config.webFolderGwServerURL");
		String url          = gwServerUrl + "/rest/ezwebfolder/filemove/modes/" + mode;
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
										.queryParam("tenantId", user.getTenantId())
										.queryParam("fileList", fileList)
										.queryParam("userId", user.getId())
										.queryParam("privileges", privileges)
										.queryParam("folderId", folderId);
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("host-name", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		RestTemplate rest    = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.PUT, entity, String.class);
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		String status                 = resultBody.get("status").toString();
		
		if (!status.equals("ok")) {
			String reason = resultBody.get("reason").toString();
			model.addAttribute("reason", reason);
		}
		
		logger.debug("Status: " + status);
		logger.debug("Move File finishes!");
		
		return "json";
	}

	@RequestMapping(value="/ezWebFolder/getFolderTree.do", method = RequestMethod.POST)
	public String getFolderTree(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		String companyId   = request.getParameter("companyId");
		String folderId    = request.getParameter("folderId");
		String type        = request.getParameter("type");
		String gwServerUrl = config.getProperty("config.webFolderGwServerURL");
		String url         = gwServerUrl + "/rest/ezwebfolder/foldersTree";
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("host-name", request.getServerName());
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
		String status                 = resultBody.get("status").toString();
		
		if (status.equals("ok")) {
			String currFolder = (String)resultBody.get("currentFolder");
			
			if (!type.equals("dept")) {
				JSONObject folderTree = (JSONObject) resultBody.get("data");
				model.addAttribute("folderTree", folderTree);
			}
			else {
				JSONArray folderTree = (JSONArray) resultBody.get("data");
				model.addAttribute("folderTree", folderTree);
			}
			
			if (!currFolder.equals("")) {
				model.addAttribute("currentFolder", currFolder);
			}
			
		}
		
		return "json";
	}
	
	@RequestMapping(value="/ezWebFolder/getDeptTree.do", method = RequestMethod.POST)
	public String getDepartTree(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		String companyId   = request.getParameter("companyId");
		String deptId      = request.getParameter("deptId") != null ? request.getParameter("deptId") : "";
		String gwServerUrl = config.getProperty("config.webFolderGwServerURL");
		String url         = gwServerUrl + "/rest/ezwebfolder/depart-tree";
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("host-name", request.getServerName());
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
										.queryParam("userId", user.getId())
										.queryParam("deptId", deptId)
										.queryParam("companyId", companyId);
		
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		String status                 = resultBody.get("status").toString();
		
		if (status.equals("ok")) {
			JSONObject deptTree   = (JSONObject) resultBody.get("data");
			String     userDept   = (String) resultBody.get("userDept");
			if (userDept != null && !userDept.equals("")) {
				model.addAttribute("currentDept", userDept);
			}
			model.addAttribute("deptTree", deptTree);
		}
		
		return "json";
	}
	
	@RequestMapping(value="/ezWebFolder/getSubTree.do", method = RequestMethod.POST)
	public String getSubDepartTree(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		String deptId      = request.getParameter("deptId");
		String level       = request.getParameter("level");
		String gwServerUrl = config.getProperty("config.webFolderGwServerURL");
		String url         = gwServerUrl + "/rest/ezwebfolder/sub-tree/" + deptId;
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("host-name", request.getServerName());
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
										.queryParam("userId", user.getId())
										.queryParam("level", level);
		
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		String status                 = resultBody.get("status").toString();
		
		if (status.equals("ok")) {
			JSONObject deptTree   = (JSONObject) resultBody.get("data");
			model.addAttribute("subTree", deptTree);
		}
		
		return "json";
	}
	
	@RequestMapping(value="/ezWebFolder/getDeptMembers.do", method = RequestMethod.POST)
	public String getDeptMembers(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		String deptId      = request.getParameter("deptId");
		String gwServerUrl = config.getProperty("config.webFolderGwServerURL");
		String url         = gwServerUrl + "/rest/ezwebfolder/dept-member/" + deptId;
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("host-name", request.getServerName());
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url).queryParam("userId", user.getId());
		
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		String status                 = resultBody.get("status").toString();
		
		if (status.equals("ok")) {
			JSONArray memberList = (JSONArray) resultBody.get("data");
			model.addAttribute("listMembers", memberList);
		}
		
		return "json";
	}

	@RequestMapping(value="/ezWebFolder/getFileFolderTree.do", method = RequestMethod.POST)
	public String getFileFolderTree(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		String fileList    = request.getParameter("fileList");
		String mode        = request.getParameter("mode");
		String companyId   = request.getParameter("companyId");
		String type        = request.getParameter("type");
		
		String gwServerUrl = config.getProperty("config.webFolderGwServerURL");
		String url         = gwServerUrl + "/rest/ezwebfolder/foldersTree/file";
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("host-name", request.getServerName());
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
		String status                 = resultBody.get("status").toString();
		
		if (status.equals("ok")) {
			JSONArray currFolders = (JSONArray)resultBody.get("currentFolders");
			
			if (!type.equals("dept") && !type.equals("share")) {
				JSONObject folderTree = (JSONObject) resultBody.get("data");
				model.addAttribute("folderTree", folderTree);
			}
			else {
				JSONArray folderTree = (JSONArray) resultBody.get("data");
				model.addAttribute("folderTree", folderTree);
			}
			
			if (currFolders != null && currFolders.size() > 0) {
				model.addAttribute("currentFolders", currFolders);
			}
			
		}
		
		return "json";
	}
	
	@RequestMapping(value="/ezWebFolder/saveGeneralList.do", method = RequestMethod.POST)
	public String saveListSize(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		String listCount   = request.getParameter("listCount");
		
		String gwServerUrl = config.getProperty("config.webFolderGwServerURL");
		String url         = gwServerUrl + "/rest/ezwebfolder/env/" + listCount + "/update";
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("host-name", request.getServerName());
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url).queryParam("userId", user.getId());
		
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.PUT, entity, String.class);
		
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		String status                 = resultBody.get("status").toString();
		
		if (status.equals("ok")) {
			model.addAttribute("resultValue", "ok");
		}
		else {
			model.addAttribute("resultValue", "error");
		}
		
		return "json";
	}
	
	@RequestMapping(value="/ezWebFolder/getDeptTreeForChief.do", method = RequestMethod.POST)
	public String getDepartTreeForChief(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		String gwServerUrl = config.getProperty("config.webFolderGwServerURL");
		String url         = gwServerUrl + "/rest/ezwebfolder/depart-tree/chief/" + user.getId();
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("host-name", request.getServerName());
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url);
		
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		String status                 = resultBody.get("status").toString();
		
		if (status.equals("ok")) {
			JSONArray deptTree      = (JSONArray) resultBody.get("data");
			JSONArray selectedDepts = (JSONArray) resultBody.get("selectedDepts");
			String     userDept     = (String) resultBody.get("userDept");
			model.addAttribute("userDept", userDept);
			model.addAttribute("deptTree", deptTree);
			model.addAttribute("selectedDepts", selectedDepts);
		}
		
		return "json";
	}
	
	@RequestMapping(value="/ezWebFolder/getSelectedDeptForChief.do", method = RequestMethod.POST)
	public String getSelectedDepartsForChief(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		String gwServerUrl = config.getProperty("config.webFolderGwServerURL");
		String url         = gwServerUrl + "/rest/ezwebfolder/selected-dept/chief/" + user.getId();
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("host-name", request.getServerName());
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url);
		
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		String status                 = resultBody.get("status").toString();
		
		if (status.equals("ok")) {
			JSONArray selectedDepts = (JSONArray) resultBody.get("data");
			model.addAttribute("selectedDepts", selectedDepts);
		}
		
		return "json";
	}
	
	@RequestMapping(value="/ezWebFolder/saveSelectedDeptsForChief.do", method = RequestMethod.POST)
	public String updateEnvDeptList(@CookieValue("loginCookie") String loginCookie, @RequestParam("deptList") List<String> deptsList, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		String gwServerUrl = config.getProperty("config.webFolderGwServerURL");
		String url         = gwServerUrl + "/rest/ezwebfolder/env/dept-list";
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("host-name", request.getServerName());
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
										.queryParam("deptList", String.join(",", deptsList))
										.queryParam("userId", user.getId());
		
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.PUT, entity, String.class);
		
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		String status                 = resultBody.get("status").toString();
		
		if (status.equals("ok")) {
			model.addAttribute("resultValue", "ok");
		}
		else {
			model.addAttribute("resultValue", "error");
		}
		
		return "json";
	}

	@RequestMapping(value="/ezWebFolder/checkPermission.do", method = RequestMethod.POST)
	public String checkPermission(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		String fileId      = request.getParameter("fileId");
		String fileList    = request.getParameter("fileList");
		String gwServerUrl = config.getProperty("config.webFolderGwServerURL");
		String url         = gwServerUrl + "/rest/ezwebfolder/permission-check/" + user.getId();
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("host-name", request.getServerName());
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
										.queryParam("fileList", fileList)
										.queryParam("fileId", fileId);
		
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		String status                 = resultBody.get("status").toString();
		
		if (status.equals("ok")) {
			String check = resultBody.get("data").toString();
			model.addAttribute("resultValue", check);
		}
		
		return "json";
	}

	@RequestMapping(value="/ezWebFolder/getUserCapicity.do", method = RequestMethod.POST)
	public String getUserCapacity(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		String gwServerUrl = config.getProperty("config.webFolderGwServerURL");
		String url         = gwServerUrl + "/rest/ezwebfolder/capacity/" + user.getId();
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("host-name", request.getServerName());
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url);
		
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		String status                 = resultBody.get("status").toString();
		
		if (status.equals("ok")) {
			JSONObject userCap   = (JSONObject) resultBody.get("data");
			model.addAttribute("userCapacity", userCap);
		}
		
		return "json";
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