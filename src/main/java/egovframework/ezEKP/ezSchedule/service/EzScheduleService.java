
package egovframework.ezEKP.ezSchedule.service;

import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import java.util.Map;

import org.json.simple.JSONArray;
import org.w3c.dom.NodeList;

import egovframework.ezEKP.ezSchedule.vo.AttachListVO;
import egovframework.ezEKP.ezSchedule.vo.AttendantListVO;
import egovframework.ezEKP.ezSchedule.vo.ScheDeptVO;
import egovframework.ezEKP.ezSchedule.vo.ScheGetHolidayVO;
import egovframework.ezEKP.ezSchedule.vo.ScheSecretaryVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleConfigVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleCumulerVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleDeptVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleGroupListVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleGroupVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleInfoVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleMailConfigVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleReceiveListVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleReminderVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleSecretaryVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleTokenInfoVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleTypeConfigVO;
import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.ezMobile.ezSchedule.vo.MScheduleInfoVO;
import egovframework.let.user.login.vo.LoginVO;


public interface EzScheduleService {
	
	public List<ScheGetHolidayVO> getTholiday (String companyID, String userCompany, int tenantId, String isRest) throws Exception;
	
	public List<AttendantListVO> getAttendantList(String scheduleId, String offSetMin, int tenantId, String companyID) throws Exception;
	
	public List<AttachListVO> getAttachList(String scheduleId, int tenantId) throws Exception;
		
	public List<ScheduleSecretaryVO> getPublicScheduleSec(String userId, String lang, int tenantId ,String companyID) throws Exception;
	
	public List<ScheduleDeptVO> getPublicScheduleDept(String userId, String lang, int tenantId ,String companyID) throws Exception;
	
	public List<ScheduleCumulerVO> getPublicScheduleCumuler(String userId, String lang, int tenantId, String companyID) throws Exception;
	
	public List<ScheduleInfoVO> getScheduleList(String indiList, String pidList, String filter, String utcStartDate, String utcEndDate, String orgStartDate, String orgEndDate, String offSetMin, String searchTitle, String searchLocation, String searchAll, int tenantId, String companyID, String userID, String deptId, String useAnnualScheduleYN) throws Exception;
	
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
			String repetition, String title, String location, String content, NodeList attach, String defaultPath, int tenantId, String companyID, String showtop) throws Exception;

	public int insertSchedule(String ownerid, String ownername, String ownername2, String creatorid, String creatorname, String creatorname2, String scheduletype, String importance,
			String ispublic, String datetype, String startdate, String enddate, String repetition, String title, String location, String content, NodeList attach, NodeList attendantId, 
			NodeList attendantName, NodeList attendantName2, NodeList attendantDeptName, NodeList attendantDeptName2, String defaultPath, int tenantId ,String companyID, String showtop, String offSet, String lang) throws Exception;

	public void deleteScheduleGroup(String groupId, int tenantId) throws Exception;	

	public void deleteScheduleMember(String groupId, String memberId, int tenantId) throws Exception;
	
	public void updateManageScheduleMember(String groupId, String memberId,String memberName ,String memberName2, int tenantId, String loginUserId, String loginUserName, String loginUserName2) throws Exception;

	public void updateScheduleMember(String groupId, String memberId, String status, int tenantId) throws Exception;
	
	public void updateAttendantStatus(String scheduleId, String attendantId, String status, int tenantId) throws Exception;	

	public void insertScheduleGroupMember(String groupId, String memberId, String memberName, String memberName2, String memberDeptId, int tenantId, String writePermission) throws Exception;

	public void insertScheduleGroup(String gUID, String id, String displayName, String displayName2, String groupName, String description, int tenantId ,String companyID, String groupColor) throws Exception;	
	
	public void updateScheduleGroup(String groupId,String id, String displayName, String displayName2, String groupName, String description, int tenantId ,String companyID, String groupColor) throws Exception;
	
	public void deleteScheduleConfig(String userID, int tenantID) throws Exception;

	public void deleteSecretary(String userID, int tenantID, String companyID) throws Exception;

	public void insertSecretary(String userID, String displayName, String displayName2, String secretaryID, String secretaryName, int tenantID ,String companyID) throws Exception;

	public void deleteSchedule(String scheduleId, int tenantID) throws Exception;
	
	public void deleteResource(String scheduleId, int tenantId) throws Exception;	

	public void scheduleDelAttendant(String scheduleId, String attendantId,	int tenantId) throws Exception;

	public void insertScheduleAttendant(String scheduleId, String attendantId, String attendantName, String attendantName2, String attendantDeptName, String attendantDeptName2, int tenantId ,String companyID) throws Exception;

	public void updateAttendantSchedule(String hasAttendant, String scheduleId, int tenantId) throws Exception;	

	public void updateAttendant(String scheduleId, String attendantId, String displayName, String displayName2, String status, int tenantId, String showtop, String lang, String offSet) throws Exception;

	public void insertScheduleRepeDel(String scheduleId, String startDate, int tenantId ,String companyID) throws Exception;

	public void deleteScheduleRepe(String scheduleId, int tenantId) throws Exception;

	public void updateDragSchedule(String scheduleid, String userId, String displayName1, String displayName2, String utcStartTime, String utcEndTime, int tenantId, String companyID, String datetype, String repetition, String title) throws Exception;

	public void copySchedule(String dragDay, String startDate, String endDate, String defaultPath, String offSetMin, int tenantId, String companyId, String lang, String offSet, String completeFG) throws Exception;

	public List<ScheGetHolidayVO> getTholidayYear(String companyID,String userCompany, int tenantId, String isRest, String holidayYear) throws Exception;

	public void scheduleSendMail(int scheduleId, String v_attendantId, String v_attendantName, String title, String periodContent, String type, LoginVO userInfo, String loginCookie, String startDate, String endDate) throws Exception;

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

	/* 2023-10-10 기민혁 - 사용자일정 검색시 스케쥴 list 호출 메서드 */
	public List<ScheduleInfoVO> getUserSearchScheduleList(String indiList, String pidList, String filter, String utcStartDate, String utcEndDate, String orgStartDate, String orgEndDate, String keyword, String offSetMin, String searchTitle, int tenantId, String companyID, String userID, String deptId, String useAnnualScheduleYN) throws Exception;
	
	public String checkExecutiveType(String userID, String companyID, int tenantID) throws Exception;

	public String checkExecutiveUsage(String userID, String companyID, int tenantID) throws Exception;

	/* 2023-09-22 한태훈 - 일정관리 > 초대 일정 참석 여부 반환 메서드 */
	public String selectAttendanceStatus(String scheduleid, String v_attendantId, int tenantId) throws Exception;
	
	// 2023-09-25 한태훈 - 일정관리 > 초대 일정 수정 시 메일 및 알림 발송 메서드
	public void sendInviteModNoti(HttpServletRequest request, String scheduleid, NodeList attendantId, NodeList attendantName, String location, String title, String importance, String ispublic, String startdate, String enddate, String datetype, String repetition, ScheduleInfoVO beforeSche, String repStartdate, String repeatCount, String isAllRep, String completeFG,  LoginVO userInfo, String loginCookie) throws Exception;
	
	// 2023-09-25 한태훈 - 일정관리 > 참석자 초대 일정 수정 알림 메일 전송시 변경 내용 양식 만들기
	public StringBuilder makeScheModMailForm(StringBuilder mailContent, String category, String beforeContent, String afterContent, Locale locale) throws Exception;
	
	// 2023-09-25 한태훈 - 일정관리 > 참석자 초대 일정 수정 알림 메일 전송시 중요도, 공개여부 컬럼 코드값 변경
	public String decodeColumnValue(String column, String originString, Locale locale) throws Exception;
	
	// 2023-09-25 한태훈 - 일정관리 > 참석자 초대 일정 수정 알림 메일 전송시 일정 기간 내용 만들기
	public String makeScheDateContent(String dateType, String repetition, String startDate, String endDate, Locale locale) throws Exception;

	// 2023-09-25 한태훈 - 일정관리 > 참석자 초대 일정 수정 알림 메일 전송 시 시간 내용 만들기
	public String makeScheTimeContent(String startdate, String enddate, String datetype, String repetition, Locale locale) throws Exception;
	
	// 2023-09-25 한태훈 - 일정관리 > 참석자 초대 일정 수정 알림 메일 전송 시 반복주기 내용 만들기
	public String makeRepetitionContent(String repetition, Locale locale) throws Exception;
	
	// 2023-09-25 한태훈 - 일정관리 > 참석자 초대 일정 수정 알림 메일 전송 시 완료 여부 내용 만들기
	public String makeCompleteContent(String dateType, String isAllRep, String completeFG, String repStartdate, Locale locale) throws Exception;
	
	// 2024-07-01 한태훈 - 일정관리 > 일정 삭제 메일 및 알림 전송
	public void sendInviteScheDelNoti(HttpServletRequest request, List<AttendantListVO> attendantList, ScheduleInfoVO scheduleInfo, String selectedDate, String repeatCount, LoginVO loginVO, String loginCookie) throws Exception;
	
	// 2023-10-17 한태훈 - 일정관리 > 모바일 초대 일정 참석 수락/거절 메일 및 알림 발송
	public void sendScheduleNotiForMobile(HttpServletRequest request, MCommonVO userInfo, String creatorId, String creatorName, String title, String periodContent, String type, String scheduleId, String stardDate, String endDate) throws Exception;
	 
	// 2023-10-17 한태훈 - 일정관리 > 모바일 초대 일정 수정 메일 및 알림 발송
	public void sendInviteModNotiForMoblie(HttpServletRequest request, String scheduleId, String ownerId, String ownerName, List<AttendantListVO> attendantList, String location, String title, String importance, String ispublic, String startdate, String enddate, String datetype, MScheduleInfoVO vo, MCommonVO info) throws Exception;
	
	// 2023-10-25 한태훈 - 일정관리 > 모바일 초대 일정 삭제 메일 및 알림 발송
	public void sendInviteScheDelNotiForMobile(HttpServletRequest request, List<AttendantListVO> attendantList, ScheduleInfoVO scheduleInfo, MCommonVO info) throws Exception;
	public Map<String, List<ScheduleReminderVO>> selectReminderScheList(String nowTimeStr, int tenantId) throws Exception;
	public void updateCompleteScheduleStatus(List<ScheduleReminderVO> reminderCompleteList, int tenantId) throws Exception;
	public void sendReminderMail(ScheduleReminderVO reminderSche) throws Exception;
	public ScheduleGroupListVO selectScheduleGroupInfo(String groupId, int tenantId) throws Exception;
	public void updateAllDaySTimeForReminder(String allDaySTimeForReminder, int tenantId) throws Exception;

	public void updateScheduleWritePermission(String groupId, List<Map<String, String>> memberList, int tenantId) throws Exception;
	// 2024-11-19 한태훈 - 일정관리 > 초대 일정 드래그로 수정 시 메일 및 알림 발송 메서드
	public void sendInviteModNotiForDrag(HttpServletRequest request, String dragId, ScheduleInfoVO beforeSche, String startDate, String endDate, LoginVO loginVO, String loginCookie) throws Exception;
	
	/* 2023-09-27 임정은 - 모아보기 그룹 관리 리스트 리턴하는 메서드 */
	public List<ScheduleGroupListVO> getMyGatherList(String userId, int tenantId ,String companyID) throws Exception;

	/* 2023-09-27 임정은 - 모아보기 그룹 관리 리스트별 멤버 수 리턴하는 메서드 */
	public int getMyGatherMemberCnt(String groupId, String lang, int tenantId ,String companyID) throws Exception;

	/* 2023-10-04 임정은 - 모아보기 그룹 추가 시 tbl_schedulegather에 insert하는 메서드 */
	public void insertScheduleGather(String gUID, String id, String displayName, String displayName2, String groupName, String description, int tenantId ,String companyID) throws Exception;

	/* 2023-10-04 임정은 - 모아보기 그룹 추가 시 tbl_schedulegathermember에 insert하는 메서드 / 모아보기 그룹 관리 > 그룹 관리 버튼 > 구성원 추가/편집 버튼 > 구성원 추가 */
	public void insertScheduleGatherMember(String groupId, String memberId, String memberName, String memberName2, String memberDeptId, int tenantId) throws Exception;

	/* 2023-10-04 임정은 - 모아보기 그룹 관리 > 그룹 선택 시 상세 정보 리턴하는 메소드 */
	public List<ScheduleGroupListVO> getMyGatherMemberList(String groupId, String lang, int tenantId ,String companyID) throws Exception;

	/* 2023-10-04 임정은 - 모아보기 그룹 관리 > 그룹 선택 후 삭제 버튼 */
	public void deleteScheduleGather(String groupId, int tenantId, String memberId) throws Exception;

	/* 2023-10-04 임정은 - 모아보기 그룹 관리 > 그룹 관리 버튼 */
	public List<ScheduleGroupListVO> getGatherMemberList(String groupId, String lang, int tenantId, String offSetMin, String companyID) throws Exception;

	/* 2023-10-05 임정은 - 모아보기 그룹 관리 > 그룹 관리 버튼 > 그룹명, 설명 수정 후 저장 버튼 */
	public void updateScheduleGather(String groupId,String id, String groupName, String description, int tenantId) throws Exception;

	// 권기혁 - 일정보기 상태값 저장(월, 주, 일 보기)
	public void setScheduleViewStatus(String userId, int tenantId, String status) throws Exception;
	
	// 권기혁 - 일정 환경설정 입력
	public void insertScheduleConfig(String userID, String defaultView, String startDay, String startTime,
			String endTime, String autoDelete, int tenantID, String reminderTime, String defaultViewCheckBox, List<ScheduleTypeConfigVO> tagColors) throws Exception;

	public List<ScheduleTypeConfigVO> getUserScheduleTypeConfig(String userID, String companyID, int tenantID) throws Exception;
	
	// 2025-04-23 조수빈 - 개인의 일정 항목별 체크 여부 저장 메소드
	public String saveIsTagChecked(String userID, String scheduleType, String relatedID, String isChecked, int tenantID, String companyID);

	public String getUserScheduleTypeColor(String userId, String companyId, int tenantId, String scheduleType, String relatedId);
	
	public List<ScheSecretaryVO> getPublicExceSchedule(Map<String, Object> param) throws Exception;
	public List<ScheDeptVO> getShareScheduleDept(Map<String, Object> param) throws Exception;
	public List<ScheDeptVO> getAddJobSchedule(Map<String, Object> param) throws Exception;
}
