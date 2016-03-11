package egovframework.ezEKP.ezEmail.web;

import java.util.Properties;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Controller
@RequestMapping("/ezEmail/mailList.do")
public class EzEMailMailListController {
	
	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;

	public String showMailList(HttpServletRequest request, Model model, LoginVO loginVO, HttpServletResponse response) throws Exception{
		return "ezEmail/mailList";
	}
	
}
