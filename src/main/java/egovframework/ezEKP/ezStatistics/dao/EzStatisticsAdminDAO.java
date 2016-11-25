package egovframework.ezEKP.ezStatistics.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezStatistics.vo.StatApprVO;
import egovframework.ezEKP.ezStatistics.vo.StatDailyDocCountLogVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzStatisticsAdminDAO")
public class EzStatisticsAdminDAO extends EgovAbstractDAO{

	@SuppressWarnings("unchecked")
	public List<StatDailyDocCountLogVO> getTimeList(Map<String, Object> map) {
		return (List<StatDailyDocCountLogVO>) list("EzStatisticsAdminDAO.getTimeList", map);
	}

	@SuppressWarnings("unchecked")
	public List<StatDailyDocCountLogVO> getCountList(StatApprVO statApprVO) {
		return (List<StatDailyDocCountLogVO>) list("EzStatisticsAdminDAO.getCountList", statApprVO);
	}

	@SuppressWarnings("unchecked")
	public List<StatDailyDocCountLogVO> getFormInfo(StatApprVO statApprVO) {
		return (List<StatDailyDocCountLogVO>) list("EzStatisticsAdminDAO.getFormInfo", statApprVO);
	}

}
