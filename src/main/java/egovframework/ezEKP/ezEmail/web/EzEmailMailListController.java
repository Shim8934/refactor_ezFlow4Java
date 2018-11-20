package egovframework.ezEKP.ezEmail.web;

import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;
import java.util.TimeZone;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.annotation.Resource;
import javax.mail.Address;
import javax.mail.Flags;
import javax.mail.Folder;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.UIDFolder;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
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
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.logic.IMAPAccess;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezEmail.util.EzEmailUtil;
import egovframework.ezEKP.ezEmail.vo.MailColorVO;
import egovframework.ezEKP.ezEmail.vo.MailGeneralVO;
import egovframework.ezEKP.ezEmail.vo.MailReadVO;
import egovframework.ezEKP.ezEmail.vo.MailSharedMailboxUserVO;
import egovframework.let.user.login.vo.LoginVO;
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
	
    @Resource(name = "EzCommonService")
    private EzCommonService ezCommonService;
    
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
		logger.debug("showMailList started.");
		
		// retrieve the passed in parameters
		String dispname = request.getParameter("dispname");
		String url = request.getParameter("url");
		url = (url != null) ? url : "INBOX";
		logger.debug("dispname=" + dispname + ",url=" + url);
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String folderName = egovMessageSource.getMessage("ezEmail.t644", locale);
		String folderType = "";
		String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
		String useEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		String useOcs = config.getProperty("config.USE_OCS");
		boolean isSentItems = false;
		String useEncryptZipForEmail = ezCommonService.getTenantConfig("UseEncryptZipForEmail", userInfo.getTenantId());
		String useMailBoxBackUp = ezCommonService.getTenantConfig("UseMailBoxBackUp", userInfo.getTenantId());
		String useReSend = ezCommonService.getTenantConfig("useReSend", userInfo.getTenantId());
		String useMailWriteSenderClick = ezCommonService.getTenantConfig("useMailWriteSenderClick", userInfo.getTenantId()); // 수아 수정(useMailWriteSenderClick 추가)
		String useSearchContent = ezCommonService.getTenantConfig("useSearchContent", userInfo.getTenantId());
		String useMailNewWindow = ezCommonService.getTenantConfig("useMailNewWindow", userInfo.getTenantId()); 
		String useCountryIP = ezCommonService.getTenantConfig("useCountryIP", userInfo.getTenantId());
		String systemCountryCode = ezCommonService.getTenantConfig("systemCountryCode", userInfo.getTenantId());
		String useShowSystemCountry = ezCommonService.getTenantConfig("useShowSystemCountry", userInfo.getTenantId());
		String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", userInfo.getTenantId());

		if (useSharedMailbox.equals("YES")) {
			String shareId = request.getParameter("shareId");
			logger.debug("shareId=" + shareId);
			
			if (shareId != null) {
				MailSharedMailboxUserVO shareVO = ezEmailService.getSharedMailboxPermissionInfo(shareId, userInfo.getTenantId(), userInfo.getId());
				model.addAttribute("shareId", shareId);
				model.addAttribute("deletePermission", shareVO.getDeletePermission());
				model.addAttribute("sendPermission", shareVO.getSendPermission());
			}
		}
		
		if (useEncryptZipForEmail.equals("")) {
			useEncryptZipForEmail = "NO";
		}
		
		if (useMailBoxBackUp.equals("")) {
			useMailBoxBackUp = "NO";
		}
		
		//수아 수정
		if (useMailWriteSenderClick.equals("")) {
			useMailWriteSenderClick = "NO";
		}
		
		if (useSearchContent.equals("")) {
			useSearchContent = "NO";
		}
		
		if (useMailNewWindow.equals("")) {
			useMailNewWindow = "NO";
		}
		
		if (dispname != null) {
			folderName = dispname;
		}
		
		if (folderName.equals(egovMessageSource.getMessage("ezEmail.t645", locale)) || folderName.equals(egovMessageSource.getMessage("ezEmail.t516", locale))) {
			folderType = "sent";
			isSentItems = true;
		}
		else if (folderName.equals(egovMessageSource.getMessage("ezEmail.t646", locale))) {
			folderType = "draft";
			isSentItems = true;
		}
		else if (folderName.equals(egovMessageSource.getMessage("ezEmail.t647", locale))) {
			folderType = "delete";
		}
		
		// retrieve the mail general settings from DB.
		MailGeneralVO mailGeneral = ezEmailService.getMailGeneral(userInfo.getTenantId(), userInfo.getId()).get(0);
				
		// set importanceColor
		String importanceColor = "#ff0000";
		MailColorVO mailColor = ezEmailService.getMailColor(userInfo.getTenantId());
		
		if (mailColor != null && mailColor.getImportanceColor() != null) {
			importanceColor = mailColor.getImportanceColor();
		}
		
		// set model
		model.addAttribute("folderName", folderName);
		model.addAttribute("url", url);
		model.addAttribute("folderType", folderType);
		model.addAttribute("isSentItems", isSentItems);
		model.addAttribute("userLang", userInfo.getLang());
		model.addAttribute("userId", userInfo.getId());
		model.addAttribute("domainName", domainName);
		model.addAttribute("mailGeneral", mailGeneral);
		model.addAttribute("useEditor", useEditor);
		model.addAttribute("useOcs", useOcs);
		model.addAttribute("importanceColor", importanceColor);
		model.addAttribute("useEncryptZipForEmail", useEncryptZipForEmail);
		model.addAttribute("useMailBoxBackUp", useMailBoxBackUp);
		model.addAttribute("useReSend", useReSend);
		model.addAttribute("useMailWriteSenderClick", useMailWriteSenderClick); // 수아 수정 (useMailWriteSenderClick 추가)
		model.addAttribute("useSearchContent", useSearchContent);
		model.addAttribute("useMailNewWindow", useMailNewWindow); 
		model.addAttribute("sentFolderId", ezEmailUtil.getSentFolderId(locale));
		model.addAttribute("useCountryIP", useCountryIP);
		model.addAttribute("systemCountryCode", systemCountryCode);
		model.addAttribute("useShowSystemCountry", useShowSystemCountry);

		logger.debug("folderName=" + folderName + ",url=" + url + ",folderType=" + folderType + ",isSentItems=" + isSentItems
				 + ",userLang=" + userInfo.getLang() + ",userId=" + userInfo.getId() + ",domainName=" + domainName + ",useEditor=" + useEditor
				 + ",useOcs=" + useOcs + ",importanceColor=" + importanceColor + ",UseEncryptZipForEmail=" + useEncryptZipForEmail
				 + ",useMailBoxBackUp=" + useMailBoxBackUp + ",useCountryIP=" + useCountryIP);
		logger.debug("mailGeneral=" + mailGeneral);
		logger.debug("showMailList ended.");
		
		return "ezEmail/mailList";
	}
	
	
	/**
	 * 메일 리스트 호출 함수 (수신확인화면)
	 */
	@RequestMapping(value="/ezEmail/getReceiverMailList.do",method=RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String getReceiverMailList(@CookieValue("loginCookie") String loginCookie, @RequestBody String bodyData, Locale locale, Model model) throws Exception {
		logger.debug("getReceiverMailList started.");		
		logger.debug("bodyData=" + bodyData);
		
		// get user credentials
		List<String> userIdAndPassword = commonUtil.getUserIdAndPassword(loginCookie);
		String password = userIdAndPassword.get(1);		
		
        LoginVO userInfo = commonUtil.userInfo(loginCookie);
        String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
        String userEmail = userInfo.getId() + "@" + domainName;
        
		Document doc = commonUtil.convertStringToDocument(bodyData);
		String folderId = doc.getElementsByTagName("FOLDERID").item(0).getTextContent();
		String inboxName = egovMessageSource.getMessage("ezEmail.t644", locale);
		folderId = folderId.equals(inboxName) ? "INBOX" : folderId;
		String sortType = doc.getElementsByTagName("SORTTYPE").item(0).getTextContent();
		String start = doc.getElementsByTagName("START").item(0).getTextContent();
		String end = doc.getElementsByTagName("END").item(0).getTextContent();
		String search = doc.getElementsByTagName("SEARCH").item(0).getTextContent();
		String viewSelectIndex = doc.getElementsByTagName("VIEWSELECTINDEX").item(0).getTextContent();
		
		logger.debug("userId=" + userInfo.getId() + ",tenantId=" + userInfo.getTenantId() + ",serverName=" + userInfo.getServerName() 
		            + ",folderId=" + folderId + ",sortType=" + sortType + ",start=" + start + ",end=" + end
					+ ",search=" + search + ",viewSelectIndex=" + viewSelectIndex);
		
		String returnData = "";
		
		IMAPAccess ia = null;
		
		try {
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userEmail, password, egovMessageSource, locale, 40*1000, 20*1000, ezEmailUtil);
					
			Folder folder = ia.getFolder(folderId);		
			folder.open(Folder.READ_ONLY);
			
			StringBuilder sb = new StringBuilder();
			sb.append("<maillist><contentrange>").append(start).append("-").append(end).append("</contentrange>");
			
			Message[] messages = null; 
			boolean isUnreadOnly = false;
			boolean isImportantOnly = false;
			int totalCount = 0;
			int startNo = 0;
			int endNo = 0;
			
			if (sortType.indexOf("\"urn:schemas:httpmail:read\" = false") >= 0) {
				isUnreadOnly = true;
			}
					
			logger.debug("isUnreadOnly=" + isUnreadOnly + ", isImportantOnly=" + isImportantOnly);
			
			String searchField = "";
			String searchValue = "";
			int index = search.indexOf("=");
			
			if (index > -1) {
				searchField = search.substring(0, index);
				searchValue = search.substring(index + 1);
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
			
			// importance
			else if (sortType.indexOf(" ORDER BY \"http://schemas.microsoft.com/exchange/x-priority-long\"") >= 0) {
				sortTypeSpecifier = "importance";
			}
			
			// received date
			else if (sortType.indexOf(" ORDER BY \"urn:schemas:httpmail:datereceived\"") >= 0
					|| sortType.indexOf(" ORDER BY \"http://schemas.microsoft.com/exchange/date-iso\"") >= 0) {
				sortTypeSpecifier = "receivedDate";
			}
			
			startNo = Integer.parseInt(start);
			endNo = Integer.parseInt(end);
			int listCount = endNo - startNo + 1;
			
			if (listCount < 0) {
				listCount = 0;
			}
			
			logger.debug("searchField=" + searchField + ",searchValue=" + searchValue + ",sortTypeSpecifier=" + sortTypeSpecifier 
					+ ",isAscending=" + isAscending + ",startNo=" + startNo + ",endNo=" + endNo + ",listCount=" + listCount);
			
			Map<String, Object> extraMap = new HashMap<String, Object>();
			messages = ezEmailUtil.searchFolder(ia, userEmail, folder, searchField, searchValue, null, null, false, 
					isUnreadOnly, isImportantOnly, sortTypeSpecifier, isAscending, startNo, listCount, false, extraMap, userInfo.getTenantId());
			
			totalCount = (int)extraMap.get("totalCount");
			logger.debug("totalCount=" + totalCount);
			
			for (Message message : messages) {
				UIDFolder uidFolder = (UIDFolder)message.getFolder();
				
				sb.append("<response>");
				sb.append(String.format("<href><![CDATA[%s/%s]]></href>", folderId, uidFolder.getUID(message)));
				
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
				
				String msgto = "";
				Address[] addresses = null;

				int addressCount = 1;
				String name = "";
				
				if (!viewSelectIndex.equals("3")) {
					name = ezEmailUtil.getFromNameOrAddressOfMessage(message);
					String senderEmail = ezEmailUtil.getFromEmailAddressOfMessage(message);
					
					msgto = String.format("%s <%s>", name, senderEmail);
				}
				// in case of Sent mailbox
				else {
					addresses = message.getRecipients(Message.RecipientType.TO);
					
					if (addresses != null) {
						addressCount = addresses.length;
						String toHeader = message.getHeader("To")[0];
						boolean isAscii = ezEmailUtil.isPureAscii(toHeader);
						
						String recipientName = "";
						
						StringBuilder msgtoBuilder = new StringBuilder();
						
						for (Address address : addresses) {
							recipientName = ((InternetAddress) address).getPersonal(); // name part
							String receiverUserEmail = ((InternetAddress) address).getAddress(); // email address part
							
							if (recipientName == null) {
								recipientName = receiverUserEmail;
							}
							
							if (receiverUserEmail != null) {
								
								if (!isAscii) {
									byte[] rawBytes = receiverUserEmail.getBytes("iso-8859-1");
									receiverUserEmail = ezEmailUtil.decodeNonAsciiBytes(rawBytes);								
								} else {
									// decoding is needed for the name part
									receiverUserEmail = MimeUtility.decodeText(receiverUserEmail);
								}
							}
							
							msgtoBuilder.append(String.format("%s <%s>", recipientName, receiverUserEmail));
							msgtoBuilder.append(",");
							
							name += recipientName;
							name += "; ";
						}
						
						msgto = msgtoBuilder.toString();
						msgto = msgto.substring(0, msgto.length() - 1);
						name = name.substring(0, name.length() - 2);
					}
				}
				
				
				String readDate = "";
				int nameLength = 1;
				int readCount = 0;
				
				String messageId = ((MimeMessage)message).getMessageID() == null ? "" : ((MimeMessage)message).getMessageID();
				
				//get readList(수신확인)
				List<MailReadVO> readList = ezEmailService.getMailReadList(userInfo.getTenantId(), userInfo.getId(), messageId);
				
				//get all recipients from email message(메일)
				Address[] addresses1 = message.getAllRecipients();
				
				//get aliasAddressList from recipients
				List<String> addressList = new ArrayList<String>();
				
				if (addresses1 != null) {
					for (Address address : addresses1) {
						if (((InternetAddress)address).getAddress() != null) {
							addressList.add(((InternetAddress)address).getAddress());
						}
					}
				}
				
				Map<String, String> aliasAddressList = ezEmailService.getAliasAddressMap(addressList, userInfo.getTenantId());
				
				List<String> tempMailList = new ArrayList<String>();
				
				readDate = "UNREAD";
				readCount = 0;
				
				if (addresses1 != null) {
					for (Address address : addresses1) {
						String email = ((InternetAddress)address).getAddress();
						
						if (email != null) {
							
							// 메일 수신자의 주소가 alias 주소인 경우 real(account) 주소로 바꾼다.
							if (aliasAddressList.containsKey(email)) {
								email = aliasAddressList.get(email);
							}
							
							for (MailReadVO vo : readList) {
								// readList의 reader 주소가 alias 주소인 경우 real(account) 주소로 바꾸어 비교한다.
								if (aliasAddressList.containsKey(vo.getReaderEmail())) {
									if (aliasAddressList.get(vo.getReaderEmail()).equals(email)) {
										readDate = commonUtil.getDateStringInUTC(vo.getReadDate(), userInfo.getOffset(), false);
										readCount++;
									}
								} else {								
									if (vo.getReaderEmail().equals(email)) {
										readDate = commonUtil.getDateStringInUTC(vo.getReadDate(), userInfo.getOffset(), false);
										readCount++;
									}
								}
							}
							
							tempMailList.add(email);
						}
					}
										
					String returnValue1 = Integer.toString(tempMailList.size());
					if (tempMailList.size() == 1) {
						returnValue1 += ";" + readDate;
					} else {
						//다수일때 unreadCount도 리턴해주기
						returnValue1 += ";" + readCount;
					}
						
					nameLength = Integer.parseInt(returnValue1.split(";")[0]);
					
					if (nameLength > 1) {
						readDate = "";
					} else {
						readDate = returnValue1.split(";")[1];
					}
				}
				
				if (name == null || name.equals("")) {
					name = "";
				}
				
				if (readDate == null || readDate.equals("")) {
					readDate = "";
				}
				
				if (msgto == null || msgto.equals("")) {
					msgto = "";
				}
				
				// 수신확인 항목이 존재하나 readCount가 0인 경우는 메일의 수신인 주소와 일치하는
				// 수신확인 읽은 사람 주소가 없는 경우이며 부서 혹은 공용배포그룹과 같은 경우에 발생할 수 있다.
				if (readCount == 0 && readList.size() > 0) {
					sb.append(String.format("<group><![CDATA[yes]]></group>"));
					readDate = "";
				} else {
					sb.append(String.format("<group><![CDATA[no]]></group>"));
				}
				
				sb.append(String.format("<sender><![CDATA[%s]]></sender>", name));
				sb.append(String.format("<readdt><![CDATA[%s]]></readdt>", readDate));
				sb.append(String.format("<msgto><![CDATA[%s]]></msgto>", msgto));
				sb.append(String.format("<recipientCount><![CDATA[%d]]></recipientCount>", addresses1.length));
				
				// subject
				String subject = ezEmailUtil.getSubject(message);								
				subject = (subject != null) ? subject : "";
				subject = commonUtil.cleanValue(subject);
				
				// secureMail
				if (ezEmailUtil.hasSecureMailFlag(message)) {
					sb.append(String.format("<securemail>1</securemail>"));
				} else {
					sb.append(String.format("<securemail>0</securemail>"));
				}
				
				if (viewSelectIndex.equals("1")) {
					((IMAPMessage)message).setPeek(true);
					List<String> bodyInfoList = ezEmailUtil.getBodyInfo(message, folderId, uidFolder.getUID(message), -1, null, false, false, locale, null, null);
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
				sdf.setTimeZone(TimeZone.getTimeZone("GMT"));
				String receivedDateStr = sdf.format(receivedDate);
				
				receivedDateStr = commonUtil.getDateStringInUTC(receivedDateStr, userInfo.getOffset(), false);
				
				sb.append(String.format("<receivedt><![CDATA[%s]]></receivedt>", receivedDateStr));
				
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
					start, end, totalCount, folder.getMessageCount(), folder.getUnreadMessageCount()));
			sb.append("</maillist>");
			folder.close(false);
			
			// skyblue0o0 20180402 : 특정 유니코드 문자 포함 시 xml파싱 에러나서 빈칸으로 치환
			returnData = sb.toString().replaceAll("[\\u0000-\\u0008\\u000B-\\u000C\\u000E-\\u001F]", " ");
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (ia != null) {
				ia.close();
			}
		}
		
		logger.debug("getReceiverMailList ended.");
		
		return returnData;		
	}
	
	/**
	 * 메일 리스트 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailGetList.do",method=RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String getMailList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, @RequestBody String bodyData, Locale locale, Model model) throws Exception {
		logger.debug("getMailList started.");
		logger.debug("bodyData=" + bodyData);
		
		// get user credentials
		List<String> userIdAndPassword = commonUtil.getUserIdAndPassword(loginCookie);
		String password = userIdAndPassword.get(1);		
		
        LoginVO userInfo = commonUtil.userInfo(loginCookie);
        String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
        String userEmail = userInfo.getId() + "@" + domainName;
        
		Document doc = commonUtil.convertStringToDocument(bodyData);
		String folderId = doc.getElementsByTagName("FOLDERID").item(0).getTextContent();
		String inboxName = egovMessageSource.getMessage("ezEmail.t644", locale);
		folderId = folderId.equals(inboxName) ? "INBOX" : folderId;
		String sortType = doc.getElementsByTagName("SORTTYPE").item(0).getTextContent();
		String start = doc.getElementsByTagName("START").item(0).getTextContent();
		String end = doc.getElementsByTagName("END").item(0).getTextContent();
		String search = doc.getElementsByTagName("SEARCH").item(0).getTextContent();
		String viewSelectIndex = doc.getElementsByTagName("VIEWSELECTINDEX").item(0).getTextContent();
		String useCountryIP = ezCommonService.getTenantConfig("useCountryIP", userInfo.getTenantId());
		String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", userInfo.getTenantId());
		
		if (useSharedMailbox.equals("YES")) {
			String shareId = request.getParameter("shareId");
			logger.debug("shareId=" + shareId);
			
			if (shareId != null) {
				if (!ezEmailService.checkUserShareId(userInfo.getId(), shareId, userInfo.getTenantId())) {
					logger.debug("the user cannot access the shareId.");
					logger.debug("getMailList ended.");
					
					return "";
				}
				
				userEmail = shareId + "@" + domainName;
			}
		}
		
		logger.debug("userId=" + userInfo.getId() + ",userEmail=" + userEmail + ",tenantId=" + userInfo.getTenantId() + ",serverName=" + userInfo.getServerName() 
		            + ",folderId=" + folderId + ",sortType=" + sortType + ",start=" + start + ",end=" + end
					+ ",search=" + search + ",viewSelectIndex=" + viewSelectIndex + ",useCountryIP=" + useCountryIP);
		
		String returnData = "";
		
		IMAPAccess ia = null;
		
		try {
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userEmail, password, egovMessageSource, locale, 40*1000, 20*1000, ezEmailUtil);
					
			Folder folder = ia.getFolder(folderId);		
			folder.open(Folder.READ_ONLY);
			
			StringBuilder sb = new StringBuilder();
			sb.append("<maillist><contentrange>").append(start).append("-").append(end).append("</contentrange>");
			
			Message[] messages = null; 
			int totalCount = 0;
			int startNo = 0;
			int endNo = 0;
			boolean isUnreadOnly = false;
			boolean isImportantOnly = false;
			
			if (sortType.indexOf("\"urn:schemas:httpmail:read\" = false") >= 0) {
				isUnreadOnly = true;
			}
					
			logger.debug("isUnreadOnly=" + isUnreadOnly + ", isImportantOnly=" + isImportantOnly);
			
			String searchField = "";
			String searchValue = "";
			
			int index = search.indexOf("=");
			
			if (search.indexOf("=") > -1) {
				searchField = search.substring(0, index);
				searchValue = search.substring(index + 1);
			}
			
			logger.debug("searchField=" + searchField + ",searchValue=" + searchValue);
			
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
			
			startNo = Integer.parseInt(start);
			endNo = Integer.parseInt(end);
			int listCount = endNo - startNo + 1;
			
			if (listCount < 0) {
				listCount = 0;
			}
			
			Map<String, Object> extraMap = new HashMap<String, Object>();
			messages = ezEmailUtil.searchFolder(ia, userEmail, folder, searchField, searchValue, null, null, false, 
					isUnreadOnly, isImportantOnly, sortTypeSpecifier, isAscending, startNo, listCount, false, extraMap, userInfo.getTenantId());
			
			totalCount = (int)extraMap.get("totalCount");
			logger.debug("totalCount=" + totalCount);
		
			for (Message message : messages) {
				UIDFolder uidFolder = (UIDFolder)message.getFolder();
				
				sb.append("<response>");
				sb.append(String.format("<href><![CDATA[%s/%s]]></href>", folderId, uidFolder.getUID(message)));

				/*String fromEmail = ((InternetAddress)message.getFrom()[0]).getAddress();
				if (fromEmail == null) {
					sb.append("<fromemail><![CDATA[]]></fromemail>");
				} else {
					sb.append(String.format("<fromemail><![CDATA[%s]]></fromemail>", fromEmail));
				}*/
				
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
				
				String msgto = "";
				Address[] addresses = null;

				int addressCount = 1;
				String name = "";
				
				if (!viewSelectIndex.equals("3")) {
					name = ezEmailUtil.getFromNameOrAddressOfMessage(message);
					String senderEmail = ezEmailUtil.getFromEmailAddressOfMessage(message);
					
					msgto = String.format("%s <%s>", name, senderEmail);
				}
				// in case of Sent mailbox
				else {
					addresses = message.getRecipients(Message.RecipientType.TO);
					
					if (addresses != null) {
						addressCount = addresses.length;
						String toHeader = message.getHeader("To")[0];
						boolean isAscii = ezEmailUtil.isPureAscii(toHeader);
						
						String recipientName = "";
						
						StringBuilder msgtoBuilder = new StringBuilder();
						
						for (Address address : addresses) {
							recipientName = ((InternetAddress) address).getPersonal(); // name part
							String receiverUserEmail = ((InternetAddress) address).getAddress(); // email address part
							
							if (recipientName == null) {
								recipientName = receiverUserEmail;
							}
							
							if (receiverUserEmail != null) {
								
								if (!isAscii) {
									byte[] rawBytes = receiverUserEmail.getBytes("iso-8859-1");
									receiverUserEmail = ezEmailUtil.decodeNonAsciiBytes(rawBytes);								
								} else {
									// decoding is needed for the name part
									receiverUserEmail = MimeUtility.decodeText(receiverUserEmail);
								}
							}
							
							msgtoBuilder.append(String.format("%s <%s>", recipientName, receiverUserEmail));
							msgtoBuilder.append(",");
							
							name += recipientName;
							name += "; ";
						}
						
						msgto = msgtoBuilder.toString();
						msgto = msgto.substring(0, msgto.length() - 1);
						name = name.substring(0, name.length() - 2);
					}
				}
				
				// 2018-10-05 메일리스트에 보낸사람 국기표시 박예연
				if (useCountryIP.equals("YES")) {
					try {
						String[] ctryCode = message.getHeader("X-Jmocha-Country-Code");
						String countryCode = "";
						
						if (ctryCode != null && ctryCode[0] != null) {
							countryCode = ctryCode[0].toLowerCase();
							logger.debug("countryCode=" + countryCode);
						}
						
						sb.append(String.format("<countryCode><![CDATA[%s]]></countryCode>", countryCode));
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
				
				sb.append(String.format("<useCountryIP><![CDATA[%s]]></useCountryIP>", useCountryIP));
				sb.append(String.format("<sender><![CDATA[%s]]></sender>", name));
				sb.append(String.format("<msgto><![CDATA[%s]]></msgto>", msgto));

				// subject
				String subject = ezEmailUtil.getSubject(message);								
				subject = (subject != null) ? subject : "";
				subject = commonUtil.cleanValue(subject);
				
				// secureMail
				if (ezEmailUtil.hasSecureMailFlag(message)) {
					sb.append(String.format("<securemail>1</securemail>"));
				} else {
					sb.append(String.format("<securemail>0</securemail>"));
				}
				
				if (viewSelectIndex.equals("1")) {
					((IMAPMessage)message).setPeek(true);
					List<String> bodyInfoList = ezEmailUtil.getBodyInfo(message, folderId, uidFolder.getUID(message), -1, null, false, false, locale, null, null);
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
				sdf.setTimeZone(TimeZone.getTimeZone("GMT"));
				String receivedDateStr = sdf.format(receivedDate);
				
				receivedDateStr = commonUtil.getDateStringInUTC(receivedDateStr, userInfo.getOffset(), false);
				
				sb.append(String.format("<receivedt><![CDATA[%s]]></receivedt>", receivedDateStr));
				
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
					start, end, totalCount, folder.getMessageCount(), folder.getUnreadMessageCount()));
			sb.append("</maillist>");
		    
			folder.close(false);
			
			// skyblue0o0 20180402 : 특정 유니코드 문자 포함 시 xml파싱 에러나서 빈칸으로 치환
			returnData = sb.toString().replaceAll("[\\u0000-\\u0008\\u000B-\\u000C\\u000E-\\u001F]", " ");
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (ia != null) {
				ia.close();
			}
		}
		
		logger.debug("getMailList ended.");
		
		return returnData;		
	}
	
	/**
	 * 메일 삭제 실행 함수
	 */
	@RequestMapping(value="/ezEmail/mailDelete.do",method=RequestMethod.POST)
	@ResponseBody
	public String mailDelete(@CookieValue("loginCookie") String loginCookie, 
			HttpServletRequest request,
			@RequestParam("cmd") String cmd,
			@RequestBody String bodyData,
			Locale locale, Model model) throws Exception {
		logger.debug("mailDelete started.");
		logger.debug("cmd=" + cmd);
		logger.debug("bodyData=" + bodyData);
		
		String returnData = "OK";
		
		// get user credentials
		List<String> userIdAndPassword = commonUtil.getUserIdAndPassword(loginCookie);
		String password = userIdAndPassword.get(1);
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		Document doc = commonUtil.convertStringToDocument(bodyData);
		String uniqueId = doc.getElementsByTagName("UNIQUEID").item(0).getTextContent();	
		
		String folderId = null;
		long[] uids = null;
		
		if (cmd.equalsIgnoreCase("ALL")) {
			folderId = uniqueId;
		} else {
			String[] folderAndMsgIdArray = ezEmailUtil.makeFolderAndMsgIdArray(uniqueId);
			
			int delimiterIndex = folderAndMsgIdArray[0].lastIndexOf("/");
			folderId = folderAndMsgIdArray[0].substring(0, delimiterIndex);			
			uids = new long[folderAndMsgIdArray.length];
			
			for (int i = 0; i < folderAndMsgIdArray.length; i++) {
				String folderAndMsgId = folderAndMsgIdArray[i];
				delimiterIndex = folderAndMsgId.lastIndexOf("/");
				String msgId = folderAndMsgId.substring(delimiterIndex + 1);
				uids[i] = Long.parseLong(msgId);
			}
		}
		
		logger.debug("folderId=" + folderId);
		
		IMAPAccess ia = null;
        boolean isNewUserQuotaNeeded = false;	
        boolean isThereUserLevelQuota = false;
        String userEmail = "";
        Double userQuota = 0.0;
        Double userWarn = 0.0;        
		
		try {
	        String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
	        userEmail = userInfo.getId() + "@" + domainName;
	        
	        String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", userInfo.getTenantId());
	        
	        if (useSharedMailbox.equals("YES")) {
	        	String shareId = request.getParameter("shareId");
				logger.debug("shareId=" + shareId);
		        
		        if (shareId != null) {
					if (!ezEmailService.checkUserShareId(userInfo.getId(), shareId, 1, userInfo.getTenantId())) {
						logger.debug("the user cannot access the shareId.");
						logger.debug("mailDelete ended.");
						
						return "";
					}
					
					userEmail = shareId + "@" + domainName;
				}
	        }
	        
	        logger.debug("userId=" + userInfo.getId() + ",userEmail=" + userEmail);
	        
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userEmail, password, egovMessageSource, locale, ezEmailUtil);
					
			IMAPFolder sourceFolder = (IMAPFolder)ia.getFolder(folderId);		
			sourceFolder.open(Folder.READ_WRITE);		
					
			Message[] deleteMsgs = null;
			if (cmd.equalsIgnoreCase("ALL")) {
				deleteMsgs = sourceFolder.getMessages();
			}
			else {
				deleteMsgs = sourceFolder.getMessagesByUID(uids);
				
				// 2018-10-09 메일 영구 삭제 시 메일 제목, 받은 날짜 로그 추가
				if (!cmd.equalsIgnoreCase("BMOVE")) {
					String subject = null;
					String from = null;
					String receivedDate = null;
					
					for (Message message : deleteMsgs) {
						subject = ezEmailUtil.getSubject(message);
						subject = (subject != null) ? subject : "";
						from = ezEmailUtil.getFullFromAddressOfMessage(message);
						receivedDate = (message.getReceivedDate() != null) ? message.getReceivedDate().toString() : "";
						
						logger.debug("subject=" + subject + ",from=" + from + ",receivedDate=" + receivedDate);
					}
				}
			}
			
			String useImapMoveCommand = ezCommonService.getTenantConfig("useImapMoveCommand", userInfo.getTenantId());
			
			if (useImapMoveCommand.equals("YES")) {
				if (cmd.equalsIgnoreCase("BMOVE")) {
					IMAPFolder deletedFolder = (IMAPFolder)ia.getFolder(ezEmailUtil.getTrashFolderId(locale));			
					sourceFolder.moveUIDMessages(deleteMsgs, deletedFolder);
				} else {			
					sourceFolder.setFlags(deleteMsgs, new Flags(Flags.Flag.DELETED), true);
				}
			} else {
				if (cmd.equalsIgnoreCase("BMOVE")) {
					// 지운 편지함으로 보낼 메시지의 크기가 Quota량을 초과하게 되면 Quota를 재조정한다.
					Double[] adjustQuotaData = ezEmailUtil.adjustUserQuotaForMessageMove(deleteMsgs, userEmail, domainName, ia);
					
					if (adjustQuotaData[0] != null) {
						isNewUserQuotaNeeded = true;
						
						userQuota = adjustQuotaData[0];
						userWarn = adjustQuotaData[1];
					}

					if (adjustQuotaData[2] != null) {
						isThereUserLevelQuota = true;
					}
									
					IMAPFolder deletedFolder = (IMAPFolder)ia.getFolder(ezEmailUtil.getTrashFolderId(locale));			
					sourceFolder.copyUIDMessages(deleteMsgs, deletedFolder);
				}
				
				sourceFolder.setFlags(deleteMsgs, new Flags(Flags.Flag.DELETED), true);				
			}
					
			sourceFolder.close(true);		
		} catch (Exception e) {
			returnData = "ERROR : " + e.getMessage();
			e.printStackTrace();
		} finally {
			if (ia != null) {
				ia.close();		
			}
			
			// 사용자 Quota를 변경시켰다면 원래 값으로 복원시킨다.			
			if (isNewUserQuotaNeeded) {
				if (isThereUserLevelQuota) {
					ezEmailUtil.setUserQuota(userEmail, String.valueOf(userQuota), String.valueOf(userWarn));
				// 사용자 레벨 Quota 설정값이 없었던 경유에는 해당 설정값을 삭제한다.
				} else {
					ezEmailUtil.deleteUserQuota(userEmail);
				}
			}
		}
		
		logger.debug("returnData=" + returnData);
		logger.debug("mailDelete ended.");
		
		return returnData;				
	}
	
	/**
	 * 메일 이동/복사 실행 함수
	 */
	@RequestMapping(value="/ezEmail/mailMoveCopyMessage.do")
	@ResponseBody
	public String mailMoveCopyMessage(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, 
			@RequestBody String bodyData, Locale locale, Model model) throws Exception {
		logger.debug("mailMoveCopyMessage started.");
		logger.debug("bodyData=" + bodyData);
		
		String returnValue = "OK";
		
		IMAPAccess ia = null;
        boolean isNewUserQuotaNeeded = false;	
        boolean isThereUserLevelQuota = false;
        String userEmail = "";
        Double userQuota = 0.0;
        Double userWarn = 0.0;        		
		
		try {
			List<String> userIdAndPassword = commonUtil.getUserIdAndPassword(loginCookie);
			String password = userIdAndPassword.get(1);
			
			Document doc = commonUtil.convertStringToDocument(bodyData);
			String cmd = doc.getElementsByTagName("CMD").item(0).getTextContent();
			String uniqueId = doc.getElementsByTagName("UNIQUEID").item(0).getTextContent();
			String mfolderId = doc.getElementsByTagName("FOLDERID").item(0).getTextContent();
			
			String[] folderAndMsgIdArray = ezEmailUtil.makeFolderAndMsgIdArray(uniqueId);
			
			String folderId = folderAndMsgIdArray[0].split("/")[0];			
			long[] uids = new long[folderAndMsgIdArray.length];
			
			for (int i = 0; i < folderAndMsgIdArray.length; i++) {
				String folderAndMsgId = folderAndMsgIdArray[i];
				String msgId = folderAndMsgId.split("/")[1];
				uids[i] = Long.parseLong(msgId);
			}
			
			LoginVO userInfo = commonUtil.userInfo(loginCookie);
	        String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
	        userEmail = userInfo.getId() + "@" + domainName;
	        String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", userInfo.getTenantId());
	        
	        if (useSharedMailbox.equals("YES")) {
	        	String shareId = request.getParameter("shareId");
				logger.debug("shareId=" + shareId);
		        
		        if (shareId != null) {
					if (!ezEmailService.checkUserShareId(userInfo.getId(), shareId, 1, userInfo.getTenantId())) {
						logger.debug("the user cannot access the shareId.");
						logger.debug("mailMoveCopyMessage ended.");
						
						return "";
					}
					
					userEmail = shareId + "@" + domainName;
				}
	        }
	        
	        logger.debug("userId=" + userInfo.getId() + ",userEmail=" + userEmail);
	        
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userEmail, password, egovMessageSource, locale, ezEmailUtil);
					
			IMAPFolder sourceFolder = (IMAPFolder)ia.getFolder(folderId);		
			sourceFolder.open(Folder.READ_WRITE);
			
			Message[] messages = sourceFolder.getMessagesByUID(uids);						
			IMAPFolder movefolder = (IMAPFolder)ia.getFolder(mfolderId);			
			
			String useImapMoveCommand = ezCommonService.getTenantConfig("useImapMoveCommand", userInfo.getTenantId());
			
			if (useImapMoveCommand.equals("YES")) {			
				if (cmd.equalsIgnoreCase("MOVE")) {
					sourceFolder.moveUIDMessages(messages, movefolder);
				} else {					
					sourceFolder.copyUIDMessages(messages, movefolder);					
				}
			} else {
				if (cmd.equalsIgnoreCase("MOVE")) {
					// 이동시킬 메시지의 크기가 Quota량을 초과하게 되면 Quota를 재조정한다.
					Double[] adjustQuotaData = ezEmailUtil.adjustUserQuotaForMessageMove(messages, userEmail, domainName, ia);
					
					if (adjustQuotaData[0] != null) {
						isNewUserQuotaNeeded = true;
						
						userQuota = adjustQuotaData[0];
						userWarn = adjustQuotaData[1];
					}

					if (adjustQuotaData[2] != null) {
						isThereUserLevelQuota = true;
					}				
				}
				
				sourceFolder.copyUIDMessages(messages, movefolder);
				
				if (cmd.equalsIgnoreCase("MOVE")) {
					sourceFolder.setFlags(messages, new Flags(Flags.Flag.DELETED), true);
				}									
			}
			
			sourceFolder.close(true);		
		} catch (Exception e) {
			returnValue = "ERROR : " + e.getMessage();
			e.printStackTrace();
		} finally {
			if (ia != null) {
				ia.close();
			}
			
			// 사용자 Quota를 변경시켰다면 원래 값으로 복원시킨다.			
			if (isNewUserQuotaNeeded) {
				if (isThereUserLevelQuota) {
					ezEmailUtil.setUserQuota(userEmail, String.valueOf(userQuota), String.valueOf(userWarn));
				// 사용자 레벨 Quota 설정값이 없었던 경유에는 해당 설정값을 삭제한다.
				} else {
					ezEmailUtil.deleteUserQuota(userEmail);
				}
			}			
		}
		
		logger.debug("returnValue=" + returnValue);
		logger.debug("mailMoveCopyMessage ended.");
		
		return returnValue;
	}
	
	/**
	 * 메일 책갈피 지정 실행 함수
	 */
	@RequestMapping(value="/ezEmail/mailSetFlag.do",method=RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String mailSetFlag(@CookieValue("loginCookie") String loginCookie,
			HttpServletRequest request,
			@RequestBody String bodyData,
			Locale locale, Model model) throws Exception {
		logger.debug("mailSetFlag started.");
		logger.debug("bodyData=" + bodyData);
		
		String returnData = "";
		
		// get user credentials
		List<String> userIdAndPassword = commonUtil.getUserIdAndPassword(loginCookie);
		String password = userIdAndPassword.get(1);
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
        String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
        String userEmail = userInfo.getId() + "@" + domainName;
        String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", userInfo.getTenantId());

        if (useSharedMailbox.equals("YES")) {
        	String shareId = request.getParameter("shareId");
    		logger.debug("shareId=" + shareId);
            
            if (shareId != null) {
    			if (!ezEmailService.checkUserShareId(userInfo.getId(), shareId, userInfo.getTenantId())) {
    				logger.debug("the user cannot access the shareId.");
    				logger.debug("mailSetFlag ended.");
    				
    				return "";
    			}
    			
    			userEmail = shareId + "@" + domainName;
    		}
        }
        
        logger.debug("userId=" + userInfo.getId() + ",userEmail=" + userEmail);
        
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
					userEmail, password, egovMessageSource, locale, ezEmailUtil);
					
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
		
		logger.debug("returnData=" + returnData);
		logger.debug("mailSetFlag ended.");
		
		return returnData;				
	}
	
	/**
	 * 메일 읽음 상태 지정 실행 함수
	 */
	@RequestMapping(value="/ezEmail/mailSetReadChange.do",method=RequestMethod.POST,
			produces="text/xml; charset=utf-8")
	@ResponseBody
	public String mailSetReadChange(@CookieValue("loginCookie") String loginCookie,
			HttpServletRequest request,
			@RequestBody String bodyData,
			Locale locale, Model model) throws Exception {
		logger.debug("mailSetReadChange started.");
		logger.debug("bodyData=" + bodyData);

		// get user credentials
		List<String> userIdAndPassword = commonUtil.getUserIdAndPassword(loginCookie);
		String password = userIdAndPassword.get(1);
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
        String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
        String userEmail = userInfo.getId() + "@" + domainName;
        String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", userInfo.getTenantId());

        if (useSharedMailbox.equals("YES")) {
        	String shareId = request.getParameter("shareId");
    		logger.debug("shareId=" + shareId);
            
            if (shareId != null) {
    			if (!ezEmailService.checkUserShareId(userInfo.getId(), shareId, userInfo.getTenantId())) {
    				logger.debug("the user cannot access the shareId.");
    				logger.debug("mailSetReadChange ended.");
    				
    				return "";
    			}
    			
    			userEmail = shareId + "@" + domainName;
    		}
        }
        
        logger.debug("userId=" + userInfo.getId() + ",userEmail=" + userEmail);
        
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
					userEmail, password, egovMessageSource, locale, ezEmailUtil);
					
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
		
		logger.debug("returnData=" + returnData);
		logger.debug("mailSetReadChange ended.");
		
		return returnData;				
	}
	
	/**
	 * 메일에서 보낸사람 정보 추출 함수
	 */
	@RequestMapping(value="/ezEmail/mailGetFromEmail.do", produces="text/xml; charset=utf-8")
	@ResponseBody
	public String mailGetFromEmail(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request,
			@RequestBody String bodyData, Locale locale, Model model) throws Exception {
		logger.debug("mailGetFromEmail started.");
		logger.debug("bodyData=" + bodyData);
		
		Document xmldom = commonUtil.convertStringToDocument(bodyData);
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
			logger.debug("mailGetFromEmail ended.");
			return "ERROR";
		}
		
		List<String> userInfo = commonUtil.getUserIdAndPassword(loginCookie);
		String password  = userInfo.get(1);
		
		LoginVO loginInfo = commonUtil.userInfo(loginCookie);
        String domainName = ezCommonService.getTenantConfig("DomainName", loginInfo.getTenantId());
        String userEmail = loginInfo.getId() + "@" + domainName;
        String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", loginInfo.getTenantId());

        if (useSharedMailbox.equals("YES")) {
        	String shareId = request.getParameter("shareId");
    		logger.debug("shareId=" + shareId);
            
            if (shareId != null) {
    			if (!ezEmailService.checkUserShareId(loginInfo.getId(), shareId, loginInfo.getTenantId())) {
    				logger.debug("the user cannot access the shareId.");
    				logger.debug("mailGetFromEmail ended.");
    				
    				return "";
    			}
    			
    			userEmail = shareId + "@" + domainName;
    		}
        }
        
        logger.debug("userId=" + loginInfo.getId() + ",userEmail=" + userEmail);
        
		IMAPAccess ia = null;
		String resultData = "ERROR";
		try {
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userEmail, password, egovMessageSource, locale, ezEmailUtil);
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
		
		logger.debug("resultData=" + resultData);
		logger.debug("mailGetFromEmail ended.");
		
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
			@RequestBody String bodyData, Locale locale, Model model) throws Exception {
		logger.debug("mailRequestDenial started.");
		
		String returnData = "<DATA><![CDATA[ERROR]]></DATA>";
		
		Document xmldom = commonUtil.convertStringToDocument(bodyData);
		NodeList nodes = xmldom.getElementsByTagName("DENIAL");
		
		if (nodes == null || nodes.getLength() == 0) {
			logger.error("cannot get request data");
			logger.debug("mailRequestDenial ended.");
			return returnData;
		}
		
		StringBuilder sb = new StringBuilder();
		
		LoginVO loginInfo = commonUtil.userInfo(loginCookie);
        String domainName = ezCommonService.getTenantConfig("DomainName", loginInfo.getTenantId());
        String userEmail = loginInfo.getId() + "@" + domainName;
		
        logger.debug("userEmail=" + userEmail);
        
		sb.append("userId=" + URLEncoder.encode(userEmail, "UTF-8"));
		
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
		
		logger.debug("returnData=" + returnData);
		logger.debug("mailRequestDenial ended.");
		
		return returnData;
	}
	
	/**
	 * mail list 및 mail quota 정보 추출 함수 (portal 연동)
	 */
	@RequestMapping(value="/ezEmail/getPortletMailList.do", produces="text/xml; charset=utf-8")
	@ResponseBody
	public String getPortletMailList(@CookieValue("loginCookie") String loginCookie,
			Locale locale, Model model) throws Exception {
		logger.debug("getPortletMailList started.");
		
		String returnData = "";
		String folderPath = "INBOX";
		IMAPAccess ia = null;
		
		try {
			// get user credentials
			List<String> userIdAndPassword = commonUtil.getUserIdAndPassword(loginCookie);
			String password = userIdAndPassword.get(1);		
			
	        LoginVO userInfo = commonUtil.userInfo(loginCookie);
	        String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
	        String userAccount = userInfo.getId() + "@" + domainName;
			
	        logger.debug("userEmail=" + userAccount);
	        
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userAccount, password, egovMessageSource, locale, 40*1000, 20*1000, ezEmailUtil);
			
			long[] storageUsageAndLimit = ia.getStorageUsageAndLimit();
			
			double mailboxUsage = storageUsageAndLimit[0]; // in KBs
			double mailboxQuota = storageUsageAndLimit[1]; // in KBs
			
			// 재은 수정
			String[] mailUse = ezEmailUtil.getMailUsage(mailboxUsage, mailboxQuota);
			String mailPercent = "";
			String mailboxDetail = "";
			String mailboxQuotaStr = "";
			
			if (mailUse != null) {
				mailPercent = mailUse[0];
				mailboxDetail = mailUse[1];
				mailboxQuotaStr = mailUse[2];
			}
					
			logger.debug("mailPercent=" + mailPercent + ",mailboxDetail=" + mailboxDetail + ",mailboxQuotaStr=" + mailboxQuotaStr);		
			
			Folder folder = ia.getFolder(folderPath);		
			folder.open(Folder.READ_ONLY);
	        
	        Message[] messages = null;
	        
 			int mailCount = 7;
 			int unreadCount = ia.getUnreadCount(folderPath);
 			
	        messages = ezEmailUtil.searchFolder(ia, userAccount, folder, "", "", null, null, false, 
	        		false, false, "receivedDate", false, 0, mailCount, false, null, userInfo.getTenantId());
	        
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
			sdf.setTimeZone(TimeZone.getTimeZone("GMT"));
			
			StringBuilder sb = new StringBuilder();
			sb.append("<DATA>");
			
			for (int i=0; i<messages.length; i++) {
				Message message = messages[i];
				UIDFolder uidFolder = (UIDFolder)message.getFolder();
				
				// href
				String href = "INBOX/" + uidFolder.getUID(message);
				
				// received date
				Date receivedDate = message.getReceivedDate();
				String receivedDateStr = sdf.format(receivedDate);
				receivedDateStr = commonUtil.getDateStringInUTC(receivedDateStr, userInfo.getOffset(), false);
				
				// sender
				String sender = ezEmailUtil.getFromNameOrAddressOfMessage(message);
				
				// subject
				String subject = ezEmailUtil.getSubject(message);				
				subject = (subject != null) ? subject : "";
				
				if (ezEmailUtil.hasSecureMailFlag(message)) {
					subject = "<img src=\"/images/email/secureMail/security_icon.gif\" width=\"12\" />" + subject;
				}
				
				int readFlag = message.isSet(Flags.Flag.SEEN) ? 1 : 0;
				
				sb.append("<NODE>");
				sb.append("<HREF><![CDATA[" + href + "]]></HREF>");
				sb.append("<DATE><![CDATA[" + receivedDateStr + "]]></DATE>");
				sb.append("<SENDER><![CDATA[" + sender + "]]></SENDER>");
				sb.append("<SUBJECT><![CDATA[" + subject + "]]></SUBJECT>");
				sb.append("<READ><![CDATA[" + readFlag + "]]></READ>");
				sb.append("</NODE>");
			}
			
			sb.append("<TOTALCNT>" + unreadCount + "</TOTALCNT>");
			sb.append("<MAILBOXSIZE>" + mailboxQuotaStr + "</MAILBOXSIZE>");
			sb.append("<MAILBOXDETAIL>" + mailboxDetail + "</MAILBOXDETAIL>");
			sb.append("<MAILPERCENT>" + mailPercent + "</MAILPERCENT>");
			sb.append("</DATA>");
			
			returnData = sb.toString();
		
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (ia != null) {
				ia.close();
			}
		}
		
		logger.debug("getPortletMailList ended.");
		
		return returnData;
	}
	
}
