package egovframework.ezEKP.ezStatistics.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezStatistics.vo.StatApprVO;
import egovframework.ezEKP.ezStatistics.vo.StatDailyDocCountLogVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzStatisticsAdminDAO")
public class EzStatisticsAdminDAO extends EgovAbstractDAO{

	@SuppressWarnings("unchecked")
	public List<StatDailyDocCountLogVO> getTimeList_F(StatApprVO statApprVO) {
		return (List<StatDailyDocCountLogVO>) list("EzStatisticsAdminDAO.getTimeList_F", statApprVO);
	}
	
	@SuppressWarnings("unchecked")
	public List<StatDailyDocCountLogVO> getTimeList_D(StatApprVO statApprVO) {
		return (List<StatDailyDocCountLogVO>) list("EzStatisticsAdminDAO.getTimeList_D", statApprVO);
	}

	@SuppressWarnings("unchecked")
	public List<StatDailyDocCountLogVO> getCountList_F(StatApprVO statApprVO) {
		return (List<StatDailyDocCountLogVO>) list("EzStatisticsAdminDAO.getCountList_F", statApprVO);
	}
	
	@SuppressWarnings("unchecked")
	public List<StatDailyDocCountLogVO> getCountList_U(StatApprVO statApprVO) {
		return (List<StatDailyDocCountLogVO>) list("EzStatisticsAdminDAO.getCountList_U", statApprVO);
	}

	@SuppressWarnings("unchecked")
	public List<StatDailyDocCountLogVO> getFormInfo(StatApprVO statApprVO) {
		return (List<StatDailyDocCountLogVO>) list("EzStatisticsAdminDAO.getFormInfo", statApprVO);
	}

	@SuppressWarnings("unchecked")
	public List<StatDailyDocCountLogVO> getCountList_D(StatApprVO statApprVO) {
		return (List<StatDailyDocCountLogVO>) list("EzStatisticsAdminDAO.getCountList_D", statApprVO);
	}

	@SuppressWarnings("unchecked")
	public List<StatDailyDocCountLogVO> getTimeList_U(StatApprVO statApprVO) {
		return (List<StatDailyDocCountLogVO>) list("EzStatisticsAdminDAO.getTimeList_U", statApprVO);
	}

	@SuppressWarnings("unchecked")
	public List<StatDailyDocCountLogVO> getSearchList_F(StatApprVO statApprVO) {
		return (List<StatDailyDocCountLogVO>) list("EzStatisticsAdminDAO.getSearchList_F", statApprVO);
	}

	@SuppressWarnings("unchecked")
	public List<StatDailyDocCountLogVO> getSearchList_D(StatApprVO statApprVO) {
		return (List<StatDailyDocCountLogVO>) list("EzStatisticsAdminDAO.getSearchList_D", statApprVO);
	}
	
	@SuppressWarnings("unchecked")
	public List<StatDailyDocCountLogVO> getSearchList_U(StatApprVO statApprVO) {
		return (List<StatDailyDocCountLogVO>) list("EzStatisticsAdminDAO.getSearchList_U", statApprVO);
	}

	@SuppressWarnings("unchecked")
	public List<StatDailyDocCountLogVO> getMainList(StatApprVO statApprVO) {
		return (List<StatDailyDocCountLogVO>) list("EzStatisticsAdminDAO.getMainList", statApprVO);
	}

}
