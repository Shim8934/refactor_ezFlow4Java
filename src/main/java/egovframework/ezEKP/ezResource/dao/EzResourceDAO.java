package egovframework.ezEKP.ezResource.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezResource.vo.ResBrdListVO;
import egovframework.ezEKP.ezResource.vo.ResBrdVO;
import egovframework.ezEKP.ezResource.vo.ResGetAdmSubClsTreeVO;
import egovframework.ezEKP.ezResource.vo.ResGetAdminFlagVO;
import egovframework.ezEKP.ezResource.vo.ResGetItemListVO;
import egovframework.ezEKP.ezResource.vo.ResGetRepDateTimesVO;
import egovframework.ezEKP.ezResource.vo.ResGetScheduleListMainVO;
import egovframework.ezEKP.ezResource.vo.ResGetScheduleListRepetitionVO;
import egovframework.ezEKP.ezResource.vo.ResGetScheduleListTermVO;
import egovframework.ezEKP.ezResource.vo.ResGetScheduleListVO;
import egovframework.ezEKP.ezResource.vo.ResGetScheduleRepetitionVO;
import egovframework.ezEKP.ezResource.vo.ResGetScheduleVO;
import egovframework.ezEKP.ezResource.vo.ResSelectFormIDVO;
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
	public List<ResGetScheduleRepetitionVO> getScheduleRepetition(Map<String, Object> map){
		return  (List<ResGetScheduleRepetitionVO>) list("EzResourceDAO.getScheduleRepetition", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ResGetScheduleListMainVO> getScheduleListMain(Map<String, Object> map){
		return  (List<ResGetScheduleListMainVO>) list("EzResourceDAO.getScheduleListMain", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ResGetScheduleListRepetitionVO> getScheduleListRepetiti(Map<String, Object> map){
		return  (List<ResGetScheduleListRepetitionVO>) list("EzResourceDAO.getScheduleListRepetiti", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ResGetScheduleListMainVO> getScheduleListRepetitim(Map<String, Object> map){
		return  (List<ResGetScheduleListMainVO>) list("EzResourceDAO.getScheduleListRepetitim", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ResBrdListVO> getBrdList(Map<String, Object> map){
		return  (List<ResBrdListVO>) list("EzResourceDAO.getBrdList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ResGetScheduleVO> getScheduleInfo(Map<String, Object> map) {
		return (List<ResGetScheduleVO>) list("EzResourceDAO.getScheduleInfo", map);
	}
	
	public ResGetScheduleListTermVO getScheduleListTerm(Map<String, Object> map){
		return  (ResGetScheduleListTermVO) select("EzResourceDAO.getScheduleListTerm", map);
	}
	
	public ResGetAdminFlagVO getAdmFlag(Map<String, Object> map) {
		return (ResGetAdminFlagVO) select("EzResourceDAO.getAdmFlag", map);
	}
	
	public ResGetRepDateTimesVO getRepDateTimes(Map<String, Object> map) {
		return (ResGetRepDateTimesVO) select("EzResourceDAO.getRepDateTimes", map);
	}
	
	public ResBrdVO getBrd(Map<String, Object> map) {
		return (ResBrdVO) select("EzResourceDAO.getBrd", map);
	}
	
	public ResGetScheduleVO getSchedule(Map<String, Object> map) {
		return (ResGetScheduleVO) select("EzResourceDAO.getSchedule", map);
	}
	
	public ResSelectFormIDVO selectFormID(Map<String, Object> map) {
		return (ResSelectFormIDVO) select("EzResourceDAO.selectFormID", map);
	}
	
	public String getAclTblBrd(Map<String, Object> map) {
		return (String) select("EzResourceDAO.getAclTblBrd", map);
	}
	
	public String getBrdApproveFlag(Map<String, Object> map) {
		return (String) select("EzResourceDAO.getBrdApproveFlag", map);
	}
	
	public int getBrdCnt(Map<String , Object> map) {
		select("EzResourceDAO.getBrdCnt", map);
		return (int)map.get("v_pCount");
	}
	
	public void addResData(Map<String, Object> map) {
		insert("EzResourceDAO.addResData", map);
	}
	
	public void insertScheduleRepetition(Map<String, Object> map) {
		insert("EzResourceDAO.insertScheduleRepetition", map);
	}
	
	public void insertForm(Map<String, Object> map) {
		insert("EzResourceDAO.insertForm", map);
	}
	
	public void addResSch(Map<String, Object> map) {
		insert("EzResourceDAO.addRessch", map);
	}
	
	public void modifyResData(Map<String, Object> map) {
		update("EzResourceDAO.modifyResData", map);
	}
	
	public void updateSchedule(Map<String, Object> map) {
		update("EzResourceDAO.updateSchedule", map);
	}
	
	public void updateScheduleDateTime(Map<String, Object> map) {
		update("EzResourceDAO.updateScheduleDateTime", map);
	}
	
	public void updateScheduleRepetition(Map<String, Object> map) {
		update("EzResourceDAO.updateScheduleRepetition", map);
	}
	
	public void modifyResSch(Map<String, Object> map) {
		update("EzResourceDAO.modifyResSch", map);
	}
	
	public void delResData(Map<String, Object> map) {
		delete("EzResourceDAO.delResData", map);
	}
	
	public void deleteRepetition(Map<String, Object> map) {
		delete("EzResourceDAO.deleteRepetition", map);
	}
	
	public void delFormID(Map<String, Object> map) {
		delete("EzResourceDAO.delFormID", map);
	}
	
	public void delResSch(Map<String, Object> map) {
		delete("EzResourceDAO.delResSch", map);
	}
	
}

