package egovframework.ezEKP.ezEmail.web;

import java.util.List;
import java.util.Locale;
import java.util.Properties;

import javax.annotation.Resource;
import javax.mail.Flags;
import javax.mail.Folder;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

import com.sun.mail.imap.IMAPFolder;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.logic.IMAPAccess;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

/** 
 * @Description [Controller] 편지함 관리
 * @author 오픈솔루션팀 이효민
 * @Modification Information
 *
 *    수정일        수정자         수정내용
 *    ----------    ------    -------------------
 *    2016.05.03    이효민    신규작성
 *
 * @see
 */

@Controller
public class EzEmailFolderManageController extends EgovFileMngUtil{

	private static final Logger logger = LoggerFactory.getLogger(EzEmailFolderManageController.class);
	
	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;
	
	@Resource(name = "EzCommonService")
    private EzCommonService ezCommonService;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	/**
	 * 편지함 관리 화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailFolderManage.do")
	public String mailFolderManage(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		String pDeleteBoxID = egovMessageSource.getMessage("ezEmail.t99000028", locale);
		String pDeleteBoxName = egovMessageSource.getMessage("ezEmail.t99000028", locale);
		
		model.addAttribute("pDeleteBoxID", pDeleteBoxID);
		model.addAttribute("pDeleteBoxName", pDeleteBoxName);
		
		return "ezEmail/mailFolderManage";
	}
	
	/**
	 * 편지함 추가/수정 화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/inputNameDlg.do")
	public String inputNameDlg(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		
		return "ezEmail/mailInputNameDlg";
	}
	
	/**
	 * 편지함 이동/복사 화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailMoveCopy.do")
	public String mailMoveCopy(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		
		return "ezEmail/mailMoveCopy";
	}
	
	/**
	 * 편지함 추가/수정/삭제/이동/복사/메일삭제 실행 함수
	 */
	@RequestMapping(value="/ezEmail/mailMakeFolder.do")
	@ResponseBody
	public String mailMakeFolder(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, @RequestBody String bodyData) throws Exception{
		logger.debug("mailMakeFolder started.");
		logger.debug("bodyData=" + bodyData);
		
		String returnValue = "ERROR";
		
		Document xmlDoc = commonUtil.convertStringToDocument(bodyData);
		Element root = xmlDoc.getDocumentElement();
		
		String url = "";
		String name = "";
		String destination = "";
		String cmd = "";
		
		if (root.getElementsByTagName("URL") != null && root.getElementsByTagName("URL").item(0) != null) {
			url = root.getElementsByTagName("URL").item(0).getTextContent();
		}
		if (root.getElementsByTagName("NAME") != null && root.getElementsByTagName("NAME").item(0) != null) {
			name = root.getElementsByTagName("NAME").item(0).getTextContent();
		}
		if (root.getElementsByTagName("DESTINATION") != null && root.getElementsByTagName("DESTINATION").item(0) != null) {
			destination = root.getElementsByTagName("DESTINATION").item(0).getTextContent();
		}
		if (root.getElementsByTagName("CMD") != null && root.getElementsByTagName("CMD").item(0) != null) {
			cmd = root.getElementsByTagName("CMD").item(0).getTextContent();
		}
		
		List<String> userIdnPw = commonUtil.getUserIdAndPassword(loginCookie);
		String password  = userIdnPw.get(1);
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
		String userAccount = userInfo.getId() + "@" + domainName;
		logger.debug("userEmail=" + userAccount);
		
		IMAPAccess ia = null;
		try {
	        switch (cmd) {
	            case "NEW": 
	            	ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
	            			userAccount, password, egovMessageSource, locale);
	            	if (!name.equals("") && !url.equals("")) {
	            		Folder folder = ia.getFolder(url);
	            		if (folder.exists()) {
	            			Folder newFolder = ia.getFolder(url).getFolder(name);
	            			if (newFolder.exists()) {
	            				returnValue = "ALREADY_EXISTS";
	            			} else {
	            				boolean isCreated = newFolder.create(Folder.HOLDS_FOLDERS|Folder.HOLDS_MESSAGES);
	            				if (isCreated) {
	            					logger.debug(newFolder.getFullName() + " folder is created.");
	            					returnValue = "OK";
	            				}
	            			}
	            		}
	            	}
	                break;
	            case "MODIFY":
	            	ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
	            			userAccount, password, egovMessageSource, locale);
	            	if (!name.equals("") && !url.equals("")) {
		            	Folder oldFolder = ia.getFolder(url);
		            	
		            	if (oldFolder.exists()) {
		            		String parentPath = oldFolder.getParent().getFullName();
		            		Folder newFolder = ia.getFolder(parentPath).getFolder(name);
		            		
		            		if (newFolder.exists()) {
		            			returnValue = "ALREADY_EXISTS";
		            		} else {
			            		boolean isRenamed = ((IMAPFolder)oldFolder).renameTo(newFolder);
			            		if (isRenamed) {
			            			logger.debug(url + " folder is renamed as " + newFolder.getFullName() + ".");
			            			returnValue = "OK";
			            		}
		            		}
		            		
		            	}
	            	}
	                break;
	            case "MOVE": //폴더 이동(폴더삭제기능 포함 : 지운편지함으로 이동)
	            	ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
	            			userAccount, password, egovMessageSource, locale);
	            	if (!destination.equals("") && !url.equals("")) {
	            		Folder oldFolder = ia.getFolder(url);
	            		Folder destinationFolder = ia.getFolder(destination);
	            		
	            		if (oldFolder.exists() && destinationFolder.exists()) {
                			Folder movedFolder = destinationFolder.getFolder(oldFolder.getName());
                			
                			if (movedFolder.exists()) {
                				returnValue = "ALREADY_EXISTS";
                			} else {
                				boolean isRenamed = ((IMAPFolder)oldFolder).renameTo(movedFolder);
	    	            		if (isRenamed) {
	    	            			logger.debug(url + " folder is moved to " + destination + ".");
	    	            			returnValue = "OK";
	    	            		}
                			}
                			
	            		}
	            	}
	                break;
	            case "COPY": //특정 편지함을 복사 - 하위폴더는 복사하지 않음(닷넷버전은 하위폴더도 복사)
	            	ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
	            			userAccount, password, egovMessageSource, locale, 120000, 20000);
	            	if (!destination.equals("") && !url.equals("")) {
	            		Folder folder = ia.getFolder(url);
	            		Folder destinationFolder = ia.getFolder(destination);
	            		
	            		if (folder.exists() && destinationFolder.exists()) {
	            			Folder copiedFolder = destinationFolder.getFolder(folder.getName());
	            			
	            			if (copiedFolder.exists()) {
	            				returnValue = "ALREADY_EXISTS";
	            			} else {
	            				boolean isCreated = copiedFolder.create(Folder.HOLDS_FOLDERS|Folder.HOLDS_MESSAGES);
		        				if (isCreated) {
		        					logger.debug(folder.getName() + " folder is created.");
		        					folder.open(Folder.READ_WRITE);
		        					folder.copyMessages(folder.getMessages(), copiedFolder);
		        					folder.close(true);
		        					logger.debug(url + " folder is copied to " + destination + ".");
		        					returnValue = "OK";
		        				}
	            			}
	            			
	            		}
	            	}
	                break;
	            case "DEL": //지운편지함 하위에 있는 폴더 영구삭제 - 하위폴더도 삭제됨(메일도 삭제됨)
	            	ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
	            			userAccount, password, egovMessageSource, locale);
	            	if (!url.equals("")) {
	            		Folder folder = ia.getFolder(url);
	            		if (folder.exists()) {
	            			boolean isDeleted = folder.delete(true);
	            			if (isDeleted) {
	            				logger.debug(url + " folder is deleted.");
	            				returnValue = "OK";
	            			}
	            		}
	            	}
	                break;
	            case "MAILREALDEL": //지운편지함에 있는 모든 메시지 영구삭제
	            	ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
	            			userAccount, password, egovMessageSource, locale);
	            	if (!url.equals("")) {
	            		Folder folder = ia.getFolder(url);
	            		if (folder.exists()) {
	            			folder.open(Folder.READ_WRITE);
	            			Message[] messages = folder.getMessages();
	        				folder.setFlags(messages, new Flags(Flags.Flag.DELETED), true);
	            			folder.close(true);
	            			logger.debug(url + " folder is clean.");
	            			returnValue = "OK";
	            		}
	            	}
	                break;
	            case "MAILDEL": //특정폴더의 모든 메시지 삭제(지운편지함으로 이동)
	            	ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
	            			userAccount, password, egovMessageSource, locale, 120000, 20000);
	            	if (!url.equals("")) {
	            		String trashFolderName = egovMessageSource.getMessage("ezEmail.t99000028", locale);
            			Folder trashFolder = ia.getFolder(trashFolderName);
            			Folder folder = ia.getFolder(url);
            			
	            		if (folder.exists() && trashFolder.exists()) {
            				folder.open(Folder.READ_WRITE);
            				Message[] messages = folder.getMessages();
            				folder.setFlags(messages, new Flags(Flags.Flag.DELETED), true);
            				folder.copyMessages(messages, trashFolder);
            				folder.close(true);
            				logger.debug(url + " folder's message is moved to " + trashFolderName + ".");
            				returnValue = "OK";
	            		}
	            	}
	                break;
	            default:
	                break;
	        }
		} catch (MessagingException e) {
			returnValue = "ERROR : " + e.getMessage();
			e.printStackTrace();
		} finally {
			if (ia != null) {
				ia.close();
			}
		}
        
		logger.debug("returnValue=" + returnValue);
		logger.debug("mailMakeFolder ended.");
		
		return returnValue;
	}
}
