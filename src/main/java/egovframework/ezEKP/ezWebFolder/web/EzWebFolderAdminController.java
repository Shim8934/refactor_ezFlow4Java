package egovframework.ezEKP.ezWebFolder.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;

import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Controller
public class EzWebFolderAdminController extends EgovFileMngUtil {
	@Autowired
	private CommonUtil commonUtil;
	
	private static final Logger logger = LoggerFactory.getLogger(EzWebFolderAdminController.class);
	
	@RequestMapping(value = "/admin/ezWebFolder/webFolderConfig.do")
	public String webFolderConfig(@CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("webFolderConfig started");

		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}

		logger.debug("webFolderConfig ended");
		
		return "admin/ezWebFolder/webfolderConfig";
	}
	
	@RequestMapping(value="/admin/ezWebFolder/webfolderAdminLeft.do")
	public String webfolderAdminLeft(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, ModelMap modelMap, LoginVO userInfo, HttpServletResponse response) throws Exception{       
        userInfo = commonUtil.userInfo(loginCookie);
        //Add more function here
        
        
		return "admin/ezWebFolder/webfolderAdminLeft";
	}
	
	@RequestMapping(value="/admin/ezWebFolder/webfolderAdminRight.do")
	public String webfolderAdminRight(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, ModelMap modelMap, LoginVO userInfo, HttpServletResponse response) throws Exception{       
        userInfo = commonUtil.userInfo(loginCookie);
        //Add more function here
        
        
		return "admin/ezWebFolder/webfolderCompanyConfig";
	}
	
	@RequestMapping(value="/admin/ezWebFolder/webfolderAdminPersonal.do")
	public String webfolderAdminPersonal(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, LoginVO userInfo, HttpServletResponse response) throws Exception{       
        userInfo = commonUtil.userInfo(loginCookie);
        //Add more function here
        model.addAttribute("topid", "S907000");
		return "admin/ezWebFolder/webfolderPersonalConfig";
	}
	
	@RequestMapping(value="/admin/ezWebFolder/webfolderAdminGroup.do")
	public String webfolderAdminGroup(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, LoginVO userInfo, HttpServletResponse response) throws Exception{       
        userInfo = commonUtil.userInfo(loginCookie);
        //Add more function here
        
        model.addAttribute("companyID", "S907000");
        
		return "admin/ezWebFolder/webfolderGroupConfig";
	}
	
}
