package egovframework.ezEKP.ezEmail.service.impl;

import java.io.File;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.security.PrivateKey;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Optional;
import java.util.Properties;
import java.util.Set;
import java.util.TimeZone;
import java.util.UUID;
import java.util.stream.Collectors;

import javax.annotation.Resource;
import javax.mail.Flags;
import javax.mail.Folder;
import javax.mail.Message;
import javax.mail.Message.RecipientType;
import javax.mail.MessagingException;
import javax.mail.Transport;
import javax.mail.UIDFolder;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;

import egovframework.ezEKP.ezEmail.vo.MailboxProgressVO;
import egovframework.let.utl.fcc.service.KlibUtil;
import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.codec.binary.Base64;
import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.jsoup.Jsoup;
import org.jsoup.select.Elements;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.w3c.dom.Document;
import org.w3c.dom.NodeList;

import com.nimbusds.openid.connect.sdk.claims.UserInfo;
import com.sun.mail.imap.IMAPFolder;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.dao.EzEmailDAO;
import egovframework.ezEKP.ezEmail.logic.IMAPAccess;
import egovframework.ezEKP.ezEmail.logic.SMTPAccess;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezEmail.util.EmailImportance;
import egovframework.ezEKP.ezEmail.util.EzEmailUtil;
import egovframework.ezEKP.ezEmail.vo.MailBlobVO;
import egovframework.ezEKP.ezEmail.vo.MailCancelVO;
import egovframework.ezEKP.ezEmail.vo.MailColorVO;
import egovframework.ezEKP.ezEmail.vo.MailDeleteVO;
import egovframework.ezEKP.ezEmail.vo.MailDeletedIdVO;
import egovframework.ezEKP.ezEmail.vo.MailDistributionVO;
import egovframework.ezEKP.ezEmail.vo.MailGeneralVO;
import egovframework.ezEKP.ezEmail.vo.MailPOP3VO;
import egovframework.ezEKP.ezEmail.vo.MailReadVO;
import egovframework.ezEKP.ezEmail.vo.MailReservationVO;
import egovframework.ezEKP.ezEmail.vo.MailSecureReaderVO;
import egovframework.ezEKP.ezEmail.vo.MailSecureVO;
import egovframework.ezEKP.ezEmail.vo.MailSharedMailboxUserVO;
import egovframework.ezEKP.ezEmail.vo.MailSharedMailboxVO;
import egovframework.ezEKP.ezEmail.vo.MailSignatureTemplateVO;
import egovframework.ezEKP.ezEmail.vo.MailSignatureVO;
import egovframework.ezEKP.ezOrgan.dao.EzOrganAdminDAO;
import egovframework.ezEKP.ezOrgan.dao.EzOrganDAO;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

@Service("EzEmailService")
public class EzEmailServiceImpl extends EgovAbstractServiceImpl implements EzEmailService {
	
	private static final Logger logger = LoggerFactory.getLogger(EzEmailServiceImpl.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
    private Properties config;
	
	@Autowired
    private EzEmailUtil ezEmailUtil;
	
	@Resource(name = "EzCommonService")
    private EzCommonService ezCommonService;
	
	@Autowired
	private EzOrganAdminDAO ezOrganAdminDao;
	
	@Autowired
	private EzOrganDAO ezOrganDao;
	
	
	@Resource(name="crypto") 
	private EgovFileScrty egovFileScrty;
	
	@Resource(name="egovMessageSource")
    private EgovMessageSource egovMessageSource;
	
	@Autowired
	private EzEmailDAO ezEmailDAO;

	@Autowired
	private EzEmailService ezEmailService;

	@Autowired
	private EzOrganAdminService ezOrganAdminService;

	@Autowired
	private EzOrganService ezOrganService;
	
	@Resource(name = "jspw")
	private String jspw;
	
    @Autowired
    private KlibUtil klibUtil;

	@Override
	public List<MailBlobVO> getOrphanedMailBlobList() throws Exception {
		return ezEmailDAO.getOrphanedMailBlobList();
	}

	@Override
	public List<MailDeletedIdVO> getMailDeletedIdList() throws Exception {
		return ezEmailDAO.getMailDeletedIdList();
	}
	
	@Override
	public List<MailGeneralVO> getMailGeneral(int tenantId, String userId) throws Exception {
		logger.debug("getMailGeneral started. tenantId=" + tenantId + ",userId=" + userId);
		
		List<MailGeneralVO> mailGeneralList = new ArrayList<MailGeneralVO>();
		
		String domainName = ezCommonService.getTenantConfig("DomainName", tenantId);
		String usePreviewSubTree = ezCommonService.getTenantConfig("UsePreviewSubTreeForEmail", tenantId);
		String usePlainForDefaultTextOption = ezCommonService.getTenantConfig("usePlainForDefaultTextOption", tenantId);
		String userIdParam = "userId=" + URLEncoder.encode(userId + "@" + domainName, "UTF-8");
		String usePreviewSubTreeParam = "usePreviewSubTree=" + usePreviewSubTree;
		String inputParams = userIdParam + "&" + usePreviewSubTreeParam;
		logger.debug("inputParams=" + inputParams);
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaEzEmail/getMailGeneral", inputParams);
		logger.debug("strJson=" + strJson);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(strJson);
        
        if (object.get("resultCode").equals("OK") && ((Long)object.get("reasonCode")).intValue() == 0) {
        	JSONObject obj = (JSONObject)object.get("result");
        	if (obj != null) {
        		MailGeneralVO mailGeneral = new MailGeneralVO();
        		String mailSearchPeriod = (String)obj.get("mailSearchPeriod") == null ? "sixMonth" : (String)obj.get("mailSearchPeriod");
        		String textOption = (String)obj.get("textOption");
        		
        		if (textOption == null || textOption.trim().equals("")) {
        			if (usePlainForDefaultTextOption.equalsIgnoreCase("YES")) {
        				textOption = "PLAIN";
        			} else {
        				textOption = "HTML";
        			}
        		}
        		
        		mailGeneral.setListCount((String)obj.get("listCount"));
        		mailGeneral.setRefreshInterval((String)obj.get("refreshInterval"));
        		mailGeneral.setKeepDeleteLength((String)obj.get("keepDeleteLength"));
        		mailGeneral.setPreviewMode((String)obj.get("previewMode"));
        		mailGeneral.setPreviewWList((String)obj.get("previewWList"));
        		mailGeneral.setPreviewWContent((String)obj.get("previewWContent"));
        		mailGeneral.setPreviewHList((String)obj.get("previewHList"));
        		mailGeneral.setPreviewHContent((String)obj.get("previewHContent"));
        		mailGeneral.setMailSenderNm((String)obj.get("mailSenderName"));
        		mailGeneral.setPreviewSubTree((String)obj.get("previewSubTree"));
        		mailGeneral.setPreviewMailImage((String)obj.get("previewMailImage"));
        		mailGeneral.setPreviewMail((String)obj.get("previewMail"));
        		mailGeneral.setTextOption(textOption);
        		mailGeneral.setMailSearchPeriod(mailSearchPeriod);
        		mailGeneral.setDefaultCursorPosition((String)obj.get("defaultCursorPosition"));
        		mailGeneral.setDefaultSeparateSend((String)obj.get("defaultSeparateSend"));
        		mailGeneral.setMailSendResult((String)obj.get("mailSendResult"));
				mailGeneral.setEditorFontFamily((String)obj.get("editorFontFamily"));
				mailGeneral.setEditorFontSize((String)obj.get("editorFontSize"));
				mailGeneral.setSelfCcOption((String)obj.get("selfCcOption"));
        		mailGeneralList.add(mailGeneral);
        	}
        }
        
        // set the defaults if there is no record in DB.
		if (mailGeneralList.size() == 0) {
			MailGeneralVO mailGeneral = new MailGeneralVO();
			String textOption = "HTML";
			
			if (usePlainForDefaultTextOption.equalsIgnoreCase("YES")) {
				textOption = "PLAIN";
			}
			
			mailGeneral.setListCount("30");
			mailGeneral.setRefreshInterval("300");
			mailGeneral.setKeepDeleteLength("0");
			mailGeneral.setPreviewMode("OFF");
			mailGeneral.setPreviewWList("50");
			mailGeneral.setPreviewWContent("50");
			mailGeneral.setPreviewHList("50");
			mailGeneral.setPreviewHContent("50");
			mailGeneral.setMailSenderNm("");
			mailGeneral.setPreviewSubTree("N");
			mailGeneral.setPreviewMailImage("Y");
			mailGeneral.setPreviewMail("N");
			mailGeneral.setTextOption(textOption);
			mailGeneral.setMailSearchPeriod("sixMonth");
			mailGeneral.setDefaultCursorPosition("recipient");
			mailGeneral.setDefaultSeparateSend("N");
			mailGeneral.setMailSendResult("failure");
			mailGeneral.setEditorFontFamily(null);
			mailGeneral.setEditorFontSize(null);
			mailGeneral.setSelfCcOption("none");
			
			mailGeneralList.add(mailGeneral);
		}
		
		logger.debug("getMailGeneral ended.");
		return mailGeneralList;
	}
	
	@Override
	public void setMailGeneral(int tenantId, String userId, MailGeneralVO mailGeneral, String mode, String inMailBox) throws Exception {
		logger.debug("setMailGeneral started.");
		logger.debug("tenantId=" + tenantId + ",userId=" + userId + ",mode=" + mode);
		
		String domainName = ezCommonService.getTenantConfig("DomainName", tenantId);
		String usePreviewSubTree = ezCommonService.getTenantConfig("UsePreviewSubTreeForEmail", tenantId);
		
		String userIdParam = "userId=" + URLEncoder.encode(userId + "@" + domainName, "UTF-8");
		String listCountParam = "listCount=" + URLEncoder.encode(mailGeneral.getListCount(), "UTF-8");
		String refreshIntervalParam = "refreshInterval=" + URLEncoder.encode(mailGeneral.getRefreshInterval(), "UTF-8");
		String keepDeleteLengthParam = "keepDeleteLength=" + URLEncoder.encode(mailGeneral.getKeepDeleteLength(), "UTF-8");
		String previewModeParam = "previewMode=" + URLEncoder.encode(mailGeneral.getPreviewMode(), "UTF-8");
		String previewWListParam = "previewWList=" + URLEncoder.encode(mailGeneral.getPreviewWList(), "UTF-8");
		String previewWContentParam = "previewWContent=" + URLEncoder.encode(mailGeneral.getPreviewWContent(), "UTF-8");
		String previewHListParam = "previewHList=" + URLEncoder.encode(mailGeneral.getPreviewHList(), "UTF-8");
		String previewHContentParam = "previewHContent=" + URLEncoder.encode(mailGeneral.getPreviewHContent(), "UTF-8");
		String mailSenderNameParam = "mailSenderName=" + URLEncoder.encode(mailGeneral.getMailSenderNm(), "UTF-8");
		String previewSubTreeParam = "previewSubTree=" + URLEncoder.encode(mailGeneral.getPreviewSubTree(), "UTF-8");
		String usePreviewSubTreeParam = "usePreviewSubTree=" + usePreviewSubTree;
		String previewMailImageParam = "previewMailImage=" + URLEncoder.encode(mailGeneral.getPreviewMailImage(), "UTF-8");
		String previewMailParam = "previewMail=" + URLEncoder.encode(mailGeneral.getPreviewMail(), "UTF-8");
		String textOptionParam = "textOption=" + URLEncoder.encode(mailGeneral.getTextOption(), "UTF-8");
		String mailSearchPeriodParam = "mailSearchPeriod=" + URLEncoder.encode(mailGeneral.getMailSearchPeriod(), "UTF-8");
		String defaultCursorPositionParam = "defaultCursorPosition=" + URLEncoder.encode(mailGeneral.getDefaultCursorPosition(), "UTF-8");
		String defaultSeparateSendParam = "defaultSeparateSend=" + URLEncoder.encode(mailGeneral.getDefaultSeparateSend(), "UTF-8");
		String mailSendResultParam = "mailSendResult=" + URLEncoder.encode(mailGeneral.getMailSendResult(), "UTF-8");
		String editorFontFamilyParam = "editorFontFamily=" + URLEncoder.encode(mailGeneral.getEditorFontFamily(), "UTF-8");
		String editorFontSizeParam = "editorFontSize=" + URLEncoder.encode(mailGeneral.getEditorFontSize(), "UTF-8");
		String selfCcOption = "selfCcOption=" + URLEncoder.encode(mailGeneral.getSelfCcOption(), "UTF-8");
		String inMailBoxOption = "inMailBox=" + URLEncoder.encode(inMailBox, "UTF-8");
		String modeParam = "mode=";
		if (mode != null && mode.equals("ALL")) {
			modeParam = "mode=all";
		}
		
		String inputParams = userIdParam + "&" + listCountParam + "&" + refreshIntervalParam + "&" + keepDeleteLengthParam + "&" + previewModeParam
				+ "&" + previewWListParam + "&" + previewWContentParam + "&" + previewHListParam + "&" + previewHContentParam + "&" + mailSenderNameParam
				+ "&" + modeParam +"&" + previewSubTreeParam + "&" + usePreviewSubTreeParam + "&" + previewMailImageParam + "&" + previewMailParam + "&" + textOptionParam
				+ "&" + mailSearchPeriodParam + "&" + defaultCursorPositionParam + "&" + defaultSeparateSendParam + "&" + mailSendResultParam + "&" + editorFontFamilyParam + "&" + editorFontSizeParam
				+ "&" + selfCcOption + "&" + inMailBoxOption;

		logger.debug("inputParams=" + inputParams);
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaEzEmail/setMailGeneral", inputParams);
		logger.debug("strJson=" + strJson);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(strJson);
        
        if (!object.get("resultCode").equals("OK") || ((Long)object.get("reasonCode")).intValue() != 0) {
        	throw new Exception("JGwServer ERROR");
        }
        
        logger.debug("setMailGeneral ended.");
	}
	
	@Override
	public MailSignatureVO getMailSignature(int tenantId, String pUserID) throws Exception {
		logger.debug("getMailSignature started. tenantId=" + tenantId + ",pUserID" + pUserID);
		
		MailSignatureVO mailSignatureVO = null;
		
		String domainName = ezCommonService.getTenantConfig("DomainName", tenantId);
		
		String inputParams = "userId=" + URLEncoder.encode(pUserID + "@" + domainName, "UTF-8");
		logger.debug("inputParams=" + inputParams);
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaEzEmail/getMailSignature", inputParams);
		logger.debug("strJson=" + strJson);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(strJson);
        
        if (object.get("resultCode").equals("OK") && ((Long)object.get("reasonCode")).intValue() == 0) {
        	JSONObject obj = (JSONObject)object.get("result");
        	
        	if (obj != null) {
        		mailSignatureVO = new MailSignatureVO();
        		
        		mailSignatureVO.setUseFlag((String)obj.get("useFlag"));
        		mailSignatureVO.setContent1((String)obj.get("content1"));
        		mailSignatureVO.setContent2((String)obj.get("content2"));
        		mailSignatureVO.setContent3((String)obj.get("content3"));
        	}
        } else {
        	throw new Exception("JGwServer ERROR");
        }
        
        logger.debug("getMailSignature ended.");
        return mailSignatureVO;
	}

	@Override
	public void setMailSignature(int tenantId, String pUserID, String pUseFlag, String pContent1, String pContent2, String pContent3)
			throws Exception {
		logger.debug("setMailSignature started.");
		logger.debug("tenantId=" + tenantId + ",pUserID=" + pUserID + ",pUseFlag=" + pUseFlag);
		
		String domainName = ezCommonService.getTenantConfig("DomainName", tenantId);
		
		String userIdParam = "userId=" + URLEncoder.encode(pUserID + "@" + domainName, "UTF-8");
		String useFlagParam = "useFlag=" + URLEncoder.encode(pUseFlag, "UTF-8");
		String content1Param = "content1=" + URLEncoder.encode(pContent1, "UTF-8");
		String content2Param = "content2=" + URLEncoder.encode(pContent2, "UTF-8");
		String content3Param = "content3=" + URLEncoder.encode(pContent3, "UTF-8");
		
		String inputParams = userIdParam + "&" + useFlagParam + "&" + content1Param + "&" + content2Param + "&" + content3Param;
		logger.debug("inputParams=" + inputParams);
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaEzEmail/setMailSignature", inputParams);
		logger.debug("strJson=" + strJson);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(strJson);
        
        if (!object.get("resultCode").equals("OK") || ((Long)object.get("reasonCode")).intValue() != 0) {
        	throw new Exception("JGwServer ERROR");
        }
        
        logger.debug("setMailSignature ended.");
	}
	
	@Override
	public MailColorVO getMailColor(int tenantId) throws Exception {
		logger.debug("getMailColor started. tenantId=" + tenantId);
		
		MailColorVO vo = null;
		
		String inputParams = "tenantId=" + tenantId;
		logger.debug("inputParams=" + inputParams);
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaEzEmail/getMailColor", inputParams);
		logger.debug("strJson=" + strJson);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(strJson);
        
        if (object.get("resultCode").equals("OK") && ((Long)object.get("reasonCode")).intValue() == 0) {
        	JSONObject obj = (JSONObject)object.get("result");
        	if (obj != null) {
        		vo = new MailColorVO();
        		
        		vo.setImportanceColor((String)obj.get("importanceColor"));
        		vo.setInmailColor((String)obj.get("inmailColor"));
        		vo.setOutmailColor((String)obj.get("outmailColor"));
        	}
        } else {
        	throw new Exception("Error from JGwServer.");
        }
        
        logger.debug("getMailColor ended.");
        return vo;
	}
	
	@Override
	public void setMailColor(int pTenantId, String pImportanceColor, String pInColor, String pOutColor) throws Exception {
		logger.debug("setMailColor started.");
		logger.debug("pTenantId=" + pTenantId + ",pImportanceColor=" + pImportanceColor + ",pInColor=" + pInColor + ",pOutColor=" + pOutColor);
		
		String tenantIdParam = "tenantId=" + pTenantId;
		String importanceColorParam = "importanceColor=" + URLEncoder.encode(pImportanceColor, "UTF-8");
		String inmailColorParam = "inmailColor=" + URLEncoder.encode(pInColor, "UTF-8");
		String outmailColorParam = "outmailColor=" + URLEncoder.encode(pOutColor, "UTF-8");
		
		String inputParams = tenantIdParam + "&" + importanceColorParam + "&" + inmailColorParam + "&" + outmailColorParam;
		logger.debug("inputParams=" + inputParams);
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaEzEmail/setMailColor", inputParams);
		logger.debug("strJson=" + strJson);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(strJson);
        
        if (!object.get("resultCode").equals("OK") || ((Long)object.get("reasonCode")).intValue() != 0) {
        	throw new Exception("Error from JGwServer.");
        }
        
        logger.debug("setMailColor ended.");
	}
	
	@Override
	public List<MailDeleteVO> getMailDelete(int tenantId, String userId) throws Exception {
		logger.debug("getMailDelete started. tenantId=" + tenantId + ",userId=" + userId);
		
		List<MailDeleteVO> list = new ArrayList<MailDeleteVO>();
		
		String domainName = ezCommonService.getTenantConfig("DomainName", tenantId);
		
		String inputParams = "userId=" + URLEncoder.encode(userId + "@" + domainName, "UTF-8");
		logger.debug("inputParams=" + inputParams);
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaEzEmail/getMailDelete", inputParams);
		logger.debug("strJson=" + strJson);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(strJson);
        
        if (object.get("resultCode").equals("OK") && ((Long)object.get("reasonCode")).intValue() == 0) {
        	JSONArray resultArray = (JSONArray)object.get("result");
        	
        	for (int i=0; i<resultArray.size(); i++) {
        		JSONObject obj = (JSONObject)resultArray.get(i);
        		
        		MailDeleteVO mailDeleteVO = new MailDeleteVO();
        		
        		mailDeleteVO.setPath((String)obj.get("folderPath"));
        		mailDeleteVO.setExpireTime(((Long)obj.get("expireTime")).intValue());
        		mailDeleteVO.setDeleteUnread((String)obj.get("deleteUnread"));
        		mailDeleteVO.setFolderName((String)obj.get("folderName"));
				mailDeleteVO.setAutoDeletionOption((String) obj.get("autoDeletionOption"));
        		
        		list.add(mailDeleteVO);
        	}
        } else {
        	throw new Exception("JGwServer ERROR");
        }
        
        logger.debug("getMailDelete ended.");
        return list;
	}
	
	@Override
	public void setMailDelete(int tenantId, String pUserID, String pPath, int pExpireTime, int pDeleteUnread, String pFolderName, String pAutoDeletionOption) throws Exception {
		logger.debug("setMailDelete started.");
		logger.debug("tenantId=" + tenantId + ",pUserID=" + pUserID + ",pPath=" + pPath + ",pExpireTime=" + pExpireTime + ",pDeleteUnread=" + pDeleteUnread + ",pFolderName=" + pFolderName);
		
		String domainName = ezCommonService.getTenantConfig("DomainName", tenantId);
		
		String userIdParam = "userId=" + URLEncoder.encode(pUserID + "@" + domainName, "UTF-8");
		String folderPathParam = "folderPath=" + URLEncoder.encode(pPath, "UTF-8");
		String expireTimeParam = "expireTime=" + pExpireTime;
		String deleteUnreadParam = "deleteUnread=" + pDeleteUnread;
		String folderNameParam = "folderName=" + URLEncoder.encode(pFolderName, "UTF-8");
		String autoDeletionOptionParam = "autoDeletionOption=" + URLEncoder.encode(pAutoDeletionOption, "UTF-8");

		String inputParams = userIdParam + "&" + folderPathParam + "&" + expireTimeParam + "&" + deleteUnreadParam + "&" + folderNameParam + "&" + autoDeletionOptionParam;
		logger.debug("inputParams=" + inputParams);
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaEzEmail/setMailDelete", inputParams);
		logger.debug("strJson=" + strJson);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(strJson);
        
        if (!object.get("resultCode").equals("OK") || ((Long)object.get("reasonCode")).intValue() != 0) {
        	throw new Exception("JGwServer ERROR");
        }

        logger.debug("setMailDelete ended.");
	}
	
	@Override
	public void deleteMailDelete(int tenantId, String pUserID, String pFolderPath) throws Exception {
		logger.debug("deleteMailDelete started.");
		logger.debug("tenantId=" + tenantId + ",pUserID=" + pUserID + ",pFolderPath=" + pFolderPath);
		
		if (pFolderPath == null || pFolderPath.trim().equals("")) {
			logger.error("Cannot delete autoDelete. folderPath is empty.");
			throw new Exception("Cannot delete autoDelete. folderPath is empty.");
		}
		
		String domainName = ezCommonService.getTenantConfig("DomainName", tenantId);
		
		String userIdParam = "userId=" + URLEncoder.encode(pUserID + "@" + domainName, "UTF-8");
		String folderPathParam = "folderPath=" + URLEncoder.encode(pFolderPath, "UTF-8");
		
		String inputParams = userIdParam + "&" + folderPathParam;
		logger.debug("inputParams=" + inputParams);
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaEzEmail/deleteMailDelete", inputParams);
		logger.debug("strJson=" + strJson);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(strJson);
        
        if (!object.get("resultCode").equals("OK") || ((Long)object.get("reasonCode")).intValue() != 0) {
        	throw new Exception("JGwServer ERROR");
        }
        
        logger.debug("deleteMailDelete ended.");
	}
	
	@Override
	public List<MailDeleteVO> getMailDeleteList() throws Exception {
		logger.debug("getMailDeleteList started.");
		
		List<MailDeleteVO> list = new ArrayList<MailDeleteVO>();
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaEzEmail/getMailDeleteAll", null);
		logger.debug("strJson=" + strJson);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(strJson);
        
        if (object.get("resultCode").equals("OK") && ((Long)object.get("reasonCode")).intValue() == 0) {
        	JSONArray resultArray = (JSONArray)object.get("result");
        	
        	for (int i=0; i<resultArray.size(); i++) {
        		JSONObject obj = (JSONObject)resultArray.get(i);
        		
        		MailDeleteVO mailDeleteVO = new MailDeleteVO();
        		
        		mailDeleteVO.setUserEmail(((String)obj.get("userId")));
        		mailDeleteVO.setPath((String)obj.get("folderPath"));
        		mailDeleteVO.setExpireTime(((Long)obj.get("expireTime")).intValue());
        		mailDeleteVO.setDeleteUnread((String)obj.get("deleteUnread"));
        		mailDeleteVO.setFolderName((String)obj.get("folderName"));
				mailDeleteVO.setAutoDeletionOption((String) obj.get("autoDeletionOption"));

        		list.add(mailDeleteVO);
        	}
        }
        
        logger.debug("getMailDeleteList ended.");
        return list;
	}
	
	@Override
	public List<MailReservationVO> getMailReserved(int tenantId, String pUserId) throws Exception {
		logger.debug("getMailReserved started. tenantId=" + tenantId + ",pUserId=" + pUserId);
		
		List<MailReservationVO> list = new ArrayList<MailReservationVO>();
		
		String domainName = ezCommonService.getTenantConfig("DomainName", tenantId);
		
		String inputParams = "userId=" + URLEncoder.encode(pUserId + "@" + domainName, "UTF-8");
		logger.debug("inputParams=" + inputParams);
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaEzEmail/getMailReserved", inputParams);
		logger.debug("strJson=" + strJson);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(strJson);
        
        if (object.get("resultCode").equals("OK") && ((Long)object.get("reasonCode")).intValue() == 0) {
        	JSONArray resultArray = (JSONArray)object.get("result");
        	
        	for (int i=0; i<resultArray.size(); i++) {
        		JSONObject obj = (JSONObject)resultArray.get(i);
        		
        		MailReservationVO vo = new MailReservationVO();
        		
        		vo.setMessageId((String)obj.get("messageId"));
        		vo.setConnUrl((String)obj.get("userId"));
        		vo.setSubject((String)obj.get("subject"));
        		vo.setSendDate((String)obj.get("sendDate"));
        		
        		list.add(vo);
        	}
        }
        
        logger.debug("getMailReserved ended.");
        return list;
	}
	
	@Override
	public List<MailReservationVO> getMailReserved2() throws Exception {
		logger.debug("getMailReserved2 started.");
		
		List<MailReservationVO> list = new ArrayList<MailReservationVO>();
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaEzEmail/getMailReserved2", null);
		logger.debug("strJson=" + strJson);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(strJson);
        
        if (object.get("resultCode").equals("OK") && ((Long)object.get("reasonCode")).intValue() == 0) {
        	JSONArray resultArray = (JSONArray)object.get("result");
        	
        	for (int i=0; i<resultArray.size(); i++) {
        		JSONObject obj = (JSONObject)resultArray.get(i);
        		
        		MailReservationVO vo = new MailReservationVO();
        		
        		vo.setMessageId((String)obj.get("messageId"));
        		vo.setConnUrl((String)obj.get("userId"));
        		vo.setSender((String)obj.get("sender"));

        		list.add(vo);
        	}
        }
        
        logger.debug("getMailReserved2 ended.");
		return list;
	}
	
	@Override
	public String setMailReserved(int tenantId, String pMessageId, String pSubject, String pSendDate, String mailId, String sender, String isReserve) throws Exception {
		logger.debug("setMailReserved started.");
		logger.debug("tenantId={}, pMessageId={}, pSubject={}, pSendDate={}, mailId={}, sender={}, isReserve={}", tenantId, pMessageId, pSubject, pSendDate, mailId, sender, isReserve);
		if (!isReserve.equalsIgnoreCase("YES")) {
			pMessageId = UUID.randomUUID().toString();
		}
		
		String domainName = ezCommonService.getTenantConfig("DomainName", tenantId);
		
		String messageIdParam = "messageId=" + URLEncoder.encode(pMessageId, "UTF-8");
		String userIdParam = "userId=" + URLEncoder.encode(mailId + "@" + domainName, "UTF-8");
		String senderParam = "sender=" + URLEncoder.encode(sender, "UTF-8");
		String subjectParam = "subject=" + URLEncoder.encode(pSubject, "UTF-8");
		String sendDateParam = "sendDate=" + URLEncoder.encode(pSendDate, "UTF-8");

		String inputParams = String.join("&", messageIdParam, userIdParam, senderParam, subjectParam, sendDateParam);
		logger.debug("inputParams=" + inputParams);
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaEzEmail/setMailReserved", inputParams);
		logger.debug("strJson=" + strJson);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(strJson);
        
        if (!object.get("resultCode").equals("OK") || ((Long)object.get("reasonCode")).intValue() != 0) {
        	throw new Exception("Error from JGwServer.");
        }
        
        logger.debug("setMailReserved ended. pMessageId=" + pMessageId);
        return pMessageId;
	}
	
	@Override
	public void deleteMailReserved(String pMessageId) throws Exception {
		logger.debug("deleteMailReserved started. pMessageId=" + pMessageId);
		
		String inputParams = "messageId=" + URLEncoder.encode(pMessageId, "UTF-8");
		logger.debug("inputParams=" + inputParams);
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaEzEmail/deleteMailReserved", inputParams);
		logger.debug("strJson=" + strJson);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(strJson);
        
        if (!object.get("resultCode").equals("OK") || ((Long)object.get("reasonCode")).intValue() != 0) {
        	throw new Exception("Error from JGwServer.");
        }
        
        logger.debug("deleteMailReserved ended.");
	}
	
	@Override
	public String getMailReservedTime(String pMessageId) throws Exception {
		logger.debug("getMailReservedTime started. pMessageId=" + pMessageId);
		
		String pReservedSaveTime = "";
		
		String inputParams = "messageId=" + URLEncoder.encode(pMessageId, "UTF-8");
		logger.debug("inputParams=" + inputParams);
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaEzEmail/getMailReservedTime", inputParams);
		logger.debug("strJson=" + strJson);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(strJson);
        
        if (object.get("resultCode").equals("OK") && ((Long)object.get("reasonCode")).intValue() == 0) {
        	pReservedSaveTime = (String)object.get("result");
        } else {
        	throw new Exception("Error from JGwServer.");
        }
        
        logger.debug("getMailReservedTime ended.");
        return pReservedSaveTime;
	}
	
	@Override
	public List<MailReadVO> getMailReadList(int tenantId, String pUserId, String pMessageId) throws Exception {
		logger.debug("getMailReadList started.");
		logger.debug("tenantId=" + tenantId + ",pUserId=" + pUserId + ",pMessageId=" + pMessageId);
		
		List<MailReadVO> readList = new ArrayList<MailReadVO>();
		
		String domainName = ezCommonService.getTenantConfig("DomainName", tenantId);
		
		String userIdParam = "userId=" + URLEncoder.encode(pUserId + "@" + domainName, "UTF-8");
		String messageIdParam = "messageId=" + URLEncoder.encode(pMessageId, "UTF-8");
		
		String inputParams = userIdParam + "&" + messageIdParam;
		logger.debug("inputParams=" + inputParams);
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaEzEmail/getMailReadList", inputParams);
		logger.debug("strJson=" + strJson);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(strJson);
		
		if (object.get("resultCode").equals("OK") && ((Long)object.get("reasonCode")).intValue() == 0) {
        	JSONArray resultArray = (JSONArray)object.get("result");
        	
        	for (int i=0; i<resultArray.size(); i++) {
        		JSONObject obj = (JSONObject)resultArray.get(i);
        		
        		MailReadVO mailReadVO = new MailReadVO();
        		
				mailReadVO.setReadDate((String)obj.get("readDate"));
				mailReadVO.setReaderEmail((String)obj.get("readerEmail"));
				mailReadVO.setReaderName((String)obj.get("readerName"));
        		
				readList.add(mailReadVO);
        	}
		}
		
		logger.debug("getMailReadList ended.");
		return readList;
	}
	
	@Override
	public List<MailCancelVO> getMailCancelList(String pMessage) throws Exception {
		logger.debug("getMailCancelList started. pMessage=" + pMessage);
		
		List<MailCancelVO> cancelList = new ArrayList<MailCancelVO>();
		
		String inputParams = "messageId=" + URLEncoder.encode(pMessage, "UTF-8");
		logger.debug("inputParams=" + inputParams);
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaEzEmail/getMailRecallList", inputParams);
		logger.debug("strJson=" + strJson);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(strJson);
		
		if (object.get("resultCode").equals("OK") && ((Long)object.get("reasonCode")).intValue() == 0) {
        	JSONArray resultArray = (JSONArray)object.get("result");
        	
        	for (int i=0; i<resultArray.size(); i++) {
        		JSONObject obj = (JSONObject)resultArray.get(i);
        		
        		MailCancelVO mailCancelVO = new MailCancelVO();
        		
        		mailCancelVO.setReaderEmail((String)obj.get("receiverEmail"));
        		mailCancelVO.setReaderName((String)obj.get("receiverName"));
        		mailCancelVO.setStatus((String)obj.get("status"));
        		mailCancelVO.setPrimaryEmail((String)obj.get("primaryEmail"));
        		
				cancelList.add(mailCancelVO);
        	}
		}
		
		logger.debug("getMailCancelList ended.");
		return cancelList;
	}
	
	@Override
	public String getMailReceiveMessageId(String pNum) throws Exception {
		logger.debug("getMailReceiveMessageId started. pNum=" + pNum);
		
		String messageId = null;
		
		String inputParams = "recallIdx=" + URLEncoder.encode(pNum, "UTF-8");
		logger.debug("inputParams=" + inputParams);
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaEzEmail/getMailRecallMessageId", inputParams);
		logger.debug("strJson=" + strJson);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(strJson);
        
        if (object.get("resultCode").equals("OK") && ((Long)object.get("reasonCode")).intValue() == 0) {
        	messageId = (String)object.get("result");
        }
        
        logger.debug("getMailReceiveMessageId ended.");
        return messageId;
	}
	
	@Override
	public void updateMailReceiveDetailInfo(String pNum, String[] receiveDetail) throws Exception {
		logger.debug("updateMailReceiveDetailInfo started.");
		
		String recallIdxParam = "recallIdx=" + pNum;
		String addressParam = "address=" + URLEncoder.encode(receiveDetail[0], "UTF-8");
		String statusParam = "status=" + URLEncoder.encode(receiveDetail[1], "UTF-8");
		
		String inputParams = recallIdxParam + "&" + addressParam + "&" + statusParam;
		logger.debug("inputParams=" + inputParams);
		
		logger.debug("inputParams=" + inputParams.toString());
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaEzEmail/updateMailRecallDetail2", inputParams.toString());
		logger.debug("strJson=" + strJson);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(strJson);
        
        if (!object.get("resultCode").equals("OK") || ((Long)object.get("reasonCode")).intValue() != 0) {
        	throw new Exception("Error from JGwServer.");
        }
        
        logger.debug("updateMailReceiveDetailInfo ended.");
	}
	
	@Override
	public List<String> getMailReceiveAddress(String pNum) throws Exception {
		logger.debug("getMailReceiveAddress started. pNum=" + pNum);
		
		List<String> addressList = new ArrayList<String>();
		
		String inputParams = "recallIdx=" + URLEncoder.encode(pNum, "UTF-8");
		logger.debug("inputParams=" + inputParams);
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaEzEmail/getMailRecallReceiverEmail", inputParams);
		logger.debug("strJson=" + strJson);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(strJson);
		
		if (object.get("resultCode").equals("OK") && ((Long)object.get("reasonCode")).intValue() == 0) {
        	JSONArray resultArray = (JSONArray)object.get("result");
        	
        	for (int i=0; i<resultArray.size(); i++) {
        		addressList.add((String)resultArray.get(i));
        	}
		}
		
		logger.debug("getMailReceiveAddress ended.");
		return addressList;
	}
	
	@Override
	public List<MailPOP3VO> getMailPOP3(int tenantId, String pUserId) throws Exception {
		logger.debug("getMailPOP3 started. tenantId=" + tenantId + ",pUserId=" + pUserId);
		
		List<MailPOP3VO> list = new ArrayList<MailPOP3VO>();
		
		String domainName = ezCommonService.getTenantConfig("DomainName", tenantId);
		
		String inputParams = "userId=" + URLEncoder.encode(pUserId + "@" + domainName, "UTF-8");
		logger.debug("inputParams=" + inputParams);
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaEzEmail/getMailPOP3", inputParams);
		logger.debug("strJson=" + strJson);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(strJson);
		
		if (object.get("resultCode").equals("OK") && ((Long)object.get("reasonCode")).intValue() == 0) {
        	JSONArray resultArray = (JSONArray)object.get("result");
        	
        	for (int i=0; i<resultArray.size(); i++) {
        		JSONObject obj = (JSONObject)resultArray.get(i);
        		
        		MailPOP3VO mailPOP3VO = new MailPOP3VO();
        		
				mailPOP3VO.setPop3Server((String)obj.get("pop3Server"));
				mailPOP3VO.setPop3PortNo((String)obj.get("pop3Port"));
				mailPOP3VO.setPop3UserId((String)obj.get("pop3UserId"));
				mailPOP3VO.setPop3Pw((String)obj.get("pop3Password"));
				mailPOP3VO.setSaveTo((String)obj.get("saveFolderPath"));
				mailPOP3VO.setSaveTofolder((String)obj.get("saveFolderName"));
				mailPOP3VO.setDeleteYN((String)obj.get("deleteYN"));
				mailPOP3VO.setPop3SslYN((String)obj.get("sslYN"));
        		
				list.add(mailPOP3VO);
        	}
		}
		
		logger.debug("getMailPOP3 ended.");
		return list;
	}
	
	@Override
	public void savePop3(int tenantId, String pUserId, String pRet) throws Exception {
		logger.debug("savePop3 started. tenantId=" + tenantId + ",pUserId=" + pUserId);
		
		String domainName = ezCommonService.getTenantConfig("DomainName", tenantId);
		
		String inputParams = "userId=" + URLEncoder.encode(pUserId + "@" + domainName, "UTF-8");
		logger.debug("inputParams=" + inputParams);
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaEzEmail/getMailPOP3", inputParams);
		logger.debug("strJson=" + strJson);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(strJson);
        
		List<MailPOP3VO> pop3List = new ArrayList<MailPOP3VO>();
		
		if (object.get("resultCode").equals("OK") && ((Long)object.get("reasonCode")).intValue() == 0) {
        	JSONArray resultArray = (JSONArray)object.get("result");
        	
        	for (int i=0; i<resultArray.size(); i++) {
        		JSONObject obj = (JSONObject)resultArray.get(i);
        		
        		MailPOP3VO mailPOP3VO = new MailPOP3VO();
        		
				mailPOP3VO.setPop3Server((String)obj.get("pop3Server"));
				mailPOP3VO.setPop3PortNo((String)obj.get("pop3Port"));
				mailPOP3VO.setPop3UserId((String)obj.get("pop3UserId"));
				mailPOP3VO.setPop3Pw((String)obj.get("pop3Password"));
				mailPOP3VO.setSaveTo((String)obj.get("saveFolderPath"));
				mailPOP3VO.setSaveTofolder((String)obj.get("saveFolderName"));
				mailPOP3VO.setDeleteYN((String)obj.get("deleteYN"));
				mailPOP3VO.setPop3SslYN((String)obj.get("sslYN"));
        		
				pop3List.add(mailPOP3VO);
        	}
        } else {
        	throw new Exception("JGwServer ERROR");
        }
		
		String prm = egovFileScrty.getPrm();
		String pre = egovFileScrty.getPre();
		PrivateKey pk = EgovFileScrty.getPrivateKey(prm, pre);

		if (pRet != null){
			Document doc = commonUtil.convertStringToDocument(pRet);
			NodeList rows = doc.getElementsByTagName("ROW");

			for (int i=0; i<rows.getLength(); i++) {
				NodeList children = rows.item(i).getChildNodes();
				String server = children.item(0).getTextContent();
				String port = children.item(1).getTextContent();
				String id = children.item(2).getTextContent();
				String deleteYN = children.item(3).getTextContent();
				String pw = children.item(4).getTextContent();
				String saveTo = children.item(5).getTextContent();
				String saveToFolder = children.item(6).getTextContent();
				String useSsl = children.item(7).getTextContent().equals("true") ? "1" : "0";

				for (MailPOP3VO vo : pop3List) {
					if (vo.getPop3Server().toLowerCase().equals(server.toLowerCase())
							&& EgovFileScrty.decryptRsa(pk, vo.getPop3UserId()).equals(EgovFileScrty.decryptRsa(pk, id))) {
						id = vo.getPop3UserId();
						break;
					}
				}

				inputParams += "&pop3Server=" + server + "&pop3Port=" + port + "&pop3UserId=" + id + "&pop3Password=" + pw
						+ "&saveFolderPath=" + saveTo + "&saveFolderName=" + saveToFolder + "&deleteYN=" + deleteYN + "&sslYN=" + useSsl;
			}
		}
		
		logger.debug("inputParams=" + inputParams);
		
		strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaEzEmail/setMailPOP3", inputParams);
		logger.debug("strJson=" + strJson);
		
		object = (JSONObject)parser.parse(strJson);
		
		if (!object.get("resultCode").equals("OK") || ((Long)object.get("reasonCode")).intValue() != 0) {
        	throw new Exception("JGwServer ERROR");
        }
		
		logger.debug("savePop3 ended.");
	}
	
	@Override
	public void setMailPOP3List(int tenantId, String pUserId, String pPop3Server, String pPop3UserId, List<String> pMessageIds) throws Exception {
		logger.debug("setMailPOP3List started.");
		logger.debug("tenantId=" + tenantId + ",pUserId=" + pUserId + ",pPop3Server=" + pPop3Server + ",pPop3UserId=" + pPop3UserId);
		
		String domainName = ezCommonService.getTenantConfig("DomainName", tenantId);
		
		StringBuilder inputParams = new StringBuilder();
		inputParams.append("userId=" + URLEncoder.encode(pUserId + "@" + domainName, "UTF-8"));
		inputParams.append("&pop3Server=" + URLEncoder.encode(pPop3Server, "UTF-8"));
		inputParams.append("&pop3UserId=" + URLEncoder.encode(pPop3UserId, "UTF-8"));
		
		for (String messageId : pMessageIds) {
			inputParams.append("&mid=" + URLEncoder.encode(messageId, "UTF-8"));
		}
		
		logger.debug("inputParams=" + inputParams.toString());
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaEzEmail/setMailPOP3List", inputParams.toString());
		logger.debug("strJson=" + strJson);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(strJson);
		
		if (!object.get("resultCode").equals("OK") || ((Long)object.get("reasonCode")).intValue() != 0) {
			throw new Exception("Error from JGwServer.");
        }
		
		logger.debug("setMailPOP3List ended.");
	}
	
	@Override
	public List<String> getMailPOP3List(int tenantId, String pUserId, String pPop3Server, String pPop3UserId) throws Exception {
		logger.debug("getMailPOP3List started.");
		logger.debug("tenantId=" + tenantId + ",pUserId=" + pUserId + ",pPop3Server=" + pPop3Server + ",pPop3UserId=" + pPop3UserId);
		
		List<String> list = new ArrayList<String>();
		
		String domainName = ezCommonService.getTenantConfig("DomainName", tenantId);
		
		String userIdParam = "userId=" + URLEncoder.encode(pUserId + "@" + domainName, "UTF-8");
		String pop3ServerParam = "pop3Server=" + URLEncoder.encode(pPop3Server, "UTF-8");
		String pop3UserIdParam = "pop3UserId=" + URLEncoder.encode(pPop3UserId, "UTF-8");
		
		String inputParams = userIdParam + "&" + pop3ServerParam + "&" + pop3UserIdParam;
		logger.debug("inputParams=" + inputParams);
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaEzEmail/getMailPOP3List", inputParams);
		logger.debug("strJson=" + strJson);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(strJson);
        
		if (object.get("resultCode").equals("OK") && ((Long)object.get("reasonCode")).intValue() == 0) {
        	JSONArray resultArray = (JSONArray)object.get("result");
        	for (int i=0; i<resultArray.size(); i++) {
				list.add((String)resultArray.get(i));
        	}
		} else {
			throw new Exception("JGwServer ERROR");
		}
		
		logger.debug("getMailPOP3List ended.");
		return list;
	}
	
	@Override
	public String setIndividualAlias(String userId, int tenantID, String primaryMail, List<String> individualAliasList) throws Exception {
		logger.debug("setIndividualAlias started.");
		logger.debug("userId=" + userId + ",tenantID=" + tenantID + ",primaryMail=" + primaryMail);
		
		return  setIndividualAlias(userId, tenantID, primaryMail, individualAliasList, "user", "");
	}
	
	@Override
	public String setIndividualAlias(String userId, int tenantID, String primaryMail, List<String> individualAliasList, String type, String companyId) throws Exception {
		logger.debug("setIndividualAlias(2) started.");
		type = type.equals("") ? "user" : type;
		logger.debug("userId=" + userId + ",tenantID=" + tenantID + ",primaryMail=" + primaryMail, ", type=" + type + ", companyId=" + companyId);
		
		String returnValue = "ERROR";
		
		String domain = ezCommonService.getTenantConfig("DomainName", tenantID);
		String inputParams = "userId=" + URLEncoder.encode(userId + "@" + domain, "UTF-8");
		
		for (String individualAlias : individualAliasList) {
			inputParams += "&individualAlias=" + URLEncoder.encode(individualAlias, "UTF-8");
		}
		logger.debug("inputParams=" + inputParams);
		
		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzHrMaster/setIndividualAlias";
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		logger.debug("response=" + response);

		if (response != null) {
			JSONParser jsonParser = new JSONParser();
			JSONObject responseObj = (JSONObject)jsonParser.parse(response);
			
			if (((String)responseObj.get("resultCode")).equals("OK") && (Long)responseObj.get("reasonCode") == 0) {
				logger.debug("== setPrimaryMail");

				if (type.equals("user") || type.equals("share")) {
					ezOrganAdminDao.setUserPrimaryMail(userId, tenantID, primaryMail);
				} else if (type.equals("dept")) {
					Map<String, Object> deptMap = new HashMap<String, Object>();
					
					deptMap.put("MAIL", primaryMail);
					deptMap.put("CN", userId);
					deptMap.put("TENANT_ID", tenantID);
					
					ezOrganAdminDao.setDeptPrimaryMail(deptMap);
				} else if (type.equals("ml")) {
					inputParams = "userId=" + userId + "&companyId=" + companyId + "&primaryMail=" + primaryMail;
					requestURL = config.getProperty("config.JGwServerURL") + "/jMochaAccess/setDistributionPrimaryMail";
					response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
					logger.debug("ml response=" + response);
				}
				
				returnValue = "OK";
			}
		}						
		
		logger.debug("setIndividualAlias(2) ended. returnValue=" + returnValue);
		
		return returnValue;
	}
	
	@Override
	public int deleteIndividualAlias(String userId, int tenantID) throws Exception {
		logger.debug("deleteIndividualAlias started.");
		logger.debug("userId=" + userId + ",tenantID=" + tenantID);
		
		String domain = ezCommonService.getTenantConfig("DomainName", tenantID);
		String inputParams = "userId=" + URLEncoder.encode(userId + "@" + domain, "UTF-8");
		logger.debug("inputParams=" + inputParams);
		
		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzHrMaster/setIndividualAlias";
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		logger.debug("response=" + response);
		
		String resultCode = "Error";
		int reasonCode = -100;
		
		if (response != null) {
			JSONParser jsonParser = new JSONParser();
			JSONObject responseObj = (JSONObject)jsonParser.parse(response);
			
			resultCode = (String)responseObj.get("resultCode");		
			
			if (resultCode.equals("OK")) {
				reasonCode = ((Long)responseObj.get("reasonCode")).intValue();
			}
		}
		
		logger.debug("deleteIndividualAlias ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);
		return reasonCode;
	}
	
	@Override
	public String checkIndividualAlias(String individualAlias,int  tenantId) throws Exception {
		logger.debug("checkIndividualAlias started. individualAlias=" + individualAlias);
		
		String returnValue = "ERROR";
		
		String inputParams = "individualAlias=" + URLEncoder.encode(individualAlias, "UTF-8");
		inputParams += "&tenantId=" + tenantId;
		logger.debug("inputParams=" + inputParams);
		
		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzHrMaster/checkIndividualAlias";
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		logger.debug("response=" + response);

		if (response != null) {
			JSONParser jsonParser = new JSONParser();
			JSONObject responseObj = (JSONObject)jsonParser.parse(response);
			
			if (((String)responseObj.get("resultCode")).equals("OK")) {
				int reasonCode = ((Long)responseObj.get("reasonCode")).intValue();
				if (reasonCode == 0) {
					returnValue = "OK";
				} else if (reasonCode == -1) {
					returnValue = "OTHERDOMAIN";
				} else if (reasonCode == -2) {
					returnValue = "OTHERUSER";
				}
			}
		}						
		
		logger.debug("checkIndividualAlias ended. returnValue=" + returnValue);
		return returnValue;
	}
	
	@Override
	public String checkIndividualAliasWithoutOwned(String userEmail, String individualAlias, int tenantId) throws Exception {
		logger.debug("checkIndividualAliasWithoutOwned started. userEmail={}, individualAlias={}", userEmail, individualAlias);

		String returnValue = "ERROR";

		String inputParams = new StringBuilder("userEmail=").append(URLEncoder.encode(userEmail, "UTF-8"))
				.append("&individualAlias=").append(URLEncoder.encode(individualAlias, "UTF-8"))
				.append("&tenantId=").append(tenantId).toString();
		logger.debug("inputParams=" + inputParams);

		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzHrMaster/checkIndividualAliasWithoutOwned";
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		logger.debug("response=" + response);

		if (response != null) {
			JSONParser jsonParser = new JSONParser();
			JSONObject responseObj = (JSONObject) jsonParser.parse(response);

			if (((String) responseObj.get("resultCode")).equals("OK")) {
				int reasonCode = ((Long) responseObj.get("reasonCode")).intValue();
				if (reasonCode == 0) {
					returnValue = "OK";
				} else if (reasonCode == -1) {
					returnValue = "OTHERDOMAIN";
				} else if (reasonCode == -2) {
					returnValue = "OTHERUSER";
				} else if (reasonCode == -4) {
					returnValue = "INVALIDFORMAT";
				}
			}
		}

		logger.debug("checkIndividualAliasWithoutOwned ended. returnValue=" + returnValue);
		return returnValue;
	}

	@Override
	public String updatePrimaryIndividualAlias(String userEmail, String originAlias, String updateAlias, int tenantId) throws Exception {
		logger.debug("updatePrimaryIndividualAlias started.");
		logger.debug("userEmail={}, originAlias={}, updateAlias={}", userEmail, originAlias, updateAlias);

		String returnValue = "ERROR";

		String inputParams = "userEmail=" + URLEncoder.encode(userEmail, "UTF-8")
				+ "&originAlias=" + URLEncoder.encode(originAlias, "UTF-8")
				+ "&updateAlias=" + URLEncoder.encode(updateAlias, "UTF-8")
				+ "&tenantId=" + tenantId;
		logger.debug("inputParams=" + inputParams);

		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzHrMaster/updatePrimaryIndividualAlias";
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		logger.debug("response=" + response);

		if (response != null) {
			JSONParser jsonParser = new JSONParser();
			JSONObject responseObj = (JSONObject) jsonParser.parse(response);
			String resultCode = (String) responseObj.get("resultCode");
			Long reasonCode = (Long) responseObj.get("reasonCode");

			if (resultCode.equals("OK") && (reasonCode == 0 || reasonCode == 2)) {
				try {
					String userId = userEmail.substring(0, userEmail.indexOf("@"));
					ezOrganAdminDao.setUserPrimaryMail(userId, tenantId, updateAlias);

					if (originAlias.isEmpty()) {
						ezCommonService.insertUserConfigInfo(tenantId, userId, "userFriendlyEmailAddress", updateAlias);
					} else {
						ezCommonService.updateUserConfigInfo(tenantId, userId, "userFriendlyEmailAddress", updateAlias);
					}
					returnValue = "OK";
				} catch (IndexOutOfBoundsException ex) {
					logger.error(ex.getMessage(), ex);
				} catch (Exception ex) {
					logger.debug("set primary error!");
					logger.error(ex.getMessage(), ex);
				}
			} else if (reasonCode == -1) {
				returnValue = "OTHERUSER";
			} else if (reasonCode == -2) {
				returnValue = "INVALIDFORMAT";
			}
		}

		logger.debug("updatePrimaryIndividualAlias ended. returnValue=" + returnValue);

		return returnValue;
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, String> getAliasAddressMap(List<String> addressList, int tenantId) throws Exception {
		logger.debug("getAliasAddressMap started. tenantId=" + tenantId);
		
		Map<String, String> resultMap = new HashMap<String, String>();
		
		List<String> innerDomain = ezEmailUtil.getInnerDomain(tenantId);
		
		String inputParams = "";
		for (int i=0; i<addressList.size(); i++) {
			if (innerDomain.contains(addressList.get(i).split("@")[1])) {
				if (i == 0) {
					inputParams += "address=" + URLEncoder.encode(addressList.get(i), "UTF-8");
				} else {
					inputParams += "&address=" + URLEncoder.encode(addressList.get(i), "UTF-8");
				}
			}
		}
		logger.debug("inputParams=" + inputParams);

		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzEmail/getAliasAddressMap";
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);

		logger.debug("response=" + response);

		String resultCode = "Error";
		int reasonCode = -100; 
				
		if (response != null) {
			JSONParser jsonParser = new JSONParser();
			JSONObject responseObj = (JSONObject)jsonParser.parse(response);

			resultCode = (String)responseObj.get("resultCode");		
			
			if (resultCode.equals("OK")) {
				reasonCode = ((Long)responseObj.get("reasonCode")).intValue();
				
				if (reasonCode == 0) {
					if ((JSONObject)responseObj.get("result") != null) {
						resultMap = (JSONObject) responseObj.get("result");
					}
				}
			}
		}
		
		logger.debug("getAliasAddressMap ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);
		
		return resultMap;
	}
	
	/**
	 * 메일 보내기 서비스
	 * @param loginCookie 로그인 쿠키
	 * @param from 보내는 사람
	 * @param toArr 받는 사람
	 * @param ccArr 참조(없으면 null)
	 * @param bccArr 숨은 참조(없으면 null)
	 * @param subject 메일 제목
	 * @param content 메일 내용(html형식)
	 * @param isSaved 보낸편지함에 저장 여부
	 * @throws Exception
	 */
	@Override
	public void sendMail(String loginCookie, InternetAddress from, InternetAddress[] toArr, InternetAddress[] ccArr, InternetAddress[] bccArr, String subject, String content, boolean isSaved) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();
		String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
		String userAccount = userId + "@" + domainName;
		String password  = commonUtil.getUserIdAndPassword(loginCookie).get(1);
		
        sendMail(userAccount, password, userInfo.getLocale(), from, toArr, ccArr, bccArr, subject, content, isSaved, EmailImportance.NORMAL);
	}
	
	/**
	 * 메일 보내기 서비스
	 * @param userEmail 유저 메일 주소
	 * @param password 유저 메일 패스워드(JMochaSuperPassword)
	 * @param userLocale 유저 로케일(메세지 프로퍼티를 판별하기 위함)
	 * @param from 보내는 사람
	 * @param toArr 받는 사람
	 * @param ccArr 참조(없으면 null)
	 * @param bccArr 숨은 참조(없으면 null)
	 * @param subject 메일 제목
	 * @param content 메일 내용(html형식)
	 * @param isSaved 보낸편지함에 저장 여부
	 * @param importance 메일 중요성(low, normal, high)
	 * @throws Exception
	 */
	@Override
	public void sendMail(String userEmail, String password, Locale userLocale, InternetAddress from, InternetAddress[] toArr, InternetAddress[] ccArr, InternetAddress[] bccArr, String subject, String content, boolean isSaved, EmailImportance importance) throws Exception {
		logger.debug("sendMail started.");
		logger.debug("from=" + from + ",subject=" + subject + ",isSaved=" + isSaved);

//		IMAPAccess ia = null;
//		
//		try {
//			SMTPAccess sa = SMTPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.SMTPPort"),
//					userEmail, password);
//			
//			MimeMessage message = sa.createMimeMessage();
//			
//			// set from
//			logger.debug("from=" + from.getAddress());
//			message.setFrom(from);
//			
//			// set to
//			for (InternetAddress to : toArr) {
//				logger.debug("to=" + to.getAddress());
//				message.addRecipient(RecipientType.TO, to);
//			}
//			
//			// set cc
//			if (ccArr != null) {
//				for (InternetAddress cc : ccArr) {
//					logger.debug("cc=" + cc.getAddress());
//					message.addRecipient(RecipientType.CC, cc);
//				}
//			}
//			
//			// set bcc
//			if (bccArr != null) {
//				for (InternetAddress bcc : bccArr) {
//					logger.debug("bcc=" + bcc.getAddress());
//					message.addRecipient(RecipientType.BCC, bcc);
//				}
//			}
//			
//			// set subject
//			logger.debug("subject=" + subject);
//			message.setSubject(subject, "UTF-8");
//			
//			// set content
//			message.setContent(content, "text/html; charset=utf-8");
//			
//			// set sentDate
//	        message.setSentDate(Calendar.getInstance().getTime());
//	        
//	        // set User-Agent header
//	        message.setHeader("User-Agent", "JMocha Mail 1.0");
//	        
//			// set importance header
//			if (importance != null && importance != EmailImportance.NORMAL) {
//				message.setHeader("Importance", importance.getMappingValue());
//				message.setHeader("X-Priority", importance.getPriority());
//			}
//	        
//	        // set X-JMocha-Noti header
//	        message.setHeader("X-JMocha-Noti", "true");
//	        
//	        Transport.send(message);
//	        logger.debug("Mail send success.");
//	        
//	        if (isSaved) {
//	        	//보낸편지함에 저장
//	        	ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
//	        			userEmail, password, egovMessageSource, userLocale, ezEmailUtil);
//	        	
//	    		Folder sentFolder = ia.getFolder(ezEmailUtil.getSentFolderId(userLocale));
//	    		
//	    		if (!sentFolder.exists()) {
//	    			ia.createFolder(sentFolder.getFullName());
//	    		}
//	    		
//	    		message.setFlag(Flags.Flag.SEEN, true);
//    			sentFolder.open(Folder.READ_WRITE);
//    			sentFolder.appendMessages(new Message[]{message});
//    			sentFolder.close(true);
//    			logger.debug("Mail is successfully saved in sent folder.");
//	        }
//        
//		} catch (MessagingException e) {
//			logger.error(e.getMessage(), e);
//		} finally {
//			if (ia != null) {
//				ia.close();
//			}
//		}
		//List<OrganUserVO> retireMailList = ezOrganDao.getRetireUserMail(tenantId);
		//String domainName = userEmail.substring(userEmail.indexOf("@") + 1, userEmail.length());
		int tenantId = ezCommonService.getTenantIdByDomainName(userEmail.substring(userEmail.indexOf("@") + 1, userEmail.length()));
		int toArrLength = 0;
		int ccArrLength = 0;
		int bccArrLength = 0;

		// 퇴직자 mailList를 가져온다.
		List<String> retireMailList = ezOrganDao.getRetireUserMail(tenantId).stream().map(OrganUserVO::getMail)
				.collect(Collectors.toList());

		// 수신자 주소 중에서 퇴직자인 경우 제외한다.
		if (toArr != null) {
			InternetAddress[] reciptMailtoArr = Arrays.stream(toArr)
					.filter(addr -> !retireMailList.contains(addr.getAddress())).toArray(InternetAddress[]::new);
			toArr = reciptMailtoArr;
			toArrLength = toArr.length;
		}
		if (ccArr != null) {
			InternetAddress[] reciptMailccArr = Arrays.stream(ccArr)
					.filter(addr -> !retireMailList.contains(addr.getAddress())).toArray(InternetAddress[]::new);
			ccArr = reciptMailccArr;
			ccArrLength = ccArr.length;
		}
		if (bccArr != null) {
			InternetAddress[] reciptMailbccArr = Arrays.stream(bccArr)
					.filter(addr -> !retireMailList.contains(addr.getAddress())).toArray(InternetAddress[]::new);
			bccArr = reciptMailbccArr;
			bccArrLength = bccArr.length;
		}
		// 받는 사람, 참조, 숨은참조 모두 포함해서 수신자가 1명도 없을 경우 return
		if (toArrLength + ccArrLength + bccArrLength < 1) {
			return;
		}

		ezEmailUtil.createMail(userEmail, password)
			.from(from)
			.to(toArr)
			.cc(ccArr)
			.bcc(bccArr)
			.subject(subject)
			.content(content)
			.importance(importance)
			.saveSentMailbox(isSaved)
			.notUseAuth()
		.send();
		
        logger.debug("sendMail ended.");
	}
	
	/**
	 * 메일 보내기 서비스
	 * @param userEmail 유저 메일 주소
	 * @param password 유저 메일 패스워드(JMochaSuperPassword)
	 * @param userLocale 유저 로케일(메세지 프로퍼티를 판별하기 위함)
	 * @param from 보내는 사람
	 * @param toArr 받는 사람
	 * @param ccArr 참조(없으면 null)
	 * @param bccArr 숨은 참조(없으면 null)
	 * @param subject 메일 제목
	 * @param content 메일 내용(html형식)
	 * @throws Exception
	 */
	@Override
	public void sendMail(String userEmail, String password, Locale userLocale, InternetAddress from, InternetAddress[] toArr, InternetAddress[] ccArr, InternetAddress[] bccArr, String subject, String content) throws Exception {
		logger.debug("sendMail started.");
		logger.debug("from=" + from + ",subject=" + subject);
		
//		IMAPAccess ia = null;
//		
//		try {
//			SMTPAccess sa = SMTPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.SMTPPort"),
//					userEmail, password);
//			
//			MimeMessage message = sa.createMimeMessage();
//			
//			// set from
//			logger.debug("from=" + from.getAddress());
//			message.setFrom(from);
//			
//			// set to
//			for (InternetAddress to : toArr) {
//				logger.debug("to=" + to.getAddress());
//				message.addRecipient(RecipientType.TO, to);
//			}
//			
//			// set cc
//			if (ccArr != null) {
//				for (InternetAddress cc : ccArr) {
//					logger.debug("cc=" + cc.getAddress());
//					message.addRecipient(RecipientType.CC, cc);
//				}
//			}
//			
//			// set bcc
//			if (bccArr != null) {
//				for (InternetAddress bcc : bccArr) {
//					logger.debug("bcc=" + bcc.getAddress());
//					message.addRecipient(RecipientType.BCC, bcc);
//				}
//			}
//			
//			// set subject
//			logger.debug("subject=" + subject);
//			message.setSubject(subject, "UTF-8");
//			
//			// set content
//			message.setContent(content, "text/html; charset=utf-8");
//			
//			// set sentDate
//	        message.setSentDate(Calendar.getInstance().getTime());
//	        
//	        // set User-Agent header
//	        message.setHeader("User-Agent", "JMocha Mail 1.0");
//	        	        
//	        // set X-JMocha-Noti header
//	        message.setHeader("X-JMocha-Noti", "true");
//	        
//	        Transport.send(message);
//	        
//	        logger.debug("Mail send success.");	                
//		} catch (MessagingException e) {
//			logger.error(e.getMessage(), e);
//		} finally {
//			if (ia != null) {
//				ia.close();
//			}
//		}
		int tenantId = ezCommonService.getTenantIdByDomainName(userEmail.substring(userEmail.indexOf("@") + 1, userEmail.length()));
		int toArrLength = 0;
		int ccArrLength = 0;
		int bccArrLength = 0;
		
		// 퇴직자 mailList를 가져온다.
		List<String> retireMailList = ezOrganDao.getRetireUserMail(tenantId).stream().map(OrganUserVO::getMail)
				.collect(Collectors.toList());
		
		// 수신자 주소 중에서 퇴직자인 경우 제외한다.
		if (toArr != null) {
			InternetAddress[] reciptMailtoArr = Arrays.stream(toArr)
					.filter(addr -> !retireMailList.contains(addr.getAddress())).toArray(InternetAddress[]::new);
			toArr = reciptMailtoArr;
			toArrLength = toArr.length;
		}
		if (ccArr != null) {
			InternetAddress[] reciptMailccArr = Arrays.stream(ccArr)
					.filter(addr -> !retireMailList.contains(addr.getAddress())).toArray(InternetAddress[]::new);
			ccArr = reciptMailccArr;
			ccArrLength = ccArr.length;
		}
		if (bccArr != null) {
			InternetAddress[] reciptMailbccArr = Arrays.stream(bccArr)
					.filter(addr -> !retireMailList.contains(addr.getAddress())).toArray(InternetAddress[]::new);
			bccArr = reciptMailbccArr;
			bccArrLength = bccArr.length;
		}

		// 받는 사람, 참조, 숨은참조 모두 포함해서 수신자가 1명도 없을 경우 return
		if (toArrLength + ccArrLength + bccArrLength < 1) {
			return;
		}

		ezEmailUtil.createMail(userEmail, password)
			.from(from)
			.to(toArr)
			.cc(ccArr)
			.bcc(bccArr)
			.subject(subject)
			.content(content)
			.notUseAuth()
		.send();
		
        logger.debug("sendMail ended.");
	}
	
	/**
	 * 메일 보내기 서비스
	 * @param recipients SMTP의 rcpt to에 지정될 수신자 목록
	 * @param loginCookie 로그인 쿠키
	 * @param from 보내는 사람
	 * @param toArr 받는 사람
	 * @param ccArr 참조(없으면 null)
	 * @param bccArr 숨은 참조(없으면 null)
	 * @param subject 메일 제목
	 * @param content 메일 내용(html형식)
	 * @param isSaved 보낸편지함에 저장 여부
	 * @throws Exception
	 */
	@Override
	public void sendMailWithExplicitRecipients(InternetAddress[] recipients, String loginCookie, InternetAddress from, InternetAddress[] toArr, InternetAddress[] ccArr, InternetAddress[] bccArr, String subject, String content, boolean isSaved) throws Exception {
		logger.debug("sendMailWithExplicitRecipients started. recipients=" + recipients);
		logger.debug("from=" + from + ",subject=" + subject + ",isSaved=" + isSaved);
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();
		String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
		String userAccount = userId + "@" + domainName;
		String password  = commonUtil.getUserIdAndPassword(loginCookie).get(1);
		
		IMAPAccess ia = null;
		
		try {
			SMTPAccess sa = SMTPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.SMTPPort"),
					userAccount, password);
			
			MimeMessage message = sa.createMimeMessage();
			
			// set from
			logger.debug("from=" + from.getAddress());
			message.setFrom(from);
			
			// set to
			for (InternetAddress to : toArr) {
				logger.debug("to=" + to.getAddress());
				message.addRecipient(RecipientType.TO, to);
			}
			
			// set cc
			if (ccArr != null) {
				for (InternetAddress cc : ccArr) {
					logger.debug("cc=" + cc.getAddress());
					message.addRecipient(RecipientType.CC, cc);
				}
			}
			
			// set bcc
			if (bccArr != null) {
				for (InternetAddress bcc : bccArr) {
					logger.debug("bcc=" + bcc.getAddress());
					message.addRecipient(RecipientType.BCC, bcc);
				}
			}
			
			// set subject
			logger.debug("subject=" + subject);
			message.setSubject(subject, "UTF-8");
			
			// set content
			message.setContent(content, "text/html; charset=utf-8");
			
			// set sentDate
	        message.setSentDate(Calendar.getInstance().getTime());
	        
	        // set User-Agent header
	        message.setHeader("User-Agent", "JMocha Mail 1.0");
	        
	        // set X-JMocha-Noti header
	        message.setHeader("X-JMocha-Noti", "true");
	        
	        Transport.send(message, recipients);
	        logger.debug("Mail send success.");
	        
	        if (isSaved) {
	        	//보낸편지함에 저장
	        	ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
	        			userAccount, password, egovMessageSource, userInfo.getLocale(), ezEmailUtil);
	        	
	    		Folder sentFolder = ia.getFolder(ezEmailUtil.getSentFolderId(userInfo.getLocale()));
	    		
	    		if (!sentFolder.exists()) {
	    			ia.createFolder(sentFolder.getFullName());
	    		}
	    		
	    		message.setFlag(Flags.Flag.SEEN, true);
    			sentFolder.open(Folder.READ_WRITE);
    			sentFolder.appendMessages(new Message[]{message});
    			sentFolder.close(true);
    			logger.debug("Mail is successfully saved in sent folder.");
	        }
        
		} catch (MessagingException e) {
			logger.error(e.getMessage(), e);
		} finally {
			if (ia != null) {
				ia.close();
			}
		}
		
        logger.debug("sendMailWithExplicitRecipients ended.");
	}
	
	@Override
	public String mailContentDownload(String loginCookie, String url, String realPath) throws Exception {
		logger.debug("mailContentDownload started. url=" + url);
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String password  = commonUtil.getUserIdAndPassword(loginCookie).get(1);
		String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
        String userAccount = userInfo.getId() + "@" + domainName;
        
		String returnValue = "";
		
		try {
			int attachIDPos1 = url.indexOf("&folderPath=") + 12;
            int attachIDPos2 = url.indexOf("&uid=");
            int attachIDPos3 = url.indexOf("&contentId=");
            int attachIDPos4 = url.indexOf("&shareId=");
			
            String mailbox = url.substring(attachIDPos1, attachIDPos2);
            mailbox = URLDecoder.decode(mailbox, "utf-8");
            String uidStr = url.substring(attachIDPos2 + 5, attachIDPos3);
            String contentId = null;
            
            if (attachIDPos4 > -1) {
            	contentId = url.substring(attachIDPos3 + 11, attachIDPos4);
                
            	String shareId = url.substring(attachIDPos4 + 9);
            	shareId = URLDecoder.decode(shareId, "utf-8");
            	logger.debug("shareId=" + shareId);
            	
            	userAccount = shareId + "@" + domainName;
            } else {
            	contentId = url.substring(attachIDPos3 + 11);
            }
            
            contentId = URLDecoder.decode(contentId, "utf-8");
            
            logger.debug("mailbox=" + mailbox + ",uid=" + uidStr + ",contentId=" + contentId);
            
            IMAPAccess ia = null;
            try {
            	ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
						userAccount, password, egovMessageSource, userInfo.getLocale(), ezEmailUtil);
            	
            	Folder folder = ia.getFolder(mailbox != null ? mailbox : "");

            	if (folder != null && folder.exists()) {
            		folder.open(Folder.READ_ONLY);
        			Message message = ((IMAPFolder)folder).getMessageByUID(Long.parseLong(uidStr));
        			
        			if (message != null) {
        				MimeBodyPart part = (MimeBodyPart)ezEmailUtil.getInlinePart(message, contentId);
    					
    					if (part != null) {
    						String fileName = UUID.randomUUID().toString() + ".jpg";
    						String saveDirectory = commonUtil.getUploadPath("upload_common.ROOT", userInfo.getTenantId());
    						saveDirectory += commonUtil.separator + commonUtil.getTodayUTCTime("yyyyMMdd");
    						
    						File f = new File(realPath + saveDirectory);
    						if (!f.exists()) {
    							f.mkdirs();
    						}
    						
    						part.saveFile(realPath + saveDirectory + commonUtil.separator + fileName);
    						logger.debug(fileName + " is saved to " + saveDirectory + " temporarily.");
    						
    						returnValue = saveDirectory + commonUtil.separator + fileName;
    					}
        			}
        			
        			folder.close(false);
            	}
            } catch (MessagingException e) {
            	logger.error(e.getMessage(), e);
			} catch (Exception e) {
            	logger.error(e.getMessage(), e);
            } finally {
            	if (ia != null) {
            		ia.close();
            	}
			}
            
		} catch (IndexOutOfBoundsException e) {
			logger.error(e.getMessage(), e);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("mailContentDownload ended. returnValue=" + returnValue);
		
		return returnValue;
	}
	
	@Override
	public boolean checkMailQuota(LoginVO userInfo, String password) throws Exception {
		logger.debug("checkMailQuota started.");
		
		boolean returnValue = true;
		
		String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
		String userAccount = userInfo.getId() + "@" + domainName;
		logger.debug("userAccount=" + userAccount);
		
		IMAPAccess ia = null;
		
		try {
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userAccount, password, egovMessageSource, userInfo.getLocale(), ezEmailUtil);
					
			long[] storageUsageAndLimit = ia.getStorageUsageAndLimit();
			
			double mailboxUsage = storageUsageAndLimit[0]; // in KBs
			double mailboxQuota = storageUsageAndLimit[1]; // in KBs
			
			logger.debug("mailboxUsage=" + mailboxUsage + ",mailboxQuota=" + mailboxQuota);
			
			if (mailboxUsage >= mailboxQuota) {
				returnValue = false;
			}
		
		} catch (NullPointerException e) {
			logger.error(e.getMessage(), e);
		} catch (Exception e) {
			logger.debug(e.getMessage());
			logger.error(e.getMessage(), e);
		} finally {
			if (ia != null) {
				ia.close();
			}
		}
		
		logger.debug("checkMailQuota ended. returnValue=" + returnValue);
		return returnValue;
	}
	
	@Override
	public int getMaxMessageSize(int tenantId) throws Exception {
		logger.debug("getMaxMessageSize started. tenantId=" + tenantId);
		
		int size = 0;
		
		String inputParams = "tenantId=" + tenantId;
		logger.debug("inputParams=" + inputParams);

		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzEmail/getMaxMessageSize";
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		logger.debug("response=" + response);

		String resultCode = "Error";
		int reasonCode = -100; 
				
		if (response != null) {
			JSONParser jsonParser = new JSONParser();
			JSONObject responseObj = (JSONObject)jsonParser.parse(response);

			resultCode = (String)responseObj.get("resultCode");		
			
			if (resultCode.equals("OK")) {
				reasonCode = ((Long)responseObj.get("reasonCode")).intValue();
				
				if (reasonCode == 0 && responseObj.get("result") != null) {
					String sizeStr = (String)responseObj.get("result");
					size = Integer.parseInt(sizeStr);
				}
			}
		}
		
		logger.debug("getMaxMessageSize ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode + ",size=" + size);
		
		return size;
	}
	
	@Override
	public List<String[]> getAliasAddress(String userId, int tenantId, String useFromAddress, String useDistributionSender) throws Exception {
		logger.debug("getAliasAddress started. userId=" + userId);
		
		String domainName = ezCommonService.getTenantConfig("DomainName", tenantId);
		String userAccount = userId + "@" + domainName;
				
		String inputParams = "userId=" + URLEncoder.encode(userAccount, "UTF-8")
				+ "&useFromAddress=" + URLEncoder.encode(useFromAddress, "UTF-8")
				+ "&useDistributionSender=" + URLEncoder.encode(useDistributionSender, "UTF-8");
		logger.debug("inputParams=" + inputParams);

		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzEmail/getAliasAddress";
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		logger.debug("response=" + response);

		String resultCode = "Error";
		int reasonCode = -100; 
		List<String[]> aliasAddressList = new ArrayList<String[]>();	
		
		if (response != null) {
			JSONParser jsonParser = new JSONParser();
			JSONObject responseObj = (JSONObject)jsonParser.parse(response);

			resultCode = (String)responseObj.get("resultCode");		
			
			if (resultCode.equals("OK")) {
				reasonCode = ((Long)responseObj.get("reasonCode")).intValue();
				
				if (reasonCode == 0) {
					JSONArray resultArray = (JSONArray)responseObj.get("result");
					
					for (int i=0; i<resultArray.size(); i++) {
						JSONObject obj = (JSONObject)resultArray.get(i);
						aliasAddressList.add(new String[] {obj.get("address").toString().trim(), obj.get("type").toString().trim(), obj.get("name").toString().trim()});
					}
				}
			}
		}						
		
		logger.debug("getAliasAddress ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);
		
		return aliasAddressList;		
	}

	@Override
	public List<Map<String, String>> getMailListT(LoginVO userInfo, String password, String dateTime, int count) throws Exception {
		logger.debug("getMailListT started.");
		
		List<Map<String, String>> list = new ArrayList<Map<String, String>>();
		
		String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
		String userEmail = userInfo.getId() + "@" + domainName;
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		
		IMAPAccess ia = null;
		
		try {
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userEmail, password, egovMessageSource, userInfo.getLocale(), 40*1000, 20*1000, ezEmailUtil);
		
			Folder folder = ia.getFolder(ezEmailUtil.getInboxFolderId());		
			folder.open(Folder.READ_ONLY);
			
	        Message[] messages = ezEmailUtil.searchFolder(ia, userEmail, folder, "", "", null, sdf.parse(dateTime), false, 
	        		true, false, "receivedDate", false, 0, 30, true, null, userInfo.getTenantId(), "");
	        
	        for (int i=0; i<messages.length; i++) {
	        	Message message = messages[i];
	        	UIDFolder uidFolder = (UIDFolder)message.getFolder();
	        	
	        	Date receivedDate = message.getReceivedDate();
	        	String receivedDateStr = sdf.format(receivedDate);
//	        	receivedDateStr = commonUtil.getDateStringInUTC(receivedDateStr, userInfo.getOffset(), false);
	        	
	        	String subject = ezEmailUtil.getSubject(message);
				subject = (subject != null) ? subject : "";
	        	
				EmailImportance importance = EmailImportance.byMessage(message);

	        	Map<String, String> map = new HashMap<String, String>();
	        	map.put("subject", subject);
	        	map.put("sender", ezEmailUtil.getFromNameOrAddressOfMessage(message));
	        	map.put("receivedDate", receivedDateStr);
	        	map.put("uid", String.valueOf(uidFolder.getUID(message)));
				// 중요도: low = 0, normal = 1, high = 2
				map.put("importance", Integer.toString(importance.ordinal()));
	        	
	        	list.add(map);
	        }
		} catch (MessagingException e) {
			logger.error(e.getMessage(), e);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		} finally {
			if (ia != null) {
				ia.close();
			}
		}
		
		logger.debug("getMailListT ended.");
		return list;
	}
	
	@Override
	public List<MailDistributionVO> getDistributionList(String companyId, int tenantId) throws Exception {
		logger.debug("getDistributionList started.");
		logger.debug("companyId=" + companyId + ",tenantId=" + tenantId);
		
		String domain = ezCommonService.getTenantConfig("DomainName", tenantId);
				
		String inputParams = "companyId=" + URLEncoder.encode(companyId, "UTF-8");
		inputParams += "&domain=" + URLEncoder.encode(domain, "UTF-8");
		logger.debug("inputParams=" + inputParams);

		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaAccess/getDistributionList";			
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		logger.debug("response=" + response);

		String resultCode = "Error";
		int reasonCode = -100; 
		List<MailDistributionVO> distributionList = new ArrayList<MailDistributionVO>();	
		
		if (response != null) {
			JSONParser jsonParser = new JSONParser();
			JSONObject responseObj = (JSONObject)jsonParser.parse(response);

			resultCode = (String)responseObj.get("resultCode");		
			
			if (resultCode.equals("OK")) {
				reasonCode = ((Long)responseObj.get("reasonCode")).intValue();
				
				if (reasonCode == 0) {
					JSONArray resultArray = (JSONArray)responseObj.get("result");
					
					for (int i=0; i<resultArray.size(); i++) {
						MailDistributionVO vo = new MailDistributionVO();
						
						JSONObject obj = (JSONObject)resultArray.get(i);
						
						vo.setName((String)obj.get("distributionName"));
						vo.setId((String)obj.get("distributionId"));
						vo.setMail((String)obj.get("distributionMail"));
						
						distributionList.add(vo);
					}
				}
			}
		}						
		
		logger.debug("getDistributionList ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);
		logger.debug(distributionList.toString());
		
		return distributionList;
	}
	
	@Override
	public List<MailDistributionVO> getDistributionSearchList(String companyId, int tenantId, String searchValue) throws Exception {
		logger.debug("getDistributionSearchList started.");
		logger.debug("companyId=" + companyId + ",tenantId=" + tenantId + ",searchValue=" + searchValue);
		
		String domain = ezCommonService.getTenantConfig("DomainName", tenantId);
		String inputParams = "companyId=" + URLEncoder.encode(companyId, "UTF-8");
		inputParams += "&domain=" + URLEncoder.encode(domain, "UTF-8");
		inputParams += "&searchValue=" + URLEncoder.encode(searchValue, "UTF-8");
		logger.debug("inputParams=" + inputParams);

		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaAccess/getDistributionSearchList";			
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		logger.debug("response=" + response);

		String resultCode = "Error";
		int reasonCode = -100;
		List<MailDistributionVO> distributionList = new ArrayList<MailDistributionVO>();	
		
		if (response != null) {
			JSONParser jsonParser = new JSONParser();
			JSONObject responseObj = (JSONObject)jsonParser.parse(response);

			resultCode = (String)responseObj.get("resultCode");		
			
			if (resultCode.equals("OK")) {
				reasonCode = ((Long)responseObj.get("reasonCode")).intValue();
				
				if (reasonCode == 0) {
					JSONArray resultArray = (JSONArray)responseObj.get("result");
					
					for (int i=0; i<resultArray.size(); i++) {
						MailDistributionVO vo = new MailDistributionVO();
						
						JSONObject obj = (JSONObject)resultArray.get(i);
						
						vo.setName((String)obj.get("distributionName"));
						vo.setId((String)obj.get("distributionId"));
						vo.setMail((String)obj.get("distributionMail"));
						
						distributionList.add(vo);
					}
				}
			}
		}
		
		logger.debug("getDistributionSearchList ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);
		logger.debug(distributionList.toString());
		
		return distributionList;
	}

	@Override
	public List<MailDistributionVO> getDistributionSearchListByItem(String companyId, int tenantId, String searchValue, String searchType) throws Exception {
		logger.debug("getDistributionSearchListByItem started.");
		logger.debug("companyId=" + companyId + ",tenantId=" + tenantId + ",searchValue=" + searchValue + ",searchType=" + searchType);
		
		String domain = ezCommonService.getTenantConfig("DomainName", tenantId);
		String inputParams = "companyId=" + URLEncoder.encode(companyId, "UTF-8");
		inputParams += "&domain=" + URLEncoder.encode(domain, "UTF-8");
		inputParams += "&searchType=" + URLEncoder.encode(searchType, "UTF-8");
		inputParams += "&searchValue=" + URLEncoder.encode(searchValue, "UTF-8");
		logger.debug("inputParams=" + inputParams);

		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaAccess/getDistributionSearchListByItem";			
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		logger.debug("response=" + response);

		String resultCode = "Error";
		int reasonCode = -100;
		List<MailDistributionVO> distributionList = new ArrayList<MailDistributionVO>();	
		
		if (response != null) {
			JSONParser jsonParser = new JSONParser();
			JSONObject responseObj = (JSONObject)jsonParser.parse(response);

			resultCode = (String)responseObj.get("resultCode");		
			
			if (resultCode.equals("OK")) {
				reasonCode = ((Long)responseObj.get("reasonCode")).intValue();
				
				if (reasonCode == 0) {
					JSONArray resultArray = (JSONArray)responseObj.get("result");
					
					for (int i=0; i<resultArray.size(); i++) {
						MailDistributionVO vo = new MailDistributionVO();
						
						JSONObject obj = (JSONObject)resultArray.get(i);
						
						vo.setName((String)obj.get("distributionName"));
						vo.setId((String)obj.get("distributionId"));
						vo.setMail((String)obj.get("distributionMail"));
						
						distributionList.add(vo);
					}
				}
			}
		}
		
		logger.debug("getDistributionSearchListByItem ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);
		logger.debug(distributionList.toString());
		
		return distributionList;
	}
	
	@Override
	public MailSignatureVO getInitMailSignature(int tenantId) throws Exception {
		logger.debug("getInitMailSignature started. tenantId=" + tenantId);
		
		MailSignatureVO mailSignatureVO = null;
		String domain = ezCommonService.getTenantConfig("DomainName", tenantId);
		
		String inputParams = "userId=" + URLEncoder.encode(domain, "UTF-8");
		logger.debug("inputParams=" + inputParams);
		
		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzEmail/getMailSignature";
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		
		if (response != null) {
			JSONParser jsonParser = new JSONParser();
			JSONObject responseObj = (JSONObject)jsonParser.parse(response);
			
			if (((String)responseObj.get("resultCode")).equals("OK") && (Long)responseObj.get("reasonCode") == 0) {
				JSONObject obj = (JSONObject)responseObj.get("result");
	        	
	        	if (obj != null) {
	        		mailSignatureVO = new MailSignatureVO();
	        		
	        		mailSignatureVO.setUseFlag((String)obj.get("useFlag"));
	        		mailSignatureVO.setContent1((String)obj.get("content1"));
	        		mailSignatureVO.setContent2((String)obj.get("content2"));
	        		mailSignatureVO.setContent3((String)obj.get("content3"));
	        	}
			}
		}
		
		logger.debug("getInitMailSignature ended.");
		return mailSignatureVO;
	}
	
	@Override
	public boolean addEzTalkNotification(String userId, String senderName, String subject, String mainType, String subType, String linkURL) {
		logger.debug("addEzTalkNotification started. userId={}, senderName={}, mainType={}, subType={}, linkURL", userId, senderName, mainType, subType, linkURL);
		
		boolean returnValue = false;
		
		try {
			// null 인 경우는 empty string으로 대체한다.
			userId = userId != null ? userId : "";
			senderName = senderName != null ? senderName : "";
			subject = subject != null ? subject : "";
			mainType = StringUtils.defaultString(mainType);
			subType = StringUtils.defaultString(subType);
			linkURL = linkURL != null ? linkURL : "";
			
			String userIdParam = "userId=" + userId;
			String senderNameParam = "senderName=" + URLEncoder.encode(senderName, "UTF-8");
			String subjectParam = "subject=" + URLEncoder.encode(subject, "UTF-8");
			String typeParam = "type=" + mainType;
			String subParam = "subType=" + subType;
			
			String inputParams = userIdParam + "&" + senderNameParam + "&" + subjectParam + "&" + typeParam + "&" + subParam;

			if (!linkURL.isEmpty()) {
				String linkURLParam = "linkURL=" + URLEncoder.encode(linkURL, "UTF-8");
				inputParams += "&" + linkURLParam;
			}
	
			logger.debug("inputParams=" + inputParams);
			
			String requestURL = config.getProperty("config.JGwServerURL") + "/ezTalkGate/addNotification";			
			String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
			
			if (response != null) {
				JSONParser jsonParser = new JSONParser();
				JSONObject responseObj = (JSONObject)jsonParser.parse(response);
				
				if (((String)responseObj.get("resultCode")).equals("OK") && (Long)responseObj.get("reasonCode") == 0) {
					returnValue = true;
				}
			}
		} catch (UnsupportedEncodingException e) {
			logger.error(e.getMessage(), e);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("addEzTalkNotification ended. returnValue=" + returnValue);
		
		return returnValue;
	}
	
	@Override
	public boolean setInitInboxRule(int tenantId, String userId) throws Exception {
		logger.debug("setInitInboxRule started.");
		logger.debug("tenantId=" + tenantId + ",userId=" + userId);
		
		boolean returnValue = false;
		String domain = ezCommonService.getTenantConfig("DomainName", tenantId);
		String userAccount = userId + "@" + domain;
		
		String inputParams = "userId=" + URLEncoder.encode(userAccount, "UTF-8");
		logger.debug("inputParams=" + inputParams);
		
		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaAccess/setInitInboxRule";			
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		
		if (response != null) {
			JSONParser jsonParser = new JSONParser();
			JSONObject responseObj = (JSONObject)jsonParser.parse(response);
			
			if (((String)responseObj.get("resultCode")).equals("OK") && (Long)responseObj.get("reasonCode") == 0) {
				returnValue = true;
			}
		}
		
		logger.debug("setInitInboxRule ended. returnValue=" + returnValue);
		return returnValue;
	}

	@Override
	public List<String> getInitInboxRuleMailbox(int tenantId) throws Exception {
		logger.debug("getInitInboxRuleMailbox started. tenantId=" + tenantId);
		
		List<String> mailboxList = new ArrayList<String>();
		String domain = ezCommonService.getTenantConfig("DomainName", tenantId);
		
		String inputParams = "domain=" + domain;
		logger.debug("inputParams=" + inputParams);
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaAccess/getInitInboxRuleMailbox", inputParams);
		logger.debug("strJson=" + strJson);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(strJson);
		
		if (object.get("resultCode").equals("OK") && ((Long)object.get("reasonCode")).intValue() == 0) {
	    	JSONArray resultArray = (JSONArray)object.get("result");
	    	
	    	for (int i=0; i<resultArray.size(); i++) {
	    		mailboxList.add((String)resultArray.get(i));
	    	}
		}
		
		logger.debug("getInitInboxRuleMailbox ended.");
		return mailboxList;
	}

	@Override
	public int setMailSecure(int tenantId, String userId, String password, int maxReadCount,
			String maxReadDate) throws Exception {
		logger.debug("setMailSecure started.");
		logger.debug("tenantId=" + tenantId + ",userId=" + userId
				+ ",password=" + password + ",maxReadCount=" + maxReadCount + ",maxReadDate=" + maxReadDate);
		
		int returnValue = 0;
		
		String domainName = ezCommonService.getTenantConfig("DomainName", tenantId);
		String userAccount = userId + "@" + domainName;
		
		String inputParams = "userAccount=" + URLEncoder.encode(userAccount, "UTF-8");
		inputParams += "&password=" + URLEncoder.encode(password, "UTF-8");
		inputParams += "&maxReadCount=" + maxReadCount;
		inputParams += "&maxReadDate=" + URLEncoder.encode(maxReadDate, "UTF-8");
		logger.debug("inputParams=" + inputParams);

		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzEmail/setMailSecure";			
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		logger.debug("response=" + response);

		if (response != null) {
			JSONParser jsonParser = new JSONParser();
			JSONObject responseObj = (JSONObject)jsonParser.parse(response);
			
			if (((String)responseObj.get("resultCode")).equals("OK") && (Long)responseObj.get("reasonCode") == 0) {
				int secureId = ((Long)responseObj.get("result")).intValue();
				
				if (secureId != 0) {
					returnValue = secureId;
				}
			}
		}
		
		logger.debug("setMailSecure ended. returnValue=" + returnValue);
		return returnValue;
	}

	@Override
	public String updateMailSecure(int tenantId, String userId, int secureId, String url) throws Exception {
		logger.debug("updateMailSecure started.");
		logger.debug("tenantId=" + tenantId + ",userId=" + userId + ",secureId=" + secureId + ",url=" + url);
		
		String returnValue = "ERROR";
		
		String domainName = ezCommonService.getTenantConfig("DomainName", tenantId);
		String userAccount = userId + "@" + domainName;
		
		String inputParams = "userAccount=" + URLEncoder.encode(userAccount, "UTF-8");
		inputParams += "&url=" + URLEncoder.encode(url, "UTF-8");
		inputParams += "&secureId=" + secureId;
		logger.debug("inputParams=" + inputParams);

		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzEmail/updateMailSecure";			
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		logger.debug("response=" + response);

		if (response != null) {
			JSONParser jsonParser = new JSONParser();
			JSONObject responseObj = (JSONObject)jsonParser.parse(response);
			
			if (((String)responseObj.get("resultCode")).equals("OK") && (Long)responseObj.get("reasonCode") == 0) {
				returnValue = "OK";
			}
		}
		
		logger.debug("updateMailSecure ended. returnValue=" + returnValue);
		return returnValue;
		
	}

	@Override
	public int checkSecureMailPassword(String secureId, String reader, String password) throws Exception {
		logger.debug("checkSecureMailPassword started.");
		logger.debug("secureId=" + secureId + ",reader=" + reader + ",password=" + password);
		
		String inputParams = "secureId=" + secureId;
		inputParams += "&reader=" + URLEncoder.encode(reader, "UTF-8");
		inputParams += "&password=" + URLEncoder.encode(password, "UTF-8");
		logger.debug("inputParams=" + inputParams);

		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzEmail/checkSecureMailPassword";			
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		logger.debug("response=" + response);
		
		int returnValue = -100;
		
		if (response != null) {
			JSONParser jsonParser = new JSONParser();
			JSONObject responseObj = (JSONObject)jsonParser.parse(response);
			
			if (((String)responseObj.get("resultCode")).equals("OK")) {
				returnValue = ((Long)responseObj.get("reasonCode")).intValue();
			} else {
				throw new Exception("JGwServer ERROR");
			}
		}
		
		logger.debug("checkSecureMailPassword ended.");
		return returnValue;
	}

	@Override
	public MailSecureVO getSecureMailInfo(String secureId, String reader) throws Exception {
		logger.debug("getSecureMailInfo started.");
		logger.debug("secureId=" + secureId + ",reader=" + reader);
		
		String inputParams = "secureId=" + secureId;
		inputParams += "&reader=" + URLEncoder.encode(reader, "UTF-8");
		logger.debug("inputParams=" + inputParams);

		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzEmail/getSecureMailInfo";			
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		logger.debug("response=" + response);
		
		MailSecureVO vo = null;
		
		if (response != null) {
			JSONParser jsonParser = new JSONParser();
			JSONObject responseObj = (JSONObject)jsonParser.parse(response);
			
			if (((String)responseObj.get("resultCode")).equals("OK") && (Long)responseObj.get("reasonCode") == 0) {
				JSONObject obj = (JSONObject)responseObj.get("result");
				
				vo = new MailSecureVO();
				vo.setUserAccount((String)obj.get("userAccount"));
        		vo.setFolderPath((String)obj.get("folderPath"));
        		vo.setMailUid((String)obj.get("mailUid"));
        		vo.setMaxReadCount((String)obj.get("maxReadCount"));
        		vo.setMaxReadDate((String)obj.get("maxReadDate"));
        		vo.setReadCount((String)obj.get("readCount"));
			} else {
				throw new Exception("JGwServer ERROR");
			}
		}
		
		logger.debug("getSecureMailInfo ended.");
		return vo;
	}

	@Override
	public String updateSecureMailReaderInfo(String secureId, String reader) throws Exception {
		logger.debug("updateSecureMailReaderInfo started.");
		logger.debug("secureId=" + secureId + ",reader=" + reader);
		
		String inputParams = "secureId=" + secureId;
		inputParams += "&reader=" + URLEncoder.encode(reader, "UTF-8");
		logger.debug("inputParams=" + inputParams);

		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzEmail/updateSecureMailReaderInfo";			
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		logger.debug("response=" + response);
		
		String returnValue = "ERROR";
		
		if (response != null) {
			JSONParser jsonParser = new JSONParser();
			JSONObject responseObj = (JSONObject)jsonParser.parse(response);
			
			if (((String)responseObj.get("resultCode")).equals("OK") && (Long)responseObj.get("reasonCode") == 0) {
				returnValue = "OK";
			}
		}
		
		logger.debug("updateSecureMailReaderInfo ended.");
		return returnValue;
	}

	@Override
	public MailSecureVO getSecureMailInfoWithPassword(String secureId) throws Exception {
		logger.debug("getSecureMailInfoWithPassword started.");
		logger.debug("secureId=" + secureId);
		
		String inputParams = "secureId=" + secureId;
		logger.debug("inputParams=" + inputParams);

		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzEmail/getSecureMailInfoWithPassword";			
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		logger.debug("response=" + response);
		
		MailSecureVO vo = null;
		
		if (response != null) {
			JSONParser jsonParser = new JSONParser();
			JSONObject responseObj = (JSONObject)jsonParser.parse(response);
			
			if (((String)responseObj.get("resultCode")).equals("OK") && (Long)responseObj.get("reasonCode") == 0) {
				JSONObject obj = (JSONObject)responseObj.get("result");
				
				vo = new MailSecureVO();
				vo.setPassword((String)obj.get("password"));
        		vo.setMaxReadCount((String)obj.get("maxReadCount"));
        		vo.setMaxReadDate((String)obj.get("maxReadDate"));
			} else {
				throw new Exception("JGwServer ERROR");
			}
		}
		
		logger.debug("getSecureMailInfoWithPassword ended.");
		return vo;
	}
	
	@Override
	public MailSecureVO getSecureMailInfoWithPassword(String userId, int tenantId, String url) throws Exception {
		logger.debug("getSecureMailInfoWithPassword started.");
		logger.debug("userId=" + userId + ",tenantId=" + tenantId + ",url=" + url);
		
		String domainName = ezCommonService.getTenantConfig("DomainName", tenantId);
		String userAccount = userId + "@" + domainName;
		
		String inputParams = "userAccount=" + URLEncoder.encode(userAccount, "UTF-8");
		inputParams += "&url=" + URLEncoder.encode(url, "UTF-8");
		logger.debug("inputParams=" + inputParams);

		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzEmail/getSecureMailInfoWithPassword2";			
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		logger.debug("response=" + response);
		
		MailSecureVO vo = null;
		
		if (response != null) {
			JSONParser jsonParser = new JSONParser();
			JSONObject responseObj = (JSONObject)jsonParser.parse(response);
			
			if (((String)responseObj.get("resultCode")).equals("OK") && (Long)responseObj.get("reasonCode") == 0) {
				JSONObject obj = (JSONObject)responseObj.get("result");
				
				vo = new MailSecureVO();
				vo.setSecureId((String)obj.get("secureId"));
				vo.setPassword((String)obj.get("password"));
        		vo.setMaxReadCount((String)obj.get("maxReadCount"));
        		vo.setMaxReadDate((String)obj.get("maxReadDate"));
			} else {
				throw new Exception("JGwServer ERROR");
			}
		}
		
		logger.debug("getSecureMailInfoWithPassword ended.");
		return vo;
	}
	
	@Override
	public List<MailSecureReaderVO> getSecureMailReaderInfo(String secureId) throws Exception {
		logger.debug("getSecureMailReaderInfo started.");
		logger.debug("secureId=" + secureId);
		
		String inputParams = "secureId=" + secureId;
		logger.debug("inputParams=" + inputParams);

		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzEmail/getSecureMailReaderInfo";			
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);

		logger.debug("response=" + response);
		
		List<MailSecureReaderVO> list = new ArrayList<MailSecureReaderVO>();
		
		if (response != null) {
			JSONParser jsonParser = new JSONParser();
			JSONObject responseObj = (JSONObject)jsonParser.parse(response);
			
			if (((String)responseObj.get("resultCode")).equals("OK") && (Long)responseObj.get("reasonCode") == 0) {
				JSONArray array = (JSONArray)responseObj.get("result");
				
				MailSecureReaderVO vo = null;
				JSONObject obj = null;
				
				for (int i = 0; i < array.size(); i++) {
					obj = (JSONObject)array.get(i);
					vo = new MailSecureReaderVO();
					
					vo.setReader((String)obj.get("reader"));
					vo.setReadCount((String)obj.get("readCount"));
					vo.setReadDate((String)obj.get("readDate"));
					
					list.add(vo);
				}
			} else {
				throw new Exception("JGwServer ERROR");
			}
		}
		
		logger.debug("getSecureMailReaderInfo ended.");
		return list;
	}
	
	@Override
	public String checkDistributionIsIncluded(String standardCn, String searchCn, int tenantId) throws Exception {
		logger.debug("checkDistributionIsIncluded started.");
		logger.debug("standardCn=" + standardCn + ", searchCn=" + searchCn);
		
		String isIncluded = "NO";
		
		String domainName = ezCommonService.getTenantConfig("DomainName", tenantId);
		String inputParams = "cn=" + searchCn + "&domain=" + domainName;
		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaAccess/getDistribution";
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		
		logger.debug("response=" + response);
		
		if (response != null) {
			JSONParser jsonParser = new JSONParser();
			JSONObject responseObj = (JSONObject)jsonParser.parse(response);
			
			if (((String)responseObj.get("resultCode")).equals("OK") && (Long)responseObj.get("reasonCode") == 0) {
				JSONArray array = (JSONArray)responseObj.get("result");
				
				if (array != null) {
					JSONObject obj = null;
					while (isIncluded.equals("NO")) {
						
						if (array.toString().indexOf("group") != -1) {
							for (int i = 0; i < array.size(); i++) {
								obj = (JSONObject)array.get(i);
								if (((String)obj.get("class")).equals("group")) {
									String resultAddress[] = ((String)obj.get("cn")).split("@");
									String resultCn = resultAddress[0];
									
									if (resultCn.equals(standardCn)) {
										isIncluded = "YES";
										break;
									} else {
										isIncluded = checkDistributionIsIncluded(standardCn, resultCn, tenantId);
									}
								} 
							}
						} else {
							isIncluded = "NO";
							break;
						}
					}
				} else {
					throw new Exception("JGwServer ERROR");
				}
			}
		}
			
		logger.debug("checkDistributionIsIncluded ended.");
		return isIncluded;
	}
	
	@Override
	public List<MailDistributionVO> getDistributioUpperList(String userName, int tenantId) throws Exception {
		logger.debug("getDistributioUpperList started.");
		logger.debug("userName = " + userName + ",tenantId=" + tenantId);
		
		String domain = ezCommonService.getTenantConfig("DomainName", tenantId);
		
		String inputParams = "userName=" + URLEncoder.encode(userName, "UTF-8");
		inputParams += "&domain=" + URLEncoder.encode(domain, "UTF-8");
		logger.debug("inputParams=" + inputParams);
		
		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaAccess/getDistributioIncludednList";			
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		logger.debug("response=" + response);
		
		String resultCode = "Error";
		int reasonCode = -100; 
		List<MailDistributionVO> distributionList = new ArrayList<MailDistributionVO>();
		List<MailDistributionVO> distributionUpperList = null;
		
		if (response != null) {
			JSONParser jsonParser = new JSONParser();
			JSONObject responseObj = (JSONObject)jsonParser.parse(response);
			
			resultCode = (String)responseObj.get("resultCode");		
			
			if (resultCode.equals("OK")) {
				reasonCode = ((Long)responseObj.get("reasonCode")).intValue();
				
				if (reasonCode == 0) {
					JSONArray resultArray = (JSONArray)responseObj.get("result");
					
					if (resultArray != null &&  resultArray.size() > 0) {
						for (int i=0; i<resultArray.size(); i++) {
							MailDistributionVO vo = new MailDistributionVO();
							
							JSONObject obj = (JSONObject)resultArray.get(i);
							
							vo.setName((String)obj.get("distributionName"));
							vo.setId((String)obj.get("distributionId"));
							vo.setMail((String)obj.get("distributionMail"));
							
							distributionList.add(vo);
							
							distributionUpperList = getDistributioUpperList(vo.getId(), tenantId);
							if (distributionUpperList != null && distributionUpperList.size() >0) {
								for (MailDistributionVO upperVO : distributionUpperList) {
									distributionList.add(upperVO);
								}
							}
						}
					}
				}
			}
		}						
		
		logger.debug("getDistributioUpperList ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);
		logger.debug(distributionList.toString());
		
		return distributionList;
	}
	
	@Override
	public List<String> aliasMailCheck(String address) throws Exception {
		logger.debug("aliasMailCheck started.");
		List<String> resultList = new ArrayList<String>();

		String inputParams = "address=" + URLEncoder.encode(address, "UTF-8");
		
		logger.debug("inputParams=" + inputParams);
		
		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaAccess/getAliasMail";
		String strJson = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		
		logger.debug("strJson=" + strJson);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(strJson);
        
        if (object.get("resultCode").equals("OK")) {
        	JSONArray array = (JSONArray)object.get("result");
        	
        	if (array != null) { 
        		int len = array.size();
        		for (int i=0; i<len; i++){ 
        			resultList.add((String)array.get(i));
        		} 
        	} 
        }
		
        logger.debug("usercnt=" + resultList.size());
		logger.debug("aliasMailCheck ended.");
		
		return resultList;
	}
	
	@Override
	public List<Map<String, String>> getUserSharedMailboxList(String userId, boolean useUnreadCount, int tenantId) throws Exception {
		logger.debug("getUserSharedMailboxList started.");
		logger.debug("userId=" + userId + ",useUnreadCount=" + useUnreadCount + ",tenantId=" + tenantId);
		
		List<Map<String, String>> list = new ArrayList<Map<String, String>>();
		
		String domain = ezCommonService.getTenantConfig("DomainName", tenantId);
		
		String tenantIdParam = "tenantId=" + tenantId;
		String domainParam = "domain=" + URLEncoder.encode(domain, "UTF-8");
		String userIdParam = "userId=" + URLEncoder.encode(userId, "UTF-8");
		String useUnreadCountParam = "useUnreadCount=" + useUnreadCount;
		String inputParams = tenantIdParam + "&" + domainParam + "&" + userIdParam + "&" + useUnreadCountParam;
		logger.debug("inputParams=" + inputParams);
		
		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzEmail/getUserSharedMailboxList";
		String strJson = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		logger.debug("strJson=" + strJson);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(strJson);
        
        if (object.get("resultCode").equals("OK")) {
        	JSONArray array = (JSONArray)object.get("result");
        	
        	if (array != null) {
        		int length = array.size();
        		Map<String, String> map = null;
        		
        		for (int i = 0; i < length; i++) {
        			JSONObject obj = (JSONObject)array.get(i);
        			
        			map = new HashMap<String, String>();
        			map.put("shareId", (String)obj.get("shareId"));
        			map.put("deletePermission", (String)obj.get("deletePermission"));
        			map.put("sendPermission", (String)obj.get("sendPermission"));
        			map.put("managePermission", (String)obj.get("managePermission"));
    				map.put("shareName", (String)obj.get("shareName"));
        			map.put("mail", (String)obj.get("mail"));
        			map.put("compId", (String)obj.get("compId"));
        			map.put("enable", (String)obj.get("enable"));

        			if (useUnreadCount) {
        				map.put("totalUnreadCount", (String)obj.get("totalUnreadCount"));
        			}
        			
        			list.add(map);
        		}
        	}
        }
		
		logger.debug("getUserSharedMailboxList ended.");
		return list;
	}
	
	@Override
	public boolean checkUserShareId(String userId, String shareId, int tenantId) throws Exception {
		return checkUserShareId(userId, shareId, 0, tenantId);
	}
	
	@Override
	public boolean checkUserShareId(String userId, String shareId, int permissionType, int tenantId) throws Exception {
		logger.debug("checkUserShareId started.");
		logger.debug("userId=" + userId + ",shareId=" + shareId + ",permissionType=" + permissionType + ",tenantId=" + tenantId);
		
		boolean result = false;
		
		String tenantIdParam = "tenantId=" + tenantId;
		String userIdParam = "userId=" + URLEncoder.encode(userId, "UTF-8");
		String shareIdParam = "shareId=" + URLEncoder.encode(shareId, "UTF-8");
		String permissionTypeParam = "permissionType=" + permissionType;
		String inputParams = tenantIdParam + "&" + userIdParam + "&" + shareIdParam + "&" + permissionTypeParam;
		logger.debug("inputParams=" + inputParams);
		
		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzEmail/checkUserShareId";
		String strJson = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		logger.debug("strJson=" + strJson);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(strJson);
        
        if (((String)object.get("resultCode")).equals("OK") && (Long)object.get("reasonCode") == 0) {
        	result = (boolean)object.get("result");
        }
		
		logger.debug("checkUserShareId ended.");
		return result;
	}
	
	@Override
	public List<MailSharedMailboxVO> getSharedMailboxList(String compId, int tenantId) throws Exception {
		logger.debug("getSharedMailboxList started.");
		logger.debug("compId=" + compId + ",tenantId=" + tenantId);
		
		List<MailSharedMailboxVO> list = new ArrayList<MailSharedMailboxVO>();
		
		String tenantIdParam = "tenantId=" + tenantId;
		String compIdParam = "compId=" + URLEncoder.encode(compId, "UTF-8");
		String inputParams = tenantIdParam + "&" + compIdParam;
		logger.debug("inputParams=" + inputParams);
		
		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzEmail/getSharedMailboxList";
		String strJson = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		logger.debug("strJson=" + strJson);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(strJson);
        
        if (((String)object.get("resultCode")).equals("OK") && (Long)object.get("reasonCode") == 0) {
        	JSONArray sharedMailboxArray = (JSONArray)object.get("result");
        	
        	if (sharedMailboxArray != null) {
        		MailSharedMailboxVO vo = null;
        		
        		for (int i = 0; i < sharedMailboxArray.size(); i++) {
        			JSONObject sharedMailbox = (JSONObject)sharedMailboxArray.get(i);
        			vo = new MailSharedMailboxVO();
        			
        			vo.setShareId((String)sharedMailbox.get("shareId"));
        			vo.setShareMail((String)sharedMailbox.get("shareMail"));
        			vo.setShareName((String)sharedMailbox.get("shareName"));
        			
        			list.add(vo);
        		}
        	}
        }
		
		logger.debug("getSharedMailboxList ended.");
		return list;
	}
	
	@Override
	public MailSharedMailboxVO getSharedMailboxInfo(String shareId, int tenantId) throws Exception {
		return getSharedMailboxInfo(shareId, tenantId, null);
	}
	
	@Override
	public MailSharedMailboxVO getSharedMailboxInfo(String shareId, int tenantId, String lang) throws Exception {
		logger.debug("getSharedMailboxInfo started.");
		
		lang = (lang != null && !"1".equals(lang)) ? "2" : "";
		logger.debug("shareId={}, tenantId={}, lang={}",shareId , tenantId, lang);
		
		MailSharedMailboxVO sharedMailboxInfo = null;
		
		String tenantIdParam = "tenantId=" + tenantId;
		String shareIdParam = "shareId=" + URLEncoder.encode(shareId, "UTF-8");
		String inputParams = tenantIdParam + "&" + shareIdParam;
		logger.debug("inputParams=" + inputParams);
		
		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzEmail/getSharedMailboxInfo";
		String strJson = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		logger.debug("strJson=" + strJson);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(strJson);
        
        if (((String)object.get("resultCode")).equals("OK") && (Long)object.get("reasonCode") == 0) {
        	JSONObject result = (JSONObject)object.get("result");
        	
        	if (result != null) {
        		sharedMailboxInfo = new MailSharedMailboxVO();
        		
        		sharedMailboxInfo.setShareId((String)result.get("shareId"));
        		sharedMailboxInfo.setShareMail((String)result.get("shareMail"));
        		sharedMailboxInfo.setShareName((String)result.get("shareName"));
        		sharedMailboxInfo.setShareName1((String)result.get("shareName"));
        		sharedMailboxInfo.setShareName2((String)result.get("shareName2"));
        		
        		JSONArray userArray = (JSONArray)result.get("userList");
        		List<MailSharedMailboxUserVO> userList = sharedMailboxInfo.getUserList();
        		MailSharedMailboxUserVO userVO = null;
        		
        		for (int i = 0; i < userArray.size(); i++) {
        			JSONObject user = (JSONObject)userArray.get(i);
        			userVO = new MailSharedMailboxUserVO();
        			
        			userVO.setUserId((String)user.get("userId"));
        			userVO.setUserName((String) user.get("userName"+lang));
        			userVO.setDeptId((String)user.get("deptId"));
        			userVO.setDeptName((String) user.get("deptName"+lang));
        			userVO.setCompId((String)user.get("compId"));
        			userVO.setCompName((String) user.get("compName"+lang));
        			userVO.setDeletePermission((String)user.get("deletePermission"));
        			userVO.setSendPermission((String)user.get("sendPermission"));
        			userVO.setManagePermission((String)user.get("managePermission"));
        			
        			userList.add(userVO);
        		}
        	}
        }
		
		logger.debug("getSharedMailboxInfo ended.");
		return sharedMailboxInfo;
	}
	
	@Override
	public MailSharedMailboxUserVO getSharedMailboxPermissionInfo(String shareId, int tenantId, String userId) throws Exception {
		logger.debug("getSharedMailboxPermissionInfo started.");
		logger.debug("shareId=" + shareId + ",tenantId=" + tenantId);
		
		String tenantIdParam = "tenantId=" + tenantId;
		String shareIdParam = "shareId=" + URLEncoder.encode(shareId, "UTF-8");
		String userIdParam = "userId=" + URLEncoder.encode(userId, "UTF-8");
		String inputParams = tenantIdParam + "&" + shareIdParam + "&" + userIdParam;
		logger.debug("inputParams=" + inputParams);
		
		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzEmail/getShareMailBoxPermissionInfo";
		String strJson = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		logger.debug("strJson=" + strJson);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(strJson);
		MailSharedMailboxUserVO shareMailBoxPermissonInfo = new MailSharedMailboxUserVO();
        if (((String)object.get("resultCode")).equals("OK") && (Long)object.get("reasonCode") == 0) {
        	JSONObject result = (JSONObject)object.get("result");
        	shareMailBoxPermissonInfo.setShareId((String)result.get("shareId"));
        	shareMailBoxPermissonInfo.setDeletePermission((String)result.get("delete_permission"));
        	shareMailBoxPermissonInfo.setSendPermission((String)result.get("send_permission"));
        	shareMailBoxPermissonInfo.setManagePermission((String)result.get("manage_permission"));
        	shareMailBoxPermissonInfo.setShareName((String)result.get("displayname"));
        }
		
		logger.debug("getSharedMailboxPermissionInfo ended.");
		return shareMailBoxPermissonInfo;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public JSONArray getFolderQuota(String email, Locale locale) throws Exception {
		logger.debug("getFolderQuota started.");
		String userIdParam = "primaryMail=" + URLEncoder.encode(email, "UTF-8");
		String inputParams = userIdParam;
		logger.debug("inputParams=" + inputParams);
		
		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaAccess/getFolderQuota";
		String strJson = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		logger.debug("strJson=" + strJson);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(strJson);
		
		JSONArray jsonArr =  (JSONArray) object.get("resultData");
		List<JSONObject> list = (List<JSONObject>) object.get("resultData");
		
		for(int i = 0; i <list.size(); i++){
			
			String mailboxName = (String) list.get(i).get("mailboxName");
			list.get(i).put("mailboxChangeName", ezEmailUtil.getDisplayNameFromFolderId(mailboxName, locale));
			// String mailboxId = (String) list.get(i).get("mailboxId");
			double size = Double.parseDouble(list.get(i).get("mailboxQuota").toString());
			String mailboxQuota = ezEmailUtil.getSizeWithUnit(size);
			list.get(i).replace("mailboxQuota", mailboxQuota);
			// String notReadCount = (String) list.get(i).get("notReadCount");
			// String mailCount = (String) list.get(i).get("mailCount");
		}
			
		logger.debug("getFolderQuota ended.");
		return jsonArr;
	}
	
	@Override
	public int deleteUserFromAllSharedMailbox(String userId, int tenantId) throws Exception {
		logger.debug("deleteUserFromAllSharedMailbox started.");
		logger.debug("userId=" + userId + ",tenantId=" + tenantId);
		
		String userIdParam = "userId=" + URLEncoder.encode(userId, "UTF-8");
		String tenantIdParam = "tenantId=" + tenantId;
		String inputParams = userIdParam + "&" + tenantIdParam;
		logger.debug("inputParams=" + inputParams);
		
		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzEmail/deleteUserFromAllSharedMailbox";
		String strJson = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		logger.debug("strJson=" + strJson);
		
		String resultCode = "Error";
		int reasonCode = -100;
		
		if (strJson != null) {
			JSONParser parser = new JSONParser();
			JSONObject object = (JSONObject)parser.parse(strJson);
	        
			resultCode = (String)object.get("resultCode");		
			
			if (resultCode.equals("OK")) {
				reasonCode = ((Long)object.get("reasonCode")).intValue();
			}
		}
		
		logger.debug("deleteUserFromAllSharedMailbox ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);
		return reasonCode;
	}
	
	@Override
	public String delSharedMailboxAllUser(String shareId, int tenantId) throws Exception {
		logger.debug("delSharedMailboxAllUser started.");
		logger.debug("shareId=" + shareId + ",tenantId=" + tenantId);
		
		String result = "OK";
		
		String tenantIdParam = "tenantId=" + tenantId;
		String shareIdParam = "shareId=" + URLEncoder.encode(shareId, "UTF-8");
		String inputParams = tenantIdParam + "&" + shareIdParam;
		logger.debug("inputParams=" + inputParams);
		
		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzEmail/delSharedMailboxAllUser";
		String strJson = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		logger.debug("strJson=" + strJson);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(strJson);
        
        if (!((String)object.get("resultCode")).equals("OK") || (Long)object.get("reasonCode") != 0) {
        	result = "ERROR";
        }
		
		logger.debug("delSharedMailboxAllUser ended.");
		return result;
	}
	
	@Override
	public String setSharedMailboxUsers(String shareId, JSONArray userList, int tenantId) throws Exception {
		logger.debug("setSharedMailboxUsers started.");
		logger.debug("shareId=" + shareId + ",tenantId=" + tenantId);
		
		String result = "OK";
		
		String tenantIdParam = "tenantId=" + tenantId;
		String shareIdParam = "shareId=" + URLEncoder.encode(shareId, "UTF-8");
		String inputParams = tenantIdParam + "&" + shareIdParam;
		
		for (int i = 0; i < userList.size(); i++) {
			String user = (String)userList.get(i);
			inputParams += "&user=" + URLEncoder.encode(user, "UTF-8");
		}
		
		logger.debug("inputParams=" + inputParams);
		
		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzEmail/setSharedMailboxUsers";
		String strJson = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		logger.debug("strJson=" + strJson);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(strJson);
        
        if (!((String)object.get("resultCode")).equals("OK") || (Long)object.get("reasonCode") != 0) {
        	result = "ERROR";
        }
		
		logger.debug("setSharedMailboxUsers ended.");
		return result;
	}
	
	@Override
	public List<MailSharedMailboxVO> getSharedMailboxSearchList(String companyId, int tenantId, String searchValue) throws Exception {
		logger.debug("getSharedMailboxSearchList started.");
		logger.debug("companyId=" + companyId + ",tenantId=" + tenantId + ",searchValue=" + searchValue);
		
		List<MailSharedMailboxVO> list = new ArrayList<>();
		String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", tenantId);
		
		if (useSharedMailbox.equals("YES")) {
			Map<String, Object> map = new HashMap<>();
			map.put("tenantId", tenantId);
			map.put("deptId", "shared_mailbox_" + companyId);
			map.put("searchValue", "%" + searchValue + "%");
			
			List<OrganUserVO> userList = ezOrganDao.getSharedMailboxSearchList(map);
			MailSharedMailboxVO vo = null;
			
			for (OrganUserVO user : userList) {
				vo = new MailSharedMailboxVO();
				
				vo.setShareName(user.getDisplayName());
				vo.setShareId(user.getCn());
				vo.setShareMail(user.getMail());
				vo.setCompanyName(user.getCompany());
				
				list.add(vo);
			}
		}
		
		logger.debug("getSharedMailboxSearchList ended. listSize=" + list.size());
		return list;
	}
	
	
	@Override
	public List<MailSharedMailboxVO> getSharedMailboxListSearchByItem(String companyId, int tenantId, String searchType, String searchValue) throws Exception {
		logger.debug("getSharedMailboxListSearchByItem started.");
		logger.debug("companyId=" + companyId + ",tenantId=" + tenantId + ",searchType=" + searchType + ",searchValue=" + searchValue);
		
		String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", tenantId);
		List<MailSharedMailboxVO> list = new ArrayList<>();
		
		if (useSharedMailbox.equals("YES")) {
			String deptId = "shared_mailbox_" + companyId;
			
			String inputParams = "tenantId=" + tenantId + "&deptId=" + URLEncoder.encode(deptId, "UTF-8") 
					+ "&searchValue=" + URLEncoder.encode(searchValue, "UTF-8") + "&searchType=" + URLEncoder.encode(searchType, "UTF-8");
			
			String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzEmail/getSharedMailboxListSearchByItem";
			String strJson = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
			logger.debug("strJson=" + strJson);

			JSONParser parser = new JSONParser();
			JSONObject object = (JSONObject)parser.parse(strJson);
			
			if (object.get("resultCode").equals("OK")) {
	        	JSONArray array = (JSONArray)object.get("result");
	        	
	        	if (array != null) {
	        		int length = array.size();
	        		
	        		MailSharedMailboxVO vo = null;
	        		
	        		for (int i = 0; i < length; i++) {
	        			JSONObject sharedMailbox = (JSONObject)array.get(i);
	        			vo = new MailSharedMailboxVO();
	        			
	        			vo.setShareId((String)sharedMailbox.get("shareId"));
	        			vo.setShareMail((String)sharedMailbox.get("shareMail"));
	        			vo.setShareName((String)sharedMailbox.get("shareName"));
	        			
	        			list.add(vo);
	        		}
	        	}
	        }
		}
		
		logger.debug("getSharedMailboxListSearchByItem ended. listSize=" + list.size());
		return list;
	}
	
	@Override
	public JSONArray selectAllSignatureTemplate(String companyId, String tenantId) throws Exception {
		logger.debug("selectAllSignatureTemplate started.");
		logger.debug("companyId=" + companyId + ",tenantId=" + tenantId);
		
		String tenantStr = "companyId=" + URLEncoder.encode(companyId, "UTF-8");
		String companyIdStr = "tenantId=" + URLEncoder.encode(tenantId, "UTF-8");
		String inputParams = companyIdStr + "&" + tenantStr;
		
		logger.debug("inputParams=" + inputParams);
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaEzEmail/getMailSignatureTemplate", inputParams);
		logger.debug("strJson=" + strJson);
		
		JSONArray json = new JSONArray();
		
		if (!strJson.equals("")){
			JSONParser parser = new JSONParser();
			JSONObject object = (JSONObject)parser.parse(strJson);
			
			json = (JSONArray) object.get("result");
			
			if (object.get("resultCode").equals("ERROR") || ((Long)object.get("reasonCode")).intValue() == -1 || json.size() <= 0) {
				//throw new Exception("JGwServer ERROR");
			}
		}
		
		logger.debug("selectAllSignatureTemplate ended.");
		
		return json;
		
	}
	
	@Override
	public JSONArray selectSearchSignatureTemplate(String companyId, String tenantId, String search, String userLang) throws Exception {
		logger.debug("selectSearchSignatureTemplate started.");
		logger.debug("companyId=" + companyId + ",tenantId=" + tenantId + ", search=" + search + ",userLang=" + userLang);
		
		String tenantStr = "companyId=" + URLEncoder.encode(companyId, "UTF-8");
		String companyIdStr = "tenantId=" + URLEncoder.encode(tenantId, "UTF-8");
		String searchStr = "search=" + URLEncoder.encode(search, "UTF-8");
		String userLangStr = "userLang=" + URLEncoder.encode(userLang, "UTF-8");
		String inputParams = companyIdStr + "&" + tenantStr + "&" + searchStr + "&" + userLangStr;
		
		logger.debug("inputParams=" + inputParams);
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaEzEmail/getSearchMailSignatureTemplate", inputParams);
		logger.debug("strJson=" + strJson);
		
		JSONArray json = new JSONArray();
		
		if (!strJson.equals("")){
			JSONParser parser = new JSONParser();
			JSONObject object = (JSONObject)parser.parse(strJson);
			
			json = (JSONArray) object.get("result");
			
			if (object.get("resultCode").equals("ERROR") || ((Long)object.get("reasonCode")).intValue() == -1 || json.size() <= 0) {
				//throw new Exception("JGwServer ERROR");
			}
		}
		
		logger.debug("selectSearchSignatureTemplate ended.");
		
		return json;
	}
	
	@Override
	public void deleteSignatureTemplate(String signNo) throws Exception {	
		logger.debug("deleteSignatureTemplate started. signNo=" + signNo);
		
		String signNoStr = "signNo=" + URLEncoder.encode(signNo, "UTF-8");
		
		String inputParams = signNoStr;
		logger.debug("inputParams=" + inputParams);
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaEzEmail/deleteSignatureTemplate", inputParams);
		logger.debug("strJson=" + strJson);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(strJson);
        
        if (!object.get("resultCode").equals("OK")) {
        	throw new Exception("JGwServer ERROR");
        }
        
        logger.debug("deleteSignatureTemplate ended.");
        
	}
	
	@Override
	public JSONArray selectOneSignatureTemplate(String signNo) throws Exception {
		logger.debug("selectOneSignatureTemplate started.");
		logger.debug("signNo=" + signNo);
		
		String signNoStr = "signNo=" + URLEncoder.encode(signNo, "UTF-8");
		String inputParams = signNoStr;
		
		logger.debug("inputParams=" + inputParams);
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaEzEmail/getOneSignatureTemplate", inputParams);
		logger.debug("strJson=" + strJson);
		
		JSONArray json = new JSONArray();
		
		if (!strJson.equals("")){
			JSONParser parser = new JSONParser();
			JSONObject object = (JSONObject)parser.parse(strJson);
			
			json = (JSONArray) object.get("result");
			
			if (object.get("resultCode").equals("ERROR") || ((Long)object.get("reasonCode")).intValue() == -1 || json.size() <= 0) {
				throw new Exception("JGwServer ERROR");
			}
		}
		
		logger.debug("selectOneSignatureTemplate ended.");
		
		return json;
	}
	
	@Override
	public void addSignatureTemplate(MailSignatureTemplateVO signTemplate) throws Exception {
		logger.debug("addSignatureTemplate started. signTemplate=" + signTemplate);
		
		String companyIdStr = "companyId=" + URLEncoder.encode(signTemplate.getCompanyId(), "UTF-8");
		String tenantIdStr = "tenantId=" + URLEncoder.encode(signTemplate.getTenantId(), "UTF-8");
		String displaynameStr = "displayname=" + URLEncoder.encode(signTemplate.getDisplayname(), "UTF-8");
		String displayname2Str = "displayname2=" + URLEncoder.encode(signTemplate.getDisplayname2(), "UTF-8");
		String contentStr = "content=" + URLEncoder.encode(signTemplate.getContent(), "UTF-8");
		
		String inputParams = companyIdStr + "&" + tenantIdStr + "&" + displaynameStr + "&" + displayname2Str + "&" + contentStr;
		logger.debug("inputParams=" + inputParams);
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaEzEmail/insertSignatureTemplate", inputParams);
		logger.debug("strJson=" + strJson);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(strJson);
        
        if (!object.get("resultCode").equals("OK")) {
        	throw new Exception("JGwServer ERROR");
        }
        
        logger.debug("addSignatureTemplate ended.");
	}
	
	@Override
	public void setSignatureTemplate(MailSignatureTemplateVO signTemplate) throws Exception {
		logger.debug("setSignatureTemplate started. signTemplate=" + signTemplate);
		
		String displaynameStr = "displayname=" + URLEncoder.encode(signTemplate.getDisplayname(), "UTF-8");
		String displayname2Str = "displayname2=" + URLEncoder.encode(signTemplate.getDisplayname2(), "UTF-8");
		String contentStr = "content=" + URLEncoder.encode(signTemplate.getContent(), "UTF-8");
		String signNoStr = "signNo=" + URLEncoder.encode(signTemplate.getSignNo(), "UTF-8");
		
		String inputParams = displaynameStr + "&" + displayname2Str + "&" + contentStr + "&" + signNoStr;
		logger.debug("inputParams=" + inputParams);
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaEzEmail/updateSignatureTemplate", inputParams);
		logger.debug("strJson=" + strJson);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(strJson);
        
        if (!object.get("resultCode").equals("OK")) {
        	throw new Exception("JGwServer ERROR");
        }
        
        logger.debug("setSignatureTemplate ended.");
        
	}
	
	@Override
	public MailDistributionVO getDistributionSub(String userName, String subMail, String companyId, int tenantId) throws Exception {
		logger.debug("getDistributionSub started.");
		logger.debug("userName = " + userName + ",subMail=" + subMail + ",companyId=" + companyId + ",tenantId=" + tenantId);
		
		String domain = ezCommonService.getTenantConfig("DomainName", tenantId);
		
		String inputParams = "domainName=" + URLEncoder.encode(domain, "UTF-8");
		inputParams += "&userName=" + URLEncoder.encode(userName, "UTF-8");
		inputParams += "&companyId=" + URLEncoder.encode(companyId, "UTF-8");
		inputParams += "&subMail=" + URLEncoder.encode(subMail, "UTF-8");
		logger.debug("inputParams=" + inputParams);
		
		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaAccess/getDistributionSub";			
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		logger.debug("response=" + response);
		
		String resultCode = "Error";
		int reasonCode = -100; 
		MailDistributionVO distributonSubVo = new MailDistributionVO();;
		
		if (response != null) {
			JSONParser jsonParser = new JSONParser();
			JSONObject responseObj = (JSONObject)jsonParser.parse(response);
			
			resultCode = (String)responseObj.get("resultCode");		
			
			if (resultCode.equals("OK")) {
				reasonCode = ((Long)responseObj.get("reasonCode")).intValue();
				
				if (reasonCode == 0) {
					JSONObject resultObject = (JSONObject) responseObj.get("result");
					
					if (resultObject != null &&  resultObject.size() > 0) {
						distributonSubVo.setMail((String)resultObject.get("SUB_MAIL"));
						distributonSubVo.setName((String)resultObject.get("SUB_NAME"));
						
					}
				}
			}
		}						
		
		logger.debug("getDistributionSub ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);
		logger.debug(distributonSubVo.toString());
		return distributonSubVo;
	}
	
	/**
	 * 공용배포그룹 추가
	 */
	@Override
	public int addDistributionList(String id, String name, List<String> memberList, List<Map<String, String>> subList, 
			String compId, int tenantId) throws Exception {
		logger.debug("addDistributionList started.");
		logger.debug("id=" + id + ",name=" + name + ",memberList.size=" + memberList.size() + ",subList.size=" + subList.size() 
			+ ",compId=" + compId + ",tenantId=" + tenantId);

		String domain = ezCommonService.getTenantConfig("DomainName", tenantId);
		String companyDomainName = ezCommonService.getCompanyConfig(tenantId, compId, "DomainName");

		String inputParams = "companyId=" + URLEncoder.encode(compId, "UTF-8") 
			+ "&name=" + URLEncoder.encode(name, "UTF-8") 
			+ "&id=" + URLEncoder.encode(id, "UTF-8") 
			+ "&domain=" + URLEncoder.encode(domain, "UTF-8");

		// 공용배포그룹 맴버가 조직도 or 공용그룹인 경우
		for (int i = 0; i < memberList.size(); i++) {
			inputParams += "&memberId=" + URLEncoder.encode(memberList.get(i), "UTF-8");
		}

		// 공용배포그룹 멤버가 주소록 or 직접입력인 경우
		for (int i = 0; i < subList.size(); i++) {
			String subName = subList.get(i).get("subName");
			String subEmail = subList.get(i).get("subEmail");
			inputParams += "&subName=" + URLEncoder.encode(subName, "UTF-8") + "&subEmail=" + URLEncoder.encode(subEmail, "UTF-8");
		}

		// 회사별 이메일 도메인명이 설정되어 있으면 해당 도메인명을 기반으로 한 이메일 주소를 함께 전달한다.
		if (!companyDomainName.isEmpty()) {
			String email = id + "@" + companyDomainName;
			inputParams += "&email=" + URLEncoder.encode(email, "UTF-8");
		}

		logger.debug("inputParams=" + inputParams);

		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaAccess/setDistributionList";
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		logger.debug("response=" + response);

		String resultCode = "Error";
		int reasonCode = -100; 

		if (response != null) {
			JSONParser jsonParser = new JSONParser();
			JSONObject responseObj = (JSONObject)jsonParser.parse(response);
			resultCode = (String)responseObj.get("resultCode");		

			if (resultCode.equals("OK")) {
				reasonCode = ((Long)responseObj.get("reasonCode")).intValue();
			}
		}

		logger.debug("addDistributionList ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);
		return reasonCode;
	}
	
	/**
	 * 공용배포그룹 추가 (도메인 설정)
	 */
	@Override
	public int addDistributionList(String id, String name, List<String> memberList, List<Map<String, String>> subList, 
			String compId, int tenantId, String selectDomain) throws Exception {
		logger.debug("addDistributionList started.");
		logger.debug("id=" + id + ",name=" + name + ",memberList.size=" + memberList.size() + ",subList.size=" + subList.size() 
			+ ",compId=" + compId + ",tenantId=" + tenantId + ", selectDomain=" + selectDomain);
		
		String domain = ezCommonService.getTenantConfig("DomainName", tenantId);
		String companyDomainName = ezCommonService.getCompanyConfig(tenantId, compId, "DomainName");
		companyDomainName = !selectDomain.equals("") ? selectDomain : companyDomainName;

		String inputParams = "companyId=" + URLEncoder.encode(compId, "UTF-8") 
			+ "&name=" + URLEncoder.encode(name, "UTF-8") 
			+ "&id=" + URLEncoder.encode(id, "UTF-8") 
			+ "&domain=" + URLEncoder.encode(domain, "UTF-8");

		// 공용배포그룹 맴버가 조직도 or 공용그룹인 경우
		for (int i = 0; i < memberList.size(); i++) {
			inputParams += "&memberId=" + URLEncoder.encode(memberList.get(i), "UTF-8");
		}

		// 공용배포그룹 멤버가 주소록 or 직접입력인 경우
		for (int i = 0; i < subList.size(); i++) {
			String subName = subList.get(i).get("subName");
			String subEmail = subList.get(i).get("subEmail");
			inputParams += "&subName=" + URLEncoder.encode(subName, "UTF-8") + "&subEmail=" + URLEncoder.encode(subEmail, "UTF-8");
		}
		
		// companyDomainName != tenantDomain > 선택한 도메인이 tenant domain일 경우 아래의 처리는 하지 않는다.
		if (!companyDomainName.isEmpty() && !companyDomainName.equals(domain)) {
		// 회사별 이메일 도메인명이 설정되어 있으면 해당 도메인명을 기반으로 한 이메일 주소를 함께 전달한다.
			String email = id + "@" + companyDomainName;
			inputParams += "&email=" + URLEncoder.encode(email, "UTF-8");
		}

		logger.debug("inputParams=" + inputParams);

		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaAccess/setDistributionList";
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		logger.debug("response=" + response);

		String resultCode = "Error";
		int reasonCode = -100; 

		if (response != null) {
			JSONParser jsonParser = new JSONParser();
			JSONObject responseObj = (JSONObject)jsonParser.parse(response);
			resultCode = (String)responseObj.get("resultCode");		

			if (resultCode.equals("OK")) {
				reasonCode = ((Long)responseObj.get("reasonCode")).intValue();
			}
		}

		logger.debug("addDistributionList ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);
		return reasonCode;
	}
	
	
	/**
	 * 공용배포그룹 추가
	 */
	@Override
	public int addDistributionList(String id, String name, List<String> memberList, List<Map<String, String>> subList, 
			String compId, int tenantId, String selectDomain, String ownerId, String policy, String explaination, String endDate, String loginCookie) throws Exception {
		logger.debug("addDistributionList started.");
		logger.debug("id=" + id + ",name=" + name + ",memberList.size=" + memberList.size() + ",subList.size=" + subList.size() 
			+ ",compId=" + compId + ",tenantId=" + tenantId + ", selectDomain=" + selectDomain);
		logger.debug("ownerId=" + ownerId + ",policy=" + policy + ",explaination=" + explaination + ",endDate=" + endDate);
		
		String domain = ezCommonService.getTenantConfig("DomainName", tenantId);
		String companyDomainName = ezCommonService.getCompanyConfig(tenantId, compId, "DomainName");
		companyDomainName = !selectDomain.equals("") ? selectDomain : companyDomainName;
		String useUserDefinedDL = ezCommonService.getTenantConfig("useUserDefinedDL", tenantId);

		String inputParams = "companyId=" + URLEncoder.encode(compId, "UTF-8") 
			+ "&name=" + URLEncoder.encode(name, "UTF-8") 
			+ "&id=" + URLEncoder.encode(id, "UTF-8") 
			+ "&domain=" + URLEncoder.encode(domain, "UTF-8")
			+ "&ownerId=" + URLEncoder.encode(ownerId, "UTF-8")
			+ "&policy=" + URLEncoder.encode(policy, "UTF-8")
			+ "&explaination=" + URLEncoder.encode(explaination, "UTF-8")
			+ "&endDate=" + URLEncoder.encode(endDate, "UTF-8");

		// 공용배포그룹 맴버가 조직도 or 공용그룹인 경우
		for (int i = 0; i < memberList.size(); i++) {
			inputParams += "&memberId=" + URLEncoder.encode(memberList.get(i), "UTF-8");
		}

		// 공용배포그룹 멤버가 주소록 or 직접입력인 경우
		for (int i = 0; i < subList.size(); i++) {
			String subName = subList.get(i).get("subName");
			String subEmail = subList.get(i).get("subEmail");
			inputParams += "&subName=" + URLEncoder.encode(subName, "UTF-8") + "&subEmail=" + URLEncoder.encode(subEmail, "UTF-8");
		}
		
		// companyDomainName != tenantDomain > 선택한 도메인이 tenant domain일 경우 아래의 처리는 하지 않는다.
		if (!companyDomainName.isEmpty() && !companyDomainName.equals(domain)) {
		// 회사별 이메일 도메인명이 설정되어 있으면 해당 도메인명을 기반으로 한 이메일 주소를 함께 전달한다.
			String email = id + "@" + companyDomainName;
			inputParams += "&email=" + URLEncoder.encode(email, "UTF-8");
		}

		logger.debug("inputParams=" + inputParams);

		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaAccess/setDistributionList";
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		logger.debug("response=" + response);

		String resultCode = "Error";
		int reasonCode = -100; 

		if (response != null) {
			JSONParser jsonParser = new JSONParser();
			JSONObject responseObj = (JSONObject)jsonParser.parse(response);
			resultCode = (String)responseObj.get("resultCode");		

			if (resultCode.equals("OK")) {
				reasonCode = ((Long)responseObj.get("reasonCode")).intValue();
				
				logger.debug("reasonCode=" + reasonCode + "config=" + useUserDefinedDL.equalsIgnoreCase("YES") + ", memsize=" + memberList.size() 
						+ ", login=" + loginCookie);
				if (reasonCode == 0 && useUserDefinedDL.equalsIgnoreCase("YES") && memberList.size() > 0 && !ownerId.equals("")) {
					sendUserDLMail(loginCookie, id, "add", memberList);
				}
			}
		}

		logger.debug("addDistributionList ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);
		return reasonCode;
	}
	
	/**
	 * 공용배포그룹 수정
	 */
	@Override
	public int updateDistributionList(String id, String name, List<String> memberList, List<Map<String, String>> subList, 
			String compId, int tenantId) throws Exception {
		logger.debug("updateDistributionList started.");
		int returnInt = updateDistributionList(id, name, memberList, subList, compId, tenantId, "", "", "", "", "");
		logger.debug("updateDistributionList ended.");
		return returnInt;
	}
	
	/**
	 * 공용배포그룹 수정
	 */
	@Override
	public int updateDistributionList(String id, String name, List<String> memberList, List<Map<String, String>> subList, 
			String compId, int tenantId, String ownerId, String policy, String explaination, String endDate, String loginCookie) throws Exception {
		logger.debug("updateDistributionList started.");
		logger.debug("id=" + id + ",name=" + name + ",memberList.size=" + memberList.size() + ",subList.size=" + subList.size() 
			+ ",compId=" + compId + ",tenantId=" + tenantId + ", ownerId=" + ownerId + ", policy=" + policy 
			+ ", explaination=" + explaination + ", endDate=" + endDate);

		String domain = ezCommonService.getTenantConfig("DomainName", tenantId);
		String useUserDefinedDL = ezCommonService.getTenantConfig("useUserDefinedDL", tenantId);

		String inputParams = "companyId=" + URLEncoder.encode(compId, "UTF-8") 
			+ "&cn=" + URLEncoder.encode(id, "UTF-8") 
			+ "&name=" + URLEncoder.encode(name, "UTF-8") 
			+ "&id=" + URLEncoder.encode(id, "UTF-8") 
			+ "&domain=" + URLEncoder.encode(domain, "UTF-8")
			+ "&ownerId=" + URLEncoder.encode(ownerId, "UTF-8")
			+ "&policy=" + URLEncoder.encode(policy, "UTF-8")
			+ "&explaination=" + URLEncoder.encode(explaination, "UTF-8")
			+ "&endDate=" + URLEncoder.encode(endDate, "UTF-8");

		// 공용배포그룹 맴버가 조직도 or 공용그룹인 경우
		for (int i = 0; i < memberList.size(); i++) {
			inputParams += "&memberId=" + URLEncoder.encode(memberList.get(i), "UTF-8");
		}

		// 공용배포그룹 멤버가 주소록 or 직접입력인 경우
		for (int i = 0; i < subList.size(); i++) {
			String subName = subList.get(i).get("subName");
			String subEmail = subList.get(i).get("subEmail");
			inputParams += "&subName=" + URLEncoder.encode(subName, "UTF-8") + "&subEmail=" + URLEncoder.encode(subEmail, "UTF-8");
		}

		logger.debug("inputParams=" + inputParams);

		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaAccess/updateDistributionList";
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		logger.debug("response=" + response);

		String resultCode = "Error";
		int reasonCode = -100; 
		String result = ""; // 새로 추가된 사용자 이메일

		if (response != null) {
			JSONParser jsonParser = new JSONParser();
			JSONObject responseObj = (JSONObject)jsonParser.parse(response);
			resultCode = (String)responseObj.get("resultCode");		

			if (resultCode.equals("OK")) {
				reasonCode = ((Long)responseObj.get("reasonCode")).intValue();
				result = (String)responseObj.get("result");

				logger.debug("reasonCode=" + reasonCode + "config=" + useUserDefinedDL.equalsIgnoreCase("YES") + ", result=" + result 
						+ ", login=" + loginCookie);
				// 새로 추가된 사용자한테 알림 메일 발송
				if (reasonCode == 0 && useUserDefinedDL.equalsIgnoreCase("YES") && !result.equals("") && !ownerId.equals("")) {
					List<String> toArr = new ArrayList<String>(Arrays.asList(result));
					sendUserDLMail(loginCookie, id, "add", toArr);
				}
			}
		}

		logger.debug("updateDistributionList ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);
		return reasonCode;
	}
	
	@Override
	public JSONObject recallMailByMessageId(String address, String messageId) {
		logger.debug("recallMailByMessageId started. address=" + address + ", messageId=" + messageId);
		
		JSONObject result = null;
		
		try {
			String inputParams = "targetAddress=" + URLEncoder.encode(address, "UTF-8");
			inputParams += "&" + "messageId=" + URLEncoder.encode(messageId, "UTF-8");
			logger.debug("inputParams=" + inputParams);
			
			String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaEzHrMaster/recallMailByMessageId", inputParams);
			logger.debug("strJson=" + strJson);
			
			JSONParser parser = new JSONParser();
			JSONObject object = (JSONObject)parser.parse(strJson);
	        
	        if (((String)object.get("resultCode")).equals("OK") && (Long)object.get("reasonCode") == 0) {
	        	result = (JSONObject)object.get("result");
	        }
		} catch (UnsupportedEncodingException e) {
			logger.error(e.getMessage(), e);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
        
        logger.debug("recallMailByMessageId ended.");
        return result;
	}

	@Override
	public void cancelMailByMailUid(Long mailUid, Long mailboxId) throws Exception {
		logger.debug("cancelMailByMessageId started.");

		MailDeletedIdVO deletedIdVO = new MailDeletedIdVO();
		
		deletedIdVO.setMailUid(mailUid);
		deletedIdVO.setMailBoxId(mailboxId);

		ezEmailDAO.cancelMailByMailUid(deletedIdVO);
		
		logger.debug("cancelMailByMessageId ended.");
	}
	
	/**
	 * 전체 안읽은 메일 개수 가져오기
	 */
	@Override
	public int getTotalUnreadCount(String userId, int tenantId) throws Exception {
		logger.debug("getTotalUnreadCount started. userId=" + userId + ",tenantId=" + tenantId);
		
		String domain = ezCommonService.getTenantConfig("DomainName", tenantId);
		String inputParams = "userId=" + URLEncoder.encode(userId, "UTF-8")
			+ "&domain=" + URLEncoder.encode(domain, "UTF-8");
		logger.debug("inputParams=" + inputParams);

		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzEmail/getTotalUnreadCount";
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		logger.debug("response=" + response);

		String resultCode = "Error";
		int reasonCode = -100;
		int totalUnreadCount = 0;
		
		JSONParser jsonParser = new JSONParser();
		JSONObject responseObj = (JSONObject)jsonParser.parse(response);
		
		resultCode = (String)responseObj.get("resultCode");
		reasonCode = ((Long)responseObj.get("reasonCode")).intValue();
		
		if (resultCode.equals("OK") && reasonCode == 0) {
			totalUnreadCount = ((Long)responseObj.get("result")).intValue();
		}
		
		logger.debug("getTotalUnreadCount ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);
		return totalUnreadCount;
	}
	
	/** 
	 * 공유사서함까지 포함하여 전체 메일함 안 읽은 갯수 가져오기
	 * @param requestObject null 값을 허용하며 unreadCountMap 이 필요할때만 넘김
	 */
	@Override
	public JSONObject getUnreadCountAll(JSONObject requestObject, String userId, Locale locale, int tenantId) throws Exception {
		Map<String, Object> resultObject = new HashMap<>();
		IMAPAccess ia = null;

		try {
			requestObject = Optional.ofNullable(requestObject).orElse(new JSONObject());
			JSONArray requestMailboxList = (JSONArray) requestObject.get("mailboxList");

			String domainName = ezCommonService.getTenantConfig("DomainName", tenantId);
			String userAccount = userId + "@" + domainName;

			String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", tenantId);
			String shareId = null;

			if (useSharedMailbox.equals("YES")) {
				shareId = (String) requestObject.get("shareId");

				if (shareId != null) {
					logger.debug("shareId=" + shareId);

					if (!checkUserShareId(userId, shareId, tenantId)) {
						logger.debug("the user cannot access the shareId.");
						logger.debug("getFolderUnreadCount ended.");

						throw new Exception("CANNOT_ACCESS_SHAREID");
					}

					userAccount = shareId + "@" + domainName;
				}
			}

			logger.debug("userId=" + userId + ",userAccount=" + userAccount);

			Map<String, Object> unreadCountMap = new HashMap<>();
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"), userAccount, jspw, egovMessageSource, locale, ezEmailUtil);

			if (requestMailboxList != null) {
				for (int i = 0; i < requestMailboxList.size(); i++) {
					String mailboxName = (String) requestMailboxList.get(i);
					mailboxName = mailboxName != null ? mailboxName : "";
					unreadCountMap.put(mailboxName, ia.getUnreadCount(mailboxName));
				}
			}

			int totalUnreadCount = getTotalUnreadCount(userId, tenantId);
			int totalUnreadCountInAllAccounts = totalUnreadCount;

			if (useSharedMailbox.equals("YES")) {
				List<Map<String, String>> shareInfoList = getUserSharedMailboxList(userId, true, tenantId);
				resultObject.put("shareInfoList", shareInfoList);

				for (Map<String, String> item : shareInfoList) {
					String unreadCountStr = item.get("totalUnreadCount");

					if (unreadCountStr != null) {
						try {
							int unreadCountInShared = Integer.parseInt(unreadCountStr);

							totalUnreadCountInAllAccounts += unreadCountInShared;
						} catch (NumberFormatException ne) {
							logger.error(ne.getMessage(), ne);
						}
					}
				}
			}

			resultObject.put("shareId", shareId == null ? "" : shareId);
			resultObject.put("unreadCountMap", unreadCountMap);
			resultObject.put("totalUnreadCount", totalUnreadCount);
			resultObject.put("totalUnreadCountInAllAccounts", totalUnreadCountInAllAccounts);
		} catch (NullPointerException ex) {
			logger.error(ex.getMessage(), ex);
		} catch (Exception ex) {
			logger.error(ex.getMessage(), ex);
		}

		return new JSONObject(resultObject);
	}

	/**
	 * 전체 도메인 가져오기(tbl_tenant_config:MailInnerDomain)
	 */
	@Override
	public String getMultiDomainList(int tenantId) throws Exception {
		logger.debug("getMultiDomainList started.");
		logger.debug("tenantId=" + tenantId);
		
		String domainList = "";
		
		String inputParams = "tenantId=" + URLEncoder.encode(Integer.toString(tenantId), "UTF-8");
		logger.debug("inputParams=" + inputParams);
		
		String requestURL = config.getProperty("config.JGwServerURL")+ "/jMochaAccess/getMailInnerDomain";
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		
		if (response != null) {
			JSONParser jsonParser = new JSONParser();
			JSONObject responseObj = (JSONObject) jsonParser.parse(response);

			String resultCode = (String) responseObj.get("resultCode");

			if (resultCode.equalsIgnoreCase("OK")) {
				domainList = (String)responseObj.get("result");
			}
		}

		logger.debug("getMultiDomainList ended.");
		return domainList;
	}
	
	/**
	 * 전체 도메인 추가
	 */
	@Override
	public int addMultiDomain(int tenantId, String domainName) throws Exception { 
		logger.debug("addMultiDomain started.");
		logger.debug("tenantId=" + tenantId + ", domainName=" + domainName);
		
		String resultCode = "";
		int reasonCode = -100;
		
		String inputParams = "tenantId=" + URLEncoder.encode(Integer.toString(tenantId), "UTF-8")
				+ "&domain=" + URLEncoder.encode(domainName, "UTF-8");
		logger.debug("inputParams=" + inputParams);
		
		String requestURL = config.getProperty("config.JGwServerURL")+ "/jMochaAccess/addMailDomain";
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		
		if (response != null) {
			JSONParser jsonParser = new JSONParser();
			JSONObject responseObj = (JSONObject)jsonParser.parse(response);
			resultCode = (String)responseObj.get("resultCode");	
			reasonCode = ((Long)responseObj.get("reasonCode")).intValue();

			logger.debug("resultCode=" + resultCode + ", reasonCode=" + reasonCode);
		}
		
		logger.debug("addMultiDomain ended.");
		return reasonCode;
	}
	
	/**
	 * 전체 도메인 삭제
	 */
	@Override
	public int delMultiDomain(int tenantId, String delDomain, String saveDomainList) throws Exception { 
		logger.debug("delMultiDomain started.");
		logger.debug("tenantId=" + tenantId + ", delDomain=" + delDomain + ", saveDomainList=" + saveDomainList);
		
		String resultCode = "";
		int reasonCode = -100;
		
		String inputParams = "tenantId=" + URLEncoder.encode(Integer.toString(tenantId), "UTF-8")
				+ "&delDomain=" + URLEncoder.encode(delDomain, "UTF-8") 
				+ "&saveDomainList=" + URLEncoder.encode(saveDomainList, "UTF-8");
		logger.debug("inputParams=" + inputParams);
		
		String requestURL = config.getProperty("config.JGwServerURL")+ "/jMochaAccess/delMailDomain";
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		
		if (response != null) {
			JSONParser jsonParser = new JSONParser();
			JSONObject responseObj = (JSONObject)jsonParser.parse(response);
			resultCode = (String)responseObj.get("resultCode");	
			reasonCode = ((Long)responseObj.get("reasonCode")).intValue();

			logger.debug("resultCode=" + resultCode + ", reasonCode=" + reasonCode);
		}
		
		logger.debug("delMultiDomain ended.");
		return reasonCode;
	}
	
	/**
	 * companyConfig 가져오기
	 */
	@Override
	public String getCompanyConfig(int tenantId, String companyId, String propertyName) throws Exception {
		logger.debug("getCompanyConfig started.");
		logger.debug("tenantId=" + tenantId + ", companyId=" + companyId + ", propertyName=" + propertyName);

		String returnStr = "";
		
		String inputParams = "tenantId=" + URLEncoder.encode(Integer.toString(tenantId), "UTF-8")
				+ "&companyId=" + URLEncoder.encode(companyId, "UTF-8") 
				+ "&propertyName=" + URLEncoder.encode(propertyName, "UTF-8") ;
		logger.debug("inputParams=" + inputParams);
		
		String requestURL = config.getProperty("config.JGwServerURL")+ "/jMochaEzHrMaster/getTblCompanyConfig";
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		
		if (response != null) {
			JSONParser jsonParser = new JSONParser();
			JSONObject responseObj = (JSONObject) jsonParser.parse(response);

			String resultCode = (String) responseObj.get("resultCode");
			int reasonCode = ((Long)responseObj.get("reasonCode")).intValue();

			if (resultCode.equalsIgnoreCase("OK") && reasonCode == 0) {
				JSONObject re = (JSONObject) responseObj.get("result");
				returnStr = (String) re.get("propertyValue");
			}
		}

		logger.debug("getCompanyConfig ended.");
		return returnStr;
	}

	/**
	 * 회사 도메인 저장
	 */
	@Override
	public int saveCompanyMultiDomain(int tenantId, String companyId, String primaryDomain, String saveDomainList) throws Exception {
		logger.debug("saveCompanyMultiDomain started.");
		logger.debug("tenantId=" + tenantId + ", companyId=" + companyId + ", primaryDomain=" + primaryDomain + ", saveDomainList=" + saveDomainList);

		String resultCode = "";
		int reasonCode = -100;
		
		String inputParams = "tenantId=" + URLEncoder.encode(Integer.toString(tenantId), "UTF-8")
				+ "&companyId=" + URLEncoder.encode(companyId, "UTF-8") 
				+ "&primaryDomain=" + URLEncoder.encode(primaryDomain, "UTF-8")
				+ "&saveDomainList=" + URLEncoder.encode(saveDomainList, "UTF-8") ;
		logger.debug("inputParams=" + inputParams);
		
		String requestURL = config.getProperty("config.JGwServerURL")+ "/jMochaAccess/saveCompanyMailDomain";
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		
		if (response != null) {
			JSONParser jsonParser = new JSONParser();
			JSONObject responseObj = (JSONObject)jsonParser.parse(response);
			resultCode = (String)responseObj.get("resultCode");	
			reasonCode = ((Long)responseObj.get("reasonCode")).intValue();

			logger.debug("resultCode=" + resultCode + ", reasonCode=" + reasonCode);
		}
		
		logger.debug("saveCompanyMultiDomain ended.");
		return reasonCode;
	}
	
	@Override
	public String setIndividualAliasForMig(String userId, int tenantID, String targetAddr, String individualAlias) throws Exception {
		logger.debug("setIndividualAliasForMig started.");
		logger.debug("targetAddr=" + targetAddr + ",individualAlias=" + individualAlias);

		String returnValue = "ERROR";
		
		String inputParams = "userId=" + URLEncoder.encode(targetAddr, "UTF-8")
						+ "&individualAlias=" + URLEncoder.encode(individualAlias, "UTF-8");
		logger.debug("inputParams=" + inputParams);
		
		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzHrMaster/setIndividualAliasForMig";
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		logger.debug("response=" + response);

		if (response != null) {
			JSONParser jsonParser = new JSONParser();
			JSONObject responseObj = (JSONObject)jsonParser.parse(response);
			
			if (((String)responseObj.get("resultCode")).equals("OK") && (Long)responseObj.get("reasonCode") == 0) {
				logger.debug("setIndividualAliasForMig OK");
				returnValue = "OK";
			}
		}						
		
		logger.debug("setIndividualAliasForMig ended. returnValue=" + returnValue);
		
		return returnValue;
	}

	@Override
	public MailDistributionVO getDistributionInfo(String cn, int tenantId)
			throws Exception {
		logger.debug("getDistributionInfo started.");
		
		String tenantDomain = ezCommonService.getTenantConfig("DomainName", tenantId);
		MailDistributionVO vo = new MailDistributionVO();
		logger.debug("cn=" + cn + ",tenantId=" + tenantId + ", tenantDomain=" + tenantDomain);
		
		String inputParams = "cn=" + URLEncoder.encode(cn, "UTF-8") + "&domain=" + tenantDomain;
		logger.debug("inputParams=" + inputParams);
		
		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaAccess/getDistributionInfo";
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		logger.debug("response=" + response);
		
		if (response != null) {
			JSONParser jsonParser = new JSONParser();
			JSONObject responseObj = (JSONObject)jsonParser.parse(response);
			JSONObject resultObj = (JSONObject)	responseObj.get("result");
			
			if (((String)responseObj.get("resultCode")).equals("OK") && (Long)responseObj.get("reasonCode") == 0 && resultObj != null) {
				vo.setName((String)resultObj.get("groupName"));
				vo.setId((String)resultObj.get("userName"));
				vo.setMail((String)resultObj.get("mail"));
			}
		}		
		
		logger.debug("getDistributionInfo ended.");
		return vo;
	}

	@Override
	public String setBigAttachCountInfo(String[] fileIdArr, int limitCount, int tenantId) throws Exception {
		logger.debug("setBigAttachCountInfo started.");
		
		Map<String, Object> map = new HashMap<>();
		map.put("fileIdArr", fileIdArr);
		map.put("limitCount", limitCount);
		map.put("tenantId", tenantId);
		
		ezEmailDAO.setBigAttachCountInfo(map);
		
		logger.debug("setBigAttachCountInfo ended.");
		return "";
	}

	@Override
	public String checkBigAttachDownloadCount(String fileId, int tenantId) throws Exception {
		logger.debug("checkBigAttachDownloadCount started.");
		
		Map<String, Object> map = new HashMap<>();
		map.put("fileId", fileId);
		map.put("tenantId", tenantId);
		
		
		logger.debug("checkBigAttachDownloadCount ended.");
		
		return ezEmailDAO.checkBigAttachDownloadCount(map);
	}

	@Override
	public void updateBigAttachDownloadCount(String fileId, int tenantId) throws Exception {
		logger.debug("updateBigAttachDownloadCount started.");
		
		Map<String, Object> map = new HashMap<>();
		map.put("fileId", fileId);
		map.put("tenantId", tenantId);
		
		
		logger.debug("updateBigAttachDownloadCount ended.");
		
		ezEmailDAO.updateBigAttachDownloadCount(map);
	}

	@Override
	public void deleteBigAttachCountInfo(File[] fileList, int tenantId) throws Exception {
		logger.debug("deleteBigAttachCountInfo(file[], int) started.");
		
		String[] fileIdArr = new String[fileList.length];
		for (int i = 0; i < fileIdArr.length; i++) {
			String fileName = fileList[i].getName();
			fileIdArr[i] = fileName.substring(0, 36);
		}
		
		deleteBigAttachCountInfo(fileIdArr, tenantId);
		logger.debug("deleteBigAttachCountInfo ended.");
	}
	
	@Override
	public List<MailDistributionVO> getUserOwnerDistributionList(String companyId, int tenantId, String ownerId) throws Exception {
		logger.debug("getUserOwnerDistributionList started.");
		String domain = ezCommonService.getTenantConfig("DomainName", tenantId);
		logger.debug("companyId=" + companyId + ",tenantId=" + tenantId + ",ownerId=" + ownerId + ",domain=" + domain);
		
		String inputParams = "companyId=" + URLEncoder.encode(companyId, "UTF-8");
		inputParams += "&domain=" + URLEncoder.encode(domain, "UTF-8") 
					+ "&ownerId=" +  URLEncoder.encode(ownerId, "UTF-8");
		logger.debug("inputParams=" + inputParams);

		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaAccess/getUserOwnerDistributionList";			
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		logger.debug("response=" + response);

		String resultCode = "Error";
		int reasonCode = -100; 
		List<MailDistributionVO> distributionList = new ArrayList<MailDistributionVO>();	
		
		if (response != null) {
			JSONParser jsonParser = new JSONParser();
			JSONObject responseObj = (JSONObject)jsonParser.parse(response);

			resultCode = (String)responseObj.get("resultCode");		
			if (resultCode.equals("OK")) {
				reasonCode = ((Long)responseObj.get("reasonCode")).intValue();
				
				if (reasonCode == 0) {
					JSONArray resultArray = (JSONArray)responseObj.get("result");
					
					for (int i=0; i<resultArray.size(); i++) {
						MailDistributionVO vo = new MailDistributionVO();
						
						JSONObject obj = (JSONObject)resultArray.get(i);
						
						vo.setName((String)obj.get("distributionName"));
						vo.setId((String)obj.get("distributionId"));
						vo.setMail((String)obj.get("distributionMail"));
						vo.setOwnerId((String)obj.get("ownerId"));
						vo.setDisclosurePolicy((String)obj.get("policy"));
						vo.setExplaination((String)obj.get("explaination"));
						vo.setEndDate((String)obj.get("endDate"));

						distributionList.add(vo);
					}
				}
			}
		}						
		
		logger.debug("getUserOwnerDistributionList ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);
		logger.debug(distributionList.toString());
		
		return distributionList;
	}
	
	@Override
	public List<MailDistributionVO> getUserIncludedDistributionList(String companyId, int tenantId, String userId) throws Exception {
		logger.debug("getUserIncludedDistributionList started.");
		String domain = ezCommonService.getTenantConfig("DomainName", tenantId);
		logger.debug("companyId=" + companyId + ",tenantId=" + tenantId + ",userId=" + userId + ",domain=" + domain);
		
		String inputParams = "companyId=" + URLEncoder.encode(companyId, "UTF-8")
					+ "&domain=" + URLEncoder.encode(domain, "UTF-8") + "&userId=" +  URLEncoder.encode(userId, "UTF-8");
		logger.debug("inputParams=" + inputParams);

		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaAccess/getUserIncludeDistributionList";			
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		logger.debug("response=" + response);

		String resultCode = "Error";
		int reasonCode = -100; 
		List<MailDistributionVO> distributionList = new ArrayList<MailDistributionVO>();	
		
		if (response != null) {
			JSONParser jsonParser = new JSONParser();
			JSONObject responseObj = (JSONObject)jsonParser.parse(response);

			resultCode = (String)responseObj.get("resultCode");		
			if (resultCode.equals("OK")) {
				reasonCode = ((Long)responseObj.get("reasonCode")).intValue();
				
				if (reasonCode == 0) {
					JSONArray resultArray = (JSONArray)responseObj.get("result");
					
					for (int i=0; i<resultArray.size(); i++) {
						MailDistributionVO vo = new MailDistributionVO();
						
						JSONObject obj = (JSONObject)resultArray.get(i);
						
						vo.setName((String)obj.get("distributionName"));
						vo.setId((String)obj.get("distributionId"));
						vo.setMail((String)obj.get("distributionMail"));
						vo.setOwnerId((String)obj.get("ownerId"));
						vo.setDisclosurePolicy((String)obj.get("policy"));
						vo.setExplaination((String)obj.get("explaination"));
						vo.setEndDate((String)obj.get("endDate"));

						distributionList.add(vo);
					}
				}
			}
		}						
		
		logger.debug("getUserIncludedDistributionList ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);
		logger.debug(distributionList.toString());
		
		return distributionList;
	}
	
	@Override
	public int secessionDistribution(int tenantId, String cn, String userId) throws Exception {
		logger.debug("secessionDistribution started.");
		String domain = ezCommonService.getTenantConfig("DomainName", tenantId);
		logger.debug("tenantId=" + tenantId + ", cn=" + cn + ",userId=" + userId + ",domain=" + domain);
		
		String inputParams = "cn=" + URLEncoder.encode(cn, "UTF-8")
					+ "&domain=" + URLEncoder.encode(domain, "UTF-8") + "&userId=" +  URLEncoder.encode(userId, "UTF-8");
		logger.debug("inputParams=" + inputParams);

		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaAccess/delDistributionIndivisualMember";			
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		logger.debug("response=" + response);

		String resultCode = "Error";
		int reasonCode = -100; 

		if (response != null) {
			JSONParser jsonParser = new JSONParser();
			JSONObject responseObj = (JSONObject)jsonParser.parse(response);

			resultCode = (String)responseObj.get("resultCode");		
			if (resultCode.equals("OK")) {
				reasonCode = ((Long)responseObj.get("reasonCode")).intValue();
			}
		}						
		
		logger.debug("secessionDistribution ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);
		
		return reasonCode;
	}
	
	@Override
	public MailDistributionVO getUserDistributionInfo(String cn, int tenantId) throws Exception {
		logger.debug("getUserDistributionInfo started.");

		String tenantDomain = ezCommonService.getTenantConfig("DomainName", tenantId);
		MailDistributionVO vo = null;
		logger.debug("cn=" + cn + ",tenantId=" + tenantId + ", tenantDomain=" + tenantDomain);
		
		String inputParams = "cn=" + URLEncoder.encode(cn, "UTF-8") + "&domain=" + tenantDomain;
		logger.debug("inputParams=" + inputParams);
		
		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaAccess/getUserDistributionInfo";
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		logger.debug("response=" + response);
		
		if (response != null) {
			JSONParser jsonParser = new JSONParser();
			JSONObject responseObj = (JSONObject)jsonParser.parse(response);
			JSONObject resultObj = (JSONObject)	responseObj.get("result");
			
			if (((String)responseObj.get("resultCode")).equals("OK") && (Long)responseObj.get("reasonCode") == 0 && resultObj != null) {
				vo = new MailDistributionVO();
				vo.setId((String)resultObj.get("userName"));
				vo.setOwnerId((String)resultObj.get("ownerId"));
				vo.setDisclosurePolicy((String)resultObj.get("policy"));
				vo.setExplaination((String)resultObj.get("explaination"));
				vo.setEndDate((String)resultObj.get("endDate"));
				vo.setMail((String)resultObj.get("mail"));
				vo.setCompanyId((String)resultObj.get("companyId"));
				vo.setName((String)resultObj.get("groupName"));
			}
		}		
		
		logger.debug("getUserDistributionInfo ended.");
		return vo;
	}
	
	@Override
	public JSONArray getUserDistributionApplyList(String cn, int tenantId) throws Exception {
		logger.debug("getUserDistributionApplyList started.");
		logger.debug("cn=" + cn + ",tenantId=" + tenantId);
		
		String domain = ezCommonService.getTenantConfig("DomainName", tenantId);
				
		String inputParams = "cn=" + URLEncoder.encode(cn, "UTF-8") + "&domain=" + URLEncoder.encode(domain, "UTF-8");
		logger.debug("inputParams=" + inputParams);

		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaAccess/getUserDistributionApplyList";			
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		logger.debug("response=" + response);

		String resultCode = "Error";
		int reasonCode = -100; 
		JSONArray resultArray = null;
		
		if (response != null) {
			JSONParser jsonParser = new JSONParser();
			JSONObject responseObj = (JSONObject)jsonParser.parse(response);

			resultCode = (String)responseObj.get("resultCode");		
			
			if (resultCode.equals("OK")) {
				reasonCode = ((Long)responseObj.get("reasonCode")).intValue();
				
				if (reasonCode == 0) {
					resultArray = (JSONArray)responseObj.get("result");
				}
			}
		}						
		
		logger.debug("getUserDistributionApplyList ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);
		
		return resultArray;
	}
	
	@Override
	public int setUserDistributionApply(String cn, int tenantId, String userId, String type) throws Exception {
		logger.debug("setUserDistributionApply started.");
		logger.debug("cn=" + cn + ",tenantId=" + tenantId + ",userId=" + userId + ",type=" + type);
		
		String domain = ezCommonService.getTenantConfig("DomainName", tenantId);
				
		String inputParams = "cn=" + URLEncoder.encode(cn, "UTF-8") + "&domain=" + URLEncoder.encode(domain, "UTF-8")
				 + "&userId=" + URLEncoder.encode(userId, "UTF-8") + "&type=" + URLEncoder.encode(type, "UTF-8");
		logger.debug("inputParams=" + inputParams);

		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaAccess/setUserDistributionApply";			
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		logger.debug("response=" + response);

		String resultCode = "Error";
		int reasonCode = -100; 
		
		if (response != null) {
			JSONParser jsonParser = new JSONParser();
			JSONObject responseObj = (JSONObject)jsonParser.parse(response);

			resultCode = (String)responseObj.get("resultCode");		
			
			if (resultCode.equals("OK")) {
				reasonCode = ((Long)responseObj.get("reasonCode")).intValue();
			}
		}						
		
		logger.debug("getUserDistributionApplyList ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);
		return reasonCode;
	}
	
	@Override
	public JSONArray getUserDistributionMemberList(String domain, String cn) throws Exception {
		logger.debug("getUserDistributionMemberList started.");
		logger.debug("domain=" + domain + ", cn=" + cn);
		
		String resultCode = "";
		JSONArray resultArray = null;
		
		String inputParams = "cn=" + URLEncoder.encode(cn, "UTF-8") + "&domain=" + URLEncoder.encode(domain, "UTF-8") + "&type=userDL";
		logger.debug("inputParams=" + inputParams);

		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaAccess/getDistribution";
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		logger.debug("response=" + response);

		if (response != null) {
			JSONParser jsonParser = new JSONParser();
			JSONObject responseObj = (JSONObject) jsonParser.parse(response);

			resultCode = (String) responseObj.get("resultCode");
	
			if (resultCode.equalsIgnoreCase("OK") && ((Long)responseObj.get("reasonCode")).intValue() == 0) {
				resultArray = (JSONArray)responseObj.get("result");
			}
		}
		
		logger.debug("getUserDistributionMemberList ended. resultCode=" + resultCode);
		return resultArray;
	}
	
	@Override
	public int checkUserDistributionInCludedMember(String domain, String cn, String userId) throws Exception {
		logger.debug("checkUserDistributionInCludedMember started.");
		logger.debug("domain=" + domain + ", cn=" + cn + ", userId=" + userId);
		
		String resultCode = "";
		int reasonCode = -1;
		
		String inputParams = "cn=" + URLEncoder.encode(cn, "UTF-8") + "&domain=" + URLEncoder.encode(domain, "UTF-8")
				 + "&userId=" + URLEncoder.encode(userId, "UTF-8");
		logger.debug("inputParams=" + inputParams);

		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaAccess/checkUserDistributionInCludedMember";
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		logger.debug("response=" + response);

		if (response != null) {
			JSONParser jsonParser = new JSONParser();
			JSONObject responseObj = (JSONObject) jsonParser.parse(response);

			resultCode = (String) responseObj.get("resultCode");
			reasonCode = ((Long)responseObj.get("reasonCode")).intValue(); //0:성공, -1:구성원 아님
		}
		
		logger.debug("checkUserDistributionInCludedMember ended. resultCode=" + resultCode + ", reasonCode=" + reasonCode);
		return reasonCode;
	}

	@Override
	public List<MailDistributionVO> userDistributionListSearch(String domain, String searchRange, 
			String searchValue, String userId) throws Exception {
		logger.debug("userDistributionListSearch started.");
		logger.debug("domain=" + domain + ", searchRange=" + searchRange
				 + ", searchValue=" + searchValue + ", userId=" + userId);
		
		String resultCode = "";
		int reasonCode = -1;
		List<MailDistributionVO> distributionList = new ArrayList<MailDistributionVO>();	
		
		String inputParams = "domain=" + URLEncoder.encode(domain, "UTF-8") + "&searchRange=" + URLEncoder.encode(searchRange, "UTF-8")
				 + "&searchValue=" + URLEncoder.encode(searchValue, "UTF-8")+ "&userId=" + URLEncoder.encode(userId, "UTF-8");
		logger.debug("inputParams=" + inputParams);

		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaAccess/getUserDistributionListSearch";
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		logger.debug("response=" + response);
		
		if (response != null) {
			JSONParser jsonParser = new JSONParser();
			JSONObject responseObj = (JSONObject)jsonParser.parse(response);

			resultCode = (String)responseObj.get("resultCode");		
			if (resultCode.equals("OK")) {
				reasonCode = ((Long)responseObj.get("reasonCode")).intValue();
				
				if (reasonCode == 0) {
					JSONArray resultArray = (JSONArray)responseObj.get("result");
					
					for (int i=0; i<resultArray.size(); i++) {
						MailDistributionVO vo = new MailDistributionVO();
						
						JSONObject obj = (JSONObject)resultArray.get(i);
						
						vo.setName((String)obj.get("groupName"));
						vo.setId((String)obj.get("userName"));
						vo.setMail((String)obj.get("mail"));
						vo.setOwnerId((String)obj.get("ownerId"));
						vo.setDisclosurePolicy((String)obj.get("policy"));
						vo.setExplaination((String)obj.get("explaination"));
						vo.setEndDate((String)obj.get("endDate"));
						vo.setCompanyId((String)obj.get("companyId"));
						
						distributionList.add(vo);
					}
				}
			}
		}	
		
		logger.debug("userDistributionListSearch ended. resultCode=" + resultCode + ", reasonCode=" + reasonCode);
		return distributionList;
	}
	
	@Override
	public int checkUserDistributionApply(String cn, String domain, String userId) throws Exception {
		logger.debug("checkUserDistributionApply started.");
		logger.debug("cn=" + cn + ",domain=" + domain + ",userId=" + userId);
		
		String inputParams = "cn=" + URLEncoder.encode(cn, "UTF-8") + "&domain=" + URLEncoder.encode(domain, "UTF-8")
				 + "&userId=" + URLEncoder.encode(userId, "UTF-8");
		logger.debug("inputParams=" + inputParams);

		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaAccess/getUserDistributionApply";			
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		logger.debug("response=" + response);

		String resultCode = "Error";
		int reasonCode = -100; 
		
		if (response != null) {
			JSONParser jsonParser = new JSONParser();
			JSONObject responseObj = (JSONObject)jsonParser.parse(response);

			resultCode = (String)responseObj.get("resultCode");		
			
			if (resultCode.equals("OK")) {
				reasonCode = ((Long)responseObj.get("reasonCode")).intValue(); // 0:가입신청, -1:가입신청 안함
			}
		}						
		
		logger.debug("checkUserDistributionApply ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);
		return reasonCode;
	}
	
	@Override
	public List<MailDistributionVO> getExpiredUserDistributionList() throws Exception {
		logger.debug("getExpiredUserDistributionList started.");
		
		String inputParams = "";
		logger.debug("inputParams=" + inputParams);

		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaAccess/getExpiredUserDistributionList";			
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		logger.debug("response=" + response);

		String resultCode = "Error";
		List<MailDistributionVO> returnList = null;
		
		if (response != null) {
			JSONParser jsonParser = new JSONParser();
			JSONObject responseObj = (JSONObject)jsonParser.parse(response);

			resultCode = (String)responseObj.get("resultCode");		
			
			if (resultCode.equals("OK")) {
				returnList = new ArrayList<MailDistributionVO>();

				JSONArray resultArray = (JSONArray)responseObj.get("result");
	        	
	        	for (int i=0; i<resultArray.size(); i++) {
	        		JSONObject obj = (JSONObject)resultArray.get(i);
	        		
	        		MailDistributionVO dlVo = new MailDistributionVO();
	        		
	        		dlVo.setDomain((String)obj.get("domain"));
	        		dlVo.setId((String)obj.get("userName"));
	        		
	        		returnList.add(dlVo);
	        	}
			}
		}						
		
		logger.debug("getExpiredUserDistributionList ended. resultCode=" + resultCode);
		return returnList;
	}
	
	/**
	 * 공용배포그룹 추가, 반려 알림 메일
	 * type : add or refuse
	 */
	@Override
	public void sendUserDLMail(String loginCookie, String cn, String type, List<String> toList) throws Exception {
		logger.debug("sendUserDlMail started.");
		
		if (loginCookie.equals("")) {return; }

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();
		int tenantId = userInfo.getTenantId();
		logger.debug("userId=" + userId + ", cn=" + cn + ", type=" + type + ", toList=" + toList.toString() + ", tenantId=" + tenantId);
		
		MailDistributionVO dlVo = getUserDistributionInfo(cn, tenantId);
		String dlName = dlVo.getName();
		logger.debug("dl Name=" + dlName);
	
		String mailTypeStr = type.equals("refuse") ? "ezEmail.userDL38" : "ezEmail.userDL37";
		String subject = egovMessageSource.getMessage("ezEmail.userDL36", userInfo.getLocale());	// 메일제목
		subject += egovMessageSource.getMessage(mailTypeStr, userInfo.getLocale());
		StringBuilder bodyContent = new StringBuilder("");	// 메일 링크
		bodyContent.append(" \'" + dlName + "\' " + egovMessageSource.getMessage(mailTypeStr, userInfo.getLocale()));
		String content = commonUtil.createNotiMailContent(bodyContent.toString(), tenantId, userInfo.getLocale());
		
		// 참여자에게 메일 발송
		int toListCnt = toList.size();
		InternetAddress from = new InternetAddress();
		from.setPersonal(userInfo.getDisplayName(), "UTF-8");
		from.setAddress(userInfo.getEmail());
		
		for (int i=0; i < toListCnt; i++) {
			String toId = toList.get(i).trim();
			toId = toId.split("@")[0];
			OrganUserVO AccessUserInfo = ezOrganAdminService.getUserInfo(toId, userInfo.getPrimary(), tenantId);
			
			if (AccessUserInfo != null) {
				InternetAddress to = new InternetAddress();
				to.setPersonal(AccessUserInfo.getDisplayName(), "UTF-8");
				to.setAddress(AccessUserInfo.getMail());
				
				InternetAddress [] toArr = new InternetAddress[]{to};
				sendMail(loginCookie, from, toArr, null, null, subject, content, false);
			}
		}
		
		logger.debug("sendUserDlMail ended.");
	}
	

	@Override
	public void sendMail(String userEmail, String password, Locale userLocale, InternetAddress from, InternetAddress[] toArr, InternetAddress[] ccArr, InternetAddress[] bccArr, String subject, String content, boolean isSaved, EmailImportance importance, String fileName, String contentType, InputStream inputStream) throws Exception {
		logger.debug("sendMail started.");
		logger.debug("from=" + from + ",subject=" + subject + ",isSaved=" + isSaved);

		ezEmailUtil.createMail(userEmail, password)
			.from(from)
			.to(toArr)
			.cc(ccArr)
			.bcc(bccArr)
			.subject(subject)
			.content(content)
			.importance(importance)
			.saveSentMailbox(isSaved)
			.attach(fileName, contentType, inputStream)
		.send();
		
        logger.debug("sendMail ended.");   
	}
	
	public void deleteBigAttachCountInfo(String[] fileIdArr, int tenantId) throws Exception {
		logger.debug("deleteBigAttachCountInfo(String[], tenantId) started.");
		
		Map<String, Object> map = new HashMap<>();
		map.put("fileIdArr", fileIdArr);
		map.put("tenantId", tenantId);
		
		ezEmailDAO.deleteBigAttachCountInfo(map);
		logger.debug("deleteBigAttachCountInfo ended.");
	}
	
	@Override
	public int deleteMailDeleteForUser(String pUserEmail) throws Exception {
		logger.debug("deleteMailDeleteForUser started.");
		logger.debug("pUserEmail=" + pUserEmail);
		
		int returnInt = -100;
		
		String inputParams = "userId=" + pUserEmail;
		logger.debug("inputParams=" + inputParams);
		try {
			String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaEzEmail/deleteMailDeleteForUser", inputParams);
			logger.debug("strJson=" + strJson);
			
			JSONParser parser = new JSONParser();
			JSONObject object = (JSONObject)parser.parse(strJson);
	        
	        if (!object.get("resultCode").equals("OK") || ((Long)object.get("reasonCode")).intValue() != 0) {
	        	throw new Exception("JGwServer ERROR");
	        }
		} catch (ParseException e) {
			logger.error(e.getMessage(), e);
		} catch (Exception e) {
			logger.debug("[JGW-SERVER ERROR] deleteMailDeleteForUser.");
		}

		logger.debug("deleteMailDeleteForUser ended.");
        return returnInt;
	}

	/**
	 * 2020-09-11 김은실-(빗썸코리아)메일삭제: MessageId들에 일치하는 행 delete
	 */
	@Override
	public int deleteMailsByMessageIds(String messageIds) throws Exception {
		logger.debug("deleteMailsByMessageIds started. messageIds=" + messageIds);

		int returnInt = -1;

		String inputParams = "messageIds=" + URLEncoder.encode(messageIds, "UTF-8");
		logger.debug("inputParams=" + inputParams);

		String response = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaAccess/deleteMailsByMessageIds", inputParams);
		logger.debug("strJson=" + response);

		if (response != null) {
			// String으로 온 Json을: JSONParser를 이용해 JSONObject로 변환해준다.
			JSONParser jsonParser = new JSONParser();
			JSONObject responseObj = (JSONObject)jsonParser.parse(response);

			if (((String)responseObj.get("resultCode")).equals("OK") && (Long)responseObj.get("reasonCode") == 0) {
				// jgw에서 int로 보내도, Long으로 해석한다.
				returnInt = ((Long)responseObj.get("resultInt")).intValue();
			}
		}

		logger.debug("deleteMailsByMessageIds ended.");
		return returnInt;
	}

	@Override
	public int blockMailsByMessageIds(String messageIds) throws Exception {
		logger.debug("blockMailsByMessageIds started. messageIds=" + messageIds);

		int returnInt = -1;

		String inputParams = "messageIds=" + URLEncoder.encode(messageIds, "UTF-8");
		logger.debug("inputParams=" + inputParams);

		String response = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaAccess/blockMailsByMessageIds", inputParams);
		logger.debug("strJson=" + response);

		if (response != null) {
			// String으로 온 Json을: JSONParser를 이용해 JSONObject로 변환해준다.
			JSONParser jsonParser = new JSONParser();
			JSONObject responseObj = (JSONObject)jsonParser.parse(response);

			if (((String)responseObj.get("resultCode")).equals("OK") && (Long)responseObj.get("reasonCode") == 0) {
				// jgw에서 int로 보내도, Long으로 해석한다.
				returnInt = ((Long)responseObj.get("resultInt")).intValue();
			}
		}

		logger.debug("blockMailsByMessageIds ended.");
		return returnInt;
	}

	@Override
	public int unblockMailsByMessageIds(String messageIds) throws Exception {
		logger.debug("unblockMailsByMessageIds started. messageIds=" + messageIds);

		int returnInt = -1;

		String inputParams = "messageIds=" + URLEncoder.encode(messageIds, "UTF-8");
		logger.debug("inputParams=" + inputParams);

		String response = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaAccess/unblockMailsByMessageIds", inputParams);
		logger.debug("strJson=" + response);

		if (response != null) {
			// String으로 온 Json을: JSONParser를 이용해 JSONObject로 변환해준다.
			JSONParser jsonParser = new JSONParser();
			JSONObject responseObj = (JSONObject)jsonParser.parse(response);

			if (((String)responseObj.get("resultCode")).equals("OK") && (Long)responseObj.get("reasonCode") == 0) {
				// jgw에서 int로 보내도, Long으로 해석한다.
				returnInt = ((Long)responseObj.get("resultInt")).intValue();
			}
		}

		logger.debug("unblockMailsByMessageIds ended.");
		return returnInt;
	}

	@Override
	public int checkBlockedMailByMessageId(String messageId) throws Exception {
		logger.debug("checkBlockedMailByMessageId started. messageId=" + messageId);

		int returnInt = -1;

		String inputParams = "messageId=" + URLEncoder.encode(messageId, "UTF-8");
		logger.debug("inputParams=" + inputParams);

		String response = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaAccess/checkBlockedMailByMessageId", inputParams);
		logger.debug("strJson=" + response);

		if (response != null) {
			// String으로 온 Json을: JSONParser를 이용해 JSONObject로 변환해준다.
			JSONParser jsonParser = new JSONParser();
			JSONObject responseObj = (JSONObject)jsonParser.parse(response);

			if (((String)responseObj.get("resultCode")).equals("OK") && (Long)responseObj.get("reasonCode") == 0) {
				// jgw에서 int로 보내도, Long으로 해석한다.
				returnInt = ((Long)responseObj.get("resultInt")).intValue();
			}
		}

		logger.debug("checkBlockedMailByMessageId ended.");
		return returnInt;
	}
	
	@Override
	public void setMailboxProgress(String userKey, String userId, String action, int tenantId, int percent) throws Exception {
		logger.debug("setMailboxProgress started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userKey", userKey);
		map.put("userId", userId);
		map.put("action", action);
		map.put("tenantId", tenantId);
		map.put("percent", percent);
		
		ezEmailDAO.setMailboxProgress(map);
		
		logger.debug("setMailboxProgress ended.");
	}
	
	@Override
	public int updateMailboxProgress(String userKey, int percent) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userKey", userKey);
		map.put("percent", percent);
		
		return ezEmailDAO.updateMailboxProgress(map);
	}

	@Override
	public int updateMailboxProgressState(String userKey, String state, String stateDescription) {
		return ezEmailDAO.updateMailboxProgressState(userKey, state, stateDescription);
	}

	@Override
	public MailboxProgressVO getMailboxProgress(String userKey) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userKey", userKey);

		MailboxProgressVO mailboxProgressVO = Optional.ofNullable(ezEmailDAO.getMailboxProgress(map))
				.orElse(new MailboxProgressVO());
		if (mailboxProgressVO.getProgress() == null) {
			mailboxProgressVO.setProgress(-100);
		}

		return mailboxProgressVO;
	}

	@Override
	public int delMailboxProgress(String userKey) throws Exception {
		logger.debug("delMailboxProgress started.");
		logger.debug("userKey=" + userKey);

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userKey", userKey);
		
		int resultInt = ezEmailDAO.deleteMailboxProgress(map);
		
		logger.debug("delMailboxProgress ended.");
		return resultInt;
	}

	@Override
	public JSONArray getMailOutOfOfficeTemplateList(String userEmail) throws Exception {
		logger.debug("getMailOutOfOfficeTemplateList started.");
		logger.debug("userEmail=" + userEmail);
		
		JSONArray jsonArr = new JSONArray();
		
		String inputParams = "userId=" + URLEncoder.encode(userEmail, "UTF-8");
		logger.debug("inputParams=" + inputParams);

		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaAccess/getMailOutOfOfficeTemplateList";
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		logger.debug("response=" + response);

		if (response != null) {
			JSONParser jsonParser = new JSONParser();
			JSONObject responseObj = (JSONObject)jsonParser.parse(response);
			String resultCode = (String)responseObj.get("resultCode");

			if (resultCode.equalsIgnoreCase("OK")) {
				JSONArray resultArray = (JSONArray)responseObj.get("result");

				if (resultArray != null && resultArray.size() > 0) {
					jsonArr = resultArray;
				}
			}				
		}	
		
		logger.debug("getMailOutOfOfficeTemplateList ended.");
		return jsonArr;
	}

	@Override
	public JSONObject getMailOutOfOfficeTemplate(String userEmail, String displayName) throws Exception {
		logger.debug("getMailOutOfOfficeTemplate started.");
		logger.debug("userEmail=" + userEmail + ", displayName=" + displayName);
		
		JSONObject resultObj = null;
		
		String inputParams = "userId=" + URLEncoder.encode(userEmail, "UTF-8")
				+ "&displayName=" + URLEncoder.encode(displayName, "UTF-8");
		logger.debug("inputParams=" + inputParams);

		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaAccess/getMailOutOfOfficeTemplate";
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		logger.debug("response=" + response);

		if (response != null) {
			JSONParser jsonParser = new JSONParser();
			JSONObject responseObj = (JSONObject)jsonParser.parse(response);
			String resultCode = (String)responseObj.get("resultCode");

			if (resultCode.equalsIgnoreCase("OK")) {
				if ((JSONObject)responseObj.get("result") != null) {
					resultObj = (JSONObject) responseObj.get("result");
				}
			}				
		}else{
			resultObj = new JSONObject();
		}

		logger.debug("getMailOutOfOfficeTemplate ended.");
		return resultObj;
	}

	@Override
	public int saveMailOutOfOfficeTemplate(String userEmail, String modDisplayName, String displayName, String content, String type) throws Exception {
		logger.debug("saveMailOutOfOfficeTemplate started.");
		logger.debug("userEmail=" + userEmail + ", modDisplayName=" + modDisplayName + ", displayName=" + displayName + ", content=" + content);
		
		int resultInt = -100;
		
		String inputParams = "userId=" + URLEncoder.encode(userEmail, "UTF-8")
				+ "&modDisplayName=" + URLEncoder.encode(modDisplayName, "UTF-8")
				+ "&displayName=" + URLEncoder.encode(displayName.trim(), "UTF-8")
				+ "&content=" + URLEncoder.encode(content, "UTF-8")
				+ "&type=" + URLEncoder.encode(type, "UTF-8");
		logger.debug("inputParams=" + inputParams);

		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaAccess/setOutOfOfficeTemplate";
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		logger.debug("response=" + response);

		if (response != null) {
			JSONParser jsonParser = new JSONParser();
			JSONObject responseObj = (JSONObject)jsonParser.parse(response);
			String resultCode = (String)responseObj.get("resultCode");

			if (resultCode.equalsIgnoreCase("OK")) {
				resultInt = ((Long)responseObj.get("reasonCode")).intValue(); 
			}				
		}

		logger.debug("saveMailOutOfOfficeTemplate ended.");
		return resultInt;
	}
	
	@Override
	public int deleteMailOutOfOfficeTemplate(String userEmail, String displayName) throws Exception {
		logger.debug("deleteMailOutOfOfficeTemplate started.");
		logger.debug("userEmail=" + userEmail + ", displayName=" + displayName);
		
		int resultInt = -100;
		
		String inputParams = "userId=" + URLEncoder.encode(userEmail, "UTF-8")
				+ "&displayName=" + URLEncoder.encode(displayName, "UTF-8");
		logger.debug("inputParams=" + inputParams);

		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaAccess/delMailOutOfOfficeTemplate";
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		logger.debug("response=" + response);

		if (response != null) {
			JSONParser jsonParser = new JSONParser();
			JSONObject responseObj = (JSONObject)jsonParser.parse(response);
			String resultCode = (String)responseObj.get("resultCode");

			if (resultCode.equalsIgnoreCase("OK")) {
				resultInt = ((Long)responseObj.get("reasonCode")).intValue(); 
			}				
		}

		logger.debug("deleteMailOutOfOfficeTemplate ended.");
		return resultInt;
	}
	
	@Override
	public JSONArray getUserMailTemplateList(String userEmail) throws Exception {
		logger.debug("getUserMailTemplateList started.");
		logger.debug("userEmail=" + userEmail);

		JSONArray jsonArr = new JSONArray();
		
		String inputParams = "userId=" + URLEncoder.encode(userEmail, "UTF-8");
		logger.debug("inputParams=" + inputParams);

		String requestURL = config.getProperty("config.JGwServerURL") + "/JMochaLetter/selectUserMailTemplateList";
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		logger.debug("response=" + response);
		
		if (response != null) {
			JSONParser jsonParser = new JSONParser();
			JSONObject responseObj = (JSONObject)jsonParser.parse(response);
			String resultCode = (String)responseObj.get("resultCode");

			if (resultCode.equalsIgnoreCase("OK")) {
				JSONArray resultArray = (JSONArray)responseObj.get("result");

				if (resultArray != null && resultArray.size() > 0) {
					jsonArr = resultArray;
				}
			}				
		}
		
		logger.debug("getUserMailTemplateList ended.");
		return jsonArr;
	}

	@Override
	public JSONObject getUserMailTemplate(String userEmail, String templateId) throws Exception {
		logger.debug("getUserMailTemplate started.");
		logger.debug("userEmail=" + userEmail + ", templateId=" + templateId);
		
		JSONObject resultObj = null;
		
		String inputParams = "userId=" + URLEncoder.encode(userEmail, "UTF-8")
				+ "&templateId=" + URLEncoder.encode(templateId, "UTF-8");
		logger.debug("inputParams=" + inputParams);

		String requestURL = config.getProperty("config.JGwServerURL") + "/JMochaLetter/selectUserMailTemplate";
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		logger.debug("response=" + response);

		if (response != null) {
			JSONParser jsonParser = new JSONParser();
			JSONObject responseObj = (JSONObject)jsonParser.parse(response);
			String resultCode = (String)responseObj.get("resultCode");

			if (resultCode.equalsIgnoreCase("OK")) {
				if ((JSONObject)responseObj.get("result") != null) {
					resultObj = (JSONObject) responseObj.get("result");
				}
			}				
		}

		logger.debug("getUserMailTemplate ended.");
		return resultObj;
	}

	@Override
	public int saveUserMailTemplate(String userEmail, String displayName, String content, String realPath, String editorType, int tenantId) throws Exception {
		logger.debug("saveUserMailTemplate started.");
		logger.debug("userEmail=" + userEmail + ", displayName=" + displayName + ", content=" + content, ", tenantId=" + tenantId
				+ ", editorType=" + editorType);
		
		String templateId = UUID.randomUUID().toString();
		
		String uploadMailTemplatePath = commonUtil.getUploadPath("upload_mail.MAILTEMPLATE", tenantId);
		String mailTemplatePath = uploadMailTemplatePath + "/" + userEmail + "/" + templateId;
		
		if (editorType.equals("0")) { // html mode
			org.jsoup.nodes.Document doc = Jsoup.parseBodyFragment(content);
			Elements imagesEle = doc.getElementsByTag("img");
			
			if (imagesEle != null && imagesEle.size() > 0) {
				logger.debug("imagesEle size=" + imagesEle.size());

				String templatePathTmp = mailTemplatePath + "/temp";
				File mailTemplateFolder = new File(realPath + templatePathTmp);
				FileUtils.forceMkdir(mailTemplateFolder);
				
				for (org.jsoup.nodes.Element img : imagesEle) {
					try {
						String sourceFilePath  = img.attr("src");
						String fileType        = sourceFilePath.substring(sourceFilePath.lastIndexOf(".") + 1);
						logger.debug("fileType={},  sourceFilePath={}", fileType, sourceFilePath);
						
						String fileName      = UUID.randomUUID() + "." + fileType;
						String destFilePath  = templatePathTmp + "/" + fileName;
						logger.debug("sourceFilePath=" + sourceFilePath + ", destFilePath=" + destFilePath);
						
						File srcFile  = new File(realPath + "/" + sourceFilePath);
						File destFile = new File(realPath + "/" + destFilePath);
						FileUtils.copyFile(srcFile, destFile);
						
						img.attr("src", mailTemplatePath + "/" + fileName);
					} catch (IndexOutOfBoundsException e) {
						logger.error(e.getMessage(), e);
					} catch (Exception e) {
						logger.debug("userMailTemplateContent Error.");
						logger.error(e.getMessage(), e);
					}
				}
				
				content = doc.toString();
			}
		}
		
		int resultInt = -100; // 0:성공, -1:실패, -2:이름중복
		
		String inputParams = "userId=" + URLEncoder.encode(userEmail, "UTF-8")
				+ "&displayName=" + URLEncoder.encode(displayName, "UTF-8")
				+ "&content=" + URLEncoder.encode(content, "UTF-8")
				+ "&templateId=" + URLEncoder.encode(templateId, "UTF-8")
				+ "&editorType=" + URLEncoder.encode(editorType, "UTF-8");
		
		String requestURL = config.getProperty("config.JGwServerURL") + "/JMochaLetter/setUserMailTemplate";
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		logger.debug("response=" + response);

		if (response != null) {
			JSONParser jsonParser = new JSONParser();
			JSONObject responseObj = (JSONObject)jsonParser.parse(response);
			String resultCode = (String)responseObj.get("resultCode");

			if (resultCode.equalsIgnoreCase("OK")) {
				resultInt = ((Long)responseObj.get("reasonCode")).intValue(); 
			}			
		}
		
		if (editorType.equals("0")) {
			File mvFolder  = new File(realPath + "/" + mailTemplatePath);
			File tmpFolder = new File(realPath + "/" + mailTemplatePath + "/temp");
			
			if (tmpFolder.exists()) {
				File[] files = tmpFolder.listFiles();
 
				for (File f : files) {
					if (resultInt == 0) {
						File mf = new File(mvFolder, f.getName());
						f.renameTo(mf);
					} else {
						f.delete();
					}
				}
				
				boolean tmpDel = tmpFolder.delete();
				if (resultInt != 0) {
					mvFolder.delete();
				}
				logger.debug("tmpDel status={}", tmpDel);
			}
		}
		
		logger.debug("saveUserMailTemplate ended.");
		return resultInt;
	}

	// type = all(전체), indivisual(개별)
	@Override
	public int deleteUserMailTemplate(String userEmail, String templateId, String type, String realPath, int tenantId) throws Exception {
		logger.debug("deleteUserMailTemplate started.");
		logger.debug("userEmail=" + userEmail + ", templateId=" + templateId + ", type=" + type, ", tenantId=" + tenantId);
		
		int resultInt = -100; // 0:성공, -1:실패
		
		String inputParams = "userId=" + URLEncoder.encode(userEmail, "UTF-8")
				+ "&templateId=" + URLEncoder.encode(templateId, "UTF-8")
				+ "&type=" + URLEncoder.encode(type, "UTF-8");
		
		String requestURL = config.getProperty("config.JGwServerURL") + "/JMochaLetter/delUserMailTemplate";
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		logger.debug("response=" + response);

		if (response != null) {
			JSONParser jsonParser = new JSONParser();
			JSONObject responseObj = (JSONObject)jsonParser.parse(response);
			String resultCode = (String)responseObj.get("resultCode");

			if (resultCode.equalsIgnoreCase("OK")) {
				// 이미지 삭제
				String uploadMailTemplatePath = commonUtil.getUploadPath("upload_mail.MAILTEMPLATE", tenantId);
				String mailTemplatePath = uploadMailTemplatePath + "/" + userEmail;
				mailTemplatePath += type.equalsIgnoreCase("all") ? "" :	"/" + templateId;

				try {
					File testFile = new File(realPath + mailTemplatePath);
					FileUtils.deleteDirectory(testFile);
				} catch (RuntimeException e) {
					logger.error(e.getMessage(), e);
				} catch (Exception e) {
					logger.error(e.getMessage(), e);
				}
				
				resultInt = ((Long)responseObj.get("reasonCode")).intValue();
			}				
		}

		logger.debug("deleteUserMailTemplate ended.");
		return resultInt;
	}
	
	// 2023-04-04 김대현 메일 전달기능 등록한 주소가 내부domainList에 등록된 주소인지 확인 로직
	@Override
	public String checkInnerDomain(String forwardAddress, int tenantId) throws Exception {
		logger.debug("checkInnerDomain started.");
	
		String result = "OK";
		String innerDomain = getMultiDomainList(tenantId); // 도메인 가져오는거 ;으로 구분됨
		
		logger.debug("forwardAddress={}, innerDomain={}", forwardAddress, innerDomain);
		
		List<String> forwardAddressList = Arrays.asList(forwardAddress.split(";")); //전달할 메일계정 List
		List<String> innerDomainList = Arrays.asList(innerDomain.split(";")); //내부도메인List
		
		for (String email : forwardAddressList) {
			String domainName = email.split("@")[1];
			
			if (!innerDomainList.contains(domainName)) {
				result = "FAIL";
				break;
			}
		}
		
		logger.debug("checkInnerDomain ended. result = {}", result);
		return result;
	}
	
	public JSONObject getDistributionMemberList(String domain, String cn) throws Exception {
		logger.debug("getDistributionMemberList started.");
		logger.debug("domain=" + domain + ", cn=" + cn);

		String resultCode = "";
		JSONObject resultObject = null;

		String inputParams = "cn=" + URLEncoder.encode(cn, "UTF-8") + "&domain=" + URLEncoder.encode(domain, "UTF-8");
		logger.debug("inputParams=" + inputParams);

		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaAccess/getDistribution";
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		logger.debug("response=" + response);

		if (response != null) {
			JSONParser jsonParser = new JSONParser();
			resultObject = (JSONObject) jsonParser.parse(response);
		}

		logger.debug("getDistributionMemberList ended. resultCode=" + resultCode);
		return resultObject;
	}
	
	/**
	 * 관리자 전사승인메일
	 * - 승인대기목록 가져오기 (type=pending)
     * - 승인로그 가져오기    (type=complete)
	 * @param tenantId, companyId, type, id, lang, pageStartNum, listCount
	 */
	@Override
	public JSONArray getAdminCompApprMailList(int tenantId, String companyId, String type, String id, String lang, int pageStartNum, int listCount) throws Exception {
		logger.debug("getAdminCompApprMailList {} for id={} started.", type, id);

		// jgw서버에서 승인메일 리스트를 가져 옴
		String inputParams = String.format("tenantId=%d&companyId=%s&type=%s&id=%s&lang=%s&pageStartNum=%d&listCount=%d", tenantId, companyId, type, id, lang, pageStartNum, listCount);
		logger.debug("inputParams={}", inputParams);

		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzEmailAppr/getAdminCompApprMailList";
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);

		// 승인메일 결과를 로그 출력
		JSONArray resultArray = new JSONArray();
		JSONParser parser = new JSONParser();
		JSONObject resultObj = (JSONObject) parser.parse(response);

		String resultCode = (String) resultObj.get("resultCode");
		Long reasonCode = (Long) resultObj.get("reasonCode");
		logger.debug("getAdminCompApprMailList {} for id={} ended. resultCode={}, reasonCode={}", type, id, resultCode,	reasonCode);

		// 승인메일 리스트가 있는 경우에는 리스트를 반환하고, 오류는 던짐
		if ("OK".equals(resultCode) && (reasonCode.intValue() == 0)) {
			resultArray = (JSONArray) resultObj.get("result");
		} else {
			throw new Exception("JGwServer ERROR");
		}

		return resultArray;
	}

	/**
	 * 관리자 승인메일
     * - 승인로그 가져오기    (type=complete)
	 * @param tenantId, companyId, type, id, lang, pageStartNum, listCount
	 */
	@Override
	public JSONArray getAdminApprMailList(int tenantId, String companyId, String type, String id, String lang, int pageStartNum, int listCount) throws Exception {
		logger.debug("getAdminApprMailList {} for id={} started.", type, id);

		// jgw서버에서 승인메일 리스트를 가져 옴
		String inputParams = String.format("tenantId=%d&companyId=%s&type=%s&id=%s&lang=%s&pageStartNum=%d&listCount=%d", tenantId, companyId, type, id, lang, pageStartNum, listCount);
		logger.debug("inputParams={}", inputParams);

		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzEmailAppr/getAdminApprMailList";
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);

		// 승인메일 결과를 로그 출력
		JSONArray resultArray = new JSONArray();
		JSONParser parser = new JSONParser();
		JSONObject resultObj = (JSONObject) parser.parse(response);

		String resultCode = (String) resultObj.get("resultCode");
		Long reasonCode = (Long) resultObj.get("reasonCode");
		logger.debug("getAdminApprMailList {} for id={} ended. resultCode={}, reasonCode={}", type, id, resultCode,	reasonCode);

		// 승인메일 리스트가 있는 경우에는 리스트를 반환하고, 오류는 던짐
		if ("OK".equals(resultCode) && (reasonCode.intValue() == 0)) {
			resultArray = (JSONArray) resultObj.get("result");
		} else {
			throw new Exception("JGwServer ERROR");
		}

		return resultArray;
	}
	
	/**
	 * 관리자 승인메일
     * 전사승인메일 승인대기목록 카운트 가져오기 (type=apprCompPending)
     * 전사승인메일 승인로그 카운트 가져오기 (type=apprCompLog)
     * 승인메일 승인로그 카운트 가져오기 (type=apprLog)
	 * @param tenantId, companyId, type, id
	 */
	@Override
	public int getAdminApprMailListCount(int tenantId, String companyId, String type, String id) throws Exception {

		logger.debug("getApprMailListCount {} for id={} started.", type, id);

		// jgw서버에서 승인메일 카운트를 가져 옴
		String inputParams = String.format("tenantId=%d&companyId=%s&type=%s&id=%s", tenantId, companyId, type, id);
		logger.debug("inputParams={}", inputParams);

		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzEmailAppr/getAdminApprMailListCount";
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);

		// 카운트 조회 결과를 로그로 출력
		JSONParser parser = new JSONParser();
		JSONObject resultObj = (JSONObject) parser.parse(response);

		String resultCode = (String) resultObj.get("resultCode");
		Long reasonCode = (Long) resultObj.get("reasonCode");
		Long resultCountLong = (Long) resultObj.get("resultCount");
		int pageTotalCount = resultCountLong.intValue();
		logger.debug("getApprMailListCount {} for id={} ended. resultCode={}, reasonCode={}, pageTotalCount={}", type, id, resultCode, reasonCode, pageTotalCount);

		// 카운트 조회 결과 반환, 오류는 던짐
		if (!"OK".equals(resultCode) || reasonCode.intValue() != 0) {
			throw new Exception("JGwServer ERROR");
		}

		return pageTotalCount;
	}

	/**
	 * 승인메일 
	 * - 발송요청목록 type=user 
	 * - 발송승인대기 type=approver 
	 * - 발송완료목록 type=complete
	 * @param tenantId, companyId, type, id, lang, pageStartNum, listCount
	 */
	@Override
	public JSONArray getApprMailList(int tenantId, String companyId, String type, String id, String lang, int pageStartNum, int listCount, String domainName)
			throws Exception {
		logger.debug("getApprMailList {} for id={} started.", type, id);

		// jgw서버에서 승인메일 리스트를 가져 옴
		String inputParams = String.format("tenantId=%d&companyId=%s&type=%s&id=%s&lang=%s&pageStartNum=%d&listCount=%d&domainName=%s", tenantId, companyId, type, id, lang, pageStartNum, listCount, domainName);
		logger.debug("inputParams={}", inputParams);

		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzEmailAppr/getApprMailList";
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);

		// 승인메일 결과를 로그 출력
		JSONArray resultArray = new JSONArray();
		JSONParser parser = new JSONParser();
		JSONObject resultObj = (JSONObject) parser.parse(response);

		String resultCode = (String) resultObj.get("resultCode");
		Long reasonCode = (Long) resultObj.get("reasonCode");
		logger.debug("getApprMailList {} for id={} ended. resultCode={}, reasonCode={}", type, id, resultCode,	reasonCode);

		// 승인메일 리스트가 있는 경우에는 리스트를 반환하고, 오류는 던짐
		if ("OK".equals(resultCode) && (reasonCode.intValue() == 0)) {
			resultArray = (JSONArray) resultObj.get("result");
		} else {
			throw new Exception("JGwServer ERROR");
		}

		return resultArray;
	}

	/**
	 * 승인메일
	 * - 발송요청목록 카운트 type=user
	 * - 발송승인대기 카운트 type=approver
	 * - 발송완료목록 카운트 type=complete
	 * @param tenantId, companyId, type, id
	 */
	@Override
	public int getApprMailListCount(int tenantId, String companyId, String type, String id) throws Exception {

		logger.debug("getApprMailListCount {} for id={} started.", type, id);

		// jgw서버에서 승인메일 카운트를 가져 옴
		String inputParams = String.format("tenantId=%d&companyId=%s&type=%s&id=%s", tenantId, companyId, type, id);
		logger.debug("inputParams={}", inputParams);

		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzEmailAppr/getApprMailListCount";
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);

		// 카운트 조회 결과를 로그로 출력
		JSONParser parser = new JSONParser();
		JSONObject resultObj = (JSONObject) parser.parse(response);

		String resultCode = (String) resultObj.get("resultCode");
		Long reasonCode = (Long) resultObj.get("reasonCode");
		Long resultCountLong = (Long) resultObj.get("resultCount");
		int listTotalCount = resultCountLong.intValue();
		logger.debug("getApprMailListCount {} for id={} ended. resultCode={}, reasonCode={}, pageTotalCount={}", type, id, resultCode, reasonCode, listTotalCount);

		// 카운트 조회 결과 반환, 오류는 던짐
		if (!"OK".equals(resultCode) || reasonCode.intValue() != 0) {
			throw new Exception("JGwServer ERROR");
		}

		return listTotalCount;
	}

	/**
	 * 승인메일 : UTC -> 사용자 timeZone으로 변경하는 api 
	 * 작성일시 - writeDate, 승인일시 - updatedt
	 * 2025-01-14 메일주소 real -> primary로 변경 추가
	 */
	@SuppressWarnings("unchecked")
	@Override
	public JSONArray setUTCtoUserTime(JSONArray array, String offset, int tenantId) throws Exception {
		JSONArray resultArry = new JSONArray();

		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
		sdf.setTimeZone(TimeZone.getTimeZone("GMT"));

		for (int i = 0; i < array.size(); i++) {
			JSONObject obj = (JSONObject) array.get(i);

			Date writeDate = sdf.parse(obj.get("writeDate").toString());
			String writeDateStr = sdf.format(writeDate);
			writeDateStr = commonUtil.getDateStringInUTC(writeDateStr, offset, false);
			obj.put("writeDate", writeDateStr);

			String senderId = obj.get("senderEmail").toString().split("@")[0];
			OrganUserVO senderVO = ezOrganAdminService.getUserInfo(senderId, "1", tenantId); // 신청자의 primary 메일주소만 필요하기 때문에 lang 값 1로 픽스 함
			obj.put("senderEmail", senderVO.getMail());

			// 승인완료된 경우에만 updatedt가 있음
			if (obj.get("updatedt") != null) {
				Date updateDate = sdf.parse(obj.get("updatedt").toString());
				String updateDateStr = sdf.format(updateDate);
				updateDateStr = commonUtil.getDateStringInUTC(updateDateStr, offset, false);
				obj.put("updatedt", updateDateStr);
			}

			resultArry.add(obj);
		}

		return resultArry;
	}

	//@Override
	public JSONArray formatApprEmail(JSONArray array, String offset, int tenantId, Locale locale) throws Exception {
		JSONArray resultArray = new JSONArray();

		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
		sdf.setTimeZone(TimeZone.getTimeZone("GMT"));

		for (int i = 0; i < array.size(); i++) {
			JSONObject obj = (JSONObject) array.get(i);

			// 1. 작성일
			Date writeDate = sdf.parse(obj.get("writeDate").toString());
			String writeDateStr = sdf.format(writeDate);
			writeDateStr = commonUtil.getDateStringInUTC(writeDateStr, offset, false);
			obj.put("writeDate", writeDateStr);

			// 2. 신청자의 primary mail
			String senderId = obj.get("senderEmail").toString().split("@")[0];
			OrganUserVO senderVO = ezOrganAdminService.getUserInfo(senderId, "1", tenantId); // 신청자의 primary 메일주소만 필요하기 때문에 lang 값 1로 픽스 함
			obj.put("senderEmail", senderVO.getMail());

			// 3. 승인일시 - 승인완료된 경우에만 updatedt가 있음
			if (obj.get("updatedt") != null) {
				Date updateDate = sdf.parse(obj.get("updatedt").toString());
				String updateDateStr = sdf.format(updateDate);
				updateDateStr = commonUtil.getDateStringInUTC(updateDateStr, offset, false);
				obj.put("updatedt", updateDateStr);
			}
			
			// 4. href 암호화
			String mailUID = obj.get("mailUID").toString();
			String href = "Sent." + senderId + "/" + mailUID;
			String encryptedHref = egovFileScrty.encryptAES(href);

			obj.put("href", encryptedHref);
			
			// 5. 상태 언어 변경
			if (locale != null) {
				String state = obj.get("state").toString().toLowerCase();
				String stateLang;

				if ("approved".equals(state)) {
					stateLang = egovMessageSource.getMessage("email.appr.approval.status", locale);
				} else if ("rejected".equals(state)) {
					stateLang = egovMessageSource.getMessage("email.appr.reject.status", locale);
				} else if ("deleted".equals(state)) {
					stateLang = egovMessageSource.getMessage("email.appr.delete.status", locale);
				} else {
					stateLang = ""; // 기본값 처리
				}

				obj.put("state", stateLang);
			}

			// 6. array에 담음
			resultArray.add(obj);
		}
		
		return resultArray;
	}

	/**
	 * 승인메일 : 전체메일 승인자 이름 관리자로 일괄 적용
	 */
	@SuppressWarnings("unchecked")
	@Override
	public JSONArray setApprover(JSONArray array, Locale locale) throws Exception {
		JSONArray resultArry = new JSONArray();

		for (int i = 0; i < array.size(); i++) {
			JSONObject obj = (JSONObject) array.get(i);
			
			if (obj.get("approverName") == null) {
				obj.put("approverName", egovMessageSource.getMessage("email.administrator", locale));
				obj.put("approverEmail", "");
			}

			resultArry.add(obj);
		}

		return resultArry;
	}

	/**
	 * 승인메일 : href를 암호화
	 */
	@SuppressWarnings("unchecked")
	@Override
	public JSONArray setHref(JSONArray array) throws Exception {
		JSONArray resultArry = new JSONArray();

		for (int i = 0; i < array.size(); i++) {
			JSONObject obj = (JSONObject) array.get(i);

			String senderId = obj.get("senderId").toString();
			String mailUID = obj.get("mailUID").toString();
			String href = "Sent." + senderId + "/" + mailUID;

			// 암호화
			String encryptedHref = egovFileScrty.encryptAES(href);

			obj.put("href", encryptedHref);
			resultArry.add(obj);
		}

		return resultArry;
	}
	@SuppressWarnings("unchecked")
	@Override
	public String setHref(String senderId, String mailUID) throws Exception {
		String href = "Sent." + senderId + "/" + mailUID;
		// 암호화
		String encryptedHref = egovFileScrty.encryptAES(href);

		return encryptedHref;
	}

	/**
	 * 승인메일 : 상태 다국어 지원 api
	 */
	@SuppressWarnings("unchecked")
	@Override
	public JSONArray setStateByLocale(JSONArray array, Locale locale) throws Exception {
		JSONArray resultArray = new JSONArray();

	    array.forEach(item -> {
	        JSONObject obj = (JSONObject) item;
	        String state = obj.get("state").toString().toLowerCase();
	        String stateLang;

	        if ("approved".equals(state)) {
	            stateLang = egovMessageSource.getMessage("email.appr.approval.status", locale);
	        } else if ("rejected".equals(state)) {
	            stateLang = egovMessageSource.getMessage("email.appr.reject.status", locale);
	        } else if ("deleted".equals(state)) {
	            stateLang = egovMessageSource.getMessage("email.appr.delete.status", locale);
	        } else {
	            stateLang = ""; // 기본값 처리
	        }

	        obj.put("state", stateLang);
	        resultArray.add(obj);
	    });

		return resultArray;
	}
	@SuppressWarnings("unchecked")
	@Override
	public String setStateByLocale(String state, Locale locale) throws Exception {
		String stateLang = state;
		
	    if ("approved".equals(state)) {
	        stateLang = egovMessageSource.getMessage("email.appr.approval.status", locale);
	    } else if ("rejected".equals(state)) {
	        stateLang = egovMessageSource.getMessage("email.appr.reject.status", locale);
	    } else if ("deleted".equals(state)) {
	        stateLang = egovMessageSource.getMessage("email.appr.delete.status", locale);
	    }

		return stateLang;
	}

	/**
	 * 승인메일 : 
	 * 승인자 여부 확인
	 */
	@Override
	public boolean checkApprMailApprover(int tenantId, String companyId, String cn) throws Exception {
		logger.debug("checkApprMailApprover started. cn={}", cn);

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		map.put("cn", cn);

		boolean result = ezEmailDAO.checkApprMailApprover(map) == 1;

		logger.debug("checkApprMailApprover ended. cn={}, result={}", cn, result);
		return result;
	}

	/**
	 * 승인메일 : 
	 * 발송허용 도메인 리스트 가져오기
	 */
	@Override
	public List<String> getApprAllowedDomainList(int tenantId, String companyId) throws Exception {
		logger.debug("getApprAllowedDomainList started.");
		logger.debug("tenantId={}, companyId={}", tenantId, companyId);

		List<String> list = new ArrayList<String>();
		
		String inputParams = "tenantId=" + tenantId + "&companyId=" + companyId;
		logger.debug("inputParams={}", inputParams);

		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzEmailAppr/getAllowedDomainList";
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		logger.debug("response={}", response);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(response);
		
		if (object.get("resultCode").equals("OK") && ((Long)object.get("reasonCode")).intValue() == 0) {
        	JSONArray resultArray = (JSONArray)object.get("result");
        	
        	for (int i=0; i<resultArray.size(); i++) {
        		JSONObject obj = (JSONObject)resultArray.get(i);
        		
        		list.add((String) obj.get("domainName"));
        	}
		} else {
			throw new Exception("JGwServer ERROR");
		}

		logger.debug("getApprAllowedDomainList ended.");
		return list;
	}
	
	/**
	 * 승인메일 : 
	 * 발송허용 도메인 검색 (이미 존재하는지 여부 체크)
	 */
	@Override
	public List<String> checkApprAllowedDomain(int tenantId, String companyId, String[] domainNameList) throws Exception {
		logger.debug("checkApprAllowedDomain started.");
		logger.debug("tenantId={}, companyId={}, domainNameList={}", tenantId, companyId, domainNameList);

		List<String> list = null;
		
		String inputParams = "tenantId=" + tenantId + "&companyId=" + companyId;
		for (String dn : domainNameList) {
			inputParams += "&domainName=" + URLEncoder.encode(dn, "UTF-8");
		}
		logger.debug("inputParams={}", inputParams);
		
		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzEmailAppr/checkAllowedDomain";
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		logger.debug("response={}", response);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(response);
		
		if (object.get("resultCode").equals("OK") && ((Long)object.get("reasonCode")).intValue() == 0) {
        	JSONArray resultArray = (JSONArray)object.get("result");
        	
        	if (resultArray.size() > 0) {
        		list = new ArrayList<String>();
        	}
        	
        	for (int i=0; i<resultArray.size(); i++) {
        		list.add((String)resultArray.get(i));
        	}
		} else {
			throw new Exception("JGwServer ERROR");
		}
		
		logger.debug("checkApprAllowedDomain ended.");
		return null;
	}
	
	/**
	 * 승인메일 : 
	 * 발송허용 도메인 추가
	 */
	@Override
	public int insertApprAllowedDomain(int tenantId, String companyId, String domainName) throws Exception {
		logger.debug("insertApprAllowedDomain started.");
		logger.debug("tenantId={}, companyId={}, domainName={}", tenantId, companyId, domainName);
		
		int resultInt = -100; // -1:이미 있는 도메인
		
		String inputParams = "tenantId=" + tenantId + "&companyId=" + companyId 
							+ "&domainName=" + URLEncoder.encode(domainName, "UTF-8");
		logger.debug("inputParams={}", inputParams);

		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzEmailAppr/insertAllowedDomain";
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		logger.debug("response={}", response);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(response);
        
		if (object.get("resultCode").equals("OK")) {
			resultInt = ((Long)object.get("reasonCode")).intValue();
		} else {
			throw new Exception("JGwServer ERROR");
		}
		
		logger.debug("insertApprAllowedDomain ended.");
		return resultInt;
	}

	/**
	 * 승인메일 : 
	 * 발송허용 도메인 삭제
	 */
	@Override
	public int deleteApprAllowedDomain(int tenantId, String companyId, String[] domainNameList) throws Exception {
		logger.debug("deleteApprAllowedDomain started.");
		logger.debug("tenantId={}, companyId={}, domainNameList={}", tenantId, companyId, domainNameList);
		
		int resultInt = -100;
		
		String inputParams = "tenantId=" + tenantId + "&companyId=" + companyId;
		for (String dn : domainNameList) {
			inputParams += "&domainName=" + URLEncoder.encode(dn, "UTF-8");
		}
		logger.debug("inputParams={}", inputParams);
		
		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzEmailAppr/deleteAllowedDomain";
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		logger.debug("response={}", response);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(response);
		
		if (object.get("resultCode").equals("OK")) {
			resultInt = ((Long)object.get("reasonCode")).intValue();
		} else {
			throw new Exception("JGwServer ERROR");
		}
		
		logger.debug("deleteApprAllowedDomain ended.");
		return resultInt;
	}
	
	/**
	 * 승인메일 : 
	 * 승인자 리스트 가져오기
	 */
	@Override
	public List<String> getApproverList(int tenantId, String companyId) throws Exception {
		logger.debug("getApproverList started.");
		logger.debug("tenantId={}, companyId={}", tenantId, companyId);

		List<String> list = null;
		
		String inputParams = "tenantId=" + tenantId + "&companyId=" + companyId;
		logger.debug("inputParams={}", inputParams);

		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzEmailAppr/getApproverList";
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		logger.debug("response={}", response);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(response);
		
		if (object.get("resultCode").equals("OK") && ((Long)object.get("reasonCode")).intValue() == 0) {
        	JSONArray resultArray = (JSONArray)object.get("result");
        	
        	if (resultArray.size() > 0) {
        		list = new ArrayList<String>();
        	}
        	
        	for (int i=0; i<resultArray.size(); i++) {
        		JSONObject obj = (JSONObject)resultArray.get(i);
        		
        		list.add((String) obj.get("userId"));
        	}
		} else {
			throw new Exception("JGwServer ERROR");
		}

		logger.debug("getApproverList ended.");
		return list;
	}
	
	/** 
	 * 승인메일 :  
	 * 승인자 리스트 가져오기
	 */
	@Override
	public List<OrganUserVO> getApproverList(int tenantId, String companyId, String lang) throws Exception {
		logger.debug("getApproverList started.");
		logger.debug("tenantId={}, companyId={}, lang={}", tenantId, companyId, lang);

		List<OrganUserVO> list = new ArrayList<OrganUserVO>();
		
		String inputParams = "tenantId=" + tenantId + "&companyId=" + companyId;
		logger.debug("inputParams={}", inputParams);

		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzEmailAppr/getApproverList";
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		logger.debug("response={}", response);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(response);
		
		if (object.get("resultCode").equals("OK") && ((Long)object.get("reasonCode")).intValue() == 0) {
        	JSONArray resultArray = (JSONArray)object.get("result");
        	
        	for (int i=0; i<resultArray.size(); i++) {
        		JSONObject obj = (JSONObject)resultArray.get(i);
        		
        		OrganUserVO userVO = ezOrganAdminService.getUserInfo((String) obj.get("userId"), lang, tenantId);
        		if (userVO != null) {
        			list.add(userVO);
        		}
        	}
		} else {
			throw new Exception("JGwServer ERROR");
		}

		logger.debug("getApproverList ended.");
		return list;
	}
	
	/**
	 * 승인메일 : 
	 * 승인자 리스트 검색
	 * searchType= displayname(이름), deptname(부서명), title(직위), deptId(부서아이디)
	 */
	@Override
	public List<OrganUserVO> getApproverSearchList(int tenantId, String companyId, String lang, String searchType, String searchValue) throws Exception {
		logger.debug("getApproverSearchList started.");
		logger.debug("tenantId={}, companyId={}, lang={}, searchType={}, searchValue={}"
				, tenantId, companyId, lang, searchType, searchValue);

		List<OrganUserVO> list = new ArrayList<OrganUserVO>();
		
		String inputParams = "tenantId=" + tenantId + "&companyId=" + companyId + "&lang=" + lang 
				+ "&searchType=" + searchType + "&searchValue=" + URLEncoder.encode(searchValue, "UTF-8");
		logger.debug("inputParams={}", inputParams);

		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzEmailAppr/searchApproverList";
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		logger.debug("response={}", response);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(response);
		
		if (object.get("resultCode").equals("OK") && ((Long)object.get("reasonCode")).intValue() == 0) {
        	JSONArray resultArray = (JSONArray)object.get("result");
        	
        	for (int i=0; i<resultArray.size(); i++) {
        		JSONObject obj = (JSONObject)resultArray.get(i);
        		
        		OrganUserVO userVO = ezOrganAdminService.getUserInfo((String) obj.get("userId"), lang, tenantId);
        		if (userVO != null) {
        			list.add(userVO);
        		}
        	}
		} else {
			throw new Exception("JGwServer ERROR");
		}

		logger.debug("getApproverSearchList ended.");
		return list;
	}
	
	/**
	 * 승인메일 : 
	 * 승인자 검색 (이미 존재하는지 여부 체크)
	 * 
	 * ------- 사용안함 위에 검색이용바람
	 @Override
	public List<String> checkApprover(int tenantId, String companyId, String[] userIdList) throws Exception {
		logger.debug("checkApprover started.");
		logger.debug("tenantId={}, companyId={}, userId={}", tenantId, companyId, userIdList);

		List<String> list = null;
		
		String inputParams = "tenantId=" + tenantId + "&companyId=" + companyId;
		for (String user : userIdList) {
			inputParams += "&userId=" + URLEncoder.encode(user, "UTF-8");
		}
		logger.debug("inputParams={}", inputParams);
		
		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzEmailAppr/checkApprover";
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		logger.debug("response={}", response);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(response);
		
		if (object.get("resultCode").equals("OK") && ((Long)object.get("reasonCode")).intValue() == 0) {
        	JSONArray resultArray = (JSONArray)object.get("result");
        	
        	if (resultArray.size() > 0) {
        		list = new ArrayList<String>();
        	}
        	
        	for (int i=0; i<resultArray.size(); i++) {
        		list.add((String)resultArray.get(i));
        	}
		} else {
			throw new Exception("JGwServer ERROR");
		}
		
		logger.debug("checkApprover ended.");
		return null;
	}*/
	
	/**
	 * 승인메일 : 
	 * 승인자 추가/편집 (전체 삭제 후 추가)
	 */
	@Override
	public int resetApprover(int tenantId, String companyId, String[] userIdList) throws Exception {
		logger.debug("resetApprover started.");
		logger.debug("tenantId={}, companyId={}, userIdList={}", tenantId, companyId, userIdList);

		int resultInt = -100;
		
		List<String> allApprover = getApproverList(tenantId, companyId);

		// delete
		if (allApprover != null) {
			String[] allApproverArr = allApprover.toArray(new String[0]);
			resultInt = deleteApprover(tenantId, companyId, allApproverArr);
		}
		
		// insert
		if (userIdList != null) {
			resultInt = insertApprover(tenantId, companyId, userIdList);
		}

		logger.debug("resetApprover ended.");
		return resultInt;
	}
	
	/**
	 * 승인메일 : 
	 * 승인자 추가
	 */
	@Override
	public int insertApprover(int tenantId, String companyId, String[] userIdList) throws Exception {
		logger.debug("insertApprover started.");
		logger.debug("tenantId={}, companyId={}, userIdList={}", tenantId, companyId, userIdList);
		
		int resultInt = -100;

		String inputParams = "tenantId=" + tenantId + "&companyId=" + companyId;
		for (String user : userIdList) {
			inputParams += "&userId=" + URLEncoder.encode(user, "UTF-8");
		}
		logger.debug("inputParams={}", inputParams);

		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzEmailAppr/insertApprover";
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		logger.debug("response={}", response);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(response);
        
		if (object.get("resultCode").equals("OK")) {
			resultInt = ((Long)object.get("reasonCode")).intValue();
		} else {
			throw new Exception("JGwServer ERROR");
		}
		
		logger.debug("insertApprover ended.");
		return resultInt;
	}

	/**
	 * 승인메일 : 
	 * 승인자 삭제
	 */
	@Override
	public int deleteApprover(int tenantId, String companyId, String[] userIdList) throws Exception {
		logger.debug("deleteApprover started.");
		logger.debug("tenantId={}, companyId={}, userIdList={}", tenantId, companyId, userIdList);
		
		int resultInt = -100;
		
		String inputParams = "tenantId=" + tenantId + "&companyId=" + companyId;
		for (String user : userIdList) {
			inputParams += "&userId=" + URLEncoder.encode(user, "UTF-8");
		}
		logger.debug("inputParams={}", inputParams);
		
		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzEmailAppr/deleteApprover";
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		logger.debug("response={}", response);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(response);
		
		if (object.get("resultCode").equals("OK")) {
			resultInt = ((Long)object.get("reasonCode")).intValue();
		} else {
			throw new Exception("JGwServer ERROR");
		}
		
		logger.debug("deleteApprover ended.");
		return resultInt;
	}

	/**
	 * 승인메일 : 
	 * 예외자 리스트 가져오기
	 */
	@Override
	public List<String> getExceptionUserList(int tenantId, String companyId) throws Exception {
		logger.debug("getExceptionUserList started.");
		logger.debug("tenantId={}, companyId={}", tenantId, companyId);

		List<String> list = null;
		
		String inputParams = "tenantId=" + tenantId + "&companyId=" + companyId;
		logger.debug("inputParams={}", inputParams);

		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzEmailAppr/getExceptionUserList";
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		logger.debug("response={}", response);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(response);
		
		if (object.get("resultCode").equals("OK") && ((Long)object.get("reasonCode")).intValue() == 0) {
        	JSONArray resultArray = (JSONArray)object.get("result");
        	
        	if (resultArray.size() > 0) {
        		list = new ArrayList<String>();
        	}
        	
        	for (int i=0; i<resultArray.size(); i++) {
        		JSONObject obj = (JSONObject)resultArray.get(i);
        		
        		list.add((String) obj.get("userId"));
        	}
		} else {
			throw new Exception("JGwServer ERROR");
		}

		logger.debug("getExceptionUserList ended.");
		return list;
	}
	
	/**
	 * 승인메일 : 
	 * 예외자 검색 (이미 존재하는지 여부 체크)
	 
	@Override
	public List<String> checkExceptionUser(int tenantId, String companyId, String[] userIdList) throws Exception {
		logger.debug("checkExceptionUser started.");
		logger.debug("tenantId={}, companyId={}, userId={}", tenantId, companyId, userIdList);

		List<String> list = null;
		
		String inputParams = "tenantId=" + tenantId + "&companyId=" + companyId;
		for (String user : userIdList) {
			inputParams += "&userId=" + URLEncoder.encode(user, "UTF-8");
		}
		logger.debug("inputParams={}", inputParams);
		
		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzEmailAppr/checkExceptionUser";
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		logger.debug("response={}", response);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(response);
		
		if (object.get("resultCode").equals("OK") && ((Long)object.get("reasonCode")).intValue() == 0) {
        	JSONArray resultArray = (JSONArray)object.get("result");
        	
        	if (resultArray.size() > 0) {
        		list = new ArrayList<String>();
        	}
        	
        	for (int i=0; i<resultArray.size(); i++) {
        		list.add((String)resultArray.get(i));
        	}
		} else {
			throw new Exception("JGwServer ERROR");
		}
		
		logger.debug("checkExceptionUser ended.");
		return null;
	}*/
	
	/**
	 * 승인메일 : 
	 * 예외자 검색 (이미 존재하는지 여부 체크)
	 */
	@Override
	public boolean checkExceptionUser(int tenantId, String companyId, String userId) throws Exception {
		logger.debug("checkExceptionUser started.");
		logger.debug("tenantId={}, companyId={}, userId={}", tenantId, companyId, userId);

		boolean result = false;
		
		String inputParams = "tenantId=" + tenantId + "&companyId=" + companyId
				 		+ "&userId=" + URLEncoder.encode(userId, "UTF-8");
		logger.debug("inputParams={}", inputParams);
		
		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzEmailAppr/checkExceptionUser";
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		logger.debug("response={}", response);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(response);
		
		if (object.get("resultCode").equals("OK") && ((Long)object.get("reasonCode")).intValue() == 0) {
        	JSONArray resultArray = (JSONArray)object.get("result");
        	
    		for (int i=0; i<resultArray.size(); i++) {
        		JSONObject obj = (JSONObject)resultArray.get(i);
        		
        		if (userId.equals((String)obj.get("userId"))) {
        			result = true;
        			break;
        		}
        	}
		} else {
			throw new Exception("JGwServer ERROR");
		}
		
		logger.debug("checkExceptionUser ended.");
		return result;
	}

	/**
	 * 승인메일 : 
	 * 예외자 추가/편집 (전체 삭제 후 추가)
	 */
	@Override
	public int resetExceptionUser(int tenantId, String companyId, String[] userIdList) throws Exception {
		logger.debug("resetExceptionUser started.");
		logger.debug("tenantId={}, companyId={}, userIdList={}", tenantId, companyId, userIdList);
		
		int resultInt = -100;

		List<String> allExceptionUser = getExceptionUserList(tenantId, companyId);

		// delete
		if (allExceptionUser != null) {
			String[] allExceptionUserArr = allExceptionUser.toArray(new String[0]);
			resultInt = deleteExceptionUser(tenantId, companyId, allExceptionUserArr);
		}
		
		// insert
		if (userIdList != null) {
			resultInt = insertExceptionUser(tenantId, companyId, userIdList);
		}

		logger.debug("resetExceptionUser ended.");
		return resultInt;
	}
	
	/**
	 * 승인메일 : 
	 * 예외자 추가
	 */
	@Override
	public int insertExceptionUser(int tenantId, String companyId, String[] userIdList) throws Exception {
		logger.debug("insertExceptionUser started.");
		logger.debug("tenantId={}, companyId={}, userIdList={}", tenantId, companyId, userIdList);
		
		int resultInt = -100;

		String inputParams = "tenantId=" + tenantId + "&companyId=" + companyId;
		for (String user : userIdList) {
			inputParams += "&userId=" + URLEncoder.encode(user, "UTF-8");
		}
		logger.debug("inputParams={}", inputParams);

		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzEmailAppr/insertExceptionUser";
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		logger.debug("response={}", response);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(response);
        
		if (object.get("resultCode").equals("OK")) {
			resultInt = ((Long)object.get("reasonCode")).intValue();
		} else {
			throw new Exception("JGwServer ERROR");
		}
		
		logger.debug("insertExceptionUser ended.");
		return resultInt;
	}

	/**
	 * 승인메일 : 
	 * 예외자 삭제
	 */
	@Override
	public int deleteExceptionUser(int tenantId, String companyId, String[] userIdList) throws Exception {
		logger.debug("deleteExceptionUser started.");
		logger.debug("tenantId={}, companyId={}, userIdList={}", tenantId, companyId, userIdList);
		
		int resultInt = -100;
		
		String inputParams = "tenantId=" + tenantId + "&companyId=" + companyId;
		for (String user : userIdList) {
			inputParams += "&userId=" + URLEncoder.encode(user, "UTF-8");
		}
		logger.debug("inputParams={}", inputParams);
		
		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzEmailAppr/deleteExceptionUser";
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		logger.debug("response={}", response);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(response);
		
		if (object.get("resultCode").equals("OK")) {
			resultInt = ((Long)object.get("reasonCode")).intValue();
		} else {
			throw new Exception("JGwServer ERROR");
		}
		
		logger.debug("deleteExceptionUser ended.");
		return resultInt;
	}

	/**
	 * 승인메일 : 전사/일반 승인메일 로그 단일 조회
	 * @param userId 신청자 아이디
	 * @return tenantId, companyId, mailUID, subject, userId, userName, approverId, approverName, type(ALL_HANDS/NORMAL)
	 */
	@Override
	public Map<String, String> getApprAllHistoryInfo(int tenantId, String companyId, long mailUID, String userId, String lang) throws Exception{

		String domainName = ezCommonService.getTenantConfig("DomainName", tenantId);
		
		String inputParams = "tenantId=" + tenantId + "&companyId=" + companyId + "&mailUID=" + mailUID
				 + "&userId=" + URLEncoder.encode(userId, "UTF-8") + "&lang=" + lang;
		logger.debug("inputParams={}", inputParams);
		
		Map<String, String> resultMap = null;
		
		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzEmailAppr/getApprAllHistoryInfo";
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		logger.debug("response={}", response);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(response);
		
		if (object.get("resultCode").equals("OK") && ((Long)object.get("reasonCode")).intValue() == 0) {
        	JSONObject obj = (JSONObject)object.get("result");

        	if (obj != null) {
        		resultMap = new HashMap<String, String>();

        		resultMap.put("tenantId",     (String)obj.get("tenantId"));
           	 	resultMap.put("companyId",    (String)obj.get("companyId"));
                resultMap.put("mailUID",      (String)obj.get("mailUID"));
                resultMap.put("subject",      (String)obj.get("subject"));
                resultMap.put("userId",       (String)obj.get("userId"));
                resultMap.put("userName",     (String)obj.get("userName"));
                resultMap.put("approverId",   (String)obj.get("approverId"));
                resultMap.put("approverName", (String)obj.get("approverName"));
                resultMap.put("approverEmail", ((String)obj.get("approverId")) + "@" + domainName);
                resultMap.put("type", 		  (String)obj.get("type"));
        	}
        } else {
        	throw new Exception("JGwServer ERROR");
        }
				
		return resultMap;
	}

	/**
	 * 승인메일 : 
	 * 전사 승인메일 로그 저장
	 */
	@Override
	public int insertApprCompHistory(int tenantId, String companyId, long mailUID, String userId, MimeMessage message) throws Exception {
		logger.debug("tenantId={}, companyId={}, mailUID={}, userId={}"
                , tenantId, companyId, mailUID, userId);
		
		String domainName = ezCommonService.getTenantConfig("DomainName", tenantId);
		
		// 신청자 정보
		OrganUserVO applicantVO = ezOrganAdminService.getUserInfo(userId, "1", tenantId);
		String userName = applicantVO.getDisplayName1();
		String userName2 = applicantVO.getDisplayName2();
		String senderEmail = userId + "@" + domainName;
		String userDeptId = applicantVO.getDepartment();
		OrganDeptVO applicantDeptVO = ezOrganService.getDeptInfo(userDeptId, "1", tenantId);
		String userDeptName = applicantDeptVO.getDisplayName1();
		String userDeptName2 = applicantDeptVO.getDisplayName2();
		// 승인메일 정보
		String subject = message.getSubject();
		Date writeDate = message.getSentDate();

		// 저장
		int resultInt = -100;
		
		String inputParams = "tenantId=" + tenantId + "&companyId=" + companyId + "&mailUID=" + mailUID
				 + "&subject=" + URLEncoder.encode(subject, "UTF-8") + "&userId=" + URLEncoder.encode(userId, "UTF-8") + "&userName=" + URLEncoder.encode(userName, "UTF-8") + "&userName2=" + URLEncoder.encode(userName2, "UTF-8")
				 + "&writeDate=" + writeDate + "&senderEmail=" + URLEncoder.encode(senderEmail , "UTF-8")
				 + "&userDeptId=" + URLEncoder.encode(userDeptId, "UTF-8") + "&userDeptName=" + URLEncoder.encode(userDeptName, "UTF-8") + "&userDeptName2=" + URLEncoder.encode(userDeptName2, "UTF-8");
		logger.debug("inputParams={}", inputParams);
		
		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzEmailAppr/insertApprCompHistory";
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		logger.debug("response={}", response);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(response);
		
		if (object.get("resultCode").equals("OK")) {
			resultInt = ((Long)object.get("reasonCode")).intValue();
		} else {
			throw new Exception("JGwServer ERROR");
		}
		
		return resultInt;
	}
	
	/**
	 * 승인메일 : 
	 * 일반 승인메일 로그 저장
	 */
	@Override
	public int insertApprHistory(int tenantId, String companyId, long mailUID, String userId, String approverId, MimeMessage message) throws Exception {
		logger.debug("tenantId={}, companyId={}, mailUID={}, userId={}, approverId={}"
                , tenantId, companyId, mailUID, userId, approverId);

		String domainName = ezCommonService.getTenantConfig("DomainName", tenantId);
		
		// 신청자 정보
		OrganUserVO applicantVO = ezOrganAdminService.getUserInfo(userId, "1", tenantId);
		String userName = applicantVO.getDisplayName1();
		String userName2 = applicantVO.getDisplayName2();
		String senderEmail = userId + "@" + domainName;
		String userDeptId = applicantVO.getDepartment();
		OrganDeptVO applicantDeptVO = ezOrganService.getDeptInfo(userDeptId, "1", tenantId);
		String userDeptName = applicantDeptVO.getDisplayName1();
		String userDeptName2 = applicantDeptVO.getDisplayName2();
		// 승인자 정보
		OrganUserVO approverVO = ezOrganAdminService.getUserInfo(approverId, "1", tenantId);
		String approverName = approverVO.getDisplayName1();
		String approverName2 = approverVO.getDisplayName2();
		// 승인메일 정보
		String subject = message.getSubject();
		Date writeDate = message.getSentDate();

		// 저장
		int resultInt = -100;
		
		String inputParams = "tenantId=" + tenantId + "&companyId=" + companyId + "&mailUID=" + mailUID
				 + "&subject=" + URLEncoder.encode(subject, "UTF-8") + "&userId=" + URLEncoder.encode(userId, "UTF-8") + "&userName=" + URLEncoder.encode(userName, "UTF-8") + "&userName2=" + URLEncoder.encode(userName2, "UTF-8")
				 + "&approverId=" + URLEncoder.encode(approverId, "UTF-8") + "&approverName=" + URLEncoder.encode(approverName, "UTF-8") + "&approverName2=" + URLEncoder.encode(approverName2, "UTF-8") 
				 + "&writeDate=" + writeDate + "&senderEmail=" + URLEncoder.encode(senderEmail , "UTF-8") 
				 + "&userDeptId=" + URLEncoder.encode(userDeptId, "UTF-8") + "&userDeptName=" + URLEncoder.encode(userDeptName, "UTF-8") + "&userDeptName2=" + URLEncoder.encode(userDeptName2, "UTF-8");
		logger.debug("inputParams={}", inputParams);
		
		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzEmailAppr/insertApprHistory";
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		logger.debug("response={}", response);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(response);
		
		if (object.get("resultCode").equals("OK")) {
			resultInt = ((Long)object.get("reasonCode")).intValue();
		} else {
			throw new Exception("JGwServer ERROR");
		}
		
		return resultInt;
	}

	/**
	 * 승인메일 : 전사 승인메일 로그 삭제
	 * @param userId: 신청자 아이디
	 */
	@Override
	public int deleteApprCompHistory(int tenantId, String companyId, long mailUID, String userId) throws Exception {
		logger.debug("tenantId={}, companyId={}, mailUID={}, userId={}"
                , tenantId, companyId, mailUID, userId);
		
		int resultInt = -100;
		
		String inputParams = "tenantId=" + tenantId + "&companyId=" + companyId + "&mailUID=" + mailUID + "&userId=" + URLEncoder.encode(userId, "UTF-8");
		logger.debug("inputParams={}", inputParams);
		
		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzEmailAppr/deleteApprCompHistory";
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		logger.debug("response={}", response);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(response);
		
		if (object.get("resultCode").equals("OK")) {
			resultInt = ((Long)object.get("reasonCode")).intValue();
		} else {
			throw new Exception("JGwServer ERROR");
		}
		
		return resultInt;
	}
	
	/**
	 * 승인메일 : 일반 승인메일 로그 삭제
	 * @param userId: 신청자 아이디
	 */
	@Override
	public int deleteApprHistory(int tenantId, String companyId, long mailUID, String userId) throws Exception {
		logger.debug("tenantId={}, companyId={}, mailUID={}, userId={}"
                , tenantId, companyId, mailUID, userId);
		
		int resultInt = -100;
		
		String inputParams = "tenantId=" + tenantId + "&companyId=" + companyId + "&mailUID=" + mailUID + "&userId=" + URLEncoder.encode(userId, "UTF-8");
		logger.debug("inputParams={}", inputParams);
		
		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzEmailAppr/deleteApprHistory";
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		logger.debug("response={}", response);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(response);
		
		if (object.get("resultCode").equals("OK")) {
			resultInt = ((Long)object.get("reasonCode")).intValue();
		} else {
			throw new Exception("JGwServer ERROR");
		}
		
		return resultInt;
	}
	
	/** 
	 * 승인메일 : 전사 승인메일 로그 상태 변경
     * @param state:  pending(대기), approved(승인), rejected(거절), cancel(취소)
	 * @param memo 거부사유 (거부할 때 사용되는 컬럼으로 거부사유가 없거나 상태가 거부가 아닌 그 외는 null로 넘기면 됨)
	 * @param approverId: 승인자 아이디 (승인자가 아직 없거나 변경하지 않을 땐 null로 넘기면 됨)
     * @param approverName: 승인자 이름 (승인자가 아직 없거나 변경하지 않을 땐 null로 넘기면 됨)
	 */ 
	@Override
	public int updateApprCompHistory(int tenantId, String companyId, long mailUID, String userId, String state, 
			String approverId, String approverName, String approverName2, String memo) throws Exception {
		logger.debug("tenantId={}, companyId={}, mailUID={}, userId={}, state={}, "
				+ "approverId={}, approverName={}, approverName2={}, memo={}"
                , tenantId, companyId, mailUID, userId, state
                , approverId, approverName, approverName2, memo);
 
		int resultInt = -100;
		 
		String inputParams = "tenantId=" + tenantId + "&companyId=" + companyId + "&mailUID=" + mailUID
				 + "&userId=" + URLEncoder.encode(userId, "UTF-8") + "&state=" + state;
		if (approverId != null) 	{ inputParams += "&approverId=" + URLEncoder.encode(approverId, "UTF-8"); }
		if (approverName != null) 	{ inputParams += "&approverName=" + URLEncoder.encode(approverName, "UTF-8"); }
		if (approverName2 != null) 	{ inputParams += "&approverName2=" + URLEncoder.encode(approverName2, "UTF-8"); }
		if (memo != null) 			{ inputParams += "&memo=" + URLEncoder.encode(memo, "UTF-8"); }
		logger.debug("inputParams={}", inputParams);
		
		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzEmailAppr/updateApprCompHistory";
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		logger.debug("response={}", response);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(response);
		
		if (object.get("resultCode").equals("OK")) {
			resultInt = ((Long)object.get("reasonCode")).intValue();
		} else {
			throw new Exception("JGwServer ERROR");
		}
		
		return resultInt;
	}

	/**
	 * 승인메일 : 일반 & 회사 승인메일 로그 상태 체크
	 */
	public int checkApprHistoryAll(int tenantId, String companyId, String userId, List<Map<String, Object>> mailDataList) throws Exception {
		logger.debug("checkApprHistoryAll started. tenantId={}, companyId={}, userId={}, mailDataList size={}",
				tenantId, companyId, userId, mailDataList.size());

		int resultInt = -100;

		// JSON 배열 생성
		JSONArray requestArray = new JSONArray();
		for (Map<String, Object> mailData : mailDataList) {
			JSONObject item = new JSONObject();
			item.put("tenantId", String.valueOf(tenantId));
			item.put("companyId", companyId);
			item.put("mailUID", String.valueOf(mailData.get("uid")));
			item.put("userId", (String) mailData.get("applicantId"));
			item.put("state", (String) mailData.get("state"));
			requestArray.add(item);
		}

		String requestData = requestArray.toJSONString();
		logger.debug("requestData={}", requestData);

		String inputParams = "requestData=" + URLEncoder.encode(requestData, "UTF-8");
		logger.debug("inputParams={}", inputParams);

		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzEmailAppr/checkApprHistoryAll";
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		logger.debug("response={}", response);

		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(response);

		if (object.get("resultCode").equals("OK")) {
			resultInt = ((Long)object.get("reasonCode")).intValue(); // 0:정상(모든 항목 처리 가능), 1:처리 불가(0건 항목 존재)
		} else {
			throw new Exception("checkApprHistoryAll JGwServer ERROR");
		}

		logger.debug("checkApprHistoryAll ended. resultInt={}", resultInt);
		return resultInt;
	}
	
	/**
	 * 승인메일 : 일반 or 회사 승인메일 로그 상태 체크
	 */
	public int checkApprHistoryMultiple(int tenantId, String companyId, String userId, List<Map<String, Object>> mailDataList) throws Exception {
		logger.debug("checkApprHistoryMultiple started. tenantId={}, companyId={}, userId={}, mailDataList size={}",
				tenantId, companyId, userId, mailDataList.size());

		int resultInt = -100;

		// JSON 배열 생성
		JSONArray requestArray = new JSONArray();
		for (Map<String, Object> mailData : mailDataList) {
			JSONObject item = new JSONObject();
			item.put("tenantId", String.valueOf(tenantId));
			item.put("companyId", companyId);
			item.put("mailUID", String.valueOf(mailData.get("uid")));
			item.put("userId", (String) mailData.get("applicantId"));
			item.put("state", (String) mailData.get("state"));
			item.put("apprMailFlag", (String) mailData.get("apprMailFlag"));
			requestArray.add(item);
		}

		String requestData = requestArray.toJSONString();
		logger.debug("requestData={}", requestData);

		String inputParams = "requestData=" + URLEncoder.encode(requestData, "UTF-8");
		logger.debug("inputParams={}", inputParams);

		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzEmailAppr/checkApprHistoryMultiple";
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		logger.debug("response={}", response);

		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(response);

		if (object.get("resultCode").equals("OK")) {
			resultInt = ((Long)object.get("reasonCode")).intValue(); // 0:정상(모든 항목 처리 가능), 1:처리 불가(0건 항목 존재)
		} else {
			throw new Exception("checkApprHistoryMultiple JGwServer ERROR");
		}

		logger.debug("checkApprHistoryMultiple ended. resultInt={}", resultInt);
		return resultInt;
	}
	
	/**
	 * 승인메일 : 일반 승인메일 로그 상태 변경
     * @param state:  pending(대기), approved(승인), rejected(거절), deleted(자동삭제), cancel(취소)
	 * @param memo 거부사유 (거부할 때 사용되는 컬럼으로 거부사유가 없거나 상태가 거부가 아닌 그 외는 null로 넘기면 됨)
	 */
	@Override
	public int updateApprHistory(int tenantId, String companyId, long mailUID, String userId, String state, String memo) throws Exception {
		logger.debug("updateApprHistory started. tenantId={}, companyId={}, mailUID={}, userId={}, state={}, memo={}"
                , tenantId, companyId, mailUID, userId, state, memo);

		int resultInt = -100;
		
		String inputParams = "tenantId=" + tenantId + "&companyId=" + companyId + "&mailUID=" + mailUID
				 + "&userId=" + URLEncoder.encode(userId, "UTF-8") + "&state=" + state;
		if (memo != null) {
			inputParams += "&memo=" + URLEncoder.encode(memo, "UTF-8");
		}
		logger.debug("inputParams={}", inputParams);
		
		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzEmailAppr/updateApprHistory";
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		logger.debug("response={}", response);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(response);
		
		if (object.get("resultCode").equals("OK")) {
			resultInt = ((Long)object.get("reasonCode")).intValue();
		} else {
			throw new Exception("updateApprHistory JGwServer ERROR");
		}
		
		return resultInt;
	}

	/**
	 * 승인메일 : 전사 승인메일 신청 - 로그 저장 및 전체/회사관리자에게 알림 메일 발송
	 */
	@Override
	public int applyApprCompMail(String loginCookie, long mailUID, MimeMessage message) throws Exception {
		return applyApprCompMail(loginCookie, mailUID, message, "");
	}
	@Override
	public int applyApprCompMail(String loginCookie, long mailUID, MimeMessage message, String shareId) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();
		int tenantId = userInfo.getTenantId();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("lang", userInfo.getLang());
		map.put("primary", userInfo.getPrimary());
		map.put("locale", userInfo.getLocale());
		map.put("companyId", userInfo.getCompanyID());
		map.put("shareId", shareId);
		
		return applyApprCompMail(userId, tenantId, map, mailUID, message);
	}
	/**
	 * @param paramMap: lang, primary, locale, companyId
	 */
	@Override
	public int applyApprCompMail(String userId, int tenantId, Map<String, Object> paramMap, long mailUID, MimeMessage message) throws Exception {
		String companyId 	= (String) paramMap.get("companyId");
		String lang 	= (String) paramMap.get("lang");
		String primary 	= (String) paramMap.get("primary");
		Locale locale 	= (Locale) paramMap.get("locale");
		String shareId 	= (String) paramMap.get("shareId");

		String domainName = ezCommonService.getTenantConfig("DomainName", tenantId);

		String vUserId = "";
		String vUserName = "";
		String vUserEmail = "";
		if (shareId == null || "".equals(shareId)) {
			OrganUserVO userInfo = ezOrganAdminService.getUserInfo(userId, lang, tenantId);
			if (userInfo == null) { throw new Exception("not found user."); }

			vUserId = userId;
			vUserName = userInfo.getDisplayName();
			vUserEmail = userInfo.getMail();
		} else {
			MailSharedMailboxVO sharedMailBoxInfo = getSharedMailboxInfo(shareId, tenantId, lang);
			if (sharedMailBoxInfo == null) { throw new Exception("not found user."); }
			
			vUserId = shareId;
			vUserName = sharedMailBoxInfo.getShareName();
			vUserEmail = vUserId + "@" + domainName;
		}
		
		String userAccount = vUserId + "@" + domainName;
		
		// 로그 저장
		insertApprCompHistory(tenantId, companyId, mailUID, vUserId, message);
		
		try {
			// 알림메일
			/**
			 *  메일 제목 : [메일승인요청] TEST 님께서 전사메일 발송 승인을 요청하였습니다.
			 *  메일 본문 : 관리자>메일>전체메일승인>승인대기목록 페이지에서 확인하시기 바랍니다.
			 */
			String subject = egovMessageSource.getMessage("email.appr.noti.apply.title", locale) 
					+ " " + String.format(egovMessageSource.getMessage("email.appr.noti.apply.allhands.subject", locale), vUserName);
			
			String content = commonUtil.createNotiMailContentForApprMail(egovMessageSource.getMessage("email.appr.noti.apply.allhands.content1", locale), tenantId, locale);
			
			/**
			 * 보낸 사람 : 신청자
			 */
			InternetAddress from = new InternetAddress();
			from.setPersonal(vUserName, "UTF-8");
			from.setAddress(vUserEmail);
	
			/**
			 * 받는 사람 : 전체/회사관리자
			 */
			String permissionBasisDeptYN = ezCommonService.getTenantConfig("permissionBasisDeptYN", tenantId);
	        int allAdminCnt = ezOrganAdminService.getPermissionListCount(companyId, "c=1", "", "", primary, tenantId, permissionBasisDeptYN);
			List<OrganUserVO> allAdminList = ezOrganAdminService.getPermissionList(companyId, "c=1", "", "", primary, 1, allAdminCnt, tenantId, permissionBasisDeptYN);
			int compAdminCnt = ezOrganAdminService.getPermissionListCount(companyId, "k=1", "", "", primary, tenantId, permissionBasisDeptYN);
			List<OrganUserVO> compAdminList = ezOrganAdminService.getPermissionList(companyId, "k=1", "", "", primary, 1, compAdminCnt, tenantId, permissionBasisDeptYN);

			Set<OrganUserVO> adminList = new HashSet<OrganUserVO>();
			adminList.addAll(allAdminList);
			adminList.addAll(compAdminList);
			
			List<InternetAddress> toList = new ArrayList<InternetAddress>();
			for (OrganUserVO ad : adminList) {
				InternetAddress to = new InternetAddress();
				to.setPersonal(ad.getDisplayName(), "UTF-8");
				to.setAddress(ad.getMail());
				
				toList.add(to);
			}
			
			// 회사 관리자가 없는 경우
			// 2024-07-17 전체/회사관리자가 없어도 신청할 수 있게 수정
			/*if (toList.size() < 1) { 
				throw new Exception("APPR_ERROR_ALLHANDS_NOT_EXIST");
			}*/
			if (toList.size() > 0) {
				sendMail(userAccount, jspw, locale, from, toList.toArray(new InternetAddress[toList.size()]), null, null, subject, content, false, EmailImportance.NORMAL);
			}
		} catch (Exception e) {
			deleteApprCompHistory(tenantId, companyId, mailUID, vUserId);
			logger.debug("applyApprCompMail error!");
			throw new Exception(e.getMessage());
		}
		
		return 0;
	}
	
	/**
	 * 승인메일 : 
	 * 일반 승인메일 신청
	 * - 로그 저장 및 승인자에게 알림 메일 발송
	 */
	@Override
	public int applyApprMail(String loginCookie, long mailUID, MimeMessage message, String approverId) throws Exception {
		return applyApprMail(loginCookie, mailUID, message, approverId, "");
	}
	@Override
	public int applyApprMail(String loginCookie, long mailUID, MimeMessage message, String approverId, String shareId) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();
		int tenantId = userInfo.getTenantId();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("lang", userInfo.getLang());
		map.put("primary", userInfo.getPrimary());
		map.put("locale", userInfo.getLocale());
		map.put("companyId", userInfo.getCompanyID());
		map.put("shareId", shareId);
		
		return applyApprMail(userId, tenantId, map, mailUID, message, approverId);
	}
	/**
	 * @param paramMap: lang, primary, locale, companyId
	 */
	public int applyApprMail(String userId, int tenantId, Map<String, Object> paramMap, long mailUID, MimeMessage message, String approverId) throws Exception {
		String companyId 	= (String) paramMap.get("companyId");
		String lang 		= (String) paramMap.get("lang");
		String primary 		= (String) paramMap.get("primary");
		Locale locale 		= (Locale) paramMap.get("locale");
		String shareId 	= (String) paramMap.get("shareId");

		String domainName = ezCommonService.getTenantConfig("DomainName", tenantId);

		String vUserId = "";
		String vUserName = "";
		String vUserEmail = "";
		if (shareId == null || "".equals(shareId)) {
			OrganUserVO userInfo = ezOrganAdminService.getUserInfo(userId, lang, tenantId);
			if (userInfo == null) { throw new Exception("not found user."); }

			vUserId = userId;
			vUserName = userInfo.getDisplayName();
			vUserEmail = userInfo.getMail();
		} else {
			MailSharedMailboxVO sharedMailBoxInfo = getSharedMailboxInfo(shareId, tenantId, lang);
			if (sharedMailBoxInfo == null) { throw new Exception("not found user."); }
			
			vUserId = shareId;
			vUserName = sharedMailBoxInfo.getShareName();
			vUserEmail = vUserId + "@" + domainName;
		}
		
		String userAccount = vUserId + "@" + domainName;
		
		// 로그 저장
		insertApprHistory(tenantId, companyId, mailUID, vUserId, approverId, message);
		
		try {
			// 알림메일
			/**
			 *  메일 제목 : [메일승인요청] TEST 님께서 메일 발송 승인을 요청하였습니다.
			 *  메일 본문 : 메일>승인메일>발송승인대기 페이지에서 확인하시기 바랍니다.
			 */
			String subject = egovMessageSource.getMessage("email.appr.noti.apply.title", locale) 
					+ " " + String.format(egovMessageSource.getMessage("email.appr.noti.apply.normal.subject", locale), vUserName);
			
			String content = commonUtil.createNotiMailContentForApprMail(egovMessageSource.getMessage("email.appr.noti.apply.normal.content1", locale), tenantId, locale);
			
			/**
			 * 보낸 사람 : 신청자
			 */
			InternetAddress from = new InternetAddress();
			from.setPersonal(vUserName, "UTF-8");
			from.setAddress(vUserEmail);
	
			/**
			 * 받는 사람 : 승인자
			 */
			OrganUserVO approverVO = ezOrganAdminService.getUserInfo(approverId, primary, tenantId);
			// 승인자가 없는 경우
			if (approverVO == null) { 
				throw new Exception("APPR_ERROR_NORMAL_NOT_EXIST");
			}
			
			InternetAddress to = new InternetAddress();
			to.setPersonal(approverVO.getDisplayName(), "UTF-8");
			to.setAddress(approverVO.getMail());

			sendMail(userAccount, jspw, locale, from, new InternetAddress[]{to}, null, null, subject, content, false, EmailImportance.NORMAL);
		} catch (Exception e) {
			deleteApprHistory(tenantId, companyId, mailUID, vUserId);
			logger.debug("applyApprMail error!");
			throw new Exception(e.getMessage());
		}

		return 0;
	}
	
	/**
	 * 승인메일 : 신청 취소 - 로그 상태 변경
	 * @param applicantEmail: 신청자 이메일
	 */
	@Override
	public int setApprMailCancel(String loginCookie, String applicantEmail, long uid) throws Exception {
		LoginVO loginInfo = commonUtil.userInfo(loginCookie);
		int tenantId = loginInfo.getTenantId();
		String userId = loginInfo.getId();

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyId", loginInfo.getCompanyID());
		map.put("lang", loginInfo.getLang());
		map.put("locale", loginInfo.getLocale());
		
		return setApprMailCancel(tenantId, map, applicantEmail, uid);
	}
	/**
	 * @param paramMap: lang, locale, companyId
	 */
	@Override
	public int setApprMailCancel(int tenantId, Map<String, Object> paramMap, String applicantEmail, long uid) throws Exception {
		int resultInt = -1;
		int moveToDraft = 0; // 성공 : 0, 메일이 없는 경우 : 1
		
		String companyId 	= (String) paramMap.get("companyId");
		String lang 		= (String) paramMap.get("lang");
		Locale locale 		= (Locale) paramMap.get("locale");
		logger.debug("setApprMailCancel tenantId={}, companyId={}, lang={}, locale={}, applicantEmail={}", tenantId, companyId, lang, locale, applicantEmail);
		
		String userId = applicantEmail.split("@")[0]; // 신청자 아이디
			
		Map<String, String> hisInfo = getApprAllHistoryInfo(tenantId, companyId, uid, userId, lang);// 해당 메일의 로그 정보
		boolean isAllHandsType = "ALL_HANDS".equalsIgnoreCase(hisInfo.get("type"));
		
		/*
		if (isAllHandsType) {
			resultInt = updateApprCompHistory(tenantId, companyId, uid, userId, "canceled", null, null, null, null);
		} else {
			resultInt = updateApprHistory(tenantId, companyId, uid, userId, "canceled", null);
		}	
		
		if (resultInt >= 0) {
			try {
				Map<String, Object> apprMailMap = new HashMap<String, Object>();
				apprMailMap.put("applicantEmail", applicantEmail);
				apprMailMap.put("uid", uid);
				
				// 임시보관함에 저장
				ezEmailUtil.apprMailMoveToFolder(locale, tenantId, apprMailMap, ezEmailUtil.getDraftsFolderId(locale), true);
			} catch (Exception e) {
				logger.error(e.getMessage(), e);
				resultInt = -1;
				if (isAllHandsType) {
					resultInt = updateApprCompHistory(tenantId, companyId, uid, userId, "pending", null, null, null, null);
				} else {
					resultInt = updateApprHistory(tenantId, companyId, uid, userId, "pending", null);
				}
			}
		}
		*/
		// 임시보관함에 저장이 성공하면 로그 정보를 변경하도록 수정, 여러번 취소 요청이 왔을 때 메일이 없는 경우 대비하여 처리 순서 변경
		// 2025-08-06 - 승인요청메일이 pending일 경우에만 진행하도록 수정 
		try {
			Map<String, Object> apprMailMap = new HashMap<String, Object>();
			apprMailMap.put("applicantEmail", applicantEmail);
			apprMailMap.put("uid", uid);

			// 임시보관함에 저장
			//moveToDraft = ezEmailUtil.apprMailMoveToFolder(locale, tenantId, apprMailMap, ezEmailUtil.getDraftsFolderId(locale), true);

			if (0 == moveToDraft) {
				if (isAllHandsType) {
					resultInt = updateApprCompHistory(tenantId, companyId, uid, userId, "canceled", null, null, null, null);
				} else {
					resultInt = updateApprHistory(tenantId, companyId, uid, userId, "canceled", null);
				}
			}

			// 임시보관함에 저장
			if (0 == resultInt) {
				moveToDraft = ezEmailUtil.apprMailMoveToFolder(locale, tenantId, apprMailMap, ezEmailUtil.getDraftsFolderId(locale), true);
			}
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			resultInt = -1;
		}
		
		return resultInt;
	}
	
	/**
	 * 승인메일 : 전사메일 발송 승인 - 로그 상태 변경 및  알림메일 발송
	 * @param applicantEmail: 신청자 이메일 
	 */
	@Override
	public int setApprCompMailApproval(String loginCookie, String applicantEmail, long uid) throws Exception {
		int resultInt = -1;

		LoginVO loginInfo = commonUtil.userInfo(loginCookie);
		int tenantId = loginInfo.getTenantId();
		String companyId = loginInfo.getCompanyID();
		String lang = loginInfo.getPrimary();
		Locale locale = loginInfo.getLocale();
		logger.debug("tenantId={}, companyId={}, lang={}, locale={}, applicantEmail={}", tenantId, companyId, lang, locale, applicantEmail);

		String approverId = loginInfo.getId(); // 승인자는 현재 로그인한 사용자
		String approverName = loginInfo.getDisplayName(); 
		String approverName2 = loginInfo.getDisplayName2(); 
		String applicantId = applicantEmail.split("@")[0];
		
		// 해당 메일의 로그 정보
		String hisSubject = "";
		
		Map<String, String> hisInfo = getApprAllHistoryInfo(tenantId, companyId, uid, applicantId, lang);
		if (hisInfo != null) {
			hisSubject = hisInfo.get("subject");
		}

		// 승인자
		OrganUserVO approverVO = ezOrganAdminService.getUserInfo(approverId, lang, tenantId);
		// 신청자
		OrganUserVO applicantVO = ezOrganAdminService.getUserInfo(applicantId, lang, tenantId);
		
		// 로그 상태 변경
		resultInt = updateApprCompHistory(tenantId, companyId, uid, applicantId, "approved", approverId, approverName, approverName2, null);
			 
		if (resultInt >= 0) {
			try {
				Map<String, Object> apprMailMap = new HashMap<String, Object>();
				apprMailMap.put("approverEmail", approverVO.getMail());
				apprMailMap.put("applicantEmail", applicantEmail);
				apprMailMap.put("uid", uid);
				
				// 보낸편지함 저장 및 메일 발송
				ezEmailUtil.apprMailMoveAndSend(locale, tenantId, apprMailMap, false);
				
				// 알림메일
				if (applicantVO != null) {
					/**
					 *  메일 제목 : [메일발송알림] "메일 제목"
					 *  메일 본문 : 요청하신 메일에 대하여 승인 후 발송이 이루어졌음을 알려드립니다.
					 */
					String subject = egovMessageSource.getMessage("email.appr.noti.send.title", locale) + " " + hisSubject;
					String content = commonUtil.createNotiMailContentForApprMail(egovMessageSource.getMessage("email.appr.noti.send.normal.content1", locale), tenantId, locale);
					
					/**
					 * 보낸 사람 : 승인자
					 */
					InternetAddress from = new InternetAddress();
					from.setPersonal(approverVO.getDisplayName(), "UTF-8");
					from.setAddress(approverVO.getMail());
	
					/**
					 * 받는 사람 : 신청자
					 */
					InternetAddress to = new InternetAddress();
					to.setPersonal(applicantVO.getDisplayName(), "UTF-8");
					to.setAddress(applicantVO.getMail());
					
					sendMail(loginCookie, from, new InternetAddress[]{to}, null, null, subject, content, false);
				} else {
					logger.debug("applicant is not found.");
				}
			} catch (Exception e) {
				logger.error(e.getMessage(), e);
				resultInt = -1;
				updateApprCompHistory(tenantId, companyId, uid, applicantId, "pending", approverId, approverName, approverName2, null);
			}
		}
		
		return resultInt;
	}
	
	/**
	 * 승인메일 : 일반메일 발송 승인 - 로그 상태 변경 및  알림메일 발송
	 * @param applicantEmail: 신청자 이메일 
	 */
	@Override
	public int setApprMailApproval(String loginCookie, String applicantEmail, long uid) throws Exception {
		LoginVO loginInfo = commonUtil.userInfo(loginCookie);
		int tenantId = loginInfo.getTenantId();
		String userId = loginInfo.getId();

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyId", loginInfo.getCompanyID());
		map.put("lang", loginInfo.getLang());
		map.put("locale", loginInfo.getLocale());
		
		return setApprMailApproval(userId, tenantId, map, applicantEmail, uid);
	}

	@Override
	public int setApprMailApproval(String userId, int tenantId,Map<String, Object> paramMap) throws Exception {
		String applicantEmail = (String) paramMap.get("uid");
		long uid = (long) paramMap.get("uid");
		return setApprMailApproval(userId, tenantId, paramMap, applicantEmail, uid);
	}

	/**
	 * @param paramMap: lang, locale, companyId
	 * @param userId: 승인하는 사람 아이디
	 */
	@Override
	public int setApprMailApproval(String userId, int tenantId, Map<String, Object> paramMap, String applicantEmail, long uid) throws Exception {
		logger.debug("setApprMailApproval started. tenantId={},applicantEmail={}, uid={}", tenantId, applicantEmail, uid);
		int resultInt = -1;

		String companyId 	= (String) paramMap.get("companyId");
		String lang 		= (String) paramMap.get("lang");
		Locale locale 		= (Locale) paramMap.get("locale");
	
		String applicantId = applicantEmail.split("@")[0];
		String domainName = ezCommonService.getTenantConfig("DomainName", tenantId);
		String userAccount = userId + "@" + domainName;
		logger.debug("setApprMailApproval applicantId={}, domainName={}, userAccount={} lang={}, companyId={}", applicantId, domainName, userAccount, lang, companyId);
		
		// 해당 메일의 로그 정보
		String hisSubject = "";
		String hisApproverId = "";
		
		Map<String, String> hisInfo = getApprAllHistoryInfo(tenantId, companyId, uid, applicantId, lang);
		if (hisInfo != null) {
			hisSubject = hisInfo.get("subject");
			hisApproverId  = hisInfo.get("approverId");
		}
		
		// 승인자
		OrganUserVO approverVO = ezOrganAdminService.getUserInfo(hisApproverId, lang, tenantId);
		// 신청자
		OrganUserVO applicantVO = ezOrganAdminService.getUserInfo(applicantId, lang, tenantId);
		
		// 로그 상태 변경
		resultInt = updateApprHistory(tenantId, companyId, uid, applicantId, "approved", null);
			 
		if (resultInt >= 0) {
			try {
				Map<String, Object> apprMailMap = new HashMap<String, Object>();
				apprMailMap.put("approverEmail", approverVO.getMail());
				apprMailMap.put("applicantEmail", applicantEmail);
				apprMailMap.put("uid", uid);
				
				// 보낸편지함 저장 및 메일 발송
				ezEmailUtil.apprMailMoveAndSend(locale, tenantId, apprMailMap, false);
				
				// 알림메일
				if (applicantVO != null) {
					/**
					 *  메일 제목 : [메일발송알림] "메일 제목"
					 *  메일 본문 : 요청하신 메일에 대하여 승인 후 발송이 이루어졌음을 알려드립니다.
					 */
					String subject = egovMessageSource.getMessage("email.appr.noti.send.title", locale) + " " + hisSubject;
					String content = commonUtil.createNotiMailContentForApprMail(egovMessageSource.getMessage("email.appr.noti.send.normal.content1", locale), tenantId, locale);
					
					/**
					 * 보낸 사람 : 승인자
					 */
					InternetAddress from = new InternetAddress();
					from.setPersonal(approverVO.getDisplayName(), "UTF-8");
					from.setAddress(approverVO.getMail());
	
					/**
					 * 받는 사람 : 신청자
					 */
					InternetAddress to = new InternetAddress();
					to.setPersonal(applicantVO.getDisplayName(), "UTF-8");
					to.setAddress(applicantVO.getMail());

					sendMail(userAccount, jspw, locale, from, new InternetAddress[]{to}, null, null, subject, content, false, EmailImportance.NORMAL);
				} else {
					logger.debug("applicant is not found.");
				}
			} catch (Exception e) {
				logger.error(e.getMessage(), e);
				resultInt = -1;
				updateApprHistory(tenantId, companyId, uid, applicantId, "pending", null);
			}
		}
		
		return resultInt;
	}
	
	/**
	 * 승인메일 : 전사메일 발송 거부- 로그 상태 변경, 승인자 지정 및  알림메일 발송
	 * @param applicantEmail: 신청자 이메일 
	 */
	@Override
	public int setApprCompMailReject(String loginCookie, String applicantEmail, long uid, String memo) throws Exception {
		int resultInt = -1;
		
		LoginVO loginInfo = commonUtil.userInfo(loginCookie);
		int tenantId = loginInfo.getTenantId();
		String companyId = loginInfo.getCompanyID();
		String lang = loginInfo.getPrimary();
		Locale locale = loginInfo.getLocale();
		logger.debug("tenantId={}, companyId={}, lang={}, locale={}, applicantEmail={}", tenantId, companyId, lang, locale, applicantEmail);

		String approverId = loginInfo.getId(); // 승인자는 현재 로그인한 사용자
		String approverName = loginInfo.getDisplayName(); 
		String approverName2 = loginInfo.getDisplayName2(); 
		String applicantId = applicantEmail.split("@")[0];
		
		// 해당 메일의 로그 정보
		String hisSubject = "";
		
		Map<String, String> hisInfo = getApprAllHistoryInfo(tenantId, companyId, uid, applicantId, lang);
		if (hisInfo != null) {
			hisSubject = hisInfo.get("subject");
		}
		
		// 신청자
		OrganUserVO applicantVO = ezOrganAdminService.getUserInfo(applicantId, lang, tenantId);
		
		// 로그 상태 변경
		resultInt = updateApprCompHistory(tenantId, companyId, uid, applicantId, "rejected", approverId, approverName, approverName2, memo);
			 
		if (resultInt >= 0 && applicantVO != null) {
			try {
				Map<String, Object> apprMailMap = new HashMap<String, Object>();
				apprMailMap.put("applicantEmail", applicantEmail);
				apprMailMap.put("uid", uid);
				
				// 임시보관함에 저장
				ezEmailUtil.apprMailMoveToFolder(locale, tenantId, apprMailMap, ezEmailUtil.getDraftsFolderId(locale), false);
				
				// 알림메일
				/**
				 *  메일 제목 : [메일거부알림] "메일 제목"
				 *  메일 본문 : 요청하신 메일에 대하여 발송이 거부되었음을 알려드립니다. \n거부된 메일은 임시보관함에서 확인하시기 바랍니다.
				 */
				String subject = egovMessageSource.getMessage("email.appr.noti.reject.title", locale) + " " + hisSubject;
				String mailContent = egovMessageSource.getMessage("email.appr.noti.reject.normal.content1", locale);
				if (!StringUtils.isBlank(memo)) { // 발송거부 의견
					mailContent += "</br></br>" + egovMessageSource.getMessage("email.appr.noti.reject.normal.content2", locale) 
								+  "</br>" + memo.replaceAll("&lt;", "<").replaceAll("&gt;", ">").replaceAll("&amp;", "&").replaceAll("\n", "<br>");
				}
				String content = commonUtil.createNotiMailContentForApprMail(mailContent, tenantId, locale);
				
				/**
				 * 보낸 사람 : 승인자
				 */
				OrganUserVO approverVO = ezOrganAdminService.getUserInfo(approverId, lang, tenantId);
				
				InternetAddress from = new InternetAddress();
				from.setPersonal(approverVO.getDisplayName(), "UTF-8");
				from.setAddress(approverVO.getMail());

				/**
				 * 받는 사람 : 신청자
				 */
				InternetAddress to = new InternetAddress();
				to.setPersonal(applicantVO.getDisplayName(), "UTF-8");
				to.setAddress(applicantVO.getMail());
				
				sendMail(loginCookie, from, new InternetAddress[]{to}, null, null, subject, content, false);
			} catch (Exception e) {
				logger.error(e.getMessage(), e);
				resultInt = -1;
				updateApprCompHistory(tenantId, companyId, uid, applicantId, "pending", null, null, null, null);
			}
		} else if (applicantVO != null) {
			logger.debug("applicant is not found.");
		}
		
		return resultInt;
	}
	
	/**
	 * 승인메일 : 일반메일 발송 거부- 로그 상태 변경 및  알림메일 발송
	 * @param applicantEmail: 신청자 이메일 
	 */

	@Override
	public int setApprMailReject(String loginCookie, String applicantEmail, long uid, String memo) throws Exception {
		LoginVO loginInfo = commonUtil.userInfo(loginCookie);
		int tenantId = loginInfo.getTenantId();
		String userId = loginInfo.getId();

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyId", loginInfo.getCompanyID());
		map.put("lang", loginInfo.getLang());
		map.put("locale", loginInfo.getLocale());
		
		return setApprMailReject(userId, tenantId, map, applicantEmail, uid, memo);
	}
	/**
	 * @param paramMap: lang, locale, companyId
	 * @param userId: 승인하는 사람 아이디
	 */
	@Override
	public int setApprMailReject(String userId, int tenantId, Map<String, Object> paramMap, String applicantEmail, long uid, String memo) throws Exception {
		int resultInt = -1;
		
		String companyId 	= (String) paramMap.get("companyId");
		String lang 		= (String) paramMap.get("lang");
		Locale locale 		= (Locale) paramMap.get("locale");
		logger.debug("tenantId={}, companyId={}, lang={}, locale={}, applicantEmail={}", tenantId, companyId, lang, locale, applicantEmail);
		
		String applicantId = applicantEmail.split("@")[0];
		String domainName = ezCommonService.getTenantConfig("DomainName", tenantId);
		String userAccount = userId + "@" + domainName;
		logger.debug("applicantId={}, domainName={}, userAccount={}", applicantEmail, domainName, userAccount);
		
		// 해당 메일의 로그 정보
		String hisSubject = "";
		String hisApproverId = "";
		
		Map<String, String> hisInfo = getApprAllHistoryInfo(tenantId, companyId, uid, applicantId, lang);
		if (hisInfo != null) {
			hisSubject = hisInfo.get("subject");
			hisApproverId  = hisInfo.get("approverId");
		}

		// 신청자
		OrganUserVO applicantVO = ezOrganAdminService.getUserInfo(applicantId, lang, tenantId);
		
		// 로그 상태 변경
		resultInt = updateApprHistory(tenantId, companyId, uid, applicantId, "rejected", memo);
			 
		if (resultInt >= 0 && applicantVO != null) {
			try {
				Map<String, Object> apprMailMap = new HashMap<String, Object>();
				apprMailMap.put("applicantEmail", applicantEmail);
				apprMailMap.put("uid", uid);
				
				// 임시보관함에 저장
				ezEmailUtil.apprMailMoveToFolder(locale, tenantId, apprMailMap, ezEmailUtil.getDraftsFolderId(locale), false);
				
				// 알림메일
				/**
				 *  메일 제목 : [메일거부알림] "메일 제목"
				 *  메일 본문 : 요청하신 메일에 대하여 발송이 거부되었음을 알려드립니다. \n거부된 메일은 임시보관함에서 확인하시기 바랍니다.
				 */
				String subject = egovMessageSource.getMessage("email.appr.noti.reject.title", locale) + " " + hisSubject;
				String mailContent = egovMessageSource.getMessage("email.appr.noti.reject.normal.content1", locale);
				if (!StringUtils.isBlank(memo)) { // 발송거부 의견
					mailContent += "</br></br>" + egovMessageSource.getMessage("email.appr.noti.reject.normal.content2", locale) 
								+  "</br>" + memo.replaceAll("&lt;", "<").replaceAll("&gt;", ">").replaceAll("&amp;", "&").replaceAll("\n", "<br>");
				}
				String content = commonUtil.createNotiMailContentForApprMail(mailContent, tenantId, locale);
				
				/**
				 * 보낸 사람 : 승인자
				 */
				OrganUserVO approverVO = ezOrganAdminService.getUserInfo(hisApproverId, lang, tenantId);
				
				InternetAddress from = new InternetAddress();
				from.setPersonal(approverVO.getDisplayName(), "UTF-8");
				from.setAddress(approverVO.getMail());

				/**
				 * 받는 사람 : 신청자
				 */
				InternetAddress to = new InternetAddress();
				to.setPersonal(applicantVO.getDisplayName(), "UTF-8");
				to.setAddress(applicantVO.getMail());

				sendMail(userAccount, jspw, locale, from, new InternetAddress[]{to}, null, null, subject, content, false, EmailImportance.NORMAL);
			} catch (Exception e) {
				logger.error(e.getMessage(), e);
				resultInt = -1;
				updateApprHistory(tenantId, companyId, uid, applicantId, "pending", null);
			}
		} else if (applicantVO != null) {
			logger.debug("applicant is not found.");
		}
		
		return resultInt;
	}
	
	/**
	 * 승인메일 : 전사메일 삭제 - 로그 삭제 및 승인메일 공유사서함에서 메일 삭제
	 * @param applicantEmail: 신청자 이메일 
	 */
	@Override
	public int setApprCompMailDelete(String loginCookie, String applicantEmail, long uid) throws Exception {
		int resultInt = -1;
		
		LoginVO loginInfo = commonUtil.userInfo(loginCookie);
		int tenantId = loginInfo.getTenantId();
		String companyId = loginInfo.getCompanyID();
		Locale locale = loginInfo.getLocale();
        String applicantId = applicantEmail.split("@")[0];
		logger.debug("tenantId={}, companyId={}, locale={}, applicantEmail={}"
				, tenantId, companyId, locale, applicantEmail);
		
		resultInt = deleteApprCompHistory(tenantId, companyId, uid, applicantId);
		
		if (resultInt >= 0) {
			try {
				Map<String, Object> apprMailMap = new HashMap<String, Object>();
				apprMailMap.put("applicantEmail", applicantEmail);
				apprMailMap.put("uid", uid);
				
				// 승인메일 공유사서함에서 메일 삭제
				ezEmailUtil.apprMailDeleteFromSharedMailbox(locale, tenantId, apprMailMap);
			} catch (Exception e) {
				logger.error(e.getMessage(), e);
				resultInt = -1;
			}
		}
		
		return resultInt;
	}
	
	/**
	 * 승인메일 : 자동삭제 - 로그 상태 변경 및 알림메일 발송
	 * @param applicantEmail: 신청자 이메일
	 */
	@Override
	public int setApprMailAutoDelete(int tenantId, String companyId, String applicantEmail, long uid) throws Exception {
		int resultInt = -1;
		
		String keepLogPeriod = StringUtils.defaultIfBlank(ezCommonService.getTenantConfig("apprMailKeepLogPeriod", tenantId), "3");
		
		Locale locale = Locale.getDefault();
        String applicantId = applicantEmail.split("@")[0];
        String lang = ezCommonService.selectUserGetLang(applicantId, tenantId);
		logger.debug("tenantId={}, companyId={}, lang={}, locale={}, applicantEmail={}"
				, tenantId, companyId, lang, locale, applicantEmail);
		
		// 해당 메일의 로그 정보
		Map<String, String> hisInfo = getApprAllHistoryInfo(tenantId, companyId, uid, applicantId, lang);
		String hisSubject = hisInfo.get("subject");
		String hisApproverId = hisInfo.get("approverId");
		boolean isAllHandsType = "ALL_HANDS".equalsIgnoreCase(hisInfo.get("type"));
				
		if (isAllHandsType) {
			resultInt = updateApprCompHistory(tenantId, companyId, uid, applicantId, "deleted", null, null, null, null);
		} else {
			resultInt = updateApprHistory(tenantId, companyId, uid, applicantId, "deleted", null);
		}	

		// 신청자
		OrganUserVO applicantVO = ezOrganAdminService.getUserInfo(applicantId, lang, tenantId);
		
		if (resultInt >= 0 && applicantVO != null) {
			try {
				Map<String, Object> apprMailMap = new HashMap<String, Object>();
				apprMailMap.put("applicantEmail", applicantEmail);
				apprMailMap.put("uid", uid);
				
				// 임시보관함에 저장
				ezEmailUtil.apprMailMoveToFolder(locale, tenantId, apprMailMap, ezEmailUtil.getDraftsFolderId(locale), true);
				
				// 알림메일
				/**
				 *  메일 제목 : [메일자동삭제] "메일 제목"
				 *  메일 본문 : 요청하신 메일에 대하여 n개월이 지나 자동삭제 되었음을 알려드립니다. \n자동삭제된 메일은 임시보관함에서 확인하시기 바랍니다.
				 */
				String subject = egovMessageSource.getMessage("email.appr.noti.delete.title", locale) + " " + hisSubject;
				String mailContent = String.format(egovMessageSource.getMessage("email.appr.noti.delete.normal.content1", locale), keepLogPeriod);
				String content = commonUtil.createNotiMailContentForApprMail(mailContent, tenantId, locale);
				
				/**
				 * 보낸 사람 : 승인자
				 */
				OrganUserVO approverVO = ezOrganAdminService.getUserInfo(hisApproverId, lang, tenantId);
				
				InternetAddress from = new InternetAddress();
				from.setPersonal(approverVO.getDisplayName(), "UTF-8");
				from.setAddress(approverVO.getMail());

				/**
				 * 받는 사람 : 신청자
				 */
				InternetAddress to = new InternetAddress();
				to.setPersonal(applicantVO.getDisplayName(), "UTF-8");
				to.setAddress(applicantVO.getMail());
				
				sendMail(applicantEmail, jspw, null, from, new InternetAddress[]{to}, null, null, subject, content);
			} catch (Exception e) {
				logger.error(e.getMessage(), e);
				resultInt = -1;
				if (isAllHandsType) {
					updateApprCompHistory(tenantId, companyId, uid, applicantId, "pending", null, null, null, null);
				} else {
					updateApprHistory(tenantId, companyId, uid, applicantId, "pending", null);
				}
			}
		} else if (applicantVO != null) {
			logger.debug("applicant is not found.");
		}
		
		return resultInt;
	}
	
	/**
	 * 승인메일 : 오래된 승인메일 로그 삭제 (대기상태 제외)
	 * @param applicantEmail: 신청자 이메일
	 */
	@Override
	public int setOldApprMailDelete(int tenantId, String companyId, String applicantEmail, long uid) throws Exception {
		int resultInt = -1; 
		
		Locale locale = Locale.getDefault();
        String applicantId = applicantEmail.split("@")[0];
        String lang = ezCommonService.selectUserGetLang(applicantId, tenantId);
		logger.debug("tenantId={}, companyId={}, lang={}, locale={}, applicantEmail={}"
				, tenantId, companyId, lang, locale, applicantEmail);
		
		resultInt = deleteApprHistory(tenantId, companyId, uid, applicantId);
		
		if (resultInt >= 0) {
			try {
				Map<String, Object> apprMailMap = new HashMap<String, Object>();
				apprMailMap.put("applicantEmail", applicantEmail);
				apprMailMap.put("uid", uid);
				
				// 승인메일 공유사서함에서 메일 삭제
				ezEmailUtil.apprMailDeleteFromSharedMailbox(locale, tenantId, apprMailMap);
			} catch (Exception e) {
				logger.error(e.getMessage(), e);
				resultInt = -1;
			}
		}
		
		return resultInt;
	}
	
	/**
	 * 승인메일 : 자동삭제 - (전사/일반) 자동 삭제 대상로그 조회 (대기상태)
	 */
	@Override
	public List<Map<String, String>> getAutoDeleteApprMailHistoryList(int tenantId, String lang) throws Exception {
		String keepLogPeriod = StringUtils.defaultIfBlank(ezCommonService.getTenantConfig("apprMailKeepLogPeriod", tenantId), "3");
		
		List<Map<String, String>> list = new ArrayList<Map<String, String>>();
		
		String inputParams = "tenantId=" + tenantId + "&keepLogPeriod=" + keepLogPeriod + "&lang=" + lang;
		logger.debug("inputParams={}", inputParams);

		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzEmailAppr/getAutoDeleteApprMailHistoryList";
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		logger.debug("response={}", response);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(response);
		
		if (object.get("resultCode").equals("OK") && ((Long)object.get("reasonCode")).intValue() == 0) {
        	JSONArray resultArray = (JSONArray)object.get("result");
        	
        	for (int i=0; i<resultArray.size(); i++) {
        		Map<String, String> resultMap = new HashMap<String, String>();

        		JSONObject obj = (JSONObject)resultArray.get(i);
        		
        		resultMap.put("tenantId",     (String)obj.get("tenantId"));
           	 	resultMap.put("companyId",    (String)obj.get("companyId"));
                resultMap.put("mailUID",      (String)obj.get("mailUID"));
                resultMap.put("subject",      (String)obj.get("subject"));
                resultMap.put("userId",       (String)obj.get("userId"));
                resultMap.put("userName",     (String)obj.get("userName"));
                resultMap.put("approverId",   (String)obj.get("approverId"));
                resultMap.put("approverName", (String)obj.get("approverName"));
                resultMap.put("type", 		  (String)obj.get("type"));
        		
        		list.add(resultMap);
        	}
		} else {
			throw new Exception("JGwServer ERROR");
		}
		
		return list;
	}
	
	/**
	 * 승인메일 : (일반) 로그 삭제 대상로그 조회 (대기상태 제외)
	 */
	@Override
	public List<Map<String, String>> getOldApprMailHistoryList(int tenantId, String lang) throws Exception {
		String keepLogPeriod = StringUtils.defaultIfBlank(ezCommonService.getTenantConfig("apprMailKeepLogPeriod", tenantId), "3");
		
		List<Map<String, String>> list = new ArrayList<Map<String, String>>();
		
		String inputParams = "tenantId=" + tenantId + "&keepLogPeriod=" + keepLogPeriod + "&lang=" + lang;
		logger.debug("inputParams={}", inputParams);

		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzEmailAppr/getOldApprMailHistoryList";
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		logger.debug("response={}", response);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(response);
		
		if (object.get("resultCode").equals("OK") && ((Long)object.get("reasonCode")).intValue() == 0) {
        	JSONArray resultArray = (JSONArray)object.get("result");
        	
        	for (int i=0; i<resultArray.size(); i++) {
        		Map<String, String> resultMap = new HashMap<String, String>();

        		JSONObject obj = (JSONObject)resultArray.get(i);
        		
        		resultMap.put("tenantId",     (String)obj.get("tenantId"));
           	 	resultMap.put("companyId",    (String)obj.get("companyId"));
                resultMap.put("mailUID",      (String)obj.get("mailUID"));
                resultMap.put("subject",      (String)obj.get("subject"));
                resultMap.put("userId",       (String)obj.get("userId"));
                resultMap.put("userName",     (String)obj.get("userName"));
                resultMap.put("approverId",   (String)obj.get("approverId"));
                resultMap.put("approverName", (String)obj.get("approverName"));
                resultMap.put("type", 		  (String)obj.get("type"));
        		
        		list.add(resultMap);
        	}
		} else {
			throw new Exception("JGwServer ERROR");
		}
		
		return list;
	}
	
	/**
	 * 승인메일 : (전사) 승인로그 전체 리스트 조회 (대기상태 제외)
	 */
	@Override
	public List<Map<String, String>> getApprCompMailHistorySearchList(int tenantId, String companyId, String lang, Locale locale, String offset) throws Exception {
		return getApprCompMailHistorySearchList(tenantId, companyId, lang, locale, offset, null, null);
	}

	/**
	 * 승인메일 : (전사) 승인로그 검색 (대기상태 제외)
     * @param sDate: 시작날짜 
     * @param eDate: 종료날짜
     * sdate, edate 둘다 없는 경우 전체 검색
	 */
	@Override
	public List<Map<String, String>> getApprCompMailHistorySearchList(int tenantId, String companyId, String lang, Locale locale, String offset, String sDate, String eDate) throws Exception {
		return getApprCompMailHistorySearchList(tenantId, companyId, lang, locale, offset, sDate, eDate, 0, 0);
	}

	/**
	 * 승인메일 : (전사) 승인로그 검색 (대기상태 제외) 페이지네이션
     * @param sDate: 시작날짜 
     * @param eDate: 종료날짜
     * sdate, edate 둘다 없는 경우 전체 검색
     * @param pageStartNum: 페이지 시작점 (1부터, 0넣으면 페이지네이션 사용안함)
     * @param listCount: 한페이지에 출력될 리스트 개수
	 */
	@Override
	public List<Map<String, String>> getApprCompMailHistorySearchList(int tenantId, String companyId, String lang, Locale locale, String offset, String sDate, String eDate, int pageStartNum, int listCount) throws Exception {

		String domainName = ezCommonService.getTenantConfig("DomainName", tenantId);
		
		List<Map<String, String>> list = new ArrayList<Map<String, String>>();
		
		String inputParams = "tenantId=" + tenantId + "&companyId=" + companyId + "&lang=" + lang + "&pageStartNum=" + pageStartNum + "&listCount=" + listCount;
		if (sDate != null && eDate != null) {
			inputParams += "&sDate=" + sDate + "&eDate=" + eDate;
		}
		logger.debug("inputParams={}", inputParams);

		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzEmailAppr/getApprCompMailHistorySearchList";
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		logger.debug("response={}", response);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(response);
		
		if (object.get("resultCode").equals("OK") && ((Long)object.get("reasonCode")).intValue() == 0) {
        	JSONArray resultArray = (JSONArray)object.get("result");

    		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
        	
        	for (int i=0; i<resultArray.size(); i++) {
        		JSONObject obj = (JSONObject)resultArray.get(i);
        		
				// UTC -> 사용자 설정 시간
        		String writeDate = sdf.format(sdf.parse((String)obj.get("writeDate")));
				String updatedt = sdf.format(sdf.parse((String)obj.get("updatedt")));

				writeDate = commonUtil.getDateStringInUTC(writeDate, offset, false);
        		updatedt = commonUtil.getDateStringInUTC(updatedt, offset, false);

				// primary 주소로 수정
				String senderId = obj.get("senderEmail").toString().split("@")[0];
				OrganUserVO senderVO = ezOrganAdminService.getUserInfo(senderId, "1", tenantId); // 신청자의 primary 메일주소만 필요하기 때문에 lang 값 1로 픽스 함
				obj.put("senderEmail", senderVO.getMail());

        		Map<String, String> resultMap = new HashMap<String, String>();
        		
        		resultMap.put("tenantId",     (String)obj.get("tenantId"));
           	 	resultMap.put("companyId",    (String)obj.get("companyId"));
                resultMap.put("mailUID",      (String)obj.get("mailUID"));
                resultMap.put("subject",      (String)obj.get("subject"));
                resultMap.put("userId",       (String)obj.get("userId"));
                resultMap.put("userName",     (String)obj.get("userName"));
                resultMap.put("approverId",   (String)obj.get("approverId"));
                resultMap.put("approverName", (String)obj.get("approverName"));
                resultMap.put("approverEmail", ((String)obj.get("approverId")) + "@" + domainName);
                resultMap.put("type", 		  (String)obj.get("type"));
                resultMap.put("writeDate",	  writeDate);
                resultMap.put("updateDt",	  updatedt);
                resultMap.put("state", 		  	(String)obj.get("state"));
                resultMap.put("stateStr", 	   	setStateByLocale((String)obj.get("state"), locale));
                resultMap.put("senderEmail",  	(String)obj.get("senderEmail"));
                resultMap.put("userDeptName",  	(String)obj.get("userDeptName"));
                resultMap.put("href",  			setHref((String)obj.get("userId"), (String)obj.get("mailUID")) );
        		
        		list.add(resultMap);
        	}
		} else {
			throw new Exception("JGwServer ERROR");
		}
		
		return list;
	}

	/**
	 * 승인메일 : (전사) 승인로그 검색 (대기상태 제외) 전체 개수
     * @param sDate: 시작날짜 
     * @param eDate: 종료날짜
     * sdate, edate 둘다 없는 경우 전체 검색
	 */
	@Override
	public int getApprCompMailHistorySearchListCnt(int tenantId, String companyId, String sDate, String eDate) throws Exception {
		
		int listCount = 0;
		
		String inputParams = "tenantId=" + tenantId + "&companyId=" + companyId;
		if (sDate != null && eDate != null) {
			inputParams += "&sDate=" + sDate + "&eDate=" + eDate;
		}
		logger.debug("inputParams={}", inputParams);

		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzEmailAppr/getApprCompMailHistorySearchListCnt";
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		logger.debug("response={}", response);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(response);
		
		if (object.get("resultCode").equals("OK") && ((Long)object.get("reasonCode")).intValue() == 0) {
			listCount = ((Long) object.get("result")).intValue();
		} else {
			throw new Exception("JGwServer ERROR");
		}
		
		return listCount;
	}

	/**
	 * 승인메일 : (전사) 승인로그 검색 (대기상태 제외) 사용자 데이터 개수 조회
     * @param sDate: 시작날짜 
     * @param eDate: 종료날짜
     * sdate, edate 둘다 없는 경우 전체 검색
	 */
	@Override
	public List<Map<String, String>> getApprCompMailHistorySearchUserCnt(int tenantId, String companyId, String lang, String sDate, String eDate) throws Exception {
		
		List<Map<String, String>> list = new ArrayList<Map<String, String>>();
		
		String inputParams = "tenantId=" + tenantId + "&companyId=" + companyId + "&lang=" + lang;
		if (sDate != null && eDate != null) {
			inputParams += "&sDate=" + sDate + "&eDate=" + eDate;
		}
		logger.debug("inputParams={}", inputParams);

		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzEmailAppr/getApprCompMailHistorySearchUserCnt";
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		logger.debug("response={}", response);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(response);
		
		if (object.get("resultCode").equals("OK") && ((Long)object.get("reasonCode")).intValue() == 0) {
        	JSONArray resultArray = (JSONArray)object.get("result");

        	for (int i=0; i<resultArray.size(); i++) {
        		JSONObject obj = (JSONObject)resultArray.get(i);
        		
        		Map<String, String> resultMap = new HashMap<String, String>();
        		resultMap.put("userId",     (String)obj.get("userId"));
           	 	resultMap.put("userName",    (String)obj.get("userName"));
                resultMap.put("userCnt",      (String)obj.get("userCnt"));
                resultMap.put("senderEmail",      (String)obj.get("senderEmail"));
        		
        		list.add(resultMap);
        	}
		} else {
			throw new Exception("JGwServer ERROR");
		}
		
		return list;
	}
	
	/**
	 * 승인메일 : (일반) 승인로그 전체 리스트 조회 (대기상태 제외)
	 */
	@Override
	public JSONArray getApprMailHistorySearchList(int tenantId, String companyId, String lang, Locale locale, String offset) throws Exception {
		return getApprMailHistorySearchList(tenantId, companyId, lang, locale, offset, null, null);
	}

	/**
	 * 승인메일 : (일반) 승인로그 검색 (대기상태 제외)
     * @param sDate: 시작날짜 
     * @param eDate: 종료날짜
     * sdate, edate 둘다 없는 경우 전체 검색
	 */
	@Override
	public JSONArray getApprMailHistorySearchList(int tenantId, String companyId, String lang, Locale locale, String offset, String sDate, String eDate) throws Exception {
		return getApprMailHistorySearchList(tenantId, companyId, lang, locale, offset, sDate, eDate, 0, 0);
	}

	/**
	 * 승인메일 : (일반) 승인로그 검색 (대기상태 제외)
     * @param sDate: 시작날짜 
     * @param eDate: 종료날짜
     * sdate, edate 둘다 없는 경우 전체 검색
	 */
	@Override
	public JSONArray getApprMailHistorySearchList(int tenantId, String companyId, String lang, Locale locale, String offset, String sDate, String eDate, int pageStartNum, int listCount) throws Exception {
		//List<Map<String, String>> list = new ArrayList<Map<String, String>>();
		JSONArray resultArray = new JSONArray();
		
		String inputParams = "tenantId=" + tenantId + "&companyId=" + companyId + "&lang=" + lang + "&pageStartNum=" + pageStartNum + "&listCount=" + listCount;
		if (sDate != null && eDate != null) {
			inputParams += "&sDate=" + sDate + "&eDate=" + eDate;
		}
		logger.debug("inputParams={}", inputParams);

		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzEmailAppr/getApprMailHistorySearchList";
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		logger.debug("response={}", response);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(response);
		
		if (object.get("resultCode").equals("OK") && ((Long)object.get("reasonCode")).intValue() == 0) {
        	JSONArray array = (JSONArray)object.get("result");
			//resultArray = ezEmailService.setUTCtoUserTime(array, offset, tenantId);
			resultArray = formatApprEmail(array, offset, tenantId, locale);

    		/*SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
        	
        	for (int i=0; i<resultArray.size(); i++) {
        		JSONObject obj = (JSONObject)resultArray.get(i);
        		
        		String writeDate = sdf.format(sdf.parse((String)obj.get("writeDate")));
        				writeDate = commonUtil.getDateStringInUTC(writeDate, offset, false);
        		String updatedt = sdf.format(sdf.parse((String)obj.get("updatedt")));
        			updatedt = commonUtil.getDateStringInUTC(updatedt, offset, false);

        		Map<String, String> resultMap = new HashMap<String, String>();
        		
        		resultMap.put("tenantId",     (String)obj.get("tenantId"));
           	 	resultMap.put("companyId",    (String)obj.get("companyId"));
                resultMap.put("mailUID",      (String)obj.get("mailUID"));
                resultMap.put("subject",      (String)obj.get("subject"));
                resultMap.put("userId",       (String)obj.get("userId"));
                resultMap.put("userName",     (String)obj.get("userName"));
                resultMap.put("approverId",   (String)obj.get("approverId"));
                resultMap.put("approverName", (String)obj.get("approverName"));
                resultMap.put("approverEmail", ((String)obj.get("approverId")) + "@" + domainName);
                resultMap.put("type", 		  (String)obj.get("type"));
                resultMap.put("writeDate",	  writeDate);
                resultMap.put("updateDt",	  updatedt);
                resultMap.put("state", 		  (String)obj.get("state"));
                resultMap.put("stateStr", 	   setStateByLocale((String)obj.get("state"), locale));
                resultMap.put("senderEmail",  (String)obj.get("senderEmail"));
                resultMap.put("userDeptName",  (String)obj.get("userDeptName"));
                resultMap.put("href",  			setHref((String)obj.get("userId"), (String)obj.get("mailUID")) );
        		
        		list.add(resultMap);
        	}*/
		} else {
			throw new Exception("JGwServer ERROR");
		}
		
		return resultArray;
	}

	/**
	 * 승인메일 : (일반) 승인로그 검색 (대기상태 제외) 전체 개수
     * @param sDate: 시작날짜 
     * @param eDate: 종료날짜
     * sdate, edate 둘다 없는 경우 전체 검색
	 */
	@Override
	public int getApprMailHistorySearchListCnt(int tenantId, String companyId, String sDate, String eDate) throws Exception {
		
		int listCount = 0;
		
		String inputParams = "tenantId=" + tenantId + "&companyId=" + companyId;
		if (sDate != null && eDate != null) {
			inputParams += "&sDate=" + sDate + "&eDate=" + eDate;
		}
		logger.debug("inputParams={}", inputParams);

		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzEmailAppr/getApprMailHistorySearchListCnt";
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		logger.debug("response={}", response);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(response);
		
		if (object.get("resultCode").equals("OK") && ((Long)object.get("reasonCode")).intValue() == 0) {
			listCount = ((Long) object.get("result")).intValue();
		} else {
			throw new Exception("JGwServer ERROR");
		}
		
		return listCount;
	}

	/**
	 * 승인메일 : (일반) 승인로그 검색 (대기상태 제외) 사용자 데이터 개수 조회
     * @param sDate: 시작날짜 
     * @param eDate: 종료날짜
     * sdate, edate 둘다 없는 경우 전체 검색
	 */
	@Override
	public List<Map<String, String>> getApprMailHistorySearchUserCnt(int tenantId, String companyId, String lang, String sDate, String eDate) throws Exception {
		
		List<Map<String, String>> list = new ArrayList<Map<String, String>>();
		
		String inputParams = "tenantId=" + tenantId + "&companyId=" + companyId + "&lang=" + lang;
		if (sDate != null && eDate != null) {
			inputParams += "&sDate=" + sDate + "&eDate=" + eDate;
		}
		logger.debug("inputParams={}", inputParams);

		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzEmailAppr/getApprMailHistorySearchUserCnt";
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		logger.debug("response={}", response);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(response);
		
		if (object.get("resultCode").equals("OK") && ((Long)object.get("reasonCode")).intValue() == 0) {
        	JSONArray resultArray = (JSONArray)object.get("result");

        	for (int i=0; i<resultArray.size(); i++) {
        		JSONObject obj = (JSONObject)resultArray.get(i);
        		
        		Map<String, String> resultMap = new HashMap<String, String>();
        		resultMap.put("userId",     (String)obj.get("userId"));
           	 	resultMap.put("userName",    (String)obj.get("userName"));
                resultMap.put("userCnt",      (String)obj.get("userCnt"));
                resultMap.put("senderEmail",      (String)obj.get("senderEmail"));
        		
        		list.add(resultMap);
        	}
		} else {
			throw new Exception("JGwServer ERROR");
		}
		
		return list;
	}

	@Override
	public void actionTrashMailAllDelete(IMAPAccess ia, String folderId) throws Exception {
		logger.debug("actionTrashMailAllDelete started.");
		
		IMAPFolder sourceFolder = (IMAPFolder)ia.getFolder(folderId);
		sourceFolder.open(Folder.READ_WRITE);
		
		if (sourceFolder.exists()) {
			Message[] deleteMsgs = null;

			deleteMsgs = sourceFolder.getMessages();

			for (int i = 0; i < deleteMsgs.length; i += 100) {
				int end = Math.min(i + 100, deleteMsgs.length);
				sourceFolder.setFlags(Arrays.copyOfRange(deleteMsgs, i, end), new Flags(Flags.Flag.DELETED), true);
				sourceFolder.expunge();
			}
		}
		logger.debug("actionTrashMailAllDelete ended.");
	}

	@Override
	public void actionMailMoveTrash(IMAPAccess ia, Map<String, long[]> folderIdUids, String cmd, Locale locale, int tenantID, String userEmail, String domainName) throws Exception {
		logger.debug("actionMailMoveTrash started.");
		
		boolean isNewUserQuotaNeeded = false;
		boolean isThereUserLevelQuota = false;
		Double userQuota = 0.0;
		Double userWarn = 0.0;
		
		// 2025-02-19 - 다중 편지함 지원을 위해 for문, long[] uids 추가
		for (String folderId : folderIdUids.keySet()) {
			IMAPFolder sourceFolder = (IMAPFolder) ia.getFolder(folderId);
			sourceFolder.open(Folder.READ_WRITE);

			Message[] deleteMsgs = null;
			long[] uids = folderIdUids.get(folderId);
			deleteMsgs = sourceFolder.getMessagesByUID(uids);

			// 2018-10-09 메일 영구 삭제 시 메일 제목, 받은 날짜 로그 추가
			if (!cmd.equalsIgnoreCase("BMOVE")) {
				String subject = null;
				String from = null;
				String receivedDate = null;
	
				for (Message message : deleteMsgs) {
					subject = ezEmailUtil.getSubject(message);
					subject = (subject != null) ? subject : "";
					from = ezEmailUtil.getFullFromAddressOfMessage(message);
					receivedDate = (message.getReceivedDate() != null) ? message.getReceivedDate().toString() : "";
	
					logger.debug("subject=" + subject + ",from=" + from + ",receivedDate=" + receivedDate);
				}
			}
	
	
			String useImapMoveCommand = ezCommonService.getTenantConfig("useImapMoveCommand", tenantID);
	
			if (useImapMoveCommand.equals("YES")) {
				if (cmd.equalsIgnoreCase("BMOVE")) {
					IMAPFolder deletedFolder = (IMAPFolder)ia.getFolder(ezEmailUtil.getTrashFolderId(locale));
					sourceFolder.moveUIDMessages(deleteMsgs, deletedFolder);
				} else {
					sourceFolder.setFlags(deleteMsgs, new Flags(Flags.Flag.DELETED), true);
				}
			} else {
				if (cmd.equalsIgnoreCase("BMOVE")) {
					// 지운 편지함으로 보낼 메시지의 크기가 Quota량을 초과하게 되면 Quota를 재조정한다.
					Double[] adjustQuotaData = ezEmailUtil.adjustUserQuotaForMessageMove(deleteMsgs, userEmail, domainName, ia);
	
					if (adjustQuotaData[0] != null) {
						isNewUserQuotaNeeded = true;
	
						userQuota = adjustQuotaData[0];
						userWarn = adjustQuotaData[1];
					}
	
					if (adjustQuotaData[2] != null) {
						isThereUserLevelQuota = true;
					}
	
					IMAPFolder deletedFolder = (IMAPFolder) ia.getFolder(ezEmailUtil.getTrashFolderId(locale));
					sourceFolder.copyUIDMessages(deleteMsgs, deletedFolder);
				}
	
				sourceFolder.setFlags(deleteMsgs, new Flags(Flags.Flag.DELETED), true);
			}
	
			sourceFolder.expunge();
	
			if (isNewUserQuotaNeeded) {
				if (isThereUserLevelQuota) {
					ezEmailUtil.setUserQuota(userEmail, String.valueOf(userQuota), String.valueOf(userWarn));
					// 사용자 레벨 Quota 설정값이 없었던 경유에는 해당 설정값을 삭제한다.
				} else {
					ezEmailUtil.deleteUserQuota(userEmail);
				}
			}
		}

		logger.debug("actionMailMoveTrash ended.");
	}

	public String encryptSecureValue(String encryptValue, boolean useKlibEncrypt) throws Exception {
		if (useKlibEncrypt) {
			byte[] encrypt = klibUtil.encrypt(encryptValue.getBytes());
			return new String(Base64.encodeBase64(encrypt));
		} else {
			return egovFileScrty.encryptAES(encryptValue);
		}
	}

	public String decryptSecureValue(String decryptValue, boolean useKlibEncrypt) throws Exception {
		if (useKlibEncrypt) {
			byte[] decrypt = Base64.decodeBase64(decryptValue.getBytes());
			return new String(klibUtil.decrypt(decrypt));
		} else {
			return egovFileScrty.decryptAES(decryptValue);
		}
	}
}