package egovframework.ezEKP.ezSchedule.service;

import java.util.List;

import egovframework.ezEKP.ezSchedule.vo.AttachListVO;
import egovframework.ezEKP.ezSchedule.vo.AttendantListVO;
import egovframework.ezEKP.ezSchedule.vo.PubScheCumulerVO;
import egovframework.ezEKP.ezSchedule.vo.PubScheDeptVO;
import egovframework.ezEKP.ezSchedule.vo.PubScheHqVO;
import egovframework.ezEKP.ezSchedule.vo.PubScheSecVO;
import egovframework.ezEKP.ezSchedule.vo.ScheGetHolidayVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleConfigVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleGroupListVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleInfoVO;


public interface EzScheduleService {
	
	public List<ScheGetHolidayVO> getTholiday (String companyID, String userCompany) throws Exception;
	
	public ScheduleConfigVO getScheduleConfig(String userId, int tenantId) throws Exception;
	
	public ScheduleInfoVO getScheduleInfo(String scheduleId) throws Exception;
	
	public List<AttendantListVO> getAttendantList(String scheduleId) throws Exception;
	
	public List<AttachListVO> getAttachList(String scheduleId) throws Exception;
	
	public List<PubScheHqVO> getPublicScheduleHq(String userId) throws Exception;
	
	public List<PubScheSecVO> getPublicScheduleSec(String userId, String lang) throws Exception;
	
	public List<PubScheDeptVO> getPublicScheduleDept(String userId, String lang) throws Exception;
	
	public List<PubScheCumulerVO> getPublicScheduleCumuler(String userId, String lang) throws Exception;
	
	public int getNewScheduleId() throws Exception;
	
	public int getReceiveCount (String pUserId) throws Exception;
	
	public int getInviteScheduleGroupCnt (String pUserId) throws Exception;

	public void scheduleNewItem(ScheduleInfoVO scheduleInfoVO) throws Exception;

	public String getScheduleList(String startDate, String endDate, String userID, String deptID, String companyID) throws Exception;
	
	public List<ScheduleGroupListVO> getScheduleGroupList(String userID) throws Exception;

	public List<ScheduleGroupListVO> getMyGroupList(String userID, int tenantId) throws Exception;
	
	public int getMyGroupMemberListCnt(String groupId, String lang, int tenantId) throws Exception;

	public String getMyGroupMemberList(String groupId, String lang, int tenantId) throws Exception;

	public void deleteScheduleGroup(String groupId, int tenantId) throws Exception;

	
}
