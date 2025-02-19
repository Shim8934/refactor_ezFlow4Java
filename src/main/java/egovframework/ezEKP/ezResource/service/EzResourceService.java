package egovframework.ezEKP.ezResource.service;

import java.util.Date;
import java.util.List;
import java.util.Locale;

import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.ezEKP.ezResource.vo.ResAdminVO;
import egovframework.ezEKP.ezResource.vo.ResBrdListVO;
import egovframework.ezEKP.ezResource.vo.ResBrdVO;
import egovframework.ezEKP.ezResource.vo.ResFavoriteCategoryVO;
import egovframework.ezEKP.ezResource.vo.ResGetItemListVO;
import egovframework.ezEKP.ezResource.vo.ResGetScheduleRepetitionVO;
import egovframework.ezEKP.ezResource.vo.ResGetScheduleVO;
import egovframework.ezEKP.ezResource.vo.ResGetSendMailToUserVO;
import egovframework.ezEKP.ezResource.vo.ResMakeDupResultVO;
import egovframework.ezEKP.ezResource.vo.ResOccuVO;
import egovframework.ezEKP.ezResource.vo.ResScheduleRepetitionVO;
import egovframework.ezEKP.ezResource.vo.ResSelectFormIDVO;
import egovframework.let.user.login.vo.LoginVO;

public interface EzResourceService {
	
	public List<ResGetItemListVO> getBrdMainList(String brdID, String companyID, String lang, int tenantID) throws Exception;

	/* 2024-07-05 홍승비 - SQL Injection 수정 > 다국어 칼럼은 쿼리 내부 분기로 처리 */
	public List<ResBrdListVO> getBrdList(int topCnt, int brdID, String CompanyID, String lang, int tenantID) throws Exception;

	public ResGetScheduleRepetitionVO getRepDateTimes(String ownerID, String companyID, int num, int tenantID) throws Exception;
	
	public ResBrdVO getBrd(int brdID, String companyID, int tenantID) throws Exception;
	
	public ResGetScheduleVO getSchedule(int pNum, String ownerID, String companyID, int tenantID, String lang) throws Exception;
	
	public void deleteRepetition(String ownerID, int num, String companyID, int tenantID) throws Exception;
	
	public ResSelectFormIDVO selectFormID(String resID, int tenantID) throws Exception;
	
	public List<ResAdminVO> getResourceAdminInfo(String brdID, int tenantID, String[] ownerList) throws Exception;
	
	public ResGetSendMailToUserVO getSendMailToUser(String resID, int num, int tenantID) throws Exception;
	
	public int getBrdCnt(int brdID, String companyID, int tenantID) throws Exception;

	public String getScheduleXML(String xmlStr, String resID, String companyID, String groupID, String gubun, String type, String title, String writerName, String writerDept, int tenantID, String offset, String lang) throws Exception;

	public String getAdminFlag(String companyID, String brdID, String id, int tenantID, String deptID) throws Exception;

	public String getItemList(String loginCookie, String brdID) throws Exception;

	public String getSubClsTree(String xmlReq, String lang, String companyID, String deptID, String id, int tenantID) throws Exception;
	
	public String updateScheduleDateTime(String xmlDom, String companyID, int tenantID, String offset) throws Exception;
	
	public String getRepetition(String xmlStr, int tenantID, String offset) throws Exception;
	
	public String getACL(String pCompanyID, String pBrdID, String pUserID, String pMode, int tenantID, String deptID) throws Exception;
	
	public String getBrdApproveFlag(int brdID, String companyID, int tenantID) throws Exception;

	public String getBrdRepeatFlag(int brdID, String companyID, int tenantID) throws Exception;
	
	public String addResSch(String xmlStr, int tenantID, String offset) throws Exception;
	
	public String modifyResSch(String xmlStr, int tenantID, String offset) throws Exception;
	
	public boolean deleteRepetition(String xmlStr, String companyID, int tenantID) throws Exception;
	
	public boolean saveRepetition(String companyID, String num, String ownerID, String xmlStr, String cmd, int tenantID, String offset, String lang) throws Exception;
	
	public boolean multiDelResData(String xmlStr, int tenantID, String realPath) throws Exception;
	
	public boolean modifyResData(String xmlStr, int tenantID) throws Exception;
	
	public boolean addResData(String xmlStr, int tenantID,Locale locale) throws Exception;
	
	public boolean delResSch(String xmlStr, int tenantID, String offset) throws Exception;
	
	public boolean getRepResource(String strFrequency, String strSelType, String strEndRecurType, String strStartDateTime, String strEndDateTime, String strInterval,
			String strDaysOfWeek, String strInstances, String strByPosition, String strDaysOfMonth, String strMonthsOfYear, String strPownerID, String strPnum, String companyID, List<ResMakeDupResultVO> dtResult, int tenantID, String offset) throws Exception;

	public boolean getRepResource(String strStartDateTime, String strEndDateTime, String strPownerID, String strPnum, String companyID, List<ResMakeDupResultVO> dtResult, int tenantID, String offset) throws Exception;

	public void insertForm(String resID, String brdNm, String formText, int tenantID) throws Exception;
	
	public void updateSchedule(int num, String ownerID, String companyID, String approve, int tenantID) throws Exception;
	
	public void updateSchedule2(int num, String ownerID, String companyID, String returnFlag, int tenantID) throws Exception;
	
	public void delFormID(String delCode, int tenantID) throws Exception;
	
	public String getDeptID(String writerID, String deptNm, int tenantID, String companyID) throws Exception;

	public List<OrganUserVO> getOwnerInfo(String[] ownerList, int tenantID, String companyID, String lang) throws Exception;
	
	public void changeResourceOrder(String selectedResourceId, String targetResourceId, int tenantId,String companyID,String upperResourceId) throws Exception;
	
	public void moveResourceToOtherResourceGroup(String originResourceGroupId, String selectedResourceGroupId, int tenantId, String companyID) throws Exception;
	
	public String isResourceGroupManager(String selectedResourceGroupId, String userId, int tenantId, String companyID, String deptID) throws Exception;
	
	public String userResPermissionCheck(String userID, String companyID, int tenantID, String brdID, String deptID) throws Exception;

	public List<ResBrdVO> getResourcePortlet(LoginVO userInfo, String date) throws Exception;

	public String saveResourcePortlet(String loginCookie, String resources) throws Exception;
	
	public List<String> getAttachList(String resID, String companyID, int tenantId) throws Exception;	
	
	public ResScheduleRepetitionVO resStruct(ResGetScheduleRepetitionVO vo) throws Exception;
	
	public List<Date[]> getRepDateTimes(ResScheduleRepetitionVO vo, String sDate, String eDate, String offset) throws Exception;
	
	public List<String> getDeletedRepScheduleDate(int pNum, String companyID, String ownerID, int tenantID) throws Exception;

	public List<ResBrdVO> getUserResourceList(String userId, String companyId, String deptId, int tenantId) throws Exception;

	public List<ResBrdVO> getResourceScheduleList(String brdId, String date, int currentPage, int listCnt, int tenantId, String companyId, String offset, String lang) throws Exception;
	
	public List<ResOccuVO> getResOccuList(String companyID, int tenantID, String startTime, String endTime, String offset) throws Exception;
	
	// 2024-08-23 유길상 - 자원관리 즐겨찾기 기능 추가
	public void addFavoriteCategory(String catName, String catId, String userID, String companyID, int teanatId) throws Exception;

	public List<ResFavoriteCategoryVO> getFavoriteCategoryList(String catId, String userID) throws Exception;

	public void modFavoriteCategory(String catName, String catId, String userID) throws Exception;

	public void delFavoriteCategory(String catId, String userID, String companyID, int tenantID) throws Exception;

	public String addBrdFavoriteCategory(String brdId, String catId, String userID, String companyID, int tenantID) throws Exception;

	public List<ResBrdVO> getFavoriteBrdList(String catId, String companyId, int tenantId, String userID) throws Exception;

	public String moveCategory(String userID, String companyID, int tenantID, String catId, String topId) throws Exception;

	public String moveResource(String userID, String companyID, int tenantID, String catId, String brdId, String topId) throws Exception;

	public void delBrdFavoriteCategory(String userId, int tenantId, String companyId, String delBrdId, String delTopId) throws Exception;	
}
