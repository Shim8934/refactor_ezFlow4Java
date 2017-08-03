package egovframework.ezMobile.ezResource.service;

import java.util.List;



import java.util.Map;

import egovframework.ezMobile.ezResource.vo.MResourceGetAdmSubClsTreeVO;
import egovframework.ezMobile.ezResource.vo.MResourceGetScheduleVO;
import egovframework.ezMobile.ezResource.vo.MResourceScheduleVO;

public interface MResourceService {
	
	public List<MResourceGetAdmSubClsTreeVO> getAdmSubClsTree(String parentID, String companyID, String treeType, int tenantID);
	
	public Map<String, Object> getScheduleList(String ownerID, String companyID, String groupID, String gubun, String sDate, String eDate, String pType, String pWriterName, String pWriterDept, int tenantID, String offset) throws Exception;
	
	public List<MResourceScheduleVO> getResScheduleMainList(String utcStartDate, String utcEndDate, String companyId, int page, String firstWriteDay, String lastWriteDay,int tenantId);
	
	public List<MResourceScheduleVO> getResScheduleList(String startDate, String endDate, String companyId, String ownerId, int tenantId);
	
	public MResourceScheduleVO getResScheduleDetail(String resourceId, String scheduleId, String companyId, int tenantId);
	
	public List<MResourceGetAdmSubClsTreeVO> getResBrdList(String brdId, String brdCompany, int tenantId);
	
	public List<MResourceGetAdmSubClsTreeVO> getResFavoriteList(String userId, int tenantId);
	
	public void addResSch(String ownerId, String companyId, int tenantId, String pNum, String writerId, String deptNm, String ownerNm, String title, 
			String location, String timeDisplay, String startDate, String endDate, String allDay, String alterTime, String content, String importance, 
			String writeDay, String entryList, String attachFlag, String approve, String scheduleId);
	
	public void modifyResSch(String title, String location, String timeDisplay, String startDate, String endDate, String alterTime, String content, String importance, 
			String reFlag, String gresFlag, String allDay, String writeDay, String entryList, String attachFlag, String characterId,
			String companyId, String num, String ownerId, int tenantId);
	
	public void delResSch(String companyId, String ownerId, String num, int tenantId);
	
	public void addResFavor(String resId, String userId, int tenantId);
	
	public void delResFavor(String resId, String userId, int tenantId);
	
}
