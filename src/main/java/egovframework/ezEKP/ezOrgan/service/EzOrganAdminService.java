package egovframework.ezEKP.ezOrgan.service;

public interface EzOrganAdminService {

	public int companyCheck(String cn) throws Exception;
	
	public int companyChildCheck(String cn) throws Exception;

	public void insertDBData_company(String cn, String displayName, String displayName2, String mailAddr, String parentCn,	String ldapPath) throws Exception;

	public void deleteDBData(String cn, String pClass) throws Exception;	
	 
}
