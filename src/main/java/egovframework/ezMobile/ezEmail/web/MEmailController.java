package egovframework.ezMobile.ezEmail.web;

import java.net.URLDecoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;
import java.util.TimeZone;

import javax.annotation.Resource;
import javax.mail.Address;
import javax.mail.FetchProfile;
import javax.mail.Flags;
import javax.mail.Flags.Flag;
import javax.mail.Folder;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.UIDFolder;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.InternetHeaders;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeUtility;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.w3c.dom.Document;

import com.sun.mail.dsn.DispositionNotification;
import com.sun.mail.dsn.MultipartReport;
import com.sun.mail.imap.IMAPFolder;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.logic.IMAPAccess;
import egovframework.ezEKP.ezEmail.logic.SMTPAccess;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezEmail.util.EzEmailUtil;
import egovframework.ezEKP.ezEmail.vo.MailCancelVO;
import egovframework.ezEKP.ezEmail.vo.MailReadVO;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.ezMobile.ezEmail.vo.MEmailFolderVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovStringUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

/** 
 * @Description [Controller] 메일
 * @author 오픈솔루션팀 이효민
 * @Modification Information
 *
 *    수정일        수정자         수정내용
 *    ----------    ------    -------------------
 *    2017.06.13    이효민    신규작성
 *
 * @see
 */

@Controller
public class MEmailController extends EgovFileMngUtil {
	
	private static final Logger logger = LoggerFactory.getLogger(MEmailController.class);
	
	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;
	
	@Resource(name="crypto") 
	private EgovFileScrty egovFileScrty;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Resource(name="EzCommonService")
	private EzCommonService ezCommonService;
	
	@Autowired
	private EzEmailService ezEmailService;
	
	@Autowired
	private EzOrganAdminService ezOrganAdminService;
	
	@Autowired
	private EzEmailUtil ezEmailUtil;
	
	/**
	 * 모바일 메인 > 편지함 리스트 정보 표출 함수
	 */
	@RequestMapping(value = "/mobile/ezEmail/getFolderList.do")
	public String getFolderList(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie, HttpServletResponse response, Locale locale) throws Exception {
		logger.debug("getFolderList started.");
		
		List<String> userIdAndPassword = commonUtil.getUserIdAndPassword(loginCookie);
		String password  = userIdAndPassword.get(1);
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
		String userAccount = userInfo.getId() + "@" + domainName;
		logger.debug("userAccount=" + userAccount);
		
		String folderId = request.getParameter("folderId");
		logger.debug("folderId=" + folderId);
		
		List<MEmailFolderVO> mailFolderList = new ArrayList<MEmailFolderVO>();
		
		IMAPAccess ia = null;
		
		try {
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userAccount, password, egovMessageSource, locale);
			
			List<Folder> subMailFolder = null;
			
			if (folderId != null && !folderId.equals("")) {
				subMailFolder = ia.getSubFolders(folderId);
			} else {
				subMailFolder = ia.getTopLevelFolders();
			}
			
			MEmailFolderVO folder = null;
			
			for (int i=0; i<subMailFolder.size(); i++) {
				Folder f = subMailFolder.get(i);
				
				folder = new MEmailFolderVO();
				
				folder.setName(f.getName());
				folder.setFullName(f.getFullName());
				folder.setUnReadCount(f.getUnreadMessageCount());
				
				mailFolderList.add(folder);
			}
			
		} catch (MessagingException e) {
			e.printStackTrace();
		} finally {
			if (ia != null) {
				ia.close();
			}
		}
		
		model.addAttribute("mailFolderList", mailFolderList);
		
		logger.debug("getFolderList ended.");
		return "json";
	}
	
	/**
	 * 모바일 편지함 > 편지함 정보 표출 함수
	 */
	@RequestMapping(value = "/mobile/ezEmail/mailMain.do")
	public String mailMain(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie, HttpServletResponse response, Locale locale) throws Exception {
		logger.debug("mailMain started.");
		
		List<String> userIdAndPassword = commonUtil.getUserIdAndPassword(loginCookie);
		String password  = userIdAndPassword.get(1);
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
		String userAccount = userInfo.getId() + "@" + domainName;
		logger.debug("userAccount=" + userAccount);
		
		String folderId = request.getParameter("folderId");
		logger.debug("folderId=" + folderId);
		
		MEmailFolderVO folderInfo = new MEmailFolderVO();
		
		IMAPAccess ia = null;
		
		try {
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userAccount, password, egovMessageSource, locale);
			
			Folder folder = ia.getFolder(folderId);
			
			folderInfo.setName(folder.getName());
			folderInfo.setFullName(folder.getFullName());
			folderInfo.setUnReadCount(folder.getUnreadMessageCount());
			
			if (folder.list().length > 0) {
				folderInfo.setHasSub(true);
			} else {
				folderInfo.setHasSub(false);
			}
			
		} catch (MessagingException e) {
			e.printStackTrace();
		} finally {
			if (ia != null) {
				ia.close();
			}
		}

		model.addAttribute("folderInfo", folderInfo);
		
		logger.debug("mailMain ended.");
		
		return "/mobile/ezEmail/mMailMain";
	}
	
	@RequestMapping(value="/mobile/ezEmail/mailGetList.do",method=RequestMethod.POST)
	@ResponseBody
	public String getMobileMailList(@CookieValue("loginCookie") String loginCookie,@RequestBody String bodyData, Locale locale, Model model) throws Exception {
		logger.debug("getMailList started.");		
		logger.debug("bodyData=" + bodyData);
		
		bodyData = URLDecoder.decode(bodyData , "UTF-8");
		
		String[] data = bodyData.split("&");
		String folderId = data[0].split("=")[1];
		String start = data[1].split("=")[1];
		String end = data[2].split("=")[1];
		String search = "";
		String jsonMessages = "";
		
		if(data[3].split("/").length==2){
			search = data[3].split("/")[0] + "=" + data[3].split("/")[1];
		}
		
		JSONArray messageJsonArray = new JSONArray();
		// get user credentials
		
		boolean senderReceiverFlag = false;
		
		List<String> userIdAndPassword = commonUtil.getUserIdAndPassword(loginCookie);
		String password = userIdAndPassword.get(1);		
		
        LoginVO userInfo = commonUtil.userInfo(loginCookie);
        String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
        String userEmail = userInfo.getId() + "@" + domainName;
        
        String inboxName = egovMessageSource.getMessage("ezEmail.t644", locale);
        String sendName = egovMessageSource.getMessage("ezEmail.t644", locale);
        String tempName = egovMessageSource.getMessage("ezEmail.t644", locale);
		
        folderId = folderId.equals(inboxName) ? "INBOX" : folderId;
        
        senderReceiverFlag = folderId.equals(sendName) ? true : false;
        senderReceiverFlag = folderId.equals(tempName) ? true : false;
        
        logger.debug("userId=" + userInfo.getId() + ",tenantId=" + userInfo.getTenantId() + ",serverName=" + userInfo.getServerName() 
	            + ",folderId=" + folderId + ",start=" + start + ",end=" + end + "search=" + search);
        
        IMAPAccess ia = null;
        Message[] messages = null;
		try {
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userEmail, password, egovMessageSource, locale, 40*1000, 20*1000);
					
			Folder folder = ia.getFolder(folderId);		
			folder.open(Folder.READ_ONLY);
	        UIDFolder uidFolder = (UIDFolder)folder;
	        
	        JSONObject contentrange = new JSONObject();
	        
	        contentrange.put("contentrange", start + "-" + end);
	        
	        messageJsonArray.add(contentrange);
	        
	        boolean isUnreadOnly = false;
			
			if (!search.equals("")) {
				int index = search.indexOf("=");
				if (index >= 0) {
					String searchField = search.substring(0, index);
					final String searchValue = search.substring(index + 1);
					
					logger.debug("searchField=" + searchField + ",searchValue=" + searchValue);
					
					messages = ezEmailUtil.searchFolder(folder, searchField, searchValue, null, null, false, null, isUnreadOnly);
				}
			}
			else if (isUnreadOnly) {
				messages = ezEmailUtil.searchFolder(folder, "", "", null, null, false, null, isUnreadOnly);
			}
			
			if (messages == null) {
				messages = folder.getMessages(); 
			}
			
			int startNo = Integer.parseInt(start);
			int endNo = Math.min(Integer.parseInt(end), messages.length - 1);
			
	
			logger.debug("isUnreadOnly=" + isUnreadOnly);
							
			logger.debug("Message Length=" + messages.length);
			
			logger.debug("startNo=" + startNo + ",endNo=" + endNo);
			
			if (startNo <= endNo) {
				Message[] fetchMessages = Arrays.copyOfRange(messages, startNo, endNo + 1);
				FetchProfile fp = new FetchProfile();
								
				fp.add(UIDFolder.FetchProfileItem.UID);
				fp.add("X-Priority");
				fp.add(FetchProfile.Item.CONTENT_INFO);
				fp.add(FetchProfile.Item.ENVELOPE);
				fp.add(IMAPFolder.FetchProfileItem.INTERNALDATE);
				fp.add(FetchProfile.Item.SIZE);
				fp.add(FetchProfile.Item.FLAGS);
				
				fp.add("Subject");
				fp.add("From");
				fp.add("To");
				
				folder.fetch(fetchMessages, fp);					
			}
			
			
			
			for (int i = startNo; i <= endNo; i++) {
				Message message = messages[i];
				
				JSONObject messageJson = new JSONObject();
				
				messageJson.put("href",folderId+"/"+uidFolder.getUID(message));
				messageJson.put("fromemail","");
								
				// importance
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
				messageJson.put("importance",importance);
				
				// Flagged is used for bookmark
				int flagged = 0;
				if (message.isSet(Flags.Flag.FLAGGED)) {
					flagged = 1;
				}
				messageJson.put("flag",flagged);
				
				// attachment
				boolean isAttached = IMAPAccess.hasAttachment(message);
				int attached = isAttached ? 1 : 0;
				messageJson.put("attach",attached);
				
				String addressStr = "";
				Address[] addresses = null;
				if (!senderReceiverFlag) {
					addressStr = ezEmailUtil.getFromNameOrAddressOfMessage(message);
				}
				// in case of Sent mailbox
				else {
					addresses = message.getRecipients(Message.RecipientType.TO);
					if (addresses != null) {
						String toHeader = message.getHeader("To")[0];
						boolean isAscii = ezEmailUtil.isPureAscii(toHeader);
						
						StringBuilder addressBuilder = new StringBuilder();
						for (Address address : addresses) {
							addressStr = ((InternetAddress)address).getPersonal(); // name part
							if (addressStr == null) {
								addressStr = ((InternetAddress)address).getAddress(); // email address part
							}
							else {
								if (!isAscii) {
									byte[] rawBytes = addressStr.getBytes("iso-8859-1");
									
									addressStr = ezEmailUtil.decodeNonAsciiBytes(rawBytes);								
								}
								else {
									// decoding is needed for the name part
									addressStr = MimeUtility.decodeText(addressStr);
								}
							}						
							addressBuilder.append(addressStr);
							addressBuilder.append("; ");
						}
						addressStr = addressBuilder.toString();
						addressStr = addressStr.substring(0, addressStr.length() - 2);
					}								
				}
				messageJson.put("sender",addressStr);
							
				// subject
				String subject = ezEmailUtil.getSubject(message);								
				subject = (subject != null) ? subject : "";
						
				messageJson.put("subject",subject);
				
				// received date
				Date receivedDate = message.getReceivedDate();
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
				sdf.setTimeZone(TimeZone.getTimeZone("GMT"));
				String receivedDateStr = sdf.format(receivedDate);
				
				receivedDateStr = commonUtil.getDateStringInUTC(receivedDateStr, userInfo.getOffset(), false);
				
				messageJson.put("receivedt",receivedDateStr);
				
				// size
				messageJson.put("size",message.getSize());
				
				// read/unread
				int readFlag = message.isSet(Flags.Flag.SEEN) ? 1 : 0;
				messageJson.put("read",readFlag);
							
				if (message.isSet(Flags.Flag.ANSWERED)) {
					messageJson.put("contentclass","REPLY");
				}
				else {
					boolean isForwarded = ezEmailUtil.hasForwardedFlag(message);
					
					if (isForwarded) {
						messageJson.put("contentclass","FORWARD");
					}
					else {
						messageJson.put("contentclass","IPM.Note");
					}
				}
				
				messageJsonArray.add(messageJson);
			}
			
			JSONObject contentRange = new JSONObject();
			
			contentRange.put("start", start); 
			contentRange.put("end" , end);
			contentRange.put("total", messages.length);
			contentRange.put("BoxTCount", folder.getMessageCount());
			contentRange.put("BoxUCount", folder.getUnreadMessageCount());
			
			folder.close(false);
			messageJsonArray.add(contentRange);
			
			jsonMessages = messageJsonArray.toJSONString();
		
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (ia != null) {
				ia.close();
			}
		}
		
		return jsonMessages;
	}
	
	@RequestMapping(value="/mobile/ezEmail/mailMoveMessage.do",method=RequestMethod.POST)
	@ResponseBody
	public String mailMoveMessage(@CookieValue("loginCookie") String loginCookie, @RequestBody String bodyData, 
			Locale locale, Model model) throws Exception {
		logger.debug("mailMoveMessage started.");
		logger.debug("bodyData=" + bodyData);
		
		bodyData = URLDecoder.decode(bodyData, "UTF-8");
		
		String[] data = bodyData.split("&");
		
		String returnValue = "OK";
		
		IMAPAccess ia = null;
		
		try {
			List<String> userIdAndPassword = commonUtil.getUserIdAndPassword(loginCookie);
			String password = userIdAndPassword.get(1);
			
			String uniqueId =  data[0].split("=")[1];
			String mfolderId = data[1].split("=")[1];
			
			logger.debug("uniqueId, mfolderId=" + uniqueId + "," + mfolderId);
			
			if (uniqueId.endsWith(",")) {
				uniqueId = uniqueId.substring(0, uniqueId.length() - 1);
			}
			
			String[] folderAndMsgIdArray = uniqueId.split(",");
			String folderId = folderAndMsgIdArray[0].split("/")[0];			
			long[] uids = new long[folderAndMsgIdArray.length];
			
			for (int i = 0; i < folderAndMsgIdArray.length; i++) {
				String folderAndMsgId = folderAndMsgIdArray[i];
				String msgId = folderAndMsgId.split("/")[1];
				uids[i] = Long.parseLong(msgId);
			}
			
			LoginVO userInfo = commonUtil.userInfo(loginCookie);
	        String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
	        String userEmail = userInfo.getId() + "@" + domainName;
			
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userEmail, password, egovMessageSource, locale);
					
			IMAPFolder sourceFolder = (IMAPFolder)ia.getFolder(folderId);		
			sourceFolder.open(Folder.READ_WRITE);
			
			Message[] messages = sourceFolder.getMessagesByUID(uids);
			
			IMAPFolder movefolder = (IMAPFolder)ia.getFolder(mfolderId);			
			sourceFolder.copyUIDMessages(messages, movefolder);
			
			sourceFolder.setFlags(messages, new Flags(Flags.Flag.DELETED), true);
			
			sourceFolder.close(true);
		
		} catch (Exception e) {
			returnValue = "ERROR : " + e.getMessage();
			e.printStackTrace();
		} finally {
			if (ia != null) {
				ia.close();
			}
		}
		
		logger.debug("returnValue=" + returnValue);
		logger.debug("mailMoveCopyMessage ended.");
		
		return returnValue;
	}
	
	@RequestMapping(value="/mobile/ezEmail/mailDelete.do",method=RequestMethod.POST)
	@ResponseBody
	public String mailDelete(@CookieValue("loginCookie") String loginCookie, @RequestBody String bodyData,
			Locale locale, Model model) throws Exception {
		logger.debug("mailDelete started.");
		logger.debug("bodyData=" + bodyData);
		
		bodyData = URLDecoder.decode(bodyData, "UTF-8");
		
		String[] data = bodyData.split("&");
		String uniqueId =  data[0].split("=")[1];
		String folderId = data[1].split("=")[1];
		String returnData = "OK";
		
		boolean permanentlyDelete = false;
				
		// get user credentials
		List<String> userIdAndPassword = commonUtil.getUserIdAndPassword(loginCookie);
		String password = userIdAndPassword.get(1);
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
				
		long[] uids = null;
		
		if(folderId.equals(egovMessageSource.getMessage("ezEmail.t647", locale))){
			permanentlyDelete = true;
		}
		
		if (uniqueId.endsWith(",")) {
			uniqueId = uniqueId.substring(0, uniqueId.length() - 1);
		}
		String[] folderAndMsgIdArray = uniqueId.split(",");
		
		uids = new long[folderAndMsgIdArray.length];
		for (int i = 0; i < folderAndMsgIdArray.length; i++) {
			String folderAndMsgId = folderAndMsgIdArray[i];
			String msgId = folderAndMsgId.split("/")[1];
			logger.debug("msgId=" + msgId);
			uids[i] = Long.parseLong(msgId);
		}	
	
		logger.debug("folderId=" + folderId);
		
		IMAPAccess ia = null;
		
		try {
	        String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
	        String userEmail = userInfo.getId() + "@" + domainName;
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userEmail, password, egovMessageSource, locale);
					
			IMAPFolder sourceFolder = (IMAPFolder)ia.getFolder(folderId);		
			sourceFolder.open(Folder.READ_WRITE);		
	        
	        Message[] deleteMsgs = null;

	        deleteMsgs = sourceFolder.getMessagesByUID(uids);
	        
			if (!permanentlyDelete) {
				IMAPFolder deletedFolder = (IMAPFolder)ia.getFolder(egovMessageSource.getMessage("ezEmail.t647", locale));			
				sourceFolder.copyUIDMessages(deleteMsgs, deletedFolder);
			}
			
			sourceFolder.setFlags(deleteMsgs, new Flags(Flags.Flag.DELETED), true);

			sourceFolder.close(true);
		
		} catch (Exception e) {
			returnData = "ERROR : " + e.getMessage();
			e.printStackTrace();
		} finally {
			if (ia != null) {
				ia.close();		
			}
		}
		
		logger.debug("returnData=" + returnData);
		logger.debug("mailDelete ended.");
		
		return returnData;				
	}
	
	@RequestMapping(value="/mobile/ezEmail/mailRead.do")
	public String mobileReadMail(@CookieValue("loginCookie") String loginCookie, Locale locale, HttpServletRequest request, Model model) throws Exception {
		logger.debug("readMail started.");
		
		// get user credentials
		List<String> userInfo = commonUtil.getUserIdAndPassword(loginCookie);
		String password = userInfo.get(1);
		
		LoginVO loginInfo = commonUtil.userInfo(loginCookie);
		String domainName = ezCommonService.getTenantConfig("DomainName", loginInfo.getTenantId());
		String userEmail = loginInfo.getId() + "@" + domainName;
		logger.debug("userEmail=" + userEmail);
		
		// retrieve the passed in parameters
		String url = request.getParameter("iptURL");
		if (url == null) {
			url = request.getParameter("URL");
		}
		
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
		
		String pnFlag = "N";
		if (request.getParameter("PNFlag") != null) {
			pnFlag = request.getParameter("PNFlag");
		}
		
		String contentClass = request.getParameter("CONTENTCLASS");

		Address[] arrFroms = null;
		Address[] arrRecipientsTo = null;
		Address[] arrRecipientsCC = null;
		Address[] arrRecipientsBCC = null;
		Date date = null;
		String fromStr = null;
		String fromEmail = null;
		String toStr = null;
		String toHiddenStr = null;
		String ccStr = null;
		String ccHiddenStr = null;
		String bccStr = "";
		String subject = null;
		String dateStr = null;
		String title = null;
		String pReadFlag = "Y";
		String isDelete = "BMOVE";
		boolean isSentItems = false;
		String pIsCCFg = "Y";
		IMAPAccess ia = null;
		
		try {
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userEmail, password, egovMessageSource, locale);
			Folder f = ia.getFolder(folderPath);
			
			if (f == null || !f.exists()) {
				logger.error("Folder not found. folderPath=" + folderPath);
			} else {
				f.open(Folder.READ_WRITE);
				
				Message message = null;
				if(f.isOpen() && f instanceof IMAPFolder){
					message = ((IMAPFolder)f).getMessageByUID(uid);
				}
				
				if (message == null) {
					logger.error("Message not found. uid=" + uid);
				} else {
					FetchProfile fp = new FetchProfile();
					
					fp.add(FetchProfile.Item.ENVELOPE);
					fp.add(IMAPFolder.FetchProfileItem.INTERNALDATE);
					fp.add(FetchProfile.Item.SIZE);
					fp.add(FetchProfile.Item.FLAGS);
					fp.add("Subject");
					fp.add("From");
					fp.add("To");
					fp.add("Cc");
					fp.add("Bcc");
					
					Message[] fetchMessages = new Message[] {message};
					f.fetch(fetchMessages, fp);
					
					// From
					arrFroms = message.getFrom();
					
					if (arrFroms != null) {
						fromStr = ezEmailUtil.getFromNameOrAddressOfMessage(message);
						fromStr = commonUtil.trimDoubleQuotes(fromStr);
								
						fromEmail = ((InternetAddress)arrFroms[0]).getAddress();
					} else {
						String[] fromHeaders = message.getHeader("From");
						if (fromHeaders != null) {
							fromStr = MimeUtility.decodeText(message.getHeader("From")[0]);
						}
					}
					
					logger.debug("From=" + fromStr);
					
					// TO
					arrRecipientsTo = message.getRecipients(Message.RecipientType.TO);
					if(arrRecipientsTo != null){
						boolean toListme = false;
						for(int i=0; i<arrRecipientsTo.length; i++){
							if(((InternetAddress)arrRecipientsTo[i]).getAddress().equals(userEmail)){
								toListme = true;
								break;
							}
						}
						
						String toHeader = message.getHeader("To")[0];
						boolean isAscii = ezEmailUtil.isPureAscii(toHeader);						
						String name = null;
						
						for(int i=0; i<arrRecipientsTo.length; i++){
							name = ((InternetAddress)arrRecipientsTo[i]).getPersonal();
							if(name == null){
								name = ((InternetAddress)arrRecipientsTo[i]).getAddress();
							}
							else{
								if (!isAscii) {
									byte[] rawBytes = name.getBytes("iso-8859-1");
									
									name = ezEmailUtil.decodeNonAsciiBytes(rawBytes);								
								}
								else {
									name = MimeUtility.decodeText(name);
								}
								
								name = commonUtil.trimDoubleQuotes(name);
							}
							
							logger.debug("TO=" + name + ((InternetAddress)arrRecipientsTo[i]).getAddress());
							
							if(toListme){
								if(((InternetAddress)arrRecipientsTo[i]).getAddress().equals(userEmail)){
									if(arrRecipientsTo.length > 1){
										toStr = getReceiverHTML(name, ((InternetAddress)arrRecipientsTo[i]).getAddress()) + "<span>&nbsp;(" + egovMessageSource.getMessage("ezEmail.t10000", locale) + arrRecipientsTo.length + egovMessageSource.getMessage("ezEmail.t10001", locale) + ")&nbsp;<img src='/images/expnd.gif'  style='cursor:pointer;' onclick='ShowHiddenTo(this);' align='absmiddle'></span>";
									} else {
										toStr = getReceiverHTML(name, ((InternetAddress)arrRecipientsTo[i]).getAddress());
									}
								}
								if(toHiddenStr == null){
									toHiddenStr = getReceiverHTML(name, ((InternetAddress)arrRecipientsTo[i]).getAddress());
								} else{
									toHiddenStr += " , " + getReceiverHTML(name, ((InternetAddress)arrRecipientsTo[i]).getAddress());
								}
							} else {
								if(i == 0){
									if(arrRecipientsTo.length > 1){
										toStr = getReceiverHTML(name, ((InternetAddress)arrRecipientsTo[i]).getAddress()) + "<span>&nbsp;(" + egovMessageSource.getMessage("ezEmail.t10000", locale) + arrRecipientsTo.length + egovMessageSource.getMessage("ezEmail.t10001", locale) + ")&nbsp;<img src='/images/expnd.gif'  style='cursor:pointer;' onclick='ShowHiddenTo(this);' align='absmiddle'></span>";
									} else {
										toStr = getReceiverHTML(name, ((InternetAddress)arrRecipientsTo[i]).getAddress());
									}
								}
								if(toHiddenStr == null){
									toHiddenStr = getReceiverHTML(name, ((InternetAddress)arrRecipientsTo[i]).getAddress());
								} else {
									toHiddenStr += " , " + getReceiverHTML(name, ((InternetAddress)arrRecipientsTo[i]).getAddress());
								}
							}
						}
					}
					
					// CC
					arrRecipientsCC = message.getRecipients(Message.RecipientType.CC);
					if(arrRecipientsCC != null){
						boolean ccListme = false;
						for(int i=0; i<arrRecipientsCC.length; i++){
							if(((InternetAddress)arrRecipientsCC[i]).getAddress().equals(userEmail)){
								ccListme = true;
								break;
							}
						}
						
						String ccHeader = message.getHeader("Cc")[0];
						boolean isAscii = ezEmailUtil.isPureAscii(ccHeader);												
						String name = null;
						
						for(int i=0; i<arrRecipientsCC.length; i++){
							name = ((InternetAddress)arrRecipientsCC[i]).getPersonal();
							if(name == null) {
								name = ((InternetAddress)arrRecipientsCC[i]).getAddress();
							} else {
								if (!isAscii) {
									byte[] rawBytes = name.getBytes("iso-8859-1");
									
									name = ezEmailUtil.decodeNonAsciiBytes(rawBytes);								
								}
								else {								
									name = MimeUtility.decodeText(name);
								}
								
								name = commonUtil.trimDoubleQuotes(name);
							}
							
							logger.debug("CC=" + name + ((InternetAddress)arrRecipientsCC[i]).getAddress());
							
							if (ccListme) {
								if (((InternetAddress)arrRecipientsCC[i]).getAddress().equals(userEmail)) {
									if (arrRecipientsCC.length > 1) {
										ccStr = getReceiverHTML(name, ((InternetAddress)arrRecipientsCC[i]).getAddress()) + "<span>&nbsp;(" + egovMessageSource.getMessage("ezEmail.t10000", locale) + arrRecipientsCC.length + egovMessageSource.getMessage("ezEmail.t10001", locale) + ")&nbsp;<img src='/images/expnd.gif'  style='cursor:pointer;' onclick='ShowHiddenCc(this);' align='absmiddle'></span>";
									} else {
										ccStr = getReceiverHTML(name, ((InternetAddress)arrRecipientsCC[i]).getAddress());
									}
								}
								if (ccHiddenStr == null) {
									ccHiddenStr = getReceiverHTML(name, ((InternetAddress)arrRecipientsCC[i]).getAddress());
								} else {
									ccHiddenStr += " , " + getReceiverHTML(name, ((InternetAddress)arrRecipientsCC[i]).getAddress());
								}
							} else {
								if (i == 0) {
									if (arrRecipientsCC.length > 1) {
										ccStr = getReceiverHTML(name, ((InternetAddress)arrRecipientsCC[i]).getAddress()) + "<span>&nbsp;(" + egovMessageSource.getMessage("ezEmail.t10000", locale) + arrRecipientsCC.length + egovMessageSource.getMessage("ezEmail.t10001", locale) + ")&nbsp;<img src='/images/expnd.gif'  style='cursor:pointer;' onclick='ShowHiddenCc(this);' align='absmiddle'></span>";
									} else {
										ccStr = getReceiverHTML(name, ((InternetAddress)arrRecipientsCC[i]).getAddress());
									}
								}
								if (ccHiddenStr == null) {
									ccHiddenStr = getReceiverHTML(name, ((InternetAddress)arrRecipientsCC[i]).getAddress());
								} else {
									ccHiddenStr += " , " + getReceiverHTML(name, ((InternetAddress)arrRecipientsCC[i]).getAddress());
								}
							}
						}
					}
	
					// BCC
					arrRecipientsBCC = message.getRecipients(Message.RecipientType.BCC);
					if (arrRecipientsBCC != null) {
						String name = null;
						for (int i=0; i<arrRecipientsBCC.length; i++){
							name = ((InternetAddress)arrRecipientsBCC[i]).getPersonal();
							if (name == null) {
								name = ((InternetAddress)arrRecipientsBCC[i]).getAddress();
							} else {
								name = MimeUtility.decodeText(name);
								name = commonUtil.trimDoubleQuotes(name);
							}
							
							logger.debug("BCC=" + name + ((InternetAddress)arrRecipientsBCC[i]).getAddress());
							
							if (i != 0) {
								bccStr += ", ";
							}
							bccStr += getReceiverHTML(name, ((InternetAddress)arrRecipientsBCC[i]).getAddress());
						}
					}
					
					if (ccStr == null || ccStr.equals("")) {
						pIsCCFg = "N";
					}
					
					// received date
					date = message.getReceivedDate();
					if (date != null) {
						SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
						sdf.setTimeZone(TimeZone.getTimeZone("GMT"));
						String receivedDateStr = sdf.format(date);
						
						dateStr = commonUtil.getDateStringInUTC(receivedDateStr, loginInfo.getOffset(), false);
					}
					logger.debug("dateStr=" + dateStr);
					
					// subject
					subject = ezEmailUtil.getSubject(message);
					
					logger.debug("subject=" + subject);
					
					if (subject != null) {
						title = egovMessageSource.getMessage("ezEmail.t565", locale) + subject;
					}
					
					if (message.getFolder().getFullName().equals(egovMessageSource.getMessage("ezEmail.t99000026", locale))) {
						isSentItems = true;
					}
					
					if (message.getFolder().getFullName().equals(egovMessageSource.getMessage("ezEmail.t99000028", locale))) {
						isDelete = "BDELETE";
					}
					
					if (!message.isSet(Flag.SEEN)) {
						pReadFlag = "N";
						message.setFlag(Flag.SEEN, true);
						logger.debug("Message's seen flag changed to true.");
					}
				}
				f.close(true);
			}
		} catch (MessagingException e) {
			e.printStackTrace();
		} finally {
			if (ia != null) {
				ia.close();
			}
		}
		
		model.addAttribute("fromStr", fromStr);
		model.addAttribute("fromEmail", fromEmail);
		model.addAttribute("url", url);
		model.addAttribute("toStr", toStr);
		model.addAttribute("toHiddenStr", toHiddenStr);
		model.addAttribute("ccStr", ccStr);
		model.addAttribute("ccHiddenStr", ccHiddenStr);
		model.addAttribute("bccStr", bccStr);
		model.addAttribute("dateStr", dateStr);
		model.addAttribute("subject", subject);
		model.addAttribute("title", title);
		model.addAttribute("folderPath", folderPath);
		model.addAttribute("uid", uid);
		model.addAttribute("pReadFlag", pReadFlag);
		model.addAttribute("isDelete", isDelete);
		model.addAttribute("isSentItems", isSentItems);
		model.addAttribute("pnFlag", pnFlag);
		model.addAttribute("pIsCCFg", pIsCCFg);
		model.addAttribute("jMochaStandAlone", config.getProperty("config.IsJMochaStandAlone"));
		
		logger.debug("readMail ended.");
		
		return "ezEmail/mailRead";
	}
	
	@RequestMapping(value="/mobile/ezEmail/mailReadContent.do")
	public String readMailContent(@CookieValue("loginCookie") String loginCookie, Locale locale, HttpServletRequest request, Model model) throws Exception {
		logger.debug("readMailContent started.");
		
		String rejectKeyWord = "";
		
		// get user credentials
		List<String> userCookieInfo = commonUtil.getUserIdAndPassword(loginCookie);
		String password = userCookieInfo.get(1);
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
		String userEmail = userInfo.getId() + "@" + domainName;
		logger.debug("userEmail=" + userEmail);
		
		// retrieve the passed in parameters
		long uid = Long.parseLong(request.getParameter("iptURL"));
		String folderPath = request.getParameter("iptFolderPath");
		String url = folderPath + "/" + request.getParameter("iptURL");
		logger.debug("url=" + url);
		
		IMAPAccess ia = null;
		List<String> bodyInfoList = null;
		String pAttachListHtmlSub = null;
	    boolean retryFlag = false;
	    int retryCount = 1; // 메일 읽기 실패 시 재시도 횟수        
	    
	    do {		
			try {
				ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
						userEmail, password, egovMessageSource, locale);
				
	            if (retryFlag) {
	                retryFlag = false;
	            }
				
				Folder f = ia.getFolder(folderPath);
				
				if (f == null || !f.exists()) {
					logger.error("Folder not found. folderPath=" + folderPath);
				} else {
					f.open(Folder.READ_ONLY);
					Message message = null;
					
					if (f.isOpen() && f instanceof IMAPFolder) {
						message = ((IMAPFolder)f).getMessageByUID(uid);
					}
					
					if (message == null) {
						logger.error("Message not found. uid=" + uid);
					} else {
						bodyInfoList = ezEmailUtil.getBodyInfo(message, folderPath, uid, -1, null, false, locale);
						double size = Double.parseDouble(bodyInfoList.get(2));
						String strSize = ezEmailUtil.getSizeWithUnit(size);
						pAttachListHtmlSub = " - <b>" + bodyInfoList.get(3) + egovMessageSource.getMessage("ezEmail.t180", locale) + "</b>(" + strSize + ")";
						
						if (!folderPath.equals(egovMessageSource.getMessage("ezEmail.t99000026", locale))) {
						    String[] messageIds = message.getHeader("Message-ID");
						    
						    if (messageIds != null) {
						        logger.debug("Message-ID=" + messageIds[0]);
						    } else {
						        logger.debug("No Message-ID");
						    }
						    
							// send an MDN to the sender.
							if (!ezEmailUtil.hasMDNSentFlag(message)) {
								logger.debug("MDNSentFlag isn't set.");
								
								// retrieve user info from db.
								OrganUserVO userVO = ezOrganAdminService.getUserInfo(userInfo.getId(), userInfo.getPrimary(), userInfo.getTenantId());
								
								SMTPAccess sa = SMTPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.SMTPPort"),
										userEmail, password);
								
								processAutoMDN(sa, message, userEmail, userVO.getDisplayName());
							}
							else {
								logger.debug("MDNSentFlag is set");
							}
						}
					}
				}
			} catch (Exception e) { 
				e.printStackTrace();
				
	            retryFlag = true;
	            --retryCount;
	            
	            if (retryCount > -1) {
	                logger.debug("Message read fail. Retry...");
	                
	                try {
	                    Thread.sleep(1000);
	                } catch (Exception ex) {}
	            }                   			
			} finally {
				if (ia != null) {
					ia.close();
				}
			}
	    } while (retryFlag && retryCount > -1);		
		
		model.addAttribute("htmlBody", bodyInfoList.get(0));
		model.addAttribute("pAttachListHtml", bodyInfoList.get(1));
		model.addAttribute("pAttachListHtmlSub", pAttachListHtmlSub);
		model.addAttribute("isAttach", bodyInfoList.get(4));
		model.addAttribute("url", url);
		model.addAttribute("rejectKeyWord", rejectKeyWord);
		
		logger.debug("readMailContent ended.");
		
		return "ezEmail/mailReadContent";
	}

	@RequestMapping(value="/mobile/ezEmail/mailGetReceiveList.do")
		public String mailGetReceiveList(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, @RequestBody String bodyData) throws Exception{
			//차후에 StringBuilder 모두 삭제 예정
			logger.debug("mailGetReceiveList started.");
			bodyData = URLDecoder.decode(bodyData,"UTF-8");
			logger.debug("bodyData=" + bodyData);
			
			List<String> userInfo = commonUtil.getUserIdAndPassword(loginCookie);
			String password  = userInfo.get(1);
			
			LoginVO loginInfo = commonUtil.userInfo(loginCookie);
			
			String domainName = ezCommonService.getTenantConfig("DomainName", loginInfo.getTenantId());
			String userEmail = loginInfo.getId() + "@" + domainName;
			logger.debug("userEmail=" + userEmail);
			
			String returnValue = "";
			
			String uidStr = bodyData.split("=")[1];
			uidStr = uidStr.split("/")[1];
			long uid = Long.parseLong(uidStr); 
			JSONObject readJSON = new JSONObject();
	
			
			IMAPAccess ia = null;
			try {
				ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
						userEmail, password, egovMessageSource, locale);
				
				Folder folder = ia.getFolder(egovMessageSource.getMessage("ezEmail.t99000026", locale));
				folder.open(Folder.READ_ONLY);
				Message message = ((IMAPFolder)folder).getMessageByUID(uid);
				
				StringBuilder sb = new StringBuilder();
				
				StringBuilder unreadSb = new StringBuilder();
				JSONObject unreadJSON = new JSONObject();
				sb.append("<DATA>");
				
				if (message == null) {
					logger.error("Message not found. uid=" + uid);
				} else {
					String messageId = ((MimeMessage)message).getMessageID() == null ? "" : ((MimeMessage)message).getMessageID();
					logger.debug("messageId = " + messageId);
					
					//TODO: 외부용 메일 처리
	//				String outerReadCheck = "NONE";
	//				if (message.ExtendedProperties.Count > 0) {
	//              	OuterReadCheck = GetExtendedPropertyName(message, "X-READCHECK");
	//          	}
					
					//get readList(수신확인)
					List<MailReadVO> readList = ezEmailService.getMailReadList(loginInfo.getTenantId(), loginInfo.getId(), messageId);
					
					//get cancelList(회수)
					List<MailCancelVO> cancelList = ezEmailService.getMailCancelList(messageId);
					
					//get all recipients from email message(메일)
					Address[] addresses = message.getAllRecipients();
					
					//get aliasAddressList from recipients
					List<String> addressList = new ArrayList<String>();
					for (Address address : addresses) {
						if (((InternetAddress)address).getAddress() != null) {
							addressList.add(((InternetAddress)address).getAddress());
						}
					}
					Map<String, String> aliasAddressList = ezEmailService.getAliasAddressMap(addressList, loginInfo.getTenantId());
					
					List<String> tempMailList = new ArrayList<String>();
					
					//recipients from email message
					for (Address address : addresses) {
						String email = ((InternetAddress)address).getAddress();
						String name = ((InternetAddress)address).getPersonal() == null ? 
								((InternetAddress)address).getAddress() : ((InternetAddress)address).getPersonal();
						if (email != null) {
							StringBuilder tempSb = new StringBuilder();
							JSONObject tempJSON = new JSONObject();
							tempSb.append("<ROW>");
							tempJSON.put("READEREMAIL",email);
							tempSb.append("<READEREMAIL><![CDATA[" + email + "]]></READEREMAIL>");
							tempJSON.put("READERNAME",name);
							tempSb.append("<READERNAME><![CDATA[" + name + "]]></READERNAME>");
							
							if (aliasAddressList.containsKey(email)) { //Alias주소인 경우
								email = aliasAddressList.get(email);
							}
							
							String readDate = "UNREAD";
							for (MailReadVO vo : readList) {
								if (vo.getReaderEmail().equals(email)) {
									readDate = commonUtil.getDateStringInUTC(vo.getReadDate(), loginInfo.getOffset(), false);
									break;
								}
							}
							tempSb.append("<READDATE><![CDATA[" + readDate + "]]></READDATE>");
							tempJSON.put("READDATE",readDate);
							
							String status = "";
							for (MailCancelVO vo : cancelList) {
								if (vo.getReaderEmail().equals(email)) {
									if (vo.getStatus() != null && !vo.getStatus().equals("")) {
										status = vo.getStatus();
									} else {
										status = "0";
									}
									break;
								}
							}
							tempSb.append("<CANCEL><![CDATA[" + status + "]]></CANCEL>");
							tempJSON.put("CANCEL",status);
	
							tempSb.append("</ROW>");
	
							if (readDate.equals("UNREAD")) {
								unreadSb.append(tempSb.toString());
								unreadJSON.put("tempJSON", tempJSON);
							} else {
								sb.append(tempSb.toString());
								readJSON.put("tempJSON", tempJSON);
							}
							
							tempMailList.add(email);
						}
					}
					
					//readList
					for (MailReadVO vo : readList) {
						if (!tempMailList.contains(vo.getReaderEmail())) {
							String readerEmail = vo.getReaderEmail();
							String readerName = vo.getReaderName();
							
							sb.append("<ROW>");
							sb.append("<READEREMAIL><![CDATA[" + readerEmail + "]]></READEREMAIL>");
							readJSON.put("READEREMAIL", readerEmail);
							sb.append("<READERNAME><![CDATA[" + readerName + "]]></READERNAME>");
							readJSON.put("READERNAME", readerName);
							vo.setReadDate(commonUtil.getDateStringInUTC(vo.getReadDate(), loginInfo.getOffset(), false));
							sb.append("<READDATE><![CDATA[" + vo.getReadDate() + "]]></READDATE>");
							readJSON.put("READDATE", vo.getReadDate());
							String status = "";
							for (MailCancelVO cvo : cancelList) {
								if (cvo.getReaderEmail().equals(vo.getReaderEmail())) {
									if (cvo.getStatus() != null && !cvo.getStatus().equals("")) {
										status = cvo.getStatus();
									} else {
										status = "0";
									}
									break;
								}
							}
							sb.append("<CANCEL><![CDATA[" + status + "]]></CANCEL>");
							readJSON.put("CANCEL", status);
							sb.append("</ROW>");
							
							tempMailList.add(readerEmail);
						}
					}
					
					//cancelList
					for (MailCancelVO vo : cancelList) {
						if (!tempMailList.contains(vo.getReaderEmail())) {
							String readerEmail = vo.getReaderEmail();
							
							unreadSb.append("<ROW>");
							unreadSb.append("<READEREMAIL><![CDATA[" + readerEmail + "]]></READEREMAIL>");
							unreadJSON.put("READEREMAIL", readerEmail);
							unreadSb.append("<READERNAME><![CDATA[" + readerEmail + "]]></READERNAME>");
							unreadJSON.put("READERNAME", readerEmail);
							unreadSb.append("<READDATE><![CDATA[UNREAD]]></READDATE>");
							unreadJSON.put("READDATE", "UNREAD");
							
							String status = "";
							if (vo.getStatus() != null && !vo.getStatus().equals("")) {
								status = vo.getStatus();
							} else {
								status = "0";
							}
							unreadSb.append("<CANCEL><![CDATA[" + status + "]]></CANCEL>");
							unreadJSON.put("CANCEL", status);
							unreadSb.append("</ROW>");
						}
					}
					
					sb.append(unreadSb.toString());
					readJSON.put("unreadJSON",unreadJSON);
					sb.append("<SUBJECT><![CDATA[" + message.getSubject() + "]]></SUBJECT>");
					readJSON.put("SUBJECT", message.getSubject());
					
				}
				
		        folder.close(true);
		        
		        sb.append("</DATA>");
				returnValue = sb.toString();
		        
			} catch (MessagingException e) {
				returnValue = "<DATA>ERROR</DATA>";
				e.printStackTrace();
			} finally {
				if (ia != null) {
					ia.close();
				}
			}
			
			logger.debug("returnValue=" + returnValue);
			logger.debug("mailGetReceiveList ended.");
			model.addAttribute("readJSON", readJSON);
			return "json";
		}

	private String getReceiverHTML(String name, String address){
		return "<span style='cursor:pointer' title='" + (address==null?"":EgovStringUtil.getSpclStrCnvr(address)) + "' onclick='show_personinfo(\"" + address + "\")'>" + (name==null?"":EgovStringUtil.getSpclStrCnvr(name)) + "</span>";
	}
	
	private void processAutoMDN(SMTPAccess sa, Message message, String myEmailAddress, String myName) {
		logger.debug("processAutoMDN started.");
		
		try {		
			String fromEmailAddress = ezEmailUtil.getFromEmailAddressOfMessage(message);
			
			logger.debug("myEmailAddress=" + myEmailAddress + ",fromEmailAddress=" + fromEmailAddress);
			
			int atSignIndex = fromEmailAddress.indexOf("@");
			
			if (fromEmailAddress.equals("") || atSignIndex == -1) {
				logger.debug("invalid fromEmailAddress=" + fromEmailAddress);
				return;
			}
			
			String fromEmailDomain = fromEmailAddress.substring(atSignIndex + 1);
			String myEmailDomain = myEmailAddress.substring(myEmailAddress.indexOf("@") + 1);
			
			logger.debug("fromEmailDomain=" + fromEmailDomain + ",myEmailDomain=" + myEmailDomain);
			
			if (!fromEmailDomain.equalsIgnoreCase(myEmailDomain)) {
				logger.debug("different domain");
				logger.debug("processAutoMDN ended.");
				return;
			}
									
			String[] messageIds = message.getHeader("Message-ID");
			String[] mdnHeaders = message.getHeader("Disposition-Notification-To");
			
			if (messageIds != null && mdnHeaders != null) {				
				logger.debug("Sending an MDN...");
											
				Message replyMessage = message.reply(false);
				
        		// ANSWERED flag needs to be cleared since the above reply method sets it.
				message.setFlag(Flags.Flag.ANSWERED, false);
				
				InternetHeaders h = new InternetHeaders();
				
				h.addHeader("Reporting-UA", "JMocha Mail 1.0");
				h.addHeader("Final-Recipient", String.format("rfc822;%s", myEmailAddress));
				h.addHeader("Original-Message-ID", messageIds[0]);
				h.addHeader("Disposition", "automatic-action/MDN-sent-automatically; displayed");
				
				DispositionNotification dn = new DispositionNotification();
				dn.setNotifications(h);
				
				MultipartReport mpr = new MultipartReport("This is a Read Receipt.", dn);
				replyMessage.setContent(mpr);		
				replyMessage.setFrom(new InternetAddress(myEmailAddress, myName, "UTF-8"));
										
				sa.sendMessageWithNewTransport(replyMessage);
				
				ezEmailUtil.setMDNSentFlag(message, true);
			}
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		
		logger.debug("processAutoMDN ended.");
	}
	
}