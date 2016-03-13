package egovframework.ezEKP.ezEmail.web;

import java.util.Properties;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Controller
@RequestMapping("/ezEmail/mailList.do")
public class EzEmailMailListController {
	
	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;

    private static final Logger logger = LoggerFactory.getLogger(EzEmailMailListController.class);
	
	@RequestMapping()
	public String showMailList(HttpServletRequest request, Model model, LoginVO loginVO, HttpServletResponse response) throws Exception{
		logger.debug("showMailList started");
		
		model.addAttribute("folderName", "받은 편지함");
		
		logger.debug("showMailList ended");
		
		return "ezEmail/mailList";
	}
	
}
