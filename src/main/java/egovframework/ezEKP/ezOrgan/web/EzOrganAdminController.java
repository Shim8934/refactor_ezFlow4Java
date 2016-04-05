package egovframework.ezEKP.ezOrgan.web;

import java.util.Properties;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;

import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Controller
public class EzOrganAdminController {
	
	@Autowired	
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
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

}
