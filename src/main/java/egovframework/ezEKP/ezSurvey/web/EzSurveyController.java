package egovframework.ezEKP.ezSurvey.web;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.PrintWriter;
import java.net.URLEncoder;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import javax.annotation.Resource;
import javax.imageio.ImageIO;
import javax.imageio.ImageReader;
import javax.imageio.stream.ImageInputStream;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import egovframework.ezEKP.ezSurvey.service.EzSurveyService;
import egovframework.ezEKP.ezSurvey.vo.SurveyItemSearchVO;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.ClientAnchor;
import org.apache.poi.ss.usermodel.CreationHelper;
import org.apache.poi.ss.usermodel.Drawing;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessagingTemplate;
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

import com.fasterxml.jackson.databind.ObjectMapper;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezSurvey.service.EzSurveyRestService;
import egovframework.ezEKP.ezSurvey.vo.AttachVO;
import egovframework.ezEKP.ezSurvey.vo.OptionVO;
import egovframework.ezEKP.ezSurvey.vo.QuestionVO;
import egovframework.ezEKP.ezSurvey.vo.ResponseVO;
import egovframework.ezEKP.ezSurvey.vo.SurveyGeneralVO;
import egovframework.let.user.login.vo.LoginSimpleVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@SuppressWarnings("unchecked")
@Controller
public class EzSurveyController extends EgovFileMngUtil {
	private static final Logger logger = LoggerFactory.getLogger(EzSurveyController.class);

	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private EzSurveyRestService surveyRestService;

	@Autowired
	private EzSurveyService ezSurveyService;

	@Autowired
	private SimpMessagingTemplate template;
	
	@Resource(name="EzCommonService")
	private EzCommonService ezCommonService;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@RequestMapping(value = "/ezSurvey/surveyMain.do", method = RequestMethod.GET)
	public String jspGetSurveyMain(@CookieValue("loginCookie") String loginCookie, HttpServletRequest req, Model model) {
		logger.debug("jspGetSurveyMain started");

		String leftFrameWidth = "220";
		int width = 0;

		if (req.getParameter("__wwidth") != null) {
			String widthParam = req.getParameter("__wwidth");

			try {
				width = Integer.parseInt(widthParam);

				leftFrameWidth = width < 1180 ? "0" : "220";
			} catch (NumberFormatException e) {
				width = 0;
			}
		}

		model.addAttribute("leftFrameWidth", leftFrameWidth);
		
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

		/* 2024-03-26 양지혜 - 설문종료 후 게시기간 제한 */
		LoginVO user = commonUtil.userInfo(loginCookie);
		String maxPeriod = ezSurveyService.checkTenantConfig("SurveyPostingMaxPeriod", user.getTenantId());
		if (maxPeriod == null || maxPeriod.equals("")) {
			maxPeriod = "999";
		}
		
		String editor = ezSurveyService.checkTenantConfig("MODULEEDITOR", user.getTenantId());
		
		model.addAttribute("maxPeriod", maxPeriod);
		model.addAttribute("companyId", user.getCompanyID());
		model.addAttribute("editor", editor);

		logger.debug("jspGetCreateSurveyPage ended");

		return "ezSurvey/listmenu/surveyCreate";
	}
	
	@RequestMapping(value="/ezSurvey/reuseItem.do", method = RequestMethod.GET)
	public String jspGetReuseSurveyPage(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("jspGetReuseSurveyPage started");
		LoginVO user = commonUtil.userInfo(loginCookie);
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

		/* 2024-03-26 양지혜 - 설문종료 후 게시기간 제한 */
		String maxPeriod = ezSurveyService.checkTenantConfig("SurveyPostingMaxPeriod", user.getTenantId());
		if (maxPeriod == null || maxPeriod.equals("")) {
			maxPeriod = "999";
		}
		model.addAttribute("maxPeriod", maxPeriod);
		model.addAttribute("companyId", user.getCompanyID());
		model.addAttribute("editor", ezSurveyService.checkTenantConfig("MODULEEDITOR", user.getTenantId()));

		logger.debug("jspGetReuseSurveyPage ended");
		return "ezSurvey/listmenu/surveyCreate";
	}
	
	@RequestMapping(value="/ezSurvey/modifyItem.do", method = RequestMethod.GET)
	public String jspGetModifySurveyPage(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("jspGetModifySurveyPage started");
		LoginVO user = commonUtil.userInfo(loginCookie);
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
		model.addAttribute("editor", ezSurveyService.checkTenantConfig("MODULEEDITOR", user.getTenantId()));
		
		model.addAttribute("companyId", user.getCompanyID());
		String maxPeriod = ezSurveyService.checkTenantConfig("SurveyPostingMaxPeriod", user.getTenantId());
		if (maxPeriod == null || maxPeriod.equals("")) {
			maxPeriod = "999";
		}
		model.addAttribute("maxPeriod", maxPeriod);
		
		logger.debug("jspGetModifySurveyPage ended");
		return "ezSurvey/listmenu/surveyCreate";
	}
	
	@RequestMapping(value="/ezSurvey/surveyDetail.do", method = RequestMethod.GET)
	public String jspGetSurveyDetail(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("jspGetSurveyDetail started");
		LoginVO user = commonUtil.userInfo(loginCookie);
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
			// 20.05.06 강승구 : 설문응답여부 반환
			String     resStatus 	 = (String)surveyInf.get("resStatus");
			String	   finishYN      = ezSurveyService.checkfinishSurvey((String)survey.get("endDate"), user.getOffset()); // 설문 종료여부 체크
			
			model.addAttribute("survey" , survey);
			model.addAttribute("creator", creator);
			model.addAttribute("participation", participation);
			model.addAttribute("resStatus", resStatus);
			model.addAttribute("finishYN", finishYN);
		}
		else {
			int reasonCode = ((Long)surveyInf.get("code")).intValue();
			String messageCode = "";
			
			switch(reasonCode) {
				case 1 : messageCode = "ezSurvey.err1"; break;
				case 2 : messageCode = "ezSurvey.err2"; break;
				case 3 : messageCode = "ezSurvey.err3"; break;
				case -1 : messageCode = "ezSurvey.err4"; break;
				default: messageCode = "ezSurvey.err1"; break;
			}
			
			model.addAttribute("reasonMessage", messageCode);
			return "ezSurvey/surveyAccessDenied";
		}
		
		String defaultFontFamily = egovMessageSource.getMessage("main.t246", user.getLocale());
		String defaultFontSize = "13px";		
		String adminYN = commonUtil.isAdmin(user.getId(), user.getTenantId(), user.getRollInfo(), "c;l;k") ? "Y" : "N";
		
		model.addAttribute("user", user.getId());
		model.addAttribute("tenantId", user.getTenantId());
		model.addAttribute("mode", mode);
		model.addAttribute("defaultFontFamily", defaultFontFamily);
		model.addAttribute("defaultFontSize", defaultFontSize);
		model.addAttribute("adminYN", adminYN);
		
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
		LoginVO user = commonUtil.userInfo(loginCookie);
		
		JSONObject result = surveyRestService.getUserListType(request, user.getId());
		if (result.get("status").toString().equals("ok")) {
			String listType = (String)result.get("listType");
			model.addAttribute("listType", listType);
		}
		
		// survey - 설문대상자 선택, result - 설문결과 지정공개 대상자 선택
		model.addAttribute("mode", request.getParameter("mode"));
		model.addAttribute("cn",user.getId());
		model.addAttribute("companyId",user.getCompanyID());
		model.addAttribute("dept",user.getDeptID());
		model.addAttribute("lang",user.getLang());
		
		logger.debug("jspGetSelectUesrPage ended");
		return "ezSurvey/user/selectUser";
	}
	
	@RequestMapping(value="/ezSurvey/getSurveyQuestions.do", method = RequestMethod.GET)
	@ResponseBody
	public JSONObject jsonGetSurveyQuestions(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("jsonGetSurveyQuestions start");
		LoginSimpleVO user   = commonUtil.userInfoSimple(loginCookie);
		String itemId        = request.getParameter("surveyId") != null ? request.getParameter("surveyId") : "";
		String logicMode     = request.getParameter("logic")    != null ? request.getParameter("logic")    : "";
		JSONObject resultObj = new JSONObject();
		
		if (itemId.equals("")) {
			resultObj.put("code", 1);
			resultObj.put("status", "error");
			return resultObj;
		}
		
		resultObj = surveyRestService.getSurveyQuestions(request, user.getId(), itemId, logicMode);
		
		logger.debug("jsonGetSurveyQuestions end");
		return resultObj;
	}
	
	@RequestMapping(value="/ezSurvey/changeSurveyState.do", method = RequestMethod.GET)
	@ResponseBody
	public JSONObject jsonChangeSurveyState(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("jsonChangeSurveyState start");
		LoginSimpleVO user   = commonUtil.userInfoSimple(loginCookie);
		JSONObject resultObj = new JSONObject();
		String itemId        = request.getParameter("surveyId") != null ? request.getParameter("surveyId") : "";
		
		if (itemId.equals("")) {
			resultObj.put("code", 1);
			resultObj.put("status", "error");
			return resultObj;
		}
		
		resultObj = surveyRestService.changeSurveyState(request, user.getId(), itemId);
		
		logger.debug("jsonChangeSurveyState end");
		return resultObj;
	}
	
	@RequestMapping(value="/ezSurvey/checkReusePermission.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject jsonCheckItems(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("jsonCheckItems start");
		LoginSimpleVO user   = commonUtil.userInfoSimple(loginCookie);
		JSONObject resultObj = surveyRestService.checkSurveyItems(request, user.getId());
		
		logger.debug("jsonCheckItems end");
		return resultObj;
	}
	
	@RequestMapping(value="/ezSurvey/checkProcessingSurvey.do", method = RequestMethod.GET)
	@ResponseBody
	public JSONObject jsonCheckProcessingSurvey(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("jsonCheckItems start");
		LoginSimpleVO user   = commonUtil.userInfoSimple(loginCookie);
		JSONObject resultObj = new JSONObject();
		String itemId        = request.getParameter("surveyId") != null ? request.getParameter("surveyId") : "";
		
		if (itemId.equals("")) {
			resultObj.put("code", 1);
			resultObj.put("status", "error");
			return resultObj;
		}
		
		resultObj = surveyRestService.checkProcessingSurvey(request, user.getId(), itemId);
		
		logger.debug("jsonCheckItems end");
		return resultObj;
	}
	
	@RequestMapping(value="/ezSurvey/checkAnalysisPermission.do", method = RequestMethod.GET)
	@ResponseBody
	public JSONObject jsonCheckAnalysisPermission (@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
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
		return resultObj;
	}
	
	@RequestMapping(value="/ezSurvey/saveSurvey.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject jsonSaveSurveyItem(@RequestBody JSONObject surveyItem, @CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("jsonSaveSurveyItem started");
		
		LoginVO user   = commonUtil.userInfo(loginCookie);
		surveyItem.put("userId", user.getId());
		
		JSONObject resultObj = surveyRestService.saveSurveyItem(request, surveyItem);
		
		/* 수정 시 변경 상태(MODIFY)와 기존 surveyId 포함한 WebSocket 메시지 전송 로직 추가 */
		if (!"-1".equals(surveyItem.get("surveyId").toString()) && surveyItem.get("draft") == null) {
			String orgSurveyId = surveyItem.get("surveyId").toString();
			String result = "{\"status\":\"MODIFY\", \"surveyId\":\"" + orgSurveyId + "\"}";
			JSONParser parser = new JSONParser();
			JSONObject json = (JSONObject) parser.parse(result);
			this.template.convertAndSend("/reply/getSeenUpdateForSurvey" + orgSurveyId + "+" + user.getTenantId(), json);
		}
		logger.debug("jsonSaveSurveyItem ended");
		return resultObj;
	}
	
	@RequestMapping(value="/ezSurvey/deleteItems.do", method = RequestMethod.GET)
	@ResponseBody
	public JSONObject jsonDeleteItems(@CookieValue("loginCookie") String loginCookie, @RequestParam(value = "itemList") List<String> itemList, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("jsonDeleteItems start");
		LoginVO user   = commonUtil.userInfo(loginCookie);
		JSONObject resultObj = new JSONObject();
		
		if (itemList.size() == 0) {
			resultObj.put("code", 1);
			resultObj.put("status", "error");
			return resultObj;
		}
		
		resultObj = surveyRestService.deleteItems(request, user.getId(), itemList);
		
		logger.debug("jsonDeleteItems end");
		return resultObj;
	}
	
	@RequestMapping(value="/ezSurvey/getSurveyItems.do", method = RequestMethod.GET)
	@ResponseBody
	public JSONObject jsonGetSurveyItems(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
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
		String filterStatus   = request.getParameter("filterStatus") != null ? request.getParameter("filterStatus") : "";
		JSONObject userObj = surveyRestService.getUserInformation(request, user.getId());
		int userMode = 0;
		
		if(!commonUtil.isIntNumber(currentPage)) {
			logger.debug("This number is invalid.");	
			currentPage = "1";
		}
		
		if(!commonUtil.isIntNumber(listCntSize)) {
			logger.debug("This number is invalid.");	
			listCntSize = "5";
		}
		
		if (userObj.get("status").toString().equals("ok")) {
			userMode = ((Long)userObj.get("mode")).intValue();
		}
		
		logger.debug("pageMode: " + pageMode + " || Title: " + title + " || Creator name: " + creatorName + " || Start Date: " + startDate + " || End Date: " + endDate + " || Column: " + column + " || Order: " + order + " || Search mode: " + srchMode + " || Search option: " + srchOption + " || List count: " + listCntSize + " || Current page: " + currentPage + " || userMode: " + userMode);
		
		JSONObject resultObj = new JSONObject();
		
		if (pageMode.equals("") || listCntSize.equals("") || currentPage.equals("")) {
			resultObj.put("code", 1);
			resultObj.put("status", "error");
			return resultObj;
		}
		
		resultObj = surveyRestService.getSurveyItems(request, user.getId(), pageMode, title, creatorName, startDate, endDate, column, order, srchMode, srchOption, listCntSize, currentPage, userMode, filterStatus);
		
		logger.debug("jsonGetSurveyItems end");
		return resultObj;
	}
	
	@RequestMapping(value="/ezSurvey/getSurveyPopupItems.do", method=RequestMethod.GET)
	@ResponseBody
	public JSONObject jsonGetSurveyPopupItems(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("jsonGetSurveyPopupItems start");
		LoginSimpleVO user   = commonUtil.userInfoSimple(loginCookie);
		String mode          = request.getParameter("mode")        != null ? request.getParameter("mode")        : "";
		String startDate     = request.getParameter("startDate")   != null ? request.getParameter("startDate")   : "";
		String endDate       = request.getParameter("endDate")     != null ? request.getParameter("endDate")     : "";
		@SuppressWarnings("unused")
		JSONObject userObj = surveyRestService.getUserInformation(request, user.getId());
		
		JSONObject resultObj = new JSONObject();
		
		resultObj = surveyRestService.getSurveyPopupItems(request, user.getId(), mode, startDate, endDate);
		
		String cookieValue = "";
		
		Cookie[] cookies = request.getCookies();
		
		if (cookies != null) {
			for (int i = 0; i < cookies.length; i++) {
				Cookie cookie = cookies[i];
				String cookieName = cookie.getName();
				
				if (cookieName.equals("SURV_POPUP" + "_" + user.getId())) {
					cookieValue = cookies[i].getValue();
				}
			}
			
			if (cookieValue != null && !cookieValue.equals("")) {
				resultObj.remove("surveyPopupList");
			}
		}
		
		logger.debug("jsonGetSurveyPopupItems end");
		return resultObj;
	}
	
	@RequestMapping(value="/ezSurvey/getCompanyTree.do", method=RequestMethod.GET)
	@ResponseBody
	public JSONObject jsonGetCompanyTree(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception{
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String companyId       = request.getParameter("companyId") != null ? request.getParameter("companyId") : "";
		JSONObject resultObj   = surveyRestService.getCompanyTree(request, userInfo.getId(), companyId);
		
		return resultObj;
	}
	
	@RequestMapping(value="/ezSurvey/getSubNodes.do", method=RequestMethod.GET)
	@ResponseBody
	public JSONObject jsonGetSubNodes(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response) throws Exception{
		logger.debug("jsonGetSubNodes started");
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String deptId          = request.getParameter("nodeId") != null ? request.getParameter("nodeId") : "";
		String level           = request.getParameter("level")  != null ? request.getParameter("level")  : "";
		JSONObject resultObj   = new JSONObject();
		
		if (deptId.equals("") || level.equals("")) {
			logger.debug("Parameter error");
			resultObj.put("code", 1);
			resultObj.put("status", "error");
			return resultObj;
		}
		
		resultObj = surveyRestService.getDeptSubNodes(request, userInfo.getId(), deptId, level);
		logger.debug("jsonGetSubNodes ended");
		
		return resultObj;
	}
	
	@RequestMapping(value="/ezSurvey/getDeptMembers.do", method=RequestMethod.POST)
	@ResponseBody
	public JSONObject jsonGetDeptMembers(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("jsonGetDeptMembers started");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		String deptId      = request.getParameter("deptId")      != null ? request.getParameter("deptId")      : "";
		String currentPage = request.getParameter("currentPage") != null ? request.getParameter("currentPage") : "";
		
		logger.debug("deptId: " + deptId + " || currentPage: " + currentPage);
		
		JSONObject resultObj = new JSONObject();
		
		if (deptId.equals("") || currentPage.equals("")) {
			resultObj.put("code", 1);
			resultObj.put("status", "error");
			return resultObj;
		}
		
		resultObj = surveyRestService.getDeptMembers(request, user.getId(), deptId, currentPage);
		
		logger.debug("jsonGetDeptMembers ended");
		logger.debug(resultObj.toString());
		return resultObj;
	}
	
	/* 2024-07-01 홍승비 - surveyUser.js 파일 내부의 getUsers() 함수에서만 호출되는 URL로, 해당 js파일이 사용되지 않아 전체 주석처리 */
	/*
	@RequestMapping(value="/ezSurvey/getSearchMember.do", method=RequestMethod.POST)
	@ResponseBody
	public JSONObject jsonGetSearchMember(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
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
			return resultObj;
		}
		
		resultObj = surveyRestService.getSearchMember(request, user.getId(), srchOption, srchValue, currentPage);
		
		logger.debug("jsonGetSearchMember ended");
		logger.debug(resultObj.toString());
		return resultObj;
	}*/
	
	@RequestMapping(value="/ezSurvey/uploadAttachFile.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject jsonUploadFile(MultipartHttpServletRequest request, @CookieValue("loginCookie") String loginCookie, Model model, HttpServletResponse response) throws Exception {
		logger.debug("Upload file is running!");
		LoginSimpleVO userInfo         = commonUtil.userInfoSimple(loginCookie);
		List<MultipartFile> multiFiles = request.getFiles("fileToUpload");
		JSONObject resultObj           = new JSONObject();
		
		if (multiFiles.size() == 0) {
			resultObj.put("code", 1);
			resultObj.put("status", "error");
			return resultObj;
		}
		
		resultObj = surveyRestService.uploadAttachFile(request, userInfo.getId(), multiFiles);
		
		logger.debug("Upload file finishes!");
		return resultObj;
	}
	
	@RequestMapping(value="/ezSurvey/deleteAttachFile.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject jsonDeleteFile(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, Model model, HttpServletResponse response) throws Exception {
		logger.debug("Delete file is running!");
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		String filePath        = request.getParameter("filePath") != null ? request.getParameter("filePath") : "";
		filePath = commonUtil.detectPathTraversal(filePath);
		JSONObject resultObj   = new JSONObject();
		
		if (filePath.equals("")) {
			resultObj.put("code", 1);
			resultObj.put("status", "error");
			return resultObj;
		}
		
		resultObj = surveyRestService.deleteAttachFile(request, userInfo.getId(), filePath);
		
		logger.debug("Delete file finishes!");
		return resultObj;
	}
	
	@RequestMapping(value="/ezSurvey/downloadAttachFile", produces="application/zip", method=RequestMethod.GET)
	@ResponseBody
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
	public JSONObject jsonSaveUserConfig(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
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
			return resultObj;
		}
		
		resultObj = surveyRestService.saveUserConfig(request, user.getId(), prevMode, listCount, contentWPrev, contentHPrev);
		
		logger.debug("jsonSaveUserConfig end");
		return resultObj;
	}
	
	@RequestMapping(value="/ezSurvey/saveResponse.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject jsonSaveResponse(@RequestBody JSONObject responseItem, @CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("jsonSaveResponse started");
		LoginSimpleVO user   = commonUtil.userInfoSimple(loginCookie);
		responseItem.put("userId", user.getId());
		
		JSONObject resultObj = surveyRestService.saveResponse(request, responseItem);
		
		logger.debug("jsonSaveResponse ended");
		return resultObj;
	}
	
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
		try (XSSFWorkbook workbook = new XSSFWorkbook()) {
	
			String fontFamily = egovMessageSource.getMessage("main.t0620", locale).split(";")[0];
	
			// 1행 타이틀 font (bold, 맑은고딕, 크기 12pt)
			XSSFFont titleFont = workbook.createFont();
			titleFont.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);
			titleFont.setFontHeight((short) 240);
			titleFont.setFontName(fontFamily);
	
			// header font (bold, 맑은고딕)
			XSSFFont headerFont = workbook.createFont();
			headerFont.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);
			headerFont.setFontName(fontFamily);
	
			// 기본 font(맑은고딕)
			XSSFFont basicFont = workbook.createFont();
			basicFont.setFontName(fontFamily);
	
			
			// 헤더 스타일(회색 배경, border 얇은 라인(위아래좌우), 가로세로 텍스트 중앙정렬)
			XSSFCellStyle headerStyle = workbook.createCellStyle();
			headerStyle.setFillForegroundColor(HSSFColor.GREY_40_PERCENT.index);
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
			
			// 응답자 정보 헤더 스타일
			XSSFCellStyle responserHeaderStyle = workbook.createCellStyle();
			responserHeaderStyle.setFillForegroundColor(HSSFColor.GREY_25_PERCENT.index);
			responserHeaderStyle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
			responserHeaderStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
			responserHeaderStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
			responserHeaderStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
			responserHeaderStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
			responserHeaderStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);
			responserHeaderStyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
			
			// 응답자 정보 스타일
			XSSFCellStyle responserStyle = workbook.createCellStyle();
			responserStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
			responserStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
			responserStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
			responserStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
			responserStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);
			responserStyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
	
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
				sheet.addMergedRegionUnsafe(new CellRangeAddress(rowCount, rowCount+1, 0, 0));
				sheet.addMergedRegionUnsafe(new CellRangeAddress(rowCount, rowCount+1, 1, 13));
				row = sheet.createRow(rowCount);
				row.createCell(0).setCellValue(egovMessageSource.getMessage("ezSurvey.t103", locale) + qVO.getLevel() + " (" + egovMessageSource.getMessage("ezSurvey.t100" + qVO.getType(), locale) + ")");
				
				row.getCell(0).setCellStyle(headerStyle);
				
				AttachVO imgTitle = qVO.getImgTitle();
				double imgTitleWidth = 0; 
				double imgTitleHeight = 0;
				ClientAnchor anchor = null;
				if (imgTitle == null) {
					row.createCell(1).setCellValue(qVO.getContent());
				} else {
					row.createCell(1);
					String realPath = request.getServletContext().getRealPath("");
					realPath = commonUtil.detectPathTraversal(realPath);
					File imageFile = new File(realPath + commonUtil.separator + imgTitle.getFpath());
					try (ImageInputStream imageInputStream = ImageIO.createImageInputStream(imageFile);) {
						Iterator<ImageReader> readers = ImageIO.getImageReaders(imageInputStream);
						if (readers.hasNext()) {
			                ImageReader reader = readers.next();
			                reader.setInput(imageInputStream);
			                imgTitleWidth = reader.getWidth(0);
			                imgTitleWidth = imgTitleWidth / 8.54; // (너비 1 포인트 = 약 8.54 픽셀)
			                imgTitleHeight = reader.getHeight(0);
			                imgTitleHeight = imgTitleHeight / 1.33; // (높이 1포인트 = 1.33 픽셀)
			            }
					}
					
					byte[] bytes = null;
			        try (FileInputStream fis = new FileInputStream(imageFile);
			            ByteArrayOutputStream bos = new ByteArrayOutputStream()) {
			            byte[] buffer = new byte[1024];
			            int bytesRead;
			            while ((bytesRead = fis.read(buffer)) != -1) {
			                bos.write(buffer, 0, bytesRead);
			            }
			            bytes = bos.toByteArray();
			        }
			        
			        String filename = imgTitle.getFname();
			        String fileExtension = "";
			        int dotIndex = filename.lastIndexOf('.');
			        if (dotIndex > 0 && dotIndex < filename.length() - 1) {
			        	fileExtension = filename.substring(dotIndex + 1);
			        }
			        
			        int pictureIndex = 0;
			        
			        if (fileExtension.toUpperCase().equals("PNG")) {
			        	pictureIndex = workbook.addPicture(bytes, Workbook.PICTURE_TYPE_PNG);
			        } else if (fileExtension.toUpperCase().equals("JPG") || fileExtension.toUpperCase().equals("JPEG")) {
			        	pictureIndex = workbook.addPicture(bytes, Workbook.PICTURE_TYPE_JPEG);
			        }
			        
				    CreationHelper helper = workbook.getCreationHelper();
		            Drawing drawing = sheet.createDrawingPatriarch();
		             anchor = helper.createClientAnchor();
		            anchor.setCol1(1); // 이미지 시작 열
		            anchor.setRow1(rowCount); // 이미지 시작 행
		            anchor.setCol2(14); // 이미지 끝 열
		            anchor.setRow2(rowCount + 2); // 이미지 끝 행
		            // 이미지 삽입
		            drawing.createPicture(anchor, pictureIndex);
		            
				}
				
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
				
				
				if (imgTitle != null) {
					double cellWidthInPoint = 8.43; //영문은 8.43 한글은 8.38. 너비의 포인트는 너비에 들어갈 수 있는 글자 수를 말함.
			        double totalWidth = 0;
		            totalWidth += cellWidthInPoint * 13; // 제목 칸 너비의 최대 길이 (1칸에 8.43 포인트)
					
					if (imgTitleWidth < totalWidth) {
						int col2Idx = anchor.getCol1() + 1;
						col2Idx = (int) (imgTitleWidth / cellWidthInPoint) > 0 ? anchor.getCol1() + (int) (imgTitleWidth / cellWidthInPoint) : col2Idx;
						anchor.setCol2(col2Idx);
			        }
					
					Row temp1Row =sheet.getRow(rowCount);
					Row temp2Row = sheet.getRow(rowCount + 1);
					if (imgTitleHeight > 33) { // row 하나의 높이는 16.5포인트 정도. 제목  열의 높이는 33포인트.
						temp1Row.setHeightInPoints((int)imgTitleHeight / 2);
						temp2Row.setHeightInPoints((int)imgTitleHeight / 2);
					}
			        
				}
				
				boolean isFirstRow = true;
				
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
					case 10: //일정단일 선택 질문
					case 11: //일정 다중 선택 질문
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
							
							if(annoynumous == 0) {
								for(int i=0; i<responCount; i++) {
									ResponseVO resVO = optVO.getResponses().get(i);
									
									rowCount++;
									sheet.addMergedRegionUnsafe(new CellRangeAddress(rowCount, rowCount, 8, 9));
									sheet.addMergedRegionUnsafe(new CellRangeAddress(rowCount, rowCount, 10, 11));
									sheet.addMergedRegionUnsafe(new CellRangeAddress(rowCount, rowCount, 12, 13));
									row = sheet.createRow(rowCount);
									
									for(int j=8; j<=13; j++) {
										row.createCell(j);
										row.getCell(j).setCellStyle(responserStyle);
									}
									row.getCell(8).setCellValue(resVO.getUserName());
									row.getCell(10).setCellValue(resVO.getDeptName());
									row.getCell(12).setCellValue(resVO.getResponseDate().substring(0, 19));
								}
							}
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
							
							Collections.sort(responVO, new Comparator<ResponseVO>() {
								@Override
								public int compare(ResponseVO o1, ResponseVO o2) {
									if(o1.getRowId() == o2.getRowId()) {
										return Integer.compare(o1.getColumnId(), o2.getColumnId());
									}
									return Integer.compare(o1.getRowId(), o2.getRowId());
								}
							});
		
							// 매치된 값으로 sheet 생성
							int responseCnt = 0;
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
									
									if(annoynumous == 0) {
										for(int k=0; k<rowColMatrix[i][j]; k++) {
											ResponseVO resVO = responVO.get(responseCnt++);
											
											rowCount++;
											sheet.addMergedRegionUnsafe(new CellRangeAddress(rowCount, rowCount, 8, 9));
											sheet.addMergedRegionUnsafe(new CellRangeAddress(rowCount, rowCount, 10, 11));
											sheet.addMergedRegionUnsafe(new CellRangeAddress(rowCount, rowCount, 12, 13));
											row = sheet.createRow(rowCount);
											
											for(int l=8; l<=13; l++) {
												row.createCell(l);
												row.getCell(l).setCellStyle(responserStyle);
											}
											row.getCell(8).setCellValue(resVO.getUserName());
											row.getCell(10).setCellValue(resVO.getDeptName());
											row.getCell(12).setCellValue(resVO.getResponseDate().substring(0, 19));
										}
									}
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
								
								if(annoynumous == 0) {
									if(isFirstRow) {
										sheet.addMergedRegionUnsafe(new CellRangeAddress(rowCount, rowCount, 0, 7));
										sheet.addMergedRegionUnsafe(new CellRangeAddress(rowCount, rowCount, 8, 9));
										sheet.addMergedRegionUnsafe(new CellRangeAddress(rowCount, rowCount, 10, 11));
										sheet.addMergedRegionUnsafe(new CellRangeAddress(rowCount, rowCount, 12, 13));
										
										for(int l=0; l<=13; l++) {
											row.createCell(l);
											row.getCell(l).setCellStyle(responserHeaderStyle);
										}
										
										row.getCell(0).setCellValue(egovMessageSource.getMessage("ezSurvey.t88", locale));
										row.getCell(8).setCellValue(egovMessageSource.getMessage("ezSurvey.t57", locale));
										row.getCell(10).setCellValue(egovMessageSource.getMessage("ezSurvey.t59", locale));
										row.getCell(12).setCellValue(egovMessageSource.getMessage("ezSchedule.t165", locale));
										
										rowCount++;
										row = sheet.createRow(rowCount);
										
										isFirstRow = false;
									}
									
									sheet.addMergedRegionUnsafe(new CellRangeAddress(rowCount, rowCount, 0, 7));
									sheet.addMergedRegionUnsafe(new CellRangeAddress(rowCount, rowCount, 8, 9));
									sheet.addMergedRegionUnsafe(new CellRangeAddress(rowCount, rowCount, 10, 11));
									sheet.addMergedRegionUnsafe(new CellRangeAddress(rowCount, rowCount, 12, 13));
								}
								else {
									sheet.addMergedRegionUnsafe(new CellRangeAddress(rowCount, rowCount, 0, 13));
								}
								
								// 답변
								row.createCell(0).setCellValue(rVO.getTexts());
								row.getCell(0).setCellStyle(sentenceStyle);
								
								if(annoynumous == 0) {
									for(int j=8; j<=13; j++) {
										row.createCell(j);
										row.getCell(j).setCellStyle(responserStyle);
									}
									row.getCell(8).setCellValue(rVO.getUserName());
									row.getCell(10).setCellValue(rVO.getDeptName());
									row.getCell(12).setCellValue(rVO.getResponseDate().substring(0, 19));
								}
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
							
							Collections.sort(responseVO, new Comparator<ResponseVO>() {
								@Override
								public int compare(ResponseVO o1, ResponseVO o2) {
									return Integer.compare(o1.getSliderValue(), o2.getSliderValue());
								}
							});
		
							// 엑셀 그리기
							int responseCnt = 0;
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
								
								if(annoynumous == 0) {
									for(int i=0; i<sArray[1]; i++) {
										ResponseVO resVO = responseVO.get(responseCnt++);
										
										rowCount++;
										sheet.addMergedRegionUnsafe(new CellRangeAddress(rowCount, rowCount, 8, 9));
										sheet.addMergedRegionUnsafe(new CellRangeAddress(rowCount, rowCount, 10, 11));
										sheet.addMergedRegionUnsafe(new CellRangeAddress(rowCount, rowCount, 12, 13));
										row = sheet.createRow(rowCount);
										
										for(int j=8; j<=13; j++) {
											row.createCell(j);
											row.getCell(j).setCellStyle(responserStyle);
										}
										row.getCell(8).setCellValue(resVO.getUserName());
										row.getCell(10).setCellValue(resVO.getDeptName());
										row.getCell(12).setCellValue(resVO.getResponseDate().substring(0, 19));
									}
								}
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
								/* for(int num:rowArray) {
									num = 0;
								} */
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
							
							Collections.sort(responsVO, new Comparator<ResponseVO>() {
								@Override
								public int compare(ResponseVO o1, ResponseVO o2) {
									if(o1.getOptionId() == o2.getOptionId()) {
										return Integer.compare(o1.getRankingLevel(), o2.getRankingLevel());
									}
									return Long.compare(o1.getOptionId(), o2.getOptionId());
								}
							});
		
							// 매치된 값으로 sheet 생성
							int responseCnt = 0;
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
									
									if(annoynumous == 0) {
										for(int k=0; k<orderArray[i][j]; k++) {
											ResponseVO resVO = responsVO.get(responseCnt++);
											
											rowCount++;
											sheet.addMergedRegionUnsafe(new CellRangeAddress(rowCount, rowCount, 8, 9));
											sheet.addMergedRegionUnsafe(new CellRangeAddress(rowCount, rowCount, 10, 11));
											sheet.addMergedRegionUnsafe(new CellRangeAddress(rowCount, rowCount, 12, 13));
											row = sheet.createRow(rowCount);
											
											for(int l=8; l<=13; l++) {
												row.createCell(l);
												row.getCell(l).setCellStyle(responserStyle);
											}
											row.getCell(8).setCellValue(resVO.getUserName());
											row.getCell(10).setCellValue(resVO.getDeptName());
											row.getCell(12).setCellValue(resVO.getResponseDate().substring(0, 19));
										}
									}
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
			//workbook.close();
		}
		
		logger.debug("jsonSaveResponse ended");
	}
	
	@RequestMapping(value="/ezSurvey/checkRespondent.do", method = RequestMethod.GET)
	@ResponseBody
	public JSONObject checkRespondent(int surveyId, @CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model, Locale locale) throws Exception {
		logger.debug("checkRespondent started");
		LoginSimpleVO user   = commonUtil.userInfoSimple(loginCookie);
		JSONObject resultObj = new JSONObject();
		
		resultObj = surveyRestService.checkRespondent(request, user.getId(), surveyId);
		
		logger.debug("checkRespondent ended");
		return resultObj;
	}
	
	// 20.05.08 강승구 : 설문수정 코드
	@RequestMapping(value="/ezSurvey/updateResponse.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject jsonUpdateResponse(@RequestBody JSONObject responseItem, @CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("jsonUpdateResponse started");
		LoginSimpleVO user   = commonUtil.userInfoSimple(loginCookie);
		responseItem.put("userId", user.getId());
		
		JSONObject resultObj = surveyRestService.saveResponse(request, responseItem);
		
		logger.debug("jsonUpdateResponse ended");
		return resultObj;
	}
	
	@RequestMapping(value="/ezSurvey/setPreviewFlag.do", method = RequestMethod.POST)
	public String setPreviewFlag(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("setPreviewFlag start");
		LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
		String prevMode = request.getParameter("prevMode") != null ? request.getParameter("prevMode") : "";
		
		SurveyGeneralVO userConfig  = ezSurveyService.getUserPreviewConfig(user.getId(), user.getCompanyID(), user.getTenantId());
		try {
			if (userConfig == null) {
				ezSurveyService.saveUserConfig(prevMode, 10, 50, 50, user.getId(), user.getCompanyID(), user.getTenantId());
			} else {
				ezSurveyService.setPreviewFlag(prevMode, user.getId(), user.getCompanyID(), user.getTenantId());
			}	
			
			logger.debug("setPreviewFlag end");
			return "OK";
		} catch (Exception e) {
			logger.debug(e.getMessage());
			return "NO";
		}
	}

	@RequestMapping(value="/ezSurvey/deleteResponse.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject jsonDeleteResponse(@RequestBody JSONObject responseItem, @CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("jsonDeleteResponse started");

		LoginSimpleVO user = loginCookie != null ? commonUtil.userInfoSimple(loginCookie) : new LoginSimpleVO();
		responseItem.put("userId", user.getId());

		JSONObject resultObj = surveyRestService.deleteResponse(request, responseItem);

		logger.debug("jsonDeleteResponse ended");
		return resultObj;
	}

	@ResponseBody
	@RequestMapping(value="/ezSurvey/endSurveyItem.do", method = RequestMethod.POST)
	public void closeSurveyItem(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("endSurveyItem started");
		
		LoginVO user   = commonUtil.userInfo(loginCookie);
		String surveyID = request.getParameter("surveyID");

		ezSurveyService.endSurveyItem(surveyID, user.getId(), user.getTenantId());

		/* 설문종료 시 변경 상태(END)와 기존 surveyId 포함한 WebSocket 메시지 전송 로직 추가 */
		try {
			String result = "{\"status\":\"END\", \"surveyId\":\"" + surveyID + "\"}";
			JSONParser parser = new JSONParser();
			JSONObject json = (JSONObject) parser.parse(result);
			this.template.convertAndSend("/reply/getSeenUpdateForSurvey" + surveyID + "+" + user.getTenantId(), json);
		} catch (Exception e) {
			logger.error("endSurveyItem - getSeenUpdateForSurvey err : " + e.getMessage());
		}

		logger.debug("endSurveyItem ended");
	}
}
