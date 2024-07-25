package egovframework.ezEKP.ezCabinet.web;

import java.io.File;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Locale;
import java.util.stream.Collectors;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
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
import egovframework.ezEKP.ezCabinet.service.EzCabinetAdminService;
import egovframework.ezEKP.ezCabinet.service.EzCabinetService;
import egovframework.ezEKP.ezCabinet.vo.CabinetGeneralVO;
import egovframework.ezEKP.ezCabinet.vo.CabinetItemSimpleVO;
import egovframework.ezEKP.ezCabinet.vo.CabinetModuleVO;
import egovframework.ezEKP.ezCabinet.vo.CabinetSimpleVO;
import egovframework.ezEKP.ezCabinet.vo.CabinetVO;
import egovframework.ezEKP.ezCabinet.vo.CompanyCapacityVO;
import egovframework.ezEKP.ezCabinet.vo.SimpleDeptVO;
import egovframework.ezEKP.ezCabinet.vo.SimpleUserVO;
import egovframework.ezEKP.ezCabinet.vo.UserCapacityVO;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@SuppressWarnings("unchecked")
@RestController
public class EzCabinetGWController {
	private static final Logger logger = LoggerFactory.getLogger(EzCabinetGWController.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private EzOrganService organService;
	
	@Autowired
	private EzCabinetService cabinetService;
	
	@Autowired
	private EzCabinetAdminService cabinetAdminService;
	
	@Autowired
	private EzOrganAdminService organAdminService;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Resource(name="loginService")
	private LoginService loginService;
	
	@RequestMapping(value="/rest/ezcabinet/check-admin/{userid:.+}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject checkCabinetAdmin(@PathVariable(value="userid") String userId, HttpServletRequest request, Locale locale) {
		String serverName = request.getHeader("host-name") != null ? request.getHeader("host-name") : "";
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
			boolean check    = isCabinetAdmin(userInfo);
			
			if (check == true) {
				result.put("status", "ok");
				result.put("code", 0);
			}
			else {
				result.put("status", "error");
				result.put("code", 3);
			}
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezcabinet/company-list/{userid:.+}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getCompanyList(@PathVariable(value="userid") String userId, HttpServletRequest request, Locale locale) {
		String serverName = request.getHeader("host-name")   != null ? request.getHeader("host-name") : "";
		String mode       = request.getParameter("mode")     != null ? request.getParameter("mode")   : "";
		JSONObject result = new JSONObject();
		logger.debug("serverName: " + serverName + " || Mode: " + mode);
		
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
			
			if (userInfo.getRollInfo().indexOf("c=1")  > -1 && !mode.equals("normal")) {
				resultList = organAdminService.getCompanyList(userInfo.getPrimary(), userInfo.getTenantId());
			}
			else {
				OrganDeptVO dept = organService.getDeptInfo(userInfo.getCompanyID(), userInfo.getPrimary(), userInfo.getTenantId());
				resultList.add(dept);
			}
			
			result.put("data", resultList);
			result.put("userCompany", userInfo.getCompanyID());
			result.put("status", "ok");
			result.put("code", 0);
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezcabinet/company-tree/comp", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getCompanyTree(HttpServletRequest request) {
		String userId     = request.getParameter("userId")    != null ? request.getParameter("userId")    : "";
		String companyId  = request.getParameter("companyId") != null ? request.getParameter("companyId") : "";
		String deptId     = request.getParameter("deptId")    != null ? request.getParameter("deptId")    : "";
		String serverName = request.getHeader("host-name")    != null ? request.getHeader("host-name")    : "";
		JSONObject result = new JSONObject();
		
		if (userId.equals("") || serverName.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		logger.debug("Company Id: " + companyId + " || serverName: " + serverName + " || User Id: " + userId);
		
		try {
			LoginVO userInfo      = commonUtil.getUserForGw(userId, serverName);
			String primary        = userInfo.getPrimary();
			int tenantId          = userInfo.getTenantId();
			deptId                = deptId.equals("")    ? userInfo.getDeptID()    : deptId;
			companyId             = companyId.equals("") ? userInfo.getCompanyID() : companyId;
			SimpleDeptVO sCompany = new SimpleDeptVO();
			
			if (deptId.equals("")) {
				List<SimpleDeptVO> deptList = cabinetService.getAllSubDepts(companyId, 1, primary, tenantId);
				sCompany.setSubDepts(deptList);
			}
			else {
				String deptPath  = cabinetService.getDeptPath(deptId, tenantId);
				String[] path    = deptPath.split(",");
				sCompany         = cabinetService.getSimpleCompany(companyId, 0, primary, tenantId);
				
				cabinetService.getAllDepts(sCompany, path, primary, tenantId, 1, 1);
			}
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("tree", sCompany);
			result.put("node", deptId);
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezcabinet/sub-tree/{deptid:.+}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getSubTree(@PathVariable(value="deptid") String deptId, HttpServletRequest request) {
		String serverName = request.getHeader("host-name") != null ? request.getHeader("host-name")                  : "";
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
			LoginVO userInfo            = commonUtil.getUserForGw(userId, serverName);
			List<SimpleDeptVO> subDepts = cabinetService.getAllSubDepts(deptId, level + 1, userInfo.getPrimary(), userInfo.getTenantId());
			result.put("status", "ok");
			result.put("code", 0);
			result.put("subNodes", subDepts);
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezcabinetadmin/capcity/id/{companyid}/comp", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getBasicStorage(@PathVariable(value="companyid") String companyId, HttpServletRequest request) {
		String serverName = request.getHeader("host-name")   != null ? request.getHeader("host-name") : "";
		JSONObject result = new JSONObject();
		logger.debug("CompanyId: " + companyId + " || serverName: " + serverName);
		
		if (serverName.equals("") || companyId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			int tenantId                      = loginService.getTenantId(serverName);
			CompanyCapacityVO companyCapacity = cabinetAdminService.getCompanyCapacity(companyId, tenantId);
			result.put("status", "ok");
			result.put("code", 0);
			result.put("capacity", companyCapacity);
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezcabinetadmin/capcity/id/{companyid}/comp", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject putChangeBasicStorage(@PathVariable(value="companyid") String companyId, HttpServletRequest request) {
		String serverName  = request.getHeader("host-name")       != null ? request.getHeader("host-name")                         : "";
		String newValue    = request.getParameter("newCapacity")  != null ? request.getParameter("newCapacity")                    : "";
		int type           = request.getParameter("capacityType") != null ? Integer.parseInt(request.getParameter("capacityType")) : -1;
		JSONObject result  = new JSONObject();
		
		logger.debug("CapacityType: "+ type + "New Value: " + newValue + " || serverName: " + serverName + " || CompanyId: " + companyId);
		
		if (serverName.equals("") || companyId.equals("") || type == -1 || (type == 1 && newValue.equals(""))) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			int tenantId    = loginService.getTenantId(serverName);
			double newCapacity = 0;
			
			if (type == 1) {
				newCapacity = Double.parseDouble(newValue);
			}
			
			cabinetAdminService.saveCompanyCapacity(type, newCapacity, companyId, tenantId);
			result.put("status", "ok");
			result.put("code", 0);
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezcabinetadmin/capcity/id/{companyid}/person", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getUserCapacities(@PathVariable(value="companyid") String companyId, HttpServletRequest request) {
		String serverName = request.getHeader("host-name")    != null ? request.getHeader("host-name")                        : "";
		int currPage      = request.getParameter("currPage")  != null ? Integer.parseInt(request.getParameter("currPage"))    : 1;
		int listCnt       = request.getParameter("listCnt")   != null ? Integer.parseInt(request.getParameter("listCnt"))     : 10;
		String searchStr  = request.getParameter("searchStr") != null ? request.getParameter("searchStr")                     : "";
		String searchOpt  = request.getParameter("searchOpt") != null ? request.getParameter("searchOpt")                     : "";
		String userId     = request.getParameter("userId")    != null ? request.getParameter("userId")                        : "";
		String column     = request.getParameter("column")    != null ? request.getParameter("column")                        : "";
		String order      = request.getParameter("order")     != null ? request.getParameter("order")                         : "";
		JSONObject result = new JSONObject();
		int totalUsers    = 0;
		int totalPages    = 0;
		int startPoint    = (currPage - 1) * listCnt;
		String realColmn  = "";
		
		logger.debug("CompanyId: " + companyId + " || serverName: " + serverName + " || Current page: " + currPage + " || List count: " + listCnt + " || searchStr: " + searchStr + " || searchOpt: " + searchOpt + " || UserId: " + userId + " || Column: " + column + " || Order: " + order);
		
		if (serverName.equals("") || companyId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
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
					case "ct": realColmn = "CAPACITY_TP"     ; break;
					default  : realColmn = "COMPANY_NAME"    ; break;
				}
			}
			
			List<UserCapacityVO> list = cabinetAdminService.getListUserCapacity(realColmn, order, companyId, searchStr, searchOpt, startPoint, listCnt, tenantId, primary);
			totalUsers                = cabinetAdminService.getTotalListUserCapacity(companyId, searchStr, searchOpt, tenantId, primary);
			totalPages                = (totalUsers + listCnt - 1)/listCnt;
			
			for (UserCapacityVO capacity: list) {
				setUsedRateForUser(capacity);
			}
			
			result.put("capacity", list);
			result.put("code", 0);
			result.put("status", "ok");
			result.put("totalPages",  totalPages);
			result.put("totalUsers",  totalUsers);
			result.put("currentPage", currPage);
			
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezcabinetadmin/capcity/person", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject putChangePersonalStorage(@RequestParam("userList") List<String> userList, Locale locale, HttpServletRequest request) {
		String serverName = request.getHeader("host-name")       != null ? request.getHeader("host-name")    : "";
		String newValue   = request.getParameter("newCapacity")  != null ? request.getParameter("newCapacity")                    : "";
		String companyId  = request.getParameter("companyId")    != null ? request.getParameter("companyId")                      : "";
		int type          = request.getParameter("capacityType") != null ? Integer.parseInt(request.getParameter("capacityType")) : -1;
		JSONObject result = new JSONObject();
		
		logger.debug("CapacityType: "+ type + "New Value: " + newValue + " || serverName: " + serverName + " || CompanyId: " + companyId + " || User List: " + String.join(",", userList));
		
		if (serverName.equals("") || companyId.equals("") || type == -1 || (type == 1 && newValue.equals(""))) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			int tenantId    = loginService.getTenantId(serverName);
			double newCapacity = 0;
			
			if (type == 1) {
				newCapacity = Double.parseDouble(newValue);
			}
			
			cabinetAdminService.changeUserCapacity(userList, newCapacity, type, companyId, tenantId);
			
			result.put("status", "ok");
			result.put("code", 0);
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezcabinetadmin/defaultCapcity/person", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject putChangePersonalDefaultStorage(@RequestParam("userList") List<String> userList, Locale locale, HttpServletRequest request) {
		String serverName = request.getHeader("host-name")       != null ? request.getHeader("host-name")    : "";
		String companyId  = request.getParameter("companyId")    != null ? request.getParameter("companyId")                      : "";
		JSONObject result = new JSONObject();
		
		logger.debug("ServerName: " + serverName + " || CompanyId: " + companyId + " || User List: " + String.join(",", userList));
		
		if (serverName.equals("") || companyId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			int tenantId                      = loginService.getTenantId(serverName);
			cabinetAdminService.deleteUserCapacity(userList, companyId, tenantId);
			
			result.put("status", "ok");
			result.put("code", 0);
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezcabinetadmin/module/id/{companyid}/comp", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getModulesForAdmin(@PathVariable(value="companyid") String companyId, HttpServletRequest request) {
		String serverName = request.getHeader("host-name") != null ? request.getHeader("host-name") : "";
		JSONObject result = new JSONObject();
		
		logger.debug("CompanyId: " + companyId + " || serverName: " + serverName);
		
		if (serverName.equals("") || companyId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			int tenantId                  = loginService.getTenantId(serverName);
			List<CabinetModuleVO> modules = cabinetAdminService.getModuleListForAdmin(companyId, tenantId);
			Collections.sort(modules, (CabinetModuleVO module1, CabinetModuleVO module2) -> Integer.compare(module1.getOrderFromType(), module2.getOrderFromType()));
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("modules", modules);
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezcabinetadmin/module/id/{companyid}/comp", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject saveModulesSetting(@PathVariable(value="companyid") String companyId, HttpServletRequest request) {
		String serverName = request.getHeader("host-name")  != null ? request.getHeader("host-name")  : "";
		String moduleList = request.getParameter("modules") != null ? request.getParameter("modules") : "";
		JSONObject result = new JSONObject();
		JSONParser jp     = new JSONParser();
		
		logger.debug("CompanyId: " + companyId + " || serverName: " + serverName + " || moduleList: " + moduleList);
		
		if (serverName.equals("") || companyId.equals("") || moduleList.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			JSONArray modules = (JSONArray) jp.parse(moduleList);
			int tenantId      = loginService.getTenantId(serverName);
			cabinetAdminService.saveModulesSetting(modules, companyId, tenantId);
			result.put("status", "ok");
			result.put("code", 0);
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezcabinet/module/id/{userid:.+}/person", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getActiveModulesForUser(@PathVariable(value="userid") String userId, HttpServletRequest request) {
		String serverName = request.getHeader("host-name") != null ? request.getHeader("host-name") : "";
		JSONObject result = new JSONObject();
		
		logger.debug("userId: " + userId + " || serverName: " + serverName);
		
		if (serverName.equals("") || userId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo              = commonUtil.getUserForGw(userId, serverName);
			List<CabinetModuleVO> modules = cabinetService.getModuleListForUser(userInfo.getId(), userInfo.getCompanyID(), userInfo.getTenantId());
			Collections.sort(modules, (CabinetModuleVO module1, CabinetModuleVO module2) -> Integer.compare(module1.getOrderFromType(), module2.getOrderFromType()));
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("modules", modules);
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezcabinet/module/id/{userid:.+}/active-check", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject checkActiveModules(@PathVariable(value="userid") String userId, HttpServletRequest request) {
		String serverName = request.getHeader("host-name") != null ? request.getHeader("host-name") : "";
		String moduleType = request.getParameter("module") != null ? request.getParameter("module") : "";
		JSONObject result = new JSONObject();
		
		logger.debug("userId: " + userId + " || serverName: " + serverName + " || moduleType: " + moduleType);
		
		if (serverName.equals("") || userId.equals("") || moduleType.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo              = commonUtil.getUserForGw(userId, serverName);
			List<CabinetModuleVO> modules = cabinetService.getModuleListForUser(userInfo.getId(), userInfo.getCompanyID(), userInfo.getTenantId());
			List<CabinetModuleVO> actives = modules.stream().filter(module -> (module.getActiveStatus() == 1 && module.getModuleType().equals(moduleType))).collect(Collectors.toList());
			
			if (actives == null || actives.size() == 0) {
				result.put("active", "0");
			}
			else {
				result.put("active", "1");
			}
			
			result.put("status", "ok");
			result.put("code", 0);
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezcabinet/module/id/{userid:.+}/person", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject saveModulesSettingForUser(@PathVariable(value="userid") String userId, HttpServletRequest request) {
		String serverName = request.getHeader("host-name")  != null ? request.getHeader("host-name")  : "";
		String moduleList = request.getParameter("modules") != null ? request.getParameter("modules") : "";
		JSONObject result = new JSONObject();
		JSONParser jp     = new JSONParser();
		
		logger.debug("UserId: " + userId + " || serverName: " + serverName + " || moduleList: " + moduleList);
		
		if (serverName.equals("") || userId.equals("") || moduleList.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			JSONArray modules = (JSONArray) jp.parse(moduleList);
			LoginVO userInfo  = commonUtil.getUserForGw(userId, serverName);
			cabinetService.saveModulesSetting(modules, userInfo.getId(), userInfo.getCompanyID(), userInfo.getTenantId());
			result.put("status", "ok");
			result.put("code", 0);
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezcabinet/capacity/{userid:.+}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getUserCapacity(@PathVariable(value="userid") String userId, HttpServletRequest request) {
		String serverName = request.getHeader("host-name") != null ? request.getHeader("host-name") : "";
		JSONObject result = new JSONObject();
		
		logger.debug("UserId: " + userId + " || serverName: " + serverName);
		
		if (serverName.equals("") || userId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo            = commonUtil.getUserForGw(userId, serverName);
			UserCapacityVO userCapacity = cabinetAdminService.getUserCapacity(userId, userInfo.getCompanyID(), userInfo.getPrimary(), userInfo.getTenantId());
			setUsedRateForUser(userCapacity);
			
			result.put("capacity", userCapacity);
			result.put("status", "ok");
			result.put("code", 0);
		} 
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezcabinet/config/id/{userid:.+}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getUserPreviewConfig(@PathVariable(value="userid") String userId, HttpServletRequest request) {
		String serverName = request.getHeader("host-name") != null ? request.getHeader("host-name") : "";
		JSONObject result = new JSONObject();
		
		logger.debug("UserId: " + userId + " || serverName: " + serverName);
		
		if (serverName.equals("") || userId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo            = commonUtil.getUserForGw(userId, serverName);
			int tenantId                = userInfo.getTenantId();
			String companyId            = userInfo.getCompanyID();
			CabinetGeneralVO userConfig = cabinetService.getUserPreviewConfig(userId, userInfo.getCompanyID(), userInfo.getTenantId());
			
			if (userConfig == null) {
				userConfig = new CabinetGeneralVO(userId, companyId, "off", 10, 50, 50, 50, 50, tenantId);
			}
			else {
				userConfig.setPreviewHpercent(100 - userConfig.getContentHpercent());
				userConfig.setPreviewWpercent(100 - userConfig.getContentWpercent());
			}
			
			result.put("config", userConfig);
			result.put("status", "ok");
			result.put("code", 0);
		} 
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezcabinet/config/id/{userid:.+}", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject saveUserConfig(@PathVariable(value="userid") String userId, HttpServletRequest request) {
		String serverName    = request.getHeader("host-name")    != null ? request.getHeader("host-name")    : "";
		String prevMode      = request.getParameter("prevMode")  != null ? request.getParameter("prevMode")  : "";
		int listCount        = request.getParameter("listCount") != null ? Integer.parseInt(request.getParameter("listCount")) : -1;
		int contentWPrev     = request.getParameter("contentW")  != null ? Integer.parseInt(request.getParameter("contentW"))  : -1;
		int contentHPrev     = request.getParameter("contentH")  != null ? Integer.parseInt(request.getParameter("contentH"))  : -1;
		JSONObject result    = new JSONObject();
		
		logger.debug("UserId: " + userId + " || serverName: " + serverName + " || Preview Mode: " + prevMode + " || List count: " + listCount + " || ContentHPreview: " + contentHPrev + " || ContentWPreview: " + contentWPrev);
		
		if (serverName.equals("") || userId.equals("") || listCount == -1 || prevMode.equals("") || (!prevMode.equals("off") && (contentWPrev == -1 || contentHPrev == -1))) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		if (prevMode.equals("off")) {
			contentWPrev = 50;
			contentHPrev = 50;
		}
		
		try {
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			cabinetService.saveUserConfig(prevMode, listCount, contentWPrev, contentHPrev, userId, userInfo.getCompanyID(), userInfo.getTenantId());
			
			result.put("status", "ok");
			result.put("code", 0);
		} 
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezcabinet/mycabinet/id/{userid:.+}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getMyCabinet(@PathVariable(value="userid") String userId, HttpServletRequest request, Locale locale) {
		String serverName = request.getHeader("host-name")    != null ? request.getHeader("host-name")    : "";
		String cabinetId  = request.getParameter("cabinetId") != null ? request.getParameter("cabinetId") : "";
		JSONObject result = new JSONObject();
		
		logger.debug("UserId: " + userId + " || serverName: " + serverName + " || CabinetId: " + cabinetId);
		
		if (serverName.equals("") || userId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo          = commonUtil.getUserForGw(userId, serverName);
			CabinetSimpleVO mycabinet = null;
					
			if (cabinetId.equals("") || cabinetId.equals("root")) {
				mycabinet = cabinetService.getMyCabinetTreeNormal(userInfo);
				
				if (cabinetId.equals("root")) {
					result.put("node", mycabinet.getCabinetId());
				}
			}
			else {
				mycabinet = cabinetService.getMyCabinetTreeDetail(cabinetId, userInfo);
				result.put("node", cabinetId);
			}
			
			result.put("tree", mycabinet);
			result.put("status", "ok");
			result.put("code", 0);
		} 
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezcabinet/allcabinet/id/{userid:.+}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getAllCabinetTree(@PathVariable(value="userid") String userId, HttpServletRequest request, Locale locale) {
		String serverName = request.getHeader("host-name")    != null ? request.getHeader("host-name")    : "";
		String cabinetId  = request.getParameter("cabinetId") != null ? request.getParameter("cabinetId") : "";
		JSONObject result = new JSONObject();
		
		logger.debug("UserId: " + userId + " || serverName: " + serverName + " || CabinetId: " + cabinetId);
		
		if (serverName.equals("") || userId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo                  = commonUtil.getUserForGw(userId, serverName);
			CabinetSimpleVO mycabinet         = cabinetService.getMyCabinetTreeNormal(userInfo);       //Process my cabinet
			List<CabinetSimpleVO> relatedList = cabinetService.getRelatedCabinetListForUser(userInfo); //Process related cabinet list
			relatedList.add(0, mycabinet);
			
			result.put("tree", relatedList);
			result.put("status", "ok");
			result.put("code", 0);
		} 
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezcabinet/relatedcabinet/id/{userid:.+}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getRelatedCabinetTree(@PathVariable(value="userid") String userId, HttpServletRequest request, Locale locale) {
		String serverName = request.getHeader("host-name") != null ? request.getHeader("host-name") : "";
		String mode       = request.getParameter("mode")   != null ? request.getParameter("mode")   : "";
		JSONObject result = new JSONObject();
		
		logger.debug("UserId: " + userId + " || serverName: " + serverName + " || Mode: " + mode);
		
		if (serverName.equals("") || userId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo                  = commonUtil.getUserForGw(userId, serverName);
			List<CabinetSimpleVO> relatedList = cabinetService.getRelatedCabinetListForUser(userInfo);
			
			if (relatedList.size() == 0) {
				result.put("status", "error");
				result.put("code", 4);
				return result;
			}
			
			if (!mode.equals("1")) {
				result.put("node", relatedList.get(0).getCabinetId());
			}
			
			result.put("tree", relatedList);
			result.put("status", "ok");
			result.put("code", 0);
		} 
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezcabinet/sharedcabinet/id/{userid:.+}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getSharedCabinetTree(@PathVariable(value="userid") String userId, HttpServletRequest request, Locale locale) {
		String serverName = request.getHeader("host-name") != null ? request.getHeader("host-name") : "";
		JSONObject result = new JSONObject();
		
		logger.debug("UserId: " + userId + " || serverName: " + serverName);
		
		if (serverName.equals("") || userId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo              = commonUtil.getUserForGw(userId, serverName);
			List<SimpleUserVO> sharedList = cabinetService.getSharedUserList(userInfo);
			
			if (sharedList.size() == 0) {
				result.put("status", "error");
				result.put("code", 5);
				return result;
			}
			
			List<CabinetSimpleVO> cabinetList = cabinetService.getUserSharedCabinet(sharedList.get(0).getUserId(), userInfo);
			
			sharedList.get(0).setSharedCabinet(cabinetList);
			result.put("tree", sharedList);
			result.put("status", "ok");
			result.put("code", 0);
		} 
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezcabinet/myshare/id/{userid:.+}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getMyShareCabinetTree(@PathVariable(value="userid") String userId, HttpServletRequest request, Locale locale) {
		String serverName  = request.getHeader("host-name")      != null ? request.getHeader("host-name")      : "";
		String currentNode = request.getParameter("currentNode") != null ? request.getParameter("currentNode") : "";
		JSONObject result  = new JSONObject();
		
		logger.debug("UserId: " + userId + " || serverName: " + serverName);
		
		if (serverName.equals("") || userId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo                  = commonUtil.getUserForGw(userId, serverName);
			List<CabinetSimpleVO> cabinetList = cabinetService.getMyShareCabinet(userInfo);
			
			if (cabinetList != null && cabinetList.size() > 0) {
				if (!currentNode.equals("")) {
					List<String> listCabinetIds = cabinetList.stream().map(cab -> Integer.toString(cab.getCabinetId())).collect(Collectors.toList());
					if (listCabinetIds.contains(currentNode)) {
						result.put("node", currentNode);
					}
					else {
						result.put("node", cabinetList.get(0).getCabinetId());
					}
				}
				else {
					result.put("node", cabinetList.get(0).getCabinetId());
				}
			}
			
			result.put("tree", cabinetList);
			result.put("status", "ok");
			result.put("code", 0);
		} 
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezcabinet/sharedcabinet/shareid/{shareid:.+}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getUserSharedCabinet(@PathVariable(value="shareid") String shareId, HttpServletRequest request, Locale locale) {
		String serverName = request.getHeader("host-name") != null ? request.getHeader("host-name") : "";
		String userId     = request.getParameter("userId") != null ? request.getParameter("userId") : "";
		JSONObject result = new JSONObject();
		
		logger.debug("UserId: " + userId + " || serverName: " + serverName + " || Share Id: " + shareId);
		
		if (serverName.equals("") || userId.equals("") || shareId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo                 = commonUtil.getUserForGw(userId, serverName);
			List<CabinetSimpleVO> sharedList = cabinetService.getUserSharedCabinet(shareId, userInfo);
			
			result.put("subNodes", sharedList);
			result.put("status", "ok");
			result.put("code", 0);
		} 
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezcabinet/cabinet/add", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject addCabinet(HttpServletRequest request) {
		String serverName = request.getHeader("host-name")   != null ? request.getHeader("host-name")                     : "";
		String userId     = request.getParameter("userId")   != null ? request.getParameter("userId")                     : "";
		String cabName1   = request.getParameter("cabName1") != null ? request.getParameter("cabName1")                   : "";
		int parentId      = request.getParameter("parentId") != null ? Integer.parseInt(request.getParameter("parentId")) : -1;
		
		JSONObject result = new JSONObject();
		
		logger.debug("UserId: " + userId + " || serverName: " + serverName + " || Parent Id: " + parentId + " || Cabinet name1: " + cabName1);
		
		if (serverName.equals("") || userId.equals("") || parentId == -1 || cabName1.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			
			//Add checking permission here
			List<Integer> cabinetList = new ArrayList<>(Arrays.asList(parentId));
			JSONObject permission = cabinetService.checkPermission(cabinetList, new ArrayList<>(), 1, userInfo);
			
			if ((int)permission.get("code") == 1) {
				result.put("status", "error");
				result.put("code", 3);
				return result;
			}
			
			cabinetService.addCabinet(parentId, cabName1, userInfo);
			
			result.put("status", "ok");
			result.put("code", 0);
		} 
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezcabinet/cabinet/rename", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject renameCabinet(HttpServletRequest request) {
		String serverName = request.getHeader("host-name")    != null ? request.getHeader("host-name")                      : "";
		String userId     = request.getParameter("userId")    != null ? request.getParameter("userId")                      : "";
		String cabName1   = request.getParameter("cabName1")  != null ? request.getParameter("cabName1")                    : "";
		int cabinetId     = request.getParameter("cabinetId") != null ? Integer.parseInt(request.getParameter("cabinetId")) : -1;
		
		JSONObject result = new JSONObject();
		
		logger.debug("UserId: " + userId + " || serverName: " + serverName + " || Cabinet Id: " + cabinetId + " || Cabinet name1: " + cabName1);
		
		if (serverName.equals("") || userId.equals("") || cabinetId == -1 || cabName1.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			
			//Add checking permission here
			List<Integer> cabinetList = new ArrayList<>(Arrays.asList(cabinetId));
			JSONObject permission = cabinetService.checkPermission(cabinetList, new ArrayList<>(), 1, userInfo);
			
			if ((int)permission.get("code") == 1) {
				result.put("status", "error");
				result.put("code", 3);
				return result;
			}
			
			result = cabinetService.renameCabinet(cabinetId, cabName1, userInfo);
		} 
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezcabinet/cabinet/delete", method= RequestMethod.DELETE, produces="application/json;charset=utf-8")
	public JSONObject deleteCabinet(HttpServletRequest request) {
		String serverName = request.getHeader("host-name")    != null ? request.getHeader("host-name")                      : "";
		String userId     = request.getParameter("userId")    != null ? request.getParameter("userId")                      : "";
		int cabinetId     = request.getParameter("cabinetId") != null ? Integer.parseInt(request.getParameter("cabinetId")) : -1;
		
		JSONObject result = new JSONObject();
		
		logger.debug("UserId: " + userId + " || serverName: " + serverName + " || Cabinet Id: " + cabinetId);
		
		if (serverName.equals("") || userId.equals("") || cabinetId == -1) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			
			//Add checking permission here
			List<Integer> cabinetList = new ArrayList<>(Arrays.asList(cabinetId));
			JSONObject permission = cabinetService.checkPermission(cabinetList, new ArrayList<>(), 1, userInfo);
			
			if ((int)permission.get("code") == 1) {
				result.put("status", "error");
				result.put("code", 3);
				return result;
			}
			
			result = cabinetService.deleteCabinet(cabinetId, userInfo);
		} 
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezcabinet/cabinet-move/mode/{mode:.+}", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject putCabinetMove(@PathVariable(value="mode") String mode, Locale locale, HttpServletRequest request) throws Exception {
		String userId     = request.getParameter("userId")    != null ? request.getParameter("userId")                      : "";
		String serverName = request.getHeader("host-name")    != null ? request.getHeader("host-name")                      : "";
		int cabinetId     = request.getParameter("cabinetId") != null ? Integer.parseInt(request.getParameter("cabinetId")) : -1;
		int parentId      = request.getParameter("parentId")  != null ? Integer.parseInt(request.getParameter("parentId"))  : -1;
		JSONObject result = new JSONObject();
		
		logger.debug("UserId: " + userId + " || serverName: " + serverName + " || Cabinet Id: " + cabinetId + " || Parent Id: " + parentId + " || Mode: " + mode);
		
		if (cabinetId == -1 || mode.equals("") || serverName.equals("") || userId.equals("") || parentId == -1) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("reason", egovMessageSource.getMessage("ezWebFolder.t244", locale));
			result.put("code", "1");
			return result;
		}
		
		try {
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			
			//Add checking permission here
			List<Integer> cabinetList = new ArrayList<>(Arrays.asList(cabinetId, parentId));
			JSONObject permission = cabinetService.checkPermission(cabinetList, new ArrayList<>(), 1, userInfo);
			
			if ((int)permission.get("code") == 1) {
				result.put("status", "error");
				result.put("code", 3);
				return result;
			}
			
			String realPath = request.getServletContext().getRealPath("");
			result          = cabinetService.moveCabinet(cabinetId, parentId, mode, realPath, userInfo);
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezcabinet/cabinet/id/{cabinetid}/sub-node", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getCabinetSubNodes(@PathVariable(value="cabinetid") String cabinetId, HttpServletRequest request) {
		String serverName = request.getHeader("host-name")   != null ? request.getHeader("host-name") : "";
		String userId     = request.getParameter("userId")   != null ? request.getParameter("userId") : "";
		
		JSONObject result = new JSONObject();
		
		logger.debug("UserId: " + userId + " || serverName: " + serverName + " Cabinet Id: " + cabinetId);
		
		if (serverName.equals("") || userId.equals("") || cabinetId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo               = commonUtil.getUserForGw(userId, serverName);
			List<CabinetSimpleVO> nodeList = cabinetService.getCabinetSubTree(cabinetId, userInfo);
			
			result.put("subNodes", nodeList);
			result.put("status", "ok");
			result.put("code", 0);
		} 
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezcabinet/attachfile/file-upload", method= RequestMethod.POST, produces="application/json;charset=utf-8")
	public JSONObject postFileUploadGW(@RequestParam("data") String dataList, @RequestParam("files") List<MultipartFile> multiFileLists, Locale locale, HttpServletRequest request) throws Exception {
		JSONParser jp          = new JSONParser();
		JSONObject jsonObject  = (JSONObject) jp.parse(dataList);
		JSONArray nameArray    = jsonObject.get("nameArray")    != null ? (JSONArray) jsonObject.get("nameArray") : null;
		String serverName      = request.getHeader("host-name") != null ? request.getHeader("host-name")          : "";
		JSONObject result      = new JSONObject();
		
		logger.debug("serverName: " + serverName);
		
		if (nameArray == null || serverName.equals("") || nameArray.size() != multiFileLists.size() || multiFileLists.size() != 1) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			int tenantId    = loginService.getTenantId(serverName);
			String realPath = request.getServletContext().getRealPath("");
			String filePath = cabinetService.saveUploadFile(multiFileLists, nameArray, realPath, tenantId);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("path", filePath);
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value = "/rest/ezcabinet/attachfile/file-download", method=RequestMethod.GET, produces = { MediaType.APPLICATION_OCTET_STREAM_VALUE})
	public void getFileDownload(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String filePath   = request.getParameter("filePath")   != null ? request.getParameter("filePath")  : "";
		String fileName   = request.getParameter("fileName")   != null ? request.getParameter("fileName")  : "";
		String userId     = request.getParameter("userId")     != null ? request.getParameter("userId")    : "";
		String serverName = request.getHeader("host-name")     != null ? request.getHeader("host-name")    : "";
		String userAgent  = request.getParameter("userAgent")  != null ? request.getParameter("userAgent") : "";
		
		logger.debug("serverName: " + serverName + " ||  filePath: " + filePath + " || UserId: " + userId + " || File Name: " + fileName);
		
		if (filePath.equals("") || fileName.equals("") || serverName.equals("") || userId.equals("")) {
			logger.debug("Invalid arguments!!!!!!");
			return;
		}
		
		//Get absolute path of the application
		String realPath  = request.getServletContext().getRealPath("");
		LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
		
		cabinetService.getDownloadedFile(fileName, filePath, realPath, userInfo, userAgent, request, response);
		
		logger.debug("File Download Finish!");
		return;
	}
	
	@RequestMapping(value="/rest/ezcabinet/attachfile/file-delete", method= RequestMethod.DELETE, produces="application/json;charset=utf-8")
	public JSONObject delFileUploadGW(Locale locale, HttpServletRequest request) throws Exception {
		String serverName = request.getHeader("host-name")   != null ? request.getHeader("host-name")   : "";
		String filePath   = request.getParameter("filePath") != null ? request.getParameter("filePath") : "";
		JSONObject result = new JSONObject();
		
		logger.debug("ServerName: " + serverName + " filePath: " + filePath);
		
		if (serverName.equals("") || filePath.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			int tenantId      = loginService.getTenantId(serverName);
			String realPath   = request.getServletContext().getRealPath("");
			cabinetService.deleteAttachFile(filePath, realPath, tenantId);
			
			result.put("status", "ok");
			result.put("code", 0);
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezcabinet/item/id/{cabinetid}/add", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject saveItem(@RequestBody JSONObject itemInf, @PathVariable(value="cabinetid") String cabinetId, Locale locale, HttpServletRequest request) throws Exception {
		String serverName = request.getHeader("host-name") != null ? request.getHeader("host-name")       : "";
		String title      = itemInf.get("title")           != null ? itemInf.get("title").toString()      : "";
		String summary    = itemInf.get("summary")         != null ? itemInf.get("summary").toString()    : "";
		String fileArray  = itemInf.get("fileArray")       != null ? itemInf.get("fileArray").toString()  : "";
		String relatedArr = itemInf.get("relatedArr")      != null ? itemInf.get("relatedArr").toString() : "";
		String userId     = itemInf.get("userId")          != null ? itemInf.get("userId").toString()     : "";
		JSONObject result = new JSONObject();
		JSONParser jp     = new JSONParser();
		
		logger.debug("ServerName: " + serverName + " || title: " + title + " || summary: " + summary + " || userId: " + userId + " || fileArray: " + fileArray + " || relatedArr: " + relatedArr);
		
		if (serverName.equals("") || title.equals("") || userId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo          = commonUtil.getUserForGw(userId, serverName);
			//Add checking permission here
			List<Integer> cabinetList = new ArrayList<>(Arrays.asList(Integer.parseInt(cabinetId)));
			JSONObject permission     = cabinetService.checkPermission(cabinetList, new ArrayList<>(), 1, userInfo);
			
			if ((int)permission.get("code") == 1) {
				result.put("status", "error");
				result.put("code", 3);
				return result;
			}
			
			JSONArray attacheFiles  = (JSONArray) jp.parse(fileArray);
			JSONArray relatedFiles  = (JSONArray) jp.parse(relatedArr);
			String realPath         = request.getServletContext().getRealPath("");
			UserCapacityVO capacity = cabinetAdminService.getUserCapacity(userId, userInfo.getCompanyID(), userInfo.getPrimary(), userInfo.getTenantId());
			
			if (capacity.getCapacityType() == 1) {
				//Check save condition
				long totalAttachSize = 0;
				
				if (attacheFiles.size() > 0) {
					for (int i = 0; i < attacheFiles.size(); i++) {
						JSONObject fileObj = (JSONObject)attacheFiles.get(i);
						String filePath    = (String)fileObj.get("path");
						File file          = new File(realPath + commonUtil.detectPathTraversal(filePath));
						totalAttachSize    = totalAttachSize + file.length();
					}
				}
				
				long totalUsed = Long.parseLong(capacity.getTotalUsed());
				long totalCap  = capacity.getTotalCapacity() * 1048576;
				
				if (totalAttachSize > (totalCap - totalUsed)) {
					logger.debug("Not enough storage to upload these files!");
					result.put("status", "error");
					result.put("code", 4);
					return result;
				}
			}
			
			cabinetService.saveItem(Integer.parseInt(cabinetId), attacheFiles, relatedFiles, title, summary, realPath, userInfo);
			
			result.put("status", "ok");
			result.put("code", 0);
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezcabinet/item/delete", method= RequestMethod.DELETE, produces="application/json;charset=utf-8")
	public JSONObject deleteItems(@RequestParam(value = "itemList") List<String> itemList, Locale locale, HttpServletRequest request) throws Exception {
		String serverName = request.getHeader("host-name")     != null ? request.getHeader("host-name")     : "";
		String userId     = request.getParameter("userId")     != null ? request.getParameter("userId")     : "";
		JSONObject result = new JSONObject();
		
		logger.debug("ServerName: " + serverName + " ||  userId: " + userId + " || itemList: " + String.join(",", itemList));
		
		if (serverName.equals("") || itemList.size() == 0 || userId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo          = commonUtil.getUserForGw(userId, serverName);
			List<Integer> itemIdList  = itemList.stream().map(Integer::parseInt).collect(Collectors.toList());
			
			//Add checking permission here
			JSONObject permission     = cabinetService.checkPermission(new ArrayList<>(), itemIdList, 1, userInfo);
			
			if ((int)permission.get("code") == 1) {
				result.put("status", "error");
				result.put("code", 3);
				return result;
			}
			
			cabinetService.deleteItems(itemIdList, userInfo);
			
			result.put("status", "ok");
			result.put("code", 0);
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezcabinet/item-move/mode/{mode:.+}", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject moveItems(@PathVariable(value="mode") String mode, @RequestParam(value = "itemList") List<String> itemList, Locale locale, HttpServletRequest request) throws Exception {
		String serverName = request.getHeader("host-name")     != null ? request.getHeader("host-name")     : "";
		String userId     = request.getParameter("userId")     != null ? request.getParameter("userId")     : "";
		int cabinetId     = request.getParameter("cabinetId") != null ? Integer.parseInt(request.getParameter("cabinetId")) : -1;
		JSONObject result = new JSONObject();
		
		logger.debug("UserId: " + userId + " || serverName: " + serverName + " || Cabinet Id: " + cabinetId + " || Mode: " + mode + " || itemList: " + String.join(",", itemList));
		
		if (cabinetId == -1 || mode.equals("") || serverName.equals("") || userId.equals("") || itemList.size() == 0) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("reason", egovMessageSource.getMessage("ezWebFolder.t244", locale));
			result.put("code", "1");
			return result;
		}
		
		try {
			LoginVO userInfo          = commonUtil.getUserForGw(userId, serverName);
			List<Integer> itemIdList  = itemList.stream().map(Integer::parseInt).collect(Collectors.toList());
			List<Integer> cabinetList = new ArrayList<>(Arrays.asList(cabinetId));
			
			//Add checking permission here
			JSONObject permission     = cabinetService.checkPermission(cabinetList, itemIdList, 1, userInfo);
			
			if ((int)permission.get("code") == 1) {
				result.put("status", "error");
				result.put("code", 3);
				return result;
			}
			
			String realPath = request.getServletContext().getRealPath("");
			result          = cabinetService.moveItems(realPath, cabinetId, mode, itemIdList, userInfo);
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezcabinet/item/id/{cabinetid}/get", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getItems(@PathVariable(value="cabinetid") String cabinetId, Locale locale, HttpServletRequest request) throws Exception {
		String serverName    = request.getHeader("host-name")      != null ? request.getHeader("host-name")                        : "";
		String userId        = request.getParameter("userId")      != null ? request.getParameter("userId")                        : "";
		String title         = request.getParameter("title")       != null ? request.getParameter("title")                         : "";
		String summary       = request.getParameter("summary")     != null ? request.getParameter("summary")                       : "";
		String recursive     = request.getParameter("recursive")   != null ? request.getParameter("recursive")                     : "";
		String creatorName   = request.getParameter("creatorName") != null ? request.getParameter("creatorName")                   : "";
		String startDate     = request.getParameter("startDate")   != null ? request.getParameter("startDate")                     : "";
		String endDate       = request.getParameter("endDate")     != null ? request.getParameter("endDate")                       : "";
		String column        = request.getParameter("column")      != null ? request.getParameter("column")                        : "";
		String order         = request.getParameter("order")       != null ? request.getParameter("order")                         : "";
		String srchMode      = request.getParameter("srchMode")    != null ? request.getParameter("srchMode")                      : "";
		String srchOption    = request.getParameter("srchOption")  != null ? request.getParameter("srchOption")                    : "";
		int listCntSize      = request.getParameter("listCntSize") != null ? Integer.parseInt(request.getParameter("listCntSize")) : -1;
		int currentPage      = request.getParameter("currentPage") != null ? Integer.parseInt(request.getParameter("currentPage")) : -1;
		String sqlQuery      = "";
		JSONObject result    = new JSONObject();
		
		logger.debug("CabinetId: " + cabinetId + " || Title: " + title + " || Summary: " + summary + " || Recursive: " + recursive + " || Creator name: " + creatorName + " || Start Date: " + startDate + " || End Date: " + endDate + " || Column: " + column + " || Order: " + order + " || Search mode: " + srchMode + " || Search option: " + srchOption + " || List count: " + listCntSize);
		
		if (serverName.equals("") || cabinetId.equals("") || userId.equals("") || currentPage < 1 || listCntSize < 1) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo          = commonUtil.getUserForGw(userId, serverName);
			//Add checking permission here
			List<Integer> cabinetList = new ArrayList<>(Arrays.asList(Integer.parseInt(cabinetId)));
			JSONObject permission     = cabinetService.checkPermission(cabinetList, new ArrayList<>(), 0, userInfo);
			
			if ((int)permission.get("code") == 1) {
				result.put("status", "error");
				result.put("code", 3);
				return result;
			}
			
			result = cabinetService.getItemsBySearching(cabinetId, currentPage, listCntSize, title, summary, creatorName, startDate, endDate, sqlQuery, srchMode, srchOption, order, column, recursive, userInfo);
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezcabinet/cabinet/id/{cabinetid:.+}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getCabinetInfo(@PathVariable(value="cabinetid") String cabinetId, Locale locale, HttpServletRequest request) throws Exception {
		String serverName = request.getHeader("host-name")     != null ? request.getHeader("host-name")     : "";
		String userId     = request.getParameter("userId")     != null ? request.getParameter("userId")     : "";
		JSONObject result = new JSONObject();
		
		if (serverName.equals("") || userId.equals("") || cabinetId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo          = commonUtil.getUserForGw(userId, serverName);
			//Add checking permission here
			List<Integer> cabinetList = new ArrayList<>(Arrays.asList(Integer.parseInt(cabinetId)));
			JSONObject permission     = cabinetService.checkPermission(cabinetList, new ArrayList<>(), 0, userInfo);
			
			if ((int)permission.get("code") == 1) {
				result.put("status", "error");
				result.put("code", 3);
				return result;
			}
			
			CabinetVO cabinet = cabinetService.getCabinetById(cabinetId, userInfo.getTenantId());
			cabinet.setCabinetName(cabinet.getCabinetName1());
			cabinet.setPermission(2);
			
			result.put("cabinet", cabinet);
			result.put("status", "ok");
			result.put("code", 0);
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezcabinet/share-cabinet/id/{cabinetid:.+}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getShareCabinetInfo(@PathVariable(value="cabinetid") String cabinetId, Locale locale, HttpServletRequest request) throws Exception {
		String serverName = request.getHeader("host-name")     != null ? request.getHeader("host-name")     : "";
		String userId     = request.getParameter("userId")     != null ? request.getParameter("userId")     : "";
		JSONObject result = new JSONObject();
		
		logger.debug("UserId: " + userId + " || Host name: " + serverName);
		
		if (serverName.equals("") || userId.equals("") || cabinetId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo          = commonUtil.getUserForGw(userId, serverName);
			//Add checking permission here
			List<Integer> cabinetList = new ArrayList<>(Arrays.asList(Integer.parseInt(cabinetId)));
			JSONObject permission     = cabinetService.checkPermission(cabinetList, new ArrayList<>(), 0, userInfo);
			
			if ((int)permission.get("code") == 1) {
				result.put("status", "error");
				result.put("code", 3);
				return result;
			}
			
			result = cabinetService.getSharedCabinetInfo(cabinetId, userInfo);
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezcabinet/relate-item/id/{cabinetid}/get", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getFiles(@PathVariable(value="cabinetid") String cabinetId, Locale locale, HttpServletRequest request) throws Exception {
		String serverName = request.getHeader("host-name")      != null ? request.getHeader("host-name")                        : "";
		String userId     = request.getParameter("userId")      != null ? request.getParameter("userId")                        : "";
		int currentPage   = request.getParameter("currentPage") != null ? Integer.parseInt(request.getParameter("currentPage")) : -1;
		JSONObject result = new JSONObject();
		
		logger.debug("CabinetId: " + cabinetId + " || Server name: " + serverName + " User Id: " + userId + " || Current page: " + currentPage);
		
		if (serverName.equals("") || cabinetId.equals("") || userId.equals("") || currentPage == -1) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo          = commonUtil.getUserForGw(userId, serverName);
			//Add checking permission here
			List<Integer> cabinetList = new ArrayList<>(Arrays.asList(Integer.parseInt(cabinetId)));
			JSONObject permission     = cabinetService.checkPermission(cabinetList, new ArrayList<>(), 1, userInfo);
			
			if ((int)permission.get("code") == 1) {
				result.put("status", "error");
				result.put("code", 3);
				return result;
			}
			
			int startPoint                     = (currentPage - 1) * 50;
			int totalItems                     = cabinetService.getTotalFiles(cabinetId, userInfo.getTenantId());
			int totalPages                     = (totalItems + 49) / 50;
			List<CabinetItemSimpleVO> itemList = cabinetService.getCabinetFiles(cabinetId, startPoint, 50, userInfo.getTenantId());
			
			result.put("totalPages",  totalPages);
			result.put("totalRows",   totalItems);
			result.put("currentPage", currentPage);
			result.put("itemList",    itemList);
			result.put("status", "ok");
			result.put("code", 0);
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezcabinet/relate-item/search", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getFilesBySearching(Locale locale, HttpServletRequest request) throws Exception {
		String serverName    = request.getHeader("host-name")      != null ? request.getHeader("host-name")                        : "";
		String userId        = request.getParameter("userId")      != null ? request.getParameter("userId")                        : "";
		String itemTitle     = request.getParameter("title")       != null ? request.getParameter("title")                         : "";
		int currentPage      = request.getParameter("currentPage") != null ? Integer.parseInt(request.getParameter("currentPage")) : -1;
		JSONObject result    = new JSONObject();
		
		logger.debug("itemTitle: " + itemTitle + " || Server name: " + serverName + " User Id: " + userId + " || Current page: " + currentPage);
		
		if (serverName.equals("") || userId.equals("") || currentPage == -1) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo                   = commonUtil.getUserForGw(userId, serverName);
			int startPoint                     = (currentPage - 1) * 50;
			int totalItems                     = cabinetService.getTotalFilesByTitle(itemTitle, userInfo.getId(), userInfo.getTenantId());
			int totalPages                     = (totalItems + 49) / 50;
			List<CabinetItemSimpleVO> itemList = cabinetService.getFilesByTitle(itemTitle, startPoint, 50, userInfo.getId(), userInfo.getTenantId());
			
			result.put("totalPages",  totalPages);
			result.put("totalRows",   totalItems);
			result.put("currentPage", currentPage);
			result.put("itemList", itemList);
			result.put("status", "ok");
			result.put("code", 0);
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezcabinet/relate-item/save/email", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject saveEmailItem(@RequestBody JSONObject emailItemInf, Locale locale, HttpServletRequest request) throws Exception {
		String serverName = request.getHeader("host-name") != null ? request.getHeader("host-name")          : "";
		String title      = emailItemInf.get("title")      != null ? emailItemInf.get("title").toString()    : "";
		String summary    = emailItemInf.get("summary")    != null ? emailItemInf.get("summary").toString()  : "";
		String mailTitle  = emailItemInf.get("mailTitle")  != null ? emailItemInf.get("mailTitle").toString(): "";
		String sender     = emailItemInf.get("sender")     != null ? emailItemInf.get("sender").toString()   : "";
		String attach     = emailItemInf.get("attach")     != null ? emailItemInf.get("attach").toString()   : "";
		String mode       = emailItemInf.get("mode")       != null ? emailItemInf.get("mode").toString()     : "";
		String cabinetId  = emailItemInf.get("cabinet")    != null ? emailItemInf.get("cabinet").toString()  : "";
		String content    = emailItemInf.get("content")    != null ? emailItemInf.get("content").toString()  : "";
		String receiver   = emailItemInf.get("receiver")   != null ? emailItemInf.get("receiver").toString() : "";
		String forward    = emailItemInf.get("forward")    != null ? emailItemInf.get("forward").toString()  : "";
		String userId     = emailItemInf.get("userId")     != null ? emailItemInf.get("userId").toString()   : "";
		String dateTime   = emailItemInf.get("dateTime")   != null ? emailItemInf.get("dateTime").toString() : "";
		JSONObject result = new JSONObject();
		
		logger.debug("ServerName: " + serverName + " || title: " + title + " || summary: " + summary + " || mailTitle: " + mailTitle + " || sender: " + sender + " || receiver: " + receiver + " || forward: " + forward + " || userId: " + userId + " || attach: " + attach + " || mode: " + mode + " || cabinetId: " + cabinetId + " || content: " + content + " || dateTime: " + dateTime);
		
		if (serverName.equals("") || userId.equals("") || title.equals("") || mailTitle.equals("") || sender.equals("") || (mode.equals("1") && cabinetId.equals("")) || content.equals("") || mode.equals("") || receiver.equals("") || dateTime.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			int dstCabinetId = cabinetId.equals("") ? -1 : Integer.parseInt(cabinetId);
			String realPath  = request.getServletContext().getRealPath("");
			result           = cabinetService.saveEmailItem(realPath, dstCabinetId, title, summary, mailTitle, sender, attach, mode, content, receiver, forward, dateTime, locale, userInfo);
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezcabinet/relate-item/modify/id/{itemid:.+}", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject modifyEmailItem(@RequestBody JSONObject emailItemInf, @PathVariable(value="itemid") String itemId, Locale locale, HttpServletRequest request) throws Exception {
		String serverName  = request.getHeader("host-name") != null ? request.getHeader("host-name")        : "";
		String title       = emailItemInf.get("title")      != null ? emailItemInf.get("title").toString()  : "";
		String summary     = emailItemInf.get("summary")    != null ? emailItemInf.get("summary").toString(): "";
		String relatedList = emailItemInf.get("relate")     != null ? emailItemInf.get("relate").toString() : "";
		String userId      = emailItemInf.get("userId")     != null ? emailItemInf.get("userId").toString() : "";
		JSONObject result  = new JSONObject();
		JSONParser jp      = new JSONParser();
		
		logger.debug("ServerName: " + serverName + " || title: " + title + " || summary: " + summary +" || userId: " + userId + " || itemId: " + itemId + " || relatedList: " + relatedList);
		
		if (serverName.equals("") || userId.equals("") || title.equals("") || itemId.equals("") ) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo       = commonUtil.getUserForGw(userId, serverName);
			int currentItemId      = Integer.parseInt(itemId);
			
			//Add checking permission here
			List<Integer> itemList = new ArrayList<>(Arrays.asList(currentItemId));
			JSONObject permission  = cabinetService.checkPermission(new ArrayList<>(), itemList, 1, userInfo);
			
			if ((int)permission.get("code") == 1) {
				result.put("status", "error");
				result.put("code", 3);
				return result;
			}
			
			JSONArray relatedFiles = (JSONArray) jp.parse(relatedList);
			result                 = cabinetService.modifyRelatedItem(currentItemId, title, summary, relatedFiles, userInfo);
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezcabinet/relate-item/save/address-group", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject saveGroupAddressItem(@RequestBody JSONObject addressItemInf, Locale locale, HttpServletRequest request) throws Exception {
		String serverName = request.getHeader("host-name")   != null ? request.getHeader("host-name")              : "";
		String title      = addressItemInf.get("title")      != null ? addressItemInf.get("title").toString()      : "";
		String summary    = addressItemInf.get("summary")    != null ? addressItemInf.get("summary").toString()    : "";
		String mode       = addressItemInf.get("mode")       != null ? addressItemInf.get("mode").toString()       : "";
		String cabinetId  = addressItemInf.get("cabinet")    != null ? addressItemInf.get("cabinet").toString()    : "";
		String groupName  = addressItemInf.get("groupName")  != null ? addressItemInf.get("groupName").toString()    : "";
		String content    = addressItemInf.get("content")    != null ? addressItemInf.get("content").toString()    : "";
		String createUser = addressItemInf.get("createUser") != null ? addressItemInf.get("createUser").toString() : "";
		String createDate = addressItemInf.get("createDate") != null ? addressItemInf.get("createDate").toString() : "";
		String userId     = addressItemInf.get("userId")     != null ? addressItemInf.get("userId").toString()     : "";
		String changeUser = addressItemInf.get("changeUser") != null ? addressItemInf.get("changeUser").toString() : "";
		String changeDate = addressItemInf.get("changeDate") != null ? addressItemInf.get("changeDate").toString() : "";
		
		JSONObject result = new JSONObject();
		
		logger.debug("ServerName: " + serverName + " || title: " + title + " || summary: " + summary + " || groupName: " + groupName + " || createUser: " + createUser + " || createDate: " + createDate + " || changeUser: " + changeUser + " || userId: " + userId + " || changeDate: " + changeDate + " || mode: " + mode + " || cabinetId: " + cabinetId + " || content: " + content);
		
		if (serverName.equals("") || userId.equals("") || title.equals("") || groupName.equals("") || createUser.equals("") || (mode.equals("1") && cabinetId.equals("")) || content.equals("") || mode.equals("") || createDate.equals("") || changeUser.equals("") || changeDate.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			int dstCabinetId = cabinetId.equals("") ? -1 : Integer.parseInt(cabinetId);
			result           = cabinetService.saveGroupAddressItem(dstCabinetId, title, summary, mode, groupName, content, createUser, createDate, changeUser, changeDate, userInfo);
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezcabinet/relate-item/save/address-normal", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject saveNormalAddressItem(@RequestBody JSONObject addressItemInf, Locale locale, HttpServletRequest request) throws Exception {
		String serverName = request.getHeader("host-name")   != null ? request.getHeader("host-name")              : "";
		String title      = addressItemInf.get("title")      != null ? addressItemInf.get("title").toString()      : "";
		String summary    = addressItemInf.get("summary")    != null ? addressItemInf.get("summary").toString()    : "";
		String mode       = addressItemInf.get("mode")       != null ? addressItemInf.get("mode").toString()       : "";
		String cabinetId  = addressItemInf.get("cabinet")    != null ? addressItemInf.get("cabinet").toString()    : "";
		String createUser = addressItemInf.get("createUser") != null ? addressItemInf.get("createUser").toString() : "";
		String createDate = addressItemInf.get("createDate") != null ? addressItemInf.get("createDate").toString() : "";
		String userId     = addressItemInf.get("userId")     != null ? addressItemInf.get("userId").toString()     : "";
		String changeUser = addressItemInf.get("changeUser") != null ? addressItemInf.get("changeUser").toString() : "";
		String changeDate = addressItemInf.get("changeDate") != null ? addressItemInf.get("changeDate").toString() : "";
		String company    = addressItemInf.get("company")    != null ? addressItemInf.get("company").toString()    : "";
		String department = addressItemInf.get("department") != null ? addressItemInf.get("department").toString() : "";
		String position   = addressItemInf.get("position")   != null ? addressItemInf.get("position").toString()   : "";
		String email      = addressItemInf.get("email")      != null ? addressItemInf.get("email").toString()      : "";
		String compNumber = addressItemInf.get("compNumber") != null ? addressItemInf.get("compNumber").toString() : "";
		String userNumber = addressItemInf.get("userNumber") != null ? addressItemInf.get("userNumber").toString() : "";
		String faxNumber  = addressItemInf.get("faxNumber")  != null ? addressItemInf.get("faxNumber").toString()  : "";
		String homePage   = addressItemInf.get("homePage")   != null ? addressItemInf.get("homePage").toString()   : "";
		String companyZip = addressItemInf.get("companyZip") != null ? addressItemInf.get("companyZip").toString() : "";
		String compAddr   = addressItemInf.get("compAddr")   != null ? addressItemInf.get("compAddr").toString()   : "";
		String homeZip    = addressItemInf.get("homeZip")    != null ? addressItemInf.get("homeZip").toString()    : "";
		String homeAddr   = addressItemInf.get("homeAddr")   != null ? addressItemInf.get("homeAddr").toString()   : "";
		String memo       = addressItemInf.get("memo")       != null ? addressItemInf.get("memo").toString()       : "";
		
		JSONObject result = new JSONObject();
		
		logger.debug("ServerName: " + serverName + " || title: " + title + "|| summary: " + summary + " || createUser: " + createUser + " || createDate: " + createDate + " || changeUser: " + changeUser + " || userId: " + userId + " || changeDate: " + changeDate + " || mode: " + mode + " || cabinetId: " + cabinetId + " || company: " + company + " || department: " + department + " || position: " + position + " || email: " + email + " || compNumber: " + compNumber + " || userNumber: " + userNumber + " || faxNumber: " + faxNumber + " || homePage: " + homePage + " || companyZip: " + companyZip + " || compAddr: " + compAddr + " || homeZip: " + homeZip + " || homeAddr: " + homeAddr + " || memo: " + memo);
		
		if (serverName.equals("") || userId.equals("") || title.equals("") || createUser.equals("") || (mode.equals("1") && cabinetId.equals("")) || mode.equals("") || createDate.equals("") || changeUser.equals("") || changeDate.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			int dstCabinetId = cabinetId.equals("") ? -1 : Integer.parseInt(cabinetId);
			result           = cabinetService.saveNormalAddressItem(dstCabinetId, title, summary, mode, createUser, createDate, changeUser, changeDate, company, department, position, email, compNumber, userNumber, faxNumber, homePage, companyZip, compAddr, homeZip, homeAddr, memo, userInfo);
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezcabinet/relate-item/save/resource", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject saveResourceItem(@RequestBody JSONObject resourceItemInf, Locale locale, HttpServletRequest request) throws Exception {
		String serverName = request.getHeader("host-name")    != null ? request.getHeader("host-name")               : "";
		String title      = resourceItemInf.get("title")      != null ? resourceItemInf.get("title").toString()      : "";
		String summary    = resourceItemInf.get("summary")    != null ? resourceItemInf.get("summary").toString()    : "";
		String mode       = resourceItemInf.get("mode")       != null ? resourceItemInf.get("mode").toString()       : "";
		String cabinetId  = resourceItemInf.get("cabinet")    != null ? resourceItemInf.get("cabinet").toString()    : "";
		String resTitle   = resourceItemInf.get("resTitle")    != null ? resourceItemInf.get("resTitle").toString()    : "";
		String createUser = resourceItemInf.get("createUser") != null ? resourceItemInf.get("createUser").toString() : "";
		String resDate    = resourceItemInf.get("resDate")    != null ? resourceItemInf.get("resDate").toString()    : "";
		String userId     = resourceItemInf.get("userId")     != null ? resourceItemInf.get("userId").toString()     : "";
		String resItem    = resourceItemInf.get("resItem")    != null ? resourceItemInf.get("resItem").toString()    : "";
		String content    = resourceItemInf.get("content")    != null ? resourceItemInf.get("content").toString()    : "";
		
		JSONObject result = new JSONObject();
		
		logger.debug("ServerName: " + serverName + " || title: " + title + "|| summary: " + summary + " || createUser: " + createUser + " || Resource Date: " + resDate + " || userId: " + userId + " || resItem: " + resItem + " || mode: " + mode + " || cabinetId: " + cabinetId + " || resTitle: " + resTitle + " || content: " + content);
		
		if (serverName.equals("") || userId.equals("") || title.equals("") || resTitle.equals("") || createUser.equals("") || (mode.equals("1") && cabinetId.equals("")) || mode.equals("") || resDate.equals("") || resItem.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			int dstCabinetId = cabinetId.equals("") ? -1 : Integer.parseInt(cabinetId);
			result           = cabinetService.saveResourceItem(dstCabinetId, resTitle, content, title, summary, mode, createUser, resDate, resItem, userInfo);
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezcabinet/relate-item/save/schedule", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject saveScheduleItem(@RequestBody JSONObject scheduleItemInf, Locale locale, HttpServletRequest request) throws Exception {
		String serverName    = request.getHeader("host-name")       != null ? request.getHeader("host-name")                 : "";
		String userId        = scheduleItemInf.get("userId")        != null ? scheduleItemInf.get("userId").toString()       : "";
		String title         = scheduleItemInf.get("title")         != null ? scheduleItemInf.get("title").toString()        : "";
		String summary       = scheduleItemInf.get("summary")       != null ? scheduleItemInf.get("summary").toString()      : "";
		String mode          = scheduleItemInf.get("mode")          != null ? scheduleItemInf.get("mode").toString()         : "";
		String cabinetId     = scheduleItemInf.get("cabinet")       != null ? scheduleItemInf.get("cabinet").toString()      : "";
		String scheduleTitle = scheduleItemInf.get("scheduleTitle") != null ? scheduleItemInf.get("scheduleTitle").toString(): "";
		String createUser    = scheduleItemInf.get("createUser")    != null ? scheduleItemInf.get("createUser").toString()   : "";
		String createDate    = scheduleItemInf.get("createDate")    != null ? scheduleItemInf.get("createDate").toString()   : "";
		String scheduleDate  = scheduleItemInf.get("scheduleDate")  != null ? scheduleItemInf.get("scheduleDate").toString() : "";
		String location      = scheduleItemInf.get("location")      != null ? scheduleItemInf.get("location").toString()     : "";
		String publicstatus  = scheduleItemInf.get("publicstatus")  != null ? scheduleItemInf.get("publicstatus").toString() : "";
		String groupname     = scheduleItemInf.get("groupname")     != null ? scheduleItemInf.get("groupname").toString()    : "";
		String attendant     = scheduleItemInf.get("attendant")     != null ? scheduleItemInf.get("attendant").toString()    : "";
		String scheduletype  = scheduleItemInf.get("scheduletype")  != null ? scheduleItemInf.get("scheduletype").toString() : "";
		String attach        = scheduleItemInf.get("attach")        != null ? scheduleItemInf.get("attach").toString()       : "";
		String content       = scheduleItemInf.get("content")       != null ? scheduleItemInf.get("content").toString()      : "";
		
		JSONObject result = new JSONObject();
		
		logger.debug("ServerName: " + serverName +  "userId: " + userId +  "Title: " + title + " || summary: " + summary + " || mode: " + mode + " || cabinetId: " + cabinetId + " || scheduleTitle: " + scheduleTitle +" || createUser: " + createUser + " || createDate: " + createDate + " || scheduleDate: " + scheduleDate + " || location: " + location + " || publicstatus: " + publicstatus + " || groupname: " + groupname + " || attendant: " + attendant + " || scheduletype: " + scheduletype + " || attach: " + attach + " || content: " + content);
		
		if (serverName.equals("") || userId.equals("") || title.equals("") || scheduleTitle.equals("") || createUser.equals("") || (mode.equals("1") && cabinetId.equals("")) || mode.equals("") || createUser.equals("") || createDate.equals("") || scheduleDate.equals("") || publicstatus.equals("") || scheduletype.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			int dstCabinetId = cabinetId.equals("") ? -1 : Integer.parseInt(cabinetId);
			String realPath  = request.getServletContext().getRealPath("");
			result           = cabinetService.saveScheduleItem(dstCabinetId, realPath, title, summary, mode, scheduleTitle, createUser, createDate, scheduleDate, location, publicstatus, groupname, attendant, scheduletype, attach, content, locale, userInfo);
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezcabinet/relate-item/save/todo", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject saveTodoItem(@RequestBody JSONObject todoItemInf, Locale locale, HttpServletRequest request) throws Exception {
		String serverName = request.getHeader("host-name") != null ? request.getHeader("host-name")           : "";
		String userId     = todoItemInf.get("userId")      != null ? todoItemInf.get("userId").toString()     : "";
		String title      = todoItemInf.get("title")       != null ? todoItemInf.get("title").toString()      : "";
		String mode       = todoItemInf.get("mode")        != null ? todoItemInf.get("mode").toString()       : "";
		String cabinetId  = todoItemInf.get("cabinet")     != null ? todoItemInf.get("cabinet").toString()    : "";
		String createUser = todoItemInf.get("createUser")  != null ? todoItemInf.get("createUser").toString() : "";
		String createDate = todoItemInf.get("createDate")  != null ? todoItemInf.get("createDate").toString() : "";
		String priority   = todoItemInf.get("priority")    != null ? todoItemInf.get("priority").toString()   : "";
		String memo       = todoItemInf.get("memo")        != null ? todoItemInf.get("memo").toString()       : "";
		String tasktype   = todoItemInf.get("tasktype")    != null ? todoItemInf.get("tasktype").toString()   : "";
		String executor   = todoItemInf.get("executor")    != null ? todoItemInf.get("executor").toString()   : "";
		String shareList  = todoItemInf.get("shareList")   != null ? todoItemInf.get("shareList").toString()  : "";
		String attach     = todoItemInf.get("attach")      != null ? todoItemInf.get("attach").toString()     : "";
		String content    = todoItemInf.get("content")     != null ? todoItemInf.get("content").toString()    : "";
		
		JSONObject result = new JSONObject();
		
		logger.debug("ServerName: " + serverName +  "userId: " + userId +  "Title: " + title + " || mode: " + mode + " || cabinetId: " + cabinetId + " || createUser: " + createUser + " || createDate: " + createDate + " || priority: " + priority + " || memo: " + memo + " || tasktype: " + tasktype + " || executor: " + executor + " || shareList: " + shareList + " || attach: " + attach + " || content: " + content);
		
		if (serverName.equals("") || userId.equals("") || title.equals("") || createUser.equals("") || (mode.equals("1") && cabinetId.equals("")) || mode.equals("") || createUser.equals("") || createDate.equals("") || priority.equals("") || tasktype.equals("") || executor.equals("") || content.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			int dstCabinetId = cabinetId.equals("") ? -1 : Integer.parseInt(cabinetId);
			String realPath  = request.getServletContext().getRealPath("");
			result           = cabinetService.saveTodoItem(dstCabinetId, realPath, title, mode, createUser, createDate, priority, memo, tasktype, executor, shareList, attach, content, locale, userInfo);
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezcabinet/relate-item/save/photo-board", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject savePhotoBoard(@RequestBody JSONObject boardItemInf, Locale locale, HttpServletRequest request) throws Exception {
		String serverName = request.getHeader("host-name") != null ? request.getHeader("host-name")            : "";
		String userId     = boardItemInf.get("userId")     != null ? boardItemInf.get("userId").toString()     : "";
		String title      = boardItemInf.get("title")      != null ? boardItemInf.get("title").toString()      : "";
		String summary    = boardItemInf.get("summary")    != null ? boardItemInf.get("summary").toString()    : "";
		String boardTitle = boardItemInf.get("boardTitle") != null ? boardItemInf.get("boardTitle").toString() : "";
		String mode       = boardItemInf.get("mode")       != null ? boardItemInf.get("mode").toString()       : "";
		String cabinetId  = boardItemInf.get("cabinet")    != null ? boardItemInf.get("cabinet").toString()    : "";
		String createUser = boardItemInf.get("createUser") != null ? boardItemInf.get("createUser").toString() : "";
		String createDate = boardItemInf.get("createDate") != null ? boardItemInf.get("createDate").toString() : "";
		String descript   = boardItemInf.get("descript")   != null ? boardItemInf.get("descript").toString()   : "";
		String boardId    = boardItemInf.get("boardId")    != null ? boardItemInf.get("boardId").toString()    : "";
		String itemId     = boardItemInf.get("itemId")     != null ? boardItemInf.get("itemId").toString()     : "";
		
		JSONObject result = new JSONObject();
		
		logger.debug("ServerName: " + serverName +  "userId: " + userId +  "Title: " + title + " || summary: " + summary + " || boardTitle: " + boardTitle + " || mode: " + mode + " || cabinetId: " + cabinetId + " || createUser: " + createUser + " || createDate: " + createDate + " || boardId: " + boardId + " || itemId: " + itemId + " || Description: " + descript);
		
		if (serverName.equals("") || userId.equals("") || title.equals("") || createUser.equals("") || (mode.equals("1") && cabinetId.equals("")) || mode.equals("") || createUser.equals("") || createDate.equals("") || boardId.equals("") || itemId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			int dstCabinetId = cabinetId.equals("") ? -1 : Integer.parseInt(cabinetId);
			String realPath  = request.getServletContext().getRealPath("");
			result           = cabinetService.savePhotoBoard(dstCabinetId, realPath, title, summary, boardTitle, mode, createUser, createDate, descript, boardId, itemId, locale, userInfo);
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	private boolean isCabinetAdmin(LoginVO user) {
		return (user.getRollInfo().indexOf("c=1") == -1 && user.getRollInfo().indexOf("k=1") == -1)? false : true;
	}
	
	private void setUsedRateForUser(UserCapacityVO capacity) {
		if (capacity.getCapacityType() == 0 || capacity.getTotalUsed().equals("0") || capacity.getTotalCapacity() == 0) {
			capacity.setUsedRate(0);
		}
		else {
			double totalCapByBytes = capacity.getTotalCapacity() * 10485.76;
			capacity.setUsedRate((int)(Double.parseDouble(capacity.getTotalUsed())/totalCapByBytes));
		}
	}
}
