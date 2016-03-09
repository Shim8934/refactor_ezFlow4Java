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
import egovframework.ezEKP.ezQuestion.vo.QuestionListVO;
import egovframework.ezEKP.ezQuestion.vo.UserPermissionVO;
import egovframework.ezEKP.ezQuestion.vo.UserPollItemVO;

@Service("EzQuestionService")
public class EzQuestionServiceImpl implements EzQuestionService{
	
	@Resource(name="EzQuestionDAO")
	private EzQuestionDAO ezQuestionDAO;
	
	Map<String, Object> map = new HashMap<String, Object>();
	
	@Override
	public int getQstListCnt(QuestionListVO questionListVO) throws Exception {
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
	public List<QuestionListVO> getQstList(QuestionListVO questionListVO) throws Exception {
		map.put("v_PSTRBRDID", questionListVO.getBrdId());
		map.put("v_PUSERID", questionListVO.getUserId());
		map.put("v_PTOTALCNT", questionListVO.getTotalCnt());
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
		//map.put("v_pPostDate", "2016-03-08");
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
	public UserPollItemVO getUserPollItem(UserPollItemVO userPollItemVO) throws Exception {
		map.put("v_pstrBrdID", userPollItemVO.getBrdId());
		map.put("v_pItemNo", userPollItemVO.getItemNo());
		return ezQuestionDAO.getUserPollItem(map);
	}

	@Override
	public UserPermissionVO getUserPermission(UserPermissionVO userPermissionVO) throws Exception {
		map.put("v_pstrBrdID", userPermissionVO.getBrdId());
		map.put("v_pItemNo", userPermissionVO.getItemNo());
		return ezQuestionDAO.getUserPermission(map);
	}

	@Override
	public int getUserResponseCnt(UserPermissionVO userPermissionVO) throws Exception {
		map.put("v_pstrBrdID", userPermissionVO.getBrdId());
		map.put("v_pItemNo", userPermissionVO.getItemNo());
		map.put("v_puserID", userPermissionVO.getUserId());
		return ezQuestionDAO.getUserResponseCnt(map);
	}
}
