package egovframework.ezEKP.ezOrgan.service;

public interface EzOrganService {

	String getPropertyValue(String userID, String propName) throws Exception;

	String getSIPUriList(String pCNList, String eMailList) throws Exception;
	
	String getDeptFullPath(String deptID) throws Exception;

	String getPropertyList(String userID,String primary) throws Exception; 
}
