package egovframework.ezEKP.ezOrgan.service;

import egovframework.let.user.login.vo.LoginVO;

public interface EzOrganService {

	public String getPropertyValue(String userID, String propName) throws Exception;

	public String getSIPUriList(String pCNList, String eMailList) throws Exception;
	
	public String getDeptFullPath(String deptID) throws Exception;

	public LoginVO getPropertyList(String userID,String primary) throws Exception; 
}
