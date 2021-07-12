package egovframework.ezEKP.ezCar.service;

import java.util.List;

import egovframework.ezEKP.ezCar.vo.CarGetClsAclListVO;
import egovframework.ezEKP.ezCar.vo.CarGetSubClsListVO;

public interface EzCarAdminService {
	
	public boolean addClsData(String xmlStr, int tenantID) throws Exception;
	public void addClsData(String classGB, String deptID, String deptNm, String ownerID, String ownerNm, String ownerPos, String ownerCall, String brdNm, String strCompanyID, String brdNm2, String isCompany, int tenantID) throws Exception;
	
	public CarGetSubClsListVO getBrdInfo(int brdID, String companyID, int tenantID) throws Exception;
	
	public boolean modifyClsData(String xmlStr, int tenantID) throws Exception;
	public void modifyClsData(String brdID, String deptID, String deptNm, String ownerID, String ownerNm, String ownerPos, String ownerCall, String brdNm, String accessNoty, String companyID, String brdNm2, int tenantID) throws Exception;

	public List<CarGetClsAclListVO> getClsAclList(String brdID, String companyID, int tenantID) throws Exception;
	public String getClsACLList(String xmlStr, int tenantID) throws Exception;

	public boolean userResPermissionCheck(String xmlStr, int tenantID) throws Exception;
	public boolean saveACLLst(String xmlStr, int tenantID) throws Exception;

	public void delResAcll(String resID, String companyID, int tenantID) throws Exception;
	public void saveACL(String resID, String deptYn, String sdaYn, String memberNam, String memberID, String accessLvl, String companyID, int tenantID) throws Exception;
	
	public int getSubResCnt(String resID, String companyID, int tenantID) throws Exception;
	public int getSubClsCnt(String resID, String companyID, int tenantID) throws Exception; 
	public String getSubCntOfCls(String xmlStr, int tenantID) throws Exception;

	public boolean delClsData(String xmlStr, int tenantID) throws Exception;
	public void delClsData(String brdID, String companyID, int tenantID) throws Exception;


}
