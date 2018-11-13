package egovframework.ezEKP.ezEmail.service.impl;

import java.io.File;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.security.PrivateKey;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;
import java.util.UUID;

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

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.w3c.dom.Document;
import org.w3c.dom.NodeList;

import com.sun.mail.imap.IMAPFolder;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.logic.IMAPAccess;
import egovframework.ezEKP.ezEmail.logic.SMTPAccess;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezEmail.task.EzEmailAsync;
import egovframework.ezEKP.ezEmail.util.EmailImportance;
import egovframework.ezEKP.ezEmail.util.EzEmailUtil;
import egovframework.ezEKP.ezEmail.vo.MailCancelVO;
import egovframework.ezEKP.ezEmail.vo.MailColorVO;
import egovframework.ezEKP.ezEmail.vo.MailDeleteVO;
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
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

@Service("EzEmailService")
public class EzEmailServiceImpl implements EzEmailService {
	
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
	
	@Autowired
	private EzEmailAsync ezEmailAsync;
	
	@Resource(name="crypto") 
	private EgovFileScrty egovFileScrty;
	
	@Resource(name="egovMessageSource")
    private EgovMessageSource egovMessageSource;

	@Override
	public List<MailGeneralVO> getMailGeneral(int tenantId, String userId) throws Exception {
		logger.debug("getMailGeneral started. tenantId=" + tenantId + ",userId=" + userId);
		
		List<MailGeneralVO> mailGeneralList = new ArrayList<MailGeneralVO>();
		
		String domainName = ezCommonService.getTenantConfig("DomainName", tenantId);
		String usePreviewSubTree = ezCommonService.getTenantConfig("UsePreviewSubTreeForEmail", tenantId);
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
        		
        		mailGeneralList.add(mailGeneral);
        	}
        }
        
        // set the defaults if there is no record in DB.
		if (mailGeneralList.size() == 0) {
			MailGeneralVO mailGeneral = new MailGeneralVO();
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
			
			mailGeneralList.add(mailGeneral);
		}
		
		logger.debug("getMailGeneral ended.");
		return mailGeneralList;
	}
	
	@Override
	public void setMailGeneral(int tenantId, String userId, MailGeneralVO mailGeneral, String mode) throws Exception {
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
		
		String modeParam = "mode=";
		if (mode != null && mode.equals("ALL")) {
			modeParam = "mode=all";
		}
		
		String inputParams = userIdParam + "&" + listCountParam + "&" + refreshIntervalParam + "&" + keepDeleteLengthParam + "&" + previewModeParam
				+ "&" + previewWListParam + "&" + previewWContentParam + "&" + previewHListParam + "&" + previewHContentParam + "&" + mailSenderNameParam
				+ "&" + modeParam +"&" + previewSubTreeParam + "&" + usePreviewSubTreeParam;
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
        		
        		list.add(mailDeleteVO);
        	}
        } else {
        	throw new Exception("JGwServer ERROR");
        }
        
        logger.debug("getMailDelete ended.");
        return list;
	}
	
	@Override
	public void setMailDelete(int tenantId, String pUserID, String pPath, int pExpireTime, int pDeleteUnread, String pFolderName) throws Exception {
		logger.debug("setMailDelete started.");
		logger.debug("tenantId=" + tenantId + ",pUserID=" + pUserID + ",pPath=" + pPath + ",pExpireTime=" + pExpireTime + ",pDeleteUnread=" + pDeleteUnread + ",pFolderName=" + pFolderName);
		
		String domainName = ezCommonService.getTenantConfig("DomainName", tenantId);
		
		String userIdParam = "userId=" + URLEncoder.encode(pUserID + "@" + domainName, "UTF-8");
		String folderPathParam = "folderPath=" + URLEncoder.encode(pPath, "UTF-8");
		String expireTimeParam = "expireTime=" + pExpireTime;
		String deleteUnreadParam = "deleteUnread=" + pDeleteUnread;
		String folderNameParam = "folderName=" + URLEncoder.encode(pFolderName, "UTF-8");
		
		String inputParams = userIdParam + "&" + folderPathParam + "&" + expireTimeParam + "&" + deleteUnreadParam + "&" + folderNameParam;
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
        		
        		list.add(vo);
        	}
        }
        
        logger.debug("getMailReserved2 ended.");
		return list;
	}
	
	@Override
	public String setMailReserved(int tenantId, String pMessageId, String pSubject, String pSendDate, String pUserId, String isReserve) throws Exception {
		logger.debug("setMailReserved started.");
		logger.debug("tenantId=" + tenantId + ",pMessageId=" + pMessageId + ",pSubject=" + pSubject + ",pSendDate=" + pSendDate + ",pUserId=" + pUserId + ",isReserve=" + isReserve);
		
		if (!isReserve.equalsIgnoreCase("YES")) {
			pMessageId = UUID.randomUUID().toString();
		}
		
		String domainName = ezCommonService.getTenantConfig("DomainName", tenantId);
		
		String messageIdParam = "messageId=" + URLEncoder.encode(pMessageId, "UTF-8");
		String userIdParam = "userId=" + URLEncoder.encode(pUserId + "@" + domainName, "UTF-8");
		String subjectParam = "subject=" + URLEncoder.encode(pSubject, "UTF-8");
		String sendDateParam = "sendDate=" + URLEncoder.encode(pSendDate, "UTF-8");
		
		String inputParams = messageIdParam + "&" + userIdParam + "&" + subjectParam + "&" + sendDateParam;
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
        		
				cancelList.add(mailCancelVO);
        	}
		}
		
		logger.debug("getMailCancelList ended.");
		return cancelList;
	}
	
	@Override
	public void setMailCancelSend(int tenantId, String primary, String pMessageId, String pUserId, String pSubject, List<String> pInnerAddresses) throws Exception {
		logger.debug("setMailCancelSend started.");
		logger.debug("tenantId=" + tenantId + ",primary=" + primary + ",pMessageId=" + pMessageId + ",pUserId=" + pUserId + ",pSubject=" + pSubject);
		
		String domainName = ezCommonService.getTenantConfig("DomainName", tenantId);
		
		String messageIdParam = "messageId=" + URLEncoder.encode(pMessageId, "UTF-8");
		String senderEmailParam = "senderEmail=" + URLEncoder.encode(pUserId + "@" + domainName, "UTF-8");
		String subjectParam = "subject=" + URLEncoder.encode(pSubject, "UTF-8");
		String primaryParam = "primary=" + primary;
		String tenantIdParam = "tenantId=" + tenantId;
		
		StringBuilder receiverEmailParam = new StringBuilder();
		
		for (String innerAddress : pInnerAddresses) {
			receiverEmailParam.append("&re=" + URLEncoder.encode(innerAddress, "UTF-8"));
		}
		
		String inputParams = messageIdParam + "&" + senderEmailParam + "&" + subjectParam + "&" + primaryParam + "&" + tenantIdParam;
		inputParams += receiverEmailParam.toString();
		logger.debug("inputParams=" + inputParams);
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaEzEmail/setMailRecall2", inputParams);
		logger.debug("strJson=" + strJson);
		
		//get recallIdx
		String recallIdx = "";
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(strJson);
		
		if (object.get("resultCode").equals("OK") && ((Long)object.get("reasonCode")).intValue() == 0) {
        	recallIdx = (String)object.get("result");
		}
		
		//회수처리 함수 호출(비동기)
		if (recallIdx != null && !recallIdx.equals("") && !recallIdx.equals("0")) {
			ezEmailAsync.cancelMailDelete(recallIdx, tenantId);
		} else {
			throw new Exception("Cannot get recallIdx. So, cannot call cancelMailDelete method(Async).");
		}
		
		logger.debug("setMailCancelSend ended.");
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
				ezOrganAdminDao.setUserPrimaryMail(userId, tenantID, primaryMail);
				
				returnValue = "OK";
			}
		}						
		
		logger.debug("setIndividualAlias ended. returnValue=" + returnValue);
		
		return returnValue;
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
						resultMap = (JSONObject)responseObj.get("result");
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
		
		IMAPAccess ia = null;
		
		try {
			SMTPAccess sa = SMTPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.SMTPPort"),
					userEmail, password);
			
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
	        
			// set importance header
			if (importance != EmailImportance.NORMAL) {
				message.setHeader("Importance", importance.getMappingValue());
				message.setHeader("X-Priority", importance.getPriority());
			}
	        
	        // set X-JMocha-Noti header
	        message.setHeader("X-JMocha-Noti", "true");
	        
	        Transport.send(message);
	        logger.debug("Mail send success.");
	        
	        if (isSaved) {
	        	//보낸편지함에 저장
	        	ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
	        			userEmail, password, egovMessageSource, userLocale, ezEmailUtil);
	        	
	    		Folder sentFolder = ia.getFolder(ezEmailUtil.getSentFolderId(userLocale));
	    		
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
			e.printStackTrace();
		} finally {
			if (ia != null) {
				ia.close();
			}
		}
		
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
			e.printStackTrace();
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
            	
            	Folder folder = ia.getFolder(mailbox);
            	
            	if (folder.exists()) {
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
            } catch (Exception e) {
            	e.printStackTrace();
            } finally {
				ia.close();
			}
            
		} catch (Exception e) {
			e.printStackTrace();
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
		
		} catch (Exception e) {
			logger.debug(e.getMessage());
			e.printStackTrace();
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
	public List<String[]> getAliasAddress(String userId, int tenantId) throws Exception {
		logger.debug("getAliasAddress started. userId=" + userId);
		
		String domainName = ezCommonService.getTenantConfig("DomainName", tenantId);
		String userAccount = userId + "@" + domainName;
				
		String inputParams = "userId=" + URLEncoder.encode(userAccount, "UTF-8");
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
						aliasAddressList.add(new String[] {(String)obj.get("address"), (String)obj.get("type")});
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
	        		true, false, "receivedDate", false, 0, 30, true, null, userInfo.getTenantId());
	        
	        for (int i=0; i<messages.length; i++) {
	        	Message message = messages[i];
	        	UIDFolder uidFolder = (UIDFolder)message.getFolder();
	        	
	        	Date receivedDate = message.getReceivedDate();
	        	String receivedDateStr = sdf.format(receivedDate);
//	        	receivedDateStr = commonUtil.getDateStringInUTC(receivedDateStr, userInfo.getOffset(), false);
	        	
	        	String subject = ezEmailUtil.getSubject(message);
				subject = (subject != null) ? subject : "";
	        	
	        	Map<String, String> map = new HashMap<String, String>();
	        	map.put("subject", subject);
	        	map.put("sender", ezEmailUtil.getFromNameOrAddressOfMessage(message));
	        	map.put("receivedDate", receivedDateStr);
	        	map.put("uid", String.valueOf(uidFolder.getUID(message)));
	        	
	        	list.add(map);
	        }
	        
		} catch (Exception e) {
			e.printStackTrace();
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
	public List<Map<String, String>> getUserSharedMailboxList(String userId, int tenantId) throws Exception {
		logger.debug("getUserSharedMailboxList started.");
		logger.debug("userId=" + userId + ",tenantId=" + tenantId);
		
		List<Map<String, String>> list = new ArrayList<Map<String, String>>();
		
		String tenantIdParam = "tenantId=" + tenantId;
		String userIdParam = "userId=" + URLEncoder.encode(userId, "UTF-8");
		String inputParams = tenantIdParam + "&" + userIdParam;
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
    				map.put("shareName", (String)obj.get("shareName"));
        			map.put("mail", (String)obj.get("mail"));
        			map.put("compId", (String)obj.get("compId"));
        			
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
		logger.debug("getSharedMailboxInfo started.");
		logger.debug("shareId=" + shareId + ",tenantId=" + tenantId);
		
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
        			userVO.setUserName((String)user.get("userName"));
        			userVO.setDeptId((String)user.get("deptId"));
        			userVO.setDeptName((String)user.get("deptName"));
        			userVO.setCompId((String)user.get("compId"));
        			userVO.setCompName((String)user.get("compName"));
        			userVO.setDeletePermission((String)user.get("deletePermission"));
        			userVO.setSendPermission((String)user.get("sendPermission"));
        			
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
        	shareMailBoxPermissonInfo.setShareName((String)result.get("displayname"));
        }
		
		logger.debug("getSharedMailboxPermissionInfo ended.");
		return shareMailBoxPermissonInfo;
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
		
		Map<String, Object> map = new HashMap<>();
		map.put("tenantId", tenantId);
		map.put("deptId", "shared_mailbox_" + companyId);
		map.put("searchValue", "%" + searchValue + "%");
		
		List<OrganUserVO> userList = ezOrganDao.getSharedMailboxSearchList(map);
		List<MailSharedMailboxVO> list = new ArrayList<>();
		MailSharedMailboxVO vo = null;
		
		for (OrganUserVO user : userList) {
			vo = new MailSharedMailboxVO();
			
			vo.setShareName(user.getDisplayName());
			vo.setShareId(user.getCn());
			vo.setShareMail(user.getMail());
			
			list.add(vo);
		}
		
		logger.debug("getSharedMailboxSearchList ended. listSize=" + list.size());
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
	
}