package egovframework.ezMobile.ezEmail.web;

import java.net.URLDecoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
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
import javax.mail.MessagingException;
import javax.mail.UIDFolder;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeUtility;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.sun.mail.imap.IMAPFolder;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezEmail.logic.IMAPAccess;
import egovframework.ezEKP.ezEmail.util.EzEmailUtil;
import egovframework.ezMobile.ezEmail.vo.MEmailFolderVO;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@RestController
public class MEmailGWController extends EgovFileMngUtil {

private static final Logger logger = LoggerFactory.getLogger(MEmailGWController.class);
	
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
	
	static final String SUPERPASSWORD = "!p1221612";	
	
	/**
	 * 모바일 G/W 이메일 [put] method sample
	 */
	/*
	 * @RequestMapping(value="/ezMAIL/{MAILid}/gw-testUpdate/{id}", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
	public void testUpdate(@PathVariable String MAILid, @PathVariable String id, @RequestBody LoginVO loginVO) throws Exception {		
		logger.debug("gw-testUpdate started.");
		
		System.out.println(loginVO.getIp());
				
		LoginVO vo = new LoginVO();
		vo.setTenantId(0);
		vo.setId(id);
		vo.setIp(loginVO.getIp());
		
		loginService.updateUser(vo);
		
		logger.debug("gw-testUpdate ended.");		
	}
	*/
    ///////////////////////////////////////////////// sample end /////////////////////////////////////////////////////
	
	/**
	 * 모바일 G/W 이메일 [GET] 왼쪽 슬라이드 메뉴에 편지함 목록 조회, 메일 이동 시 편지함 목록 출력
	 */
	@RequestMapping(value="/ezemail/folders-list/users/{userId}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public List<MEmailFolderVO> mMailFolderList(@PathVariable String userId, @RequestParam(value="folderId", required=false) String folderId) throws Exception {
		logger.debug("MOBILE G/W MAIL [GET /ezemail/folders-list/users/{userId}] started.");
		
//		List<String> userIdAndPassword = commonUtil.getUserIdAndPassword(loginCookie);
//		String password  = userIdAndPassword.get(1);
		
//		LoginVO userInfo = commonUtil.userInfo(loginCookie);
//		String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
//		String userAccount = userInfo.getId() + "@" + domainName;
//		logger.debug("userAccount=" + userAccount);
		
//		String folderId = request.getParameter("folderId");

		logger.debug("folderId=" + folderId);
		
		List<MEmailFolderVO> mailFolderList = new ArrayList<MEmailFolderVO>();
		
		IMAPAccess ia = null;
		
		try {
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					"opensoladmin@svn.opensol2014.com", "qwe123!", egovMessageSource, new Locale("ko_KR"));
			
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
		
		logger.debug("getFolderList ended.");
		logger.debug("MOBILE G/W MAIL [GET /ezemail/folders-list/users/{userId}] ended.");
		
		return mailFolderList;
	}
	
	/**
	 * 모바일 G/W 이메일 [GET] (받은, 보낸,임시,지운,개인,기타) 편지함 리스트
	 */
	@RequestMapping(value="/ezemail/folders/{folderId}/mails/users/{userId}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONArray mMailFolderMailList(@PathVariable String folderId, @PathVariable String userId, 
			@RequestParam(value="start", required=false) String start,
			@RequestParam(value="end", required=false) String end,
			@RequestParam(value="search", required=false) String search) throws Exception {
		logger.debug("MOBILE G/W MAIL [GET /ezemail/folders/{folderId}/mails/users/{userId}] started.");
		
		logger.debug("getMailList started.");				
		
		String jsonMessages = "";
		
		Locale locale = new Locale("ko_KR");
			
		JSONArray messageJsonArray = new JSONArray();
		// get user credentials
		
		boolean senderReceiverFlag = false;
		
//		List<String> userIdAndPassword = commonUtil.getUserIdAndPassword(loginCookie);
//		String password = userIdAndPassword.get(1);		
//		
//        LoginVO userInfo = commonUtil.userInfo(loginCookie);
//        String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
//        String userEmail = userInfo.getId() + "@" + domainName;
        
        String inboxName = egovMessageSource.getMessage("ezEmail.t644", locale);
        String sendName = egovMessageSource.getMessage("ezEmail.t644", locale);
        String tempName = egovMessageSource.getMessage("ezEmail.t644", locale);
		
        folderId = folderId.equals(inboxName) ? "INBOX" : folderId;
        
        senderReceiverFlag = folderId.equals(sendName) ? true : false;
        senderReceiverFlag = folderId.equals(tempName) ? true : false;
        
        logger.debug("userID" + userId+ ",folderId=" + folderId + ",start=" + start + ",end=" + end + "search=" + search);
        
        IMAPAccess ia = null;
        Message[] messages = null;
		try {
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					"rkd1395@svn.opensol2014.com", "qwe123!", egovMessageSource, locale, 40*1000, 20*1000);
					
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
					
					messages = ezEmailUtil.searchFolder(folder, searchField, searchValue, null, null, false, null, isUnreadOnly, false);
				}
			}
			else if (isUnreadOnly) {
				messages = ezEmailUtil.searchFolder(folder, "", "", null, null, false, null, isUnreadOnly, false);
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
			
			jsonMessages = messageJsonArray.toJSONString();
		
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (ia != null) {
				ia.close();
			}
		}
		
		logger.debug("MOBILE G/W MAIL [GET /ezemail/folders/{folderId}/mails/users/{userId}] ended.");		

		return messageJsonArray;
	}
	
	/**
	 * 모바일 G/W 이메일 [POST] 메시지 복사 (전달을 선택한 메일정보 조회)
	 */
	@RequestMapping(value="/ezemail/folders/{folderId}/mails/{messageId}/copy/users/{userId}", method= RequestMethod.POST, produces="application/json;charset=utf-8")
	public void mMailCopy() throws Exception {
		logger.debug("MOBILE G/W MAIL [POST /ezemail/folders/{folderId}/mails/{messageId}/copy/users/{userId}] started.");
		
		logger.debug("MOBILE G/W MAIL [POST /ezemail/folders/{folderId}/mails/{messageId}/copy/users/{userId}] ended.");		
	}
	
	/**
	 * 모바일 G/W 이메일 [GET] 메일 쓰기에 필요한 옵션 정보 조회
	 */
	@RequestMapping(value="/ezemail/mail-write/option", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public void mMailWriteOption() throws Exception {
		logger.debug("MOBILE G/W MAIL [GET /ezemail/mail-write/option] started.");
		
		logger.debug("MOBILE G/W MAIL [GET /ezemail/mail-write/option] ended.");		
	}
	
	/**
	 * 모바일 G/W 이메일 [GET] 서명 조회
	 */
	@RequestMapping(value="/ezemail/sign/users/{userId}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public void mMailSign() throws Exception {
		logger.debug("MOBILE G/W MAIL [GET /ezemail/sign/users/{userId}] started.");
		
		logger.debug("MOBILE G/W MAIL [GET /ezemail/sign/users/{userId}] ended.");		
	}
	
	/**
	 * 모바일 G/W 이메일 [POST] 첨부파일 업로드
	 */
	@RequestMapping(value="/ezemail/folders/{folderId}/mails/{messageId}/attachs/users/{userId}", method= RequestMethod.POST, produces="application/json;charset=utf-8")
	public void mMailFileUpload() throws Exception {
		logger.debug("MOBILE G/W MAIL [POST /ezemail/folders/{folderId}/mails/{messageId}/attachs/users/{userId}] started.");
		
		logger.debug("MOBILE G/W MAIL [POST /ezemail/folders/{folderId}/mails/{messageId}/attachs/users/{userId}] ended.");		
	}
	
	/**
	 * 모바일 G/W 이메일 [POST] 임시저장
	 */
	@RequestMapping(value="/ezemail/mail-save/users/{userId}", method= RequestMethod.POST, produces="application/json;charset=utf-8")
	public void mMailSave() throws Exception {
		logger.debug("MOBILE G/W MAIL [POST /ezemail/mail-save/users/{userId}] started.");
		
		logger.debug("MOBILE G/W MAIL [POST /ezemail/mail-save/users/{userId}] ended.");		
	}
	
	/**
	 * 모바일 G/W 이메일 [POST] 메일발송(send)
	 */
	@RequestMapping(value="/ezemail/mail-send/users/{userId}", method= RequestMethod.POST, produces="application/json;charset=utf-8")
	public void mMailSend() throws Exception {
		logger.debug("MOBILE G/W MAIL [POST /ezemail/mail-send/users/{userId}] started.");
		
		logger.debug("MOBILE G/W MAIL [POST /ezemail/mail-send/users/{userId}] ended.");		
	}
	
	/**
	 * 모바일 G/W 이메일 [GET] 메일 읽기
	 */
	@RequestMapping(value="/ezemail/folders/{folderId}/mails/{messageId}/users/{userId}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public void mMailRead() throws Exception {
		logger.debug("MOBILE G/W MAIL [GET /ezemail/folders/{folderId}/mails/{messageId}/users/{userId}] started.");
		
		logger.debug("MOBILE G/W MAIL [GET /ezemail/folders/{folderId}/mails/{messageId}/users/{userId}] ended.");		
	}
	
	/**
	 * 모바일 G/W 이메일 [GET] 파일 다운로드
	 */
	@RequestMapping(value="/ezemail/folders/{folderId}/mails/{messageId}/attach/{index}/users/{userId}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public void mMailFileDown() throws Exception {
		logger.debug("MOBILE G/W MAIL [GET /ezemail/folders/{folderId}/mails/{messageId}/attach/{index}/users/{userId}] started.");
		
		logger.debug("MOBILE G/W MAIL [GET /ezemail/folders/{folderId}/mails/{messageId}/attach/{index}/users/{userId}] ended.");		
	}
	
	/**
	 * 모바일 G/W 이메일 [PUT] 메일 이동 , 읽은 상태 변경
	 */
	@RequestMapping(value="/ezemail/folders/{folderId}/mails/{messageId}/users/{userId}", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
	public void mMailMove() throws Exception {
		logger.debug("MOBILE G/W MAIL [DELETE /ezemail/folders/{folderId}/mails/{messageId}/users/{userId}] started.");
		
		logger.debug("MOBILE G/W MAIL [DELETE /ezemail/folders/{folderId}/mails/{messageId}/users/{userId}] ended.");		
	}
	
//	/**
//	 * 모바일 G/W 이메일 [PUT] 읽은 상태 변경
//	 */
//	@RequestMapping(value="/ezemail/folders/{folderId}/mails/{messageId}/users/{userId}", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
//	public void mMailStatusChange() throws Exception {
//		logger.debug("MOBILE G/W MAIL [DELETE /ezemail/folders/{folderId}/mails/{messageId}/users/{userId}] started.");
//		
//		logger.debug("MOBILE G/W MAIL [DELETE /ezemail/folders/{folderId}/mails/{messageId}/users/{userId}] ended.");		
//	}
	
	/**
	 * 모바일 G/W 이메일 [DELETE] 메일 삭제
	 */
	@RequestMapping(value="/ezemail/folders/{folderId}/mails/{messageId}/users/{userId}", method= RequestMethod.DELETE, produces="application/json;charset=utf-8")
	public void mMailDelete() throws Exception {
		logger.debug("MOBILE G/W MAIL [DELETE /ezemail/folders/{folderId}/mails/{messageId}/users/{userId}] started.");
		
		logger.debug("MOBILE G/W MAIL [DELETE /ezemail/folders/{folderId}/mails/{messageId}/users/{userId}] ended.");		
	}
	
	/**
	 * 모바일 G/W 이메일 [put] method sample
	 */
//	@RequestMapping(value="/ezMAIL/{MAILid}/gw-testUpdate/{id}", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
//	public void testUpdate(@PathVariable String MAILid, @PathVariable String id, @RequestBody LoginVO loginVO) throws Exception {		
//		logger.debug("gw-testUpdate started.");
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
//		logger.debug("gw-testUpdate ended.");		
//	}
}