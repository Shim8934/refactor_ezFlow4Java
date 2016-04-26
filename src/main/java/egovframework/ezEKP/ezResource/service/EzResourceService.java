package egovframework.ezEKP.ezResource.service;

import java.util.List;

import egovframework.ezEKP.ezResource.vo.ResGetAdmSubClsTreeVO;
import egovframework.ezEKP.ezResource.vo.ResGetAdminFlagVO;
import egovframework.ezEKP.ezResource.vo.ResGetItemListVO;
import egovframework.ezEKP.ezResource.vo.ResGetScheduleListMainVO;
import egovframework.ezEKP.ezResource.vo.ResGetScheduleListVO;

public interface EzResourceService {
	public List<ResGetAdmSubClsTreeVO> getAdmSubClsTree(String parentID, String companyID, String treeType) throws Exception;
	
	public List<ResGetAdmSubClsTreeVO> getSubClsTree(String parentID, String companyID, String treeType, String pUserID, String comID, String deptID, String userID) throws Exception;
	
	public List<ResGetItemListVO> getBrdMainList(String brdID, String companyID, String lang) throws Exception;
	
	public List<ResGetScheduleListVO> getScheduleList(String ownerID, String companyID, String startDate, String endDate, String writerName, String writerDept) throws Exception;
	
	public List<ResGetScheduleListMainVO> getScheduleListMain(String ownerID, String companyID, String startDate, String endDate) throws Exception;
	
	public List<ResGetScheduleListVO> getScheduleListRepetiti(String ownerID, String companyID, String startDate, String endDate, String writerName, String writerDept) throws Exception;
	
	public List<ResGetScheduleListMainVO> getScheduleListRepetitim(String ownerID, String companyID, String startDate) throws Exception;
	
	public ResGetAdminFlagVO getAdminFlag(String companyID, String resID, String memberID) throws Exception; 
	
}
