package egovframework.ezEKP.ezCabinet.web;

import javax.servlet.http.HttpServletRequest;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import egovframework.ezEKP.ezCabinet.service.EzCabinetRestService;
import egovframework.let.user.login.vo.LoginSimpleVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Controller
public class EzCabinetAdminController {
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private EzCabinetRestService cabinetRestService;
	
	private static final Logger logger = LoggerFactory.getLogger(EzCabinetAdminController.class);
	
	@RequestMapping(value = "/admin/ezCabinet/cabinetAdminMain.do")
	public String jspAdminPage(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("jspAdminPage start");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		
		if ((long)cabinetRestService.checkCabinetAdmin(request, user.getId()).get("code") != 0) {
			return "cmm/error/adminDenied";
		}
		
		logger.debug("jspAdminPage end");
		return "admin/ezCabinet/adminMain";
	}
	
	@RequestMapping(value="/admin/ezcabinet/adminTop.do")
	public String jspAdminTop() throws Exception {
		logger.debug("jspAdminTop start");
		logger.debug("jspAdminTop end");
		return "admin/ezCabinet/cabinetAdminTop";
	}
	
	@RequestMapping(value="/admin/ezcabinet/cabinetAdminLeft.do")
	public String jspAdminLeft(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("jspAdminLeft start");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		
		if ((long)cabinetRestService.checkCabinetAdmin(request, user.getId()).get("code") != 0) {
			return "cmm/error/adminDenied";
		}
		
		logger.debug("jspAdminLeft end");
		return "admin/ezCabinet/cabinetAdminLeft";
	}
	
	@RequestMapping(value="/admin/ezCabinet/getBasicPage.do")
	public String jspGetBasicPage(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("jspGetBasicPage start");
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
		
		logger.debug("jspGetBasicPage end");
		return "admin/ezCabinet/cabinetBasicConfig";
	}
	
	@RequestMapping(value="/admin/ezCabinet/getPersonalPage.do")
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
	
	@RequestMapping(value="/admin/ezCabinet/getRelatedCabinetConfig.do")
	public String jspGetRelatedCabinetConfig(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("jspGetRelatedCabinetConfig start");
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
		
		logger.debug("jspGetRelatedCabinetConfig end");
		return "admin/ezCabinet/cabinetAdminInterLock";
	}
	
}
