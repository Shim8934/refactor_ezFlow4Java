package egovframework.ezMobile.ezSchedule.service;

import org.json.simple.JSONObject;
import egovframework.ezMobile.ezSchedule.vo.MScheduleInfoVO;

public interface MScheduleService {

	int insertSchedule(JSONObject jsonParam, String utcStartDate, String utcEndDate, String defaultPath, int tenantId) throws Exception;

	void deleteSchedule(String scheduleId, int tenantId) throws Exception;

	void updateSchedule(JSONObject jsonParam, String utcStartDate, String utcEndDate, String defaultPath, int tenantId) throws Exception;

	MScheduleInfoVO scheduleInfo(String scheduleId, int tenantId) throws Exception;
	
	
	
}
