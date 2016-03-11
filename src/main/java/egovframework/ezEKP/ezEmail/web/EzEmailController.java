package egovframework.ezEKP.ezEmail.web;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class EzEmailController {

	@RequestMapping(value="/ezEmail/mailMain.do")
	public String showMailMain() throws Exception{		
		return "ezEmail/mailMain";
	}

}
