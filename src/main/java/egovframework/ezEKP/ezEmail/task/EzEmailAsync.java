package egovframework.ezEKP.ezEmail.task;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Properties;

import javax.annotation.Resource;
import javax.mail.FetchProfile;
import javax.mail.Flags;
import javax.mail.Folder;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;
import javax.mail.search.SearchTerm;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Component;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.logic.IMAPAccess;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezEmail.util.EzEmailUtil;

@Component
public class EzEmailAsync {
	private static final Logger logger = LoggerFactory.getLogger(EzEmailAsync.class);

	@Resource(name = "egovMessageSource")
	private EgovMessageSource egovMessageSource;

	@Autowired
	private EzEmailService ezEmailService;

	@Resource(name = "EzCommonService")
	private EzCommonService ezCommonService;

	@Autowired
	private Properties config;

	@Autowired
	private EzEmailUtil ezEmailUtil;
	
	@Resource(name = "jspw")
	private String jspw;

	@Async
	public void cancelMailDelete(String num, int tenantID) {
		logger.debug("cancelMailDelete async methoed started.");
		logger.debug("num=" + num);
		
		try {
			final String messageId = ezEmailService.getMailReceiveMessageId(num);
			
			if (messageId == null) {
				logger.error("cannot get messageId from DB.");
				return;
			}
			
			String password = jspw;
			List<String> addresses = ezEmailService.getMailReceiveAddress(num);
			Locale locale = Locale.getDefault();
						
			String isReadDeleteStr = ezCommonService.getTenantConfig("IS_READ_DELETE", tenantID);
			boolean isReadDelete = false;

			if (isReadDeleteStr.equals("YES")) {
				isReadDelete = true;
			}
			
			SearchTerm searchTerm = new SearchTerm() {
				private static final long serialVersionUID = 1L;

				@Override
				public boolean match(Message message) {
					try {
						String thisMessageId = ((MimeMessage) message).getMessageID();

						if (thisMessageId != null && thisMessageId.contains(messageId)) {
							return true;
						}
					} catch (MessagingException e) {
						e.printStackTrace();
					}
					
					return false;
				}
			};
			
			for (String address : addresses) {
				// jobCode - 1:발견후 삭제, 2:발견하였으나 읽은 메일, 3:발견하지 못함
				// config.IS_READ_DELETE가 YES이면 읽은 메일도 삭제 (jobCode=1)
				int jobCode = 3;
				IMAPAccess ia = null;
				
				try {
					ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"),
							config.getProperty("config.IMAPPort"), address, password, egovMessageSource, locale, ezEmailUtil);
					
					List<String> folderNameList = ia.getAllTopLevelFolderNames();
										
					for (String folderName : folderNameList) {
						Folder folder = ia.getFolder(folderName);
						jobCode = recursiveCancelMailSearch(ia, folder,searchTerm, isReadDelete);
						 
						if (jobCode != 3) {
							break; 
						}							 
					}
					
					ia.close();
					ia = null;
				} catch (Exception e) {
					e.printStackTrace();
					jobCode = 3;
				} finally {					
					if (ia != null) {
						ia.close();
					}
				}
				
				ezEmailService.updateMailReceiveDetailInfo(num, new String[] {address, String.valueOf(jobCode)});
				logger.debug("address=" + address + ",jobCode=" + jobCode);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}

		logger.debug("cancelMailDelete async methoed ended.");
	}
	
	/**
	 * 메일 회수시 받은 편지함, 지운편지함, 개인편지함, 정크메일함과 각 편지함의 하위폴더에서도 회수가 가능하도록 개선.
	 */
	private int recursiveCancelMailSearch(IMAPAccess ia, Folder folder, 
					SearchTerm searchTerm, boolean isReadDelete) throws Exception {
		logger.debug("folderName=" + folder.getFullName());
		
		int jobCode = 3;
		
		if (folder.exists()) {
			folder.open(Folder.READ_WRITE);
			String folderPath = folder.getFullName();
			Message[] messages = folder.getMessages();
			
			// pre-fetch fields needed for searching
			FetchProfile fp = new FetchProfile();
			fp.add(FetchProfile.Item.ENVELOPE);
			folder.fetch(messages, fp);

			messages = folder.search(searchTerm);
			
			if (messages.length > 0) { // 메일 발견
				if (messages[0].isSet(Flags.Flag.SEEN)) { // 메일 읽음
					if (isReadDelete) { // 읽어도 지움
						messages[0].setFlag(Flags.Flag.DELETED, true);
						jobCode = 1;
					} else { // 읽으면 안지움
						jobCode = 2;
					}
				} else { // 메일 안읽음
					messages[0].setFlag(Flags.Flag.DELETED, true);
					jobCode = 1;
				}

				logger.debug("folderPath=" + folder.getFullName());
				
				folder.close(true);
			} else {
				folder.close(true);
				List<Folder> subfolderList = ia.getSubFolders(folderPath, false);

				for (Folder subFolder : subfolderList) {
					int subJobCode = recursiveCancelMailSearch(ia, subFolder, searchTerm, isReadDelete);

					if (subJobCode != 3) {
						jobCode = subJobCode;
						break;
					}
				}
			}
		}
		
		return jobCode;
	}
	
}


