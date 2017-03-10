package egovframework.ezEKP.ezResource.service;

import java.util.List;
import java.util.Locale;

import egovframework.ezEKP.ezResource.vo.ResAdminVO;
import egovframework.ezEKP.ezResource.vo.ResBrdListVO;
import egovframework.ezEKP.ezResource.vo.ResBrdVO;
import egovframework.ezEKP.ezResource.vo.ResDateVO;
import egovframework.ezEKP.ezResource.vo.ResGetAdmSubClsTreeVO;
import egovframework.ezEKP.ezResource.vo.ResGetAdminFlagVO;
import egovframework.ezEKP.ezResource.vo.ResGetItemListVO;
import egovframework.ezEKP.ezResource.vo.ResGetScheduleRepetitionVO;
import egovframework.ezEKP.ezResource.vo.ResGetScheduleVO;
import egovframework.ezEKP.ezResource.vo.ResGetSendMailToUserVO;
import egovframework.ezEKP.ezResource.vo.ResMakeDupResultVO;
import egovframework.ezEKP.ezResource.vo.ResSelectFormIDVO;

public interface EzResourceService {
	
	public List<ResGetItemListVO> getBrdMainList(String brdID, String companyID, String lang, int tenantID) throws Exception;
	
	public List<ResBrdListVO> getBrdList(int topCnt, int brdID, String CompanyID, String ownDeptNm, String ownerNm, String ownerPosition, String brdNm, int tenantID) throws Exception;

	public ResGetScheduleRepetitionVO getRepDateTimes(String ownerID, String companyID, int num, int tenantID) throws Exception;
	
	public ResBrdVO getBrd(int brdID, String companyID, int tenantID) throws Exception;
	
	public ResGetScheduleVO getSchedule(int pNum, String ownerID, String companyID, int tenantID) throws Exception;
	
	public ResSelectFormIDVO selectFormID(String resID, int tenantID) throws Exception;
	
	public ResAdminVO getResourceAdminInfo(String brdID, int tenantID) throws Exception;
	
	public ResGetSendMailToUserVO getSendMailToUser(String resID, int num, int tenantID) throws Exception;
	
	public int getBrdCnt(int brdID, String companyID, int tenantID) throws Exception;

	public String getScheduleXML(String xmlStr, String resID, String companyID, String groupID, String gubun, String type, String writerName, String writerDept, int tenantID, String offset) throws Exception;

	public String getAdminFlag(String companyID, String brdID, String id, int tenantID) throws Exception;

	public String getItemList(String loginCookie, String brdID) throws Exception;

	public String getSubClsTree(String xmlReq, String lang, String companyID, String deptID, String id, int tenantID) throws Exception;
	
	public String updateScheduleDateTime(String xmlDom, String companyID, int tenantID, String offset) throws Exception;
	
	public String getRepetition(String xmlStr, int tenantID, String offset) throws Exception;
	
	public String getACL(String pCompanyID, String pBrdID, String pUserID, String pMode, int tenantID) throws Exception;
	
	public String getBrdApproveFlag(int brdID, String companyID, int tenantID) throws Exception;
	
	public String addResSch(String xmlStr, int tenantID, String offset) throws Exception;
	
	public String modifyResSch(String xmlStr, int tenantID, String offset) throws Exception;
	
	public boolean deleteRepetition(String xmlStr, String companyID, int tenantID) throws Exception;
	
	public boolean saveRepetition(String companyID, String num, String ownerID, String xmlStr, String cmd, int tenantID, String offset) throws Exception;
	
	public boolean multiDelResData(String xmlStr, int tenantID) throws Exception;
	
	public boolean modifyResData(String xmlStr, int tenantID) throws Exception;
	
	public boolean addResData(String xmlStr, int tenantID,Locale locale) throws Exception;
	
	public boolean delResSch(String xmlStr, int tenantID, String offset) throws Exception;
	
	public boolean getRepResource(String strFrequency, String strSelType, String strEndRecurType, String strStartDateTime, String strEndDateTime, String strInterval,
			String strDaysOfWeek, String strInstances, String strByPosition, String strDaysOfMonth, String strMonthsOfYear, String strPownerID, String strPnum, String companyID, List<ResMakeDupResultVO> dtResult, int tenantID, String offset) throws Exception;

	public boolean getRepResource(String strStartDateTime, String strEndDateTime, String strPownerID, String strPnum, String companyID, List<ResMakeDupResultVO> dtResult, int tenantID, String offset) throws Exception;
	
	public void insertForm(String resID, String brdNm, String formText, int tenantID) throws Exception;
	
	public void updateSchedule(int num, String ownerID, String companyID, String approve, int tenantID) throws Exception;
	
	public void delFormID(String delCode, int tenantID) throws Exception;
	
}
