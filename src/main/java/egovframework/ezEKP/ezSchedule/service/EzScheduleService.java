package egovframework.ezEKP.ezSchedule.service;

import java.util.List;

import egovframework.ezEKP.ezSchedule.vo.ScheGetHolidayVO;


public interface EzScheduleService {
	List<ScheGetHolidayVO> getTholiday (String companyID, String userCompany) throws Exception;
}
