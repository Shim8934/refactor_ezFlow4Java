package egovframework.ezMobile.ezSchedule.dao;

import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezSchedule.vo.ScheduleInfoVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("MScheduleDAO")
public class MScheduleDAO extends EgovAbstractDAO {

	public String scheduleContentPath(Map<String, Object> map) throws Exception{		
		return (String) select("MScheduleDAO.scheduleContentPath", map);
	}

	public ScheduleInfoVO scheduleInfo(Map<String, Object> map) throws Exception{
		return (ScheduleInfoVO) select("MScheduleDAO.scheduleInfo", map);
	}
}

