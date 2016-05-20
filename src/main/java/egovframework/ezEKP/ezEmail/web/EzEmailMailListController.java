package egovframework.ezEKP.ezEmail.web;

import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Properties;

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
import javax.mail.search.FromStringTerm;
import javax.mail.search.SearchTerm;
import javax.mail.search.SubjectTerm;
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
import org.w3c.dom.NodeList;

import com.sun.mail.imap.IMAPFolder;

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
		
		logger.debug("showMailList ended");
		
		return "ezEmail/mailList";
	}
	
	/**
	 * 메일 리스트 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailGetList.do",method=RequestMethod.POST,
			produces="text/xml; charset=utf-8")
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
		
		IMAPAccess imapAccess = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
				userId + "@" + config.getProperty("config.DomainName"), password, egovMessageSource, locale);
				
		Folder folder = imapAccess.getFolder(folderId);		
		folder.open(Folder.READ_ONLY);
        UIDFolder uidFolder = (UIDFolder)folder;
		
		StringBuilder sb = new StringBuilder();
		sb.append("<maillist><contentrange>").append(start).append("-").append(end).append("</contentrange>");
		
		Message[] messages = folder.getMessages(); 
				
		if (!search.equals("")) {
			int index = search.indexOf("=");
			if (index >= 0) {
				String searchField = search.substring(0, index);
				final String searchValue = search.substring(index + 1);
				
				logger.debug("searchField=" + searchField + ",searchValue=" + searchValue);
				
				SearchTerm sTerm = null; 
						
				if (searchField.equalsIgnoreCase("SUBJECT")) {
					sTerm = new SearchTerm() {
					    public boolean match(Message message) {
					        try {
					        	String subject = message.getSubject();
					        	
					        	
					            if (subject != null && subject.toLowerCase().contains(searchValue.toLowerCase())) {
					                return true;
					            }
					        } 
					        catch (MessagingException e) {
					        }
					        
					        return false;
					    }
					};					
				}
				else if (searchField.equalsIgnoreCase("FROM")) {
					sTerm = new SearchTerm() {
					    public boolean match(Message message) {
				        	String from = ezEmailUtil.getFullFromAddressOfMessage(message);
				            if (from != null & from.toLowerCase().contains(searchValue.toLowerCase())) {
				                return true;
				            }
					        
					        return false;
					    }
					};					
				}
				else if (searchField.equalsIgnoreCase("RECEIVE")) {
					sTerm = new SearchTerm() {
					    public boolean match(Message message) {
					    	if (",<>@".contains(searchValue)) {
					    		return false;
					    	}
					    	
					    	try {
						    	StringBuilder sb = new StringBuilder();
						    	
						    	// retrieve the TO addresses from the message.
								Address[] addresses = message.getRecipients(Message.RecipientType.TO);
								String to = ezEmailUtil.getStringListOfAddresses(addresses);
								
								if (!to.equals("")) {
									sb.append(to);
								}
								
								// retrieve the CC addresses from the message.
								addresses = message.getRecipients(Message.RecipientType.CC);
								String cc = ezEmailUtil.getStringListOfAddresses(addresses);
								
								if (!cc.equals("")) {
									if (!to.equals("")) {
										sb.append(",");
									}
									
									sb.append(cc);
								}
								
								// retrieve the BCC addresses from the message.
								addresses = message.getRecipients(Message.RecipientType.BCC);
								String bcc = ezEmailUtil.getStringListOfAddresses(addresses);
	
								if (!bcc.equals("")) {
									if (!to.equals("") || !cc.equals("")) {
										sb.append(",");
									}
									
									sb.append(bcc);
								}							
						    	
					            if (sb.toString().toLowerCase().contains(searchValue.toLowerCase())) {
					                return true;
					            }
					    	}
					    	catch (MessagingException e) {					    		
					    	}
					        
					        return false;
					    }
					};					
				}
				
				if (sTerm != null) {
					// pre-fetch fields needed for searching
					FetchProfile fp = new FetchProfile();
					fp.add(FetchProfile.Item.ENVELOPE);
					folder.fetch(messages, fp);
					
					messages = folder.search(sTerm);
				}
			}
		}
		
		// sort the messages
		sortMessages(imapAccess, folder, messages, sortType);
				
		int startNo = messages.length - 1 - Integer.parseInt(start);
		int endNo = Math.max(messages.length - 1 - Integer.parseInt(end), 0);
		logger.debug("startNo=" + startNo + ",endNo=" + endNo);
		if (startNo >= endNo) {
			Message[] fetchMessages = Arrays.copyOfRange(messages, endNo, startNo + 1);
			FetchProfile fp = new FetchProfile();
			
			// subject or sender or recipient
			if (sortType.startsWith(" ORDER BY \"http://schemas.microsoft.com/mapi/proptag/x0e1d001f\"")
					|| sortType.startsWith(" ORDER BY \"http://schemas.microsoft.com/mapi/sent_representing_name\"")
					|| sortType.startsWith(" ORDER BY \"urn:schemas:httpmail:displayto\"")) {
				// pre-fetch the remaining fields after pre-fetching fields for sorting
				fp.add(UIDFolder.FetchProfileItem.UID);
				fp.add("X-Priority");
				fp.add(FetchProfile.Item.CONTENT_INFO);
				fp.add(FetchProfile.Item.FLAGS);				
			}
			// attachment
			else if (sortType.startsWith(" ORDER BY \"urn:schemas:httpmail:hasattachment\"")) {
				// pre-fetch the remaining fields after pre-fetching fields for sorting
				fp.add(UIDFolder.FetchProfileItem.UID);
				fp.add("X-Priority");
				fp.add(FetchProfile.Item.ENVELOPE);
				fp.add(FetchProfile.Item.SIZE);
				fp.add(FetchProfile.Item.FLAGS);				
			}
			// read/unread
			else if (sortType.startsWith(" ORDER BY \"http://schemas.microsoft.com/exchange/smallicon\"")) {
				// pre-fetch the remaining fields after pre-fetching fields for sorting
				fp.add(UIDFolder.FetchProfileItem.UID);
				fp.add("X-Priority");
				fp.add(FetchProfile.Item.CONTENT_INFO);
				fp.add(FetchProfile.Item.ENVELOPE);
				fp.add(FetchProfile.Item.SIZE);				
			}
			// bookmark
			else if (sortType.startsWith(" ORDER BY \"http://schemas.microsoft.com/mapi/proptag/x10900003\"")) {
				// pre-fetch the remaining fields after pre-fetching fields for sorting
				fp.add(UIDFolder.FetchProfileItem.UID);
				fp.add("X-Priority");
				fp.add(FetchProfile.Item.CONTENT_INFO);
				fp.add(FetchProfile.Item.ENVELOPE);
				fp.add(FetchProfile.Item.SIZE);				
			}
			// importance (X-Priority)
			else if (sortType.startsWith(" ORDER BY \"http://schemas.microsoft.com/exchange/x-priority-long\"")) {
				// pre-fetch the remaining fields after pre-fetching fields for sorting
				fp.add(UIDFolder.FetchProfileItem.UID);
				fp.add("X-Priority");
				fp.add(FetchProfile.Item.CONTENT_INFO);
				fp.add(FetchProfile.Item.ENVELOPE);
				fp.add(FetchProfile.Item.SIZE);
				fp.add(FetchProfile.Item.FLAGS);				
			}
			// size
			else if (sortType.startsWith(" ORDER BY \"http://schemas.microsoft.com/mapi/proptag/x0e080003\"")) {
				// pre-fetch the remaining fields after pre-fetching fields for sorting
				fp.add(UIDFolder.FetchProfileItem.UID);
				fp.add("X-Priority");
				fp.add(FetchProfile.Item.CONTENT_INFO);
				fp.add(FetchProfile.Item.ENVELOPE);
				fp.add(FetchProfile.Item.FLAGS);				
			}
			// received date or received date in sent mailbox
			else if (sortType.startsWith(" ORDER BY \"urn:schemas:httpmail:datereceived\"")
					|| sortType.startsWith(" ORDER BY \"http://schemas.microsoft.com/exchange/date-iso\"")) {
				// pre-fetch the remaining fields after pre-fetching fields for sorting
				fp.add(UIDFolder.FetchProfileItem.UID);
				fp.add("X-Priority");
				fp.add(FetchProfile.Item.CONTENT_INFO);
				fp.add(FetchProfile.Item.ENVELOPE);
				fp.add(FetchProfile.Item.SIZE);
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
			
			folder.fetch(fetchMessages, fp);					
		}
		
		for (int i = startNo; i >= endNo; i--) {
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
			boolean isAttached = imapAccess.hasAttachment(message);
//			logger.debug("msgno=" + i + ",isAttached=" + isAttached);
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
					StringBuilder addressBuilder = new StringBuilder();
					for (Address address : addresses) {
						addressStr = ((InternetAddress)address).getPersonal(); // name part
						if (addressStr == null) {
							addressStr = ((InternetAddress)address).getAddress(); // email address part
						}
						else {
							// decoding is needed for the name part
							addressStr = MimeUtility.decodeText(addressStr);
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
			subject = (subject != null) ? subject : "";
			sb.append(String.format("<subject><![CDATA[%s]]></subject>", subject));
			
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
				boolean isForwarded = false;
				String[] flags = message.getFlags().getUserFlags();				
				for (String flag : flags) {
					if (flag.equals("$Forwarded")) {
						isForwarded = true;
						break;
					}
				}
				
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
		imapAccess.close();
		
//		String returnData = "<maillist><contentrange>0-29</contentrange><response><href><![CDATA[AAMkAGJiNjA1ZTYwLWU3NjItNDA1Yi05NWNhLWU0MjdjYTYwODhiYwBGAAAAAAD0DJQBik2KSIR3MR2XIUsMBwAC5Z0TOjuhQ5Z/reykkEsxAAAAAAEMAAAC5Z0TOjuhQ5Z/reykkEsxAAAZAx8FAAA=]]></href><fromemail><![CDATA[]]></fromemail><importance><![CDATA[1]]></importance><flag><![CDATA[0]]></flag><attach><![CDATA[0]]></attach><sender><![CDATA[ 이동호(iPhone) ]]></sender><subject><![CDATA[Re: Local Delivery 문제 해결]]></subject><receivedt><![CDATA[2016-02-17 18:12]]></receivedt><size><![CDATA[9962]]></size><read><![CDATA[1]]></read><contentclass><![CDATA[IPM.Note]]></contentclass></response><response><href><![CDATA[AAMkAGJiNjA1ZTYwLWU3NjItNDA1Yi05NWNhLWU0MjdjYTYwODhiYwBGAAAAAAD0DJQBik2KSIR3MR2XIUsMBwAC5Z0TOjuhQ5Z/reykkEsxAAAAAAEMAAAC5Z0TOjuhQ5Z/reykkEsxAAAZAx8EAAA=]]></href><fromemail><![CDATA[]]></fromemail><importance><![CDATA[2]]></importance><flag><![CDATA[0]]></flag><attach><![CDATA[0]]></attach><sender><![CDATA[Microsoft Outlook]]></sender><subject><![CDATA[사서함이 거의 꽉 찼습니다.]]></subject><receivedt><![CDATA[2016-02-17 18:07]]></receivedt><size><![CDATA[10299]]></size><read><![CDATA[0]]></read><contentclass><![CDATA[IPM.Note.StorageQuotaWarning.Warning]]></contentclass></response><response><href><![CDATA[AAMkAGJiNjA1ZTYwLWU3NjItNDA1Yi05NWNhLWU0MjdjYTYwODhiYwBGAAAAAAD0DJQBik2KSIR3MR2XIUsMBwAC5Z0TOjuhQ5Z/reykkEsxAAAAAAEMAAAC5Z0TOjuhQ5Z/reykkEsxAAAZAx8DAAA=]]></href><fromemail><![CDATA[]]></fromemail><importance><![CDATA[1]]></importance><flag><![CDATA[0]]></flag><attach><![CDATA[0]]></attach><sender><![CDATA[이동호]]></sender><subject><![CDATA[읽음: Local Delivery 문제 해결]]></subject><receivedt><![CDATA[2016-02-17 17:30]]></receivedt><size><![CDATA[10803]]></size><read><![CDATA[1]]></read><contentclass><![CDATA[REPORT.IPM.Note.IPNRN]]></contentclass></response><response><href><![CDATA[AAMkAGJiNjA1ZTYwLWU3NjItNDA1Yi05NWNhLWU0MjdjYTYwODhiYwBGAAAAAAD0DJQBik2KSIR3MR2XIUsMBwAC5Z0TOjuhQ5Z/reykkEsxAAAAAAEMAAAC5Z0TOjuhQ5Z/reykkEsxAAAZAx8BAAA=]]></href><fromemail><![CDATA[]]></fromemail><importance><![CDATA[1]]></importance><flag><![CDATA[0]]></flag><attach><![CDATA[1]]></attach><sender><![CDATA[이동호]]></sender><subject><![CDATA[FW: 폼빌더 사용자 매뉴얼]]></subject><receivedt><![CDATA[2016-02-16 17:57]]></receivedt><size><![CDATA[2783134]]></size><read><![CDATA[1]]></read><contentclass><![CDATA[REPLY]]></contentclass></response><CONTENTRANGE><![CDATA[rows;0;29;total;4;BoxTCount;4;BoxUCount;1;]]></CONTENTRANGE></maillist>";
		String returnData = sb.toString();
		logger.debug("getMailList ended");
		
		return returnData;		
	}
	
	/**
	 * 메일 삭제 실행 함수
	 */
	@RequestMapping(value="/ezEmail/mailDelete.do",method=RequestMethod.POST,
			produces="text/xml; charset=utf-8")
	@ResponseBody
	public String mailDelete(@CookieValue("loginCookie") String loginCookie, 
			@RequestParam("cmd") String cmd,
			@RequestBody String bodyData,
			Locale locale, Model model) throws Exception {
		logger.debug("mailDelete started");
		logger.debug("cmd=" + cmd);
		logger.debug("bodyData=" + bodyData);
		
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
			uniqueId = uniqueId.substring(0, uniqueId.length() - 1);
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
		
		IMAPAccess imapAccess = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
				userId + "@" + config.getProperty("config.DomainName"), password, egovMessageSource, locale);
				
		IMAPFolder sourceFolder = (IMAPFolder)imapAccess.getFolder(folderId);		
		sourceFolder.open(Folder.READ_WRITE);		
				
		Message[] deleteMsgs = null;
		if (cmd.equalsIgnoreCase("ALL")) {
			deleteMsgs = sourceFolder.getMessages();
		}
		else {
			deleteMsgs = sourceFolder.getMessagesByUID(uids);
		}
		
		if (cmd.equalsIgnoreCase("BMOVE")) {
			IMAPFolder deletedFolder = (IMAPFolder)imapAccess.getFolder(egovMessageSource.getMessage("ezEmail.t647", locale));			
			sourceFolder.copyUIDMessages(deleteMsgs, deletedFolder);
		}
		sourceFolder.setFlags(deleteMsgs, new Flags(Flags.Flag.DELETED), true);
				
		sourceFolder.close(true);
		imapAccess.close();		
		
		String returnData = "";
		logger.debug("mailDelete ended");
		
		return returnData;				
	}
	
	/**
	 * 메일 리스트 정렬 실행 함수
	 */
	private void sortMessages(IMAPAccess imapAccess, Folder folder, Message[] messages, 
			String sortType) throws Exception {
		// subject
		if (sortType.startsWith(" ORDER BY \"http://schemas.microsoft.com/mapi/proptag/x0e1d001f\"")) {
			Comparator<Message> comparator = new IMAPAccess.MessageSubjectComparator();
			
			if (sortType.endsWith("ASC")) {
				logger.debug("ASC");
				
				comparator = Collections.reverseOrder(comparator);
			}
			else {
				logger.debug("DESC");
			}
			
			// pre-fetch fields needed for sorting
			FetchProfile fp = new FetchProfile();
			fp.add(FetchProfile.Item.ENVELOPE);
			folder.fetch(messages, fp);
			
			Locale locale = Locale.getDefault();
			logger.debug("locale=" + locale);
			
			Arrays.sort(messages, comparator);
		}
		// sender
		else if (sortType.startsWith(" ORDER BY \"http://schemas.microsoft.com/mapi/sent_representing_name\"")) {
			Comparator<Message> comparator = new IMAPAccess.MessageAddressComparator(true);
			
			if (sortType.endsWith("ASC")) {
				logger.debug("ASC");
				
				comparator = Collections.reverseOrder(comparator);
			}
			else {
				logger.debug("DESC");
			}
			
			// pre-fetch fields needed for sorting
			FetchProfile fp = new FetchProfile();
			fp.add(FetchProfile.Item.ENVELOPE);
			folder.fetch(messages, fp);
			
			Locale locale = Locale.getDefault();
			logger.debug("locale=" + locale);
			
			Arrays.sort(messages, comparator);
		}		
		// recipient
		else if (sortType.startsWith(" ORDER BY \"urn:schemas:httpmail:displayto\"")) {
			Comparator<Message> comparator = new IMAPAccess.MessageAddressComparator(false);
			
			if (sortType.endsWith("ASC")) {
				logger.debug("ASC");
				
				comparator = Collections.reverseOrder(comparator);
			}
			else {
				logger.debug("DESC");
			}
			
			// pre-fetch fields needed for sorting
			FetchProfile fp = new FetchProfile();
			fp.add(FetchProfile.Item.ENVELOPE);
			folder.fetch(messages, fp);
			
			Locale locale = Locale.getDefault();
			logger.debug("locale=" + locale);
			
			Arrays.sort(messages, comparator);
		}				
		// attachment
		else if (sortType.startsWith(" ORDER BY \"urn:schemas:httpmail:hasattachment\"")) {
			Comparator<Message> comparator = new IMAPAccess.MessageAttachmentComparator(imapAccess);
			
			if (sortType.endsWith("ASC")) {
				logger.debug("ASC");
				
				comparator = Collections.reverseOrder(comparator);
			}
			else {
				logger.debug("DESC");
			}
			
			// pre-fetch fields needed for sorting
			FetchProfile fp = new FetchProfile();
			fp.add(FetchProfile.Item.CONTENT_INFO);
			fp.add(IMAPFolder.FetchProfileItem.INTERNALDATE);
			folder.fetch(messages, fp);
						
			Arrays.sort(messages, comparator);
		}				
		// read/unread
		else if (sortType.startsWith(" ORDER BY \"http://schemas.microsoft.com/exchange/smallicon\"")) {
			Comparator<Message> comparator = new IMAPAccess.MessageUnreadComparator();
			
			if (sortType.endsWith("ASC")) {
				logger.debug("ASC");
				
				comparator = Collections.reverseOrder(comparator);
			}
			else {
				logger.debug("DESC");
			}
			
			// pre-fetch fields needed for sorting
			FetchProfile fp = new FetchProfile();
			fp.add(FetchProfile.Item.FLAGS);
			fp.add(IMAPFolder.FetchProfileItem.INTERNALDATE);
			folder.fetch(messages, fp);
						
			Arrays.sort(messages, comparator);
		}		
		// bookmark
		else if (sortType.startsWith(" ORDER BY \"http://schemas.microsoft.com/mapi/proptag/x10900003\"")) {
			Comparator<Message> comparator = new IMAPAccess.MessageFlaggedComparator();
			
			if (sortType.endsWith("ASC")) {
				logger.debug("ASC");
				
				comparator = Collections.reverseOrder(comparator);
			}
			else {
				logger.debug("DESC");
			}
			
			// pre-fetch fields needed for sorting
			FetchProfile fp = new FetchProfile();
			fp.add(FetchProfile.Item.FLAGS);
			fp.add(IMAPFolder.FetchProfileItem.INTERNALDATE);
			folder.fetch(messages, fp);
						
			Arrays.sort(messages, comparator);
		}								
		// importance
		else if (sortType.startsWith(" ORDER BY \"http://schemas.microsoft.com/exchange/x-priority-long\"")) {
			Comparator<Message> comparator = new IMAPAccess.MessagePriorityComparator();
			
			if (sortType.endsWith("ASC")) {
				logger.debug("ASC");
				
				comparator = Collections.reverseOrder(comparator);
			}
			else {
				logger.debug("DESC");
			}
								
			// pre-fetch fields needed for sorting
			FetchProfile fp = new FetchProfile();
			fp.add(IMAPFolder.FetchProfileItem.HEADERS);
			fp.add(IMAPFolder.FetchProfileItem.INTERNALDATE);
			folder.fetch(messages, fp);
			
			Arrays.sort(messages, comparator);
		}								
		// size
		else if (sortType.startsWith(" ORDER BY \"http://schemas.microsoft.com/mapi/proptag/x0e080003\"")) {
			Comparator<Message> comparator = new IMAPAccess.MessageSizeComparator();
			
			if (sortType.endsWith("ASC")) {
				logger.debug("ASC");
				
				comparator = Collections.reverseOrder(comparator);
			}
			else {
				logger.debug("DESC");
			}
			
			// pre-fetch fields needed for sorting
			FetchProfile fp = new FetchProfile();
			fp.add(FetchProfile.Item.SIZE);
			fp.add(IMAPFolder.FetchProfileItem.INTERNALDATE);
			folder.fetch(messages, fp);
						
			Arrays.sort(messages, comparator);
		}			
		// received date
		else if (sortType.startsWith(" ORDER BY \"urn:schemas:httpmail:datereceived\"")
				|| sortType.startsWith(" ORDER BY \"http://schemas.microsoft.com/exchange/date-iso\"")) {
			Comparator<Message> comparator = new IMAPAccess.MessageReceivedDateComparator();
			
			if (sortType.endsWith("ASC")) {
				logger.debug("ASC");
				
				comparator = Collections.reverseOrder(comparator);
			}
			else {
				logger.debug("DESC");
			}
			
			// pre-fetch fields needed for sorting
			FetchProfile fp = new FetchProfile();
			fp.add(IMAPFolder.FetchProfileItem.INTERNALDATE);
			folder.fetch(messages, fp);
						
			Arrays.sort(messages, comparator);
		}										
	}
	
	/**
	 * 메일 책갈피 지정 실행 함수
	 */
	@RequestMapping(value="/ezEmail/mailSetFlag.do",method=RequestMethod.POST,
			produces="text/xml; charset=utf-8")
	@ResponseBody
	public String mailSetFlag(@CookieValue("loginCookie") String loginCookie,
			@RequestBody String bodyData,
			Locale locale, Model model) throws Exception {
		logger.debug("mailSetFlag started");
		logger.debug("bodyData=" + bodyData);
		
		// get user credentials
		List<String> userIdAndPassword = commonUtil.getUserIdAndPassword(loginCookie);
		String userId = userIdAndPassword.get(0);
		String password = userIdAndPassword.get(1);
		
		Document doc = commonUtil.convertStringToDocument(bodyData);
		String uniqueId = doc.getElementsByTagName("ITEMID").item(0).getTextContent();	
		
		String folderId = null;
		long[] uids = null;
		uniqueId = uniqueId.substring(0, uniqueId.length() - 1);
		String[] folderAndMsgIdArray = uniqueId.split(";");
		folderId = folderAndMsgIdArray[0].split("/")[0];			
		uids = new long[folderAndMsgIdArray.length];
		for (int i = 0; i < folderAndMsgIdArray.length; i++) {
			String folderAndMsgId = folderAndMsgIdArray[folderAndMsgIdArray.length - i - 1];
			String msgId = folderAndMsgId.split("/")[1];
			uids[i] = Long.parseLong(msgId);
		}	
		logger.debug("folderId=" + folderId);		
		
		IMAPAccess imapAccess = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
				userId + "@" + config.getProperty("config.DomainName"), password, egovMessageSource, locale);
				
		IMAPFolder sourceFolder = (IMAPFolder)imapAccess.getFolder(folderId);		
		sourceFolder.open(Folder.READ_WRITE);		
				
		Message[] msgs = sourceFolder.getMessagesByUID(uids);
		
		String returnData = "";
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
		imapAccess.close();		
		
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
		
		IMAPAccess imapAccess = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
				userId + "@" + config.getProperty("config.DomainName"), password, egovMessageSource, locale);
				
		IMAPFolder sourceFolder = (IMAPFolder)imapAccess.getFolder(folderId);		
		sourceFolder.open(Folder.READ_WRITE);		
				
		Message[] msgs = sourceFolder.getMessagesByUID(uids);		
				
		if (isRead.equals("TRUE")) {
			sourceFolder.setFlags(msgs, new Flags(Flags.Flag.SEEN), true);
		}
		else {
			sourceFolder.setFlags(msgs, new Flags(Flags.Flag.SEEN), false);
		}
		
		sourceFolder.close(true);
		imapAccess.close();		
		
		String returnData = "<DATA>OK</DATA>";
		logger.debug("mailSetReadChange ended");
		
		return returnData;				
	}
	
}
