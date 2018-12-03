package egovframework.ezEKP.ezEmail.web;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.security.PrivateKey;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Enumeration;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;
import java.util.UUID;

import javax.annotation.Resource;
import javax.mail.Address;
import javax.mail.Flags;
import javax.mail.Folder;
import javax.mail.Header;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeUtility;
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
import egovframework.let.utl.sim.service.EgovFileScrty;

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
	
	@Resource(name="crypto") 
    private EgovFileScrty egovFileScrty;
	
	/**
	 * 메일 예약발송 화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailReservation.do")
	public String mailReservation(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		logger.debug("mailReservation started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String draftUrl = "";
		String useEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		String noneActiveX = "YES";
		
		List<MailReservationVO> list = ezEmailService.getMailReserved(userInfo.getTenantId(), userInfo.getId());
		
		for (MailReservationVO vo : list) {
			vo.setSendDate(commonUtil.getDateStringInUTC(vo.getSendDate(), userInfo.getOffset(), false));
		}
		
		model.addAttribute("draftUrl", draftUrl);
		model.addAttribute("useEditor", useEditor);
		model.addAttribute("noneActiveX", noneActiveX);
		model.addAttribute("list", list);
		
		logger.debug("mailReservation ended.");
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
	public String mailEdit(
			@CookieValue("loginCookie") String loginCookie, 
			Locale locale, Model model, 
			HttpServletRequest request) throws Exception{
		
		logger.debug("mailEdit started.");
		
		String cmd = "";
		String url = "";
		String cmdOwn = "";
		String urlOwn = "";
		
		String bodyType = "0";
		String importance = "1";
		String isEach = "FALSE";
		String isSecureMail = "false";
		String securePassword = null;
		String secureReadCount = null;
		String secureReadDate = null;
		String replySendTime = "0";
		String replyReadTime = "1";
		String pReservedSaveTime = "";
		String pCDOMessageID = "";
		String mailSignSel = "0"; //예약발송 수정에서는 mailsign 수정불가
		String unread = "0"; //안쓰임
		
		String subject = "";
		String body = "";
		String from = "";
		String to = "";
		String cc = "";
		String bcc = "";
		String attachCK = "";
		long uid = 0;
		String showDisplay = "";
		
		String docHref = "";
		String reSendFlag = "N"; //?
		String fileUploadType = ""; //?
		String strSelectHtml = ""; //?
		
		
		// get user credentials
		LoginVO loginInfo = commonUtil.userInfo(loginCookie);
		OrganUserVO userInfo = ezOrganAdminService.getUserInfo(loginInfo.getId(), loginInfo.getPrimary(), loginInfo.getTenantId());
		String password  = commonUtil.getUserIdAndPassword(loginCookie).get(1);
		
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
				model.addAttribute("pMessage", egovMessageSource.getMessage("ezEmail.lhm07", locale));
				logger.debug(egovMessageSource.getMessage("ezEmail.lhm07", locale));
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
							userEmail, password, egovMessageSource, locale, ezEmailUtil);
					Folder folder = ia.getFolder(ezEmailUtil.getDraftsFolderId(locale));
					
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
				
			} else { //eml파일이 저장소에 없는 경우
				model.addAttribute("pMessage", egovMessageSource.getMessage("ezEmail.lhm06", locale));
				logger.debug(egovMessageSource.getMessage("ezEmail.lhm06", locale));
				logger.debug("mailEdit ended.");
				return "ezEmail/mailMessage";
			}
			

		} else { //messageId parameter가 비어있는 경우
			model.addAttribute("pMessage", egovMessageSource.getMessage("ezEmail.lhm06", locale));
			logger.debug(egovMessageSource.getMessage("ezEmail.lhm06", locale));
			logger.debug("mailEdit ended.");
			return "ezEmail/mailMessage";
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
		
        // set serverName
 		String serverName = loginInfo.getServerName();
 		String useMailLinkHostname = ezCommonService.getTenantConfig("useMailLinkHostname", loginInfo.getTenantId());
 		
 		if (useMailLinkHostname.equals("YES")) {
 			String mailLinkHostname = ezCommonService.getTenantConfig("mailLinkHostname", loginInfo.getTenantId());
 			
 			if (!mailLinkHostname.equals("")) {
 				serverName = mailLinkHostname;
 			}
 		}
 		
        logger.debug("displayNamePrintable=" + displayNamePrintable + ",serverName=" + serverName);
		
		String stateName = UUID.randomUUID().toString();
		logger.debug("stateName=" + stateName);
		
		String mailInnerDomain = ezCommonService.getTenantConfig("MailInnerDomain", loginInfo.getTenantId());
		String useEditor = ezCommonService.getTenantConfig("EDITOR", loginInfo.getTenantId());
		String useSecureMail = ezCommonService.getTenantConfig("USE_SECUREMAIL", loginInfo.getTenantId());
		String defaultFontAndSize = "style='font-size:13px;font-family:" + egovMessageSource.getMessage("main.t246", locale) + "'";
		
		//사용자 언어가 한국어이고 editorFontStyle값이 있을 경우 editorFontStyle값 적용
		if (loginInfo.getLang().equals("1")) {
			String editorFontStyle = ezCommonService.getTenantConfig("editorFontStyle", loginInfo.getTenantId());
			
			if (!editorFontStyle.equals("")) {
				String fontFamily = editorFontStyle.split("\\|")[0];
				String fontSize = editorFontStyle.split("\\|")[1];
				
				defaultFontAndSize = "style='font-size:" + fontSize + ";font-family:" + fontFamily + "'";
			}
		}
		// 쓰기창에서 수신인 자동완성 기능 사용 유무
		String useMailAddrAutoComplete = ezCommonService.getTenantConfig("useMailAddrAutoComplete", loginInfo.getTenantId());
				
		
		logger.debug("mailInnerDomain=" + mailInnerDomain + ",useEditor=" + useEditor + ",useSecureMail=" + useSecureMail + ",defaultFontAndSize" + defaultFontAndSize);
		
		String senderInfo = userInfo.getCompany() + ", " + userInfo.getDescription() + ", " + userInfo.getTitle();
		logger.debug("senderInfo=" + senderInfo);
		
		//메일 색상 관련 설정
		String inMailColor = "808080";
		String outMailColor = "0080ff";
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
        
        if (totBigSizeMailAttachLimit.equals("0")) {
        	pAttachWarning = egovMessageSource.getMessage("ezEmail.kms01", locale) + mailAttachLimit +egovMessageSource.getMessage("ezEmail.kms02", locale);
        }
        
        logger.debug("bigSizeMailAttachDelDate=" + bigSizeMailAttachDelDate + ",pBigAttachDownloadPeriod=" + pBigAttachDownloadPeriod
        		+ ",pAttachWarning=" + pAttachWarning);
        
        //TODO: setting
  		String useMultiLangMail = "1";
  		String pSecurity = "1";
  		String charsetCheck = "1";
  		String postType = "0";
  		logger.debug("useMultiLangMail=" + useMultiLangMail + ",pSecurity=" + pSecurity + ",charsetCheck=" + charsetCheck
  				+ ",postType=" + postType);
  		
		String individualMailUser = ezCommonService.getTenantConfig("INDIVIDUALMAILUSER", loginInfo.getTenantId());
		
		//set cmdOwn
		if (request.getParameter("cmd") != null) {
			cmdOwn = request.getParameter("cmd");
		}
		
		//set cmd
		if (request.getParameter("cmd") != null) {
			cmd = request.getParameter("cmd");
		}
		
		// retrieve the Drafts folder name
    	String draftsFolderName = ezEmailUtil.getDraftsFolderId(locale);
    	
		if (message != null) {
			if (message.getFrom() != null && message.getFrom()[0] != null) {
    			from = ((InternetAddress)message.getFrom()[0]).getAddress();
    		}
			
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
			List<String> bodyInfoList = ezEmailUtil.getBodyInfo(message, draftsFolderName, uid, -1, attachedFileList, false, false, locale, null, null);
			body = EgovStringUtil.getSpclStrCnvr2(bodyInfoList.get(0));
			
			if (attachedFileList.size() > 0) {
                StringBuilder attachXmlList = new StringBuilder("<ROOT><NODES>");	
                
                for (int i = 0; i < attachedFileList.size(); i++) {
					Map<String, String> fileInfo = attachedFileList.get(i);
					
	                attachXmlList.append("<NODE>");
	                //TODO : <PUPLOADSN>" + (i + 1) + "</PUPLOADSN> 으로 수정(인덱스로 파일 지울 때)
	                attachXmlList.append("<PUPLOADSN>" + commonUtil.cleanValue(fileInfo.get("filename")) + "</PUPLOADSN>");
	                attachXmlList.append("<RESULTUPLOADA>true</RESULTUPLOADA>");
	                attachXmlList.append("<PFILENAME>" + commonUtil.cleanValue(fileInfo.get("filename")) + "</PFILENAME>");
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
			
			Enumeration headers = message.getAllHeaders();
            while (headers.hasMoreElements()) {
              Header h = (Header) headers.nextElement();
              logger.debug("@@"+h.getName() + ": " + h.getValue());
            }
            
            //set isEachMail
        	if (message.getHeader("X-JMocha-Each-Mail") != null) {
        		isEach = message.getHeader("X-JMocha-Each-Mail")[0];
    		}  
			
        	//set isSecureMail
    		if (message.getHeader("X-JMocha-Secure-Mail") != null) {
    			isSecureMail = message.getHeader("X-JMocha-Secure-Mail")[0];
    			securePassword = message.getHeader("X-JMocha-Secure-Mail-Password")[0];
    			secureReadCount = message.getHeader("X-JMocha-Secure-Mail-ReadCount")[0];
    			secureReadDate = message.getHeader("X-JMocha-Secure-Mail-ReadDate")[0];
				
    			// 암호화되어있는 securePassword 복호화
    			String prm = egovFileScrty.getPrm();
            	String pre = egovFileScrty.getPre();
            	PrivateKey pk = EgovFileScrty.getPrivateKey(prm, pre);
            	securePassword = EgovFileScrty.decryptRsa(pk, securePassword);
    			
				logger.debug("securePassword=" + securePassword + ",secureReadCount=" + secureReadCount + ",secureReadDate=" + secureReadDate);
    		}
    		
        	//set bodyType
        	if (message.getHeader("Content-Type") != null) {
        		String tempBodyType = ezEmailUtil.getTextPart(message).get(1);
        		
        		if(tempBodyType.equals("text/plain")) {
        			bodyType = "1";
        		}
    		}
        	
        	if (message.getHeader("Return-Receipt-To") != null) {
        		replySendTime = "1";
    		} else {
    			replySendTime = "0";
    		}
        	if (message.getHeader("Disposition-Notification-To") != null) {
        		replyReadTime = "1";
    		} else {
    			replyReadTime = "0";
    		}
            
			if (message.getHeader("X-JMocha-EXT-SENDERNAME") != null) {
				showDisplay = message.getHeader("X-JMocha-EXT-SENDERNAME")[0];
			}
		}
		
		String useFromAddress = ezCommonService.getTenantConfig("Use_FromAddress", loginInfo.getTenantId());
		String fromAddressHtml = "";
		
		if (useFromAddress != null) {
			if (useFromAddress.equals("YES")) {
				List<String[]> fromAddressList = ezEmailService.getAliasAddress(loginInfo.getId(), loginInfo.getTenantId());
				
				if (fromAddressList.size() >= 2) {
					String companyDomainName = ezCommonService.getCompanyConfig(loginInfo.getTenantId(), loginInfo.getCompanyID(), "DomainName");
					
					// 회사별 이메일 도메인명이 설정되어 있으면 Account 이메일 주소를 목록에서 제외한다.								
					if (!companyDomainName.isEmpty()) {
						for (int i = 0; i < fromAddressList.size(); i++) {
							String[] item = fromAddressList.get(i);
							String type = item[1];
							
							if (type.equals("1")) {
								logger.debug("removing the account email address...");
								
								fromAddressList.remove(i);
								
								break;
							}
						}
					}
				}
				
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
		model.addAttribute("useEditor", useEditor);
		model.addAttribute("mailInnerDomain", mailInnerDomain);
		model.addAttribute("individualMailUser", individualMailUser);
		model.addAttribute("inMailColor", inMailColor);
		model.addAttribute("outMailColor", outMailColor);
		model.addAttribute("userPrimary", userPrimary);
		model.addAttribute("postType", postType);
		model.addAttribute("userLang", userLang);
		model.addAttribute("mailAttachLimit", mailAttachLimit);
		model.addAttribute("bigSizeMailAttachLimit", bigSizeMailAttachLimit);
		model.addAttribute("totBigSizeMailAttachLimit", totBigSizeMailAttachLimit);
		model.addAttribute("bigSizeMailAttachDelDate", bigSizeMailAttachDelDate);
		model.addAttribute("pBigAttachDownloadPeriod", pBigAttachDownloadPeriod);
		model.addAttribute("pAttachWarning", pAttachWarning);
		model.addAttribute("pBigAttachDownloadDay", pBigAttachDownloadDay);
		model.addAttribute("displayNamePrintable", displayNamePrintable);
		model.addAttribute("useMultiLangMail", useMultiLangMail);
		model.addAttribute("cmd", cmd);
		model.addAttribute("cmdOwn", cmdOwn);
		model.addAttribute("url", url);
		model.addAttribute("urlOwn", urlOwn);
		model.addAttribute("mailSignSel", mailSignSel);
		model.addAttribute("importance", importance);
		model.addAttribute("isEach", isEach);
		model.addAttribute("bodyType", bodyType);
		model.addAttribute("replySendTime", replySendTime);
		model.addAttribute("replyReadTime", replyReadTime);
		model.addAttribute("senderInfo", senderInfo);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("tenantId", loginInfo.getTenantId());
		model.addAttribute("unread", unread);
		model.addAttribute("charsetCheck", charsetCheck);
		model.addAttribute("reSendFlag", reSendFlag);
		model.addAttribute("userTimeset", userTimeset);
		model.addAttribute("fileUploadType", fileUploadType);
		model.addAttribute("pSecurity", pSecurity);
		model.addAttribute("docHref", docHref);
		model.addAttribute("strSelectHtml", strSelectHtml);
		model.addAttribute("showDisplay", showDisplay);
		model.addAttribute("serverName", serverName);
		model.addAttribute("isCrossBrowser", isCrossBrowser);
		model.addAttribute("useFromAddress", useFromAddress);
		model.addAttribute("useSecureMail", useSecureMail);
		model.addAttribute("isSecureMail", isSecureMail);
		model.addAttribute("securePassword", securePassword);
		model.addAttribute("secureMaxReadCount", secureReadCount);
		model.addAttribute("secureMaxReadDate", secureReadDate);
		model.addAttribute("fromAddressHtml", fromAddressHtml);
		model.addAttribute("defaultFontAndSize", defaultFontAndSize);
		model.addAttribute("useLetter", useLetter);
		model.addAttribute("draftsFolderName", draftsFolderName);
		model.addAttribute("useMailAddrAutoComplete", useMailAddrAutoComplete); // 20180531 조진호 추가
		
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
