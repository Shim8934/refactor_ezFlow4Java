package egovframework.ezEKP.ezPoll.service;

import java.util.List;
import java.util.Map;
import java.util.Set;

import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.ezEKP.ezPoll.vo.PollAnswerVO;
import egovframework.ezEKP.ezPoll.vo.PollCommentVO;
import egovframework.ezEKP.ezPoll.vo.PollQuestionStatusVO;
import egovframework.ezEKP.ezPoll.vo.PollQuestionVO;
import egovframework.ezEKP.ezPoll.vo.PollUserAnswerVO;
import egovframework.ezEKP.ezPoll.vo.PollUserVO;
import egovframework.let.user.login.vo.LoginVO;

public interface EzPollService {	
	public String getQuestionSeq(int tenantID) throws Exception;
	
	public void insertQuestion(PollQuestionVO pollQuestionVO) throws Exception;
	
	public void insertQustReceivers(PollQuestionVO pollQuestionVO) throws Exception;
	
	public void insertOption(PollAnswerVO pollAnswerVO) throws Exception;
	
	public List<String> getListOfUserIdForQst(int qstId, int tenantID, String type) throws Exception;
	
	public List<PollUserVO> getListOfUserForQst(int qstId, int tenantID, String type) throws Exception;
	
	public int checkTargetOfQst(int qstId, int tenantID) throws Exception;

	public List<PollQuestionVO> getQuestionByDeptId(String dept_id, int tenantID) throws Exception;

	public List<PollQuestionVO> getQuestionsTest(String userID, String deptPath, String companyID, String deptID, int tenantID, String searchStr, String primary, String mode) throws Exception;

	public List<Integer> getHiddenQuestionIds(String userID, int tenantId, String companyID) throws Exception;

	public void insertHiddenQuestion(PollQuestionStatusVO pollQstStatusVO) throws Exception;	

	public void insertModifyingQuestion(PollQuestionStatusVO pollQstStatusVO, String companyID) throws Exception;

	public void insertSeenQuestion(PollQuestionStatusVO pollQstStatusVO, String companyID) throws Exception;

	public void insertCommentQuestion(PollQuestionStatusVO pollQstStatusVO) throws Exception;

	public List<PollQuestionVO> getOwnQuestions(String userID, int tenantID, String searchStr, String primary, String mode, String companyID) throws Exception;

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

	public List<PollQuestionVO> getAllQuestions(int tenantID, String searchStr, String primary, String mode, String companyID, String userID) throws Exception;

	public void updateModifyingQuestion(int qstId, int tenantId, int value) throws Exception;

	public void updateModifyingQuestionRelatedStatus(PollQuestionStatusVO pollQstStatusVO) throws Exception;

	public void deleteModifyingQuestionRelatedStatus(PollQuestionStatusVO pollQstStatusVO) throws Exception;

	public String getModifyingUser(int tenantId, int qstId) throws Exception;

	public List<PollCommentVO> getListCmtOfQst(int qstId, int tenantId) throws Exception;

	public void insertCmt(PollCommentVO pollCmtVO) throws Exception;

	public void deleteCommentOfQst(int qstId, int tenantId) throws Exception;

	public void updateCmt(PollCommentVO pollCmtVO) throws Exception;

	public void deleteSpecificCmt(int cmtId, int qstId, int tenantId) throws Exception;

	public void getAllQuestionForUser(LoginVO loginVO, Set<PollQuestionVO> setOfQuestions, String searchStr, String mode) throws Exception;
	
	public void getAllQuestionForUser2(LoginVO loginVO, Set<PollQuestionVO> setOfQuestions, String searchStr, String mode) throws Exception;

	public void unhideQuestion(String qstID, String userID, int tenantId) throws Exception;

	public PollUserAnswerVO getSpecificPollUserAndAnswer(int optId, int qstId, String id, int tenantId) throws Exception;	
	
	public int checkUsingFile(int tenantID, String FilePath) throws Exception;
	
	public int checkQstUsingFile(int tenantID, int qstId, String FilePath) throws Exception;
	
	public void deleteAllFilesByQstId(int tenantID, int qstId, String pDirPath, String realPath) throws Exception;
	
	public void deleteQstFiles(Map<String, Object> map) throws Exception;
	
	public void deleteAnsFiles(Map<String, Object> map) throws Exception;
	
	public void deleteCmtFiles(Map<String, Object> map) throws Exception;
	
	public void sendPostNotiMail(LoginVO userInfo, String loginCookie, PollQuestionVO pollQuestion) throws Exception;
	
	public OrganUserVO getRetireEntryInfo(String cn, String lang, int tenantID) throws Exception;
	
	public void getAllMemberOfDept(List<LoginVO> list, String deptId, int tenantID) throws Exception;
	
	public void getAllUserForQuestion(LoginVO loginVO, int questionID, Set<LoginVO> set) throws Exception;

	public List<PollUserVO> getAllUsersForQst(int tenantId, int qstId) throws Exception;
	
	public List<LoginVO> getQstAllUsers(int tenantId, int qstId) throws Exception;
	
	public List<LoginVO> getInfoOfSeenUsers(int tenantId, int qstId, String companyID) throws Exception;
	
	public List<LoginVO> getAllUsersInfoForQstM(int tenantId, int qstId, String companyID) throws Exception;
	
	public List<LoginVO> getAllUsersInfoForQstMRD(int tenantId, int qstId) throws Exception;
	
	public String getAddJobDept(int tenantId, int qstId, String userId, String deptId) throws Exception;
	
	public String getQuestionRelatedDept(int tenantId, int qstId, String userId, String deptId) throws Exception;

	public String getContent(int qstId, int tenantId) throws Exception;

	public void deleteQstImages(Map<String, Object> map) throws Exception;

	public PollCommentVO getCmtFileType(int cmtId, int qstId, int tenantID) throws Exception;
}
