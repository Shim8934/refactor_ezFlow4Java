package egovframework.ezEKP.ezEmail.web;

import java.util.Properties;

import javax.mail.Folder;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.NoSuchProviderException;
import javax.mail.Session;
import javax.mail.Store;
import javax.mail.search.SearchTerm;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;

import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Controller
public class EzEmailMenuController {
	
	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;
	
	@RequestMapping(value="/ezEmail/mailLeft.do")
	public String showMailLeft(@CookieValue("loginCookie") String loginCookie, Model model, LoginVO loginVO) throws Exception{
		String funCode = "";
		String subCode = "";			
		String rootFolderXML = "";
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
		//유저정보 가져오기 아직 미구현이므로 고정값으로 테스트 @수정요망@
		loginVO = commonUtil.userInfo(loginCookie);

		getRootMailFolder("jblue0o0@opensol2016.com", "1234");
		
		String use_ArchiveMailBox = config.getProperty("config.USE_ArchiveMailBox");
		String mailServerAddress = config.getProperty("config.MailServerAddress");
		model.addAttribute("use_ArchiveMailBox", use_ArchiveMailBox);
		model.addAttribute("mailServerAddress", mailServerAddress);
		return "ezEmail/mailLeft";
	}
	
	public String getRootFolderXML(){
		/*
		<node imgidx="1" caption="받은 편지함(15)" foldername="받은 편지함" orgBoxName="0" fullcaption="_INBOX" href="AAMkADUzMzFiN2ZmLTcxMjQtNGQyYy04NWFhLWIwZGE4MjgwOGFiNgAuAAAAAACTVwAhk/rNSrXnUO5agdjtAQB7mQ9h8kXlSbYb4JX5rK8UAAAAAAEMAAA=" hassub="1" style='font-weight:bold' ></node>
		<node imgidx="1" caption="보낸 편지함" foldername="보낸 편지함" orgBoxName="1" fullcaption="_SENT" href="AAMkADUzMzFiN2ZmLTcxMjQtNGQyYy04NWFhLWIwZGE4MjgwOGFiNgAuAAAAAACTVwAhk/rNSrXnUO5agdjtAQB7mQ9h8kXlSbYb4JX5rK8UAAAAAAEJAAA="   ></node>
		<node imgidx="1" caption="임시 보관함" foldername="임시 보관함" orgBoxName="2" fullcaption="_DRAFT" href="AAMkADUzMzFiN2ZmLTcxMjQtNGQyYy04NWFhLWIwZGE4MjgwOGFiNgAuAAAAAACTVwAhk/rNSrXnUO5agdjtAQB7mQ9h8kXlSbYb4JX5rK8UAAAAAAEPAAA="   ></node>
		<node imgidx="1" caption="지운 편지함" foldername="지운 편지함" orgBoxName="3" fullcaption="_DELETE" href="AAMkADUzMzFiN2ZmLTcxMjQtNGQyYy04NWFhLWIwZGE4MjgwOGFiNgAuAAAAAACTVwAhk/rNSrXnUO5agdjtAQB7mQ9h8kXlSbYb4JX5rK8UAAAAAAEKAAA="   ></node>
		<node imgidx="1" caption="PERSONAL" foldername="PERSONAL" orgBoxName="4" fullcaption="_PERSONAL" href="AAMkADUzMzFiN2ZmLTcxMjQtNGQyYy04NWFhLWIwZGE4MjgwOGFiNgAuAAAAAACTVwAhk/rNSrXnUO5agdjtAQB7mQ9h8kXlSbYb4JX5rK8UAAAAAAElAAA="   ></node>
		<node imgidx="1" caption="정크 메일" foldername="정크 메일" orgBoxName="5" fullcaption="_JUNK" href="AAMkADUzMzFiN2ZmLTcxMjQtNGQyYy04NWFhLWIwZGE4MjgwOGFiNgAuAAAAAACTVwAhk/rNSrXnUO5agdjtAQB7mQ9h8kXlSbYb4JX5rK8UAAAAAAEeAAA="   ></node>
		 */
		String rootFolderXML = "";



		return rootFolderXML;
	}

	public void getRootMailFolder(String userName, String password) throws Exception{
		Store store = getIMAPStore(config.getProperty("config.MailServerAddress"));
		store.connect(userName, password);
		
		//기존 편지함 존재하지 않을 시 생성
		Folder f = store.getDefaultFolder();
		if(!f.getFolder("INBOX").exists()){
			System.out.println("create INBOX");
			if(f.getFolder("INBOX").create(Folder.HOLDS_FOLDERS)){
				System.out.println("creating INBOX success");
			}
		}
		if(!f.getFolder("보낸 편지함").exists()){
			System.out.println("create 보낸 편지함");
			if(f.getFolder("보낸 편지함").create(Folder.HOLDS_FOLDERS)){
				System.out.println("creating 보낸 편지함 success");
			}
		}
		if(!f.getFolder("임시 보관함").exists()){
			System.out.println("create 임시 보관함");
			if(f.getFolder("임시 보관함").create(Folder.HOLDS_FOLDERS)){
				System.out.println("creating 임시 보관함 success");
			}
		}
		if(!f.getFolder("지운 편지함").exists()){
			System.out.println("create 지운 편지함");
			if(f.getFolder("지운 편지함").create(Folder.HOLDS_FOLDERS)){
				System.out.println("creating 지운 편지함 success");
			}
		}
		if(!f.getFolder("PERSONAL").exists()){
			System.out.println("create PERSONAL");
			if(f.getFolder("PERSONAL").create(Folder.HOLDS_FOLDERS)){
				System.out.println("creating PERSONAL success");
			}
		}
		if(!f.getFolder("정크 메일").exists()){
			System.out.println("create 정크 메일");
			if(f.getFolder("정크 메일").create(Folder.HOLDS_FOLDERS)){
				System.out.println("creating 정크 메일 success");
			}
		}
		
		Folder[] rootMailFolder = f.list();
		for(Folder fd : rootMailFolder){
			
		}
		
		
		/*for(Folder fd:f){
			System.out.println(">> "+fd.getName()+","+fd.getFullName());
			
			if(fd.getName().equals("INBOX")){
				System.out.println("0");
			}
			else if(fd.getName().equals("Sent")){
				System.out.println("1");
			}
			else if(fd.getName().equals("Drafts")){
				System.out.println("2");
			}
			else if(fd.getName().equals("Trash")){
				System.out.println("3");
			}
			else if(fd.getName().equals("Personal")){
				System.out.println("4");
			}
			else if(fd.getName().equals("Junk")){
				System.out.println("5");
			}
		}
		
		Folder[] f2 = store.getFolder("Trash.sub1").list();
		for(Folder fd:f2){
			System.out.println(">> "+fd.getName()+","+fd.getFullName());
		}*/
		
		store.close();
	}

	public Store getIMAPStore(String host) throws Exception{
		Properties properties = new Properties();

		// server setting
		properties.put("mail.imap.host", host);
		properties.put("mail.imap.port", "143");

		// SSL setting
		//properties.setProperty("mail.imap.socketFactory.class", "javax.net.ssl.SSLSocketFactory");

		//If set to true, failure to create a socket using the specified socket factory class will 
		//cause the socket to be created using the java.net.Socket class. Defaults to true.
		properties.setProperty("mail.imap.socketFactory.fallback", "false");
		properties.setProperty("mail.imap.socketFactory.port", String.valueOf("143"));

		Session session = Session.getDefaultInstance(properties);

		// connects to the message store
		Store store = session.getStore("imap");

		return store;
	}
	
}
