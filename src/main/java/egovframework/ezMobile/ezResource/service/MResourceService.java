package egovframework.ezMobile.ezResource.service;

import java.util.List;



import java.util.Map;










import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.ezMobile.ezResource.vo.MResourceGetAdmSubClsTreeVO;
import egovframework.ezMobile.ezResource.vo.MResourceScheduleVO;
import egovframework.ezMobile.ezResource.vo.ResScheGetHolidayVO;

public interface MResourceService {
	
	public List<MResourceGetAdmSubClsTreeVO> getAdmSubClsTree(String parentID, String companyID, String treeType, int tenantID);
	
	public Map<String, Object> getScheduleList(String ownerID, String companyID, String sDate, String eDate, String pWriterDept, int tenantID, String offset, String listCnt, String check, String checkNum, String checkSDate, String checkEDate, String langStr) throws Exception;
	
	public Map<String, Object> getScheduleApprList(String ownerID, String companyID, String sDate, String eDate, String userId, String deptId, String writerName, String approveType, int tenantID, String offset, String check, String checkNum, String checkSDate, String checkEDate, String langStr, String authYn) throws Exception;
	
	public Map<String, Object> getScheduleMainList(MCommonVO info, String listCnt, String langStr) throws Exception;
		
	public List<MResourceScheduleVO> getResScheduleMainList(String utcStartDate, String utcEndDate, String companyId, int page, String firstWriteDay, String lastWriteDay,int tenantId);
	
	public List<MResourceScheduleVO> getResScheduleList(String startDate, String endDate, String companyId, String ownerId, int tenantId);
	
	public MResourceScheduleVO getResScheduleDetail(String resourceId, String scheduleId, String companyId, int tenantId, String langStr);
	
	public List<MResourceGetAdmSubClsTreeVO> getResBrdList(String brdId, String brdCompany,  String userId, String userCompany, String userDept , int tenantId, String langStr, String authYn) throws Exception;
	
	public List<MResourceGetAdmSubClsTreeVO> getResApprBrdList(String brdCompany, String userId, String userCompany, String userDept, int tenantId, String langStr, String authYn);
	
	public List<MResourceGetAdmSubClsTreeVO> getResApprBrdListCheck(String brdCompany, String userId, String userCompany, String userDept, int tenantId, String langStr, String authYn, String brdID) throws Exception;
	
	public List<MResourceScheduleVO> getResFavoriteList(String userId, String companyId, int tenantId, String langStr);
	
	public Integer addResSch(String ownerId, String companyId, int tenantId, String pNum, String writerId, String deptNm, String ownerNm, String title, 
			String location, String timeDisplay, String startDate, String endDate, String allDay, String alterTime, String content, String importance, 
			String writeDay, String entryList, String attachFlag, String approveFlag, String reFlag,String scheduleId);
	
	public void modifyResSch(String title, String startDate, String endDate, 
			String alterTime, String content,String importance, String reFlag, String allDay,String approveFlag,
			String companyId, String num, String ownerId, int tenantId);
	
	public void delResSch(String companyId, String ownerId, String num, String startDate, String endDate, String offset,String reFlag, int tenantId) throws Exception;
	
	public void addResFavor(String resId, String companyId, String userId, int tenantId);
	
	public void delResFavor(String resId, String userId, int tenantId);
	
	public List<ResScheGetHolidayVO> getTholiday(String companyId, String userCompany, int tenantId) throws Exception ;
	
	public MResourceScheduleVO getResBrdDetail(String ownerId, String companyId, int tenantId) throws Exception;
	
	public List<String> getResAdminAuth(String userId, int tenantId, String companyId) throws Exception;
	
	public String getResUpperBrdID(String ownerId, int tenantId, String companyId) throws Exception;
}
