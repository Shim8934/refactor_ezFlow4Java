package egovframework.ezEKP.ezEmail.web;

import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Properties;
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

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
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
import org.w3c.dom.NodeList;

import com.sun.mail.imap.IMAPFolder;
import com.sun.mail.imap.IMAPMessage;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezEmail.logic.IMAPAccess;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezEmail.util.EzEmailUtil;
import egovframework.ezEKP.ezEmail.vo.MailGeneralVO;
import egovframework.let.utl.fcc.service.CommonUtil;

/** 
 * @Description [Controller] 메일 리스트
 * @author 오픈솔루션팀 이동호
 * @Modification Information
 *
 *    수정일        수정자         수정내용
 *    ----------    ------    -------------------
 *    2016.04.14    이동호    신규작성
 *
 * @see
 */

@Controller
public class EzEmailMailListController {
	
    private static final Logger logger = LoggerFactory.getLogger(EzEmailMailListController.class);
    
	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;

    @Resource(name="egovMessageSource")
    private EgovMessageSource egovMessageSource;    

    @Resource(name="EzEmailService")
    private EzEmailService ezEmailService;        
	
	@Autowired
	private EzEmailUtil ezEmailUtil;
    
    /**
	 * 메일 리스트화면 호출 함수
	 */
	@RequestMapping("/ezEmail/mailList.do")
	public String showMailList(@CookieValue("loginCookie") String loginCookie, 
			Locale locale,
			HttpServletRequest request,
			Model model) throws Exception {
		logger.debug("showMailList started");
		
		// get user credentials
		List<String> userIdAndPassword = commonUtil.getUserIdAndPassword(loginCookie);
		String userId = userIdAndPassword.get(0);
		
		// retrieve the passed in parameters
		String dispname = request.getParameter("dispname");
		String url = request.getParameter("url");
		url = (url != null) ? url : "INBOX";
		
		logger.debug("dispname=" + dispname + ",url=" + url);
				
		String folderName = egovMessageSource.getMessage("ezEmail.t644", locale);
		String folderType = "";
		String userLang = "1";
		String domainName = config.getProperty("config.DomainName");
		String useEditor = config.getProperty("config.EDITOR");
		String useOcs = config.getProperty("config.USE_OCS");
		boolean isSentItems = false;
		
		if (dispname != null) {
			folderName = dispname;
		}
		
		if (folderName.equals(egovMessageSource.getMessage("ezEmail.t645", locale))) {
			folderType = "sent";
			isSentItems = true;
		}
		else if (folderName.equals(egovMessageSource.getMessage("ezEmail.t646", locale))) {
			folderType = "draft";
		}
		else if (folderName.equals(egovMessageSource.getMessage("ezEmail.t647", locale))) {
			folderType = "delete";
		}
		
		// retrieve the mail general settings from DB.
		MailGeneralVO mailGeneral = null;
		List<MailGeneralVO> mailGeneralList = ezEmailService.getMailGeneral(userId);
		
		mailGeneral = mailGeneralList.get(0);
		
		logger.debug("userId=" + userId + ",mailGeneral=" + mailGeneral);		
		
		// set model
		model.addAttribute("folderName", folderName);
		model.addAttribute("url", url);
		model.addAttribute("folderType", folderType);
		model.addAttribute("isSentItems", isSentItems);
		model.addAttribute("userLang", userLang);
		model.addAttribute("userId", userId);
		model.addAttribute("domainName", domainName);
		model.addAttribute("mailGeneral", mailGeneral);
		model.addAttribute("useEditor", useEditor);
		model.addAttribute("useOcs", useOcs);
		
		logger.debug("showMailList ended");
		
		return "ezEmail/mailList";
	}
	
	/**
	 * 메일 리스트 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailGetList.do",method=RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String getMailList(@CookieValue("loginCookie") String loginCookie, @RequestBody String bodyData, Locale locale, Model model) throws Exception {
		logger.debug("getMailList started");		
		logger.debug("bodyData=" + bodyData);
		
		// get user credentials
		List<String> userIdAndPassword = commonUtil.getUserIdAndPassword(loginCookie);
		String userId = userIdAndPassword.get(0);
		String password = userIdAndPassword.get(1);		
		
		Document doc = commonUtil.convertStringToDocument(bodyData);
		String folderId = doc.getElementsByTagName("FOLDERID").item(0).getTextContent();
		String inboxName = egovMessageSource.getMessage("ezEmail.t644", locale);
		folderId = folderId.equals(inboxName) ? "INBOX" : folderId;
		String sortType = doc.getElementsByTagName("SORTTYPE").item(0).getTextContent();
		String start = doc.getElementsByTagName("START").item(0).getTextContent();
		String end = doc.getElementsByTagName("END").item(0).getTextContent();
		String search = doc.getElementsByTagName("SEARCH").item(0).getTextContent();
		String viewSelectIndex = doc.getElementsByTagName("VIEWSELECTINDEX").item(0).getTextContent();
		
		logger.debug("folderId=" + folderId + ",sortType=" + sortType + ",start=" + start + ",end=" + end
						+ ",search=" + search + ",viewSelectIndex=" + viewSelectIndex);
		
		String returnData = "";
		
		IMAPAccess ia = null;
		
		try {
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userId + "@" + config.getProperty("config.DomainName"), password, egovMessageSource, locale);
					
			Folder folder = ia.getFolder(folderId);		
			folder.open(Folder.READ_ONLY);
	        UIDFolder uidFolder = (UIDFolder)folder;
			
			StringBuilder sb = new StringBuilder();
			sb.append("<maillist><contentrange>").append(start).append("-").append(end).append("</contentrange>");
			
			Message[] messages = null; 
			boolean isUnreadOnly = false;
			
			if (sortType.indexOf("\"urn:schemas:httpmail:read\" = false") >= 0) {
				isUnreadOnly = true;
			}
					
			logger.debug("isUnreadOnly=" + isUnreadOnly);
			
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
			
			String sortTypeSpecifier = null;
			boolean isAscending = sortType.endsWith("ASC") ? true : false;
			
			// subject
			if (sortType.indexOf(" ORDER BY \"http://schemas.microsoft.com/mapi/proptag/x0e1d001f\"") >= 0) {
				sortTypeSpecifier = "subject";
			}
			// sender
			else if (sortType.indexOf(" ORDER BY \"http://schemas.microsoft.com/mapi/sent_representing_name\"") >= 0) {
				sortTypeSpecifier = "sender";
			}
			// recipient
			else if (sortType.indexOf(" ORDER BY \"urn:schemas:httpmail:displayto\"") >= 0) {
				sortTypeSpecifier = "recipient";
			}
			// attachment
			else if (sortType.indexOf(" ORDER BY \"urn:schemas:httpmail:hasattachment\"") >= 0) {
				sortTypeSpecifier = "attachment";
			}
			// read/unread
			else if (sortType.indexOf(" ORDER BY \"http://schemas.microsoft.com/exchange/smallicon\"") >= 0) {
				sortTypeSpecifier = "readFlag";
			}
			// bookmark
			else if (sortType.indexOf(" ORDER BY \"http://schemas.microsoft.com/mapi/proptag/x10900003\"") >= 0) {
				sortTypeSpecifier = "flag";
			}
			// importance
			else if (sortType.indexOf(" ORDER BY \"http://schemas.microsoft.com/exchange/x-priority-long\"") >= 0) {
				sortTypeSpecifier = "importance";
			}
			// size
			else if (sortType.indexOf(" ORDER BY \"http://schemas.microsoft.com/mapi/proptag/x0e080003\"") >= 0) {
				sortTypeSpecifier = "size";
			}
			// received date
			else if (sortType.indexOf(" ORDER BY \"urn:schemas:httpmail:datereceived\"") >= 0
					|| sortType.indexOf(" ORDER BY \"http://schemas.microsoft.com/exchange/date-iso\"") >= 0) {
				sortTypeSpecifier = "receivedDate";
			}		
			
			// sort the messages
			if (sortTypeSpecifier != null) {
				ezEmailUtil.sortMessages(folder, messages, sortTypeSpecifier, isAscending);
			}
							
			int startNo = Integer.parseInt(start);
			int endNo = Math.min(Integer.parseInt(end), messages.length - 1);
			
			logger.debug("startNo=" + startNo + ",endNo=" + endNo);
			
			if (startNo <= endNo) {
				Message[] fetchMessages = Arrays.copyOfRange(messages, startNo, endNo + 1);
				FetchProfile fp = new FetchProfile();
				
				// subject or sender or recipient
				if (sortType.indexOf(" ORDER BY \"http://schemas.microsoft.com/mapi/proptag/x0e1d001f\"") >= 0
						|| sortType.indexOf(" ORDER BY \"http://schemas.microsoft.com/mapi/sent_representing_name\"") >= 0
						|| sortType.indexOf(" ORDER BY \"urn:schemas:httpmail:displayto\"") >= 0) {
					// pre-fetch the remaining fields after pre-fetching fields for sorting
					fp.add(UIDFolder.FetchProfileItem.UID);
					fp.add("X-Priority");
					fp.add(FetchProfile.Item.CONTENT_INFO);
					fp.add(FetchProfile.Item.FLAGS);				
				}
				// attachment
				else if (sortType.indexOf(" ORDER BY \"urn:schemas:httpmail:hasattachment\"") >= 0) {
					// pre-fetch the remaining fields after pre-fetching fields for sorting
					fp.add(UIDFolder.FetchProfileItem.UID);
					fp.add("X-Priority");
					fp.add(FetchProfile.Item.ENVELOPE);
					fp.add(FetchProfile.Item.SIZE);
					fp.add(FetchProfile.Item.FLAGS);				
				}
				// read/unread or bookmark
				else if (sortType.indexOf(" ORDER BY \"http://schemas.microsoft.com/exchange/smallicon\"") >= 0
							|| sortType.indexOf(" ORDER BY \"http://schemas.microsoft.com/mapi/proptag/x10900003\"") >= 0) {
					// pre-fetch the remaining fields after pre-fetching fields for sorting
					fp.add(UIDFolder.FetchProfileItem.UID);
					fp.add("X-Priority");
					fp.add(FetchProfile.Item.CONTENT_INFO);
					fp.add(FetchProfile.Item.ENVELOPE);
					fp.add(FetchProfile.Item.SIZE);				
				}
				// importance (X-Priority) or received date or received date in sent mailbox
				else if (sortType.indexOf(" ORDER BY \"http://schemas.microsoft.com/exchange/x-priority-long\"") >= 0
							|| sortType.indexOf(" ORDER BY \"urn:schemas:httpmail:datereceived\"") >= 0
							|| sortType.indexOf(" ORDER BY \"http://schemas.microsoft.com/exchange/date-iso\"") >= 0) {						
					// pre-fetch the remaining fields after pre-fetching fields for sorting
					fp.add(UIDFolder.FetchProfileItem.UID);
					fp.add("X-Priority");
					fp.add(FetchProfile.Item.CONTENT_INFO);
					fp.add(FetchProfile.Item.ENVELOPE);
					fp.add(FetchProfile.Item.SIZE);
					fp.add(FetchProfile.Item.FLAGS);				
				}
				// size
				else if (sortType.indexOf(" ORDER BY \"http://schemas.microsoft.com/mapi/proptag/x0e080003\"") >= 0) {
					// pre-fetch the remaining fields after pre-fetching fields for sorting
					fp.add(UIDFolder.FetchProfileItem.UID);
					fp.add("X-Priority");
					fp.add(FetchProfile.Item.CONTENT_INFO);
					fp.add(FetchProfile.Item.ENVELOPE);
					fp.add(FetchProfile.Item.FLAGS);				
				}
				else {
					fp.add(UIDFolder.FetchProfileItem.UID);
					fp.add("X-Priority");
					fp.add(FetchProfile.Item.CONTENT_INFO);
					fp.add(FetchProfile.Item.ENVELOPE);
					fp.add(IMAPFolder.FetchProfileItem.INTERNALDATE);
					fp.add(FetchProfile.Item.SIZE);
					fp.add(FetchProfile.Item.FLAGS);
				}
				
				fp.add("Subject");
				fp.add("From");
				fp.add("To");
				
				folder.fetch(fetchMessages, fp);					
			}
			
			for (int i = startNo; i <= endNo; i++) {
				Message message = messages[i];
				
				sb.append("<response>");
				sb.append(String.format("<href><![CDATA[%s/%s]]></href>", folderId, uidFolder.getUID(message)));
				sb.append("<fromemail><![CDATA[]]></fromemail>");
				
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
				sb.append(String.format("<importance><![CDATA[%d]]></importance>", importance));	
				
				// Flagged is used for bookmark
				int flagged = 0;
				if (message.isSet(Flags.Flag.FLAGGED)) {
					flagged = 1;
				}
				sb.append(String.format("<flag><![CDATA[%d]]></flag>", flagged));
				
				// attachment
				boolean isAttached = IMAPAccess.hasAttachment(message);
				int attached = isAttached ? 1 : 0;
				sb.append(String.format("<attach><![CDATA[%d]]></attach>", attached));
				
				String addressStr = "";
				Address[] addresses = null;
				if (!viewSelectIndex.equals("3")) {
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
				sb.append(String.format("<sender><![CDATA[%s]]></sender>", addressStr));
							
				// subject
				String subject = message.getSubject();
				
				if (subject != null && !subject.equals("")) {
					String[] rawHeaders = message.getHeader("subject");
					String rawHeader = rawHeaders[0];
					
					if (!ezEmailUtil.isPureAscii(rawHeader)) {
						byte[] rawBytes = rawHeader.getBytes("iso-8859-1");
						
						subject = ezEmailUtil.decodeNonAsciiBytes(rawBytes);
					}
				}
				
				subject = (subject != null) ? subject : "";
							
				if (viewSelectIndex.equals("1")) {
					((IMAPMessage)message).setPeek(true);
					List<String> bodyInfoList = ezEmailUtil.getBodyInfo(message, folderId, uidFolder.getUID(message), -1, null, false);
					String htmlBody = bodyInfoList.get(0);
					
					Pattern p = Pattern.compile("\\s*<(head|title|style)(.*?)<\\/(head|title|style)>\\s*", Pattern.CASE_INSENSITIVE | Pattern.DOTALL);
					Matcher m = p.matcher(htmlBody);
					htmlBody = m.replaceAll("");
					
					p = Pattern.compile("\\s*<.*?>\\s*", Pattern.CASE_INSENSITIVE | Pattern.DOTALL);
					m = p.matcher(htmlBody);
					htmlBody = m.replaceAll("").trim();
	
					int minLen = Math.min(200, htmlBody.length());
					htmlBody = htmlBody.substring(0, minLen);
					
					String preview = "<br/><span style='font-weight:normal;font-size:9pt;color:gray'>" + htmlBody + "</span>";
					sb.append(String.format("<subject><![CDATA[%s]]></subject>", subject + preview));
				}
				else {
					sb.append(String.format("<subject><![CDATA[%s]]></subject>", subject));
				}
				
				// received date
				Date receivedDate = message.getReceivedDate();
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");					
				sb.append(String.format("<receivedt><![CDATA[%s]]></receivedt>", sdf.format(receivedDate)));
				
				// size
				sb.append(String.format("<size><![CDATA[%d]]></size>", message.getSize()));
				
				// read/unread
				int readFlag = message.isSet(Flags.Flag.SEEN) ? 1 : 0;
				sb.append(String.format("<read><![CDATA[%d]]></read>", readFlag));
							
				if (message.isSet(Flags.Flag.ANSWERED)) {
					sb.append("<contentclass><![CDATA[REPLY]]></contentclass>");
				}
				else {
					boolean isForwarded = ezEmailUtil.hasForwardedFlag(message);
					
					if (isForwarded) {
						sb.append("<contentclass><![CDATA[FORWARD]]></contentclass>");
					}
					else {
						sb.append("<contentclass><![CDATA[IPM.Note]]></contentclass>");
					}
				}
				
				sb.append("</response>");
			}
			sb.append(String.format("<CONTENTRANGE><![CDATA[rows;%s;%s;total;%d;BoxTCount;%d;BoxUCount;%d;]]></CONTENTRANGE>", 
					start, end, messages.length, folder.getMessageCount(), folder.getUnreadMessageCount()));
			sb.append("</maillist>");
		      
			folder.close(false);
			
//			String returnData = "<maillist><contentrange>0-29</contentrange><response><href><![CDATA[AAMkAGJiNjA1ZTYwLWU3NjItNDA1Yi05NWNhLWU0MjdjYTYwODhiYwBGAAAAAAD0DJQBik2KSIR3MR2XIUsMBwAC5Z0TOjuhQ5Z/reykkEsxAAAAAAEMAAAC5Z0TOjuhQ5Z/reykkEsxAAAZAx8FAAA=]]></href><fromemail><![CDATA[]]></fromemail><importance><![CDATA[1]]></importance><flag><![CDATA[0]]></flag><attach><![CDATA[0]]></attach><sender><![CDATA[ 이동호(iPhone) ]]></sender><subject><![CDATA[Re: Local Delivery 문제 해결]]></subject><receivedt><![CDATA[2016-02-17 18:12]]></receivedt><size><![CDATA[9962]]></size><read><![CDATA[1]]></read><contentclass><![CDATA[IPM.Note]]></contentclass></response><response><href><![CDATA[AAMkAGJiNjA1ZTYwLWU3NjItNDA1Yi05NWNhLWU0MjdjYTYwODhiYwBGAAAAAAD0DJQBik2KSIR3MR2XIUsMBwAC5Z0TOjuhQ5Z/reykkEsxAAAAAAEMAAAC5Z0TOjuhQ5Z/reykkEsxAAAZAx8EAAA=]]></href><fromemail><![CDATA[]]></fromemail><importance><![CDATA[2]]></importance><flag><![CDATA[0]]></flag><attach><![CDATA[0]]></attach><sender><![CDATA[Microsoft Outlook]]></sender><subject><![CDATA[사서함이 거의 꽉 찼습니다.]]></subject><receivedt><![CDATA[2016-02-17 18:07]]></receivedt><size><![CDATA[10299]]></size><read><![CDATA[0]]></read><contentclass><![CDATA[IPM.Note.StorageQuotaWarning.Warning]]></contentclass></response><response><href><![CDATA[AAMkAGJiNjA1ZTYwLWU3NjItNDA1Yi05NWNhLWU0MjdjYTYwODhiYwBGAAAAAAD0DJQBik2KSIR3MR2XIUsMBwAC5Z0TOjuhQ5Z/reykkEsxAAAAAAEMAAAC5Z0TOjuhQ5Z/reykkEsxAAAZAx8DAAA=]]></href><fromemail><![CDATA[]]></fromemail><importance><![CDATA[1]]></importance><flag><![CDATA[0]]></flag><attach><![CDATA[0]]></attach><sender><![CDATA[이동호]]></sender><subject><![CDATA[읽음: Local Delivery 문제 해결]]></subject><receivedt><![CDATA[2016-02-17 17:30]]></receivedt><size><![CDATA[10803]]></size><read><![CDATA[1]]></read><contentclass><![CDATA[REPORT.IPM.Note.IPNRN]]></contentclass></response><response><href><![CDATA[AAMkAGJiNjA1ZTYwLWU3NjItNDA1Yi05NWNhLWU0MjdjYTYwODhiYwBGAAAAAAD0DJQBik2KSIR3MR2XIUsMBwAC5Z0TOjuhQ5Z/reykkEsxAAAAAAEMAAAC5Z0TOjuhQ5Z/reykkEsxAAAZAx8BAAA=]]></href><fromemail><![CDATA[]]></fromemail><importance><![CDATA[1]]></importance><flag><![CDATA[0]]></flag><attach><![CDATA[1]]></attach><sender><![CDATA[이동호]]></sender><subject><![CDATA[FW: 폼빌더 사용자 매뉴얼]]></subject><receivedt><![CDATA[2016-02-16 17:57]]></receivedt><size><![CDATA[2783134]]></size><read><![CDATA[1]]></read><contentclass><![CDATA[REPLY]]></contentclass></response><CONTENTRANGE><![CDATA[rows;0;29;total;4;BoxTCount;4;BoxUCount;1;]]></CONTENTRANGE></maillist>";
			returnData = sb.toString();
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (ia != null) {
				ia.close();
			}
		}
		
		logger.debug("getMailList ended");
		
		return returnData;		
	}
	
	/**
	 * 메일 삭제 실행 함수
	 */
	@RequestMapping(value="/ezEmail/mailDelete.do",method=RequestMethod.POST)
	@ResponseBody
	public String mailDelete(@CookieValue("loginCookie") String loginCookie, 
			@RequestParam("cmd") String cmd,
			@RequestBody String bodyData,
			Locale locale, Model model) throws Exception {
		logger.debug("mailDelete started");
		logger.debug("cmd=" + cmd);
		logger.debug("bodyData=" + bodyData);
		
		String returnData = "OK";
		
		// get user credentials
		List<String> userIdAndPassword = commonUtil.getUserIdAndPassword(loginCookie);
		String userId = userIdAndPassword.get(0);
		String password = userIdAndPassword.get(1);
		
		Document doc = commonUtil.convertStringToDocument(bodyData);
		String uniqueId = doc.getElementsByTagName("UNIQUEID").item(0).getTextContent();	
		
		String folderId = null;
		long[] uids = null;
		if (cmd.equalsIgnoreCase("ALL")) {
			folderId = uniqueId;
		}
		else {
			if (uniqueId.endsWith(",")) {
				uniqueId = uniqueId.substring(0, uniqueId.length() - 1);
			}
			String[] folderAndMsgIdArray = uniqueId.split(",");
			folderId = folderAndMsgIdArray[0].split("/")[0];			
			uids = new long[folderAndMsgIdArray.length];
			for (int i = 0; i < folderAndMsgIdArray.length; i++) {
				String folderAndMsgId = folderAndMsgIdArray[i];
				String msgId = folderAndMsgId.split("/")[1];
				uids[i] = Long.parseLong(msgId);
			}	
		}
		logger.debug("folderId=" + folderId);
		
		IMAPAccess ia = null;
		
		try {
		
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userId + "@" + config.getProperty("config.DomainName"), password, egovMessageSource, locale);
					
			IMAPFolder sourceFolder = (IMAPFolder)ia.getFolder(folderId);		
			sourceFolder.open(Folder.READ_WRITE);		
					
			Message[] deleteMsgs = null;
			if (cmd.equalsIgnoreCase("ALL")) {
				deleteMsgs = sourceFolder.getMessages();
			}
			else {
				deleteMsgs = sourceFolder.getMessagesByUID(uids);
			}
			
			if (cmd.equalsIgnoreCase("BMOVE")) {
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
		
		logger.debug("mailDelete ended");
		
		return returnData;				
	}
	
	/**
	 * 메일 이동/복사 실행 함수
	 */
	@RequestMapping(value="/ezEmail/mailMoveCopyMessage.do")
	@ResponseBody
	public String mailMoveCopyMessage(@CookieValue("loginCookie") String loginCookie, @RequestBody String bodyData, 
			Locale locale, Model model) throws Exception {
		String returnValue = "OK";
		
		IMAPAccess ia = null;
		
		try {
		
			List<String> userIdAndPassword = commonUtil.getUserIdAndPassword(loginCookie);
			String userId = userIdAndPassword.get(0);
			String password = userIdAndPassword.get(1);
			
			logger.debug("bodyData=" + bodyData);
			
			Document doc = commonUtil.convertStringToDocument(bodyData);
			String cmd = doc.getElementsByTagName("CMD").item(0).getTextContent();
			String uniqueId = doc.getElementsByTagName("UNIQUEID").item(0).getTextContent();
			String mfolderId = doc.getElementsByTagName("FOLDERID").item(0).getTextContent();
			
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
			
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userId + "@" + config.getProperty("config.DomainName"), password, egovMessageSource, locale);
					
			IMAPFolder sourceFolder = (IMAPFolder)ia.getFolder(folderId);		
			sourceFolder.open(Folder.READ_WRITE);
			
			Message[] messages = sourceFolder.getMessagesByUID(uids);
			
			IMAPFolder movefolder = (IMAPFolder)ia.getFolder(mfolderId);			
			sourceFolder.copyUIDMessages(messages, movefolder);
			
			if (cmd.equalsIgnoreCase("MOVE")) {
				sourceFolder.setFlags(messages, new Flags(Flags.Flag.DELETED), true);
			}
			
			sourceFolder.close(true);
		
		} catch (Exception e) {
			returnValue = "ERROR : " + e.getMessage();
			e.printStackTrace();
		} finally {
			if (ia != null) {
				ia.close();
			}
		}
		
		return returnValue;
	}
	
	/**
	 * 메일 책갈피 지정 실행 함수
	 */
	@RequestMapping(value="/ezEmail/mailSetFlag.do",method=RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String mailSetFlag(@CookieValue("loginCookie") String loginCookie,
			@RequestBody String bodyData,
			Locale locale, Model model) throws Exception {
		logger.debug("mailSetFlag started");
		logger.debug("bodyData=" + bodyData);
		
		String returnData = "";
		
		// get user credentials
		List<String> userIdAndPassword = commonUtil.getUserIdAndPassword(loginCookie);
		String userId = userIdAndPassword.get(0);
		String password = userIdAndPassword.get(1);
		
		Document doc = commonUtil.convertStringToDocument(bodyData);
		String uniqueId = doc.getElementsByTagName("ITEMID").item(0).getTextContent();	
		
		String folderId = null;
		long[] uids = null;
		
		if (uniqueId.endsWith(";")) {
			uniqueId = uniqueId.substring(0, uniqueId.length() - 1);
		}
		
		String[] folderAndMsgIdArray = uniqueId.split(";");
		folderId = folderAndMsgIdArray[0].split("/")[0];			
		uids = new long[folderAndMsgIdArray.length];
		for (int i = 0; i < folderAndMsgIdArray.length; i++) {
			String folderAndMsgId = folderAndMsgIdArray[folderAndMsgIdArray.length - i - 1];
			String msgId = folderAndMsgId.split("/")[1];
			uids[i] = Long.parseLong(msgId);
		}	
		logger.debug("folderId=" + folderId);		
		
		IMAPAccess ia = null;
		
		try {
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userId + "@" + config.getProperty("config.DomainName"), password, egovMessageSource, locale);
					
			IMAPFolder sourceFolder = (IMAPFolder)ia.getFolder(folderId);		
			sourceFolder.open(Folder.READ_WRITE);		
					
			Message[] msgs = sourceFolder.getMessagesByUID(uids);
			
			for (int i = 0; i < msgs.length; i++) {
				Message msg = msgs[i];
				if (msg.isSet(Flags.Flag.FLAGGED)) {
					msg.setFlag(Flags.Flag.FLAGGED, false);
					returnData = "DEL";
				}
				else {
					msg.setFlag(Flags.Flag.FLAGGED, true);
					returnData = "NEW";
				}
			}
					
			sourceFolder.close(true);
		} catch (Exception e) {
			returnData = "ERROR : " + e.getMessage();
			e.printStackTrace();
		} finally {
			if (ia != null) {
				ia.close();
			}
		}
		
		logger.debug("mailSetFlag ended");
		
		return returnData;				
	}
	
	/**
	 * 메일 읽음 상태 지정 실행 함수
	 */
	@RequestMapping(value="/ezEmail/mailSetReadChange.do",method=RequestMethod.POST,
			produces="text/xml; charset=utf-8")
	@ResponseBody
	public String mailSetReadChange(@CookieValue("loginCookie") String loginCookie,
			@RequestBody String bodyData,
			Locale locale, Model model) throws Exception {
		logger.debug("mailSetReadChange started");
		logger.debug("bodyData=" + bodyData);

		// get user credentials
		List<String> userIdAndPassword = commonUtil.getUserIdAndPassword(loginCookie);
		String userId = userIdAndPassword.get(0);
		String password = userIdAndPassword.get(1);
		
		Document doc = commonUtil.convertStringToDocument(bodyData);
		String isRead = doc.getElementsByTagName("ISREAD").item(0).getTextContent();
		NodeList messageIdList = doc.getElementsByTagName("MESSAGEID");	
		String firstItem = messageIdList.item(0).getTextContent();
		
		String folderId = null;
		folderId = firstItem.split("/")[0];			
		long[] uids = new long[messageIdList.getLength()];
		for (int i = 0; i < messageIdList.getLength(); i++) {
			String item = messageIdList.item(i).getTextContent();
			String msgId = item.split("/")[1];
			uids[i] = Long.parseLong(msgId);
		}	
		logger.debug("folderId=" + folderId);		
		
		String returnData = "<DATA>OK</DATA>";
		
		IMAPAccess ia = null;
		try {
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userId + "@" + config.getProperty("config.DomainName"), password, egovMessageSource, locale);
					
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
		} catch (Exception e) {
			returnData = "<DATA>ERROR</DATA>";
			e.printStackTrace();
		} finally {
			if (ia != null) {
				ia.close();
			}
		}	
		
		logger.debug("mailSetReadChange ended");
		
		return returnData;				
	}
	
	/**
	 * 메일에서 보낸사람 정보 추출 함수
	 */
	@RequestMapping(value="/ezEmail/mailGetFromEmail.do", produces="text/xml; charset=utf-8")
	@ResponseBody
	public String mailGetFromEmail(@CookieValue("loginCookie") String loginCookie,
			HttpServletRequest request, Locale locale, Model model) throws Exception {
		Document xmldom = commonUtil.convertRequestToDocument(request);
		String itemId = xmldom.getElementsByTagName("ITEMID").item(0).getTextContent();
		
		long uid = 0;
		String folderPath = null;
		if (itemId != null) {
			int index = itemId.lastIndexOf("/");
			if (index != -1) {
				folderPath = itemId.substring(0, index);
				uid = Long.parseLong(itemId.substring(index + 1));
			}
		}
		
		if (uid == 0 || folderPath == null || folderPath.trim().equals("")) {
			logger.error("cannot get request data");
			return "ERROR";
		}
		
		List<String> userInfo = commonUtil.getUserIdAndPassword(loginCookie);
		String id = userInfo.get(0);
		String password  = userInfo.get(1);
		IMAPAccess ia = null;
		String resultData = "ERROR";
		try {
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					id+"@"+config.getProperty("config.DomainName"), password, egovMessageSource, locale);
			Folder folder = ia.getFolder(folderPath);
			folder.open(Folder.READ_ONLY);
			Message message = ((IMAPFolder)folder).getMessageByUID(uid);
			
			if (message != null) {
				String name = ((InternetAddress)message.getFrom()[0]).getPersonal();
				String email = ((InternetAddress)message.getFrom()[0]).getAddress();
				
				if (name == null || name.trim().equals("")) {
					name = email;
				}
				
				resultData = name + " <" + email + ">";
			}
			
			folder.close(true);
			
		} catch (MessagingException e) {
			logger.error(e.getMessage());
		} finally {
			if (ia != null) {
				ia.close();
			}
		}
		
		return resultData;
	}
	
	/**
	 * 수신거부 화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailDenial.do")
	public String mailDenial() throws Exception {
		return "ezEmail/mailDenial";
	}
	
	/**
	 * jgw에 수신거부 요청 실행 함수
	 */
	@RequestMapping(value="/ezEmail/mailRequestDenial.do", produces="text/xml; charset=utf-8")
	@ResponseBody
	public String mailRequestDenial(@CookieValue("loginCookie") String loginCookie,
			HttpServletRequest request, Locale locale, Model model) throws Exception {
		String returnData = "<DATA><![CDATA[ERROR]]></DATA>";
		
		List<String> userInfo = commonUtil.getUserIdAndPassword(loginCookie);
		String userId = userInfo.get(0);
		Document xmldom = commonUtil.convertRequestToDocument(request);
		
		NodeList nodes = xmldom.getElementsByTagName("DENIAL");
		
		if (nodes == null || nodes.getLength() == 0) {
			logger.error("cannot get request data");
			return returnData;
		}
		
		StringBuilder sb = new StringBuilder();
		
		userId = userId + "@" + config.getProperty("config.DomainName");
		sb.append("userId=" + URLEncoder.encode(userId, "UTF-8"));
		
		List<String> addresses = new ArrayList<String>();
		
		for (int i=0; i<nodes.getLength(); i++) {
			String address = nodes.item(i).getTextContent();
			InternetAddress internetAddress = new InternetAddress(address);
			String email = internetAddress.getAddress();
			String name = internetAddress.getPersonal();
			
			if (name == null) {
				name = internetAddress.getAddress();
			}
			
			if (email != null) {
				if (!addresses.contains(email)) {
					String displayName = address + " " + egovMessageSource.getMessage("ezEmail.t270", locale);
					sb.append("&displayName=" + URLEncoder.encode(displayName, "UTF-8"));
					sb.append("&rejectId=" + URLEncoder.encode(email, "UTF-8"));
					addresses.add(email);
				}
			}
		}
		
		String inputParams = sb.toString();
		logger.debug("inputParams=" + inputParams);
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaAccess/setRejectRule", inputParams);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(strJson);
		
		if (object.get("resultCode") != null) {
			returnData = "<DATA><![CDATA[" + object.get("resultCode").toString() + "]]></DATA>";
        }
		
		return returnData;
	}
	
}
