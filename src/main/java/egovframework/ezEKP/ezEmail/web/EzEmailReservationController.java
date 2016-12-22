package egovframework.ezEKP.ezEmail.web;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;
import java.util.UUID;

import javax.annotation.Resource;
import javax.mail.Address;
import javax.mail.Flags;
import javax.mail.Folder;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;

import com.sun.mail.imap.AppendUID;
import com.sun.mail.imap.IMAPFolder;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.logic.IMAPAccess;
import egovframework.ezEKP.ezEmail.logic.SMTPAccess;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezEmail.util.EzEmailUtil;
import egovframework.ezEKP.ezEmail.vo.MailColorVO;
import egovframework.ezEKP.ezEmail.vo.MailReservationVO;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.ClientUtil;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;
import egovframework.let.utl.fcc.service.EgovStringUtil;

/**
 * @Description [Controller] 메일 예약발송관리
 * @author 오픈솔루션팀 이효민
 * @Modification Information
 * 
 *    수정일        수정자         수정내용
 *    ----------    ------    -------------------
 *    2016.05.18    이효민    신규작성
 *
 * @see
 */

@Controller
public class EzEmailReservationController extends EgovFileMngUtil {

	private static final Logger logger = LoggerFactory.getLogger(EzEmailReservationController.class);

	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;

	@Resource(name = "egovMessageSource")
	private EgovMessageSource egovMessageSource;

	@Autowired
	private EzOrganAdminService ezOrganAdminService;

	@Autowired
	private EzEmailService ezEmailService;
	
	@Resource(name = "EzCommonService")
    private EzCommonService ezCommonService;
	
	@Autowired
	private EzEmailUtil ezEmailUtil;

	/**
	 * 메일 예약발송 화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailReservation.do")
	public String mailReservation(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		String draftUrl = "";
		String useEditor = config.getProperty("config.EDITOR");
		String useIE11Browser = "";
		String noneActiveX = "YES";
		
		if ((request.getHeader("User-Agent").indexOf("rv:11") > 0 || request.getHeader("User-Agent").indexOf("Trident/7.0") > 0) && config.getProperty("config.IE11EDITOR").equals("CK")) {
        	useIE11Browser = "CK";
        }
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		List<MailReservationVO> list = ezEmailService.getMailReserved(userInfo.getTenantId(), userInfo.getId());
		
		for (MailReservationVO vo : list) {
			vo.setSendDate(commonUtil.getDateStringInUTC(vo.getSendDate(), userInfo.getOffset(), false));
		}
		
		model.addAttribute("draftUrl", draftUrl);
		model.addAttribute("useEditor", useEditor);
		model.addAttribute("useIE11Browser", useIE11Browser);
		model.addAttribute("noneActiveX", noneActiveX);
		model.addAttribute("list", list);

		return "ezEmail/mailReservation";
	}

	/**
	 * 예약발송메일 삭제 함수
	 */
	@RequestMapping(value="/ezEmail/mailDeleteReservedMail.do")
	@ResponseBody
	public String mailDeleteReservedMail(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		logger.debug("mailDeleteReservedMail started.");
		
		String messageId = request.getParameter("messageid") == null ? "" : request.getParameter("messageid");
		
		ezEmailService.deleteMailReserved(messageId);
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String realPath = commonUtil.getRealPath(request);
		String pDirPath = commonUtil.getUploadPath("upload_mail.RESERVED_MAIL_PATH", userInfo.getTenantId());
		pDirPath = realPath + pDirPath;
		File f = new File(pDirPath + commonUtil.separator + messageId + ".eml");

		if (f.exists()) {
			f.delete();
			logger.debug(pDirPath + commonUtil.separator + messageId + ".eml deleted.");
		}

		logger.debug("mailDeleteReservedMail ended.");
		
		return "";
	}

	/**
	 * 예약발송메일 수정 화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailEdit.do")
	public String mailEdit(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		logger.debug("mailEdit started.");
		
		String cmd = "";
		String senderInfo = "";
		String importance = "1";
		String postType = "";
		String url = "";
		String unread = "0";
		String sendFrom = "";
		String useMultiLangMail = "";
		String displayNamePrintable = "";
		String charsetCheck = "1";
		String userInfoApprovalG = "";
		String reSendFlag = "N";
		String bigSizeMailAttachLimit = "20";
		String totBigSizeMailAttachLimit = "20";
		String mailAttachLimit = "20";
		String bigSizeMailAttachDelDay = "";
		String userLang = "";
		String userTimeset = "";
		String userPrimary = "";
		String cmdOwn = "";
		String urlOwn = "";
		String fileUploadType = "";
		int individualMailUser = 0;
		String pSecurity = "1";
		String mailInnerDomain = "";
		String inMailColor = "";
		String outMailColor = "";
		String docHref = "";
		String pReservedSaveTime = "";
		String pCDOMessageID = "";
		String useEditor = "";
		String stateName = "";
		String folderDate = "";
		String pBigAttachDownloadDay = "";
		String pBigAttachDownloadPeriod = "";
		String mailSignSel = "0";
		String strSelectHtml = "";
		String subject = "";
		String body = "";
		String to = "";
		String cc = "";
		String bcc = "";
		String from = "";
		String pAttachWarning = "";
		String attachCK = "";
		String showDisplay = "";
		long uid = 0;
		
		// get user credentials
		List<String> userIdnPw = commonUtil.getUserIdAndPassword(loginCookie);
		String password  = userIdnPw.get(1);
		
		LoginVO loginInfo = commonUtil.userInfo(loginCookie);
		
		String serverName = loginInfo.getServerName();
		
		stateName = UUID.randomUUID().toString();
		folderDate = EgovDateUtil.getToday("");
		useEditor = config.getProperty("config.EDITOR");
		mailInnerDomain = ezCommonService.getTenantConfig("MailInnerDomain", loginInfo.getTenantId());
		individualMailUser = EgovStringUtil.isEmpty(config.getProperty("config.INDIVIDUALMAILUSER").trim()) ?
				0 : Integer.parseInt(config.getProperty("config.INDIVIDUALMAILUSER").trim());
		
		//TODO: docHref값에 따른 jsp페이지의 placeholder 바꾸기
		docHref = request.getParameter("dochref") == null ? "" : request.getParameter("dochref").trim();
		MimeMessage message = null;
		
		if (request.getParameter("messageid") != null && !request.getParameter("messageid").trim().equals("")) { 
			pCDOMessageID = request.getParameter("messageid").trim();
			
			pReservedSaveTime = ezEmailService.getMailReservedTime(pCDOMessageID);
			
			//utc에서 timezone으로 시간변경
			pReservedSaveTime = commonUtil.getDateStringInUTC(pReservedSaveTime, loginInfo.getOffset(), false);
			
			Calendar cal = Calendar.getInstance();
			cal.add(Calendar.MINUTE, 30);
			Date currentTime = cal.getTime();

			SimpleDateFormat transFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");
			Date reservedSaveTime = transFormat.parse(pReservedSaveTime);

			//예약발송 시간 30분 전에는 수정 불가
			if (reservedSaveTime.before(currentTime)) { 
				model.addAttribute("pMessage", egovMessageSource.getMessage("ezEmail.t99000090", locale));
				logger.debug(egovMessageSource.getMessage("ezEmail.t99000090", locale));
				logger.debug("mailEdit ended.");
				return "ezEmail/mailMessage";
			}

			//eml파일 읽기
			FileInputStream fis = null;
			String realPath = commonUtil.getRealPath(request);
			String pDirPath = commonUtil.getUploadPath("upload_mail.RESERVED_MAIL_PATH", loginInfo.getTenantId());
			pDirPath = realPath + commonUtil.separator + pDirPath;
			File f = new File(pDirPath + commonUtil.separator + pCDOMessageID + ".eml");
			
			if (f.exists()) {
				
				IMAPAccess ia = null;
				try {
					fis = new FileInputStream(f);
					
					String domainName = ezCommonService.getTenantConfig("DomainName", loginInfo.getTenantId());
					String userEmail = loginInfo.getId() + "@" + domainName;
					
					SMTPAccess sa = SMTPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.SMTPPort"),
							userEmail, password);

					message = sa.readMimeMessage(fis);

					//임시보관함에 저장
					ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
							userEmail, password, egovMessageSource, locale);
					Folder folder = ia.getFolder(egovMessageSource.getMessage("ezEmail.t99000027", locale));
					
					if (folder.exists()) {
						folder.open(Folder.READ_WRITE);
						message.setFlag(Flags.Flag.SEEN, true);
						AppendUID[] uids = ((IMAPFolder)folder).appendUIDMessages(new Message[]{message});
		        		if (uids != null && uids[0] != null) {
		        			uid = uids[0].uid;
		        		} 	        		
		        		urlOwn = String.valueOf(uid);
		        		url = urlOwn;
						folder.close(true);
					}
				
				} catch (MessagingException e) {
					e.printStackTrace();
				} catch (IOException e) {
					logger.error("IOException has occurred");
					e.printStackTrace();
				} finally {
					if (ia != null) {
						ia.close();
					}
					if (fis != null) {
						fis.close();
					}
				}
				
			} else {
				model.addAttribute("pMessage", egovMessageSource.getMessage("ezEmail.t99000089", locale));
				logger.debug(egovMessageSource.getMessage("ezEmail.t99000089", locale));
				logger.debug("mailEdit ended.");
				return "ezEmail/mailMessage";
			}
			

		} else {
			model.addAttribute("pMessage", egovMessageSource.getMessage("ezEmail.t99000089", locale));
			logger.debug(egovMessageSource.getMessage("ezEmail.t99000089", locale));
			logger.debug("mailEdit ended.");
			return "ezEmail/mailMessage";
		}

		MailColorVO vo = ezEmailService.getMailColor(loginInfo.getTenantId());
		
		if (vo != null) {
			inMailColor = vo.getInmailColor();
			outMailColor = vo.getOutmailColor();
		} else {
			inMailColor = "#808080";
			outMailColor = "#0080ff";
		}
		
		userInfoApprovalG = config.getProperty("config.UserInfo_ApprovalG");
		
		//대용량 메일 관련 변수
		//set mailAttachLimit, bigSizeMailAttachLimit, totBigSizeMailAttachLimit, bigSizeMailAttachDelDay
		mailAttachLimit = config.getProperty("config.MailAttachLimit");
		bigSizeMailAttachLimit = config.getProperty("config.BigSizeMailAttachLimit");
		totBigSizeMailAttachLimit = config.getProperty("config.totBigSizeMailAttachLimit");
		int day = 20;
		if (config.getProperty("config.BigSizeMailAttachDelDay") != null && !config.getProperty("config.BigSizeMailAttachDelDay").trim().equals("")) {
			day = Integer.parseInt(config.getProperty("config.BigSizeMailAttachDelDay"));
		}
		bigSizeMailAttachDelDay = EgovDateUtil.addDay(EgovDateUtil.getToday("-"), day, "yyyy-MM-dd");
		
		userPrimary = loginInfo.getPrimary();
		userLang = loginInfo.getLang();
		userTimeset = loginInfo.getOffset();
		
		OrganUserVO userInfo = ezOrganAdminService.getUserInfo(loginInfo.getId(), userPrimary, loginInfo.getTenantId());
		displayNamePrintable = userInfo.getDisplayName();
		
		//set sendFrom
		if (request.getParameter("sendfrom") != null) {
			sendFrom = request.getParameter("sendfrom");
		}
		
		//set useMultiLangMail
		useMultiLangMail = "1";
		
		//set cmdOwn
		if (request.getParameter("cmd") != null) {
			cmdOwn = request.getParameter("cmd");
		}
		
		//set cmd
		if (request.getParameter("cmd") != null) {
			cmd = request.getParameter("cmd");
		}
		
		//set from
		from = "\""+userInfo.getDisplayName()+"\" <"+userInfo.getMail()+">";
		
		// retrieve the Drafts folder name
    	String draftsFolderName = egovMessageSource.getMessage("ezEmail.t99000027", locale);
    	
		if (message != null) {
			// in case of editing a message in Drafts folder.
			// retrieve the TO addresses from the message.
			Address[] addresses = message.getRecipients(Message.RecipientType.TO);
			String[] rawHeaders = message.getHeader("To");
			String rawHeader = rawHeaders != null ? rawHeaders[0] : ""; 
			to = ezEmailUtil.getStringListOfAddresses(addresses, ezEmailUtil.isPureAscii(rawHeader));
			
			// retrieve the CC addresses from the message.
			addresses = message.getRecipients(Message.RecipientType.CC);
			rawHeaders = message.getHeader("Cc");
			rawHeader = rawHeaders != null ? rawHeaders[0] : ""; 			
			cc = ezEmailUtil.getStringListOfAddresses(addresses, ezEmailUtil.isPureAscii(rawHeader));
			
			// retrieve the BCC addresses from the message.
			addresses = message.getRecipients(Message.RecipientType.BCC);
			rawHeaders = message.getHeader("Bcc");
			rawHeader = rawHeaders != null ? rawHeaders[0] : ""; 						
			bcc = ezEmailUtil.getStringListOfAddresses(addresses, ezEmailUtil.isPureAscii(rawHeader));
			
			// retrieve the subject from the message.
			subject = message.getSubject();
			subject = (subject != null) ? subject : "";
			
			// analyze the message and retrieve the attached file list.
			List<Map<String, String>> attachedFileList = new ArrayList<Map<String, String>>();
			List<String> bodyInfoList = ezEmailUtil.getBodyInfo(message, draftsFolderName, uid, -1, attachedFileList, false);					
			body = EgovStringUtil.getSpclStrCnvr2(bodyInfoList.get(0));
			
			if (attachedFileList.size() > 0) {
                StringBuilder attachXmlList = new StringBuilder("<ROOT><NODES>");	
                
				for (int i = 0; i < attachedFileList.size(); i++) {
					Map<String, String> fileInfo = attachedFileList.get(i);
					
	                attachXmlList.append("<NODE>");
	                //TODO : <PUPLOADSN>" + (i + 1) + "</PUPLOADSN> 으로 수정(인덱스로 파일 지울 때)
	                attachXmlList.append("<PUPLOADSN>" + fileInfo.get("filename") + "</PUPLOADSN>");
	                attachXmlList.append("<RESULTUPLOADA>true</RESULTUPLOADA>");
	                attachXmlList.append("<PFILENAME>" + fileInfo.get("filename") + "</PFILENAME>");
	                attachXmlList.append("<FILESIZE>" + fileInfo.get("size") + "</FILESIZE>");
	                attachXmlList.append("<FILELOCATION>" + uid + "</FILELOCATION>");
	                attachXmlList.append("<PBIGFILEUPLOAD>N</PBIGFILEUPLOAD>");
	                attachXmlList.append("</NODE>");
				}
				
                attachXmlList.append("</NODES></ROOT>");
                attachCK = attachXmlList.toString();
			}
			
			if (message.getHeader("X-Priority") != null) {
    			String tempImportance = message.getHeader("X-Priority")[0];
    			if (tempImportance.equals("1")) {
    				importance = "2";
    			} else if (tempImportance.equals("5")) {
    				importance = "0";
    			} else {
    				importance = "1";
    			}
    		}
			
			if (message.getHeader("X-NEW-DISPLAYNAME") != null) {
				showDisplay = message.getHeader("X-NEW-DISPLAYNAME")[0];
			}
		}
		
		int pBigAttachDownloadDaynum = 0;
        if (config.getProperty("config.BigSizeMailAttachDelDay") != null && !config.getProperty("config.BigSizeMailAttachDelDay").trim().equals("")) {
        	pBigAttachDownloadDay = config.getProperty("config.BigSizeMailAttachDelDay");
        	pBigAttachDownloadDaynum = Integer.parseInt(pBigAttachDownloadDay);
        }
        
        pBigAttachDownloadPeriod = EgovDateUtil.getToday("/") + " ~ " + EgovDateUtil.addDay(EgovDateUtil.getToday("/"), pBigAttachDownloadDaynum, "yyyy/MM/dd");
        
        senderInfo = userInfo.getCompany() + ", " + userInfo.getDescription() + ", " + userInfo.getTitle();
        
        pAttachWarning = egovMessageSource.getMessage("ezEmail.t99000104", locale) + mailAttachLimit + egovMessageSource.getMessage("ezEmail.t99000105", locale) 
    		+ totBigSizeMailAttachLimit + egovMessageSource.getMessage("ezEmail.t99000106", locale) + pBigAttachDownloadDay + egovMessageSource.getMessage("ezEmail.t99000107", locale);
        
        String browser = ClientUtil.getClientInfo(request, "browser");
        boolean isCrossBrowser = browser.equals("IE9") ? false : true;
        
		model.addAttribute("from", from);
		model.addAttribute("to", to);
		model.addAttribute("cc", cc);
		model.addAttribute("bcc", bcc);
		model.addAttribute("subject", subject);
		model.addAttribute("encodedSubject", EgovStringUtil.getSpclStrCnvr(subject));
		model.addAttribute("body", body);
		model.addAttribute("attachCK", attachCK);
		model.addAttribute("pCDOMessageID", pCDOMessageID);
		model.addAttribute("pReservedSaveTime", pReservedSaveTime);
		model.addAttribute("stateName", stateName);
		model.addAttribute("folderDate", folderDate);
		model.addAttribute("useEditor", useEditor);
		model.addAttribute("mailInnerDomain", mailInnerDomain);
		model.addAttribute("individualMailUser", individualMailUser);
		model.addAttribute("inMailColor", inMailColor);
		model.addAttribute("outMailColor", outMailColor);
		model.addAttribute("userPrimary", userPrimary);
		model.addAttribute("userLang", userLang);
		model.addAttribute("mailAttachLimit", mailAttachLimit);
		model.addAttribute("bigSizeMailAttachLimit", bigSizeMailAttachLimit);
		model.addAttribute("totBigSizeMailAttachLimit", totBigSizeMailAttachLimit);
		model.addAttribute("bigSizeMailAttachDelDay", bigSizeMailAttachDelDay);
		model.addAttribute("displayNamePrintable", displayNamePrintable);
		model.addAttribute("sendFrom", sendFrom);
		model.addAttribute("useMultiLangMail", useMultiLangMail);
		model.addAttribute("cmd", cmd);
		model.addAttribute("cmdOwn", cmdOwn);
		model.addAttribute("url", url);
		model.addAttribute("urlOwn", urlOwn);
		model.addAttribute("pBigAttachDownloadPeriod", pBigAttachDownloadPeriod);
		model.addAttribute("pAttachWarning", pAttachWarning);
		model.addAttribute("pBigAttachDownloadDay", pBigAttachDownloadDay);
		model.addAttribute("mailSignSel", mailSignSel);
		model.addAttribute("importance", importance);
		model.addAttribute("senderInfo", senderInfo);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("unread", unread);
		model.addAttribute("charsetCheck", charsetCheck);
		model.addAttribute("userInfoApprovalG", userInfoApprovalG);
		model.addAttribute("reSendFlag", reSendFlag);
		model.addAttribute("userTimeset", userTimeset);
		model.addAttribute("fileUploadType", fileUploadType);
		model.addAttribute("pSecurity", pSecurity);
		model.addAttribute("docHref", docHref);
		model.addAttribute("strSelectHtml", strSelectHtml);
		model.addAttribute("showDisplay", showDisplay);
		model.addAttribute("serverName", serverName);
		model.addAttribute("isCrossBrowser", isCrossBrowser);
		
        logger.debug("mailEdit ended.");
        
		return "ezEmail/mailEdit";
	}
	
	/**
	 * 예약발송메일 DB 체크 함수
	 */
	@RequestMapping(value="/ezEmail/reservedMailCheck.do")
	@ResponseBody
	public String reservedMailCheck(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, @RequestBody String bodyData) throws Exception{
		logger.debug("reservedMailCheck started.");
		logger.debug("bodyData=" + bodyData);
		
		String returnValue = "<DATA>MAIL-NOT-EXISTS</DATA>";
		Document xmlDoc = commonUtil.convertStringToDocument(bodyData);
		Element root = xmlDoc.getDocumentElement();
		String messageId  = "";
		Node tempNode = null;
		
		if (root.getElementsByTagName("MESSAGEID") != null) {
			tempNode = root.getElementsByTagName("MESSAGEID").item(0);
			if (tempNode != null) {
				messageId = tempNode.getTextContent();
			}
		}
		
		if (messageId != null && !messageId.equals("")) {
			String reservedTime = ezEmailService.getMailReservedTime(messageId);
			
			if (reservedTime != null) {
				returnValue = "<DATA>MAIL-EXISTS</DATA>";
			}
		}
		
		logger.debug("returnValue=" + returnValue);
		logger.debug("reservedMailCheck ended.");
		
		return returnValue;
	}
	
}
