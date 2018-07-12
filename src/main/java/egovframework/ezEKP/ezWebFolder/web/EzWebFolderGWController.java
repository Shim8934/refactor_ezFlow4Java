package egovframework.ezEKP.ezWebFolder.web;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.TimeZone;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderAdminService;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderService;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderService_y;
import egovframework.ezEKP.ezWebFolder.vo.FileLogVO;
import egovframework.ezEKP.ezWebFolder.vo.FileVO;
import egovframework.ezEKP.ezWebFolder.vo.FolderSimpleVO;
import egovframework.ezEKP.ezWebFolder.vo.FolderUserVO;
import egovframework.ezEKP.ezWebFolder.vo.FolderVO;
import egovframework.ezEKP.ezWebFolder.vo.SimpleDeptVO;
import egovframework.ezEKP.ezWebFolder.vo.SimpleUserVO;
import egovframework.ezEKP.ezWebFolder.vo.UserCapacityVO;
import egovframework.ezEKP.ezWebFolder.vo.WebfolderConfigVO;
import egovframework.ezEKP.ezWebFolder.vo.WebfolderEnvVO;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@SuppressWarnings("unchecked")
@RestController
public class EzWebFolderGWController {
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
	
	@Resource(name = "EzWebFolderService_y")
	private EzWebFolderService_y ezWebFolderService_y;
	
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
		String userId     = request.getParameter("userId")      != null ? request.getParameter("userId")                        : "";
		String column     = request.getParameter("column")      != null ? request.getParameter("column")                        : "";
		String order      = request.getParameter("order")       != null ? request.getParameter("order")                         : "";
		JSONObject result = new JSONObject();
		int totalUsers    = 0;
		int totalPages    = 0;
		int pageSize      = 10;
		int startPoint    = (currPage - 1) * pageSize;
		String realColmn  = "";
		
		logger.debug("CompanyId: " + companyId + " || serverName: " + serverName);
		
		if (serverName.equals("") || companyId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			return result;
		}
		
		try {
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			int tenantId     = userInfo.getTenantId();
			String primary   = userInfo.getPrimary();
			
			if (!column.equals("") && !order.equals("")) {
				switch(column) {
					case "cn": realColmn = "COMPANY_NAME"    ; break;
					case "dn": realColmn = "DEPARTMENT_NAME" ; break;
					case "un": realColmn = "DISPLAY_NAME"    ; break;
					case "ut": realColmn = "JOB_TITLE"       ; break;
					case "tc": realColmn = "TOTAL_CAPACITY"  ; break;
					default  : realColmn = "COMPANY_NAME"    ; break;
				}
			}
			
			logger.debug("Column: " + realColmn + " || order: " + order);
			
			List<UserCapacityVO> listUserCapacity = ezWebFolderAdminService.getListUserCapacity(realColmn, order, companyId, searchStr, searchOpt, startPoint, pageSize, tenantId, primary);
			totalUsers                            = ezWebFolderAdminService.getTotalListUserCapacity(companyId, searchStr, searchOpt, startPoint, pageSize, tenantId, primary);
			totalPages                            = (totalUsers + pageSize - 1)/pageSize;
			
			for (UserCapacityVO capacity: listUserCapacity) {
				if (capacity.getTotalUsed().equals("0") || capacity.getTotalCapacity().equals("0")) {
					capacity.setUsedRate(0);
				}
				else {
					double totalCapByBytes = Double.parseDouble(capacity.getTotalCapacity()) * 10737418.24;
					capacity.setUsedRate((int)(Double.parseDouble(capacity.getTotalUsed())/totalCapByBytes));
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
	public JSONObject putChangePersonalStorage(@PathVariable(value="newvalue") String newValue, @RequestParam("userList") List<String> userList, Locale locale, HttpServletRequest request) {
		String serverName = request.getHeader("host-name")    != null ? request.getHeader("host-name")    : "";
		String companyId  = request.getParameter("companyId") != null ? request.getParameter("companyId") : "";
		JSONObject result = new JSONObject();
		
		if (serverName.equals("") || companyId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("reason", egovMessageSource.getMessage("ezWebFolder.t244", locale));
			return result;
		}
		
		try {
			int tenantId                      = loginService.getTenantId(serverName);
			WebfolderConfigVO webfolderConfig = ezWebFolderAdminService.getWebfolderConfig(companyId, tenantId);
			
			if (Double.parseDouble(newValue) < Double.parseDouble(webfolderConfig.getUploadLimit())) {
				result.put("status", "error");
				result.put("reason", egovMessageSource.getMessage("ezWebFolder.t26", locale));
				return result;
			}
			
			ezWebFolderAdminService.updateNewAmount(userList, newValue, companyId, tenantId);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "");
		} 
		catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("reason", egovMessageSource.getMessage("ezWebFolder.t134", locale));
		}
		
		return result;
	}

	@RequestMapping(value="/rest/ezwebfolderadmin/storagereset/person", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject putResetPersonalStorage(@RequestParam("userList") List<String> userList, HttpServletRequest request, Locale locale) {
		String serverName  = request.getHeader("host-name")    != null ? request.getHeader("host-name")    : "";
		String companyId   = request.getParameter("companyId") != null ? request.getParameter("companyId") : "";
		String totalAmount = "";
		JSONObject result  = new JSONObject();
		
		if (serverName.equals("") || companyId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			result.put("reason", egovMessageSource.getMessage("ezWebFolder.t244", locale));
			return result;
		}
		
		try {
			int tenantId                      = loginService.getTenantId(serverName);
			WebfolderConfigVO webfolderConfig = ezWebFolderAdminService.getWebfolderConfig(companyId, tenantId);
			
			if (webfolderConfig != null) {
				totalAmount = webfolderConfig.getTotalLimit();
			}
			
			ezWebFolderAdminService.updateNewAmount(userList, totalAmount, companyId, tenantId);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "");
		}
		catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			result.put("reason", egovMessageSource.getMessage("ezWebFolder.t134", locale));
		}
		
		return result;
	}

	@RequestMapping(value="/rest/ezwebfolder/capacity/{userid}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getUserCapacity(@PathVariable(value="userid") String userId, HttpServletRequest request) {
		String serverName = request.getHeader("host-name") != null ? request.getHeader("host-name") : "";
		JSONObject result = new JSONObject();
		
		logger.debug("UserId: " + userId + " || serverName: " + serverName);
		
		if (serverName.equals("") || userId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			return result;
		}
		
		try {
			LoginVO userInfo            = commonUtil.getUserForGw(userId, serverName);
			int tenantId                = userInfo.getTenantId();
			String primary              = userInfo.getPrimary();
			UserCapacityVO userCapacity = ezWebFolderAdminService.getUserCapacity(userId, primary, tenantId);
			
			if (userCapacity.getTotalUsed().equals("0") || userCapacity.getTotalCapacity().equals("0")) {
				userCapacity.setUsedRate(0);
			}
			else {
				double totalCapByBytes = Double.parseDouble(userCapacity.getTotalCapacity()) * 10737418.24;
				userCapacity.setUsedRate((int)(Double.parseDouble(userCapacity.getTotalUsed())/totalCapByBytes));
			}
			
			result.put("data", userCapacity);
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

	@RequestMapping(value="/rest/ezwebfolderadmin/filehistorylist", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getFileHistory(HttpServletRequest request, Locale locale) {
		String serverName = request.getHeader("host-name")      != null ? request.getHeader("host-name")                        : "";
		String userId     = request.getParameter("userId")      != null ? request.getParameter("userId")                        : "";
		String companyId  = request.getParameter("companyId")   != null ? request.getParameter("companyId")                     : "";
		String startDate  = request.getParameter("startDate")   != null ? request.getParameter("startDate")                     : "";
		String endDate    = request.getParameter("endDate")     != null ? request.getParameter("endDate")                       : "";
		String fileExt    = request.getParameter("fileExt")     != null ? request.getParameter("fileExt")                       : "";
		String fileName   = request.getParameter("fileName")    != null ? request.getParameter("fileName")                      : "";
		String userName   = request.getParameter("userName")    != null ? request.getParameter("userName")                      : "";
		String fileType   = request.getParameter("fileType")    != null ? request.getParameter("fileType")                      : "";
		String actionType = request.getParameter("actionType")  != null ? request.getParameter("actionType")                    : "";
		String column     = request.getParameter("column")      != null ? request.getParameter("column")                        : "";
		String order      = request.getParameter("order")       != null ? request.getParameter("order")                         : "";
		String listCnt    = request.getParameter("listCnt")     != null ? request.getParameter("listCnt")                       : "";
		
		String searchChk  = "1";
		int currPage      = request.getParameter("currentPage") != null ? Integer.parseInt(request.getParameter("currentPage")) :  1;
		int totalRows     = 0;
		int totalPages    = 0;
		int pageSize      = listCnt.equals("") ? 10 : Integer.parseInt(listCnt);
		int startPoint    = (currPage - 1) * pageSize;
		String realColmn  = "";
		
		logger.debug("StartDate: " + startDate + " || EndDate: " + endDate + " || FileExt: " + fileExt + " || FileName: " + fileName + " || File Type: " + fileType + " || Username: " + userName + " || Action Type: " + actionType);
		
		JSONObject result = new JSONObject();
		
		if (serverName.equals("") || companyId.equals("") || fileType.equals("") || userId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			result.put("reason", egovMessageSource.getMessage("ezWebFolder.t244", locale));
			return result;
		}
		
		try {
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			int tenantId     = userInfo.getTenantId();
			String primary   = userInfo.getPrimary();
			String offset    = userInfo.getOffset();
			
			if (!column.equals("") && !order.equals("")) {
				switch(column) {
					case "ft": realColmn = "FILE_TYPE"                                          ; break;
					case "fn": realColmn = "FILE_NAME"                                          ; break;
					case "fs": realColmn = "FILE_SIZE"                                          ; break;
					case "un": realColmn = primary.equals("1") ? "CREATE_NAME1" : "CREATE_NAME2"; break;
					case "at": realColmn = "LOG_TYPE"                                           ; break;
					case "ad": realColmn = "CREATE_DATE"                                        ; break;
					default  : realColmn = "FILE_NAME"                                          ; break;
				}
			}
			
			logger.debug("Column: " + realColmn + " || order: " + order + " || companyId: " + companyId + " TenantId: " + tenantId);
			
			if (startDate.equals("") && endDate.equals("") && fileExt.equals("") && fileName.equals("") && userName.equals("") && actionType.equals("")) {
				searchChk = "0";
			}
			
			if (searchChk.equals("1")) {
				if (!startDate.equals("")) {
					String startDateTmp = startDate + " 00:00:00";
					String endDateTmp   = endDate + " 23:59:59";
					startDate           = commonUtil.getDateStringInUTC(startDateTmp, offset, true);
					endDate             = commonUtil.getDateStringInUTC(endDateTmp, offset, true);
				}
			}
			
			logger.debug("SearchChk: " + searchChk + " || StartDate in UTC: " + startDate + " || EndDate in UTC: " + endDate);
			
			List<FileLogVO> listFileLogs = ezWebFolderAdminService.getListFileLogs(realColmn, order.toUpperCase(), companyId, searchChk, startDate, endDate, fileExt, fileName, userName, fileType, actionType, startPoint, pageSize, primary, offset, tenantId);
			totalRows                    = ezWebFolderAdminService.getTotalFileLogs(companyId, searchChk, startDate, endDate, fileExt, fileName, userName, fileType, actionType, primary, tenantId);
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
			result.put("reason", egovMessageSource.getMessage("ezWebFolder.t134", locale));
		}
		
		return result;
	}

	@RequestMapping(value="/rest/ezwebfolderadmin/export-logs", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject createExcelFile(HttpServletRequest request, Locale locale) {
		String serverName = request.getHeader("host-name")      != null ? request.getHeader("host-name")                        : "";
		String userId     = request.getParameter("userId")      != null ? request.getParameter("userId")                        : "";
		String companyId  = request.getParameter("companyId")   != null ? request.getParameter("companyId")                     : "";
		String startDate  = request.getParameter("startDate")   != null ? request.getParameter("startDate")                     : "";
		String endDate    = request.getParameter("endDate")     != null ? request.getParameter("endDate")                       : "";
		String fileExt    = request.getParameter("fileExt")     != null ? request.getParameter("fileExt")                       : "";
		String fileName   = request.getParameter("fileName")    != null ? request.getParameter("fileName")                      : "";
		String userName   = request.getParameter("userName")    != null ? request.getParameter("userName")                      : "";
		String fileType   = request.getParameter("fileType")    != null ? request.getParameter("fileType")                      : "";
		String actionType = request.getParameter("actionType")  != null ? request.getParameter("actionType")                    : "";
		String column     = request.getParameter("column")      != null ? request.getParameter("column")                        : "";
		String order      = request.getParameter("order")       != null ? request.getParameter("order")                         : "";
		
		String searchChk  = "1";
		String realColmn  = "";
		
		logger.debug("StartDate: " + startDate + " || EndDate: " + endDate + " || FileExt: " + fileExt + " || FileName: " + fileName + " || File Type: " + fileType + " || Username: " + userName + " || Action Type: " + actionType);
		
		JSONObject result = new JSONObject();
		
		if (serverName.equals("") || companyId.equals("") || fileType.equals("") || userId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			result.put("reason", egovMessageSource.getMessage("ezWebFolder.t244", locale));
			return result;
		}
		
		try {
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			int tenantId     = userInfo.getTenantId();
			String primary   = userInfo.getPrimary();
			String offset    = userInfo.getOffset();
			
			if (!column.equals("") && !order.equals("")) {
				switch(column) {
					case "ft": realColmn = "FILE_TYPE"                                          ; break;
					case "fn": realColmn = "FILE_NAME"                                          ; break;
					case "fs": realColmn = "FILE_SIZE"                                          ; break;
					case "un": realColmn = primary.equals("1") ? "CREATE_NAME1" : "CREATE_NAME2"; break;
					case "at": realColmn = "LOG_TYPE"                                           ; break;
					case "ad": realColmn = "CREATE_DATE"                                        ; break;
					default  : realColmn = "FILE_NAME"                                          ; break;
				}
			}
			
			logger.debug("Column: " + realColmn + " || order: " + order + " || companyId: " + companyId + " TenantId: " + tenantId);
			
			if (startDate.equals("") && endDate.equals("") && fileExt.equals("") && fileName.equals("") && userName.equals("") && actionType.equals("")) {
				searchChk = "0";
			}
			
			if (searchChk.equals("1")) {
				if (!startDate.equals("")) {
					String startDateTmp = startDate + " 00:00:00";
					String endDateTmp   = endDate + " 23:59:59";
					startDate           = commonUtil.getDateStringInUTC(startDateTmp, offset, true);
					endDate             = commonUtil.getDateStringInUTC(endDateTmp, offset, true);
				}
			}
			
			logger.debug("SearchChk: " + searchChk + " || StartDate in UTC: " + startDate + " || EndDate in UTC: " + endDate);
			
			List<FileLogVO> listFileLogs = ezWebFolderAdminService.getListFileLogs(realColmn, order.toUpperCase(), companyId, searchChk, startDate, endDate, fileExt, fileName, userName, fileType, actionType, 0, 0, primary, offset, tenantId);
			String realPath              = request.getServletContext().getRealPath("");
			String pDirPath              = ezWebFolderService.getWebFolderDirPath(tenantId);
			pDirPath                     = realPath + pDirPath + "temp" + commonUtil.separator;
			String excelPath             = ezWebFolderAdminService.createExcelFileLogs(realPath + commonUtil.separator, pDirPath, listFileLogs, primary, locale);
			
			if (excelPath.equals("")) {
				result.put("status", "error");
				result.put("reason", egovMessageSource.getMessage("ezWebFolder.t134", locale));
				result.put("code", 1);
				return result;
			}
			
			result.put("status", "ok");
			result.put("data", excelPath);
			result.put("code", 0);
		}
		catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			result.put("reason", egovMessageSource.getMessage("ezWebFolder.t134", locale));
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezwebfolder/filemanage/file-upload", method= RequestMethod.POST, produces="application/json;charset=utf-8")
	public JSONObject postFileUploadGW(@RequestParam("data") String dataList, @RequestParam("files") List<MultipartFile> multiFileLists, Locale locale, HttpServletRequest request) throws Exception {
		JSONParser jp          = new JSONParser();
		JSONObject jsonObject  = (JSONObject) jp.parse(dataList);
		
		JSONArray nameArray    = jsonObject.get("nameArray")    != null ? (JSONArray) jsonObject.get("nameArray") : null;
		String serverName      = request.getHeader("host-name") != null ? request.getHeader("host-name")          : "";
		String userId          = jsonObject.get("userId")       != null ? (String) jsonObject.get("userId")       : "";
		String folderId        = jsonObject.get("folderId")     != null ? (String) jsonObject.get("folderId")     : "";
		JSONObject result      = new JSONObject();
		
		if (nameArray == null || serverName.equals("") || userId.equals("") || folderId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("reason", egovMessageSource.getMessage("ezWebFolder.t244", locale));
			result.put("code", 1);
			result.put("data", "");
			return result;
		}
		
		if (nameArray.size() != multiFileLists.size()) {
			logger.debug("Some files upload failed!");
			result.put("status", "error");
			result.put("reason", egovMessageSource.getMessage("ezWebFolder.t244", locale));
			result.put("code", 1);
			result.put("data", "");
			return result;
		}
		
		try {
			LoginVO userInfo  = commonUtil.getUserForGw(userId, serverName);
			String primary    = userInfo.getPrimary();
			String offset     = userInfo.getOffset();
			
			if (!isWebfolderAdmin(userInfo)){
				JSONObject permissionResult = ezWebFolderService_y.checkPermissions(userId, userInfo.getDeptID(), userInfo.getCompanyID(), folderId, null, userInfo.getTenantId());
				
				if ("error".equals(permissionResult.get("status"))) {
					return permissionResult;
				}
			}
			
			//Check upload conditions
			FolderVO folder = ezWebFolderService.getFolderByFolderId(folderId, offset, userInfo.getTenantId());
			
			WebfolderConfigVO webfolderConfig   = ezWebFolderAdminService.getWebfolderConfig(userInfo.getCompanyID(), userInfo.getTenantId());
			double limitUploadValue             = webfolderConfig.getUploadLimit().equals("") ? 0 : Double.parseDouble(webfolderConfig.getUploadLimit());
			double totalUploadSize              = 0;
			
			for (int i = 0; i < multiFileLists.size(); i++) {
				totalUploadSize += multiFileLists.get(i).getSize();
			}
			
			if (limitUploadValue * 1073741824 < totalUploadSize) {
				logger.debug("limited upload value!");
				result.put("status", "error");
				result.put("reason", egovMessageSource.getMessage("ezWebFolder.t249", locale));
				result.put("code", 1);
				result.put("data", "");
				return result;
			}
			
			UserCapacityVO userCapacity = ezWebFolderAdminService.getUserCapacity(userId, primary, userInfo.getTenantId());
			
			long totalUsed = Long.parseLong(userCapacity.getTotalUsed());
			long totalCapa = Long.parseLong(userCapacity.getTotalCapacity()) * 1073741824;
			
			if (totalUploadSize > (totalCapa - totalUsed)) {
				logger.debug("Not enough storage to upload these files!");
				result.put("status", "error");
				result.put("reason", egovMessageSource.getMessage("ezWebFolder.t250", locale));
				result.put("code", 1);
				result.put("data", "");
				return result;
			}
			
			String realPath   = request.getServletContext().getRealPath("");
			List<FileVO> list = ezWebFolderService.saveUploadedFiles(multiFileLists, nameArray, folder, realPath, userInfo);
			
			if (list == null || list.size() == 0) {
				result.put("status", "error");
				result.put("code", 1);
				result.put("reason", egovMessageSource.getMessage("ezWebFolder.t134", locale));
			}
			else {
				result.put("status", "ok");
				result.put("code", 0);
				result.put("data", list);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
			result.put("reason", egovMessageSource.getMessage("ezWebFolder.t134", locale));
			result.put("data", "");
		}
		
		return result;
	}

	@RequestMapping(value = "/rest/ezwebfolder/filemanage/file-download", method=RequestMethod.GET, produces = { MediaType.APPLICATION_OCTET_STREAM_VALUE})
	public void getFileDownload(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String listFileId   = request.getParameter("fileList")   != null ? request.getParameter("fileList")   : "";
		String listFolderId = request.getParameter("folderList") != null ? request.getParameter("folderList") : "";
		String userId       = request.getParameter("userId")     != null ? request.getParameter("userId")     : "";
		String serverName   = request.getHeader("host-name")     != null ? request.getHeader("host-name")     : "";
		String userAgent    = request.getParameter("userAgent")  != null ? request.getParameter("userAgent")  : "";
		
		String[] fileIDList = listFileId.equals("")   ? new String[0] : listFileId.split(",");
		String[] folderList = listFolderId.equals("") ? new String[0] : listFolderId.split(",");
		
		logger.debug("serverName: " + serverName + " ||  listFileId: " + listFileId + " || listFolderId: " + listFolderId + " || UserId: " + userId);
		
		if ((fileIDList.length == 0 && folderList.length == 0) || serverName.equals("") || userId.equals("")) {
			logger.debug("downloadAttach illegal arguments!");
			return;
		}
		
		//Get absolute path of the application
		String realPath  = request.getServletContext().getRealPath("");
		LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
		ezWebFolderService.getDownloadedFiles(folderList, fileIDList, realPath, userInfo, userAgent, request, response);
		
		logger.debug("File Download Finish!");
		return;
	}

	@RequestMapping(value = "/rest/ezwebfolder/file-delete", method = RequestMethod.DELETE, produces = "application/json;charset=utf-8")
	public JSONObject delFileDelete(Locale locale, HttpServletRequest request) {
		String listFileId   = request.getParameter("fileList") != null ? request.getParameter("fileList") : "";
		String userId       = request.getParameter("userId")   != null ? request.getParameter("userId")   : "";
		String serverName   = request.getHeader("host-name")   != null ? request.getHeader("host-name")   : "";
		String[] fileIDList = listFileId.split(",");
		JSONObject result   = new JSONObject();
		
		if (fileIDList.length == 0 || serverName.equals("") || userId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("reason", egovMessageSource.getMessage("ezWebFolder.t244", locale));
			result.put("code", "1");
			return result;
		}
		
		try {
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			
			if (!isWebfolderAdmin(userInfo)){
				JSONObject permissionResult = ezWebFolderService_y.checkPermissions(userId, userInfo.getDeptID(), userInfo.getCompanyID(), null, listFileId, userInfo.getTenantId());
				
				if ("error".equals(permissionResult.get("status"))) {
					return permissionResult;
				}
			}
			
			ezWebFolderService.deleteSelectedFiles(fileIDList, userInfo);
			
			result.put("status", "ok");
			result.put("code", "0");
		} catch (Exception e) {
			e.printStackTrace();
			result.put("reason", egovMessageSource.getMessage("ezWebFolder.t134", locale));
			result.put("status", "error");
			result.put("code", "1");
		}
		
		return result;
	}

	@RequestMapping(value="/rest/ezwebfolder/file-rename/fileid/{fileid}", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject putFileRename(@PathVariable(value="fileid") String fileId, HttpServletRequest request) {
		String userId       = request.getParameter("userId")   != null ? request.getParameter("userId")  : "";
		String serverName   = request.getHeader("host-name")   != null ? request.getHeader("host-name")  : "";
		String newName      = request.getParameter("newName")  != null ? request.getParameter("newName") : "";
		JSONObject result   = new JSONObject();
		
		if (fileId.equals("") || newName.equals("") || serverName.equals("") || userId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", "1");
			return result;
		}
		
		try {
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			String userName1 = userInfo.getDisplayName1();
			String userName2 = userInfo.getDisplayName2();
			String companyId = userInfo.getCompanyID();
			int tenantId     = userInfo.getTenantId();
			String offset    = userInfo.getOffset();
			
			if (!isWebfolderAdmin(userInfo)){
				JSONObject permissionResult = ezWebFolderService_y.checkPermissions(userId, userInfo.getDeptID(), userInfo.getCompanyID(), null, fileId, userInfo.getTenantId());
				
				if ("error".equals(permissionResult.get("status"))) {
					return permissionResult;
				}
			}
			
			SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			Date date                  = new Date();
			String timeUTC             = commonUtil.getDateStringInUTC(formatter.format(date), userInfo.getOffset(), true);
			
			FileVO fileVO    = ezWebFolderService.getFileByFileId(fileId, offset, tenantId);
			String fileExt   = fileVO.getFileExt();
			ezWebFolderService.updateFileName(fileId, newName + "." + fileExt, timeUTC, tenantId);
			ezWebFolderService.saveLog("U", companyId, offset, userId, userName1, userName2, fileVO.getFileName(), fileVO.getFileSize(), fileVO.getFileExt(), fileVO.getFileTypeName(), tenantId);
			
			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
		}
		
		return result;
	}

	@RequestMapping(value="/rest/ezwebfolder/filemove/modes/{mode}", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject putFileMove(@PathVariable(value="mode") String mode, Locale locale, HttpServletRequest request) throws Exception {
		String fileList     = request.getParameter("fileList")   != null ? request.getParameter("fileList")   : "";
		String userId       = request.getParameter("userId")     != null ? request.getParameter("userId")     : "";
		String serverName   = request.getHeader("host-name")     != null ? request.getHeader("host-name")     : "";
		String folderId     = request.getParameter("folderId")   != null ? request.getParameter("folderId")   : "";
		String privileges   = request.getParameter("privileges") != null ? request.getParameter("privileges") : "";
		JSONObject result   = new JSONObject();
		
		if (fileList.equals("") || mode.equals("") || serverName.equals("") || userId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("reason", egovMessageSource.getMessage("ezWebFolder.t244", locale));
			result.put("code", "1");
			return result;
		}
		
		LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
		
		if (!isWebfolderAdmin(userInfo)){
			JSONObject permissionResult = ezWebFolderService_y.checkPermissions(userId, userInfo.getDeptID(), userInfo.getCompanyID(), folderId, fileList, userInfo.getTenantId());
			
			if ("error".equals(permissionResult.get("status"))) {
				return permissionResult;
			}
		}
		
		String realPath = request.getServletContext().getRealPath("");
		result          = ezWebFolderService.moveFiles(folderId, fileList, mode, privileges, locale, realPath, userInfo);
		return result;
	}

	@RequestMapping(value="/rest/ezwebfolderadmin/webfolderadmin-list", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getWebfolderAdminList(HttpServletRequest request) {
		String serverName   = request.getHeader("host-name")   != null ? request.getHeader("host-name")                     : "";
		String userId       = request.getParameter("userId")   != null ? request.getParameter("userId")                     : "";
		int pageNum         = request.getParameter("pageNum")  != null ? Integer.parseInt(request.getParameter("pageNum"))  : -1;
		int pageSize        = request.getParameter("pageSize") != null ? Integer.parseInt(request.getParameter("pageSize")) : -1;
		String companyId    = request.getParameter("companyId")!= null ? request.getParameter("companyId")                  : "";
		String type         = "wf=1";
		JSONObject result   = new JSONObject();
		JSONArray jsonArray = new JSONArray();
		
		if (companyId.equals("") || type.equals("") || serverName.equals("") || pageNum == -1 || pageSize == -1) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", "1");
			return result;
		}
		
		try {
			LoginVO userInfo       = commonUtil.getUserForGw(userId, serverName);
			int tenantId           = userInfo.getTenantId();
			String primary         = userInfo.getPrimary();
			int startRow           = (pageSize * (pageNum - 1)) + 1;
			int endRow             = pageSize * pageNum;
			int cnt                = ezOrganAdminService.getPermissionListCount(companyId, type,"","", primary, tenantId);
			List<OrganUserVO> list = ezOrganAdminService.getPermissionList(companyId, type,"","", primary, startRow, endRow, tenantId);
			
			logger.debug("List size: " + list.size());
			
			for (OrganUserVO vo : list) {
				JSONObject fileJson = new JSONObject();
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

	@RequestMapping(value="/rest/webfolderadmin/webfolderadmin-insert", method= RequestMethod.POST, produces="application/json;charset=utf-8")
	public JSONObject postWebfolderAdminInsert(HttpServletRequest request) throws Exception {
		String serverName   = request.getHeader("host-name")   != null ? request.getHeader("host-name") : "";
		String userId       = request.getParameter("userId")   != null ? request.getParameter("userId") : "";
		JSONObject result   = new JSONObject();
		
		if (userId.equals("") || serverName.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", "1");
			return result;
		}
		
		logger.debug("UserID: " + userId + " || serverName: " + serverName);
		LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
		int tenantId     = userInfo.getTenantId();
		String primary   = userInfo.getPrimary();
		
		OrganUserVO vo   = ezOrganAdminService.getUserInfo(userId, primary, tenantId);
		String extStr    = vo.getExtensionAttribute1().toLowerCase();
		
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

	@RequestMapping(value="/rest/webfolderadmin/webfolderadmin-delete/users/{userid}", method= RequestMethod.DELETE, produces="application/json;charset=utf-8")
	public JSONObject deleteWebfolderAdminDelete(@PathVariable String userid, HttpServletRequest request) throws Exception {
		String serverName = request.getHeader("host-name") != null ? request.getHeader("host-name") : "";
		String userId     = request.getParameter("userId") != null ? request.getParameter("userId") : "";
		
		JSONObject result = new JSONObject();
		
		if (userid.equals("") || serverName.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", "1");
			return result;
		}
		
		logger.debug("UserID: " + userid + " || serverName: " + serverName);
		
		LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
		int tenantId     = userInfo.getTenantId();
		String primary   = userInfo.getPrimary();
		OrganUserVO vo   = ezOrganAdminService.getUserInfo(userid, primary, tenantId);
		String extStr    = vo.getExtensionAttribute1().toLowerCase();
		
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
		String companyId  = request.getParameter("companyId")!= null ? request.getParameter("companyId")                  : "";
		String primary    = request.getParameter("primary")  != null ? request.getParameter("primary")                    : "";
		JSONObject result = new JSONObject();
		
		if (companyId.equals("") || primary.equals("") || tenantId == -1) {
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
	public JSONObject postCompanyFolderInsert(@RequestBody JSONObject jsonObject, HttpServletRequest request, Locale locale) throws ParseException {
		JSONParser parser  = new JSONParser();
		jsonObject         = (JSONObject) parser.parse(jsonObject.toJSONString());
		String serverName  = request.getHeader("host-name") != null ? request.getHeader("host-name")       : "";
		String userId      = jsonObject.get("userId")       != null ? (String) jsonObject.get("userId")    : "";
		String pFolderId   = jsonObject.get("pFolderId")    != null ? (String) jsonObject.get("pFolderId") : "";
		String folderName  = jsonObject.get("fName")        != null ? (String) jsonObject.get("fName")     : "";
		String folderName2 = jsonObject.get("fName2")       != null ? (String) jsonObject.get("fName2")    : "";
		String folderUsers = jsonObject.get("fUsers")       != null ? (String) jsonObject.get("fUsers")    : "";
		JSONObject result  = new JSONObject();
		
		if (pFolderId.equals("") || userId.equals("") || folderUsers.equals("") || folderName.equals("") || serverName.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", "1");
			result.put("reason", egovMessageSource.getMessage("ezWebFolder.t244", locale));
			return result;
		}
		
		logger.debug("serverName: " + serverName + " || folderName: " + folderName + " || ParentFolderID: " + pFolderId);
		
		try {
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			ezWebFolderAdminService.addCompanyFolder(pFolderId, folderUsers, folderName, folderName2, userInfo);
			
			result.put("status", "ok");
			result.put("code", 0);
		}
		catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			result.put("reason", egovMessageSource.getMessage("ezWebFolder.t134", locale));
		}
		
		return result;
	}

	@RequestMapping(value="/rest/ezwebfolderadmin/folders/{folderid}/comp", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject putCompanyFolderUpdate(@RequestBody JSONObject jsonObject, @PathVariable(value="folderid") String folderId, HttpServletRequest request, Locale locale) throws ParseException {
		JSONParser parser      = new JSONParser();
		jsonObject             = (JSONObject) parser.parse(jsonObject.toJSONString());
		String serverName      = request.getHeader("host-name") != null ? request.getHeader("host-name")    : "";
		String userId          = jsonObject.get("userId")       != null ? (String) jsonObject.get("userId") : "";
		String folderName      = jsonObject.get("fName")        != null ? (String) jsonObject.get("fName")  : "";
		String folderName2     = jsonObject.get("fName2")       != null ? (String) jsonObject.get("fName2") : "";
		String folderUsers     = jsonObject.get("fUsers")       != null ? (String) jsonObject.get("fUsers") : "";
		JSONObject result      = new JSONObject();
		
		if (folderId.equals("") || userId.equals("") || folderUsers.equals("") || folderName.equals("") || serverName.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", "1");
			result.put("reason", egovMessageSource.getMessage("ezWebFolder.t244", locale));
			return result;
		}
		
		logger.debug("serverName: " + serverName + " || folderName: " + folderName + " || folderID: " + folderId);
		
		try {
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			int tenantId     = userInfo.getTenantId();
			String offset    = userInfo.getOffset();
			ezWebFolderAdminService.updateCompanyFolder(userId, folderId, folderUsers, folderName, folderName2, offset, tenantId);
			
			result.put("status", "ok");
			result.put("code", 0);
		}
		catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			result.put("reason", egovMessageSource.getMessage("ezWebFolder.t134", locale));
		}
		
		return result;
	}

	@RequestMapping(value="/rest/ezwebfolder/foldersTree", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getFolderTree(HttpServletRequest request) {
		String userId     = request.getParameter("userId")    != null ? request.getParameter("userId")    : "";
		String companyId  = request.getParameter("companyId") != null ? request.getParameter("companyId") : "";
		String folderId   = request.getParameter("folderId")  != null ? request.getParameter("folderId")  : "";
		String type       = request.getParameter("type")      != null ? request.getParameter("type")      : "";
		String serverName = request.getHeader("host-name")    != null ? request.getHeader("host-name")    : "";
		JSONObject result = new JSONObject();
		
		if (serverName.equals("") || type.equals("") || companyId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", "1");
			return result;
		}
		
		logger.debug("Type: " + type + " || folderId: " + folderId + " || companyId: " + companyId + " || serverName: " + serverName);
		
		try {
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			int tenantId     = userInfo.getTenantId();
			
			if (!isWebfolderAdmin(userInfo)) {
				logger.debug("Privileges!");
				result.put("status", "error");
				result.put("code", "1");
				return result;
			}
					
			switch (type) {
				case "comp":
					//Get company folder tree
					FolderSimpleVO company = ezWebFolderService.getCompanySimpleFolder(companyId, userInfo);
					ezWebFolderService.getAllSubDepts(company, tenantId, 2);
					
					result.put("currentFolder", "");
					result.put("data", company);
					break;
				case "dept":
					//Get department folder tree
					List<FolderSimpleVO> listFolders = ezWebFolderService.getAllSimpleDeptFolder(companyId, userInfo);
					
					result.put("currentFolder", "");
					result.put("data", listFolders);
					break;
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
		String serverName = request.getHeader("host-name")   != null ? request.getHeader("host-name")    : "";
		JSONObject result = new JSONObject();
		
		if (companyId.equals("") || serverName.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", "1");
			return result;
		}
		
		logger.debug("CompanyId: " + companyId + " || serverName: " + serverName);
		
		try {
			LoginVO userInfo      = commonUtil.getUserForGw(userId, serverName);
			String primary        = userInfo.getPrimary();
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
		String serverName = request.getHeader("host-name") != null ? request.getHeader("host-name")                  : "";
		int level         = request.getParameter("level")  != null ? Integer.parseInt(request.getParameter("level")) : -1;
		String userId     = request.getParameter("userId") != null ? request.getParameter("userId")                  : "";
		JSONObject result = new JSONObject();
		
		logger.debug("deptId: " + deptId + " || level: " + level + " || serverName: " + serverName + " || User Id: " + userId);
		
		if (deptId.equals("") || serverName.equals("") || level == -1 || userId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", "1");
			return result;
		}
		
		try {
			LoginVO userInfo   = commonUtil.getUserForGw(userId, serverName);
			int tenantId       = userInfo.getTenantId();
			String primary     = userInfo.getPrimary();
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
		String serverName = request.getHeader("host-name") != null ? request.getHeader("host-name") : "";
		String userId     = request.getParameter("userId") != null ? request.getParameter("userId") : "";
		JSONObject result = new JSONObject();
		
		logger.debug("deptId: " + deptId + " || serverName: " + serverName);
		
		if (deptId.equals("") || userId.equals("") || serverName.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", "1");
			return result;
		}
		
		try {
			LoginVO userInfo               = commonUtil.getUserForGw(userId, serverName);
			int tenantId                   = userInfo.getTenantId();
			String primary                 = userInfo.getPrimary();
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
		String userId     = request.getParameter("userId")    != null ? request.getParameter("userId")    : "";
		String companyId  = request.getParameter("companyId") != null ? request.getParameter("companyId") : "";
		String folderId   = request.getParameter("folderId")  != null ? request.getParameter("folderId")  : "";
		JSONObject result = new JSONObject();
		
		if (companyId.equals("") || serverName.equals("") || userId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", "1");
			return result;
		}
		
		logger.debug("CompanyId: " + companyId + " || serverName: " + serverName);
		
		try {
			LoginVO userInfo                 = commonUtil.getUserForGw(userId, serverName);
			int tenantId                     = userInfo.getTenantId();
			String offset                    = userInfo.getOffset();
			List<FolderSimpleVO> listFolders = ezWebFolderService.getAllSimpleDeptFolder(companyId, userInfo);
			
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
	
	@RequestMapping(value="/rest/ezwebfolderadmin/foldersTree/comp", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getCompanyFolderTree(HttpServletRequest request) {
		String serverName = request.getHeader("host-name")    != null ? request.getHeader("host-name")    : "";
		String userId     = request.getParameter("userId")    != null ? request.getParameter("userId")    : "";
		String companyId  = request.getParameter("companyId") != null ? request.getParameter("companyId") : "";
		String folderId   = request.getParameter("folderId")  != null ? request.getParameter("folderId")  : "";
		JSONObject result = new JSONObject();
		
		if (companyId.equals("") || serverName.equals("") || userId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", "1");
			return result;
		}
		
		logger.debug("CompanyId: " + companyId + " || serverName: " + serverName);
		
		try {
			LoginVO userInfo  = commonUtil.getUserForGw(userId, serverName);
			int tenantId      = userInfo.getTenantId();
			String primary    = userInfo.getPrimary();
			String offset     = userInfo.getOffset();
			FolderVO folderVO = ezWebFolderService.getRootFolderId(companyId, "C", offset, tenantId);
			
			if (folderVO == null) {
				//Auto create 회사 folder
				OrganDeptVO company        = ezOrganService.getDeptInfo(companyId, primary, tenantId);
				folderVO                   = new FolderVO();
				SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				Date date                  = new Date();
				String timeUTC             = commonUtil.getDateStringInUTC(formatter.format(date), offset, true);
				String compFolderId        = ezWebFolderAdminService.getMaxFolderID(tenantId);
				
				folderVO.setFolderId(compFolderId);
				folderVO.setFolderLevel(0);
				folderVO.setFolderName1(company.getDisplayName1());
				folderVO.setFolderName2(company.getDisplayName2());
				folderVO.setFolderPath("|" + compFolderId + "|");
				folderVO.setFolderStep(0);
				folderVO.setFolderType("C");
				folderVO.setFolderUpper("root");
				folderVO.setOwnerId(company.getCn());
				folderVO.setUseStatus("Y");
				folderVO.setUpdateId(userId);
				folderVO.setCreateName1(userInfo.getDisplayName1());
				folderVO.setCreateName2(userInfo.getDisplayName2());
				folderVO.setTenantId(tenantId);
				folderVO.setCompanyId(company.getCn());
				folderVO.setCreateId(userId);
				folderVO.setCreateDate(timeUTC);
				folderVO.setUpdateDate(timeUTC);
				
				ezWebFolderAdminService.insertFolder2(folderVO);
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
		String mode       = request.getParameter("mode")     != null ? request.getParameter("mode")    : "";
		String userId     = request.getParameter("userId")   != null ? request.getParameter("userId")  : "";
		JSONObject result = new JSONObject();
		
		logger.debug("folderId: " + folderId + " || serverName: " + serverName);
		
		if (folderId.equals("") || serverName.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", "1");
			return result;
		}
		
		try {
			LoginVO userInfo      = commonUtil.getUserForGw(userId, serverName);
			int tenantId          = userInfo.getTenantId();
			FolderSimpleVO folder = ezWebFolderService.getSimpleFolder(folderId, tenantId);
			if (mode.equals("1") && folder.getFolderLevel() == 0) {
				List<FolderSimpleVO> listCompSubFolders = ezWebFolderService.getCompanySubSimpleFolder(userInfo.getId(), userInfo.getDeptID(), folder.getFolderId(), tenantId);
				folder.setListSubFolders(listCompSubFolders);
			}
			else {
				ezWebFolderService.getAllSubDepts(folder, tenantId, 1);
			}
			
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
	public JSONObject getFolderUsers(@PathVariable(value="folderid") String folderId, HttpServletRequest request, Locale locale) {
		String serverName = request.getHeader("host-name")   != null ? request.getHeader("host-name") : "";
		String userId     = request.getParameter("userId")   != null ? request.getParameter("userId") : "";
		String mode       = request.getParameter("mode")     != null ? request.getParameter("mode")   : "";
		JSONObject result = new JSONObject();
		
		logger.debug("folderId: " + folderId + " || serverName: " + serverName);
		
		if (folderId.equals("") || serverName.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", "1");
			result.put("reason", egovMessageSource.getMessage("ezWebFolder.t244", locale));
			return result;
		}
		
		try {
			LoginVO userInfo             = commonUtil.getUserForGw(userId, serverName);
			int tenantId                 = userInfo.getTenantId();
			String offset                = userInfo.getOffset();
			List<FolderUserVO> listUsers = new ArrayList<FolderUserVO>();
			FolderVO folder              = ezWebFolderService.getFolderByFolderId(folderId, offset, tenantId);
			String folderPath            = folder.getFolderPath();
			folderPath                   = folderPath.substring(1, folderPath.length() - 1);
			
			if (mode.equals("")) {
				String ancestorId = folderPath.split("\\|")[1];
				listUsers         = ezWebFolderService.getFolderUsers(ancestorId, tenantId);
			}
			else {
				String ancestorId = folderPath.split("\\|")[0];
				listUsers         = ezWebFolderService.getFolderUsers(ancestorId, tenantId);
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
			result.put("reason", egovMessageSource.getMessage("ezWebFolder.t134", locale));
		}
		
		return result;
	}

	@RequestMapping(value="/rest/ezwebfolderadmin/folders/{folderid}", method= RequestMethod.DELETE, produces="application/json;charset=utf-8")
	public JSONObject delCompanyFolder(@PathVariable(value="folderid") String folderId, HttpServletRequest request, Locale locale) throws Exception {
		String serverName = request.getHeader("host-name") != null ? request.getHeader("host-name") : "";
		String userId     = request.getParameter("userId") != null ? request.getParameter("userId") : "";
		JSONObject result = new JSONObject();
		
		if (folderId.equals("") || serverName.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", "1");
			result.put("reason", egovMessageSource.getMessage("ezWebFolder.t244", locale));
			return result;
		}
		
		logger.debug("FolderId: " + folderId + " || serverName: " + serverName);
		
		try {
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			String offset    = userInfo.getOffset();
			FolderVO folder  = ezWebFolderService.getFolderByFolderId(folderId, offset, userInfo.getTenantId());
			ezWebFolderService.updateFolderUseStatus(folder, userInfo);
			
			result.put("status", "ok");
			result.put("code", 0);
		}
		catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
			result.put("reason", egovMessageSource.getMessage("ezWebFolder.t134", locale));
		}
		
		return result;
	}

	@RequestMapping(value="/rest/ezwebfolderadmin/folders/{folderid}/modes/{mode}/folder-move", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject putCompanyFolderMove(@PathVariable(value="folderid") String folderId, @PathVariable(value="mode") String mode, Locale locale, HttpServletRequest request) throws Exception {
		String serverName   = request.getHeader("host-name")    != null ? request.getHeader("host-name")    : "";
		String userId       = request.getParameter("userId")    != null ? request.getParameter("userId")    : "";
		String destFolderId = request.getParameter("parentFld") != null ? request.getParameter("parentFld") : "";
		JSONObject result   = new JSONObject();
		
		logger.debug("FolderID: " + folderId + " || serverName: " + serverName + " || destination: " + destFolderId + " || mode: " + mode);
		
		if (folderId.equals("") || serverName.equals("") || destFolderId.equals("") || mode.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", "1");
			result.put("reason", egovMessageSource.getMessage("ezWebFolder.t244", locale));
			return result;
		}
		
		try {
			LoginVO userInfo    = commonUtil.getUserForGw(userId, serverName);
			int tenantId        = userInfo.getTenantId();
			String offset       = userInfo.getOffset();
			FolderVO folder     = ezWebFolderService.getFolderByFolderId(folderId, offset, tenantId);
			FolderVO destFolder = ezWebFolderService.getFolderByFolderId(destFolderId, offset, tenantId);
			
			//Check copy/move conditions
			if (folder.getFolderUpper().equals(destFolderId)) {
				result.put("status", "error");
				result.put("reason", egovMessageSource.getMessage("ezWebFolder.t224", locale));
				result.put("code", 1);
				return result;
			}
			
			int pos = destFolder.getFolderPath().indexOf(folder.getFolderPath());
			
			if (pos != -1) {
				result.put("status", "error");
				result.put("reason", egovMessageSource.getMessage("ezWebFolder.t245", locale));
				result.put("code", 1);
				return result;
			}
			
			String realPath = request.getServletContext().getRealPath("");
			ezWebFolderAdminService.moveCompanyFolder(folder, destFolder, mode, realPath, userInfo);
			
			result.put("status", "ok");
			result.put("code", 0);
		}
		catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
			result.put("reason", egovMessageSource.getMessage("ezWebFolder.t134", locale));
		}
		
		return result;
	}

	@RequestMapping(value="/rest/ezwebfolderadmin/folders/{folderid}/file-list", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getFileList(@PathVariable(value="folderid") String folderId, HttpServletRequest request, Locale locale) {
		String serverName = request.getHeader("host-name")      != null ? request.getHeader("host-name")    : "";
		String userId     = request.getParameter("userId")      != null ? request.getParameter("userId")    : "";
		String startDate  = request.getParameter("startDate")   != null ? request.getParameter("startDate") : "";
		String endDate    = request.getParameter("endDate")     != null ? request.getParameter("endDate")   : "";
		String fileExt    = request.getParameter("fileExt")     != null ? request.getParameter("fileExt")   : "";
		String fileName   = request.getParameter("fileName")    != null ? request.getParameter("fileName")  : "";
		String userName   = request.getParameter("userName")    != null ? request.getParameter("userName")  : "";
		String fileType   = request.getParameter("fileType")    != null ? request.getParameter("fileType")  : "";
		String column     = request.getParameter("column")      != null ? request.getParameter("column")    : "";
		String order      = request.getParameter("order")       != null ? request.getParameter("order")     : "";
		String listCnt    = request.getParameter("listCnt")     != null ? request.getParameter("listCnt")   : "";
		String searchChk  = "1";
		int currPage      = request.getParameter("currentPage") != null ? Integer.parseInt(request.getParameter("currentPage")) :  1;
		int totalRows     = 0;
		int totalPages    = 0;
		int pageSize      = listCnt.equals("") ? 10 : Integer.parseInt(listCnt);
		int startPoint    = 0;
		String realColmn  = "";
		
		JSONObject result = new JSONObject();
		
		if (folderId.equals("") || serverName.equals("") || userId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", "1");
			result.put("reason", egovMessageSource.getMessage("ezWebFolder.t244", locale));
			return result;
		}
		
		logger.debug("FolderId: " + folderId + " || serverName: " + serverName + " || Current Page: " + currPage);
		
		try {
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			int tenantId     = userInfo.getTenantId();
			String primary   = userInfo.getPrimary();
			String offset    = userInfo.getOffset();
			
			if (!column.equals("") && !order.equals("")) {
				switch(column) {
					case "ft": realColmn = "FILETYPE_ICON"                                      ; break;
					case "fn": realColmn = "FILE_NAME"                                          ; break;
					case "fs": realColmn = "FILE_SIZE"                                          ; break;
					case "un": realColmn = primary.equals("1") ? "CREATE_NAME1" : "CREATE_NAME2"; break;
					case "cd": realColmn = "CREATE_DATE"                                        ; break;
					case "ud": realColmn = "UPDATE_DATE"                                        ; break;
					case "dt": realColmn = "DOWN_COUNT"                                         ; break;
					default  : realColmn = "FILE_NAME"                                          ; break;
				}
			}
			
			logger.debug("Column: " + realColmn + " || order: " + order);
					
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
			String originalPath   = ezWebFolderService.getFolderPath(folderPath.split("\\|"), primary, tenantId);
			
			if (folder.getFolderUpper().equals("root")) {
				Map<String, String> filePathMap = new LinkedHashMap<String, String>();
				totalRows                       = ezWebFolderService.getTotalFileCnt2(folder.getFolderPath(), searchChk, startDate, endDate, fileExt, fileName, userName, fileType, primary, tenantId);
				totalPages                      = (totalRows + pageSize - 1)/pageSize;
				currPage                        = currPage > totalPages ? totalPages : currPage;
				currPage                        = currPage == 0         ? 1          : currPage;
				startPoint                      = (currPage - 1) * pageSize;
				fileList                        = ezWebFolderService.getAllFiles(realColmn, order.toUpperCase(), folder.getFolderPath(), originalPath, searchChk, startDate, endDate, fileExt, fileName, userName, fileType, startPoint, pageSize, primary, offset, tenantId);
				
				//New way 30-50% faster
				if (fileList.size() > 0) {
					String []rootPath               = folderPath.split("\\|");
					Set<String> testbnk             = new HashSet<String>();
					
					for (FileVO file : fileList) {
						String fldPath      = file.getFolderPath().substring(1, file.getFolderPath().length() - 1);
						String[] fldPathArr = fldPath.split("\\|");
						testbnk.addAll(Arrays.asList(fldPathArr));
					}
					
					List<String> listName = new ArrayList<String>(testbnk);
					filePathMap           = ezWebFolderService.getAllFolderNameMap(listName, primary, tenantId);
					
					for (FileVO file : fileList) {
						if (file.getFilePosition() == null || file.getFilePosition().equals("")) {
							String file_path    = originalPath;
							String fldPath      = file.getFolderPath().substring(1, file.getFolderPath().length() - 1);
							String[] fldPathArr = fldPath.split("\\|");
							
							for (int i = rootPath.length; i < fldPathArr.length; i++) {
								file_path += filePathMap.get(fldPathArr[i]) + "/";
							}
							
							file.setFilePosition(file_path + file.getFileName());
						}
					}
				}
			}
			else {
				totalRows  = ezWebFolderService.getTotalFileCnt(folderId, searchChk, startDate, endDate, fileExt, fileName, userName, fileType, primary, tenantId);
				totalPages = (totalRows + pageSize - 1)/pageSize;
				currPage   = currPage > totalPages ? totalPages : currPage;
				currPage   = currPage == 0         ? 1          : currPage;
				startPoint = (currPage - 1) * pageSize;
				fileList   = ezWebFolderService.getAllFilesInFolder(realColmn, order.toUpperCase(), folderId, originalPath, searchChk, startDate, endDate, fileExt, fileName, userName, fileType, startPoint, pageSize, primary, offset, tenantId);
			}
			
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
			result.put("reason", egovMessageSource.getMessage("ezWebFolder.t134", locale));
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezwebfolderadmin/company-id/{userid}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getCompanyId(@PathVariable(value="userid") String userId, HttpServletRequest request, Locale locale) {
		String serverName = request.getHeader("host-name")   != null ? request.getHeader("host-name") : "";
		JSONObject result = new JSONObject();
		logger.debug("serverName: " + serverName);
		
		if (serverName.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			result.put("reason", egovMessageSource.getMessage("ezWebFolder.t244", locale));
			return result;
		}
		
		try {
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			
			result.put("data", userInfo.getCompanyID());
			result.put("status", "ok");
			result.put("code", 0);
		} 
		catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			result.put("reason", egovMessageSource.getMessage("ezWebFolder.t134", locale));
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezwebfolderadmin/company-list/{userid}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getCompanyList(@PathVariable(value="userid") String userId, HttpServletRequest request, Locale locale) {
		String serverName = request.getHeader("host-name")   != null ? request.getHeader("host-name") : "";
		String mode       = request.getParameter("mode")     != null ? request.getParameter("mode")   : "";
		JSONObject result = new JSONObject();
		logger.debug("serverName: " + serverName);
		
		if (serverName.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			result.put("reason", egovMessageSource.getMessage("ezWebFolder.t244", locale));
			return result;
		}
		
		try {
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			
			//Get list of companies
			List<OrganDeptVO> resultList = new ArrayList<OrganDeptVO>();
			
			if (userInfo.getRollInfo().indexOf("c=1")  > -1 && !mode.equals("normal")) {
				resultList = ezOrganAdminService.getCompanyList(userInfo.getPrimary(), userInfo.getTenantId());
			}
			else {
				OrganDeptVO dept = ezOrganService.getDeptInfo(userInfo.getCompanyID(), userInfo.getPrimary(), userInfo.getTenantId());
				resultList.add(dept);
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
			result.put("reason", egovMessageSource.getMessage("ezWebFolder.t134", locale));
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezwebfolderadmin/folders/dept", method= RequestMethod.POST, produces="application/json;charset=utf-8")
	public JSONObject postDeptFolderInsert(@RequestBody JSONObject jsonObject, HttpServletRequest request) throws ParseException {
		JSONParser parser      = new JSONParser();
		jsonObject             = (JSONObject) parser.parse(jsonObject.toJSONString());
		String serverName      = request.getHeader("host-name") != null ? request.getHeader("host-name")       : "";
		String userId          = jsonObject.get("userId")       != null ? (String) jsonObject.get("userId")    : "";
		String pFolderId       = jsonObject.get("pFolderId")    != null ? (String) jsonObject.get("pFolderId") : "";
		String folderName      = jsonObject.get("fName")        != null ? (String) jsonObject.get("fName")     : "";
		String folderName2     = jsonObject.get("fName2")       != null ? (String) jsonObject.get("fName2")    : "";
		JSONObject result      = new JSONObject();
		
		if (pFolderId.equals("") || userId.equals("") || folderName.equals("") || serverName.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", "1");
			return result;
		}
		
		logger.debug("serverName: " + serverName + " || folderName: " + folderName + " || ParentFolderID: " + pFolderId);
		
		try {
			LoginVO userInfo           = commonUtil.getUserForGw(userId, serverName);
			String userName1           = userInfo.getDisplayName1();
			String userName2           = userInfo.getDisplayName2();
			int tenantId               = userInfo.getTenantId();
			String offset              = userInfo.getOffset();
			FolderVO parentFolder      = ezWebFolderService.getFolderByFolderId(pFolderId, offset, tenantId);
			FolderVO folder            = new FolderVO();
			SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			Date date                  = new Date();
			String timeUTC             = commonUtil.getDateStringInUTC(formatter.format(date), offset, true);
			String folderId            = ezWebFolderAdminService.getMaxFolderID(tenantId);
			
			folder.setFolderId(folderId);
			folder.setFolderLevel(parentFolder.getFolderLevel() + 1);
			folder.setFolderName1(folderName);
			folder.setFolderName2(folderName2);
			folder.setFolderPath(parentFolder.getFolderPath() + folderId + "|");
			folder.setFolderStep(ezWebFolderAdminService.getMaxFolderStep(pFolderId, tenantId));
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
		String userId          = jsonObject.get("userId")       != null ? (String) jsonObject.get("userId") : "";
		String folderName      = jsonObject.get("fName")        != null ? (String) jsonObject.get("fName")  : "";
		String folderName2     = jsonObject.get("fName2")       != null ? (String) jsonObject.get("fName2") : "";
		JSONObject result      = new JSONObject();
		
		if (folderId.equals("") || userId.equals("") || folderName.equals("") || serverName.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", "1");
			return result;
		}
		
		logger.debug("serverName: " + serverName + " || folderName: " + folderName + " || folderID: " + folderId);
		
		try {
			LoginVO userInfo           = commonUtil.getUserForGw(userId, serverName);
			int tenantId               = userInfo.getTenantId();
			String offset              = userInfo.getOffset();
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
	
	@RequestMapping(value="/rest/ezwebfolderadmin/company-folder/{companyid}", method= RequestMethod.POST, produces="application/json;charset=utf-8")
	public JSONObject postMakeCompanyFolder(@PathVariable(value="companyid") String companyId, HttpServletRequest request, Locale locale) throws Exception {
		String serverName = request.getHeader("host-name") != null ? request.getHeader("host-name") : "";
		String userId     = request.getParameter("userId") != null ? request.getParameter("userId") : "";
		JSONObject result = new JSONObject();
		
		logger.debug("serverName: " + serverName + " || companyId: " + companyId);
		
		if (serverName.equals("") || companyId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", "1");
			result.put("reason", egovMessageSource.getMessage("ezWebFolder.t244", locale));
			return result;
		}
		
		try {
			LoginVO userInfo           = commonUtil.getUserForGw(userId, serverName);
			int tenantId               = userInfo.getTenantId();
			String primary             = userInfo.getPrimary();
			String offset              = userInfo.getOffset();
			OrganDeptVO company        = ezOrganService.getDeptInfo(companyId, primary, tenantId);
			FolderVO folder            = new FolderVO();
			SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			Date date                  = new Date();
			String timeUTC             = commonUtil.getDateStringInUTC(formatter.format(date), offset, true);
			String folderId            = ezWebFolderAdminService.getMaxFolderID(tenantId);
			
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
			
			ezWebFolderAdminService.insertFolder2(folder);
			
			result.put("status", "ok");
			result.put("code", 0);
		}
		catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
			result.put("reason", egovMessageSource.getMessage("ezWebFolder.t134", locale));
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezwebfolderadmin/dept-folder/{companyid}", method= RequestMethod.POST, produces="application/json;charset=utf-8")
	public JSONObject postMakeDepartmentFolder(@PathVariable(value="companyid") String companyId, HttpServletRequest request, Locale locale) throws Exception {
		String serverName = request.getHeader("host-name") != null ? request.getHeader("host-name") : "";
		String userId     = request.getParameter("userId") != null ? request.getParameter("userId") : "";
		JSONObject result = new JSONObject();
		
		logger.debug("serverName: " + serverName + " || || companyId: " + companyId);
		
		if (serverName.equals("") || companyId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", "1");
			result.put("reason", egovMessageSource.getMessage("ezWebFolder.t244", locale));
			return result;
		}
		
		try {
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			ezWebFolderAdminService.addDeptFolders(companyId, userInfo);
			
			result.put("status", "ok");
			result.put("code", 0);
		}
		catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
			result.put("reason", egovMessageSource.getMessage("ezWebFolder.t134", locale));
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezwebfolder/foldersTree/file", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getFileFolderTree(HttpServletRequest request) {
		String userId     = request.getParameter("userId")    != null ? request.getParameter("userId")    : "";
		String fileList   = request.getParameter("fileList")  != null ? request.getParameter("fileList")  : "";
		String companyId  = request.getParameter("companyId") != null ? request.getParameter("companyId") : "";
		String mode       = request.getParameter("mode")      != null ? request.getParameter("mode")      : "";
		String type       = request.getParameter("type")      != null ? request.getParameter("type")      : "";
		String serverName = request.getHeader("host-name")    != null ? request.getHeader("host-name")    : "";
		String[] fileArr  = fileList.split(",");
		JSONObject result = new JSONObject();
		
		if (serverName.equals("") || mode.equals("") || type.equals("") || fileArr.length == 0) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", "1");
			return result;
		}
		
		logger.debug("Mode: " + mode + " || fileList: " + fileList + " || type: " + type + " || companyId: " + companyId + " || serverName: " + serverName);
		
		try {
			LoginVO userInfo     = commonUtil.getUserForGw(userId, serverName);
			int tenantId         = userInfo.getTenantId();
			List<String> fileIds = Arrays.asList(fileArr);
			List<String> folders = ezWebFolderService.getFolderListFromFileId(fileIds, tenantId);
			companyId            = companyId.equals("") ? userInfo.getCompanyID() : companyId;
			
			switch (type) {
				case "comp":
					//Get company folder tree
					FolderSimpleVO company = new FolderSimpleVO();
					if (isWebfolderAdmin(userInfo) && mode.equalsIgnoreCase("admin")) {
						company = ezWebFolderService.getCompanySimpleFolder(companyId, userInfo);
						ezWebFolderService.getAllSubDepts(company, tenantId, 2);
					}
					else {
						company                                 = ezWebFolderService.getCompanySimpleFolder(userInfo.getCompanyID(), userInfo);
						List<FolderSimpleVO> listCompSubFolders = ezWebFolderService.getCompanySubSimpleFolder(userInfo.getId(), userInfo.getDeptID(), company.getFolderId(), tenantId);
						
						if (listCompSubFolders != null && listCompSubFolders.size() > 0) {
							company.setHasSubFolder(1);
						}
						else {
							company.setHasSubFolder(0);
						}
					}
					
					result.put("data", company);
					break;
				case "dept":
					//Get department folder tree
					List<FolderSimpleVO> listFolders = new ArrayList<FolderSimpleVO>();
					if (isWebfolderAdmin(userInfo) && mode.equalsIgnoreCase("admin")) {
						listFolders = ezWebFolderService.getAllSimpleDeptFolder(companyId, userInfo);
					}
					else {
						listFolders = ezWebFolderService.getDeptFolderTreeForUser(userId, userInfo.getDeptID(), tenantId);
					}
					
					result.put("data", listFolders);
					
					break;
				case "user":
					//Get personal folder tree
					FolderSimpleVO personalFolder = ezWebFolderService.getUserSimpleFolder(userId, tenantId);
					
					//If not created then create
					if (personalFolder == null) {
						ezWebFolderAdminService.addPersonalFolder(userInfo);
						personalFolder = ezWebFolderService.getUserSimpleFolder(userId, tenantId);
					}
					
					result.put("data", personalFolder);
					break;
				case "share":
					//Get share folder tree
					List<FolderSimpleVO> shareFolders = new ArrayList<FolderSimpleVO>();
					shareFolders = ezWebFolderService.getAllSimpleShareFolder(userId, userInfo.getDeptID(), companyId, tenantId);
					result.put("data", shareFolders);
					break;
			}
			
			result.put("currentFolders", folders);
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
	
	@RequestMapping(value="/rest/ezwebfolder/dept-chief/{userid}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject checkChief(@PathVariable(value="userid") String userId, HttpServletRequest request) {
		String serverName = request.getHeader("host-name")   != null ? request.getHeader("host-name") : "";
		JSONObject result = new JSONObject();
		
		logger.debug("ServerName: " + serverName + " || userId: " + userId);
		
		if (serverName.equals("") || userId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			return result;
		}
		
		try {
			int tenantId  = loginService.getTenantId(serverName);
			boolean check = ezWebFolderService.checkDepartChief(userId, tenantId);
			
			if (check == true) {
				result.put("data", "1");
			}
			else {
				result.put("data", "0");
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
	
	@RequestMapping(value="/rest/ezwebfolder/users/{userid}/env/list-count", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getListCount(@PathVariable(value="userid") String userId, HttpServletRequest request) {
		String serverName = request.getHeader("host-name")   != null ? request.getHeader("host-name") : "";
		JSONObject result = new JSONObject();
		
		logger.debug("ServerName: " + serverName + " || userId: " + userId);
		
		if (serverName.equals("") || userId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			return result;
		}
		
		try {
			int tenantId         = loginService.getTenantId(serverName);
			WebfolderEnvVO envVO = ezWebFolderService.getListCount(userId, tenantId);
			
			result.put("data", envVO);
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
	
	@RequestMapping(value="/rest/ezwebfolder/env/{listcount}/update", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject updateEnvListCount(@PathVariable(value="listcount") String listCount, HttpServletRequest request) {
		String serverName = request.getHeader("host-name")   != null ? request.getHeader("host-name") : "";
		String userId     = request.getParameter("userId")   != null ? request.getParameter("userId") : "";
		JSONObject result = new JSONObject();
		
		logger.debug("ServerName: " + serverName + " || userId: " + userId + " || listCount: " + listCount);
		
		if (serverName.equals("") || userId.equals("") || listCount.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			return result;
		}
		
		try {
			int tenantId         = loginService.getTenantId(serverName);
			ezWebFolderService.updateListCount(userId, listCount, tenantId);
			
			result.put("data", "");
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
	
	@RequestMapping(value="/rest/ezwebfolder/depart-tree/chief/{userid}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getDeptTree(@PathVariable(value="userid") String userId, HttpServletRequest request) {
		String serverName = request.getHeader("host-name") != null ? request.getHeader("host-name") : "";
		JSONObject result = new JSONObject();
		
		if (userId.equals("") || serverName.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", "1");
			return result;
		}
		
		logger.debug("userId: " + userId + " || serverName: " + serverName);
		
		try {
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			int tenantId     = userInfo.getTenantId();
			String primary   = userInfo.getPrimary();
			boolean check    = ezWebFolderService.checkDepartChief(userId, tenantId);
			
			if (check == false) {
				logger.debug("Privileges!");
				result.put("status", "error");
				result.put("code", "1");
				return result;
			}
			
			List<SimpleDeptVO> listDepts           = ezWebFolderService.getAllDeptsForChief(userId, 0, primary, tenantId);
			List<SimpleDeptVO> listSelectedDepts   = ezWebFolderService.getSelectedDeptsForChief(userId, 0, primary, tenantId);
			
			result.put("data", listDepts);
			result.put("selectedDepts", listSelectedDepts);
			result.put("userDept", userInfo.getDeptID());
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
	
	@RequestMapping(value="/rest/ezwebfolder/selected-dept/chief/{userid}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getSelectedDepts(@PathVariable(value="userid") String userId, HttpServletRequest request) {
		String serverName = request.getHeader("host-name") != null ? request.getHeader("host-name") : "";
		JSONObject result = new JSONObject();
		
		if (userId.equals("") || serverName.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", "1");
			return result;
		}
		
		logger.debug("userId: " + userId + " || serverName: " + serverName);
		
		try {
			LoginVO userInfo                     = commonUtil.getUserForGw(userId, serverName);
			int tenantId                         = userInfo.getTenantId();
			String primary                       = userInfo.getPrimary();
			List<SimpleDeptVO> listSelectedDepts = ezWebFolderService.getSelectedDeptsForChief(userId, 0, primary, tenantId);
			
			result.put("data", listSelectedDepts);
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
	
	@RequestMapping(value="/rest/ezwebfolder/env/dept-list", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject updateEnvDeptList(@RequestParam("deptList") List<String> deptsList, HttpServletRequest request) {
		String serverName = request.getHeader("host-name") != null ? request.getHeader("host-name") : "";
		String userId     = request.getParameter("userId") != null ? request.getParameter("userId") : "";
		JSONObject result = new JSONObject();
		
		logger.debug("ServerName: " + serverName + " || userId: " + userId);
		
		if (serverName.equals("") || userId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			return result;
		}
		
		try {
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			ezWebFolderAdminService.updateSelectedDeptsForChief(deptsList, userInfo);
			
			result.put("data", "");
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
	
	@RequestMapping(value="/rest/ezwebfolder/permission-check/{userid}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject checkPermission(@PathVariable(value="userid") String userId, HttpServletRequest request) {
		String fileList   = request.getParameter("fileList") != null ? request.getParameter("fileList") : "";
		String fileId     = request.getParameter("fileId")   != null ? request.getParameter("fileId")   : "";
		String serverName = request.getHeader("host-name")   != null ? request.getHeader("host-name")   : "";
		JSONObject result = new JSONObject();
		
		if (userId.equals("") || serverName.equals("") || (fileId.equals("") && fileList.equals(""))) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", "1");
			return result;
		}
		
		logger.debug("userId: " + userId + " || serverName: " + serverName + " || fileList: " + fileList + " || fileId: " + fileId);
		
		try {
			LoginVO userInfo  = commonUtil.getUserForGw(userId, serverName);
			int tenantId      = userInfo.getTenantId();
			String offset     = userInfo.getOffset();
			
			if (!fileId.equals("")) {
				FileVO fileVO = ezWebFolderService.getFileByFileId(fileId, offset, tenantId);
				result.put("data", fileVO.getCreateId().equals(userId) ? "ok" : "error");
			}
			else {
				int totalFiles = fileList.split(",").length;
				fileList       = "'" + fileList + "'";
				fileList       = fileList.replace(",", "','");
				int count      = ezWebFolderService.checkFilesOwner(userId, fileList, tenantId);
				result.put("data", count == totalFiles ? "ok" : "error");
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
	
	@RequestMapping(value="/rest/ezwebfolderadmin/dept-check/{folderid}", method= RequestMethod.POST, produces="application/json;charset=utf-8")
	public JSONObject getCheckValidDept(@PathVariable(value="folderid") String folderId, HttpServletRequest request, Locale locale) throws Exception {
		String serverName = request.getHeader("host-name") != null ? request.getHeader("host-name") : "";
		String userId     = request.getParameter("userId") != null ? request.getParameter("userId") : "";
		JSONObject result = new JSONObject();
		
		logger.debug("serverName: " + serverName + " || folderId: " + folderId);
		
		if (serverName.equals("") || folderId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", "1");
			result.put("reason", egovMessageSource.getMessage("ezWebFolder.t244", locale));
			return result;
		}
		
		try {
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			int tenantId     = userInfo.getTenantId();
			String primary   = userInfo.getPrimary();
			String offset    = userInfo.getOffset();
			FolderVO folder  = ezWebFolderService.getFolderByFolderId(folderId, offset, tenantId);
			OrganDeptVO dept = ezOrganService.getDeptInfo(folder.getOwnerId(), primary, tenantId);
			
			if (dept == null) {
				result.put("status", "ok");
				result.put("code", 0);
			}
			else {
				result.put("status", "error");
				result.put("reason", egovMessageSource.getMessage("ezWebFolder.t134", locale));
				result.put("code", 0);
			}
		}
		catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
			result.put("reason", egovMessageSource.getMessage("ezWebFolder.t134", locale));
		}
		
		return result;
	}
	
	@RequestMapping(value = "/rest/ezwebfolder/download-excel", method=RequestMethod.GET, produces = { MediaType.APPLICATION_OCTET_STREAM_VALUE})
	public void getFileExcel(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String fileName     = request.getParameter("fileName")   != null ? request.getParameter("fileName")   : "";
		String serverName   = request.getHeader("host-name")     != null ? request.getHeader("host-name")     : "";
		String userAgent    = request.getParameter("userAgent")  != null ? request.getParameter("userAgent")  : "";
		
		logger.debug("serverName: " + serverName + " || File Name: " + fileName);
		
		if (serverName.equals("") || fileName.equals("")) {
			logger.debug("downloadAttach illegal arguments!");
			return;
		}
		
		//Get absolute path of the application
		String realPath  = request.getServletContext().getRealPath("");
		int tenantId     = loginService.getTenantId(serverName);
		ezWebFolderAdminService.getExcelFile(fileName, realPath, userAgent, response, tenantId);
		
		logger.debug("File Download Finish!");
		return;
	}
	
	@RequestMapping(value="/rest/ezwebfolder/check-wfadmin/{userid}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject checkWfAdmin(@PathVariable(value="userid") String userId, HttpServletRequest request, Locale locale) {
		String serverName = request.getHeader("host-name") != null ? request.getHeader("host-name") : "";
		JSONObject result = new JSONObject();
		
		logger.debug("ServerName: " + serverName + " || userId: " + userId);
		
		if (serverName.equals("") || userId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			result.put("reason", egovMessageSource.getMessage("ezWebFolder.t244", locale));
			return result;
		}
		
		try {
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			boolean check = isWebfolderAdmin(userInfo);
			
			if (check == true) {
				result.put("data", "1");
			}
			else {
				result.put("data", "0");
				result.put("reason", egovMessageSource.getMessage("ezWebFolder.t28", locale));
			}
			
			result.put("status", "ok");
			result.put("code", 0);
		} 
		catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			result.put("reason", egovMessageSource.getMessage("ezWebFolder.t134", locale));
		}
		
		return result;
	}
	
	private boolean isWebfolderAdmin(LoginVO user) {
		return isWebfolderAdmin(user.getRollInfo());
	}
	
	private boolean isWebfolderAdmin(String rollInfo) {
		return rollInfo.contains("c=1") || rollInfo.contains("k=1") || rollInfo.contains("wf=1");
	}
}
