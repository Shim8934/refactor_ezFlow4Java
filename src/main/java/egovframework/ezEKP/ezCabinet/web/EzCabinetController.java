package egovframework.ezEKP.ezCabinet.web;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import egovframework.ezEKP.ezCabinet.service.EzCabinetService;
import egovframework.let.user.login.vo.LoginSimpleVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Controller
public class EzCabinetController {
	private static final Logger logger = LoggerFactory.getLogger(EzCabinetController.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private EzCabinetService cabinetService;
	
	@RequestMapping(value = "/ezCabinet/cabinetMain.do")
	public String cabinetMain(@CookieValue("loginCookie") String loginCookie, HttpServletRequest req, Model model) {
		return "ezCabinet/cabinetMain";
	}
	
	@RequestMapping(value="/ezCabinet/cabinetLeft.do")
	public String cabinetLeft(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception{
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		if ((long)cabinetService.checkCabinetAdmin(request, userInfo.getId()).get("code") != 0) {
			model.addAttribute("isCabinetAdmin", "0");
		}
		else {
			model.addAttribute("isCabinetAdmin", "1");
		}
		
		return "ezCabinet/cabinetLeft";
	}
	
}
