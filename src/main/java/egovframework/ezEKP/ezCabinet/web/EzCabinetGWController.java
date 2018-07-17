package egovframework.ezEKP.ezCabinet.web;

import java.io.File;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Locale;
import java.util.stream.Collectors;
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
import org.springframework.web.multipart.MultipartFile;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCabinet.service.EzCabinetAdminService;
import egovframework.ezEKP.ezCabinet.service.EzCabinetService;
import egovframework.ezEKP.ezCabinet.vo.CabinetGeneralVO;
import egovframework.ezEKP.ezCabinet.vo.CabinetItemSearchVO;
import egovframework.ezEKP.ezCabinet.vo.CabinetItemVO;
import egovframework.ezEKP.ezCabinet.vo.CabinetModuleVO;
import egovframework.ezEKP.ezCabinet.vo.CabinetSimpleVO;
import egovframework.ezEKP.ezCabinet.vo.CabinetVO;
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
			List<SimpleDeptVO> subDepts = cabinetService.getAllSubDepts(deptId, level + 1, userInfo.getPrimary(), userInfo.getTenantId());
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
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezcabinet/allcabinet/id/{userid}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
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
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezcabinet/relatedcabinet/id/{userid}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
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
			
			if (!mode.equals("1")) {
				result.put("node", relatedList.get(0).getCabinetId());
			}
			
			result.put("tree", relatedList);
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
			
			//Add checking permission here
			List<Integer> cabinetList = new ArrayList<>(Arrays.asList(parentId));
			JSONObject permission = cabinetService.checkPermission(cabinetList, new ArrayList<>(), userInfo);
			
			if ((int)permission.get("code") == 1) {
				result.put("status", "error");
				result.put("code", 3);
				return result;
			}
			
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
			
			//Add checking permission here
			List<Integer> cabinetList = new ArrayList<>(Arrays.asList(cabinetId));
			JSONObject permission = cabinetService.checkPermission(cabinetList, new ArrayList<>(), userInfo);
			
			if ((int)permission.get("code") == 1) {
				result.put("status", "error");
				result.put("code", 3);
				return result;
			}
			
			result = cabinetService.renameCabinet(cabinetId, cabName1, cabName2, userInfo);
		} 
		catch (Exception e) {
			e.printStackTrace();
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
			JSONObject permission = cabinetService.checkPermission(cabinetList, new ArrayList<>(), userInfo);
			
			if ((int)permission.get("code") == 1) {
				result.put("status", "error");
				result.put("code", 3);
				return result;
			}
			
			result = cabinetService.deleteCabinet(cabinetId, userInfo);
		} 
		catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezcabinet/cabinet-move/mode/{mode}", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
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
			JSONObject permission = cabinetService.checkPermission(cabinetList, new ArrayList<>(), userInfo);
			
			if ((int)permission.get("code") == 1) {
				result.put("status", "error");
				result.put("code", 3);
				return result;
			}
			
			String realPath = request.getServletContext().getRealPath("");
			result          = cabinetService.moveCabinet(cabinetId, parentId, mode, realPath, userInfo);
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
			int tenantId     = loginService.getTenantId(serverName);
			String realPath  = request.getServletContext().getRealPath("");
			String filePath  = cabinetService.saveUploadFile(multiFileLists, nameArray, realPath, tenantId);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("path", filePath);
		}
		catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
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
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezcabinet/item/id/{cabinetid}/add", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject saveItem(@PathVariable(value="cabinetid") String cabinetId, Locale locale, HttpServletRequest request) throws Exception {
		String serverName = request.getHeader("host-name")     != null ? request.getHeader("host-name")     : "";
		String title      = request.getParameter("title")      != null ? request.getParameter("title")      : "";
		String summary    = request.getParameter("summary")    != null ? request.getParameter("summary")    : "";
		String fileArray  = request.getParameter("fileArray")  != null ? request.getParameter("fileArray")  : "";
		String relatedArr = request.getParameter("relatedArr") != null ? request.getParameter("relatedArr") : "";
		String userId     = request.getParameter("userId")     != null ? request.getParameter("userId")     : "";
		JSONObject result = new JSONObject();
		JSONParser jp     = new JSONParser();
		
		logger.debug("ServerName: " + serverName + " ||  title: " + title + " ||  summary: " + summary + " ||  userId: " + userId + " || fileArray: " + fileArray + " || relatedArr: " + relatedArr);
		
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
			JSONObject permission     = cabinetService.checkPermission(cabinetList, new ArrayList<>(), userInfo);
			
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
						File file          = new File(realPath + filePath);
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
			e.printStackTrace();
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
			JSONObject permission     = cabinetService.checkPermission(new ArrayList<>(), itemIdList, userInfo);
			
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
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezcabinet/item-move/mode/{mode}", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
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
			JSONObject permission     = cabinetService.checkPermission(cabinetList, itemIdList, userInfo);
			
			if ((int)permission.get("code") == 1) {
				result.put("status", "error");
				result.put("code", 3);
				return result;
			}
			
			String realPath = request.getServletContext().getRealPath("");
			result          = cabinetService.moveItems(realPath, cabinetId, mode, itemIdList, userInfo);
		}
		catch (Exception e) {
			e.printStackTrace();
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
			JSONObject permission     = cabinetService.checkPermission(cabinetList, new ArrayList<>(), userInfo);
			
			if ((int)permission.get("code") == 1) {
				result.put("status", "error");
				result.put("code", 3);
				return result;
			}
			
			int tenantId     = userInfo.getTenantId();
			String primary   = userInfo.getPrimary();
			String offset    = commonUtil.getMinuteUTC(userInfo.getOffset());
			int startPoint   = 0;
			int totalItems   = 0;
			int totalPages   = 0;
			
			if (!column.equals("") && !order.equals("")) {
				switch(column) {
					case "it": sqlQuery = "item_type "   + order; break;
					case "tt": sqlQuery = "title "       + order; break;
					case "un": sqlQuery = primary.equals("1") ? "creator_name1 " + order : "creator_name2 " + order; break;
					case "cd": sqlQuery = "create_date " + order; break;
					case "is": sqlQuery = "item_size "   + order; break;
					default  : sqlQuery = "item_type "   + order; break;
				}
			}
			
			CabinetItemSearchVO searchVO = new CabinetItemSearchVO(Integer.parseInt(cabinetId), listCntSize, tenantId, userId, primary, offset, title, summary, creatorName, startDate, endDate, sqlQuery, srchMode, srchOption);
			List<CabinetItemVO> itemList = new ArrayList<>();
			
			if (srchMode.equals("2") && recursive.equals("1")) {
				CabinetVO cabinet = cabinetService.getCabinetById(cabinetId, userInfo.getTenantId());
				searchVO.setCabinetPath(cabinet.getCabinetPath());
				totalItems  = cabinetService.getTotalItemsRecursive(searchVO);
				totalPages  = (totalItems + listCntSize - 1) / listCntSize;
				currentPage = currentPage > totalPages ? totalPages : currentPage;
				currentPage = currentPage == 0         ? 1          : currentPage;
				startPoint  = (currentPage - 1) * listCntSize;
				searchVO.setStartPoint(startPoint);
				itemList    = cabinetService.getItemsRecursive(searchVO);
			}
			else {
				totalItems  = cabinetService.getTotalItems(searchVO);
				totalPages  = (totalItems + listCntSize - 1) / listCntSize;
				currentPage = currentPage > totalPages ? totalPages : currentPage;
				currentPage = currentPage == 0         ? 1          : currentPage;
				startPoint  = (currentPage - 1) * listCntSize;
				searchVO.setStartPoint(startPoint);
				itemList    = cabinetService.getItems(searchVO);
			}
			
			result.put("itemList",    itemList);
			result.put("totalPages",  totalPages);
			result.put("totalRows",   totalItems);
			result.put("currentPage", currentPage);
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
	
	@RequestMapping(value="/rest/ezcabinet/cabinet/id/{cabinetid}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
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
			JSONObject permission     = cabinetService.checkPermission(cabinetList, new ArrayList<>(), userInfo);
			
			if ((int)permission.get("code") == 1) {
				result.put("status", "error");
				result.put("code", 3);
				return result;
			}
			
			CabinetVO cabinet = cabinetService.getCabinetById(cabinetId, userInfo.getTenantId());
			cabinet.setCabinetName(userInfo.getPrimary().equals("1") ? cabinet.getCabinetName1() : cabinet.getCabinetName2());
			
			result.put("cabinet", cabinet);
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
		if (capacity.getCapacityType() == 0 || capacity.getTotalUsed().equals("0") || capacity.getTotalCapacity() == 0) {
			capacity.setUsedRate(0);
		}
		else {
			double totalCapByBytes = capacity.getTotalCapacity() * 10485.76;
			capacity.setUsedRate((int)(Double.parseDouble(capacity.getTotalUsed())/totalCapByBytes));
		}
	}
}
