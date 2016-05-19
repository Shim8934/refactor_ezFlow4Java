package egovframework.ezEKP.ezEmail.scheduler;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
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
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezEmail.logic.IMAPAccess;
import egovframework.ezEKP.ezEmail.logic.SMTPAccess;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezEmail.vo.MailDeleteVO;
import egovframework.ezEKP.ezEmail.vo.MailReservationVO;
import egovframework.let.utl.fcc.service.CommonUtil;

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

	@Scheduled(cron = "0 0/10 * * * *")
	public void reservedMailSend() throws Exception{
		logger.debug("10분 주기로 호출이 됩니다.");
		Locale locale = Locale.getDefault();

		//DB에 있는 예약발송리스트 가져와서 for문돌리기
		List<MailReservationVO> list = ezEmailService.getMailReserved2();
		for (MailReservationVO vo : list) {

			String userId = vo.getConnUrl();
			int index = userId.indexOf("@");
			if (index > -1) {
				userId = userId.substring(0, index);
			}
			String password = "1234!";

			FileInputStream fis = null;

			String realPath = config.getProperty("data_root");
			String pDirPath = config.getProperty("upload_mail.RESERVED_MAIL_PATH");
			pDirPath = realPath + commonUtil.separator + pDirPath;

			File f = new File(pDirPath + commonUtil.separator + vo.getMessageId() + ".eml");
			if (f.exists()) {
				try {
					fis = new FileInputStream(f);

					SMTPAccess sa = SMTPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.SMTPPort"),
							userId + "@"+config.getProperty("config.DomainName"), password);

					MimeMessage message = sa.readMimeMessage(fis);
					Transport.send(message);

					//보낸편지함에 저장
					IMAPAccess ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
							userId +"@"+config.getProperty("config.DomainName"), password, egovMessageSource, locale);
					Folder folder = ia.getFolder(egovMessageSource.getMessage("ezEmail.t99000026", locale));
					if (folder.exists()) {
						folder.open(Folder.READ_WRITE);
						folder.appendMessages(new Message[]{message});
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

				//파일시스템의 eml파일 삭제
				f.delete();
			}

			//DB에서 삭제
			ezEmailService.deleteMailReserved(vo.getMessageId());
		}
	}

}
