package egovframework.ezEKP.ezSurvey.web;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.stream.Collectors;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezSurvey.service.EzSurveyService;
import egovframework.ezEKP.ezSurvey.vo.SimpleDeptVO;
import egovframework.ezEKP.ezSurvey.vo.SimpleUserVO;
import egovframework.ezEKP.ezSurvey.vo.SurveyGeneralVO;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@SuppressWarnings("unchecked")
@RestController
public class EzSurveyGWController {
	private static final Logger logger = LoggerFactory.getLogger(EzSurveyGWController.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private EzSurveyService surveyService;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Resource(name="loginService")
	private LoginService loginService;
	
	@Autowired
	private EzOrganService ezOrganService;
	
	@RequestMapping(value="/rest/ezsurvey/company-tree/comp", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getCompanyTree(HttpServletRequest request) {
		String userId     = request.getParameter("userId")    != null ? request.getParameter("userId")    : "";
		String companyId  = request.getParameter("companyId") != null ? request.getParameter("companyId") : "";
		String deptId     = request.getParameter("deptId")    != null ? request.getParameter("deptId")    : "";
		String serverName = request.getHeader("host-name")    != null ? request.getHeader("host-name")    : "";
		JSONObject result = new JSONObject();
		
		if (userId.equals("") || serverName.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		logger.debug("Company Id: " + companyId + " || serverName: " + serverName + " || User Id: " + userId);
		
		try {
			LoginVO userInfo      = commonUtil.getUserForGw(userId, serverName);
			String primary        = userInfo.getPrimary();
			int tenantId          = userInfo.getTenantId();
			deptId                = deptId.equals("")    ? userInfo.getDeptID()    : deptId;
			companyId             = companyId.equals("") ? userInfo.getCompanyID() : companyId;
			SimpleDeptVO sCompany = new SimpleDeptVO();
			
			if (deptId.equals("")) {
				List<SimpleDeptVO> deptList = surveyService.getAllSubDepts(companyId, 1, primary, tenantId);
				sCompany.setSubDepts(deptList);
			}
			else {
				String deptPath  = surveyService.getDeptPath(deptId, tenantId);
				String[] path    = deptPath.split(",");
				sCompany         = surveyService.getSimpleCompany(companyId, 0, primary, tenantId);
				
				surveyService.getAllDepts(sCompany, path, primary, tenantId, 1, 1);
			}
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("tree", sCompany);
			result.put("node", deptId);
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezsurvey/sub-tree/{deptid:.+}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getSubTree(@PathVariable(value="deptid") String deptId, HttpServletRequest request) {
		String serverName = request.getHeader("host-name") != null ? request.getHeader("host-name")                  : "";
		int level         = request.getParameter("level")  != null ? Integer.parseInt(request.getParameter("level")) : -1;
		String userId     = request.getParameter("userId") != null ? request.getParameter("userId")                  : "";
		JSONObject result = new JSONObject();
		
		logger.debug("deptId: " + deptId + " || level: " + level + " || serverName: " + serverName + " || User Id: " + userId);
		
		if (deptId.equals("") || serverName.equals("") || level == -1 || userId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo            = commonUtil.getUserForGw(userId, serverName);
			List<SimpleDeptVO> subDepts = surveyService.getAllSubDepts(deptId, level + 1, userInfo.getPrimary(), userInfo.getTenantId());
			result.put("status", "ok");
			result.put("code", 0);
			result.put("subNodes", subDepts);
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezsurvey/dept-member/{deptid:.+}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getDeptMembers(@PathVariable(value="deptid") String deptId, Locale locale, HttpServletRequest request) {
		String serverName = request.getHeader("host-name")      != null ? request.getHeader("host-name")                        : "";
		String userId     = request.getParameter("userId")      != null ? request.getParameter("userId")                        : "";
		int currentPage   = request.getParameter("currentPage") != null ? Integer.parseInt(request.getParameter("currentPage")) : -1;
		
		JSONObject result = new JSONObject();
		
		logger.debug("ServerName: " + serverName + " || UserId: " + userId + "|| currentPage: " + currentPage);
		
		if (serverName.equals("") || userId.equals("") || currentPage == -1) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo               = commonUtil.getUserForGw(userId, serverName);
			int tenantId                   = userInfo.getTenantId();
			String primary                 = userInfo.getPrimary();
			int startPoint                 = (currentPage - 1) * 50;
			int totalUsers                 = surveyService.getTotalDeptMembers(deptId, tenantId);
			int totalPages                 = (totalUsers + 49) / 50;
			
			List<SimpleUserVO> memberList = surveyService.getDeptMemberList(deptId, null, null, primary, startPoint, 50, tenantId);
			
			result.put("currentPage", currentPage);
			result.put("totalPages",  totalPages);
			result.put("memberList",  memberList);
			result.put("memberCount", totalUsers);
			result.put("status", "ok");
			result.put("code", 0);
		} 
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezsurvey/list-type/userid/{userid:.+}/get", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getUserListType(@PathVariable(value="userid") String userId, HttpServletRequest request) throws Exception {
		String serverName = request.getHeader("host-name") != null ? request.getHeader("host-name") : "";
		JSONObject result = new JSONObject();
		
		logger.debug("ServerName: " + serverName + " || UserId: " + userId);
		
		if (serverName.equals("") || userId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			String listType  = ezOrganService.getListType(userInfo.getId(), userInfo.getTenantId(), userInfo.getCompanyID());
			
			result.put("listType", listType);
			result.put("status", "ok");
			result.put("code", 0);
		} 
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	/* 2024-07-01 홍승비 - surveyUser.js 파일 내부의 getUsers() 함수에서만 호출되는 URL로, 해당 js파일이 사용되지 않아 전체 주석처리 */
	/*
	@RequestMapping(value="/rest/ezsurvey/search-member", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getSearchMember(Locale locale, HttpServletRequest request) {
		String serverName = request.getHeader("host-name")      != null ? request.getHeader("host-name")                        : "";
		String userId     = request.getParameter("userId")      != null ? request.getParameter("userId")                        : "";
		String srchOption = request.getParameter("srchOption")  != null ? request.getParameter("srchOption")                    : "";
		String srchValue  = request.getParameter("srchValue")   != null ? request.getParameter("srchValue")                     : "";
		int currentPage   = request.getParameter("currentPage") != null ? Integer.parseInt(request.getParameter("currentPage")) : -1;
		
		JSONObject result = new JSONObject();
		
		logger.debug("ServerName: " + serverName + " || UserId: " + userId + " || srchOption : " + srchOption + "|| srchValue" + srchValue + "|| currentPage: " + currentPage);
		
		if (serverName.equals("") || userId.equals("") || srchOption.equals("") || srchValue.equals("") || currentPage == -1) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo               = commonUtil.getUserForGw(userId, serverName);
			int tenantId                   = userInfo.getTenantId();
			String primary                 = userInfo.getPrimary();
			String sqlQuery                = "";
			
			switch(srchOption) {
				case "displayname": sqlQuery = primary.equals("1") ? srchOption : "displayname2" ; break;
				case "description": sqlQuery = primary.equals("1") ? srchOption : "description2" ; break;
				default: sqlQuery = srchOption;
			}
			
			int startPoint                 = (currentPage - 1) * 50;
			int totalUsers                 = surveyService.getTotalSearchMembers(sqlQuery, srchValue, tenantId);
			int totalPages                 = (totalUsers + 49) / 50;
			List<SimpleUserVO> memberList  = surveyService.getSearchMemberList(primary, startPoint, 50, sqlQuery, srchValue, tenantId);
			
			result.put("currentPage", currentPage);
			result.put("totalPages",  totalPages);
			result.put("memberList",  memberList);
			result.put("memberCount", totalUsers);
			result.put("status", "ok");
			result.put("code", 0);
		} 
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
		}
		
		return result;
	}*/
	
	@RequestMapping(value="/rest/ezsurvey/attachfile/file-upload", method= RequestMethod.POST, produces="application/json;charset=utf-8")
	public JSONObject postFileUploadGW(@RequestParam("data") String dataList, @RequestParam("files") List<MultipartFile> multiFileLists, Locale locale, HttpServletRequest request) throws Exception {
		JSONParser jp          = new JSONParser();
		JSONObject jsonObject  = (JSONObject) jp.parse(dataList);
		JSONArray nameArray    = jsonObject.get("nameArray")    != null ? (JSONArray) jsonObject.get("nameArray") : null;
		String serverName      = request.getHeader("host-name") != null ? request.getHeader("host-name")          : "";
		JSONObject result      = new JSONObject();
		
		logger.debug("serverName: " + serverName);
		
		if (nameArray == null || serverName.equals("") || nameArray.size() != multiFileLists.size() || multiFileLists.size() != 1) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			int tenantId    = loginService.getTenantId(serverName);
			String realPath = request.getServletContext().getRealPath("");
			realPath = commonUtil.detectPathTraversal(realPath);
			String filePath = surveyService.saveUploadFile(multiFileLists, nameArray, realPath, tenantId);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("path", filePath);
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value = "/rest/ezsurvey/attachfile/file-download", method=RequestMethod.GET, produces = {MediaType.APPLICATION_OCTET_STREAM_VALUE})
	@ResponseBody
	public void getFileDownload(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String filePath   = request.getParameter("filePath")   != null ? request.getParameter("filePath")  : "";
		String fileName   = request.getParameter("fileName")   != null ? request.getParameter("fileName")  : "";
		String userId     = request.getParameter("userId")     != null ? request.getParameter("userId")    : "";
		String serverName = request.getHeader("host-name")     != null ? request.getHeader("host-name")    : "";
		String userAgent  = request.getParameter("userAgent")  != null ? request.getParameter("userAgent") : "";
		
		logger.debug("serverName: " + serverName + " ||  filePath: " + filePath + " || UserId: " + userId + " || File Name: " + fileName);
		
		if (filePath.equals("") || fileName.equals("") || serverName.equals("") || userId.equals("")) {
			logger.debug("Invalid arguments!!!!!!");
			return;
		}
		
		//Get absolute path of the application
		String realPath = request.getServletContext().getRealPath("");
		realPath = commonUtil.detectPathTraversal(realPath);
		surveyService.getDownloadedFile(fileName, filePath, realPath, userAgent, request, response);
		
		logger.debug("File Download Finish!");
		return;
	}
	
	@RequestMapping(value="/rest/ezsurvey/attachfile/file-delete", method= RequestMethod.DELETE, produces="application/json;charset=utf-8")
	public JSONObject delFileUploadGW(Locale locale, HttpServletRequest request) throws Exception {
		String serverName = request.getHeader("host-name")   != null ? request.getHeader("host-name")   : "";
		String filePath   = request.getParameter("filePath") != null ? request.getParameter("filePath") : "";
		JSONObject result = new JSONObject();
		
		logger.debug("ServerName: " + serverName + " filePath: " + filePath);
		
		if (serverName.equals("") || filePath.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			int tenantId      = loginService.getTenantId(serverName);
			String realPath   = request.getServletContext().getRealPath("");
			realPath = commonUtil.detectPathTraversal(realPath);
			surveyService.deleteAttachFile(filePath, realPath, tenantId);
			
			result.put("status", "ok");
			result.put("code", 0);
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezsurvey/config/id/{userid:.+}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getUserPreviewConfig(@PathVariable(value="userid") String userId, HttpServletRequest request) {
		String serverName = request.getHeader("host-name") != null ? request.getHeader("host-name") : "";
		JSONObject result = new JSONObject();
		
		logger.debug("UserId: " + userId + " || serverName: " + serverName);
		
		if (serverName.equals("") || userId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo            = commonUtil.getUserForGw(userId, serverName);
			int tenantId                = userInfo.getTenantId();
			String companyId            = userInfo.getCompanyID();
			SurveyGeneralVO userConfig  = surveyService.getUserPreviewConfig(userId, userInfo.getCompanyID(), userInfo.getTenantId());
			
			if (userConfig == null) {
				userConfig = new SurveyGeneralVO(userId, companyId, "off", 10, 50, 50, 50, 50, tenantId);
			}
			else {
				userConfig.setPreviewHpercent(100 - userConfig.getContentHpercent());
				userConfig.setPreviewWpercent(100 - userConfig.getContentWpercent());
			}
			
			result.put("config", userConfig);
			result.put("status", "ok");
			result.put("code", 0);
		} 
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezsurvey/config/id/{userid:.+}", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject saveUserConfig(@RequestBody JSONObject configItem, @PathVariable(value="userid") String userId, HttpServletRequest request) {
		String serverName    = request.getHeader("host-name")    != null ? request.getHeader("host-name")    : "";
		String prevMode      = configItem.get("prevMode")  != null ? configItem.get("prevMode").toString()  : "";
		int listCount        = configItem.get("listCount") != null ? Integer.parseInt(configItem.get("listCount").toString()) : -1;
		int contentWPrev     = configItem.get("contentW")  != null ? Integer.parseInt(configItem.get("contentW").toString())  : -1;
		int contentHPrev     = configItem.get("contentH")  != null ? Integer.parseInt(configItem.get("contentH").toString())  : -1;
		JSONObject result    = new JSONObject();
		
		logger.debug("UserId: " + userId + " || serverName: " + serverName + " || Preview Mode: " + prevMode + " || List count: " + listCount + " || ContentHPreview: " + contentHPrev + " || ContentWPreview: " + contentWPrev);
		
		if (serverName.equals("") || userId.equals("") || listCount == -1 || prevMode.equals("") || (!prevMode.equals("off") && (contentWPrev == -1 || contentHPrev == -1))) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		if (prevMode.equals("off")) {
			contentWPrev = 50;
			contentHPrev = 50;
		}
		
		try {
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			surveyService.saveUserConfig(prevMode, listCount, contentWPrev, contentHPrev, userId, userInfo.getCompanyID(), userInfo.getTenantId());
			
			result.put("status", "ok");
			result.put("code", 0);
		} 
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezsurvey/survey-item/save", method=RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject saveSurveyItem(@RequestBody JSONObject surveyItem, HttpServletRequest request, Locale locale) throws Exception {
		JSONObject result   = new JSONObject();
		JSONParser jp       = new JSONParser();
		
		try {
			JSONObject survey   = (JSONObject) jp.parse(surveyItem.toJSONString());
			long surveyId       = survey.get("surveyId")         != null ? (Long)survey.get("surveyId")           : -1;
			int draftMode       = survey.get("draft")            != null ? ((Long)survey.get("draft")).intValue() : 0;
			JSONObject infor    = survey.get("infor")            != null ? (JSONObject) survey.get("infor")       : null;
			JSONArray questions = survey.get("questions")        != null ? (JSONArray) survey.get("questions")    : null;
			String serverName   = request.getHeader("host-name") != null ? request.getHeader("host-name")         : "";
			String userId       = surveyItem.get("userId")       != null ? surveyItem.get("userId").toString()    : "";
			
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			
			if (serverName.equals("") || userId.equals("") || ((questions == null || questions.isEmpty()) && draftMode == 0) || infor == null || infor.toJSONString().equals("")) {
				logger.debug("Parameter error!");
				result.put("status", "error");
				result.put("code", 1);
				return result;
			}
			
			logger.debug("ServerName: " + serverName + " || survey id: " + surveyId + " || draft mode: " + draftMode + " || User id: " + userId + " || question list: " + (questions != null ? questions.toJSONString() : "") + " || survey information: " + infor.toJSONString());
			
			String title            = infor.get("title")      != null ? infor.get("title").toString()              : "";
			String purpose          = infor.get("purpose")    != null ? infor.get("purpose").toString()            : "";
			String startDate        = infor.get("startDate")  != null ? infor.get("startDate").toString()          : "";
			String endDate          = infor.get("endDate")    != null ? infor.get("endDate").toString()            : "";
			String startTime        = infor.get("startTime")  != null ? infor.get("startTime").toString()          : "";
			String endTime          = infor.get("endTime")    != null ? infor.get("endTime").toString()            : "";
			if (!startTime.isEmpty()) startDate = startDate + " " + startTime;
			if (!endTime.isEmpty())   endDate   = endDate   + " " + endTime;
			int publicFlag          = infor.get("public")     != null ? ((Long)infor.get("public")).intValue()     : -1;
			int anonymousFlag       = infor.get("anonymous")  != null ? ((Long)infor.get("anonymous")).intValue()  : -1;
			int userExposedFlag     = infor.get("userExposed")!= null ? ((Long)infor.get("userExposed")).intValue(): 1;
			int multipleFlag        = infor.get("multiple")   != null ? ((Long)infor.get("multiple")).intValue()   : -1;
			int publicDays          = infor.get("publicDays") != null ? ((Long)infor.get("publicDays")).intValue() : -1;
			int mailFlag            = infor.get("mail")       != null ? ((Long)infor.get("mail")).intValue()       : 0;
			int popupFlag           = infor.get("popup")      != null ? ((Long)infor.get("popup")).intValue()      : 0;
			int useStatus           = infor.get("status")     != null ? ((Long)infor.get("status")).intValue()     : 1;
			JSONArray attchList     = infor.get("attach")     != null ? (JSONArray)infor.get("attach")             : null;
			JSONArray users         = infor.get("users")      != null ? (JSONArray)infor.get("users")              : null;
			JSONArray resultViewTarget = infor.get("resultViewTarget") != null ? (JSONArray) infor.get("resultViewTarget") : null;
			int userFlag            = (users == null || users.size() == 0) ? 0 : 1;
			SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
			String closingText      = infor.get("closing")    != null ? infor.get("closing").toString()            : "";
			
			// 2025-02-10 조수빈 - 설문 목적은 필수 값에서 제외하기로 했음
			if (title.equals("") || startDate.equals("") || endDate.equals("") || format.parse(startDate).compareTo(format.parse(endDate)) > 0 || publicFlag == -1 || anonymousFlag == -1 || multipleFlag == -1 || (publicFlag == 1 && publicDays == -1)) {
				logger.debug("Parameter error!");
				result.put("status", "error");
				result.put("code", 1);
				return result;
			}
			
			String realPath  = request.getServletContext().getRealPath("");
			result           = surveyService.saveSurveyItem(request, realPath, questions, title, purpose, startDate, endDate, publicFlag, anonymousFlag, multipleFlag, userFlag, publicDays, attchList, users, useStatus, surveyId, draftMode, userInfo, mailFlag, popupFlag, closingText, userExposedFlag);
		
			if (publicFlag == 2 && resultViewTarget != null) {
				Long NewSurveyId = (Long) result.get("survey_id");
				surveyService.saveSurveyResultViewTarget(userInfo, NewSurveyId, resultViewTarget);
			}
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezsurvey/survey-item/get", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getItems(Locale locale, HttpServletRequest request) throws Exception {
		String serverName    = request.getHeader("host-name")      != null ? request.getHeader("host-name")                        : "";
		String userId        = request.getParameter("userId")      != null ? request.getParameter("userId")                        : "";
		String title         = request.getParameter("title")       != null ? request.getParameter("title")                         : "";
		String pageMode      = request.getParameter("pageMode")    != null ? request.getParameter("pageMode")                      : "";
		String creatorName   = request.getParameter("creatorName") != null ? request.getParameter("creatorName")                   : "";
		String startDate     = request.getParameter("startDate")   != null ? request.getParameter("startDate")                     : "";
		String endDate       = request.getParameter("endDate")     != null ? request.getParameter("endDate")                       : "";
		String column        = request.getParameter("column")      != null ? request.getParameter("column")                        : "";
		String order         = request.getParameter("order")       != null ? request.getParameter("order")                         : "";
		String srchMode      = request.getParameter("srchMode")    != null ? request.getParameter("srchMode")                      : "";
		String srchOption    = request.getParameter("srchOption")  != null ? request.getParameter("srchOption")                    : "";
		String filterStatus    = request.getParameter("filterStatus")  != null ? request.getParameter("filterStatus")                    : "";
		int listCntSize      = request.getParameter("listCntSize") != null ? Integer.parseInt(request.getParameter("listCntSize")) : -1;
		int currentPage      = request.getParameter("currentPage") != null ? Integer.parseInt(request.getParameter("currentPage")) : -1;
		int userMode         = request.getParameter("userMode")    != null ? Integer.parseInt(request.getParameter("userMode"))    : -1;
		JSONObject result    = new JSONObject();
		
		logger.debug("pageMode: " + pageMode + " || Title: " + title + " || Creator name: " + creatorName + " || Start Date: " + startDate + " || End Date: " + endDate + " || Column: " + column + " || Order: " + order + " || Search mode: " + srchMode + " || Search option: " + srchOption + " || List count: " + listCntSize + " || userMode: " + userMode);
		
		if (serverName.equals("") || pageMode.equals("") || userId.equals("") || currentPage < 1 || listCntSize < 1) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			result = surveyService.getItemsBySearching(pageMode, currentPage, listCntSize, title, creatorName, startDate, endDate, srchMode, srchOption, order, column, userInfo, userMode, filterStatus);
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezsurvey/survey-popupItem/get", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getPopupItems(Locale locale, HttpServletRequest request) throws Exception {
		String serverName    = request.getHeader("host-name")      != null ? request.getHeader("host-name")    : "";
		String mode          = request.getParameter("mode")        != null ? request.getParameter("mode")      : "";
		String userId        = request.getParameter("userId")      != null ? request.getParameter("userId")    : "";
		JSONObject result    = new JSONObject();
		
		if (userId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			result = surveyService.getPopupItems(mode, userInfo);
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezsurvey/survey-item/delete", method= RequestMethod.DELETE, produces="application/json;charset=utf-8")
	public JSONObject deleteItems(@RequestParam(value = "itemList") List<String> itemList, Locale locale, HttpServletRequest request) throws Exception {
		String serverName = request.getHeader("host-name")     != null ? request.getHeader("host-name")     : "";
		String userId     = request.getParameter("userId")     != null ? request.getParameter("userId")     : "";
		JSONObject result = new JSONObject();
		
		logger.debug("ServerName: " + serverName + " ||  userId: " + userId + " || itemList: " + String.join(",", itemList));
		
		if (serverName.equals("") || itemList.size() == 0 || userId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo       = commonUtil.getUserForGw(userId, serverName);
			List<Long> itemIdList  = itemList.stream().map(Long::parseLong).collect(Collectors.toList());
			
			//Add checking permission here
			JSONObject permission  = surveyService.checkPermission(itemIdList, 1, userInfo);
			
			if ((int)permission.get("code") == 3) {
				result.put("status", "error");
				result.put("code", 3);
				return result;
			}
			
			surveyService.deleteItems(itemIdList, userInfo);
			
			result.put("status", "ok");
			result.put("code", 0);
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezsurvey/survey-item/check", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject checkItems(Locale locale, HttpServletRequest request) throws Exception {
		String serverName = request.getHeader("host-name")   != null ? request.getHeader("host-name")   : "";
		String userId     = request.getParameter("userId")   != null ? request.getParameter("userId")   : "";
		JSONObject result = new JSONObject();
		
		logger.debug("ServerName: " + serverName + " ||  userId: " + userId);
		
		if (serverName.equals("") || userId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			result.put("code", isSurveyAdmin(userInfo) ? 0 : 3);
			result.put("status", "ok");
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezsurvey/survey-item/state", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject changeSurveyState(Locale locale, HttpServletRequest request) throws Exception {
		String serverName = request.getHeader("host-name")   != null ? request.getHeader("host-name")   : "";
		String userId     = request.getParameter("userId")   != null ? request.getParameter("userId")   : "";
		String itemId     = request.getParameter("surveyId") != null ? request.getParameter("surveyId") : "";
		JSONObject result = new JSONObject();
		
		logger.debug("ServerName: " + serverName + " ||  userId: " + userId + " || itemId: " + itemId);
		
		if (serverName.equals("") || itemId.equals("") || userId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			result           = surveyService.changeSurveyState(itemId, userInfo);
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezsurvey/survey-processing/check", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject checkProcessingItem(Locale locale, HttpServletRequest request) throws Exception {
		String serverName = request.getHeader("host-name")   != null ? request.getHeader("host-name")   : "";
		String userId     = request.getParameter("userId")   != null ? request.getParameter("userId")   : "";
		String itemId     = request.getParameter("surveyId") != null ? request.getParameter("surveyId") : "";
		JSONObject result = new JSONObject();
		
		logger.debug("ServerName: " + serverName + " ||  userId: " + userId + " || itemId: " + itemId);
		
		if (serverName.equals("") || itemId.equals("") || userId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			result           = surveyService.checkProcessing(itemId, userInfo);
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezsurvey/user-info/{userid:.+}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getSurveyAdministratorInfo(@PathVariable(value="userid") String userId, Locale locale, HttpServletRequest request) throws Exception {
		String serverName = request.getHeader("host-name") != null ? request.getHeader("host-name") : "";
		JSONObject result = new JSONObject();
		
		logger.debug("ServerName: " + serverName + " ||  userId: " + userId);
		
		if (serverName.equals("") || userId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			result.put("mode", isSurveyAdmin(userInfo) ? 1 : 0);
			result.put("status", "ok");
			result.put("code", 0);
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezsurvey/survey-item/info", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getItemInfo(Locale locale, HttpServletRequest request) throws Exception {
		String serverName = request.getHeader("host-name") != null ? request.getHeader("host-name") : "";
		String userId     = request.getParameter("userId") != null ? request.getParameter("userId") : "";
		String itemId     = request.getParameter("itemId") != null ? request.getParameter("itemId") : "";
		String mode       = request.getParameter("mode")   != null ? request.getParameter("mode")   : "";
		JSONObject result = new JSONObject();
		
		logger.debug("ServerName: " + serverName + " ||  userId: " + userId + " || itemId: " + itemId + " || mode: " + mode);
		
		if (serverName.equals("") || itemId.equals("")|| userId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo   = commonUtil.getUserForGw(userId, serverName);
			Long surveyId      = Long.parseLong(itemId);
			String realPath    = request.getServletContext().getRealPath("");
			
			if (mode.equals("reuse")) {
				if (!isSurveyAdmin(userInfo)) {
					result.put("status", "error");
					result.put("code", 3);
				}
			}
			else {
				List<Long> items   = new ArrayList<>();
				items.add(Long.parseLong(itemId));
				int checkPri       = mode.equals("normal") ? 2 : 1;
				JSONObject check   = surveyService.checkPermission(items, checkPri, userInfo);
				
				if ((int)check.get("code") != 0) {
					return check;
				}
			}
			
			result = surveyService.getItemInfo(surveyId, mode, realPath, userInfo);
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezsurvey/survey-item/questions", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getSurveyQuestions(Locale locale, HttpServletRequest request) throws Exception {
		String serverName = request.getHeader("host-name") != null ? request.getHeader("host-name") : "";
		String userId     = request.getParameter("userId") != null ? request.getParameter("userId") : "";
		String itemId     = request.getParameter("itemId") != null ? request.getParameter("itemId") : "";
		String logicMode  = request.getParameter("logic")  != null ? request.getParameter("logic")  : "";
		JSONObject result = new JSONObject();
		
		logger.debug("ServerName: " + serverName + " ||  userId: " + userId + " || itemId: " + itemId + " || logicMode: " + logicMode);
		
		if (serverName.equals("") || itemId.equals("")|| userId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			Long surveyId    = Long.parseLong(itemId);
			String realPath  = request.getServletContext().getRealPath("");
			result           = surveyService.getSurveyQuestions(surveyId, logicMode, realPath, userInfo);
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezsurvey/response-item/save", method=RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject saveResponseItem(@RequestBody JSONObject responseItem, HttpServletRequest request, Locale locale) throws Exception {
		JSONObject result   = new JSONObject();
		JSONParser jp       = new JSONParser();
		
		try {
			JSONObject response  = (JSONObject) jp.parse(responseItem.toJSONString());
			long surveyId        = response.get("surveyId")              != null ? (Long)response.get("surveyId")        : -1;
			JSONArray responses  = (JSONArray) response.get("responses") != null ? (JSONArray) response.get("responses") : null;
			String serverName    = request.getHeader("host-name")        != null ? request.getHeader("host-name")        : "";
			String userId        = responseItem.get("userId")            != null ? responseItem.get("userId").toString() : "";
			
			logger.debug("ServerName: " + serverName + " ||  userId: " + userId + " || surveyId: " + surveyId);
			
			if (serverName.equals("") || userId.equals("") || (responses == null || responses.size() == 0)) {
				logger.debug("Parameter error!");
				result.put("status", "error");
				result.put("code", 1);
				return result;
			}

			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);

			/* 응답 시 현재 설문의 상태(수정/삭제/일시정지)를 확인 */
			int surveyState = surveyService.checkEditingState(surveyId, userInfo.getCompanyID(), userInfo.getTenantId());
			if (1 == surveyState) {
				logger.debug("Survey in edit mode. surveyId={}", surveyId);
				result.put("status", "editing");
				result.put("code", 8);
				return result;
			} else if (-1 == surveyState) {
				logger.debug("Survey has been deleted. surveyId={}", surveyId);
				result.put("status", "deleted");
				result.put("code", 8);
				return result;
			} else if (2 == surveyState) {
				logger.debug("Survey is in paused state. surveyId={}", surveyId);
				result.put("status", "paused");
				result.put("code", 8);
			} else {
				result = surveyService.saveResponseItem(responses, surveyId, userInfo);
			}
		}
		
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezsurvey/survey-item/statistic", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getSurveyStatistic(Locale locale, HttpServletRequest request) throws Exception {
		String serverName = request.getHeader("host-name") != null ? request.getHeader("host-name") : "";
		String userId     = request.getParameter("userId") != null ? request.getParameter("userId") : "";
		String itemId     = request.getParameter("itemId") != null ? request.getParameter("itemId") : "";
		JSONObject result = new JSONObject();
		
		logger.debug("ServerName: " + serverName + " ||  userId: " + userId + " || itemId: " + itemId);
		
		if (serverName.equals("") || itemId.equals("")|| userId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			Long surveyId    = Long.parseLong(itemId);
			String realPath  = request.getServletContext().getRealPath("");
			String adminYN = isSurveyAdmin(userInfo) ? "Y" : "N";
			result           = surveyService.getSurveyStatistic(surveyId, realPath, userInfo, adminYN);
			// 2019-03-05 황윤호 권한 체크 (전체 | 회사 | 설문)
			result.put("adminYN", adminYN);
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	private boolean isSurveyAdmin(LoginVO userInfo) throws Exception {
		return commonUtil.isAdmin(userInfo.getId(), userInfo.getTenantId(), userInfo.getRollInfo(), "c;l;k");
	}
	
	@RequestMapping(value="/rest/ezsurvey/check/respondent", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject checkRespondent(HttpServletRequest request) throws Exception {
		String serverName = request.getHeader("host-name") != null ? request.getHeader("host-name") : "";
		String userId     = request.getParameter("userId") != null ? request.getParameter("userId") : "";
		String itemId     = request.getParameter("itemId") != null ? request.getParameter("itemId") : "";
		JSONObject result = new JSONObject();
		
		logger.debug("ServerName: " + serverName + " ||  userId: " + userId + " || itemId: " + itemId);
		
		if (serverName.equals("") || itemId.equals("")|| userId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			Long surveyId    = Long.parseLong(itemId);
			result = surveyService.checkRespondent(surveyId, userInfo);
			
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		return result;
	}
	
	@RequestMapping(value="/rest/ezsurvey/response-item/delete", method=RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject deleteResponse(@RequestBody JSONObject responseItem, HttpServletRequest request) throws Exception {
		JSONObject result   = new JSONObject();
		JSONParser jp       = new JSONParser();

		try {
			JSONObject response  = (JSONObject) jp.parse(responseItem.toJSONString());
			long surveyId        = response.get("surveyId")           != null ? (Long)response.get("surveyId")        : -1;
			String serverName    = request.getHeader("host-name")  != null ? request.getHeader("host-name")  	  : "";
			String userId        = responseItem.get("userId")         != null ? responseItem.get("userId").toString() : "";

			logger.debug("ServerName: " + serverName + " ||  userId: " + userId + " || surveyId: " + surveyId);

			if ("".equals(serverName) || "".equals(userId)) {
				logger.debug("Parameter error!");
				result.put("status", "error");
				result.put("code", 1);
				return result;
			}

			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			surveyService.deleteResponseItem(surveyId, userInfo);
			result.put("status", "ok");
			result.put("code", 9);

		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}

		return result;
	}
}
