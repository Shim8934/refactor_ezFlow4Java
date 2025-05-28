package egovframework.ezMobile.ezSurvey.service;

import java.util.List;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.let.user.login.vo.LoginVO;

public interface MSurveyService {

	JSONObject getItemsBySearching(String pageMode, int start, int end, String title, MCommonVO userInfo, int userMode) throws Exception;
	JSONObject checkPermission(List<Long> surveyList, int mode, MCommonVO userInfo) throws Exception;
	JSONObject getItemInfo(Long surveyId, String mode, String realPath, MCommonVO userInfo) throws Exception;
	JSONObject getSurveyQuestions(Long surveyId, String logicMode, String realPath, LoginVO userInfo) throws Exception;
	JSONObject saveResponseItem(JSONArray responses, long surveyId, LoginVO userInfo) throws Exception;
	JSONObject getSurveyStatistic(Long surveyId, String realPath, LoginVO userInfo, String adminYN) throws Exception;
}
