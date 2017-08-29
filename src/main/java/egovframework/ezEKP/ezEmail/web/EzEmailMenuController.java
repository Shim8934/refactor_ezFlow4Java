package egovframework.ezEKP.ezEmail.web;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.channels.ClosedChannelException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;
import java.util.Set;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.CopyOnWriteArrayList;
import java.util.concurrent.CopyOnWriteArraySet;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;
import java.util.zip.ZipOutputStream;

import javax.annotation.Resource;
import javax.json.JsonArray;
import javax.json.JsonObject;
import javax.mail.Folder;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.jsp.PageContext;
import javax.websocket.OnClose;
import javax.websocket.OnError;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.PathParam;
import javax.websocket.server.ServerEndpoint;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.w3c.dom.Document;

import com.sun.mail.imap.IMAPFolder;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezAddress.service.EzAddressService;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.logic.IMAPAccess;
import egovframework.ezEKP.ezEmail.logic.SMTPAccess;
import egovframework.ezEKP.ezEmail.util.EzEmailUtil;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.ClientUtil;
import egovframework.let.utl.fcc.service.CommonUtil;

/** 
 * @Description [Controller] 메일 메뉴
 * @author 오픈솔루션팀 이효민
 * @Modification Information
 *
 *    수정일                       수정자              수정내용
 *    ----------    ------    -------------------
 *    2016.04.14    이효민              신규작성
 *    2017.08.25    김유진              일부 웹 소켓 적용
 *
 * @see
 */

@ServerEndpoint(value = "/websocket/{getID}")
@Controller
public class EzEmailMenuController extends EgovFileMngUtil {
	
	private static final Logger logger = LoggerFactory.getLogger(EzEmailMenuController.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;

	@Autowired
	private EzAddressService ezAddressService;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;  
	
	@Resource(name = "EzCommonService")
    private EzCommonService ezCommonService;
	
	@Autowired
	private EzEmailUtil ezEmailUtil;
	
	// 웹소켓 커넥션은 인스턴스가 싱글톤이 아니기 때문에 힙에 생성되는 1개의 인스턴스 Map을 공유할 수 있도록 Static으로 선언하였다. 
	private static Map<String, Session> sessionMap = new ConcurrentHashMap<>();
	
	
	/**
	 * 메일 왼쪽화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailLeft.do")
	public String showMailLeft(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception {
		logger.debug("showMailLeft started.");
		System.out.println("mailLeft="+this);
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
					if (folderName.equalsIgnoreCase(egovMessageSource.getMessage("ezEmail.lhm01", locale))) {
						rootFolderXML.append(" caption='"+egovMessageSource.getMessage("ezEmail.t99000025", locale) + "(" + folderUnreadMessageCount + ")'");
					} else {
						rootFolderXML.append(" caption='" + folderName + "(" + folderUnreadMessageCount + ")'");
					}
				} else {
					if (folderName.equalsIgnoreCase(egovMessageSource.getMessage("ezEmail.lhm01", locale))) {
						rootFolderXML.append(" caption='" + egovMessageSource.getMessage("ezEmail.t99000025", locale) + "'");
					} else {
						rootFolderXML.append(" caption='" + folderName+"'");
					}
				}
				
				if (folderName.equalsIgnoreCase(egovMessageSource.getMessage("ezEmail.lhm01", locale))) {
					rootFolderXML.append(" foldername='" + egovMessageSource.getMessage("ezEmail.t99000025", locale) + "'");
				} else {
					rootFolderXML.append(" foldername='" + folderName+"'");
				}

				if (folderName.equalsIgnoreCase(egovMessageSource.getMessage("ezEmail.lhm01", locale))) {
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
				} else if (folderName.equalsIgnoreCase(egovMessageSource.getMessage("ezEmail.t99000029", locale))) {
					rootFolderXML.append(" orgBoxName='5'");
					rootFolderXML.append(" fullcaption='_JUNK'"); //수정
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
		
		Map<String, String> map = ezAddressService.getTopFolderSubCount(loginInfo.getTenantId(), loginInfo.getId(), loginInfo.getDeptID(), loginInfo.getCompanyID());
		
		String pHasSub = "";
		String dHasSub = "";
		String cHasSub = "";
		
		if (map != null) {
			if (map.get("P") != null && !map.get("P").equals("0")) {
				pHasSub = "1";
			}
			if (map.get("D") != null && !map.get("D").equals("0")) {
				dHasSub = "1";
			}
			if (map.get("C") != null && !map.get("C").equals("0")) {
				cHasSub = "1";
			}
		}
		
		rootAddressXML.append("<tree>");
		rootAddressXML.append("<nodes>");
        String xmlFormat = "<node imgidx=\"%s\" caption=\"%s\" ownerid=\"%s\" type=\"%s\" folderid=\"%s\" changekey=\"%s\" hassub=\"%s\"></node>";
        rootAddressXML.append(String.format(xmlFormat, "1", egovMessageSource.getMessage("ezEmail.t99000038", locale), user.getId(), "P", "0", "", pHasSub));
        rootAddressXML.append(String.format(xmlFormat, "1", egovMessageSource.getMessage("ezEmail.t99000039", locale), user.getDeptID(), "D", "0", "", dHasSub));
        rootAddressXML.append(String.format(xmlFormat, "1", egovMessageSource.getMessage("ezEmail.t99000040", locale), user.getCompanyID(), "C", "0", "", cHasSub));
        rootAddressXML.append("</nodes>");
        rootAddressXML.append("</tree>");
        
		String mailServerAddress = config.getProperty("config.MailServerAddress");
		
		String funCode = "1";
		if (request.getParameter("funCode") != null) {
			funCode = request.getParameter("funCode");
		}
		
		model.addAttribute("mailServerAddress", mailServerAddress);
		model.addAttribute("rootFolderXML", rootFolderXML.toString());
		model.addAttribute("rootAddressXML", rootAddressXML.toString());
		model.addAttribute("funCode", funCode);
		
		String useBizmekaSpambox = ezCommonService.getTenantConfig("UseBizmekaSpambox", loginInfo.getTenantId());
		
		if (useBizmekaSpambox.equals("YES")) {
			String credentialForBizmekaSpambox = ezEmailUtil.getCredentialForBizmekaSpambox(userEmail);
			
			model.addAttribute("useBizmekaSpambox", useBizmekaSpambox);
			model.addAttribute("credentialForBizmekaSpambox", credentialForBizmekaSpambox);
		}
		
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
							if (fd.getName().equalsIgnoreCase(egovMessageSource.getMessage("ezEmail.lhm01", locale))) {
								subFolderXML.append(" caption='"+egovMessageSource.getMessage("ezEmail.t99000025", locale)+"("+fd.getUnreadMessageCount()+")'");
							} else {
								subFolderXML.append(" caption='"+fd.getName()+"("+fd.getUnreadMessageCount()+")'");
							}
						} else {
							if(fd.getName().equalsIgnoreCase(egovMessageSource.getMessage("ezEmail.lhm01", locale))){
								subFolderXML.append(" caption='"+egovMessageSource.getMessage("ezEmail.t99000025", locale)+"'");
							} else {
								subFolderXML.append(" caption='"+fd.getName()+"'");
							}
						}
					} else {
						if(fd.getName().equalsIgnoreCase(egovMessageSource.getMessage("ezEmail.lhm01", locale))){
							subFolderXML.append(" caption='"+egovMessageSource.getMessage("ezEmail.t99000025", locale)+"'");
						} else {
							subFolderXML.append(" caption='"+fd.getName()+"'");
						}
					}
					if (fd.getName().equalsIgnoreCase(egovMessageSource.getMessage("ezEmail.lhm01", locale))) {
						subFolderXML.append(" foldername='"+egovMessageSource.getMessage("ezEmail.t99000025", locale)+"'");
					} else {
						subFolderXML.append(" foldername='"+fd.getName()+"'");
					}

					if (fd.getName().equalsIgnoreCase(egovMessageSource.getMessage("ezEmail.lhm01", locale))) {
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
			InputStream inputStream = null;
			MimeMessage message = null;
			
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
						try {
							inputStream = multiFile.get(i).getInputStream();
							message = sa.readMimeMessage(inputStream);
							logger.debug("subject=" + message.getSubject());
						} finally {
							try {
								inputStream.close();
							} catch (Exception e) {} 
						}
						
						if (message != null) {
							messages[i] = message;
						}
					}
					
					folder.appendMessages(messages);
					folder.close(true);
					
					logger.debug("mail import Success. messages size=" + messages.length);
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
	 * PC에 메일파일 저장하기 실행 함수
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
		
		IMAPAccess ia = null;
		try {
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userEmail, password, egovMessageSource, locale);
			
			Folder folder = ia.getFolder(folderPath);
			
			String mimetype = "message/rfc822";	
			response.setContentType(mimetype);
			
			if (folder == null || !folder.exists()) {
				logger.error("Folder not found. folderPath=" + folderPath);
			} else {
				folder.open(Folder.READ_ONLY);
				Message message = ((IMAPFolder)folder).getMessageByUID(uid);
				
				if (message == null) {
					logger.error("Message not found. uid=" + uid);
				} else {
					String subject = ezEmailUtil.getSubject(message);
					if(subject.trim().equals("")){
						subject = egovMessageSource.getMessage("ezEmail.kms03", locale);
					}
					
					String fileName = subject + ".eml";
					fileName = CommonUtil.getEncodedFileNameForDownload(request.getHeader("User-Agent"), fileName);
					logger.debug("fileName=" + fileName);
					
					response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
					
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
	
	/**
	 * 여러개의 메일파일을 zip파일로 서버에 저장하기 실행 함수
	 */
	@RequestMapping(value="/ezEmail/mailExportZip.do")
	@ResponseBody
	public String mailExportZip(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request, HttpServletResponse response) throws Exception{
		logger.debug("mailExportZip started.");
		
		String returnValue = "";
		
		List<String> userIdAndPassword = commonUtil.getUserIdAndPassword(loginCookie);
		String password  = userIdAndPassword.get(1);
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
		String userAccount = userInfo.getId() + "@" + domainName;
		logger.debug("userAccount=" + userAccount);
		
		Map<String, String[]> urlMap = request.getParameterMap();
		Set<String> folderList = urlMap.keySet();
		logger.debug("folderList=" + folderList.toString());
		
		String realPath = commonUtil.getRealPath(request);
		String pDirPath = commonUtil.getUploadPath("upload_mail.ROOT", userInfo.getTenantId());
		pDirPath = realPath + pDirPath;
		String guid = UUID.randomUUID().toString();
		String pDirTempPath = pDirPath + commonUtil.separator + "tempFileUpload" + commonUtil.separator + guid;
		
		IMAPAccess ia = null;
		ZipOutputStream zos = null;
		Map<String, Integer> fileNameMap = new HashMap<String, Integer>();
		
		try {
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userAccount, password, egovMessageSource, locale);
			
			File tempFile = new File(pDirTempPath + ".zip");
			if (tempFile.exists()) {
				tempFile.delete();
			}
			
			zos = new ZipOutputStream(new FileOutputStream(pDirTempPath + ".zip"));
			
			for (String folderPath : folderList) {
				String uids = urlMap.get(folderPath)[0];
				String[] uidArr = uids.split(",");
				
				Folder folder = ia.getFolder(folderPath);
				
				if (folder == null || !folder.exists()) {
					logger.error("Folder not found. folderPath=" + folderPath);
				} else {
					folder.open(Folder.READ_ONLY);
					
					for (String uid : uidArr) {
						Message message = ((IMAPFolder)folder).getMessageByUID(Long.parseLong(uid));
						
						if (message == null) {
							logger.error("Message not found. uid=" + uid);
							
						} else {
							
							String subject = ezEmailUtil.getSubject(message);
							
							if(subject.trim().equals("")){
								subject = egovMessageSource.getMessage("ezEmail.kms03", locale);
							}
							
							String fileName = subject.replaceAll("[\\\\/:*?\"<>|]", "_").replaceAll("[\\t\\r\\n\\v\\f]", "");
							String fileNameLowerCase = fileName.toLowerCase();
							
							// rename fileName if the fileName already exists
							if (fileNameMap.containsKey(fileNameLowerCase)) {
								int count = fileNameMap.get(fileNameLowerCase);
								
								if (count > -1) {
									while (true) {
										if (!fileNameMap.containsKey(fileNameLowerCase + " (" + ++count + ")")) {
											break;
										}
									}
									
									fileNameMap.put(fileNameLowerCase, count);
									
									fileName += " (" + count + ")";
									fileNameMap.put(fileName.toLowerCase(), -1);
								} else {
									fileNameMap.put(fileNameLowerCase, 1);
									
									fileName += " (1)";
									fileNameMap.put(fileName.toLowerCase(), -1);
								}
							} else {
								fileNameMap.put(fileNameLowerCase, 0);
							}
							
							fileName += ".eml";
//							logger.debug("fileName=" + fileName);
							
							ZipEntry zipEntry = new ZipEntry("/" + fileName);
							zos.putNextEntry(zipEntry);
							
							message.writeTo(zos);

							zos.closeEntry();
						}
					}
					
					folder.close(true);
				}
			}
			
			returnValue = guid;
			
		} catch (Exception e) {
			if (zos != null) {
				zos.close();
				zos = null;
			}
			
			File file = new File(pDirTempPath + ".zip");
			if (file.exists()) {
				file.delete();
			}
			
			e.printStackTrace();
		} finally {
			if (ia != null) {
				ia.close();
			}
			if (zos != null) {
				zos.close();
			}
		}
		
		logger.debug("mailExportZip ended. returnValue=" + returnValue);
		return returnValue;
	}
	
	/**
	 * PC에서 메일함(메일파일묶음) 가져오기 실행 함수
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/ezEmail/mailboxImportZip.do")
	public String mailboxImportZip(@CookieValue("loginCookie") String loginCookie, MultipartHttpServletRequest request, Locale locale, Model model) throws Exception{
		logger.debug("mailboxImportZip started.");

		String returnValue = "OK";
		ZipInputStream zis = null;
		IMAPAccess ia = null;
		int messageCount = 0;
		int currCount = 1;
		
		
		String userkey = request.getParameter("userkey");
		String sessionKeyName = "percent";
		Session session = null;
		
		try {
			List<String> userIdAndPassword = commonUtil.getUserIdAndPassword(loginCookie);
			String password  = userIdAndPassword.get(1);
			
			LoginVO userInfo = commonUtil.userInfo(loginCookie);
			String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
			String userAccount = userInfo.getId() + "@" + domainName;
			
			String folderPath = request.getParameter("folderPath");
			logger.debug("userAccount=" + userAccount + ",folderPath=" + folderPath);
			
			List<MultipartFile> multiFile = request.getFiles("file1");

			if (multiFile == null || multiFile.get(0) == null) {
				logger.error("Cannot find file.");
				throw new Exception("Cannot find file.");
			}

			zis = new ZipInputStream(multiFile.get(0).getInputStream());	

			ZipEntry ze = zis.getNextEntry();
			
			
			// 유저정보를 키로 가지고있는 세션맵에서 메세지 보낼 세션정보를 확인하고, 메일의 갯수를 확인한다.
			if (userkey != null) {
				ZipInputStream zis1 = new ZipInputStream(multiFile.get(0).getInputStream());	
				@SuppressWarnings("unused")
				ZipEntry tmpZe = zis.getNextEntry();
				
				while ((tmpZe = zis1.getNextEntry()) != null) {
					messageCount++;
				}
				
				session = sessionMap.get(userkey);
				logger.debug("[WebSocket] mailBoxImportZip SessionMap Size = "+ sessionMap.size() + " userkey=" + userkey + " SessionId=" + session.getId() + " SessionInfo=" + session.getBasicRemote());
			}
			
			SMTPAccess sa = SMTPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.SMTPPort"),
					userAccount, password);
			
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userAccount, password, egovMessageSource, locale);
			
			Folder folder = ia.getFolder(folderPath);

			
			if (folder == null || !folder.exists()) {
				logger.error("Folder not found. folderPath=" + folderPath);
			} else {
				folder.open(Folder.READ_WRITE);
				List<Message> messageList = new ArrayList<Message>();
				Message message = null;
				int count = 0;

				SimpleDateFormat dateFormat = new SimpleDateFormat("hh:mm:ss");
				String lastTime = dateFormat.format(System.currentTimeMillis());
				lastTime = lastTime.replaceAll(":", "");
				
				while(ze != null){
					count++;

					if (count % 50 == 0) {
						folder.appendMessages(messageList.toArray(new Message[0]));
						messageList = new ArrayList<Message>();
						
						System.gc();
					}
					
					message = sa.readMimeMessage(zis);
					messageList.add(message);
					
					ze = zis.getNextEntry();
					
					// 진행율 클라이언트에게 전송
					if (userkey != null) {
						
						int percent = (int)((double) currCount / (double) (messageCount -1) * 100.0 );
						String currTime = dateFormat.format(System.currentTimeMillis());
						currTime = currTime.replaceAll(":", "");
						
						int interval = Integer.parseInt(currTime) - Integer.parseInt(lastTime);
						
						JSONObject jsonObj = new JSONObject();
						jsonObj.put("status" , "progress"); 
						jsonObj.put("userkey", userkey);

						if (interval >= 2) {
							jsonObj.put(sessionKeyName, percent); 
							String json2 = jsonObj.toJSONString();
							handleMessage(json2, session);
							lastTime = currTime; 
						}
						currCount = currCount + 1;
					}
					
				}
				
				logger.debug("count=" + count);
				
				folder.appendMessages(messageList.toArray(new Message[0]));
				folder.close(true);
			}
			
			zis.closeEntry();
			
		} catch (Exception e) {
			returnValue = "ERROR";
			e.printStackTrace();
		} finally {
			if (ia != null) {
				ia.close();
			}
			if (zis != null) {
				zis.close();
			}
		}

		model.addAttribute("result", returnValue);

		logger.debug("mailboxImportZip ended.");
		return "ezEmail/mailboxImportZip";
	}
	
	/**
	 * 메일 zip파일 다운로드 실행 함수
	 */
	@RequestMapping(value="/ezEmail/downloadMailZip.do")
	public void downloadMailZip(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request, HttpServletResponse response) throws Exception{
		logger.debug("downloadMailZip started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
		String userAccount = userInfo.getId() + "@" + domainName;
		logger.debug("userAccount=" + userAccount);
		
		String tempZipName = request.getParameter("temp");
		logger.debug("tempZipName=" + tempZipName);
		
		String realPath = commonUtil.getRealPath(request);
		String pDirPath = realPath + commonUtil.getUploadPath("upload_mail.ROOT", userInfo.getTenantId());
		String filePath = pDirPath + commonUtil.separator + "tempFileUpload" + commonUtil.separator + tempZipName + ".zip";
		logger.debug("filePath=" + filePath);
		
		downFile(request, response, filePath, userAccount + ".zip");
		
		File zipFile = new File(filePath);
		if (zipFile.delete()) {
			logger.debug(tempZipName + ".zip file is deleted.");
		}
		
		logger.debug("downloadMailZip ended.");
	}
	
	
	
	
	/**
	 * 특정 메일함의 모든 메일을 zip파일로 서버에 저장하기 실행 함수
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/ezEmail/mailboxExportZip.do")
	@ResponseBody
	public String mailboxExportZip(@CookieValue("loginCookie") String loginCookie, Locale locale,
				Model model, HttpServletRequest request, HttpServletResponse response) throws Exception{
		logger.debug("mailboxExportZip started.");
		
		String returnValue = "";
		
		List<String> userIdAndPassword = commonUtil.getUserIdAndPassword(loginCookie);
		String password  = userIdAndPassword.get(1);
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
		String userAccount = userInfo.getId() + "@" + domainName;
		logger.debug("userAccount=" + userAccount);
		
		String folderPath = request.getParameter("folderPath");
		logger.debug("folderPath=" + folderPath);
		
		String realPath = commonUtil.getRealPath(request);
		String pDirPath = commonUtil.getUploadPath("upload_mail.ROOT", userInfo.getTenantId());
		pDirPath = realPath + pDirPath;
		String guid = UUID.randomUUID().toString();
		String pDirTempPath = pDirPath + commonUtil.separator + "tempFileUpload" + commonUtil.separator + guid;
		
		IMAPAccess ia = null;
		ZipOutputStream zos = null;
		Map<String, Integer> fileNameMap = new HashMap<String, Integer>();
		
		Session session = null;
		String userkey = request.getParameter("userkey");
		String sessionKeyName = "percent";
		
		// 유저정보를 키로 가지고있는 세션맵에서 메세지 보낼 세션정보를 가지고온다.
		if (userkey != null) {
			session = sessionMap.get(userkey);
			logger.debug("[WebSocket] mailBoxExportZip SessionMap Size = "+ sessionMap.size() + " userkey=" + userkey + " SessionId=" + session.getId() + " SessionInfo=" + session.getBasicRemote());
		}
		
		try {
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userAccount, password, egovMessageSource, locale);
			
			File tempFile = new File(pDirTempPath + ".zip");
			if (tempFile.exists()) {
				tempFile.delete();
			}
			
			zos = new ZipOutputStream(new FileOutputStream(pDirTempPath + ".zip"));
			
			Folder folder = ia.getFolder(folderPath);
			
			if (folder == null || !folder.exists()) {
				logger.error("Folder not found. folderPath=" + folderPath);
			} else {
				folder.open(Folder.READ_ONLY);

				Message[] messages = ((IMAPFolder)folder).getMessages();
				
				int messageCount = messages.length; // 총 메일 갯수
				int currCount = 1;

				SimpleDateFormat dateformat = new SimpleDateFormat("hh:mm:ss");
				String lastTime = dateformat.format(System.currentTimeMillis());
				lastTime = lastTime.replaceAll(":", "");
				
				for (Message message : messages) {

					JSONObject jsonObj = new JSONObject();
					String startTime = dateformat.format(System.currentTimeMillis());
					startTime = startTime.replaceAll(":", "");

					String subject = ezEmailUtil.getSubject(message);
					
					if(subject.trim().equals("")){
						subject = egovMessageSource.getMessage("ezEmail.kms03", locale);
					}
					
					String fileName = subject.replaceAll("[\\\\/:*?\"<>|]", "_").replaceAll("[\\t\\r\\n\\v\\f]", "");
					String fileNameLowerCase = fileName.toLowerCase();
					
					// rename fileName if the fileName already exists
					if (fileNameMap.containsKey(fileNameLowerCase)) {
						int count = fileNameMap.get(fileNameLowerCase);
						
						if (count > -1) {
							while (true) {
								if (!fileNameMap.containsKey(fileNameLowerCase + " (" + ++count + ")")) {
									break;
								}
							}
							
							fileNameMap.put(fileNameLowerCase, count);
							
							fileName += " (" + count + ")";
							fileNameMap.put(fileName.toLowerCase(), -1);
						} else {
							fileNameMap.put(fileNameLowerCase, 1);
							
							fileName += " (1)";
							fileNameMap.put(fileName.toLowerCase(), -1);
						}
					} else {
						fileNameMap.put(fileNameLowerCase, 0);
					}
					
					fileName += ".eml";
//					logger.debug("fileName=" + fileName);
					
					ZipEntry zipEntry = new ZipEntry("/" + fileName);
					zos.putNextEntry(zipEntry);
					
					message.writeTo(zos);

					zos.closeEntry();

					// 진행율 클라이언트에게 전송
					if (userkey != null) {
						
						String currTime = dateformat.format(System.currentTimeMillis());
						currTime = currTime.replaceAll(":", "");
						
						int interval = Integer.parseInt(currTime) - Integer.parseInt(lastTime);
						int percent = (int)((double) currCount / (double) (messageCount -1) * 100.0 );
						
						jsonObj.put("status", "progress"); // 현재 퍼센트
						jsonObj.put("userkey", userkey);
						
						if (interval >= 2) {
							jsonObj.put(sessionKeyName, percent); // 현재 퍼센트
							String json1 = jsonObj.toJSONString();
							handleMessage(json1, session);
							lastTime = currTime;
						}
						currCount = currCount + 1; // 현재 메일 카운트
					}
					
				}
				
				folder.close(true);
			}
			
			returnValue = guid;
			
		} catch (Exception e) {
			if (zos != null) {
				zos.flush();
				zos.close();
				zos = null;
			}
			
			File file = new File(pDirTempPath + ".zip");
			
			if (file.exists()) {
				file.delete();
			}
			
			e.printStackTrace();
			
		} finally {
			if (ia != null) {
				ia.close();
			}
			if (zos != null) {
				zos.flush();
				zos.close();
			}
			
		}
		
		logger.debug("mailboxExportZip ended. returnValue=" + returnValue);
		return returnValue;
	}
	
	/**
	 * 메일함 zip파일 다운로드 실행 함수
	 */
	@RequestMapping(value="/ezEmail/downloadMailboxZip.do")
	public void downloadMailboxZip(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request, HttpServletResponse response) throws Exception{
		logger.debug("downloadMailboxZip started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
		String userAccount = userInfo.getId() + "@" + domainName;
		logger.debug("userAccount=" + userAccount);
		
		String folderName = request.getParameter("folderName");
		String tempZipName = request.getParameter("temp");
		logger.debug("folderName=" + folderName + ",tempZipName=" + tempZipName);
		
		String realPath = commonUtil.getRealPath(request);
		String pDirPath = realPath + commonUtil.getUploadPath("upload_mail.ROOT", userInfo.getTenantId());
		String filePath = pDirPath + commonUtil.separator + "tempFileUpload" + commonUtil.separator + tempZipName + ".zip";
		logger.debug("filePath=" + filePath);
		
		downFile(request, response, filePath, userAccount + "_" + folderName + ".zip");
		
		File zipFile = new File(filePath);
		if (zipFile.delete()) {
			logger.debug(tempZipName + ".zip file is deleted.");
		}
		
		logger.debug("downloadMailboxZip ended.");
	}
	
	/**
	 * zip파일 삭제 실행 함수
	 */
	@RequestMapping(value="/ezEmail/deleteZipFile.do")
	public void deleteZipFile(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request, HttpServletResponse response) throws Exception{
		logger.debug("deleteZipFile started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String temp = request.getParameter("temp");
		String realPath = commonUtil.getRealPath(request);
		String pDirPath = commonUtil.getUploadPath("upload_mail.ROOT", userInfo.getTenantId());
		pDirPath = realPath + pDirPath;
		String pDirTempPath = pDirPath + commonUtil.separator + "tempFileUpload" + commonUtil.separator + temp;
		
		File file = new File(pDirTempPath + ".zip");
		if (file.exists()) {
			file.delete();
		}
		
		logger.debug("deleteZipFile ended.");
	}

	/**
	 * 웹소켓 처음 커넥션 맺을 때 호출되는 함수
	 * @param session
	 * @param getID
	 */
    @SuppressWarnings("unchecked")
	@OnOpen
    public void handleOpen(Session session, @PathParam("getID") String getID){
    	
    	logger.info("[WebSocket] OnOpen called. WebSocket Connected.");
    	
    	// 세션에 연결한 유저ID에 고유문자를 붙여서 메세지전송 대상의 유저를 구별하는 유일한 값을 부여한다.
    	UUID uuid = UUID.randomUUID();
    	String userkey = getID + String.valueOf(uuid);
        
    	// 특정유저의 세션을 Map에 보관한다.
        sessionMap.put(userkey, session);
        session = sessionMap.get(userkey);
        
        JSONObject jsonObj = new JSONObject();
        jsonObj.put("status", "start");
        jsonObj.put("userkey", userkey);
        String jsonStr = jsonObj.toJSONString();

        try {
        	// 클라이언트 연결을 확인하고 시작을 알린다.(유저의 고유문자를 전송)
        	this.handleMessage(jsonStr, session);
        } catch (Exception e) {
        	logger.debug("[WebSocket] handleOpen error occured.");
        	e.printStackTrace();
        }
        
        logger.info("[Websocket] UserKey="+ userkey + " sessionId=" + session.getId() + "sessionInfo=" + session.getBasicRemote() + "SessionMap Size=" + sessionMap.size());
        logger.info("[Websocket] SessionMap Size=" + sessionMap.size() + " this=" + this);
        
    }


    /**
     * 웹소켓 클라이언트와 메세지 송수신시 호출되는 함수
     * @param jsonStr
     * @param session
     * @throws Exception
     */
	@SuppressWarnings("unchecked")
	@OnMessage
    public void handleMessage(String jsonStr, Session session) throws Exception{
    	
		logger.info("[WebSocket] OnMessage called.");

		JSONObject sendObj = new JSONObject();
		JSONObject recObj = new JSONObject();
		JSONParser jsonParser = new JSONParser();
		recObj = (JSONObject) jsonParser.parse(jsonStr);
		
		String userkey = (String) recObj.get("userkey");
		
		if ( recObj.get("status").equals("start")) {
			session = sessionMap.get(userkey);
			sendObj.put("status", "transferStart");
			sendObj.put("userkey", userkey);
			jsonStr = sendObj.toJSONString();
			session.getBasicRemote().sendText(jsonStr);
			logger.info("[WebSocket] SessionId=" + session.getId() + " UserKey="+ userkey + " SessionMap Size=" + sessionMap.size() + " Connection Started.");
			
		} else if (recObj.get("status").equals("progress")) {
			session.getBasicRemote().sendText(jsonStr);
			logger.info("[WebSocket] SessionId=" + session.getId() + " Send message=" + jsonStr +" Connection progressed.");
			
		} else if (recObj.get("status").equals("close")) {
			handleClose(sessionMap.get(userkey));
			sessionMap.remove(userkey);
			logger.info("[WebSocket] SessionId=" + session.getId() +" UserKey=" + userkey + " SessionMap Size=" + sessionMap.size() +" Connection closed.");
			
		} else {
			if (recObj.get("percent").equals(100)) {
				sendObj.put("status", "close");
				jsonStr = sendObj.toJSONString();
				session.getBasicRemote().sendText(jsonStr);
			}
		}
    }

    /**
     * 웹소켓 커넥션 종료시 호출 함수
     * @param session
     */
    @OnClose
    public void handleClose(Session session){
    	logger.info("[WebSocket] OnClose called. WebSocket Disconnected.");
    }

    /**
     * 웹소켓 커넥션 에러시 호출 함수
     * @param t
     */
    @OnError
    public void handleError(Throwable t){
        t.printStackTrace();
    }

}
