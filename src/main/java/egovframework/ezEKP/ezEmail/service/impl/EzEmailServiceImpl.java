package egovframework.ezEKP.ezEmail.service.impl;

import java.net.URLEncoder;
import java.security.PrivateKey;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;
import java.util.UUID;

import javax.annotation.Resource;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.w3c.dom.Document;
import org.w3c.dom.NodeList;

import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezEmail.task.EzEmailAsync;
import egovframework.ezEKP.ezEmail.util.EzEmailUtil;
import egovframework.ezEKP.ezEmail.vo.MailCancelVO;
import egovframework.ezEKP.ezEmail.vo.MailColorVO;
import egovframework.ezEKP.ezEmail.vo.MailDeleteVO;
import egovframework.ezEKP.ezEmail.vo.MailGeneralVO;
import egovframework.ezEKP.ezEmail.vo.MailPOP3VO;
import egovframework.ezEKP.ezEmail.vo.MailReadVO;
import egovframework.ezEKP.ezEmail.vo.MailReservationVO;
import egovframework.ezEKP.ezEmail.vo.MailSignatureVO;
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
	private EzEmailAsync ezEmailAsync;
	
	@Resource(name="crypto") 
	private EgovFileScrty egovFileScrty;
	
	@Override
	public List<MailGeneralVO> getMailGeneral(int tenantId, String userId) throws Exception {
		List<MailGeneralVO> mailGeneralList = new ArrayList<MailGeneralVO>();
		
		String domainName = ezCommonService.getTenantConfig("DomainName", tenantId);
		
		String inputParams = "userId=" + URLEncoder.encode(userId + "@" + domainName, "UTF-8");
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
			
			mailGeneralList.add(mailGeneral);
		}
		
		return mailGeneralList;
	}
	
	@Override
	public void setMailGeneral(int tenantId, String userId, MailGeneralVO mailGeneral, String mode) throws Exception {
		String domainName = ezCommonService.getTenantConfig("DomainName", tenantId);
		
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
		
		String modeParam = "mode=";
		if (mode != null && mode.equals("ALL")) {
			modeParam = "mode=all";
		}
		
		String inputParams = userIdParam + "&" + listCountParam + "&" + refreshIntervalParam + "&" + keepDeleteLengthParam + "&" + previewModeParam
				+ "&" + previewWListParam + "&" + previewWContentParam + "&" + previewHListParam + "&" + previewHContentParam + "&" + mailSenderNameParam
				+ "&" + modeParam;
		logger.debug("inputParams=" + inputParams);
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaEzEmail/setMailGeneral", inputParams);
		logger.debug("strJson=" + strJson);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(strJson);
        
        if (!object.get("resultCode").equals("OK") || ((Long)object.get("reasonCode")).intValue() != 0) {
        	throw new Exception("JGwServer ERROR");
        }
	}
	
	@Override
	public MailSignatureVO getMailSignature(int tenantId, String pUserID) throws Exception {
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
        
        return mailSignatureVO;
	}

	@Override
	public void setMailSignature(int tenantId, String pUserID, String pUseFlag, String pContent1, String pContent2, String pContent3)
			throws Exception {
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
	}
	
	@Override
	public MailColorVO getMailColor(int tenantId) throws Exception {
		MailColorVO vo = new MailColorVO();
		
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
        
        return vo;
	}
	
	@Override
	public void setMailColor(int pTenantId, String pImportanceColor, String pInColor, String pOutColor) throws Exception {
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
	}
	
	@Override
	public List<MailDeleteVO> getMailDelete(int tenantId, String userId) throws Exception {
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
        
        return list;
	}
	
	@Override
	public void setMailDelete(int tenantId, String pUserID, String pPath, int pExpireTime, int pDeleteUnread, String pFolderName)
			throws Exception {
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
	}
	
	@Override
	public void deleteMailDelete(int tenantId, String pUserID, String pFolderPath) throws Exception {
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
	}
	
	@Override
	public List<MailDeleteVO> getMailDeleteList() throws Exception {
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
        		
        		mailDeleteVO.setUserId(((String)obj.get("userId")).split("@")[0]);
        		mailDeleteVO.setPath((String)obj.get("folderPath"));
        		mailDeleteVO.setExpireTime(((Long)obj.get("expireTime")).intValue());
        		mailDeleteVO.setDeleteUnread((String)obj.get("deleteUnread"));
        		mailDeleteVO.setFolderName((String)obj.get("folderName"));
        		
        		list.add(mailDeleteVO);
        	}
        }
        
        return list;
	}
	
	@Override
	public List<MailReservationVO> getMailReserved(int tenantId, String pUserId) throws Exception {
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
        
        return list;
	}
	
	@Override
	public List<MailReservationVO> getMailReserved2() throws Exception {
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
        
		return list;
	}
	
	@Override
	public String setMailReserved(int tenantId, String pMessageId, String pSubject, String pSendDate, String pUserId, String isReserve)
			throws Exception {
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
        
        return pMessageId;
	}
	
	@Override
	public void deleteMailReserved(String pMessageId) throws Exception {
		String inputParams = "messageId=" + URLEncoder.encode(pMessageId, "UTF-8");
		logger.debug("inputParams=" + inputParams);
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaEzEmail/deleteMailReserved", inputParams);
		logger.debug("strJson=" + strJson);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(strJson);
        
        if (!object.get("resultCode").equals("OK") || ((Long)object.get("reasonCode")).intValue() != 0) {
        	throw new Exception("Error from JGwServer.");
        }
	}
	
	@Override
	public String getMailReservedTime(String pMessageId) throws Exception {
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
        
        return pReservedSaveTime;
	}
	
	@Override
	public List<MailReadVO> getMailReadList(int tenantId, String pUserId, String pMessageId) throws Exception {
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
		
		return readList;
	}
	
	@Override
	public List<MailCancelVO> getMailCancelList(String pMessage) throws Exception {
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
        		mailCancelVO.setStatus((String)obj.get("status"));
        		
				cancelList.add(mailCancelVO);
        	}
		}
		
		return cancelList;
	}
	
	@Override
	public void setMailCancelSend(int tenantId, String pMessageId, String pUserId, String pSubject, String pCreateDate, String pLocalServerName, List<String> pInnerAddresses) throws Exception {
		String domainName = ezCommonService.getTenantConfig("DomainName", tenantId);
		
		String messageIdParam = "messageId=" + URLEncoder.encode(pMessageId, "UTF-8");
		String senderEmailParam = "senderEmail=" + URLEncoder.encode(pUserId + "@" + domainName, "UTF-8");
		String subjectParam = "subject=" + URLEncoder.encode(pSubject, "UTF-8");
		//TODO: recallDate가 아닌거같다...?
		String recallDateParam = "recallDate=" + URLEncoder.encode(pCreateDate, "UTF-8");
		String serverNameParam = "serverName=" + URLEncoder.encode(pLocalServerName, "UTF-8");
		
		StringBuilder receiverEmailParam = new StringBuilder();
		for (String innerAddress : pInnerAddresses) {
			receiverEmailParam.append("&re=" + URLEncoder.encode(innerAddress, "UTF-8"));
		}
		
		String inputParams = messageIdParam + "&" + senderEmailParam + "&" + subjectParam + "&" + recallDateParam + "&" + serverNameParam;
		inputParams += receiverEmailParam.toString();
		logger.debug("inputParams=" + inputParams);
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaEzEmail/setMailRecall", inputParams);
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
			ezEmailAsync.cancelMailDelete(recallIdx);
		} else {
			throw new Exception("Cannot get recallIdx. So, cannot call cancelMailDelete method(Async).");
		}
	}

	@Override
	public String getMailReceiveMessageId(String pNum) throws Exception {
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
        
        return messageId;
	}
	
	@Override
	public void updateMailReceiveDetailInfo(String pNum, List<String[]> receiveDetailList) throws Exception {
		StringBuilder inputParams = new StringBuilder();
		
		inputParams.append("recallIdx=" + URLEncoder.encode(pNum, "UTF-8"));
		
		for (String[] receiveDetail : receiveDetailList) {
			inputParams.append("&re=" + URLEncoder.encode(receiveDetail[0], "UTF-8"));
			inputParams.append("&s=" + URLEncoder.encode(receiveDetail[1], "UTF-8"));
		}
		
		logger.debug("inputParams=" + inputParams.toString());
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaEzEmail/updateMailRecallDetail", inputParams.toString());
		logger.debug("strJson=" + strJson);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(strJson);
        
        if (!object.get("resultCode").equals("OK") || ((Long)object.get("reasonCode")).intValue() != 0) {
        	throw new Exception("Error from JGwServer.");
        }
	}
	
	@Override
	public List<String> getMailReceiveAddress(String pNum) throws Exception {
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
		
		return addressList;
	}
	
	@Override
	public List<MailPOP3VO> getMailPOP3(int tenantId, String pUserId) throws Exception {
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
		
		return list;
	}
	
	@Override
	public void savePop3(int tenantId, String pUserId, String pRet) throws Exception {
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
	}
	
	@Override
	public void setMailPOP3List(int tenantId, String pUserId, String pPop3Server, String pPop3UserId, List<String> pMessageIds) throws Exception {
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
	}
	
	@Override
	public List<String> getMailPOP3List(int tenantId, String pUserId, String pPop3Server, String pPop3UserId) throws Exception {
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
		
		return list;
	}
	
}
