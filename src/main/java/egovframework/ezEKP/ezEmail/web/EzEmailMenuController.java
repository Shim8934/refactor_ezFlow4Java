package egovframework.ezEKP.ezEmail.web;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
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
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.w3c.dom.Document;

import com.sun.mail.imap.IMAPFolder;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.logic.IMAPAccess;
import egovframework.ezEKP.ezEmail.logic.SMTPAccess;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.ClientUtil;
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
	
	@Resource(name = "EzCommonService")
    private EzCommonService ezCommonService;
	
	/**
	 * 메일 왼쪽화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailLeft.do")
	public String showMailLeft(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception {
		logger.debug("showMailLeft started.");
		
		List<String> userInfo = commonUtil.getUserIdAndPassword(loginCookie);
		String password  = userInfo.get(1);
		
		LoginVO loginInfo = commonUtil.userInfo(loginCookie);
		String domainName = ezCommonService.getTenantConfig("DomainName", loginInfo.getTenantId());
		String userEmail = loginInfo.getId() + "@" + domainName;
		logger.debug("userEmail=" + userEmail);
		
		LoginVO user = commonUtil.userInfo(loginCookie);
		
		StringBuilder rootFolderXML = new StringBuilder();
		StringBuilder rootAddressXML = new StringBuilder();
		
		IMAPAccess ia = null;
		try {
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userEmail, password, egovMessageSource, locale);
			List<Folder> rootMailFolderList = ia.getTopLevelFolders();
			
			for (int i=0,j=0; i<rootMailFolderList.size(); i++) {
				Folder folder = rootMailFolderList.get(i);
				
				String folderName = folder.getName();
				int folderUnreadMessageCount = folder.getUnreadMessageCount();
				
				rootFolderXML.append("<node imgidx='1'");
				
				if (folderUnreadMessageCount > 0) {
					if (folderName.equalsIgnoreCase(egovMessageSource.getMessage("ezEmail.t99000084", locale))) {
						rootFolderXML.append(" caption='"+egovMessageSource.getMessage("ezEmail.t99000025", locale) + "(" + folderUnreadMessageCount + ")'");
					} else {
						rootFolderXML.append(" caption='" + folderName + "(" + folderUnreadMessageCount + ")'");
					}
				} else {
					if (folderName.equalsIgnoreCase(egovMessageSource.getMessage("ezEmail.t99000084", locale))) {
						rootFolderXML.append(" caption='" + egovMessageSource.getMessage("ezEmail.t99000025", locale) + "'");
					} else {
						rootFolderXML.append(" caption='" + folderName+"'");
					}
				}
				
				if (folderName.equalsIgnoreCase(egovMessageSource.getMessage("ezEmail.t99000084", locale))) {
					rootFolderXML.append(" foldername='" + egovMessageSource.getMessage("ezEmail.t99000025", locale) + "'");
				} else {
					rootFolderXML.append(" foldername='" + folderName+"'");
				}

				if (folderName.equalsIgnoreCase(egovMessageSource.getMessage("ezEmail.t99000084", locale))) {
					rootFolderXML.append(" orgBoxName='0'");
					rootFolderXML.append(" fullcaption='_INBOX'"); //수정
				} else if (folderName.equalsIgnoreCase(egovMessageSource.getMessage("ezEmail.t645", locale))) {
					rootFolderXML.append(" orgBoxName='1'");
					rootFolderXML.append(" fullcaption='_SENT'"); //수정
				} else if (folderName.equalsIgnoreCase(egovMessageSource.getMessage("ezEmail.t646", locale))) {
					rootFolderXML.append(" orgBoxName='2'");
					rootFolderXML.append(" fullcaption='_DRAFT'"); //수정
				} else if (folderName.equalsIgnoreCase(egovMessageSource.getMessage("ezEmail.t647", locale))) {
					rootFolderXML.append(" orgBoxName='3'");
					rootFolderXML.append(" fullcaption='_DELETE'"); //수정
				} else if (folderName.equalsIgnoreCase(egovMessageSource.getMessage("ezEmail.t648", locale))) {
					rootFolderXML.append(" orgBoxName='4'");
					rootFolderXML.append(" fullcaption='_PERSONAL'"); //수정
				} else {
					rootFolderXML.append(" orgBoxName='" + ((j++) + 6) + "'");
					rootFolderXML.append(" fullcaption='_NONE'"); //수정
				}

				rootFolderXML.append(" href='" + folder.getFullName() + "'"); //수정
				
				if (folder.list().length > 0) {
					rootFolderXML.append(" hassub='1'");
				}
				if (folderUnreadMessageCount > 0) {
					rootFolderXML.append(" style='font-weight:bold'");
				}
				
				rootFolderXML.append("></node>");
				
			}
		} catch (Exception e) {
			logger.error("Error get unread message count: " + e.getMessage());
			e.printStackTrace();
		} finally {
			if (ia != null) {
				ia.close();
			}
		}
		
		rootAddressXML.append("<tree>");
		rootAddressXML.append("<nodes>");
        String xmlFormat = "<node imgidx=\"%s\" caption=\"%s\" ownerid=\"%s\" type=\"%s\" folderid=\"%s\" changekey=\"%s\" hassub=\"%s\"></node>";
        rootAddressXML.append(String.format(xmlFormat, "1", egovMessageSource.getMessage("ezEmail.t99000038", locale), user.getId(), "P", "0", "", "1"));
        rootAddressXML.append(String.format(xmlFormat, "1", egovMessageSource.getMessage("ezEmail.t99000039", locale), user.getDeptID(), "D", "0", "", "1"));
        rootAddressXML.append(String.format(xmlFormat, "1", egovMessageSource.getMessage("ezEmail.t99000040", locale), user.getCompanyID(), "C", "0", "", "1"));
        rootAddressXML.append("</nodes>");
        rootAddressXML.append("</tree>");
		
		
		String use_ArchiveMailBox = config.getProperty("config.USE_ArchiveMailBox");
		String mailServerAddress = config.getProperty("config.MailServerAddress");
		
		String funCode = "1";
		if (request.getParameter("funCode") != null) {
			funCode = request.getParameter("funCode");
		}
		
		model.addAttribute("use_ArchiveMailBox", use_ArchiveMailBox);
		model.addAttribute("mailServerAddress", mailServerAddress);
		model.addAttribute("rootFolderXML", rootFolderXML.toString());
		model.addAttribute("rootAddressXML", rootAddressXML.toString());
		model.addAttribute("funCode", funCode);
		
		logger.debug("showMailLeft ended.");
		
		return "ezEmail/mailLeft";
	}
	
	/**
	 * 메일 폴더 리스트 정보 호출 함수
	 */
	@RequestMapping(value="/ezEmail/getFolderList.do", produces="text/xml; charset=utf-8")
	@ResponseBody
	public String getFolderList(@CookieValue("loginCookie") String loginCookie, Locale locale, HttpServletRequest request) throws Exception {
		logger.debug("getFolderList started.");
		
		List<String> userInfo = commonUtil.getUserIdAndPassword(loginCookie);
		String password  = userInfo.get(1);
		
		LoginVO loginInfo = commonUtil.userInfo(loginCookie);
		String domainName = ezCommonService.getTenantConfig("DomainName", loginInfo.getTenantId());
		String userEmail = loginInfo.getId() + "@" + domainName;
		logger.debug("userEmail=" + userEmail);
		
		Document doc = commonUtil.convertRequestToDocument(request);
		String folderName = doc.getElementsByTagName("URL").item(0).getTextContent();
		String bcount = doc.getElementsByTagName("BCOUNT").item(0).getTextContent();
		logger.debug("folderName=" + folderName);
		
		StringBuilder subFolderXML = new StringBuilder();
		
		IMAPAccess ia = null;
		try {
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userEmail, password, egovMessageSource, locale);
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
		
		logger.debug("getFolderList ended.");
		
		return subFolderXML.toString();
	}
	
	/**
	 * 읽지않은 메시지 개수 정보 호출 함수
	 */
	@RequestMapping(value="/ezEmail/getFolderUnreadCount.do", produces="text/xml; charset=utf-8")
	@ResponseBody
	public String getFolderUnreadCount(@CookieValue("loginCookie") String loginCookie, Locale locale, HttpServletRequest request) throws Exception {
		logger.debug("getFolderUnreadCount started.");
		
		List<String> userInfo = commonUtil.getUserIdAndPassword(loginCookie);
		String password  = userInfo.get(1);
		
		LoginVO loginInfo = commonUtil.userInfo(loginCookie);
		String domainName = ezCommonService.getTenantConfig("DomainName", loginInfo.getTenantId());
		String userEmail = loginInfo.getId() + "@" + domainName;
		logger.debug("userEmail=" + userEmail);
		
		Document doc = commonUtil.convertRequestToDocument(request);
		String folderName = doc.getElementsByTagName("URL").item(0).getTextContent();
		logger.debug("folderName=" + folderName);
		
		IMAPAccess ia = null;
		String unreadCountXML = null;
		
		try {
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userEmail, password, egovMessageSource, locale);
			unreadCountXML = "<DATA>"+ia.getUnreadCount(folderName)+"</DATA>";
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (ia != null) {
				ia.close();
			}
		}
		
		logger.debug("getFolderUnreadCount ended.");
		
		return unreadCountXML;
	}
	
	/**
	 * PC에서 메일 가져오기 화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailImport.do")
	public String mailImport(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		logger.debug("mailImport started.");
		
		String browser = ClientUtil.getClientInfo(request, "browser");
		boolean isCrossBrowser = browser.equals("IE9") ? false : true;
		
		model.addAttribute("isCrossBrowser", isCrossBrowser);
		
		logger.debug("mailImport ended.");
		
		return "ezEmail/mailImport";
	}
	
	/**
	 * PC에서 메일 가져오기 실행 함수
	 */
	@RequestMapping(value="/ezEmail/mailImportUpload.do")
	public String mailImportUpload(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, MultipartHttpServletRequest request) throws Exception{
		logger.debug("mailImportUpload started.");
		
		String strResult = "ERROR";
		
		List<String> userInfo = commonUtil.getUserIdAndPassword(loginCookie);
		String password  = userInfo.get(1);
		
		LoginVO loginInfo = commonUtil.userInfo(loginCookie);
		String domainName = ezCommonService.getTenantConfig("DomainName", loginInfo.getTenantId());
		String userEmail = loginInfo.getId() + "@" + domainName;
		logger.debug("userEmail=" + userEmail);
		
		List<MultipartFile> multiFile = request.getFiles("file1");
		String folderId = request.getParameter("folderid");
		logger.debug("folderId=" + folderId);
		
		if (multiFile != null) {
			
			SMTPAccess sa = SMTPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.SMTPPort"),
					userEmail, password);
			
			IMAPAccess ia = null;
			try {
				ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
						userEmail, password, egovMessageSource, locale);
				
				Folder folder = ia.getFolder(folderId);
				
				if (folder == null || !folder.exists()) {
					logger.error("Folder not found. folderId=" + folderId);
				} else {
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
				strResult = "ERROR : " + e.getMessage();
				e.printStackTrace();
			} finally {
				if (ia != null) {
					ia.close();
				}
			}
		}
		
		model.addAttribute("strResult", strResult);
		
		logger.debug("mailImportUpload ended.");
		
		return "ezEmail/mailImportUpload";
	}
	
	/**
	 * PC에서 메일 가져오기 실행 함수(ActiveX)
	 */
	@RequestMapping(value="/ezEmail/mailImportUploadX.do", produces = "text/plain; charset=utf-8")
	@ResponseBody
	public String mailImportUploadX(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		logger.debug("mailImportUploadX started.");
		
		String strResult = "ERROR";
		
		String sFileTitle = request.getParameter("name");
        String sExt = request.getParameter("ext");
        String folderId = request.getParameter("dir");
		
        logger.debug("sFileTitle=" + sFileTitle + ",sExt=" + sExt + ",folderId=" + folderId);
        
        if (sFileTitle == null || sExt == null || !sExt.toLowerCase().equals("eml") || folderId == null) {
        	return strResult;
        }
        
        List<String> userInfo = commonUtil.getUserIdAndPassword(loginCookie);
		String password  = userInfo.get(1);
        
		LoginVO loginInfo = commonUtil.userInfo(loginCookie);
		String domainName = ezCommonService.getTenantConfig("DomainName", loginInfo.getTenantId());
		String userEmail = loginInfo.getId() + "@" + domainName;
		logger.debug("userEmail=" + userEmail);
		
		SMTPAccess sa = SMTPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.SMTPPort"),
				userEmail, password);
		
		IMAPAccess ia = null;
		try {
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userEmail, password, egovMessageSource, locale);
			
			Folder folder = ia.getFolder(folderId);
			if (folder == null || !folder.exists()) {
				logger.error("Folder not found. folderId=" + folderId);
			} else {
				folder.open(Folder.READ_WRITE);
				
				InputStream inputStream = request.getInputStream();
				MimeMessage message = sa.readMimeMessage(inputStream);
				inputStream.close();
				
				folder.appendMessages(new Message[]{message});
				folder.close(true);
				
				strResult = "OK";
			}
			
		} catch (MessagingException e) {
			strResult = "ERROR : " + e.getMessage();
			e.printStackTrace();
		} finally {
			if (ia != null) {
				ia.close();
			}
		}
        
		logger.debug("strResult=" + strResult);
		logger.debug("mailImportUploadX ended.");
		
		return strResult;
	}
	
	/**
	 * PC에 메일 저장하기 실행 함수
	 */
	@RequestMapping(value="/ezEmail/mailExport.do")
	public void mailExport(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request, HttpServletResponse response) throws Exception{
		logger.debug("mailExport started.");
		
		List<String> userInfo = commonUtil.getUserIdAndPassword(loginCookie);
		String password  = userInfo.get(1);
		
		LoginVO loginInfo = commonUtil.userInfo(loginCookie);
		String domainName = ezCommonService.getTenantConfig("DomainName", loginInfo.getTenantId());
		String userEmail = loginInfo.getId() + "@" + domainName;
		logger.debug("userEmail=" + userEmail);
		
		String url = request.getParameter("url");
		logger.debug("url=" + url);
		
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
		
		logger.debug("filename=" + filename);
		
		filename = CommonUtil.getEncodedFileNameForDownload(request.getHeader("User-Agent"), filename);
		
		logger.debug("filename=" + filename);
		
		//특수문자(*|\:"<>?/.)를 밑줄(_)로 replace.
		//점(.)은 client browser에서 replace.
		filename = filename.replaceAll("\\*", "_");
		filename = filename.replaceAll("%7C", "_");
		filename = filename.replaceAll("%5C", "_");
		filename = filename.replaceAll("%3A", "_");
		filename = filename.replaceAll("%22", "_");
		filename = filename.replaceAll("%3C", "_");
		filename = filename.replaceAll("%3E", "_");
		filename = filename.replaceAll("%3F", "_");
		filename = filename.replaceAll("/", "_");
		
		filename = filename.replaceAll("\\|", "_");
		filename = filename.replaceAll("\\\\", "_");
		filename = filename.replaceAll(":", "_");
		filename = filename.replaceAll("\"", "_");
		filename = filename.replaceAll("<", "_");
		filename = filename.replaceAll(">", "_");
		filename = filename.replaceAll("\\?", "_");
		
		logger.debug("filename=" + filename);
		
		IMAPAccess ia = null;
		try {
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userEmail, password, egovMessageSource, locale);
			
			Folder folder = ia.getFolder(folderPath);
			
			String mimetype = "message/rfc822";	
			response.setContentType(mimetype);
			response.setHeader("Content-Disposition", "attachment; filename=\"" + filename + "\"");
			
			if (folder == null || !folder.exists()) {
				logger.error("Folder not found. folderPath=" + folderPath);
			} else {
				folder.open(Folder.READ_ONLY);
				Message message = ((IMAPFolder)folder).getMessageByUID(uid);
				
				if (message == null) {
					logger.error("Message not found. uid=" + uid);
				} else {
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
		
		logger.debug("mailExport ended.");
	}
	
}
