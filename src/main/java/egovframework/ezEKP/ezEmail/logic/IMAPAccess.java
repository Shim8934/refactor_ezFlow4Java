package egovframework.ezEKP.ezEmail.logic;

import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

import javax.mail.Folder;
import javax.mail.MessagingException;
import javax.mail.NoSuchProviderException;
import javax.mail.Session;
import javax.mail.Store;

import org.springframework.beans.factory.annotation.Autowired;

public class IMAPAccess {

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
	
	public List<Folder> getRootMailFolder() {
		ArrayList<Folder> rootMailFolder = new ArrayList<Folder>();
		
		try{
			getStore().getDefaultFolder().getFolder("INBOX").create(Folder.HOLDS_FOLDERS|Folder.HOLDS_MESSAGES);
			getStore().getDefaultFolder().getFolder("보낸 편지함").create(Folder.HOLDS_FOLDERS|Folder.HOLDS_MESSAGES);
			getStore().getDefaultFolder().getFolder("임시 보관함").create(Folder.HOLDS_FOLDERS|Folder.HOLDS_MESSAGES);
			getStore().getDefaultFolder().getFolder("지운 편지함").create(Folder.HOLDS_FOLDERS|Folder.HOLDS_MESSAGES);
			getStore().getDefaultFolder().getFolder("PERSONAL").create(Folder.HOLDS_FOLDERS|Folder.HOLDS_MESSAGES);
			getStore().getDefaultFolder().getFolder("정크 메일").create(Folder.HOLDS_FOLDERS|Folder.HOLDS_MESSAGES);
			
			
			
			Folder[] f = getStore().getDefaultFolder().list();
			
			
			
			for(Folder fd : f){
				rootMailFolder.add(fd);
			}

			/*//순서 변경 -- 수정
			int defaultFolderCount = 6;
			for(Folder fd : f){
				switch(fd.getName()){
				case "INBOX":
					rootMailFolder.add(0, fd);
					break;
				case "보낸 편지함":
					rootMailFolder.add(1, fd);
					break;
				case "임시 보관함":
					rootMailFolder.add(2, fd);
					break;
				case "지운 편지함":
					rootMailFolder.add(3, fd);
					break;
				case "PERSONAL":
					rootMailFolder.add(4, fd);
					break;
				case "정크 메일":
					rootMailFolder.add(5, fd);
					break;
				default:
					rootMailFolder.add(defaultFolderCount++, fd);
					break;
				}
			}*/
		} catch(MessagingException e){
			System.out.println("Error get default folder: " + e.getMessage());
			e.printStackTrace();
		}
		return rootMailFolder;
	}
	
	public List<Folder> getSubMailFolder(String parent){
		ArrayList<Folder> al = new ArrayList<Folder>();
		try {
			Folder[] f = getStore().getFolder(parent).list();
			for(Folder fd : f){
				al.add(fd);
			}
		} catch (MessagingException e) {
			System.out.println("Error get sub folder: " + e.getMessage());
			e.printStackTrace();
		}
		return al;
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
	
	public static IMAPAccess getInstance(String host, String port, String username, String password){
		return new IMAPAccess(host, port, username, password);
	}
}
