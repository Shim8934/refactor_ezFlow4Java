package egovframework.ezEKP.ezSchedule.service;

import java.util.List;

import egovframework.ezEKP.ezSchedule.vo.ScheGetHolidayVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleConfigVO;


public interface EzScheduleService {
	List<ScheGetHolidayVO> getTholiday (String companyID, String userCompany) throws Exception;
	ScheduleConfigVO getScheduleConfig(String userId) throws Exception;
}
