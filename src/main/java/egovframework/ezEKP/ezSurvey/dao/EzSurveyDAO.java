package egovframework.ezEKP.ezSurvey.dao;

import java.util.List;
import java.util.Map;
import org.springframework.stereotype.Repository;
import egovframework.ezEKP.ezSurvey.vo.SimpleDeptVO;
import egovframework.ezEKP.ezSurvey.vo.SimpleUserVO;
import egovframework.ezEKP.ezSurvey.vo.SurveyGeneralVO;
import egovframework.ezEKP.ezSurvey.vo.SurveyVO;
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
	
	public int getTotalDeptMembers(Map<String, Object> map) {
		return (int)select("EzSurveyDAO.getTotalDeptMembers", map);
	}
	
	public List<SimpleUserVO> getDeptMemberList(Map<String, Object> map) {
		return (List<SimpleUserVO>)list("EzSurveyDAO.getDeptMemberList", map);
	}
	
	public int getTotalSearchMembers(Map<String, Object> map) {
		return (int)select("EzSurveyDAO.getTotalSearchMembers", map);
	}
	
	public SurveyGeneralVO getUserPreviewConfig(Map<String, Object> map) {
		return (SurveyGeneralVO)select("EzSurveyDAO.getUserPreviewConfig", map);
	}
	
	public void saveUserConfig(Map<String, Object> map) {
		insert("EzSurveyDAO.saveUserConfig", map);
	}
	
	public List<SimpleUserVO> getSearchMemberList(Map<String, Object> map) {
		return (List<SimpleUserVO>)list("EzSurveyDAO.getSearchMemberList", map);
	}
	
	public List<SurveyVO> getSurveyListForPermission(Map<String, Object> map) {
		return (List<SurveyVO>)list("EzSurveyDAO.getSurveyListForPermission", map);
	}
	
	public List<String> getUserDepartmentIdList(Map<String, Object> map) {
		return (List<String>)list("EzSurveyDAO.getUserDepartmentIdList", map);
	}

	public List<SurveyVO> getReceivedSurveyListForPermission(Map<String, Object> map) {
		return (List<SurveyVO>)list("EzSurveyDAO.getReceivedSurveyListForPermission", map);
	}
}

