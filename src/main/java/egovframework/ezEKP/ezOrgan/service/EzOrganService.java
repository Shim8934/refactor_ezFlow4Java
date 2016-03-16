package egovframework.ezEKP.ezOrgan.service;

import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;

public interface EzOrganService {

	public String getPropertyValue(String userID, String propName) throws Exception;

	public String getSIPUriList(String pCNList, String eMailList) throws Exception;
	
	public String getDeptFullPath(String deptID) throws Exception;

	public OrganDeptVO getPropertyList(String userID,String primary) throws Exception; 
}
