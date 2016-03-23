package egovframework.ezEKP.ezQuestion.service;

import java.util.List;
import java.util.Map;

import egovframework.ezEKP.ezQuestion.vo.QstAnswerVO;
import egovframework.ezEKP.ezQuestion.vo.QstAttachVO;
import egovframework.ezEKP.ezQuestion.vo.QstCompleteVO;
import egovframework.ezEKP.ezQuestion.vo.QstListVO;
import egovframework.ezEKP.ezQuestion.vo.QstResponsePersonVO;
import egovframework.ezEKP.ezQuestion.vo.QstUserPermissionVO;
import egovframework.ezEKP.ezQuestion.vo.QstUserPollItemVO;
import egovframework.ezEKP.ezQuestion.vo.QstVO;
import egovframework.let.user.login.vo.LoginVO;

public interface EzQuestionService {

	public List<QstListVO> getQstList(QstListVO qstListVO) throws Exception;

	public List<QstVO> getQuestionForResponse(QstVO questionVO) throws Exception;
	
	public List<QstAttachVO> getAttachInfo(QstAttachVO qstAttachVO) throws Exception;

	public List<String> getUserIdAdmin(int brd) throws Exception;
	
	public List<QstAnswerVO> getAnswerAnswerCnt(int brdId, int itemNo, int qstNo) throws Exception;
	
	public List<QstAnswerVO> getAnswerCnt(int brdId, int itemNo, int qstNo) throws Exception;
	
	public QstResponsePersonVO getResponsePerson(QstResponsePersonVO qstResponsePersonVO) throws Exception;
	
	public QstUserPollItemVO getUserPollItem(QstUserPollItemVO qstUserPollItemVO) throws Exception;

	public QstUserPermissionVO getUserPermission(QstUserPermissionVO qstUserPermissionVO) throws Exception;
	
	public QstUserPermissionVO getResponseRange(QstUserPermissionVO qstUserPermissionVO) throws Exception;

	public String getItemSeq(String brdId) throws Exception;

	public int getQstListCnt(QstListVO qstListVO) throws Exception;

	public int getItemNoCnt(int brdId,int itemNo) throws Exception;

	public int getUserResponseCnt(QstUserPermissionVO userPermissionVO,String userId) throws Exception;

	public int getQuestionNo(int brdId,int itemNo) throws Exception;

	public int getResponseDateCnt(QstUserPermissionVO userPermissionVO, String userId) throws Exception;
	
	public int getReadDateItem(QstUserPollItemVO qstUserPollItemVO, String userId) throws Exception;

	public int resCount(String brdId,String itemNo) throws Exception;
	
	public Integer getResponseMaxNo(int brdId, int itemNo, int questionNo) throws Exception;

	public void stepSave(String pUserID, Map<String, Object> map) throws Exception;

	public void stepSave2(Map<String, Object> map) throws Exception;

	public void insertItemSeq(String brdId) throws Exception;
	
	public void insertQuestion(QstCompleteVO qstCompleteVO) throws Exception;
	
	public void insertAnswerAnswerContent(QstCompleteVO qstCompleteVO) throws Exception;

	public void insertAnswerContent(QstCompleteVO qstCompleteVO) throws Exception;
	
	public void insertItemRead(LoginVO loginVO, QstUserPollItemVO qstUserPollItemVO, String readDate) throws Exception;
	
	public void callCreateMother(QstCompleteVO qstCompleteVO) throws Exception;

	public void callInsertPollResponsep1(QstCompleteVO qstCompleteVO) throws Exception;

	public void callInsertPollResponseper(QstCompleteVO qstCompleteVO) throws Exception;
	
	public void pollSaveAttach(QstCompleteVO qstCompleteVO) throws Exception;

	public void updateItemSeq(int brdId,int itemNo) throws Exception;
	
	public void updatePollItem(QstCompleteVO qstCompleteVO) throws Exception;
	
	public void updateReadCnt(QstUserPollItemVO qstUserPollItemVO) throws Exception;

	public void updateReadDate(QstUserPollItemVO userPollItemVO, String readDate, String userId) throws Exception;
	
	public void updateResponsePerson(QstResponsePersonVO qstResponsePersonVO) throws Exception;
	
	public void updateResCnt(int brdId, int itemNo) throws Exception;

	public void deleteItem(QstCompleteVO qstCompleteVO) throws Exception;

	
}