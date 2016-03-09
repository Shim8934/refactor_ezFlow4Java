package egovframework.ezEKP.ezOrgan.web;

import java.util.Properties;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;

import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Controller
public class EzOrganController {
	
	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;
	
	@Autowired
	private EzOrganService ezOrganService;
	
	@RequestMapping(value = "/ezOrgan/getSIPUriList.do")
	public String  getSIPUriList(@CookieValue("userID") String userID, LoginVO loginVO, HttpServletRequest request, Model model) throws Exception{
		loginVO = commonUtil.userInfo(userID);
		String cnList = request.getParameter("cnList");
        String emailList = request.getParameter("emailList");
        String strRet = ezOrganService.getSIPUriList(cnList, emailList);
        
        model.addAttribute("strRet",strRet);
        
		return"json";
	}

}
