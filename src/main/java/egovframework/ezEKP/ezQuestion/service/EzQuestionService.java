package egovframework.ezEKP.ezQuestion.service;

import java.util.List;
import java.util.Map;

import egovframework.ezEKP.ezQuestion.vo.QstCompleteVO;
import egovframework.ezEKP.ezQuestion.vo.QuestionListVO;
import egovframework.ezEKP.ezQuestion.vo.UserPermissionVO;
import egovframework.ezEKP.ezQuestion.vo.UserPollItemVO;
	 
public interface EzQuestionService {
	public int getQstListCnt(QuestionListVO questionListVO) throws Exception;
	
	public List<QuestionListVO> getQstList(QuestionListVO questionListVO) throws Exception;
	
	public int getItemNoCnt(int brdId,int itemNo) throws Exception;
	
	public String getItemSeq(String brdId) throws Exception;
	
	public void stepSave(String pUserID, Map<String, Object> map) throws Exception;
	
	public void stepSave2(Map<String, Object> map) throws Exception;
	
	public void insertItemSeq(String brdId) throws Exception;
	
	public void updateItemSeq(int brdId,int itemNo) throws Exception;
	
	public UserPollItemVO getUserPollItem(UserPollItemVO userPollItemVO) throws Exception;
	
	public UserPermissionVO getUserPermission(UserPermissionVO userPermissionVO) throws Exception;
	
	public int getUserResponseCnt(UserPermissionVO userPermissionVO) throws Exception;
	
	public List<String> getUserIdAdmin(String brd) throws Exception;
	
	public void callCreateMother(QstCompleteVO qstCompleteVO) throws Exception;
	
	public void callInsertPollResponsep1(QstCompleteVO qstCompleteVO) throws Exception;
	
	public void callInsertPollResponseper(QstCompleteVO qstCompleteVO) throws Exception;
	
	public int getQuestionNo(QstCompleteVO qstCompleteVO) throws Exception;
	
	public void insertQuestion(QstCompleteVO qstCompleteVO) throws Exception;
	
	public void pollSaveAttach(QstCompleteVO qstCompleteVO) throws Exception;
	
	public void insertAnswerAnswerContent(QstCompleteVO qstCompleteVO) throws Exception;
	
	public void insertAnswerContent(QstCompleteVO qstCompleteVO) throws Exception;
	
	public void updatePollItem(QstCompleteVO qstCompleteVO) throws Exception;
	
	public void deleteItem(QstCompleteVO qstCompleteVO) throws Exception;
	
	
}
