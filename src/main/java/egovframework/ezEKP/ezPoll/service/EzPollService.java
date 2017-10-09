package egovframework.ezEKP.ezPoll.service;

import java.util.List;

import egovframework.ezEKP.ezPoll.vo.PollAnswerVO;
import egovframework.ezEKP.ezPoll.vo.PollCommentVO;
import egovframework.ezEKP.ezPoll.vo.PollQuestionStatusVO;
import egovframework.ezEKP.ezPoll.vo.PollQuestionVO;
import egovframework.ezEKP.ezPoll.vo.PollUserAnswerVO;



public interface EzPollService {
	
	public String getQuestionSeq(int tenantID) throws Exception;
	
	public void insertQuestion(PollQuestionVO pollQuestionVO) throws Exception;
	
	public void insertQustReceivers(PollQuestionVO pollQuestionVO) throws Exception;
	
	public void insertOption(PollAnswerVO pollAnswerVO) throws Exception;
	
	public List<String> getListOfUserIdForQst(int qstId, int tenantID, String type) throws Exception;
	
	public int checkTargetOfQst(int qstId, int tenantID) throws Exception;

	//public List<PollQuestionVO> getQuestionsForACompany(String userID, String companyID, int tenantID) throws Exception;

	public List<PollQuestionVO> getQuestionByDeptId(String dept_id, int tenantID) throws Exception;

	public List<PollQuestionVO> getQuestionsTest(String userID, String deptPath, String companyID, int tenantID, String searchStr) throws Exception;

	public List<Integer> getHiddenQuestionIds(String userID, int tenantId) throws Exception;

	public void insertHiddenQuestion(PollQuestionStatusVO pollQstStatusVO) throws Exception;	

	public void insertModifyingQuestion(PollQuestionStatusVO pollQstStatusVO) throws Exception;

	public void insertSeenQuestion(PollQuestionStatusVO pollQstStatusVO) throws Exception;

	public void insertCommentQuestion(PollQuestionStatusVO pollQstStatusVO) throws Exception;

	public List<PollQuestionVO> getOwnQuestions(String userID, int tenantID, String searchStr) throws Exception;

	public PollQuestionVO getQuestionByIdAndTenantId(int qstId, int tenantId) throws Exception;

	public void deleteQuestions(int qstId, int tenantId) throws Exception;

	public void deleteUserAndAnswer(int qstId, int tenantId) throws Exception;

	public void deleteQuestionRelated(int qstId, int tenantId) throws Exception;

	public void deleteAnswers(int qstId, int tenantId) throws Exception;

	public void deleteUserAndQuestion(int qstId, int tenantId) throws Exception;
	
	public List<String> getNumberOfSeenUsers(int qstId, int tenantId) throws Exception;

	public List<PollUserAnswerVO> getPollUserAndAnswer(int qstId, int tenantId) throws Exception;

	public List<PollAnswerVO> getListOptionsOfQst(int qstId, int tenantId) throws Exception;

	public void addAnswerAndUser(PollUserAnswerVO pollUserAnswer) throws Exception;

	public void removeAnswerAndUser(PollUserAnswerVO pollUserAnswer) throws Exception;

	public void updateNumberOfVotesForAnswer(PollUserAnswerVO pollUserAnswer, int value) throws Exception;

	public List<PollUserAnswerVO> getListVotedUsersForAnswer(int optId,	int qstId, int tenantId) throws Exception;

	public PollAnswerVO getAnswerByIdAndQstId(int optId, int qstId, int tenantId) throws Exception;

	public void updateEndDateForQst(int qstId, int tenantId, String dateNow) throws Exception;

	public List<PollQuestionVO> getAllQuestions(int tenantID, String searchStr) throws Exception;

	public void updateModifyingQuestion(int qstId, int tenantId, int value) throws Exception;

	public void updateModifyingQuestionRelatedStatus(PollQuestionStatusVO pollQstStatusVO) throws Exception;

	public void deleteModifyingQuestionRelatedStatus(PollQuestionStatusVO pollQstStatusVO) throws Exception;

	public String getModifyingUser(int tenantId, int qstId) throws Exception;

	public List<PollCommentVO> getListCmtOfQst(int qstId, int tenantId) throws Exception;

	public void insertCmt(PollCommentVO pollCmtVO) throws Exception;

	public void deleteCommentOfQst(int qstId, int tenantId) throws Exception;
	
}
