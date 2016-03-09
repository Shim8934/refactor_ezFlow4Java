package egovframework.ezEKP.ezEmail.web;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class EzEmailController {
	
	@RequestMapping(value="/ezEmail/mailMain.do")
	public String showMailMain() throws Exception{		
		return "ezEmail/mailMain";
	}
	
	@RequestMapping(value="/ezEmail/mailLeft.do")
	public String showMailLeft() throws Exception{
		return "ezEmail/mailLeft";
	}
	
	@RequestMapping(value="/ezEmail/mailList.do")
	public String showMailList() throws Exception{
		return "ezEmail/mailList";
	}
}
