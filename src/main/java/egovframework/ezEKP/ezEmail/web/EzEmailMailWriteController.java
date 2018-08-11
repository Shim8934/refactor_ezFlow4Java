package egovframework.ezEKP.ezEmail.web;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.UnsupportedEncodingException;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.security.PrivateKey;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;
import java.util.Set;
import java.util.TimeZone;
import java.util.UUID;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.activation.DataHandler;
import javax.activation.FileDataSource;
import javax.annotation.Resource;
import javax.crypto.Cipher;
import javax.mail.Address;
import javax.mail.BodyPart;
import javax.mail.Flags;
import javax.mail.Folder;
import javax.mail.Header;
import javax.mail.Message;
import javax.mail.Message.RecipientType;
import javax.mail.MessagingException;
import javax.mail.Multipart;
import javax.mail.Part;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.InternetHeaders;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import javax.mail.internet.MimePart;
import javax.mail.internet.MimeUtility;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.codec.binary.Base64;
import org.apache.commons.io.FileUtils;
import org.apache.commons.io.IOUtils;
import org.apache.commons.lang3.StringUtils;
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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import com.sun.mail.imap.AppendUID;
import com.sun.mail.imap.IMAPFolder;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezAddress.service.EzAddressService;
import egovframework.ezEKP.ezAddress.vo.AddressVO;
import egovframework.ezEKP.ezAddress.vo.SimpleAddressVO;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.logic.IMAPAccess;
import egovframework.ezEKP.ezEmail.logic.SMTPAccess;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezEmail.util.EzEmailUtil;
import egovframework.ezEKP.ezEmail.vo.MailColorVO;
import egovframework.ezEKP.ezEmail.vo.MailDistributionVO;
import egovframework.ezEKP.ezEmail.vo.MailGeneralVO;
import egovframework.ezEKP.ezEmail.vo.MailSignatureVO;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.ClientUtil;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;
import egovframework.let.utl.fcc.service.EgovStringUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

/** 
 * @Description [Controller] 메일 쓰기
 * @author 오픈솔루션팀 이효민
 * @Modification Information
 *
 *    수정일        수정자         수정내용
 *    ----------    ------    -------------------
 *    2016.04.14    이효민    신규작성
 *
 * @see
 */

@Controller
public class EzEmailMailWriteController extends EgovFileMngUtil {

	private static final Logger logger = LoggerFactory.getLogger(EzEmailMailWriteController.class);
	
	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;

	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Autowired
	private EzOrganAdminService ezOrganAdminService;
	
	@Autowired
	private EzOrganService ezOrganService;
	
	@Autowired
	private EzEmailService ezEmailService;
	
	@Autowired
	private EzAddressService ezAddressService;
	
	@Resource(name = "EzCommonService")
    private EzCommonService ezCommonService;
	
	@Autowired
	private EzEmailUtil ezEmailUtil;
	
    @Resource(name="crypto") 
    private EgovFileScrty egovFileScrty;
	
	/**
	 * 메일 쓰기화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailWrite.do")
	public String mailWrite(
			@CookieValue("loginCookie") String loginCookie, 
			Locale locale, 
			Model model, 
			HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		logger.debug("mailWrite started.");
		
		String from = "";
		String to = "";
		String cc = "";
		String bcc = "";
		
		//String body = "";
		String tempBody = "";
		String bodyValue = "";
		
		String subject = "";
		String url = "";
		String attach = "";
		String importance = "1";
		String isEach = "FALSE";
		String isSecureMail = "false";
		String bodyType = "0";
		String replySendTime = "0";
		String replyReadTime;
		String delaySendDate = "";
		String unread = "";
		String reSendFlag = "N";
		String folderPath = "";
		
		String mailSign1 = "";
		String mailSign2 = "";
		String mailSign3 = "";
		String mailSignSel = "0";
		
		String boardID = "";
		String itemID = "";
		String docHref = "";
		String docID = "";
		String docImagCnt = "";
		String docTarget = "";
		String retransType = "";
		
		String fileUploadType = "";
		String newWindowId = "";
		
		String dotNetUrl = "";
		
		//업무일지 아이디
		String journalId = "";
		
		//근태관리
		String attitudeId = "";
		
		//운영자에게 메일 보내기
		String operatorMailAddress = request.getParameter("operatorMailAddress") != null ? request.getParameter("operatorMailAddress") : "";
		
		// check if parameter is valid
		String tempStr = "";
		if (request.getParameter("cmd") != null) {
			tempStr = request.getParameter("cmd").toUpperCase().trim();
		} else {
			tempStr = "NEW";
		}

		if (!(tempStr.equals("") || tempStr.equals("REPLY") || tempStr.equals("REPLYALL") || tempStr.equals("FORWARD") || tempStr.equals("READ") 
				|| tempStr.equals("EDIT") || tempStr.equals("NEW") || tempStr.equals("BOARD") || tempStr.equals("COMMUNITY") || tempStr.equals("DOCSEND")
				|| tempStr.equals("RESEND") || tempStr.equals("BOARDDOTNET") || tempStr.equals("DOCSENDDOTNET")
				|| tempStr.equals("COMMUNITYDOTNET")|| tempStr.equals("JOURNAL") || tempStr.equals("ATTITUDE") || tempStr.equals("ATTITUDEABSENTED")
				/* 아직 이 값으로는 받는 부분 없음
				|| tempStr.equals("DOCSENDDOC") || tempStr.equals("ACCESSNO") || tempStr.equals("REPORT") */
			)) {
			return egovMessageSource.getMessage("ezEmail.lhm17", locale);
		}

		if (request.getParameter("msgto") != null) {
			tempStr = request.getParameter("msgto").toUpperCase().trim().replaceAll("&lt;", "<").replaceAll("&gt;", ">").replaceAll("&quot;", "\"");
		} else {
			tempStr = "";
		}

		if (tempStr.indexOf("<") >= 0 && tempStr.indexOf(">") >= 0 && tempStr.indexOf("SCRIPT") >= 0) {
			return egovMessageSource.getMessage("ezEmail.lhm17", locale);
		}

		// get user credentials
		LoginVO loginInfo = commonUtil.userInfo(loginCookie);
		OrganUserVO userInfo = ezOrganAdminService.getUserInfo(loginInfo.getId(), loginInfo.getPrimary(), loginInfo.getTenantId());
		String password  = commonUtil.getUserIdAndPassword(loginCookie).get(1);
		
		// set replyReadTime
		String isDefaultReceiptExternal = ezCommonService.getTenantConfig("isDefaultReceiptExternal", loginInfo.getTenantId());
		String useReceiptExternal = ezCommonService.getTenantConfig("useReceiptExternal", loginInfo.getTenantId());
		
		if (useReceiptExternal.equals("YES")) {
			replyReadTime = "YES".equalsIgnoreCase(isDefaultReceiptExternal) ? "2" : "1";
		} else {
			replyReadTime = "1";
		}
		
		// set attributes
		String userPrimary = loginInfo.getPrimary();
		String userLang = loginInfo.getLang();
		String userTimeset = loginInfo.getOffset();
		logger.debug("userPrimary=" + userPrimary + ",userLang=" + userLang + ",userTimeset=" + userTimeset);
		
		String displayNamePrintable = userInfo.getDisplayName();
		
		// set useLetter
		String useLetter = ezCommonService.getTenantConfig("useLetter", loginInfo.getTenantId());
		if (useLetter == null || useLetter.equals("")) {
			useLetter = "NO";
		}
		
		logger.debug("useLetter=" + useLetter);
		
		// 쓰기창에서 수신인 자동완성 기능 사용 유무
		String useMailAddrAutoComplete = ezCommonService.getTenantConfig("useMailAddrAutoComplete", loginInfo.getTenantId());
		
		// set serverName
		String serverName = loginInfo.getServerName();
		String useMailLinkHostname = ezCommonService.getTenantConfig("useMailLinkHostname", loginInfo.getTenantId());
		
		if (useMailLinkHostname.equals("YES")) {
			String mailLinkHostname = ezCommonService.getTenantConfig("mailLinkHostname", loginInfo.getTenantId());
			
			if (!mailLinkHostname.equals("")) {
				serverName = mailLinkHostname;
			}
		}
		
		//수아 수정
		String useMailWriteSenderClick = ezCommonService.getTenantConfig("useMailWriteSenderClick", userInfo.getTenantId());
		
		if (useMailWriteSenderClick.equals("")) {
			useMailWriteSenderClick = "NO";
		}
		
		logger.debug("displayNamePrintable=" + displayNamePrintable + ",serverName=" + serverName);
		
		String stateName = UUID.randomUUID().toString();
		logger.debug("stateName=" + stateName);
		
		String mailInnerDomain = ezCommonService.getTenantConfig("MailInnerDomain", loginInfo.getTenantId());
		String useEditor = ezCommonService.getTenantConfig("EDITOR", loginInfo.getTenantId());
		String useSecureMail = ezCommonService.getTenantConfig("USE_SECUREMAIL", loginInfo.getTenantId());
		String defaultFontAndSize = "style='font-size:13px;font-family:" + egovMessageSource.getMessage("main.t246", locale) + "'";
		String useReSend = ezCommonService.getTenantConfig("useReSend", loginInfo.getTenantId());
		
		//사용자 언어가 한국어이고 editorFontStyle값이 있을 경우 editorFontStyle값 적용
		if (loginInfo.getLang().equals("1")) {
			String editorFontStyle = ezCommonService.getTenantConfig("editorFontStyle", loginInfo.getTenantId());
			
			if (!editorFontStyle.equals("")) {
				String fontFamily = editorFontStyle.split("\\|")[0];
				String fontSize = editorFontStyle.split("\\|")[1];
				
				defaultFontAndSize = "style='font-size:" + fontSize + ";font-family:" + fontFamily + "'";
			}
		}
		
		logger.debug("mailInnerDomain=" + mailInnerDomain + ",useEditor=" + useEditor + ",useSecureMail=" + useSecureMail + ",defaultFontAndSize=" + defaultFontAndSize);
		
		//메일 색상 관련 설정
		String inMailColor = "#808080";
		String outMailColor = "#0080ff";
		MailColorVO vo = ezEmailService.getMailColor(loginInfo.getTenantId());
		if (vo != null) {
			inMailColor = vo.getInmailColor();
			outMailColor = vo.getOutmailColor();
		}
		logger.debug("inMailColor=" + inMailColor + ",outMailColor=" + outMailColor);
		
		//파일첨부 제한 관련 변수 설정 
		String mailAttachLimit = ezCommonService.getTenantConfig("MailAttachLimit", loginInfo.getTenantId());
		String bigSizeMailAttachLimit = ezCommonService.getTenantConfig("BigSizeMailAttachLimit", loginInfo.getTenantId());
		String totBigSizeMailAttachLimit = ezCommonService.getTenantConfig("totBigSizeMailAttachLimit", loginInfo.getTenantId());
		String pBigAttachDownloadDay = ezCommonService.getTenantConfig("BigSizeMailAttachDelDay", loginInfo.getTenantId());
		logger.debug("mailAttachLimit=" + mailAttachLimit + ",bigSizeMailAttachLimit=" + bigSizeMailAttachLimit
				+ ",totBigSizeMailAttachLimit=" + totBigSizeMailAttachLimit + ",pBigAttachDownloadDay=" + pBigAttachDownloadDay);
		
		String bigSizeMailAttachDelDate = EgovDateUtil.addDay(EgovDateUtil.getToday("-"), Integer.parseInt(pBigAttachDownloadDay), "yyyy-MM-dd");
        String pBigAttachDownloadPeriod = EgovDateUtil.getToday("/") + " ~ " + EgovDateUtil.addDay(EgovDateUtil.getToday("/"), Integer.parseInt(pBigAttachDownloadDay), "yyyy/MM/dd");
        String pAttachWarning = egovMessageSource.getMessage("ezEmail.lhm18", locale) + mailAttachLimit + egovMessageSource.getMessage("ezEmail.lhm19", locale) 
        	+ totBigSizeMailAttachLimit + egovMessageSource.getMessage("ezEmail.lhm20", locale) + pBigAttachDownloadDay + egovMessageSource.getMessage("ezEmail.lhm21", locale);
        if(totBigSizeMailAttachLimit.equals("0")){
        	pAttachWarning = egovMessageSource.getMessage("ezEmail.kms01", locale) + mailAttachLimit +egovMessageSource.getMessage("ezEmail.kms02", locale);
        }
        logger.debug("bigSizeMailAttachDelDate=" + bigSizeMailAttachDelDate + ",pBigAttachDownloadPeriod=" + pBigAttachDownloadPeriod
        		+ ",pAttachWarning=" + pAttachWarning);
        
        // set pAutoSaveTime,mailSendObject
 		MailGeneralVO mailGeneralVO = ezEmailService.getMailGeneral(loginInfo.getTenantId(), loginInfo.getId()).get(0);
 		String pAutoSaveTime = mailGeneralVO.getKeepDeleteLength() == null ? "0" : mailGeneralVO.getKeepDeleteLength();
 		String pMailSenderNM = EgovStringUtil.isEmpty(mailGeneralVO.getMailSenderNm()) ? userInfo.getDisplayName2() : mailGeneralVO.getMailSenderNm();
 		String mailSendObject = "<option value='NONE'>" + egovMessageSource.getMessage("ezEmail.t99000032", locale) + "</option>";
 		
 		if (pMailSenderNM != null && !pMailSenderNM.trim().equals("")) {
 			String[] senderList = pMailSenderNM.split("\\|!\\-@\\-!\\|");
 			
 	 		for (String pSenderNM : senderList) {
 	 			mailSendObject += "<option value='" + pSenderNM + "'>" + pSenderNM + "</option>";
 	 		}
 		}
        logger.debug("pAutoSaveTime=" + pAutoSaveTime + ",pMailSenderNM=" + pMailSenderNM);
 		
        //set mail sign
        MailSignatureVO mailSignatureVO = ezEmailService.getMailSignature(loginInfo.getTenantId(), loginInfo.getId());
        
        if (mailSignatureVO != null) {
        	mailSign1 = mailSignatureVO.getContent1();
            mailSign2 = mailSignatureVO.getContent2();
            mailSign3 = mailSignatureVO.getContent3();
            mailSignSel = mailSignatureVO.getUseFlag().trim();
        }
        
        if (!mailSignSel.equals("0") && !mailSignSel.equals("1") && !mailSignSel.equals("2") && !mailSignSel.equals("3")) {
        	mailSignSel = "0";
        }
        
        //TODO: setting
  		String useMultiLangMail = "1";
  		String pSecurity = "1";
  		String charsetCheck = "1";
  		String postType = "0";
  		logger.debug("useMultiLangMail=" + useMultiLangMail + ",pSecurity=" + pSecurity + ",charsetCheck=" + charsetCheck
  				+ ",postType=" + postType);
  		
		String individualMailUser = ezCommonService.getTenantConfig("INDIVIDUALMAILUSER", loginInfo.getTenantId());
		
		String cmdOwn = "";
		if (request.getParameter("cmd") != null) {
			cmdOwn = request.getParameter("cmd");
		}
		
		String urlOwn = "";
		if (request.getParameter("url") != null) {
			urlOwn = URLDecoder.decode(request.getParameter("url").replaceAll(" ", "+"),"UTF-8"); // url decode 해야하나?
		}
		
		String _cmd = "";
		if (request.getParameter("cmd") != null) {
			_cmd = request.getParameter("cmd");
		}
		
		String msgto = "";
		if (request.getParameter("msgto") != null) {
			msgto = request.getParameter("msgto").trim().replaceAll("&lt;", "<").replaceAll("&gt;", ">").replaceAll("&quot;", "\"");
		}
        
        String _url = "";
        if (request.getParameter("iptURL") != null) {
        	_url = request.getParameter("iptURL");
		}
        if (request.getParameter("URL") != null) {
        	_url = request.getParameter("URL");
        } else if (request.getParameter("url") != null) {
        	_url = request.getParameter("url");
        }
        urlOwn = _url;
        logger.debug("_cmd=" + _cmd + ",_url=" + _url);
        
        String _attach = "";
        if (request.getParameter("attach") != null) {
        	_attach = request.getParameter("attach");
		}
        String includeContent = "";
        if (request.getParameter("include") != null) {
        	includeContent = request.getParameter("include");
		}
        
        String domainName = ezCommonService.getTenantConfig("DomainName", loginInfo.getTenantId());
		String userAccount = loginInfo.getId() + "@" + domainName;
        
		// make mail top level folders
        IMAPAccess ia = null;
        try {
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userAccount, password, egovMessageSource, locale, ezEmailUtil);
			ia.makeTopLevelFolders();
		} finally {
			if (ia != null) {
				ia.close();
				ia = null;
			}
		}
        
        String multipartFirstIdx = "0";
        
        // in case of new
        if (_url.equals("") && _cmd.equals("NEW")) {
        	to = msgto;
        	
        	if (operatorMailAddress != null && !operatorMailAddress.equals("")) {
        		to =  egovMessageSource.getMessage("ezEmail.0hun03", locale) + " <" + operatorMailAddress + ">";
        	}
        	
        	logger.debug("to=" + to);
        }
        // in case of board/Community
        else if (_url.equals("") && (_cmd.equals("board") || _cmd.equals("Community")
        		|| _cmd.equals("boardDotNet") || _cmd.equals("CommunityDotNet"))) {
        	boardID = request.getParameter("boardID") == null ? "" : request.getParameter("boardID");
        	itemID = request.getParameter("itemID") == null ? "" : request.getParameter("itemID");
        	retransType = request.getParameter("retransType") == null ? "" : request.getParameter("retransType");
        	
        	if (_cmd.equals("boardDotNet") || _cmd.equals("CommunityDotNet")) {
        		dotNetUrl = ezCommonService.getTenantConfig("dotNetUrl", loginInfo.getTenantId());
        	}
        }
        // in case of approvalG
        else if (_url.equals("") && (_cmd.equals("docsend") || _cmd.equals("docsendDotNet"))) {
    		docID = request.getParameter("docID") == null ? "" : request.getParameter("docID").trim();
    		docHref = request.getParameter("docHref") == null ? "" : request.getParameter("docHref").trim();
    		docImagCnt = request.getParameter("imagCnt") == null ? "" : request.getParameter("imagCnt").trim();
    		docTarget = request.getParameter("target") == null ? "" : request.getParameter("target").trim();
    		
        	if (_cmd.equals("docsendDotNet")) {
        		dotNetUrl = ezCommonService.getTenantConfig("dotNetUrl", loginInfo.getTenantId());
        	}
    		
    		/* 2017-01-26 이효민 : 필요하지 않아 주석처리
    		 * 현재 docHref가 IMAGE로만 오고있기 때문에 HolderDocSend는 항상 보이지 않는다(jsp페이지의 HolderDocSend도 주석처리해놓음)
    		if (this._DocHref.ToLower().IndexOf(".doc") == this._DocHref.Length - 4 || this._DocHref.ToLower().IndexOf(".hwp") == this._DocHref.Length - 4)
            {
                _cmd = "docsenddoc";
            }
            else
            {
                this.HolderDocSend.Visible = true;
            }
            if (_DocHref.Equals("IMAGE"))
                this.HolderDocSend.Visible = false;

            if (!_DocHref.Equals("IMAGE"))
            {
                FileInfo fi = new FileInfo(Server.MapPath(_DocHref));
                if (fi.Exists)
                {
                    docfilesize = fi.Length;
                }
            }*/
        
        }
        // when _url is passed in from the client
        else if (!_url.equals("")) {
    		long uid = 0;
			int index = _url.lastIndexOf("/");			
			
			// separate the passed-in url into a folder path and a message uid
			if (index != -1) {
				folderPath = _url.substring(0, index);
				url = _url.substring(index + 1);
				uid = Long.parseLong(url);
			}
			logger.debug("folderPath=" + folderPath + ",url=" + url);
        	
			try {
				ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
						userAccount, password, egovMessageSource, locale, ezEmailUtil);
				
	    		Folder orgFolder = ia.getFolder(folderPath);
	    		orgFolder.open(Folder.READ_ONLY);       
	    		
				// retrieve the Drafts folder name
	        	String draftsFolderName = ezEmailUtil.getDraftsFolderId(locale);
	    		
	        	// retrieve the Sent folder name
	        	String sentFolderName = ezEmailUtil.getSentFolderId(locale);
	        	
	    		// retrieve the specified message.
				Message orgMessage = ((IMAPFolder)orgFolder).getMessageByUID(uid);
				
				if (orgMessage != null) {				        	
		        	// in case of editing a message in Drafts folder.
		        	if (folderPath.equals(draftsFolderName) && _cmd.equals("EDIT")) {
		        		
		        		if (orgMessage.getFrom() != null && orgMessage.getFrom()[0] != null) {
		        			from = ((InternetAddress)orgMessage.getFrom()[0]).getAddress();
		        		}
		        		
						// retrieve the TO addresses from the message.
						Address[] addresses = orgMessage.getRecipients(Message.RecipientType.TO);
						to = ezEmailUtil.getStringListOfAddresses(addresses, true);
						
						// retrieve the CC addresses from the message.
						addresses = orgMessage.getRecipients(Message.RecipientType.CC);
						cc = ezEmailUtil.getStringListOfAddresses(addresses, true);
						
						// retrieve the BCC addresses from the message.
						addresses = orgMessage.getRecipients(Message.RecipientType.BCC);
						bcc = ezEmailUtil.getStringListOfAddresses(addresses, true);
						
						// retrieve the subject from the message.
						subject = ezEmailUtil.getSubject(orgMessage);
						subject = (subject != null) ? subject : "";
						
						// analyze the message and retrieve the attached file list.
						List<Map<String, String>> attachedFileList = new ArrayList<Map<String, String>>();
						List<String> bodyInfoList = ezEmailUtil.getBodyInfo(orgMessage, folderPath, uid, -1, attachedFileList, false, false, locale, null, null);					
						tempBody = bodyInfoList.get(0);
						
						if (attachedFileList.size() > 0) {
			                StringBuilder attachXmlList = new StringBuilder("<ROOT><NODES>");	
			                
			                multipartFirstIdx = attachedFileList.get(0).get("index");
			                logger.debug("EDIT multipartFirstIdx=" + multipartFirstIdx);
			                
							for (int i = 0; i < attachedFileList.size(); i++) {
								Map<String, String> fileInfo = attachedFileList.get(i);
								
				                attachXmlList.append("<NODE>");
				                //TODO : <PUPLOADSN>" + (i + 1) + "</PUPLOADSN> 으로 수정(인덱스로 파일 지울 때)
				                attachXmlList.append("<PUPLOADSN>" + EgovStringUtil.getSpclStrCnvr(fileInfo.get("filename")) + "</PUPLOADSN>");
				                attachXmlList.append("<RESULTUPLOADA>true</RESULTUPLOADA>");
				                attachXmlList.append("<PFILENAME>" + EgovStringUtil.getSpclStrCnvr(fileInfo.get("filename")) + "</PFILENAME>");
				                attachXmlList.append("<FILESIZE>" + fileInfo.get("size") + "</FILESIZE>");
				                attachXmlList.append("<FILELOCATION>" + uid + "</FILELOCATION>");
				                attachXmlList.append("<PBIGFILEUPLOAD>N</PBIGFILEUPLOAD>");
				                attachXmlList.append("</NODE>");
							}
							
			                attachXmlList.append("</NODES></ROOT>");						
			                attach = attachXmlList.toString();	
						}
						
						//임시보관함의 메일을 수정할 때에는 서명사용안함이 default.
	                    mailSignSel = "0";
		        	}
		        	// in case of resending
	        		else if (folderPath.equals(sentFolderName) && _cmd.equals("RESEND")) {
		        		//임시보관함에 메시지 임시저장
		        		SMTPAccess sa = SMTPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.SMTPPort"),
		        				userAccount, password);
		        		MimeMessage resendMessage = sa.createMimeMessage();
		        		
		        		resendMessage.setFlag(Flags.Flag.SEEN, true);
		        		
		        		if (orgMessage.isMimeType("multipart/related")) {
			        		MimeMultipart relatedPart = new MimeMultipart("related");
			        		
			        		if (ezEmailUtil.copyInlineParts(orgMessage, relatedPart, false)) {
			        			resendMessage.setContent(relatedPart);
			        		}	        			
			        		else {
			        			resendMessage.setText("placeholder");
			        		}	        					        		
	        			}
	        			else if (orgMessage.isMimeType("multipart/*")) {
			                MimeMultipart mixedPart = new MimeMultipart();
			                
			                ezEmailUtil.copyAllPartsInMultipart(orgMessage, mixedPart);
			                
			                resendMessage.setContent(mixedPart);	    
	        			}
	        			else {
	        				resendMessage.setText("placeholder");
	        			}
		        		
		        		Folder draftsFolder = ia.getFolder(draftsFolderName);
		        		draftsFolder.open(Folder.READ_WRITE);       
		        		long draftUID = 0;
		        		AppendUID[] uids = ((IMAPFolder)draftsFolder).appendUIDMessages(new Message[]{resendMessage});
		        		if (uids != null && uids[0] != null) {
		        			draftUID = uids[0].uid;
		        		} 	        		
		        		url = String.valueOf(draftUID);
		        		logger.debug("draftUID=" + draftUID);
		        		draftsFolder.close(true);
		        		//END: 임시보관함에 메시지 임시저장
		        		
		        		reSendFlag = "Y";
		        		
		        		Address[] addresses = orgMessage.getAllRecipients();
		        		
		        		for (Address address : addresses) {
		        			if (((InternetAddress)address).getAddress().equalsIgnoreCase(msgto)) {
								to = ezEmailUtil.getStringListOfAddresses(new Address[]{address}, true);
								break;
								
		        			} else {
		        				// 재작성시 메세지에서 수신인을 뽑아내어 넣어준다. 
		        				if (useReSend.equals("YES") && msgto.equals("")) {
		        					addresses = orgMessage.getRecipients(Message.RecipientType.TO);
									String[] rawHeaders = orgMessage.getHeader("From");
									String rawHeader = rawHeaders != null ? rawHeaders[0] : "";		
									boolean isPureAscii = ezEmailUtil.isPureAscii(rawHeader);
									
									if (isPureAscii) {
										rawHeaders = orgMessage.getHeader("To");
										rawHeader = rawHeaders != null ? rawHeaders[0] : "";
										isPureAscii = ezEmailUtil.isPureAscii(rawHeader);
									}
									
									to = ezEmailUtil.getStringListOfAddresses(addresses, isPureAscii);
			
									// retrieve the CC addresses from the reply message.
									addresses = orgMessage.getRecipients(Message.RecipientType.CC);
									
									if (addresses != null) {
										rawHeaders = orgMessage.getHeader("Cc");
										rawHeader = rawHeaders != null ? rawHeaders[0] : "";																					
										cc = ezEmailUtil.getStringListOfAddresses(addresses, ezEmailUtil.isPureAscii(rawHeader));
									}
									
									// retrieve the BCC addresses from the reply message.
									addresses = orgMessage.getRecipients(Message.RecipientType.BCC);
									bcc = ezEmailUtil.getStringListOfAddresses(addresses, true);
		        					
									break;
		        				}
		        			}
		        		}
		        		
		        		subject = orgMessage.getSubject();
						subject = (subject != null) ? subject : "";
		        		
						List<Map<String, String>> attachedFileList = new ArrayList<Map<String, String>>();		            
						List<String> bodyInfoList = ezEmailUtil.getBodyInfo(orgMessage, folderPath, uid, -1, attachedFileList, false, false, locale, null, null);					
						bodyValue = bodyInfoList.get(0);
		        		
		        		if (attachedFileList.size() > 0) {
			                StringBuilder attachXmlList = new StringBuilder("<ROOT><NODES>");	
			                
			                multipartFirstIdx = attachedFileList.get(0).get("index");
			                logger.debug("RESEND multipartFirstIdx=" + multipartFirstIdx);
			                
							for (int i = 0; i < attachedFileList.size(); i++) {
								Map<String, String> fileInfo = attachedFileList.get(i);
								
				                attachXmlList.append("<NODE>");
				                //TODO : <PUPLOADSN>" + (i + 1) + "</PUPLOADSN> 으로 수정(인덱스로 파일 지울 때)
				                attachXmlList.append("<PUPLOADSN>" + EgovStringUtil.getSpclStrCnvr(fileInfo.get("filename")) + "</PUPLOADSN>");
				                attachXmlList.append("<RESULTUPLOADA>true</RESULTUPLOADA>");
				                attachXmlList.append("<PFILENAME>" + EgovStringUtil.getSpclStrCnvr(fileInfo.get("filename")) + "</PFILENAME>");
				                attachXmlList.append("<FILESIZE>" + fileInfo.get("size") + "</FILESIZE>");
				                attachXmlList.append("<FILELOCATION>" + uid + "</FILELOCATION>");
				                attachXmlList.append("<PBIGFILEUPLOAD>N</PBIGFILEUPLOAD>");
				                attachXmlList.append("</NODE>");
							}
							
			                attachXmlList.append("</NODES></ROOT>");						
			                attach = attachXmlList.toString();				                
						}
		        		
		                unread = orgMessage.isSet(Flags.Flag.SEEN) ? "1" : "0";
		                
		                //TODO: Sensitivity?
		                //this._posttype = ((int)orgmesg.Sensitivity).ToString();
		        		
		                //메일 재전송할 때에는 서명사용안함이 default.
	                    mailSignSel = "0";
		        	}
		        	// in case of replying
		        	else if (_cmd.equals("REPLY") || _cmd.equals("REPLYALL") || _cmd.equals("FORWARD")) {
		        		Message replyMessage = null; 
		        		
		        		// reply call is needed to create 'References' & 'In-Reply-To' headers.
		        		if (_cmd.equals("REPLY") || _cmd.equals("FORWARD")) {
		        			replyMessage = orgMessage.reply(false);
		        		}
		        		else {
		        			replyMessage = orgMessage.reply(true);
		        		}
		        		
		        		// ANSWERED flag needs to be cleared since the above reply method sets it.
		        		orgMessage.setFlag(Flags.Flag.ANSWERED, false);
		        		
		        		replyMessage.setFlag(Flags.Flag.SEEN, true);
	
		        		if (_cmd.equals("FORWARD")) {
		        			if (orgMessage.isMimeType("multipart/related")) {
				        		MimeMultipart relatedPart = new MimeMultipart("related");
				        		boolean isThereHtmlPart = ezEmailUtil.isThereHtmlPartInRelatedPart(relatedPart);
				        		// text/html 파트가 없으면 인라인 이미지 파트를 첨부파일 파트로 변환한다.(이미지를 첨부로 대신 표시하기 위해)
				        		boolean convertInlineImageToAttachment = isThereHtmlPart ? false : true;
				        		
				        		logger.debug("convertInlineImageToAttachment=" + convertInlineImageToAttachment);
				        		
				        		if (ezEmailUtil.copyInlineParts(orgMessage, relatedPart, true, convertInlineImageToAttachment)) {
				        			replyMessage.setContent(relatedPart);
				        		}	        			
				        		else {
				        			replyMessage.setText("placeholder");
				        		}	        					        		
		        			}
		        			else if (orgMessage.isMimeType("multipart/*")) {
				                MimeMultipart mixedPart = new MimeMultipart();
				                
				                ezEmailUtil.copyAllPartsInMultipart(orgMessage, mixedPart);
				                
				                replyMessage.setContent(mixedPart);	    
		        			}
		        			else {
		        				replyMessage.setText("placeholder");
		        			}
		        		}
		        		else {
			        		MimeMultipart relatedPart = new MimeMultipart("related");
			        		
			        		if (ezEmailUtil.copyInlineParts(orgMessage, relatedPart, false)) {
			        			replyMessage.setContent(relatedPart);
			        		}
			        		else {
			        			replyMessage.setText("placeholder");
			        		}	        		
		        		}
	
		        		Address[] addresses = null;
		        		if (_cmd.equals("REPLY") || _cmd.equals("REPLYALL")) {
							// retrieve the TO addresses from the reply message.
							addresses = replyMessage.getRecipients(Message.RecipientType.TO);
							String[] rawHeaders = orgMessage.getHeader("From");
							String rawHeader = rawHeaders != null ? rawHeaders[0] : "";		
							boolean isPureAscii = ezEmailUtil.isPureAscii(rawHeader);
							if (isPureAscii) {
								rawHeaders = orgMessage.getHeader("To");
								rawHeader = rawHeaders != null ? rawHeaders[0] : "";
								isPureAscii = ezEmailUtil.isPureAscii(rawHeader);
							}
							to = ezEmailUtil.getStringListOfAddresses(addresses, isPureAscii);
	
							// retrieve the CC addresses from the reply message.
							addresses = replyMessage.getRecipients(Message.RecipientType.CC);
							if (addresses != null) {
								rawHeaders = orgMessage.getHeader("Cc");
								rawHeader = rawHeaders != null ? rawHeaders[0] : "";																					
								cc = ezEmailUtil.getStringListOfAddresses(addresses, ezEmailUtil.isPureAscii(rawHeader));
							}
							
							// retrieve the BCC addresses from the reply message.
							addresses = replyMessage.getRecipients(Message.RecipientType.BCC);
							bcc = ezEmailUtil.getStringListOfAddresses(addresses, true);
		        		}
						
						// retrieve the subject from the message.
						subject = ezEmailUtil.getSubject(orgMessage);
						
						if (subject != null && !subject.equals("")) {
							String[] rawHeaders = orgMessage.getHeader("subject");
							String rawHeader = rawHeaders[0];
							
							// if the subject contains Non-Ascii characters(violating the standard), 
							// try to decode it by examining the characters.							
							if (!ezEmailUtil.isPureAscii(rawHeader)) {
								byte[] rawBytes = rawHeader.getBytes("iso-8859-1");
								
								subject = ezEmailUtil.decodeNonAsciiBytes(rawBytes);
							}
						}
						
						subject = (subject != null) ? subject : "";
						String reStr = ""; 
								
						if (_cmd.equals("REPLY") || _cmd.equals("REPLYALL")) {		
							reStr = egovMessageSource.getMessage("ezEmail.t511", locale);
						}
						else if (_cmd.equals("FORWARD")) {
							reStr = egovMessageSource.getMessage("ezEmail.t513", locale);
						}
						
						if (!subject.startsWith(reStr)) {
							subject = reStr + ": " + subject;
						}
		        		
						// retrieve the TO addresses from the original message.
						addresses = orgMessage.getRecipients(Message.RecipientType.TO);
						String[] rawHeaders = orgMessage.getHeader("To");
						String rawHeader = rawHeaders != null ? rawHeaders[0] : "";													
						String orgTo = ezEmailUtil.getStringListOfAddresses(addresses, ezEmailUtil.isPureAscii(rawHeader));
						
						// retrieve the CC addresses from the original message.
						addresses = orgMessage.getRecipients(Message.RecipientType.CC);
						rawHeaders = orgMessage.getHeader("Cc");
						rawHeader = rawHeaders != null ? rawHeaders[0] : "";																			
						String orgCc = ezEmailUtil.getStringListOfAddresses(addresses, ezEmailUtil.isPureAscii(rawHeader));
						
			            StringBuilder sb = new StringBuilder();
			            sb.append("<hr tabindex=\"-1\">");
			            sb.append("<p " + defaultFontAndSize + ">");
			            sb.append(String.format("<b>%s : </b> %s", egovMessageSource.getMessage("ezEmail.t703", locale), EgovStringUtil.getSpclStrCnvr(ezEmailUtil.getFullFromAddressOfMessage(orgMessage).replaceAll("<a@a.com>", ""))));
			            sb.append("</p>");
			            
			            //set received date
			            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss ( z )");
			            String offset = loginInfo.getOffset();
			            if (offset == null || offset.indexOf("|") == -1) {
			    			logger.error("Check the offset. Offset is null or offset format is wrong.");
			    		} else {
			    			String[] offsetArr = offset.split("\\|");
			    			sdf.setTimeZone(TimeZone.getTimeZone("GMT" + offsetArr[1]));
			    		}
			            sb.append("<p " + defaultFontAndSize + ">");
			            sb.append(String.format("<b>%s : </b> %s", egovMessageSource.getMessage("ezEmail.t704", locale), sdf.format(orgMessage.getReceivedDate()).replace("GMT", "")));
			            sb.append("</p>");
			            //to-do
			            sb.append("<p " + defaultFontAndSize + ">");
			            sb.append(String.format("<b>%s : </b> %s", egovMessageSource.getMessage("ezEmail.t705", locale), EgovStringUtil.getSpclStrCnvr(orgTo.replaceAll("<a@a.com>", ""))));
			            sb.append("</p>");
			            
			            sb.append("<p " + defaultFontAndSize + ">");
			            sb.append(String.format("<b>%s : </b> %s", egovMessageSource.getMessage("ezEmail.t706", locale), EgovStringUtil.getSpclStrCnvr(orgCc.replaceAll("<a@a.com>", ""))));
			            sb.append("</p>");
			            
			            String orgMessageSubject = ezEmailUtil.getSubject(orgMessage);	
						if (orgMessageSubject != null && !orgMessageSubject.equals("")) {
							rawHeaders = orgMessage.getHeader("subject");
							rawHeader = rawHeaders[0];
							
							// if the subject contains Non-Ascii characters(violating the standard), 
							// try to decode it by examining the characters.							
							if (!ezEmailUtil.isPureAscii(rawHeader)) {
								byte[] rawBytes = rawHeader.getBytes("iso-8859-1");
								
								orgMessageSubject = ezEmailUtil.decodeNonAsciiBytes(rawBytes);
							}
						}
						
						sb.append("<p " + defaultFontAndSize + ">");
				        sb.append(String.format("<b>%s : </b> %s", egovMessageSource.getMessage("ezEmail.t707", locale), EgovStringUtil.getSpclStrCnvr(orgMessageSubject)));
				        sb.append("</p>");
				        sb.append("<br/><br/>");
				            
						// analyze the message and retrieve the attached file list.
						List<Map<String, String>> attachedFileList = new ArrayList<Map<String, String>>();		            
						List<String> bodyInfoList = ezEmailUtil.getBodyInfo(orgMessage, folderPath, uid, -1, attachedFileList, false, false, locale, null, null);					
						String tmphtmlbody = bodyInfoList.get(0);
			            
			            bodyValue = sb.toString() + tmphtmlbody;
			            
			            // 원본 메일 내용에 메일 서명 존재 시 변환 처리
		                if (bodyValue.contains("id=\"MailSignSent\"") || bodyValue.contains("id=MailSignSent")) {
		                	bodyValue = bodyValue.replaceAll("MailSignSent", "MailSignSent___send");
		                	bodyValue = bodyValue.replaceAll("kaoni_sign1", "kaoni_sign1___send");
		                	bodyValue = bodyValue.replaceAll("kaoni_sign2", "kaoni_sign2___send");
		                	bodyValue = bodyValue.replaceAll("kaoni_sign3", "kaoni_sign3___send");
		                }
		                bodyValue = bodyValue.replaceAll("ORGMAIL_CONTENT", "ORGMAIL_CONTENT___send");
		                bodyValue = bodyValue.replaceAll("div id=\"MailSign\"", "div ");
		                
		                bodyValue = bodyValue.replaceAll("id=msgbody", "");
	
		                if (cmdOwn.equals("REPLY") || cmdOwn.equals("REPLYALL") || cmdOwn.equals("FORWARD")) {
		                	bodyValue = bodyValue.replaceAll("class=&quot;FIELD&quot;", "");
		                	bodyValue = bodyValue.replaceAll("class=FIELD", "");
		                	bodyValue = "<body free>" + bodyValue + "</body>";
		                }
		                
		                //임시보관함에 저장
		        		Folder draftsFolder = ia.getFolder(draftsFolderName);
		        		draftsFolder.open(Folder.READ_WRITE);       
		        		
		        		long draftUID = 0;
		        		AppendUID[] uids = ((IMAPFolder)draftsFolder).appendUIDMessages(new Message[]{replyMessage});
		        		if (uids != null && uids[0] != null) {
		        			draftUID = uids[0].uid;
		        		} 	        		
		        		url = String.valueOf(draftUID);
		        		
		        		logger.debug("draftUID=" + draftUID);
		        		
		        		draftsFolder.close(true);
		                
		        		//첨부파일 정보 추출
		        		if (_cmd.equals("FORWARD")) {
							if (attachedFileList.size() > 0) {
								List<Map<String, String>> attachedFileListInReply = new ArrayList<Map<String, String>>();	
								
								// replyMessage의 첨부 파일 구성이 orgMessage와 다르게 될 수 있기 때문에 다시 첨부파일 정보를 구하도록 한다.
								ezEmailUtil.getBodyInfo(replyMessage, folderPath, uid, -1, attachedFileListInReply, false, false, locale, null, null);					
								
				                StringBuilder attachXmlList = new StringBuilder("<ROOT><NODES>");	
				                
				                multipartFirstIdx = attachedFileListInReply.get(0).get("index");
				                logger.debug("FORWARD multipartFirstIdx=" + multipartFirstIdx);
				                
								for (int i = 0; i < attachedFileListInReply.size(); i++) {
									Map<String, String> fileInfo = attachedFileListInReply.get(i);
									
					                attachXmlList.append("<NODE>");
					                //TODO : <PUPLOADSN>" + (i + 1) + "</PUPLOADSN> 으로 수정(인덱스로 파일 지울 때)
					                attachXmlList.append("<PUPLOADSN>" + EgovStringUtil.getSpclStrCnvr(fileInfo.get("filename")) + "</PUPLOADSN>");
					                attachXmlList.append("<RESULTUPLOADA>true</RESULTUPLOADA>");
					                attachXmlList.append("<PFILENAME>" + EgovStringUtil.getSpclStrCnvr(fileInfo.get("filename")) + "</PFILENAME>");
					                attachXmlList.append("<FILESIZE>" + fileInfo.get("size") + "</FILESIZE>");
					                attachXmlList.append("<FILELOCATION>" + uid + "</FILELOCATION>");
					                attachXmlList.append("<PBIGFILEUPLOAD>N</PBIGFILEUPLOAD>");
					                attachXmlList.append("</NODE>");
								}
								
				                attachXmlList.append("</NODES></ROOT>");						
				                attach = attachXmlList.toString();				                
							}											            	
			            }
		        		
		        	}
		        	
		        	if(_cmd.equals("EDIT")) {
		        		logger.debug("EDIT MODE : set mail option start");
		        		
		        		//set importance
		        		if (orgMessage.getHeader("X-Priority") != null) {
		        			String tempImportance = orgMessage.getHeader("X-Priority")[0];
		        			if (tempImportance.equals("1")) {
		        				importance = "2";
		        			} else if (tempImportance.equals("5")) {
		        				importance = "0";
		        			} else {
		        				importance = "1";
		        			}
		        		}
		        		logger.debug("importance=" + importance);
		        	
		        		//set isEachMail
		        		if (orgMessage.getHeader("X-JMocha-Each-Mail") != null) {
		        			isEach = orgMessage.getHeader("X-JMocha-Each-Mail")[0];
		        		}
		        		//set isSecureMail
		        		if (orgMessage.getHeader("X-JMocha-Secure-Mail") != null) {
		        			isSecureMail = orgMessage.getHeader("X-JMocha-Secure-Mail")[0];
		        		}
		        		
		        		//set bodyType
		        		bodyType = isHtmlMessage(orgMessage) ? "0" : "1";
		        		
		        		if (orgMessage.getHeader("Return-Receipt-To") != null) {
		        			replySendTime = "1";
		        		} else {
		        			replySendTime = "0";
		        		}
		        		
		        		if (orgMessage.getHeader("Disposition-Notification-To") == null) {
		        			replyReadTime = "0";
		        		}
		        	
		        		if (orgMessage.getHeader("Delivery-Date") != null) {
		        			delaySendDate = orgMessage.getHeader("Delivery-Date")[0].trim();
		        		} else {
		        			delaySendDate = "";
		        		}
		        		
		        		logger.debug("EDIT MODE : set mail option end");
		        	}
				}
				orgFolder.close(true);
				
			} catch (MessagingException e) {
				if (e.getMessage().indexOf("NO APPEND failed.") > -1) {
					model.addAttribute("overQuota", true);
				}
				e.printStackTrace();
			} finally {
				if (ia != null) {
					ia.close();        	
				}
			}
			
        }
        //업무일지면 작동
        else if(_cmd.equals("journal")){
        	journalId = request.getParameter("journalId");
        }
        //근태관리
        else if(_cmd.equals("attitude")) {
        	attitudeId = request.getParameter("attitudeId");        			
        }
        //근태관리 미입력자 메일발송
        else if (_cmd.equals("attitudeAbsented")) {
        	model.addAttribute("moduleType", "attitudeAbsented");
        	model.addAttribute("companyId", request.getParameter("companyId"));
        	model.addAttribute("searchUserName", request.getParameter("userName"));
        	model.addAttribute("searchDeptName", request.getParameter("deptName"));
        	model.addAttribute("searchTitle", request.getParameter("title"));
        	model.addAttribute("searchDeptId", request.getParameter("deptId"));
        	model.addAttribute("searchStartDate", request.getParameter("startDate"));
        	model.addAttribute("searchEndDate", request.getParameter("endDate"));
//        	model.addAttribute("pageNum", request.getParameter("pageNum"));
//        	model.addAttribute("listSize", request.getParameter("listSize"));
//        	model.addAttribute("orderCell", request.getParameter("orderCell"));
//        	model.addAttribute("orderOption", request.getParameter("orderOption"));
        }
        String useFromAddress = ezCommonService.getTenantConfig("Use_FromAddress", loginInfo.getTenantId());
		String fromAddressHtml = "";
		
		if (useFromAddress != null) {
			if (useFromAddress.equals("YES")) {
				List<String[]> fromAddressList = ezEmailService.getAliasAddress(loginInfo.getId(), loginInfo.getTenantId());
				
				if (fromAddressList.size() < 2) {
					useFromAddress = "NO";
				} else {
					StringBuilder sb = new StringBuilder();
					sb.append("<select id='ex_select' onchange='fromAddressChange(this.value)'>");
					
					boolean isValidFrom = false;
					
					for (String[] address : fromAddressList) {
						if (from.equals(address[0])) {
							isValidFrom = true;
							break;
						}
					}
					
					if (!isValidFrom) {
						from = loginInfo.getEmail();
					}
					
					for (String[] address : fromAddressList) {
						if (from.equals(address[0])) {
							sb.append("<option value='" + address[0] + "' selected>" + address[0] + "</option>");
						} else {
							sb.append("<option value='" + address[0] + "'>" + address[0] + "</option>");
						}
					}
					
					sb.append("</select>");
					sb.append("<label for='ex_select'>" + from + "</label>");
					
					fromAddressHtml = sb.toString();
				}
			}
		} else {
			useFromAddress = "NO";
		}
		
        String browser = ClientUtil.getClientInfo(request, "browser");
		boolean isCrossBrowser = browser.equals("IE9") ? false : true;
		
		String useOnlyInnerMail = ezCommonService.getTenantConfig("UseOnlyInnerMail", loginInfo.getTenantId());
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("tenantId", loginInfo.getTenantId());
		model.addAttribute("to", to);
		model.addAttribute("cc", cc);
		model.addAttribute("bcc", bcc);
		//model.addAttribute("body", body);
		model.addAttribute("subject", subject);
		model.addAttribute("encodedSubject", EgovStringUtil.getSpclStrCnvr(subject));
		model.addAttribute("importance", importance);
		model.addAttribute("isEach", isEach);
		model.addAttribute("useSecureMail", useSecureMail);
		model.addAttribute("isSecureMail", isSecureMail);
		model.addAttribute("bodyType", bodyType);
		model.addAttribute("replySendTime", replySendTime);
		model.addAttribute("replyReadTime", replyReadTime);
		model.addAttribute("delaySendDate", delaySendDate);
		model.addAttribute("postType", postType);
		model.addAttribute("url", url);
		model.addAttribute("attach", attach);
		model.addAttribute("_cmd", _cmd);
		model.addAttribute("unread", unread);
		model.addAttribute("boardID", boardID);
		model.addAttribute("itemID", itemID);
		model.addAttribute("docHref", docHref);
		model.addAttribute("docID", docID);
		model.addAttribute("docImagCnt", docImagCnt);
		model.addAttribute("docTarget", docTarget);
		model.addAttribute("retransType", retransType);
		model.addAttribute("useMultiLangMail", useMultiLangMail);
		model.addAttribute("displayNamePrintable", displayNamePrintable);
		model.addAttribute("charsetCheck", charsetCheck);
		model.addAttribute("userLang", userLang);
		model.addAttribute("userPrimary", userPrimary);
		model.addAttribute("reSendFlag", reSendFlag);
		model.addAttribute("mailAttachLimit", mailAttachLimit);
		model.addAttribute("bigSizeMailAttachLimit", bigSizeMailAttachLimit);
		model.addAttribute("totBigSizeMailAttachLimit", totBigSizeMailAttachLimit);
		model.addAttribute("bigSizeMailAttachDelDate", bigSizeMailAttachDelDate);
		model.addAttribute("userTimeset", userTimeset);
		model.addAttribute("cmdOwn", cmdOwn);
		model.addAttribute("urlOwn", urlOwn);
		model.addAttribute("mailSign1", mailSign1);
		model.addAttribute("mailSign2", mailSign2);
		model.addAttribute("mailSign3", mailSign3);
		model.addAttribute("mailSignSel", mailSignSel);
		model.addAttribute("bodyValue", bodyValue);
		model.addAttribute("fileUploadType", fileUploadType);
		model.addAttribute("folderPath", folderPath);
		model.addAttribute("tempBody", tempBody);
		model.addAttribute("newWindowId", newWindowId);
		model.addAttribute("individualMailUser", individualMailUser); //int형
		model.addAttribute("pSecurity", pSecurity);
		model.addAttribute("stateName", stateName);
		model.addAttribute("pBigAttachDownloadDay", pBigAttachDownloadDay);
		model.addAttribute("pBigAttachDownloadPeriod", pBigAttachDownloadPeriod);
		model.addAttribute("pAutoSaveTime", pAutoSaveTime);
		model.addAttribute("pAttachWarning", pAttachWarning);
		model.addAttribute("mailSendObject", mailSendObject);
		model.addAttribute("mailInnerDomain", mailInnerDomain);
		model.addAttribute("inMailColor", inMailColor);
		model.addAttribute("outMailColor", outMailColor);
		model.addAttribute("useEditor", useEditor);
		model.addAttribute("serverName", serverName);
		model.addAttribute("uploadCommonPath", commonUtil.getUploadPath("upload_common.ROOT", loginInfo.getTenantId()));
		model.addAttribute("uploadCommunityPath", commonUtil.getUploadPath("upload_community.ROOT", loginInfo.getTenantId()));
		model.addAttribute("isCrossBrowser", isCrossBrowser);
		model.addAttribute("useFromAddress", useFromAddress);
		model.addAttribute("fromAddressHtml", fromAddressHtml);
		model.addAttribute("dotNetUrl", dotNetUrl);
		model.addAttribute("useOnlyInnerMail", useOnlyInnerMail);
		model.addAttribute("defaultFontAndSize", defaultFontAndSize);
		model.addAttribute("useLetter", useLetter);
		model.addAttribute("useMailWriteSenderClick", useMailWriteSenderClick); // 수아 추가
		model.addAttribute("drafts", ezEmailUtil.getDraftsFolderId(locale)); // 임시보관함 스트링 추가 (윤진) 
		model.addAttribute("multipartFirstIdx", multipartFirstIdx);
		model.addAttribute("useMailAddrAutoComplete", useMailAddrAutoComplete); // 20180531 조진호 추가
		
		//업무일지 아이디
		model.addAttribute("journalId", journalId);
		
		//근태관리
		model.addAttribute("attitudeId", attitudeId);
		
		response.setHeader("X-XSS-Protection", "0");
		
		logger.debug("mailWrite ended.");
		return "ezEmail/mailWrite";
	}
	
	/**
	 * 메일 저장 여부를 묻는 확인 다이알로그 표시
	 */
	@RequestMapping(value="/ezEmail/mailConfirmDialog.do")
	public String mailConfirmDialog(
					@CookieValue("loginCookie") String loginCookie,
					@RequestParam("CAPTION") String caption,
					@RequestParam("MESSAGE") String message,
					@RequestParam("BUTTONNAMES") String buttonNames,
					HttpServletRequest request,
					LoginVO userInfo,
					Model model) throws Exception {
		logger.debug("mailConfirmDialog started.");
		
		userInfo = commonUtil.userInfo(loginCookie);
		
		caption = caption != null ? caption : "";
		message = message != null ? message : "";
		buttonNames = buttonNames != null ? buttonNames : "";
		
		String buttonName0 = "";
		String buttonName1 = "";
		String buttonName2 = "";
		String[] buttonNamesArray = buttonNames.split(",");
		
		if (userInfo.getLang().equals("3")) {
			buttonNamesArray = buttonNames.split("、");
		}
		
		for (int i = 0; i < buttonNamesArray.length; i++) {
			switch (i) {
			case 0: buttonName0 = buttonNamesArray[i]; break;
			case 1: buttonName1 = buttonNamesArray[i]; break;
			case 2: buttonName2 = buttonNamesArray[i]; break;
			}
		}
		
		model.addAttribute("caption", caption);
		model.addAttribute("message", message);
		model.addAttribute("buttonName0", buttonName0);
		model.addAttribute("buttonName1", buttonName1);
		model.addAttribute("buttonName2", buttonName2);
		
		logger.debug("mailConfirmDialog ended.");
		return "ezEmail/mailConfirmDialog";
	}
	
	/**
	 * 메일 파일첨부 화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/dragAndDrop.do")
	public String dragAndDropIframe(
			@CookieValue("loginCookie") String loginCookie, 
			LoginVO userInfo, 
			Model model) throws Exception{
		
		userInfo = commonUtil.userInfo(loginCookie);
		
		String attachFileNameMaxLength = ezCommonService.getTenantConfig("attachFileNameMaxLength", userInfo.getTenantId());
		
		if (attachFileNameMaxLength.equals("")) {
			attachFileNameMaxLength = "100";
		}
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("attachFileNameMaxLength", attachFileNameMaxLength);
		
		return "ezEmail/mailDragAndDrop";
	}

	/**
	 * 메일 DragAndDrop 첨부파일 업로드 실행 함수
	 */
	@RequestMapping(value="/ezEmail/mailInterUploadXCK.do", produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String mailInterUpload(
			@CookieValue("loginCookie") String loginCookie, 
			MultipartHttpServletRequest request) throws Exception{
		logger.debug("mailInterUploadXCK started.");
		
		String strXML = "";
		String strXML2 = "";
		String folderDate = "";
		String tempFolderName = "";
		String xmlList = "";
		String isBigYN = "N";
		List<MultipartFile> multiFile = request.getFiles("fileToUpload");
		int cnt = 0;
		
		if (request.getParameter("cnt") != null && !request.getParameter("cnt").equals("")) {
			cnt = Integer.parseInt(request.getParameter("cnt"));
		}
		
		String realPath = commonUtil.getRealPath(request);
		String[] pFileName = new String[cnt];
		Long[] fileSize = new Long[cnt];
		String[] fileLocation = new String[cnt];
		String[] resultUpload = new String[cnt];
		String[] sGUID = new String[cnt];
		String pBigFileUpload = "";
		String[] sFileTitle = new String[cnt];
		String[] sExt = new String[cnt];
		String pDirTempPath = "";
		long bigMaxSize = 0;
		long changeSize = 0;

		if (request.getParameter("STATUS") != null && !request.getParameter("STATUS").equals("")) {
			tempFolderName = request.getParameter("STATUS");
		} else {
			return "NODATA";
		}
		
		if (multiFile == null) {
			return "NODATA";
		}
		
		if (request.getParameter("isbigyn") != null) {
			isBigYN = request.getParameter("isbigyn");
		}
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String useExtension = ezCommonService.getTenantConfig("USE_FileExtension", userInfo.getTenantId());
		
		if (useExtension == null) {
			useExtension = "";
		}
		
		if (multiFile.get(0).getOriginalFilename() != null && StringUtils.isNotBlank(multiFile.get(0).getOriginalFilename())){
			boolean isEmpty = false;
			String _pFileName = "";
			for (int i=0; i<cnt; i++) {
				_pFileName = multiFile.get(i).getOriginalFilename();
				if (_pFileName.indexOf(commonUtil.separator) > 0) {
					_pFileName = _pFileName.split(commonUtil.separator)[_pFileName.split(commonUtil.separator).length - 1];
				}
				pFileName[i] = _pFileName;
				if (pFileName[i].lastIndexOf(".") > -1) {
					sFileTitle[i] = pFileName[i].substring(0, pFileName[i].lastIndexOf("."));
					sExt[i] = pFileName[i].substring(pFileName[i].lastIndexOf(".") + 1);
				} else {
					sFileTitle[i] = pFileName[i];
					sExt[i] = "";
				}
				
				if (multiFile.get(i).getSize() == 0) {
					isEmpty = true;
				}
			}
			
			if (isEmpty) {
				return "OVERFLOW";
			}
		}

		for (int i = 0; i < cnt; i++) {
			sGUID[i] = UUID.randomUUID().toString() + "." + sExt[i];
		}

		if (request.getParameter("bigmaxsize") != null) {
			bigMaxSize = Long.parseLong(request.getParameter("bigmaxsize"));
		}
		
		if (request.getParameter("changesize") != null) {
			changeSize = Long.parseLong(request.getParameter("changesize"));
		}

		strXML = "<ROOT><NODES>";
		String pDirPath = commonUtil.getUploadPath("upload_mail.ROOT", userInfo.getTenantId());
		pDirPath = realPath + pDirPath;
		
		// check the upload mail root folder and create it if it isn't exist.
		File uploadMailRootFolder = new File(pDirPath);
		if (!uploadMailRootFolder.exists()) {
			logger.debug("creating uploadMailRootFolder=" + uploadMailRootFolder);
			uploadMailRootFolder.mkdirs();
		}
		
		for (int i=0; i<cnt; i++) {
			fileSize[i] = multiFile.get(i).getSize();
			if (fileSize[i] > changeSize || isBigYN.equals("Y")) {
                String pDate = EgovDateUtil.getToday("");
                folderDate = pDate;
                pDirTempPath = pDirPath + commonUtil.separator + pDate;
                File file = new File(pDirTempPath);
                
                if (!file.exists()) {
                	file.mkdirs();
                }
                
                pBigFileUpload = "Y";
                
                pFileName[i] = commonUtil.normalizeFileName(pFileName[i]);
                
                String base64OrgFileName = Base64.encodeBase64String(pFileName[i].getBytes("UTF-8"));
                FileOutputStream fos = null;
                
                try {
                	File f = new File(pDirTempPath + commonUtil.separator + sGUID[i] + "__.txt");
                	fos = new FileOutputStream(f);
                    fos.write(base64OrgFileName.getBytes("ISO-8859-1"));
                } catch(Exception e) {
                	throw e;
                } finally {
                	if (fos != null) {
                		fos.close();
                	}
                }
            } else {
                pDirTempPath = pDirPath + commonUtil.separator + "tempFileUpload";
                pBigFileUpload = "N";
            }
			
			File f = new File(pDirTempPath);
			if (!f.exists()) {
				f.mkdirs();
            }
			
			if (fileSize[i] > bigMaxSize && bigMaxSize != 0) {
                resultUpload[i] = "overflow";
            } else {
                if (useExtension.toLowerCase().indexOf(sExt[i].toLowerCase()) == -1 && !useExtension.equals("*")) {
                    resultUpload[i] = "denied";
                } else {
                    writeUploadedFile(multiFile.get(i), sGUID[i], pDirTempPath);
                    fileLocation[i] = pDirTempPath + commonUtil.separator + sGUID[i];
                    resultUpload[i] = "true";
                }
                
                strXML2 += "<NODE><PUPLOADSN><![CDATA[" + sGUID[i] + "]]></PUPLOADSN>";
                strXML2 += "<RESULTUPLOADA><![CDATA[" + resultUpload[i] + "]]></RESULTUPLOADA>";
                strXML2 += "<PFILENAME><![CDATA[" + pFileName[i] + "]]></PFILENAME>";
                strXML2 += "<FILESIZE><![CDATA[" + fileSize[i] + "]]></FILESIZE>";
                if (pBigFileUpload.equals("Y")) {
                	strXML2 += "<FILELOCATION><![CDATA[" + folderDate+"|!|"+sGUID[i] + "]]></FILELOCATION>";
                } else {
                	strXML2 += "<FILELOCATION><![CDATA[" + sGUID[i] + "]]></FILELOCATION>";
                }
                strXML2 += "<PBIGFILEUPLOAD><![CDATA[" + pBigFileUpload + "]]></PBIGFILEUPLOAD>";
                strXML2 += "</NODE>";
            }
            pDirTempPath = "";
		}
		
		strXML += strXML2 + "</NODES></ROOT>";

        String xmlPath = pDirPath + commonUtil.separator + "templist";
        File f = new File(xmlPath);
        if (!f.exists()) {
			f.mkdirs();
        }

        xmlPath += commonUtil.separator + tempFolderName + ".txt";
        f = new File(xmlPath);
        
        if (f.exists()) {
        	String tempXmlList = "";
        	InputStreamReader isr = null;
        	BufferedReader br = null;
        	OutputStreamWriter osw = null;
        	
        	try {
	        	isr = new InputStreamReader(new FileInputStream(f));
	        	br = new BufferedReader(isr);
	        	int read = 0;
				
	        	while ((read = br.read()) != -1) {
					tempXmlList += (char)read;
				}
				
				Document xmldom = commonUtil.convertStringToDocument(tempXmlList);
				Document xmldom2 = commonUtil.convertStringToDocument(strXML);
				
	            NodeList nodeList = xmldom.getElementsByTagName("NODES");
	            NodeList nodeList2 = xmldom2.getElementsByTagName("NODE");
	            
	            for (int i=0; i<nodeList2.getLength(); i++) {
	            	nodeList.item(0).appendChild(xmldom.importNode(nodeList2.item(i), true));
	            }
            	
	            osw = new OutputStreamWriter(new FileOutputStream(f));
            	osw.write(commonUtil.convertDocumentToString(xmldom));
            	String crlf = System.getProperty("line.separator");
        		osw.append(crlf+crlf);
	            
	            xmlList = strXML;
        	} catch(Exception e) {
        		throw e;
        	} finally {
        		if (br != null) {
        			br.close();
        		}
        		if (isr != null) {
        			isr.close();
        		}
        		if (osw != null) {
        			osw.close();
        		}
        	}
        	
        } else {
        	OutputStreamWriter osw = null;
        	
        	try {
        		osw = new OutputStreamWriter(new FileOutputStream(f));
        		osw.write(strXML);
        		String crlf = System.getProperty("line.separator");
        		osw.append(crlf+crlf);
        		xmlList = strXML;
        	} catch(Exception e) {
        		throw e;
        	} finally {
        		if (osw != null) {
        			osw.close();
        		}
        	}
        }
        
        logger.debug("mailInterUploadXCK ended.");
        return xmlList;
	}
	
	/**
	 * <pre>
	 * 메일 DragAndDrop 첨부파일 업로드 실행 함수
	 * - 게시판/커뮤니티/전자결재에서 메일로 전송 시.
	 * - 서버에 이미 업로드 되어있는 첨부파일을 복사해옴.
	 * - 일반 첨부파일에만 해당됨.
	 * </pre>
	 */
	@RequestMapping(value="/ezEmail/mailInterUploadCopyXCK.do", produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String mailInterUploadCopy(
			@CookieValue("loginCookie") String loginCookie, 
			@RequestBody String bodyData,
			HttpServletRequest request) throws Exception {
		logger.debug("mailInterUploadCopy started.");
		logger.debug("bodyData=" + bodyData);
		
		String tempFolderName = request.getParameter("STATUS") == null ? "" : request.getParameter("STATUS");
		String isBigYN = request.getParameter("isbigyn") == null ? "" : request.getParameter("isbigyn"); //isBigYN은 항상 N
		logger.debug("tempFolderName=" + tempFolderName + ",isBigYN=" + isBigYN);
		
		Document doc = commonUtil.convertStringToDocument(bodyData);
		String bigMaxSizeStr = doc.getElementsByTagName("BIGMAXSIZE").item(0).getTextContent();
		long bigMaxSize = Long.parseLong(bigMaxSizeStr);
		
		String changeSizeStr = doc.getElementsByTagName("CHANGESIZE").item(0).getTextContent();	
		int changeSize = Integer.parseInt(changeSizeStr);
		
		String endDate = doc.getElementsByTagName("ENDDAY").item(0).getTextContent();	
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String realPath = commonUtil.getRealPath(request);
		String uploadMailRootPath = realPath + commonUtil.getUploadPath("upload_mail.ROOT", userInfo.getTenantId());
		String pTempFileUploadPath = uploadMailRootPath + commonUtil.separator + "tempFileUpload";
		String pTempListPath = uploadMailRootPath + commonUtil.separator + "templist";
		
		String useExtension = ezCommonService.getTenantConfig("USE_FileExtension", userInfo.getTenantId());
		
		int fileCnt = doc.getElementsByTagName("ROW").getLength();
		String[] fileName = new String[fileCnt];
		String[] filePath = new String[fileCnt];
		long[] fileSize = new long[fileCnt];
		String[] fileExt = new String[fileCnt];
		String[] newFileName = new String[fileCnt];
		boolean[] downloadedFlags = new boolean[fileCnt];
		
		int totalFileSize = 0;
		
		if (tempFolderName.equals("")) {
			logger.debug("tempFolderName is EMPTY. Return NODATA.");
			logger.debug("mailInterUploadCopy ended.");
			
			return "NODATA";
		}
		
		String dotNetIntegration = ezCommonService.getTenantConfig("dotNetIntegration", userInfo.getTenantId());
		String dotNetUrl = ezCommonService.getTenantConfig("dotNetUrl", userInfo.getTenantId());
		
		for (int i = 0; i < fileCnt; i++) {
			String filePathValue = doc.getElementsByTagName("DATA2").item(i).getTextContent();		
			filePathValue = filePathValue != null ? filePathValue : "";
			
			if (!filePathValue.startsWith("/")) {
				filePathValue = "/" + filePathValue;
			}
			
			filePath[i] = realPath + filePathValue;
			
			if (dotNetIntegration.equals("YES")) {
				try {
					File f = new File(filePath[i]);
					
					// 닷넷 연동 시 첨부 파일이 존재하지 않으면 암호화된 파일일 수 있으므로 복호화 URL을 호출하여 다운로드를 시도해 본다.
					if (!f.exists()) {						
						String downloadUrl = dotNetUrl + "/myoffice/Common/DownloadAttach_java.aspx?filename=placeholder"
									+ "&filepath=" + URLEncoder.encode(filePathValue, "UTF-8");
						
						logger.debug("downloadUrl=" + downloadUrl);
						
						// 다운로드된 파일을 저장할 로컬 파일명을 임의로 생성한다.
						String localFilePath = pTempFileUploadPath + commonUtil.separator + UUID.randomUUID().toString();
						File localFile = new File(localFilePath);
						
						// URL로부터 다운로드를 시도한다.
						FileUtils.copyURLToFile(new URL(downloadUrl), localFile);
						
						logger.debug("downloaded File Size is " + localFile.length());
						
						if (localFile.length() != 0) {
							// 다운로드한 파일의 Path로 filePath를 변경한다.
							filePath[i] = localFilePath;
							// 다운로드한 파일을 사용 후 삭제하기 위해 다운로드한 파일임을 표시한다.
							downloadedFlags[i] = true;
						// 파일 크기가 0인 경우는 다운로드가 되지 않은 경우이므로 생성된 파일을 삭제한다.
						} else {
							localFile.delete();
						}
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			
			File f = new File(filePath[i]);
			
			if (f.exists()) {
				fileName[i] = doc.getElementsByTagName("DATA1").item(i).getTextContent();
				fileName[i] = fileName[i].replaceAll("[\\\\/:*?\"<>|]", "_");
				
				if (fileName[i].lastIndexOf(".") > -1) {
					fileExt[i] = fileName[i].substring(fileName[i].lastIndexOf(".") + 1);
					newFileName[i] = UUID.randomUUID().toString() + "." + fileExt[i];
				} else {
					fileExt[i] = "";
					newFileName[i] = UUID.randomUUID().toString();
				}
				
				fileSize[i] = f.length();
				totalFileSize += fileSize[i];
			} else {
				logger.debug("Cannot find the file : " + filePath[i]);
				filePath[i] = "NOFILE";
			}
		}
		
		// 총 파일의 크기가 대용량첨부 제한크기를 넘는지 체크한다.
		if (bigMaxSize != 0 && totalFileSize > bigMaxSize) {
			logger.debug("totalFileSize is over bigMaxSize. Return OVERFLOW.");
			
			if (dotNetIntegration.equals("YES")) {
				for (int i = 0; i < fileCnt; i++) {
					// 복호화 URL을 통해 다운로드한 임시 파일들을 삭제한다.
					if (downloadedFlags[i]) {
						logger.debug("deleting " + filePath[i]);
						
						File localFile = new File(filePath[i]);
						
						localFile.delete();
					}
				}
			}
			
			logger.debug("mailInterUploadCopy ended.");
			
			return "OVERSIZE";
		}
		
		StringBuilder sb = new StringBuilder();
		sb.append("<ROOT><NODES>");
		
		if (totalFileSize > changeSize) { // 대용량첨부의 경우
			logger.debug("In case of big attachment.");
			
			// 현재 날짜의 폴더가 없으면 생성한다.
			String folderDate = EgovDateUtil.getToday("");
			String bigAttachFolderPath = uploadMailRootPath + commonUtil.separator + folderDate;
            File file = new File(bigAttachFolderPath);
            
            if (!file.exists()) {
            	file.mkdirs();
            }
            
            for (int i = 0; i < fileCnt; i++) {
            	if (filePath[i].equals("NOFILE")) {
					continue;
				}
            	
            	FileInputStream fis = null;
				FileOutputStream fos = null;
				BufferedInputStream bis = null;
				BufferedOutputStream bos = null;
                
				try {
                	// 게시판의 첨부파일을 대용량첨부 폴더쪽으로 복사한다.
					fis = new FileInputStream(filePath[i]);
					bis = new BufferedInputStream(fis);
					
					fos = new FileOutputStream(bigAttachFolderPath + commonUtil.separator + newFileName[i]);
					bos = new BufferedOutputStream(fos);
					
					int data = 0;
					byte[] buffer = new byte[BUFF_SIZE];
					
					while ((data = bis.read(buffer, 0, BUFF_SIZE)) != -1) {
						bos.write(buffer, 0, data);
					}
					
					bos.close(); bos = null;
					bis.close(); bis = null;
					fos.close(); fos = null;
					fis.close(); fis = null;
					
					// 첨부파일의 original 이름을 base64로 인코딩하여 첨부파일__.txt에 저장한다.
                	String base64OrgFileName = Base64.encodeBase64String(newFileName[i].getBytes("UTF-8"));
                	
                	file = new File(bigAttachFolderPath + commonUtil.separator + newFileName[i] + "__.txt");
                	fos = new FileOutputStream(file);
                	fos.write(base64OrgFileName.getBytes("ISO-8859-1"));
                	
                	//첨부파일 정보를 XML data로 만든다.
                    String resultUpload = "";
                    
    				if (useExtension.toLowerCase().indexOf(fileExt[i].toLowerCase()) == -1 && !useExtension.equals("*")) {
                        resultUpload = "denied";
                    } else {
                        resultUpload = "true";
                    }
    				
    				sb.append("<NODE>");
    				sb.append("<PUPLOADSN><![CDATA[" + newFileName[i] + "]]></PUPLOADSN>");
    				sb.append("<RESULTUPLOADA><![CDATA[" + resultUpload + "]]></RESULTUPLOADA>");
    				sb.append("<PFILENAME><![CDATA[" + fileName[i] + "]]></PFILENAME>");
    				sb.append("<FILESIZE><![CDATA[" + fileSize[i] + "]]></FILESIZE>");
    				sb.append("<FILELOCATION><![CDATA[" + folderDate + "|!|" + newFileName[i] + "]]></FILELOCATION>");
    				sb.append("<PBIGFILEUPLOAD>Y</PBIGFILEUPLOAD>");
    				sb.append("</NODE>");					
                } catch(Exception e) {
                	e.printStackTrace();
                } finally {
                	if (bos != null) {
                		try { bos.close(); } catch(Exception e) {}
                	}
                	if (bis != null) {
                		try { bis.close(); } catch(Exception e) {}
                	}
                	if (fos != null) {
                		try { fos.close(); } catch(Exception e) {}
                	}
                	if (fis != null) {
                		try { fis.close(); } catch(Exception e) {}
                	}
                }                
            }            
		} else { // 일반첨부의 경우
			logger.debug("In case of common attachment.");
			
			File file = new File(pTempFileUploadPath);
			
			if (!file.exists()) {
				file.mkdirs();
			}
			
			for (int i = 0; i < fileCnt; i++) {
				if (filePath[i].equals("NOFILE")) {
					continue;
				}
				
				FileInputStream fis = null;
				FileOutputStream fos = null;
				BufferedInputStream bis = null;
				BufferedOutputStream bos = null;
				
				try {
					// 게시판의 첨부파일을 메일 첨부파일 임시폴더쪽으로 복사한다.
					fis = new FileInputStream(filePath[i]);
					bis = new BufferedInputStream(fis);
					
					String nfcFilename = commonUtil.normalizeFileName(newFileName[i]);
					
					fos = new FileOutputStream(pTempFileUploadPath + commonUtil.separator + nfcFilename);
					bos = new BufferedOutputStream(fos);
					
					int data = 0;
					byte[] buffer = new byte[BUFF_SIZE];
					
					while ((data = bis.read(buffer, 0, BUFF_SIZE)) != -1) {
						bos.write(buffer, 0, data);
					}
					
					//첨부파일 정보를 XML data로 만든다.
					String resultUpload = "";
					
					if (useExtension.toLowerCase().indexOf(fileExt[i].toLowerCase()) == -1 && !useExtension.equals("*")) {
	                    resultUpload = "denied";
	                } else {
	                    resultUpload = "true";
	                }
					
					sb.append("<NODE>");
					sb.append("<PUPLOADSN><![CDATA[" + nfcFilename + "]]></PUPLOADSN>");
					sb.append("<RESULTUPLOADA><![CDATA[" + resultUpload + "]]></RESULTUPLOADA>");
					sb.append("<PFILENAME><![CDATA[" + fileName[i] + "]]></PFILENAME>");
					sb.append("<FILESIZE><![CDATA[" + fileSize[i] + "]]></FILESIZE>");
					sb.append("<FILELOCATION><![CDATA[" + newFileName[i] + "]]></FILELOCATION>");
					sb.append("<PBIGFILEUPLOAD>N</PBIGFILEUPLOAD>");
					sb.append("</NODE>");					
				} catch (Exception e) {
					e.printStackTrace();
				} finally {
					if (bos != null) {
                		try { bos.close(); } catch(Exception e) {}
                	}
                	if (bis != null) {
                		try { bis.close(); } catch(Exception e) {}
                	}
					if (fos != null) {
						try { fos.close(); } catch(Exception e){}
					}
					if (fis != null) {
						try { fis.close(); } catch(Exception e){}
					}
				}
			}			
		}
		
		sb.append("</NODES></ROOT>");
		
		if (dotNetIntegration.equals("YES")) {
			for (int i = 0; i < fileCnt; i++) {
				// 복호화 URL을 통해 다운로드한 임시 파일들을 삭제한다.
				if (downloadedFlags[i]) {
					logger.debug("deleting " + filePath[i]);
					
					File localFile = new File(filePath[i]);
					
					localFile.delete();
				}
			}
		}
		
		// templist폴더에 메일에 대한 첨부파일 정보를 가지고있는 txt파일 생성한다.
        File f = new File(pTempListPath);
        
        if (!f.exists()) {
			f.mkdirs();
        }
        
        f = new File(pTempListPath + commonUtil.separator + tempFolderName + ".txt");
		OutputStreamWriter outWrite = null;
		
    	try {
    		outWrite = new OutputStreamWriter(new FileOutputStream(f));
    		outWrite.write(sb.toString());
    		String crlf = System.getProperty("line.separator");
    		outWrite.append(crlf+crlf);
    	} catch(Exception e) {
    		e.printStackTrace();
    	} finally {
    		if (outWrite != null) {
    			try { outWrite.close(); } catch (Exception e) {}
    		}
    	}
		
		logger.debug("mailInterUploadCopy ended.");
		
		return sb.toString();
	}
	
	/**
	 * <pre>
	 * 메일 DragAndDrop 첨부파일 업로드 실행 함수
	 * - 게시판/커뮤니티/전자결재에서 메일로 전송 시.
	 * - 서버에 이미 업로드 되어있는 첨부파일을 복사해옴.
	 * - 일반 첨부파일에만 해당됨.
	 * </pre>
	 */
	@RequestMapping(value="/ezEmail/mailInterUploadCopyXCKFromJournal.do", produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String mailInterUploadCopyFromJournal(
			@CookieValue("loginCookie") String loginCookie, 
			@RequestBody String bodyData,
			HttpServletRequest request) throws Exception {
		logger.debug("mailInterUploadCopy started.");
		logger.debug("bodyData=" + bodyData);
		
		String tempFolderName = request.getParameter("STATUS") == null ? "" : request.getParameter("STATUS");
		String isBigYN = request.getParameter("isbigyn") == null ? "" : request.getParameter("isbigyn"); //isBigYN은 항상 N
		logger.debug("tempFolderName=" + tempFolderName + ",isBigYN=" + isBigYN);
		
		Document doc = commonUtil.convertStringToDocument(bodyData);
		String bigMaxSizeStr = doc.getElementsByTagName("BIGMAXSIZE").item(0).getTextContent();
		long bigMaxSize = Long.parseLong(bigMaxSizeStr);
		
		String changeSizeStr = doc.getElementsByTagName("CHANGESIZE").item(0).getTextContent();	
		int changeSize = Integer.parseInt(changeSizeStr);
		
		String endDate = doc.getElementsByTagName("ENDDAY").item(0).getTextContent();	
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String realPath = commonUtil.getRealPath(request);
		
		String journalPath = realPath + commonUtil.getUploadPath("upload_journal.ROOT", userInfo.getTenantId())+ commonUtil.separator +"uploadFile";
		
		String uploadMailRootPath = realPath + commonUtil.getUploadPath("upload_mail.ROOT", userInfo.getTenantId());
		String pTempFileUploadPath = uploadMailRootPath + commonUtil.separator + "tempFileUpload";
		String pTempListPath = uploadMailRootPath + commonUtil.separator + "templist";
		
		String useExtension = ezCommonService.getTenantConfig("USE_FileExtension", userInfo.getTenantId());
		
		int fileCnt = doc.getElementsByTagName("ROW").getLength();
		String[] fileName = new String[fileCnt];
		String[] filePath = new String[fileCnt];
		long[] fileSize = new long[fileCnt];
		String[] fileExt = new String[fileCnt];
		String[] newFileName = new String[fileCnt];
		boolean[] downloadedFlags = new boolean[fileCnt];
		
		int totalFileSize = 0;
		
		if (tempFolderName.equals("")) {
			logger.debug("tempFolderName is EMPTY. Return NODATA.");
			logger.debug("mailInterUploadCopy ended.");
			
			return "NODATA";
		}
		
		String dotNetIntegration = ezCommonService.getTenantConfig("dotNetIntegration", userInfo.getTenantId());
		String dotNetUrl = ezCommonService.getTenantConfig("dotNetUrl", userInfo.getTenantId());
		
		for (int i = 0; i < fileCnt; i++) {
			String filePathValue = doc.getElementsByTagName("DATA2").item(i).getTextContent();		
			filePathValue = filePathValue != null ? filePathValue : "";
			
//			if (!filePathValue.startsWith("/")) {
//				filePathValue = "/" + filePathValue;
//			}
			
			filePath[i] = journalPath + filePathValue;
			
			if (dotNetIntegration.equals("YES")) {
				try {
					File f = new File(filePath[i]);
					
					// 닷넷 연동 시 첨부 파일이 존재하지 않으면 암호화된 파일일 수 있으므로 복호화 URL을 호출하여 다운로드를 시도해 본다.
					if (!f.exists()) {						
						String downloadUrl = dotNetUrl + "/myoffice/Common/DownloadAttach_java.aspx?filename=placeholder"
								+ "&filepath=" + URLEncoder.encode(filePathValue, "UTF-8");
						
						logger.debug("downloadUrl=" + downloadUrl);
						
						// 다운로드된 파일을 저장할 로컬 파일명을 임의로 생성한다.
						String localFilePath = pTempFileUploadPath + commonUtil.separator + UUID.randomUUID().toString();
						File localFile = new File(localFilePath);
						
						// URL로부터 다운로드를 시도한다.
						FileUtils.copyURLToFile(new URL(downloadUrl), localFile);
						
						logger.debug("downloaded File Size is " + localFile.length());
						
						if (localFile.length() != 0) {
							// 다운로드한 파일의 Path로 filePath를 변경한다.
							filePath[i] = localFilePath;
							// 다운로드한 파일을 사용 후 삭제하기 위해 다운로드한 파일임을 표시한다.
							downloadedFlags[i] = true;
							// 파일 크기가 0인 경우는 다운로드가 되지 않은 경우이므로 생성된 파일을 삭제한다.
						} else {
							localFile.delete();
						}
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			
			File f = new File(filePath[i]);
			
			if (f.exists()) {
				fileName[i] = doc.getElementsByTagName("DATA1").item(i).getTextContent();
				fileName[i] = fileName[i].replaceAll("[\\\\/:*?\"<>|]", "_");
				
				if (fileName[i].lastIndexOf(".") > -1) {
					fileExt[i] = fileName[i].substring(fileName[i].lastIndexOf(".") + 1);
					newFileName[i] = UUID.randomUUID().toString() + "." + fileExt[i];
				} else {
					fileExt[i] = "";
					newFileName[i] = UUID.randomUUID().toString();
				}
//				newFileName[i] = newFileName[i].substring(newFileName[i].lastIndexOf(";")+1);
				
				fileSize[i] = f.length();
				totalFileSize += fileSize[i];
			} else {
				logger.debug("Cannot find the file : " + filePath[i]);
				filePath[i] = "NOFILE";
			}
		}
		
		// 총 파일의 크기가 대용량첨부 제한크기를 넘는지 체크한다.
		if (bigMaxSize != 0 && totalFileSize > bigMaxSize) {
			logger.debug("totalFileSize is over bigMaxSize. Return OVERFLOW.");
			
			if (dotNetIntegration.equals("YES")) {
				for (int i = 0; i < fileCnt; i++) {
					// 복호화 URL을 통해 다운로드한 임시 파일들을 삭제한다.
					if (downloadedFlags[i]) {
						logger.debug("deleting " + filePath[i]);
						
						File localFile = new File(filePath[i]);
						
						localFile.delete();
					}
				}
			}
			
			logger.debug("mailInterUploadCopy ended.");
			
			return "OVERSIZE";
		}
		
		StringBuilder sb = new StringBuilder();
		sb.append("<ROOT><NODES>");
		
		if (totalFileSize > changeSize) { // 대용량첨부의 경우
			logger.debug("In case of big attachment.");
			
			// 현재 날짜의 폴더가 없으면 생성한다.
			String folderDate = EgovDateUtil.getToday("");
			String bigAttachFolderPath = uploadMailRootPath + commonUtil.separator + folderDate;
			File file = new File(bigAttachFolderPath);
			
			if (!file.exists()) {
				file.mkdirs();
			}
			
			for (int i = 0; i < fileCnt; i++) {
				if (filePath[i].equals("NOFILE")) {
					continue;
				}
				
				FileInputStream fis = null;
				FileOutputStream fos = null;
				BufferedInputStream bis = null;
				BufferedOutputStream bos = null;
				
				try {
					// 게시판의 첨부파일을 대용량첨부 폴더쪽으로 복사한다.
					fis = new FileInputStream(filePath[i]);
					bis = new BufferedInputStream(fis);
					
					fos = new FileOutputStream(bigAttachFolderPath + commonUtil.separator + newFileName[i]);
					bos = new BufferedOutputStream(fos);
					
					int data = 0;
					byte[] buffer = new byte[BUFF_SIZE];
					
					while ((data = bis.read(buffer, 0, BUFF_SIZE)) != -1) {
						bos.write(buffer, 0, data);
					}
					
					bos.close(); bos = null;
					bis.close(); bis = null;
					fos.close(); fos = null;
					fis.close(); fis = null;
					
					// 첨부파일의 original 이름을 base64로 인코딩하여 첨부파일__.txt에 저장한다.
					String base64OrgFileName = Base64.encodeBase64String(newFileName[i].getBytes("UTF-8"));
					
					file = new File(bigAttachFolderPath + commonUtil.separator + newFileName[i] + "__.txt");
					fos = new FileOutputStream(file);
					fos.write(base64OrgFileName.getBytes("ISO-8859-1"));
					
					//첨부파일 정보를 XML data로 만든다.
					String resultUpload = "";
					
					if (useExtension.toLowerCase().indexOf(fileExt[i].toLowerCase()) == -1 && !useExtension.equals("*")) {
						resultUpload = "denied";
					} else {
						resultUpload = "true";
					}
					
					sb.append("<NODE>");
					sb.append("<PUPLOADSN><![CDATA[" + newFileName[i] + "]]></PUPLOADSN>");
					sb.append("<RESULTUPLOADA><![CDATA[" + resultUpload + "]]></RESULTUPLOADA>");
					sb.append("<PFILENAME><![CDATA[" + fileName[i] + "]]></PFILENAME>");
					sb.append("<FILESIZE><![CDATA[" + fileSize[i] + "]]></FILESIZE>");
					sb.append("<FILELOCATION><![CDATA[" + folderDate + "|!|" + newFileName[i] + "]]></FILELOCATION>");
					sb.append("<PBIGFILEUPLOAD>Y</PBIGFILEUPLOAD>");
					sb.append("</NODE>");					
				} catch(Exception e) {
					e.printStackTrace();
				} finally {
					if (bos != null) {
						try { bos.close(); } catch(Exception e) {}
					}
					if (bis != null) {
						try { bis.close(); } catch(Exception e) {}
					}
					if (fos != null) {
						try { fos.close(); } catch(Exception e) {}
					}
					if (fis != null) {
						try { fis.close(); } catch(Exception e) {}
					}
				}                
			}            
		} else { // 일반첨부의 경우
			logger.debug("In case of common attachment.");
			
			File file = new File(pTempFileUploadPath);
			
			if (!file.exists()) {
				file.mkdirs();
			}
			
			for (int i = 0; i < fileCnt; i++) {
				if (filePath[i].equals("NOFILE")) {
					continue;
				}
				
				FileInputStream fis = null;
				FileOutputStream fos = null;
				BufferedInputStream bis = null;
				BufferedOutputStream bos = null;
				
				try {
					// 게시판의 첨부파일을 메일 첨부파일 임시폴더쪽으로 복사한다.
					fis = new FileInputStream(filePath[i]);
					bis = new BufferedInputStream(fis);
					
					fos = new FileOutputStream(pTempFileUploadPath + commonUtil.separator + newFileName[i]);
					bos = new BufferedOutputStream(fos);
					
					int data = 0;
					byte[] buffer = new byte[BUFF_SIZE];
					
					while ((data = bis.read(buffer, 0, BUFF_SIZE)) != -1) {
						bos.write(buffer, 0, data);
					}
					
					//첨부파일 정보를 XML data로 만든다.
					String resultUpload = "";
					
					if (useExtension.toLowerCase().indexOf(fileExt[i].toLowerCase()) == -1 && !useExtension.equals("*")) {
						resultUpload = "denied";
					} else {
						resultUpload = "true";
					}
					
				//	fileName[i] = fileName[i].substring(fileName[i].lastIndexOf(";")+1);
					sb.append("<NODE>");
					sb.append("<PUPLOADSN><![CDATA[" + newFileName[i] + "]]></PUPLOADSN>");
					sb.append("<RESULTUPLOADA><![CDATA[" + resultUpload + "]]></RESULTUPLOADA>");
					sb.append("<PFILENAME><![CDATA[" + fileName[i] + "]]></PFILENAME>");
					sb.append("<FILESIZE><![CDATA[" + fileSize[i] + "]]></FILESIZE>");
					sb.append("<FILELOCATION><![CDATA[" + newFileName[i] + "]]></FILELOCATION>");
					sb.append("<PBIGFILEUPLOAD>N</PBIGFILEUPLOAD>");
					sb.append("</NODE>");					
				} catch (Exception e) {
					e.printStackTrace();
				} finally {
					if (bos != null) {
						try { bos.close(); } catch(Exception e) {}
					}
					if (bis != null) {
						try { bis.close(); } catch(Exception e) {}
					}
					if (fos != null) {
						try { fos.close(); } catch(Exception e){}
					}
					if (fis != null) {
						try { fis.close(); } catch(Exception e){}
					}
				}
			}			
		}
		
		sb.append("</NODES></ROOT>");
		
		if (dotNetIntegration.equals("YES")) {
			for (int i = 0; i < fileCnt; i++) {
				// 복호화 URL을 통해 다운로드한 임시 파일들을 삭제한다.
				if (downloadedFlags[i]) {
					logger.debug("deleting " + filePath[i]);
					
					File localFile = new File(filePath[i]);
					
					localFile.delete();
				}
			}
		}
		
		// templist폴더에 메일에 대한 첨부파일 정보를 가지고있는 txt파일 생성한다.
		File f = new File(pTempListPath);
		
		if (!f.exists()) {
			f.mkdirs();
		}
		
		f = new File(pTempListPath + commonUtil.separator + tempFolderName + ".txt");
		OutputStreamWriter outWrite = null;
		
		try {
			outWrite = new OutputStreamWriter(new FileOutputStream(f));
			outWrite.write(sb.toString());
			String crlf = System.getProperty("line.separator");
			outWrite.append(crlf+crlf);
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			if (outWrite != null) {
				try { outWrite.close(); } catch (Exception e) {}
			}
		}
		
		logger.debug("mailInterUploadCopy ended.");
		
		return sb.toString();
	}

	/**
     * EzHTTPTrans ActiveX Control로부터 한 개의 파일을 업로드 받아 저장하는 메소드
     */
    @RequestMapping(value="/ezEmail/mailInterUploadX.do", produces = "text/plain; charset=utf-8")
    @ResponseBody
    public String mailInterUploadX(
    		@CookieValue("loginCookie") String loginCookie, 
    		HttpServletRequest request) {
    	logger.debug("mailInterUploadX started.");
    	
        String returnedData = "";
        
        try {
            String strXML = "<ROOT><NODES>";;
            String strXML2 = "";
            
            String sFileTitle = request.getParameter("name");
            String sFileData = request.getParameter("filedata");
            String sExt = request.getParameter("ext");
            String tempFolderName = request.getParameter("dir");
            
            logger.debug("sFileTitle=" + sFileTitle + ",sFileData=" + sFileData + ",sExt=" + sExt + ",tempFolderName=" + tempFolderName);
            
            String pBigFileUpload = sFileData;
            String newguid = UUID.randomUUID().toString();
            String newfilename = newguid + "." + sExt;
            String pDirTempPath = "";
            String extResult = "";
            String pDate = "";
            String useExtension = "";
            long fileSize = 0;
            
            LoginVO userInfo = commonUtil.userInfo(loginCookie);
            
            if (ezCommonService.getTenantConfig("USE_FileExtension", userInfo.getTenantId()) != null) {
                useExtension = ezCommonService.getTenantConfig("USE_FileExtension", userInfo.getTenantId());
            }
            
            String realPath = commonUtil.getRealPath(request);
            String pDirPath = commonUtil.getUploadPath("upload_mail.ROOT", userInfo.getTenantId());
            pDirPath = realPath + pDirPath;
            
            if (pBigFileUpload.equals("Y")) {
                // 대용량 첨부파일인 경우에는 오늘 날짜를 이름으로 갖는 폴더를 사용한다.
                pDate = EgovDateUtil.getToday("");
                pDirTempPath = pDirPath + commonUtil.separator + pDate;
            } else {
                // 일반 첨부파일인 경우에는 tempFileUpload 폴더를 사용한다.
                pDirTempPath = pDirPath + commonUtil.separator + "tempFileUpload";
            }
    
            File f = new File(pDirTempPath);
    
            // 파일을 업로드할 폴더가 존재하지 않으면 생성한다.            
            if (!f.exists()) {
                f.mkdirs();
            }
            
            // 업로드된 데이터를 저장할 파일의 패스명
            String saveLocalPath = pDirTempPath + commonUtil.separator + newfilename;
            String orgFileName = sFileTitle + "." + sExt;            
            
            // 지원하지 않는 파일 확장자명을 갖고 있는 경우에는 거부한다.
            if (useExtension.toLowerCase().indexOf(sExt.toLowerCase()) == -1 && !useExtension.equals("*")) {
                extResult = "denied";
            } else {
                // 대용량 첨부파일의 경우에는 후에 다운로드 받을 때 파일명을 내려보내기 위해 원 파일명을 저장한다.                
                if (pBigFileUpload.equals("Y")) {                    
                    String base64OrgFileName = Base64.encodeBase64String(orgFileName.getBytes("UTF-8"));
                    FileOutputStream fos = null;
                    
                    try {
                        File nameFile = new File(saveLocalPath + "__.txt");
                        fos = new FileOutputStream(nameFile);
                        fos.write(base64OrgFileName.getBytes("ISO-8859-1"));
                    } catch (Exception e) {
                        throw e;
                    } finally {
                        if (fos != null) {
                            fos.close();
                        }
                    }
                }
                
                InputStream stream = null;
                OutputStream bos = null;         
                
                try {
                    // HTTP Body로부터 데이터를 읽어 로컬 파일에 저장한다.
                    stream = request.getInputStream();
                    bos = new FileOutputStream(saveLocalPath);
                
                    int bytesRead = 0;
                    byte[] buffer = new byte[BUFF_SIZE];
            
                    while ((bytesRead = stream.read(buffer, 0, BUFF_SIZE)) != -1) {
                        bos.write(buffer, 0, bytesRead);
                        fileSize += bytesRead;
                    }
                } catch (Exception e) {
                    throw e;                
                } finally {
                    if (bos != null) {
                        try {
                            bos.close();
                        } catch (Exception ignore) {
                        }
                    }
                    if (stream != null) {
                        try {
                            stream.close();
                        } catch (Exception ignore) {
                        }
                    }
                }
                                            
                extResult = "true";
            }
            
            strXML2 += "<NODE><PUPLOADSN><![CDATA[" + newfilename + "]]></PUPLOADSN>";
            strXML2 += "<RESULTUPLOADA><![CDATA[" + extResult + "]]></RESULTUPLOADA>";
            strXML2 += "<PFILENAME><![CDATA[" + orgFileName + "]]></PFILENAME>";
            strXML2 += "<FILESIZE><![CDATA[" + fileSize + "]]></FILESIZE>";
            if (pBigFileUpload.equals("Y")) {
                strXML2 += "<FILELOCATION><![CDATA[" + pDate + "|!|" + newfilename + "]]></FILELOCATION>";
            } else {
                strXML2 += "<FILELOCATION><![CDATA[" + newfilename + "]]></FILELOCATION>";
            }
            strXML2 += "<PBIGFILEUPLOAD><![CDATA[" + pBigFileUpload + "]]></PBIGFILEUPLOAD>";
            strXML2 += "</NODE>";
            
            strXML += strXML2 + "</NODES></ROOT>";
            
            String xmlPath = pDirPath + commonUtil.separator + "templist";
            f = new File(xmlPath);
            if (!f.exists()) {
                f.mkdirs();
            }

            xmlPath += commonUtil.separator + tempFolderName + ".txt";
            f = new File(xmlPath);
            if (f.exists()) {
                String tempXmlList = "";
                InputStreamReader isr = null;
                BufferedReader br = null;
                OutputStreamWriter osw = null;
                try {
                    isr = new InputStreamReader(new FileInputStream(f));
                    br = new BufferedReader(isr);
                    int read = 0;
                    while ((read = br.read()) != -1) {
                        tempXmlList += (char)read;
                    }
                    Document xmldom = commonUtil.convertStringToDocument(tempXmlList);
                    Document xmldom2 = commonUtil.convertStringToDocument(strXML);
                    
                    NodeList nodeList = xmldom.getElementsByTagName("NODES");
                    NodeList nodeList2 = xmldom2.getElementsByTagName("NODE");
                    for (int i=0; i<nodeList2.getLength(); i++) {
                        nodeList.item(0).appendChild(xmldom.importNode(nodeList2.item(i), true));
                    }
                    osw = new OutputStreamWriter(new FileOutputStream(f));
                    osw.write(commonUtil.convertDocumentToString(xmldom));
                    String crlf = System.getProperty("line.separator");
                    osw.append(crlf+crlf);
                } catch(Exception e) {
                    throw e;
                } finally {
                    if (br != null) {
                        br.close();
                    }
                    if (isr != null) {
                        isr.close();
                    }
                    if (osw != null) {
                        osw.close();
                    }
                }
            } else {
                OutputStreamWriter osw = null;
                try {
                    osw = new OutputStreamWriter(new FileOutputStream(f));
                    osw.write(strXML);
                    String crlf = System.getProperty("line.separator");
                    osw.append(crlf+crlf);
                } catch(Exception e) {
                    throw e;
                } finally {
                    if (osw != null) {
                        osw.close();
                    }
                }
            }
            
            if (pBigFileUpload.equals("Y")) {
                returnedData = pDate + "|!|" + newfilename + "_kaonisplit_" + pBigFileUpload + "_" + extResult;
            } else {
                returnedData = newfilename + "_kaonisplit_" + pBigFileUpload + "_" + extResult;
            }
        } catch (Exception e) {
            e.printStackTrace();
            
            returnedData = "ERROR";
        }
        
        logger.debug("returnedData=" + returnedData);
        logger.debug("mailInterUploadX ended.");
        
        return returnedData;
    }
	
    /**
	 * 첨부파일을 포함한 메일을 임시 보관함에 저장하는 함수
	 */
	@RequestMapping(value="/ezEmail/mailInterAttachCK.do", produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String mailInterAttach(
			@CookieValue("loginCookie") String loginCookie, 
			Locale locale, 
			HttpServletRequest request) throws Exception{
		logger.debug("mailInterAttach started.");
		
		String returnValue = "";
		String cmd = "";
		Document xmldom = commonUtil.convertRequestToDocument(request);
		cmd = xmldom.getElementsByTagName("CMD").item(0).getTextContent();
		String uidStr = xmldom.getElementsByTagName("URL").item(0).getTextContent();
		NodeList bigs = xmldom.getElementsByTagName("BIG");
		boolean hasAttachFile = false;
		
		if (bigs != null) {
			
			for (int i = 0; i < bigs.getLength(); i++) {
				
				if (bigs.item(i).getTextContent().equals("N")) {
				    // 일반첨부파일이 있는 경우
					hasAttachFile = true;
					break;
				}
			}
		}
		
		List<String> userInfo = commonUtil.getUserIdAndPassword(loginCookie);
		String password  = userInfo.get(1);
		
		long uid = 0;
		
		if (uidStr != null && !uidStr.equals("")) {
			uid = Long.parseLong(uidStr);
		}
		
		LoginVO loginInfo = commonUtil.userInfo(loginCookie);
		
		String realPath = commonUtil.getRealPath(request);
		String pDirTempPath = realPath + commonUtil.getUploadPath("upload_mail.ROOT", loginInfo.getTenantId()) + commonUtil.separator + "tempFileUpload";
		String domainName = ezCommonService.getTenantConfig("DomainName", loginInfo.getTenantId());
		String userEmail = loginInfo.getId() + "@" + domainName;
		
		MimeMessage newMessage = null;
		IMAPAccess ia = null;
		Folder folder = null;
		Multipart multipart = null;
		
		try {
			
			if (hasAttachFile) {
				SMTPAccess sa = SMTPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.SMTPPort"),
						userEmail, password);
				
				// 첨부파일들을 추가하여 임시 보관함에 저장할 메시지를 생성한다.
				newMessage = sa.createMimeMessage();
				
				ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
						userEmail, password, egovMessageSource, locale, ezEmailUtil);
				
				// 임시 보관함 폴더 오픈 
				folder = ia.getFolder(ezEmailUtil.getDraftsFolderId(locale));
				folder.open(Folder.READ_WRITE);
				
				// 첨부파일 Part들을 삽입할 Multipart를 생성한다.
				multipart = new MimeMultipart();
			}
			
			if (cmd.equals("ADD")) {
				NodeList fileNodes = xmldom.getElementsByTagName("FILE");
				
				// 임시 보관함에 이미 기존 메시지가 있는 경우, 해당 메시지의 파트들을 새 메시지에 병합한다.
				if (hasAttachFile && uid != 0) {
				    // 임시 보관함에 있는 메시지를 가져온다.
					Message oldMessage = ((IMAPFolder)folder).getMessageByUID(uid);
					
					if (oldMessage != null) {
					    // 기존 메시지가 Multipart인 경우 처리
						if (oldMessage.getContent() instanceof Multipart) {
							Multipart mp = (Multipart)oldMessage.getContent();
							int count = mp.getCount();
							BodyPart p = null;
							
							// 임시 보관함에 있는 메시지가 multipart/related일 때는 새롭게 related 파트로 구성한 다음
							// 새 메시지의 서브 파트로 추가한다.
							if (oldMessage.isMimeType("multipart/related")) {
							    logger.debug("oldMessage is multipart/related");
							    
								Multipart relatedPart = new MimeMultipart("related");
								
								for (int i = 0; i < count; i++) {
									p = mp.getBodyPart(i);
									
									// 코린도에서 수신한 메일 중 multipart/related 안에 첨부 파일이 있는 경우가 있어
									// 해당 첨부 파일을 multipart/mixed 파트로 옮기도록 한다.
									if (p.getDisposition() != null && p.getDisposition().equalsIgnoreCase(Part.ATTACHMENT)) {
										multipart.addBodyPart(p);
									} else {
									relatedPart.addBodyPart(p);
								}
								}
								
								// relatedPart에 속한 파트가 하나도 없는 경우 삽입하면 메시지가
								// 정상적으로 생성되지 않는다.
								if (relatedPart.getCount() > 0) {
								MimeBodyPart wrap = new MimeBodyPart();
								wrap.setContent(relatedPart);
								multipart.addBodyPart(wrap, 0);
								}
							} else if (oldMessage.isMimeType("multipart/alternative")) {
							    logger.debug("oldMessage is multipart/alternative");
							    
	                            Multipart alternativePart = new MimeMultipart("alternative");
	                            
	                            for (int i = 0; i < count; i++) {
	                                p = mp.getBodyPart(i); 
	                                alternativePart.addBodyPart(p);
	                            }
	                            
	                            MimeBodyPart wrap = new MimeBodyPart();
	                            wrap.setContent(alternativePart);
	                            multipart.addBodyPart(wrap, 0);							    
							} else {
								
								for (int i = 0; i < count; i++) {
									p = mp.getBodyPart(i);
									multipart.addBodyPart(p);
								}
							}
						}
						
						// 기존 메시지의 모든 헤더를 적용한다.
						Enumeration<Header> e = oldMessage.getAllHeaders();
						
						while (e.hasMoreElements()) {
							Header header = e.nextElement();
							newMessage.setHeader(header.getName(), header.getValue());
						}
						
						// 기존 메시지를 제거한다.
						oldMessage.setFlag(Flags.Flag.DELETED, true);
					}
				}
				
				// 새로 업로드된 파일들을 새 메시지에 추가한다.
				for (int i = 0; i < fileNodes.getLength(); i++) {
					Node subNode = fileNodes.item(i);
					NodeList childNodes = subNode.getChildNodes();
					String fileName = childNodes.item(0).getTextContent();
					String path = childNodes.item(1).getTextContent();
					String bigBool = childNodes.item(2).getTextContent();
					
					// 일반첨부파일의 경우
					if (hasAttachFile && bigBool.equals("N")) {
					    // 첨부파일을 삽입할 Part를 생성한다.
						BodyPart messageBodyPart = new MimeBodyPart();
						
				        File f = new File(pDirTempPath + commonUtil.separator + path);
				        FileDataSource source = new FileDataSource(pDirTempPath + commonUtil.separator + path);
				        messageBodyPart.setDataHandler(new DataHandler(source));
				        
				        String nfcFilename = commonUtil.normalizeFileName(fileName);
				        		
				        // MimeUtility.encodeText is needed to encode a file name in UTF-8 explicitly, 
				        // otherwise, a wrong encoding may be used on some systems(linux, etc)
				        // nonghyup.com 메일 서버의 경우 QP로 인코딩된 경우 connection close(EOF)를 발생시켜
				        // 무조건 BASE64로 인코딩하도록 변경함
				        String encodedFileName = MimeUtility.encodeText(nfcFilename, "UTF-8", "B");
				        
						// folding a filename is done manually since BodyPart.setFileName method encodes it based on RFC 2231.
						// and some mailers (Daum, etc) may not understand it.			        
				        encodedFileName = MimeUtility.fold(0, encodedFileName);
				        messageBodyPart.setHeader("Content-Disposition", "attachment;\r\n filename=\"" + encodedFileName + "\"");
				        
				        // 첨부파일 Content-Type의 디폴트는 application/octet-stream로 설정한다.
				        String contentType = "application/octet-stream";
				        
				        // 첨부파일의 Content-Type을 구한다.
				        if (Files.probeContentType(f.toPath()) != null) {
				        	contentType = Files.probeContentType(f.toPath());
				        } else {
				        	
				        	if (path.lastIndexOf(".") > 0 && path.substring(path.lastIndexOf(".")).equalsIgnoreCase(".eml")) {
				        		contentType = "message/rfc822";
				        	}
				        }
				        
				        messageBodyPart.setHeader("Content-Type", contentType);
				        
				        // Multipart에 첨부파일 Part를 삽입한다.
				        multipart.addBodyPart(messageBodyPart);
						
				        //TODO: fileName parameter를 attachCount로 바꿔야 할것같음. 또는 (filename, attachCount).
				        //메일에서 첨부파일 삭제할 때 attachCount 필요함.
				        childNodes.item(4).setTextContent(fileName);
				        
					} else {
						
						if (!path.equals("")) {
							String[] newPath = path.split("\\|!\\|");
							childNodes.item(1).setTextContent(newPath[1]);
							childNodes.item(4).setTextContent(newPath[0] + commonUtil.separator + newPath[1]);
						}
					}
				}
				
				if (hasAttachFile) {
					newMessage.setContent(multipart);
					newMessage.setFlag(Flags.Flag.SEEN, true);
					AppendUID[] uids = ((IMAPFolder)folder).appendUIDMessages(new Message[]{newMessage});
					xmldom.getElementsByTagName("URL").item(0).setTextContent(String.valueOf(uids[0].uid));
				} else {
					
					if (uid == 0) {
						xmldom.getElementsByTagName("URL").item(0).setTextContent("");
					} else {
						xmldom.getElementsByTagName("URL").item(0).setTextContent(String.valueOf(uid));
					}
				}
	    		
				// 처리가 완료된 일반첨부파일 원본 파일들을 삭제한다.				
				for (int i=0; i<fileNodes.getLength(); i++) {
					Node subNode = fileNodes.item(i);
					NodeList childNodes = subNode.getChildNodes();
					
	                if (childNodes.item(2).getTextContent().equals("N")) {
	                	File file = new File(pDirTempPath + commonUtil.separator + childNodes.item(1).getTextContent());
	                    
	                	if (file.exists()) {
	                    	file.delete();
	                    }
	                }
	            }
			}
			
			if (hasAttachFile) {
		        folder.close(true);
			}
			
			returnValue = commonUtil.convertDocumentToString(xmldom);
			
		} catch (MessagingException e) {
			returnValue = e.getMessage();
			e.printStackTrace();
		} finally {
			
			if (ia != null) {
				ia.close();
			}
		}
		
		logger.debug("mailInterAttach ended.");
		
		return returnValue;
	}

	/**
	 * 메일 전송 실행 함수
	 */
	@RequestMapping(value="/ezEmail/mailInterSend.do", produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String mailInterSend(
			@CookieValue("loginCookie") String loginCookie, 
			Locale locale, Model model, 
			HttpServletRequest request,
			@RequestBody String bodyData) throws Exception {
		logger.debug("mailInterSend started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String password = commonUtil.getUserIdAndPassword(loginCookie).get(1);
		
		String userId = userInfo.getId();
		String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
		String userAccount = userId + "@" + domainName;
		
		//변수들은 메일발송 실패 시 다시 사용되므로 메일발송 로직 도중 값이 바뀌면 안된다.
		String url = "";
		String orgUrl = "";
		String cmd = "";
		String mailCmd = "";
		String orgMailCmd = "";
		String eShowDisplayName = "";
		String from = "";
		String to = "";
		String cc = "";
		String bcc = "";
		String textBody = "";
		String importance = "";
		String subject = "";
		String simpleMime = "";
		String delaySendTime = "";
		String htmlBody = "";
		String pSecurityMail = "";
		String replySendTime = "";
		String replyReadTime = "";
		String isEachMail = "";
		String isReserve = "";
		String reservedId = "";
		String stateName = "";
		boolean isSecureMail = false;
		String securePassword = null;
		String secureReadCount = null;
		String secureReadDate = null;
		int secureId = 0;
		String connUrl = "";
		String author = "";
		String pMessageID = "";
		String eCharSet = "";
		String eContentTransferEncoding = "";
		String eSimpleMIME = "";
		String eSimpleMIMEContentTransferEncoding = "";
		
		String realPath = commonUtil.getRealPath(request);
		List<Map<String, Object>> addressCheck = null; 		// 메일 주소록 자동저장을 위한 name, address 담을 list
		
		// 클라이언트로부터 전달된 XML 형태의 요청 데이터를 XML 문서로 변환한다.
		Document xmlDoc = commonUtil.convertStringToDocument(bodyData);
		Element root = xmlDoc.getDocumentElement();
		
		Node tempNode = null;
		
		// 클라이언트로부터 전달된 요청 패러메터들을 추출한다.
		if (root.getElementsByTagName("URL") != null) {
			tempNode = root.getElementsByTagName("URL").item(0);
			if (tempNode != null) {
				url = tempNode.getTextContent();
			}
		}
		if (root.getElementsByTagName("ORGURL") != null) {
			tempNode = root.getElementsByTagName("ORGURL").item(0);
			if (tempNode != null) {
				orgUrl = tempNode.getTextContent();
			}
		}
		if (root.getElementsByTagName("CONNURL") != null) {
			tempNode = root.getElementsByTagName("CONNURL").item(0);
			if (tempNode != null) {
				connUrl = tempNode.getTextContent();
			}
		}
		if (root.getElementsByTagName("CMD") != null) {
			tempNode = root.getElementsByTagName("CMD").item(0);
			if (tempNode != null) {
				cmd = tempNode.getTextContent();
			}
		}
		if (root.getElementsByTagName("MAILCMD") != null) {
			tempNode = root.getElementsByTagName("MAILCMD").item(0);
			if (tempNode != null) {
				mailCmd = tempNode.getTextContent();
			}
		}
		if (root.getElementsByTagName("ORGMAILCMD") != null) {
			tempNode = root.getElementsByTagName("ORGMAILCMD").item(0);
			if (tempNode != null) {
				orgMailCmd = tempNode.getTextContent();
			}
		}
		if (root.getElementsByTagName("AUTHOR") != null) {
			tempNode = root.getElementsByTagName("AUTHOR").item(0);
			if (tempNode != null) {
				author = tempNode.getTextContent();
			}
		}
		if (root.getElementsByTagName("SUBJECT") != null) {
			tempNode = root.getElementsByTagName("SUBJECT").item(0);
			if (tempNode != null) {
				subject = tempNode.getTextContent();
			}
		}
		if (root.getElementsByTagName("TO") != null) {
			tempNode = root.getElementsByTagName("TO").item(0);
			if (tempNode != null) {
				to = tempNode.getTextContent();
			}
		}
		if (root.getElementsByTagName("CC") != null) {
			tempNode = root.getElementsByTagName("CC").item(0);
			if (tempNode != null) {
				cc = tempNode.getTextContent();
			}
		}
		if (root.getElementsByTagName("BCC") != null) {
			tempNode = root.getElementsByTagName("BCC").item(0);
			if (tempNode != null) {
				bcc = tempNode.getTextContent();
			}
		}
		if (root.getElementsByTagName("FROM") != null) {
			tempNode = root.getElementsByTagName("FROM").item(0);
			if (tempNode != null) {
				from = tempNode.getTextContent();
			}
		}
		if (root.getElementsByTagName("IMPORTANCE") != null) {
			tempNode = root.getElementsByTagName("IMPORTANCE").item(0);
			if (tempNode != null) {
				importance = tempNode.getTextContent();
			}
		}
		if (root.getElementsByTagName("SIMPLE-MIME") != null) {
			tempNode = root.getElementsByTagName("SIMPLE-MIME").item(0);
			if (tempNode != null) {
				simpleMime = tempNode.getTextContent();
			}
		}
		if (root.getElementsByTagName("DELAYSENDTIME") != null) {
			tempNode = root.getElementsByTagName("DELAYSENDTIME").item(0);
			if (tempNode != null) {
				delaySendTime = tempNode.getTextContent();
			}
		}
		if (root.getElementsByTagName("HTMLBODY") != null) {
			tempNode = root.getElementsByTagName("HTMLBODY").item(0);
			if (tempNode != null) {
				htmlBody = tempNode.getTextContent();
				
				String hostUrl = request.getScheme()
						+ "://"
						+ request.getServerName()
						+ ("http".equals(request.getScheme())
								&& request.getServerPort() == 80
								|| "https".equals(request.getScheme())
								&& request.getServerPort() == 443 ? "" : ":"
								+ request.getServerPort());
				
				logger.debug("hostUrl=" + hostUrl);
				
				// 쿠쿠닥스 에디터의 경우 인라인 이미지 태그의 src가 http://호스트명:포트 와 같이 시작하여 이를 제거하도록 함
				htmlBody = htmlBody.replaceAll("src=\"" + hostUrl + "/ezEmail/downloadInline\\.do", "src=\"/ezEmail/downloadInline\\.do");
			}
		}
		if (root.getElementsByTagName("SECURITYMAIL") != null) {
			tempNode = root.getElementsByTagName("SECURITYMAIL").item(0);
			if (tempNode != null) {
				pSecurityMail = tempNode.getTextContent();
			}
		}
		if (root.getElementsByTagName("REPLYSENDTIME") != null) {
			tempNode = root.getElementsByTagName("REPLYSENDTIME").item(0);
			if (tempNode != null) {
				replySendTime = tempNode.getTextContent();
			}
		}
		if (root.getElementsByTagName("REPLYREADTIME") != null) {
			tempNode = root.getElementsByTagName("REPLYREADTIME").item(0);
			if (tempNode != null) {
				replyReadTime = tempNode.getTextContent();
			}
		}
		if (root.getElementsByTagName("ISEACHMAIL") != null) {
			tempNode = root.getElementsByTagName("ISEACHMAIL").item(0);
			if (tempNode != null) {
				isEachMail = tempNode.getTextContent();
			}
		}
		if (root.getElementsByTagName("ISRESERVE") != null) {
			tempNode = root.getElementsByTagName("ISRESERVE").item(0);
			if (tempNode != null) {
				isReserve = tempNode.getTextContent();
			}
		}
		if (root.getElementsByTagName("RESERVEDID") != null) {
			tempNode = root.getElementsByTagName("RESERVEDID").item(0);
			if (tempNode != null) {
				reservedId = tempNode.getTextContent();
			}
		}
		if (root.getElementsByTagName("SHOW-DISPLAYNAME") != null) {
			tempNode = root.getElementsByTagName("SHOW-DISPLAYNAME").item(0);
			if (tempNode != null) {
				eShowDisplayName = tempNode.getTextContent();
			}
		}
		if (root.getElementsByTagName("STATENAME") != null) {
			tempNode = root.getElementsByTagName("STATENAME").item(0);
			if (tempNode != null) {
				stateName = tempNode.getTextContent();
			}
		}
		if (root.getElementsByTagName("SECUREMAIL") != null) {
			tempNode = root.getElementsByTagName("SECUREMAIL").item(0);
			if (tempNode != null && tempNode.getTextContent() != null && tempNode.getTextContent().equalsIgnoreCase("TRUE")) {
				isSecureMail = true;
				
				if (root.getElementsByTagName("SECUREPASSWORD") != null) {
					tempNode = root.getElementsByTagName("SECUREPASSWORD").item(0);
					if (tempNode != null) {
						securePassword = tempNode.getTextContent();
						
					}
				}
				if (root.getElementsByTagName("SECUREREADCOUNT") != null) {
					tempNode = root.getElementsByTagName("SECUREREADCOUNT").item(0);
					if (tempNode != null) {
						secureReadCount = tempNode.getTextContent();
					}
				}
				if (root.getElementsByTagName("SECUREREADDATE") != null) {
					tempNode = root.getElementsByTagName("SECUREREADDATE").item(0);
					if (tempNode != null) {
						secureReadDate = tempNode.getTextContent();
					}
				}
			}
		}
		
		// set textBody
		// tempNode.getTextContent()로 가져오면 whitespace가 모두 없어져서 bodyData에서 잘라서 가져오도록 수정함.
		int sTextBodyIndex = bodyData.indexOf("<TEXTBODY>");
		int eTextBodyIndex = bodyData.indexOf("</TEXTBODY>");
		if (sTextBodyIndex > -1 && eTextBodyIndex > sTextBodyIndex) {
			textBody = bodyData.substring(sTextBodyIndex + 10, eTextBodyIndex);
		}
		
//		// 다국어 발송 관련 변수들
//      string eCharSet = xmlDoc.GetElementsByTagName("CHARSET").Item(0).InnerText;
//      string eContentTransferEncoding = xmlDoc.GetElementsByTagName("CONTENT-TRANSFER-ENCODING").Item(0).InnerText;
//      string eSimpleMIME = xmlDoc.GetElementsByTagName("SIMPLE-MIME").Item(0).InnerText;
//      string eSimpleMIMEContentTransferEncoding = xmlDoc.GetElementsByTagName("SIMPLE-MIME-CONTENT-TRANSFER-ENCODING").Item(0).InnerText;
		
		SMTPAccess sa = SMTPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.SMTPPort"),
				userAccount, password);
		
		String pResult = null;
		IMAPAccess ia = null;
		boolean retryFlag = false;
		int retryCount = 1; //메일 발송 실패 시 재시도 횟수
		long draftUID = 0;
		long sentFolderMessageUID = 0;
		boolean mailSendCompleted = false;
		
		do {
			try {
				ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
						userAccount, password, egovMessageSource, locale, ezEmailUtil);
				
				//메일 발송 재시도일 경우 draftUID의 메일을 지우고 retryFlag와 draftUID를 초기화한다.
				if (retryFlag) {
				    if (draftUID != 0) {
    					Folder draftFolder = null;
    					
    					try {
    						draftFolder = ia.getFolder(ezEmailUtil.getDraftsFolderId(locale));
    						draftFolder.open(Folder.READ_WRITE);
    				        Message draftMessage = ((IMAPFolder)draftFolder).getMessageByUID(draftUID);
    		        		draftMessage.setFlag(Flags.Flag.DELETED, true);
    		        		draftFolder.close(true);
    		        		draftFolder = null;
    		        		
    		        		logger.debug("draftUID message deleted successfully during retry.");
    					} catch (Exception e) {
    						logger.error("Failed to delete draftUID message during retry. draftUID=" + draftUID);
    					} finally {
    						if (draftFolder != null) {
    							try {
    								draftFolder.close(true);
    							} catch (Exception e) {}
    							
    							draftFolder = null;
    						}
    					}
				    }
				    
				    // 보낸편지함에 저장된 이후 Exception이 발생하여 Retry하는 경우 보낸편지함에 있는 메시지를 삭제한다.
				    if (sentFolderMessageUID != 0) {
                        Folder sentFolder = null;
                        
                        try {
                            sentFolder = ia.getFolder(ezEmailUtil.getSentFolderId(locale));
                            sentFolder.open(Folder.READ_WRITE);
                            Message sentMessage = ((IMAPFolder)sentFolder).getMessageByUID(sentFolderMessageUID);
                            sentMessage.setFlag(Flags.Flag.DELETED, true);
                            sentFolder.close(true);
                            sentFolder = null;
                            
                            logger.debug("sentFolderMessageUID message deleted successfully during retry.");
                        } catch (Exception e) {
                            logger.error("Failed to delete sentFolderMessageUID message during retry. sentFolderMessageUID=" + sentFolderMessageUID);
                        } finally {
                            if (sentFolder != null) {
                                try {
                                    sentFolder.close(true);
                                } catch (Exception e) {}
                                
                                sentFolder = null;
                            }
                        }				        
				    }
					
					retryFlag = false;
					draftUID = 0;
					sentFolderMessageUID = 0;
				}
				
				//편지함 용량 체크
				long[] storageUsageAndLimit = ia.getStorageUsageAndLimit();
				double mailboxUsage = storageUsageAndLimit[0]; // in KBs
				double mailboxQuota = storageUsageAndLimit[1]; // in KBs
				logger.debug("mailboxUsage=" + mailboxUsage + ",mailboxQuota=" + mailboxQuota);
				
				if (mailboxUsage >= mailboxQuota) {
					throw new Exception("OVERQUOTA");
				}
				
				// MIME Message를 생성한다.
				MimeMessage message = sa.createMimeMessage();
				
				// 메일 From,TO,CC,BCC
				InternetAddress internetAddress = new InternetAddress();
				String name = "";
				String address = "";
				
				// From
				logger.debug("from=" + from);
				String pattern = "\"?([^\"]*)\"? <([^<>]+)>";
				Pattern r = Pattern.compile(pattern);
				Matcher m = r.matcher(from);
				if (m.find()) {
					name = m.group(1);
					address = m.group(2);
					internetAddress.setPersonal(name, "UTF-8");
					internetAddress.setAddress(address);
					message.setFrom(internetAddress);
				}
				
				// 외부메일 주소록 자동저장을 위한 name, address 담을 list 객체 생성 
				addressCheck = new ArrayList<Map<String, Object>>();
				
				// To
				logger.debug("to=" + to);
				m = r.matcher(to);
				while (m.find()) {
					name = m.group(1);
					address = m.group(2);
					internetAddress.setPersonal(name, "UTF-8");
					internetAddress.setAddress(address);
					message.addRecipient(RecipientType.TO, internetAddress);
					
					// 외부메일 주소록 자동저장을 위한 addressCheck list에  name, address add
					Map<String, Object> autoAddress = new HashMap<String, Object>();
					autoAddress.put("name", name);
					autoAddress.put("address", address);
					addressCheck.add(autoAddress);
				}
				
				// Cc
				logger.debug("cc=" + cc);
				m = r.matcher(cc);
				while (m.find()) {
					name = m.group(1);
					address = m.group(2);
					internetAddress.setPersonal(name, "UTF-8");
					internetAddress.setAddress(address);
					message.addRecipient(RecipientType.CC, internetAddress);
					
					Map<String, Object> autoAddress = new HashMap<String, Object>();
					autoAddress.put("name", name);
					autoAddress.put("address", address);
					addressCheck.add(autoAddress);
				}
				
				// Bcc
				logger.debug("bcc=" + bcc);
				m = r.matcher(bcc);
				while (m.find()) {
					name = m.group(1);
					address = m.group(2);
					internetAddress.setPersonal(name, "UTF-8");
					internetAddress.setAddress(address);
					message.addRecipient(RecipientType.BCC, internetAddress);
					
					Map<String, Object> autoAddress = new HashMap<String, Object>();
					autoAddress.put("name", name);
					autoAddress.put("address", address);
					addressCheck.add(autoAddress);
				}				
				
				// 메일 제목
				message.setSubject(subject, "UTF-8");
				
				logger.debug("cmd=" + cmd + ",simpleMime=" + simpleMime);
				
		        Multipart alternativePart = null;
		        
				// 메일 본문 및 타입
				MimeBodyPart content = new MimeBodyPart();
				
				// simpleMime의 값이 1인 경우는 Plain Text 형식이다.
				if (simpleMime.equals("1")) {
				 // 메일을 발송하는 경우
		            if (!cmd.toUpperCase().equals("SAVE")) {
		                // 예약 메일의 경우
		                if (!delaySendTime.equals("")) {
		                	message.setContent(textBody, "text/plain; charset=utf-8");
		                	content.setContent(textBody, "text/plain; charset=utf-8");
		                // 지금 발송하는 경우
		                } else {
		                	message.setContent(textBody.replaceAll("div id=\"MailSign\"", "div id=\"MailSignSent\""), "text/plain; charset=utf-8");
		                	content.setContent(textBody.replaceAll("div id=\"MailSign\"", "div id=\"MailSignSent\""), "text/plain; charset=utf-8");
		                }
		             // 임시 보관함에 저장하는 경우    
		            } else {
		            	message.setContent(textBody, "text/plain; charset=utf-8");
		            	content.setContent(textBody, "text/plain; charset=utf-8");
		            }
		        // HTML 형식의 경우
		        } else {
					// HTML 안에 포함된 인라인 이미지들에 대한 다운로드 링크를 cid 형식으로 변환한다.
		        	// 이후 Related Part 처리 코드에서 변환을 하지만 Related Part 없이 HTML 파트만으로
		        	// 인라인 이미지를 포함하고 있는 메일이 있어 추가함. 이 경우 이 처리를 하지 않으면
		        	// 해당 메일을 전달하거나 회신할 때 인라인 이미지가 포함되지 않게 된다.
		        	htmlBody = convertDownloadInlineImageURLtoCid(htmlBody);							
		        	
		            // 메일을 발송하는 경우
		            if (!cmd.toUpperCase().equals("SAVE")) {
		                // 예약 메일의 경우
		                if (!delaySendTime.equals("")) {
		                	message.setContent(htmlBody, "text/html; charset=utf-8");
		                	content.setContent(htmlBody, "text/html; charset=utf-8");
		                // 지금 발송하는 경우
		                } else {
		                	message.setContent(htmlBody.replaceAll("div id=\"MailSign\"", "div id=\"MailSignSent\""), "text/html; charset=utf-8");
		                	content.setContent(htmlBody.replaceAll("div id=\"MailSign\"", "div id=\"MailSignSent\""), "text/html; charset=utf-8");
		                }
		            // 임시 보관함에 저장하는 경우
		            } else {
		            	//임시보관함에 저장할 경우에는 style 빼도록 수정
		            	htmlBody = htmlBody.replace("<style>P {MARGIN-TOP: 0mm; MARGIN-BOTTOM: 0mm}</style> ", "");
		            	
		            	message.setContent(htmlBody, "text/html; charset=utf-8");
		            	content.setContent(htmlBody, "text/html; charset=utf-8");
		            }
		
		            // HTML 형식의 경우엔 multipart/alternative로 구성한다.
	                alternativePart = new MimeMultipart("alternative");
		            
	                // text/plain 파트를 구성한다.
		            MimeBodyPart textPlainPart = new MimeBodyPart();
		            textPlainPart.setText(textBody, "utf-8");	
		            
		            // text/plain 파트를 추가한다.
		            alternativePart.addBodyPart(textPlainPart);
		            // text/html 파트를 추가한다. content가 text/html 파트를 갖고 있다.
		            alternativePart.addBodyPart(content);
		            
		            message.setContent(alternativePart);
		        }
				
				// 보안메일
//				if (pSecurityMail.equals("3")) {
//					message.setHeader("Sensitivity", "company-confidential");
//		        }
				
				// 메일 중요도
				switch (importance) { // 2: High, 1: Normal, 0: Low
		            case "0": message.setHeader("X-Priority", "5");
		                break;
		            case "1": message.setHeader("X-Priority", "3");
		                break;
		            case "2": message.setHeader("X-Priority", "1");
		                break;
		            default: message.setHeader("X-Priority", "3");
		                break;
		        }
				
				// 추적(배달되면 알림)
				logger.debug("replySendTime=" + replySendTime);
		        if (replySendTime.equals("1")) {
		        	message.setHeader("Return-Receipt-To", ((InternetAddress)message.getFrom()[0]).getAddress());
		        }
		
		        // 추적(수신확인)
		        logger.debug("replyReadTime=" + replyReadTime);
		        if (replyReadTime.equals("1") || replyReadTime.equals("2")) {
		        	message.setHeader("Disposition-Notification-To", ((InternetAddress)message.getFrom()[0]).getAddress());
		        }
		        
		        // 추적(외부 수신확인)
		        if (replyReadTime.equals("2")) {
		        	message.setHeader("X-JMocha-Ext-Receipt", "1");
		        }
		        
		        //SentDate 설정
		        message.setSentDate(Calendar.getInstance().getTime());
		        
		        //User-Agent 설정
		        message.setHeader("User-Agent", "JMocha Mail 1.0");	        
		        
		        //inline image 처리
		        MimeMultipart relatedPart = null;
		        Set<String> contentIdSet = new HashSet<String>();
		        
		        // simpleMime의 값이 1인 아닌 경우는 HTML 형식이다.
		        if (!simpleMime.equals("1")) {
		        	// getElementsByTagName always returns non-null object even if
		        	// the tag doesn't exist, so its length must be checked.
		        	NodeList imageNameList = root.getElementsByTagName("IMAGENAME");
		        	NodeList imagePathList = root.getElementsByTagName("IMAGEPATH");
		        	
		        	// 새롭게 HTML 본문에 추가된 이미지가 있으면 이미지를 파트로 추가하고 Related Part로 구성한다.
			        if (imageNameList != null && imageNameList.getLength() > 0
			        		&& imagePathList != null && imagePathList.getLength() > 0) {
			        	String imageName = "";
			            String imagePath = "";
			        	
			            // Related Part를 생성한다.
			            relatedPart = new MimeMultipart("related");
			            
			        	for (int i = 0; true; i++) {
			            	if (imageNameList.item(i) == null || imagePathList.item(i) == null) {
			            		break;
			            	}
			            	
			            	imageName = imageNameList.item(i).getTextContent();
			            	imagePath = imagePathList.item(i).getTextContent();
			            	
			            	if (!imageName.trim().equals("") && !imagePath.trim().equals("")) {
			            	    // 이미지 파일의 Path를 구한다.
			                	imagePath = new URL(imagePath).getPath();
			                	String pDirPath = realPath + imagePath;
			                	
			        	        File f = new File(pDirPath);
			        	        
			        	        if (f.exists()) {	            		
			        	            // 본문 내용에 있는 image tag의 src 속성의 값을 content id 형식으로 변경한다.
				                	String cid = imageName + "@12345678.87654321";
				                	
				                	// content가 HTML 파트를 갖고 있다.
				                	String strContent = content.getContent().toString();
				                	int index = strContent.indexOf("src=\"" + imageName);
				                	
				                	if (index != -1) {
				                		strContent = strContent.replace("src=\"" + imageName, "src=\"cid:" + cid);
				                	}
				                	
				                	content.setContent(strContent, "text/html; charset=utf-8");
			                		        	        
				                	// 이미지 파일을 추가할 Mime Body Part를 생성한다.
				                	MimeBodyPart messageBodyPart = new MimeBodyPart();
				                	
				        	        FileDataSource source = new FileDataSource(f);
				        	        messageBodyPart.setDataHandler(new DataHandler(source));
				        	        messageBodyPart.setFileName(imageName);
				        	        
				        	        String contentType = null;
				        	        BufferedInputStream bis = null;
				        	        
				        	        try {
				        		        bis = new BufferedInputStream(new FileInputStream(f));
				        		        contentType = URLConnection.guessContentTypeFromStream(bis);
				        	        } catch(Exception e) {
				        	        } finally {
				        	        	if (bis != null) {
				        	        		bis.close();
				        	        	}
				        	        }
				        	        
				        	        if (contentType == null) {
			        		        	contentType = "application/octet-stream";
			        		        }
				        	        
				        	        
				        	        messageBodyPart.setHeader("Content-Type", contentType);
				        	        String cidWithBrackets = "<" + cid + ">";
				        	        messageBodyPart.setContentID(cidWithBrackets);
				        	        messageBodyPart.setDisposition(Part.INLINE);
				        	        
				        	        contentIdSet.add(cidWithBrackets);
				        	        logger.debug("cidWithBrackets=" + cidWithBrackets);
				        	        
				        	        // Related Part에 이미지 Part를 추가한다.
				        	        relatedPart.addBodyPart(messageBodyPart);
			        	        }
			                }
			            }
			        	
			        	// Related Part의 첫 부분에 HTML 본문 Part를 삽입한다.
			        	relatedPart.addBodyPart(content, 0);
			        	
			        	// Alternative의 두 번째 파트에 기존 HTML 파트를 제거하고 Related Part를 삽입한다.
			        	alternativePart.removeBodyPart(1);
			        	
			        	// Multipart 객체는 직접적으로 Body Part로서 다른 Multipart 객체 안에 
			        	// 들어갈 수 없기 때문에 Wrapper 역할을 하는 MimeBodyPart 객체의 콘텐트로 세트한 다음
			        	// 해당 Wrapper 객체를 alternativePart에 삽입한다.
	                    MimeBodyPart wrap = new MimeBodyPart();
	                    wrap.setContent(relatedPart);
			        	alternativePart.addBodyPart(wrap, 1);
			        	
			        	// 이 시점에 message는 alternatvie part 안에 plain 파트와 related 파트를 갖게 되고
			        	// related 파트는 html 파트와 인라인 이미지 파트들을 포함한다.
			        	message.setContent(alternativePart);
					}
		        }
		        
	            // 임시 보관함에 메시지가 있는 경우 해당 메시지와 병합 작업을 수행한다.
		        Message oldMessage = null;
		        long uid = 0;
		        
		        Folder draftFolder = ia.getFolder(ezEmailUtil.getDraftsFolderId(locale));
		        draftFolder.open(Folder.READ_WRITE);
		        
		        logger.debug("url=" + url);
		        
		        // url은 임시 보관함에 있는 메시지의 UID를 갖고 있다.
		        if (!url.trim().equals("")) {
		        	uid = Long.parseLong(url);
		        
		        	MimeMultipart mixedPart = new MimeMultipart();
					
					if (uid != 0) {
					    // 임시 보관함에 있는 기존 메시지를 불러온다.
						oldMessage = ((IMAPFolder)draftFolder).getMessageByUID(uid);
						
						if (oldMessage != null) {
							// copy existing headers that are needed.
							String[] headers = oldMessage.getHeader("References");
							
							if (headers != null) {
								message.setHeader("References", headers[0]);
							}
							
							headers = oldMessage.getHeader("In-Reply-To");
							
							if (headers != null) {
								message.setHeader("In-Reply-To", headers[0]);
							}
							
							// 임시 보관함에 있는 기존 메시지가 Multipart 메시지일 경우의 처리
							// 이 경우 각 파트들을 필요에 따라 새 메시지에 병합한다.
							if (oldMessage.getContent() instanceof Multipart) {
							    // 기존 메시지의 Multipart를 불러온다.
								Multipart mp = (Multipart)oldMessage.getContent();
								int count = mp.getCount();
								BodyPart p = null;
								boolean hasAttach = false;
								boolean hasInlineImage = false;
								boolean hasRelated = false;
								
								// Multipart의 각 Part별 처리를 수행한다.
								for (int i = 0; i < count; i++) {
									p = mp.getBodyPart(i);
									
									while (true) {
										// alternativePart가 null이 아닌 경우는 HTML 형식의 메일을 작성하는 경우이다.
										// Related Part는 HTML 형식의 메일에서만 처리할 필요가 있다.
									    // Part가 Related Part일 경우의 처리
	    								if (alternativePart != null && p.isMimeType("multipart/related")) {
	    								    logger.debug("Part is multipart/related");
	    								    
	    									hasAttach = true;
	    									hasRelated = true;
	    									
	    									logger.debug("relatedPart=" + relatedPart);
	    									
	    									// 새로 작성하는 메시지가 이미 Related Part를 갖고 있지 않은 경우에는
	    									// Related Part를 생성한다.
	    									if (relatedPart == null) {
	    										relatedPart = new MimeMultipart("related");
	    										    							
	    							        	// Multipart 객체는 직접적으로 Body Part로서 다른 Multipart 객체 안에 
	    							        	// 들어갈 수 없기 때문에 Wrapper 역할을 하는 MimeBodyPart 객체의 콘텐트로 세트한 다음
	    							        	// 해당 Wrapper 객체를 alternativePart에 삽입한다.	    										
	    					                    MimeBodyPart wrap = new MimeBodyPart();
	    					                    wrap.setContent(relatedPart);
	    					                    // HTML 파트를 갖고 있는 1번 파트를 제거하고 Related Part를 갖고 있는
	    					                    // Wrapper 객체를 대신 추가한다.
	    					                    alternativePart.removeBodyPart(1);
	    					                    alternativePart.addBodyPart(wrap, 1);
	    									}
	    									// HTML 본문에 새로 추가한 인라인 이미지가 있는 경우에는 이미 relatedPart 객체가 
	    									// 생성되어 있다.
	    									else {
	    										// 이 relatedPart 객체는 이미 alternativePart 객체 안에 삽입되어 있다.
	    										// relatedPart 객체가 포함하고 있는 HTML part를 제거한다.
	    										relatedPart.removeBodyPart(0);
	    									}
	    									
	    									// 임시 보관함에 있는 기존 메시지의 Related Part내에 있는 인라인 이미지 파트들을 병합한다.
	    									Multipart existingRelatedPart = (Multipart)p.getContent();
	    									int existingRelatedPartCount = existingRelatedPart.getCount();
	    									BodyPart existingRelatedSubPart = null;
	    									
	    									for (int j = 0; j < existingRelatedPartCount; j++) {
	    									    existingRelatedSubPart = existingRelatedPart.getBodyPart(j);
	    										
	    										if (existingRelatedSubPart instanceof MimePart) {
	    										    String contentId = ((MimePart)existingRelatedSubPart).getContentID();
	    										    logger.debug("Existing ContentId=" + contentId);
	    										    
	    										    // 이미 relatedPart 객체 안에 포함되어 있지 않은 이미지 파트이면 추가한다.
	    											if (contentId != null && !contentIdSet.contains(contentId)) {
	    											    logger.debug("Adding ContentId=" + contentId);
	    											    
	    												relatedPart.addBodyPart(existingRelatedSubPart);						
	    											}
	    										}				
	    									}
	    									
	    									// content가 HTML 파트를 갖고 있다.
	    									String bodyContent = content.getContent().toString();
	    									// HTML 안에 포함된 임시 보관함 기존 메시지 내의 인라인 이미지들에 대한 다운로드 링크를 
	    									// cid 형식으로 변환한다.
	    									bodyContent = convertDownloadInlineImageURLtoCid(bodyContent);							
	    									content.setContent(bodyContent, "text/html; charset=utf-8");
	    									// relatedPart 객체의 첫 번째 파트에 해당 HTML 파트를 추가한다.
	    									relatedPart.addBodyPart(content, 0);
	    									
	    									// HTML 내에서 참조하고 있지 않은 인라인 이미지 파트들을 제거한다.
	    									removeUnusedInlineImagePart(relatedPart);
	    								}
										// alternativePart가 null이 아닌 경우는 HTML 형식의 메일을 작성하는 경우이다.
										// Alternative Part는 HTML 형식의 메일에서만 처리할 필요가 있다.	    								
	    								// Part가 Alternative Part일 경우의 처리
	    								else if (alternativePart != null && p.isMimeType("multipart/alternative")) {
	    								    logger.debug("Part is multipart/alternative");
	    								    
	    								    hasAttach = true;
	    								    
	                                        Multipart existingAlternativePart = (Multipart)p.getContent();
	                                        int existingAlternativePartCount = existingAlternativePart.getCount();
	                                        BodyPart existingAlternativeSubPart = null;
	                                        boolean isRelatedFound = false;
	                                        
	                                        // Alternative Part 안에 있는 파트들을 처리한다.
	                                        for (int j = 0; j < existingAlternativePartCount; j++) {
	                                            existingAlternativeSubPart = existingAlternativePart.getBodyPart(j);
	                                            
	                                            if (existingAlternativeSubPart instanceof MimePart) {
	                                                // Alternative Part 안에 Related Part가 있는 경우에 대한 처리
	                                                if (existingAlternativeSubPart.isMimeType("multipart/related")) {
	                                                    isRelatedFound = true;
	                                                    break;
	                                                }
	                                            }               
	                                        }						
	                                        
	                                        if (isRelatedFound) {
	                                            // p를 발견된 related 파트로 변경하여 루프의 시작 부분에 있는 related 파트 처리 부분으로 제어를 옮긴다.
	                                            p = existingAlternativeSubPart;
	                                            continue;
	                                        }
	                                    }								
	                                    // there are cases where an in-line image part doesn't have
	                                    // a Content-Disposition header, but has a Content-ID header.
	    								// 첨부파일 파트나 본문 파트에도 Content-ID가 있을 수 있어서 if문에 들어가지 않도록 조건을 추가함
	    								else if (p instanceof MimePart 
	    								        && ((MimePart)p).getContentID() != null
	    								        && !(p.getDisposition() != null && p.getDisposition().equalsIgnoreCase(Part.ATTACHMENT))
	    								        && !p.isMimeType("text/*")) {
	    								    String contentId = ((MimePart)p).getContentID();
	    								    logger.debug("Existing ContentId=" + contentId);
	    								    
	    								    if (!contentIdSet.contains(contentId)) {
	    								        logger.debug("Adding ContentId=" + contentId);
	    								        
	    								        hasInlineImage = true;
	    								        mixedPart.addBodyPart(p);
	    								    }
	    								}
	    								// Content-Disposition 헤더가 없이 첨부된 파일이 있어
	    								// Content-Type이 application으로 시작하는 경우도 추가함 
	    								// 예) Content-Type: application/octet-stream;
	    								//         name="=?utf-8?B?NDExMDAwODE1OS5QREY=?="
	    							    //    Content-Transfer-Encoding: base64	    								
	    								else if (p.getDisposition() != null || p.isMimeType("application/*")) { 
	    									MimeBodyPart newBodyPart = (MimeBodyPart)p;
	    									
	    									// 첨부파일 파트인 경우
	    									if ((p.getDisposition() != null && p.getDisposition().equalsIgnoreCase(Part.ATTACHMENT))
	    											|| p.isMimeType("application/*")) {
	    										hasAttach = true;
	    											    										
	    										InternetHeaders newHeaders = new InternetHeaders();
	    										
	    										@SuppressWarnings("unchecked")
												Enumeration<Header> enumerator = p.getAllHeaders();
	    										
	    										// 해당 파트의 헤더들을 읽는다.
	    										while (enumerator.hasMoreElements()) {
	    											Header h = (Header)enumerator.nextElement();
	    											
	    											String hValue = h.getValue();
	    											
	    											// long header line의 경우 작성 시에는 folding이 되어 있으나
	    											// 파트를 복사하는 과정에서 CRLF가 사라지는 현상이 있어
	    											// 이곳에서 다시 CRLF를 삽입하도록 함
	    											hValue = hValue.replace("attachment; filename=", "attachment;\r\n filename=");
	    											hValue = hValue.replace("?= =?", "?=\r\n =?");
	    											
	    											newHeaders.addHeader(h.getName(), hValue);
	    										}
	    										
	    										// 해당 파트의 body 데이터를 읽는다.
	    										byte[] bytes = IOUtils.toByteArray(newBodyPart.getRawInputStream());
	    											    										
	    										// 해당 파트의 헤더와 body 데이터를 동일하게 갖는 파트 객체를 생성한다.
	    										newBodyPart = new MimeBodyPart(newHeaders, bytes);	 
	    									}
	    									
	    									mixedPart.addBodyPart(newBodyPart);	    									
	    								}
	    								// Part가 message 인 경우, 즉 메일이 첨부된 경우
	    								else if (p.isMimeType("message/*")) {
	    								    logger.debug("Part is message");
	    								    
	    									mixedPart.addBodyPart(p);
	    									hasAttach = true;
	    								}							
	    								
	    								break;
									}
								}
								
								// multipart/related 안에 첨부파일이 들어 있는 메일이 코린도에서 수신되어
								// 해당 메일이 인라인 이미지도 포함한 경우의 처리를 위해 추가함.
								// 이 경우엔 전체 메시지를 multipart/related로 구성하고
								// 그 안에 인라인 이미지와 첨부 파일이 들어 있는 형태로 메시지를 구성한다.
								if (oldMessage.isMimeType("multipart/related")) {
									logger.debug("hasAttach=" + hasAttach + ",hasRelated=" + hasRelated
													+ ",hasInlineImage=" + hasInlineImage);
									
									if (hasAttach && !hasRelated && hasInlineImage) {
										hasAttach = false;
									}
								}
								
								// 기존 메시지에 첨부파일이 있거나 Alternative Part 혹은 Related Part가 있는 경우의 처리
								if (hasAttach) {
									if (alternativePart != null) {
										MimeBodyPart wrap = new MimeBodyPart();
										wrap.setContent(alternativePart);
										mixedPart.addBodyPart(wrap, 0);
									} else {
										mixedPart.addBodyPart(content, 0);
									}							
									
									message.setContent(mixedPart);							
								}
								// 기존 메시지가 Related Part일 경우의 처리
								else if (oldMessage.isMimeType("multipart/related")) {
								    logger.debug("oldMessage is multipart/related");
									logger.debug("relatedPart=" + relatedPart);
									
	                                if (alternativePart != null) {								
	    								// 새로 추가되는 이미지 파트들을 추가한다.
	    								// 기존 메시지의 이미지 파트들은 위에서 이미 mixedPart에 추가되어 있다.
	    								// a new related part is already created by the above routine
	    								// for adding new in-line images.						
	    								if (relatedPart != null) {
	    									relatedPart.removeBodyPart(0);
	    									
	    									BodyPart relatedSubPart = null;
	    									for (int i = 0; i < relatedPart.getCount(); i++) {
	    										relatedSubPart = relatedPart.getBodyPart(i);
	    										mixedPart.addBodyPart(relatedSubPart);
	    									}
	    								}
	    								
	    								// 기존 메시지가 Related Part인 경우는 첨부파일이 없는 경우이므로 mixed가 아니다.
	    								// this mixedPart is actually a related part.
	    								mixedPart.setSubType("related");
	    								
	    								String bodyContent = content.getContent().toString();																
	                                    bodyContent = convertDownloadInlineImageURLtoCid(bodyContent);                          
	                                    content.setContent(bodyContent, "text/html; charset=utf-8");                            
	                                    mixedPart.addBodyPart(content, 0);
	                                    
	                                    removeUnusedInlineImagePart(mixedPart);
	                                                                        
	                                    MimeBodyPart wrap = new MimeBodyPart();
	                                    wrap.setContent(mixedPart);
	                                    alternativePart.removeBodyPart(1);
	                                    alternativePart.addBodyPart(wrap, 1);                                                                               
	                                } 
								}
							}					
						}
					}
		        }        
		        
		        //mailboxUsage + messageSize >= mailboxQuota인 경우 OVERQUOTA Exception
		        CountOutputStream cos = null;
		        double messageSize = 0;
		        
		        try {
		        	cos = new CountOutputStream();
		        	message.writeTo(cos);
		        	messageSize = cos.getSize() / 1024.0;
		        } catch(Exception e) {
		        	e.printStackTrace();
		        } finally {
		        	try { cos.close(); } catch (Exception e) {}
		        }
		        
		        logger.debug("mailboxUsage=" + mailboxUsage + ", messageSize=" + messageSize + ", mailboxQuota=" + mailboxQuota);
		        
		        if (mailboxUsage + messageSize >= mailboxQuota) {
					throw new Exception("OVERQUOTA");
				}
		        
		        //messageSize가 maxMessageSize 넘을 경우 OVERMESSAGESIZE Exception
		        int maxMessageSize = ezEmailService.getMaxMessageSize(userInfo.getTenantId());
		        
		        if (maxMessageSize > 0 && messageSize > maxMessageSize) {
		        	double maxMessageSizeD = maxMessageSize / 1024.0;
		        	maxMessageSizeD = Math.round(maxMessageSizeD * 10) / 10;
		        	
		        	double messageSizeD = messageSize / 1024.0;
		        	messageSizeD = Math.round(messageSizeD * 10) / 10;
		        	
		        	throw new Exception("OVERMESSAGESIZE:" + maxMessageSizeD + "MB:" + messageSizeD + "MB");
		        }
		        
		        String useSecureMail = ezCommonService.getTenantConfig("USE_SECUREMAIL", userInfo.getTenantId());
		        logger.debug("useSecureMail=" + useSecureMail);
		        
		        if (cmd.equalsIgnoreCase("SAVE")) {
		        	logger.debug("Saving the message");
		        	
		    		Boolean isEachMailB = Boolean.parseBoolean(isEachMail.trim());
		    		
		    		if (isEachMailB) {
	                	message.setHeader("X-JMocha-Each-Mail", "true");
                    }
		    		if (delaySendTime != ""){
		    			message.setHeader("Delivery-Date", delaySendTime);
		    		}
		    		if (useSecureMail.equals("YES") && isSecureMail) {
		    			message.setHeader("X-JMocha-Secure-Mail", "true");
		    		}
		    		
		    		message.setFlag(Flags.Flag.SEEN, true);
		    		AppendUID[] uids = ((IMAPFolder)draftFolder).appendUIDMessages(new Message[]{message});
		    		if (uids != null && uids[0] != null) {
		    			draftUID = uids[0].uid;
		    		} 
		    	
		            // this deletion code block has been moved here because
		            // it needs to be kept in Drafts if an error occurs during the above process.
		            if (oldMessage != null) {
		            	oldMessage.setFlag(Flags.Flag.DELETED, true);
		            }
		            
		        } else if (cmd.equalsIgnoreCase("SEND")) {
		        	logger.debug("Sending the message");
		        	
//					String strCheckReadUrl = ""; //외부메일수신확인 관련 URL. GetSystemConfigValue("APPREADCHECK_URL").ToString();
			        Boolean isEachMailB = Boolean.parseBoolean(isEachMail.trim());
			        
			        if (!eShowDisplayName.equals("")) {
		            	message.setHeader("X-JMocha-EXT-SENDERNAME", MimeUtility.encodeText(eShowDisplayName, "UTF-8", null));
		            }
			                            
                    message.setFlag(Flags.Flag.SEEN, true);
		            
                    // 예약 발송의 경우
			        if (!delaySendTime.equals("")) {
			            // 편지함 용량 초과 메세지 확인을 위해 임시저장
	                    AppendUID[] uids = ((IMAPFolder)draftFolder).appendUIDMessages(new Message[]{message});
	                    if (uids != null && uids[0] != null) {
	                        draftUID = uids[0].uid;
	                    } 
			            
	                    // 개별발신
	                    if (isEachMailB) {
		                	message.setHeader("X-JMocha-Each-Mail", "true");
	                    }
	                    
			        	// 예약발송
			        	String delaySendTimeUTC = commonUtil.getDateStringInUTC(delaySendTime, userInfo.getOffset(), true);
			            
			        	// 보안메일 처리
		            	if (useSecureMail.equals("YES") && isSecureMail) {
	    		        	message.setHeader("X-JMocha-Secure-Mail", "true");
	    		        	message.setHeader("X-JMocha-Secure-Mail-Password", securePassword);
	    		        	message.setHeader("X-JMocha-Secure-Mail-ReadCount", secureReadCount);
	    		        	message.setHeader("X-JMocha-Secure-Mail-ReadDate", secureReadDate);
	    		        	
	    		        	// set serverName
	    		    		String serverName = userInfo.getServerName();
	    		    		String useMailLinkHostname = ezCommonService.getTenantConfig("useMailLinkHostname", userInfo.getTenantId());
	    		    		
	    		    		if (useMailLinkHostname.equals("YES")) {
	    		    			String mailLinkHostname = ezCommonService.getTenantConfig("mailLinkHostname", userInfo.getTenantId());
	    		    			
	    		    			if (!mailLinkHostname.equals("")) {
	    		    				serverName = mailLinkHostname;
	    		    			}
	    		    		}
	    		        	
	    		        	message.setHeader("X-JMocha-Secure-Mail-ServerName", serverName);
		            	}
			        	
			        	doDelaySend(userInfo.getTenantId(), message, isReserve, reservedId, subject, delaySendTimeUTC, userId, realPath);
			        	
			            //임시보관함에서 삭제
			            Message draftMessage = ((IMAPFolder)draftFolder).getMessageByUID(draftUID);
		        		draftMessage.setFlag(Flags.Flag.DELETED, true);
		        		
                        // this deletion code block has been moved here because
                        // it needs to be kept in Drafts if an error occurs during the above process.
                        if (oldMessage != null) {
                            oldMessage.setFlag(Flags.Flag.DELETED, true);
                        }		        		
		        	// 즉시 발송의 경우	
			        } else {
			        	
			        	String[] eachMailHeaders = message.getHeader("X-JMocha-Each-Mail");
						String eachMailHeader = eachMailHeaders != null ? eachMailHeaders[0] : null;		
						
						if (eachMailHeader != null) {
							message.removeHeader("X-JMocha-Each-Mail");
						}
						
						File encryptedFile = null; // 보안메일 관련 파일 변수
			        	
			            // mailSendCompleted가 true인 경우는 메일 전송까지 완료된 이후에 Exception이 발생하여 Retry하는 경우이다.
			            // 이 경우에는 이미 보낸편지함에 저장된 메일이 있으므로 보낸편지함에 다시 저장하지 않는다.
			            if (mailSendCompleted == false) {
			            	Folder sentFolder = ia.getFolder(ezEmailUtil.getSentFolderId(locale));
			            	
			            	// 보안메일 처리
			            	if (useSecureMail.equals("YES") && isSecureMail) {
			            		if (!secureReadDate.equals("")) {
			            			Date date = new Date(Long.parseLong(secureReadDate));
			            			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			            			secureReadDate = sdf.format(date);
			            			secureReadDate = commonUtil.getDateStringInUTC(secureReadDate, userInfo.getOffset(), true);
			            		}

			            		// client단에서 암호화되어 넘겨진 securePassword 복호화
			            		String prm = egovFileScrty.getPrm();
			                	String pre = egovFileScrty.getPre();
			                	PrivateKey pk = EgovFileScrty.getPrivateKey(prm, pre);
			                	securePassword = EgovFileScrty.decryptRsa(pk, securePassword);
			            		
			            		// securePassword 암호화
			            		securePassword = egovFileScrty.encryptAES(securePassword);
			            		
			            		// save secure mail info and get secureId
			            		secureId = ezEmailService.setMailSecure(userInfo.getTenantId(), userId, securePassword, Integer.parseInt(secureReadCount), secureReadDate);
		    		        	
		    		        	if (secureId == 0) {
		    		        		throw new Exception("INSERTSECUREMAILFAIL");
		    		        	}
			            		
			            		MimeMessage secureMessage = sa.createMimeMessage();
			            		
			            		@SuppressWarnings("unchecked")
								Enumeration<Header> headerEnum = message.getAllHeaders();
			            		
			            		while (headerEnum.hasMoreElements()) {
			            			Header header = headerEnum.nextElement();
			            			secureMessage.setHeader(header.getName(), header.getValue());
			            		}
			            		
		    		        	MimeMultipart secureMixedPart = new MimeMultipart();
		    		        	
		    		        	// make secureBodyPart and add to secureMixedPart
		    		        	MimeBodyPart secureBodyPart = new MimeBodyPart();
		    		        	MimeMultipart secureBodyRelatedPart = new MimeMultipart("related");
		    		        	MimeBodyPart secureBodyHtmlPart = new MimeBodyPart();
		    		        	MimeBodyPart secureBodyImagePart = new MimeBodyPart();
		    		        	
		    		        	String tempFileName = UUID.randomUUID().toString();
		    		        	
		    		        	secureBodyHtmlPart.setContent(ezEmailUtil.getSecureBodyHtml(tempFileName, locale), "text/html; charset=utf-8");
		    		        	
		    		        	secureBodyImagePart.setHeader("Content-Disposition", "inline;\r\n\tfilename=\"" + tempFileName + ".gif\"");
		    		        	secureBodyImagePart.setHeader("Content-ID", "<" + tempFileName + ".gif@12345678.87654321>");
		    		        	secureBodyImagePart.setHeader("Content-Type", "image/gif");
		    		        	FileDataSource source = new FileDataSource(new File(realPath + "/images/email/secureMail/security_img.gif"));
		    		        	secureBodyImagePart.setDataHandler(new DataHandler(source));
		    		        	
		    		        	secureBodyRelatedPart.addBodyPart(secureBodyHtmlPart);
		    		        	secureBodyRelatedPart.addBodyPart(secureBodyImagePart);
		    		        	
		    		        	secureBodyPart.setContent(secureBodyRelatedPart);
		    		        	secureMixedPart.addBodyPart(secureBodyPart);
		    		        	// make secureBodyPart and add to secureMixedPart - end
		    		        	
		    		        	// make secureAttachPart and add to secureMixedPart
		    		        	MimeBodyPart secureAttachPart = new MimeBodyPart();
		    		        	secureAttachPart.setHeader("Content-Disposition", "attachment;\r\n\tfilename=\"secureMail.html\"");
		    		        	secureAttachPart.setHeader("Content-Type", "text/html");
		    		        	
		    		        	String useHttps = ezCommonService.getTenantConfig("USE_HTTPS", userInfo.getTenantId());
		    		        	
		    		    		String serverName = userInfo.getServerName();
		    		    		String useMailLinkHostname = ezCommonService.getTenantConfig("useMailLinkHostname", userInfo.getTenantId());
		    		    		
		    		    		if (useMailLinkHostname.equals("YES")) {
		    		    			String mailLinkHostname = ezCommonService.getTenantConfig("mailLinkHostname", userInfo.getTenantId());
		    		    			
		    		    			if (!mailLinkHostname.equals("")) {
		    		    				serverName = mailLinkHostname;
		    		    			}
		    		    		}
		    		        	
		    		        	logger.debug("useHttps=" + useHttps + ",serverName=" + serverName);
		    		        	
		    		        	String secureAttachHtml = ezEmailUtil.getSecureAttachHtml(serverName, locale, useHttps);
		    		        	
		    		        	String secureMailKey = userAccount + "/" + secureId + "/" + userAccount;
		    		        	secureMailKey = egovFileScrty.encryptAES(secureMailKey);
		    		        	
		    		        	secureAttachPart.setContent(secureAttachHtml.replace("${X-JMocha-Secure-Mail-Key}", secureMailKey), "text/html; charset=utf-8");
		    		        	secureAttachPart.setHeader("Content-Disposition", "attachment;\r\n\tfilename=\"secureMail.html\"");
		    		        	secureMixedPart.addBodyPart(secureAttachPart);
		    		        	// make secureAttachPart and add to secureMixedPart - end
		    		        	
		    		        	// make encryptedOriginalPart and add to secureMixedPart
		    		        	MimeBodyPart encryptedOriginalPart = new MimeBodyPart();
		    		        	
		    		        	String pDirPath = realPath + commonUtil.getUploadPath("upload_mail.ROOT", userInfo.getTenantId()) + commonUtil.separator + "tempFileUpload";
		    		        	File file = new File(pDirPath);
		    		        	if (!file.exists()) {
		    		        		file.mkdirs();
		    		        	}
		    			        
		    		        	File originalFile = new File(pDirPath + commonUtil.separator + UUID.randomUUID().toString());
		    		        	FileOutputStream fos = null;
		    		        	
		    		        	try {
		    		        		fos = new FileOutputStream(originalFile);
		    		        		message.writeTo(fos);
		    		        	} catch (Exception e) {
		    		        		e.printStackTrace();
		    		        	} finally {
		    						if (fos != null) {
		    							try { fos.close(); } catch (IOException e) {}
		    						}
		    					}
		    		        	
		    		        	encryptedFile = new File(pDirPath + commonUtil.separator + UUID.randomUUID().toString());
		    		        	egovFileScrty.cryptFile(Cipher.ENCRYPT_MODE, originalFile, encryptedFile);
		    		        	
		    		        	// 보안메일 관련 임시파일 삭제
		    		        	if (originalFile.delete()) {
		    		        		logger.debug("originalFile is deleted. fileName=" + originalFile.getName());
		    		        	}
		    		        	
		    		        	encryptedOriginalPart.setHeader("Content-Disposition", "attachment;\r\n\tfilename=\"originalMail.eml\"");
		    		        	encryptedOriginalPart.setHeader("Content-Type", "message/rfc822");
		    		        	source = new FileDataSource(encryptedFile);
		    		        	encryptedOriginalPart.setDataHandler(new DataHandler(source));
		    		        	secureMixedPart.addBodyPart(encryptedOriginalPart);
		    		        	// make encryptedOriginalPart and add to secureMixedPart - end
		    		        	
		    		        	secureMessage.setContent(secureMixedPart);
		    		        	
		    		        	ezEmailUtil.setSecureMailFlag(secureMessage, true);
		    		        	secureMessage.setFlag(Flags.Flag.SEEN, true);
		    		        	
			            		// 편지함 용량 초과 메세지 확인을 위해 임시저장
	    	                    // 본래는 임시보관함에 미리 저장해두고 성공했을 시 임시보관함에 있는 메일을 보낸메일함으로 복사하였으나
	    			            // 보낸메일함에 바로 저장하는 것으로 변경함.
	    	                    AppendUID[] uids = ((IMAPFolder)sentFolder).appendUIDMessages(new Message[]{secureMessage});
	    	                    if (uids != null && uids[0] != null) {
	    	                        sentFolderMessageUID = uids[0].uid;
	    	                    }
	    	                    
			            		// 보낸편지함에 저장한 메일의 uid를 저장한다.
    			            	String result = ezEmailService.updateMailSecure(userInfo.getTenantId(), userId, secureId, sentFolder.getFullName() + "/" + sentFolderMessageUID);
    				        	
    				        	if (!result.equals("OK")) {
    				        		throw new Exception("UPDATESECUREMAILFAIL");
    				        	}
	    			            
    				        	// 메일을 발송할 때에는 보낸사람의 secureMailKey를 다시 ${X-JMocha-Secure-Mail-Key}로 되돌려놓는다.
    				        	secureMixedPart.removeBodyPart(secureAttachPart);
    				        	secureAttachPart.setContent(secureAttachHtml, "text/html; charset=utf-8");
    				        	secureMixedPart.addBodyPart(secureAttachPart);
    				        	
    				        	// 메일을 발송할 때에는 원본메일을 삭제한다.
	    			            secureMixedPart.removeBodyPart(encryptedOriginalPart);
	    			            
	    			            // 서버에서 보안메일을 처리할 수 있도록 헤더를 추가한다.
	    			            secureMessage.setHeader("X-JMocha-Secure-Mail-ID", String.valueOf(secureId));
	    			            
	    			            message = secureMessage;
	    			            
			            	} else {
			            		// 편지함 용량 초과 메세지 확인을 위해 임시저장
	    	                    // 본래는 임시보관함에 미리 저장해두고 성공했을 시 임시보관함에 있는 메일을 보낸메일함으로 복사하였으나
	    			            // 보낸메일함에 바로 저장하는 것으로 변경함.
	    	                    AppendUID[] uids = ((IMAPFolder)sentFolder).appendUIDMessages(new Message[]{message});
	    	                    if (uids != null && uids[0] != null) {
	    	                        sentFolderMessageUID = uids[0].uid;
	    	                    }
			            	}
			            }
			            
			            // 개별발신
			            if (isEachMailB) {
			            	logger.debug("sending each recipient mail");
			            	
			                // mailSendCompleted가 true인 경우는 Transport.send가 완료된 이후에 예외가 발생하여 Retry하는 경우이다.
			                // 이 경우에는 메일을 다시 전송하지 않는다.
			                if (mailSendCompleted == false) {			     			                	
				            	Address[] allRecipients = message.getAllRecipients();
				            	
				            	message.removeHeader("TO");
				        		message.removeHeader("CC");
				        		message.removeHeader("BCC");
				        		
				            	for (Address a : allRecipients) {
				            		logger.debug("address=" + a);
				            		
				            		message.setRecipient(RecipientType.TO, a);
				            		
				            		Transport.send(message);
				            		
	    			            	sentFolderMessageUID = 0;
	    			            	mailSendCompleted = true;				            		
				            	}
			                }
			            	
			                // this deletion code block has been moved here because
			                // it needs to be kept in Drafts if an error occurs during the above process.
			                if (oldMessage != null) {
			                	oldMessage.setFlag(Flags.Flag.DELETED, true);
			                }
			            } else {
			                // mailSendCompleted가 true인 경우는 Transport.send가 완료된 이후에 예외가 발생하여 Retry하는 경우이다.
			                // 이 경우에는 메일을 다시 전송하지 않는다.
			                if (mailSendCompleted == false) {
    			            	Transport.send(message);
    			            	
    			            	sentFolderMessageUID = 0;
    			            	mailSendCompleted = true;
			                }
			            				                	            				        		
                            // this deletion code block has been moved here because
                            // it needs to be kept in Drafts if an error occurs during the above process.
                            if (oldMessage != null) {
                                oldMessage.setFlag(Flags.Flag.DELETED, true);
                            }			        		
			            }
			            			            
			            //예악발송 수정창에서 예약발송 옵션 해제하고 저장했을 경우 메일이 바로 발송되므로 DB 데이터 삭제, 파일 시스템의 eml파일 삭제
			            logger.debug("reservedId=" + reservedId);
			            if (reservedId != null && !reservedId.trim().equals("")) {
							ezEmailService.deleteMailReserved(reservedId);
			            	
							String pDirPath = commonUtil.getUploadPath("upload_mail.RESERVED_MAIL_PATH", userInfo.getTenantId());
				    		pDirPath = realPath + pDirPath;
				            File f = new File(pDirPath + commonUtil.separator + reservedId + ".eml");
							if (f.exists()) {
								f.delete();
							}
			            }
			            
			            logger.debug("mailCmd=" + mailCmd + ",orgUrl=" + orgUrl);
			            
			            // set the ANSWERED flag of the original message to indicate it has been replied.
			            if (orgMailCmd.equals("REPLY") || orgMailCmd.equals("REPLYALL") || orgMailCmd.equals("FORWARD")) {
			    			int index = orgUrl.lastIndexOf("/");			
			    			
			    			if (index != -1) {
			    				String orgMsgFolderPath = orgUrl.substring(0, index);
			    				long orgMsgUid = Long.parseLong(orgUrl.substring(index + 1));
		
			    				logger.debug("orgMsgFolderPath=" + orgMsgFolderPath + ",orgMsgUid=" + orgMsgUid);
			    				
			    		        Folder orgMsgFolder = ia.getFolder(orgMsgFolderPath);
			    		        orgMsgFolder.open(Folder.READ_WRITE);
			    				
			    		        Message orgMessage = ((IMAPFolder)orgMsgFolder).getMessageByUID(orgMsgUid);
		    		        	
			    		        if (orgMessage != null) {
			    		        	if (orgMailCmd.equals("REPLY") || orgMailCmd.equals("REPLYALL")) {
				    		        	orgMessage.setFlag(Flags.Flag.ANSWERED, true);
				    		        	ezEmailUtil.setForwardedFlag(orgMessage, false);
				    		        	
				    		        }
				    		        else {
				    		        	ezEmailUtil.setForwardedFlag(orgMessage, true);
				    		        	orgMessage.setFlag(Flags.Flag.ANSWERED, false);
				    		        }
			    		        	// 전달, 회신 테스트
			    		        	ezEmailUtil.setSentDateFlag(orgMessage, true);
			    		        }
			    		        
			    		        orgMsgFolder.close(true);
			    			}
			            }
			            
			            // 보안메일 관련 임시파일 삭제
				        if (encryptedFile != null) {
				        	if (encryptedFile.delete()) {
				        		logger.debug("encryptedFile is deleted. fileName=" + encryptedFile.getName());
				        	}
				        }
			        }
			        
			        // file system의 templist txt파일 삭제
			        String pDirPath = realPath + commonUtil.getUploadPath("upload_mail.ROOT", userInfo.getTenantId()) + commonUtil.separator + "templist";
			        pDirPath += commonUtil.separator + stateName + ".txt";
			        File f = new File(pDirPath);
			        if (f.exists()) {
			        	f.delete();
			        }
			        
		        }
		        
		        // file system의 inline image 파일 삭제 - 경로가 upload_common인 파일만 삭제
		        // 발송의 경우에만 삭제하고 저장의 경우에는 쓰기 창이 계속 표시되어 있는 상태이므로 삭제하지 않고 유지한다.
		        // 남아있는 이미지 파일들은 스케쥴러에 의해 삭제되어야 함.
		        if (cmd.equalsIgnoreCase("SEND")) {
	    	        NodeList imagePathList = root.getElementsByTagName("IMAGEPATH");
	    	        if (imagePathList != null && imagePathList.getLength() > 0) {
	    	            String imagePath = "";
	    	            
	    	        	for (int i=0; true; i++) {
	    	            	if (imagePathList.item(i) == null) {
	    	            		break;
	    	            	}
	    	            	
	    	            	imagePath = imagePathList.item(i).getTextContent();
	    	            	
	    	            	if (!imagePath.trim().equals("") && imagePath.contains(commonUtil.getUploadPath("upload_common.ROOT", userInfo.getTenantId()))) {
	    	                	imagePath = new URL(imagePath).getPath();
	    	                	String pDirPath = realPath + imagePath;
	    	            		File f = new File(pDirPath);
	    	            		if (f.exists()) {
	    	            			f.delete();
	    	            		}
	    	            	}
	    	        	}
	    	        }
		        }
		        
		        draftFolder.close(true);
		        
		        pResult = "<RESULT>OK</RESULT>";
		        pResult += "<MESSAGEID><![CDATA[" + draftUID + "]]></MESSAGEID>";
		        
		        // useAutoSaveMailAddress가 YES일 경우, 외부수신자의 메일주소를 개인주소록에 자동 저장 (코린도)
				String autoSaveAddress = ezCommonService.getTenantConfig("useAutoSaveMailAddress", userInfo.getTenantId());
				
				if (autoSaveAddress.equals("YES")) {
					try {
						ezEmailUtil.outerMailInsertAddress(addressCheck, userId, userInfo.getTenantId(), 
								userAccount, userInfo.getDisplayName(), userInfo.getDisplayName1());
					} catch (Exception e) {
						logger.debug("AutoEmailAddress insert fail.");
						e.printStackTrace();
					}
				}
	        
			} catch (Exception e) {
				
				if (e.getMessage().indexOf("OVERQUOTA") > -1 && e.getMessage().indexOf("OVERMESSAGESIZE") > -1) {
					logger.error("mailInterSend : " + e.getMessage());
					pResult = e.getMessage();
				} else if (e.getMessage().indexOf("Invalid Addresses") > -1) {
					pResult = e.getMessage();
					String cause = e.getCause().toString();
					
					String pattern = "Unknown user: ([\\S]+)";
					Pattern r = Pattern.compile(pattern);
					Matcher m = r.matcher(cause);
					pResult = "Invalid Addresses:";
					
					int index = 1000;
					while (m.find()) {
						// 1000번 이상 반복되면 break한다.
						--index;
						if (index < 0) {
							logger.error("Stop finding invalid addresses, because over 1000 times.");
							break;
						}
						
						pResult += m.group(1) + "|";
					}
					
					pResult = pResult.substring(0, pResult.length() - 1);
				} else { // retry
					e.printStackTrace();
					
					retryFlag = true;
					--retryCount;
					
					if (retryCount > -1) {
						logger.debug("Message send fail. Retry...");
						
						try {
							Thread.sleep(1000);
						} catch (Exception ex) {}
					} else {
						//더이상 retry를 하지 않으므로 리턴 메시지를 세팅한다.
						pResult = e.getMessage();
					}
				}
			} finally {
				if (ia != null) {
					ia.close();
					ia = null;
				}
			}
			
		} while (retryFlag && retryCount > -1);
		
		// 즉시 발송의 경우
		if (cmd.equalsIgnoreCase("SEND") && delaySendTime.equals("")) {
		    // 보낸편지함에 메일이 저장되었지만 메일 전송이 성공하지 못했다면 해당 메일을 삭제한다.
		    if (mailSendCompleted == false && sentFolderMessageUID != 0) {
                Folder sentFolder = null;
                        
                try {
                    Thread.sleep(1000);
                    
                    ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
                    		userAccount, password, egovMessageSource, locale, ezEmailUtil);                
                    
                    sentFolder = ia.getFolder(ezEmailUtil.getSentFolderId(locale));
                    sentFolder.open(Folder.READ_WRITE);
                    Message sentMessage = ((IMAPFolder)sentFolder).getMessageByUID(sentFolderMessageUID);
                    sentMessage.setFlag(Flags.Flag.DELETED, true);
                    sentFolder.close(true);
                    sentFolder = null;
                    
                    logger.debug("sentFolderMessageUID message deleted successfully.");
                } catch (Exception e) {
                    logger.error("Failed to delete sentFolderMessageUID message. sentFolderMessageUID=" + sentFolderMessageUID);
                } finally {
                    if (sentFolder != null) {
                        try {
                            sentFolder.close(true);
                        } catch (Exception e) {}
                        
                        sentFolder = null;
                    }
                    
                    if (ia != null) {
                        ia.close();
                        ia = null;
                    }                    
                }                                           
		    }
		}
		
		logger.debug("mailInterSend ended. pResult=" + pResult);
		return "<DATA>" + pResult + "</DATA>";
	}
	
	/**
	 * 임시저장메일 삭제 실행 함수
	 */
	@RequestMapping(value="/ezEmail/delDrafts.do", produces = "text/html")
	@ResponseBody
	public String delDrafts(
			@CookieValue("loginCookie") String loginCookie, 
			Locale locale, 
			HttpServletRequest request) throws Exception {
		logger.debug("delDrafts started.");
		
		List<String> userInfo = commonUtil.getUserIdAndPassword(loginCookie);
		String password  = userInfo.get(1);
		
		String uidStr = request.getParameter("itemid");
		logger.debug("uidStr=" + uidStr);
		
		long uid = 0;
		if (uidStr != null && !uidStr.equals("")) {
			uid = Long.parseLong(uidStr);
		}
		
        LoginVO loginInfo = commonUtil.userInfo(loginCookie);
        
		if (uid != 0) {
    		String domainName = ezCommonService.getTenantConfig("domainName", loginInfo.getTenantId());
    		String userEmail = loginInfo.getId() + "@" + domainName;
    		
    		IMAPAccess ia = null;
    		try {
    			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
    					userEmail, password, egovMessageSource, locale, ezEmailUtil);
    			
    			Folder folder = ia.getFolder(ezEmailUtil.getDraftsFolderId(locale));
    			folder.open(Folder.READ_WRITE);
    			Message message = ((IMAPFolder)folder).getMessageByUID(uid);
    			logger.debug("message=" + message);
    			
    			if (message != null) {
    				message.setFlag(Flags.Flag.DELETED, true);
    			}
    	        folder.close(true);
    	        
    		} catch (MessagingException e) {
    			e.printStackTrace();
    		} finally {
    			if (ia != null) {
    				ia.close();
    			}
    		}
		}
		
		//첨부파일 정보파일(templist) 삭제
		String delId = request.getParameter("delid");
        String realPath = commonUtil.getRealPath(request);
        String pDirPath = realPath + commonUtil.getUploadPath("upload_mail.ROOT", loginInfo.getTenantId()) + commonUtil.separator + "templist";
        pDirPath += commonUtil.separator + delId + ".txt";
        File f = new File(pDirPath);
        if (f.exists()) {
        	f.delete();
        }
		
        logger.debug("delDrafts ended.");
        
		return "";
	}
	
	/**
	 * 첨부파일 정보파일(templist) 삭제 실행 함수
	 */
	@RequestMapping(value="/ezEmail/delAttachListFile.do", produces = "text/html")
	@ResponseBody
	public String delAttachListFile(
			@CookieValue("loginCookie") String loginCookie, 
			Locale locale, 
			HttpServletRequest request) throws Exception {
		logger.debug("delAttachListFile started.");
		
        LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String delId = request.getParameter("delid");
        String realPath = commonUtil.getRealPath(request);
        String pDirPath = realPath + commonUtil.getUploadPath("upload_mail.ROOT", userInfo.getTenantId()) + commonUtil.separator + "templist";
        pDirPath += commonUtil.separator + delId + ".txt";
        
        File f = new File(pDirPath);
        
        if (f.exists()) {
        	f.delete();
        }
        
        logger.debug("delAttachListFile ended.");
        
		return "";
	}
	
	/**
	 * 첨부파일 정보(templist) 반환 함수
	 */
	@RequestMapping(value="/ezEmail/fileListSession.do", produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String fileListSession(
			@CookieValue("loginCookie") String loginCookie, 
			Locale locale, 
			HttpServletRequest request) throws Exception {
		logger.debug("fileListSession started.");
		
		String fileData = request.getParameter("filedata") == null ? "" : request.getParameter("filedata");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String pDirPath = commonUtil.getUploadPath("upload_mail.ROOT", userInfo.getTenantId());
		String realPath = commonUtil.getRealPath(request);
		pDirPath = realPath + pDirPath;
		String xmlPath = pDirPath + commonUtil.separator + "templist" + commonUtil.separator + fileData + ".txt";
    	
		String returnValue = "";
		File f = new File(xmlPath);
        if (f.exists()) {
			InputStreamReader isr = null;
	    	BufferedReader br = null;
	    	try {
	        	isr = new InputStreamReader(new FileInputStream(f));
	        	br = new BufferedReader(isr);
	        	int read = 0;
				while ((read = br.read()) != -1) {
					returnValue += (char)read;
				}
	    	} catch(Exception e) {
	    		throw e;
	    	} finally {
	    		if (br != null) {
	    			br.close();
	    		}
	    		if (isr != null) {
	    			isr.close();
	    		}
	    	}
        }
		
        logger.debug("fileListSession ended.");
        
		return returnValue;
	}
	
	/**
	 * 일반 첨부파일 삭제 실행 함수
	 */
	@RequestMapping(value="/ezEmail/mailDelInterAttach.do", produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String mailDelInterAttach(
			@CookieValue("loginCookie") String loginCookie, 
			Locale locale, 
			HttpServletRequest request) throws Exception {
		logger.debug("mailDelInterAttach started.");
		
		List<String> userInfo = commonUtil.getUserIdAndPassword(loginCookie);
		String password  = userInfo.get(1);
		
		String returnValue = "<DATA><![CDATA[";
		
		Document xmlDoc = commonUtil.convertRequestToDocument(request);
		Element root = xmlDoc.getDocumentElement();
		
		long uid = 0;
		if (root.getElementsByTagName("ITEMID") != null) {
			String uidStr = root.getElementsByTagName("ITEMID").item(0).getTextContent();
			if (uidStr != null && !uidStr.trim().equals("")) {
				uid = Long.parseLong(uidStr);
			}
		}
		
		LoginVO loginInfo = commonUtil.userInfo(loginCookie);
		String domainName = ezCommonService.getTenantConfig("DomainName", loginInfo.getTenantId());
		String userEmail = loginInfo.getId() + "@" + domainName;
		
		if (uid != 0) {
			NodeList rows = root.getElementsByTagName("ROW");
			
			if (rows != null && rows.item(0) != null) {
				SMTPAccess sa = SMTPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.SMTPPort"),
						userEmail, password);
				
				IMAPAccess ia = null;
				try {
					ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
							userEmail, password, egovMessageSource, locale, ezEmailUtil);
					
					Folder folder = ia.getFolder(ezEmailUtil.getDraftsFolderId(locale));
					folder.open(Folder.READ_WRITE);
					Message oldMessage = ((IMAPFolder)folder).getMessageByUID(uid);
					
					if (oldMessage != null) {
						MimeMessage newMessage = sa.createMimeMessage();
						Multipart multipart = new MimeMultipart();
						
						Multipart mp = (Multipart)oldMessage.getContent();
						int count = mp.getCount();
						BodyPart p = null;
						int nonAttachCount = 0;
						
						// 첨부파일 파트 이전에 존재하는 파트들의 갯수를 구한다.
						// 이 로직이 제대로 동작하려면 첨부파일들이 모두 메시지의 뒷부분에 연속으로 위치하여야 한다.
						for (int i = 0; i < count; i++) {
							p = mp.getBodyPart(i);

							if (p.getDisposition() == null) {
								nonAttachCount++;
							} else {
								break;
							}
							}
							
						for (int i = 0; i < count; i++) {
							p = mp.getBodyPart(i);
							
							int length = rows.getLength();
							boolean isRemoved = false;
							
							// 파일의 index가 nonAttachCount 만큼 뒤로 밀렸으므로 i - nonAttachCount과 비교하여 파일을 삭제한다. 
								if (p.getDisposition() != null && p.getDisposition().equalsIgnoreCase(Part.ATTACHMENT)) {
									for (int j = 0; j < length; j++) {
//										String mailFileName = MimeUtility.decodeText(p.getFileName());
//										logger.debug("mailFileName : " + mailFileName + ", index i : " + (i-1));
//										logger.debug("rows.item(j).getFirstChild().getTextContent() : " + rows.item(j).getFirstChild().getTextContent());
//										logger.debug("rows.item(j).getChildNodes().item(1) : " + rows.item(j).getChildNodes().item(1).getTextContent());
									if (rows.item(j).getChildNodes().item(1).getTextContent().equals((i - nonAttachCount) + "")) {
											isRemoved = true;
											break;
										}
									}
								}
							
							if (!isRemoved) {
								multipart.addBodyPart(p);
							}
						}
						
						@SuppressWarnings("unchecked")
						Enumeration<Header> e = oldMessage.getAllHeaders();
						while(e.hasMoreElements()){
							Header header = e.nextElement();
							newMessage.setHeader(header.getName(), header.getValue());
						}
						//
						
						if (multipart.getCount() != 0) {
							newMessage.setContent(multipart);
							newMessage.setFlag(Flags.Flag.SEEN, true);
							AppendUID[] uids = ((IMAPFolder)folder).appendUIDMessages(new Message[]{newMessage});
							returnValue += uids[0].uid;
						}
						
						oldMessage.setFlag(Flags.Flag.DELETED, true);
						
					}
					folder.close(true);
					
				} catch (MessagingException e) {
					e.printStackTrace();
				} finally {
					if (ia != null) {
						ia.close();
					}
				}
			}
		}
		
		returnValue += "]]></DATA>";
		
		logger.debug("mailDelInterAttach ended. returnValue=" + returnValue);
		
		return returnValue;
	}
	
	/**
	 * 대용량 첨부파일 삭제 실행 함수
	 */
	@RequestMapping(value="/ezEmail/fileListDelete.do", produces = "text/plain; charset=utf-8")
	@ResponseBody
	public String fileListDelete(
			@CookieValue("loginCookie") String loginCookie, 
			Locale locale, 
			HttpServletRequest request) throws Exception{
		logger.debug("fileListDelete started.");
		
		String fileData = request.getParameter("filedata") != null ? request.getParameter("filedata") : "";
		String realFileNM = request.getParameter("realFileNM") != null ? request.getParameter("realFileNM") : "";
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String pDirPath = commonUtil.getUploadPath("upload_mail.ROOT", userInfo.getTenantId());
		String realPath = commonUtil.getRealPath(request);
		pDirPath = realPath + pDirPath;
		String xmlPath = pDirPath + commonUtil.separator + "templist" + commonUtil.separator + fileData + ".txt";
		
		File templistFile = new File(xmlPath);
		if (templistFile.exists()) {
			String strXml = "";
			InputStreamReader isr = null;
			try {
				isr = new InputStreamReader(new FileInputStream(xmlPath));
			    int read = 0;
				while ((read = isr.read()) != -1) {
					strXml += (char)read;
				}
			} finally {
				if (isr != null) {
					isr.close();
				}
			}
			
			Document xmlDom = commonUtil.convertStringToDocument(strXml);
			NodeList nodeList = xmlDom.getElementsByTagName("NODE");
			
			if (nodeList != null) {
				for (int i=0; i<nodeList.getLength(); i++) {
					if (nodeList.item(i).getFirstChild().getTextContent().equals(realFileNM)) {
						String fileLocation = nodeList.item(i).getChildNodes().item(4).getTextContent();
						String[] fileLocationArray = fileLocation.split("\\|!\\|");
						String pRealFilePath = pDirPath + commonUtil.separator + fileLocationArray[0] + commonUtil.separator + fileLocationArray[1];
						File bigAttachFile = new File(pRealFilePath);
						
						if (bigAttachFile.exists()) {
							bigAttachFile.delete();
							File bigAttachNameFile = new File(pRealFilePath+"__.txt");
							bigAttachNameFile.delete();
						}

						nodeList.item(i).getParentNode().removeChild(nodeList.item(i));
					}
				}
			}
			
			String strXml2 = commonUtil.convertDocumentToString(xmlDom);
			logger.debug("strXml : "+strXml);
			logger.debug("strXml2 : "+strXml2);
			
			OutputStreamWriter osw = null;
			try {
				osw = new OutputStreamWriter(new FileOutputStream(xmlPath), "UTF-8");
				osw.write(strXml2);
			} finally {
				if (osw != null) {
					osw.close();
				}
			}
		}
		
		logger.debug("fileListDelete ended.");
		
		return "";
	}
	
	/**
	 * 사원 정보 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailNameCheck.do", produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String mailNameCheck(
			@CookieValue("loginCookie") String loginCookie, 
			Model model, 
			HttpServletRequest request) throws Exception{
		logger.debug("mailNameCheck started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String pOrganSearchList = "";
		String pOrganCellList = "displayname";
		String pOrganPropList = "company;description;title;mail;extensionAttribute3";
		String pOrganListType = "all";
		String pDLSearchList = "";
		String pDLCellList = "displayname";
		String pDLPropList = "mail";
		String pDLListType = "group";
		String pAddressFilter = "";
		
		Document xmlDoc = commonUtil.convertRequestToDocument(request);
		Element root = xmlDoc.getDocumentElement();
		
		Node tempNode = null;
		if (root.getElementsByTagName("ORGSEARCH") != null) {
			tempNode = root.getElementsByTagName("ORGSEARCH").item(0);
			if (tempNode != null && !tempNode.getTextContent().equals("")) {
				pOrganSearchList = tempNode.getTextContent();
			}
		}
		if (root.getElementsByTagName("DLGSEARCH") != null) {
			tempNode = root.getElementsByTagName("DLGSEARCH").item(0);
			if (tempNode != null && !tempNode.getTextContent().equals("")) {
				pDLSearchList = tempNode.getTextContent();
			}
		}
		if (root.getElementsByTagName("CELL") != null) {
			tempNode = root.getElementsByTagName("CELL").item(0);
			if (tempNode != null && !tempNode.getTextContent().equals("")) {
				pOrganCellList = tempNode.getTextContent();
				pDLCellList = tempNode.getTextContent();
			}
		}
		if (root.getElementsByTagName("ORGPROP") != null) {
			tempNode = root.getElementsByTagName("ORGPROP").item(0);
			if (tempNode != null && !tempNode.getTextContent().equals("")) {
				pOrganPropList = tempNode.getTextContent();
			}
		}
		if (root.getElementsByTagName("DLPROP") != null) {
			tempNode = root.getElementsByTagName("DLPROP").item(0);
			if (tempNode != null && !tempNode.getTextContent().equals("")) {
				pDLPropList = tempNode.getTextContent();
			}
		}
		if (root.getElementsByTagName("ORGTYPE") != null) {
			tempNode = root.getElementsByTagName("ORGTYPE").item(0);
			if (tempNode != null && !tempNode.getTextContent().equals("")) {
				pOrganListType = tempNode.getTextContent();
			}
		}
		if (root.getElementsByTagName("DLTYPE") != null) {
			tempNode = root.getElementsByTagName("DLTYPE").item(0);
			if (tempNode != null && !tempNode.getTextContent().equals("")) {
				pDLListType = tempNode.getTextContent();
			}
		}
		if (root.getElementsByTagName("ADDFILTER") != null) {
			tempNode = root.getElementsByTagName("ADDFILTER").item(0);
			if (tempNode != null && !tempNode.getTextContent().equals("")) {
				pAddressFilter = tempNode.getTextContent();
			}
		}
        
        String organXML = getOrganSearch(pOrganSearchList, pOrganCellList, pOrganPropList, pOrganListType, userInfo);
        String dlXML = getOrganDLSearch(pDLSearchList, userInfo);
        String addressXML = getAddressSearch(pAddressFilter, userInfo);
        
        logger.debug("mailNameCheck ended.");
        return String.format("<RESULT><ORGAN>%s</ORGAN><DL>%s</DL><ADDRESS>%s</ADDRESS></RESULT>", organXML, dlXML, addressXML);
	}
	
	/**
	 * 사원 이름으로 메일 찾기 화면 호출 함수 
	 */
	@RequestMapping(value="/ezEmail/mailCheckName.do")
	public String mailCheckName(
			@CookieValue("loginCookie") String loginCookie, 
			Model model, 
			HttpServletRequest request) throws Exception{
		
		return "ezEmail/mailCheckName";
	}
	
	/**
	 * 편지쓰기 창에서 입력받은 메일이 존재하는지 검색. 
	 * 메일쓰기 창에서 받는사람 도메인 확인 메소드
	 */
	@RequestMapping(value="/ezEmail/mailCheck.do")
	@ResponseBody
	public List<String> mailCheck(@CookieValue("loginCookie") String loginCookie, Locale locale, 
			Model model, HttpServletRequest request) throws Exception{
		logger.debug("mailCheck started.");
		LoginVO loginVO = commonUtil.userInfo(loginCookie);
		String email = request.getParameter("name");
		List<String> resultList = new ArrayList<String>();

		String inputParams = "address=" + URLEncoder.encode(email, "UTF-8");
		
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
		
        int usercnt = ezOrganAdminService.userCountCheck(email, loginVO.getTenantId());
        
        if (usercnt >= 0) {
        	object.put("usercnt", usercnt);
        }
        
        
        logger.debug("usercnt="  + usercnt);
		logger.debug("mailCheck ended.");
		
		return resultList;
	}
	
	/**
	 * 메일 옵션화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/letterOption.do")
	public String mailLetterOption(
			@CookieValue("loginCookie") String loginCookie, 
			Locale locale, 
			Model model, 
			HttpServletRequest request) throws Exception{
		logger.debug("mailLetterOption started.");
		
		//TODO: 변수들 setting
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		int tenantId = userInfo.getTenantId();
		
		String individualMailUser = ezCommonService.getTenantConfig("INDIVIDUALMAILUSER", tenantId);
		String useOnlyInnerMail = ezCommonService.getTenantConfig("UseOnlyInnerMail", tenantId);
		String offsetMin = commonUtil.getMinuteUTC(userInfo.getOffset());
		String useReceiptExternal = ezCommonService.getTenantConfig("useReceiptExternal", tenantId);
		
		model.addAttribute("offsetMin", offsetMin);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("individualMailUser", individualMailUser);
		model.addAttribute("useOnlyInnerMail", useOnlyInnerMail);
		model.addAttribute("useReceiptExternal", useReceiptExternal);
		
		logger.debug("mailLetterOption ended.");
		return "ezEmail/mailLetterOption";
	}
	
	/**
	 * 보안메일 설정화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailSecureOption.do")
	public String mailSecureOption(
			@CookieValue("loginCookie") String loginCookie, 
			Locale locale, 
			Model model) throws Exception{
		logger.debug("mailSecureOption started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String offsetMin = commonUtil.getMinuteUTC(userInfo.getOffset());
		
		// client단에 publicKey 뿌림
		String publicModulus = egovFileScrty.getPbm();
		String publicExponent = "10001";
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("offsetMin", offsetMin);
		model.addAttribute("publicModulus", publicModulus);
		model.addAttribute("publicExponent", publicExponent);
		
		logger.debug("mailSecureOption ended.");
		return "ezEmail/mailSecureOption";
	}

	/**
	 * 메일쓰기 - 조직도(받는사람,참조,숨은참조) 화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailNewReceiverChoose.do")
	public String mailNewReceiverChoose(
			@CookieValue("loginCookie") String loginCookie, 
			Locale locale, 
			Model model, 
			HttpServletRequest request) throws Exception{
		logger.debug("mailNewReceiverChoose started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String defaultWin = request.getParameter("defaultwin") == null ? "To" : request.getParameter("defaultwin").trim();
		String type = request.getParameter("type") == null ? "" : request.getParameter("type").trim();
		String ruleKind = request.getParameter("ruleKind") == null ? "" : request.getParameter("ruleKind").trim();
		String useOcs = config.getProperty("config.USE_OCS") == null ? "" : config.getProperty("config.USE_OCS");
		
		model.addAttribute("defaultWin", defaultWin);
		model.addAttribute("type", type);
		model.addAttribute("ruleKind", ruleKind);
		model.addAttribute("useOcs", useOcs);
		model.addAttribute("userInfo", userInfo);
		
		logger.debug("mailNewReceiverChoose ended.");
		return "ezEmail/mailNewReceiverChoose";
	}
	
	/**
	 * 메일쓰기 - 공용배포그룹(받는사람,참조,숨은참조) 정보 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailGetDistribution.do", produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String mailGetDistribution(
			@CookieValue("loginCookie") String loginCookie, 
			Locale locale, 
			Model model, 
			HttpServletRequest request) throws Exception{
		logger.debug("mailGetDistribution started.");
		
		String returnData = "";
		
		try {
			LoginVO userInfo = commonUtil.userInfo(loginCookie);
			
			List<MailDistributionVO> distributionList = ezEmailService.getDistributionList(userInfo.getCompanyID(), userInfo.getTenantId());
			
			StringBuilder sb = new StringBuilder();
			sb.append("<LISTVIEWDATA><ROWS>");

			for (MailDistributionVO vo : distributionList) {
				sb.append("<ROW><CELL>");
				
				sb.append("<VALUE>");
				sb.append(commonUtil.cleanValue(vo.getName()));
				sb.append("</VALUE>");
				
				sb.append("<DATA1>");
				sb.append(commonUtil.cleanValue(vo.getId()));
				sb.append("</DATA1>");
				
				sb.append("<DATA2>");
				sb.append(commonUtil.cleanValue(vo.getMail()));
				sb.append("</DATA2>");
				
				sb.append("</CELL></ROW>");
			}
			
			sb.append("</ROWS></LISTVIEWDATA>");
			
			returnData = sb.toString();
			
		} catch (Exception e) {
			returnData = "ERROR";
			e.printStackTrace();
		}

		logger.debug("mailGetDistribution ended.");
		return returnData;
	}
	
	/**
	 * 메일쓰기 - 공용배포그룹 구성원 보기 및 선택 화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailSelectDLMember.do")
	public String mailSelectDLMember(
			@CookieValue("loginCookie") String loginCookie, 
			Locale locale, 
			Model model, 
			HttpServletRequest request) throws Exception{
		logger.debug("mailSelectDLMember started.");
		
	    LoginVO userInfo = commonUtil.userInfo(loginCookie);
	    
		String isUser = "";
		List<Map<String, String>> list = new ArrayList<Map<String, String>>();
		
		String cn = request.getParameter("cn");
		String domain = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
		String companyName = userInfo.getCompanyName();
		
		try {
			String inputParams = "cn=" + URLEncoder.encode(cn, "UTF-8")
							   + "&domain=" + URLEncoder.encode(domain, "UTF-8");
			
			logger.debug("inputParams=" + inputParams);
			
			String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaAccess/getDistribution";
			String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
			
			logger.debug("response=" + response);
			
			JSONArray resultArray = null;
			
			if (response != null) {
				JSONParser jsonParser = new JSONParser();
				JSONObject responseObj = (JSONObject)jsonParser.parse(response);

				String resultCode = (String)responseObj.get("resultCode");
				
				if (resultCode.equalsIgnoreCase("OK")) {
					resultArray = (JSONArray)responseObj.get("result");
				}
			}
			
			for (int i=0; i<resultArray.size(); i++) {
				JSONObject address = (JSONObject)resultArray.get(i);
				String pCn = (String)address.get("cn");
				pCn = pCn.substring(0, pCn.indexOf("@"));
				isUser = (String)address.get("class");
				String displayName = (String) address.get("displayName");

				logger.debug("pCn=" + pCn + ", isUser=" + isUser + ", displayName=" + displayName);
				
				if(isUser.equals("group")) {
					OrganDeptVO dept = ezOrganService.getDeptInfo(pCn, userInfo.getPrimary(), userInfo.getTenantId());

					Map<String, String> map = new HashMap<String, String>();
					
					if (dept != null) { // 부서
						map.put("displayName", dept.getDisplayName());
						map.put("mail", dept.getMail());
						map.put("company", dept.getExtensionAttribute3());
						map.put("dept", dept.getDisplayName());
						map.put("title", "");
					} else { // 공용배포그룹
						map.put("displayName", displayName); // 배포그룹 이름
						map.put("mail", (String)address.get("cn"));  // 메일
						map.put("company", companyName); // 배포그룹 이름
						map.put("dept", egovMessageSource.getMessage("ezEmail.t57",
								locale));  //배포그룹이름
						map.put("title", ""); // ""
					}
					list.add(map);
				} else {
					OrganUserVO user = ezOrganAdminService.getUserInfo(pCn, userInfo.getPrimary(), userInfo.getTenantId());
					
					Map<String, String> map = new HashMap<String, String>();
					map.put("displayName", user.getDisplayName());
					map.put("mail", user.getMail());
					map.put("company", user.getCompany());
					map.put("dept", user.getDescription());
					map.put("title", user.getTitle());
					
					list.add(map);
				}
				
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		model.addAttribute("isUser", isUser);
		model.addAttribute("list", list);
		
		logger.debug("mailSelectDLMember ended.");
		return "ezEmail/mailSelectDLMember";
	}
	
	/**
	 * 간편주소록 정보 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailGetAddress.do", produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String mailGetAddress(
			@CookieValue("loginCookie") String loginCookie, 
			Locale locale, 
			Model model, 
			HttpServletRequest request) throws Exception{
		logger.debug("mailGetAddress started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		List<SimpleAddressVO> addressList = ezAddressService.getSimpleAddress(userInfo.getTenantId(), userInfo.getId());
		
		StringBuilder sb = new StringBuilder();
		sb.append("<NewDataSet>");
		
		for (SimpleAddressVO vo : addressList) {
			sb.append("<Table>");
			sb.append("<NAME><![CDATA[" + vo.getName() + "]]></NAME>");
			sb.append("<EMAIL><![CDATA[" + vo.getEmail() + "]]></EMAIL>");
			sb.append("</Table>");
		}
		
		sb.append("</NewDataSet>");
		
		logger.debug("mailGetAddress ended.");
		return sb.toString();
	}
	
	/**
	 * 간편주소록 정보 저장 함수
	 */
	@RequestMapping(value="/ezEmail/mailSetAddress.do", produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String mailSetAddress(
			@CookieValue("loginCookie") String loginCookie, 
			Locale locale, 
			Model model, 
			@RequestBody String bodyData) throws Exception{
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		ezAddressService.setSimpleAddress(userInfo.getTenantId(), userInfo.getId(), bodyData);
		
		return "<DATA>OK</DATA>";
	}
	
	
	/**
	 * 사원 Organ 정보 호출 함수
	 */
	private String getOrganSearch(String pSearchList, String pCellList, String pPropList, String pListType, LoginVO userInfo) {
		String pResult = "";
        try {
            pResult = ezOrganService.getSearchListOR(pSearchList, pCellList, pPropList, pListType, 100, userInfo.getPrimary(), userInfo.getTenantId());
        } catch (Exception e) {
        	e.printStackTrace();
            pResult = "EXCEPTION";
        }
        return pResult;
    }
	
	/**
	 * 공용배포그룹 정보 호출 함수
	 */
	private String getOrganDLSearch(String pSearchList, LoginVO userInfo) {
        String returnData = "";
        
        try {
        	String searchValue = pSearchList.split("::")[1];
        	
			List<MailDistributionVO> distributionList = ezEmailService.getDistributionSearchList(userInfo.getCompanyID(), userInfo.getTenantId(), searchValue);
			
			StringBuilder sb = new StringBuilder();
			sb.append("<LISTVIEWDATA><ROWS>");

			for (MailDistributionVO vo : distributionList) {
				sb.append("<ROW><CELL>");
				
				sb.append("<VALUE>");
				sb.append(commonUtil.cleanValue(vo.getName()));
				sb.append("</VALUE>");
				
				sb.append("<DATA1>group</DATA1>");
				
				sb.append("<DATA2>");
				sb.append(commonUtil.cleanValue(vo.getId()));
				sb.append("</DATA2>");
				
				sb.append("<DATA3>");
				sb.append(commonUtil.cleanValue(vo.getMail()));
				sb.append("</DATA3>");
				
				sb.append("</CELL></ROW>");
			}
			
			sb.append("</ROWS></LISTVIEWDATA>");
			
			returnData = sb.toString();
			
		} catch (Exception e) {
			returnData = "EXCEPTION";
			e.printStackTrace();
		}
        
        return returnData;
    }
	
	/**
	 * 주소록 정보 호출 함수
	 */
	private String getAddressSearch(String pFilter, LoginVO userInfo) {
        String returnValue = "";
        try {
            String[] ownerIds = new String[]{userInfo.getCompanyID(), userInfo.getDeptID(), userInfo.getId()};
            pFilter = "S_NAME;S_EMAIL," + pFilter;
            
            List<AddressVO> addressInfoList = ezAddressService.getSearchList(userInfo.getTenantId(), ownerIds, "", pFilter, 100, 0);
            
            StringBuilder sb = new StringBuilder();
            sb.append("<LISTVIEWDATA><ROWS>");
            
            for (AddressVO addressInfo : addressInfoList) {
            	sb.append("<ROW>");
            	sb.append("<STYPE>" + (addressInfo.getsType() == null ? "" : addressInfo.getsType()) + "</STYPE>");
            	sb.append("<ADDRESSID>" + (addressInfo.getAddressId() == null ? "" : addressInfo.getAddressId()) + "</ADDRESSID>");
            	sb.append("<SNAME>" + (addressInfo.getsName() == null ? "" : commonUtil.cleanValue(addressInfo.getsName())) + "</SNAME>");
            	sb.append("<FOLDERTYPE>DB</FOLDERTYPE>");
            	sb.append("<SEMAIL>" + (addressInfo.getsEmail() == null ? "" : commonUtil.cleanValue(addressInfo.getsEmail())) + "</SEMAIL>");
            	sb.append("<SCOMPANY>" + (addressInfo.getsCompany() == null ? "" : commonUtil.cleanValue(addressInfo.getsCompany())) + "</SCOMPANY>");
            	sb.append("<SDEPT>" + (addressInfo.getsDept() == null ? "" : commonUtil.cleanValue(addressInfo.getsDept())) + "</SDEPT>");
            	sb.append("<STITLE>" + (addressInfo.getsTitle() == null ? "" : commonUtil.cleanValue(addressInfo.getsTitle())) + "</STITLE>");
            	sb.append("</ROW>");
            }
            
            sb.append("</ROWS></LISTVIEWDATA>");
            returnValue = sb.toString();
        } catch (Exception e) {
        	e.printStackTrace();
        	returnValue = "EXCEPTION";
        }
        return returnValue;
    }
	
	private String convertDownloadInlineImageURLtoCid(String htmlStr) {
		Pattern pat = Pattern.compile("src=\"/ezEmail/downloadInline\\.do.*?contentId=%3C(.*?)%3E\"", Pattern.CASE_INSENSITIVE | Pattern.DOTALL);
		Matcher mat = pat.matcher(htmlStr);
				
		StringBuffer result = new StringBuffer();
		while (mat.find()) {
			String cid = mat.group(1);
			try {
				cid = URLDecoder.decode(cid, "UTF-8");
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
			}
			mat.appendReplacement(result, Matcher.quoteReplacement("src=\"cid:" + cid + "\""));
		}
		mat.appendTail(result);
		
		return result.toString();	
	}
	
	private void removeUnusedInlineImagePart(Multipart relatedPart) {
		try {
			String htmlStr = relatedPart.getBodyPart(0).getContent().toString();
			int count = relatedPart.getCount() - 1;
			
			for (int i = count; i >= 1; i--) {
				MimeBodyPart bp = (MimeBodyPart)relatedPart.getBodyPart(i);
				
				if (bp.getDisposition() != null) {
					String contentID = bp.getContentID();
					
					if (contentID != null && contentID.length() > 2) {
						contentID = contentID.substring(1, contentID.length() - 1);
						if (htmlStr.indexOf("src=\"cid:" + contentID) < 0) {
							logger.debug("this inline image isn't used. contentID=" + contentID);
							relatedPart.removeBodyPart(i);
						}
					}
				}
			}
		} catch (IOException e) {
			e.printStackTrace();
		} catch (MessagingException e) {
			e.printStackTrace();
		}
	}
	
	private boolean isHtmlMessage(Message message) throws MessagingException, IOException {
		if (message.getHeader("Content-Type") == null) {
			return true;
		}
		
		String tempBodyType = message.getHeader("Content-Type")[0];
		String contentType = tempBodyType.split(";")[0].trim();

		if (contentType.equals("text/plain")) {
			return false;
		} else if (contentType.equals("multipart/alternative")) {
			return true;
		}
		
		Object content = message.getContent();
		
		if (content instanceof Multipart) {
			return containsHtmlMultipart((Multipart) content);
		}
		
		return true;
	}
	
	private boolean containsHtmlMultipart(Multipart multipart) throws MessagingException, IOException {
		int partCount = multipart.getCount();
		
		Object partContent;

		for (int i = 0; i < partCount; i++) {
			BodyPart bodyPart = multipart.getBodyPart(i);
			
			if (BodyPart.ATTACHMENT.equalsIgnoreCase(bodyPart.getDisposition())) {
				continue;
			}
			
			partContent = bodyPart.getContent();
			
			if (partContent instanceof Multipart && containsHtmlMultipart((Multipart) partContent)) {
				return true;
			}

			if (bodyPart.isMimeType("text/html") || bodyPart.isMimeType("message/*")) {
				return true;
			}
		}

		return false;
	}
	
	/**
	 * 메일 예약발송 처리 함수
	 */
	private void doDelaySend(int tenantId, Message message, String isReserve, String reservedId, String subject, String sendDate, String userId, String realPath) throws Exception {
		logger.debug("isReserve : " + isReserve);
		logger.debug("subject : " + subject);
		logger.debug("sendDate : " + sendDate);
		logger.debug("reservedId : " + reservedId);
		
		String messageId = reservedId;
		
		messageId = ezEmailService.setMailReserved(tenantId, messageId, subject, sendDate, userId, isReserve);
		
		File f = null;
		
		String pDirPath = commonUtil.getUploadPath("upload_mail.RESERVED_MAIL_PATH", tenantId);
		pDirPath = realPath + pDirPath;
		f = new File(pDirPath);
		if (!f.exists()) {
			f.mkdirs();
		}
		
		f = new File(pDirPath + commonUtil.separator + messageId + ".eml");
    	FileOutputStream fos = null;
    	try {
    		fos = new FileOutputStream(f);
    		message.writeTo(fos);
    	} catch (IOException e) {
    		logger.error("IOException has occurred");
    		e.printStackTrace();
    	} finally {
    		if (fos != null) {
    			fos.close();
    		}
    	}
	}
	
	/**
	 * 받는사람, 참조, 숨은참조 등 자동완성 기능
	 */
	@RequestMapping(value = "/ezEmail/autoCompleteList.do", produces = "text/xml; charset=utf-8")
	public String autoCompleteList(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model,
			HttpServletRequest request) throws Exception {
		logger.debug("autoCompleteList started.");

		String searchValue = request.getParameter("value");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		String pOrganSearchList = "displayname::" + searchValue + ";;mail::" + searchValue;
		String pOrganCellList = "displayname";
		String pOrganPropList = "company;description;title;mail;extensionAttribute3;displayName2";
		String pOrganListType = "all";
		String pDLSearchList = "displayname::" + searchValue;
		String pAddressFilter = searchValue;

		try {
			Document organXML = commonUtil.convertStringToDocument(
					getOrganSearch(pOrganSearchList, pOrganCellList, pOrganPropList, pOrganListType, userInfo));
			Document dlXML = commonUtil.convertStringToDocument(getOrganDLSearch(pDLSearchList, userInfo));
			Document addressXML = commonUtil.convertStringToDocument(getAddressSearch(pAddressFilter, userInfo));

			HashMap<String, Object> jsonObject = null;
			List<Object> jsonList = new ArrayList<Object>();

			NodeList organRow = organXML.getElementsByTagName("ROW");
			for (int i = 0; i < organRow.getLength(); i++) {
				Element row = (Element) organRow.item(i);
				NodeList organList = row.getElementsByTagName("CELL");
				Element organCell = (Element) organList.item(0);
				if(organCell.getElementsByTagName("DATA6").item(0).getTextContent().trim() != "" || organCell.getElementsByTagName("DATA6").item(0).getTextContent().trim() != null){
					jsonObject = new HashMap<String, Object>();
					jsonObject.put("name", organCell.getElementsByTagName("VALUE").item(0).getTextContent());
					jsonObject.put("title", organCell.getElementsByTagName("DATA5").item(0).getTextContent());
					jsonObject.put("description", organCell.getElementsByTagName("DATA4").item(0).getTextContent());
					jsonObject.put("mail", organCell.getElementsByTagName("DATA6").item(0).getTextContent());
					jsonObject.put("type", "");
					jsonList.add(jsonObject);
				}
			}

			NodeList dlRow = dlXML.getElementsByTagName("ROW");
			for (int i = 0; i < dlRow.getLength(); i++) {
				Element row = (Element) dlRow.item(i);
				NodeList dlList = row.getElementsByTagName("CELL");
				Element dlCell = (Element) dlList.item(0);
				if(dlCell.getElementsByTagName("DATA3").item(0).getTextContent().trim() != "" || dlCell.getElementsByTagName("DATA3").item(0).getTextContent().trim() != null){
					jsonObject = new HashMap<String, Object>();
					jsonObject.put("name", dlCell.getElementsByTagName("VALUE").item(0).getTextContent());
					jsonObject.put("title", "");
					jsonObject.put("description", egovMessageSource.getMessage("ezEmail.t593", locale));
					jsonObject.put("mail", dlCell.getElementsByTagName("DATA3").item(0).getTextContent());
					jsonObject.put("type", "");
					jsonList.add(jsonObject);
				}
			}

			NodeList addressRow = addressXML.getElementsByTagName("ROW");
			for (int i = 0; i < addressRow.getLength(); i++) {
				Element row = (Element) addressRow.item(i);
				if(row.getElementsByTagName("SEMAIL").item(0).getTextContent().trim() != "" || row.getElementsByTagName("SEMAIL").item(0).getTextContent().trim() != null){
					jsonObject = new HashMap<String, Object>();
					jsonObject.put("name", row.getElementsByTagName("SNAME").item(0).getTextContent());
					jsonObject.put("title", "");
					jsonObject.put("description", egovMessageSource.getMessage("ezEmail.t99000041", locale));
					jsonObject.put("mail", row.getElementsByTagName("SEMAIL").item(0).getTextContent());
					jsonObject.put("type", row.getElementsByTagName("STYPE").item(0).getTextContent());
					jsonList.add(jsonObject);
				}
			}
			model.addAttribute("susinList", jsonList);
		} catch (Exception e) {

		}

		logger.debug("autoCompleteList ended.");
		return "json";
	}
	
	/**
	 * size만 읽는 OutputStream 클래스
	 */
	public class CountOutputStream extends OutputStream {
	    int size;
		
	    public int getSize() {
	    	return size;
	    }
	    
	    @Override
	    public void write(byte[] b, int off, int len) {
	    	size += len;
	    }

	    @Override
	    public void write(int b) {
	    	size += 1;
	    }

	    @Override
	    public void write(byte[] b) throws IOException {
	    	size += b.length;
	    }
	}
}
