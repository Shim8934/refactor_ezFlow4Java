package egovframework.ezEKP.ezSurvey.service;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.web.multipart.MultipartFile;

import egovframework.ezEKP.ezSurvey.vo.SimpleDeptVO;
import egovframework.ezEKP.ezSurvey.vo.SimpleUserVO;
import egovframework.ezEKP.ezSurvey.vo.SurveyGeneralVO;
import egovframework.ezEKP.ezSurvey.vo.SurveyParticipantVO;
import egovframework.ezEKP.ezSurvey.vo.SurveyVO;
import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.ezEKP.ezSurvey.vo.RespondentVO;
import egovframework.let.user.login.vo.LoginSimpleVO;

public interface EzSurveyService {
	//Company Tree process functions
	List<SimpleDeptVO> getAllSubDepts(String companyId, int level, String primary, int tenantId) throws Exception;
	String getDeptPath(String deptId, int tenantId) throws Exception;
	SimpleDeptVO getSimpleCompany(String deptId, int level, String primary, int tenantId) throws Exception;
	void getAllDepts(SimpleDeptVO sDept, String[] path, String primary, int tenantId, int order, int level) throws Exception;
	int getTotalDeptMembers(String deptId, int tenantId) throws Exception;
	List<SimpleUserVO> getDeptMemberList(String deptId, List<String> deptList, List<String> subDeptsList, String primary, int startPoint, int listcnt, int tenantId) throws Exception;
	// int getTotalSearchMembers(String sqlQuery, String srchValue, int tenantId) throws Exception;
	// List<SimpleUserVO> getSearchMemberList(String primary, int startPoint, int listcnt, String sqlQuery, String srchValue, int tenantId) throws Exception;
	
	//Check user permission + survey status
	JSONObject checkPermission(List<Long> surveyList, int mode, LoginVO userInfo) throws Exception;
	JSONObject checkProcessing(String itemId, LoginVO userInfo) throws Exception;

    List<SimpleUserVO> getSearchMemberListByAttr(String primary, String srchOption, List<String> attrList, int tenantId) throws Exception;

    //User preview config functions
	SurveyGeneralVO getUserPreviewConfig(String userId, String companyID, int tenantId) throws Exception;
	void saveUserConfig(String prevMode, int listCount, int contentWPrev, int contentHPrev, String userId, String companyId, int tenantId) throws Exception;
	
	//User upload/download/delete attach file functions
	String saveUploadFile(List<MultipartFile> multiFileLists, JSONArray nameArray, String realPath, int tenantId) throws Exception;
	void deleteAttachFile(String filePath, String realPath, int tenantId) throws Exception;
	void getDownloadedFile(String fileName, String filePath, String realPath, String userAgent, HttpServletRequest request, HttpServletResponse response) throws Exception;
	
	//Save/Delete/Get survery item
	JSONObject saveSurveyItem(HttpServletRequest request, String realPath, JSONArray questions, String title, String purpose, String startDate, String endDate, int publicFlag, int anonymousFlag, int multipleFlag, int userFlag, int publicDays, JSONArray attchList, JSONArray users, int useStatus, long surveyId, int drafMode, LoginVO userInfo, int mailFlag, int popupFlag, String closingText, int userExposedFlag) throws Exception;
	JSONObject getItemsBySearching(String pageMode, int currentPage, int listCntSize, String title, String creatorName, String startDate, String endDate, String srchMode, String srchOption, String order, String column, LoginVO userInfo, int userMode, String filterStatus) throws Exception;
	JSONObject getPopupItems(String mode, /*String startDate, String endDate,*/ LoginVO userInfo) throws Exception;
	void deleteItems(List<Long> itemIdList, LoginVO userInfo) throws Exception;
	JSONObject getItemInfo(Long surveyId, String mode, String realPath, LoginVO userInfo) throws Exception;
	JSONObject getSurveyQuestions(Long surveyId, String logicMode, String realPath, LoginVO userInfo) throws Exception;
	JSONObject changeSurveyState(String itemId, LoginVO userInfo) throws Exception;
	JSONObject saveResponseItem(JSONArray responses, long surveyId, LoginVO userInfo) throws Exception;
	JSONObject getSurveyStatistic(Long surveyId, String realPath, LoginVO userInfo, String adminYN) throws Exception;
	
	//Get survey List
	List<SurveyVO> getTodaySurveyList(int offset);
	List<SurveyParticipantVO> getSurveyParticipantListForMail(long surveyId, String companyId, int tenantId);
	List<SurveyParticipantVO> getSurveySubDeptListForMail(long surveyId, String companyId, int tenantId);
	void updateMailSentFlag(long surveyId, int mailSentFlag, String companyId, int tenantId) throws Exception;
	JSONObject checkRespondent(Long surveyId, LoginVO userInfo);
	int getSurveyIngCnt(MCommonVO userInfo) throws Exception;
	String checkTenantConfig(String propertyName, int tenantID) throws Exception;
	
	void setPreviewFlag(String prevMode, String userId, String companyId, int tenantId) throws Exception;

	// 2024-07-12 전인하 - 설문 > 설문결과 지정공개 대상자 저장
    public void saveSurveyResultViewTarget(LoginVO userInfo, Long survey_id, JSONArray resultViewTarget) throws Exception;

	// 2024-07-12 전인하 - 설문 > 설문결과 지정공개 대상자 리스트 조회
	public JSONArray getSurveyResultViewTarget(LoginVO userInfo, Long survey_id) throws Exception;

	// 2024-07-12 전인하 - 설문 > 사용자가 결과조회 가능한 설문 id 조회
	public List<Long> getUserReceivedSurveyResultList(LoginVO userInfo, long surveyId) throws Exception;
	public void updateTotalNotiSentFlag(long surveyId, int mailSentFlag, String companyId, int tenantId) throws Exception;

	public int checkEditingState(long surveyId, String companyId, int tenantId) throws Exception;
	// 2025-05-23 양지혜 - 설문 > 응답삭제
    public void deleteResponseItem(long surveyId, LoginVO userInfo) throws Exception;

    // 2025-06-13 양지혜 - 설문 > 진행중 설문 > 설문종료
	public void endSurveyItem(String surveyID, String userId, int tenantId) throws Exception;

	// 2025-06-13 양지혜 - 설문 > 설문 종료여부 확인
	public String checkfinishSurvey(String endDate, String offset) throws Exception;

	public void pauseSurvey(String surveyID, String type, int tenantId) throws Exception;

    public List<RespondentVO> getSurveyParticipantList(String surveyId, LoginSimpleVO userInfo, int currentPage, int listCntSize, String orderCol, String orderType, String locale) throws Exception;

    public int getSurveyParticipantCnt(String surveyId, String companyID, int tenantId) throws Exception;

	public SurveyVO getOneSurveyInfo(String surveyId, String companyID, int tenantId, String offset) throws Exception;

    public String drawWinnersByCount(String surveyId, int lotteryCnt, String companyID, int tenantId) throws Exception;

	public String assignRandomNumbers(String surveyId, String companyID, int tenantId) throws Exception;

	public String checkHasLotteryResult(String surveyId, String companyID, int tenantId) throws Exception;

	public void checkResponseFlag(Object surveyId, String companyID, int tenantId) throws Exception;
}
