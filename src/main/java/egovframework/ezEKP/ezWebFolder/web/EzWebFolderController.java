package egovframework.ezEKP.ezWebFolder.web;

import java.io.File;
import java.io.FileInputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
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
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderAdminService;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderService;
import egovframework.ezEKP.ezWebFolder.vo.FileLogVO;
import egovframework.ezEKP.ezWebFolder.vo.FileTypeVO;
import egovframework.ezEKP.ezWebFolder.vo.FileVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Controller
public class EzWebFolderController extends EgovFileMngUtil {
	
	@Autowired
	private CommonUtil commonUtil;
	
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
        
        
		return "ezWebFolder/webfolderLeft";
	}
	
	@RequestMapping(value = "/ezWebFolder/uploadFile.do")
	@ResponseBody
	public String uploadFile(MultipartHttpServletRequest request, @CookieValue("loginCookie") String loginCookie, HttpServletResponse response) throws Exception {		
		logger.debug("Upload file is running!");		
		LoginVO user = commonUtil.userInfo(loginCookie);		
		List<MultipartFile> multiFile = request.getFiles("fileToUpload");
		String folderId = request.getParameter("folderId"); //baonk 2018/01/16
		int cnt = multiFile.size();
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String realPath = request.getServletContext().getRealPath("");
		String[] pFileName = new String[cnt];
        Long[] fileSize = new Long[cnt];
        String useExtension = ezCommonService.getTenantConfig("USE_FileExtension", user.getTenantId());
        ObjectMapper om = new ObjectMapper();

        if (StringUtils.isNotEmpty(multiFile.get(0).getOriginalFilename()) && StringUtils.isNotBlank(multiFile.get(0).getOriginalFilename())) {        	
            for (int i = 0; i < cnt; i++) {
                String _pFileName = multiFile.get(i).getOriginalFilename();
                
                if (_pFileName.indexOf(commonUtil.separator) > 0) {
                    _pFileName = _pFileName.split("/")[_pFileName.split("/").length - 1];
                }
                
                pFileName[i] = _pFileName;
            }
        }      
        
        String pDirPath = getWebFolderDirPath(user.getTenantId());        		
        pDirPath = realPath + pDirPath;
        
        if (!pDirPath.substring(pDirPath.length() - 1).equals(commonUtil.separator)) {
        	pDirPath = pDirPath + commonUtil.separator;
        }
        
        File file = new File(pDirPath);

        if (!file.exists()) {
        	file.mkdir();        
        }

        List<FileVO> list = new ArrayList<FileVO>();
        
        for (int i = 0; i < cnt; i++) {        	
        	fileSize[i] = multiFile.get(i).getSize();
            String extend = pFileName[i].substring(pFileName[i].lastIndexOf(".") + 1);
            
            if (useExtension.toLowerCase().indexOf(extend.toLowerCase()) != -1 || useExtension.equals("*")) {   	
            	try {
            		writeUploadedFile(multiFile.get(i), pFileName[i], pDirPath);
            		//Save to database           		
            		FileTypeVO fileType = ezWebFolderService.getFileTypeByFileExt(extend, user.getTenantId());
            		Date date = new Date();
            		FileVO fileVO = new FileVO();
            		
            		String timeUTC = commonUtil.getDateStringInUTC(formatter.format(date), user.getOffset(), true);
            		
            		fileVO.setCreateDate(timeUTC);
            		fileVO.setUpdateDate(timeUTC);
            		fileVO.setFileExt(extend);
            		fileVO.setFileName(pFileName[i]);
            		fileVO.setDownloadCnt(0);
            		fileVO.setFilePath(getWebFolderDirPath(user.getTenantId()) + pFileName[i]);
            		fileVO.setFileSize(getFileSize(fileSize[i]));
            		fileVO.setFolderId(folderId);
            		fileVO.setTenantId(user.getTenantId());
            		fileVO.setCreateId(user.getId());    
            		fileVO.setUpdateId(user.getId());
            		fileVO.setFileIconUrl(fileType.getTypeIcon());
            		fileVO.setFileShareStatus("0");
            		fileVO.setUseStatus("Y");
            		fileVO.setTypeId(fileType.getTypeId());
            		fileVO.setFavouriteStatus("0");         		
            		fileVO.setCreateName1(user.getDisplayName1());
            		fileVO.setCreateName2(user.getDisplayName2());
            		fileVO.setFileId(getMaxFileID(user.getTenantId()));
            		
            		ezWebFolderService.insertFile(fileVO);
            		list.add(fileVO);
            		
            		//Save log to database
            		FileLogVO fileLog = new FileLogVO();            		
            		
            		fileLog.setLogType("C");
            		fileLog.setCompanyId(user.getCompanyID());
            		fileLog.setCreateDate(timeUTC);
            		fileLog.setCreateId(user.getId());
            		fileLog.setCreateName1(user.getDisplayName1());
            		fileLog.setCreateName2(user.getDisplayName2());
            		fileLog.setFileName(pFileName[i]);
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
            }
        }

        logger.debug("Upload file finishes!");        
            
        return om.writeValueAsString(list);
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
	
	private String getFileSize(long fileSize) {
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
	}
	
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

	private String getWebFolderDirPath(int tenantId) {
		return commonUtil.separator + "fileroot" + commonUtil.separator + tenantId + commonUtil.separator + "webfolder" + commonUtil.separator;
	}
}
