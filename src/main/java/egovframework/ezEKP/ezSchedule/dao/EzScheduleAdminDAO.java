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

}

