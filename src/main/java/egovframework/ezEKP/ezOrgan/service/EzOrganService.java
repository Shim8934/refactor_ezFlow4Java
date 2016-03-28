package egovframework.ezEKP.ezOrgan.service;

import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;

public interface EzOrganService {
	
	public OrganDeptVO getPropertyList(String userID,String primary) throws Exception;

	public String getPropertyValue(String userID, String propName) throws Exception;

	public String getSIPUriList(String pCNList, String eMailList) throws Exception;
	
	public String getDeptFullPath(String deptID) throws Exception;
	
	public String getDeptTreeInfo(String userID, String deptID, String topID, String propList, String lang) throws Exception;

	public String getDeptMemberList(String deptid, String celllist, String proplist, String listtype, String lang) throws Exception;	
	 
}
