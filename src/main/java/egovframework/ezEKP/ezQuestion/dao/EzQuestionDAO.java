package egovframework.ezEKP.ezQuestion.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezQuestion.vo.QuestionListVO;
import egovframework.ezEKP.ezQuestion.vo.UserPermissionVO;
import egovframework.ezEKP.ezQuestion.vo.UserPollItemVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzQuestionDAO")
public class EzQuestionDAO extends EgovAbstractDAO{
	
	public int getQstListCnt(Map<String, Object> map){
		select("EzQuestionDAO.getQstListCnt", map);
		return (int) map.get("v_pCount");
	}
	
	@SuppressWarnings("unchecked")
	public List<QuestionListVO> getQstList(Map<String, Object> map){
		return (List<QuestionListVO>) list("EzQuestionDAO.getQstList", map);
	}
	
	public int getItemNoCnt(Map<String, Object> map) throws Exception {
		select("EzQuestionDAO.getItemNoCnt", map);
		return (int) map.get("v_pCount");
	}
	
	public void stepSave(Map<String,Object> map) {
		update("EzQuestionDAO.stepSave", map);
	}
	
	public String getItemSeq(String brdId) {
		return (String)select("EzQuestionDAO.getItemSeq", brdId);
	}
	
	public void insertItemSeq(String brdId) {
		select("EzQuestionDAO.insertItemSeq", brdId);
	}
	
	public void updateItemSeq(Map<String,Object> map) {
		update("EzQuestionDAO.updateItemSeq", map);
	}
	
	public void stepSave2(Map<String,Object> map) {
		update("EzQuestionDAO.stepSave2", map);
	}
	
	public UserPollItemVO getUserPollItem(Map<String, Object> map){
		return  (UserPollItemVO) select("EzQuestionDAO.getUserPollItem", map);
	}
	
	public UserPermissionVO getUserPermission(Map<String, Object> map){
		return (UserPermissionVO) select("EzQuestionDAO.getUserPermission", map);
	}
	
	public int getUserResponseCnt(Map<String, Object> map){
		return (int) select("EzQuestionDAO.getUserResponseCnt", map);
	}
	
}
