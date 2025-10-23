package egovframework.ezEKP.ezCabinet.web;

import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import egovframework.ezEKP.ezCabinet.service.EzCabinetRestService;
import egovframework.let.user.login.vo.LoginSimpleVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@SuppressWarnings("unchecked")
@Controller
public class EzCabinetAdminController {
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private EzCabinetRestService cabinetRestService;
	
	private static final Logger logger = LoggerFactory.getLogger(EzCabinetAdminController.class);
	
	@RequestMapping(value = "/admin/ezCabinet/cabinetAdminMain.do", method = RequestMethod.GET)
	public String jspAdminPage(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("jspAdminPage start");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		
		if ((long)cabinetRestService.checkCabinetAdmin(request, user.getId()).get("code") != 0) {
			return "cmm/error/adminDenied";
		}
		
		logger.debug("jspAdminPage end");
		return "admin/ezCabinet/adminMain";
	}
	
	@RequestMapping(value="/admin/ezcabinet/cabinetAdminLeft.do", method = RequestMethod.GET)
	public String jspAdminLeft(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("jspAdminLeft start");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		
		if ((long)cabinetRestService.checkCabinetAdmin(request, user.getId()).get("code") != 0) {
			return "cmm/error/adminDenied";
		}
		model.addAttribute("lang", user.getLang());
		logger.debug("jspAdminLeft end");
		return "admin/ezCabinet/cabinetAdminLeft";
	}
	
	@RequestMapping(value="/admin/ezCabinet/getBasicPage.do", method = RequestMethod.GET)
	public String jspGetBasicPage(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("jspGetBasicPage start");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		
		if ((long)cabinetRestService.checkCabinetAdmin(request, user.getId()).get("code") != 0) {
			return "cmm/error/adminDenied";
		}
		
		JSONObject resultObj = cabinetRestService.getCompanyList(request, user.getId());
		String status        = resultObj.get("status").toString();
		
		if (!status.equals("ok")) {
			return "cmm/error/dataAccessFailure";
		}
		
		String companyId       = (String) resultObj.get("userCompany");
		JSONArray companyList  = (JSONArray) resultObj.get("data");
		
		model.addAttribute("userCompany", companyId);
		model.addAttribute("list", companyList);
		
		logger.debug("jspGetBasicPage end");
		return "admin/ezCabinet/cabinetBasicConfig";
	}
	
	@RequestMapping(value="/admin/ezCabinet/getPersonalPage.do", method = RequestMethod.GET)
	public String jspGetPersonalPage(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("jspGetPersonalPage start");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		
		if ((long)cabinetRestService.checkCabinetAdmin(request, user.getId()).get("code") != 0) {
			return "cmm/error/adminDenied";
		}
		
		JSONObject resultObj = cabinetRestService.getCompanyList(request, user.getId());
		
		String status        = resultObj.get("status").toString();
		
		if (status.equals("ok")) {
			String companyId      = (String) resultObj.get("userCompany");
			JSONArray companyList = (JSONArray) resultObj.get("data");
			model.addAttribute("userCompany", companyId);
			model.addAttribute("list", companyList);
		}
		else {
			return "cmm/error/dataAccessFailure";
		}
		
		logger.debug("jspGetPersonalPage end");
		return "admin/ezCabinet/cabinetPersonalConfig";
	}
	
	@RequestMapping(value="/admin/ezCabinet/getRelatedCabinetConfig.do", method = RequestMethod.GET)
	public String jspGetRelatedCabinetConfig(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("jspGetRelatedCabinetConfig start");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		
		if ((long)cabinetRestService.checkCabinetAdmin(request, user.getId()).get("code") != 0) {
			return "cmm/error/adminDenied";
		}
		
		JSONObject resultObj = cabinetRestService.getCompanyList(request, user.getId());
		
		if (!resultObj.get("status").toString().equals("ok")) {
			return "cmm/error/dataAccessFailure";
		}
		
		String companyId         = (String) resultObj.get("userCompany");
		JSONArray companyList    = (JSONArray) resultObj.get("data");
		JSONObject modulesObject = cabinetRestService.getModuleListForAdmin(request, companyId);
		
		if (!modulesObject.get("status").toString().equals("ok")) {
			return "cmm/error/dataAccessFailure";
		}
		
		JSONArray moduleList = (JSONArray) modulesObject.get("modules");
		
		model.addAttribute("userCompany", companyId);
		model.addAttribute("list",        companyList);
		model.addAttribute("modules",     moduleList);
		
		logger.debug("jspGetRelatedCabinetConfig end");
		return "admin/ezCabinet/cabinetAdminInterLock";
	}
	
	@RequestMapping(value="/admin/ezCabinet/getCompanyCapacity.do", method = RequestMethod.GET)
	@ResponseBody
	public String jsonGetCompanyCapacity(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("jsonGetCompanyCapacity start");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		
		if ((long)cabinetRestService.checkCabinetAdmin(request, user.getId()).get("code") != 0) {
			return "cmm/error/adminDenied";
		}
		
		String companyId       = request.getParameter("companyId") != null ? request.getParameter("companyId") : "";
		JSONObject resultObj   = new JSONObject();
		
		if (companyId.equals("")) {
			resultObj.put("code", 1);
			resultObj.put("status", "error");
			return resultObj.toString();
		}
		
		resultObj = cabinetRestService.getCompanyCapacity(request, companyId);
		
		logger.debug("jsonGetCompanyCapacity end");
		return resultObj.toString();
	}
	
	@RequestMapping(value="/admin/ezCabinet/saveCompanyCapacity.do", method = RequestMethod.GET)
	@ResponseBody
	public String jsonSaveCompanyCapacity(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("jsonSaveCompanyCapacity start");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		
		if ((long)cabinetRestService.checkCabinetAdmin(request, user.getId()).get("code") != 0) {
			return "cmm/error/adminDenied";
		}
		
		String companyId       = request.getParameter("companyId") != null ? request.getParameter("companyId") : "";
		String newCapacity     = request.getParameter("capacity")  != null ? request.getParameter("capacity")  : "";
		String capacityType    = request.getParameter("type")      != null ? request.getParameter("type")      : "";
		JSONObject resultObj   = new JSONObject();
		
		if (companyId.equals("") || capacityType.equals("") || (capacityType.equals("1") && newCapacity.equals(""))) {
			resultObj.put("code", 1);
			resultObj.put("status", "error");
			return resultObj.toString();
		}
		
		resultObj = cabinetRestService.saveCompanyCapacity(request, capacityType, newCapacity, companyId);
		
		logger.debug("jsonSaveCompanyCapacity end");
		return resultObj.toString();
	}
	
	@RequestMapping(value="/admin/ezCabinet/getUserCapacity.do", method = RequestMethod.GET, produces = "application/text; charset=UTF-8")
	@ResponseBody
	public String jsonGetUserCapacity(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("jsonGetUserCapacity start");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		
		if ((long)cabinetRestService.checkCabinetAdmin(request, user.getId()).get("code") != 0) {
			return "cmm/error/adminDenied";
		}
		
		String companyId     = request.getParameter("companyId")   != null ? request.getParameter("companyId")   : "";
		String currPage      = request.getParameter("currentPage") != null ? request.getParameter("currentPage") : "";
		String searchStr     = request.getParameter("searchStr")   != null ? request.getParameter("searchStr")   : "";
		String searchOpt     = request.getParameter("searchOpt")   != null ? request.getParameter("searchOpt")   : "";
		String column        = request.getParameter("column")      != null ? request.getParameter("column")      : "";
		String order         = request.getParameter("order")       != null ? request.getParameter("order")       : "";
		String listCnt       = request.getParameter("listCnt")     != null ? request.getParameter("listCnt")     : "";
		
		JSONObject resultObj = new JSONObject();
		
		if (companyId.equals("") || currPage.equals("") || listCnt.equals("")) {
			resultObj.put("code", 1);
			resultObj.put("status", "error");
			return resultObj.toString();
		}
		
		resultObj = cabinetRestService.getUserCapacity(request, currPage, companyId, user.getId(), searchStr, searchOpt, column, order, listCnt);
		
		logger.debug("jsonGetUserCapacity end");
		return resultObj.toString();
	}
	
	@RequestMapping(value="/admin/ezCabinet/saveUserCapacity.do", method = RequestMethod.GET)
	@ResponseBody
	public String jsonSaveUserCapacity(@CookieValue("loginCookie") String loginCookie, @RequestParam(value = "userList") List<String> userList, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("jsonSaveUserCapacity start");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		
		if ((long)cabinetRestService.checkCabinetAdmin(request, user.getId()).get("code") != 0) {
			return "cmm/error/adminDenied";
		}
		
		String companyId       = request.getParameter("companyId") != null ? request.getParameter("companyId") : "";
		String newCapacity     = request.getParameter("capacity")  != null ? request.getParameter("capacity")  : "";
		String capacityType    = request.getParameter("type")      != null ? request.getParameter("type")      : "";
		JSONObject resultObj   = new JSONObject();
		
		if (companyId.equals("") || capacityType.equals("") || (capacityType.equals("1") && newCapacity.equals("")) || userList.size() == 0) {
			resultObj.put("code", 1);
			resultObj.put("status", "error");
			return resultObj.toString();
		}
		
		resultObj = cabinetRestService.saveUserCapacity(request, userList, capacityType, newCapacity, companyId);
		
		logger.debug("jsonSaveUserCapacity end");
		return resultObj.toString();
	}
	
	@RequestMapping(value="/admin/ezCabinet/saveUserDefaultCapacity.do", method = RequestMethod.GET)
	@ResponseBody
	public String jsonSaveUserDefaultCapacity(@CookieValue("loginCookie") String loginCookie, @RequestParam(value = "userList") List<String> userList, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("jsonSaveUserDefaultCapacity start");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		
		if ((long)cabinetRestService.checkCabinetAdmin(request, user.getId()).get("code") != 0) {
			return "cmm/error/adminDenied";
		}
		
		String companyId       = request.getParameter("companyId") != null ? request.getParameter("companyId") : "";
		JSONObject resultObj   = new JSONObject();
		
		if (companyId.equals("") || userList.size() == 0) {
			resultObj.put("code", 1);
			resultObj.put("status", "error");
			return resultObj.toString();
		}
		
		resultObj = cabinetRestService.saveUserDefaultCapacity(request, userList, companyId);
		
		logger.debug("jsonSaveUserDefaultCapacity end");
		return resultObj.toString();
	}
	
	@RequestMapping(value="/admin/ezCabinet/getModules.do", method = RequestMethod.GET)
	@ResponseBody
	public String jsonGetModules(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("jsonGetModules start");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		
		if ((long)cabinetRestService.checkCabinetAdmin(request, user.getId()).get("code") != 0) {
			return "cmm/error/adminDenied";
		}
		
		String companyId     = request.getParameter("companyId") != null ? request.getParameter("companyId") : "";
		JSONObject resultObj = new JSONObject();
		
		if (companyId.equals("")) {
			resultObj.put("code", 1);
			resultObj.put("status", "error");
			return resultObj.toString();
		}
		
		resultObj = cabinetRestService.getModuleListForAdmin(request, companyId);
		
		logger.debug("jsonGetModules end");
		return resultObj.toString();
	}
	
	@RequestMapping(value="/admin/ezCabinet/saveModules.do", method = RequestMethod.GET)
	@ResponseBody
	public String jsonSaveModulesSetting(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("jsonSaveModulesSetting start");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		
		if ((long)cabinetRestService.checkCabinetAdmin(request, user.getId()).get("code") != 0) {
			return "cmm/error/adminDenied";
		}
		
		String companyId     = request.getParameter("companyId") != null ? request.getParameter("companyId") : "";
		String moduleList    = request.getParameter("modules")   != null ? request.getParameter("modules")    : "";
		JSONObject resultObj = new JSONObject();
		
		if (companyId.equals("") || moduleList.equals("")) {
			resultObj.put("code", 1);
			resultObj.put("status", "error");
			return resultObj.toString();
		}
		
		ObjectMapper mapper = new ObjectMapper();
		JSONArray modules   = mapper.readValue(moduleList, new TypeReference<JSONArray>(){});
		resultObj           = cabinetRestService.saveModulesSetting(request, modules, companyId);
		
		logger.debug("jsonSaveModulesSetting end");
		return resultObj.toString();
	}
}
