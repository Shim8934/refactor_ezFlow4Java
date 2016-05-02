package egovframework.ezEKP.ezResource.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezResource.vo.ResBrdListVO;
import egovframework.ezEKP.ezResource.vo.ResGetAdmSubClsTreeVO;
import egovframework.ezEKP.ezResource.vo.ResGetAdminFlagVO;
import egovframework.ezEKP.ezResource.vo.ResGetItemListVO;
import egovframework.ezEKP.ezResource.vo.ResGetRepDateTimesVO;
import egovframework.ezEKP.ezResource.vo.ResGetScheduleListMainVO;
import egovframework.ezEKP.ezResource.vo.ResGetScheduleListTermVO;
import egovframework.ezEKP.ezResource.vo.ResGetScheduleListVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzResourceDAO")
public class EzResourceDAO extends EgovAbstractDAO {
	
	@SuppressWarnings("unchecked")
	public List<ResGetAdmSubClsTreeVO> getAdmSubClsTree(Map<String, Object> map){
		return  (List<ResGetAdmSubClsTreeVO>) list("EzResourceDAO.getAdmSubClsTree", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ResGetAdmSubClsTreeVO> getSubClsTree(Map<String, Object> map){
		return  (List<ResGetAdmSubClsTreeVO>) list("EzResourceDAO.getSubClsTree", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ResGetItemListVO> getBrdMainList(Map<String, Object> map){
		return  (List<ResGetItemListVO>) list("EzResourceDAO.getBrdMainList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ResGetScheduleListVO> getScheduleList(Map<String, Object> map){
		return  (List<ResGetScheduleListVO>) list("EzResourceDAO.getScheduleList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ResGetScheduleListMainVO> getScheduleListMain(Map<String, Object> map){
		return  (List<ResGetScheduleListMainVO>) list("EzResourceDAO.getScheduleListMain", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ResGetScheduleListVO> getScheduleListRepetiti(Map<String, Object> map){
		return  (List<ResGetScheduleListVO>) list("EzResourceDAO.getScheduleListRepetiti", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ResGetScheduleListMainVO> getScheduleListRepetitim(Map<String, Object> map){
		return  (List<ResGetScheduleListMainVO>) list("EzResourceDAO.getScheduleListRepetitim", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ResBrdListVO> getBrdList(Map<String, Object> map){
		return  (List<ResBrdListVO>) list("EzResourceDAO.getBrdList", map);
	}
	
	public ResGetScheduleListTermVO getScheduleListTerm(Map<String, Object> map){
		return  (ResGetScheduleListTermVO) select("EzResourceDAO.getScheduleListTerm", map);
	}
	
	public ResGetAdminFlagVO getAdminFlag(Map<String, Object> map) {
		return (ResGetAdminFlagVO) select("EzResourceDAO.getAdminFlag", map);
	}
	
	public ResGetRepDateTimesVO getRepDateTimes(Map<String, Object> map) {
		return (ResGetRepDateTimesVO) select("EzResourceDAO.getRepDateTimes", map);
	}
	
	public int getBrdCnt(Map<String , Object> map) {
		select("EzResourceDAO.getBrdCnt", map);
		return (int)map.get("v_pCount");
	}
}

