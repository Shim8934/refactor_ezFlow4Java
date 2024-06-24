package egovframework.ezEKP.ezSchedule.dao;

import java.util.List;
import java.util.Map;

import egovframework.ezEKP.ezSchedule.vo.ScheduleExecutiveVO;
import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezSchedule.vo.ScheduleGroupListVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleGroupVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleShareVO;
import org.egovframe.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzScheduleAdminDAO")
public class EzScheduleAdminDAO extends EgovAbstractDAO {

	@SuppressWarnings("unchecked")
	public List<ScheduleShareVO> scheduleGetShareManage(Map<String, Object> map) throws Exception {
		return (List<ScheduleShareVO>) list("EzScheduleAdminDAO.scheduleGetShareManage", map);
	}


	@SuppressWarnings("unchecked")
	public List<ScheduleGroupListVO> getMyGroupList(Map<String, Object> map) throws Exception {
		return (List<ScheduleGroupListVO>) list("EzScheduleAdminDAO.getMyGroupList", map);
	}	

	@SuppressWarnings("unchecked")
	public List<ScheduleGroupVO> getMyGroupList2(Map<String, Object> map) throws Exception {
		return (List<ScheduleGroupVO>) list("EzScheduleAdminDAO.getMyGroupList2", map);
	}	

	public int getMyGroupMemberListCnt(Map<String, Object> map) throws Exception {
		return (int) select("EzScheduleAdminDAO.getMyGroupMemberListCnt", map);
	}
	public void scheduleDelShareDept(Map<String, Object> map) throws Exception {
		delete("EzScheduleAdminDAO.scheduleDelShareDept", map);
	}

	public void scheduleSaveShareDept(Map<String, Object> map) throws Exception {
		insert("EzScheduleAdminDAO.scheduleSaveShareDept", map);
	}

	public void scheduleDelHoliday(Map<String, Object> map) throws Exception {
		delete("EzScheduleAdminDAO.scheduleDelHoliday", map);
	}

	public void scheduleChangeHolidayUse(Map<String, Object> map) throws Exception {
		update("EzScheduleAdminDAO.scheduleChangeHolidayUse", map);
	}

	public String scheduleSaveHoliday(Map<String, Object> map) throws Exception {
		return (String) insert("EzScheduleAdminDAO.scheduleSaveHoliday", map);
	}

	public void scheduleUpdateHoliday(Map<String, Object> map) throws Exception {
		update("EzScheduleAdminDAO.scheduleUpdateHoliday", map);
	}

	public void scheduleInsertLunarUse(Map<String, Object> map) throws Exception {
		insert("EzScheduleAdminDAO.scheduleInsertLunarUse", map);
	}

	public void scheduleUpdateLunarUse(Map<String, Object> map) throws Exception {
		update("EzScheduleAdminDAO.scheduleUpdateLunarUse", map);
	}

	public void scheduleInsertRegi(Map<String, Object> map) throws Exception {
		insert("EzScheduleAdminDAO.scheduleInsertRegi", map);		
	}

	public void scheduleUpdateRegi(Map<String, Object> map) throws Exception {
		update("EzScheduleAdminDAO.scheduleUpdateRegi", map);		
	}

	public int scheduleShareCheck(Map<String, Object> map) throws Exception {
		return (int) select("EzScheduleAdminDAO.scheduleShareCheck", map);		
	}

	public List<ScheduleExecutiveVO> scheduleGetExecutiveList(Map<String, Object> map) throws Exception {
		return (List<ScheduleExecutiveVO>) list("EzScheduleAdminDAO.scheduleGetExecutiveList", map);
	}

	public void scheduleSaveExecutive(Map<String, Object> map) throws Exception {
		insert("EzScheduleAdminDAO.scheduleSaveExecutive", map);
	}

	public void scheduleUpdateExecutive(Map<String, Object> map) throws Exception {
		update("EzScheduleAdminDAO.scheduleUpdateExecutive", map);
	}

	public void scheduleDelExecutive(Map<String, Object> map) throws Exception {
		delete("EzScheduleAdminDAO.scheduleDelExecutive", map);
	}
}

