package egovframework.ezEKP.ezEmail.logic;

import java.util.Properties;

import javax.mail.Folder;
import javax.mail.MessagingException;
import javax.mail.NoSuchProviderException;
import javax.mail.Session;
import javax.mail.Store;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class POP3Access {

    private static final Logger logger = LoggerFactory.getLogger(POP3Access.class);
    
	private String host;
	private String port;
	private Store store;
	private String userName;
	private String password;
	private String useSsl;
	private final int TIMEOUT = 20000;
	
	private POP3Access(String host, String port, String userName, String password, String useSsl){
		this.host = host;
		this.port = port;
		this.userName = userName;
		this.password = password;
		this.useSsl = useSsl;
	}

	private Store getStore(){
		if(store != null){
			return store;
		}
		try {
			Properties properties = new Properties();
			
			if (useSsl.equals("true")) {
				properties.put("mail.pop3s.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
				properties.put("mail.pop3s.socketFactory.fallback", "false");
				properties.put("mail.pop3s.socketFactory.port", port);
				properties.put("mail.store.protocol", "pop3s");
				properties.put("mail.pop3s.host", host);
				properties.put("mail.pop3s.port", port);
				properties.put("mail.pop3s.connectiontimeout", TIMEOUT);
				properties.put("mail.pop3s.timeout", TIMEOUT);
				properties.put("mail.pop3s.disabletop", "true");
				properties.put("mail.pop3s.disablecapa", "true");
				
				Session session = Session.getDefaultInstance(properties);
				
				store = session.getStore("pop3s");
				
			} else {
				properties.put("mail.pop3s.socketFactory.fallback", "false");
				properties.put("mail.pop3s.socketFactory.port", port);
				properties.put("mail.store.protocol", "pop3");
				properties.put("mail.pop3.host", host);
				properties.put("mail.pop3.port", port);
				properties.put("mail.pop3.connectiontimeout", TIMEOUT);
				properties.put("mail.pop3.timeout", TIMEOUT);
				properties.put("mail.pop3.disabletop", "true");
				properties.put("mail.pop3.disablecapa", "true");
				
				Session session = Session.getDefaultInstance(properties);
				
				store = session.getStore("pop3");
				
			}
			
			store.connect(host, Integer.parseInt(port), userName, password);
			
		} catch (NoSuchProviderException e) {
			logger.error("Error get store from session: " + e.getMessage());
			logger.error(e.getMessage(), e);
			close();
		}catch (MessagingException e) {
			logger.error("Error connect store: " + e.getMessage());
			logger.error(e.getMessage(), e);
			close();
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
	
	public static POP3Access getInstance(String host, String port, String username, String password, String useSsl){
		return new POP3Access(host, port, username, password, useSsl);
	}
	
	public boolean checkConnect() {
		boolean returnValue = false;
		
		if (getStore() != null) {
			returnValue = true;
		} else {
			returnValue = false;
		}
			
		return returnValue;
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
	
	
//	public int getUnreadCount(String folderName){
//		int unreadCount = 0;
//		try {
//			unreadCount = getStore().getFolder(folderName).getUnreadMessageCount();
//		} catch (MessagingException e) {
//			logger.error("Error get unread message count: " + e.getMessage());
//		}
//		return unreadCount;
//	}
//	
//	public void createFolder(String folderName, String folderPath) {
//		boolean isCreated = false;
//		
//		try {
//			Folder paraentFolder = null;
//			if (!folderPath.equals("")) {
//				paraentFolder = getStore().getFolder(folderPath);
//			} else {
//				paraentFolder = getStore().getDefaultFolder();
//			}
//			if (paraentFolder.exists()) {
//				if (!paraentFolder.getFolder(folderName).exists()) {
//					isCreated = paraentFolder.getFolder(folderName).create(Folder.HOLDS_FOLDERS|Folder.HOLDS_MESSAGES);
//					if (isCreated) {
//						logger.debug(folderName + " folder is created.");
//					}
//				}
//			}
//		} catch (MessagingException e) {
//			logger.error("Error create folder: " + e.getMessage());
//		}
//		
//	}
//	
//	public static boolean hasAttachment(Part part) {
//		boolean isAttached = false;
//		
//		try {
////			logger.debug("Content-Type=" + part.getContentType());
//			
//			// this is a multipart			
//			if (part.isMimeType("multipart/*")) {				
//		         Multipart mp = (Multipart)part.getContent();
//		         int count = mp.getCount();
//		         for (int i = 0; i < count; i++) {
//		        	 isAttached = hasAttachment(mp.getBodyPart(i));
//		        	 if (isAttached) {
//		        		 break;
//		        	 }
//		         }
//			}
//			// this is a nested message			
//			else if (part.isMimeType("message/rfc822")) {
//				hasAttachment((Part)part.getContent());
//			}
//			else if (part.getDisposition()!= null && part.getDisposition().equalsIgnoreCase(Part.ATTACHMENT)) {
//				isAttached = true;
//			}			
//		} catch (Exception e) {
//			logger.error(e.getMessage(), e);
//		} 		
//		
//		return isAttached;
//	}
//	
//	
//	public static class MessageSubjectComparator implements Comparator<Message> {
//		
//		Collator collator = Collator.getInstance();
//		
//		@Override
//		public int compare(Message m1, Message m2) {
//			String first = null;
//			String second = null;
//			try {
//				first = m1.getSubject();
//				second = m2.getSubject();
//			} catch (MessagingException e) {
//			}
//			
//			first = first != null ? first.trim() : "";
//			second = second != null ? second.trim() : "";
//			
//			int rc = collator.compare(first, second);
//			if (rc == 0) {
//				try {
//					Date d1 = m1.getReceivedDate();
//					Date d2 = m2.getReceivedDate();
//					if (d1 != null && d2 != null) {
//						rc = d1.compareTo(d2);
//					}
//				} catch (MessagingException e) {
//				}
//			}
//			
//			return rc;
//		}
//		
//	}	
//	
//	public static class MessageAddressComparator implements Comparator<Message> {
//		
//		private Collator collator = Collator.getInstance();
//		private Map<String, String> addressMap = new HashMap<String, String>();
//		private boolean isSender;
//		
//		public MessageAddressComparator(boolean isSender) {
//			this.isSender = isSender;
//		}
//		
//		private String getAddress(Message msg) {
//			String addressStr = null;
//			Address[] addresses = null;
//			try {
//				if (isSender) {
//					addresses = msg.getFrom();
//				}
//				else {
//					addresses = msg.getRecipients(Message.RecipientType.TO);
//				}
//			} catch (MessagingException e) {
//			}
//			if (addresses != null) {
//				if (isSender) {
//					addressStr = addressMap.get(addresses[0].toString());			
//					if (addressStr == null) {					
//						addressStr = ((InternetAddress)addresses[0]).getPersonal();
//						if (addressStr == null) {
//							addressStr = ((InternetAddress)addresses[0]).getAddress();
//						}
//						else {
//							try {
//								addressStr = MimeUtility.decodeText(addressStr);
//							} catch (UnsupportedEncodingException e) {
//								logger.error(e.getMessage(), e);
//							}
//						}					
//						
//						addressMap.put(addresses[0].toString(), addressStr);
//					}		
//				}
//				else {
//					String keyString = InternetAddress.toString(addresses);
//					addressStr = addressMap.get(keyString);			
//					if (addressStr == null) {		
//						StringBuilder addressBuilder = new StringBuilder();
//						for (Address address : addresses) {
//							addressStr = ((InternetAddress)address).getPersonal();
//							if (addressStr == null) {
//								addressStr = ((InternetAddress)address).getAddress();
//							}
//							else {
//								try {
//									addressStr = MimeUtility.decodeText(addressStr);
//								} catch (UnsupportedEncodingException e) {
//									logger.error(e.getMessage(), e);
//								}
//							}			
//							addressBuilder.append(addressStr);
//							addressBuilder.append("; ");							
//						}
//						addressStr = addressBuilder.toString();
//						addressStr = addressStr.substring(0, addressStr.length() - 2);						
//						
//						addressMap.put(keyString, addressStr);
//					}		
//				}
//			}
//			else {
//				addressStr = "";
//			}
//			
//			return addressStr;
//		}
//		
//		@Override
//		public int compare(Message m1, Message m2) {			
//			String first = getAddress(m1);
//			String second = getAddress(m2);
//			
//			first = first != null ? first.trim() : "";
//			second = second != null ? second.trim() : "";
//			
//			int rc = collator.compare(first, second);
//			if (rc == 0) {
//				try {
//					Date d1 = m1.getReceivedDate();
//					Date d2 = m2.getReceivedDate();
//					if (d1 != null && d2 != null) {
//						rc = d1.compareTo(d2);
//					}
//				} catch (MessagingException e) {
//				}
//			}
//			
//			return rc;
//		}
//		
//	}	
//	
//	public static class MessageAttachmentComparator implements Comparator<Message> {
//				
//		@Override
//		public int compare(Message m1, Message m2) {
//			int attached1 = hasAttachment(m1) ? 1 : 0;
//			int attached2 = hasAttachment(m2) ? 1 : 0;
//						
//			int rc = attached1 - attached2;
//			if (rc == 0) {
//				try {
//					Date d1 = m1.getReceivedDate();
//					Date d2 = m2.getReceivedDate();
//					if (d1 != null && d2 != null) {
//						rc = d1.compareTo(d2);
//					}
//				} catch (MessagingException e) {
//				}
//			}
//			
//			return rc;
//		}
//		
//	}	
//	
//	public static class MessageUnreadComparator implements Comparator<Message> {
//				
//		@Override
//		public int compare(Message m1, Message m2) {
//			int unread1 = 0;
//			int unread2 = 0;
//			try {
//				unread1 = !m1.isSet(Flags.Flag.SEEN) ? 1 : 0;
//				unread2 = !m2.isSet(Flags.Flag.SEEN) ? 1 : 0;
//			} catch (MessagingException e1) {
//			}
//						
//			int rc = unread1 - unread2;
//			if (rc == 0) {
//				try {
//					Date d1 = m1.getReceivedDate();
//					Date d2 = m2.getReceivedDate();
//					if (d1 != null && d2 != null) {
//						rc = d1.compareTo(d2);
//					}
//				} catch (MessagingException e) {
//				}
//			}
//			
//			return rc;
//		}
//		
//	}	
//	
//	public static class MessageFlaggedComparator implements Comparator<Message> {
//		
//		@Override
//		public int compare(Message m1, Message m2) {
//			int flagged1 = 0;
//			int flagged2 = 0;
//			try {
//				flagged1 = m1.isSet(Flags.Flag.FLAGGED) ? 1 : 0;
//				flagged2 = m2.isSet(Flags.Flag.FLAGGED) ? 1 : 0;
//			} catch (MessagingException e1) {
//			}
//						
//			int rc = flagged1 - flagged2;
//			if (rc == 0) {
//				try {
//					Date d1 = m1.getReceivedDate();
//					Date d2 = m2.getReceivedDate();
//					if (d1 != null && d2 != null) {
//						rc = d1.compareTo(d2);
//					}
//				} catch (MessagingException e) {
//				}
//			}
//			
//			return rc;
//		}
//		
//	}	
//	
//	public static class MessagePriorityComparator implements Comparator<Message> {
//		
//		private int getPriority(Message msg) {
//			String[] headers = null;
//			try {
//				headers = msg.getHeader("X-Priority");
//			} catch (MessagingException e) {
//			}
//			String header = headers != null ? headers[0] : "normal";
//			int importance = 1;
//			// startsWith is used since
//			// there are cases like X-Priority: 1 (Highest) generated by Thunderbird.			
//			if (header.startsWith("1")) {
//				importance = 2;
//			}
//			else if (header.startsWith("5")) {
//				importance = 0;
//			}			
//			
//			return importance;
//		}
//		
//		@Override
//		public int compare(Message m1, Message m2) {
//			int priority1 = getPriority(m1);	
//			int priority2 = getPriority(m2);
//			
//			int rc = priority1 - priority2;
//			if (rc == 0) {
//				try {
//					Date d1 = m1.getReceivedDate();
//					Date d2 = m2.getReceivedDate();
//					if (d1 != null && d2 != null) {
//						rc = d1.compareTo(d2);
//					}
//				} catch (MessagingException e) {
//				}
//			}
//			
//			return rc;
//		}
//		
//	}	
//	
//	public static class MessageSizeComparator implements Comparator<Message> {
//		
//		@Override
//		public int compare(Message m1, Message m2) {
//			int size1 = 0;
//			int size2 = 0;
//			try {
//				size1 = m1.getSize();
//				size2 = m2.getSize();
//			} catch (MessagingException e1) {
//			}
//						
//			int rc = size1 - size2;
//			if (rc == 0) {
//				try {
//					Date d1 = m1.getReceivedDate();
//					Date d2 = m2.getReceivedDate();
//					if (d1 != null && d2 != null) {
//						rc = d1.compareTo(d2);
//					}
//				} catch (MessagingException e) {
//				}
//			}
//			
//			return rc;
//		}
//		
//	}	
//	
//	public static class MessageReceivedDateComparator implements Comparator<Message> {
//		
//		@Override
//		public int compare(Message m1, Message m2) {
//			int rc = 0;
//			try {
//				Date d1 = m1.getReceivedDate();
//				Date d2 = m2.getReceivedDate();
//				if (d1 != null && d2 != null) {
//					rc = d1.compareTo(d2);
//				}
//			} catch (MessagingException e) {
//			}
//			
//			return rc;
//		}
//		
//	}		
	
}
