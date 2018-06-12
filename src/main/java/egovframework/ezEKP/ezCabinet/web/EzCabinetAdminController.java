package egovframework.ezEKP.ezCabinet.web;

import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import egovframework.ezEKP.ezCabinet.service.EzCabinetService;
import egovframework.ezEKP.ezCabinet.service.impl.EzCabinetServiceImpl;
import egovframework.let.user.login.vo.LoginSimpleVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Controller
public class EzCabinetAdminController {
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private EzCabinetService cabinetService;
	
	private static final Logger logger = LoggerFactory.getLogger(EzCabinetAdminController.class);
	
	@RequestMapping(value = "/admin/ezCabinet/cabinetAdminMain.do")
	public String jspAdminPage(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		
		if ((long)cabinetService.checkCabinetAdmin(request, user.getId()).get("code") != 0) {
			return "cmm/error/adminDenied";
		}
		
		return "admin/ezCabinet/adminMain";
	}
	
	@RequestMapping(value="/admin/ezcabinet/adminTop.do")
	public String jspAdminTop() throws Exception {
		return "admin/ezCabinet/cabinetAdminTop";
	}
	
	@RequestMapping(value="/admin/ezcabinet/cabinetAdminLeft.do")
	public String jspAdminLeft(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		
		if ((long)cabinetService.checkCabinetAdmin(request, user.getId()).get("code") != 0) {
			return "cmm/error/adminDenied";
		}
		
		return "admin/ezCabinet/cabinetAdminLeft";
	}
	
	@RequestMapping(value="/admin/ezCabinet/getBasicPage.do")
	public String jspGetBasicPage(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		
		if ((long)cabinetService.checkCabinetAdmin(request, user.getId()).get("code") != 0) {
			return "cmm/error/adminDenied";
		}
		
		JSONObject resultObj = cabinetService.getCompanyList(request, user.getId());
		String status        = resultObj.get("status").toString();
		
		if (status.equals("ok")) {
			String companyId      = (String) resultObj.get("userCompany");
			JSONArray companyList = (JSONArray) resultObj.get("data");
			model.addAttribute("userCompany", companyId);
			model.addAttribute("list", companyList);
		}
		
		return "admin/ezCabinet/cabinetBasicConfig";
	}
	
}
