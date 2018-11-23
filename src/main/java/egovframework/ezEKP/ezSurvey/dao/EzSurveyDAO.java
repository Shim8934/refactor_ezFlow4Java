package egovframework.ezEKP.ezSurvey.dao;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezSurvey.vo.SurveyVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzSurveyDAO")
public class EzSurveyDAO extends EgovAbstractDAO{

	private static final Logger Logger = LoggerFactory.getLogger(EzSurveyDAO.class);
	
	@SuppressWarnings("unchecked")
	public List<SurveyVO> getSurveyList(Map<String, Object> map) {
		
		List<SurveyVO> list = null;
		try {
			list = (List<SurveyVO>) list("EzSurveyDAO.getSurveyList", map);
		} catch (Exception e) {
			e.printStackTrace();
			
		}
		return list; 
	}

	public int getTotalCount(Map<String, Object> map) {
		return (int) select("EzSurveyDAO.getTotalCount", map);
	}

}
