package egovframework.ezEKP.ezWebFolder.web;

import java.io.File;
import java.io.FileInputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Properties;
import java.util.UUID;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.compress.utils.IOUtils;
import org.apache.commons.lang3.StringUtils;
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
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
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
	
	@RequestMapping(value = "/ezWebFolder/uploadFile.do")
	@ResponseBody
	public String uploadFile(MultipartHttpServletRequest request, @CookieValue("loginCookie") String loginCookie, HttpServletResponse response) throws Exception {		
		logger.debug("Upload file is running!");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		List<MultipartFile> multiFiles = request.getFiles("fileToUpload");
		String folderId = request.getParameter("folderId");		
	    
	    MultiValueMap<String, Object> map = new LinkedMultiValueMap<String, Object>(); 
	    for(MultipartFile file : multiFiles) { 
	        ByteArrayResource resource = new ByteArrayResource(file.getBytes()) { 
	            @Override 
	            public String getFilename() { 
	                return file.getOriginalFilename();
	            } 
	        }; 
	        map.add("files", resource);
	    }	    
	    
	    String gwServerUrl = config.getProperty("config.webfolderGwServerURL");
		String url = gwServerUrl + "/webfolder/filemanage/fileupload";
				
		HttpHeaders headers = new HttpHeaders();	
		headers.add("Accept","application/json");		 
		headers.setContentType(MediaType.MULTIPART_FORM_DATA);
	    HttpEntity<MultiValueMap<String, Object>> entity = new HttpEntity<MultiValueMap<String, Object>>(map, headers);
	    
	    UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
	    		.queryParam("tenantId", userInfo.getTenantId())
				.queryParam("offset", userInfo.getOffset())
				.queryParam("userId", userInfo.getId())
				.queryParam("userName1", userInfo.getDisplayName1())
				.queryParam("userName2", userInfo.getDisplayName2())
				.queryParam("folderId", folderId)
				.queryParam("companyId", userInfo.getCompanyID());
		RestTemplate rest = new RestTemplate();		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.POST, entity, String.class);
		
		JSONParser jp = new JSONParser();		
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());				
		String status = resultBody.get("status").toString();
		JSONArray listFileVO = null;
		
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
		LoginVO user = commonUtil.userInfo(loginCookie);	
		String offset = user.getOffset();
		String listFileId = request.getParameter("fileList");	
		String[] fileIDList = listFileId.split(",");
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date date = new Date();	
		String timeUTC = commonUtil.getDateStringInUTC(formatter.format(date), user.getOffset(), true);
		
		if (fileIDList.length <= 0) {
			logger.debug("downloadAttach illegal arguments!");
			return;
		}		
		
        //Get absolute path of the application       
        String realPath = request.getServletContext().getRealPath("");
        String guid = UUID.randomUUID().toString();
        String fileName = guid + ".zip";
		
		if (fileIDList.length > 1) {
			ZipOutputStream zipOutputStream = null;
			FileInputStream fileInputStream = null;
			
			try {
				//Setting headers  
			    response.setStatus(HttpServletResponse.SC_OK);
			    response.addHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");	
			    zipOutputStream = new ZipOutputStream(response.getOutputStream());
			    
			    //Package files
			    for (int i = 0; i < fileIDList.length; i++) {
			    	//New zip entry and copying input stream with file to zipOutputStream, after all closing streams
			    	FileVO fileVO = ezWebFolderService.getFileByFileId(fileIDList[i], offset, user.getTenantId());
			    	FileTypeVO fileType = ezWebFolderService.getFileTypeByFileExt(fileVO.getFileExt(), user.getTenantId());
			    	File file = new File(realPath + fileVO.getFilePath());
			        zipOutputStream.putNextEntry(new ZipEntry(fileVO.getFileName()));
			        fileInputStream = new FileInputStream(file);
		
			        IOUtils.copy(fileInputStream, zipOutputStream);
		
			        fileInputStream.close();
			        zipOutputStream.closeEntry();
			        
					//Save log to database
					FileLogVO fileLog = new FileLogVO();
					
					fileLog.setLogType("D");
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
		
			    zipOutputStream.close();
			}
			catch (Exception e) {
				throw e;			
			} 
			finally {
				if (fileInputStream != null) {
					try { fileInputStream.close(); } catch (Exception e) {}
				}
				
				if (zipOutputStream != null) {
					try { zipOutputStream.closeEntry(); } catch (Exception e) {}
					try { zipOutputStream.close(); } catch (Exception e) {}
				}			
			}
		}		
		else if (fileIDList.length == 1) {
			FileVO fileVO = ezWebFolderService.getFileByFileId(fileIDList[0], offset, user.getTenantId());
			FileTypeVO fileType = ezWebFolderService.getFileTypeByFileExt(fileVO.getFileExt(), user.getTenantId());
			String _fileName = fileVO.getFileName();
			String _filePath = realPath + fileVO.getFilePath();
			
			downFile(request, response, _filePath, _fileName);			
			
			//Save log to database
			FileLogVO fileLog = new FileLogVO();
			
			fileLog.setLogType("D");
			fileLog.setCompanyId(user.getCompanyID());
			fileLog.setCreateDate(timeUTC);
			fileLog.setCreateId(user.getId());
			fileLog.setCreateName1(user.getDisplayName1());
			fileLog.setCreateName2(user.getDisplayName2());
			fileLog.setFileName(_fileName);
			fileLog.setFileSize(fileVO.getFileSize());
			fileLog.setFileExt(fileVO.getFileExt());
			fileLog.setFileType(fileType.getTypeName());
			fileLog.setLogId(getMaxLogID(user.getTenantId()));
			fileLog.setTenantId(user.getTenantId());
			
			ezWebFolderAdminService.insertFileLog(fileLog);
		}
		
		
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
