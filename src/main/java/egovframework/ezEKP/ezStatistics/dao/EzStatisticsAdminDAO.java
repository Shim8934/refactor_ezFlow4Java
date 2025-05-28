package egovframework.ezEKP.ezStatistics.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.ezEKP.ezStatistics.vo.StatisticVO;
import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezStatistics.vo.StatApprVO;
import egovframework.ezEKP.ezStatistics.vo.StatConnVO;
import egovframework.ezEKP.ezStatistics.vo.StatDailyDocCountLogVO;
import org.egovframe.rte.psl.dataaccess.EgovAbstractDAO;

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
	
	@SuppressWarnings("unchecked")
	public List<StatConnVO> getConnInfo(StatApprVO statApprVO) {
		return (List<StatConnVO>) list("EzStatisticsAdminDAO.getConnInfo", statApprVO);
	}
	
	@SuppressWarnings("unchecked")
	public List<StatConnVO> getConnBrowser(StatApprVO statApprVO) {
		return (List<StatConnVO>) list("EzStatisticsAdminDAO.getConnBrowser", statApprVO);	
	}
	
	@SuppressWarnings("unchecked")
	public List<StatConnVO> getConnOS(StatApprVO statApprVO) {
		return (List<StatConnVO>) list("EzStatisticsAdminDAO.getConnOS", statApprVO);	
	}

	public void insertCustomDocBatch() {
		insert("EzStatisticsAdminDAO.insertCustomDocBatch");	
	}
	public void insertCustomFormBatch() {
		insert("EzStatisticsAdminDAO.insertCustomFormBatch");	
	}

	public void deleteCustomDocBatch() {
		insert("EzStatisticsAdminDAO.deleteCustomDocBatch");	
	}
	public void deleteCustomFormBatch() {
		insert("EzStatisticsAdminDAO.deleteCustomFormBatch");	
	}

	public void deleteDailyDocCountLog(StatApprVO statApprVO) throws Exception {
		delete("EzStatisticsAdminDAO.deleteDailyDocCountLog", statApprVO);
	}

	public void deleteDailyFormCountLog(StatApprVO statApprVO) throws Exception {
		delete("EzStatisticsAdminDAO.deleteDailyFormCountLog", statApprVO);
	}

	public void insertDailyDocCountLog(StatApprVO statApprVO) throws Exception {
		insert("EzStatisticsAdminDAO.insertDailyDocCountLog", statApprVO);
	}

	public void insertDailyFormCountLog(StatApprVO statApprVO) throws Exception {
		insert("EzStatisticsAdminDAO.insertDailyFormCountLog", statApprVO);
	}

	public void deleteYearlyDocCount(StatApprVO statApprVO) throws Exception {
		delete("EzStatisticsAdminDAO.deleteYearlyDocCount", statApprVO);
	}

	public void insertYearlyDocCount(StatApprVO statApprVO) throws Exception {
		insert("EzStatisticsAdminDAO.insertYearlyDocCount", statApprVO);
	}

	@SuppressWarnings("unchecked")
	public List<HashMap<String, Object>> getYearlyDocCount(Map<String, Object> map) throws Exception {
		return (List<HashMap<String, Object>>) list("EzStatisticsAdminDAO.getYearlyDocCount", map);
	}

	public void upsertStatMenuUser(StatisticVO statisticVO) {
		insert("EzStatisticsAdminDAO.upsertStatMenuUser", statisticVO);
	}

	@SuppressWarnings("unchecked")
	public List<StatisticVO> getStatMenuUser(Map<String, Object> map) {
		return (List<StatisticVO>) list("EzStatisticsAdminDAO.getStatMenuUser", map);
	}

	public void upsertStatMenuUserMonth(StatisticVO statisticVO) {
		insert("EzStatisticsAdminDAO.upsertStatMenuUserMonth", statisticVO);
	}

	@SuppressWarnings("unchecked")
	public List<StatisticVO> getStatMenuUserMonth(Map<String, Object> map) {
		return (List<StatisticVO>) list("EzStatisticsAdminDAO.getStatMenuUserMonth", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<StatisticVO> getStatMenuUserDay(Map<String, Object> map) {
		return (List<StatisticVO>) list("EzStatisticsAdminDAO.getStatMenuUserDay", map);
	}

	public void upsertStatMenuDept(StatisticVO statisticVO) {
		insert("EzStatisticsAdminDAO.upsertStatMenuDept", statisticVO);
	}

	public void upsertStatMenuDeptMonth(StatisticVO statisticVO) {
		insert("EzStatisticsAdminDAO.upsertStatMenuDeptMonth", statisticVO);
	}

	@SuppressWarnings("unchecked")
	public List<StatisticVO> getStatMenuDept(Map<String, Object> map) {
		return (List<StatisticVO>) list("EzStatisticsAdminDAO.getStatMenuDept", map);
	}

	@SuppressWarnings("unchecked")
	public List<StatisticVO> getStatMenuDeptMonth(Map<String, Object> map) {
		return (List<StatisticVO>) list("EzStatisticsAdminDAO.getStatMenuDeptMonth", map);
	}

	@SuppressWarnings("unchecked")
	public List<StatisticVO> getStatMenuDeptDay(Map<String, Object> map) {
		return (List<StatisticVO>) list("EzStatisticsAdminDAO.getStatMenuDeptDay", map);
	}

	public void deleteStatMenuUser(StatisticVO statisticVO) {
		delete("EzStatisticsAdminDAO.deleteStatMenuUser", statisticVO);
	}

	public void deleteStatMenuDept(StatisticVO statisticVO) {
		delete("EzStatisticsAdminDAO.deleteStatMenuDept", statisticVO);
	}
}
