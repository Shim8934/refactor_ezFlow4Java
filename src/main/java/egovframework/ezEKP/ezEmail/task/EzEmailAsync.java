package egovframework.ezEKP.ezEmail.task;

import java.util.List;
import java.util.Locale;
import java.util.Properties;

import javax.annotation.Resource;
import javax.mail.FetchProfile;
import javax.mail.Flags;
import javax.mail.Folder;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.search.SearchTerm;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Component;

import com.sun.mail.imap.IMAPFolder;

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
	public void cancelMailDelete(String num, int tenantID, Locale locale) {
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
						
			String isReadDeleteStr = ezCommonService.getTenantConfig("IS_READ_DELETE", tenantID);
			boolean isReadDelete = false;

			if (isReadDeleteStr.equals("YES")) {
				isReadDelete = true;
			}
			
			recallMailByMessageId(addresses, password, messageId, num, locale, isReadDelete);
			
		} catch (Exception e) {
			e.printStackTrace();
		}

		logger.debug("cancelMailDelete async methoed ended.");
	}
	
	private void recallMailByMessageId(List<String> recallMailList, String password, String messageId, String num, Locale locale, boolean isReadDelete) {
		IMAPAccess ia = null;
		JSONObject recallMailInfo = null;
		String senderEmail = null;
		JSONArray mailList = null;
		JSONObject mailInfo = null;
		String folderName = null;
		long mailUid = 0;
		
		String senderSentMailBoxName = ezEmailUtil.getSentFolderId(locale);
		String senderDraftMailBoxName = ezEmailUtil.getDraftsFolderId(locale);
		
		for (String address : recallMailList) {
			try {
				int jobCode = 3; // jobCode (1:발견후 삭제, 2:발견하였으나 읽은 메일, 3:발견하지 못함)
				
				recallMailInfo = ezEmailService.recallMailByMessageId(address, messageId);
				
				if (recallMailInfo == null) {
					logger.debug("Get recallMailInfo failed. Move to the next user...");
					continue;
				}
				
				senderEmail = (String) recallMailInfo.get("senderEmail");
				mailList = (JSONArray) recallMailInfo.get("mailList");
				
				ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"),
						config.getProperty("config.IMAPPort"), address, password, egovMessageSource, locale, ezEmailUtil);
					        	
				for (int i = 0; i < mailList.size(); i++) {
					mailInfo = (JSONObject) mailList.get(i);
					folderName = (String) mailInfo.get("mailboxName");
					mailUid = (long) mailInfo.get("mailUid");
					
					if (senderEmail.equals(address) && (folderName.equals(senderDraftMailBoxName) || folderName.equals(senderSentMailBoxName))) {
						logger.debug("This mailbox is sender mailbox Draft or Sent.");
						continue;
					}
					
					Folder folder = ia.getFolder(folderName);
					
					try {
						if (folder.exists()) {
							folder.open(Folder.READ_WRITE);
							Message message = ((IMAPFolder)folder).getMessageByUID(mailUid);
							
							// 사용자가 메일을 복사하여 같은 메일이 여러개 있고 isReadDelete가 true일 경우(읽어도 회수)
							// 읽은 메일은 회수하지 않고, 읽지 않은 메일은 모두 회수한다.
							// 읽은 메일이 하나라도 있을 경우 읽음으로 처리한다.
							if (message.isSet(Flags.Flag.SEEN)) {               // 사용자가 메일을 읽었을 경우
								if (isReadDelete) {                             // 읽어도 회수할 경우
									message.setFlag(Flags.Flag.DELETED, true);  // 메일 삭제
									jobCode = 1;                                // 회수 처리
								} else {                                        // 읽은 메일 회수하지 않을 경우
									jobCode = 2;                                // 읽음 처리
								}
							} else {                                            // 사용자가 메일을 읽지 않았을 경우
								message.setFlag(Flags.Flag.DELETED, true);      // 메일 삭제
								
								if (jobCode != 2) {                             // 읽음 처리가 안되었을 경우
									jobCode = 1;                                // 회수 처리
								}
							}
							
							folder.close(true);
						}
					} catch (MessagingException e) {
						e.printStackTrace();
						logger.debug("mail Flags update error. so move the next mailbox.");
						continue;
					}
				}
				
				logger.debug("address=" + address + ",jobCode=" + jobCode + ",messageId=" + messageId + ",num=" + num);
				ezEmailService.updateMailReceiveDetailInfo(num, new String[] {address, String.valueOf(jobCode)});
				
				ia.close();
				ia = null;
			
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				if (ia != null) {
					ia.close();
				}
			}
		}
	}
}


