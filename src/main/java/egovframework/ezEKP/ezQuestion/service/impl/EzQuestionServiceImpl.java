package egovframework.ezEKP.ezQuestion.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathFactory;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.w3c.dom.Document;
import org.w3c.dom.NodeList;

import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezQuestion.dao.EzQuestionDAO;
import egovframework.ezEKP.ezQuestion.service.EzQuestionService;
import egovframework.ezEKP.ezQuestion.vo.QstAnswerVO;
import egovframework.ezEKP.ezQuestion.vo.QstAttachVO;
import egovframework.ezEKP.ezQuestion.vo.QstCompleteVO;
import egovframework.ezEKP.ezQuestion.vo.QstDeleteAttachUrlVO;
import egovframework.ezEKP.ezQuestion.vo.QstListVO;
import egovframework.ezEKP.ezQuestion.vo.QstPollItemACLVO;
import egovframework.ezEKP.ezQuestion.vo.QstResponsePersonVO;
import egovframework.ezEKP.ezQuestion.vo.QstResponseVO;
import egovframework.ezEKP.ezQuestion.vo.QstReuseQuestionVO;
import egovframework.ezEKP.ezQuestion.vo.QstTempSaveVO;
import egovframework.ezEKP.ezQuestion.vo.QstUserPermissionVO;
import egovframework.ezEKP.ezQuestion.vo.QstUserPollItemVO;
import egovframework.ezEKP.ezQuestion.vo.QstVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Service("EzQuestionService")
public class EzQuestionServiceImpl extends EgovFileMngUtil implements EzQuestionService {
	
	private static final Logger logger = LoggerFactory.getLogger(EzQuestionServiceImpl.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private EzOrganService ezOrganService;
	
	@Autowired
	private EzOrganAdminService ezOrganAdminService;
	
	@Resource(name="EzQuestionDAO")
	private EzQuestionDAO ezQuestionDAO;
	
	@Override
	public Integer getQstListCnt(QstListVO questionListVO, int tenantID) throws Exception {
		logger.debug("getQstListCnt Start");
		
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_PSTRBRDID", questionListVO.getBrdID());
		map.put("v_PUSERID", questionListVO.getUserID());
		map.put("v_PTITLE", questionListVO.getTitle());
		map.put("v_PRANGE", questionListVO.getResponseRange());
		map.put("v_PSDATE",questionListVO.getPollStartDate());
		map.put("v_PEDATE", questionListVO.getPollEndDate());
		map.put("v_PLANG", questionListVO.getLang());
		map.put("rangeLength", questionListVO.getResponseRange().length());
		map.put("eDateLength", questionListVO.getPollEndDate().length());
		map.put("sDateLength", questionListVO.getPollStartDate().length());
		map.put("tenantID", tenantID);
		map.put("companyID", questionListVO.getCompanyID());
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		
		logger.debug("getQstListCnt End");
		return ezQuestionDAO.getQstListCnt(map);
	}

	@Override
	public List<QstListVO> getQstList(QstListVO questionListVO, int tenantID) throws Exception {
		logger.debug("getQstList Start");
		
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_PSTRBRDID", questionListVO.getBrdID());
		map.put("v_PUSERID", questionListVO.getUserID());
		map.put("v_PTOTALCNT", questionListVO.getTotalCnt()-(questionListVO.getCurrPage()-1)*questionListVO.getPageSize());
		map.put("v_PPAGESIZE", questionListVO.getPageSize());
		map.put("v_PTITLE", questionListVO.getTitle());
		map.put("v_PRANGE", questionListVO.getResponseRange());
		map.put("v_PSDATE", questionListVO.getPollStartDate());
		map.put("v_PEDATE", questionListVO.getPollEndDate());
		map.put("v_PLANG", questionListVO.getLang());
		map.put("rangeLength", questionListVO.getResponseRange().length());
		map.put("eDateLength", questionListVO.getPollEndDate().length());
		map.put("sDateLength", questionListVO.getPollStartDate().length());
		map.put("tenantID", tenantID);
		map.put("companyID", questionListVO.getCompanyID());
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		
		logger.debug("getQstList End");
		return ezQuestionDAO.getQstList(map);
	}
	
	@Override
	public Integer getItemNoCnt(int brdID, int itemNo, int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", brdID);
		map.put("v_pItemNo", itemNo);
		map.put("tenantID", tenantID);
		return ezQuestionDAO.getItemNoCnt(map);
	}
	
	@Override
	public void insertItemSeq(String brdID, int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", brdID);
		map.put("tenantID", tenantID);
		ezQuestionDAO.insertItemSeq(map);
	}

	@Override
	public void updateItemSeq(int brdID, int itemNo, int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", brdID);
		map.put("v_pItemNo", itemNo);
		map.put("tenantID", tenantID);
		ezQuestionDAO.updateItemSeq(map);
	}

	@Override
	public void stepSave(String pUserID, Map<String,Object> map) throws Exception {
		map.put("v_pstrBrdID", map.get("brdID"));
		map.put("v_pItemNo", map.get("itemNo"));
		map.put("v_pUserID", pUserID);
		map.put("v_pUserNM", map.get("userNm"));
		map.put("v_pUserNM2", map.get("userNm2"));
		map.put("v_pUserEmail", map.get("userEmail"));
		map.put("v_pTitle", map.get("subject"));
		map.put("v_pContent", map.get("content"));
		map.put("v_pPostDate", commonUtil.getTodayUTCTime(""));
		map.put("v_pPostTerm", map.get("expiredate"));
		map.put("v_pItemRef", map.get("itemNo"));
		map.put("v_pItemImp", map.get("importance"));
		map.put("v_pSDate", map.get("startdate"));
		map.put("v_pEdate", map.get("enddate"));
		map.put("v_pDataCount", map.get("dataCount"));
		map.put("v_companyID", map.get("companyID"));
		
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
	public String getItemSeq(String brdID, int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("brdID", brdID);
		map.put("tenantID", tenantID);
		return ezQuestionDAO.getItemSeq(map);
	}
	
	@Override
	public QstUserPollItemVO getUserPollItem(QstUserPollItemVO userPollItemVO, int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", userPollItemVO.getBrdID());
		map.put("v_pItemNo", userPollItemVO.getItemNo());
		map.put("tenantID", tenantID);
		return ezQuestionDAO.getUserPollItem(map);
	}

	@Override
	public QstUserPermissionVO getUserPermission(QstUserPermissionVO userPermissionVO, int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", userPermissionVO.getBrdID());
		map.put("v_pItemNo", userPermissionVO.getItemNo());
		map.put("tenantID", tenantID);
		return ezQuestionDAO.getUserPermission(map);
	}

	@Override
	public Integer getUserResponseCnt(QstUserPermissionVO userPermissionVO,String userID, int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", userPermissionVO.getBrdID());
		map.put("v_pItemNo", userPermissionVO.getItemNo());
		map.put("v_puserID", userID);
		map.put("tenantID", tenantID);
		return ezQuestionDAO.getUserResponseCnt(map);
	}
	
	@Override
	public void callCreateMother(QstCompleteVO qstCompleteVO, int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", qstCompleteVO.getStrBrdID());
		map.put("v_pItemNo", qstCompleteVO.getItemNo());
		map.put("v_pGubunFg", qstCompleteVO.getGubunFg());
		map.put("v_pGubunID", qstCompleteVO.getGubunID());
		map.put("v_pGubunNm", qstCompleteVO.getGubunNm());
		map.put("v_pGubunNm2", qstCompleteVO.getGubunNm2());
		map.put("v_temp", "");
		map.put("tenantID", tenantID);
		ezQuestionDAO.callCreateMother(map);
	}

	@Override
	public void callInsertPollResponsep1(QstCompleteVO qstCompleteVO, int tenantID) throws Exception {
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
		map.put("tenantID", tenantID);
		
		Integer temp = ezQuestionDAO.callInsertPollResponsep(map);
		
		if (temp != null) {
			ezQuestionDAO.callInsertPollResponsep1(map);
		}
	}

	@Override
	public void callInsertPollResponseper(QstCompleteVO qstCompleteVO, int tenantID) throws Exception {
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
		map.put("v_temp", "");
		map.put("tenantID", tenantID);
		ezQuestionDAO.callInsertPollResponseper(map);
	}

	@Override
	public Integer getQuestionNo(int brdID, int itemNo, int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID",brdID);
		map.put("v_pItemNo", itemNo);
		map.put("tenantID", tenantID);
		return ezQuestionDAO.getQuestionNo(map);
	}

	@Override
	public void insertQuestion(QstCompleteVO qstCompleteVO, int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", qstCompleteVO.getStrBrdID());
		map.put("v_pItemNo", qstCompleteVO.getItemNo());
		map.put("v_pQuesNo", qstCompleteVO.getQuesNo());
		map.put("v_pQuesContent", qstCompleteVO.getQuesContent());
		map.put("v_pAnswerType", qstCompleteVO.getAnswerType());
		map.put("v_pmultiselect", qstCompleteVO.getMultiSelect());
		map.put("tenantID", tenantID);
		ezQuestionDAO.insertQuestion(map);
	}

	@Override
	public void pollSaveAttach(QstCompleteVO qstCompleteVO, int tenantID) throws Exception {
		logger.debug("pollSaveAttach started.");
		
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", qstCompleteVO.getStrBrdID());
		map.put("v_pItemNo", qstCompleteVO.getItemNo());
		map.put("v_pQuesNo", qstCompleteVO.getQuesNo());
		map.put("v_pAnswerNo", qstCompleteVO.getAnswerNo());
		map.put("v_pAttachNo", qstCompleteVO.getAttachNo());
		map.put("v_pAttachName", qstCompleteVO.getAttachName());
		map.put("v_pAttachURL", qstCompleteVO.getAttachURL());
		map.put("v_pAttachType", qstCompleteVO.getAttachType());
		map.put("tenantID", tenantID);
		ezQuestionDAO.pollSaveAttach(map);
		
		logger.debug("pollSaveAttach ended.");
	}

	@Override
	public void insertAnswerAnswerContent(QstCompleteVO qstCompleteVO, int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", qstCompleteVO.getStrBrdID());
		map.put("v_pItemNo", qstCompleteVO.getItemNo());
		map.put("v_pQuesNo", qstCompleteVO.getQuesNo());
		map.put("v_pAnswerNo", qstCompleteVO.getAnswerNo());
		map.put("v_pAnswer_AnswerContent", qstCompleteVO.getAnswerAnswerContent());
		map.put("tenantID", tenantID);
		ezQuestionDAO.insertAnswerAnswerContent(map);
	}

	@Override
	public void insertAnswerContent(QstCompleteVO qstCompleteVO, int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", qstCompleteVO.getStrBrdID());
		map.put("v_pItemNo", qstCompleteVO.getItemNo());
		map.put("v_pQuesNo", qstCompleteVO.getQuesNo());
		map.put("v_pAnswerNo", qstCompleteVO.getAnswerNo());
		map.put("v_pAnswerContent", qstCompleteVO.getAnswerContent());
		map.put("tenantID", tenantID);
		ezQuestionDAO.insertAnswerContent(map);
	}

	@Override
	public void updatePollItem(QstCompleteVO qstCompleteVO, int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", qstCompleteVO.getStrBrdID());
		map.put("v_pItemNo", qstCompleteVO.getItemNo());
		map.put("tenantID", tenantID);
		ezQuestionDAO.updatePollItem(map);
	}

	@Override
	public void deleteItem(QstCompleteVO qstCompleteVO, int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", qstCompleteVO.getStrBrdID());
		map.put("v_pItemNo", qstCompleteVO.getItemNo());
		map.put("tenantID", tenantID);
		ezQuestionDAO.deleteItem_D1(map);
		ezQuestionDAO.deleteItem_D2(map);
		ezQuestionDAO.deleteItem_D3(map);
		ezQuestionDAO.deleteItem_D4(map);
		ezQuestionDAO.deleteItem_D5(map);
		ezQuestionDAO.deleteItem_D6(map);
		ezQuestionDAO.deleteItem_D7(map);
		ezQuestionDAO.deleteItem(map);
	}
	
	@Override
	public void deleteItemList(String itemList, String realPath, int tenantID) throws Exception {
		logger.debug("deleteItemList started. itemList = " + itemList + ", tenantID = " + tenantID);
		
		for (String itemNo : itemList.split(";")) {
			int itemNO = Integer.parseInt(itemNo);
			
			List<QstDeleteAttachUrlVO> tempList = getDeleteAttachUrl(itemNO, tenantID);
			for(QstDeleteAttachUrlVO vo : tempList) {
				if(vo.getAttachType().equals("1") || vo.getAttachType().equals("2")) {
					String url = vo.getAttachUrl().toString();
					
					if (!url.equals("")) {
						deleteFile(realPath + commonUtil.separator + url);
					}
				}
			}
			
			QstCompleteVO qstCompleteVO = new QstCompleteVO();
			qstCompleteVO.setStrBrdID(5);
			qstCompleteVO.setItemNo(itemNO);
			
			deleteItem(qstCompleteVO, tenantID);
			
			deletePollAttach(5, itemNO, tenantID);
		}
		
		logger.debug("deleteItemList ended.");
	}

	@Override
	public Integer getResponseDateCnt(QstUserPermissionVO userPermissionVO,String userID, int tenantID) {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", userPermissionVO.getBrdID());
		map.put("v_pItemNo", userPermissionVO.getItemNo());
		map.put("v_pUserID", userID);
		map.put("tenantID", tenantID);
		return ezQuestionDAO.getResponseDateCnt(map);
	}

	@Override
	public Integer resCount(String brdID, String itemNo, int tenantID) {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", Integer.parseInt(brdID));
		map.put("v_pItemNo", Integer.parseInt(itemNo));
		map.put("tenantID", tenantID);
		return ezQuestionDAO.resCount(map);
	}

	@Override
	public void updateReadCnt(QstUserPollItemVO qstUserPollItemVO, int tenantID) {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pReadCnt", qstUserPollItemVO.getReadCnt());
		map.put("v_pstrBrdID", qstUserPollItemVO.getBrdID());
		map.put("v_pItemNo", qstUserPollItemVO.getItemNo());
		map.put("tenantID", tenantID);
		ezQuestionDAO.updateReadCnt(map);
	}

	@Override
	public Integer getReadDateItem(QstUserPollItemVO qstUserPollItemVO, String userID, int tenantID) {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", qstUserPollItemVO.getBrdID());
		map.put("v_pItemNo", qstUserPollItemVO.getItemNo());
		map.put("v_pUserID", userID);
		map.put("tenantID", tenantID);
		return ezQuestionDAO.getReadDateItem(map);
	}
	
	@Override
	public void updateReadDate(QstUserPollItemVO qstUserPollItemVO, String readDate,String userID, int tenantID) {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", qstUserPollItemVO.getBrdID());
		map.put("v_pItemNo", qstUserPollItemVO.getItemNo());
		map.put("v_pUserID", userID);
		map.put("v_pReadDate", readDate);
		map.put("tenantID", tenantID);
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
		map.put("tenantID", loginVO.getTenantId());
		ezQuestionDAO.insertItemRead(map);
	}

	@Override
	public List<QstVO> getQuestionForResponse(QstVO questionVO, int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", questionVO.getBrdID());
		map.put("v_pItemNo", questionVO.getItemNo());
		map.put("tenantID", tenantID);
		return ezQuestionDAO.getQuestionForResponse(map);
	}

	@Override
	public List<QstAttachVO> getAttachInfo(QstAttachVO qstAttachVO, int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", qstAttachVO.getBrdID());
		map.put("v_pItemNo", qstAttachVO.getItemNo());
		map.put("v_pQuesNo", qstAttachVO.getQuestionNo());
		map.put("v_pAnswerNo", qstAttachVO.getAnswerNo());
		map.put("tenantID", tenantID);
		return ezQuestionDAO.getAttachInfo(map);
	}
	
	@Override
	public List<QstAttachVO> getAttachInfo3(QstAttachVO qstAttachVO, int tenantID)	throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", qstAttachVO.getBrdID());
		map.put("v_pItemNo", qstAttachVO.getItemNo());
		map.put("v_pQuesNo", qstAttachVO.getQuestionNo());
		map.put("tenantID", tenantID);
		return ezQuestionDAO.getAttachInfo03(map);
	}

	@Override
	public List<QstAnswerVO> getAnswerAnswerCnt(int brdID, int itemNo, int qstNo, int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", brdID);
		map.put("v_pItemNo", itemNo);
		map.put("v_pQuesNo", qstNo);
		map.put("tenantID", tenantID);
		return ezQuestionDAO.getAnswerAnswerCnt(map);
	}

	@Override
	public List<QstAnswerVO> getAnswerCnt(int brdID, int itemNo, int qstNo, int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", brdID);
		map.put("v_pItemNo", itemNo);
		map.put("v_pQuesNo", qstNo);
		map.put("tenantID", tenantID);
		return ezQuestionDAO.getAnswerCnt(map);
	}

	@Override
	public QstUserPermissionVO getResponseRange(QstUserPermissionVO qstUserPermissionVO, int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", qstUserPermissionVO.getBrdID());
		map.put("v_pItemNo", qstUserPermissionVO.getItemNo());
		map.put("tenantID", tenantID);
		return ezQuestionDAO.getResponseRange(map);
	}

	@Override
	public QstResponsePersonVO getResponsePerson(QstResponsePersonVO qstResponsePersonVO, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object> ();
		map.put("v_pstrBrdID", qstResponsePersonVO.getBrdID());
		map.put("v_pItemNo", qstResponsePersonVO.getItemNo());
		map.put("v_pUserID", qstResponsePersonVO.getUserID());
		map.put("tenantID", tenantID);
		return ezQuestionDAO.getResponsePerson(map);
	}

	@Override
	public void updateResponsePerson(QstResponsePersonVO qstResponsePersonVO, int tenantID)throws Exception {
		Map<String, Object> map = new HashMap<String, Object> ();
		map.put("v_pstrBrdID", qstResponsePersonVO.getBrdID());
		map.put("v_pItemNo", qstResponsePersonVO.getItemNo());
		map.put("v_pUserID", qstResponsePersonVO.getUserID());
		map.put("v_pNow", commonUtil.getTodayUTCTime(""));
		map.put("tenantID", tenantID);
		ezQuestionDAO.updateResponsePerson(map);
	}

	@Override
	public void updateResCnt(int brdID,int itemNo, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object> ();
		map.put("v_pstrBrdID", brdID);
		map.put("v_pItemNo", itemNo);
		map.put("tenantID", tenantID);
		ezQuestionDAO.updateResCnt(map);	
	}

	@Override
	public Integer getResponseMaxNo(int brdID, int itemNo, int questionNo, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object> ();
		map.put("v_pstrBrdID", brdID);
		map.put("v_pItemNo", itemNo);
		map.put("v_pQuesNo", questionNo);
		map.put("tenantID", tenantID);
		return ezQuestionDAO.getResponseMaxNo(map);
	}

	@Override
	public Integer getAnsCnt(int brdID, int itemNo, int quesNo, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object> ();
		map.put("v_pstrBrdID", brdID);
		map.put("v_pItemNo", itemNo);
		map.put("v_pQuesNo", quesNo);
		map.put("tenantID", tenantID);
		return ezQuestionDAO.getAnsCnt(map);
	}

	@Override
	public void insertResponse(QstResponseVO qstResponseVO, int tenantID) throws Exception {
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
		map.put("tenantID", tenantID);
		ezQuestionDAO.insertResponse(map);
	}

	@Override
	public void insertResponse2(QstResponseVO qstResponseVO, int tenantID) throws Exception {
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
		map.put("tenantID", tenantID);
		ezQuestionDAO.insertResponse2(map);
	}

	@Override
	public Integer getResPersonCnt(int brdID, int itemNo, int questionNo, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object> ();
		map.put("v_pstrBrdID", brdID);
		map.put("v_pItemNo", itemNo);
		map.put("v_pQuesNo", questionNo);
		map.put("tenantID", tenantID);
		return ezQuestionDAO.getResponsePersonCnt(map);
	}

	@Override
	public String getReadDateItemForResult(QstUserPollItemVO qstUserPollItemVO, String userID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object> ();
		map.put("v_pstrBrdID", qstUserPollItemVO.getBrdID());
		map.put("v_pItemNo", qstUserPollItemVO.getItemNo());
		map.put("v_pUserID", userID);
		map.put("tenantID", tenantID);
		return ezQuestionDAO.getReadDateItemForResult(map);
	}
	
	@Override
	public void deletePermission(int brdID, int itemNo, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object> ();
		map.put("v_pstrBrdID", brdID);
		map.put("v_pItemNo", itemNo);
		map.put("tenantID", tenantID);
		ezQuestionDAO.deletePermission(map);
	}
	@Override
	public String getTableAnswer(int brdID, int itemNo, int questionNo, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object> ();
		map.put("v_pStrBrdID", brdID);
		map.put("v_pItemNo", itemNo);
		map.put("v_pQuestionNo", questionNo);
		map.put("tenantID", tenantID);
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
	public String tableAnswerValue(int brdID, int itemNo, int questionNo, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object> ();
		map.put("v_PSTRBRDID", brdID);
		map.put("v_PITEMNO", itemNo);
		map.put("v_PQUESNO", questionNo);
		map.put("tenantID", tenantID);
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
	public String getResponseAnswer(int brdID, int itemNo, int questionNo, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object> ();
		map.put("v_PSTRBRDID", brdID);
		map.put("v_PITEMNO", itemNo);
		map.put("v_PQUESNO", questionNo);
		map.put("tenantID", tenantID);
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
	public Integer pollRespCnt(int brdID, int itemNo, int questionNo, int iAnsCnt, int tenantID) throws Exception{
		Map<String, Object> map = new HashMap<String, Object> ();
		map.put("v_pstrBrdID", brdID);
		map.put("v_pItemNo", itemNo);
		map.put("v_pQuesNo", questionNo);
		map.put("v_piCount", iAnsCnt);
		map.put("tenantID", tenantID);
		return ezQuestionDAO.pollRespCnt(map);
	}

	@Override
	public Integer pollRespCnt2(int brdID, int itemNo, int questionNo, int iAnsCnt, int tenantID) throws Exception{
		Map<String, Object> map = new HashMap<String, Object> ();
		map.put("v_pstrBrdID", brdID);
		map.put("v_pItemNo", itemNo);
		map.put("v_pQuesNo", questionNo);
		map.put("v_piCount", iAnsCnt);
		map.put("tenantID", tenantID);
		return ezQuestionDAO.pollRespCnt2(map);
	}

	@Override
	public QstAttachVO getAttachInfo2(String vBrdID, String vItemNo, String strQuestionNo, String strAnswer, String strAttID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", vBrdID);
		map.put("v_pItemNo", vItemNo);
		map.put("v_pQuesNo", strQuestionNo);
		map.put("v_pAnswerNo", strAnswer);
		map.put("v_pAttachNo", strAttID);
		map.put("tenantID", tenantID);
		return ezQuestionDAO.getAttachInfo2(map);
	}
	
	@Override
	public void changePermission(QstUserPermissionVO qstUserPermissionVO, QstUserPollItemVO qstUserPollItemVO, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", qstUserPermissionVO.getBrdID());
		map.put("v_pItemNo", qstUserPermissionVO.getItemNo());
		map.put("v_psubject", qstUserPollItemVO.getTitle());
		map.put("v_pcontent", qstUserPollItemVO.getContent());
		map.put("v_ppostterm", qstUserPollItemVO.getPostTerm());
		map.put("v_pstartdate", qstUserPollItemVO.getPollStartDate());
		map.put("v_penddate", qstUserPollItemVO.getPollEndDate());
		map.put("v_presultflg", qstUserPermissionVO.getPublicResultFlg());
		map.put("v_pflg", qstUserPermissionVO.getPublicFlg());
		map.put("v_pmultiflg", qstUserPermissionVO.getMultiResponseFlg());
		map.put("v_pendflg", qstUserPermissionVO.getEndFlg());
		map.put("v_presponserange", qstUserPermissionVO.getResponseRange());
		map.put("tenantID", tenantID);
		ezQuestionDAO.changePermission_U(map);
		ezQuestionDAO.changePermission(map);
	}
	
	@Override
	public void updatePollEndDate(int brdID, int itemNo, String endDate, String endFlag, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", brdID);
		map.put("v_pItemNo", itemNo);
		map.put("v_penddate", endDate);
		map.put("v_pendflg", endFlag);
		map.put("tenantID", tenantID);
		ezQuestionDAO.updatePollEndDate_U(map);
		ezQuestionDAO.updatePollEndDate(map);
	}
	
	@Override
	public QstReuseQuestionVO reUseQuestionData(int brdID, int itemNo, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_BRD_ID", brdID);
		map.put("v_ITEM_NO", itemNo);
		map.put("tenantID", tenantID);
		return ezQuestionDAO.reUseQuestionData(map);
	}

	@Override
	public Integer resultSubjectiveListCnt(int brdID, int itemNo, int questionNo, String lang, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", brdID);
		map.put("v_pItemNo", itemNo);
		map.put("v_pQuesNo", questionNo);
		map.put("v_pLang", lang);
		map.put("tenantID", tenantID);
		return Integer.parseInt(ezQuestionDAO.resultSubjectiveListCnt(map));
	}

	@Override
	public List<QstResponseVO> resultSubjectiveList(String brdID, String itemNo, String questionNo, int pTotalCnt, int pPageSize, String lang, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", brdID);
		map.put("v_pItemNo", itemNo);
		map.put("v_pQuesNo", questionNo);
		map.put("v_pTotalCnt", pTotalCnt);
		map.put("v_pPageSize", pPageSize);
		map.put("v_pLang", lang);
		map.put("tenantID", tenantID);
		return ezQuestionDAO.resultSubjectiveList(map);
	}

	@Override
	public List<QstResponseVO> resultSubjectiveListAll(String brdID, String itemNo, String questionNo, int pTotalCnt, int pPageSize, String lang, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", brdID);
		map.put("v_pItemNo", itemNo);
		map.put("v_pQuesNo", questionNo);
		map.put("v_pTotalCnt", pTotalCnt);
		map.put("v_pPageSize", pPageSize);
		map.put("v_pLang", lang);
		map.put("tenantID", tenantID);
		return ezQuestionDAO.resultSubjectiveListAll(map);
	}
	
	@Override
	public QstVO getQuestionForSubjective(String brdID, String itemNo, String questionNo, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", brdID);
		map.put("v_pItemNo", itemNo);
		map.put("v_pQuesNo", questionNo);
		map.put("tenantID", tenantID);
		return ezQuestionDAO.getQuestionForSubjective(map);
	}

	@Override
	public Integer responseListCnt(String brdID, String itemNo, String responseYN, String lang, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", brdID);
		map.put("v_pItemNo", itemNo);
		map.put("v_pResYN", responseYN);
		map.put("v_pLang", lang);
		map.put("tenantID", tenantID);
		return Integer.parseInt(ezQuestionDAO.responseListCnt(map));
	}
	
	@Override
	public List<QstResponseVO> responseList(String brdID, String itemNo, String responseYN, int pTotalCnt, int pPageSize, String lang, int pCurPage, int tenantID) throws Exception {
		logger.debug("responseList started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", brdID);
		map.put("v_pItemNo", itemNo);
		map.put("v_pResYN", responseYN);
		map.put("v_pTotalCnt", pTotalCnt);
		map.put("v_pPageSize", pPageSize);
		map.put("v_pLang", lang);
		map.put("mariaStart", (pCurPage-1) * pPageSize);
		map.put("tenantID", tenantID);
		
		List<QstResponseVO> list = ezQuestionDAO.responseList(map);
		
		logger.debug("responseList ended.");
		
		return list;
	}

	@Override
	public List<QstVO> getObjQuestion(String pBrdID, String pItemNo, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", pBrdID);
		map.put("v_pItemNo", pItemNo);
		map.put("tenantID", tenantID);
		return ezQuestionDAO.getObjQuestion(map);
	}

	@Override
	public List<QstVO> getQuestion(String vBrdID, String vItemNo, String vQuesNo, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", vBrdID);
		map.put("v_pItemNo", vItemNo);
		map.put("v_pQuesNo", vQuesNo);
		map.put("tenantID", tenantID);
		return ezQuestionDAO.getQuestion(map);
	}
	
	@Override
	public int callGetItemSeq(int brdID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", brdID);
		map.put("tenantID", tenantID);
		return ezQuestionDAO.callGetItemSeq(map);
	}

	@Override
	public void callUpdateItemSeq(int brdID, int itemNo, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", brdID);
		map.put("v_pItemNo", itemNo);
		map.put("tenantID", tenantID);
		ezQuestionDAO.callUpdateItemSeq(map);
	}
	
	@Override
	public void callInsertItemSeq(int brdID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", brdID);
		map.put("tenantID", tenantID);
		ezQuestionDAO.callInsertItemSeq(map);
	}

	@Override
	public void callDeleteItemSeq(int brdID, int itemNo, int tenantID) throws Exception {
		logger.debug("callDeleteItemSeq started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", brdID);
		map.put("v_pItemNo", itemNo);
		map.put("tenantID", tenantID);
		ezQuestionDAO.callDeleteItemSeq(map);
		
		logger.debug("callDeleteItemSeq ended.");
	}

	@Override
	public void callDeletePollResponseper(int brdID, int itemNo, int tenantID) throws Exception {
		logger.debug("callDeletePollResponseper started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", brdID);
		map.put("v_pItemNo", itemNo);
		map.put("tenantID", tenantID);
		ezQuestionDAO.callDeletePollResponseper(map);
		
		logger.debug("callDeletePollResponseper ended.");
	}
	@Override
	public String analysisCount(String vItemNo, String vQuesNo, int tenantID) throws Exception {
		logger.debug("analysisCount started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pItemNo", vItemNo);
		map.put("v_pQuesNo", vQuesNo);
		map.put("tenantID", tenantID);
		
		String result = ezQuestionDAO.analysisCount(map);
		
		logger.debug("analysisCount ended. result = " + result);
		
		return result;
	}

	@Override
	public List<QstResponseVO> gwPollGetSearch(String vItemNo, String vQuesNo, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_item_num", vItemNo);
		map.put("v_Que_num", vQuesNo);
		map.put("tenantID", tenantID);
		return ezQuestionDAO.gwPollGetSearch(map);
	}

	@Override
	public List<QstResponseVO> gwPollPositionSearch(String vItemNo, String vQuesNo, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_item_num", vItemNo);
		map.put("v_Que_num", vQuesNo);
		map.put("tenantID", tenantID);
		return ezQuestionDAO.gwPollPositionSearch(map);
	}

	@Override
	public List<QstResponseVO> gwPollJikgubSearch(String vItemNo, String vQuesNo, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pItemNo", vItemNo);
		map.put("v_pQuesNo", vQuesNo);
		map.put("tenantID", tenantID);
		return ezQuestionDAO.gwPollJikgubSearch(map);
	}
	
	@Override
	public List<QstDeleteAttachUrlVO> getDeleteAttachUrl(int itemNo, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pItemNo", itemNo);
		map.put("tenantID", tenantID);
		return ezQuestionDAO.getDeleteAttachUrl(map);
	}

	@Override
	public String getQuestionNoCnt(String itemNo, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pItemNo", itemNo);
		map.put("tenantID", tenantID);
		return ezQuestionDAO.getQuestionNoCnt(map);
	}

	@Override
	public List<QstResponseVO> getRespersonForResultTotalSave(int itemNo, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pItemNo", itemNo);
		map.put("tenantID", tenantID);
		return ezQuestionDAO.getResponsePersonForResultTotalSave(map);
	}

	@Override
	public List<QstTempSaveVO> tempSave(int brdID, int itemNo, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", brdID);
		map.put("v_pItemNo", itemNo);
		map.put("tenantID", tenantID);
		return ezQuestionDAO.tempSave(map);
	}

	@Override
	public void questionDelete2(int brdID, int itemNo, int tenantID) throws Exception {
		logger.debug("questionDelete2 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", brdID);
		map.put("v_pItemNo", itemNo);
		map.put("tenantID", tenantID);
		ezQuestionDAO.questionDelete2(map);
		
		logger.debug("questionDelete2 ended.");
	}
	
	@Override
	public void questionDelete2_D(int brdID, int itemNo, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", brdID);
		map.put("v_pItemNo", itemNo);
		map.put("tenantID", tenantID);
		
		ezQuestionDAO.questionDelete2_D(map);
	}

	@Override
	public void questionDelete1(int brdID, int itemNo, int quesNo, int tenantID) throws Exception {
		logger.debug("questionDelete1 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", brdID);
		map.put("v_pItemNo", itemNo);
		map.put("v_pQuesNo", quesNo);
		map.put("tenantID", tenantID);
		ezQuestionDAO.questionDelete1(map);
		
		logger.debug("questionDelete1 ended.");
	}

	@Override
	public void deletePollAttach(int brdID, int itemNo, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", brdID);
		map.put("v_pItemNo", itemNo);
		map.put("tenantID", tenantID);
		ezQuestionDAO.deletePollAttach(map);
	}

	@Override
	public int wpCountPollCount(String userID, int tenantID, String offset, String companyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pUSERID", userID);
		map.put("tenantID", tenantID);
		map.put("companyID", companyID);
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		return ezQuestionDAO.wpCountPollCount(map);
	}

	@Override
	public void updateTblPollItem(String endDate, int brdID, int itemNo, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("endDate", endDate);
		map.put("brdID", brdID);
		map.put("itemNo", itemNo);
		map.put("tenantID", tenantID);
		ezQuestionDAO.updateTblPollItem(map);
	}

	@Override
	public void updateTblPollPermission(String endFlag, int brdID, int itemNo, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("endFlag", endFlag);
		map.put("brdID", brdID);
		map.put("itemNo", itemNo);
		map.put("tenantID", tenantID);
		ezQuestionDAO.updateTblPollPermission(map);
	}

	@Override
	public Integer getQstResponse(String brdID, String itemNo, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pstrBrdID", brdID);
		map.put("v_pItemNo", itemNo);
		map.put("tenantID", tenantID);
		return ezQuestionDAO.getQstResponse(map);
	}
	
	@Override
	public String saveQuestion(String pBrdID, String vItemID, Document doc, String pUserID, LoginVO loginVO) throws Exception {
		logger.debug("SaveQuestion Start");
		NodeList nList = null;
		int dataCount = 0;
		dataCount = getItemNoCnt(Integer.parseInt(pBrdID), Integer.parseInt(vItemID), loginVO.getTenantId());
		
		String startDate = commonUtil.getDateStringInUTC(doc.getElementsByTagName("STARTDATE").item(0).getTextContent(), loginVO.getOffset(), true);
		String endDate = commonUtil.getDateStringInUTC(doc.getElementsByTagName("ENDDATE").item(0).getTextContent(), loginVO.getOffset(), true);
		
		logger.debug("startDate="+startDate);
		logger.debug("endDate="+endDate);
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("subject", doc.getElementsByTagName("SUBJECT").item(0).getTextContent());
		map.put("content", doc.getElementsByTagName("CONTENT").item(0).getTextContent());
		map.put("startdate", startDate);
		map.put("enddate", endDate);
		map.put("expiredate", doc.getElementsByTagName("EXPIREDATE").item(0).getTextContent());
		map.put("anonymity", doc.getElementsByTagName("ANONYMITY").item(0).getTextContent());
		map.put("openresult", doc.getElementsByTagName("OPENRESULT").item(0).getTextContent());
		map.put("multiresponse", doc.getElementsByTagName("MULTIRESPONSE").item(0).getTextContent());
		map.put("importance", doc.getElementsByTagName("IMPORTANT").item(0).getTextContent());
		map.put("target", doc.getElementsByTagName("TARGET").item(0).getTextContent());
		map.put("brdID", pBrdID);
		map.put("itemNo", Integer.parseInt(vItemID));
		map.put("dataCount", dataCount);
		map.put("userNm", loginVO.getDisplayName1());
		map.put("userNm2", loginVO.getDisplayName2());
		map.put("userEmail", loginVO.getEmail());
		map.put("tenantID", loginVO.getTenantId());
		map.put("companyID", loginVO.getCompanyID());
		
		stepSave(pUserID, map);
		
		Map<String, Object> map2 = new HashMap<String, Object>();
		map2.put("brdID", pBrdID);
		map2.put("itemNo", Integer.parseInt(vItemID));
		map2.put("openresult", doc.getElementsByTagName("OPENRESULT").item(0).getTextContent());
		map2.put("anonymity", doc.getElementsByTagName("ANONYMITY").item(0).getTextContent());
		map2.put("multiresponse", doc.getElementsByTagName("MULTIRESPONSE").item(0).getTextContent());
		map2.put("target", doc.getElementsByTagName("TARGET").item(0).getTextContent());
		map2.put("dataCount", dataCount);
		map2.put("tenantID", loginVO.getTenantId());
		stepSave2(map2);
		//대상범위
		if(doc.getElementsByTagName("TARGET").item(0).getTextContent().equals("1")) {
			
			if(doc.getElementsByTagName("RANGE").item(0).getChildNodes().getLength() > 0) {
				int pDeptCnt = doc.getElementsByTagName("DEPT").item(0).getChildNodes().getLength();
				
				for(int i=0; i<pDeptCnt; i++) {
					QstCompleteVO qstCompleteVO = new QstCompleteVO();
					String deptID = doc.getElementsByTagName("DEPT").item(0).getChildNodes().item(i).getAttributes().getNamedItem("id").getTextContent();
		        	String deptNm = doc.getElementsByTagName("DEPT").item(0).getChildNodes().item(i).getAttributes().getNamedItem("nm").getTextContent();
		        	String deptNm2 = doc.getElementsByTagName("DEPT").item(0).getChildNodes().item(i).getAttributes().getNamedItem("nm2").getTextContent();
		        	qstCompleteVO.setStrBrdID(Integer.parseInt(pBrdID));
		        	qstCompleteVO.setItemNo(Integer.parseInt(vItemID));
		        	qstCompleteVO.setGubunFg("0");
		        	qstCompleteVO.setGubunID(deptID);
		        	qstCompleteVO.setGubunNm(deptNm);
		        	qstCompleteVO.setGubunNm2(deptNm2);
		        	callCreateMother(qstCompleteVO, loginVO.getTenantId());
						
					String cellList = "department";
                    String propList = "department;mail;displayname;title;description;company;title";
                    String pClass = "all";
                       
                    String sXML = ezOrganService.getDeptMemberList(deptID, cellList, propList, pClass, loginVO.getPrimary(), loginVO.getTenantId(), null);
                    
             		Document xmlDom = commonUtil.convertStringToDocument(sXML);
         			for(int j=0; j<xmlDom.getElementsByTagName("CELL").getLength(); j++) {
         				if(!xmlDom.getElementsByTagName("ROWS").item(0).getChildNodes().item(j).getChildNodes().item(0).getChildNodes().item(3).getTextContent().equals("") && xmlDom.getElementsByTagName("ROWS").item(0).getChildNodes().item(j).getChildNodes().item(0).getChildNodes().item(1).getTextContent().equals("user")) {
         					String userID = xmlDom.getElementsByTagName("ROWS").item(0).getChildNodes().item(j).getChildNodes().item(0).getChildNodes().item(2).getTextContent();
         					String userNm = xmlDom.getElementsByTagName("ROWS").item(0).getChildNodes().item(j).getChildNodes().item(0).getChildNodes().item(10).getTextContent();
         					String userNm2 = xmlDom.getElementsByTagName("ROWS").item(0).getChildNodes().item(j).getChildNodes().item(0).getChildNodes().item(11).getTextContent();
         					String userEmail = xmlDom.getElementsByTagName("ROWS").item(0).getChildNodes().item(j).getChildNodes().item(0).getChildNodes().item(4).getTextContent();
         					String deptID2 = xmlDom.getElementsByTagName("ROWS").item(0).getChildNodes().item(j).getChildNodes().item(0).getChildNodes().item(3).getTextContent();
         					String deptNM = xmlDom.getElementsByTagName("ROWS").item(0).getChildNodes().item(j).getChildNodes().item(0).getChildNodes().item(14).getTextContent();
         					String deptNM2 = xmlDom.getElementsByTagName("ROWS").item(0).getChildNodes().item(j).getChildNodes().item(0).getChildNodes().item(15).getTextContent();
         					String userPos = xmlDom.getElementsByTagName("ROWS").item(0).getChildNodes().item(j).getChildNodes().item(0).getChildNodes().item(18).getTextContent();
         					String userPos2 = xmlDom.getElementsByTagName("ROWS").item(0).getChildNodes().item(j).getChildNodes().item(0).getChildNodes().item(19).getTextContent();
         					QstCompleteVO qstCompleteVO2 = new QstCompleteVO();
                         	qstCompleteVO2.setStrBrdID(Integer.parseInt(pBrdID));
                         	qstCompleteVO2.setItemNo(Integer.parseInt(vItemID));
                         	qstCompleteVO2.setUserID(userID);
                         	qstCompleteVO2.setUserNm(userNm);
                         	qstCompleteVO2.setUserNm2(userNm2);
                         	qstCompleteVO2.setUserEmail(userEmail);
                         	qstCompleteVO2.setUserDeptID(deptID2);
                         	qstCompleteVO2.setUserDeptNm(deptNM);
                         	qstCompleteVO2.setUserDeptNm2(deptNM2);
                         	qstCompleteVO2.setUserPOS(userPos);
                         	qstCompleteVO2.setUserPOS2(userPos2);
                         	callInsertPollResponsep1(qstCompleteVO2, loginVO.getTenantId());
         				}
         			}
				}
				
				int pUserCnt = 0;
				
				if(doc.getElementsByTagName("MEMBER").item(0) != null) {
					pUserCnt = doc.getElementsByTagName("MEMBER").item(0).getChildNodes().getLength();
				}
				
				for(int i=0; i<pUserCnt; i++) {
					String userID = doc.getElementsByTagName("MEMBER").item(0).getChildNodes().item(i).getAttributes().getNamedItem("id").getTextContent();
		        	String userNm = doc.getElementsByTagName("MEMBER").item(0).getChildNodes().item(i).getAttributes().getNamedItem("nm").getTextContent();
		        	String userNm2 = doc.getElementsByTagName("MEMBER").item(0).getChildNodes().item(i).getAttributes().getNamedItem("nm2").getTextContent();
		        	
                	QstCompleteVO qstCompleteVO = new QstCompleteVO();
                	qstCompleteVO.setStrBrdID(Integer.parseInt(pBrdID));
                	qstCompleteVO.setItemNo(Integer.parseInt(vItemID));
                	qstCompleteVO.setGubunFg("1");
                	qstCompleteVO.setGubunID(userID);
                	qstCompleteVO.setGubunNm(userNm);
                	qstCompleteVO.setGubunNm2(userNm2);
                	callCreateMother(qstCompleteVO, loginVO.getTenantId());
                	
                	String propList = "department;mail;displayName;title;description;company";
                	String pXML = ezOrganAdminService.getPropertyList(userID, propList, loginVO.getPrimary(), loginVO.getTenantId());

					Document infoXML = commonUtil.convertStringToDocument(pXML);
					String userDeptId = "";
					//String userGender = "";
					//String userAge = "";
					
					if(infoXML.getElementsByTagName("DEPARTMENT").item(0).getTextContent().equals("")) {
						userDeptId = "TOP";
					} else {
						userDeptId = infoXML.getElementsByTagName("DEPARTMENT").item(0).getTextContent();
					}
					String userEmail = infoXML.getElementsByTagName("MAIL").item(0).getTextContent();
					String userPos = infoXML.getElementsByTagName("TITLE1").item(0).getTextContent();
					String userPos2 = infoXML.getElementsByTagName("TITLE2").item(0).getTextContent();
					String userDeptNm = infoXML.getElementsByTagName("DESCRIPTION1").item(0).getTextContent();
					String userDeptNm2 = infoXML.getElementsByTagName("DESCRIPTION2").item(0).getTextContent();
					/*String userJumin = "1111111111111";*/
					
					/*if(userJumin.substring(7, 1).equals("1")) {
						userGender = "1";
					} else {
						userGender = "2";
					}
					userAge = userJumin.substring(0, 2);
					
					if(userAge.equals("11")) {
						userAge = "NULL";
					}*/
					
					QstCompleteVO qstCompleteVO3 = new QstCompleteVO();
					qstCompleteVO3.setStrBrdID(Integer.parseInt(pBrdID));
					qstCompleteVO3.setItemNo(Integer.parseInt(vItemID));
					qstCompleteVO3.setGubunID(userID);
					qstCompleteVO3.setGubunNm(userNm);
					qstCompleteVO3.setGubunNm2(userNm2);
					qstCompleteVO3.setUserEmail(userEmail);
					qstCompleteVO3.setUserDeptID(userDeptId);
					qstCompleteVO3.setUserDeptNm(userDeptNm);
					qstCompleteVO3.setUserDeptNm2(userDeptNm2);
					qstCompleteVO3.setUserPOS(userPos);
					qstCompleteVO3.setUserPOS2(userPos2);
					qstCompleteVO3.setUserGender("");
					qstCompleteVO3.setUserAge(0);
					callInsertPollResponseper(qstCompleteVO3, loginVO.getTenantId());
				}
			}
		}
		
		int qstCnt = doc.getElementsByTagName("QUESTION").item(0).getChildNodes().getLength();

		for(int i=0; i<qstCnt; i++) {
			XPath xpath = XPathFactory.newInstance().newXPath();
			
			String qstSubject = doc.getElementsByTagName("QUESTIONCONTENT").item(i).getTextContent();
			String answerType = doc.getElementsByTagName("ANSWERTYPE").item(i).getTextContent();
			String multiSelect = doc.getElementsByTagName("MULTISELECT").item(i).getTextContent();
			/*String selViewStart = doc.getElementsByTagName("SELVIEWSTART").item(i).getTextContent();
			String selViewEnd = doc.getElementsByTagName("SELVIEWEND").item(i).getTextContent();*/
			
			int v_quesNo = 1;
			
			v_quesNo = getQuestionNo(Integer.parseInt(pBrdID), Integer.parseInt(vItemID), loginVO.getTenantId());
			
			if(v_quesNo == 0) {
				v_quesNo = 1;
			} else {
				v_quesNo = v_quesNo + 1;
			}
			
			QstCompleteVO qstCompleteVO = new QstCompleteVO();
			qstCompleteVO.setStrBrdID(Integer.parseInt(pBrdID));
			qstCompleteVO.setItemNo(Integer.parseInt(vItemID));
			qstCompleteVO.setQuesNo(v_quesNo);
			qstCompleteVO.setQuesContent(qstSubject);
			qstCompleteVO.setAnswerType(Integer.parseInt(answerType));
			qstCompleteVO.setMultiSelect(multiSelect);
			
			insertQuestion(qstCompleteVO, loginVO.getTenantId());

			NodeList qstAttachNodes = (NodeList)xpath.evaluate("//QUESTION/ROW["+(i+1)+"]/ATTACH//ROW", doc, XPathConstants.NODESET);
			
			if (qstAttachNodes!= null && qstAttachNodes.getLength() > 0) {
				for (int k=0; k < qstAttachNodes.getLength() ; k++) {
					QstCompleteVO qstCompleteVO2 = new QstCompleteVO();
					qstCompleteVO2.setStrBrdID(Integer.parseInt(pBrdID));
					qstCompleteVO2.setItemNo(Integer.parseInt(vItemID));
					qstCompleteVO2.setQuesNo(v_quesNo);
					qstCompleteVO2.setAnswerNo(0);
					qstCompleteVO2.setAttachNo(k+1);
					qstCompleteVO2.setAttachType(qstAttachNodes.item(k).getChildNodes().item(0).getTextContent());
					qstCompleteVO2.setAttachName(qstAttachNodes.item(k).getChildNodes().item(1).getTextContent());
					qstCompleteVO2.setAttachURL(qstAttachNodes.item(k).getChildNodes().item(2).getTextContent());
					pollSaveAttach(qstCompleteVO2, loginVO.getTenantId());
				}
			}
			
			NodeList nodes1 = (NodeList)xpath.evaluate("//QUESTION/ROW["+(i+1)+"]/ANSWER_ANSWER", doc, XPathConstants.NODESET);
			if(nodes1.getLength() > 0) {
				int ansAnsCnt = nodes1.getLength();
				for(int iAnsAnsCnt=0; iAnsAnsCnt < ansAnsCnt; iAnsAnsCnt++ ) {
					qstCompleteVO.setStrBrdID(Integer.parseInt(pBrdID));
					qstCompleteVO.setItemNo(Integer.parseInt(vItemID));
					qstCompleteVO.setQuesNo(v_quesNo);
					qstCompleteVO.setAnswerNo(iAnsAnsCnt+1);
					qstCompleteVO.setAnswerAnswerContent(nodes1.item(iAnsAnsCnt).getChildNodes().item(0).getTextContent().replace("'", "''"));
					insertAnswerAnswerContent(qstCompleteVO, loginVO.getTenantId());
					
				}
			}
			
			NodeList nodes = (NodeList)xpath.evaluate("//QUESTION/ROW["+(i+1)+"]/ANSWER", doc, XPathConstants.NODESET);
			//NodeList nodes = (NodeList)xpath.evaluate("//QUESTION/ROW/ANSWER", doc, XPathConstants.NODESET);
				
			if(nodes.getLength() > 0) {
				int ansCnt = nodes.getLength();
				for(int iAns=0; iAns < ansCnt; iAns++ ) {
					qstCompleteVO.setStrBrdID(Integer.parseInt(pBrdID));
					qstCompleteVO.setItemNo(Integer.parseInt(vItemID));
					qstCompleteVO.setQuesNo(v_quesNo);
					qstCompleteVO.setAnswerNo(iAns+1);
					qstCompleteVO.setAnswerContent(nodes.item(iAns).getChildNodes().item(0).getTextContent().replace("'", "\'"));
					insertAnswerContent(qstCompleteVO, loginVO.getTenantId());
					
					NodeList nodes2 = (NodeList)xpath.evaluate("//QUESTION/ROW["+(i+1)+"]/ANSWER/ATTACH", doc, XPathConstants.NODESET);
					logger.debug("nodes2Length="+nodes2.getLength());
					if(nodes2.getLength() > 0) {
						nList = (NodeList)xpath.evaluate("//QUESTION/ROW["+(i+1)+"]/ANSWER", doc, XPathConstants.NODESET);
						//nList = doc.getElementsByTagName("ANSWER");	
						
						if(nList.item(iAns).getChildNodes().item(1) != null){
							if(nList.item(iAns).getChildNodes().item(1).getNodeName().equals("ATTACH")) {
								int ansAttachCnt = nList.item(iAns).getChildNodes().item(1).getChildNodes().getLength();
								
								logger.debug("ansAttachCnt="+ansAttachCnt);
								for(int aa=0; aa<ansAttachCnt; aa++) {
									String ansAttachType = nList.item(iAns).getChildNodes().item(1).getChildNodes().item(aa).getChildNodes().item(0).getTextContent();
									String ansAttachUrl = nList.item(iAns).getChildNodes().item(1).getChildNodes().item(aa).getChildNodes().item(2).getTextContent();
									if(ansAttachType.equals("3") || ansAttachType.equals("4") || ansAttachType.equals("6") || ansAttachType.equals("7")) {
									}
									QstCompleteVO qstCompleteVO2 = new QstCompleteVO();
									qstCompleteVO2.setStrBrdID(Integer.parseInt(pBrdID));
									qstCompleteVO2.setItemNo(Integer.parseInt(vItemID));
									qstCompleteVO2.setQuesNo(v_quesNo);
									qstCompleteVO2.setAnswerNo(iAns+1);
									qstCompleteVO2.setAttachNo(aa+1);
									//qstCompleteVO2.setAttachName(doc.getElementsByTagName("ATTACHTITLE").item(aa).getTextContent().replace("'", "''"));
									qstCompleteVO2.setAttachName(nList.item(iAns).getChildNodes().item(1).getChildNodes().item(aa).getChildNodes().item(1).getTextContent().replace("'", "''"));
									qstCompleteVO2.setAttachURL(ansAttachUrl);
									qstCompleteVO2.setAttachType(ansAttachType);
									pollSaveAttach(qstCompleteVO2, loginVO.getTenantId());
								}
							}
						}
					}
				}
			}
		}
		
		QstCompleteVO qstCompleteVO = new QstCompleteVO();
		qstCompleteVO.setStrBrdID(Integer.parseInt(pBrdID));
		qstCompleteVO.setItemNo(Integer.parseInt(vItemID));
		updatePollItem(qstCompleteVO, loginVO.getTenantId());
		logger.debug("SaveQuestion End");
		return "OK";
	}
	
	@Override
	public List<QstPollItemACLVO> getQstPollItemAcl(String itemID, int tenantID) throws Exception {
		logger.debug("getQstPollItemAcl started. itemID = " + itemID + " || tenantID = " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("itemID", itemID);
		map.put("tenantID", tenantID);
		
		List<QstPollItemACLVO> list = ezQuestionDAO.getQstPollItemAcl(map);
		
		logger.debug("getQstPollItemAcl ended. listSize = " + list.size());
		
		return list;
	}
}

