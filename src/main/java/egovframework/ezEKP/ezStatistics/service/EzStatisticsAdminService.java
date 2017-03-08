package egovframework.ezEKP.ezStatistics.service;

import egovframework.ezEKP.ezStatistics.vo.StatApprVO;


public interface EzStatisticsAdminService {

	public String getTimeList(StatApprVO statApprVO);

	public String getCountList(StatApprVO statApprVO);

	public String getFormInfo(StatApprVO statApprVO);

	public String getSearchList(StatApprVO statApprVO);

	public String getMainList(StatApprVO statApprVO);
	
	public String getConnInfo(StatApprVO statApprVO);
	
	public String getStatConnBrowser(StatApprVO statApprVO);
	
	public String getStatConnOS(StatApprVO statApprVO);

	public void dailyDocCountLog(StatApprVO statApprVO) throws Exception;

	public void dailyFormCountLog(StatApprVO statApprVO) throws Exception;

}
