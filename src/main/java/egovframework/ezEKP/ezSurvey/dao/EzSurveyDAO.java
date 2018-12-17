package egovframework.ezEKP.ezSurvey.dao;

import java.util.List;
import java.util.Map;
import org.springframework.stereotype.Repository;
import egovframework.ezEKP.ezSurvey.vo.AttachVO;
import egovframework.ezEKP.ezSurvey.vo.OptionVO;
import egovframework.ezEKP.ezSurvey.vo.QuestionVO;
import egovframework.ezEKP.ezSurvey.vo.SimpleDeptVO;
import egovframework.ezEKP.ezSurvey.vo.SimpleUserVO;
import egovframework.ezEKP.ezSurvey.vo.SurveyGeneralVO;
import egovframework.ezEKP.ezSurvey.vo.SurveyItemSearchVO;
import egovframework.ezEKP.ezSurvey.vo.SurveyParticipantVO;
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
	
	public List<Long> getReceivedSurveyList(Map<String, Object> map) {
		return (List<Long>)list("EzSurveyDAO.getReceivedSurveyList", map);
	}
	
	public void saveSurveyItem(SurveyVO survey) {
		insert("EzSurveyDAO.saveSurveyItem", survey);
	}
	
	public long getMaxSurveyId(Map<String, Object> map) {
		return (long)select("EzSurveyDAO.getMaxSurveyId", map);
	}
	
	public long getMaxQuestionId(Map<String, Object> map) {
		return (long)select("EzSurveyDAO.getMaxQuestionId", map);
	}
	
	public void saveQuestionItem(QuestionVO question) {
		insert("EzSurveyDAO.saveQuestionItem", question);
	}
	
	public void saveOptionItem(OptionVO option) {
		insert("EzSurveyDAO.saveOptionItem", option);
	}
	
	public long getMaxOptionId(Map<String, Object> map) {
		return (long)select("EzSurveyDAO.getMaxOptionId", map);
	}
	
	public void saveAttachItem(AttachVO attach) {
		insert("EzSurveyDAO.saveAttachItem", attach);
	}
	
	public void saveSurveyUsers(SurveyParticipantVO surveyUser) {
		insert("EzSurveyDAO.saveSurveyUsers", surveyUser);
	}
	
	public int getTotalReceivedSurveyItemsCnt(SurveyItemSearchVO searchVO) {
		return (int)select("EzSurveyDAO.getTotalReceivedSurveyItemsCnt", searchVO);
	}
	
	public List<SurveyVO> getTotalReceivedSurveyItems(SurveyItemSearchVO searchVO) {
		return (List<SurveyVO>)list("EzSurveyDAO.getTotalReceivedSurveyItems", searchVO);
	}
	
	public void deleteItems(Map<String, Object> map) {
		update("EzSurveyDAO.deleteItems", map);
	}
}