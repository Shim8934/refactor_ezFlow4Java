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
		String mode            = request.getParameter("mode")      != null ? request.getParameter("mode")      : "";
		String cabinetId       = request.getParameter("cabinetId") != null ? request.getParameter("cabinetId") : "";
		String content         = request.getParameter("content")   != null ? request.getParameter("content")   : "";
		String title           = request.getParameter("title")     != null ? request.getParameter("title")     : "";
		String summary         = request.getParameter("summary")   != null ? request.getParameter("summary")   : "";
		String attach          = request.getParameter("attach")    != null ? request.getParameter("attach")    : "";
		String other           = request.getParameter("other")     != null ? request.getParameter("other")     : "";
		JSONObject resultObj   = new JSONObject();
		
		logger.debug("Title: " + title + " || summary: " + summary + " || mode : " + mode + " || Content: " + content + " || Cabinet Id: " + cabinetId + " || Attach: " + attach + " || Other: " + other);
		
		if (content.equals("") || mode.equals("") || (mode.equals("1") && cabinetId.equals("")) || title.equals("")) {
			logger.debug("Invalid parameter!");
			resultObj.put("code", 1);
			resultObj.put("status", "error");
			return resultObj.toString();
		}
		
		resultObj = cabinetRestService_m.saveRelatedApproval(request, userInfo.getId(), mode, cabinetId, content, title, summary, attach, other);
		
		logger.debug("jsonSaveRelatedApproval finishes!");
		return resultObj.toString();
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/ezCabinet/saveRelatedJournal.do", method = RequestMethod.POST)
	@ResponseBody
	public String jsonSaveRelatedJournal(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, Model model, HttpServletResponse response) throws Exception{
		logger.debug("jsonSaveRelatedJournal is running!");
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String mode            = request.getParameter("mode")           != null? request.getParameter("mode")            : "";
		String cabinetId       = request.getParameter("cabinetId")      != null? request.getParameter("cabinetId")       : "";
		String title           = request.getParameter("title")          != null? request.getParameter("title")           : "";
		String summary         = request.getParameter("summary")        != null? request.getParameter("summary")         : "";
		String journalTitle    = request.getParameter("journalTitle")   != null? request.getParameter("journalTitle")    : "";
		String createDate      = request.getParameter("createDate")     != null? request.getParameter("createDate")      : "";
		String journalWriter   = request.getParameter("journalWriter")  != null? request.getParameter("journalWriter")   : "";
		String journalType     = request.getParameter("journalType")    != null? request.getParameter("journalType")     : "";
		String formName        = request.getParameter("formName")       != null? request.getParameter("formName")        : "";
		String content         = request.getParameter("content")        != null? request.getParameter("content")         : "";
		String attach          = request.getParameter("attach")         != null? request.getParameter("attach")          : "";
		JSONObject resultObj   = new JSONObject();
		
		logger.debug("mode: " + mode + " || cabinetId : " + cabinetId + " || title: " + title + " || summary: " + summary + " || journalTitle: " + journalTitle + " || createDate : " + createDate + " || journalWriter : " + journalWriter + " || journalType : " + journalType + " || formName : " + formName + " || content : " + content + " || attach: " + attach );
		if ((mode.equals("1") && cabinetId.equals("")) || title.equals("") || journalTitle.equals("") || createDate.equals("") || journalWriter.equals("") || journalType.equals("") || formName.equals("") || content.equals("") || mode.equals("")){
			logger.debug("Invalid parameter!");
			resultObj.put("code", 1);
			resultObj.put("status", "error");
			return resultObj.toString();
		}
		
		resultObj = cabinetRestService_m.saveRelatedJournal(request, userInfo.getId(), cabinetId, mode, title, summary, journalTitle, createDate, journalWriter, journalType, formName, content, attach);
		
		logger.debug("jsonSaveRelatedJournal finishes!");
		return resultObj.toString();
	}
	
	@RequestMapping(value="/ezCabinet/cabinetRelatedFileDetail.do")
	public String jspGetCabinetRelatedFileDetail(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) {
		logger.debug("jspGetCabinetFileDetail started");
		logger.debug("jspGetCabinetFileDetail ended");
		return "ezCabinet/cabinetFileDetail";
	}
}