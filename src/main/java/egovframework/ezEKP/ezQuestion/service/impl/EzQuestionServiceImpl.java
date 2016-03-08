package egovframework.ezEKP.ezQuestion.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.ezEKP.ezQuestion.dao.EzQuestionDAO;
import egovframework.ezEKP.ezQuestion.service.EzQuestionService;
import egovframework.ezEKP.ezQuestion.vo.QuestionListVO;

@Service("EzQuestionService")
public class EzQuestionServiceImpl implements EzQuestionService{
	
	@Resource(name="EzQuestionDAO")
	private EzQuestionDAO ezQuestionDAO;
	
	Map<String, Object> map;
	
	@Override
	public int getQstListCnt(QuestionListVO questionListVO) throws Exception {
		map = new HashMap<String, Object>();
		map.put("v_PSTRBRDID", questionListVO.getBrdId());
		map.put("v_PUSERID", questionListVO.getUserId());
		map.put("v_PTITLE", questionListVO.getTitle());
		map.put("v_PRANGE", questionListVO.getResponseRange());
		map.put("v_PSDATE", questionListVO.getPostDate());
		map.put("v_PEDATE", questionListVO.getPollEndDate());
		map.put("v_PLANG", questionListVO.getLang());
		return ezQuestionDAO.getQstListCnt(map);
	}

	@Override
	public List<QuestionListVO> getQstList(QuestionListVO questionListVO) throws Exception {
		map = new HashMap<String, Object>();
		map.put("v_PSTRBRDID", questionListVO.getBrdId());
		map.put("v_PUSERID", questionListVO.getUserId());
		map.put("v_PTOTALCNT", questionListVO.getTotalCnt()-(questionListVO.getCurrPage()-1)*questionListVO.getPageSize());
		map.put("v_PPAGESIZE", questionListVO.getPageSize());
		map.put("v_PTITLE", questionListVO.getTitle());
		map.put("v_PRANGE", questionListVO.getResponseRange());
		map.put("v_PSDATE", questionListVO.getPostDate());
		map.put("v_PEDATE", questionListVO.getPollEndDate());
		map.put("v_PLANG", questionListVO.getLang());
		return ezQuestionDAO.getQstList(map);
	}
}
