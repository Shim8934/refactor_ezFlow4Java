package egovframework.ezEKP.ezOrgan.service;

import java.util.List;

import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;

public interface EzOrganAdminService {
	
	public List<OrganDeptVO> getCompanyList(String lang, int tenantID) throws Exception;
	
	public List<OrganUserVO> getAddJobList(String companyID, String strLang, int tenantID) throws Exception;
	
	public List<OrganUserVO> getUserAddJobList(String cn, String strLang, int tenantID) throws Exception;
	
	public List<OrganUserVO> getPermissionList(String companyID, String type, String strLang, int startRow, int endRow, int tenantID) throws Exception;
		
	public List<OrganUserVO> getRetireList(int pPage, int pPageRow, int tenantID) throws Exception;
	
	public List<OrganUserVO> getUserCnList() throws Exception;
	
	public OrganUserVO getUserInfo(String cn, String lang, int tenantID) throws Exception;
	
	public OrganUserVO getRetireEntryInfo(String cn, String lang, int tenantID) throws Exception;
	
	public String getPropertyList(String cn, String proplist, String string, int tenantID) throws Exception;
	
	public String moveEntry(String parentCn, String cn, String type, int tenantID) throws Exception;
	
	public void updateProperty(String cn, String column, String number, String pClass, int tenantID) throws Exception;

	public int companyCheck(String cn) throws Exception;
	
	public int companyChildCheck(String cn, int tenantID) throws Exception;
	
	public int userCheck(String cn, int tenantID) throws Exception;
	
	public int getRetireListCount(int pPage, int pPageRow, int tenantID) throws Exception;
	
	public int getPermissionListCount(String companyID, String type, String strLang, int tenantID) throws Exception;

	public void insertDBData_company(String cn, String displayName, String displayName2, String mailAddr, String parentCn, String ldapPath, int tenantID) throws Exception;
	
	public void insertDBData_dept(OrganDeptVO vo) throws Exception;
	
	public void updateDBData_dept(OrganDeptVO vo) throws Exception;

	public void deleteDBData(String cn, String pClass, int tenantID) throws Exception;
	
	public void moveDBData(String parentCn, String cn, String type, int tenantID) throws Exception;

	public void setPassword(String cn, String password, int tenantID) throws Exception;

	public void retireEntry(String cn, int tenantID) throws Exception;

	public void updateDBData_user(OrganUserVO vo) throws Exception;

	public void insertDBData_user(OrganUserVO vo) throws Exception;

	public void addJob(String userID, String titleInfo, int tenantID) throws Exception;
	
    public void deleteJob(String userID, String titleInfo, int tenantID) throws Exception;	

	public void restoreRetireEntry(String cn, String deptID, int tenantID) throws Exception;

	public int userCountCheck(String cn, int tenantID)throws Exception;

	 
}
