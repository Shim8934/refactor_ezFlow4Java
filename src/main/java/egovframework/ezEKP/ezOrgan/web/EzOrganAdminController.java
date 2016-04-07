package egovframework.ezEKP.ezOrgan.web;

import java.util.Properties;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Controller
public class EzOrganAdminController {
	
	@Autowired	
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
	@Autowired
	private EzOrganAdminService ezOrganAdminService;
	
	@RequestMapping(value = "/admin/ezOrgan/organMain.do")
	public String organMain() throws Exception{        
		return "admin/ezOrgan/organMain";
	}
	
	@RequestMapping(value = "/admin/ezOrgan/organLeft.do")
	public String organLeft() throws Exception{        
		return "admin/ezOrgan/organLeft";
	}
	
	@RequestMapping(value = "/admin/ezOrgan/organRight.do")
	public String organRight(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception{
		LoginVO user = commonUtil.userInfo(loginCookie);		
		//관리자 권한 체크
		if(user.getRollInfo().indexOf("c=1") == -1 && user.getRollInfo().indexOf("k=1") == -1){
			return "cmm/error/adminDenied";
		}
		
		String topid = "";
		
		if(user.getRollInfo().indexOf("c=1") == -1){
			topid = user.getCompanyID();
		}else{
			topid = "Top";
		}
		
		model.addAttribute("topid", topid);
		model.addAttribute("useOCS", config.getProperty("config.USE_OCS"));
		
		return "admin/ezOrgan/organRight";
	}
	
	@RequestMapping(value = "/admin/ezOrgan/companyInfo.do")
	public String companyInfo(Model model) throws Exception{
		String lang = config.getProperty("config.primary");		
		String primary = config.getProperty("config.lang_Primary" + lang);
		String secondary = config.getProperty("config.lang_Secondary" + lang);
		
		model.addAttribute("primary", primary);
		model.addAttribute("secondary", secondary);
		
		return "admin/ezOrgan/companyInfo";
	}
	
	@RequestMapping(value = "/admin/ezOrgan/saveCompanyInfo.do", produces = "text/html;charset=utf-8")	
	@ResponseBody
	public String saveCompanyInfo(HttpServletRequest request, HttpServletResponse response) throws Exception{
		String parentCn = request.getParameter("parentCn");
		String cn = request.getParameter("cn");
		String displayName = request.getParameter("displayName");
		String displayName2 = request.getParameter("displayName2");
		String domain = config.getProperty("config.DomainName");
		String result = "";
		String ldapPath = "";
		
		int cnt = ezOrganAdminService.companyCheck(cn);

		if(cnt > 0){
			result = "PRE";
		}else{
			String mailAddr = cn + "@" + domain;
			ezOrganAdminService.insertDBData_company(cn, displayName, displayName2, mailAddr, parentCn, ldapPath);
			
			result = "OK";
		}
		
		return result;
	}
	
	@RequestMapping(value = "/admin/ezOrgan/delDept.do", produces = "text/html;charset=utf-8")	
	@ResponseBody
	public String delDept(HttpServletRequest request, HttpServletResponse response) throws Exception{
		String cn = request.getParameter("cn");
		String pClass = "group";
		String result = "";
		
		int cnt = ezOrganAdminService.companyChildCheck(cn);
		
		if(cnt > 0){
			result = "HASCHILD";
		}else{			
			ezOrganAdminService.deleteDBData(cn, pClass);			
			result = "OK";
		}
		
		return result;
	}
	
	@RequestMapping(value = "/admin/ezOrgan/deptInfo.do")	
	public String deptInfo(Model model) throws Exception{
		String lang = config.getProperty("config.primary");		
		String primary = config.getProperty("config.lang_Primary" + lang);
		String secondary = config.getProperty("config.lang_Secondary" + lang);
		
		model.addAttribute("primary", primary);
		model.addAttribute("secondary", secondary);
		
		return "admin/ezOrgan/deptInfo";
	}
		
	@RequestMapping(value = "/admin/ezOrgan/getEntryInfo.do", produces = "text/xml;charset=utf-8")	
	@ResponseBody
	public String getEntryInfo(HttpServletRequest request, HttpServletResponse response) throws Exception{
		String cn = request.getParameter("cn");
		String proplist = request.getParameter("prop");		
	
		String infoXML = ezOrganAdminService.getPropertyList(cn, proplist, "1");		
		
		return infoXML;
	}	

}
