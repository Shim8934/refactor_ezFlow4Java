package egovframework.ezEKP.ezCabinet.web;

import java.util.Locale;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCabinet.service.EzCabinetService_m;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@SuppressWarnings("unchecked")
@RestController
public class EzCabinetGWController_m {
	private static final Logger logger = LoggerFactory.getLogger(EzCabinetGWController_m.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private EzCabinetService_m cabinetService_m;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Resource(name="loginService")
	private LoginService loginService;
	
	@RequestMapping(value="/rest/ezcabinet/relate-item/save/apprv", method=RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject saveRelatedApproval(@RequestBody JSONObject apprContent, Locale locale, HttpServletRequest request) throws Exception {
		String serverName      = request.getHeader("host-name") != null ? request.getHeader("host-name")          : "";
		String approvalContent = apprContent.get("content")     != null ? apprContent.get("content").toString()   : "";
		String userId          = apprContent.get("userId")      != null ? apprContent.get("userId").toString()    : "";
		String mode            = apprContent.get("mode")        != null ? apprContent.get("mode").toString()      : "";
		String title           = apprContent.get("title")       != null ? apprContent.get("title").toString()     : "";
		String summary         = apprContent.get("summary")     != null ? apprContent.get("summary").toString()   : "";
		String attach          = apprContent.get("attach")      != null ? apprContent.get("attach").toString()    : "";
		String other           = apprContent.get("other")       != null ? apprContent.get("other").toString()     : "";
		String cabinetId       = apprContent.get("cabinetId")   != null ? apprContent.get("cabinetId").toString() : "";
		JSONObject result      = new JSONObject();
		
		logger.debug("ServerName: " + serverName + " || Content: " + approvalContent + " || userId: " + userId + " || mode: " + mode+ " ||  cabinetId: " + cabinetId + " || doctitle: " + title + " || summary: " + summary + " || lstAttachLink: " + attach + " || otherAttachLk: " + other);
		
		if (serverName.equals("") || mode.equals("") || (mode.equals("1") && cabinetId.equals("")) || approvalContent.equals("") || userId.equals("") || mode.equals("") || title.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			int dstCabinetId = cabinetId.equals("") ? -1 : Integer.parseInt(cabinetId);
			String realPath  = request.getServletContext().getRealPath("");
			
			//Save approval item
			result           = cabinetService_m.saveApprovalItem(realPath, dstCabinetId, approvalContent, mode, title, summary, attach, other, locale, userInfo);
		}
		catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezcabinet/relate-item/save/jounl", method=RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject saveRelatedJournal(@RequestBody JSONObject jContent, Locale locale, HttpServletRequest request) throws Exception {
		String serverName      = request.getHeader("host-name")  != null ? request.getHeader("host-name")               : "";
		String userId          = jContent.get("userId")          != null ? jContent.get("userId").toString()            : "";
		String mode            = jContent.get("mode")            != null ? jContent.get("mode").toString()              : "";
		String cabinetId       = jContent.get("cabinetId")       != null ? jContent.get("cabinetId").toString()         : "";
		String title           = jContent.get("title")           != null ? jContent.get("title").toString()             : "";
		String summary         = jContent.get("summary")         != null ? jContent.get("summary").toString()           : "";
		String journalTitle    = jContent.get("journalTitle")    != null ? jContent.get("journalTitle").toString()      : "";
		String createDate      = jContent.get("createDate")      != null ? jContent.get("createDate").toString()        : ""; 
		String journalWriter   = jContent.get("journalWriter")   != null ? jContent.get("journalWriter").toString()     : ""; 
		String journalType     = jContent.get("journalType")     != null ? jContent.get("journalType").toString()       : ""; 
		String journalContent  = jContent.get("content")         != null ? jContent.get("content").toString()           : "";
		String formName        = jContent.get("formName")        != null ? jContent.get("formName").toString()          : ""; 
		String attach          = jContent.get("attach")          != null ? jContent.get("attach").toString()            : "";
		
		JSONObject result      = new JSONObject();
		
		logger.debug("ServerName : " + serverName + " || userId: " + userId + " || mode: " + mode + " || cabinetId: " + cabinetId + " || title: " + title + " || summary: " + summary + " || journalTitle: " + journalTitle + " || createDate: " + createDate + " || journalWriter: " + journalWriter + " || journalType: " + journalType + " || journalContent: " + journalContent + "|| formName: " + formName + "|| attach:" +  attach);
		
		if (serverName.equals("") || journalContent.equals("") || userId.equals("") || mode.equals("") || (mode.equals("1") && cabinetId.equals("")) || title.equals("") || journalTitle.equals("") || createDate.equals("") || journalWriter.equals("") || journalType.equals("") || formName.equals("")){
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			int dstCabinetId = cabinetId.equals("") ? -1 : Integer.parseInt(cabinetId);
			String realPath  = request.getServletContext().getRealPath("");
			
			//Save receiver list
			result           = cabinetService_m.saveJournalItem(realPath, dstCabinetId, title, summary, mode, journalTitle, createDate, journalWriter, journalType, journalContent, formName, attach, locale, userInfo);
		}
		catch(Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
}
