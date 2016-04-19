package egovframework.ezEKP.ezResource.service;

import java.util.List;

import egovframework.ezEKP.ezResource.vo.ResGetAdmSubClsTreeVO;

public interface EzResourceService {
	public List<ResGetAdmSubClsTreeVO> getAdmSubClsTree(String parentID, String companyID, String treeType) throws Exception;
	
	public List<ResGetAdmSubClsTreeVO> getSubClsTree(String parentID, String companyID, String treeType, String pUserID, String comID, String deptID, String userID) throws Exception;
}
