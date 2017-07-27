package egovframework.ezMobile.ezSchedule.service;

import org.json.simple.JSONObject;

public interface MScheduleService {

	int insertSchedule(JSONObject jsonParam, String utcStartDate, String utcEndDate, String defaultPath, int tenantId) throws Exception;

	void deleteSchedule(String scheduleId, String dateType, int tenantId) throws Exception;

	void updateSchedule(JSONObject jsonParam, String utcStartDate, String utcEndDate, String defaultPath, int tenantId) throws Exception;
	
	
	
}
