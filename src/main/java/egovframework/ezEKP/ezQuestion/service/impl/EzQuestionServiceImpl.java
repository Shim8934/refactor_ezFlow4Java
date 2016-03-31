package egovframework.ezEKP.ezQuestion.service.impl;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.ezEKP.ezQuestion.dao.EzQuestionDAO;
import egovframework.ezEKP.ezQuestion.service.EzQuestionService;
import egovframework.ezEKP.ezQuestion.vo.QstAnswerVO;
import egovframework.ezEKP.ezQuestion.vo.QstAttachVO;
import egovframework.ezEKP.ezQuestion.vo.QstCompleteVO;
import egovframework.ezEKP.ezQuestion.vo.QstListVO;
import egovframework.ezEKP.ezQuestion.vo.QstResponsePersonVO;
import egovframework.ezEKP.ezQuestion.vo.QstResponseVO;
import egovframework.ezEKP.ezQuestion.vo.QstUserPermissionVO;
import egovframework.ezEKP.ezQuestion.vo.QstUserPollItemVO;
import egovframework.ezEKP.ezQuestion.vo.QstVO;
import egovframework.let.user.login.vo.LoginVO;

@Service("EzQuestionService")
public class EzQuestionServiceImpl implements EzQuestionService{
	@Resource(name="EzQuestionDAO")
	private EzQuestionDAO ezQuestionDAO;
	
	@Override
	public int getQstListCnt(QstListVO questionListVO) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_PSTRBRDID", questionListVO.getBrdId());
		map.put("v_PUSERID", questionListVO.getUserId());
		map.put("v_PTITLE", questionListVO.getTitle());
		map.put("v_PRANGE", questionListVO.getResponseRange());
		map.put("v_PSDATE", questionListVO.getPostDate());
		map.put("v_PEDATE", questionListVO.getPollEndDate());
		map.put("v_PLANG", questionListVO.getLang());
		return ezQuestionDAO.getQstListCnt(map);
	}

	@Override
	public List<QstListVO> getQstList(QstListVO questionListVO) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_PSTRBRDID", questionListVO.getBrdId());
		map.put("v_PUSERID", questionListVO.getUserId());
		map.put("v_PTOTALCNT", questionListVO.getTotalCnt()-(questionListVO.getCurrPage()-1)*questionListVO.getPageSize());
		map.put("v_PPAGESIZE", questionListVO.getPageSize());
		map.put("v_PTITLE", questionListVO.getTitle());
		map.put("v_PRANGE", questionListVO.getResponseRange());
		map.put("v_PSDATE", questionListVO.getPostDate());
		map.put("v_PEDATE", questionListVO.getPollEndDate());
		map.put("v_PLANG", questionListVO.getLang());
		return ezQuestionDAO.getQstList(map);
	}
	
	@Override
	public int getItemNoCnt(int brdId, int itemNo) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", brdId);
		map.put("v_pItemNo", itemNo);
		return ezQuestionDAO.getItemNoCnt(map);
	}
	
	@Override
	public void insertItemSeq(String brdId) throws Exception {
		ezQuestionDAO.insertItemSeq(brdId);
	}

	@Override
	public void updateItemSeq(int brdId, int itemNo) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", brdId);
		map.put("v_pItemNo", itemNo);
		ezQuestionDAO.updateItemSeq(map);
	}

	@Override
	public void stepSave(String pUserID, Map<String,Object> map) throws Exception {
		Calendar calendar = Calendar.getInstance();
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
		map.put("v_pstrBrdID", map.get("brdId"));
		map.put("v_pItemNo", map.get("itemNo"));
		map.put("v_pUserID", pUserID);
		map.put("v_pUserNM", pUserID);
		map.put("v_pUserNM2", pUserID);
		map.put("v_pUserEmail", pUserID);
		map.put("v_pTitle", map.get("subject"));
		map.put("v_pContent", map.get("content"));
		map.put("v_pPostDate", dateFormat.format(calendar.getTime()));
		map.put("v_pPostTerm", map.get("expiredate"));
		map.put("v_pItemRef", map.get("itemId"));
		map.put("v_pItemImp", map.get("importance"));
		map.put("v_pSDate", map.get("startdate"));
		map.put("v_pEdate", map.get("enddate"));
		map.put("v_pDataCount", map.get("dataCount"));
		ezQuestionDAO.stepSave(map);
	}

	@Override
	public void stepSave2(Map<String, Object> map) throws Exception {
		map.put("v_pstrBrdID", map.get("brdId"));
		map.put("v_pItemNo", map.get("itemNo"));
		map.put("v_PRESULTFLG", map.get("openresult"));
		map.put("v_PPUBLICFLG", map.get("anonymity"));
		map.put("v_PMULTIFLG", map.get("multiresponse"));
		map.put("v_PRESRANGE", map.get("target"));
		map.put("v_PDATACOUNT", map.get("dataCount"));
		ezQuestionDAO.stepSave2(map);
	}

	@Override
	public String getItemSeq(String brdId) throws Exception {
		return ezQuestionDAO.getItemSeq(brdId);
	}
	
	@Override
	public QstUserPollItemVO getUserPollItem(QstUserPollItemVO userPollItemVO) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", userPollItemVO.getBrdId());
		map.put("v_pItemNo", userPollItemVO.getItemNo());
		return ezQuestionDAO.getUserPollItem(map);
	}

	@Override
	public QstUserPermissionVO getUserPermission(QstUserPermissionVO userPermissionVO) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", userPermissionVO.getBrdId());
		map.put("v_pItemNo", userPermissionVO.getItemNo());
		return ezQuestionDAO.getUserPermission(map);
	}

	@Override
	public int getUserResponseCnt(QstUserPermissionVO userPermissionVO,String userId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", userPermissionVO.getBrdId());
		map.put("v_pItemNo", userPermissionVO.getItemNo());
		map.put("v_puserID", userId);
		return ezQuestionDAO.getUserResponseCnt(map);
	}
	
	@Override
	public String getUserIdAdmin(int brdId) throws Exception {
		return ezQuestionDAO.getUserIdAdmin(brdId);
	}
	
	@Override
	public void callCreateMother(QstCompleteVO qstCompleteVO) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", qstCompleteVO.getStrBrdID());
		map.put("v_pItemNo", qstCompleteVO.getItemNo());
		map.put("v_pGubunFg", qstCompleteVO.getGubunFg());
		map.put("v_pGubunID", qstCompleteVO.getGubunID());
		map.put("v_pGubunNm", qstCompleteVO.getGubunNm());
		map.put("v_pGubunNm2", qstCompleteVO.getGubunNm2());
		ezQuestionDAO.callCreateMother(map);
	}

	@Override
	public void callInsertPollResponsep1(QstCompleteVO qstCompleteVO) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", qstCompleteVO.getStrBrdID());
		map.put("v_pItemNo", qstCompleteVO.getItemNo());
		map.put("v_pUserID", qstCompleteVO.getUserID());
		map.put("v_pUserNm", qstCompleteVO.getUserNm());
		map.put("v_pUserNm2", qstCompleteVO.getUserNm2());
		map.put("v_pUserEmail", qstCompleteVO.getUserEmail());
		map.put("v_pUserDeptID", qstCompleteVO.getUserDeptID());
		map.put("v_pUserDeptNM", qstCompleteVO.getUserDeptNm());
		map.put("v_pUserDeptNM2", qstCompleteVO.getUserDeptNm2());
		map.put("v_pUserPOS", qstCompleteVO.getUserPOS());
		map.put("v_pUserPOS2", qstCompleteVO.getUserPOS2());
		ezQuestionDAO.callInsertPollResponsep1(map);
	}

	@Override
	public void callInsertPollResponseper(QstCompleteVO qstCompleteVO) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", qstCompleteVO.getStrBrdID());
		map.put("v_pItemNo", qstCompleteVO.getItemNo());
		map.put("v_pGubunID", qstCompleteVO.getUserID());
		map.put("v_pGubunNm", qstCompleteVO.getUserNm());
		map.put("v_pGubunNm2", qstCompleteVO.getUserNm2());
		map.put("v_pUserEmail", qstCompleteVO.getUserEmail());
		map.put("v_pUserDeptID", qstCompleteVO.getUserDeptID());
		map.put("v_pUserDeptNM", qstCompleteVO.getUserDeptNm());
		map.put("v_pUserDeptNM2", qstCompleteVO.getUserDeptNm2());
		map.put("v_pUserPOS", qstCompleteVO.getUserPOS());
		map.put("v_pUserPOS2", qstCompleteVO.getUserPOS2());
		map.put("v_pUserGender", qstCompleteVO.getUserGender());
		map.put("v_pUserAge", qstCompleteVO.getUserAge());
		ezQuestionDAO.callInsertPollResponseper(map);
	}

	@Override
	public int getQuestionNo(int brdId, int itemNo) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID",brdId);
		map.put("v_pItemNo", itemNo);
		return ezQuestionDAO.getQuestionNo(map);
	}

	@Override
	public void insertQuestion(QstCompleteVO qstCompleteVO) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", qstCompleteVO.getStrBrdID());
		map.put("v_pItemNo", qstCompleteVO.getItemNo());
		map.put("v_pQuesNo", qstCompleteVO.getQuesNo());
		map.put("v_pQuesContent", qstCompleteVO.getQuesContent());
		map.put("v_pAnswerType", qstCompleteVO.getAnswerType());
		map.put("v_pmultiselect", qstCompleteVO.getMultiSelect());
		ezQuestionDAO.insertQuestion(map);
	}

	@Override
	public void pollSaveAttach(QstCompleteVO qstCompleteVO) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", qstCompleteVO.getStrBrdID());
		map.put("v_pItemNo", qstCompleteVO.getItemNo());
		map.put("v_pQuesNo", qstCompleteVO.getQuesNo());
		map.put("v_pAnswerNo", qstCompleteVO.getAnswerNo());
		map.put("v_pAttachNo", qstCompleteVO.getAttachNo());
		map.put("v_pAttachName", qstCompleteVO.getAttachName());
		map.put("v_pAttachURL", qstCompleteVO.getAttachURL());
		map.put("v_pAttachType", qstCompleteVO.getAttachType());
		ezQuestionDAO.pollSaveAttach(map);
	}

	@Override
	public void insertAnswerAnswerContent(QstCompleteVO qstCompleteVO) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", qstCompleteVO.getStrBrdID());
		map.put("v_pItemNo", qstCompleteVO.getItemNo());
		map.put("v_pQuesNo", qstCompleteVO.getQuesNo());
		map.put("v_pAnswerNo", qstCompleteVO.getAnswerNo());
		map.put("v_pAnswer_AnswerContent", qstCompleteVO.getAnswerAnswerContent());
		ezQuestionDAO.insertAnswerAnswerContent(map);
	}

	@Override
	public void insertAnswerContent(QstCompleteVO qstCompleteVO) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", qstCompleteVO.getStrBrdID());
		map.put("v_pItemNo", qstCompleteVO.getItemNo());
		map.put("v_pQuesNo", qstCompleteVO.getQuesNo());
		map.put("v_pAnswerNo", qstCompleteVO.getAnswerNo());
		map.put("v_pAnswerContent", qstCompleteVO.getAnswerContent());
		ezQuestionDAO.insertAnswerContent(map);
	}

	@Override
	public void updatePollItem(QstCompleteVO qstCompleteVO) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", qstCompleteVO.getStrBrdID());
		map.put("v_pItemNo", qstCompleteVO.getItemNo());
		ezQuestionDAO.updatePollItem(map);
	}

	@Override
	public void deleteItem(QstCompleteVO qstCompleteVO) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", qstCompleteVO.getStrBrdID());
		map.put("v_pItemNo", qstCompleteVO.getItemNo());
		ezQuestionDAO.deleteItem(map);
	}

	@Override
	public int getResponseDateCnt(QstUserPermissionVO userPermissionVO,String userId) {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", userPermissionVO.getBrdId());
		map.put("v_pItemNo", userPermissionVO.getItemNo());
		map.put("v_pUserID", userId);
		return ezQuestionDAO.getResponseDateCnt(map);
	}

	@Override
	public Integer resCount(String brdId, String itemNo) {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", brdId);
		map.put("v_pItemNo", itemNo);
		return ezQuestionDAO.resCount(map);
	}

	@Override
	public void updateReadCnt(QstUserPollItemVO qstUserPollItemVO) {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pReadCnt", qstUserPollItemVO.getReadCnt());
		map.put("v_pstrBrdID", qstUserPollItemVO.getBrdId());
		map.put("v_pItemNo", qstUserPollItemVO.getItemNo());
		ezQuestionDAO.updateReadCnt(map);
	}

	@Override
	public int getReadDateItem(QstUserPollItemVO qstUserPollItemVO, String userId) {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", qstUserPollItemVO.getBrdId());
		map.put("v_pItemNo", qstUserPollItemVO.getItemNo());
		map.put("v_pUserID", userId);
		return ezQuestionDAO.getReadDateItem(map);
	}
	
	@Override
	public void updateReadDate(QstUserPollItemVO qstUserPollItemVO, String readDate,String userId) {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", qstUserPollItemVO.getBrdId());
		map.put("v_pItemNo", qstUserPollItemVO.getItemNo());
		map.put("v_pUserID", userId);
		map.put("v_pReadDate", readDate);
		ezQuestionDAO.updateReadDate(map);
	}

	@Override
	public void insertItemRead(LoginVO loginVO, QstUserPollItemVO qstUserPollItemVO, String readDate) {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", qstUserPollItemVO.getBrdId());
		map.put("v_pItemNo", qstUserPollItemVO.getItemNo());
		map.put("v_pUserID", loginVO.getId());
		map.put("v_pReadDate", readDate);
		map.put("v_pUserNM", loginVO.getDisplayName1());
		map.put("v_pUserNM2", loginVO.getDisplayName2());
		map.put("v_pUserDeptID", loginVO.getDeptID());
		map.put("v_pUserDeptNM", loginVO.getDeptName1());
		map.put("v_pUserDeptNM2", loginVO.getDeptName2());
		map.put("v_pUserPosNM", loginVO.getTitle1());
		map.put("v_pUserPosNM2", loginVO.getTitle2());
		ezQuestionDAO.insertItemRead(map);
	}

	@Override
	public List<QstVO> getQuestionForResponse(QstVO questionVO) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", questionVO.getBrdId());
		map.put("v_pItemNo", questionVO.getItemNo());
		return ezQuestionDAO.getQuestionForResponse(map);
	}

	@Override
	public List<QstAttachVO> getAttachInfo(QstAttachVO qstAttachVO)	throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", qstAttachVO.getBrdId());
		map.put("v_pItemNo", qstAttachVO.getItemNo());
		map.put("v_pQuesNo", qstAttachVO.getQuestionNo());
		map.put("v_pAnswerNo", qstAttachVO.getAnswerNo());
		return ezQuestionDAO.getAttachInfo(map);
	}

	@Override
	public List<QstAnswerVO> getAnswerAnswerCnt(int brdId, int itemNo, int qstNo) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", brdId);
		map.put("v_pItemNo", itemNo);
		map.put("v_pQuesNo", qstNo);
		return ezQuestionDAO.getAnswerAnswerCnt(map);
	}

	@Override
	public List<QstAnswerVO> getAnswerCnt(int brdId, int itemNo, int qstNo) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", brdId);
		map.put("v_pItemNo", itemNo);
		map.put("v_pQuesNo", qstNo);
		return ezQuestionDAO.getAnswerCnt(map);
	}

	@Override
	public QstUserPermissionVO getResponseRange(QstUserPermissionVO qstUserPermissionVO) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", qstUserPermissionVO.getBrdId());
		map.put("v_pItemNo", qstUserPermissionVO.getItemNo());
		return ezQuestionDAO.getResponseRange(map);
	}

	@Override
	public QstResponsePersonVO getResponsePerson(QstResponsePersonVO qstResponsePersonVO) throws Exception {
		Map<String, Object> map = new HashMap<String, Object> ();
		map.put("v_pstrBrdID", qstResponsePersonVO.getBrdId());
		map.put("v_pItemNo", qstResponsePersonVO.getItemNo());
		map.put("v_pUserID", qstResponsePersonVO.getUserId());
		return ezQuestionDAO.getResponsePerson(map);
	}

	@Override
	public void updateResponsePerson(QstResponsePersonVO qstResponsePersonVO)throws Exception {
		Map<String, Object> map = new HashMap<String, Object> ();
		map.put("v_pstrBrdID", qstResponsePersonVO.getBrdId());
		map.put("v_pItemNo", qstResponsePersonVO.getItemNo());
		map.put("v_pUserID", qstResponsePersonVO.getUserId());
		ezQuestionDAO.updateResponsePerson(map);
	}

	@Override
	public void updateResCnt(int brdId,int itemNo) throws Exception {
		Map<String, Object> map = new HashMap<String, Object> ();
		map.put("v_pstrBrdID", brdId);
		map.put("v_pItemNo", itemNo);
		ezQuestionDAO.updateResCnt(map);	
	}

	@Override
	public Integer getResponseMaxNo(int brdId, int itemNo, int questionNo) throws Exception {
		Map<String, Object> map = new HashMap<String, Object> ();
		map.put("v_pstrBrdID", brdId);
		map.put("v_pItemNo", itemNo);
		map.put("v_pQuesNo", questionNo);
		return ezQuestionDAO.getResponseMaxNo(map);
	}

	@Override
	public Integer getAnsCnt(QstAnswerVO answerVO) throws Exception {
		// TODO Auto-generated method stub
		Map<String, Object> map = new HashMap<String, Object> ();
		map.put("v_pstrBrdID", answerVO.getBrdId());
		map.put("v_pItemNo", answerVO.getItemNo());
		map.put("v_pQuesNo", answerVO.getQuestionNo());
		return ezQuestionDAO.getAnsCnt(map);
	}

	@Override
	public void insertResponse(QstResponseVO qstResponseVO) throws Exception {
		Map<String, Object> map = new HashMap<String, Object> ();
		map.put("v_pstrBrdID", qstResponseVO.getBrdId());
		map.put("v_pItemNo", qstResponseVO.getItemNo());
		map.put("v_pQuesNo", qstResponseVO.getQuestionNo());
		map.put("v_pResNo", qstResponseVO.getResponseNo());
		map.put("v_pAobj", qstResponseVO.getAnswerObjectivity());
		map.put("v_pUserID", qstResponseVO.getResponseUserId());
		map.put("v_pUserNM", qstResponseVO.getResponseUserName());
		map.put("v_pUserNM2", qstResponseVO.getResponseUserName2());
		map.put("v_pEmail", qstResponseVO.getResponseUserEmail());
		map.put("v_pDeptID", qstResponseVO.getResponseUserDeptId());
		map.put("v_pDeptNM", qstResponseVO.getResponseUserDeptName());
		map.put("v_pDeptNM2", qstResponseVO.getResponseUserDeptName2());
		map.put("v_pPos", qstResponseVO.getResponseUserPosition());
		map.put("v_pPos2", qstResponseVO.getResponseUserPosition2());
		map.put("v_pJikGub", qstResponseVO.getResponseUserJikgub());
		map.put("v_pJikGub2", qstResponseVO.getResponseUserJikgub2());
		map.put("v_pGender", qstResponseVO.getResponseUserGender());
		map.put("v_pAge", qstResponseVO.getResponseUserAge());
		map.put("v_pResDate", qstResponseVO.getResponseDate());
		map.put("v_pResUserIP", qstResponseVO.getResponseUserIp());
		ezQuestionDAO.insertResponse(map);
	}

	@Override
	public void insertResponse2(QstResponseVO qstResponseVO) throws Exception {
		Map<String, Object> map = new HashMap<String, Object> ();
		map.put("v_pstrBrdID", qstResponseVO.getBrdId());
		map.put("v_pItemNo", qstResponseVO.getItemNo());
		map.put("v_pQuesNo", qstResponseVO.getQuestionNo());
		map.put("v_pResNo", qstResponseVO.getResponseNo());
		map.put("v_pAsub", qstResponseVO.getAnswerSubjectivity());
		map.put("v_pUserID", qstResponseVO.getResponseUserId());
		map.put("v_pUserNM", qstResponseVO.getResponseUserName());
		map.put("v_pUserNM2", qstResponseVO.getResponseUserName2());
		map.put("v_pEmail", qstResponseVO.getResponseUserEmail());
		map.put("v_pDeptID", qstResponseVO.getResponseUserDeptId());
		map.put("v_pDeptNM", qstResponseVO.getResponseUserDeptName());
		map.put("v_pDeptNM2", qstResponseVO.getResponseUserDeptName2());
		map.put("v_pPos", qstResponseVO.getResponseUserPosition());
		map.put("v_pPos2", qstResponseVO.getResponseUserPosition2());
		map.put("v_pJikGub", qstResponseVO.getResponseUserJikgub());
		map.put("v_pJikGub2", qstResponseVO.getResponseUserJikgub2());
		map.put("v_pGender", qstResponseVO.getResponseUserGender());
		map.put("v_pAge", qstResponseVO.getResponseUserAge());
		map.put("v_pResDate", qstResponseVO.getResponseDate());
		map.put("v_pResUserIP", qstResponseVO.getResponseUserIp());
		ezQuestionDAO.insertResponse2(map);
	}

	@Override
	public Integer getResPersonCnt(int brdId, int itemNo, int questionNo) throws Exception {
		Map<String, Object> map = new HashMap<String, Object> ();
		map.put("v_pstrBrdID", brdId);
		map.put("v_pItemNo", itemNo);
		map.put("v_pQuesNo", questionNo);
		return ezQuestionDAO.getResponsePersonCnt(map);
	}

	@Override
	public String getReadDateItemForResult(QstUserPollItemVO qstUserPollItemVO, String userId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object> ();
		map.put("v_pstrBrdID", qstUserPollItemVO.getBrdId());
		map.put("v_pItemNo", qstUserPollItemVO.getItemNo());
		map.put("v_pUserID", userId);
		return ezQuestionDAO.getReadDateItemForResult(map);
	}
	
	@Override
	public void deletePermission(int brdId, int itemNo) throws Exception {
		Map<String, Object> map = new HashMap<String, Object> ();
		map.put("v_pstrBrdID", brdId);
		map.put("v_pItemNo", itemNo);
		ezQuestionDAO.deletePermission(map);
	}
	@Override
	public String getTableAnswer(int brdId, int itemNo, int questionNo) throws Exception {
		Map<String, Object> map = new HashMap<String, Object> ();
		map.put("v_pstrBrdID", brdId);
		map.put("v_pItemNo", itemNo);
		map.put("v_pQuesNo", questionNo);
		List<String> list = ezQuestionDAO.getTableAnswer(map);
		StringBuilder sb = new StringBuilder();
		if(list != null){
			sb.append("<DATA>");
			for(String answerAnswerContent : list){
				sb.append("<ROW>");
				sb.append("<ANSWER_ANSWERCONTENT>");
				sb.append("<ANSWER_ANSWERCONTENT>");
				sb.append(answerAnswerContent);
				sb.append("</ROW>");
			}
			sb.append("</DATA>");
		}	
		return sb.toString();
	}

	@Override
	public String getResponseAnswer(int brdId, int itemNo, int questionNo) throws Exception {
		Map<String, Object> map = new HashMap<String, Object> ();
		map.put("v_pstrBrdID", brdId);
		map.put("v_pItemNo", itemNo);
		map.put("v_pQuesNo", questionNo);
		List<String> list = ezQuestionDAO.getResponseAnswer(map);
		StringBuilder sb = new StringBuilder();
		if(list != null){
			sb.append("<DATA>");
			for(String answerSubjectivity : list){
				sb.append("<ROW>");
				sb.append("<ANSWER_SUBJECTIVITY>");
				sb.append(answerSubjectivity);
				sb.append("</ANSWER_SUBJECTIVITY>");
				sb.append("</ROW>");
			}
			sb.append("</DATA>");
		}	
		return sb.toString();
	}

	@Override
	public Integer pollRespCnt(int brdId, int itemNo, int questionNo, int iAnsCnt) throws Exception{
		Map<String, Object> map = new HashMap<String, Object> ();
		map.put("v_pstrBrdID", brdId);
		map.put("v_pItemNo", itemNo);
		map.put("v_pQuesNo", questionNo);
		map.put("v_piCount", iAnsCnt);
		return ezQuestionDAO.pollRespCnt(map);
	}

	@Override
	public Integer pollRespCnt2(int brdId, int itemNo, int questionNo, int iAnsCnt) throws Exception{
		Map<String, Object> map = new HashMap<String, Object> ();
		map.put("v_pstrBrdID", brdId);
		map.put("v_pItemNo", itemNo);
		map.put("v_pQuesNo", questionNo);
		map.put("v_piCount", iAnsCnt);
		return ezQuestionDAO.pollRespCnt2(map);
	}

	@Override
	public QstAttachVO getAttachInfo2(String vBrdId, String vItemNo, String strQuestionNo, String strAnswer, String strAttID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", vBrdId);
		map.put("v_pItemNo", vItemNo);
		map.put("v_pQuesNo", strQuestionNo);
		map.put("v_pAnswerNo", strAnswer);
		map.put("v_pAttachNo", strAttID);
		return ezQuestionDAO.getAttachInfo2(map);
	}

	@Override
	public Integer resultSubjectiveListCnt(int brdId, int itemNo, int questionNo, String lang) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", brdId);
		map.put("v_pItemNo", itemNo);
		map.put("v_pQuesNo", questionNo);
		map.put("v_pLang", lang);
		return Integer.parseInt(ezQuestionDAO.resultSubjectiveListCnt(map));
	}

	@Override
	public List<QstResponseVO> resultSubjectiveList(String brdId, String itemNo, String questionNo, int pTotalCnt, int pPageSize, String lang) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", brdId);
		map.put("v_pItemNo", itemNo);
		map.put("v_pQuesNo", questionNo);
		map.put("v_pTotalCnt", pTotalCnt);
		map.put("v_pPageSize", pPageSize);
		map.put("v_pLang", lang);
		return ezQuestionDAO.resultSubjectiveList(map);
	}

	@Override
	public QstVO getQuestionForSubjective(String brdId, String itemNo, String questionNo) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", brdId);
		map.put("v_pItemNo", itemNo);
		map.put("v_pQuesNo", questionNo);
		return ezQuestionDAO.getQuestionForSubjective(map);
	}

	@Override
	public Integer responseListCnt(String brdId, String itemNo, String responseYN, String lang) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", brdId);
		map.put("v_pItemNo", itemNo);
		map.put("v_pResYN", responseYN);
		map.put("v_pLang", lang);
		return Integer.parseInt(ezQuestionDAO.responseListCnt(map));
	}
	
	@Override
	public List<QstResponseVO> responseList(String brdId, String itemNo, String responseYN, int pTotalCnt, int pPageSize, String lang) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", brdId);
		map.put("v_pItemNo", itemNo);
		map.put("v_pResYN", responseYN);
		map.put("v_pTotalCnt", pTotalCnt);
		map.put("v_pPageSize", pPageSize);
		map.put("v_pLang", lang);
		return ezQuestionDAO.responseList(map);
	}	
	
	
}
