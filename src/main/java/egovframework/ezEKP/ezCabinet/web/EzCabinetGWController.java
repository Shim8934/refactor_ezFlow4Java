package egovframework.ezEKP.ezCabinet.web;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCabinet.service.EzCabinetAdminService;
import egovframework.ezEKP.ezCabinet.service.EzCabinetService;
import egovframework.ezEKP.ezCabinet.vo.CabinetGeneralVO;
import egovframework.ezEKP.ezCabinet.vo.CabinetModuleVO;
import egovframework.ezEKP.ezCabinet.vo.CabinetSimpleVO;
import egovframework.ezEKP.ezCabinet.vo.CompanyCapacityVO;
import egovframework.ezEKP.ezCabinet.vo.SimpleDeptVO;
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
	
	@RequestMapping(value="/rest/ezcabinet/check-admin/{userid}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
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
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezcabinet/company-list/{userid}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
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
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezcabinet/company-tree/comp/{companyid}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getCompanyTree(@PathVariable(value="companyid") String companyId, HttpServletRequest request) {
		String userId     = request.getParameter("userId") != null ? request.getParameter("userId") : "";
		String deptId     = request.getParameter("deptId") != null ? request.getParameter("deptId") : "";
		String serverName = request.getHeader("host-name") != null ? request.getHeader("host-name") : "";
		JSONObject result = new JSONObject();
		
		if (companyId.equals("") || serverName.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		logger.debug("CompanyId: " + companyId + " || serverName: " + serverName);
		
		try {
			LoginVO userInfo      = commonUtil.getUserForGw(userId, serverName);
			String primary        = userInfo.getPrimary();
			int tenantId          = userInfo.getTenantId();
			deptId                = deptId.equals("") ? userInfo.getDeptID() : deptId;
			SimpleDeptVO sCompany = null;
			
			/*if (deptId.equals("")) {
				sCompany = cabinetService.getAllDepts(companyId, 0, primary, tenantId);
			}
			else {
				String deptPath  = cabinetService.getDeptPath(deptId, tenantId);
				String[] path    = deptPath.split(",");
				sCompany         = cabinetService.getSimpleCompany(companyId, 0, primary, tenantId);
				
				cabinetService.getAllDepts(sCompany, path, primary, tenantId, 1, 1);
			}*/
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("tree", sCompany);
			result.put("node", deptId);
		}
		catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezcabinet/sub-tree/{deptid}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
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
			List<SimpleDeptVO> subDepts = cabinetService.getAllSubDepts(deptId, level, userInfo.getPrimary(), userInfo.getTenantId());
			result.put("status", "ok");
			result.put("code", 0);
			result.put("subNodes", subDepts);
		}
		catch (Exception e) {
			e.printStackTrace();
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
			e.printStackTrace();
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
			int tenantId = loginService.getTenantId(serverName);
			cabinetAdminService.saveCompanyCapacity(type, newValue, companyId, tenantId);
			result.put("status", "ok");
			result.put("code", 0);
		}
		catch (Exception e) {
			e.printStackTrace();
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
			e.printStackTrace();
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
			int tenantId = loginService.getTenantId(serverName);
			cabinetAdminService.changeUserCapacity(userList, newValue, type, companyId, tenantId);
			
			result.put("status", "ok");
			result.put("code", 0);
		}
		catch (Exception e) {
			e.printStackTrace();
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
			result.put("status", "ok");
			result.put("code", 0);
			result.put("modules", modules);
		}
		catch (Exception e) {
			e.printStackTrace();
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
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezcabinet/module/id/{userid}/person", method= RequestMethod.GET, produces="application/json;charset=utf-8")
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
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("modules", modules);
		}
		catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezcabinet/module/id/{userid}/person", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
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
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezcabinet/capacity/{userid}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
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
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezcabinet/config/id/{userid}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
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
			CabinetGeneralVO userConfig = cabinetService.getUserPreviewConfig(userId, companyId, tenantId);
			
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
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezcabinet/config/id/{userid}", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
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
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezcabinet/mycabinet/id/{userid}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
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
			CabinetSimpleVO mycabinet = new CabinetSimpleVO();
					
			if (cabinetId.equals("")) {
				String cabinetStr1  = egovMessageSource.getMessage("ezCabinet.t02", new Locale("ko"));
				String cabinetStr2  = egovMessageSource.getMessage("ezCabinet.t02", new Locale("en"));
				mycabinet           = cabinetService.getMyCabinetTreeNormal(cabinetStr1, cabinetStr2, userInfo);
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
			e.printStackTrace();
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
		String cabName2   = request.getParameter("cabName2") != null ? request.getParameter("cabName2")                   : "";
		int parentId      = request.getParameter("parentId") != null ? Integer.parseInt(request.getParameter("parentId")) : -1;
		
		JSONObject result = new JSONObject();
		
		logger.debug("UserId: " + userId + " || serverName: " + serverName + " || Parent Id: " + parentId + " || Cabinet name1: " + cabName1 + " || Cabinet name2: " + cabName2);
		
		if (serverName.equals("") || userId.equals("") || parentId == -1 || cabName1.equals("") || cabName2.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			cabinetService.addCabinet(parentId, cabName1, cabName2, userInfo);
			
			result.put("status", "ok");
			result.put("code", 0);
		} 
		catch (Exception e) {
			e.printStackTrace();
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
		String cabName2   = request.getParameter("cabName2")  != null ? request.getParameter("cabName2")                    : "";
		int cabinetId     = request.getParameter("cabinetId") != null ? Integer.parseInt(request.getParameter("cabinetId")) : -1;
		
		JSONObject result = new JSONObject();
		
		logger.debug("UserId: " + userId + " || serverName: " + serverName + " || Cabinet Id: " + cabinetId + " || Cabinet name1: " + cabName1 + " || Cabinet name2: " + cabName2);
		
		if (serverName.equals("") || userId.equals("") || cabinetId == -1 || cabName1.equals("") || cabName2.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			cabinetService.renameCabinet(cabinetId, cabName1, cabName2, userInfo);
			
			result.put("status", "ok");
			result.put("code", 0);
		} 
		catch (Exception e) {
			e.printStackTrace();
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
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	private boolean isCabinetAdmin(LoginVO user) {
		return user.getRollInfo().contains("cb=1");
	}
	
	private void setUsedRateForUser(UserCapacityVO capacity) {
		if (capacity.getCapacityType() == 0 || capacity.getTotalUsed().equals("0") || capacity.getTotalCapacity().equals("0")) {
			capacity.setUsedRate(0);
		}
		else {
			double totalCapByBytes = Double.parseDouble(capacity.getTotalCapacity()) * 10485.76;
			capacity.setUsedRate((int)(Double.parseDouble(capacity.getTotalUsed())/totalCapByBytes));
		}
	}
}
