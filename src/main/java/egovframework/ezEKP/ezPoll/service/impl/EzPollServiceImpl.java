package egovframework.ezEKP.ezPoll.service.impl;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;

import javax.annotation.Resource;
import javax.mail.internet.InternetAddress;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.ezEKP.ezPersonal.service.EzPersonalService;
import egovframework.ezEKP.ezPersonal.type.NotiPlatform;
import egovframework.ezEKP.ezPersonal.type.NotiType;
import egovframework.ezEKP.ezPoll.dao.EzPollDAO;
import egovframework.ezEKP.ezPoll.service.EzPollService;
import egovframework.ezEKP.ezPoll.vo.PollAnswerVO;
import egovframework.ezEKP.ezPoll.vo.PollCommentVO;
import egovframework.ezEKP.ezPoll.vo.PollQuestionStatusVO;
import egovframework.ezEKP.ezPoll.vo.PollQuestionVO;
import egovframework.ezEKP.ezPoll.vo.PollUserAnswerVO;
import egovframework.ezEKP.ezPoll.vo.PollUserVO;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Service("EzPollService")
public class EzPollServiceImpl implements EzPollService{

	private static final Logger logger = LoggerFactory.getLogger(EzPollServiceImpl.class);

	@Resource(name = "EzPollDAO")
	private EzPollDAO ezPollDAO;
	
	@Resource(name="EzCommonService")
	private EzCommonService ezCommonService;
	
	@Resource(name="EzOrganService")
	private EzOrganService ezOrganService;
	
	@Resource(name="loginService")
	private LoginService loginService;
	
	@Autowired
	private EzEmailService ezEmailService;
	
	@Autowired
	private EzOrganAdminService ezOrganAdminService;
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Autowired
	EzPersonalService ezPersonalService;
	
	@Override
	public String getQuestionSeq(int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();		
		map.put("tenantID", tenantID);
		return ezPollDAO.getQuestionSeq(map);		
	}

	@Override
	public void insertQuestion(PollQuestionVO pollQuestionVO) throws Exception {		
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("id", pollQuestionVO.getQstId());		
		map.put("tenant_id", pollQuestionVO.getTenantId());
		map.put("content", pollQuestionVO.getContent());
		map.put("multi_select", pollQuestionVO.getMultiSelect());
		map.put("create_date", pollQuestionVO.getCreateDate());
		map.put("start_date", pollQuestionVO.getStartDate());
		map.put("end_date", pollQuestionVO.getEndDate());
		map.put("target", pollQuestionVO.getTarget());
		map.put("title", pollQuestionVO.getTitle());
		map.put("secret_vote", pollQuestionVO.getSecretVote());
		map.put("creator", pollQuestionVO.getCreator());
		map.put("creator_name1", pollQuestionVO.getCreatorName1());
		map.put("creator_name2", pollQuestionVO.getCreatorName2());
		map.put("creator_dept", pollQuestionVO.getCreatorDept());
		map.put("file_path", pollQuestionVO.getFilePath());	
		map.put("result_first", pollQuestionVO.getResultFirst());
		map.put("set_date", pollQuestionVO.getSetDate());
		map.put("is_sorting", pollQuestionVO.getIsSorting());		
		map.put("is_selonlyonce", pollQuestionVO.getIsSelOnlyOnce());		
		map.put("sendpostnotice", pollQuestionVO.getSendPostNotice());
		map.put("opentoall", pollQuestionVO.getOpenToAll());
		map.put("companyid", pollQuestionVO.getCompanyId());
		ezPollDAO.insertQuestion(map);
	}

	@Override
	public void insertQustReceivers(PollQuestionVO pollQuestionVO) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("qst_id", pollQuestionVO.getQstId());		
		map.put("user_id", pollQuestionVO.getUserId());
		map.put("tenant_id", pollQuestionVO.getTenantId());
		map.put("type", pollQuestionVO.getReceiverType());
		map.put("companyid", pollQuestionVO.getCompanyId());
		map.put("dept_id", pollQuestionVO.getUserDeptId());
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
		map.put("filePath", pollAnswerVO.getFilePath());
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
	public List<PollUserVO> getListOfUserForQst(int qstId, int tenantID, String type) throws Exception {		
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("qst_id", qstId);
		map.put("tenantID", tenantID);
		map.put("type", type);
		return (List<PollUserVO>) ezPollDAO.getListOfUserForQst(map);
	}

	@Override
	public int checkTargetOfQst(int qstId, int tenantID) throws Exception {		
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("qst_id", qstId);
		map.put("tenantID", tenantID);
		return ezPollDAO.checkTargetOfQst(map);
	}

	@Override
	public List<PollQuestionVO> getQuestionByDeptId(String dept_id, int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("dept_id", dept_id);
		map.put("tenant_id", tenantID);
		return ezPollDAO.getQuestionByDeptId(map);	
	}

	@Override
	public List<PollQuestionVO> getQuestionsTest(String userID, String deptPath, String companyID, String deptID, int tenantID, String searchStr, String primary, String mode) throws Exception {		
		Map<String,Object> map = new HashMap<String, Object>();	
		String[] deptArr = deptPath.split(",");
		map.put("user_id", userID);
		map.put("v_deptPath", deptPath);
		map.put("company_id", companyID);
		map.put("dept_id", deptID);
		map.put("tenant_id", tenantID);	
		map.put("search_str", searchStr);	
		map.put("primary", primary);
		map.put("mode", mode);
		map.put("deptArr", deptArr);
		return ezPollDAO.getQuestionsTest(map);		

	}

	@Override
	public List<Integer> getHiddenQuestionIds(String userID, int tenantId, String companyID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("user_id", userID);
		map.put("tenant_id", tenantId);	
		map.put("companyid", companyID);
		return ezPollDAO.getHiddenQuestionIds(map);			
	}

	@Override
	public void insertHiddenQuestion(PollQuestionStatusVO pollQstStatusVO) throws Exception {		
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("qst_id", pollQstStatusVO.getQustId());
		map.put("user_id", pollQstStatusVO.getUserId());
		map.put("tenant_id", pollQstStatusVO.getTenantId());		
		map.put("dept_id", pollQstStatusVO.getDeptId());		
		ezPollDAO.insertHiddenQuestion(map);		
	}

	@Override
	public void insertSeenQuestion(PollQuestionStatusVO pollQstStatusVO, String companyID) throws Exception {		
		String deptID = pollQstStatusVO.getDeptId();
		int tenantID = pollQstStatusVO.getTenantId();
		
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("qst_id", pollQstStatusVO.getQustId());
		map.put("user_id", pollQstStatusVO.getUserId());
		map.put("tenant_id", tenantID);	
		map.put("dept_id", deptID);
		map.put("companyid", companyID);
		
		PollUserVO userVo = ezPollDAO.getIsQuestionUser(map);
		if(userVo != null){
			map.put("userType", userVo.getUserType());
			map.put("userDept", userVo.getDeptId());
		}
		else {
			String depPath = ezOrganService.getDeptPath(deptID, tenantID);
			String[] deptPathArr = depPath.split(",");
			map.put("deptPathArr", deptPathArr);
		}
		
		ezPollDAO.insertSeenQuestion(map);		
	}
	
	@Override
	public void insertCommentQuestion(PollQuestionStatusVO pollQstStatusVO)	throws Exception {		
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("qst_id", pollQstStatusVO.getQustId());
		map.put("user_id", pollQstStatusVO.getUserId());
		map.put("tenant_id", pollQstStatusVO.getTenantId());		
		map.put("dept_id", pollQstStatusVO.getDeptId());		
		ezPollDAO.insertCommentQuestion(map);		
	}

	@Override
	public List<PollQuestionVO> getOwnQuestions(String userID, int tenantID, String searchStr, String primary, String mode, String companyID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("user_id", userID);
		map.put("tenant_id", tenantID);	
		map.put("search_str", searchStr);	
		map.put("primary", primary);
		map.put("mode", mode);
		map.put("companyid", companyID);
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
		map.put("user_name1", pollUserAnswer.getUserName1());	
		map.put("user_name2", pollUserAnswer.getUserName2());
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
	public List<PollQuestionVO> getAllQuestions(int tenantID, String searchStr, String primary, String mode, String companyID, String userID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("tenant_id", tenantID);	
		map.put("search_str", searchStr);	
		map.put("primary", primary);
		map.put("mode", mode);
		map.put("companyid", companyID);
		map.put("user_id", userID);
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
	public void insertModifyingQuestion(PollQuestionStatusVO pollQstStatusVO, String companyID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("qst_id", pollQstStatusVO.getQustId());
		map.put("user_id", pollQstStatusVO.getUserId());
		map.put("tenant_id", pollQstStatusVO.getTenantId());		
		map.put("companyid", companyID);
		map.put("dept_id", pollQstStatusVO.getDeptId());
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
		map.put("user_name1", pollCmtVO.getUserName1());	
		map.put("user_name2", pollCmtVO.getUserName2());
		map.put("text_content", pollCmtVO.getTextContent());
		map.put("image_type", pollCmtVO.getImageAttach());			
		map.put("file_type", pollCmtVO.getFileAttach());
		map.put("file_name", pollCmtVO.getFileName());
		map.put("file_path", pollCmtVO.getFilePath());
		map.put("cmt_time", pollCmtVO.getCmtTime());
		map.put("dept_id", pollCmtVO.getDeptId());
		map.put("companyid", pollCmtVO.getDeptId());
		
		ezPollDAO.insertCmt(map);		
	}

	@Override
	public void deleteCommentOfQst(int qstId, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("qst_id", qstId);
		map.put("tenant_id", tenantId);	
		ezPollDAO.deleteCommentOfQst(map);		
	}

	@Override
	public void updateCmt(PollCommentVO pollCmtVO) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("id", pollCmtVO.getCmtId());
		map.put("qst_id", pollCmtVO.getQstId());			
		map.put("tenant_id", pollCmtVO.getTenantId());				
		map.put("text_content", pollCmtVO.getTextContent());
		map.put("image_type", pollCmtVO.getImageAttach());			
		map.put("file_type", pollCmtVO.getFileAttach());
		map.put("file_name", pollCmtVO.getFileName());
		map.put("file_path", pollCmtVO.getFilePath());		
		ezPollDAO.updateCmt(map);	
	}

	@Override
	public void deleteSpecificCmt(int cmtId, int qstId, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("id", cmtId);
		map.put("qst_id", qstId);			
		map.put("tenant_id", tenantId);			
		ezPollDAO.deleteSpecificCmt(map);		
	}
	
	public void getAllQuestionForUser(LoginVO loginvo, Set<PollQuestionVO> set, String searchStr, String mode) throws Exception {
		List<PollQuestionVO> listOfQuestion = new ArrayList<PollQuestionVO>();
		int tenantID = loginvo.getTenantId();
		String primary = loginvo.getPrimary();
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("tenant_id", tenantID);
		map.put("companyid", loginvo.getCompanyID());
		map.put("user_id", loginvo.getId());
		map.put("dept_id", loginvo.getDeptID());
		String companyID = loginvo.getCompanyID();
		
		//Check if user has admin privilege
		if (loginvo.getRollInfo().indexOf("c=1") == -1 && loginvo.getRollInfo().indexOf("k=1") == -1) {
			//Normal user
			String deptID = loginvo.getDeptID();
			String userID = loginvo.getId();			
			
			try {
				String depPath = ezOrganService.getDeptPath(deptID, tenantID);
				listOfQuestion = getQuestionsTest(userID, depPath, companyID, deptID, tenantID, searchStr, primary, mode);
			}
			catch (Exception e) {
				logger.error(e.getMessage(), e);
			}
			set.addAll(listOfQuestion);
			
			//Get all question which this user is creator
			List<PollQuestionVO> listOfQuestion2 = getOwnQuestions(userID, tenantID, searchStr, primary, mode, companyID);		
			set.addAll(listOfQuestion2);
			
			List<PollQuestionVO> listOfQuestion3 = ezPollDAO.getOpenToAllQuestion(map);
			set.addAll(listOfQuestion3);
			
		}
		else {
			//Get all questions for admin privilege user
			try {
				listOfQuestion = getAllQuestions(tenantID, searchStr, primary, mode, companyID, loginvo.getId());
			}
			catch (Exception e) {
				logger.error(e.getMessage(), e);
			}
			
			set.addAll(listOfQuestion);
		}	
	}
	
	@Override
	public void getAllQuestionForUser2(LoginVO loginvo,	Set<PollQuestionVO> set, String searchStr, String mode) throws Exception {
		List<PollQuestionVO> listOfQuestion = new ArrayList<PollQuestionVO>();
		int tenantID = loginvo.getTenantId();
		String primary = loginvo.getPrimary();
		
		String companyID = loginvo.getCompanyID();
		String deptID = loginvo.getDeptID();
		String userID = loginvo.getId();			
		
		try {
			String depPath = ezOrganService.getDeptPath(deptID, tenantID);
			listOfQuestion = getQuestionsTest(userID, depPath, companyID, deptID, tenantID, searchStr, primary, mode);
		} 
		catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		
		set.addAll(listOfQuestion);
	}

	@Override
	public void unhideQuestion(String qstID, String userID, int tenantId) throws Exception {		
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("qst_id", qstID);
		map.put("user_id", userID);			
		map.put("tenant_id", tenantId);			
		ezPollDAO.unhideQuestion(map);	
	}

	@Override
	public PollUserAnswerVO getSpecificPollUserAndAnswer(int optId, int qstId, String id, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("opt_id", optId);
		map.put("qst_id", qstId);
		map.put("user_id", id);
		map.put("tenant_id", tenantId);
		return ezPollDAO.getSpecificPollUserAndAnswer(map);
	}

	@Override
	public int checkUsingFile(int tenantId, String FilePath) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("tenant_id", tenantId);
		map.put("file_path", FilePath);
		return ezPollDAO.checkUsingFile(map);
	}

	@Override
	public int checkQstUsingFile(int tenantId, int qstId, String FilePath) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("tenant_id", tenantId);
		map.put("qst_id", qstId);
		map.put("file_path", FilePath);
		return ezPollDAO.checkQstUsingFile(map);
	}
	
	@Override
	public void deleteAllFilesByQstId(int tenantId, int qstId, String pDirPath, String realPath) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("tenant_id", tenantId);
		map.put("qst_id", qstId);
		map.put("realPath", realPath);
		
		if (!pDirPath.substring(pDirPath.length() - 1).equals(commonUtil.separator)) {
			pDirPath = pDirPath + commonUtil.separator;
		}
		map.put("pDirPath", pDirPath);
		
		//투표에 첨부된 파일 체크 및 삭제
		deleteQstFiles(map);
		deleteAnsFiles(map);
		deleteCmtFiles(map);
		// 2023-08-18 장혜연 - 게시물 에디터에 첨부된 이미지를 삭제한다.
		deleteQstImages(map);
	}
	
	@Override
	public void deleteQstFiles(Map<String, Object> map) throws Exception {
		String qstFileName = "";
		int fileUsingCheck = 0;
		int tenantId = (int)map.get("tenant_id");
		int qstId = (int)map.get("qst_id");
		String pDirPath = (String)map.get("pDirPath");
		String qstFile = ezPollDAO.getQuestionFileById(map);
		
		if(qstFile != null){
			String[] qstFilesList = qstFile.split("\\|");
			for(int i = 0; i < qstFilesList.length; i++){
				qstFileName = qstFilesList[i];
				
				//다른 qstId에서 파일을 사용하고 있는지 체크
				fileUsingCheck = checkQstUsingFile(tenantId, qstId, qstFileName);
				if(fileUsingCheck < 1 && qstFileName != null){
					qstFileName= qstFileName.split("/")[0];
					String absoluteFilePath = pDirPath + "uploadFile/" + commonUtil.detectPathTraversal(qstFileName);
					
					try {
						File file = new File(absoluteFilePath);
						file.delete();	
					}
					catch (Exception e) {
						logger.error(e.getMessage(), e);
					}
				}
			}
		}
	}
	
	@Override
	public void deleteAnsFiles(Map<String, Object> map) throws Exception {
		String ansFileName = "";
		int fileUsingCheck = 0;
		int tenantId = (int)map.get("tenant_id");
		String pDirPath = (String)map.get("pDirPath");
		List<String> ansFilesList = ezPollDAO.getAnswerFilesByQstId(map);
		
		for(int i = 0; i < ansFilesList.size(); i++){
			ansFileName = ansFilesList.get(i);
			fileUsingCheck = checkUsingFile(tenantId, ansFileName);
			if(fileUsingCheck <= 1 && ansFileName != null){
				ansFileName= ansFileName.split("/")[0];
				String absoluteFilePath = pDirPath + "uploadFile/" + commonUtil.detectPathTraversal(ansFileName);
				
				try {
					File file = new File(absoluteFilePath);
					file.delete();	
				}
				catch (Exception e) {
					logger.error(e.getMessage(), e);
				}
			}
		}
	}
	
	@Override
	public void deleteCmtFiles(Map<String, Object> map) throws Exception {
		String cmtFileName = "";
		List<String> cmtFilesList = ezPollDAO.getCommentFilesByQstId(map);
		List<String> cmtImgFilesList = ezPollDAO.getCommentImgFilesByQstId(map);
		
		//일반 파일 삭제
		if(cmtFilesList != null){
			for(int i = 0; i < cmtFilesList.size(); i++){
				cmtFileName = cmtFilesList.get(i);
				
				//댓글은 재사용하지 않기 때문에 파일 사용유무 체크하지 않음.
				if(cmtFileName != null){
					String pDirPath = (String)map.get("pDirPath");
					String absoluteFilePath = pDirPath + "uploadFile/" + commonUtil.detectPathTraversal(cmtFileName);
					
					try {
						File file = new File(absoluteFilePath);
						file.delete();	
					}
					catch (Exception e) {
						logger.error(e.getMessage(), e);
					}
				}
			}
		}
		//이미지 파일 삭제
		if(cmtImgFilesList != null){
			for(int i = 0; i < cmtImgFilesList.size(); i++){
				cmtFileName = cmtImgFilesList.get(i);
				
				//댓글은 재사용하지 않기 때문에 파일 사용유무 체크하지 않음.
				if(cmtFileName != null && cmtFileName.indexOf("commentImages") != -1){
					/*if(cmtFileName != null && cmtFileName.indexOf("commentImages") != -1){
						String[] tempArr = cmtFileName.split("/");
						cmtFileName= tempArr[tempArr.length - 1];
					}*/
					
					String realPath = (String)map.get("realPath");
					String absoluteFilePath = realPath + commonUtil.detectPathTraversal(cmtFileName);
					
					try {
						File file = new File(absoluteFilePath);
						file.delete();	
					}
					catch (Exception e) {
						logger.error(e.getMessage(), e);
					}
				}
			}
		}
	}

	@Override
	public void sendPostNotiMail(LoginVO userInfo, String loginCookie, PollQuestionVO pollQuestion) throws Exception {
		int tenantId = userInfo.getTenantId();
		String title = pollQuestion.getTitle();
		int qstId = pollQuestion.getQstId();
		String toName = "";
		String toAddress = "";
		
		//메일 제목 작성.
		String subject = egovMessageSource.getMessage("ezPoll.hdp03", userInfo.getLocale());
		StringBuilder bodyContent = new StringBuilder("");
		
		/* 2018-07-19 홍승비 - 투표 팝업창 표시 시 가로스크롤 발생하지 않도록 width 수정 */
		//메일 본문 작성.
		bodyContent.append(" " + egovMessageSource.getMessage("ezCircular.t32", userInfo.getLocale()) + " : " + "<span id='poll_a' style=\"color:blue;cursor:pointer;text-decoration:underline;\" onclick=\"javascript:window.open('../ezPoll/pollVote.do?qstId=" + qstId + "&params=&search=&searchN=', '', 'width=835, height=900, scrollbars=yes, resizable=yes')\">" + commonUtil.cleanValue(title) + "</span></br>");
		bodyContent.append(" " + egovMessageSource.getMessage("ezCircular.t122", userInfo.getLocale()) + " : " + userInfo.getDisplayName() + "</br>");
		bodyContent.append(" " + egovMessageSource.getMessage("ezAddress.t288", userInfo.getLocale()) + " : " + pollQuestion.getCreateDate());
		
		String content = commonUtil.createNotiMailContent(bodyContent.toString(), tenantId, userInfo.getLocale());
		
		//메일 대상자 선정
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("tenantID", tenantId);
		map.put("qst_id", qstId);
		
		List<PollUserVO> receiverList = ezPollDAO.getListOfUserIdForQstByQstId(map);
		InternetAddress[] toArr = new InternetAddress[receiverList.size()];
		InternetAddress from = new InternetAddress();
		
		
		for (int i = 0; i < receiverList.size(); i++) {
			OrganUserVO AccessUserInfo = null;
			OrganDeptVO AccessUserGroupInfo = null;
			InternetAddress to = new InternetAddress();
			
			String userType = receiverList.get(i).getUserType();
			String receiverId = receiverList.get(i).getUserId().trim();
			
			
			if(userType.equals("user")){
				AccessUserInfo = ezOrganAdminService.getUserInfo(receiverId, userInfo.getPrimary(), userInfo.getTenantId());
			}
			else{
				AccessUserGroupInfo = ezOrganService.getDeptInfo(receiverId, userInfo.getPrimary(), userInfo.getTenantId());
			}
			
			if (ezPersonalService.hasNotiDiableItem(receiverId, NotiType.fromString("POLL_NEW"), NotiPlatform.MAIL, tenantId)) {
				continue;
			}
			
			from.setPersonal(userInfo.getDisplayName(), "UTF-8");
			from.setAddress(userInfo.getEmail());
			
			if(AccessUserInfo != null){
				toName = AccessUserInfo.getDisplayName();
				toAddress = AccessUserInfo.getMail();
			}
			// 2023-05-17 이사라 : NullPointerException 시큐어코딩
			else if (!Objects.isNull(AccessUserGroupInfo)) {
				toName = AccessUserGroupInfo.getDisplayName();
				toAddress = AccessUserGroupInfo.getMail();
			}
			
			to.setPersonal(toName, "UTF-8");
			to.setAddress(toAddress);
			toArr[i] = to;
		}
		if (toArr != null && toArr.length > 0) {
			ezEmailService.sendMail(loginCookie, from, toArr, null, null, subject, content, false);
		}
	}

	@Override
	public OrganUserVO getRetireEntryInfo(String cn, String lang, int tenantID) throws Exception {
		return ezOrganAdminService.getRetireEntryInfo(cn, lang, tenantID);
	}

	public void getAllMemberOfDept(List<LoginVO> list, String deptId, int tenantID) throws Exception {		
		List<LoginVO> list1 = loginService.selectAllReceivers(deptId, tenantID);
		
		if (list1 != null && list1.size() > 0) {
			list.addAll(list1);
		}		
		
		//Get all member of sub department
		List<String> subDeptIdList = ezOrganService.getAllSubDeptId(deptId, tenantID);
		
		if (subDeptIdList != null && subDeptIdList.size() > 0) {
			for (String subDeptId : subDeptIdList) {				
				getAllMemberOfDept(list, subDeptId, tenantID);
			}
		}		
	}

	@Override
	public void getAllUserForQuestion(LoginVO loginVO, int questionID, Set<LoginVO> set) throws Exception {
		//Check if this question is for all members
		int target = checkTargetOfQst(questionID, loginVO.getTenantId());
		List<LoginVO> list = new ArrayList<LoginVO>();

		if (target == 0) {
			list = loginService.selectAllMemberOfCompany(loginVO.getCompanyID(), loginVO.getTenantId());
		}
		else {
			List<String> departIdList = getListOfUserIdForQst(questionID, loginVO.getTenantId(), "dept");

			for (String deptId : departIdList) {
				getAllMemberOfDept(list, deptId, loginVO.getTenantId());
			}

			List<String> userIdList = getListOfUserIdForQst(questionID, loginVO.getTenantId(), "user");

			for (String _userID : userIdList) {
				LoginVO user = loginService.selectReceiver(_userID, loginVO.getTenantId());
				if(user != null){
					list.add(user);
				}
			}
		}

		set.addAll(list);
	}

	//tbl_vote_user_and_question 의 모든 유저 정보를 가져옴.
	@Override
	public List<PollUserVO> getAllUsersForQst(int tenantId, int qstId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		
		map.put("tenant_id", tenantId);
		map.put("qst_id", qstId);
		
		return ezPollDAO.getAllUsersForQst(map);
	}

	//모든 투표 대상자의 정보를 usermaster에서 가져옴.
	@Override
	public List<LoginVO> getAllUsersInfoForQstM(int tenantId, int qstId, String companyID) throws Exception {
		List<PollUserVO> pollUser = getAllUsersForQst(tenantId, qstId);
		List<String> userList = new ArrayList<String>();
		List<String> deptUserList = new ArrayList<String>();
		String companyUser = "";
		HashMap<String, Object> map = new HashMap<String, Object>();
		
		Iterator<PollUserVO> iter = pollUser.iterator();
		while(iter.hasNext()){
			PollUserVO user = iter.next();
			String userType = user.getUserType();
			if(userType.equals("user")){
				userList.add(user.getUserId());
			}
			else if(userType.equals("dept")){
				deptUserList.add(user.getUserId());
			}
			else{
				companyUser = user.getUserId();
			}
		}
		map.put("tenant_id", tenantId);
		map.put("companyid", companyID);
		map.put("qst_id", qstId);
		
		if(userList.size() > 0){
			map.put("userList", userList);
		}
		
		if(deptUserList.size() > 0){
			map.put("deptUserList", deptUserList);
		}
		
		if(companyUser != null){
			map.put("companyUser", companyUser);
		}
		
		return ezPollDAO.getUserInfoM(map);
	}
	
	//모든 투표 대상자의 정보를 usermaster, retire, delete에서 가져옴.
	@Override
	public List<LoginVO> getAllUsersInfoForQstMRD(int tenantId, int qstId) throws Exception {
		List<PollUserVO> pollUser = getAllUsersForQst(tenantId, qstId);
		List<String> userList = new ArrayList<String>();
		List<String> deptUserList = new ArrayList<String>();
		HashMap<String, Object> map = new HashMap<String, Object>();
		
		Iterator<PollUserVO> iter = pollUser.iterator();
		while(iter.hasNext()){
			PollUserVO user = iter.next();
			if(user.getUserType().equals("user")){
				userList.add(user.getUserId());
			}
			else{
				deptUserList.add(user.getUserId());
			}
		}
		map.put("tenant_id", tenantId);
		
		if(userList.size() > 0){
			map.put("userList", userList);
		}
		
		if(deptUserList.size() > 0){
			map.put("deptUserList", deptUserList);
		}
		
		return ezPollDAO.getUserInfoMRD(map);
	}
	
	@Override
	public List<LoginVO> getQstAllUsers(int tenantId, int qstId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		
		map.put("tenant_id", tenantId);
		map.put("qst_id", qstId);
		
		return ezPollDAO.getQstAllUsers(map);
	}

	@Override
	public List<LoginVO> getInfoOfSeenUsers(int tenantId, int qstId, String companyID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		
		map.put("tenant_id", tenantId);
		map.put("qst_id", qstId);
		map.put("companyid", companyID);
		
		return ezPollDAO.getInfoOfSeenUsers(map);
	}

	@Override
	public String getAddJobDept(int tenantId, int qstId, String userId, String deptId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		
		map.put("tenant_id", tenantId);
		map.put("qst_id", qstId);
		map.put("dept_id", deptId);
		map.put("user_id", userId);
		
		return ezPollDAO.getAddJobDept(map);
	}

	@Override
	public String getQuestionRelatedDept(int tenantId, int qstId, String userId, String deptId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		
		map.put("tenant_id", tenantId);
		map.put("qst_id", qstId);
		map.put("dept_id", deptId);
		map.put("user_id", userId);
		
		return ezPollDAO.getQuestionRelatedDept(map);
	}

	@Override
	public String getContent(int qstId, int tenantId) throws Exception {
		logger.debug("qstid : {}, tenantId : {}", qstId, tenantId );
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("qst_id", qstId);
		map.put("tenant_id", tenantId);
		return ezPollDAO.getContent(map);
	}

	@Override
	public void deleteQstImages(Map<String, Object> map) throws Exception {
		String realPath = (String)map.get("realPath");
		String content = getContent((int)map.get("qst_id"), (int)map.get("tenant_id"));
		
		if (content == null) {
			content = "";
		}

		Document document = Jsoup.parse(content);
		Elements elements = document.getElementsByTag("img");

		if (!elements.isEmpty()) {
			for (Element element : elements) {
				File file = new File(realPath + element.attr("src"));
				file.delete();
			}
		}
	}

	@Override
	public PollCommentVO getCmtFileType(int cmtId, int qstId, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<>();
		map.put("cmt_id", cmtId);
		map.put("qst_id", qstId);
		map.put("tenant_id", tenantId);
		return ezPollDAO.getCmtFile(map);
	}

}
