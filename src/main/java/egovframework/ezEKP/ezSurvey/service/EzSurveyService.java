package egovframework.ezEKP.ezSurvey.service;

import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.json.simple.JSONArray;
import org.springframework.web.multipart.MultipartFile;
import egovframework.ezEKP.ezSurvey.vo.SimpleDeptVO;
import egovframework.ezEKP.ezSurvey.vo.SimpleUserVO;
import egovframework.ezEKP.ezSurvey.vo.SurveyGeneralVO;

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
	
	//User preview config functions
	SurveyGeneralVO getUserPreviewConfig(String userId, String companyID, int tenantId) throws Exception;
	void saveUserConfig(String prevMode, int listCount, int contentWPrev, int contentHPrev, String userId, String companyId, int tenantId) throws Exception;
	
	//User upload/download/delete attach file functions
	String saveUploadFile(List<MultipartFile> multiFileLists, JSONArray nameArray, String realPath, int tenantId) throws Exception;
	void deleteAttachFile(String filePath, String realPath, int tenantId) throws Exception;
	void getDownloadedFile(String fileName, String filePath, String realPath, String userAgent, HttpServletRequest request, HttpServletResponse response) throws Exception;
}
