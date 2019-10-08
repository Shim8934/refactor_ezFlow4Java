package egovframework.ezEKP.ezSurvey.web;

import java.io.PrintWriter;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.stream.Collectors;

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
import egovframework.ezEKP.ezSurvey.vo.OptionVO;
import egovframework.ezEKP.ezSurvey.vo.QuestionVO;
import egovframework.ezEKP.ezSurvey.vo.ResponseVO;
import egovframework.let.user.login.vo.LoginSimpleVO;
import egovframework.let.utl.fcc.service.CommonUtil;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.util.CellRangeAddress;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;

@SuppressWarnings("unchecked")
@Controller
public class EzSurveyController extends EgovFileMngUtil {
	private static final Logger logger = LoggerFactory.getLogger(EzSurveyController.class);

	private static final String JSONObject = null;
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private EzSurveyRestService surveyRestService;
	
	@Resource(name="EzCommonService")
	private EzCommonService ezCommonService;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@RequestMapping(value = "/ezSurvey/surveyMain.do", method = RequestMethod.GET)
	public String jspGetSurveyMain(@CookieValue("loginCookie") String loginCookie, HttpServletRequest req, Model model) {
		logger.debug("jspGetSurveyMain started");
		logger.debug("jspGetSurveyMain ended");
		return "ezSurvey/mainmenu/surveyMain";
	}
	
	@RequestMapping(value="/ezSurvey/surveyLeft.do", method = RequestMethod.GET)
	public String jspGetSurveyLeft(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception{
		logger.debug("jspGetSurveyLeft started");
		LoginSimpleVO user   = commonUtil.userInfoSimple(loginCookie);
		JSONObject resultObj = surveyRestService.getUserInformation(request, user.getId());
		logger.debug(resultObj.toJSONString());
		
		if (resultObj.get("status").toString().equals("ok")) {
			int userMode = ((Long)resultObj.get("mode")).intValue();
			model.addAttribute("mode", userMode);
		}
		
		logger.debug("jspGetSurveyLeft ended");
		return "ezSurvey/mainmenu/surveyLeft";
	}
	
	@RequestMapping(value="/ezSurvey/surveyConfig.do", method = RequestMethod.GET)
	public String jspGetSurveyConfig(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("jspGetSurveyConfig started");
		logger.debug("jspGetSurveyConfig ended");
		return "ezSurvey/config/surveyConfig";
	}
	
	@RequestMapping(value="/ezSurvey/surveyGeneral.do", method = RequestMethod.GET)
	public String jspGetSurveyGeneral(@CookieValue("loginCookie") String loginCookie,  HttpServletRequest request, Model model) throws Exception {
		logger.debug("jspGetSurveyGeneral started");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		
		JSONObject resultObj = surveyRestService.getUserPreviewConfig(request, user.getId());
		logger.debug(resultObj.toJSONString());
		
		if (resultObj.get("status").toString().equals("ok")) {
			JSONObject userConfig = (JSONObject)resultObj.get("config");
			model.addAttribute("config", userConfig);
		}
		
		logger.debug("jspGetSurveyGeneral ended");
		return "ezSurvey/config/surveyGeneral";
	}
	
	@RequestMapping(value="/ezSurvey/surveyList.do", method = RequestMethod.GET)
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
		
		JSONObject resultObj = surveyRestService.getUserInformation(request, user.getId());
		
		if (resultObj.get("status").toString().equals("ok")) {
			int userMode = ((Long)resultObj.get("mode")).intValue();
			model.addAttribute("reuseFlag", userMode);
		}
		
		switch(mode) {
			case "all"        : pageName = egovMessageSource.getMessage("ezSurvey.t80", locale); break;
			case "processing" : pageName = egovMessageSource.getMessage("ezSurvey.t02", locale); break;
			case "finish"     : pageName = egovMessageSource.getMessage("ezSurvey.t03", locale); break;
			case "my"         : pageName = egovMessageSource.getMessage("ezSurvey.t04", locale); break;
			case "draft"      : pageName = egovMessageSource.getMessage("ezSurvey.t05", locale); break;
		}
		
		model.addAttribute("pageName", pageName);
		model.addAttribute("mode"    , mode);
		model.addAttribute("user"    , user.getId());
		
		logger.debug("jspGetSurveyList ended");
		return "ezSurvey/listmenu/surveyList";
	}
	
	@RequestMapping(value="/ezSurvey/createSurvey.do", method = RequestMethod.GET)
	public String jspGetCreateSurveyPage(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("jspGetCreateSurveyPage started");
		logger.debug("jspGetCreateSurveyPage ended");
		return "ezSurvey/listmenu/surveyCreate";
	}
	
	@RequestMapping(value="/ezSurvey/reuseItem.do", method = RequestMethod.GET)
	public String jspGetReuseSurveyPage(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("jspGetReuseSurveyPage started");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		String itemId      = request.getParameter("itemId") != null ? request.getParameter("itemId") : "";
		
		if (itemId.equals("")) {
			model.addAttribute("reasonMessage", "ezSurvey.err1");
			return "ezSurvey/surveyAccessDenied";
		}
		
		JSONObject surveyInf = surveyRestService.getSurveyInformation(request, user.getId(), itemId, "reuse");
		
		if (((Long)surveyInf.get("code")).intValue() == 0) {
			JSONObject survey = (JSONObject)surveyInf.get("survey");
			survey.put("modifyFlag", 0);
			model.addAttribute("survey", survey);
		}
		else {
			int reasonCode = ((Long)surveyInf.get("code")).intValue();
			String messageCode = "";
			
			switch(reasonCode) {
				case 1 : messageCode = "ezSurvey.err1"; break;
				case 2 : messageCode = "ezSurvey.err2"; break;
				case 3 : messageCode = "ezSurvey.err3"; break;
				default: messageCode = "ezSurvey.err1"; break;
			}
			
			model.addAttribute("reasonMessage", messageCode);
			return "ezSurvey/surveyAccessDenied";
		}
		
		logger.debug("jspGetReuseSurveyPage ended");
		return "ezSurvey/listmenu/surveyCreate";
	}
	
	@RequestMapping(value="/ezSurvey/modifyItem.do", method = RequestMethod.GET)
	public String jspGetModifySurveyPage(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("jspGetModifySurveyPage started");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		String itemId      = request.getParameter("itemId") != null ? request.getParameter("itemId") : "";
		
		if (itemId.equals("")) {
			model.addAttribute("reasonMessage", "ezSurvey.err1");
			return "ezSurvey/surveyAccessDenied";
		}
		
		JSONObject surveyInf = surveyRestService.getSurveyInformation(request, user.getId(), itemId, "modify");
		
		if (((Long)surveyInf.get("code")).intValue() == 0) {
			JSONObject survey = (JSONObject)surveyInf.get("survey");
			survey.put("modifyFlag", 1);
			model.addAttribute("survey", survey);
		}
		else {
			int reasonCode = ((Long)surveyInf.get("code")).intValue();
			String messageCode = "";
			
			switch(reasonCode) {
				case 1:  messageCode = "ezSurvey.err1"; break;
				case 2:  messageCode = "ezSurvey.err2"; break;
				case 3:  messageCode = "ezSurvey.err3"; break;
				default: messageCode = "ezSurvey.err1"; break;
			}
			
			model.addAttribute("reasonMessage", messageCode);
			return "ezSurvey/surveyAccessDenied";
		}
		
		logger.debug("jspGetModifySurveyPage ended");
		return "ezSurvey/listmenu/surveyCreate";
	}
	
	@RequestMapping(value="/ezSurvey/surveyDetail.do", method = RequestMethod.GET)
	public String jspGetSurveyDetail(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("jspGetSurveyDetail started");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		String itemId      = request.getParameter("itemId") != null ? request.getParameter("itemId") : "";
		String mode        = request.getParameter("mode")   != null ? request.getParameter("mode")   : "";
		
		if (itemId.equals("")) {
			model.addAttribute("reasonMessage", "ezSurvey.err1");
			return "ezSurvey/surveyAccessDenied";
		}
		
		JSONObject surveyInf = surveyRestService.getSurveyInformation(request, user.getId(), itemId, "normal");
		
		if (((Long)surveyInf.get("code")).intValue() == 0) {
			JSONObject survey        = (JSONObject)surveyInf.get("survey");
			JSONObject creator       = (JSONObject)surveyInf.get("creator");
			String     participation = (String)surveyInf.get("participation");
			model.addAttribute("survey" , survey);
			model.addAttribute("creator", creator);
			model.addAttribute("participation", participation);
		}
		else {
			int reasonCode = ((Long)surveyInf.get("code")).intValue();
			String messageCode = "";
			
			switch(reasonCode) {
				case 1 : messageCode = "ezSurvey.err1"; break;
				case 2 : messageCode = "ezSurvey.err2"; break;
				case 3 : messageCode = "ezSurvey.err3"; break;
				default: messageCode = "ezSurvey.err1"; break;
			}
			
			model.addAttribute("reasonMessage", messageCode);
			return "ezSurvey/surveyAccessDenied";
		}
		
		model.addAttribute("user", user.getId());
		model.addAttribute("mode", mode);
		logger.debug("jspGetSurveyDetail ended");
		
		return "ezSurvey/listmenu/surveyDetail";
	}
	
	@RequestMapping(value="/ezSurvey/showStatisticInfo.do", method = RequestMethod.GET)
	public String jspGetStatisticsPage(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("jspGetStatisticsPage started");
		LoginSimpleVO user    = commonUtil.userInfoSimple(loginCookie);
		String itemId         = request.getParameter("surveyId") != null ? request.getParameter("surveyId") : "";
		JSONObject result     = surveyRestService.getSurveyStatistic(request, user.getId(), itemId);
		
		if (((Long)result.get("code")).intValue() != 0) {
			int reasonCode     = ((Long)result.get("code")).intValue();
			String messageCode = "";
			
			switch(reasonCode) {
				case 1 : messageCode = "ezSurvey.err1"; break;
				case 2 : messageCode = "ezSurvey.err2"; break;
				case 3 : messageCode = "ezSurvey.err3"; break;
				case 6 : messageCode = "ezSurvey.err6"; break;
				case 7 : messageCode = "ezSurvey.err7"; break;
				default: messageCode = "ezSurvey.err1"; break;
			}
			
			model.addAttribute("reasonMessage", messageCode);
			return "ezSurvey/surveyAccessDenied";
		}
		else {
			String adminYN         = (String) result.get("adminYN");
			JSONObject surveyData  = (JSONObject)result.get("data");
			JSONArray questionData = (JSONArray)result.get("questions");
			model.addAttribute("adminYN"  , adminYN);
			model.addAttribute("data"     , surveyData);
			model.addAttribute("questions", questionData);
		}
		
		logger.debug("jspGetStatisticsPage ended");
		return "ezSurvey/listmenu/statistics";
	}
	
	@RequestMapping(value="/ezSurvey/selectUsers.do", method = RequestMethod.GET)
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
	
	@RequestMapping(value="/ezSurvey/getSurveyQuestions.do", method = RequestMethod.GET)
	@ResponseBody
	public String jsonGetSurveyQuestions(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("jsonGetSurveyQuestions start");
		LoginSimpleVO user   = commonUtil.userInfoSimple(loginCookie);
		String itemId        = request.getParameter("surveyId") != null ? request.getParameter("surveyId") : "";
		String logicMode     = request.getParameter("logic")    != null ? request.getParameter("logic")    : "";
		JSONObject resultObj = new JSONObject();
		
		if (itemId.equals("")) {
			resultObj.put("code", 1);
			resultObj.put("status", "error");
			return resultObj.toString();
		}
		
		resultObj = surveyRestService.getSurveyQuestions(request, user.getId(), itemId, logicMode);
		
		logger.debug("jsonGetSurveyQuestions end");
		return resultObj.toString();
	}
	
	@RequestMapping(value="/ezSurvey/changeSurveyState.do", method = RequestMethod.GET)
	@ResponseBody
	public String jsonChangeSurveyState(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("jsonChangeSurveyState start");
		LoginSimpleVO user   = commonUtil.userInfoSimple(loginCookie);
		JSONObject resultObj = new JSONObject();
		String itemId        = request.getParameter("surveyId") != null ? request.getParameter("surveyId") : "";
		
		if (itemId.equals("")) {
			resultObj.put("code", 1);
			resultObj.put("status", "error");
			return resultObj.toString();
		}
		
		resultObj = surveyRestService.changeSurveyState(request, user.getId(), itemId);
		
		logger.debug("jsonChangeSurveyState end");
		return resultObj.toString();
	}
	
	@RequestMapping(value="/ezSurvey/checkReusePermission.do", method = RequestMethod.POST)
	@ResponseBody
	public String jsonCheckItems(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("jsonCheckItems start");
		LoginSimpleVO user   = commonUtil.userInfoSimple(loginCookie);
		JSONObject resultObj = surveyRestService.checkSurveyItems(request, user.getId());
		
		logger.debug("jsonCheckItems end");
		return resultObj.toString();
	}
	
	@RequestMapping(value="/ezSurvey/checkProcessingSurvey.do", method = RequestMethod.GET)
	@ResponseBody
	public String jsonCheckProcessingSurvey(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("jsonCheckItems start");
		LoginSimpleVO user   = commonUtil.userInfoSimple(loginCookie);
		JSONObject resultObj = new JSONObject();
		String itemId        = request.getParameter("surveyId") != null ? request.getParameter("surveyId") : "";
		
		if (itemId.equals("")) {
			resultObj.put("code", 1);
			resultObj.put("status", "error");
			return resultObj.toString();
		}
		
		resultObj = surveyRestService.checkProcessingSurvey(request, user.getId(), itemId);
		
		logger.debug("jsonCheckItems end");
		return resultObj.toString();
	}
	
	@RequestMapping(value="/ezSurvey/checkAnalysisPermission.do", method = RequestMethod.GET)
	@ResponseBody
	public String jsonCheckAnalysisPermission (@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("jsonCheckAnalysisPermission start");

		LoginSimpleVO user    = commonUtil.userInfoSimple(loginCookie);
		String itemId         = request.getParameter("surveyId") != null ? request.getParameter("surveyId") : "";
		JSONObject result     = surveyRestService.getSurveyStatistic(request, user.getId(), itemId);
		JSONObject resultObj  = new JSONObject();

		int reasonCode  = ((Long)result.get("code")).intValue();
		String adminYN  = ((String)result.get("adminYN"));
		int messageCode = 0;
		switch(reasonCode) {
			case 1 : messageCode = 1; break; // parameter 부족합니다
			case 2 : messageCode = 2; break; // 오류가 발생했습니다.
			case 3 : messageCode = 3; break; // 권한이 없습니다.
			case 6 : messageCode = 4; break; // 이 설문은 결과를 공개하지 않습니다.
			case 7 : messageCode = 5; break; // 공개기간이 아닙니다.
			default: messageCode = 0; break; // (결과분석)
		}
		if(adminYN.equals("Y")) messageCode = 0;
		resultObj.put("code", messageCode);

		logger.debug("jsonCheckAnalysisPermission end");
		return resultObj.toString();
	}
	
	@RequestMapping(value="/ezSurvey/saveSurvey.do", method = RequestMethod.POST)
	@ResponseBody
	public String jsonSaveSurveyItem(@RequestBody JSONObject surveyItem, @CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("jsonSaveSurveyItem started");
		LoginSimpleVO user   = commonUtil.userInfoSimple(loginCookie);
		surveyItem.put("userId", user.getId());
		
		JSONObject resultObj = surveyRestService.saveSurveyItem(request, surveyItem);
		
		logger.debug("jsonSaveSurveyItem ended");
		return resultObj.toString();
	}
	
	@RequestMapping(value="/ezSurvey/deleteItems.do", method = RequestMethod.GET)
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
	
	@RequestMapping(value="/ezSurvey/getSurveyItems.do", method = RequestMethod.GET)
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
		JSONObject userObj = surveyRestService.getUserInformation(request, user.getId());
		int userMode = 0;
		
		if (userObj.get("status").toString().equals("ok")) {
			userMode = ((Long)userObj.get("mode")).intValue();
		}
		
		logger.debug("pageMode: " + pageMode + " || Title: " + title + " || Creator name: " + creatorName + " || Start Date: " + startDate + " || End Date: " + endDate + " || Column: " + column + " || Order: " + order + " || Search mode: " + srchMode + " || Search option: " + srchOption + " || List count: " + listCntSize + " || Current page: " + currentPage + " || userMode: " + userMode);
		
		JSONObject resultObj = new JSONObject();
		
		if (pageMode.equals("") || listCntSize.equals("") || currentPage.equals("")) {
			resultObj.put("code", 1);
			resultObj.put("status", "error");
			return resultObj.toString();
		}
		
		resultObj = surveyRestService.getSurveyItems(request, user.getId(), pageMode, title, creatorName, startDate, endDate, column, order, srchMode, srchOption, listCntSize, currentPage, userMode);
		
		logger.debug("jsonGetSurveyItems end");
		return resultObj.toString();
	}
	
	@RequestMapping(value="/ezSurvey/getSurveyPopupItems.do", method=RequestMethod.GET)
	@ResponseBody
	public String jsonGetSurveyPopupItems(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("jsonGetSurveyPopupItems start");
		LoginSimpleVO user   = commonUtil.userInfoSimple(loginCookie);
		String mode          = request.getParameter("mode")        != null ? request.getParameter("mode")        : "";
		String startDate     = request.getParameter("startDate")   != null ? request.getParameter("startDate")   : "";
		String endDate       = request.getParameter("endDate")     != null ? request.getParameter("endDate")     : "";
		JSONObject userObj = surveyRestService.getUserInformation(request, user.getId());
		
		JSONObject resultObj = new JSONObject();
		
		resultObj = surveyRestService.getSurveyPopupItems(request, user.getId(), mode, startDate, endDate);
		
		logger.debug("jsonGetSurveyPopupItems end");
		return resultObj.toString();
	}
	
	@RequestMapping(value="/ezSurvey/getCompanyTree.do", method=RequestMethod.GET)
	@ResponseBody
	public String jsonGetCompanyTree(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception{
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String companyId       = request.getParameter("companyId") != null ? request.getParameter("companyId") : "";
		JSONObject resultObj   = surveyRestService.getCompanyTree(request, userInfo.getId(), companyId);
		
		return resultObj.toString();
	}
	
	@RequestMapping(value="/ezSurvey/getSubNodes.do", method=RequestMethod.GET)
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
		filePath = commonUtil.detectPathTraversal(filePath);
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
	
	@RequestMapping(value="/ezSurvey/downloadAttachFile", produces="application/zip", method=RequestMethod.GET)
	public void responeDownloadFile(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, Model model, HttpServletResponse response) throws Exception {
		logger.debug("responeDownloadFile is running!");
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String filePath        = request.getParameter("filePath") != null ? request.getParameter("filePath") : "";
		filePath = commonUtil.detectPathTraversal(filePath);
		String fileName        = request.getParameter("fileName") != null ? request.getParameter("fileName") : "";
		fileName = commonUtil.detectPathTraversal(fileName);
		
		if (filePath.equals("") || fileName.equals("")) {
			logger.debug("Invalid arguments!!!");
			return;
		}
		
		surveyRestService.downloadAttachFile(request, response, userInfo.getId(), filePath, fileName);
		
		logger.debug("responeDownloadFile finishes!");
	}
	
	@RequestMapping(value="/ezSurvey/saveUserConfig.do", method = RequestMethod.POST)
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
	
	@RequestMapping(value="/ezSurvey/saveResponse.do", method = RequestMethod.POST)
	@ResponseBody
	public String jsonSaveResponse(@RequestBody JSONObject responseItem, @CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("jsonSaveResponse started");
		LoginSimpleVO user   = commonUtil.userInfoSimple(loginCookie);
		responseItem.put("userId", user.getId());
		
		JSONObject resultObj = surveyRestService.saveResponse(request, responseItem);
		
		logger.debug("jsonSaveResponse ended");
		return resultObj.toString();
	}
	
	@SuppressWarnings({ "unchecked", "static-access" })
	@RequestMapping(value="/ezSurvey/exportResultExcel.do", method = RequestMethod.POST)
	@ResponseBody
	public void exportResultExcel(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model, Locale locale) throws Exception {
		logger.debug("jspGetStatisticsPage started");
		LoginSimpleVO user     = commonUtil.userInfoSimple(loginCookie);
		String itemId          = request.getParameter("surveyId") != null ? request.getParameter("surveyId") : "";
		JSONObject result      = surveyRestService.getSurveyStatistic(request, user.getId(), itemId);
		JSONObject surveyData  = (JSONObject)result.get("data");
		JSONArray questionData = (JSONArray)result.get("questions");

		
		// surveyData parsing
		/** 익명/비익명 */
		int annoynumous    = ((Long)surveyData.get("annoynymous")).intValue();
		/** 참여자 */
		int responseUser   = ((Long)surveyData.get("respondentCnt")).intValue();
		/** 전체참여자 */
		int allUser        = ((Long)surveyData.get("usersCnt")).intValue();
		/** 설문제목 */
		String surveyTitle = (String)surveyData.get("title");
		/** 관리자 권한 */	
		String adminYN     = (String) result.get("adminYN");

		// 2019-03-21 황윤호
		// 관리자 권한이 없을 경우, 설문 권한 보기 제한.
		if(adminYN.equals("N")) {
			// 한글 처리
			response.setContentType("text/html; charset=UTF-8");
			PrintWriter out = response.getWriter();
			out.println("<script>");
			out.println("alert('" + egovMessageSource.getMessage("ezSurvey.t106", locale) +"');");
			out.println("window.close();");
			out.println("</script>");
			return;
		}

		// questionData parsing
		ObjectMapper objectMapper         = new ObjectMapper();
		List<QuestionVO> surveyResultData = objectMapper.readValue(questionData.toString(), objectMapper.getTypeFactory().constructCollectionType(List.class, QuestionVO.class));
	
		// Excel 객체 생성
		XSSFWorkbook workbook = new XSSFWorkbook();

		// 1행 타이틀 font (bold, 맑은고딕, 크기 12pt)
		XSSFFont titleFont = workbook.createFont();
		titleFont.setBoldweight((short) titleFont.BOLDWEIGHT_BOLD);
		titleFont.setFontHeight((short) 240);
		titleFont.setFontName("맑은 고딕");

		// header font (bold, 맑은고딕)
		XSSFFont headerFont = workbook.createFont();
		headerFont.setBoldweight((short) headerFont.BOLDWEIGHT_BOLD);
		headerFont.setFontName("맑은 고딕");

		// 기본 font(맑은고딕)
		XSSFFont basicFont = workbook.createFont();
		basicFont.setFontName("맑은 고딕");

		
		// 헤더 스타일(회색 배경, border 얇은 라인(위아래좌우), 가로세로 텍스트 중앙정렬)
		XSSFCellStyle headerStyle = workbook.createCellStyle();
		headerStyle.setFillForegroundColor(HSSFColor.GREY_25_PERCENT.index);
		headerStyle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
		headerStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
		headerStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
		headerStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
		headerStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
		headerStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);
		headerStyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
		headerStyle.setFont(headerFont);
		headerStyle.setWrapText(true);

		// 작업 이름 border스타일(좌우 라인 없음, 왼쪽정렬)
		XSSFCellStyle taskNameStyle = workbook.createCellStyle();
		taskNameStyle.setAlignment(HSSFCellStyle.ALIGN_LEFT);
		taskNameStyle.setFont(basicFont);

		// 보기, 답변 스타일
		XSSFCellStyle sentenceStyle = workbook.createCellStyle();
		sentenceStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);
		sentenceStyle.setFont(basicFont);

		// 1행 타이틀 스타일
		XSSFCellStyle titleStyle = workbook.createCellStyle();
		titleStyle.setAlignment(HSSFCellStyle.ALIGN_LEFT);
		titleStyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
		titleStyle.setFont(titleFont);

		String fileName = surveyTitle;		
		String[] invalidName = {"\\\\","/",":","[*]","[?]","\"","<",">","[|]"}; // 윈도우 파일명으로 사용할 수 없는 문자
		
		for(int i = 0;i < invalidName.length; i++) { 
			fileName = fileName.replaceAll(invalidName[i], "_"); //언더바로 치환
		}
		
		String browser = "";
		String header = request.getHeader("User-Agent"); 
		
		if (header.indexOf("MSIE") > -1) { 
			browser = "MSIE"; 
		} else if (header.indexOf("Chrome") > -1) { 
			browser = "Chrome"; 
		} else if (header.indexOf("Opera") > -1) { 
			browser = "Opera"; 
		} else if (header.indexOf("Trident/7.0") > -1) { 
			//IE 11 이상 
			//IE 버전 별 체크 >> Trident/6.0(IE 10) , Trident/5.0(IE 9) , Trident/4.0(IE 8)
			browser = "MSIE"; 
		} else if (header.indexOf("Trident/6.0") > -1) { 
			//IE 11 이상 
			//IE 버전 별 체크 >> Trident/6.0(IE 10) , Trident/5.0(IE 9) , Trident/4.0(IE 8)
			browser = "MSIE"; 
		} else {
			browser = "Firefox";
		}

		String encodedFileName = "";
		
		if (browser.equals("MSIE")) { 
			encodedFileName = URLEncoder.encode(fileName, "UTF-8").replaceAll("\\+", "%20"); 
		} else if (browser.equals("Firefox")) { 
			encodedFileName = new String(fileName.getBytes("UTF-8"), "8859_1");
		} else if (browser.equals("Opera")) {
			encodedFileName = new String(fileName.getBytes("UTF-8"), "8859_1"); 
		} else if (browser.equals("Chrome")) { 
			StringBuffer sb = new StringBuffer(); 
			
			for (int i = 0; i < fileName.length(); i++) { 
				char c = fileName.charAt(i); 
				
				if (c > '~') { 
					sb.append(URLEncoder.encode("" + c, "UTF-8")); 
				
				} else { 
					sb.append(c); 
				} 
			} 
			
			encodedFileName = sb.toString(); 
		} else { 
			encodedFileName = fileName;
		}



		// Sheet 객체 생성
		XSSFSheet sheet = workbook.createSheet("report");
		// Row 객체 생성
		Row row = sheet.createRow(0);

		// 1행 제목
		row.createCell(0).setCellValue(fileName);
		row.getCell(0).setCellStyle(titleStyle);
		row.setHeight((short) 512);

		// 기준일, 간트차트 시작 주수 등 들어감
		row = sheet.createRow(1);
		// 빈 행
		row = sheet.createRow(2);

		/** 참여자 */
		//int responseUser   = ((Long)surveyData.get("respondentCnt")).intValue();
		/** 전체참여자 */
		//int allUser        = ((Long)surveyData.get("usersCnt")).intValue();

		// 전체
		row = sheet.createRow(3);
		row.createCell(12).setCellValue(egovMessageSource.getMessage("ezSurvey.t104", locale));
		row.getCell(12).setCellStyle(headerStyle);
		row.createCell(13).setCellValue(allUser + egovMessageSource.getMessage("ezSurvey.t102", locale));
		row.getCell(13).setCellStyle(headerStyle);
		// 참여
		row = sheet.createRow(4);
		row.createCell(12).setCellValue(egovMessageSource.getMessage("ezSurvey.t105", locale));
		row.getCell(12).setCellStyle(headerStyle);
		row.createCell(13).setCellValue(responseUser + egovMessageSource.getMessage("ezSurvey.t102", locale));
		row.getCell(13).setCellStyle(headerStyle);
		
		int rowCount = 5;
		for (QuestionVO qVO : surveyResultData) {
			// 질문 헤더
			sheet.addMergedRegion(new CellRangeAddress(rowCount, rowCount+1, 0, 0));
			sheet.addMergedRegion(new CellRangeAddress(rowCount, rowCount+1, 1, 13));
			row = sheet.createRow(rowCount);
			row.createCell(0).setCellValue(egovMessageSource.getMessage("ezSurvey.t103", locale) + qVO.getLevel() + " (" + egovMessageSource.getMessage("ezSurvey.t100" + qVO.getType(), locale) + ")");
			
			row.getCell(0).setCellStyle(headerStyle);
			row.createCell(1).setCellValue(qVO.getContent());
			row.getCell(1).setCellStyle(headerStyle);
			for(int i = 2; i<=13;  i++) {
				row.createCell(i);
				row.getCell(i).setCellStyle(headerStyle);
			}
			row = sheet.createRow(rowCount+1);
			for(int i = 0; i<=13;  i++) {
				row.createCell(i);
				row.getCell(i).setCellStyle(headerStyle);
			}
			
			rowCount++;
			// 보기 갯수
			int bogiCount;
			// 전체 응답수
			double resultTot;
			// 질문 본문
			switch(qVO.getType()) {
				case 1: // 단일선택 질문
				case 2: // 다중선택 질문
				case 9: // 드롭다운 질문
					resultTot = 0;

					// 질문 응답 전체 참여자
					for(OptionVO optVO:qVO.getOption()) {
						if(optVO.getResponses() != null) {
							resultTot += optVO.getResponses().size();
						}
					}

					// 매치된 값으로 sheet 생성
					for(OptionVO optVO:qVO.getOption()) {
						// 응답자수
						int responCount = 0;
						rowCount++;
						row = sheet.createRow(rowCount);
						// 보기 질문
						row.createCell(0).setCellValue(optVO.getContent());
						row.getCell(0).setCellStyle(sentenceStyle);
						
						// 응답자수
						if(optVO.getResponses()!= null){
							responCount = optVO.getResponses().size();
						} 
						row.createCell(13).setCellValue(responCount + egovMessageSource.getMessage("ezSurvey.t102", locale));
						row.getCell(13).setCellStyle(taskNameStyle);
						
						// 참여율
						row.createCell(12).setCellValue(Math.round(responCount/resultTot * 1000)/10.0 + "%");
						row.getCell(12).setCellStyle(taskNameStyle);
					}
					break;
				case 3: // 행렬 질문
				case 4: // 행렬다중선택 질문
					// 행렬 보기수
					bogiCount           = qVO.getOption().size();
					// 행렬 id
					int[] matrixID      = new int[bogiCount];
					// 행/렬 순서
					int[] matrixOrder   = new int[bogiCount];
					// 행/렬 보기 이름
					String[] matrixName = new String[bogiCount];
					int rowCol = 0;

					if(qVO.getResponses() != null) {
						// 행렬 id, 순서, 행렬이름 매치
						List<OptionVO> optionVO = qVO.getOption();
						List<ResponseVO> responVO = qVO.getResponses();
						int matrixCnt=0;
						for(OptionVO optVO:optionVO) {
							matrixName[matrixCnt] = optVO.getContent();
							matrixOrder[matrixCnt] = optVO.getRowLevel()>=0 ? optVO.getRowLevel() : optVO.getColLevel();
							matrixID[matrixCnt++] = (int) optVO.getOptionId();
						}
						for(int i=1; i<matrixOrder.length; i++) {
							if(matrixOrder[i] == 0) {
								rowCol = i;
								break;
							}
						}
	
						// 행 * 렬 배열 set
						int[][] rowColMatrix = new int[rowCol][bogiCount-rowCol+1];
						for(int i=0;i<rowCol;i++) {
							rowColMatrix[i][0] = matrixID[i];
							rowColMatrix[i][1] = 0;
						}
						int minCol = matrixID[rowCol];
						for(ResponseVO rVO:responVO) {
							int rowID = rVO.getRowId();
							int colID = rVO.getColumnId();
							for(int i=0; i<rowCol; i++) {
								if(rowColMatrix[i][0] == rowID) {
									rowColMatrix[i][colID-minCol+1]++;
								}
							}
						}
	
						// 매치된 값으로 sheet 생성
						for(int i=0; i<rowCol; i++) {
							String rowName = matrixName[i];
							for(int j=1;j<bogiCount-rowCol+1; j++) {
								String colName = matrixName[rowCol+j-1];
								rowCount++;
								row = sheet.createRow(rowCount);
								// 행/렬
								row.createCell(0).setCellValue(rowName + " / " + colName);
								row.getCell(0).setCellStyle(sentenceStyle);
								
								// 참여
								row.createCell(13).setCellValue(rowColMatrix[i][j] + egovMessageSource.getMessage("ezSurvey.t102", locale));
								row.getCell(13).setCellStyle(taskNameStyle);
							}
						}
					}
					
					break;
				case 5: // 단답 질문
				case 6: // 문장 질문
					if(qVO.getResponses() != null) {
						for(ResponseVO rVO:qVO.getResponses()) {
							rowCount++;
							row = sheet.createRow(rowCount);
							sheet.addMergedRegion(new CellRangeAddress(rowCount, rowCount, 0, 13));
							// 답변
							row.createCell(0).setCellValue(rVO.getTexts());
							row.getCell(0).setCellStyle(sentenceStyle);
						}
					}
					break;
				case 7: // 슬라이드 질문
					if(qVO.getResponses() != null) {
						// 단위
						int unit       = (int) qVO.getUnit();
						// 슬라이드 시작값
						int startValue = Integer.parseInt(qVO.getOption().get(0).getContent());
						// 슬라이드 종료값
						int endValue   = Integer.parseInt(qVO.getOption().get(1).getContent());
						int cnt        = (endValue - startValue)/unit + 1;
						int[][] sliderArray = new int[cnt][2];
						for(int i=0; i<cnt; i++) {
							sliderArray[i][0] = startValue + unit*i;
						}
						
						
						// 슬라이드 응답값
						List<ResponseVO> responseVO = qVO.getResponses().stream().collect(Collectors.toList());
						List<Integer> sliderValue   = responseVO.stream().map(i -> i.getSliderValue()).collect(Collectors.toList());
						for(int sValue:sliderValue ) {
							int temp = sValue;
							for(int[] sArray:sliderArray) {
								if(sArray[0] == temp) {
									sArray[1]++;
								}
							}
						}
	
						// 엑셀 그리기
						for(int []sArray:sliderArray) {
							if(sArray[1] == 0) {
								continue;
							}
	
							rowCount++;
							row = sheet.createRow(rowCount);
							// 보기 질문
							row.createCell(0).setCellValue(sArray[0]);
							row.getCell(0).setCellStyle(sentenceStyle);
							// 응답자수
							row.createCell(13).setCellValue(sArray[1] + egovMessageSource.getMessage("ezSurvey.t102", locale));
							row.getCell(13).setCellStyle(taskNameStyle);
						}
					}
					break;
				case 8: // 순위 질문
					if(qVO.getResponses() != null) {
						// 보기갯수
						bogiCount                = qVO.getOption().size();
						// OptionVO
						List<OptionVO> optVO     = qVO.getOption();
						// 보기 이름
						List<String> optionName  = optVO.stream().map(i->i.getContent()).collect(Collectors.toList());
						// 보기 아이디
						List<Integer> optionId   = optVO.stream().map(i->(int) i.getOptionId()).collect(Collectors.toList());
						
						
						// 배열 set
						int count          = 0;
						int[][] orderArray = new int[bogiCount][bogiCount+1];
						for(int[] rowArray:orderArray) {
							rowArray[0] = optionId.get(count++);
							for(int num:rowArray) {
								num = 0;
							}
						}
						List<ResponseVO> responsVO = qVO.getResponses();
						for(ResponseVO rVO:responsVO) {
							int optId = (int) rVO.getOptionId();
							int level = rVO.getRankingLevel();
							for(int[] rowArray:orderArray) {
								if(rowArray[0] == optId) {
									rowArray[level]++;
								}
							}
						}
	
						// 매치된 값으로 sheet 생성
						for(int i=0; i<bogiCount; i++) {
							String rowName = optionName.get(i);
							for(int j=1;j<bogiCount+1; j++) {
								rowCount++;
								row = sheet.createRow(rowCount);
								// 보기n / n번째
								row.createCell(0).setCellValue(rowName + " : " + j);
								row.getCell(0).setCellStyle(sentenceStyle);
								
								// 참여
								row.createCell(13).setCellValue(orderArray[i][j] + egovMessageSource.getMessage("ezSurvey.t102", locale));
								row.getCell(13).setCellStyle(taskNameStyle);
							}
						}
					}
					break;
			}
			
			rowCount += 3;
		}
		
		sheet.autoSizeColumn(0);

		response.setContentType("application/vnd.ms-excel");
		response.setHeader("Content-Disposition", "attachment; fileName=\"" + encodedFileName + ".xlsx\"");
		workbook.write(response.getOutputStream());
		workbook.close();
		logger.debug("jsonSaveResponse ended");
	}
}
