package egovframework.ezEKP.ezWebFolder.web;

import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.FileInputStream;
import java.io.Reader;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Base64;
import java.util.Collections;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Properties;
import java.util.UUID;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;
import java.util.Map;
import java.io.InputStreamReader;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.IOUtils;
import org.codehaus.jackson.map.ObjectMapper;
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
import org.springframework.http.converter.FormHttpMessageConverter;
import org.springframework.http.converter.HttpMessageConverter;
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.util.FileCopyUtils;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.HttpMessageConverterExtractor;
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
import egovframework.ezEKP.ezWebFolder.vo.FileLogVO;
import egovframework.ezEKP.ezWebFolder.vo.FileTypeVO;
import egovframework.ezEKP.ezWebFolder.vo.FileVO;
import egovframework.ezEKP.ezWebFolder.vo.FolderSimpleVO;
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
        //Add more function here
		return "ezWebFolder/webfolderLeft";
	}
	
	@RequestMapping(value="/ezWebFolder/test.do")
	public String webfolderTest(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, LoginVO userInfo, HttpServletResponse response) throws Exception{       
        userInfo = commonUtil.userInfo(loginCookie);
        //Add more function here
        
        model.addAttribute("primary", userInfo.getPrimary());
		return "ezWebFolder/webfolderTest";
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ezWebFolder/uploadFile.do")
	@ResponseBody
	public String uploadFile2(MultipartHttpServletRequest request, @CookieValue("loginCookie") String loginCookie, HttpServletResponse response) throws Exception {
		logger.debug("Upload file is running!");
		
		LoginVO userInfo               = commonUtil.userInfo(loginCookie);
		List<MultipartFile> multiFiles = request.getFiles("fileToUpload");
		String folderId                = request.getParameter("folderId"); 	    	
		String gwServerUrl             = config.getProperty("config.webfolderGwServerURL");
		String url                     = gwServerUrl + "/webfolder/filemanage/fileupload";
		
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
		String url          = gwServerUrl + "/webfolder/filemanage/filedownload";

		UriComponentsBuilder builder  = UriComponentsBuilder.fromHttpUrl(url)
										.queryParam("tenantId", user.getTenantId())
										.queryParam("offset", user.getOffset())
										.queryParam("userId", user.getId())
										.queryParam("userName1", user.getDisplayName1())
										.queryParam("userName2", user.getDisplayName2())
										.queryParam("companyId", user.getCompanyID())
										.queryParam("fileList", listFileId);
		
		RestTemplate rest          		= new RestTemplate();		
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
		String offset = user.getOffset();
		String listFileId = request.getParameter("fileList") != null ? request.getParameter("fileList") : "";
		String[] fileIDList = listFileId.split(",");
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date date = new Date();	
		String timeUTC = commonUtil.getDateStringInUTC(formatter.format(date), user.getOffset(), true);
		
		if (fileIDList.length <= 0) {
			logger.debug("Delete File illegal arguments!");
			return ;
		}
		
		logger.debug("Number of delete files: " + fileIDList.length);
		
		//Delete files in database
		try {
			for (int i = 0; i < fileIDList.length; i++) {
				FileVO fileVO = ezWebFolderService.getFileByFileId(fileIDList[0], offset, user.getTenantId());
				FileTypeVO fileType = ezWebFolderService.getFileTypeByFileExt(fileVO.getFileExt(), user.getTenantId());
				//ezWebFolderService.deleteFileByFileId(fileIDList[i], loginSimpleVO.getTenantId());
				ezWebFolderService.updateFileUseStatus(fileIDList[i], user.getTenantId());
				
				//Save log to database				
				FileLogVO fileLog = new FileLogVO();
				
				fileLog.setLogType("R");
				fileLog.setCompanyId(user.getCompanyID());
				fileLog.setCreateDate(timeUTC);
				fileLog.setCreateId(user.getId());
				fileLog.setCreateName1(user.getDisplayName1());
				fileLog.setCreateName2(user.getDisplayName2());
				fileLog.setFileName(fileVO.getFileName());
				fileLog.setFileSize(fileVO.getFileSize());
				fileLog.setFileExt(fileVO.getFileExt());
				fileLog.setFileType(fileType.getTypeName());
				fileLog.setLogId(getMaxLogID(user.getTenantId()));
				fileLog.setTenantId(user.getTenantId());
				
				ezWebFolderAdminService.insertFileLog(fileLog);
			}
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		
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
		LoginVO user = commonUtil.userInfo(loginCookie);
		String offset = user.getOffset();
		String fileId = request.getParameter("fileId") != null ? request.getParameter("fileId") : "";
		String newName = request.getParameter("newName") != null ? request.getParameter("newName") : "";
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date date = new Date();	
		String timeUTC = commonUtil.getDateStringInUTC(formatter.format(date), user.getOffset(), true);
		
		if (fileId.equals("")) {
			logger.debug("File Rename Confirm illegal arguments!");
			return;
		}
		
		//Update file in database
		try {
			FileVO fileVO = ezWebFolderService.getFileByFileId(fileId, offset, user.getTenantId());
			FileTypeVO fileType = ezWebFolderService.getFileTypeByFileExt(fileVO.getFileExt(), user.getTenantId());
			String fileExt = fileVO.getFileExt();
			ezWebFolderService.updateFileName(fileId, newName + "." + fileExt, user.getTenantId());
			
			//Save log to database
			FileLogVO fileLog = new FileLogVO();			
			
			fileLog.setLogType("U");
			fileLog.setCompanyId(user.getCompanyID());
			fileLog.setCreateDate(timeUTC);
			fileLog.setCreateId(user.getId());
			fileLog.setCreateName1(user.getDisplayName1());
			fileLog.setCreateName2(user.getDisplayName2());
			fileLog.setFileName(fileVO.getFileName());
			fileLog.setFileSize(fileVO.getFileSize());
			fileLog.setFileExt(fileVO.getFileExt());
			fileLog.setFileType(fileType.getTypeName());
			fileLog.setLogId(getMaxLogID(user.getTenantId()));
			fileLog.setTenantId(user.getTenantId());
			
			ezWebFolderAdminService.insertFileLog(fileLog);
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		
		logger.debug("Rename File finishes!");		
	}
	
	@RequestMapping(value="/ezWebFolder/fileMoveConfirm.do")
	public String fileMoveConfirm(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		logger.debug("File Move Confirm is running!");		
		String fileId = request.getParameter("fileId") != null ? request.getParameter("fileId") : "";
		
		if (fileId.equals("")) {
			logger.debug("File Move Confirm illegal arguments!");
			return "cmm/error/egovError";
		}
		
		model.addAttribute("fileId", fileId);
		logger.debug("File Move Confirm finishes!");
		
		return "/ezWebFolder/fileMoveTest";		
	}
	
	@RequestMapping(value="/ezWebFolder/moveFile.do", method = RequestMethod.POST)	
	public void moveFile(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("Move File is running!");	
		LoginVO user = commonUtil.userInfo(loginCookie);
		String offset = user.getOffset();
		String fileId 	= request.getParameter("fileId")   != null ? request.getParameter("fileId")   : "";
		String folderId = request.getParameter("folderId") != null ? request.getParameter("folderId") : "";
		String mode 	= request.getParameter("mode")     != null ? request.getParameter("mode")     : "";
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date date = new Date();	
		String timeUTC = commonUtil.getDateStringInUTC(formatter.format(date), user.getOffset(), true);
		
		if (fileId.equals("") || folderId.equals("") || mode.equals("")) {
			logger.debug("Move File illegal arguments!");
			return;
		}
		
		//Update file in database
		try {
			FileVO fileVO = ezWebFolderService.getFileByFileId(fileId, offset, user.getTenantId());
			FileTypeVO fileType = ezWebFolderService.getFileTypeByFileExt(fileVO.getFileExt(), user.getTenantId());
			
			if (mode.equals("move")) {
				ezWebFolderService.moveFile(fileId, folderId, user.getTenantId());
			}
			else {				
				fileVO.setFolderId(folderId);				
				fileVO.setFileId(getMaxFileID(user.getTenantId()));
				fileVO.setCreateDate(commonUtil.getDateStringInUTC(fileVO.getCreateDate(), offset, true));
				fileVO.setUpdateDate(commonUtil.getDateStringInUTC(fileVO.getUpdateDate(), offset, true));
				ezWebFolderService.insertFile(fileVO);
			}
			
			//Save log to database
			FileLogVO fileLog = new FileLogVO();			
			
			fileLog.setLogType("U");
			fileLog.setCompanyId(user.getCompanyID());
			fileLog.setCreateDate(timeUTC);
			fileLog.setCreateId(user.getId());
			fileLog.setCreateName1(user.getDisplayName1());
			fileLog.setCreateName2(user.getDisplayName2());
			fileLog.setFileName(fileVO.getFileName());
			fileLog.setFileSize(fileVO.getFileSize());
			fileLog.setFileExt(fileVO.getFileExt());
			fileLog.setFileType(fileType.getTypeName());
			fileLog.setLogId(getMaxLogID(user.getTenantId()));
			fileLog.setTenantId(user.getTenantId());
			
			ezWebFolderAdminService.insertFileLog(fileLog);
			
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		
		logger.debug("Move File finishes!");		
	}
	
	@RequestMapping(value="/ezWebFolder/getFolderList.do", method = RequestMethod.POST)	
	public String getFolderList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception {     			
		LoginVO userInfo   = commonUtil.userInfo(loginCookie);
		String offset	   = userInfo.getOffset();
		String folderId    = request.getParameter("folderId");
		String folderType  = request.getParameter("folderType");
		
		//FolderVO folderVO = ezWebFolderService.getFolderByFolderId(folderId, offset, userInfo.getTenantId());
		switch(folderType) {
			case "1":
				if (userInfo.getRollInfo().indexOf("c=1") == -1) {
					FolderSimpleVO folderList = ezWebFolderService.getSimpleFolder(folderId, userInfo.getTenantId());
					model.addAttribute("folderList", folderList);
				}
				else {
					List<FolderSimpleVO> companyFolderList = ezWebFolderService.getAllSimpleSubFolders("root", userInfo.getTenantId());
					
					for (FolderSimpleVO company: companyFolderList) {
						ezWebFolderService.getAllSubDepts(company, userInfo.getTenantId(), 0);						
					}		
					
					model.addAttribute("folderList", companyFolderList);
				}
				
				break;
			case "2":
				break;
			case "3":
				break;
		}	

		return "json";
	}	

	/*private String getFileSize(long fileSize) {
		String fileSize_ = "";
		
        if (fileSize / 1024 / 1024 >= 1) {
        	fileSize_ = String.format("%.2f", (double)(fileSize / 1024 / 1024 * 10) / 10);
        	fileSize_ = fileSize_ + "MB";
        }
        else if (fileSize / 1024 >= 1) {
        	fileSize_ = String.format("%.2f", (double)(fileSize / 1024));
        	fileSize_ = fileSize_ + "KB";
        }
        else {
        	fileSize_ = fileSize + "B";
        }
        
        return fileSize_;
	}*/
	
	private String getMaxFileID(int tenantId) throws Exception {
		int currentMaxFileId = -1;
		String result = ezWebFolderService.getFileSequence(tenantId);
		
		if (result.equals("")) {
			currentMaxFileId = 1;
		} 
		else {
			currentMaxFileId = Integer.parseInt(result);			
		}
		
		if (currentMaxFileId == -1) {
			currentMaxFileId = 1;
		}
		else {
			currentMaxFileId += 1;
		}

		return Integer.toString(currentMaxFileId);
	}
	
	private String getMaxLogID(int tenantId) throws Exception {
		int currentMaxLogId = -1;
		String result = ezWebFolderService.getFileLogSequence(tenantId);
		
		if (result.equals("")) {
			currentMaxLogId = 1;
		} 
		else {
			currentMaxLogId = Integer.parseInt(result);			
		}
		
		if (currentMaxLogId == -1) {
			currentMaxLogId = 1;
		}
		else {
			currentMaxLogId += 1;
		}

		return Integer.toString(currentMaxLogId);
	}
}
