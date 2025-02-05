package egovframework.ezMobile.ezResource.dao;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

import egovframework.ezMobile.ezResource.vo.MResourceGetAdmSubClsTreeVO;
import egovframework.ezMobile.ezResource.vo.MResourceGetScheduleVO;
import egovframework.ezMobile.ezResource.vo.MResourceScheduleVO;
import egovframework.ezMobile.ezResource.vo.ResGetScheduleRepetitionVO;
import egovframework.ezMobile.ezResource.vo.ResGetScheduleVO;
import egovframework.ezMobile.ezResource.vo.ResScheGetHolidayVO;
import org.egovframe.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("MResourceDAO")
public class MResourceDAO extends EgovAbstractDAO {
	
	private static final Logger logger = LoggerFactory.getLogger(MResourceDAO.class);
	
	
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
		return  list;
	}
	
	@SuppressWarnings("unchecked")
	public List<MResourceScheduleVO> getResScheduleMainList(Map<String, Object> map){
		List<MResourceScheduleVO> list = (List<MResourceScheduleVO>) list("MResourceDAO.getResScheduleMainList", map);
		logger.debug("size of list: " + list.size());
		return  list;
	}
	
	public MResourceScheduleVO getResScheduleDetail(Map<String, Object> map){
		return  (MResourceScheduleVO) select("MResourceDAO.getResScheduleDetail", map);
	}
	
	public MResourceGetScheduleVO getResSchRepet(Map<String, Object> map){
		return  (MResourceGetScheduleVO) select("MResourceDAO.getResSchRepet", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<MResourceGetAdmSubClsTreeVO> getResBrdList(Map<String, Object> map){
		return  (List<MResourceGetAdmSubClsTreeVO>) list("MResourceDAO.getResBrdList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<MResourceScheduleVO> getResFavoriteList(Map<String, Object> map){
		return  (List<MResourceScheduleVO>) list("MResourceDAO.getResFavoriteList", map);
	}
	
	public Integer addResSch(Map<String, Object> map){
		insert("MResourceDAO.addResSch", map);
		return (Integer) map.get("v_PNUM");
	}
	
	public void modifyResSch(Map<String, Object> map){
		update("MResourceDAO.modifyResSch", map);
	}
	
	public void delResSch(Map<String, Object> map){
		delete("MResourceDAO.delResSchRem", map);
	}
	
	public void delResSchRepet(Map<String, Object> map){
		delete("MResourceDAO.delResSchRemRepet", map);
	}
	
	public void delResSch_I(Map<String, Object> map){
		delete("MResourceDAO.delResSch_I", map);
	}
	
	public int getResSchMaxNum(Map<String, Object> map){
		return (int)select("EzResourceDAO.resScheMaxNum", map);
	}
	
	public void addResFavor(Map<String, Object> map){
		insert("MResourceDAO.addResFavor", map);
	}
	
	public void delResFavor(Map<String, Object> map){
		delete("MResourceDAO.delResFavor", map);
	}
	
	public String getResUpperBrdID(Map<String, Object> map){
		return (String)select("MResourceDAO.getResUpperBrdID", map);
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
	
	public MResourceScheduleVO getResBrdDetail(Map<String, Object> map){
			return  (MResourceScheduleVO) select("MResourceDAO.getResBrdDetail", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ResGetScheduleVO> getScheduleApprList(Map<String, Object> map){
		return  (List<ResGetScheduleVO>) list("MResourceDAO.getScheduleListAppr", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ResGetScheduleVO> getScheduleApprListRepetiti(Map<String, Object> map){
		return  (List<ResGetScheduleVO>) list("MResourceDAO.getScheduleListRepetitiAppr", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<MResourceGetAdmSubClsTreeVO> getResApprBrdList(Map<String, Object> map){
		return  (List<MResourceGetAdmSubClsTreeVO>) list("MResourceDAO.getResApprBrdList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<MResourceGetAdmSubClsTreeVO> getResApprBrdListCheck(Map<String, Object> map){
		return  (List<MResourceGetAdmSubClsTreeVO>) list("MResourceDAO.getResApprBrdListCheck", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<MResourceGetAdmSubClsTreeVO> getResApprBrdListCheck2(Map<String, Object> map){
		return  (List<MResourceGetAdmSubClsTreeVO>) list("MResourceDAO.getResApprBrdListCheck2", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<String> getResAdminAuth(Map<String, Object> map){
		return (List<String>) list("MResourceDAO.getResAdminAuth", map);
	}
}

