package egovframework.ezEKP.ezEmail.web;

import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.let.utl.fcc.service.CommonUtil;

@Controller
@RequestMapping("/ezEmail/mailList.do")
public class EzEmailMailListController {
	
	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;

    @Resource(name="egovMessageSource")
    private EgovMessageSource egovMessageSource;    
	
    private static final Logger logger = LoggerFactory.getLogger(EzEmailMailListController.class);
	
	@RequestMapping()
	public String showMailList(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception{
		logger.debug("showMailList started");
		
		List<String> userIdAndPassword = commonUtil.getUserIdAndPassword(loginCookie);
		String userId = userIdAndPassword.get(0);
		String password = userIdAndPassword.get(1);
		
		model.addAttribute("folderName", egovMessageSource.getMessage("ezEmail.t644"));
		model.addAttribute("isSentItems", true);
		model.addAttribute("listCount", "30");
		
		logger.debug("showMailList ended");
		
		return "ezEmail/mailList";
	}
	
}
