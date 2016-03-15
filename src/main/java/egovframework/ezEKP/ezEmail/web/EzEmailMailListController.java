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
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezEmail.vo.MailGeneralVO;
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

    @Resource(name="EzEmailService")
    private EzEmailService ezEmailService;    
    
    private static final Logger logger = LoggerFactory.getLogger(EzEmailMailListController.class);
	
	@RequestMapping()
	public String showMailList(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception{
		logger.debug("showMailList started");
		
		List<String> userIdAndPassword = commonUtil.getUserIdAndPassword(loginCookie);
		String userId = userIdAndPassword.get(0);
		String password = userIdAndPassword.get(1);
		String folderName = egovMessageSource.getMessage("ezEmail.t644");
		String folderType = "";
		String userLang ="1";
		
		if (folderName.equals(egovMessageSource.getMessage("ezEmail.t645"))) {
			folderType = "sent";
		}
		else if (folderName.equals(egovMessageSource.getMessage("ezEmail.t646"))) {
			folderType = "draft";
		}
		else if (folderName.equals(egovMessageSource.getMessage("ezEmail.t647"))) {
			folderType = "delete";
		}
		
		MailGeneralVO mailGeneral = null;
		List<MailGeneralVO> mailGeneralList = ezEmailService.getMailGeneral(userId);
		if (mailGeneralList.size() > 0) {
			mailGeneral = mailGeneralList.get(0);
			logger.debug("userId=" + userId + ",mailGeneral=" + mailGeneral);
		}
		
		model.addAttribute("folderName", folderName);
		model.addAttribute("folderType", folderType);
		model.addAttribute("isSentItems", true);
		model.addAttribute("listCount", "30");
		model.addAttribute("userLang", userLang);
		model.addAttribute("userId", userId);
		model.addAttribute("mailGeneral", mailGeneral);
		
		logger.debug("showMailList ended");
		
		return "ezEmail/mailList";
	}
	
}
