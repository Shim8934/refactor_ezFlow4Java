package egovframework.ezEKP.ezAttitude.service;

import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONObject;

import egovframework.ezEKP.ezAttitude.vo.AdminAttitudeVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeAnnualVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeApplicationVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeAuthorVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeConfigVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeDeptVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeFormVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeStatisVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeTypeVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeUserConfigVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeVO;
import egovframework.ezEKP.ezAttitude.vo.DeptViewVO;
import egovframework.ezEKP.ezAttitude.vo.HolidayVO;
import egovframework.ezEKP.ezAttitude.vo.ModApplHistoryVO;
import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.let.user.login.vo.LoginVO;

public interface EzAttitudeService {
	public AttitudeVO getAttitudeInfo(String attitudeId, String offset, String lang, String companyId, int tenantId) throws Exception;
	
	public void insertAttitude(String writerId, String deptId, String startDate, String endDate, String region,
			String mobile, String bizSub, String content, String ip, String typeId, String dateType, String offset, String companyId, int tenantId, String mode, String adminId, String attendType, String latitude, String longitude) throws Exception;
	
	public void insertAdminAttHistory(String writerId, String deptId, String startDate, String endDate, String region,
			String mobile, String bizSub, String content, String ip, String typeId, String dateType, String offset, String companyId, int tenantId, String adminId) throws Exception;
	
	public List<AttitudeVO> getAttitudeList(String pidList, String deptIdList, String yrmh, String typeId, String startDate, String endDate, String offset, String deptFlag, String lang, String companyId, int tenantId) throws Exception;
	
	public List<AttitudeStatisVO> getAttitudeStatisticsList(String pidList, String deptIdList, String offset, String startDate, String endDate, int tenantId, String deptFlag) throws Exception;
	
	public List<AttitudeTypeVO> getAttitudeTypeList(String companyId, String isuse, String isAdmin, String statistics, String typeIdArr, int tenantId, String primary, String type) throws Exception;
	
	public AttitudeFormVO getFormBody(String typeId, String companyId, int tenantId, String lang) throws Exception;
	
	public void updateAttitude(String attitudeId, String startDate, String endDate, String region,
			String mobile, String bizSub, String content, String offset, String ip, String typeId, String dateType, String mode, AttitudeVO attVO, String adminId, MCommonVO info, MCommonVO userInfo, int tenantId, String companyId, String latitude, String longitude) throws Exception;
	
	public void deleteAttitude(String attitudeId, int tenantId, String mode, AttitudeVO attitudeVO, String offset, MCommonVO info, MCommonVO userInfo) throws Exception;
	
	public AttitudeConfigVO getAttitudeConfig(int tenantId, String companyId) throws Exception;
	
	public void updateAttitudeConfig(String workStartTime, String workEndTime, String closedDay, String attitudeModAppl, String closedDateAttitude, String confSetDate, String companyId, int tenantId) throws Exception;
	
	public void updateAttitudeTypeConfig(String typeConfigList, String companyId, int tenantId) throws Exception;
	
	public boolean insertAttitudeType(String typeName, String typeName2, int tenantId, String companyId, String primary) throws Exception;
	
	public AttitudeTypeVO getAttitudeTypeInfo(int tenantId, String companyId, String typeId) throws Exception;
	
	public void updateAttitudeType(String typeId, String typeName, String typeName2, int tenantId, String companyId) throws Exception;
	
	public List<AttitudeUserConfigVO> getAttitudeUserConfigList(int tenantId, String companyId, String searchUserName, String searchDeptName, String searchTitle, String searchStartTime, String searchEndTime, String searchGubun, String pageNum, String listSize, String orderCell, String orderOption, String offsetMin, String primary) throws Exception;
	
	public AttitudeUserConfigVO getAttitudeUserConfigInfo(String selectedUserIdList, String offsetMin, String companyId, int tenantId) throws Exception;
	
//	public void updateAttitudeUserConfig(int tenantId, String userId, String workStartTime, String workEndTime) throws Exception;
	
//	public void insertAttitudeUserConfig(int tenantId, String companyId, String userId, String workStartTime, String workEndTime) throws Exception;
	
	public void editAttitudeUserConfig(String selectUserId, String workStartTime, String workEndTime, String gubun, String offSet, String companyId, int tenantId) throws Exception;

	public void editAttitudeDeptConfig(String selectDeptIds, String workStartTime, String workEndTime, String gubun, String offSet, String companyId, int tenantId) throws Exception;
	
	public List<AttitudeDeptVO> getCompanyList(String lang, int tenantId, String userId) throws Exception;
	
	public String getAttitudeUserConfigCount(int tenantId, String companyId, String searchUserName, String searchDeptName, String searchTitle, String searchStartTime, String searchEndTime, String searchGubun, String offsetMin) throws Exception;
	
	public List<AttitudeApplicationVO> getUsersModiyAtt(String companyId, int tenantId, String userId, String startDate, String endDate, String apprUserName, String writerName, String writerDeptName, String lang, String offSet, String startPoint, String endPoint, String type, String order, String adminFlag, String checkAdmin, String deptId, List<String> deptIdList) throws Exception;

	public String getAttitudeTypeMaxTypeId(String companyId, int tenantId) throws Exception;

	public List<AttitudeFormVO> getAttitudeFormList(int tenantId) throws Exception;

	public int getUsersModiyAttCount(String companyId, int tenantId, String userId, String startDate, String endDate, String apprUserName, String writerName ,String writerDeptName, String lang, String offSet, String type, String deptId, List<String> deptIdList, String admin, String checkAdmin) throws Exception;
	
	public List<HolidayVO> getHolidayList(String isRest, String companyId, int tenantId) throws Exception;

	public int delUsersModifyAtt(String companyId, int tenantId, String[] ids) throws Exception;

	public List<DeptViewVO> getDeptViewList(String userId, String companyId, int tenantId, String primary) throws Exception;

	public List<AdminAttitudeVO> getAttitudeList2(String searchUserName, String searchDeptName, String searchTitle, String searchStartDate, String searchEndDate, String searchAttitudeType, String orderCell, String orderOption, String offset, String pageNum, String listSize, String companyId, int tenantId, String searchDeptId, List<String> deptIdList, String primary) throws Exception;
	
	public AttitudeApplicationVO attModAppDetail(String attModId, String offset, String applCnt, String lang, String companyId, int tenantId) throws Exception;
	
	public List<AttitudeApplicationVO> attModGetHistory(String attModId, String userId, String offset, String lang, String companyId, int tenantId) throws Exception;
			
	public int attModAppModify(String companyId, int tenantId, String userId, String attModId, String offset, String content, String changeDate) throws Exception;

	public String getAttitudeCount2(String searchUserName, String searchDeptName, String searchTitle, String searchStartDate, String searchEndDate, String searchAttitudeType, String offset, String companyId, int tenantId, String searchDeptId, List<String> deptIdList) throws Exception;
	
	public JSONObject getAttitudeAbsentedList(String searchUserName, String searchDeptName, String searchTitle, String searchStartDate, String searchEndDate, String deptId, String pageNum, String listSize, String orderCell, String orderOption, String duplicated, String userLang, String offset, String companyId, int tenantId, List<String> deptIdList, String primary) throws Exception;
	
	public List<Map<String, Object>> getTenantCompanyId() throws Exception;
	
//	public void absentedListSendMail(List<AdminAttitudeVO> duplicatedList, List<AdminAttitudeVO> distinctedList, String loginCookie, String startDate, String endDate, String fromName, String fromEmail) throws Exception;
	
	public String attSaveAppModify(String attitudeId, String companyId, int tenantId, String userId, String writerName, String writerName2, String writerTitle , String writerTitle2, 
			String writerDeptId, String writerDeptName, String writerDeptName2 ,String changeDate, String delFlag, String content,String offset, String originDate) throws Exception;
	
	public void changeUsersModifyAtt(String companyId, int tenantId, String ids, String changeStatus, String userId, String userName, String userName2, String offSet) throws Exception;

	public List<AttitudeAuthorVO> getAttitudeAuthList(int tenantId,	String companyId, String primary) throws Exception;

	public void deleteAttitudeAuth(String selectUserId, int tenantId, String companyId) throws Exception;

	public void saveAttitudeAuthDept(int tenantId, String companyId, String selectedUser, String deptIds, String authTypes) throws Exception;

	public List<AttitudeAuthorVO> getAttitudeAuthDeptList(int tenantId, String companyId, String userId, String isAllDept, String primary) throws Exception;
	
	public List<AttitudeAuthorVO> getAttitudeAuthDeptList_hyo(int tenantId, String companyId, String userId, String rollInfo, String userAuthType, String listAuthType, String comFlag, String primary) throws Exception;
	
	public List<AttitudeStatisVO> getAttitudeUserStatistics(String userId, String deptId, String offset, String year,String typeId, int tenantId) throws Exception;

	public List<AttitudeAuthorVO> getCompanyDeptList(String userId, String companyId, int tenantId) throws Exception;

	public String deleteAttitudeType(String typeId, int tenantId, String companyId) throws Exception;
	
	public List<ModApplHistoryVO> getAttitudeHistoryList(String searchUserName, String searchDeptName, String searchTitle, String searchStartDate, String searchEndDate, String orderCell, String orderOption, String offset, String pageNum, String listSize, String companyId, int tenantId, String deptId, List<String> deptIdList, String primary) throws Exception;
		
	public String getAttitudeHistoryCount(String searchUserName, String searchDeptName, String searchTitle, String searchStartDate,	String searchEndDate, String offset, String companyId, int tenantId, String deptId, List<String> deptIdList) throws Exception;
	
	/* 2024-07-25 홍승비 - 미사용 메서드 주석처리 */
	// public String getSearchList(String pSearchList, String pCellList, String pPropList, String pClass, int pLimit, String primary, int tenantID) throws Exception;
	
	public String getSearchListPagination(String pSearchList, String pCellList, String pPropList, String pClass, int pLimit, String pLangCode, String page, int tenantID, List<String> deptIdList) throws Exception;
	
	public String getIsAttitude(String typeId, String writerId, String startDate, String offset, String companyId, int tenantId, String isOutCheck) throws Exception;

	public List<AttitudeAuthorVO> getDeptUserList(int tenantId, String key, String value, String companyId, String lang) throws Exception;

	public String getAttitudeAnnualListCount(String searchUserName,	String searchDeptName, String searchTitle, String offsetMin, String companyId, int tenantId, String primary) throws Exception;

	public List<AttitudeAnnualVO> getAttitudeAnnualList(String searchUserName,String searchDeptName, String searchTitle, String orderCell, String orderOption, String offsetMin, String pageNum, String listSize, String companyId, int tenantId, String primary, String startDate, String endDate) throws Exception;
	
//	public void changeAllAnnual(Map<String, Object> map, int tenantId, String companyId, String primary) throws Exception;

	public List<AdminAttitudeVO> getUserAnnual(String userId, String primary, String offset, String startDate, String endDate, String orderCell, String orderOption, String secondYear, String companyId, int tenantId) throws Exception;

	public void changeAnnual(Map<String, Object> map) throws Exception;

	public void excelChangeAnnual(Map<String, Object> map) throws Exception;
	
	public String annualExcelUpload(List<Map<String, Object>> excelList, String changeUserId, String companyId, int tenantId, String changeReason, String flagCheck, Locale locale) throws Exception;
	
	public AttitudeAnnualVO getAnnualCnt(Map<String, Object> map) throws Exception;
	
	public List<Map<String, Object>> getAnnualHistoryList(Map<String, Object> map) throws Exception;

	void changeAllAnnual(Map<String, Object> map) throws Exception;

	public Map<String, Object> getMonthlyAnnualList(String userId, String offset, String startDate, String endDate, int tenantId) throws Exception;
	
	public String saveCancelAnnual(String attitudeId, String companyId, int tenantId, String userId, String writerName, String writerName2, String writerTitle , String writerTitle2, 
			String writerDeptId, String writerDeptName, String writerDeptName2, String delFlag, String content,String offset) throws Exception;
	
	public List<Map<String, Object>> getJoinDateUserList(String yesterday, String companyId, int tenantId) throws Exception;
	
	public void updateAnnualHoliday(Map<String, Object> map) throws Exception;
	
	public void updateExceedAnnualHoliday(Map<String, Object> map) throws Exception;
	
	public void updateMonthlyHoliday(Map<String, Object> map) throws Exception;
	
	public void updateFiscalYearAnnualHoliday(Map<String, Object> map) throws Exception;
	
	public void extinctionMonthlyHoliday(Map<String, Object> map) throws Exception;

	public int deleteCancelAnnual(String companyId, int tenantId, String attitudeId) throws Exception;

	public String sendMailToReference(AttitudeVO vo, String attitudeId, String idList, HttpServletRequest request, String loginCookie, LoginVO userInfo, String orgCompanyID, int tenantID) throws Exception;

	public int getUsersCancelAnnCount(String companyId, int tenantId, String userId, String startDate, String endDate, String apprUserName, String writerName, String writerDeptName, String lang, String offset, String type, String deptId, List<String> deptIdList, String adminFlag, String checkAdmin) throws Exception;

	public List<AttitudeApplicationVO> getUsersCancelAnn(String companyId, int tenantId, String userId, String startDate, String endDate, String apprUserName, String writerName, String writerDeptName,	String lang, String offset, String startPoint, String endPoint, String type, String order, String adminFlag, String checkAdmin, String deptId, List<String> deptIdList) throws Exception;

	public AttitudeApplicationVO annCanAppDetail(String attModId, String offset, String applCnt, String lang, String companyId, int tenantId) throws Exception;

	public void changeUsersCancelAnn(String companyId, int tenantId, String ids, String changeStatus, String userId, String userName, String userName2, String offSet) throws Exception;

	public List<AttitudeApplicationVO> getAnnCanHistory(String attModId, String userId, String offset, String lang, String companyId, int tenantId) throws Exception;

	public void saveJoinDate(Map<String, Object> map) throws Exception;
	
	public int approvalGConn(String userId, String deptId, String content, String mobile, String attitudeTypeList, String startDateList, String endDateList, String startTimeList, String endTimeList,String docId, String offset, String companyId, int tenantId) throws Exception;
	
	public int updateApprovalGConnInfo(String aprStatus, String userId, String docId,	String companyId, int tenantId) throws Exception;

	public int deleteApprovalGConnInfo(String userId, String type, String docId, String companyId, int tenantId) throws Exception;
	
	public Map<String, Object> getAttitudeAnnualConfig(int tenantId, String companyId) throws Exception;

	public void updateAnnualConfig(Map<String, Object> map) throws Exception;

	public Map<String, Object> getJoinDate(int tenantId, String companyId, String userId) throws Exception;

	public List<Map<String, Object>> getAttitudeAprInfo(String attitudeId, String lang, int tenantId, String companyId) throws Exception;

	public List<String> getDisabledDays(String primary, String offset, String year, String month, String startDate, String endDate, String userId, String companyId, int tenantId) throws Exception;
	
	public List<String> getHoliDays(String primary, String offset, String year, String month, String startDate, String endDate, String userId, String companyId, int tenantId) throws Exception;

	public void autoSetDailyWork() throws Exception;
}
