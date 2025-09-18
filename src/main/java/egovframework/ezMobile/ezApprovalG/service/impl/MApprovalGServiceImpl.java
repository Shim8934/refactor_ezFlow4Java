package egovframework.ezMobile.ezApprovalG.service.impl;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezApprovalG.dao.EzApprovalGDAO;
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGService;
import egovframework.ezEKP.ezApprovalG.vo.ApprGListHeaderVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGAprLineVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGFormVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGLeftVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGReceiptVO;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezEmail.util.EmailImportance;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezPersonal.service.EzPersonalService;
import egovframework.ezEKP.ezPersonal.type.NotiPlatform;
import egovframework.ezEKP.ezPersonal.type.NotiType;
import egovframework.ezMobile.ezApprovalG.dao.MApprovalGDAO;
import egovframework.ezMobile.ezApprovalG.service.MApprovalGService;
import egovframework.ezMobile.ezApprovalG.vo.*;
import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.ezMobile.ezOption.vo.MOptionVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.user.login.vo.LoginVO;
import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;

import org.apache.commons.compress.utils.IOUtils;
import org.apache.commons.io.FileUtils;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.interceptor.TransactionAspectSupport;

import javax.annotation.Resource;
import javax.mail.internet.InternetAddress;
import javax.servlet.http.HttpServletRequest;

import java.io.File;
import java.io.FileOutputStream;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.UnsupportedEncodingException;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.net.URLDecoder;
import java.util.*;
import org.w3c.dom.NodeList;

@Service("MApprovalGService")
public class MApprovalGServiceImpl extends EgovAbstractServiceImpl implements MApprovalGService {
	private static final Logger logger = LoggerFactory.getLogger(MApprovalGServiceImpl.class);
	
	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;

	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Resource(name = "MApprovalGDAO")
	private MApprovalGDAO mApprovalGDAO;
	
	@Resource(name = "EzApprovalGService")
	private EzApprovalGService ezApprovalGService;
	
	@Resource(name = "EzCommonService")
	private EzCommonService ezCommonService;
	
	@Resource(name = "EzOrganService")
	private EzOrganService ezOrganService;

	@Resource(name = "EzPersonalService")
	private EzPersonalService ezPersonalService;

	@Resource(name = "EzEmailService")
	private EzEmailService ezEmailService;

	@Resource(name = "EzApprovalGDAO")
	private EzApprovalGDAO ezApprovalGDAO;

	@Resource(name = "jspw")
	private String jspw;

	@Override
	public List<MApprovalGDocInfoVO> getDoApproveList(MCommonVO userInfo, String type, String searchText, String listSize, String lastDate) throws Exception {
		logger.debug("getDoApproveList started");

		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());
		String mainViewYN = ezCommonService.getTenantConfig("MineViewYN", userInfo.getTenantId());
		String userIDS = "'" + userInfo.getUserId() + "'";
		String proxyOption = ezApprovalGService.getIsUse("A23", "001", userInfo.getCompanyId(), userInfo.getLang(), userInfo.getTenantId());
		//2018-11-01 배현상, mobile 공유결재기능 추가
		String shareApprovalFlag = ezCommonService.getTenantConfig("useShareApproval", userInfo.getTenantId());
				
		if (proxyOption.equals("1")) {
			userIDS = ezApprovalGService.getProxyUser(userInfo.getUserId(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffSet());
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userIds", userIDS.replace(" ", "").replace("\'", "").split(","));
		map.put("tenantID", userInfo.getTenantId());
		map.put("companyID", userInfo.getCompanyId());
		map.put("offset", commonUtil.getMinuteUTC(userInfo.getOffSet()));
		map.put("searchText", searchText);
		map.put("listSize", Integer.parseInt(listSize));
		map.put("lastDate", lastDate);
		map.put("type", type);
		map.put("approvalFlag", approvalFlag);
		map.put("userId", userInfo.getUserId());
		map.put("lang", commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()));
		map.put("mainViewYN", mainViewYN);
		map.put("shareApprovalFlag", shareApprovalFlag);
		
		List<MApprovalGDocInfoVO> approvalGDocInfoVOs = mApprovalGDAO.getDoApproveList(map);

		logger.debug("getDoApproveList ended");
		
		return approvalGDocInfoVOs;
	}

	@Override
	public int getDoApproveListCount(MCommonVO userInfo, String type, String searchText) throws Exception {
		logger.debug("getDoApproveListCount started");

		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());
		String mainViewYN = ezCommonService.getTenantConfig("MineViewYN", userInfo.getTenantId());
		String userIDS = "'" + userInfo.getUserId() + "'";
		String proxyOption = ezApprovalGService.getIsUse("A23", "001", userInfo.getCompanyId(), userInfo.getLang(), userInfo.getTenantId());
		//2018-11-01 배현상, mobile 공유결재기능 추가
		String shareApprovalFlag = ezCommonService.getTenantConfig("useShareApproval", userInfo.getTenantId());
		
		if (proxyOption.equals("1")) {
			userIDS = ezApprovalGService.getProxyUser(userInfo.getUserId(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffSet());
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userIds", userIDS.replace(" ", "").replace("\'", "").split(","));
		map.put("tenantID", userInfo.getTenantId());
		map.put("companyID", userInfo.getCompanyId());
		map.put("searchText", searchText);
		map.put("userId", userInfo.getUserId());
		map.put("type", type);
		map.put("approvalFlag", approvalFlag);
		map.put("mainViewYN", mainViewYN);
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		map.put("shareApprovalFlag", shareApprovalFlag);

		int listCount = mApprovalGDAO.getDoApproveListCount(map);
		
		logger.debug("getDoApproveListCount ended");
		
		return listCount;
	}

	@Override
	public List<MApprovalGAprLineInfoVO> getAprLineInfo(String pDocID, String type, MCommonVO userInfo) throws Exception {
		logger.debug("getAprLineInfo started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("docID", pDocID);
		map.put("type", type);
		map.put("lang", commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()));
		map.put("offset", commonUtil.getMinuteUTC(userInfo.getOffSet()));
		map.put("tenantID", userInfo.getTenantId());
		map.put("companyID", userInfo.getCompanyId());
		
		List<MApprovalGAprLineInfoVO> approvalGAprLineInfoVOs = mApprovalGDAO.getAprLineInfo(map);

		logger.debug("getAprLineInfo ended");
		
		return approvalGAprLineInfoVOs;
	}

	@Override
	public String getMHTBody(String pDocID, String realPath, String domain, MCommonVO userInfo, Locale locale, String type, String scheme, String mode) throws Exception {
		logger.debug("getMHTBody started");

		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("docID", pDocID);
		map.put("type", type);
		map.put("mode", mode);
		map.put("approvalFlag", approvalFlag);
		map.put("tenantID", userInfo.getTenantId());
		map.put("companyID", userInfo.getCompanyId());
		
		String docHref = mApprovalGDAO.getAprDocHref(map);
		logger.debug("docHref : " + docHref);
		String uploadModule = commonUtil.getUploadPath("upload_common.MHTIMAGE", userInfo.getTenantId()) + commonUtil.separator;
		String filePath = realPath + uploadModule;
        
        File file = new File(filePath);
        if (!file.exists()) {
        	file.mkdirs();
        }
        
        String m_strMHT = "";
        
        try {
        	m_strMHT = ezCommonService.loadMHTFile(realPath + docHref);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			m_strMHT= "";
		}
        
        String strHTML = ezCommonService.startMHT2HTML(filePath, m_strMHT, filePath, realPath, locale, domain, scheme);
//        logger.debug("strHTML : " + strHTML);

		logger.debug("getMHTBody ended");
		
		return strHTML;
	}

	@Override
	public String getOpinionCount(String pDocID, String type, MCommonVO userInfo) throws Exception {
		logger.debug("getAprCommentCount started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("docID", pDocID);
		map.put("type", type);
		map.put("tenantID", userInfo.getTenantId());
		map.put("companyID", userInfo.getCompanyId());
		
		String commentCount = mApprovalGDAO.getAprCommentCount(map);

		logger.debug("getAprCommentCount ended");
		
		return commentCount;
	}

	@Override
	public List<MApprovalGOpinionInfoVO> getOpinionInfo(String pDocID, String type, MCommonVO userInfo) throws Exception {
		logger.debug("getOpinionInfo started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("docID", pDocID);
		map.put("type", type);
		map.put("lang", commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()));
		map.put("tenantID", userInfo.getTenantId());
		map.put("companyID", userInfo.getCompanyId());
		
		List<MApprovalGOpinionInfoVO> approvalGOpinionInfoVOs = mApprovalGDAO.getOpinionInfo(map);
		
		logger.debug("getOpinionInfo ended");
		
		return approvalGOpinionInfoVOs;
	}
	
	@Override
	public int mSetOpinionInfo(String pDocID, String pContent, String pOpinionGB, MCommonVO userInfo, String pType, String pAprMemberSN, String opinionSN) throws Exception {
		logger.debug("saveOpinionInfo started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("docID", pDocID);
		map.put("content", pContent);
		map.put("opinionGB", pOpinionGB);
		map.put("userID", userInfo.getUserId());
		map.put("tenantID", userInfo.getTenantId());
		map.put("companyID", userInfo.getCompanyId());
		// 2023-03-13 전인하 - 전자결재 > 모바일 의견 기능 개선 - 의견 동작 시 추가 파라미터(의견순번) 삽입, 의견 동작 로직 개선
		map.put("opinionSN", opinionSN);
		map.put("aprMemberSN", pAprMemberSN); // 2023-04-28 이가은 - 의견 추가할 경우 실제 결재선상의 부서명, 직위로 표출하기 위해 추가

		int isAbsentee = mApprovalGDAO.getIsAbsenteeInfo(map);

		if (isAbsentee > 0) {
			map.put("isAbsentee","Y");
		} else {
			map.put("isAbsentee","N");
		}
		
		int result = 0;
        // int resultRow = mApprovalGDAO.deleteOpinionInfo(map); // 기존 의견 전체삭제 동작 주석
		
		if (pType.equals("INSERT")) {
			if (pContent != null && !pContent.equals("")) {
				map.put("hasOpinionYN", "Y");
				mApprovalGDAO.insertOpinionInfo(map);
				result = mApprovalGDAO.updateDocOpinionInfo(map);
			}
		} else if (pType.equals("UPDATE")) {
			if (pContent != null && !pContent.equals("")) {
				result = mApprovalGDAO.updateOpinionInfo(map);
			}
		} else if (pType.equals("DELETE")) {
			result = mApprovalGDAO.deleteOpinionInfo(map);
			int opinionCount = mApprovalGDAO.getOpinionCountInfo(map);

			if (opinionCount == 0) { // 의견을 지우고 남은 의견 수가 0일때, hasOpinionYN 컬럼에 N 삽입
				map.put("hasOpinionYN", "N");
				mApprovalGDAO.updateDocOpinionInfo(map);
			}
		}

		logger.debug("saveOpinionInfo ended");
		
		return result;
	}

	@Override
	public List<MApprovalGAttachInfoVO> getAttachList(String docId, String type, MCommonVO userInfo) throws Exception {
		logger.debug("getAttachList started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("docID", docId);
		map.put("type", type);
		map.put("tenantID", userInfo.getTenantId());
		map.put("companyID", userInfo.getCompanyId());
		
		List<MApprovalGAttachInfoVO> approvalGAttachInfoVOs = mApprovalGDAO.getAttachList(map);

		logger.debug("getAttachList ended");
		
		return approvalGAttachInfoVOs;
	}
	
	@Override
	public MApprovalGAbsenteeInfoVO getAbsenteeInfo(MCommonVO userInfo) throws Exception {
		logger.debug("getAbsenteeInfo started");

		String absenteeInfo = mApprovalGDAO.getAbsenteeInfo(userInfo);
		
		MApprovalGAbsenteeInfoVO absenteeInfoVO = new MApprovalGAbsenteeInfoVO();
		
		if (absenteeInfo != null && !absenteeInfo.equals("")) {
			String[] absenteeInfoArry = absenteeInfo.split(":");
			
			absenteeInfoVO.setAbsenteeId(absenteeInfoArry[0]);
			absenteeInfoVO.setAbsenteeName(absenteeInfoArry[1]);
			absenteeInfoVO.setAbsenteeDeptId(absenteeInfoArry[2]);
			absenteeInfoVO.setStartDate(absenteeInfoArry[3] + ":" + absenteeInfoArry[4]);
			absenteeInfoVO.setEndDate(absenteeInfoArry[5] + ":" + absenteeInfoArry[6]);
		}

		logger.debug("getAbsenteeInfo ended");
		
		return absenteeInfoVO;
	}

	@Override
	public int setAbsenteeInfo(MApprovalGAbsenteeInfoVO absenteeInfoVO) throws Exception {
		logger.debug("setAbsenteeInfo started");

		int result = mApprovalGDAO.setAbsenteeInfo(absenteeInfoVO);

		logger.debug("setAbsenteeInfo ended");
		
		return result;
	}

	@Override
	public int checkPass(MCommonVO userInfo, String shaEncPassword) throws Exception {
		logger.debug("checkPass started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("password", shaEncPassword);
		map.put("userID", userInfo.getUserId());
		map.put("tenantID", userInfo.getTenantId());
		
		int resultCode = mApprovalGDAO.checkPass(map);

		logger.debug("checkPass ended");
		
		return resultCode;
	}

	@Override
	public MApprovalGDocInfoVO getAprDocInfo(String docId, String type, String lang, String offset, String companyId, int tenantId, String aprMemberSN, String mode) throws Exception {
		logger.debug("getAprDocInfo started");

		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", tenantId);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("docID", docId);
		map.put("type", type);
		map.put("mode", mode);
		map.put("aprMemberSN", aprMemberSN);
		map.put("approvalFlag", approvalFlag);
		map.put("lang", commonUtil.getMultiData(lang, tenantId));
		map.put("tenantID", tenantId);
		map.put("companyID", companyId);
		map.put("offset", commonUtil.getMinuteUTC(offset));
		
		MApprovalGDocInfoVO approvalGDocInfoVO = new MApprovalGDocInfoVO();
		
		approvalGDocInfoVO = mApprovalGDAO.getAprDocInfo(map);

		logger.debug("getAprDocInfo ended");
		
		return approvalGDocInfoVO;
	}
	
	@Override
	public MApprovalGDocInfoVO getAprMemberSn(String docId, String type, MCommonVO userInfo) throws Exception {
		logger.debug("getAprDocInfo started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("docID", docId);
		map.put("type", type);
		map.put("tenantID", userInfo.getTenantId());
		map.put("companyID", userInfo.getCompanyId());
		map.put("userID", userInfo.getUserId());
		
		MApprovalGDocInfoVO approvalGDocInfoVO = new MApprovalGDocInfoVO();
		
		approvalGDocInfoVO = mApprovalGDAO.getAprMemberSn(map);

		logger.debug("getAprDocInfo ended");
		
		return approvalGDocInfoVO;
	}

	@Override
	public String getDocState(String docId, String companyId, int tenantId) throws Exception {
		logger.debug("getDocState started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("docID", docId);
		map.put("tenantID", tenantId);
		map.put("companyID", companyId);
		
		String docState = mApprovalGDAO.getDocState(map);

		logger.debug("getDocState ended");
		
		return docState;
	}

	@Override
	public MApprovalGLeftVO getLeftCount(String userId, MCommonVO userInfo) throws Exception {
		logger.debug("getLeftCount started");
		
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());
		String mainViewYN = ezCommonService.getTenantConfig("MineViewYN", userInfo.getTenantId());
		String userIDS = "'" + userInfo.getUserId() + "'";
		String proxyOption = ezApprovalGService.getIsUse("A23", "001", userInfo.getCompanyId(), userInfo.getLang(), userInfo.getTenantId());
		//2018-11-01 배현상, mobile 공유결재기능 추가
		String useShareApproval = ezCommonService.getTenantConfig("useShareApproval", userInfo.getTenantId());
		
		if (proxyOption.equals("1")) {
			userIDS = ezApprovalGService.getProxyUser(userInfo.getUserId(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffSet());
		}

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userIds", userIDS.replace(" ", "").replace("\'", "").split(","));
		map.put("userId", userId);
		map.put("tenantID", userInfo.getTenantId());
		map.put("companyID", userInfo.getCompanyId());
		map.put("approvalFlag", approvalFlag);
		map.put("mainViewYN", mainViewYN);
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		map.put("useShareApproval", useShareApproval);
		
		MApprovalGLeftVO approvalGLeftVO = mApprovalGDAO.getLeftCount(map);

		logger.debug("getLeftCount ended");
		
		return approvalGLeftVO;
	}

	@Override
	public int delAbsenteeInfo(String userId, int tenantId) throws Exception {
		logger.debug("delAbsenteeInfo started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("tenantID", tenantId);
		
		int result = mApprovalGDAO.delAbsenteeInfo(map);

		logger.debug("delAbsenteeInfo ended");
		
		return result;
	}

	@Override
	public int getCheckAprState(String docId, String userId,
			String aprMemberSN, String mode, String companyId, int tenantId)
			throws Exception {
		logger.debug("getCheckAprState started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("docId", docId);
		map.put("userId", userId);
		map.put("aprMemberSN", aprMemberSN);
		map.put("mode", mode);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		int result = mApprovalGDAO.getCheckAprState(map);
		
		logger.debug("getCheckAprState ended.");
		
		return result;
	}
	
	/**
	 * 결재동작 이후의 알림메일발송
	 * @param userInfo
	 * @param optionInfo
	 * @param approvalGDocInfoVO
	 * @param docId
	 * @param type
	 * @throws Exception
	 */
	@Override
	public void sendApproveNoticeMail(MCommonVO userInfo, MOptionVO optionInfo, MApprovalGDocInfoVO approvalGDocInfoVO, String docId, String type) throws Exception {
		logger.debug("sendApproveNoticeMail started.");

		String subject = null;
		StringBuilder contentBuilder = null;
		StringBuilder contentBuilderCham = null;

		String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
		String https = "YES".equals(ezCommonService.getTenantConfig("USE_HTTPS", userInfo.getTenantId())) ? "HTTPS://" : "HTTP://";
		String serverName = ezCommonService.getTenantConfig("serverName", userInfo.getTenantId());
		String userEmail = userInfo.getUserId() + "@" + domainName;
		String password = jspw;

		//to User
		String targetUserId = null;
		String targetUserName = null;
		List<InternetAddress> toList = new ArrayList<>();
		List<InternetAddress> toListCham = new ArrayList<>();
		Locale locale = new Locale(commonUtil.getTwoLetterLangFromLangNum(userInfo.getLang()));

		//from User
		String userId = userInfo.getUserId();
		String userName = userInfo.getUserName();
		String lang = userInfo.getLang();
		String companyId = userInfo.getCompanyId();
		int tenantId = userInfo.getTenantId();

		logger.debug("docId = " + docId + ", type = " + type + ", userId = " + userId);

		InternetAddress from = new InternetAddress();
		from.setAddress(userInfo.getEmail());
		from.setPersonal(userName, "UTF-8");

		InternetAddress to;

		List<MApprovalGAprLineInfoVO> approvalGAprLineInfoVOs = getAprLineInfo(docId, type, userInfo);

		//"BO", "CHECK" 필요시 추가
		switch (type) {
			case "APR":
				if (approvalGAprLineInfoVOs.isEmpty()) { //end
					//[수신문서결재완료알림]
					if ("011".equalsIgnoreCase(approvalGDocInfoVO.getDocState())) {
						approvalGAprLineInfoVOs = getAprLineInfo(approvalGDocInfoVO.getOrgDocID(), "END", userInfo);

						MApprovalGAprLineInfoVO targetVo = approvalGAprLineInfoVOs.get(approvalGAprLineInfoVOs.size() - 1);
						targetUserId = targetVo.getAprMemberId();

						if (ezPersonalService.hasNotiDiableItem(targetUserId, NotiType.APPROVAL_COMPLETE, NotiPlatform.MAIL, tenantId)) {
							break;
						}

						targetUserName = targetVo.getAprMemberName();
						logger.debug("END REC : targetUserId = " + targetUserId + ", targetUserName = " + targetUserName);

						to = new InternetAddress();
						to.setAddress(ezOrganService.getPropertyValue(targetUserId, "mail", tenantId));
						to.setPersonal(targetUserName, "UTF-8");

						toList.add(to);

						subject = egovMessageSource.getMessage("ezEmail.csj07", locale) + " " + approvalGDocInfoVO.getDocTitle(); //[수신부서결재완료알림] + DOCTITLE
						contentBuilder = new StringBuilder("<table width='750' cellpadding='0' cellspacing='0' border='0' ><tr align='left'><td>");
						contentBuilder.append("<span style='font-size:13px;'>" + egovMessageSource.getMessage("ezEmail.csj17", locale) + ": " + approvalGDocInfoVO.getDocTitle() + "</span><br>");
						contentBuilder.append("<span style='font-size:13px;'>" + egovMessageSource.getMessage("ezEmail.csj18", locale) + ": " + approvalGDocInfoVO.getWriterName() + "</span><br>");
						contentBuilder.append("<span style='font-size:13px;'>" + egovMessageSource.getMessage("ezEmail.csj19", locale) + ": " + approvalGDocInfoVO.getStartDate() + "</span><br>");
						contentBuilder.append("</td></tr></table>");

						ezEmailService.sendMail(userEmail, password, locale, from, toList.toArray(new InternetAddress[toList.size()]), null, null, subject, commonUtil.createNotiMailContent(contentBuilder.toString(), tenantId, locale), false, EmailImportance.NORMAL);
					} else {
						approvalGAprLineInfoVOs = getAprLineInfo(docId, "END", userInfo);

						MApprovalGAprLineInfoVO targetVo = approvalGAprLineInfoVOs.get(approvalGAprLineInfoVOs.size() - 1);
						targetUserId = targetVo.getAprMemberId();

						if (ezPersonalService.hasNotiDiableItem(targetUserId, NotiType.APPROVAL_COMPLETE, NotiPlatform.MAIL, tenantId)) {
							break;
						}

						targetUserName = targetVo.getAprMemberName();
						logger.debug("END : targetUserId = " + targetUserId + ", targetUserName = " + targetUserName);

						to = new InternetAddress();
						to.setAddress(ezOrganService.getPropertyValue(targetUserId, "mail", tenantId));
						to.setPersonal(targetUserName, "UTF-8");

						toList.add(to);

						subject = egovMessageSource.getMessage("ezEmail.csj06", locale) + " " + approvalGDocInfoVO.getDocTitle(); //[결재완료알림] + DOCTITLE
						contentBuilder = new StringBuilder("<table width='750' cellpadding='0' cellspacing='0' border='0' ><tr align='left'><td>");
						contentBuilder.append("<span style='font-size:13px;'>" + egovMessageSource.getMessage("ezEmail.csj17", locale) + ": " + approvalGDocInfoVO.getDocTitle() + "</span><br>");
						contentBuilder.append("<span style='font-size:13px;'>" + egovMessageSource.getMessage("ezEmail.csj18", locale) + ": " + approvalGDocInfoVO.getWriterName() + "</span><br>");
						contentBuilder.append("<span style='font-size:13px;'>" + egovMessageSource.getMessage("ezEmail.csj19", locale) + ": " + approvalGDocInfoVO.getStartDate() + "</span><br>");
						contentBuilder.append("</td></tr></table>");
						ezEmailService.sendMail(userEmail, password, locale, from, toList.toArray(new InternetAddress[toList.size()]), null, null, subject, commonUtil.createNotiMailContent(contentBuilder.toString(), tenantId, locale), false, EmailImportance.NORMAL);
					}

					/* 수신문서도착알림메일이 두번 발송되는현상 수정
					//[수신문서도착알림]
					List<MApprovalGReceiptInfoVO> receiptInfos = getEndReceiptInfos(docId, companyId, tenantId);

					if (!receiptInfos.isEmpty()) {
						toList = new ArrayList<>();

						subject = egovMessageSource.getMessage("ezEmail.csj02", locale) + " " + approvalGDocInfoVO.getDocTitle(); //[수신문서도착알림] + DOCTITLE
						contentBuilder = new StringBuilder("<table width='750' cellpadding='0' cellspacing='0' border='0' ><tr align='left'><td>");
						contentBuilder.append("<span style='font-size:13px;'>" + egovMessageSource.getMessage("ezEmail.csj17", locale) + ": " + approvalGDocInfoVO.getDocTitle() + "</span><br>");
						contentBuilder.append("<span style='font-size:13px;'>" + egovMessageSource.getMessage("ezEmail.csj18", locale) + ": " + approvalGDocInfoVO.getWriterName() + "</span><br>");
						contentBuilder.append("<span style='font-size:13px;'>" + egovMessageSource.getMessage("ezEmail.csj19", locale) + ": " + approvalGDocInfoVO.getStartDate() + "</span><br>");
						contentBuilder.append("</td></tr></table>");

						//add user of dept
						List<String> deptIds = receiptInfos.stream()
								.filter(vo -> vo.getUserId().equalsIgnoreCase(""))
								.map(MApprovalGReceiptInfoVO::getDeptId)
								.collect(Collectors.toList());

						for (String deptId : deptIds) {
							Map<String, Object> map = new HashMap<>();
							map.put("tenantId", tenantId);
							map.put("deptId", deptId);

							List<MCommonVO> userInfos = mApprovalGDAO.getReceiptInfosOfDept(map);

							for (MCommonVO info : userInfos) {
								logger.debug("REC dept : targetUserId = " + info.getUserId() + ", targetUserName = " + info.getUserName());

								to = new InternetAddress();

								to.setAddress(info.getEmail());
								to.setPersonal(info.getUserName(), "UTF-8");

								toList.add(to);
							}
						}

						//add user
						List<String> userIds = receiptInfos.stream()
								.filter(vo -> !vo.getUserId().equalsIgnoreCase(""))
								.map(MApprovalGReceiptInfoVO::getUserId)
								.collect(Collectors.toList());

						for (String recUserId : userIds) {
							Map<String, Object> map = new HashMap<>();
							map.put("tenantId", tenantId);
							map.put("userId", recUserId);

							List<MCommonVO> userInfos = mApprovalGDAO.getReceiptInfosOfUser(map);

							for (MCommonVO info : userInfos) {
								logger.debug("REC user : targetUserId = " + info.getUserName() + ", targetUserName = " + info.getUserName());

								to = new InternetAddress();

								to.setAddress(info.getEmail());
								to.setPersonal(info.getUserName(), "UTF-8");

								toList.add(to);
							}
						}

						toList = toList.stream().distinct().collect(Collectors.toList());

						ezEmailService.sendMail(userEmail, password, locale, from, toList.toArray(new InternetAddress[toList.size()]), null, null, subject, commonUtil.createNotiMailContent(contentBuilder.toString(), tenantId, locale), saveSendBoxFlag, EmailImportance.NORMAL);
					}*/
				} else { //apr
					for (MApprovalGAprLineInfoVO vo : approvalGAprLineInfoVOs) {
						targetUserId = vo.getAprMemberId();

						// 결재유형이 참조인 경우에만 메일을 보내는 오류 분기 수정 (!"007".equalsIgnoreCase(vo.getAprType()) OR조건에서 제거)
						if (!"002".equals(vo.getAprState())
								|| ezPersonalService.hasNotiDiableItem(targetUserId, NotiType.APPROVAL_ARRIVE, NotiPlatform.MAIL, tenantId)) {
							continue;
						}

						targetUserName = vo.getAprMemberName();
						logger.debug("APR NEXT : targetUserId = " + targetUserId + ", targetUserName = " + targetUserName + ", aprState = " + vo.getAprState() + ", aprType = " + vo.getAprType());

						to = new InternetAddress();
						to.setAddress(ezOrganService.getPropertyValue(targetUserId, "mail", tenantId));
						to.setPersonal(targetUserName, "UTF-8");

						/* 2021-08-18 홍승비 - 참조자와 결재자용 메일 수신자 리스트를 분리 (동일한 수신자 리스트에 계속 수신자를 추가하면 결재자도 참조메일을 받게 됨) */
						if (!"007".equals(vo.getAprType())) {
							toList.add(to);
						} else {
							toListCham.add(to);
						}

						/* 2021-01-12 홍승비 - 모바일에서 결재 시 참조와 일반 결재 메일 분기 추가 */
						subject = egovMessageSource.getMessage("ezEmail.csj12", locale) + " " + approvalGDocInfoVO.getDocTitle(); // [결재문서도착알림]
						contentBuilder = new StringBuilder("<table width='750' cellpadding='0' cellspacing='0' border='0' ><tr align='left'><td>");
						contentBuilderCham = new StringBuilder("<table width='750' cellpadding='0' cellspacing='0' border='0' ><tr align='left'><td>");
						
						if (!"007".equalsIgnoreCase(vo.getAprType())) { // 참조가 아닌 경우에만 결재링크 생성 (웹과 동일)
							contentBuilder.append("<span style='font-size:13px; font-weight:bold;'>" + approvalGDocInfoVO.getWriterName() + "</span>");
							contentBuilder.append("<span style='font-size:13px;'>" + egovMessageSource.getMessage("ezEmail.csj14", locale) + "</span>");
							contentBuilder.append("<a id='approv_a' href ='" + https + serverName + "/ezApprovalG/approvui.do?");
							contentBuilder.append("docID=" + approvalGDocInfoVO.getDocID());
							contentBuilder.append("&id=" + targetUserId + "&name=" + targetUserName + "&deptID=" + ezOrganService.getPropertyValue(targetUserId, "department", tenantId));
							contentBuilder.append("&allFlag=0&mailchk=Y&mode=APR&orgCompanyID=" + ezOrganService.getPropertyValue(targetUserId, "physicaldeliveryofficename", tenantId));
							contentBuilder.append("' data-id='" + approvalGDocInfoVO.getDocID() + "'"+ "data-comp='" + ezOrganService.getPropertyValue(targetUserId, "physicaldeliveryofficename", tenantId));
							contentBuilder.append("' onclick ='javascript:mail_link();' style='cursor: pointer; font-size: 13px; color: blue;' target='_blank'><br>");
							contentBuilder.append(egovMessageSource.getMessage("ezEmail.csj15", locale)); //결재 문서 바로가기 링크
							contentBuilder.append("</a><br><br>");
							contentBuilder.append("<span style='font-size:13px; font-weight:bold;'>" + egovMessageSource.getMessage("ezEmail.csj16", locale) + "</span><br>");
							contentBuilder.append("<span style='font-size:13px;'>" + egovMessageSource.getMessage("ezEmail.csj17", locale) + ": " + approvalGDocInfoVO.getDocTitle() + "</span><br>");
							contentBuilder.append("<span style='font-size:13px;'>" + egovMessageSource.getMessage("ezEmail.csj18", locale) + ": " + approvalGDocInfoVO.getWriterName() + "</span><br>");
							contentBuilder.append("<span style='font-size:13px;'>" + egovMessageSource.getMessage("ezEmail.csj19", locale) + ": " + approvalGDocInfoVO.getStartDate() + "</span><br>");
							contentBuilder.append("</td></tr></table>");
						} else {
							contentBuilderCham.append("<span style='font-size:13px;'>" + egovMessageSource.getMessage("ezEmail.csj17", locale) + ": " + approvalGDocInfoVO.getDocTitle() + "</span><br>");
							contentBuilderCham.append("<span style='font-size:13px;'>" + egovMessageSource.getMessage("ezEmail.csj18", locale) + ": " + approvalGDocInfoVO.getWriterName() + "</span><br>");
							contentBuilderCham.append("<span style='font-size:13px;'>" + egovMessageSource.getMessage("ezEmail.csj19", locale) + ": " + approvalGDocInfoVO.getStartDate() + "</span><br>");
							contentBuilderCham.append("</td></tr></table>");
						}
						
						// 2023-05-17 이사라 : NullPointerException 시큐어코딩
						String contentBuilderValue = !Objects.isNull(contentBuilder) ? contentBuilder.toString() : "";

						// 참조자가 아닌 경우, 개별로 결재에 관련된 속성(targetUserId, targetUserName 등)을 부여한 결재알림메일을 루프 내부에서 발송한다.
						if (toList.size() > 0) {
							ezEmailService.sendMail(userEmail, password, locale, from, toList.toArray(new InternetAddress[toList.size()]), null, null, subject, commonUtil.createNotiMailContent(contentBuilderValue, tenantId, locale), false, EmailImportance.NORMAL);
							toList.clear(); // 결재자에게 메일 발송 후 리스트 초기화 -> 다음 루프에서 참조자가 아닌 결재자가 존재한다면 다시 메일 발송하도록 add() 후 초기화를 반복함
						}
					}

					String contentBuilderChamValue = !Objects.isNull(contentBuilderCham) ? contentBuilderCham.toString() : "";

					// 참조자인 경우, 메일 내부에 결재 관련 속성이 없으므로 한꺼번에 참조메일을 발송한다.
					if (toListCham.size() > 0) {
						ezEmailService.sendMail(userEmail, password, locale, from, toListCham.toArray(new InternetAddress[toListCham.size()]), null, null, subject, commonUtil.createNotiMailContent(contentBuilderChamValue, tenantId, locale), false, EmailImportance.NORMAL);
					}
				}

				break;

			case "BAN" :
				MApprovalGAprLineInfoVO targetVo = approvalGAprLineInfoVOs.get(approvalGAprLineInfoVOs.size() - 1);
				targetUserId = targetVo.getAprMemberId();

				if (ezPersonalService.hasNotiDiableItem(targetUserId, NotiType.APPROVAL_REJECT, NotiPlatform.MAIL, tenantId)) {
					break;
				}

				targetUserName = targetVo.getAprMemberName();
				logger.debug("BAN : targetUserId = " + targetUserId + ", targetUserName = " + targetUserName);

				to = new InternetAddress();

				to.setAddress(ezOrganService.getPropertyValue(targetUserId, "mail", tenantId));
				to.setPersonal(targetUserName, "UTF-8");

				toList.add(to);

				subject = egovMessageSource.getMessage("ezEmail.csj04", locale) + " " + approvalGDocInfoVO.getDocTitle(); //[기안문서 반송알림]
				contentBuilder = new StringBuilder("<table width='750' cellpadding='0' cellspacing='0' border='0' ><tr align='left'><td>");
				contentBuilder.append("<span style='font-size:13px;'>" + egovMessageSource.getMessage("ezEmail.csj17", locale) + ": " + approvalGDocInfoVO.getDocTitle() + "</span><br>");
				contentBuilder.append("<span style='font-size:13px;'>" + egovMessageSource.getMessage("ezEmail.csj18", locale) + ": " + approvalGDocInfoVO.getWriterName() + "</span><br>");
				contentBuilder.append("<span style='font-size:13px;'>" + egovMessageSource.getMessage("ezEmail.csj19", locale) + ": " + approvalGDocInfoVO.getStartDate() + "</span><br>");

				Map<String, Object> map = new HashMap<String, Object>();
				map.put("docID", docId);
				map.put("lang", commonUtil.getMultiData(lang, tenantId));
				map.put("tenantID", tenantId);
				map.put("companyID", companyId);

				List<MApprovalGOpinionInfoVO> opinionInfos = mApprovalGDAO.getOpinionInfo(map);

				if (!opinionInfos.isEmpty()) {
					map.put("v_LISTTYPE", "031");
					map.put("v_LANGTYPE", lang);
					map.put("companyID", companyId);
					map.put("v_TENANTID", tenantId);

					List<ApprGListHeaderVO> headers = ezApprovalGDAO.getListHeader(map);

					//table header
					contentBuilder.append("<table width='750' cellpadding='0' cellspacing='0'><tr align='center' height='30' style='background:#F9F8F8'>");
					contentBuilder.append("<td style='BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-RIGHT: black 1px solid;padding-left:10px;padding-right:10px'><b>No.</b></td>");
					contentBuilder.append("<td style='BORDER-BOTTOM: black 1px solid; BORDER-TOP: black 1px solid; BORDER-RIGHT: black 1px solid;padding-left:10px;padding-right:10px'><b>" + headers.get(1).getName() + "</b></td>");
					contentBuilder.append("<td style='BORDER-BOTTOM: black 1px solid; BORDER-TOP: black 1px solid; BORDER-RIGHT: black 1px solid;padding-left:10px;padding-right:10px'><b>" + headers.get(4).getName() + "</b></td>");
					contentBuilder.append("<td style='BORDER-BOTTOM: black 1px solid; BORDER-TOP: black 1px solid; BORDER-RIGHT: black 1px solid;padding-left:10px;padding-right:10px'><b>" + headers.get(0).getName() + "</b></td>");
					contentBuilder.append("<td style='BORDER-BOTTOM: black 1px solid; BORDER-TOP: black 1px solid; BORDER-RIGHT: black 1px solid;padding-left:10px;padding-right:10px'><b>" + headers.get(2).getName() + "</b></td>");
					contentBuilder.append("</tr>");

					for(MApprovalGOpinionInfoVO opinionInfo : opinionInfos) {
						contentBuilder.append("<tr align='center' bgcolor='#FFFFFF' height='20'>");
						contentBuilder.append("<td style='BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-RIGHT: black 1px solid;padding-left:10px;padding-right:10px'>" + (opinionInfos.indexOf(opinionInfo) + 1)  + "</td>");
						contentBuilder.append("<td style='BORDER-BOTTOM: black 1px solid; BORDER-RIGHT: black 1px solid;padding-left:10px;padding-right:10px'>" + opinionInfo.getUserName() + "</td>");
						contentBuilder.append("<td style='BORDER-BOTTOM: black 1px solid; BORDER-RIGHT: black 1px solid;padding-left:10px;padding-right:10px'>" + opinionInfo.getUserDeptName()  + "</td>");
						contentBuilder.append("<td style='BORDER-BOTTOM: black 1px solid; BORDER-RIGHT: black 1px solid;padding-left:10px;padding-right:10px'>");
						switch (opinionInfo.getOpinionGB()) {
							case "001" :
								contentBuilder.append(egovMessageSource.getMessage("ezApprovalG.lhj21", locale));
								break;
							case "002" :
								contentBuilder.append(egovMessageSource.getMessage("ezApprovalG.lhj22", locale));
								break;
							case "003" :
								contentBuilder.append(egovMessageSource.getMessage("ezApprovalG.lhj23", locale));
								break;
							case "004" :
								contentBuilder.append(egovMessageSource.getMessage("ezApprovalG.lhj24", locale));
								break;
						}

						contentBuilder.append("</td>");
						contentBuilder.append("<td style='BORDER-BOTTOM: black 1px solid;  BORDER-RIGHT: black 1px solid;padding-left:10px;padding-right:10px' align='left'>" + commonUtil.cleanValue(opinionInfo.getContent()) + "</td>");
						contentBuilder.append("</tr>");
					}

					contentBuilder.append("</table>");
				}

				contentBuilder.append("</td></tr></table>");
				ezEmailService.sendMail(userEmail, password, locale, from, toList.toArray(new InternetAddress[toList.size()]), null, null, subject, commonUtil.createNotiMailContent(contentBuilder.toString(), tenantId, locale), false, EmailImportance.NORMAL);

				break;

			case "HWE" :
				for (MApprovalGAprLineInfoVO vo : approvalGAprLineInfoVOs) {
					targetUserId = vo.getAprMemberId();
					
					// 회수알림 발송 대상자에서 기안자(회수자)를 제외하고, 현재 결재진행/승인상태가 아닌 경우도 제외함
					if ((!"002".equals(vo.getAprState()) && !"003".equals(vo.getAprState()))
							|| approvalGAprLineInfoVOs.indexOf(vo) == approvalGAprLineInfoVOs.size() - 1
							|| ezPersonalService.hasNotiDiableItem(targetUserId, NotiType.APPROVAL_RETURN, NotiPlatform.MAIL, tenantId)) {
						continue;
					}

					targetUserName = vo.getAprMemberName();
					logger.debug("HWE : targetUserId = " + targetUserId + ", targetUserName = " + targetUserName + ", aprState = " + vo.getAprState() + ", aprType = " + vo.getAprType());

					to = new InternetAddress();

					to.setAddress(ezOrganService.getPropertyValue(targetUserId, "mail", tenantId));
					to.setPersonal(targetUserName, "UTF-8");

					toList.add(to);

					subject = egovMessageSource.getMessage("ezEmail.csj01", locale) + " " + approvalGDocInfoVO.getDocTitle(); //[결재문서회수알림]
					contentBuilder = new StringBuilder("<table width='750' cellpadding='0' cellspacing='0' border='0' ><tr align='left'><td>");
					contentBuilder.append("<span style='font-size:13px;'>" + egovMessageSource.getMessage("ezEmail.csj17", locale) + ": " + approvalGDocInfoVO.getDocTitle() + "</span><br>");
					contentBuilder.append("<span style='font-size:13px;'>" + egovMessageSource.getMessage("ezEmail.csj18", locale) + ": " + approvalGDocInfoVO.getWriterName() + "</span><br>");
					contentBuilder.append("<span style='font-size:13px;'>" + egovMessageSource.getMessage("ezEmail.csj19", locale) + ": " + approvalGDocInfoVO.getStartDate() + "</span><br>");
					contentBuilder.append("</td></tr></table>");
				}
				
				/* 2023-02-15 홍승비 - 모바일에서 회수 시, 회수알림메일의 대상자가 존재하는 경우에만 메일을 발송하도록 수정 */
				if (toList.size() > 0) {
					ezEmailService.sendMail(userEmail, password, locale, from, toList.toArray(new InternetAddress[toList.size()]), null, null, subject, commonUtil.createNotiMailContent(contentBuilder.toString(), tenantId, locale), false, EmailImportance.NORMAL);
				}
				
				break;

			default:
				break;
		}

		logger.debug("sendApproveNoticeMail ended.");
	}

	public List<MApprovalGReceiptInfoVO> getEndReceiptInfos(String docId, String companyId, int tenantId) throws Exception {
		logger.debug("getEndReceiptInfos started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("docId", docId);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);

		List<MApprovalGReceiptInfoVO> receiptInfos = mApprovalGDAO.getEndReceiptInfos(map);

		logger.debug("getEndReceiptInfos ended");

		return receiptInfos;
	}
	
	/* 2020-07-02 홍승비 - 모바일에서 최종결재 완료 시 서명에 결재날짜 삽입 동작 추가(결재날짜 필드가 없는 경우에만, 웹과 동일하게) */
	public String insertSeumyungdateMobile(String docId, String realPath, String offset, Locale locale, String domain, String scheme, String companyId, int tenantId) throws Exception {
		logger.debug("insertSeumyungdateMobile started");

		String result = "SUCCESS";
		try {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("v_DOCID", docId);
			map.put("v_COMPANYID", companyId);
			map.put("v_TENANTID", tenantId);
			
			MApprovalGDocInfoVO endDocInfo = mApprovalGDAO.getEndAprDocInfo(map);
			
			// 최종결재가 완료된 경우, 완료문서의 경로를 찾아서 서명을 업데이트한다.
			if (endDocInfo != null && endDocInfo.getHref() != null) {
				String docHref = endDocInfo.getHref();
				logger.debug("docHref in insertSeumyungdateMobile : " + docHref);
				
				String uploadModule = commonUtil.getUploadPath("upload_common.MHTIMAGE", tenantId) + commonUtil.separator;
				String filePath = realPath + uploadModule;
		        
		        File file = new File(filePath);
		        if (!file.exists()) {
		        	file.mkdirs();
		        }
		        
		        String m_strMHT = "";
		        
		        try {
		        	m_strMHT = ezCommonService.loadMHTFile(realPath + docHref);
				} catch (Exception e) {
					logger.error(e.getMessage(), e);
					m_strMHT= "";
				}
		        
		        String strHTML = ezCommonService.startMHT2HTML(filePath, m_strMHT, filePath, realPath, locale, domain, scheme);
		        org.jsoup.nodes.Document doc = Jsoup.parse(strHTML); // 셀렉터를 사용하기 위한 파싱
				
		        /* 2020-07-21 홍승비 - 내부결재, 수신결재 분기 추가 */
		        Elements signField = new Elements();
				Elements seumyungDateField = new Elements();
				
				logger.debug("endDocInfo.getDocState() in insertSeumyungdateMobile   ::   " + endDocInfo.getDocState());
		        if (endDocInfo.getDocState().equals("011")) { // 수신결재
		        	signField = doc.select("[id^='1sign']");
					seumyungDateField = doc.select("[id^='1seumyungdate" + signField.size() + "']"); // (수신)최종결재자의 결재날짜
		        } else { // 내부결재
		        	signField = doc.select("[id^='sign']");
					seumyungDateField = doc.select("[id^='seumyungdate" + signField.size() + "']"); // (내부)최종결재자의 결재날짜
		        }
		        
				// 모바일 결재 시 디폴트가 문자서명이므로, 이미지 서명 분기는 생략
				if (signField.size() > 0 && seumyungDateField.size() == 0) { // 서명 필드가 존재하며, 결재날짜 필드가 없는 경우
					String orgSignHtml = signField.get(signField.size() - 1).html();
					String newSignHtml = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime("yyyy/MM/dd"), offset, false).substring(5,10) + "<br>" + orgSignHtml;
					logger.debug("newSignHtml   ::   " + newSignHtml);
					
					signField.get(signField.size() - 1).html(newSignHtml);
					
					// 수정한 결재문서 html을 다시 mht로 저장한다.
					//OutputStream outputStream = null;
	        		//OutputStreamWriter output = null;
					String tempHtml = doc.outerHtml();
	        		String convertedMHT = ezCommonService.startHtml2Mht(tempHtml, realPath, locale);
	        		
	        		try (OutputStream outputStream = new FileOutputStream(new File(commonUtil.detectPathTraversal(realPath + docHref)));
	        				OutputStreamWriter output = new OutputStreamWriter(outputStream)) {
	        			output.write(convertedMHT);
	        		} catch (Exception e) {
	        			logger.error(e.getMessage(), e);
	        		}
				}
			} else { // 아직 결재 진행중인 경우, 바로 리턴시킨다. 에러는 아니다.
				logger.debug("insertSeumyungdateMobile ended(Not End Apr)");
				return result;
			}
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result = "ERROR";
			
			logger.debug("insertSeumyungdateMobile ended(ERROR)");
			return result;
		}
		
		logger.debug("insertSeumyungdateMobile ended");
		return result;
	}

	@Override
	public List<MApprovalGAbsenteeAddJobInfoVO> getAbsenteeAddJobInfo(MCommonVO userInfo) throws Exception {
		logger.debug("getAbsenteeAddJobInfo started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userID", userInfo.getUserId());
		map.put("tenantId", userInfo.getTenantId());
		List<MApprovalGAbsenteeAddJobInfoVO> list = mApprovalGDAO.getAbsenteeAddJobInfo(map);

		logger.debug("getAbsenteeAddJobInfo ended");
		return list;
	}

	@Override
	public int updateAbsenteeJobInfo(JSONObject data, String userId, int tenantId) throws Exception {
		logger.debug("updateAbsenteeJobInfo started");

		int result = 0;
		String startDate = data.get("startDate").toString();
		String endDate = data.get("endDate").toString();
		String dataArr = data.get("dataArr").toString();
		String deptId		;
		String jobId 		;
		String proxyId 		;
		String proxyName 	;
		String proxyDept 	;
		String proxyReason	;
		String proxyInfo 	;
		JSONParser parser = new JSONParser();
		Object obj = parser.parse( dataArr );
		JSONObject jsonObj = (JSONObject) obj;
		Map<String, Object> map;
		MApprovalGAbsenteeInfoVO absenteeInfoVO = new MApprovalGAbsenteeInfoVO();
		absenteeInfoVO.setTenantId(tenantId);
		absenteeInfoVO.setUserId(userId);

		for (int i = 0; i < jsonObj.size(); i++) {
			String index = i + "";
			JSONObject json = (JSONObject) parser.parse(jsonObj.get(index).toString());

			deptId = json.get("deptId").toString();
			jobId  = json.get("jobId").toString();
			proxyId = json.get("proxyId") != null ? json.get("proxyId").toString() : "";
			proxyName = json.get("proxyName") != null ? json.get("proxyName").toString() : "";
			proxyDept = json.get("proxyDept") != null ? json.get("proxyDept").toString() : "";
			proxyReason = json.get("proxyReason") != null ? json.get("proxyReason").toString() : "";
			proxyInfo = proxyId + ":" + proxyName + ":" + proxyDept + ":" + startDate + ":" + endDate;

			if (!proxyReason.equals("")) { // 사유가 없는 경우 :제거
				proxyInfo += ":" + proxyReason;
			} else if (proxyId.equals("")) { //사유가 없음 & 대리결제자 없을경우
				proxyInfo = "";
			}

			if (jobId.equals("-1")) {
				absenteeInfoVO.setAbsenteeInfo(proxyInfo);
				result += setAbsenteeInfo(absenteeInfoVO);
			} else {
				map = new HashMap<String, Object>();
				map.put("userID", userId);
				map.put("deptId", deptId);
				map.put("tenantId", tenantId);
				map.put("absenteeInfo", proxyInfo);
				map.put("jobId", jobId);
				mApprovalGDAO.updateAbsenteeAddJobInfo(map);
			}

		}


		logger.debug("updateAbsenteeJobInfo ended");
		return result;
	}

	@Override
	public JSONObject gwDraft(JSONObject jObject, String realPath, MCommonVO userInfo) throws Exception {
		JSONObject result = new JSONObject();
		String resultMessage = "success";
		
		try {
			String userId = jObject.get("userId").toString();
			String companyId = jObject.get("companyId").toString();
			String deptId = jObject.get("deptId").toString();
			String hasAttachYn = "N";
			if (companyId != null && !companyId.equals("") && !companyId.equals(userInfo.getCompanyId())) {
				userInfo.setCompanyId(companyId);
			}
						
			String formId =  jObject.get("formId").toString();
			int tenantId = userInfo.getTenantId();

			int resultCode = 0;
			
			HashMap<String, Object> map = new HashMap<>();

			String href = "";

			map.put("v_WRITERID", userId);
			map.put("v_CN", userId);
			map.put("v_WRITERDEPTID", deptId);
			map.put("v_COMPANYID", companyId);
			map.put("v_FORMID", formId);
			map.put("v_TENANTID", tenantId);
			
			//가장 최근 완료문서 조회
			HashMap<String, Object> lastDocInfo = mApprovalGDAO.getLastDocInfo(map);

			logger.debug("testGetLastDocInfo lastDocInfo: " + lastDocInfo.toString());

			map.put("v_DOCID", lastDocInfo.get("DOCID"));
			
			//문서아이디 발급 및 진행문서 정보 생성
			String newDocId = ezApprovalGService.createNewDoc(formId, companyId, tenantId);
			logger.debug(" newDocId: " + newDocId);

			//mht 파일 생성 경로
			String thisYear = ezApprovalGService.getDocHrefYear(newDocId, companyId, tenantId);
			logger.debug("oldYear: " + thisYear);
			String extension = ".mht";
			String filePath = commonUtil.getUploadPath("upload_approvalG.ROOT", tenantId) + commonUtil.separator + companyId + commonUtil.separator + "doc" + commonUtil.separator + thisYear + 
					commonUtil.separator + "1000" + commonUtil.separator + ezApprovalGService.getDocDir(newDocId);
			String fileName = newDocId + extension;
			logger.debug("filePath: " + filePath);

			map.put("realPath", realPath);
			map.put("filePath", filePath);
			map.put("fileName", fileName);
			
			//첨부파일 저장
			if (jObject.get("attachments") != null && !jObject.get("attachments").equals("")) {
				hasAttachYn = "Y";
			}
			
			//가장 최근 완료문서 정보 조회 및 진행문서 데이터 보완
			HashMap<String, Object> endDocInfo = mApprovalGDAO.getEndDocInfo(map);
			
			href = filePath + commonUtil.separator + fileName;
			String docNum = (String) endDocInfo.get("DOCNO");
			docNum = docNum.substring(0,(docNum.lastIndexOf("-")+1));
			
			HashMap<String, Object> userMasterInfo = mApprovalGDAO.getUserInfo(map);
			
			jObject.put("docnumber", docNum);
			jObject.put("receiptnumber", "");
			jObject.put("telephone", userMasterInfo.get("TELEPHONENUMBER"));
			jObject.put("fax", userMasterInfo.get("FACSIMILETELEPHONENUMBER"));
			jObject.put("email", userMasterInfo.get("MAIL"));
			
			String docTitle =  (jObject.get("doctitle") == null) ?  "제목없음":(String) jObject.get("doctitle");
			jObject.put("doctitle", docTitle);
			
			//데이터 초기화
			endDocInfo.put("HASOPINIONYN", "N");
			endDocInfo.put("STARTDATE", commonUtil.getTodayUTCTime(""));
			endDocInfo.put("HREF", href);
			endDocInfo.put("DOCID", newDocId);
			endDocInfo.put("DOCSTATE", "001");
			endDocInfo.put("FUNCTIONTYPE", "002");
			endDocInfo.put("DOCTITLE", docTitle);
			endDocInfo.put("DOCNO", docNum);
			endDocInfo.put("HASATTACHYN", hasAttachYn);
			
			int sqlResult = mApprovalGDAO.updateDocInfo(endDocInfo);

			logger.debug("sqlResult: " + sqlResult);

			HashMap<String, Object> expEndDocInfo = mApprovalGDAO.getEndDocInfoEx(map);
			
			expEndDocInfo.put("DOCID", newDocId);
			
			sqlResult = mApprovalGDAO.updateDocInfoEx(expEndDocInfo);

			logger.debug("sqlResult: " + sqlResult);

			List<HashMap> endDocLineInfo = mApprovalGDAO.getEndDocLineInfo(map);
			
			for (HashMap hashMap : endDocLineInfo) {

				hashMap.put("DOCID", newDocId);
				Long aprmembersn = (Long) hashMap.get("APRMEMBERSN");
				String jikwe = "jikwe" + aprmembersn.toString();				
				jObject.put(jikwe, hashMap.get("APRMEMBERJOBTITLE"));
				
				if(aprmembersn.toString().equals("1")) {
					hashMap.put("APRSTATE", "003");
					hashMap.put("RECEIVEDDATE", commonUtil.getTodayUTCTime(""));
					hashMap.put("PROCESSDATE", commonUtil.getTodayUTCTime(""));
					jObject.put("sign1", hashMap.get("APRMEMBERNAME"));
				} else if (aprmembersn.toString().equals("2")) {
					hashMap.put("APRSTATE", "002");
					hashMap.put("RECEIVEDDATE", commonUtil.getTodayUTCTime(""));
					hashMap.put("PROCESSDATE", null);
				} else {
					hashMap.put("APRSTATE", "001");
					hashMap.put("RECEIVEDDATE", null);
					hashMap.put("PROCESSDATE", null);
				}
				
				mApprovalGDAO.insertDocLineInfo(hashMap);

				logger.debug("endDocLineInfo: " + hashMap);

			}
			
			
			List<HashMap> expEndDocLine = mApprovalGDAO.getEndDocLineInfoEx(map);
			
			for (HashMap hashMap : expEndDocLine) {
				
				hashMap.put("DOCID", newDocId);
				mApprovalGDAO.insertDocLineInfoEx(hashMap);

				logger.debug("expEndDocLine: " + hashMap);

			}
			
			List<HashMap> endReceiptInfo = mApprovalGDAO.getEndReceiptDocInfo(map);
			
			for (HashMap hashMap : endReceiptInfo) {
				
				hashMap.put("DOCID", newDocId);
				hashMap.put("EXTRECEPTYN", "N");
				hashMap.put("PROCESSYN", "N");
				hashMap.put("PROCESSDATE", null);
				
				mApprovalGDAO.insertDocRecvInfo(hashMap);

				logger.debug("endReceiptInfo: " + hashMap);

			}
			
			//파일생성
			String resultFile = createMhtFile(map, jObject);
			
			if(resultFile.equals("fail")) {
				
				resultCode = 1;
				resultMessage = "file create failure";
				
			}
			
			if(hasAttachYn.equals("Y")) {
				saveAttachmentsInfo(jObject.get("attachments").toString(), newDocId, filePath, "APPROVAL", realPath, userInfo);
			}

			
			//resultCode 가 0이면 업데이트를 했는데 업데이트가 안된 경우 잘못된 경우지만 흐름은 정상적으로 흘러가기에 코드로 구분 프론트단에서 업데이트가 안됐다고 알려줘야하는데 안될리가 없을듯 하지만 한치앞을 내다볼수없는 세상이라 만들어놓음
			if (resultCode == 0) {
				result.put("status", "ok");
				result.put("code", "2");
				result.put("data", "");
				result.put("message", resultMessage);
			} else {
				result.put("status", "ok");
				result.put("code", "0");
				result.put("data", "");
				result.put("message", resultMessage);
			}
			
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", "1");
			result.put("message", "gwDraft service error");
		}
		
		return result;
	}
	
	//MHT 파일 생성
	public String createMhtFile(HashMap<String, Object> map, JSONObject jObject) throws Exception {
		
		String result = "success";
		String realPath = (String) map.get("realPath");
		String filePath = (String) map.get("filePath");
		String fileName = (String) map.get("fileName");
		
		
		HashMap<String, Object> formInfo = mApprovalGDAO.getFormInfo(map);
		String formURL = realPath + formInfo.get("FORMFILELOCATION");
		String loadMht = ezCommonService.loadMHTFile(formURL); // 결재문서 가져오기
		logger.debug("loadMht: " + loadMht);

		Locale locale = new Locale("ko");		
		String m_strMHT = "";
	
		File Folder = new File(realPath + filePath);
		
		if(!Folder.exists()) {
			Folder.mkdirs();
			logger.debug("폴더 생성 완료!!!");
		}
		
		//양식을 가져와서 데이터를 매핑한 후 문서를 생성
		m_strMHT = changeHTMLInMHT(loadMht, jObject, locale);
		
		OutputStream outputStream = null;
		OutputStreamWriter outputStreamWriter = null;
		
		try {
			outputStream = new FileOutputStream(new File(commonUtil.detectPathTraversal(realPath + filePath + commonUtil.separator + fileName)));
			outputStreamWriter = new OutputStreamWriter(outputStream);
			outputStreamWriter.write(m_strMHT);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result = "fail";
		} finally {
			// 2023-05-17 이사라 : NullPointerException 시큐어코딩
			//outputStreamWriter.close();
			//outputStream.close();
			IOUtils.closeQuietly(outputStreamWriter);
			IOUtils.closeQuietly(outputStream);
		}
		
		return result;
		
	}
	
	//MHT 파일에 데이터를 추가한 MHT를 생성
		public String changeHTMLInMHT(String m_strMHT, JSONObject jObject, Locale locale) throws Exception {
			
			logger.debug("====== startMHT2HTML started ======");
			String m_strHTML = "";
			String r_strMHT = "";
			String strBoundary = "";
			String[] m_Mimechunk = null;
			boolean isUTF8;
			
			strBoundary = getBoundaryText(m_strMHT);
			logger.debug("strBoundary="+strBoundary);

			if (m_strMHT != null && !m_strMHT.equals("")) {
				if (strBoundary.equals("error")) {
					return egovMessageSource.getMessage("main.t0600", locale);
				} else {
					m_Mimechunk = m_strMHT.split(strBoundary);
					logger.debug("m_Mimechunk="+m_Mimechunk);
					
					//문서 인코딩 방식 추출 
	                if (m_Mimechunk[0].indexOf("(UTF-8)") > -1) 
	                    isUTF8 = true; 
	                else 
	                    isUTF8 = false; 
					
					for (int i = 1; i < m_Mimechunk.length; i++) {
						String[] strMimeChunk = m_Mimechunk[i].split(commonUtil.CRLF + commonUtil.CRLF);
						String[] strMime_info_p = strMimeChunk[0].trim().split(commonUtil.CRLF);
						String[] strMime_info_tupe = strMime_info_p[0].split(": ");

						if (strMime_info_tupe[0].equals("Content-Type")) {
							if (strMime_info_tupe[1].equals("Text/HTML")) {
								m_strHTML = doMHTDecoding(strMimeChunk[1].trim(), m_strHTML, isUTF8);
							}
						}
					}

					Document doc = Jsoup.parse(m_strHTML);
					Element body = doc.body();
					
				 	Set keys = jObject.keySet();
					
					Iterator jKeyList = keys.iterator();
					
					while(jKeyList.hasNext()) {
						
						String key = (String) jKeyList.next();
						String val = (String) jObject.get(key);
							
						Element targetId = body.getElementById(key);					
						if(targetId != null) {
							targetId.text("");
							targetId.append(val);						
						}
						
						
					}

					//logger.debug("doc: " + doc.toString());

					StringBuilder mhtBuilder = new StringBuilder();
					StringBuilder htmlBuilder = new StringBuilder(doc.toString());
					
					doHtmlEncoding( htmlBuilder, mhtBuilder, strBoundary);

					//logger.debug("mhtBuilder: " + mhtBuilder.toString());

					logger.debug("m_Mimechunk size: " + m_Mimechunk.length);

					m_Mimechunk[1] = mhtBuilder.toString();
					
					for (int i = 0; i < m_Mimechunk.length; i++) {

						//logger.debug("m_Mimechunk index " + i + " : " + m_Mimechunk[i].toString());

						if(i == (m_Mimechunk.length - 1)) {
							r_strMHT = r_strMHT + strBoundary + m_Mimechunk[i];
						} else {
							r_strMHT = r_strMHT + m_Mimechunk[i];
						}
						
					}
					
					return r_strMHT;
				}
			} else {

				return egovMessageSource.getMessage("main.t0602", locale);
			}
			
		}
	
		/**
		 * html -> mht 변환boundary 반환 표출 Method
		 */
		private String getBoundaryText(String m_strMHT) {
			String strTemp = m_strMHT;
	        int nPos = strTemp.indexOf("boundary=");

	        if (nPos > 0) {
	            int nEndPos = strTemp.indexOf("\"", nPos + 10);
	            return "--" + strTemp.substring(nPos + 10, nEndPos);
	        } else {
	            return "error";
	        }
		}
		
		/**
		 * html -> mht 변환 mht디코딩 표출 Method
		 */
		private String doMHTDecoding(String strMht, String m_strHTML, boolean isUTF8) {
			byte[] arr = Base64.getMimeDecoder().decode(strMht);

			try {
				//m_strHTML = new String(arr, "utf-8");
				if(isUTF8)
	                m_strHTML = new String(arr, "utf-8");
	            else
	                m_strHTML = new String(arr, "ks_c_5601-1987");
			} catch (UnsupportedEncodingException e) {
				logger.error(e.getMessage(), e);
			}

			return m_strHTML;
		}
		
		/**
		 * html -> mht 변환 html 인코딩 실행 Method
		 */
		private void doHtmlEncoding(StringBuilder htmlBuilder, StringBuilder mhtBuilder, String m_strBoundary) throws Exception{
	        mhtBuilder.append(m_strBoundary + commonUtil.CRLF);
	        mhtBuilder.append("Content-Type: Text/HTML" + commonUtil.CRLF);
	        mhtBuilder.append("Content-Transfer-Encoding: base64" + commonUtil.CRLF);
	        mhtBuilder.append("Content-Location: file://c:" + commonUtil.separator + "test.htm" + commonUtil.CRLF);
	        mhtBuilder.append(commonUtil.CRLF);

	        byte[] arr = htmlBuilder.toString().getBytes("UTF-8");
	        String strMhtBase64 = Base64.getMimeEncoder().encodeToString(arr);

	        mhtBuilder.append(strMhtBase64 + commonUtil.CRLF);
	        mhtBuilder.append(m_strBoundary);
	    }
		
		/**
		 * 전자결재 첨부파일저장 실행 Method
		 */
		public boolean saveAttachmentsInfo(String strAttachments, String newDocId, String strFilePath, String strType, String realPath, MCommonVO userInfo) throws Exception{
			logger.debug("saveAttachmentsInfo started");
			
			String fileRoot = "fileroot/0/files";
			
	        long fileSize = 0;
	        boolean rtnValue = false;
	        String filePath = "";
	        String filePath2 = "";
	        String fileName = "";
	        
	        try {
	        	if (!strAttachments.substring(strAttachments.length() - 1).equals("|")) {
	        		strAttachments += "|";
	        	}
	        	
	        	for (int i = 0; i < strAttachments.split("\\|").length; i++) {
	        		
	        		String targetStr = strAttachments.split("\\|")[i];
	        		targetStr = targetStr.substring(targetStr.indexOf("{"));
	        			
	        		filePath = commonUtil.separator + fileRoot + commonUtil.separator + "upload_board" + commonUtil.separator + "tempUploadFile" + commonUtil.separator + targetStr;
	        			
	        		File file = new File(realPath + filePath);
	        		
	        		fileSize = file.length();
	        		String thisYear = ezApprovalGService.getDocHrefYear(newDocId, userInfo.getCompanyId(), userInfo.getTenantId());
	    			String fileUploadPath = commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()) + commonUtil.separator + userInfo.getCompanyId() + commonUtil.separator + "uploadFile" + commonUtil.separator + thisYear + 
	    					commonUtil.separator + ezApprovalGService.getDocDir(newDocId);
	        		
	    			File uploadPath = new File(realPath + fileUploadPath);
	    			
	    			if(!uploadPath.exists()) {
	    				uploadPath.mkdirs();
	    			}
	    			
	    			
	        		filePath2 =  fileUploadPath + commonUtil.separator + targetStr;
	        				
	        		File fileinfo = new File(realPath + fileUploadPath + commonUtil.separator + targetStr);
	        		
	        		if (!fileinfo.exists()) {
	        			FileUtils.moveFile(file, fileinfo);
	        		}

	        		file = null;
	        		
	        		fileName = filePath2.replace(fileUploadPath, "").substring(40);
	        		
	        		saveAttachInfo(newDocId, i, filePath2, fileSize, fileName, userInfo);
	        	}
	        	
	        	rtnValue = true;
			} catch (Exception e) {
				logger.error(e.getMessage(), e);
				logger.debug(e.getMessage());
				TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
				rtnValue = false;
			}
	        
	        logger.debug("saveAttachmentsInfo ended");
	        return rtnValue;
		}
		
		public void saveAttachInfo(String newDocId, int seqNum, String filePath, long fileSize, String fileName, MCommonVO userInfo) throws Exception {
			logger.debug("saveAttachInfo started");
			
			/*
			 * DOCID , ATTACHFILESN , VIEWORDER , ATTACHFILENAME , ATTACHFILEHREF ,
			 * ATTACHFILESIZE , ATTACHUSERID , ATTACHUSERNAME , ATTACHUSERJOBTITLE ,
			 * ATTACHUSERDEPTID , ATTACHUSERDEPTNAME , PAGENUM , DISPLAYNAME , BODYATTACH ,
			 * AttachUserName2 , AttachUserJobTitle2 , AttachUserDeptName2 , TENANT_ID ,
			 * COMPANYID, ISBIGATTACH, ISBIGATTACHDEL, SAVEDATE
			 */
			
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("v_DOCID", newDocId);
			map.put("v_ATTACHFILESN", seqNum);
			map.put("v_VIEWORDER", seqNum);
			map.put("v_ATTACHFILENAME", fileName);
			map.put("v_ATTACHFILEHREF", filePath);
			map.put("v_ATTACHFILESIZE", fileSize);
			map.put("v_ATTACHUSERID", userInfo.getUserId());
			map.put("v_ATTACHUSERNAME", userInfo.getDeptName());
			map.put("v_ATTACHUSERJOBTITLE", userInfo.getTitle());
			map.put("v_ATTACHUSERDEPTID", userInfo.getDeptId());
			map.put("v_ATTACHUSERDEPTNAME", userInfo.getDeptName());
			map.put("v_DISPLAYNAME", fileName);
			map.put("v_ATTACHUSERNAME2", userInfo.getDeptName2());
			map.put("v_ATTACHUSERJOBTITLE2", userInfo.getTitle2());
			map.put("v_ATTACHUSERDEPTNAME2", userInfo.getDeptName2());
			map.put("v_TENANTID", userInfo.getTenantId());
			map.put("v_COMPANYID", userInfo.getCompanyId());
			
			mApprovalGDAO.saveAttachInfo(map);
			
			logger.debug("saveAttachInfo ended");
		}

		@Override
		public List<HashMap> checkChangeDocInfo(HashMap<String, Object> params) throws Exception {
			
			List<HashMap> result = mApprovalGDAO.checkChangeDocInfo(params);
			
			return result;
		}
		
	@Override
	public HashMap<String, Object> getAprMemberBySn(String docID, String aprMemberSN, String lang, String companyID, int tenantID) throws Exception {
		logger.debug("getAprMemberBySn started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_DOCID", docID);
		map.put("v_APRMEMBERSN", aprMemberSN);
		map.put("v_LANG", lang);
		map.put("v_COMPANYID", companyID);
		map.put("v_TENANTID", tenantID);
		
		HashMap<String, Object> result = mApprovalGDAO.getAprMemberBySn(map);
		
		logger.debug("getAprMemberBySn ended");
		return result;
	}

	@Override
	public String gongRamCancel(String docID, int count, int aprMemberSN, String companyID, int tenantId) throws Exception {
		logger.debug("gongRamCancel started.");

        Map<String, Object> map = new HashMap<String, Object>();

        map.put("v_DocID", docID);
        map.put("v_gongRamDocID", docID);
        map.put("companyID", companyID);
        map.put("v_TENANTID", tenantId);
        map.put("v_AprMemberSN", aprMemberSN);

        try {
            if (count == aprMemberSN) {
                if (count == 1) {
                    ezApprovalGDAO.aprDeleteDocInfo(map);
                    ezApprovalGDAO.aprDeleteDocInfo2(map);
                    ezApprovalGDAO.aprDeleteDocInfo5(map);
                    ezApprovalGDAO.aprDeleteDocInfo6(map);
                    ezApprovalGDAO.aprDeleteDocInfo7(map);
                    ezApprovalGDAO.aprDeleteDocInfo8(map);
                    ezApprovalGDAO.aprDeleteDocInfo9(map);
                } else {
                    ezApprovalGDAO.deleteGongRamSaveExpAprLine(map);
                    ezApprovalGDAO.deleteGongRamSaveAprLineInfo(map);
                }
            } else {
                ezApprovalGDAO.deleteGongRamSaveExpAprLine(map);
                ezApprovalGDAO.deleteGongRamSaveAprLineInfo(map);

                for (int i = aprMemberSN + 1; i <= count; i++) {
                    map.put("v_AprMemberSN", i);

                    ezApprovalGDAO.updateOtherGongRamExpAprLine(map);
                    ezApprovalGDAO.updateOtherGongRamAprLineInfo(map);
                }
            }
        } catch (Exception e) {
            logger.error(e.getMessage(), e);
            return "FALSE";
        }
        logger.debug("gongRamCancel ended.");
        return "TRUE";
	}

    public String makeListField(String orgStr) {
        if (orgStr == null || orgStr.equals("NULL")) {
            return "";
        } else {
            return orgStr;
        }
    }

    @Override
    public String getForm(String formContID, String kind, String searchType, String searchName, String userID, String deptId, String companyID, String lang, int tenantID) throws Exception {
        logger.debug("getForm started");

        String listCode = "109";
        Map<String, Object> listCodeMap = new HashMap<String, Object>();
        listCodeMap.put("v_LISTTYPE", listCode);
        listCodeMap.put("v_LANGTYPE", lang);
        listCodeMap.put("companyID", companyID);
        listCodeMap.put("v_TENANTID", tenantID);
        logger.debug("getListHeader Param : v_LISTTYPE="+ listCode + " v_LANGTYPE = " +lang +" companyID = " + companyID + " v_TENANTID =" + tenantID);

        List<ApprGListHeaderVO> apprGListHeaderVOList = ezApprovalGDAO.getListHeader(listCodeMap);
        StringBuffer listCodeMapSb = new StringBuffer();
        listCodeMapSb.append("<DATA>");

        for (int i = 0; i < apprGListHeaderVOList.size(); i++) {
            listCodeMapSb.append(commonUtil.getQueryResult(apprGListHeaderVOList.get(i)));
        }

        listCodeMapSb.append("</DATA>");
        String listString = listCodeMapSb.toString();
        org.w3c.dom.Document listXML = commonUtil.convertStringToDocument(listString);

        int hlength = listXML.getElementsByTagName("NAME").getLength();

        StringBuffer resultXML = new StringBuffer();
        resultXML.append("<LISTVIEWDATA>");
        resultXML.append("<HEADERS>");

        for (int k = 0; k < hlength; k++) {
            resultXML.append("<HEADER>");
            resultXML.append("<NAME>" + listXML.getElementsByTagName("NAME").item(k).getTextContent() + "</NAME>");
            resultXML.append("<WIDTH>" + listXML.getElementsByTagName("WIDTH").item(k).getTextContent() + "</WIDTH>");
            resultXML.append("</HEADER>");
        }

        resultXML.append("</HEADERS>");

        String strMultiData = commonUtil.getMultiData(lang, tenantID);
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("v_FORMCONTID", formContID);
        map.put("v_USERID", userID);
        map.put("v_FORMKIND", kind);
        map.put("v_LANGTYPE", strMultiData);
        map.put("v_SEARCHTYPE", searchType);
        map.put("deptId", deptId);
        map.put("v_SEARCHNAME", searchName);
        map.put("v_TENANTID", tenantID);
        map.put("companyID", companyID);
        map.put("v_MOBILEDRAFTFLAG", "Y");

        List<ApprGFormVO> apprGFormVOlist = new ArrayList<>();

        if("RESEND".equals(formContID)){
            apprGFormVOlist = ezApprovalGDAO.getResendFormInfo(map);
        }else{
            apprGFormVOlist = ezApprovalGDAO.getFormInfo(map);
        }
        StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        for (int i = 0; i < apprGFormVOlist.size(); i++) {
            sb.append(commonUtil.getQueryResult(apprGFormVOlist.get(i)));
        }
        sb.append("</DATA>");
        String docList = sb.toString();


        org.w3c.dom.Document docXML = commonUtil.convertStringToDocument(docList);
        int dlength = docXML.getElementsByTagName("ROW").getLength();
        String primaryData = commonUtil.getPrimaryData(lang, tenantID);

        resultXML.append("<ROWS>");

        for (int k = 0; k < dlength; k++) {
            resultXML.append("<ROW>");

            for (int p = 0; p < hlength; p++) {
                resultXML.append("<CELL>");

                if (p == 0) {
                    if (primaryData.equals("1")) {
                        resultXML.append("<VALUE><![CDATA[" + makeListField(docXML.getElementsByTagName("FORMNAME").item(k).getTextContent()) + "]]></VALUE>");
                    } else {
                        // 2018-07-13 천성준 (#13071) 이름이 없는 양식이 존재함
                        if (makeListField(docXML.getElementsByTagName("FORMNAME2").item(k).getTextContent()).length() <= 0) {
                            resultXML.append("<VALUE><![CDATA[" + makeListField(docXML.getElementsByTagName("FORMNAME").item(k).getTextContent()) + "]]></VALUE>");
                        } else {
                            resultXML.append("<VALUE><![CDATA[" + makeListField(docXML.getElementsByTagName("FORMNAME2").item(k).getTextContent()) + "]]></VALUE>");
                        }
                    }

                    resultXML.append("<DATA1>" + makeListField(docXML.getElementsByTagName("FORMID").item(k).getTextContent()) + "</DATA1>");
                    resultXML.append("<DATA2><![CDATA[" + makeListField(docXML.getElementsByTagName("FORMDESCRIPTION").item(k).getTextContent()) + "]]></DATA2>");
                    resultXML.append("<DATA3>" + makeListField(docXML.getElementsByTagName("FORMDOCTYPE").item(k).getTextContent()) + "</DATA3>");
                    resultXML.append("<DATA4><![CDATA[" + makeListField(docXML.getElementsByTagName("FORMFILELOCATION").item(k).getTextContent()) + "]]></DATA4>");
                    resultXML.append("<DATA5>" + makeListField(docXML.getElementsByTagName("FORMCONNFLAG").item(k).getTextContent()) + "</DATA5>");
                    resultXML.append("<DATA6><![CDATA[" + makeListField(docXML.getElementsByTagName("FORMNAME").item(k).getTextContent()) + "]]></DATA6>");
                    resultXML.append("<DATA7><![CDATA[" + makeListField(docXML.getElementsByTagName("FORMNAME2").item(k).getTextContent()) + "]]></DATA7>");
                    resultXML.append("<DATA8><![CDATA[" + makeListField(docXML.getElementsByTagName("FORMCONTID").item(k).getTextContent()) + "]]></DATA8>");
                    resultXML.append("<REFORMFLAG><![CDATA[" + makeListField(docXML.getElementsByTagName("REFORMFLAG").item(k).getTextContent()) + "]]></REFORMFLAG>");
                    resultXML.append("<DATA-COMPANYID><![CDATA[" + makeListField(docXML.getElementsByTagName("COMPANYID").item(k).getTextContent()) + "]]></DATA-COMPANYID>");
                    resultXML.append("<DATA-OFFICEFLAG><![CDATA[" + makeListField(docXML.getElementsByTagName("OFFICEFLAG").item(k).getTextContent()) + "]]></DATA-OFFICEFLAG>");
                    resultXML.append("<OPENGOVFLAG><![CDATA[" + makeListField(docXML.getElementsByTagName("OPENGOVFLAG").item(k).getTextContent()) + "]]></OPENGOVFLAG>");
                    resultXML.append("<PASSAPRLINEFLAG><![CDATA[" + makeListField(docXML.getElementsByTagName("PASSAPRLINEFLAG").item(k).getTextContent()) + "]]></PASSAPRLINEFLAG>");
                }

                resultXML.append("</CELL>");
            }

            resultXML.append("</ROW>");
        }

        resultXML.append("</ROWS>");
        resultXML.append("</LISTVIEWDATA>");

        logger.debug("getForm ended.");
        return resultXML.toString();
    }

    @Override
    public String getSecurityType(String selected, String companyID, String lang, int tenantID, String approvalFlag) throws Exception {
        logger.debug("mobile getSecurityType started");
        StringBuilder rtnXML = new StringBuilder();

        Map<String, Object> map = new HashMap<String, Object>();
        map.put("v_LANGTYPE", lang);
        map.put("companyID", companyID);
        map.put("v_TENANTID", tenantID);
        map.put("approvalFlag", approvalFlag);
        List<ApprGLeftVO> apprGLeftVOlist = ezApprovalGDAO.getSecurityType(map);

        StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");

        for (int i = 0; i < apprGLeftVOlist.size(); i++) {
            sb.append(commonUtil.getQueryResult(apprGLeftVOlist.get(i)));
        }

        sb.append("</DATA>");

        org.w3c.dom.Document docXML = commonUtil.convertStringToDocument(sb.toString());

        int dlength = docXML.getElementsByTagName("ROW").getLength();

        for (int k = 0; k < dlength; k++) {
            String[] colOption = docXML.getElementsByTagName("NAME").item(k).getTextContent().split(";");
            rtnXML.append("<option name='RSecurity' value=" + colOption[2] + ">" + colOption[1] + "</option>");
        }
        logger.debug("mobile getSecurityType ended");
        return rtnXML.toString();
    }

    @Override
    public String getKeepType(String lang, int tenantID, String companyID) throws Exception {
        StringBuilder rtnXML = new StringBuilder();
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("v_LANGTYPE", lang);
        map.put("v_TENANTID", tenantID);
        map.put("companyID", companyID);
        map.put("approvalFlag", ezCommonService.getTenantConfig("ApprovalFlag", tenantID));
        List<ApprGLeftVO> apprGetKeepTypeList = ezApprovalGDAO.getKeepType(map);

        StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");

        for (int i = 0; i < apprGetKeepTypeList.size(); i++) {
            sb.append(commonUtil.getQueryResult(apprGetKeepTypeList.get(i)));
        }

        sb.append("</DATA>");

        org.w3c.dom.Document docXML = commonUtil.convertStringToDocument(sb.toString());

        int dlength = docXML.getElementsByTagName("ROW").getLength();

        for (int k = 0; k < dlength; k++) {
            String[] colOption = docXML.getElementsByTagName("NAME").item(k).getTextContent().split(";");
            rtnXML.append("<option name='RKeeptype' value=" +  colOption[2] + ">" +  colOption[1] + "</option>");
        }
        return rtnXML.toString();
    }

    @Override
    public int getAttachFileMaxSn(String docID, int tenantID, String companyID) throws Exception {
        logger.debug("getAttachFileMaxSn started");
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("v_DOCID", docID);
        map.put("v_TENANTID", tenantID);
        map.put("companyID", companyID);

        int result = mApprovalGDAO.getAttachFileMaxSn(map);

        logger.debug("getAttachFileMaxSn ended");
        return result;
    }

    @Override
    public String updateAttachFileInfo(String docID, JSONObject jsonObj, MCommonVO userInfo) throws Exception {
        logger.debug("updateAttachFileInfo started");
        String rtnVal = deleteAttachFileInfo(docID, userInfo.getCompanyId(), userInfo.getLang(), userInfo.getTenantId());

        Map<String, Object> map = new HashMap<String, Object>();

        if (rtnVal.equals("TRUE")) {
            String size = "";
            JSONParser parser = new JSONParser();
            for (int i = 0; i < jsonObj.size(); i++) {
                String index = i + "";
                JSONObject json = (JSONObject) parser.parse(jsonObj.get(index).toString());

                size = json.get("filesize").toString().trim();

                map.put("v_DOCID", docID);
                map.put("v_ATTACHFILESN", json.get("fileSn").toString());
                map.put("v_VIEWORDER", jsonObj.size() - i);
                map.put("v_ATTACHFILENAME", json.get("fileName").toString());
                map.put("v_ATTACHFILEHREF", json.get("fileLocation").toString());
                map.put("v_ATTACHFILESIZE", size);
                map.put("v_ATTACHUSERID", userInfo.getUserId());
                map.put("v_ATTACHUSERNAME", userInfo.getUserName());
                map.put("v_ATTACHUSERNAME2", userInfo.getUserName2());
                map.put("v_ATTACHUSERJOBTITLE", userInfo.getTitle());
                map.put("v_ATTACHUSERJOBTITLE2", userInfo.getTitle2());
                map.put("v_ATTACHUSERDEPTID", userInfo.getDeptId());
                map.put("v_ATTACHUSERDEPTNAME", userInfo.getDeptName());
                map.put("v_ATTACHUSERDEPTNAME2", userInfo.getDeptName2());
                map.put("v_PAGENUM", "1");
                map.put("v_DISPLAYNAME", json.get("fileName").toString());
                map.put("v_BODYATTACH", "N");
                map.put("FLAG", "Y");
                map.put("companyID", userInfo.getCompanyId());
                map.put("v_TENANTID", userInfo.getTenantId());

                /* 2020-11-12 홍승비 - 대용량첨부 플래그, 첨부파일 최초 저장일 추가 */
                map.put("v_ISBIGATTACH", json.get("isBigAttachYN").toString());
                map.put("v_ISBIGATTACHDEL", "N");
                map.put("v_SYSDATE", commonUtil.getTodayUTCTime(""));

                ezApprovalGDAO.insertAprAttachInfo(map);
                ezApprovalGDAO.updateHistoryAttachInfo(map);
                ezApprovalGDAO.updateAttachFileInfo(map);

                if (config.getProperty("config.useOpenGov").equals("YES")) {
                    ezApprovalGDAO.insertOpenGovAttachInfo(map);
                }
            }
        }
        logger.debug("updateAttachFileInfo started");
        return rtnVal;
    }

    @Override
    public String deleteAttachFileInfo(String docID, String companyID, String lang, int tenantID) throws Exception {
        logger.debug("deleteAttachFileInfo started");

        Map<String, Object> map = new HashMap<String, Object>();

        map.put("v_DOCID", docID);
        map.put("companyID", companyID);
        map.put("v_TENANTID", tenantID);

        ezApprovalGDAO.deleteAttachFileInfo(map);
        // 원문정보공개 첨부파일 삭제
        ezApprovalGDAO.deleteOpenGovAttachInfo(map);

        int attachFile = ezApprovalGDAO.countAttachFile(map);

        if (attachFile > 0) {
            map.put("FLAG", "Y");
            ezApprovalGDAO.updateAttachFileInfo(map);
        } else {
            map.put("FLAG", "N");
            ezApprovalGDAO.updateAttachFileInfo(map);
        }

        logger.debug("deleteAttachFileInfo ended");

        return "TRUE";
    }

    @Override
    public String updateAttachDocInfo(JSONObject jsonObject, MCommonVO userInfo, String approvalFlag) throws Exception {
        logger.debug("updateAttachDocInfo started");

        JSONParser jp = new JSONParser();
        JSONObject data = (JSONObject) jp.parse(jsonObject.toJSONString());
        String docID = data.get("docID").toString();
        Map<String, Object> map = new HashMap<String, Object>();

        String dataArr = data.get("dataArr").toString();
        JSONParser parser = new JSONParser();
        Object obj = parser.parse(dataArr);
        JSONObject jsonObj = (JSONObject) obj;

        String rtnVal = deleteAttachDocInfo(docID, userInfo.getCompanyId(), userInfo.getLang(), userInfo.getTenantId());
        int tempSN = 0;

        if (rtnVal.equals("TRUE")) {
            for (int i = 0; i < jsonObj.size(); i++) {
                String index = i + "";
                JSONObject json = (JSONObject) parser.parse(jsonObj.get(index).toString());
                if (approvalFlag.equals("S")) {
                    tempSN = (i + 1);
                    map.put("v_DOCID", docID);
                    map.put("v_TEMPSN", tempSN);
                    map.put("v_AttachDocName", json.get("fileName").toString());
                    map.put("v_AttachDocURL", json.get("fileLocation").toString());
                    map.put("v_SubAttachYN", "N");
                    map.put("v_AttachUserID",userInfo.getUserId());
                    map.put("v_AttachUserName", userInfo.getUserName());
                    map.put("v_AttachUserName2", userInfo.getUserName2());
                    map.put("v_AttachUserJobTitle", userInfo.getTitle());
                    map.put("v_AttachUserJobTitle2", userInfo.getTitle2());
                    map.put("v_AttachUserDeptID", userInfo.getDeptId());
                    map.put("v_AttachUserDeptName", userInfo.getDeptName());
                    map.put("v_AttachUserDeptName2", userInfo.getDeptName2());
                    map.put("FLAG", "Y");
                    map.put("companyID", userInfo.getCompanyId());
                    map.put("v_TENANTID", userInfo.getTenantId());

                    ezApprovalGDAO.insertGianAprDocAttachInfo(map);
                }
            }
            ezApprovalGDAO.updateAttachFileInfo(map);
            rtnVal = "TRUE";
        }

        logger.debug("updateAttachDocInfo ended");
        return rtnVal;
    }

    @Override
    public String deleteAttachDocInfo(String docID, String companyID, String lang, int tenantID) throws Exception {
        logger.debug("deleteAttachDocInfo started");

        Map<String, Object> map = new HashMap<String, Object>();

        map.put("companyID", companyID);
        map.put("v_DOCID", docID);
        map.put("v_TENANTID", tenantID);

        ezApprovalGDAO.deleteAttachDocInfo(map);
        int countAttachDoc = ezApprovalGDAO.countAttachDocInfo(map);

        if(countAttachDoc > 0 ){
            map.put("FLAG", "Y");
            ezApprovalGDAO.updateAttachFileInfo(map);
        } else {
            map.put("FLAG", "N");
            ezApprovalGDAO.updateAttachFileInfo(map);
        }

        logger.debug("deleteAttachDocInfo ended");

        return "TRUE";
    }

    @Override
    public String saveDraftInfo(JSONObject jsonParam, String realPath, LoginVO userInfo, String userInfoXML, HttpServletRequest request) throws Exception {
        String result = "";

        try {
            org.w3c.dom.Document xmlDom = commonUtil.convertStringToDocument(jsonParam.get("docinfo").toString());
            org.w3c.dom.Document xmlDomField = commonUtil.convertStringToDocument(jsonParam.get("formFieldInfo").toString());
            org.w3c.dom.Document userDom = commonUtil.convertStringToDocument(userInfoXML);

            String docID = xmlDom.getDocumentElement().getChildNodes().item(0).getTextContent();
            int tenantId = userInfo.getTenantId();
            String companyId = userInfo.getCompanyID();
            String formURLTemp = xmlDom.getElementsByTagName("FORMURL").item(0).getTextContent();
            Locale locale = new Locale(commonUtil.getTwoLetterLangFromLangNum(userInfo.getLang()));
            String lang = userInfo.getLang();
            String junGyulFlag = ezCommonService.getTenantConfig("JunGyulFlag", userInfo.getTenantId()); // 전결자 이후 결재자 사인칸 표시 여부
            String draftJunGyulFlag = ezCommonService.getTenantConfig("draftJunGyulFlag", userInfo.getTenantId()); // 사인칸 전결자 표시
            String optIsSplit = ezApprovalGService.getOptionInfo("SA33", "001", userInfo, "CODE");
            String signImageSize = ezCommonService.getTenantConfig("SignImageSize", userInfo.getTenantId());
            String docNO = xmlDom.getElementsByTagName("DOCNO").item(0).getTextContent();
            String currentDate = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), userInfo.getOffset(), false).substring(0, 10).replace("-", ".");

            // 양식 가져와서 본문 작성 후 기안문서 생성하기
            String convertedMHT = "";
            String formURL = realPath + formURLTemp;
            String loadMht = ezCommonService.loadMHTFile(formURL); // 양식 가져오기
            String domain = request.getServerName() + ":" + request.getServerPort();
            String scheme = "http://";
            if (request.getHeader("HTTPS") != null && request.getHeader("HTTPS").toString().toLowerCase().equals("on")) {
                scheme = "https://";
            }
            String oldYear = ezApprovalGService.getDocHrefYear(docID, userInfo.getCompanyID(), userInfo.getTenantId());
            String extension = ".mht";
            String filePath = commonUtil.getUploadPath("upload_approvalG.ROOT", tenantId) + commonUtil.separator + companyId + commonUtil.separator + "doc" + commonUtil.separator + oldYear +
                    commonUtil.separator + "1000" + commonUtil.separator + ezApprovalGService.getDocDir(docID);
            String href = filePath + commonUtil.separator + docID + extension;
            xmlDom.getElementsByTagName("HREF").item(0).setTextContent(href);

            // HTML -> MHT
            String content = ezCommonService.startMHT2HTML(realPath + commonUtil.getUploadPath("config.LocalPath", userInfo.getTenantId()), loadMht, realPath + commonUtil.getUploadPath("config.LocalPath", userInfo.getTenantId()), realPath, userInfo.getLocale(), domain, scheme);
            //HTML 파싱 document 클래스 겹쳐서 임포트 못함
            org.jsoup.nodes.Document doc = Jsoup.parse(content);


            /* 문서 본문 작성 시작 */
            JSONObject fieldValue = new JSONObject();
            fieldValue.put("doctitle", xmlDom.getElementsByTagName("DOCTITLE").item(0).getTextContent());
            fieldValue.put("enforcedate", "");
            fieldValue.put("receiptdate", "");
            fieldValue.put("zipcode", userDom.getElementsByTagName("POSTALCODE").item(0).getTextContent());
            fieldValue.put("address", userDom.getElementsByTagName("STREETADDRESS").item(0).getTextContent());
            fieldValue.put("telephone", userDom.getElementsByTagName("TELEPHONENUMBER").item(0).getTextContent());
//			fieldValue.put("depttelephone", userDom.getElementsByTagName("TELEPHONENUMBER").item(0).getTextContent());
            fieldValue.put("fax", userDom.getElementsByTagName("FACSIMILETELEPHONENUMBER").item(0).getTextContent());
//			fieldValue.put("deptfax", userDom.getElementsByTagName("FACSIMILETELEPHONENUMBER").item(0).getTextContent());
            fieldValue.put("department", xmlDom.getElementsByTagName("PDEPTNAME").item(0).getTextContent());
//			fieldValue.put("parantdept", userDom.getElementsByTagName("COMPANY").item(0).getTextContent());
            fieldValue.put("charge", userDom.getElementsByTagName("DISPLAYNAME").item(0).getTextContent());
            fieldValue.put("position", xmlDom.getElementsByTagName("WRITERJOBTITLE").item(0).getTextContent());
            fieldValue.put("email", xmlDom.getElementsByTagName("WRITEREMAIL").item(0).getTextContent());
            fieldValue.put("deptname", xmlDom.getElementsByTagName("WRITERDEPTNAME").item(0).getTextContent());
            fieldValue.put("seal", userDom.getElementsByTagName("COMPANY").item(0).getTextContent() + egovMessageSource.getMessage("ezApprovalG.t171", locale));
            fieldValue.put("username", xmlDom.getElementsByTagName("WRITERNAME").item(0).getTextContent());
            fieldValue.put("draftername", xmlDom.getElementsByTagName("WRITERNAME").item(0).getTextContent());
            fieldValue.put("draftdate", currentDate);
            fieldValue.put("deptshortedname", xmlDom.getElementsByTagName("DEPTSHORTEDNAME").item(0).getTextContent());

            // 문서정보 
            fieldValue.put("keepperiod", xmlDom.getElementsByTagName("KEEPPERIODNAME").item(0).getTextContent());
            fieldValue.put("securitylevel", xmlDom.getElementsByTagName("SECURITYNAME").item(0).getTextContent());
            if ("N".equals(xmlDom.getElementsByTagName("PUBLICATION").item(0).getTextContent())) {
                fieldValue.put("publication", egovMessageSource.getMessage("ezApproval.t49", locale));
            } else {
                fieldValue.put("publication", egovMessageSource.getMessage("ezApproval.t50", locale));

            }

            Set keys = fieldValue.keySet();
            Iterator jKeyList = keys.iterator();
            while(jKeyList.hasNext()) {
                String key = (String) jKeyList.next();
                String val = (String) (fieldValue.get(key) != null ? fieldValue.get(key) : "");
                Element targetId = doc.getElementById(key);
                if(targetId != null) {
                    targetId.text(val);
                }
            }

            Element field;
            // 문서번호 - SetAutoPropertyValue 참고
            Element bodyEl = doc.getElementById("body");
            if (bodyEl != null) {
                if (!bodyEl.hasAttr("orgdocnum")) {
                    field = doc.getElementById("docnumber");
                    if (field != null) {
                        bodyEl.attr("orgdocnum", field.text().trim());
                        field.html(docNO);
                    }

                    field = doc.getElementById("bedocnumber");
                    if (field != null) {
                        bodyEl.attr("orgdocnum", field.text().trim());
                        field.html(docNO);
                    }
                }

                if (!xmlDom.getElementsByTagName("BODYATTRDOCNUM").item(0).getTextContent().isEmpty()) {
                    bodyEl.attr("docnum", xmlDom.getElementsByTagName("BODYATTRDOCNUM").item(0).getTextContent());
                }

                field = doc.getElementById("receiptnumber");
                if (field != null) {
                    field.attr("Format", field.text().trim());
                    bodyEl.attr("receiptnumber", field.text().trim());
                    field.html("");
                }
            }



            Map<String, Object> map = new HashMap<String, Object>();
            map.put("v_DOCID", docID);
            map.put("v_MODE", "APR");
            map.put("v_TENANTID", tenantId);
            map.put("companyID", companyId);

            // 결재선
            map.put("isUsed", "");
            map.put("v_FLAG", "1");
            List<ApprGAprLineVO> paprlines = ezApprovalGDAO.getAprLineInfo(map);

            int LastSignSN = 0;
            for (int i = paprlines.size() -1; i >= 0; i--) {
                ApprGAprLineVO paprline = paprlines.get(i);
                if ("001".equals(paprline.getAprType()) || "004".equals(paprline.getAprType()) || "003".equals(paprline.getAprType())) {
                    LastSignSN = i;
                }
            }

            field = doc.getElementById("lastKyuljikwee");
            if (field != null) {
                ApprGAprLineVO paprline = paprlines.get(LastSignSN);
                String pAprJobTitle = "1".equals(lang) ? paprline.getAprMemberJobTitle() : paprline.getAprMemberJobTitle2();
                field.text(pAprJobTitle);
            }

            field = doc.getElementById("lastKyulName");
            if (field != null) {
                ApprGAprLineVO paprline = paprlines.get(LastSignSN);
                String pAprName = "1".equals(lang) ? paprline.getAprMemberName() : paprline.getAprMemberName2();
                field.text(pAprName);
            }


            String susinSN = "";
            String pRefer = "";
            int hapyuiCnt = 1;
            int idx = 1;
            int cnt = 20;
            int LastSignNo = 0;

            // 2025-09-08 김유진 - 사인칸 '/' 추가를 위한 처리
            for (int k = 1; k <= cnt; k++) {
                field = doc.getElementById("jikwe" + k);
                if (field != null) {
                    field.html("&nbsp;");

                    field = doc.getElementById("sign" + k);
                    if (field != null) {
                        field.html("&nbsp;");
                    }
                    field = doc.getElementById("approdept" + k);
                    if (field != null) {
                        field.html("&nbsp;");
                    }
                    field = doc.getElementById("seumyung" + k);
                    if (field != null) {
                        field.html("&nbsp;");
                    }
                }

                field = doc.getElementById("hjkwe" + k);
                if (field != null) {
                    field.html("&nbsp;");
                }
            }
            
            for (int i = paprlines.size() - 1; i >= 0; i--) {
                ApprGAprLineVO paprline = paprlines.get(i);
                String pAprType = paprline.getAprType();
                String pAprJobTitle = "1".equals(lang) ? paprline.getAprMemberJobTitle() : paprline.getAprMemberJobTitle2();
                String pAprDept = "1".equals(lang) ? paprline.getAprMemberDeptName() : paprline.getAprMemberDeptName2();
                String pAprName = "1".equals(lang) ? paprline.getAprMemberName() : paprline.getAprMemberName2();

                switch (pAprType) {
                    case "001":
                    case "003":
                    case "004":
                    case "040":
                        if (LastSignSN == i) {
                            for (int k = 1; k <= cnt; k++) {
                                field = doc.getElementById("sign" + k);
                                if (field != null) {
                                    LastSignNo = k;
                                }
                            }
                            idx = LastSignNo;
                        }

                        if ("4".equals(junGyulFlag)) {
                            if (pAprType == "003") {
                                continue;
                            }
                        }

                        field = doc.getElementById(susinSN + "jikwe" + idx);
                        if (field != null) {
                            field.text(pAprJobTitle);
                        }
                        field = doc.getElementById(susinSN + "approdept" + idx);
                        if (field != null) {
                            field.text(pAprDept);
                        }
                        field = doc.getElementById(susinSN + "seumyung" + idx);
                        if (field != null) {
                            field.text(pAprName);
                        }

                        field = doc.getElementById(susinSN + "sign" + idx);
                        if (field != null) {
                            // 서명필드만 존재하는 경우, 서명+결재자명 필드가 함께 존재하는 경우, 슬래시 이미지의 표출분기 수정
                            if ("1".equals(draftJunGyulFlag) && "004".equals(pAprType)) { // 전결 서명 부여
                                field.html(egovMessageSource.getMessage("ezApproval.t59", locale) + "&nbsp;" +  pAprName);
                            } else if (doc.getElementById(susinSN + "seumyung" + idx) == null) { // 서명필드만 존재
                                field.text(pAprName);
                            } else if (doc.getElementById(susinSN + "seumyung" + idx) != null) { // 서명필드만 존재
                                field.html("[NOSLASH]");
                            }
                            idx = idx + 1; // 서명칸이 존재하는 경우, idx를 1 증가시켜서 다음 칸을 찾는다.
                        }
                        break;
                    case "008": // 개인순차합의
                    case "009": // 개인병렬합의
                        field = doc.getElementById("habyui" + hapyuiCnt);
                        if (field != null) {
                            field.text(pAprDept);
                        }
                        // 합의자명 필드가 존재하지 않는 경우, 합의자 사인 필드에 이름 표출하도록 수정(개인순차합의, 개인병렬합의) 
                        field = doc.getElementById("habyuisign" + hapyuiCnt);
                        if (field != null && doc.getElementById("habyuija" + hapyuiCnt) == null) {
                            field.text(pAprName);
                        }
                        field = doc.getElementById("habyuija" + hapyuiCnt);
                        if (field != null) {
                            field.text(pAprName);
                        }
//						field = doc.getElementById("habyuiaddress" + hapyuiCnt); // 2024-05-31 기준으로 확인 시 양식작성창에 habyuiaddress 필드 추가 UI가 없어 실제로 사용되지는 않고 있음
                        field = doc.getElementById("habyuipositon" + hapyuiCnt);
                        if (field != null) {
                            field.text(pAprJobTitle);
                        }
                        field = doc.getElementById("habyuiapprodept" + hapyuiCnt);
                        if (field != null) {
                            field.text(pAprDept);
                        }
                        hapyuiCnt = hapyuiCnt + 1;
                        break;
                    case "011": // 부서순차합의
                    case "012": // 부서병렬합의
                        field = doc.getElementById("habyui" + hapyuiCnt);
                        if (field != null) {
                            field.text(pAprDept);
                        }
                        field = doc.getElementById("habyuisign" + hapyuiCnt);
                        if (field != null) {
                            field.text(pAprDept);
                        }
                        field = doc.getElementById("habyuija" + hapyuiCnt);
                        if (field != null) {
                            field.text(pAprName);
                        }
//						field = doc.getElementById("habyuiaddress" + hapyuiCnt);
                        field = doc.getElementById("habyuipositon" + hapyuiCnt);
                        if (field != null) {
                            field.text(pAprJobTitle);
                        }
                        field = doc.getElementById("habyuiapprodept" + hapyuiCnt);
                        if (field != null) {
                            field.text(pAprDept);
                        }
                        hapyuiCnt = hapyuiCnt + 1;
                        break;
                    case "007":	// 참조
                        pRefer += pAprName + ",";
                        break;
                }

            }
            if ("Y".equals(optIsSplit)) {
                for (int i = 1; i < 21; i++) {
                    field = doc.getElementById(susinSN + "sign" + i);
                    if (field != null) {
                        String inner = field.html().trim();
                        if (field.text().trim().isEmpty() && (inner.equals("&nbsp;") || inner.equals("") || inner.equals("<br>"))) {
                            String strimg = "<img src='/images/signimgs/200.gif' border=0 embedding='1' ";
                            strimg += " spath = '" + "/images/signimgs/200.gif'";
                            strimg += " width=" + signImageSize.split("/")[0] ;
                            strimg += " height=" + signImageSize.split("/")[1] + " imglock >";
                            field.html(strimg);
                        } else if ("[NOSLASH]".equals(inner.trim())) {
                            field.html(" ");
                        }
                    }
                }
            }

            // 참조
            field = doc.getElementById("refer");
            if (!"".equals(pRefer) && field != null) {
                if (pRefer.endsWith(",")) {
                    pRefer = pRefer.substring(0, pRefer.length() - 1);
                }
                field.text(pRefer);
            }

            // 수신처
            Element fieldRecipient = doc.getElementById("recipient");
            if (fieldRecipient != null) {
                List<ApprGReceiptVO> apprGAprLineVOList = ezApprovalGDAO.getReceiptInfo(map);
                String precipent = "";
                String precipents = "";
                if (apprGAprLineVOList.size() > 1) {
                    precipent = egovMessageSource.getMessage("ezApproval.t128", locale);
                    precipents = apprGAprLineVOList.get(0).getReceiptPointName();
                    for (int i=1; i<apprGAprLineVOList.size(); i++) {
                        precipents += ", " + apprGAprLineVOList.get(i).getReceiptPointName();
                    }
                } else if (apprGAprLineVOList.size() == 1) {
                    precipent = apprGAprLineVOList.get(0).getReceiptPointName();
                    precipents = apprGAprLineVOList.get(0).getReceiptPointName();
                }

                fieldRecipient.text(precipent);
                field = doc.getElementById("recipients");
                if (field != null) {
                    field.text(precipents);
                }

                field = doc.getElementById("hrecipients");
                if (field != null) {
                    if (precipents.isEmpty()) {
                        field.text("");
                    } else {
                        field.text(egovMessageSource.getMessage("ezApproval.t129", locale));
                    }
                }
            }

            // 본문 내용
            String bodyContent = jsonParam.get("content").toString();
            bodyContent = bodyContent.replaceAll("%(?![0-9a-fA-F]{2})", "%25");
            bodyContent = bodyContent.replaceAll("\\+", "%2B");
            bodyContent = URLDecoder.decode(bodyContent, "utf-8");
            if (doc.getElementById("body") != null) {
                doc.getElementById("body").html(bodyContent);
            }

			// 2025-09-10 김유진 - id가 m_ValText, m_ValDate 로 시작하는 필드명에 값 넣기
			NodeList xmlDomFieldList = xmlDomField.getDocumentElement().getChildNodes();
			for (int i = 0; i < xmlDomFieldList.getLength(); i++) {
				field = doc.getElementById(xmlDomFieldList.item(i).getNodeName());
				if (field != null) {
					String val = xmlDomFieldList.item(i).getTextContent();
					val = val.replaceAll("%(?![0-9a-fA-F]{2})", "%25");
					val = val.replaceAll("\\+", "%2B");
					val = URLDecoder.decode(val, "utf-8");
					field.html(val);
				}
			}

			/* 문서 본문 작성 끝 */


            /* 결재 파일 저장 시작 */
            File Folder = new File(realPath + filePath);
            if(!Folder.exists()) {
                Folder.mkdirs();
            }
            String tempHtml = doc.outerHtml();
            OutputStream outputStream = null;
            OutputStreamWriter output = null;
            try {
                convertedMHT = ezCommonService.startHtml2Mht(tempHtml, realPath, userInfo.getLocale());
                outputStream = new FileOutputStream(new File(commonUtil.detectPathTraversal(realPath + href)));
                output = new OutputStreamWriter(outputStream);

                output.write(convertedMHT);
            }  catch (FileNotFoundException fnfe) {
                logger.debug("fnfe: {}", fnfe);
            } catch (IOException ioe) {
                logger.debug("ioe: {}", ioe);
            } catch (Exception e) {
                logger.debug("e: {}", e);
            }  finally{

                if (output != null) {
                    try {
                        output.close();
                    } catch (Exception ignore) {
                        logger.debug("IGNORED: {}", ignore.getMessage());
                    }
                }
                if (outputStream != null) {
                    try {
                        outputStream.close();
                    } catch (Exception ignore) {
                        logger.debug("IGNORED: {}", ignore.getMessage());
                        // return "";
                    }
                }
            }
            /* 결재 파일 저장 끝 */

            // DB 문서정보 업데이트
            String subSQL = updateDocInfo(xmlDom, userInfo.getId(), userInfo.getCompanyID(), lang, userInfo.getTenantId());
            if (!subSQL.toUpperCase().equals("TRUE")) {
                result = "ERROR";
            } else {
                result = "TRUE";
            }
        } catch (Exception e) {
            logger.error(e.getMessage(), e);
            result = "ERROR";
        }
        return result;
    }

    public String updateDocInfo(org.w3c.dom.Document docXML, String userID, String companyID, String lang, int tenantID) throws Exception {
        boolean firstFlag = true;
        logger.debug("updateDocInfo started");
        String docID = docXML.getElementsByTagName("DOCID").item(0).getTextContent();
        String tempValue = "";
        String rtnVal = "TRUE";

        Map<String, Object> map = new HashMap<String, Object>();

        map.put("companyID", companyID);
        map.put("v_DOCID", docID);
        map.put("v_TENANTID", tenantID);

        tempValue = docXML.getElementsByTagName("FORMID").item(0).getTextContent().trim();

        if (!tempValue.equals("")) {
            if (firstFlag) {
                map.put("v_FORMID", tempValue);
                map.put("v_FIRSTFLAG", firstFlag);
                firstFlag = false;
            } else {
                map.put("v_FORMID", tempValue);
                map.put("v_FIRSTFLAG", firstFlag);
            }
        }

        tempValue = docXML.getElementsByTagName("ORGDOCID").item(0).getTextContent().trim();

        if (!tempValue.equals("")) {
            if (firstFlag) {
                map.put("v_ORGDOCID", tempValue);
                map.put("v_FIRSTFLAG2", firstFlag);
                firstFlag = false;
            } else {
                map.put("v_ORGDOCID", tempValue);
                map.put("v_FIRSTFLAG2", firstFlag);
            }
        }

        tempValue = docXML.getElementsByTagName("DOCTYPE").item(0).getTextContent().trim();

        if (!tempValue.equals("")) {
            if (firstFlag) {
                map.put("v_DOCTYPE", tempValue);
                map.put("v_FIRSTFLAG3", firstFlag);
                firstFlag = false;
            } else {
                map.put("v_DOCTYPE", tempValue);
                map.put("v_FIRSTFLAG3", firstFlag);
            }
        }

        tempValue = docXML.getElementsByTagName("DOCSTATE").item(0).getTextContent().trim();

        if (!tempValue.equals("")) {
            if (firstFlag) {
                map.put("v_DOCSTATE", tempValue);
                map.put("v_FIRSTFLAG4", firstFlag);
                firstFlag = false;
            } else {
                map.put("v_DOCSTATE", tempValue);
                map.put("v_FIRSTFLAG4", firstFlag);
            }
        }

        tempValue = docXML.getElementsByTagName("FUNCTIONTYPE").item(0).getTextContent().trim();

        if (!tempValue.equals("")) {
            if (firstFlag) {
                map.put("v_FUNCTIONTYPE", tempValue);
                map.put("v_FIRSTFLAG5", firstFlag);
                firstFlag = false;
            } else {
                map.put("v_FUNCTIONTYPE", tempValue);
                map.put("v_FIRSTFLAG5", firstFlag);
            }
        }

        tempValue = docXML.getElementsByTagName("HREF").item(0).getTextContent().trim();

        if (!tempValue.equals("")) {
            if (firstFlag) {
                map.put("v_HREF", tempValue);
                map.put("v_FIRSTFLAG6", firstFlag);
                firstFlag = false;
            } else {
                map.put("v_HREF", tempValue);
                map.put("v_FIRSTFLAG6", firstFlag);
            }
        }

        tempValue = docXML.getElementsByTagName("DOCTITLE").item(0).getTextContent().trim();

        if (!tempValue.equals("")) {
            if (firstFlag) {
                map.put("v_DOCTITLE", tempValue.replaceAll("(^\\p{Z}+|\\p{Z}+$)", ""));
                map.put("v_FIRSTFLAG7", firstFlag);
                firstFlag = false;
            } else {
                map.put("v_DOCTITLE", tempValue.replaceAll("(^\\p{Z}+|\\p{Z}+$)", ""));
                map.put("v_FIRSTFLAG7", firstFlag);
            }
        }

        tempValue = docXML.getElementsByTagName("DOCNO").item(0).getTextContent().trim();

        if (!tempValue.equals("")) {
            if (firstFlag) {
                map.put("v_DOCNO", tempValue);
                map.put("v_FIRSTFLAG8", firstFlag);
                firstFlag = false;
            } else {
                map.put("v_DOCNO", tempValue);
                map.put("v_FIRSTFLAG8", firstFlag);
            }
        }

        tempValue = docXML.getElementsByTagName("HASATTACHYN").item(0).getTextContent().trim();

        if (!tempValue.equals("")) {
            if (firstFlag) {
                map.put("v_HASATTACHYN", tempValue);
                map.put("v_FIRSTFLAG9", firstFlag);
                firstFlag = false;
            } else {
                map.put("v_HASATTACHYN", tempValue);
                map.put("v_FIRSTFLAG9", firstFlag);
            }
        }

        tempValue = docXML.getElementsByTagName("HASOPINIONYN").item(0).getTextContent().trim();

        if (!tempValue.equals("")) {
            if (firstFlag) {
                map.put("v_HASOPINIONYN", tempValue);
                map.put("v_FIRSTFLAG10", firstFlag);
                firstFlag = false;
            } else {
                map.put("v_HASOPINIONYN", tempValue);
                map.put("v_FIRSTFLAG10", firstFlag);
            }
        }

        tempValue = docXML.getElementsByTagName("STARTDATE").item(0).getTextContent().trim();

        if (tempValue.equals("DRAFT")) {
            if (firstFlag) {
                map.put("v_STARTDATE", commonUtil.getTodayUTCTime(""));
                map.put("v_FIRSTFLAG11", firstFlag);
                firstFlag = false;
            } else {
                map.put("v_STARTDATE", commonUtil.getTodayUTCTime(""));
                map.put("v_FIRSTFLAG11", firstFlag);
            }
        }

        tempValue = docXML.getElementsByTagName("ENDDATE").item(0).getTextContent().trim();

        if (tempValue.equals("DRAFT")) {
            if (firstFlag) {
                map.put("v_ENDDATE", "NULL");
                map.put("v_FIRSTFLAG12", firstFlag);
                firstFlag = false;
            } else {
                map.put("v_ENDDATE", "NULL");
                map.put("v_FIRSTFLAG12", firstFlag);
            }
        }

        tempValue = docXML.getElementsByTagName("WRITERID").item(0).getTextContent().trim();

        if (!tempValue.equals("")) {
            if (firstFlag) {
                map.put("v_WRITERID", tempValue);
                map.put("v_FIRSTFLAG13", firstFlag);
                firstFlag = false;
            } else {
                map.put("v_WRITERID", tempValue);
                map.put("v_FIRSTFLAG13", firstFlag);
            }
        }

        tempValue = docXML.getElementsByTagName("WRITERNAME").item(0).getTextContent().trim();

        if (!tempValue.equals("")) {
            if (firstFlag) {
                map.put("v_WRITERNAME", tempValue);
                map.put("v_FIRSTFLAG14", firstFlag);
                firstFlag = false;
            } else {
                map.put("v_WRITERNAME", tempValue);
                map.put("v_FIRSTFLAG14", firstFlag);
            }
        }

        if (docXML.getElementsByTagName("WRITERNAME2").item(0) != null) {
            tempValue = docXML.getElementsByTagName("WRITERNAME2").item(0).getTextContent().trim();

            if (!tempValue.equals("")) {
                if (firstFlag) {
                    map.put("v_WRITERNAME2", tempValue);
                    map.put("v_FIRSTFLAG15", firstFlag);
                    firstFlag = false;
                } else {
                    map.put("v_WRITERNAME2", tempValue);
                    map.put("v_FIRSTFLAG15", firstFlag);
                }
            }
        }

        tempValue = docXML.getElementsByTagName("WRITERJOBTITLE").item(0).getTextContent().trim();

        if (!tempValue.equals("")) {
            if (firstFlag) {
                map.put("v_WRITERJOBTITLE", tempValue);
                map.put("v_FIRSTFLAG16", firstFlag);
                firstFlag = false;
            } else {
                map.put("v_WRITERJOBTITLE", tempValue);
                map.put("v_FIRSTFLAG16", firstFlag);
            }
        }

        if (docXML.getElementsByTagName("WRITERJOBTITLE2").item(0) != null) {
            tempValue = docXML.getElementsByTagName("WRITERJOBTITLE2").item(0).getTextContent().trim();

            if (!tempValue.equals("")) {
                if (firstFlag) {
                    map.put("v_WRITERJOBTITLE2", tempValue);
                    map.put("v_FIRSTFLAG17", firstFlag);
                    firstFlag = false;
                } else {
                    map.put("v_WRITERJOBTITLE2", tempValue);
                    map.put("v_FIRSTFLAG17", firstFlag);
                }
            }
        }

        tempValue = docXML.getElementsByTagName("WRITERDEPTID").item(0).getTextContent().trim();

        if (!tempValue.equals("")) {
            if (firstFlag) {
                map.put("v_WRITERDEPTID", tempValue);
                map.put("v_FIRSTFLAG18", firstFlag);
                firstFlag = false;
            } else {
                map.put("v_WRITERDEPTID", tempValue);
                map.put("v_FIRSTFLAG18", firstFlag);
            }
        }

        tempValue = docXML.getElementsByTagName("WRITERDEPTNAME").item(0).getTextContent().trim();

        if (!tempValue.equals("")) {
            if (firstFlag) {
                map.put("v_WRITERDEPTNAME", tempValue);
                map.put("v_FIRSTFLAG19", firstFlag);
                firstFlag = false;
            } else {
                map.put("v_WRITERDEPTNAME", tempValue);
                map.put("v_FIRSTFLAG19", firstFlag);
            }
        }

        if (docXML.getElementsByTagName("WRITERDEPTNAME2").item(0) != null) {
            tempValue = docXML.getElementsByTagName("WRITERDEPTNAME2").item(0).getTextContent().trim();

            if (!tempValue.equals("")) {
                if (firstFlag) {
                    map.put("v_WRITERDEPTNAME2", tempValue);
                    map.put("v_FIRSTFLAG20", firstFlag);
                    firstFlag = false;
                } else {
                    map.put("v_WRITERDEPTNAME2", tempValue);
                    map.put("v_FIRSTFLAG20", firstFlag);
                }
            }
        }

        tempValue = docXML.getElementsByTagName("PUBLICATION").item(0).getTextContent().trim();

        if (!tempValue.equals("")) {
            if (firstFlag) {
                map.put("v_ISPUBLIC", tempValue);
                map.put("v_FIRSTFLAG21", firstFlag);
                firstFlag = false;
            } else {
                map.put("v_ISPUBLIC", tempValue);
                map.put("v_FIRSTFLAG21", firstFlag);
            }
        }

        map.put("v_DOCID", docID);
        map.put("v_TENANTID", tenantID);

        ezApprovalGDAO.updateAprDocInfo(map);

        firstFlag = true;

        tempValue = docXML.getElementsByTagName("SECURITY").item(0).getTextContent().trim();

        if (!tempValue.equals("")) {
            if (firstFlag) {
                map.put("v_SECURITYCODE", tempValue);
                map.put("v_FIRSTFLAG", firstFlag);
                firstFlag = false;
            } else {
                map.put("v_SECURITYCODE", tempValue);
                map.put("v_FIRSTFLAG", firstFlag);
            }
        }

        tempValue = docXML.getElementsByTagName("KEEPPERIOD").item(0).getTextContent().trim();

        if (!tempValue.equals("")) {
            if (firstFlag) {
                map.put("v_STORAGEPERIOD", tempValue);
                map.put("v_FIRSTFLAG2", firstFlag);
                firstFlag = false;
            } else {
                map.put("v_STORAGEPERIOD", tempValue);
                map.put("v_FIRSTFLAG2", firstFlag);
            }
        }

        tempValue = docXML.getElementsByTagName("ITEMCODE").item(0).getTextContent().trim();

        if (!tempValue.equals("")) {
            if (firstFlag) {
                map.put("v_ITEMCODE", tempValue);
                map.put("v_FIRSTFLAG3", firstFlag);
                firstFlag = false;
            } else {
                map.put("v_ITEMCODE", tempValue);
                map.put("v_FIRSTFLAG3", firstFlag);
            }
        }

        tempValue = docXML.getElementsByTagName("ITEMNAME").item(0).getTextContent().trim();

        if (!tempValue.equals("")) {
            if (firstFlag) {
                map.put("v_ITEMNAME", tempValue);
                map.put("v_FIRSTFLAG4", firstFlag);
                firstFlag = false;
            } else {
                map.put("v_ITEMNAME", tempValue);
                map.put("v_FIRSTFLAG4", firstFlag);
            }
        }

        if (docXML.getElementsByTagName("ITEMNAME2").item(0) != null) {
            tempValue = docXML.getElementsByTagName("ITEMNAME2").item(0).getTextContent().trim();

            if (!tempValue.equals("")) {
                if (firstFlag) {
                    map.put("v_ITEMNAME2", tempValue);
                    map.put("v_FIRSTFLAG5", firstFlag);
                    firstFlag = false;
                } else {
                    map.put("v_ITEMNAME2", tempValue);
                    map.put("v_FIRSTFLAG5", firstFlag);
                }
            }
        }

        tempValue = docXML.getElementsByTagName("URGENTAPPROVAL").item(0).getTextContent().trim();

        if (!tempValue.equals("")) {
            if (firstFlag) {
                map.put("v_URGENTAPPROVAL", tempValue);
                map.put("v_FIRSTFLAG6", firstFlag);
                firstFlag = false;
            } else {
                map.put("v_URGENTAPPROVAL", tempValue);
                map.put("v_FIRSTFLAG6", firstFlag);
            }
        }

        tempValue = docXML.getElementsByTagName("KEYWORD").item(0).getTextContent().trim();

        if (!tempValue.equals("")) {
            if (firstFlag) {
                map.put("v_KEYWORD", tempValue);
                map.put("v_FIRSTFLAG7", firstFlag);
                firstFlag = false;
            } else {
                map.put("v_KEYWORD", tempValue);
                map.put("v_FIRSTFLAG7", firstFlag);
            }
        }

        if (docXML.getElementsByTagName("SPECIALRECORDCODE").item(0) != null) {
            tempValue = docXML.getElementsByTagName("SPECIALRECORDCODE").item(0).getTextContent().trim();

            if (!tempValue.equals("")) {
                if (firstFlag) {
                    map.put("v_SPECIALRECORDCODE", tempValue);
                    map.put("v_FIRSTFLAG8", firstFlag);
                    firstFlag = false;
                } else {
                    map.put("v_SPECIALRECORDCODE", tempValue);
                    map.put("v_FIRSTFLAG8", firstFlag);
                }
            }
        }

        if (docXML.getElementsByTagName("PUBLICITYCODE").item(0) != null) {
            tempValue = docXML.getElementsByTagName("PUBLICITYCODE").item(0).getTextContent().trim();

            if (!tempValue.equals("")) {
                if (firstFlag) {
                    map.put("v_PUBLICITYCODE", tempValue);
                    map.put("v_FIRSTFLAG9", firstFlag);
                    firstFlag = false;
                } else {
                    map.put("v_PUBLICITYCODE", tempValue);
                    map.put("v_FIRSTFLAG9", firstFlag);
                }
            }
        }

        if (docXML.getElementsByTagName("PUBLICITYYN").item(0) != null) {
            tempValue = docXML.getElementsByTagName("PUBLICITYYN").item(0).getTextContent().trim();

            if (!tempValue.equals("")) {
                if (firstFlag) {
                    map.put("v_PUBLICITYYN", tempValue);
                    map.put("v_FIRSTFLAG19", firstFlag);
                    firstFlag = false;
                } else {
                    map.put("v_PUBLICITYYN", tempValue);
                    map.put("v_FIRSTFLAG19", firstFlag);
                }
            }
        }

        if (docXML.getElementsByTagName("LIMITRANGE").item(0) != null) {
            tempValue = docXML.getElementsByTagName("LIMITRANGE").item(0).getTextContent().trim();

            if (!tempValue.equals("")) {
                if (firstFlag) {
                    map.put("v_LIMITRANGE", tempValue);
                    map.put("v_FIRSTFLAG10", firstFlag);
                    firstFlag = false;
                } else {
                    map.put("v_LIMITRANGE", tempValue);
                    map.put("v_FIRSTFLAG10", firstFlag);
                }
            }
        }

        if (docXML.getElementsByTagName("PAGENUM").item(0) != null) {
            tempValue = docXML.getElementsByTagName("PAGENUM").item(0).getTextContent().trim();

            if (!tempValue.equals("")) {
                if (firstFlag) {
                    map.put("v_PAGENUM", tempValue);
                    map.put("v_FIRSTFLAG11", firstFlag);
                    firstFlag = false;
                } else {
                    map.put("v_PAGENUM", tempValue);
                    map.put("v_FIRSTFLAG11", firstFlag);
                }
            }
        }

        if (docXML.getElementsByTagName("CABINETID").item(0) != null) {
            tempValue = docXML.getElementsByTagName("CABINETID").item(0).getTextContent().trim();

            if (!tempValue.equals("")) {
                if (firstFlag) {
                    map.put("v_CABINETID", tempValue);
                    map.put("v_FIRSTFLAG12", firstFlag);
                    firstFlag = false;
                } else {
                    map.put("v_CABINETID", tempValue);
                    map.put("v_FIRSTFLAG12", firstFlag);
                }
            }
        }

        if (docXML.getElementsByTagName("TASKCODE").item(0) != null) {
            tempValue = docXML.getElementsByTagName("TASKCODE").item(0).getTextContent().trim();

            if (!tempValue.equals("")) {
                if (firstFlag) {
                    map.put("v_TASKCODE", tempValue);
                    map.put("v_FIRSTFLAG13", firstFlag);
                    firstFlag = false;
                } else {
                    map.put("v_TASKCODE", tempValue);
                    map.put("v_FIRSTFLAG13", firstFlag);
                }
            }
        }

        if (docXML.getElementsByTagName("DOCNUMCODE").item(0) != null) {
            tempValue = docXML.getElementsByTagName("DOCNUMCODE").item(0).getTextContent().trim();

            if (!tempValue.equals("")) {
                if (firstFlag) {
                    map.put("v_DOCNUMCODE", tempValue);
                    map.put("v_FIRSTFLAG14", firstFlag);
                    firstFlag = false;
                } else {
                    map.put("v_DOCNUMCODE", tempValue);
                    map.put("v_FIRSTFLAG14", firstFlag);
                }
            }
        }

        if (docXML.getElementsByTagName("ORGDOCNUMCODE").item(0) != null) {
            tempValue = docXML.getElementsByTagName("ORGDOCNUMCODE").item(0).getTextContent().trim();

            if (!tempValue.equals("")) {
                if (firstFlag) {
                    map.put("v_ORGDOCNUMCODE", tempValue);
                    map.put("v_FIRSTFLAG15", firstFlag);
                    firstFlag = false;
                } else {
                    map.put("v_ORGDOCNUMCODE", tempValue);
                    map.put("v_FIRSTFLAG15", firstFlag);
                }
            }
        }

        if (docXML.getElementsByTagName("SEPERATEATTACHXML").item(0) != null) {
            tempValue = docXML.getElementsByTagName("SEPERATEATTACHXML").item(0).getTextContent().trim();

            if (!tempValue.equals("")) {
                if (firstFlag) {
                    map.put("v_SEPERATEATTACHXML", tempValue);
                    map.put("v_FIRSTFLAG16", firstFlag);
                    firstFlag = false;
                } else {
                    map.put("v_SEPERATEATTACHXML", tempValue);
                    map.put("v_FIRSTFLAG16", firstFlag);
                }
            }
        }

        if (docXML.getElementsByTagName("SUMMARY").item(0) != null && docXML.getElementsByTagName("SUMMARYPATH").item(0) != null) {
            tempValue = docXML.getElementsByTagName("SUMMARY").item(0).getTextContent();
            String tempValue2 = docXML.getElementsByTagName("SUMMARYPATH").item(0).getTextContent();
            if (!tempValue.trim().equals("") && !tempValue2.trim().equals("")) {
                if (firstFlag) {
                    map.put("v_SUMMARY", tempValue);
                    map.put("v_SUMMARYPATH", tempValue2);
                    map.put("v_FIRSTFLAG17", firstFlag);
                    firstFlag = false;
                } else {
                    map.put("v_SUMMARY", tempValue);
                    map.put("v_SUMMARYPATH", tempValue2);
                    map.put("v_FIRSTFLAG17", firstFlag);
                }
            }
        }

        if (docXML.getElementsByTagName("SECURITYAPPROVAL").item(0) != null) {
            tempValue = docXML.getElementsByTagName("SECURITYAPPROVAL").item(0).getTextContent().trim();

            if (!tempValue.equals("")) {
                if (firstFlag) {
                    map.put("v_SECURITYAPPROVAL", tempValue);
                    map.put("v_FIRSTFLAG18", firstFlag);
                    firstFlag = false;
                } else {
                    map.put("v_SECURITYAPPROVAL", tempValue);
                    map.put("v_FIRSTFLAG18", firstFlag);
                }
            }
        }

        map.put("v_DOCID", docID);
        map.put("v_TENANTID", tenantID);

        ezApprovalGDAO.updateExpAprDocInfo(map);

        if (docXML.getElementsByTagName("STARTDATE").item(0).getTextContent().trim().equals("DRAFT")) {
            insLastAprLine(docID, docXML.getElementsByTagName("FORMID").item(0).getTextContent().trim(), docXML.getElementsByTagName("DOCSTATE").item(0).getTextContent().trim(), userID, companyID, lang, tenantID);
            insLastAprReceipt(docID, docXML.getElementsByTagName("FORMID").item(0).getTextContent().trim(), docXML.getElementsByTagName("DOCSTATE").item(0).getTextContent().trim(), userID, companyID, lang, tenantID);
        }

        logger.debug("updateDocInfo ended");

        return rtnVal;
    }

    public void insLastAprLine(String docID, String formID, String docState, String userID, String companyID, String lang, int tenantID) throws Exception {
        logger.debug("insLastAprLine started");

        String isUse = ezApprovalGService.getCode2Name("A44", "001", companyID, lang, tenantID);

        if (isUse.equals("1")) {
            Map<String, Object> map = new HashMap<String, Object>();
            map.put("v_USERID", userID);
            map.put("v_FORMID", formID);
            map.put("v_DOCID", docID);
            map.put("companyID", companyID);
            map.put("v_TENANTID", tenantID);
            map.put("docState", docState);

            /* 2020-08-04 홍승비 - 신규 양식 생성하여 처음 결재선 지정하고 기안하는 경우, 오라클에서 DOCSTATE값 NULL로 들어가서 터지는 오류 수정 */
            if ((commonUtil.getDatabaseType().equalsIgnoreCase("oracle") || commonUtil.getDatabaseType().equalsIgnoreCase("tibero")) && (docState == null || docState.trim().equals(""))) {
                map.put("docState", " "); // 임의로 공백문자 삽입
            }

            ezApprovalGDAO.deleteLastAprLine(map);
            ezApprovalGDAO.insertLastAprLine(map);
        }

        logger.debug("insLastAprLine ended");
    }

    public void insLastAprReceipt(String docID, String formID, String docState, String userID, String companyID, String lang, int tenantID) throws Exception {
        logger.debug("insLastAprReceipt started");

        String isUse = ezApprovalGService.getCode2Name("A44", "002", companyID, lang, tenantID);

        if (isUse.equals("1")) {
            Map<String, Object> map = new HashMap<String, Object>();
            map.put("companyID", companyID);
            map.put("v_USERID", userID);
            map.put("v_FORMID", formID);
            map.put("v_DOCID", docID);
            map.put("v_TENANTID", tenantID);
            map.put("docState", docState);

            ezApprovalGDAO.deleteLastDeptLine(map);
            ezApprovalGDAO.insertLastDeptLine(map);
        }

        logger.debug("insLastAprReceipt ended");
    }
}
