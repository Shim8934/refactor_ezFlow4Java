package egovframework.ezEKP.ezStatistics.service;

import egovframework.ezEKP.ezStatistics.vo.StatApprVO;


public interface EzStatisticsAdminService {

	public String getTimeList(String date, String company, int tenantID);

	public String getCountList(StatApprVO statApprVO);

	public String getFormInfo(StatApprVO statApprVO);

}
