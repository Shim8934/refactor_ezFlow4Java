package egovframework.ezEKP.ezQuestion.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.ezEKP.ezQuestion.dao.EzQuestionDAO;
import egovframework.ezEKP.ezQuestion.service.EzQuestionService;
import egovframework.ezEKP.ezQuestion.vo.QuestionListVO;

@Service("EzQuestionService")
public class EzQuestionServiceImpl implements EzQuestionService{
	
	@Resource(name="EzQuestionDAO")
	private EzQuestionDAO ezQuestionDAO;

	@Override
	public int getQstListCnt(QuestionListVO questionListVO) throws Exception {
		// TODO Auto-generated method stub
		return ezQuestionDAO.getQstListCnt(questionListVO);
	}

	@Override
	public List<QuestionListVO> getQstList(QuestionListVO questionListVO)
			throws Exception {
		// TODO Auto-generated method stub
		return ezQuestionDAO.getQstList(questionListVO);
	}
}
