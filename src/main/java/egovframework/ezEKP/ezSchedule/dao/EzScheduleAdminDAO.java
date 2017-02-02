package egovframework.ezEKP.ezSchedule.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezSchedule.vo.ScheduleShareVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzScheduleAdminDAO")
public class EzScheduleAdminDAO extends EgovAbstractDAO {

	@SuppressWarnings("unchecked")
	public List<ScheduleShareVO> scheduleGetShareManage(Map<String, Object> map) throws Exception {
		return (List<ScheduleShareVO>) list("EzScheduleAdminDAO.scheduleGetShareManage", map);
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

	public void scheduleSaveHoliday(Map<String, Object> map) throws Exception {
		insert("EzScheduleAdminDAO.scheduleSaveHoliday", map);
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

}

