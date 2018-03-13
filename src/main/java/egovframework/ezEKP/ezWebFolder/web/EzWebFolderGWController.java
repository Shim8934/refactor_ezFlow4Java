package egovframework.ezEKP.ezWebFolder.web;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
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
import org.json.simple.parser.ParseException;import org.slf4j.Logger;
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
import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderAdminService;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderService;
import egovframework.ezEKP.ezWebFolder.vo.FileLogVO;
import egovframework.ezEKP.ezWebFolder.vo.FileTypeVO;
import egovframework.ezEKP.ezWebFolder.vo.FileVO;
import egovframework.ezEKP.ezWebFolder.vo.FolderSimpleVO;
import egovframework.ezEKP.ezWebFolder.vo.FolderUserVO;
import egovframework.ezEKP.ezWebFolder.vo.FolderVO;
import egovframework.ezEKP.ezWebFolder.vo.SimpleDeptVO;
import egovframework.ezEKP.ezWebFolder.vo.SimpleUserVO;
import egovframework.ezEKP.ezWebFolder.vo.UserCapacityVO;
import egovframework.ezEKP.ezWebFolder.vo.WebfolderConfigVO;
import egovframework.let.user.login.service.LoginService;
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
	
	@Resource(name="loginService")
	private LoginService loginService;
	
	@Resource(name = "EzWebFolderService")
	private EzWebFolderService ezWebFolderService;
	
	@Autowired
	private EzOrganService ezOrganService;
	
	@Autowired
	private EzOrganAdminService ezOrganAdminService;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	private static final Logger logger = LoggerFactory.getLogger(EzWebFolderGWController.class);

	@RequestMapping(value="/rest/ezwebfolderadmin/basicstorage/id/{companyid}/comp", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getBasicStorage(@PathVariable(value="companyid") String companyId, HttpServletRequest request) {
		String serverName = request.getHeader("host-name")   != null ? request.getHeader("host-name") : "";
		JSONObject result = new JSONObject();
		logger.debug("CompanyId: " + companyId + " || serverName: " + serverName);
		
		if (serverName.equals("") || companyId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			return result;
		}
		
		try {
			int tenantId                      = loginService.getTenantId(serverName);
			WebfolderConfigVO webfolderConfig = ezWebFolderAdminService.getWebfolderConfig(companyId, tenantId);
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", webfolderConfig);
		} 
		catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		
		return result;
	}

	@RequestMapping(value="/rest/ezwebfolderadmin/basicstorage/{newvalue}/comp", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject putChangeBasicStorage(@PathVariable(value="newvalue") String newValue, HttpServletRequest request) {
		String serverName  = request.getHeader("host-name")      != null ? request.getHeader("host-name")      : "";
		String uploadLimit = request.getParameter("uploadLimit") != null ? request.getParameter("uploadLimit") : "";
		String companyId   = request.getParameter("companyId")   != null ? request.getParameter("companyId")   : "";
		JSONObject result  = new JSONObject();
		
		logger.debug("New Value: " + newValue + " || serverName: " + serverName);
		
		if (serverName.equals("") || companyId.equals("") || uploadLimit.equals("") || newValue.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			return result;
		}
		
		try {
			int tenantId = loginService.getTenantId(serverName);
			ezWebFolderAdminService.saveConfig(newValue, uploadLimit, companyId, tenantId);
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "");
		} 
		catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		
		return result;
	}

	@RequestMapping(value="/rest/ezwebfolderadmin/basicstorage/id/{companyid}/person", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getPersonalStorage(@PathVariable(value="companyid") String companyId, HttpServletRequest request) {
		String serverName = request.getHeader("host-name")      != null ? request.getHeader("host-name")                        : "";
		int currPage      = request.getParameter("currentPage") != null ? Integer.parseInt(request.getParameter("currentPage")) :  1;
		String searchStr  = request.getParameter("searchStr")   != null ? request.getParameter("searchStr")                     : "";
		String searchOpt  = request.getParameter("searchOpt")   != null ? request.getParameter("searchOpt")                     : "";
		String primary    = request.getParameter("primary")     != null ? request.getParameter("primary")                       : "";
		JSONObject result = new JSONObject();
		int totalUsers    = 0;
		int totalPages    = 0;
		int pageSize      = 10;
		int startPoint    = (currPage - 1) * pageSize;
		
		logger.debug("CompanyId: " + companyId + " || serverName: " + serverName);
		
		if (serverName.equals("") || companyId.equals("") || primary.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			return result;
		}
		
		try {
			int tenantId                          = loginService.getTenantId(serverName);
			List<UserCapacityVO> listUserCapacity = ezWebFolderAdminService.getListUserCapacity(companyId, searchStr, searchOpt, startPoint, pageSize, tenantId, primary);
			totalUsers                            = ezWebFolderAdminService.getTotalListUserCapacity(companyId, searchStr, searchOpt, startPoint, pageSize, tenantId, primary);
			totalPages                            = (totalUsers + pageSize - 1)/pageSize;
			
			for(UserCapacityVO capacity: listUserCapacity) {
				if (capacity.getTotalUsed().equals("0") || capacity.getTotalCapacity().equals("0")) {
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
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		
		return result;
	}

	@RequestMapping(value="/rest/ezwebfolderadmin/basicstorage/{newvalue}/person", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject putChangePersonalStorage(@PathVariable(value="newvalue") String newValue, @RequestParam("userList") List<String> userList, HttpServletRequest request) {
		String serverName = request.getHeader("host-name")    != null ? request.getHeader("host-name")    : "";
		String companyId  = request.getParameter("companyId") != null ? request.getParameter("companyId") : "";
		JSONObject result = new JSONObject();
		
		if (serverName.equals("") || companyId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			return result;
		}
		
		try {
			int tenantId = loginService.getTenantId(serverName);
			
			for (String userId : userList) {
				ezWebFolderAdminService.updateNewAmount(userId, newValue, companyId, tenantId);
			}
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "");
		} 
		catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		
		return result;
	}

	@RequestMapping(value="/rest/ezwebfolderadmin/storagereset/person", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject putResetPersonalStorage(@RequestParam("userList") List<String> userList, HttpServletRequest request) {
		String serverName  = request.getHeader("host-name")    != null ? request.getHeader("host-name")    : "";
		String companyId   = request.getParameter("companyId") != null ? request.getParameter("companyId") : "";
		String totalAmount = "";
		JSONObject result  = new JSONObject();
		
		if (serverName.equals("") || companyId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			return result;
		}
		
		try {
			int tenantId                      = loginService.getTenantId(serverName);
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
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		
		return result;
	}

	@RequestMapping(value="/rest/ezwebfolderadmin/filehistorylist", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getFileHistory(HttpServletRequest request) {
		String serverName = request.getHeader("host-name")      != null ? request.getHeader("host-name")                        : "";
		String offset     = request.getParameter("offset")      != null ? request.getParameter("offset")                        : "";
		String primary    = request.getParameter("primary")     != null ? request.getParameter("primary")                       : "";
		String companyId  = request.getParameter("companyId")   != null ? request.getParameter("companyId")                     : "";
		String startDate  = request.getParameter("startDate")   != null ? request.getParameter("startDate")                     : "";
		String endDate    = request.getParameter("endDate")     != null ? request.getParameter("endDate")                       : "";
		String fileExt    = request.getParameter("fileExt")     != null ? request.getParameter("fileExt")                       : "";
		String fileName   = request.getParameter("fileName")    != null ? request.getParameter("fileName")                      : "";
		String userName   = request.getParameter("userName")    != null ? request.getParameter("userName")                      : "";
		String searchChk  = "1";
		int currPage      = request.getParameter("currentPage") != null ? Integer.parseInt(request.getParameter("currentPage")) :  1;
		int totalRows     = 0;
		int totalPages    = 0;
		int pageSize      = 10;
		int startPoint    = (currPage - 1) * pageSize;
		
		logger.debug("StartDate: " + startDate + " || EndDate: " + endDate + " || FileExt: " + fileExt + " || FileName: " + fileName + " || Username: " + userName);
		
		JSONObject result = new JSONObject();
		
		if (serverName.equals("") || offset.equals("") || offset.equals("") || primary.equals("") || companyId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			return result;
		}
		
		try {
			int tenantId = loginService.getTenantId(serverName);
			
			if (startDate.equals("") && endDate.equals("") && fileExt.equals("") && fileName.equals("") && userName.equals("")) {
				searchChk = "0";
			}
			
			if (searchChk.equals("1")) {
				if (startDate.equals("")) {
					//Get logs in three months
					SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
					Date now             = new Date();
					Calendar cal         = Calendar.getInstance();
					cal.setTime(now);
					cal.add(Calendar.MONTH, -3);
					
					startDate = commonUtil.getDateStringInUTC(sdf.format(cal.getTime()), offset, true);
					endDate   = commonUtil.getDateStringInUTC(sdf.format(now), offset, true);
				}
				else {
					String startDateTmp = startDate + " 00:00:00";
					String endDateTmp   = endDate + " 23:59:59";
					startDate           = commonUtil.getDateStringInUTC(startDateTmp, offset, true);
					endDate             = commonUtil.getDateStringInUTC(endDateTmp, offset, true);
				}
			}
			
			logger.debug("SearchChk: " + searchChk + " || StartDate in UTC: " + startDate + " || EndDate in UTC: " + endDate);
			
			List<FileLogVO> listFileLogs = ezWebFolderAdminService.getListFileLogs(companyId, searchChk, startDate, endDate, fileExt, fileName, userName, startPoint, pageSize, primary, offset, tenantId);
			totalRows                    = ezWebFolderAdminService.getTotalFileLogs(companyId, searchChk, startDate, endDate, fileExt, fileName, userName, startPoint, pageSize, primary, tenantId);
			totalPages                   = (totalRows + pageSize - 1)/pageSize;
			
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

	@RequestMapping(value="/rest/ezwebfolder/filemanage/file-upload", method= RequestMethod.POST, produces="application/json;charset=utf-8")
	public JSONObject postFileUploadGW(@RequestParam("data") String dataList, @RequestParam("files") List<MultipartFile> multiFileLists, HttpServletRequest request) throws Exception {
		JSONParser jp          = new JSONParser();
		JSONObject jsonObject  = (JSONObject) jp.parse(dataList);
		
		JSONArray nameArray    = jsonObject.get("nameArray")    != null ? (JSONArray) jsonObject.get("nameArray") : null;
		String serverName      = request.getHeader("host-name") != null ? request.getHeader("host-name")          : "";
		String offset          = jsonObject.get("offset")       != null ? (String) jsonObject.get("offset")       : "";
		String userId          = jsonObject.get("userId")       != null ? (String) jsonObject.get("userId")       : "";
		String lang            = jsonObject.get("lang")         != null ? (String) jsonObject.get("lang")         : "";
		String folderId        = jsonObject.get("folderId")     != null ? (String) jsonObject.get("folderId")     : "";
		JSONObject result      = new JSONObject();
		
		if (nameArray == null || serverName.equals("") || offset.equals("") || userId.equals("") || lang.equals("") || folderId.equals("")) {
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
			LoginVO userInfo           = commonUtil.getUserForGw(userId, serverName, lang, offset);
			int tenantId               = userInfo.getTenantId();
			String userName1           = userInfo.getDisplayName1();
			String userName2           = userInfo.getDisplayName2();
			String companyId           = userInfo.getCompanyID();
			int cnt                    = multiFileLists.size();
			SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			String realPath            = request.getServletContext().getRealPath("");
			String[] pFileName         = new String[cnt];
			Long[] fileSize            = new Long[cnt];
			String useExtension        = ezCommonService.getTenantConfig("USE_FileExtension", tenantId);
			FolderVO folder            = ezWebFolderService.getFolderByFolderId(folderId, offset, tenantId);
			String folderPath          = folder.getFolderPath();
			folderPath                 = folderPath.substring(1, folderPath.length() - 1);
			String originalPath        = getFolderPath(folderPath.split("\\|"), offset, tenantId) + folder.getFolderName1() + "/";
			
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
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		
		return result;
	}

	@RequestMapping(value = "/rest/ezwebfolder/filemanage/file-download", method=RequestMethod.GET, produces = { MediaType.APPLICATION_OCTET_STREAM_VALUE})
	public void getFileDownload(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String offset       = request.getParameter("offset")   != null ? request.getParameter("offset")   : "";
		String listFileId   = request.getParameter("fileList") != null ? request.getParameter("fileList") : "";
		String userId       = request.getParameter("userId")   != null ? request.getParameter("userId")   : "";
		String serverName   = request.getHeader("host-name")   != null ? request.getHeader("host-name")   : "";
		String lang         = request.getParameter("lang")     != null ? request.getParameter("lang")     : "";
		String[] fileIDList = listFileId.split(",");
		
		logger.debug("serverName: " + serverName + " || Lang: " + lang + " || listFileId: " + listFileId + " || Offset: " + offset + " || UserId: " + userId);
		
		if (fileIDList.length <= 0 || offset.equals("") || serverName.equals("") || userId.equals("") || lang.equals("")) {
			logger.debug("downloadAttach illegal arguments!");
			return;
		}
		
		//Get absolute path of the application
		String realPath  = request.getServletContext().getRealPath("");
		LoginVO userInfo = commonUtil.getUserForGw(userId, serverName, lang, offset);
		String userName1 = userInfo.getDisplayName1();
		String userName2 = userInfo.getDisplayName2();
		String companyId = userInfo.getCompanyID();
		int tenantId     = userInfo.getTenantId();
		
		if (fileIDList.length == 1) {
			FileVO fileVO    = ezWebFolderService.getFileByFileId(fileIDList[0], offset, tenantId);
			String _fileName = fileVO.getFileName();
			_fileName        = CommonUtil.getEncodedFileNameForDownload(request.getHeader("User-Agent"), _fileName);
			File file        = new File(realPath + fileVO.getFilePath());
			
			if (!file.exists()) {
				throw new FileNotFoundException(fileVO.getFileName());
			}
		
			if (!file.isFile()) {
				throw new FileNotFoundException(fileVO.getFileName());
			}
			
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
			String guid                     = UUID.randomUUID().toString();
			String fileName                 = guid + ".zip";
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
					
					if (!file.exists()) {
						throw new FileNotFoundException(fileVO.getFileName());
					}
					
					if (!file.isFile()) {
						throw new FileNotFoundException(fileVO.getFileName());
					}
					
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

	@RequestMapping(value = "/rest/ezwebfolder/file-delete", method = RequestMethod.DELETE, produces = "application/json;charset=utf-8")
	public JSONObject delFileDelete(HttpServletRequest request) {
		String offset       = request.getParameter("offset")   != null ? request.getParameter("offset")   : "";
		String listFileId   = request.getParameter("fileList") != null ? request.getParameter("fileList") : "";
		String userId       = request.getParameter("userId")   != null ? request.getParameter("userId")   : "";
		String serverName   = request.getHeader("host-name")   != null ? request.getHeader("host-name")   : "";
		String lang         = request.getParameter("lang")     != null ? request.getParameter("lang")     : "";
		String[] fileIDList = listFileId.split(",");
		JSONObject result   = new JSONObject();
		
		if (fileIDList.length == 0 || serverName.equals("") || offset.equals("") || userId.equals("") || lang.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", "1");
			return result;
		}
		
		try {
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName, lang, offset);
			String userName1 = userInfo.getDisplayName1();
			String userName2 = userInfo.getDisplayName2();
			String companyId = userInfo.getCompanyID();
			int tenantId     = userInfo.getTenantId();
			
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
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", "1");
		}
		
		return result;
	}

	@RequestMapping(value="/rest/ezwebfolder/file-rename/fileid/{fileid}", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject putFileRename(@PathVariable(value="fileid") String fileId, HttpServletRequest request) {
		String offset       = request.getParameter("offset")   != null ? request.getParameter("offset")  : "";
		String userId       = request.getParameter("userId")   != null ? request.getParameter("userId")  : "";
		String serverName   = request.getHeader("host-name")   != null ? request.getHeader("host-name")  : "";
		String lang         = request.getParameter("lang")     != null ? request.getParameter("lang")    : "";
		String newName      = request.getParameter("newName")  != null ? request.getParameter("newName") : "";
		JSONObject result   = new JSONObject();
		
		if (fileId.equals("") || newName.equals("") || serverName.equals("") || offset.equals("") || userId.equals("") || lang.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", "1");
			return result;
		}
		
		try {
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName, lang, offset);
			String userName1 = userInfo.getDisplayName1();
			String userName2 = userInfo.getDisplayName2();
			String companyId = userInfo.getCompanyID();
			int tenantId     = userInfo.getTenantId();
			
			FileVO fileVO    = ezWebFolderService.getFileByFileId(fileId, offset, tenantId);
			String fileExt   = fileVO.getFileExt();
			ezWebFolderService.updateFileName(fileId, newName + "." + fileExt, tenantId);
			saveLog("U", companyId, offset, userId, userName1, userName2, fileVO.getFileName(), fileVO.getFileSize(), fileVO.getFileExt(), fileVO.getFileTypeName(), tenantId);
			
			result.put("status", "ok");
			result.put("code", 0);
		} 
		catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
		}
		
		return result;
	}

	@RequestMapping(value="/rest/ezwebfolder/filemove/fileid/{fileid}/modes/{mode}", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject putFileMove(@PathVariable(value="fileid") String fileId, @PathVariable(value="mode") String mode, HttpServletRequest request) {
		String offset       = request.getParameter("offset")   != null ? request.getParameter("offset")   : "";
		String userId       = request.getParameter("userId")   != null ? request.getParameter("userId")   : "";
		String serverName   = request.getHeader("host-name")   != null ? request.getHeader("host-name")   : "";
		String lang         = request.getParameter("lang")     != null ? request.getParameter("lang")     : "";
		String folderId     = request.getParameter("folderId") != null ? request.getParameter("folderId") : "";
		JSONObject result   = new JSONObject();
		
		if (fileId.equals("") || fileId.equals("") || mode.equals("") || serverName.equals("") || offset.equals("") || userId.equals("") || lang.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", "1");
			return result;
		}
		
		try {
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName, lang, offset);
			String userName1 = userInfo.getDisplayName1();
			String userName2 = userInfo.getDisplayName2();
			String companyId = userInfo.getCompanyID();
			int tenantId     = userInfo.getTenantId();
			
			FileVO fileVO    = ezWebFolderService.getFileByFileId(fileId, offset, tenantId);
			
			if (mode.equals("move")) {
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
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
		}
		
		return result;
	}

	@RequestMapping(value="/rest/ezwebfolderadmin/webfolderadmin-list", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getWebfolderAdminList(HttpServletRequest request) {
		String serverName   = request.getHeader("host-name")   != null ? request.getHeader("host-name")                     : "";
		String primary      = request.getParameter("primary")  != null ? request.getParameter("primary")                    : "";
		int pageNum         = request.getParameter("pageNum")  != null ? Integer.parseInt(request.getParameter("pageNum"))  : -1;
		int pageSize        = request.getParameter("pageSize") != null ? Integer.parseInt(request.getParameter("pageSize")) : -1;
		String companyId    = request.getParameter("companyId")!= null ? request.getParameter("companyId")                  : "";
		String type         = "wf=1";
		JSONObject result   = new JSONObject();
		JSONArray jsonArray = new JSONArray();
		
		if (companyId.equals("") || type.equals("") || serverName.equals("") || primary.equals("") || pageNum == -1 || pageSize == -1) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", "1");
			return result;
		}
		
		try {
			int tenantId           = loginService.getTenantId(serverName);
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
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		
		return result;
	}

	@RequestMapping(value="/webfolderadmin/webfolderadmin-insert", method= RequestMethod.POST, produces="application/json;charset=utf-8")
	public JSONObject postWebfolderAdminInsert(HttpServletRequest request) throws Exception {
		String serverName   = request.getHeader("host-name")   != null ? request.getHeader("host-name")                     : "";
		String userId       = request.getParameter("userId")   != null ? request.getParameter("userId")                     : "";
		String primary      = request.getParameter("primary")  != null ? request.getParameter("primary")                    : "";
		JSONObject result   = new JSONObject();
		OrganUserVO vo      = null;
		
		if (userId.equals("") || primary.equals("") || serverName.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", "1");
			return result;
		}
		
		logger.debug("UserID: " + userId + " || primary: " + primary + " || serverName: " + serverName);
		
		int tenantId  = loginService.getTenantId(serverName);
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
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
		}
		
		return result;
	}

	@RequestMapping(value="/webfolderadmin/webfolderadmin-delete/users/{userid}", method= RequestMethod.DELETE, produces="application/json;charset=utf-8")
	public JSONObject deleteWebfolderAdminDelete(@PathVariable String userid, HttpServletRequest request) throws Exception {
		String serverName   = request.getHeader("host-name")   != null ? request.getHeader("host-name")  : "";
		String primary      = request.getParameter("primary")  != null ? request.getParameter("primary") : "";
		JSONObject result   = new JSONObject();
		OrganUserVO vo      = null;
		
		if (userid.equals("") || primary.equals("") || serverName.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", "1");
			return result;
		}
		
		logger.debug("UserID: " + userid + " || primary: " + primary + " || serverName: " + serverName);
		
		int tenantId  = loginService.getTenantId(serverName);
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
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
		}
		
		return result;
	}

	/*@RequestMapping(value="/webfolderadmin/folders", method= RequestMethod.GET, produces="application/json;charset=utf-8")
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
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		
		return result;
	}*/

	@RequestMapping(value="/rest/ezwebfolderadmin/folders/comp", method= RequestMethod.POST, produces="application/json;charset=utf-8")
	public JSONObject postCompanyFolderInsert(@RequestBody JSONObject jsonObject, HttpServletRequest request) throws ParseException {
		JSONParser parser      = new JSONParser();
		jsonObject             = (JSONObject) parser.parse(jsonObject.toJSONString());
		String serverName      = request.getHeader("host-name") != null ? request.getHeader("host-name")       : "";
		String offset          = jsonObject.get("offset")       != null ? (String) jsonObject.get("offset")    : "";
		String userId          = jsonObject.get("userId")       != null ? (String) jsonObject.get("userId")    : "";
		String lang            = jsonObject.get("lang")         != null ? (String) jsonObject.get("lang")      : "";
		String pFolderId       = jsonObject.get("pFolderId")    != null ? (String) jsonObject.get("pFolderId") : "";
		String folderName      = jsonObject.get("fName")        != null ? (String) jsonObject.get("fName")     : "";
		String folderName2     = jsonObject.get("fName2")       != null ? (String) jsonObject.get("fName2")    : "";
		String folderUsers     = jsonObject.get("fUsers")       != null ? (String) jsonObject.get("fUsers")    : "";
		JSONObject result      = new JSONObject();
		
		if (pFolderId.equals("") || userId.equals("") || lang.equals("") || folderUsers.equals("") || folderName.equals("") || offset.equals("") || serverName.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", "1");
			return result;
		}
		
		logger.debug("serverName: " + serverName + " || folderName: " + folderName + " || ParentFolderID: " + pFolderId);
		
		try {
			LoginVO userInfo           = commonUtil.getUserForGw(userId, serverName, lang, offset);
			String userName1           = userInfo.getDisplayName1();
			String userName2           = userInfo.getDisplayName2();
			int tenantId               = userInfo.getTenantId();
			FolderVO parentFolder      = ezWebFolderService.getFolderByFolderId(pFolderId, offset, tenantId);
			FolderVO folder            = new FolderVO();
			SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			Date date                  = new Date();
			String timeUTC             = commonUtil.getDateStringInUTC(formatter.format(date), offset, true);
			String folderId            = getMaxFolderID(tenantId);
			JSONObject json            = (JSONObject) parser.parse(folderUsers);
			JSONArray userArray        = (JSONArray)json.get("user");
			JSONArray deptArray        = (JSONArray)json.get("dept");
			
			if (userArray != null) {
				for (int i = 0; i < userArray.size(); i++) {
					ezWebFolderAdminService.insertFolderUser(getMaxFolderUserSeq(tenantId), (String)userArray.get(i), "user", folderId, userId, timeUTC, parentFolder.getCompanyId(), tenantId);
				}
			}
			
			if (deptArray != null) {
				for (int i = 0; i < deptArray.size(); i++) {
					ezWebFolderAdminService.insertFolderUser(getMaxFolderUserSeq(tenantId), (String)deptArray.get(i), "dept", folderId, userId, timeUTC, parentFolder.getCompanyId(), tenantId);
				}
			}
			
			folder.setFolderId(folderId);
			folder.setFolderLevel(parentFolder.getFolderLevel() + 1);
			folder.setFolderName1(folderName);
			folder.setFolderName2(folderName2);
			folder.setFolderPath(parentFolder.getFolderPath() + folderId + "|");
			folder.setFolderStep(getMaxFolderStep(pFolderId, tenantId));
			folder.setFolderType("C");
			folder.setFolderUpper(parentFolder.getFolderId());
			folder.setOwnerId(parentFolder.getOwnerId());
			folder.setUseStatus("Y");
			folder.setUpdateId(userId);
			folder.setCreateName1(userName1);
			folder.setCreateName2(userName2);
			folder.setTenantId(tenantId);
			folder.setCompanyId(parentFolder.getCompanyId());
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

	@RequestMapping(value="/rest/ezwebfolderadmin/folders/{folderid}/comp", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject putCompanyFolderUpdate(@RequestBody JSONObject jsonObject, @PathVariable(value="folderid") String folderId, HttpServletRequest request) throws ParseException {
		JSONParser parser      = new JSONParser();
		jsonObject             = (JSONObject) parser.parse(jsonObject.toJSONString());
		String serverName      = request.getHeader("host-name") != null ? request.getHeader("host-name")    : "";
		String offset          = jsonObject.get("offset")       != null ? (String) jsonObject.get("offset") : "";
		String userId          = jsonObject.get("userId")       != null ? (String) jsonObject.get("userId") : "";
		String folderName      = jsonObject.get("fName")        != null ? (String) jsonObject.get("fName")  : "";
		String folderName2     = jsonObject.get("fName2")       != null ? (String) jsonObject.get("fName2") : "";
		String folderUsers     = jsonObject.get("fUsers")       != null ? (String) jsonObject.get("fUsers") : "";
		JSONObject result      = new JSONObject();
		
		if (folderId.equals("") || userId.equals("") || folderUsers.equals("") || folderName.equals("") || offset.equals("") || serverName.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", "1");
			return result;
		}
		
		logger.debug("serverName: " + serverName + " || folderName: " + folderName + " || folderID: " + folderId);
		
		try {
			int tenantId    = loginService.getTenantId(serverName);
			FolderVO folder = ezWebFolderService.getFolderByFolderId(folderId, offset, tenantId);
			
			if (folder == null) {
				logger.debug("Folder not found!");
				result.put("status", "error");
				result.put("code", "1");
				return result;
			}
			
			String folderPath          = folder.getFolderPath();
			folderPath                 = folderPath.substring(1, folderPath.length() - 1);
			String ancestorId          = folderPath.split("\\|")[1];
			SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			Date date                  = new Date();
			String timeUTC             = commonUtil.getDateStringInUTC(formatter.format(date), offset, true);
			
			if (ancestorId.equals(folderId)) {
				JSONObject json            = (JSONObject) parser.parse(folderUsers);
				JSONArray userArray        = (JSONArray)json.get("user");
				JSONArray deptArray        = (JSONArray)json.get("dept");
				
				//Delete all folder users
				ezWebFolderAdminService.deleteFolderUsers(folderId, tenantId);
				
				for (int i = 0; i < userArray.size(); i++) {
					ezWebFolderAdminService.insertFolderUser(getMaxFolderUserSeq(tenantId), (String)userArray.get(i), "user", folderId, userId, timeUTC, folder.getCompanyId(), tenantId);
				}
				
				for (int i = 0; i < deptArray.size(); i++) {
					ezWebFolderAdminService.insertFolderUser(getMaxFolderUserSeq(tenantId), (String)deptArray.get(i), "dept", folderId, userId, timeUTC, folder.getCompanyId(), tenantId);
				}
			}
			
			folder.setFolderName1(folderName);
			folder.setFolderName2(folderName2);
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

	@RequestMapping(value="/rest/ezwebfolder/foldersTree", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getFolderTree(HttpServletRequest request) {
		String offset     = request.getParameter("offset")     != null ? request.getParameter("offset")                     : "";
		String rootFolder = request.getParameter("rootFolder") != null ? request.getParameter("rootFolder")                 : "";
		String fileId     = request.getParameter("fileId")     != null ? request.getParameter("fileId")                     : "";
		String folderId   = request.getParameter("folderId")   != null ? request.getParameter("folderId")                   : "";
		String serverName = request.getHeader("host-name")     != null ? request.getHeader("host-name")                     : "";
		JSONObject result = new JSONObject();
		
		if (offset.equals("") || serverName.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", "1");
			return result;
		}
		
		logger.debug("fileId: " + fileId + " || folderId: " + folderId + " || RootFolder: " + rootFolder + " || serverName: " + serverName + " || Offset: " + offset);
		
		try {
			int tenantId = loginService.getTenantId(serverName);
			
			
			if (fileId.equals("")) {
				if (rootFolder.equals("")) {
					//회사폴더
					FolderVO folder = ezWebFolderService.getFolderByFolderId(folderId, offset, tenantId);
					List<FolderSimpleVO> listFolders = ezWebFolderService.getAllSimpleDeptFolder(folder.getCompanyId(), tenantId);
					result.put("currentFolder", "");
					result.put("data", listFolders);
				}
				else {
					FolderSimpleVO company = ezWebFolderService.getSimpleFolder(rootFolder, tenantId);
					ezWebFolderService.getAllSubDepts(company, tenantId, 2);
					result.put("currentFolder", "");
					result.put("data", company);
				}
			}
			else {
				FolderSimpleVO company  = ezWebFolderService.getSimpleFolder(rootFolder, tenantId);
				FileVO file             = ezWebFolderService.getFileByFileId(fileId, offset, tenantId);
				FolderVO selectedFolder = ezWebFolderService.getFolderByFolderId(file.getFolderId(), offset, tenantId);
				String folderPath       = selectedFolder.getFolderPath();
				folderPath              = folderPath.substring(1, folderPath.length() - 1);
				String[] path           = folderPath.split("\\|");
				ezWebFolderService.getAllSubDepts(company, tenantId, path, 1);
				result.put("currentFolder", file.getFolderId());
				result.put("data", company);
			}
			
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

	@RequestMapping(value="/rest/ezwebfolder/depart-tree", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getDeptTree(HttpServletRequest request) {
		String companyId  = request.getParameter("companyId")!= null ? request.getParameter("companyId") : "";
		String deptId     = request.getParameter("deptId")   != null ? request.getParameter("deptId")    : "";
		String userId     = request.getParameter("userId")   != null ? request.getParameter("userId")    : "";
		String primary    = request.getParameter("primary")  != null ? request.getParameter("primary")   : "";
		String serverName = request.getHeader("host-name")   != null ? request.getHeader("host-name")    : "";
		JSONObject result = new JSONObject();
		
		if (companyId.equals("") || primary.equals("") || serverName.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", "1");
			return result;
		}
		
		logger.debug("CompanyId: " + companyId + " || serverName: " + serverName + " || Primary: " + primary);
		
		try {
			LoginVO userInfo      = commonUtil.getUserForGw(userId, serverName, primary, "");
			int tenantId          = userInfo.getTenantId();
			deptId                = deptId.equals("") ? userInfo.getDeptID() : deptId;
			SimpleDeptVO sCompany = null;
			
			if (deptId.equals("")) {
				sCompany = ezWebFolderService.getAllDepts(companyId, 0, primary, tenantId);
			}
			else {
				String deptPath  = ezWebFolderService.getDeptPath(deptId, tenantId);
				String[] path    = deptPath.split(",");
				sCompany         = ezWebFolderService.getSimpleCompany(companyId, 0, primary, tenantId);
				
				ezWebFolderService.getAllDepts(sCompany, path, primary, tenantId, 1, 1);
			}
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", sCompany);
			result.put("userDept", deptId);
		} 
		catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		
		return result;
	}

	@RequestMapping(value="/rest/ezwebfolder/sub-tree/{deptid}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getSubTree(@PathVariable(value="deptid") String deptId, HttpServletRequest request) {
		String serverName = request.getHeader("host-name")   != null ? request.getHeader("host-name")                     : "";
		int level         = request.getParameter("level")    != null ? Integer.parseInt(request.getParameter("level"))    : -1;
		String primary    = request.getParameter("primary")  != null ? request.getParameter("primary")                    : "";
		JSONObject result = new JSONObject();
		
		logger.debug("deptId: " + deptId + " || level: " + level + " || serverName: " + serverName);
		
		if (deptId.equals("") || primary.equals("") || serverName.equals("") || level == -1) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", "1");
			return result;
		}
		
		try {
			int tenantId       = loginService.getTenantId(serverName);
			SimpleDeptVO sDept = ezWebFolderService.getAllDepts(deptId, level, primary, tenantId);
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", sDept);
		} 
		catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezwebfolder/dept-member/{deptid}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getAllDeptMembers(@PathVariable(value="deptid") String deptId, HttpServletRequest request) {
		String serverName = request.getHeader("host-name")   != null ? request.getHeader("host-name")  : "";
		String primary    = request.getParameter("primary")  != null ? request.getParameter("primary") : "";
		JSONObject result = new JSONObject();
		
		logger.debug("deptId: " + deptId + " || serverName: " + serverName);
		
		if (deptId.equals("") || primary.equals("") || serverName.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", "1");
			return result;
		}
		
		try {
			int tenantId                   = loginService.getTenantId(serverName);
			List<SimpleUserVO> listMembers = ezWebFolderService.getDeptMemberList(deptId, primary, tenantId);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", listMembers);
		} 
		catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezwebfolderadmin/foldersTree/dept", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getDeptFolderTree(HttpServletRequest request) {
		String serverName = request.getHeader("host-name")    != null ? request.getHeader("host-name")    : "";
		String offset     = request.getParameter("offset")    != null ? request.getParameter("offset")    : "";
		String companyId  = request.getParameter("companyId") != null ? request.getParameter("companyId") : "";
		String folderId   = request.getParameter("folderId")  != null ? request.getParameter("folderId")  : "";
		JSONObject result = new JSONObject();
		
		if (companyId.equals("") || offset.equals("") || serverName.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", "1");
			return result;
		}
		
		logger.debug("CompanyId: " + companyId + " || serverName: " + serverName + " || Offset: " + offset);
		
		try {
			int tenantId                     = loginService.getTenantId(serverName);
			List<FolderSimpleVO> listFolders = ezWebFolderService.getAllSimpleDeptFolder(companyId, tenantId);
			
			if (!folderId.equals("")) {
				FolderVO selectedFolder = ezWebFolderService.getFolderByFolderId(folderId, offset, tenantId);
				String folderPath       = selectedFolder.getFolderPath();
				folderPath              = folderPath.substring(1, folderPath.length() - 1);
				String[] path           = folderPath.split("\\|");
				
				for (FolderSimpleVO deptFolder : listFolders) {
					if (deptFolder.getFolderId().equals(path[0])) {
						ezWebFolderService.getAllSubDepts(deptFolder, tenantId, path, 1);
					}
				}
				
			}
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", listFolders);
		} 
		catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezwebfolderadmin/foldersTree", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getCompanyFolderTree(HttpServletRequest request) {
		String serverName = request.getHeader("host-name")    != null ? request.getHeader("host-name")    : "";
		String offset     = request.getParameter("offset")    != null ? request.getParameter("offset")    : "";
		String companyId  = request.getParameter("companyId") != null ? request.getParameter("companyId") : "";
		String folderId   = request.getParameter("folderId")  != null ? request.getParameter("folderId")  : "";
		JSONObject result = new JSONObject();
		
		if (companyId.equals("") || offset.equals("") || serverName.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", "1");
			return result;
		}
		
		logger.debug("CompanyId: " + companyId + " || serverName: " + serverName + " || Offset: " + offset);
		
		try {
			int tenantId           = loginService.getTenantId(serverName);
			FolderVO folderVO      = ezWebFolderService.getCompanyFolderId(companyId, offset, tenantId);
			
			if (folderVO == null) {
				result.put("status", "ok");
				result.put("code", 0);
				result.put("data", folderVO);
				return result;
			}
			
			FolderSimpleVO company = ezWebFolderService.getSimpleFolder(folderVO.getFolderId(), tenantId);
			
			if (folderId.equals("")) {
				ezWebFolderService.getAllSubDepts(company, tenantId, 2);
			}
			else {
				FolderVO selectedFolder = ezWebFolderService.getFolderByFolderId(folderId, offset, tenantId);
				String folderPath       = selectedFolder.getFolderPath();
				folderPath              = folderPath.substring(1, folderPath.length() - 1);
				String[] path           = folderPath.split("\\|");
				ezWebFolderService.getAllSubDepts(company, tenantId, path, 1);
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

	@RequestMapping(value="/rest/ezwebfolderadmin/subfolder-tree/{folderid}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getSubFoldersTree(@PathVariable(value="folderid") String folderId, HttpServletRequest request) {
		String serverName = request.getHeader("host-name")   != null ? request.getHeader("host-name")  : "";
		JSONObject result = new JSONObject();
		
		logger.debug("folderId: " + folderId + " || serverName: " + serverName);
		
		if (folderId.equals("") || serverName.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", "1");
			return result;
		}
		
		try {
			int tenantId          = loginService.getTenantId(serverName);
			FolderSimpleVO folder = ezWebFolderService.getSimpleFolder(folderId, tenantId);
			ezWebFolderService.getAllSubDepts(folder, tenantId, 1);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", folder);
		} 
		catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		
		return result;
	}

	@RequestMapping(value="/rest/ezwebfolderadmin/folder-users/{folderid}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getFolderUsers(@PathVariable(value="folderid") String folderId, HttpServletRequest request) {
		String serverName = request.getHeader("host-name")   != null ? request.getHeader("host-name") : "";
		String offset     = request.getParameter("offset")   != null ? request.getParameter("offset") : "";
		String mode       = request.getParameter("mode")     != null ? request.getParameter("mode")   : "";
		String userId     = request.getParameter("userId")   != null ? request.getParameter("userId") : "";
		JSONObject result = new JSONObject();
		
		logger.debug("folderId: " + folderId + " || serverName: " + serverName);
		
		if (folderId.equals("") || serverName.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", "1");
			return result;
		}
		
		try {
			List<FolderUserVO> listUsers = new ArrayList<FolderUserVO>();
			
			if (mode.equals("")) {
				int tenantId      = loginService.getTenantId(serverName);
				FolderVO folder   = ezWebFolderService.getFolderByFolderId(folderId, offset, tenantId);
				String folderPath = folder.getFolderPath();
				folderPath        = folderPath.substring(1, folderPath.length() - 1);
				String ancestorId = folderPath.split("\\|")[1];
				listUsers         = ezWebFolderService.getFolderUsers(ancestorId, tenantId);
			}
			else {
				LoginVO userInfo  = commonUtil.getUserForGw(userId, serverName, "", "");
				int tenantId      = userInfo.getTenantId();
				listUsers         = ezWebFolderService.getFolderUsers(folderId, tenantId);
				
				if (listUsers == null || listUsers.size() == 0) {
					FolderVO folder            = ezWebFolderService.getFolderByFolderId(folderId, offset, tenantId);
					String deptId              = folder.getOwnerId();
					SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
					Date date                  = new Date();
					String timeUTC             = commonUtil.getDateStringInUTC(formatter.format(date), offset, true);
					ezWebFolderAdminService.insertFolderUser(getMaxFolderUserSeq(tenantId), deptId, "dept", folderId, userId, timeUTC, folder.getCompanyId(), tenantId);
					listUsers = ezWebFolderService.getFolderUsers(folderId, tenantId);
				}
			}
			
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

	@RequestMapping(value="/rest/ezwebfolderadmin/folders/{folderid}", method= RequestMethod.DELETE, produces="application/json;charset=utf-8")
	public JSONObject delCompanyFolder(@PathVariable(value="folderid") String folderId, HttpServletRequest request) throws Exception {
		String serverName = request.getHeader("host-name")   != null ? request.getHeader("host-name") : "";
		String offset     = request.getParameter("offset")   != null ? request.getParameter("offset") : "";
		JSONObject result = new JSONObject();
		
		if (folderId.equals("") || serverName.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", "1");
			return result;
		}
		
		logger.debug("FolderId: " + folderId + " || serverName: " + serverName);
		
		try {
			int tenantId    = loginService.getTenantId(serverName);
			FolderVO folder = ezWebFolderService.getFolderByFolderId(folderId, offset, tenantId);
			ezWebFolderService.updateFolderUseStatus(folder.getFolderPath(), tenantId);
			
			result.put("status", "ok");
			result.put("code", 0);
		}
		catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
		}
		
		return result;
	}

	@RequestMapping(value="/rest/ezwebfolderadmin/folders/{folderid}/modes/{mode}/folder-move", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject putCompanyFolderMove(@PathVariable(value="folderid") String folderId, @PathVariable(value="mode") String mode, Locale locale, HttpServletRequest request) throws Exception {
		String serverName   = request.getHeader("host-name")    != null ? request.getHeader("host-name")    : "";
		String offset       = request.getParameter("offset")    != null ? request.getParameter("offset")    : "";
		String primary      = request.getParameter("primary")   != null ? request.getParameter("primary")   : "";
		String userId       = request.getParameter("userId")    != null ? request.getParameter("userId")    : "";
		String destFolderId = request.getParameter("parentFld") != null ? request.getParameter("parentFld") : "";
		JSONObject result   = new JSONObject();
		
		logger.debug("FolderID: " + folderId + " || serverName: " + serverName + " || destination: " + destFolderId + " || offset: " + offset + " || mode: " + mode);
		
		if (folderId.equals("") || serverName.equals("") || destFolderId.equals("") || offset.equals("") || mode.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", "1");
			return result;
		}
		
		try {
			int tenantId    = loginService.getTenantId(serverName);
			FolderVO folder = ezWebFolderService.getFolderByFolderId(folderId, offset, tenantId);
			
			//Check copy/move conditions
			if (folder.getFolderUpper().equals(destFolderId)) {
				result.put("status", "error");
				result.put("reason", egovMessageSource.getMessage("ezWebFolder.t224", locale));
				result.put("code", 1);
				return result;
			}
			
			List<FolderVO> listSubFolder = ezWebFolderService.getAllSubFolders(folderId, offset, tenantId);
			
			for (FolderVO subFld : listSubFolder) {
				if (subFld.getFolderId().equals(destFolderId)) {
					result.put("status", "error");
					result.put("reason", "Cannot move/copy to a sub folder!");
					result.put("code", 1);
					return result;
				}
			}
			
			if (mode.equals("move")) {
				moveFolder(folder, listSubFolder, destFolderId, userId, offset, tenantId);
			}
			else {
				copyFolder(folder, listSubFolder, destFolderId, userId, primary, offset, tenantId);
			}
			
			result.put("status", "ok");
			result.put("code", 0);
		}
		catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
		}
		
		return result;
	}

	@RequestMapping(value="/rest/ezwebfolderadmin/folders/{folderid}/file-list", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getFileList(@PathVariable(value="folderid") String folderId, HttpServletRequest request) {
		String serverName = request.getHeader("host-name")      != null ? request.getHeader("host-name")                        : "";
		String offset     = request.getParameter("offset")      != null ? request.getParameter("offset")                        : "";
		String primary    = request.getParameter("primary")     != null ? request.getParameter("primary")                       : "";
		String startDate  = request.getParameter("startDate")   != null ? request.getParameter("startDate")                     : "";
		String endDate    = request.getParameter("endDate")     != null ? request.getParameter("endDate")                       : "";
		String fileExt    = request.getParameter("fileExt")     != null ? request.getParameter("fileExt")                       : "";
		String fileName   = request.getParameter("fileName")    != null ? request.getParameter("fileName")                      : "";
		String userName   = request.getParameter("userName")    != null ? request.getParameter("userName")                      : "";
		String fileType   = request.getParameter("fileType")    != null ? request.getParameter("fileType")                      : "";
		String searchChk  = "1";
		int currPage      = request.getParameter("currentPage") != null ? Integer.parseInt(request.getParameter("currentPage")) :  1;
		int totalRows     = 0;
		int totalPages    = 0;
		int pageSize      = 10;
		int startPoint    = (currPage - 1) * pageSize;
		
		JSONObject result = new JSONObject();
		
		if (folderId.equals("") || serverName.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", "1");
			return result;
		}
		
		logger.debug("FolderId: " + folderId + " || serverName: " + serverName);
		
		try {
			int tenantId = loginService.getTenantId(serverName);
					
			if (startDate.equals("") && endDate.equals("") && fileExt.equals("") && fileName.equals("") && userName.equals("")) {
				searchChk = "0";
			}
			
			if (searchChk.equals("1")) {
				if (startDate.equals("")) {
					//Get logs in three months
					SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
					Date now             = new Date();
					Calendar cal         = Calendar.getInstance();
					cal.setTime(now);
					cal.add(Calendar.MONTH, -3);
					
					startDate = commonUtil.getDateStringInUTC(sdf.format(cal.getTime()), offset, true);
					endDate = commonUtil.getDateStringInUTC(sdf.format(now), offset, true);
				}
				else {
					String startDateTmp = startDate + " 00:00:00";
					String endDateTmp   = endDate + " 23:59:59";
					startDate           = commonUtil.getDateStringInUTC(startDateTmp, offset, true);
					endDate             = commonUtil.getDateStringInUTC(endDateTmp, offset, true);
				}
			}
			
			logger.debug("SearchChk: " + searchChk + " || StartDate in UTC: " + startDate + " || EndDate in UTC: " + endDate);
			
			List<FileVO> fileList = new ArrayList<FileVO>();
			FolderVO folder       = ezWebFolderService.getFolderByFolderId(folderId, offset, tenantId);
			String folderPath     = folder.getFolderPath();
			folderPath            = folderPath.substring(1, folderPath.length() - 1);
			String originalPath   = getFolderPath(folderPath.split("\\|"), offset, tenantId) + folder.getFolderName1() + "/";
			
			if (folder.getFolderUpper().equals("root")) {
				Map<String, String> filePathMap = new LinkedHashMap<String, String>();
				fileList                        = ezWebFolderService.getAllFiles(folder.getFolderPath(), originalPath, searchChk, startDate, endDate, fileExt, fileName, userName, fileType, startPoint, pageSize, primary, offset, tenantId);
				totalRows                       = ezWebFolderService.getTotalFileCnt2(folder.getFolderPath(), searchChk, startDate, endDate, fileExt, fileName, userName, fileType, startPoint, pageSize, primary, tenantId);
				String []rootPath               = folderPath.split("\\|");
				
				for (FileVO file : fileList) {
					if (file.getFilePosition().equals("")) {
						String file_path    = originalPath;
						String fldPath      = file.getFolderPath().substring(1, file.getFolderPath().length() - 1);
						String[] fldPathArr = fldPath.split("\\|");
						
						for (int i = rootPath.length; i < fldPathArr.length - 1; i++) {
							if (filePathMap.containsKey(fldPathArr[i])) {
								file_path += filePathMap.get(fldPathArr[i]) + "/";
							}
							else {
								FolderVO _folder = ezWebFolderService.getFolderByFolderId(fldPathArr[i], offset, tenantId);
								file_path       += _folder.getFolderName1() + "/";
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
	
	@RequestMapping(value="/rest/ezwebfolderadmin/company-id/{userid}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getCompanyId(@PathVariable(value="userid") String userId, HttpServletRequest request) {
		String serverName = request.getHeader("host-name")   != null ? request.getHeader("host-name") : "";
		String offset     = request.getParameter("offset")   != null ? request.getParameter("offset") : "";
		String lang       = request.getParameter("lang")     != null ? request.getParameter("lang")   : "";
		JSONObject result = new JSONObject();
		logger.debug("serverName: " + serverName + " || Offset: " + offset + " || Lang: " + lang);
		
		if (serverName.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			return result;
		}
		
		try {
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName, lang, offset);
			
			result.put("data", userInfo.getCompanyID());
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
	
	@RequestMapping(value="/rest/ezwebfolderadmin/company-list/{userid}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getCompanyList(@PathVariable(value="userid") String userId, HttpServletRequest request) {
		String serverName = request.getHeader("host-name")   != null ? request.getHeader("host-name") : "";
		String offset     = request.getParameter("offset")   != null ? request.getParameter("offset") : "";
		String lang       = request.getParameter("lang")     != null ? request.getParameter("lang")   : "";
		JSONObject result = new JSONObject();
		logger.debug("serverName: " + serverName + " || Offset: " + offset + " || Lang: " + lang);
		
		if (serverName.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			return result;
		}
		
		try {
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName, lang, offset);
			
			//Get list of companies
			List<OrganDeptVO> list       = ezOrganAdminService.getCompanyList(userInfo.getPrimary(), userInfo.getTenantId());
			List<OrganDeptVO> resultList = new ArrayList<OrganDeptVO>();
			int j = 0;
			
			for (int i = 0; i < list.size(); i++) {
				OrganDeptVO vo = list.get(i);
				
				if (userInfo.getRollInfo().indexOf("c=1") > -1 || vo.getCn().equals(userInfo.getCompanyID())) {
					resultList.add(j++, vo);
				}
			}
			
			result.put("data", resultList);
			result.put("userCompany", userInfo.getCompanyID());
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
	
	@RequestMapping(value="/rest/ezwebfolderadmin/folders/dept", method= RequestMethod.POST, produces="application/json;charset=utf-8")
	public JSONObject postDeptFolderInsert(@RequestBody JSONObject jsonObject, HttpServletRequest request) throws ParseException {
		JSONParser parser      = new JSONParser();
		jsonObject             = (JSONObject) parser.parse(jsonObject.toJSONString());
		String serverName      = request.getHeader("host-name") != null ? request.getHeader("host-name")       : "";
		String offset          = jsonObject.get("offset")       != null ? (String) jsonObject.get("offset")    : "";
		String userId          = jsonObject.get("userId")       != null ? (String) jsonObject.get("userId")    : "";
		String lang            = jsonObject.get("lang")         != null ? (String) jsonObject.get("lang")      : "";
		String pFolderId       = jsonObject.get("pFolderId")    != null ? (String) jsonObject.get("pFolderId") : "";
		String folderName      = jsonObject.get("fName")        != null ? (String) jsonObject.get("fName")     : "";
		String folderName2     = jsonObject.get("fName2")       != null ? (String) jsonObject.get("fName2")    : "";
		JSONObject result      = new JSONObject();
		
		if (pFolderId.equals("") || userId.equals("") || lang.equals("") || folderName.equals("") || offset.equals("") || serverName.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", "1");
			return result;
		}
		
		logger.debug("serverName: " + serverName + " || folderName: " + folderName + " || ParentFolderID: " + pFolderId);
		
		try {
			LoginVO userInfo           = commonUtil.getUserForGw(userId, serverName, lang, offset);
			String userName1           = userInfo.getDisplayName1();
			String userName2           = userInfo.getDisplayName2();
			int tenantId               = userInfo.getTenantId();
			FolderVO parentFolder      = ezWebFolderService.getFolderByFolderId(pFolderId, offset, tenantId);
			FolderVO folder            = new FolderVO();
			SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			Date date                  = new Date();
			String timeUTC             = commonUtil.getDateStringInUTC(formatter.format(date), offset, true);
			String folderId            = getMaxFolderID(tenantId);
			
			folder.setFolderId(folderId);
			folder.setFolderLevel(parentFolder.getFolderLevel() + 1);
			folder.setFolderName1(folderName);
			folder.setFolderName2(folderName2);
			folder.setFolderPath(parentFolder.getFolderPath() + folderId + "|");
			folder.setFolderStep(getMaxFolderStep(pFolderId, tenantId));
			folder.setFolderType("D");
			folder.setFolderUpper(parentFolder.getFolderId());
			folder.setOwnerId(parentFolder.getOwnerId());
			folder.setUseStatus("Y");
			folder.setUpdateId(userId);
			folder.setCreateName1(userName1);
			folder.setCreateName2(userName2);
			folder.setTenantId(tenantId);
			folder.setCompanyId(parentFolder.getCompanyId());
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
	
	@RequestMapping(value="/rest/ezwebfolderadmin/folders/{folderid}/dept", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject putDeptFolderUpdate(@RequestBody JSONObject jsonObject, @PathVariable(value="folderid") String folderId, HttpServletRequest request) throws ParseException {
		JSONParser parser      = new JSONParser();
		jsonObject             = (JSONObject) parser.parse(jsonObject.toJSONString());
		String serverName      = request.getHeader("host-name") != null ? request.getHeader("host-name")    : "";
		String offset          = jsonObject.get("offset")       != null ? (String) jsonObject.get("offset") : "";
		String userId          = jsonObject.get("userId")       != null ? (String) jsonObject.get("userId") : "";
		String folderName      = jsonObject.get("fName")        != null ? (String) jsonObject.get("fName")  : "";
		String folderName2     = jsonObject.get("fName2")       != null ? (String) jsonObject.get("fName2") : "";
		JSONObject result      = new JSONObject();
		
		if (folderId.equals("") || userId.equals("") || folderName.equals("") || offset.equals("") || serverName.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", "1");
			return result;
		}
		
		logger.debug("serverName: " + serverName + " || folderName: " + folderName + " || folderID: " + folderId);
		
		try {
			int tenantId               = loginService.getTenantId(serverName);
			FolderVO folder            = ezWebFolderService.getFolderByFolderId(folderId, offset, tenantId);
			SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			Date date                  = new Date();
			String timeUTC             = commonUtil.getDateStringInUTC(formatter.format(date), offset, true);
			
			folder.setFolderName1(folderName);
			folder.setFolderName2(folderName2);
			folder.setUpdateId(userId);
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
	
	@RequestMapping(value="rest/ezwebfolderadmin/company-folder/{companyid}", method= RequestMethod.POST, produces="application/json;charset=utf-8")
	public JSONObject postMakeCompanyFolder(@PathVariable(value="companyid") String companyId, HttpServletRequest request) throws Exception {
		String serverName   = request.getHeader("host-name")    != null ? request.getHeader("host-name")    : "";
		String offset       = request.getParameter("offset")    != null ? request.getParameter("offset")    : "";
		String primary      = request.getParameter("primary")   != null ? request.getParameter("primary")   : "";
		String userId       = request.getParameter("userId")    != null ? request.getParameter("userId")    : "";
		JSONObject result   = new JSONObject();
		
		logger.debug("serverName: " + serverName + " || offset: " + offset + " || companyId: " + companyId);
		
		if (serverName.equals("") || offset.equals("") || companyId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", "1");
			return result;
		}
		
		try {
			LoginVO userInfo           = commonUtil.getUserForGw(userId, serverName, primary, offset);
			int tenantId               = userInfo.getTenantId();
			OrganDeptVO company        = ezOrganService.getDeptInfo(companyId, primary, tenantId);
			FolderVO folder            = new FolderVO();
			SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			Date date                  = new Date();
			String timeUTC             = commonUtil.getDateStringInUTC(formatter.format(date), offset, true);
			String folderId            = getMaxFolderID(tenantId);
			
			folder.setFolderId(folderId);
			folder.setFolderLevel(0);
			folder.setFolderName1(company.getDisplayName1());
			folder.setFolderName2(company.getDisplayName2());
			folder.setFolderPath("|" + folderId + "|");
			folder.setFolderStep(0);
			folder.setFolderType("C");
			folder.setFolderUpper("root");
			folder.setOwnerId(company.getCn());
			folder.setUseStatus("Y");
			folder.setUpdateId(userId);
			folder.setCreateName1(userInfo.getDisplayName1());
			folder.setCreateName2(userInfo.getDisplayName2());
			folder.setTenantId(tenantId);
			folder.setCompanyId(company.getCn());
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
		}
		
		return result;
	}
	
	@RequestMapping(value="rest/ezwebfolderadmin/dept-folder/{companyid}", method= RequestMethod.POST, produces="application/json;charset=utf-8")
	public JSONObject postMakeDepartmentFolder(@PathVariable(value="companyid") String companyId, HttpServletRequest request) throws Exception {
		String serverName   = request.getHeader("host-name")    != null ? request.getHeader("host-name")    : "";
		String offset       = request.getParameter("offset")    != null ? request.getParameter("offset")    : "";
		String primary      = request.getParameter("primary")   != null ? request.getParameter("primary")   : "";
		String userId       = request.getParameter("userId")    != null ? request.getParameter("userId")    : "";
		JSONObject result   = new JSONObject();
		
		logger.debug("serverName: " + serverName + " || offset: " + offset + " || companyId: " + companyId);
		
		if (serverName.equals("") || offset.equals("") || companyId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", "1");
			return result;
		}
		
		try {
			LoginVO userInfo            = commonUtil.getUserForGw(userId, serverName, primary, offset);
			int tenantId                = userInfo.getTenantId();
			SimpleDateFormat formatter  = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			Date date                   = new Date();
			String timeUTC              = commonUtil.getDateStringInUTC(formatter.format(date), offset, true);
			
			List<OrganDeptVO> listDepts = ezWebFolderService.getAllDepartments(companyId, primary, tenantId);
			
			logger.debug("List length: " + listDepts.size());
			
			for (OrganDeptVO dept : listDepts) {
				FolderVO folder = new FolderVO();
				String folderId = getMaxFolderID(tenantId);
				
				folder.setFolderId(folderId);
				folder.setFolderLevel(0);
				folder.setFolderName1(dept.getDisplayName1());
				folder.setFolderName2(dept.getDisplayName2());
				folder.setFolderPath("|" + folderId + "|");
				folder.setFolderStep(0);
				folder.setFolderType("D");
				folder.setFolderUpper("root");
				folder.setOwnerId(dept.getCn());
				folder.setUseStatus("Y");
				folder.setUpdateId(userId);
				folder.setCreateName1(userInfo.getDisplayName1());
				folder.setCreateName2(userInfo.getDisplayName2());
				folder.setTenantId(tenantId);
				folder.setCompanyId(companyId);
				folder.setCreateId(userId);
				folder.setCreateDate(timeUTC);
				folder.setUpdateDate(timeUTC);
				
				ezWebFolderAdminService.insertFolder(folder);
			}
			
			result.put("status", "ok");
			result.put("code", 0);
		}
		catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
		}
		
		return result;
	}
	
	private String getFolderPath(String[] path, String offset, int tenantId) throws Exception {
		String result = "/";
		
		for (int i = 0; i < path.length - 1; i++) {
			FolderVO parentFolder = ezWebFolderService.getFolderByFolderId(path[i], offset, tenantId);
			result               += parentFolder.getFolderName1() + "/";
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
		currentMaxFileId     = (currentMaxFileId == -1) ? 1 : (currentMaxFileId + 1);
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
		currentMaxFolderId     = result.equals("")          ? 1 : Integer.parseInt(result);
		currentMaxFolderId     = (currentMaxFolderId == -1) ? 1 : (currentMaxFolderId + 1);
		return Integer.toString(currentMaxFolderId);
	}
	
	private int getMaxFolderStep(String folderId, int tenantId) throws Exception {
		int currentMaxStep = -1;
		String result      = ezWebFolderService.getMaxFolderStep(folderId, tenantId);
		currentMaxStep     = result.equals("")        ? 1 : Integer.parseInt(result);
		currentMaxStep     = (currentMaxStep == -1)   ? 1 : (currentMaxStep + 1);
		return currentMaxStep;
	}
	
	private String getMaxFolderUserSeq(int tenantId) throws Exception {
		int currentMaxolderUserId  = -1;
		String result              = ezWebFolderService.getFolderUserSequence(tenantId);
		currentMaxolderUserId      = result.equals("")             ? 1 : Integer.parseInt(result);
		currentMaxolderUserId	   = (currentMaxolderUserId == -1) ? 1 : (currentMaxolderUserId + 1);
		return Integer.toString(currentMaxolderUserId);
	}
	
	private void moveFolder(FolderVO folder, List<FolderVO> listSubFolder, String destFolderId, String userId, String offset, int tenantId) throws Exception {
		FolderVO parentFolder      = ezWebFolderService.getFolderByFolderId(destFolderId, offset, tenantId);
		String oldPath             = folder.getFolderPath();
		String newPath             = parentFolder.getFolderPath() + folder.getFolderId() + "|";
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date date                  = new Date();
		String timeUTC             = commonUtil.getDateStringInUTC(formatter.format(date), offset, true);
		int levelDistance          = parentFolder.getFolderLevel() + 1 - folder.getFolderLevel();
		
		if (folder.getFolderLevel() == 1) {
			//Delete all folder users
			ezWebFolderAdminService.deleteFolderUsers(folder.getFolderId(), tenantId);
		}
		
		if (folder.getFolderLevel() + levelDistance == 1) {
			String folderPath = folder.getFolderPath();
			folderPath	      = folderPath.substring(1, folderPath.length() - 1);
			String ancestorId = folderPath.split("\\|")[1];
			
			List<FolderUserVO> listUsers = ezWebFolderService.getFolderUsers(ancestorId, tenantId);
			
			for (FolderUserVO folderUser: listUsers) {
				ezWebFolderAdminService.insertFolderUser(getMaxFolderUserSeq(tenantId), folderUser.getUserId(), folderUser.getUserType(), folder.getFolderId(), userId, timeUTC, folder.getCompanyId(), tenantId);
			}
		}
		
		folder.setFolderPath(newPath);
		folder.setUpdateId(userId);
		folder.setUpdateDate(timeUTC);
		folder.setFolderUpper(destFolderId);
		folder.setFolderLevel(folder.getFolderLevel() + levelDistance);
		folder.setFolderStep(getMaxFolderStep(destFolderId, tenantId));
		ezWebFolderAdminService.insertFolder(folder);
		
		for (FolderVO subFld : listSubFolder) {
			String folderPath = subFld.getFolderPath();
			folderPath        = folderPath.replace(oldPath, newPath);
			subFld.setFolderPath(folderPath);
			subFld.setUpdateDate(timeUTC);
			subFld.setUpdateId(userId);
			subFld.setFolderLevel(subFld.getFolderLevel() + levelDistance);
			
			//Update Folder
			ezWebFolderAdminService.insertFolder(subFld);
		}
	}
	
	private void copyFolder(FolderVO folder, List<FolderVO> listSubFolder, String destFolderId, String userId, String primary, String offset, int tenantId) throws Exception {
		FolderVO parentFolder      = ezWebFolderService.getFolderByFolderId(destFolderId, offset, tenantId);
		String folderId            = folder.getFolderId();
		String oldPath             = folder.getFolderPath();
		String newId               = getMaxFolderID(tenantId);
		String newPath             = parentFolder.getFolderPath() + newId + "|";
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date date                  = new Date();
		String timeUTC             = commonUtil.getDateStringInUTC(formatter.format(date), offset, true);
		int levelDistance          = parentFolder.getFolderLevel() + 1 - folder.getFolderLevel();
		
		if (folder.getFolderLevel() + levelDistance == 1) {
			String folderPath = folder.getFolderPath();
			folderPath        = folderPath.substring(1, folderPath.length() - 1);
			String ancestorId = folderPath.split("\\|")[1];
			
			List<FolderUserVO> listUsers = ezWebFolderService.getFolderUsers(ancestorId, tenantId);
			
			for (FolderUserVO folderUser: listUsers) {
				ezWebFolderAdminService.insertFolderUser(getMaxFolderUserSeq(tenantId), folderUser.getUserId(), folderUser.getUserType(), folder.getFolderId(), userId, timeUTC, folder.getCompanyId(), tenantId);
			}
		}
		
		folder.setFolderPath(newPath);
		folder.setUpdateId(userId);
		folder.setUpdateDate(timeUTC);
		folder.setFolderUpper(destFolderId);
		folder.setFolderLevel(folder.getFolderLevel() + levelDistance);
		folder.setFolderStep(getMaxFolderStep(destFolderId, tenantId));
		folder.setFolderId(newId);
		
		ezWebFolderAdminService.insertFolder(folder);
		copyFile(folderId, userId, newId, timeUTC, primary, offset, tenantId);
		
		for (int i = 0; i < listSubFolder.size(); i++) {
			FolderVO subFld   = listSubFolder.get(i);
			String oldId      = subFld.getFolderId();
			String newSubId   = getMaxFolderID(tenantId);
			String folderPath = subFld.getFolderPath();
			folderPath        = folderPath.replace(oldPath, newPath);
			folderPath        = folderPath.replace("|" + subFld.getFolderId() + "|", "|" + newSubId + "|");
			
			subFld.setFolderPath(folderPath);
			subFld.setUpdateDate(timeUTC);
			subFld.setUpdateId(userId);
			subFld.setFolderLevel(subFld.getFolderLevel() + levelDistance);
			subFld.setFolderId(newSubId);
			
			folderPath           = folderPath.substring(1, folderPath.length() - 1);
			String[] folderArry  = folderPath.split("\\|");
			String upperFolderId = folderArry[folderArry.length - 2];
			
			subFld.setFolderUpper(upperFolderId);
			
			//Update Folder
			ezWebFolderAdminService.insertFolder(subFld);
			copyFile(oldId, userId, newSubId, timeUTC, primary, offset, tenantId);
		}
	}
	
	private void copyFile(String folderId, String userId, String newId, String timeUTC, String primary, String offset, int tenantId) throws Exception {
		List<FileVO> fileList = ezWebFolderService.getAllFilesInFolder(folderId, "", "0", "", "", "", "", "", "1", 0, 0, primary, offset, tenantId);
		
		if (fileList != null && fileList.size() > 0) {
			for (FileVO file : fileList) {
				file.setDownloadCnt(0);
				file.setFolderId(newId);
				file.setUpdateDate(timeUTC);
				file.setUpdateId(userId);
				file.setFileId(getMaxFileID(tenantId));
				ezWebFolderService.insertFile(file);
			}
		}
	}
}