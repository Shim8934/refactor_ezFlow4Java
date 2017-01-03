package egovframework.ezEKP.ezEmail.web;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Properties;
import java.util.TimeZone;

import javax.annotation.Resource;
import javax.mail.Address;
import javax.mail.FetchProfile;
import javax.mail.Flags;
import javax.mail.Folder;
import javax.mail.Message;
import javax.mail.UIDFolder;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.w3c.dom.Document;

import com.sun.mail.imap.IMAPFolder;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.logic.IMAPAccess;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezEmail.util.EzEmailUtil;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

/** 
 * @Description [Controller] 메일 검색
 * @author 오픈솔루션팀 이동호
 * @Modification Information
 *
 *    수정일        수정자         수정내용
 *    ----------    ------    -------------------
 *    2016.05.20    이동호             신규작성
 *
 * @see
 */

@Controller
public class EzEmailMailSearchController {
	
    private static final Logger logger = LoggerFactory.getLogger(EzEmailMailSearchController.class);
    
	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;

    @Resource(name="egovMessageSource")
    private EgovMessageSource egovMessageSource;    

    @Resource(name="EzEmailService")
    private EzEmailService ezEmailService;        
	
    @Resource(name = "EzCommonService")
    private EzCommonService ezCommonService;
    
	@Autowired
	private EzEmailUtil ezEmailUtil;
	
    /**
	 * 메일 검색 화면 표시 함수
	 */
	@RequestMapping("/ezEmail/mailSearchView.do")
	public String mailSearchView(@CookieValue("loginCookie") String loginCookie, 
			Locale locale,
			HttpServletRequest request,
			Model model) throws Exception {
		logger.debug("mailSearchView started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
		String userEmail = userInfo.getId() + "@" + domainName;
		
		// get user credentials
		List<String> userIdAndPassword = commonUtil.getUserIdAndPassword(loginCookie);
		String password = userIdAndPassword.get(1);	
		
		String serverName = userInfo.getServerName();
		String userLang = userInfo.getLang();
		String useEditor = config.getProperty("config.EDITOR");
		
		long[] timeOffset = ezEmailUtil.getTimeOffsetInHourAndMinute();
		String userTimeSet = String.format("235|+%02d:%02d", timeOffset[0], timeOffset[1]);
		String addHour = String.format("+%02d", timeOffset[0]);
		
		logger.debug("userTimeSet=" + userTimeSet + ",addHour=" + addHour);
		
		List<String> topLevelFolderNames = null;
		IMAPAccess ia = null;
		try {
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userEmail, password, egovMessageSource, locale);
			
			List<Folder> topLevelFolders = ia.getTopLevelFolders();		
			
			topLevelFolderNames = new ArrayList<String>();
			int maxFolderCount = Math.min(5, topLevelFolders.size());
			
			for (int i = 0; i < maxFolderCount; i++) {
				Folder folder = topLevelFolders.get(i);
				
				topLevelFolderNames.add(folder.getName());
			}
			
			logger.debug("topLevelFolderNames=" + topLevelFolderNames);
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (ia != null) {
				ia.close();
			}
		}
		
		model.addAttribute("userId", userInfo.getId());
		model.addAttribute("serverName", serverName);
		model.addAttribute("userLang", userLang);
		model.addAttribute("useEditor", useEditor);
		model.addAttribute("userTimeSet", userTimeSet);
		model.addAttribute("addHour", addHour);
		model.addAttribute("topLevelFolderNames", topLevelFolderNames);
		
		logger.debug("mailSearchView ended.");
		
		return "ezEmail/mailSearchView";		
	}
	
	/**
	 * 메일 검색 함수
	 */
	@RequestMapping(value="/ezEmail/mailSearch.do",method=RequestMethod.POST,
			produces="text/xml; charset=utf-8")
	@ResponseBody
	public String mailSearch(@CookieValue("loginCookie") String loginCookie, @RequestBody String bodyData, Locale locale, Model model) throws Exception {
		logger.debug("mailSearch started.");		
		logger.debug("bodyData=" + bodyData);

		// get user credentials
		List<String> userIdAndPassword = commonUtil.getUserIdAndPassword(loginCookie);
		String password = userIdAndPassword.get(1);		
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
		String userEmail = userInfo.getId() + "@" + domainName;
		logger.debug("userEmail=" + userEmail);
		
		Document doc = commonUtil.convertStringToDocument(bodyData);
		
		String mailFolder = doc.getElementsByTagName("MAILFOLDER").item(0).getTextContent();
		String keyword = doc.getElementsByTagName("KEYWORD").item(0).getTextContent();
		String category = doc.getElementsByTagName("CATEGORY").item(0).getTextContent();
		String startDate = doc.getElementsByTagName("STARTDATE").item(0).getTextContent();
		String endDate = doc.getElementsByTagName("ENDDATE").item(0).getTextContent();
		String prop = doc.getElementsByTagName("PORP").item(0).getTextContent();
		String orderBy = doc.getElementsByTagName("ORDERBY").item(0).getTextContent();
		
		SimpleDateFormat sdfForParsing = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", locale);
		Date startDateObj = startDate.equals("") ? null : sdfForParsing.parse(startDate);
		Date endDateObj = endDate.equals("") ? null : new Date(sdfForParsing.parse(endDate).getTime() + 60*60*24*1000);
		
		String returnData = "";
		IMAPAccess ia = null;
		
		try {
		ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
				userEmail, password, egovMessageSource, locale, 150*1000, 20*1000);
						
		StringBuilder sb = new StringBuilder();
		sb.append("<DATA><ROWS>");
		
		Folder folder = null;
		Message[] messages = null;
		
		if (mailFolder.equals("ALL")) {
			List<Folder> topLevelFolders = ia.getTopLevelFolders();		
			
			List<String> topLevelFolderNames = new ArrayList<String>();
			int maxFolderCount = Math.min(5, topLevelFolders.size());
			
			for (int i = 0; i < maxFolderCount; i++) {
				Folder tmpFolder = topLevelFolders.get(i);
				
				topLevelFolderNames.add(tmpFolder.getName());
			}
			
			logger.debug("topLevelFolderNames=" + topLevelFolderNames);	
			
			for (String folderName : topLevelFolderNames) {
				Folder tmpFolder = ia.getFolder(folderName);
				
				if (folder == null) {
					folder = tmpFolder;
				}
				
				tmpFolder.open(Folder.READ_ONLY);			
				
				Message[] subMessages = ezEmailUtil.searchFolder(tmpFolder, category, keyword, startDateObj, endDateObj, true, null, false);
				
				if (messages == null) {
					messages = subMessages;
				}
				else if (subMessages.length > 0) {
				   int mainLen = messages.length;
				   int subLen = subMessages.length;
				   Message[] combined = new Message[mainLen + subLen];
				   System.arraycopy(messages, 0, combined, 0, mainLen);
				   System.arraycopy(subMessages, 0, combined, mainLen, subLen);	
				   
				   messages = combined;
				}				
				
				FetchProfile fp = new FetchProfile();
				
				fp.add(UIDFolder.FetchProfileItem.UID);
				fp.add("X-Priority");
				fp.add(FetchProfile.Item.CONTENT_INFO);
				fp.add(FetchProfile.Item.ENVELOPE);
				fp.add(IMAPFolder.FetchProfileItem.INTERNALDATE);
				fp.add(FetchProfile.Item.SIZE);
				fp.add(FetchProfile.Item.FLAGS);
				
				tmpFolder.fetch(messages, fp);		
			}
		}
		else {
			folder = ia.getFolder(mailFolder);
			folder.open(Folder.READ_ONLY);			
			messages = ezEmailUtil.searchFolder(folder, category, keyword, startDateObj, endDateObj, true, null, false);					
		}
				
		if (messages.length > 0) {
			String sortTypeSpecifier = prop;
			boolean isAscending = orderBy.equals("ASC") ? true : false;
			
			if (prop.equals("importance")) {
				sortTypeSpecifier = "importance";
			}
			else if (prop.equals("view")) {
				sortTypeSpecifier = "readFlag";
			}
			else if (prop.equals("flag")) {
				sortTypeSpecifier = "flag";
			}
			else if (prop.equals("attach")) {
				sortTypeSpecifier = "attachment";
			}
			else if (prop.equals("from")) {
				sortTypeSpecifier = "sender";
			}
			else if (prop.equals("subject")) {
				sortTypeSpecifier = "subject";
			}
			else if (prop.equals("recevdate")) {
				sortTypeSpecifier = "receivedDate";
			}
			else if (prop.equals("size")) {
				sortTypeSpecifier = "size";
			}		
			
			// sort the messages
			if (sortTypeSpecifier != null) {
				ezEmailUtil.sortMessages(folder, messages, sortTypeSpecifier, isAscending);
			}
			
			FetchProfile fp = new FetchProfile();
			
			if (sortTypeSpecifier.equals("importance")
					|| sortTypeSpecifier.equals("receivedDate")) {
				fp.add(UIDFolder.FetchProfileItem.UID);
				fp.add("X-Priority");
				fp.add(FetchProfile.Item.CONTENT_INFO);
				fp.add(FetchProfile.Item.ENVELOPE);
				fp.add(FetchProfile.Item.SIZE);
				fp.add(FetchProfile.Item.FLAGS);								
			}
			else if (sortTypeSpecifier.equals("readFlag")
						|| sortTypeSpecifier.equals("flag")) {
				fp.add(UIDFolder.FetchProfileItem.UID);
				fp.add("X-Priority");
				fp.add(FetchProfile.Item.CONTENT_INFO);
				fp.add(FetchProfile.Item.ENVELOPE);
				fp.add(FetchProfile.Item.SIZE);								
			}
			else if (sortTypeSpecifier.equals("attachment")) {
				fp.add(UIDFolder.FetchProfileItem.UID);
				fp.add("X-Priority");
				fp.add(FetchProfile.Item.ENVELOPE);
				fp.add(FetchProfile.Item.SIZE);
				fp.add(FetchProfile.Item.FLAGS);								
			}
			else if (sortTypeSpecifier.equals("sender") || sortTypeSpecifier.equals("subject")) {
				fp.add(UIDFolder.FetchProfileItem.UID);
				fp.add("X-Priority");
				fp.add(FetchProfile.Item.CONTENT_INFO);
				fp.add(FetchProfile.Item.FLAGS);								
			}
			else if (sortTypeSpecifier.equals("size")) {
				fp.add(UIDFolder.FetchProfileItem.UID);
				fp.add("X-Priority");
				fp.add(FetchProfile.Item.CONTENT_INFO);
				fp.add(FetchProfile.Item.ENVELOPE);
				fp.add(FetchProfile.Item.FLAGS);								
			}					
		
			folder.fetch(messages, fp);
			
			for (int i = 0; i < messages.length; i++) {
				Message message = messages[i];
				
				sb.append("<ROW>");
				
				Folder msgFolder = message.getFolder();
		        UIDFolder uidFolder = (UIDFolder)msgFolder;				
				String folderPath = msgFolder.getFullName();
				
				sb.append(String.format("<ITEMID><![CDATA[%s/%s]]></ITEMID>", folderPath, uidFolder.getUID(message)));
				
				String email = ezEmailUtil.getFromEmailAddressOfMessage(message);
				sb.append(String.format("<FROMEMAIL><![CDATA[%s]]></FROMEMAIL>", email));
				
				String name = ezEmailUtil.getFromNameOrAddressOfMessage(message);			
				sb.append(String.format("<FROMNAME><![CDATA[%s]]></FROMNAME>", name));
				
				Address[] addresses = message.getRecipients(Message.RecipientType.TO);
				String displayTo = ezEmailUtil.getStringListOfNameOrAddressOfAddresses(addresses);
				sb.append(String.format("<DISPLAYTO><![CDATA[%s]]></DISPLAYTO>", displayTo));
							
				Date receivedDate = message.getReceivedDate();
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");	
				sdf.setTimeZone(TimeZone.getTimeZone("UTC"));
				sb.append(String.format("<DATERECEIVED><![CDATA[%s]]></DATERECEIVED>", sdf.format(receivedDate)));
				
				String folderPathName = folderPath.replaceFirst("INBOX", egovMessageSource.getMessage("ezEmail.t99000025", locale));
				folderPathName = folderPathName.replaceAll("\\.", "/");
				sb.append(String.format("<PARENTNAME><![CDATA[/%s]]></PARENTNAME>", folderPathName));
				
				// subject
				String subject = message.getSubject();
				
				if (subject != null && !subject.equals("")) {
					String[] rawHeaders = message.getHeader("subject");
					String rawHeader = rawHeaders[0];
					
					// if the subject contains Non-Ascii characters(violating the standard), 
					// try to decode it by examining the characters.					
					if (!ezEmailUtil.isPureAscii(rawHeader)) {
						byte[] rawBytes = rawHeader.getBytes("iso-8859-1");
						
						subject = ezEmailUtil.decodeNonAsciiBytes(rawBytes);
					}
				}
				
				subject = (subject != null) ? subject : "";
				sb.append(String.format("<SUBJECT><![CDATA[%s]]></SUBJECT>", subject));
				
				String[] headers = message.getHeader("X-Priority");
				String header = headers != null ? headers[0] : "normal";
				int importance = 1;
				// startsWith is used since
				// there are cases like X-Priority: 1 (Highest) generated by Thunderbird.
				if (header.startsWith("1")) {
					importance = 2;
				}
				else if (header.startsWith("5")) {
					importance = 0;
				}			
				sb.append(String.format("<IMPORTANCE><![CDATA[%d]]></IMPORTANCE>", importance));
				
				// attachment
				boolean isAttached = IMAPAccess.hasAttachment(message);
				int attached = isAttached ? 1 : 0;			
				sb.append(String.format("<HASATTACHMENT><![CDATA[%d]]></HASATTACHMENT>", attached));
				
				int readFlag = message.isSet(Flags.Flag.SEEN) ? 1 : 0;			
				sb.append(String.format("<READ><![CDATA[%d]]></READ>", readFlag));
				
				sb.append(String.format("<CONTENTCLASS><![CDATA[%s]]></CONTENTCLASS>", "IPM.Note"));
				
				int flagged = 0;
				if (message.isSet(Flags.Flag.FLAGGED)) {
					flagged = 1;
				}			
				sb.append(String.format("<FLAG><![CDATA[%d]]></FLAG>", flagged));
				sb.append(String.format("<SIZE><![CDATA[%d]]></SIZE>", message.getSize()));
				
				sb.append("</ROW>");
			}
		}
		
		sb.append("</ROWS></DATA>");
		
		returnData = sb.toString();
		
		} catch (Exception e) {
			returnData = "<DATA>ERROR</DATA>";
			e.printStackTrace();
		} finally {
			if (ia != null) {
				ia.close();
			}
		}
		
		logger.debug("mailSearch ended.");
		
		return returnData;		
	}
	
	/**
	 * 메일 삭제 실행 함수(메일 검색)
	 */
	@RequestMapping(value="/ezEmail/mailDeleteS.do",method=RequestMethod.POST,
			produces="text/xml; charset=utf-8")
	@ResponseBody
	public String mailDeleteS(@CookieValue("loginCookie") String loginCookie, 
			@RequestParam("cmd") String cmd,
			@RequestBody String bodyData,
			Locale locale, Model model) throws Exception {
		logger.debug("mailDelete started.");
		logger.debug("cmd=" + cmd);
		logger.debug("bodyData=" + bodyData);
		
		// get user credentials
		List<String> userIdAndPassword = commonUtil.getUserIdAndPassword(loginCookie);
		String password = userIdAndPassword.get(1);
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
		String userEmail = userInfo.getId() + "@" + domainName;
		
		Document doc = commonUtil.convertStringToDocument(bodyData);
		String uniqueId = doc.getElementsByTagName("UNIQUEID").item(0).getTextContent();	
		
		String folderId = null;
		
		if (uniqueId.endsWith(",")) {
			uniqueId = uniqueId.substring(0, uniqueId.length() - 1);
		}
		String[] folderAndMsgIdArray = uniqueId.split(",");
					
		String returnData = "OK";
		
		IMAPAccess ia = null;
		try {
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userEmail, password, egovMessageSource, locale);
			
			for (int i = 0; i < folderAndMsgIdArray.length; i++) {
				String folderAndMsgId = folderAndMsgIdArray[i];
				folderId = folderAndMsgId.split("/")[0];
				String msgId = folderAndMsgId.split("/")[1];
				long uid = Long.parseLong(msgId);
				
				IMAPFolder sourceFolder = (IMAPFolder)ia.getFolder(folderId);		
				sourceFolder.open(Folder.READ_WRITE);		
				
				Message deleteMsg = sourceFolder.getMessageByUID(uid);
				
				if (deleteMsg != null) {
					deleteMsg.setFlag(Flags.Flag.DELETED, true);
				}
				
				sourceFolder.close(true);
			}	
		} catch (Exception e) {
			returnData = "ERROR";
			e.printStackTrace();
		} finally {
			if (ia != null) {
				ia.close();
			}
		}
				
		logger.debug("mailDelete ended.");
		
		return returnData;
	}
	
	/**
	 * 메일 이동/복사 실행 함수(메일 검색)
	 */
	@RequestMapping(value="/ezEmail/mailMoveCopyMessageS.do", produces="text/xml; charset=utf-8")
	@ResponseBody
	public String mailMoveCopyMessageS(@CookieValue("loginCookie") String loginCookie, @RequestBody String bodyData, 
			Locale locale, Model model) throws Exception {
		logger.debug("mailMoveCopyMessageS started.");
		logger.debug("bodyData=" + bodyData);
		
		String returnValue = "OK";
		
		List<String> userIdAndPassword = commonUtil.getUserIdAndPassword(loginCookie);
		String password = userIdAndPassword.get(1);
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
		String userEmail = userInfo.getId() + "@" + domainName;
		
		Document doc = commonUtil.convertStringToDocument(bodyData);
		String cmd = doc.getElementsByTagName("CMD").item(0).getTextContent();
		String uniqueId = doc.getElementsByTagName("UNIQUEID").item(0).getTextContent();
		String mfolderId = doc.getElementsByTagName("FOLDERID").item(0).getTextContent();
		
		if (uniqueId.endsWith(",")) {
			uniqueId = uniqueId.substring(0, uniqueId.length() - 1);
		}
		
		String[] folderAndMsgIdArray = uniqueId.split(",");
		
		IMAPAccess ia = null;
		
		try {
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userEmail, password, egovMessageSource, locale);
			
			for (int i = 0; i < folderAndMsgIdArray.length; i++) {
				String folderAndMsgId = folderAndMsgIdArray[i];
				String folderId = folderAndMsgId.split("/")[0];	
				String msgId = folderAndMsgId.split("/")[1];
				long uid = Long.parseLong(msgId);
				
				IMAPFolder sourceFolder = (IMAPFolder)ia.getFolder(folderId);		
				sourceFolder.open(Folder.READ_WRITE);
				
				Message message = sourceFolder.getMessageByUID(uid);
				
				if (message != null) {
					IMAPFolder movefolder = (IMAPFolder)ia.getFolder(mfolderId);			
					sourceFolder.copyUIDMessages(new Message[]{message}, movefolder);
					
					if (cmd.equalsIgnoreCase("MOVE")) {
						message.setFlag(Flags.Flag.DELETED, true);
					}
				}
				
				sourceFolder.close(true);
			}
		
		} catch (Exception e) {
			e.printStackTrace();
			returnValue = "ERROR : " + e.getMessage();
		} finally {
			if (ia != null) {
				ia.close();
			}
		}
		
		logger.debug("mailMoveCopyMessageS ended.");
		
		return returnValue;
	}
	
}
