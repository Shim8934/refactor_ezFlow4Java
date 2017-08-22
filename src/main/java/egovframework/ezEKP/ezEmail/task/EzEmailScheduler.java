package egovframework.ezEKP.ezEmail.task;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FilenameFilter;
import java.io.IOException;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Enumeration;
import java.util.List;
import java.util.Locale;
import java.util.Properties;
import java.util.UUID;

import javax.activation.DataHandler;
import javax.activation.FileDataSource;
import javax.annotation.Resource;
import javax.crypto.Cipher;
import javax.mail.Address;
import javax.mail.Flags;
import javax.mail.Folder;
import javax.mail.Header;
import javax.mail.Message;
import javax.mail.Transport;
import javax.mail.Message.RecipientType;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import javax.mail.internet.MimeUtility;
import javax.mail.search.AndTerm;
import javax.mail.search.ComparisonTerm;
import javax.mail.search.FlagTerm;
import javax.mail.search.ReceivedDateTerm;
import javax.mail.search.SearchTerm;

import org.apache.commons.lang3.math.NumberUtils;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.sun.mail.imap.AppendUID;
import com.sun.mail.imap.IMAPFolder;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.logic.IMAPAccess;
import egovframework.ezEKP.ezEmail.logic.SMTPAccess;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezEmail.util.EzEmailUtil;
import egovframework.ezEKP.ezEmail.vo.MailDeleteVO;
import egovframework.ezEKP.ezEmail.vo.MailReservationVO;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.ezEKP.ezSystem.service.EzSystemAdminService;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.TenantVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

@Component
public class EzEmailScheduler extends EgovFileMngUtil {

	private static final Logger logger = LoggerFactory.getLogger(EzEmailScheduler.class);

	@Autowired
	private Properties config;

	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource; 

	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private EzEmailService ezEmailService;
	
	@Autowired
	private EzCommonService ezCommonService;
	
	@Resource(name = "loginService")
    private LoginService loginService;
	
	@Autowired
	private EzEmailUtil ezEmailUtil;
	
	@Autowired
	private EzOrganAdminService ezOrganAdminService;
	
	@Resource(name="EzSystemAdminService")
	private EzSystemAdminService ezSystemAdminService;
	
	@Resource(name = "jspw")
    private String jspw;
	
	@Resource(name="crypto") 
    private EgovFileScrty egovFileScrty;
	
	/**
	 * 환경설정 - 자동삭제 스케줄러
	 */
	@Scheduled(cron = "${config.cron.autoDelete}")
	public void autoDelete() throws Exception{
		logger.debug("autoDelete scheduler started.");
		
		//choose scheduler running server
		if (!preScheduler("autoDelete")) {
			logger.debug("autoDelete scheduler ended.");
			return;
		}
		
		Locale locale = Locale.getDefault();
		
		List<MailDeleteVO> list = ezEmailService.getMailDeleteList();

		for (MailDeleteVO vo : list) {
			IMAPAccess ia = null;
			
			try {
				String userEmail = vo.getUserEmail();

				String password = jspw;
				String path = vo.getPath();
				String deleteUnread = vo.getDeleteUnread();
				int expireTime = vo.getExpireTime();

				logger.debug("userEmail=" + userEmail);
				logger.debug("path=" + path);
				logger.debug("deleteUnread=" + deleteUnread);
				logger.debug("expireTime=" + expireTime);

				ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
						userEmail, password, egovMessageSource, locale);
				Folder f = ia.getFolder(path);

				if (f != null && f.exists()) {
					f.open(Folder.READ_WRITE);

					Calendar cal = Calendar.getInstance();
					cal.setTime(new Date());
					cal.add(Calendar.DATE, expireTime *-1);
					SearchTerm searchTerm = new ReceivedDateTerm(ComparisonTerm.LT, cal.getTime());

					if (deleteUnread.equals("0")) {
						searchTerm = new AndTerm(searchTerm, new FlagTerm(new Flags(Flags.Flag.SEEN), true));
					}

					Message[] messages = f.search(searchTerm);

					f.setFlags(messages, new Flags(Flags.Flag.DELETED), true);
					f.close(true);
				}
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				if (ia != null) {
					ia.close();
				}
			}
			
		}
		
		logger.debug("autoDelete scheduler ended.");
	}
	
	/**
	 * 메일 예약발송 스케줄러
	 */
	@Scheduled(cron = "${config.cron.reservedMailSend}")
	public void reservedMailSend() throws Exception{
		logger.debug("reservedMailSend scheduler started.");
		
		//choose scheduler running server
		if (!preScheduler("reservedMailSend")) {
			logger.debug("reservedMailSend scheduler ended.");
			return;
		}
		
		List<MailReservationVO> list = ezEmailService.getMailReserved2();
		
		for (MailReservationVO vo : list) {
			logger.debug("messageId=" + vo.getMessageId());
			logger.debug("userAccount=" + vo.getConnUrl());
			
			IMAPAccess ia = null;
			FileInputStream fis = null;
			try {
				
				String userAccount = vo.getConnUrl();
				String password = jspw;
	
				String realPath = config.getProperty("data_root");
				
				String userId = userAccount.split("@")[0];
				String domainName = userAccount.split("@")[1];
				
				int tenantId = ezCommonService.getTenantIdByDomainName(domainName);
				String lang = ezCommonService.selectUserGetLang(userId, tenantId);
				Locale locale = new Locale(commonUtil.getTwoLetterLangFromLangNum(lang));
				String offset = ezCommonService.selectUserGetTimeZone(userId, tenantId);
				logger.debug("locale=" + locale + ",offset=" + offset);
				
				String pDirPath = commonUtil.getUploadPath("upload_mail.RESERVED_MAIL_PATH", tenantId);
				pDirPath = realPath + commonUtil.separator + pDirPath;
	
				File f = new File(pDirPath + commonUtil.separator + vo.getMessageId() + ".eml");
				logger.debug("filePath=" + pDirPath + commonUtil.separator + vo.getMessageId() + ".eml");
				
				File encryptedFile = null; // 보안메일 관련 파일 변수
				
				if (f.exists()) {
					fis = new FileInputStream(f);
	
					SMTPAccess sa = SMTPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.SMTPPort"),
							userAccount, password);
	
					MimeMessage message = sa.readMimeMessage(fis);
					
					//SentDate 재설정
			        message.setSentDate(Calendar.getInstance().getTime());
					logger.debug("Reset sentDate. sentDate=" + message.getSentDate().toString());
			        
					String[] eachMailHeaders = message.getHeader("X-JMocha-Each-Mail");
					String eachMailHeader = eachMailHeaders != null ? eachMailHeaders[0] : null;		
					
					if (eachMailHeader != null) {
						message.removeHeader("X-JMocha-Each-Mail");
					}
					
					String[] secureMailHeaders = message.getHeader("X-JMocha-Secure-Mail");
					String secureMailHeader = secureMailHeaders != null ? secureMailHeaders[0] : null;		
					
					// TODO: 보안메일 처리
					if (secureMailHeader.equals("true")) {
						
						// get Info from secureMail header
						secureMailHeader = MimeUtility.decodeText(secureMailHeader);
						String securePassword = message.getHeader("X-JMocha-Secure-Mail-Password")[0];
						String secureReadCount = message.getHeader("X-JMocha-Secure-Mail-ReadCount")[0];
						String secureReadDate = message.getHeader("X-JMocha-Secure-Mail-ReadDate")[0];
						String serverName = message.getHeader("X-JMocha-Secure-Mail-ServerName")[0];
						logger.debug("securePassword=" + securePassword + ",secureReadCount=" + secureReadCount
								+ ",secureReadDate=" + secureReadDate + ",serverName=" + serverName);
						
						// remove header
						message.removeHeader("X-JMocha-Secure-Mail-Password");
						message.removeHeader("X-JMocha-Secure-Mail-ReadCount");
						message.removeHeader("X-JMocha-Secure-Mail-ReadDate");
						message.removeHeader("X-JMocha-Secure-Mail-ServerName");
						message.removeHeader("X-JMocha-Secure-Mail");
						
						//TODO: timezone 처리 확인
						if (!secureReadDate.equals("")) {
							SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
							secureReadDate = sdf.format(new Date(Long.parseLong(secureReadDate)));
							secureReadDate = commonUtil.getDateStringInUTC(secureReadDate, offset, true);
						}
						
						// save secure mail info and get secureId
	            		int secureId = ezEmailService.setMailSecure(tenantId, userId, securePassword, Integer.parseInt(secureReadCount), secureReadDate);
    		        	
	            		if (secureId == 0) {
    		        		throw new Exception("INSERTSECUREMAILFAIL");
    		        	}
						
	            		MimeMessage secureMessage = sa.createMimeMessage();
	            		
	            		// copy message's headers
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
    		        	
    		        	StringBuilder sb = new StringBuilder();
    		        	sb.append("<style>\n");
    		        	sb.append(".security_message{background:#d0e1ff;}\n");
    		        	sb.append(".security_message .security_img{max-width:780px; margin:0 auto; padding-left: 40px;}\n");
    		        	sb.append(".security_message .security_txt{margin:0px 0px 0px 300px; padding:54px 0px; font-family:\"맑은고딕\", Malgun Gothic, \"돋움\", Dotum, \"굴림\", Gulim, Arial, Helvetica, sans-serif;position:relative;left:-50px;margin-top:-250px;}\n");
    		        	sb.append(".security_message .security_txt h4{margin:0px; padding:3px 0px 0px 0px; font-size:22px; letter-spacing:-1px; color:#333; border-bottom:2px solid #727985; line-height:44px;}\n");
    		        	sb.append(".security_message .security_txt h4 span{color:#304d7f;}\n");
    		        	sb.append(".security_message .security_txt p{margin:0px; padding:5px 0px 0px 0px; font-size:15px; color:#333; line-height:22px;}\n");
    		        	sb.append("</style>\n");
    		        	sb.append("<div class=\"security_message\">\n");
    		        	sb.append("    <div class=\"security_img\">\n");
    		        	sb.append("        <img src=\"cid:" + tempFileName + ".gif@12345678.87654321\">\n");
    		        	sb.append("        <section class=\"security_txt\">\n");
    		        	sb.append("            <h4>해당 메일은 <span>암호화</span>되어있는 <span>보안메일</span>입니다.</h4>\n");
    		        	sb.append("            <p>메일을 열람하려면 첨부파일을 다운로드한 후<br>보낸 사람이 지정한 암호를 입력해야 합니다.<br>열람 허용 횟수와 열람 허용 기간이 지정되어있으니<br>주의하시기 바랍니다.</p>\n");
    		        	sb.append("        </section>\n");
    		        	sb.append("    </div>\n");
    		        	sb.append("</div>\n");
    		        	secureBodyHtmlPart.setContent(sb.toString(), "text/html; charset=utf-8");
    		        	
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
    		        	
    		        	sb = new StringBuilder();
    		        	sb.append("<!DOCTYPE html>\n");
    		        	sb.append("<html style=\"height:100%;\">\n");
    		        	sb.append("    <head>\n");
    		        	sb.append("        <meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\"/>\n");
    		        	sb.append("        <title>SECURE MAIL</title>\n");
    		        	sb.append("        <style>\n");
    		        	sb.append("            .security_layerpopup{width:100%; height:100%; background:#f1f1f1;}\n");
    		        	sb.append("            .security_layerpopup .popup_img{margin:0px; padding:84px 0px 0px 0px; text-align:center;}\n");
    		        	sb.append("            .security_layerpopup .popup_txt{margin:0px; padding:0px; text-align:center; font-size:24px; color:#333; font-weight:600; font-family:\"맑은고딕\", Malgun Gothic, \"돋움\", Dotum, \"굴림\", Gulim, Arial, Helvetica, sans-serif;}\n");
    		        	sb.append("            .security_layerpopup .popup_txt span{font-size:18px; font-weight:300; letter-spacing:-1px;}\n");
    		        	sb.append("            .security_layerpopup form{width:465px; margin: 35px auto;}\n");
    		        	sb.append("            .security_layerpopup form fieldset {margin:0; padding:0; border:0; clear:both;}\n");
    		        	sb.append("            .security_layerpopup legend {visibility:hidden; position:absolute; top:0; left:0; width:1px; height:1px; font-size:0; line-height:0}\n");
    		        	sb.append("            .security_layerpopup .password{float:left; width:380px; height:45px; margin:0px; padding::0px; background:url(http://" + serverName + "/images/email/secureMail/input_pw_bg.gif) no-repeat;}\n");
    		        	sb.append("            .security_layerpopup #TextPassword {background:url(http://" + serverName + "/images/email/secureMail/pw_txt.png) no-repeat 0px 3px; width:300px; height:43px;  margin:1px 0px 0px 46px; padding:0px 0px 0px 10px; line-height:21px; color:#777; font-size:18px; border:0px solid #fff; border-radius:5px; -webkit-border-radius:5px; -moz-border-radius:5px;}\n");
    		        	sb.append("            .security_layerpopup .input_text.focus, .input_text.focusnot{background:#fff !important;}\n");
    		        	sb.append("            .security_layerpopup .btn{float:left; width:75px; height:45px; margin:0px 0px 0px 10px; padding:0px;}\n");
    		        	sb.append("            .security_layerpopup .btn_check{width:75px; height:45px; margin:0px; padding:0px;}\n");
    		        	sb.append("        </style>\n");
    		        	sb.append("        <script>\n");
    		        	sb.append("            function submitForm() {\n");
    		        	sb.append("                var f = document.secureForm;\n");
    		        	sb.append("                f.submit();\n");
    		        	sb.append("            }\n");
    		        	sb.append("        </script>\n");
    		        	sb.append("    </head>\n");
    		        	sb.append("    <body style=\"margin:0;height:100%;\">\n");
    		        	sb.append("        <div class=\"security_layerpopup\">\n");
    		        	sb.append("            <p class=\"popup_img\"><img src=\"http://" + serverName + "/images/email/secureMail/layer_img.gif\"></p>\n");
    		        	sb.append("            <p class=\"popup_txt\">해당 메일은 암호화되어있는 보안메일입니다.<br><span>메일을 열람하려면 보낸 사람이 지정한 암호를 입력해야 합니다.</span></p>\n");
    		        	sb.append("            <form name=\"secureForm\" method=\"post\" action=\"http://" + serverName + "/ezEmail/readSecureMail.do\">\n");
    		        	sb.append("                <fieldset>\n");
    		        	sb.append("                    <legend>암호입력 폼</legend>\n");
    		        	sb.append("                    <p class=\"password\"><input name=\"securePassword\" type=\"password\" id=\"TextPassword\" class=\"input_text\" onchange=\"if(this.value.length!=0){this.className=&#39;input_text focus&#39;}\"\n");
    		        	sb.append("                                           onblur=\"if (this.value.length==0) {this.className=&#39;input_text&#39;}else {this.className=&#39;input_text focusnot&#39;};\" onfocus=\"this.className=&#39;input_text focus&#39;\" /></p>\n");
    		        	sb.append("                    <p class=\"btn\"><input src=\"http://" + serverName + "/images/email/secureMail/btn.gif\" name=\"Button\" type=\"image\" id=\"Button\" tabindex=\"3\" border=\"0\" class=\"btn_check\" /></p>\n");
    		        	sb.append("                </fieldset>\n");
    		        	sb.append("                <input type=\"hidden\" name=\"secureKey\" value=\"${X-JMocha-Secure-Mail-Key}\" />\n");
    		        	sb.append("            </form>\n");
    		        	sb.append("        </div>\n");
    		        	sb.append("    </body>\n");
    		        	sb.append("</html>\n");
    		        	
    		        	// TODO: secureMailKey 암호화
    		        	String secureMailKey = userAccount + "/" + secureId;
    		        	secureAttachPart.setContent(sb.toString().replace("${X-JMocha-Secure-Mail-Key}", secureMailKey), "text/html; charset=utf-8");
    		        	secureAttachPart.setHeader("Content-Disposition", "attachment;\r\n\tfilename=\"secureMail.html\"");
    		        	secureMixedPart.addBodyPart(secureAttachPart);
    		        	// make secureAttachPart and add to secureMixedPart - end
    		        	
    		        	// make encryptedOriginalPart and add to secureMixedPart
    		        	MimeBodyPart encryptedOriginalPart = new MimeBodyPart();
    		        	
    		        	// TODO: originalFile, encryptedFile 삭제
    		        	String tempPath = realPath + commonUtil.getUploadPath("upload_mail.ROOT", tenantId) + commonUtil.separator + "tempFileUpload";
    		        	
    		        	File file = new File(tempPath);
    		        	if (!file.exists()) {
    		        		file.mkdirs();
    		        	}
    			        
    		        	File originalFile = new File(tempPath + commonUtil.separator + UUID.randomUUID().toString());
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
    		        	
    		        	encryptedFile = new File(tempPath + commonUtil.separator + UUID.randomUUID().toString());
    		        	egovFileScrty.cryptFile(Cipher.ENCRYPT_MODE, originalFile, encryptedFile);
    		        	
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
	                    
    		        	//보낸편지함에 저장
						ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
								userAccount, password, egovMessageSource, locale);
						Folder folder = ia.getFolder(egovMessageSource.getMessage("ezEmail.t99000026", locale));
						
						message.setFlag(Flags.Flag.SEEN, true);
						folder.open(Folder.READ_WRITE);
						
						AppendUID[] uids = ((IMAPFolder)folder).appendUIDMessages(new Message[]{secureMessage});
	                    long sentFolderMessageUID = 0;
	                    if (uids != null && uids[0] != null) {
	                        sentFolderMessageUID = uids[0].uid;
	                    }
	                    
						folder.close(true);
						logger.debug("Succeed in saving a message in sent folder.");
	                    
	            		// 보낸편지함에 저장한 메일의 uid를 저장한다.
		            	String result = ezEmailService.updateMailSecure(tenantId, userId, secureId, folder.getFullName() + "/" + sentFolderMessageUID);
			        	
			        	if (!result.equals("OK")) {
			        		throw new Exception("UPDATESECUREMAILFAIL");
			        	}
			            
			        	// 메일을 발송할 때에는 보낸사람의 secureMailKey를 다시 ${X-JMocha-Secure-Mail-Key}로 되돌려놓는다.
			        	secureMixedPart.removeBodyPart(secureAttachPart);
			        	secureAttachPart.setContent(sb.toString(), "text/html; charset=utf-8");
			        	secureMixedPart.addBodyPart(secureAttachPart);
			        	
			        	// 메일을 발송할 때에는 원본메일을 삭제한다.
			            secureMixedPart.removeBodyPart(encryptedOriginalPart);
			            
			            // 서버에서 보안메일을 처리할 수 있도록 헤더를 추가한다.
			            secureMessage.setHeader("X-JMocha-Secure-Mail-ID", String.valueOf(secureId));
			            
			            message = secureMessage;
	            		
					} else {
						//보낸편지함에 저장
						ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
								userAccount, password, egovMessageSource, locale);
						Folder folder = ia.getFolder(egovMessageSource.getMessage("ezEmail.t99000026", locale));
						
						if (folder.exists()) {
							message.setFlag(Flags.Flag.SEEN, true);
							folder.open(Folder.READ_WRITE);
							folder.appendMessages(new Message[]{message});
							folder.close(true);
							logger.debug("Succeed in saving a message in sent folder.");
						}
					}
					
					// 개별발신
					if (eachMailHeader != null) {
		            	logger.debug("sending each recipient mail");
		            	
		            	Address[] allRecipients = message.getAllRecipients();
		            	
		            	message.removeHeader("TO");
		        		message.removeHeader("CC");
		        		message.removeHeader("BCC");
		        		
		            	for (Address a : allRecipients) {
		            		logger.debug("address=" + a);
		            		
		            		message.setRecipient(RecipientType.TO, a);
		            		
		            		Transport.send(message);			            		
		            	}						
					} else {					
						Transport.send(message);
					}
					
			        logger.debug("Succeed in sending the reserved message.");
			        	
					//파일시스템의 eml파일 삭제
					f.delete();
					logger.debug("Succeed in deleting EML file.");
				} else {
					logger.error("Cannot find EML file.");
				}
				
				// 보안메일 관련 임시파일 삭제
				if (encryptedFile != null) {
					if (encryptedFile.delete()) {
		        		logger.debug("encryptedFile is deleted. fileName=" + encryptedFile.getName());
		        	}
				}
				
				//DB에서 메일 예약발송 정보 삭제.
				ezEmailService.deleteMailReserved(vo.getMessageId());
				logger.debug("Succeed in deleting data from DB.");
				
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				if (ia != null) {
					ia.close();
				}
				if (fis != null) {
					fis.close();
				}
			}
			
		}
		
		logger.debug("reservedMailSend scheduler ended.");
	}

    /**
     * Processes Mail Statistics Logs.
     * 매일 자정 1분 30초에 실행된다.
     */
    @Scheduled(cron = "${config.cron.processMailStatLogs}")
    public void processMailStatLogs() throws Exception {
        logger.debug("processMailStatLogs scheduler started.");
        
        //choose scheduler running server
        if (!preScheduler("processMailStatLogs")) {
            logger.debug("processMailStatLogs scheduler ended.");
            return;
        }
        
        logger.debug("processMailStatLogs scheduler elected.");
        
        // 모든 테넌트의 목록을 가져온다.
        List<TenantVO> tenantList = ezCommonService.getTenantList();
        
        // 각 테넌트별로 처리한다.
        for (TenantVO tenant : tenantList) {
            logger.debug("tenantId=" + tenant.getTenantId() + ",tenantName=" + tenant.getTenantName());
        
            String LoginMailLogKeepPeriod = ezCommonService.getTenantConfig("LoginMailLogKeepPeriod", tenant.getTenantId());
            
            int keepLogPeriodNum = 3; // Default 3개월
            
            if (!LoginMailLogKeepPeriod.equals("")) {
	            try {
	            	keepLogPeriodNum = Integer.parseInt(LoginMailLogKeepPeriod);
	            } catch (Exception e) {            	
	            	e.printStackTrace();
	            }
            }
            
            try {
	            // 보존 기간이 지난 로그인 히스토리 로그를 삭제한다.
	            ezSystemAdminService.deleteLoginHist(keepLogPeriodNum, tenant.getTenantId());
            } catch (Exception e) {           
            	e.printStackTrace();
            }
            
            // 메일 건수, 크기 등 통계 현황을 통계 테이블에 저장하는 API를 호출한다.
            // 보존 기간이 지난 메일 수발신 로그를 삭제하는 기능도 수행한다.
            String requestURL = config.getProperty("config.JGwServerURL") + "/ezEmailAccess/processMailStatLogs";
            
            String param1 = "tenantId=" + tenant.getTenantId();        
            String param2 = "keepLogPeriod=" + LoginMailLogKeepPeriod;
            String inputParams = param1 + "&" + param2;
    
            logger.debug("inputParams=" + inputParams);
            
            String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams); 
            
            logger.debug("response=" + response);       
    
            Calendar calendar = Calendar.getInstance();
            int dayOfMonth = calendar.get(Calendar.DAY_OF_MONTH);   
            
            logger.debug("dayOfMonth=" + dayOfMonth);
            
        	// 모든 사용자의 목록을 가져온다.
            List<OrganUserVO> userCnList = ezOrganAdminService.getUserCnList(tenant.getTenantId());
            
            IMAPAccess ia = null;
            Locale locale = Locale.getDefault();
            String password = jspw;
            String userId = null;
            String email = null;
            
            String yearMonth = String.format("%04d%02d", calendar.get(Calendar.YEAR), calendar.get(Calendar.MONTH) + 1);
            
            // 각 사용자별로 처리한다.
            for (OrganUserVO organUser : userCnList) {
                userId = organUser.getCn();
                logger.debug("userId=" + userId);
                
                try {
                    email = userId + "@" + ezCommonService.getTenantConfig("DomainName", tenant.getTenantId());
                    ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
                                        email, password, egovMessageSource, locale);
                            
                    long[] storageUsageAndLimit = ia.getStorageUsageAndLimit();
                    
                    // 사용자의 현재 메일박스 스토리지 사용량과 쿼터(최대 할당량)을 구한다.
                    long mailboxUsage = storageUsageAndLimit[0]; // in KBs
                    long mailboxQuota = storageUsageAndLimit[1]; // in KBs
                    
                    logger.debug("email=" + email + ",mailboxUsage=" + mailboxUsage + ",mailboxQuota=" + mailboxQuota);     
                    
                    // 메일박스 쿼터와 사용량을 통계 테이블에 저장하는 Web Service API를 호출한다.
                    requestURL = config.getProperty("config.JGwServerURL") + "/ezEmailAccess/setMailboxUsageLog";
                    
                    String tenantIdParam = "tenantId=" + tenant.getTenantId();
                    String userIdParam = "userId=" + URLEncoder.encode(userId, "UTF-8");
                    String usageParam = "usage=" + mailboxUsage*1024;
                    String quotaParam = "quota=" + mailboxQuota*1024;
                    String yearMonthParam = "yearMonth=" + yearMonth;
                    
                    inputParams = tenantIdParam + "&" + userIdParam + "&" + usageParam + "&" + quotaParam + "&" + yearMonthParam;

                    logger.debug("inputParams=" + inputParams);
                    
                    response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
                    
                    logger.debug("response=" + response);                           
                } catch (Exception e) {
                    logger.debug(e.getMessage());
                    e.printStackTrace();
                } finally {
                    if (ia != null) {
                        ia.close();
                    }
                }
            }
        }
        
        logger.debug("processMailStatLogs scheduler ended.");
    }
	
	/**
	 * delete garbage files
	 */
	@Scheduled(cron = "${config.cron.dailyFileManage}")
	public void dailyFileManage() throws Exception{
		logger.debug("dailyFileManage scheduler started.");
		
		//choose scheduler running server
		if (!preScheduler("dailyFileManage")) {
			logger.debug("dailyFileManage scheduler ended.");
			return;
		}
		
		//get tenantIdList
		List<TenantVO> tenantList = ezCommonService.getTenantList();
		
		String realPath = config.getProperty("data_root");
		
		//delete expired big-attachment files
		deleteExpireAttach(tenantList, realPath);
		
		//set directory
		//TODO: set upload_common directory
		List<String> directoryList = new ArrayList<String>();
		for (TenantVO tenantVO : tenantList) {
			directoryList.add(commonUtil.getUploadPath("upload_mail.ROOT", tenantVO.getTenantId()) + commonUtil.separator + "tempFileUpload");
			directoryList.add(commonUtil.getUploadPath("upload_mail.ROOT", tenantVO.getTenantId()) + commonUtil.separator + "templist");
			directoryList.add(commonUtil.getUploadPath("upload_common.MHTIMAGE", tenantVO.getTenantId()));
		}
		
		int dayLimit = 2;
		long nowTime = new Date().getTime();
		
		//delete garbage files from directoryList
		for (String directory : directoryList) {
			File file = new File(realPath + directory);
			logger.debug("path=" + realPath + directory);
			if (file.exists()) {
				File[] files = file.listFiles();
				
				for (File f : files) {
					logger.debug("f.getName()=" + f.getName());
					logger.debug("nowTime=" + nowTime);
					logger.debug("f.lastModified()=" + f.lastModified());
					
					if (nowTime - f.lastModified() > dayLimit * 24 * 60 * 60 * 1000) {
						if (deleteDirectory(f)) {
							logger.debug(f.getName() + " is deleted.");
						}
					}
					
				}
			}
		}
		
		logger.debug("dailyFileManage scheduler ended.");
	}
	
	/**
	 * 만료된 대용량 메일 첨부폴더 삭제 함수
	 */
	private void deleteExpireAttach(List<TenantVO> tenantList, String realPath) throws Exception{
		logger.debug("deleteExpireAttach started.");
		
		for (TenantVO tenantVO : tenantList) {
			logger.debug("tenantId=" + tenantVO.getTenantId());
			
			String pUploadPath = commonUtil.getUploadPath("upload_mail.ROOT", tenantVO.getTenantId());
		
			File file = new File(realPath + pUploadPath);
			logger.debug("path=" + realPath + pUploadPath);
			
			String bigSizeMailAttachDelDayStr = ezCommonService.getTenantConfig("BigSizeMailAttachDelDay", tenantVO.getTenantId());
			int bigSizeMailAttachDelDay = Integer.parseInt(bigSizeMailAttachDelDayStr);
			
			if (file.exists()) {
				File[] files = file.listFiles(new deleteExpireAttachFilter(bigSizeMailAttachDelDay));
				
				for (File expiredFile : files) {
					logger.debug("expired directory name=" + expiredFile.getName());
					if (deleteDirectory(expiredFile)) {
						logger.debug(expiredFile.getName() + " is deleted.");
					}
				}
			}
		}
		
		logger.debug("deleteExpireAttach ended.");
	}
	
	public boolean preScheduler(String scheduler) {
		logger.debug("preScheduler started.");
		
		boolean isSchedulerServer = false;
		
		if (config.getProperty("config.Run_Scheduler").equals("YES")) {
			logger.debug("Elect scheduler server.");
			try {
				//set SchedulerServer
				String server = config.getProperty("config.SchedulerServer");
				
				String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaAccess/setSchedulerServer";
				
				String schedulerParam = "scheduler=" + URLEncoder.encode(scheduler, "UTF-8");
				String serverParam = "server=" + URLEncoder.encode(server, "UTF-8");
				
				String inputParams = schedulerParam + "&" + serverParam;
				logger.debug("inputParams=" + inputParams);
				
				String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);		
				logger.debug("response=" + response);
				
				//sleep 20 seconds
				logger.debug(scheduler + " is sleeping...");
				Thread.sleep(20000);
				
				//get SchedulerServer
				requestURL = config.getProperty("config.JGwServerURL") + "/jMochaAccess/getSchedulerServer";
				
				inputParams = schedulerParam;
				logger.debug("inputParams=" + inputParams);
				
				response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
				logger.debug("response=" + response);
				
				JSONParser parser = new JSONParser();
				JSONObject object = (JSONObject)parser.parse(response);
		        
		        if (object.get("resultCode").equals("OK") && ((Long)object.get("reasonCode")).intValue() == 0) {
		        	String schedulerServer = (String)object.get("result");
		        	
		        	if (schedulerServer.equals(server)) {
		        		isSchedulerServer = true;
		        		logger.debug("This is elected as a scheduler server.");
		        	} else {
		        		logger.debug("This is not elected.");
		        	}
		        } else {
		        	logger.error("Cannot get SchedulerServer.");
		        }
				
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else {
			logger.debug("config.Run_Scheduler property is not YES.");
		}
		
		logger.debug("preScheduler ended.");
		
		return isSchedulerServer;
	}
	
	class deleteExpireAttachFilter implements FilenameFilter {
		private int bigSizeMailAttachDelDay;
		private String today;
		
		public deleteExpireAttachFilter(int bigSizeMailAttachDelDay) {
			super();
			
			this.bigSizeMailAttachDelDay = bigSizeMailAttachDelDay;
			this.today = EgovDateUtil.getToday("");
		}
		
		@Override
		public boolean accept(File dir, String name) {
			if (name != null && dir.isDirectory()) {
				if (NumberUtils.isNumber(name)) {
					return EgovDateUtil.getDaysDiff(name, today) > bigSizeMailAttachDelDay;
				}
			}
			return false;
		}
	}
}
