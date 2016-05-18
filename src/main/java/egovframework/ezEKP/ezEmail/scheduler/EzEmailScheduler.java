package egovframework.ezEKP.ezEmail.scheduler;

import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Properties;

import javax.annotation.Resource;
import javax.mail.Flags;
import javax.mail.Folder;
import javax.mail.Message;
import javax.mail.search.AndTerm;
import javax.mail.search.ComparisonTerm;
import javax.mail.search.FlagTerm;
import javax.mail.search.ReceivedDateTerm;
import javax.mail.search.SearchTerm;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezEmail.logic.IMAPAccess;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezEmail.vo.MailDeleteVO;

@Component
public class EzEmailScheduler {
	
	private static final Logger logger = LoggerFactory.getLogger(EzEmailScheduler.class);

	@Autowired
	private Properties config;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource; 
	
	@Autowired
	private EzEmailService ezEmailService;
	
	@Scheduled(cron = "00 00 05 * * *")
	public void autoDelete() throws Exception{
		logger.debug("오전 05:00:00에 호출이 됩니다.");
		Locale locale = Locale.getDefault();
		List<MailDeleteVO> list = ezEmailService.getMailDeleteList();
		
		for (MailDeleteVO vo : list) {
			try {
				String userId = vo.getUserId();
				int index = userId.indexOf("@");
				if (index != -1) {
					userId = userId.substring(0, index);
				}
				
				//TODO: 비밀번호 setting...
				String password = "1234!";
				String path = vo.getPath();
				String deleteUnread = vo.getDeleteUnread();
				int expireTime = vo.getExpireTime();
				
				logger.debug("userId : " + userId);
				logger.debug("path : " + path);
				logger.debug("deleteUnread : " + deleteUnread);
				logger.debug("expireTime : " + expireTime);
				
				IMAPAccess ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
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
				ia.close();
			} catch (Exception e) {
				logger.error("Exception has occurred.");
			}
		}
	}
	
}
