package egovframework.ezEKP.ezQuestion.service;

import java.util.List;

import egovframework.ezEKP.ezQuestion.vo.QuestionListVO;
	 
public interface EzQuestionService {
	public int getQstListCnt(QuestionListVO questionListVO) throws Exception;
	
	public List<QuestionListVO> getQstList(QuestionListVO questionListVO) throws Exception;
}
