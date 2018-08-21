package egovframework.ezEKP.ezEmail.task;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FilenameFilter;
import java.io.IOException;
import java.net.URLEncoder;
import java.security.PrivateKey;
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
import javax.mail.Message.RecipientType;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
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
import org.json.simple.JSONArray;
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
import egovframework.ezEKP.ezEmail.util.EmailImportance;
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
	 * 관리자 - 자동삭제 
	 */
	@Scheduled(cron = "${config.cron.deleteAllUserOldMail}")
	public void deleteAllUserMail() throws Exception {
		logger.debug("deleteAllUserOldMail scheduler started.");
		
		if (!preScheduler("deleteAllUserOldMail")) {
			logger.debug("deleteAllUserOldMail scheduler ended.");
			return;
		}
		
		try {
			int tenantId = 0;
					
			String useAllUserOldMailDelete = ezCommonService.getTenantConfig("useAllUserOldMailDelete", tenantId);
			String useAllUserOldMailDeletePeriod = ezCommonService.getTenantConfig("useAllUserOldMailDeletePeriod", tenantId);
			
			if (useAllUserOldMailDelete.equals("YES") && !useAllUserOldMailDeletePeriod.equals("0")) {
				
				String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzEmail/deleteAllUserOldMail";
				String param = "period=" + useAllUserOldMailDeletePeriod;
				
				String inputParams = param;
				logger.debug("inputParams=" + inputParams);
				
				String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
				logger.debug("response=" + response);
				
				JSONParser parser = new JSONParser();
				JSONObject object = (JSONObject) parser.parse(response);
				
				if (!object.get("resultCode").equals("OK")) {
					logger.debug("Cannot delete AllUserOldMail.");
				}
				
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		logger.debug("deleteAllUserMail scheduler ended.");
	}
	
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
						userEmail, password, egovMessageSource, locale, ezEmailUtil);
				Folder f = ia.getFolder(path);

				if (f != null && f.exists()) {
					f.open(Folder.READ_WRITE);

					Calendar cal = Calendar.getInstance();
					cal.setTime(new Date());
					cal.add(Calendar.DATE, expireTime * -1);
					SearchTerm searchTerm = new ReceivedDateTerm(ComparisonTerm.LT, cal.getTime());

					if (deleteUnread.equals("0")) {
						searchTerm = new AndTerm(searchTerm, new FlagTerm(new Flags(Flags.Flag.SEEN), true));
					}

					Message[] messages = f.search(searchTerm);

					logger.debug("messages length=" + messages.length);
					
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
			File f = null;
			File encryptedFile = null; // 보안메일 관련 파일 변수
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
	
				f = new File(pDirPath + commonUtil.separator + vo.getMessageId() + ".eml");
				logger.debug("filePath=" + pDirPath + commonUtil.separator + vo.getMessageId() + ".eml");
				
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
					
					String useSecureMail = ezCommonService.getTenantConfig("USE_SECUREMAIL", tenantId);
			        logger.debug("useSecureMail=" + useSecureMail);
					
					String[] secureMailHeaders = message.getHeader("X-JMocha-Secure-Mail");
					String secureMailHeader = secureMailHeaders != null ? secureMailHeaders[0] : null;		
					
					// 보안메일 처리
					if (useSecureMail.equals("YES") && secureMailHeader != null && secureMailHeader.equals("true")) {
						
						// get Info from secureMail header
						secureMailHeader = MimeUtility.decodeText(secureMailHeader);
						String securePassword = message.getHeader("X-JMocha-Secure-Mail-Password")[0];
						String secureReadCount = message.getHeader("X-JMocha-Secure-Mail-ReadCount")[0];
						String secureReadDate = message.getHeader("X-JMocha-Secure-Mail-ReadDate")[0];
						String serverName = message.getHeader("X-JMocha-Secure-Mail-ServerName")[0];
						
						// 암호화되어있는 securePassword 복호화
		    			String prm = egovFileScrty.getPrm();
		            	String pre = egovFileScrty.getPre();
		            	PrivateKey pk = EgovFileScrty.getPrivateKey(prm, pre);
		            	securePassword = EgovFileScrty.decryptRsa(pk, securePassword);
						
						logger.debug("securePassword=" + securePassword + ",secureReadCount=" + secureReadCount
								+ ",secureReadDate=" + secureReadDate + ",serverName=" + serverName);
						
						// remove header
						message.removeHeader("X-JMocha-Secure-Mail-Password");
						message.removeHeader("X-JMocha-Secure-Mail-ReadCount");
						message.removeHeader("X-JMocha-Secure-Mail-ReadDate");
						message.removeHeader("X-JMocha-Secure-Mail-ServerName");
						message.removeHeader("X-JMocha-Secure-Mail");
						
						// timezone 처리 확인
						if (!secureReadDate.equals("")) {
							SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
							secureReadDate = sdf.format(new Date(Long.parseLong(secureReadDate)));
							secureReadDate = commonUtil.getDateStringInUTC(secureReadDate, offset, true);
						}
						
						// securePassword 암호화
	            		securePassword = egovFileScrty.encryptAES(securePassword);
						
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
    		        	
    		        	String useHttps = ezCommonService.getTenantConfig("USE_HTTPS", tenantId);
    		        	logger.debug("useHttps=" + useHttps);
    		        	
    		        	String secureAttachHtml = ezEmailUtil.getSecureAttachHtml(serverName, locale, useHttps);
    		        	
    		        	String secureMailKey = userAccount + "/" + secureId + "/" + userAccount;
    		        	secureMailKey = egovFileScrty.encryptAES(secureMailKey);
    		        	
    		        	secureAttachPart.setContent(secureAttachHtml.replace("${X-JMocha-Secure-Mail-Key}", secureMailKey), "text/html; charset=utf-8");
    		        	secureAttachPart.setHeader("Content-Disposition", "attachment;\r\n\tfilename=\"secureMail.html\"");
    		        	secureMixedPart.addBodyPart(secureAttachPart);
    		        	// make secureAttachPart and add to secureMixedPart - end
    		        	
    		        	// make encryptedOriginalPart and add to secureMixedPart
    		        	MimeBodyPart encryptedOriginalPart = new MimeBodyPart();
    		        	
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
								userAccount, password, egovMessageSource, locale, ezEmailUtil);
						Folder folder = ia.getFolder(ezEmailUtil.getSentFolderId(locale));
						
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
			        	secureAttachPart.setContent(secureAttachHtml, "text/html; charset=utf-8");
			        	secureMixedPart.addBodyPart(secureAttachPart);
			        	
			        	// 메일을 발송할 때에는 원본메일을 삭제한다.
			            secureMixedPart.removeBodyPart(encryptedOriginalPart);
			            
			            // 서버에서 보안메일을 처리할 수 있도록 헤더를 추가한다.
			            secureMessage.setHeader("X-JMocha-Secure-Mail-ID", String.valueOf(secureId));
			            
			            message = secureMessage;
	            		
			            fis.close();
				        fis = null;
			            
					} else {
						//보낸편지함에 저장
						ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
								userAccount, password, egovMessageSource, locale, ezEmailUtil);
						Folder folder = ia.getFolder(ezEmailUtil.getSentFolderId(locale));
						
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
					if (f.delete()) {
						logger.debug("Succeed in deleting EML file.");
					}
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
				String errorMessage = e.getMessage();
				
				//유효하지 않은 사용자일 경우, eml 파일 및  예약 발송 정보(DB) 삭제
				if (errorMessage.contains("Invalid Addresses")
						|| errorMessage.contains("No recipient addresses")) {					
					//파일시스템의 eml파일 삭제
					if (f != null && f.delete()) {
						logger.debug("Succeed in deleting EML file.");
					}
					
					// 보안메일 관련 임시파일 삭제
					if (encryptedFile != null && encryptedFile.delete()) {
		        		logger.debug("encryptedFile is deleted. fileName=" + encryptedFile.getName());
					}
					
					//DB에서 메일 예약발송 정보 삭제.
					ezEmailService.deleteMailReserved(vo.getMessageId());
				}
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
                                        email, password, egovMessageSource, locale, ezEmailUtil);
                            
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
	 * @since 2018.03.06
	 * @author jwseo99
	 * 
	 * 편지함 용량 경고 메일 자동 발송
	 * */
	@Scheduled(cron = "${config.cron.broadcastQuotaWarning}")
	public void broadcastQuotaWarning() throws Exception {
		logger.debug("broadcastQuotaWarning started.");
		
		List<String> emailArray = new ArrayList<>();
		
		try {
			// get all rows from jmocha_storage_warning_sent table
			String requestURI = config.getProperty("config.JGwServerURL") + "/jMochaAccess/getEmailForStorageWarningSent";
			String resultJsonStr = ezEmailUtil.getWebServiceResult(requestURI, null);
			
			// result json parsing
			JSONParser jsonParser = new JSONParser();
			JSONObject jsonObject;
			
			jsonObject = (JSONObject) jsonParser.parse(resultJsonStr);
			JSONArray emailJsonArray = (JSONArray) jsonObject.get("data");
			
			// JSONArray to ArrayList<String>
			for (Object emailObject : emailJsonArray) {
				String emailAddress = emailObject.toString();
				emailArray.add(emailAddress);
			}			
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		
		// using system locale
		Locale locale = Locale.getDefault();
		// mail access info
		String mailServerAddress = config.getProperty("config.MailServerAddress");
		String imapPort = config.getProperty("config.IMAPPort");
		
		// message info
		InternetAddress from = new InternetAddress("postmaster@localhost");		
		String fontFamily = egovMessageSource.getMessage("ezEmail.sjw01", locale);
		String subject = egovMessageSource.getMessage("ezEmail.sjw02", locale);
		String suggestion = egovMessageSource.getMessage("ezEmail.sjw03", locale);
		
		String fontStyle = String.format("style='font-family: %s; font-size: %spx;'", fontFamily, 13);
		
		// process mailQuota
		for (String userEmail : emailArray) {
			
			try {
				// user quota info
				Double[] userQuotaData = ezEmailUtil.getUserQuota(userEmail);
				
				if (userQuotaData[0] == null) {
					String domainName = userEmail.substring(userEmail.indexOf("@") + 1, userEmail.length());
					userQuotaData = ezEmailUtil.getDefaultQuota(domainName);
				}
				
				IMAPAccess imapAccess = IMAPAccess.getInstance(mailServerAddress, imapPort, userEmail, jspw, egovMessageSource, 
														locale, ezEmailUtil);
				
				// KB
				long mailboxUsage = imapAccess.getStorageUsageAndLimit()[0];
				long mailboxQuota = imapAccess.getStorageUsageAndLimit()[1];
				// MB to KB
				double mailboxWarning = userQuotaData[1] * 1024;
				
				logger.debug("============");
				logger.debug(String.format("user: %s", userEmail));
				logger.debug(String.format("quota max: %s", mailboxQuota));
				logger.debug(String.format("quota used: %s", mailboxUsage));
				logger.debug(String.format("quota warning: %s", mailboxWarning));
				
				// 메일함 용량이 경고 발생 용량보다 작으면 continue
				if (mailboxUsage < mailboxWarning) {
					logger.debug("============");
					continue;
				}
				
				int progressWidth = 200;
				
				int usedPercent = (int) ((progressWidth / (float) mailboxQuota) * mailboxUsage);
	            int unusedPercent = progressWidth - usedPercent;
				
	            logger.debug(String.format("used percent: %s", usedPercent));
	            logger.debug(String.format("unused percent: %s", unusedPercent));
	            logger.debug("============");
	            
	            // content
	            StringBuilder content = new StringBuilder();
	            content.append(String.format("<span %s>%s</span><br/><br/>", fontStyle, subject));
	            content.append("<table cellspacing='0;'>")
	            	.append("	<tbody>")
	            	.append("		<tr>")
	            	.append("			<td style='background-color:#FFCC00;width:" + usedPercent + "px;border-left-style:solid;border-top-style:solid;border-bottom-style:solid;border-color:black;border-width:1'><font color='#000000' size='2' face='Tahoma'>" + humanReadableByteCount(mailboxUsage * 1024) + "</font></td>")
	            	.append("			<td style='background-color:#ffffff;width:" + unusedPercent + "px;border-right-style:solid;border-top-style:solid;border-bottom-style:solid;border-color:black;border-width:1'>&nbsp;</td>")
	            	.append("			<td><span " + fontStyle + "><b>" + humanReadableByteCount(mailboxQuota * 1024) + "</b></span></td>")
	            	.append("		</tr>")
	            	.append("	</tbody>")
	            	.append("</table>");
	            content.append(String.format("<br/><span %s>%s</span><br/>", fontStyle, suggestion));
				
	            // send mail
				ezEmailService.sendMail(userEmail, jspw, null, from, new InternetAddress[]{ new InternetAddress(userEmail) }, null, null, subject, content.toString(), false, EmailImportance.HIGH);
			} catch (Exception ex) {
				ex.printStackTrace();
			}
			
		}
		
		logger.debug("broadcastQuotaWarning end.");
	}
	
	/**
	 * org.apache.james.transport.mailets.JMochaQuotaWarning humanReadableByteCount(long bytes) 복사
	 * 
	 * @since 2018.03.06
	 * @author jwseo99
	 * 
	 * @param bytes
	 *            계산 대상 바이트
	 * @return 100,000 -> 97.6 KB<br>
	 *         5,242,880 -> 5 MB
	 * */
	private String humanReadableByteCount(long bytes) {
		int unit = 1024;
		
		if (bytes < unit) {
			return bytes + " B";
		}
		
		int exp = (int) (Math.log(bytes) / Math.log(unit));
		String pre = ("KMGTPE").charAt(exp - 1) + "";
		
		return String.format("%.1f %sB", bytes / Math.pow(unit, exp), pre);
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
				File[] files = file.listFiles(new DeleteExpireAttachFilter(bigSizeMailAttachDelDay));
				
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
	
	class DeleteExpireAttachFilter implements FilenameFilter {
		private int bigSizeMailAttachDelDay;
		private String today;
		
		public DeleteExpireAttachFilter(int bigSizeMailAttachDelDay) {
			super();
			
			this.bigSizeMailAttachDelDay = bigSizeMailAttachDelDay;
			this.today = EgovDateUtil.getToday("");
		}
		
		@Override
		public boolean accept(File dir, String name) {
			if (name != null && dir.isDirectory()) {
				if (NumberUtils.isNumber(name)) {
					return EgovDateUtil.getDaysDiff(name, today) >= bigSizeMailAttachDelDay;
				}
			}
			return false;
		}
	}
}
