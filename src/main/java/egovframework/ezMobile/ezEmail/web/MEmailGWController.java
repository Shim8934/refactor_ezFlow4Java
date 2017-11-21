package egovframework.ezMobile.ezEmail.web;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.net.URLDecoder;
import java.nio.file.Files;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Base64;
import java.util.Base64.Decoder;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashSet;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;
import java.util.Set;
import java.util.TimeZone;
import java.util.UUID;
import java.util.concurrent.ExecutionException;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.activation.DataHandler;
import javax.activation.FileDataSource;
import javax.annotation.Resource;
import javax.mail.Address;
import javax.mail.BodyPart;
import javax.mail.FetchProfile;
import javax.mail.Flags;
import javax.mail.Flags.Flag;
import javax.mail.Folder;
import javax.mail.Header;
import javax.mail.Message;
import javax.mail.Message.RecipientType;
import javax.mail.MessagingException;
import javax.mail.Multipart;
import javax.mail.Part;
import javax.mail.Transport;
import javax.mail.UIDFolder;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import javax.mail.internet.MimePart;
import javax.mail.internet.MimeUtility;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.io.IOUtils;
import org.apache.commons.lang3.StringUtils;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import com.sun.mail.imap.AppendUID;
import com.sun.mail.imap.IMAPFolder;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezAddress.service.EzAddressService;
import egovframework.ezEKP.ezAddress.vo.AddressVO;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.logic.IMAPAccess;
import egovframework.ezEKP.ezEmail.logic.SMTPAccess;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezEmail.util.EzEmailUtil;
import egovframework.ezEKP.ezEmail.vo.MailColorVO;
import egovframework.ezEKP.ezEmail.vo.MailDistributionVO;
import egovframework.ezEKP.ezEmail.vo.MailSignatureVO;
import egovframework.ezEKP.ezEmail.web.EzEmailMailReadController;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.ezMobile.ezEmail.service.MEmailService;
import egovframework.ezMobile.ezOption.service.MOptionService;
import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.ezMobile.ezOption.vo.MOptionVO;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.ClientUtil;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovStringUtil;

@RestController
public class MEmailGWController extends EgovFileMngUtil {

private static final Logger LOGGER = LoggerFactory.getLogger(MEmailGWController.class);
	
	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;
	
	@Resource(name="loginService")
	private LoginService loginService;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Autowired
	private EzEmailUtil ezEmailUtil;
	
	@Autowired
	private EzEmailService ezEmailService;
	
	@Autowired
	private EzOrganService ezOrganService;
	
	@Autowired
	private EzAddressService ezAddressService;
	
	@Autowired
	private EzOrganAdminService ezOrganAdminService;
	
	@Autowired
	private EzEmailMailReadController ezEmailMailReadController;
	
	
	@Resource(name="MOptionService")
	private MOptionService mOptionService;
	
	@Resource(name = "EzCommonService")
    private EzCommonService ezCommonService;
	
	@Resource(name = "MEmailService")
	private MEmailService MEmailService;
	
	@Resource(name = "jspw")
    private String jspw;
		
	/**
	 * 모바일 G/W 이메일 [GET] 왼쪽 슬라이드 메뉴에 편지함 목록 조회, 메일 이동 시 편지함 목록 출력
	 */
	@RequestMapping(value="/mobile/ezemail/folders-list/users/{userId}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public Object mMailFolderList(HttpServletRequest request, @PathVariable String userId, @RequestParam(value="folderId", required=false) String folderId) {
		LOGGER.debug("MOBILE G/W MAIL [GET /ezemail/folders-list/users/{userId}] started.");
		
		JSONObject result = new JSONObject();
		IMAPAccess ia = null;
		
		try {
			folderId = URLDecoder.decode(folderId, "UTF-8");
			LOGGER.debug("folderId=" + folderId);
		
//			List<MEmailFolderVO> mailFolderList = new ArrayList<MEmailFolderVO>();
			JSONArray mailFolderList = new JSONArray();
		
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			String domainName = ezCommonService.getTenantConfig("DomainName", info.getTenantId());
			String userEmail = info.getUserId() + "@" + domainName;
			String password = jspw;
			
			String ld = commonUtil.getTwoLetterLangFromLangNum(info.getLang());
			Locale locale = new Locale(ld);
			
			MOptionVO opt = mOptionService.optionInfo(userId, info.getTenantId());
			if ( opt.getLang().equals("1") ) {
				locale = new Locale("ko");	
			} else if ( opt.getLang().equals("3") ) {
				locale = new Locale("ja");
			}
			
			LOGGER.debug("locale : ," + locale.getDisplayLanguage());
			
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userEmail, password, egovMessageSource, locale);
			
			List<Folder> subMailFolder = null;
//			JSONObject folder = null;
			
			if (folderId != null && !folderId.equals("")) {
				subMailFolder = ia.getSubFolders(folderId, true);
			} else {
				LOGGER.debug("getTopLevelFolders");
				subMailFolder = ia.getTopLevelFolders(true);
			}
			
			JSONObject folder = null;
			
			for (int i=0; i<subMailFolder.size(); i++) {
				Folder f = subMailFolder.get(i);
				
				folder = new JSONObject();
				
				if ( f.getName().equalsIgnoreCase(egovMessageSource.getMessage("ezEmail.lhm01", locale))) {
					folder.put("name", egovMessageSource.getMessage("ezEmail.t99000025", locale));
				} else {
					folder.put("name", f.getName());
				}
				folder.put("fullName", f.getFullName());
				folder.put("unReadCount", f.getUnreadMessageCount());
				
				if (f.list().length > 0) {
					folder.put("hasSub", true);
				} else {
					folder.put("hasSub", false);
				}
				mailFolderList.add(folder);
			}
			
//			if (!folderId.equals("")) {
//				subMailFolder = ia.getSubFolders(folderId);
//				
//				for (int i=0; i<subMailFolder.size(); i++) {
//					Folder f = subMailFolder.get(i);
//					folder = new JSONObject();
//					
//
//					if (f.getUnreadMessageCount()>0) {
//						folder.put("fullName", f.getFullName());
//						folder.put("unReadCount", f.getUnreadMessageCount());
//					} else {
//						folder.put("fullName", f.getFullName());
//						folder.put("unReadCount", f.getUnreadMessageCount());
//					}
//
//					folder.put("fullName", f.getFullName());
//					
//					if (f.list().length > 0) {
//						folder.put("hasSub", true);
//					} else {
//						folder.put("hasSub", false);
//					}
//					
//					mailFolderList.add(folder);
//				}
//			} else {
//				subMailFolder = ia.getTopLevelFolders();
//				for (int i=0,j=0; i<subMailFolder.size(); i++) {
//					Folder f = subMailFolder.get(i);
//					folder = new JSONObject();
//					
//					if (f.getName().equalsIgnoreCase("INBOX")) {
//						folder.put("name", "받은 편지함");
//					} else {
//						folder.put("name", f.getName());
//					}
//
//					if (fd.getName().equalsIgnoreCase(egovMessageSource.getMessage("ezEmail.lhm01", locale))) {
//						subFolderXML.append(" orgBoxName='0'");
//						subFolderXML.append(" fullcaption='_INBOX'"); //수정
//					} else if (fd.getName().equalsIgnoreCase(egovMessageSource.getMessage("ezEmail.t645", locale))) {
//						subFolderXML.append(" orgBoxName='1'");
//						subFolderXML.append(" fullcaption='_SENT'"); //수정
//					} else if (fd.getName().equalsIgnoreCase(egovMessageSource.getMessage("ezEmail.t646", locale))) {
//						subFolderXML.append(" orgBoxName='2'");
//						subFolderXML.append(" fullcaption='_DRAFT'"); //수정
//					} else if (fd.getName().equalsIgnoreCase(egovMessageSource.getMessage("ezEmail.t647", locale))) {
//						subFolderXML.append(" orgBoxName='3'");
//						subFolderXML.append(" fullcaption='_DELETE'"); //수정
//					} else if (fd.getName().equalsIgnoreCase(egovMessageSource.getMessage("ezEmail.t648", locale))) {
//						subFolderXML.append(" orgBoxName='4'");
//						subFolderXML.append(" fullcaption='_PERSONAL'"); //수정
//					} else if (fd.getName().equalsIgnoreCase(egovMessageSource.getMessage("ezEmail.t99000029", locale))) {
//						subFolderXML.append(" orgBoxName='5'");
//						subFolderXML.append(" fullcaption='_JUNK'"); //수정
//					} else {
//						subFolderXML.append(" orgBoxName='"+((j++)+6)+"'");
//						subFolderXML.append(" fullcaption='_NONE'"); //수정
//					}
//
//					subFolderXML.append(" href='"+fd.getFullName()+"'"); //수정
//					if (fd.list().length>0) {
//						subFolderXML.append(" hassub='1'");
//					}
//					if (bcount.equals("-1")) {
//						if (fd.getUnreadMessageCount()>0) {
//							subFolderXML.append(" style='font-weight:bold'");
//						}
//					}
//					subFolderXML.append("></node>");
//				}
//			}//end else 	
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", mailFolderList);
			
		} catch (Exception e) {
			
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
			
		} finally {
			if (ia != null) {
				ia.close();
			}
		}
		
		LOGGER.debug("MOBILE G/W MAIL [GET /ezemail/folders-list/users/{userId}] ended.");
		
		return result;
	}
	
	/**
	 * 모바일 G/W 이메일 [GET] (받은, 보낸,임시,지운,개인,기타) 편지함 리스트
	 */
	@RequestMapping(value="/mobile/ezemail/folders/{folderId}/mails/users/{userId}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public Object mMailFolderMailList(HttpServletRequest request, @PathVariable String folderId, @PathVariable String userId, 
			@RequestParam(value="start", required=true) String start,
			@RequestParam(value="end", required=true) String end,
			@RequestParam(value="search", required=false) String search,
			@RequestParam(value="filter", required=false) String filter,
			@RequestParam(value="endDate", required=false) String endDate) {
		LOGGER.debug("MOBILE G/W MAIL [GET /ezemail/folders/{folderId}/mails/users/{userId}] started.");

		JSONObject result = new JSONObject();
        IMAPAccess ia = null;
		
		try {
			folderId = URLDecoder.decode(folderId, "UTF-8");
			
			JSONArray messageJsonArray = new JSONArray();
			
			Date ed = null;
			
			boolean senderReceiverFlag = false;
			
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			String domainName = ezCommonService.getTenantConfig("DomainName", info.getTenantId());
			String userEmail = info.getUserId() + "@" + domainName;
			String password = jspw;
       
			String ld = commonUtil.getTwoLetterLangFromLangNum(info.getLang());
			Locale locale = new Locale(ld);
			
			MOptionVO opt = mOptionService.optionInfo(userId, info.getTenantId());
			if ( opt.getLang().equals("1") ) {
				locale = new Locale("ko");	
			} else if ( opt.getLang().equals("3") ) {
				locale = new Locale("ja");
			}
			
			String inboxName = egovMessageSource.getMessage("ezEmail.t644", locale);
			String sendName = egovMessageSource.getMessage("ezEmail.t645", locale);
			String tempName = egovMessageSource.getMessage("ezEmail.t646", locale);
			
	        folderId = folderId.equals(inboxName) ? "INBOX" : folderId;
	        LOGGER.debug("sendName : " + sendName + ", tempName : " + tempName);	        
//to-do     senderReceiverFlag = folderId.equals(sendName) ? true : false;
	        senderReceiverFlag = folderId.equals(sendName) || folderId.equals(tempName) ? true : false;
	        LOGGER.debug("folderId : " + folderId + ", senderReceiverFlag : " + senderReceiverFlag);
	        if (endDate == null) {
	        	endDate = "";
	        }
	        
			else if (!endDate.equals("")) {
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
//				sdf.setTimeZone(TimeZone.getTimeZone("GMT"));
//				String receivedDateStr = sdf.format(receivedDate);
				ed = sdf.parse(endDate);
			}
	        
	        folderId = URLDecoder.decode(folderId, "UTF-8");
	        
	        LOGGER.debug("userID : " + userId+ ",folderId : " + folderId + ",start : " + start 
	        		+ ",end : " + end + "search : " + search + "endDate : " + ed); 
	        
	        Message[] messages = null;
			
			LOGGER.debug("userEmail : " + userEmail + ", password : " + password);
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userEmail, password, egovMessageSource, locale);
					
			Folder folder = ia.getFolder(folderId);		
			folder.open(Folder.READ_ONLY);
	        UIDFolder uidFolder = (UIDFolder)folder;
	        
	        boolean isUnreadOnly = false;
	        boolean isImportantOnly = false;
			
	        if (filter.equals("isUnreadOnly")) {
	        	isUnreadOnly = true;
	        } 
	        
	        else if (filter.equals("isImportantOnly")) {
	        	isImportantOnly = true;
	        }
	        
			if (!search.equals("")) {
				LOGGER.debug("search field not null");

				String searchField = "SUBJECT&FROM";
				
				if (senderReceiverFlag) {
					searchField = "SUBJECT&TO";
				}
				
				final String searchValue = search;
				
				LOGGER.debug("searchField=" + searchField + ",searchValue=" + searchValue + ",endDate=" + endDate);
				
				
				if (!endDate.equals("")) {
					LOGGER.debug("search field paging");
					messages = ezEmailUtil.searchFolder(folder, searchField, searchValue, null, ed, false, null, isUnreadOnly, isImportantOnly);
				} else {
					LOGGER.debug("search field not paging");
					messages = ezEmailUtil.searchFolder(folder, searchField, searchValue, null, null, false, null, isUnreadOnly, isImportantOnly);
				}
			}
			else if (isUnreadOnly) {
				messages = ezEmailUtil.searchFolder(folder, "", "", null, ed, false, null, isUnreadOnly, false);
			}
			
			else if (isImportantOnly) {
				messages = ezEmailUtil.searchFolder(folder, "", "", null, ed, false, null, false, isImportantOnly);
			}
			
			if (messages == null && !endDate.equals("")) {
				LOGGER.debug("search field paging");
				messages = ezEmailUtil.searchFolder(folder, "", "", null, ed, false, null, isUnreadOnly, isImportantOnly);
			}
			
			if (messages == null) {
				messages = folder.getMessages(); 
			}
			
			ezEmailUtil.sortMessages(folder, messages, "receivedDate", false);
			
			int startNo = Integer.parseInt(start);
			int endNo = Math.min(Integer.parseInt(end), messages.length - 1);
			
			LOGGER.debug("isUnreadOnly=" + isUnreadOnly + "isImportantOnly" + isImportantOnly);
							
			LOGGER.debug("Message Length=" + messages.length);
			
			LOGGER.debug("startNo=" + startNo + ",endNo=" + endNo);
			
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
				messageJson.put("folderId",folderId);
				messageJson.put("messageId",uidFolder.getUID(message));
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
				
				if( filter.equals("isImportantOnly") && flagged != 1 ) {
					continue;
				}
				
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
				
				if(subject == null || subject.trim().equals("")){
					subject = egovMessageSource.getMessage("ezEmail.kms03", locale);
				}
								
				messageJson.put("subject",subject);
				
				// received date
				Date receivedDate = message.getReceivedDate();
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				sdf.setTimeZone(TimeZone.getTimeZone("GMT"));
				
				String receivedDateStr = sdf.format(receivedDate);
				
				receivedDateStr = commonUtil.getDateStringInUTC(receivedDateStr, info.getOffSet(), false);
				
				String receivedDateStr2 = receivedDateStr.substring(0,receivedDateStr.length()-3);
				
				messageJson.put("receivedt",receivedDateStr);
				messageJson.put("receivedt2",receivedDateStr2);
				
				// size
				messageJson.put("size",message.getSize());
				
				// read/unread
				int readFlag = message.isSet(Flags.Flag.SEEN) ? 1 : 0;
				messageJson.put("read",readFlag);
				
				if( filter.equals("isUnreadOnly") && readFlag == 1 ) {
					continue;
				}
				
				if (message.isSet(Flags.Flag.ANSWERED)) {
					messageJson.put("contentclass","REPLY");
				} else {
					boolean isForwarded = ezEmailUtil.hasForwardedFlag(message);
					
					if (isForwarded) {
						messageJson.put("contentclass","FORWARD");
					}
					else {
						messageJson.put("contentclass","IPM.Note");
					}
				}
				if (!endDate.equals(receivedDateStr)) {
					messageJsonArray.add(messageJson);
				}
			}
			String folderName = folder.getName();
			if ( folderName.equals("INBOX") ) {
				folderName = egovMessageSource.getMessage("ezEmail.t99000025", locale);
			}
			folder.close(false);
			
			// set importanceColor
			String importanceColor = "#ff0000";
			MailColorVO mailColor = ezEmailService.getMailColor(info.getTenantId());
			
			if (mailColor != null && mailColor.getImportanceColor() != null) {
				importanceColor = mailColor.getImportanceColor();
			}
			
			JSONObject data = new JSONObject();
			
			data.put("messageJsonArray", messageJsonArray);
			data.put("importanceColor", importanceColor);
			data.put("unreadCount", folder.getUnreadMessageCount());
			data.put("fullCount", folder.getMessageCount());
			data.put("optionCount", messages.length);
			data.put("folderName", folderName);
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", data);
//			result.put("unreadCount", folder.getUnreadMessageCount());
//			result.put("folderList", folderList);
//			result.put("folderId", folderId);
			
			//data 안에 넣어서 한번에 처리하도록 하자.
			
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
			
		} finally {
			if (ia != null) {
				ia.close();
			}
		}
		
		LOGGER.debug("MOBILE G/W MAIL [GET /ezemail/folders/{folderId}/mails/users/{userId}] ended.");		

		return result;
	}
	
	/**
	 * 모바일 G/W 이메일 [GET] 메일 쓰기에 필요한 옵션 정보 조회
	 */
	@RequestMapping(value="/mobile/ezemail/mail-write/option", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public void mMailWriteOption(HttpServletRequest request) throws Exception {
		LOGGER.debug("MOBILE G/W MAIL [GET /ezemail/mail-write/option] started.");
//		String serverName = request.getHeader("x-user-host");
//		MCommonVO info = mOptionService.commonInfo(serverName, userId);
		
//		LoginVO loginInfo = commonUtil.userInfo(loginCookie);
//		OrganUserVO userInfo = ezOrganAdminService.getUserInfo(info.getUserId(), info.getLang(), info.getTenantId());
		LOGGER.debug("MOBILE G/W MAIL [GET /ezemail/mail-write/option] ended.");		
	}
	
	/**
	 * 모바일 G/W 이메일 [GET] 쓰기
	 */
	@RequestMapping(value="/mobile/ezemail/write/users/{userId}", method= RequestMethod.POST, produces="application/json;charset=utf-8")
	public Object mMailWrite(HttpServletRequest request, @PathVariable String userId, @RequestBody JSONObject jsonObject){
		LOGGER.debug("MOBILE G/W MAIL [GET /ezemail/write/users/{userId}] started.");
		
		JSONObject result = new JSONObject();
		IMAPAccess ia = null;
		
		try{
			String from = "";
			String to = "";
			String cc = "";
			String bcc = "";
			
			//String body = "";
			String tempBody = "";
			String bodyValue = "";
			
			String subject = "";
			String url = "";
			String attach = "";
			String importance = "1";
			String isEach = "FALSE";
			String bodyType = "0";
			String replySendTime = "0";
			String replyReadTime = "1";
			String delaySendDate = "";
			String unread = "";
			String reSendFlag = "N";
			String folderPath = "";
			
			String boardID = "";
			String itemID = "";
			String docHref = "";
			String docID = "";
			String docImagCnt = "";
			String docTarget = "";
			String retransType = "";
			
			String fileUploadType = "";
			String newWindowId = "";
			
			String cmd = "";
			String folderId = "";
			String messageId = "";
			
			if (jsonObject.get("cmd") != null) {
				cmd = (String) jsonObject.get("cmd");
			}
			
			if (jsonObject.get("folderId") != null) {
				folderId = (String) jsonObject.get("folderId");
			}
			
			if (jsonObject.get("messageId") != null) {
				messageId = (String) jsonObject.get("messageId");
			}
			
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			String domainName = ezCommonService.getTenantConfig("DomainName", info.getTenantId());
			
			String userEmail = info.getUserId() + "@" + domainName;
			String password = jspw;

			int tenantID = 0;
			tenantID = info.getTenantId();
			
			String ld = commonUtil.getTwoLetterLangFromLangNum(info.getLang());
			Locale locale = new Locale(ld);
			
			MOptionVO opt = mOptionService.optionInfo(userId, info.getTenantId());
			if ( opt.getLang().equals("1") ) {
				locale = new Locale("ko");	
			} else if ( opt.getLang().equals("3") ) {
				locale = new Locale("ja");
			}
			
			String msgto = "";
			if (request.getParameter("msgto") != null) {
				msgto = request.getParameter("msgto").trim().replaceAll("&lt;", "<").replaceAll("&gt;", ">").replaceAll("&quot;", "\"");
			}

			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userEmail, password, egovMessageSource, locale);
			ia.makeTopLevelFolders();

			if (!messageId.equals("") && !folderId.equals("")){
				long uid = 0;

				folderPath = URLDecoder.decode(folderId, "UTF-8");
				
				LOGGER.debug("cmd : " + cmd +", folderId : " + folderId + ", messageId : " +  messageId);
				
				uid = Long.parseLong(messageId);
				
				LOGGER.debug("tenantID" + tenantID + "userId" + userId);
				
	    		Folder orgFolder = ia.getFolder(folderPath);
	    		orgFolder.open(Folder.READ_ONLY);       
	    		
				// retrieve the Drafts folder name
	        	String draftsFolderName = egovMessageSource.getMessage("ezEmail.t99000027", locale);
	    		
	        	// retrieve the Sent folder name
	        	String sentFolderName = egovMessageSource.getMessage("ezEmail.t99000026", locale);
	        	
	    		// retrieve the specified message.
				Message orgMessage = ((IMAPFolder)orgFolder).getMessageByUID(uid);
				
				if (orgMessage != null) {
					LOGGER.debug("orgMessage not null");
		        	// in case of editing a message in Drafts folder.
		        	if (folderPath.equals(draftsFolderName) && cmd.equals("EDIT")) {
		        		
		        		if (orgMessage.getFrom() != null && orgMessage.getFrom()[0] != null) {
		        			from = ((InternetAddress)orgMessage.getFrom()[0]).getAddress();
		        		}
		        		
						// retrieve the TO addresses from the message.
						Address[] addresses = orgMessage.getRecipients(Message.RecipientType.TO);
						to = ezEmailUtil.getStringListOfAddresses(addresses, true);
						
						// retrieve the CC addresses from the message.
						addresses = orgMessage.getRecipients(Message.RecipientType.CC);
						cc = ezEmailUtil.getStringListOfAddresses(addresses, true);
						
						// retrieve the BCC addresses from the message.
						addresses = orgMessage.getRecipients(Message.RecipientType.BCC);
						bcc = ezEmailUtil.getStringListOfAddresses(addresses, true);
						
						// retrieve the subject from the message.
						subject = ezEmailUtil.getSubject(orgMessage);
						subject = (subject != null) ? subject : "";
						
						// analyze the message and retrieve the attached file list.
						List<Map<String, String>> attachedFileList = new ArrayList<Map<String, String>>();
						List<String> bodyInfoList = ezEmailUtil.getBodyInfo(orgMessage, folderPath, uid, -1, attachedFileList, false, false, locale, null, null);					
						tempBody = bodyInfoList.get(0);
						
						if (attachedFileList.size() > 0) {
			                StringBuilder attachXmlList = new StringBuilder("<ROOT><NODES>");	
			                
							for (int i = 0; i < attachedFileList.size(); i++) {
								Map<String, String> fileInfo = attachedFileList.get(i);
								
				                attachXmlList.append("<NODE>");
				                //TODO : <PUPLOADSN>" + (i + 1) + "</PUPLOADSN> 으로 수정(인덱스로 파일 지울 때)
				                attachXmlList.append("<PUPLOADSN>" + EgovStringUtil.getSpclStrCnvr(fileInfo.get("filename")) + "</PUPLOADSN>");
				                attachXmlList.append("<RESULTUPLOADA>true</RESULTUPLOADA>");
				                attachXmlList.append("<PFILENAME>" + EgovStringUtil.getSpclStrCnvr(fileInfo.get("filename")) + "</PFILENAME>");
				                attachXmlList.append("<FILESIZE>" + fileInfo.get("size") + "</FILESIZE>");
				                attachXmlList.append("<FILELOCATION>" + uid + "</FILELOCATION>");
				                attachXmlList.append("<PBIGFILEUPLOAD>N</PBIGFILEUPLOAD>");
				                attachXmlList.append("</NODE>");
							}
							
			                attachXmlList.append("</NODES></ROOT>");						
			                attach = attachXmlList.toString();	
						}
						
		        	}
		        	// in case of resending
		        	else if (folderPath.equals(sentFolderName) && cmd.equals("RESEND") && !msgto.equals("")) {
		        		//임시보관함에 메시지 임시저장
		        		SMTPAccess sa = SMTPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.SMTPPort"),
		        				userEmail, password);
		        		MimeMessage resendMessage = sa.createMimeMessage();
		        		
		        		resendMessage.setFlag(Flags.Flag.SEEN, true);
		        		
		        		if (orgMessage.isMimeType("multipart/related")) {
			        		MimeMultipart relatedPart = new MimeMultipart("related");
			        		
			        		if (ezEmailUtil.copyInlineParts(orgMessage, relatedPart)) {
			        			resendMessage.setContent(relatedPart);
			        		}	        			
			        		else {
			        			resendMessage.setText("placeholder");
			        		}	        					        		
	        			}
	        			else if (orgMessage.isMimeType("multipart/*")) {
			                MimeMultipart mixedPart = new MimeMultipart();
			                
			                ezEmailUtil.copyAllPartsInMultipart(orgMessage, mixedPart);
			                
			                resendMessage.setContent(mixedPart);	    
	        			}
	        			else {
	        				resendMessage.setText("placeholder");
	        			}
		        		
		        		Folder draftsFolder = ia.getFolder(draftsFolderName);
		        		draftsFolder.open(Folder.READ_WRITE);       
		        		long draftUID = 0;
		        		AppendUID[] uids = ((IMAPFolder)draftsFolder).appendUIDMessages(new Message[]{resendMessage});
		        		if (uids != null && uids[0] != null) {
		        			draftUID = uids[0].uid;
		        		} 	        		
		        		url = String.valueOf(draftUID);
		        		LOGGER.debug("draftUID=" + draftUID);
		        		draftsFolder.close(true);
		        		//END: 임시보관함에 메시지 임시저장
		        		
		        		reSendFlag = "Y";
		        		
		        		Address[] addresses = orgMessage.getAllRecipients();
		        		for (Address address : addresses) {
		        			if (((InternetAddress)address).getAddress().equalsIgnoreCase(msgto)) {
								to = ezEmailUtil.getStringListOfAddresses(new Address[]{address}, true);
								break;
		        			}
		        		}
		        		
		        		subject = orgMessage.getSubject();
						subject = (subject != null) ? subject : "";
		        		
						List<Map<String, String>> attachedFileList = new ArrayList<Map<String, String>>();		            
						List<String> bodyInfoList = ezEmailUtil.getBodyInfo(orgMessage, folderPath, uid, -1, attachedFileList, false, false, locale, null, null);					
						bodyValue = bodyInfoList.get(0);
		        		
		        		if (attachedFileList.size() > 0) {
			                StringBuilder attachXmlList = new StringBuilder("<ROOT><NODES>");	
			                
							for (int i = 0; i < attachedFileList.size(); i++) {
								Map<String, String> fileInfo = attachedFileList.get(i);
								
				                attachXmlList.append("<NODE>");
				                //TODO : <PUPLOADSN>" + (i + 1) + "</PUPLOADSN> 으로 수정(인덱스로 파일 지울 때)
				                attachXmlList.append("<PUPLOADSN>" + EgovStringUtil.getSpclStrCnvr(fileInfo.get("filename")) + "</PUPLOADSN>");
				                attachXmlList.append("<RESULTUPLOADA>true</RESULTUPLOADA>");
				                attachXmlList.append("<PFILENAME>" + EgovStringUtil.getSpclStrCnvr(fileInfo.get("filename")) + "</PFILENAME>");
				                attachXmlList.append("<FILESIZE>" + fileInfo.get("size") + "</FILESIZE>");
				                attachXmlList.append("<FILELOCATION>" + uid + "</FILELOCATION>");
				                attachXmlList.append("<PBIGFILEUPLOAD>N</PBIGFILEUPLOAD>");
				                attachXmlList.append("</NODE>");
							}
							
			                attachXmlList.append("</NODES></ROOT>");						
			                attach = attachXmlList.toString();				                
						}
		        		
		                unread = orgMessage.isSet(Flags.Flag.SEEN) ? "1" : "0";
		                
		                //TODO: Sensitivity?
		                //this._posttype = ((int)orgmesg.Sensitivity).ToString();
		        		
		        	}
		        	// in case of replying
		        	else if (cmd.equals("REPLY") || cmd.equals("REPLYALL") || cmd.equals("FORWARD")) {
		        		Message replyMessage = null; 
		        		
		        		// reply call is needed to create 'References' & 'In-Reply-To' headers.
		        		if (cmd.equals("REPLY") || cmd.equals("FORWARD")) {
		        			replyMessage = orgMessage.reply(false);
		        		}
		        		else {
		        			replyMessage = orgMessage.reply(true);
		        		}
		        		
		        		// ANSWERED flag needs to be cleared since the above reply method sets it.
		        		orgMessage.setFlag(Flags.Flag.ANSWERED, false);
		        		
		        		replyMessage.setFlag(Flags.Flag.SEEN, true);
	
		        		if (cmd.equals("FORWARD")) {
		        			if (orgMessage.isMimeType("multipart/related")) {
				        		MimeMultipart relatedPart = new MimeMultipart("related");
				        		
				        		if (ezEmailUtil.copyInlineParts(orgMessage, relatedPart)) {
				        			replyMessage.setContent(relatedPart);
				        		}	        			
				        		else {
				        			replyMessage.setText("placeholder");
				        		}	        					        		
		        			}
		        			else if (orgMessage.isMimeType("multipart/*")) {
				                MimeMultipart mixedPart = new MimeMultipart();
				                
				                ezEmailUtil.copyAllPartsInMultipart(orgMessage, mixedPart);
				                
				                replyMessage.setContent(mixedPart);	    
		        			}
		        			else {
		        				replyMessage.setText("placeholder");
		        			}
		        		}
		        		else {
			        		MimeMultipart relatedPart = new MimeMultipart("related");
			        		
			        		if (ezEmailUtil.copyInlineParts(orgMessage, relatedPart)) {
			        			replyMessage.setContent(relatedPart);
			        		}
			        		else {
			        			replyMessage.setText("placeholder");
			        		}	        		
		        		}
	
		        		Address[] addresses = null;
		        		if (cmd.equals("REPLY") || cmd.equals("REPLYALL")) {
							// retrieve the TO addresses from the reply message.
							addresses = replyMessage.getRecipients(Message.RecipientType.TO);
							String[] rawHeaders = orgMessage.getHeader("From");
							String rawHeader = rawHeaders != null ? rawHeaders[0] : "";		
							boolean isPureAscii = ezEmailUtil.isPureAscii(rawHeader);
							if (isPureAscii) {
								rawHeaders = orgMessage.getHeader("To");
								rawHeader = rawHeaders != null ? rawHeaders[0] : "";
								isPureAscii = ezEmailUtil.isPureAscii(rawHeader);
							}
							to = ezEmailUtil.getStringListOfAddresses(addresses, isPureAscii);
	
							// retrieve the CC addresses from the reply message.
							addresses = replyMessage.getRecipients(Message.RecipientType.CC);
							if (addresses != null) {
								rawHeaders = orgMessage.getHeader("Cc");
								rawHeader = rawHeaders != null ? rawHeaders[0] : "";																					
								cc = ezEmailUtil.getStringListOfAddresses(addresses, ezEmailUtil.isPureAscii(rawHeader));
							}
							
							// retrieve the BCC addresses from the reply message.
							addresses = replyMessage.getRecipients(Message.RecipientType.BCC);
							bcc = ezEmailUtil.getStringListOfAddresses(addresses, true);
		        		}
						
						// retrieve the subject from the message.
						subject = ezEmailUtil.getSubject(orgMessage);
						
						if (subject != null && !subject.equals("")) {
							String[] rawHeaders = orgMessage.getHeader("subject");
							String rawHeader = rawHeaders[0];
							
							// if the subject contains Non-Ascii characters(violating the standard), 
							// try to decode it by examining the characters.							
							if (!ezEmailUtil.isPureAscii(rawHeader)) {
								byte[] rawBytes = rawHeader.getBytes("iso-8859-1");
								
								subject = ezEmailUtil.decodeNonAsciiBytes(rawBytes);
							}
						}
						
						subject = (subject != null) ? subject : "";
						String reStr = ""; 
								
						if (cmd.equals("REPLY") || cmd.equals("REPLYALL")) {		
							reStr = egovMessageSource.getMessage("ezEmail.t511", locale);
						}
						else if (cmd.equals("FORWARD")) {
							reStr = egovMessageSource.getMessage("ezEmail.t513", locale);
						}
						
						if (!subject.startsWith(reStr)) {
							subject = reStr + ": " + subject;
						}
		        		
						// retrieve the TO addresses from the original message.
						addresses = orgMessage.getRecipients(Message.RecipientType.TO);
						String[] rawHeaders = orgMessage.getHeader("To");
						String rawHeader = rawHeaders != null ? rawHeaders[0] : "";													
						String orgTo = ezEmailUtil.getStringListOfAddresses(addresses, ezEmailUtil.isPureAscii(rawHeader));
						
						// retrieve the CC addresses from the original message.
						addresses = orgMessage.getRecipients(Message.RecipientType.CC);
						rawHeaders = orgMessage.getHeader("Cc");
						rawHeader = rawHeaders != null ? rawHeaders[0] : "";																			
						String orgCc = ezEmailUtil.getStringListOfAddresses(addresses, ezEmailUtil.isPureAscii(rawHeader));
						
			            StringBuilder sb = new StringBuilder();
			            sb.append("<hr tabindex=\"-1\">");
			            sb.append(String.format("<B>%s : </B> %s<BR>", egovMessageSource.getMessage("ezEmail.t703", locale), EgovStringUtil.getSpclStrCnvr(ezEmailUtil.getFullFromAddressOfMessage(orgMessage))));
			            
			            //set received date
			            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss ( z )");
			            String offset = info.getOffSet();
			            if (offset == null || offset.indexOf("|") == -1) {
			    			LOGGER.error("Check the offset. Offset is null or offset format is wrong.");
			    		} else {
			    			String[] offsetArr = offset.split("\\|");
			    			sdf.setTimeZone(TimeZone.getTimeZone("GMT" + offsetArr[1]));
			    		}
			            sb.append(String.format("<B>%s : </B> %s<BR>", egovMessageSource.getMessage("ezEmail.t704", locale), sdf.format(orgMessage.getReceivedDate()).replace("GMT", "")));
			            
			            sb.append(String.format("<B>%s : </B> %s<BR>", egovMessageSource.getMessage("ezEmail.t705", locale), EgovStringUtil.getSpclStrCnvr(orgTo)));
			            sb.append(String.format("<B>%s : </B> %s<BR>", egovMessageSource.getMessage("ezEmail.t706", locale), EgovStringUtil.getSpclStrCnvr(orgCc)));
			            
			            String orgMessageSubject = ezEmailUtil.getSubject(orgMessage);	
						if (orgMessageSubject != null && !orgMessageSubject.equals("")) {
							rawHeaders = orgMessage.getHeader("subject");
							rawHeader = rawHeaders[0];
							
							// if the subject contains Non-Ascii characters(violating the standard), 
							// try to decode it by examining the characters.							
							if (!ezEmailUtil.isPureAscii(rawHeader)) {
								byte[] rawBytes = rawHeader.getBytes("iso-8859-1");
								
								orgMessageSubject = ezEmailUtil.decodeNonAsciiBytes(rawBytes);
							}
						}			            
			            sb.append(String.format("<B>%s : </B> %s<BR><BR>", egovMessageSource.getMessage("ezEmail.t707", locale), EgovStringUtil.getSpclStrCnvr(orgMessageSubject)));
						
						// analyze the message and retrieve the attached file list.
						List<Map<String, String>> attachedFileList = new ArrayList<Map<String, String>>();		            
						List<String> bodyInfoList = ezEmailUtil.getBodyInfo(orgMessage, folderPath, uid, -1, attachedFileList, false, false, locale, null, null);					
						String tmphtmlbody = bodyInfoList.get(0);
			            
			            bodyValue = sb.toString() + tmphtmlbody;
			            
			            // 원본 메일 내용에 메일 서명 존재 시 변환 처리
		                if (bodyValue.contains("id=\"MailSignSent\"") || bodyValue.contains("id=MailSignSent")) {
		                	bodyValue = bodyValue.replaceAll("MailSignSent", "MailSignSent___send");
		                	bodyValue = bodyValue.replaceAll("kaoni_sign1", "kaoni_sign1___send");
		                	bodyValue = bodyValue.replaceAll("kaoni_sign2", "kaoni_sign2___send");
		                	bodyValue = bodyValue.replaceAll("kaoni_sign3", "kaoni_sign3___send");
		                }
		                bodyValue = bodyValue.replaceAll("ORGMAIL_CONTENT", "ORGMAIL_CONTENT___send");
		                bodyValue = bodyValue.replaceAll("div id=\"MailSign\"", "div ");
		                
		                bodyValue = bodyValue.replaceAll("id=msgbody", "");
	
		                if (cmd.equals("REPLY") || cmd.equals("REPLYALL") || cmd.equals("FORWARD")) {
		                	bodyValue = bodyValue.replaceAll("class=&quot;FIELD&quot;", "");
		                	bodyValue = bodyValue.replaceAll("class=FIELD", "");
		                	bodyValue = "<body free>" + bodyValue + "</body>";
		                }
		                
		                //임시보관함에 저장
		        		Folder draftsFolder = ia.getFolder(draftsFolderName);
		        		draftsFolder.open(Folder.READ_WRITE);       
		        		
		        		long draftUID = 0;
		        		AppendUID[] uids = ((IMAPFolder)draftsFolder).appendUIDMessages(new Message[]{replyMessage});
		        		if (uids != null && uids[0] != null) {
		        			draftUID = uids[0].uid;
		        		} 	        		
		        		url = String.valueOf(draftUID);
		        		
		        		LOGGER.debug("draftUID=" + draftUID);
		        		
		        		draftsFolder.close(true);
		                
		        		//첨부파일 정보 추출
		        		if (cmd.equals("FORWARD")) {
							if (attachedFileList.size() > 0) {
				                StringBuilder attachXmlList = new StringBuilder("<ROOT><NODES>");	
				                
								for (int i = 0; i < attachedFileList.size(); i++) {
									Map<String, String> fileInfo = attachedFileList.get(i);
									
					                attachXmlList.append("<NODE>");
					                //TODO : <PUPLOADSN>" + (i + 1) + "</PUPLOADSN> 으로 수정(인덱스로 파일 지울 때)
					                attachXmlList.append("<PUPLOADSN>" + EgovStringUtil.getSpclStrCnvr(fileInfo.get("filename")) + "</PUPLOADSN>");
					                attachXmlList.append("<RESULTUPLOADA>true</RESULTUPLOADA>");
					                attachXmlList.append("<PFILENAME>" + EgovStringUtil.getSpclStrCnvr(fileInfo.get("filename")) + "</PFILENAME>");
					                attachXmlList.append("<FILESIZE>" + fileInfo.get("size") + "</FILESIZE>");
					                attachXmlList.append("<FILELOCATION>" + uid + "</FILELOCATION>");
					                attachXmlList.append("<PBIGFILEUPLOAD>N</PBIGFILEUPLOAD>");
					                attachXmlList.append("</NODE>");
								}
								
				                attachXmlList.append("</NODES></ROOT>");						
				                attach = attachXmlList.toString();				                
							}											            	
			            }
		        		
		        	}
		        	
		        	//set importance
		        	if(cmd.equals("EDIT")) {
		        		LOGGER.debug("EDIT MODE : set mail option start");
		        		if (orgMessage.getHeader("X-Priority") != null) {
		        			String tempImportance = orgMessage.getHeader("X-Priority")[0];
		        			if (tempImportance.equals("1")) {
		        				importance = "2";
		        			} else if (tempImportance.equals("5")) {
		        				importance = "0";
		        			} else {
		        				importance = "1";
		        			}
		        		}
		        		LOGGER.debug("importance=" + importance);
		        	
		        		//set isEachMail
		        		if (orgMessage.getHeader("X-JMocha-Each-Mail") != null) {
		        			isEach = orgMessage.getHeader("X-JMocha-Each-Mail")[0];
		        		}
		        		//set bodyType
		        		if (orgMessage.getHeader("Content-Type") != null) {
		        			String tempBodyType = orgMessage.getHeader("Content-Type")[0];
		        			
		        			if(tempBodyType.split(";")[0].trim().equals("text/plain")) {
		        				bodyType = "1";
		        			}else if ( tempBodyType.split(";")[0].trim().equals("multipart/alternative")) {
		        				bodyType = "0";
		        			}
		        		}
		        		if (orgMessage.getHeader("Return-Receipt-To") != null) {
		        			replySendTime = "1";
		        		} else {
		        			replySendTime = "0";
		        		}
		        		if (orgMessage.getHeader("Disposition-Notification-To") != null) {
		        			replyReadTime = "1";
		        		} else {
		        			replyReadTime = "0";
		        		}
		        	
		        		if (orgMessage.getHeader("Delivery-Date") != null) {
		        			delaySendDate = orgMessage.getHeader("Delivery-Date")[0].trim();
		        		} else {
		        			delaySendDate = "";
		        		}
		        		
		        		LOGGER.debug("EDIT MODE : set mail option end");
		        	}
				}
				orgFolder.close(true);
			}
			
			String useFromAddress = ezCommonService.getTenantConfig("Use_FromAddress", info.getTenantId());
			String fromAddressHtml = "";
			
			if (useFromAddress != null) {
				if (useFromAddress.equals("YES")) {
					List<String[]> fromAddressList = ezEmailService.getAliasAddress(info.getUserId(), info.getTenantId());
					
					if (fromAddressList.size() < 2) {
						useFromAddress = "NO";
					} else {
						StringBuilder sb = new StringBuilder();
						sb.append("<select id='ex_select' onchange='fromAddressChange(this.value)'>");
						
						boolean isValidFrom = false;
						
						for (String[] address : fromAddressList) {
							if (from.equals(address[0])) {
								isValidFrom = true;
								break;
							}
						}
						
						if (!isValidFrom) {
							from = userEmail;
						}
						
						for (String[] address : fromAddressList) {
							if (from.equals(address[0])) {
								sb.append("<option value='" + address[0] + "' selected>" + address[0] + "</option>");
							} else {
								sb.append("<option value='" + address[0] + "'>" + address[0] + "</option>");
							}
						}
						
						sb.append("</select>");
						sb.append("<label for='ex_select'>" + from + "</label>");
						
						fromAddressHtml = sb.toString();
					}
				}
			} else {
				useFromAddress = "NO";
			}
			
	        String browser = ClientUtil.getClientInfo(request, "browser");
			boolean isCrossBrowser = browser.equals("IE9") ? false : true;
			
			
			JSONObject data = new JSONObject();
	        data.put("userEmail",userEmail);
			data.put("to", to);
			data.put("cc", cc);
			data.put("bcc", bcc);
			data.put("subject", subject);
			data.put("encodedSubject", EgovStringUtil.getSpclStrCnvr(subject));
			data.put("url", url);
			data.put("attach", attach);
			data.put("folderPath", folderPath);
			data.put("importance", importance);
			data.put("isEach", isEach);
			data.put("bodyType", bodyType);
			data.put("replySendTime", replySendTime);
			data.put("replyReadTime", replyReadTime);
			data.put("delaySendDate", delaySendDate);
			data.put("unread", unread);
			data.put("bodyValue", bodyValue);
			data.put("fileUploadType", fileUploadType);
			data.put("tempBody", tempBody);
			data.put("newWindowId", newWindowId);
			data.put("serverName", serverName);
			data.put("isCrossBrowser", isCrossBrowser);
			data.put("useFromAddress", useFromAddress);
			data.put("fromAddressHtml", fromAddressHtml);
			
	        result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", data);
			
		} catch (Exception e) {
			if (e.getMessage().indexOf("NO APPEND failed.") > -1) {
//				model.addAttribute("overQuota", true);
				e.printStackTrace();
				result.put("status", "error");
				result.put("code", 1);			
				result.put("data", "");
			}
			e.printStackTrace();
		} finally {
			if (ia != null) {
				ia.close();        	
			}
		}

		LOGGER.debug("MOBILE G/W MAIL [GET /ezemail/write/users/{userId}] ended.");	
		
		return result;
	}
	
	/**
	 * 모바일 G/W 이메일 [POST] 첨부파일 업로드
	 */
	@RequestMapping(value="/mobile/ezemail/mails/attachs/users/{userId}", method= RequestMethod.POST, produces="application/json;charset=utf-8")
	public Object mMailFileUpload(HttpServletRequest request, @PathVariable String userId, @RequestBody JSONObject jsonObject) throws Exception {
		LOGGER.debug("MOBILE G/W MAIL [POST /mobile/ezemail/mails/attachs/users/{userId}] started.");

//		LOGGER.debug("####" + jsonObject.toJSONString() +"####");
		
		JSONParser jp = new JSONParser();
		jsonObject = (JSONObject) jp.parse(jsonObject.toJSONString());
		
		JSONObject result = new JSONObject();
		
		try {
			String tempFolderName = "";
			JSONArray fileArray = new JSONArray();
			int cnt = 0;
			int maxsize = 0;
			
			if (jsonObject.get("tempFolderName") != null) {
				tempFolderName = (String) jsonObject.get("tempFolderName");
			}
			
			if (jsonObject.get("fileArray") != null) {
				fileArray = (JSONArray) jsonObject.get("fileArray");
			}
			
			if (jsonObject.get("cnt") != null) {
				cnt =  ((Long) jsonObject.get("cnt")).intValue();
			}
			
			if (jsonObject.get("maxsize") != null) {
				maxsize =  ((Long) jsonObject.get("maxsize")).intValue();
			}
		
			LOGGER.debug("####" + tempFolderName +"####");
//			LOGGER.debug("####" + fileArray.toJSONString() +"####");
			LOGGER.debug("####" + cnt +"####");
			LOGGER.debug("####" + maxsize +"####");
			
			String serverName = request.getHeader("x-user-host");
			
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			String domainName = ezCommonService.getTenantConfig("DomainName", info.getTenantId());
			String userEmail = info.getUserId() + "@" + domainName;
			String password = jspw;
			
			String ld = commonUtil.getTwoLetterLangFromLangNum(info.getLang());
			Locale locale = new Locale(ld);
			String strXML = "";
			String strXML2 = "";
	//		String folderDate = "";
	//		String tempFolderName = "";
			String xmlList = "";
	//		String isBigYN = "N";
	//		List<MultipartFile> multiFile = request.getFiles("fileToUpload");
	//		int cnt = 0;
	//		if (request.getParameter("cnt") != null && !request.getParameter("cnt").equals("")) {
	//			cnt = Integer.parseInt(request.getParameter("cnt"));
	//		}
			String realPath = commonUtil.getRealPath(request);
			String[] pFileName = new String[cnt];
			Long[] fileSize = new Long[cnt];
			String[] fileLocation = new String[cnt];
			String[] resultUpload = new String[cnt];
			String[] sGUID = new String[cnt];
	//		String pBigFileUpload = "";
			String[] sFileTitle = new String[cnt];
			String[] sExt = new String[cnt];
			String pDirTempPath = "";
	//		long bigMaxSize = 0;
	//		long changeSize = 0;
	//
	//		if (request.getParameter("STATUS") != null && !request.getParameter("STATUS").equals("")) {
	//			tempFolderName = request.getParameter("STATUS");
	//		} else {
	//			return "NODATA";
	//		}
	//		
	//		if (multiFile == null) {
	//			return "NODATA";
	//		}
	//		
	//		if (request.getParameter("isbigyn") != null) {
	//			isBigYN = request.getParameter("isbigyn");
	//		}
	//		
	//		LoginVO userInfo = commonUtil.userInfo(loginCookie);
	//		
			String useExtension = ezCommonService.getTenantConfig("USE_FileExtension", info.getTenantId());
	//		
			if (useExtension == null) {
				useExtension = "";
			}
			//		
			if (((JSONObject)fileArray.get(0)).get("originalFilename") != null && StringUtils.isNotBlank((String) ((JSONObject)fileArray.get(0)).get("originalFilename"))){
				boolean isEmpty = false;
				String _pFileName = "";
				for (int i=0; i<cnt; i++) {
					_pFileName = (String) ((JSONObject)fileArray.get(i)).get("originalFilename");
					if (_pFileName.indexOf(commonUtil.separator) > 0) {
						_pFileName = _pFileName.split(commonUtil.separator)[_pFileName.split(commonUtil.separator).length - 1];
					}
					pFileName[i] = _pFileName;
					if (pFileName[i].lastIndexOf(".") > -1) {
						sFileTitle[i] = pFileName[i].substring(0, pFileName[i].lastIndexOf("."));
						sExt[i] = pFileName[i].substring(pFileName[i].lastIndexOf(".") + 1);
					} else {
						sFileTitle[i] = pFileName[i];
						sExt[i] = "";
					}
					
					if ( ((Long)((JSONObject)fileArray.get(i)).get("fileSize")).intValue() == 0) {
						isEmpty = true;
					}
				}
				if (isEmpty) {
					return "OVERFLOW";
				}
			}
//
			for (int i=0; i<cnt; i++) {
				sGUID[i] = UUID.randomUUID().toString() + "." + sExt[i];
			}
	//
	//		if (request.getParameter("bigmaxsize") != null) {
	//			bigMaxSize = Long.parseLong(request.getParameter("bigmaxsize"));
	//		}
	//		if (request.getParameter("changesize") != null) {
	//			changeSize = Long.parseLong(request.getParameter("changesize"));
	//		}
	//
			strXML = "<ROOT><NODES>";
			String pDirPath = commonUtil.getUploadPath("upload_mail.ROOT", info.getTenantId());
			pDirPath = realPath + pDirPath;
	//		
	//		// check the upload mail root folder and create it if it isn't exist.
			File uploadMailRootFolder = new File(pDirPath);
			if (!uploadMailRootFolder.exists()) {
				LOGGER.debug("creating uploadMailRootFolder=" + uploadMailRootFolder);
				uploadMailRootFolder.mkdirs();
			}

			for (int i=0; i<cnt; i++) {
				fileSize[i] = (Long) ((JSONObject)fileArray.get(i)).get("fileSize");
	            pDirTempPath = pDirPath + commonUtil.separator + "tempFileUpload";
				
				File f = new File(pDirTempPath);
				if (!f.exists()) {
					f.mkdirs();
	            }
	
				if (fileSize[i] > maxsize && maxsize != 0) {
	                resultUpload[i] = "overflow";
	            } else {
	                if (useExtension.toLowerCase().indexOf(sExt[i].toLowerCase()) == -1 && !useExtension.equals("*")) {
	                    resultUpload[i] = "denied";
	                } else {
	                    mobileMailWriteUploadedFile((String)((JSONObject)fileArray.get(i)).get("bytes"), sGUID[i], pDirTempPath);
	                    fileLocation[i] = pDirTempPath + commonUtil.separator + sGUID[i];
	                    resultUpload[i] = "true";
	                }
	                String pBigFileUpload = "N";
	                strXML2 += "<NODE><PUPLOADSN><![CDATA[" + sGUID[i] + "]]></PUPLOADSN>";
	                strXML2 += "<RESULTUPLOADA><![CDATA[" + resultUpload[i] + "]]></RESULTUPLOADA>";
	                strXML2 += "<PFILENAME><![CDATA[" + pFileName[i] + "]]></PFILENAME>";
	                strXML2 += "<FILESIZE><![CDATA[" + fileSize[i] + "]]></FILESIZE>";
	                strXML2 += "<FILELOCATION><![CDATA[" + sGUID[i] + "]]></FILELOCATION>";
	                strXML2 += "<PBIGFILEUPLOAD><![CDATA[" + pBigFileUpload + "]]></PBIGFILEUPLOAD>";
	                strXML2 += "</NODE>";
	            }
	            pDirTempPath = "";
			}
			strXML += strXML2 + "</NODES></ROOT>";

			String xmlPath = pDirPath + commonUtil.separator + "templist";
	        File f = new File(xmlPath);
	        if (!f.exists()) {
				f.mkdirs();
	        }

	        xmlPath += commonUtil.separator + tempFolderName + ".txt";
	        LOGGER.debug("###" + xmlPath + "###");
	        f = new File(xmlPath);
	        if (f.exists()) {
	        	String tempXmlList = "";
	        	InputStreamReader isr = null;
	        	BufferedReader br = null;
	        	OutputStreamWriter osw = null;
	        	try {
		        	isr = new InputStreamReader(new FileInputStream(f));
		        	br = new BufferedReader(isr);
		        	int read = 0;
					while ((read = br.read()) != -1) {
						tempXmlList += (char)read;
					}
					Document xmldom = commonUtil.convertStringToDocument(tempXmlList);
					Document xmldom2 = commonUtil.convertStringToDocument(strXML);
	
		            NodeList nodeList = xmldom.getElementsByTagName("NODES");
		            NodeList nodeList2 = xmldom2.getElementsByTagName("NODE");
		            for (int i=0; i<nodeList2.getLength(); i++) {
		            	nodeList.item(0).appendChild(xmldom.importNode(nodeList2.item(i), true));
		            }
	            	osw = new OutputStreamWriter(new FileOutputStream(f));
	            	osw.write(commonUtil.convertDocumentToString(xmldom));
	            	String crlf = System.getProperty("line.separator");
	        		osw.append(crlf+crlf);
		            
		            xmlList = strXML;
		            
	        	} catch(Exception e) {
	        		result.put("status", "error");
	    			result.put("code", 1);			
	    			result.put("data", "");	
	        	} finally {
	        		if (br != null) {
	        			br.close();
	        		}
	        		if (isr != null) {
	        			isr.close();
	        		}
	        		if (osw != null) {
	        			osw.close();
	        		}
	        	}
	        	
	        } else {
	        	OutputStreamWriter osw = null;
	        	try {
	        		osw = new OutputStreamWriter(new FileOutputStream(f));
	        		osw.write(strXML);
	        		String crlf = System.getProperty("line.separator");
	        		osw.append(crlf+crlf);
	        		xmlList = strXML;
	        		
	        	} catch(Exception e) {
	        		e.printStackTrace();
	        	} finally {
	        		if (osw != null) {
	        			osw.close();
	        		}
	        	}
	        }
				result.put("status", "ok");
				result.put("code", 0);			
				result.put("data", xmlList);
			} catch (Exception e) {
				e.printStackTrace();
				result.put("status", "error");
				result.put("code", 1);			
				result.put("data", "");	
			}
		LOGGER.debug("MOBILE G/W MAIL [POST /mobile/ezemail/mails/attachs/users/{userId}] ended.");
			
		return result;
	}
	
	
//	/**
//	 * 임시저장메일 삭제 실행 함수
//	 */
//	
//	@RequestMapping(value="/mobile/ezemail/mails/delDraft/users/{userId}", method= RequestMethod.POST, produces="application/json;charset=utf-8")
//	public Object delDrafts(HttpServletRequest request, @PathVariable String userId, @RequestBody JSONObject jsonObject) throws Exception {
//		
//		LOGGER.debug("delDrafts started.");
//		
//		try {
//		
//			String uidStr = "";
//			String delid = "";
//			
//			if (jsonObject.get("uidStr") != null) {
//				uidStr = (String) jsonObject.get("uidStr");
//			}
//			
//			if (jsonObject.get("delid") != null) {
//				delid = (String) jsonObject.get("delid");
//			}
//			
//			String serverName = request.getHeader("x-user-host");
//			
//			MCommonVO info = mOptionService.commonInfo(serverName, userId);
//			String domainName = ezCommonService.getTenantConfig("DomainName", info.getTenantId());
//			String userEmail = info.getUserId() + "@" + domainName;
//			String password = jspw;
//			
//			String ld = commonUtil.getTwoLetterLangFromLangNum(info.getLang());
//			Locale locale = new Locale(ld);
//			
//			LOGGER.debug("uidStr=" + uidStr);
//			
//			long uid = 0;
//			if (uidStr != null && !uidStr.equals("")) {
//				uid = Long.parseLong(uidStr);
//			}
//			
//			if (uid != 0) {
//	    		
//	    		IMAPAccess ia = null;
//	    		try {
//	    			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
//	    					userEmail, password, egovMessageSource, locale);
//	    			
//	    			Folder folder = ia.getFolder(egovMessageSource.getMessage("ezEmail.t99000027", locale));
//	    			folder.open(Folder.READ_WRITE);
//	    			Message message = ((IMAPFolder)folder).getMessageByUID(uid);
//	    			LOGGER.debug("message=" + message);
//	    			
//	    			if (message != null) {
//	    				message.setFlag(Flags.Flag.DELETED, true);
//	    			}
//	    	        folder.close(true);
//	    	        
//	    		} catch (MessagingException e) {
//	    			e.printStackTrace();
//	    		} finally {
//	    			if (ia != null) {
//	    				ia.close();
//	    			}
//	    		}
//			}
//			
//			//첨부파일 정보파일(templist) 삭제
//			String delId = delid;
//	        String realPath = commonUtil.getRealPath(request);
//	        String pDirPath = realPath + commonUtil.getUploadPath("upload_mail.ROOT", info.getTenantId()) + commonUtil.separator + "templist";
//	        pDirPath += commonUtil.separator + delId + ".txt";
//	        File f = new File(pDirPath);
//	        if (f.exists()) {
//	        	f.delete();
//	        }
//		} catch (Exception e) {
//			
//		}
//        LOGGER.debug("delDrafts ended.");
//        
//		return "";
//	}
	
	@RequestMapping(value="/mobile/ezemail/mails/attachsmail/users/{userId}", method= RequestMethod.POST, produces="application/json;charset=utf-8")
	@ResponseBody
	public Object mailInterAttach(HttpServletRequest request, @PathVariable String userId, @RequestBody JSONObject jsonObject) throws Exception {
		LOGGER.debug("MOBILE G/W MAIL [POST /mobile/ezemail/mails/attachs/users/{userId}] started.");
		
		String returnValue = "";
		String cmd = "";
	    
		JSONObject result = new JSONObject();
		
		try {
		
			String xmldomString = "";
			String realPath = commonUtil.getRealPath(request);
			
			if (jsonObject.get("xmldom") != null) {
				xmldomString = (String) jsonObject.get("xmldom");
			}
			
			String serverName = request.getHeader("x-user-host");
			
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			String domainName = ezCommonService.getTenantConfig("DomainName", info.getTenantId());
			String userEmail = info.getUserId() + "@" + domainName;
			String password = jspw;
			
			String ld = commonUtil.getTwoLetterLangFromLangNum(info.getLang());
			Locale locale = new Locale(ld);	
			
			MOptionVO opt = mOptionService.optionInfo(userId, info.getTenantId());
			if ( opt.getLang().equals("1") ) {
				locale = new Locale("ko");	
			} else if ( opt.getLang().equals("3") ) {
				locale = new Locale("ja");
			}
			
			Document xmldom = commonUtil.convertStringToDocument(xmldomString);
			cmd = xmldom.getElementsByTagName("CMD").item(0).getTextContent();
			String uidStr = xmldom.getElementsByTagName("URL").item(0).getTextContent();
			
			NodeList bigs = xmldom.getElementsByTagName("BIG");
			boolean hasAttachFile = false;
			
			if (bigs != null) {
				for (int i=0; i < bigs.getLength(); i++) {
					if (bigs.item(i).getTextContent().equals("N")) {
					    // 일반첨부파일이 있는 경우
						hasAttachFile = true;
						break;
					}
				}
			}
			
			long uid = 0;
			if (uidStr != null && !uidStr.equals("")) {
				uid = Long.parseLong(uidStr);
			}
			
//			String realPath = commonUtil.getRealPath(request);
			String pDirPath = commonUtil.getUploadPath("upload_mail.ROOT", info.getTenantId());
			pDirPath = realPath + pDirPath;
			String pDirTempPath = realPath + commonUtil.getUploadPath("upload_mail.ROOT", info.getTenantId()) + commonUtil.separator + "tempFileUpload";
			
			MimeMessage newMessage = null;
			IMAPAccess ia = null;
			Folder folder = null;
			Multipart multipart = null;
			
			try {
				
				if (hasAttachFile) {
					SMTPAccess sa = SMTPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.SMTPPort"),
							userEmail, password);
					
					// 첨부파일들을 추가하여 임시 보관함에 저장할 메시지를 생성한다.
					newMessage = sa.createMimeMessage();
					
					ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
							userEmail, password, egovMessageSource, locale);
					
					// 임시 보관함 폴더 오픈 
					folder = ia.getFolder(egovMessageSource.getMessage("ezEmail.t99000027", locale));
					folder.open(Folder.READ_WRITE);
					
					// 첨부파일 Part들을 삽입할 Multipart를 생성한다.
					multipart = new MimeMultipart();
				}
				
				if (cmd.equals("ADD")) {
					NodeList fileNodes = xmldom.getElementsByTagName("FILE");
					
					// 임시 보관함에 이미 기존 메시지가 있는 경우, 해당 메시지의 파트들을 새 메시지에 병합한다.
					if (hasAttachFile && uid != 0) {
					    // 임시 보관함에 있는 메시지를 가져온다.
						Message oldMessage = ((IMAPFolder)folder).getMessageByUID(uid);
						
						if (oldMessage != null) {
						    // 기존 메시지가 Multipart인 경우 처리
							if (oldMessage.getContent() instanceof Multipart) {
								Multipart mp = (Multipart)oldMessage.getContent();
								int count = mp.getCount();
								BodyPart p = null;
								
								// 임시 보관함에 있는 메시지가 multipart/related일 때는 새롭게 related 파트로 구성한 다음
								// 새 메시지의 서브 파트로 추가한다.
								if (oldMessage.isMimeType("multipart/related")) {
									LOGGER.debug("oldMessage is multipart/related");
								    
									Multipart relatedPart = new MimeMultipart("related");
									
									for (int i = 0; i < count; i++) {
										p = mp.getBodyPart(i);
										relatedPart.addBodyPart(p);
									}
									
									MimeBodyPart wrap = new MimeBodyPart();
									wrap.setContent(relatedPart);
									multipart.addBodyPart(wrap, 0);
								} else if (oldMessage.isMimeType("multipart/alternative")) {
									LOGGER.debug("oldMessage is multipart/alternative");
								    
		                            Multipart alternativePart = new MimeMultipart("alternative");
		                            
		                            for (int i = 0; i < count; i++) {
		                                p = mp.getBodyPart(i);
		                                alternativePart.addBodyPart(p);
		                            }
		                            
		                            MimeBodyPart wrap = new MimeBodyPart();
		                            wrap.setContent(alternativePart);
		                            multipart.addBodyPart(wrap, 0);							    
								} else {
									for (int i = 0; i < count; i++) {
										p = mp.getBodyPart(i);
										multipart.addBodyPart(p);
									}
								}
							}
							
							// 기존 메시지의 모든 헤더를 적용한다.
							Enumeration<Header> e = oldMessage.getAllHeaders();
							while(e.hasMoreElements()){
								Header header = e.nextElement();
								newMessage.setHeader(header.getName(), header.getValue());
							}
							
							// 기존 메시지를 제거한다.
							oldMessage.setFlag(Flags.Flag.DELETED, true);
						}
					}
					
					// 새로 업로드된 파일들을 새 메시지에 추가한다.
					for (int i=0; i<fileNodes.getLength(); i++) {
						Node subNode = fileNodes.item(i);
						NodeList childNodes = subNode.getChildNodes();
						String fileName = childNodes.item(0).getTextContent();
						String path = childNodes.item(1).getTextContent();
						String bigBool = childNodes.item(2).getTextContent();
						
						// 일반첨부파일의 경우
//						if (hasAttachFile && bigBool.equals("N")) {
						    // 첨부파일을 삽입할 Part를 생성한다.
							BodyPart messageBodyPart = new MimeBodyPart();
							
					        File f = new File(pDirTempPath + commonUtil.separator + path);
					        FileDataSource source = new FileDataSource(pDirTempPath + commonUtil.separator + path);
					        messageBodyPart.setDataHandler(new DataHandler(source));
					        
					        // MimeUtility.encodeText is needed to encode a file name in UTF-8 explicitly, 
					        // otherwise, a wrong encoding may be used on some systems(linux, etc)
					        String encodedFileName = MimeUtility.encodeText(fileName, "UTF-8", null);
					        
							// folding a filename is done manually since BodyPart.setFileName method encodes it based on RFC 2231.
							// and some mailers (Daum, etc) may not understand it.			        
					        encodedFileName = MimeUtility.fold(0, encodedFileName);
					        messageBodyPart.setHeader("Content-Disposition", "attachment;\r\n\tfilename=\"" + encodedFileName + "\"");
					        
					        // 첨부파일 Content-Type의 디폴트는 application/octet-stream로 설정한다.
					        String contentType = "application/octet-stream";
					        
					        // 첨부파일의 Content-Type을 구한다.
					        if (Files.probeContentType(f.toPath()) != null) {
					        	contentType = Files.probeContentType(f.toPath());
					        } else {
					        	if (path.substring(path.lastIndexOf(".")).equalsIgnoreCase(".eml")) {
					        		contentType = "message/rfc822";
					        	}
					        }
					        
					        messageBodyPart.setHeader("Content-Type", contentType);
					        
					        // Multipart에 첨부파일 Part를 삽입한다.
					        multipart.addBodyPart(messageBodyPart);
							
					        //TODO: fileName parameter를 attachCount로 바꿔야 할것같음. 또는 (filename, attachCount).
					        //메일에서 첨부파일 삭제할 때 attachCount 필요함.
					        childNodes.item(4).setTextContent(fileName);
					        
//						} else {
//							if (!path.equals("")) {
//								String[] newPath = path.split("\\|!\\|");
//								childNodes.item(1).setTextContent(newPath[1]);
//								childNodes.item(4).setTextContent(newPath[0] + commonUtil.separator + newPath[1]);
//							}
//						}
					}
					
					if (hasAttachFile) {
						newMessage.setContent(multipart);
						newMessage.setFlag(Flags.Flag.SEEN, true);
						AppendUID[] uids = ((IMAPFolder)folder).appendUIDMessages(new Message[]{newMessage});
						xmldom.getElementsByTagName("URL").item(0).setTextContent(String.valueOf(uids[0].uid));
					} else {
						if (uid == 0) {
							xmldom.getElementsByTagName("URL").item(0).setTextContent("");
						} else {
							xmldom.getElementsByTagName("URL").item(0).setTextContent(String.valueOf(uid));
						}
					}
		    		
					// 처리가 완료된 일반첨부파일 원본 파일들을 삭제한다.				
					for (int i=0; i<fileNodes.getLength(); i++) {
						Node subNode = fileNodes.item(i);
						NodeList childNodes = subNode.getChildNodes();
						
		                if (childNodes.item(2).getTextContent().equals("N")) {
		                	File file = new File(pDirTempPath + commonUtil.separator + childNodes.item(1).getTextContent());
		                    if (file.exists()) {
		                    	file.delete();
		                    }
		                }
		            }
				}
				
				if (hasAttachFile) {
			        folder.close(true);
				}
				
				returnValue = commonUtil.convertDocumentToString(xmldom);
				
			} catch (MessagingException e) {
				returnValue = e.getMessage();
				e.printStackTrace();
				result.put("status", "error");
				result.put("code", 1);			
				result.put("data", "");
			} finally {
				if (ia != null) {
					ia.close();
				}
			}
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", returnValue);
			
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		}
		
		LOGGER.debug("mailInterAttach ended.");
		
		return result;
	}
	
	/**
	 * 일반 첨부파일 삭제 실행 함수
	 */
	
	@RequestMapping(value="/mobile/ezemail/mails/deletesmail/users/{userId}", method= RequestMethod.POST, produces="application/json;charset=utf-8")
	@ResponseBody
	public Object mailDelInterAttach(HttpServletRequest request, @PathVariable String userId, @RequestBody JSONObject jsonObject) throws Exception {
		LOGGER.debug("mailDelInterAttach started.");
		
		
		String returnValue = "";
		String cmd = "";
	    
		JSONObject result = new JSONObject();
		
		try {
		
			String serverName = request.getHeader("x-user-host");
			
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			String domainName = ezCommonService.getTenantConfig("DomainName", info.getTenantId());
			String userEmail = info.getUserId() + "@" + domainName;
			String password = jspw;
			
			String ld = commonUtil.getTwoLetterLangFromLangNum(info.getLang());
			Locale locale = new Locale(ld);
			
			MOptionVO opt = mOptionService.optionInfo(userId, info.getTenantId());
			if ( opt.getLang().equals("1") ) {
				locale = new Locale("ko");	
			} else if ( opt.getLang().equals("3") ) {
				locale = new Locale("ja");
			}
			
			returnValue = "<DATA><![CDATA[";
			
			String xmldomString = "";
			String realPath = commonUtil.getRealPath(request);
			
			if (jsonObject.get("xmldom") != null) {
				xmldomString = (String) jsonObject.get("xmldom");
			}
			Document xmlDoc = commonUtil.convertStringToDocument(xmldomString);
			Element root = xmlDoc.getDocumentElement();
			
			long uid = 0;
			if (root.getElementsByTagName("ITEMID") != null) {
				String uidStr = root.getElementsByTagName("ITEMID").item(0).getTextContent();
				if (uidStr != null && !uidStr.trim().equals("")) {
					uid = Long.parseLong(uidStr);
				}
			}
			
			if (uid != 0) {
				NodeList rows = root.getElementsByTagName("ROW");
				
				if (rows != null && rows.item(0) != null) {
					SMTPAccess sa = SMTPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.SMTPPort"),
							userEmail, password);
					
					IMAPAccess ia = null;
					try {
						ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
								userEmail, password, egovMessageSource, locale);
						
						Folder folder = ia.getFolder(egovMessageSource.getMessage("ezEmail.t99000027", locale));
						folder.open(Folder.READ_WRITE);
						Message oldMessage = ((IMAPFolder)folder).getMessageByUID(uid);
						
						if (oldMessage != null) {
							
							//TODO: rows에 filename대신 index넣기, 
							//deleteAttach(SMTPAccess sa, Message oldMessage, int[] index) 부르기
							
							MimeMessage newMessage = sa.createMimeMessage();
							Multipart multipart = new MimeMultipart();
							
							Multipart mp = (Multipart)oldMessage.getContent();
							int count = mp.getCount();
							BodyPart p = null;
							
							for (int i = 0; i < count; i++) {
								p = mp.getBodyPart(i);
								
								int length = rows.getLength();
								boolean isRemoved = false;
								if (p.getDisposition() != null && p.getDisposition().equalsIgnoreCase(Part.ATTACHMENT)) {
									for (int j = 0; j < length; j++) {
										String mailFileName = MimeUtility.decodeText(p.getFileName());
										if (rows.item(j).getFirstChild().getTextContent().equals(mailFileName)) {
											isRemoved = true;
											break;
										}
									}
								}
								
								if (!isRemoved) {
									multipart.addBodyPart(p);
								}
							}
							
							@SuppressWarnings("unchecked")
							Enumeration<Header> e = oldMessage.getAllHeaders();
							while(e.hasMoreElements()){
								Header header = e.nextElement();
								newMessage.setHeader(header.getName(), header.getValue());
							}
							//
							
							if (multipart.getCount() != 0) {
								newMessage.setContent(multipart);
								newMessage.setFlag(Flags.Flag.SEEN, true);
								AppendUID[] uids = ((IMAPFolder)folder).appendUIDMessages(new Message[]{newMessage});
								returnValue += uids[0].uid;
							}
							
							oldMessage.setFlag(Flags.Flag.DELETED, true);
							
						}
						folder.close(true);
						
					} catch (MessagingException e) {
						e.printStackTrace();
					} finally {
						if (ia != null) {
							ia.close();
						}
					}
				}
			}
			returnValue += "]]></DATA>";
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", returnValue);
			
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		}
		
		
		LOGGER.debug("mailDelInterAttach ended. returnValue=" + returnValue);
		
		return result;
	}

	
	/**
	 * 모바일 G/W 이메일 [POST] 임시저장
	 */
	@RequestMapping(value="/mobile/ezemail/mail-save/users/{userId}", method= RequestMethod.POST, produces="application/json;charset=utf-8")
	public Object mMailSave(HttpServletRequest request, @PathVariable String userId, @RequestBody JSONObject jsonObject) throws Exception {
		LOGGER.debug("MOBILE G/W MAIL [POST /ezemail/mail-save/users/{userId}] started.");
		JSONObject result = new JSONObject();
		
		try{
			
		boolean retryFlag = false;
		int retryCount = 1; //메일 발송 실패 시 재시도 횟수
		long draftUID = 0;
		long sentFolderMessageUID = 0;
		boolean mailSendCompleted = false;
		
		String importance = "3";
		
		String subject = "";
		String to = "";
		String cc = "";
		String bcc = "";
		String textBody = "";
		String from = "";
		String charset = "";
		String htmlbody = "";
		String displayName = "";
		String stateName = "";
		
		if (jsonObject.get("subject") != null) {
			subject = (String) jsonObject.get("subject");
		}
		
		if (jsonObject.get("to") != null) {
			to = (String) jsonObject.get("to");
		}
		
		if (jsonObject.get("cc") != null) {
			cc = (String) jsonObject.get("cc");
		}
		
		if (jsonObject.get("bcc") != null) {
			bcc = (String) jsonObject.get("bcc");
		}
		
		if (jsonObject.get("textBody") != null) {
			textBody = (String) jsonObject.get("textBody");
		}
		
		if (jsonObject.get("from") != null) {
			from = (String) jsonObject.get("from");
		}
		
		if (jsonObject.get("charset") != null) {
			charset = (String) jsonObject.get("charset");
		}
		
		if (jsonObject.get("htmlbody") != null) {
			htmlbody = (String) jsonObject.get("htmlbody");
		}
		
		if (jsonObject.get("displayName") != null) {
			displayName = (String) jsonObject.get("displayName");
		}
		
		if (jsonObject.get("stateName") != null) {
			stateName = (String) jsonObject.get("stateName");
		}
		
		if (jsonObject.get("importance") != null) {
			importance = (String) jsonObject.get("importance");
		}
		
		String realPath = commonUtil.getRealPath(request);

		LOGGER.debug("subject = " + subject + ", to = " + to + ", cc = " + cc + ", bcc = " + bcc + ", textBody = " 
		+ textBody + ", from = " + from + ", charset = " + charset + ", htmlbody = " + htmlbody + ", htmlbody = " + htmlbody
		+ ", displayName = " + displayName + ", stateName = " + stateName); 
				
		String serverName = request.getHeader("x-user-host");
		
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			String domainName = ezCommonService.getTenantConfig("DomainName", info.getTenantId());
			String userEmail = info.getUserId() + "@" + domainName;
			String password = jspw;
			
			String ld = commonUtil.getTwoLetterLangFromLangNum(info.getLang());
			Locale locale = new Locale(ld);
			
			MOptionVO opt = mOptionService.optionInfo(userId, info.getTenantId());
			if ( opt.getLang().equals("1") ) {
				locale = new Locale("ko");	
			} else if ( opt.getLang().equals("3") ) {
				locale = new Locale("ja");
			}
			
			SMTPAccess sa = SMTPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.SMTPPort"),
					userEmail, password);
		
			String pResult = null;
			IMAPAccess ia = null;
		
			do {
				try {
					ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
							userEmail, password, egovMessageSource, locale);
					
					//메일 발송 재시도일 경우 draftUID의 메일을 지우고 retryFlag와 draftUID를 초기화한다.
//					if (retryFlag) {
//						if (draftUID != 0) {
//							Folder draftFolder = null;
//    					
//							try {
//								draftFolder = ia.getFolder(egovMessageSource.getMessage("ezEmail.t99000027", locale));
//								draftFolder.open(Folder.READ_WRITE);
//								Message draftMessage = ((IMAPFolder)draftFolder).getMessageByUID(draftUID);
//								draftMessage.setFlag(Flags.Flag.DELETED, true);
//								draftFolder.close(true);
//								draftFolder = null;
//    		        		
//								LOGGER.debug("draftUID message deleted successfully during retry.");
//							} catch (Exception e) {
//								LOGGER.error("Failed to delete draftUID message during retry. draftUID=" + draftUID);
//							} finally {
//								if (draftFolder != null) {
//									try {
//    								draftFolder.close(true);
//									} catch (Exception e) {}
//									draftFolder = null;
//								}
//							}
//						}
//				    
//					    // 보낸편지함에 저장된 이후 Exception이 발생하여 Retry하는 경우 보낸편지함에 있는 메시지를 삭제한다.
//					    if (sentFolderMessageUID != 0) {
//	                        Folder sentFolder = null;
//	                        
//	                        try {
//	                            sentFolder = ia.getFolder(egovMessageSource.getMessage("ezEmail.t99000026", locale));
//	                            sentFolder.open(Folder.READ_WRITE);
//	                            Message sentMessage = ((IMAPFolder)sentFolder).getMessageByUID(sentFolderMessageUID);
//	                            sentMessage.setFlag(Flags.Flag.DELETED, true);
//	                            sentFolder.close(true);
//	                            sentFolder = null;
//	                            
//	                            LOGGER.debug("sentFolderMessageUID message deleted successfully during retry.");
//	                        } catch (Exception e) {
//	                            LOGGER.error("Failed to delete sentFolderMessageUID message during retry. sentFolderMessageUID=" + sentFolderMessageUID);
//	                        } finally {
//	                            if (sentFolder != null) {
//	                                try {
//	                                    sentFolder.close(true);
//	                                } catch (Exception e) {}
//	                                
//	                                sentFolder = null;
//	                            }
//	                        }				        
//					    }
//						
//						retryFlag = false;
//						draftUID = 0;
//						sentFolderMessageUID = 0;
//					}
					
					//편지함 용량 체크
					long[] storageUsageAndLimit = ia.getStorageUsageAndLimit();
					double mailboxUsage = storageUsageAndLimit[0]; // in KBs
					double mailboxQuota = storageUsageAndLimit[1]; // in KBs
					LOGGER.debug("mailboxUsage=" + mailboxUsage + ",mailboxQuota=" + mailboxQuota);
					
					if (mailboxUsage >= mailboxQuota) {
						throw new Exception("OVERQUOTA");
					}
				
					// MIME Message를 생성한다.
					MimeMessage message = sa.createMimeMessage();
					
					// 메일 From,TO,CC,BCC
					InternetAddress internetAddress = new InternetAddress();
					String name = "";
					String address = "";
					
					// From
					LOGGER.debug("from=" + from);
					String pattern = "\"?([^\"]*)\"? <([^<>]+)>";
					Pattern r = Pattern.compile(pattern);
					Matcher m = r.matcher(from);
					
					if (m.find()) {
						name = m.group(1);
						address = m.group(2);
						internetAddress.setPersonal(name, "UTF-8");
						internetAddress.setAddress(address);
						message.setFrom(internetAddress);
					}
				
					// To
					LOGGER.debug("to=" + to);
					m = r.matcher(to);
					while (m.find()) {
						name = m.group(1);
						address = m.group(2);
						internetAddress.setPersonal(name, "UTF-8");
						internetAddress.setAddress(address);
						message.addRecipient(RecipientType.TO, internetAddress);
					}
					
					// Cc
					LOGGER.debug("cc=" + cc);
					m = r.matcher(cc);
					while (m.find()) {
						name = m.group(1);
						address = m.group(2);
						internetAddress.setPersonal(name, "UTF-8");
						internetAddress.setAddress(address);
						message.addRecipient(RecipientType.CC, internetAddress);
					}
					
					// Bcc
					LOGGER.debug("bcc=" + bcc);
					m = r.matcher(bcc);
					while (m.find()) {
						name = m.group(1);
						address = m.group(2);
						internetAddress.setPersonal(name, "UTF-8");
						internetAddress.setAddress(address);
						message.addRecipient(RecipientType.BCC, internetAddress);
					}				
					
					// 메일 제목
					message.setSubject(subject, "UTF-8");
				
//				LOGGER.debug("cmd=" + cmd + ",simpleMime=" + simpleMime);
				
					Multipart alternativePart = null;
		        
					// 메일 본문 및 타입
					MimeBodyPart content = new MimeBodyPart();
				
				// simpleMime의 값이 1인 경우는 Plain Text 형식이다.
//				if (simpleMime.equals("1")) {
				 // 메일을 발송하는 경우
//		            if (!cmd.toUpperCase().equals("SAVE")) {
		                // 예약 메일의 경우
//		                if (!delaySendTime.equals("")) {
//		                	message.setContent(textBody, "text/plain; charset=utf-8");
//		                	content.setContent(textBody, "text/plain; charset=utf-8");
//		                // 지금 발송하는 경우
//		                } else {
//		           	message.setContent(textBody.replaceAll("div id=\"MailSign\"", "div id=\"MailSignSent\""), "text/plain; charset=utf-8");
//		           	content.setContent(textBody.replaceAll("div id=\"MailSign\"", "div id=\"MailSignSent\""), "text/plain; charset=utf-8");
//		                }
		             // 임시 보관함에 저장하는 경우    
//		            } else {
//		            	message.setContent(textBody, "text/plain; charset=utf-8");
//		            	content.setContent(textBody, "text/plain; charset=utf-8");
//		            }
		        // HTML 형식의 경우
//		        } else {
//		            // 메일을 발송하는 경우
//		            if (!cmd.toUpperCase().equals("SAVE")) {
//		                // 예약 메일의 경우
//		                if (!delaySendTime.equals("")) {
//		                	message.setContent(htmlBody, "text/html; charset=utf-8");
		                	content.setContent(textBody, "text/html; charset=utf-8");
//		                // 지금 발송하는 경우
//		                } else {
//		                	message.setContent(htmlBody.replaceAll("div id=\"MailSign\"", "div id=\"MailSignSent\""), "text/html; charset=utf-8");
//		                	content.setContent(htmlBody.replaceAll("div id=\"MailSign\"", "div id=\"MailSignSent\""), "text/html; charset=utf-8");
//		                }
//		            // 임시 보관함에 저장하는 경우
//		            } else {
//		            	message.setContent(htmlBody, "text/html; charset=utf-8");
//		            	content.setContent(htmlBody, "text/html; charset=utf-8");
//		            }
//		
//		            // multipart/alternative로 구성한다.
	                alternativePart = new MimeMultipart("alternative");
//		            
//	                // text/plain 파트를 구성한다.
		            MimeBodyPart textPlainPart = new MimeBodyPart();
		            textPlainPart.setText(textBody, "utf-8");	
//		            
//		            // text/plain 파트를 추가한다.
		            alternativePart.addBodyPart(textPlainPart);
//		            // text/html 파트를 추가한다. content가 text/html 파트를 갖고 있다.
		            alternativePart.addBodyPart(content);
//		            
		            message.setContent(alternativePart);
//		        }
				
				// 보안메일
//				if (pSecurityMail.equals("3")) {
//					message.setHeader("Sensitivity", "company-confidential");
//		        }
				
				// 메일 중요도
				switch (importance) { // 2: High, 1: Normal, 0: Low
		            case "0": message.setHeader("X-Priority", "5");
		                break;
		            case "1": message.setHeader("X-Priority", "3");
		                break;
		            case "2": message.setHeader("X-Priority", "1");
		                break;
		            default: message.setHeader("X-Priority", "3");
		                break;
		        }
				
//				// 추적(배달되면 알림)
//				LOGGER.debug("replySendTime=" + replySendTime);
//		        if (replySendTime.equals("1")) {
//		        	message.setHeader("Return-Receipt-To", ((InternetAddress)message.getFrom()[0]).getAddress());
//		        }
//		
//		        // 추적(수신확인)
//		        LOGGER.debug("replyReadTime=" + replyReadTime);
//		        if (replyReadTime.equals("1")) {
//		        	message.setHeader("Disposition-Notification-To", ((InternetAddress)message.getFrom()[0]).getAddress());
//		        }
		        
//		        SentDate 설정
		        message.setSentDate(Calendar.getInstance().getTime());
//		        
//		        User-Agent 설정
		        message.setHeader("User-Agent", "JMocha Mail 1.0");	        
//		        
//		        //inline image 처리
//		        MimeMultipart relatedPart = null;
//		        Set<String> contentIdSet = new HashSet<String>();
//		        
//		        // simpleMime의 값이 1인 아닌 경우는 HTML 형식이다.
//		        if (!simpleMime.equals("1")) {
//		        	// getElementsByTagName always returns non-null object even if
//		        	// the tag doesn't exist, so its length must be checked.
//		        	NodeList imageNameList = root.getElementsByTagName("IMAGENAME");
//		        	NodeList imagePathList = root.getElementsByTagName("IMAGEPATH");
//		        	
//		        	// 새롭게 추가된 이미지가 있으면 이미지를 파트로 추가하고 Related Part로 구성한다.
//			        if (imageNameList != null && imageNameList.getLength() > 0
//			        		&& imagePathList != null && imagePathList.getLength() > 0) {
//			        	String imageName = "";
//			            String imagePath = "";
//			        	
//			            // Related Part를 생성한다.
//			            relatedPart = new MimeMultipart("related");
//			            
//			        	for (int i=0; true; i++) {
//			            	if (imageNameList.item(i) == null || imagePathList.item(i) == null) {
//			            		break;
//			            	}
//			            	
//			            	imageName = imageNameList.item(i).getTextContent();
//			            	imagePath = imagePathList.item(i).getTextContent();
//			            	
//			            	if (!imageName.trim().equals("") && !imagePath.trim().equals("")) {
//			            	    // 이미지 파일의 Path를 구한다.
//			                	imagePath = new URL(imagePath).getPath();
//			                	String pDirPath = realPath + imagePath;
//			                	
//			        	        File f = new File(pDirPath);
//			        	        
//			        	        if (f.exists()) {	            		
//			        	            // 본문 내용에 있는 image tag의 src 속성의 값을 content id 형식으로 변경한다.
//				                	String cid = imageName + "@12345678.87654321";
//				                	String strContent = content.getContent().toString();
//				                	int index = strContent.indexOf("src=\"" + imageName);
//				                	if (index != -1) {
//				                		strContent = strContent.replace("src=\"" + imageName, "src=\"cid:" + cid);
//				                	}
//				                	content.setContent(strContent, "text/html; charset=utf-8");
//			                		        	        
//				                	// 이미지 파일을 추가할 Mime Body Part를 생성한다.
//				                	MimeBodyPart messageBodyPart = new MimeBodyPart();
//				                	
//				        	        FileDataSource source = new FileDataSource(f);
//				        	        messageBodyPart.setDataHandler(new DataHandler(source));
//				        	        messageBodyPart.setFileName(imageName);
//				        	        
//				        	        // 이미지 파일의 Default Content-Type은 application/octet-stream 로 설정한다.
//				        	        String contentType = "application/octet-stream";
//				        	        
//				        	        // 이미지 파일의 Content-Type을 구한다.
//				        	        if (Files.probeContentType(f.toPath()) != null) {
//				        	        	contentType = Files.probeContentType(f.toPath());
//				        	        }
//				        	        
//				        	        messageBodyPart.setHeader("Content-Type", contentType);
//				        	        String cidWithBrackets = "<" + cid + ">";
//				        	        messageBodyPart.setContentID(cidWithBrackets);
//				        	        messageBodyPart.setDisposition(Part.INLINE);
//				        	        
//				        	        contentIdSet.add(cidWithBrackets);
//				        	        LOGGER.debug("cidWithBrackets=" + cidWithBrackets);
//				        	        
//				        	        // Related Part에 이미지 Part를 추가한다.
//				        	        relatedPart.addBodyPart(messageBodyPart);
//			        	        }
//			                }
//			            }
//			        	
//			        	// Related Part의 첫 부분에 본문 Part를 삽입한다.
//			        	relatedPart.addBodyPart(content, 0);
//			        	
//			        	// Alternative의 두 번째 파트에 기존 HTML 파트를 제거하고 Related Part를 삽입한다.
//			        	alternativePart.removeBodyPart(1);
//	                    MimeBodyPart wrap = new MimeBodyPart();
//	                    wrap.setContent(relatedPart);
//			        	alternativePart.addBodyPart(wrap, 1);
//			        	
//			        	message.setContent(alternativePart);
//					}
//		        }
		        
	            // 임시 보관함에 메시지가 있는 경우 해당 메시지와 병합 작업을 수행한다.
//		        Message oldMessage = null;
//		        long uid = 0;
		        
		        Folder draftFolder = ia.getFolder(egovMessageSource.getMessage("ezEmail.t99000027", locale));
		        draftFolder.open(Folder.READ_WRITE);
		        
//		        LOGGER.debug("url=" + url);
		        
//		        if (!url.trim().equals("")) {
//		        	uid = Long.parseLong(url);
//		        
//		        	MimeMultipart mixedPart = new MimeMultipart();
//					
//					if (uid != 0) {
//					    // 임시 보관함에 있는 기존 메시지를 불러온다.
//						oldMessage = ((IMAPFolder)draftFolder).getMessageByUID(uid);
//						
//						if (oldMessage != null) {
//							// copy existing headers that are needed.
//							String[] headers = oldMessage.getHeader("References");
//							
//							if (headers != null) {
//								message.setHeader("References", headers[0]);
//							}
//							
//							headers = oldMessage.getHeader("In-Reply-To");
//							if (headers != null) {
//								message.setHeader("In-Reply-To", headers[0]);
//							}
//							
//							// 기존 메시지가 Multipart 메시지일 경우의 처리
//							if (oldMessage.getContent() instanceof Multipart) {
//							    // 기존 메시지의 Multipart를 불러온다.
//								Multipart mp = (Multipart)oldMessage.getContent();
//								int count = mp.getCount();
//								BodyPart p = null;
//								boolean hasAttach = false;
//								
//								// Multipart의 각 Part별 처리를 수행한다.
//								for (int i = 0; i < count; i++) {
//									p = mp.getBodyPart(i);
//									
//									while (true) {
//									    // Part가 Related Part일 경우의 처리
//	    								if (alternativePart != null && p.isMimeType("multipart/related")) {
//	    								    LOGGER.debug("Part is multipart/related");
//	    								    
//	    									hasAttach = true;
//	    									
//	    									LOGGER.debug("relatedPart=" + relatedPart);
//	    									
//	    									if (relatedPart == null) {
//	    										relatedPart = new MimeMultipart("related");
//	    										    							
//	    					                    MimeBodyPart wrap = new MimeBodyPart();
//	    					                    wrap.setContent(relatedPart);
//	    					                    alternativePart.removeBodyPart(1);
//	    					                    alternativePart.addBodyPart(wrap, 1);
//	    									}
//	    									// new related part is already created by the above routine
//	    									// for adding new in-line images.
//	    									else {
//	    										relatedPart.removeBodyPart(0);
//	    									}
//	    									
//	    									// 기존 메시지의 Related Part와 병합한다.
//	    									Multipart existingRelatedPart = (Multipart)p.getContent();
//	    									int existingRelatedPartCount = existingRelatedPart.getCount();
//	    									BodyPart existingRelatedSubPart = null;
//	    									
//	    									for (int j = 0; j < existingRelatedPartCount; j++) {
//	    									    existingRelatedSubPart = existingRelatedPart.getBodyPart(j);
//	    										
//	    										if (existingRelatedSubPart instanceof MimePart) {
//	    										    String contentId = ((MimePart)existingRelatedSubPart).getContentID();
//	    										    LOGGER.debug("Existing ContentId=" + contentId);
//	    										    
//	    											if (contentId != null && !contentIdSet.contains(contentId)) {
//	    											    LOGGER.debug("Adding ContentId=" + contentId);
//	    											    
//	    												relatedPart.addBodyPart(existingRelatedSubPart);						
//	    											}
//	    										}				
//	    									}
//	    									
//	    									String bodyContent = content.getContent().toString();
//	    									bodyContent = convertDownloadInlineImageURLtoCid(bodyContent);							
//	    									content.setContent(bodyContent, "text/html; charset=utf-8");
//	    									relatedPart.addBodyPart(content, 0);
//	    									
//	    									removeUnusedInlineImagePart(relatedPart);
//	    								}
//	    								// Part가 Alternative Part일 경우의 처리
//	    								else if (alternativePart != null && p.isMimeType("multipart/alternative")) {
//	    								    LOGGER.debug("Part is multipart/alternative");
//	    								    
//	    								    hasAttach = true;
//	    								    
//	                                        Multipart existingAlternativePart = (Multipart)p.getContent();
//	                                        int existingAlternativePartCount = existingAlternativePart.getCount();
//	                                        BodyPart existingAlternativeSubPart = null;
//	                                        boolean isRelatedFound = false;
//	                                        
//	                                        for (int j = 0; j < existingAlternativePartCount; j++) {
//	                                            existingAlternativeSubPart = existingAlternativePart.getBodyPart(j);
//	                                            
//	                                            if (existingAlternativeSubPart instanceof MimePart) {
//	                                                // Alternative Part 안에 Related Part가 있는 경우에 대한 처리
//	                                                if (existingAlternativeSubPart.isMimeType("multipart/related")) {
//	                                                    isRelatedFound = true;
//	                                                    break;
//	                                                }
//	                                            }               
//	                                        }						
//	                                        
//	                                        if (isRelatedFound) {
//	                                            // p를 발견된 related 파트로 변경하여 루프의 시작 부분에 있는 related 파트 처리 부분으로 제어를 옮긴다.
//	                                            p = existingAlternativeSubPart;
//	                                            continue;
//	                                        }
//	                                    }								
//	                                    // there are cases where an in-line image part doesn't have
//	                                    // a Content-Disposition header, but has a Content-ID header.    								
//	    								else if (p instanceof MimePart 
//	    								        && ((MimePart)p).getContentID() != null) {
//	    								    String contentId = ((MimePart)p).getContentID();
//	    								    LOGGER.debug("Existing ContentId=" + contentId);
//	    								    
//	    								    if (!contentIdSet.contains(contentId)) {
//	    								        LOGGER.debug("Adding ContentId=" + contentId);
//	    								        
//	    								        mixedPart.addBodyPart(p);
//	    								    }
//	    								}
//	    								// Content-Disposition 헤더가 없이 첨부된 파일이 있어
//	    								// Content-Type이 application으로 시작하는 경우도 추가함 
//	    								// 예) Content-Type: application/octet-stream;
//	    								//         name="=?utf-8?B?NDExMDAwODE1OS5QREY=?="
//	    							    //    Content-Transfer-Encoding: base64	    								
//	    								else if (p.getDisposition() != null || p.isMimeType("application/*")) { 
//	    									mixedPart.addBodyPart(p);
//	    									
//	    									// 첨부파일 파트인 경우
//	    									if ((p.getDisposition() != null && p.getDisposition().equalsIgnoreCase(Part.ATTACHMENT))
//	    											|| p.isMimeType("application/*")) {
//	    										hasAttach = true;
//	    									}
//	    								}
//	    								// Part가 message 인 경우, 즉 메일이 첨부된 경우
//	    								else if (p.isMimeType("message/*")) {
//	    								    LOGGER.debug("Part is message");
//	    								    
//	    									mixedPart.addBodyPart(p);
//	    									hasAttach = true;
//	    								}							
//	    								
//	    								break;
//									}
//								}
//								
//								// 기존 메시지에 첨부파일이 있거나 Alternative Part 혹은 Related Part가 있는 경우의 처리
//								if (hasAttach) {
//									if (alternativePart != null) {
//										MimeBodyPart wrap = new MimeBodyPart();
//										wrap.setContent(alternativePart);
//										mixedPart.addBodyPart(wrap, 0);
//									} else {
//										mixedPart.addBodyPart(content, 0);
//									}							
//									
//									message.setContent(mixedPart);							
//								}
//								// 기존 메시지가 Related Part일 경우의 처리
//								else if (oldMessage.isMimeType("multipart/related")) {
//								    LOGGER.debug("oldMessage is multipart/related");
//									LOGGER.debug("relatedPart=" + relatedPart);
//									
//	                                if (alternativePart != null) {								
//	    								// 새로 추가되는 이미지 파트들을 추가한다.
//	    								// 기존 메시지의 이미지 파트들은 위에서 이미 mixedPart에 추가되어 있다.
//	    								// a new related part is already created by the above routine
//	    								// for adding new in-line images.						
//	    								if (relatedPart != null) {
//	    									relatedPart.removeBodyPart(0);
//	    									
//	    									BodyPart relatedSubPart = null;
//	    									for (int i = 0; i < relatedPart.getCount(); i++) {
//	    										relatedSubPart = relatedPart.getBodyPart(i);
//	    										mixedPart.addBodyPart(relatedSubPart);
//	    									}
//	    								}
//	    								
//	    								// 기존 메시지가 Related Part인 경우는 첨부파일이 없는 경우이므로 mixed가 아니다.
//	    								// this mixedPart is actually a related part.
//	    								mixedPart.setSubType("related");
//	    								
//	    								String bodyContent = content.getContent().toString();																
//	                                    bodyContent = convertDownloadInlineImageURLtoCid(bodyContent);                          
//	                                    content.setContent(bodyContent, "text/html; charset=utf-8");                            
//	                                    mixedPart.addBodyPart(content, 0);
//	                                    
//	                                    removeUnusedInlineImagePart(mixedPart);
//	                                                                        
//	                                    MimeBodyPart wrap = new MimeBodyPart();
//	                                    wrap.setContent(mixedPart);
//	                                    alternativePart.removeBodyPart(1);
//	                                    alternativePart.addBodyPart(wrap, 1);                                                                               
//	                                } 
//								}
//							}					
//						}
//					}
//		        }        
		        
		        //mailboxUsage + messageSize >= mailboxQuota인 경우 OVERQUOTA Exception
		        CountOutputStream cos = null;
		        double messageSize = 0;
		        
		        try {
		        	cos = new CountOutputStream();
		        	message.writeTo(cos);
		        	messageSize = cos.getSize() / 1024.0;
		        } catch(Exception e) {
		        	e.printStackTrace();
		        } finally {
		        	try { cos.close(); } catch (Exception e) {}
		        }
		        
		        LOGGER.debug("mailboxUsage=" + mailboxUsage + ", messageSize=" + messageSize + ", mailboxQuota=" + mailboxQuota);
		        
		        if (mailboxUsage + messageSize >= mailboxQuota) {
					throw new Exception("OVERQUOTA");
				}
		        
		        //messageSize가 maxMessageSize 넘을 경우 OVERMESSAGESIZE Exception
		        int maxMessageSize = ezEmailService.getMaxMessageSize(info.getTenantId());
		        
		        if (maxMessageSize > 0 && messageSize > maxMessageSize) {
		        	double maxMessageSizeD = maxMessageSize / 1024.0;
		        	maxMessageSizeD = Math.round(maxMessageSizeD * 10) / 10;
		        	
		        	double messageSizeD = messageSize / 1024.0;
		        	messageSizeD = Math.round(messageSizeD * 10) / 10;
		        	
		        	throw new Exception("OVERMESSAGESIZE:" + maxMessageSizeD + "MB:" + messageSizeD + "MB");
		        }
		        
//		        if (cmd.equalsIgnoreCase("SAVE")) {
		        	LOGGER.debug("Saving the message");
		        	
//		    		Boolean isEachMailB = Boolean.parseBoolean(isEachMail.trim());
		    		
//		    		if (isEachMailB) {
//	                	message.setHeader("X-JMocha-Each-Mail", "true");
//                    }
//		    		if (delaySendTime != ""){
//		    			message.setHeader("Delivery-Date", delaySendTime);
//		    		}
		    		message.setFlag(Flags.Flag.SEEN, true);
		    		AppendUID[] uids = ((IMAPFolder)draftFolder).appendUIDMessages(new Message[]{message});
		    		if (uids != null && uids[0] != null) {
		    			draftUID = uids[0].uid;
		    		} 
		    	
		            // this deletion code block has been moved here because
		            // it needs to be kept in Drafts if an error occurs during the above process.
//		            if (oldMessage != null) {
//		            	oldMessage.setFlag(Flags.Flag.DELETED, true);
//		            }
		            
//		        } else if (cmd.equalsIgnoreCase("SEND")) {
//		        	LOGGER.debug("Sending the message");
		        	
//                    Folder sentFolder = ia.getFolder(egovMessageSource.getMessage("ezEmail.t99000026", locale));
                    		        
//					String strCheckReadUrl = ""; //외부메일수신확인 관련 URL. GetSystemConfigValue("APPREADCHECK_URL").ToString();
//			        Boolean isEachMailB = Boolean.parseBoolean(isEachMail.trim());
			        
//			        if (!displayName.equals("")) {
//		            	message.setHeader("X-JMocha-EXT-SENDERNAME", MimeUtility.encodeText(displayName, "UTF-8", null));
//		            }
			                            
//                    message.setFlag(Flags.Flag.SEEN, true);
		            
                    // 예약 발송의 경우
//			        if (!delaySendTime.equals("")) {
//			            // 편지함 용량 초과 메세지 확인을 위해 임시저장
//	                    AppendUID[] uids = ((IMAPFolder)draftFolder).appendUIDMessages(new Message[]{message});
//	                    if (uids != null && uids[0] != null) {
//	                        draftUID = uids[0].uid;
//	                    } 
//			            
//	                    // 개별발신
//	                    if (isEachMailB) {
//		                	message.setHeader("X-JMocha-Each-Mail", "true");
//	                    }
//	                    
//			        	//예약발송
//			        	String delaySendTimeUTC = commonUtil.getDateStringInUTC(delaySendTime, userInfo.getOffset(), true);
//			            doDelaySend(userInfo.getTenantId(), message, isReserve, reservedId, subject, delaySendTimeUTC, userId, realPath);
//			        				            
//			            //임시보관함에서 삭제
//			            Message draftMessage = ((IMAPFolder)draftFolder).getMessageByUID(draftUID);
//		        		draftMessage.setFlag(Flags.Flag.DELETED, true);
//		        		
//                        // this deletion code block has been moved here because
//                        // it needs to be kept in Drafts if an error occurs during the above process.
//                        if (oldMessage != null) {
//                            oldMessage.setFlag(Flags.Flag.DELETED, true);
//                        }		        		
//		        	// 즉시 발송의 경우	
//			        } else {         
			            // mailSendCompleted가 true인 경우는 메일 전송까지 완료된 이후에 Exception이 발생하여 Retry하는 경우이다.
			            // 이 경우에는 이미 보낸편지함에 저장된 메일이 있으므로 보낸편지함에 다시 저장하지 않는다.
//			            if (mailSendCompleted == false) {
    			            // 편지함 용량 초과 메세지 확인을 위해 임시저장
    	                    // 본래는 임시보관함에 미리 저장해두고 성공했을 시 임시보관함에 있는 메일을 보낸메일함으로 복사하였으나
    			            // 보낸메일함에 바로 저장하는 것으로 변경함.
//    	                    AppendUID[] uids = ((IMAPFolder)sentFolder).appendUIDMessages(new Message[]{message});
//    	                    if (uids != null && uids[0] != null) {
//    	                        sentFolderMessageUID = uids[0].uid;
//    	                    } 
//			            }
			            
//			            STRING[] EACHMAILHEADERS = MESSAGE.GETHEADER("X-JMOCHA-EACH-MAIL");
//						STRING EACHMAILHEADER = EACHMAILHEADERS != NULL ? EACHMAILHEADERS[0] : NULL;		
//						
//						IF (EACHMAILHEADER != NULL) {
//							MESSAGE.REMOVEHEADER("X-JMOCHA-EACH-MAIL");
//						}
			            
			            // 개별발신
//			            if (isEachMailB) {
//			            	LOGGER.debug("sending each recipient mail");
//			            	
//			                // mailSendCompleted가 true인 경우는 Transport.send가 완료된 이후에 예외가 발생하여 Retry하는 경우이다.
//			                // 이 경우에는 메일을 다시 전송하지 않는다.
//			                if (mailSendCompleted == false) {			     			                	
//				            	Address[] allRecipients = message.getAllRecipients();
//				            	
//				            	message.removeHeader("TO");
//				        		message.removeHeader("CC");
//				        		message.removeHeader("BCC");
//				        		
//				            	for (Address a : allRecipients) {
//				            		LOGGER.debug("address=" + a);
//				            		
//				            		message.setRecipient(RecipientType.TO, a);
//				            		
//				            		Transport.send(message);
//				            		
//	    			            	sentFolderMessageUID = 0;
//	    			            	mailSendCompleted = true;				            		
//				            	}
//			                }
//			            	
//			                // this deletion code block has been moved here because
//			                // it needs to be kept in Drafts if an error occurs during the above process.
//			                if (oldMessage != null) {
//			                	oldMessage.setFlag(Flags.Flag.DELETED, true);
//			                }
//			            } else {
			                // mailSendCompleted가 true인 경우는 Transport.send가 완료된 이후에 예외가 발생하여 Retry하는 경우이다.
			                // 이 경우에는 메일을 다시 전송하지 않는다.
//			                if (mailSendCompleted == false) {
//    			            	Transport.send(message);
    			            	
//    			            	sentFolderMessageUID = 0;
//    			            	mailSendCompleted = true;
//			                }
			            				                	            				        		
                            // this deletion code block has been moved here because
                            // it needs to be kept in Drafts if an error occurs during the above process.
//                            if (oldMessage != null) {
//                                oldMessage.setFlag(Flags.Flag.DELETED, true);
//                            }			        		
//			            }
			            			            
			            //예악발송 수정 시 옵션에서 예약발송 안하고 저장했을 시 DB 데이터 삭제, 파일 시스템의 eml파일 삭제
//			            LOGGER.debug("reservedId=" + reservedId);
//			            if (reservedId != null && !reservedId.trim().equals("")) {
//							ezEmailService.deleteMailReserved(reservedId);
//			            	
//							String pDirPath = commonUtil.getUploadPath("upload_mail.RESERVED_MAIL_PATH", userInfo.getTenantId());
//				    		pDirPath = realPath + pDirPath;
//				            File f = new File(pDirPath + commonUtil.separator + reservedId + ".eml");
//							if (f.exists()) {
//								f.delete();
//							}
//			            }
			            
			            // set the ANSWERED flag of the original message to indicate it has been replied.
//			            if (mailCmd.equals("REPLY") || mailCmd.equals("REPLYALL") || mailCmd.equals("FORWARD")) {
//			    			int index = orgUrl.lastIndexOf("/");			
//			    			
//			    			if (index != -1) {
//			    				String orgMsgFolderPath = orgUrl.substring(0, index);
//			    				long orgMsgUid = Long.parseLong(orgUrl.substring(index + 1));
//		
//			    				LOGGER.debug("orgMsgFolderPath=" + orgMsgFolderPath + ",orgMsgUid=" + orgMsgUid);
//			    				
//			    		        Folder orgMsgFolder = ia.getFolder(orgMsgFolderPath);
//			    		        orgMsgFolder.open(Folder.READ_WRITE);
//			    				
//			    		        Message orgMessage = ((IMAPFolder)orgMsgFolder).getMessageByUID(orgMsgUid);
//		    		        	
//			    		        if (mailCmd.equals("REPLY") || mailCmd.equals("REPLYALL")) {
//			    		        	orgMessage.setFlag(Flags.Flag.ANSWERED, true);
//			    		        	ezEmailUtil.setForwardedFlag(orgMessage, false);
//			    		        }
//			    		        else {
//			    		        	ezEmailUtil.setForwardedFlag(orgMessage, true);
//			    		        	orgMessage.setFlag(Flags.Flag.ANSWERED, false);
//			    		        }
//			    		        
//			    		        orgMsgFolder.close(true);
//			    			}
//			            }
			            
//			        }
			        
			        //file system의 templist txt파일 삭제
			        String pDirPath = realPath + commonUtil.getUploadPath("upload_mail.ROOT", info.getTenantId()) + commonUtil.separator + "templist";
			        pDirPath += commonUtil.separator + stateName + ".txt";
			        File f = new File(pDirPath);
			        if (f.exists()) {
			        	f.delete();
			        }
			        
//		        }
		        
		        // file system의 inline image 파일 삭제 - 경로가 upload_common인 파일만 삭제
		        // 발송의 경우에만 삭제하고 저장의 경우에는 쓰기 창이 계속 표시되어 있는 상태이므로 삭제하지 않고 유지한다.
		        // 남아있는 이미지 파일들은 스케쥴러에 의해 삭제되어야 함.
//		        if (cmd.equalsIgnoreCase("SEND")) {
//	    	        NodeList imagePathList = root.getElementsByTagName("IMAGEPATH");
//	    	        if (imagePathList != null && imagePathList.getLength() > 0) {
//	    	            String imagePath = "";
//	    	            
//	    	        	for (int i=0; true; i++) {
//	    	            	if (imagePathList.item(i) == null) {
//	    	            		break;
//	    	            	}
//	    	            	
//	    	            	imagePath = imagePathList.item(i).getTextContent();
//	    	            	
//	    	            	if (!imagePath.trim().equals("") && imagePath.contains(commonUtil.getUploadPath("upload_common.ROOT", userInfo.getTenantId()))) {
//	    	                	imagePath = new URL(imagePath).getPath();
//	    	                	String pDirPath = realPath + imagePath;
//	    	            		File f = new File(pDirPath);
//	    	            		if (f.exists()) {
//	    	            			f.delete();
//	    	            		}
//	    	            	}
//	    	        	}
//	    	        }
//		        }
		        
		        draftFolder.close(true);
		        
		        pResult = "<RESULT>OK</RESULT>";
		        pResult += "<MESSAGEID><![CDATA[" + draftUID + "]]></MESSAGEID>";
	        
			} catch (Exception e) {
				e.printStackTrace();
				if (e.getMessage().indexOf("OVERQUOTA") > -1 && e.getMessage().indexOf("OVERMESSAGESIZE") > -1) {
					LOGGER.error("mailInterSend : " + e.getMessage());
					pResult = e.getMessage();
				} else if (e.getMessage().indexOf("Invalid Addresses") > -1) {
					pResult = e.getMessage();
					String cause = e.getCause().toString();
					
					String pattern = "Unknown user: ([\\S]+)";
					Pattern r = Pattern.compile(pattern);
					Matcher m = r.matcher(cause);
					pResult = "Invalid Addresses:";
					
					int index = 1000;
					while (m.find()) {
						// 1000번 이상 반복되면 break한다.
						--index;
						if (index < 0) {
							LOGGER.error("Stop finding invalid addresses, because over 1000 times.");
							break;
						}
						
						pResult += m.group(1) + "|";
					}
					
					pResult = pResult.substring(0, pResult.length() - 1);
				} else { // retry
					e.printStackTrace();
					
					retryFlag = true;
					--retryCount;
					
					if (retryCount > -1) {
						LOGGER.debug("Message send fail. Retry...");
						
						try {
							Thread.sleep(1000);
						} catch (Exception ex) {}
					} else {
						//더이상 retry를 하지 않으므로 리턴 메시지를 세팅한다.
						pResult = e.getMessage();
					}
				}
			} finally {
				if (ia != null) {
					ia.close();
					ia = null;
				}
			}
			
		} while (retryFlag && retryCount > -1);
		
		// 즉시 발송의 경우
//		if (cmd.equalsIgnoreCase("SEND") && delaySendTime.equals("")) {
		    // 보낸편지함에 메일이 저장되었지만 메일 전송이 성공하지 못했다면 해당 메일을 삭제한다.
		    if (mailSendCompleted == false && sentFolderMessageUID != 0) {
                Folder sentFolder = null;
                        
                try {
                    Thread.sleep(1000);
                    
                    ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
                            userEmail, password, egovMessageSource, locale);                
                    
                    sentFolder = ia.getFolder(egovMessageSource.getMessage("ezEmail.t99000026", locale));
                    sentFolder.open(Folder.READ_WRITE);
                    Message sentMessage = ((IMAPFolder)sentFolder).getMessageByUID(sentFolderMessageUID);
                    sentMessage.setFlag(Flags.Flag.DELETED, true);
                    sentFolder.close(true);
                    sentFolder = null;
                    
                    LOGGER.debug("sentFolderMessageUID message deleted successfully.");
                    
                    result.put("status", "ok");
        			result.put("code", 0);			
        			result.put("data", "");
        			
                } catch (Exception e) {
                	e.printStackTrace();
        			result.put("status", "error");
        			result.put("code", 1);			
        			result.put("data", "");
                    LOGGER.error("Failed to delete sentFolderMessageUID message. sentFolderMessageUID=" + sentFolderMessageUID);
                } finally {
                    if (sentFolder != null) {
                        try {
                            sentFolder.close(true);
                        } catch (Exception e) {}
                        
                        sentFolder = null;
                    }
                    
                    if (ia != null) {
                        ia.close();
                        ia = null;
                    }                    
                }                                           
		    }
//		}
		
		    
		    
		LOGGER.debug("mailInterSend ended. pResult=" + pResult);
		
		result.put("status", "ok");
		result.put("code", 0);			
		result.put("data", "");
		
		} catch (Exception e){
		e.printStackTrace();
		result.put("status", "error");
		result.put("code", 1);			
		result.put("data", "");
		
		}
		
		LOGGER.debug("MOBILE G/W MAIL [POST /ezemail/mail-save/users/{userId}] ended.");
		
		return result;		
	}
	
	/**
	 * 모바일 G/W 이메일 [POST] 메일발송(send)
	 */
	@RequestMapping(value="/mobile/ezemail/mail-send/users/{userId}", method= RequestMethod.POST, produces="application/json;charset=utf-8")
	public Object mMailSend(HttpServletRequest request, @PathVariable String userId, @RequestBody JSONObject jsonObject) {
		LOGGER.debug("MOBILE G/W MAIL [POST /ezemail/mail-send/users/{userId}] started.");
		JSONObject result = new JSONObject();
		
		try{
		boolean retryFlag = false;
		int retryCount = 1; //메일 발송 실패 시 재시도 횟수
		long draftUID = 0;
		long sentFolderMessageUID = 0;
		boolean mailSendCompleted = false;
		
		LOGGER.debug(jsonObject.toJSONString());
		
		String importance = "3";
		
		String subject = "";
		String to = "";
		String cc = "";
		String bcc = "";
		String textBody = "";
		String from = "";
		String charset = "";
		String htmlbody = "";
		String displayName = "";
		String stateName = "";
		String url = "";
		String orgFolderId = "";
		String orgMessageId = "";
		String cmd = "";
		String mailcmd = "";
		String replySendTime = "0";
		String replyReadTime = "1";
		
		if (jsonObject.get("subject") != null) {
			subject = (String) jsonObject.get("subject");
		}
		
		if (jsonObject.get("to") != null) {
			to = (String) jsonObject.get("to");
		}
		
		if (jsonObject.get("cc") != null) {
			cc = (String) jsonObject.get("cc");
		}
		
		if (jsonObject.get("bcc") != null) {
			bcc = (String) jsonObject.get("bcc");
		}
		
		if (jsonObject.get("textbody") != null) {
			textBody = (String) jsonObject.get("textbody");
		}
		
		if (jsonObject.get("from") != null) {
			from = (String) jsonObject.get("from");
		}
		
		if (jsonObject.get("charset") != null) {
			charset = (String) jsonObject.get("charset");
		}
		
		if (jsonObject.get("htmlbody") != null) {
			htmlbody = (String) jsonObject.get("htmlbody");
		}
		
		if (jsonObject.get("displayName") != null) {
			displayName = (String) jsonObject.get("displayName");
		}
		
		if (jsonObject.get("stateName") != null) {
			stateName = (String) jsonObject.get("stateName");
		}
		
		if (jsonObject.get("importance") != null) {
			importance = (String) jsonObject.get("importance");
		}
		
		if (jsonObject.get("url") != null) {
			url = (String) jsonObject.get("url");
		}
		
		if (jsonObject.get("orgFolderId") != null) {
			orgFolderId = (String) jsonObject.get("orgFolderId");
		}
		
		if (jsonObject.get("orgMessageId") != null) {
			orgMessageId = (String) jsonObject.get("orgMessageId");
		}
		
		if (jsonObject.get("cmd") != null) {
			cmd = (String) jsonObject.get("cmd");
		}
		
		if (jsonObject.get("mailcmd") != null) {
			mailcmd = (String) jsonObject.get("mailcmd");
		}
		
//		if (jsonObject.get("replySendTime") != null) {
//			replySendTime = (String) jsonObject.get("replySendTime");
//		}
		
		if (jsonObject.get("replyReadTime") != null) {
			replyReadTime = (String) jsonObject.get("replyReadTime");
		}
		
		String realPath = commonUtil.getRealPath(request);

		LOGGER.debug("subject = " + subject + ", to = " + to + ", cc = " + cc + ", bcc = " + bcc + ", textBody = " 
		+ textBody + ", from = " + from + ", charset = " + charset + ", htmlbody = " + htmlbody + ", htmlbody = " + htmlbody
		+ ", displayName = " + displayName + ", stateName = " + stateName + ", url = " + url + ", cmd" + cmd + ", replyReadTime" + replyReadTime); 
				
		String serverName = request.getHeader("x-user-host");
	
		MCommonVO info = mOptionService.commonInfo(serverName, userId);
		String domainName = ezCommonService.getTenantConfig("DomainName", info.getTenantId());
		String userEmail = info.getUserId() + "@" + domainName;
		String password = jspw;
		
		String ld = commonUtil.getTwoLetterLangFromLangNum(info.getLang());
		Locale locale = new Locale(ld);
		
		MOptionVO opt = mOptionService.optionInfo(userId, info.getTenantId());
		if ( opt.getLang().equals("1") ) {
			locale = new Locale("ko");	
		} else if ( opt.getLang().equals("3") ) {
			locale = new Locale("ja");
		}
		
		SMTPAccess sa = SMTPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.SMTPPort"),
				userEmail, password);
	
		String pResult = null;
		IMAPAccess ia = null;
		
			do {
				try {
					ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
							userEmail, password, egovMessageSource, locale);
					
					//메일 발송 재시도일 경우 draftUID의 메일을 지우고 retryFlag와 draftUID를 초기화한다.
					if (retryFlag) {
						if (draftUID != 0) {
							Folder draftFolder = null;
    					
							try {
								draftFolder = ia.getFolder(egovMessageSource.getMessage("ezEmail.t99000027", locale));
								draftFolder.open(Folder.READ_WRITE);
								Message draftMessage = ((IMAPFolder)draftFolder).getMessageByUID(draftUID);
								draftMessage.setFlag(Flags.Flag.DELETED, true);
								draftFolder.close(true);
								draftFolder = null;
    		        		
								LOGGER.debug("draftUID message deleted successfully during retry.");
							} catch (Exception e) {
								LOGGER.error("Failed to delete draftUID message during retry. draftUID=" + draftUID);
								result.put("status", "error");
			        			result.put("code", 1);			
			        			result.put("data", "");
							} finally {
								if (draftFolder != null) {
									try {
    								draftFolder.close(true);
									} catch (Exception e) {
										result.put("status", "error");
					        			result.put("code", 1);			
					        			result.put("data", "");
									}
									draftFolder = null;
								}
							}
						}
				    
					    // 보낸편지함에 저장된 이후 Exception이 발생하여 Retry하는 경우 보낸편지함에 있는 메시지를 삭제한다.
					    if (sentFolderMessageUID != 0) {
	                        Folder sentFolder = null;
	                        try {
	                            sentFolder = ia.getFolder(egovMessageSource.getMessage("ezEmail.t99000026", locale));
	                            sentFolder.open(Folder.READ_WRITE);
	                            Message sentMessage = ((IMAPFolder)sentFolder).getMessageByUID(sentFolderMessageUID);
	                            sentMessage.setFlag(Flags.Flag.DELETED, true);
	                            sentFolder.close(true);
	                            sentFolder = null;
	                            
	                            LOGGER.debug("sentFolderMessageUID message deleted successfully during retry.");
	                        } catch (Exception e) {
	                            LOGGER.error("Failed to delete sentFolderMessageUID message during retry. sentFolderMessageUID=" + sentFolderMessageUID);
	                            result.put("status", "error");
	                			result.put("code", 1);			
	                			result.put("data", "");
	                        } finally {
	                            if (sentFolder != null) {
	                                try {
	                                    sentFolder.close(true);
	                                } catch (Exception e) {
	                                	result.put("status", "error");
	                        			result.put("code", 1);			
	                        			result.put("data", "");
	                                }
	                                
	                                sentFolder = null;
	                            }
	                        }				        
					    }
						
						retryFlag = false;
						draftUID = 0;
						sentFolderMessageUID = 0;
					}
					
					//편지함 용량 체크
					long[] storageUsageAndLimit = ia.getStorageUsageAndLimit();
					double mailboxUsage = storageUsageAndLimit[0]; // in KBs
					double mailboxQuota = storageUsageAndLimit[1]; // in KBs
					LOGGER.debug("mailboxUsage=" + mailboxUsage + ",mailboxQuota=" + mailboxQuota);
					
					if (mailboxUsage >= mailboxQuota) {
						throw new Exception("OVERQUOTA");
					}
				
					// MIME Message를 생성한다.
					MimeMessage message = sa.createMimeMessage();
					
					// 메일 From,TO,CC,BCC
					InternetAddress internetAddress = new InternetAddress();
					String name = "";
					String address = "";
					
					// From
					LOGGER.debug("from=" + from);
					String pattern = "\"?([^\"]*)\"? <([^<>]+)>";
					Pattern r = Pattern.compile(pattern);
					Matcher m = r.matcher(from);
					
					if (m.find()) {
						name = m.group(1);
						address = m.group(2);
						internetAddress.setPersonal(name, "UTF-8");
						internetAddress.setAddress(address);
						message.setFrom(internetAddress);
					}
				
					// To
					LOGGER.debug("to=" + to);
					m = r.matcher(to);
					while (m.find()) {
						name = m.group(1);
						address = m.group(2);
						internetAddress.setPersonal(name, "UTF-8");
						internetAddress.setAddress(address);
						message.addRecipient(RecipientType.TO, internetAddress);
					}
					
					// Cc
					LOGGER.debug("cc=" + cc);
					m = r.matcher(cc);
					while (m.find()) {
						name = m.group(1);
						address = m.group(2);
						internetAddress.setPersonal(name, "UTF-8");
						internetAddress.setAddress(address);
						message.addRecipient(RecipientType.CC, internetAddress);
					}
					
					// Bcc
					LOGGER.debug("bcc=" + bcc);
					m = r.matcher(bcc);
					while (m.find()) {
						name = m.group(1);
						address = m.group(2);
						internetAddress.setPersonal(name, "UTF-8");
						internetAddress.setAddress(address);
						message.addRecipient(RecipientType.BCC, internetAddress);
					}				
					
					// 메일 제목
					message.setSubject(subject, "UTF-8");
				
//				LOGGER.debug("cmd=" + cmd + ",simpleMime=" + simpleMime);
				
					Multipart alternativePart = null;
		        
					// 메일 본문 및 타입
					MimeBodyPart content = new MimeBodyPart();
				
				// simpleMime의 값이 1인 경우는 Plain Text 형식이다.
//				if (simpleMime.equals("1")) {
				 // 메일을 발송하는 경우
//		            if (!cmd.toUpperCase().equals("SAVE")) {
		                // 예약 메일의 경우
//		                if (!delaySendTime.equals("")) {
//		                	message.setContent(textBody, "text/plain; charset=utf-8");
//		                	content.setContent(textBody, "text/plain; charset=utf-8");
//		                // 지금 발송하는 경우
//		                } else {
//		           	message.setContent(textBody.replaceAll("div id=\"MailSign\"", "div id=\"MailSignSent\""), "text/plain; charset=utf-8");
//		           	content.setContent(textBody.replaceAll("div id=\"MailSign\"", "div id=\"MailSignSent\""), "text/plain; charset=utf-8");
//		                }
		             // 임시 보관함에 저장하는 경우    
//		            } else {
//		            	message.setContent(textBody, "text/plain; charset=utf-8");
//		            	content.setContent(textBody, "text/plain; charset=utf-8");
//		            }
		        // HTML 형식의 경우
//		        } else {
//		            // 메일을 발송하는 경우
//		            if (!cmd.toUpperCase().equals("SAVE")) {
//		                // 예약 메일의 경우
//		                if (!delaySendTime.equals("")) {
//		                	message.setContent(htmlBody, "text/html; charset=utf-8");
		                	content.setContent(textBody, "text/html; charset=utf-8");
//		                // 지금 발송하는 경우
//		                } else {
//		                	message.setContent(htmlBody.replaceAll("div id=\"MailSign\"", "div id=\"MailSignSent\""), "text/html; charset=utf-8");
//		                	content.setContent(htmlBody.replaceAll("div id=\"MailSign\"", "div id=\"MailSignSent\""), "text/html; charset=utf-8");
//		                }
//		            // 임시 보관함에 저장하는 경우
//		            } else {
//		            	message.setContent(htmlBody, "text/html; charset=utf-8");
//		            	content.setContent(htmlBody, "text/html; charset=utf-8");
//		            }
//		
//		            // multipart/alternative로 구성한다.
	                alternativePart = new MimeMultipart("alternative");
//		            
//	                // text/plain 파트를 구성한다.
		            MimeBodyPart textPlainPart = new MimeBodyPart();
		            textPlainPart.setText(textBody, "utf-8");	
//		            
//		            // text/plain 파트를 추가한다.
		            alternativePart.addBodyPart(textPlainPart);
//		            // text/html 파트를 추가한다. content가 text/html 파트를 갖고 있다.
		            alternativePart.addBodyPart(content);
//		            
		            message.setContent(alternativePart);
//		        }
				
				// 보안메일
//				if (pSecurityMail.equals("3")) {
//					message.setHeader("Sensitivity", "company-confidential");
//		        }
				
				// 메일 중요도
				switch (importance) { // 2: High, 1: Normal, 0: Low
		            case "0": message.setHeader("X-Priority", "5");
		                break;
		            case "1": message.setHeader("X-Priority", "3");
		                break;
		            case "2": message.setHeader("X-Priority", "1");
		                break;
		            default: message.setHeader("X-Priority", "3");
		                break;
		        }
				
//				// 추적(배달되면 알림)
//				LOGGER.debug("replySendTime=" + replySendTime);
//		        if (replySendTime.equals("1")) {
//		        	message.setHeader("Return-Receipt-To", ((InternetAddress)message.getFrom()[0]).getAddress());
//		        }
//		
//		        // 추적(수신확인)
		        LOGGER.debug("replyReadTime=" + replyReadTime);
		        if (replyReadTime.equals("1")) {
		        	message.setHeader("Disposition-Notification-To", ((InternetAddress)message.getFrom()[0]).getAddress());
		        }
		        
//		        SentDate 설정
		        message.setSentDate(Calendar.getInstance().getTime());
//		        
//		        User-Agent 설정
		        message.setHeader("User-Agent", "JMocha Mail 1.0");	        
//		        
//		        //inline image 처리
		        MimeMultipart relatedPart = null;
		        Set<String> contentIdSet = new HashSet<String>();
//		        
//		        // simpleMime의 값이 1인 아닌 경우는 HTML 형식이다.
//		        if (!simpleMime.equals("1")) {
//		        	// getElementsByTagName always returns non-null object even if
//		        	// the tag doesn't exist, so its length must be checked.
//		        	NodeList imageNameList = root.getElementsByTagName("IMAGENAME");
//		        	NodeList imagePathList = root.getElementsByTagName("IMAGEPATH");
//		        	
//		        	// 새롭게 추가된 이미지가 있으면 이미지를 파트로 추가하고 Related Part로 구성한다.
//			        if (imageNameList != null && imageNameList.getLength() > 0
//			        		&& imagePathList != null && imagePathList.getLength() > 0) {
//			        	String imageName = "";
//			            String imagePath = "";
//			        	
//			            // Related Part를 생성한다.
//			            relatedPart = new MimeMultipart("related");
//			            
//			        	for (int i=0; true; i++) {
//			            	if (imageNameList.item(i) == null || imagePathList.item(i) == null) {
//			            		break;
//			            	}
//			            	
//			            	imageName = imageNameList.item(i).getTextContent();
//			            	imagePath = imagePathList.item(i).getTextContent();
//			            	
//			            	if (!imageName.trim().equals("") && !imagePath.trim().equals("")) {
//			            	    // 이미지 파일의 Path를 구한다.
//			                	imagePath = new URL(imagePath).getPath();
//			                	String pDirPath = realPath + imagePath;
//			                	
//			        	        File f = new File(pDirPath);
//			        	        
//			        	        if (f.exists()) {	            		
//			        	            // 본문 내용에 있는 image tag의 src 속성의 값을 content id 형식으로 변경한다.
//				                	String cid = imageName + "@12345678.87654321";
//				                	String strContent = content.getContent().toString();
//				                	int index = strContent.indexOf("src=\"" + imageName);
//				                	if (index != -1) {
//				                		strContent = strContent.replace("src=\"" + imageName, "src=\"cid:" + cid);
//				                	}
//				                	content.setContent(strContent, "text/html; charset=utf-8");
//			                		        	        
//				                	// 이미지 파일을 추가할 Mime Body Part를 생성한다.
//				                	MimeBodyPart messageBodyPart = new MimeBodyPart();
//				                	
//				        	        FileDataSource source = new FileDataSource(f);
//				        	        messageBodyPart.setDataHandler(new DataHandler(source));
//				        	        messageBodyPart.setFileName(imageName);
//				        	        
//				        	        // 이미지 파일의 Default Content-Type은 application/octet-stream 로 설정한다.
//				        	        String contentType = "application/octet-stream";
//				        	        
//				        	        // 이미지 파일의 Content-Type을 구한다.
//				        	        if (Files.probeContentType(f.toPath()) != null) {
//				        	        	contentType = Files.probeContentType(f.toPath());
//				        	        }
//				        	        
//				        	        messageBodyPart.setHeader("Content-Type", contentType);
//				        	        String cidWithBrackets = "<" + cid + ">";
//				        	        messageBodyPart.setContentID(cidWithBrackets);
//				        	        messageBodyPart.setDisposition(Part.INLINE);
//				        	        
//				        	        contentIdSet.add(cidWithBrackets);
//				        	        LOGGER.debug("cidWithBrackets=" + cidWithBrackets);
//				        	        
//				        	        // Related Part에 이미지 Part를 추가한다.
//				        	        relatedPart.addBodyPart(messageBodyPart);
//			        	        }
//			                }
//			            }
//			        	
//			        	// Related Part의 첫 부분에 본문 Part를 삽입한다.
//			        	relatedPart.addBodyPart(content, 0);
//			        	
//			        	// Alternative의 두 번째 파트에 기존 HTML 파트를 제거하고 Related Part를 삽입한다.
//			        	alternativePart.removeBodyPart(1);
//	                    MimeBodyPart wrap = new MimeBodyPart();
//	                    wrap.setContent(relatedPart);
//			        	alternativePart.addBodyPart(wrap, 1);
//			        	
//			        	message.setContent(alternativePart);
//					}
//		        }
		        
	            // 임시 보관함에 메시지가 있는 경우 해당 메시지와 병합 작업을 수행한다.
		        Message oldMessage = null;
		        long uid = 0;
		        
		        Folder draftFolder = ia.getFolder(egovMessageSource.getMessage("ezEmail.t99000027", locale));
		        draftFolder.open(Folder.READ_WRITE);
		        
		        LOGGER.debug("url=" + url);
		        
		        if (!url.trim().equals("") || !orgMessageId.trim().equals("")) {
		        	if (!url.trim().equals("")){
		        		uid = Long.parseLong(url);
		        	} else if (!orgMessageId.trim().equals("")){
		        		uid = Long.parseLong(orgMessageId);
		        	}
		        	
		        	MimeMultipart mixedPart = new MimeMultipart();
					
					if (uid != 0) {
					    // 임시 보관함에 있는 기존 메시지를 불러온다.
						oldMessage = ((IMAPFolder)draftFolder).getMessageByUID(uid);
						
						if (oldMessage != null) {
							// copy existing headers that are needed.
							String[] headers = oldMessage.getHeader("References");
							
							if (headers != null) {
								message.setHeader("References", headers[0]);
							}
							
							headers = oldMessage.getHeader("In-Reply-To");
							if (headers != null) {
								message.setHeader("In-Reply-To", headers[0]);
							}
							
							// 기존 메시지가 Multipart 메시지일 경우의 처리
							if (oldMessage.getContent() instanceof Multipart) {
							    // 기존 메시지의 Multipart를 불러온다.
								Multipart mp = (Multipart)oldMessage.getContent();
								int count = mp.getCount();
								BodyPart p = null;
								boolean hasAttach = false;
								
								// Multipart의 각 Part별 처리를 수행한다.
								for (int i = 0; i < count; i++) {
									p = mp.getBodyPart(i);
									
									while (true) {
									    // Part가 Related Part일 경우의 처리
//	    								if (alternativePart != null && p.isMimeType("multipart/related")) {
//	    								    LOGGER.debug("Part is multipart/related");
//	    								    
//	    									hasAttach = true;
//	    									
//	    									LOGGER.debug("relatedPart=" + relatedPart);
//	    									
//	    									if (relatedPart == null) {
//	    										relatedPart = new MimeMultipart("related");
//	    										    							
//	    					                    MimeBodyPart wrap = new MimeBodyPart();
//	    					                    wrap.setContent(relatedPart);
//	    					                    alternativePart.removeBodyPart(1);
//	    					                    alternativePart.addBodyPart(wrap, 1);
//	    									}
//	    									// new related part is already created by the above routine
//	    									// for adding new in-line images.
//	    									else {
//	    										relatedPart.removeBodyPart(0);
//	    									}
//	    									
//	    									// 기존 메시지의 Related Part와 병합한다.
//	    									Multipart existingRelatedPart = (Multipart)p.getContent();
//	    									int existingRelatedPartCount = existingRelatedPart.getCount();
//	    									BodyPart existingRelatedSubPart = null;
//	    									
//	    									for (int j = 0; j < existingRelatedPartCount; j++) {
//	    									    existingRelatedSubPart = existingRelatedPart.getBodyPart(j);
//	    										
//	    										if (existingRelatedSubPart instanceof MimePart) {
//	    										    String contentId = ((MimePart)existingRelatedSubPart).getContentID();
//	    										    LOGGER.debug("Existing ContentId=" + contentId);
//	    										    
//	    											if (contentId != null && !contentIdSet.contains(contentId)) {
//	    											    LOGGER.debug("Adding ContentId=" + contentId);
//	    											    
//	    												relatedPart.addBodyPart(existingRelatedSubPart);						
//	    											}
//	    										}				
//	    									}
//	    									
//	    									String bodyContent = content.getContent().toString();
//	    									bodyContent = convertDownloadInlineImageURLtoCid(bodyContent);							
//	    									content.setContent(bodyContent, "text/html; charset=utf-8");
//	    									relatedPart.addBodyPart(content, 0);
//	    									
//	    									removeUnusedInlineImagePart(relatedPart);
//	    								}
	    								// Part가 Alternative Part일 경우의 처리
//	    							else if (alternativePart != null && p.isMimeType("multipart/alternative")) {
//	    								    LOGGER.debug("Part is multipart/alternative");
//	    								    
//	    								    hasAttach = true;
//	    								    
//	                                        Multipart existingAlternativePart = (Multipart)p.getContent();
//	                                        int existingAlternativePartCount = existingAlternativePart.getCount();
//	                                        BodyPart existingAlternativeSubPart = null;
//	                                        boolean isRelatedFound = false;
//	                                        
//	                                        for (int j = 0; j < existingAlternativePartCount; j++) {
//	                                            existingAlternativeSubPart = existingAlternativePart.getBodyPart(j);
//	                                            
//	                                            if (existingAlternativeSubPart instanceof MimePart) {
//	                                                // Alternative Part 안에 Related Part가 있는 경우에 대한 처리
//	                                                if (existingAlternativeSubPart.isMimeType("multipart/related")) {
//	                                                    isRelatedFound = true;
//	                                                    break;
//	                                                }
//	                                            }               
//	                                        }						
//	                                        
//	                                        if (isRelatedFound) {
//	                                            // p를 발견된 related 파트로 변경하여 루프의 시작 부분에 있는 related 파트 처리 부분으로 제어를 옮긴다.
//	                                            p = existingAlternativeSubPart;
//	                                            continue;
//	                                        }
//	                                    }								
	                                    // there are cases where an in-line image part doesn't have
	                                    // a Content-Disposition header, but has a Content-ID header.    								
//	    								if (p instanceof MimePart 
//	    								        && ((MimePart)p).getContentID() != null) {
//	    								    String contentId = ((MimePart)p).getContentID();
//	    								    LOGGER.debug("Existing ContentId=" + contentId);
//	    								    
//	    								    if (!contentIdSet.contains(contentId)) {
//	    								        LOGGER.debug("Adding ContentId=" + contentId);
//	    								        
//	    								        mixedPart.addBodyPart(p);
//	    								    }
//	    								}
	    								// Content-Disposition 헤더가 없이 첨부된 파일이 있어
	    								// Content-Type이 application으로 시작하는 경우도 추가함 
	    								// 예) Content-Type: application/octet-stream;
	    								//         name="=?utf-8?B?NDExMDAwODE1OS5QREY=?="
	    							    //    Content-Transfer-Encoding: base64	    								
	    								if (p.getDisposition() != null || p.isMimeType("application/*")) { 
	    									mixedPart.addBodyPart(p);
	    									
	    									// 첨부파일 파트인 경우
	    									if ((p.getDisposition() != null && p.getDisposition().equalsIgnoreCase(Part.ATTACHMENT))
	    											|| p.isMimeType("application/*")) {
	    										hasAttach = true;
	    									}
	    								}
	    								// Part가 message 인 경우, 즉 메일이 첨부된 경우
	    								else if (p.isMimeType("message/*")) {
	    								    LOGGER.debug("Part is message");
	    								    
	    									mixedPart.addBodyPart(p);
	    									hasAttach = true;
	    								}							
	    								
	    								break;
									}
								}
								
								// 기존 메시지에 첨부파일이 있거나 Alternative Part 혹은 Related Part가 있는 경우의 처리
								if (hasAttach) {
									if (alternativePart != null) {
										MimeBodyPart wrap = new MimeBodyPart();
										wrap.setContent(alternativePart);
										mixedPart.addBodyPart(wrap, 0);
									} else {
										mixedPart.addBodyPart(content, 0);
									}							
									
									message.setContent(mixedPart);							
								}
								// 기존 메시지가 Related Part일 경우의 처리
//								else if (oldMessage.isMimeType("multipart/related")) {
//								    LOGGER.debug("oldMessage is multipart/related");
//									LOGGER.debug("relatedPart=" + relatedPart);
//									
//	                                if (alternativePart != null) {								
//	    								// 새로 추가되는 이미지 파트들을 추가한다.
//	    								// 기존 메시지의 이미지 파트들은 위에서 이미 mixedPart에 추가되어 있다.
//	    								// a new related part is already created by the above routine
//	    								// for adding new in-line images.						
//	    								if (relatedPart != null) {
//	    									relatedPart.removeBodyPart(0);
//	    									
//	    									BodyPart relatedSubPart = null;
//	    									for (int i = 0; i < relatedPart.getCount(); i++) {
//	    										relatedSubPart = relatedPart.getBodyPart(i);
//	    										mixedPart.addBodyPart(relatedSubPart);
//	    									}
//	    								}
//	    								
//	    								// 기존 메시지가 Related Part인 경우는 첨부파일이 없는 경우이므로 mixed가 아니다.
//	    								// this mixedPart is actually a related part.
//	    								mixedPart.setSubType("related");
//	    								
//	    								String bodyContent = content.getContent().toString();																
//	                                    bodyContent = convertDownloadInlineImageURLtoCid(bodyContent);                          
//	                                    content.setContent(bodyContent, "text/html; charset=utf-8");                            
//	                                    mixedPart.addBodyPart(content, 0);
//	                                    
//	                                    removeUnusedInlineImagePart(mixedPart);
//	                                                                        
//	                                    MimeBodyPart wrap = new MimeBodyPart();
//	                                    wrap.setContent(mixedPart);
//	                                    alternativePart.removeBodyPart(1);
//	                                    alternativePart.addBodyPart(wrap, 1);                                                                               
//	                                } 
//								}
							}					
						}
					}
		        }        
		        
		        //mailboxUsage + messageSize >= mailboxQuota인 경우 OVERQUOTA Exception
		        CountOutputStream cos = null;
		        double messageSize = 0;
		        
		        try {
		        	cos = new CountOutputStream();
		        	message.writeTo(cos);
		        	messageSize = cos.getSize() / 1024.0;
		        } catch(Exception e) {
		        	e.printStackTrace();
		        	result.put("status", "error");
        			result.put("code", 1);			
        			result.put("data", "");
		        } finally {
		        	try { 
		        		cos.close(); 
		        	} catch (Exception e) {
		        	result.put("status", "error");
        			result.put("code", 1);			
        			result.put("data", "");
        			}
		        }
		        
		        LOGGER.debug("mailboxUsage=" + mailboxUsage + ", messageSize=" + messageSize + ", mailboxQuota=" + mailboxQuota);
		        
		        if (mailboxUsage + messageSize >= mailboxQuota) {
					throw new Exception("OVERQUOTA");
				}
		        
		        //messageSize가 maxMessageSize 넘을 경우 OVERMESSAGESIZE Exception
		        int maxMessageSize = ezEmailService.getMaxMessageSize(info.getTenantId());
		        
		        if (maxMessageSize > 0 && messageSize > maxMessageSize) {
		        	double maxMessageSizeD = maxMessageSize / 1024.0;
		        	maxMessageSizeD = Math.round(maxMessageSizeD * 10) / 10;
		        	
		        	double messageSizeD = messageSize / 1024.0;
		        	messageSizeD = Math.round(messageSizeD * 10) / 10;
		        	
		        	throw new Exception("OVERMESSAGESIZE:" + maxMessageSizeD + "MB:" + messageSizeD + "MB");
		        }
		        
		        if (cmd.equalsIgnoreCase("SAVE")) {
		        	LOGGER.debug("Saving the message");
		        	
//		    		Boolean isEachMailB = Boolean.parseBoolean(isEachMail.trim());
		    		
//		    		if (isEachMailB) {
//	                	message.setHeader("X-JMocha-Each-Mail", "true");
//                    }
//		    		if (delaySendTime != ""){
//		    			message.setHeader("Delivery-Date", delaySendTime);
//		    		}
		    		message.setFlag(Flags.Flag.SEEN, true);
		    		AppendUID[] uids = ((IMAPFolder)draftFolder).appendUIDMessages(new Message[]{message});
		    		if (uids != null && uids[0] != null) {
		    			draftUID = uids[0].uid;
		    		} 
		    	
		            // this deletion code block has been moved here because
		            // it needs to be kept in Drafts if an error occurs during the above process.
		            if (oldMessage != null) {
		            	oldMessage.setFlag(Flags.Flag.DELETED, true);
		            }
		        
		        } else if (cmd.equalsIgnoreCase("SEND")) {
		        	LOGGER.debug("Sending the message");
		        	
                    Folder sentFolder = ia.getFolder(egovMessageSource.getMessage("ezEmail.t99000026", locale));
                    		        
//					String strCheckReadUrl = ""; //외부메일수신확인 관련 URL. GetSystemConfigValue("APPREADCHECK_URL").ToString();
//			        Boolean isEachMailB = Boolean.parseBoolean(isEachMail.trim());
			        
//			        if (!displayName.equals("")) {
//		            	message.setHeader("X-JMocha-EXT-SENDERNAME", MimeUtility.encodeText(displayName, "UTF-8", null));
//		            }
			                            
                    message.setFlag(Flags.Flag.SEEN, true);
		            
                    // 예약 발송의 경우는 지원하지 않기 때문에 false로 고정해 놓았다.
                    if (false) {
//			        if (!delaySendTime.equals("")) {
//			            // 편지함 용량 초과 메세지 확인을 위해 임시저장
//	                    AppendUID[] uids = ((IMAPFolder)draftFolder).appendUIDMessages(new Message[]{message});
//	                    if (uids != null && uids[0] != null) {
//	                        draftUID = uids[0].uid;
//	                    } 
//			            
//	                    // 개별발신
//	                    if (isEachMailB) {
//		                	message.setHeader("X-JMocha-Each-Mail", "true");
//	                    }
//	                    
//			        	//예약발송
//			        	String delaySendTimeUTC = commonUtil.getDateStringInUTC(delaySendTime, userInfo.getOffset(), true);
//			            doDelaySend(userInfo.getTenantId(), message, isReserve, reservedId, subject, delaySendTimeUTC, userId, realPath);
//			        				            
//			            //임시보관함에서 삭제
//			            Message draftMessage = ((IMAPFolder)draftFolder).getMessageByUID(draftUID);
//		        		draftMessage.setFlag(Flags.Flag.DELETED, true);
//		        		
//                        // this deletion code block has been moved here because
//                        // it needs to be kept in Drafts if an error occurs during the above process.
//                        if (oldMessage != null) {
//                            oldMessage.setFlag(Flags.Flag.DELETED, true);
//                        }		        		
//		        	// 즉시 발송의 경우	
			        } else {         
			            // mailSendCompleted가 true인 경우는 메일 전송까지 완료된 이후에 Exception이 발생하여 Retry하는 경우이다.
			            // 이 경우에는 이미 보낸편지함에 저장된 메일이 있으므로 보낸편지함에 다시 저장하지 않는다.
			            if (mailSendCompleted == false) {
    			            // 편지함 용량 초과 메세지 확인을 위해 임시저장
    	                    // 본래는 임시보관함에 미리 저장해두고 성공했을 시 임시보관함에 있는 메일을 보낸메일함으로 복사하였으나
    			            // 보낸메일함에 바로 저장하는 것으로 변경함.
    	                    AppendUID[] uids = ((IMAPFolder)sentFolder).appendUIDMessages(new Message[]{message});
    	                    if (uids != null && uids[0] != null) {
    	                        sentFolderMessageUID = uids[0].uid;
    	                    } 
			            }
			            
//			            STRING[] EACHMAILHEADERS = MESSAGE.GETHEADER("X-JMOCHA-EACH-MAIL");
//						STRING EACHMAILHEADER = EACHMAILHEADERS != NULL ? EACHMAILHEADERS[0] : NULL;		
//						
//						IF (EACHMAILHEADER != NULL) {
//							MESSAGE.REMOVEHEADER("X-JMOCHA-EACH-MAIL");
//						}
			            
			            // 개별발신
//			            if (isEachMailB) {
//			            	LOGGER.debug("sending each recipient mail");
//			            	
//			                // mailSendCompleted가 true인 경우는 Transport.send가 완료된 이후에 예외가 발생하여 Retry하는 경우이다.
//			                // 이 경우에는 메일을 다시 전송하지 않는다.
//			                if (mailSendCompleted == false) {			     			                	
//				            	Address[] allRecipients = message.getAllRecipients();
//				            	
//				            	message.removeHeader("TO");
//				        		message.removeHeader("CC");
//				        		message.removeHeader("BCC");
//				        		
//				            	for (Address a : allRecipients) {
//				            		LOGGER.debug("address=" + a);
//				            		
//				            		message.setRecipient(RecipientType.TO, a);
//				            		
//				            		Transport.send(message);
//				            		
//	    			            	sentFolderMessageUID = 0;
//	    			            	mailSendCompleted = true;				            		
//				            	}
//			                }
//			            	
//			                // this deletion code block has been moved here because
//			                // it needs to be kept in Drafts if an error occurs during the above process.
			                if (oldMessage != null) {
			                	oldMessage.setFlag(Flags.Flag.DELETED, true);
			                }
//			            } else {
			                // mailSendCompleted가 true인 경우는 Transport.send가 완료된 이후에 예외가 발생하여 Retry하는 경우이다.
			                // 이 경우에는 메일을 다시 전송하지 않는다.
			                if (mailSendCompleted == false) {
			                	Transport.send(message);
    			            	sentFolderMessageUID = 0;
    			            	mailSendCompleted = true;
			                }
			            				                	            				        		
                            // this deletion code block has been moved here because
                            // it needs to be kept in Drafts if an error occurs during the above process.
//                            if (oldMessage != null) {
//                                oldMessage.setFlag(Flags.Flag.DELETED, true);
//                            }			        		
//			            }
			            			            
			            //예악발송 수정 시 옵션에서 예약발송 안하고 저장했을 시 DB 데이터 삭제, 파일 시스템의 eml파일 삭제
//			            LOGGER.debug("reservedId=" + reservedId);
//			            if (reservedId != null && !reservedId.trim().equals("")) {
//							ezEmailService.deleteMailReserved(reservedId);
//			            	
//							String pDirPath = commonUtil.getUploadPath("upload_mail.RESERVED_MAIL_PATH", userInfo.getTenantId());
//				    		pDirPath = realPath + pDirPath;
//				            File f = new File(pDirPath + commonUtil.separator + reservedId + ".eml");
//							if (f.exists()) {
//								f.delete();
//							}
//			            }
			            
			            // set the ANSWERED flag of the original message to indicate it has been replied.
			            if (mailcmd.equals("REPLY") || mailcmd.equals("REPLYALL") || mailcmd.equals("FORWARD")) {
//			    			int index = orgUrl.lastIndexOf("/");			
			    			
//			    			if (index != -1) {
			    				String orgMsgFolderPath = orgFolderId;
			    				long orgMsgUid = Long.parseLong(orgMessageId);
		
			    				LOGGER.debug("orgMsgFolderPath=" + orgMsgFolderPath + ",orgMsgUid=" + orgMsgUid);
			    				
			    		        Folder orgMsgFolder = ia.getFolder(orgMsgFolderPath);
			    		        orgMsgFolder.open(Folder.READ_WRITE);
			    				
			    		        Message orgMessage = ((IMAPFolder)orgMsgFolder).getMessageByUID(orgMsgUid);
		    		        	
			    		        if (mailcmd.equals("REPLY") || mailcmd.equals("REPLYALL")) {
			    		        	orgMessage.setFlag(Flags.Flag.ANSWERED, true);
			    		        	ezEmailUtil.setForwardedFlag(orgMessage, false);
			    		        }
			    		        else {
			    		        	ezEmailUtil.setForwardedFlag(orgMessage, true);
			    		        	orgMessage.setFlag(Flags.Flag.ANSWERED, false);
			    		        }
			    		        
			    		        orgMsgFolder.close(true);
//			    			}
			            }
			            
			        }
			        
			        //file system의 templist txt파일 삭제
			        String pDirPath = realPath + commonUtil.getUploadPath("upload_mail.ROOT", info.getTenantId()) + commonUtil.separator + "templist";
			        pDirPath += commonUtil.separator + stateName + ".txt";
			        File f = new File(pDirPath);
			        if (f.exists()) {
			        	f.delete();
			        }
			        
		        }
		        
		        // file system의 inline image 파일 삭제 - 경로가 upload_common인 파일만 삭제
		        // 발송의 경우에만 삭제하고 저장의 경우에는 쓰기 창이 계속 표시되어 있는 상태이므로 삭제하지 않고 유지한다.
		        // 남아있는 이미지 파일들은 스케쥴러에 의해 삭제되어야 함.
//		        if (cmd.equalsIgnoreCase("SEND")) {
//	    	        NodeList imagePathList = root.getElementsByTagName("IMAGEPATH");
//	    	        if (imagePathList != null && imagePathList.getLength() > 0) {
//	    	            String imagePath = "";
//	    	            
//	    	        	for (int i=0; true; i++) {
//	    	            	if (imagePathList.item(i) == null) {
//	    	            		break;
//	    	            	}
//	    	            	
//	    	            	imagePath = imagePathList.item(i).getTextContent();
//	    	            	
//	    	            	if (!imagePath.trim().equals("") && imagePath.contains(commonUtil.getUploadPath("upload_common.ROOT", userInfo.getTenantId()))) {
//	    	                	imagePath = new URL(imagePath).getPath();
//	    	                	String pDirPath = realPath + imagePath;
//	    	            		File f = new File(pDirPath);
//	    	            		if (f.exists()) {
//	    	            			f.delete();
//	    	            		}
//	    	            	}
//	    	        	}
//	    	        }
//		        }
		        
		        draftFolder.close(true);
		        
		        pResult = "<RESULT>OK</RESULT>";
		        pResult += "<MESSAGEID><![CDATA[" + draftUID + "]]></MESSAGEID>";
	        
			} catch (Exception e) {
				e.printStackTrace();
				if (e.getMessage().indexOf("OVERQUOTA") > -1 && e.getMessage().indexOf("OVERMESSAGESIZE") > -1) {
					LOGGER.error("mailInterSend : " + e.getMessage());
					pResult = e.getMessage();
				} else if (e.getMessage().indexOf("Invalid Addresses") > -1) {
					pResult = e.getMessage();
					String cause = e.getCause().toString();
					
					String pattern = "Unknown user: ([\\S]+)";
					Pattern r = Pattern.compile(pattern);
					Matcher m = r.matcher(cause);
					pResult = "Invalid Addresses:";
					
					int index = 1000;
					while (m.find()) {
						// 1000번 이상 반복되면 break한다.
						--index;
						if (index < 0) {
							LOGGER.error("Stop finding invalid addresses, because over 1000 times.");
							break;
						}
						
						pResult += m.group(1) + "|";
					}
					
					pResult = pResult.substring(0, pResult.length() - 1);
					result.put("status", "error");
	    			result.put("code", 1);			
	    			result.put("data", pResult);
				} else { // retry
					e.printStackTrace();
					
					retryFlag = true;
					--retryCount;
					
					if (retryCount > -1) {
						LOGGER.debug("Message send fail. Retry...");
						
						try {
							Thread.sleep(1000);
						} catch (Exception ex) {}
					} else {
						//더이상 retry를 하지 않으므로 리턴 메시지를 세팅한다.
						pResult = e.getMessage();
					}
				}
				
				return result;
			} finally {
				if (ia != null) {
					ia.close();
					ia = null;
				}
			}
			
		} while (retryFlag && retryCount > -1);
		
		// 즉시 발송의 경우
//		if (cmd.equalsIgnoreCase("SEND") && delaySendTime.equals("")) {
		    // 보낸편지함에 메일이 저장되었지만 메일 전송이 성공하지 못했다면 해당 메일을 삭제한다.
		    if (mailSendCompleted == false && sentFolderMessageUID != 0) {
                Folder sentFolder = null;
                        
                try {
                    Thread.sleep(1000);
                    
                    ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
                            userEmail, password, egovMessageSource, locale);                
                    
                    sentFolder = ia.getFolder(egovMessageSource.getMessage("ezEmail.t99000026", locale));
                    sentFolder.open(Folder.READ_WRITE);
                    Message sentMessage = ((IMAPFolder)sentFolder).getMessageByUID(sentFolderMessageUID);
                    sentMessage.setFlag(Flags.Flag.DELETED, true);
                    sentFolder.close(true);
                    sentFolder = null;
                    
                    LOGGER.debug("sentFolderMessageUID message deleted successfully.");
                    
                    result.put("status", "ok");
        			result.put("code", 0);			
        			result.put("data", "");
        			
                } catch (Exception e) {
                	e.printStackTrace();
        			result.put("status", "error");
        			result.put("code", 1);			
        			result.put("data", "");
                    LOGGER.error("Failed to delete sentFolderMessageUID message. sentFolderMessageUID=" + sentFolderMessageUID);
                } finally {
                    if (sentFolder != null) {
                        try {
                            sentFolder.close(true);
                        } catch (Exception e) {}
                        
                        sentFolder = null;
                    }
                    
                    if (ia != null) {
                        ia.close();
                        ia = null;
                    }                    
                }                                           
		    }
//		}
		
		    
		    
		LOGGER.debug("mailInterSend ended. pResult=" + pResult);
		
		result.put("status", "ok");
		result.put("code", 0);			
		result.put("data", "");
		
		} catch (Exception e){
		e.printStackTrace();
		result.put("status", "error");
		result.put("code", 1);			
		result.put("data", "");
		
		}
		
		LOGGER.debug("MOBILE G/W MAIL [POST /ezemail/mail-send/users/{userId}] ended.");
		
		return result;
	}
	
	/**
	 * 모바일 G/W 이메일 [GET] 메일 읽기
	 */
	@RequestMapping(value="/mobile/ezemail/folders/{folderId}/mails/{messageId}/users/{userId}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public Object mMailRead(HttpServletRequest request, @PathVariable String folderId, @PathVariable String messageId, @PathVariable String userId) throws Exception {
		LOGGER.debug("MOBILE G/W MAIL [GET /ezemail/folders/{folderId}/mails/{messageId}/users/{userId}] started.");
				
		JSONObject result = new JSONObject();
		JSONObject mail = new JSONObject();
		IMAPAccess ia = null;
		
		try {
		
		folderId = URLDecoder.decode(folderId, "UTF-8");
		
		// get user credentials
		String serverName = request.getHeader("x-user-host");
		MCommonVO info = mOptionService.commonInfo(serverName, userId);
		String domainName = ezCommonService.getTenantConfig("DomainName", info.getTenantId());
		String userEmail = info.getUserId() + "@" + domainName;
		String password = jspw;
		
		String ld = commonUtil.getTwoLetterLangFromLangNum(info.getLang());
		Locale locale = new Locale(ld);
		
		MOptionVO opt = mOptionService.optionInfo(userId, info.getTenantId());
		if ( opt.getLang().equals("1") ) {
			locale = new Locale("ko");	
		} else if ( opt.getLang().equals("3") ) {
			locale = new Locale("ja");
		}

		String pAttachListHtmlSub = null;
		
		List<String> bodyInfoList = null;
		
		LOGGER.debug("userEmail=" + userEmail);
		
		// retrieve the passed in parameters
		
		long uid = Long.parseLong(messageId);
		
		String pnFlag = "N";
//		if (jsonobject.get("PNFlag") != null) {
//			pnFlag = (String) jsonobject.get("PNFlag");
//		}
		
//		String contentClass = (String) jsonobject.get("CONTENTCLASS");

		Address[] arrFroms = null;
		Address[] arrRecipientsTo = null;
		Address[] arrRecipientsCC = null;
		Address[] arrRecipientsBCC = null;
		Date date = null;
		String fromStr = null;
		String fromEmail = null;
		String toStr = null;
		String toHiddenStr = null;
		String toMobileStr = "";
		String ccStr = null;
		String ccHiddenStr = null;
		String ccMobileStr = "";
		String bccStr = "";
		String bccMobileStr = "";
		String subject = null;
		String dateStr = null;
		String title = null;
		String pReadFlag = "Y";
		String isDelete = "BMOVE";
		boolean isSentItems = false;
		String pIsCCFg = "Y";
		String flagged = "0";
		
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userEmail, password, egovMessageSource, locale);
			Folder f = ia.getFolder(folderId);
			
			if (f == null || !f.exists()) {
				LOGGER.error("Folder not found. folderPath=" + folderId);
			} else {
				f.open(Folder.READ_WRITE);
				LOGGER.error(" folderId = " + folderId + " uid = " + uid);
				Message message = null;
				if(f.isOpen() && f instanceof IMAPFolder){
					message = ((IMAPFolder)f).getMessageByUID(uid);
				}
				
				if (message == null) {
					//to-do 메일이 없습니다. 와 같은 문구를  보내주고 싶은데 아마 메일이 있는지 체크하는 메소드를 다시 만들어야 할 거 같다.
					LOGGER.error("Message not found. uid=" + uid);
					result.put("status", "ok");
					result.put("code", 0);			
					result.put("data", "");
					
					return result;
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
					
					LOGGER.debug("From=" + fromStr);
					
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
							
							LOGGER.debug("TO=" + name + ((InternetAddress)arrRecipientsTo[i]).getAddress());
							
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
							if ( i == arrRecipientsTo.length - 1 ) {
								toMobileStr +=  getMobileReceiverHTML(name, ((InternetAddress)arrRecipientsTo[i]).getAddress());
							} else {
								toMobileStr +=  getMobileReceiverHTML(name, ((InternetAddress)arrRecipientsTo[i]).getAddress()) + "&nbsp;,&nbsp;";
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
							
							LOGGER.debug("CC=" + name + ((InternetAddress)arrRecipientsCC[i]).getAddress());
							
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
							if ( i == arrRecipientsCC.length - 1 ) {
								ccMobileStr +=  getMobileReceiverHTML(name, ((InternetAddress)arrRecipientsCC[i]).getAddress());
							} else {
								ccMobileStr +=  getMobileReceiverHTML(name, ((InternetAddress)arrRecipientsCC[i]).getAddress()) + "&nbsp;,&nbsp;";
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
							
							LOGGER.debug("BCC=" + name + ((InternetAddress)arrRecipientsBCC[i]).getAddress());
							
							if (i != 0) {
								bccStr += ", ";
							}
							bccStr += getReceiverHTML(name, ((InternetAddress)arrRecipientsBCC[i]).getAddress());
							
							if ( i == arrRecipientsBCC.length - 1 ) {
								bccMobileStr +=  getMobileReceiverHTML(name, ((InternetAddress)arrRecipientsBCC[i]).getAddress());
							} else {
								bccMobileStr +=  getMobileReceiverHTML(name, ((InternetAddress)arrRecipientsBCC[i]).getAddress()) + "&nbsp;,&nbsp;";
							}
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
						
						dateStr = commonUtil.getDateStringInUTC(receivedDateStr, info.getOffSet(), false);
					}
					LOGGER.debug("dateStr=" + dateStr);
					
					// subject
					subject = ezEmailUtil.getSubject(message);
					
					LOGGER.debug("subject=" + subject);
					
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
						LOGGER.debug("Message's seen flag changed to true.");
					}
					
					if (message.isSet(Flags.Flag.FLAGGED)) {
						flagged = "1";
					}
					mail.put("flag",flagged);

					mail.put("folderName",f.getName());
					bodyInfoList = ezEmailUtil.getBodyInfo(message, folderId, uid, -1, null, false, true, locale, null, null);

					double size = Double.parseDouble(bodyInfoList.get(2));
					String strSize = ezEmailUtil.getSizeWithUnit(size);
					pAttachListHtmlSub = bodyInfoList.get(3) + egovMessageSource.getMessage("ezEmail.t180", locale) + " (" + strSize + ")";
					
					if (!folderId.equals(egovMessageSource.getMessage("ezEmail.t99000026", locale))) {
					    String[] messageIds = message.getHeader("Message-ID");
					    
					    if (messageIds != null) {
					        LOGGER.debug("Message-ID=" + messageIds[0]);
					    } else {
					        LOGGER.debug("No Message-ID");
					    }
					    
						// send an MDN to the sender.
						if (!ezEmailUtil.hasMDNSentFlag(message)) {
							LOGGER.debug("MDNSentFlag isn't set.");
							
							// retrieve user info from db.
							OrganUserVO userVO = ezOrganAdminService.getUserInfo(info.getUserId(), info.getLang(), info.getTenantId());
							
							SMTPAccess sa = SMTPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.SMTPPort"),
									userEmail, password);
							
							ezEmailMailReadController.processAutoMDN(sa, message, userEmail, userVO.getDisplayName(), info.getTenantId());
						}
						else {
							LOGGER.debug("MDNSentFlag is set");
						}
					}
				}
				f.close(true);
				
			}
			
			LOGGER.debug(toMobileStr);
			LOGGER.debug(toStr);
			LOGGER.debug(ccMobileStr);
			LOGGER.debug(ccStr);
			
			mail.put("fromStr", fromStr);
			mail.put("fromEmail", fromEmail);
			mail.put("toStr", toStr);
			mail.put("toHiddenStr", toHiddenStr);
			mail.put("toMobileStr", toMobileStr);
			mail.put("ccStr", ccStr);
			mail.put("ccHiddenStr", ccHiddenStr);
			mail.put("ccMobileStr", ccMobileStr);
			mail.put("bccStr", bccStr);
			mail.put("bccMobileStr", bccMobileStr);
			mail.put("dateStr", dateStr);
			mail.put("subject", subject);
			mail.put("title", title);
			mail.put("folderId", folderId);
			mail.put("uid", uid);
			mail.put("pReadFlag", pReadFlag);
			mail.put("isDelete", isDelete);
			mail.put("isSentItems", isSentItems);
			mail.put("pnFlag", pnFlag);
			mail.put("pIsCCFg", pIsCCFg);
			mail.put("jMochaStandAlone", config.getProperty("config.IsJMochaStandAlone"));
			
			if (bodyInfoList != null) { 
				mail.put("htmlBody", bodyInfoList.get(0));
				mail.put("pAttachListHtmlSub", pAttachListHtmlSub);
				mail.put("pAttachListHtml", bodyInfoList.get(1));
				mail.put("isAttach", bodyInfoList.get(4));
			}
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", mail);
			
		} catch (MessagingException e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
			
		} finally {
			if (ia != null) {
				ia.close();
			}
		}
		
		
		LOGGER.debug("readMail ended.");
	
		LOGGER.debug("MOBILE G/W MAIL [GET /ezemail/folders/{folderId}/mails/{messageId}/users/{userId}] ended.");		
		
		return result;
		
	}
	
	/**
	 * 모바일 G/W 이메일 [GET] 파일 다운로드
	 */
	@RequestMapping(value="/mobile/ezemail/folders/{folderId}/mails/{messageId}/attach/{index}/users/{userId}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public Object mMailFileDown(HttpServletRequest request,
			@PathVariable String folderId, @PathVariable String messageId, @PathVariable String index, @PathVariable String userId) throws Exception {
		LOGGER.debug("MOBILE G/W MAIL [GET /ezemail/folders/{folderId}/mails/{messageId}/attach/{index}/users/{userId}] started.");
		
		String filename = "";
		
		InputStream input = null;
		OutputStream output = null;
		IMAPAccess ia = null;
		JSONObject result = new JSONObject();
				
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			String domainName = ezCommonService.getTenantConfig("DomainName", info.getTenantId());
			String userEmail = info.getUserId() + "@" + domainName;
			String password = jspw;
			LOGGER.debug("userEmail=" + userEmail);
			
			String ld = commonUtil.getTwoLetterLangFromLangNum(info.getLang());
			Locale locale = new Locale(ld);
			
			MOptionVO opt = mOptionService.optionInfo(userId, info.getTenantId());
			if ( opt.getLang().equals("1") ) {
				locale = new Locale("ko");	
			} else if ( opt.getLang().equals("3") ) {
				locale = new Locale("ja");
			}
			
			// retrieve the passed in parameters
			String folderPath = folderId;
			String strUid = messageId;
			long uid = strUid != null ? Long.parseLong(strUid) : 0;
			filename = request.getParameter("filename");
			LOGGER.debug("folderPath=" + folderPath + ",uid=" + uid + ",filename=" + filename);
			
			if (folderPath == null || strUid == null || filename == null) {
				LOGGER.debug("downloadAttach illegal arguments.");
				
				result.put("status", "error");
				result.put("code", 1);			
				result.put("data", "");
				
				return result;
			}
			
			String strIndex = index;
			int intIndex = -1;
			if(strIndex != null){
				intIndex = Integer.parseInt(strIndex);
			}
			LOGGER.debug("index=" + intIndex);
		
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userEmail, password, egovMessageSource, locale);
	
			Folder f = ia.getFolder(folderPath);
			
			if (f == null || !f.exists()) {
				LOGGER.error("Folder not found. folderPath=" + folderPath);
			} else {
				f.open(Folder.READ_ONLY);
				Message message = null;
				if(f.isOpen() && f instanceof IMAPFolder){
					message = ((IMAPFolder)f).getMessageByUID(uid);
				}
				
				if (message == null) {
					LOGGER.error("Message not found. uid=" + uid);
					result.put("status", "error");
					result.put("code", 1);			
					result.put("data", "");
				} else {
					Part part = null;
					if (intIndex == -1) {
						part = message;
					}
					else {
						part = ezEmailUtil.getAttachPart(message, intIndex);
					}
					
					if (part == null) {
						LOGGER.error("AttachPart not found. AttachPartIndex=" + index);
					} else {
//						LOGGER.debug("content-disposition=" + "attachment; filename=\"" + filename + "\"");
						
						try {
							input = part.getInputStream();
					
							byte[] bytes = IOUtils.toByteArray(input);
							
							JSONObject data = new JSONObject();
																				
							data.put("bytes", bytes);
							data.put("filename",filename);
							data.put("filetype",part.getContentType());
							
							result.put("status", "success");
							result.put("code", 0);			
							result.put("data", data);
							
						} catch(Exception e) {
							e.printStackTrace();
							result.put("status", "error");
							result.put("code", 1);			
							result.put("data", "");
						} finally {
							if (ia != null) {
								ia.close();
							}
							if (input != null) {
								try { input.close(); } catch (IOException e1) {}
							}
						}
						
					}
				}
			}
		} catch (MessagingException e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		} finally {
			if (ia != null) {
				ia.close();
			}
		}
		
		LOGGER.debug("downloadAttach ended.");
		
		return result;
	}
	
	/**
	 * 메일 인라인 이미지 읽어오기 실행 함수
	 */
	@RequestMapping(value="/mobile/ezemail/folders/{folderId}/mails/{messageId}/inlineattach/{index}/users/{userId}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public Object downloadInline(HttpServletRequest request,
			@PathVariable String folderId, @PathVariable String messageId, @PathVariable String index, @PathVariable String userId) throws Exception {

		LOGGER.debug("downloadInline started.");
		
		InputStream input = null;
		OutputStream output = null;
		IMAPAccess ia = null;
		JSONObject result = new JSONObject();
		
		// get user credentials
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			String domainName = ezCommonService.getTenantConfig("DomainName", info.getTenantId());
			String userEmail = info.getUserId() + "@" + domainName;
			String password = jspw;
			LOGGER.debug("userEmail=" + userEmail);
		
			String ld = commonUtil.getTwoLetterLangFromLangNum(info.getLang());
			Locale locale = new Locale(ld);
			
			MOptionVO opt = mOptionService.optionInfo(userId, info.getTenantId());
			if ( opt.getLang().equals("1") ) {
				locale = new Locale("ko");	
			} else if ( opt.getLang().equals("3") ) {
				locale = new Locale("ja");
			}
			
			// retrieve the passed in parameters
			String folderPath = folderId;
			String strUid = messageId;
			long uid = strUid != null ? Long.parseLong(strUid) : 0;
			String contentId = index;
			
			if (contentId != null) {
				contentId = EgovStringUtil.getHtmlStrCnvr(contentId);
			}	
		
		LOGGER.debug("folderPath=" + folderPath + ",uid=" + uid + ",contentId=" + contentId);
				
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userEmail, password, egovMessageSource, locale);
	
			Folder f = ia.getFolder(folderPath);
			if (f == null || !f.exists()) {
				LOGGER.error("Folder not found. folderPath=" + folderPath);
			} else {
				f.open(Folder.READ_ONLY);
				Message message = null;
				if(f.isOpen() && f instanceof IMAPFolder){
					message = ((IMAPFolder)f).getMessageByUID(uid);
				}
				
				if (message == null) {
					LOGGER.error("Message not found. uid=" + uid);
				} else {
					Part part = ezEmailUtil.getInlinePart(message, contentId);
					
					if (part == null) {
						LOGGER.error("InlinePart not found. contentId=" + contentId);
					} else {
						input = part.getInputStream();
						byte[] bytes = IOUtils.toByteArray(input);
						int byteRead;
						
						JSONObject data = new JSONObject();
						
						data.put("bytes", bytes);
						data.put("filetype",part.getContentType());
						
						result.put("status", "success");
						result.put("code", 0);			
						result.put("data", data);

					}
				}
			}
		} catch (MessagingException e) {
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
			
			return result;
		} finally {
			if (ia != null) {
				ia.close();
			}
		}
		
		LOGGER.debug("downloadInline ended.");
		return result;
	}
	
	/**
	 * 모바일 G/W 이메일 [PUT] 메일 이동 
	 */
	@RequestMapping(value="/mobile/ezemail/folders/{folderId}/mails/{messageId}/move/users/{userId}", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
	public Object mMailMove(HttpServletRequest request, @PathVariable String folderId, @PathVariable String messageId, @PathVariable String userId,
			@RequestBody JSONObject jsonobject) throws Exception {
		LOGGER.debug("MOBILE G/W MAIL [PUT /ezemail/folders/{folderId}/mails/{messageId}/move/users/{userId}] started.");
		
		JSONObject result = new JSONObject();
		
		IMAPAccess ia = null;
		
		try {
			
			String uniqueId =  messageId;
			String mfolderId = (String) jsonobject.get("mfolderId");
			
			LOGGER.debug("uniqueId, mfolderId=" + uniqueId + "," + mfolderId);
			
//			if (uniqueId.endsWith(",")) {
//				uniqueId = uniqueId.substring(0, uniqueId.length() - 1);
//			}
			
			String[] MsgIdArray = uniqueId.split(",");		
			long[] uids = new long[MsgIdArray.length];
			
			for (int i = 0; i < MsgIdArray.length; i++) {
				uids[i] = Long.parseLong(MsgIdArray[i]);
			}
				
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			String domainName = ezCommonService.getTenantConfig("DomainName", info.getTenantId());
			String userEmail = info.getUserId() + "@" + domainName;
			String password = jspw;

			String ld = commonUtil.getTwoLetterLangFromLangNum(info.getLang());
			Locale locale = new Locale(ld);
			
			MOptionVO opt = mOptionService.optionInfo(userId, info.getTenantId());
			if ( opt.getLang().equals("1") ) {
				locale = new Locale("ko");	
			} else if ( opt.getLang().equals("3") ) {
				locale = new Locale("ja");
			}
			
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userEmail, password, egovMessageSource, locale);
					
			IMAPFolder sourceFolder = (IMAPFolder)ia.getFolder(folderId);		
			sourceFolder.open(Folder.READ_WRITE);
			
			Message[] messages = sourceFolder.getMessagesByUID(uids);
			
			IMAPFolder movefolder = (IMAPFolder)ia.getFolder(mfolderId);			
			sourceFolder.copyUIDMessages(messages, movefolder);
			
			sourceFolder.setFlags(messages, new Flags(Flags.Flag.DELETED), true);
			
			sourceFolder.close(true);
		
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", "success");
			
		} catch (Exception e) {
			
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "fail");
			
		} finally {
			if (ia != null) {
				ia.close();
			}
		}
				
		LOGGER.debug("MOBILE G/W MAIL [GET /ezemail/folders/{folderId}/mails/{messageId}/move/users/{userId}] ended.");		
		
		return result;
	}
	
	/**
	 * 모바일 G/W 이메일 [PUT] 읽은 상태 변경
	 */
	@RequestMapping(value="/mobile/ezemail/folders/{folderId}/mails/{messageId}/users/{userId}", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
	public Object mMailStatusChange(HttpServletRequest request, @PathVariable String folderId, @PathVariable String messageId, @PathVariable String userId,
			@RequestBody JSONObject jsonobject) throws Exception {
		LOGGER.debug("MOBILE G/W MAIL [PUT /ezemail/folders/{folderId}/mails/{messageId}/users/{userId}] started.");
		// get user credentials
		
		JSONObject result = new JSONObject();
		
		IMAPAccess ia = null;
		
		try {
			
			String uniqueId =  messageId;
						
			String[] MsgIdArray = uniqueId.split(",");		
			long[] uids = new long[MsgIdArray.length];
			
			for (int i = 0; i < MsgIdArray.length; i++) {
				uids[i] = Long.parseLong(MsgIdArray[i]);
			}
		
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			String domainName = ezCommonService.getTenantConfig("DomainName", info.getTenantId());
			String userEmail = info.getUserId() + "@" + domainName;			
			String password = jspw;

			String ld = commonUtil.getTwoLetterLangFromLangNum(info.getLang());
			Locale locale = new Locale(ld);
			
			MOptionVO opt = mOptionService.optionInfo(userId, info.getTenantId());
			if ( opt.getLang().equals("1") ) {
				locale = new Locale("ko");	
			} else if ( opt.getLang().equals("3") ) {
				locale = new Locale("ja");
			}
			
			LOGGER.debug("userEmail=" + userEmail);
		        
			String isRead = (String) jsonobject.get("isRead");
			//TRUE면 읽은 상태로  FALSE면 읽지 않은 상태로 변경.			
	
			LOGGER.debug("folderId=" + folderId);		
								
				try {
					ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
							userEmail, password, egovMessageSource, locale);
							
					IMAPFolder sourceFolder = (IMAPFolder)ia.getFolder(folderId);		
					sourceFolder.open(Folder.READ_WRITE);		
							
					Message[] msgs = sourceFolder.getMessagesByUID(uids);		
							
					if (isRead.equals("TRUE")) {
						sourceFolder.setFlags(msgs, new Flags(Flags.Flag.SEEN), true);
					}
					else {
						sourceFolder.setFlags(msgs, new Flags(Flags.Flag.SEEN), false);
					}
					
					sourceFolder.close(true);
					
					result.put("status", "ok");
					result.put("code", 0);			
					result.put("data", "success");
					
				} catch (Exception e) {
					
					result.put("status", "error");
					result.put("code", 1);			
					result.put("data", "fail");
					
				} finally {
					if (ia != null) {
						ia.close();
					}
				}	
				
				LOGGER.debug("mailSetReadChange ended.");
				
		LOGGER.debug("MOBILE G/W MAIL [PUT /ezemail/folders/{folderId}/mails/{messageId}/users/{userId}] ended.");		
		} catch (Exception e) {
		
		} finally {
			
		}
		return result;
	}
	
	/**
	 * 모바일 G/W 이메일 [DELETE] 메일 삭제
	 * @return 
	 */
	@RequestMapping(value="/mobile/ezemail/folders/{folderId}/mails/{messageId}/users/{userId}", method= RequestMethod.DELETE, produces="application/json;charset=utf-8")
	public Object mMailDelete(HttpServletRequest request, @PathVariable String folderId, @PathVariable String messageId, @PathVariable String userId) throws Exception {
		LOGGER.debug("MOBILE G/W MAIL [DELETE /ezemail/folders/{folderId}/mails/{messageId}/users/{userId}] started.");
			
		JSONObject result = new JSONObject();
		
		IMAPAccess ia = null;
		// get user credentials
		try{
			
			folderId = URLDecoder.decode(folderId, "UTF-8");
			
			boolean permanentlyDelete = false;

			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			String domainName = ezCommonService.getTenantConfig("DomainName", info.getTenantId());
			String userEmail = info.getUserId() + "@" + domainName;
			String password = jspw;
		
			String ld = commonUtil.getTwoLetterLangFromLangNum(info.getLang());
			Locale locale = new Locale(ld);

			MOptionVO opt = mOptionService.optionInfo(userId, info.getTenantId());
			if ( opt.getLang().equals("1") ) {
				locale = new Locale("ko");	
			} else if ( opt.getLang().equals("3") ) {
				locale = new Locale("ja");
			}
			
			if(folderId.equals(egovMessageSource.getMessage("ezEmail.t647", locale))){
				permanentlyDelete = true;
			}
			
			String[] MsgIdArray = messageId.split(",");		
			long[] uids = new long[MsgIdArray.length];
			
			for (int i = 0; i < MsgIdArray.length; i++) {
				uids[i] = Long.parseLong(MsgIdArray[i]);
			}
		
			LOGGER.debug("folderId=" + folderId);

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
		
					
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", "success");
			
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "fail");
			
		} finally {
			if (ia != null) {
				ia.close();		
			}
		}
		
		LOGGER.debug("MOBILE G/W MAIL [DELETE /ezemail/folders/{folderId}/mails/{messageId}/users/{userId}] ended.");		
		
		return result;
	}
	
	@RequestMapping(value="/mobile/ezemail/folders/{folderId}/tempmail/{messageId}/users/{userId}", method= RequestMethod.DELETE, produces="application/json;charset=utf-8")
	public Object mTempMailDelete(HttpServletRequest request, @PathVariable String folderId, @PathVariable String messageId, @PathVariable String userId) throws Exception {
		LOGGER.debug("MOBILE G/W MAIL [DELETE /ezemail/folders/{folderId}/mails/{messageId}/users/{userId}] started.");
			
		JSONObject result = new JSONObject();
		
		IMAPAccess ia = null;
		// get user credentials
		try{
			
			folderId = URLDecoder.decode(folderId, "UTF-8");
			
			boolean permanentlyDelete = true;

			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			String domainName = ezCommonService.getTenantConfig("DomainName", info.getTenantId());
			String userEmail = info.getUserId() + "@" + domainName;
			String password = jspw;
		
			String ld = commonUtil.getTwoLetterLangFromLangNum(info.getLang());
			Locale locale = new Locale(ld);

			MOptionVO opt = mOptionService.optionInfo(userId, info.getTenantId());
			if ( opt.getLang().equals("1") ) {
				locale = new Locale("ko");	
			} else if ( opt.getLang().equals("3") ) {
				locale = new Locale("ja");
			}
			
			if(folderId.equals(egovMessageSource.getMessage("ezEmail.t647", locale))){
				permanentlyDelete = true;
			}
			
			String[] MsgIdArray = messageId.split(",");		
			long[] uids = new long[MsgIdArray.length];
			
			for (int i = 0; i < MsgIdArray.length; i++) {
				uids[i] = Long.parseLong(MsgIdArray[i]);
			}
		
			LOGGER.debug("folderId=" + folderId);

			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userEmail, password, egovMessageSource, locale);
						
			IMAPFolder sourceFolder = (IMAPFolder)ia.getFolder(folderId);		
			sourceFolder.open(Folder.READ_WRITE);		
	        
	        Message deleteMsgs = null;

	        deleteMsgs = ((IMAPFolder)sourceFolder).getMessageByUID(Long.parseLong(messageId));

			if (deleteMsgs != null) {
				deleteMsgs.setFlag(Flags.Flag.DELETED, true);
            }
			sourceFolder.close(true);
		
					
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", "success");
			
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "fail");
			
		} finally {
			if (ia != null) {
				ia.close();		
			}
		}
		
		LOGGER.debug("MOBILE G/W MAIL [DELETE /ezemail/folders/{folderId}/mails/{messageId}/users/{userId}] ended.");		
		
		return result;
	}
	 
	@RequestMapping(value="/mobile/ezemail/write/checkname/users/{userId}", method= RequestMethod.POST,  produces="application/json;charset=utf-8")
	public Object mailNameCheck(HttpServletRequest request, @PathVariable String userId, @RequestBody JSONObject jsonObject) {
		
		LOGGER.debug("MOBILE G/W MAIL [GET /ezemail/folders/{folderId}/mails/{messageId}/users/{userId}] started.");
		
		String organXML = "";
        String dlXML = "";
        String addressXML = "";
		
        JSONObject data = new JSONObject();
        JSONObject result = new JSONObject();
        
        try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			String domainName = ezCommonService.getTenantConfig("DomainName", info.getTenantId());
			String userEmail = info.getUserId() + "@" + domainName;
			String password = jspw;
		
			String ld = commonUtil.getTwoLetterLangFromLangNum(info.getLang());
			Locale locale = new Locale(ld);
			
			MOptionVO opt = mOptionService.optionInfo(userId, info.getTenantId());
			if ( opt.getLang().equals("1") ) {
				locale = new Locale("ko");	
			} else if ( opt.getLang().equals("3") ) {
				locale = new Locale("ja");
			}
			
			String pOrganSearchList = "";
			String pOrganCellList = "displayname";
			String pOrganPropList = "company;description;title;mail;extensionAttribute3";
			String pOrganListType = "all";
			String pDLSearchList = "";
			String pDLCellList = "displayname";
			String pDLPropList = "mail";
			String pDLListType = "group";
			String pAddressFilter = "";
	
			if (jsonObject.get("pOrganSearchList") != null) {
				pOrganSearchList = (String) jsonObject.get("pOrganSearchList");
			}
			
			if (jsonObject.get("pOrganCellList") != null) {
				pOrganCellList = (String) jsonObject.get("pOrganCellList");
			}
			
			if (jsonObject.get("pOrganPropList") != null) {
				pOrganPropList = (String) jsonObject.get("pOrganPropList");
			}
			
			if (jsonObject.get("pOrganListType") != null) {
				pOrganListType = (String) jsonObject.get("pOrganListType");
			}
			
			if (jsonObject.get("pDLSearchList") != null) {
				pDLSearchList = (String) jsonObject.get("pDLSearchList");
			}
			
			if (jsonObject.get("pDLCellList") != null) {
				pDLCellList = (String) jsonObject.get("pDLCellList");
			}
			
			if (jsonObject.get("pDLPropList") != null) {
				pDLPropList = (String) jsonObject.get("pDLPropList");
			}
			
			if (jsonObject.get("pDLPropList") != null) {
				pDLPropList = (String) jsonObject.get("pDLPropList");
			}
			
			if (jsonObject.get("pDLListType") != null) {
				pDLListType = (String) jsonObject.get("pDLListType");
			}
			
			if (jsonObject.get("pAddressFilter") != null) {
				pAddressFilter = (String) jsonObject.get("pAddressFilter");
			}
			
			LOGGER.debug("pOrganSearchList : " + pOrganSearchList + ", pOrganCellList : " + pOrganCellList 
					+ ", pOrganPropList : " + pOrganPropList +", pOrganListType : " + pOrganListType);
			
	        organXML = getOrganSearch(pOrganSearchList, pOrganCellList, pOrganPropList, pOrganListType, info);
	        dlXML = getOrganDLSearch(pDLSearchList, info);
	        addressXML = getAddressSearch(pAddressFilter, info);
	        
	        data.put("organXML", organXML);
	        data.put("dlXML", dlXML);
	        data.put("addressXML",addressXML);
	        
	        result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", data);
			
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "fail");
			
		}
        
        LOGGER.debug("MOBILE G/W MAIL [GET /ezemail/folders/{folderId}/mails/{messageId}/users/{userId}] ended.");
        
        return result;
	}
	
	/**
	 * 메일 책갈피 지정 실행 함수
	 */
	@RequestMapping(value="/mobile/ezemail/folders/{folderId}/mails/{messageId}/users/{userId}/setFlag", method= RequestMethod.POST, produces="application/json;charset=utf-8")
	public Object mailSetFlag(HttpServletRequest request, @PathVariable String folderId, @PathVariable String messageId, @PathVariable String userId, @RequestBody JSONObject jsonObject) throws Exception {
		LOGGER.debug("MOBILE G/W MAIL [GET /ezemail/folders/{folderId}/mails/{messageId}/users/{userId}/setFlag] started.");

		String returnData = "";
		
		JSONObject data = new JSONObject();
	    JSONObject result = new JSONObject();
	     
	    IMAPAccess ia = null;
	     
	    String setCmd = "toggle";
		
		if (jsonObject.get("setCmd") != null) {
			setCmd = (String) jsonObject.get("setCmd");
		}
	    
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			String domainName = ezCommonService.getTenantConfig("DomainName", info.getTenantId());
			String userEmail = info.getUserId() + "@" + domainName;
			String password = jspw;
			String ld = commonUtil.getTwoLetterLangFromLangNum(info.getLang());
			Locale locale = new Locale(ld);
			
			MOptionVO opt = mOptionService.optionInfo(userId, info.getTenantId());
			if ( opt.getLang().equals("1") ) {
				locale = new Locale("ko");	
			} else if ( opt.getLang().equals("3") ) {
				locale = new Locale("ja");
			}
			
			LOGGER.debug("userEmail=" + userEmail);
			
			String uniqueId = messageId;	
			
			long[] uids = null;
			
			if (uniqueId.endsWith(",")) {
				uniqueId = uniqueId.substring(0, uniqueId.length() - 1);
			}
			
			String[] messageIdArray = uniqueId.split(",");
						
			uids = new long[messageIdArray.length];
			for (int i = 0; i < messageIdArray.length; i++) {
				String msgId = messageIdArray[messageIdArray.length - i - 1];
				uids[i] = Long.parseLong(msgId);
			}
			
			LOGGER.debug("folderId=" + folderId + "uniqueId=" + uniqueId);		

			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
				userEmail, password, egovMessageSource, locale);
				
			IMAPFolder sourceFolder = (IMAPFolder)ia.getFolder(folderId);		
			sourceFolder.open(Folder.READ_WRITE);		
					
			Message[] msgs = sourceFolder.getMessagesByUID(uids);
			
			for (int i = 0; i < msgs.length; i++) {
				Message msg = msgs[i];
				if (setCmd.equals("toggle")) {
					if (msg.isSet(Flags.Flag.FLAGGED)) {
						msg.setFlag(Flags.Flag.FLAGGED, false);
						returnData = "DEL";
					} else {
						msg.setFlag(Flags.Flag.FLAGGED, true);
						returnData = "NEW";
					}
				} else if (setCmd.equals("set")) {
					msg.setFlag(Flags.Flag.FLAGGED, true);
					returnData = "NEW";
				} else if (setCmd.equals("reset")) {
					msg.setFlag(Flags.Flag.FLAGGED, false);
					returnData = "DEL";
				}
			}
			
			sourceFolder.close(true);
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", returnData);
			
		} catch (Exception e) {
			returnData = "ERROR : " + e.getMessage();
			
			e.printStackTrace();
			
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", returnData);
			
		}  finally {
			if (ia != null) {
				ia.close();
			}
		}
		
		LOGGER.debug("MOBILE G/W MAIL [GET /ezemail/folders/{folderId}/mails/{messageId}/users/{userId}/setFlag] ended.");
		
		return result;				
	}
	
	/**
	 * 사원 Organ 정보 호출 함수
	 */
	private String getOrganSearch(String pSearchList, String pCellList, String pPropList, String pListType, MCommonVO userInfo) {
		String pResult = "";
        try {
            pResult = ezOrganService.getSearchList(pSearchList, pCellList, pPropList, pListType, 100, userInfo.getLang(), userInfo.getTenantId());
        } catch (Exception e) {
        	e.printStackTrace();
            pResult = "EXCEPTION";
        }
        return pResult;
    }
	
	/**
	 * 공용배포그룹 정보 호출 함수
	 */
	private String getOrganDLSearch(String pSearchList, MCommonVO userInfo) {
        String returnData = "";
        
        try {
        	String searchValue = pSearchList.split("::")[1];
        	
			List<MailDistributionVO> distributionList = ezEmailService.getDistributionSearchList(userInfo.getCompanyId(), userInfo.getTenantId(), searchValue);
			
			StringBuilder sb = new StringBuilder();
			sb.append("<LISTVIEWDATA><ROWS>");

			for (MailDistributionVO vo : distributionList) {
				sb.append("<ROW><CELL>");
				
				sb.append("<VALUE>");
				sb.append(commonUtil.cleanValue(vo.getName()));
				sb.append("</VALUE>");
				
				sb.append("<DATA1>group</DATA1>");
				
				sb.append("<DATA2>");
				sb.append(commonUtil.cleanValue(vo.getId()));
				sb.append("</DATA2>");
				
				sb.append("<DATA3>");
				sb.append(commonUtil.cleanValue(vo.getMail()));
				sb.append("</DATA3>");
				
				sb.append("</CELL></ROW>");
			}
			
			sb.append("</ROWS></LISTVIEWDATA>");
			
			returnData = sb.toString();
			
		} catch (Exception e) {
			returnData = "EXCEPTION";
			e.printStackTrace();
		}
        
        return returnData;
    }
	
	/**
	 * 주소록 정보 호출 함수
	 */
	private String getAddressSearch(String pFilter, MCommonVO userInfo) {
        String returnValue = "";
        try {
            String[] ownerIds = new String[]{userInfo.getCompanyId(), userInfo.getDeptId(), userInfo.getUserId()};
            pFilter = "S_NAME," + pFilter;
            
            List<AddressVO> addressInfoList = ezAddressService.getSearchList(userInfo.getTenantId(), ownerIds, "", pFilter, 100, 0);
            
            StringBuilder sb = new StringBuilder();
            
            for (AddressVO addressInfo : addressInfoList) {
            	sb.append("<ROW>");
            	sb.append("<STYPE>" + (addressInfo.getsType() == null ? "" : addressInfo.getsType()) + "</STYPE>");
            	sb.append("<ADDRESSID>" + (addressInfo.getAddressId() == null ? "" : addressInfo.getAddressId()) + "</ADDRESSID>");
            	sb.append("<SNAME>" + (addressInfo.getsName() == null ? "" : commonUtil.cleanValue(addressInfo.getsName())) + "</SNAME>");
            	sb.append("<FOLDERTYPE>DB</FOLDERTYPE>");
            	sb.append("<SEMAIL>" + (addressInfo.getsEmail() == null ? "" : commonUtil.cleanValue(addressInfo.getsEmail())) + "</SEMAIL>");
            	sb.append("<SCOMPANY>" + (addressInfo.getsCompany() == null ? "" : commonUtil.cleanValue(addressInfo.getsCompany())) + "</SCOMPANY>");
            	sb.append("<SDEPT>" + (addressInfo.getsDept() == null ? "" : commonUtil.cleanValue(addressInfo.getsDept())) + "</SDEPT>");
            	sb.append("<STITLE>" + (addressInfo.getsTitle() == null ? "" : commonUtil.cleanValue(addressInfo.getsTitle())) + "</STITLE>");
            	sb.append("</ROW>");
            }
            
            returnValue = sb.toString();
        } catch (Exception e) {
        	e.printStackTrace();
        	returnValue = "EXCEPTION";
        }
        return returnValue;
    }
	
	private String getReceiverHTML(String name, String address){
		return "<span style='cursor:pointer' title='" + (address==null?"":EgovStringUtil.getSpclStrCnvr(address)) + "' onclick='show_personinfo(\"" + address + "\")'>" + (name==null?"":EgovStringUtil.getSpclStrCnvr(name)) + "</span>";
	}
	
	private String getMobileReceiverHTML(String name, String address){
		return "<span style='display:inline-block' title='" + (address==null?"":EgovStringUtil.getSpclStrCnvr(address)) + "'>" + (name==null?"":EgovStringUtil.getSpclStrCnvr(name)) + "</span>";
	}
	
//	private void processAutoMDN(SMTPAccess sa, Message message, String myEmailAddress, String myName) {
//		LOGGER.debug("processAutoMDN started.");
//		
//		try {		
//			String fromEmailAddress = ezEmailUtil.getFromEmailAddressOfMessage(message);
//			
//			LOGGER.debug("myEmailAddress=" + myEmailAddress + ",fromEmailAddress=" + fromEmailAddress);
//			
//			int atSignIndex = fromEmailAddress.indexOf("@");
//			
//			if (fromEmailAddress.equals("") || atSignIndex == -1) {
//				LOGGER.debug("invalid fromEmailAddress=" + fromEmailAddress);
//				return;
//			}
//			
//			String fromEmailDomain = fromEmailAddress.substring(atSignIndex + 1);
//			String myEmailDomain = myEmailAddress.substring(myEmailAddress.indexOf("@") + 1);
//			
//			LOGGER.debug("fromEmailDomain=" + fromEmailDomain + ",myEmailDomain=" + myEmailDomain);
//			
//			if (!fromEmailDomain.equalsIgnoreCase(myEmailDomain)) {
//				LOGGER.debug("different domain");
//				LOGGER.debug("processAutoMDN ended.");
//				return;
//			}
//									
//			String[] messageIds = message.getHeader("Message-ID");
//			String[] mdnHeaders = message.getHeader("Disposition-Notification-To");
//			
//			if (messageIds != null && mdnHeaders != null) {				
//				LOGGER.debug("Sending an MDN...");
//											
//				Message replyMessage = message.reply(false);
//				
//        		// ANSWERED flag needs to be cleared since the above reply method sets it.
//				message.setFlag(Flags.Flag.ANSWERED, false);
//				
//				InternetHeaders h = new InternetHeaders();
//				
//				h.addHeader("Reporting-UA", "JMocha Mail 1.0");
//				h.addHeader("Final-Recipient", String.format("rfc822;%s", myEmailAddress));
//				h.addHeader("Original-Message-ID", messageIds[0]);
//				h.addHeader("Disposition", "automatic-action/MDN-sent-automatically; displayed");
//				
//				DispositionNotification dn = new DispositionNotification();
//				dn.setNotifications(h);
//				
//				MultipartReport mpr = new MultipartReport("This is a Read Receipt.", dn);
//				replyMessage.setContent(mpr);		
//				replyMessage.setFrom(new InternetAddress(myEmailAddress, myName, "UTF-8"));
//										
//				sa.sendMessageWithNewTransport(replyMessage);
//				
//				ezEmailUtil.setMDNSentFlag(message, true);
//			}
//		}
//		catch (Exception e) {
//			e.printStackTrace();
//		}
//		
//		LOGGER.debug("processAutoMDN ended.");
//	}
	
	public class CountOutputStream extends OutputStream {
	    int size;
		
	    public int getSize() {
	    	return size;
	    }
	    
	    @Override
	    public void write(byte[] b, int off, int len) {
	    	size += len;
	    }

	    @Override
	    public void write(int b) {
	    	size += 1;
	    }

	    @Override
	    public void write(byte[] b) throws IOException {
	    	size += b.length;
	    }
	}
	
	/**
     * 첨부파일을 서버에 저장한다.
     *
     * @param file
     * @param newName
     * @param stordFilePath
     * @throws Exception
     */
    public void mobileMailWriteUploadedFile(String bytearray, String newName, String stordFilePath) throws Exception {
    	LOGGER.debug("mobileMailWriteUploadedFile");
    	
		InputStream stream = null;
		OutputStream bos = null;
		String stordFilePathReal = (stordFilePath==null?"":stordFilePath);
		
		try {
//		    stream = file.getInputStream();
		    File cFile = new File(stordFilePathReal);
	
		    if (!cFile.isDirectory()) {
				boolean _flag = cFile.mkdirs();
				if (!_flag) {
				    throw new IOException("Directory creation Failed ");
				}
		    }
	
		    bos = new FileOutputStream(stordFilePathReal + File.separator + newName);
		    LOGGER.debug("###" + stordFilePathReal + File.separator + newName + "###");
		    int bytesRead = 0;
		    byte[] buffer = new byte[BUFF_SIZE];
		    Decoder decoder = Base64.getDecoder();
//		    while ((bytesRead = stream.read(buffer, 0, BUFF_SIZE)) != -1) {
		    bos.write(decoder.decode(bytearray));
//		    }
		} catch (FileNotFoundException fnfe) {
			LOGGER.debug("fnfe: {}", fnfe);
		} catch (IOException ioe) {
			LOGGER.debug("ioe: {}", ioe);
		} catch (Exception e) {
			LOGGER.debug("e: {}", e);
		} finally {
		    if (bos != null) {
				try {
				    bos.close();
				} catch (Exception ignore) {
					LOGGER.debug("IGNORED: {}", ignore.getMessage());
				}
		    }
		    if (stream != null) {
				try {
				    stream.close();
				} catch (Exception ignore) {
					LOGGER.debug("IGNORED: {}", ignore.getMessage());
				}
		    }
		}
    }
	
}
