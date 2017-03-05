package egovframework.let.main.web;

import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;

import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Controller
public class EzMainAdminController {
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
	@Resource(name="EzCommonService")
	private EzCommonService ezCommonService;
	
	@RequestMapping(value="/admin/main.do")
	public String adminMain(HttpServletRequest request) throws Exception{		
		return "admin/adminMain";
	}
	
	@RequestMapping(value="/admin/top.do")
	public String adminTop(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception{
		LoginVO userInfo = commonUtil.userInfo(loginCookie); 
		
		String use_approvalG = config.getProperty("config.UserInfo_ApprovalG");
		String use_ezDMS = config.getProperty("config.Use_ezDMS");
		String use_portal = ezCommonService.getTenantConfig("Use_Portal", userInfo.getTenantId());
		
		String IsJMochaStandAlone = config.getProperty("config.IsJMochaStandAlone");
		String AdminActiveX = config.getProperty("config.AdminActiveX");

		model.addAttribute("use_approvalG", use_approvalG);
		model.addAttribute("use_ezDMS", use_ezDMS);
		model.addAttribute("use_portal", use_portal);
		model.addAttribute("IsJMochaStandAlone", IsJMochaStandAlone);
		model.addAttribute("AdminActiveX", AdminActiveX);
		
		return "admin/adminTop";
	}	
}
