package egovframework.ezEKP.ezWebFolder.web;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.codehaus.jackson.JsonParseException;
import org.codehaus.jackson.map.JsonMappingException;
import org.codehaus.jackson.map.ObjectMapper;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderAdminService;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderService;
import egovframework.ezEKP.ezWebFolder.vo.FileLogVO;
import egovframework.ezEKP.ezWebFolder.vo.FileTypeVO;
import egovframework.ezEKP.ezWebFolder.vo.FileVO;
import egovframework.ezEKP.ezWebFolder.vo.UserCapacityVO;
import egovframework.ezEKP.ezWebFolder.vo.WebfolderConfigVO;
import egovframework.let.user.login.vo.LoginVO;
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
	public JSONObject changeBasicStorage(@PathVariable String newValue, HttpServletRequest request) {	
		int tenantId         = Integer.parseInt(request.getParameter("tenantId"));
		String uploadLimit   = request.getParameter("uploadLimit");
		String companyId     = request.getParameter("companyId");
		logger.debug("New Value: " + newValue + " || tenantId: " + tenantId);	
		JSONObject result = new JSONObject();
		
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
		int currPage     = Integer.parseInt(request.getParameter("currentPage"));
		String searchStr = request.getParameter("searchStr");
		String searchOpt = request.getParameter("searchOpt");
		String primary   = request.getParameter("primary");
		
		logger.debug("CompanyId: " + companyid + " || tenantId: " + tenantId);
		
		JSONObject result = new JSONObject();
		
		try {			
			List<UserCapacityVO> listUserCapacity = ezWebFolderAdminService.getListUserCapacity(companyid, searchStr, searchOpt, tenantId, primary);			
			for(UserCapacityVO capacity: listUserCapacity) {
				if (capacity.getTotalUsed().equals("0")) {
					capacity.setUsedRate(0);
				}
				else {				
					double totalCapByBytes = Double.parseDouble(capacity.getTotalCapacity()) * 10737418.24;
					capacity.setUsedRate((int)(Integer.parseInt(capacity.getTotalUsed())/totalCapByBytes));
				}
			}
			
			//Paging
			totalUsers = listUserCapacity.size();
			totalPages = (totalUsers + pageSize - 1)/pageSize;
			List<UserCapacityVO> renderList = new ArrayList<UserCapacityVO>();
			
			logger.debug("totalUsers: " + totalUsers + " || TotalPages: " + totalPages + " || CurrPage: " + currPage);

			if (totalPages == 0 || totalPages == 1) {
				result.put("data", listUserCapacity);				
			}
			else {
				if (currPage < totalPages) {				
					int startPoint = (currPage - 1) * pageSize;
					int endPoint = currPage * pageSize;
					renderList = listUserCapacity.subList(startPoint, endPoint);					
					result.put("data", renderList);
				}
				else {
					if (currPage > totalPages) {
						currPage = totalPages;
					}
					int startPoint = (currPage - 1) * pageSize;
					int endPoint = totalUsers;				
					
					renderList = listUserCapacity.subList(startPoint, endPoint);
					result.put("data", renderList);
				}
			}			
								
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
	public JSONObject changePersonalStorage(@PathVariable String newValue, @RequestParam("userList") List<String> userList, HttpServletRequest request) {	
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
	public JSONObject resetPersonalStorage(@RequestParam("userList") List<String> userList, HttpServletRequest request) {	
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
		String offset    = request.getParameter("offset");
		String primary   = request.getParameter("primary");		
		String companyId = request.getParameter("companyId");
		String startDate = request.getParameter("startDate");
		String endDate   = request.getParameter("endDate");
		String fileExt   = request.getParameter("fileExt");
		String fileName  = request.getParameter("fileName");
		String userName  = request.getParameter("userName");
		String searchChk = "1";
		int tenantId     = Integer.parseInt(request.getParameter("tenantId"));
		int currPage     = Integer.parseInt(request.getParameter("currentPage"));
		int totalRows    = 0;
		int totalPages   = 0;
		int pageSize     = 10;
		
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
			
			List<FileLogVO> listFileLogs = ezWebFolderAdminService.getListFileLogs(companyId, searchChk, startDate, endDate, fileExt, fileName, userName, primary, offset, tenantId);
			
			//Paging
			if (listFileLogs != null) {
				totalRows  = listFileLogs.size();
			}
			
			totalPages = (totalRows + pageSize - 1)/pageSize;
			List<FileLogVO> renderList = new ArrayList<FileLogVO>();
			
			logger.debug("totalUsers: " + totalRows + " || TotalPages: " + totalPages + " || CurrPage: " + currPage);

			if (totalPages == 0 || totalPages == 1) {				
				result.put("data", listFileLogs);
			}
			else {
				if (currPage < totalPages) {				
					int startPoint = (currPage - 1) * pageSize;
					int endPoint = currPage * pageSize;
					renderList = listFileLogs.subList(startPoint, endPoint);					
					result.put("data", renderList);
				}
				else {
					if (currPage > totalPages) {
						currPage = totalPages;
					}
					int startPoint = (currPage - 1) * pageSize;
					int endPoint = totalRows;				
					
					renderList = listFileLogs.subList(startPoint, endPoint);					
					result.put("data", renderList);
				}
			}

			result.put("totalPages", totalPages);
			result.put("totalRows", totalRows);
			result.put("status", "ok");
			result.put("code", 0);
		} 
		catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		
		return result;
	}
	
	@RequestMapping(value="/webfolder/filemanage/fileupload", method= RequestMethod.POST, produces="application/json;charset=utf-8")
	public JSONObject fileUploadGW(@RequestParam(value = "files") List<MultipartFile> multiFileLists, HttpServletRequest request) throws JsonParseException, JsonMappingException, IOException {
		int tenantId      = Integer.parseInt(request.getParameter("tenantId"));
		String offset     = request.getParameter("offset");
		String userId	  = request.getParameter("userId");
		String userName1  = request.getParameter("userName1");
		String userName2  = request.getParameter("userName2");
		String folderId   = request.getParameter("folderId");
		String companyId  = request.getParameter("companyId");		
		JSONObject result = new JSONObject();
		
		logger.debug("folderId: " + folderId + " || userId: " + userId + " || companyId: " + companyId);
		
		try {	
			int cnt = multiFileLists.size();
			SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			String realPath = request.getServletContext().getRealPath("");
			String[] pFileName = new String[cnt];
	        Long[] fileSize = new Long[cnt];
	        String useExtension = ezCommonService.getTenantConfig("USE_FileExtension", tenantId);	        
	        
	        logger.debug("File Name: " + multiFileLists.get(0).getOriginalFilename());
	 
	        if (StringUtils.isNotEmpty(multiFileLists.get(0).getOriginalFilename()) && StringUtils.isNotBlank(multiFileLists.get(0).getOriginalFilename())) {	        	
	            for (int i = 0; i < cnt; i++) {
	                String _pFileName = multiFileLists.get(i).getOriginalFilename();
	                
	                if (_pFileName.indexOf(commonUtil.separator) > 0) {
	                    _pFileName = _pFileName.split("/")[_pFileName.split("/").length - 1];
	                }
	                
	                pFileName[i] = _pFileName;
	            }
	        }      
	        
	        String pDirPath = getWebFolderDirPath(tenantId);     		
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
	        	fileSize[i] = multiFileLists.get(i).getSize();
	            String extend = pFileName[i].substring(pFileName[i].lastIndexOf(".") + 1);
	            
	            if (useExtension.toLowerCase().indexOf(extend.toLowerCase()) != -1 || useExtension.equals("*")) {   	
	            	try {
	            		writeUploadedFile(multiFileLists.get(i), pFileName[i], pDirPath);
	            		//Save to database           		
	            		FileTypeVO fileType = ezWebFolderService.getFileTypeByFileExt(extend, tenantId);
	            		Date date = new Date();
	            		FileVO fileVO = new FileVO();
	            		
	            		String timeUTC = commonUtil.getDateStringInUTC(formatter.format(date), offset, true);
	            		
	            		fileVO.setCreateDate(timeUTC);
	            		fileVO.setUpdateDate(timeUTC);
	            		fileVO.setFileExt(extend);
	            		fileVO.setFileName(pFileName[i]);
	            		fileVO.setDownloadCnt(0);
	            		fileVO.setFilePath(getWebFolderDirPath(tenantId) + pFileName[i]);
	            		//fileVO.setFileSize(getFileSize(fileSize[i]));
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
	            		
	            		ezWebFolderService.insertFile(fileVO);
	            		list.add(fileVO);
	            		
	            		//Save log to database
	            		FileLogVO fileLog = new FileLogVO();            		
	            		
	            		fileLog.setLogType("C");
	            		fileLog.setCompanyId(companyId);
	            		fileLog.setCreateDate(timeUTC);
	            		fileLog.setCreateId(userId);
	            		fileLog.setCreateName1(userName1);
	            		fileLog.setCreateName2(userName2);
	            		fileLog.setFileName(pFileName[i]);
	            		fileLog.setFileSize(fileVO.getFileSize());
	            		fileLog.setFileExt(fileVO.getFileExt());
	            		fileLog.setFileType(fileType.getTypeName());
	            		fileLog.setLogId(getMaxLogID(tenantId));
	            		fileLog.setTenantId(tenantId);
	            		
	            		ezWebFolderAdminService.insertFileLog(fileLog);
	            	}
	            	catch (Exception e) {
	        			result.put("status", "error");
	        			result.put("code", 1);			
	        			result.put("data", "");           		
	            	}			
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
	
	private String getWebFolderDirPath(int tenantId) {
		return commonUtil.separator + "fileroot" + commonUtil.separator + tenantId + commonUtil.separator + "webfolder" + commonUtil.separator;
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
	
}
