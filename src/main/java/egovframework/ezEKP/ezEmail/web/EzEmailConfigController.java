package egovframework.ezEKP.ezEmail.web;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.PrintWriter;
import java.net.URLEncoder;
import java.security.PrivateKey;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;
import java.util.Set;
import java.util.TimeZone;
import java.util.UUID;

import javax.annotation.Resource;
import javax.imageio.ImageIO;
import javax.mail.FetchProfile;
import javax.mail.Flags;
import javax.mail.Folder;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.UIDFolder;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.search.SearchTerm;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import com.sun.mail.pop3.POP3Folder;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.logic.IMAPAccess;
import egovframework.ezEKP.ezEmail.logic.POP3Access;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezEmail.util.EzEmailUtil;
import egovframework.ezEKP.ezEmail.vo.MailDeleteVO;
import egovframework.ezEKP.ezEmail.vo.MailGeneralVO;
import egovframework.ezEKP.ezEmail.vo.MailPOP3VO;
import egovframework.ezEKP.ezEmail.vo.MailSignatureVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;
import egovframework.rte.fdl.string.EgovStringUtil;

/**
 * @Description [Controller] 메일 환경설정
 * @author 오픈솔루션팀 이효민
 * @Modification Information
 * 
 *    수정일        수정자         수정내용
 *    ----------    ------    -------------------
 *    2016.05.10    이효민    신규작성
 *
 * @see
 */

@Controller
public class EzEmailConfigController extends EgovFileMngUtil {

	private static final Logger logger = LoggerFactory.getLogger(EzEmailConfigController.class);

	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;

	@Resource(name = "egovMessageSource")
	private EgovMessageSource egovMessageSource;

	@Autowired
	private EzEmailService ezEmailService;
	
	@Resource(name = "EzCommonService")
    private EzCommonService ezCommonService;
	
	@Autowired
	private EzEmailUtil ezEmailUtil;

	@Resource(name="crypto") 
	private EgovFileScrty egovFileScrty;
	
	/**
	 * 메일 기본 환경설정 화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailConfig.do")
	public String mailConfig(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		logger.debug("mailConfig started.");
		
		String userEditor = "";
		String userIE11Browser = "";
		String noneActiveX = "YES";
		String blockedSenders = "";

		if ((request.getHeader("User-Agent").contains("rv:11") || request.getHeader("User-Agent").contains("Trident/7.0"))
				&& config.getProperty("config.IE11EDITOR").equals("CK")) {
			userIE11Browser = "CK";
		}

		userEditor = config.getProperty("config.EDITOR");
		blockedSenders = config.getProperty("config.BlockedSenders");

		model.addAttribute("userEditor", userEditor);
		model.addAttribute("userIE11Browser", userIE11Browser);
		model.addAttribute("noneActiveX", noneActiveX);
		model.addAttribute("blockedSenders", blockedSenders);
		
		logger.debug("mailConfig ended.");
		
		return "ezEmail/mailConfig";
	}

	/**
	 * 메일 기본 환경설정 내부 화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailGeneral.do")
	public String mailGeneral(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		logger.debug("mailGeneral started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		MailGeneralVO mailGeneralVO = ezEmailService.getMailGeneral(userInfo.getTenantId(), userInfo.getId()).get(0);

		String listCount = mailGeneralVO.getListCount() == null ? "" : mailGeneralVO.getListCount();
		String previewMode = mailGeneralVO.getPreviewMode() == null ? "OFF" : mailGeneralVO.getPreviewMode();
		String previewHListSize = mailGeneralVO.getPreviewHList() == null ? "50" : mailGeneralVO.getPreviewHList();
		String previewHContentSize = mailGeneralVO.getPreviewHContent() == null ? "50" : mailGeneralVO.getPreviewHContent();
		String previewWListSize = mailGeneralVO.getPreviewWList() == null ? "50" : mailGeneralVO.getPreviewWList();
		String previewWContentSize = mailGeneralVO.getPreviewWContent() == null ? "50" : mailGeneralVO.getPreviewWContent();
		String refreshInterval = mailGeneralVO.getRefreshInterval() == null ? "" : mailGeneralVO.getRefreshInterval();
		String keepDeleteLength = mailGeneralVO.getKeepDeleteLength() == null ? "" : mailGeneralVO.getKeepDeleteLength();
		String mailSendObject = "";

		if (keepDeleteLength.equals("30")) {
			keepDeleteLength = "60";
		}
		
		String pMailSenderNM = EgovStringUtil.isEmpty(mailGeneralVO.getMailSenderNm()) ? userInfo.getDisplayName2() : mailGeneralVO.getMailSenderNm();
		
		if (pMailSenderNM == null) {
			pMailSenderNM = "";
		}
		
		String[] senderList = pMailSenderNM.split("\\|!\\-@\\-!\\|");
		for (int i=0; i<senderList.length; i++) {
			if (i == 0) {
				mailSendObject += "<option value='" + senderList[i] + "' selected>" + senderList[i] + "</option>";
			} else {
				mailSendObject += "<option value='" + senderList[i] + "'>" + senderList[i] + "</option>";
			}
		}
		
		logger.debug("listCount=" + listCount + ",previewMode=" + previewMode  + ",previewHListSize=" + previewHListSize
				 + ",previewHContentSize=" + previewHContentSize + ",previewWListSize=" + previewWListSize + ",previewWContentSize=" + previewWContentSize
				 + ",refreshInterval=" + refreshInterval + ",keepDeleteLength=" + keepDeleteLength + ",mailSendObject=" + mailSendObject);
		
		model.addAttribute("listCount", listCount);
		model.addAttribute("previewMode", previewMode);
		model.addAttribute("previewHListSize", previewHListSize);
		model.addAttribute("previewHContentSize", previewHContentSize);
		model.addAttribute("previewWListSize", previewWListSize);
		model.addAttribute("previewWContentSize", previewWContentSize);
		model.addAttribute("refreshInterval", refreshInterval);
		model.addAttribute("keepDeleteLength", keepDeleteLength);
		model.addAttribute("mailSendObject", mailSendObject);
		
		logger.debug("mailGeneral ended.");
		
		return "ezEmail/mailGeneral";
	}

	/**
	 * 메일 환경 설정 저장 함수
	 */
	@RequestMapping(value="/ezEmail/mailGeneralSave.do", method=RequestMethod.POST,
			produces="text/xml; charset=utf-8")
	@ResponseBody
	public String mailGeneralSave(@CookieValue("loginCookie") String loginCookie,
			@RequestParam(value = "MODE", required = false) String mode,
			@RequestBody String bodyData, 
			Locale locale, 
			Model model) throws Exception {
		logger.debug("mailGeneralSave started.");		
		logger.debug("bodyData=" + bodyData);

		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		Document doc = commonUtil.convertStringToDocument(bodyData);

		String listCount = doc.getElementsByTagName("LISTCOUNT").item(0).getTextContent();
		String refreshInterval = doc.getElementsByTagName("REFRESHINTERVAL").item(0).getTextContent();
		String keepDeleteLength = doc.getElementsByTagName("KEEPDELETELENGTH").item(0).getTextContent();
		String previewMode = doc.getElementsByTagName("PREVIEWMODE").item(0).getTextContent();
		String previewWList = doc.getElementsByTagName("PREVIEWWLIST").item(0).getTextContent();
		String previewWContent = doc.getElementsByTagName("PREVIEWWCONTENT").item(0).getTextContent();
		String previewHList = doc.getElementsByTagName("PREVIEWHLIST").item(0).getTextContent();
		String previewHContent = doc.getElementsByTagName("PREVIEWHCONTENT").item(0).getTextContent();
		String mailSenderNm = "";

		if (mode != null && mode.equals("ALL")) {
			mailSenderNm = doc.getElementsByTagName("MAILSENDERNM").item(0).getTextContent();
		}

		logger.debug("userId=" + userInfo.getId() + ",listCount=" + listCount + ",refreshInterval=" + refreshInterval 
				+ ",keepDeleteLength=" + keepDeleteLength + ",previewMode=" + previewMode 
				+ ",previewWList=" + previewWList + ",previewWContent=" + previewWContent
				+ ",previewHList=" + previewHList + ",previewHContent=" + previewHContent
				+ ",mailSenderNm=" + mailSenderNm
				);

		String rtnValue= "OK";

		try {
			MailGeneralVO mailGeneral = new MailGeneralVO();

			mailGeneral.setListCount(listCount);
			mailGeneral.setRefreshInterval(refreshInterval);
			mailGeneral.setKeepDeleteLength(keepDeleteLength);
			mailGeneral.setPreviewMode(previewMode);
			mailGeneral.setPreviewWList(previewWList);
			mailGeneral.setPreviewWContent(previewWContent);
			mailGeneral.setPreviewHList(previewHList);
			mailGeneral.setPreviewHContent(previewHContent);	
			mailGeneral.setMailSenderNm(mailSenderNm);
			
			ezEmailService.setMailGeneral(userInfo.getTenantId(), userInfo.getId(), mailGeneral, mode);
		} catch (Exception e) {
			rtnValue = "ERROR:" + e.getMessage();
		}

		logger.debug("rtnValue=" + rtnValue);
		logger.debug("mailGeneralSave ended.");
		
		return rtnValue;
	}

	/**
	 * 메일 기본 환경설정 내부 화면(용량) 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailGetUse.do", produces="text/xml; charset=utf-8")
	@ResponseBody
	public String mailGetUse(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		logger.debug("mailGetUse started.");
		
		// get user credentials
		List<String> userIdAndPassword = commonUtil.getUserIdAndPassword(loginCookie);
		String password = userIdAndPassword.get(1);		
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
		
		String userEmail = userInfo.getId() + "@" + domainName;
		logger.debug("userEmail=" + userEmail);
		
		IMAPAccess ia = null;
		
		int mailPercent = 0;
		String mailboxDetail = "";
		String mailboxQuotaStr = "";
		
		try {
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userEmail, password, egovMessageSource, locale);
					
			long[] storageUsageAndLimit = ia.getStorageUsageAndLimit();
			
			double mailboxUsage = storageUsageAndLimit[0]; // in KBs
			double mailboxQuota = storageUsageAndLimit[1]; // in KBs
			
			logger.debug("mailboxUsage=" + mailboxUsage + ",mailboxQuota=" + mailboxQuota);
			
			if (mailboxUsage < mailboxQuota) {
				mailPercent = (int)((mailboxUsage/mailboxQuota) * 100);
			}
			else {
				mailPercent = 100;
			}
			
			if (mailboxUsage >= 1024) {
				mailboxDetail = (int)(mailboxUsage/1024) + "MB";
			}
			else {
				mailboxDetail = (int)mailboxUsage + "KB";
			}
	
			if (mailboxQuota >= 1024*1024) {
				mailboxQuotaStr = String.format("%.2fG", mailboxQuota/(1024*1024));
			}
			else if (mailboxQuota >= 1024) {
				mailboxQuotaStr = (int)(mailboxQuota/1024) + "MB";
			}
			else {
				mailboxQuotaStr = (int)mailboxQuota + "KB";
			}
		
		} catch (Exception e) {
			logger.debug(e.getMessage());
			e.printStackTrace();
		} finally {
			if (ia != null) {
				ia.close();
			}
		}
		
		StringBuilder sb = new StringBuilder("<DATA>");
		sb.append("<ROW>");
		sb.append(String.format("<QUOTA>%s</QUOTA>", mailboxQuotaStr));
		sb.append(String.format("<DETAIL>%s</DETAIL>", mailboxDetail));
		sb.append(String.format("<PERCENT>%d</PERCENT>", mailPercent));
		sb.append(String.format("<BAR1>%d</BAR1>", mailPercent * 2));
		sb.append(String.format("<BAR2>%d</BAR2>", 211 - mailPercent * 2));
		sb.append("</ROW>");
		sb.append("</DATA>");
		
		logger.debug("returnData=" + sb.toString());
		logger.debug("mailGetUse ended.");
		
		return sb.toString();
	}


	/**
	 * 메일 자동 전달 설정 화면 표시 함수
	 */
	@RequestMapping(value="/ezEmail/mailAutoForward.do")
	public String mailAutoForward(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		logger.debug("mailAutoForward stated.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
		String userEmail = userInfo.getId() + "@" + domainName;

		String forwardAddress = getMailForwardAddress(userEmail);

		model.addAttribute("userId", userInfo.getId());
		model.addAttribute("userEmail", userEmail);
		model.addAttribute("forwardAddress", forwardAddress);
		
		logger.debug("userEmail=" + userEmail + ",forwardAddress=" + forwardAddress);
		logger.debug("mailAutoForward ended.");
		
		return "ezEmail/mailAutoForward";
	}

	/**
	 * 메일 자동 전달 설정 함수
	 */
	@RequestMapping(value="/ezEmail/mailAutoForwardSave.do",method=RequestMethod.POST,
			produces="text/xml; charset=utf-8")
	@ResponseBody	
	public String mailAutoForwardSave(@CookieValue("loginCookie") String loginCookie, @RequestBody String bodyData, Locale locale, Model model) throws Exception {
		logger.debug("mailAutoForwardSave started.");		
		logger.debug("bodyData=" + bodyData);

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
		String userEmail = userInfo.getId() + "@" + domainName;

		Document doc = commonUtil.convertStringToDocument(bodyData);

		String forwardAddress = doc.getElementsByTagName("ADDRESS").item(0).getTextContent();

		String strResult = "Error";

		if (!forwardAddress.equalsIgnoreCase(userEmail)) {
			try {				
				InternetAddress internetAddress = new InternetAddress(forwardAddress);
				strResult = setMailForwardAddress(userEmail, internetAddress.getAddress());
			} catch (AddressException e) {
			}
		}
		else {
			strResult = "MINE";
		}

		String returnData = "<RESULT>" + strResult + "</RESULT>";
		
		logger.debug("returnData=" + returnData);
		logger.debug("mailAutoForwardSave ended.");

		return returnData;		
	}

	/**
	 * 메일 자동 전달 설정 함수
	 */
	@RequestMapping(value="/ezEmail/mailAutoForwardDelete.do",method=RequestMethod.POST,
			produces="text/xml; charset=utf-8")
	@ResponseBody	
	public String mailAutoForwardDelete(@CookieValue("loginCookie") String loginCookie, @RequestBody String bodyData, Locale locale, Model model) throws Exception {
		logger.debug("mailAutoForwardDelete started.");		
		logger.debug("bodyData=" + bodyData);
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
		String userEmail = userInfo.getId() + "@" + domainName;

		String strResult = deleteMailForwardAddress(userEmail);

		String returnData = "<RESULT>" + strResult + "</RESULT>";
		
		logger.debug("returnData=" + returnData);
		logger.debug("mailAutoForwardDelete ended.");

		return returnData;		
	}	

	/**
	 * JMocha Gateway Server에 메일 자동 전달 설정 요청을 보내는 함수
	 */	
	private String setMailForwardAddress(String userEmail, String forwardAddress) {
		logger.debug("setMailForwardAddress started.");
		
		String result = "Error";

		try {
			String userIdParam = "userId=" + URLEncoder.encode(userEmail, "UTF-8");
			String forwardAddressParam = "forwardAddress=" + URLEncoder.encode(forwardAddress, "UTF-8");
			String inputParams = userIdParam + "&" + forwardAddressParam;

			logger.debug("inputParams=" + inputParams);

			String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaAccess/setMailForwardAddress";
			String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);

			logger.debug("response=" + response);

			if (response != null) {
				JSONParser jsonParser = new JSONParser();
				JSONObject responseObj = (JSONObject)jsonParser.parse(response);

				result = (String)responseObj.get("resultCode");		        		        				
			}						
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		logger.debug("result=" + result);
		logger.debug("setMailForwardAddress ended.");
		
		return result;
	}

	/**
	 * JMocha Gateway Server로부터 메일 자동 전달 설정을 읽는 함수
	 */		
	private String getMailForwardAddress(String userEmail) {
		logger.debug("getMailForwardAddress started.");
		
		String result = "";

		try {
			String userIdParam = "userId=" + URLEncoder.encode(userEmail, "UTF-8");
			String inputParams = userIdParam;

			logger.debug("inputParams=" + inputParams);

			String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaAccess/getMailForwardAddress";
			String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);

			logger.debug("response=" + response);

			if (response != null) {
				JSONParser jsonParser = new JSONParser();
				JSONObject responseObj = (JSONObject)jsonParser.parse(response);

				String resultCode = (String)responseObj.get("resultCode");

				if (resultCode.equalsIgnoreCase("OK")) {
					JSONArray resultArray = (JSONArray)responseObj.get("result");

					if (resultArray != null && resultArray.size() > 0) {
						result = (String)resultArray.get(0);
					}
				}				
			}						
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		logger.debug("result=" + result);
		logger.debug("getMailForwardAddress ended.");
		
		return result;
	}

	/**
	 * JMocha Gateway Server에 메일 자동 전달 삭제 요청을 보내는 함수
	 */	
	private String deleteMailForwardAddress(String userEmail) {
		logger.debug("deleteMailForwardAddress started.");
		
		String result = "Error";

		try {
			String inputParams = "userId=" + URLEncoder.encode(userEmail, "UTF-8");
			logger.debug("inputParams=" + inputParams);

			String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaAccess/deleteMailForwardAddress";			
			String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);

			logger.debug("response=" + response);

			if (response != null) {
				JSONParser jsonParser = new JSONParser();
				JSONObject responseObj = (JSONObject)jsonParser.parse(response);

				result = (String)responseObj.get("resultCode");		        		        				
			}						
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		logger.debug("result=" + result);
		logger.debug("deleteMailForwardAddress ended.");
		
		return result;
	}

	/**
	 * 메일 서명관리 화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailSignatureCK.do")
	public String mailSignatureCK(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		logger.debug("mailSignatureCK started.");
		
		String signState = "0";
		String signature1 = "";
		String signature2 = "";
		String signature3 = "";
		String serverName = "";
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		MailSignatureVO mailSignatureVO = ezEmailService.getMailSignature(userInfo.getTenantId(), userInfo.getId());

		if (mailSignatureVO != null) {
			signState = mailSignatureVO.getUseFlag().trim();
			signature1 = EgovStringUtil.isEmpty(mailSignatureVO.getContent1()) ? "<div>&nbsp;</div>" : mailSignatureVO.getContent1();
			signature2 = EgovStringUtil.isEmpty(mailSignatureVO.getContent2()) ? "<div>&nbsp;</div>" : mailSignatureVO.getContent2();
			signature3 = EgovStringUtil.isEmpty(mailSignatureVO.getContent3()) ? "<div>&nbsp;</div>" : mailSignatureVO.getContent3();
		} else {
			signature1 = "<div>&nbsp;</div>";
			signature2 = "<div>&nbsp;</div>";
			signature3 = "<div>&nbsp;</div>";

		}

		serverName = userInfo.getServerName();

		logger.debug("signState : " + signState);
		logger.debug("signature1 : " + signature1);
		logger.debug("signature2 : " + signature2);
		logger.debug("signature3 : " + signature3);
		logger.debug("serverName : " + serverName);
		logger.debug("userId : " + userInfo.getId());
		
		model.addAttribute("signState", signState);
		model.addAttribute("signature1", signature1);
		model.addAttribute("signature2", signature2);
		model.addAttribute("signature3", signature3);
		model.addAttribute("serverName", serverName);
		model.addAttribute("userId", userInfo.getId());
		
		logger.debug("mailSignatureCK ended.");
		
		return "ezEmail/mailSignatureCK";
	}

	/**
	 * 메일 서명관리 저장 실행 함수
	 */
	@RequestMapping(value="/ezEmail/mailSignSave.do")
	@ResponseBody
	public String mailSignSave(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, @RequestBody String bodyData) throws Exception{
		logger.debug("mailSignSave started.");
		logger.debug("bodyData=" + bodyData);
		
		String rtnValue = "OK";
		
		Document xmlDoc = commonUtil.convertStringToDocument(bodyData);
		Element root = xmlDoc.getDocumentElement();
		Node tempNode = null;
		
		String pUseFlag = "";
		String pContent1 = "";
		String pContent2 = "";
		String pContent3 = "";

		if (root.getElementsByTagName("USEFLAG") != null) {
			tempNode = root.getElementsByTagName("USEFLAG").item(0);
			if (tempNode != null && !tempNode.getTextContent().equals("")) {
				pUseFlag = tempNode.getTextContent();
			}
		}
		if (root.getElementsByTagName("CONTENT1") != null) {
			tempNode = root.getElementsByTagName("CONTENT1").item(0);
			if (tempNode != null && !tempNode.getTextContent().equals("")) {
				pContent1 = tempNode.getTextContent();
			}
		}
		if (root.getElementsByTagName("CONTENT2") != null) {
			tempNode = root.getElementsByTagName("CONTENT2").item(0);
			if (tempNode != null && !tempNode.getTextContent().equals("")) {
				pContent2 = tempNode.getTextContent();
			}
		}
		if (root.getElementsByTagName("CONTENT3") != null) {
			tempNode = root.getElementsByTagName("CONTENT3").item(0);
			if (tempNode != null && !tempNode.getTextContent().equals("")) {
				pContent3 = tempNode.getTextContent();
			}
		}
		
		try {
			LoginVO userInfo = commonUtil.userInfo(loginCookie);
			ezEmailService.setMailSignature(userInfo.getTenantId(), userInfo.getId(), pUseFlag, pContent1, pContent2, pContent3);
		} catch (Exception e) {
			rtnValue = "ERROR : " + e.getMessage();
			logger.error("rtnValue=" + rtnValue);
		}
		
		logger.debug("mailSignSave ended.");
		
		return rtnValue;
	}


	/**
	 * 메일 서명관리 ck에디터 이미지 업로드 호출 Method
	 */
	@RequestMapping(value = "/ezEmail/ckImageUpload.do")
	public String ckImageUpload() {
		return "ezEmail/ckImageUpload";
	}

	/**
	 * 메일 서명관리 ck에디터 업로드 화면 호출 Method
	 */
	@RequestMapping(value = "/ezEmail/ckUpload.do")
	public String ckUpload(@CookieValue("loginCookie") String loginCookie, MultipartHttpServletRequest request, Model model) throws Exception{
		logger.debug("ckUpload started.");
		
		MultipartFile multiFile = request.getFile("file1");
		String fileType = multiFile.getContentType().replace("\\", "/").split("/")[1];

		String realPath = commonUtil.getRealPath(request);
		String today = EgovDateUtil.getToday("");
		String fileName = UUID.randomUUID() + "." + fileType;
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String filePath = commonUtil.getUploadPath("upload_mail.SIGNIMGS", userInfo.getTenantId());
		filePath = filePath + commonUtil.separator + today;
		File file = new File(realPath + filePath);
		if (!file.exists()) {
			file.mkdirs();
		}

		int width = 0;
		int height = 0;

		writeUploadedFile(multiFile, fileName, realPath + filePath);

		File imageFile = new File(realPath + filePath + commonUtil.separator + fileName);			

		if (imageFile.exists()) {			
			BufferedImage bi = ImageIO.read(new File(realPath + filePath + commonUtil.separator + fileName));			    
			width = bi.getWidth();
			height = bi.getHeight();
		}
		
		String imgPath = (filePath + commonUtil.separator + fileName +  "|!|" + width + "|!|" + height).replace("\\", "/");
		
		model.addAttribute("imgPath", imgPath);
		
		logger.debug("imgPath=" + imgPath);
		logger.debug("ckUpload ended.");
		
		return "ezEmail/ckUpload";
	}


	/**
	 * 메일 자동삭제 화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailAutoDelete.do")
	public String mailAutoDelete(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		logger.debug("mailAutoDelete started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		List<MailDeleteVO> list = ezEmailService.getMailDelete(userInfo.getTenantId(), userInfo.getId());
		
		for (MailDeleteVO vo : list) {
			if (vo.getDeleteUnread().trim().equals("1")) {
				vo.setDeleteUnread("checked");
			}
		}
		
		model.addAttribute("list", list);
		
		logger.debug("mailAutoDelete ended.");
		
		return "ezEmail/mailAutoDelete";
	}

	/**
	 * 메일 편지함선택 화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailSelectFolder.do")
	public String mailSelectFolder(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		return "ezEmail/mailSelectFolder";
	}

	/**
	 * 메일 자동삭제 조건추가 실행 함수
	 */
	@RequestMapping(value="/ezEmail/mailAutoDeleteAdd.do")
	@ResponseBody
	public String mailAutoDeleteAdd(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request, HttpServletResponse response) throws Exception{
		logger.debug("mailAutoDeleteAdd started.");
		
		String rtnValue = "OK";
		
		String path = request.getParameter("path") == null ? "" : request.getParameter("path");
		String expireTimeStr = request.getParameter("expiretime") == null ? "" : request.getParameter("expiretime");
		int expireTime = expireTimeStr.equals("") ? 0 : Integer.parseInt(expireTimeStr);
		String deleteUnreadStr = request.getParameter("unread") == null ? "" : request.getParameter("unread");
		int deleteUnread = deleteUnreadStr.equals("") ? 0 : Integer.parseInt(deleteUnreadStr);
		String folderName = request.getParameter("foldername") == null ? "" : request.getParameter("foldername");
		
		logger.debug("path=" + path + ",expireTime=" + expireTime
				 + ",deleteUnread=" + deleteUnread + ",folderName=" + folderName);
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		ezEmailService.setMailDelete(userInfo.getTenantId(), userInfo.getId(), path, expireTime, deleteUnread, folderName);
		
		logger.debug("mailAutoDeleteAdd redirect '/ezEmail/mailAutoDelete.do'.");
		response.sendRedirect("/ezEmail/mailAutoDelete.do");
		
		return rtnValue;
	}

	/**
	 * 메일 자동삭제 조건추가 실행 함수
	 */
	@RequestMapping(value="/ezEmail/mailAutoDeleteDelete.do")
	@ResponseBody
	public String mailAutoDeleteDelete(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request, HttpServletResponse response) throws Exception{
		logger.debug("mailAutoDeleteDelete started.");
		
		String rtnValue = "OK";
		
		String folderPath = request.getParameter("folderPath");
		logger.debug("folderPath=" + folderPath);
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		ezEmailService.deleteMailDelete(userInfo.getTenantId(), userInfo.getId(), folderPath);
		
		logger.debug("mailAutoDeleteDelete redirect '/ezEmail/mailAutoDelete.do'.");
		
		response.sendRedirect("/ezEmail/mailAutoDelete.do");
		return rtnValue;
	}

	/**
	 * 메일 자동분류 화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailInboxRule.do")
	public String mailInboxRule(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		return "ezEmail/mailInboxRule";
	}

	/**
	 * 메일 자동분류 룰 추가 화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailNewInboxRule.do")
	public String mailNewInboxRule(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		return "ezEmail/mailNewInboxRule";
	}

	/**
	 * 메일 자동분류 룰 추가/수정 실행 함수
	 */
	@RequestMapping(value="/ezEmail/mailSetInboxRule.do", produces="text/xml; charset=utf-8")
	@ResponseBody
	public String mailSetInboxRule(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		logger.debug("mailSetInboxRule started.");
		
		String mode = request.getParameter("mode");

		StringBuilder sb = new StringBuilder();

		Document doc = commonUtil.convertRequestToDocument(request);
		String displayName = doc.getElementsByTagName("NAME").item(0).getTextContent();
		sb.append("displayName=" + URLEncoder.encode(displayName, "UTF-8"));
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
		String userId = userInfo.getId() + "@" + domainName;
		sb.append("&userId=" + URLEncoder.encode(userId, "UTF-8"));

		//condition
		Node condition = doc.getElementsByTagName("CONDITION").item(0);
		NodeList conRows = condition.getChildNodes();
		for (int i=0; i<conRows.getLength(); i++) {
			Node row = conRows.item(i);
			NodeList rowChilds = row.getChildNodes();

			for (int j=0; j<rowChilds.getLength(); j++) {
				if (rowChilds.item(j).getNodeName().equals("CONKIND")) {
					if (rowChilds.item(j).getTextContent().equals("null")) {
						break;
					}
					sb.append("&type=condition");
					sb.append("&kind=" + URLEncoder.encode(rowChilds.item(j).getTextContent().toLowerCase(), "UTF-8"));
				} else if (rowChilds.item(j).getNodeName().equals("CONVALUE")) {
					if (rowChilds.item(j).getTextContent().equals("null")) {
						sb.append("&value=");
					} else {
						sb.append("&value=" + URLEncoder.encode(rowChilds.item(j).getTextContent(), "UTF-8"));
					}
				}
			}
		}

		//action
		Node action = doc.getElementsByTagName("ACTION").item(0);
		NodeList actRows = action.getChildNodes();
		for (int i=0; i<actRows.getLength(); i++) {
			Node row = actRows.item(i);
			NodeList rowChilds = row.getChildNodes();

			for (int j=0; j<rowChilds.getLength(); j++) {
				if (rowChilds.item(j).getNodeName().equals("ACTKIND")) {
					if (rowChilds.item(j).getTextContent().equals("null")) {
						break;
					}
					sb.append("&type=action");
					sb.append("&kind=" + URLEncoder.encode(rowChilds.item(j).getTextContent().toLowerCase(), "UTF-8"));

					if (rowChilds.item(j).getTextContent().equalsIgnoreCase("IMPORTANCE")) {
						sb.append("&value=" + rowChilds.item(j+1).getTextContent().toLowerCase());
						break;
					} else if (rowChilds.item(j).getTextContent().equalsIgnoreCase("READ") || rowChilds.item(j).getTextContent().equalsIgnoreCase("DELETE")) {
						sb.append("&value=");
						break;
					}

				} else if (rowChilds.item(j).getNodeName().equals("ACTVALUE") || rowChilds.item(j).getNodeName().equals("URL")) {
					if (rowChilds.item(j).getTextContent().equals("null")) {
						sb.append("&value=");
					} else {
						sb.append("&value=" + URLEncoder.encode(rowChilds.item(j).getTextContent(), "UTF-8"));
					}
				}
			}
		}

		//exception
		Node exception = doc.getElementsByTagName("EXCEPTION").item(0);
		NodeList exptRows = exception.getChildNodes();
		for (int i=0; i<exptRows.getLength(); i++) {
			Node row = exptRows.item(i);
			NodeList rowChilds = row.getChildNodes();

			for (int j=0; j<rowChilds.getLength(); j++) {
				if (rowChilds.item(j).getNodeName().equals("EXPTKIND")) {
					if (rowChilds.item(j).getTextContent().equals("null")) {
						break;
					}
					sb.append("&type=exception");
					sb.append("&kind=" + URLEncoder.encode(rowChilds.item(j).getTextContent().toLowerCase(), "UTF-8"));
				} else if (rowChilds.item(j).getNodeName().equals("EXPTVALUE")) {
					if (rowChilds.item(j).getTextContent().equals("null")) {
						sb.append("&value=");
					} else {
						sb.append("&value=" + URLEncoder.encode(rowChilds.item(j).getTextContent(), "UTF-8"));
					}
				}
			}
		}

		String inputParams = sb.toString();
		logger.debug("inputParams=" + inputParams);

		String strJson = "";

		if (mode.equalsIgnoreCase("NEW")) { //룰 추가
			strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaAccess/setInboxRule", inputParams);
		} else if (mode.equalsIgnoreCase("MOD")) { //룰 수정
			String ruleId = doc.getElementsByTagName("ITEMID").item(0).getTextContent();
			inputParams += "&ruleId=" + URLEncoder.encode(ruleId, "UTF-8");

			strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaAccess/updateInboxRule", inputParams);
		}

		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(strJson);

		String returnValue = "Error";
		if (object.get("resultCode") != null) {
			returnValue = "<DATA><![CDATA[" + object.get("resultCode").toString() + "]]></DATA>";
		}
		
		logger.debug("returnValue=" + returnValue);
		logger.debug("mailSetInboxRule ended.");
		
		return returnValue;
	}

	/**
	 * 메일 자동분류 룰 리스트 추출 함수
	 */
	@RequestMapping(value="/ezEmail/mailGetInboxRule.do", produces="text/xml; charset=utf-8")
	@ResponseBody
	public String mailGetInboxRule(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model) throws Exception{
		logger.debug("mailGetInboxRule started.");
		
		String returnValue = "Error";
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
		String userId = userInfo.getId() + "@" + domainName;
		
		String inputParams = "userId=" + URLEncoder.encode(userId, "UTF-8");
		logger.debug("inputParams=" + inputParams);
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaAccess/getInboxRule", inputParams);

		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(strJson);
		
		if (object.get("resultCode").equals("OK")) {
			JSONArray array = (JSONArray)object.get("result");

			DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
			DocumentBuilder docBuilder = docFactory.newDocumentBuilder();

			Document doc = docBuilder.newDocument();
			Element data = doc.createElement("DATA");
			doc.appendChild(data);

			Map<Integer, Element> ruleMap = new HashMap<Integer, Element>();

			for (int i=0; i<array.size(); i++) {
				JSONObject obj = (JSONObject)array.get(i);

				if (!ruleMap.containsKey(Integer.parseInt(obj.get("ruleId").toString()))) {
					Element row = doc.createElement("ROWS");
					data.appendChild(row);

					Element id = doc.createElement("ID");
					id.appendChild(doc.createCDATASection(obj.get("ruleId").toString()));
					row.appendChild(id);

					Element name = doc.createElement("NAME");
					name.appendChild(doc.createCDATASection(obj.get("ruleName").toString()));
					row.appendChild(name);

					Element use = doc.createElement("USE");
					use.appendChild(doc.createCDATASection(obj.get("isUse").toString().toUpperCase()));
					row.appendChild(use);

					Element priority = doc.createElement("PRIORITY");
					priority.appendChild(doc.createCDATASection(obj.get("priority").toString()));
					row.appendChild(priority);

					Element condition = doc.createElement("CONDITION");
					row.appendChild(condition);

					Element action = doc.createElement("ACTION");
					row.appendChild(action);

					Element exception = doc.createElement("EXCEPTION");
					row.appendChild(exception);

					ruleMap.put(Integer.parseInt(obj.get("ruleId").toString()), row);
				}

				Element tRow = ruleMap.get(Integer.parseInt(obj.get("ruleId").toString()));
				Element tCondition = null;
				Element tAction = null;
				Element tException = null;

				NodeList rowChilds = tRow.getChildNodes();

				for (int j=0; j<rowChilds.getLength(); j++) {
					if (rowChilds.item(j).getNodeName().equalsIgnoreCase("CONDITION")) {
						tCondition = (Element)rowChilds.item(j);
					} else if (rowChilds.item(j).getNodeName().equalsIgnoreCase("ACTION")) {
						tAction = (Element)rowChilds.item(j);
					} else if (rowChilds.item(j).getNodeName().equalsIgnoreCase("EXCEPTION")) {
						tException = (Element)rowChilds.item(j);
					}
				}

				if (obj.get("type").toString().equalsIgnoreCase("CONDITION")) {
					//DOMAIN, SENDER, RECEIVER, SUBJECT, BODY, SUBJECTORBODY
					Element kind = doc.createElement("KIND");
					kind.appendChild(doc.createCDATASection(obj.get("kind").toString().toUpperCase()));
					tCondition.appendChild(kind);

					Element values = doc.createElement("VALUES");
					values.appendChild(doc.createCDATASection(obj.get("value").toString()));
					tCondition.appendChild(values);

				} else if (obj.get("type").toString().equalsIgnoreCase("ACTION")) {
					//DELETE, READ, IMPORTANCE, REDIRECTION, FORWARD, MOVE, COPY
					//SKIP : ASSIGNCATE, NONE, FORWARDATTACH, SENDSMS, SERVREPLY
					if (obj.get("kind").toString().equalsIgnoreCase("DELETE") || obj.get("kind").toString().equalsIgnoreCase("REDIRECTION")
							|| obj.get("kind").toString().equalsIgnoreCase("FORWARD")) {
						Element kind = doc.createElement("KIND");
						kind.appendChild(doc.createCDATASection(obj.get("kind").toString().toUpperCase()));
						tAction.appendChild(kind);

						Element values = doc.createElement("VALUES");
						values.appendChild(doc.createCDATASection(obj.get("value").toString()));
						tAction.appendChild(values);

					} else if (obj.get("kind").toString().equalsIgnoreCase("IMPORTANCE")) {
						Element kind = doc.createElement("KIND");
						kind.appendChild(doc.createCDATASection(obj.get("kind").toString().toUpperCase()));
						tAction.appendChild(kind);

						Element values = doc.createElement("VALUES");
						values.appendChild(doc.createCDATASection(obj.get("value").toString().toUpperCase()));
						tAction.appendChild(values);

					} else if (obj.get("kind").toString().equalsIgnoreCase("READ")) {
						Element kind = doc.createElement("KIND");
						kind.appendChild(doc.createCDATASection(obj.get("kind").toString().toUpperCase()));
						tAction.appendChild(kind);

						Element values = doc.createElement("VALUES");
						values.appendChild(doc.createCDATASection("READ"));
						tAction.appendChild(values);

					} else if (obj.get("kind").toString().equalsIgnoreCase("MOVE") || obj.get("kind").toString().equalsIgnoreCase("COPY")) {
						Element kind = doc.createElement("KIND");
						kind.appendChild(doc.createCDATASection(obj.get("kind").toString().toUpperCase()));
						tAction.appendChild(kind);

						Element folderId = doc.createElement("FOLDERID");
						folderId.appendChild(doc.createCDATASection(obj.get("value").toString()));
						tAction.appendChild(folderId);

						Element folderName = doc.createElement("FOLDERNAME");

						String folderNameStr = (String)obj.get("value");
						if (folderNameStr.equals(egovMessageSource.getMessage("ezEmail.t99000084", locale))) {
							folderNameStr = egovMessageSource.getMessage("ezEmail.t99000025", locale);
						}
						if (folderNameStr.lastIndexOf(".") > -1) {
							folderNameStr = folderNameStr.substring(folderNameStr.lastIndexOf(".")+1);
						}
						folderName.appendChild(doc.createCDATASection(folderNameStr));
						tAction.appendChild(folderName);

						Element values = doc.createElement("VALUES");
						values.appendChild(doc.createCDATASection(obj.get("kind").toString().toUpperCase()));
						tAction.appendChild(values);
					}
				} else if (obj.get("type").toString().equalsIgnoreCase("EXCEPTION")) {
					//DOMAIN, SENDER, RECEIVER, SUBJECT, BODY, SUBJECTORBODY
					Element kind = doc.createElement("KIND");
					kind.appendChild(doc.createCDATASection(obj.get("kind").toString().toUpperCase()));
					tException.appendChild(kind);

					Element values = doc.createElement("VALUES");
					values.appendChild(doc.createCDATASection(obj.get("value").toString()));
					tException.appendChild(values);
				}
			}

			returnValue = commonUtil.convertDocumentToString(doc);
		}
		
		logger.debug("returnValue=" + returnValue);
		logger.debug("mailGetInboxRule ended.");
		
		return returnValue;
	}

	/**
	 * 메일 자동분류 룰 삭제 실행 함수
	 */
	@RequestMapping(value="/ezEmail/mailDeleteInboxRule.do", produces="text/xml; charset=utf-8")
	@ResponseBody
	public String mailDeleteInboxRule(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		logger.debug("mailDeleteInboxRule started.");
		
		String returnValue = "Error";

		Document doc = commonUtil.convertRequestToDocument(request);
		String ruleId = doc.getElementsByTagName("RULEID").item(0).getTextContent();

		String inputParams = "ruleId=" + URLEncoder.encode(ruleId, "UTF-8");
		logger.debug("inputParams=" + inputParams);
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaAccess/deleteInboxRule", inputParams);

		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(strJson);

		if (object.get("resultCode") != null) {
			returnValue = "<DATA><![CDATA[" + object.get("resultCode").toString() + "]]></DATA>";
		}
		
		logger.debug("returnValue=" + returnValue);
		logger.debug("mailDeleteInboxRule ended.");
		
		return returnValue;
	}

	/**
	 * 메일 자동분류 룰 우선순위 변경 실행 함수
	 */
	@RequestMapping(value="/ezEmail/mailSetRulePriority.do", produces="text/xml; charset=utf-8")
	@ResponseBody
	public String mailSetRulePriority(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		logger.debug("mailSetRulePriority started.");
		
		String returnValue = "Error";

		Document doc = commonUtil.convertRequestToDocument(request);
		String aRuleId = doc.getElementsByTagName("ARULEID").item(0).getTextContent();
		String aPriority = doc.getElementsByTagName("APRIORITY").item(0).getTextContent();
		String bRuleId = doc.getElementsByTagName("BRULEID").item(0).getTextContent();
		String bPriority = doc.getElementsByTagName("BPRIORITY").item(0).getTextContent();

		String inputParams = "aRuleId=" + URLEncoder.encode(aRuleId, "UTF-8");
		inputParams += "&aPriority=" + URLEncoder.encode(aPriority, "UTF-8");
		inputParams += "&bRuleId=" + URLEncoder.encode(bRuleId, "UTF-8");
		inputParams += "&bPriority=" + URLEncoder.encode(bPriority, "UTF-8");
		logger.debug("inputParams=" + inputParams);
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaAccess/setRulePriority", inputParams);

		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(strJson);

		if (object.get("resultCode") != null) {
			returnValue = "<DATA><![CDATA[" + object.get("resultCode").toString() + "]]></DATA>";
		}
		
		logger.debug("returnValue=" + returnValue);
		logger.debug("mailSetRulePriority ended.");
		
		return returnValue;
	}

	/**
	 * 메일 자동분류 룰 사용여부 변경 실행 함수
	 */
	@RequestMapping(value="/ezEmail/mailSetRuleStatus.do", produces="text/xml; charset=utf-8")
	@ResponseBody
	public String mailSetRuleStatus(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		logger.debug("mailSetRuleStatus started.");
		
		String returnValue = "Error";

		Document doc = commonUtil.convertRequestToDocument(request);
		String ruleId = doc.getElementsByTagName("RULEID").item(0).getTextContent();
		String status = doc.getElementsByTagName("STATUS").item(0).getTextContent().toLowerCase();

		String inputParams = "ruleId=" + URLEncoder.encode(ruleId, "UTF-8");
		inputParams += "&status=" + URLEncoder.encode(status, "UTF-8");
		logger.debug("inputParams=" + inputParams);
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaAccess/setRuleStatus", inputParams);

		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(strJson);

		if (object.get("resultCode") != null) {
			returnValue = "<DATA><![CDATA[" + object.get("resultCode").toString() + "]]></DATA>";
		}
		
		logger.debug("returnValue=" + returnValue);
		logger.debug("mailSetRuleStatus ended.");
		
		return returnValue;
	}

	/**
	 * 메일 자동분류 룰 자세히보기 화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailDetailInboxRule.do")
	public String mailDetailInboxRule(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model) throws Exception{
		return "ezEmail/mailDetailInboxRule";
	}

	/**
	 * 메일 부재중 설정 화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailOutOfOfficeCK.do")
	public String mailOutOfOfficeCK(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model) throws Exception{
		logger.debug("mailOutOfOfficeCK started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String gOofState = "disabled";
		String gStartDate = "";
		String gEndDate = "";
		String gExternalAudience = "known";
		String gInternal = "";
		String gExternal = "";

		String userLang = userInfo.getLang();

		String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
		String userId = userInfo.getId() + "@" + domainName;

		String inputParams = "userId=" + URLEncoder.encode(userId, "UTF-8");
		logger.debug("inputParams=" + inputParams);
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaAccess/getOutOfOffice", inputParams);

		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(strJson);

		if (object.get("resultCode").equals("OK") && object.get("result") != null) {
			JSONObject resultObject = (JSONObject)object.get("result");
			gOofState = resultObject.get("oofState").toString();
			gStartDate = resultObject.get("startDate").toString();
			gEndDate = resultObject.get("endDate").toString();
			gExternalAudience = resultObject.get("externalAudience").toString();
			gInternal = resultObject.get("internal").toString();
			gExternal = resultObject.get("external").toString();
		}
		
		String offset = userInfo.getOffset();
		
		String offsetMin = commonUtil.getMinuteUTC(offset);
		
		if (!gOofState.equals("scheduled")) {
			//get UTC time
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			sdf.setTimeZone(TimeZone.getTimeZone("GMT"));
			String dateStr = sdf.format(new Date());
			
			//get user time from UTC time
			dateStr = commonUtil.getDateStringInUTC(dateStr, offset, false);
			logger.debug("userCurrentTime=" + dateStr);
			
			String date = dateStr.substring(0, 10);
			String hour = dateStr.substring(11, 13);
			
			gStartDate = EgovDateUtil.addYMDtoDayTime(date, hour + ":00", 0, 0, 0, 1, 0, "yyyy-MM-dd HH:mm");
			gEndDate = EgovDateUtil.addYMDtoDayTime(date, hour + ":00", 0, 0, 1, 0, 0, "yyyy-MM-dd HH:mm");
		} else {
			//set user time from UTC time
			gStartDate = commonUtil.getDateStringInUTC(gStartDate, offset, false);
			gEndDate = commonUtil.getDateStringInUTC(gEndDate, offset, false);
		}
		
		logger.debug("gOofState=" + gOofState + ",gStartDate=" + gStartDate + ",gEndDate=" + gEndDate
				 + ",gExternalAudience=" + gExternalAudience + ",gInternal=" + gInternal + ",gExternal=" + gExternal);
		
		model.addAttribute("offsetMin", offsetMin);
		model.addAttribute("gOofState", gOofState);
		model.addAttribute("gStartDate", gStartDate);
		model.addAttribute("gEndDate", gEndDate);
		model.addAttribute("gExternalAudience", gExternalAudience);
		model.addAttribute("gInternal", gInternal);
		model.addAttribute("gExternal", gExternal);
		model.addAttribute("userLang", userLang);
		
		logger.debug("mailOutOfOfficeCK ended.");
		
		return "ezEmail/mailOutOfOfficeCK";
	}

	/**
	 * 메일 부재중 설정 저장 함수
	 */
	@RequestMapping(value="/ezEmail/mailOutOfOfficeSave.do")
	@ResponseBody
	public String mailOutOfOfficeSave(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		logger.debug("mailOutOfOfficeSave started.");
		
		String returnValue = "ERROR";

		Document doc = commonUtil.convertRequestToDocument(request);
		String oofState = doc.getElementsByTagName("OOFSTATE").item(0).getTextContent();
		String startDate = doc.getElementsByTagName("STARTDATE").item(0).getTextContent();
		String endDate = doc.getElementsByTagName("ENDDATE").item(0).getTextContent();
		String internal = doc.getElementsByTagName("INTERNAL").item(0).getTextContent();
		String external = doc.getElementsByTagName("EXTERNAL").item(0).getTextContent();
		String externalAudience = doc.getElementsByTagName("EXTERNALAUDIENCE").item(0).getTextContent();

		//set UTC time
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String offset = userInfo.getOffset();
		startDate = commonUtil.getDateStringInUTC(startDate, offset, true);
		endDate = commonUtil.getDateStringInUTC(endDate, offset, true);
		
		String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
		String userId = userInfo.getId() + "@" + domainName;
		
		StringBuilder sb = new StringBuilder();
		sb.append("userId=" + URLEncoder.encode(userId, "UTF-8"));
		sb.append("&oofState=" + URLEncoder.encode(oofState, "UTF-8"));
		sb.append("&startDate=" + URLEncoder.encode(startDate, "UTF-8"));
		sb.append("&endDate=" + URLEncoder.encode(endDate, "UTF-8"));
		sb.append("&internal=" + URLEncoder.encode(internal, "UTF-8"));
		sb.append("&external=" + URLEncoder.encode(external, "UTF-8"));
		sb.append("&externalAudience=" + URLEncoder.encode(externalAudience, "UTF-8"));
		
		String inputParams = sb.toString();
		logger.debug("inputParams=" + inputParams);
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaAccess/setOutOfOffice", inputParams);

		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(strJson);

		if (object.get("resultCode") != null) {
			returnValue = object.get("resultCode").toString();
		}
		
		logger.debug("returnValue=" + returnValue);
		logger.debug("mailOutOfOfficeSave ended.");
		
		return returnValue;

	}

	/**
	 * 외부메일 설정 화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailPop3.do")
	public String mailPop3(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		logger.debug("mailPop3 started.");

		String publicModulus = egovFileScrty.getPbm();
		String publicExponent = "10001";
		
		String prm = egovFileScrty.getPrm();
		String pre = egovFileScrty.getPre();
		PrivateKey pk = EgovFileScrty.getPrivateKey(prm, pre);
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		List<MailPOP3VO> pop3VoList = ezEmailService.getMailPOP3(userInfo.getTenantId(), userInfo.getId());
		
		StringBuilder sb = new StringBuilder();
		sb.append("<DATA>");
		
		for (MailPOP3VO pop3Vo : pop3VoList) {

			String pop3UserId = EgovFileScrty.decryptRsa(pk, pop3Vo.getPop3UserId());
			String pop3Pw = EgovFileScrty.decryptRsa(pk, pop3Vo.getPop3Pw());

			String pop3SslYN = "false";
			if (pop3Vo.getPop3SslYN().equals("1")) {
				pop3SslYN = "true";
			}

			sb.append("<ROW>");
			sb.append("<POP3SERVER>" + pop3Vo.getPop3Server() + "</POP3SERVER>");
			sb.append("<POP3PORTNO>" + pop3Vo.getPop3PortNo() + "</POP3PORTNO>");
			sb.append("<POP3USERID>" + pop3UserId + "</POP3USERID>");
			sb.append("<POP3PW>" + pop3Pw + "</POP3PW>");
			sb.append("<SAVETO>" + pop3Vo.getSaveTo() + "</SAVETO>");
			sb.append("<DELETEYN>" + pop3Vo.getDeleteYN() + "</DELETEYN>");
			sb.append("<POP3SSLYN>" + pop3SslYN + "</POP3SSLYN>");
			sb.append("<SAVETOFOLDER>" + pop3Vo.getSaveTofolder() + "</SAVETOFOLDER>");
			sb.append("</ROW>");
		}

		sb.append("</DATA>");
		String infoXML = sb.toString();
		
		model.addAttribute("infoXML", infoXML);
		model.addAttribute("publicModulus", publicModulus);
		model.addAttribute("publicExponent", publicExponent);
		
		logger.debug("infoXML=" + infoXML);
		logger.debug("publicModulus=" + publicModulus);
		logger.debug("publicExponent=" + publicExponent);
		logger.debug("mailPop3 ended.");
		
		return "ezEmail/mailPop3";
	}

	/**
	 * 외부메일 설정 저장 실행 함수
	 */
	@RequestMapping(value="/ezEmail/mailPop3Save.do")
	@ResponseBody
	public String mailPop3Save(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, @RequestBody String ret) throws Exception{
		String rtnVal = "OK";
		
		try {
			LoginVO userInfo = commonUtil.userInfo(loginCookie);
			ezEmailService.savePop3(userInfo.getTenantId(), userInfo.getId(), ret);
		} catch (Exception e) {
			rtnVal = "ERROR";
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		
		return rtnVal;
	}

	/**
	 * 외부메일 설정 접속확인 실행 함수
	 */
	@RequestMapping(value="/ezEmail/mailPop3Connect.do", produces="text/xml; charset=utf-8")
	@ResponseBody
	public String mailPop3Connect(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, @RequestBody String bodyData) throws Exception{
		logger.debug("mailPop3Connect started.");
		logger.debug("bodyData=" + bodyData);
		
		String returnValue = "<DATA>ERROR</DATA>";

		Document doc = commonUtil.convertStringToDocument(bodyData);
		String server = doc.getElementsByTagName("SERVER").item(0).getTextContent();
		String port = doc.getElementsByTagName("PORT").item(0).getTextContent();
		String id = doc.getElementsByTagName("ID").item(0).getTextContent();
		String pw = doc.getElementsByTagName("PW").item(0).getTextContent();
		String useSsl = doc.getElementsByTagName("SSL").item(0).getTextContent();

		String prm = egovFileScrty.getPrm();
		String pre = egovFileScrty.getPre();
		PrivateKey pk = EgovFileScrty.getPrivateKey(prm, pre);

		id = EgovFileScrty.decryptRsa(pk, id);
		pw = EgovFileScrty.decryptRsa(pk, pw);

		POP3Access pa = null;
		try {
			pa = POP3Access.getInstance(server, port, id, pw, useSsl);
			if (pa.checkConnect()) {
				returnValue = "<DATA>OK</DATA>";
			}
		} catch (Exception e) {
			logger.error(e.getMessage());
		} finally {
			if (pa != null) {
				pa.close();
			}
		}
		
		logger.debug("returnValue=" + returnValue);
		logger.debug("mailPop3Connect ended.");
		
		return returnValue;
	}

	/**
	 * 외부메일 확인 실행 함수
	 */
	@RequestMapping(value="/ezEmail/mailGetPop3.do")
	public void mailGetPop3(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletResponse response) throws Exception{
		logger.debug("mailGetPop3 started.");
		
		List<String> userInfo = commonUtil.getUserIdAndPassword(loginCookie);
		String password  = userInfo.get(1);
		
		LoginVO loginInfo = commonUtil.userInfo(loginCookie);
		String domainName = ezCommonService.getTenantConfig("DomainName", loginInfo.getTenantId());
		String userEmail = loginInfo.getId() + "@" + domainName;
		logger.debug("userEmail=" + userEmail);
		
		response.setContentType("text/html; charset=utf-8");

		PrintWriter out = response.getWriter();
		out.write("<!DOCTYPE html><head>");
		out.write("<title>" + egovMessageSource.getMessage("ezEmail.t490", locale) + "</title>");
		out.write("<META HTTP-EQUIV='Content-Type' CONTENT='text/html; charset=utf-8'>");
		out.write("<link rel='stylesheet' href='" + egovMessageSource.getMessage("ezEmail.c1", locale) + "' type=text/css>");
		out.write("<script type='text/javascript' src='/js/mouseeffect.js'></script>"
				+ "</head>"
				+ "<body scroll=no class='popup'>");
		out.write("<h1>" + egovMessageSource.getMessage("ezEmail.t490", locale) + "</h1>");
		out.write("<div id='close'><ul><li onClick='window.close()'><span>" + egovMessageSource.getMessage("ezEmail.t63", locale) + "</span></li></ul>");
		out.write("</div>"
				+ "<script type='text/javascript'>"
				+ "selToggleList(document.getElementById('close'), 'ul', 'li', '0');"
				+ "</script>"
				+ "<div class='nobox' id='status_view' style='background-color:#FFFFFF; border-style:solid; border-width:1px; border-color:#B6B6B6; overflow-y:auto; height:265px; overflow-x:auto; width:100%; padding-top:5px; padding-left:5px; padding-right:3px; margin-top:7px;'>");
		out.write(egovMessageSource.getMessage("ezEmail.t491", locale));
		out.flush();

		String prm = egovFileScrty.getPrm();
		String pre = egovFileScrty.getPre();
		PrivateKey pk = EgovFileScrty.getPrivateKey(prm, pre);
		
		List<MailPOP3VO> pop3Settinglist = ezEmailService.getMailPOP3(loginInfo.getTenantId(), loginInfo.getId());
		
		if (pop3Settinglist.size() == 0) {
			out.write("<BR> " + egovMessageSource.getMessage("ezEmail.t504", locale)
					+ "<BR>" + egovMessageSource.getMessage("ezEmail.t505", locale) + " > "
					+ egovMessageSource.getMessage("ezEmail.t506", locale));
			out.write("<BR><BR> " + egovMessageSource.getMessage("ezEmail.t507", locale));
			
			out.write("<span id='forscroll'></span>"
					+ "</div>"
					+ "<script type='text/javascript'>"
					+ "forscroll.scrollIntoView(false);"
					+ "</script></body>");
			out.flush();

			out.close();
			
			logger.debug("<BR> " + egovMessageSource.getMessage("ezEmail.t504", locale)
			+ "<BR>" + egovMessageSource.getMessage("ezEmail.t505", locale) + " > "
			+ egovMessageSource.getMessage("ezEmail.t506", locale));
			
			logger.debug("mailGetPop3 ended.");
			return;
		}
		
		IMAPAccess ia = null;
		try {
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userEmail, password, egovMessageSource, locale);
			
			for (MailPOP3VO vo : pop3Settinglist) {
				String boxId = vo.getSaveTo();
				String boxName = vo.getSaveTofolder();
				String host = vo.getPop3Server();
				String port = vo.getPop3PortNo();
				String useSsl = vo.getPop3SslYN(); //0,1
				String id = vo.getPop3UserId();
				String pw = vo.getPop3Pw();
				String deleteYN = vo.getDeleteYN(); //Y,N
	
				String dId = EgovFileScrty.decryptRsa(pk, id);
				String dPw = EgovFileScrty.decryptRsa(pk, pw);
	
				if (useSsl.equals("1")) {
					useSsl = "true";
				} else {
					useSsl = "false";
				}
	
				out.write("<BR><BR>" + egovMessageSource.getMessage("ezEmail.t492", locale) + host + ", "
						+ egovMessageSource.getMessage("ezEmail.t493", locale) + dId
						+ "<BR>" + egovMessageSource.getMessage("ezEmail.t494", locale) + boxName
						+ "<BR>" + egovMessageSource.getMessage("ezEmail.t495", locale));
				out.flush();
				
				logger.debug("<BR><BR>" + egovMessageSource.getMessage("ezEmail.t492", locale) + host + ", "
						+ egovMessageSource.getMessage("ezEmail.t493", locale) + dId
						+ "<BR>" + egovMessageSource.getMessage("ezEmail.t494", locale) + boxName
						+ "<BR>" + egovMessageSource.getMessage("ezEmail.t495", locale));
				
				POP3Access pa = null;
	
				try {
					pa = POP3Access.getInstance(host, port, dId, dPw, useSsl);
					if (!pa.checkConnect()) {
						out.write("<BR>" + egovMessageSource.getMessage("ezEmail.t269", locale) + egovMessageSource.getMessage("ezEmail.t99000091", locale));
						out.flush();
						
						logger.debug("<BR>" + egovMessageSource.getMessage("ezEmail.t269", locale) + egovMessageSource.getMessage("ezEmail.t99000091", locale));
					} else {
						final Folder folder = pa.getFolder(egovMessageSource.getMessage("ezEmail.t99000084", locale));
	
						if (deleteYN.equals("Y")) {
							folder.open(Folder.READ_WRITE);
						} else {
							folder.open(Folder.READ_ONLY);
						}
	
						Message[] messages = folder.getMessages();
						int mailCount = messages.length;
	
						// pre-fetch fields needed for searching
						FetchProfile fp = new FetchProfile();
						fp.add(UIDFolder.FetchProfileItem.UID);
						folder.fetch(messages, fp);
						
						// Throw exception when the pop3 server does not support UIDL.
						String testUID = ((POP3Folder)folder).getUID(messages[0]);
						if (testUID == null) {
							throw new Exception("Unsupported");
						}
						
						List<String> messageIdList = ezEmailService.getMailPOP3List(loginInfo.getTenantId(), loginInfo.getId(), host, id);
						
						final Set<String> messageIds = new HashSet<String>(messageIdList);
						SearchTerm searchTerm= new SearchTerm() {
							@Override
							public boolean match(Message message) {
								try {
									String thisUID = ((POP3Folder)folder).getUID(message); 
	
									if (!messageIds.contains(thisUID)) {
										return true;
									}
								} catch (MessagingException e) {
									e.printStackTrace();
								}
								return false;
							}
						};
						
						messages = folder.search(searchTerm);
						int newCount = messages.length;
	
						out.write("<BR>" + egovMessageSource.getMessage("ezEmail.t498", locale) + mailCount 
								+ "<BR>" + egovMessageSource.getMessage("ezEmail.t499", locale) + newCount);
						out.flush();
						
						logger.debug("<BR>" + egovMessageSource.getMessage("ezEmail.t498", locale) + mailCount 
								+ "<BR>" + egovMessageSource.getMessage("ezEmail.t499", locale) + newCount);
						
						if (newCount > 40) {
							out.write("<BR>" + egovMessageSource.getMessage("ezEmail.t500", locale));
							out.flush();
							
							logger.debug("<BR>" + egovMessageSource.getMessage("ezEmail.t500", locale));
							
							messages = Arrays.copyOfRange(messages, 0, 40);
						}
						
						Folder innerFolder = null;
						try {
							innerFolder = ia.getFolder(boxId);
							innerFolder.open(Folder.READ_WRITE);
							
							List<String> pop3MessageId = new ArrayList<String>();
							
							for (int i=0; i<messages.length; i++) {
								if (i%10 == 0) {
									if (messages.length < i + 10) {
										out.write("<BR>" + (i+1) + " - " + messages.length + egovMessageSource.getMessage("ezEmail.t501", locale));
										logger.debug("<BR>" + (i+1) + " - " + messages.length + egovMessageSource.getMessage("ezEmail.t501", locale));
									}
									else {
										out.write("<BR>" + (i+1) + " - " + (i+10) + egovMessageSource.getMessage("ezEmail.t501", locale));
										logger.debug("<BR>" + (i+1) + " - " + (i+10) + egovMessageSource.getMessage("ezEmail.t501", locale));
									}
									out.flush();
								}
								
								//TODO: 편지함 존재여부, 용량초과 Exception은 for문 그만돌고 error message를 찍어줘야함.
								// 그 외의 Exception은 계속 for문을 돌면서 메일을 가져와야함.
								String messageId = ((POP3Folder)folder).getUID(messages[i]);
								try {
									innerFolder.appendMessages(new Message[]{messages[i]});
									if (deleteYN.equals("Y")) {
										messages[i].setFlag(Flags.Flag.DELETED, true);
									}
									
									pop3MessageId.add(messageId);
								} catch (MessagingException e) {
									out.write("<BR>" + egovMessageSource.getMessage("ezEmail.t497", locale) + "messageId=" + messageId);
									out.flush();
									logger.debug("<BR>" + egovMessageSource.getMessage("ezEmail.t497", locale)
										+ "messageId=" + messageId + ",subject=" + messages[i].getSubject());
									e.printStackTrace();
								}
								
							}
							
							ezEmailService.setMailPOP3List(loginInfo.getTenantId(), loginInfo.getId(), host, id, pop3MessageId);
							
						} catch (MessagingException e) {
							out.write("<BR>" + egovMessageSource.getMessage("ezEmail.t497", locale)
							+ egovMessageSource.getMessage("ezEmail.t502", locale));
							out.flush();
							
							logger.error("<BR>" + egovMessageSource.getMessage("ezEmail.t497", locale)
							+ egovMessageSource.getMessage("ezEmail.t502", locale));
							
							e.printStackTrace();
						} finally {
							if (innerFolder != null) {
								innerFolder.close(true);
							}
						}
						
						folder.close(true);
					}
					
				} catch (Exception e) {
					out.write("<BR>" + egovMessageSource.getMessage("ezEmail.t497", locale) + e.getMessage());
					out.flush();
					
					logger.error("<BR>" + egovMessageSource.getMessage("ezEmail.t497", locale) + e.getMessage());
					
					e.printStackTrace();
				} finally {
					if (pa != null) {
						pa.close();
					}
				}
	
			}
		
		} catch (Exception e) {
			out.write("<BR>" + egovMessageSource.getMessage("ezEmail.t497", locale) + e.getMessage());
			out.flush();
			
			logger.error("<BR>" + egovMessageSource.getMessage("ezEmail.t497", locale) + e.getMessage());
			
			e.printStackTrace();
		} finally {
			if (ia != null) {
				ia.close();
			}
		}
		
		out.write("<BR><BR> " + egovMessageSource.getMessage("ezEmail.t507", locale));
		out.write("<span id='forscroll'></span>"
				+ "</div>"
				+ "<script type='text/javascript'>"
				+ "forscroll.scrollIntoView(false);"
				+ "</script></body>");
		out.flush();
		out.close();
		
		logger.debug("mailGetPop3 ended.");
	}
	
}
