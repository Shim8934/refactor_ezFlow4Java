package egovframework.ezEKP.ezCabinet.web;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.ezEKP.ezCabinet.service.EzCabinetRestService;
import egovframework.let.user.login.vo.LoginSimpleVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Controller
public class EzCabinetController_m {
	private static final Logger logger = LoggerFactory.getLogger(EzCabinetController_m.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private EzCabinetRestService cabinetRestService;
	
	@RequestMapping(value = "/ezCabinet/cabinetAddRelated.do")
	public String jspGetCabinetFileDetail(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) {
		logger.debug("jspGetCabinetFileDetail started");
		logger.debug("jspGetCabinetFileDetail ended");
		return "ezCabinet/cabinetAddRelated";
	}
	
}