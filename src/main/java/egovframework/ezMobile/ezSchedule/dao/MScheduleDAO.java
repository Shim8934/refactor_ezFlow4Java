package egovframework.ezMobile.ezSchedule.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezMobile.ezResource.vo.ResScheGetHolidayVO;
import egovframework.ezMobile.ezSchedule.vo.MScheduleInfoVO;
import org.egovframe.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("MScheduleDAO")
public class MScheduleDAO extends EgovAbstractDAO {

	public String scheduleContentPath(Map<String, Object> map) throws Exception{		
		return (String) select("MScheduleDAO.scheduleContentPath", map);
	}

	public MScheduleInfoVO scheduleInfo(Map<String, Object> map) throws Exception{
		return (MScheduleInfoVO) select("MScheduleDAO.scheduleInfo", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ResScheGetHolidayVO> getTholiday(Map<String, Object> map){
		return  (List<ResScheGetHolidayVO>) list("MScheduleDAO.getTholiday", map);
	}
}

