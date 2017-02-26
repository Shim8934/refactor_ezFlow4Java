package egovframework.ezEKP.ezResource.service;

import java.util.List;
import java.util.Locale;

import egovframework.ezEKP.ezResource.vo.ResAdminVO;
import egovframework.ezEKP.ezResource.vo.ResBrdListVO;
import egovframework.ezEKP.ezResource.vo.ResBrdVO;
import egovframework.ezEKP.ezResource.vo.ResGetAdmSubClsTreeVO;
import egovframework.ezEKP.ezResource.vo.ResGetAdminFlagVO;
import egovframework.ezEKP.ezResource.vo.ResGetItemListVO;
import egovframework.ezEKP.ezResource.vo.ResGetRepDateTimesVO;
import egovframework.ezEKP.ezResource.vo.ResGetRepResourceRepeatVO;
import egovframework.ezEKP.ezResource.vo.ResGetRepResourceVO;
import egovframework.ezEKP.ezResource.vo.ResGetScheduleListMainVO;
import egovframework.ezEKP.ezResource.vo.ResGetScheduleListRepetitionVO;
import egovframework.ezEKP.ezResource.vo.ResGetScheduleListTermVO;
import egovframework.ezEKP.ezResource.vo.ResGetScheduleListVO;
import egovframework.ezEKP.ezResource.vo.ResGetScheduleRepetitionVO;
import egovframework.ezEKP.ezResource.vo.ResGetScheduleVO;
import egovframework.ezEKP.ezResource.vo.ResGetSendMailToUserVO;
import egovframework.ezEKP.ezResource.vo.ResMakeDupResultVO;
import egovframework.ezEKP.ezResource.vo.ResSelectFormIDVO;

public interface EzResourceService {
	public List<ResGetAdmSubClsTreeVO> getAdmSubClsTree(String parentID, String companyID, String treeType, int tenantID) throws Exception;
	
	public List<ResGetAdmSubClsTreeVO> getSubClsTree(String parentID, String companyID, String treeType, String pUserID, String comID, String deptID, String userID, int tenantID) throws Exception;
	
	public List<ResGetItemListVO> getBrdMainList(String brdID, String companyID, String lang, int tenantID) throws Exception;
	
	public List<ResGetScheduleListVO> getScheduleList(String ownerID, String companyID, String startDate, String endDate, String writerName, String writerDept, String offset, int tenantID) throws Exception;
	
	public List<ResGetScheduleListMainVO> getScheduleListMain(String ownerID, String companyID, String startDate, String endDate, String offset, int tenantID) throws Exception;
	
	public List<ResGetScheduleListRepetitionVO> getScheduleListRepetiti(String ownerID, String companyID, String startDate, String endDate, String writerName, String writerDept, String offset, int tenantID) throws Exception;
	
	public List<ResGetScheduleListMainVO> getScheduleListRepetitim(String ownerID, String companyID, String startDate, int tenantID, String offset) throws Exception;
	
	public List<ResBrdListVO> getBrdList(int topCnt, int brdID, String CompanyID, String ownDeptNm, String ownerNm, String ownerPosition, String brdNm, int tenantID) throws Exception;

	public List<ResGetScheduleVO> getScheduleInfo(int pNum, String entryID, String ownerID, String companyID, int tenantID) throws Exception;
	
	public List<ResGetScheduleRepetitionVO> getScheduleRepetition(int pNum, String ownerID, String companyID, int tenantID) throws Exception;
	
	public List<ResGetRepResourceVO> getRepResource(int frequency, int selType, int endRecurType, String startDateTime, String endDateTime, int interval, String daysOfWeek, int instances, int byPosition, String daysOfMonth, String ownerID, int num, String cmd, String companyID, int tenantID, String offset) throws Exception;
	
	public List<ResGetRepResourceRepeatVO> getRepResourceRepeat(String ownerID, int num, String cmd, String companyID, int tenantID) throws Exception;
	
	public List<ResGetScheduleVO> getDeletedRepSchedule(String companyID, String ownerID, int tenantID) throws Exception;
	
	public ResGetAdminFlagVO getAdmFlag(String companyID, String resID, String memberID, int tenantID) throws Exception; 
	
	public ResGetRepDateTimesVO getRepDateTimes(String ownerID, String companyID, int num, int tenantID) throws Exception;
	
	public ResGetScheduleListTermVO getScheduleListTerm(int num,String companyID, String ownerID, String startDate, String endDate, String writerName, String writerDept, int tenantID) throws Exception;
	
	public ResBrdVO getBrd(int brdID, String companyID, int tenantID) throws Exception;
	
	public ResGetScheduleVO getSchedule(int pNum, String ownerID, String companyID, int tenantID) throws Exception;
	
	public ResSelectFormIDVO selectFormID(String resID, int tenantID) throws Exception;
	
	public ResGetRepResourceVO chkDeletedRepResource(String ownerID, int tenantID) throws Exception;
	
	public ResAdminVO getResourceAdminInfo(String brdID, int tenantID) throws Exception;
	
	public ResGetSendMailToUserVO getSendMailToUser(String resID, int num, int tenantID) throws Exception;
	
	public int getBrdCnt(int brdID, String companyID, int tenantID) throws Exception;

	public String getScheduleXML(String xmlStr, String resID, String companyID, String groupID, String gubun, String type, String writerName, String writerDept, int tenantID, String offset) throws Exception;

	public String getAdminFlag(String companyID, String brdID, String id, int tenantID) throws Exception;

	public String getItemList(String loginCookie, String brdID) throws Exception;

	public String getSubClsTree(String xmlReq, String lang, String companyID, String deptID, String id, int tenantID) throws Exception;
	
	public String updateScheduleDateTime(String xmlDom, String companyID, int tenantID, String offset) throws Exception;
	
	public String getRepetition(String xmlStr, int tenantID, String offset) throws Exception;
	
	public String getAclTblBrd(String companyID, String brdID, String userID, String mode, int tenantID) throws Exception;
	
	public String getACL(String pCompanyID, String pBrdID, String pUserID, String pMode, int tenantID) throws Exception;
	
	public String getBrdApproveFlag(int brdID, String companyID, int tenantID) throws Exception;
	
	public String isoUTFDate(String dateTimeStr, Locale locale);
	
	public String convertDate(String strSource, String fromDateFormat, String toDateFormat, String strTimeZone) throws Exception;
	
	public String addResSch(String xmlStr, int tenantID, String offset) throws Exception;
	
	public String modifyResSch(String xmlStr, int tenantID, String offset) throws Exception;
	
	public String addMinutes(String sDate, int minute, String dateFormat) throws Exception;
	
	public boolean deleteRepetition(String xmlStr, int tenantID) throws Exception;
	
	public boolean saveRepetition(String companyID, String num, String ownerID, String xmlStr, String cmd, int tenantID, String offset) throws Exception;
	
	public boolean multiDelResData(String xmlStr, int tenantID) throws Exception;
	
	public boolean modifyResData(String xmlStr, int tenantID) throws Exception;
	
	public boolean addResData(String xmlStr, int tenantID,Locale locale) throws Exception;
	
	public boolean delResSch(String xmlStr, int tenantID, String offset) throws Exception;
	
	public boolean getRepResource(String strFrequency, String strSelType, String strEndRecurType, String strStartDateTime, String strEndDateTime, String strInterval,
			String strDaysOfWeek, String strInstances, String strByPosition, String strDaysOfMonth, String strPownerID, String strPnum, String strPcmd, String companyID, List<ResMakeDupResultVO> dtResult, int tenantID, String offset) throws Exception;

	public boolean getRepResource(String strStartDateTime, String strEndDateTime, String strPownerID, String strPnum, String strPcmd, String companyID, List<ResMakeDupResultVO> dtResult, int tenantID, String offset) throws Exception;
	
	public void insertScheduleRepetition(int pNum, String ownerID, String startDateTime, String endDateTime, String reWay, String reDay, String reNum, String reYoil, String reMonth,
	String reOrd, String endFlag, String reCount, String companyID, int tenantID, String offset) throws Exception;
	
	public void insertForm(String resID, String brdNm, String formText, int tenantID) throws Exception;
	
	public void addResSch(String ownerID, String pNum, String companyID, String writerID, String title, String location, String timeDisplay, String startDate, 
			String endDate, String allDay, String alertTime, String content, String importance, String reFlag, String gresFlag, String entryList, String characterID, String attachFlag, 
			String deptNm, String ownerNm, String approve, String scheduleID, int tenantID, String offset) throws Exception;
	
	public void delResData(String brdID, String companyID, int tenantID) throws Exception;
	
	public void modifyResData(String brdID, String deptID, String deptNm, String ownerID, String ownerNm, String ownerPos, String ownerCall, String brdNm, String resLocation, 
	String brdExplain, String companyID, String approve, String brdNm2, String deptNm2, String ownerNm2, String ownerPos2, int tenantID) throws Exception;
	
	public void addResData(String classGB, String deptID, String deptNm, String ownerID, String ownerNm, String ownerPos, String ownerCall, String brdNm, String resLocation, 
	String brdExplain, String companyID, String approve, String brdNm2, String deptNm2, String ownerNm2, String ownerPos2,String strBreAccess, int tenantID) throws Exception;
	
	public void updateScheduleDateTime(int num, String ownerID, String companyID, String startDate, String endDate, int tenantID) throws Exception;
	
	public void updateScheduleRepetition(int pNum, String ownerID, String startDateTime, String endDateTime, String reWay, String reDay, String reNum, String reYoil, String reMonth,
	String reOrd, String endFlag, String reCount, String companyID, int tenantID, String offset) throws Exception;
	
	public void updateSchedule(int num, String ownerID, String companyID, String approve, int tenantID) throws Exception;
	
	public void modifyResSch(String ownerID, String num, String pNum, String companyID, String writerID, String title, String location, String timeDisplay, String startDate, 
	String endDate, String allDay, String alertTime, String content, String importance, String reFlag, String gresFlag, String entryList, String characterID, String attachFlag, 
	String typeVal, String approve, int tenantID, String offset) throws Exception;
	
	public void deleteRepetition(String ownerID, int pNum, int tenantID) throws Exception;
	
	public void delFormID(String delCode, int tenantID) throws Exception;
	
	public void delResSch(String ownerID, String num, String pNum, String companyID, String writerID, String sDate, String eDate, int insType, String offset, int tenantID) throws Exception;
}
