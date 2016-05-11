package egovframework.ezEKP.ezResource.service;

import java.util.List;

import egovframework.ezEKP.ezResource.vo.ResBrdListVO;
import egovframework.ezEKP.ezResource.vo.ResBrdVO;
import egovframework.ezEKP.ezResource.vo.ResGetAdmSubClsTreeVO;
import egovframework.ezEKP.ezResource.vo.ResGetAdminFlagVO;
import egovframework.ezEKP.ezResource.vo.ResGetItemListVO;
import egovframework.ezEKP.ezResource.vo.ResGetRepDateTimesVO;
import egovframework.ezEKP.ezResource.vo.ResGetScheduleListMainVO;
import egovframework.ezEKP.ezResource.vo.ResGetScheduleListTermVO;
import egovframework.ezEKP.ezResource.vo.ResGetScheduleListVO;

public interface EzResourceService {
	public List<ResGetAdmSubClsTreeVO> getAdmSubClsTree(String parentID, String companyID, String treeType) throws Exception;
	
	public List<ResGetAdmSubClsTreeVO> getSubClsTree(String parentID, String companyID, String treeType, String pUserID, String comID, String deptID, String userID) throws Exception;
	
	public List<ResGetItemListVO> getBrdMainList(String brdID, String companyID, String lang) throws Exception;
	
	public List<ResGetScheduleListVO> getScheduleList(String ownerID, String companyID, String startDate, String endDate, String writerName, String writerDept) throws Exception;
	
	public List<ResGetScheduleListMainVO> getScheduleListMain(String ownerID, String companyID, String startDate, String endDate) throws Exception;
	
	public List<ResGetScheduleListVO> getScheduleListRepetiti(String ownerID, String companyID, String startDate, String endDate, String writerName, String writerDept) throws Exception;
	
	public List<ResGetScheduleListMainVO> getScheduleListRepetitim(String ownerID, String companyID, String startDate) throws Exception;
	
	public List<ResBrdListVO> getBrdList(int topCnt, int brdID, String CompanyID, String ownDeptNm, String ownerNm, String ownerPosition, String brdNm) throws Exception;
	
	public ResGetAdminFlagVO getAdmFlag(String companyID, String resID, String memberID) throws Exception; 
	
	public ResGetRepDateTimesVO getRepDateTimes(String ownerID, String companyID, int num) throws Exception;
	
	public ResGetScheduleListTermVO getScheduleListTerm(int num,String companyID, String ownerID, String startDate, String endDate, String writerName, String writerDept) throws Exception;
	
	public ResBrdVO getBrd(int brdID, String companyID) throws Exception;
	
	public int getBrdCnt(int brdID, String companyID) throws Exception;

	public String getScheduleXML(String xmlStr, String resID, String companyID, String groupID, String gubun, String type, String writerName, String writerDept) throws Exception;

	public String getLocalTime(String substring) throws Exception;

	public String convertToUTC(String sDate) throws Exception;

	public String getAdminFlag(String companyID, String brdID, String id) throws Exception;

	public String getItemList(String loginCookie, String brdID) throws Exception;

	public String getCurrentDate() throws Exception;

	public String getSubClsTree(String xmlReq, String lang, String companyID, String deptID, String id) throws Exception;
	
	public void delResData(String brdID, String companyID) throws Exception;

	public boolean multiDelResData(String xmlStr);

	
}
