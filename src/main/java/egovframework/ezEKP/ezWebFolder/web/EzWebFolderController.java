package egovframework.ezEKP.ezWebFolder.web;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.w3c.dom.Document;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezBoard.vo.BoardVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Controller
public class EzWebFolderController {
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Resource(name = "egovMessageSource")
    private EgovMessageSource egovMessageSource;
	
	@RequestMapping(value = "/ezWebFolder/webfolderMain.do")
	public String webfolderMain(HttpServletRequest req, Model model) {
/*		String func = "";
		String subFunc = "";

		if (req.getParameter("func") != null && !req.getParameter("func").equals("")) {
			func = req.getParameter("func");	
		}
		if (req.getParameter("subFunc") != null && !req.getParameter("subFunc").equals("")) {
			subFunc = req.getParameter("subFunc");	
		}
		
		model.addAttribute("func", func);
		model.addAttribute("subFunc", subFunc);*/
		
		return "ezWebFolder/webfolderMain";
	}
	
	@RequestMapping(value="/ezWebFolder/webfolderLeft.do")
	public String webfolderLeft(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, ModelMap modelMap, LoginVO userInfo, HttpServletResponse response) throws Exception{       
        userInfo = commonUtil.userInfo(loginCookie);
        //Add more function here
        
        
		return "ezWebFolder/webfolderLeft";
	}
}
