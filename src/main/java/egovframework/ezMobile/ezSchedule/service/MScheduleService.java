package egovframework.ezMobile.ezSchedule.service;

import java.util.List;
import java.util.Locale;

import org.json.simple.JSONObject;

import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.ezMobile.ezSchedule.vo.MScheduleInfoVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleInfoVO;

public interface MScheduleService {

	public int insertSchedule(JSONObject jsonParam, String utcStartDate, String utcEndDate, int tenantId, String realPath, Locale locale) throws Exception;

	public void deleteSchedule(String scheduleId, int tenantId) throws Exception;

	public void insertScheduleRepeDel(String scheduleId, String startDate, int tenantId) throws Exception;
	
	public void updateSchedule(JSONObject jsonParam, String utcStartDate, String utcEndDate, String defaultPath, int tenantId) throws Exception;

	public String scheduleContentPath(String scheduleId, int tenantId) throws Exception;

	public MScheduleInfoVO scheduleInfo(String scheduleId, String offSetMin, int tenantId) throws Exception;
	
	public List<ScheduleInfoVO> scheduleList(MCommonVO info, String startDate, String endDate) throws Exception;
	
	public JSONObject scheduleMainList(MCommonVO info, String listCnt) throws Exception;	
	
}
