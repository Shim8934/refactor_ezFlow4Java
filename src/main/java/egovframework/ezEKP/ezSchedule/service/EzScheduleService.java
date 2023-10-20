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
import egovframework.ezEKP.ezSchedule.vo.ScheduleGroupVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleInfoVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleMailConfigVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleReceiveListVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleSecretaryVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleTokenInfoVO;
import egovframework.let.user.login.vo.LoginVO;


public interface EzScheduleService {
	
	public List<ScheGetHolidayVO> getTholiday (String companyID, String userCompany, int tenantId, String isRest) throws Exception;
	
	public List<AttendantListVO> getAttendantList(String scheduleId, String offSetMin, int tenantId, String companyID) throws Exception;
	
	public List<AttachListVO> getAttachList(String scheduleId, int tenantId) throws Exception;
		
	public List<ScheduleSecretaryVO> getPublicScheduleSec(String userId, String lang, int tenantId ,String companyID) throws Exception;
	
	public List<ScheduleDeptVO> getPublicScheduleDept(String userId, String lang, int tenantId ,String companyID) throws Exception;
	
	public List<ScheduleCumulerVO> getPublicScheduleCumuler(String userId, String lang, int tenantId, String companyID) throws Exception;
	
	public List<ScheduleInfoVO> getScheduleList(String indiList, String pidList, String filter, String utcStartDate, String utcEndDate, String orgStartDate, String orgEndDate, String keyword, String offSetMin, String searchTitle, int tenantId, String companyID, String userID, String deptId, String useAnnualScheduleYN) throws Exception;
	
	public List<ScheduleInfoVO> getScheduleListForWorkspace(String indiList, String pidList, String filter, String utcStartDate, String utcEndDate, String orgStartDate, String orgEndDate, String keyword, String offSetMin, String searchTitle, int tenantId, String companyID, String userID, String deptId) throws Exception;
	
	public List<ScheduleGroupListVO> getScheduleGroupList(String userId, int tenantId ,String companyID) throws Exception;

	public List<ScheduleGroupVO> getMyGroupList(String userId, int tenantId ,String companyID) throws Exception;
	
	public List<ScheduleGroupListVO> getGroupMemberList(String groupId,	String lang, int tenantId, String offSetMin ,String companyID) throws Exception;
	
	public List<ScheduleReceiveListVO> getReceiveList(String id, int tenantId, String offSetMin ,String companyID) throws Exception;
	
	public List<ScheduleGroupListVO> getInviteScheduleGroupList(String id, int tenantId, String offSetMin ,String companyID) throws Exception;
		
	public List<ScheduleSecretaryVO> getSecretaryList(String userId, int tenantId ,String companyID) throws Exception;
	
	public ScheduleConfigVO getScheduleConfig(String userId, int tenantId) throws Exception;
	
	public ScheduleInfoVO getScheduleInfo(String scheduleId, String offSetMin, int tenantId ,String companyID) throws Exception;
	
	public ScheduleMailConfigVO getScheduleMailNotiConfig(String userId, int tenantId) throws Exception;
	
	public String getMyGroupMemberList(String groupId, String lang, int tenantId ,String companyID) throws Exception;
	
	public String getDeptMemberList(String deptId, String subDept, String lang, int tenantId ,String companyID) throws Exception;
	
	public String scheduleGetLunarUse(String companyID, int tenantId) throws Exception;

	public String scheduleGetRegi(String companyID, int tenantId) throws Exception;
	
	public String getCumDeptId(String userID, int tenantID, String companyID) throws Exception;
		
	public int getReceiveCount (String pUserId, int tenantId ,String companyID) throws Exception;
	
	public int getInviteScheduleGroupCnt (String pUserId, int tenantId ,String companyID) throws Exception;
	
	public int getMyGroupMemberListCnt(String groupId, String lang, int tenantId ,String companyID) throws Exception;
	
	public int getResourceCount(String scheduleId, int tenantId) throws Exception;
	
	public int updateSchedule(String scheduleid, String creatorid, String creatorname, String creatorname2, String importance, String ispublic, String datetype, String startdate, String enddate,
			String repetition, String title, String location, String content, NodeList attach, String defaultPath, int tenantId, String companyID) throws Exception;

	public int insertSchedule(String ownerid, String ownername, String ownername2, String creatorid, String creatorname, String creatorname2, String scheduletype, String importance,
			String ispublic, String datetype, String startdate, String enddate, String repetition, String title, String location, String content, NodeList attach, NodeList attendantId, 
			NodeList attendantName, NodeList attendantName2, NodeList attendantDeptName, NodeList attendantDeptName2, String defaultPath, int tenantId ,String companyID) throws Exception;	

	public void deleteScheduleGroup(String groupId, int tenantId) throws Exception;	

	public void deleteScheduleMember(String groupId, String memberId, int tenantId) throws Exception;
	
	public void updateManageScheduleMember(String groupId, String memberId,String memberName ,String memberName2, int tenantId, String loginUserId, String loginUserName, String loginUserName2) throws Exception;

	public void updateScheduleMember(String groupId, String memberId, String status, int tenantId) throws Exception;
	
	public void updateAttendantStatus(String scheduleId, String attendantId, String status, int tenantId) throws Exception;	

	public void insertScheduleGroupMember(String groupId, String memberId, String memberName, String memberName2, int tenantId) throws Exception;

	public void insertScheduleGroup(String gUID, String id, String displayName, String displayName2, String groupName, String description, int tenantId ,String companyID, String groupColor) throws Exception;	
	
	public void updateScheduleGroup(String groupId,String id, String displayName, String displayName2, String groupName, String description, int tenantId ,String companyID, String groupColor) throws Exception;
	
	public void deleteScheduleConfig(String userID, int tenantID) throws Exception;

	public void deleteSecretary(String userID, int tenantID, String companyID) throws Exception;

	public void insertScheduleConfig(String userID, String defaultView,	String startDay, String startTime, String endTime, String autoDelete, int tenantID) throws Exception;

	public void insertSecretary(String userID, String displayName, String displayName2, String secretaryID, String secretaryName, int tenantID ,String companyID) throws Exception;

	public void deleteSchedule(String scheduleId, int tenantID) throws Exception;
	
	public void deleteResource(String scheduleId, int tenantId) throws Exception;	

	public void scheduleDelAttendant(String scheduleId, String attendantId,	int tenantId) throws Exception;

	public void insertScheduleAttendant(String scheduleId, String attendantId, String attendantName, String attendantName2, String attendantDeptName, String attendantDeptName2, int tenantId ,String companyID) throws Exception;

	public void updateAttendantSchedule(String hasAttendant, String scheduleId, int tenantId) throws Exception;	

	public void updateAttendant(String scheduleId, String attendantId, String displayName, String displayName2, String status, int tenantId) throws Exception;

	public void insertScheduleRepeDel(String scheduleId, String startDate, int tenantId ,String companyID) throws Exception;

	public void deleteScheduleRepe(String scheduleId, int tenantId) throws Exception;

	public void updateDragSchedule(String scheduleid, String userId, String displayName1, String displayName2, String utcStartTime, String utcEndTime, int tenantId, String companyID) throws Exception;

	public void copySchedule(String dragDay, String startDate, String endDate, String defaultPath, String offSetMin, int tenantId, String companyId) throws Exception;

	public List<ScheGetHolidayVO> getTholidayYear(String companyID,String userCompany, int tenantId, String isRest, String holidayYear) throws Exception;

	public void scheduleSendMail(int scheduleId, String v_attendantId, String v_attendantName, String title, String period, String type, LoginVO userInfo, String loginCookie) throws Exception;

	public void setScheduleMailNotiConfig(String userMailNoti, String userID, int tenantId) throws Exception;

	/* 2021-11-25 홍승비 - 일정완료 데이터를 삽입하는 메서드 */
	public void insertScheduleComplete(String scheduleId, String repeatCount, String isAllRep, String startdate, int tenantId, String companyID) throws Exception;
	/* 2021-11-25 홍승비 - 일정완료 데이터를 삭제하는 메서드 */
	public void deleteScheduleComplete(String scheduleId, String repeatCount, String isAllRep, String startdate, int tenantId, String companyID) throws Exception;
	/* 2021-11-26 홍승비 - 해당 반복일정의 일정완료 레코드 삭제 (전체 반복완료 레코드는 유지해야 하므로 삭제조건의 isAllRep값은 'N'으로 고정) */
	public void deleteScheduleCompleteOneRep(String scheduleId, String repeatCount, String isAllRep, String startdate, int tenantId) throws Exception;
	/* 2021-11-26 홍승비 - 일정완료 레코드가 존재하는 경우, 해당 레코드의 ISALLREP 값을 리턴하는 메서드 */
	public String getScheduleCompleteIsAllRep(String scheduleId, String repeatCount, String startdate, String dateType, int tenantId, String companyID) throws Exception;
	/* 2021-11-26 홍승비 - 일정 리스트 데이터를 전달받아 일정완료 데이터를 추가 가공하여 리턴 */
	public List<ScheduleInfoVO> applyScheduleCompleteData(List<ScheduleInfoVO> sList, String offset, int tenantId, String companyID) throws Exception;
	
	public ScheduleTokenInfoVO scheduleGetTokenInfo(String userID, int tenantID, String companyID) throws Exception;
	
	public void scheduleSaveTokenInfo(String userID, String googleAccessToken, String googleRefreshToken, String todayUtcTime, int tenantID, String companyID) throws Exception;
	
	/* 2023-07-19 홍승비 - 일정그룹의 관리자(그룹장) CREATORID(USERID)값을 리턴하는 메서드 */
	public String getScheduleGroupCreatorID(String groupID) throws Exception;
}
