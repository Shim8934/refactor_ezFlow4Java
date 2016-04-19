package egovframework.ezEKP.ezQuestion.service;

import java.util.List;
import java.util.Map;

import egovframework.ezEKP.ezQuestion.vo.QstAnswerVO;
import egovframework.ezEKP.ezQuestion.vo.QstAttachVO;
import egovframework.ezEKP.ezQuestion.vo.QstCompleteVO;
import egovframework.ezEKP.ezQuestion.vo.QstListVO;
import egovframework.ezEKP.ezQuestion.vo.QstResponsePersonVO;
import egovframework.ezEKP.ezQuestion.vo.QstResponseVO;
import egovframework.ezEKP.ezQuestion.vo.QstReuseQuestionVO;
import egovframework.ezEKP.ezQuestion.vo.QstTempSaveVO;
import egovframework.ezEKP.ezQuestion.vo.QstUserPermissionVO;
import egovframework.ezEKP.ezQuestion.vo.QstUserPollItemVO;
import egovframework.ezEKP.ezQuestion.vo.QstVO;
import egovframework.let.user.login.vo.LoginVO;

public interface EzQuestionService {

	public List<QstListVO> getQstList(QstListVO qstListVO) throws Exception;

	public List<QstVO> getQuestionForResponse(QstVO questionVO) throws Exception;
	
	public List<QstAttachVO> getAttachInfo(QstAttachVO qstAttachVO) throws Exception;
	
	public List<QstAttachVO> getAttachInfo3(QstAttachVO qstAttachVO) throws Exception;

	public String getUserIDAdmin(int brd) throws Exception;
	
	public List<QstAnswerVO> getAnswerAnswerCnt(int brdID, int itemNo, int qstNo) throws Exception;
	
	public List<QstAnswerVO> getAnswerCnt(int brdID, int itemNo, int qstNo) throws Exception;
	
	public List<QstResponseVO> resultSubjectiveList(String brdID, String itemNo, String questionNo, int pTotalCnt, int pPageSize, String lang) throws Exception;
	
	public List<QstResponseVO> responseList(String brdID, String itemNo, String responseYN, int pTotalCnt, int pPageSize, String lang) throws Exception;
	
	public List<QstVO> getObjQuestion(String pBrdID, String pItemNo) throws Exception;
	
	public List<QstVO> getQuestion(String vBrdID, String vItemNo, String vQuesNo) throws Exception;
	
	public List<QstResponseVO> gwPollGetSearch(String vItemNo, String vQuesNo) throws Exception;
	
	public List<QstResponseVO> gwPollPositionSearch(String vItemNo, String vQuesNo) throws Exception;
	
	public List<QstResponseVO> gwPollJikgubSearch(String vItemNo, String vQuesNo) throws Exception;
	
	public List<QstResponseVO> getRespersonForResultTotalSave(int itemNo) throws Exception;
	
	public List<QstTempSaveVO> tempSave(int brdID, int itemNo) throws Exception;
	
	public String tableAnswerValue(int brdID, int itemNo, int questionNo) throws Exception;
	
	public QstResponsePersonVO getResponsePerson(QstResponsePersonVO qstResponsePersonVO) throws Exception;
	
	public QstUserPollItemVO getUserPollItem(QstUserPollItemVO qstUserPollItemVO) throws Exception;

	public QstUserPermissionVO getUserPermission(QstUserPermissionVO qstUserPermissionVO) throws Exception;
	
	public QstUserPermissionVO getResponseRange(QstUserPermissionVO qstUserPermissionVO) throws Exception;
	
	public QstAttachVO getAttachInfo2(String vBrdID, String vItemNo, String strQuestionNo, String strAnswer, String strAttID) throws Exception;
	
	public QstReuseQuestionVO reUseQuestionData (int brdID, int itemNo) throws Exception; 
	
	public QstVO getQuestionForSubjective(String brdID, String itemNo, String questionNo) throws Exception;
	
	public String getTableAnswer(int brdID, int itemNo, int questionNo) throws Exception;
	
	public String getResponseAnswer(int brdID, int itemNo, int questionNo) throws Exception;

	public String getItemSeq(String brdID) throws Exception;
	
	public String getReadDateItemForResult(QstUserPollItemVO qstUserPollItemVO, String userID) throws Exception;
	
	public int callGetItemSeq(int brdID) throws Exception;
	
	public Integer getQstListCnt(QstListVO qstListVO) throws Exception;

	public Integer getItemNoCnt(int brdID,int itemNo) throws Exception;

	public Integer getUserResponseCnt(QstUserPermissionVO userPermissionVO,String userID) throws Exception;

	public Integer getQuestionNo(int brdID,int itemNo) throws Exception;

	public Integer getResponseDateCnt(QstUserPermissionVO userPermissionVO, String userID) throws Exception;
	
	public Integer getReadDateItem(QstUserPollItemVO qstUserPollItemVO, String userID) throws Exception;

	public Integer resCount(String brdID,String itemNo) throws Exception;
	
	public Integer getAnsCnt(int brdID, int itemNo, int quesNo) throws Exception;
	
	public Integer getResponseMaxNo(int brdID, int itemNo, int questionNo) throws Exception;
	
	public Integer pollRespCnt(int brdID, int itemNo, int questionNo, int iAnsCnt) throws Exception;

	public Integer pollRespCnt2(int brdID, int itemNo, int questionNo, int iAnsCnt) throws Exception;
	
	public Integer getResPersonCnt(int brdID, int itemNo, int questionNo) throws Exception;
	
	public Integer resultSubjectiveListCnt(int brdID, int itemNo, int questionNo, String lang)throws Exception;
	
	public Integer responseListCnt(String brdID, String itemNo, String responseYN, String lang) throws Exception;
	
	public String getQuestionNoCnt(String itemNo) throws Exception;
	
	public String analysisCount(String vItemNo, String vQuesNo) throws Exception;
	
	public void stepSave(String pUserID, Map<String, Object> map) throws Exception;

	public void stepSave2(Map<String, Object> map) throws Exception;

	public void insertItemSeq(String brdID) throws Exception;
	
	public void insertQuestion(QstCompleteVO qstCompleteVO) throws Exception;
	
	public void insertAnswerAnswerContent(QstCompleteVO qstCompleteVO) throws Exception;

	public void insertAnswerContent(QstCompleteVO qstCompleteVO) throws Exception;
	
	public void insertItemRead(LoginVO loginVO, QstUserPollItemVO qstUserPollItemVO, String readDate) throws Exception;
	
	public void insertResponse(QstResponseVO qstResponseVO) throws Exception;

	public void insertResponse2(QstResponseVO qstResponseVO) throws Exception;
	
	public void callInsertItemSeq(int brdID) throws Exception;
	
	public void callCreateMother(QstCompleteVO qstCompleteVO) throws Exception;

	public void callInsertPollResponsep1(QstCompleteVO qstCompleteVO) throws Exception;

	public void callInsertPollResponseper(QstCompleteVO qstCompleteVO) throws Exception;
	
	public void pollSaveAttach(QstCompleteVO qstCompleteVO) throws Exception;
	
	public void callUpdateItemSeq(int brdID,int itemNo) throws Exception;

	public void updateItemSeq(int brdID,int itemNo) throws Exception;
	
	public void updatePollItem(QstCompleteVO qstCompleteVO) throws Exception;
	
	public void updateReadCnt(QstUserPollItemVO qstUserPollItemVO) throws Exception;

	public void updateReadDate(QstUserPollItemVO userPollItemVO, String readDate, String userID) throws Exception;
	
	public void updateResponsePerson(QstResponsePersonVO qstResponsePersonVO) throws Exception;
	
	public void updateResCnt(int brdID, int itemNo) throws Exception;
	
	public void updatePollEndDate(int brdID, int itemNo, String endDate, String endFlag) throws Exception;
	
	public void changePermission(QstUserPermissionVO qstUserPermissionVO, QstUserPollItemVO qstUserPollItemVO) throws Exception;
	
	public void callDeleteItemSeq(int brdID, int itemNo) throws Exception;
	
	public void deleteItem(QstCompleteVO qstCompleteVO) throws Exception;

	public void deletePermission(int brdID, int itemNo) throws Exception;
	
	public void callDeletePollResponseper(int brdID, int itemNo) throws Exception;
	
	public void questionDelete2(int brdID, int itemNo) throws Exception;
	
	public void questionDelete1(int brdID, int itemNo, int quesNo) throws Exception;
	
}