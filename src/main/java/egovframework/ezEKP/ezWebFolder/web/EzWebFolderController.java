package egovframework.ezEKP.ezWebFolder.web;

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
import egovframework.let.user.login.vo.LoginVO;
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
	public String webfolderLeft(@CookieValue("loginCookie") String loginCookie,ModelMap modelMap, HttpServletRequest request, Model model, LoginVO userInfo, HttpServletResponse response) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		return "ezWebFolder/webfolderLeft";
	}

	@RequestMapping(value="/ezWebFolder/test.do")
	public String webfolderTest(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, LoginVO userInfo, HttpServletResponse response) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		model.addAttribute("primary", userInfo.getPrimary());
		return "ezWebFolder/webfolderTest";
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ezWebFolder/uploadFile.do")
	@ResponseBody
	public String uploadFile(MultipartHttpServletRequest request, @CookieValue("loginCookie") String loginCookie, HttpServletResponse response) throws Exception {
		logger.debug("Upload file is running!");
		
		LoginVO userInfo               = commonUtil.userInfo(loginCookie);
		List<MultipartFile> multiFiles = request.getFiles("fileToUpload");
		String folderId                = request.getParameter("folderId");
		String gwServerUrl             = config.getProperty("config.webfolderGwServerURL");
		String url                     = gwServerUrl + "/webfolder/filemanage/file-upload";
		
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
		jsonObject.put("tenantId", userInfo.getTenantId());
		jsonObject.put("offset", userInfo.getOffset());
		jsonObject.put("userId", userInfo.getId());
		jsonObject.put("userName1", userInfo.getDisplayName1());
		jsonObject.put("userName2", userInfo.getDisplayName2());
		jsonObject.put("folderId", folderId);
		jsonObject.put("companyId", userInfo.getCompanyID());
		
		map.add("data", jsonObject);
		
		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.MULTIPART_FORM_DATA);
		
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
		
		LoginVO user        = commonUtil.userInfo(loginCookie);
		String listFileId   = request.getParameter("fileList");
		String gwServerUrl  = config.getProperty("config.webfolderGwServerURL");
		String url          = gwServerUrl + "/webfolder/filemanage/file-download";
		
		UriComponentsBuilder builder  = UriComponentsBuilder.fromHttpUrl(url)
										.queryParam("tenantId", user.getTenantId())
										.queryParam("offset", user.getOffset())
										.queryParam("userId", user.getId())
										.queryParam("userName1", user.getDisplayName1())
										.queryParam("userName2", user.getDisplayName2())
										.queryParam("companyId", user.getCompanyID())
										.queryParam("fileList", listFileId);
		
		RestTemplate rest               = new RestTemplate();
		RequestCallback requestCallback = req -> req.getHeaders().setAccept(Arrays.asList(MediaType.APPLICATION_OCTET_STREAM, MediaType.ALL));
		
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
		
		return "/ezWebFolder/fileDeleteTest";
	}

	@RequestMapping(value="/ezWebFolder/deleteFile.do", method = RequestMethod.POST)
	public void deleteFile(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("Delete File is running!");
		LoginVO user = commonUtil.userInfo(loginCookie);
		
		String listFileId   = request.getParameter("fileList");
		String gwServerUrl  = config.getProperty("config.webfolderGwServerURL");
		String url          = gwServerUrl + "/webfolder/file-delete";
		
		UriComponentsBuilder builder  = UriComponentsBuilder.fromHttpUrl(url)
										.queryParam("tenantId", user.getTenantId())
										.queryParam("offset", user.getOffset())
										.queryParam("userId", user.getId())
										.queryParam("userName1", user.getDisplayName1())
										.queryParam("userName2", user.getDisplayName2())
										.queryParam("companyId", user.getCompanyID())
										.queryParam("fileList", listFileId);
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		RestTemplate rest    = new RestTemplate();
		
		rest.exchange(builder.build().encode().toUri(), HttpMethod.DELETE, entity, String.class);
		
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
		
		return "/ezWebFolder/fileRenameTest";
	}

	@RequestMapping(value="/ezWebFolder/renameFile.do", method = RequestMethod.POST)
	public void renameFile(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("Rename File is running!");
		LoginVO user        = commonUtil.userInfo(loginCookie);
		String fileId       = request.getParameter("fileId");
		String newName      = request.getParameter("newName");
		String gwServerUrl  = config.getProperty("config.webfolderGwServerURL");
		String url          = gwServerUrl + "/webfolder/file-rename/fileid/" + fileId;
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
										.queryParam("tenantId", user.getTenantId())
										.queryParam("offset", user.getOffset())
										.queryParam("userId", user.getId())
										.queryParam("userName1", user.getDisplayName1())
										.queryParam("userName2", user.getDisplayName2())
										.queryParam("companyId", user.getCompanyID())
										.queryParam("newName", newName);
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		RestTemplate rest    = new RestTemplate();
		
		rest.exchange(builder.build().encode().toUri(), HttpMethod.PUT, entity, String.class);
		
		logger.debug("Rename File finishes!");
	}

	@RequestMapping(value="/ezWebFolder/fileMoveConfirm.do")
	public String fileMoveConfirm(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		logger.debug("File Move Confirm is running!");
		String fileId     = request.getParameter("fileId")     != null ? request.getParameter("fileId")     : "";
		String rootFolder = request.getParameter("rootFolder") != null ? request.getParameter("rootFolder") : "";
		
		if (fileId.equals("")) {
			logger.debug("File Move Confirm illegal arguments!");
			return "cmm/error/egovError";
		}
		
		model.addAttribute("fileId", fileId);
		model.addAttribute("rootFolder", rootFolder);
		logger.debug("File Move Confirm finishes!");
		
		return "/ezWebFolder/fileMoveTest";
	}

	@RequestMapping(value="/ezWebFolder/moveFile.do", method = RequestMethod.POST)
	public void moveFile(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("Move File is running!");
		LoginVO user        = commonUtil.userInfo(loginCookie);
		String fileId       = request.getParameter("fileId");
		String folderId     = request.getParameter("folderId");
		String mode         = request.getParameter("mode");
		
		String gwServerUrl  = config.getProperty("config.webfolderGwServerURL");
		String url          = gwServerUrl + "/webfolder/filemove/fileid/" + fileId + "/modes/" + mode;
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
										.queryParam("tenantId", user.getTenantId())
										.queryParam("offset", user.getOffset())
										.queryParam("userId", user.getId())
										.queryParam("userName1", user.getDisplayName1())
										.queryParam("userName2", user.getDisplayName2())
										.queryParam("companyId", user.getCompanyID())
										.queryParam("folderId", folderId);
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		RestTemplate rest    = new RestTemplate();
		
		rest.exchange(builder.build().encode().toUri(), HttpMethod.PUT, entity, String.class);
		
		logger.debug("Move File finishes!");
	}

	@RequestMapping(value="/ezWebFolder/getFolderTree.do", method = RequestMethod.POST)
	public String getFolderTree(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {
		LoginVO userInfo   = commonUtil.userInfo(loginCookie);
		String rootFolder  = request.getParameter("rootFolder");
		String fileId      = request.getParameter("fileId") != null ? request.getParameter("fileId") : "";
		
		String gwServerUrl = config.getProperty("config.webfolderGwServerURL");
		String url         = gwServerUrl + "/webfolder/foldersTree";
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
										.queryParam("tenantId", userInfo.getTenantId())
										.queryParam("primary", userInfo.getPrimary())
										.queryParam("rootFolder", rootFolder)
										.queryParam("fileId", fileId)
										.queryParam("offset", userInfo.getOffset());
		
		RestTemplate rest             = new RestTemplate();
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = (JSONObject) jp.parse(result.getBody());
		String status                 = resultBody.get("status").toString();
		
		if (status.equals("ok")) {
			JSONObject folderTree = (JSONObject) resultBody.get("data");
			String     currFolder = (String)resultBody.get("currentFolder");
			
			if (!currFolder.equals("")) {
				model.addAttribute("currentFolder", currFolder);
			}
			model.addAttribute("folderTree", folderTree);
		}
		
		return "json";
	}
}