package egovframework.ezEKP.ezPoll.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezPoll.dao.EzPollDAO;
import egovframework.ezEKP.ezPoll.service.EzPollService;
import egovframework.ezEKP.ezPoll.vo.PollAnswerVO;
import egovframework.ezEKP.ezPoll.vo.PollCommentVO;
import egovframework.ezEKP.ezPoll.vo.PollQuestionStatusVO;
import egovframework.ezEKP.ezPoll.vo.PollQuestionVO;
import egovframework.ezEKP.ezPoll.vo.PollUserAnswerVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Service("EzPollService")
public class EzPollServiceImpl implements EzPollService{
	@Resource(name = "EzPollDAO")
	private EzPollDAO ezPollDAO;
	
	@Resource(name="EzCommonService")
	private EzCommonService ezCommonService;
	
	@Autowired
	private CommonUtil commonUtil;

	@Override
	public String getQuestionSeq(int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();		
		map.put("tenantID", tenantID);
		return ezPollDAO.getQuestionSeq(map);		
	}

	@Override
	public void insertQuestion(PollQuestionVO pollQuestionVO) throws Exception {
		// TODO Auto-generated method stub
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("id", pollQuestionVO.getQstId());		
		map.put("tenant_id", pollQuestionVO.getTenantId());
		map.put("content", pollQuestionVO.getContent());
		map.put("multi_select", pollQuestionVO.getMultiSelect());
		map.put("start_date", pollQuestionVO.getStartDate());
		map.put("end_date", pollQuestionVO.getEndDate());
		map.put("target", pollQuestionVO.getTarget());
		map.put("title", pollQuestionVO.getTitle());
		map.put("secret_vote", pollQuestionVO.getSecretVote());
		map.put("creator", pollQuestionVO.getCreator());
		map.put("creator_name", pollQuestionVO.getCreatorName());
		map.put("file_path", pollQuestionVO.getFilePath());	
		map.put("result_first", pollQuestionVO.getResultFirst());	
		ezPollDAO.insertQuestion(map);
	}

	@Override
	public void insertQustReceivers(PollQuestionVO pollQuestionVO)
			throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("qst_id", pollQuestionVO.getQstId());		
		map.put("user_id", pollQuestionVO.getUserId());
		map.put("tenant_id", pollQuestionVO.getTenantId());
		map.put("type", pollQuestionVO.getReceiverType());
		ezPollDAO.insertQustReceivers(map);
	}

	@Override
	public void insertOption(PollAnswerVO pollAnswerVO) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("id", pollAnswerVO.getAnsId());
		map.put("qst_id", pollAnswerVO.getQstId());			
		map.put("tenant_id", pollAnswerVO.getTenantId());
		map.put("content", pollAnswerVO.getContent());
		map.put("vote_number", pollAnswerVO.getVotesNumber());
		ezPollDAO.insertOption(map);
	}

	@Override
	public List<String> getListOfUserIdForQst(int qstId, int tenantID, String type) throws Exception {		
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("qst_id", qstId);
		map.put("tenantID", tenantID);
		map.put("type", type);
		return (List<String>) ezPollDAO.getListOfUserIdForQst(map);
	}

	@Override
	public int checkTargetOfQst(int qstId, int tenantID) throws Exception {		
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("qst_id", qstId);
		map.put("tenantID", tenantID);
		return ezPollDAO.checkTargetOfQst(map);
	}

/*	@Override
	public List<PollQuestionVO> getQuestionsForACompany(String userID, String companyID,
			int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("user_id", userID);
		map.put("company_id", companyID);
		map.put("tenant_id", tenantID);
		return ezPollDAO.getQuestions(map);		
	}*/

	@Override
	public List<PollQuestionVO> getQuestionByDeptId(String dept_id, int tenantID)
			throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("dept_id", dept_id);
		map.put("tenant_id", tenantID);
		return ezPollDAO.getQuestionByDeptId(map);	
	}

	@Override
	public List<PollQuestionVO> getQuestionsTest(String userID, String deptPath, String companyID, int tenantID, String searchStr) throws Exception {		
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("user_id", userID);
		map.put("v_deptPath", deptPath);
		map.put("company_id", companyID);
		map.put("tenant_id", tenantID);	
		map.put("search_str", searchStr);	
		return ezPollDAO.getQuestionsTest(map);		

	}

	@Override
	public List<Integer> getHiddenQuestionIds(String userID, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("user_id", userID);
		map.put("tenant_id", tenantId);	
		return ezPollDAO.getHiddenQuestionIds(map);			
	}

	@Override
	public void insertHiddenQuestion(PollQuestionStatusVO pollQstStatusVO) throws Exception {		
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("qst_id", pollQstStatusVO.getQustId());
		map.put("user_id", pollQstStatusVO.getUserId());
		map.put("tenant_id", pollQstStatusVO.getTenantId());	
		//map.put("hide", pollQstStatusVO.getHide());
		ezPollDAO.insertHiddenQuestion(map);		
	}

	@Override
	public void insertSeenQuestion(PollQuestionStatusVO pollQstStatusVO) throws Exception {		
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("qst_id", pollQstStatusVO.getQustId());
		map.put("user_id", pollQstStatusVO.getUserId());
		map.put("tenant_id", pollQstStatusVO.getTenantId());	
		//map.put("hide", pollQstStatusVO.getHide());
		ezPollDAO.insertSeenQuestion(map);		
	}
	
	@Override
	public void insertCommentQuestion(PollQuestionStatusVO pollQstStatusVO)	throws Exception {		
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("qst_id", pollQstStatusVO.getQustId());
		map.put("user_id", pollQstStatusVO.getUserId());
		map.put("tenant_id", pollQstStatusVO.getTenantId());	
		//map.put("hide", pollQstStatusVO.getHide());
		ezPollDAO.insertCommentQuestion(map);		
	}

	@Override
	public List<PollQuestionVO> getOwnQuestions(String userID, int tenantID, String searchStr) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("user_id", userID);
		map.put("tenant_id", tenantID);	
		map.put("search_str", searchStr);	
		return ezPollDAO.getOwnQuestions(map);	
	}

	@Override
	public PollQuestionVO getQuestionByIdAndTenantId(int qstId, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("qst_id", qstId);
		map.put("tenant_id", tenantId);	
		return ezPollDAO.getQuestionByIdAndTenantId(map);	
	}

	@Override
	public void deleteQuestions(int qstId, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("qst_id", qstId);
		map.put("tenant_id", tenantId);	
		ezPollDAO.deleteQuestions(map);			
	}

	@Override
	public void deleteUserAndAnswer(int qstId, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("qst_id", qstId);
		map.put("tenant_id", tenantId);	
		ezPollDAO.deleteUserAndAnswer(map);			
	}

	@Override
	public void deleteQuestionRelated(int qstId, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("qst_id", qstId);
		map.put("tenant_id", tenantId);	
		ezPollDAO.deleteQuestionRelated(map);		
	}

	@Override
	public void deleteAnswers(int qstId, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("qst_id", qstId);
		map.put("tenant_id", tenantId);	
		ezPollDAO.deleteAnswers(map);	
	}

	@Override
	public void deleteUserAndQuestion(int qstId, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("qst_id", qstId);
		map.put("tenant_id", tenantId);	
		ezPollDAO.deleteUserAndQuestion(map);	
	}

	@Override
	public List<String> getNumberOfSeenUsers(int qstId, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("qst_id", qstId);
		map.put("tenant_id", tenantId);	
		return ezPollDAO.getNumberOfSeenUsers(map);	
	}

	@Override
	public List<PollUserAnswerVO> getPollUserAndAnswer(int qstId, int tenantId)	throws Exception {		
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("qst_id", qstId);
		map.put("tenant_id", tenantId);	
		return ezPollDAO.getPollUserAndAnswer(map);			
	}

	@Override
	public List<PollAnswerVO> getListOptionsOfQst(int qstId, int tenantId) throws Exception {		
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("qst_id", qstId);
		map.put("tenant_id", tenantId);	
		return ezPollDAO.getListOptionsOfQst(map);	
	}

	@Override
	public void addAnswerAndUser(PollUserAnswerVO pollUserAnswer) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("opt_id", pollUserAnswer.getAnsId());
		map.put("qst_id", pollUserAnswer.getQstId());
		map.put("user_id", pollUserAnswer.getUserId());
		map.put("tenant_id", pollUserAnswer.getTenantId());	
		map.put("user_name", pollUserAnswer.getUserName());	
		map.put("vote_date", pollUserAnswer.getVoteDate());	
		ezPollDAO.addAnswerAndUser(map);	
		
	}

	@Override
	public void removeAnswerAndUser(PollUserAnswerVO pollUserAnswer) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("opt_id", pollUserAnswer.getAnsId());
		map.put("qst_id", pollUserAnswer.getQstId());
		map.put("user_id", pollUserAnswer.getUserId());
		map.put("tenant_id", pollUserAnswer.getTenantId());	
		ezPollDAO.removeAnswerAndUser(map);	
		
	}

	@Override
	public void updateNumberOfVotesForAnswer(PollUserAnswerVO pollUserAnswer, int value) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("opt_id", pollUserAnswer.getAnsId());
		map.put("qst_id", pollUserAnswer.getQstId());		
		map.put("tenant_id", pollUserAnswer.getTenantId());	
		map.put("value", value);
		ezPollDAO.updateNumberOfVotesForAnswer(map);	
		
	}

	@Override
	public List<PollUserAnswerVO> getListVotedUsersForAnswer(int optId, int qstId, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("opt_id", optId);
		map.put("qst_id", qstId);
		map.put("tenant_id", tenantId);			
		return ezPollDAO.getListVotedUsersForAnswer(map);	
	}

	@Override
	public PollAnswerVO getAnswerByIdAndQstId(int optId, int qstId, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("opt_id", optId);
		map.put("qst_id", qstId);
		map.put("tenant_id", tenantId);			
		return ezPollDAO.getAnswerByIdAndQstId(map);
	}

	@Override
	public void updateEndDateForQst(int qstId, int tenantId, String dateNow) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("qst_id", qstId);
		map.put("tenant_id", tenantId);		
		map.put("end_date", dateNow);
		ezPollDAO.updateEndDateForQst(map);		
	}

	@Override
	public List<PollQuestionVO> getAllQuestions(int tenantID, String searchStr) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("tenant_id", tenantID);	
		map.put("search_str", searchStr);	
		return ezPollDAO.getAllQuestions(map);	
	}

	@Override
	public void updateModifyingQuestion(int qstId, int tenantId, int value) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("qst_id", qstId);		
		map.put("tenant_id", tenantId);	
		map.put("value", value);	
		ezPollDAO.updateModifyingQuestion(map);			
	}

	@Override
	public void insertModifyingQuestion(PollQuestionStatusVO pollQstStatusVO) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("qst_id", pollQstStatusVO.getQustId());
		map.put("user_id", pollQstStatusVO.getUserId());
		map.put("tenant_id", pollQstStatusVO.getTenantId());		
		ezPollDAO.insertModifyingQuestion(map);	
		
	}

	@Override
	public void updateModifyingQuestionRelatedStatus(PollQuestionStatusVO pollQstStatusVO) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("qst_id", pollQstStatusVO.getQustId());
		map.put("user_id", pollQstStatusVO.getUserId());
		map.put("tenant_id", pollQstStatusVO.getTenantId());	
		ezPollDAO.updateModifyingQuestionRelatedStatus(map);	
		
	}

	@Override
	public void deleteModifyingQuestionRelatedStatus(PollQuestionStatusVO pollQstStatusVO) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("qst_id", pollQstStatusVO.getQustId());
		map.put("user_id", pollQstStatusVO.getUserId());
		map.put("tenant_id", pollQstStatusVO.getTenantId());	
		ezPollDAO.deleteModifyingQuestionRelatedStatus(map);		
	}

	@Override
	public String getModifyingUser(int tenantId, int qstId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("qst_id", qstId);	
		map.put("tenant_id", tenantId);	
		return ezPollDAO.getModifyingUser(map);
	}

	@Override
	public List<PollCommentVO> getListCmtOfQst(int qstId, int tenantId)	throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("qst_id", qstId);
		map.put("tenant_id", tenantId);	
		return ezPollDAO.getListCmtOfQst(map);	
	}

	@Override
	public void insertCmt(PollCommentVO pollCmtVO) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("id", pollCmtVO.getCmtId());
		map.put("qst_id", pollCmtVO.getQstId());			
		map.put("tenant_id", pollCmtVO.getTenantId());
		map.put("user_id", pollCmtVO.getUserId());		
		map.put("text_content", pollCmtVO.getTextContent());
		map.put("image_type", pollCmtVO.getImageAttach());			
		map.put("file_type", pollCmtVO.getFileAttach());
		map.put("file_name", pollCmtVO.getFileName());
		map.put("file_path", pollCmtVO.getFilePath());
		map.put("cmt_time", pollCmtVO.getCmtTime());
		ezPollDAO.insertCmt(map);		
	}

	@Override
	public void deleteCommentOfQst(int qstId, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("qst_id", qstId);
		map.put("tenant_id", tenantId);	
		ezPollDAO.deleteCommentOfQst(map);		
	}

}
