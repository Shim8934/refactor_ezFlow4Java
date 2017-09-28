package egovframework.ezEKP.ezPoll.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezPoll.vo.PollAnswerVO;
import egovframework.ezEKP.ezPoll.vo.PollQuestionVO;
import egovframework.ezEKP.ezPoll.vo.PollUserAnswerVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzPollDAO")
public class EzPollDAO extends EgovAbstractDAO{
	public String getQuestionSeq(Map<String, Object> map) {
		return (String)select("EzPollDAO.getQuestionSeq", map);
	}
	
	public String getModifyingUser(Map<String, Object> map) {
		return (String)select("EzPollDAO.getModifyingUser", map);
	}
	
	/*
	public int getNumberOfSeenUsers(Map<String, Object> map) {
		return (int)select("EzPollDAO.getNumberOfSeenUsers", map);
	}
	*/
	@SuppressWarnings("unchecked")
	public List<String> getNumberOfSeenUsers(Map<String, Object> map) {
		return (List<String>) list("EzPollDAO.getNumberOfSeenUsers", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<PollAnswerVO> getListOptionsOfQst(Map<String, Object> map) {
		return (List<PollAnswerVO>) list("EzPollDAO.getListOptionsOfQst", map);
	}	
	
	public void addAnswerAndUser(Map<String, Object> map) {
		insert("EzPollDAO.addAnswerAndUser", map);
	}	
	
	public void insertQuestion(Map<String, Object> map) {
		insert("EzPollDAO.insertQuestion", map);
	}
	public void insertQustReceivers(Map<String, Object> map) {
		insert("EzPollDAO.insertQustReceivers", map);
	}	
	public void insertOption(Map<String, Object> map) {
		insert("EzPollDAO.insertOption", map);
	}		
	public void insertHiddenQuestion(Map<String, Object> map) {
		insert("EzPollDAO.insertHiddenQuestion", map);
	}	
	public void insertModifyingQuestion(Map<String, Object> map) {
		insert("EzPollDAO.insertModifyingQuestion", map);
	}	
	public void insertSeenQuestion(Map<String, Object> map) {
		insert("EzPollDAO.insertSeenQuestion", map);
	}	
	public void insertCommentQuestion(Map<String, Object> map) {
		insert("EzPollDAO.insertCommentQuestion", map);
	}
	
	public void updateModifyingQuestionRelatedStatus(Map<String, Object> map) {
		update("EzPollDAO.updateModifyingQuestionRelatedStatus", map);
	}	
	
	public void updateNumberOfVotesForAnswer(Map<String, Object> map) {
		update("EzPollDAO.updateNumberOfVotesForAnswer", map);
	}	
	
	public void updateModifyingQuestion(Map<String, Object> map) {
		update("EzPollDAO.updateModifyingQuestion", map);
	}	
	
	public void updateEndDateForQst(Map<String, Object> map) {
		update("EzPollDAO.updateEndDateForQst", map);
	}		
	
	@SuppressWarnings("unchecked")
	public List<String> getListOfUserIdForQst(Map<String, Object> map) {		
		return (List<String>) list("EzPollDAO.getListOfUserIdForQst", map);
	}
	
	public int checkTargetOfQst(Map<String, Object> map) {		
		return (int) select("EzPollDAO.checkTargetOfQst", map);
	}		

	@SuppressWarnings("unchecked")
	public List<PollQuestionVO> getQuestionsTest(Map<String, Object> map) {		
		return (List<PollQuestionVO>) list("EzPollDAO.getQuestionsTest", map);
	}	
	
	@SuppressWarnings("unchecked")
	public List<PollQuestionVO> getAllQuestions(Map<String, Object> map) {		
		return (List<PollQuestionVO>) list("EzPollDAO.getAllQuestions", map);
	}	
	
	@SuppressWarnings("unchecked")
	public List<PollQuestionVO> getOwnQuestions(Map<String, Object> map) {		
		return (List<PollQuestionVO>) list("EzPollDAO.getOwnQuestions", map);
	}	
	
	@SuppressWarnings("unchecked")
	public List<PollUserAnswerVO> getPollUserAndAnswer(Map<String, Object> map) {		
		return (List<PollUserAnswerVO>) list("EzPollDAO.getPollUserAndAnswer", map);
	}	
	
	@SuppressWarnings("unchecked")
	public List<PollUserAnswerVO> getListVotedUsersForAnswer(Map<String, Object> map) {		
		return (List<PollUserAnswerVO>) list("EzPollDAO.getListVotedUsersForAnswer", map);
	}		
	
	@SuppressWarnings("unchecked")
	public List<PollQuestionVO> getQuestionByDeptId(Map<String, Object> map) {		
		return (List<PollQuestionVO>) list("EzPollDAO.getQuestionByDeptId", map);
	}	
	
	@SuppressWarnings("unchecked")
	public List<Integer> getHiddenQuestionIds(Map<String, Object> map) {		
		return (List<Integer>) list("EzPollDAO.getHiddenQuestionIds", map);
	}	
	
	public PollQuestionVO getQuestionByIdAndTenantId(Map<String, Object> map) {		
		return (PollQuestionVO) select("EzPollDAO.getQuestionByIdAndTenantId", map);
	}		
	
	public PollAnswerVO getAnswerByIdAndQstId(Map<String, Object> map) {		
		return (PollAnswerVO) select("EzPollDAO.getAnswerByIdAndQstId", map);
	}	
	
	
	public void deleteQuestions(Map<String, Object> map) {
		delete("EzPollDAO.deleteQuestions", map);
	}
	
	public void deleteUserAndAnswer(Map<String, Object> map) {
		delete("EzPollDAO.deleteUserAndAnswer", map);
	}
	
	public void deleteModifyingQuestionRelatedStatus(Map<String, Object> map) {
		delete("EzPollDAO.deleteModifyingQuestionRelatedStatus", map);
	}	
	
	public void deleteQuestionRelated(Map<String, Object> map) {
		delete("EzPollDAO.deleteQuestionRelated", map);
	}
	
	public void deleteAnswers(Map<String, Object> map) {
		delete("EzPollDAO.deleteAnswers", map);
	}
	
	public void deleteUserAndQuestion(Map<String, Object> map) {
		delete("EzPollDAO.deleteUserAndQuestion", map);
	}	
	
	public void removeAnswerAndUser(Map<String, Object> map) {
		delete("EzPollDAO.removeAnswerAndUser", map);
	}
	
}
