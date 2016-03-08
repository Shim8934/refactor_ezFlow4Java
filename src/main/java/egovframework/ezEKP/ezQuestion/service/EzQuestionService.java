package egovframework.ezEKP.ezQuestion.service;

import java.util.List;

import egovframework.ezEKP.ezQuestion.vo.QuestionListVO;
import egovframework.ezEKP.ezQuestion.vo.UserPermissionVO;
import egovframework.ezEKP.ezQuestion.vo.UserPollItemVO;
	 
public interface EzQuestionService {
	public int getQstListCnt(QuestionListVO questionListVO) throws Exception;
	
	public List<QuestionListVO> getQstList(QuestionListVO questionListVO) throws Exception;
	
	public UserPollItemVO getUserPollItem(UserPollItemVO userPollItemVO) throws Exception;
	
	public UserPermissionVO getUserPermission(UserPermissionVO userPermissionVO) throws Exception;
	
	public int getUserResponseCnt(UserPermissionVO userPermissionVO) throws Exception;
	
}
