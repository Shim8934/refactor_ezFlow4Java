package egovframework.ezEKP.ezAttitude.service;

import java.util.List;
import java.util.Map;

import org.json.simple.JSONObject;

import egovframework.ezEKP.ezAttitude.vo.AdminAttitudeVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeApplicationVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeAuthorVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeConfigVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeDeptVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeFormVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeStatisVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeTypeVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeUserConfigVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeVO;
import egovframework.ezEKP.ezAttitude.vo.HolidayVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeAuthorVO;
import egovframework.ezEKP.ezAttitude.vo.DeptViewVO;
import egovframework.ezEKP.ezAttitude.vo.ModApplHistoryVO;

public interface EzAttitudeService {
	public AttitudeVO getAttitudeInfo(String attitudeId, String offset, int tenantId) throws Exception;
	
	public void insertAttitude(String writerId, String deptId, String startDate, String endDate, String region,
			String mobile, String bizSub, String content, String ip, String typeId, String dateType, String offset, String companyId, int tenantId, String mode, String adminId) throws Exception;
	
	public void insertAdminAttHistory(String writerId, String deptId, String startDate, String endDate, String region,
			String mobile, String bizSub, String content, String ip, String typeId, String dateType, String offset, String companyId, int tenantId, String adminId) throws Exception;
	
	public List<AttitudeVO> getAttitudeList(String pidList, String deptIdList, String yrmh, String typeId, String startDate, String endDate, String offset, int tenantId, String deptFlag) throws Exception;
	
	public List<AttitudeStatisVO> getAttitudeStatisticsList(String pidList, String deptIdList, String offset, String startDate, String endDate, int tenantId, String deptFlag) throws Exception;
	
	public List<AttitudeTypeVO> getAttitudeTypeList(String companyId, String isuse, String isAdmin, String statistics, int tenantId) throws Exception;
	
	public AttitudeFormVO getFormBody(String typeId, String companyId, int tenantId) throws Exception;
	
	public void updateAttitude(String attitudeId, String startDate, String endDate, String region,
			String mobile, String bizSub, String content, String offset, String ip, String typeId, String dateType, String mode, AttitudeVO attVO, String adminId, int tenantId, String companyId) throws Exception;
	
	public void deleteAttitude(String attitudeId, int tenantId, String mode, AttitudeVO attitudeVO, String userId) throws Exception;
	
	//메일로 발송하는 부분.... 전자결재 부분보고 알아보자 AND 상세부분
	
	public void insertAttitudeApplication(String attitudeId, String writerId, String writerName, String writerName2, String writerTitle,
			String writerTitle2, String writerDeptId, String writerDeptName, String writerDeptName2, String changeDate, String changeTime,
			String content, String companyId, int tenantId) throws Exception;
	
	public String getAttitudeApplStatus(String attitudeId, int tenantId) throws Exception;
	
	public void updateAttitudeApplication(String attitudeId, String changeTime, String content, String companyId, int tenantId) throws Exception;
	
	public void updateAttitudeApplicationApproval(String attitudeId, String apprUserId, String apprUserName, String apprUserName2, String apprStatus, 
			int tenantId) throws Exception;
	
	public List<Map<String, String>> getDeptAttitudeList(String pidList, int tenantId) throws Exception;
	
	public AttitudeApplicationVO getAttitudeApplicationInfo(int tenantId, String companyId, String attitudeId) throws Exception;
	
	public void deleteAttitudeApplication(String attitudeId, int tenantId) throws Exception;
	
	public List<AttitudeApplicationVO> getUserAttitudeApplicationList(String userId, int tenantId, String writeName, String apprUserName, String startDate, String endDate, String statusType) throws Exception;

	public List<AttitudeApplicationVO> getAttitudeApplicationList(int tenantId, String writeName, String apprUserName, String deptName, String startDate, String endDate, String statusType) throws Exception;
	
	public AttitudeConfigVO getAttitudeConfig(int tenantId, String companyId) throws Exception;
	
	public void updateAttitudeConfig(JSONObject jsonParam) throws Exception;
	
	public void updateAttitudeTypeConfig(String typeConfigList, String companyId, int tenantId) throws Exception;
	
	public boolean insertAttitudeType(String typeName, String typeName2, int tenantId, String companyId) throws Exception;
	
	public AttitudeTypeVO getAttitudeTypeInfo(int tenantId, String companyId, String typeId) throws Exception;
	
	public void updateAttitudeType(String typeId, String typeName, String typeName2, int tenantId, String companyId) throws Exception;
	
	public List<AttitudeUserConfigVO> getAttitudeUserConfigList(int tenantId, String companyId, String searchUserName, String searchDeptName, String searchTitle, String searchStartTime, String searchEndTime, String searchGubun, String pageNum, String listSize, String orderCell, String orderOption, String offsetMin) throws Exception;
	
	public AttitudeUserConfigVO getAttitudeUserConfigInfo(String selectedUserIdList, String offsetMin, String companyId, int tenantId) throws Exception;
	
//	public void updateAttitudeUserConfig(int tenantId, String userId, String workStartTime, String workEndTime) throws Exception;
	
//	public void insertAttitudeUserConfig(int tenantId, String companyId, String userId, String workStartTime, String workEndTime) throws Exception;
	
	public void editAttitudeUserConfig(String selectUserId, String workStartTime, String workEndTime, String gubun, String offSet, String companyId, int tenantId) throws Exception;
	
	public List<AttitudeDeptVO> getCompanyList(String lang, int tenantId, String userId) throws Exception;
	
	public String getAttitudeUserConfigCount(int tenantId, String companyId, String searchUserName, String searchDeptName, String searchTitle, String searchStartTime, String searchEndTime, String searchGubun, String offsetMin) throws Exception;
	
	public List<AttitudeApplicationVO> getUsersModiyAtt(String companyId, int tenantId, String userId, String startDate, String endDate, String apprUserName, String writerName, String writerDeptName, String sysLang, String offSet, String startPoint, String endPoint, String type, String order, String adminFlag, String checkAdmin, String[] deptIdList) throws Exception;

	public String getAttitudeTypeMaxTypeId(String companyId, int tenantId) throws Exception;

	public List<AttitudeFormVO> getAttitudeFormList(int tenantId) throws Exception;

	public int getUsersModiyAttCount(String companyId, int tenantId, String userId, String startDate, String endDate, String apprUserName, String writerName ,String writerDeptName,String sysLang, String offSet, String type, String[] deptIdList, String admin, String checkAdmin) throws Exception;
	
	public List<HolidayVO> getHolidayList(String isRest, String companyId, int tenantId) throws Exception;

	public List<AttitudeAuthorVO> getDeptUserList(String tenantId, String key,	String value) throws Exception;

	public int delUsersModifyAtt(String companyId, int tenantId, String[] ids) throws Exception;

	public List<DeptViewVO> getDeptViewList(String userId, String companyId, String tenantId) throws Exception;

	public List<AdminAttitudeVO> getAttitudeList2(String searchUserName, String searchDeptName, String searchTitle, String searchStartDate, String searchEndDate, String searchAttitudeType, String orderCell, String orderOption, String offset, String pageNum, String listSize, String companyId, int tenantId, String searchDeptId) throws Exception;
	
	public AttitudeApplicationVO attModAppDetail(String companyId, int tenantId, String userId, String attModId, String offset, String applCnt) throws Exception;
	
	public List<AttitudeApplicationVO> attModGetHistory(String companyId, int tenantId, String userId, String attModId, String offset) throws Exception;
			
	public int attModAppModify(String companyId, int tenantId, String userId, String attModId, String offset, String content, String changeDate) throws Exception;

	public String getAttitudeCount2(String searchUserName, String searchDeptName, String searchTitle, String searchStartDate, String searchEndDate, String searchAttitudeType, String offset, String companyId, int tenantId, String searchDeptId) throws Exception;
	
	public JSONObject getAttitudeAbsentedList(String searchUserName, String searchDeptName, String searchTitle, String searchStartDate, String searchEndDate, String deptId, String pageNum, String listSize, String orderCell, String orderOption, String duplicated, String userLang, String offset, String companyId, int tenantId) throws Exception;
	
	public void absentedListSendMail(List<AdminAttitudeVO> duplicatedList, List<AdminAttitudeVO> distinctedList, String loginCookie, String startDate, String endDate, String fromName, String fromEmail) throws Exception;
	
	public String attSaveAppModify(String attitudeId, String companyId, int tenantId, String userId, String writerName, String writerName2, String writerTitle , String writerTitle2, 
			String writerDeptId, String writerDeptName, String writerDeptName2 ,String changeDate, String delFlag, String content,String offset, String originDate) throws Exception;
	
	public void changeUsersModifyAtt(String companyId, int tenantId, String ids, String changeStatus, String userId, String userName, String userName2, String offSet) throws Exception;

	public List<AttitudeAuthorVO> getAttitudeAuthList(int tenantId,	String companyId) throws Exception;

	public void deleteAttitudeAuth(String selectUserId, int tenantId, String companyId) throws Exception;

	public void saveAttitudeAuthDept(int tenantId, String companyId, String selectedUser, String deptIds, String authTypes) throws Exception;

	public List<AttitudeAuthorVO> getAttitudeAuthDeptList(int tenantId, String companyId, String userId, String isAllDept) throws Exception;
	
	public List<AttitudeStatisVO> getAttitudeUserStatistics(String userId, String deptId, String offset, String year,String typeId, int tenantId) throws Exception;

	public List<AttitudeAuthorVO> getCompanyDeptList(String userId, String companyId, int tenantId) throws Exception;

	public int checkUseAttitudeType(String typeId, int tenantId, String companyId) throws Exception;

	public void deleteAttitudeType(String typeId, int tenantId, String companyId) throws Exception;
	
	public List<ModApplHistoryVO> getAttitudeHistoryList(String searchUserName, String searchDeptName, String searchTitle, String searchStartDate, String searchEndDate, String searchAttitudeType, String orderCell, String orderOption, String offset, String pageNum, String listSize, String companyId, int tenantId, String deptId) throws Exception;
		
	public String getAttitudeHistoryCount(String searchUserName, String searchDeptName, String searchTitle, String searchStartDate,	String searchEndDate, String searchAttitudeType,String offset, String companyId, int tenantId, String deptId) throws Exception;
	
	public String getSearchList(String pSearchList, String pCellList, String pPropList, String pClass, int pLimit, String primary, int tenantID) throws Exception;
	
	public String getSearchListPagination(String pSearchList, String pCellList, String pPropList, String pClass, int pLimit, String pLangCode, String page, int tenantID) throws Exception;
	
	public String getIsAttitude(String typeId, String writerId, String startDate, String offset, String companyId, int tenantId) throws Exception;
}
