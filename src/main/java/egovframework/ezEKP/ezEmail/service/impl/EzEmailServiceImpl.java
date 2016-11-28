package egovframework.ezEKP.ezEmail.service.impl;

import java.net.URLEncoder;
import java.security.PrivateKey;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.UUID;

import javax.annotation.Resource;
import javax.mail.internet.InternetAddress;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.w3c.dom.Document;
import org.w3c.dom.NodeList;

import egovframework.ezEKP.ezEmail.dao.EzEmailDAO;
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

	@Autowired
	private EzEmailAsync ezEmailAsync;
	
	@Resource(name="EzEmailDAO")
	private EzEmailDAO ezEmailDAO;
	
	@Resource(name="crypto") 
	private EgovFileScrty egovFileScrty;
	
	@Override
	public List<MailGeneralVO> getMailGeneral(String userId) throws Exception {
		if (config.getProperty("config.USE_JGwRepository").equals("YES")) {
            return getMailGeneralForJMocha(userId);
        } else {
            return getMailGeneralForLocal(userId);
        }
	}
	
	public List<MailGeneralVO> getMailGeneralForJMocha(String userId) throws Exception {
		List<MailGeneralVO> mailGeneralList = new ArrayList<MailGeneralVO>();
		
		String inputParams = "userId=" + URLEncoder.encode(userId + "@" + config.getProperty("config.DomainName"), "UTF-8");
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
	
	public List<MailGeneralVO> getMailGeneralForLocal(String userId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();		
		map.put("v_PUSERID", userId);
		
		List<MailGeneralVO> mailGeneralList = ezEmailDAO.getMailGeneral(map);
		
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
	public void setMailGeneral(String userId, MailGeneralVO mailGeneral, String mode) throws Exception {
		if (config.getProperty("config.USE_JGwRepository").equals("YES")) {
            setMailGeneralForJMocha(userId, mailGeneral, mode);
        } else {
            setMailGeneralForLocal(userId, mailGeneral, mode);
        }
	}
	
	public void setMailGeneralForJMocha(String userId, MailGeneralVO mailGeneral, String mode) throws Exception {
		String userIdParam = "userId=" + URLEncoder.encode(userId + "@" + config.getProperty("config.DomainName"), "UTF-8");
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
	
	public void setMailGeneralForLocal(String userId, MailGeneralVO mailGeneral, String mode) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_PUSERID", userId);
		map.put("v_PLISTCNT", mailGeneral.getListCount());
		map.put("v_PREFRESHINTERVAL", mailGeneral.getRefreshInterval());
		map.put("v_PKEEPDELETELENGTH", mailGeneral.getKeepDeleteLength());
		map.put("v_PREVIEWMODE", mailGeneral.getPreviewMode());
		map.put("v_PREVIEWWLIST", mailGeneral.getPreviewWList());
		map.put("v_PREVIEWWCONTENT", mailGeneral.getPreviewWContent());
		map.put("v_PREVIEWHLIST", mailGeneral.getPreviewHList());
		map.put("v_PREVIEWHCONTENT", mailGeneral.getPreviewHContent());
		
		if (mode != null && mode.equals("ALL")) {
			map.put("v_MAILSENDERNM", mailGeneral.getMailSenderNm());
			ezEmailDAO.setMailGeneral2(map);
		} else {
			ezEmailDAO.setMailGeneral(map);		
		}
	}
	
	@Override
	public MailSignatureVO getMailSignature(String pUserID) throws Exception {
		if (config.getProperty("config.USE_JGwRepository").equals("YES")) {
            return getMailSignatureForJMocha(pUserID);
        } else {
            return getMailSignatureForLocal(pUserID);
        }
	}

	public MailSignatureVO getMailSignatureForJMocha(String pUserID) throws Exception {
		MailSignatureVO mailSignatureVO = null;
		
		String inputParams = "userId=" + URLEncoder.encode(pUserID + "@" + config.getProperty("config.DomainName"), "UTF-8");
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
	
	public MailSignatureVO getMailSignatureForLocal(String pUserID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_USERID", pUserID);
		
		return ezEmailDAO.getMailSignature(map);
	}
	
	@Override
	public void setMailSignature(String pUserID, String pUseFlag, String pContent1, String pContent2, String pContent3)
			throws Exception {
		if (config.getProperty("config.USE_JGwRepository").equals("YES")) {
			setMailSignatureForJMocha(pUserID, pUseFlag, pContent1, pContent2, pContent3);
        } else {
        	setMailSignatureForLocal(pUserID, pUseFlag, pContent1, pContent2, pContent3);
        }
	}
	
	public void setMailSignatureForJMocha(String pUserID, String pUseFlag, String pContent1, String pContent2, String pContent3)
			throws Exception {
		String userIdParam = "userId=" + URLEncoder.encode(pUserID + "@" + config.getProperty("config.DomainName"), "UTF-8");
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
	
	public void setMailSignatureForLocal(String pUserID, String pUseFlag, String pContent1, String pContent2, String pContent3)
			throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_USERID", pUserID);
		map.put("v_USEFLAG", pUseFlag);
		map.put("v_CONTENT1", pContent1);
		map.put("v_CONTENT2", pContent2);
		map.put("v_CONTENT3", pContent3);
		
		ezEmailDAO.setMailSignature(map);
	}
	
	@Override
	public MailColorVO getMailColor(int tenantId) throws Exception {
		if (config.getProperty("config.USE_JGwRepository").equals("YES")) {
            return getMailColorForJMocha(tenantId);
        } else {
            return getMailColorForLocal();
        }
	}
	
	public MailColorVO getMailColorForJMocha(int tenantId) throws Exception {
		MailColorVO vo = new MailColorVO();
		
		String inputParams = "tenantId=" + URLEncoder.encode(String.valueOf(tenantId), "UTF-8");
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
	
	public MailColorVO getMailColorForLocal() throws Exception {
		return ezEmailDAO.getMailColor();
	}
	
	@Override
	public void setMailColor(int pTenantId, String pImportanceColor, String pInColor, String pOutColor) throws Exception {
		if (config.getProperty("config.USE_JGwRepository").equals("YES")) {
			setMailColorForJMocha(pTenantId, pImportanceColor, pInColor, pOutColor);
        } else {
        	setMailColorForLocal(pImportanceColor, pInColor, pOutColor);
        }
	}
	
	public void setMailColorForJMocha(int pTenantId, String pImportanceColor, String pInColor, String pOutColor) throws Exception {
		String tenantIdParam = "tenantId=" + URLEncoder.encode(String.valueOf(pTenantId), "UTF-8");
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
	
	public void setMailColorForLocal(String pImportanceColor, String pInColor, String pOutColor) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_IMPORTANCE", pImportanceColor);
		map.put("v_INMAIL", pInColor);
		map.put("v_OUTMAIL", pOutColor);
		
		ezEmailDAO.setMailColor(map);
	}
	
	@Override
	public List<MailDeleteVO> getMailDelete(String userId) throws Exception {
		if (config.getProperty("config.USE_JGwRepository").equals("YES")) {
            return getMailDeleteForJMocha(userId);
        } else {
            return getMailDeleteForLocal(userId);
        }
	}
	
	public List<MailDeleteVO> getMailDeleteForJMocha(String userId) throws Exception {
		List<MailDeleteVO> list = new ArrayList<MailDeleteVO>();
		
		String inputParams = "userId=" + URLEncoder.encode(userId + "@" + config.getProperty("config.DomainName"), "UTF-8");
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
	
	public List<MailDeleteVO> getMailDeleteForLocal(String userId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_PUSERID", userId);
		
		return ezEmailDAO.getMailDelete(map);
	}
	
	@Override
	public void setMailDelete(String pUserID, String pPath, int pExpireTime, int pDeleteUnread, String pFolderName)
			throws Exception {
		if (config.getProperty("config.USE_JGwRepository").equals("YES")) {
			setMailDeleteForJMocha(pUserID, pPath, pExpireTime, pDeleteUnread, pFolderName);
        } else {
        	setMailDeleteForLocal(pUserID, pPath, pExpireTime, pDeleteUnread, pFolderName);
        }
	}
	
	public void setMailDeleteForJMocha(String pUserID, String pPath, int pExpireTime, int pDeleteUnread, String pFolderName)
			throws Exception {
		String userIdParam = "userId=" + URLEncoder.encode(pUserID + "@" + config.getProperty("config.DomainName"), "UTF-8");
		String folderPathParam = "folderPath=" + URLEncoder.encode(pPath, "UTF-8");
		String expireTimeParam = "expireTime=" + URLEncoder.encode(String.valueOf(pExpireTime), "UTF-8");
		String deleteUnreadParam = "deleteUnread=" + URLEncoder.encode(String.valueOf(pDeleteUnread), "UTF-8");
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
	
	public void setMailDeleteForLocal(String pUserID, String pPath, int pExpireTime, int pDeleteUnread, String pFolderName)
			throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_PUSERID", pUserID);
		map.put("v_PPATH", pPath);
		map.put("v_PEXPIRETIME", pExpireTime);
		map.put("v_PDELETEUNREAD", pDeleteUnread);
		map.put("v_PFOLDERNAME", pFolderName);
		
		ezEmailDAO.setMailDelete(map);
	}
	
	@Override
	public void deleteMailDelete(String pUserID, String pFolderPath, int pItemSeq) throws Exception {
		if (config.getProperty("config.USE_JGwRepository").equals("YES")) {
			deleteMailDeleteForJMocha(pUserID, pFolderPath);
        } else {
        	deleteMailDeleteForLocal(pUserID, pItemSeq);
        }
	}
	
	public void deleteMailDeleteForJMocha(String pUserID, String pFolderPath) throws Exception {
		if (pFolderPath == null || pFolderPath.trim().equals("")) {
			logger.error("Cannot delete autoDelete. folderPath is empty.");
			throw new Exception("Cannot delete autoDelete. folderPath is empty.");
		}
		
		String userIdParam = "userId=" + URLEncoder.encode(pUserID + "@" + config.getProperty("config.DomainName"), "UTF-8");
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
	
	public void deleteMailDeleteForLocal(String pUserID, int pItemSeq) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_PUSERID", pUserID);
		map.put("v_PITEMSEQ", pItemSeq);
		
		ezEmailDAO.deleteMailDelete(map);
	}
	
	@Override
	public List<MailDeleteVO> getMailDeleteList() throws Exception {
		if (config.getProperty("config.USE_JGwRepository").equals("YES")) {
            return getMailDeleteListForJMocha();
        } else {
            return getMailDeleteListForLocal();
        }
	}
	
	public List<MailDeleteVO> getMailDeleteListForJMocha() throws Exception {
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
        		
        		mailDeleteVO.setUserId((String)obj.get("userId"));
        		mailDeleteVO.setPath((String)obj.get("folderPath"));
        		mailDeleteVO.setExpireTime(((Long)obj.get("expireTime")).intValue());
        		mailDeleteVO.setDeleteUnread((String)obj.get("deleteUnread"));
        		mailDeleteVO.setFolderName((String)obj.get("folderName"));
        		
        		list.add(mailDeleteVO);
        	}
        }
        
        return list;
	}
	
	public List<MailDeleteVO> getMailDeleteListForLocal() throws Exception {
		return ezEmailDAO.getMailDeleteList();
	}
	
	@Override
	public List<MailReservationVO> getMailReserved(String pEmail) throws Exception {
		if (config.getProperty("config.USE_JGwRepository").equals("YES")) {
            return getMailReservedForJMocha(pEmail);
        } else {
            return getMailReservedForLocal(pEmail);
        }
	}
	
	public List<MailReservationVO> getMailReservedForJMocha(String pEmail) throws Exception {
		List<MailReservationVO> list = new ArrayList<MailReservationVO>();
		
		String inputParams = "userId=" + URLEncoder.encode(pEmail, "UTF-8");
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
	
	public List<MailReservationVO> getMailReservedForLocal(String pEmail) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_PURL", pEmail);
		
		return ezEmailDAO.getMailReserved(map);
	}
	
	@Override
	public List<MailReservationVO> getMailReserved2() throws Exception {
		if (config.getProperty("config.USE_JGwRepository").equals("YES")) {
            return getMailReserved2ForJMocha();
        } else {
            return getMailReserved2Forlocal();
        }
	}
	
	public List<MailReservationVO> getMailReserved2ForJMocha() throws Exception {
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
	
	public List<MailReservationVO> getMailReserved2Forlocal() throws Exception {
		return ezEmailDAO.getMailReserved2();
	}
	
	@Override
	public String setMailReserved(String pMessageId, String pSubject, String pSendDate, String pConnUrl, String isReserve)
			throws Exception {
		if (config.getProperty("config.USE_JGwRepository").equals("YES")) {
			return setMailReservedForJMocha(pMessageId, pSubject, pSendDate, pConnUrl, isReserve);
        } else {
        	return setMailReservedForLocal(pMessageId, pSubject, pSendDate, pConnUrl, isReserve);
        }
	}
	
	public String setMailReservedForJMocha(String pMessageId, String pSubject, String pSendDate, String pConnUrl, String isReserve)
			throws Exception {
		if (!isReserve.equalsIgnoreCase("YES")) {
			pMessageId = UUID.randomUUID().toString();
		}
		
		String messageIdParam = "messageId=" + URLEncoder.encode(pMessageId, "UTF-8");
		String userIdParam = "userId=" + URLEncoder.encode(pConnUrl, "UTF-8");
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
	
	public String setMailReservedForLocal(String pMessageId, String pSubject, String pSendDate, String pConnUrl, String isReserve)
			throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		if (isReserve.equalsIgnoreCase("YES")) {
			map.put("v_PMESSAGEID", pMessageId);
			map.put("v_PSUBJECT", pSubject);
			map.put("v_PSENDDATE", pSendDate);
			
			ezEmailDAO.updateReservedMail(map);
		} else {
			pMessageId = UUID.randomUUID().toString();
			map.put("v_PMESSAGEID", pMessageId);
			map.put("v_PSUBJECT", pSubject);
			map.put("v_PSENDDATE", pSendDate);
			map.put("v_PCONNURL", pConnUrl);
			
			ezEmailDAO.setMailReserved(map);
		}
		
		return pMessageId;
	}
	
	@Override
	public void deleteMailReserved(String pMessageId) throws Exception {
		if (config.getProperty("config.USE_JGwRepository").equals("YES")) {
			deleteMailReservedForJMocha(pMessageId);
        } else {
        	deleteMailReservedForLocal(pMessageId);
        }
	}
	
	public void deleteMailReservedForJMocha(String pMessageId) throws Exception {
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
	
	public void deleteMailReservedForLocal(String pMessageId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_PMESSAGEID", pMessageId);
		
		ezEmailDAO.deleteMailReserved(map);
	}
	
	@Override
	public String getMailReservedTime(String pMessageId) throws Exception {
		if (config.getProperty("config.USE_JGwRepository").equals("YES")) {
            return getMailReservedTimeForJMocha(pMessageId);
        } else {
            return getMailReservedTimeForLocal(pMessageId);
        }
	}
	
	public String getMailReservedTimeForJMocha(String pMessageId) throws Exception {
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
	
	public String getMailReservedTimeForLocal(String pMessageId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_MESSAGEID", pMessageId);
		
		return ezEmailDAO.getMailReservedTime(map);
	}
	
	@Override
	public List<MailReadVO> getMailReadList(String pUserId, String pMessageId, String pMessageId2)
			throws Exception {
		if (config.getProperty("config.USE_JGwRepository").equals("YES")) {
            return getMailReadListForJMocha(pUserId, pMessageId);
        } else {
            return getMailReadListForLocal(pUserId, pMessageId, pMessageId2);
        }
	}
	
	public List<MailReadVO> getMailReadListForJMocha(String pUserId, String pMessageId) throws Exception {
		List<MailReadVO> readList = new ArrayList<MailReadVO>();
		
		String userIdParam = "userId=" + URLEncoder.encode(pUserId, "UTF-8");
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
	
	public List<MailReadVO> getMailReadListForLocal(String pUserId, String pMessageId, String pMessageId2)
			throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_PUSERID", pUserId);
		map.put("v_PMESSAGEID", pMessageId);
		map.put("v_PMESSAGEID2", pMessageId2);
		
		return ezEmailDAO.getMailReadList(map);
	}
	
	@Override
	public List<MailCancelVO> getMailCancelList(String pMessage) throws Exception {
		if (config.getProperty("config.USE_JGwRepository").equals("YES")) {
            return getMailCancelListForJMocha(pMessage);
        } else {
            return getMailCancelListForLocal(pMessage);
        }
	}
	
	public List<MailCancelVO> getMailCancelListForJMocha(String pMessage) throws Exception {
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
	
	public List<MailCancelVO> getMailCancelListForLocal(String pMessage) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_PMESSAGE", pMessage);
		
		return ezEmailDAO.getMailCancelList(map);
	}
	
	@Override
	public void setMailCancelSend(String pMessageId, String pUserEmail, String pSubject, String pCreateDate, String pLocalServerName, List<String> pInnerAddresses) throws Exception {
		if (config.getProperty("config.USE_JGwRepository").equals("YES")) {
            setMailCancelSendForJMocha(pMessageId, pUserEmail, pSubject, pCreateDate, pLocalServerName, pInnerAddresses);
        } else {
            setMailCancelSendForLocal(pMessageId, pUserEmail, pSubject, pCreateDate, pLocalServerName, pInnerAddresses);
        }
	}
	
	public void setMailCancelSendForJMocha(String pMessageId, String pUserEmail, String pSubject, String pCreateDate, String pLocalServerName, List<String> pInnerAddresses) throws Exception {
		String messageIdParam = "messageId=" + URLEncoder.encode(pMessageId, "UTF-8");
		String senderEmailParam = "senderEmail=" + URLEncoder.encode(pUserEmail, "UTF-8");
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

	public void setMailCancelSendForLocal(String pMessageId, String pUserEmail, String pSubject, String pCreateDate, 
			String pLocalServerName, List<String> pInnerAddresses) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_SENDEREMAIL", pUserEmail);
		map.put("v_SUBJECT", pSubject);
		map.put("v_RECDATE", pCreateDate);
		map.put("v_MESSAGEID", pMessageId);
		map.put("v_SERVERNAME", pLocalServerName);
		
		String recallIdx = ezEmailDAO.checkDoubleMailReceive(map);
		
		logger.debug("recallIdx = " + recallIdx);
		
		if (recallIdx == null) {
			map = new HashMap<String, Object>();
			
			map.put("v_SENDEREMAIL", pUserEmail);
			map.put("v_SUBJECT", pSubject);
			map.put("v_RECDATE", pCreateDate);
			map.put("v_MESSAGEID", pMessageId);
			map.put("v_SERVERNAME", pLocalServerName);
			map.put("v_RECALLKEY", "");
			
			recallIdx =  ezEmailDAO.insertMailReceiveInfo(map);
		}
		
		for (String address : pInnerAddresses) {
			map = new HashMap<String, Object>();
			
			map.put("v_NUM", Integer.parseInt(recallIdx));
			map.put("v_RECEIVEID", address);
			
			ezEmailDAO.insertMailReceiveDetailInfo(map);
		}
		
		//회수처리 함수 호출(비동기)
		ezEmailAsync.cancelMailDelete(recallIdx);
	}

	@Override
	public String getMailReceiveMessageId(String pNum) throws Exception {
		if (config.getProperty("config.USE_JGwRepository").equals("YES")) {
			return getMailReceiveMessageIdForJMocha(pNum);
        } else {
        	return getMailReceiveMessageIdForLocal(pNum);
        }
	}
	
	public String getMailReceiveMessageIdForJMocha(String pNum) throws Exception {
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
	
	public String getMailReceiveMessageIdForLocal(String pNum) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_NUM", pNum);
		
		return ezEmailDAO.getMailReceiveMessageId(map);
	}
	
	@Override
	public void updateMailReceiveDetailInfo(String pNum, List<String[]> receiveDetailList) throws Exception {
		if (config.getProperty("config.USE_JGwRepository").equals("YES")) {
			updateMailReceiveDetailInfoForJMocha(pNum, receiveDetailList);
        } else {
        	updateMailReceiveDetailInfoForLocal(pNum, receiveDetailList);
        }
	}
	
	public void updateMailReceiveDetailInfoForJMocha(String pNum, List<String[]> receiveDetailList) throws Exception {
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
	
	public void updateMailReceiveDetailInfoForLocal(String pNum, List<String[]> receiveDetailList) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_NUM", pNum);
		
		for (String[] receiveDetail : receiveDetailList) {
			map.put("v_EMAIL", receiveDetail[0]);
			map.put("v_CODE", receiveDetail[1]);
		}
		
		ezEmailDAO.updateMailReceiveDetailInfo(map);
	}
	
	@Override
	public List<String> getMailReceiveAddress(String pNum) throws Exception {
		if (config.getProperty("config.USE_JGwRepository").equals("YES")) {
			return getMailReceiveAddressForJMocah(pNum);
        } else {
        	return getMailReceiveAddressForLocal(pNum);
        }
	}
	
	public List<String> getMailReceiveAddressForJMocah(String pNum) throws Exception {
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
	
	public List<String> getMailReceiveAddressForLocal(String pNum) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_NUM", pNum);
		
		return ezEmailDAO.getMailReceiveAddress(map);
	}
	
	@Override
	public List<MailPOP3VO> getMailPOP3(String pUserId) throws Exception {
		if (config.getProperty("config.USE_JGwRepository").equals("YES")) {
            return getMailPOP3ForJMocha(pUserId);
        } else {
            return getMailPOP3ForLocal(pUserId);
        }
	}
	
	public List<MailPOP3VO> getMailPOP3ForJMocha(String pUserId) throws Exception {
		List<MailPOP3VO> list = new ArrayList<MailPOP3VO>();
		
		String inputParams = "userId=" + URLEncoder.encode(pUserId + "@" + config.getProperty("config.DomainName"), "UTF-8");
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
	
	public List<MailPOP3VO> getMailPOP3ForLocal(String pUserId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_PUSERID", pUserId);
		
		return ezEmailDAO.getMailPOP3(map);
	}
	
	@Override
	public void savePop3(String pUserId, String pRet) throws Exception {
		if (config.getProperty("config.USE_JGwRepository").equals("YES")) {
			savePop3ForJMocha(pUserId, pRet);
        } else {
        	savePop3ForLocal(pUserId, pRet);
        }
	}
	
	public void savePop3ForJMocha(String pUserId, String pRet) throws Exception {
		String inputParams = "userId=" + URLEncoder.encode(pUserId + "@" + config.getProperty("config.DomainName"), "UTF-8");
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
	
	public void savePop3ForLocal(String pUserId, String pRet) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PUSERID", pUserId);
		
		//DB에서 해당 user의 pop3 정보들을 지우기 전에 가져온다.
		List<MailPOP3VO> pop3OldVoList = ezEmailDAO.getMailPOP3(map);
		
		//pop3OldVoList와 같은 list를 하나 더 만든다.
		//사용하지 않는 pop3 정보로 가져온 DB에 저장된 메일들의 정보를 삭제하기 위함이다.
		List<MailPOP3VO> pop3OldVoToDeleteList = new ArrayList<MailPOP3VO>();
		pop3OldVoToDeleteList.addAll(pop3OldVoList);
		
		map = new HashMap<String, Object>();
		map.put("v_USERID", pUserId);
		
		//DB에서 해당 user의 pop3 정보들을 지운다.
		ezEmailDAO.deletePop3ByUserId(map);
		
		Document doc = commonUtil.convertStringToDocument(pRet);
		NodeList rows = doc.getElementsByTagName("ROW");
		
		String prm = egovFileScrty.getPrm();
		String pre = egovFileScrty.getPre();
		PrivateKey pk = EgovFileScrty.getPrivateKey(prm, pre);
		
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

			map = new HashMap<String, Object>();
			map.put("v_USERID", pUserId);
			map.put("v_POP3SERVER", server);
			map.put("v_POP3PORTNO", port);
			map.put("v_POP3USERID", id);
			map.put("v_POP3PW", pw);
			map.put("v_SAVETO", saveTo);
			map.put("v_DELETEYN", deleteYN);
			map.put("v_POP3SSLYN", useSsl);
			map.put("v_SAVETOFOLDER", saveToFolder);
			
			for (MailPOP3VO vo : pop3OldVoList) {
				//DB에 원래 들어있던 pop3 정보인지 체크한다.
				if (vo.getPop3Server().toLowerCase().equals(server.toLowerCase())
						&& EgovFileScrty.decryptRsa(pk, vo.getPop3UserId()).equals(EgovFileScrty.decryptRsa(pk, id))) {
					
					//id와 vo.getPop3UserId()가 복호화했을 때에는 같지만 암호화 된 상태에서는 두 값이 다르기 때문에, 두 값을 비교할 때에는 복호화해서 비교해야 한다.
					//DB에 넣을 때에는 원래 DB에 들어있던 vo.getPop3UserId() 값을 넣는다.
					map.put("v_POP3USERID", vo.getPop3UserId());
					
					//원래 있던 pop3 정보로 가져온 메일들의 정보는 지울 필요가 없기 때문에, pop3OldVoToDeleteList에서 뺀다.
					pop3OldVoToDeleteList.remove(vo);
					
					break;
				}
			}
			
			ezEmailDAO.insertPop3(map);
		}

		for (MailPOP3VO vo : pop3OldVoToDeleteList) {
			map = new HashMap<String, Object>();
			map.put("v_USERID", pUserId);
			map.put("v_POP3SERVER", vo.getPop3Server());
			map.put("v_POP3USERID", vo.getPop3UserId());
			
			ezEmailDAO.deletePop3List(map);
		}
			
	}

	@Override
	public void setMailPOP3List(String pUserId, String pPop3Server, String pPop3UserId, List<String> pMessageIds,
			String pPop3DupMsg) throws Exception {
		if (config.getProperty("config.USE_JGwRepository").equals("YES")) {
			setMailPOP3ListForJMocha(pUserId, pPop3Server, pPop3UserId, pMessageIds);
        } else {
        	setMailPOP3ListForLocal(pUserId, pPop3Server, pPop3UserId, pMessageIds, pPop3DupMsg);
        }
	}
	
	public void setMailPOP3ListForJMocha(String pUserId, String pPop3Server, String pPop3UserId, List<String> pMessageIds) throws Exception {
		StringBuilder inputParams = new StringBuilder();
		inputParams.append("userId=" + URLEncoder.encode(pUserId + "@" + config.getProperty("config.DomainName"), "UTF-8"));
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
	
	public void setMailPOP3ListForLocal(String pUserId, String pPop3Server, String pPop3UserId, List<String> pMessageIds,
			String pPop3DupMsg) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PUSERID", pUserId);
		map.put("v_PPOP3SERVER", pPop3Server);
		map.put("v_PPOP3USERID", pPop3UserId);
		
		map.put("v_PPOP3DUPMSG", pPop3DupMsg);
		
		for (String messageId : pMessageIds) {
			map.put("v_PMESSAGEID", messageId);
			ezEmailDAO.setMailPOP3(map);
		}
	}
	
	@Override
	public List<String> getMailPOP3List(String pUserId, String pPop3Server, String pPop3UserId) throws Exception {
		if (config.getProperty("config.USE_JGwRepository").equals("YES")) {
            return getMailPOP3ListForJMocha(pUserId, pPop3Server, pPop3UserId);
        } else {
            return getMailPOP3ListForLocal(pUserId, pPop3Server, pPop3UserId);
        }
	}
	
	public List<String> getMailPOP3ListForJMocha(String pUserId, String pPop3Server, String pPop3UserId) throws Exception {
		List<String> list = new ArrayList<String>();
		
		String userIdParam = "userId=" + URLEncoder.encode(pUserId + "@" + config.getProperty("config.DomainName"), "UTF-8");
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
	
	public List<String> getMailPOP3ListForLocal(String pUserId, String pPop3Server, String pPop3UserId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_PUSERID", pUserId);
		map.put("v_PPOP3SERVER", pPop3Server);
		map.put("v_PPOP3USERID", pPop3UserId);
		
		return ezEmailDAO.getMailPOP3List(map);
	}
	
}
