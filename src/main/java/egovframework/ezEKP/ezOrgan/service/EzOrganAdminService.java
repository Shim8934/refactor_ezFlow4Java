package egovframework.ezEKP.ezOrgan.service;

import java.util.List;





import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.let.user.login.vo.LoginVO;

public interface EzOrganAdminService {
	
	public List<OrganDeptVO> getCompanyList(String lang, int tenantID) throws Exception;
	
	public List<OrganUserVO> getAddJobList(String companyID, String strLang, int tenantID) throws Exception;
	
	public List<OrganUserVO> getUserAddJobList(String cn, String strLang, int tenantID) throws Exception;
	
	public List<OrganUserVO> getPermissionList(String companyID, String type, String searchType, String searchValue, String strLang, int startRow, int endRow, int tenantID) throws Exception;

	public List<OrganUserVO> getRetireList(int pPage, int pPageRow, int tenantID, String offset, String searchStartDate, String searchEndDate, String searchField, String searchValue) throws Exception;
	
	public List<OrganUserVO> getUserCnList(int tenantID) throws Exception;

	public int getUserCount(int tenantID) throws Exception;
	
	public OrganUserVO getUserInfo(String cn, String lang, int tenantID) throws Exception;
	
	public OrganUserVO getRetireEntryInfo(String cn, String lang, int tenantID) throws Exception;
	
	public String getPropertyList(String cn, String proplist, String string, int tenantID) throws Exception;
	
	public String moveEntry(String parentCn, String cn, String type, int tenantID) throws Exception;
	
	public void updateProperty(String cn, String column, String number, String pClass, int tenantID) throws Exception;

	public int companyCheck(String cn, int tenantID) throws Exception;
	
	public int companyChildCheck(String cn, int tenantID) throws Exception;
	
	public int userCheck(String cn, int tenantID) throws Exception;
	
	public int getRetireListCount(int pPage, int pPageRow, int tenantID, String searchStartDate, String searchEndDate, String searchKeycode, String searchKeyword) throws Exception;

	public int getPermissionListCount(String companyID, String type, String searchType, String searchValue, String strLang, int tenantID) throws Exception;

	public void insertDBData_company(String cn, String displayName, String displayName2, String mailAddr, String parentCn, String ldapPath,
					String extensionAttribute15, String skipInitData, int tenantID, LoginVO userInfo) throws Exception;
	
	public void updateDBData_company(String cn, String displayName, String displayName2, String mailAddr, int tenantID) throws Exception;	
	
	public void insertDBData_dept(OrganDeptVO vo) throws Exception;
	
	public void updateDBData_dept(OrganDeptVO vo) throws Exception;

	public void deleteDBData(String cn, String pClass, int tenantID) throws Exception;
	
	public void moveDBData(String parentCn, String cn, String type, int tenantID) throws Exception;

	public void setPassword(String cn, String password, int tenantID) throws Exception;
	
	public void setPasswordExceptAD(String cn, String password, int tenantID) throws Exception;

	public void setPasswordWithEmailSystem(String cn, String domain, String password, int tenantID) throws Exception;
	
	public void retireEntry(String cn, String domain, String adminPassword, int tenantID, String offset) throws Exception;

	public void updateDBData_user(OrganUserVO vo) throws Exception;

	public void updateDBData_userPermission(OrganUserVO vo) throws Exception;
	
	public void insertDBData_user(OrganUserVO vo, String oriPass) throws Exception;

	public void addJob(String userID, String titleInfo, int tenantID) throws Exception;
	
    public void deleteJob(String userID, String titleInfo, int tenantID) throws Exception;	

	public void restoreRetireEntry(String cn, String deptID, int tenantID, String offset) throws Exception;

	public int userCountCheck(String cn, int tenantID) throws Exception;
	
	public void syncWithBizmekaTalkAccounts(int tenantID) throws Exception;
	
	public List<OrganUserVO> getUserList(int tenantID, int startPage, int maxItemPerPage, String keycode,String keyword,String companyId) throws Exception;
	
	public int getUserCount(int tenantID,String keycode,String keyword,String companyId) throws Exception;
	
	public String mailAddDistributionList(String domain, String job, String job2, String companyId, int tenantID, String cn) throws Exception;
	
	public String mailUpdateDistributionList(String domain, String job, String job2, String companyId, int tenantID, String cn) throws Exception;
	
	public String getDistributionUserName (int tenantID, String groupName) throws Exception;

	public String mailDelDistributionList(int tenantID, String cn) throws Exception;
	
	public String deleteTargetAddressUser (int tenantID, String groupName, String memberID, String companyID) throws Exception;
	
	public void updateProperty(String cn, String column, String number, String pClass, int tenantID, String mCondition) throws Exception;
}
