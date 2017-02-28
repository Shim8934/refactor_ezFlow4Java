package egovframework.ezEKP.ezSchedule.service;

import java.util.List;

import org.w3c.dom.NodeList;

import egovframework.ezEKP.ezSchedule.vo.AttachListVO;
import egovframework.ezEKP.ezSchedule.vo.AttendantListVO;
import egovframework.ezEKP.ezSchedule.vo.ScheGetHolidayVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleConfigVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleCumulerVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleDeptVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleGroupListVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleInfoVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleReceiveListVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleSecretaryVO;


public interface EzScheduleService {
	
	public List<ScheGetHolidayVO> getTholiday (String companyID, String userCompany, int tenantId) throws Exception;
	
	public List<AttendantListVO> getAttendantList(String scheduleId, String offSetMin, int tenantId) throws Exception;
	
	public List<AttachListVO> getAttachList(String scheduleId, int tenantId) throws Exception;
		
	public List<ScheduleSecretaryVO> getPublicScheduleSec(String userId, String lang, int tenantId) throws Exception;
	
	public List<ScheduleDeptVO> getPublicScheduleDept(String userId, String lang, int tenantId) throws Exception;
	
	public List<ScheduleCumulerVO> getPublicScheduleCumuler(String userId, String lang, int tenantId) throws Exception;
	
	public List<ScheduleInfoVO> getScheduleList(String pidList, String filter, String startDate, String endDate, String keyword, String offSetMin, int tenantId) throws Exception;
	
	public List<ScheduleGroupListVO> getScheduleGroupList(String userId, int tenantId) throws Exception;

	public List<ScheduleGroupListVO> getMyGroupList(String userId, int tenantId) throws Exception;
	
	public List<ScheduleGroupListVO> getGroupMemberList(String groupId,	int tenantId, String offSetMin) throws Exception;
	
	public List<ScheduleReceiveListVO> getReceiveList(String id, int tenantId, String offSetMin) throws Exception;
	
	public List<ScheduleGroupListVO> getInviteScheduleGroupList(String id, int tenantId, String offSetMin) throws Exception;
	
	public List<ScheduleSecretaryVO> getSecretaryList(String userId, int tenantId) throws Exception;
	
	public ScheduleConfigVO getScheduleConfig(String userId, int tenantId) throws Exception;
	
	public ScheduleInfoVO getScheduleInfo(String scheduleId, String offSetMin, int tenantId) throws Exception;
	
	public String getMyGroupMemberList(String groupId, String lang, int tenantId) throws Exception;

	public String getDeptMemberList(String deptId, String subDept, String lang, int tenantId) throws Exception;
	
	public String scheduleGetLunarUse(String companyID, int tenantId) throws Exception;

	public String scheduleGetRegi(String companyID, int tenantId) throws Exception;
		
	public int getReceiveCount (String pUserId, int tenantId) throws Exception;
	
	public int getInviteScheduleGroupCnt (String pUserId, int tenantId) throws Exception;
	
	public int getMyGroupMemberListCnt(String groupId, String lang, int tenantId) throws Exception;
	
	public int getResourceCount(String scheduleId, int tenantId) throws Exception;
	
	public int updateSchedule(String scheduleid, String creatorid, String creatorname, String creatorname2, String importance, String ispublic, String datetype, String startdate, String enddate,
			String repetition, String title, String location, String content, NodeList attach, String defaultPath, int tenantId) throws Exception;

	public int insertSchedule(String ownerid, String ownername, String ownername2, String creatorid, String creatorname, String creatorname2, String scheduletype, String importance,
			String ispublic, String datetype, String startdate, String enddate, String repetition, String title, String location, String content, NodeList attach, NodeList attendantId, 
			NodeList attendantName, NodeList attendantName2, NodeList attendantDeptName, NodeList attendantDeptName2, String defaultPath, int tenantId) throws Exception;	

	public void deleteScheduleGroup(String groupId, int tenantId) throws Exception;	

	public void deleteScheduleMember(String groupId, String memberId, int tenantId) throws Exception;

	public void updateScheduleMember(String groupId, String memberId, String status, int tenantId) throws Exception;

	public void insertScheduleGroupMember(String groupId, String memberId, String memberName, String memberName2, int tenantId) throws Exception;

	public void insertScheduleGroup(String gUID, String id, String displayName, String displayName2, String groupName, String description, int tenantId) throws Exception;	

	public void deleteScheduleConfig(String userID, int tenantID) throws Exception;

	public void deleteSecretary(String userID, int tenantID) throws Exception;

	public void insertScheduleConfig(String userID, String defaultView,	String startDay, String startTime, String endTime, String autoDelete, int tenantID) throws Exception;

	public void insertSecretary(String userID, String displayName, String displayName2, String secretaryID, String secretaryName, int tenantID) throws Exception;

	public void deleteSchedule(String scheduleId, int tenantID) throws Exception;
	
	public void deleteResource(String scheduleId, int tenantId) throws Exception;	

	public void scheduleDelAttendant(String scheduleId, String attendantId,	int tenantId) throws Exception;

	public void insertScheduleAttendant(String scheduleId, String attendantId, String attendantName, String attendantName2, String attendantDeptName, String attendantDeptName2, int tenantId) throws Exception;

	public void updateAttendantSchedule(String hasAttendant, String scheduleId, int tenantId) throws Exception;	

	public void updateAttendant(String scheduleId, String attendantId, String displayName, String displayName2, String status, int tenantId) throws Exception;

	public void insertScheduleRepeDel(String scheduleId, String startDate, int tenantId) throws Exception;

	public void deleteScheduleRepe(String scheduleId, int tenantId) throws Exception;
	
}
