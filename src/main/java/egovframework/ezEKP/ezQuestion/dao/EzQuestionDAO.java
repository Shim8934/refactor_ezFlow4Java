package egovframework.ezEKP.ezQuestion.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezQuestion.vo.QuestionListVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzQuestionDAO")
public class EzQuestionDAO extends EgovAbstractDAO{
	
	public int getQstListCnt(Map<String, Object> map){
		select("EzQuestionDAO.getQstListCnt", map);
		return (int) map.get("v_pCount");
	}
	
	@SuppressWarnings("unchecked")
	public List<QuestionListVO> getQstList(Map<String, Object> map){
		return (List<QuestionListVO>) list("getQstList", map);
	}
}
