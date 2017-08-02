package egovframework.ezMobile.ezEmail.web;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URLDecoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Properties;
import java.util.TimeZone;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.annotation.Resource;
import javax.mail.Address;
import javax.mail.FetchProfile;
import javax.mail.Flags;
import javax.mail.Flags.Flag;
import javax.mail.Folder;
import javax.mail.Message;
import javax.mail.Message.RecipientType;
import javax.mail.MessagingException;
import javax.mail.Multipart;
import javax.mail.Part;
import javax.mail.Transport;
import javax.mail.UIDFolder;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.InternetHeaders;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import javax.mail.internet.MimeUtility;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.ws.Response;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.sun.mail.dsn.DispositionNotification;
import com.sun.mail.dsn.MultipartReport;
import com.sun.mail.imap.AppendUID;
import com.sun.mail.imap.IMAPFolder;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.logic.IMAPAccess;
import egovframework.ezEKP.ezEmail.logic.SMTPAccess;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezEmail.util.EzEmailUtil;
import egovframework.ezEKP.ezEmail.vo.MailSignatureVO;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.ezMobile.ezEmail.vo.MEmailFolderVO;
import egovframework.ezMobile.ezOption.service.MOptionService;
import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.let.user.login.service.LoginService;
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
	private EzOrganAdminService ezOrganAdminService;
	
	@Resource(name="MOptionService")
	private MOptionService mOptionService;
	
	@Resource(name = "EzCommonService")
    private EzCommonService ezCommonService;
	
	static final String SUPERPASSWORD = "!p1221612";	
	
	/**
	 * 모바일 G/W 이메일 [put] method sample
	 */
	/*
	 * @RequestMapping(value="/ezMAIL/{MAILid}/gw-testUpdate/{id}", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
	public void testUpdate(@PathVariable String MAILid, @PathVariable String id, @RequestBody LoginVO loginVO) throws Exception {		
		LOGGER.debug("gw-testUpdate started.");
		
		System.out.println(loginVO.getIp());
				
		LoginVO vo = new LoginVO();
		vo.setTenantId(0);
		vo.setId(id);
		vo.setIp(loginVO.getIp());
		
		loginService.updateUser(vo);
		
		LOGGER.debug("gw-testUpdate ended.");		
	}
	*/
    ///////////////////////////////////////////////// sample end /////////////////////////////////////////////////////
	
	/**
	 * 모바일 G/W 이메일 [GET] 왼쪽 슬라이드 메뉴에 편지함 목록 조회, 메일 이동 시 편지함 목록 출력
	 */
	@RequestMapping(value="/mobile/ezemail/folders-list/users/{userId}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public Object mMailFolderList(HttpServletRequest request, @PathVariable String userId, @RequestParam(value="folderId", required=false) String folderId, Locale locale) {
		LOGGER.debug("MOBILE G/W MAIL [GET /ezemail/folders-list/users/{userId}] started.");
		
		JSONObject result = new JSONObject();
		IMAPAccess ia = null;
		
		try {
		
			LOGGER.debug("folderId=" + folderId);
		
			List<MEmailFolderVO> mailFolderList = new ArrayList<MEmailFolderVO>();
		
		
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			String domainName = ezCommonService.getTenantConfig("DomainName", info.getTenantId());
			String userEmail = info.getUserId() + "@" + domainName;
			
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userEmail, "qwe123!", egovMessageSource, locale);
			
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
				if (f.list().length > 0) {
					folder.setHasSub(true);
				} else {
					folder.setHasSub(false);
				}
				mailFolderList.add(folder);
			}
			
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
			@RequestParam(value="start", required=false) String start,
			@RequestParam(value="end", required=false) String end,
			@RequestParam(value="search", required=false) String search,
			@RequestParam(value="filter", required=false) String filter, Locale locale) {
		LOGGER.debug("MOBILE G/W MAIL [GET /ezemail/folders/{folderId}/mails/users/{userId}] started.");

		JSONObject result = new JSONObject();
        IMAPAccess ia = null;
		
		try {
				
			JSONArray messageJsonArray = new JSONArray();
			
			boolean senderReceiverFlag = false;
       
			String inboxName = egovMessageSource.getMessage("ezEmail.t644", locale);
			String sendName = egovMessageSource.getMessage("ezEmail.t644", locale);
			String tempName = egovMessageSource.getMessage("ezEmail.t644", locale);
		
	        folderId = folderId.equals(inboxName) ? "INBOX" : folderId;
	        
	        senderReceiverFlag = folderId.equals(sendName) ? true : false;
	        senderReceiverFlag = folderId.equals(tempName) ? true : false;
	        
	        LOGGER.debug("userID : " + userId+ ",folderId : " + folderId + ",start : " + start + ",end : " + end + "search : " + search); 
	        
	        Message[] messages = null;
			
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			String domainName = ezCommonService.getTenantConfig("DomainName", info.getTenantId());
			String userEmail = info.getUserId() + "@" + domainName;
			
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userEmail, "qwe123!", egovMessageSource, locale);
					
			Folder folder = ia.getFolder(folderId);		
			folder.open(Folder.READ_ONLY);
	        UIDFolder uidFolder = (UIDFolder)folder;
	        
	        JSONObject contentrange = new JSONObject();
	        
	        contentrange.put("contentrange", start + "-" + end);
	        
	        messageJsonArray.add(contentrange);
	        
	        boolean isUnreadOnly = false;
	        boolean isImportantOnly = false;
			
	        if (filter.equals("isUnreadOnly")) {
	        	isUnreadOnly = true;
	        } 
	        
	        else if (filter.equals("isImportantOnly")) {
	        	isImportantOnly = true;
	        }
	        
			if (!search.equals("")) {
				int index = search.indexOf("=");
				if (index >= 0) {
					String searchField = search.substring(0, index);
					final String searchValue = search.substring(index + 1);
					
					LOGGER.debug("searchField=" + searchField + ",searchValue=" + searchValue);
					
					messages = ezEmailUtil.searchFolder(folder, searchField, searchValue, null, null, false, null, isUnreadOnly, isImportantOnly);
				}
			}
			else if (isUnreadOnly) {
				messages = ezEmailUtil.searchFolder(folder, "", "", null, null, false, null, isUnreadOnly, false);
			}
			
			else if (isImportantOnly) {
				messages = ezEmailUtil.searchFolder(folder, "", "", null, null, false, null, false, isImportantOnly);
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
				
//				receivedDateStr = commonUtil.getDateStringInUTC(receivedDateStr, userInfo.getOffset(), false);
				receivedDateStr = "";
				
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
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", messageJsonArray);
			
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
	 * 메인 받은 편지함 전용 함수
	 */
	@RequestMapping(value="/mobile/ezemail/main/mail-list/users/{userId}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public Object mMailMainMailList(HttpServletRequest request, @PathVariable String userId, 
			@RequestParam(value="start", required=false) String start,
			@RequestParam(value="end", required=false) String end,
			@RequestParam(value="filter", required=false) String filter, Locale locale) {
		LOGGER.debug("MOBILE G/W MAIL [GET /ezemail/folders/{folderId}/mails/users/{userId}] started.");

		JSONObject result = new JSONObject();
        IMAPAccess ia = null;
		
		try {
				
			JSONArray messageJsonArray = new JSONArray();
       
			String folderId = "INBOX";
	        String listLength = "10";			
			start = "0";
			end = (Integer.parseInt(start) + Integer.parseInt(listLength) - 1) + "";
	        
	        LOGGER.debug("userID : " + userId+ ",folderId : " + folderId + ",listLength : " + listLength
	        		+"start : " + start+ ",end : " + end); 
	        
	        Message[] messages = null;
			
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			String domainName = ezCommonService.getTenantConfig("DomainName", info.getTenantId());
			String userEmail = info.getUserId() + "@" + domainName;
			
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userEmail, "qwe123!", egovMessageSource, locale);
					
			Folder folder = ia.getFolder(folderId);		
			folder.open(Folder.READ_ONLY);
	        UIDFolder uidFolder = (UIDFolder)folder;
	        
	        JSONObject contentrange = new JSONObject();
	        
	        contentrange.put("contentrange", start + "-" + end);
	        
	        messageJsonArray.add(contentrange);
	        
	        boolean isUnreadOnly = false;
	        boolean isImportantOnly = false;
			
			if (messages == null) {
				messages = folder.getMessages(); 
			}
			
			ezEmailUtil.sortMessages(folder, messages, "receivedDate", false);
			//가장 최근에 받은 편지 순으로 정렬
			
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

				// in case of Sent mailbox

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
				
//				receivedDateStr = commonUtil.getDateStringInUTC(receivedDateStr, userInfo.getOffset(), false);
				receivedDateStr = "";
				
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
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", messageJsonArray);
			
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
	 * 모바일 G/W 이메일 [POST] 메시지 복사 (전달을 선택한 메일정보 조회)
	 */
	@RequestMapping(value="/mobile/ezemail/folders/{folderId}/mails/{messageId}/copy/users/{userId}", method= RequestMethod.POST, produces="application/json;charset=utf-8")
	public Object mMailCopy(HttpServletRequest request, @PathVariable String folderId, @PathVariable String messageId, @PathVariable String userId,
			 @RequestBody JSONObject jsonObject, Locale locale) throws Exception {
		LOGGER.debug("MOBILE G/W MAIL [POST /ezemail/folders/{folderId}/mails/{messageId}/copy/users/{userId}] started.");
		
		JSONObject result = new JSONObject();

		IMAPAccess ia = null;
		
		try {
			String tofolderId = (String) jsonObject.get("toFolderID");
			
			String[] folderAndMsgIdArray = messageId.split(",");
			long[] uids = new long[folderAndMsgIdArray.length];
			
			for (int i = 0; i < folderAndMsgIdArray.length; i++) {
				String msgId = folderAndMsgIdArray[i];
				uids[i] = Long.parseLong(msgId);
			}
			
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			String domainName = ezCommonService.getTenantConfig("DomainName", info.getTenantId());
			String userEmail = info.getUserId() + "@" + domainName;
						
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userEmail, "qwe123!", egovMessageSource, locale);
					
			IMAPFolder sourceFolder = (IMAPFolder)ia.getFolder(folderId);		
			sourceFolder.open(Folder.READ_WRITE);
			
			Message[] messages = sourceFolder.getMessagesByUID(uids);
			
			IMAPFolder movefolder = (IMAPFolder)ia.getFolder(tofolderId);			
			sourceFolder.copyUIDMessages(messages, movefolder);
						
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
				
		LOGGER.debug("MOBILE G/W MAIL [POST /ezemail/folders/{folderId}/mails/{messageId}/copy/users/{userId}] ended.");
		
		return result;
	}
	
	/**
	 * 모바일 G/W 이메일 [GET] 메일 쓰기에 필요한 옵션 정보 조회
	 */
	@RequestMapping(value="/mobile/ezemail/mail-write/option", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public void mMailWriteOption(HttpServletRequest request) throws Exception {
		LOGGER.debug("MOBILE G/W MAIL [GET /ezemail/mail-write/option] started.");
		
		LOGGER.debug("MOBILE G/W MAIL [GET /ezemail/mail-write/option] ended.");		
	}
	
	/**
	 * 모바일 G/W 이메일 [GET] 서명 조회
	 */
	@RequestMapping(value="/mobile/ezemail/sign/users/{userId}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public Object mMailSign(HttpServletRequest request, @PathVariable String userId){
		LOGGER.debug("MOBILE G/W MAIL [GET /ezemail/sign/users/{userId}] started.");
		
		JSONObject result = new JSONObject();

		try{
			int tenantID = 0;
			
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			String domainName = ezCommonService.getTenantConfig("DomainName", info.getTenantId());
			String userEmail = info.getUserId() + "@" + domainName;
			
			tenantID = info.getTenantId();
			
			String mailSign1 = "";
			String mailSign2 = "";
			String mailSign3 = "";
			String mailSignSel = "0";
			
	
			LOGGER.debug("tenantID" + tenantID + "userId" + userId);
			
			MailSignatureVO mailSignatureVO = ezEmailService.getMailSignature(tenantID, userId);
	        
	        if (mailSignatureVO != null) {
	        	mailSign1 = mailSignatureVO.getContent1();
	            mailSign2 = mailSignatureVO.getContent2();
	            mailSign3 = mailSignatureVO.getContent3();
	            mailSignSel = mailSignatureVO.getUseFlag().trim();
	        }
	        
	        result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", mailSignatureVO);
	        
		} catch (Exception e) {
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", "");
		}
		LOGGER.debug("MOBILE G/W MAIL [GET /ezemail/sign/users/{userId}] ended.");	
		
		return result;
	}
	
	/**
	 * 모바일 G/W 이메일 [POST] 첨부파일 업로드
	 */
	@RequestMapping(value="/mobile/ezemail/folders/{folderId}/mails/{messageId}/attachs/users/{userId}", method= RequestMethod.POST, produces="application/json;charset=utf-8")
	public void mMailFileUpload(HttpServletRequest request) throws Exception {
		LOGGER.debug("MOBILE G/W MAIL [POST /ezemail/folders/{folderId}/mails/{messageId}/attachs/users/{userId}] started.");
//		
//		
//		LOGGER.debug("mailInterUploadXCK started.");
//		
//		String strXML = "";
//		String strXML2 = "";
//		String folderDate = "";
//		String tempFolderName = "";
//		String xmlList = "";
//		String isBigYN = "N";
//		List<MultipartFile> multiFile = request.getFiles("fileToUpload");
//		int cnt = 0;
//		if (request.getParameter("cnt") != null && !request.getParameter("cnt").equals("")) {
//			cnt = Integer.parseInt(request.getParameter("cnt"));
//		}
//		String realPath = commonUtil.getRealPath(request);
//		String[] pFileName = new String[cnt];
//		Long[] fileSize = new Long[cnt];
//		String[] fileLocation = new String[cnt];
//		String[] resultUpload = new String[cnt];
//		String[] sGUID = new String[cnt];
//		String pBigFileUpload = "";
//		String[] sFileTitle = new String[cnt];
//		String[] sExt = new String[cnt];
//		String pDirTempPath = "";
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
//		String useExtension = ezCommonService.getTenantConfig("USE_FileExtension", userInfo.getTenantId());
//		
//		if (useExtension == null) {
//			useExtension = "";
//		}
//		
//		if (multiFile.get(0).getOriginalFilename() != null && StringUtils.isNotBlank(multiFile.get(0).getOriginalFilename())){
//			boolean isEmpty = false;
//			String _pFileName = "";
//			for (int i=0; i<cnt; i++) {
//				_pFileName = multiFile.get(i).getOriginalFilename();
//				if (_pFileName.indexOf(commonUtil.separator) > 0) {
//					_pFileName = _pFileName.split(commonUtil.separator)[_pFileName.split(commonUtil.separator).length - 1];
//				}
//				pFileName[i] = _pFileName;
//				if (pFileName[i].lastIndexOf(".") > -1) {
//					sFileTitle[i] = pFileName[i].substring(0, pFileName[i].lastIndexOf("."));
//					sExt[i] = pFileName[i].substring(pFileName[i].lastIndexOf(".") + 1);
//				} else {
//					sFileTitle[i] = pFileName[i];
//					sExt[i] = "";
//				}
//				
//				if (multiFile.get(i).getSize() == 0) {
//					isEmpty = true;
//				}
//			}
//			if (isEmpty) {
//				return "OVERFLOW";
//			}
//		}
//
//		for (int i=0; i<cnt; i++) {
//			sGUID[i] = UUID.randomUUID().toString() + "." + sExt[i];
//		}
//
//		if (request.getParameter("bigmaxsize") != null) {
//			bigMaxSize = Long.parseLong(request.getParameter("bigmaxsize"));
//		}
//		if (request.getParameter("changesize") != null) {
//			changeSize = Long.parseLong(request.getParameter("changesize"));
//		}
//
//		strXML = "<ROOT><NODES>";
//		String pDirPath = commonUtil.getUploadPath("upload_mail.ROOT", userInfo.getTenantId());
//		pDirPath = realPath + pDirPath;
//		
//		// check the upload mail root folder and create it if it isn't exist.
//		File uploadMailRootFolder = new File(pDirPath);
//		if (!uploadMailRootFolder.exists()) {
//			LOGGER.debug("creating uploadMailRootFolder=" + uploadMailRootFolder);
//			uploadMailRootFolder.mkdirs();
//		}
//		
//		for (int i=0; i<cnt; i++) {
//			fileSize[i] = multiFile.get(i).getSize();
//			if (fileSize[i] > changeSize || isBigYN.equals("Y")) {
//                String pDate = EgovDateUtil.getToday("");
//                folderDate = pDate;
//                pDirTempPath = pDirPath + commonUtil.separator + pDate;
//                File file = new File(pDirTempPath);
//                if (!file.exists()) {
//                	file.mkdirs();
//                }
//                pBigFileUpload = "Y";
//                
//                String base64OrgFileName = Base64.encodeBase64String(pFileName[i].getBytes("UTF-8"));
//                FileOutputStream fos = null;
//                try {
//                	File f = new File(pDirTempPath + commonUtil.separator + sGUID[i] + "__.txt");
//                	fos = new FileOutputStream(f);
//                    fos.write(base64OrgFileName.getBytes("ISO-8859-1"));
//                } catch(Exception e) {
//                	throw e;
//                } finally {
//                	if (fos != null) {
//                		fos.close();
//                	}
//                }
//            } else {
//                pDirTempPath = pDirPath + commonUtil.separator + "tempFileUpload";
//                pBigFileUpload = "N";
//            }
//			
//			File f = new File(pDirTempPath);
//			if (!f.exists()) {
//				f.mkdirs();
//            }
//			
//			if (fileSize[i] > bigMaxSize && bigMaxSize != 0) {
//                resultUpload[i] = "overflow";
//            } else {
//                if (useExtension.toLowerCase().indexOf(sExt[i].toLowerCase()) == -1 && !useExtension.equals("*")) {
//                    resultUpload[i] = "denied";
//                } else {
//                    writeUploadedFile(multiFile.get(i), sGUID[i], pDirTempPath);
//                    fileLocation[i] = pDirTempPath + commonUtil.separator + sGUID[i];
//                    resultUpload[i] = "true";
//                }
//                
//                strXML2 += "<NODE><PUPLOADSN><![CDATA[" + sGUID[i] + "]]></PUPLOADSN>";
//                strXML2 += "<RESULTUPLOADA><![CDATA[" + resultUpload[i] + "]]></RESULTUPLOADA>";
//                strXML2 += "<PFILENAME><![CDATA[" + pFileName[i] + "]]></PFILENAME>";
//                strXML2 += "<FILESIZE><![CDATA[" + fileSize[i] + "]]></FILESIZE>";
//                if (pBigFileUpload.equals("Y")) {
//                	strXML2 += "<FILELOCATION><![CDATA[" + folderDate+"|!|"+sGUID[i] + "]]></FILELOCATION>";
//                } else {
//                	strXML2 += "<FILELOCATION><![CDATA[" + sGUID[i] + "]]></FILELOCATION>";
//                }
//                strXML2 += "<PBIGFILEUPLOAD><![CDATA[" + pBigFileUpload + "]]></PBIGFILEUPLOAD>";
//                strXML2 += "</NODE>";
//            }
//            pDirTempPath = "";
//		}
//		strXML += strXML2 + "</NODES></ROOT>";
//
//        String xmlPath = pDirPath + commonUtil.separator + "templist";
//        File f = new File(xmlPath);
//        if (!f.exists()) {
//			f.mkdirs();
//        }
//
//        xmlPath += commonUtil.separator + tempFolderName + ".txt";
//        f = new File(xmlPath);
//        if (f.exists()) {
//        	String tempXmlList = "";
//        	InputStreamReader isr = null;
//        	BufferedReader br = null;
//        	OutputStreamWriter osw = null;
//        	try {
//	        	isr = new InputStreamReader(new FileInputStream(f));
//	        	br = new BufferedReader(isr);
//	        	int read = 0;
//				while ((read = br.read()) != -1) {
//					tempXmlList += (char)read;
//				}
//				Document xmldom = commonUtil.convertStringToDocument(tempXmlList);
//				Document xmldom2 = commonUtil.convertStringToDocument(strXML);
//				
//	            NodeList nodeList = xmldom.getElementsByTagName("NODES");
//	            NodeList nodeList2 = xmldom2.getElementsByTagName("NODE");
//	            for (int i=0; i<nodeList2.getLength(); i++) {
//	            	nodeList.item(0).appendChild(xmldom.importNode(nodeList2.item(i), true));
//	            }
//            	osw = new OutputStreamWriter(new FileOutputStream(f));
//            	osw.write(commonUtil.convertDocumentToString(xmldom));
//            	String crlf = System.getProperty("line.separator");
//        		osw.append(crlf+crlf);
//	            
//	            xmlList = strXML;
//	            
//        	} catch(Exception e) {
//        		throw e;
//        	} finally {
//        		if (br != null) {
//        			br.close();
//        		}
//        		if (isr != null) {
//        			isr.close();
//        		}
//        		if (osw != null) {
//        			osw.close();
//        		}
//        	}
//        	
//        	return xmlList;
//        	
//        } else {
//        	OutputStreamWriter osw = null;
//        	try {
//        		osw = new OutputStreamWriter(new FileOutputStream(f));
//        		osw.write(strXML);
//        		String crlf = System.getProperty("line.separator");
//        		osw.append(crlf+crlf);
//        		xmlList = strXML;
//        		
//        	} catch(Exception e) {
//        		throw e;
//        	} finally {
//        		if (osw != null) {
//        			osw.close();
//        		}
//        	}
//            
//            return xmlList;
		
		LOGGER.debug("MOBILE G/W MAIL [POST /ezemail/folders/{folderId}/mails/{messageId}/attachs/users/{userId}] ended.");		
	}
	
	/**
	 * 모바일 G/W 이메일 [POST] 임시저장
	 */
	@RequestMapping(value="/mobile/ezemail/mail-save/users/{userId}", method= RequestMethod.POST, produces="application/json;charset=utf-8")
	public Object mMailSave(HttpServletRequest request, @PathVariable String userId, @RequestBody JSONObject jsonObject, Locale locale) throws Exception {
		LOGGER.debug("MOBILE G/W MAIL [POST /ezemail/mail-save/users/{userId}] started.");
		JSONObject result = new JSONObject();
		
		try{
		
		boolean retryFlag = false;
		int retryCount = 1; //메일 발송 실패 시 재시도 횟수
		long draftUID = 0;
		long sentFolderMessageUID = 0;
		boolean mailSendCompleted = false;
		
		String importance = "3";
		
		String subject = (String) jsonObject.get("subject");
		String to = (String) jsonObject.get("to");
		String cc = (String) jsonObject.get("cc");
		String bcc = (String) jsonObject.get("bcc");
		String textBody = (String) jsonObject.get("textbody");
		String from = (String) jsonObject.get("from");
		String charset = (String) jsonObject.get("charset");
		String htmlbody = (String) jsonObject.get("htmlbody");
		String displayName = (String) jsonObject.get("displayName");
		String stateName = (String) jsonObject.get("stateName");
//		String importance = (String) jsonObject.get("importance");
		
		String realPath = commonUtil.getRealPath(request);

		LOGGER.debug("subject = " + subject + ", to = " + to + ", cc = " + cc + ", bcc = " + bcc + ", textBody = " 
		+ textBody + ", from = " + from + ", charset = " + charset + ", htmlbody = " + htmlbody + ", htmlbody = " + htmlbody
		+ ", displayName = " + displayName + ", stateName = " + stateName); 
				
		String serverName = request.getHeader("x-user-host");
		
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			String domainName = ezCommonService.getTenantConfig("DomainName", info.getTenantId());
			String userEmail = info.getUserId() + "@" + domainName;
		
			SMTPAccess sa = SMTPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.SMTPPort"),
					userEmail, "qwe123!");
		
			String pResult = null;
			IMAPAccess ia = null;
		
			do {
				try {
					ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
							userEmail, "qwe123!", egovMessageSource, locale);
					
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
                            userEmail, "qwe123!", egovMessageSource, locale);                
                    
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
	public Object mMailSend(HttpServletRequest request, @PathVariable String userId, @RequestBody JSONObject jsonObject, Locale locale) {
		LOGGER.debug("MOBILE G/W MAIL [POST /ezemail/mail-send/users/{userId}] started.");
		JSONObject result = new JSONObject();
		
		try{
		boolean retryFlag = false;
		int retryCount = 1; //메일 발송 실패 시 재시도 횟수
		long draftUID = 0;
		long sentFolderMessageUID = 0;
		boolean mailSendCompleted = false;
		
		String importance = "3";
		
		String subject = (String) jsonObject.get("subject");
		String to = (String) jsonObject.get("to");
		String cc = (String) jsonObject.get("cc");
		String bcc = (String) jsonObject.get("bcc");
		String textBody = (String) jsonObject.get("textbody");
		String from = (String) jsonObject.get("from");
		String charset = (String) jsonObject.get("charset");
		String htmlbody = (String) jsonObject.get("htmlbody");
		String displayName = (String) jsonObject.get("displayName");
		String stateName = (String) jsonObject.get("stateName");
//		String importance = (String) jsonObject.get("importance");
		
		String realPath = commonUtil.getRealPath(request);

		LOGGER.debug("subject = " + subject + ", to = " + to + ", cc = " + cc + ", bcc = " + bcc + ", textBody = " 
		+ textBody + ", from = " + from + ", charset = " + charset + ", htmlbody = " + htmlbody + ", htmlbody = " + htmlbody
		+ ", displayName = " + displayName + ", stateName = " + stateName); 
				
		String serverName = request.getHeader("x-user-host");
		
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			String domainName = ezCommonService.getTenantConfig("DomainName", info.getTenantId());
			String userEmail = info.getUserId() + "@" + domainName;
		
			SMTPAccess sa = SMTPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.SMTPPort"),
					userEmail, "qwe123!");
		
			String pResult = null;
			IMAPAccess ia = null;
		
			do {
				try {
					ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
							userEmail, "qwe123!", egovMessageSource, locale);
					
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
							} finally {
								if (draftFolder != null) {
									try {
    								draftFolder.close(true);
									} catch (Exception e) {}
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
	                        } finally {
	                            if (sentFolder != null) {
	                                try {
	                                    sentFolder.close(true);
	                                } catch (Exception e) {}
	                                
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
		        Message oldMessage = null;
		        long uid = 0;
		        
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
//		        	LOGGER.debug("Saving the message");
//		        	
//		    		Boolean isEachMailB = Boolean.parseBoolean(isEachMail.trim());
//		    		
//		    		if (isEachMailB) {
//	                	message.setHeader("X-JMocha-Each-Mail", "true");
//                    }
//		    		if (delaySendTime != ""){
//		    			message.setHeader("Delivery-Date", delaySendTime);
//		    		}
//		    		message.setFlag(Flags.Flag.SEEN, true);
//		    		AppendUID[] uids = ((IMAPFolder)draftFolder).appendUIDMessages(new Message[]{message});
//		    		if (uids != null && uids[0] != null) {
//		    			draftUID = uids[0].uid;
//		    		} 
//		    	
//		            // this deletion code block has been moved here because
//		            // it needs to be kept in Drafts if an error occurs during the above process.
//		            if (oldMessage != null) {
//		            	oldMessage.setFlag(Flags.Flag.DELETED, true);
//		            }
		            
//		        } else if (cmd.equalsIgnoreCase("SEND")) {
		        	LOGGER.debug("Sending the message");
		        	
                    Folder sentFolder = ia.getFolder(egovMessageSource.getMessage("ezEmail.t99000026", locale));
                    		        
//					String strCheckReadUrl = ""; //외부메일수신확인 관련 URL. GetSystemConfigValue("APPREADCHECK_URL").ToString();
//			        Boolean isEachMailB = Boolean.parseBoolean(isEachMail.trim());
			        
//			        if (!displayName.equals("")) {
//		            	message.setHeader("X-JMocha-EXT-SENDERNAME", MimeUtility.encodeText(displayName, "UTF-8", null));
//		            }
			                            
                    message.setFlag(Flags.Flag.SEEN, true);
		            
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
//			                if (oldMessage != null) {
//			                	oldMessage.setFlag(Flags.Flag.DELETED, true);
//			                }
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
                            userEmail, "qwe123!", egovMessageSource, locale);                
                    
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
	public Object mMailRead(HttpServletRequest request, @PathVariable String folderId, @PathVariable String messageId, @PathVariable String userId, Locale locale) throws Exception {
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
			
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userEmail, "qwe123!", egovMessageSource, locale);
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
					LOGGER.error("Message not found. uid=" + uid);
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
					
					bodyInfoList = ezEmailUtil.getBodyInfo(message, folderId, uid, -1, null, false, locale);
					double size = Double.parseDouble(bodyInfoList.get(2));
					String strSize = ezEmailUtil.getSizeWithUnit(size);
					pAttachListHtmlSub = " - <b>" + bodyInfoList.get(3) + egovMessageSource.getMessage("ezEmail.t180", locale) + "</b>(" + strSize + ")";
					
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
									userEmail, "qwe123!");
							
							processAutoMDN(sa, message, userEmail, userVO.getDisplayName());
						}
						else {
							LOGGER.debug("MDNSentFlag is set");
						}
					}
				}
				f.close(true);
				
			}
			
			mail.put("fromStr", fromStr);
			mail.put("fromEmail", fromEmail);
			mail.put("toStr", toStr);
			mail.put("toHiddenStr", toHiddenStr);
			mail.put("ccStr", ccStr);
			mail.put("ccHiddenStr", ccHiddenStr);
			mail.put("bccStr", bccStr);
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
			mail.put("htmlBody", bodyInfoList.get(0));
			mail.put("pAttachListHtml", bodyInfoList.get(1));
			mail.put("pAttachListHtmlSub", pAttachListHtmlSub);
			mail.put("isAttach", bodyInfoList.get(4));
			
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
	public Object mMailFileDown(HttpServletRequest request, HttpServletResponse response, 
			@PathVariable String folderId, @PathVariable String messageId, @PathVariable String strIndex, @PathVariable String userId, Locale locale) throws Exception {
		LOGGER.debug("MOBILE G/W MAIL [GET /ezemail/folders/{folderId}/mails/{messageId}/attach/{index}/users/{userId}] started.");
		
		IMAPAccess ia = null;
		JSONObject result = new JSONObject();
		
		try {
		
		// get user credentials
		String serverName = request.getHeader("x-user-host");
		MCommonVO info = mOptionService.commonInfo(serverName, userId);
		String domainName = ezCommonService.getTenantConfig("DomainName", info.getTenantId());
		String userEmail = info.getUserId() + "@" + domainName;
		
		LOGGER.debug("userEmail=" + userEmail);
		
		// retrieve the passed in parameters
		String folderPath = folderId;
		String strUid = messageId;
		long uid = strUid != null ? Long.parseLong(strUid) : 0;
		String filename = request.getParameter("filename");
		
		
		
		LOGGER.debug("folderPath=" + folderPath + ",uid=" + uid + ",filename=" + filename);
		
		if (folderPath == null || strUid == null || filename == null) {
			LOGGER.debug("downloadAttach illegal arguments.");
			
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
			
//			return result;
		}
		
		int index = -1;
		
		if(strIndex != null){
			index = Integer.parseInt(strIndex);
		}
		LOGGER.debug("index=" + index);
		
		
		byte[]out = null;
		
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userEmail, "qwe123!", egovMessageSource, locale);
	
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
					Part part = null;
					if (index == -1) {
						part = message;
					}
					else {
						part = ezEmailUtil.getAttachPart(message, index);
					}
					
					if (part == null) {
						LOGGER.error("AttachPart not found. AttachPartIndex=" + index);
					} else {
						response.setContentType(part.getContentType());
						
						filename = CommonUtil.getEncodedFileNameForDownload(request.getHeader("User-Agent"), filename);						
						response.addHeader("content-disposition", "attachment; filename=\"" + filename + "\"");
						LOGGER.debug("content-disposition=" + "attachment; filename=\"" + filename + "\"");
						
						InputStream input = null;
						OutputStream output = null;
						
						try {
							input = part.getInputStream();
							output = response.getOutputStream();
							
							org.apache.commons.io.IOUtils.copy(input, output);
							
							byte[] buffer = new byte[4096];
							int byteRead;
							
							while ((byteRead = input.read(buffer)) != -1) {
								output.write(buffer, 0, byteRead);
							}
						} catch(IOException e) {
						} finally {
							if (ia != null) {
								ia.close();
							}
							if (input != null) {
								try { input.close(); } catch (IOException e1) {}
							}
							if (output != null) {
								try { output.flush(); } catch (IOException e1) {}
								try { output.close(); } catch (IOException e1) {}
							}
						}
						
					}
				}
			}
			
			result.put("status", "success");
			result.put("code", 0);			
			result.put("data", out);
			
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
		LOGGER.debug("MOBILE G/W MAIL [GET /ezemail/folders/{folderId}/mails/{messageId}/attach/{index}/users/{userId}] ended.");
		return result;		
	}
	
	/**
	 * 모바일 G/W 이메일 [PUT] 메일 이동 
	 */
	@RequestMapping(value="/mobile/ezemail/folders/{folderId}/mails/{messageId}/move/users/{userId}", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
	public Object mMailMove(HttpServletRequest request, @PathVariable String folderId, @PathVariable String messageId, @PathVariable String userId,
			@RequestBody JSONObject jsonobject, Locale locale) throws Exception {
		LOGGER.debug("MOBILE G/W MAIL [PUT /ezemail/folders/{folderId}/mails/{messageId}/move/users/{userId}] started.");
		
		JSONObject result = new JSONObject();
		
		IMAPAccess ia = null;
		
		try {
//			List<String> userIdAndPassword = commonUtil.getUserIdAndPassword(loginCookie);
//			String password = userIdAndPassword.get(1);
			
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
			
//			LoginVO userInfo = commonUtil.userInfo(loginCookie);
//	        String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
//	        String userEmail = userInfo.getId() + "@" + domainName;
//			
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			String domainName = ezCommonService.getTenantConfig("DomainName", info.getTenantId());
			String userEmail = info.getUserId() + "@" + domainName;
			
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userEmail, "qwe123!", egovMessageSource, locale);
					
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
			@RequestBody JSONObject jsonobject, Locale locale) throws Exception {
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
			
			LOGGER.debug("userEmail=" + userEmail);
		        
			String isRead = (String) jsonobject.get("isRead");
			//TRUE면 읽은 상태로  FALSE면 읽지 않은 상태로 변경.			
	
			LOGGER.debug("folderId=" + folderId);		
								
				try {
					ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
							userEmail, "qwe123!", egovMessageSource, locale);
							
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
	public Object mMailDelete(HttpServletRequest request, @PathVariable String folderId, @PathVariable String messageId, @PathVariable String userId ,Locale locale) throws Exception {
		LOGGER.debug("MOBILE G/W MAIL [DELETE /ezemail/folders/{folderId}/mails/{messageId}/users/{userId}] started.");
		
				
		JSONObject result = new JSONObject();
		
		IMAPAccess ia = null;
		// get user credentials
		try{
			
			boolean permanentlyDelete = false;

			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			String domainName = ezCommonService.getTenantConfig("DomainName", info.getTenantId());
			String userEmail = info.getUserId() + "@" + domainName;
					
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
					userEmail, "qwe123!", egovMessageSource, locale);
						
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
	
	private String getReceiverHTML(String name, String address){
		return "<span style='cursor:pointer' title='" + (address==null?"":EgovStringUtil.getSpclStrCnvr(address)) + "' onclick='show_personinfo(\"" + address + "\")'>" + (name==null?"":EgovStringUtil.getSpclStrCnvr(name)) + "</span>";
	}
	
	private void processAutoMDN(SMTPAccess sa, Message message, String myEmailAddress, String myName) {
		LOGGER.debug("processAutoMDN started.");
		
		try {		
			String fromEmailAddress = ezEmailUtil.getFromEmailAddressOfMessage(message);
			
			LOGGER.debug("myEmailAddress=" + myEmailAddress + ",fromEmailAddress=" + fromEmailAddress);
			
			int atSignIndex = fromEmailAddress.indexOf("@");
			
			if (fromEmailAddress.equals("") || atSignIndex == -1) {
				LOGGER.debug("invalid fromEmailAddress=" + fromEmailAddress);
				return;
			}
			
			String fromEmailDomain = fromEmailAddress.substring(atSignIndex + 1);
			String myEmailDomain = myEmailAddress.substring(myEmailAddress.indexOf("@") + 1);
			
			LOGGER.debug("fromEmailDomain=" + fromEmailDomain + ",myEmailDomain=" + myEmailDomain);
			
			if (!fromEmailDomain.equalsIgnoreCase(myEmailDomain)) {
				LOGGER.debug("different domain");
				LOGGER.debug("processAutoMDN ended.");
				return;
			}
									
			String[] messageIds = message.getHeader("Message-ID");
			String[] mdnHeaders = message.getHeader("Disposition-Notification-To");
			
			if (messageIds != null && mdnHeaders != null) {				
				LOGGER.debug("Sending an MDN...");
											
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
		
		LOGGER.debug("processAutoMDN ended.");
	}
	
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
	 * 모바일 G/W 이메일 [put] method sample
	 */
//	@RequestMapping(value="/ezMAIL/{MAILid}/gw-testUpdate/{id}", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
//	public void testUpdate(@PathVariable String MAILid, @PathVariable String id, @RequestBody LoginVO loginVO) throws Exception {		
//		LOGGER.debug("gw-testUpdate started.");
//		
//		System.out.println(loginVO.getIp());
//				
//		LoginVO vo = new LoginVO();
//		vo.setTenantId(0);
//		vo.setId(id);
//		vo.setIp(loginVO.getIp());
//		
//		loginService.updateUser(vo);
//		
//		LOGGER.debug("gw-testUpdate ended.");		
//	}
}