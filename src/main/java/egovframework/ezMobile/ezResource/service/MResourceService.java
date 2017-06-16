package egovframework.ezMobile.ezResource.service;

import java.util.List;

import egovframework.ezMobile.ezResource.vo.MResourceGetAdmSubClsTreeVO;

public interface MResourceService {
	
	public List<MResourceGetAdmSubClsTreeVO> getAdmSubClsTree(String parentID, String companyID, String treeType, int tenantID);
	
}
