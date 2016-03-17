package egovframework.ezEKP.ezQuestion.service;

import java.util.Date;
import java.util.List;
import java.util.Map;

import egovframework.ezEKP.ezQuestion.vo.QstCompleteVO;
import egovframework.ezEKP.ezQuestion.vo.QstListVO;
import egovframework.ezEKP.ezQuestion.vo.QstVO;
import egovframework.ezEKP.ezQuestion.vo.QstUserPermissionVO;
import egovframework.ezEKP.ezQuestion.vo.QstUserPollItemVO;
import egovframework.let.user.login.vo.LoginVO;

	 
public interface EzQuestionService {

	public int getQstListCnt(QstListVO qstListVO) throws Exception;

	public List<QstListVO> getQstList(QstListVO qstListVO) throws Exception;

	public int getItemNoCnt(int brdId,int itemNo) throws Exception;
	
	public String getItemSeq(String brdId) throws Exception;
	
	public void stepSave(String pUserID, Map<String, Object> map) throws Exception;
	
	public void stepSave2(Map<String, Object> map) throws Exception;
	
	public void insertItemSeq(String brdId) throws Exception;
	
	public void updateItemSeq(int brdId,int itemNo) throws Exception;
	
	public QstUserPollItemVO getUserPollItem(QstUserPollItemVO userPollItemVO) throws Exception;
	
	public QstUserPermissionVO getUserPermission(QstUserPermissionVO userPermissionVO) throws Exception;
	
	public int getUserResponseCnt(QstUserPermissionVO userPermissionVO) throws Exception;
	
	public List<String> getUserIdAdmin(String brd) throws Exception;
	
	public void callCreateMother(QstCompleteVO qstCompleteVO) throws Exception;
	
	public void callInsertPollResponsep1(QstCompleteVO qstCompleteVO) throws Exception;
	
	public void callInsertPollResponseper(QstCompleteVO qstCompleteVO) throws Exception;
	
	public int getQuestionNo(int brdId,int itemNo) throws Exception;
	
	public void insertQuestion(QstCompleteVO qstCompleteVO) throws Exception;
	
	public void pollSaveAttach(QstCompleteVO qstCompleteVO) throws Exception;
	
	public void insertAnswerAnswerContent(QstCompleteVO qstCompleteVO) throws Exception;
	
	public void insertAnswerContent(QstCompleteVO qstCompleteVO) throws Exception;
	
	public void updatePollItem(QstCompleteVO qstCompleteVO) throws Exception;
	
	public void deleteItem(QstCompleteVO qstCompleteVO) throws Exception;

	public int getResponseDateCnt(QstUserPermissionVO userPermissionVO, String userId);

	public int resCount(String brdId,String itemNo);

	public void updateReadCnt(QstUserPollItemVO userPollItemVO);

	public int getReadDateItem(QstUserPollItemVO qstUserPollItemVO, String userId);
	
	public void updateReadDate(QstUserPollItemVO userPollItemVO, String readDate, String userId);

	public List<QstVO> getQuestionForResponse(QstVO questionVO);

	public void insertItemRead(LoginVO loginVO, QstUserPollItemVO qstUserPollItemVO, String readDate);
}
