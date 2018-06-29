package egovframework.ezEKP.ezCabinet.web;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class EzCabinetController_h {
	private static final Logger logger = LoggerFactory.getLogger(EzCabinetController_h.class);
	
	/**
	 * 캐비넷파일 상세내용 가져오기
	 * @param loginCookie
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/ezCabinet/cabinetFileDetail.do")
	public String jspGetCabinetFileDetail(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) {
		logger.debug("jspGetCabinetFileDetail started");
		logger.debug("jspGetCabinetFileDetail ended");
		return "ezCabinet/cabinetFileDetail";
	}
}
