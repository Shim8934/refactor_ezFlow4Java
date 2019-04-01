package egovframework.ezEKP.ezEmail.task;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
import javax.mail.FetchProfile;
import javax.mail.Flags;
import javax.mail.Folder;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;
import javax.mail.search.SearchTerm;

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
			recallMailByMessageId(addresses, password, messageId, num, locale, searchTerm, isReadDelete);
			
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
	
	private void recallMailByMessageId(List<String> recallMailList, String password, String messageId, String num, Locale locale,
					SearchTerm searchTerm, boolean isReadDelete) {
		IMAPAccess ia = null;
		String address = "";
		String folderName = "";
		String mailboxId = "";
		long mailUid = 0;
		String senderEmail = "";
		
		String senderSentMailBoxName = ezEmailUtil.getSentFolderId(locale);
		String senderDraftMailBoxName = ezEmailUtil.getDraftsFolderId(locale);
		
		for (int i =0; i < recallMailList.size(); i++ ) {
			int jobCode = 3;	// jobCode ( 1:발견후 삭제, 2:발견하였으나 읽은 메일, 3:발견하지 못함 )
			ArrayList<Map<String,String>> personMail = new ArrayList<Map<String,String>>();
			address = recallMailList.get(i);
			JSONObject object;
			try {
				object = ezEmailService.recallMailByMessageId(address, messageId);
				personMail = (ArrayList<Map<String, String>>) object.get("result");
			} catch (Exception e1) {
				jobCode = 3;
				e1.printStackTrace();
				logger.debug("recallMailByMessageId select error.");
				continue;
			}
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"),
					config.getProperty("config.IMAPPort"), address, password, egovMessageSource, locale, ezEmailUtil);
				        	
			for (int j =0; j <personMail.size(); j ++ ) {
				folderName = personMail.get(j).get("mailboxName");
				mailboxId = personMail.get(j).get("mailboxId");
				mailUid = Long.parseLong(personMail.get(j).get("mailUid"));
				senderEmail = personMail.get(j).get("senderEmail");
				
				Folder folder = ia.getFolder(folderName);
				
				if (senderEmail.equals(address) && (folderName.equals(senderDraftMailBoxName) || folderName.equals(senderSentMailBoxName))) {
					logger.debug("this mailbox is sender mailbox Draft or Sent. ");
					continue;
				}
					
				try {
					if (folder.exists()) {
						folder.open(Folder.READ_WRITE);
						Message message = null;
							message = ((IMAPFolder)folder).getMessageByUID(mailUid);
						
						if (message.isSet(Flags.Flag.SEEN)) { 				// 이미 사용자가 읽었는지 판단 
							if (isReadDelete) {								// 읽어도 회수 
								message.setFlag(Flags.Flag.DELETED, true);	// 상태 delete로 바꿈
								//jobCode:2 - 사용자의 다른 편지함에 있던 메일을 읽어 읽음으로 처리 되었음을 의미 
								if (jobCode != 2) {							// 아직 jobCode가 찾지못함 상태일때 
									jobCode = 1;							// 찾았고 status 회수 : 1
								}
							} else {										// 읽었으면 회수 하지 마라
								jobCode = 2;								// 이미 읽은 파일이라 회수하지 못함 
							}
						} else {											// 읽지 않았다
							message.setFlag(Flags.Flag.DELETED, true);	
							if (jobCode != 2) {								// 아직 jobCode가 찾지못함 상태였을때 
								jobCode = 1;								// 이미 읽은 파일이라 회수하지 못함 
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
			try {
				logger.debug("address=" + address + ",jobCode=" + jobCode + ",messageId=" + messageId + ",num=" + num);
				ezEmailService.updateMailReceiveDetailInfo(num, new String[] {address, String.valueOf(jobCode)});
			} catch (Exception e) {
				e.printStackTrace();
				logger.debug("updateMailReceivedDetailInfo update error. ");
			}
			ia.close();
			ia = null;
		}
	}
}


