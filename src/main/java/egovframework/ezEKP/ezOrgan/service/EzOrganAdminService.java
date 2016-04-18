package egovframework.ezEKP.ezOrgan.service;

import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;

public interface EzOrganAdminService {
	
	public OrganUserVO getUserInfo(String cn, String lang) throws Exception;
	
	public String getPropertyList(String cn, String proplist, String string) throws Exception;
	
	public String moveEntry(String parentCn, String cn, String type) throws Exception;
	
	public void updateProperty(String cn, String column, String number, String pClass) throws Exception;

	public int companyCheck(String cn) throws Exception;
	
	public int companyChildCheck(String cn) throws Exception;

	public void insertDBData_company(String cn, String displayName, String displayName2, String mailAddr, String parentCn,	String ldapPath) throws Exception;
	
	public void insertDBData_dept(OrganDeptVO vo) throws Exception;
	
	public void updateDBData_dept(OrganDeptVO vo) throws Exception;

	public void deleteDBData(String cn, String pClass) throws Exception;
	
	public void moveDBData(String parentCn, String cn, String type) throws Exception;

	public void setPassword(String cn, String password) throws Exception;

	public void retireEntry(String cn) throws Exception;

	 
}
