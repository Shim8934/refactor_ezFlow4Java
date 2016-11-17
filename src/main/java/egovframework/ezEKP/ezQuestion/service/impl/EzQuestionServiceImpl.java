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
import egovframework.ezEKP.ezQuestion.vo.QstDeleteAttachUrlVO;
import egovframework.ezEKP.ezQuestion.vo.QstListVO;
import egovframework.ezEKP.ezQuestion.vo.QstResponsePersonVO;
import egovframework.ezEKP.ezQuestion.vo.QstResponseVO;
import egovframework.ezEKP.ezQuestion.vo.QstReuseQuestionVO;
import egovframework.ezEKP.ezQuestion.vo.QstTempSaveVO;
import egovframework.ezEKP.ezQuestion.vo.QstUserPermissionVO;
import egovframework.ezEKP.ezQuestion.vo.QstUserPollItemVO;
import egovframework.ezEKP.ezQuestion.vo.QstVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("EzQuestionService")
public class EzQuestionServiceImpl extends EgovAbstractServiceImpl implements EzQuestionService{
	@Resource(name="EzQuestionDAO")
	private EzQuestionDAO ezQuestionDAO;
	
	@Override
	public Integer getQstListCnt(QstListVO questionListVO) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_PSTRBRDID", questionListVO.getBrdID());
		map.put("v_PUSERID", questionListVO.getUserID());
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
		map.put("v_PSTRBRDID", questionListVO.getBrdID());
		map.put("v_PUSERID", questionListVO.getUserID());
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
	public Integer getItemNoCnt(int brdID, int itemNo) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", brdID);
		map.put("v_pItemNo", itemNo);
		return ezQuestionDAO.getItemNoCnt(map);
	}
	
	@Override
	public void insertItemSeq(String brdID) throws Exception {
		ezQuestionDAO.insertItemSeq(brdID);
	}

	@Override
	public void updateItemSeq(int brdID, int itemNo) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", brdID);
		map.put("v_pItemNo", itemNo);
		ezQuestionDAO.updateItemSeq(map);
	}

	@Override
	public void stepSave(String pUserID, Map<String,Object> map) throws Exception {
		Calendar calendar = Calendar.getInstance();
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
		map.put("v_pstrBrdID", map.get("brdID"));
		map.put("v_pItemNo", map.get("itemNo"));
		map.put("v_pUserID", pUserID);
		map.put("v_pUserNM", map.get("userNm"));
		map.put("v_pUserNM2", map.get("userNm2"));
		map.put("v_pUserEmail", map.get("userEmail"));
		map.put("v_pTitle", map.get("subject"));
		map.put("v_pContent", map.get("content"));
		map.put("v_pPostDate", dateFormat.format(calendar.getTime()));
		map.put("v_pPostTerm", map.get("expiredate"));
		map.put("v_pItemRef", map.get("itemNo"));
		map.put("v_pItemImp", map.get("importance"));
		map.put("v_pSDate", map.get("startdate"));
		map.put("v_pEdate", map.get("enddate"));
		map.put("v_pDataCount", map.get("dataCount"));
		ezQuestionDAO.stepSave(map);
	}

	@Override
	public void stepSave2(Map<String, Object> map) throws Exception {
		map.put("v_pstrBrdID", map.get("brdID"));
		map.put("v_pItemNo", map.get("itemNo"));
		map.put("v_PRESULTFLG", map.get("openresult"));
		map.put("v_PPUBLICFLG", map.get("anonymity"));
		map.put("v_PMULTIFLG", map.get("multiresponse"));
		map.put("v_PRESRANGE", map.get("target"));
		map.put("v_PDATACOUNT", map.get("dataCount"));
		ezQuestionDAO.stepSave2(map);
	}

	@Override
	public String getItemSeq(String brdID) throws Exception {
		return ezQuestionDAO.getItemSeq(brdID);
	}
	
	@Override
	public QstUserPollItemVO getUserPollItem(QstUserPollItemVO userPollItemVO) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", userPollItemVO.getBrdID());
		map.put("v_pItemNo", userPollItemVO.getItemNo());
		return ezQuestionDAO.getUserPollItem(map);
	}

	@Override
	public QstUserPermissionVO getUserPermission(QstUserPermissionVO userPermissionVO) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", userPermissionVO.getBrdID());
		map.put("v_pItemNo", userPermissionVO.getItemNo());
		return ezQuestionDAO.getUserPermission(map);
	}

	@Override
	public Integer getUserResponseCnt(QstUserPermissionVO userPermissionVO,String userID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", userPermissionVO.getBrdID());
		map.put("v_pItemNo", userPermissionVO.getItemNo());
		map.put("v_puserID", userID);
		return ezQuestionDAO.getUserResponseCnt(map);
	}
	
	@Override
	public String getUserIDAdmin(int brdID) throws Exception {
		return ezQuestionDAO.getUserIDAdmin(brdID);
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
		map.put("v_pGubunID", qstCompleteVO.getGubunID());
		map.put("v_pGubunNm", qstCompleteVO.getGubunNm());
		map.put("v_pGubunNm2", qstCompleteVO.getGubunNm2());
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
	public Integer getQuestionNo(int brdID, int itemNo) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID",brdID);
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
	public Integer getResponseDateCnt(QstUserPermissionVO userPermissionVO,String userID) {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", userPermissionVO.getBrdID());
		map.put("v_pItemNo", userPermissionVO.getItemNo());
		map.put("v_pUserID", userID);
		return ezQuestionDAO.getResponseDateCnt(map);
	}

	@Override
	public Integer resCount(String brdID, String itemNo) {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", Integer.parseInt(brdID));
		map.put("v_pItemNo", Integer.parseInt(itemNo));
		return ezQuestionDAO.resCount(map);
	}

	@Override
	public void updateReadCnt(QstUserPollItemVO qstUserPollItemVO) {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pReadCnt", qstUserPollItemVO.getReadCnt());
		map.put("v_pstrBrdID", qstUserPollItemVO.getBrdID());
		map.put("v_pItemNo", qstUserPollItemVO.getItemNo());
		ezQuestionDAO.updateReadCnt(map);
	}

	@Override
	public Integer getReadDateItem(QstUserPollItemVO qstUserPollItemVO, String userID) {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", qstUserPollItemVO.getBrdID());
		map.put("v_pItemNo", qstUserPollItemVO.getItemNo());
		map.put("v_pUserID", userID);
		return ezQuestionDAO.getReadDateItem(map);
	}
	
	@Override
	public void updateReadDate(QstUserPollItemVO qstUserPollItemVO, String readDate,String userID) {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", qstUserPollItemVO.getBrdID());
		map.put("v_pItemNo", qstUserPollItemVO.getItemNo());
		map.put("v_pUserID", userID);
		map.put("v_pReadDate", readDate);
		ezQuestionDAO.updateReadDate(map);
	}

	@Override
	public void insertItemRead(LoginVO loginVO, QstUserPollItemVO qstUserPollItemVO, String readDate) {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", qstUserPollItemVO.getBrdID());
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
		map.put("v_pstrBrdID", questionVO.getBrdID());
		map.put("v_pItemNo", questionVO.getItemNo());
		return ezQuestionDAO.getQuestionForResponse(map);
	}

	@Override
	public List<QstAttachVO> getAttachInfo(QstAttachVO qstAttachVO)	throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", qstAttachVO.getBrdID());
		map.put("v_pItemNo", qstAttachVO.getItemNo());
		map.put("v_pQuesNo", qstAttachVO.getQuestionNo());
		map.put("v_pAnswerNo", qstAttachVO.getAnswerNo());
		return ezQuestionDAO.getAttachInfo(map);
	}
	
	@Override
	public List<QstAttachVO> getAttachInfo3(QstAttachVO qstAttachVO)	throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", qstAttachVO.getBrdID());
		map.put("v_pItemNo", qstAttachVO.getItemNo());
		map.put("v_pQuesNo", qstAttachVO.getQuestionNo());
		return ezQuestionDAO.getAttachInfo03(map);
	}

	@Override
	public List<QstAnswerVO> getAnswerAnswerCnt(int brdID, int itemNo, int qstNo) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", brdID);
		map.put("v_pItemNo", itemNo);
		map.put("v_pQuesNo", qstNo);
		return ezQuestionDAO.getAnswerAnswerCnt(map);
	}

	@Override
	public List<QstAnswerVO> getAnswerCnt(int brdID, int itemNo, int qstNo) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", brdID);
		map.put("v_pItemNo", itemNo);
		map.put("v_pQuesNo", qstNo);
		return ezQuestionDAO.getAnswerCnt(map);
	}

	@Override
	public QstUserPermissionVO getResponseRange(QstUserPermissionVO qstUserPermissionVO) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", qstUserPermissionVO.getBrdID());
		map.put("v_pItemNo", qstUserPermissionVO.getItemNo());
		return ezQuestionDAO.getResponseRange(map);
	}

	@Override
	public QstResponsePersonVO getResponsePerson(QstResponsePersonVO qstResponsePersonVO) throws Exception {
		Map<String, Object> map = new HashMap<String, Object> ();
		map.put("v_pstrBrdID", qstResponsePersonVO.getBrdID());
		map.put("v_pItemNo", qstResponsePersonVO.getItemNo());
		map.put("v_pUserID", qstResponsePersonVO.getUserID());
		return ezQuestionDAO.getResponsePerson(map);
	}

	@Override
	public void updateResponsePerson(QstResponsePersonVO qstResponsePersonVO)throws Exception {
		Map<String, Object> map = new HashMap<String, Object> ();
		map.put("v_pstrBrdID", qstResponsePersonVO.getBrdID());
		map.put("v_pItemNo", qstResponsePersonVO.getItemNo());
		map.put("v_pUserID", qstResponsePersonVO.getUserID());
		ezQuestionDAO.updateResponsePerson(map);
	}

	@Override
	public void updateResCnt(int brdID,int itemNo) throws Exception {
		Map<String, Object> map = new HashMap<String, Object> ();
		map.put("v_pstrBrdID", brdID);
		map.put("v_pItemNo", itemNo);
		ezQuestionDAO.updateResCnt(map);	
	}

	@Override
	public Integer getResponseMaxNo(int brdID, int itemNo, int questionNo) throws Exception {
		Map<String, Object> map = new HashMap<String, Object> ();
		map.put("v_pstrBrdID", brdID);
		map.put("v_pItemNo", itemNo);
		map.put("v_pQuesNo", questionNo);
		return ezQuestionDAO.getResponseMaxNo(map);
	}

	@Override
	public Integer getAnsCnt(int brdID, int itemNo, int quesNo) throws Exception {
		Map<String, Object> map = new HashMap<String, Object> ();
		map.put("v_pstrBrdID", brdID);
		map.put("v_pItemNo", itemNo);
		map.put("v_pQuesNo", quesNo);
		return ezQuestionDAO.getAnsCnt(map);
	}

	@Override
	public void insertResponse(QstResponseVO qstResponseVO) throws Exception {
		Map<String, Object> map = new HashMap<String, Object> ();
		map.put("v_pstrBrdID", qstResponseVO.getBrdID());
		map.put("v_pItemNo", qstResponseVO.getItemNo());
		map.put("v_pQuesNo", qstResponseVO.getQuestionNo());
		map.put("v_pResNo", qstResponseVO.getResponseNo());
		map.put("v_pAobj", qstResponseVO.getAnswerObjectivity());
		map.put("v_pUserID", qstResponseVO.getResponseUserID());
		map.put("v_pUserNM", qstResponseVO.getResponseUserName());
		map.put("v_pUserNM2", qstResponseVO.getResponseUserName2());
		map.put("v_pEmail", qstResponseVO.getResponseUserEmail());
		map.put("v_pDeptID", qstResponseVO.getResponseUserDeptID());
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
		map.put("v_pstrBrdID", qstResponseVO.getBrdID());
		map.put("v_pItemNo", qstResponseVO.getItemNo());
		map.put("v_pQuesNo", qstResponseVO.getQuestionNo());
		map.put("v_pResNo", qstResponseVO.getResponseNo());
		map.put("v_pAsub", qstResponseVO.getAnswerSubjectivity());
		map.put("v_pUserID", qstResponseVO.getResponseUserID());
		map.put("v_pUserNM", qstResponseVO.getResponseUserName());
		map.put("v_pUserNM2", qstResponseVO.getResponseUserName2());
		map.put("v_pEmail", qstResponseVO.getResponseUserEmail());
		map.put("v_pDeptID", qstResponseVO.getResponseUserDeptID());
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
	public Integer getResPersonCnt(int brdID, int itemNo, int questionNo) throws Exception {
		Map<String, Object> map = new HashMap<String, Object> ();
		map.put("v_pstrBrdID", brdID);
		map.put("v_pItemNo", itemNo);
		map.put("v_pQuesNo", questionNo);
		return ezQuestionDAO.getResponsePersonCnt(map);
	}

	@Override
	public String getReadDateItemForResult(QstUserPollItemVO qstUserPollItemVO, String userID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object> ();
		map.put("v_pstrBrdID", qstUserPollItemVO.getBrdID());
		map.put("v_pItemNo", qstUserPollItemVO.getItemNo());
		map.put("v_pUserID", userID);
		return ezQuestionDAO.getReadDateItemForResult(map);
	}
	
	@Override
	public void deletePermission(int brdID, int itemNo) throws Exception {
		Map<String, Object> map = new HashMap<String, Object> ();
		map.put("v_pstrBrdID", brdID);
		map.put("v_pItemNo", itemNo);
		ezQuestionDAO.deletePermission(map);
	}
	@Override
	public String getTableAnswer(int brdID, int itemNo, int questionNo) throws Exception {
		Map<String, Object> map = new HashMap<String, Object> ();
		map.put("v_pStrBrdID", brdID);
		map.put("v_pItemNo", itemNo);
		map.put("v_pQuestionNo", questionNo);
		List<String> list = ezQuestionDAO.getTableAnswer(map);
		StringBuilder sb = new StringBuilder();
		if(list != null){
			sb.append("<DATA>");
			for(String answerAnswerContent : list){
				sb.append("<ROW>");
				sb.append("<ANSWER_ANSWERCONTENT>");
				sb.append(answerAnswerContent);
				sb.append("</ANSWER_ANSWERCONTENT>");
				sb.append("</ROW>");
			}
			sb.append("</DATA>");
		}	
		return sb.toString();
	}
	
	@Override
	public String tableAnswerValue(int brdID, int itemNo, int questionNo) throws Exception {
		Map<String, Object> map = new HashMap<String, Object> ();
		map.put("v_PSTRBRDID", brdID);
		map.put("v_PITEMNO", itemNo);
		map.put("v_PQUESNO", questionNo);
		List<String> list = ezQuestionDAO.tableAnswerValue(map);
		
		StringBuilder sb = new StringBuilder();
		if(list != null){
			sb.append("<DATA>");
			for(String answerAnswerContent : list){
				sb.append("<ROW>");
				sb.append("<ANSWER_ANSWERCONTENT>");
				sb.append(answerAnswerContent);
				sb.append("</ANSWER_ANSWERCONTENT>");
				sb.append("</ROW>");
			}
			sb.append("</DATA>");
		}	
		return sb.toString();
	}

	@Override
	public String getResponseAnswer(int brdID, int itemNo, int questionNo) throws Exception {
		Map<String, Object> map = new HashMap<String, Object> ();
		map.put("v_PSTRBRDID", brdID);
		map.put("v_PITEMNO", itemNo);
		map.put("v_PQUESNO", questionNo);
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
	public Integer pollRespCnt(int brdID, int itemNo, int questionNo, int iAnsCnt) throws Exception{
		Map<String, Object> map = new HashMap<String, Object> ();
		map.put("v_pstrBrdID", brdID);
		map.put("v_pItemNo", itemNo);
		map.put("v_pQuesNo", questionNo);
		map.put("v_piCount", iAnsCnt);
		return ezQuestionDAO.pollRespCnt(map);
	}

	@Override
	public Integer pollRespCnt2(int brdID, int itemNo, int questionNo, int iAnsCnt) throws Exception{
		Map<String, Object> map = new HashMap<String, Object> ();
		map.put("v_pstrBrdID", brdID);
		map.put("v_pItemNo", itemNo);
		map.put("v_pQuesNo", questionNo);
		map.put("v_piCount", iAnsCnt);
		return ezQuestionDAO.pollRespCnt2(map);
	}

	@Override
	public QstAttachVO getAttachInfo2(String vBrdID, String vItemNo, String strQuestionNo, String strAnswer, String strAttID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", vBrdID);
		map.put("v_pItemNo", vItemNo);
		map.put("v_pQuesNo", strQuestionNo);
		map.put("v_pAnswerNo", strAnswer);
		map.put("v_pAttachNo", strAttID);
		return ezQuestionDAO.getAttachInfo2(map);
	}
	
	@Override
	public void changePermission(QstUserPermissionVO qstUserPermissionVO, QstUserPollItemVO qstUserPollItemVO) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", qstUserPermissionVO.getBrdID());
		map.put("v_pItemNo", qstUserPermissionVO.getItemNo());
		map.put("v_psubject", qstUserPollItemVO.getTitle());
		map.put("v_pcontent", qstUserPollItemVO.getContent());
		map.put("v_ppostterm", qstUserPollItemVO.getPostTerm());
		map.put("v_pstartdate", qstUserPollItemVO.getPostDate());
		map.put("v_penddate", qstUserPollItemVO.getPollEndDate());
		map.put("v_presultflg", qstUserPermissionVO.getPublicResultFlg());
		map.put("v_pflg", qstUserPermissionVO.getPublicFlg());
		map.put("v_pmultiflg", qstUserPermissionVO.getMultiResponseFlg());
		map.put("v_pendflg", qstUserPermissionVO.getEndFlg());
		map.put("v_presponserange", qstUserPermissionVO.getResponseRange());
		ezQuestionDAO.changePermission(map);
	}
	
	@Override
	public void updatePollEndDate(int brdID, int itemNo, String endDate, String endFlag) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", brdID);
		map.put("v_pItemNo", itemNo);
		map.put("v_penddate", endDate);
		map.put("v_pendflg", endFlag);
		ezQuestionDAO.updatePollEndDate(map);
	}
	
	@Override
	public QstReuseQuestionVO reUseQuestionData(int brdID, int itemNo) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_BRD_ID", brdID);
		map.put("v_ITEM_NO", itemNo);
		return ezQuestionDAO.reUseQuestionData(map);
	}

	@Override
	public Integer resultSubjectiveListCnt(int brdID, int itemNo, int questionNo, String lang) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", brdID);
		map.put("v_pItemNo", itemNo);
		map.put("v_pQuesNo", questionNo);
		map.put("v_pLang", lang);
		return Integer.parseInt(ezQuestionDAO.resultSubjectiveListCnt(map));
	}

	@Override
	public List<QstResponseVO> resultSubjectiveList(String brdID, String itemNo, String questionNo, int pTotalCnt, int pPageSize, String lang) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", brdID);
		map.put("v_pItemNo", itemNo);
		map.put("v_pQuesNo", questionNo);
		map.put("v_pTotalCnt", pTotalCnt);
		map.put("v_pPageSize", pPageSize);
		map.put("v_pLang", lang);
		return ezQuestionDAO.resultSubjectiveList(map);
	}

	@Override
	public QstVO getQuestionForSubjective(String brdID, String itemNo, String questionNo) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", brdID);
		map.put("v_pItemNo", itemNo);
		map.put("v_pQuesNo", questionNo);
		return ezQuestionDAO.getQuestionForSubjective(map);
	}

	@Override
	public Integer responseListCnt(String brdID, String itemNo, String responseYN, String lang) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", brdID);
		map.put("v_pItemNo", itemNo);
		map.put("v_pResYN", responseYN);
		map.put("v_pLang", lang);
		return Integer.parseInt(ezQuestionDAO.responseListCnt(map));
	}
	
	@Override
	public List<QstResponseVO> responseList(String brdID, String itemNo, String responseYN, int pTotalCnt, int pPageSize, String lang) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", brdID);
		map.put("v_pItemNo", itemNo);
		map.put("v_pResYN", responseYN);
		map.put("v_pTotalCnt", pTotalCnt);
		map.put("v_pPageSize", pPageSize);
		map.put("v_pLang", lang);
		return ezQuestionDAO.responseList(map);
	}

	@Override
	public List<QstVO> getObjQuestion(String pBrdID, String pItemNo) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", pBrdID);
		map.put("v_pItemNo", pItemNo);
		return ezQuestionDAO.getObjQuestion(map);
	}

	@Override
	public List<QstVO> getQuestion(String vBrdID, String vItemNo, String vQuesNo) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", vBrdID);
		map.put("v_pItemNo", vItemNo);
		map.put("v_pQuesNo", vQuesNo);
		return ezQuestionDAO.getQuestion(map);
	}
	
	@Override
	public int callGetItemSeq(int brdID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", brdID);
		return ezQuestionDAO.callGetItemSeq(map);
	}

	@Override
	public void callUpdateItemSeq(int brdID, int itemNo) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", brdID);
		map.put("v_pItemNo", itemNo);
		ezQuestionDAO.callUpdateItemSeq(map);
	}
	
	@Override
	public void callInsertItemSeq(int brdID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", brdID);
		ezQuestionDAO.callInsertItemSeq(map);
	}

	@Override
	public void callDeleteItemSeq(int brdID, int itemNo) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", brdID);
		map.put("v_pItemNo", itemNo);
		ezQuestionDAO.callDeleteItemSeq(map);
	}

	@Override
	public void callDeletePollResponseper(int brdID, int itemNo) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", brdID);
		map.put("v_pItemNo", itemNo);
		ezQuestionDAO.callDeletePollResponseper(map);
	}
	@Override
	public String analysisCount(String vItemNo, String vQuesNo) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pItemNo", vItemNo);
		map.put("v_pQuesNo", vQuesNo);
		return ezQuestionDAO.analysisCount(map);
	}

	@Override
	public List<QstResponseVO> gwPollGetSearch(String vItemNo, String vQuesNo) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pItemNo", vItemNo);
		map.put("v_pQuesNo", vQuesNo);
		return ezQuestionDAO.gwPollGetSearch(map);
	}

	@Override
	public List<QstResponseVO> gwPollPositionSearch(String vItemNo, String vQuesNo) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pItemNo", vItemNo);
		map.put("v_pQuesNo", vQuesNo);
		return ezQuestionDAO.gwPollPositionSearch(map);
	}

	@Override
	public List<QstResponseVO> gwPollJikgubSearch(String vItemNo, String vQuesNo) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pItemNo", vItemNo);
		map.put("v_pQuesNo", vQuesNo);
		return ezQuestionDAO.gwPollJikgubSearch(map);
	}
	
	@Override
	public List<QstDeleteAttachUrlVO> getDeleteAttachUrl(int brdID, int itemNo) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", brdID);
		map.put("v_pItemNo", itemNo);
		return ezQuestionDAO.getDeleteAttachUrl(map);
	}

	@Override
	public String getQuestionNoCnt(String itemNo) throws Exception {
		return ezQuestionDAO.getQuestionNoCnt(itemNo);
	}

	@Override
	public List<QstResponseVO> getRespersonForResultTotalSave(int itemNo) throws Exception {
		return ezQuestionDAO.getResponsePersonForResultTotalSave(itemNo);
	}

	@Override
	public List<QstTempSaveVO> tempSave(int brdID, int itemNo) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", brdID);
		map.put("v_pItemNo", itemNo);
		return ezQuestionDAO.tempSave(map);
	}

	@Override
	public void questionDelete2(int brdID, int itemNo) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", brdID);
		map.put("v_pItemNo", itemNo);
		ezQuestionDAO.questionDelete2(map);
	}

	@Override
	public void questionDelete1(int brdID, int itemNo, int quesNo) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", brdID);
		map.put("v_pItemNo", itemNo);
		map.put("v_pQuesNo", quesNo);
		ezQuestionDAO.questionDelete2(map);
	}

	@Override
	public void deletePollAttach(int brdID, int itemNo) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", brdID);
		map.put("v_pItemNo", itemNo);
		ezQuestionDAO.deletePollAttach(map);
	}

	@Override
	public int wpCountPollCount(String userID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pUSERID", userID);
		return ezQuestionDAO.wpCountPollCount(map);
	}

	@Override
	public void updateTblPollItem(String endDate, int brdID, int itemNo) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("endDate", endDate);
		map.put("brdID", brdID);
		map.put("itemNo", itemNo);
		ezQuestionDAO.updateTblPollItem(map);
	}

	@Override
	public void updateTblPollPermission(String endFlag, int brdID, int itemNo) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("endFlag", endFlag);
		map.put("brdID", brdID);
		map.put("itemNo", itemNo);
		ezQuestionDAO.updateTblPollPermission(map);
	}

	@Override
	public int getQstResponse(int brdID, int itemNo) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", brdID);
		map.put("v_pItemNo", itemNo);
		return ezQuestionDAO.getQstResponse(map);
	}
	
	
	
}
