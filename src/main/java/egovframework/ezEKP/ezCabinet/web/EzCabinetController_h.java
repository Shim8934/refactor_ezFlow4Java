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
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.ezEKP.ezCabinet.service.EzCabinetRestService_h;
import egovframework.let.user.login.vo.LoginSimpleVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@SuppressWarnings("unchecked")
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
	@RequestMapping(value="/ezCabinet/cabinetFileDetail.do")
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
		LoginSimpleVO user   = commonUtil.userInfoSimple(loginCookie);
		String cabinetId     = request.getParameter("cabId");
			
		model.addAttribute("cabinetId", cabinetId);
		
		logger.debug("jspGetShareCabinetPage ended");
		return "ezCabinet/cabinetShare";
	}
	
	@RequestMapping(value="/ezCabinet/getDeptMembers.do", method=RequestMethod.POST)
	@ResponseBody
	public String jsonGetDeptMembers(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("jsonGetDeptMembers started");
		LoginSimpleVO user   = commonUtil.userInfoSimple(loginCookie);
		String deptId     = request.getParameter("deptId")       != null ? request.getParameter("deptId")           : "";
		String srchOption = request.getParameter("srchOption")   != null ? request.getParameter("srchOption")       : "";
		String srchValue  = request.getParameter("srchValue")    != null ? request.getParameter("srchValue")        : "";
		
		logger.debug("deptId: " + deptId + " || srchOption: " + srchOption + " || srchValue: " + srchValue);
		
		JSONObject resultObj = new JSONObject();
		
		if (deptId.equals("")) {
			resultObj.put("code", 1);
			resultObj.put("status", "error");
			return resultObj.toString();
		}
		
		resultObj = cabinetRestService_h.getDeptMembers(request, user.getId(), deptId, srchOption, srchValue);
		
		logger.debug("jsonGetDeptMembers ended");
		logger.debug(resultObj.toString());
		return resultObj.toString();
	}
	
	@RequestMapping(value="/ezCabinet/getShareUserList.do", method=RequestMethod.POST)
	@ResponseBody
	public String jsonGetShareUserList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("jsonGetShareUserList started");
		LoginSimpleVO user   = commonUtil.userInfoSimple(loginCookie);
		String cabinetId     = request.getParameter("cabinetId")   != null ? request.getParameter("cabinetId")   : "";
		
		logger.debug("CabinetId: " + cabinetId);
		
		JSONObject resultObj = new JSONObject();
		
		if (cabinetId.equals("")) {
			resultObj.put("code", 1);
			resultObj.put("status", "error");
			return resultObj.toString();
		}
		
		resultObj = cabinetRestService_h.getShareUserList(request, user.getId(), cabinetId);
		
		logger.debug("jsonGetShareUserList ended");
		return resultObj.toString();
	}
	
	
}
