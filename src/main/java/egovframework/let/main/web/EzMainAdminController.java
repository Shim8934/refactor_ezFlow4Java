package egovframework.let.main.web;

import java.util.Properties;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class EzMainAdminController {

	@Autowired
	private Properties config;
	
	@RequestMapping(value="/admin/main.do")
	public String adminMain(HttpServletRequest request) throws Exception{		
		return "admin/adminMain";
	}
	
	@RequestMapping(value="/admin/top.do")
	public String adminTop(HttpServletRequest request, Model model) throws Exception{
		
		String use_approvalG = config.getProperty("config.UserInfo_ApprovalG");
		String use_ezKMS = config.getProperty("config.Use_ezKMS");
		String use_ezDMS = config.getProperty("config.Use_ezDMS");
		String use_portal = config.getProperty("config.Use_Portal");
		String use_mobileMgmt = config.getProperty("config.Use_MobileMgmt");
		String useJMochaUserRepository = config.getProperty("config.UseJMochaUserRepository");

		model.addAttribute("use_approvalG", use_approvalG);
		model.addAttribute("use_ezKMS", use_ezKMS);
		model.addAttribute("use_ezDMS", use_ezDMS);
		model.addAttribute("use_portal", use_portal);
		model.addAttribute("use_mobileMgmt", use_mobileMgmt);
		model.addAttribute("useJMochaUserRepository", useJMochaUserRepository);
		
		return "admin/adminTop";
	}	
}
