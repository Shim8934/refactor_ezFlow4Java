package egovframework.ezEKP.ezEmail.web;

import java.io.UnsupportedEncodingException;
import java.text.Collator;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
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
import org.springframework.web.bind.annotation.ResponseBody;
import org.w3c.dom.Document;

import com.sun.mail.imap.IMAPFolder;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezEmail.logic.IMAPAccess;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezEmail.vo.MailGeneralVO;
import egovframework.let.utl.fcc.service.CommonUtil;

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
	
	@RequestMapping("/ezEmail/mailList.do")
	public String showMailList(@CookieValue("loginCookie") String loginCookie, 
			HttpServletRequest request,
			Model model) throws Exception {
		logger.debug("showMailList started");
		String dispname = request.getParameter("dispname");
		if (dispname != null) {
			dispname = new String(dispname.getBytes("ISO-8859-1"),"UTF-8");
		}
		String url = request.getParameter("url");
		if (url != null) {
			url = new String(url.getBytes("ISO-8859-1"),"UTF-8");
		}		
		else {
			url = "INBOX";
		}
		logger.debug("dispname=" + dispname + ",url=" + url);
		
		List<String> userIdAndPassword = commonUtil.getUserIdAndPassword(loginCookie);
		String userId = userIdAndPassword.get(0);
		String folderName = egovMessageSource.getMessage("ezEmail.t644");
		String folderType = "";
		String userLang ="1";
		
		if (dispname != null) {
			folderName = dispname;
		}
		
		if (folderName.equals(egovMessageSource.getMessage("ezEmail.t645"))) {
			folderType = "sent";
		}
		else if (folderName.equals(egovMessageSource.getMessage("ezEmail.t646"))) {
			folderType = "draft";
		}
		else if (folderName.equals(egovMessageSource.getMessage("ezEmail.t647"))) {
			folderType = "delete";
		}
		
		MailGeneralVO mailGeneral = null;
		List<MailGeneralVO> mailGeneralList = ezEmailService.getMailGeneral(userId);
		if (mailGeneralList.size() > 0) {
			mailGeneral = mailGeneralList.get(0);
			logger.debug("userId=" + userId + ",mailGeneral=" + mailGeneral);
		}
		
		model.addAttribute("folderName", folderName);
		model.addAttribute("url", url);
		model.addAttribute("folderType", folderType);
		model.addAttribute("isSentItems", true);
		model.addAttribute("listCount", "30");
		model.addAttribute("userLang", userLang);
		model.addAttribute("userId", userId);
		model.addAttribute("mailGeneral", mailGeneral);
		
		logger.debug("showMailList ended");
		
		return "ezEmail/mailList";
	}
	
	@RequestMapping(value="/ezEmail/mailGetList.do",method=RequestMethod.POST,
			produces="text/xml; charset=utf-8")
	@ResponseBody
	public String getMailList(@CookieValue("loginCookie") String loginCookie, @RequestBody String bodyData, Model model) throws Exception {
		logger.debug("getMailList started");
		
		logger.debug("bodyData=" + bodyData);
		List<String> userIdAndPassword = commonUtil.getUserIdAndPassword(loginCookie);
		String userId = userIdAndPassword.get(0);
		String password = userIdAndPassword.get(1);		
		Document doc = commonUtil.convertStringToDocument(bodyData);
		String folderId = doc.getElementsByTagName("FOLDERID").item(0).getTextContent();
		String inboxName = egovMessageSource.getMessage("ezEmail.t644");
		folderId = folderId.equals(inboxName) ? "INBOX" : folderId;
		String sortType = doc.getElementsByTagName("SORTTYPE").item(0).getTextContent();
		String start = doc.getElementsByTagName("START").item(0).getTextContent();
		String end = doc.getElementsByTagName("END").item(0).getTextContent();
		String search = doc.getElementsByTagName("SEARCH").item(0).getTextContent();
		String viewSelectIndex = doc.getElementsByTagName("VIEWSELECTINDEX").item(0).getTextContent();
		logger.debug("folderId=" + folderId + ",sortType=" + sortType + ",start=" + start + ",end=" + end
						+ ",search=" + search + ",viewSelectIndex=" + viewSelectIndex);
		
		IMAPAccess imapAccess = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
				userId + "@" + config.getProperty("config.DomainName"), password, egovMessageSource);
				
		Folder folder = imapAccess.getFolder(folderId);		
		folder.open(Folder.READ_ONLY);
        UIDFolder uidFolder = (UIDFolder)folder;
		
		StringBuilder sb = new StringBuilder();
		sb.append("<maillist><contentrange>").append(start).append("-").append(end).append("</contentrange>");
		Message[] messages = folder.getMessages();
		
		sortMessages(imapAccess, folder, messages, sortType);
				
		int startNo = messages.length - 1 - Integer.parseInt(start);
		int endNo = Math.max(messages.length - 1 - Integer.parseInt(end), 0);
		logger.debug("startNo=" + startNo + ",endNo=" + endNo);
		if (startNo >= endNo) {
			Message[] fetchMessages = Arrays.copyOfRange(messages, endNo, startNo + 1);
			FetchProfile fp = new FetchProfile();
			fp.add(UIDFolder.FetchProfileItem.UID);
			fp.add("importance");
			fp.add(FetchProfile.Item.CONTENT_INFO);
			fp.add(FetchProfile.Item.ENVELOPE);
			fp.add(IMAPFolder.FetchProfileItem.INTERNALDATE);
			fp.add(FetchProfile.Item.SIZE);
			fp.add(FetchProfile.Item.FLAGS);
			folder.fetch(fetchMessages, fp);					
		}
		
		for (int i = startNo; i >= endNo; i--) {
			Message message = messages[i];
			
			sb.append("<response>");
			sb.append(String.format("<href><![CDATA[%s/%s]]></href>", folderId, uidFolder.getUID(message)));
			sb.append("<fromemail><![CDATA[]]></fromemail>");
			String[] headers = message.getHeader("importance");
			String header = headers != null ? headers[0] : "normal";
			int importance = 1;
			if (header.equalsIgnoreCase("high")) {
				importance = 2;
			}
			else if (header.equalsIgnoreCase("low")) {
				importance = 0;
			}
			sb.append(String.format("<importance><![CDATA[%d]]></importance>", importance));			
			sb.append("<flag><![CDATA[0]]></flag>");
			boolean isAttached = imapAccess.hasAttachment(message);
//			logger.debug("msgno=" + i + ",isAttached=" + isAttached);
			int attached = isAttached ? 1 : 0;
			sb.append(String.format("<attach><![CDATA[%d]]></attach>", attached));
			
			String addressStr = "";
			Address[] address = null;
			if (!viewSelectIndex.equals("3")) {
				address = message.getFrom();
			}
			else {
				address = message.getRecipients(Message.RecipientType.TO);
			}			
			if (address != null) {
				addressStr = ((InternetAddress)address[0]).getPersonal();
				if (addressStr == null) {
					addressStr = ((InternetAddress)address[0]).getAddress();
				}
				else {
					addressStr = MimeUtility.decodeText(addressStr);
				}
			}
			sb.append(String.format("<sender><![CDATA[%s]]></sender>", addressStr));
			sb.append(String.format("<subject><![CDATA[%s]]></subject>", message.getSubject()));
			Date receivedDate = message.getReceivedDate();
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");					
			sb.append(String.format("<receivedt><![CDATA[%s]]></receivedt>", sdf.format(receivedDate)));
			sb.append(String.format("<size><![CDATA[%d]]></size>", message.getSize()));
			int readFlag = message.isSet(Flags.Flag.SEEN) ? 1 : 0;
			sb.append(String.format("<read><![CDATA[%d]]></read>", readFlag));
			sb.append("<contentclass><![CDATA[IPM.Note]]></contentclass>");
			sb.append("</response>");
		}
		sb.append(String.format("<CONTENTRANGE><![CDATA[rows;%s;%s;total;%d;BoxTCount;%d;BoxUCount;%d;]]></CONTENTRANGE>", 
				start, end, folder.getMessageCount(), folder.getMessageCount(), folder.getUnreadMessageCount()));
		sb.append("</maillist>");
	      
		folder.close(false);
		imapAccess.close();
		
//		String returnData = "<maillist><contentrange>0-29</contentrange><response><href><![CDATA[AAMkAGJiNjA1ZTYwLWU3NjItNDA1Yi05NWNhLWU0MjdjYTYwODhiYwBGAAAAAAD0DJQBik2KSIR3MR2XIUsMBwAC5Z0TOjuhQ5Z/reykkEsxAAAAAAEMAAAC5Z0TOjuhQ5Z/reykkEsxAAAZAx8FAAA=]]></href><fromemail><![CDATA[]]></fromemail><importance><![CDATA[1]]></importance><flag><![CDATA[0]]></flag><attach><![CDATA[0]]></attach><sender><![CDATA[ 이동호(iPhone) ]]></sender><subject><![CDATA[Re: Local Delivery 문제 해결]]></subject><receivedt><![CDATA[2016-02-17 18:12]]></receivedt><size><![CDATA[9962]]></size><read><![CDATA[1]]></read><contentclass><![CDATA[IPM.Note]]></contentclass></response><response><href><![CDATA[AAMkAGJiNjA1ZTYwLWU3NjItNDA1Yi05NWNhLWU0MjdjYTYwODhiYwBGAAAAAAD0DJQBik2KSIR3MR2XIUsMBwAC5Z0TOjuhQ5Z/reykkEsxAAAAAAEMAAAC5Z0TOjuhQ5Z/reykkEsxAAAZAx8EAAA=]]></href><fromemail><![CDATA[]]></fromemail><importance><![CDATA[2]]></importance><flag><![CDATA[0]]></flag><attach><![CDATA[0]]></attach><sender><![CDATA[Microsoft Outlook]]></sender><subject><![CDATA[사서함이 거의 꽉 찼습니다.]]></subject><receivedt><![CDATA[2016-02-17 18:07]]></receivedt><size><![CDATA[10299]]></size><read><![CDATA[0]]></read><contentclass><![CDATA[IPM.Note.StorageQuotaWarning.Warning]]></contentclass></response><response><href><![CDATA[AAMkAGJiNjA1ZTYwLWU3NjItNDA1Yi05NWNhLWU0MjdjYTYwODhiYwBGAAAAAAD0DJQBik2KSIR3MR2XIUsMBwAC5Z0TOjuhQ5Z/reykkEsxAAAAAAEMAAAC5Z0TOjuhQ5Z/reykkEsxAAAZAx8DAAA=]]></href><fromemail><![CDATA[]]></fromemail><importance><![CDATA[1]]></importance><flag><![CDATA[0]]></flag><attach><![CDATA[0]]></attach><sender><![CDATA[이동호]]></sender><subject><![CDATA[읽음: Local Delivery 문제 해결]]></subject><receivedt><![CDATA[2016-02-17 17:30]]></receivedt><size><![CDATA[10803]]></size><read><![CDATA[1]]></read><contentclass><![CDATA[REPORT.IPM.Note.IPNRN]]></contentclass></response><response><href><![CDATA[AAMkAGJiNjA1ZTYwLWU3NjItNDA1Yi05NWNhLWU0MjdjYTYwODhiYwBGAAAAAAD0DJQBik2KSIR3MR2XIUsMBwAC5Z0TOjuhQ5Z/reykkEsxAAAAAAEMAAAC5Z0TOjuhQ5Z/reykkEsxAAAZAx8BAAA=]]></href><fromemail><![CDATA[]]></fromemail><importance><![CDATA[1]]></importance><flag><![CDATA[0]]></flag><attach><![CDATA[1]]></attach><sender><![CDATA[이동호]]></sender><subject><![CDATA[FW: 폼빌더 사용자 매뉴얼]]></subject><receivedt><![CDATA[2016-02-16 17:57]]></receivedt><size><![CDATA[2783134]]></size><read><![CDATA[1]]></read><contentclass><![CDATA[REPLY]]></contentclass></response><CONTENTRANGE><![CDATA[rows;0;29;total;4;BoxTCount;4;BoxUCount;1;]]></CONTENTRANGE></maillist>";
		String returnData = sb.toString();
		logger.debug("getMailList ended");
		
		return returnData;		
	}
	
	private void sortMessages(IMAPAccess imapAccess, Folder folder, Message[] messages, 
			String sortType) throws Exception {
		// subject
		if (sortType.startsWith(" ORDER BY \"http://schemas.microsoft.com/mapi/proptag/x0e1d001f\"")) {
			Comparator<Message> comparator = new MessageSubjectComparator();
			
			if (sortType.endsWith("ASC")) {
				logger.debug("ASC");
				
				comparator = Collections.reverseOrder(comparator);
			}
			else {
				logger.debug("DESC");
			}
			
			FetchProfile fp = new FetchProfile();
			fp.add(FetchProfile.Item.ENVELOPE);
			folder.fetch(messages, fp);
			
			Locale locale = Locale.getDefault();
			logger.debug("locale=" + locale);
			
			Arrays.sort(messages, comparator);
		}
		else if (sortType.startsWith(" ORDER BY \"http://schemas.microsoft.com/mapi/sent_representing_name\"")) {
			Comparator<Message> comparator = new MessageSenderComparator();
			
			if (sortType.endsWith("ASC")) {
				logger.debug("ASC");
				
				comparator = Collections.reverseOrder(comparator);
			}
			else {
				logger.debug("DESC");
			}
			
			FetchProfile fp = new FetchProfile();
			fp.add(FetchProfile.Item.ENVELOPE);
			folder.fetch(messages, fp);
			
			Locale locale = Locale.getDefault();
			logger.debug("locale=" + locale);
			
			Arrays.sort(messages, comparator);
		}		
		else if (sortType.startsWith(" ORDER BY \"urn:schemas:httpmail:hasattachment\"")) {
			Comparator<Message> comparator = new MessageAttachmentComparator(imapAccess);
			
			if (sortType.endsWith("ASC")) {
				logger.debug("ASC");
				
				comparator = Collections.reverseOrder(comparator);
			}
			else {
				logger.debug("DESC");
			}
			
			FetchProfile fp = new FetchProfile();
			fp.add(FetchProfile.Item.CONTENT_INFO);
			folder.fetch(messages, fp);
						
			Arrays.sort(messages, comparator);
		}				
	}
	
	private class MessageSubjectComparator implements Comparator<Message>{
		
		Collator collator = Collator.getInstance();
		
		@Override
		public int compare(Message m1, Message m2) {
			String first = null;
			String second = null;
			try {
				first = m1.getSubject();
				second = m2.getSubject();
			} catch (MessagingException e) {
				e.printStackTrace();
			}
			
			first = first != null ? first.trim() : "";
			second = second != null ? second.trim() : "";
			
			int rc = collator.compare(first, second);
			if (rc == 0) {
				try {
					Date d1 = m1.getReceivedDate();
					Date d2 = m2.getReceivedDate();
					if (d1 != null && d2 != null) {
						rc = d1.compareTo(d2);
					}
				} catch (MessagingException e) {
					e.printStackTrace();
				}
			}
			
			return rc;
		}
		
	}	
	
	private class MessageSenderComparator implements Comparator<Message>{
		
		Collator collator = Collator.getInstance();
		Map<Address, String> senders = new HashMap<Address, String>();
		
		private String getAddress(Message msg) {
			String addressStr = null;
			Address[] address = null;
			try {
				address = msg.getFrom();
			} catch (MessagingException e) {
				e.printStackTrace();
			}
			if (address != null) {
				addressStr = senders.get(address[0]);			
				if (addressStr == null) {					
					addressStr = ((InternetAddress)address[0]).getPersonal();
					if (addressStr == null) {
						addressStr = ((InternetAddress)address[0]).getAddress();
					}
					else {
						try {
							addressStr = MimeUtility.decodeText(addressStr);
						} catch (UnsupportedEncodingException e) {
							e.printStackTrace();
						}
					}					
					
					senders.put(address[0], addressStr);
				}		
			}
			else {
				addressStr = "";
			}
			
			return addressStr;
		}
		
		@Override
		public int compare(Message m1, Message m2) {			
			String first = getAddress(m1);
			String second = getAddress(m2);
			
			first = first != null ? first.trim() : "";
			second = second != null ? second.trim() : "";
			
			int rc = collator.compare(first, second);
			if (rc == 0) {
				try {
					Date d1 = m1.getReceivedDate();
					Date d2 = m2.getReceivedDate();
					if (d1 != null && d2 != null) {
						rc = d1.compareTo(d2);
					}
				} catch (MessagingException e) {
					e.printStackTrace();
				}
			}
			
			return rc;
		}
		
	}	
	
	private class MessageAttachmentComparator implements Comparator<Message>{
		
		IMAPAccess imapAccess;
		
		public MessageAttachmentComparator(IMAPAccess imapAccess) {
			this.imapAccess = imapAccess;
		}
		
		@Override
		public int compare(Message m1, Message m2) {
			int attached1 = imapAccess.hasAttachment(m1) ? 1 : 0;
			int attached2 = imapAccess.hasAttachment(m2) ? 1 : 0;
						
			int rc = attached1 - attached2;
			if (rc == 0) {
				try {
					Date d1 = m1.getReceivedDate();
					Date d2 = m2.getReceivedDate();
					if (d1 != null && d2 != null) {
						rc = d1.compareTo(d2);
					}
				} catch (MessagingException e) {
					e.printStackTrace();
				}
			}
			
			return rc;
		}
		
	}	
	
}
