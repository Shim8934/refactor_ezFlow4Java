package egovframework.ezEKP.ezResource.service;

import java.util.List;

import egovframework.ezEKP.ezResource.vo.ResGetAdmSubClsTreeVO;
import egovframework.ezEKP.ezResource.vo.ResGetAdminFlagVO;
import egovframework.ezEKP.ezResource.vo.ResGetItemListVO;

public interface EzResourceService {
	public List<ResGetAdmSubClsTreeVO> getAdmSubClsTree(String parentID, String companyID, String treeType) throws Exception;
	
	public List<ResGetAdmSubClsTreeVO> getSubClsTree(String parentID, String companyID, String treeType, String pUserID, String comID, String deptID, String userID) throws Exception;
	
	public List<ResGetItemListVO> getBrdMainList(String brdID, String companyID, String lang) throws Exception;
	
	public ResGetAdminFlagVO getAdminFlag(String companyID, String resID, String memberID) throws Exception; 
	
}
