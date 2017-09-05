package egovframework.ezMobile.ezResource.dao;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;














import egovframework.ezEKP.ezSchedule.vo.ScheGetHolidayVO;
import egovframework.ezMobile.ezResource.vo.MResourceGetScheduleVO;
import egovframework.ezMobile.ezResource.vo.ResGetScheduleRepetitionVO;
import egovframework.ezMobile.ezResource.vo.ResGetScheduleVO;
import egovframework.ezMobile.ezResource.vo.MResourceGetAdmSubClsTreeVO;
import egovframework.ezMobile.ezResource.vo.MResourceScheduleVO;
import egovframework.ezMobile.ezResource.vo.ResScheGetHolidayVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("MResourceDAO")
public class MResourceDAO extends EgovAbstractDAO {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(MResourceDAO.class);
	
	
	@SuppressWarnings("unchecked")
	public List<MResourceGetAdmSubClsTreeVO> getAdmSubClsTree(Map<String, Object> map){
		return  (List<MResourceGetAdmSubClsTreeVO>) list("MResourceDAO.getAdmSubClsTree", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<MResourceScheduleVO> getTestList(Map<String, Object> map){
		return  (List<MResourceScheduleVO>) list("MResourceDAO.getTestList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<MResourceScheduleVO> getResScheduleList(Map<String, Object> map){
		List<MResourceScheduleVO> list = (List<MResourceScheduleVO>) list("MResourceDAO.getResScheduleList", map);
		LOGGER.debug("size of list: " + list.size());
		return  list;
	}
	
	@SuppressWarnings("unchecked")
	public List<MResourceScheduleVO> getResScheduleMainList(Map<String, Object> map){
		List<MResourceScheduleVO> list = (List<MResourceScheduleVO>) list("MResourceDAO.getResScheduleMainList", map);
		LOGGER.debug("size of list: " + list.size());
		return  list;
	}
	
	@SuppressWarnings("unchecked")
	public MResourceScheduleVO getResScheduleDetail(Map<String, Object> map){
		return  (MResourceScheduleVO) select("MResourceDAO.getResScheduleDetail", map);
	}
	
	@SuppressWarnings("unchecked")
	public MResourceGetScheduleVO getResSchRepet(Map<String, Object> map){
		return  (MResourceGetScheduleVO) select("MResourceDAO.getResSchRepet", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<MResourceGetAdmSubClsTreeVO> getResBrdList(Map<String, Object> map){
		LOGGER.debug("in getResBrdList");
		LOGGER.debug("map in getResBrdList: " + map);
		return  (List<MResourceGetAdmSubClsTreeVO>) list("MResourceDAO.getResBrdList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<MResourceScheduleVO> getResFavoriteList(Map<String, Object> map){
		return  (List<MResourceScheduleVO>) list("MResourceDAO.getResFavoriteList", map);
	}
	
	@SuppressWarnings("unchecked")
	public void addResSch(Map<String, Object> map){
		insert("MResourceDAO.addResSch", map);
	}
	
	@SuppressWarnings("unchecked")
	public void modifyResSch(Map<String, Object> map){
		update("MResourceDAO.modifyResSch", map);
	}
	
	@SuppressWarnings("unchecked")
	public void delResSch(Map<String, Object> map){
		delete("MResourceDAO.delResSchRem", map);
	}
	
	@SuppressWarnings("unchecked")
	public void delResSch_I(Map<String, Object> map){
		delete("MResourceDAO.delResSch_I", map);
	}
	
	@SuppressWarnings("unchecked")
	public int getResSchMaxNum(Map<String, Object> map){
		return (int)select("EzResourceDAO.resScheMaxNum", map);
	}
	
	@SuppressWarnings("unchecked")
	public void addResFavor(Map<String, Object> map){
		insert("MResourceDAO.addResFavor", map);
	}
	
	@SuppressWarnings("unchecked")
	public void delResFavor(Map<String, Object> map){
		delete("MResourceDAO.delResFavor", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ResGetScheduleVO> getScheduleList(Map<String, Object> map){
		return  (List<ResGetScheduleVO>) list("MResourceDAO.getScheduleList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ResGetScheduleVO> getScheduleListRepetiti(Map<String, Object> map){
		return  (List<ResGetScheduleVO>) list("MResourceDAO.getScheduleListRepetiti", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ResGetScheduleVO> getScheduleListMain(Map<String, Object> map){
		return  (List<ResGetScheduleVO>) list("MResourceDAO.getScheduleListMain", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ResGetScheduleVO> getScheduleListRepetitim(Map<String, Object> map){
		return  (List<ResGetScheduleVO>) list("MResourceDAO.getScheduleListRepetitim", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<String> getDeletedRepScheduleDate(Map<String, Object> map) {
		return (List<String>) list("MResourceDAO.getDeletedRepScheduleDate", map);
	} 
	
	public ResGetScheduleRepetitionVO getRepDateTimes(Map<String, Object> map) {
		return (ResGetScheduleRepetitionVO) select("MResourceDAO.getRepDateTimes", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ResScheGetHolidayVO> getTholiday(Map<String, Object> map){
			return  (List<ResScheGetHolidayVO>) list("MResourceDAO.getTholiday", map);
	}
	
	@SuppressWarnings("unchecked")
	public MResourceScheduleVO getResBrdDetail(Map<String, Object> map){
			return  (MResourceScheduleVO) select("MResourceDAO.getResBrdDetail", map);
	}
		
}

