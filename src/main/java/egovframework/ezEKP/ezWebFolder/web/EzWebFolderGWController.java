package egovframework.ezEKP.ezWebFolder.web;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.TimeZone;
import java.util.UUID;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.IOUtils;
import org.apache.commons.lang3.StringUtils;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderAdminService;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderService;
import egovframework.ezEKP.ezWebFolder.vo.FileLogVO;
import egovframework.ezEKP.ezWebFolder.vo.FileTypeVO;
import egovframework.ezEKP.ezWebFolder.vo.FileVO;
import egovframework.ezEKP.ezWebFolder.vo.FolderSimpleVO;
import egovframework.ezEKP.ezWebFolder.vo.FolderUserVO;
import egovframework.ezEKP.ezWebFolder.vo.FolderVO;
import egovframework.ezEKP.ezWebFolder.vo.UserCapacityVO;
import egovframework.ezEKP.ezWebFolder.vo.WebfolderConfigVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@SuppressWarnings("unchecked")
@RestController
public class EzWebFolderGWController extends EgovFileMngUtil {
	@Resource(name = "EzWebFolderAdminService")
	private EzWebFolderAdminService ezWebFolderAdminService;
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Resource(name="EzCommonService")
	private EzCommonService ezCommonService;
	
	@Resource(name = "EzWebFolderService")
	private EzWebFolderService ezWebFolderService;
	
	@Autowired
	private EzOrganAdminService ezOrganAdminService;
	
	private static final Logger logger = LoggerFactory.getLogger(EzWebFolderGWController.class);
	
	@RequestMapping(value="/webfolderadmin/basicstorage/id/{companyid}/comp", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getBasicStorage(@PathVariable String companyid, HttpServletRequest request) {	
		int tenantId = Integer.parseInt(request.getParameter("tenantId"));
		
		logger.debug("CompanyId: " + companyid + " || tenantId: " + tenantId);
		
		JSONObject result = new JSONObject();
		
		try {			
			WebfolderConfigVO webfolderConfig = ezWebFolderAdminService.getWebfolderConfig(companyid, tenantId);						
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", webfolderConfig);
		} 
		catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		}
		
		return result;
	}
	
	@RequestMapping(value="/webfolderadmin/basicstorage/{newValue}/comp", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject putChangeBasicStorage(@PathVariable String newValue, HttpServletRequest request) {	
		int tenantId         = Integer.parseInt(request.getParameter("tenantId"));
		String uploadLimit   = request.getParameter("uploadLimit");
		String companyId     = request.getParameter("companyId");
		JSONObject result    = new JSONObject();
		
		logger.debug("New Value: " + newValue + " || tenantId: " + tenantId);		
		
		try {			
			ezWebFolderAdminService.saveConfig(newValue,  uploadLimit, companyId, tenantId);	
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "");
		} 
		catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		}
		
		return result;
	}
	
	@RequestMapping(value="/webfolderadmin/basicstorage/id/{companyid}/person", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getPersonalStorage(@PathVariable String companyid, HttpServletRequest request) {
		int totalUsers   = 0;
		int totalPages   = 0;
		int pageSize     = 10;
		int tenantId     = Integer.parseInt(request.getParameter("tenantId"));
		int currPage     = request.getParameter("currentPage") != null ? Integer.parseInt(request.getParameter("currentPage")) : 1;
		String searchStr = request.getParameter("searchStr");
		String searchOpt = request.getParameter("searchOpt");
		String primary   = request.getParameter("primary");
		int startPoint   = (currPage - 1) * pageSize;		
		
		logger.debug("CompanyId: " + companyid + " || tenantId: " + tenantId);
		
		JSONObject result = new JSONObject();
		
		try {
			List<UserCapacityVO> listUserCapacity = ezWebFolderAdminService.getListUserCapacity(companyid, searchStr, searchOpt, startPoint, pageSize, tenantId, primary);
			totalUsers	 				          = ezWebFolderAdminService.getTotalListUserCapacity(companyid, searchStr, searchOpt, startPoint, pageSize, tenantId, primary);
			totalPages 					          = (totalUsers + pageSize - 1)/pageSize;
			
			for(UserCapacityVO capacity: listUserCapacity) {
				if (capacity.getTotalUsed().equals("0")) {
					capacity.setUsedRate(0);
				}
				else {				
					double totalCapByBytes = Double.parseDouble(capacity.getTotalCapacity()) * 10737418.24;
					capacity.setUsedRate((int)(Integer.parseInt(capacity.getTotalUsed())/totalCapByBytes));
				}
			}		
					
			result.put("data", listUserCapacity);			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("totalPages", totalPages);
			result.put("totalUsers", totalUsers);			
		} 
		catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		}
		
		return result;
	}
	
	@RequestMapping(value="/webfolderadmin/basicstorage/{newValue}/person", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject putChangePersonalStorage(@PathVariable String newValue, @RequestParam("userList") List<String> userList, HttpServletRequest request) {	
		int tenantId         = Integer.parseInt(request.getParameter("tenantId"));		
		String companyId     = request.getParameter("companyId");
		logger.debug("New Value: " + newValue + " || tenantId: " + tenantId);	
		JSONObject result = new JSONObject();

		try {
			for (String userId : userList) {
				ezWebFolderAdminService.updateNewAmount(userId, newValue, companyId, tenantId);
			}
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "");
		} 
		catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		}
		
		return result;
	}
	
	@RequestMapping(value="/webfolderadmin/storagereset/person", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject putResetPersonalStorage(@RequestParam("userList") List<String> userList, HttpServletRequest request) {	
		int tenantId         = Integer.parseInt(request.getParameter("tenantId"));		
		String companyId     = request.getParameter("companyId");
		String totalAmount   = "";
			
		JSONObject result = new JSONObject();

		try {			
			WebfolderConfigVO webfolderConfig = ezWebFolderAdminService.getWebfolderConfig(companyId, tenantId);
			if (webfolderConfig != null) {
				totalAmount = webfolderConfig.getTotalLimit();
			}
			
			for (String userId : userList) {
				ezWebFolderAdminService.updateNewAmount(userId, totalAmount, companyId, tenantId);
			}		
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "");
		} 
		catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		}
		
		return result;
	}
	
	@RequestMapping(value="/webfolderadmin/filehistorylist", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getFileHistory(HttpServletRequest request) {
		String offset    = request.getParameter("offset")      != null ? request.getParameter("offset")                        : "";
		String primary   = request.getParameter("primary")     != null ? request.getParameter("primary")                       : "";		
		String companyId = request.getParameter("companyId")   != null ? request.getParameter("companyId")                     : "";
		String startDate = request.getParameter("startDate")   != null ? request.getParameter("startDate")                     : "";
		String endDate   = request.getParameter("endDate")     != null ? request.getParameter("endDate")                       : "";
		String fileExt   = request.getParameter("fileExt")     != null ? request.getParameter("fileExt")                       : "";
		String fileName  = request.getParameter("fileName")    != null ? request.getParameter("fileName")                      : "";
		String userName  = request.getParameter("userName")    != null ? request.getParameter("userName")                      : "";
		String searchChk = "1";
		int tenantId     = request.getParameter("tenantId")    != null ? Integer.parseInt(request.getParameter("tenantId"))    : -1;
		int currPage     = request.getParameter("currentPage") != null ? Integer.parseInt(request.getParameter("currentPage")) : 1;
		int totalRows    = 0;
		int totalPages   = 0;
		int pageSize     = 10;
		int startPoint   = (currPage - 1) * pageSize;
		
		logger.debug("StartDate: " + startDate + " || EndDate: " + endDate + " || FileExt: " + fileExt + " || FileName: " + fileName + " || Username: " + userName);
		
		JSONObject result = new JSONObject();
		
		try {			
			if (startDate.equals("") && endDate.equals("") && fileExt.equals("") && fileName.equals("") && userName.equals("")) {
				searchChk = "0";
			}
			
			if (searchChk.equals("1")) {
				if (startDate.equals("")) {
					//Get logs in three months
					SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
					Date now = new Date();						 
					Calendar cal = Calendar.getInstance();
					cal.setTime(now);	
					cal.add(Calendar.MONTH, -3);
					
					startDate = commonUtil.getDateStringInUTC(sdf.format(cal.getTime()), offset, true);
					endDate = commonUtil.getDateStringInUTC(sdf.format(now), offset, true); 
				}
				else {
					String startDateTmp = startDate + " 00:00:00";
					String endDateTmp   = endDate + " 23:59:59";
					
					startDate = commonUtil.getDateStringInUTC(startDateTmp, offset, true);
					endDate   = commonUtil.getDateStringInUTC(endDateTmp, offset, true);
				}
			}
			
			logger.debug("SearchChk: " + searchChk + " || StartDate in UTC: " + startDate + " || EndDate in UTC: " + endDate);
			
			List<FileLogVO> listFileLogs = ezWebFolderAdminService.getListFileLogs(companyId, searchChk, startDate, endDate, fileExt, fileName, userName, startPoint, pageSize, primary, offset, tenantId);
			totalRows	 				 = ezWebFolderAdminService.getTotalFileLogs(companyId, searchChk, startDate, endDate, fileExt, fileName, userName, startPoint, pageSize, primary, tenantId);
			totalPages 					 = (totalRows + pageSize - 1)/pageSize;			
			
			result.put("data", listFileLogs);
			result.put("totalPages", totalPages);
			result.put("totalRows", totalRows);
			result.put("status", "ok");
			result.put("code", 0);
		} 
		catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		
		return result;
	}
	
	@RequestMapping(value="/webfolder/filemanage/file-upload", method= RequestMethod.POST, produces="application/json;charset=utf-8")
	public JSONObject postFileUploadGW(@RequestParam("data") String dataList, @RequestParam("files") List<MultipartFile>multiFileLists, HttpServletRequest request) throws Exception {
		JSONParser jp          = new JSONParser();
		JSONObject jsonObject  = (JSONObject) jp.parse(dataList);	
		
		JSONArray nameArray    = jsonObject.get("nameArray") != null ? (JSONArray) jsonObject.get("nameArray")        : null;
		int tenantId           = jsonObject.get("tenantId")  != null ? ((Long) jsonObject.get("tenantId")).intValue() : -1;
		String offset          = jsonObject.get("offset")    != null ? (String) jsonObject.get("offset")              : "";
		String userId	       = jsonObject.get("userId")    != null ? (String) jsonObject.get("userId")              : "";
		String userName1       = jsonObject.get("userName1") != null ? (String) jsonObject.get("userName1")           : "";
		String userName2       = jsonObject.get("userName2") != null ? (String) jsonObject.get("userName2")           : "";
		String folderId        = jsonObject.get("folderId")  != null ? (String) jsonObject.get("folderId")            : "";
		String companyId       = jsonObject.get("companyId") != null ? (String) jsonObject.get("companyId")           : "";
		JSONObject result      = new JSONObject();		
		
		if (nameArray == null || tenantId == -1 || offset.equals("") || userId.equals("") || userName1.equals("") || userName2.equals("") || folderId.equals("") || companyId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
			return result;
		}
		
		if (nameArray.size() != multiFileLists.size()) {
			logger.debug("Some files upload failed!");
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
			return result;
		}

		try {	
			int cnt                    = multiFileLists.size();
			SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			String realPath            = request.getServletContext().getRealPath("");
			String[] pFileName         = new String[cnt];
	        Long[] fileSize            = new Long[cnt];
	        String useExtension        = ezCommonService.getTenantConfig("USE_FileExtension", tenantId);
	        FolderVO folder		  	   = ezWebFolderService.getFolderByFolderId(folderId, offset, tenantId);
			String folderPath	       = folder.getFolderPath();
			folderPath			       = folderPath.substring(1, folderPath.length() - 1);
			String originalPath	       = getFolderPath(folderPath.split("\\|"), offset, tenantId) + folder.getFolderName1() + "/";
	        	 
	        if (((JSONObject)nameArray.get(0)).get("originalFilename") != null && StringUtils.isNotBlank((String) ((JSONObject)nameArray.get(0)).get("originalFilename"))) {	        	
	            for (int i = 0; i < cnt; i++) {
	                String _pFileName = (String)((JSONObject)nameArray.get(i)).get("originalFilename");
	                
	                if (_pFileName.indexOf(commonUtil.separator) > 0) {
	                    _pFileName = _pFileName.split("/")[_pFileName.split("/").length - 1];
	                }
	                
	                pFileName[i] = _pFileName;
	            }
	        }
	        
	        String pDirPath = getWebFolderDirPath(tenantId);     		
	        pDirPath        = realPath + pDirPath;
	        
	        if (!pDirPath.substring(pDirPath.length() - 1).equals(commonUtil.separator)) {
	        	pDirPath = pDirPath + commonUtil.separator;
	        }
	        
	        File file = new File(pDirPath);

	        if (!file.exists()) {
	        	file.mkdir();        
	        }

	        List<FileVO> list = new ArrayList<FileVO>();
	        
	        for (int i = 0; i < cnt; i++) {
	        	fileSize[i]   = multiFileLists.get(i).getSize();
	            String extend = pFileName[i].substring(pFileName[i].lastIndexOf(".") + 1);
	            
	            if (useExtension.toLowerCase().indexOf(extend.toLowerCase()) != -1 || useExtension.equals("*")) {	            	
            		writeUploadedFile(multiFileLists.get(i), pFileName[i], pDirPath);
            		//Save to database           		
            		FileTypeVO fileType = ezWebFolderService.getFileTypeByFileExt(extend, tenantId);
            		Date date           = new Date();
            		FileVO fileVO       = new FileVO();            		
            		String timeUTC      = commonUtil.getDateStringInUTC(formatter.format(date), offset, true);
            		
            		fileVO.setCreateDate(timeUTC);
            		fileVO.setUpdateDate(timeUTC);
            		fileVO.setFileExt(extend);
            		fileVO.setFileName(pFileName[i]);
            		fileVO.setDownloadCnt(0);
            		fileVO.setFilePath(getWebFolderDirPath(tenantId) + pFileName[i]);
            		fileVO.setFileSize(Long.toString(fileSize[i]));
            		fileVO.setFolderId(folderId);
            		fileVO.setTenantId(tenantId);
            		fileVO.setCreateId(userId);    
            		fileVO.setUpdateId(userId);
            		fileVO.setFileIconUrl(fileType.getTypeIcon());
            		fileVO.setFileShareStatus("0");
            		fileVO.setUseStatus("Y");
            		fileVO.setTypeId(fileType.getTypeId());
            		fileVO.setFavouriteStatus("0");         		
            		fileVO.setCreateName1(userName1);
            		fileVO.setCreateName2(userName2);
            		fileVO.setFileId(getMaxFileID(tenantId));
            		fileVO.setFilePosition(originalPath + pFileName[i]); //baonk 02-09-2018
            		
            		ezWebFolderService.insertFile(fileVO);
            		list.add(fileVO);
            		
            		saveLog("C", companyId, offset, userId, userName1, userName2, fileVO.getFileName(), fileVO.getFileSize(), fileVO.getFileExt(), fileType.getTypeName(), tenantId);
	            }
	        }

			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", list);
		} 
		catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		}
		
		return result;
	}	
		
	@RequestMapping(value = "/webfolder/filemanage/file-download", method=RequestMethod.GET, produces = { MediaType.APPLICATION_OCTET_STREAM_VALUE})
	public void getFileDownload(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String offset       = request.getParameter("offset")   != null ? request.getParameter("offset")                     : "";
		int tenantId        = request.getParameter("tenantId") != null ? Integer.parseInt(request.getParameter("tenantId")) : -1;
		String listFileId   = request.getParameter("fileList") != null ? request.getParameter("fileList")                   : "";
		String userId	    = request.getParameter("userId")   != null ? request.getParameter("userId")                     : "";
		String userName1    = request.getParameter("userName1")!= null ? request.getParameter("userName1")                  : "";
		String userName2    = request.getParameter("userName2")!= null ? request.getParameter("userName2")                  : "";	
		String companyId    = request.getParameter("companyId")!= null ? request.getParameter("companyId")                  : "";
		String[] fileIDList = listFileId.split(",");		
		
		if (fileIDList.length <= 0) {
			logger.debug("downloadAttach illegal arguments!");
			return;
		}

		//Get absolute path of the application       
        String realPath = request.getServletContext().getRealPath("");
		
		if (fileIDList.length == 1) {			
			FileVO fileVO          = ezWebFolderService.getFileByFileId(fileIDList[0], offset, tenantId);			
			String _fileName       = fileVO.getFileName();
			_fileName 		       = CommonUtil.getEncodedFileNameForDownload(request.getHeader("User-Agent"), _fileName);
			File file              = new File(realPath + fileVO.getFilePath());
			BufferedInputStream in = null;
			
			try {		    	
		    	in              = new BufferedInputStream(new FileInputStream(file));		    	
	    	    String mimetype = "application/octet-stream";	

	    	    response.setBufferSize(BUFF_SIZE);	    	    
				response.setContentType(mimetype);
				response.setHeader("Content-Disposition", "attachment; filename=\"" + _fileName + "\"");
				response.setContentLength((int)file.length());

				FileCopyUtils.copy(in, response.getOutputStream());
		    }
		    finally {
				if (in != null) {
				    try {
				    	in.close();
				    } catch (Exception ignore) {
				    	logger.debug("IGNORED: {}", ignore.getMessage());
				    }
				}
		    }
		    
		    response.getOutputStream().flush();
		    response.getOutputStream().close();			
			
		    ezWebFolderService.updateDownCnt(fileVO.getFileId(), tenantId);
		    saveLog("D", companyId, offset, userId, userName1, userName2, fileVO.getFileName(), fileVO.getFileSize(), fileVO.getFileExt(), fileVO.getFileTypeName(), tenantId);
		}		
		else {		
	        String guid = UUID.randomUUID().toString();
	        String fileName = guid + ".zip";
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
			    	FileVO fileVO = ezWebFolderService.getFileByFileId(fileIDList[i], offset, tenantId);			    	
			    	File file     = new File(realPath + fileVO.getFilePath());
			    	
			        zipOutputStream.putNextEntry(new ZipEntry(fileVO.getFileName()));
			        fileInputStream = new FileInputStream(file);
		
			        IOUtils.copy(fileInputStream, zipOutputStream);
		
			        fileInputStream.close();
			        zipOutputStream.closeEntry();
			        
			        ezWebFolderService.updateDownCnt(fileVO.getFileId(), tenantId);
			        saveLog("D", companyId, offset, userId, userName1, userName2, fileVO.getFileName(), fileVO.getFileSize(), fileVO.getFileExt(), fileVO.getFileTypeName(), tenantId);
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
		
		logger.debug("File Download Finish!");
		return;
	}
	
	@RequestMapping(value = "/webfolder/file-delete", method = RequestMethod.DELETE, produces = "application/json;charset=utf-8")
	public JSONObject delFileDelete(HttpServletRequest request) {
		String offset       = request.getParameter("offset")   != null ? request.getParameter("offset")                     : "";
		int tenantId        = request.getParameter("tenantId") != null ? Integer.parseInt(request.getParameter("tenantId")) : -1;
		String listFileId   = request.getParameter("fileList") != null ? request.getParameter("fileList")                   : "";
		String userId	    = request.getParameter("userId")   != null ? request.getParameter("userId")                     : "";
		String userName1    = request.getParameter("userName1")!= null ? request.getParameter("userName1")                  : "";
		String userName2    = request.getParameter("userName2")!= null ? request.getParameter("userName2")                  : "";	
		String companyId    = request.getParameter("companyId")!= null ? request.getParameter("companyId")                  : "";
		String[] fileIDList = listFileId.split(",");
		JSONObject result   = new JSONObject();
		
		if (fileIDList.length == 0 || tenantId == -1 || offset.equals("") || userId.equals("") || userName1.equals("") || userName2.equals("") || companyId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", "1");
			return result;
		}
		
		try {
			for (int i = 0; i < fileIDList.length; i++) {
				FileVO fileVO = ezWebFolderService.getFileByFileId(fileIDList[i], offset, tenantId);
				
				//ezWebFolderService.deleteFileByFileId(fileIDList[i], loginSimpleVO.getTenantId());
				ezWebFolderService.updateFileUseStatus(fileIDList[i], tenantId);				
				saveLog("R", companyId, offset, userId, userName1, userName2, fileVO.getFileName(), fileVO.getFileSize(), fileVO.getFileExt(), fileVO.getFileTypeName(), tenantId);
			}
			
			result.put("status", "ok");
			result.put("code", "0");
		} 
		catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
		}
		
		return result;
	}

	@RequestMapping(value="/webfolder/file-rename/fileid/{fileid}", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject putFileRename(@PathVariable(value="fileid") String fileId, HttpServletRequest request) {
		String offset       = request.getParameter("offset")   != null ? request.getParameter("offset")                     : "";
		int tenantId        = request.getParameter("tenantId") != null ? Integer.parseInt(request.getParameter("tenantId")) : -1;		
		String userId	    = request.getParameter("userId")   != null ? request.getParameter("userId")                     : "";
		String userName1    = request.getParameter("userName1")!= null ? request.getParameter("userName1")                  : "";
		String userName2    = request.getParameter("userName2")!= null ? request.getParameter("userName2")                  : "";	
		String companyId    = request.getParameter("companyId")!= null ? request.getParameter("companyId")                  : "";
		String newName 		= request.getParameter("newName")  != null ? request.getParameter("newName") 					: "";
		JSONObject result   = new JSONObject();
		
		if (fileId.equals("") || newName.equals("") || tenantId == -1 || offset.equals("") || userId.equals("") || userName1.equals("") || userName2.equals("") || companyId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", "1");
			return result;
		}
		
		try {
			FileVO fileVO  = ezWebFolderService.getFileByFileId(fileId, offset, tenantId);			
			String fileExt = fileVO.getFileExt();
			ezWebFolderService.updateFileName(fileId, newName + "." + fileExt, tenantId);			
			saveLog("U", companyId, offset, userId, userName1, userName2, fileVO.getFileName(), fileVO.getFileSize(), fileVO.getFileExt(), fileVO.getFileTypeName(), tenantId);
			
			result.put("status", "ok");
			result.put("code", 0);			
		} 
		catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);			
		}
		
		return result;
	}
	
	@RequestMapping(value="/webfolder/filemove/fileid/{fileid}/modes/{mode}", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject putFileMove(@PathVariable(value="fileid") String fileId, @PathVariable(value="mode") String mode, HttpServletRequest request) {
		String offset       = request.getParameter("offset")   != null ? request.getParameter("offset")                     : "";
		int tenantId        = request.getParameter("tenantId") != null ? Integer.parseInt(request.getParameter("tenantId")) : -1;		
		String userId	    = request.getParameter("userId")   != null ? request.getParameter("userId")                     : "";
		String userName1    = request.getParameter("userName1")!= null ? request.getParameter("userName1")                  : "";
		String userName2    = request.getParameter("userName2")!= null ? request.getParameter("userName2")                  : "";	
		String companyId    = request.getParameter("companyId")!= null ? request.getParameter("companyId")                  : "";
		String folderId     = request.getParameter("folderId") != null ? request.getParameter("folderId")                   : "";
		JSONObject result   = new JSONObject();
		
		if (fileId.equals("") || fileId.equals("") || mode.equals("") || tenantId == -1 || offset.equals("") || userId.equals("") || userName1.equals("") || userName2.equals("") || companyId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", "1");
			return result;
		}
		
		try {
			FileVO fileVO = ezWebFolderService.getFileByFileId(fileId, offset, tenantId);			
			
			if (mode.equals("0")) {
				//move file
				ezWebFolderService.moveFile(fileId, folderId, tenantId);
			}
			else {
				//copy file
				SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				Date date                  = new Date();
				String timeUTC             = commonUtil.getDateStringInUTC(formatter.format(date), offset, true);
				
				fileVO.setFolderId(folderId);				
				fileVO.setFileId(getMaxFileID(tenantId));
				fileVO.setCreateDate(timeUTC);
				fileVO.setUpdateDate(timeUTC);
				ezWebFolderService.insertFile(fileVO);
			}
		
			saveLog("U", companyId, offset, userId, userName1, userName2, fileVO.getFileName(), fileVO.getFileSize(), fileVO.getFileExt(), fileVO.getFileTypeName(), tenantId);
			
			result.put("status", "ok");
			result.put("code", 0);			
		} 
		catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);			
		}
		
		return result;
	}
	
	@RequestMapping(value="/webfolderadmin/webfolderadmin-list", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getWebfolderAdminList(HttpServletRequest request) {		
		int tenantId        = request.getParameter("tenantId") != null ? Integer.parseInt(request.getParameter("tenantId")) : -1;		
		String primary	    = request.getParameter("primary")  != null ? request.getParameter("primary")                    : "";
		int pageNum         = request.getParameter("pageNum")  != null ? Integer.parseInt(request.getParameter("pageNum"))  : -1;
		int pageSize        = request.getParameter("pageSize") != null ? Integer.parseInt(request.getParameter("pageSize")) : -1;	
		String companyId    = request.getParameter("companyId")!= null ? request.getParameter("companyId")                  : "";
		String type 		= "wf=1";
		JSONObject result   = new JSONObject();
		JSONArray jsonArray = new JSONArray();		
		
		if (companyId.equals("") || type.equals("") || tenantId == -1 || primary.equals("") || pageNum == -1 || pageSize == -1) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", "1");
			return result;
		}
		
		try {
			int startRow           = (pageSize * (pageNum - 1)) + 1;
	        int endRow             = pageSize * pageNum;	                
	        int cnt                = ezOrganAdminService.getPermissionListCount(companyId, type, primary, tenantId);
	        List<OrganUserVO> list = ezOrganAdminService.getPermissionList(companyId, type, primary, startRow, endRow, tenantId);
	        
	        logger.debug("List size: " + list.size());
	        
	        for (OrganUserVO vo : list) {
	        	JSONObject fileJson    = new JSONObject();
	        	fileJson.put("userId", vo.getCn());	        	
	        	fileJson.put("departmentId", vo.getExtensionAttribute1());
	        	fileJson.put("userName", vo.getDisplayName());
	        	fileJson.put("userMail", vo.getMail());
	        	fileJson.put("jobPositon", vo.getTitle());
	        	fileJson.put("departmentName", vo.getDescription());
	        	fileJson.put("phoneNumber", vo.getTelephoneNumber());
	        	fileJson.put("companyName", vo.getCompany());
	        	
	        	jsonArray.add(fileJson);
	        }

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", jsonArray);
			result.put("count", cnt);
		}
		catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		
		return result;
	}
	
	@RequestMapping(value="/webfolderadmin/webfolderadmin", method= RequestMethod.POST, produces="application/json;charset=utf-8")
	public JSONObject postWebfolderAdminInsert(HttpServletRequest request) throws Exception {
		int tenantId        = request.getParameter("tenantId") != null ? Integer.parseInt(request.getParameter("tenantId")) : -1;		
		String userId		= request.getParameter("userId")   != null ? request.getParameter("userId")   					: "";
		String primary	    = request.getParameter("primary")  != null ? request.getParameter("primary")                    : "";
		JSONObject result   = new JSONObject();
		OrganUserVO vo      = null;
		
		if (userId.equals("") || primary.equals("") || tenantId == -1) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", "1");
			return result;
		}		
		
		logger.debug("UserID: " + userId + " || primary: " + primary + " || TenantId: " + tenantId);
		
		vo            = ezOrganAdminService.getUserInfo(userId, primary, tenantId);
		String extStr = vo.getExtensionAttribute1().toLowerCase();
		
	    SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        date.setTimeZone(TimeZone.getTimeZone("GMT"));
        
        String nowDate = date.format(new Date());		
		int pos        = extStr.indexOf("wf=1");
		
		if (pos > -1) {
			logger.debug("Already be webfolder admin!");
			result.put("status", "error");
			result.put("code", "1");
			return result;
		}

		pos = extStr.indexOf("wf=0;");
		
		if (pos > -1) {			
			extStr = extStr.replace("wf=0", "wf=1");
		}
		else {
			extStr += "wf=1;";
		}
		
		vo.setExtensionAttribute1(extStr);
		vo.setTenantId(tenantId);
		vo.setNowDate(nowDate);
		
		logger.debug("Extension: " + extStr);

		try {
			ezOrganAdminService.updateDBData_user(vo);

			result.put("status", "ok");
			result.put("code", 0);						
		}
		catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);			
		}
		
		return result;
	}
	
	@RequestMapping(value="/webfolderadmin/webfolderadmin/users/{userid}", method= RequestMethod.DELETE, produces="application/json;charset=utf-8")
	public JSONObject deleteWebfolderAdminDelete(@PathVariable String userid, HttpServletRequest request) throws Exception {
		int tenantId        = request.getParameter("tenantId") != null ? Integer.parseInt(request.getParameter("tenantId")) : -1;		
		String primary	    = request.getParameter("primary")  != null ? request.getParameter("primary")                    : "";
		JSONObject result   = new JSONObject();
		OrganUserVO vo      = null;
		
		if (userid.equals("") || primary.equals("") || tenantId == -1) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", "1");
			return result;
		}		
		
		logger.debug("UserID: " + userid + " || primary: " + primary + " || TenantId: " + tenantId);
		
		vo            = ezOrganAdminService.getUserInfo(userid, primary, tenantId);
		String extStr = vo.getExtensionAttribute1().toLowerCase();
		
	    SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        date.setTimeZone(TimeZone.getTimeZone("GMT"));
        
        String nowDate = date.format(new Date());		
		int pos        = extStr.indexOf("wf=1;");
		
		if (pos == -1) {
			logger.debug("Cannot find webfolder admin extension!");
			result.put("status", "error");
			result.put("code", "1");
			return result;
		}		
				
		extStr = extStr.replace("wf=1;", "");
		
		vo.setExtensionAttribute1(extStr);
		vo.setTenantId(tenantId);
		vo.setNowDate(nowDate);
		
		logger.debug("Extension: " + extStr);

		try {
			ezOrganAdminService.updateDBData_user(vo);

			result.put("status", "ok");
			result.put("code", 0);						
		}
		catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);			
		}
		
		return result;
	}
	
	@RequestMapping(value="/webfolderadmin/folders", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getCompanyFolderList(HttpServletRequest request) {	
		int tenantId      = request.getParameter("tenantId") != null ? Integer.parseInt(request.getParameter("tenantId")) : -1;
		String offset     = request.getParameter("offset")   != null ? request.getParameter("offset")                     : "";			
		String companyId  = request.getParameter("companyId")!= null ? request.getParameter("companyId")                  : "";
		String primary    = request.getParameter("primary")  != null ? request.getParameter("primary")                    : "";
		JSONObject result = new JSONObject();
		
		if (companyId.equals("") || primary.equals("") || offset.equals("") || tenantId == -1) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", "1");
			return result;
		}		
		
		logger.debug("CompanyId: " + companyId + " || tenantId: " + tenantId + " || Offset: " + offset + " || Primary: " + primary);
		
		try {
			FolderVO folderVO = ezWebFolderService.getCompanyFolderId(companyId, offset, tenantId);
			FolderSimpleVO company = ezWebFolderService.getSimpleFolder(folderVO.getFolderId(), primary, tenantId);
			ezWebFolderService.getAllSubDepts(company, primary, tenantId, 0);
									
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", company);
		} 
		catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		}
		
		return result;
	}
	
	@RequestMapping(value="/webfolderadmin/folders", method= RequestMethod.POST, produces="application/json;charset=utf-8")
	public JSONObject postCompanyFolderInsert(@RequestBody JSONObject jsonObject, HttpServletRequest request) throws ParseException {
		JSONParser parser      = new JSONParser();
		jsonObject             = (JSONObject) parser.parse(jsonObject.toJSONString());
		
		int tenantId           = jsonObject.get("tenantId")  != null ? ((Long) jsonObject.get("tenantId")).intValue() : -1;		
		String offset          = jsonObject.get("offset")    != null ? (String) jsonObject.get("offset")              : "";
		String userId	       = jsonObject.get("userId")    != null ? (String) jsonObject.get("userId")              : "";
		String userName1       = jsonObject.get("userName1") != null ? (String) jsonObject.get("userName1")           : "";
		String userName2       = jsonObject.get("userName2") != null ? (String) jsonObject.get("userName2")           : "";
		String pFolderId       = jsonObject.get("pFolderId") != null ? (String) jsonObject.get("pFolderId")           : "";
		String companyId       = jsonObject.get("companyId") != null ? (String) jsonObject.get("companyId")           : "";
		String folderName      = jsonObject.get("fName")     != null ? (String) jsonObject.get("fName")               : "";
		String folderUsers     = jsonObject.get("fUsers")    != null ? (String) jsonObject.get("fUsers")              : "";
		JSONObject result      = new JSONObject();
		
		if (companyId.equals("") || pFolderId.equals("") || userId.equals("") || userName1.equals("") || folderUsers.equals("") || userName2.equals("") || folderName.equals("") || offset.equals("") || tenantId == -1) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", "1");
			return result;
		}		
		
		logger.debug("CompanyId: " + companyId + " || tenantId: " + tenantId + " || folderName: " + folderName + " || ParentFolderID: " + pFolderId);
		
		try {
			FolderVO parentFolder	   = ezWebFolderService.getFolderByFolderId(pFolderId, offset, tenantId);
			FolderVO folder            = new FolderVO();
			SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			Date date           	   = new Date();
			String timeUTC             = commonUtil.getDateStringInUTC(formatter.format(date), offset, true);
			String folderId			   = getMaxFolderID(tenantId);
			JSONObject json            = (JSONObject) parser.parse(folderUsers);
			JSONArray userArray		   = (JSONArray)json.get("user");
			JSONArray deptArray		   = (JSONArray)json.get("dept");
			
			for (int i = 0; i < userArray.size(); i++) {
				ezWebFolderAdminService.insertFolderUser(getMaxFolderUserSeq(tenantId), (String)userArray.get(i), "user", folderId, userId, timeUTC, companyId, tenantId);
			}
			
			for (int i = 0; i < deptArray.size(); i++) {
				ezWebFolderAdminService.insertFolderUser(getMaxFolderUserSeq(tenantId), (String)deptArray.get(i), "dept", folderId, userId, timeUTC, companyId, tenantId);
			}
			
			folder.setFolderId(folderId);
			folder.setFolderLevel(parentFolder.getFolderLevel() + 1);
			folder.setFolderName1(folderName);
			folder.setFolderName2("");
			folder.setFolderPath(parentFolder.getFolderPath() + folderId + "|");
			folder.setFolderStep(getMaxFolderStep(pFolderId, tenantId));
			folder.setFolderType("C");
			folder.setFolderUpper(parentFolder.getFolderId());
			folder.setOwnerId(companyId);
			folder.setUseStatus("Y");
			folder.setUpdateId(userId);
			folder.setCreateName1(userName1);
			folder.setCreateName2(userName2);
			folder.setTenantId(tenantId);
			folder.setCompanyId(companyId);
			folder.setCreateId(userId);
			folder.setCreateDate(timeUTC);
			folder.setUpdateDate(timeUTC);		
			
			ezWebFolderAdminService.insertFolder(folder);
									
			result.put("status", "ok");
			result.put("code", 0);			
		} 
		catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		}
		
		return result;
	}
	
	@RequestMapping(value="/webfolderadmin/folders/{folderid}", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject putCompanyFolderUpdate(@RequestBody JSONObject jsonObject, @PathVariable(value="folderid") String folderId, HttpServletRequest request) throws ParseException {
		JSONParser parser      = new JSONParser();
		jsonObject             = (JSONObject) parser.parse(jsonObject.toJSONString());
		
		int tenantId           = jsonObject.get("tenantId")  != null ? ((Long) jsonObject.get("tenantId")).intValue() : -1;		
		String offset          = jsonObject.get("offset")    != null ? (String) jsonObject.get("offset")              : "";
		String userId	       = jsonObject.get("userId")    != null ? (String) jsonObject.get("userId")              : "";		
		String folderName      = jsonObject.get("fName")     != null ? (String) jsonObject.get("fName")               : "";
		String folderUsers     = jsonObject.get("fUsers")    != null ? (String) jsonObject.get("fUsers")              : "";
		JSONObject result      = new JSONObject();
		
		if (folderId.equals("") || userId.equals("") || folderUsers.equals("") || folderName.equals("") || offset.equals("") || tenantId == -1) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", "1");
			return result;
		}		
		
		logger.debug("TenantId: " + tenantId + " || folderName: " + folderName + " || folderID: " + folderId);
		
		try {
			FolderVO folder = ezWebFolderService.getFolderByFolderId(folderId, offset, tenantId);
			
			if (folder == null) {
				logger.debug("Folder not found!");
				result.put("status", "error");
				result.put("code", "1");
				return result;
			}			
			
			SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			Date date           	   = new Date();
			String timeUTC             = commonUtil.getDateStringInUTC(formatter.format(date), offset, true);			
			JSONObject json            = (JSONObject) parser.parse(folderUsers);
			JSONArray userArray		   = (JSONArray)json.get("user");
			JSONArray deptArray		   = (JSONArray)json.get("dept");
			
			//Delete all folder users
			ezWebFolderAdminService.deleteFolderUsers(folderId, tenantId);
			
			for (int i = 0; i < userArray.size(); i++) {
				ezWebFolderAdminService.insertFolderUser(getMaxFolderUserSeq(tenantId), (String)userArray.get(i), "user", folderId, userId, timeUTC, folder.getCompanyId(), tenantId);
			}
			
			for (int i = 0; i < deptArray.size(); i++) {
				ezWebFolderAdminService.insertFolderUser(getMaxFolderUserSeq(tenantId), (String)deptArray.get(i), "dept", folderId, userId, timeUTC, folder.getCompanyId(), tenantId);
			}			
					
			folder.setFolderName1(folderName);
			folder.setFolderName2("");			
			folder.setUpdateId(userId);
			folder.setTenantId(tenantId);
			folder.setUpdateDate(timeUTC);		
			
			ezWebFolderAdminService.insertFolder(folder);
									
			result.put("status", "ok");
			result.put("code", 0);			
		} 
		catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		}
		
		return result;
	}
	
	@RequestMapping(value="/webfolderadmin/foldersTree", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getCompanyFolderTree(HttpServletRequest request) {	
		int tenantId      = request.getParameter("tenantId") != null ? Integer.parseInt(request.getParameter("tenantId")) : -1;
		String offset     = request.getParameter("offset")   != null ? request.getParameter("offset")                     : "";			
		String companyId  = request.getParameter("companyId")!= null ? request.getParameter("companyId")                  : "";
		String folderId  = request.getParameter("folderId")  != null ? request.getParameter("folderId")                   : "";
		String primary    = request.getParameter("primary")  != null ? request.getParameter("primary")                    : "";
		JSONObject result = new JSONObject();
		
		if (companyId.equals("") || primary.equals("") || offset.equals("") || tenantId == -1) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", "1");
			return result;
		}		
		
		logger.debug("CompanyId: " + companyId + " || tenantId: " + tenantId + " || Offset: " + offset + " || Primary: " + primary);
		
		try {			
			FolderVO folderVO      = ezWebFolderService.getCompanyFolderId(companyId, offset, tenantId);
			FolderSimpleVO company = ezWebFolderService.getSimpleFolder(folderVO.getFolderId(), primary, tenantId);
			
			if (folderId.equals("")) {
				ezWebFolderService.getAllSubDepts(company, primary, tenantId, 2);
			}
			else {
				FolderVO selectedFolder = ezWebFolderService.getFolderByFolderId(folderId, offset, tenantId);
				String folderPath		= selectedFolder.getFolderPath();
				folderPath				= folderPath.substring(1, folderPath.length() - 1);
				String[] path			= folderPath.split("\\|");
				ezWebFolderService.getAllSubDepts(company, primary, tenantId, path, 1);
			}
			
									
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", company);
		} 
		catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		}
		
		return result;
	}
	
	@RequestMapping(value="/webfolderadmin/subfolder-tree/{folderid}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getSubFoldersTree(@PathVariable(value="folderid") String folderId, HttpServletRequest request) {	
		int tenantId      = request.getParameter("tenantId") != null ? Integer.parseInt(request.getParameter("tenantId")) : -1;					
		String primary    = request.getParameter("primary")  != null ? request.getParameter("primary")                    : "";
		JSONObject result = new JSONObject();
		
		logger.debug("folderId: " + folderId + " || tenantId: " + tenantId);		
		
		if (folderId.equals("") || primary.equals("") || tenantId == -1) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", "1");
			return result;
		}	
		
		try {			
			FolderSimpleVO folder = ezWebFolderService.getSimpleFolder(folderId, primary, tenantId);
			ezWebFolderService.getAllSubDepts(folder, primary, tenantId, 1);
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", folder);
		} 
		catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		}
		
		return result;
	}
	
	@RequestMapping(value="/webfolderadmin/folder-users/{folderid}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getFolderUsers(@PathVariable(value="folderid") String folderId, HttpServletRequest request) {	
		int tenantId      = request.getParameter("tenantId") != null ? Integer.parseInt(request.getParameter("tenantId")) : -1;		
		JSONObject result = new JSONObject();
		
		logger.debug("folderId: " + folderId + " || tenantId: " + tenantId);		
		
		if (folderId.equals("") || tenantId == -1) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", "1");
			return result;
		}	
		
		try {			
			List<FolderUserVO> listUsers = ezWebFolderService.getFolderUsers(folderId, tenantId);
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", listUsers);
		} 
		catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		}
		
		return result;
	}
	
	@RequestMapping(value="/webfolderadmin/folders/{folderid}", method= RequestMethod.DELETE, produces="application/json;charset=utf-8")
	public JSONObject delCompanyFolder(@PathVariable(value="folderid") String folderId, HttpServletRequest request) throws Exception {
		int tenantId        = request.getParameter("tenantId") != null ? Integer.parseInt(request.getParameter("tenantId")) : -1;		
		JSONObject result   = new JSONObject();		
		
		if (folderId.equals("") || tenantId == -1) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", "1");
			return result;
		}
		
		logger.debug("FolderId: " + folderId + " || TenantId: " + tenantId);

		try {
			ezWebFolderService.updateFolderUseStatus(folderId, tenantId);
			
			result.put("status", "ok");
			result.put("code", 0);
		}
		catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);			
		}
		
		return result;
	}
	
	@RequestMapping(value="/webfolderadmin/folders/{folderid}/file-list", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getFileList(@PathVariable(value="folderid") String folderId, HttpServletRequest request) {	
		String offset    = request.getParameter("offset")      != null ? request.getParameter("offset")                        : "";
		String primary   = request.getParameter("primary")     != null ? request.getParameter("primary")                       : "";		
		String startDate = request.getParameter("startDate")   != null ? request.getParameter("startDate")                     : "";
		String endDate   = request.getParameter("endDate")     != null ? request.getParameter("endDate")                       : "";
		String fileExt   = request.getParameter("fileExt")     != null ? request.getParameter("fileExt")                       : "";
		String fileName  = request.getParameter("fileName")    != null ? request.getParameter("fileName")                      : "";
		String userName  = request.getParameter("userName")    != null ? request.getParameter("userName")                      : "";
		String fileType  = request.getParameter("fileType")    != null ? request.getParameter("fileType")                      : "";
		String searchChk = "1";
		int tenantId     = request.getParameter("tenantId")    != null ? Integer.parseInt(request.getParameter("tenantId"))    : -1;
		int currPage     = request.getParameter("currentPage") != null ? Integer.parseInt(request.getParameter("currentPage")) :  1;
		int totalRows    = 0;
		int totalPages   = 0;
		int pageSize     = 10;
		int startPoint   = (currPage - 1) * pageSize;
		
		JSONObject result = new JSONObject();
		
		if (folderId.equals("") || tenantId == -1) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", "1");
			return result;
		}
		
		logger.debug("FolderId: " + folderId + " || tenantId: " + tenantId);		
		
		try {
			if (startDate.equals("") && endDate.equals("") && fileExt.equals("") && fileName.equals("") && userName.equals("")) {
				searchChk = "0";
			}
			
			if (searchChk.equals("1")) {
				if (startDate.equals("")) {
					//Get logs in three months
					SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
					Date now = new Date();						 
					Calendar cal = Calendar.getInstance();
					cal.setTime(now);	
					cal.add(Calendar.MONTH, -3);
					
					startDate = commonUtil.getDateStringInUTC(sdf.format(cal.getTime()), offset, true);
					endDate = commonUtil.getDateStringInUTC(sdf.format(now), offset, true); 
				}
				else {
					String startDateTmp = startDate + " 00:00:00";
					String endDateTmp   = endDate + " 23:59:59";
					
					startDate = commonUtil.getDateStringInUTC(startDateTmp, offset, true);
					endDate   = commonUtil.getDateStringInUTC(endDateTmp, offset, true);
				}
			}
			
			logger.debug("SearchChk: " + searchChk + " || StartDate in UTC: " + startDate + " || EndDate in UTC: " + endDate);
			
			List<FileVO> fileList = new ArrayList<FileVO>();			
			FolderVO folder		  = ezWebFolderService.getFolderByFolderId(folderId, offset, tenantId);
			String folderPath	  = folder.getFolderPath();
			folderPath			  = folderPath.substring(1, folderPath.length() - 1);		
			String originalPath   = getFolderPath(folderPath.split("\\|"), offset, tenantId) + folder.getFolderName1() + "/";
			
			if (folder.getFolderUpper().equals("root")) {
				Map<String, String> filePathMap = new LinkedHashMap<String, String>();				
				fileList  = ezWebFolderService.getAllFiles(folder.getFolderPath(), originalPath, searchChk, startDate, endDate, fileExt, fileName, userName, fileType, startPoint, pageSize, primary, offset, tenantId);
				totalRows = ezWebFolderService.getTotalFileCnt2(folder.getFolderPath(), searchChk, startDate, endDate, fileExt, fileName, userName, fileType, startPoint, pageSize, primary, tenantId);
				String []rootPath = folderPath.split("\\|");
				
				for (FileVO file : fileList) {
					if (file.getFilePosition().equals("")) {
						String file_path	= originalPath;
						String fldPath      = file.getFolderPath().substring(1, file.getFolderPath().length() - 1);
						String[] fldPathArr = fldPath.split("\\|");
						
						for (int i = rootPath.length; i < fldPathArr.length - 1; i++) {
							if (filePathMap.containsKey(fldPathArr[i])) {
								file_path += filePathMap.get(fldPathArr[i]) + "/";
							}
							else {
								FolderVO _folder = ezWebFolderService.getFolderByFolderId(fldPathArr[i], offset, tenantId);
								file_path += _folder.getFolderName1() + "/";								
								filePathMap.put(fldPathArr[i], _folder.getFolderName1());
							}
						}
						
						file_path += file.getFolderName() + "/";				
						file.setFilePosition(file_path + file.getFileName());
					}
				}
			}
			else {				
				fileList  = ezWebFolderService.getAllFilesInFolder(folderId, originalPath, searchChk, startDate, endDate, fileExt, fileName, userName, fileType, startPoint, pageSize, primary, offset, tenantId);
				totalRows = ezWebFolderService.getTotalFileCnt(folderId, searchChk, startDate, endDate, fileExt, fileName, userName, fileType, startPoint, pageSize, primary, tenantId);
			}
			
			totalPages  = (totalRows + pageSize - 1)/pageSize;
			
			result.put("data", fileList);
			result.put("totalPages", totalPages);
			result.put("totalRows", totalRows);			
			result.put("status", "ok");
			result.put("code", 0);			
		} 
		catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		}
		
		return result;
	}	
	
	private String getFolderPath(String[] path, String offset, int tenantId) throws Exception {
		String result = "/";
		
		for (int i = 0; i < path.length - 1; i++) {
			FolderVO parentFolder = ezWebFolderService.getFolderByFolderId(path[i], offset, tenantId);
			result += parentFolder.getFolderName1() + "/";
		}
		
		return result;
	}	
	
	private void saveLog(String type, String companyId, String offset, String userId, String userName1, String userName2, String filename, String fileSize, String fileExt, String fileType, int tenantId) throws Exception {
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date date                  = new Date();
		String timeUTC             = commonUtil.getDateStringInUTC(formatter.format(date), offset, true);
		
		//Save log to database				
		FileLogVO fileLog = new FileLogVO();
		
		fileLog.setLogType(type);
		fileLog.setCompanyId(companyId);
		fileLog.setCreateDate(timeUTC);
		fileLog.setCreateId(userId);
		fileLog.setCreateName1(userName1);
		fileLog.setCreateName2(userName2);
		fileLog.setFileName(filename);
		fileLog.setFileSize(fileSize);
		fileLog.setFileExt(fileExt);
		fileLog.setFileType(fileType);
		fileLog.setLogId(getMaxLogID(tenantId));
		fileLog.setTenantId(tenantId);
		
		ezWebFolderAdminService.insertFileLog(fileLog);
	}
		
	private String getWebFolderDirPath(int tenantId) {
		return commonUtil.separator + "fileroot" + commonUtil.separator + tenantId + commonUtil.separator + "webfolder" + commonUtil.separator;
	}
	
	private String getMaxFileID(int tenantId) throws Exception {
		int currentMaxFileId = -1;
		String result        = ezWebFolderService.getFileSequence(tenantId);		
		currentMaxFileId     = result.equals("")        ? 1 : Integer.parseInt(result);		
		currentMaxFileId	 = (currentMaxFileId == -1) ? 1 : (currentMaxFileId + 1);

		return Integer.toString(currentMaxFileId);
	}
	
	private String getMaxLogID(int tenantId) throws Exception {
		int currentMaxLogId = -1;
		String result       = ezWebFolderService.getFileLogSequence(tenantId);
		currentMaxLogId     = result.equals("")       ? 1 : Integer.parseInt(result);
		currentMaxLogId     = (currentMaxLogId == -1) ? 1 : (currentMaxLogId + 1);

		return Integer.toString(currentMaxLogId);
	}
	
	private String getMaxFolderID(int tenantId) throws Exception {
		int currentMaxFolderId = -1;
		String result          = ezWebFolderService.getFolderSequence(tenantId);		
		currentMaxFolderId     = result.equals("")        ? 1 : Integer.parseInt(result);		
		currentMaxFolderId	   = (currentMaxFolderId == -1) ? 1 : (currentMaxFolderId + 1);

		return Integer.toString(currentMaxFolderId);
	}
	
	private int getMaxFolderStep(String folderId, int tenantId) throws Exception {
		int currentMaxStep = -1;
		String result      = ezWebFolderService.getMaxFolderStep(folderId, tenantId);
		currentMaxStep     = result.equals("")        ? 1 : Integer.parseInt(result);		
		currentMaxStep	   = (currentMaxStep == -1)   ? 1 : (currentMaxStep + 1);

		return currentMaxStep;
	}
	
	private String getMaxFolderUserSeq(int tenantId) throws Exception {
		int currentMaxolderUserId  = -1;
		String result              = ezWebFolderService.getFolderUserSequence(tenantId);		
		currentMaxolderUserId      = result.equals("")        ? 1 : Integer.parseInt(result);		
		currentMaxolderUserId	   = (currentMaxolderUserId == -1) ? 1 : (currentMaxolderUserId + 1);

		return Integer.toString(currentMaxolderUserId);
	}

}
