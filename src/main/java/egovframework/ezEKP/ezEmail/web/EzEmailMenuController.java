package egovframework.ezEKP.ezEmail.web;

import java.io.IOException;
import java.io.StringReader;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

import javax.mail.Folder;
import javax.mail.MessagingException;
import javax.mail.NoSuchProviderException;
import javax.mail.Session;
import javax.mail.Store;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.w3c.dom.Document;
import org.xml.sax.InputSource;

import egovframework.let.utl.fcc.service.CommonUtil;

@Controller
public class EzEmailMenuController {

	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;

	@RequestMapping(value="/ezEmail/mailLeft.do")
	public String showMailLeft(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		String funCode = "";
		String subCode = "";			
		String rootAddressXML = "";
		String folderID = "";
		String pOutBoxFolderID = "";
		String pSentBoxID = "";
		String pDraftBoxID = "";
		String pDeleteBoxID = "";
		String pInBoxID = "";
		String pJunkBoxID = "";
		String pPersonalBoxID = "";
		String pAddressFolderID = "";
		String pAddressChangeID = "";
		String pAddressUpFolderID = "";
		String use_Editor = "";
		String use_IE11Browser = "";
		String pcFolderPath = "";
		String noneActiveX = "";
		
		String rootFolderXML = getRootFolderXML();
		System.out.println(rootFolderXML);
		String use_ArchiveMailBox = config.getProperty("config.USE_ArchiveMailBox");
		String mailServerAddress = config.getProperty("config.MailServerAddress");
		
		model.addAttribute("use_ArchiveMailBox", use_ArchiveMailBox);
		model.addAttribute("mailServerAddress", mailServerAddress);
		model.addAttribute("rootFolderXML", rootFolderXML);
		return "ezEmail/mailLeft";
	}

	@RequestMapping(value="/ezEmail/getFolderList.do")
	public void getFolderList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response){
		try {
			StringBuilder sb = new StringBuilder();
			char[] charBuffer = new char[128];
	        int bytesRead=0;
	        while ( (bytesRead = request.getReader().read(charBuffer)) != -1 ) {
	            sb.append(charBuffer, 0, bytesRead);
	        }
	        Document doc = commonUtil.convertStringToDocument(sb.toString());
	        String folderName = doc.getElementsByTagName("URL").item(0).getTextContent();
			response.setContentType("text/plain; charset=utf-8");
			response.getWriter().print(getSubFolderXML(folderName));
		} catch (IOException e) {
			System.out.println("Error IO: " + e.getMessage());
			e.printStackTrace();
		}
	}
	
	public String getRootFolderXML() {
		StringBuilder rootFolderXML = new StringBuilder();
		List<Folder> rootMailFolder = getRootMailFolder();
		try {
			for(int i=0; i<rootMailFolder.size(); i++){
				Folder fd = rootMailFolder.get(i);
				rootFolderXML.append("<node imgidx='1'");
				if(fd.getUnreadMessageCount()>0){
					rootFolderXML.append(" caption='"+fd.getName()+"("+fd.getUnreadMessageCount()+")'");
				}else{
					rootFolderXML.append(" caption='"+fd.getName()+"'");
				}
				rootFolderXML.append(" foldername='"+fd.getName()+"'");
				rootFolderXML.append(" orgBoxName='"+i+"'");
				rootFolderXML.append(" fullcaption='_PERSONAL'"); //수정
				rootFolderXML.append(" href='"+fd.getFullName()+"'"); //수정
				if(fd.list().length>0){
					rootFolderXML.append(" hassub='1'");
				}
				if(fd.getUnreadMessageCount()>0){
					rootFolderXML.append(" style='font-weight:bold'");
				}
				rootFolderXML.append("></node>");
			}
		} catch (MessagingException e) {
			System.out.println("Error get unread message count: " + e.getMessage());
			e.printStackTrace();
		}
		return rootFolderXML.toString();
	}
	
	public String getSubFolderXML(String parent) {
		StringBuilder subFolderXML = new StringBuilder();
		List<Folder> subMailFolder = getSubMailFolderByName(parent);
		try {
			for(int i=0; i<subMailFolder.size(); i++){
				Folder fd = subMailFolder.get(i);
				subFolderXML.append("<node imgidx='1'");
				if(fd.getUnreadMessageCount()>0){
					subFolderXML.append(" caption='"+fd.getName()+"("+fd.getUnreadMessageCount()+")'");
				}else{
					subFolderXML.append(" caption='"+fd.getName()+"'");
				}
				subFolderXML.append(" foldername='"+fd.getName()+"'");
				subFolderXML.append(" orgBoxName='"+i+"'");
				subFolderXML.append(" fullcaption='_NONE'"); //수정
				subFolderXML.append(" href='"+fd.getFullName()+"'"); //수정
				if(fd.list().length>0){
					subFolderXML.append(" hassub='1'");
				}
				if(fd.getUnreadMessageCount()>0){
					subFolderXML.append(" style='font-weight:bold'");
				}
				subFolderXML.append("></node>");
			}
		} catch (MessagingException e) {
			System.out.println("Error get unread message count: " + e.getMessage());
			e.printStackTrace();
		}
		return subFolderXML.toString();
	}
	
	public List<Folder> getRootMailFolder() {
		ArrayList<Folder> rootMailFolder = new ArrayList<Folder>();
		Store store = getStore(config.getProperty("config.MailServerAddress"), "jblue0o0@opensol2016.com", "1234"); //수정
		createDefualtFolders(store); //6개의 기본폴더 생성
		try{
			Folder[] f = store.getDefaultFolder().list();

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
		closeStore(store);
		return rootMailFolder;
	}
	
	public List<Folder> getSubMailFolder(Folder parent){
		ArrayList<Folder> al = new ArrayList<Folder>();
		try {
			Folder[] f = parent.list();
			for(Folder fd : f){
				al.add(fd);
			}
		} catch (MessagingException e) {
			System.out.println("Error get sub folder: " + e.getMessage());
			e.printStackTrace();
		}
		return al;
	}
	
	public List<Folder> getSubMailFolderByName(String parent){
		ArrayList<Folder> al = new ArrayList<Folder>();
		Store store = null;
		try {
			store = getStore(config.getProperty("config.MailServerAddress"), "jblue0o0@opensol2016.com", "1234"); //수정
			Folder[] f = store.getFolder(parent).list();
			for(Folder fd : f){
				al.add(fd);
			}
		} catch (MessagingException e) {
			System.out.println("Error get sub folder: " + e.getMessage());
			e.printStackTrace();
		} finally {
			closeStore(store);
		}
		return al;
	}
	
	public Store getStore(String host, String userName, String password) {
		Store store=null;
		try {
			Properties properties = new Properties();
			String port = "143";
			// server setting
			properties.put("mail.imap.host", host);
			properties.put("mail.imap.port", port);

			// SSL setting
			//properties.setProperty("mail.imap.socketFactory.class", "javax.net.ssl.SSLSocketFactory");

			//If set to true, failure to create a socket using the specified socket factory class will 
			//cause the socket to be created using the java.net.Socket class. Defaults to true.
			properties.setProperty("mail.imap.socketFactory.fallback", "false");
			properties.setProperty("mail.imap.socketFactory.port", String.valueOf(port));
			Session session = Session.getDefaultInstance(properties);

			// connects to the message store
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

	public void closeStore(Store store) {
		try {
			if(store != null){
				store.close();
			}
		} catch(MessagingException e) {
			System.out.println("Error close store: " + e.getMessage());
			e.printStackTrace();
		}

	}

	public void createDefualtFolders(Store store){
		Folder f;
		try {
			f = store.getDefaultFolder();
			createFolder(f, "INBOX", Folder.HOLDS_FOLDERS|Folder.HOLDS_MESSAGES);
			createFolder(f, "보낸 편지함", Folder.HOLDS_FOLDERS|Folder.HOLDS_MESSAGES);
			createFolder(f, "임시 보관함", Folder.HOLDS_FOLDERS|Folder.HOLDS_MESSAGES);
			createFolder(f, "지운 편지함", Folder.HOLDS_FOLDERS|Folder.HOLDS_MESSAGES);
			createFolder(f, "PERSONAL", Folder.HOLDS_FOLDERS|Folder.HOLDS_MESSAGES);
			createFolder(f, "정크 메일", Folder.HOLDS_FOLDERS|Folder.HOLDS_MESSAGES);
		} catch (MessagingException e) {
			System.out.println("Error get default folder: " + e.getMessage());
			e.printStackTrace();
		}
	}

	public boolean createFolder(Folder parent, String folderName, int folderType){ //create:true, already exist:false
		boolean isCreate = false;
		try{
			Folder newFolder = parent.getFolder(folderName);
			isCreate = newFolder.create(folderType);
		}
		catch(MessagingException e){
			System.out.println("Error create folder: " + e.getMessage());
			e.printStackTrace();
		}
		return isCreate;
	}

}
