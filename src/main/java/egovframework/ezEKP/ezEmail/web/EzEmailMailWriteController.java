package egovframework.ezEKP.ezEmail.web;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.UnsupportedEncodingException;
import java.net.URL;
import java.net.URLDecoder;
import java.nio.file.Files;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Enumeration;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;
import java.util.UUID;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.activation.DataHandler;
import javax.activation.FileDataSource;
import javax.annotation.Resource;
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
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import javax.mail.internet.MimePart;
import javax.mail.internet.MimeUtility;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.codec.binary.Base64;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
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
import egovframework.ezEKP.ezEmail.logic.IMAPAccess;
import egovframework.ezEKP.ezEmail.logic.SMTPAccess;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezEmail.util.EzEmailUtil;
import egovframework.ezEKP.ezEmail.vo.MailColorVO;
import egovframework.ezEKP.ezEmail.vo.MailSignatureVO;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;
import egovframework.let.utl.fcc.service.EgovStringUtil;

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
public class EzEmailMailWriteController extends EgovFileMngUtil{

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
	private EzEmailUtil ezEmailUtil;
	
	/**
	 * 메일 쓰기화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailWrite.do")
	public String mailWrite(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		String to = "";
		String cc = "";
		String bcc = "";
		String from = "";
		String body = "";
		String subject = "";
		String importance = "1";
		String postType = "0";
		String url = "";
		String attach = "";
		String cmd = "";
		String unread = "";
		String boardID = "";
		String itemID = "";
		String docHref = "";
		String docID = "";
		String docImagCnt = "";
		String docTarget = "";
		String sendFrom = "";
		String retransType = "";
		String useMultiLangMail = "";
		String displayNamePrintable = "";
		String charsetCheck = "1";
		String userInfoApprovalG = "";
		String userLang = "1";
		String userPrimary = "1";
		String reSendFlag = "N";
		String mailAttachLimit = "20";
		String bigSizeMailAttachLimit = "20";
		String totBigSizeMailAttachLimit = "20";
		String bigSizeMailAttachDelDay = "20";
		String userTimeset = "";
		String cmdOwn = "";
		String urlOwn = "";
		String mailSign1 = "";
		String mailSign2 = "";
		String mailSign3 = "";
		String mailSignSel = "";
		String bodyValue = "";
		String fileUploadType = "";
		String folderPath = "";
		String tempBody = "";
		String newWindowId = "";
		int individualMailUser = 0;
		String pSecurity = "1";
		String folderDate = "";
		String stateName = null;
		String pBigAttachDownloadDay = "";
		String pBigAttachDownloadPeriod = "";
		String pAutoSaveTime = "";
		String pAttachWarning = "";
		String mailSendObject = "";
		String mailInnerDomain = "";
		String inMailColor = "";
		String outMailColor = "";
		String useEditor = "";
		String serverName = config.getProperty("config.ServerName") != null ? config.getProperty("config.ServerName") : "";
		
		// get user credentials
		List<String> userIdnPw = commonUtil.getUserIdAndPassword(loginCookie);
		String userId = userIdnPw.get(0);
		String password  = userIdnPw.get(1);
				
		// retrieve user info from db.
		OrganUserVO userInfo = ezOrganAdminService.getUserInfo(userId, "1"); //추후 lang(두번째 파라미터) 수정
		userInfo.setMail(userInfo.getCn()+"@"+config.getProperty("config.DomainName"));
		
		useEditor = config.getProperty("config.EDITOR");

		//hostURL = request.getRequestURL().substring(0, request.getRequestURI().length()) + "/ezEmail/"; - 지금은 필요없는데 나중에 필요할지도?
		folderDate = EgovDateUtil.getToday("");
		stateName = UUID.randomUUID().toString();

		if (config.getProperty("config.MailInnerDomain") != null) {
			mailInnerDomain = config.getProperty("config.MailInnerDomain").trim();
		}
		
		if (config.getProperty("config.INDIVIDUALMAILUSER") != null && !config.getProperty("config.INDIVIDUALMAILUSER").trim().equals("")) {
			individualMailUser = Integer.parseInt(config.getProperty("config.INDIVIDUALMAILUSER"));
		}

		String tempStr = "";
		if (request.getParameter("cmd") != null) {
			tempStr = request.getParameter("cmd").toUpperCase().trim();
		} else {
			tempStr = "NEW";
		}

		if (!(tempStr.equals("") || tempStr.equals("REPLY") || tempStr.equals("REPLYALL") || tempStr.equals("FORWARD") || tempStr.equals("READ") 
				|| tempStr.equals("EDIT") || tempStr.equals("NEW") || tempStr.equals("BOARD") || tempStr.equals("COMMUNITY") || tempStr.equals("DOCSEND")
				|| tempStr.equals("DOCSENDDOC") || tempStr.equals("ACCESSNO") || tempStr.equals("REPORT") || tempStr.equals("RESEND"))) {
			return "정상적인 값을 전달 받지 못했습니다.";
		}

		if (request.getParameter("msgto") != null) {
			tempStr = request.getParameter("msgto").toUpperCase().trim().replaceAll("&lt;", "<").replaceAll("&gt;", ">").replaceAll("&quot;", "\"");
		} else {
			tempStr = "";
		}

		if (tempStr.indexOf("<") >= 0 && tempStr.indexOf(">") >= 0 && tempStr.indexOf("SCRIPT") >= 0) {
			return "정상적인 값을 전달 받지 못했습니다.";
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
		userLang = "1"; // 추후 수정(DB에서 가져와야함.)
		//userTimeset = userInfo.getOffset();
		userInfoApprovalG = config.getProperty("config.UserInfo_ApprovalG");
		mailAttachLimit = config.getProperty("config.MailAttachLimit");
		bigSizeMailAttachLimit = config.getProperty("config.BigSizeMailAttachLimit");
		totBigSizeMailAttachLimit = config.getProperty("config.totBigSizeMailAttachLimit");
		int day = 20;
		if (config.getProperty("config.BigSizeMailAttachDelDay") != null && !config.getProperty("config.BigSizeMailAttachDelDay").trim().equals("")) {
			day = Integer.parseInt(config.getProperty("config.BigSizeMailAttachDelDay"));
		}
		bigSizeMailAttachDelDay = EgovDateUtil.addDay(EgovDateUtil.getToday("-"), day, "yyyy-MM-dd");

		displayNamePrintable = userInfo.getDisplayName();

		if (request.getParameter("sendfrom") != null) {
			sendFrom = request.getParameter("sendfrom");
		}
		useMultiLangMail = "1";
		if (request.getParameter("cmd") != null) {
			cmdOwn = request.getParameter("cmd");
		}
		if (request.getParameter("url") != null) {
			urlOwn = URLDecoder.decode(request.getParameter("url").replaceAll(" ", "+"),"UTF-8"); // url decode 해야하나?
		}
		if (request.getParameter("cmd") != null) {
			cmd = request.getParameter("cmd");
		}
		
		from = "\""+userInfo.getDisplayName()+"\" <"+userInfo.getMail()+">";

//		OracleCommand comd = new OracleCommand("EZSP_GETMAILGENERAL");
//		comd.CommandType = CommandType.StoredProcedure;
//		comd.Parameters.Add("v_PUSERID", OracleType.VarChar, 20).Value = userinfo.UserID;
//		comd.Parameters.Add("cv_1", OracleType.Cursor).Direction = ParameterDirection.Output;
//		string infoXML = GetQueryResultSP(ref comd, false);
//		comd.Dispose();
//		comd = null;
//
//		XmlDocument xmlDoc = new XmlDocument();
//		xmlDoc = GetXmlReaderString(infoXML);
//		if (xmlDoc.InnerText == "")
		pAutoSaveTime = "0";
//		else
//			pAutoSaveTime = xmlDoc.SelectSingleNode("DATA/KEEPDELETELENGTH").InnerText.Trim();

//		string _PmailSenderNM = xmlDoc.SelectNodes("DATA/MAILSENDERNM").Count > 0 ?
//				string.IsNullOrEmpty(xmlDoc.SelectSingleNode("DATA/MAILSENDERNM").InnerText) ?
//						userinfo.DisplayName2 : xmlDoc.SelectSingleNode("DATA/MAILSENDERNM").InnerText : userinfo.DisplayName2;
//		string[] DivStrstr = new string[] { "|!-@-!|" };
//		string[] SenderList = _PmailSenderNM.Split(DivStrstr, StringSplitOptions.RemoveEmptyEntries);
		mailSendObject += "<option value='NONE'>" + egovMessageSource.getMessage("ezEmail.t99000032", locale) + "</option>";
//		foreach (string pSenderNM in SenderList)
//		{
//			mailSendObject += "<option value='" + pSenderNM + "'>" + pSenderNM + "</option>";
//		}
		
		String _cmd = "";
		if (request.getParameter("cmd") != null) {
			_cmd = request.getParameter("cmd");
		}
		String msgto = "";
		if (request.getParameter("msgto") != null) {
			msgto = request.getParameter("msgto").toUpperCase().trim().replaceAll("&lt;", "<").replaceAll("&gt;", ">").replaceAll("&quot;", "\"");
		}
        String _attach = "";
        if (request.getParameter("attach") != null) {
        	_attach = request.getParameter("attach");
		}
        String includeContent = "";
        if (request.getParameter("include") != null) {
        	includeContent = request.getParameter("include");
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
        
        if (_url.equals("") && _cmd.equals("NEW")) {
        	to = msgto;
            String resultXML = "";
            
            MailSignatureVO mailSignatureVO = ezEmailService.getMailSignature(userId, "A");
            
            if (mailSignatureVO != null) {
            	mailSign1 = mailSignatureVO.getContent1();
                mailSign2 = mailSignatureVO.getContent2();
                mailSign3 = mailSignatureVO.getContent3();
                mailSignSel = mailSignatureVO.getUseFlag().trim();
                
                mailSign1 = "<DIV style='font-size:12px;'><br /><br /><DIV id='MailSign'> " + mailSign1 + "<br /></DIV></DIV>";
                mailSign2 = "<DIV style='font-size:12px;'><br /><br /><DIV id='MailSign'> " + mailSign2 + "<br /></DIV></DIV>";
                mailSign3 = "<DIV style='font-size:12px;'><br /><br /><DIV id='MailSign'> " + mailSign3 + "<br /></DIV></DIV>";
                
                switch (mailSignSel) {
                    case "1": resultXML = mailSign1; break;
                    case "2": resultXML = mailSign2; break;
                    case "3": resultXML = mailSign3; break;
                    default: resultXML = ""; mailSignSel = "0"; break;
                }
                
            } else {
                mailSignSel = "0";
                resultXML = "";
            }
            
            body = EgovStringUtil.getSpclStrCnvr("<DIV style='font-size:12px;'><br><br><DIV id='MailSign'>" + resultXML + "</div><br></DIV>");
        } 
        // when _url is passed in from the client
        else if (!_url.equals("")) {
        	mailSignSel = "0";
        	
    		long uid = 0;
			int index = _url.lastIndexOf("/");			
			
			// separate the passed-in url into a folder path and a message uid
			if (index != -1) {
				folderPath = _url.substring(0, index);
				url = _url.substring(index + 1);
				uid = Long.parseLong(url);
			}
			logger.debug("folderPath=" + folderPath + ",url=" + url);
        	
    		IMAPAccess ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
    				userId+"@"+config.getProperty("config.DomainName"), password, egovMessageSource, locale);
			
    		Folder orgFolder = ia.getFolder(folderPath);
    		orgFolder.open(Folder.READ_ONLY);       
    		
			// retrieve the Drafts folder name
        	String draftsFolderName = egovMessageSource.getMessage("ezEmail.t99000027", locale);
    		
        	// retrieve the Sent folder name
        	String sentFolderName = egovMessageSource.getMessage("ezEmail.t99000026", locale);
        	
    		// retrieve the specified message.
			Message orgMessage = ((IMAPFolder)orgFolder).getMessageByUID(uid);
			
			if (orgMessage != null) {				        	
	        	// in case of editing a message in Drafts folder.
	        	if (folderPath.equals(draftsFolderName) && _cmd.equals("EDIT")) {         						  
					// retrieve the TO addresses from the message.
					Address[] addresses = orgMessage.getRecipients(Message.RecipientType.TO);
					to = ezEmailUtil.getStringListOfAddresses(addresses);
					
					// retrieve the CC addresses from the message.
					addresses = orgMessage.getRecipients(Message.RecipientType.CC);
					cc = ezEmailUtil.getStringListOfAddresses(addresses);
					
					// retrieve the BCC addresses from the message.
					addresses = orgMessage.getRecipients(Message.RecipientType.BCC);
					bcc = ezEmailUtil.getStringListOfAddresses(addresses);
					
					// retrieve the subject from the message.
					subject = orgMessage.getSubject();
					subject = (subject != null) ? subject : "";
					
					// analyze the message and retrieve the attached file list.
					List<Map<String, String>> attachedFileList = new ArrayList<Map<String, String>>();
					List<String> bodyInfoList = ezEmailUtil.getBodyInfo(orgMessage, folderPath, uid, -1, attachedFileList);					
					tempBody = bodyInfoList.get(0);
					
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
		                attach = attachXmlList.toString();	
					}
					
					MailSignatureVO mailSignatureVO = ezEmailService.getMailSignature(userId, "A");
					if (mailSignatureVO != null) {
	                	mailSign1 = mailSignatureVO.getContent1();
	                    mailSign2 = mailSignatureVO.getContent2();
	                    mailSign3 = mailSignatureVO.getContent3();
	                    mailSignSel = mailSignatureVO.getUseFlag().trim();
	                    
	                } else {
	                    mailSignSel = "0";
	                }
					
	        	}
	        	// in case of resending
	        	else if (folderPath.equals(sentFolderName) && _cmd.equals("RESEND") && !msgto.equals("")) {
	        		//임시보관함에 메시지 임시저장
	        		SMTPAccess sa = SMTPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.SMTPPort"),
	        				userId+"@"+config.getProperty("config.DomainName"), password);
	        		MimeMessage resendMessage = sa.createMimeMessage();
	        		
	        		resendMessage.setFlag(Flags.Flag.SEEN, true);
	        		
	        		if (orgMessage.isMimeType("multipart/related")) {
		        		MimeMultipart relatedPart = new MimeMultipart("related");
		        		
		        		if (ezEmailUtil.copyInlineParts(orgMessage, relatedPart)) {
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
	        			System.out.println(address);
	        			if (((InternetAddress)address).getAddress().equalsIgnoreCase(msgto)) {
							to = ezEmailUtil.getStringListOfAddresses(new Address[]{address});
							break;
	        			}
	        		}
	        		
	        		subject = orgMessage.getSubject();
					subject = (subject != null) ? subject : "";
	        		
					List<Map<String, String>> attachedFileList = new ArrayList<Map<String, String>>();		            
					List<String> bodyInfoList = ezEmailUtil.getBodyInfo(orgMessage, folderPath, uid, -1, attachedFileList);					
					bodyValue = bodyInfoList.get(0);
	        		
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
		                attach = attachXmlList.toString();				                
					}
	        		
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
	        		
	                unread = orgMessage.isSet(Flags.Flag.SEEN) ? "1" : "0";
	                
	                //TODO: Sensitivity?
	                //this._posttype = ((int)orgmesg.Sensitivity).ToString();
	        		
	                //TODO: 서명

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
			        		
			        		if (ezEmailUtil.copyInlineParts(orgMessage, relatedPart)) {
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
		        		
		        		if (ezEmailUtil.copyInlineParts(orgMessage, relatedPart)) {
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
						to = ezEmailUtil.getStringListOfAddresses(addresses);

						// retrieve the CC addresses from the reply message.
						addresses = replyMessage.getRecipients(Message.RecipientType.CC);
						cc = ezEmailUtil.getStringListOfAddresses(addresses);
						
						// retrieve the BCC addresses from the reply message.
						addresses = replyMessage.getRecipients(Message.RecipientType.BCC);
						bcc = ezEmailUtil.getStringListOfAddresses(addresses);
	        		}
					
					// retrieve the subject from the message.
					subject = orgMessage.getSubject();
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
					String orgTo = ezEmailUtil.getStringListOfAddresses(addresses);
					
					// retrieve the CC addresses from the original message.
					addresses = orgMessage.getRecipients(Message.RecipientType.CC);
					String orgCc = ezEmailUtil.getStringListOfAddresses(addresses);
					
		            StringBuilder sb = new StringBuilder();
		            sb.append("<hr tabindex=\"-1\">");
		            sb.append(String.format("<B>%s : </B> %s<BR>", egovMessageSource.getMessage("ezEmail.t703", locale), EgovStringUtil.getSpclStrCnvr(ezEmailUtil.getFullFromAddressOfMessage(orgMessage))));
		            
		            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss ( Z )");
		            sb.append(String.format("<B>%s : </B> %s<BR>", egovMessageSource.getMessage("ezEmail.t704", locale), sdf.format(orgMessage.getReceivedDate())));
		            sb.append(String.format("<B>%s : </B> %s<BR>", egovMessageSource.getMessage("ezEmail.t705", locale), EgovStringUtil.getSpclStrCnvr(orgTo)));
		            sb.append(String.format("<B>%s : </B> %s<BR>", egovMessageSource.getMessage("ezEmail.t706", locale), EgovStringUtil.getSpclStrCnvr(orgCc)));
		            sb.append(String.format("<B>%s : </B> %s<BR><BR>", egovMessageSource.getMessage("ezEmail.t707", locale), EgovStringUtil.getSpclStrCnvr(orgMessage.getSubject())));
					
					// analyze the message and retrieve the attached file list.
					List<Map<String, String>> attachedFileList = new ArrayList<Map<String, String>>();		            
					List<String> bodyInfoList = ezEmailUtil.getBodyInfo(orgMessage, folderPath, uid, -1, attachedFileList);					
					String tmphtmlbody = bodyInfoList.get(0);
		            
		            bodyValue = sb.toString() + tmphtmlbody;
	    			
		            if (_cmd.equals("FORWARD")) {
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
			                attach = attachXmlList.toString();				                
						}											            	
		            }
		            
	        		Folder draftsFolder = ia.getFolder(draftsFolderName);
	        		draftsFolder.open(Folder.READ_WRITE);       
	        		
	        		long draftUID = 0;
	        		// TODO: 에러 발생 시 처리
	        		AppendUID[] uids = ((IMAPFolder)draftsFolder).appendUIDMessages(new Message[]{replyMessage});
	        		if (uids != null && uids[0] != null) {
	        			draftUID = uids[0].uid;
	        		} 	        		
	        		url = String.valueOf(draftUID);
	        		
	        		logger.debug("draftUID=" + draftUID);
	        		
	        		draftsFolder.close(true);
	                
	                MailSignatureVO mailSignatureVO = ezEmailService.getMailSignature(userId, "A");
	                
	                if (mailSignatureVO != null) {
	                	mailSign1 = mailSignatureVO.getContent1();
	                    mailSign2 = mailSignatureVO.getContent2();
	                    mailSign3 = mailSignatureVO.getContent3();
	                    mailSignSel = mailSignatureVO.getUseFlag().trim();
	                    
	                    mailSign1 = "<DIV style='font-size:12px;'><br /><br /><DIV id='MailSign'> " + mailSign1 + "<br /></DIV></DIV>";
	                    mailSign2 = "<DIV style='font-size:12px;'><br /><br /><DIV id='MailSign'> " + mailSign2 + "<br /></DIV></DIV>";
	                    mailSign3 = "<DIV style='font-size:12px;'><br /><br /><DIV id='MailSign'> " + mailSign3 + "<br /></DIV></DIV>";
	                    
	                } else {
	                    mailSignSel = "0";
	                }
	                
	                if (bodyValue.contains("id=\"MailSignSent\"") || bodyValue.contains("id=MailSignSent")) {
	                	bodyValue = bodyValue.replaceAll("MailSignSent", "MailSignSent___send");
	                	bodyValue = bodyValue.replaceAll("kaoni_sign1", "kaoni_sign1___send");
	                	bodyValue = bodyValue.replaceAll("kaoni_sign2", "kaoni_sign2___send");
	                	bodyValue = bodyValue.replaceAll("kaoni_sign3", "kaoni_sign3___send");
	                }
	                bodyValue = bodyValue.replaceAll("ORGMAIL_CONTENT", "ORGMAIL_CONTENT___send");
	                bodyValue = bodyValue.replaceAll("DIV id='MailSign'", "DIV ");
	                
	                bodyValue = bodyValue.replaceAll("id=msgbody", "");

	                if (cmdOwn.equals("REPLY") || cmdOwn.equals("REPLYALL") || cmdOwn.equals("FORWARD")) {
	                	bodyValue = bodyValue.replaceAll("class=&quot;FIELD&quot;", "");
	                	bodyValue = bodyValue.replaceAll("class=FIELD", "");
	                	bodyValue = "<body free>" + bodyValue + "</body>";
	                }
	        	}
			}
        	        	
			orgFolder.close(true);			
			ia.close();        	
        }
        
//        else if (_url.equals("") && (_cmd.equals("board") || _cmd.equals("Community")))
//        {
//            mailMessageBoard();
//        }
//        else if (_url.equals("") && _cmd.equals("docsend"))
//        {
//            mailMessageDoc();
//        }
//        else if (_url.equals("") && _cmd.equals("AccessNO"))
//        {
//            mailMessageNone();
//        }
//        else if (_url.equals("") && _cmd.equals("report"))
//        {
//            mailMessageReport();
//        }
//        else if (!_url.equals(""))
//        {
//            ExchangeService esb = apiesb.getexchangeservice(userinfo.UserID);
//            ExtendedPropertyDefinition pagehtml = new ExtendedPropertyDefinition(0x1013, MapiPropertyType.Binary);
//            ExtendedPropertyDefinition codepagehtml = new ExtendedPropertyDefinition(0x3FDE, MapiPropertyType.Integer);
//            PropertySet properts = new PropertySet(BasePropertySet.FirstClassProperties, pagehtml, codepagehtml);
//            EmailMessage orgmesg = EmailMessage.Bind(esb, new ItemId(url), properts);
//            if (orgmesg.IsDraft)
//            {
//                //임시보관함에 있는 메일일경우 처리
//                bool isDraft = false;
//                Folder folderid = Folder.Bind(esb, WellKnownFolderName.Drafts);
//                if (orgmesg.ParentFolderId.UniqueId == folderid.Id.UniqueId)
//                {
//                    folderpath = "Draft";
//                    isDraft = true;
//                }
//                else
//                {
//                    Folder draft = Folder.Bind(esb, WellKnownFolderName.Drafts);
//                    if (draft.Id.UniqueId == orgmesg.ParentFolderId.UniqueId)
//                    {
//                        folderpath = "Draft";
//                        isDraft = true;
//                    }
//                    if (!isDraft)
//                    {
//                        FindFoldersResults findfolders = esb.FindFolders(WellKnownFolderName.Drafts, new FolderView(100));
//                        foreach (Folder folder in findfolders)
//                        {
//                            if (folder.Id.UniqueId == orgmesg.ParentFolderId.UniqueId)
//                            {
//                                folderpath = "Draft";
//                                isDraft = true;
//                                break;
//                            }
//                        }
//                    }
//                }
//                if (!isDraft)
//                {
//                    MailMessage_Send(_cmd, _url, _attach, esb, orgmesg);
//                    return;
//                }
//            }
//            if ((_cmd == "EDIT" || _cmd == "RESEND") && msgto != "")
//            {
//                resendMail(_cmd, _url, _attach, msgto, esb, orgmesg); return;
//            }
//            if (_url != "" && _cmd == "EDIT")
//            {
//                MailMessage_Edit(_cmd, _url, _attach, esb, orgmesg); return;
//            }
//            if (_url != "")
//            {
//                MailMessage_Send(_cmd, _url, _attach, esb, orgmesg); return;
//            }
//        }
		
        int pBigAttachDownloadDaynum = 0;
        if (config.getProperty("config.BigSizeMailAttachDelDay") != null && !config.getProperty("config.BigSizeMailAttachDelDay").trim().equals("")) {
        	pBigAttachDownloadDay = config.getProperty("config.BigSizeMailAttachDelDay");
        	pBigAttachDownloadDaynum = Integer.parseInt(pBigAttachDownloadDay);
        }
        
        pBigAttachDownloadPeriod = EgovDateUtil.getToday("/") + " ~ " + EgovDateUtil.addDay(EgovDateUtil.getToday("/"), pBigAttachDownloadDaynum, "yyyy/MM/dd");
        
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
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("to", to);
		model.addAttribute("cc", cc);
		model.addAttribute("bcc", bcc);
		model.addAttribute("from", from);
		model.addAttribute("body", body);
		model.addAttribute("subject", subject);
		model.addAttribute("encodedSubject", EgovStringUtil.getSpclStrCnvr(subject));
		model.addAttribute("importance", importance);
		model.addAttribute("postType", postType);
		model.addAttribute("url", url);
		model.addAttribute("attach", attach);
		model.addAttribute("cmd", cmd);
		model.addAttribute("unread", unread);
		model.addAttribute("boardID", boardID);
		model.addAttribute("itemID", itemID);
		model.addAttribute("docHref", docHref);
		model.addAttribute("docID", docID);
		model.addAttribute("docImagCnt", docImagCnt);
		model.addAttribute("docTarget", docTarget);
		model.addAttribute("sendFrom", sendFrom);
		model.addAttribute("retransType", retransType);
		model.addAttribute("useMultiLangMail", useMultiLangMail);
		model.addAttribute("displayNamePrintable", displayNamePrintable);
		model.addAttribute("charsetCheck", charsetCheck);
		model.addAttribute("userInfoApprovalG", userInfoApprovalG);
		model.addAttribute("userLang", userLang);
		model.addAttribute("userPrimary", userPrimary);
		model.addAttribute("reSendFlag", reSendFlag);
		model.addAttribute("mailAttachLimit", mailAttachLimit);
		model.addAttribute("bigSizeMailAttachLimit", bigSizeMailAttachLimit);
		model.addAttribute("totBigSizeMailAttachLimit", totBigSizeMailAttachLimit);
		model.addAttribute("bigSizeMailAttachDelDay", bigSizeMailAttachDelDay);
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
		model.addAttribute("folderDate", folderDate);
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
		
		return "ezEmail/mailWrite";
	}

	/**
	 * 메일 CK에디터 화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailCKEditor.do")
	public String mailCKEditor(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		model.addAttribute("userInfo", userInfo);
		return "ezEmail/mailCKEditor";
	}

	/**
	 * 메일 파일첨부 화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/dragAndDrop.do")
	public String dragAndDropIframe(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		model.addAttribute("userInfo", userInfo);
		return "ezEmail/mailDragAndDrop";
	}

	/**
	 * 메일 DragAndDrop 첨부파일 업로드 실행 함수
	 */
	@RequestMapping(value="/ezEmail/mailInterUploadXCK.do", produces = "text/html; charset=utf-8")
	@ResponseBody
	public String mailInterUploadXCK(MultipartHttpServletRequest request) throws Exception{
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
		String realPath = request.getServletContext().getRealPath("");
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
		
		if (request.getParameter("isbigyn") != null) {
			isBigYN = request.getParameter("isbigyn");
		}
		
		String useExtension = "";
		if (config.getProperty("config.USE_FileExtension") != null) {
			useExtension = config.getProperty("config.USE_FileExtension");
		}
		
		if (multiFile == null) {
			return "NOFILE";
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
				sFileTitle[i] = pFileName[i].substring(0, pFileName[i].lastIndexOf("."));
				sExt[i] = pFileName[i].substring(pFileName[i].lastIndexOf(".") + 1);
				if (multiFile.get(i).getSize() == 0) {
					isEmpty = true;
				}
			}
			if (isEmpty) {
				return "OVERFLOW";
			}
		}

		for (int i=0; i<cnt; i++) {
			sGUID[i] = UUID.randomUUID().toString() + "." + sExt[i];
		}

		if (request.getParameter("bigmaxsize") != null) {
			bigMaxSize = Long.parseLong(request.getParameter("bigmaxsize"));
		}
		if (request.getParameter("changesize") != null) {
			changeSize = Long.parseLong(request.getParameter("changesize"));
		}

		strXML = "<ROOT><NODES>";
		String pDirPath = config.getProperty("upload_mail.ROOT");
		pDirPath = realPath + pDirPath;
		
		// check the upload mail root folder and create it if it doesn't exist.
		File uploadMailRootFolder = new File(pDirPath);
		if (!uploadMailRootFolder.exists()) {
			logger.debug("creating uploadMailRootFolder=" + uploadMailRootFolder);
			uploadMailRootFolder.mkdir();
		}
		
		for (int i=0; i<cnt; i++) {
			fileSize[i] = multiFile.get(i).getSize();
			if (fileSize[i] > changeSize || isBigYN.equals("Y")) {
                String pDate = EgovDateUtil.getToday("");
                folderDate = pDate;
                pDirTempPath = pDirPath + commonUtil.separator + pDate;
                File file = new File(pDirTempPath);
                if (!file.exists()) {
                	file.mkdir();
                }
                pBigFileUpload = "Y";
                
                String base64OrgFileName = Base64.encodeBase64String(pFileName[i].getBytes());
                FileOutputStream fos = null;
                try {
                	File f = new File(pDirTempPath + commonUtil.separator + sGUID[i] + "__.txt");
                	fos = new FileOutputStream(f);
                    fos.write(base64OrgFileName.getBytes());
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
				f.mkdir();
            }
			
			if (fileSize[i] > bigMaxSize) {
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
                if (pBigFileUpload == "Y") {
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
			f.mkdir();
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
        	
        	return xmlList;
        	
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
            
            return xmlList;
        }
	}
	
	/**
	 * 첨부파일을 포함한 메일을 임시 보관함에 저장하는 함수
	 */
	@RequestMapping(value="/ezEmail/mailInterAttachCK.do", produces = "text/plain; charset=utf-8")
	@ResponseBody
	public String mailInterAttachCK(@CookieValue("loginCookie") String loginCookie, Locale locale, HttpServletRequest request) throws Exception{
        String cmd = "";
        
		Document xmldom = commonUtil.convertRequestToDocument(request);
		cmd = xmldom.getElementsByTagName("CMD").item(0).getTextContent();
		String uidStr = xmldom.getElementsByTagName("URL").item(0).getTextContent();
		
		NodeList bigs = xmldom.getElementsByTagName("BIG");
		boolean hasAttachFile = false;
		if (bigs != null) {
			for (int i=0; i<bigs.getLength(); i++) {
				if (bigs.item(i).getTextContent().equals("N")) {
					hasAttachFile = true;
					break;
				}
			}
		}
		
		List<String> userInfo = commonUtil.getUserIdAndPassword(loginCookie);
		String id = userInfo.get(0);
		String password  = userInfo.get(1);
		
		long uid = 0;
		if (uidStr != null && !uidStr.equals("")) {
			uid = Long.parseLong(uidStr);
		}
				
		String realPath = request.getServletContext().getRealPath("");
		String pDirTempPath = realPath + config.getProperty("upload_mail.ROOT") + commonUtil.separator + "tempFileUpload";
				
		MimeMessage newMessage = null;
		IMAPAccess ia = null;
		Folder folder = null;
		Multipart multipart = null;
		
		if (hasAttachFile) {
			SMTPAccess sa = SMTPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.SMTPPort"),
					id+"@"+config.getProperty("config.DomainName"), password);
			newMessage = sa.createMimeMessage();
			
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					id+"@"+config.getProperty("config.DomainName"), password, egovMessageSource, locale);
			
			folder = ia.getFolder(egovMessageSource.getMessage("ezEmail.t99000027", locale));
			folder.open(Folder.READ_WRITE);
			multipart = new MimeMultipart();
		}
		
		if (cmd.equals("ADD")) {
			NodeList fileNodes = xmldom.getElementsByTagName("FILE");
			
			if (hasAttachFile && uid != 0) {
				Message oldMessage = ((IMAPFolder)folder).getMessageByUID(uid);
				if (oldMessage != null) {
					if (oldMessage.getContent() instanceof Multipart) {
						Multipart mp = (Multipart)oldMessage.getContent();
						int count = mp.getCount();
						BodyPart p = null;
						
						if (oldMessage.isMimeType("multipart/related")) {
							Multipart relatedPart = new MimeMultipart("related");
							
							for (int i = 0; i < count; i++) {
								p = mp.getBodyPart(i);
								relatedPart.addBodyPart(p);
							}
							
							MimeBodyPart wrap = new MimeBodyPart();
							wrap.setContent(relatedPart);
							multipart.addBodyPart(wrap, 0);
						}
						else {
							for (int i = 0; i < count; i++) {
								p = mp.getBodyPart(i);
								multipart.addBodyPart(p);
							}
						}
					}
					
					Enumeration<Header> e = oldMessage.getAllHeaders();
					while(e.hasMoreElements()){
						Header header = e.nextElement();
						newMessage.setHeader(header.getName(), header.getValue());
					}
					
					oldMessage.setFlag(Flags.Flag.DELETED, true);
				}
			}
			
			for (int i=0; i<fileNodes.getLength(); i++) {
				Node subNode = fileNodes.item(i);
				NodeList childNodes = subNode.getChildNodes();
				String fileName = childNodes.item(0).getTextContent();
				String path = childNodes.item(1).getTextContent();
				String bigBool = childNodes.item(2).getTextContent();
				
				if (hasAttachFile && bigBool.equals("N")) {
					BodyPart messageBodyPart = new MimeBodyPart();
			        File f = new File(pDirTempPath + commonUtil.separator + path);
			        FileDataSource source = new FileDataSource(pDirTempPath + commonUtil.separator + path);
			        messageBodyPart.setDataHandler(new DataHandler(source));
			        
			        // MimeUtility.encodeText is needed to encode a file name in UTF-8 explicitly, 
			        // otherwise, a wrong encoding may be used on some systems(linux, etc)
			        String encodedFileName = MimeUtility.encodeText(fileName, "UTF-8", null);
			        
					// folding a filename is done manually since BodyPart.setFileName method encodes it based on RFC 2231.
					// and some mailers (Daum, etc) may not understand it.			        
			        encodedFileName = MimeUtility.fold(0, encodedFileName);
			        messageBodyPart.setHeader("Content-Disposition", "attachment;\r\n\tfilename=\"" + encodedFileName + "\"");
			        
			        String contentType = "application/octet-stream";
			        
			        if (Files.probeContentType(f.toPath()) != null) {
			        	contentType = Files.probeContentType(f.toPath());
			        } else {
			        	if (path.substring(path.lastIndexOf(".")).equalsIgnoreCase(".eml")) {
			        		contentType = "message/rfc822";
			        	}
			        }
			        
			        messageBodyPart.setHeader("Content-Type", contentType);
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
			ia.close();
		}
		
		String xmldomStr = commonUtil.convertDocumentToString(xmldom);
		return xmldomStr;
	}
	
	/**
	 * 메일 전송 실행 함수
	 */
	@RequestMapping(value="/ezEmail/mailInterSend.do", produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String mailInterSend(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception {
		List<String> userInfo = commonUtil.getUserIdAndPassword(loginCookie);
		String id = userInfo.get(0);
		String password  = userInfo.get(1);
		
		// TODO : MailUserVO 만들어지면 수정(jsp단도 수정)
		String userId = "";
		List<String> userIdnPw = commonUtil.getUserIdAndPassword(loginCookie);
		if (userIdnPw !=null && userIdnPw.get(0) != null) {
			userId = userIdnPw.get(0);
		}
		//OrganUserVO userInfo = ezOrganAdminService.getUserInfo(userId, "1"); //추후 lang(두번째 파라미터) 수정
		//userInfo.setMail(userInfo.getCn()+"@"+config.getProperty("config.DomainName"));
		
		String pMessageID = "";
		String rtnStatus = "";
		
		// sendmail_2010변환 시작
		// request XML값 받기
		String url = "";
		String connUrl = "";
		String orgUrl = "";
		String author = "";
		String cmd = "";
		String mailCmd = "";
		String eCharSet = "";
		String eContentTransferEncoding = "";
		String eSimpleMIME = "";
		String eSimpleMIMEContentTransferEncoding = "";
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
		String realPath = request.getServletContext().getRealPath("");
		
		Document xmlDoc = commonUtil.convertRequestToDocument(request);
		Element root = xmlDoc.getDocumentElement();
		
		Node tempNode = null;
		
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
		if (root.getElementsByTagName("TEXTBODY") != null) {
			tempNode = root.getElementsByTagName("TEXTBODY").item(0);
			if (tempNode != null) {
				textBody = tempNode.getTextContent();
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
		
//		// 다국어 발송 관련 변수들
//      string eCharSet = xmlDoc.GetElementsByTagName("CHARSET").Item(0).InnerText;
//      string eContentTransferEncoding = xmlDoc.GetElementsByTagName("CONTENT-TRANSFER-ENCODING").Item(0).InnerText;
//      string eSimpleMIME = xmlDoc.GetElementsByTagName("SIMPLE-MIME").Item(0).InnerText;
//      string eSimpleMIMEContentTransferEncoding = xmlDoc.GetElementsByTagName("SIMPLE-MIME-CONTENT-TRANSFER-ENCODING").Item(0).InnerText;
//      string eShowDisplayName = xmlDoc.GetElementsByTagName("SHOW-DISPLAYNAME").Item(0).InnerText;
        
//		string newwindowid = url;
//      string messageid; 
//		//messageid로 메시지 있으면 가져오고 없으면 새로운 message객체 생성.
//      EmailMessage message = apiesb.getemailmessage(esb, newwindowid, out messageid);
//		if (cmd.Equals("SAVE") && url != "")
//        {
//            bool isdraftmsg = message.IsDraft;
//            if (!isdraftmsg)
//            {
//                message = apiesb.getemailmessage(esb, "", out messageid);
//            }
//        }
		
		
		
		SMTPAccess sa = SMTPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.SMTPPort"),
				id+"@"+config.getProperty("config.DomainName"), password);
		MimeMessage message = sa.createMimeMessage();
		
		IMAPAccess ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
				id+"@"+config.getProperty("config.DomainName"), password, egovMessageSource, locale);
		
		// 메일 From,Recipient,CC,BCC
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
		
		// To
		logger.debug("to=" + to);
		m = r.matcher(to);
		while (m.find()) {
			name = m.group(1);
			address = m.group(2);
			internetAddress.setPersonal(name, "UTF-8");
			internetAddress.setAddress(address);
			message.addRecipient(RecipientType.TO, internetAddress);
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
		}				
		
		// 메일 제목
		message.setSubject(subject, "UTF-8");
		
		logger.debug("cmd=" + cmd + ",simpleMime=" + simpleMime);
		
		// 메일 본문 및 타입
		MimeBodyPart content = new MimeBodyPart();
		if (simpleMime.equals("1")) {
            if (!cmd.toUpperCase().equals("SAVE")) {
                if (!delaySendTime.equals("")) {
                	message.setContent(textBody, "text/plain; charset=utf-8");
                	content.setContent(textBody, "text/plain; charset=utf-8");
                } else {
                	message.setContent(textBody.replaceAll("<DIV id=MailSign", "<DIV id=MailSignSent"), "text/plain; charset=utf-8");
                	content.setContent(textBody.replaceAll("<DIV id=MailSign", "<DIV id=MailSignSent"), "text/plain; charset=utf-8");
                }
            } else {
            	message.setContent(textBody, "text/plain; charset=utf-8");
            	content.setContent(textBody, "text/plain; charset=utf-8");
            }
        } else {
            if (!cmd.toUpperCase().equals("SAVE")) {
                if (!delaySendTime.equals("")) {
                	message.setContent(htmlBody, "text/html; charset=utf-8");
                	content.setContent(htmlBody, "text/html; charset=utf-8");
                } else {
                	message.setContent(htmlBody.replaceAll("<DIV id=MailSign", "<DIV id=MailSignSent"), "text/html; charset=utf-8");
                	content.setContent(htmlBody.replaceAll("<DIV id=MailSign", "<DIV id=MailSignSent"), "text/html; charset=utf-8");
                }
            } else {
            	message.setContent(htmlBody, "text/html; charset=utf-8");
            	content.setContent(htmlBody, "text/html; charset=utf-8");
            }

        }
		
		// 보안메일
		if (pSecurityMail.equals("3")) {
			message.setHeader("Sensitivity", "company-confidential");
        }
		
		// 메일 중요도
		switch (importance) {
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
        } else {
        	message.removeHeader("Return-Receipt-To");
        }

        // 추적(수신확인)
        logger.debug("replyReadTime=" + replyReadTime);
        if (replyReadTime.equals("1")) {
        	message.setHeader("Disposition-Notification-To", ((InternetAddress)message.getFrom()[0]).getAddress());
        } else {
        	message.removeHeader("Disposition-Notification-To");
        }
        
        //SentDate 설정
        message.setSentDate(Calendar.getInstance().getTime());
        
        //User-Agent 설정
        message.setHeader("User-Agent", "JMocha Mail 0.1");
        
        //inline image 처리
        MimeMultipart relatedPart = null;
        
        if (!simpleMime.equals("1")) {
        	// getElementsByTagName always returns non-null object even if
        	// the tag doesn't exist, so its length must be checked.
        	NodeList imageNameList = root.getElementsByTagName("IMAGENAME");
        	NodeList imagePathList = root.getElementsByTagName("IMAGEPATH");
        	
	        if (imageNameList != null && imageNameList.getLength() > 0
	        		&& imagePathList != null && imagePathList.getLength() > 0) {
	        	String imageName = "";
	            String imagePath = "";
	        	
	            relatedPart = new MimeMultipart("related");
	            
	        	for (int i=0; true; i++) {
	            	if (imageNameList.item(i) == null || imagePathList.item(i) == null) {
	            		break;
	            	}
	            	
	            	imageName = imageNameList.item(i).getTextContent();
	            	imagePath = imagePathList.item(i).getTextContent();
	            	
	            	if (!imageName.trim().equals("") && !imagePath.trim().equals("")) {
	                	//TODO: embedding제거
	            		
	                	imagePath = new URL(imagePath).getPath();
	                	String pDirPath = realPath + imagePath;
	                	
	        	        File f = new File(pDirPath);
	        	        if (f.exists()) {	            		
		                	String cid = imageName + "@12345678.87654321";
		                	String strContent = content.getContent().toString();
		                	int index = strContent.indexOf("src=\"" + imageName);
		                	if (index != -1) {
		                		strContent = strContent.replace("src=\"" + imageName, "src=\"cid:" + cid);
		                	}
		                	content.setContent(strContent, "text/html; charset=utf-8");
	                		        	        
		                	MimeBodyPart messageBodyPart = new MimeBodyPart();
		                	
		        	        FileDataSource source = new FileDataSource(f);
		        	        messageBodyPart.setDataHandler(new DataHandler(source));
		        	        messageBodyPart.setFileName(imageName);
		        	        
		        	        String contentType = "application/octet-stream";
		        	        
		        	        if (Files.probeContentType(f.toPath()) != null) {
		        	        	contentType = Files.probeContentType(f.toPath());
		        	        }
		        	        
		        	        messageBodyPart.setHeader("Content-Type", contentType);
		        	        messageBodyPart.setContentID("<" + cid + ">");
		        	        messageBodyPart.setDisposition(Part.INLINE);
		        	        
		        	        relatedPart.addBodyPart(messageBodyPart);
	        	        }
	                }
	            }
	        	
	        	relatedPart.addBodyPart(content, 0);
	        	message.setContent(relatedPart);
			}
        }
        
        //첨부파일 처리
        Folder folder = ia.getFolder(egovMessageSource.getMessage("ezEmail.t99000027", locale));
        folder.open(Folder.READ_WRITE);
        
        logger.debug("url=" + url);
        long uid = 0;
                
        // merge the existing message in the Drafts folder into a new message.
        Message oldMessage = null;
        if (!url.trim().equals("")) {
        	uid = Long.parseLong(url);
        
        	MimeMultipart mixedPart = new MimeMultipart();
			
			if (uid != 0) {
				oldMessage = ((IMAPFolder)folder).getMessageByUID(uid);
				
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
					
					if (oldMessage.getContent() instanceof Multipart) {
						Multipart mp = (Multipart)oldMessage.getContent();
						int count = mp.getCount();
						BodyPart p = null;
						boolean hasAttach = false;
						
						for (int i = 0; i < count; i++) {
							p = mp.getBodyPart(i);
							
							// this case means it's editing an existing message in Drafts
							if (p.isMimeType("multipart/related")) {
								hasAttach = true;
								
								logger.debug("relatedPart=" + relatedPart);
								if (relatedPart == null) {
									relatedPart = new MimeMultipart("related");
								}
								// new related part is already created by the above routine
								// for adding new in-line images.
								else {
									relatedPart.removeBodyPart(0);
								}
								
								Multipart relatedPartContent = (Multipart)p.getContent();
								int relatedPartCount = relatedPartContent.getCount();
								BodyPart relatedSubPart = null;
								
								for (int j = 0; j < relatedPartCount; j++) {
									relatedSubPart = relatedPartContent.getBodyPart(j);
									
									if (relatedSubPart instanceof MimePart) {
										if (((MimePart)relatedSubPart).getContentID() != null) {
											relatedPart.addBodyPart(relatedSubPart);						
										}
									}				
								}
								
								String bodyContent = content.getContent().toString();
								bodyContent = convertDownloadInlineImageURLtoCid(bodyContent);							
								content.setContent(bodyContent, "text/html; charset=utf-8");
								relatedPart.addBodyPart(content, 0);
								
								removeUnusedInlineImagePart(relatedPart);
							}
							else if (p.getDisposition() != null) { 
								mixedPart.addBodyPart(p);
								if (p.getDisposition().equalsIgnoreCase(Part.ATTACHMENT)) {
									hasAttach = true;
								}
							}
							else if (p.isMimeType("message/*")) {
								mixedPart.addBodyPart(p);
								hasAttach = true;
							}							
							else {
								// there are cases where an in-line image part doesn't have
								// a Content-Disposition header, but has a Content-ID header.
								if (p instanceof MimePart) {
									if (((MimePart)p).getContentID() != null) {
										mixedPart.addBodyPart(p);			
									}
								}												
							}
						}
						
						if (hasAttach) {
							if (relatedPart != null) {
								MimeBodyPart wrap = new MimeBodyPart();
								wrap.setContent(relatedPart);
								mixedPart.addBodyPart(wrap, 0);
							} else {
								mixedPart.addBodyPart(content, 0);
							}							
							message.setContent(mixedPart);							
						}
						// this case means it's editing an existing message in Drafts.
						else if (oldMessage.isMimeType("multipart/related")) {
							logger.debug("relatedPart=" + relatedPart);
							
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
							
							// this mixedPart is actually a related part.
							mixedPart.setSubType("related");
							
							String bodyContent = content.getContent().toString();
							bodyContent = convertDownloadInlineImageURLtoCid(bodyContent);							
							content.setContent(bodyContent, "text/html; charset=utf-8");							
							mixedPart.addBodyPart(content, 0);
							
							removeUnusedInlineImagePart(mixedPart);
							
							message.setContent(mixedPart);							
						}
					}					
				}
			}
        }        
        
        long draftUID = 0;
        if (cmd.equalsIgnoreCase("SAVE")) {
        	logger.debug("Saving the message");
        	
    		message.setFlag(Flags.Flag.SEEN, true);
    		AppendUID[] uids = ((IMAPFolder)folder).appendUIDMessages(new Message[]{message});
    		if (uids != null && uids[0] != null) {
    			draftUID = uids[0].uid;
    		} 
    		
            // this deletion code block has been moved here because
            // it needs to be kept in Drafts if an error occurs during the above process.
            if (oldMessage != null) {
            	oldMessage.setFlag(Flags.Flag.DELETED, true);
            }
            
        	rtnStatus = "OK";
        } else if (cmd.equalsIgnoreCase("SEND")) {
        	logger.debug("Sending the message");
        	
        	// TODO: 이후 예외 처리 필요
        	// 편지함 용량 초과 메세지 확인을 위해 임시저장
    		message.setFlag(Flags.Flag.SEEN, true);
    		AppendUID[] uids = ((IMAPFolder)folder).appendUIDMessages(new Message[]{message});
    		if (uids != null && uids[0] != null) {
    			draftUID = uids[0].uid;
    		} 
        
			String strCheckReadUrl = ""; //외부메일수신확인 관련 URL. GetSystemConfigValue("APPREADCHECK_URL").ToString();
	        Boolean isEachMailB = Boolean.parseBoolean(isEachMail.trim());
	        if (!delaySendTime.equals("")) {
	        	//예약발송
	            doDelaySend(message, isReserve, reservedId, subject, delaySendTime, userId, realPath);
	        	
	            // this deletion code block has been moved here because
	            // it needs to be kept in Drafts if an error occurs during the above process.
	            if (oldMessage != null) {
	            	oldMessage.setFlag(Flags.Flag.DELETED, true);
	            }
	            
	            rtnStatus = "OK";
	        } else {                        
	            if (!eShowDisplayName.equals("")) {
	            	//eShowDisplayName = Base64Encode(eShowDisplayName);
	                //message.SetExtendedProperty(new ExtendedPropertyDefinition(DefaultExtendedPropertySet.InternetHeaders, "X-NEW-DISPLAYNAME", MapiPropertyType.String), eShowDisplayName);
	            }
	            //message.Update(ConflictResolutionMode.AlwaysOverwrite);
	
	//            if (replyReadTime.equals("2") && strCheckReadUrl != "" && !iseachmail) //외부메일수신확인
	//            	rtnStatus = OuterMailSend(esb, message, mailcmd, strCheckReadUrl, orgurl, messageid, newwindowid);
	//            else
	//            	rtnStatus = InnterMailSend(esb, message, mailcmd, iseachmail, orgurl, newwindowid, messageid, strCheckReadUrl, xmldom);
	            
	            //InnterMailSend 변환 시작
	            if (isEachMailB) {
	            	//개별발송에 따른 "X-READCHECK" 값  Update
	            	String strRecvGuid = UUID.randomUUID().toString();
	            	message.setHeader("x-readcheck", strRecvGuid);
	            	message.setHeader("x-eachmail", "true");
	            	
	            	Address[] allRecipients = message.getAllRecipients();
	            	
	            	// 임시보관함에 미리 저장해두고 성공했을 시 임시보관함에 있는 메일을 보낸메일함으로 이동
	            	message.removeHeader("TO");
	        		message.removeHeader("CC");
	        		message.removeHeader("BCC");
	            	for(Address a : allRecipients){
	            		message.setRecipient(RecipientType.TO, a);
	            		
	            		Transport.send(message);
	            	}
	            	
	                // this deletion code block has been moved here because
	                // it needs to be kept in Drafts if an error occurs during the above process.
	                if (oldMessage != null) {
	                	oldMessage.setFlag(Flags.Flag.DELETED, true);
	                }
	            } else {
	            	Transport.send(message);
	            	
	                // this deletion code block has been moved here because
	                // it needs to be kept in Drafts if an error occurs during the above process.
	                if (oldMessage != null) {
	                	oldMessage.setFlag(Flags.Flag.DELETED, true);
	                }
	                	            	
	            	//보낸편지함에 저장
	        		Folder sendFolder = ia.getFolder(egovMessageSource.getMessage("ezEmail.t99000026", locale));
	        		Message draftMessage = ((IMAPFolder)folder).getMessageByUID(draftUID);
	        		folder.copyMessages(new Message[]{draftMessage}, sendFolder);
	        		draftMessage.setFlag(Flags.Flag.DELETED, true);
	            }
	            
	            //예악발송 수정 시 옵션에서 예약발송 안하고 저장했을 시 DB 데이터 삭제, 파일 시스템의 eml파일 삭제
	            logger.debug("reservedId=" + reservedId);
	            if (reservedId != null && !reservedId.trim().equals("")) {
		            ezEmailService.deleteMailReserved(reservedId);
		            String pDirPath = config.getProperty("upload_mail.RESERVED_MAIL_PATH");
		    		pDirPath = realPath + pDirPath;
		            File f = new File(pDirPath + commonUtil.separator + reservedId + ".eml");
					if (f.exists()) {
						f.delete();
					}
	            }
	            
	            // set the ANSWERED flag of the original message to indicate it has been replied.
	            if (mailCmd.equals("REPLY") || mailCmd.equals("REPLYALL") || mailCmd.equals("FORWARD")) {
	    			int index = orgUrl.lastIndexOf("/");			
	    			
	    			if (index != -1) {
	    				String orgMsgFolderPath = orgUrl.substring(0, index);
	    				long orgMsgUid = Long.parseLong(orgUrl.substring(index + 1));

	    				logger.debug("orgMsgFolderPath=" + orgMsgFolderPath + ",orgMsgUid=" + orgMsgUid);
	    				
	    		        Folder orgMsgFolder = ia.getFolder(orgMsgFolderPath);
	    		        orgMsgFolder.open(Folder.READ_WRITE);
	    				
	    		        Message orgMessage = ((IMAPFolder)orgMsgFolder).getMessageByUID(orgMsgUid);
    		        	
	    		        if (mailCmd.equals("REPLY") || mailCmd.equals("REPLYALL")) {
	    		        	orgMessage.setFlag(Flags.Flag.ANSWERED, true);
	    		        	ezEmailUtil.setForwardedFlag(orgMessage, false);
	    		        }
	    		        else {
	    		        	ezEmailUtil.setForwardedFlag(orgMessage, true);
	    		        	orgMessage.setFlag(Flags.Flag.ANSWERED, false);
	    		        }
	    		        
	    		        orgMsgFolder.close(true);
	    			}
	            }
	            
	            rtnStatus = "OK";
	        }
        }
                
        folder.close(true);        
        ia.close();
        
        // sendmail_2010변환 끝
        
        //file system의 inline image 파일 삭제 - 경로가 upload_common인 파일만 삭제
        NodeList imagePathList = root.getElementsByTagName("IMAGEPATH");
        if (imagePathList != null && imagePathList.getLength() > 0) {
            String imagePath = "";
            
        	for (int i=0; true; i++) {
            	if (imagePathList.item(i) == null) {
            		break;
            	}
            	
            	imagePath = imagePathList.item(i).getTextContent();
            	
            	if (!imagePath.trim().equals("") && imagePath.contains(config.getProperty("upload_common.ROOT"))) {
                	imagePath = new URL(imagePath).getPath();
                	String pDirPath = realPath + imagePath;
            		File f = new File(pDirPath);
            		if (f.exists()) {
            			f.delete();
            		}
            	}
        	}
        }
        
        String pResult = null;
        pResult = "<RESULT><![CDATA[" + rtnStatus + "]]></RESULT>";
        pResult += "<MESSAGEID><![CDATA[" + draftUID + "]]></MESSAGEID>";
        
		return "<DATA>" + pResult + "</DATA>";
	}
	
	/**
	 * 임시저장메일 삭제 실행 함수
	 */
	@RequestMapping(value="/ezEmail/delDrafts.do", produces = "text/html")
	@ResponseBody
	public String delDrafts(@CookieValue("loginCookie") String loginCookie, Locale locale, HttpServletRequest request) throws Exception {
		List<String> userInfo = commonUtil.getUserIdAndPassword(loginCookie);
		String id = userInfo.get(0);
		String password  = userInfo.get(1);
		
		String uidStr = request.getParameter("itemid");
		logger.debug("uidStr=" + uidStr);
		
		long uid = 0;
		if (uidStr != null && !uidStr.equals("")) {
			uid = Long.parseLong(uidStr);
		}
		
		IMAPAccess ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
				id+"@"+config.getProperty("config.DomainName"), password, egovMessageSource, locale);
		
		Folder folder = ia.getFolder(egovMessageSource.getMessage("ezEmail.t99000027", locale));
		folder.open(Folder.READ_WRITE);
		Message message = ((IMAPFolder)folder).getMessageByUID(uid);
		logger.debug("message=" + message);
		
		if (message != null) {
			message.setFlag(Flags.Flag.DELETED, true);
		}
        folder.close(true);
		
		ia.close();
		return "";
	}
	
	/**
	 * 첨부파일 정보(templist) 반환 함수
	 */
	@RequestMapping(value="/ezEmail/fileListSession.do", produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String fileListSession(@CookieValue("loginCookie") String loginCookie, Locale locale, HttpServletRequest request) throws Exception {
		String fileData = request.getParameter("filedata") == null ? "" : request.getParameter("filedata");
		
		String pDirPath = config.getProperty("upload_mail.ROOT");
		String realPath = request.getServletContext().getRealPath("");
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
		
		return returnValue;
	}
	
	/**
	 * 일반 첨부파일 삭제 실행 함수
	 */
	@RequestMapping(value="/ezEmail/mailDelInterAttach.do", produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String mailDelInterAttach(@CookieValue("loginCookie") String loginCookie, Locale locale, HttpServletRequest request) throws Exception {
		List<String> userInfo = commonUtil.getUserIdAndPassword(loginCookie);
		String id = userInfo.get(0);
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
		
		if (uid != 0) {
			NodeList rows = root.getElementsByTagName("ROW");
			
			if (rows != null && rows.item(0) != null) {
				SMTPAccess sa = SMTPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.SMTPPort"),
						id+"@"+config.getProperty("config.DomainName"), password);
				
				IMAPAccess ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
						id+"@"+config.getProperty("config.DomainName"), password, egovMessageSource, locale);
				
				Folder folder = ia.getFolder(egovMessageSource.getMessage("ezEmail.t99000027", locale));
				folder.open(Folder.READ_WRITE);
				Message oldMessage = ((IMAPFolder)folder).getMessageByUID(uid);
				
				if (oldMessage != null) {
					MimeMessage newMessage = sa.createMimeMessage();
					Multipart multipart = new MimeMultipart();
					
					Multipart mp = (Multipart)oldMessage.getContent();
					int count = mp.getCount();
					BodyPart p = null;
					
					for (int i = 0; i < count; i++) {
						p = mp.getBodyPart(i);
						
						int length = rows.getLength();
						boolean isRemoved = false;
						if (p.getDisposition() != null && p.getDisposition().equalsIgnoreCase(Part.ATTACHMENT)) {
							for (int j = 0; j < length; j++) {
								if (rows.item(j).getFirstChild().getTextContent().equals(p.getFileName())) {
									isRemoved = true;
									break;
								}
							}
						}
						
						if (!isRemoved) {
							multipart.addBodyPart(p);
						}
					}
					
					Enumeration<Header> e = oldMessage.getAllHeaders();
					while(e.hasMoreElements()){
						Header header = e.nextElement();
						newMessage.setHeader(header.getName(), header.getValue());
					}
					
					if (multipart.getCount() != 0) {
						newMessage.setContent(multipart);
						newMessage.setFlag(Flags.Flag.SEEN, true);
						AppendUID[] uids = ((IMAPFolder)folder).appendUIDMessages(new Message[]{newMessage});
						returnValue += uids[0].uid;
					}
					
					oldMessage.setFlag(Flags.Flag.DELETED, true);
					
				}
				folder.close(true);
				
				ia.close();
			}
		}
		
		returnValue += "]]></DATA>";
		return returnValue;
	}
	
	/**
	 * 대용량 첨부파일 삭제 실행 함수
	 */
	@RequestMapping(value="/ezEmail/fileListDelete.do", produces = "text/plain; charset=utf-8")
	@ResponseBody
	public String fileListDelete(@CookieValue("loginCookie") String loginCookie, Locale locale, HttpServletRequest request) throws Exception{
		String fileData = request.getParameter("filedata") != null ? request.getParameter("filedata") : "";
		String realFileNM = request.getParameter("realFileNM") != null ? request.getParameter("realFileNM") : "";
		String pDirPath = config.getProperty("upload_mail.ROOT");
		String realPath = request.getServletContext().getRealPath("");
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
		
		return "";
	}
	
	/**
	 * 사원 정보 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailNameCheck.do", produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String mailNameCheck(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception{
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
        
        String organXML = getOrganSearch(pOrganSearchList, pOrganCellList, pOrganPropList, pOrganListType);
        String dlXML = getOrganDLSearch(pDLSearchList, pDLCellList, pDLPropList, pDLListType);
        String addressXML = getAddressSearch(pAddressFilter);
        return String.format("<RESULT><ORGAN>%s</ORGAN><DL>%s</DL><ADDRESS>%s</ADDRESS></RESULT>", organXML, dlXML, addressXML);
	}
	
	/**
	 * 메일 옵션화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/letterOption.do")
	public String mailLetterOption(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		//TODO: 변수들 setting
		String userTimeSet = "";
		String setLocalTime = "";
		String nonActiveX = "YES";
		boolean outMailReadCheck = false;
		
		model.addAttribute("userTimeSet", userTimeSet);
		model.addAttribute("setLocalTime", setLocalTime);
		model.addAttribute("nonActiveX", nonActiveX);
		model.addAttribute("outMailReadCheck", outMailReadCheck);
		
		return "ezEmail/mailLetterOption";
	}
	
	/**
	 * 사원 Organ 정보 호출 함수
	 */
	private String getOrganSearch(String pSearchList, String pCellList, String pPropList, String pListType) {
		String pResult = "";
        try {
            pResult = ezOrganService.getSearchList(pSearchList, pCellList, pPropList, pListType, 100, config.getProperty("config.primary"));
        } catch (Exception Ex) {
            pResult = "EXCEPTION";
        }
        return pResult;
    }
	
	/**
	 * 사원 DL 정보 호출 함수
	 */
	private String getOrganDLSearch(String pSearchList, String pCellList, String pPropList, String pListType) {
        String pResult = "";
        try {
        	//TODO : ezOrganService에 getSearchListDL만들어지면 연결
            //pResult = ezOrganService.getSearchListDL(pSearchList, pCellList, pPropList, pListType, 100, "");
        	pResult = "<LISTVIEWDATA><ROWS></ROWS></LISTVIEWDATA>";
        } catch (Exception Ex) {
            pResult = "EXCEPTION";
        }
        return pResult;
    }
	
	/**
	 * 사원 Address 정보 호출 함수
	 */
	private String getAddressSearch(String pFilter) {
        String pResult = "";
        try {
        	//TODO : ezAddress 만들어지면 연결
//            XmlDocument xmldom = new XmlDocument();
//            StringBuilder Rvalue = new StringBuilder("");
//            GetSearcAddressInfo(pFilter, "P", ref Rvalue);
//            string _field = "STYPE,AddressID, SNAME,'DB' AS FLODERTYPE , SEMAIL, SCOMPANY, SDEPT, STITLE";
//            //ezAddress.AddressInfo _ezAddress = new ezAddress.AddressInfo();
//            string DBSearchList = _ezAddress.GetSearchList(userinfo.CompanyID + "," + userinfo.DeptID, "", "SNAME LIKE '%" + pFilter + "%'", _field, 0, 100, 0, "");
//            xmldom = GetXmlReaderString(DBSearchList);
//            if (xmldom.SelectNodes("DATA/ROW").Count > 0) {
//                foreach (XmlNode Node in xmldom.SelectNodes("DATA/ROW")) {
//                    Rvalue.Append(Node.OuterXml);
//                }
//            }
//            pResult = Rvalue.ToString();
        	pResult = "";
        } catch (Exception Ex) {
            pResult = "EXCEPTION";
        }
        return pResult;
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
			mat.appendReplacement(result, "src=\"cid:" + cid + "\"");
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
	
	/**
	 * 메일 예약발송 처리 함수
	 */
	private void doDelaySend(Message message, String isReserve, String reservedId, String subject, String sendDate, String userId, String realPath) throws Exception {
		String messageId = "";
		
		if (isReserve.equalsIgnoreCase("YES")) { //예약메일 수정
			messageId = reservedId;
			ezEmailService.updateReservedMail(messageId, subject, sendDate);
		} else { //예약메일 생성
			messageId = UUID.randomUUID().toString();
			String email = userId + "@" + config.getProperty("config.DomainName");
			ezEmailService.setMailReserved(messageId, subject, sendDate, email);
		}
		
		File f = null;
		String pDirPath = config.getProperty("upload_mail.ROOT");
		pDirPath = realPath + pDirPath;
		f = new File(pDirPath);
		if (!f.exists()) {
			f.mkdir();
		}
		
		pDirPath = config.getProperty("upload_mail.RESERVED_MAIL_PATH");
		pDirPath = realPath + pDirPath;
		f = new File(pDirPath);
		if (!f.exists()) {
			f.mkdir();
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
	
}
