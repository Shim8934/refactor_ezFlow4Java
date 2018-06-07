package egovframework.ezEKP.ezCabinet.web;

import javax.servlet.http.HttpServletRequest;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import egovframework.ezEKP.ezCabinet.service.EzCabinetService;
import egovframework.let.user.login.vo.LoginSimpleVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Controller
public class EzCabinetAdminController {
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private EzCabinetService cabinetService;
	
	private static final Logger logger = LoggerFactory.getLogger(EzCabinetAdminController.class);
	
	@RequestMapping(value = "/admin/ezCabinet/cabinetAdminMain.do")
	public String jspAdminPage(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		
		if (!cabinetService.checkCabinetAdmin(request, user.getId()).get("result").toString().equals("ok")) {
			return "cmm/error/adminDenied";
		}
		
		return "admin/ezCabinet/adminMain";
	}
	
	@RequestMapping(value="/admin/ezcabinet/adminTop.do")
	public String jspAdminTop() throws Exception {
		return "admin/ezCabinet/cabinetAdminTop";
	}
}
