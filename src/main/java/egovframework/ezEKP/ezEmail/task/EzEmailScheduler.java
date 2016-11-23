package egovframework.ezEKP.ezEmail.task;

import java.io.File;
import java.io.FileInputStream;
import java.io.FilenameFilter;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Properties;

import javax.annotation.Resource;
import javax.mail.Flags;
import javax.mail.Folder;
import javax.mail.Message;
import javax.mail.Transport;
import javax.mail.internet.MimeMessage;
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

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezEmail.logic.IMAPAccess;
import egovframework.ezEKP.ezEmail.logic.SMTPAccess;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezEmail.util.EzEmailUtil;
import egovframework.ezEKP.ezEmail.vo.MailDeleteVO;
import egovframework.ezEKP.ezEmail.vo.MailReservationVO;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;

@Component
public class EzEmailScheduler {

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
	private EzEmailUtil ezEmailUtil;
	
	@Autowired
	private EzOrganAdminService ezOrganAdminService;
	
	/**
	 * 환경설정 - 자동삭제 스케줄러
	 */
	@Scheduled(cron = "00 00 05 * * *")
	public void autoDelete() throws Exception{
		logger.debug("오전 05:00:00에 호출이 됩니다.");
		Locale locale = Locale.getDefault();
		
		List<MailDeleteVO> list = ezEmailService.getMailDeleteList();

		for (MailDeleteVO vo : list) {
			IMAPAccess ia = null;
			
			try {
				String userId = vo.getUserId();
				int index = userId.indexOf("@");
				if (index != -1) {
					userId = userId.substring(0, index);
				}

				//TODO: 비밀번호 setting...
				String password = config.getProperty("config.JMochaSuperPassword");
				String path = vo.getPath();
				String deleteUnread = vo.getDeleteUnread();
				int expireTime = vo.getExpireTime();

				logger.debug("userId : " + userId);
				logger.debug("path : " + path);
				logger.debug("deleteUnread : " + deleteUnread);
				logger.debug("expireTime : " + expireTime);

				ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
						userId+"@"+config.getProperty("config.DomainName"), password, egovMessageSource, locale);
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
	}
	
	/**
	 * 메일 예약발송 스케줄러
	 */
	@Scheduled(cron = "30 0/10 * * * *")
	public void reservedMailSend() throws Exception{
		logger.debug("reservedMailSend scheduler started.");
		Locale locale = Locale.getDefault();
		
		List<MailReservationVO> list = ezEmailService.getMailReserved2();
		
		for (MailReservationVO vo : list) {
			logger.debug(vo.toString());
			IMAPAccess ia = null;
			FileInputStream fis = null;
			try {
				
				String userId = vo.getConnUrl();
				int index = userId.indexOf("@");
				if (index > -1) {
					userId = userId.substring(0, index);
				}
				String password = config.getProperty("config.JMochaSuperPassword");
	
				String realPath = config.getProperty("data_root");
				String pDirPath = config.getProperty("upload_mail.RESERVED_MAIL_PATH");
				pDirPath = realPath + commonUtil.separator + pDirPath;
	
				File f = new File(pDirPath + commonUtil.separator + vo.getMessageId() + ".eml");
				if (f.exists()) {
					fis = new FileInputStream(f);
	
					SMTPAccess sa = SMTPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.SMTPPort"),
							userId + "@"+config.getProperty("config.DomainName"), password);
	
					MimeMessage message = sa.readMimeMessage(fis);
					
					//SentDate 재설정
			        message.setSentDate(Calendar.getInstance().getTime());
					logger.debug("sentDate=" + message.getSentDate().toString());
			        
			        Transport.send(message);
			        logger.debug("Succeed in sending the reserved message.");
			        
					//보낸편지함에 저장
					ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
							userId +"@"+config.getProperty("config.DomainName"), password, egovMessageSource, locale);
					Folder folder = ia.getFolder(egovMessageSource.getMessage("ezEmail.t99000026", locale));
					if (folder.exists()) {
						folder.open(Folder.READ_WRITE);
						folder.appendMessages(new Message[]{message});
						folder.close(true);
						logger.debug("Succeed in saving a message in sent folder.");
					}
	
					//파일시스템의 eml파일 삭제
					f.delete();
					logger.debug("Succeed in deleting EML file.");
				} else {
					logger.error("Cannot find file. filePath=" + pDirPath + commonUtil.separator + vo.getMessageId() + ".eml");
				}
				
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
	 */
	@Scheduled(cron = "30 01 00 * * *")
	public void processMailStatLogs() throws Exception{
		logger.debug("오전 00:01:30에 호출이 됩니다.");

		// 메일 건수, 크기 등 통계 현황을 통계 테이블에 저장하는 API를 호출한다.
		String requestURL = config.getProperty("config.JGwServerURL") + "/ezEmailAccess/processMailStatLogs";			
		String response = ezEmailUtil.getWebServiceResult(requestURL, null);		
		logger.debug("response=" + response);		

		Calendar calendar = Calendar.getInstance();
		int dayOfMonth = calendar.get(Calendar.DAY_OF_MONTH);		
		logger.debug("dayOfMonth=" + dayOfMonth);
		
		// 메일박스 사용량 통계는 매월 초 1일에 한 번 처리한다.
		if (dayOfMonth == 1) {	
			List<OrganUserVO> userCnList = ezOrganAdminService.getUserCnList();
			IMAPAccess ia = null;
			Locale locale = Locale.getDefault();
			String password = config.getProperty("config.JMochaSuperPassword");
			String userId = null;
			String email = null;
			
			calendar.add(Calendar.DAY_OF_MONTH, -1);
			String yearMonth = String.format("%04d%02d", calendar.get(Calendar.YEAR), calendar.get(Calendar.MONTH) + 1);
			
			for (OrganUserVO organUser : userCnList) {
				userId = organUser.getCn();
				logger.debug("userId=" + userId);
				
				try {
					email = userId + "@" + config.getProperty("config.DomainName");
					ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
										email, password, egovMessageSource, locale);
							
					long[] storageUsageAndLimit = ia.getStorageUsageAndLimit();
					
					long mailboxUsage = storageUsageAndLimit[0]; // in KBs
					long mailboxQuota = storageUsageAndLimit[1]; // in KBs
					
					logger.debug("email=" + email + ",mailboxUsage=" + mailboxUsage + ",mailboxQuota=" + mailboxQuota);		
					
					// 메일박스 쿼터와 사용량을 통계 테이블에 저장하는 API를 호출한다.
					requestURL = config.getProperty("config.JGwServerURL") + "/ezEmailAccess/setMailboxUsageLog";
					
					String userIdParam = "userId=" + URLEncoder.encode(userId, "UTF-8");
					String emailParam = "email=" + URLEncoder.encode(email, "UTF-8");
					String usageParam = "usage=" + mailboxUsage*1024;
					String quotaParam = "quota=" + mailboxQuota*1024;
					String yearMonthParam = "yearMonth=" + yearMonth;
					
					String inputParams = userIdParam + "&" + emailParam + "&" + usageParam + "&" + quotaParam + "&" + yearMonthParam;

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
	}
	
	/**
	 * 만료된 대용량 메일 첨부폴더 삭제 스케줄러
	 */
	@Scheduled(cron = "30 00 00 * * *")
	public void deleteExpireAttach() throws Exception{
		logger.debug("오전 00:00:30에 호출이 됩니다.");
		
		String pUploadPath = config.getProperty("upload_mail.ROOT");
		String realPath = config.getProperty("data_root");
		
		File file = new File(realPath + pUploadPath);
		if (file.exists()) {
			File[] files = file.listFiles(new FilenameFilter() {
				String today = EgovDateUtil.getToday("");
				int signImageSizeLimit = Integer.parseInt(config.getProperty("config.BigSizeMailAttachDelDay"));
				
				@Override
				public boolean accept(File dir, String name) {
					if (name != null && dir.isDirectory()) {
						if (NumberUtils.isNumber(name)) {
							return EgovDateUtil.getDaysDiff(name, today) > signImageSizeLimit;
						}
					}
					return false;
				}
			});
			
			for (File expiredFile : files) {
				if (deleteDirectory(expiredFile)) {
					logger.debug(expiredFile.getName() + "is deleted.");
				}
			}
		}
	}
	
	/**
	 * recursive하게 파일/폴더 삭제하는 함수
	 */
	public boolean deleteDirectory(File path) {
		if(path.exists()) {
			File[] files = path.listFiles();
			for(int i=0; i<files.length; i++) {
				if(files[i].isDirectory()) {
					deleteDirectory(files[i]);
				}
				else {
					files[i].delete();
				}
			}
		}
		return path.delete();
	}
	
}
