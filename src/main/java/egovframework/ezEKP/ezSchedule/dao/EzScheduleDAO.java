package egovframework.ezEKP.ezSchedule.dao;



import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezSchedule.vo.ScheGetHolidayVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleConfigVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzScheduleDAO")
public class EzScheduleDAO extends EgovAbstractDAO {
	
	@SuppressWarnings("unchecked")
	public List<ScheGetHolidayVO> getTholiday(Map<String, Object> map){
		return  (List<ScheGetHolidayVO>) list("EzScheduleDAO.getTholiday", map);
	}
	
	@SuppressWarnings("unchecked")
	public ScheduleConfigVO getScheduleConfig(Map<String, Object> map){
		return (ScheduleConfigVO) select("EzScheduleDAO.getScheduleConfig", map);
	}
}

