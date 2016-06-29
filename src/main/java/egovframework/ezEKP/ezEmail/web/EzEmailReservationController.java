package egovframework.ezEKP.ezEmail.web;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.net.URLDecoder;
import java.text.DateFormat;
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
import javax.mail.Transport;
import javax.mail.internet.MimeMessage;
import javax.security.auth.Subject;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;

import com.sun.mail.imap.AppendUID;
import com.sun.mail.imap.IMAPFolder;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezEmail.logic.IMAPAccess;
import egovframework.ezEKP.ezEmail.logic.SMTPAccess;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezEmail.util.EzEmailUtil;
import egovframework.ezEKP.ezEmail.vo.MailColorVO;
import egovframework.ezEKP.ezEmail.vo.MailReservationVO;
import egovframework.ezEKP.ezEmail.vo.MailSignatureVO;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
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

	@Autowired
	private EzEmailUtil ezEmailUtil;

	/**
	 * 메일 예약발송 화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailReservation.do")
	public String mailReservation(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		//TODO: draftUrl, useEditor, useIE11Browser, noneActiveX setting
		String draftUrl = "";
		String useEditor = "";
		String useIE11Browser = "";
		String noneActiveX = "";

		String userId = commonUtil.getUserIdAndPassword(loginCookie).get(0);
		String domainName = config.getProperty("config.DomainName");
		List<MailReservationVO> list = ezEmailService.getMailReserved(userId + "@" + domainName);

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
		String messageId = request.getParameter("messageid") == null ? "" : request.getParameter("messageid");
		ezEmailService.deleteMailReserved(messageId);

		String realPath = config.getProperty("data_root");
		String pDirPath = config.getProperty("upload_mail.RESERVED_MAIL_PATH");
		pDirPath = realPath + pDirPath;
		File f = new File(pDirPath + commonUtil.separator + messageId + ".eml");

		if (f.exists()) {
			f.delete();
		}

		return "";
	}

	/**
	 * 예약발송메일 수정 화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailEdit.do")
	public String mailEdit(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
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
		String userId = userIdnPw.get(0);
		String password  = userIdnPw.get(1);
		
		stateName = UUID.randomUUID().toString();
		folderDate = EgovDateUtil.getToday("");
		useEditor = config.getProperty("config.EDITOR");
		mailInnerDomain = config.getProperty("config.MailInnerDomain");
		individualMailUser = EgovStringUtil.isEmpty(config.getProperty("config.INDIVIDUALMAILUSER").trim()) ?
				0 : Integer.parseInt(config.getProperty("config.INDIVIDUALMAILUSER").trim());
		
		//TODO: docHref값에 따른 jsp페이지의 placeholder 바꾸기
		docHref = request.getParameter("dochref") == null ? "" : request.getParameter("dochref").trim();
		MimeMessage message = null;
		
		if (request.getParameter("messageid") != null && !request.getParameter("messageid").trim().equals("")) { 
			pCDOMessageID = request.getParameter("messageid").trim();

			//messageId로 DB에 있는 정보 가져오기
			pReservedSaveTime = ezEmailService.getMailReservedTime(pCDOMessageID).getSendDate();

			Calendar cal = Calendar.getInstance();
			cal.add(Calendar.MINUTE, 30);
			Date currentTime = cal.getTime();

			SimpleDateFormat transFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			Date reservedSaveTime = transFormat.parse(pReservedSaveTime);

			//예약발송 시간 30분 전에는 수정 불가
			if (reservedSaveTime.before(currentTime)) { 
				model.addAttribute("pMessage", egovMessageSource.getMessage("ezEmail.t99000090", locale));
				return "ezEmail/mailMessage";
			}

			//eml파일 읽기
			FileInputStream fis = null;
			String realPath = config.getProperty("data_root");
			String pDirPath = config.getProperty("upload_mail.RESERVED_MAIL_PATH");
			pDirPath = realPath + commonUtil.separator + pDirPath;
			File f = new File(pDirPath + commonUtil.separator + pCDOMessageID + ".eml");
			
			if (f.exists()) {
				try {
					fis = new FileInputStream(f);
					
					SMTPAccess sa = SMTPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.SMTPPort"),
							userId + "@"+config.getProperty("config.DomainName"), password);

					message = sa.readMimeMessage(fis);

					//임시보관함에 저장
					IMAPAccess ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
							userId +"@"+config.getProperty("config.DomainName"), password, egovMessageSource, locale);
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
					ia.close();
					
				} catch (IOException e) {
					logger.error("IOException has occurred");
					e.printStackTrace();
				} finally {
					if (fis != null) {
						fis.close();
					}
				}
			} else {
				model.addAttribute("pMessage", egovMessageSource.getMessage("ezEmail.t99000089", locale));
				return "ezEmail/mailMessage";
			}
			

		} else {
			model.addAttribute("pMessage", egovMessageSource.getMessage("ezEmail.t99000089", locale));
			return "ezEmail/mailMessage";
		}

		//DB에서 importance color 가져오기
		MailColorVO vo = ezEmailService.getMailColor();
		if (vo != null) {
			inMailColor = vo.getInmailColor();
			outMailColor = vo.getOutmailColor();
		} else {
			inMailColor = "black";
			outMailColor = "black";
		}

		userPrimary = config.getProperty("config.primary");
		
		//TODO: userLang, userTimeset(offset)값 DB에서 가져와서 제대로 넣기
		userLang = "1";
		//userTimeset = userInfo.getOffset(); //"235|+09:00"
		
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
		
		//TODO:lang(두번째 파라미터) 수정
		OrganUserVO userInfo = ezOrganAdminService.getUserInfo(userId, "1");
		userInfo.setMail(userInfo.getCn()+"@"+config.getProperty("config.DomainName"));
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
			to = ezEmailUtil.getStringListOfAddresses(addresses);
			
			// retrieve the CC addresses from the message.
			addresses = message.getRecipients(Message.RecipientType.CC);
			cc = ezEmailUtil.getStringListOfAddresses(addresses);
			
			// retrieve the BCC addresses from the message.
			addresses = message.getRecipients(Message.RecipientType.BCC);
			bcc = ezEmailUtil.getStringListOfAddresses(addresses);
			
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
	                attachXmlList.append("<PUPLOADSN>" + (i + 1) + "</PUPLOADSN>");
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
        
        //TODO: message쪽으로 옮겨서 읽어오기.
		if (userLang.equals("1")) {
			pAttachWarning = "일반첨부파일은 총 " + mailAttachLimit + "MB까지 가능하며, 대용량첨부는 " + totBigSizeMailAttachLimit + "MB까지 가능(" + pBigAttachDownloadDay + "일후 자동삭제) ";
		} else if (userLang.equals("2")) {
			pAttachWarning = "Normal attachments and large attachments up to " + mailAttachLimit + "MB up to " + totBigSizeMailAttachLimit + "MB (after " + pBigAttachDownloadDay + " days automatically deleted) ";
		} else if (userLang.equals("3")) {
			pAttachWarning = "一般的な添付ファイルは合計" + mailAttachLimit + "MBまで可能で、大容量の添付ファイルは" + totBigSizeMailAttachLimit + "MBまで可能（" + pBigAttachDownloadDay + "日後に自動削除）";
		} else if (userLang.equals("4")) {
			pAttachWarning = "普通附件和大型附件" + mailAttachLimit + "MB高达" + totBigSizeMailAttachLimit + "MB（" + pBigAttachDownloadDay + " 天之后自动删除）";
		}
		
		model.addAttribute("from", from);
		model.addAttribute("to", to);
		model.addAttribute("cc", cc);
		model.addAttribute("bcc", bcc);
		model.addAttribute("subject", subject);
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
		
		return "ezEmail/mailEdit";
	}
	
	/**
	 * 예약발송메일 DB 체크 함수
	 */
	@RequestMapping(value="/ezEmail/reservedMailCheck.do")
	@ResponseBody
	public String reservedMailCheck(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		Document xmlDoc = commonUtil.convertRequestToDocument(request);
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
			MailReservationVO vo = ezEmailService.checkReservedMail(messageId);
			if (vo.getSubject() != null) {
				return "<DATA>MAIL-EXISTS</DATA>";
			}
		}
		
		return "<DATA>MAIL-NOT-EXISTS</DATA>";
	}
	
}
