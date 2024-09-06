package egovframework.ezMobile.ezSchedule.service;

import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONObject;

import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.ezMobile.ezSchedule.vo.MScheduleInfoVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleInfoVO;

public interface MScheduleService {

	public int insertSchedule(JSONObject jsonParam, String utcStartDate, String utcEndDate, int tenantId, String realPath, Locale locale, String offSet, String lang) throws Exception;
	
	public int insertBoardSchedule(JSONObject jsonParam, String utcStartDate, String utcEndDate, int tenantId, String realPath, Locale locale, String offSet, String lang) throws Exception;

	public void deleteSchedule(HttpServletRequest request, String scheduleId, int tenantId, MCommonVO info) throws Exception;

	public void insertScheduleRepeDel(String scheduleId, String startDate, int tenantId) throws Exception;
	
	public void updateSchedule(JSONObject jsonParam, String utcStartDate, String utcEndDate, String defaultPath, int tenantId, String realPath, Locale locale) throws Exception;

	public String scheduleContentPath(String scheduleId, int tenantId) throws Exception;

	public MScheduleInfoVO scheduleInfo(String scheduleId, String offSetMin, int tenantId) throws Exception;
	
	public List<ScheduleInfoVO> scheduleList(MCommonVO info, String startDate, String endDate, String searchTitle, String searchLocation, String searchAll, String filter) throws Exception;
	
	public List<ScheduleInfoVO> scheduleListForWorkspace(MCommonVO info, String startDate, String endDate, String searchTitle) throws Exception;
	
	public JSONObject scheduleMainList(MCommonVO info, String listCnt) throws Exception;

	public List<ScheduleInfoVO> scheduleUserSearchList(MCommonVO info, String startDate, String endDate, String searchTitle) throws Exception;

}
