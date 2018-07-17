package egovframework.ezEKP.ezCabinet.web;

import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;

import egovframework.ezEKP.ezCabinet.service.EzCabinetRestService_h;
import egovframework.let.user.login.vo.LoginSimpleVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Controller
public class EzCabinetController_h {
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private EzCabinetRestService_h cabinetRestService_h;
	
	private static final Logger logger = LoggerFactory.getLogger(EzCabinetController_h.class);
	
	/**
	 * 캐비넷파일 상세페이지
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
	
	/**
	 * 캐비넷 공유페이지 
	 * @param loginCookie
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/ezCabinet/shareCabinet.do")
	public String jspGetShareCabinetPage(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("jspGetShareCabinetPage started");
		LoginSimpleVO user     = commonUtil.userInfoSimple(loginCookie);
		String cabinetId       = request.getParameter("cabId");
	
		//회사아이디, 부서아이디 가져오기
		JSONObject resultObj   = cabinetRestService_h.getUserInfo(request, user.getId());
		
		if (resultObj.get("status").toString().equals("ok")) {
			JSONObject userInfo = (JSONObject) resultObj.get("data");
			model.addAttribute("userInfo", userInfo);
		}
			
		model.addAttribute("cabinetId", cabinetId);
		
		logger.debug("jspGetShareCabinetPage ended");
		return "ezCabinet/cabinetShare";
	}
	
}
