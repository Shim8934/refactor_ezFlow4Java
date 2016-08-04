package egovframework.ezEKP.ezOrgan.service;

import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;

public interface EzOrganService {
	
	public OrganDeptVO getDeptInfo(String userID,String primary) throws Exception;	

	public String getPropertyValue(String userID, String propName) throws Exception;

	public String getSIPUriList(String pCNList, String eMailList) throws Exception;
	
	public String getDeptFullPath(String deptID) throws Exception;
	
	public String getDeptTreeInfo(String userID, String deptID, String topID, String propList, String lang) throws Exception;

	public String getDeptMemberList(String deptid, String celllist, String proplist, String listtype, String lang) throws Exception;
	
	public String getDeptMemberListPagination(String deptid, String celllist, String proplist, String listtype, String lang, String page) throws Exception;
	
	public String getSearchList(String searchlist, String celllist,	String proplist, String listtype, int i, String lang) throws Exception;

	public String getDeptSubTreeInfo(String deptID, String propList, String lang) throws Exception;
	
	public String convertAddandConvert(String pClass, String pProvValue) throws Exception;
	
	public String getPropertyList(String id, String proplist, String primary) throws Exception;

	public String getUserAddjobInfo(String id, String pDeptID, String primary) throws Exception;	
	
	public String getOrganTreeInfo(String strFilter, int intScope) throws Exception;
	
	public String getEncPassword(String dUserID) throws Exception;
	
	public String getSearchListPagination(String searchlist, String celllist, String proplist, String listtype, int i, String lang, String page) throws Exception;
	
	public String updateProperty(String userID, String propName, String propValue, String pClass) throws Exception;
	
	public String delProxyUserInfo(String userID) throws Exception;
	
	public String setProxyUserInfo(String userID, String proxyUserID, String proxyUserName, String proxyUserDeptID, String startDate, String endDate) throws Exception;
	
	public String getProxyUserInfo(String userID) throws Exception;
	
	public boolean checkDBColum(String pProvValue) throws Exception;
	
	public boolean checkSearchField(String pFieldName) throws Exception;

 
}
