package egovframework.ezEKP.ezEmail.web;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Optional;
import java.util.Properties;
import java.util.TimeZone;
import java.util.regex.PatternSyntaxException;

import javax.annotation.Resource;
import javax.mail.*;
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
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import com.sun.mail.imap.IMAPFolder;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.logic.IMAPAccess;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezEmail.util.EzEmailUtil;
import egovframework.ezEKP.ezEmail.vo.MailGeneralVO;
import egovframework.ezEKP.ezEmail.vo.MailSharedMailboxUserVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovStringUtil;
import egovframework.let.utl.rest.Rest;

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

	@Autowired
	private Rest rest;

	/**
	 * 메일 검색 화면 표시 함수
	 */
	@RequestMapping(value="/ezEmail/mailSearchView.do", method=RequestMethod.GET)
	public String mailSearchView(@CookieValue("loginCookie") String loginCookie, 
			Locale locale,
			HttpServletRequest request,
			Model model) throws Exception {
		logger.debug("mailSearchView started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
		String userEmail = userInfo.getId() + "@" + domainName;
		String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", userInfo.getTenantId());
		String mailSearchPeriod = "";
		
		if (useSharedMailbox.equals("YES")) {
			String shareId = request.getParameter("shareId");
			logger.debug("shareId=" + shareId);
			
			if (shareId != null) {
				if (!ezEmailService.checkUserShareId(userInfo.getId(), shareId, userInfo.getTenantId())) {
					model.addAttribute("mainContent", egovMessageSource.getMessage("ezEmail.lhm81", locale));
					
					logger.debug("the user cannot access the shareId.");
					logger.debug("mailSearchView ended.");
					
					return "ezCommon/error";
				} else {
					MailSharedMailboxUserVO shareInfo = ezEmailService.getSharedMailboxPermissionInfo(shareId, userInfo.getTenantId(), userInfo.getId());
					
					model.addAttribute("shareId", shareId);
					model.addAttribute("shareName", shareInfo.getShareName());
					model.addAttribute("deletePermission", shareInfo.getDeletePermission());
					model.addAttribute("sendPermission", shareInfo.getSendPermission());
					
					userEmail = shareId + "@" + domainName;
				}
			}
		}
		
		logger.debug("userId=" + userInfo.getId() + ",userEmail=" + userEmail);
		
		// get user credentials
		List<String> userIdAndPassword = commonUtil.getUserIdAndPassword(loginCookie);
		String password = userIdAndPassword.get(1);	
		
		String serverName = userInfo.getServerName();
		String userLang = userInfo.getLang();
		String useEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		
		String userTimeSet = userInfo.getOffset();
		String offsetMin = commonUtil.getMinuteUTC(userTimeSet);
		
		String useEncryptZipForEmail = ezCommonService.getTenantConfig("UseEncryptZipForEmail", userInfo.getTenantId());
		
		if (useEncryptZipForEmail.equals("")) {
			useEncryptZipForEmail = "NO";
		}
		
		logger.debug("userTimeSet=" + userTimeSet + ",offsetMin=" + offsetMin + ", useEncryptZipForEmail=" + useEncryptZipForEmail);
		
		List<String> topLevelFolderNames = null;
		IMAPAccess ia = null;
		try {
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userEmail, password, egovMessageSource, locale, ezEmailUtil);
			
			String useDefaultFoldersForLangOnly = ezCommonService.getTenantConfig("UseDefaultFoldersForLangOnly", userInfo.getTenantId());
			boolean isUseDefaultFoldersForLangOnly = useDefaultFoldersForLangOnly.equals("YES") ? true : false;

			if (ia != null){
				List<Folder> topLevelFolders = ia.getTopLevelFolders(true, isUseDefaultFoldersForLangOnly);
				if (topLevelFolders == null){
					throw new Exception("TopLevelFolders is null");
				}
				topLevelFolderNames = new ArrayList<String>();
				int maxFolderCount = Math.min(5, topLevelFolders.size());

				for (int i = 0; i < maxFolderCount; i++) {
					Folder folder = topLevelFolders.get(i);

					topLevelFolderNames.add(folder.getName());
				}

				logger.debug("topLevelFolderNames=" + topLevelFolderNames);
			}


			// 2022-12-19 이사라 : 검색기간의 디폴트 기간을 메일 환경설정에서 설정한 값으로 세팅하기 위해 추가
			MailGeneralVO mailGeneral = ezEmailService.getMailGeneral(userInfo.getTenantId(), userInfo.getId()).get(0);
			mailSearchPeriod = mailGeneral.getMailSearchPeriod();

			logger.debug("mailSearchPeriod=" + mailSearchPeriod);
			
		} catch (RuntimeException e) {
			logger.error(e.getMessage(), e);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		} finally {
			if (ia != null) {
				ia.close();
			}
		}

		boolean isDotNetIntegration = "YES".equalsIgnoreCase(ezCommonService.getTenantConfig("dotNetIntegration", userInfo.getTenantId()));
		
		model.addAttribute("isDotNetIntegration", userInfo.getId());
		model.addAttribute("userId", userInfo.getId());
		model.addAttribute("serverName", serverName);
		model.addAttribute("userLang", userLang);
		model.addAttribute("useEditor", useEditor);
		model.addAttribute("userTimeSet", userTimeSet);
		model.addAttribute("offsetMin", offsetMin);
		model.addAttribute("topLevelFolderNames", topLevelFolderNames);
		model.addAttribute("useEncryptZipForEmail", useEncryptZipForEmail);
		model.addAttribute("searchCheck", request.getParameter("searchCheck"));
		model.addAttribute("keywordFromList", request.getParameter("keywordFromList"));
		model.addAttribute("searchFromList", request.getParameter("searchFromList"));
		model.addAttribute("mailSearchPeriod", mailSearchPeriod);
		
		logger.debug("mailSearchView ended.");
		
		return "ezEmail/mailSearchView";		
	}
	
	/**
	 * 메일 검색 함수
	 */
	@RequestMapping(value="/ezEmail/mailSearch.do", method=RequestMethod.POST,
			produces="text/xml; charset=utf-8")
	@ResponseBody
	public String mailSearch(@CookieValue("loginCookie") String loginCookie, @RequestBody String bodyData, Locale locale, Model model, HttpServletRequest request) throws Exception {
		logger.debug("mailSearch started.");		
		logger.debug("bodyData=" + bodyData);

		// get user credentials
		List<String> userIdAndPassword = commonUtil.getUserIdAndPassword(loginCookie);
		String password = userIdAndPassword.get(1);		
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
		String userEmail = userInfo.getId() + "@" + domainName;
		String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", userInfo.getTenantId());
		String useRDBOnlyMailList = ezCommonService.getTenantConfig("useRDBOnlyMailList", userInfo.getTenantId());
		
		if (useSharedMailbox.equals("YES")) {
			String shareId = request.getParameter("shareId");
			logger.debug("shareId=" + shareId);
			
			if (shareId != null) {
				if (!ezEmailService.checkUserShareId(userInfo.getId(), shareId, userInfo.getTenantId())) {
					logger.debug("the user cannot access the shareId.");
					logger.debug("mailSearch ended.");
					
					return "";
				} else {
					userEmail = shareId + "@" + domainName;
				}
			}
		}
		
		logger.debug("userId=" + userInfo.getId() + ",userEmail=" + userEmail);
		
		Document doc = commonUtil.convertStringToDocument(bodyData != null ? bodyData : "");
		
		String mailFolder = doc.getElementsByTagName("MAILFOLDER").item(0).getTextContent();

		NodeList  nListCategory = doc.getElementsByTagName("CATEGORY");
		NodeList  nListKeyword = doc.getElementsByTagName("KEYWORD");
		String[] categoryArray = new String[nListCategory.getLength()] ;
		String[] keywordArray = new String[nListKeyword.getLength()] ;
		
		for (int i = 0; i < nListCategory.getLength(); i++) {
			categoryArray[i] = doc.getElementsByTagName("CATEGORY").item(i).getTextContent();
		}
		
		for (int i = 0; i < nListKeyword.getLength(); i++) {
			keywordArray[i] = EgovStringUtil.getHtmlStrCnvr(doc.getElementsByTagName("KEYWORD").item(i).getTextContent());
		}
		
		String tagName = Optional.ofNullable(doc.getElementsByTagName("TAGNAME").item(0)).map(Node::getTextContent).orElse("");
		String startDate = doc.getElementsByTagName("STARTDATE").item(0).getTextContent();
		String endDate = doc.getElementsByTagName("ENDDATE").item(0).getTextContent();
		String prop = doc.getElementsByTagName("PORP").item(0).getTextContent();
		String orderBy = doc.getElementsByTagName("ORDERBY").item(0).getTextContent();
		int startIndex = Integer.parseInt(doc.getElementsByTagName("STARTINDEX").item(0).getTextContent());
		int listCount = Integer.parseInt(doc.getElementsByTagName("LISTCOUNT").item(0).getTextContent());
		
		String andorStatus = doc.getElementsByTagName("ANDORSTATUS").item(0).getTextContent();
		String attachStatus = doc.getElementsByTagName("ATTACHSTATUS").item(0).getTextContent();
		
		startDate = commonUtil.getDateStringInUTC(startDate, userInfo.getOffset(), true);
		endDate = commonUtil.getDateStringInUTC(endDate, userInfo.getOffset(), true);
		
		SimpleDateFormat sdfForParsing = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		sdfForParsing.setTimeZone(TimeZone.getTimeZone("GMT"));
		
		Date startDateObj = startDate.equals("") ? null : sdfForParsing.parse(startDate);
		Date endDateObj = endDate.equals("") ? null : new Date(sdfForParsing.parse(endDate).getTime() + 60*60*24*1000);
		
		// 가온누리에서 분석 결과 endDate가 없는 경우 null보다 현재 시각으로 지정하는 것이 성능이 훨씬 좋게 나와 추가함.
		if (endDateObj == null) {
			endDateObj = new Date();
		}
		
		String returnData = "";
		IMAPAccess ia = null;
		
		try {
			StringBuilder sb = new StringBuilder();
			sb.append("<DATA><ROWS>");
			
			int totalCount = 0;
			
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
						
			Map<String, Object> extraMap = new HashMap<String, Object>();
			extraMap.put("andorStatus", andorStatus);
			extraMap.put("attachStatus", attachStatus);
			
			if (useRDBOnlyMailList.equals("YES")) {
				String folderPath = "";
				
				if (!mailFolder.equals("ALL")) {
					folderPath = mailFolder;
				}
				
				List<Map<String, String>> mailList = ezEmailUtil.searchFolderUsingRDBOnly(userEmail, folderPath, categoryArray, keywordArray, startDateObj, endDateObj, true, 
						false, false, sortTypeSpecifier, isAscending, startIndex, listCount, false, extraMap, userInfo.getTenantId(), false, tagName);
								
				totalCount = (int) extraMap.get("totalCount");
				logger.debug("totalCount=" + totalCount);
					
				for (Map<String, String> mailInfo : mailList) {
					sb.append("<ROW>");
					
					sb.append(String.format("<ITEMID><![CDATA[%s]]></ITEMID>", mailInfo.get("MAIL_ID")));
					
					String email = ezEmailUtil.getAddress(mailInfo.get("SENDER"));
					sb.append(String.format("<FROMEMAIL><![CDATA[%s]]></FROMEMAIL>", email));
					
					String name = ezEmailUtil.getNameOrAddress(mailInfo.get("SENDER"));			
					sb.append(String.format("<FROMNAME><![CDATA[%s]]></FROMNAME>", name));
					
					String displayTo = "";
					String msgto = "";
					// To, Cc, Bcc를 모두 포함한다.
					String recipientsStr = mailInfo.get("RECIPIENT");
					msgto = String.format("%s <%s>", name, email);

					if (!recipientsStr.isEmpty()) {
						// To, Cc, Bcc를 분리한다.(||로 구분됨.)
						String[] recipientsArr = recipientsStr.split("\\|\\|", 3);		
						
						if (!recipientsArr[0].isEmpty()) {
							String[] toStrArr = recipientsArr[0].split("; ");
							StringBuilder msgtoBuilder = new StringBuilder();
							
							for (String toStr : toStrArr) {
								toStr = toStr.trim();
								String[] tokens = toStr.split(" <");
								String toName = tokens[0]; 
								
								msgtoBuilder.append(toName);
								msgtoBuilder.append("; ");								
							}

							displayTo = msgtoBuilder.toString();
							displayTo = displayTo.substring(0, displayTo.length() - 2);								
						}
					}
					
					sb.append(String.format("<DISPLAYTO><![CDATA[%s]]></DISPLAYTO>", displayTo));
					sb.append(String.format("<MSGTO><![CDATA[%s]]></MSGTO>", msgto));

					SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm");				
					Date receivedDate = df.parse(mailInfo.get("MAIL_DATE"));
					SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
					sdf.setTimeZone(TimeZone.getTimeZone("UTC"));
					sb.append(String.format("<DATERECEIVED><![CDATA[%s]]></DATERECEIVED>", sdf.format(receivedDate)));
										
					folderPath = mailInfo.get("MAIL_ID").split("/")[0];					
					String folderPathName = ezEmailUtil.getDisplayNameFromFolderId(folderPath, locale);
					folderPathName = folderPathName.replaceAll("\\.", "/");
					sb.append(String.format("<PARENTNAME><![CDATA[/%s]]></PARENTNAME>", folderPathName));					
					
					// subject
					String subject = mailInfo.get("SUBJECT");
									
					subject = (subject != null) ? subject : "";
					sb.append(String.format("<SUBJECT><![CDATA[%s]]></SUBJECT>", subject));
					
					// secureMail
					sb.append(String.format("<SECUREMAIL>%s</SECUREMAIL>", mailInfo.get("MAIL_IS_SECURED")));
					
					sb.append(String.format("<IMPORTANCE><![CDATA[%s]]></IMPORTANCE>", mailInfo.get("IMPORTANCE")));
					
					// attachment
					sb.append(String.format("<HASATTACHMENT><![CDATA[%s]]></HASATTACHMENT>", mailInfo.get("HAS_ATTACH")));
					
					sb.append(String.format("<READ><![CDATA[%s]]></READ>", mailInfo.get("MAIL_IS_SEEN")));
					
					sb.append(String.format("<CONTENTCLASS><![CDATA[%s]]></CONTENTCLASS>", "IPM.Note"));
					
					sb.append(String.format("<FLAG><![CDATA[%s]]></FLAG>", mailInfo.get("MAIL_IS_FLAGGED")));
					sb.append(String.format("<SIZE><![CDATA[%s]]></SIZE>", mailInfo.get("MAIL_SIZE")));
					
					sb.append("</ROW>");
				}				
			} else {
				ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
						userEmail, password, egovMessageSource, locale, 150*1000, 20*1000, ezEmailUtil);
											
				Folder folder = null;
				Message[] messages = null;
				
				if (ia != null && !mailFolder.equals("ALL")) {
					folder = ia.getFolder(mailFolder != null ? mailFolder : "");
					if (folder == null){
						throw new Exception("folder is null");
					}
					folder.open(Folder.READ_ONLY);
				}
				
				messages = ezEmailUtil.searchFolder(ia, userEmail, folder, categoryArray, keywordArray, startDateObj, endDateObj, true, 
						false, false, sortTypeSpecifier, isAscending, startIndex, listCount, false, extraMap, userInfo.getTenantId(), tagName);
				
				totalCount = (int) extraMap.get("totalCount");
				logger.debug("totalCount=" + totalCount);
					
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
					
					String folderPathName = ezEmailUtil.getDisplayNameFromFolderId(folderPath, locale);
					folderPathName = folderPathName.replaceAll("\\.", "/");
					sb.append(String.format("<PARENTNAME><![CDATA[/%s]]></PARENTNAME>", folderPathName));
					
					// subject
					String subject = ezEmailUtil.getSubject(message);
									
					subject = (subject != null) ? subject : "";
					sb.append(String.format("<SUBJECT><![CDATA[%s]]></SUBJECT>", subject));
					
					// secureMail
					if (ezEmailUtil.hasSecureMailFlag(message)) {
						sb.append(String.format("<SECUREMAIL>1</SECUREMAIL>"));
					} else {
						sb.append(String.format("<SECUREMAIL>0</SECUREMAIL>"));
					}
					
					String[] headers = message.getHeader("X-Priority");
					String header = "";
					int importance = 1;
					
					if (headers == null){
						//importance      = "low" / "normal" / "high"
						String[] headerImportance = message.getHeader("Importance"); 
						
						if (headerImportance == null){
							header = "normal";
						} else {
							header = headerImportance[0];
						}
					} else {
						header = headers[0];
					}
					// startsWith is used since
					// there are cases like X-Priority: 1 (Highest) generated by Thunderbird.
					if (header.startsWith("1") || header.startsWith("high")) {
						importance = 2;
					} else if (header.startsWith("5") || header.startsWith("low")) {
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
			
			sb.append("</ROWS>");
			sb.append(String.format("<TOTALCOUNT><![CDATA[%d]]></TOTALCOUNT>", totalCount));
			sb.append("</DATA>");
			
			returnData = sb.toString();
		
		} catch (PatternSyntaxException e) {
			returnData = "<DATA>ERROR</DATA>";
			logger.error(e.getMessage(), e);
		} catch (Exception e) {
			returnData = "<DATA>ERROR</DATA>";
			logger.error(e.getMessage(), e);
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
	@RequestMapping(value="/ezEmail/mailDeleteS.do", method=RequestMethod.POST,
			produces="text/xml; charset=utf-8")
	@ResponseBody
	public String mailDeleteS(@CookieValue("loginCookie") String loginCookie, 
			@RequestParam("cmd") String cmd,
			@RequestBody String bodyData,
			Locale locale, Model model,
			HttpServletRequest request) throws Exception {
		logger.debug("mailDeleteS started.");
		logger.debug("cmd=" + cmd);
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
				if (!ezEmailService.checkUserShareId(userInfo.getId(), shareId, 1, userInfo.getTenantId())) {
					logger.debug("the user cannot access the shareId.");
					logger.debug("mailDeleteS ended.");
					
					return "";
				} else {
					userEmail = shareId + "@" + domainName;
				}
			}
		}
		
		logger.debug("userId=" + userInfo.getId() + ",userEmail=" + userEmail);
		
		Document doc = commonUtil.convertStringToDocument(bodyData != null ? bodyData : "");
		String uniqueId = doc.getElementsByTagName("UNIQUEID").item(0).getTextContent();	
		
		String folderId = null;

		String[] folderAndMsgIdArray = ezEmailUtil.makeFolderAndMsgIdArray(uniqueId);
					
		String returnData = "OK";
		
		IMAPAccess ia = null;
        
		try {
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userEmail, password, egovMessageSource, locale, ezEmailUtil);

			if (ia != null){
				for (int i = 0; i < folderAndMsgIdArray.length; i++) {
					String folderAndMsgId = folderAndMsgIdArray[i];
					folderId = folderAndMsgId.split("/")[0];
					String msgId = folderAndMsgId.split("/")[1];
					long uid = Long.parseLong(msgId);

					IMAPFolder sourceFolder = (IMAPFolder)ia.getFolder(folderId);
					if (sourceFolder == null){
						throw new Exception("SourceFolder is null");
					}
					sourceFolder.open(Folder.READ_WRITE);

					Message deleteMsg = sourceFolder.getMessageByUID(uid);
					IMAPFolder deletedFolder = (IMAPFolder)ia.getFolder(ezEmailUtil.getTrashFolderId(locale));

					if (deleteMsg != null && !folderId.equals(deletedFolder.toString())) {
						Message[] deleteMsgs = {deleteMsg};

						// 2018-10-09 메일 영구 삭제 시 메일 제목, 받은 날짜 로그 추가
						if (!cmd.equalsIgnoreCase("BMOVE")) {
							String subject = ezEmailUtil.getSubject(deleteMsg);
							subject = (subject != null) ? subject : "";
							String from = ezEmailUtil.getFullFromAddressOfMessage(deleteMsg);
							String receivedDate = (deleteMsg.getReceivedDate() != null) ? deleteMsg.getReceivedDate().toString() : "";

							logger.debug("subject=" + subject + ",from=" + from + ",receivedDate=" + receivedDate);
						}

						String useImapMoveCommand = ezCommonService.getTenantConfig("useImapMoveCommand", userInfo.getTenantId());
						if (useImapMoveCommand.equals("YES")) {
							if (cmd.equalsIgnoreCase("BMOVE")) {
								sourceFolder.moveUIDMessages(deleteMsgs, deletedFolder);
							} else {
								sourceFolder.setFlags(deleteMsgs, new Flags(Flags.Flag.DELETED), true);
							}
						} else {
							if (cmd.equalsIgnoreCase("BMOVE")) {
								sourceFolder.copyUIDMessages(deleteMsgs, deletedFolder);
							}

							sourceFolder.setFlags(deleteMsgs, new Flags(Flags.Flag.DELETED), true);
						}
					} else if (deleteMsg != null) {
						deleteMsg.setFlag(Flags.Flag.DELETED, true);
					}

					sourceFolder.close(true);
				}
			}

				
		} catch (MessagingException e) {
			returnData = "ERROR";
			logger.error(e.getMessage(), e);
		} catch (Exception e) {
			returnData = "ERROR";
			logger.error(e.getMessage(), e);
		} finally {
			if (ia != null) {
				ia.close();
			}
		}
				
		logger.debug("mailDeleteS ended.");
		
		return returnData;
	}
	
	/**
	 * 메일 이동/복사 실행 함수(메일 검색)
	 */
	@RequestMapping(value="/ezEmail/mailMoveCopyMessageS.do", method=RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String mailMoveCopyMessageS(@CookieValue("loginCookie") String loginCookie, @RequestBody String bodyData, 
			Locale locale, Model model, HttpServletRequest request) throws Exception {
		logger.debug("mailMoveCopyMessageS started.");
		logger.debug("bodyData=" + bodyData);
		
		String returnValue = "OK";
		
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
				if (!ezEmailService.checkUserShareId(userInfo.getId(), shareId, 1, userInfo.getTenantId())) {
					logger.debug("the user cannot access the shareId.");
					logger.debug("mailMoveCopyMessageS ended.");
					
					return "";
				} else {
					userEmail = shareId + "@" + domainName;
				}
			}
		}
		
		logger.debug("userId=" + userInfo.getId() + ",userEmail=" + userEmail);

		if (bodyData != null){
			Document doc = commonUtil.convertStringToDocument(bodyData);
			String cmd = doc.getElementsByTagName("CMD").item(0).getTextContent();
			String uniqueId = doc.getElementsByTagName("UNIQUEID").item(0).getTextContent();
			String mfolderId = doc.getElementsByTagName("FOLDERID").item(0).getTextContent();

			String[] folderAndMsgIdArray = ezEmailUtil.makeFolderAndMsgIdArray(uniqueId);

			IMAPAccess ia = null;

			try {
				ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
						userEmail, password, egovMessageSource, locale, ezEmailUtil);

				String useImapMoveCommand = ezCommonService.getTenantConfig("useImapMoveCommand", userInfo.getTenantId());

				if (ia != null){
					for (int i = 0; i < folderAndMsgIdArray.length; i++) {
						String folderAndMsgId = folderAndMsgIdArray[i];
						String folderId = folderAndMsgId.split("/")[0];
						String msgId = folderAndMsgId.split("/")[1];
						long uid = Long.parseLong(msgId);

						IMAPFolder sourceFolder = (IMAPFolder)ia.getFolder(folderId);
						if (sourceFolder == null){
							throw new Exception("SourceFolder is null");
						}
						sourceFolder.open(Folder.READ_WRITE);

						Message message = sourceFolder.getMessageByUID(uid);

						if (message != null) {
							IMAPFolder movefolder = (IMAPFolder)ia.getFolder(mfolderId);

							if (useImapMoveCommand.equals("YES")) {
								if (cmd.equalsIgnoreCase("MOVE")) {
									sourceFolder.moveUIDMessages(new Message[]{message}, movefolder);
								} else {
									sourceFolder.copyUIDMessages(new Message[]{message}, movefolder);
								}
							} else {
								sourceFolder.copyUIDMessages(new Message[]{message}, movefolder);

								if (cmd.equalsIgnoreCase("MOVE")) {
									message.setFlag(Flags.Flag.DELETED, true);
								}
							}
						}

						sourceFolder.close(true);
					}
				}


			} catch (MessagingException e) {
				logger.error(e.getMessage(), e);
				returnValue = "ERROR : " + e.getMessage();
			} catch (Exception e) {
				logger.error(e.getMessage(), e);
				returnValue = "ERROR : " + e.getMessage();
			} finally {
				if (ia != null) {
					ia.close();
				}
			}
		}
		
		logger.debug("mailMoveCopyMessageS ended.");
		
		return returnValue;
	}
	
}
