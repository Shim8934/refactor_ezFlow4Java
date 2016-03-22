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

import egovframework.com.cmm.EgovMessageSource;

public class IMAPAccess {

    private static final Logger logger = LoggerFactory.getLogger(IMAPAccess.class);
    
	private String host;
	private String port;
	private Store store;
	private String userName;
	private String password;
	private EgovMessageSource egovMessageSource;
	
	private IMAPAccess(String host, String port, String userName, String password, EgovMessageSource egovMessageSource){
		this.host = host;
		this.port = port;
		this.userName = userName;
		this.password = password;
		this.egovMessageSource = egovMessageSource;
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
			if(!store.getDefaultFolder().getFolder(egovMessageSource.getMessage("ezEmail.t99000084")).exists()){
				store.getDefaultFolder().getFolder(egovMessageSource.getMessage("ezEmail.t99000084")).create(Folder.HOLDS_FOLDERS|Folder.HOLDS_MESSAGES);
				logger.debug(egovMessageSource.getMessage("ezEmail.t99000084") + " created");
			}
			if(!store.getDefaultFolder().getFolder(egovMessageSource.getMessage("ezEmail.t99000026")).exists()){
				store.getDefaultFolder().getFolder(egovMessageSource.getMessage("ezEmail.t99000026")).create(Folder.HOLDS_FOLDERS|Folder.HOLDS_MESSAGES);
				logger.debug(egovMessageSource.getMessage("ezEmail.t99000026") + " created");
			}
			if(!store.getDefaultFolder().getFolder(egovMessageSource.getMessage("ezEmail.t99000027")).exists()){
				store.getDefaultFolder().getFolder(egovMessageSource.getMessage("ezEmail.t99000027")).create(Folder.HOLDS_FOLDERS|Folder.HOLDS_MESSAGES);
				logger.debug(egovMessageSource.getMessage("ezEmail.t99000027") + " created");
			}
			if(!store.getDefaultFolder().getFolder(egovMessageSource.getMessage("ezEmail.t99000028")).exists()){
				store.getDefaultFolder().getFolder(egovMessageSource.getMessage("ezEmail.t99000028")).create(Folder.HOLDS_FOLDERS|Folder.HOLDS_MESSAGES);
				logger.debug(egovMessageSource.getMessage("ezEmail.t99000028") + " created");
			}
			if(!store.getDefaultFolder().getFolder(egovMessageSource.getMessage("ezEmail.t99000085")).exists()){
				store.getDefaultFolder().getFolder(egovMessageSource.getMessage("ezEmail.t99000085")).create(Folder.HOLDS_FOLDERS|Folder.HOLDS_MESSAGES);
				logger.debug("PERSONAL created");
			}
			if(!store.getDefaultFolder().getFolder(egovMessageSource.getMessage("ezEmail.t99000029")).exists()){
				store.getDefaultFolder().getFolder(egovMessageSource.getMessage("ezEmail.t99000029")).create(Folder.HOLDS_FOLDERS|Folder.HOLDS_MESSAGES);
				logger.debug(egovMessageSource.getMessage("ezEmail.t99000029") + " created");
			}
			
			Folder[] f = getStore().getDefaultFolder().list();
			
			for(Folder fd : f){
				if(fd.getName().equalsIgnoreCase(egovMessageSource.getMessage("ezEmail.t99000084"))){
					topLevelFolders.add(fd);
					break;
				}
			}
			for(Folder fd : f){
				if(fd.getName().equalsIgnoreCase(egovMessageSource.getMessage("ezEmail.t99000026"))){
					topLevelFolders.add(fd);
					break;
				}
			}
			for(Folder fd : f){
				if(fd.getName().equalsIgnoreCase(egovMessageSource.getMessage("ezEmail.t99000027"))){
					topLevelFolders.add(fd);
					break;
				}
			}
			for(Folder fd : f){
				if(fd.getName().equalsIgnoreCase(egovMessageSource.getMessage("ezEmail.t99000028"))){
					topLevelFolders.add(fd);
					break;
				}
			}
			for(Folder fd : f){
				if(fd.getName().equalsIgnoreCase(egovMessageSource.getMessage("ezEmail.t99000085"))){
					topLevelFolders.add(fd);
					break;
				}
			}
			for(Folder fd : f){
				if(fd.getName().equalsIgnoreCase(egovMessageSource.getMessage("ezEmail.t99000029"))){
					topLevelFolders.add(fd);
					break;
				}
			}
			for(Folder fd : f){
				if(!fd.getName().equalsIgnoreCase("INBOX")&&!fd.getName().equalsIgnoreCase(egovMessageSource.getMessage("ezEmail.t99000026"))&&!fd.getName().equalsIgnoreCase(egovMessageSource.getMessage("ezEmail.t99000027"))&&
						!fd.getName().equalsIgnoreCase(egovMessageSource.getMessage("ezEmail.t99000028"))&&!fd.getName().equalsIgnoreCase("PERSONAL")&&!fd.getName().equalsIgnoreCase(egovMessageSource.getMessage("ezEmail.t99000029"))){
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
	
	public static IMAPAccess getInstance(String host, String port, String username, String password, EgovMessageSource egovMessageSource){
		return new IMAPAccess(host, port, username, password, egovMessageSource);
	}
}
