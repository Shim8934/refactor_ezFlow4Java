package egovframework.ezMobile.ezEmail.service.impl;

import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Properties;
import java.util.TimeZone;

import javax.annotation.Resource;
import javax.mail.Address;
import javax.mail.FetchProfile;
import javax.mail.Flags;
import javax.mail.Folder;
import javax.mail.Message;
import javax.mail.UIDFolder;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeUtility;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sun.mail.imap.IMAPFolder;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.logic.IMAPAccess;
import egovframework.ezEKP.ezEmail.util.EzEmailUtil;
import egovframework.ezMobile.ezEmail.service.MEmailService;
import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("MEmailService")
public class MEmailServiceImpl extends EgovAbstractServiceImpl implements MEmailService {

	private static final Logger LOGGER = LoggerFactory.getLogger(MEmailServiceImpl.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Resource(name = "EzCommonService")
    private EzCommonService ezCommonService;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Autowired
	private EzEmailUtil ezEmailUtil;
	
	@Autowired
	private Properties config;
	
	@Resource(name = "jspw")
    private String jspw;
	
	@Override
	public JSONArray getMainMailList(MCommonVO info, Locale locale, String filter, String listSize) {
        
		IMAPAccess ia = null;
        JSONArray messageJsonArray = new JSONArray();
        
		try {

			String folderId = "INBOX";
			String start = "0";
			String end = (Integer.parseInt(start) + Integer.parseInt(listSize) - 1) + "";
	        String userId = info.getUserId();
	      
	        LOGGER.debug("userID : " + userId+ ",folderId : " + folderId + ",listLength : " + listSize
	        		+"start : " + start+ ",end : " + end); 
	        
	        Message[] messages = null;
			
			
			String domainName = ezCommonService.getTenantConfig("DomainName", info.getTenantId());
			String userEmail = info.getUserId() + "@" + domainName;
			String password = jspw;

			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userEmail, password, egovMessageSource, locale);
					
			Folder folder = ia.getFolder(folderId);		
			folder.open(Folder.READ_ONLY);
	        UIDFolder uidFolder = (UIDFolder)folder;
	        
	        boolean isUnreadOnly = false;
	        boolean isImportantOnly = false;
	        
	        if (filter.equals("isUnreadOnly")) {
	        	LOGGER.debug("isUnreadOnly");
	        	isUnreadOnly = true;
	        	messages = ezEmailUtil.searchFolder(folder, "", "", null, null, false, null, isUnreadOnly, false);
	        	LOGGER.debug("isUnreadOnly unreadMessage : " + messages.length);
	        } 
	        
	        else if (filter.equals("isImportantOnly")) {
	        	isImportantOnly = true;
	        }
			
			if (messages == null) {
				messages = folder.getMessages();
			}
			
			ezEmailUtil.sortMessages(folder, messages, "receivedDate", false);
			//가장 최근에 받은 편지 순으로 정렬
			
			int startNo = Integer.parseInt(start);
			int endNo = Math.min(Integer.parseInt(end), messages.length - 1);
			
	
			LOGGER.debug("isUnreadOnly=" + isUnreadOnly + "isImportantOnly" + isImportantOnly);
							
			LOGGER.debug("unreadMessage Count=" + folder.getUnreadMessageCount());
			
			LOGGER.debug("startNo=" + startNo + ",endNo=" + endNo);
			
			if (startNo <= endNo) {
				Message[] fetchMessages = Arrays.copyOfRange(messages, startNo, endNo + 1);
				FetchProfile fp = new FetchProfile();
								
				fp.add(UIDFolder.FetchProfileItem.UID);
				fp.add("X-Priority");
				fp.add(FetchProfile.Item.CONTENT_INFO);
				fp.add(FetchProfile.Item.ENVELOPE);
				fp.add(IMAPFolder.FetchProfileItem.INTERNALDATE);
				fp.add(FetchProfile.Item.SIZE);
				fp.add(FetchProfile.Item.FLAGS);
				
				fp.add("Subject");
				fp.add("From");
				fp.add("To");
				
				folder.fetch(fetchMessages, fp);					
			}
			
			for (int i = startNo; i <= endNo; i++) {
				Message message = messages[i];
				
				JSONObject messageJson = new JSONObject();
				
				messageJson.put("href",folderId+"/"+uidFolder.getUID(message));
				messageJson.put("folderId",folderId);
				messageJson.put("messageId",uidFolder.getUID(message));
				messageJson.put("fromemail","");
								
				// importance
				String[] headers = message.getHeader("X-Priority");
				String header = headers != null ? headers[0] : "normal";
				int importance = 1;
				// startsWith is used since
				// there are cases like X-Priority: 1 (Highest) generated by Thunderbird.
				if (header.startsWith("1")) {
					importance = 2;
				}
				else if (header.startsWith("5")) {
					importance = 0;
				}
				messageJson.put("importance",importance);
				
				// Flagged is used for bookmark
				int flagged = 0;
				if (message.isSet(Flags.Flag.FLAGGED)) {
					flagged = 1;
				}
				messageJson.put("flag",flagged);
				
				// attachment
				boolean isAttached = IMAPAccess.hasAttachment(message);
				int attached = isAttached ? 1 : 0;
				messageJson.put("attach",attached);
				
				String addressStr = "";
							
				addressStr = ezEmailUtil.getFromNameOrAddressOfMessage(message);
				messageJson.put("sender",addressStr);
							
				// subject
				String subject = ezEmailUtil.getSubject(message);								
				subject = (subject != null) ? subject : "";
				
				if(subject.equals("")) {
					subject = "제목 없음";
				}
				
				messageJson.put("subject",subject);
				
				// received date
				Date receivedDate = message.getReceivedDate();
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
				sdf.setTimeZone(TimeZone.getTimeZone("GMT"));
				
				String receivedDateStr = sdf.format(receivedDate);
	        	receivedDateStr = commonUtil.getDateStringInUTC(receivedDateStr, info.getOffSet(), false);
				
				messageJson.put("receivedt",receivedDateStr);
				
				// size
				messageJson.put("size",message.getSize());
				
				// read/unread
				int readFlag = message.isSet(Flags.Flag.SEEN) ? 1 : 0;
				messageJson.put("read",readFlag);
							
				if (message.isSet(Flags.Flag.ANSWERED)) {
					messageJson.put("contentclass","REPLY");				}
				else {
					boolean isForwarded = ezEmailUtil.hasForwardedFlag(message);
					
					if (isForwarded) {
						messageJson.put("contentclass","FORWARD");
					}
					else {
						messageJson.put("contentclass","IPM.Note");
					}
				}
				messageJsonArray.add(messageJson);
			}
					
			folder.close(false);
		
		} catch (Exception e) {
			
			e.printStackTrace();
			
		} finally {
			if (ia != null) {
				ia.close();
			}
		}
		return messageJsonArray;
	}

	@Override
	public int getMainMailUnreadCount(MCommonVO info, Locale locale) {
		IMAPAccess ia = null;
		
		String folderId = "INBOX";
		try {
		String domainName = ezCommonService.getTenantConfig("DomainName", info.getTenantId());
		String userEmail = info.getUserId() + "@" + domainName;
		String password = jspw;

		ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
				userEmail, password, egovMessageSource, locale);
				
		Folder folder = ia.getFolder(folderId);	
		return folder.getUnreadMessageCount();
		} catch (Exception e) { 
		return -1;	
		}  finally {
			if (ia != null) {
				ia.close();
			}
		}
	}

	@Override
	public JSONArray getFolderList(MCommonVO info, Locale locale, String folderId) {
		LOGGER.debug("MEmailServiceImpl getFolderList started.");
		
		IMAPAccess ia = null;
//		List<MEmailFolderVO> mailFolderList = new ArrayList<MEmailFolderVO>();
		JSONArray malFolderList = new JSONArray();
		
		try {
		
			LOGGER.debug("folderId=" + folderId);
		
	
			String domainName = ezCommonService.getTenantConfig("DomainName", info.getTenantId());
			String userEmail = info.getUserId() + "@" + domainName;
			String password = jspw;

			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userEmail, password, egovMessageSource, locale);
			
			List<Folder> subMailFolder = null;
			
			if (folderId != null && !folderId.equals("")) {
				subMailFolder = ia.getSubFolders(folderId);
			} else {
				subMailFolder = ia.getTopLevelFolders();
			}
			
//			MEmailFolderVO folder = null;
			JSONObject folder = null;

			for (int i=0; i<subMailFolder.size(); i++) {
				Folder f = subMailFolder.get(i);
				folder = new JSONObject();	
//				folder = new MEmailFolderVO();
				folder.put("name", f.getName());
				folder.put("fullName", f.getFullName());
				folder.put("unreadCount", f.getUnreadMessageCount());
//				folder.setName(f.getName());
//				folder.setFullName(f.getFullName());
//				folder.setUnReadCount(f.getUnreadMessageCount());
				if (f.list().length > 0) {
					folder.put("hasSub", true);
//					folder.setHasSub(true);
				} else {
					folder.put("hasSub", false);
//					folder.setHasSub(false);
				}
//				mailFolderList.add(folder);
				malFolderList.add(folder);
			}
			
		} catch (Exception e) {
			
			e.printStackTrace();
			
		} finally {
			if (ia != null) {
				ia.close();
			}
		}
		
		LOGGER.debug("MEmailServiceImpl getFolderList ended.");
		
		return malFolderList;
	}

}
