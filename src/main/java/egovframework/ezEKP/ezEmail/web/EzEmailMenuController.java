package egovframework.ezEKP.ezEmail.web;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.util.List;
import java.util.Locale;
import java.util.Properties;

import javax.annotation.Resource;
import javax.mail.Folder;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.w3c.dom.Document;

import com.sun.mail.imap.IMAPFolder;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezEmail.logic.IMAPAccess;
import egovframework.ezEKP.ezEmail.logic.SMTPAccess;
import egovframework.let.utl.fcc.service.CommonUtil;

/** 
 * @Description [Controller] 메일 메뉴
 * @author 오픈솔루션팀 이효민
 * @Modification Information
 *
 *    수정일        수정자         수정내용
 *    ----------    ------    -------------------
 *    2016.04.14    이효민    신규작성
 *
 * @see
 */

@Controller
public class EzEmailMenuController {
	
	private static final Logger logger = LoggerFactory.getLogger(EzEmailMenuController.class);
	
	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;

	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;  
	
	/**
	 * 메일 왼쪽화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailLeft.do")
	public String showMailLeft(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model) throws Exception {
		List<String> userInfo = commonUtil.getUserIdAndPassword(loginCookie);
		String id = userInfo.get(0);
		String password  = userInfo.get(1);
		StringBuilder rootFolderXML = new StringBuilder();
		
		IMAPAccess ia = null;
		try {
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					id+"@"+config.getProperty("config.DomainName"), password, egovMessageSource, locale);
			List<Folder> rootMailFolder = ia.getTopLevelFolders();
			
			for(int i=0,j=0; i<rootMailFolder.size(); i++){
				Folder fd = rootMailFolder.get(i);
				rootFolderXML.append("<node imgidx='1'");
				if(fd.getUnreadMessageCount()>0){
					if(fd.getName().equalsIgnoreCase(egovMessageSource.getMessage("ezEmail.t99000084", locale))){
						rootFolderXML.append(" caption='"+egovMessageSource.getMessage("ezEmail.t99000025", locale)+"("+fd.getUnreadMessageCount()+")'");
					}
					else{
						rootFolderXML.append(" caption='"+fd.getName()+"("+fd.getUnreadMessageCount()+")'");
					}
				}else{
					if(fd.getName().equalsIgnoreCase(egovMessageSource.getMessage("ezEmail.t99000084", locale))){
						rootFolderXML.append(" caption='"+egovMessageSource.getMessage("ezEmail.t99000025", locale)+"'");
					}
					else{
						rootFolderXML.append(" caption='"+fd.getName()+"'");
					}
				}
				if(fd.getName().equalsIgnoreCase(egovMessageSource.getMessage("ezEmail.t99000084", locale))) {
					rootFolderXML.append(" foldername='"+egovMessageSource.getMessage("ezEmail.t99000025", locale)+"'");
				}
				else{
					rootFolderXML.append(" foldername='"+fd.getName()+"'");
				}

				if(fd.getName().equalsIgnoreCase(egovMessageSource.getMessage("ezEmail.t99000084", locale))) {
					rootFolderXML.append(" orgBoxName='0'");
					rootFolderXML.append(" fullcaption='_INBOX'"); //수정
				} else if(fd.getName().equalsIgnoreCase(egovMessageSource.getMessage("ezEmail.t645", locale))) {
					rootFolderXML.append(" orgBoxName='1'");
					rootFolderXML.append(" fullcaption='_SENT'"); //수정
				} else if(fd.getName().equalsIgnoreCase(egovMessageSource.getMessage("ezEmail.t646", locale))) {
					rootFolderXML.append(" orgBoxName='2'");
					rootFolderXML.append(" fullcaption='_DRAFT'"); //수정
				} else if(fd.getName().equalsIgnoreCase(egovMessageSource.getMessage("ezEmail.t647", locale))) {
					rootFolderXML.append(" orgBoxName='3'");
					rootFolderXML.append(" fullcaption='_DELETE'"); //수정
				} else if(fd.getName().equalsIgnoreCase(egovMessageSource.getMessage("ezEmail.t648", locale))) {
					rootFolderXML.append(" orgBoxName='4'");
					rootFolderXML.append(" fullcaption='_PERSONAL'"); //수정
				} else if(fd.getName().equalsIgnoreCase(egovMessageSource.getMessage("ezEmail.t99000029", locale))) {
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
			logger.error("Error get unread message count: " + e.getMessage());
			e.printStackTrace();
		} finally {
			if (ia != null) {
				ia.close();
			}
		}
		
		String use_ArchiveMailBox = config.getProperty("config.USE_ArchiveMailBox");
		String mailServerAddress = config.getProperty("config.MailServerAddress");
		model.addAttribute("use_ArchiveMailBox", use_ArchiveMailBox);
		model.addAttribute("mailServerAddress", mailServerAddress);
		model.addAttribute("rootFolderXML", rootFolderXML.toString());
		return "ezEmail/mailLeft";
	}
	
	/**
	 * 메일 폴더 리스트 정보 호출 함수
	 */
	@RequestMapping(value="/ezEmail/getFolderList.do")
	public void getFolderList(@CookieValue("loginCookie") String loginCookie, Locale locale, HttpServletRequest request, HttpServletResponse response) throws Exception {
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
			String bcount = doc.getElementsByTagName("BCOUNT").item(0).getTextContent();
			response.setContentType("text/plain; charset=utf-8");
			
			StringBuilder subFolderXML = new StringBuilder();
			
			IMAPAccess ia = null;
			try {
				ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
						id+"@"+config.getProperty("config.DomainName"), password, egovMessageSource, locale);
				List<Folder> subMailFolder = null;
				
				if (!folderName.equals("")) {
					subMailFolder = ia.getSubFolders(folderName);
					
					for (int i=0; i<subMailFolder.size(); i++) {
						Folder fd = subMailFolder.get(i);
						subFolderXML.append("<node imgidx='1'");
						if (bcount.equals("-1")) {
							if (fd.getUnreadMessageCount()>0) {
								subFolderXML.append(" caption='"+fd.getName()+"("+fd.getUnreadMessageCount()+")'");
							} else {
								subFolderXML.append(" caption='"+fd.getName()+"'");
							}
						} else {
							subFolderXML.append(" caption='"+fd.getName()+"'");
						}
						subFolderXML.append(" foldername='"+fd.getName()+"'");
						subFolderXML.append(" orgBoxName='"+i+"'");
						subFolderXML.append(" fullcaption='_NONE'"); //수정
						subFolderXML.append(" href='"+fd.getFullName()+"'"); //수정
						if (fd.list().length>0) {
							subFolderXML.append(" hassub='1'");
						}
						if (bcount.equals("-1")) {
							if (fd.getUnreadMessageCount()>0) {
								subFolderXML.append(" style='font-weight:bold'");
							}
						}
						subFolderXML.append("></node>");
					}
				} else {
					subMailFolder = ia.getTopLevelFolders();
					for (int i=0,j=0; i<subMailFolder.size(); i++) {
						Folder fd = subMailFolder.get(i);
						subFolderXML.append("<node imgidx='1'");
						if (bcount.equals("-1")) {
							if (fd.getUnreadMessageCount()>0) {
								if (fd.getName().equalsIgnoreCase(egovMessageSource.getMessage("ezEmail.t99000084", locale))) {
									subFolderXML.append(" caption='"+egovMessageSource.getMessage("ezEmail.t99000025", locale)+"("+fd.getUnreadMessageCount()+")'");
								} else {
									subFolderXML.append(" caption='"+fd.getName()+"("+fd.getUnreadMessageCount()+")'");
								}
							} else {
								if(fd.getName().equalsIgnoreCase(egovMessageSource.getMessage("ezEmail.t99000084", locale))){
									subFolderXML.append(" caption='"+egovMessageSource.getMessage("ezEmail.t99000025", locale)+"'");
								} else {
									subFolderXML.append(" caption='"+fd.getName()+"'");
								}
							}
						} else {
							if(fd.getName().equalsIgnoreCase(egovMessageSource.getMessage("ezEmail.t99000084", locale))){
								subFolderXML.append(" caption='"+egovMessageSource.getMessage("ezEmail.t99000025", locale)+"'");
							} else {
								subFolderXML.append(" caption='"+fd.getName()+"'");
							}
						}
						if (fd.getName().equalsIgnoreCase(egovMessageSource.getMessage("ezEmail.t99000084", locale))) {
							subFolderXML.append(" foldername='"+egovMessageSource.getMessage("ezEmail.t99000025", locale)+"'");
						} else {
							subFolderXML.append(" foldername='"+fd.getName()+"'");
						}
	
						if (fd.getName().equalsIgnoreCase(egovMessageSource.getMessage("ezEmail.t99000084", locale))) {
							subFolderXML.append(" orgBoxName='0'");
							subFolderXML.append(" fullcaption='_INBOX'"); //수정
						} else if (fd.getName().equalsIgnoreCase(egovMessageSource.getMessage("ezEmail.t645", locale))) {
							subFolderXML.append(" orgBoxName='1'");
							subFolderXML.append(" fullcaption='_SENT'"); //수정
						} else if (fd.getName().equalsIgnoreCase(egovMessageSource.getMessage("ezEmail.t646", locale))) {
							subFolderXML.append(" orgBoxName='2'");
							subFolderXML.append(" fullcaption='_DRAFT'"); //수정
						} else if (fd.getName().equalsIgnoreCase(egovMessageSource.getMessage("ezEmail.t647", locale))) {
							subFolderXML.append(" orgBoxName='3'");
							subFolderXML.append(" fullcaption='_DELETE'"); //수정
						} else if (fd.getName().equalsIgnoreCase(egovMessageSource.getMessage("ezEmail.t648", locale))) {
							subFolderXML.append(" orgBoxName='4'");
							subFolderXML.append(" fullcaption='_PERSONAL'"); //수정
						} else if (fd.getName().equalsIgnoreCase(egovMessageSource.getMessage("ezEmail.t99000029", locale))) {
							subFolderXML.append(" orgBoxName='5'");
							subFolderXML.append(" fullcaption='_JUNK'"); //수정
						} else {
							subFolderXML.append(" orgBoxName='"+((j++)+6)+"'");
							subFolderXML.append(" fullcaption='_NONE'"); //수정
						}
	
						subFolderXML.append(" href='"+fd.getFullName()+"'"); //수정
						if (fd.list().length>0) {
							subFolderXML.append(" hassub='1'");
						}
						if (bcount.equals("-1")) {
							if (fd.getUnreadMessageCount()>0) {
								subFolderXML.append(" style='font-weight:bold'");
							}
						}
						subFolderXML.append("></node>");
					}
				}
				
			} catch (MessagingException e) {
				e.printStackTrace();
			} finally {
				if (ia != null) {
					ia.close();
				}
			}
			
			response.getWriter().print(subFolderXML.toString());
		} catch (IOException e) {
			logger.error("Error IO: " + e.getMessage());
			e.printStackTrace();
		}
	}
	
	/**
	 * 읽지않은 메시지 개수 정보 호출 함수
	 */
	@RequestMapping(value="/ezEmail/getFolderUnreadCount.do")
	public void getFolderUnreadCount(@CookieValue("loginCookie") String loginCookie, Locale locale, HttpServletRequest request, HttpServletResponse response) throws Exception {
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
			response.setContentType("text/xml; charset=utf-8");
			
			IMAPAccess ia = null;
			String unreadCountXML = null;
			
			try {
				ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
						id+"@"+config.getProperty("config.DomainName"), password, egovMessageSource, locale);
				unreadCountXML = "<DATA>"+ia.getUnreadCount(folderName)+"</DATA>";
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				if (ia != null) {
					ia.close();
				}
			}
			
			response.getWriter().print(unreadCountXML);
			
		} catch (IOException e) {
			logger.error("Error IO: " + e.getMessage());
			e.printStackTrace();
		}
	}
	
	/**
	 * PC에서 메일 가져오기 화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailImport.do")
	public String mailImport(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		String pNonActivX = "YES";
		model.addAttribute("pNonActivX", pNonActivX);

		return "ezEmail/mailImport";
	}
	
	/**
	 * PC에서 메일 가져오기 실행 함수
	 */
	@RequestMapping(value="/ezEmail/mailImportUpload.do")
	public String mailImportUpload(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, MultipartHttpServletRequest request) throws Exception{
		String strResult = "ERROR";
		
		List<String> userInfo = commonUtil.getUserIdAndPassword(loginCookie);
		String id = userInfo.get(0);
		String password  = userInfo.get(1);
		
		List<MultipartFile> multiFile = request.getFiles("file1");
		String folderId = request.getParameter("folderid");
		String cnt = request.getParameter("cnt");
		
		if (multiFile != null) {
			
			SMTPAccess sa = SMTPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.SMTPPort"),
					id+"@"+config.getProperty("config.DomainName"), password);
			
			IMAPAccess ia = null;
			try {
				ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
						id+"@"+config.getProperty("config.DomainName"), password, egovMessageSource, locale);
				
				Folder folder = ia.getFolder(folderId);
				if (folder != null && folder.exists()) {
					folder.open(Folder.READ_WRITE);
					
					Message[] messages = new Message[multiFile.size()];
					
					for (int i=0; i<multiFile.size(); i++) {
						InputStream inputStream = multiFile.get(i).getInputStream();
						MimeMessage message = sa.readMimeMessage(inputStream);
						inputStream.close();
						
						if (message != null) {
							messages[i] = message;
						}
					}
					
					folder.appendMessages(messages);
					folder.close(true);
					
					strResult = "OK";
				}
				
			} catch (MessagingException e) {
				e.printStackTrace();
			} finally {
				if (ia != null) {
					ia.close();
				}
			}
		}
		
		model.addAttribute("strResult", strResult);
		return "ezEmail/mailImportUpload";
	}
	
	/**
	 * PC에 메일 저장하기 실행 함수
	 */
	@RequestMapping(value="/ezEmail/mailExport.do")
	public void mailExport(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request, HttpServletResponse response) throws Exception{
		List<String> userInfo = commonUtil.getUserIdAndPassword(loginCookie);
		String id = userInfo.get(0);
		String password  = userInfo.get(1);
		
		String url = request.getParameter("url");
		long uid = 0;
		String folderPath = null;
		
		if (url != null) {
			int index = url.lastIndexOf("/");
			
			// separate the passed-in url into a folder path and a message uid
			if (index != -1) {
				folderPath = url.substring(0, index);
				uid = Long.parseLong(url.substring(index + 1));
			}
		}
		
		String filename = request.getParameter("filename");
		
		IMAPAccess ia = null;
		try {
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					id+"@"+config.getProperty("config.DomainName"), password, egovMessageSource, locale);
			
			Folder folder = ia.getFolder(folderPath);
			
			String mimetype = "message/rfc822";	
			response.setContentType(mimetype);
			response.setHeader("Content-Disposition", "attachment; filename=" + URLEncoder.encode(filename, "UTF-8").replaceAll("\\+","\\ ") + ";");
			
			if (folder != null && folder.exists()) {
				folder.open(Folder.READ_ONLY);
				Message message = ((IMAPFolder)folder).getMessageByUID(uid);
				
				if (message != null) {
					OutputStream outputStream = null;
					try{
						response.setContentLength(message.getSize());
						
						outputStream = response.getOutputStream();
						message.writeTo(outputStream);
						
					} catch(IOException e){
					} finally {
						if (outputStream != null) {
							outputStream.close();
						}
					}
				}
				
				folder.close(true);
			}
			
		} catch (MessagingException e) {
			e.printStackTrace();
		} finally {
			if (ia != null) {
				ia.close();
			}
		}
		
	}
	
}
