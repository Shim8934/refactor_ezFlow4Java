package egovframework.ezEKP.ezOrgan.service;

import java.util.List;
import java.util.Map;
import java.util.Optional;

import egovframework.ezEKP.ezNewPortal.vo.PortalUserSwitchVO;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.ezEKP.ezOrgan.vo.OrganProxyVO;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.ezEKP.ezOrgan.vo.TeamsOrganVO;
import egovframework.let.user.login.vo.LoginVO;

import javax.servlet.http.HttpServletRequest;

public interface EzOrganService {
	
	public OrganDeptVO getDeptInfo(String userID, String primary, int tenantID) throws Exception;	

	public String getPropertyValue(String userID, String propName, int tenantID) throws Exception;

	public String getSIPUriList(String pCNList, String eMailList) throws Exception;
	
	public String getDeptFullPath(String deptID, int tenantID) throws Exception;
	
	public String getDeptTreeInfo(String userID, String deptID, String topID, String propList, String primary, String displayTrashDept, int tenantID) throws Exception;
	public String getDeptTreeInfo(String userID, String deptID, String topID, String propList, String primary, String displayTrashDept, int tenantID, String adminOrgan) throws Exception;

	public List<OrganDeptVO> getDeptMemberList(String pClass, String deptID, String lang, int tenantID) throws Exception;
	
	public String getDeptMemberList(String deptid, String celllist, String proplist, String listtype, String lang, int tenantID, String noAddJob) throws Exception;
	public String getDeptMemberList(String deptid, String celllist, String proplist, String listtype, String lang, int tenantID, String noAddJob, String adminOrgan) throws Exception;
	
	public String getDeptMemberListPagination(String deptid, String celllist, String proplist, String listtype, String lang, String page, int tenantID) throws Exception;
	public String getDeptMemberListPagination(String deptid, String celllist, String proplist, String listtype, String lang, String page, int tenantID, String adminOrgan) throws Exception;
	
	public String getSearchList(String searchlist, String celllist,	String proplist, String listtype, int i, String lang, int tenantID, String adminOrgan) throws Exception;

	public String getDeptSubTreeInfo(String deptID, String propList, String primary, int tenantID) throws Exception;

	public String getDeptSubTreeInfo(String deptID, String propList, String primary, int tenantID, boolean displayTrashDept, String adminOrgan) throws Exception;
	
	public String convertAddandConvert(String pClass, String pProvValue) throws Exception;
	
	public String getPropertyList(String id, String proplist, String primary, int tenantID) throws Exception;

	public String getUserAddjobInfo(String id, String pDeptID, String primary, int tenantID) throws Exception;

	public String getUserAddjobInfoWithJobId(String id, String pDeptID, String primary, String jobID, int tenantID) throws Exception;
	
	public String getOrganTreeInfo(String strFilter, int intScope) throws Exception;
	
	public String getEncPassword(String dUserID, int tenantID) throws Exception;
	
	public String getSearchListPagination(String searchlist, String celllist, String proplist, String listtype, int i, String lang, String page, int tenantID, String companyId, String adminOrgan) throws Exception;
	
	public String updateProperty(String userID, String propName, String propValue, String pClass, int tenantID) throws Exception;
	
	public String delProxyUserInfo(String userID, int tenantID) throws Exception;
	
	public String setProxyUserInfo(String userID, String proxyUserID, String proxyUserName, String proxyUserDeptID, String startDate, String endDate, int tenantID, String offset) throws Exception;
	
	public String getProxyUserInfo(String userID, int tenantID, String offset) throws Exception;
	
	public String getLastLogin(String userID, int tenantID) throws Exception;
	
	public String getLoginIP(String userID, int tenantID) throws Exception;

	public OrganUserVO getAddJobInfo(String userID, String deptID, String jobID, int tenantID) throws Exception;

	public boolean checkDBColum(String pProvValue) throws Exception;
	
	public boolean checkSearchField(String pFieldName) throws Exception;

	public String getCNByEmail(String email, int tenantID) throws Exception;

	public String getDeptReceipterIDs(String deptID, int tenantID) throws Exception;

	public OrganProxyVO getProxyInfo(String userID, int tenantID, String offset) throws Exception;
	
	public List<String> getAllSubDeptId(String deptID, int tenantID) throws Exception;
	
	public String getDeptPath(String deptID, int tenantID) throws Exception;

	public String getOrganSubTreeInfo(String strFilter, String strBaseDN, int intScope) throws Exception;

	public String getOrgInfo(String strFilter, int intScope) throws Exception;

	public String searchOuterOrgan(String strFilter, int intScope) throws Exception;

	public List<OrganDeptVO> getExtensionAttr4ID(String strReceiveID) throws Exception;
	
	public String getChildrenDeptID(String parentID, String companyID, int tenantID) throws Exception;

	public String getSearchList(String searchlist, String celllist, String proplist, String listtype, int i, String lang, String companyId, int tenantID, String noAddJob, String adminOrgan) throws Exception;

	public boolean checkRetired(String userID, String companyID, int tenantID) throws Exception;
	
	public String isProxyUser(int tenantId, String userId, String nowDateTime) throws Exception;

	public String setListType(String listType, String userID, int tenantID, String companyID) throws Exception;

	public String getListType(String userID, int tenantID, String companyID) throws Exception;

	public String getSearchListOR(String pSearchList, String pCellList, String pPropList, String pClass, int pLimit, String primary, int tenantID, String companyId) throws Exception;

	public int getMemberListCount2(String pDeptID, List<String> companyList, int totalCount2, String containCompany, int tenantId) throws Exception;
	
	public int getMemberListCount2(String pDeptID, List<String> companyList, int totalCount2, String containCompany, int tenantId,  String adminOrgan) throws Exception;
	
	public int getDeptMemberListCount(String deptID, boolean containLow, String primary, int tenantID) throws Exception;
	public int getDeptMemberListCount(String deptID, boolean containLow, String primary, int tenantID, String adminOrgan) throws Exception;
	
	public String getPhysicalDeliveryOfficeName(String userID,  String property, int tenantID) throws Exception;

	String getUserOrgDeptId(String userID, int tenantID, String companyID) throws Exception;

	public String updateAddJobProxy(String id, String proxyInfo, int tenantId, String dept) throws Exception;

	public String getAddJobProxy(String id, String dept, int tenantId) throws Exception;
	
	public String getAddJobProxy(String id, String dept, String title, int tenantId) throws Exception;

	public OrganUserVO getUserInfo(String id, String lang, int tenantId) throws Exception;
	
	/* 2020-10-22 홍승비 - 전달한 필드(칼럼)에 대응하는 값을 TBL_DEPTMASTER 테이블에서 가져오는 메서드 */
	public String getPropertyValueForDept(String fieldName, String deptID, int tenantID) throws Exception;

	public String updateAddJobProxy(String userID, String proxyInfo, int tenantID, String dept, String jobId) throws Exception;

	public String getCompanyJobTreeInfo(String type, String pComID, String pTopID, String pPropList, String primary, int tenantID) throws Exception;
	
	public String getJobMasterTreeInfo(String type, String pComID, String lang, int tenantID) throws Exception;
	
	public String getJobMasterMemberList(String type, String jobID, String celllist, String proplist, String pageSize, String pageNum, String searchType, String searchValue, String primary, String companyID, int tenantID,String adminOrgan) throws Exception;
	
	public List<OrganUserVO> getOrgUserInfo(String userID, int tenantID, String companyID) throws Exception;

	// 2023-07-31 전인하 - 관리자 > 조직도 > 권한관리 - 겸직/사용자 별 권한 설정 옵션에 따른 권한 조회 메소드
    public String getRollInfoBasisDept(String userID, int tenantID, String deptID, String jobID) throws Exception;

	// 2023-08-09 전인하 - 특정 유저의 모든 겸직 권한 호출하는 메소드
	public List<OrganUserVO> getAllRollInfoForUserBasisDept(String userId, int tenantId, String permissionCode) throws Exception;

	// 2023-08-28 전인하 - 전자결재 > 좌측 겸직 변경 드롭다운 > 리스트 생성 위한 겸직정보 조회
	public List<OrganUserVO> getAddJobListForEzApprDropdown(String lang, String userId, int tenantId) throws Exception;

	String changeCookie(String loginCookie, String deptId, String companyId, int tenantId, String jobId) throws Exception;

	Optional<OrganUserVO> getUserInfo(int tenantId, String userId, String companyId, String deptId, String jobId, String lang) throws Exception;

	List<OrganUserVO> getAllUserinfo(String userId, int tenantId) throws Exception;
	
	public TeamsOrganVO organMain(LoginVO userInfo, String device, String companyId, String permission, String deptId, String uselstcompany, int tenantId) throws Exception;

	String getTotalTreeNodeInfo(LoginVO userInfo, String userId, String selectedUserId, String deptId, String topId, String propList, String langCode, String type, String adminFlag) throws Exception;

	public List<Map<String, Object>> getSearchListForTeamsJson(String searchlist, String celllist, String proplist, String listtype, int i, String lang, String companyId, int tenantID, String noAddJob, String adminOrgan) throws Exception;

	public String getCnByUpn (String upn, int tenantID) throws Exception;

    public String GetUpnFromAuthToken(String authToken, int tenantId) throws Exception;
}
