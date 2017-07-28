package egovframework.ezMobile.ezSchedule.service;

import org.json.simple.JSONObject;

import egovframework.ezEKP.ezSchedule.vo.ScheduleInfoVO;

public interface MScheduleService {

	public int insertSchedule(JSONObject jsonParam, String utcStartDate, String utcEndDate, String defaultPath, int tenantId) throws Exception;

	public void deleteSchedule(String scheduleId, int tenantId) throws Exception;

	public void updateSchedule(JSONObject jsonParam, String utcStartDate, String utcEndDate, String defaultPath, int tenantId) throws Exception;

	public String scheduleContentPath(String scheduleId, int tenantId) throws Exception;

	public ScheduleInfoVO scheduleInfo(String scheduleId, String offSetMin, int tenantId) throws Exception;
	
	
	
}
