package egovframework.ezEKP.ezEmail.web;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.net.URLEncoder;
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
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.regex.PatternSyntaxException;
import java.util.stream.Collectors;

import javax.annotation.Resource;
import javax.mail.Address;
import javax.mail.Flags;
import javax.mail.Folder;
import javax.mail.FolderNotFoundException;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.UIDFolder;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeUtility;
import javax.mail.search.FlagTerm;
import javax.servlet.http.HttpServletRequest;

import egovframework.com.cmm.service.Globals;
import egovframework.ezEKP.ezAI.util.AICommonUtil;
import egovframework.ezEKP.ezEmail.vo.*;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;

import org.apache.commons.lang3.ArrayUtils;
import org.apache.commons.lang3.StringUtils;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.w3c.dom.DOMException;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import com.sun.mail.imap.IMAPFolder;
import com.sun.mail.imap.IMAPMessage;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.logic.IMAPAccess;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezEmail.util.EmailImportance;
import egovframework.ezEKP.ezEmail.util.EzEmailUtil;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.let.user.login.vo.LoginSimpleVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovStringUtil;
import egovframework.let.utl.rest.JgwResult;
import egovframework.let.utl.rest.Rest;
import egovframework.let.utl.rest.Result;
import egovframework.let.utl.sim.service.EgovFileScrty;

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

	private static final Pattern NOT_ALLOWED_TAG_NAME_REGEXP = Pattern.compile("[!@#$%^&()\\\\/:*?\"<>|'`]");

	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;

	@Autowired
	private AICommonUtil aICommonUtil;

    @Resource(name="egovMessageSource")
    private EgovMessageSource egovMessageSource;    

    @Resource(name="EzEmailService")
    private EzEmailService ezEmailService;        
	
    @Resource(name = "EzCommonService")
    private EzCommonService ezCommonService;
    
	@Autowired
	private EzEmailUtil ezEmailUtil;
    
	@Autowired
	private EzOrganService ezOrganService;

	@Autowired
	private EzOrganAdminService ezOrganAdminService;

	@Resource(name="crypto") 
    private EgovFileScrty egovFileScrty;
	
	@Autowired
	private Rest rest;

	@Autowired
	private String jspw;

    /**
	 * 메일 리스트화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailList.do", method = RequestMethod.GET)
	public String showMailList(@CookieValue("loginCookie") String loginCookie, 
			Locale locale,
			HttpServletRequest request,
			Model model,
			@RequestParam(required = false) String tagName) throws Exception {
		logger.debug("showMailList started.");
		
		// retrieve the passed in parameters
		String dispname = request.getParameter("dispname");
		dispname = commonUtil.stripTagSymbols(commonUtil.stripScriptTagsAndFunctions(dispname));
		String url = request.getParameter("url");
		url = (url != null) ? url : "INBOX";
		url = commonUtil.stripTagSymbols(commonUtil.stripScriptTagsAndFunctions(url));
		logger.debug("dispname={},url={},tagName={}", dispname, url, tagName);
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		int tenantId = userInfo.getTenantId();
		String folderName = egovMessageSource.getMessage("ezEmail.t644", locale);
		String folderType = "";
		String domainName = ezCommonService.getTenantConfig("DomainName", tenantId);
		String useEditor = ezCommonService.getTenantConfig("EDITOR", tenantId);
		String useOcs = config.getProperty("config.USE_OCS");
		boolean isSentItems = false;
		String useEncryptZipForEmail = ezCommonService.getTenantConfig("UseEncryptZipForEmail", tenantId);
		String useMailBoxBackUp = ezCommonService.getTenantConfig("UseMailBoxBackUp", tenantId);
		String useReSend = ezCommonService.getTenantConfig("useReSend", tenantId);
		String useMailWriteSenderClick = ezCommonService.getTenantConfig("useMailWriteSenderClick", tenantId); // 수아 수정(useMailWriteSenderClick 추가)
		String useSearchContent = ezCommonService.getTenantConfig("useSearchContent", tenantId);
		String useMailNewWindow = ezCommonService.getTenantConfig("useMailNewWindow", tenantId);
		String useCountryIP = ezCommonService.getTenantConfig("useCountryIP", tenantId);
		String systemCountryCode = ezCommonService.getTenantConfig("systemCountryCode", tenantId);
		String useShowSystemCountry = ezCommonService.getTenantConfig("useShowSystemCountry", tenantId);
		String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", tenantId);
		String useMailConfirm = ezCommonService.getTenantConfig("useMailConfirm", tenantId);
		String useHackingMailReport = ezCommonService.getTenantConfig("useHackingMailReport", tenantId);
		String useSecureMail = StringUtils.defaultIfEmpty(ezCommonService.getTenantConfig("USE_SECUREMAIL", tenantId), "NO");
		String userTimeSet = userInfo.getOffset();
		String offsetMin = commonUtil.getMinuteUTC(userTimeSet);
		String serverName = userInfo.getServerName();
		String allMailName = egovMessageSource.getMessage("email.allmail", locale);
		String shareId = request.getParameter("shareId");
		logger.debug("shareId=" + shareId);
		
		if (useSharedMailbox.equals("YES")) {
			if (StringUtils.isNotBlank(shareId)) {
				if (!ezEmailService.checkUserShareId(userInfo.getId(), shareId, tenantId)) {
					model.addAttribute("mainContent", egovMessageSource.getMessage("ezEmail.lhm81", locale));
					
					logger.debug("the user cannot access the shareId.");
					logger.debug("showMailList ended.");
					
					return "ezCommon/error";
				} else {
					MailSharedMailboxUserVO shareVO = ezEmailService.getSharedMailboxPermissionInfo(shareId, tenantId, userInfo.getId());
					
					model.addAttribute("shareId", shareId);
					model.addAttribute("deletePermission", shareVO.getDeletePermission());
					model.addAttribute("sendPermission", shareVO.getSendPermission());
					model.addAttribute("managePermission", shareVO.getManagePermission());
				}
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
		
		if (useMailConfirm.equals("")) {
			useMailConfirm = "NO";
		}
		
		if (dispname != null) {
			folderName = dispname;
		}
		
		if (StringUtils.isNotEmpty(tagName)) {
			folderType = "tag";
		} else if (folderName.equals(allMailName)) {
			folderType = "allMail";
		} else if (folderName.equals(egovMessageSource.getMessage("ezEmail.t645", locale)) || folderName.equals(egovMessageSource.getMessage("ezEmail.t516", locale))) {
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
		MailGeneralVO mailGeneral = ezEmailService.getMailGeneral(tenantId, userInfo.getId()).get(0);
				
		// set importanceColor
		String importanceColor = "#ff0000";
		MailColorVO mailColor = ezEmailService.getMailColor(tenantId);
		
		if (mailColor != null && mailColor.getImportanceColor() != null) {
			importanceColor = mailColor.getImportanceColor();
		}
		
		String userEmail = userInfo.getId() + "@" + domainName;

		if(StringUtils.isNotBlank(shareId)) {
			userEmail = shareId + "@" + domainName;
		}
		
		// 메일 태그 사용확인
		boolean useMailTag = ezEmailUtil.checkUseMailTag(userInfo.getTenantId(), userEmail);

		model.addAttribute("tagName", tagName);
		model.addAttribute("useMailTag", useMailTag);
		
		// 2022-11-02 이사라 - [닷넷연동] 메일 가져오기 실행 시 분기처리 필요하여 추가
		boolean isDotNetIntegration = "YES".equalsIgnoreCase(ezCommonService.getTenantConfig("dotNetIntegration", tenantId));
		// 안읽은 메일 일괄 삭제
		String pDeleteBoxID = ezEmailUtil.getTrashFolderId(locale);

		// set model
		model.addAttribute("pDeleteBoxID", pDeleteBoxID);
		model.addAttribute("isDotNetIntegration", isDotNetIntegration);
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
		model.addAttribute("systemCountryCode", systemCountryCode.toLowerCase());
		model.addAttribute("useShowSystemCountry", useShowSystemCountry);
		model.addAttribute("useMailConfirm", useMailConfirm);
		model.addAttribute("useHackingMailReport", useHackingMailReport);
		model.addAttribute("offsetMin", offsetMin);
		model.addAttribute("serverName", serverName);
		model.addAttribute("useSecureMail", useSecureMail);

		// AI 첨부파일 이름 최대 길이 - 기존 메일과 동일한 값 사용
		String attachFileNameMaxLength = ezCommonService.getTenantConfig("attachFileNameMaxLength", userInfo.getTenantId());
		// AI 사용여부 확인
		boolean useAI = aICommonUtil.checkUseAI(userInfo.getTenantId());
		// AI 챗봇 첨부파일 최대용량
		String aiAttachMBSize = "10";//ezCommonService.getTenantConfig("aiAttachMBSize", -99); // 모든 테넌트 공통 값

		model.addAttribute("useAI", useAI);
		model.addAttribute("attachFileNameMaxLength", attachFileNameMaxLength);
		model.addAttribute("aiAttachMBSize", aiAttachMBSize);


		logger.debug("folderName={}, url={}, folderType={}, isSentItems={}, userLang={},"
					+ " userId={}, domainName={}, useEditor={}, useOcs={}, importanceColor={},"
					, folderName, url, folderType, isSentItems, userInfo.getLang()
					, userInfo.getId(), domainName, useEditor, useOcs, importanceColor);
		logger.debug("UseEncryptZipForEmail={}, useMailBoxBackUp={}, useCountryIP={}, useMailConfirm={}, useHackingMailReport={},"
					+ " offsetMin={}, mailGeneral={}, useSecureMail={}"
					, useEncryptZipForEmail, useMailBoxBackUp, useCountryIP, useMailConfirm, useHackingMailReport
					, offsetMin, mailGeneral, useSecureMail);
		
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
		String startDate = doc.getElementsByTagName("STARTDATE").item(0).getTextContent();
		String endDate = doc.getElementsByTagName("ENDDATE").item(0).getTextContent();
		String andorStatus = doc.getElementsByTagName("ANDORSTATUS").item(0).getTextContent();
		String attachStatus = doc.getElementsByTagName("ATTACHSTATUS").item(0).getTextContent();
		// 2020-08-20 (사조그룹) 보안메일 필터링
		String useSecureMailFilter = doc.getElementsByTagName("SECUREMAILFILTER").item(0).getTextContent();
		String useRDBOnlyMailList = ezCommonService.getTenantConfig("useRDBOnlyMailList", userInfo.getTenantId());
		String useAttachFileFilter = doc.getElementsByTagName("ATTACHFILEFILTER").item(0).getTextContent();
		
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
		
		SimpleDateFormat sdfForParsing = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		sdfForParsing.setTimeZone(TimeZone.getTimeZone("GMT"));
		
		Date startDateObj = startDate.equals("") ? null : sdfForParsing.parse(startDate);
		Date endDateObj = endDate.equals("") ? null : new Date(sdfForParsing.parse(endDate).getTime() + 60*60*24*1000);
		
		logger.debug("userId=" + userInfo.getId() + ",tenantId=" + userInfo.getTenantId() + ",serverName=" + userInfo.getServerName() 
		            + ",folderId=" + folderId + ",sortType=" + sortType + ",start=" + start + ",end=" + end
					+ ",search=" + search + ",viewSelectIndex=" + viewSelectIndex 
					+ ",startDate=" + startDate + ",endDate=" + endDate + ",useSecureMailFilter=" + useSecureMailFilter +",useAttachFileFilter=" + useAttachFileFilter);
		
		String returnData = "";
		
		IMAPAccess ia = null;
		
		try {
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
			extraMap.put("andorStatus", andorStatus);
			extraMap.put("attachStatus", attachStatus);
			extraMap.put("useSecureMailFilter", useSecureMailFilter.equals("1"));
			extraMap.put("useAttachFileFilter",useAttachFileFilter.equals("1"));

			if (useRDBOnlyMailList.equals("YES")) {
				int mailboxMailCount = 0;
				int mailboxUnreadMailCount = 0;
				boolean includeContent = false;

				if (viewSelectIndex.equals("1")) {
					includeContent = true;
				}

				List<Map<String, String>> mailList = ezEmailUtil.searchFolderUsingRDBOnly(userEmail, folderId, categoryArray, keywordArray, startDateObj, endDateObj, false,
						isUnreadOnly, isImportantOnly, sortTypeSpecifier, isAscending, startNo, listCount, false, extraMap, userInfo.getTenantId(), includeContent, "");

				totalCount = (int)extraMap.get("totalCount");
				mailboxMailCount = (int)extraMap.get("mailboxMailCount");
				mailboxUnreadMailCount = (int)extraMap.get("mailboxUnreadMailCount");

				logger.debug("totalCount=" + totalCount + ",mailboxMailCount=" + mailboxMailCount + ",mailboxUnreadMailCount=" + mailboxUnreadMailCount);

				for (Map<String, String> mailInfo : mailList) {
					sb.append("<response>");
					sb.append(String.format("<href><![CDATA[%s]]></href>", mailInfo.get("MAIL_ID")));

					sb.append(String.format("<importance><![CDATA[%s]]></importance>", mailInfo.get("IMPORTANCE")));

					String msgto = "";
					String name = "";

					if (!viewSelectIndex.equals("3")) {
						name = ezEmailUtil.getNameOrAddress(mailInfo.get("SENDER"));
						String senderEmail = ezEmailUtil.getAddress(mailInfo.get("SENDER"));

						msgto = String.format("%s <%s>", name, senderEmail);
					}
					// in case of Sent mailbox
					else {
						// To, Cc, Bcc를 모두 포함한다.
						String recipientsStr = mailInfo.get("RECIPIENT");

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

									msgtoBuilder.append(toStr);
									msgtoBuilder.append(",");

									name += toName;
									name += "; ";
								}

								msgto = msgtoBuilder.toString();
								msgto = msgto.substring(0, msgto.length() - 1);
								name = name.substring(0, name.length() - 2);
							}
						}
					}


					String readDate = "";
					int nameLength = 1;
					int readCount = 0;

					String messageId = mailInfo.get("MESSAGE_ID") != null ? mailInfo.get("MESSAGE_ID") : "";

					//get readList(수신확인)
					List<MailReadVO> readList = ezEmailService.getMailReadList(userInfo.getTenantId(), userInfo.getId(), messageId);

					//get all recipients
					List<String> addressList = new ArrayList<>();
					String recipientsStr = mailInfo.get("RECIPIENT");

					if (!recipientsStr.isEmpty()) {
						// To, Cc, Bcc를 분리한다.(||로 구분됨.)
						String[] recipientsArr = recipientsStr.split("\\|\\|", 3);

						for (String recipientStr : recipientsArr) {
							if (!recipientStr.isEmpty()) {
								String[] addressStrArr = recipientStr.split("; ");

								for (String addressStr : addressStrArr) {
									addressList.add(ezEmailUtil.getAddress(addressStr));
								}
							}
						}
					}

					Map<String, String> aliasAddressList = ezEmailService.getAliasAddressMap(addressList, userInfo.getTenantId());

					List<String> tempMailList = new ArrayList<String>();

					readDate = "UNREAD";
					readCount = 0;

					for (String email : addressList) {
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
					sb.append(String.format("<msgto><![CDATA[%s]]></msgto>", msgto.replace("]]>", "]]]]><![CDATA[>")));
					sb.append(String.format("<recipientCount><![CDATA[%d]]></recipientCount>", addressList.size()));

					// subject
					String subject = mailInfo.get("SUBJECT");
					subject = (subject != null) ? subject : "";
					subject = commonUtil.cleanValue(subject);

					// secureMail
					sb.append(String.format("<securemail>%s</securemail>", mailInfo.get("MAIL_IS_SECURED")));

					if (viewSelectIndex.equals("1")) {
						String htmlBody = mailInfo.get("CONTENT");

						Pattern p = Pattern.compile("\\s*<(head|title|style)(.*?)<\\/(head|title|style)>\\s*", Pattern.CASE_INSENSITIVE | Pattern.DOTALL);
						Matcher m = p.matcher(htmlBody);
						htmlBody = m.replaceAll("");

						p = Pattern.compile("\\s*<.*?>\\s*", Pattern.CASE_INSENSITIVE | Pattern.DOTALL);
						m = p.matcher(htmlBody);
						htmlBody = m.replaceAll("").trim();

						int minLen = Math.min(200, htmlBody.length());
						htmlBody = htmlBody.substring(0, minLen);

						String preview = "<br/><span style='font-weight:normal;font-size:9pt;color:gray'>" + htmlBody + "</span>";
						sb.append(String.format("<subject><![CDATA[%s]]></subject>", (subject + preview).replace("]]>", "]]]]><![CDATA[>")));
					}
					else {
						sb.append(String.format("<subject><![CDATA[%s]]></subject>", subject.replace("]]>", "]]]]><![CDATA[>")));
					}

					// received date
					SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
					Date receivedDate = sdf.parse(mailInfo.get("MAIL_DATE"));
					sdf.setTimeZone(TimeZone.getTimeZone("GMT"));
					String receivedDateStr = sdf.format(receivedDate);

					receivedDateStr = commonUtil.getDateStringInUTC(receivedDateStr, userInfo.getOffset(), false);

					sb.append(String.format("<receivedt><![CDATA[%s]]></receivedt>", receivedDateStr));

					if ("1".equals(mailInfo.get("MAIL_IS_ANSWERED"))) {
						sb.append("<contentclass><![CDATA[REPLY]]></contentclass>");
					}
					else {
						if ("1".equals(mailInfo.get("MAIL_IS_FORWARDED"))) {
							sb.append("<contentclass><![CDATA[FORWARD]]></contentclass>");
						}
						else {
							sb.append("<contentclass><![CDATA[IPM.Note]]></contentclass>");
						}
					}

					sb.append(String.format("<tags><![CDATA[%s]]></tags>", mailInfo.get("TAGS")));

					sb.append("</response>");
				}

				sb.append(String.format("<CONTENTRANGE><![CDATA[rows;%s;%s;total;%d;BoxTCount;%d;BoxUCount;%d;]]></CONTENTRANGE>",
						start, end, totalCount, mailboxMailCount, mailboxUnreadMailCount));
				sb.append("</maillist>");
			} else {
				ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
						userEmail, password, egovMessageSource, locale, 40 * 1000, 20 * 1000, ezEmailUtil);

				if (ia == null){
					throw new Exception("Ia is null");
				}
				Folder folder = ia.getFolder(folderId != null ? folderId : "");
				if (folder == null){
					throw new Exception("folder is null");
				}
				folder.open(Folder.READ_ONLY);

				messages = ezEmailUtil.searchFolder(ia, userEmail, folder, categoryArray, keywordArray, startDateObj, endDateObj, false,
						isUnreadOnly, isImportantOnly, sortTypeSpecifier, isAscending, startNo, listCount, false, extraMap, userInfo.getTenantId(), "");

				totalCount = (int) extraMap.get("totalCount");
				logger.debug("totalCount=" + totalCount);

				for (Message message : messages) {
					UIDFolder uidFolder = (UIDFolder) message.getFolder();

					sb.append("<response>");
					sb.append(String.format("<href><![CDATA[%s/%s]]></href>", folderId, uidFolder.getUID(message)));

					// importance
					String[] headers = message.getHeader("X-Priority");
//				String header = headers != null ? headers[0] : "normal";
					String header = "";

					if (headers == null) {
						//importance      = "low" / "normal" / "high"
						String[] headerImportance = message.getHeader("Importance");

						if (headerImportance == null) {
							header = "normal";
						} else {
							header = headerImportance[0];
						}
					} else {
						header = headers[0];
					}

					int importance = 1;
					// startsWith is used since
					// there are cases like X-Priority: 1 (Highest) generated by Thunderbird.
					if (header.startsWith("1") || header.startsWith("high")) {
						importance = 2;
					} else if (header.startsWith("5") || header.startsWith("low")) {
						importance = 0;
					}
					sb.append(String.format("<importance><![CDATA[%d]]></importance>", importance));

					String msgto = "";
					Address[] addresses = null;

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

					String messageId = ((MimeMessage) message).getMessageID() == null ? "" : ((MimeMessage) message).getMessageID();

					//get readList(수신확인)
					List<MailReadVO> readList = ezEmailService.getMailReadList(userInfo.getTenantId(), userInfo.getId(), messageId);

					//get all recipients from email message(메일)
					Address[] addresses1 = message.getAllRecipients();

					//get aliasAddressList from recipients
					List<String> addressList = new ArrayList<String>();

					if (addresses1 != null) {
						for (Address address : addresses1) {
							if (((InternetAddress) address).getAddress() != null) {
								addressList.add(((InternetAddress) address).getAddress());
							}
						}
					}

					Map<String, String> aliasAddressList = ezEmailService.getAliasAddressMap(addressList, userInfo.getTenantId());

					List<String> tempMailList = new ArrayList<String>();

					readDate = "UNREAD";
					readCount = 0;

					if (addresses1 != null) {
						for (Address address : addresses1) {
							String email = ((InternetAddress) address).getAddress();

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
						((IMAPMessage) message).setPeek(true);
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
					} else {
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
					} else {
						boolean isForwarded = ezEmailUtil.hasForwardedFlag(message);

						if (isForwarded) {
							sb.append("<contentclass><![CDATA[FORWARD]]></contentclass>");
						} else {
							sb.append("<contentclass><![CDATA[IPM.Note]]></contentclass>");
						}
					}

					sb.append("</response>");
				}

				// Folder.getUnreadMessageCount() 메소드 동작 방식이 folder가 open 상태일 때는 읽지 않은 메일 갯수를 IMAP search 명령을
				// 통해 비효율적으로 구하는 관계로 여기서 folder를 close 하도록 수정함. open 상태가 아닐 때는 IMAP status 명령을 사용하며 status 명령이
				// 더 효율적임.
				folder.close(false);

				sb.append(String.format("<CONTENTRANGE><![CDATA[rows;%s;%s;total;%d;BoxTCount;%d;BoxUCount;%d;]]></CONTENTRANGE>",
						start, end, totalCount, folder.getMessageCount(), folder.getUnreadMessageCount()));
				sb.append("</maillist>");
			}
			
			// skyblue0o0 20180402 : 특정 유니코드 문자 포함 시 xml파싱 에러나서 빈칸으로 치환
			returnData = sb.toString().replaceAll("[\\u0000-\\u0008\\u000B-\\u000C\\u000E-\\u001F]", " ");
			
		} catch (IndexOutOfBoundsException e) {
			logger.error(e.getMessage(), e);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
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
	@RequestMapping(value="/ezEmail/mailGetList.do", method=RequestMethod.POST, produces="text/xml; charset=utf-8")
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
		boolean isAllMail = "allMail".equalsIgnoreCase(folderId); // 전체메일인 경우 하위폴더까지 검색
		folderId = isAllMail ? "INBOX////Personal folder" : folderId; // 전체메일은 받은편지함과 그 하위, 개인편지함과 그 하위의 모든 메일함에서 메일을 가져온다.
		String sortType = doc.getElementsByTagName("SORTTYPE").item(0).getTextContent();
		String start = doc.getElementsByTagName("START").item(0).getTextContent();
		String end = doc.getElementsByTagName("END").item(0).getTextContent();
		String search = doc.getElementsByTagName("SEARCH").item(0).getTextContent();
		String viewSelectIndex = doc.getElementsByTagName("VIEWSELECTINDEX").item(0).getTextContent();
		// 2020-08-20 (사조그룹) 보안메일 필터링
		String useSecureMailFilter = doc.getElementsByTagName("SECUREMAILFILTER").item(0).getTextContent();
		String useCountryIP = ezCommonService.getTenantConfig("useCountryIP", userInfo.getTenantId());
		String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", userInfo.getTenantId());
		String systemCountryCode = ezCommonService.getTenantConfig("systemCountryCode", userInfo.getTenantId());
		String useRDBOnlyMailList = ezCommonService.getTenantConfig("useRDBOnlyMailList", userInfo.getTenantId());
		String startDate = doc.getElementsByTagName("STARTDATE").item(0).getTextContent();
		String useAttachFileFilter = doc.getElementsByTagName("ATTACHFILEFILTER").item(0).getTextContent();
		
		if (startDate == null) {
			return "";
		}
		
		String endDate = doc.getElementsByTagName("ENDDATE").item(0).getTextContent();
		
		if (endDate == null) {
			return "";
		}
		
		String andorStatus = doc.getElementsByTagName("ANDORSTATUS").item(0).getTextContent();
		String attachStatus = doc.getElementsByTagName("ATTACHSTATUS").item(0).getTextContent();
		String tagName = Optional.ofNullable(doc.getElementsByTagName("TAGNAME").item(0)).map(Node::getTextContent).orElse("");
		boolean isRequireMailboxPath = !tagName.isEmpty();
		
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
		
		SimpleDateFormat sdfForParsing = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		sdfForParsing.setTimeZone(TimeZone.getTimeZone("GMT"));
		
		Date startDateObj = startDate.equals("") ? null : sdfForParsing.parse(startDate);
		Date endDateObj = endDate.equals("") ? null : new Date(sdfForParsing.parse(endDate).getTime() + 60*60*24*1000);

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
		
		logger.debug("userId={},userEmail={},tenantId={},serverName={},folderId={},sortType={},start={},end={},search={},viewSelectIndex={},useCountryIP={},useSecureMailFilter={},useAttachFileFilter={}"
					,userInfo.getId(),userEmail,userInfo.getTenantId(),userInfo.getServerName(),folderId,sortType,start,end,search,viewSelectIndex,useCountryIP,useSecureMailFilter,useAttachFileFilter);
		
		String returnData = "";
				
		IMAPAccess ia = null;
		
		try {
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

			if (sortType.indexOf("IMPORTANT") >= 0) {
				isImportantOnly = true;
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
			extraMap.put("andorStatus", andorStatus);
			extraMap.put("attachStatus", attachStatus);
			extraMap.put("useSecureMailFilter", useSecureMailFilter.equals("1"));
			extraMap.put("useAttachFileFilter",useAttachFileFilter.equals("1"));

			//2020-07-16 김은실 - (사조그룹)내부·외부필터 내부기준 도메인
			if (sortType.indexOf("INTERNAL") >= 0 || sortType.indexOf("EXTERNAL") >= 0) {
				String inexternalFilter = sortType.indexOf("INTERNAL") >= 0? "internal" : "external";
				String mailInnerDomainStr = ezCommonService.getTenantConfig("MailInnerDomain", userInfo.getTenantId());

				extraMap.put("inexternalFilter", inexternalFilter);
				extraMap.put("mailInnerDomainStr", mailInnerDomainStr.isEmpty()? domainName : mailInnerDomainStr);

				logger.debug("inexternalFilter=" + inexternalFilter + ", mailInnerDomainStr=" + mailInnerDomainStr);
			}

			if (useRDBOnlyMailList.equals("YES")) {
				int mailboxMailCount = 0;
				int mailboxUnreadMailCount = 0;				
				boolean includeContent = false;
				
				if (viewSelectIndex.equals("1")) {
					includeContent = true;
				}
				
				List<Map<String, String>> mailList = ezEmailUtil.searchFolderUsingRDBOnly(userEmail, folderId, categoryArray, keywordArray, startDateObj, endDateObj, isAllMail, 
						isUnreadOnly, isImportantOnly, sortTypeSpecifier, isAscending, startNo, listCount, false, extraMap, userInfo.getTenantId(), includeContent, tagName);
				
				totalCount = (int)extraMap.get("totalCount");
				mailboxMailCount = (int)extraMap.get("mailboxMailCount");
				mailboxUnreadMailCount = (int)extraMap.get("mailboxUnreadMailCount");
				
				logger.debug("totalCount=" + totalCount + ",mailboxMailCount=" + mailboxMailCount + ",mailboxUnreadMailCount=" + mailboxUnreadMailCount);
			
				for (Map<String, String> mailInfo : mailList) {
					sb.append("<response>");
					sb.append(String.format("<href><![CDATA[%s]]></href>", mailInfo.get("MAIL_ID")));
						
					sb.append(String.format("<importance><![CDATA[%s]]></importance>", mailInfo.get("IMPORTANCE")));	
					
					// Flagged is used for bookmark
					sb.append(String.format("<flag><![CDATA[%s]]></flag>", mailInfo.get("MAIL_IS_FLAGGED")));
					
					// attachment
					sb.append(String.format("<attach><![CDATA[%s]]></attach>", mailInfo.get("HAS_ATTACH")));

					// mailbox path
					if (isRequireMailboxPath) {
						String folderPath = mailInfo.get("MAIL_ID").split("/")[0];
						String folderPathName = ezEmailUtil.getDisplayNameFromFolderId(folderPath, locale).replaceAll("\\.", "/");
						sb.append("<parentName><![CDATA[").append(folderPathName).append("]]></parentName>");
					}
					
					if (isAllMail) {
						String folderPath = mailInfo.get("MAIL_ID").split("/")[0];
						String folderPathNames = ezEmailUtil.getDisplayNameFromFolderId(folderPath, locale).replaceAll("\\.", "/");
						String[] folderPathNameArray = folderPathNames.split("/");
						String folderPathName = folderPathNameArray[folderPathNameArray.length - 1];
						sb.append("<mailBoxName><![CDATA[").append(folderPathName).append("]]></mailBoxName>");
					} else {
						sb.append("<mailBoxName><![CDATA[").append("").append("]]></mailBoxName>");
					}

					String msgto = "";
					Address[] addresses = null;
	
					String name = "";
					
					if (!viewSelectIndex.equals("3")) {
						name = ezEmailUtil.getNameOrAddress(mailInfo.get("SENDER"));
						String senderEmail = ezEmailUtil.getAddress(mailInfo.get("SENDER"));
												
						msgto = String.format("%s <%s>", name, senderEmail);
					}
					// in case of Sent mailbox
					else {
						// To, Cc, Bcc를 모두 포함한다.
						String recipientsStr = mailInfo.get("RECIPIENT");
						
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
									
									msgtoBuilder.append(toStr);
									msgtoBuilder.append(",");
									
									name += toName;
									name += "; ";									
								}
								
								msgto = msgtoBuilder.toString();
								msgto = msgto.substring(0, msgto.length() - 1);
								name = name.substring(0, name.length() - 2);								
							}
						}
					}
					
					// 2018-10-05 메일리스트에 보낸사람 국기표시 박예연
					if (useCountryIP.equals("YES")) {
						String countryCode = "";
						String countryName = "";
						
						try {
							String ctryCode = mailInfo.get("COUNTRY_CODE");
							String mailIp = mailInfo.get("MAIL_IP");
							String systemLang = userInfo.getLang();
							
							if (mailIp != null && !mailIp.equals("")) {
								sb.append(String.format("<mailIP><![CDATA[%s]]></mailIP>", mailIp));
							}
							
							if (ctryCode != null && !ctryCode.equals("")) {
								String systemCountryName = commonUtil.getTwoLetterLangFromLangNum(systemLang, "kr");
								Locale localeCountry = new Locale(systemCountryName, ctryCode);
								countryName = localeCountry.getDisplayCountry(localeCountry);
								countryName = countryName.replaceAll(" ", "");
								countryCode = ctryCode.toLowerCase();
							}
							
							sb.append(String.format("<countryName><![CDATA[%s]]></countryName>", countryName));
							sb.append(String.format("<countryCode><![CDATA[%s]]></countryCode>", countryCode));							
						} catch (NullPointerException e) {
							logger.error(e.getMessage(), e);
						} catch (Exception e) {
							logger.error(e.getMessage(), e);
						}
					}
					
					sb.append(String.format("<systemCountryCode><![CDATA[%s]]></systemCountryCode>", systemCountryCode.toLowerCase()));
					sb.append(String.format("<useCountryIP><![CDATA[%s]]></useCountryIP>", useCountryIP));
					sb.append(String.format("<sender><![CDATA[%s]]></sender>", name));
					sb.append(String.format("<msgto><![CDATA[%s]]></msgto>", msgto.replace("]]>", "]]]]><![CDATA[>")));
	
					// subject
					String subject =  mailInfo.get("SUBJECT");								
					subject = (subject != null) ? subject : "";
					subject = commonUtil.cleanValue(subject);
					
					// secureMail
					sb.append(String.format("<securemail>%s</securemail>", mailInfo.get("MAIL_IS_SECURED")));
					
					if (viewSelectIndex.equals("1")) {
						String htmlBody = mailInfo.get("CONTENT");
						
						Pattern p = Pattern.compile("\\s*<(head|title|style)(.*?)<\\/(head|title|style)>\\s*", Pattern.CASE_INSENSITIVE | Pattern.DOTALL);
						Matcher m = p.matcher(htmlBody);
						htmlBody = m.replaceAll("");
						
						p = Pattern.compile("\\s*<.*?>\\s*", Pattern.CASE_INSENSITIVE | Pattern.DOTALL);
						m = p.matcher(htmlBody);
						htmlBody = m.replaceAll("").trim();
		
						int minLen = Math.min(200, htmlBody.length());
						htmlBody = htmlBody.substring(0, minLen);
						
						String preview = "<br/><span style='font-weight:normal;font-size:9pt;color:gray'>" + htmlBody + "</span>";
						sb.append(String.format("<subject><![CDATA[%s]]></subject>", (subject + preview).replace("]]>", "]]]]><![CDATA[>")));
					}
					else {
						sb.append(String.format("<subject><![CDATA[%s]]></subject>", subject.replace("]]>", "]]]]><![CDATA[>")));
					}
					
					// received date
					SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
					Date receivedDate = sdf.parse(mailInfo.get("MAIL_DATE"));
					sdf.setTimeZone(TimeZone.getTimeZone("GMT"));
					String receivedDateStr = sdf.format(receivedDate);
					
					receivedDateStr = commonUtil.getDateStringInUTC(receivedDateStr, userInfo.getOffset(), false);
					
					sb.append(String.format("<receivedt><![CDATA[%s]]></receivedt>", receivedDateStr));
					
					// size
					sb.append(String.format("<size><![CDATA[%s]]></size>", mailInfo.get("MAIL_SIZE")));
					
					// read/unread
					sb.append(String.format("<read><![CDATA[%s]]></read>", mailInfo.get("MAIL_IS_SEEN")));
								
					if ("1".equals(mailInfo.get("MAIL_IS_ANSWERED"))) {
						sb.append("<contentclass><![CDATA[REPLY]]></contentclass>");
					}
					else {
						if ("1".equals(mailInfo.get("MAIL_IS_FORWARDED"))) {
							sb.append("<contentclass><![CDATA[FORWARD]]></contentclass>");
						}
						else {
							sb.append("<contentclass><![CDATA[IPM.Note]]></contentclass>");
						}
					}
					
					sb.append(String.format("<mailConfirm><![CDATA[%s]]></mailConfirm>", mailInfo.get("MAIL_IS_CONFIRMED").equals("1") ? true : false));
					sb.append(String.format("<tags><![CDATA[%s]]></tags>", mailInfo.get("TAGS")));

					sb.append("</response>");
				}
				
				sb.append(String.format("<CONTENTRANGE><![CDATA[rows;%s;%s;total;%d;BoxTCount;%d;BoxUCount;%d;]]></CONTENTRANGE>", 
						start, end, totalCount, mailboxMailCount, mailboxUnreadMailCount));
				sb.append("</maillist>");				
			} else {							
				ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
						userEmail, password, egovMessageSource, locale, 40*1000, 20*1000, ezEmailUtil);

				if (ia == null){
					throw new Exception("Ia is null");
				}
				Folder folder = ia.getFolder(folderId != null ? folderId : "");
				if (folder == null){
					throw new Exception("folder is null");
				}
				folder.open(Folder.READ_ONLY);
								
				messages = ezEmailUtil.searchFolder(ia, userEmail, folder, categoryArray, keywordArray, startDateObj, endDateObj, false, 
						isUnreadOnly, isImportantOnly, sortTypeSpecifier, isAscending, startNo, listCount, false, extraMap, userInfo.getTenantId(), tagName);
				
				totalCount = (int)extraMap.get("totalCount");
				logger.debug("totalCount=" + totalCount);
			
				for (Message message : messages) {
					UIDFolder uidFolder = (UIDFolder)message.getFolder();
					
					sb.append("<response>");
					sb.append(String.format("<href><![CDATA[%s/%s]]></href>", folderId, uidFolder.getUID(message)));
						
					// importance
					String[] headers = message.getHeader("X-Priority");
					String header = "";
					
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
					
					int importance = 1;
					// startsWith is used since
					// there are cases like X-Priority: 1 (Highest) generated by Thunderbird.
					if (header.startsWith("1") || header.startsWith("high")) {
						importance = 2;
					} else if (header.startsWith("5") || header.startsWith("low")) {
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
	
					String name = "";
					
					if (!viewSelectIndex.equals("3")) {
						name = ezEmailUtil.getFromNameOrAddressOfMessage(message);
						String senderEmail = ezEmailUtil.getFromEmailAddressOfMessage(message);
						
						if (name.equals(senderEmail)) {
							List<String> mailAddrList = ezEmailUtil.mailAddrNameParse(name, senderEmail);
							name = mailAddrList.get(0);
							senderEmail = mailAddrList.get(1);
						}
						
						msgto = String.format("%s <%s>", name, senderEmail);
					}
					// in case of Sent mailbox
					else {
						addresses = message.getRecipients(Message.RecipientType.TO);
						
						if (addresses != null) {
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
						String countryCode = "";
						String countryName = "";
						try {
							String[] ctryCode = message.getHeader("X-Jmocha-Country-Code");
							String[] mailIp = message.getHeader("X-Jmocha-IP");
							String systemLang = userInfo.getLang();
							
							if (mailIp != null && !mailIp[0].equals("")) {
								sb.append(String.format("<mailIP><![CDATA[%s]]></mailIP>", mailIp[0]));
							}
							
							if (ctryCode != null && ctryCode[0] != null) {
								String systemCountryName = commonUtil.getTwoLetterLangFromLangNum(systemLang, "kr");
								Locale localeCountry = new Locale(systemCountryName, ctryCode[0]);
								countryName = localeCountry.getDisplayCountry(localeCountry);
								countryName = countryName.replaceAll(" ", "");
								countryCode = ctryCode[0].toLowerCase();
							}
							sb.append(String.format("<countryName><![CDATA[%s]]></countryName>", countryName));
							sb.append(String.format("<countryCode><![CDATA[%s]]></countryCode>", countryCode));
							
						} catch (MessagingException e) {
							logger.error(e.getMessage(), e);
						} catch (Exception e) {
							logger.error(e.getMessage(), e);
						}
					}
					sb.append(String.format("<systemCountryCode><![CDATA[%s]]></systemCountryCode>", systemCountryCode.toLowerCase()));
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
					
					sb.append(String.format("<mailConfirm><![CDATA[%s]]></mailConfirm>", ezEmailUtil.hasMailConfirmFlag(message)));
					
					sb.append("</response>");
				}
				
				// Folder.getUnreadMessageCount() 메소드 동작 방식이 folder가 open 상태일 때는 읽지 않은 메일 갯수를 IMAP search 명령을
				// 통해 비효율적으로 구하는 관계로 여기서 folder를 close 하도록 수정함. open 상태가 아닐 때는 IMAP status 명령을 사용하며 status 명령이
				// 더 효율적임.
				folder.close(false);
				
				sb.append(String.format("<CONTENTRANGE><![CDATA[rows;%s;%s;total;%d;BoxTCount;%d;BoxUCount;%d;]]></CONTENTRANGE>", 
						start, end, totalCount, folder.getMessageCount(), folder.getUnreadMessageCount()));
				sb.append("</maillist>");
			}
		    
			// skyblue0o0 20180402 : 특정 유니코드 문자 포함 시 xml파싱 에러나서 빈칸으로 치환
			returnData = sb.toString().replaceAll("[\\u0000-\\u0008\\u000B-\\u000C\\u000E-\\u001F]", " ");
			
		} catch (IndexOutOfBoundsException e) {
			logger.error(e.getMessage(), e);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
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
	@RequestMapping(value="/ezEmail/mailDelete.do", method=RequestMethod.POST)
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
		
		Map<String, long[]> folderIdUids = new HashMap<>();
		String folderId = "";
		//long[] uids = null;
		
		
		if (cmd.equalsIgnoreCase("ALL")) {
			folderId = uniqueId;
		} else {
			// 2025-02-19 - 다중 편지함 지원을 위해 getFolderIdUid 함수 이용
			String[] folderAndMsgIdArray = ezEmailUtil.makeFolderAndMsgIdArray(uniqueId);
			folderIdUids = ezEmailUtil.getFolderIdUid(folderAndMsgIdArray);
			
			/*int delimiterIndex = folderAndMsgIdArray[0].lastIndexOf("/");
			folderId = folderAndMsgIdArray[0].substring(0, delimiterIndex);			
			uids = new long[folderAndMsgIdArray.length];
			
			for (int i = 0; i < folderAndMsgIdArray.length; i++) {
				String folderAndMsgId = folderAndMsgIdArray[i];
				delimiterIndex = folderAndMsgId.lastIndexOf("/");
				String msgId = folderAndMsgId.substring(delimiterIndex + 1);
				uids[i] = Long.parseLong(msgId);
			}*/
		}
		
		//logger.debug("folderId=" + folderId);
		
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
	        
	        logger.debug("mailDelete userId=" + userInfo.getId() + ",userEmail=" + userEmail);
	        
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userEmail, password, egovMessageSource, locale, ezEmailUtil);
			
			if (cmd.equalsIgnoreCase("ALL")) {
				ezEmailService.actionTrashMailAllDelete(ia, folderId);
			} else {
				ezEmailService.actionMailMoveTrash(ia, folderIdUids, cmd, locale, userInfo.getTenantId(), userEmail, domainName);
			}
			
		} catch (Exception e) {
			returnData = "ERROR : " + e.getMessage();
			logger.error(e.getMessage(), e);
		} finally {
			if (ia != null) {
				ia.close();		
			}
			
		}
		
		logger.debug("returnData=" + returnData);
		logger.debug("mailDelete ended.");
		
		return returnData;				
	}

	/**
	 * 안읽은 메일 삭제 실행 함수
	 */
	@RequestMapping(value="/ezEmail/unreadMailDel.do", method = RequestMethod.POST)
	@ResponseBody
	public String unreadMailDel(@CookieValue("loginCookie") String loginCookie,
								@RequestParam String url,
								@RequestParam String cmd,
								@RequestParam String shareId,
								Locale locale,
								Model model) throws Exception{
		logger.debug("unreadMailDel started.");

		String returnValue = "error";

		List<String> userIdnPw = commonUtil.getUserIdAndPassword(loginCookie);
		String password  = userIdnPw.get(1);

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
		String userAccount = userInfo.getId() + "@" + domainName;
		String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", userInfo.getTenantId());

		if (useSharedMailbox.equals("YES")) {
			logger.debug("shareId=" + shareId);

			if (StringUtils.isNotBlank(shareId)) {
				int permissionType = 4;

				// 편지함 영구삭제 시 삭제 권한 및 관리 권한(5) 확인
				// 모든 메일 삭제(지운편지함으로 이동), 모든 메일 영구 삭제 시 삭제 권한(1) 확인
				// 그 외에는 관리 권한(4) 확인
				if (cmd.equals("DEL")) {
					permissionType = 5;
				} else if (cmd.equals("MAILREALDEL") || cmd.equals("MAILDEL")) {
					permissionType = 1;
				}

				if (!ezEmailService.checkUserShareId(userInfo.getId(), shareId, permissionType, userInfo.getTenantId())) {
					logger.debug("the user cannot access the shareId.");
					logger.debug("unreadMailDel ended.");

					return "";
				}

				userAccount = shareId + "@" + domainName;
			}
		}

		logger.debug("userId=" + userInfo.getId() + ",userAccount=" + userAccount);

		IMAPAccess ia = null;
		boolean isNewUserQuotaNeeded = false;
		boolean isThereUserLevelQuota = false;
		Double userQuota = 0.0;
		Double userWarn = 0.0;

		try {
			switch (cmd) {
				case "MAILREALDEL": //지운편지함에 있는 안 읽은 메시지 영구삭제
					ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
							userAccount, password, egovMessageSource, locale, ezEmailUtil);

					if (!url.equals("")) {
						Folder folder = ia.getFolder(url);
						if (folder.exists()) {
							folder.open(Folder.READ_WRITE);
							Message[] unreadMessages = folder.search(new FlagTerm(new Flags(Flags.Flag.SEEN), false));
							folder.setFlags(unreadMessages, new Flags(Flags.Flag.DELETED), true);
							folder.close(true);
							logger.debug(url + " folder is cleaned of unread messages.");
							returnValue = "ok";
						}
					}
					
					break;
					
				case "MAILDEL":
					// 특정폴더의 안 읽은 메시지 삭제(지운편지함으로 이동)
					// 편지함 삭제 및 복사시 timeout 오류 발생으로 시간 수정
					ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
							userAccount, password, egovMessageSource, locale, 600000, 20000, ezEmailUtil);

					if (!url.equals("")) {
						String trashFolderName = ezEmailUtil.getTrashFolderId(locale);
						Folder trashFolder = ia.getFolder(trashFolderName);
						IMAPFolder folder = (IMAPFolder)ia.getFolder(url);

						if (folder.exists() && trashFolder.exists()) {
							folder.open(Folder.READ_WRITE);
							Message[] unreadMessages = folder.search(new FlagTerm(new Flags(Flags.Flag.SEEN), false));
							logger.debug("messageCount:" + unreadMessages.length );
							if (unreadMessages.length == 0){
								returnValue = "ok"; // 안 읽은 메일이 없는 경우에는 성공으로 처리 한다.
								break;
							}

							String useImapMoveCommand = ezCommonService.getTenantConfig("useImapMoveCommand", userInfo.getTenantId());

							if (useImapMoveCommand.equals("YES")) {
								folder.moveMessages(unreadMessages, trashFolder);
							} else {
								// 지운 편지함으로 보낼 메시지의 크기가 Quota량을 초과하게 되면 Quota를 재조정한다.
								Double[] adjustQuotaData = ezEmailUtil.adjustUserQuotaForMessageMove(unreadMessages, userAccount, domainName, ia);

								if (adjustQuotaData[0] != null) {
									isNewUserQuotaNeeded = true;

									userQuota = adjustQuotaData[0];
									userWarn = adjustQuotaData[1];
								}

								if (adjustQuotaData[2] != null) {
									isThereUserLevelQuota = true;
								}

								folder.copyMessages(unreadMessages, trashFolder);
								folder.setFlags(unreadMessages, new Flags(Flags.Flag.DELETED), true);
							}

							folder.close(true);
							logger.debug(url + " folder's unread message is moved to " + trashFolderName + ".");
							returnValue = "ok";
						}
					}

					break;
			}
		} catch (MessagingException e) {
			returnValue = "error : " + e.getMessage();
			logger.error(e.getMessage(), e);
		} finally {
			if (ia != null) {
				ia.close();
			}

			// 사용자 Quota를 변경시켰다면 원래 값으로 복원시킨다.			
			if (isNewUserQuotaNeeded) {
				if (isThereUserLevelQuota) {
					ezEmailUtil.setUserQuota(userAccount, String.valueOf(userQuota), String.valueOf(userWarn));
					// 사용자 레벨 Quota 설정 값이 없었던 경우에는 해당 설정값을 삭제한다.
				} else {
					ezEmailUtil.deleteUserQuota(userAccount);
				}
			}
		}

		logger.debug("unreadMailDel ended. returnValue={}", returnValue);

		return returnValue;
	}

	/**
	 * 안읽은 검색 메일 삭제 실행 함수
	 */
	@RequestMapping(value = "/ezEmail/searchedAndUnreadMailDel.do", method = RequestMethod.POST)
	@ResponseBody
	public String searchedAndUnreadMailDel(@CookieValue("loginCookie") String loginCookie,
										   @RequestBody JSONObject requestObject,
										   Locale locale,
										   Model model
										   ) throws Exception {
		logger.debug("searchedAndUnreadMailDel started.");
		logger.debug("requestObject={}", requestObject);

		String returnValue = "";

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
		String userEmail = userInfo.getId() + "@" + domainName;

		String folderId = (String) requestObject.get("FOLDERID");
		String inboxName = egovMessageSource.getMessage("ezEmail.t644", locale);
		folderId = folderId.equals(inboxName) ? "INBOX" : folderId;
		String sortType = StringUtils.defaultIfBlank((String) requestObject.get("SORTTYPE"), "");
		String start = StringUtils.defaultIfBlank((String) requestObject.get("START"), "0");
		String end = StringUtils.defaultIfBlank((String) requestObject.get("END"), "0");
		String search = StringUtils.defaultIfBlank((String) requestObject.get("SEARCH"), "");
		String viewSelectIndex = StringUtils.defaultIfBlank((String) requestObject.get("VIEWSELECTINDEX"), "");
		String useSecureMailFilter = StringUtils.defaultIfBlank((String) requestObject.get("SECUREMAILFILTER"), "");
		String useCountryIP = ezCommonService.getTenantConfig("useCountryIP", userInfo.getTenantId());
		String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", userInfo.getTenantId());
		String useRDBOnlyMailList = ezCommonService.getTenantConfig("useRDBOnlyMailList", userInfo.getTenantId());
		String startDate = (String) requestObject.get("STARTDATE");
		String endDate = (String) requestObject.get("ENDDATE");
		String andorStatus = (String) requestObject.get("ANDORSTATUS");
		String attachStatus = (String) requestObject.get("ATTACHSTATUS");
		String tagName = StringUtils.defaultIfBlank((String) requestObject.get("TAGNAME"), "");
		String shareId = "";

		// 검색조건 정리 start
		List listCategory = (ArrayList) requestObject.get("CATEGORY");
		List listKeyword = (ArrayList) requestObject.get("KEYWORD");
		String[] categoryArray = new String[listCategory.size()];
		String[] keywordArray = new String[listKeyword.size()];

		for (int i = 0; i < listCategory.size(); i++) {
			categoryArray[i] = (String) listCategory.get(i);
		}

		for (int i = 0; i < listKeyword.size(); i++) {
			keywordArray[i] = (String) listKeyword.get(i);
		}

		if (startDate == null) {
			return "";
		}

		if (endDate == null) {
			return "";
		}

		SimpleDateFormat sdfForParsing = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		sdfForParsing.setTimeZone(TimeZone.getTimeZone("GMT"));

		Date startDateObj = startDate.equals("") ? null : sdfForParsing.parse(startDate);
		Date endDateObj = endDate.equals("") ? null	: new Date(sdfForParsing.parse(endDate).getTime() + 60 * 60 * 24 * 1000);

		if (useSharedMailbox.equals("YES")) {
			shareId = (String) requestObject.get("SHAREDID");
			logger.debug("shareId=" + shareId);

			if (StringUtils.isNotBlank(shareId)) {
				
				if (!ezEmailService.checkUserShareId(userInfo.getId(), shareId, userInfo.getTenantId())) {
					logger.debug("searchedAndUnreadMailDel ended. the user - {} cannot access the shareId" , userEmail);
					return "error";
				}

				userEmail = shareId + "@" + domainName;
			}
		}

		logger.debug("userId=" + userInfo.getId() + ",userEmail=" + userEmail + ",tenantId=" + userInfo.getTenantId()
				+ ",serverName=" + userInfo.getServerName() + ",folderId=" + folderId + ",sortType=" + sortType
				+ ",start=" + start + ",end=" + end + ",search=" + search + ",viewSelectIndex=" + viewSelectIndex
				+ ",useCountryIP=" + useCountryIP + ",useSecureMailFilter=" + useSecureMailFilter);

		boolean isUnreadOnly = true; // 무조건 true로 보냄
		boolean isImportantOnly = false;

		if (sortType.indexOf("IMPORTANT") >= 0) {
			isImportantOnly = true;
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

		int startNo = Integer.parseInt(start);
		int endNo = Integer.parseInt(end);

		Map<String, Object> extraMap = new HashMap<String, Object>();
		extraMap.put("andorStatus", andorStatus);
		extraMap.put("attachStatus", attachStatus);
		extraMap.put("useSecureMailFilter", useSecureMailFilter.equals("1"));

		// 2020-07-16 김은실 - (사조그룹)내부·외부필터 내부기준 도메인
		if (sortType.indexOf("INTERNAL") >= 0 || sortType.indexOf("EXTERNAL") >= 0) {
			String inexternalFilter = sortType.indexOf("INTERNAL") >= 0 ? "internal" : "external";
			String mailInnerDomainStr = ezCommonService.getTenantConfig("MailInnerDomain", userInfo.getTenantId());

			extraMap.put("inexternalFilter", inexternalFilter);
			extraMap.put("mailInnerDomainStr", mailInnerDomainStr.isEmpty() ? domainName : mailInnerDomainStr);

			logger.debug("inexternalFilter=" + inexternalFilter + ", mailInnerDomainStr=" + mailInnerDomainStr);
		}

		boolean includeContent = false;

		if (viewSelectIndex.equals("1")) {
			includeContent = true;
		}
		// 검색조건 정리 end		
		
		List<String> userIdnPw = commonUtil.getUserIdAndPassword(loginCookie);
		String password  = userIdnPw.get(1);

		IMAPAccess ia = null;
		boolean isNewUserQuotaNeeded = false;
		boolean isThereUserLevelQuota = false;
		Double userQuota = 0.0;
		Double userWarn = 0.0;

		try {
			if (!useRDBOnlyMailList.equals("YES")) {
				logger.debug("searchedAndUnreadMailDel ended. no rdb use error");
				return "error";
			}

			// 1. 메일 검색 mailList를 가져 옴
			List<Map<String, String>> mailList = ezEmailUtil.searchFolderUsingRDBOnly(userEmail, folderId, categoryArray, keywordArray, 
					startDateObj, endDateObj, false, isUnreadOnly, isImportantOnly, sortTypeSpecifier, isAscending, 
					startNo, endNo, false, extraMap, userInfo.getTenantId(),	includeContent, tagName);
			
			if (mailList.size() == 0) {
				logger.debug("searchedAndUnreadMailDel ended. ok - no unread mails.");
				return "ok"; //안 읽은 메일이 없는 경우에는 성공으로 처리 한다.
			}

			// todo 2024-08-12 - 현 시점의 스펙은 각 메일함에서 안읽은 메일을 삭제하도록 되어있으나, 이후 메일검색에서도 활용할 수 있도록 메일함별로 map을 나눠 for문을 돌면서 삭제하도록 로직 작성
			// 2. 메일함 : 메일id 로 데이터 정리
			// 2-1. mailList를 {메일함 : 메일id,id,id} 형태로 만들어 mailMap에 담음
			Map<String, String> mailMap = new HashMap<>();
			
			for (Map<String, String> mail : mailList) {
				String mailIdInfo = mail.get("MAIL_ID");
				String mailbox = mailIdInfo.substring(0, mailIdInfo.lastIndexOf("/"));
				String mailId = mailIdInfo.substring(mailIdInfo.lastIndexOf("/") + 1);

				if (StringUtils.isBlank(mailMap.get(mailbox))) {
					mailMap.put(mailbox, mailId);
				} else {
					String mailIds = mailMap.get(mailbox);
					mailIds += ("," + mailId);
					mailMap.put(mailbox, mailIds);
				}
			}
			
			// 2-2. mailMap를 {메일함 : [메일id,id,id]} 형태로 만들어 urlMap에 담음
			Map<String, long[]> urlMap = new HashMap<>();
			
			for (Map.Entry<String, String> elem : mailMap.entrySet()) {
				String[] mailIds = elem.getValue().split(",");
				long[] longMailIds = new long[mailIds.length];
				
				for (int i = 0; i < mailIds.length; i++) {
					longMailIds[i] = Long.parseLong(mailIds[i]);
				}

				urlMap.put(elem.getKey(), longMailIds);
			}

			// 3. imap 삭제 로직 start
			String trashFolderName = ezEmailUtil.getTrashFolderId(locale);
			
			// 메일함(folder)을 하나씩 돌면서 메일을 삭제한다.
			for (String url : urlMap.keySet()) {
				if (!trashFolderName.equalsIgnoreCase(url)) { // 지운편지함으로 이동

					ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
							userEmail, password, egovMessageSource, locale, 600000, 20000, ezEmailUtil);
	
					Folder trashFolder = ia.getFolder(trashFolderName);
					IMAPFolder folder = (IMAPFolder)ia.getFolder(url);
				
					if (folder.exists() && trashFolder.exists()) {
						folder.open(Folder.READ_WRITE);
						Message[] unreadMessages = folder.getMessagesByUID(urlMap.get(url));
						logger.debug("messageCount:" + unreadMessages.length);
						if (unreadMessages.length > 0) {
							String useImapMoveCommand = ezCommonService.getTenantConfig("useImapMoveCommand", userInfo.getTenantId());

							if (useImapMoveCommand.equals("YES")) {
								folder.moveMessages(unreadMessages, trashFolder);
							} else {
								// 지운 편지함으로 보낼 메시지의 크기가 Quota량을 초과하게 되면 Quota를 재조정한다.
								Double[] adjustQuotaData = ezEmailUtil.adjustUserQuotaForMessageMove(unreadMessages, userEmail, domainName, ia);

								if (adjustQuotaData[0] != null) {
									isNewUserQuotaNeeded = true;

									userQuota = adjustQuotaData[0];
									userWarn = adjustQuotaData[1];
								}

								if (adjustQuotaData[2] != null) {
									isThereUserLevelQuota = true;
								}

								folder.copyMessages(unreadMessages, trashFolder);
								folder.setFlags(unreadMessages, new Flags(Flags.Flag.DELETED), true);
							}

							folder.close(true);

							// 사용자 Quota를 변경시켰다면 원래 값으로 복원시킨다.			
							if (isNewUserQuotaNeeded) {
								if (isThereUserLevelQuota) {
									ezEmailUtil.setUserQuota(userEmail, String.valueOf(userQuota), String.valueOf(userWarn));
									// 사용자 레벨 Quota 설정 값이 없었던 경우에는 해당 설정값을 삭제한다.
								} else {
									ezEmailUtil.deleteUserQuota(userEmail);
								}
							}

							logger.debug("searchedAndUnreadMailDel ended. {} folder's unread message is moved to {}.", url, trashFolderName);
							returnValue = "ok";
						}
					} else {
						folder.close(true);
						
						logger.debug("searchedAndUnreadMailDel ended. mail folder not exist");
						returnValue = "error";
					}
				} else { // 영구삭제
					ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
							userEmail, password, egovMessageSource, locale, ezEmailUtil);

					IMAPFolder folder = (IMAPFolder)ia.getFolder(url);
					
					if (folder.exists()) {
						folder.open(Folder.READ_WRITE);
						Message[] unreadMessages = folder.getMessagesByUID(urlMap.get(url));
						folder.setFlags(unreadMessages, new Flags(Flags.Flag.DELETED), true);
						folder.close(true);
						
						logger.debug("searchedAndUnreadMailDel ended. seached mail deleteed in trash folder.");
						returnValue = "ok";
					} else {
						logger.debug("searchedAndUnreadMailDel ended. trash folder not exist");
						returnValue = "error";
					}
				}
				
				ia = null;
			}
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			returnValue = "error";
		} finally {
			if (ia != null) {
				ia.close();
			}
		}

		logger.debug("searchedAndUnreadMailDel ended.");
		return returnValue;
	}
	
	/**
	 * 메일 이동/복사 실행 함수
	 */
	@RequestMapping(value="/ezEmail/mailMoveCopyMessage.do", method=RequestMethod.POST)
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
			
			Document doc = commonUtil.convertStringToDocument(bodyData != null ? bodyData : "");
			String cmd = doc.getElementsByTagName("CMD").item(0).getTextContent();
			String uniqueId = doc.getElementsByTagName("UNIQUEID").item(0).getTextContent();
			String mfolderId = doc.getElementsByTagName("FOLDERID").item(0).getTextContent();

			// 2025-02-19 - 다중 편지함 지원을 위해 getFolderIdUid 함수 이용
			String[] folderAndMsgIdArray = ezEmailUtil.makeFolderAndMsgIdArray(uniqueId);
			Map<String, long[]> folderIdUids = ezEmailUtil.getFolderIdUid(folderAndMsgIdArray);

			/*String[] folderAndMsgIdArray = ezEmailUtil.makeFolderAndMsgIdArray(uniqueId);
			
			String folderId = folderAndMsgIdArray[0].split("/")[0];			
			long[] uids = new long[folderAndMsgIdArray.length];
			
			for (int i = 0; i < folderAndMsgIdArray.length; i++) {
				String folderAndMsgId = folderAndMsgIdArray[i];
				String msgId = folderAndMsgId.split("/")[1];
				uids[i] = Long.parseLong(msgId);
			}*/
			
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
					
			if (ia != null) {
				// 2025-02-19 - 다중 편지함 지원을 위해 for문, long[] uids 추가
				for (String folderId : folderIdUids.keySet()) {
					long[] uids = folderIdUids.get(folderId);

					IMAPFolder sourceFolder = (IMAPFolder) ia.getFolder(folderId);
					if (sourceFolder == null) {
						throw new Exception("SourceFolder is null");
					}
					sourceFolder.open(Folder.READ_WRITE);

					Message[] messages = sourceFolder.getMessagesByUID(uids);
					IMAPFolder movefolder = (IMAPFolder) ia.getFolder(mfolderId);

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
				}
			}
		} catch (DOMException e) {
			returnValue = "ERROR : " + e.getMessage();
			logger.error(e.getMessage(), e);
		} catch (Exception e) {
			returnValue = "ERROR : " + e.getMessage();
			logger.error(e.getMessage(), e);
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
	@RequestMapping(value="/ezEmail/mailSetFlag.do", method=RequestMethod.POST, produces="text/xml; charset=utf-8")
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

		if (bodyData != null){
			Document doc = commonUtil.convertStringToDocument(bodyData);
			String uniqueId = doc.getElementsByTagName("ITEMID").item(0).getTextContent();

			//String folderId = null;
			//long[] uids = null;

			if (uniqueId.endsWith(";")) {
				uniqueId = uniqueId.substring(0, uniqueId.length() - 1);
			}

			// 2025-02-19 - 다중 편지함 지원을 위해 getFolderIdUid 함수 이용
			String[] folderAndMsgIdArray = uniqueId.split(";");
			Map<String, long[]> folderIdUids = ezEmailUtil.getFolderIdUid(folderAndMsgIdArray);
			
			/*folderId = folderAndMsgIdArray[0].split("/")[0];
			uids = new long[folderAndMsgIdArray.length];

			for (int i = 0; i < folderAndMsgIdArray.length; i++) {
				String folderAndMsgId = folderAndMsgIdArray[folderAndMsgIdArray.length - i - 1];
				String msgId = folderAndMsgId.split("/")[1];
				uids[i] = Long.parseLong(msgId);
			}

			logger.debug("folderId=" + folderId);*/

			IMAPAccess ia = null;

			try {
				ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
						userEmail, password, egovMessageSource, locale, ezEmailUtil);

				if (ia != null) {
					// 2025-02-19 - 다중 편지함 지원을 위해 for문, long[] uids 추가
					for (String folderId : folderIdUids.keySet()) {
						long[] uids = folderIdUids.get(folderId);
						
						IMAPFolder sourceFolder = (IMAPFolder) ia.getFolder(folderId);
						if (sourceFolder == null) {
							throw new Exception("SourceFolder is null");
						}
						sourceFolder.open(Folder.READ_WRITE);

						Message[] msgs = sourceFolder.getMessagesByUID(uids);

						for (int i = 0; i < msgs.length; i++) {
							Message msg = msgs[i];
							if (msg.isSet(Flags.Flag.FLAGGED)) {
								msg.setFlag(Flags.Flag.FLAGGED, false);
								returnData = "DEL";
							} else {
								msg.setFlag(Flags.Flag.FLAGGED, true);
								returnData = "NEW";
							}
						}

						sourceFolder.close(true);
					}
				}
			} catch (MessagingException e) {
				returnData = "ERROR : " + e.getMessage();
				logger.error(e.getMessage(), e);
			} catch (Exception e) {
				returnData = "ERROR : " + e.getMessage();
				logger.error(e.getMessage(), e);
			} finally {
				if (ia != null) {
					ia.close();
				}
			}
		}
		
		logger.debug("returnData=" + returnData);
		logger.debug("mailSetFlag ended.");
		
		return returnData;				
	}
	
	/**
	 * 메일 읽음 상태 지정 실행 함수
	 */
	@RequestMapping(value="/ezEmail/mailSetReadChange.do", method=RequestMethod.POST,
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
        
		Document doc = commonUtil.convertStringToDocument(bodyData != null ? bodyData : "");
		String isRead = doc.getElementsByTagName("ISREAD").item(0).getTextContent();
		/*NodeList messageIdList = doc.getElementsByTagName("MESSAGEID");	
		String firstItem = messageIdList.item(0).getTextContent();
		
		String folderId = null;
		folderId = firstItem.split("/")[0];			
		long[] uids = new long[messageIdList.getLength()];
		for (int i = 0; i < messageIdList.getLength(); i++) {
			String item = messageIdList.item(i).getTextContent();
			String msgId = item.split("/")[1];
			uids[i] = Long.parseLong(msgId);
		}	
		logger.debug("folderId=" + folderId);*/

		// 2025-02-19 - 다중 편지함 지원을 위해 getFolderIdUid 함수 이용
		int messageIdCount = doc.getElementsByTagName("MESSAGEID").getLength();
		String[] messageIdList = new String[messageIdCount];

		for (int i = 0; i < messageIdCount; i++) {
			messageIdList[i] = doc.getElementsByTagName("MESSAGEID").item(i).getTextContent();
		}

		Map<String, long[]> folderIdUids = ezEmailUtil.getFolderIdUid(messageIdList);
		
		String returnData = "<DATA>OK</DATA>";
		
		IMAPAccess ia = null;
		try {
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userEmail, password, egovMessageSource, locale, ezEmailUtil);

			if (ia != null){
				// 2025-02-19 - 다중 편지함 지원을 위해 for문, long[] uids 추가
				for (String folderId : folderIdUids.keySet()) {
					long[] uids = folderIdUids.get(folderId);
					IMAPFolder sourceFolder = (IMAPFolder)ia.getFolder(folderId);
					if (sourceFolder == null){
						throw new Exception("SourceFolder is null");
					}
					sourceFolder.open(Folder.READ_WRITE);
	
					Message[] msgs = sourceFolder.getMessagesByUID(uids);
	
					if (isRead.equals("TRUE")) {
						sourceFolder.setFlags(msgs, new Flags(Flags.Flag.SEEN), true);
					}
					else {
						sourceFolder.setFlags(msgs, new Flags(Flags.Flag.SEEN), false);
					}
	
					sourceFolder.close(true);
				}
			}

		} catch (MessagingException e) {
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
		
		logger.debug("returnData=" + returnData);
		logger.debug("mailSetReadChange ended.");
		
		return returnData;				
	}
	
	/**
	 * 메일에서 보낸사람 정보 추출 함수
	 */
	@RequestMapping(value="/ezEmail/mailGetFromEmail.do", method=RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String mailGetFromEmail(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request,
			@RequestBody String bodyData, Locale locale, Model model) throws Exception {
		logger.debug("mailGetFromEmail started.");
		logger.debug("bodyData=" + bodyData);

		String resultData = "ERROR";
		if (bodyData != null){
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

			if (uid == 0 || folderPath == null || "".equals(folderPath.trim())) {
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

			try {
				ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
						userEmail, password, egovMessageSource, locale, ezEmailUtil);
				Folder folder = ia.getFolder(folderPath);
				folder.open(Folder.READ_ONLY);
				Message message = ((IMAPFolder)folder).getMessageByUID(uid);
				
				if (message != null) {
					String name = ezEmailUtil.getFromNameOrAddressOfMessage(message);
					name = commonUtil.trimDoubleQuotes(name);

					String email = ((InternetAddress)message.getFrom()[0]).getAddress();
					
					if (name == null || name.trim().equals("")) {
						name = email;
						
						List<String> mailAddrList = ezEmailUtil.mailAddrNameParse(name, email);
						name = mailAddrList.get(0);
						email = mailAddrList.get(1);
					}

					// "01099455495 <발신전용>" <01099455495@ktfmms.magicn.com>와 같이 이름안에 <> 기호가 있는 경우
					// 이름을 감싸는 이중따옴표가 제거된 상태로 처리가 되어 이메일 주소 파싱에 오류가 발생함. 이에 < 기호가 있는 경우
					// 다시 이중따옴표로 감싸도록 함.
					if (name.contains("<")) {
						resultData = "\"" + name + "\"" + " <" + email + ">";
					} else {
						resultData = name + " <" + email + ">";
					}
				}
				
				folder.close(true);
				
			} catch (MessagingException e) {
				logger.error(e.getMessage());
			} finally {
				if (ia != null) {
					ia.close();
				}
			}
		}
		
		logger.debug("resultData=" + resultData);
		logger.debug("mailGetFromEmail ended.");
		
		return resultData;
	}
	
	/**
	 * 수신거부 화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailDenial.do", method=RequestMethod.GET)
	public String mailDenial() throws Exception {
		return "ezEmail/mailDenial";
	}
	
	/**
	 * jgw에 수신거부 요청 실행 함수
	 */
	@RequestMapping(value="/ezEmail/mailRequestDenial.do", method=RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String mailRequestDenial(@CookieValue("loginCookie") String loginCookie,
			@RequestBody String bodyData, Locale locale, Model model) throws Exception {
		logger.debug("mailRequestDenial started.");
		
		String returnData = "<DATA><![CDATA[ERROR]]></DATA>";
		Document xmldom = commonUtil.convertStringToDocument(bodyData != null ? bodyData : "");
		NodeList nodes = xmldom.getElementsByTagName("DENIAL");
		NodeList shareId = xmldom.getElementsByTagName("SHAREID");
		
		if (nodes == null || nodes.getLength() == 0) {
			logger.error("cannot get request data");
			logger.debug("mailRequestDenial ended.");
			return returnData;
		}
		
		StringBuilder sb = new StringBuilder();
		
		LoginVO loginInfo = commonUtil.userInfo(loginCookie);
        String domainName = ezCommonService.getTenantConfig("DomainName", loginInfo.getTenantId());
        String userEmail = loginInfo.getId() + "@" + domainName;
        // 20200109 공유사서함 수신거부 기능 추가
        if (shareId != null && shareId.getLength() != 0) { 
        	String shared = shareId.item(0).getTextContent();
            logger.debug("shared=" + shared);
        	userEmail = shared + "@" + domainName;
        }
		
        logger.debug("userEmail=" + userEmail);
        
		sb.append("userId=" + URLEncoder.encode(userEmail, "UTF-8"));
		
		List<String> addresses = new ArrayList<String>();
		
		for (int i=0; i<nodes.getLength(); i++) {
			String address = nodes.item(i).getTextContent();
			address = address.replaceAll(":", ""); // InternetAddress.class 1023_line
			
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
	@RequestMapping(value="/ezEmail/getPortletMailList.do", method=RequestMethod.POST, produces="text/xml; charset=utf-8")
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
			if (ia == null){
				throw new Exception("Ia is null");
			}
			long[] storageUsageAndLimit = ia.getStorageUsageAndLimit();
			if (storageUsageAndLimit == null){
				throw new Exception("storageUsageAndLimit is null");
			}
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
			
			// Folder.getUnreadMessageCount() 메소드 동작 방식이 folder가 open 상태일 때는 읽지 않은 메일 갯수를 IMAP search 명령을
			// 통해 비효율적으로 구하는 관계로 folder open 전에 호출함. open 상태가 아닐 때는 IMAP status 명령을 사용하며 status 명령이
			// 더 효율적임.							
 			int unreadCount = ia.getUnreadCount(folderPath);
 			
			folder.open(Folder.READ_ONLY);
	        
	        Message[] messages = null;
	        
 			int mailCount = 7;
 			
	        messages = ezEmailUtil.searchFolder(ia, userAccount, folder, "", "", null, new Date(), false, 
	        		false, false, "receivedDate", false, 0, mailCount, false, null, userInfo.getTenantId(), "");
	        
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
		
		} catch (MessagingException e) {
			logger.error(e.getMessage(), e);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		} finally {
			if (ia != null) {
				ia.close();
			}
		}
		
		logger.debug("getPortletMailList ended.");
		
		return returnData;
	}
	
	/**
	 * 메일 완료/완료취소 컨피그 설정
	 */
	@RequestMapping(value="/ezEmail/mailSetFlagForMailConfirm.do", method=RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String mailSetFlagForMailConfirm(@CookieValue("loginCookie") String loginCookie,
			HttpServletRequest request,
			@RequestBody String bodyData,
			Locale locale, Model model) throws Exception {
		logger.debug("mailSetFlagForMailConfirm started.");
		logger.debug("bodyData=" + bodyData);
		
		String returnData = "OK";
		
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
        
		Document doc = commonUtil.convertStringToDocument(bodyData != null ? bodyData : "");
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
					
			if (ia != null){
				IMAPFolder sourceFolder = (IMAPFolder)ia.getFolder(folderId);
				if (sourceFolder == null){
					throw new Exception("SourceFolder is null");
				}
				sourceFolder.open(Folder.READ_WRITE);

				Message[] msgs = sourceFolder.getMessagesByUID(uids);
				for (int i = 0; i < msgs.length; i++) {
					Message msg = msgs[i];
					ezEmailUtil.setMailConfirmFlag(msg, !ezEmailUtil.hasMailConfirmFlag(msg));
				}

				sourceFolder.close(true);
			}
		} catch (MessagingException e) {
			returnData = "ERROR : " + e.getMessage();
			logger.error(e.getMessage(), e);
		} catch (Exception e) {
			returnData = "ERROR : " + e.getMessage();
			logger.error(e.getMessage(), e);
		} finally {
			if (ia != null) {
				ia.close();
			}
		}
		
		logger.debug("returnData=" + returnData);
		logger.debug("mailSetFlagForMailConfirm ended.");
		
		return returnData;				
	}

	/**
	 * 해킹 메일 신고 내용 작성 팝업
	 */
	@RequestMapping(value="/ezEmail/hackingMailReportMessage.do", method=RequestMethod.GET)
	public String hackingMailReportMessage(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {

		logger.debug("hackingMailReportMessage started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		model.addAttribute("userInfo", userInfo);

		logger.debug("hackingMailReportMessage ended");

		return "ezEmail/hackingMailReportMessage";
	}	
	
	/**
	 * 해킹 메일 신고 기능
	 */
	@RequestMapping(value="/ezEmail/hackingMailMoveAndSend.do", method=RequestMethod.POST)
	@ResponseBody
	public String hackingMailMoveAndSend(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, 
			@RequestBody String bodyData, Locale locale, Model model) throws Exception {
		logger.debug("mailMoveCopyMessage started.");
		logger.debug("bodyData=" + bodyData);
		
		String returnValue = "OK";
		
		IMAPAccess ia = null;
        String userEmail = "";      		
		
		try {
			List<String> userIdAndPassword = commonUtil.getUserIdAndPassword(loginCookie);
			String password = userIdAndPassword.get(1);
			
			Document doc = commonUtil.convertStringToDocument(bodyData != null ? bodyData : "");
			String cmd = doc.getElementsByTagName("CMD").item(0).getTextContent();
			String uniqueId = doc.getElementsByTagName("UNIQUEID").item(0).getTextContent();
			String reportMessage = doc.getElementsByTagName("MESSAGE").item(0).getTextContent();
			
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
	        
	        logger.debug("userId=" + userInfo.getId() + ",userEmail=" + userEmail);
	        
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userEmail, password, egovMessageSource, locale, ezEmailUtil);

			if (ia != null){
				IMAPFolder sourceFolder = (IMAPFolder)ia.getFolder(folderId);
				sourceFolder.open(Folder.READ_WRITE);

				///////////////////////// 해킹의심메일 관리자 계정으로 발송 로직 시작 /////////////////////////
				InternetAddress from = new InternetAddress();
				from.setPersonal(userInfo.getDisplayName(), "UTF-8");
				from.setAddress(userInfo.getEmail());

				String adminID = ezCommonService.getTenantConfig("HackingAdminID",
						userInfo.getTenantId());

			OrganUserVO adminVo = null;

			// To
			InternetAddress to = new InternetAddress();
			
			if(adminID.contains("@")){
				to.setPersonal(adminID, "UTF-8");
				to.setAddress(adminID);
			}else{
				adminVo = ezOrganService.getUserInfo(adminID, userInfo.getLang(), userInfo.getTenantId());
				if(adminVo != null){
					to.setPersonal(adminVo.getDisplayName(), "UTF-8");
					to.setAddress(adminVo.getMail());
				}
			}

			for (int i = 0; i < uids.length; i++) {
				Message message = sourceFolder.getMessageByUID(uids[i]);

				String subject = "[" + egovMessageSource.getMessage("ezEmail.zno000", locale) + "] " + message.getSubject();
		    	
		    	// 해킹의심메일의 보낸사람
		    	Address[] arrFroms = message.getFrom();
				String fromStr = ((InternetAddress)arrFroms[0]).getAddress();
				/*if (arrFroms != null) {
					fromStr = ezEmailUtil.getFromNameOrAddressOfMessage(message);
					fromStr = commonUtil.trimDoubleQuotes(fromStr);
					fromStr = fromStr + " <" + ((InternetAddress)arrFroms[0]).getAddress() + ">";
				} else {
					String[] fromHeaders = message.getHeader("From");
					if (fromHeaders != null) {
						fromStr = MimeUtility.decodeText(message.getHeader("From")[0]);
					}
				}*/
				
				// 해킹의심메일의 보낸일자
		    	Date receivedDate = message.getReceivedDate();
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
				sdf.setTimeZone(TimeZone.getTimeZone("GMT"));
				String receivedDateStr = sdf.format(receivedDate);
				receivedDateStr = commonUtil.getDateStringInUTC(receivedDateStr, userInfo.getOffset(), false);
				
				// 내용
				String content = " <table cellpadding='0' cellspacing='0' style='width:100%;margin:0;padding:0;border-bottom: 1px solid #f3f3f3; padding-bottom: 10px;'>"
						+ "		<tbody>";
				content += "<tr><td width='70' style='padding-bottom:9px;font-size:14px;color:#696969; vertical-align: top;'>"
						+ egovMessageSource.getMessage("ezEmail.t707", locale)
						+ "</td>"
						+ "<td style='padding-bottom:9px;font-size:14px; color:#000;'>"
						+ message.getSubject()
						+ "</td></tr>";
				content += " <tr><td width='70' style='padding-bottom:9px;font-size:14px; color:#696969; vertical-align: top;'>"
						+ egovMessageSource.getMessage("ezEmail.t656", locale)
						+ "</td>"
						+ "<td style='padding-bottom:9px;font-size:14px;color:#000;'>"
						+ fromStr
						+ "</td></tr>";
				content += "<tr><td width='70' style='padding-bottom:9px;font-size:14px; color:#696969; vertical-align: top;'>"
						+ egovMessageSource.getMessage("ezEmail.t657", locale)
						+ "</td>"
						+ "<td style='padding-bottom:9px;font-size:14px;color:#000;vertical-align:top'>"
						+ receivedDateStr
						+ "</td></tr>";
				content += "</tbody></table>";
				content += "<div class='mail_txtArea' style='margin-top: 15px; font-size: 14px;'>"
						+ reportMessage
						+ "</div>";
				
		    	// 첨부파일
		    	String fileName = ezEmailUtil.saveFilenameForm(userInfo, locale, message) + ".eml";
				//fileName = CommonUtil.getEncodedFileNameForDownload(request.getHeader("User-Agent"), fileName);
				logger.debug("fileName=" + fileName);
				
				ByteArrayInputStream inputStream = null;
				ByteArrayOutputStream outputStream = new ByteArrayOutputStream();

					String pReadFlag = "Y";

					// 선택 된 해킹 의심 메일이 안읽은 메일이면
					if (!message.isSet(Flags.Flag.SEEN)) {
						pReadFlag = "N";
					}

					try{
						message.writeTo(outputStream);

						boolean isRead = pReadFlag.equalsIgnoreCase("Y");
						message.setFlag(Flags.Flag.SEEN, isRead);

						inputStream = new ByteArrayInputStream(outputStream.toByteArray());
					} catch(IOException e){
						logger.error(e.getMessage(), e);
					} finally {
						if (inputStream != null) {
							inputStream.close();
						}
						if (outputStream != null) {
							outputStream.close();
						}
					}
					
					ezEmailService.sendMail(userEmail, password, userInfo.getLocale(), from, new InternetAddress[]{to}, null, null, subject, content, false, EmailImportance.NORMAL, fileName, "message/rfc822", inputStream);
					
				}
			
				///////////////////////// 해킹의심메일 관리자 계정으로 발송 로직 끝 /////////////////////////
				
				
				///////////////////////// 해당 메일을 사용자의 해킹의심메일함으로 이동 시작 /////////////////////////
				Message[] messages = sourceFolder.getMessagesByUID(uids);						
				IMAPFolder movefolder = (IMAPFolder)ia.getFolder(ezEmailUtil.getJunkFolderId(userInfo.getLocale()));			
				
				String useImapMoveCommand = ezCommonService.getTenantConfig("useImapMoveCommand", userInfo.getTenantId());
				
				if (useImapMoveCommand.equals("YES")) {			
					if (cmd.equalsIgnoreCase("MOVE")) {
						sourceFolder.moveUIDMessages(messages, movefolder);
					} else {					
						sourceFolder.copyUIDMessages(messages, movefolder);					
					}
				}
				///////////////////////// 해당 메일을 사용자의 해킹의심메일함으로 이동 끝 /////////////////////////
				
				sourceFolder.close(true);		
			}
		} catch (DOMException e) {
			returnValue = "ERROR : " + e.getMessage();
			logger.error(e.getMessage(), e);
		} catch (Exception e) {
			returnValue = "ERROR : " + e.getMessage();
			logger.error(e.getMessage(), e);
		} finally {
			if (ia != null) {
				ia.close();
			}			
		}
		
		logger.debug("returnValue=" + returnValue);
		logger.debug("hackingMailMoveAndSend ended.");
		
		return returnValue;
	}

	@PostMapping("ezEmail/addMailTag.do")
	@ResponseBody
	public Result addMailTag(@CookieValue String loginCookie, @RequestParam String folderPath, @RequestParam int mailUid, @RequestParam String tagName, @RequestParam(required = false) String shareId) {
		logger.debug("addMailTag started. folderPath: {}, mailUid: {}, tagName: {}, shareId: {}", folderPath, mailUid, tagName, shareId);

		if (StringUtils.isBlank(tagName)) {
			logger.debug("addMailTag ended. tagName must not be blank.");
			return Result.failure();
		}

		if (NOT_ALLOWED_TAG_NAME_REGEXP.matcher(tagName).find()) {
			logger.debug("addMailTag ended. tagName must not be contains \"!@#$%^&()\\\\/:*?\"<>|'`\"");
			return Result.failure();
		}

		Result result = null;

		try {
			LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
			String userAccount = user.getId() + "@" + ezCommonService.getTenantConfig("DomainName", user.getTenantId());

			if (StringUtils.isNotBlank(shareId)) {
				userAccount = shareId +  "@" + ezCommonService.getTenantConfig("DomainName", user.getTenantId());
			}

			IMAPAccess ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"), userAccount, jspw, egovMessageSource, Locale.KOREAN, ezEmailUtil);
			if (ia != null){
				Folder mailbox = ia.getFolder(folderPath);

				if (mailbox == null || !mailbox.exists()) {
					throw new FolderNotFoundException(mailbox, "not exists folder: " + folderPath);
				}

				mailbox.open(Folder.READ_WRITE);
				Message message = ((IMAPFolder) mailbox).getMessageByUID(mailUid);
				tagName = tagName.trim().replaceAll("\\s", "_");
				ezEmailUtil.setTagFlag(message, userAccount, tagName, true);
				mailbox.close(true);
			}
			result = Result.success();
		} catch (MessagingException e) {
			logger.error(e.getMessage(), e);
			result = Result.failure();
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result = Result.failure();
		}

		logger.debug("addMailTag ended. result: {}", result);
		return result;
	}

	@PostMapping("ezEmail/deleteMailTag.do")
	@ResponseBody
	public Result deleteMailTag(@CookieValue String loginCookie, @RequestParam String folderPath, @RequestParam int mailUid, @RequestParam String tagName, @RequestParam(required = false) String shareId) {
		logger.debug("deleteMailTag started. folderPath: {}, mailUid: {}, tagName: {}, shareId: {}", folderPath, mailUid, tagName, shareId);
		Result result = null;

		try {
			LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
			String userAccount = user.getId() + "@" + ezCommonService.getTenantConfig("DomainName", user.getTenantId());

			if (StringUtils.isNotBlank(shareId)) {
				userAccount = shareId + "@" + ezCommonService.getTenantConfig("DomainName", user.getTenantId());
			}

			JgwResult deleteResult = rest.jgw().url("/jMochaEzEmail/deleteTagFromMail")
					.formParam("userAccount", userAccount)
					.formParam("folderPath", folderPath)
					.formParam("mailUid", mailUid)
					.formParam("tagName", tagName)
					.exchangeJgwResult();
			logger.debug("jgw deleteTagFromMail result: {}", deleteResult);
			result = deleteResult.succeeded() ? Result.success() : Result.failure();
		} catch (RuntimeException e) {
			logger.error(e.getMessage(), e);
			result = Result.failure();
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result = Result.failure();
		}

		logger.debug("deleteMailTag ended. result: {}", result);
		return result;
	}

	@GetMapping("ezEmail/getUserTagList.do")
	@ResponseBody
	public Result getUserTagList(@CookieValue String loginCookie, @RequestParam(required = false) String orderBy, @RequestParam(required = false) String shareId) {
		logger.debug("getUserTagList started. orderBy: {}, shareId: {}", orderBy, shareId);
		Result result = null;

		try {
			// count, date, 빈 값 또는 null이 아니라면 에러
			if (orderBy != null && !orderBy.matches("count|date|")) {
				throw new IllegalArgumentException("orderBy accepts only 'count', 'date', '' or null");
			}

			LoginSimpleVO user = commonUtil.userInfoSimple(loginCookie);
			String userAccount = user.getId() + "@" + ezCommonService.getTenantConfig("DomainName", user.getTenantId());

			if (StringUtils.isNotBlank(shareId)) {
				userAccount = shareId + "@" + ezCommonService.getTenantConfig("DomainName", user.getTenantId());
			}

			Rest.RestBuilder jgwRestBuilder = rest.jgw().url("/jMochaEzEmail/getUserTagList").formParam("userAccount", userAccount);
			if (orderBy != null) {
				jgwRestBuilder.formParam("orderBy", orderBy);
			}
			JgwResult jgwResult = jgwRestBuilder.exchangeJgwResult();
			//logger.debug("jgw getUserTagFromMail result: {}", jgwResult); // 로그가 너무 많아서 주석처리 함, result값은 jgw서버 로그에서 확인 가능
			logger.debug("jgw getUserTagFromMail userAccount: {}, jgwResultCode: {}", userAccount, jgwResult.getResultCode());
			result = jgwResult.succeeded() ? Result.success(jgwResult.getResult()) : Result.failure();
		} catch (PatternSyntaxException e) {
			logger.error(e.getMessage(), e);
			result = Result.failure();	
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result = Result.failure();
		}

		//logger.debug("getUserTagList ended. result: {}", result);
		logger.debug("getUserTagList ended. result: {}", result.getStatus());
		return result;
	}

	/**
	 * 승인메일 :
	 * 발송승인대기 페이지
	 */
	@RequestMapping(value = "/ezEmail/appr/pendingList.do", method = RequestMethod.GET)
	public String apprPendingList(@CookieValue("loginCookie") String loginCookie, @RequestParam String startNum, Model model) throws Exception {
		logger.debug("apprPendingList started.");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		int tenantId = userInfo.getTenantId();
		String companyId = userInfo.getCompanyID();
		String userId = userInfo.getId();
		String lang = userInfo.getLang();
		String type = "approver"; // 승인자

		String domainName = ezCommonService.getTenantConfig("DomainName", tenantId);
		
		// 페이지네이션
		int pageMax = 0;
		int pageStartNum = 1;
		int listTotalCount = 0;
		int pageBlockSize = 10;

		int listCount =  ezEmailUtil.getListCount(tenantId, userId);

		if (StringUtils.isNotBlank(startNum)) {
			pageStartNum = Integer.parseInt(startNum);
		}

		// 로그출력
		logger.debug("apprPendingList id={}, type={}, tenantId={}, companyId={}, lang={}, pageStartNum={}, listCount={}",
				userId, type, tenantId, companyId, lang, pageStartNum, listCount);

		// jgw 서버에서 리스트 받아오기
		JSONArray resultArry = new JSONArray();

		try {
			listTotalCount = ezEmailService.getApprMailListCount(tenantId, companyId, type, userId);
			pageMax = (int) Math.ceil((double) listTotalCount / listCount);
			
			pageStartNum = pageStartNum > pageMax ? pageMax : pageStartNum;
			
			JSONArray array = ezEmailService.getApprMailList(tenantId, companyId, type, userId, lang, pageStartNum,	listCount, domainName);
			JSONArray array2 = ezEmailService.setUTCtoUserTime(array, userInfo.getOffset(), tenantId);
			resultArry = ezEmailService.setHref(array2);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}

		// set model
		model.addAttribute("shareId", Globals.APPR_MAIL_SHARED_ID);
		model.addAttribute("lang", userInfo.getLang());
		model.addAttribute("userId", userInfo.getId());
		model.addAttribute("resultArry", resultArry);
		model.addAttribute("pageStartNum", pageStartNum);
		model.addAttribute("pageMax", pageMax);
		model.addAttribute("listTotalCount", listTotalCount);
		model.addAttribute("pageBlockSize", pageBlockSize);

		logger.debug("apprPendingList ended.");
		return "ezEmail/apprPendingList";
	}

	/**
	 * 승인메일 :
	 * 발송완료목록 페이지
	 */
	@RequestMapping(value = "/ezEmail/appr/completeList.do", method = RequestMethod.GET)
	public String apprCompleteList(@CookieValue("loginCookie") String loginCookie, @RequestParam String startNum, Model model) throws Exception {
		logger.debug("apprCompleteList started.");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		int tenantId = userInfo.getTenantId();
		String companyId = userInfo.getCompanyID();
		String userId = userInfo.getId();
		String lang = userInfo.getLang();
		Locale locale = userInfo.getLocale();
		String type = "complete"; // 완료

		String domainName = ezCommonService.getTenantConfig("DomainName", tenantId);
		
		// 페이지네이션
		int pageMax = 0;
		int pageStartNum = 1;
		int listTotalCount = 0;
		int pageBlockSize = 10;

		if (StringUtils.isNotBlank(startNum)) {
			pageStartNum = Integer.parseInt(startNum);
		}

		int listCount =  ezEmailUtil.getListCount(tenantId, userId);

		logger.debug("apprCompleteList id={}, type={}, tenantId={}, companyId={}, lang={}, pageStartNum={}, listCount={}",
				userId, type, tenantId, companyId, lang, pageStartNum, listCount);

		JSONArray resultArry = new JSONArray();

		try {
			listTotalCount = ezEmailService.getApprMailListCount(tenantId, companyId, type, userId);
			pageMax = (int) Math.ceil((double) listTotalCount / listCount);
			
			pageStartNum = pageStartNum > pageMax ? pageMax : pageStartNum;
			
			JSONArray array = ezEmailService.getApprMailList(tenantId, companyId, type, userId, lang, pageStartNum,	listCount, domainName);
			JSONArray array2 = ezEmailService.setUTCtoUserTime(array, userInfo.getOffset(), tenantId);
			JSONArray array3 = ezEmailService.setHref(array2);
			resultArry = ezEmailService.setStateByLocale(array3, locale);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}

		// set model
		model.addAttribute("shareId", Globals.APPR_MAIL_SHARED_ID);
		model.addAttribute("lang", userInfo.getLang());
		model.addAttribute("userId", userInfo.getId());
		model.addAttribute("resultArry", resultArry);
		model.addAttribute("pageStartNum", pageStartNum);
		model.addAttribute("pageMax", pageMax);
		model.addAttribute("listTotalCount", listTotalCount);
		model.addAttribute("pageBlockSize", pageBlockSize);

		logger.debug("apprCompleteList ended.");
		return "ezEmail/apprCompleteList";
	}

	/**
	 * 승인메일 :
	 * 발송요청목록 페이지
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ezEmail/appr/requestList.do", method = RequestMethod.GET)
	public String apprRequestList(@CookieValue("loginCookie") String loginCookie, @RequestParam String startNum, Model model, HttpServletRequest request) throws Exception {
		logger.debug("apprRequestList started.");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		int tenantId = userInfo.getTenantId();
		String companyId = userInfo.getCompanyID();
		String userId = userInfo.getId();
		String lang = userInfo.getLang();
		String type = "user"; // 작성자
		Locale locale = userInfo.getLocale();
		//String mailbox = "Sent." + userId;

		String domainName = ezCommonService.getTenantConfig("DomainName", tenantId);

		String shareId = request.getParameter("shareId");
		logger.debug("userId={}, shareId={}", userId, shareId);
		
		String vUserId = StringUtils.defaultIfBlank(shareId, userId);
		
		int pageMax = 0;
		int pageStartNum = 1;
		int listTotalCount = 0;
		int pageBlockSize = 10;

		if (StringUtils.isNotBlank(startNum)) {
			pageStartNum = Integer.parseInt(startNum);
		}

		int listCount = ezEmailUtil.getListCount(tenantId, userId);

		logger.debug("apprRequestList vUserId={}, type={}, tenantId={}, companyId={}, lang={}", vUserId, type, tenantId, companyId, lang);

		JSONArray resultArry = new JSONArray();

		try {
			listTotalCount = ezEmailService.getApprMailListCount(tenantId, companyId, type, vUserId);
			pageMax = (int) Math.ceil((double) listTotalCount / listCount);
			
			pageStartNum = pageStartNum > pageMax ? pageMax : pageStartNum;
			
			JSONArray array = ezEmailService.getApprMailList(tenantId, companyId, type, vUserId, lang, pageStartNum, listCount, domainName);
			JSONArray array2 = ezEmailService.setUTCtoUserTime(array, userInfo.getOffset(),tenantId);
			JSONArray array3 = ezEmailService.setApprover(array2, locale);
			resultArry = ezEmailService.setHref(array3);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}

		// set model
		model.addAttribute("shareId", Globals.APPR_MAIL_SHARED_ID);
		//model.addAttribute("mailbox", mailbox);
		model.addAttribute("lang", userInfo.getLang());
		model.addAttribute("userId", vUserId);
		model.addAttribute("resultArry", resultArry);
		model.addAttribute("pageStartNum", pageStartNum);
		model.addAttribute("pageMax", pageMax);
		model.addAttribute("listTotalCount", listTotalCount);
		model.addAttribute("pageBlockSize", pageBlockSize);

		logger.debug("apprRequestList ended.");
		return "ezEmail/apprRequestList";
	}

	/**
	 * 승인메일 :
	 * 신청 취소
	 */
	@RequestMapping(value="/ezEmail/appr/setCancel.do", method=RequestMethod.POST, produces="text/plain")
	@ResponseBody
	public String apprSetCancel(@CookieValue("loginCookie") String loginCookie, @RequestParam("href") String encryptedHref) throws Exception {
		logger.debug("apprSetCancel started.");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();
		int tenantId = userInfo.getTenantId();
		String companyId = userInfo.getCompanyID();
		String domainName = ezCommonService.getTenantConfig("DomainName", tenantId);
		logger.debug("apprSetCancel userId={}, tenantId={}, companyId={}, domainName={}", userId, tenantId, companyId, domainName);

		String returnValue = "OK";
		// param
		String href = egovFileScrty.decryptAES(encryptedHref);
		String hrefUserId = href.split("/")[0].replaceFirst("^Sent\\.", "");
		long uid = Long.parseLong(href.split("/")[1]);

		// 신청자 정보
		OrganUserVO applicantVO = ezOrganAdminService.getUserInfo(hrefUserId, "1", tenantId);
		String applicantId = applicantVO.getCn();
		String applicantEmail = applicantId + "@" + domainName;

		logger.debug("apprSetCancel userId={}, href={}, hrefUserId={}, uid={}, applicantId={}, applicantEmail={}",
				userId, href, hrefUserId, uid, applicantId, applicantEmail);

		int resultInt = ezEmailService.setApprMailCancel(loginCookie, applicantEmail, uid);

		if (resultInt != 0) {
			returnValue = "ERROR";
		}

		logger.debug("apprSetCancel ended. userId={}, returnValue={}", userId, returnValue);
		return returnValue;
	}

	/**
	 * 승인메일 :
	 * 발송 승인
	 */
	@RequestMapping(value="/ezEmail/appr/setApproval.do", method=RequestMethod.POST)
	@ResponseBody
	public String apprSetApproval(@CookieValue("loginCookie") String loginCookie, @RequestBody MailApprVO request) throws Exception {
		logger.debug("apprSetApproval started.");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();
		int tenantId = userInfo.getTenantId();
		String companyId = userInfo.getCompanyID();
		String domainName = ezCommonService.getTenantConfig("DomainName", tenantId);
		logger.debug("apprSetApproval userId={}, tenantId={}, companyId={}, domainName={}", userId, tenantId, companyId, domainName);

		String returnValue = "OK";
		int errorInt = 0; // 오류난 개수
		// param
		String[] hrefArray = request.getHrefArray();

		for(String encryptedHref : hrefArray) {
			// decrypt & mailbox/uid
			String href = egovFileScrty.decryptAES(encryptedHref);
			String hrefUserId = href.split("/")[0].replaceFirst("^Sent\\.", "");
			long uid = Long.parseLong(href.split("/")[1]);

			// 신청자 정보
			String applicantId = hrefUserId;
			String applicantEmail = hrefUserId + "@" + domainName;
			OrganUserVO applicantVO = ezOrganAdminService.getUserInfo(hrefUserId, "1", tenantId);
			if (applicantVO != null) {
				applicantId = applicantVO.getCn();
				applicantEmail = applicantId + "@" + domainName;
			}

			logger.debug("apprSetApproval userId={}, href={}, hrefUserId={}, uid={}, applicantId={}, applicantEmail={}",
					userId, href, hrefUserId, uid, applicantId, applicantEmail);

			int resultInt = ezEmailService.setApprMailApproval(loginCookie, applicantEmail, uid);
			if (resultInt != 0) {
				errorInt++;
			}
		}

		if (errorInt > 0) {
			returnValue = "ERROR_" + errorInt;
		}

		logger.debug("apprSetApproval ended. returnValue=" + returnValue);

		return returnValue;
	}

	/**
	 * 승인메일 :
	 * 발송거부 요청 화면
	 */
	@RequestMapping(value = "/ezEmail/appr/setReject.do", method = RequestMethod.GET)
	public String apprSetReject(@CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("apprSetReject started & ended. userId={}", commonUtil.userInfo(loginCookie).getId());

		return "ezEmail/new/apprRejectPopUp";
	}

	/**
	 * 승인메일 :
	 * 발송거부 action
	 */
	@RequestMapping(value="/ezEmail/appr/setRejectAction.do", method=RequestMethod.POST)
	@ResponseBody
	public String apprSetRejectAction(@CookieValue("loginCookie") String loginCookie, @RequestBody MailApprVO request) throws Exception {
		logger.debug("apprSetRejectAction started.");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();
		int tenantId = userInfo.getTenantId();
		String companyId = userInfo.getCompanyID();
		String domainName = ezCommonService.getTenantConfig("DomainName", tenantId);
		logger.debug("apprSetRejectAction userId={}, tenantId={}, companyId={}, domainName={}", userId, tenantId, companyId, domainName);

		String returnValue = "OK";
		int errorInt = 0; // 오류난 개수
		// param
		String[] hrefArray = request.getHrefArray();
		String memo = request.getMemo().replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("&", "&amp;");

		for(String encryptedHref : hrefArray) {
			// decrypt & mailbox/uid
			String href = egovFileScrty.decryptAES(encryptedHref);
			String hrefUserId = href.split("/")[0].replaceFirst("^Sent\\.", "");
			long uid = Long.parseLong(href.split("/")[1]);

			// 신청자 정보
			String applicantId = hrefUserId;
			String applicantEmail = hrefUserId + "@" + domainName;
			OrganUserVO applicantVO = ezOrganAdminService.getUserInfo(hrefUserId, "1", tenantId);
			if (applicantVO != null) {
				applicantId = applicantVO.getCn();
				applicantEmail = applicantId + "@" + domainName;
			}

			logger.debug("apprSetRejectAction userId={}, href={}, hrefUserId={}, uid={}, applicantId={}, applicantEmail={}",
					userId, href, hrefUserId, uid, applicantId, applicantEmail);

			int resultInt = ezEmailService.setApprMailReject(loginCookie, applicantEmail, uid, memo);
			if (resultInt != 0) {
				errorInt++;
			}
		}

		if (errorInt > 0) {
			returnValue = "ERROR_" + errorInt;
		}

		logger.debug("apprSetRejectAction ended. returnValue=" + returnValue);

		return returnValue;
	}

	@PostMapping("/ezEmail/createTag.do")
	@ResponseBody
	public Result createTag(@CookieValue("loginCookie") String loginCookie, @RequestParam String tagName, @RequestParam(required = false) String shareId) throws Exception {
		logger.debug("createTag started.");

		if (StringUtils.isBlank(tagName)) {
			logger.debug("createTag ended. tagName must not be blank.");
			return Result.failure();
		}

		if (NOT_ALLOWED_TAG_NAME_REGEXP.matcher(tagName).find()) {
			logger.debug("createTag ended. tagName must not be contains \"!@#$%^&()\\\\/:*?\"<>|'`\"");
			return Result.failure();
		}

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
		String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", userInfo.getTenantId());
		String userAccount;

		if ("YES".equalsIgnoreCase(useSharedMailbox) && StringUtils.isNotBlank(shareId)) {
			if (!ezEmailService.checkUserShareId(userInfo.getId(), shareId, userInfo.getTenantId())) {
				logger.debug("the user cannot access the shareId.");
				return Result.failure("the user cannot access the shareId.");
			}

			userAccount = shareId + "@" + domainName;
		} else {
			userAccount = userInfo.getId() + "@" + domainName;
		}

		int tagIdx = ezEmailUtil.createTag(userAccount, tagName);
		logger.debug("createTag ended.");

		return Result.success(tagIdx);
	}

	@PostMapping("/ezEmail/saveChangesTags.do")
	@ResponseBody
	public Result saveChangesTags(@CookieValue("loginCookie") String loginCookie, @RequestBody SaveChangesTagRequest saveChangesTagRequest) throws Exception {
		logger.debug("saveChagnesTags started. params: {}", saveChangesTagRequest.toString());
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
		String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", userInfo.getTenantId());
		String userAccount;

		if ("YES".equalsIgnoreCase(useSharedMailbox) && StringUtils.isNotBlank(saveChangesTagRequest.getShareId())) {
			if (!ezEmailService.checkUserShareId(userInfo.getId(), saveChangesTagRequest.getShareId(), userInfo.getTenantId())) {
				logger.debug("the user cannot access the shareId.");
				return Result.failure("the user cannot access the shareId.");
			}

			userAccount = saveChangesTagRequest.getShareId() + "@" + domainName;
		} else {
			userAccount = userInfo.getId() + "@" + domainName;
		}

		try (IMAPAccess imapAccess = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
				userAccount, jspw, egovMessageSource, userInfo.getLocale(), ezEmailUtil)) {
			// 메일함으로 uid를 그룹핑한다.
			Map<String, List<Long>> mailboxUidsMap = saveChangesTagRequest.getMailPathList().stream()
					.map(path -> path.split("/"))
					.filter(paths -> paths.length == 2)
					.collect(Collectors.groupingBy(paths -> paths[0],
							Collectors.mapping(paths -> Long.parseLong(paths[1]), Collectors.toList())));

			Flags addFlags = new Flags();
			Flags removeFlags = new Flags();

			saveChangesTagRequest.getEnableTagList().stream().distinct().map("$Tag-"::concat).forEach(addFlags::add);
			saveChangesTagRequest.getDisableTagList().stream().distinct().map("$Tag-"::concat).forEach(removeFlags::add);

			for (Map.Entry<String, List<Long>> entry : mailboxUidsMap.entrySet()) {
				try (Folder folder = imapAccess.getFolder(entry.getKey())) {
					folder.open(Folder.READ_WRITE);
					Message[] messagesByUID = ((IMAPFolder) folder).getMessagesByUID(ArrayUtils.toPrimitive(entry.getValue().toArray(new Long[0])));
					folder.setFlags(messagesByUID, addFlags, true);
					folder.setFlags(messagesByUID, removeFlags, false);
				}
			}
		} catch (Exception e) {
			logger.debug("saveChagneTags error:", e);
			return Result.failure();
		} finally {
			logger.debug("saveChagnesTags ended.");
		}

		return Result.success();
	}
}
