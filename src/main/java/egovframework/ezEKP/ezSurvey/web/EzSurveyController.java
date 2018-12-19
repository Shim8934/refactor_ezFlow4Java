package egovframework.ezEKP.ezSurvey.web;

import java.io.File;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.UUID;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezSurvey.service.EzSurveyRestService;
import egovframework.let.user.login.vo.LoginSimpleVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.lang3.StringUtils;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@SuppressWarnings("unchecked")
@Controller
public class EzSurveyController extends EgovFileMngUtil {
	private static final Logger logger = LoggerFactory.getLogger(EzSurveyController.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private EzSurveyRestService surveyRestService;
	
	@Resource(name="EzCommonService")
	private EzCommonService ezCommonService;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@RequestMapping(value = "/ezSurvey/surveyMain.do")
	public String jspGetSurveyMain(@CookieValue("loginCookie") String loginCookie, HttpServletRequest req, Model model) {
		logger.debug("jspGetSurveyMain started");
		logger.debug("jspGetSurveyMain ended");
		return "ezSurvey/mainmenu/surveyMain";
	}
	
	@RequestMapping(value="/ezSurvey/surveyLeft.do")
	public String jspGetSurveyLeft(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception{
		logger.debug("jspGetSurveyLeft started");
		
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		
		logger.debug("jspGetSurveyLeft ended");
		return "ezSurvey/mainmenu/surveyLeft";
	}
	
	@RequestMapping(value="/ezSurvey/surveyConfig.do")
	public String jspGetSurveyConfig(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("jspGetSurveyConfig started");
		logger.debug("jspGetSurveyConfig ended");
		return "ezSurvey/config/surveyConfig";
	}
	
	
	@RequestMapping(value="/ezSurvey/surveyGeneral.do")
	public String jspGetSurveyGeneral(@CookieValue("loginCookie") String loginCookie,  HttpServletRequest request, Model model) throws Exception {
		logger.debug("jspGetSurveyGeneral started");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		
		JSONObject resultObj = surveyRestService.getUserPreviewConfig(request, user.getId());
		
		if (resultObj.get("status").toString().equals("ok")) {
			JSONObject userConfig = (JSONObject)resultObj.get("config");
			model.addAttribute("config", userConfig);
		}
		
		logger.debug("jspGetSurveyGeneral ended");
		return "ezSurvey/config/surveyGeneral";
	}
	
	@RequestMapping(value="/ezSurvey/surveyList.do")
	public String jspGetSurveyList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, Locale locale) throws Exception {
		logger.debug("jspGetSurveyList started");
		LoginSimpleVO user   = commonUtil.userInfoSimple(loginCookie);
		String mode          = request.getParameter("mode") != null ? request.getParameter("mode") : "1";
		String pageName      = "";
		JSONObject configObj = surveyRestService.getUserPreviewConfig(request, user.getId());
		
		if (configObj.get("status").toString().equals("ok")) {
			JSONObject userConfig = (JSONObject)configObj.get("config");
			model.addAttribute("config", userConfig);
		}
		
		switch(mode) {
			case "processing" : pageName = egovMessageSource.getMessage("ezSurvey.t02", locale); break;
			case "finish"     : pageName = egovMessageSource.getMessage("ezSurvey.t03", locale); break;
			case "my"         : pageName = egovMessageSource.getMessage("ezSurvey.t04", locale); break;
			case "draft"      : pageName = egovMessageSource.getMessage("ezSurvey.t05", locale); break;
		}
		
		model.addAttribute("pageName", pageName);
		model.addAttribute("mode"    , mode);
		
		logger.debug("jspGetSurveyList ended");
		return "ezSurvey/listmenu/surveyList";
	}
	
	@RequestMapping(value="/ezSurvey/createSurvey.do")
	public String jspGetCreateSurveyPage(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("jspGetCreateSurveyPage started");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		
		logger.debug("jspGetCreateSurveyPage ended");
		return "ezSurvey/listmenu/surveyCreate";
	}
	
	@RequestMapping(value="/ezSurvey/ReuseItem.do")
	public String jspGetReuseSurveyPage(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("jspGetReuseSurveyPage started");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		
		String itemId      = request.getParameter("") != null ? request.getParameter("") : "";
		
		if (itemId.equals("")) {
			model.addAttribute("reasonMessage", "ezCabinet.t160");
			return "ezSurvey/surveyAccessDenied";
		}
		
		List<String> itemList = new ArrayList<>();
		itemList.add(itemId);
		JSONObject checkObj = surveyRestService.checkSurveyItems(request, user.getId(), itemList);
		
		if (((Long)checkObj.get("code")).intValue() != 0) {
			int reasonCode = ((Long)checkObj.get("code")).intValue();
			String messageCode = "";
			
			switch(reasonCode) {
				case 1: messageCode = "ezSurvey.err1"; break;
				case 2: messageCode = "ezSurvey.err2"; break;
				case 3: messageCode = "ezSurvey.err3"; break;
			}
			
			model.addAttribute("reasonMessage", messageCode);
			return "ezSurvey/surveyAccessDenied";
		}
		
		logger.debug("jspGetReuseSurveyPage ended");
		return "ezSurvey/listmenu/surveyCreate";
	}
	
	@RequestMapping(value="/ezSurvey/statisticsPage.do")
	public String jspStatisticsPage(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("jspStatisticsPage started");
		
		logger.debug("jspStatisticsPage ended");
		return "ezSurvey/listmenu/statistics";
	}
	
	@RequestMapping(value="/ezSurvey/selectUsers.do")
	public String jspGetSelectUesrPage(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("jspGetSelectUesrPage started");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		
		JSONObject result = surveyRestService.getUserListType(request, user.getId());
		if (result.get("status").toString().equals("ok")) {
			String listType = (String)result.get("listType");
			model.addAttribute("listType", listType);
		}
		
		logger.debug("jspGetSelectUesrPage ended");
		return "ezSurvey/user/selectUser";
	}
	
	@RequestMapping(value="/ezSurvey/checkReusePermission.do")
	@ResponseBody
	public String jsonCheckItems(@CookieValue("loginCookie") String loginCookie, @RequestParam(value = "itemList") List<String> itemList, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("jsonCheckItems start");
		LoginSimpleVO user   = commonUtil.userInfoSimple(loginCookie);
		JSONObject resultObj = new JSONObject();
		
		if (itemList.size() == 0) {
			resultObj.put("code", 1);
			resultObj.put("status", "error");
			return resultObj.toString();
		}
		
		resultObj = surveyRestService.checkSurveyItems(request, user.getId(), itemList);
		
		logger.debug("jsonCheckItems end");
		return resultObj.toString();
	}
	
	@RequestMapping(value="/ezSurvey/saveSurvey.do", method = RequestMethod.POST, produces="application/json;charset=utf-8")
	@ResponseBody
	public String jsonSaveSurveyItem(@RequestBody JSONObject surveyItem, @CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("jsonSaveSurveyItem started");
		LoginSimpleVO user   = commonUtil.userInfoSimple(loginCookie);
		surveyItem.put("userId", user.getId());
		
		JSONObject resultObj = surveyRestService.saveSurveyItem(request, surveyItem);
		
		logger.debug("jsonSaveSurveyItem ended");
		return resultObj.toString();
	}
	
	@RequestMapping(value="/ezSurvey/deleteItems.do")
	@ResponseBody
	public String jsonDeleteItems(@CookieValue("loginCookie") String loginCookie, @RequestParam(value = "itemList") List<String> itemList, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("jsonDeleteItems start");
		LoginSimpleVO user   = commonUtil.userInfoSimple(loginCookie);
		JSONObject resultObj = new JSONObject();
		
		if (itemList.size() == 0) {
			resultObj.put("code", 1);
			resultObj.put("status", "error");
			return resultObj.toString();
		}
		
		resultObj = surveyRestService.deleteItems(request, user.getId(), itemList);
		
		logger.debug("jsonDeleteItems end");
		return resultObj.toString();
	}
	
	@RequestMapping(value="/ezSurvey/getSurveyItems.do")
	@ResponseBody
	public String jsonGetSurveyItems(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("jsonGetSurveyItems start");
		LoginSimpleVO user   = commonUtil.userInfoSimple(loginCookie);
		String currentPage   = request.getParameter("currentPage") != null ? request.getParameter("currentPage") : "";
		String pageMode      = request.getParameter("pageMode")    != null ? request.getParameter("pageMode")    : "";
		String title         = request.getParameter("title")       != null ? request.getParameter("title")       : "";
		String creatorName   = request.getParameter("creatorName") != null ? request.getParameter("creatorName") : "";
		String startDate     = request.getParameter("startDate")   != null ? request.getParameter("startDate")   : "";
		String endDate       = request.getParameter("endDate")     != null ? request.getParameter("endDate")     : "";
		String column        = request.getParameter("column")      != null ? request.getParameter("column")      : "";
		String order         = request.getParameter("order")       != null ? request.getParameter("order")       : "";
		String srchMode      = request.getParameter("srchMode")    != null ? request.getParameter("srchMode")    : "";
		String srchOption    = request.getParameter("srchOption")  != null ? request.getParameter("srchOption")  : "";
		String listCntSize   = request.getParameter("listCntSize") != null ? request.getParameter("listCntSize") : "";
		
		logger.debug("pageMode: " + pageMode + " || Title: " + title + " || Creator name: " + creatorName + " || Start Date: " + startDate + " || End Date: " + endDate + " || Column: " + column + " || Order: " + order + " || Search mode: " + srchMode + " || Search option: " + srchOption + " || List count: " + listCntSize + " || Current page: " + currentPage);
		
		JSONObject resultObj = new JSONObject();
		
		if (pageMode.equals("") || listCntSize.equals("") || currentPage.equals("")) {
			resultObj.put("code", 1);
			resultObj.put("status", "error");
			return resultObj.toString();
		}
		
		resultObj = surveyRestService.getSurveyItems(request, user.getId(), pageMode, title, creatorName, startDate, endDate, column, order, srchMode, srchOption, listCntSize, currentPage);
		
		logger.debug("jsonGetSurveyItems end");
		return resultObj.toString();
	}
	
	@RequestMapping(value="/ezSurvey/getCompanyTree.do")
	@ResponseBody
	public String jsonGetCompanyTree(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception{
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String companyId       = request.getParameter("companyId") != null ? request.getParameter("companyId") : "";
		JSONObject resultObj   = new JSONObject();
		
		resultObj = surveyRestService.getCompanyTree(request, userInfo.getId(), companyId);
		
		return resultObj.toString();
	}
	
	@RequestMapping(value="/ezSurvey/getSubNodes.do")
	@ResponseBody
	public String jsonGetSubNodes(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception{
		logger.debug("jsonGetSubNodes started");
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String deptId          = request.getParameter("nodeId") != null ? request.getParameter("nodeId") : "";
		String level           = request.getParameter("level")  != null ? request.getParameter("level")  : "";
		JSONObject resultObj   = new JSONObject();
		
		if (deptId.equals("") || level.equals("")) {
			logger.debug("Parameter error");
			resultObj.put("code", 1);
			resultObj.put("status", "error");
			return resultObj.toString();
		}
		
		resultObj = surveyRestService.getDeptSubNodes(request, userInfo.getId(), deptId, level);
		logger.debug("jsonGetSubNodes ended");
		
		return resultObj.toString();
	}
	
	@RequestMapping(value="/ezSurvey/getDeptMembers.do", method=RequestMethod.POST)
	@ResponseBody
	public String jsonGetDeptMembers(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("jsonGetDeptMembers started");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		String deptId      = request.getParameter("deptId")      != null ? request.getParameter("deptId")      : "";
		String currentPage = request.getParameter("currentPage") != null ? request.getParameter("currentPage") : "";
		
		logger.debug("deptId: " + deptId + " || currentPage: " + currentPage);
		
		JSONObject resultObj = new JSONObject();
		
		if (deptId.equals("") || currentPage.equals("")) {
			resultObj.put("code", 1);
			resultObj.put("status", "error");
			return resultObj.toString();
		}
		
		resultObj = surveyRestService.getDeptMembers(request, user.getId(), deptId, currentPage);
		
		logger.debug("jsonGetDeptMembers ended");
		logger.debug(resultObj.toString());
		return resultObj.toString();
	}
	
	@RequestMapping(value="/ezSurvey/getSearchMember.do", method=RequestMethod.POST)
	@ResponseBody
	public String jsonGetSearchMember(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("jsonGetSearchMember started");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		String srchOption  = request.getParameter("srchOption")  != null  ? request.getParameter("srchOption") : "";
		String srchValue   = request.getParameter("srchValue")   != null  ? request.getParameter("srchValue")  : "";
		String currentPage = request.getParameter("currentPage") != null ? request.getParameter("currentPage") : "";
		
		logger.debug("srchOption: " + srchOption + " || srchValue: " + srchValue + " || currentPage: " + currentPage);
		
		JSONObject resultObj = new JSONObject();
		
		if (srchOption.equals("") || srchValue.equals("") || currentPage.equals("")) {
			resultObj.put("code", 1);
			resultObj.put("status", "error");
			return resultObj.toString();
		}
		
		resultObj = surveyRestService.getSearchMember(request, user.getId(), srchOption, srchValue, currentPage);
		
		logger.debug("jsonGetSearchMember ended");
		logger.debug(resultObj.toString());
		return resultObj.toString();
	}
	
	@RequestMapping(value="/ezSurvey/uploadAttachFile.do", method = RequestMethod.POST)
	@ResponseBody
	public String jsonUploadFile(MultipartHttpServletRequest request, @CookieValue("loginCookie") String loginCookie, Model model, HttpServletResponse response) throws Exception {
		logger.debug("Upload file is running!");
		LoginSimpleVO userInfo         = commonUtil.userInfoSimple(loginCookie);
		List<MultipartFile> multiFiles = request.getFiles("fileToUpload");
		JSONObject resultObj           = new JSONObject();
		
		if (multiFiles.size() == 0) {
			resultObj.put("code", 1);
			resultObj.put("status", "error");
			return resultObj.toString();
		}
		
		resultObj = surveyRestService.uploadAttachFile(request, userInfo.getId(), multiFiles);
		
		logger.debug("Upload file finishes!");
		return resultObj.toString();
	}
	
	@RequestMapping(value="/ezSurvey/deleteAttachFile.do", method = RequestMethod.POST)
	@ResponseBody
	public String jsonDeleteFile(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, Model model, HttpServletResponse response) throws Exception {
		logger.debug("Delete file is running!");
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String filePath        = request.getParameter("filePath") != null ? request.getParameter("filePath") : "";
		JSONObject resultObj   = new JSONObject();
		
		if (filePath.equals("")) {
			resultObj.put("code", 1);
			resultObj.put("status", "error");
			return resultObj.toString();
		}
		
		resultObj = surveyRestService.deleteAttachFile(request, userInfo.getId(), filePath);
		
		logger.debug("Delete file finishes!");
		return resultObj.toString();
	}
	
	@RequestMapping(value="/ezSurvey/downloadAttachFile", produces="application/zip")
	public void responeDownloadFile(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, Model model, HttpServletResponse response) throws Exception {
		logger.debug("responeDownloadFile is running!");
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String filePath        = request.getParameter("filePath") != null ? request.getParameter("filePath") : "";
		String fileName        = request.getParameter("fileName") != null ? request.getParameter("fileName") : "";
		
		if (filePath.equals("") || fileName.equals("")) {
			logger.debug("Invalid arguments!!!");
			return;
		}
		
		surveyRestService.downloadAttachFile(request, response, userInfo.getId(), filePath, fileName);
		
		logger.debug("responeDownloadFile finishes!");
	}
	
	@RequestMapping(value="/ezSurvey/saveUserConfig.do")
	@ResponseBody
	public String jsonSaveUserConfig(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("jsonSaveUserConfig start");
		LoginSimpleVO user   = commonUtil.userInfoSimple(loginCookie);
		String prevMode      = request.getParameter("prevMode")  != null ? request.getParameter("prevMode")  : "";
		String listCount     = request.getParameter("listCount") != null ? request.getParameter("listCount") : "";
		String contentWPrev  = request.getParameter("contentW")  != null ? request.getParameter("contentW")  : "";
		String contentHPrev  = request.getParameter("contentH")  != null ? request.getParameter("contentH")  : "";
		JSONObject resultObj = new JSONObject();
		
		if (prevMode.equals("") || listCount.equals("") || (!prevMode.equals("off") && (contentWPrev.equals("") || contentHPrev.equals("")))) {
			resultObj.put("code", 1);
			resultObj.put("status", "error");
			return resultObj.toString();
		}
		
		resultObj = surveyRestService.saveUserConfig(request, user.getId(), prevMode, listCount, contentWPrev, contentHPrev);
		
		logger.debug("jsonSaveUserConfig end");
		return resultObj.toString();
	}
}
