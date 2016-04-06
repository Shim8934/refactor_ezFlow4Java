package egovframework.ezEKP.ezOrgan.service;

import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.ezEKP.ezOrgan.vo.OrganGetUserInfoVO;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;

public interface EzOrganService {
	
	public OrganDeptVO getDeptInfo(String userID,String primary) throws Exception;
	
	public OrganGetUserInfoVO getUserInfo(String userID,String primary) throws Exception;

	public String getPropertyValue(String userID, String propName) throws Exception;

	public String getSIPUriList(String pCNList, String eMailList) throws Exception;
	
	public String getDeptFullPath(String deptID) throws Exception;
	
	public String getDeptTreeInfo(String userID, String deptID, String topID, String propList, String lang) throws Exception;

	public String getDeptMemberList(String deptid, String celllist, String proplist, String listtype, String lang) throws Exception;

	public String getSearchList(String searchlist, String celllist,	String proplist, String listtype, int i, String lang) throws Exception;

	public String getDeptSubTreeInfo(String deptID, String propList, String lang) throws Exception;	
	
	public OrganUserVO getTBLUserMaster(String userID, String deptID, String lang) throws Exception;
	
	public String getPropertyList(String userID, String pPropList, String lang) throws Exception;
	 
}
