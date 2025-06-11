package egovframework.ezEKP.ezEmail.task;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
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
import java.util.TimeZone;
import java.util.UUID;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.activation.DataHandler;
import javax.activation.FileDataSource;
import javax.annotation.Resource;
import javax.crypto.Cipher;
import javax.mail.*;
import javax.mail.Message.RecipientType;
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
import javax.servlet.ServletContext;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.math.NumberUtils;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.sun.mail.imap.AppendUID;
import com.sun.mail.imap.IMAPFolder;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.dao.EzEmailDAO;
import egovframework.ezEKP.ezEmail.logic.IMAPAccess;
import egovframework.ezEKP.ezEmail.logic.SMTPAccess;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezEmail.util.EmailImportance;
import egovframework.ezEKP.ezEmail.util.EzEmailUtil;
import egovframework.ezEKP.ezEmail.vo.MailBlobVO;
import egovframework.ezEKP.ezEmail.vo.MailDeleteVO;
import egovframework.ezEKP.ezEmail.vo.MailDeletedIdVO;
import egovframework.ezEKP.ezEmail.vo.MailDistributionVO;
import egovframework.ezEKP.ezEmail.vo.MailReservationVO;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.ezEKP.ezSystem.service.EzSystemAdminService;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.TenantVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;
import egovframework.let.utl.fcc.service.EgovStringUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

@Component
public class EzEmailScheduler extends EgovFileMngUtil {

	private static final Logger logger = LoggerFactory.getLogger(EzEmailScheduler.class);

	@Autowired
	private Properties config;

	@Autowired
	private ServletContext servletContext;
		
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource; 

	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private EzEmailService ezEmailService;
	
	@Autowired
	private EzEmailDAO ezEmailDAO;
	
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
	
	@Scheduled(cron = "${config.cron.mailboxQuotaListUpdate}")
	public void mailboxQuotaListUpdate() throws Exception {
		logger.debug("mailboxQuotaListUpdate scheduler started.");

		String useExternalMailServer = ezCommonService.getTenantConfig("useExternalMailServer", 0);
		if (useExternalMailServer != null && useExternalMailServer.equalsIgnoreCase("YES")) {
			logger.debug("mailboxQuotaListUpdate scheduler ended.");
			return;
		}

		if (!preScheduler("mailboxQuotaListUpdate")) {
			logger.debug("mailboxQuotaListUpdate scheduler ended.");
			return;
		}

		String email = null;
		IMAPAccess ia = null;
		Locale locale = Locale.getDefault();
		String password = jspw;
		String mailServerAddress = config.getProperty("config.MailServerAddress");
		String iMAPPort = config.getProperty("config.IMAPPort");
		List<TenantVO> tenantList = ezCommonService.getTenantList();

		for (TenantVO tenant : tenantList) {
			int tenantID = tenant.getTenantId();
			String domain = ezCommonService.getTenantConfig("DomainName", tenantID);
			List<OrganUserVO> vo = ezOrganAdminService.getAllUserCnList(tenantID);

			for (OrganUserVO user : vo) {

				try {
					String cn = user.getCn();
					email = cn + "@" + domain;
					ia = IMAPAccess.getInstance(mailServerAddress, iMAPPort, email, password, egovMessageSource, locale, ezEmailUtil);

                    if (ia != null){
                        long[] storageUsageAndLimit = ia.getStorageUsageAndLimit();

                        long mailboxUsage = storageUsageAndLimit[0];
                        long mailboxQuota = storageUsageAndLimit[1];

                        ezOrganAdminService.updateProperty(cn, "mailboxusage", String.valueOf(mailboxUsage), "user", tenantID);
                        ezOrganAdminService.updateProperty(cn, "mailboxquota", String.valueOf(mailboxQuota), "user", tenantID);
                    }
                } catch (DataAccessException e) {
                    logger.debug("error. user=" + email);
                    logger.error(e.getMessage(), e);
                } catch (Exception e) {
                    logger.debug("error. user=" + email);
                    logger.error(e.getMessage(), e);
                } finally {
                    if (ia != null) {
                        ia.close();
                    }
                }
            }
        }
        logger.debug("mailboxQuotaListUpdate scheduler ended.");
    }

	/**
	 * 관리자 - 자동삭제 
	 */
	@SuppressWarnings("unchecked")
	@Scheduled(cron = "${config.cron.deleteAllUserOldMail}")
	public void deleteAllUserMail() throws Exception {
		logger.debug("deleteAllUserOldMail scheduler started.");
		
		String useExternalMailServer = ezCommonService.getTenantConfig("useExternalMailServer", 0);
		if(useExternalMailServer != null && useExternalMailServer.equalsIgnoreCase("YES")) {
			logger.debug("deleteAllUserOldMail scheduler ended.");
			return;
		}
		
		if (!preScheduler("deleteAllUserOldMail")) {
			logger.debug("deleteAllUserOldMail scheduler ended.");
			return;
		}
		
		IMAPAccess ia = null;

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
				} else {
					// 유저리스트 받아서! 유저 폴더 1개 만들고 다시 삭제 해서 쿼터 재계산 하도록 구성.
					List<String> userList = new ArrayList<>();
					userList = (List<String>) object.get("userList");
					logger.debug("userList size=" + userList.size() + ", userList=" + userList.toString());
					
					Locale locale = null;
					String returnValue = "OK";
					
					if (userList.size() > 0) {
						for (String userEmail : userList) {
							// imap 접근 
							ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"), 
									userEmail, "_jmocha_101", egovMessageSource, locale, ezEmailUtil);
                            String folderPath = "";
                            if (ia != null){
                                folderPath = ia.getFolder("INBOX").getFolder("443c2406b761402a").getFullName();
                            }
                            int result = ia.createFolder(folderPath);

                            if (result == 0) {
                                result = ia.deleteFolder(folderPath);
                                logger.debug("user=" + userEmail + " temp mailbox create and delete success. result=" + result);

                                if (result != 0) {
                                    logger.debug("temp mailbox delete error. result=" + result);
                                    returnValue = "ERROR";
                                }

                            } else if (result == 2) {
                                returnValue = "ALREADY_EXISTS";
                                logger.debug("temp mailbox create error. result=" + result);
                            }

                            logger.debug("returnValue=" + returnValue);
                        }
                    }
                }
            }
        } catch (ParseException e) {
            logger.error(e.getMessage(), e);
        } catch (Exception e) {
            logger.error(e.getMessage(), e);
        } finally {
            if (ia != null) {
                ia.close();
            }
        }

        logger.debug("deleteAllUserMail scheduler ended.");
    }

    /**
     * james_mail_blob 삭제로 변경
     * @throws Exception
     */
	@Scheduled(fixedDelay = 600000, initialDelay = 60000)
	public void deleteMailBlob() throws Exception {
		logger.debug("deleteMailBlob started.");
		
		String useDeleteMailBlob = ezCommonService.getTenantConfig("useDeleteMailBlob", 0);
		if(useDeleteMailBlob != null && useDeleteMailBlob.equalsIgnoreCase("NO")) {
			logger.debug("deleteMailBlob ended.");
			return;
		}
				
		//choose scheduler running server
		if (!preScheduler("deleteMailBlob")) {
			logger.debug("deleteMailBlob ended.");
			return;
		}
				
		int count = 0;
		
		String useMailDeletedId = ezCommonService.getTenantConfig("useMailDeletedId", 0);
		
		Calendar now = Calendar.getInstance();
		int hour = now.get(Calendar.HOUR_OF_DAY);
		int minute = now.get(Calendar.MINUTE);
		
		// 오전 3시에는 james_mail 테이블과 james_mail_blob 테이블을 outer join하여 삭제할 blob 목록을 구한다.
		if (!useMailDeletedId.equals("YES") || (hour == 3 && minute < 10)) {
			List<MailBlobVO> orphanedMailBlobList = ezEmailService.getOrphanedMailBlobList();
			
			logger.debug("orphanedMailBlobList count=" + orphanedMailBlobList.size());
									
			for (MailBlobVO mailBlobVO : orphanedMailBlobList) {
				if (++count % 120 == 1) {
					logger.debug("Deleting mailBlobId=" + mailBlobVO.getMailBlobId() + ",count=" + count);
				}
				
				// 레코드가 하나씩 삭제될 때마다 즉시 반영되도록 하기 위해 Service Layer를 거치지 않고 직접 DAO에 접근하도록 함.
				long sleepTime = ezEmailDAO.deleteOrphanedMailBlob(mailBlobVO);
								
				Thread.sleep(sleepTime);
			}
		// 그 외에는 james_mail_deleted_id 테이블에 있는 목록을 기초로 삭제할 blob 목록을 구한다.
		} else {
			List<MailDeletedIdVO> mailDeletedIdList = ezEmailService.getMailDeletedIdList();
			
			logger.debug("mailDeletedIdList count=" + mailDeletedIdList.size());
									
			for (MailDeletedIdVO mailDeletedIdVO : mailDeletedIdList) {
				if (++count % 120 == 1) {
					logger.debug("Deleting mailBoxId=" + mailDeletedIdVO.getMailBoxId() + ",mailUid=" + mailDeletedIdVO.getMailUid() + ",count=" + count);
				}
				
				// 레코드가 하나씩 삭제될 때마다 즉시 반영되도록 하기 위해 Service Layer를 거치지 않고 직접 DAO에 접근하도록 함.
				ezEmailDAO.deleteMailBlobWithDeletedId(mailDeletedIdVO);
				ezEmailDAO.deleteMailDeletedId(mailDeletedIdVO);
			}				
		}
		
		logger.debug("deleteMailBlob ended. count=" + count);
	}
		
	/**
	 * 환경설정 - 자동삭제 스케줄러
	 */
	@Scheduled(cron = "${config.cron.autoDelete}")
	public void autoDelete() throws Exception{
		logger.debug("autoDelete scheduler started.");
		
		String useExternalMailServer = ezCommonService.getTenantConfig("useExternalMailServer", 0);
		if(useExternalMailServer != null && useExternalMailServer.equalsIgnoreCase("YES")) {
			logger.debug("autoDelete scheduler ended.");
			return;
		}
		
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
                Folder f = ia.getFolder(path != null ? path : "");

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
            } catch (MessagingException e) {
                logger.error(e.getMessage(), e);
			} catch (Exception e) {
				logger.error(e.getMessage(), e);
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
		
		String useExternalMailServer = ezCommonService.getTenantConfig("useExternalMailServer", 0);
		if(useExternalMailServer != null && useExternalMailServer.equalsIgnoreCase("YES")) {
			logger.debug("reservedMailSend scheduler ended.");
			return;
		}
		
		//choose scheduler running server
		if (!preScheduler("reservedMailSend")) {
			logger.debug("reservedMailSend scheduler ended.");
			return;
		}
		
		List<MailReservationVO> list = ezEmailService.getMailReserved2();
		List<String> invalidAddressList = new ArrayList<>();
		boolean retryFlag = false;
		
		for (int i = 0; i < list.size(); i++) {
			IMAPAccess ia = null;
			FileInputStream fis = null;
			File f = null;
			File encryptedFile = null; // 보안메일 관련 파일 변수
			MimeMessage message = null;
			Locale locale = null;
			String offset = null;

			MailReservationVO vo = list.get(i);
			String messageId = vo.getMessageId();
			String userAccount = vo.getConnUrl();
			String userId = vo.getSender();

			String[] emailArr = userAccount.split("@");
			String mailId = emailArr[0];
			String domainName = emailArr[1];
			userId = StringUtils.isBlank(userId)? mailId : userId;
			logger.debug("messageId={}, userAccount={}, userId(sender)={}, mailId={}", messageId, userAccount, userId, mailId);

			try {
				
				String password = jspw;
	
				String realPath = commonUtil.getRealPath(servletContext);
				
				int tenantId = ezCommonService.getTenantIdByDomainName(domainName);
				String lang = ezCommonService.selectUserGetLang(userId, tenantId);
				locale = new Locale(commonUtil.getTwoLetterLangFromLangNum(lang));
				offset = ezCommonService.selectUserGetTimeZone(userId, tenantId);
				String sentMailStoredInSentBox = config.getProperty("SentMailStoredInSentbox", "YES");
				logger.debug("locale=" + locale + ",offset=" + offset + ",sentMailStoredInSentBox=" + sentMailStoredInSentBox);
				
				String pDirPath = commonUtil.getUploadPath("upload_mail.RESERVED_MAIL_PATH", tenantId);
				pDirPath = realPath + pDirPath;
	
				f = new File(pDirPath + commonUtil.separator + messageId + ".eml");
				logger.debug("filePath=" + pDirPath + commonUtil.separator + messageId + ".eml");
								
				if (f.exists()) {
					fis = new FileInputStream(f);
	
					SMTPAccess sa = SMTPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.SMTPPort"),
							userAccount, password);
	
					message = sa.readMimeMessage(fis);
					
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
						String securePasswordHint = message.getHeader("X-JMocha-Secure-Mail-PasswordHint")[0];
						
						// 암호화되어있는 securePassword 복호화
		    			String prm = egovFileScrty.getPrm();
		            	String pre = egovFileScrty.getPre();
		            	PrivateKey pk = EgovFileScrty.getPrivateKey(prm, pre);
		            	securePassword = EgovFileScrty.decryptRsa(pk, securePassword);

                        boolean useKlibEncrypt = "YES".equalsIgnoreCase(config.getProperty("config.useKlibEncrypt"));
                        
                        logger.debug("securePassword=" + securePassword + ",secureReadCount=" + secureReadCount
                                + ",secureReadDate=" + secureReadDate + ",serverName=" + serverName + ",useKlibEncrypt=" + useKlibEncrypt);

                        // remove header
                        message.removeHeader("X-JMocha-Secure-Mail-Password");
                        message.removeHeader("X-JMocha-Secure-Mail-ReadCount");
                        message.removeHeader("X-JMocha-Secure-Mail-ReadDate");
                        message.removeHeader("X-JMocha-Secure-Mail-ServerName");
                        message.removeHeader("X-JMocha-Secure-Mail-PasswordHint");

                        // timezone 처리 확인
                        if (!secureReadDate.equals("")) {
                            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                            secureReadDate = sdf.format(new Date(Long.parseLong(secureReadDate)));
                            secureReadDate = commonUtil.getDateStringInUTC(secureReadDate, offset, true);
                        }

                        // securePassword 암호화
                        securePassword = ezEmailService.encryptSecureValue(securePassword, useKlibEncrypt);

                        // save secure mail info and get secureId
                        int secureId = ezEmailService.setMailSecure(tenantId, mailId, securePassword, Integer.parseInt(secureReadCount), secureReadDate);

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
                        secureMailKey = ezEmailService.encryptSecureValue(secureMailKey, useKlibEncrypt);

                        secureAttachHtml = secureAttachHtml.replace("${X-JMocha-Secure-Mail-Key}", secureMailKey);
                        secureAttachHtml = secureAttachHtml.replace("${passwordHint}", securePasswordHint);

						secureAttachPart.setContent(secureAttachHtml, "text/html; charset=utf-8");
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
                        } catch (FileNotFoundException e) {
                            logger.error(e.getMessage(), e);
    		        	} catch (Exception e) {
    		        		logger.error(e.getMessage(), e);
    		        	} finally {
                            if (fos != null) {
                                try {
                                    fos.close();
                                } catch (IOException e) {
                                    logger.debug("e.message=" + e.getMessage());
                                }
                            }
    					}
    		        	
    		        	encryptedFile = new File(tempPath + commonUtil.separator + UUID.randomUUID().toString());
						
						if (!useKlibEncrypt) {
							egovFileScrty.cryptFile(Cipher.ENCRYPT_MODE, originalFile, encryptedFile);
						} else {
							byte[] bytes = commonUtil.readBytesFromFile(originalFile.toPath());
							commonUtil.writeBytesToFile(encryptedFile.toPath(),klibUtil.encrypt(bytes));
						}
    		        	
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
		            	String result = ezEmailService.updateMailSecure(tenantId, mailId, secureId, folder.getFullName() + "/" + sentFolderMessageUID);
			        	
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
						if (!retryFlag && sentMailStoredInSentBox.equalsIgnoreCase("YES")) {
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
					}
					
					// 개별발신
					if (eachMailHeader != null) {
		            	logger.debug("sending each recipient mail");
		            	
		            	Address[] allRecipients = message.getAllRecipients();
		            	
		            	message.removeHeader("TO");
		        		message.removeHeader("CC");
		        		message.removeHeader("BCC");
		        		
		        		invalidAddressList.clear();
		        		
		        		String useAdvancedEachMail = ezCommonService.getTenantConfig("useAdvancedEachMail", tenantId);
		        		if (useAdvancedEachMail.equals("YES")) {		
		        			try {
		        				message.setRecipients(RecipientType.TO, allRecipients);
		        				
		        				message.setHeader("X-JMocha-Each-Mail", "true");
		        				Transport.send(message);
		        				
		        			} catch (MessagingException e1) {
		        				logger.error(e1.getMessage(), e1);
		        				String errorMessage = e1.getMessage();
		        				logger.debug("remove Invalid address. and retry");
		        				
		        				if (errorMessage.contains("Invalid Addresses")) {
		        					String cause = e1.getCause().toString();
		        					findInvalidAddresses(cause, invalidAddressList);

                                    List<Address> allRecipientList = new ArrayList<Address>();
                                    for (int x = 0; x < allRecipients.length; x++) {
                                        String recipient = allRecipients[x].toString();
                                        String temp2 = recipient.substring(recipient.lastIndexOf(" <") + 2, recipient.length() - 1);

                                        if (invalidAddressList.contains(temp2)) {
                                            continue;
                                        } else {
                                            allRecipientList.add(allRecipients[x]);
                                        }
                                    }

                                    Address[] newRecipients = allRecipientList.stream().toArray(Address[]::new);
                                    message.setRecipients(RecipientType.TO, newRecipients);
                                    logger.debug("validAddressList=" + allRecipientList.toString());
                                    logger.debug("invalidAddressList=" + invalidAddressList);
                                    message.setHeader("X-JMocha-Each-Mail", "true");
                                    Transport.send(message);

                                } else {
                                    throw e1;     // 예외를 발생시킴
                                }
                            }
                        } else {
                            for (Address a : allRecipients) {
                                logger.debug("address=" + a);

                                try {
                                    message.setRecipient(RecipientType.TO, a);
                                    Transport.send(message);
                                } catch (MessagingException e) {
                                    logger.error(e.getMessage(), e);
                                    String errorMessage = e.getMessage();

                                    if (errorMessage.contains("Invalid Addresses")) {
                                        String cause = e.getCause().toString();

                                        findInvalidAddresses(cause, invalidAddressList);
                                    }
                                }
                            }
                        }

                        if (invalidAddressList.size() > 0) {
//		            		sendInvalidRecipientNotiMail(userAccount, message.getSubject(), invalidAddressList, locale, offset);
		            		
		            		invalidAddressList.clear();
		            	}
					} else {					
						if (retryFlag) {													
							Address[] recipients = message.getRecipients(RecipientType.TO);
							List<Address> newRecipientList = new ArrayList<>();

							if (recipients != null) {
								for (Address item : recipients) {
									InternetAddress recipient = (InternetAddress)item;
									if (!invalidAddressList.contains(recipient.getAddress())) {
										newRecipientList.add(recipient);
									}
								}
								
								Address[] newRecipients = newRecipientList.stream().toArray(Address[]::new);							
								message.setRecipients(RecipientType.TO, newRecipients);
								
								logger.debug("Retrying... i=" + i + ",newRecipientList TO=" + newRecipientList);
							}
							
							recipients = message.getRecipients(RecipientType.CC);
							newRecipientList.clear();

							if (recipients != null) {
								for (Address item : recipients) {
									InternetAddress recipient = (InternetAddress)item;
									if (!invalidAddressList.contains(recipient.getAddress())) {
										newRecipientList.add(recipient);
									}
								}
	
								Address[] newRecipients = newRecipientList.stream().toArray(Address[]::new);							
								message.setRecipients(RecipientType.CC, newRecipients);
								
								logger.debug("Retrying... i=" + i + ",newRecipientList CC=" + newRecipientList);
							}

							recipients = message.getRecipients(RecipientType.BCC);
							newRecipientList.clear();

                            if (recipients != null) {
                                for (Address item : recipients) {
                                    InternetAddress recipient = (InternetAddress) item;
                                    if (!invalidAddressList.contains(recipient.getAddress())) {
                                        newRecipientList.add(recipient);
                                    }
                                }

                                Address[] newRecipients = newRecipientList.stream().toArray(Address[]::new);
                                message.setRecipients(RecipientType.BCC, newRecipients);

                                logger.debug("Retrying... i=" + i + ",newRecipientList BCC=" + newRecipientList);
                            }

                            invalidAddressList.clear();

                            Transport.send(message);
                        } else {
                            Transport.send(message);
                        }
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
                ezEmailService.deleteMailReserved(messageId);
                logger.debug("Succeed in deleting data from DB.");

                retryFlag = false;
            } catch (MessagingException e) {
                logger.error(e.getMessage(), e);
                String errorMessage = e.getMessage();

                //유효하지 않은 사용자일 경우, eml 파일 및  예약 발송 정보(DB) 삭제
                if (!retryFlag && errorMessage.contains("Invalid Addresses")) {
                    invalidAddressList.clear();

                    String cause = e.getCause().toString();

                    findInvalidAddresses(cause, invalidAddressList);

                    logger.debug("invalidAddressList=" + invalidAddressList);

                    if (message != null && invalidAddressList.size() > 0) {
//						sendInvalidRecipientNotiMail(userAccount, message.getSubject(), invalidAddressList, locale, offset);
                    }

                    retryFlag = true;
                    i--;
                    continue;
                } else {
                    //파일시스템의 eml파일 삭제
                    if (f != null && f.delete()) {
                        logger.debug("Succeed in deleting EML file.");
                    }

                    // 보안메일 관련 임시파일 삭제
                    if (encryptedFile != null && encryptedFile.delete()) {
                        logger.debug("encryptedFile is deleted. fileName=" + encryptedFile.getName());
                    }

                    //DB에서 메일 예약발송 정보 삭제.
                    ezEmailService.deleteMailReserved(messageId);

                    retryFlag = false;
                }
            } catch (Exception e) {
                logger.error(e.getMessage(), e);
                String errorMessage = e.getMessage();

                //유효하지 않은 사용자일 경우, eml 파일 및  예약 발송 정보(DB) 삭제
                if (!retryFlag && errorMessage.contains("Invalid Addresses")) {
                    invalidAddressList.clear();

                    String cause = e.getCause().toString();

                    findInvalidAddresses(cause, invalidAddressList);

                    logger.debug("invalidAddressList=" + invalidAddressList);

                    if (message != null && invalidAddressList.size() > 0) {
//						sendInvalidRecipientNotiMail(userAccount, message.getSubject(), invalidAddressList, locale, offset);
					}
					
					retryFlag = true;
					i--;
					continue;
				} else {					
					//파일시스템의 eml파일 삭제
					if (f != null && f.delete()) {
						logger.debug("Succeed in deleting EML file.");
					}
					
					// 보안메일 관련 임시파일 삭제
					if (encryptedFile != null && encryptedFile.delete()) {
		        		logger.debug("encryptedFile is deleted. fileName=" + encryptedFile.getName());
					}
					
					//DB에서 메일 예약발송 정보 삭제.
					ezEmailService.deleteMailReserved(messageId);
					
					retryFlag = false;					
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

	private void findInvalidAddresses(String cause, List<String> invalidAddressList) {
		String pattern = "Unknown user: ([\\S]+)";
		Pattern r = Pattern.compile(pattern);
		Matcher m = r.matcher(cause);
		
		int index = 1000;
		while (m.find()) {
			// 1000번 이상 반복되면 break한다.
			--index;
			if (index < 0) {
				logger.error("Stop finding invalid addresses, because over 1000 times.");
				break;
			}
			
			invalidAddressList.add(m.group(1));
		}		
	}
	
	@SuppressWarnings("unused")
	private void sendInvalidRecipientNotiMail(String originalSender, String originalSubject, List<String> invalidAddressList,
					Locale locale, String offset) {
		try {
			String fontFamily = egovMessageSource.getMessage("main.t0620", locale).replace(";", ",");
			String subject = egovMessageSource.getMessage("ezEmail.ldh02", locale) + " " + originalSubject;		
			String message = egovMessageSource.getMessage("ezEmail.ldh03", locale);		
			String fontStyle = String.format("style='font-family: %s; font-size: %spx;'", fontFamily, 14);
			
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss ( z )");
            
            if (offset == null || offset.indexOf("|") == -1) {
    			logger.error("Check the offset. Offset is null or offset format is wrong.");
    		} else {
    			String[] offsetArr = offset.split("\\|");
    			sdf.setTimeZone(TimeZone.getTimeZone("GMT" + offsetArr[1]));
    		}
						
			StringBuilder content = new StringBuilder();
			content.append(String.format("<span %s>%s</span><br/><br/>", fontStyle, message));
			
			for (String address : invalidAddressList) {
				content.append(String.format("<span %s>%s</span><br/>", fontStyle, address));
			}

            content.append("<br/>");

            content.append("<p " + fontStyle + ">");
            content.append(String.format("<b>%s : </b> %s", egovMessageSource.getMessage("ezEmail.t704", locale), sdf.format(new Date()).replace("GMT", "")));
            content.append("</p>");

            content.append("<p " + fontStyle + ">");
            content.append(String.format("<b>%s : </b> %s", egovMessageSource.getMessage("ezEmail.t707", locale), EgovStringUtil.getSpclStrCnvr(originalSubject)));
            content.append("</p>");

            InternetAddress from = new InternetAddress("postmaster@localhost");

            ezEmailService.sendMail(originalSender, jspw, null, from, new InternetAddress[]{new InternetAddress(originalSender)}, null, null, subject, content.toString());
        } catch (MessagingException e) {
            logger.error(e.getMessage(), e);
        } catch (Exception e) {
            logger.error(e.getMessage(), e);
        }
    }

    /**
     * Processes Mail Statistics Logs.
     * 매일 자정 1분 30초에 실행된다.
     */
    @Scheduled(cron = "${config.cron.processMailStatLogs}")
    public void processMailStatLogs() throws Exception {
        logger.debug("processMailStatLogs scheduler started.");
        
        String useExternalMailServer = ezCommonService.getTenantConfig("useExternalMailServer", 0);
		if(useExternalMailServer != null && useExternalMailServer.equalsIgnoreCase("YES")) {
			logger.debug("processMailStatLogs scheduler ended.");
			return;
		}
		
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
                } catch (NumberFormatException e) {
                    logger.error(e.getMessage(), e);
                }
            }
            
            try {
                // 보존 기간이 지난 로그인 히스토리 로그를 삭제한다.
                ezSystemAdminService.deleteLoginHist(keepLogPeriodNum, tenant.getTenantId());
            } catch (DataAccessException e) {
                logger.error(e.getMessage(), e);
            } catch (Exception e) {
                logger.error(e.getMessage(), e);
            }
            
            try {
                // 보존 기간이 지난 웹폴더 파일 로그를 삭제한다.
                ezSystemAdminService.deleteWebfolderLog(keepLogPeriodNum, tenant.getTenantId());
            } catch (DataAccessException e) {
                logger.debug("deleteWebfolderLog delete fail. ");
                logger.error(e.getMessage(), e);
            } catch (Exception e) {
                logger.debug("deleteWebfolderLog delete fail. ");
                logger.error(e.getMessage(), e);
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
                } catch (DataAccessException e) {
                    logger.debug(e.getMessage());
                    logger.error(e.getMessage(), e);
                } catch (Exception e) {
                    logger.debug(e.getMessage());
                    logger.error(e.getMessage(), e);
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
		
		String realPath = commonUtil.getRealPath(servletContext);
		
		//delete expired big-attachment files
		deleteExpireAttach(tenantList, realPath);
		
		//set directory
		//TODO: set upload_common directory
		List<String> directoryList = new ArrayList<String>();
		for (TenantVO tenantVO : tenantList) {
			directoryList.add(commonUtil.getUploadPath("upload_mail.ROOT", tenantVO.getTenantId()) + commonUtil.separator + "tempFileUpload");
			directoryList.add(commonUtil.getUploadPath("upload_mail.ROOT", tenantVO.getTenantId()) + commonUtil.separator + "templist");
			directoryList.add(commonUtil.getUploadPath("upload_mail.ROOT", tenantVO.getTenantId()) + commonUtil.separator + "tempWebfolderFileUpload");
			directoryList.add(commonUtil.getUploadPath("upload_common.ROOT", tenantVO.getTenantId()));
		}
		
		int dayLimit = 2;
		long nowTime = new Date().getTime();
		
		//delete garbage files from directoryList
		for (String directory : directoryList) {
			File file = new File(realPath + directory);
			logger.debug("path=" + realPath + directory);
			if (file.exists()) {
				File[] files = file.listFiles();

                if (files != null){
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
        }

        logger.debug("dailyFileManage scheduler ended.");
    }

    /**
     * @author jwseo99
     * <p>
     * 편지함 용량 경고 메일 자동 발송
     * @since 2018.03.06
     */
    @Scheduled(cron = "${config.cron.broadcastQuotaWarning}")
    public void broadcastQuotaWarning() throws Exception {
        logger.debug("broadcastQuotaWarning started.");

        String useExternalMailServer = ezCommonService.getTenantConfig("useExternalMailServer", 0);
        if (useExternalMailServer != null && useExternalMailServer.equalsIgnoreCase("YES")) {
            logger.debug("broadcastQuotaWarning scheduler ended.");
            return;
        }

        //choose scheduler running server
        if (!preScheduler("broadcastQuotaWarning")) {
            logger.debug("broadcastQuotaWarning scheduler ended.");
            return;
        }

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
        } catch (ParseException ex) {
            logger.error(ex.getMessage(), ex);
        } catch (Exception ex) {
            logger.error(ex.getMessage(), ex);
        }

        // using system locale
        Locale systemLocale = Locale.getDefault();
        // mail access info
        String mailServerAddress = config.getProperty("config.MailServerAddress");
        String imapPort = config.getProperty("config.IMAPPort");

        // message info
        InternetAddress from = new InternetAddress("postmaster@localhost");

        // process mailQuota
        for (String userEmail : emailArray) {

            try {
                String domainName = userEmail.substring(userEmail.indexOf("@") + 1, userEmail.length());
                int tenantId = ezCommonService.getTenantIdByDomainName(domainName);
                String primaryLang = ezCommonService.getTenantConfig("PrimaryLang", tenantId);
                Locale locale;

				String lang = ezCommonService.getTenantConfig("useSecondaryLang", tenantId);
				if ("YES".equals(lang)){
					primaryLang="2";
				}

                switch (primaryLang) {
                    case "1":
                        locale = Locale.KOREA;
                        break;
                    case "2":
                        locale = Locale.US;
                        break;
                    case "3":
                        locale = Locale.JAPAN;
                        break;
                    default:
                        locale = systemLocale;
                }

                String fontFamily = egovMessageSource.getMessage("ezEmail.sjw01", locale);
                String subject = egovMessageSource.getMessage("ezEmail.sjw02", locale);
                String suggestion = egovMessageSource.getMessage("ezEmail.sjw03", locale);

                String fontStyle = String.format("style='font-family: %s; font-size: %spx;'", fontFamily, 13);

                // user quota info
                Double[] userQuotaData = ezEmailUtil.getUserRealQuota(userEmail);

                IMAPAccess imapAccess = IMAPAccess.getInstance(mailServerAddress, imapPort, userEmail, jspw, egovMessageSource,
                        locale, ezEmailUtil);

                // KB
                long[] storageUsageAndLimit = imapAccess.getStorageUsageAndLimit();
                long mailboxUsage = storageUsageAndLimit[0];
                long mailboxQuota = storageUsageAndLimit[1];
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

                int usedPercent = (int) ((100 / (float) mailboxQuota) * mailboxUsage);
                int unusedPercent = 100 - usedPercent;

                logger.debug("used percent: {}", usedPercent);
                logger.debug("unused percent: {}", unusedPercent);
                logger.debug("============");

                // content
                StringBuilder content = new StringBuilder();
                content.append(String.format("<span %s>%s</span><br/><br/>", fontStyle, subject));
                content.append("<table cellspacing='0;'>")
                        .append("	<tbody>")
                        .append("		<tr>")
                        .append("			<td style='background-color:#FFCC00;width:" + usedPercent * 2 + "px;border-left-style:solid;border-top-style:solid;border-bottom-style:solid;border-color:black;border-width:1'><font color='#000000' size='2' face='Tahoma'>" + humanReadableByteCount(mailboxUsage * 1024) + "</font></td>")
                        .append("			<td style='background-color:#ffffff;width:" + unusedPercent * 2 + "px;border-right-style:solid;border-top-style:solid;border-bottom-style:solid;border-color:black;border-width:1'>&nbsp;</td>")
                        .append("			<td><span " + fontStyle + "><b>" + humanReadableByteCount(mailboxQuota * 1024) + "</b></span></td>")
                        .append("		</tr>")
                        .append("	</tbody>")
                        .append("</table>");
                content.append(String.format("<br/><span %s>%s</span><br/>", fontStyle, suggestion));

                // send mail
                ezEmailService.sendMail(userEmail, jspw, null, from, new InternetAddress[]{new InternetAddress(userEmail)}, null, null, subject, content.toString(), false, EmailImportance.HIGH);
            } catch (IndexOutOfBoundsException ex) {
                logger.error(ex.getMessage(), ex);
            } catch (Exception ex) {
                logger.error(ex.getMessage(), ex);
            }

        }

        logger.debug("broadcastQuotaWarning end.");
    }


    /**
     * 만료일 지난 사용자 공용배포그룹 삭제
     */
    @Scheduled(cron = "${config.cron.useDistributionoDelete}")
    public void useDistributionoDelete() throws Exception {
        logger.debug("useDistributionoDelete scheduler started.");

        //choose scheduler running server
        if (!preScheduler("useDistributionoDelete")) {
            logger.debug("useDistributionoDelete scheduler ended.");
            return;
        }

        int tenantId = 0;
        String delDLURL = config.getProperty("config.JGwServerURL") + "/jMochaAccess/deleteDistribution";

        String useUserDefinedDL = ezCommonService.getTenantConfig("useUserDefinedDL", tenantId);

        if (useUserDefinedDL.equalsIgnoreCase("YES")) {
            try {
                List<MailDistributionVO> dlVoList = ezEmailService.getExpiredUserDistributionList();
                for (MailDistributionVO dlVo : dlVoList) {
                    String domain = dlVo.getDomain();
                    String dlId = dlVo.getId();
                    logger.debug("domain=" + domain + ", dlId=" + dlId);

                    String delDlInputParams = "domain=" + domain + "&cn=" + dlId;
                    String delDlResponse = ezEmailUtil.getWebServiceResult(delDLURL, delDlInputParams);
                    logger.debug("delDlResponse=" + delDlResponse);

                }
            } catch (DataAccessException e) {
                logger.error(e.getMessage(), e);
            } catch (Exception e) {
                logger.error(e.getMessage(), e);
            }
        }

        logger.debug("useDistributionoDelete scheduler ended.");
    }


	/** 
	 * 퇴직일로부터 n일 지난 퇴직자 자동 삭제
	 */
	@Scheduled(cron = "${config.cron.autoDeleteOfRetireUser}")
	public void autoDeleteOfRetireUser() throws Exception{
		logger.debug("AutoDeleteOfRetireUser scheduler started.");

		//choose scheduler running server
		if (!preScheduler("AutoDeleteOfRetireUser")) {
			logger.debug("AutoDeleteOfRetireUser scheduler ended.");
			return;
		}

		int tenantID = 0;
		
		String useAutoDeleteOfRetireUser = ezCommonService.getTenantConfig("useAutoDeleteOfRetireUser", tenantID); // 사용여부 컨피그
		String autoDeleteOfRetireUserLimit = ezCommonService.getTenantConfig("autoDeleteOfRetireUserLimit", tenantID); // n일 설정 컨피그
		logger.debug("useAutoDeleteOfRetireUser=" + useAutoDeleteOfRetireUser + ", autoDeleteOfRetireUserLimit=" + autoDeleteOfRetireUserLimit);
		
		if (useAutoDeleteOfRetireUser.equalsIgnoreCase("YES") && !autoDeleteOfRetireUserLimit.equals("")) {
			int autoRemoveUserLimitNum = Integer.parseInt(autoDeleteOfRetireUserLimit);
			
			if (autoRemoveUserLimitNum > 0) {
				List<String> deleteUserCnList = ezOrganAdminService.getAutoDeleteOfRetireUserList(tenantID, autoRemoveUserLimitNum);
				logger.debug("deleteUserCnList size=" + deleteUserCnList.size());
				
				if (deleteUserCnList.size() <= 0) {
					logger.debug("There are no users to delete. AutoDeleteOfRetireUser scheduler ended.");
					return; 
				}

				String urlStr = config.getProperty("config.scheduleGwServerURL") + "/admin/ezOrgan/delUser.do";
				
				String deleteUserCnStr = String.join(",", deleteUserCnList);
				String inputParams = "cn="+deleteUserCnStr;
				logger.debug("inputParams=" + inputParams);
				
				String result = getWebServiceResultForGw(urlStr, inputParams);
				logger.debug("result=" + result);
			}
		}
		
		logger.debug("AutoDeleteOfRetireUser scheduler ended.");
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
			
			String pUploadPath = realPath + commonUtil.getUploadPath("upload_mail.ROOT", tenantVO.getTenantId());
			
			// 2018-10-08 분리된 대용량파일(largeFile) 폴더 사용 여부
			String useSeparatedLargeFileFolder = ezCommonService.getTenantConfig("useSeparatedLargeFileFolder", tenantVO.getTenantId());

			if (useSeparatedLargeFileFolder.equals("YES")) {
				pUploadPath += commonUtil.separator + "largeFile";
			}
			
			File file = new File(pUploadPath);
			logger.debug("path=" + pUploadPath);
			
			String bigSizeMailAttachDelDayStr = ezCommonService.getTenantConfig("BigSizeMailAttachDelDay", tenantVO.getTenantId());
			int bigSizeMailAttachDelDay = Integer.parseInt(bigSizeMailAttachDelDayStr);
			
			if (file.exists()) {
				File[] files = file.listFiles(new DeleteExpireAttachFilter(bigSizeMailAttachDelDay));
				
				for (File expiredFile : files) {
					File[] filelist = expiredFile.listFiles();
					logger.debug("expired directory name=" + expiredFile.getName());
					if (deleteDirectory(expiredFile)) {
						logger.debug(expiredFile.getName() + " is deleted.");
						//대용량 첨부파일 삭제 시 제한 횟수 정보도 삭제하는 로직 추가. 2020-03-12 홍대표.
						ezEmailService.deleteBigAttachCountInfo(filelist, tenantVO.getTenantId());
					}
				}
			}
		}
		
		logger.debug("deleteExpireAttach ended.");
	}
	
	public boolean preScheduler(String scheduler) {
		logger.debug("preScheduler started.");
		
		boolean isSchedulerServer = false;

        if ("YES".equals(config.getProperty("config.Run_Scheduler"))) {
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
                JSONObject object = (JSONObject) parser.parse(response);

                if (object.get("resultCode").equals("OK") && ((Long) object.get("reasonCode")).intValue() == 0) {
                    String schedulerServer = (String) object.get("result");

                    if (schedulerServer.equals(server)) {
                        isSchedulerServer = true;
                        logger.debug("This is elected as a scheduler server.");
                    } else {
                        logger.debug("This is not elected.");
                    }
                } else {
                    logger.error("Cannot get SchedulerServer.");
                }
            } catch (ParseException e) {
                logger.error(e.getMessage(), e);
            } catch (Exception e) {
                logger.error(e.getMessage(), e);
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
            if (name != null) {
                if (NumberUtils.isNumber(name)) {
                    return EgovDateUtil.getDaysDiff(name, today) > bigSizeMailAttachDelDay;
                }
            }
            return false;
        }
    }

    public String getWebServiceResultForGw(String urlString, String inputParams) throws Exception {
        logger.debug("getWebServiceResultForGw Started.");

        String result = null;

        URL url = new URL(urlString);
        HttpURLConnection conn = null;

        try {
            conn = (HttpURLConnection) url.openConnection();

            conn.setDoOutput(true);
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded; charset=utf-8");
            //테넌트 0 번
            conn.setRequestProperty("Cookie", "loginCookie=hfH144YiWCggw53Wkj4WXmhb0rhoI1B/DeoAXRh0t13Q2Lhpiu2cfZxpGhaoRn5VGFc0scMdIv6w/TXttsWK+JzNnK345dM+ex3sizp9pXwdl7edNQKS8ydC51Aa6GINBE5qSRsW8cV7E7GpPJ5qiEqKq8asuFkHy2ZDT26lofk=;");

            if (inputParams != null) {
                try (OutputStream os = conn.getOutputStream()) {
                    // UTF-8로 인코딩한다.
                    os.write(inputParams.getBytes("UTF-8"));
                    os.flush();
                }
            }

            if (conn.getResponseCode() == HttpURLConnection.HTTP_OK) {
                // Response Body를 UTF-8로서 디코딩한다.
                try (BufferedReader br = new BufferedReader(
                        new InputStreamReader(conn.getInputStream(), "UTF-8")
                )) {

                    StringBuilder sb = new StringBuilder();
                    String output;

                    while ((output = br.readLine()) != null) {
                        sb.append(output);
                    }

                    result = sb.toString();
                }

                conn.disconnect();
                conn = null;
            } else {
                Exception e = new RuntimeException("Failed : HTTP error code : " + conn.getResponseCode());

                throw e;
            }
        } finally {
            if (conn != null) {
                conn.disconnect();
                conn = null;
            }
        }

        logger.debug("getWebServiceResultForGw ended.");
        return result;
    }

	/**
	 * 승인메일 : 자동삭제 - (전사/일반) 승인신청한 메일이 n개월이 지나면 자동삭제 (상태변경)
	 * 자동삭제 상태로 변경되는 메일은 신청자의 임시보관함으로 이동 및 알림메일 발송
	 */
	@Scheduled(cron = "${config.cron.autoDeleteApprMailHistory}")
	public void autoDeleteApprMailHistroy() throws Exception {
		logger.debug("autoDeleteApprMailHistroy scheduler started.");
		
		try {
			for (TenantVO tenantVO : ezCommonService.getTenantList()) {
				int tenantId = tenantVO.getTenantId();
				String domainName = ezCommonService.getTenantConfig("DomainName", tenantId);
				
				// 자동삭제 대상 리스트 조회
				List<Map<String, String>> hisList = ezEmailService.getAutoDeleteApprMailHistoryList(tenantId, "1");
				
				for (Map<String, String> m : hisList) {
					long uid = Long.parseLong(m.get("mailUID"));
					String companyId = m.get("companyId");
					String applicantId = m.get("userId");
					String applicantEmail = applicantId + "@" + domainName;
					logger.debug("uid={}, applicantEmail={}, companyId={}", uid, applicantEmail, companyId);

					// 상태변경 및 알림메일 발송
					ezEmailService.setApprMailAutoDelete(tenantId, companyId, applicantEmail, uid);
				}
			}
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		logger.debug("autoDeleteApprMailHistroy scheduler");
	}

	/**
	 * 승인메일 : 오래된 로그 삭제 - (일반) n개월이 지난 승인대기 상태 그외의 로그 삭제
	 */
	@Scheduled(cron = "${config.cron.deleteOldApprMailHistory}")
	public void deleteOldApprMailHistory() throws Exception {
		logger.debug("deleteOldApprMailHistory scheduler started.");
		
		try {
			for (TenantVO tenantVO : ezCommonService.getTenantList()) {
				int tenantId = tenantVO.getTenantId();
				String domainName = ezCommonService.getTenantConfig("DomainName", tenantId);
				
				// 로그 삭제 대상 리스트 조회
				List<Map<String, String>> hisList = ezEmailService.getOldApprMailHistoryList(tenantId, "1");
				
				for (Map<String, String> m : hisList) {
					long uid = Long.parseLong(m.get("mailUID"));
					String companyId = m.get("companyId");
					String applicantId = m.get("userId");
					String applicantEmail = applicantId + "@" + domainName;
					logger.debug("uid={}, applicantEmail={}, companyId={}", uid, applicantEmail, companyId);

					// 삭제
					ezEmailService.setOldApprMailDelete(tenantId, companyId, applicantEmail, uid);
				}
			}
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		logger.debug("deleteOldApprMailHistory scheduler");
	}
}
