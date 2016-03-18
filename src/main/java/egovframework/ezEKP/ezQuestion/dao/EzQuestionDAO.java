package egovframework.ezEKP.ezQuestion.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezQuestion.vo.QstAttachVO;
import egovframework.ezEKP.ezQuestion.vo.QstListVO;
import egovframework.ezEKP.ezQuestion.vo.QstUserPermissionVO;
import egovframework.ezEKP.ezQuestion.vo.QstUserPollItemVO;
import egovframework.ezEKP.ezQuestion.vo.QstVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzQuestionDAO")
public class EzQuestionDAO extends EgovAbstractDAO{
	
	@SuppressWarnings("unchecked")
	public List<QstListVO> getQstList(Map<String, Object> map){
		return (List<QstListVO>) list("EzQuestionDAO.getQstList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<String> getUserIdAdmin(int brdId) {
		return (List<String>) select("EzQuestionDAO.getUserIdAdmin", brdId);
	}
	
	@SuppressWarnings("unchecked")
	public List<QstAttachVO> getAttachInfo(Map<String, Object> map) {
		return (List<QstAttachVO>) select("EzQuestionDAO.getAttachInfo", map);
	}
	
	public List<QstVO> getQuestionForResponse(Map<String, Object> map) {
		return (List<QstVO>) select("EzQuestionDAO.getQuestionForResponse", map);
	}
	
	public QstUserPollItemVO getUserPollItem(Map<String, Object> map){
		return  (QstUserPollItemVO) select("EzQuestionDAO.getUserPollItem", map);
	}
	
	public QstUserPermissionVO getUserPermission(Map<String, Object> map){
		return (QstUserPermissionVO) select("EzQuestionDAO.getUserPermission", map);
	}
	
	public String getItemSeq(String brdId) {
		return (String)select("EzQuestionDAO.getItemSeq", brdId);
	}
	
	public int getQstListCnt(Map<String, Object> map){
		select("EzQuestionDAO.getQstListCnt", map);
		return (int) map.get("v_pCount");
	}
	
	public int getItemNoCnt(Map<String, Object> map) throws Exception {
		select("EzQuestionDAO.getItemNoCnt", map);
		return (int) map.get("v_pCount");
	}
	
	public int getUserResponseCnt(Map<String, Object> map){
		return (int) select("EzQuestionDAO.getUserResponseCnt", map);
	}
	
	public int getQuestionNo(Map<String,Object> map) throws Exception {
		select("EzQuestionDAO.getQuestionNo", map);
		int temp = 0;
		if(map.get("v_pCount") != null) {
			temp = (int)map.get("v_pCount");
		}
		return temp;
	}
	
	public int getResponseDateCnt(Map<String,Object> map){
		return (int) select("EzQuestionDAO.getResponseDateCnt", map);
	}
	
	public int resCount(Map<String, Object> map) {
		return (int) select("EzQuestionDAO.resCount", map);
	}
	
	public int getReadDateItem(Map<String, Object> map) {
		return (int) select("EzQuestionDAO.getReadDateItem", map);
	}
	
	public void callCreateMother(Map<String,Object> map) {
		insert("EzQuestionDAO.callCreateMother", map);
	}
	
	public void callInsertPollResponsep1(Map<String,Object> map) {
		insert("EzQuestionDAO.callInsertPollResponsep1", map);
	}
	
	public void callInsertPollResponseper(Map<String,Object> map) {
		insert("EzQuestionDAO.callInsertPollResponseper", map);
	}
	
	public void insertQuestion(Map<String,Object> map) {
		insert("EzQuestionDAO.insertQuestion", map);
	}
	
	public void pollSaveAttach(Map<String,Object> map) {
		insert("EzQuestionDAO.pollSaveAttach", map);
	}
	
	public void insertAnswerAnswerContent(Map<String,Object> map) {
		insert("EzQuestionDAO.insertAnswerAnswerContent", map);
	}
	
	public void insertAnswerContent(Map<String,Object> map) {
		insert("EzQuestionDAO.insertAnswerContent", map);
	}
	
	public void insertItemRead(Map<String, Object> map) {
		insert("EzQuestionDAO.insertItemRead", map);
	}
	
	public void insertItemSeq(String brdId) {
		select("EzQuestionDAO.insertItemSeq", brdId);
	}
	
	public void stepSave(Map<String,Object> map) {
		update("EzQuestionDAO.stepSave", map);
	}
	
	public void updateItemSeq(Map<String,Object> map) {
		update("EzQuestionDAO.updateItemSeq", map);
	}
	
	public void stepSave2(Map<String,Object> map) {
		update("EzQuestionDAO.stepSave2", map);
	}
	
	public void updatePollItem(Map<String,Object> map) {
		update("EzQuestionDAO.updatePollItem", map);
	}
	
	public void updateReadCnt(Map<String, Object> map) {
		update("EzQuestionDAO.updateReadCnt", map);
	}

	public void updateReadDate(Map<String, Object> map) {
		update("EzQuestionDAO.updateReadDate", map);
	}
	public void deleteItem(Map<String,Object> map) {
		delete("EzQuestionDAO.deleteItem", map);
	}

}
