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
import java.util.regex.Matcher;
import java.util.regex.Pattern;

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

import com.sun.mail.imap.IMAPFolder;
import com.sun.mail.imap.IMAPMessage;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.logic.IMAPAccess;
import egovframework.ezEKP.ezEmail.util.EzEmailUtil;
import egovframework.ezMobile.ezEmail.vo.MEmailFolderVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
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
		
		String[] data = bodyData.split("&");
		String folderId = URLDecoder.decode(data[0].split("=")[1],"UTF-8");
		String start = data[1].split("=")[1];
		String end = data[2].split("=")[1];
		String search = "";
		String jsonMessages = "";
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
	            + ",folderId=" + folderId + ",start=" + start + ",end=" + end);
        
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
	
}
