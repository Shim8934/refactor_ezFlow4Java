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
import egovframework.let.user.login.vo.LoginVO;

public interface EzSurveyService {
	//Company Tree process functions
	List<SimpleDeptVO> getAllSubDepts(String companyId, int level, String primary, int tenantId) throws Exception;
	String getDeptPath(String deptId, int tenantId) throws Exception;
	SimpleDeptVO getSimpleCompany(String deptId, int level, String primary, int tenantId) throws Exception;
	void getAllDepts(SimpleDeptVO sDept, String[] path, String primary, int tenantId, int order, int level) throws Exception;
	int getTotalDeptMembers(String deptId, int tenantId) throws Exception;
	List<SimpleUserVO> getDeptMemberList(String deptId, String primary, int startPoint, int listcnt, int tenantId) throws Exception;
	int getTotalSearchMembers(String sqlQuery, String srchValue, int tenantId) throws Exception;
	List<SimpleUserVO> getSearchMemberList(String primary, int startPoint, int listcnt, String sqlQuery, String srchValue, int tenantId) throws Exception;
	
	//Check user permission
	JSONObject checkPermission(List<Long> surveyList, int mode, LoginVO userInfo) throws Exception;
	
	//User preview config functions
	SurveyGeneralVO getUserPreviewConfig(String userId, String companyID, int tenantId) throws Exception;
	void saveUserConfig(String prevMode, int listCount, int contentWPrev, int contentHPrev, String userId, String companyId, int tenantId) throws Exception;
	
	//User upload/download/delete attach file functions
	String saveUploadFile(List<MultipartFile> multiFileLists, JSONArray nameArray, String realPath, int tenantId) throws Exception;
	void deleteAttachFile(String filePath, String realPath, int tenantId) throws Exception;
	void getDownloadedFile(String fileName, String filePath, String realPath, String userAgent, HttpServletRequest request, HttpServletResponse response) throws Exception;
	
	//Save/Delete/Get survery item
	JSONObject saveSurveyItem(String realPath, JSONArray questions, String title, String purpose, String startDate, String endDate, int publicFlag, int anonymousFlag, int multipleFlag, int userFlag, int publicDays, JSONArray attchList, JSONArray users, int useStatus, LoginVO userInfo) throws Exception;
	JSONObject getItemsBySearching(String pageMode, int currentPage, int listCntSize, String title, String creatorName, String startDate, String endDate, String sqlQuery, String srchMode, String srchOption, String order, String column, LoginVO userInfo) throws Exception;
	void deleteItems(List<Long> itemIdList, LoginVO userInfo) throws Exception;
	JSONObject getItemInfoToReuse(Long surveyId, String realPath, LoginVO userInfo) throws Exception;
	JSONObject getSurveyQuestions(Long surveyId, String realPath, LoginVO userInfo) throws Exception;
}
