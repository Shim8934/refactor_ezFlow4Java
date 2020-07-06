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
import egovframework.ezMobile.ezApprovalG.dao.MApprovalGDAO;
import egovframework.ezMobile.ezApprovalG.service.MApprovalGService;
import egovframework.ezMobile.ezApprovalG.vo.*;
import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.ezMobile.ezOption.vo.MOptionVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.jsoup.Jsoup;
import org.jsoup.select.Elements;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import javax.mail.internet.InternetAddress;
import java.io.File;
import java.io.FileOutputStream;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.util.*;
import java.util.stream.Collectors;

@Service("MApprovalGService")
public class MApprovalGServiceImpl extends EgovAbstractServiceImpl implements MApprovalGService {
	private static final Logger LOGGER = LoggerFactory.getLogger(MApprovalGServiceImpl.class);
	
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
		LOGGER.debug("getDoApproveList started");

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
		map.put("id", userIDS);
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

		LOGGER.debug("getDoApproveList ended");
		
		return approvalGDocInfoVOs;
	}

	@Override
	public int getDoApproveListCount(MCommonVO userInfo, String type, String searchText) throws Exception {
		LOGGER.debug("getDoApproveListCount started");

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
		map.put("id", userIDS);
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
		
		LOGGER.debug("getDoApproveListCount ended");
		
		return listCount;
	}

	@Override
	public List<MApprovalGAprLineInfoVO> getAprLineInfo(String pDocID, String type, MCommonVO userInfo) throws Exception {
		LOGGER.debug("getAprLineInfo started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("docID", pDocID);
		map.put("type", type);
		map.put("lang", commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()));
		map.put("offset", commonUtil.getMinuteUTC(userInfo.getOffSet()));
		map.put("tenantID", userInfo.getTenantId());
		map.put("companyID", userInfo.getCompanyId());
		
		List<MApprovalGAprLineInfoVO> approvalGAprLineInfoVOs = mApprovalGDAO.getAprLineInfo(map);

		LOGGER.debug("getAprLineInfo ended");
		
		return approvalGAprLineInfoVOs;
	}

	@Override
	public String getMHTBody(String pDocID, String realPath, String domain, MCommonVO userInfo, Locale locale, String type, String scheme, String mode) throws Exception {
		LOGGER.debug("getMHTBody started");

		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("docID", pDocID);
		map.put("type", type);
		map.put("mode", mode);
		map.put("approvalFlag", approvalFlag);
		map.put("tenantID", userInfo.getTenantId());
		map.put("companyID", userInfo.getCompanyId());
		
		String docHref = mApprovalGDAO.getAprDocHref(map);
		LOGGER.debug("docHref : " + docHref);
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
			e.printStackTrace();
			m_strMHT= "";
		}
        
        String strHTML = ezCommonService.startMHT2HTML(filePath, m_strMHT, filePath, realPath, locale, domain, scheme);
        LOGGER.debug("strHTML : " + strHTML);

		LOGGER.debug("getMHTBody ended");
		
		return strHTML;
	}

	@Override
	public String getOpinionCount(String pDocID, String type, MCommonVO userInfo) throws Exception {
		LOGGER.debug("getAprCommentCount started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("docID", pDocID);
		map.put("type", type);
		map.put("tenantID", userInfo.getTenantId());
		map.put("companyID", userInfo.getCompanyId());
		
		String commentCount = mApprovalGDAO.getAprCommentCount(map);

		LOGGER.debug("getAprCommentCount ended");
		
		return commentCount;
	}

	@Override
	public List<MApprovalGOpinionInfoVO> getOpinionInfo(String pDocID, String type, MCommonVO userInfo) throws Exception {
		LOGGER.debug("getOpinionInfo started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("docID", pDocID);
		map.put("type", type);
		map.put("lang", commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()));
		map.put("tenantID", userInfo.getTenantId());
		map.put("companyID", userInfo.getCompanyId());
		
		List<MApprovalGOpinionInfoVO> approvalGOpinionInfoVOs = mApprovalGDAO.getOpinionInfo(map);
		
		LOGGER.debug("getOpinionInfo ended");
		
		return approvalGOpinionInfoVOs;
	}

	@Override
	public int mSetOpinionInfo(String pDocID, String pContent, String pOpinionGB, MCommonVO userInfo, String pType) throws Exception {
		LOGGER.debug("saveOpinionInfo started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("docID", pDocID);
		map.put("content", pContent);
		map.put("opinionGB", pOpinionGB);
		map.put("userID", userInfo.getUserId());
		map.put("tenantID", userInfo.getTenantId());
		map.put("companyID", userInfo.getCompanyId());
		
		int result = 0;
		int resultRow = mApprovalGDAO.deleteOpinionInfo(map);
		
		if (pType.equals("INSERT")) {
			if (pContent != null && !pContent.equals("")) {
				map.put("hasOpinionYN", "Y");
				
				mApprovalGDAO.insertOpinionInfo(map);
				
				result = mApprovalGDAO.updateDocOpinionInfo(map);
			} else {
				map.put("hasOpinionYN", "N");
				
				result = mApprovalGDAO.updateDocOpinionInfo(map);
			}
		} else if (pType.equals("UPDATE")) {
			if (resultRow > 0) {
				if (pContent != null && !pContent.equals("")) {
					map.put("hasOpinionYN", "Y");
					
					mApprovalGDAO.insertOpinionInfo(map);
					
					result = mApprovalGDAO.updateDocOpinionInfo(map);
				} else {
					map.put("hasOpinionYN", "N");
					
					result = mApprovalGDAO.updateDocOpinionInfo(map);
				}
			}
		} else if (pType.equals("DELETE")) {
			if (resultRow > 0) {
				map.put("hasOpinionYN", "N");
				
				result = mApprovalGDAO.updateDocOpinionInfo(map);
			}
		}

		LOGGER.debug("saveOpinionInfo ended");
		
		return result;
	}

	@Override
	public List<MApprovalGAttachInfoVO> getAttachList(String docId, String type, MCommonVO userInfo) throws Exception {
		LOGGER.debug("getAttachList started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("docID", docId);
		map.put("type", type);
		map.put("tenantID", userInfo.getTenantId());
		map.put("companyID", userInfo.getCompanyId());
		
		List<MApprovalGAttachInfoVO> approvalGAttachInfoVOs = mApprovalGDAO.getAttachList(map);

		LOGGER.debug("getAttachList ended");
		
		return approvalGAttachInfoVOs;
	}
	
	@Override
	public MApprovalGAbsenteeInfoVO getAbsenteeInfo(MCommonVO userInfo) throws Exception {
		LOGGER.debug("getAbsenteeInfo started");

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

		LOGGER.debug("getAbsenteeInfo ended");
		
		return absenteeInfoVO;
	}

	@Override
	public int setAbsenteeInfo(MApprovalGAbsenteeInfoVO absenteeInfoVO) throws Exception {
		LOGGER.debug("setAbsenteeInfo started");

		int result = mApprovalGDAO.setAbsenteeInfo(absenteeInfoVO);

		LOGGER.debug("setAbsenteeInfo ended");
		
		return result;
	}

	@Override
	public int checkPass(MCommonVO userInfo, String shaEncPassword) throws Exception {
		LOGGER.debug("checkPass started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("password", shaEncPassword);
		map.put("userID", userInfo.getUserId());
		map.put("tenantID", userInfo.getTenantId());
		
		int resultCode = mApprovalGDAO.checkPass(map);

		LOGGER.debug("checkPass ended");
		
		return resultCode;
	}

	@Override
	public MApprovalGDocInfoVO getAprDocInfo(String docId, String type, String lang, String offset, String companyId, int tenantId, String aprMemberSN, String mode) throws Exception {
		LOGGER.debug("getAprDocInfo started");

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

		LOGGER.debug("getAprDocInfo ended");
		
		return approvalGDocInfoVO;
	}
	
	@Override
	public MApprovalGDocInfoVO getAprMemberSn(String docId, String type, String companyId, int tenantId) throws Exception {
		LOGGER.debug("getAprDocInfo started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("docID", docId);
		map.put("type", type);
		map.put("tenantID", tenantId);
		map.put("companyID", companyId);
		
		MApprovalGDocInfoVO approvalGDocInfoVO = new MApprovalGDocInfoVO();
		
		approvalGDocInfoVO = mApprovalGDAO.getAprMemberSn(map);

		LOGGER.debug("getAprDocInfo ended");
		
		return approvalGDocInfoVO;
	}

	@Override
	public String getDocState(String docId, String companyId, int tenantId) throws Exception {
		LOGGER.debug("getDocState started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("docID", docId);
		map.put("tenantID", tenantId);
		map.put("companyID", companyId);
		
		String docState = mApprovalGDAO.getDocState(map);

		LOGGER.debug("getDocState ended");
		
		return docState;
	}

	@Override
	public MApprovalGLeftVO getLeftCount(String userId, MCommonVO userInfo) throws Exception {
		LOGGER.debug("getLeftCount started");
		
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
		map.put("id", userIDS);
		map.put("userId", userId);
		map.put("tenantID", userInfo.getTenantId());
		map.put("companyID", userInfo.getCompanyId());
		map.put("approvalFlag", approvalFlag);
		map.put("mainViewYN", mainViewYN);
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		map.put("useShareApproval", useShareApproval);
		
		MApprovalGLeftVO approvalGLeftVO = mApprovalGDAO.getLeftCount(map);

		LOGGER.debug("getLeftCount ended");
		
		return approvalGLeftVO;
	}

	@Override
	public int delAbsenteeInfo(String userId, int tenantId) throws Exception {
		LOGGER.debug("delAbsenteeInfo started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("tenantID", tenantId);
		
		int result = mApprovalGDAO.delAbsenteeInfo(map);

		LOGGER.debug("delAbsenteeInfo ended");
		
		return result;
	}

	@Override
	public int getCheckAprState(String docId, String userId,
			String aprMemberSN, String mode, String companyId, int tenantId)
			throws Exception {
		LOGGER.debug("getCheckAprState started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("docId", docId);
		map.put("userId", userId);
		map.put("aprMemberSN", aprMemberSN);
		map.put("mode", mode);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		int result = mApprovalGDAO.getCheckAprState(map);
		
		LOGGER.debug("getCheckAprState ended.");
		
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
		LOGGER.debug("sendApproveNoticeMail started.");

		String subject = null;
		StringBuilder contentBuilder = null;

		String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
		String userEmail = userInfo.getUserId() + "@" + domainName;
		String password = jspw;

		//to User
		String targetUserId = null;
		String targetUserName = null;
		List<InternetAddress> toList = new ArrayList<>();
		Locale locale = new Locale(commonUtil.getTwoLetterLangFromLangNum(userInfo.getLang()));

		//from User
		String userId = userInfo.getUserId();
		String userName = userInfo.getUserName();
		String lang = userInfo.getLang();
		String companyId = userInfo.getCompanyId();
		int tenantId = userInfo.getTenantId();

		LOGGER.debug("docId = " + docId + ", type = " + type + ", userId = " + userId);

		InternetAddress from = new InternetAddress();
		from.setAddress(userInfo.getEmail());
		from.setPersonal(userName, "UTF-8");

		InternetAddress to;

		boolean saveSendBoxFlag = ("Y".equals(commonUtil.convertStringToDocument(ezPersonalService.getApprovNotiConfig(userId, userId, tenantId)).getElementsByTagName("SAVEMAILFLAG").item(0).getTextContent().trim())) ? true : false;

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
						targetUserName = targetVo.getAprMemberName();

						if ("0".equals(commonUtil.convertStringToDocument(ezPersonalService.getApprovNotiConfig(targetUserId, userId, tenantId)).getElementsByTagName("COMPLETE").item(0).getTextContent().trim())) {
							return;
						}

						LOGGER.debug("END REC : targetUserId = " + targetUserId + ", targetUserName = " + targetUserName);

						to = new InternetAddress();

						to.setAddress(ezOrganService.getPropertyValue(targetUserId, "mail", tenantId));
						to.setPersonal(targetUserName, "UTF-8");

						toList.add(to);

						subject = egovMessageSource.getMessage("ezEmail.csj07", locale) + " " + approvalGDocInfoVO.getDocTitle(); //[수신부서결재완료알림] + DOCTITLE
						contentBuilder = new StringBuilder("<table width='750' cellpadding='0' cellspacing='0' border='0' ><tr align='left'><td>");
						contentBuilder.append("<span style='font-size:13pt;'>" + egovMessageSource.getMessage("ezEmail.csj17", locale) + ": " + approvalGDocInfoVO.getDocTitle() + "</span><br>");
						contentBuilder.append("<span style='font-size:13pt;'>" + egovMessageSource.getMessage("ezEmail.csj18", locale) + ": " + approvalGDocInfoVO.getWriterName() + "</span><br>");
						contentBuilder.append("<span style='font-size:13pt;'>" + egovMessageSource.getMessage("ezEmail.csj19", locale) + ": " + approvalGDocInfoVO.getStartDate() + "</span><br>");
						contentBuilder.append("</td></tr></table>");

						ezEmailService.sendMail(userEmail, password, locale, from, toList.toArray(new InternetAddress[toList.size()]), null, null, subject, commonUtil.createNotiMailContent(contentBuilder.toString(), tenantId, locale), saveSendBoxFlag, EmailImportance.NORMAL);
					} else {
						approvalGAprLineInfoVOs = getAprLineInfo(docId, "END", userInfo);

						MApprovalGAprLineInfoVO targetVo = approvalGAprLineInfoVOs.get(approvalGAprLineInfoVOs.size() - 1);
						targetUserId = targetVo.getAprMemberId();
						targetUserName = targetVo.getAprMemberName();

						if ("0".equals(commonUtil.convertStringToDocument(ezPersonalService.getApprovNotiConfig(targetUserId, userId, tenantId)).getElementsByTagName("COMPLETE").item(0).getTextContent().trim())) {
							return;
						}

						LOGGER.debug("END : targetUserId = " + targetUserId + ", targetUserName = " + targetUserName);

						to = new InternetAddress();

						to.setAddress(ezOrganService.getPropertyValue(targetUserId, "mail", tenantId));
						to.setPersonal(targetUserName, "UTF-8");

						toList.add(to);

						subject = egovMessageSource.getMessage("ezEmail.csj06", locale) + " " + approvalGDocInfoVO.getDocTitle(); //[결재완료알림] + DOCTITLE
						contentBuilder = new StringBuilder("<table width='750' cellpadding='0' cellspacing='0' border='0' ><tr align='left'><td>");
						contentBuilder.append("<span style='font-size:13pt;'>" + egovMessageSource.getMessage("ezEmail.csj17", locale) + ": " + approvalGDocInfoVO.getDocTitle() + "</span><br>");
						contentBuilder.append("<span style='font-size:13pt;'>" + egovMessageSource.getMessage("ezEmail.csj18", locale) + ": " + approvalGDocInfoVO.getWriterName() + "</span><br>");
						contentBuilder.append("<span style='font-size:13pt;'>" + egovMessageSource.getMessage("ezEmail.csj19", locale) + ": " + approvalGDocInfoVO.getStartDate() + "</span><br>");
						contentBuilder.append("</td></tr></table>");
						ezEmailService.sendMail(userEmail, password, locale, from, toList.toArray(new InternetAddress[toList.size()]), null, null, subject, commonUtil.createNotiMailContent(contentBuilder.toString(), tenantId, locale), saveSendBoxFlag, EmailImportance.NORMAL);
					}

					//[수신문서도착알림]
					List<MApprovalGReceiptInfoVO> receiptInfos = getEndReceiptInfos(docId, companyId, tenantId);

					if (!receiptInfos.isEmpty()) {
						toList = new ArrayList<>();

						subject = egovMessageSource.getMessage("ezEmail.csj02", locale) + " " + approvalGDocInfoVO.getDocTitle(); //[수신문서도착알림] + DOCTITLE
						contentBuilder = new StringBuilder("<table width='750' cellpadding='0' cellspacing='0' border='0' ><tr align='left'><td>");
						contentBuilder.append("<span style='font-size:13pt;'>" + egovMessageSource.getMessage("ezEmail.csj17", locale) + ": " + approvalGDocInfoVO.getDocTitle() + "</span><br>");
						contentBuilder.append("<span style='font-size:13pt;'>" + egovMessageSource.getMessage("ezEmail.csj18", locale) + ": " + approvalGDocInfoVO.getWriterName() + "</span><br>");
						contentBuilder.append("<span style='font-size:13pt;'>" + egovMessageSource.getMessage("ezEmail.csj19", locale) + ": " + approvalGDocInfoVO.getStartDate() + "</span><br>");
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
								LOGGER.debug("REC dept : targetUserId = " + info.getUserId() + ", targetUserName = " + info.getUserName());

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
								LOGGER.debug("REC user : targetUserId = " + info.getUserName() + ", targetUserName = " + info.getUserName());

								to = new InternetAddress();

								to.setAddress(info.getEmail());
								to.setPersonal(info.getUserName(), "UTF-8");

								toList.add(to);
							}
						}

						toList = toList.stream().distinct().collect(Collectors.toList());

						ezEmailService.sendMail(userEmail, password, locale, from, toList.toArray(new InternetAddress[toList.size()]), null, null, subject, commonUtil.createNotiMailContent(contentBuilder.toString(), tenantId, locale), saveSendBoxFlag, EmailImportance.NORMAL);
					}
				} else { //apr
					for (MApprovalGAprLineInfoVO vo : approvalGAprLineInfoVOs) {
						targetUserId = vo.getAprMemberId();
						targetUserName = vo.getAprMemberName();

						if (!"002".equals(vo.getAprState()) || "0".equals(commonUtil.convertStringToDocument(ezPersonalService.getApprovNotiConfig(vo.getAprMemberId(), userId, tenantId)).getElementsByTagName("ALERT").item(0).getTextContent().trim()) || !"007".equalsIgnoreCase(vo.getAprType())) {
							continue;
						}

						LOGGER.debug("APR NEXT : targetUserId = " + targetUserId + ", targetUserName = " + targetUserName);

						to = new InternetAddress();

						to.setAddress(ezOrganService.getPropertyValue(targetUserId, "mail", tenantId));
						to.setPersonal(targetUserName, "UTF-8");

						toList.add(to);

						subject = egovMessageSource.getMessage("ezEmail.csj12", locale) + " " + approvalGDocInfoVO.getDocTitle(); //[수신문서결재완료알림]
						contentBuilder = new StringBuilder("<table width='750' cellpadding='0' cellspacing='0' border='0' ><tr align='left'><td>");
						contentBuilder.append("<span style='font-size:13pt; font-weight:bold;'>" + approvalGDocInfoVO.getWriterName() + "</span>");
						contentBuilder.append("<span style='font-size:13pt;'>" + egovMessageSource.getMessage("ezEmail.csj14", locale) + "</span>");
						contentBuilder.append("<a id='approv_a' docID=" + approvalGDocInfoVO.getDocID());
						contentBuilder.append("&id=" + targetUserId + "&name=" + targetUserName + "&deptID=" + ezOrganService.getPropertyValue(targetUserId, "department", tenantId));
						contentBuilder.append("&allFlag=0&mailchk=Y&orgCompanyID=" + ezOrganService.getPropertyValue(targetUserId, "physicaldeliveryofficename", tenantId));
						contentBuilder.append("' onclick ='javascript:mail_link();' style='cursor: pointer; font-size: 15px; color: blue;' target='_blank'><br>");
						contentBuilder.append(egovMessageSource.getMessage("ezEmail.csj15", locale)); //결재 문서 바로가기 링크
						contentBuilder.append("</a><br><br>");
						contentBuilder.append("<span style='font-size:13pt; font-weight:bold;'>" + egovMessageSource.getMessage("ezEmail.csj16", locale) + "</span><br>");
						contentBuilder.append("<span style='font-size:13pt;'>" + egovMessageSource.getMessage("ezEmail.csj17", locale) + ": " + approvalGDocInfoVO.getDocTitle() + "</span><br>");
						contentBuilder.append("<span style='font-size:13pt;'>" + egovMessageSource.getMessage("ezEmail.csj18", locale) + ": " + approvalGDocInfoVO.getWriterName() + "</span><br>");
						contentBuilder.append("<span style='font-size:13pt;'>" + egovMessageSource.getMessage("ezEmail.csj19", locale) + ": " + approvalGDocInfoVO.getStartDate() + "</span><br>");
						contentBuilder.append("</td></tr></table>");

						ezEmailService.sendMail(userEmail, password, locale, from, toList.toArray(new InternetAddress[toList.size()]), null, null, subject, commonUtil.createNotiMailContent(contentBuilder.toString(), tenantId, locale), saveSendBoxFlag, EmailImportance.NORMAL);
					}
				}

				break;

			case "BAN" :
				MApprovalGAprLineInfoVO targetVo = approvalGAprLineInfoVOs.get(approvalGAprLineInfoVOs.size() - 1);
				targetUserId = targetVo.getAprMemberId();
				targetUserName = targetVo.getAprMemberName();

				if ("0".equals(commonUtil.convertStringToDocument(ezPersonalService.getApprovNotiConfig(targetUserId, userId, tenantId)).getElementsByTagName("BANSONG").item(0).getTextContent().trim())) {
					return;
				}

				LOGGER.debug("BAN : targetUserId = " + targetUserId + ", targetUserName = " + targetUserName);

				to = new InternetAddress();

				to.setAddress(ezOrganService.getPropertyValue(targetUserId, "mail", tenantId));
				to.setPersonal(targetUserName, "UTF-8");

				toList.add(to);

				subject = egovMessageSource.getMessage("ezEmail.csj04", locale) + " " + approvalGDocInfoVO.getDocTitle(); //[기안문서 반송알림]
				contentBuilder = new StringBuilder("<table width='750' cellpadding='0' cellspacing='0' border='0' ><tr align='left'><td>");
				contentBuilder.append("<span style='font-size:13pt;'>" + egovMessageSource.getMessage("ezEmail.csj17", locale) + ": " + approvalGDocInfoVO.getDocTitle() + "</span><br>");
				contentBuilder.append("<span style='font-size:13pt;'>" + egovMessageSource.getMessage("ezEmail.csj18", locale) + ": " + approvalGDocInfoVO.getWriterName() + "</span><br>");
				contentBuilder.append("<span style='font-size:13pt;'>" + egovMessageSource.getMessage("ezEmail.csj19", locale) + ": " + approvalGDocInfoVO.getStartDate() + "</span><br>");

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
				ezEmailService.sendMail(userEmail, password, locale, from, toList.toArray(new InternetAddress[toList.size()]), null, null, subject, commonUtil.createNotiMailContent(contentBuilder.toString(), tenantId, locale), saveSendBoxFlag, EmailImportance.NORMAL);

				break;

			case "HWE" :
				for (MApprovalGAprLineInfoVO vo : approvalGAprLineInfoVOs) {
					targetUserId = vo.getAprMemberId();
					targetUserName = vo.getAprMemberName();

					if (!"002".equals(vo.getAprState()) && !"003".equals(vo.getAprState()) || "0".equals(commonUtil.convertStringToDocument(ezPersonalService.getApprovNotiConfig(vo.getAprMemberId(), userId, tenantId)).getElementsByTagName("CALLBACK").item(0).getTextContent().trim()) || (approvalGAprLineInfoVOs.indexOf(vo) == approvalGAprLineInfoVOs.size())) {
						continue;
					}

					LOGGER.debug("HWE : targetUserId = " + targetUserId + ", targetUserName = " + targetUserName);

					to = new InternetAddress();

					to.setAddress(ezOrganService.getPropertyValue(targetUserId, "mail", tenantId));
					to.setPersonal(targetUserName, "UTF-8");

					toList.add(to);

					subject = egovMessageSource.getMessage("ezEmail.csj01", locale) + " " + approvalGDocInfoVO.getDocTitle(); //[결재문서회수알림]
					contentBuilder = new StringBuilder("<table width='750' cellpadding='0' cellspacing='0' border='0' ><tr align='left'><td>");
					contentBuilder.append("<span style='font-size:13pt;'>" + egovMessageSource.getMessage("ezEmail.csj17", locale) + ": " + approvalGDocInfoVO.getDocTitle() + "</span><br>");
					contentBuilder.append("<span style='font-size:13pt;'>" + egovMessageSource.getMessage("ezEmail.csj18", locale) + ": " + approvalGDocInfoVO.getWriterName() + "</span><br>");
					contentBuilder.append("<span style='font-size:13pt;'>" + egovMessageSource.getMessage("ezEmail.csj19", locale) + ": " + approvalGDocInfoVO.getStartDate() + "</span><br>");
					contentBuilder.append("</td></tr></table>");

					ezEmailService.sendMail(userEmail, password, locale, from, toList.toArray(new InternetAddress[toList.size()]), null, null, subject, commonUtil.createNotiMailContent(contentBuilder.toString(), tenantId, locale), saveSendBoxFlag, EmailImportance.NORMAL);
				}

				break;

			default:
				break;
		}

		LOGGER.debug("sendApproveNoticeMail ended.");
	}

	public List<MApprovalGReceiptInfoVO> getEndReceiptInfos(String docId, String companyId, int tenantId) throws Exception {
		LOGGER.debug("getEndReceiptInfos started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("docId", docId);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);

		List<MApprovalGReceiptInfoVO> receiptInfos = mApprovalGDAO.getEndReceiptInfos(map);

		LOGGER.debug("getEndReceiptInfos ended");

		return receiptInfos;
	}
	
	/* 2020-07-02 홍승비 - 모바일에서 최종결재 완료 시 서명에 결재날짜 삽입 동작 추가(결재날짜 필드가 없는 경우에만, 웹과 동일하게) */
	public String insertSeumyungdateMobile(String docId, String realPath, String offset, Locale locale, String domain, String scheme, String companyId, int tenantId) throws Exception {
		LOGGER.debug("insertSeumyungdateMobile started");

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
				LOGGER.debug("docHref in insertSeumyungdateMobile : " + docHref);
				
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
					e.printStackTrace();
					m_strMHT= "";
				}
		        
		        String strHTML = ezCommonService.startMHT2HTML(filePath, m_strMHT, filePath, realPath, locale, domain, scheme);
		        org.jsoup.nodes.Document doc = Jsoup.parse(strHTML); // 셀렉터를 사용하기 위한 파싱
				
		        Elements signField = doc.select("[id^='sign']");
				Elements seumyungDateField = doc.select("[id^='seumyungdate" + signField.size() + "']"); // 최종결재자의 결재날짜
				
				// 모바일 결재 시 디폴트가 문자서명이므로, 이미지 서명 분기는 생략
				if (seumyungDateField.size() == 0) {
					String orgSignHtml = signField.get(signField.size() - 1).html();
					String newSignHtml = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime("yyyy/MM/dd"), offset, false).substring(5,10) + "<br>" + orgSignHtml;
					LOGGER.debug("newSignHtml   ::   " + newSignHtml);
					
					signField.get(signField.size() - 1).html(newSignHtml);
					
					// 수정한 결재문서 html을 다시 mht로 저장한다.
					OutputStream outputStream = null;
	        		OutputStreamWriter output = null;
					String tempHtml = doc.outerHtml();
	        		String convertedMHT = ezCommonService.startHtml2Mht(tempHtml, realPath, locale);
	        		
	        		try {
	        			outputStream = new FileOutputStream(new File(commonUtil.detectPathTraversal(realPath + docHref)));
	        			output = new OutputStreamWriter(outputStream);
	        			output.write(convertedMHT);
	        		} catch (Exception e) {
	        			e.printStackTrace();
	        		} finally {
	        			output.close();
	        			outputStream.close();
	        		}
				}
			} else { // 아직 결재 진행중인 경우, 바로 리턴시킨다. 에러는 아니다.
				LOGGER.debug("insertSeumyungdateMobile ended(Not End Apr)");
				return result;
			}
		} catch (Exception e) {
			e.printStackTrace();
			result = "ERROR";
			
			LOGGER.debug("insertSeumyungdateMobile ended(ERROR)");
			return result;
		}
		
		LOGGER.debug("insertSeumyungdateMobile ended");
		return result;
	}
}
