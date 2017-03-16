package egovframework.ezEKP.ezSchedule.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.ezEKP.ezResource.vo.ResGetScheduleVO;
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
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzScheduleDAO")
public class EzScheduleDAO extends EgovAbstractDAO {
	
	@SuppressWarnings("unchecked")
	public List<ScheGetHolidayVO> getTholiday(Map<String, Object> map){
		return  (List<ScheGetHolidayVO>) list("EzScheduleDAO.getTholiday", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ScheduleGroupListVO> getScheduleGroupList(Map<String, Object> map) throws Exception {
		return (List<ScheduleGroupListVO>) list("EzScheduleDAO.getScheduleGroupList", map);
	}

	@SuppressWarnings("unchecked")
	public List<ScheduleInfoVO> getScheduleList(Map<String, Object> map) throws Exception  {
		return (List<ScheduleInfoVO>) list("EzScheduleDAO.getScheduleList", map);
	}
	
	@SuppressWarnings("unchecked")	
	public List<String> getScheduleRepeDelList(Map<String, Object> map) throws Exception {
		return (List<String>) list("EzScheduleDAO.getScheduleRepeDelList", map);
	}

	@SuppressWarnings("unchecked")
	public List<ScheduleGroupListVO> getMyGroupList(Map<String, Object> map) throws Exception {
		return (List<ScheduleGroupListVO>) list("EzScheduleDAO.getMyGroupList", map);
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
	
	public ScheduleInfoVO getScheduleInfo(Map<String, Object> map){
		return (ScheduleInfoVO) select("EzScheduleDAO.getScheduleInfo", map);
	}
	
	public String scheduleGetLunarUse(Map<String, Object> map) throws Exception {
		return (String) select("EzScheduleDAO.scheduleGetLunarUse", map);
	}

	public String scheduleGetRegi(Map<String, Object> map) throws Exception {
		return (String) select("EzScheduleDAO.scheduleGetRegi", map);
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

	public void updateScheduleMember(Map<String, Object> map) throws Exception {
		update("EzScheduleDAO.updateScheduleMember", map);
	}

	public void insertScheduleGroupMember(Map<String, Object> map) throws Exception {
		insert("EzScheduleDAO.insertScheduleGroupMember", map);
	}

	public void insertScheduleGroup(Map<String, Object> map) throws Exception {
		insert("EzScheduleDAO.insertScheduleGroup", map);
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

	public void updateSchedule(Map<String, Object> map) throws Exception {
		update("EzScheduleDAO.updateSchedule", map);
	}

	public void insertScheduleRepeDel(Map<String, Object> map) throws Exception {
		insert("EzScheduleDAO.insertScheduleRepeDel", map);
	}

	public void deleteScheduleRepe(Map<String, Object> map) throws Exception {
		delete("EzScheduleDAO.deleteScheduleRepe", map);
	}

}

