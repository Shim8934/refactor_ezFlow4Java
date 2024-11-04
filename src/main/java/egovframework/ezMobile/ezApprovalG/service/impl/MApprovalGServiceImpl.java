package egovframework.ezMobile.ezApprovalG.service.impl;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezApprovalG.dao.EzApprovalGDAO;
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGService;
import egovframework.ezEKP.ezApprovalG.vo.ApprGListHeaderVO;
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

import java.io.File;
import java.io.FileOutputStream;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.UnsupportedEncodingException;
import java.util.*;

@Service("MApprovalGService")
public class MApprovalGServiceImpl extends EgovAbstractServiceImpl implements MApprovalGService {
	private static final Logger logger = LoggerFactory.getLogger(MApprovalGServiceImpl.class);
	
	@Autowired
	private CommonUtil commonUtil;

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
							contentBuilder.append("&allFlag=0&mailchk=Y&orgCompanyID=" + ezOrganService.getPropertyValue(targetUserId, "physicaldeliveryofficename", tenantId));
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
}
