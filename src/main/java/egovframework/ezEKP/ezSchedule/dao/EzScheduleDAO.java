package egovframework.ezEKP.ezSchedule.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.ezEKP.ezResource.vo.ResGetScheduleVO;
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
import egovframework.let.user.login.vo.LoginVO;
import org.egovframe.rte.psl.dataaccess.EgovAbstractDAO;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import javax.annotation.Resource;

@Repository("EzScheduleDAO")
public class EzScheduleDAO extends EgovAbstractDAO {

	@Resource(name="EzCommonService")
	private EzCommonService ezCommonService;

	@SuppressWarnings("unchecked")
	public List<ScheGetHolidayVO> getTholiday(Map<String, Object> map){
		return  (List<ScheGetHolidayVO>) list("EzScheduleDAO.getTholiday", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ScheGetHolidayVO> getTholidayYear(Map<String, Object> map){
		return  (List<ScheGetHolidayVO>) list("EzScheduleDAO.getTholidayYear", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ScheduleGroupListVO> getScheduleGroupList(Map<String, Object> map) throws Exception {
		return (List<ScheduleGroupListVO>) list("EzScheduleDAO.getScheduleGroupList", map);
	}

	@SuppressWarnings("unchecked")
	public List<ScheduleInfoVO> getScheduleList(Map<String, Object> map) throws Exception  {
		// 임원일정 조회가능범위 설정여부
		String useExecSchedulePublic = ezCommonService.getTenantConfig("useExecSchedulePublic", (Integer) map.get("v_TENANTID"));
		map.put("useExecSchedulePublic", useExecSchedulePublic);

		return (List<ScheduleInfoVO>) list("EzScheduleDAO.getScheduleList", map);
	}
	
	@SuppressWarnings("unchecked")	
	public List<String> getScheduleRepeDelList(Map<String, Object> map) throws Exception {
		return (List<String>) list("EzScheduleDAO.getScheduleRepeDelList", map);
	}

	@SuppressWarnings("unchecked")
	public List<ScheduleGroupVO> getMyGroupList(Map<String, Object> map) throws Exception {
		return (List<ScheduleGroupVO>) list("EzScheduleDAO.getMyGroupList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ScheduleGroupListVO> getMyGroupMemberList(Map<String, Object> map) throws Exception {
		return (List<ScheduleGroupListVO>) list("EzScheduleDAO.getMyGroupMemberList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<AttendantListVO> getAttendantList(Map<String, Object> map){
		return (List<AttendantListVO>) list("EzScheduleDAO.getAttendantList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<AttachListVO> getAttachList(Map<String, Object> map){
		return (List<AttachListVO>) list("EzScheduleDAO.getAttachList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ScheduleSecretaryVO> getPublicScheduleSec(Map<String, Object> map){
		return (List<ScheduleSecretaryVO>) list("EzScheduleDAO.getPublicScheduleSec", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ScheduleDeptVO> getPublicScheduleDept(Map<String, Object> map){
		return (List<ScheduleDeptVO>) list("EzScheduleDAO.getPublicScheduleDept", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ScheduleCumulerVO> getPublicScheduleCumuler(Map<String, Object> map){
		return (List<ScheduleCumulerVO>) list("EzScheduleDAO.getPublicScheduleCumuler", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ScheduleGroupListVO> getGroupMemberList(Map<String, Object> map) throws Exception {
		return (List<ScheduleGroupListVO>) list("EzScheduleDAO.getGroupMemberList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<OrganUserVO> getDeptMemberList(Map<String, Object> map) throws Exception {
		return (List<OrganUserVO>) list("EzScheduleDAO.getDeptMemberList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ScheduleSecretaryVO> getSecretaryList(Map<String, Object> map) throws Exception {
		return (List<ScheduleSecretaryVO>) list("EzScheduleDAO.getSecretaryList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ScheduleReceiveListVO> getReceiveList(Map<String, Object> map) throws Exception {
		return (List<ScheduleReceiveListVO>) list("EzScheduleDAO.getReceiveList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ScheduleGroupListVO> getInviteScheduleGroupList(Map<String, Object> map) throws Exception {
		return (List<ScheduleGroupListVO>) list("EzScheduleDAO.getInviteScheduleGroupList", map);		
	}
	
	@SuppressWarnings("unchecked")
	public List<ResGetScheduleVO> getResourceSchedule(Map<String, Object> map) throws Exception {
		return (List<ResGetScheduleVO>) list("EzScheduleDAO.getResourceSchedule", map);		
	}
	
	public ScheduleConfigVO getScheduleConfig(Map<String, Object> map){
		return (ScheduleConfigVO) select("EzScheduleDAO.getScheduleConfig", map);
	}
	
	public ScheduleMailConfigVO getScheduleMailNotiConfig(Map<String, Object> map){
		return (ScheduleMailConfigVO) select("EzScheduleDAO.getScheduleMailNotiConfig", map);
	}
	
	public ScheduleInfoVO getScheduleInfo(Map<String, Object> map){
		return (ScheduleInfoVO) select("EzScheduleDAO.getScheduleInfo", map);
	}

	public ScheduleGroupVO selectCreatorMember(Map<String, Object> map){
		return (ScheduleGroupVO) select("EzScheduleDAO.selectCreatorMember", map);
	}

	public String scheduleGetLunarUse(Map<String, Object> map) throws Exception {
		return (String) select("EzScheduleDAO.scheduleGetLunarUse", map);
	}

	public String scheduleGetRegi(Map<String, Object> map) throws Exception {
		return (String) select("EzScheduleDAO.scheduleGetRegi", map);
	}
	
	public String getCumDeptId(Map<String, Object> map) throws Exception {
		return (String) select("EzScheduleDAO.getCumDeptId", map);
	}
	
	public String getUserScheduleConfig(Map<String, Object> map) throws Exception {
		return (String) select("EzScheduleDAO.getUserScheduleConfig", map);
	}

	public int getCurScheduleId(Map<String, Object> map) {
		return (int) select("EzScheduleDAO.getCurScheduleId", map);		
	}

	public int getReceiveCount(Map<String, Object> map) {
		return (int) select("EzScheduleDAO.getReceiveCount", map);		
	}

	public int getInviteScheduleGroupCnt(Map<String, Object> map) {
		return (int) select("EzScheduleDAO.getInviteScheduleGroupCnt", map);		
	}
	
	public int getMyGroupMemberListCnt(Map<String, Object> map) throws Exception {
		return (int) select("EzScheduleDAO.getMyGroupMemberListCnt", map);
	}
	
	public int getResourceCount(Map<String, Object> map) throws Exception {
		return (int) select("EzScheduleDAO.getResourceCount", map);
	}
	
	public int getAttendantCount(Map<String, Object> map) throws Exception {
		return (int) select("EzScheduleDAO.getAttendantCount", map);
	}
		
	public void scheduleNewItem(ScheduleInfoVO scheduleInfoVO) throws Exception{
		insert("EzScheduleDAO.scheduleNewItem", scheduleInfoVO);
	}	
	
	public void deleteScheduleGroup(Map<String, Object> map) throws Exception {
		delete("EzScheduleDAO.deleteScheduleGroup", map);
	}

	public void deleteScheduleGroupMember(Map<String, Object> map) throws Exception {
		delete("EzScheduleDAO.deleteScheduleGroupMember", map);
	}

	public void deleteScheduleMember(Map<String, Object> map) throws Exception {
		delete("EzScheduleDAO.deleteScheduleMember", map);
	}

	public void updateManageScheduleMember(Map<String, Object> map) throws Exception {
		update("EzScheduleDAO.updateManageScheduleMember", map);
	}

	public void updateManageScheduleGroupMember(Map<String, Object> map) throws Exception {
		update("EzScheduleDAO.updateManageScheduleGroupMember", map);
	}

	public void updateScheduleMember(Map<String, Object> map) throws Exception {
		update("EzScheduleDAO.updateScheduleMember", map);
	}

	public void insertScheduleGroupMember(Map<String, Object> map) throws Exception {
		insert("EzScheduleDAO.insertScheduleGroupMember", map);
	}

	public void insertScheduleGroup(Map<String, Object> map) throws Exception {
		insert("EzScheduleDAO.insertScheduleGroup", map);
	}
	

	public void updateScheduleGroup(Map<String, Object> map) throws Exception {
		insert("EzScheduleDAO.updateScheduleGroup", map);
	}

	
	public void deleteScheduleConfig(Map<String, Object> map) throws Exception {
		delete("EzScheduleDAO.deleteScheduleConfig", map);
	}

	public void deleteSecretary(Map<String, Object> map) throws Exception {
		delete("EzScheduleDAO.deleteSecretary", map);
	}

	public void insertScheduleConfig(Map<String, Object> map) throws Exception {
		insert("EzScheduleDAO.insertScheduleConfig", map);
	}

	public void insertSecretary(Map<String, Object> map) throws Exception {
		insert("EzScheduleDAO.insertSecretary", map);
	}

	public void insertSchedule(Map<String, Object> map) throws Exception {
		insert("EzScheduleDAO.insertSchedule", map);
	}

	public void insertScheduleAttach(Map<String, Object> map) throws Exception {
		insert("EzScheduleDAO.insertScheduleAttach", map);
	}

	public void insertScheduleAttendant(Map<String, Object> map) throws Exception {
		insert("EzScheduleDAO.insertScheduleAttendant", map);
	}

	public void deleteScheduleAttach(Map<String, Object> map) throws Exception {
		delete("EzScheduleDAO.deleteScheduleAttach", map);
	}

	public void deleteAttendant(Map<String, Object> map) throws Exception {
		delete("EzScheduleDAO.deleteAttendant", map);
	}

	public void deleteSchedule(Map<String, Object> map) throws Exception {
		delete("EzScheduleDAO.deleteSchedule", map);
	}

	public void deleteResource(Map<String, Object> map) throws Exception {
		delete("EzScheduleDAO.deleteResource", map);
	}

	public void deleteAttendantID(Map<String, Object> map) throws Exception {
		delete("EzScheduleDAO.deleteAttendantID", map);
	}
	
	public void deleteAttendantSchedule(Map<String, Object> map) throws Exception {
		delete("EzScheduleDAO.deleteAttendantSchedule", map);
	}	

	public void updateAttendantSchedule(Map<String, Object> map) throws Exception {
		update("EzScheduleDAO.updateAttendantSchedule", map);
	}

	public void updateAttendantStatus(Map<String, Object> map) throws Exception {
		update("EzScheduleDAO.updateAttendantStatus", map);
	}

	public void insertAttendantSchedule(Map<String, Object> map) throws Exception {
		insert("EzScheduleDAO.insertAttendantSchedule", map);		
	}
	
	public void insertAttendantScheduleDel(Map<String, Object> map) throws Exception {
		insert("EzScheduleDAO.insertAttendantScheduleDel", map);		
	}

	public void updateSchedule(Map<String, Object> map) throws Exception {
		update("EzScheduleDAO.updateSchedule", map);
	}

	public void insertScheduleRepeDel(Map<String, Object> map) throws Exception {
		insert("EzScheduleDAO.insertScheduleRepeDel", map);
	}
	
	public void insertScheduleRepeDelChild(Map<String, Object> map) throws Exception {
		insert("EzScheduleDAO.insertScheduleRepeDelChild", map);
	}

	public void deleteScheduleRepe(Map<String, Object> map) throws Exception {
		delete("EzScheduleDAO.deleteScheduleRepe", map);
	}
	
	public void deleteScheduleRepeChild(Map<String, Object> map) throws Exception {
		delete("EzScheduleDAO.deleteScheduleRepeChild", map);
	}

	public void updateDragSchedule(Map<String, Object> map) throws Exception {
		update("EzScheduleDAO.updateDragSchedule", map);
	}
	
	public void modifyScheduleConfig(Map<String, Object> map) throws Exception {
		update("EzScheduleDAO.modifyScheduleConfig", map);
	}
	
	public void setScheduleMailNotiConfig(Map<String, Object> map) throws Exception {
		update("EzScheduleDAO.setScheduleMailNotiConfig", map);
	}

	/* 2021-11-25 홍승비 - 일정완료 레코드가 존재하는지 카운트를 반환하는 쿼리 */
	public int getScheduleCompleteCnt(Map<String, Object> map) throws Exception {
		return (int) select("EzScheduleDAO.getScheduleCompleteCnt", map);
	}
	/* 2021-11-25 홍승비 - 일정완료 레코드 신규 삽입 쿼리 */
	public void insertScheduleComplete(Map<String, Object> map) throws Exception {
		insert("EzScheduleDAO.insertScheduleComplete", map);
	}
	/* 2021-11-25 홍승비 - 일정완료 레코드의 전체 반복일정 칼럼 리턴 쿼리 */
	@SuppressWarnings("unchecked")
	public List<String> getScheduleCompleteIsAllRep(Map<String, Object> map) throws Exception {
		return (List<String>) list("EzScheduleDAO.getScheduleCompleteIsAllRep", map);
	}
	/* 2021-11-25 홍승비 - 특정(단일) 일정 또는 전체 일정 삭제 조건이 분기처리된 삭제 쿼리 */
	public void deleteScheduleComplete(Map<String, Object> map) throws Exception {
		delete("EzScheduleDAO.deleteScheduleComplete", map);
	}
	/* 2021-11-25 홍승비 - SCHEDULEID, TENANT_ID, COMPANYID가 일치하는 일정완료 레코드 중에서 현재 삽입한 레코드 이외의 레코드를 모두 삭제 */
	public void deleteScheduleCompleteDiffCurr(Map<String, Object> map) throws Exception {
		delete("EzScheduleDAO.deleteScheduleCompleteDiffCurr", map);
	}
	/* 2021-11-29 홍승비 - 참석자 초대 수락 시, 부모 일정의 일정완료 레코드도 동일하게 삽입 */
	public void insertAttendantScheduleComplete(Map<String, Object> map) throws Exception {
		insert("EzScheduleDAO.insertAttendantScheduleComplete", map);
	}
	
	public ScheduleTokenInfoVO getScheduleTokenInfo(Map<String, Object> map) throws Exception {
		return (ScheduleTokenInfoVO) select("EzScheduleDAO.getScheduleTokenInfo", map);
	}
	
	public void insertScheduleTokenInfo(Map<String, Object> map) throws Exception {
		insert("EzScheduleDAO.insertScheduleTokenInfo", map);
	}
	
	public void updateScheduleTokenInfo(Map<String, Object> map) throws Exception {
		update("EzScheduleDAO.updateScheduleTokenInfo", map);
	}
	
	public String getIsSync(LoginVO userInfo) throws Exception {
		String token = (String) select("EzScheduleDAO.getIsSync", userInfo); 
		return (token != null && !token.equals("")) ? "Y" : "N";
	}
	
	@SuppressWarnings("unchecked")
	public List<ScheduleTokenInfoVO> getAllGoogleToken(Map<String, Object> map) throws Exception {
		return (List<ScheduleTokenInfoVO>) list("EzScheduleDAO.getAllGoogleToken", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ScheduleTokenInfoVO> getExpiredGoogleToken(Map<String, Object> map) throws Exception {
		return (List<ScheduleTokenInfoVO>) list("EzScheduleDAO.getExpiredGoogleToken", map);
	}
	
	public void updateGoogleTokenInfo(Map<String, Object> map) throws Exception {
		update("EzScheduleDAO.updateGoogleTokenInfo", map);
	}

	@SuppressWarnings("unchecked")
	public List<ScheduleInfoVO> getUserSearchScheduleList(Map<String, Object> map) throws Exception  {
		return (List<ScheduleInfoVO>) list("EzScheduleDAO.getUserSearchScheduleList", map);
	}
	
	public String selectAttendanceStatus(Map<String, Object> map) throws Exception {
		return (String) select("EzScheduleDAO.selectAttendanceStatus", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ScheduleReminderVO> selectNoRepeatRemindScheList(Map<String, Object> map) throws Exception {
		return (List<ScheduleReminderVO>) list("EzScheduleDAO.selectNoRepeatRemindScheList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ScheduleReminderVO> selectRepeatRemindScheList(Map<String, Object> map) throws Exception {
		return (List<ScheduleReminderVO>) list("EzScheduleDAO.selectRepeatRemindScheList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ScheduleReminderVO> selectRepeatDelScheList(Map<String, Object> map) throws Exception {
		return (List<ScheduleReminderVO>) list("EzScheduleDAO.selectRepeatDelScheList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ScheduleReminderVO> selectRepeatCompletScheList(Map<String, Object> map) throws Exception {
		return (List<ScheduleReminderVO>) list("EzScheduleDAO.selectRepeatCompletScheList", map);
	}
	
	public void updateReminderStatus(Map<String, Object> map) throws Exception {
		update("EzScheduleDAO.updateReminderStatus", map);
	}

	public void insertReminderSchedule(Map<String, Object> map) throws Exception {
		insert("EzScheduleDAO.insertReminderSchedule", map);
	}

	public void deleteReminderSchedule(Map<String, Object> map) throws Exception {
		delete("EzScheduleDAO.deleteReminderSchedule", map);
	}
	
	// 일정관리 > 반복일정이 아닌 일정을 드래그로 이동시 완료일정인 경우, 시간 정보를 바꿔줘야한다.
	public void updateScheduleComplete(Map<String, Object> map) throws Exception {
		update("EzScheduleDAO.updateScheduleComplete", map);
	}

	public void insertAttendantReminderSchedule(Map<String, Object> map) throws Exception {
		insert("EzScheduleDAO.insertAttendantReminderSchedule", map);
	}

	public void updateReminderSchedule(Map<String, Object> map) throws Exception {
		update("EzScheduleDAO.updateReminderSchedule", map);
	}
	
	public ScheduleGroupListVO selectScheduleGroupInfo(Map<String, Object> map) throws Exception {
		return (ScheduleGroupListVO) select("EzScheduleDAO.selectScheduleGroupInfo", map);
	}
	
	// 2023-10-27 한태훈 - 일정관리 > 참석 일정에서 제외된 참석자의 경우 미리알림 스케줄러 테이블에서 제외해야한다.
	public void deleteAttendantReminderSchedule(Map<String, Object> map) throws Exception {
		delete("EzScheduleDAO.deleteAttendantReminderSchedule", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ScheduleReminderVO> selectExpiredSchedule(Map<String, Object> map) throws Exception {
		return (List<ScheduleReminderVO>) list("EzScheduleDAO.selectExpiredSchedule", map);
	}
	
	public void updateWritePermission(Map<String, Object> map) throws Exception {
		update("EzScheduleDAO.updateWritePermission", map);
	}
	
	public String checkExecutiveType(Map<String, Object> map) throws Exception {
		return (String) select("EzScheduleDAO.checkExecutiveType", map);
	}

	public String checkExecutiveUsage(Map<String, Object> map) throws Exception {
		return (String) select("EzScheduleDAO.checkExecutiveUsage", map);
	}

	/* 2023-09-27 임정은 - 모아보기 그룹 관리 리스트 리턴하는 메서드 */
	@SuppressWarnings("unchecked")
	public List<ScheduleGroupListVO> getMyGatherList(Map<String, Object> map) throws Exception {
		return (List<ScheduleGroupListVO>) list("EzScheduleDAO.getMyGatherList", map);
	}

	/* 2023-09-27 임정은 - 모아보기 그룹 관리 리스트별 멤버 수 리턴하는 메서드 */
	public int getMyGatherMemberCnt(Map<String, Object> map) throws Exception {
		return (int) select("EzScheduleDAO.getMyGatherMemberListCnt", map);
	}

	/* 2023-10-04 임정은 - 모아보기 그룹 추가 시 tbl_schedulegather에 insert하는 메서드 */
	public void insertScheduleGather(Map<String, Object> map) throws Exception {
		insert("EzScheduleDAO.insertScheduleGather", map);
	}

	/* 2023-10-04 임정은 - 모아보기 그룹 추가 시 tbl_schedulegathermember에 insert하는 메서드 / 모아보기 그룹 관리 > 그룹 관리 버튼 > 구성원 추가/편집 버튼 > 구성원 추가 */
	public void insertScheduleGatherMember(Map<String, Object> map) throws Exception {
		insert("EzScheduleDAO.insertScheduleGatherMember", map);
	}

	/* 2023-10-04 임정은 - 모아보기 그룹 관리 > 그룹 선택 시 상세 정보 리턴하는 메소드 */
	@SuppressWarnings("unchecked")
	public List<ScheduleGroupListVO> getMyGatherMemberList(Map<String, Object> map) throws Exception {
		return (List<ScheduleGroupListVO>) list("EzScheduleDAO.getMyGatherMemberList", map);
	}

	/* 2023-10-04 임정은 - 모아보기 그룹 관리 > 그룹 선택 후 삭제 버튼 > tbl_schedulegather에 delete하는 메서드 */
	public void deleteScheduleGather(Map<String, Object> map) throws Exception {
		delete("EzScheduleDAO.deleteScheduleGather", map);
	}

	/* 2023-10-04 임정은 - 모아보기 그룹 관리 > 그룹 선택 후 삭제 버튼 > tbl_schedulegathermember에 delete하는 메서드 / 모아보기 그룹 관리 > 그룹 관리 버튼 > 구성원 추가/편집 버튼 > 구성원 삭제 */
	public void deleteScheduleGatherMember(Map<String, Object> map) throws Exception {
		delete("EzScheduleDAO.deleteScheduleGatherMember", map);
	}

	/* 2023-10-04 임정은 - 모아보기 그룹 관리 > 그룹 관리 버튼 */
	@SuppressWarnings("unchecked")
	public List<ScheduleGroupListVO> getGatherMemberList(Map<String, Object> map) throws Exception {
		return (List<ScheduleGroupListVO>) list("EzScheduleDAO.getGatherMemberList", map);
	}

	/* 2023-10-05 임정은 - 모아보기 그룹 관리 > 그룹 관리 버튼 > 그룹명, 설명 수정 후 저장 버튼 */
	public void updateScheduleGather(Map<String, Object> map) throws Exception {
		insert("EzScheduleDAO.updateScheduleGather", map);
	}
	
	public ScheduleGroupListVO selectScheduleGatherMember(Map<String, Object> map) throws Exception {
		return (ScheduleGroupListVO) select("EzScheduleDAO.selectScheduleGatherMember", map);
	}

	public void updateScheduleGatherMember(Map<String, Object> map) throws Exception {
		update("EzScheduleDAO.updateScheduleGatherMember", map);
	}

	public ScheduleGroupListVO selectScheduleGroupMember(Map<String, Object> map) throws Exception {
		return (ScheduleGroupListVO) select("EzScheduleDAO.selectScheduleGroupMember", map);
	}

	public void updateScheduleGroupMember(Map<String, Object> map) throws Exception {
		update("EzScheduleDAO.updateScheduleGroupMember", map);
	}

	
	@SuppressWarnings("unchecked")
	public List<ScheSecretaryVO> getPublicExceSchedule(Map<String, Object> param) {
		return (List<ScheSecretaryVO>) list("EzScheduleDAO.getPublicExceSchedule", param);
	}
	
	public void setScheduleViewStatus(Map<String, Object> map) {
		insert("EzScheduleDAO.setScheduleViewStatus", map);		
	}

	@SuppressWarnings("unchecked")
	public List<ScheduleTypeConfigVO> getUserScheduleTypeConfig(Map<String, Object> param) throws Exception {
		return (List<ScheduleTypeConfigVO>) list("EzScheduleDAO.getUserscheduleTypeConfig", param);
	}

	public void saveIsTagChecked(Map<String, Object> param) {
		update("EzScheduleDAO.saveIsTagChecked", param);
	}
	public void upsertUserScheTagColor(ScheduleTypeConfigVO vo) {
		update("EzScheduleDAO.upsertUserScheTagColor", vo);
	}

	public String getUserScheduleTypeColor(Map<String, Object> param) {
		return (String) select("EzScheduleDAO.getUserScheduleTypeColor", param);
	}

	@SuppressWarnings("unchecked")
	public List<ScheDeptVO> getShareScheduleDept(Map<String, Object> param) {
		return (List<ScheDeptVO>) list("EzScheduleDAO.getShareScheduleDept", param);
	}

	@SuppressWarnings("unchecked")
	public List<ScheDeptVO> getAddJobSchedule(Map<String, Object> param) {
		return (List<ScheDeptVO>) list("EzScheduleDAO.getAddJobSchedule", param);
	}
}