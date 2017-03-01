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
import javax.mail.Address;
import javax.mail.Flags;
import javax.mail.Folder;
import javax.mail.Message;
import javax.mail.Transport;
import javax.mail.Message.RecipientType;
import javax.mail.internet.MimeMessage;
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

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.logic.IMAPAccess;
import egovframework.ezEKP.ezEmail.logic.SMTPAccess;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezEmail.util.EzEmailUtil;
import egovframework.ezEKP.ezEmail.vo.MailDeleteVO;
import egovframework.ezEKP.ezEmail.vo.MailReservationVO;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.TenantVO;
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
	private EzCommonService ezCommonService;
	
	@Resource(name = "loginService")
    private LoginService loginService;
	
	@Autowired
	private EzEmailUtil ezEmailUtil;
	
	@Autowired
	private EzOrganAdminService ezOrganAdminService;
	
	@Resource(name = "jspw")
    private String jspw;
	
	/**
	 * 환경설정 - 자동삭제 스케줄러
	 */
	@Scheduled(cron = "00 00 05 * * *")
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
				String userEmail = vo.getUserId();

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
	@Scheduled(cron = "30 0/10 * * * *")
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
				logger.debug("locale=" + locale);
				
				String pDirPath = commonUtil.getUploadPath("upload_mail.RESERVED_MAIL_PATH", tenantId);
				pDirPath = realPath + commonUtil.separator + pDirPath;
	
				File f = new File(pDirPath + commonUtil.separator + vo.getMessageId() + ".eml");
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
     */
    @Scheduled(cron = "30 01 00 * * *")
    public void processMailStatLogs() throws Exception {
        logger.debug("processMailStatLogs scheduler started.");
        
        //choose scheduler running server
        if (!preScheduler("processMailStatLogs")) {
            logger.debug("processMailStatLogs scheduler ended.");
            return;
        }
        
        logger.debug("processMailStatLogs scheduler elected.");
        
        List<TenantVO> tenantList = ezCommonService.getTenantList();
        
        for (TenantVO tenant : tenantList) {
            logger.debug("tenantId=" + tenant.getTenantId() + ",tenantName=" + tenant.getTenantName());
        
            // 메일 건수, 크기 등 통계 현황을 통계 테이블에 저장하는 API를 호출한다.
            String requestURL = config.getProperty("config.JGwServerURL") + "/ezEmailAccess/processMailStatLogs";
            
            String param1 = "tenantId=" + tenant.getTenantId();        
            String inputParams = param1;
    
            logger.debug("inputParams=" + inputParams);
            
            String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams); 
            
            logger.debug("response=" + response);       
    
            Calendar calendar = Calendar.getInstance();
            int dayOfMonth = calendar.get(Calendar.DAY_OF_MONTH);   
            
            logger.debug("dayOfMonth=" + dayOfMonth);
            
            // 메일박스 사용량 통계는 매월 초 1일에 한 번 처리한다.
            if (dayOfMonth == 1) {  
                List<OrganUserVO> userCnList = ezOrganAdminService.getUserCnList(tenant.getTenantId());
                IMAPAccess ia = null;
                Locale locale = Locale.getDefault();
                String password = jspw;
                String userId = null;
                String email = null;
                
                calendar.add(Calendar.DAY_OF_MONTH, -1);
                String yearMonth = String.format("%04d%02d", calendar.get(Calendar.YEAR), calendar.get(Calendar.MONTH) + 1);
                
                for (OrganUserVO organUser : userCnList) {
                    userId = organUser.getCn();
                    logger.debug("userId=" + userId);
                    
                    try {
                        email = userId + "@" + ezCommonService.getTenantConfig("DomainName", tenant.getTenantId());
                        ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
                                            email, password, egovMessageSource, locale);
                                
                        long[] storageUsageAndLimit = ia.getStorageUsageAndLimit();
                        
                        long mailboxUsage = storageUsageAndLimit[0]; // in KBs
                        long mailboxQuota = storageUsageAndLimit[1]; // in KBs
                        
                        logger.debug("email=" + email + ",mailboxUsage=" + mailboxUsage + ",mailboxQuota=" + mailboxQuota);     
                        
                        // 메일박스 쿼터와 사용량을 통계 테이블에 저장하는 API를 호출한다.
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
        }
        
        logger.debug("processMailStatLogs scheduler ended.");
    }
	
	/**
	 * delete garbage files
	 */
	@Scheduled(cron = "30 02 00 * * *")
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
	
	/**
	 * recursive하게 파일/폴더 삭제하는 함수
	 */
	private boolean deleteDirectory(File path) {
		if (path.isDirectory()) {
			File[] files = path.listFiles();
			
			for (int i=0; i<files.length; i++) {
				if (files[i].isDirectory()) {
					deleteDirectory(files[i]);
				}
				else {
					files[i].delete();
				}
			}
		}
		
		return path.delete();
	}
	
	private boolean preScheduler(String scheduler) {
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
