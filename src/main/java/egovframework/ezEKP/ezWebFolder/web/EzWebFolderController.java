package egovframework.ezEKP.ezWebFolder.web;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;
import java.util.Properties;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.io.IOUtils;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.http.client.ClientHttpRequest;
import org.springframework.http.client.SimpleClientHttpRequestFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RequestCallback;
import org.springframework.web.client.ResponseExtractor;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.util.UriComponentsBuilder;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderAdminService;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderService;
import egovframework.let.user.login.vo.LoginSimpleVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Controller
public class EzWebFolderController extends EgovFileMngUtil {
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
	@Resource(name = "egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Resource(name="EzCommonService")
	private EzCommonService ezCommonService;
	
	@Resource(name = "EzWebFolderService")
	private EzWebFolderService ezWebFolderService;

	@Resource(name = "EzWebFolderAdminService")
	private EzWebFolderAdminService ezWebFolderAdminService;
	
	private static final Logger logger = LoggerFactory.getLogger(EzWebFolderController.class);

	@RequestMapping(value = "/ezWebFolder/webfolderMain.do")
	public String webfolderMain(HttpServletRequest req, Model model) {
		return "ezWebFolder/webfolderMain";
	}

	@RequestMapping(value="/ezWebFolder/webfolderLeft.do")
	public String webfolderLeft(@CookieValue("loginCookie") String loginCookie,ModelMap modelMap, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception{
		return "ezWebFolder/webfolderLeft";
	}

	@RequestMapping(value="/ezWebFolder/test.do")
	public String webfolderTest(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception{
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		model.addAttribute("primary", userInfo.getLang());
		return "ezWebFolder/webfolderTest";
	}

	@RequestMapping(value="/ezWebFolder/getShareListPage.do")
	public String getShareListPage(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception{
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		model.addAttribute("primary", userInfo.getLang());
		return "ezWebFolder/fileFolderShare";
	}

	@RequestMapping(value="/ezWebFolder/getGivenShareList.do")
	public String getGivenShareList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception{
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		model.addAttribute("primary", userInfo.getLang());
		return "ezWebFolder/fileFolderGivenShare";
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/ezWebFolder/uploadFile.do")
	@ResponseBody
	public String uploadFile(MultipartHttpServletRequest request, @CookieValue("loginCookie") String loginCookie, HttpServletResponse response) throws Exception {
		logger.debug("Upload file is running!");
		
		LoginSimpleVO userInfo         = commonUtil.userInfoSimple(loginCookie);
		List<MultipartFile> multiFiles = request.getFiles("fileToUpload");
		String folderId                = request.getParameter("folderId");
		String gwServerUrl             = config.getProperty("config.webfolderGwServerURL");
		String url                     = gwServerUrl + "/rest/ezwebfolder/filemanage/file-upload";
		
		SimpleClientHttpRequestFactory requestFactory = new SimpleClientHttpRequestFactory();
		requestFactory.setBufferRequestBody(false);
		
		RestTemplate restTemplate         = new RestTemplate(requestFactory);
		MultiValueMap<String, Object> map = new LinkedMultiValueMap<String, Object>();
		
		JSONObject jsonObject = new JSONObject();
		JSONArray jsonArray   = new JSONArray();
		
		for (MultipartFile file: multiFiles) {
			JSONObject fileJson        = new JSONObject();
			ByteArrayResource resource = new ByteArrayResource(file.getBytes()) {
				@Override
				public String getFilename() {
					return file.getOriginalFilename();
				}
			};
			
			fileJson.put("originalFilename", file.getOriginalFilename());
			jsonArray.add(fileJson);
			map.add("files", resource);
		}
		
		jsonObject.put("nameArray", jsonArray);
		jsonObject.put("offset", userInfo.getOffset());
		jsonObject.put("userId", userInfo.getId());
		jsonObject.put("lang", userInfo.getLang());
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
		}
		else {
			return "";
		}
		
		logger.debug("Upload file finishes!");
		
		return listFileVO.toString();
	}

	@RequestMapping(value="/ezWebFolder/downloadAttach.do", produces="application/zip")
	public void downloadAttach(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("Download attach is running!");
		
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		String listFileId  = request.getParameter("fileList");
		String gwServerUrl = config.getProperty("config.webfolderGwServerURL");
		String url         = gwServerUrl + "/rest/ezwebfolder/filemanage/file-download";
		
		UriComponentsBuilder builder  = UriComponentsBuilder.fromHttpUrl(url)
										.queryParam("offset", user.getOffset())
										.queryParam("userId", user.getId())
										.queryParam("lang", user.getLang())
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
	public void deleteFile(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("Delete File is running!");
		
		LoginSimpleVO user  = commonUtil.userInfoSimple(loginCookie);
		String listFileId   = request.getParameter("fileList");
		String gwServerUrl  = config.getProperty("config.webfolderGwServerURL");
		String url          = gwServerUrl + "/rest/ezwebfolder/file-delete";
		
		UriComponentsBuilder builder  = UriComponentsBuilder.fromHttpUrl(url)
										.queryParam("tenantId", user.getTenantId())
										.queryParam("offset", user.getOffset())
										.queryParam("userId", user.getId())
										.queryParam("lang", user.getLang())
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
		
		logger.debug("Status: " + status);
		logger.debug("Delete File finishes!");
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
		String gwServerUrl  = config.getProperty("config.webfolderGwServerURL");
		String url          = gwServerUrl + "/rest/ezwebfolder/file-rename/fileid/" + fileId;
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
										.queryParam("tenantId", user.getTenantId())
										.queryParam("offset", user.getOffset())
										.queryParam("userId", user.getId())
										.queryParam("lang", user.getLang())
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
		String fileId      = request.getParameter("fileId")     != null ? request.getParameter("fileId")     : "";
		String rootFolder  = request.getParameter("rootFolder") != null ? request.getParameter("rootFolder") : "";
		
		if (fileId.equals("")) {
			logger.debug("File Move Confirm illegal arguments!");
			return "cmm/error/egovError";
		}
		
		model.addAttribute("fileId", fileId);
		model.addAttribute("rootFolder", rootFolder);
		model.addAttribute("primary", user.getLang());
		logger.debug("File Move Confirm finishes!");
		
		return "/ezWebFolder/fileMove";
	}

	@RequestMapping(value="/ezWebFolder/moveFile.do", method = RequestMethod.POST)
	public void moveFile(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("Move File is running!");
		
		LoginSimpleVO user  = commonUtil.userInfoSimple(loginCookie);
		String fileId       = request.getParameter("fileId");
		String folderId     = request.getParameter("folderId");
		String mode         = request.getParameter("mode");
		
		String gwServerUrl  = config.getProperty("config.webfolderGwServerURL");
		String url          = gwServerUrl + "/rest/ezwebfolder/filemove/fileid/" + fileId + "/modes/" + mode;
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
										.queryParam("tenantId", user.getTenantId())
										.queryParam("offset", user.getOffset())
										.queryParam("userId", user.getId())
										.queryParam("lang", user.getLang())
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
		
		logger.debug("Status: " + status);
		logger.debug("Move File finishes!");
	}

	@RequestMapping(value="/ezWebFolder/getFolderTree.do", method = RequestMethod.POST)
	public String getFolderTree(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		String rootFolder  = request.getParameter("rootFolder") != null ? request.getParameter("rootFolder") : "";
		String fileId      = request.getParameter("fileId")     != null ? request.getParameter("fileId")     : "";
		String folderId    = request.getParameter("folderId")   != null ? request.getParameter("folderId")   : "";
		
		String gwServerUrl = config.getProperty("config.webfolderGwServerURL");
		String url         = gwServerUrl + "/rest/ezwebfolder/foldersTree";
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("host-name", request.getServerName());
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
										.queryParam("rootFolder", rootFolder)
										.queryParam("fileId", fileId)
										.queryParam("folderId", folderId)
										.queryParam("offset", user.getOffset());
		
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		String status                 = resultBody.get("status").toString();
		
		if (status.equals("ok")) {
			String currFolder = (String)resultBody.get("currentFolder");
			
			if (!fileId.equals("") || !rootFolder.equals("")) {
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
		String gwServerUrl = config.getProperty("config.webfolderGwServerURL");
		String url         = gwServerUrl + "/rest/ezwebfolder/depart-tree";
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("host-name", request.getServerName());
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
										.queryParam("userId", user.getId())
										.queryParam("primary", user.getLang())
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
		String gwServerUrl = config.getProperty("config.webfolderGwServerURL");
		String url         = gwServerUrl + "/rest/ezwebfolder/sub-tree/" + deptId;
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("host-name", request.getServerName());
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
										.queryParam("primary", user.getLang())
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

	@RequestMapping(value="/ezWebFolder/shareUsersSelect.do")
	public String selectShareUsers(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("select share users is running!");
		
		LoginSimpleVO user   = commonUtil.userInfoSimple(loginCookie);
		String gwServerUrl   = config.getProperty("config.webfolderGwServerURL");
		String url           = gwServerUrl + "/rest/ezwebfolderadmin/company-id/" + user.getId();
		
		HttpHeaders headers  = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("host-name", request.getServerName());
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder  = UriComponentsBuilder.fromHttpUrl(url)
										.queryParam("offset", user.getOffset())
										.queryParam("lang", user.getLang());
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		String status                 = resultBody.get("status").toString();
		
		if (status.equals("ok")) {
			String companyId = (String) resultBody.get("data");
			model.addAttribute("pCompanyID", companyId);
			model.addAttribute("primary", user.getLang());
		}
		
		logger.debug("select share users finishes!");
		return "/ezWebFolder/shareUsersSelect";
	}
	
	@RequestMapping(value="/ezWebFolder/getDeptMembers.do", method = RequestMethod.POST)
	public String getDeptMembers(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		String deptId      = request.getParameter("deptId");
		String gwServerUrl = config.getProperty("config.webfolderGwServerURL");
		String url         = gwServerUrl + "/rest/ezwebfolder/dept-member/" + deptId;
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("host-name", request.getServerName());
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
										.queryParam("primary", user.getLang());
		
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
	
}