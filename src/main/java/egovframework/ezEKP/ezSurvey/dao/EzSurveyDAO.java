package egovframework.ezEKP.ezSurvey.dao;

import java.util.List;
import java.util.Map;
import org.springframework.stereotype.Repository;
import egovframework.ezEKP.ezSurvey.vo.SimpleDeptVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@SuppressWarnings("unchecked")
@Repository("EzSurveyDAO")
public class EzSurveyDAO extends EgovAbstractDAO {
	public String getDeptPath(Map<String, Object> map) {
		return (String)select("EzSurveyDAO.getDeptPath", map);
	}
	
	public SimpleDeptVO getSimpleCompany(Map<String, Object> map) {
		return (SimpleDeptVO)select("EzSurveyDAO.getSimpleCompany", map);
	}
	
	public List<SimpleDeptVO> getAllSimpleSubDepts(Map<String, Object> map) {
		return (List<SimpleDeptVO>)list("EzSurveyDAO.getAllSimpleSubDepts", map);
	}
}

