package egovframework.ezEKP.ezEmail.logic;

import java.io.UnsupportedEncodingException;
import java.text.Collator;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;

import javax.mail.Address;
import javax.mail.Flags;
import javax.mail.Folder;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Multipart;
import javax.mail.NoSuchProviderException;
import javax.mail.Part;
import javax.mail.Quota;
import javax.mail.Session;
import javax.mail.Store;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeUtility;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.sun.mail.imap.IMAPStore;

import egovframework.com.cmm.EgovMessageSource;

public class IMAPAccess {

    private static final Logger logger = LoggerFactory.getLogger(IMAPAccess.class);
    
	private String host;
	private String port;
	private Store store;
	private String userName;
	private String password;
	private EgovMessageSource egovMessageSource;
	private Locale locale;
	private int timeout = 20000;
	private int connectionTimeout = 20000;
	
	private IMAPAccess(String host, String port, String userName, String password, EgovMessageSource egovMessageSource, Locale locale){
		this.host = host;
		this.port = port;
		this.userName = userName;
		this.password = password;
		this.egovMessageSource = egovMessageSource;
		this.locale = locale;
	}
	
	private IMAPAccess(String host, String port, String userName, String password, EgovMessageSource egovMessageSource, Locale locale, int timeout, int connectionTimeout){
		this.host = host;
		this.port = port;
		this.userName = userName;
		this.password = password;
		this.egovMessageSource = egovMessageSource;
		this.timeout = timeout;
		this.connectionTimeout = connectionTimeout;
	}
	
	private Store getStore(){
		if(store != null){
			return store;
		}
		try {
			Properties properties = new Properties();
			properties.put("mail.imap.host", host);
			properties.put("mail.imap.port", port);

			//If set to true, failure to create a socket using the specified socket factory class will 
			//cause the socket to be created using the java.net.Socket class. Defaults to true.
			properties.setProperty("mail.imap.socketFactory.fallback", "false");
			properties.setProperty("mail.imap.socketFactory.port", port);
			
			// these properties are required to be set to false, otherwise
			// big mail body part(in-line image, attachment, etc) fetching may be very slow.
			properties.setProperty("mail.imap.partialfetch", "false");
			properties.setProperty("mail.imaps.partialfetch", "false");
			
			properties.put("mail.imap.connectiontimeout", connectionTimeout);
			properties.put("mail.imap.timeout", timeout);
			
			Session session = Session.getInstance(properties);

			store = session.getStore("imap");
			store.connect(userName, password);
		} catch (NoSuchProviderException e) {
			logger.error("Error get store from session: " + e.getMessage());
			e.printStackTrace();
		}catch (MessagingException e) {
			logger.error("Error connect store: " + e.getMessage());
		}
		return store;
	}

	public void close(){
		try {
			if(store != null){
				store.close();
				store = null;
			}
		} catch (MessagingException e) {
			logger.error("Error close store: " + e.getMessage());
		}
	}
	
	public List<Folder> getTopLevelFolders() {
		ArrayList<Folder> topLevelFolders = new ArrayList<Folder>();
		
		try{
			Store store = getStore();
			if(!store.getDefaultFolder().getFolder(egovMessageSource.getMessage("ezEmail.t99000084", locale)).exists()){
				store.getDefaultFolder().getFolder(egovMessageSource.getMessage("ezEmail.t99000084", locale)).create(Folder.HOLDS_FOLDERS|Folder.HOLDS_MESSAGES);
				logger.debug(egovMessageSource.getMessage("ezEmail.t99000084", locale) + " created");
			}
			if(!store.getDefaultFolder().getFolder(egovMessageSource.getMessage("ezEmail.t99000026", locale)).exists()){
				store.getDefaultFolder().getFolder(egovMessageSource.getMessage("ezEmail.t99000026", locale)).create(Folder.HOLDS_FOLDERS|Folder.HOLDS_MESSAGES);
				logger.debug(egovMessageSource.getMessage("ezEmail.t99000026", locale) + " created");
			}
			if(!store.getDefaultFolder().getFolder(egovMessageSource.getMessage("ezEmail.t99000027", locale)).exists()){
				store.getDefaultFolder().getFolder(egovMessageSource.getMessage("ezEmail.t99000027", locale)).create(Folder.HOLDS_FOLDERS|Folder.HOLDS_MESSAGES);
				logger.debug(egovMessageSource.getMessage("ezEmail.t99000027", locale) + " created");
			}
			if(!store.getDefaultFolder().getFolder(egovMessageSource.getMessage("ezEmail.t99000028", locale)).exists()){
				store.getDefaultFolder().getFolder(egovMessageSource.getMessage("ezEmail.t99000028", locale)).create(Folder.HOLDS_FOLDERS|Folder.HOLDS_MESSAGES);
				logger.debug(egovMessageSource.getMessage("ezEmail.t99000028", locale) + " created");
			}
			if(!store.getDefaultFolder().getFolder(egovMessageSource.getMessage("ezEmail.t648", locale)).exists()){
				store.getDefaultFolder().getFolder(egovMessageSource.getMessage("ezEmail.t648", locale)).create(Folder.HOLDS_FOLDERS|Folder.HOLDS_MESSAGES);
				logger.debug(egovMessageSource.getMessage("ezEmail.t648", locale) + " created");
			}
			
			Folder[] f = getStore().getDefaultFolder().list();
			
			for(Folder fd : f){
				if(fd.getName().equalsIgnoreCase(egovMessageSource.getMessage("ezEmail.t99000084", locale))){
					topLevelFolders.add(fd);
					break;
				}
			}
			for(Folder fd : f){
				if(fd.getName().equalsIgnoreCase(egovMessageSource.getMessage("ezEmail.t99000026", locale))){
					topLevelFolders.add(fd);
					break;
				}
			}
			for(Folder fd : f){
				if(fd.getName().equalsIgnoreCase(egovMessageSource.getMessage("ezEmail.t99000027", locale))){
					topLevelFolders.add(fd);
					break;
				}
			}
			for(Folder fd : f){
				if(fd.getName().equalsIgnoreCase(egovMessageSource.getMessage("ezEmail.t99000028", locale))){
					topLevelFolders.add(fd);
					break;
				}
			}
			for(Folder fd : f){
				if(fd.getName().equalsIgnoreCase(egovMessageSource.getMessage("ezEmail.t648", locale))){
					topLevelFolders.add(fd);
					break;
				}
			}
			for(Folder fd : f){
				if(!fd.getName().equalsIgnoreCase(egovMessageSource.getMessage("ezEmail.t99000084", locale))&&!fd.getName().equalsIgnoreCase(egovMessageSource.getMessage("ezEmail.t99000026", locale))&&!fd.getName().equalsIgnoreCase(egovMessageSource.getMessage("ezEmail.t99000027", locale))&&
						!fd.getName().equalsIgnoreCase(egovMessageSource.getMessage("ezEmail.t99000028", locale))&&!fd.getName().equalsIgnoreCase(egovMessageSource.getMessage("ezEmail.t648", locale))){
					topLevelFolders.add(fd);
				}
			}
		} catch(MessagingException e){
			logger.error("Error get default folder: " + e.getMessage());
		}
		return topLevelFolders;
	}
	
	public List<Folder> getSubFolders(String parent){
		ArrayList<Folder> subFolders = new ArrayList<Folder>();
		try {
			Folder[] f = getStore().getFolder(parent).list();
			for(Folder fd : f){
				subFolders.add(fd);
			}
		} catch (MessagingException e) {
			logger.error("Error get sub folder: " + e.getMessage());
		}
		return subFolders;
	}

	public int getUnreadCount(String folderName){
		int unreadCount = 0;
		try {
			unreadCount = getStore().getFolder(folderName).getUnreadMessageCount();
		} catch (MessagingException e) {
			logger.error("Error get unread message count: " + e.getMessage());
		}
		return unreadCount;
	}
	
	public Folder getFolder(String folderName) {
		Folder folder = null;
		
		try {
			folder = getStore().getFolder(folderName);
		} catch (MessagingException e) {
			logger.error("Error get folder: " + e.getMessage());
		}
		
		return folder;
	}
	
	public Quota[] getQuota(String folder) {
		IMAPStore imapStore = (IMAPStore)getStore();
		Quota[] quotas = null;
		
		try {
			quotas = imapStore.getQuota(folder);
		} catch (MessagingException e) {
			e.printStackTrace();
		}
		
		return quotas;
	}
	
	public long[] getStorageUsageAndLimit() {
		long[] returnValues = null;
		
		Quota[] quotas = getQuota("INBOX");		
		
		if (quotas != null) {
			for (Quota quota : quotas) {
				Quota.Resource[] resources = quota.resources;
	
				for (Quota.Resource resource : resources) {
					if (resource.name.equals("STORAGE")) {
						returnValues = new long[] {resource.usage, resource.limit};
					}
				}
			}
		}
		
		return returnValues;
	}
	
	public void createFolder(String folderName, String folderPath) {
		boolean isCreated = false;
		
		try {
			Folder paraentFolder = null;
			if (!folderPath.equals("")) {
				paraentFolder = getStore().getFolder(folderPath);
			} else {
				paraentFolder = getStore().getDefaultFolder();
			}
			if (paraentFolder.exists()) {
				if (!paraentFolder.getFolder(folderName).exists()) {
					isCreated = paraentFolder.getFolder(folderName).create(Folder.HOLDS_FOLDERS|Folder.HOLDS_MESSAGES);
					if (isCreated) {
						logger.debug(folderName + " folder is created.");
					}
				}
			}
		} catch (MessagingException e) {
			logger.error("Error create folder: " + e.getMessage());
		}
		
	}
	
	public static boolean hasAttachment(Part part) {
		boolean isAttached = false;
		
		try {
//			logger.debug("Content-Type=" + part.getContentType());
			
			// this is a multipart			
			if (part.isMimeType("multipart/*")) {				
		         Multipart mp = (Multipart)part.getContent();
		         int count = mp.getCount();
		         for (int i = 0; i < count; i++) {
		        	 isAttached = hasAttachment(mp.getBodyPart(i));
		        	 if (isAttached) {
		        		 break;
		        	 }
		         }
			}
			// this is a nested message			
			else if (part.isMimeType("message/rfc822")) {
				hasAttachment((Part)part.getContent());
			}
			else if (part.getDisposition()!= null && part.getDisposition().equalsIgnoreCase(Part.ATTACHMENT)) {
				isAttached = true;
			}			
		} catch (Exception e) {
			e.printStackTrace();
		} 		
		
		return isAttached;
	}
	
	public static IMAPAccess getInstance(String host, String port, String username, String password, EgovMessageSource egovMessageSource, Locale locale){
		return new IMAPAccess(host, port, username, password, egovMessageSource, locale);
	}
	
	public static IMAPAccess getInstance(String host, String port, String username, String password, EgovMessageSource egovMessageSource, Locale locale, int timeout, int connectionTimeout){
		return new IMAPAccess(host, port, username, password, egovMessageSource, locale, timeout, connectionTimeout);
	}
	
	public static class MessageSubjectComparator implements Comparator<Message> {
		
		Collator collator = Collator.getInstance();
		
		@Override
		public int compare(Message m1, Message m2) {
			String first = null;
			String second = null;
			try {
				first = m1.getSubject();
				second = m2.getSubject();
			} catch (MessagingException e) {
			}
			
			first = first != null ? first.trim() : "";
			second = second != null ? second.trim() : "";
			
			int rc = collator.compare(first, second);
			if (rc == 0) {
				try {
					Date d1 = m1.getReceivedDate();
					Date d2 = m2.getReceivedDate();
					if (d1 != null && d2 != null) {
						rc = d1.compareTo(d2);
					}
				} catch (MessagingException e) {
				}
			}
			
			return rc;
		}
		
	}	
	
	public static class MessageAddressComparator implements Comparator<Message> {
		
		private Collator collator = Collator.getInstance();
		private Map<String, String> addressMap = new HashMap<String, String>();
		private boolean isSender;
		
		public MessageAddressComparator(boolean isSender) {
			this.isSender = isSender;
		}
		
		private String getAddress(Message msg) {
			String addressStr = null;
			Address[] addresses = null;
			try {
				if (isSender) {
					addresses = msg.getFrom();
				}
				else {
					addresses = msg.getRecipients(Message.RecipientType.TO);
				}
			} catch (MessagingException e) {
			}
			if (addresses != null) {
				if (isSender) {
					addressStr = addressMap.get(addresses[0].toString());			
					if (addressStr == null) {					
						addressStr = ((InternetAddress)addresses[0]).getPersonal();
						if (addressStr == null) {
							addressStr = ((InternetAddress)addresses[0]).getAddress();
						}
						else {
							try {
								addressStr = MimeUtility.decodeText(addressStr);
							} catch (UnsupportedEncodingException e) {
								e.printStackTrace();
							}
						}					
						
						addressMap.put(addresses[0].toString(), addressStr);
					}		
				}
				else {
					String keyString = InternetAddress.toString(addresses);
					addressStr = addressMap.get(keyString);			
					if (addressStr == null) {		
						StringBuilder addressBuilder = new StringBuilder();
						for (Address address : addresses) {
							addressStr = ((InternetAddress)address).getPersonal();
							if (addressStr == null) {
								addressStr = ((InternetAddress)address).getAddress();
							}
							else {
								try {
									addressStr = MimeUtility.decodeText(addressStr);
								} catch (UnsupportedEncodingException e) {
									e.printStackTrace();
								}
							}			
							addressBuilder.append(addressStr);
							addressBuilder.append("; ");							
						}
						addressStr = addressBuilder.toString();
						addressStr = addressStr.substring(0, addressStr.length() - 2);						
						
						addressMap.put(keyString, addressStr);
					}		
				}
			}
			else {
				addressStr = "";
			}
			
			return addressStr;
		}
		
		@Override
		public int compare(Message m1, Message m2) {			
			String first = getAddress(m1);
			String second = getAddress(m2);
			
			first = first != null ? first.trim() : "";
			second = second != null ? second.trim() : "";
			
			int rc = collator.compare(first, second);
			if (rc == 0) {
				try {
					Date d1 = m1.getReceivedDate();
					Date d2 = m2.getReceivedDate();
					if (d1 != null && d2 != null) {
						rc = d1.compareTo(d2);
					}
				} catch (MessagingException e) {
				}
			}
			
			return rc;
		}
		
	}	
	
	public static class MessageAttachmentComparator implements Comparator<Message> {
				
		@Override
		public int compare(Message m1, Message m2) {
			int attached1 = hasAttachment(m1) ? 1 : 0;
			int attached2 = hasAttachment(m2) ? 1 : 0;
						
			int rc = attached1 - attached2;
			if (rc == 0) {
				try {
					Date d1 = m1.getReceivedDate();
					Date d2 = m2.getReceivedDate();
					if (d1 != null && d2 != null) {
						rc = d1.compareTo(d2);
					}
				} catch (MessagingException e) {
				}
			}
			
			return rc;
		}
		
	}	
	
	public static class MessageUnreadComparator implements Comparator<Message> {
				
		@Override
		public int compare(Message m1, Message m2) {
			int unread1 = 0;
			int unread2 = 0;
			try {
				unread1 = !m1.isSet(Flags.Flag.SEEN) ? 1 : 0;
				unread2 = !m2.isSet(Flags.Flag.SEEN) ? 1 : 0;
			} catch (MessagingException e1) {
			}
						
			int rc = unread1 - unread2;
			if (rc == 0) {
				try {
					Date d1 = m1.getReceivedDate();
					Date d2 = m2.getReceivedDate();
					if (d1 != null && d2 != null) {
						rc = d1.compareTo(d2);
					}
				} catch (MessagingException e) {
				}
			}
			
			return rc;
		}
		
	}	
	
	public static class MessageFlaggedComparator implements Comparator<Message> {
		
		@Override
		public int compare(Message m1, Message m2) {
			int flagged1 = 0;
			int flagged2 = 0;
			try {
				flagged1 = m1.isSet(Flags.Flag.FLAGGED) ? 1 : 0;
				flagged2 = m2.isSet(Flags.Flag.FLAGGED) ? 1 : 0;
			} catch (MessagingException e1) {
			}
						
			int rc = flagged1 - flagged2;
			if (rc == 0) {
				try {
					Date d1 = m1.getReceivedDate();
					Date d2 = m2.getReceivedDate();
					if (d1 != null && d2 != null) {
						rc = d1.compareTo(d2);
					}
				} catch (MessagingException e) {
				}
			}
			
			return rc;
		}
		
	}	
	
	public static class MessagePriorityComparator implements Comparator<Message> {
		
		private int getPriority(Message msg) {
			String[] headers = null;
			try {
				headers = msg.getHeader("X-Priority");
			} catch (MessagingException e) {
			}
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
			
			return importance;
		}
		
		@Override
		public int compare(Message m1, Message m2) {
			int priority1 = getPriority(m1);	
			int priority2 = getPriority(m2);
			
			int rc = priority1 - priority2;
			if (rc == 0) {
				try {
					Date d1 = m1.getReceivedDate();
					Date d2 = m2.getReceivedDate();
					if (d1 != null && d2 != null) {
						rc = d1.compareTo(d2);
					}
				} catch (MessagingException e) {
				}
			}
			
			return rc;
		}
		
	}	
	
	public static class MessageSizeComparator implements Comparator<Message> {
		
		@Override
		public int compare(Message m1, Message m2) {
			int size1 = 0;
			int size2 = 0;
			try {
				size1 = m1.getSize();
				size2 = m2.getSize();
			} catch (MessagingException e1) {
			}
						
			int rc = size1 - size2;
			if (rc == 0) {
				try {
					Date d1 = m1.getReceivedDate();
					Date d2 = m2.getReceivedDate();
					if (d1 != null && d2 != null) {
						rc = d1.compareTo(d2);
					}
				} catch (MessagingException e) {
				}
			}
			
			return rc;
		}
		
	}	
	
	public static class MessageReceivedDateComparator implements Comparator<Message> {
		
		@Override
		public int compare(Message m1, Message m2) {
			int rc = 0;
			try {
				Date d1 = m1.getReceivedDate();
				Date d2 = m2.getReceivedDate();
				if (d1 != null && d2 != null) {
					rc = d1.compareTo(d2);
				}
			} catch (MessagingException e) {
			}
			
			return rc;
		}
		
	}		
	
}
