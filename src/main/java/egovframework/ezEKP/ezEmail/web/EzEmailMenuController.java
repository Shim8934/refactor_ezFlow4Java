package egovframework.ezEKP.ezEmail.web;

import java.io.IOException;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;
import javax.mail.Folder;
import javax.mail.MessagingException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.w3c.dom.Document;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezEmail.logic.IMAPAccess;
import egovframework.let.utl.fcc.service.CommonUtil;

@Controller
public class EzEmailMenuController {

	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;

	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;  

	@RequestMapping(value="/ezEmail/mailLeft.do")
	public String showMailLeft(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		List<String> userInfo = commonUtil.getUserIdAndPassword(loginCookie);
		String id = userInfo.get(0);
		String password  = userInfo.get(1);
		StringBuilder rootFolderXML = new StringBuilder();
		System.out.println(commonUtil.getUserIdAndPassword(loginCookie).get(0) +","+ commonUtil.getUserIdAndPassword(loginCookie).get(1));
		IMAPAccess ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
				id+"@"+config.getProperty("config.DomainName"), password, egovMessageSource);
		List<Folder> rootMailFolder = ia.getTopLevelFolders();
		
		try {
			for(int i=0,j=0; i<rootMailFolder.size(); i++){
				Folder fd = rootMailFolder.get(i);
				rootFolderXML.append("<node imgidx='1'");
				if(fd.getUnreadMessageCount()>0){
					if(fd.getName().equalsIgnoreCase("INBOX")){
						rootFolderXML.append(" caption='"+egovMessageSource.getMessage("ezEmail.t99000025")+"("+fd.getUnreadMessageCount()+")'");
					}
					else{
						rootFolderXML.append(" caption='"+fd.getName()+"("+fd.getUnreadMessageCount()+")'");
					}
				}else{
					if(fd.getName().equalsIgnoreCase("INBOX")){
						rootFolderXML.append(" caption='"+egovMessageSource.getMessage("ezEmail.t99000025")+"'");
					}
					else{
						rootFolderXML.append(" caption='"+fd.getName()+"'");
					}
				}
				if(fd.getName().equalsIgnoreCase("INBOX")) {
					rootFolderXML.append(" foldername='"+egovMessageSource.getMessage("ezEmail.t99000025")+"'");
				}
				else{
					rootFolderXML.append(" foldername='"+fd.getName()+"'");
				}

				if(fd.getName().equalsIgnoreCase("INBOX")) {
					rootFolderXML.append(" orgBoxName='0'");
					rootFolderXML.append(" fullcaption='_INBOX'"); //수정
				} else if(fd.getName().equalsIgnoreCase(egovMessageSource.getMessage("ezEmail.t645"))) {
					rootFolderXML.append(" orgBoxName='1'");
					rootFolderXML.append(" fullcaption='_SENT'"); //수정
				} else if(fd.getName().equalsIgnoreCase(egovMessageSource.getMessage("ezEmail.t646"))) {
					rootFolderXML.append(" orgBoxName='2'");
					rootFolderXML.append(" fullcaption='_DRAFT'"); //수정
				} else if(fd.getName().equalsIgnoreCase(egovMessageSource.getMessage("ezEmail.t647"))) {
					rootFolderXML.append(" orgBoxName='3'");
					rootFolderXML.append(" fullcaption='_DELETE'"); //수정
				} else if(fd.getName().equalsIgnoreCase("PERSONAL")) {
					rootFolderXML.append(" orgBoxName='4'");
					rootFolderXML.append(" fullcaption='_PERSONAL'"); //수정
				} else if(fd.getName().equalsIgnoreCase(egovMessageSource.getMessage("ezEmail.t99000029"))) {
					rootFolderXML.append(" orgBoxName='5'");
					rootFolderXML.append(" fullcaption='_JUNK'"); //수정
				} else {
					rootFolderXML.append(" orgBoxName='"+((j++)+6)+"'");
					rootFolderXML.append(" fullcaption='_NONE'"); //수정
				}

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
		ia.close();
		
		String use_ArchiveMailBox = config.getProperty("config.USE_ArchiveMailBox");
		String mailServerAddress = config.getProperty("config.MailServerAddress");
		model.addAttribute("use_ArchiveMailBox", use_ArchiveMailBox);
		model.addAttribute("mailServerAddress", mailServerAddress);
		model.addAttribute("rootFolderXML", rootFolderXML.toString());
		return "ezEmail/mailLeft";
	}

	@RequestMapping(value="/ezEmail/getFolderList.do")
	public void getFolderList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		try {
			List<String> userInfo = commonUtil.getUserIdAndPassword(loginCookie);
			String id = userInfo.get(0);
			String password  = userInfo.get(1);
			StringBuilder sb = new StringBuilder();
			char[] charBuffer = new char[128];
			int bytesRead=0;
			while ( (bytesRead = request.getReader().read(charBuffer)) != -1 ) {
				sb.append(charBuffer, 0, bytesRead);
			}
			Document doc = commonUtil.convertStringToDocument(sb.toString());
			String folderName = doc.getElementsByTagName("URL").item(0).getTextContent();
			response.setContentType("text/plain; charset=utf-8");
			
			StringBuilder subFolderXML = new StringBuilder();
			IMAPAccess ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					id+"@"+config.getProperty("config.DomainName"), password, egovMessageSource);
			List<Folder> subMailFolder = ia.getSubFolders(folderName);
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
			ia.close();
			response.getWriter().print(subFolderXML.toString());
		} catch (IOException e) {
			System.out.println("Error IO: " + e.getMessage());
			e.printStackTrace();
		}
	}

	@RequestMapping(value="/ezEmail/getFolderUnreadCount.do")
	public void getFolderUnreadCount(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		try {
			List<String> userInfo = commonUtil.getUserIdAndPassword(loginCookie);
			String id = userInfo.get(0);
			String password  = userInfo.get(1);
			StringBuilder sb = new StringBuilder();
			char[] charBuffer = new char[128];
			int bytesRead=0;
			while ( (bytesRead = request.getReader().read(charBuffer)) != -1 ) {
				sb.append(charBuffer, 0, bytesRead);
			}
			Document doc = commonUtil.convertStringToDocument(sb.toString());
			String folderName = doc.getElementsByTagName("URL").item(0).getTextContent();
			response.setContentType("text/plain; charset=utf-8");
			
			IMAPAccess ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					id+"@"+config.getProperty("config.DomainName"), password, egovMessageSource);
			String unreadCountXML = "<DATA>"+ia.getUnreadCount(folderName)+"</DATA>";
			ia.close();
			
			response.getWriter().print(unreadCountXML);
		} catch (IOException e) {
			System.out.println("Error IO: " + e.getMessage());
			e.printStackTrace();
		} 
	}

}
