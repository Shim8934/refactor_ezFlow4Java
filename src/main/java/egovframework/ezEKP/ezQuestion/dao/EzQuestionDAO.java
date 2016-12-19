package egovframework.ezEKP.ezQuestion.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezQuestion.vo.QstAnswerVO;
import egovframework.ezEKP.ezQuestion.vo.QstAttachVO;
import egovframework.ezEKP.ezQuestion.vo.QstDeleteAttachUrlVO;
import egovframework.ezEKP.ezQuestion.vo.QstListVO;
import egovframework.ezEKP.ezQuestion.vo.QstResponsePersonVO;
import egovframework.ezEKP.ezQuestion.vo.QstResponseVO;
import egovframework.ezEKP.ezQuestion.vo.QstReuseQuestionVO;
import egovframework.ezEKP.ezQuestion.vo.QstTempSaveVO;
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
	
	public String getUserIDAdmin(int brdID) {
		return (String) select("EzQuestionDAO.getUserIDAdmin", brdID);
	}
	
	@SuppressWarnings("unchecked")
	public List<QstAttachVO> getAttachInfo(Map<String, Object> map) {
		return (List<QstAttachVO>) list("EzQuestionDAO.getAttachInfo", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<QstAttachVO> getAttachInfo03(Map<String, Object> map) {
		return (List<QstAttachVO>) list("EzQuestionDAO.getAttachInfo3", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<QstVO> getQuestionForResponse(Map<String, Object> map) {
		return (List<QstVO>) list("EzQuestionDAO.getQuestionForResponse", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<QstAnswerVO> getAnswerAnswerCnt(Map<String, Object> map) {
		return (List<QstAnswerVO>) list("EzQuestionDAO.getAnswerAnswerCnt", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<QstAnswerVO> getAnswerCnt(Map<String, Object> map) {
		return (List<QstAnswerVO>) list("EzQuestionDAO.getAnswerCnt", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<QstResponseVO> resultSubjectiveList(Map<String, Object> map) {
		return (List<QstResponseVO>) list("EzQuestionDAO.resultSubjectiveList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<String> getTableAnswer(Map<String, Object> map) {
		return (List<String>) list("EzQuestionDAO.getTableAnswer", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<String> tableAnswerValue(Map<String, Object> map) {
		return (List<String>) list("EzQuestionDAO.tableAnswerValue", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<String> getResponseAnswer(Map<String, Object> map) {
		return (List<String>) list("EzQuestionDAO.getResponseAnswer", map);
	}

	@SuppressWarnings("unchecked")
	public List<QstResponseVO> responseList(Map<String, Object> map) {
		return (List<QstResponseVO>) list("EzQuestionDAO.responseList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<QstVO> getObjQuestion(Map<String, Object> map) {
		return (List<QstVO>) list("EzQuestionDAO.getObjQuestion", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<QstVO> getQuestion(Map<String, Object> map) {
		return (List<QstVO>) list("EzQuestionDAO.getQuestion", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<QstResponseVO> gwPollGetSearch(Map<String, Object> map) {
		return (List<QstResponseVO>) list("EzQuestionDAO.gwPollGetSearch", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<QstResponseVO> gwPollPositionSearch(Map<String, Object> map) {
		return (List<QstResponseVO>) list("EzQuestionDAO.gwPollPositionSearch", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<QstResponseVO> gwPollJikgubSearch(Map<String, Object> map) {
		return (List<QstResponseVO>) list("EzQuestionDAO.gwPollJikgubSearch", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<QstResponseVO> getResponsePersonForResultTotalSave(Map<String, Object> map) {
		return (List<QstResponseVO>) list("EzQuestionDAO.getResponsePersonForResultTotalSave",map);
	}
	
	@SuppressWarnings("unchecked")
	public List<QstTempSaveVO> tempSave(Map<String, Object> map) {
		return (List<QstTempSaveVO>) list("EzQuestionDAO.tempSave",map);
	}
	
	@SuppressWarnings("unchecked")
	public List<QstDeleteAttachUrlVO> getDeleteAttachUrl(Map<String, Object> map) {
		return (List<QstDeleteAttachUrlVO>) list("EzQuestionDAO.getDeleteAttachUrl", map);
	}
	
	public QstResponsePersonVO getResponsePerson(Map<String, Object> map) {
		return (QstResponsePersonVO) select("EzQuestionDAO.getResponsePerson", map);
	}
	
	public QstUserPollItemVO getUserPollItem(Map<String, Object> map){
		return  (QstUserPollItemVO) select("EzQuestionDAO.getUserPollItem", map);
	}
	
	public QstUserPermissionVO getUserPermission(Map<String, Object> map){
		return (QstUserPermissionVO) select("EzQuestionDAO.getUserPermission", map);
	}
	
	public QstUserPermissionVO getResponseRange(Map<String, Object> map) {
		return (QstUserPermissionVO) select("EzQuestionDAO.getResponseRange", map);
	}
	
	public QstAttachVO getAttachInfo2(Map<String, Object> map) {
		return (QstAttachVO) select("EzQuestionDAO.getAttachInfo2",map);
	}

	public QstVO getQuestionForSubjective(Map<String, Object> map) {
		return (QstVO) select("EzQuestionDAO.getQuestionForSubjective", map);
	}
	
	public QstReuseQuestionVO reUseQuestionData(Map<String, Object> map) {
		return (QstReuseQuestionVO) select("EzQuestionDAO.reUseQuestionData", map);
	}
	
	public String getItemSeq(Map<String, Object> map) {
		return (String)select("EzQuestionDAO.getItemSeq", map);
	}
	
	public String getReadDateItemForResult(Map<String, Object> map) {
		return (String) select("EzQuestionDAO.getReadDateItemForResult", map);
	}
	
	public int callGetItemSeq(Map<String, Object> map){
		return (int) select("EzQuestionDAO.callGetItemSeq", map);
	}
	
	public int getQstListCnt(Map<String, Object> map){
		select("EzQuestionDAO.getQstListCnt", map);
		return (int) map.get("v_pCount");
	}
	
	public int getItemNoCnt(Map<String, Object> map) throws Exception {
		return (int) select("EzQuestionDAO.getItemNoCnt", map);
	}
	
	public int getUserResponseCnt(Map<String, Object> map){
		return (int) select("EzQuestionDAO.getUserResponseCnt", map);
	}
	
	public int getQuestionNo(Map<String,Object> map) throws Exception {
		//return (int)select("EzQuestionDAO.getQuestionNo", map);
		if(select("EzQuestionDAO.getQuestionNo", map) != null) {
			return (int)(int)select("EzQuestionDAO.getQuestionNo", map);
		}else{
			return 0;
		}
	}
	
	public int getResponseDateCnt(Map<String,Object> map){
		return (int) select("EzQuestionDAO.getResponseDateCnt", map);
	}
	
	public int wpCountPollCount(Map<String, Object> map){
		select("EzQuestionDAO.wpCountPollCount", map);
		return (int) map.get("v_pCount");
	}
	
	public int getQstResponse(Map<String, Object> map){
		select("EzQuestionDAO.getQstResponse", map);
		return (int) map.get("v_pCount");
	}
	
	public Integer resCount(Map<String, Object> map) {
		return (Integer) select("EzQuestionDAO.resCount", map);
	}
	
	public Integer getReadDateItem(Map<String, Object> map) {
		return (int) select("EzQuestionDAO.getReadDateItem", map);
	}
	
	public Integer getResponseMaxNo(Map<String, Object> map) {
		return (Integer) select("EzQuestionDAO.getResponseMaxNo", map);
	}
	
	public Integer getAnsCnt(Map<String, Object> map) {
		return (int) select("EzQuestionDAO.getAnsCnt", map);
	}
	
	public Integer getResponsePersonCnt(Map<String, Object> map) {
		return (Integer) select("EzQuestionDAO.getResponsePersonCnt", map);
	}
	
	public Integer pollRespCnt(Map<String, Object> map) {
		return (Integer) select("EzQuestionDAO.pollRespCnt", map);
	}
	
	public Integer pollRespCnt2(Map<String, Object> map) {
		return (Integer) select("EzQuestionDAO.pollRespCnt2", map);
	}
	
	public String getQuestionNoCnt(Map<String, Object> map){
		return (String) select("EzQuestionDAO.getQuestionNoCnt", map);
	}
	
	public String analysisCount(Map<String, Object> map) {
		return (String) select("EzQuestionDAO.analysisCount", map);
	}
	
	public String resultSubjectiveListCnt(Map<String, Object> map) {
		return (String) select("EzQuestionDAO.resultSubjectiveListCnt", map);
	}
	
	public String responseListCnt(Map<String, Object> map) {
		return (String) select("EzQuestionDAO.responseListCnt", map);
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
	
	public void insertItemSeq(Map<String,Object> map) {
		select("EzQuestionDAO.insertItemSeq", map);
	}
	
	public void insertResponse(Map<String,Object> map) {
		insert("EzQuestionDAO.insertResponse", map);
	}
	
	public void insertResponse2(Map<String,Object> map) {
		insert("EzQuestionDAO.insertResponse2", map);
	}
	
	public void callInsertItemSeq(Map<String,Object> map) {
		insert("EzQuestionDAO.callInsertItemSeq", map);
	}
	
	public void stepSave(Map<String,Object> map) {
		update("EzQuestionDAO.stepSave", map);
	}
	
	public void callUpdateItemSeq(Map<String,Object> map) {
		update("EzQuestionDAO.callUpdateItemSeq", map);
	}
	
	public void updateItemSeq(Map<String,Object> map) {
		update("EzQuestionDAO.updateItemSeq", map);
	}
	
	public void updatePollEndDate(Map<String,Object> map) {
		update("EzQuestionDAO.updatePollEndDate", map);
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
	
	public void updateResponsePerson(Map<String, Object> map) {
		update("EzQuestionDAO.updateResponsePerson", map);
	}

	public void updateResCnt(Map<String, Object> map) {
		update("EzQuestionDAO.updateResCnt", map);
	}
	
	public void changePermission(Map<String, Object> map) {
		update("EzQuestionDAO.changePermission", map);
	}
	
	public void changePermission_U(Map<String, Object> map) {
		update("EzQuestionDAO.changePermission_U", map);
	}
	
	public void updateTblPollItem(Map<String, Object> map) {
		update("EzQuestionDAO.updateTblPollItem", map);
	}
	
	public void updateTblPollPermission(Map<String, Object> map) {
		update("EzQuestionDAO.updateTblPollPermission", map);
	}
	
	public void updatePollEndDate_U(Map<String, Object> map) {
		update("EzQuestionDAO.updatePollEndDate_U", map);
	}
	
	public void deleteItem(Map<String,Object> map) {
		delete("EzQuestionDAO.deleteItem", map);
	}
	
	public void deleteItem_D1(Map<String,Object> map) {
		delete("EzQuestionDAO.deleteItem_D1", map);
	}
	
	public void deleteItem_D2(Map<String,Object> map) {
		delete("EzQuestionDAO.deleteItem_D2", map);
	}
	
	public void deleteItem_D3(Map<String,Object> map) {
		delete("EzQuestionDAO.deleteItem_D3", map);
	}
	
	public void deleteItem_D4(Map<String,Object> map) {
		delete("EzQuestionDAO.deleteItem_D4", map);
	}
	
	public void deleteItem_D5(Map<String,Object> map) {
		delete("EzQuestionDAO.deleteItem_D5", map);
	}
	
	public void deleteItem_D6(Map<String,Object> map) {
		delete("EzQuestionDAO.deleteItem_D6", map);
	}
	
	public void deleteItem_D7(Map<String,Object> map) {
		delete("EzQuestionDAO.deleteItem_D7", map);
	}
	
	public void deletePermission(Map<String,Object> map) {
		delete("EzQuestionDAO.deletePermission", map);
	}
	
	public void deletePermission_D(Map<String,Object> map) {
		delete("EzQuestionDAO.deletePermission_D", map);
	}
	
	public void deletePollAttach(Map<String,Object> map) {
		delete("EzQuestionDAO.deletePollAttach", map);
	}
	public void callDeleteItemSeq(Map<String,Object> map) {
		delete("EzQuestionDAO.callDeleteItemSeq", map);
	}
	public void callDeletePollResponseper(Map<String,Object> map) {
		delete("EzQuestionDAO.callDeletePollResponseper", map);
	}
	public void questionDelete2(Map<String,Object> map) {
		delete("EzQuestionDAO.questionDelete2", map);
	}
	
	public void questionDelete2_D(Map<String,Object> map) {
		delete("EzQuestionDAO.questionDelete2_D", map);
	}
	
	public void questionDelete1(Map<String,Object> map) {
		delete("EzQuestionDAO.questionDelete1", map);
	}
}
