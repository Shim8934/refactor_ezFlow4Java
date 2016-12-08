package egovframework.ezEKP.ezResource.service;

import java.util.List;

import egovframework.ezEKP.ezResource.vo.ResGetClsAclListVO;
import egovframework.ezEKP.ezResource.vo.ResGetSubClsListVO;

public interface EzResourceAdminService {
	public List<ResGetSubClsListVO> getSubClsList(String parentID, String companyID, String userID, String deptPath, int tenantID) throws Exception;
	
	public List<ResGetSubClsListVO> getAdmSubClsList(String parentID, String companyID, int tenantID) throws Exception;
	
	public List<ResGetClsAclListVO> getClsAclList(String brdID, String companyID, int tenantID) throws Exception;
	
	public ResGetSubClsListVO getBrdInfo(int brdID, String companyID, int tenantID) throws Exception;
	
	public String getSubCntOfCls(String xmlStr) throws Exception;
	
	public String getSubClsList(String xmlStr, String langStr, int tenantID) throws Exception;
	
	public String getClsACLList(String xmlStr, int tenantID) throws Exception;
	
	public int getSubResCnt(String resID, String companyID) throws Exception;
	
	public int getSubClsCnt(String resID, String companyID) throws Exception; 
	
	public boolean addClsData(String xmlStr, int tenantID) throws Exception;
	
	public boolean modifyClsData(String xmlStr, int tenantID) throws Exception;
	
	public boolean blnMoveCls(String srcBrdID, String targetBrdID, String strPara, int tenantID) throws Exception;
	
	public boolean blnChgClsOrder(String currID, String nextID, String companyID, int tenantID) throws Exception;
	
	public boolean delClsData(String xmlStr, int tenantID) throws Exception;
	
	public boolean saveACLLst(String xmlStr, int tenantID) throws Exception;
	
	public void addClsData(String classGB, String deptID, String deptNm, String ownerID, String ownerNm, String ownerPos, String ownerCall, String brdNm, String brdExplain, String accessNoty, String companyID, String brdNm2, String isCompany, int tenantID) throws Exception;
	
	public void saveACL(String resID, String deptYn, String sdaYn, String memberNam, String memberID, String accessLvl, String companyID, int tenantID) throws Exception;
	
	public void modifyClsData(String brdID, String deptID, String deptNm, String ownerID, String ownerNm, String ownerPos, String ownerCall, String brdNm, String brdExplain, String accessNoty, String companyID, String brdNm2, int tenantID) throws Exception;
	
	public void chgClsOrder(String sourceID, String targetID, String companyID, int tenantID) throws Exception;
	
	public void moveCls(String sourceID, String parentID, String companyID, int tenantID) throws Exception;
	
	public void delClsData(String brdID, String companyID, int tenantID) throws Exception;
	
	public void delResAcll(String resID, String companyID, int tenantID) throws Exception;
}
