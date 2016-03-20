package egovframework.ezEKP.ezEmail.logic;

import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

import javax.mail.Folder;
import javax.mail.MessagingException;
import javax.mail.Multipart;
import javax.mail.NoSuchProviderException;
import javax.mail.Part;
import javax.mail.Session;
import javax.mail.Store;
import javax.mail.internet.MimeBodyPart;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class IMAPAccess {

    private static final Logger logger = LoggerFactory.getLogger(IMAPAccess.class);
    
	private String host;
	private String port;
	private Store store;
	private String userName;
	private String password;

	private IMAPAccess(String host, String port, String username, String password){
		this.host = host;
		this.port = port;
		this.userName = username;
		this.password = password;		
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
			properties.setProperty("mail.imap.socketFactory.port", String.valueOf(port));
			Session session = Session.getDefaultInstance(properties);

			store = session.getStore("imap");
			store.connect(userName, password);
		} catch (NoSuchProviderException e) {
			System.out.println("Error get store from session: " + e.getMessage());
			e.printStackTrace();
		}catch (MessagingException e) {
			System.out.println("Error connect store: " + e.getMessage());
			e.printStackTrace();
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
			System.out.println("Error close store: " + e.getMessage());
			e.printStackTrace();
		}
	}
	
	public List<Folder> getTopLevelFolders() {
		ArrayList<Folder> topLevelFolders = new ArrayList<Folder>();
		
		try{
			Store store = getStore();
			if(!store.getDefaultFolder().getFolder("INBOX").exists()){
				store.getDefaultFolder().getFolder("INBOX").create(Folder.HOLDS_FOLDERS|Folder.HOLDS_MESSAGES);
				System.out.println("INBOX created");
			}
			if(!store.getDefaultFolder().getFolder("보낸 편지함").exists()){
				store.getDefaultFolder().getFolder("보낸 편지함").create(Folder.HOLDS_FOLDERS|Folder.HOLDS_MESSAGES);
				System.out.println("보낸 편지함 created");
			}
			if(!store.getDefaultFolder().getFolder("임시 보관함").exists()){
				store.getDefaultFolder().getFolder("임시 보관함").create(Folder.HOLDS_FOLDERS|Folder.HOLDS_MESSAGES);
				System.out.println("임시 보관함 created");
			}
			if(!store.getDefaultFolder().getFolder("지운 편지함").exists()){
				store.getDefaultFolder().getFolder("지운 편지함").create(Folder.HOLDS_FOLDERS|Folder.HOLDS_MESSAGES);
				System.out.println("지운 편지함 created");
			}
			if(!store.getDefaultFolder().getFolder("PERSONAL").exists()){
				store.getDefaultFolder().getFolder("PERSONAL").create(Folder.HOLDS_FOLDERS|Folder.HOLDS_MESSAGES);
				System.out.println("PERSONAL created");
			}
			if(!store.getDefaultFolder().getFolder("정크 메일").exists()){
				store.getDefaultFolder().getFolder("정크 메일").create(Folder.HOLDS_FOLDERS|Folder.HOLDS_MESSAGES);
				System.out.println("정크 메일 created");
			}
			
			Folder[] f = getStore().getDefaultFolder().list();
			
			for(Folder fd : f){
				if(fd.getName().equalsIgnoreCase("INBOX")){
					topLevelFolders.add(fd);
					break;
				}
			}
			for(Folder fd : f){
				if(fd.getName().equalsIgnoreCase("보낸 편지함")){
					topLevelFolders.add(fd);
					break;
				}
			}
			for(Folder fd : f){
				if(fd.getName().equalsIgnoreCase("임시 보관함")){
					topLevelFolders.add(fd);
					break;
				}
			}
			for(Folder fd : f){
				if(fd.getName().equalsIgnoreCase("지운 편지함")){
					topLevelFolders.add(fd);
					break;
				}
			}
			for(Folder fd : f){
				if(fd.getName().equalsIgnoreCase("PERSONAL")){
					topLevelFolders.add(fd);
					break;
				}
			}
			for(Folder fd : f){
				if(fd.getName().equalsIgnoreCase("정크 메일")){
					topLevelFolders.add(fd);
					break;
				}
			}
			for(Folder fd : f){
				if(!fd.getName().equalsIgnoreCase("INBOX")&&!fd.getName().equalsIgnoreCase("보낸 편지함")&&!fd.getName().equalsIgnoreCase("임시 보관함")&&
						!fd.getName().equalsIgnoreCase("지운 편지함")&&!fd.getName().equalsIgnoreCase("PERSONAL")&&!fd.getName().equalsIgnoreCase("정크 메일")){
					topLevelFolders.add(fd);
				}
			}
		} catch(MessagingException e){
			System.out.println("Error get default folder: " + e.getMessage());
			e.printStackTrace();
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
			System.out.println("Error get sub folder: " + e.getMessage());
			e.printStackTrace();
		}
		return subFolders;
	}

	public int getUnreadCount(String folderName){
		int unreadCount = 0;
		try {
			unreadCount = getStore().getFolder(folderName).getUnreadMessageCount();
		} catch (MessagingException e) {
			System.out.println("Error get unread message count: " + e.getMessage());
			e.printStackTrace();
		}
		return unreadCount;
	}
	
	public Folder getFolder(String folderName) {
		Folder folder = null;
		
		try {
			folder = getStore().getFolder(folderName);
		} catch (MessagingException e) {
			e.printStackTrace();
		}
		
		return folder;
	}
	
	public boolean hasAttachment(Part part) {
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
			else if (part instanceof MimeBodyPart) {
				String disp = part.getDisposition();
				String filename = part.getFileName();
//				logger.debug("disp=" + disp + ",filename=" + filename);
				// many mailers don't include a Content-Disposition
				if ((disp != null && disp.equalsIgnoreCase(Part.ATTACHMENT))
						|| (filename != null)) {
					isAttached = true;
				}
			}			
		} catch (Exception e) {
			e.printStackTrace();
		} 		
		
		return isAttached;
	}
	
	public static IMAPAccess getInstance(String host, String port, String username, String password){
		return new IMAPAccess(host, port, username, password);
	}
}
