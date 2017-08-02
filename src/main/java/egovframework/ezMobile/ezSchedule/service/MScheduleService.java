package egovframework.ezMobile.ezSchedule.service;

import org.json.simple.JSONObject;

import egovframework.ezMobile.ezSchedule.vo.MScheduleInfoVO;

public interface MScheduleService {

	public int insertSchedule(JSONObject jsonParam, String utcStartDate, String utcEndDate, String defaultPath, int tenantId) throws Exception;

	public void deleteSchedule(String scheduleId, int tenantId) throws Exception;

	public void updateSchedule(JSONObject jsonParam, String utcStartDate, String utcEndDate, String defaultPath, int tenantId) throws Exception;

	public String scheduleContentPath(String scheduleId, int tenantId) throws Exception;

	public MScheduleInfoVO scheduleInfo(String scheduleId, String offSetMin, int tenantId) throws Exception;
	
	
	
}
