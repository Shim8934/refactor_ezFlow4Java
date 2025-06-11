package egovframework.ezMobile.ezSurvey.web;

import java.io.File;
import java.io.FileNotFoundException;
import java.nio.file.Files;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import egovframework.let.utl.fcc.service.EzFAL;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezMobile.ezOption.service.MOptionService;
import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.ezMobile.ezSurvey.service.MSurveyService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

@RestController
public class MSurveyGWController {
	private static final Logger logger = LoggerFactory.getLogger(MSurveyGWController.class);
	
	public static final int BUFF_SIZE = 2048;
	
	@Resource(name="crypto") 
	private EgovFileScrty egovFileScrty;

	@Autowired
	private CommonUtil commonUtil;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Resource(name="EzCommonService")
	private EzCommonService ezCommonService;
	
	@Resource(name="MOptionService")
	private MOptionService mOptionService;
	
	@Resource(name="MSurveyService")
	private MSurveyService mSurveyService;
	
	@Resource(name = "jspw")
	private String jspw;
	
	/**
	 * 2023-06-29 - 한태훈 > 모바일 G/W 전자설문 [GET] 전자설문 리스트 가져오기
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezSurvey/surveylist/{userId:.+}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getSurveyList(@PathVariable String userId, HttpServletRequest request, Model model) {		
		logger.debug("MOBILE G/W Survey [GET /mobile/ezSurvey/surveylist/{userId}] started.");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			String title = request.getParameter("title") != null && !request.getParameter("title").equals("") ? request.getParameter("title") : "";
			String pageMode = request.getParameter("pageMode") != null ? request.getParameter("pageMode") : "";
			int start = request.getParameter("start") != null && !request.getParameter("start").equals("") ? Integer.parseInt(request.getParameter("start")) : -1;
			int userMode = request.getParameter("userMode") != null && !request.getParameter("userMode").equals("") ? Integer.parseInt(request.getParameter("userMode")) : -1;
			int end = request.getParameter("end") != null && !request.getParameter("end").equals("") ? Integer.parseInt(request.getParameter("end")) : -1;
			
			if (serverName.equals("") || pageMode.equals("") || userId.equals("") || start < 0) {
				logger.debug("Parameter error!");
				result.put("status", "error");
				result.put("code", 1);
				return result;
			}
			
			result = mSurveyService.getItemsBySearching(pageMode, start, end, title, info, userMode);
			
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		logger.debug("MOBILE G/W Survey [GET /mobile/ezSurvey/surveylist/{userId}] ended.");
		
		return result;
	}
	
	/**
	 * 2023-08-07 - 한태훈 > 모바일 G/W 전자설문 [GET] 전자설문 정보 가져오기
	 */
	@RequestMapping(value="/mobile/ezSurvey/survey-item/info", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getItemInfo(Locale locale, HttpServletRequest request) throws Exception {
		logger.debug("MOBILE G/W Survey [GET /mobile/ezSurvey/survey-item/info] started.");
		
		String serverName = request.getHeader("x-user-host") != null ? request.getHeader("x-user-host") : "";
		String userId = request.getParameter("userId") != null ? request.getParameter("userId") : "";
		String itemId = request.getParameter("itemId") != null ? request.getParameter("itemId") : "";
		String mode = request.getParameter("mode") != null ? request.getParameter("mode") : "";
		JSONObject result = new JSONObject();
		
		logger.debug("ServerName: " + serverName + " ||  userId: " + userId + " || itemId: " + itemId + " || mode: " + mode);
		
		if (serverName.equals("") || itemId.equals("")|| userId.equals("")) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			return result;
		}
		
		try {
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			Long surveyId = Long.parseLong(itemId);
			String realPath = request.getServletContext().getRealPath("");
			
			List<Long> items = new ArrayList<>();
			items.add(Long.parseLong(itemId));
			int checkPri = mode.equals("normal") ? 2 : 1;
			JSONObject check = mSurveyService.checkPermission(items, checkPri, info);
			
			if ((int)check.get("code") != 0) {
				return check;
			}
			
			result = mSurveyService.getItemInfo(surveyId, mode, realPath, info);
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		logger.debug("MOBILE G/W Survey [GET /mobile/ezSurvey/survey-item/info] ended.");
		
		return result;
	}
	
	/**
	 * 2023-08-07 - 한태훈 > 모바일 G/W 전자설문 [GET] 전자설문 질문들 가져오기
	 */
	@RequestMapping(value="/mobile/ezSurvey/survey-item/questions", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getSurveyQuestions(Locale locale, HttpServletRequest request) throws Exception {
		logger.debug("MOBILE G/W Survey [GET /mobile/ezSurvey/survey-item/questions] started");
		
		String serverName = request.getHeader("x-user-host") != null ? request.getHeader("x-user-host") : "";
		String userId = request.getParameter("userId") != null ? request.getParameter("userId") : "";
		String itemId = request.getParameter("itemId") != null ? request.getParameter("itemId") : "";
		String logicMode = request.getParameter("logic")  != null ? request.getParameter("logic") : "";
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
			Long surveyId = Long.parseLong(itemId);
			String realPath = request.getServletContext().getRealPath("");
			result = mSurveyService.getSurveyQuestions(surveyId, logicMode, realPath, userInfo);
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		logger.debug("MOBILE G/W Survey [GET /mobile/ezSurvey/survey-item/questions] ended");
		
		return result;
	}
	
	/**
	 * 2023-08-07 - 한태훈 > 모바일 G/W 전자설문 [GET] 전자설문 첨부파일 다운로드
	 */
	@RequestMapping(value = "/mobile/ezSurvey/attachfile/file-download", method=RequestMethod.GET, produces="application/json;charset=utf-8")
	@ResponseBody
	public JSONObject getFileDownload(HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("MOBILE G/W Survey [GET /mobile/ezSurvey/attachfile/file-download] started");
		
		String filePath = request.getParameter("filePath") != null ? request.getParameter("filePath") : "";
		String fileName = request.getParameter("fileName") != null ? request.getParameter("fileName") : "";
		String userId = request.getParameter("userId") != null ? request.getParameter("userId") : "";
		String serverName = request.getHeader("x-user-host") != null ? request.getHeader("x-user-host") : "";
		String userAgent = request.getParameter("userAgent") != null ? request.getParameter("userAgent") : "";
		JSONObject result = new JSONObject ();
		logger.debug("serverName: " + serverName + " ||  filePath: " + filePath + " || UserId: " + userId + " || File Name: " + fileName);
		
		LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
		
		if (filePath.equals("") || fileName.equals("") || serverName.equals("") || userId.equals("")) {
			logger.debug("Invalid arguments!!!!!!");
			return result;
		}
		
		//Get absolute path of the application
		String realPath = request.getServletContext().getRealPath("");
		realPath = commonUtil.detectPathTraversal(realPath);
		
		EzFAL.EzFile file = new EzFAL.EzFile(realPath + commonUtil.detectPathTraversal(filePath));
		
		if (!file.exists()) {
			throw new FileNotFoundException(fileName);
		}
		
		if (!file.isFile()) {
			throw new FileNotFoundException(fileName);
		}
		
		String tempDirPath = commonUtil.getUploadPath("upload_survey.ROOT", userInfo.getTenantId()) + commonUtil.separator + "tempUploadFile";
		EzFAL.EzFile tempDir = new EzFAL.EzFile(tempDirPath);
		if (!tempDir.exists()) {
			tempDir.mkdirs();
		}
		
		String tempFilePath = realPath + tempDirPath + realPath;
		EzFAL.EzFile tempFile = new EzFAL.EzFile(tempFilePath);
		EzFAL.copyFile(file, tempFile);
		
		byte[] fileBytes = Files.readAllBytes(tempFile.toPath());
		tempFile.delete();
		
		JSONObject data = new JSONObject();
		data.put("bytes", fileBytes);
		result.put("data", data);
		
		logger.debug("MOBILE G/W Survey [GET /mobile/ezSurvey/attachfile/file-download] ended");
		return result;
	}
	
	/**
	 * 2023-08-07 - 한태훈 > 모바일 G/W 전자설문 [PUT] 전자설문 응답 저장하기
	 */
	@RequestMapping(value="/mobile/ezSurvey/response-item/save", method=RequestMethod.PUT, produces="application/json;charset=utf-8")
	public JSONObject saveResponseItem(@RequestBody JSONObject responseItem, HttpServletRequest request, Locale locale) throws Exception {
		logger.debug("MOBILE G/W Survey [PUT /mobile/ezSurvey/response-item/save] started");
		
		JSONObject result = new JSONObject();
		JSONParser jp = new JSONParser();
		
		try {
			JSONObject response  = (JSONObject) jp.parse(responseItem.toJSONString());
			long surveyId = response.get("surveyId") != null ? (Long)response.get("surveyId") : -1;
			JSONArray responses = (JSONArray) response.get("responses") != null ? (JSONArray) response.get("responses") : null;
			String serverName = request.getHeader("x-user-host") != null ? request.getHeader("x-user-host") : "";
			String userId = responseItem.get("userId") != null ? responseItem.get("userId").toString() : "";
			
			logger.debug("ServerName: " + serverName + " ||  userId: " + userId + " || surveyId: " + surveyId);
			
			if (serverName.equals("") || userId.equals("") || (responses == null || responses.size() == 0)) {
				logger.debug("Parameter error!");
				result.put("status", "error");
				result.put("code", 1);
				return result;
			}
			
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			result = mSurveyService.saveResponseItem(responses, surveyId, userInfo);
		}
		
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		logger.debug("MOBILE G/W Survey [PUT /mobile/ezSurvey/response-item/save] ended");
		
		return result;
	}
	
	/**
	 * 2023-08-07 - 한태훈 > 모바일 G/W 전자설문 [PUT] 전자설문 결과분석 정보 가져오기
	 */
	@RequestMapping(value="/mobile/ezSurvey/survey-item/statistic", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getSurveyStatistic(Locale locale, HttpServletRequest request) throws Exception {
		logger.debug("MOBILE G/W Survey [GET /mobile/ezSurvey/survey-item/statistic] started");
		
		String serverName = request.getHeader("x-user-host") != null ? request.getHeader("x-user-host") : "";
		String userId = request.getParameter("userId") != null ? request.getParameter("userId") : "";
		String itemId = request.getParameter("itemId") != null ? request.getParameter("itemId") : "";
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
			Long surveyId = Long.parseLong(itemId);
			String realPath = request.getServletContext().getRealPath("");
			String adminYN = "N";
			if (userInfo.getRollInfo().contains("c=1") || userInfo.getRollInfo().contains("k=1") || userInfo.getRollInfo().contains("l=1")) { 
				adminYN = "Y";
			}
			result = mSurveyService.getSurveyStatistic(surveyId, realPath, userInfo, adminYN);
			// 2019-03-05 황윤호 권한 체크 (전체 | 회사 | 설문)
			result.put("adminYN", adminYN);
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 2);
		}
		
		logger.debug("MOBILE G/W Survey [GET /mobile/ezSurvey/survey-item/statistic] ended");
		
		return result;
	}
}
