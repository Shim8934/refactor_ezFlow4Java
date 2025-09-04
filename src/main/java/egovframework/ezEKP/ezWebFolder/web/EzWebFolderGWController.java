package egovframework.ezEKP.ezWebFolder.web;

import java.io.File;
import java.io.IOException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Optional;
import java.util.Properties;
import java.util.Set;
import java.util.TimeZone;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.websocket.server.PathParam;

import org.apache.commons.lang3.Validate;
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
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.util.UriComponentsBuilder;

import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderAdminService;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderService;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderService_y;
import egovframework.ezEKP.ezWebFolder.util.EzWebfolderUtil;
import egovframework.ezEKP.ezWebFolder.vo.DuplicateInfoVO;
import egovframework.ezEKP.ezWebFolder.vo.DuplicateInfoVO.Type;
import egovframework.ezEKP.ezWebFolder.vo.FileHistoryVO;
import egovframework.ezEKP.ezWebFolder.vo.FileLogVO;
import egovframework.ezEKP.ezWebFolder.vo.FileUploadVO;
import egovframework.ezEKP.ezWebFolder.vo.FileTypeVO;
import egovframework.ezEKP.ezWebFolder.vo.FileVO;
import egovframework.ezEKP.ezWebFolder.vo.FolderSimpleVO;
import egovframework.ezEKP.ezWebFolder.vo.FolderUserVO;
import egovframework.ezEKP.ezWebFolder.vo.FolderVO;
import egovframework.ezEKP.ezWebFolder.vo.SimpleDeptVO;
import egovframework.ezEKP.ezWebFolder.vo.SimpleUserVO;
import egovframework.ezEKP.ezWebFolder.vo.UserCapacityVO;
import egovframework.ezEKP.ezWebFolder.vo.WebfolderConfigVO;
import egovframework.ezEKP.ezWebFolder.vo.WebfolderEnvVO;
import egovframework.ezEKP.ezWebFolder.vo.result.UploadResult;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.collection.ChainMap;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.Offset;
import egovframework.let.utl.rest.Result;
import egovframework.let.utl.sim.service.EgovFileScrty;

@SuppressWarnings("unchecked")
@RestController
public class EzWebFolderGWController {
	@Resource(name = "EzWebFolderAdminService")
	private EzWebFolderAdminService ezWebFolderAdminService;
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private EgovFileScrty egovFileScrty;

	@Autowired
	private EzWebfolderUtil webfolderUtil;

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
	
	@Autowired
	private Properties globals;
	
	private static final Logger logger = LoggerFactory.getLogger(EzWebFolderGWController.class);

	@RequestMapping(value = {"/rest/ezwebfolderadmin/default/capacity", "/rest/ezwebfolderadmin/default/capacity/{companyId:.+}"},
			method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getDefaultCapacity(@PathVariable Optional<String> companyId, HttpServletRequest request) {
		logger.debug("ezWebFolder GW getDefaultCapacity start");
		String serverName = request.getHeader("x-user-host");
		JSONObject result = new JSONObject();
		logger.debug("companyId: {}, serverName: {}", companyId.orElse(""), serverName);

		if (containsNull(serverName)) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}

		try {
			int tenantId = loginService.getTenantId(serverName);
			WebfolderConfigVO webfolderConfig;
			
			if (companyId.isPresent()) {
				webfolderConfig = ezWebFolderAdminService.getWebfolderConfig(companyId.get(), tenantId);
			} else {
				webfolderConfig = ezWebFolderAdminService.getEveryCompanyConfig(tenantId);
			}

			result.put("status", "ok");
			result.put("code", 0);
			result.put("config", webfolderConfig);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}

		logger.debug("ezWebFolder GW getDefaultCapacity end");
		return result;
	}

	@RequestMapping(value = {"/rest/ezwebfolderadmin/default/capacity", "/rest/ezwebfolderadmin/default/capacity/{companyId:.+}"},
			method = RequestMethod.PUT, produces = "application/json;charset=utf-8")
	public JSONObject setDefaultCapacity(@PathVariable String companyId, HttpServletRequest request) {
		logger.debug("ezWebFolder GW setDefaultCapacity start");
		String serverName = request.getHeader("x-user-host");
		String uploadLimit = request.getParameter("uploadLimit");
		String companyLimit = request.getParameter("companyLimit");
		String departmentLimit = request.getParameter("departmentLimit");
		String userLimit = request.getParameter("userLimit");
		JSONObject result = new JSONObject();

		logger.debug("uploadLimit: {}, companyLimit: {}, departmentLimit: {}, userLimit: {}, companyId: {}, serverName: {}", uploadLimit, companyLimit, departmentLimit, userLimit, companyId, serverName);

		if (serverName == null || Stream.of(uploadLimit, companyLimit, departmentLimit, userLimit).allMatch(param -> param == null)) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}

		try {
			int tenantId = loginService.getTenantId(serverName);

			ezWebFolderAdminService.saveConfig(companyLimit, departmentLimit, userLimit, uploadLimit, companyId, tenantId);
			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}

		logger.debug("ezWebFolder GW setDefaultCapacity end");
		return result;
	}

	@RequestMapping(value = "/rest/ezwebfolderadmin/capacity/{type:companies|departments|users}/{id:.+}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getCapacity(@PathVariable String type, @PathVariable String id, HttpServletRequest request) {
		logger.debug("ezWebFolder GW getCapacity started");
		Map<String, Object> result = new HashMap<>();
		String serverName = request.getHeader("x-user-host");
		String primary = request.getParameter("primary");
		logger.debug("serverName: {}, type: {}, id: {}, primary: {}", serverName, type, id, primary);

		if (containsNull(serverName, type, id)) {
			logger.debug("parameter error");
			result.put("status", "error");
			result.put("code", 1);

			return new JSONObject(result);
		}

		try {
			type = getCapacityType(type);
			int tenantId = loginService.getTenantId(serverName);
			UserCapacityVO capacity = ezWebFolderAdminService.getCapacity(id, type, Optional.ofNullable(primary).orElse("1"), tenantId);

			if (capacity == null) {
				logger.debug("capacity is null");
				result.put("status", "error");
				result.put("code", 3);

				return new JSONObject(result);
			}

			if (capacity.getTotalUsed().equals("0") || capacity.getTotalCapacity().equals("0")) {
				capacity.setUsedRate(0);
			} else {
				double totalCapByBytes = Double.parseDouble(capacity.getTotalCapacity()) * 10737418.24;
				capacity.setUsedRate((int) (Double.parseDouble(capacity.getTotalUsed()) / totalCapByBytes));
			}

			result.put("capacity", capacity);
			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception ex) {
			logger.error(ex.getMessage(), ex);
			result.put("status", "error");
			result.put("code", 2);
		}

		logger.debug("ezWebFolder GW getCapacity ended");
		return new JSONObject(result);
	}

	@RequestMapping(value = "/rest/ezwebfolderadmin/capacity/folder/{id:.+}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getFolderCapacity(@PathVariable String id, HttpServletRequest request) {
		logger.debug("ezWebFolder GW getCapacity started");
		Map<String, Object> result = new HashMap<>();
		String serverName = request.getHeader("x-user-host");
		String primary = request.getParameter("primary");
		logger.debug("serverName: {}, id: {}, primary: {}", serverName, id, primary);

		if (containsNull(serverName, id)) {
			logger.debug("parameter error");
			result.put("status", "error");
			result.put("code", 1);

			return new JSONObject(result);
		}

		try {
			int tenantId = loginService.getTenantId(serverName);
			UserCapacityVO capacity = ezWebFolderAdminService.getCapacity(id, Optional.ofNullable(primary).orElse("1"), tenantId);

			if (capacity == null) {
				logger.debug("capacity is null");
				result.put("status", "error");
				result.put("code", 3);

				return new JSONObject(result);
			}

			if (capacity.getTotalUsed().equals("0") || capacity.getTotalCapacity().equals("0")) {
				capacity.setUsedRate(0);
			} else {
				double totalCapByBytes = Double.parseDouble(capacity.getTotalCapacity()) * 10737418.24;
				capacity.setUsedRate((int) (Double.parseDouble(capacity.getTotalUsed()) / totalCapByBytes));
			}

			result.put("capacity", capacity);
			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception ex) {
			logger.error(ex.getMessage(), ex);
			result.put("status", "error");
			result.put("code", 2);
		}

		logger.debug("ezWebFolder GW getCapacity ended");
		return new JSONObject(result);
	}

	@RequestMapping(value = "/rest/ezwebfolderadmin/capacity/{type:companies|departments|users}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getCapacities(@PathVariable String type, HttpServletRequest request) {
		logger.debug("ezWebFolder GW getCapacities started");
		Map<String, Object> result = new HashMap<>();
		String serverName = request.getHeader("x-user-host");
		String companyId = request.getParameter("companyId");
		String primary = Optional.ofNullable(request.getParameter("primary")).orElse("1");
		String searchKeyword = Optional.ofNullable(request.getParameter("searchKeyword")).orElse("");
		String searchOption = Optional.ofNullable(request.getParameter("searchOption")).orElse("");
		String column = Optional.ofNullable(request.getParameter("column")).orElse("");
		String order = Optional.ofNullable(request.getParameter("order")).orElse("");

		int currPage = Optional.ofNullable(request.getParameter("currentPage")).map(Integer::parseInt).orElse(1);
		int totalSize = 0;
		int totalPages = 0;
		int pageSize = 10;
		int startPoint = (currPage - 1) * pageSize;
		String realColmn = "";

		logger.debug("type: {}, companyId: {}, serverName: {}, currentPage: {}, searchKeyword: {}, searchOption: {}, column: {}, order: {}", type, companyId, serverName, currPage, searchKeyword,
				searchOption, column, order);

		if (containsNull(serverName, type) || (!type.equals("companies") && containsNull(companyId.isEmpty()))) {
			logger.debug("parameter error");
			result.put("status", "error");
			result.put("code", 1);

			return new JSONObject(result);
		}

		try {
			type = getCapacityType(type);
			int tenantId = loginService.getTenantId(serverName);

			if (column.length() > 0 && order.length() > 0) {
				switch (column) {
				case "cn":
					realColmn = "COMPANY_NAME";
					break;
				case "dn":
					realColmn = "DEPARTMENT_NAME";
					break;
				case "un":
					realColmn = "DISPLAY_NAME";
					break;
				case "ut":
					realColmn = "JOB_TITLE";
					break;
				case "tc":
					realColmn = "TOTAL_CAPACITY";
					break;
				default:
					realColmn = "COMPANY_NAME";
					break;
				}
			}

			logger.debug("Column: " + realColmn + " || order: " + order);

			List<UserCapacityVO> capacityList = ezWebFolderAdminService.getCapacityList(type, primary, companyId, tenantId, realColmn, order, searchKeyword, searchOption, startPoint, pageSize);
			totalSize = ezWebFolderAdminService.getTotalCapacityCount(type, companyId, tenantId, searchKeyword, searchOption);
			totalPages = (totalSize + pageSize - 1) / pageSize;

			for (UserCapacityVO capacity : capacityList) {
				if (capacity.getTotalUsed().equals("0") || capacity.getTotalCapacity().equals("0")) {
					capacity.setUsedRate(0);
				} else {
					double totalCapByBytes = Double.parseDouble(capacity.getTotalCapacity()) * 10737418.24;
					capacity.setUsedRate((int) (Double.parseDouble(capacity.getTotalUsed()) / totalCapByBytes));
				}
			}

			result.put("capacityList", capacityList);
			result.put("totalSize", totalSize);
			result.put("totalPages", totalPages);
			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception ex) {
			logger.error(ex.getMessage(), ex);
			result.put("status", "error");
			result.put("code", 2);
		}

		logger.debug("ezWebFolder GW getCapacities ended");
		return new JSONObject(result);
	}

	@RequestMapping(value = "/rest/ezwebfolderadmin/capacity/{type:companies|departments|users}", method = RequestMethod.PUT, produces = "application/json;charset=utf-8")
	public JSONObject setCapacities(@PathVariable String type, @RequestParam("list") List<String> list, HttpServletRequest request) {
		logger.debug("ezWebFolder GW setCapacities start");
		String serverName = request.getHeader("x-user-host");
		String companyId = request.getParameter("companyId");
		String value = request.getParameter("value");
		JSONObject result = new JSONObject();

		logger.debug("type: {}, value: {}, companyId: {}, serverName: {}, list: {}", type, value, companyId, serverName, String.join(",", list));

		if (containsNull(serverName, type, list, companyId, value)) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}

		try {
			type = getCapacityType(type);
			int tenantId = loginService.getTenantId(serverName);

			ezWebFolderAdminService.setCapacities(list, type, value, companyId, tenantId);

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "");
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}

		logger.debug("ezWebFolder GW setCapacities end");
		return result;
	}

	@RequestMapping(value = "/rest/ezwebfolderadmin/capacity/reset/{type:companies|departments|users}", method = RequestMethod.PUT, produces = "application/json;charset=utf-8")
	public JSONObject resetCapacities(@PathVariable String type, @RequestParam("list") List<String> list, HttpServletRequest request) {
		logger.debug("ezWebFolder GW resetCapacities start");
		String serverName = request.getHeader("x-user-host");
		JSONObject result = new JSONObject();

		logger.debug("type: {}, serverName: {}, list: {}", type, serverName, String.join(",", list));

		if (containsNull(serverName, type, list)) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}

		try {
			int tenantId = loginService.getTenantId(serverName);
			type = getCapacityType(type);

			ezWebFolderAdminService.deleteCapacities(list, type, tenantId);

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "");
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}

		logger.debug("ezWebFolder GW resetCapacities end");
		return result;
	}

	private String getCapacityType(String pathParam) {
		switch (pathParam) {
		case "companies":
			return "C";
		case "departments":
			return "D";
		case "users":
			return "U";
		}

		return pathParam;
	}

//	@RequestMapping(value="/rest/ezwebfolderadmin/basicstorage/id/{companyid}/comp", method= RequestMethod.GET, produces="application/json;charset=utf-8")
//	public JSONObject getBasicStorage(@PathVariable(value="companyid") String companyId, HttpServletRequest request, Locale locale) {
//		logger.debug("getBasicStorage start");
//		String serverName = request.getHeader("x-user-host")   != null ? request.getHeader("x-user-host") : "";
//		JSONObject result = new JSONObject();
//		logger.debug("CompanyId: " + companyId + " || serverName: " + serverName);
//		
//		if (serverName.equals("") || companyId.equals("")) {
//			logger.debug("Parameter error!");
//			result.put("status", "error");
//			result.put("code", 1);
//			return result;
//		}
//		
//		try {
//			int tenantId                      = loginService.getTenantId(serverName);
//			WebfolderConfigVO webfolderConfig = ezWebFolderAdminService.getWebfolderConfig(companyId, tenantId);
//			result.put("status", "ok");
//			result.put("code", 0);
//			result.put("config", webfolderConfig);
//		} 
//		catch (Exception e) {
//			logger.error(e.getMessage(), e);
//			result.put("status", "error");
//			result.put("code", 2);
//		}
//		
//		logger.debug("getBasicStorage end");
//		return result;
//	}
//
//	@RequestMapping(value="/rest/ezwebfolderadmin/basicstorage/{newvalue}/comp", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
//	public JSONObject putChangeBasicStorage(@PathVariable(value="newvalue") String newValue, HttpServletRequest request, Locale locale) {
//		logger.debug("putChangeBasicStorage start");
//		String serverName  = request.getHeader("x-user-host")      != null ? request.getHeader("x-user-host")      : "";
//		String uploadLimit = request.getParameter("uploadLimit") != null ? request.getParameter("uploadLimit") : "";
//		String companyId   = request.getParameter("companyId")   != null ? request.getParameter("companyId")   : "";
//		JSONObject result  = new JSONObject();
//		
//		logger.debug("New Value: " + newValue + " || CompanyId: " + companyId +  " || serverName: " + serverName);
//		
//		if (serverName.equals("") || companyId.equals("") || uploadLimit.equals("") || newValue.equals("")) {
//			logger.debug("Parameter error!");
//			result.put("status", "error");
//			result.put("code", 1);
//			return result;
//		}
//		
//		try {
//			int tenantId = loginService.getTenantId(serverName);
//			ezWebFolderAdminService.saveConfig(companyLimit, departmentLimit, userLimit, uploadLimit, companyId, tenantId);
//			result.put("status", "ok");
//			result.put("code", 0);
//		} 
//		catch (Exception e) {
//			logger.error(e.getMessage(), e);
//			result.put("status", "error");
//			result.put("code", 2);
//		}
//		
//		logger.debug("putChangeBasicStorage end");
//		return result;
//	}
//
//	@RequestMapping(value="/rest/ezwebfolderadmin/basicstorage/id/{companyid}/person", method= RequestMethod.GET, produces="application/json;charset=utf-8")
//	public JSONObject getPersonalStorage(@PathVariable(value="companyid") String companyId, HttpServletRequest request, Locale locale) {
//		logger.debug("getPersonalStorage start");
//		String serverName = request.getHeader("x-user-host")      != null ? request.getHeader("x-user-host")                        : "";
//		int currPage      = request.getParameter("currentPage") != null ? Integer.parseInt(request.getParameter("currentPage")) :  1;
//		String searchStr  = request.getParameter("searchStr")   != null ? request.getParameter("searchStr")                     : "";
//		String searchOpt  = request.getParameter("searchOpt")   != null ? request.getParameter("searchOpt")                     : "";
//		String userId     = request.getParameter("userId")      != null ? request.getParameter("userId")                        : "";
//		String column     = request.getParameter("column")      != null ? request.getParameter("column")                        : "";
//		String order      = request.getParameter("order")       != null ? request.getParameter("order")                         : "";
//		JSONObject result = new JSONObject();
//		int totalUsers    = 0;
//		int totalPages    = 0;
//		int pageSize      = 10;
//		int startPoint    = (currPage - 1) * pageSize;
//		String realColmn  = "";
//		
//		logger.debug("CompanyId: " + companyId + " || serverName: " + serverName + " || Current page: " + currPage + " || Search String: " + searchStr + " || Search Opt: " + searchOpt  +  " || UserId: " + userId + " || Column: " + column + " || order: " + order);
//		
//		if (serverName.equals("") || companyId.equals("")) {
//			logger.debug("Parameter error!");
//			result.put("status", "error");
//			result.put("code", 1);
//			return result;
//		}
//		
//		try {
//			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
//			int tenantId     = userInfo.getTenantId();
//			String primary   = userInfo.getPrimary();
//			
//			if (!column.equals("") && !order.equals("")) {
//				switch(column) {
//					case "cn": realColmn = "COMPANY_NAME"    ; break;
//					case "dn": realColmn = "DEPARTMENT_NAME" ; break;
//					case "un": realColmn = "DISPLAY_NAME"    ; break;
//					case "ut": realColmn = "JOB_TITLE"       ; break;
//					case "tc": realColmn = "TOTAL_CAPACITY"  ; break;
//					default  : realColmn = "COMPANY_NAME"    ; break;
//				}
//			}
//			
//			logger.debug("Column: " + realColmn + " || order: " + order);
//			
//			List<CapacityVO> listUserCapacity = ezWebFolderAdminService.getListUserCapacity(realColmn, order, companyId, searchStr, searchOpt, startPoint, pageSize, tenantId, primary);
//			totalUsers                            = ezWebFolderAdminService.getTotalListUserCapacity(companyId, searchStr, searchOpt, startPoint, pageSize, tenantId, primary);
//			totalPages                            = (totalUsers + pageSize - 1)/pageSize;
//			
//			for (CapacityVO capacity: listUserCapacity) {
//				if (capacity.getTotalUsed().equals("0") || capacity.getTotalCapacity().equals("0")) {
//					capacity.setUsedRate(0);
//				}
//				else {
//					double totalCapByBytes = Double.parseDouble(capacity.getTotalCapacity()) * 10737418.24;
//					capacity.setUsedRate((int)(Double.parseDouble(capacity.getTotalUsed())/totalCapByBytes));
//				}
//			}
//			
//			result.put("capacityList", listUserCapacity);
//			result.put("status", "ok");
//			result.put("code", 0);
//			result.put("totalPages", totalPages);
//			result.put("totalUsers", totalUsers);
//		} 
//		catch (Exception e) {
//			logger.error(e.getMessage(), e);
//			result.put("status", "error");
//			result.put("code", 2);
//		}
//		
//		logger.debug("getPersonalStorage end");
//		return result;
//	}
//
//	@RequestMapping(value="/rest/ezwebfolderadmin/basicstorage/{newvalue}/person", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
//	public JSONObject putChangePersonalStorage(@PathVariable(value="newvalue") String newValue, @RequestParam("userList") List<String> userList, Locale locale, HttpServletRequest request) {
//		logger.debug("putChangePersonalStorage start");
//		String serverName = request.getHeader("x-user-host")    != null ? request.getHeader("x-user-host")    : "";
//		String companyId  = request.getParameter("companyId") != null ? request.getParameter("companyId") : "";
//		JSONObject result = new JSONObject();
//		
//		logger.debug("CompanyId: " + companyId + " || Servername: " + serverName + " || UserList: " + String.join(",", userList));
//		
//		if (serverName.equals("") || companyId.equals("")) {
//			logger.debug("Parameter error!");
//			result.put("status", "error");
//			result.put("code", 1);
//			return result;
//		}
//		
//		try {
//			int tenantId                      = loginService.getTenantId(serverName);
//			WebfolderConfigVO webfolderConfig = ezWebFolderAdminService.getWebfolderConfig(companyId, tenantId);
//			
//			//ezWebFolderAdminService.updateNewAmount(userList, newValue, companyId, tenantId);
//			
//			result.put("status", "ok");
//			result.put("code", 0);
//			result.put("data", "");
//		} 
//		catch (Exception e) {
//			logger.error(e.getMessage(), e);
//			result.put("status", "error");
//			result.put("code", 2);
//		}
//		
//		logger.debug("putChangePersonalStorage end");
//		return result;
//	}

	@RequestMapping(value="/rest/ezwebfolderadmin/filehistorylist", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getFileHistory(HttpServletRequest request, Locale locale) {
		logger.debug("getFileHistory start");
		String serverName = request.getHeader("x-user-host")      != null ? request.getHeader("x-user-host")                        : "";
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
		String sortType   = request.getParameter("sortType")    != null ? request.getParameter("sortType")                      : "";
		String sortColumn = request.getParameter("sortColumn")  != null ? request.getParameter("sortColumn")                    : "";
		String adminFlag  = request.getParameter("adminFlag")   != null ? request.getParameter("adminFlag")                     : "";
		String folderId   = request.getParameter("folderId")    != null ? request.getParameter("folderId")                      : "";
		
		int dbName = globals.getProperty("Globals.DbType").equals("mysql") ? 1 : 2;
   		fileExt = commonUtil.getWildcardEscapedString(fileExt, dbName);
   		fileName = commonUtil.getWildcardEscapedString(fileName, dbName);
   		userName = commonUtil.getWildcardEscapedString(userName, dbName);
   		
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
			totalRows                    = ezWebFolderAdminService.getTotalFileLogs(companyId, searchChk, startDate, endDate, fileExt, fileName, userName, fileType, actionType, primary, tenantId, folderId, adminFlag);
			
			if (totalRows % pageSize == 0) {
				totalPages = (totalRows / pageSize);
			} else {
				totalPages = (totalRows / pageSize) + 1;
			}
			
			if (currPage > totalPages & totalRows != 0) {
				currPage = totalPages;
				startPoint = (currPage -1 )* pageSize;
			}
			
			List<FileLogVO> listFileLogs = ezWebFolderAdminService.getListFileLogs(realColmn, order.toUpperCase(), 
					companyId, searchChk, startDate, endDate, fileExt, fileName, userName, fileType, actionType, startPoint, 
					pageSize, primary, offset, tenantId, sortType, sortColumn, folderId, adminFlag);
			
			result.put("fileLogList", listFileLogs);
			result.put("currPage", currPage);
			result.put("totalPages", totalPages);
			result.put("totalRows", totalRows);
			result.put("status", "ok");
			result.put("code", 0);
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		logger.debug("getFileHistory end");
		return result;
	}

	@RequestMapping(value="/rest/ezwebfolderadmin/export-logs", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject createExcelFile(HttpServletRequest request, Locale locale) {
		logger.debug("createExcelFile start");
		String serverName = request.getHeader("x-user-host")      != null ? request.getHeader("x-user-host")                        : "";
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
		String adminFlag  = request.getParameter("adminFlag")   != null ? request.getParameter("adminFlag")                     : "";
		String folderId   = request.getParameter("folderId")    != null ? request.getParameter("folderId")                      : "";
		
		String sortType   = request.getParameter("sortType")    != null ? request.getParameter("sortType")                      : "";
		String sortColumn = request.getParameter("sortColumn")  != null ? request.getParameter("sortColumn")                    : "";
		
		int dbName = globals.getProperty("Globals.DbType").equals("mysql") ? 1 : 2;
   		fileExt = commonUtil.getWildcardEscapedString(fileExt, dbName);
   		fileName = commonUtil.getWildcardEscapedString(fileName, dbName);
   		userName = commonUtil.getWildcardEscapedString(userName, dbName);
   		
		String searchChk  = "1";
		String realColmn  = "";
		
		logger.debug("StartDate: " + startDate + " || EndDate: " + endDate + " || FileExt: " + fileExt + " || FileName: " + fileName 
				+ " || File Type: " + fileType + " || Username: " + userName + " || Action Type: " + actionType
				+ "||adminFlag:" + adminFlag + "||folderId:" + folderId);
		
		JSONObject result = new JSONObject();
		
		if (serverName.equals("") || companyId.equals("") || fileType.equals("") || userId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
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
					case "fp": realColmn = "FOLDER_PATH_NAME"                                   ; break;
					case "fv": realColmn = "VERSION"                                        	; break;
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
			
			List<FileLogVO> listFileLogs = ezWebFolderAdminService.getListFileLogs(realColmn, order.toUpperCase(), companyId, 
					searchChk, startDate, endDate, fileExt, fileName, userName, fileType, actionType, 0, 0, primary, offset, tenantId, sortType, sortColumn, folderId, adminFlag);
			String realPath              = request.getServletContext().getRealPath("");
			String pDirPath              = ezWebFolderService.getWebFolderDirPath(tenantId);
			pDirPath                     = realPath + pDirPath + "temp" + commonUtil.separator;
			String excelPath             = ezWebFolderAdminService.createExcelFileLogs(realPath + commonUtil.separator, pDirPath, listFileLogs, primary, locale);
			
			if (excelPath.equals("")) {
				result.put("status", "error");
				result.put("code", 2);
				return result;
			}
			
			result.put("status", "ok");
			result.put("path", excelPath);
			result.put("code", 0);
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		logger.debug("createExcelFile end");
		return result;
	}
	
	@RequestMapping(value = "/rest/ezwebfolder/filemanage/duplicate-check", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject duplicateFileCheckGW(@RequestBody Map<String, Object> parameter, HttpServletRequest request, HttpServletResponse response) {

		Map<String, Object> result = new HashMap<>();

		String serverName = request.getHeader("x-user-host");

		List<String> fileNames = (List<String>) parameter.get("fileNames");
		String folderId = (String) parameter.get("folderId");
		String userId = (String) parameter.get("userId");

		if (containsNull(serverName, fileNames, folderId, userId)) {
			logger.debug("Parameter error!");

			result.put("status", "error");
			result.put("code", 1);

			return new JSONObject(result);
		}

		try {
			LoginVO userInfo  = commonUtil.getUserForGw(userId, serverName);

			if (!webfolderUtil.isWebfolderAdmin(userInfo)) {
				JSONObject permissionResult = ezWebFolderService_y.checkPermissions(userId, userInfo.getDeptID(), userInfo.getCompanyID(), folderId, null, userInfo.getTenantId());

				if ("error".equals(permissionResult.get("status"))) {
					return permissionResult;
				}
			}
			
			List<DuplicateInfoVO> duplicateInfoList = new ArrayList<>();
			Map<String, String> nfcToOrgFileNameMap = new HashMap<>();
			
			for (String fileName : fileNames) {
				// Mac 크롬에서 업로드한 파일명의 경우 자소분리된 형태(NFD)로 전달되어 NFC 형태로 변환한다.
				String nfcFileName = commonUtil.normalizeFileName(fileName);
				nfcToOrgFileNameMap.put(nfcFileName, fileName);
				
				duplicateInfoList.addAll(ezWebFolderService.getAllDuplicateInfo(nfcFileName, folderId, userInfo.getOffset(), userInfo.getTenantId()));
			}

			for (DuplicateInfoVO duplicateInfo : duplicateInfoList) {
				if (duplicateInfo.getOldType() == Type.FILE) {
					String status = ezWebFolderService_y.checkPermission(userId, userInfo.getDeptID(),
							userInfo.getCompanyID(), duplicateInfo.getOldId(), "F", userInfo.getTenantId());
					duplicateInfo.setAccessible("ok".equalsIgnoreCase(status));
					
					// Mac 크롬의 경우 브라우저에서는 NFD 형태로 파일명을 갖고 있기 때문에 NFC에서 다시 NFD로 변환해
					// 브라우저로 반환한다.
					duplicateInfo.setFileName(nfcToOrgFileNameMap.get(duplicateInfo.getFileName()));
				}
			}

			// 덮어쓰기 가능한 순서로 정렬
			duplicateInfoList.sort(null);

			result.put("status", "ok");
			result.put("duplicateInfoArray", duplicateInfoList);
			result.put("code", 0);
		} catch (Exception ex) {
			logger.error(ex.getMessage(), ex);

			result.put("status", "error");
			result.put("code", 2);
		}

		return new JSONObject(result);
	}
	
	@RequestMapping(value="/rest/ezwebfolder/filemanage/file-upload", method= RequestMethod.POST, produces="application/json;charset=utf-8")
	public JSONObject postFileUploadGW(@RequestParam("data") String dataList, @RequestParam("files") List<MultipartFile> multiPartFileLists, Locale locale, HttpServletRequest request) throws Exception {
		logger.debug("postFileUploadGW start");
		JSONObject result      = new JSONObject();

		JSONParser jp          = new JSONParser();
		JSONObject jsonObject  = (JSONObject) jp.parse(dataList);
		
		String serverName      = request.getHeader("x-user-host") != null ? request.getHeader("x-user-host")          : "";
		JSONArray nameArray    = jsonObject.get("nameArray")    != null ? (JSONArray) jsonObject.get("nameArray") : null;
		String userId          = jsonObject.get("userId")       != null ? (String) jsonObject.get("userId")       : "";
		String folderId        = jsonObject.get("folderId")     != null ? (String) jsonObject.get("folderId")     : "";
		String[] mailAttachArray = Optional.ofNullable(request.getParameterValues("filesMailAttach")).orElse(new String[0]);

		boolean isEncrypt = Optional.ofNullable(jsonObject.get("encrypt")).map(Object::toString).map(Boolean::parseBoolean).orElse(false);
		String parentId        = orElse((String) jsonObject.get("parentId"), "");
		
		logger.debug("Servername: " + serverName + " || UserId: " + userId + " || FolderId: " + folderId); 
		
		if (nameArray == null || serverName.equals("") || userId.equals("") || folderId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}

		process: try {
			LoginVO userInfo  = commonUtil.getUserForGw(userId, serverName);
			String offset     = userInfo.getOffset();
			
			if (!webfolderUtil.isWebfolderAdmin(userInfo)){
				JSONObject permissionResult = ezWebFolderService_y.checkPermissions(userId, userInfo.getDeptID(), userInfo.getCompanyID(), folderId, "", userInfo.getTenantId());
				
				if ("error".equals(permissionResult.get("status"))) {
					logger.debug("postFileUploadGW end");
					return permissionResult;
				}
			}
			
			List<FileUploadVO> multiFileLists = webfolderUtil.convertFileUploadVOFromRequest(multiPartFileLists, mailAttachArray, userId, userInfo.getTenantId(), locale);

			if (nameArray.size() != multiFileLists.size()) {
				logger.debug("Some files upload failed!");
				result.put("status", "error");
				result.put("code", 1);
				break process;
			}
			
			List<String> onlyNameArray = ((List<JSONObject>) nameArray).stream().map(obj -> obj.get("originalFilename")).map(String.class::cast).collect(Collectors.toList());
			List<DuplicateInfoVO> duplicateInfoList = new ArrayList<>();
			
			Iterator<String> onlyNameIterator = onlyNameArray.iterator();
			Iterator<FileUploadVO> multiFileIterator = multiFileLists.iterator();
			
			while (onlyNameIterator.hasNext()) {
				String fileName = onlyNameIterator.next();
				
				multiFileIterator.next();

				// 파일 이름으로 중복 정보 가져오기
				String decodeFileName = URLDecoder.decode(fileName, "UTF-8");;

				if (decodeFileName.indexOf(commonUtil.separator) > 0) {
					decodeFileName = decodeFileName.split("/")[decodeFileName.split("/").length - 1];
				}

				decodeFileName = commonUtil.normalizeFileName(decodeFileName);
				Optional<DuplicateInfoVO> firstInfo = ezWebFolderService.getAllDuplicateInfo(decodeFileName, folderId, offset, userInfo.getTenantId())
						.stream()
						.findFirst();

				// 중복 정보가 존재한다면
				if (firstInfo.isPresent()) {
					// multifile 리스트에서 삭제 (업로드 제외됨)
					onlyNameIterator.remove();
					multiFileIterator.remove();
					// 중복 정보 리스트에 추가
					duplicateInfoList.add(firstInfo.get());
				}
			}

			// 업로드 가능한 파일이 없으면 result 처리
			if (multiFileLists.isEmpty()) {
				logger.debug("have no uploadable file. duplicateInfoArray:");
				duplicateInfoList.stream().map(Object::toString).forEach(logger::debug);

				// 중복된 파일이 존재하여 코드를 달리하여 중복된 파일 리스트를 넘겨줌
				result.put("duplicateInfoList", duplicateInfoList);
				result.put("status", "ok");
				result.put("code", 8);

				// 조기 리턴
				break process;
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
				result.put("code", 4);
				break process;
			}
			
			UserCapacityVO capacity = ezWebFolderAdminService.getCapacity(folderId, userInfo.getPrimary(), userInfo.getTenantId());
			
			double totalUsed = Double.parseDouble(capacity.getTotalUsed());
			double totalCapa = Double.parseDouble(capacity.getTotalCapacity()) * 1073741824;
			
			if (totalUploadSize > (totalCapa - totalUsed)) {
				logger.debug("Not enough storage to upload these files!");
				result.put("status", "error");
				result.put("code", 5);
				break process;
			}
			
			String realPath   = request.getServletContext().getRealPath("");
			UploadResult uploadResult = ezWebFolderService.saveUploadedFiles(multiFileLists, nameArray, folder, realPath, userInfo, isEncrypt, parentId);
			
			if (uploadResult.success()) {
				result.put("status", "ok");

				if (duplicateInfoList.isEmpty()) {
					// 중복된 파일이 없으면 0 리턴
					result.put("code", 0);
				} else {
					// 중복된 파일이 존재하여 코드를 달리하여 중복된 파일 리스트를 넘겨줌
					result.put("duplicateInfoList", duplicateInfoList);
					result.put("code", 8);
				}

				if (uploadResult.getFailureList().size() > 0) {
					result.put("failureList", uploadResult.getFailureList());
				}
			} else {
				result.put("status", "error");
				result.put("code", 2);
			}
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		logger.debug("postFileUploadGW end");
		return result;
	}

	@RequestMapping(value = "/rest/ezwebfolder/filemanage/file-download", method=RequestMethod.GET, produces = { MediaType.APPLICATION_OCTET_STREAM_VALUE})
	@ResponseBody
	public void getFileDownload(HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("getFileDownload start");
		String listFileId   = request.getParameter("fileList")   != null ? request.getParameter("fileList")   : "";
		String listFolderId = request.getParameter("folderList") != null ? request.getParameter("folderList") : "";
		String userId       = request.getParameter("userId")     != null ? request.getParameter("userId")     : "";
		String serverName   = request.getHeader("x-user-host")     != null ? request.getHeader("x-user-host")     : "";
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
		
		logger.debug("getFileDownload end");
		return;
	}

	@RequestMapping(value = "/rest/ezwebfolder/file-delete", method = RequestMethod.DELETE, produces = "application/json;charset=utf-8")
	public JSONObject delFileDelete(Locale locale, HttpServletRequest request) {
		logger.debug("delFileDelete start");
		String listFileId   = request.getParameter("fileList") != null ? request.getParameter("fileList") : "";
		String userId       = request.getParameter("userId")   != null ? request.getParameter("userId")   : "";
		String serverName   = request.getHeader("x-user-host")   != null ? request.getHeader("x-user-host")   : "";
		String[] fileIDList = listFileId.split(",");
		JSONObject result   = new JSONObject();
		
		logger.debug("serverName: " + serverName + " ||  listFileId: " + listFileId + " || UserId: " + userId);
		
		if (fileIDList.length == 0 || serverName.equals("") || userId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			
			if (!webfolderUtil.isWebfolderAdmin(userInfo)){
				JSONObject permissionResult = ezWebFolderService_y.checkPermissions(userId, userInfo.getDeptID(), userInfo.getCompanyID(), null, listFileId, userInfo.getTenantId());
				
				if ("error".equals(permissionResult.get("status"))) {
					return permissionResult;
				}
			}
			
			if (ezWebFolderService.canDelete(fileIDList, null, userId, userInfo.getTenantId())) {
				ezWebFolderService.deleteSelectedFiles(fileIDList, userInfo);
				result.put("status", "ok");
				result.put("code", 0);
			} else {
				result.put("status", "error");
				result.put("code", 4);
			}
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		logger.debug("delFileDelete end");
		return result;
	}
	
	@RequestMapping(value = "/rest/ezwebfolder/filefolder-delete", method = RequestMethod.DELETE, produces = "application/json;charset=utf-8")
	public JSONObject delFileFloderDelete(Locale locale, HttpServletRequest request) {
		logger.debug("delFileDelete start");
		String listFileId   	= request.getParameter("fileList") != null ? request.getParameter("fileList") : "";
		String listFolderId   	= request.getParameter("folderList") != null ? request.getParameter("folderList") : "";
		String userId       	= request.getParameter("userId")   != null ? request.getParameter("userId")   : "";
		String serverName   	= request.getHeader("x-user-host")   != null ? request.getHeader("x-user-host")   : "";
		//Date date               = new Date();
		//SimpleDateFormat formatter 	= new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		JSONObject result   	= new JSONObject();
		String[] fileIDList 	= listFileId.split(",");
		String[] folderIDList 	= listFolderId.split(",");

		logger.debug("serverName: " + serverName + " ||  listFileId: " + listFileId + " || UserId: " + userId);
		
		if (fileIDList.length == 0 || serverName.equals("") || userId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			
			if (!webfolderUtil.isWebfolderAdmin(userInfo)){
				JSONObject permissionResult = ezWebFolderService_y.checkPermissionForCreator(folderIDList, fileIDList, userInfo);
				
				if ("error".equals(permissionResult.get("status"))) {
					return permissionResult;
				}
			}
			
			int tenantId 	= userInfo.getTenantId();
			
			if (ezWebFolderService.canDelete(fileIDList, folderIDList, userId, tenantId)) {
				String delMsg = ezWebFolderService.deleteSelectedFilesFolders(fileIDList, folderIDList, userInfo);
				int reCode = delMsg.equalsIgnoreCase("OK_REPLY") ? 5 : delMsg.equalsIgnoreCase("OK_M_REPLY") ? 6 : 0;
				
				result.put("status", "ok");
				result.put("code", reCode);
			} else {
				result.put("status", "error");
				result.put("code", 4);
			}
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		logger.debug("delFileDelete end");
		return result;
	}

	@RequestMapping(value="/rest/ezwebfolder/file-rename/fileid/{fileid:.+}", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject putFileRename(@PathVariable(value="fileid") String fileId, HttpServletRequest request, Locale locale) {
		logger.debug("putFileRename start");
		String userId       = request.getParameter("userId")   != null ? request.getParameter("userId")  : "";
		String serverName   = request.getHeader("x-user-host")   != null ? request.getHeader("x-user-host")  : "";
		String newName      = request.getParameter("newName")  != null ? request.getParameter("newName") : "";
		String fileExt      = request.getParameter("fileExt")  != null ? request.getParameter("fileExt") : "";
		String webFlag		= request.getParameter("webFlag")  != null ? request.getParameter("webFlag") : "";
		JSONObject result   = new JSONObject();
		
		logger.debug("UserId: " + userId + " || Servername: " + serverName + " || Newname: " + newName + " || FileId: " + fileId + " || webFlag: " + webFlag);
		
		if (fileId.equals("") || (fileExt.equals("") && newName.equals("")) || serverName.equals("") || userId.equals("") ) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		process: try {
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			String userName1 = userInfo.getDisplayName1();
			String userName2 = userInfo.getDisplayName2();
			String companyId = userInfo.getCompanyID();
			int tenantId     = userInfo.getTenantId();
			String offset    = userInfo.getOffset();
			String realPath  = request.getServletContext().getRealPath("");
			realPath = realPath.substring(0, realPath.length()-1);

			String path = commonUtil.getUploadPath("upload_webfolder.ROOT", tenantId) + commonUtil.separator;
			path = path.substring(0, path.length()-1);
			
			String _file[] = new String[1];
			_file[0] = fileId;
			if (!webfolderUtil.isWebfolderAdmin(userInfo)){
//				JSONObject permissionResult = ezWebFolderService_y.checkPermissions(userId, userInfo.getDeptID(), userInfo.getCompanyID(), null, fileId, userInfo.getTenantId());
				JSONObject permissionResult = ezWebFolderService_y.checkPermissionForCreator(null, _file, userInfo, false);

				if ("error".equals(permissionResult.get("status"))) {
					return permissionResult;
				}
			}
			
			SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			Date date                  = new Date();
			String timeUTC             = commonUtil.getDateStringInUTC(formatter.format(date), userInfo.getOffset(), true);
			
			FileVO fileVO    = ezWebFolderService.getFileByFileId(fileId, offset, tenantId);
			
			boolean isWindowsExplorer = webFlag.isEmpty();
			
			String updateFileName = "";
				
			String newFilePath = "";
			String filePath = fileVO.getFilePath();
			String[] arryStrings = filePath.split("\\.");
			String oldFilePath = arryStrings[0];
			if (isWindowsExplorer) {
				// -> updateDate, filePath, fileExt, fileTypeId를 수정해야함
				
				if (fileExt.equals("")) {
					 updateFileName = newName;
					 fileExt = "unknown";
					 newFilePath = oldFilePath;
				} else {
					if (fileExt.equals("unknown")) {
						newFilePath = oldFilePath;
						updateFileName = newName;
					} else {
						newFilePath = oldFilePath + "." + fileExt;
						updateFileName = newName + "." + fileExt;
					}
				}
			} else { 
				// 이건 웹이다
				// 확장자가 비었다  : 이름만 변경한다. 
				fileExt   = fileVO.getFileExt();
				if (fileExt.equals("unknown")) {
					updateFileName = newName;
				} else {
					updateFileName = newName + "." + fileExt;
				}
			}
			
			// 새 이름으로 중복되는 게 있는지 확인
			List<DuplicateInfoVO> duplicateFiles = ezWebFolderService.getAllDuplicateInfo(updateFileName, fileVO.getFolderId(), offset, tenantId);
			
			if (duplicateFiles.size() > 0) {
				logger.debug("Duplicate file name: {}", updateFileName);
				
				result.put("status", "error");
				result.put("code", 8);
				
				break process;
			}
			
			if (isWindowsExplorer) {
				String realFileExt = fileExt;
				
				// file의 이름을 바꿔주는것에 사용
				File file = new File(realPath + commonUtil.detectPathTraversal(filePath));
				File fileToMove = new File(realPath + commonUtil.detectPathTraversal(newFilePath));
				
				if (fileExt.length() >= 10) {
					fileExt = "unknown";
				}
				
				FileTypeVO fileType = ezWebFolderService.getFileTypeByFileExt(realFileExt.toLowerCase(), tenantId);
					
				if (fileType == null) {
					fileExt = "unknown";
				}
				
				ezWebFolderService.updateFileExt(fileId, newFilePath, fileExt, realFileExt, timeUTC, tenantId);
				
				// file의 폴더경로-> fileToMove로 경로 바꿈
				boolean isMoved = file.renameTo(fileToMove);
				
				if (isMoved == true) {
					logger.debug("isMoved" + isMoved);
				}
			}
			
			boolean isEncryptedFile = ezWebFolderService.isEncryptedFile(fileId, tenantId);

			ezWebFolderService.updateFileName(fileId, updateFileName, timeUTC, tenantId);
			ezWebFolderService.incrementFileVersion(userInfo, fileId, false);
			ezWebFolderService.saveLog("U", companyId, offset, userId, userName1, userName2, tenantId, fileVO, "", userInfo.getPrimary());
			
			if (isEncryptedFile) {
				ezWebFolderService.insertEncryptedFile(fileId, tenantId);
			}

			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		logger.debug("putFileRename end");
		return result;
	}
	
	@RequestMapping(value="/rest/ezwebfolder/filemove/modes/{mode:.+}", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject putFileMove(@PathVariable(value="mode") String mode, Locale locale, HttpServletRequest request) {
		logger.debug("putFileMove start");
		String fileList     = request.getParameter("fileList")   != null ? request.getParameter("fileList")   : "";
		String folderList   = request.getParameter("folderList") != null ? request.getParameter("folderList") : "";
		String userId       = request.getParameter("userId")     != null ? request.getParameter("userId")     : "";
		String serverName   = request.getHeader("x-user-host")   != null ? request.getHeader("x-user-host")   : "";
		String destFolderId = request.getParameter("folderId")   != null ? request.getParameter("folderId")   : "";
		String privileges   = request.getParameter("privileges") != null ? request.getParameter("privileges") : "";
		// nullable
		String nameListStr = request.getParameter("nameList");
		boolean isOverwritable = request.getParameter("overwritable") != null;
		Map<String, Object> result   = new HashMap<>();
		
		logger.debug("FileId list: " + fileList + "FolderId list: " + folderList + " || UserId: " + userId + " || Servername: " + serverName + " || FolderId: " + destFolderId + " || Privileges: " + privileges + " || mode: " + mode);
		
		if ((fileList.isEmpty() && folderList.isEmpty()) || mode.isEmpty() || serverName.isEmpty() || userId.isEmpty()) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return new JSONObject(result);
		}
		
		try {
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			
			if (!webfolderUtil.isWebfolderAdmin(userInfo)){
				// 폴더 권한 비상속
				if (ezWebFolderService.isNotInheritFolder(destFolderId, userInfo.getTenantId())) {
					result.put("status", "error");
					result.put("code", 20210128);
					return new JSONObject(result);
				}

				JSONObject permissionResult;
				
				if (mode.equals("move")) {
					String[] folderIds = folderList.isEmpty() ? new String[0] : folderList.split(",");
					String[] fileIds = fileList.isEmpty() ? new String[0] : fileList.split(",");
					permissionResult = ezWebFolderService_y.checkPermissionForCreator(folderIds, fileIds, userInfo);
				} else {
					permissionResult = ezWebFolderService_y.checkPermissions(userId, userInfo.getDeptID(), userInfo.getCompanyID(), destFolderId, fileList, userInfo.getTenantId());
				}
				
				if ("error".equals(permissionResult.get("status"))) {
					return permissionResult;
				}
			}
			
			if (fileList.length() > 0) {
				if (nameListStr == null) {
					// 기존 파일 move & copy
					result = ezWebFolderService.moveFiles(destFolderId, fileList, mode, privileges, userInfo, isOverwritable);
				} else {
					// 이름 바꾸고 move & copy
					JSONArray nameList = (JSONArray) new JSONParser().parse(nameListStr);
					result = ezWebFolderService.moveFiles(destFolderId, fileList, nameList, mode, privileges, userInfo, isOverwritable);
				}	
			}
			
			// folderList 가 있을 때
			if (folderList.length() > 0) {
				JSONObject folderResult = ezWebFolderService.moveFolders(folderList, destFolderId, mode, privileges, userInfo);
				
				if (result.isEmpty()) {
					result = folderResult;
				} else if (result.get("status").equals("ok")) {
					result.put("code", folderResult.get("code"));
					
					// 중복 정보가 있으면
					if (folderResult.containsKey("duplicateInfoArray")) {
						List<DuplicateInfoVO> duplicateList = (List<DuplicateInfoVO>) folderResult.get("duplicateInfoArray");
						
						// 파일 중복 정보가 있을 때
						if (result.containsKey("duplicateInfoArray")) {
							// 폴더 중복 + 파일 중복 순서로 add
							duplicateList.addAll((List<DuplicateInfoVO>) result.get("duplicateInfoArray"));
						}
						
						// 중복 정보를 result 맵에 put
						result.put("duplicateInfoArray", duplicateList);
					}
					
					// 폴더 에러 목록이 있으면
					if (folderResult.containsKey("folderErrorArray")) {
						// result 맵에 put
						result.put("folderErrorArray", folderResult.get("folderErrorArray"));
					}
				}
			}
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		logger.debug("putFileMove end");
		return new JSONObject(result);
	}

	@RequestMapping(value="/rest/ezwebfolderadmin/webfolderadmin-list", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getWebfolderAdminList(HttpServletRequest request, Locale locale) {
		logger.debug("getWebfolderAdminList start");
		String serverName   = request.getHeader("x-user-host")   != null ? request.getHeader("x-user-host")                     : "";
		String userId       = request.getParameter("userId")   != null ? request.getParameter("userId")                     : "";
		int pageNum         = request.getParameter("pageNum")  != null ? Integer.parseInt(request.getParameter("pageNum"))  : -1;
		int pageSize        = request.getParameter("pageSize") != null ? Integer.parseInt(request.getParameter("pageSize")) : -1;
		String companyId    = request.getParameter("companyId")!= null ? request.getParameter("companyId")                  : "";
		String type         = "f=1";
		JSONObject result   = new JSONObject();
		JSONArray jsonArray = new JSONArray();
		
		logger.debug("Severname: " + serverName + " || UserId: " + userId + " || Current page: " + pageNum + " || ListCount: " + pageSize + " || CompanyId: " + companyId);
		
		if (companyId.equals("") || serverName.equals("") || pageNum == -1 || pageSize == -1) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo       = commonUtil.getUserForGw(userId, serverName);
			int tenantId           = userInfo.getTenantId();
			String primary         = userInfo.getPrimary();
			int startRow           = (pageSize * (pageNum - 1)) + 1;
			int endRow             = pageSize * pageNum;
			// 2023-07-31 전인하 - 웹폴더 > 겸직/사용자 별 권한 설정 옵션에 따른 권한 조회 동작
			String permissionBasisDeptYN = ezCommonService.getTenantConfig("permissionBasisDeptYN", userInfo.getTenantId());
			int cnt                = ezOrganAdminService.getPermissionListCount(companyId, type,"","", primary, tenantId, permissionBasisDeptYN);
			List<OrganUserVO> list = ezOrganAdminService.getPermissionList(companyId, type,"","", primary, startRow, endRow, tenantId, permissionBasisDeptYN);
			
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
			result.put("listOfUsers", jsonArray);
			result.put("count", cnt);
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		logger.debug("getWebfolderAdminList end");
		return result;
	}

	@RequestMapping(value="/rest/webfolderadmin/webfolderadmin-insert", method= RequestMethod.POST, produces="application/json;charset=utf-8")
	public JSONObject postWebfolderAdminInsert(HttpServletRequest request, Locale locale) {
		logger.debug("postWebfolderAdminInsert start");
		String serverName   = request.getHeader("x-user-host")   != null ? request.getHeader("x-user-host") : "";
		String userId       = request.getParameter("userId")   != null ? request.getParameter("userId") : "";
		JSONObject result   = new JSONObject();
		
		logger.debug("UserID: " + userId + " || serverName: " + serverName);
		
		if (userId.equals("") || serverName.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			int tenantId     = userInfo.getTenantId();
			String primary   = userInfo.getPrimary();
			
			OrganUserVO vo   = ezOrganAdminService.getUserInfo(userId, primary, tenantId);
			String extStr    = vo.getExtensionAttribute1().toLowerCase();
			
			SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			date.setTimeZone(TimeZone.getTimeZone("GMT"));
			
			String nowDate = date.format(new Date());
			int pos        = extStr.indexOf("f=1");
			
			if (pos > -1) {
				logger.debug("Already be webfolder admin!");
				result.put("status", "error");
				result.put("code", "6");
				return result;
			}
			
			pos = extStr.indexOf("f=0;");
			
			if (pos > -1) {
				extStr = extStr.replace("f=0", "f=1");
			}
			else {
				extStr += "f=1;";
			}
			
			vo.setExtensionAttribute1(extStr);
			vo.setTenantId(tenantId);
			vo.setNowDate(nowDate);
			
			logger.debug("Extension: " + extStr);
		
			ezOrganAdminService.updateDBData_user(vo);
			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		logger.debug("postWebfolderAdminInsert end");
		return result;
	}

	@RequestMapping(value="/rest/webfolderadmin/webfolderadmin-delete/users/{userid:.+}", method= RequestMethod.DELETE, produces="application/json;charset=utf-8")
	public JSONObject deleteWebfolderAdminDelete(@PathVariable String userid, HttpServletRequest request, Locale locale) {
		logger.debug("deleteWebfolderAdminDelete start");
		String serverName = request.getHeader("x-user-host") != null ? request.getHeader("x-user-host") : "";
		String userId     = request.getParameter("userId") != null ? request.getParameter("userId") : "";
		JSONObject result = new JSONObject();
		
		logger.debug("UserID: " + userid + " || serverName: " + serverName);
		
		if (userid.equals("") || serverName.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			int tenantId     = userInfo.getTenantId();
			String primary   = userInfo.getPrimary();
			OrganUserVO vo   = ezOrganAdminService.getUserInfo(userid, primary, tenantId);
			String extStr    = vo.getExtensionAttribute1().toLowerCase();
			
			SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			date.setTimeZone(TimeZone.getTimeZone("GMT"));
			
			String nowDate = date.format(new Date());
			int pos        = extStr.indexOf("f=1;");
			
			if (pos == -1) {
				logger.debug("Cannot find webfolder admin extension!");
				result.put("status", "error");
				result.put("code", 2);
				return result;
			}
			
			extStr = extStr.replace("f=1;", "");
			
			vo.setExtensionAttribute1(extStr);
			vo.setTenantId(tenantId);
			vo.setNowDate(nowDate);
			
			logger.debug("Extension: " + extStr);
		
			ezOrganAdminService.updateDBData_user(vo);
			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		logger.debug("deleteWebfolderAdminDelete end");
		return result;
	}

	@RequestMapping(value="/rest/ezwebfolderadmin/folders/comp", method= RequestMethod.POST, produces="application/json;charset=utf-8")
	public JSONObject postCompanyFolderInsert(@RequestBody JSONObject jsonObject, HttpServletRequest request, Locale locale) {
		logger.debug("postCompanyFolderInsert start");
		JSONParser parser  = new JSONParser();
		JSONObject result  = new JSONObject();
		
		try {
			jsonObject         = (JSONObject) parser.parse(jsonObject.toJSONString());
		} catch (ParseException e1) {
			logger.error(e1.getMessage(), e1);
			result.put("status", "error");
			result.put("code", 2);
			return result;
		}
		
		String serverName  		= request.getHeader("x-user-host") 		!= null ? request.getHeader("x-user-host")       : "";
		String userId      		= jsonObject.get("userId")       		!= null ? (String) jsonObject.get("userId")    : "";
		String pFolderId   		= jsonObject.get("pFolderId")    		!= null ? (String) jsonObject.get("pFolderId") : "";
		String folderName  		= jsonObject.get("fName")        		!= null ? (String) jsonObject.get("fName")     : "";
		String folderName2 		= jsonObject.get("fName2")       		!= null ? (String) jsonObject.get("fName2")    : "";
		String folderUsers 		= jsonObject.get("fUsers")       		!= null ? (String) jsonObject.get("fUsers")    : "";
		
		logger.debug("serverName: " + serverName + " || UserId: " + userId + " || Folder user: " + folderUsers + " || folderName1: " + folderName + " || FolderName2: " + folderName2 + " || ParentFolderID: " + pFolderId);
		
		if (pFolderId.equals("") || userId.equals("") || folderUsers.equals("") || folderName.equals("") || serverName.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			Map<String, Object> serviceResult =
					ezWebFolderAdminService.addCompanyFolder(pFolderId, folderUsers, folderName, folderName2, userInfo);
			result = new JSONObject(serviceResult);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		logger.debug("postCompanyFolderInsert end");
		return result;
	}

	@RequestMapping(value="/rest/ezwebfolderadmin/folders/{folderid}/comp", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject putCompanyFolderUpdate(@RequestBody JSONObject jsonObject, @PathVariable(value="folderid") String folderId, HttpServletRequest request, Locale locale) throws JsonParseException, JsonMappingException, IOException {
		logger.debug("putCompanyFolderUpdate start");
		JSONParser parser      = new JSONParser();
		JSONObject result      = new JSONObject();
		try {
			jsonObject             = (JSONObject) parser.parse(jsonObject.toJSONString());
		} catch (ParseException e1) {
			logger.error(e1.getMessage(), e1);
			result.put("status", "error");
			result.put("code", 2);
			return result;
		}
		String serverName      = request.getHeader("x-user-host") != null ? request.getHeader("x-user-host")    : "";
		String userId          = jsonObject.get("userId")       != null ? (String) jsonObject.get("userId") : "";
		String folderName      = jsonObject.get("fName")        != null ? (String) jsonObject.get("fName")  : "";
		String folderName2     = jsonObject.get("fName2")       != null ? (String) jsonObject.get("fName2") : "";
		String folderUsers     = jsonObject.get("fUsers")       != null ? (String) jsonObject.get("fUsers") : "";
		String subFolderType   	=  (String)jsonObject.get("subFolderType");	// 0 or 1
		
		JSONArray addUserJSON = new JSONArray();
		JSONArray deleteUserJSON = new JSONArray();
		try {
			addUserJSON = (JSONArray) parser.parse((String) jsonObject.get("addUser"));
			deleteUserJSON = (JSONArray) parser.parse((String) jsonObject.get("deleteUser"));
		} catch (ParseException e1) {
			logger.error(e1.getMessage(), e1);
		}
		
		List<String> addUser = new ArrayList<String>();
		List<String> deleteUser = new ArrayList<String>();
		
		for(int i =0; i <addUserJSON.size();i++){
			addUser.add(addUserJSON.get(i).toString());
		}
		for(int i =0; i <deleteUserJSON.size();i++){
			deleteUser.add(deleteUserJSON.get(i).toString());
		}
		
		// 2020-12-09 김은실 - (카이스트)회사 폴더별 관리자 지원 기능
		JSONArray addUserManagerJSON = new JSONArray();
		JSONArray deleteUserManagerJSON = new JSONArray();
		try {
			addUserManagerJSON = (JSONArray) parser.parse((String) jsonObject.get("addUserManager")       != null ? (String) jsonObject.get("addUserManager") : "[]");
			deleteUserManagerJSON = (JSONArray) parser.parse((String) jsonObject.get("deleteUserManager") != null ? (String) jsonObject.get("deleteUserManager") : "[]");
		} catch (ParseException e1) {
			logger.error(e1.getMessage(), e1);
		}
		
		List<String> addUserManager = new ArrayList<String>();
		List<String> deleteUserManager = new ArrayList<String>();
		
		for(int i =0; i <addUserManagerJSON.size();i++){
			addUserManager.add(addUserManagerJSON.get(i).toString());
		}
		for(int i =0; i <deleteUserManagerJSON.size();i++){
			deleteUserManager.add(deleteUserManagerJSON.get(i).toString());
		}
		
		boolean encryption     = Optional.ofNullable((String) jsonObject.get("encryption")).map(Boolean::parseBoolean).orElse(false);

		logger.debug("serverName: {}, userId: {}, folderUsers: {}, folderName1: {}, folderName2: {}, encryption: {}, deleteUser: {}, addUser: {}",
				serverName, userId, folderUsers, folderName, folderName2, encryption, deleteUser, addUser);
		
		if (folderId.equals("") || userId.equals("") || folderUsers.equals("") || folderName.equals("") || serverName.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			int tenantId     = userInfo.getTenantId();
			String offset    = userInfo.getOffset();

			Map<String, Object> serviceResult = ezWebFolderAdminService.updateCompanyFolder(userId, folderId, folderUsers, 
					folderName, folderName2, offset, tenantId, (ArrayList<String>)addUser, (ArrayList<String>)deleteUser, subFolderType, userInfo, 
					(ArrayList<String>)addUserManager, (ArrayList<String>)deleteUserManager, encryption);
			result = new JSONObject(serviceResult);
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		logger.debug("putCompanyFolderUpdate end");
		return result;
	}

	@RequestMapping(value="/rest/ezwebfolder/foldersTree", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getFolderTree(HttpServletRequest request, Locale locale) {
		logger.debug("getFolderTree start");
		String userId     = request.getParameter("userId")    != null ? request.getParameter("userId")    : "";
		String companyId  = request.getParameter("companyId") != null ? request.getParameter("companyId") : "";
		String folderId   = request.getParameter("folderId")  != null ? request.getParameter("folderId")  : "";
		String type       = request.getParameter("type")      != null ? request.getParameter("type")      : "";
		String serverName = request.getHeader("x-user-host")    != null ? request.getHeader("x-user-host")    : "";
		JSONObject result = new JSONObject();
		
		logger.debug("Type: " + type + " || folderId: " + folderId + " || companyId: " + companyId + " || serverName: " + serverName);
		
		if (serverName.equals("") || type.equals("") || companyId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			int tenantId     = userInfo.getTenantId();
			
			if (!webfolderUtil.isWebfolderAdmin(userInfo)) {
				logger.debug("Privileges!");
				result.put("status", "error");
				result.put("code", 3);
				return result;
			}
					
			switch (type) {
				case "comp":
					//Get company folder tree
					FolderSimpleVO company = ezWebFolderService.getCompanySimpleFolder(companyId, userInfo);

					ezWebFolderService.getAllSubDepts(company, tenantId, 2);
					
					result.put("currentFolder", "");
					result.put("folderTree", company);
					break;
				case "dept":
					//Get department folder tree
					List<FolderSimpleVO> listFolders = ezWebFolderService.getAllSimpleDeptFolder(companyId, userInfo);
					
					result.put("currentFolder", "");
					result.put("folderTree", listFolders);
					break;
			}
			
			result.put("status", "ok");
			result.put("code", 0);
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		logger.debug("getFolderTree end");
		return result;
	}

	@RequestMapping(value="/rest/ezwebfolder/depart-tree", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getDeptTree(HttpServletRequest request, Locale locale) {
		logger.debug("getDeptTree start");
		String companyId  = request.getParameter("companyId")!= null ? request.getParameter("companyId") : "";
		String deptId     = request.getParameter("deptId")   != null ? request.getParameter("deptId")    : "";
		String userId     = request.getParameter("userId")   != null ? request.getParameter("userId")    : "";
		String serverName = request.getHeader("x-user-host")   != null ? request.getHeader("x-user-host")    : "";
		String adminOrgan = request.getParameter("adminOrgan") != null ? request.getParameter("adminOrgan") : "n";
		JSONObject result = new JSONObject();
		
		logger.debug("CompanyId: " + companyId + " || serverName: " + serverName + " || Department Id: " + deptId + " || UserId: " + userId);
		
		if (companyId.equals("") || serverName.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo      = commonUtil.getUserForGw(userId, serverName);
			String primary        = userInfo.getPrimary();
			int tenantId          = userInfo.getTenantId();
			deptId                = deptId.equals("") ? userInfo.getDeptID() : deptId;
			SimpleDeptVO sCompany = null;
			String useOrganHideFlag = ezCommonService.getTenantConfig("useOrganHideFlag",tenantId);
			// useOganHideFlag를 사용하지 않으면 adminOrgan을 다 "y"로 둬서 조직도숨김을 뺀다.
			adminOrgan = "NO".equalsIgnoreCase(useOrganHideFlag) ? "y" : adminOrgan;
			
			if (deptId.equals("")) {
				sCompany = ezWebFolderService.getAllDepts(companyId, 0, primary, tenantId);
			}
			else {
				String deptPath  = ezWebFolderService.getDeptPath(deptId, tenantId);
				String[] path    = deptPath.split(",");
				sCompany         = ezWebFolderService.getSimpleCompany(companyId, 0, primary, tenantId);
				
				ezWebFolderService.getAllDepts(sCompany, path, primary, tenantId, 1, 1, adminOrgan);
			}
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("deptTree", sCompany);
			result.put("currentDept", deptId);
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		logger.debug("getDeptTree end");
		return result;
	}

	@RequestMapping(value="/rest/ezwebfolder/sub-tree/{deptid:.+}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getSubTree(@PathVariable(value="deptid") String deptId, HttpServletRequest request, Locale locale) {
		logger.debug("getSubTree start");
		String serverName = request.getHeader("x-user-host") != null ? request.getHeader("x-user-host")                  : "";
		int level         = request.getParameter("level")  != null ? Integer.parseInt(request.getParameter("level")) : -1;
		String userId     = request.getParameter("userId") != null ? request.getParameter("userId")                  : "";
		JSONObject result = new JSONObject();
		
		logger.debug("deptId: " + deptId + " || level: " + level + " || serverName: " + serverName + " || User Id: " + userId);
		
		if (deptId.equals("") || serverName.equals("") || level == -1 || userId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo   = commonUtil.getUserForGw(userId, serverName);
			int tenantId       = userInfo.getTenantId();
			String primary     = userInfo.getPrimary();
			SimpleDeptVO sDept = ezWebFolderService.getAllDepts(deptId, level, primary, tenantId);
			result.put("status", "ok");
			result.put("code", 0);
			result.put("subTree", sDept);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		logger.debug("getSubTree end");
		return result;
	}
	
	@RequestMapping(value="/rest/ezwebfolder/dept-member/{deptid:.+}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getAllDeptMembers(@PathVariable(value="deptid") String deptId, HttpServletRequest request, Locale locale) {
		logger.debug("getAllDeptMembers start");
		String serverName = request.getHeader("x-user-host") != null ? request.getHeader("x-user-host") : "";
		String userId     = request.getParameter("userId") != null ? request.getParameter("userId") : "";
		String adminOrgan = request.getParameter("adminOrgan") != null ? request.getParameter("adminOrgan") : "n";
		JSONObject result = new JSONObject();
		
		logger.debug("deptId: " + deptId + " || serverName: " + serverName + " || UserId: " + userId);
		
		if (deptId.equals("") || userId.equals("") || serverName.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo               = commonUtil.getUserForGw(userId, serverName);
			int tenantId                   = userInfo.getTenantId();
			String primary                 = userInfo.getPrimary();
			String useOrganHideFlag = ezCommonService.getTenantConfig("useOrganHideFlag",tenantId);
			// useOganHideFlag를 사용하지 않으면 adminOrgan을 다 "y"로 둬서 조직도숨김을 뺀다.
			adminOrgan = "NO".equalsIgnoreCase(useOrganHideFlag) ? "y" : adminOrgan;
			List<SimpleUserVO> listMembers = ezWebFolderService.getDeptMemberList(deptId, primary, tenantId, adminOrgan);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("listMembers", listMembers);
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		logger.debug("getAllDeptMembers end");
		return result;
	}
	
	@RequestMapping(value="/rest/ezwebfolderadmin/foldersTree/dept", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getDeptFolderTree(HttpServletRequest request, Locale locale) {
		logger.debug("getDeptFolderTree start");
		String serverName = request.getHeader("x-user-host")    != null ? request.getHeader("x-user-host")    : "";
		String userId     = request.getParameter("userId")    != null ? request.getParameter("userId")    : "";
		String companyId  = request.getParameter("companyId") != null ? request.getParameter("companyId") : "";
		String folderId   = request.getParameter("folderId")  != null ? request.getParameter("folderId")  : "";
		JSONObject result = new JSONObject();
		
		logger.debug("CompanyId: " + companyId + " || serverName: " + serverName + " || UserId: " + userId + " || FolderId: " + folderId);
		
		if (companyId.equals("") || serverName.equals("") || userId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
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
			result.put("deptTree", listFolders);
		} 
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		logger.debug("getDeptFolderTree end");
		return result;
	}
	
	@RequestMapping(value="/rest/ezwebfolderadmin/foldersTree/comp", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getCompanyFolderTree(HttpServletRequest request, Locale locale) {
		logger.debug("getCompanyFolderTree start");
		String serverName = request.getHeader("x-user-host")    != null ? request.getHeader("x-user-host")    : "";
		String userId     = request.getParameter("userId")    != null ? request.getParameter("userId")    : "";
		String companyId  = request.getParameter("companyId") != null ? request.getParameter("companyId") : "";
		String folderId   = request.getParameter("folderId")  != null ? request.getParameter("folderId")  : "";
		JSONObject result = new JSONObject();
		
		logger.debug("CompanyId: " + companyId + " || serverName: " + serverName + " || UserId: " + userId + " || FolderId: " + folderId);
		
		if (companyId.equals("") || serverName.equals("") || userId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
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
				
				int folderIdInt = ezWebFolderAdminService.insertFolder2(folderVO);
				
				if (folderIdInt != 0) {
					folderId = String.valueOf(folderIdInt);
					folderVO.setFolderId(folderId);
				}
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
			result.put("companyTree", company);
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		logger.debug("getCompanyFolderTree end");
		return result;
	}

	@RequestMapping(value="/rest/ezwebfolderadmin/subfolder-tree/{folderid:.+}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getSubFoldersTree(@PathVariable(value="folderid") String folderId, HttpServletRequest request, Locale locale) {
		logger.debug("getSubFoldersTree start");
		String serverName = request.getHeader("x-user-host")   != null ? request.getHeader("x-user-host")  : "";
		String mode       = request.getParameter("mode")     != null ? request.getParameter("mode")    : "";
		String type       = request.getParameter("type")     != null ? request.getParameter("type")    : "";
		String userId     = request.getParameter("userId")   != null ? request.getParameter("userId")  : "";
		String adminCheck     = request.getParameter("adminCheck")   != null ? request.getParameter("adminCheck")  : mode;
		JSONObject result = new JSONObject();
		
		logger.debug("folderId: " + folderId + " || serverName: " + serverName + " || mode: " + mode + " || UserId: " + userId);
		
		if (folderId.equals("") || serverName.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo      = commonUtil.getUserForGw(userId, serverName);
			int tenantId          = userInfo.getTenantId();
			FolderSimpleVO folder = ezWebFolderService.getSimpleFolder(folderId, tenantId);
			if (mode.equals("1") && folder.getFolderLevel() == 0) {
				List<String> idList = null;
				if( !adminCheck.equals("admin") && ezWebFolderAdminService.getFolderIdsByManagerUserId(userId, folderId, userInfo.getCompanyID(), tenantId).size() == 0){
					idList = ezWebFolderService_y.idListUpgrade(userId, userInfo.getDeptID(), userInfo.getCompanyID(), tenantId);
				}
				List<FolderSimpleVO> listCompSubFolders = ezWebFolderService.getCompanySubSimpleFolder(userInfo.getId(), userInfo.getDeptID(), folder.getFolderId(), userInfo.getCompanyID(), tenantId, idList);
				folder.setListSubFolders(listCompSubFolders);
			}
			else {
				List<String> idList = null;
				if( type.equals("comp") && !adminCheck.equals("admin") && ezWebFolderAdminService.getFolderIdsByManagerUserId(userId, folderId, userInfo.getCompanyID(), tenantId).size() == 0){
					idList = ezWebFolderService_y.idListUpgrade(userId, userInfo.getDeptID(), userInfo.getCompanyID(), tenantId);
				}
				ezWebFolderService.getAllSubDepts(folder, tenantId, 1, idList);
			}
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("subTree", folder);
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		logger.debug("getSubFoldersTree end");
		return result;
	}

	@RequestMapping(value="/rest/ezwebfolderadmin/folder-users/{folderid:.+}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getFolderUsers(@PathVariable(value="folderid") String folderId, HttpServletRequest request, Locale locale) {
		logger.debug("getFolderUsers start");
		String serverName = request.getHeader("x-user-host")   != null ? request.getHeader("x-user-host") : "";
		String userId     = request.getParameter("userId")   != null ? request.getParameter("userId") : "";
		String mode       = request.getParameter("mode")     != null ? request.getParameter("mode")   : "";
		JSONObject result = new JSONObject();
		
		logger.debug("folderId: " + folderId + " || serverName: " + serverName + " || UserId: " + userId + " || mode: " + mode);
		
		if (folderId.equals("") || serverName.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
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
			
			if(folder.getFolderType().equals("C") && folder.getFolderLevel() > 0) {
				listUsers         = ezWebFolderService.getFolderUsers(folderId, tenantId);
			} else {
				if (mode.equals("")) {
					String ancestorId = folderPath.split("\\|")[1];
					listUsers         = ezWebFolderService.getFolderUsers(ancestorId, tenantId);
				} else {
					String ancestorId = folderPath.split("\\|")[0];
					listUsers         = ezWebFolderService.getFolderUsers(ancestorId, tenantId);
				}
			}
			
			FolderVO encryptionRootFolder = ezWebFolderService.getEncryptionRootFolder(folderId, tenantId);
			boolean isEncryption = encryptionRootFolder != null;
			boolean isInhertiedEncryption = isEncryption && !folderId.equals(encryptionRootFolder.getFolderId());

			result.put("status", "ok");
			result.put("code", 0);
			result.put("folderUsers", listUsers);
			result.put("isEncryption", isEncryption);
			result.put("isInhertiedEncryption", isInhertiedEncryption);
			result.put("encryptionRootFolder", encryptionRootFolder);

			// 폴더 권한 비상속
			result.put("isNotInherit", ezWebFolderService.isNotInheritFolder(folderId, tenantId));
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		logger.debug("getFolderUsers end");
		return result;
	}
	
	@RequestMapping(value="/rest/ezwebfolderadmin/file-users/{fileid:.+}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getFileUsers(@PathVariable(value="fileid") String fileId, HttpServletRequest request, Locale locale) {
		logger.debug("getFileUsers start");
		String serverName = request.getHeader("x-user-host")   != null ? request.getHeader("x-user-host") : "";
		String userId     = request.getParameter("userId")   != null ? request.getParameter("userId") : "";
		String mode       = request.getParameter("mode")     != null ? request.getParameter("mode")   : "";
		JSONObject result = new JSONObject();
		
		logger.debug("fileId: " + fileId + " || serverName: " + serverName + " || UserId: " + userId + " || mode: " + mode);
		
		if (fileId.equals("") || serverName.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo             = commonUtil.getUserForGw(userId, serverName);
			int tenantId                 = userInfo.getTenantId();
			FileVO file = ezWebFolderService.getFileByFileId(fileId, "000|+00:00", tenantId);

			if (file.isReply()) {
				throw new IllegalArgumentException("reply file is not allowed");
			}

			List<FolderUserVO> listUsers = new ArrayList<FolderUserVO>();
			listUsers         			 = ezWebFolderService.getFileUsers(fileId, tenantId);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("folderUsers", listUsers);
			result.put("isEncryption", "");
			result.put("isInhertiedEncryption", "");
			result.put("encryptionRootFolder", "");
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		logger.debug("getFileUsers end");
		return result;
	}

	@RequestMapping(value="/rest/ezwebfolderadmin/folders/{folderid:.+}", method= RequestMethod.DELETE, produces="application/json;charset=utf-8")
	public JSONObject delCompanyFolder(@PathVariable(value="folderid") String folderId, HttpServletRequest request, Locale locale) {
		logger.debug("delCompanyFolder start");
		String serverName = request.getHeader("x-user-host") != null ? request.getHeader("x-user-host") : "";
		String userId     = request.getParameter("userId") != null ? request.getParameter("userId") : "";
		JSONObject result = new JSONObject();
		
		logger.debug("FolderId: " + folderId + " || serverName: " + serverName + " || UserId: " + userId);
		
		if (folderId.equals("") || serverName.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			
			if (ezWebFolderService.canDelete(null, new String[] { folderId }, userId, userInfo.getTenantId())) {
				String offset    = userInfo.getOffset();
				FolderVO folder  = ezWebFolderService.getFolderByFolderId(folderId, offset, userInfo.getTenantId());
				ezWebFolderService.updateFolderUseStatus(folder, userInfo);

				result.put("status", "ok");
				result.put("code", 0);
			} else {
				result.put("status", "error");
				result.put("code", 4);
			}
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		logger.debug("delCompanyFolder end");
		return result;
	}

	@RequestMapping(value="/rest/ezwebfolderadmin/folders/{folderid}/modes/{mode}/folder-move", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject putCompanyFolderMove(@PathVariable(value="folderid") String folderId, @PathVariable(value="mode") String mode, Locale locale, HttpServletRequest request) {
		logger.debug("putCompanyFolderMove start");
		String serverName   = request.getHeader("x-user-host")    != null ? request.getHeader("x-user-host")    : "";
		String userId       = request.getParameter("userId")    != null ? request.getParameter("userId")    : "";
		String destFolderId = request.getParameter("parentFld") != null ? request.getParameter("parentFld") : "";
		JSONObject result   = new JSONObject();
		
		logger.debug("FolderID: " + folderId + " || serverName: " + serverName + " || destination: " + destFolderId + " || mode: " + mode + " UserId: " + userId);
		
		if (folderId.equals("") || serverName.equals("") || destFolderId.equals("") || mode.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
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
				result.put("code", 4);
				return result;
			}
			
			int pos = destFolder.getFolderPath().indexOf(folder.getFolderPath());
			
			if (pos != -1) {
				result.put("status", "error");
				result.put("code", 5);
				return result;
			}
			
			String realPath = request.getServletContext().getRealPath("");
			List<DuplicateInfoVO> duplicateList = ezWebFolderAdminService.moveCompanyFolder(folder, destFolder, mode, realPath, userInfo, "admin");
		
			if (duplicateList == null){
				result.put("status", "error");
				result.put("code", 1);
			} else if (duplicateList.isEmpty()) {
				result.put("status", "ok");
				result.put("code", 0);
			} else {
				result.put("status", "ok");
				result.put("code", 8);
				result.put("duplicateInfoArray", duplicateList);
			}
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		logger.debug("putCompanyFolderMove end");
		return result;
	}

	// 사용되지 않음. (2021-04-13 확인 - 김은실)
	@RequestMapping(value="/rest/ezwebfolderadmin/folders/{folderid}/file-list", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getFileList(@PathVariable(value="folderid") String folderId, HttpServletRequest request, Locale locale) {
		logger.debug("getFileList start");
		String serverName = request.getHeader("x-user-host")    != null ? request.getHeader("x-user-host")  : "";
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
		String sortType   = request.getParameter("sortType") 	!= null ? request.getParameter("sortType") 	: "" ;
		String sortColumn = request.getParameter("sortColumn") 	!= null ? request.getParameter("sortColumn"): "" ;
		
		String searchChk  = "1";
		int currPage      = request.getParameter("currentPage") != null ? Integer.parseInt(request.getParameter("currentPage")) :  1;
		int totalRows     = 0;
		int totalPages    = 0;
		int pageSize      = listCnt.equals("") ? 10 : Integer.parseInt(listCnt);
		int startPoint    = 0;
		String realColmn  = "";
		JSONObject result = new JSONObject();
		
		int dbName = globals.getProperty("Globals.DbType").equals("mysql") ? 1 : 2;
   		fileExt = commonUtil.getWildcardEscapedString(fileExt, dbName);
   		fileName = commonUtil.getWildcardEscapedString(fileName, dbName);
   		userName = commonUtil.getWildcardEscapedString(userName, dbName);
		
		logger.debug("FolderId: " + folderId + " || serverName: " + serverName + " || Current Page: " + currPage + " || UserId: " + userId + " || StartDate: " + startDate + " || EndDate: " + endDate + " || File ext: " + fileExt + " || FileName: " + fileName + " || UserName: " + userName + " || File Type: " + fileType + " || Column: " + column + " || Order: " + order + " || ListCount: " + listCnt);
		
		if (folderId.equals("") || serverName.equals("") || userId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
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
				fileList                        = ezWebFolderService.getAllFiles(realColmn, order.toUpperCase(), folder.getFolderPath(), 
						originalPath, searchChk, startDate, endDate, fileExt, fileName, userName, fileType, startPoint, pageSize, primary, 
						offset, tenantId, sortType, sortColumn);
				
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
				fileList   = ezWebFolderService.getAllFilesInFolder(realColmn, order.toUpperCase(), folderId, originalPath, 
						searchChk, startDate, endDate, fileExt, fileName, userName, fileType, startPoint, pageSize, 
						primary, offset, tenantId, sortType, sortColumn);
			}
			
			List<String> containsReplyFiles = ezWebFolderService.getContainsReplyFiles(folderId, tenantId);

			result.put("containsReplyFiles", containsReplyFiles);
			result.put("fileList", fileList);
			result.put("totalPages", totalPages);
			result.put("totalRows", totalRows);
			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		logger.debug("getFileList end");
		return result;
	}
	
	
	@RequestMapping(value="/rest/ezwebfolderadmin/folders/{folderid}/file-list2", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getFileList2(@PathVariable(value="folderid") String folderId, HttpServletRequest request, Locale locale) {
		logger.debug("getFileList start");
		String serverName = request.getHeader("x-user-host")      != null ? request.getHeader("x-user-host")    : "";
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
		String sortType   = request.getParameter("sortType") 	!= null ? request.getParameter("sortType") 	: "" ;
		String sortColumn = request.getParameter("sortColumn") 	!= null ? request.getParameter("sortColumn"): "" ;
		String searchChk  = "1";
		int currPage      = request.getParameter("currentPage") != null ? Integer.parseInt(request.getParameter("currentPage")) :  1;
		int totalRows     = 0;
		int totalPages    = 0;
		int pageSize      = listCnt.equals("") ? 10 : Integer.parseInt(listCnt);
		int startPoint    = 0;
		String realColmn  = "";
		JSONObject result = new JSONObject();
		
		int dbName = globals.getProperty("Globals.DbType").equals("mysql") ? 1 : 2;
   		fileExt = commonUtil.getWildcardEscapedString(fileExt, dbName);
   		fileName = commonUtil.getWildcardEscapedString(fileName, dbName);
   		userName = commonUtil.getWildcardEscapedString(userName, dbName);
		
		logger.debug("FolderId: " + folderId + " || serverName: " + serverName + " || Current Page: " + currPage + " || UserId: " + userId + " || StartDate: " + startDate + " || EndDate: " + endDate + " || File ext: " + fileExt + " || FileName: " + fileName + " || UserName: " + userName + " || File Type: " + fileType + " || Column: " + column + " || Order: " + order + " || ListCount: " + listCnt);
		
		if (folderId.equals("") || serverName.equals("") || userId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
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
			
			totalRows  = ezWebFolderService.getTotalFileCnt(folderId, searchChk, startDate, endDate, fileExt, fileName, userName, fileType, primary, tenantId);
			totalPages = (totalRows + pageSize - 1)/pageSize;
			currPage   = currPage > totalPages ? totalPages : currPage;
			currPage   = currPage == 0         ? 1          : currPage;
			startPoint = (currPage - 1) * pageSize;
			fileList   = ezWebFolderService.getAllFilesInFolder(realColmn, order.toUpperCase(), folderId, originalPath, 
					searchChk, startDate, endDate, fileExt, fileName, userName, fileType, startPoint, pageSize, 
					primary, offset, tenantId, sortType, sortColumn);
			
			List<String> containsReplyFiles = ezWebFolderService.getContainsReplyFiles(folderId, tenantId);

			result.put("containsReplyFiles", containsReplyFiles);
			result.put("fileList", fileList);
			result.put("totalPages", totalPages);
			result.put("totalRows", totalRows);
			// 폴더 권한 비상속
			result.put("isNotInherit", ezWebFolderService.isNotInheritFolder(folderId, tenantId));
			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		logger.debug("getFileList end");
		return result;
	}
	
	@RequestMapping(value="/rest/ezwebfolderadmin/company-id/{userid:.+}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getCompanyId(@PathVariable(value="userid") String userId, HttpServletRequest request, Locale locale) {
		logger.debug("getCompanyId start");
		String serverName = request.getHeader("x-user-host")   != null ? request.getHeader("x-user-host") : "";
		JSONObject result = new JSONObject();
		logger.debug("serverName: " + serverName + " || UserId: " + userId);
		
		if (serverName.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			
			result.put("data", userInfo.getCompanyID());
			result.put("primary", userInfo.getPrimary());
			result.put("status", "ok");
			result.put("code", 0);
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		logger.debug("getCompanyId end");
		return result;
	}
	
	@RequestMapping(value="/rest/ezwebfolderadmin/company-list/{userid:.+}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getCompanyList(@PathVariable(value="userid") String userId, HttpServletRequest request, Locale locale) {
		logger.debug("getCompanyList start");
		String serverName = request.getHeader("x-user-host")   != null ? request.getHeader("x-user-host") : "";
		String mode       = request.getParameter("mode")     != null ? request.getParameter("mode")   : "";
		JSONObject result = new JSONObject();
		logger.debug("serverName: " + serverName + " || mode: " + mode + " || UserId: " + userId);
		
		if (serverName.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			
			//Get list of companies
			List<OrganDeptVO> resultList = new ArrayList<OrganDeptVO>();
			
			// 2020-12-16 김은실 - [카이스트] 여기서 권한을 k,wf도 해줘야 하는지 보류.	
//			String userRoll = userInfo.getRollInfo();
//			if( (userRoll.contains("c=1") || userRoll.contains("k=1") || userRoll.contains("f=1")) &&		//webfolderUtil.isWebfolderAdmin(userInfo) &&	
			if (userInfo.getRollInfo().indexOf("c=1")  > -1 && !mode.equals("normal")) {
				resultList = ezOrganAdminService.getCompanyList(userInfo.getPrimary(), userInfo.getTenantId());
				result.put("isAdminMode", true);
			} else {
				OrganDeptVO dept = ezOrganService.getDeptInfo(userInfo.getCompanyID(), userInfo.getPrimary(), userInfo.getTenantId());
				resultList.add(dept);
				result.put("isAdminMode", false);
			}
			
			result.put("useKlib", "yes".equalsIgnoreCase(ezCommonService.getTenantConfig("useWebfolderKlib", userInfo.getTenantId())));
			result.put("useVersionHistory", "yes".equalsIgnoreCase(ezCommonService.getTenantConfig("useWebfolderVersionHistory", userInfo.getTenantId())));
			result.put("data", resultList);
			result.put("userCompany", userInfo.getCompanyID());
			result.put("primary", userInfo.getPrimary());
			result.put("status", "ok");
			result.put("code", 0);
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		logger.debug("getCompanyList end");
		return result;
	}
	
	@RequestMapping(value="/rest/ezwebfolderadmin/folders/dept", method= RequestMethod.POST, produces="application/json;charset=utf-8")
	public JSONObject postDeptFolderInsert(@RequestBody JSONObject jsonObject, HttpServletRequest request, Locale locale) {
		logger.debug("postDeptFolderInsert start");
		JSONParser parser      = new JSONParser();
		JSONObject result      = new JSONObject();
		try {
			jsonObject             = (JSONObject) parser.parse(jsonObject.toJSONString());
		} catch (ParseException e1) {
			logger.error(e1.getMessage(), e1);
			result.put("status", "error");
			result.put("code", 2);
		}
		String serverName      = request.getHeader("x-user-host") != null ? request.getHeader("x-user-host")       : "";
		String userId          = jsonObject.get("userId")       != null ? (String) jsonObject.get("userId")    : "";
		String pFolderId       = jsonObject.get("pFolderId")    != null ? (String) jsonObject.get("pFolderId") : "";
		String folderName      = jsonObject.get("fName")        != null ? (String) jsonObject.get("fName")     : "";
		String folderName2     = jsonObject.get("fName2")       != null ? (String) jsonObject.get("fName2")    : "";
		
		logger.debug("serverName: " + serverName + " || folderName1: " + folderName + " || FolderName2: " + folderName2 + " || ParentFolderID: " + pFolderId);
		
		if (pFolderId.equals("") || userId.equals("") || folderName.equals("") || serverName.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		process: try {
			LoginVO userInfo           = commonUtil.getUserForGw(userId, serverName);
			String userName1           = userInfo.getDisplayName1();
			String userName2           = userInfo.getDisplayName2();
			int tenantId               = userInfo.getTenantId();
			String offset              = userInfo.getOffset();
			
			List<DuplicateInfoVO> duplicateList = new ArrayList<>();
			
			if (duplicateList.addAll(ezWebFolderService.getAllDuplicateInfo(folderName, pFolderId, offset, tenantId))) {
				result.put("status", "ok");
				result.put("code", 8);
				result.put("duplicateInfoArray", duplicateList);
				
				break process;
			}
			
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
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		logger.debug("postDeptFolderInsert end");
		return result;
	}
	
	@RequestMapping(value="/rest/ezwebfolderadmin/folders/{folderid}/dept", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject putDeptFolderUpdate(@RequestBody JSONObject jsonObject, @PathVariable(value="folderid") String folderId, HttpServletRequest request, Locale locale) {
		logger.debug("putDeptFolderUpdate start");
		JSONParser parser      = new JSONParser();
		JSONObject result      = new JSONObject();
		try {
			jsonObject             = (JSONObject) parser.parse(jsonObject.toJSONString());
		} catch (ParseException e1) {
			logger.error(e1.getMessage(), e1);
			result.put("status", "error");
			result.put("code", 2);
		}
		String serverName      = request.getHeader("x-user-host") != null ? request.getHeader("x-user-host")    : "";
		String userId          = jsonObject.get("userId")       != null ? (String) jsonObject.get("userId") : "";
		String folderName      = jsonObject.get("fName")        != null ? (String) jsonObject.get("fName")  : "";
		String folderName2     = jsonObject.get("fName2")       != null ? (String) jsonObject.get("fName2") : "";
		String encryptionStr   = (String) jsonObject.get("encryption");
		
		logger.debug("serverName: {}, folderName1: {}, folderName2: {}, folderId: {}, userId: {}, encryption: {}",
				serverName, folderName, folderName2, folderId, userId, encryptionStr);
		
		if (folderId.equals("") || userId.equals("") || folderName.equals("") || serverName.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo           = commonUtil.getUserForGw(userId, serverName);
			int tenantId               = userInfo.getTenantId();
			String offset              = userInfo.getOffset();
			
			List<DuplicateInfoVO> duplicateList = new ArrayList<>();
			FolderVO folder            = ezWebFolderService.getFolderByFolderId(folderId, offset, tenantId);
			boolean isRootFolder       = folder.getFolderLevel() == 0;
			
			if (!isRootFolder
					&& duplicateList.addAll(ezWebFolderService.getAllDuplicateInfo(folderName, folder.getFolderUpper(), offset, tenantId))) {
				if (duplicateList.size() == 1 && duplicateList.get(0).getOldId().equals(folderId)) {
					duplicateList.clear();
				}
			}
			
			if (duplicateList.isEmpty()) {
				if (isRootFolder) {
					logger.debug("folder level 0 is the root folder, so it only processeds with klib encryption flag update");
				} else {
					Date date = new Date();
					SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
					String timeUTC = commonUtil.getDateStringInUTC(formatter.format(date), offset, true);

					String createDate = "";
					
					if (folder.getCreateDate().contains(".0")){
						// TODO: 현재 query상에서 .S 형태로 돌아와서 해놓은것이지만 다른 형식으로 돌아올때에는 수정필요함.
						SimpleDateFormat formatter2 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.S");						// db에서 가져온 folder의 timeUTC를 적용한 -9시간
						Date date1 = formatter2.parse(folder.getCreateDate());																							// folder의 creatreDate를 가져와서 date방식으로 format
						
						SimpleDateFormat targetDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");					// 우리가 지원하는 형식으로 다시 포맷
						createDate = targetDateFormat.format(date1);
					} else {
						createDate = folder.getCreateDate();
					}
					
					String timeUTCCreate = commonUtil.getDateStringInUTC(createDate, offset, true); // timeUTC 적용

					folder.setFolderName1(folderName);
					folder.setFolderName2(folderName2);
					folder.setUpdateId(userId);
					folder.setUpdateDate(timeUTC);
					folder.setCreateDate(timeUTCCreate);

					ezWebFolderAdminService.insertFolder(folder);
				}
				
				result.put("status", "ok");
				result.put("code", 0);
			} else {
				result.put("status", "ok");
				result.put("code", 8);
				result.put("duplicateInfoArray", duplicateList);
			}
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		logger.debug("putDeptFolderUpdate end");
		return result;
	}
	
	@RequestMapping(value="/rest/ezwebfolderadmin/company-folder/{companyid:.+}", method= RequestMethod.POST, produces="application/json;charset=utf-8")
	public JSONObject postMakeCompanyFolder(@PathVariable(value="companyid") String companyId, HttpServletRequest request, Locale locale) {
		logger.debug("postMakeCompanyFolder start");
		String serverName = request.getHeader("x-user-host") != null ? request.getHeader("x-user-host") : "";
		String userId     = request.getParameter("userId") != null ? request.getParameter("userId") : "";
		JSONObject result = new JSONObject();
		
		logger.debug("serverName: " + serverName + " || companyId: " + companyId + " || UserId: " + userId);
		
		if (serverName.equals("") || companyId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
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
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		logger.debug("postMakeCompanyFolder end");
		return result;
	}
	
	@RequestMapping(value="/rest/ezwebfolderadmin/dept-folder/{companyid:.+}", method= RequestMethod.POST, produces="application/json;charset=utf-8")
	public JSONObject postMakeDepartmentFolder(@PathVariable(value="companyid") String companyId, HttpServletRequest request, Locale locale) {
		logger.debug("postMakeDepartmentFolder start");
		String serverName = request.getHeader("x-user-host") != null ? request.getHeader("x-user-host") : "";
		String userId     = request.getParameter("userId") != null ? request.getParameter("userId") : "";
		JSONObject result = new JSONObject();
		
		logger.debug("serverName: " + serverName + " || || companyId: " + companyId + " || UserId: " + userId);
		
		if (serverName.equals("") || companyId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			ezWebFolderAdminService.addDeptFolders(companyId, userInfo);
			
			result.put("status", "ok");
			result.put("code", 0);
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		logger.debug("postMakeDepartmentFolder end");
		return result;
	}
	
	@RequestMapping(value="/rest/ezwebfolder/foldersTree/file", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getFileFolderTree(HttpServletRequest request, Locale locale) {
		logger.debug("getFileFolderTree start");
		String userId     = request.getParameter("userId")    != null ? request.getParameter("userId")    : "";
		String fileList   = request.getParameter("fileList")  != null ? request.getParameter("fileList")  : "";
		String companyId  = request.getParameter("companyId") != null ? request.getParameter("companyId") : "";
		String mode       = request.getParameter("mode")      != null ? request.getParameter("mode")      : "";
		String type       = request.getParameter("type")      != null ? request.getParameter("type")      : "";
		String serverName = request.getHeader("x-user-host")    != null ? request.getHeader("x-user-host")    : "";
		String[] fileArr  = fileList.split(",");
		JSONObject result = new JSONObject();
		
		logger.debug("Mode: " + mode + " || fileList: " + fileList + " || type: " + type + " || companyId: " + companyId + " || serverName: " + serverName + " || UserId: " + userId);
		
		if (serverName.equals("") || mode.equals("") || type.equals("") || fileArr.length == 0) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
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
					if (webfolderUtil.isWebfolderAdmin(userInfo) && mode.equalsIgnoreCase("admin")) {
						company = ezWebFolderService.getCompanySimpleFolder(companyId, userInfo);
						ezWebFolderService.getAllSubDepts(company, tenantId, 2);
					}
					else {
						company                                 = ezWebFolderService.getCompanySimpleFolder(userInfo.getCompanyID(), userInfo);
						
						List<String> idList = ezWebFolderService_y.idListUpgrade(userId, userInfo.getDeptID(), userInfo.getCompanyID(), tenantId);
						List<FolderSimpleVO> listCompSubFolders = ezWebFolderService.getCompanySubSimpleFolder(userInfo.getId(), userInfo.getDeptID(), company.getFolderId(), userInfo.getCompanyID(), tenantId, idList);
						
						if (listCompSubFolders != null && listCompSubFolders.size() > 0) {
							company.setHasSubFolder(1);
						}
						else {
							company.setHasSubFolder(0);
						}
					}
					
					result.put("folderTree", company);
					break;
				case "dept":
					//Get department folder tree
					List<FolderSimpleVO> listFolders = new ArrayList<FolderSimpleVO>();
					if (webfolderUtil.isWebfolderAdmin(userInfo) && mode.equalsIgnoreCase("admin")) {
						listFolders = ezWebFolderService.getAllSimpleDeptFolder(companyId, userInfo);
					}
					else {
						listFolders = ezWebFolderService.getDeptFolderTreeForUser(userId, userInfo.getDeptID(), tenantId);
					}
					
					result.put("folderTree", listFolders);
					
					break;
				case "user":
					//Get personal folder tree
					FolderSimpleVO personalFolder = ezWebFolderService.getUserSimpleFolder(userId, tenantId);
					
					//If not created then create
					if (personalFolder == null) {
						ezWebFolderAdminService.addPersonalFolder(userInfo);
						personalFolder = ezWebFolderService.getUserSimpleFolder(userId, tenantId);
					}
					
					result.put("folderTree", personalFolder);
					break;
				case "share":
					//Get share folder tree
					List<FolderSimpleVO> shareFolders = new ArrayList<FolderSimpleVO>();
					shareFolders = ezWebFolderService.getAllSimpleShareFolder(userId, userInfo.getDeptID(), companyId, tenantId);
					result.put("folderTree", shareFolders);
					break;
			}
			
			result.put("currentFolders", folders);
			result.put("status", "ok");
			result.put("code", 0);
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		logger.debug("getFileFolderTree end");
		return result;
	}
	
	@RequestMapping(value="/rest/ezwebfolder/dept-chief/{userid:.+}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject checkChief(@PathVariable(value="userid") String userId, HttpServletRequest request, Locale locale) {
		logger.debug("checkChief start");
		String serverName = request.getHeader("x-user-host")   != null ? request.getHeader("x-user-host") : "";
		JSONObject result = new JSONObject();
		
		logger.debug("ServerName: " + serverName + " || userId: " + userId);
		
		if (serverName.equals("") || userId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
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
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		logger.debug("checkChief end");
		return result;
	}
	
	@RequestMapping(value="/rest/ezwebfolder/users/{userid:.+}/env/list-count", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getListCount(@PathVariable(value="userid") String userId, HttpServletRequest request, Locale locale) {
		logger.debug("getListCount start");
		String serverName = request.getHeader("x-user-host")   != null ? request.getHeader("x-user-host") : "";
		JSONObject result = new JSONObject();
		
		logger.debug("ServerName: " + serverName + " || userId: " + userId);
		
		if (serverName.equals("") || userId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
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
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		logger.debug("getListCount end");
		return result;
	}
	
	@RequestMapping(value="/rest/ezwebfolder/env/{listcount}/update", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject updateEnvListCount(@PathVariable(value="listcount") String listCount, HttpServletRequest request, Locale locale) {
		logger.debug("updateEnvListCount start");
		String serverName = request.getHeader("x-user-host")   != null ? request.getHeader("x-user-host") : "";
		String userId     = request.getParameter("userId")   != null ? request.getParameter("userId") : "";
		JSONObject result = new JSONObject();
		
		logger.debug("ServerName: " + serverName + " || userId: " + userId + " || listCount: " + listCount);
		
		if (serverName.equals("") || userId.equals("") || listCount.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			int tenantId         = loginService.getTenantId(serverName);
			ezWebFolderService.updateListCount(userId, listCount, tenantId);
			
			result.put("status", "ok");
			result.put("code", 0);
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		logger.debug("updateEnvListCount end");
		return result;
	}
	
	@RequestMapping(value="/rest/ezwebfolder/env/{folderId}/{inOrUp}PortletFolderId", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject inOrUpPortletFolderId(@PathVariable(value="folderId") String folderId, 
											@PathVariable(value="inOrUp") String inOrUp, HttpServletRequest request, Locale locale) {
		logger.debug("inOrUpPortletFolderId start");
		String serverName = request.getHeader("x-user-host")   != null ? request.getHeader("x-user-host") : "";
		String userId     = request.getParameter("userId")   != null ? request.getParameter("userId") : "";
		JSONObject result = new JSONObject();
		
		logger.debug("ServerName: " + serverName + " || userId: " + userId + " || folderId: " + folderId);
		
		if (serverName.equals("") || userId.equals("") || folderId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			int tenantId         = loginService.getTenantId(serverName);
			switch (inOrUp) {
			case "insert":
				ezCommonService.insertUserConfigInfo(tenantId, userId, "webfolderPortletFolderId", folderId);
				break;
			case "update":
				ezCommonService.updateUserConfigInfo(tenantId, userId, "webfolderPortletFolderId", folderId);
				break;
			}
			
			result.put("status", "ok");
			result.put("code", 0);
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		logger.debug("inOrUpPortletFolderId end");
		return result;
	}
	
	@RequestMapping(value="/rest/ezwebfolder/depart-tree/chief/{userid:.+}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getDeptTree(@PathVariable(value="userid") String userId, HttpServletRequest request, Locale locale) {
		logger.debug("getDeptTree start");
		String serverName = request.getHeader("x-user-host") != null ? request.getHeader("x-user-host") : "";
		JSONObject result = new JSONObject();
		
		logger.debug("userId: " + userId + " || serverName: " + serverName);
		
		if (userId.equals("") || serverName.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			int tenantId     = userInfo.getTenantId();
			String primary   = userInfo.getPrimary();
			boolean check    = ezWebFolderService.checkDepartChief(userId, tenantId);
			
			if (check == false) {
				logger.debug("Privileges!");
				result.put("status", "error");
				result.put("code", 3);
				return result;
			}
			
			List<SimpleDeptVO> listDepts           = ezWebFolderService.getAllDeptsForChief(userId, 0, primary, tenantId);
			List<SimpleDeptVO> listSelectedDepts   = ezWebFolderService.getSelectedDeptsForChief(userId, 0, primary, tenantId);
			
			result.put("deptTree", listDepts);
			result.put("selectedDepts", listSelectedDepts);
			result.put("userDept", userInfo.getDeptID());
			result.put("status", "ok");
			result.put("code", 0);
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		logger.debug("getDeptTree end");
		return result;
	}
	
	@RequestMapping(value="/rest/ezwebfolder/selected-dept/chief/{userid:.+}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getSelectedDepts(@PathVariable(value="userid") String userId, HttpServletRequest request, Locale locale) {
		logger.debug("getSelectedDepts start");
		String serverName = request.getHeader("x-user-host") != null ? request.getHeader("x-user-host") : "";
		JSONObject result = new JSONObject();
		
		logger.debug("userId: " + userId + " || serverName: " + serverName);
		
		if (userId.equals("") || serverName.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo                     = commonUtil.getUserForGw(userId, serverName);
			int tenantId                         = userInfo.getTenantId();
			String primary                       = userInfo.getPrimary();
			List<SimpleDeptVO> listSelectedDepts = ezWebFolderService.getSelectedDeptsForChief(userId, 0, primary, tenantId);
			
			result.put("selectedDepts", listSelectedDepts);
			result.put("status", "ok");
			result.put("code", 0);
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		logger.debug("getSelectedDepts end");
		return result;
	}
	
	@RequestMapping(value="/rest/ezwebfolder/env/dept-list", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject updateEnvDeptList(@RequestParam("deptList") List<String> deptsList, HttpServletRequest request, Locale locale) {
		logger.debug("updateEnvDeptList start");
		String serverName = request.getHeader("x-user-host") != null ? request.getHeader("x-user-host") : "";
		String userId     = request.getParameter("userId") != null ? request.getParameter("userId") : "";
		JSONObject result = new JSONObject();
		
		logger.debug("ServerName: " + serverName + " || userId: " + userId + " || DeptId list: " + String.join(",", deptsList));
		
		if (serverName.equals("") || userId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			ezWebFolderAdminService.updateSelectedDeptsForChief(deptsList, userInfo);
			
			result.put("status", "ok");
			result.put("code", 0);
		} 
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		logger.debug("updateEnvDeptList end");
		return result;
	}
	
	/** 카이스트: 이름변경, 이동, 삭제에서의 권한 (만든이인지, 담당자인지를 체크) */
	@RequestMapping(value="/rest/ezwebfolder/permission-check/{userid:.+}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject checkPermission(@PathVariable(value="userid") String userId, HttpServletRequest request, Locale locale) {
		logger.debug("checkPermission start");
		String fileList   = request.getParameter("fileList") != null ? request.getParameter("fileList") : "";
		String folderList = request.getParameter("folderList") != null ? request.getParameter("folderList") : "";
		String fileId     = request.getParameter("fileId")   != null ? request.getParameter("fileId")   : "";
		String serverName = request.getHeader("x-user-host")   != null ? request.getHeader("x-user-host")   : "";
		boolean isRecursive = Optional.ofNullable(request.getParameter("isRecursive"))
				.map("true"::equalsIgnoreCase).orElse(false);
		JSONObject result = new JSONObject();
		
		logger.debug("userId: " + userId + " || serverName: " + serverName + " || fileList: " + fileList + 
				" || fileId: " + fileId + " || folderList:" + folderList);
		
		if (userId.equals("") || serverName.equals("") || (fileId.equals("") && fileList.equals("") && folderList.equals("")) ) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo  = commonUtil.getUserForGw(userId, serverName);
			
			String[] folderIds = folderList.isEmpty() ? new String[0] : folderList.split(",");
			String[] fileIds = fileId.isEmpty() ? fileList.split(",") : new String[] {fileId};

			result = ezWebFolderService_y.checkPermissionForCreator(folderIds, fileIds, userInfo, isRecursive);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		logger.debug("checkPermission end");
		return result;
	}
	
	@RequestMapping(value="/rest/ezwebfolderadmin/dept-check/{folderid:.+}", method= RequestMethod.POST, produces="application/json;charset=utf-8")
	public JSONObject getCheckValidDept(@PathVariable(value="folderid") String folderId, HttpServletRequest request, Locale locale) {
		logger.debug("getCheckValidDept start");
		String serverName = request.getHeader("x-user-host") != null ? request.getHeader("x-user-host") : "";
		String userId     = request.getParameter("userId") != null ? request.getParameter("userId") : "";
		JSONObject result = new JSONObject();
		
		logger.debug("serverName: " + serverName + " || folderId: " + folderId + " || UserId: " + userId);
		
		if (serverName.equals("") || folderId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
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
				result.put("code", 2);
			}
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		logger.debug("getCheckValidDept end");
		return result;
	}
	
	@RequestMapping(value = "/rest/ezwebfolder/download-excel", method=RequestMethod.GET, produces = { MediaType.APPLICATION_OCTET_STREAM_VALUE})
	@ResponseBody
	public void getFileExcel(HttpServletRequest request, HttpServletResponse response) {
		logger.debug("getFileExcel start");
		String fileName     = request.getParameter("fileName")   != null ? request.getParameter("fileName")   : "";
		String serverName   = request.getHeader("x-user-host")     != null ? request.getHeader("x-user-host")     : "";
		String userAgent    = request.getParameter("userAgent")  != null ? request.getParameter("userAgent")  : "";
		
		logger.debug("serverName: " + serverName + " || File Name: " + fileName + " || UserAgent: " + userAgent);
		
		if (serverName.equals("") || fileName.equals("")) {
			logger.debug("downloadAttach illegal arguments!");
			return;
		}
		
		//Get absolute path of the application
		String realPath  = request.getServletContext().getRealPath("");
		try {
			int tenantId     = loginService.getTenantId(serverName);
			ezWebFolderAdminService.getExcelFile(fileName, realPath, userAgent, response, tenantId);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("getFileExcel end");
		return;
	}
	
	@RequestMapping(value="/rest/ezwebfolder/check-wfadmin/{userid:.+}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject checkWfAdmin(@PathVariable(value="userid") String userId, HttpServletRequest request, Locale locale) {
		logger.debug("checkWfAdmin start");
		String serverName = request.getHeader("x-user-host") != null ? request.getHeader("x-user-host") : "";
		JSONObject result = new JSONObject();
		
		logger.debug("ServerName: " + serverName + " || userId: " + userId);
		
		if (serverName.equals("") || userId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			boolean check    = webfolderUtil.isWebfolderAdmin(userInfo);
			
			if (check == true) {
				result.put("status", "ok");
				result.put("code", 0);
				result.put("data", "1");
			} else {
				result.put("status", "error");
				result.put("code", 3);
			}
		} 
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		logger.debug("checkWfAdmin end");
		return result;
	}

	@RequestMapping(value="/rest/ezwebfolder/folder/{folderId}/encryption", method = RequestMethod.PUT, produces = "application/json;charset=utf-8")
	public JSONObject insertEncryptionFolder(@PathParam(value = "folderId") String folderId, HttpServletRequest request) {
		int tenantId = Integer.parseInt(orElse(request.getParameter("tenantId"), "0"));

		logger.debug("G/W WEBFOLDER [PUT /rest/ezwebfolder/folder/{folderId}/encryption] started.");
		logger.debug("folderId: {}, tenantId : {}", folderId, tenantId);

		JSONObject result = new JSONObject();

		try {
			ezWebFolderService.insertEncryptionFolder(folderId, tenantId);

			result.put("status", "ok");
		} catch (Exception ex) {
			logger.error(ex.getMessage(), ex);
			result.put("status", "error");
		}

		logger.debug("G/W WEBFOLDER [PUT /rest/ezwebfolder/folder/{folderId}/encryption] ended.");

		return result;
	}

	@RequestMapping(value="/rest/ezwebfolder/folder/{folderId}/encryption", method = RequestMethod.DELETE, produces = "application/json;charset=utf-8")
	public JSONObject deleteEncryptionFolder(@PathParam(value = "folderId") String folderId, HttpServletRequest request) {
		int tenantId = Integer.parseInt(orElse(request.getParameter("tenantId"), "0"));

		logger.debug("G/W WEBFOLDER [DELETE /rest/ezwebfolder/folder/{folderId}/encryption] started.");
		logger.debug("folderId: {}, tenantId : {}", folderId, tenantId);

		JSONObject result = new JSONObject();

		try {
			ezWebFolderService.deleteEncryptionFolder(folderId, tenantId);

			result.put("status", "ok");
		} catch (Exception ex) {
			logger.error(ex.getMessage(), ex);
			result.put("status", "error");
		}

		logger.debug("G/W WEBFOLDER [DELETE /rest/ezwebfolder/folder/{folderId}/encryption] ended.");

		return result;
	}

	@RequestMapping(value = { "/rest/ezwebfolder/file/{fileId}/histories",
			"/rest/ezwebfolder/file/{fileId}/histories/{version}" }, method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getFileHistories(@PathVariable String fileId, @PathVariable Optional<Integer> version, HttpServletRequest request) {
		String requestURI = request.getRequestURI();
		String serverName = request.getHeader("x-user-host");
		String userId = request.getParameter("userId");

		logger.debug("G/W WEBFOLDER [GET {}] started.", requestURI);
		logger.debug("serverName: {}, fileId: {}, version: {}", serverName, fileId, version.map(Object::toString).orElse("all"));

		JSONObject result = new JSONObject();

		if (containsNull(serverName, userId)) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}

		try {
			String data;
			ObjectMapper mapper = new ObjectMapper();
			LoginVO user = commonUtil.getUserForGw(userId, serverName);
			String offset = user.getOffset();
			int tenantId = user.getTenantId();

			boolean isPermitted = "ok".equalsIgnoreCase(ezWebFolderService_y.checkPermission(userId, user.getDeptID(), user.getCompanyID(), fileId, "F", tenantId));

			if (version.isPresent()) {
				// JSONObject
				FileHistoryVO history = ezWebFolderService.getFileHistory(fileId, version.get(), offset, tenantId);
				data = mapper.writeValueAsString(history);
			} else {
				// JSONArray
				List<FileHistoryVO> histories = ezWebFolderService.getFileHistories(fileId, offset, tenantId);
				data = mapper.writeValueAsString(histories);
			}

			FileVO file = ezWebFolderService.getFileByFileId(fileId, offset, tenantId);

			result.put("isEncrypted", ezWebFolderService.isEncryptedFile(fileId, tenantId));
			result.put("isCreator", userId.equals(file.getCreateId()));
			result.put("isPermitted", isPermitted);
			result.put("data", new JSONParser().parse(data));
			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception ex) {
			logger.error(ex.getMessage(), ex);
			result.put("status", "error");
			result.put("code", 2);
		}

		logger.debug("G/W WEBFOLDER [GET {}] ended.", requestURI);

		return result;
	}

	@RequestMapping(value = "/rest/ezwebfolder/file/{fileId}/histories/{version}", method = RequestMethod.PUT, produces = "application/json;charset=utf-8")
	public JSONObject restoreFileVersion(@PathVariable String fileId, @PathVariable int version, HttpServletRequest request) {
		String requestURI = request.getRequestURI();
		String serverName = request.getHeader("x-user-host");
		String userId = request.getParameter("userId");

		logger.debug("G/W WEBFOLDER [PUT {}] started.", requestURI);
		logger.debug("serverName: {}, fileId: {}, userId: {}, version: {}", serverName, fileId, userId, version);

		JSONObject result = new JSONObject();

		if (containsNull(serverName, userId)) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}

		try {
			LoginVO user = commonUtil.getUserForGw(userId, serverName);

			String permissionState = ezWebFolderService_y.checkPermission(userId, user.getDeptID(), user.getCompanyID(),
					fileId, "F", user.getTenantId());

			if ("fail".equalsIgnoreCase(permissionState)) {
				throw new IllegalAccessException("접근 권한이 없습니다.");
			}

			ezWebFolderService.revertFileVersion(user, fileId, version);

			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception ex) {
			logger.error(ex.getMessage(), ex);
			result.put("status", "error");
			result.put("code", 2);
		}

		logger.debug("G/W WEBFOLDER [PUT {}] ended.", requestURI);

		return result;
	}

	@RequestMapping(value = { "/rest/ezwebfolder/file/{fileId}/histories",
			"/rest/ezwebfolder/file/{fileId}/histories/{version}" }, method = RequestMethod.DELETE, produces = "application/json;charset=utf-8")
	public JSONObject deleteFileVersions(@PathVariable String fileId, @PathVariable Optional<Integer> version, HttpServletRequest request) {
		String requestURI = request.getRequestURI();
		String serverName = request.getHeader("x-user-host");
		String userId = request.getParameter("userId");
		boolean isSingle = version.isPresent();

		int[] versions = isSingle ? null
				: Stream.of(request.getParameter("versions").split(","))
						.mapToInt(Integer::parseInt).toArray();

		logger.debug("G/W WEBFOLDER [DELETE {}] started.", requestURI);
		logger.debug("serverName: {}, fileId: {}, userId: {}, versions: {}", serverName, fileId, userId,
				isSingle ? version.get() : versions);

		JSONObject result = new JSONObject();

		if (containsNull(serverName, userId)) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}

		try {
			LoginVO user = commonUtil.getUserForGw(userId, serverName);

			String permissionState = ezWebFolderService_y.checkPermission(userId, user.getDeptID(), user.getCompanyID(),
					fileId, "F", user.getTenantId());

			if ("fail".equalsIgnoreCase(permissionState)) {
				throw new IllegalAccessException("접근 권한이 없습니다.");
			}

			if (isSingle) {
				ezWebFolderService.deleteFileVersion(user, fileId, version.get());
			} else {
				for (int ver : versions) {
					ezWebFolderService.deleteFileVersion(user, fileId, ver);
				}
			}

			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception ex) {
			logger.error(ex.getMessage(), ex);
			result.put("status", "error");
			result.put("code", 2);
		}

		logger.debug("G/W WEBFOLDER [DELETE {}] ended.", requestURI);

		return result;
	}

	@RequestMapping(value = "/rest/ezwebfolder/filemanage/version-download", method=RequestMethod.GET, produces = { MediaType.APPLICATION_OCTET_STREAM_VALUE})
	@ResponseBody
	public void getVersionDownload(HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("getVersionDownload start");
		String serverName = orElse(request.getHeader("x-user-host"), "");
		String userId = orElse(request.getParameter("userId"), "");
		String fileId = orElse(request.getParameter("fileId"), "");
		String userAgent = orElse(request.getParameter("userAgent"), "");

		int[] versions = Optional.ofNullable(request.getParameter("versions"))
				.map(str -> str.split(","))
				.map(Stream::of)
				.orElse(Stream.empty())
				.mapToInt(Integer::parseInt)
				.toArray();

		logger.debug("userAgent=" + userAgent);
		logger.debug("serverName: {}, userId: {}, fileId: {}, versions: {}", serverName, userId, fileId, versions);

		if (containsNull(serverName, userId, fileId, versions)) {
			logger.debug("getVersionDownload illegal arguments!");
			return ;
		}

		LoginVO user = commonUtil.getUserForGw(userId, serverName);
		ezWebFolderService.getDownloadedVersions(fileId, versions, user, userAgent, request, response);

		logger.debug("getVersionDownload end");
		return;
	}

	@RequestMapping(value = "/rest/ezwebfolder/{userId:.+}/upload-limit", method = RequestMethod.GET)
	@ResponseBody
	public JSONObject getUploadLimit(@PathVariable String userId, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("getUploadLimit start");
		String serverName = orElse(request.getHeader("x-user-host"), "");
		JSONObject result = new JSONObject();

		if (containsNull(serverName, userId)) {
			logger.debug("getUploadLimit illegal arguments!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}

		LoginVO user = commonUtil.getUserForGw(userId, serverName);
		WebfolderConfigVO webfolderConfig = ezWebFolderAdminService.getWebfolderConfig(user.getCompanyID(), user.getTenantId());
		double limitUploadValue = webfolderConfig.getUploadLimit().equals("") ? 0 : Double.parseDouble(webfolderConfig.getUploadLimit());
		limitUploadValue *= 1073741824;

		logger.debug("getUploadLimit end");

		result.put("status", "ok");
		result.put("code", 0);
		result.put("uploadLimit", limitUploadValue);
		return result;
	}

	@RequestMapping(value="/rest/ezwebfolder/users/{userId:.+}/checknotinherit", method=RequestMethod.POST, produces ="application/json;charset=utf-8")
	public JSONObject checkNotInherit(@PathVariable String userId, @RequestBody JSONObject jsonObject, HttpServletRequest request) {
		logger.debug("checkNotInherit started.");

		String serverName = orElse(request.getHeader("x-user-host"), "");
		String fileListStr = jsonObject.get("fileList").toString();
		String folderListStr = jsonObject.get("folderList").toString();

		JSONObject jsonObj = new JSONObject();

		if (containsNull(serverName, userId)) {
			jsonObj.put("status", "error");
			jsonObj.put("code", 1);
			jsonObj.put("data", "");
			logger.debug("parameter error. checkPermissions ended.");
			return jsonObj;
		}

		try {
			int tenantId = loginService.getTenantId(serverName);

			String[] fileIds = fileListStr.split(",");
			String[] folderIds = folderListStr.split(",");

			boolean isContainNotInherit = ezWebFolderService.containsNotInheritFolder(fileIds, folderIds, tenantId);

			jsonObj.put("result", isContainNotInherit);
			jsonObj.put("status", "ok");
			jsonObj.put("code", 0);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);

			jsonObj.put("status", "error");
			jsonObj.put("code", 2);
		}

		logger.debug("checkNotInherit ended.");
		return jsonObj;
	}

	@RequestMapping(value="/rest/ezwebfolder/users/{userId:.+}/checkencryptcreator", method=RequestMethod.POST, produces ="application/json;charset=utf-8")
	public JSONObject checkEncryptCreator(@PathVariable String userId, @RequestBody JSONObject jsonObject, HttpServletRequest request) {
		logger.debug("checkEncryptCreator started.");

		String serverName = orElse(request.getHeader("x-user-host"), "");
		String fileList = jsonObject.get("fileList").toString();

		logger.debug("userId: " + userId + " || serverName: " + serverName);

		JSONObject result = new JSONObject();

		if (containsNull(serverName, userId)) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			logger.debug("parameter error. checkPermissions ended.");
			return result;
		}

		try {
			LoginVO user = commonUtil.getUserForGw(userId, serverName);
			boolean isEncrypted = ezWebFolderService.isEncryptedFile(fileList, user.getTenantId());
			FileVO file = ezWebFolderService.getFileByFileId(fileList, user.getOffset(), user.getTenantId());

			if (isEncrypted && !file.getCreateId().equals(user.getId())) {
				result.put("status", "error");
				result.put("code", 3);
			} else {
				result.put("status", "ok");
				result.put("code", 0);
			}
		} catch (Exception e) {
			logger.error(e.getMessage(), e);

			result.put("status", "error");
			result.put("code", 2);
		}

		logger.debug("checkEncryptCreator ended.");
		return result;
	}

	@RequestMapping(value = "/rest/ezwebfolder/file/{fileId}/{mobilePath:(?:mobile-)?}viewer/{userId:.+}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public Result getSatViewerURI(@PathVariable String fileId, @PathVariable String userId, @PathVariable String mobilePath,
			@RequestParam(value = "version") Optional<Integer> versionOptional, HttpServletRequest request) {
		String requestURI = request.getRequestURI();
		String serverName = request.getHeader("x-user-host");
		boolean isMobileRequest = !mobilePath.isEmpty();

		logger.debug("G/W WEBFOLDER [GET {}] started.", requestURI);
		logger.debug("serverName: {}, fileId: {}, userId: {}, version: {}, isMobileRequest={}", serverName, fileId, userId, versionOptional, isMobileRequest);

		if (containsNull(serverName, userId)) {
			logger.error("Parameter error!");
			return Result.failure();
		}

		Result result;

		process: try {
			LoginVO user = commonUtil.getUserForGw(userId, serverName);
			String companyId = user.getCompanyID();
			String offset = user.getOffset();
			int tenantId = user.getTenantId();

			String permissionState = ezWebFolderService_y.checkPermission(userId, user.getDeptID(), companyId, fileId, "F", tenantId);

			if ("fail".equalsIgnoreCase(permissionState)) {
				throw new IllegalAccessException("접근 권한이 없습니다.");
			}

			String propertyNameForViewerMode = isMobileRequest ? "useMobileViewer" : "useImageConvertServer";

			if (!"1".equals(ezCommonService.getTenantConfig(propertyNameForViewerMode, tenantId))) {
				throw new RuntimeException("Not enabled " + propertyNameForViewerMode + " tenant config");
			}

			FileVO file = ezWebFolderService.getFileByFileId(fileId, offset, tenantId);
			String fileType = file.getFileTypeName();

			if (!"document".equals(fileType) && !"image".equals(fileType)) {
				logger.debug("is unsupported format");
				result = Result.successWithCode(1);
				break process;
			}

			int version = versionOptional.orElse(file.getVersion());

			// 파일이력에 미리보기(웹뷰어) 항목으로 추가
			ezWebFolderService.saveLog("V", companyId, offset, userId, user.getDisplayName1(), user.getDisplayName2(),
					tenantId, file, String.valueOf(version), user.getPrimary());

			SatDownloadKey key = new SatDownloadKey(fileId, version, tenantId);
			String filePath = ezCommonService.getTenantConfig("webfolderHostUrlForSAT", tenantId)
					+ "/rest/ezwebfolder/file/sat?key=" + URLEncoder.encode(key.toString(), "UTF-8");
			String fileName = file.getFileName();

			logger.debug("filePath: {}, fileName: {}", filePath, fileName);

			String satImageConvertServerUrl = ezCommonService.getTenantConfig("SATimageConvertServerURL", tenantId);
			String url = UriComponentsBuilder.fromHttpUrl(satImageConvertServerUrl)
					.queryParam("filepath", filePath)
					.queryParam("filename", fileName)
					.queryParam("fileext", file.getFileExt())
					.queryParam("viewerselect", "image")
					.queryParam("userid", userId)
					.build().encode().toString();

			result = Result.success(url);
		} catch (Exception ex) {
			logger.error(ex.getMessage(), ex);
			result = Result.failureWithCode(2);
		}

		logger.debug("G/W WEBFOLDER [GET {}] ended.", requestURI);

		return result;
	}

	@RequestMapping(value = "/rest/ezwebfolder/file/sat", method = RequestMethod.GET)
	@ResponseBody
	public void downloadFileFromSat(@RequestParam String key, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("G/W WEBFOLDER [GET {}] started.", request.getRequestURI());

		try {
			SatDownloadKey satKey = new SatDownloadKey(key);

			int tenantId = satKey.getTenantId();
			String fileId = satKey.getFileId();
			String filePath;

			if (satKey.hasVersion()) {
				int version = satKey.getVersion();
				filePath = Validate.notNull(ezWebFolderService.getFileHistory(fileId, version, Offset.KST, tenantId),
						"historyVO must not be null, fileId: %s, version: %d", fileId, version).getFilePath();
				logger.debug("specified version: {}", version);
			} else {
				// latest file
				filePath = Validate.notNull(ezWebFolderService.getFileByFileId(fileId, Offset.KST, tenantId),
						"fileVO must not be null, fileId: %s", fileId).getFilePath();
			}

			Path path = Paths.get(request.getServletContext().getRealPath(filePath));

			logger.debug("fileId: {}, filePath: {}", fileId, path);

			Validate.isTrue(Files.isRegularFile(path), "file not found");

			response.setBufferSize(2048);
			response.setHeader("Content-Length", Long.toString(Files.size(path)));

			Files.copy(path, response.getOutputStream());
		} catch (Exception ex) {
			if (!response.isCommitted()) {
				Map<String, Object> result = new HashMap<>();

				result.put("status", "error");
				result.put("data", "Invalid key or not found file");
				result.put("code", 2);

				String resultStr = JSONObject.toJSONString(result);

				response.setHeader("Content-Length", Integer.toString(resultStr.length()));
				response.getOutputStream().print(resultStr);
			}

			logger.error(ex.getMessage(), ex);
			logger.error("Invalid key or not found file. key: {}, exception: {}", key, ex);
		}

		logger.debug("G/W WEBFOLDER [GET {}] ended.", request.getRequestURI());
	}

	private <T> T orElse(T value, T other) {
		if (other == null) {
			throw new IllegalArgumentException("other is null!");
		}

		return value != null ? value : other;
	}

	private boolean containsNull(Object... elements) {
		for(Object e : elements) {
			if (e == null) {
				return true;
			}
			
			// string is ""
			if (e.toString().isEmpty()) {
				return true;
			}
		}
		
		return false;
	}

	private long parseLong(Object obj) {
		return Optional.ofNullable(obj)
				.map(Object::toString)
				.filter(str -> !str.isEmpty())
				.map(Long::parseLong)
				.orElse(0L);
	}

	// 2020-12-11 김은실 - (카이스트)회사 폴더별 관리자 지원 기능: 담당자 flag.
	@RequestMapping(value="/rest/ezwebfolder/check-folderManager/{userid:.+}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public Result checkFolderManager(@PathVariable(value = "userid") String userId, HttpServletRequest request, Locale locale) {
		logger.debug("checkFolderManager start");
		String serverName = request.getHeader("x-user-host");
		String folderId = request.getParameter("folderId");

		logger.debug("ServerName: {} || userId: {}", serverName, userId);

		if (containsNull(serverName, userId)) {
			logger.debug("Parameter error!");
			return Result.failure();
		}

		Result result;

		try {
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			List<String> managedFolderList = ezWebFolderAdminService.getFolderIdsByManagerUserId(userInfo.getId(), folderId, userInfo.getCompanyID(), userInfo.getTenantId());
			List<Map<String, String>> folderNameList = new ArrayList<>(managedFolderList.size());

			for (String folderIdTemp : managedFolderList) {
				FolderVO folderVOtemp = ezWebFolderService_y.getFolderDetail(folderIdTemp, userId, userInfo.getTenantId(), userInfo.getCompanyID());
				Map<String, String> map = new HashMap<>();
				map.put("folderId", folderVOtemp.getFolderId());
				map.put("folderName", "1".equals(userInfo.getPrimary()) ? changeString(folderVOtemp.getFolderName1()) : changeString(folderVOtemp.getFolderName2()));
				folderNameList.add(map);
			}

			if (managedFolderList.isEmpty()) {
				result = Result.failureWithCode(3);
				/*result.put("status", "ok");
				result.put("managedFolderList", managedFolderList);
				result.put("folderListMap", folderListMap);
				result.put("code", 0);
				result.put("data", "1");*/
			} else {
				result = Result.success(ChainMap.of("managedFolderList", managedFolderList).add("folderListMap", folderNameList));
				/*result.put("status", "error");
				result.put("code", 3);*/
			}
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result = Result.failureWithCode(2);
		}

		logger.debug("checkFolderManager end");
		return result;
	}
	
	private String changeString(String str){
		str = str.replaceAll("'", "&#39;");
		return str;
	}

	private class SatDownloadKey {

		private static final String SEPARATOR = "/";

		private final String fileId;
		private final Integer version;
		private final int tenantId;

		private SatDownloadKey(String fileId, Integer version, int tenantId) {
			this.fileId = fileId;
			this.version = version;
			this.tenantId = tenantId;
		}

		private SatDownloadKey(String encryptedKey) throws Exception {
			// fileId/tenantId/version(optional)
			String decryptedKey = egovFileScrty.decryptAES(encryptedKey);

			if (!decryptedKey.contains(SEPARATOR)) {
				throw new IllegalArgumentException("has no separator!");
			}

			logger.debug("new SatDownloadKey() decryptedKey: {}", decryptedKey);
			String[] data = decryptedKey.split(SEPARATOR);

			this.fileId = data[0];
			this.tenantId = Integer.parseInt(data[1]);
			this.version = data.length >= 3 ? Integer.parseInt(data[2]) : null;
		}

		public String getFileId() {
			return fileId;
		}

		public Integer getVersion() {
			return version;
		}

		public int getTenantId() {
			return tenantId;
		}

		public boolean hasVersion() {
			return version != null;
		}

		@Override
		public String toString() {
			try {
				return egovFileScrty.encryptAES(fileId + SEPARATOR + tenantId + (version == null ? "" : SEPARATOR + version));
			} catch (Exception e) {
				logger.error(e.getMessage(), e);
				return "";
			}
		}

	}

}
