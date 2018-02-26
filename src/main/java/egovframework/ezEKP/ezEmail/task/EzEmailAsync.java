package egovframework.ezEKP.ezEmail.task;

import java.util.ArrayList;
import java.util.List;
import java.util.ListIterator;
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

@Component
public class EzEmailAsync {

	private static final Logger logger = LoggerFactory.getLogger(EzEmailAsync.class);

	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource; 
	
	@Autowired
	private EzEmailService ezEmailService;
	
	@Resource(name="EzCommonService")
	private EzCommonService ezCommonService;
	
	@Autowired
	private Properties config;
	
	@Resource(name = "jspw")
    private String jspw;
	
	@Async
	public void cancelMailDelete(String num, int tenantID, String childName) {
		logger.debug("cancelMailDelete async methoed started.");
		logger.debug("num=" + num);
		int i = -1;
		Locale locale = Locale.getDefault();
		ArrayList<String> mailbox = new ArrayList<String>();   
		mailbox.add(egovMessageSource.getMessage("ezEmail.lhm01", locale));//받은편지함
		mailbox.add(egovMessageSource.getMessage("ezEmail.t647", locale));//지운편지함
		mailbox.add(egovMessageSource.getMessage("ezEmail.t648", locale));//개인편지함
		try {
			final String messageId = ezEmailService.getMailReceiveMessageId(num);
			if (messageId == null) {
				logger.error("cannot get messageId from DB");
			}
			
			List<String> addresses = ezEmailService.getMailReceiveAddress(num);
			
			String password = jspw;
			
			
			List<String[]> receiveDetailList = new ArrayList<String[]>();
			
			String isReadDelete = ezCommonService.getTenantConfig("IS_READ_DELETE", tenantID);
			logger.debug("작동 1");
		
				for (String address : addresses) {
					logger.debug("작동2");
					//jobCode - 1:발견후 삭제, 2:발견하였으나 읽은 메일, 3:발견하지 못함
					//config.IS_READ_DELETE가 YES이면 읽은 메일도 삭제 (jobCode=1)
					String jobCode = "3";
					
					IMAPAccess ia = null;
					
					try {
						ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
								address, password, egovMessageSource, locale);
						Folder folder = null;
	
						if (childName.equals("")) {
							logger.debug("빈문자");
							i++;
							String mailboxName = mailbox.get(i);
							folder = ia.getFolder(mailboxName);
						} else {
							logger.debug("빈문자가 아닐경우 childName"+childName);
							folder = ia.getFolder(childName);
						}
						
						folder.open(Folder.READ_WRITE);
						SearchTerm searchTerm= new SearchTerm() {
							@Override
							public boolean match(Message message) {
								try {
									String thisMessageId = ((MimeMessage)message).getMessageID(); 
									
									if (thisMessageId != null && thisMessageId.contains(messageId)) {
										return true;
									}
								} catch (MessagingException e) {
									e.printStackTrace();
								}
								return false;
							}
						};
					
						Message[] messages = folder.getMessages();
						
						// pre-fetch fields needed for searching
						FetchProfile fp = new FetchProfile();
						fp.add(FetchProfile.Item.ENVELOPE);
						folder.fetch(messages, fp);
						
						messages = folder.search(searchTerm);
						
						if (messages.length > 0) { // 메일 발견
							if (messages[0].isSet(Flags.Flag.SEEN)) { //메일 읽음
								if (isReadDelete.equals("YES")) { //읽어도 지움
									jobCode = "1";
									messages[0].setFlag(Flags.Flag.DELETED, true);
								} else { //읽으면 안지움
									jobCode = "2";
								}
							} else { //메일 안읽음
								jobCode = "1";
								messages[0].setFlag(Flags.Flag.DELETED, true);
							} 
						} else {
							// 메일을 발견하지 못한 경우 
							Folder[] folderList = folder.list();
							
							if (folderList.length > 0) {
								for (int i1 = 0 ; i1 <= folderList.length; i1 ++) {
									String childFolderName = folderList[i1].toString();
									cancelMailDelete(num, tenantID, childFolderName);
								}
							} else {
								cancelMailDelete(num, tenantID, "");
							}
							
							cancelMailDelete(num, tenantID, "");
						}
						
						folder.close(true);
						ia.close();
						ia = null;
					
					} catch (MessagingException e) {
						e.printStackTrace();
						jobCode = "3";
					} finally {
						if (ia != null) {
							ia.close();
						}
					}
					
					logger.debug("address=" + address + ",jobCode=" + jobCode);
					receiveDetailList.add(new String[]{address, jobCode});
				}
				ezEmailService.updateMailReceiveDetailInfo(num, receiveDetailList);
		} catch (Exception e) {
			e.printStackTrace();
		  }
		logger.debug("cancelMailDelete async methoed ended.");
		}
	}

		