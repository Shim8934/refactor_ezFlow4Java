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
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.ezEKP.ezCabinet.service.EzCabinetRestService_m;
import egovframework.let.user.login.vo.LoginSimpleVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Controller
public class EzCabinetController_m {
	private static final Logger logger = LoggerFactory.getLogger(EzCabinetController_m.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private EzCabinetRestService_m cabinetRestService_m;
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/ezCabinet/saveRelatedApproval.do", method = RequestMethod.POST)
	@ResponseBody
	public String jsonSaveRelatedApproval(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, Model model, HttpServletResponse response) throws Exception {
		logger.debug("jsonSaveRelatedApproval is running!");
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String mode            = request.getParameter("mode")             != null ? request.getParameter("mode")          : "";
		String cabinetId       = request.getParameter("cabinetId")        != null ? request.getParameter("cabinetId")     : "";
		String divContent      = request.getParameter("content")          != null ? request.getParameter("content")       : "";
		String doctitle        = request.getParameter("doctitle")         != null ? request.getParameter("doctitle")      : "";
		String lstAttachLink   = request.getParameter("lstAttachLink")    != null ? request.getParameter("lstAttachLink") : "";
		String otherAttachLk   = request.getParameter("otherAttachLk")    != null ? request.getParameter("otherAttachLk") : "";
		JSONObject resultObj   = new JSONObject();
		
		if (divContent.equals("") || (mode.equals("1") && cabinetId.equals("")) || (doctitle.equals("")) || (lstAttachLink.equals("")) || (otherAttachLk.equals(""))) {
			logger.debug("Invalid parameter!");
			resultObj.put("code", 1);
			resultObj.put("status", "error");
			return resultObj.toString();
		}
		
		resultObj = cabinetRestService_m.saveRelatedApproval(request, userInfo.getId(), mode, cabinetId, divContent, doctitle, lstAttachLink, otherAttachLk);
		
		logger.debug("jsonSaveRelatedApproval finishes!");
		return resultObj.toString();
	}
	
	@RequestMapping(value="/ezCabinet/cabinetRelatedFileDetail.do")
	public String jspGetCabinetRelatedFileDetail(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) {
		logger.debug("jspGetCabinetFileDetail started");
		logger.debug("jspGetCabinetFileDetail ended");
		return "ezCabinet/cabinetFileDetail";
	}
}