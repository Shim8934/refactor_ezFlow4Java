package egovframework.ezEKP.ezApprovalG.web;

import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;

import egovframework.ezEKP.ezApprovalG.service.EzApprovalGService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Controller
public class EzApprovalGController {
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
	@Autowired
	private Properties globals;

	@Resource(name="EzApprovalGService")
	private EzApprovalGService ezApprovalGService;
	
	@RequestMapping(value = "/ezApprovalG/apprGMain.do")
	public String apprGMain(HttpServletRequest request, Model model){
		int listType = 1;
		
		if (request.getParameter("listType") != null) {
			listType = Integer.parseInt(request.getParameter("listType"));
		}
		
		model.addAttribute("listType", listType);
		
		return "ezApprovalG/apprGMain";
	}

	@RequestMapping(value = "/ezApprovalG/apprGLeft.do")
	public String apprGLeft(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginVO userInfo) throws Exception{
		String userEnforce = config.getProperty("config.UserInfo_Enforce");
		String viewLeftCount = config.getProperty("config.APPROVLEFTCOUNT");
		String listType = request.getParameter("listType");
		
		userInfo = commonUtil.userInfo(loginCookie);
		
		return "ezApprovalG/apprGLeft";
	}
}
