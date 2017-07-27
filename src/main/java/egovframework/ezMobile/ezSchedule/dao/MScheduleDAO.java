package egovframework.ezMobile.ezSchedule.dao;

import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezMobile.ezSchedule.vo.MScheduleInfoVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("MScheduleDAO")
public class MScheduleDAO extends EgovAbstractDAO {

	public MScheduleInfoVO scheduleInfo(Map<String, Object> map) throws Exception{
		// TODO Auto-generated method stub
		return (MScheduleInfoVO) select("MScheduleDAO.scheduleInfo", map);
	}
}

