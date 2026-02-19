package egovframework.ezEKP.ezOrgan.service;

import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Optional;

import javax.servlet.http.HttpServletResponse;

import egovframework.ezEKP.ezOrgan.vo.OrganAuth;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.ezEKP.ezOrgan.vo.OrganGroupVO;
import egovframework.ezEKP.ezOrgan.vo.OrganJobVO;
import egovframework.ezEKP.ezOrgan.vo.OrganLoginStopUserVO;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.ezEKP.ezSystem.vo.PermissionInfoVO;
import egovframework.ezEKP.ezSystem.vo.UserChangeInfoVO;
import egovframework.let.user.login.vo.LoginVO;

public interface EzOrganAdminService {
	
	public List<OrganDeptVO> getCompanyList(String lang, int tenantID) throws Exception;
	
	public List<OrganUserVO> getAddJobList(String companyID, String strLang, String searchType, String searchValue, int tenantID, int totalCount, int pageSize, int startRow, int endRow) throws Exception;
	
	public List<OrganUserVO> getUserAddJobList(String cn, String strLang, int tenantID) throws Exception;

	int getAddJobCountInOneDept(String cn, String deptId, int tenantId) throws Exception;
	
	// 2023-07-31 전인하 - 관리자 > 조직도 > 권한관리 - 권한 조회 메소드 수정
	public List<OrganUserVO> getPermissionList(String companyID, String type, String searchType, String searchValue, String strLang, int startRow, int endRow, int tenantID, String permissionBasisDeptYN) throws Exception;

	public List<OrganUserVO> getRetireList(int pPage, int pPageRow, int tenantID, String offset, String searchStartDate, String searchEndDate, String searchField, String searchValue, String searchCompanyID) throws Exception;
	
	public List<OrganUserVO> getUserCnList(int tenantID) throws Exception;

	public int getUserCount(int tenantID) throws Exception;
	
	public void deleteDestUserProfileImage(String cn, int tenantID, String realPath) throws Exception;

	public OrganUserVO getUserInfo(String cn, String lang, int tenantID) throws Exception;
	
	public OrganUserVO getRetireEntryInfo(String cn, String lang, int tenantID) throws Exception;
	
	public String getPropertyList(String cn, String proplist, String string, int tenantID) throws Exception;
	
	public String moveEntry(String parentCn, String cn, String type, String offset, int tenantID) throws Exception;
	
	public void updateProperty(String cn, String column, String number, String pClass, int tenantID) throws Exception;

	public void updateJobTitleOrder(int jobId, int sortOrder, int tenantID) throws Exception;
	
	public int companyCheck(String cn, int tenantID) throws Exception;
	
	public int companyChildCheck(String cn, int tenantID) throws Exception;
	
	public int userCheck(String cn, int tenantID) throws Exception;

	PreResult checkDuplicateId(String cn, String employeeNumber, int tenantId) throws Exception;

	PreResult checkDuplicateLoginId(String cn, String employeeNumber, int tenantId) throws Exception;
	
	public int getRetireListCount(int pPage, int pPageRow, int tenantID, String searchStartDate, String searchEndDate, String searchKeycode, String searchKeyword, String searchCompanyID) throws Exception;

	// 2023-07-31 전인하 - 관리자 > 조직도 > 권한관리 - 권한 카운트 조회 메소드 수정
	public int getPermissionListCount(String companyID, String type, String searchType, String searchValue, String strLang, int tenantID, String permissionBasisDeptYN) throws Exception;

	public void insertDBData_company(String cn, String displayName, String displayName2, String mailAddr, String parentCn, String ldapPath,
					String extensionAttribute15, String skipInitData, String manualFlag, int tenantID, LoginVO userInfo) throws Exception;
	
	public void updateDBData_company(String cn, String displayName, String displayName2, String mailAddr, int tenantID) throws Exception;	
	
	public void insertDBData_dept(OrganDeptVO vo) throws Exception;
	
	public void updateDBData_dept(OrganDeptVO vo) throws Exception;

	public void deleteDBData(String cn, String pClass, int tenantID) throws Exception;
	
	public void moveDBData(String parentCn, String cn, String type, String offset, int tenantID) throws Exception;

	public void setPassword(String cn, String password, int tenantID) throws Exception;
	
	public void setPasswordExceptAD(String cn, String password, int tenantID) throws Exception;

	public void setPasswordWithEmailSystem(String cn, String domain, String password, int tenantID) throws Exception;

	public String changePasswordWithEmailSystem(String cn, int tenantId, String decryptedOldPassword, String decryptedNewPassword) throws Exception;
	
	public void retireEntry(String cn, String domain, int tenantID, String offset) throws Exception;

	public List<String> getRetireUserDeptList(String cn, int tenantID) throws Exception;

	public void updateDBData_user(OrganUserVO vo) throws Exception;

	public void updateDBData_userPermission(OrganUserVO vo) throws Exception;
	
	public void insertDBData_user(OrganUserVO vo, String oriPass) throws Exception;

	public void addJob(String userID, String titleInfo, String jobID, String roleInfo, int tenantID) throws Exception;
	
    public void deleteJob(String userID, String titleInfo, int tenantID) throws Exception;	

    public void deleteJob(String userID, String titleInfo, int tenantID, String delJobId, String delRoeId, boolean isAddJobMoreInOneDept) throws Exception;

	public void restoreRetireEntry(String cn, String deptID, int tenantID, String offset) throws Exception;

	public int userCountCheck(String cn, int tenantID) throws Exception;
	
	public void syncWithBizmekaTalkAccounts(int tenantID) throws Exception;
	
	public List<OrganUserVO> getUserList(int tenantID, int startPage, int maxItemPerPage, String keycode,String keyword,
			String companyId, String sortColumn, String sortType, boolean[] searchFor) throws Exception;
	
	public int getUserCount(int tenantID, String keycode, String keyword, boolean[] searchFor, String companyId) throws Exception;
	
	public String createExcelTotalUsers(String realPath, String dirPath, List<OrganUserVO> exportUserlist, String primary, Locale locale) throws Exception;
	
	public void updateProperty(String cn, String column, String number, String pClass, int tenantID, String mCondition) throws Exception;
	
	public String setTitle(String type, String cn, String displayName, String displayName2, String useFlag, int sort, String companyID, int tenantID) throws Exception;

	public OrganJobVO getTitleByJobID(String jobID, String lang, int tenantID) throws Exception;
	
	public String getTitleList(String type, String companyID, int tenantID) throws Exception;
	
	public String getTitleInfo(String type, String jobID, String companyID, int tenantID) throws Exception;

	public String updateTitle(String type, String jobID, String displayName, String displayName2, String useFlag, int sort, String companyID, int tenantID) throws Exception;
	
	public String deleteTitle(String type, String jobIDList, String companyID, int tenantID) throws Exception;
	
	public String getTitleUserList(String type, String jobID, String pageSize, String pageNum, String searchType, String searchValue, String primary, String companyID, int tenantID) throws Exception;
	
	public int getTitleListCnt(String type, String companyID, int tenantID) throws Exception;
	
	public int getTitleUserListCnt(String type, String jobID, String companyID, int tenantID) throws Exception;

	public int getTitleCnt(String type, String jobID, String mode, String displayName, String displayName2, String companyID, int tenantID) throws Exception;
	
	public String getJobOptionInfo(String type, String companyID, int tenantID) throws Exception;

	public void updateDBData_user_new(List<OrganUserVO> vo) throws Exception;

	public int getAddJobCount(String companyID, String searchType, String searchValue, int tenantId, String strLang) throws Exception;

	public List<OrganUserVO> getAllUserCnList(int tenantID) throws Exception;

	public String getCompanyName(String displayName, int tenantID, String lang) throws Exception;
	
	public String insertPermissionGroup(String groupID, String groupName, String createID, String companyID, int tenantID, List<String> groupMemberList) throws Exception;
	
	public String updatePermissionGroup(String groupID, String groupName, String updateID, String companyID, int tenantID, List<String> groupMemberList) throws Exception;
	
	public void deletePermissionGroup(String groupList, String companyID, int tenantID) throws Exception;
	
	public int getPermissionGroupListCount(int tenantID, String searchKeycode, String searchKeyword, String companyID) throws Exception;
	
	public List<OrganGroupVO> getPermissionGroupList(int pPage, int pPageRow, int tenantID, String offset, String searchField, String searchValue, String searchCompanyID) throws Exception;
	
	public List<OrganGroupVO> getPermissionGroupInfo(String groupID, int tenantID, String companyID) throws Exception;
	
	public List<OrganGroupVO> getGroupList(int tenantID, String companyID) throws Exception;

	public List<OrganGroupVO> getGroupListBoard(int tenantID, String companyID, String isAllGroupBoard) throws Exception;
	
	public String getTitleList_group(String type, String companyID, int tenantID, String lang) throws Exception;
	
	public OrganJobVO getTitleInfo_group(String type, String jobID, String companyID, int tenantID) throws Exception;

	public List<OrganUserVO> getExportUserList(String primary, String companyId, int tenantId) throws Exception;
	
	public String createExcelUsers(String realPath, String dirPath, List<OrganUserVO> exportUserlist, String primary, Locale locale) throws Exception;
	
	public void getExcelFile(String fileName, String realPath, String userAgent, HttpServletResponse response, int tenantId) throws Exception;

	public String getTitleListBoard(String type, String companyID, int tenantID, String lang) throws Exception;
	
	public List<OrganLoginStopUserVO> getLoginStopUserList(int tenantID, int startPage, int maxItemPerPage, String keycode, String keyword, String stopFlag, String offset, String companyId) throws Exception;
		
	public int getLoginStopUserListCount(int tenantID, String keycode, String keyword, String stopFlag, String companyId) throws Exception;
	
	public String insertStopUser(String[] cnArr, String companyID, int tenantID) throws Exception;
	
	public String deleteStopUser(String[] cnArr, String companyID, int tenantID) throws Exception;
	
	public int checkStopUser(String userID, int tenantID) throws Exception;

	List<String> getNotUseMobileUserList(int tenantId) throws Exception;
	
	public List<String> getAutoDeleteOfRetireUserList(int tenantId, int days) throws Exception;

	void insertPermissionChHist(List<PermissionInfoVO> vo) throws Exception;
	
	public OrganUserVO getUserDeptInfo(String cn, int tenantID) throws Exception;
	
	public OrganDeptVO getDeptDisplayNm(String cn, int tenantID) throws Exception;

	public String getDeptParentCn(String cn, int tenantID) throws Exception;

	public OrganUserVO getAddJobInfo(String cn, String deptId, String jobId, String roleId, int tenantId) throws Exception;

	public List<OrganUserVO> getExportAddJobList(String primary, String companyId, int tenantId) throws Exception;

	public String createExcelAddJobList(String realPath, String dirPath, List<OrganUserVO> exportAddJobList, String primary, Locale locale) throws Exception;

	public List<OrganUserVO> getExportPermissionsList(String primary, String companyId, int tenantId) throws Exception;

	public String createExcelPermissionsList(String realPath, String pDirPath, List<OrganUserVO> exportPermissionList, String primary, Locale locale, boolean isRollC) throws Exception;
	
	// 2023-08-25 전인하 - 해당 유저가 원직인지 겸직인지 확인 메소드
	String isThisAddJob(String cn, int tenant_id, String DeptId, String jobId) throws Exception;
	
	// 2023-08-24 전인하 - 관리자 > 조직도 > 권한관리 - 겸직/부서별 권한 설정 옵션에 따른 권한 히스토리 삽입 메소드
	void insertPermissionChHistBasisDept(List<PermissionInfoVO> vo) throws Exception;
	
	// 2023-07-31 전인하 - 관리자 > 조직도 > 권한관리 - 겸직/부서별 권한 설정 옵션에 따른 권한 수정 메소드
	public void updatePermissionBasisDept(List<OrganUserVO> vo) throws Exception;

	int userJobCheck(String cn, String deptId, String jobId, String roleId, int tenantID) throws Exception;

	// 2024-01-15 김혜지 - 지정된 부서에 속한 퇴직자 수를 반환한다.
	int retireUserCountCheck(String cn, int tenantID) throws Exception;

	Optional<String> getJobIdForFirstUser(String userId, int tenantId) throws Exception;

	List<OrganDeptVO> getAdminCompanyList(String id, int tenantID, String primary, String deptId, String jobId) throws Exception;
	
	// 2024-05-27 관리자 > 조직도 > 겸직 사용자 상세정보 내용 호출 함수
	public String getEntryAddJobInfo(String cn, String deptId, String jobId, String language, int tenantID, String prop) throws Exception;
	
	public void updateAddJobInfo(String cn, String deptId, String jobId, int tenantID, String orderBy, String userTreeFlag) throws Exception;

	public void updateUserMailAddress(String cn, String mailAddress, int tenantID) throws Exception;
	
	public void resetLoginCnt(String cn, int tenantID) throws Exception;

    public void deleteSecretary(String userID, int tenantID, String companyID) throws Exception;
}
