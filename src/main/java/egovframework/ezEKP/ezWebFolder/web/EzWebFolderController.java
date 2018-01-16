package egovframework.ezEKP.ezWebFolder.web;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.nio.charset.Charset;
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

import org.apache.commons.lang3.StringUtils;
import org.codehaus.jackson.map.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderService;
import egovframework.ezEKP.ezWebFolder.vo.FileVO;
import egovframework.let.user.login.vo.LoginSimpleVO;
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
	
	private static final Logger logger = LoggerFactory.getLogger(EzWebFolderController.class);	
	
	@RequestMapping(value = "/ezWebFolder/webfolderMain.do")
	public String webfolderMain(HttpServletRequest req, Model model) {
/*		String func = "";
		String subFunc = "";

		if (req.getParameter("func") != null && !req.getParameter("func").equals("")) {
			func = req.getParameter("func");	
		}
		if (req.getParameter("subFunc") != null && !req.getParameter("subFunc").equals("")) {
			subFunc = req.getParameter("subFunc");	
		}
		
		model.addAttribute("func", func);
		model.addAttribute("subFunc", subFunc);*/
		
		return "ezWebFolder/webfolderMain";
	}
	
	@RequestMapping(value="/ezWebFolder/webfolderLeft.do")
	public String webfolderLeft(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, ModelMap modelMap, LoginVO userInfo, HttpServletResponse response) throws Exception{       
        userInfo = commonUtil.userInfo(loginCookie);
        //Add more function here
        
        
		return "ezWebFolder/webfolderLeft";
	}
	
	@RequestMapping(value="/ezWebFolder/test.do")
	public String webfolderTest(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, ModelMap modelMap, LoginVO userInfo, HttpServletResponse response) throws Exception{       
        userInfo = commonUtil.userInfo(loginCookie);
        //Add more function here
        
        
		return "ezWebFolder/webfolderTest";
	}
	
	@RequestMapping(value = "/ezWebFolder/uploadFile.do")
	@ResponseBody
	public String uploadFile(MultipartHttpServletRequest request, @CookieValue("loginCookie") String loginCookie, HttpServletResponse response) throws Exception {		
		logger.debug("Upload file is running!");		
		LoginVO user = commonUtil.userInfo(loginCookie);		
		List<MultipartFile> multiFile = request.getFiles("fileToUpload");
		String folderId = request.getParameter("folderId"); //baonk 2018/01/16
		int cnt = multiFile.size();
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
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
            		String iconUrl = ezWebFolderService.getFileIconFromExt(extend, user.getTenantId());
            		Date date = new Date();
            		FileVO fileVO = new FileVO();
            		
            		fileVO.setCreatedDate(formatter.format(date));
            		fileVO.setUpdatedDate(fileVO.getCreatedDate());
            		fileVO.setFileExt(extend);
            		fileVO.setFileName(pFileName[i]);
            		fileVO.setFileFavourite("0");
            		fileVO.setFilePath(getWebFolderDirPath(user.getTenantId()) + pFileName[i]);
            		fileVO.setFileSize(getFileSize(fileSize[i]));
            		fileVO.setFolderId(folderId);
            		fileVO.setTenantId(user.getTenantId());
            		fileVO.setUploaderId(user.getId());          		            		
            		fileVO.setFileIconUrl(iconUrl);
            		fileVO.setFileShareStatus("0");
            		
            		if (user.getPrimary().equals("1")) {
            			fileVO.setUploaderName(user.getDisplayName1());
            		}
            		else {
            			fileVO.setUploaderName(user.getDisplayName2());
            		}
            		
            		fileVO.setFileId(getMaxFileID(user.getTenantId()));
            		
            		ezWebFolderService.insertFile(fileVO);
            		list.add(fileVO);            		
            	}
            	catch (Exception e) {
            		e.printStackTrace();            		
            	}			
            }
        }

        logger.debug("Upload file finishes!");        
            
        return om.writeValueAsString(list);
    }
	
	@RequestMapping(value="/ezWebFolder/downloadAttach.do")
	public void downloadAttach(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("Download attach is running!");	
		LoginSimpleVO loginSimpleVO = commonUtil.userInfoSimple(loginCookie);
		String listFileId = request.getParameter("fileList");
		
		logger.debug("FileList: " + listFileId);
		
		String[] fileIDList = listFileId.split(",");	
		List<File> fileList = new ArrayList<File>();
	
		logger.debug("FileList length: " + fileIDList.length);
		
		if (fileIDList.length <= 0) {
			logger.debug("downloadAttach illegal arguments!");
			return;
		}
				
        //Get absolute path of the application       
        String realPath = request.getServletContext().getRealPath("");
		
		for (int i = 0; i < fileIDList.length; i++) {
			FileVO fileVO = ezWebFolderService.getFileByFileId(fileIDList[i], loginSimpleVO.getTenantId());
			File f = new File(realPath + fileVO.getFilePath());
			fileList.add(f);			
		}
		
		String guid = UUID.randomUUID().toString();
		String tempFileUploadPath = realPath + getWebFolderDirPath(loginSimpleVO.getTenantId()) + commonUtil.separator + "tempFileUpload";
		
		File tempF = new File(tempFileUploadPath);
		if (!tempF.exists()) {
			tempF.mkdirs();
		}
		
		String pDirTempPath = tempFileUploadPath + commonUtil.separator + guid;
		
		ZipOutputStream zos = null;
		FileInputStream fis = null;
		
		try {
			
			File tempFile = new File(pDirTempPath + ".zip");
			if (tempFile.exists()) {
				tempFile.delete();
			}
			
			zos = new ZipOutputStream(new FileOutputStream(pDirTempPath + ".zip"), Charset.forName("UTF-8"));
			
			for (File file : fileList) {
				if (!file.isDirectory()) {
					fis = new FileInputStream(file);
					
					//String zipFilePath = file.getPath().substring(dirPath.length() + 1, file.getPath().length());
					String zipFilePath = file.getName();			
					ZipEntry zipEntry = new ZipEntry(zipFilePath);
					zos.putNextEntry(zipEntry);

					byte[] bytes = new byte[BUFF_SIZE];
					int length;
					
					while ((length = fis.read(bytes)) >= 0) {
						zos.write(bytes, 0, length);
					}

					zos.closeEntry();
					fis.close();
				}
			}
			
			fis = null;
			
			zos.close();
			zos = null;
		} catch (Exception e) {
			throw e;
			
		} finally {
			if (fis != null) {
				try { fis.close(); } catch (Exception e) {}
			}
			
			if (zos != null) {
				try { zos.closeEntry(); } catch (Exception e) {}
				try { zos.close(); } catch (Exception e) {}
			}
			
		}		
		
		downFile(request, response, pDirTempPath + ".zip", guid + ".zip");	
		
		logger.debug("Download attach finishes!");	
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

	private String getWebFolderDirPath(int tenantId) {
		return commonUtil.separator + "fileroot" + commonUtil.separator + tenantId + commonUtil.separator + "webfolder" + commonUtil.separator;
	}
}
