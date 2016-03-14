package egovframework.ezEKP.ezCommon.web;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * 공통적으로 사용되는 메소드 집합 Controller
 */
@Controller
public class EzCommonController {
	
	@RequestMapping(value = "/ezCommon/.do")
	public String getMgtMainPage(HttpServletRequest request, ModelMap model) throws Exception{		
		return "main/main";
	}

}