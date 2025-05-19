package egovframework.ezEKP.ezStatistics.service;


import java.time.LocalDateTime;
import java.time.Month;
import java.time.Year;
import java.util.List;
import java.util.Map;

import egovframework.ezEKP.ezStatistics.vo.StatChartVO;
import egovframework.ezEKP.ezStatistics.vo.StatisticVO;
import egovframework.ezEKP.ezStatistics.vo.StatApprVO;
import egovframework.let.user.login.vo.LoginVO;
import org.json.simple.JSONObject;

import javax.annotation.Nullable;


public interface EzStatisticsAdminService {

	public String getTimeList(StatApprVO statApprVO);

	public String getCountList(StatApprVO statApprVO);

	public String getFormInfo(StatApprVO statApprVO);

	public String getSearchList(StatApprVO statApprVO);

	public String getMainList(StatApprVO statApprVO);
	
	public String getConnInfo(StatApprVO statApprVO);
	
	public String getStatConnBrowser(StatApprVO statApprVO);
	
	public String getStatConnOS(StatApprVO statApprVO) throws Exception;

	public void dailyDocCountLog(StatApprVO statApprVO) throws Exception;

	public void dailyFormCountLog(StatApprVO statApprVO) throws Exception;
	
	public void customApprStatisticsBatch() throws Exception;
	
	public Map<String, Object> getMailLogList(String tenantId, String pageNo, String pageSize, String mailLogType, String searchStartTime,
				String searchEndTime, String searchField, String searchValue, String isPrimaryLang, String companyId) throws Exception;

	public void yearlyDocCount(StatApprVO statApprVO) throws Exception;

	public JSONObject getYearlyDocCount(int tenantID, String companyID);
	
	void collectAccessEvent(StatisticVO statisticVO);
	
	StatChartVO getStatMenuUserMonthly(LoginVO userInfo, String targetCompanyId, String targetUserId, Year year, String menuId) throws Exception;

	StatChartVO getStatMenuUserDaily(LoginVO userInfo, String targetCompanyId, String targetUserId,
										   Year year, Month month, @Nullable String menuId) throws Exception;
	
	StatChartVO getStatMenuUserHourly(LoginVO userInfo, String targetCompanyId, String targetUserId,
									  Year year, Month month, int day, @Nullable String menuId) throws Exception;

	StatChartVO getStatMenuDeptMonthly(LoginVO userInfo, String targetCompanyId, String targetDeptId, Year year, String menuId) throws Exception;

	StatChartVO getStatMenuDeptDaily(LoginVO userInfo, String targetCompanyId, String targetDeptId,
									 Year year, Month month, @Nullable String menuId) throws Exception;

	StatChartVO getStatMenuDeptHourly(LoginVO userInfo, String targetCompanyId, String targetDeptId,
									  Year year, Month month, int day, @Nullable String menuId) throws Exception;

	StatChartVO getStatMenuUserForMonth(LoginVO userInfo, String targetCompanyId, String targetUserId, Year year, Month month) throws Exception;

	StatChartVO getStatMenuUserForDay(LoginVO userInfo, String targetCompanyId, String targetUserId, Year year, Month month, int day) throws Exception;
	
	StatChartVO getStatMenuUserForHour(LoginVO userInfo, String targetCompanyId, String targetUserId, Year year, Month month, int day, int hour) throws Exception;

	StatChartVO getStatMenuDeptForMonth(LoginVO userInfo, String targetCompanyId, String targetDeptId,
									  Year year, Month month) throws Exception;
	
	StatChartVO getStatMenuDeptForDay(LoginVO userInfo, String targetCompanyId, String targetDeptId,
									  Year year, Month month, int day) throws Exception;
	
	StatChartVO getStatMenuDeptForHour(LoginVO userInfo, String targetCompanyId, String targetDeptId,
									  Year year, Month month, int day, int hour) throws Exception;

	void deleteStatMenuBeforeTime(LocalDateTime time);
}
