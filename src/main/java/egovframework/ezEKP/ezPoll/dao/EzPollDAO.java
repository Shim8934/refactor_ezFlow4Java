package egovframework.ezEKP.ezPoll.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezPoll.vo.PollAnswerVO;
import egovframework.ezEKP.ezPoll.vo.PollCommentVO;
import egovframework.ezEKP.ezPoll.vo.PollQuestionVO;
import egovframework.ezEKP.ezPoll.vo.PollUserAnswerVO;
import egovframework.ezEKP.ezPoll.vo.PollUserVO;
import egovframework.let.user.login.vo.LoginVO;
import org.egovframe.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzPollDAO")
public class EzPollDAO extends EgovAbstractDAO {
	public String getQuestionSeq(Map<String, Object> map) {
		return (String)select("EzPollDAO.getQuestionSeq", map);
	}
	
	public String getModifyingUser(Map<String, Object> map) {
		return (String)select("EzPollDAO.getModifyingUser", map);
	}

	@SuppressWarnings("unchecked")
	public List<String> getNumberOfSeenUsers(Map<String, Object> map) {
		return (List<String>) list("EzPollDAO.getNumberOfSeenUsers", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<PollAnswerVO> getListOptionsOfQst(Map<String, Object> map) {
		return (List<PollAnswerVO>) list("EzPollDAO.getListOptionsOfQst", map);
	}	
	
	@SuppressWarnings("unchecked")
	public List<PollCommentVO> getListCmtOfQst(Map<String, Object> map) {
		return (List<PollCommentVO>) list("EzPollDAO.getListCmtOfQst", map);
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
	
	public void insertCmt(Map<String, Object> map) {
		insert("EzPollDAO.insertCmt", map);
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
	
	public void unhideQuestion(Map<String, Object> map) {
		update("EzPollDAO.unhideQuestion", map);
	}	
	
	public void updateModifyingQuestion(Map<String, Object> map) {
		update("EzPollDAO.updateModifyingQuestion", map);
	}	
	
	public void updateEndDateForQst(Map<String, Object> map) {
		update("EzPollDAO.updateEndDateForQst", map);
	}	
	
	public void updateCmt(Map<String, Object> map) {
		update("EzPollDAO.updateCmt", map);
	}	
	
	@SuppressWarnings("unchecked")
	public List<String> getListOfUserIdForQst(Map<String, Object> map) {		
		return (List<String>) list("EzPollDAO.getListOfUserIdForQst", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<PollUserVO> getListOfUserForQst(Map<String, Object> map) {		
		return (List<PollUserVO>) list("EzPollDAO.getListOfUserForQst", map);
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
	
	public void deleteCommentOfQst(Map<String, Object> map) {
		delete("EzPollDAO.deleteCommentOfQst", map);
	}	
	
	public void deleteSpecificCmt(Map<String, Object> map) {
		delete("EzPollDAO.deleteSpecificCmt", map);
	}
	
	public void deleteUserAndQuestion(Map<String, Object> map) {
		delete("EzPollDAO.deleteUserAndQuestion", map);
	}	
	
	public void removeAnswerAndUser(Map<String, Object> map) {
		delete("EzPollDAO.removeAnswerAndUser", map);
	}

	public PollUserAnswerVO getSpecificPollUserAndAnswer(Map<String, Object> map) {		
		return (PollUserAnswerVO) select("EzPollDAO.getSpecificPollUserAndAnswer", map);
	}	
	
	public int checkUsingFile(Map<String, Object> map) {		
		return (int) select("EzPollDAO.checkUsingFile", map);
	}
	
	public int checkQstUsingFile(Map<String, Object> map) {		
		return (int) select("EzPollDAO.checkQstUsingFile", map);
	}
	
	public String getQuestionFileById(Map<String, Object> map) {		
		return (String) select("EzPollDAO.getQuestionFileById", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<String> getAnswerFilesByQstId(Map<String, Object> map) {		
		return (List<String>) list("EzPollDAO.getAnswerFilesByQstId", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<String> getCommentFilesByQstId(Map<String, Object> map) {		
		return (List<String>) list("EzPollDAO.getCommentFilesByQstId", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<String> getCommentImgFilesByQstId(Map<String, Object> map) {		
		return (List<String>) list("EzPollDAO.getCommentImgFilesByQstId", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<PollUserVO> getListOfUserIdForQstByQstId(Map<String, Object> map) {		
		return (List<PollUserVO>) list("EzPollDAO.getListOfUserIdForQstByQstId", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<PollQuestionVO> getOpenToAllQuestion(Map<String, Object> map) {		
		return (List<PollQuestionVO>) list("EzPollDAO.getOpenToAllQuestion", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<PollUserVO> getAllUsersForQst(Map<String, Object> map) {
		return (List<PollUserVO>) list("EzPollDAO.getAllUsersForQst", map);
	}	
	
	@SuppressWarnings("unchecked")
	public List<LoginVO> getQstAllUsers(Map<String, Object> map) {
		return (List<LoginVO>) list("EzPollDAO.getQstAllUsers", map);
	}	
	
	@SuppressWarnings("unchecked")
	public List<LoginVO> getInfoOfSeenUsers(Map<String, Object> map) {
		return (List<LoginVO>) list("EzPollDAO.getInfoOfSeenUsers", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<LoginVO> getUserInfoM(Map<String, Object> map) {
		return (List<LoginVO>) list("EzPollDAO.getUserInfoM", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<LoginVO> getUserInfoMRD(Map<String, Object> map) {
		return (List<LoginVO>) list("EzPollDAO.getUserInfoMRD", map);
	}

	public String getAddJobDept(Map<String, Object> map) {
		return (String) select("EzPollDAO.getAddJobDept", map);
	}
	
	public PollUserVO getIsQuestionUser(Map<String, Object> map) {
		return (PollUserVO) select("EzPollDAO.getIsQuestionUser", map);
	}
	
	public String getQuestionRelatedDept(Map<String, Object> map) {
		return (String) select("EzPollDAO.getQuestionRelatedDept", map);
	}
	
	public String getContent(Map<String, Object> map) {
		return (String) select("EzPollDAO.getContent", map);
	}

	public PollCommentVO getCmtFile(Map<String, Object> map) {
		return (PollCommentVO) select("EzPollDAO.getCmtFile", map);
	}

}
