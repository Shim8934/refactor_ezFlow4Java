package egovframework.ezEKP.ezEmail.web;

import java.io.*;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Base64.Decoder;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Objects;
import java.util.Optional;
import java.util.Properties;
import java.util.Spliterator;
import java.util.TimeZone;
import java.util.UUID;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;
import java.util.stream.StreamSupport;
import java.util.regex.PatternSyntaxException;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import javax.annotation.Resource;
import javax.crypto.Cipher;
import javax.mail.Address;
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
import javax.mail.internet.InternetAddress;
import javax.mail.internet.InternetHeaders;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeUtility;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.JsonElement;

import egovframework.ezEKP.ezAI.util.AICommonUtil;
import org.apache.commons.codec.binary.Base64;
import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.io.IOUtils;
import org.apache.commons.io.filefilter.PrefixFileFilter;
import org.apache.commons.lang3.StringUtils;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

import com.sun.mail.dsn.DispositionNotification;
import com.sun.mail.dsn.MultipartReport;
import com.sun.mail.imap.AppendUID;
import com.sun.mail.imap.IMAPFolder;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.com.cmm.service.Globals;
import egovframework.ezEKP.ezCabinet.service.EzCabinetAdminService;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.logic.IMAPAccess;
import egovframework.ezEKP.ezEmail.logic.SMTPAccess;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezEmail.util.EzEmailUtil;
import egovframework.ezEKP.ezEmail.vo.MailGeneralVO;
import egovframework.ezEKP.ezEmail.vo.MailSecureReaderVO;
import egovframework.ezEKP.ezEmail.vo.MailSecureVO;
import egovframework.ezEKP.ezEmail.vo.MailSharedMailboxUserVO;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovStringUtil;
import egovframework.let.utl.rest.JgwResult;
import egovframework.let.utl.rest.Rest;
import egovframework.let.utl.sim.service.EgovFileScrty;

/** 
 * @Description [Controller] 메일 읽기
 * @author 오픈솔루션팀 이효민
 * @Modification Information
 *
 *    수정일        수정자         수정내용
 *    ----------    ------    -------------------
 *    2016.04.14    이효민    신규작성
 *
 * @see
 */

@Controller
public class EzEmailMailReadController extends EgovFileMngUtil {

	private static final Logger logger = LoggerFactory.getLogger(EzEmailMailReadController.class);

	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private AICommonUtil aICommonUtil;

	@Autowired
	private Properties config;

	@Autowired
	private EzEmailUtil ezEmailUtil;
	
	@Autowired
	private EzEmailService ezEmailService;
	
	@Autowired
	private EzOrganAdminService ezOrganAdminService;
	
	@Resource(name = "EzCommonService")
    private EzCommonService ezCommonService;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource; 
	
	@Resource(name = "jspw")
    private String jspw;
	
	@Resource(name="crypto") 
    private EgovFileScrty egovFileScrty;
	
	@Resource(name = "loginService")
    private LoginService loginService;
	
	@Resource(name="EzCabinetAdminService")
	private EzCabinetAdminService cabinetAdminService;

	@Resource(name = "EzOrganService")
	private EzOrganService ezOrganService;

	@Autowired
	private Rest rest;

	/**
	 * 메일 읽기화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailRead.do", method=RequestMethod.GET)
	public String readMail(@CookieValue("loginCookie") String loginCookie, Locale locale, HttpServletRequest request, Model model) throws Exception {
		logger.debug("readMail started.");
		
		// get user credentials
		List<String> userInfo = commonUtil.getUserIdAndPassword(loginCookie);
		String password = userInfo.get(1);
		
		LoginVO loginInfo = commonUtil.userInfo(loginCookie);
		String domainName = ezCommonService.getTenantConfig("DomainName", loginInfo.getTenantId());
		String userEmail = loginInfo.getId() + "@" + domainName;
		String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", loginInfo.getTenantId());
		
		if (useSharedMailbox.equals("YES")) {
			String shareId = request.getParameter("shareId");
			logger.debug("shareId=" + shareId);
			
			if (shareId != null) {
				if (!ezEmailService.checkUserShareId(loginInfo.getId(), shareId, loginInfo.getTenantId())) {
					model.addAttribute("mainContent", egovMessageSource.getMessage("ezEmail.lhm81", locale));
					
					logger.debug("the user cannot access the shareId.");
					logger.debug("readMail ended.");
					
					return "ezCommon/error";
				}
				
				userEmail = shareId + "@" + domainName;
				
				MailSharedMailboxUserVO shareVO = ezEmailService.getSharedMailboxPermissionInfo(shareId, loginInfo.getTenantId(), loginInfo.getId());
				
				model.addAttribute("shareId", shareId);
				model.addAttribute("deletePermission", shareVO.getDeletePermission());
				model.addAttribute("sendPermission", shareVO.getSendPermission());
				model.addAttribute("managePermission", shareVO.getManagePermission());
			}
		}
		
		logger.debug("userId=" + loginInfo.getId() + ",userEmail=" + userEmail);
		
		//baonk 추가 2018-08-08
		String use_cabinet = ezCommonService.getTenantConfig("useCabinet", loginInfo.getTenantId());
		if (use_cabinet.equals("YES")) {
			use_cabinet = cabinetAdminService.checkModuleActive("email", loginInfo);
		}
		
		// retrieve the passed in parameters
		String url = request.getParameter("iptURL");
		if (url == null) {
			url = request.getParameter("URL");
		}
		
		logger.debug("url=" + url);
		
		long uid = 0;
		String folderPath = null;
		if (url != null) {
			int index = url.lastIndexOf("/");
			
			// separate the passed-in url into a folder path and a message uid
			if (index != -1) {
				folderPath = url.substring(0, index);
				uid = Long.parseLong(url.substring(index + 1));
			}
		}
		
		String pnFlag = "N";
		if (request.getParameter("PNFlag") != null) {
			pnFlag = request.getParameter("PNFlag");
		}
		
		String contentClass = request.getParameter("CONTENTCLASS") != null ? request.getParameter("CONTENTCLASS") :"";

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
		boolean isSecureMail = false;
		IMAPAccess ia = null;
		String sentDateMsg = ""; // 전달, 회신 시 보낸 시간
		boolean mailWritePreview = false; // 메일 작성 > 미리보기 
		String mailBox = "";
		boolean mailWritePreviewSend = false; // 메일 전송 > 미리보기
		
		// 읽기 화면에서 리스트 출력 위한 데이터
		String countryName = "";
		String countryIP = "";
		String countryCode = "";
		String[] tags = null;
		String systemCountryCode = ezCommonService.getTenantConfig("systemCountryCode", loginInfo.getTenantId());
		String useCountryIP = ezCommonService.getTenantConfig("useCountryIP", loginInfo.getTenantId());
		String useShowSystemCountry = ezCommonService.getTenantConfig("useShowSystemCountry", loginInfo.getTenantId());
		String useRDBOnlyMailList = ezCommonService.getTenantConfig("useRDBOnlyMailList", loginInfo.getTenantId());
		Message message = null;
		
		try {
			Map<String, String> mailInfo = null;
			boolean recipientHasAllRecipientTypes = false;
			
			if (useRDBOnlyMailList.equals("YES")) {
				mailInfo = ezEmailUtil.getMailInfo(userEmail, folderPath, uid);
				
				if (mailInfo == null) {
					logger.error("Message not found. uid=" + uid);
					model.addAttribute("title", egovMessageSource.getMessage("ezEmail.t565", locale));
					model.addAttribute("mainContent", egovMessageSource.getMessage("ezEmail.t99000081", locale));
					model.addAttribute("subContent", egovMessageSource.getMessage("ezEmail.t99000082", locale));
					return "ezCommon/error";
				}
				
				String recipientsStr = mailInfo.get("RECIPIENT");
				
				if (!recipientsStr.isEmpty()) {
					// To, Cc, Bcc를 분리한다.(||로 구분됨.)
					String[] recipientsArr = recipientsStr.split("\\|\\|", 3);		
					
					// 오래된 사이트(가온누리 포함)의 경우 오래된 메일의 RECIPIENT 필드값이 To, Cc, Bcc로 분리되어 있지 않은 경우가 있어
					// 추가함.
					if (recipientsArr.length > 1) {
						recipientHasAllRecipientTypes = true;
					}
				}				
			}

			Folder f = null;
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userEmail, password, egovMessageSource, locale, ezEmailUtil);
			
			if (ia != null) {
				f = ia.getFolder(folderPath != null ? folderPath : "");
				if (f == null || !f.exists()) {
					logger.error("Folder not found. folderPath=" + folderPath);
					model.addAttribute("title", egovMessageSource.getMessage("ezEmail.t565", locale));
					model.addAttribute("mainContent", egovMessageSource.getMessage("ezEmail.t99000081", locale));
					model.addAttribute("subContent", egovMessageSource.getMessage("ezEmail.t99000082", locale));
					return "ezCommon/error";
				} else {
					f.open(Folder.READ_WRITE);
					
					if (f.isOpen() && f instanceof IMAPFolder) {
						message = ((IMAPFolder)f).getMessageByUID(uid);
						if (message != null) {
							
							logger.debug("message=" + message);
		
							String[] messageIds = message.getHeader("Message-ID");

							if (messageIds != null) {
								logger.debug("Message-ID=" + messageIds[0]);

								int blockedMail = ezEmailService.checkBlockedMailByMessageId(messageIds[0]);

								if (blockedMail == 1) {
									return "ezEmail/blockedMail";
								}
							}
						}
					}
				}
			}
			
			if (useRDBOnlyMailList.equals("YES") && recipientHasAllRecipientTypes) {
				// From
				fromStr = ezEmailUtil.getNameOrAddress(mailInfo.get("SENDER"));
				fromEmail = ezEmailUtil.getAddress(mailInfo.get("SENDER"));
				
				logger.debug("From=" + fromStr);
				
				// 메일 보낸사람 국기 표시 
				if (useCountryIP.equals("YES")) {						
					String ctryCode = mailInfo.get("COUNTRY_CODE");
					String mailIp = mailInfo.get("MAIL_IP");
					String systemLang = loginInfo.getLang();
					
					if (mailIp != null && !mailIp.isEmpty()) {
						countryIP = mailIp;
					}
					
					if (ctryCode != null && !ctryCode.isEmpty()) {
						String systemCountryName = commonUtil.getTwoLetterLangFromLangNum(systemLang, "kr");
						Locale localeCountry = new Locale(systemCountryName, ctryCode);
						countryName = localeCountry.getDisplayCountry(localeCountry);
						countryName = countryName.replaceAll(" ", "");
						countryCode = ctryCode.toLowerCase();
					}
					
					logger.debug("countryName:" + countryName + ",ctryCode[0]:" + countryCode);
				} 
				
				// To, Cc, Bcc를 모두 포함한다.
				String recipientsStr = mailInfo.get("RECIPIENT");
				
				if (!recipientsStr.isEmpty()) {
					// To, Cc, Bcc를 분리한다.(||로 구분됨.)
					// sol0015@coupang.com <sol0015@coupang.com>; Judy Kh (Kyoung Hye Jang ) [PL Korea Sourcing] <khjang@coupang.com>||정덕범 <james71d@sajo.co.kr>; 강수한 <a0142@sajo.co.kr>; 함지혜 <a3016n@sajo.co.kr>||
					String[] recipientsArr = recipientsStr.split("\\|\\|", 3);		
					
					if (!recipientsArr[0].isEmpty()) {
						// Undisclosed recipients:; <Undisclosed recipients:;>|||| 와 같은 경우가 있어
						// split delimiter를 기존 "; "에서 ">; "로 변경함.
						String[] strArr = recipientsArr[0].split(">; ");
						
						for (int i = 0; i < strArr.length; i++) {
							String item = strArr[i].trim();
							String[] tokens = item.split(" <");
							String name = tokens[0]; 		
							name = commonUtil.trimDoubleQuotes(name);								
							String address = ""; 
									
							if (tokens.length > 1) {
								address = tokens[1];
							}
							
							if (address.endsWith(">")) {
								address = address.substring(0, address.length() - 1);
							}
							
							logger.debug("TO=" + name + " " + address);
							
							if (i == 0) {
								if (strArr.length > 1) {
									toStr = getReceiverHTML(name, address, false) + "<span>&nbsp;(" + egovMessageSource.getMessage("ezEmail.t10000", locale) +"&nbsp;"+ strArr.length +"&nbsp;"+ egovMessageSource.getMessage("ezEmail.t10001", locale) + ")&nbsp;<img src='/images/expnd.gif'  style='cursor:pointer;' onclick='ShowHiddenTo(this);' align='absmiddle'></span>";
								} else {
									toStr = getReceiverHTML(name, address, false);
								}
							}
							
							if (toHiddenStr == null) {
								toHiddenStr = getReceiverHTML(name, address, false);
							} else {
								toHiddenStr += " , " + getReceiverHTML(name, address, false);
							}								
						}							
					}	
					
					if (recipientsArr.length > 1 && !recipientsArr[1].isEmpty()) {
						String[] strArr = recipientsArr[1].split(">; ");
						
						for (int i = 0; i < strArr.length; i++) {
							String item = strArr[i].trim();
							String[] tokens = item.split(" <");
							String name = tokens[0]; 		
							name = commonUtil.trimDoubleQuotes(name);								
							String address = ""; 
							
							if (tokens.length > 1) {
								address = tokens[1];
							}
							
							if (address.endsWith(">")) {
								address = address.substring(0, address.length() - 1);
							}
							
							logger.debug("CC=" + name + " " + address);
							
							if (i == 0) {
								if (strArr.length > 1) {
									ccStr = getReceiverHTML(name, address, false) + "<span>&nbsp;(" + egovMessageSource.getMessage("ezEmail.t10000", locale) + strArr.length + egovMessageSource.getMessage("ezEmail.t10001", locale) + ")&nbsp;<img src='/images/expnd.gif'  style='cursor:pointer;' onclick='ShowHiddenCc(this);' align='absmiddle'></span>";
								} else {
									ccStr = getReceiverHTML(name, address, false);
								}
							}
							
							if (ccHiddenStr == null) {
								ccHiddenStr = getReceiverHTML(name, address, false);
							} else {
								ccHiddenStr += " , " + getReceiverHTML(name, address, false);
							}								
						}							
					}						

					if (recipientsArr.length > 2 && !recipientsArr[2].isEmpty()) {
						String[] strArr = recipientsArr[2].split(">; ");
						
						for (int i = 0; i < strArr.length; i++) {
							String item = strArr[i].trim();
							String[] tokens = item.split(" <");
							String name = tokens[0]; 		
							name = commonUtil.trimDoubleQuotes(name);								
							String address = ""; 
							
							if (tokens.length > 1) {
								address = tokens[1];
							}
							
							if (address.endsWith(">")) {
								address = address.substring(0, address.length() - 1);
							}
							
							logger.debug("BCC=" + name + " " + address);

							if (i != 0) {
								bccStr += ", ";
							}
							
							bccStr += getReceiverHTML(name, address, false);								
						}							
					}												
				}
									
				if (ccStr == null || ccStr.equals("")) {
					pIsCCFg = "N";
				}
				
				// received date
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
				date = sdf.parse(mailInfo.get("MAIL_DATE"));
				sdf.setTimeZone(TimeZone.getTimeZone("GMT"));
				String receivedDateStr = sdf.format(date);					
				dateStr = commonUtil.getDateStringInUTC(receivedDateStr, loginInfo.getOffset(), false);

				logger.debug("dateStr=" + dateStr);
				
				// subject
				subject = mailInfo.get("SUBJECT");
				
				if ((subject == null || subject.trim().equals("")) && !contentClass.equalsIgnoreCase("PREVIEW")) {
					subject = egovMessageSource.getMessage("ezEmail.kms03", locale);
				}
				
				subject = commonUtil.cleanValue(subject);
				
				if (contentClass.equalsIgnoreCase("PREVIEW") || contentClass.equalsIgnoreCase("PREVIEWSEND")) {
					title = egovMessageSource.getMessage("ezEmail.t487", locale) + " -" + subject;
				} else {
					title = egovMessageSource.getMessage("ezEmail.t565", locale) + subject;
				}
				
				logger.debug("subject=" + subject);
				
				if ("1".equals(mailInfo.get("MAIL_IS_SECURED"))) {
					isSecureMail = true;
				}
				
				if (folderPath.equals(ezEmailUtil.getSentFolderId(locale))) {
					isSentItems = true;
				}
				
				if (folderPath.equals(ezEmailUtil.getTrashFolderId(locale))) {
					isDelete = "BDELETE";
				}
				
				if (contentClass.equals("")) {
					if ("1".equals(mailInfo.get("MAIL_IS_ANSWERED"))) {
						contentClass = "REPLY";
					}
					else {
						boolean isForwarded = "1".equals(mailInfo.get("MAIL_IS_FORWARDED"));
						
						if (isForwarded) {
							contentClass = "FORWARD";
						}
						else {
							contentClass = "IPM.NOTE";
						}
					}
				}
				
				// 전달, 회신 시 보낸 시간
				if (contentClass.equals("REPLY") || contentClass.equals("FORWARD")) {
					/*
					if (ezEmailUtil.hasSentDateFlag(message)) {
						String sentDateFlag = ezEmailUtil.getSentDateFlag(message);
						sentDateFlag = sentDateFlag.split("-")[1];
						logger.debug("sentDateFlag=" + sentDateFlag);
						
						SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
						sdf.setTimeZone(TimeZone.getTimeZone("GMT"));
						String receivedDateStr = sdf.format(new Date(Long.parseLong(sentDateFlag)));
						String sentDate = commonUtil.getDateStringInUTC(receivedDateStr, loginInfo.getOffset(), false);
						logger.debug("receivedDateStr=" + receivedDateStr);
						
						String msg = contentClass.equals("REPLY") ? "ezEmail.ksa01" : "ezEmail.ksa02";
						String sentDateStr = egovMessageSource.getMessage(msg, locale);
						sentDateMsg = String.format(sentDateStr, sentDate);
						logger.debug("sentDateMsg=" + sentDateMsg);
					}
					*/
				} else if (contentClass.equalsIgnoreCase("PREVIEW")) {
					mailWritePreview = true;
					dateStr = "";
					logger.debug("mailWritePreview=" + mailWritePreview + ", dateStr=" + dateStr);
				} else if (contentClass.equalsIgnoreCase("PREVIEWSEND")) {
					mailWritePreviewSend = true;
					dateStr = "";
					logger.debug("mailWritePreviewSend=" + mailWritePreviewSend + ", dateStr=" + dateStr);
				}

				String tagsStr = commonUtil.cleanValue(mailInfo.get("TAGS"));
				if (StringUtils.isBlank(tagsStr)) {
					tags = new String[0];
				} else {
					tags = tagsStr.split("\\|");
				}

				mailBox = Optional.ofNullable(mailInfo.get("MAIL_ID"))
						.map(id -> id.split("/")[0])
						.orElse("");
				
			} else {
				if (ia != null){
					if (f == null || !f.exists()) {
						logger.error("Folder not found. folderPath=" + folderPath);
						model.addAttribute("title", egovMessageSource.getMessage("ezEmail.t565", locale));
						model.addAttribute("mainContent", egovMessageSource.getMessage("ezEmail.t99000081", locale));
						model.addAttribute("subContent", egovMessageSource.getMessage("ezEmail.t99000082", locale));
						return "ezCommon/error";
					} else {
						
						if (message == null) {
							logger.error("Message not found. uid=" + uid);
							model.addAttribute("title", egovMessageSource.getMessage("ezEmail.t565", locale));
							model.addAttribute("mainContent", egovMessageSource.getMessage("ezEmail.t99000081", locale));
							model.addAttribute("subContent", egovMessageSource.getMessage("ezEmail.t99000082", locale));
							return "ezCommon/error";
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

								if (fromStr.equals(fromEmail)) {
									List<String> mailAddrList = ezEmailUtil.mailAddrNameParse(fromStr, fromEmail);
									fromStr = mailAddrList.get(0);
									fromEmail = mailAddrList.get(1);
								}
							} else {
								String[] fromHeaders = message.getHeader("From");
								if (fromHeaders != null) {
									fromStr = MimeUtility.decodeText(message.getHeader("From")[0]);
								}
							}

							logger.debug("From=" + fromStr);

							// 메일 보낸사람 국기 표시
							if (useCountryIP.equals("YES")) {

								String[] ctryCode = message.getHeader("X-Jmocha-Country-Code");
								String[] mailIp = message.getHeader("X-Jmocha-IP");
								String systemLang = loginInfo.getLang();

								if (mailIp != null && !mailIp[0].equals("")) {
									countryIP = mailIp[0];
								}

								if (ctryCode != null && ctryCode[0] != null) {
									String systemCountryName = commonUtil.getTwoLetterLangFromLangNum(systemLang, "kr");
									Locale localeCountry = new Locale(systemCountryName, ctryCode[0]);
									countryName = localeCountry.getDisplayCountry(localeCountry);
									countryName = countryName.replaceAll(" ", "");
									countryCode = ctryCode[0].toLowerCase();
								}
								logger.debug("countryName:" + countryName + ",ctryCode[0]:" + countryCode );
							}

							// TO
							arrRecipientsTo = message.getRecipients(Message.RecipientType.TO);
							if(arrRecipientsTo != null){
							/* 받는 사람에 유저 이름이 있는지 확인하는 로직  -> 미리보기랑 맞추기 위해 주석처리
							boolean toListme = false;
							for(int i=0; i<arrRecipientsTo.length; i++){
								if(((InternetAddress)arrRecipientsTo[i]).getAddress().equals(userEmail)){
									toListme = true;
									break;
								}
							}*/

								String toHeader = message.getHeader("To")[0];
								boolean isAscii = ezEmailUtil.isPureAscii(toHeader);
								boolean addressFound = false;
								String name = null;
								String[] recipientHeaderArray = null;

								if (toHeader.contains("=?gb2312")) {
									toHeader = MimeUtility.unfold(toHeader);

									logger.debug("toHeader=" + toHeader);

									recipientHeaderArray = toHeader.split(",");

									for (int i = 0; i < recipientHeaderArray.length; i++) {
										recipientHeaderArray[i] = recipientHeaderArray[i].trim();
									}
								}

								for (int i = 0; i < arrRecipientsTo.length; i++) {
									name = ((InternetAddress)arrRecipientsTo[i]).getPersonal();
									addressFound = ((InternetAddress)arrRecipientsTo[i]).getAddress().contains("@");

									if (name == null && !addressFound) {
										logger.debug("no address found!");

										// To: $경영전략본부{하위포함}, $금융사업본부{하위포함} 와 같이 헤더 인코딩이 되지 않은 채로 한글로 수신자명이
										// 입력되고 메일주소가 없는 메일이 HUG(주택도시보증공사)에 수신되어 이 경우엔 header 값을 그대로 사용해 하단에서
										// Non-Ascii 디코딩을 시도하도록 함
										name = toHeader;
									}

									if (name == null) {
										name = ((InternetAddress)arrRecipientsTo[i]).getAddress();
									} else {
										if (!isAscii) {
											byte[] rawBytes = name.getBytes("iso-8859-1");

											name = ezEmailUtil.decodeNonAsciiBytes(rawBytes);
										} else {
											if (recipientHeaderArray != null) {
												String recipientHeader = recipientHeaderArray[i];

												// gb2312로 인코딩되어 있다고 기술되어 있지만 gbk에서
												// 정의되어 있는 글자가 포함되어 디코딩 시 깨지는 문제가 발생하여 gbk로 디코딩 처리하는 코드를 추가함.
												String newHeader = ezEmailUtil.changeCharSet(recipientHeader, "gb2312", "gbk");

												// gb2312에서 gbk로 변경된 경우
												if (!newHeader.equals(recipientHeader)) {
													int endPos = newHeader.indexOf("?=", 2);

													// 주소 부분을 제외한 이름 파트만 분리한다.
													if (endPos > -1) {
														name = newHeader.substring(0, endPos + 2);
													}
												}
											}

											name = MimeUtility.decodeText(name);
										}

										name = commonUtil.trimDoubleQuotes(name);
									}

									if (name != null) {
										// 료비에서 수신한 메일 중 \(backslash)" 가 문자열 내부에 포함되는 경우가 있어 추가함.
										// 예) =?iso-2022-jp?B?Im1hLXgtOTMyQGRvY29tby5uZS5qcCI=?=<ma-x-932@docomo.ne.jp>
										name = name.replace("\\\"", "");
									}

									logger.debug("TO=" + name + ((InternetAddress)arrRecipientsTo[i]).getAddress());

								/* 유저 본인의 이름을 맨앞으로 toStr에 넣는 로직 -> 미리보기랑 맞추기 위해 주석처리
								if(toListme){
									if(((InternetAddress)arrRecipientsTo[i]).getAddress().equals(userEmail)){
										if(arrRecipientsTo.length > 1){
											toStr = getReceiverHTML(name, ((InternetAddress)arrRecipientsTo[i]).getAddress(), false) + "<span>&nbsp;(" + egovMessageSource.getMessage("ezEmail.t10000", locale) + arrRecipientsTo.length + egovMessageSource.getMessage("ezEmail.t10001", locale) + ")&nbsp;<img src='/images/expnd.gif'  style='cursor:pointer;' onclick='ShowHiddenTo(this);' align='absmiddle'></span>";
										} else {
											toStr = getReceiverHTML(name, ((InternetAddress)arrRecipientsTo[i]).getAddress(), false);
										}
									}
									if(toHiddenStr == null){
										toHiddenStr = getReceiverHTML(name, ((InternetAddress)arrRecipientsTo[i]).getAddress(), false);
									} else{
										toHiddenStr += " , " + getReceiverHTML(name, ((InternetAddress)arrRecipientsTo[i]).getAddress(), false);
									}
								} else {*/
									if(i == 0){
										if(arrRecipientsTo.length > 1){
											toStr = getReceiverHTML(name, addressFound ? ((InternetAddress)arrRecipientsTo[i]).getAddress() : null , false) + "<span>&nbsp;(" + egovMessageSource.getMessage("ezEmail.t10000", locale) +"&nbsp;"+ arrRecipientsTo.length +"&nbsp;"+ egovMessageSource.getMessage("ezEmail.t10001", locale) + ")&nbsp;<img src='/images/expnd.gif'  style='cursor:pointer;' onclick='ShowHiddenTo(this);' align='absmiddle'></span>";
										} else {
											toStr = getReceiverHTML(name, addressFound ? ((InternetAddress)arrRecipientsTo[i]).getAddress() : null, false);
										}
									}
									if(toHiddenStr == null){
										toHiddenStr = getReceiverHTML(name, addressFound ? ((InternetAddress)arrRecipientsTo[i]).getAddress() : null, false);
									} else {
										toHiddenStr += " , " + getReceiverHTML(name, addressFound ? ((InternetAddress)arrRecipientsTo[i]).getAddress() : null, false);
									}
									//}
								}
							}

							// CC
							arrRecipientsCC = message.getRecipients(Message.RecipientType.CC);
							if(arrRecipientsCC != null){
							/* 참조에 유저 이름이 있는지 확인하는 로직  -> 미리보기랑 맞추기 위해 주석처리
							boolean ccListme = false;
							for(int i=0; i<arrRecipientsCC.length; i++){
								if(((InternetAddress)arrRecipientsCC[i]).getAddress().equals(userEmail)){
									ccListme = true;
									break;
								}
							}*/

								String ccHeader = message.getHeader("Cc")[0];
								boolean isAscii = ezEmailUtil.isPureAscii(ccHeader);
								boolean addressFound = false;
								String name = null;
								String[] recipientHeaderArray = null;

								if (ccHeader.contains("=?gb2312")) {
									ccHeader = MimeUtility.unfold(ccHeader);

									logger.debug("ccHeader=" + ccHeader);

									recipientHeaderArray = ccHeader.split(",");

									for (int i = 0; i < recipientHeaderArray.length; i++) {
										recipientHeaderArray[i] = recipientHeaderArray[i].trim();
									}
								}

								for (int i = 0; i < arrRecipientsCC.length; i++) {
									name = ((InternetAddress)arrRecipientsCC[i]).getPersonal();
									addressFound = ((InternetAddress)arrRecipientsCC[i]).getAddress().contains("@");

									if (name == null && !addressFound) {
										logger.debug("no address found!");

										// To: $경영전략본부{하위포함}, $금융사업본부{하위포함} 와 같이 헤더 인코딩이 되지 않은 채로 한글로 수신자명이
										// 입력되고 메일주소가 없는 메일이 HUG(주택도시보증공사)에 수신되어 이 경우엔 header 값을 그대로 사용해 하단에서
										// Non-Ascii 디코딩을 시도하도록 함
										name = ccHeader;
									}

									if (name == null) {
										name = ((InternetAddress)arrRecipientsCC[i]).getAddress();
									} else {
										if (!isAscii) {
											byte[] rawBytes = name.getBytes("iso-8859-1");

											name = ezEmailUtil.decodeNonAsciiBytes(rawBytes);
										} else {
											if (recipientHeaderArray != null) {
												String recipientHeader = recipientHeaderArray[i];

												// gb2312로 인코딩되어 있다고 기술되어 있지만 gbk에서
												// 정의되어 있는 글자가 포함되어 디코딩 시 깨지는 문제가 발생하여 gbk로 디코딩 처리하는 코드를 추가함.
												String newHeader = ezEmailUtil.changeCharSet(recipientHeader, "gb2312", "gbk");

												// gb2312에서 gbk로 변경된 경우
												if (!newHeader.equals(recipientHeader)) {
													int endPos = newHeader.indexOf("?=", 2);

													// 주소 부분을 제외한 이름 파트만 분리한다.
													if (endPos > -1) {
														name = newHeader.substring(0, endPos + 2);
													}
												}
											}

											name = MimeUtility.decodeText(name);
										}

										name = commonUtil.trimDoubleQuotes(name);
									}

									if (name != null) {
										// 료비에서 수신한 메일 중 \(backslash)" 가 문자열 내부에 포함되는 경우가 있어 추가함.
										// 예) =?iso-2022-jp?B?Im1hLXgtOTMyQGRvY29tby5uZS5qcCI=?=<ma-x-932@docomo.ne.jp>
										name = name.replace("\\\"", "");
									}

									logger.debug("CC=" + name + ((InternetAddress)arrRecipientsCC[i]).getAddress());

								/* 유저 본인의 이름을 맨앞으로 ccStr에 넣는 로직 -> 미리보기랑 맞추기 위해 주석처리
								if (ccListme) {
									if (((InternetAddress)arrRecipientsCC[i]).getAddress().equals(userEmail)) {
										if (arrRecipientsCC.length > 1) {
											ccStr = getReceiverHTML(name, ((InternetAddress)arrRecipientsCC[i]).getAddress(), false) + "<span>&nbsp;(" + egovMessageSource.getMessage("ezEmail.t10000", locale) + arrRecipientsCC.length + egovMessageSource.getMessage("ezEmail.t10001", locale) + ")&nbsp;<img src='/images/expnd.gif'  style='cursor:pointer;' onclick='ShowHiddenCc(this);' align='absmiddle'></span>";
										} else {
											ccStr = getReceiverHTML(name, ((InternetAddress)arrRecipientsCC[i]).getAddress(), false);
										}
									}
									if (ccHiddenStr == null) {
										ccHiddenStr = getReceiverHTML(name, ((InternetAddress)arrRecipientsCC[i]).getAddress(), false);
									} else {
										ccHiddenStr += " , " + getReceiverHTML(name, ((InternetAddress)arrRecipientsCC[i]).getAddress(), false);
									}
								} else { */
									if (i == 0) {
										if (arrRecipientsCC.length > 1) {
											ccStr = getReceiverHTML(name, addressFound ? ((InternetAddress)arrRecipientsCC[i]).getAddress() : null, false) + "<span>&nbsp;(" + egovMessageSource.getMessage("ezEmail.t10000", locale) + arrRecipientsCC.length + egovMessageSource.getMessage("ezEmail.t10001", locale) + ")&nbsp;<img src='/images/expnd.gif'  style='cursor:pointer;' onclick='ShowHiddenCc(this);' align='absmiddle'></span>";
										} else {
											ccStr = getReceiverHTML(name, addressFound ? ((InternetAddress)arrRecipientsCC[i]).getAddress() : null, false);
										}
									}
									if (ccHiddenStr == null) {
										ccHiddenStr = getReceiverHTML(name, addressFound ? ((InternetAddress)arrRecipientsCC[i]).getAddress() : null, false);
									} else {
										ccHiddenStr += " , " + getReceiverHTML(name, addressFound ? ((InternetAddress)arrRecipientsCC[i]).getAddress() : null, false);
									}
							//	}
							}
						}
		
						// BCC
						arrRecipientsBCC = message.getRecipients(Message.RecipientType.BCC);
						
						if (arrRecipientsBCC != null) {
							String name = null;
							
							for (int i = 0; i < arrRecipientsBCC.length; i++) {
								name = ((InternetAddress)arrRecipientsBCC[i]).getPersonal();
								
								if (name == null) {
									name = ((InternetAddress)arrRecipientsBCC[i]).getAddress();
								} else {
									name = MimeUtility.decodeText(name);
									name = commonUtil.trimDoubleQuotes(name);
								}
								
								if (name != null) {
									// 료비에서 수신한 메일 중 \(backslash)" 가 문자열 내부에 포함되는 경우가 있어 추가함.
									// 예) =?iso-2022-jp?B?Im1hLXgtOTMyQGRvY29tby5uZS5qcCI=?=<ma-x-932@docomo.ne.jp>
									name = name.replace("\\\"", "");
								}
								
								logger.debug("BCC=" + name + ((InternetAddress)arrRecipientsBCC[i]).getAddress());
								
								if (i != 0) {
									bccStr += ", ";
								}
								
								bccStr += getReceiverHTML(name, ((InternetAddress)arrRecipientsBCC[i]).getAddress(), false);
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
							
							dateStr = commonUtil.getDateStringInUTC(receivedDateStr, loginInfo.getOffset(), false);
						}
						logger.debug("dateStr=" + dateStr);
						
						// subject
						subject = ezEmailUtil.getSubject(message);
						if((subject == null || subject.trim().equals("")) && !contentClass.equalsIgnoreCase("PREVIEW")){
							subject = egovMessageSource.getMessage("ezEmail.kms03", locale);
						}
						
						subject = commonUtil.cleanValue(subject);
						if(contentClass.equalsIgnoreCase("PREVIEW") || contentClass.equalsIgnoreCase("PREVIEWSEND")){
							title = egovMessageSource.getMessage("ezEmail.t487", locale) + " -" + subject;
						} else {
							title = egovMessageSource.getMessage("ezEmail.t565", locale) + subject;
						}
						
						logger.debug("subject=" + subject);
						
						if (ezEmailUtil.hasSecureMailFlag(message)) {
							isSecureMail = true;
						}
						
						if (message.getFolder().getFullName().equals(ezEmailUtil.getSentFolderId(locale))) {
							isSentItems = true;
						}
						
						if (message.getFolder().getFullName().equals(ezEmailUtil.getTrashFolderId(locale))) {
							isDelete = "BDELETE";
						}
						
						if (!message.isSet(Flag.SEEN)) {
							pReadFlag = "N";
							message.setFlag(Flag.SEEN, true);
							logger.debug("Message's seen flag changed to true.");
						}
						
						mailBox = message.getFolder().getFullName();
					}
					
					if (contentClass.equals("")) {
						if (message.isSet(Flags.Flag.ANSWERED)) {
							contentClass = "REPLY";
						}
						else {
							boolean isForwarded = ezEmailUtil.hasForwardedFlag(message);
							
							if (isForwarded) {
								contentClass = "FORWARD";
							}
							else {
								contentClass = "IPM.NOTE";
							}
						}
					}
					
					// 전달, 회신 시 보낸 시간
					if (contentClass.equals("REPLY") || contentClass.equals("FORWARD")) {
						if (ezEmailUtil.hasSentDateFlag(message)) {
							String sentDateFlag = ezEmailUtil.getSentDateFlag(message);
							sentDateFlag = sentDateFlag.split("-")[1];
							logger.debug("sentDateFlag=" + sentDateFlag);
							
							SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
							sdf.setTimeZone(TimeZone.getTimeZone("GMT"));
							String receivedDateStr = sdf.format(new Date(Long.parseLong(sentDateFlag)));
							String sentDate = commonUtil.getDateStringInUTC(receivedDateStr, loginInfo.getOffset(), false);
							logger.debug("receivedDateStr=" + receivedDateStr);
							
							String msg = contentClass.equals("REPLY") ? "ezEmail.ksa01" : "ezEmail.ksa02";
							String sentDateStr = egovMessageSource.getMessage(msg, locale);
							sentDateMsg = String.format(sentDateStr, sentDate);
							logger.debug("sentDateMsg=" + sentDateMsg);
						}
					} else if (contentClass.equalsIgnoreCase("PREVIEW")) {
						mailWritePreview = true;
						dateStr = "";
						logger.debug("mailWritePreview=" + mailWritePreview + ", dateStr=" + dateStr);
					} else if (contentClass.equalsIgnoreCase("PREVIEWSEND")) {
						mailWritePreviewSend = true;
						dateStr = "";
						logger.debug("mailWritePreviewSend=" + mailWritePreview + ", dateStr=" + dateStr);
					}
					
					f.close(true);

						try {
							tags = ezEmailUtil.getTagList(userEmail, folderPath, uid);
						} catch (Exception e) {
							logger.error("get tag error:", e);
						}
					}
				}

			}
		} catch (MessagingException e) {
			logger.error(e.getMessage(), e);
		} finally {
			if (ia != null) {
				ia.close();
			}
		}
		
		String useReSend = ezCommonService.getTenantConfig("useReSend", loginInfo.getTenantId());
		String dotNetIntegration = ezCommonService.getTenantConfig("dotNetIntegration", loginInfo.getTenantId());
		String dotNetUrl = ezCommonService.getTenantConfig("dotNetUrl", loginInfo.getTenantId());
		
		/* 2020-08-31 홍승비 - 메일을 커뮤니티 게시판에 게시하는 기능의 사용여부 전달 */
		String useMailToCommunity = ezCommonService.getTenantConfig("useMailToCommunity", loginInfo.getTenantId());
		
		// 20200508 조진호 - 패키지 타입이 메일인 경우 메일 게시가 보이지 않도록 처리하기 위해 추가
		String packageType = commonUtil.getPackageType(loginInfo.getTenantId());
		model.addAttribute("packageType", packageType);
		
		model.addAttribute("fromStr", fromStr);
		model.addAttribute("fromEmail", fromEmail);
		model.addAttribute("url", url);
		model.addAttribute("toStr", toStr);
		model.addAttribute("toHiddenStr", toHiddenStr);
		model.addAttribute("ccStr", ccStr);
		model.addAttribute("ccHiddenStr", ccHiddenStr);
		model.addAttribute("bccStr", bccStr);
		model.addAttribute("dateStr", dateStr);
		model.addAttribute("subject", subject);
		model.addAttribute("title", title);
		model.addAttribute("folderPath", folderPath);
		model.addAttribute("uid", uid);
		model.addAttribute("pReadFlag", pReadFlag);
		model.addAttribute("isDelete", isDelete);
		model.addAttribute("isSentItems", isSentItems);
		model.addAttribute("isSecureMail", isSecureMail);
		model.addAttribute("pnFlag", pnFlag);
		model.addAttribute("pIsCCFg", pIsCCFg);
		model.addAttribute("dotNetIntegration", dotNetIntegration);
		model.addAttribute("dotNetUrl", dotNetUrl);
		model.addAttribute("useReSend", useReSend);
		model.addAttribute("sentDateMsg", sentDateMsg); // 전달, 회신 시 보낸 시간 
		model.addAttribute("mailWritePreview", mailWritePreview); // 메일작성 > 미리보기
		model.addAttribute("mailWritePreviewSend", mailWritePreviewSend); // 메일작성 > 미리보기
		model.addAttribute("useCabinet", use_cabinet); 
		model.addAttribute("countryName", countryName); 
		model.addAttribute("countryIP", countryIP); 
		model.addAttribute("countryCode", countryCode); 
		model.addAttribute("systemCountryCode", systemCountryCode.toLowerCase()); 
		model.addAttribute("useCountryIP", useCountryIP); 
		model.addAttribute("useShowSystemCountry", useShowSystemCountry); 
		model.addAttribute("useMailToCommunity", useMailToCommunity); 
		model.addAttribute("tags", tags);
		model.addAttribute("mailBox", mailBox);

		// 메일 태그를 사용중인지 확인 (미리보기 모드라면 무조건 false)
		boolean useMailTag = !(mailWritePreview || mailWritePreviewSend) && "YES".equalsIgnoreCase(ezCommonService.getTenantConfig("useMailTag", loginInfo.getTenantId()));

		// 메일 태그를 사용한다면 사용자가 기능을 활성화 했는지 확인
		if (useMailTag) {
			try {
				logger.debug("jgw getTagConfig started.");
				JgwResult jgwResult = rest.jgw().url("/jMochaEzEmail/getTagConfig").formParam("userAccount", userEmail).exchangeJgwResult();
				logger.debug("jgw getTagConfig ended, success={}", jgwResult.succeeded());

				useMailTag = jgwResult.succeeded() && jgwResult.getResultAsJsonObject().get("enable").getAsBoolean();
			} catch (RuntimeException e) {
				logger.error("jgw fetch error", e);
				useMailTag = false;
			} catch (Exception e) {
				logger.error("jgw fetch error", e);
				useMailTag = false;
			}
		}

		model.addAttribute("useMailTag", useMailTag);
		
		logger.debug("readMail ended.");
		
		return "ezEmail/mailRead";
	}
	
	/**
	 * 승인메일 읽기화면 호출 함수
	 */
	@RequestMapping(value = { "/ezEmail/mailApprRead.do" }, method = RequestMethod.GET)
	public String readApprMail(@CookieValue("loginCookie") String loginCookie, Locale locale, HttpServletRequest request, Model model) throws Exception {
		logger.debug("readApprMail started.");

		// get user credentials
		List<String> userInfo = commonUtil.getUserIdAndPassword(loginCookie);
		String password = userInfo.get(1);

		LoginVO loginInfo = commonUtil.userInfo(loginCookie);
		String shareId = Globals.APPR_MAIL_SHARED_ID;
		String domainName = ezCommonService.getTenantConfig("DomainName", loginInfo.getTenantId());
		String userEmail = shareId + "@" + domainName;
		logger.debug("readApprMail userId=" + loginInfo.getId() + ",userEmail=" + userEmail);

		// fixed param
		String pnFlag = "N";
		String contentClass = "IPM.Note";

		model.addAttribute("shareId", shareId);
		model.addAttribute("pnFlag", pnFlag);

		// decrypt
		String encryptedUrl = request.getParameter("URL");
		String url = egovFileScrty.decryptAES(encryptedUrl);
		logger.debug("readApprMail url=" + url);

		long uid = 0;
		String folderPath = null;
		if (url != null) {
			int index = url.lastIndexOf("/");

			// separate the passed-in url into a folder path and a message uid
			if (index != -1) {
				folderPath = url.substring(0, index);
				uid = Long.parseLong(url.substring(index + 1));
			}
		}

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
		String pIsCCFg = "Y";
		boolean isSecureMail = false;
		IMAPAccess ia = null;

		// 읽기 화면에서 리스트 출력 위한 데이터
		String useRDBOnlyMailList = ezCommonService.getTenantConfig("useRDBOnlyMailList", loginInfo.getTenantId());
		String senderProfileImageName = "";

		try {
			Map<String, String> mailInfo = null;
			boolean recipientHasAllRecipientTypes = false;

			if (useRDBOnlyMailList.equals("YES")) {
				mailInfo = ezEmailUtil.getMailInfo(userEmail, folderPath, uid);

				if (mailInfo == null) {
					logger.error("Message not found. uid=" + uid);
					model.addAttribute("title", egovMessageSource.getMessage("ezEmail.t565", locale));
					model.addAttribute("mainContent", egovMessageSource.getMessage("ezEmail.t99000081", locale));
					model.addAttribute("subContent", egovMessageSource.getMessage("ezEmail.t99000082", locale));
					return "ezCommon/error";
				}

				String recipientsStr = mailInfo.get("RECIPIENT");

				if (!recipientsStr.isEmpty()) {
					// To, Cc, Bcc를 분리한다.(||로 구분됨.)
					String[] recipientsArr = recipientsStr.split("\\|\\|", 3);

					// 오래된 사이트(가온누리 포함)의 경우 오래된 메일의 RECIPIENT 필드값이 To, Cc, Bcc로 분리되어 있지 않은 경우가 있어 추가함.
					if (recipientsArr.length > 1) {
						recipientHasAllRecipientTypes = true;
					}
				}
			}

			if (useRDBOnlyMailList.equals("YES") && recipientHasAllRecipientTypes) {
				// From
				fromStr = ezEmailUtil.getNameOrAddress(mailInfo.get("SENDER"));
				fromEmail = ezEmailUtil.getAddress(mailInfo.get("SENDER"));

				logger.debug("From=" + fromStr);

				String fromCn = fromEmail.split("@")[0];
				senderProfileImageName = ezOrganService.getPropertyValue(fromCn, "EXTENSIONATTRIBUTE2",	loginInfo.getTenantId());
				logger.debug("senderProfileImageName=" + senderProfileImageName);

				if (senderProfileImageName == null) {
					senderProfileImageName = "";
				}

				// To, Cc, Bcc를 모두 포함한다.
				String recipientsStr = mailInfo.get("RECIPIENT");

				if (!recipientsStr.isEmpty()) {
					// To, Cc, Bcc를 분리한다.(||로 구분됨.)
					// sol0015@coupang.com <sol0015@coupang.com>; Judy Kh (Kyoung Hye Jang ) [PL Korea Sourcing] <khjang@coupang.com>||정덕범 <james71d@sajo.co.kr>; 강수한 <a0142@sajo.co.kr>; 함지혜 <a3016n@sajo.co.kr>||
					String[] recipientsArr = recipientsStr.split("\\|\\|", 3);

					if (!recipientsArr[0].isEmpty()) {
						// Undisclosed recipients:; <Undisclosed recipients:;>|||| 와 같은 경우가 있어 split delimiter를 기존 "; "에서 ">; "로 변경함.
						String[] strArr = recipientsArr[0].split(">; ");
						List<InternetAddress> recipientToList = new ArrayList<>(strArr.length);
						model.addAttribute("recipientToList", recipientToList);

						for (int i = 0; i < strArr.length; i++) {
							String item = strArr[i].trim();
							String[] tokens = item.split(" <");
							String name = tokens[0];
							name = commonUtil.trimDoubleQuotes(name);
							String address = "";

							if (tokens.length > 1) {
								address = tokens[1];
							}

							if (address.endsWith(">")) {
								address = address.substring(0, address.length() - 1);
							}

							logger.debug("TO=" + name + " " + address);
							recipientToList.add(new InternetAddress(address, name));

							if (i == 0) {
								if (strArr.length > 1) {
									toStr = getReceiverHTML(name, address, false) + "<span>&nbsp;("
											+ egovMessageSource.getMessage("ezEmail.t10000", locale) + "&nbsp;"
											+ strArr.length + "&nbsp;"
											+ egovMessageSource.getMessage("ezEmail.t10001", locale)
											+ ")&nbsp;<img src='/images/expnd.gif'  style='cursor:pointer;' onclick='ShowHiddenTo(this);' align='absmiddle'></span>";
								} else {
									toStr = getReceiverHTML(name, address, false);
								}
							}

							if (toHiddenStr == null) {
								toHiddenStr = getReceiverHTML(name, address, false);
							} else {
								toHiddenStr += " , " + getReceiverHTML(name, address, false);
							}
						}
					}

					if (recipientsArr.length > 1 && !recipientsArr[1].isEmpty()) {
						String[] strArr = recipientsArr[1].split(">; ");
						List<InternetAddress> recipientCcList = new ArrayList<>(strArr.length);
						model.addAttribute("recipientCcList", recipientCcList);

						for (int i = 0; i < strArr.length; i++) {
							String item = strArr[i].trim();
							String[] tokens = item.split(" <");
							String name = tokens[0];
							name = commonUtil.trimDoubleQuotes(name);
							String address = "";

							if (tokens.length > 1) {
								address = tokens[1];
							}

							if (address.endsWith(">")) {
								address = address.substring(0, address.length() - 1);
							}

							logger.debug("CC=" + name + " " + address);
							recipientCcList.add(new InternetAddress(address, name));

							if (i == 0) {
								if (strArr.length > 1) {
									ccStr = getReceiverHTML(name, address, false) + "<span>&nbsp;("
											+ egovMessageSource.getMessage("ezEmail.t10000", locale) + strArr.length
											+ egovMessageSource.getMessage("ezEmail.t10001", locale)
											+ ")&nbsp;<img src='/images/expnd.gif'  style='cursor:pointer;' onclick='ShowHiddenCc(this);' align='absmiddle'></span>";
								} else {
									ccStr = getReceiverHTML(name, address, false);
								}
							}

							if (ccHiddenStr == null) {
								ccHiddenStr = getReceiverHTML(name, address, false);
							} else {
								ccHiddenStr += " , " + getReceiverHTML(name, address, false);
							}
						}
					}

					if (recipientsArr.length > 2 && !recipientsArr[2].isEmpty()) {
						String[] strArr = recipientsArr[2].split(">; ");
						List<InternetAddress> recipientBccList = new ArrayList<>(strArr.length);
						model.addAttribute("recipientBccList", recipientBccList);

						for (int i = 0; i < strArr.length; i++) {
							String item = strArr[i].trim();
							String[] tokens = item.split(" <");
							String name = tokens[0];
							name = commonUtil.trimDoubleQuotes(name);
							String address = "";

							if (tokens.length > 1) {
								address = tokens[1];
							}

							if (address.endsWith(">")) {
								address = address.substring(0, address.length() - 1);
							}

							logger.debug("BCC=" + name + " " + address);
							recipientBccList.add(new InternetAddress(address, name));

							if (i != 0) {
								bccStr += ", ";
							}

							bccStr += getReceiverHTML(name, address, false);
						}
					}
				}

				if (ccStr == null || ccStr.equals("")) {
					pIsCCFg = "N";
				}

				// received date
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
				date = sdf.parse(mailInfo.get("MAIL_DATE"));
				sdf.setTimeZone(TimeZone.getTimeZone("GMT"));
				String receivedDateStr = sdf.format(date);
				dateStr = commonUtil.getDateStringInUTC(receivedDateStr, loginInfo.getOffset(), false);

				logger.debug("dateStr=" + dateStr);

				// subject
				subject = mailInfo.get("SUBJECT");

				if ((subject == null || subject.trim().equals("")) && !contentClass.equalsIgnoreCase("PREVIEW")) {
					subject = egovMessageSource.getMessage("ezEmail.kms03", locale);
				}

				subject = commonUtil.cleanValue(subject);

				if (contentClass.equalsIgnoreCase("PREVIEW")) {
					title = egovMessageSource.getMessage("ezEmail.t487", locale) + " -" + subject;
				} else {
					title = egovMessageSource.getMessage("ezEmail.t565", locale) + subject;
				}

				logger.debug("subject=" + subject);

				if ("1".equals(mailInfo.get("MAIL_IS_SECURED"))) {
					isSecureMail = true;
				}

			} else {
				ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"),
						config.getProperty("config.IMAPPort"), userEmail, password, egovMessageSource, locale,
						ezEmailUtil);
				Folder f = ia.getFolder(folderPath);

				if (f == null || !f.exists()) {
					logger.error("Folder not found. folderPath=" + folderPath);
					model.addAttribute("title", egovMessageSource.getMessage("ezEmail.t565", locale));
					model.addAttribute("mainContent", egovMessageSource.getMessage("ezEmail.t99000081", locale));
					model.addAttribute("subContent", egovMessageSource.getMessage("ezEmail.t99000082", locale));
					return "ezCommon/error";
				} else {
					f.open(Folder.READ_WRITE);

					Message message = null;
					if (f.isOpen() && f instanceof IMAPFolder) {
						message = ((IMAPFolder) f).getMessageByUID(uid);
					}

					if (message == null) {
						logger.error("Message not found. uid=" + uid);
						model.addAttribute("title", egovMessageSource.getMessage("ezEmail.t565", locale));
						model.addAttribute("mainContent", egovMessageSource.getMessage("ezEmail.t99000081", locale));
						model.addAttribute("subContent", egovMessageSource.getMessage("ezEmail.t99000082", locale));
						return "ezCommon/error";
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

						Message[] fetchMessages = new Message[] { message };
						f.fetch(fetchMessages, fp);

						// From
						arrFroms = message.getFrom();

						if (arrFroms != null) {
							fromStr = ezEmailUtil.getFromNameOrAddressOfMessage(message);
							fromStr = commonUtil.trimDoubleQuotes(fromStr);

							fromEmail = ((InternetAddress) arrFroms[0]).getAddress();

							if (fromStr.equals(fromEmail)) {
								List<String> mailAddrList = ezEmailUtil.mailAddrNameParse(fromStr, fromEmail);
								fromStr = mailAddrList.get(0);
								fromEmail = mailAddrList.get(1);
							}
						} else {
							String[] fromHeaders = message.getHeader("From");
							if (fromHeaders != null) {
								fromStr = MimeUtility.decodeText(message.getHeader("From")[0]);
							}
						}

						logger.debug("From=" + fromStr);

						// TO
						arrRecipientsTo = message.getRecipients(Message.RecipientType.TO);
						if (arrRecipientsTo != null) {

							String toHeader = message.getHeader("To")[0];
							boolean isAscii = ezEmailUtil.isPureAscii(toHeader);
							boolean addressFound = false;
							String name = null;
							String[] recipientHeaderArray = null;

							if (toHeader.contains("=?gb2312")) {
								toHeader = MimeUtility.unfold(toHeader);

								logger.debug("toHeader=" + toHeader);

								recipientHeaderArray = toHeader.split(",");

								for (int i = 0; i < recipientHeaderArray.length; i++) {
									recipientHeaderArray[i] = recipientHeaderArray[i].trim();
								}
							}

							for (int i = 0; i < arrRecipientsTo.length; i++) {
								name = ((InternetAddress) arrRecipientsTo[i]).getPersonal();
								addressFound = ((InternetAddress) arrRecipientsTo[i]).getAddress().contains("@");

								if (name == null && !addressFound) {
									logger.debug("no address found!");

									// To: $경영전략본부{하위포함}, $금융사업본부{하위포함} 와 같이 헤더 인코딩이 되지 않은 채로 한글로 수신자명이
									// 입력되고 메일주소가 없는 메일이 HUG(주택도시보증공사)에 수신되어 이 경우엔 header 값을 그대로 사용해 하단에서 Non-Ascii 디코딩을 시도하도록 함
									name = toHeader;
								}

								if (name == null) {
									name = ((InternetAddress) arrRecipientsTo[i]).getAddress();
								} else {
									if (!isAscii) {
										byte[] rawBytes = name.getBytes("iso-8859-1");

										name = ezEmailUtil.decodeNonAsciiBytes(rawBytes);
									} else {
										if (recipientHeaderArray != null) {
											String recipientHeader = recipientHeaderArray[i];

											// gb2312로 인코딩되어 있다고 기술되어 있지만 gbk에서 정의되어 있는 글자가 포함되어 디코딩 시 깨지는 문제가 발생하여 gbk로 디코딩 처리하는 코드를 추가함.
											String newHeader = ezEmailUtil.changeCharSet(recipientHeader, "gb2312",
													"gbk");

											// gb2312에서 gbk로 변경된 경우
											if (!newHeader.equals(recipientHeader)) {
												int endPos = newHeader.indexOf("?=", 2);

												// 주소 부분을 제외한 이름 파트만 분리한다.
												if (endPos > -1) {
													name = newHeader.substring(0, endPos + 2);
												}
											}
										}

										name = MimeUtility.decodeText(name);
									}

									name = commonUtil.trimDoubleQuotes(name);
								}

								if (name != null) {
									// 료비에서 수신한 메일 중 \(backslash)" 가 문자열 내부에 포함되는 경우가 있어 추가함.
									// 예) =?iso-2022-jp?B?Im1hLXgtOTMyQGRvY29tby5uZS5qcCI=?=<ma-x-932@docomo.ne.jp>
									name = name.replace("\\\"", "");
								}

								logger.debug("TO=" + name + ((InternetAddress) arrRecipientsTo[i]).getAddress());

								if (i == 0) {
									if (arrRecipientsTo.length > 1) {
										toStr = getReceiverHTML(name,
												addressFound ? ((InternetAddress) arrRecipientsTo[i]).getAddress() : null, false) + "<span>&nbsp;("
												+ egovMessageSource.getMessage("ezEmail.t10000", locale) + "&nbsp;"
												+ arrRecipientsTo.length + "&nbsp;"
												+ egovMessageSource.getMessage("ezEmail.t10001", locale)
												+ ")&nbsp;<img src='/images/expnd.gif'  style='cursor:pointer;' onclick='ShowHiddenTo(this);' align='absmiddle'></span>";
									} else {
										toStr = getReceiverHTML(name,
												addressFound ? ((InternetAddress) arrRecipientsTo[i]).getAddress() : null, false);
									}
								}
								if (toHiddenStr == null) {
									toHiddenStr = getReceiverHTML(name, addressFound ? ((InternetAddress) arrRecipientsTo[i]).getAddress() : null, false);
								} else {
									toHiddenStr += " , " + getReceiverHTML(name, addressFound ? ((InternetAddress) arrRecipientsTo[i]).getAddress() : null,	false);
								}
							}
						}

						// CC
						arrRecipientsCC = message.getRecipients(Message.RecipientType.CC);
						if (arrRecipientsCC != null) {

							String ccHeader = message.getHeader("Cc")[0];
							boolean isAscii = ezEmailUtil.isPureAscii(ccHeader);
							boolean addressFound = false;
							String name = null;
							String[] recipientHeaderArray = null;

							if (ccHeader.contains("=?gb2312")) {
								ccHeader = MimeUtility.unfold(ccHeader);

								logger.debug("ccHeader=" + ccHeader);

								recipientHeaderArray = ccHeader.split(",");

								for (int i = 0; i < recipientHeaderArray.length; i++) {
									recipientHeaderArray[i] = recipientHeaderArray[i].trim();
								}
							}

							for (int i = 0; i < arrRecipientsCC.length; i++) {
								name = ((InternetAddress) arrRecipientsCC[i]).getPersonal();
								addressFound = ((InternetAddress) arrRecipientsCC[i]).getAddress().contains("@");

								if (name == null && !addressFound) {
									logger.debug("no address found!");

									// To: $경영전략본부{하위포함}, $금융사업본부{하위포함} 와 같이 헤더 인코딩이 되지 않은 채로 한글로 수신자명이
									// 입력되고 메일주소가 없는 메일이 HUG(주택도시보증공사)에 수신되어 이 경우엔 header 값을 그대로 사용해 하단에서 Non-Ascii 디코딩을 시도하도록 함
									name = ccHeader;
								}

								if (name == null) {
									name = ((InternetAddress) arrRecipientsCC[i]).getAddress();
								} else {
									if (!isAscii) {
										byte[] rawBytes = name.getBytes("iso-8859-1");

										name = ezEmailUtil.decodeNonAsciiBytes(rawBytes);
									} else {
										if (recipientHeaderArray != null) {
											String recipientHeader = recipientHeaderArray[i];

											// gb2312로 인코딩되어 있다고 기술되어 있지만 gbk에서
											// 정의되어 있는 글자가 포함되어 디코딩 시 깨지는 문제가 발생하여 gbk로 디코딩 처리하는 코드를 추가함.
											String newHeader = ezEmailUtil.changeCharSet(recipientHeader, "gb2312",	"gbk");

											// gb2312에서 gbk로 변경된 경우
											if (!newHeader.equals(recipientHeader)) {
												int endPos = newHeader.indexOf("?=", 2);
												// 주소 부분을 제외한 이름 파트만 분리한다.
												if (endPos > -1) {
													name = newHeader.substring(0, endPos + 2);
												}
											}
										}

										name = MimeUtility.decodeText(name);
									}

									name = commonUtil.trimDoubleQuotes(name);
								}

								if (name != null) {
									// 료비에서 수신한 메일 중 \(backslash)" 가 문자열 내부에 포함되는 경우가 있어 추가함.
									// 예) =?iso-2022-jp?B?Im1hLXgtOTMyQGRvY29tby5uZS5qcCI=?=<ma-x-932@docomo.ne.jp>
									name = name.replace("\\\"", "");
								}

								logger.debug("CC=" + name + ((InternetAddress) arrRecipientsCC[i]).getAddress());

								if (i == 0) {
									if (arrRecipientsCC.length > 1) {
										ccStr = getReceiverHTML(name,
												addressFound ? ((InternetAddress) arrRecipientsCC[i]).getAddress()
														: null,
												false) + "<span>&nbsp;("
												+ egovMessageSource.getMessage("ezEmail.t10000", locale)
												+ arrRecipientsCC.length
												+ egovMessageSource.getMessage("ezEmail.t10001", locale)
												+ ")&nbsp;<img src='/images/expnd.gif'  style='cursor:pointer;' onclick='ShowHiddenCc(this);' align='absmiddle'></span>";
									} else {
										ccStr = getReceiverHTML(name,
												addressFound ? ((InternetAddress) arrRecipientsCC[i]).getAddress() : null, false);
									}
								}
								if (ccHiddenStr == null) {
									ccHiddenStr = getReceiverHTML(name, addressFound ? ((InternetAddress) arrRecipientsCC[i]).getAddress() : null, false);
								} else {
									ccHiddenStr += " , " + getReceiverHTML(name, addressFound ? ((InternetAddress) arrRecipientsCC[i]).getAddress() : null, false);
								}
							}
						}

						// BCC
						arrRecipientsBCC = message.getRecipients(Message.RecipientType.BCC);

						if (arrRecipientsBCC != null) {
							String name = null;

							for (int i = 0; i < arrRecipientsBCC.length; i++) {
								name = ((InternetAddress) arrRecipientsBCC[i]).getPersonal();

								if (name == null) {
									name = ((InternetAddress) arrRecipientsBCC[i]).getAddress();
								} else {
									name = MimeUtility.decodeText(name);
									name = commonUtil.trimDoubleQuotes(name);
								}

								if (name != null) {
									// 료비에서 수신한 메일 중 \(backslash)" 가 문자열 내부에 포함되는 경우가 있어 추가함.
									// 예) =?iso-2022-jp?B?Im1hLXgtOTMyQGRvY29tby5uZS5qcCI=?=<ma-x-932@docomo.ne.jp>
									name = name.replace("\\\"", "");
								}

								logger.debug("BCC=" + name + ((InternetAddress) arrRecipientsBCC[i]).getAddress());

								if (i != 0) {
									bccStr += ", ";
								}

								bccStr += getReceiverHTML(name, ((InternetAddress) arrRecipientsBCC[i]).getAddress(), false);
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

							dateStr = commonUtil.getDateStringInUTC(receivedDateStr, loginInfo.getOffset(), false);
						}

						logger.debug("dateStr=" + dateStr);

						// subject
						subject = ezEmailUtil.getSubject(message);
						if ((subject == null || subject.trim().equals(""))) {
							subject = egovMessageSource.getMessage("ezEmail.kms03", locale);
						}

						subject = commonUtil.cleanValue(subject);
						title = egovMessageSource.getMessage("ezEmail.t565", locale) + subject;

						logger.debug("subject=" + subject);

						if (ezEmailUtil.hasSecureMailFlag(message)) {
							isSecureMail = true;
						}
					}

					f.close(true);

					try {
						JgwResult tagResult = rest.jgw().url("/jMochaEzEmail/getTagList")
								.formParam("userAccount", userEmail).formParam("folderPath", folderPath)
								.formParam("mailUid", uid).exchangeJgwResult();
						logger.debug("jgw getTagList result: {}", tagResult);
					} catch (Exception e) {
						logger.error("get tag error:", e);
					}
				}
			}
		} catch (MessagingException e) {
			logger.error(e.getMessage(), e);
		} finally {
			if (ia != null) {
				ia.close();
			}
		}

		String dotNetIntegration = ezCommonService.getTenantConfig("dotNetIntegration", loginInfo.getTenantId());
		String dotNetUrl = ezCommonService.getTenantConfig("dotNetUrl", loginInfo.getTenantId());

		model.addAttribute("senderProfileImageName", senderProfileImageName);
		model.addAttribute("fromStr", fromStr);
		model.addAttribute("fromEmail", fromEmail);
		model.addAttribute("url", url);
		model.addAttribute("toStr", toStr);
		model.addAttribute("toHiddenStr", toHiddenStr);
		model.addAttribute("ccStr", ccStr);
		model.addAttribute("ccHiddenStr", ccHiddenStr);
		model.addAttribute("bccStr", bccStr);
		model.addAttribute("dateStr", dateStr);
		model.addAttribute("subject", subject);
		model.addAttribute("title", title);
		model.addAttribute("folderPath", folderPath);
		model.addAttribute("uid", uid);
		model.addAttribute("isSecureMail", isSecureMail);
		model.addAttribute("pIsCCFg", pIsCCFg);
		model.addAttribute("dotNetIntegration", dotNetIntegration);
		model.addAttribute("dotNetUrl", dotNetUrl);
		logger.debug("readMail ended.");

		return "ezEmail/mailApprRead";
	}
	
	/**
	 * 메일 본문 내용 화면 정보 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailReadContent.do", method=RequestMethod.POST)
	public String readMailContent(@CookieValue("loginCookie") String loginCookie, Locale locale, HttpServletRequest request, Model model) throws Exception {
		logger.debug("readMailContent started.");
		
		String rejectKeyWord = "";
		
		// get user credentials
		List<String> userCookieInfo = commonUtil.getUserIdAndPassword(loginCookie);
		String password = userCookieInfo.get(1);
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
		String userEmail = userInfo.getId() + "@" + domainName;
		String mailId = userInfo.getId();
		Map<String, Object> extraMap = new HashMap<String, Object>();
		String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", userInfo.getTenantId());
		String useImageConvertServer = ezCommonService.getTenantConfig("useImageConvertServer", userInfo.getTenantId());
		String useRDBOnlyMailList = ezCommonService.getTenantConfig("useRDBOnlyMailList", userInfo.getTenantId());		
		String useWebfolder = ezCommonService.getTenantConfig("useWebfolder", userInfo.getTenantId());
		String shareId = StringUtils.defaultString(request.getParameter("shareId"), "");
		
		// 20200311 조진호 - 메일 읽기 > 첨부 파일 미리보기 활성화 여부 확인
		if (!useImageConvertServer.equalsIgnoreCase("0")) {
			extraMap.put("useImageConvertServer", useImageConvertServer);
		}
		
		// 20230418 김은실 - 메일 읽기 > 첨부파일 웹폴더에 저장 기능 추가
		if ("YES".equalsIgnoreCase(useWebfolder)) {
			extraMap.put("useWebfolder", true);
		}

		if (useSharedMailbox.equals("YES") && !Globals.APPR_MAIL_SHARED_ID.equalsIgnoreCase(shareId)) {
			//String shareId = request.getParameter("shareId");
			logger.debug("shareId=" + shareId);
			
			if (StringUtils.isNotBlank(shareId)) {
				if (!ezEmailService.checkUserShareId(userInfo.getId(), shareId, userInfo.getTenantId())) {
					model.addAttribute("mainContent", egovMessageSource.getMessage("ezEmail.lhm81", locale));
					
					logger.debug("the user cannot access the shareId.");
					logger.debug("readMailContent ended.");
					
					return "ezCommon/error";
				}
				
				userEmail = shareId + "@" + domainName;
				mailId = shareId;
				extraMap.put("shareId", shareId);
				
				MailSharedMailboxUserVO shareVO = ezEmailService.getSharedMailboxPermissionInfo(shareId, userInfo.getTenantId(), userInfo.getId());
				
				model.addAttribute("shareId", shareId);
				model.addAttribute("deletePermission", shareVO.getDeletePermission());
				model.addAttribute("sendPermission", shareVO.getSendPermission());
			}
		}
		
		if (StringUtils.isNotBlank(shareId) && Globals.APPR_MAIL_SHARED_ID.equalsIgnoreCase(shareId)) {
			userEmail = shareId + "@" + domainName;
			mailId = shareId;
			extraMap.put("shareId", shareId);

			model.addAttribute("shareId", shareId);
		}
		
		logger.debug("userId=" + userInfo.getId() + ",userEmail=" + userEmail);
		
		// retrieve the passed in parameters
		long uid = Long.parseLong(request.getParameter("iptURL"));
		String folderPath = request.getParameter("iptFolderPath");
		String url = folderPath + "/" + request.getParameter("iptURL");
		logger.debug("url=" + url);
		
		IMAPAccess ia = null;
		List<String> bodyInfoList = null;
		String pAttachListHtmlSub = null;
		String pReadFlag = "Y";
		String sentDateMsg = ""; // 전달, 회신 시 보낸 시간		
        boolean retryFlag = false;
        int retryCount = 1; // 메일 읽기 실패 시 재시도 횟수        
        
        do {		
    		try {
    			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
    					userEmail, password, egovMessageSource, locale, ezEmailUtil);
    			
                if (retryFlag) {
                    retryFlag = false;
                }

    			if (ia != null){
					Folder f = ia.getFolder(folderPath != null ? folderPath : "");

					if (f == null || !f.exists()) {
						logger.error("Folder not found. folderPath=" + folderPath);
					} else {
						f.open(Folder.READ_ONLY);
						Message message = null;

						if (f.isOpen() && f instanceof IMAPFolder) {
							message = ((IMAPFolder)f).getMessageByUID(uid);
						}

						if (message == null) {
							logger.error("Message not found. uid=" + uid);
						} else {
							if (useRDBOnlyMailList.equals("YES")) {
								if (!message.isSet(Flag.SEEN)) {
									pReadFlag = "N";
									message.setFlag(Flag.SEEN, true);

									logger.debug("Message's seen flag changed to true.");
								}
							}

							bodyInfoList = ezEmailUtil.getBodyInfo(message, folderPath, uid, -1, null, locale, extraMap);
							double size = Double.parseDouble(bodyInfoList.get(2));
							String strSize = ezEmailUtil.getSizeWithUnit(size);
							pAttachListHtmlSub = " - <b>" + bodyInfoList.get(3) + egovMessageSource.getMessage("ezEmail.t180", locale) + "</b>(" + strSize + ")";

							if (!folderPath.equals(ezEmailUtil.getSentFolderId(locale))) {
								String[] messageIds = message.getHeader("Message-ID");

								if (messageIds != null) {
									logger.debug("Message-ID=" + messageIds[0]);
								} else {
									logger.debug("No Message-ID");
								}

								// send an MDN to the sender.
								if (!ezEmailUtil.hasMDNSentFlag(message)) {
									logger.debug("MDNSentFlag isn't set.");

									// retrieve user info from db.
									OrganUserVO userVO = ezOrganAdminService.getUserInfo(mailId, userInfo.getPrimary(), userInfo.getTenantId());

									SMTPAccess sa = SMTPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.SMTPPort"),
											userEmail, password);

									processAutoMDN(sa, message, userVO.getMail(), userVO.getDisplayName(), userInfo.getTenantId());
								}
								else {
									logger.debug("MDNSentFlag is set");
								}
							}

							String contentClass = "";

							if (message.isSet(Flags.Flag.ANSWERED)) {
								contentClass = "REPLY";
							}
							else {
								boolean isForwarded = ezEmailUtil.hasForwardedFlag(message);

								if (isForwarded) {
									contentClass = "FORWARD";
								}
								else {
									contentClass = "IPM.NOTE";
								}
							}

							// 전달, 회신 시 보낸 시간
							if (contentClass.equals("REPLY") || contentClass.equals("FORWARD")) {
								if (ezEmailUtil.hasSentDateFlag(message)) {
									String sentDateFlag = ezEmailUtil.getSentDateFlag(message);
									sentDateFlag = sentDateFlag.split("-")[1];
									logger.debug("sentDateFlag=" + sentDateFlag);

									SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
									sdf.setTimeZone(TimeZone.getTimeZone("GMT"));
									String receivedDateStr = sdf.format(new Date(Long.parseLong(sentDateFlag)));
									String sentDate = commonUtil.getDateStringInUTC(receivedDateStr, userInfo.getOffset(), false);
									logger.debug("receivedDateStr=" + receivedDateStr);

									String msg = contentClass.equals("REPLY") ? "ezEmail.ksa01" : "ezEmail.ksa02";
									String sentDateStr = egovMessageSource.getMessage(msg, locale);
									sentDateMsg = String.format(sentDateStr, sentDate);
									logger.debug("sentDateMsg=" + sentDateMsg);
								}
							}
						}
					}
				}
    		} catch (MessagingException e) { 
    			logger.error(e.getMessage(), e);
    			
                retryFlag = true;
                --retryCount;
                
                if (retryCount > -1) {
                    logger.debug("Message read fail. Retry...");
                    
                    try {
                        Thread.sleep(1000);
                    } catch (IllegalArgumentException ex) {logger.debug("e.message=" + ex.getMessage());
					} catch (Exception ex) {logger.debug("e.message=" + ex.getMessage());}
                }      		
			} catch (Exception e) { 
    			logger.error(e.getMessage(), e);
    			
                retryFlag = true;
                --retryCount;
                
                if (retryCount > -1) {
                    logger.debug("Message read fail. Retry...");
                    
                    try {
                        Thread.sleep(1000);
                    } catch (IllegalArgumentException ex) {logger.debug("e.message=" + ex.getMessage());
					} catch (Exception ex) {logger.debug("e.message=" + ex.getMessage());}
                }                   			
    		} finally {
    			if (ia != null) {
    				ia.close();
    			}
    		}
        } while (retryFlag && retryCount > -1);		
		
		// 2023-05-16 이사라 : NullPointerException 시큐어코딩
		if (Objects.isNull(bodyInfoList)) {
			throw new NullPointerException("readMailContent bodyInfoList is null");
		}

        String htmlBody = bodyInfoList.get(0);
        Pattern p = Pattern.compile("<base\\s+.*?href.*?>", Pattern.CASE_INSENSITIVE | Pattern.DOTALL);
		Matcher m = p.matcher(htmlBody);
		htmlBody = m.replaceAll("");

		// 2018-08-03 황윤호 추가
        String memoFlag = "";
        if (ezCommonService.getTenantConfig("useMemo", userInfo.getTenantId()).equalsIgnoreCase("YES")) {
        	memoFlag = "YES";
        } else {
        	memoFlag = "NO";
        }
        
        // 20181219 김수아 : 첨부파일 이미지 미리보기 사용자 컨피그
        MailGeneralVO mailGeneralVO = ezEmailService.getMailGeneral(userInfo.getTenantId(), userInfo.getId()).get(0);
        String previewMailImage = mailGeneralVO.getPreviewMailImage() == null ? "Y" : mailGeneralVO.getPreviewMailImage();
		// AI 첨부파일 이름 최대 길이 - 기존 메일과 동일한 값 사용
		String attachFileNameMaxLength = ezCommonService.getTenantConfig("attachFileNameMaxLength", userInfo.getTenantId());
		// AI 사용여부 확인
		boolean useAI = aICommonUtil.checkUseAI(userInfo.getTenantId());
		// AI 챗봇 첨부파일 최대용량
		String aiAttachMBSize = "10";//ezCommonService.getTenantConfig("aiAttachMBSize", -99); // 모든 테넌트 공통 값

		model.addAttribute("useAI", useAI);
		model.addAttribute("attachFileNameMaxLength", attachFileNameMaxLength);
		model.addAttribute("aiAttachMBSize", aiAttachMBSize);
        
        model.addAttribute("htmlBody", htmlBody);
		model.addAttribute("pAttachListHtml", bodyInfoList.get(1));
		model.addAttribute("pAttachListHtmlSub", pAttachListHtmlSub);
		model.addAttribute("isAttach", bodyInfoList.get(4));
		model.addAttribute("url", url);
		model.addAttribute("rejectKeyWord", rejectKeyWord);
		
		/////////추가
		model.addAttribute("deptId", userInfo.getDeptID());
		model.addAttribute("Name", userInfo.getDisplayName());	
		model.addAttribute("Id", userInfo.getId());
		model.addAttribute("memoFlag", memoFlag);
		model.addAttribute("previewImageListHtml", bodyInfoList.get(5)); //이미지 미리보기 
		model.addAttribute("isIcalMail", bodyInfoList.get(6)); // "" or "Y"
		
		model.addAttribute("previewMailImage", previewMailImage);
		model.addAttribute("pReadFlag", pReadFlag);		
		model.addAttribute("sentDateMsg", sentDateMsg); // 전달, 회신 시 보낸 시간		
		
		logger.debug("readMailContent ended.");
		
		return "ezEmail/mailReadContent";
	}
	
	/**
	 * 메일 웹페이지로 보기 수행 함수
	 */
	@RequestMapping(value="/ezEmail/mailReadOriginal.do", method=RequestMethod.GET)
	public String readMailOriginal(@CookieValue("loginCookie") String loginCookie, Locale locale, HttpServletRequest request, Model model) throws Exception{
		logger.debug("readMailOriginal started.");
		
		// get user credentials
		List<String> userInfo = commonUtil.getUserIdAndPassword(loginCookie);
		String password = userInfo.get(1);
		
		LoginVO loginInfo = commonUtil.userInfo(loginCookie);
		String domainName = ezCommonService.getTenantConfig("DomainName", loginInfo.getTenantId());
		String userEmail = loginInfo.getId() + "@" + domainName;
		Map<String, Object> extraMap = new HashMap<String, Object>();
		String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", loginInfo.getTenantId());

		if (useSharedMailbox.equals("YES")) {
			String shareId = request.getParameter("shareId");
			logger.debug("shareId=" + shareId);
			
			if (shareId != null) {
				if (!ezEmailService.checkUserShareId(loginInfo.getId(), shareId, loginInfo.getTenantId())) {
					model.addAttribute("mainContent", egovMessageSource.getMessage("ezEmail.lhm81", locale));
					
					logger.debug("the user cannot access the shareId.");
					logger.debug("readMailOriginal ended.");
					
					return "ezCommon/error";
				}
				
				userEmail = shareId + "@" + domainName;
				model.addAttribute("shareId", shareId);
				extraMap.put("shareId", shareId);
			}
		}
		
		logger.debug("userId=" + loginInfo.getId() + ",userEmail=" + userEmail);
		
		// retrieve the passed in parameters
		String url = request.getParameter("url");
		logger.debug("url=" + url);
		long uid = 0;
		String folderPath = null;
		if (url != null) {
			int index = url.lastIndexOf("/");
			
			// separate the passed-in url into a folder path and a message uid
			if (index != -1) {
				folderPath = url.substring(0, index);
				uid = Long.parseLong(url.substring(index + 1));
			}
		}
		
		IMAPAccess ia = null;
		List<String> bodyInfoList = null;
		
		try {
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userEmail, password, egovMessageSource, locale, ezEmailUtil);
			if (ia != null){
				Folder f = ia.getFolder(folderPath != null ? folderPath : "");

				if (f == null || !f.exists()) {
					logger.error("Folder not found. folderPath=" + folderPath);
					throw new Exception("Folder not found. folderPath=" + folderPath);
			} else {
					f.open(Folder.READ_ONLY);
					Message message = null;

					if (f.isOpen() && f instanceof IMAPFolder){
						message = ((IMAPFolder)f).getMessageByUID(uid);
					}

					if (message == null) {
						logger.error("Message not found. uid=" + uid);
					} else {
						bodyInfoList = ezEmailUtil.getBodyInfo(message, folderPath, uid, -1, null, locale, extraMap);
					}
				}
			}

		} catch (MessagingException e) {
			logger.error(e.getMessage(), e);
		} finally {
			if (ia != null) {
				ia.close();
			}
		}
		
		if (bodyInfoList != null) {
			String htmlBody = bodyInfoList.get(0);
			model.addAttribute("htmlBody", htmlBody);
		}
		
		logger.debug("readMailOriginal ended.");
		
		return "ezEmail/mailReadOriginal";
	}
	
	/**
	 * 일반 첨부파일시 모두저장 클릭시 호출되는 메서드 (압축파일 내려받기) 
	 */
	@RequestMapping(value="/ezEmail/downloadAttachAll.do", method=RequestMethod.POST, produces="text/plain; charset=UTF-8")
	@ResponseBody
	public void downloadAttachAll(@CookieValue("loginCookie") String loginCookie, Locale locale, 
			HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("downloadAttachAll started.");
		
		// get user credentials
		List<String> userIdAndPassword = commonUtil.getUserIdAndPassword(loginCookie);
		String password = userIdAndPassword.get(1);
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
		String userEmail = userInfo.getId() + "@" + domainName;
		String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", userInfo.getTenantId());
		String shareId = StringUtils.defaultString(request.getParameter("shareId"), "");
		
		if (useSharedMailbox.equals("YES") && !Globals.APPR_MAIL_SHARED_ID.equalsIgnoreCase(shareId)) {
			//String shareId = request.getParameter("shareId");
			logger.debug("shareId=" + shareId);
			
			if (StringUtils.isNotBlank(shareId)) {
				if (!ezEmailService.checkUserShareId(userInfo.getId(), shareId, userInfo.getTenantId())) {
					logger.debug("the user cannot access the shareId.");
					logger.debug("downloadAttachAll ended.");
					
					return;
				}
				
				userEmail = shareId + "@" + domainName;
			}
		}
		
		// 승인메일
		if (StringUtils.isNotBlank(shareId) && Globals.APPR_MAIL_SHARED_ID.equalsIgnoreCase(shareId)) {
			userEmail = shareId + "@" + domainName;
		}
		
		logger.debug("userId=" + userInfo.getId() + ",userEmail=" + userEmail);
		
		// retrieve the passed in parameters
		String folderPath = URLDecoder.decode(request.getParameter("folderPath"), "utf-8");
		String strUid = URLDecoder.decode(request.getParameter("uid"), "utf-8");
		String params = request.getParameter("params");
		
		logger.debug("params=" + params);

		params = params != null ? params : "";
		String param[] = params.split("&");
		String filename[] = new String[param.length / 4];
		String strIndex[] = new String[param.length / 4];
		String strOrder[] = new String[param.length / 4];
		String strDepth[] = new String[param.length / 4];
		
		int j = 0, k = 0, l = 0, m = 0;

		for (int i = 0; i < param.length; i++) {
			if (param[i] != null){
				String tmpStr[] = param[i].split("=");

				if (i % 4 == 0) {
					filename[j] = URLDecoder.decode(tmpStr[1], "utf-8");
					j++;
				} else if (i % 4 == 1) {
					strIndex[k] = tmpStr[1];
					k++;
				} else if (i % 4 == 2) {
					strOrder[l] = tmpStr[1];
					l++;
				} else {
					strDepth[m] = tmpStr[1];
					m++;
				}
			}
		}
		
		long uid = strUid != null ? Long.parseLong(strUid) : 0;
		logger.debug("folderPath=" + folderPath + ",uid=" + uid);
		
		if (folderPath == null || strUid == null || filename == null || strIndex == null) {
			logger.debug("downloadAttachAll illegal arguments.");
			return;
		}
		
		Integer idx[] = new Integer[strIndex.length];
		
		for (int i = 0; i < strIndex.length; i++) {
			idx[i] = Integer.parseInt(strIndex[i]);
		}

		Integer order[] = new Integer[strOrder.length];
		
		for (int i = 0; i < strOrder.length; i++) {
			order[i] = Integer.parseInt(strOrder[i]);
		}

		Integer depth[] = new Integer[strDepth.length];
		
		for (int i = 0; i < strDepth.length; i++) {
			depth[i] = Integer.parseInt(strDepth[i]);
		}
		
		String realPath = commonUtil.getRealPath(request);
		String pDirPath = commonUtil.getUploadPath("upload_mail.ROOT", userInfo.getTenantId());
		pDirPath = realPath + pDirPath;
		String guid = UUID.randomUUID().toString();
		String tempFileUploadPath = pDirPath + commonUtil.separator + "tempFileUpload";
		String pDirTempPath = tempFileUploadPath + commonUtil.separator + guid;
		String charSet = "utf-8";
		String useEucKr = ezCommonService.getTenantConfig("UseMailZipEucKr", userInfo.getTenantId());
		
		if (useEucKr.equals("YES")) {
			charSet = "euc-kr";
		}
		
		logger.debug("use encoding charset=" + charSet); 
		
		IMAPAccess ia = null;
		ZipOutputStream zos = null;
		String downFileName = "";
		
		try {
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userEmail, password, egovMessageSource, locale, ezEmailUtil);
			
			File tempFile = new File(pDirTempPath + ".zip");
			
			if (tempFile.exists()) {
				tempFile.delete();
			}
			
			tempFile = new File(tempFileUploadPath);
			
			if (!tempFile.exists()) {
				tempFile.mkdirs();
			}
			
			zos = new ZipOutputStream(new FileOutputStream(pDirTempPath + ".zip"), Charset.forName(charSet));

			if (ia != null){
				Folder f = ia.getFolder(folderPath != null ? folderPath : "");

				if (f == null || !f.exists()) {
					logger.debug("folder not found. folderPath=" + folderPath);
					throw new Exception("folder not found. folderPath=" + folderPath);
			} else {

					f.open(Folder.READ_ONLY);
					Message message = null;

					if (f.isOpen() && f instanceof IMAPFolder) {
						message = ((IMAPFolder)f).getMessageByUID(uid);
					}

					if (message == null) {
						logger.debug("message not found. uid=" + uid);
					} else {

						downFileName = ezEmailUtil.saveFilenameForm(userInfo, locale, message) + ".zip";
						Part part = null;
						Map<String, Integer> fileNameMap = new HashMap<String, Integer>();

						if (idx.length == 0) {
							part = message;
						} else {

							for (int i = 0; i < idx.length; i++) {
								part = ezEmailUtil.getAttachPart(message, idx[i], order[i], depth[i]);

								if (part == null) {
									logger.debug("attachpart not found. AttachPartIndex=" + idx[i]);
								} else {
									InputStream input = null;

									try {
										filename[i] = MimeUtility.decodeText(filename[i]);
										filename[i] = filename[i].replaceAll("[\\\\/:*?\"<>|]", "_")
												.replaceAll("[\\t\\r\\n\\v\\f]", "");
										filename[i] = commonUtil.normalizeFileName(filename[i]);
										filename[i] = commonUtil.getUniqueFileName(filename[i], fileNameMap);
										logger.debug("filename=" + filename[i]);

										input = part.getInputStream();

										ZipEntry zipEntry = new ZipEntry(filename[i]);
										zos.putNextEntry(zipEntry);

										byte[] buffer = new byte[4096];
										int byteRead;

										while ((byteRead = input.read(buffer)) > 0) {
											zos.write(buffer, 0, byteRead);
										}

										zos.closeEntry();
									} catch (IOException e) {
										logger.error(e.getMessage(), e);
									} finally {
										if (input != null) {
											try {
												input.close();
											} catch (IOException e) {
												logger.debug("e.message=" + e.getMessage());
											} catch (Exception e) {
												logger.debug("e.message=" + e.getMessage());
											}
										}
									}
								}
							}
						}
					}
				}

				// 2023-05-16 이사라 : NullPointerException 시큐어코딩
				if (!Objects.isNull(f)) {
					f.close(true);
				}
			}
			
			zos.flush();
			zos.close();
			zos = null;

			File file = new File(pDirTempPath + ".zip");
			
			if (file.exists()) {
				downFile(request, response, pDirTempPath + ".zip", downFileName);
				file.delete();
			}

		} catch (MessagingException e) {
			File file = new File(pDirTempPath + ".zip");
			
			if (file.exists()) {
				file.delete();
			}
			
			logger.error(e.getMessage(), e);
		} catch (Exception e) {
			File file = new File(pDirTempPath + ".zip");
			
			if (file.exists()) {
				file.delete();
			}
			
			logger.error(e.getMessage(), e);
		} finally {
			if (ia != null) {
				ia.close();
			}
			
			if (zos != null) {
				try {
					zos.close();
				} catch (IOException e) {
					logger.error(e.getMessage(), e);
				} catch (Exception e) {
					logger.error(e.getMessage(), e);
				}
			}
		}
		
		logger.debug("downloadAttachAll ended.");
	}

	/**
	 * Part의 Content-Type을 지정된 Content-Type으로 변경한 Part를 반환한다.
	 * @param p
	 * @return
	 * @throws MessagingException
	 * @throws IOException
	 */
	public Part getBodyPartWithNewContentType(Part p, String newContentType) throws MessagingException, IOException {
		logger.debug("getBodyPartWithNewContentType started. newContentType={}", newContentType);
		
		MimeBodyPart newBodyPart = (MimeBodyPart)p;

		String[] contentTypeHeaders = p.getHeader("Content-Type");

		if (contentTypeHeaders != null && contentTypeHeaders.length > 0) {
			InternetHeaders newHeaders = new InternetHeaders();

			@SuppressWarnings("unchecked")
			Enumeration<Header> enumerator = p.getAllHeaders();

			// 해당 파트의 헤더들을 읽는다.
			while (enumerator.hasMoreElements()) {
				Header h = enumerator.nextElement();
				String hValue = h.getValue();

				if (h.getName().equalsIgnoreCase("Content-Type")) {
					hValue = newContentType;

					logger.debug("new Content-Type={}", hValue);
				}

				newHeaders.addHeader(h.getName(), hValue);
			}

			// 해당 파트의 body 데이터를 읽는다.
			byte[] bytes = IOUtils.toByteArray(newBodyPart.getRawInputStream());

			// 해당 파트의 헤더와 body 데이터를 동일하게 갖는 파트 객체를 생성한다.
			newBodyPart = new MimeBodyPart(newHeaders, bytes);
		}

		logger.debug("getBodyPartWithNewContentType ended.");
		
		return newBodyPart;
	}
	
	/**
	 * 메일 첨부파일 다운로드 실행 함수
	 */
	@RequestMapping(value="/ezEmail/downloadAttach.do", method=RequestMethod.GET)
	@ResponseBody
	public void downloadAttach(@CookieValue("loginCookie") String loginCookie, Locale locale, HttpServletRequest request, HttpServletResponse response) throws Exception{
		logger.debug("downloadAttach started.");
		
		// get user credentials
		List<String> userInfo = commonUtil.getUserIdAndPassword(loginCookie);
		String password  = userInfo.get(1);
		String readStatus = request.getParameter("readStatus");
		LoginVO loginInfo = commonUtil.userInfo(loginCookie);
		String domainName = ezCommonService.getTenantConfig("DomainName", loginInfo.getTenantId());
		String userEmail = loginInfo.getId() + "@" + domainName;
		String shareId = StringUtils.defaultString(request.getParameter("shareId"), "");
		
		String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", loginInfo.getTenantId());

		if (useSharedMailbox.equals("YES") && !Globals.APPR_MAIL_SHARED_ID.equalsIgnoreCase(shareId)) {
			//String shareId = request.getParameter("shareId");
			logger.debug("shareId=" + shareId);
			
			if (StringUtils.isNotBlank(shareId)) {
				if (!ezEmailService.checkUserShareId(loginInfo.getId(), shareId, loginInfo.getTenantId())) {
					logger.debug("the user cannot access the shareId.");
					logger.debug("downloadAttach ended.");
					
					return;
				}
				
				userEmail = shareId + "@" + domainName;
			}
		}
		
		// 승인메일
		if (StringUtils.isNotBlank(shareId) && Globals.APPR_MAIL_SHARED_ID.equalsIgnoreCase(shareId)) {
			userEmail = shareId + "@" + domainName;
		}
		
		logger.debug("userId=" + loginInfo.getId() + ",userEmail=" + userEmail);
		
		// retrieve the passed in parameters
		String folderPath = request.getParameter("folderPath");
		String strUid = request.getParameter("uid");
		long uid = strUid != null ? Long.parseLong(strUid) : 0;
		String filename = request.getParameter("filename");
		logger.debug("folderPath=" + folderPath + ",uid=" + uid + ",filename=" + filename);
		
		if (folderPath == null || strUid == null || filename == null) {
			logger.debug("downloadAttach illegal arguments.");
			return;
		}
		
		String strIndex = request.getParameter("index");
		int index = -1;
		
		if (strIndex != null) {
			index = Integer.parseInt(strIndex);
		}
		logger.debug("index=" + index);

		String strOrder = request.getParameter("order");
		int order = 0;
		
		if (strOrder != null) {
			order = Integer.parseInt(strOrder);
		}
		
		logger.debug("order=" + order);
		
		String strDepth = request.getParameter("depth");
		int depth = 0;
		
		if (strDepth != null) {
			depth = Integer.parseInt(strDepth);
		}
		
		logger.debug("depth=" + depth);
		
		IMAPAccess ia = null;
		try {
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userEmail, password, egovMessageSource, locale, ezEmailUtil);
	
			Folder f = ia.getFolder(folderPath);
			
			if (f == null || !f.exists()) {
				logger.error("Folder not found. folderPath=" + folderPath);
			} else {
				f.open(Folder.READ_ONLY);
				Message message = null;
				if(f.isOpen() && f instanceof IMAPFolder){
					message = ((IMAPFolder)f).getMessageByUID(uid);
				}
				
				if (message == null) {
					logger.error("Message not found. uid=" + uid);
				} else {
					Part part = null;
					
					if (index == -1) {
						part = message;
					}
					else {
						part = ezEmailUtil.getAttachPart(message, index, order, depth);
					}
					
					if (part == null) {
						logger.error("AttachPart not found. AttachPartIndex=" + index);
					} else {
						String partContentType = part.getContentType();
						
						// Chrome에서 message/rfc822 Type으로 내려 보내면
						// blocked a frame with origin from accessing a cross-origin frame
						// 오류가 발생해 추가함.
						if (partContentType.toLowerCase().startsWith("message/rfc822")) {
							partContentType = "application/octet-stream";
							
							String[] contentTransferEncodingHeader = part.getHeader("Content-Transfer-Encoding");
							
							if (contentTransferEncodingHeader != null && contentTransferEncodingHeader.length > 0) {
								String contentTransferEncoding = contentTransferEncodingHeader[0];

								logger.debug("contentTransferEncoding={}", contentTransferEncoding);
								
								// Content-Type이 message/rfc822이고 Content-Transfer-Encoding이 base64일 때
								// JavaMail API에서 자동으로 base64 디코딩을 하지 않고 다운로드되는 문제가 있어
								// Content-Type을 application/octet-stream으로 변경함. 변경하면 base64 디코딩이
								// 자동으로 수행됨.
								// ezEKP-docs/eml/base64로 인코딩된 eml 첨부파일.eml 참고
								if ("base64".equalsIgnoreCase(contentTransferEncoding)) {
									part = getBodyPartWithNewContentType(part, partContentType);
								}
							}
						}
						
						response.setContentType(partContentType);
						
						filename = CommonUtil.getEncodedFileNameForDownload(request.getHeader("User-Agent"), filename);						
						
						String nfcFilename = commonUtil.normalizeFileName(filename);

                        if ("Y".equals(readStatus)) {
                            response.addHeader("content-disposition", "inline; filename=\"" + nfcFilename + "\"");
                            logger.debug("content-disposition=" + "inline; filename=\"" + nfcFilename + "\"");
                        } else {
                            response.addHeader("content-disposition", "attachment; filename=\"" + nfcFilename + "\"");
                            logger.debug("content-disposition=" + "attachment; filename=\"" + nfcFilename + "\"");
                        }

                        InputStream input = null;
						OutputStream output = null;
						
						try {
							input = part.getInputStream();
							output = response.getOutputStream();
							
							byte[] buffer = new byte[4096];
							int byteRead;
							
							while ((byteRead = input.read(buffer)) != -1) {
								output.write(buffer, 0, byteRead);
							}
						} catch(IOException e) {
							logger.debug("e.message=" + e.getMessage());
						} finally {
							if (ia != null) {
								ia.close();
							}
							if (input != null) {
								try { input.close(); } catch (IOException e) {logger.debug("e.message=" + e.getMessage());}
							}
							if (output != null) {
								try { output.flush(); } catch (IOException e) {logger.debug("e.message=" + e.getMessage());}
								try { output.close(); } catch (IOException e) {logger.debug("e.message=" + e.getMessage());}
							}
						}
						
					}
				}
			}
		} catch (MessagingException e) {
			logger.error(e.getMessage(), e);
		} finally {
			if (ia != null) {
				ia.close();
			}
		}
		
		logger.debug("downloadAttach ended.");
	}
	
	/**
	 * 메일 대용량 첨부파일 다운로드 실행 함수
	 */
	@RequestMapping(value="/ezEmail/downloadAttachCommon.do", method=RequestMethod.GET, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public void downloadAttachCommon(HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("downloadAttachCommon started.");
		
		String fileId = request.getParameter("fileid") == null ? "" : request.getParameter("fileid");
		fileId = commonUtil.detectPathTraversal(fileId);		
		String fileDate = request.getParameter("filedate") == null ? "" : request.getParameter("filedate");
		fileDate = commonUtil.detectPathTraversal(fileDate);		
		String tenantIdStr = request.getParameter("tid");
		tenantIdStr = (tenantIdStr == null || tenantIdStr.trim().equals("")) ? "0" : tenantIdStr;
		tenantIdStr = commonUtil.detectPathTraversal(tenantIdStr);
		int tenantId = Integer.parseInt(tenantIdStr);
		//String serverLang = ezCommonService.getTenantConfig("PrimaryLang", tenantId);
		//Locale locale = new Locale(commonUtil.getTwoLetterLangFromLangNum(serverLang));

		// 2023-08-02 이사라 - 브라우저 언어로 메시지 표출을 위해 수정
		String acceptLanguage = request.getHeader("Accept-Language"); // ex) Accept-Language: en-US,en;q=0.9,ko;q=0.8,id;q=0.7
		String twoLetterLang = "";
		String lang = "";

		if (StringUtils.isNotBlank(acceptLanguage)) {
			twoLetterLang = acceptLanguage.substring(0, 2);
			lang = commonUtil.getLangNumFromTwoLetterLang(twoLetterLang, tenantId);
		}

		// 브라우저 언어가 표준지원 언어가 아닐 경우 시스템 언어로 설정
		if (StringUtils.isBlank(lang)) {
			lang = ezCommonService.getTenantConfig("PrimaryLang", tenantId);
		}

		Locale locale = new Locale(commonUtil.getTwoLetterLangFromLangNum(lang));

		String realPath = commonUtil.getRealPath(request);
		String pDirPath = realPath + commonUtil.getUploadPath("upload_mail.ROOT", tenantId);
		
		// 2018-10-08 분리된 대용량파일(largeFile) 폴더 사용 여부
		String useSeparatedLargeFileFolder = ezCommonService.getTenantConfig("useSeparatedLargeFileFolder", tenantId);
		
		if (useSeparatedLargeFileFolder.equals("YES")) {
			pDirPath += commonUtil.separator + "largeFile";
		}
		
		String realFilePath = pDirPath + commonUtil.separator + fileDate;
			
		try {
			// get fileId with extension
			fileId = fileId.substring(0, 36);
			File directory = new File(realFilePath);
			File[] files = directory.listFiles((FileFilter) new PrefixFileFilter(fileId));
			
			// 대용량 첨부파일의 기간이 만료되었을 경우
			if (files == null) {
				response.setContentType("text/plain; charset=utf-8");
				response.getWriter().print(egovMessageSource.getMessage("main.t4", locale));
				
				return;
			} else {
				//대용량 첨부파일 다운로드 횟수 제한 처리 2020-03-10 홍대표.
				String exceededFilelimit = ezEmailService.checkBigAttachDownloadCount(fileId, tenantId);
				if (exceededFilelimit != null) {
					response.setContentType("text/plain; charset=utf-8");
					response.getWriter().print(egovMessageSource.getMessageExtend("ezEmail.hdp05", new Object[] {exceededFilelimit}, locale));
					
					return;
				} else {
					ezEmailService.updateBigAttachDownloadCount(fileId, tenantId);
				}
			}
			
			for (int i = 0; i < files.length; i++) {
				if (!files[i].getName().endsWith("__.txt")) {
					fileId = files[i].getName();
					break;
				}
			}
			
			realFilePath = realFilePath + commonUtil.separator + fileId;
			logger.debug("realFilePath=" + realFilePath);
			
			// get original filename from text file
			String fileName = "";
			File originalNameFile = new File(realFilePath + "__.txt");
			
			if (!originalNameFile.exists()) {
				logger.error("originalNameFile not found. filePath=" + realFilePath + "__.txt");
			} else {
				InputStreamReader isr = null;
				try {
					isr = new InputStreamReader(new FileInputStream(originalNameFile));
				    int read = 0;
					while ((read = isr.read()) != -1) {
						fileName += (char)read;
					}
				} finally {
					if (isr != null) {
						isr.close();
					}
				}
			}
			
			if (fileName.equals("")) {
				fileName = fileId;
			}
			else {
				fileName = new String(Base64.decodeBase64(fileName), "UTF-8");
			}
			
			logger.debug("originalFileName=" + fileName);
		
			downFile(request, response, realFilePath, fileName);
		} catch (IOException e) {
			logger.error(e.getMessage(), e);
			
			response.setContentType("text/plain; charset=utf-8");
			response.getWriter().print(egovMessageSource.getMessage("ezEmail.lhm14", locale));
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			
			response.setContentType("text/plain; charset=utf-8");
			response.getWriter().print(egovMessageSource.getMessage("ezEmail.lhm14", locale));
		}
		
		logger.debug("downloadAttachCommon ended.");
	}
	
	/**
	 * 메일 인라인 이미지 읽어오기 실행 함수
	 */
	@RequestMapping(value="/ezEmail/downloadInline.do", method=RequestMethod.GET)
	@ResponseBody
	public void downloadInline(@CookieValue("loginCookie") String loginCookie, Locale locale, HttpServletRequest request, HttpServletResponse response) throws Exception{
		logger.debug("downloadInline started.");
		
		// get user credentials
		List<String> userInfo = commonUtil.getUserIdAndPassword(loginCookie);
		String password  = userInfo.get(1);
		
		LoginVO loginInfo = commonUtil.userInfo(loginCookie);
		String domainName = ezCommonService.getTenantConfig("DomainName", loginInfo.getTenantId());
		String userEmail = loginInfo.getId() + "@" + domainName;
		String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", loginInfo.getTenantId());
		String shareId = request.getParameter("shareId");
		boolean isApprMail = Globals.APPR_MAIL_SHARED_ID.equalsIgnoreCase(shareId);

		if (isApprMail || useSharedMailbox.equals("YES")) {
			//String shareId = request.getParameter("shareId");
			logger.debug("shareId=" + shareId);
			
			if (shareId != null) {
				if (isApprMail || ezEmailService.checkUserShareId(loginInfo.getId(), shareId, loginInfo.getTenantId())) {
					userEmail = shareId + "@" + domainName;
				} else {
					logger.debug("the user cannot access the shareId.");
					logger.debug("downloadInline ended.");
					
					return;
				}
			}
		}
		
		logger.debug("userId=" + loginInfo.getId() + ",userEmail=" + userEmail);
		
		// retrieve the passed in parameters
		String folderPath = request.getParameter("folderPath");
		String strUid = request.getParameter("uid");
		long uid = strUid != null ? Long.parseLong(strUid) : 0;
		String contentId = request.getParameter("contentId");
		
		if (contentId != null) {
			contentId = EgovStringUtil.getHtmlStrCnvr(contentId);
		}	
		
		logger.debug("folderPath=" + folderPath + ",uid=" + uid + ",contentId=" + contentId);
		
		IMAPAccess ia = null;
		try {
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userEmail, password, egovMessageSource, locale, ezEmailUtil);
	
			if (ia != null){
				Folder f = ia.getFolder(folderPath != null ? folderPath : "");
				if (f == null || !f.exists()) {
					logger.error("Folder not found. folderPath=" + folderPath);
				} else {
					f.open(Folder.READ_ONLY);
					Message message = null;
					if(f.isOpen() && f instanceof IMAPFolder){
						message = ((IMAPFolder)f).getMessageByUID(uid);
					}

					if (message == null) {
						logger.error("Message not found. uid=" + uid);
					} else {
						Part part = ezEmailUtil.getInlinePart(message, contentId);

						if (part == null) {
							logger.error("InlinePart not found. contentId=" + contentId);
						} else {
							response.setContentType(part.getContentType());
							response.addHeader("content-disposition", "inline");
							InputStream input = part.getInputStream();
							OutputStream output = response.getOutputStream();
							byte[] buffer = new byte[4096];
							int byteRead;
							try{
								while ((byteRead = input.read(buffer)) != -1) {
									output.write(buffer, 0, byteRead);
								}
							} catch(IOException e){
								try {
									output.close();
								} catch (IOException e1) {
									logger.debug("e.message=" + e1.getMessage());
								}

								if (ia != null) {
									ia.close();
								}

								return;
							}

							try {
								output.flush();
							} catch (IOException e) {
								logger.debug("e.message=" + e.getMessage());
							}

							try {
								output.close();
							} catch (IOException e) {
								logger.debug("e.message=" + e.getMessage());
							}
						}
					}
				}
			}
		} catch (MessagingException e) {
			logger.error(e.getMessage(), e);
		} finally {
			if (ia != null) {
				ia.close();
			}
		}
		
		logger.debug("downloadInline ended.");
	}
	
	@RequestMapping(value="/ezEmail/downloadInlineDotNet.do", method=RequestMethod.GET)
	@ResponseBody
	public void downloadInlineDotNet(HttpServletRequest request, HttpServletResponse response) throws Exception{
		logger.debug("downloadInlineDotNet started.");
		
		String password  = jspw;
		
        String serverName = request.getServerName();
        int tenantId = loginService.getTenantId(serverName);
		
		String domainName = ezCommonService.getTenantConfig("DomainName", tenantId);
		String userId = request.getParameter("userId");
		String userEmail = userId + "@" + domainName;
		logger.debug("userEmail=" + userEmail);
		
		// retrieve the passed in parameters
		String folderPath = request.getParameter("folderPath");
		String strUid = request.getParameter("uid");
		long uid = strUid != null ? Long.parseLong(strUid) : 0;
		String contentId = request.getParameter("contentId");
		
		if (contentId != null) {
			contentId = EgovStringUtil.getHtmlStrCnvr(contentId);
		}	
		
		logger.debug("folderPath=" + folderPath + ",uid=" + uid + ",contentId=" + contentId);
				
		IMAPAccess ia = null;
		try {
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userEmail, password, egovMessageSource, Locale.getDefault(), ezEmailUtil);
	
			if (ia != null){
				Folder f = ia.getFolder(folderPath != null ? folderPath : "");
				if (f == null || !f.exists()) {
					logger.error("Folder not found. folderPath=" + folderPath);
				} else {
					f.open(Folder.READ_ONLY);
					Message message = null;
					if(f.isOpen() && f instanceof IMAPFolder){
						message = ((IMAPFolder)f).getMessageByUID(uid);
					}

					if (message == null) {
						logger.error("Message not found. uid=" + uid);
					} else {
						Part part = ezEmailUtil.getInlinePart(message, contentId);

						if (part == null) {
							logger.error("InlinePart not found. contentId=" + contentId);
						} else {
							response.setContentType(part.getContentType());
							response.addHeader("content-disposition", "inline");
							InputStream input = part.getInputStream();
							OutputStream output = response.getOutputStream();
							byte[] buffer = new byte[4096];
							int byteRead;
							try{
								while ((byteRead = input.read(buffer)) != -1) {
									output.write(buffer, 0, byteRead);
								}
							} catch(IOException e){
								try {
									output.close();
								} catch (IOException e1) {
									logger.debug("e.message=" + e1.getMessage());
								}

								if (ia != null) {
									ia.close();
								}

								return;
							}

							try {
								output.flush();
							} catch (IOException e) {
								logger.debug("e.message=" + e.getMessage());
							}

							try {
								output.close();
							} catch (IOException e) {
								logger.debug("e.message=" + e.getMessage());
							}
						}
					}
				}
			}
		} catch (MessagingException e) {
			logger.error(e.getMessage(), e);
		} finally {
			if (ia != null) {
				ia.close();
			}
		}
				
		logger.debug("downloadInlineDotNet ended.");
	}
	
	/**
	 * 미리보기 메일 정보 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailPrevShow.do", method=RequestMethod.POST)
	@ResponseBody
	public void mailPrevShow(@CookieValue("loginCookie") String loginCookie, Locale locale, HttpServletRequest request, HttpServletResponse response) throws Exception{
		logger.debug("mailPrevShow started.");
		
		// get user credentials
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
					logger.debug("mailPrevShow ended.");
					
					return;
				}
				
				userEmail = shareId + "@" + domainName;
			}
		}
		
		logger.debug("userId=" + loginInfo.getId() + ",userEmail=" + userEmail);

		long uid = 0;
		String folderPath = null;
		String url = null;

		Document doc = commonUtil.convertRequestToDocument(request);
		if (doc != null){
			url = doc.getElementsByTagName("URL").item(0).getTextContent();
			
			url = URLDecoder.decode(url, "UTF-8");
			
			logger.debug("url=" + url);

			if(url != null){
				int index = url.lastIndexOf(commonUtil.separator);
				if(index != -1){
					folderPath = url.substring(0, index);
					uid = Long.parseLong(url.substring(index + 1));
				}
			}
		}
		
		Address[] arrFroms = null;
		Address[] arrRecipientsTo = null;
		Address[] arrRecipientsCC = null;
		Address[] arrRecipientsBCC = null;
		Date date = null;
		String fromEmail = null;
		String fromStr = "";
		String toStr = "";
		String ccStr = "";
		String bccStr = "";
		String subject = null;
		String dateStr = null;
		int unread = 0;
		int importance = 1;
		IMAPAccess ia = null;
		String fromId = "";
		String senderProfileImageName = "";
		Boolean emptyFlag = false;
		int blockedMail = 0;
		
		// 읽기 화면에서 리스트 출력 위한 데이터
		String countryName = "";
		String countryIP = "";
		String countryCode = "";
		String tags = "";
		String systemCountryCode = ezCommonService.getTenantConfig("systemCountryCode", loginInfo.getTenantId());
		String useCountryIP = ezCommonService.getTenantConfig("useCountryIP", loginInfo.getTenantId());
		String useShowSystemCountry = ezCommonService.getTenantConfig("useShowSystemCountry", loginInfo.getTenantId());
		String useRDBOnlyMailList = ezCommonService.getTenantConfig("useRDBOnlyMailList", loginInfo.getTenantId());
		Message message = null;
		
		try {
			Map<String, String> mailInfo = null;
			boolean recipientHasAllRecipientTypes = false;
			
			if (useRDBOnlyMailList.equals("YES")) {
				mailInfo = ezEmailUtil.getMailInfo(userEmail, folderPath, uid);
				
				if (mailInfo == null) {
					logger.error("Message not found. uid=" + uid);
					emptyFlag = true;
				} else {
					String recipientsStr = mailInfo.get("RECIPIENT");
					
					if (!recipientsStr.isEmpty()) {
						// To, Cc, Bcc를 분리한다.(||로 구분됨.)
						String[] recipientsArr = recipientsStr.split("\\|\\|", 3);

						// 오래된 사이트(가온누리 포함)의 경우 오래된 메일의 RECIPIENT 필드값이 To, Cc, Bcc로 분리되어 있지 않은 경우가 있어
						// 추가함.
						if (recipientsArr.length > 1) {
							recipientHasAllRecipientTypes = true;
						}
					}
				}
			}

			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userEmail, password, egovMessageSource, locale, ezEmailUtil);

			if (ia != null){

				Folder f = ia.getFolder(folderPath != null ? folderPath : "");
				if (f == null || !f.exists()) {
					logger.error("Folder not found. folderPath=" + folderPath);
					emptyFlag = true;
				} else {
					f.open(Folder.READ_WRITE);

					if (f.isOpen() && f instanceof IMAPFolder) {
						message = ((IMAPFolder)f).getMessageByUID(uid);
						if (message != null) {

							logger.debug("message=" + message);

							String[] messageIds = message.getHeader("Message-ID");

							if (messageIds != null) {
								logger.debug("Message-ID=" + messageIds[0]);
								blockedMail = ezEmailService.checkBlockedMailByMessageId(messageIds[0]);

								if (blockedMail == 1) {
									emptyFlag = true;
								}
							}
						} else {
							logger.error("Message not found. uid=" + uid);
							emptyFlag = true;
					}
				}
			}
			
			if (useRDBOnlyMailList.equals("YES") && recipientHasAllRecipientTypes) {
				fromStr = ezEmailUtil.getNameOrAddress(mailInfo.get("SENDER"));
				fromEmail = ezEmailUtil.getAddress(mailInfo.get("SENDER"));
				
				logger.debug("From=" + fromStr);
				
				// 메일 보낸사람 국기 표시 
				if (useCountryIP.equals("YES")) {						
					String ctryCode = mailInfo.get("COUNTRY_CODE");
					String mailIp = mailInfo.get("MAIL_IP");
					String systemLang = loginInfo.getLang();
					
					if (mailIp != null && !mailIp.isEmpty()) {
						countryIP = mailIp;
					}
					
					if (ctryCode != null && !ctryCode.isEmpty()) {
						String systemCountryName = commonUtil.getTwoLetterLangFromLangNum(systemLang, "kr");
						Locale localeCountry = new Locale(systemCountryName, ctryCode);
						countryName = localeCountry.getDisplayCountry(localeCountry);
						countryName = countryName.replaceAll(" ", "");
						countryCode = ctryCode.toLowerCase();
					}
					logger.debug("countryName:" + countryName + ",ctryCode[0]:" + countryCode);
				} 
				
				// To, Cc, Bcc를 모두 포함한다.
				String recipientsStr = mailInfo.get("RECIPIENT");
				
				if (!recipientsStr.isEmpty()) {
					// To, Cc, Bcc를 분리한다.(||로 구분됨.)
					String[] recipientsArr = recipientsStr.split("\\|\\|", 3);		
					
					if (!recipientsArr[0].isEmpty()) {
						// Undisclosed recipients:; <Undisclosed recipients:;>|||| 와 같은 경우가 있어
						// :; 를 제거하도록 함.
						toStr = recipientsArr[0].replace(":;", "").replace("; ", ";");
					}
					
					if (recipientsArr.length > 1 && !recipientsArr[1].isEmpty()) {
						ccStr = recipientsArr[1].replace(":;", "").replace("; ", ";");
					}

					if (recipientsArr.length > 2 && !recipientsArr[2].isEmpty()) {
						bccStr = recipientsArr[2].replace(":;", "").replace("; ", ";");
					}						
				}					
				
				logger.debug("TO=" + toStr);										
				logger.debug("CC=" + ccStr);					
				logger.debug("BCC=" + bccStr);
				
				// received date
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");					
				date = sdf.parse(mailInfo.get("MAIL_DATE"));

				sdf.setTimeZone(TimeZone.getTimeZone("GMT"));
				String receivedDateStr = sdf.format(date);					
				dateStr = commonUtil.getDateStringInUTC(receivedDateStr, loginInfo.getOffset(), false);

				logger.debug("dateStr=" + dateStr);
				
				subject = mailInfo.get("SUBJECT");
				subject = commonUtil.cleanValue(subject);
				
				logger.debug("subject=" + subject);
				
				// 메일 중요도
				try {
					importance = Integer.parseInt(mailInfo.get("IMPORTANCE"));
				} catch (NumberFormatException ex) {			
					logger.debug("ex.message=" + ex.getMessage());
				} catch (Exception ex) {			
					logger.debug("ex.message=" + ex.getMessage());			
				}
				
				logger.debug("importance=" + importance);		
				
				if (!"1".equals(mailInfo.get("MAIL_IS_SEEN"))) {
					unread = 1;
				}									

				tags = commonUtil.cleanValue(mailInfo.get("TAGS"));
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
							fp.add("Importance");

							Message[] fetchMessages = new Message[] {message};
							f.fetch(fetchMessages, fp);

							arrFroms = message.getFrom();

							if (arrFroms != null) {
								fromStr = ezEmailUtil.getFromNameOrAddressOfMessage(message);
								fromEmail = ((InternetAddress)arrFroms[0]).getAddress();

								if (fromStr.equals(fromEmail)) {
									List<String> mailAddrList = ezEmailUtil.mailAddrNameParse(fromStr, fromEmail);
									fromStr = mailAddrList.get(0);
									fromEmail = mailAddrList.get(1);

									if (fromStr.indexOf("\"") == 0 && fromStr.lastIndexOf("\"") == (fromStr.length()-1)) {
										fromStr = fromStr.substring(1, fromStr.length()-2);
									}
								}
							} else {
								String[] fromHeaders = message.getHeader("From");
								if (fromHeaders != null) {
									fromStr = MimeUtility.decodeText(message.getHeader("From")[0]);
								}
							}
							logger.debug("From=" + fromStr);

							// 메일 보낸사람 국기 표시
							if (useCountryIP.equals("YES")) {

								String[] ctryCode = message.getHeader("X-Jmocha-Country-Code");
								String[] mailIp = message.getHeader("X-Jmocha-IP");
								String systemLang = loginInfo.getLang();

								if (mailIp != null && !mailIp[0].equals("")) {
									countryIP = mailIp[0];
								}

								if (ctryCode != null && ctryCode[0] != null) {
									String systemCountryName = commonUtil.getTwoLetterLangFromLangNum(systemLang, "kr");
									Locale localeCountry = new Locale(systemCountryName, ctryCode[0]);
									countryName = localeCountry.getDisplayCountry(localeCountry);
									countryName = countryName.replaceAll(" ", "");
									countryCode = ctryCode[0].toLowerCase();
								}
								logger.debug("countryName:" + countryName + ",ctryCode[0]:" + countryCode );
							}

							arrRecipientsTo = message.getRecipients(Message.RecipientType.TO);

							if (arrRecipientsTo != null) {
								InternetAddress iAddress = null;
								String toHeader = message.getHeader("To")[0];
								boolean isAscii = ezEmailUtil.isPureAscii(toHeader);
								boolean addressFound = false;
								String name = null;
								String[] recipientHeaderArray = null;

								if (toHeader.contains("=?gb2312")) {
									toHeader = MimeUtility.unfold(toHeader);

									logger.debug("toHeader=" + toHeader);

									recipientHeaderArray = toHeader.split(",");

									for (int i = 0; i < recipientHeaderArray.length; i++) {
										recipientHeaderArray[i] = recipientHeaderArray[i].trim();
									}
								}

								for (int i = 0; i < arrRecipientsTo.length; i++) {
									iAddress = ((InternetAddress)arrRecipientsTo[i]);
									name = iAddress.getPersonal();
									addressFound = iAddress.getAddress().contains("@");

									if (name == null && !addressFound) {
										logger.debug("no address found!");

										// To: $경영전략본부{하위포함}, $금융사업본부{하위포함} 와 같이 헤더 인코딩이 되지 않은 채로 한글로 수신자명이
										// 입력되고 메일주소가 없는 메일이 HUG(주택도시보증공사)에 수신되어 이 경우엔 header 값을 그대로 사용해 하단에서
										// Non-Ascii 디코딩을 시도하도록 함
										name = toHeader;
									}

									if (name == null) {
										name = iAddress.getAddress();
									} else {
										// 표준을 지키지 않고 Non-Ascii 문자가 사용된 경우엔 직접 디코딩을 처리한다.
										if (!isAscii) {
											byte[] rawBytes = name.getBytes("iso-8859-1");

											name = ezEmailUtil.decodeNonAsciiBytes(rawBytes);
										} else {
											if (recipientHeaderArray != null) {
												String recipientHeader = recipientHeaderArray[i];

												// gb2312로 인코딩되어 있다고 기술되어 있지만 gbk에서
												// 정의되어 있는 글자가 포함되어 디코딩 시 깨지는 문제가 발생하여 gbk로 디코딩 처리하는 코드를 추가함.
												String newHeader = ezEmailUtil.changeCharSet(recipientHeader, "gb2312", "gbk");

												// gb2312에서 gbk로 변경된 경우
												if (!newHeader.equals(recipientHeader)) {
													int endPos = newHeader.indexOf("?=", 2);

													// 주소 부분을 제외한 이름 파트만 분리한다.
													if (endPos > -1) {
														name = newHeader.substring(0, endPos + 2);
													}
												}
											}

											name = MimeUtility.decodeText(name);
										}
									}

									if (i != 0) {
										toStr += ";";
									}

									if (name != null) {
										// 료비에서 수신한 메일 중 \(backslash)" 가 문자열 내부에 포함되는 경우가 있어 추가함.
										// 예) =?iso-2022-jp?B?Im1hLXgtOTMyQGRvY29tby5uZS5qcCI=?=<ma-x-932@docomo.ne.jp>
										name = name.replace("\\\"", "");
									}

									toStr += "\""+ name +"\" <" + (addressFound ? iAddress.getAddress() : "") + ">";
								}
							}

							logger.debug("TO=" + toStr);

							arrRecipientsCC = message.getRecipients(Message.RecipientType.CC);

							if (arrRecipientsCC != null) {
								InternetAddress iAddress = null;
								String ccHeader = message.getHeader("Cc")[0];
								boolean isAscii = ezEmailUtil.isPureAscii(ccHeader);
								boolean addressFound = false;
								String name = null;
								String[] recipientHeaderArray = null;

								if (ccHeader.contains("=?gb2312")) {
									ccHeader = MimeUtility.unfold(ccHeader);

									logger.debug("ccHeader=" + ccHeader);

									recipientHeaderArray = ccHeader.split(",");

									for (int i = 0; i < recipientHeaderArray.length; i++) {
										recipientHeaderArray[i] = recipientHeaderArray[i].trim();
									}
								}

								for (int i = 0; i < arrRecipientsCC.length; i++) {
									iAddress = ((InternetAddress)arrRecipientsCC[i]);
									name = iAddress.getPersonal();
									addressFound = iAddress.getAddress().contains("@");

									if (name == null && !addressFound) {
										logger.debug("no address found!");

										// To: $경영전략본부{하위포함}, $금융사업본부{하위포함} 와 같이 헤더 인코딩이 되지 않은 채로 한글로 수신자명이
										// 입력되고 메일주소가 없는 메일이 HUG(주택도시보증공사)에 수신되어 이 경우엔 header 값을 그대로 사용해 하단에서
										// Non-Ascii 디코딩을 시도하도록 함
										name = ccHeader;
									}

									if (name == null) {
										name = iAddress.getAddress();
									} else {
										// 표준을 지키지 않고 Non-Ascii 문자가 사용된 경우엔 직접 디코딩을 처리한다.
										if (!isAscii) {
											byte[] rawBytes = name.getBytes("iso-8859-1");

											name = ezEmailUtil.decodeNonAsciiBytes(rawBytes);
										} else {
											if (recipientHeaderArray != null) {
												String recipientHeader = recipientHeaderArray[i];

												// gb2312로 인코딩되어 있다고 기술되어 있지만 gbk에서
												// 정의되어 있는 글자가 포함되어 디코딩 시 깨지는 문제가 발생하여 gbk로 디코딩 처리하는 코드를 추가함.
												String newHeader = ezEmailUtil.changeCharSet(recipientHeader, "gb2312", "gbk");

												// gb2312에서 gbk로 변경된 경우
												if (!newHeader.equals(recipientHeader)) {
													int endPos = newHeader.indexOf("?=", 2);

													// 주소 부분을 제외한 이름 파트만 분리한다.
													if (endPos > -1) {
														name = newHeader.substring(0, endPos + 2);
													}
												}
											}

											name = MimeUtility.decodeText(name);
										}
									}

									if (i != 0) {
										ccStr += ";";
									}

									if (name != null) {
										// 료비에서 수신한 메일 중 \(backslash)" 가 문자열 내부에 포함되는 경우가 있어 추가함.
										// 예) =?iso-2022-jp?B?Im1hLXgtOTMyQGRvY29tby5uZS5qcCI=?=<ma-x-932@docomo.ne.jp>
										name = name.replace("\\\"", "");
									}

									ccStr += "\"" + name + "\" <" + (addressFound ? iAddress.getAddress() : "") + ">";
								}
							}

							logger.debug("CC=" + ccStr);

							arrRecipientsBCC = message.getRecipients(Message.RecipientType.BCC);

							if (arrRecipientsBCC != null) {
								InternetAddress iAddress = null;
								String name = null;

								for (int i = 0; i < arrRecipientsBCC.length; i++) {
									iAddress = ((InternetAddress)arrRecipientsBCC[i]);
									name = iAddress.getPersonal();

									if (name == null) {
										name = iAddress.getAddress();
									} else {
										name = MimeUtility.decodeText(name);
									}

									if (i != 0) {
										bccStr += ";";
									}

									if (name != null) {
										// 료비에서 수신한 메일 중 \(backslash)" 가 문자열 내부에 포함되는 경우가 있어 추가함.
										// 예) =?iso-2022-jp?B?Im1hLXgtOTMyQGRvY29tby5uZS5qcCI=?=<ma-x-932@docomo.ne.jp>
										name = name.replace("\\\"", "");
									}

									bccStr += "\"" + name + "\" <" + iAddress.getAddress() + ">";
								}
							}

							logger.debug("BCC=" + bccStr);

							// received date
							date = message.getReceivedDate();
							if (date != null) {
								SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
								sdf.setTimeZone(TimeZone.getTimeZone("GMT"));
								String receivedDateStr = sdf.format(date);

								dateStr = commonUtil.getDateStringInUTC(receivedDateStr, loginInfo.getOffset(), false);
							}
							logger.debug("dateStr=" + dateStr);

							subject = ezEmailUtil.getSubject(message);
							subject = commonUtil.cleanValue(subject);

							logger.debug("subject=" + subject);

							// 메일 중요도
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
							// startsWith is used since
							// there are cases like X-Priority: 1 (Highest) generated by Thunderbird.
							if (header.startsWith("1") || header.startsWith("high")) {
								importance = 2;
							} else if (header.startsWith("5") || header.startsWith("low")) {
								importance = 0;
							}

							logger.debug("importance=" + importance);

							if(!message.isSet(Flag.SEEN)){
								unread = 1;
								message.setFlag(Flag.SEEN, true);
								logger.debug("Message's seen flag changed to true.");
							}

							try {
								String [] tagList = ezEmailUtil.getTagList(userEmail, folderPath, uid);
								tags = Arrays.stream(tagList).collect(Collectors.joining("|"));
							} catch (Exception e) {
								logger.error("get tag error:", e);
							}
						}
						f.close(true);
					}
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		} finally {
			if (ia != null) {
				ia.close();
			}
		}
		
		if (fromEmail != null && !fromEmail.equals("")) {
			if (fromEmail.contains("@")) {
				fromId = ezOrganService.getCNByEmail(fromEmail, loginInfo.getTenantId());
				
				//email이 alias 메일이어서 id를 못가져왔을 경우
				//alias mail인지 check후 원래 이메일 주소에서 id를 가져온다.
				if (fromId == null || fromId.equals("")) {
					List<String> aliasAddress = new ArrayList<String>();
					aliasAddress.add(fromEmail);
					Map<String, String> targetAddress = ezEmailService.getAliasAddressMap(aliasAddress, loginInfo.getTenantId());
					
					if (targetAddress != null) {
						String resultTargetAddress = targetAddress.get(fromEmail);
						logger.debug("resultAddress=" + resultTargetAddress);
						
						if (resultTargetAddress != null) {
							int atSignPos = resultTargetAddress.indexOf("@");
							if (atSignPos != -1) {
								fromId = resultTargetAddress.substring(0, atSignPos);
								logger.debug("fromId=" + fromId);
							}
						}
						
					}
				}
				
				senderProfileImageName = ezOrganService.getPropertyValue(fromId, "EXTENSIONATTRIBUTE2", loginInfo.getTenantId());
				logger.debug("senderProfileImageName=" + senderProfileImageName);
				if (senderProfileImageName == null) {
					senderProfileImageName = "";
				}
			}
		}
		
		if(emptyFlag) {
			dateStr = "";
			fromStr = "";
			fromEmail = "";
			toStr = "";
			ccStr = "";
			bccStr = "";
			subject = "";
		}
		
		StringBuilder sb = new StringBuilder();
		sb.append("<DATA>");
		sb.append("<UNREAD><![CDATA[" + unread + "]]></UNREAD>");
		sb.append("<DATE><![CDATA[" + dateStr + "]]></DATE>");
		sb.append("<FROM><![CDATA[" + fromStr + "]]></FROM>");
		sb.append("<FROMEMAIL><![CDATA[" + fromEmail + "]]></FROMEMAIL>");
		sb.append("<FROMNAME><![CDATA[" + fromStr + "]]></FROMNAME>");
		sb.append("<TO><![CDATA[" + toStr + "]]></TO>");
		sb.append("<CC><![CDATA[" + ccStr + "]]></CC>");
		sb.append("<BCC><![CDATA[" + bccStr + "]]></BCC>");
		sb.append("<SUBJECT><![CDATA[" + subject + "]]></SUBJECT>");
		sb.append("<HTMLDESCRIPTION><![CDATA[]]></HTMLDESCRIPTION>");
		sb.append("<COMMENT><![CDATA[]]></COMMENT>");
		sb.append("<IMPORTANCE><![CDATA[" + importance + "]]></IMPORTANCE>");
		sb.append("<SENSITIVITY><![CDATA[" + "Normal" + "]]></SENSITIVITY>");
		sb.append("<HASEMBEDED><![CDATA[" + 0 + "]]></HASEMBEDED>");
		sb.append("<ITEMID><![CDATA[" + url + "]]></ITEMID>");
		sb.append("<SENDERPROFILEIMAGENAME><![CDATA[" + senderProfileImageName + "]]></SENDERPROFILEIMAGENAME>");
		sb.append("<CONTENTCLASS><![CDATA[" + "]]></CONTENTCLASS>");
		sb.append("<COUNTRYNAME><![CDATA[" + countryName + "]]></COUNTRYNAME>");
		sb.append("<COUNTRYIP><![CDATA[" + countryIP + "]]></COUNTRYIP>");
		sb.append("<COUNTRYCODE><![CDATA[" + countryCode + "]]></COUNTRYCODE>");
		sb.append("<SYSTEMCOUNTRYCODE><![CDATA[" + systemCountryCode.toLowerCase() + "]]></SYSTEMCOUNTRYCODE>");
		sb.append("<USECOUNTRYIP><![CDATA[" + useCountryIP + "]]></USECOUNTRYIP>");
		sb.append("<USESHOWSYSTEMCOUNTRY><![CDATA[" + useShowSystemCountry + "]]></USESHOWSYSTEMCOUNTRY>");
		sb.append("<TAGS><![CDATA[" + tags + "]]></TAGS>");
		sb.append("<MAIL_ID><![CDATA[" + tags + "]]></MAIL_ID>");
		sb.append("<BLOCKEDMAIL><![CDATA[" + blockedMail + "]]></BLOCKEDMAIL>");
		sb.append("</DATA>");

		response.setContentType("text/xml; charset=utf-8");
		
		// skyblue0o0 20180402 : 특정 유니코드 문자 포함 시 xml파싱 에러나서 빈칸으로 치환
		response.getWriter().print(sb.toString().replaceAll("[\\u0000-\\u0008\\u000B-\\u000C\\u000E-\\u001F]", " "));
		
		logger.debug("mailPrevShow ended.");
	}
	
	/**
	 * 미리보기 메일 본문 내용 화면 정보 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailPreviewContent.do", method=RequestMethod.POST)
	public String previewContent(@CookieValue("loginCookie") String loginCookie, Locale locale, HttpServletRequest request, Model model) throws Exception{
		logger.debug("previewContent started.");
		
		// get user credentials
		List<String> userCookieInfo = commonUtil.getUserIdAndPassword(loginCookie);
		String password  = userCookieInfo.get(1);
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
		String userEmail = userInfo.getId() + "@" + domainName;
		String mailId = userInfo.getId();
		Map<String, Object> extraMap = new HashMap<String, Object>();
		String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", userInfo.getTenantId());
		String useImageConvertServer = ezCommonService.getTenantConfig("useImageConvertServer", userInfo.getTenantId());
		String useRDBOnlyMailList = ezCommonService.getTenantConfig("useRDBOnlyMailList", userInfo.getTenantId());
		String useWebfolder = ezCommonService.getTenantConfig("useWebfolder", userInfo.getTenantId());
		
		// 20200311 조진호 - 메일 읽기 > 첨부 파일 미리보기 활성화 여부 확인
		if (!useImageConvertServer.equalsIgnoreCase("0")) {
			extraMap.put("useImageConvertServer", useImageConvertServer);
		}
		
		// 20230418 김은실 - 메일 읽기 > 첨부파일 웹폴더에 저장 기능 추가
		if ("YES".equalsIgnoreCase(useWebfolder)) {
			extraMap.put("useWebfolder", true);
		}

		if (useSharedMailbox.equals("YES")) {
			String shareId = request.getParameter("shareId");
			logger.debug("shareId=" + shareId);
			
			if (shareId != null) {
				if (!ezEmailService.checkUserShareId(userInfo.getId(), shareId, userInfo.getTenantId())) {
					model.addAttribute("mainContent", egovMessageSource.getMessage("ezEmail.lhm81", locale));
					
					logger.debug("the user cannot access the shareId.");
					logger.debug("previewContent ended.");
					
					return "ezCommon/error";
				}
				
				userEmail = shareId + "@" + domainName;
				mailId = shareId;
				
				extraMap.put("shareId", shareId);
				
				MailSharedMailboxUserVO shareVO = ezEmailService.getSharedMailboxPermissionInfo(shareId, userInfo.getTenantId(), userInfo.getId());
				model.addAttribute("shareId", shareId);
				model.addAttribute("deletePermission", shareVO.getDeletePermission());
				model.addAttribute("sendPermission", shareVO.getSendPermission());
			}
		}
		
		logger.debug("userId=" + userInfo.getId() + ",userEmail=" + userEmail);
		
		// retrieve the passed in parameters
		String url = request.getParameter("iptURL");
		logger.debug("url=" + url);
		long uid = 0;
		String folderPath = null;
		if (url != null) {
			int index = url.lastIndexOf(commonUtil.separator);
			if (index != -1) {
				folderPath = url.substring(0, index);
				uid = Long.parseLong(url.substring(index+1));
			}
		}
		
		List<String> bodyInfoList = null;
		String pAttachListHtmlSub = "";
		IMAPAccess ia = null;
        boolean retryFlag = false;
        int retryCount = 1; // 메일 읽기 실패 시 재시도 횟수		
        String sentDateMsg = ""; // 전달, 회신 시 보낸 시간
        String contentClass = "";
		int unread = 0;        
        
        do {
    		try {
    			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
    					userEmail, password, egovMessageSource, locale, ezEmailUtil);
    			
    			if (retryFlag) {
    			    retryFlag = false;
    			}

    			if (ia != null){
					Folder f = ia.getFolder(folderPath != null ? folderPath : "");
					if (f == null || !f.exists()) {
						logger.error("Folder not found. folderPath=" + folderPath);
						model.addAttribute("title", egovMessageSource.getMessage("ezEmail.t565", locale));
						model.addAttribute("mainContent", egovMessageSource.getMessage("ezEmail.t99000081", locale));
						model.addAttribute("subContent", egovMessageSource.getMessage("ezEmail.t99000082", locale));
						return "ezCommon/error";
					} else {
						f.open(Folder.READ_ONLY);
						Message message = null;
						if (f.isOpen() && f instanceof IMAPFolder) {
							message = ((IMAPFolder)f).getMessageByUID(uid);
						}

						if (message == null) {
							logger.error("Message not found. uid=" + uid);
							model.addAttribute("title", egovMessageSource.getMessage("ezEmail.t565", locale));
							model.addAttribute("mainContent", egovMessageSource.getMessage("ezEmail.t99000081", locale));
							model.addAttribute("subContent", egovMessageSource.getMessage("ezEmail.t99000082", locale));
							return "ezCommon/error";
						} else {
							if (useRDBOnlyMailList.equals("YES")) {
								if (!message.isSet(Flag.SEEN)) {
									unread = 1;
									message.setFlag(Flag.SEEN, true);

									logger.debug("Message's seen flag changed to true.");
								}
							}

							bodyInfoList = ezEmailUtil.getBodyInfo(message, folderPath, uid, -1, null, locale, extraMap);
							double size = Double.parseDouble(bodyInfoList.get(2));
							String strSize = ezEmailUtil.getSizeWithUnit(size);
							pAttachListHtmlSub = " <span class='cblue'>" + bodyInfoList.get(3) + "</span> (" + strSize + ")";

							if (!folderPath.equals(ezEmailUtil.getSentFolderId(locale))) {
								String[] messageIds = message.getHeader("Message-ID");

								if (messageIds != null) {
									logger.debug("Message-ID=" + messageIds[0]);
								} else {
									logger.debug("No Message-ID");
								}

								// send an MDN to the sender.
								if (!ezEmailUtil.hasMDNSentFlag(message)) {
									logger.debug("MDNSentFlag isn't set.");

									// retrieve user info from db.
									OrganUserVO userVO = ezOrganAdminService.getUserInfo(mailId, userInfo.getPrimary(), userInfo.getTenantId());

									SMTPAccess sa = SMTPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.SMTPPort"),
											userEmail, password);

									processAutoMDN(sa, message, userVO.getMail(), userVO.getDisplayName(), userInfo.getTenantId());
								} else {
									logger.debug("MDNSentFlag is set");
								}
							}

							if (message.isSet(Flags.Flag.ANSWERED)) {
								contentClass = "REPLY";
							} else if (ezEmailUtil.hasForwardedFlag(message)) {
								contentClass = "FORWARD";
							}

							// 전달, 회신 시 보낸 시간
							if (contentClass.equals("REPLY") || contentClass.equals("FORWARD")) {
								if (ezEmailUtil.hasSentDateFlag(message)) {
									String sentDateFlag = ezEmailUtil.getSentDateFlag(message);
									sentDateFlag = sentDateFlag.split("-")[1];
									logger.debug("sentDateFlag=" + sentDateFlag);

									SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
									sdf.setTimeZone(TimeZone.getTimeZone("GMT"));
									String receivedDateStr = sdf.format(new Date(Long.parseLong(sentDateFlag)));
									String sentDate = commonUtil.getDateStringInUTC(receivedDateStr, userInfo.getOffset(), false);
									logger.debug("receivedDateStr=" + receivedDateStr);

									String msg = contentClass.equals("REPLY") ? "ezEmail.ksa01" : "ezEmail.ksa02";
									String sentDateStr = egovMessageSource.getMessage(msg, locale);
									sentDateMsg = String.format(sentDateStr, sentDate);
									logger.debug("sentDateMsg=" + sentDateMsg);
								}
							}

						}
					}
				}

			} catch (MessagingException e) {
    			logger.error(e.getMessage(), e);
    			
                retryFlag = true;
                --retryCount;
                
                if (retryCount > -1) {
                    logger.debug("Message read fail. Retry...");
                    
                    try {
                        Thread.sleep(1000);
                    } catch (InterruptedException ex) {logger.debug("e.message=" + ex.getMessage());
					} catch (Exception ex) {logger.debug("e.message=" + ex.getMessage());}
                }    
			} catch (Exception e) {
    			logger.error(e.getMessage(), e);
    			
                retryFlag = true;
                --retryCount;
                
                if (retryCount > -1) {
                    logger.debug("Message read fail. Retry...");
                    
                    try {
                        Thread.sleep(1000);
					} catch (InterruptedException ex) {logger.debug("e.message=" + ex.getMessage());	
                    } catch (Exception ex) {logger.debug("e.message=" + ex.getMessage());}
                }    			
    		} finally {
    			if (ia != null) {
    				ia.close();
    			}
    		}        
        } while (retryFlag && retryCount > -1);		
		
        // 2023-05-16 이사라 : NullPointerException 시큐어코딩
        String htmlBody = CollectionUtils.isNotEmpty(bodyInfoList) ? bodyInfoList.get(0) : "";
        Pattern p = Pattern.compile("<base\\s+.*?href.*?>", Pattern.CASE_INSENSITIVE | Pattern.DOTALL);
		Matcher m = p.matcher(htmlBody);
		htmlBody = m.replaceAll("");
        		
		// 2018-08-03 황윤호 추가
        String memoFlag = "";
        if (ezCommonService.getTenantConfig("useMemo", userInfo.getTenantId()).equalsIgnoreCase("YES")) {
        	memoFlag = "YES";
        } else {
        	memoFlag = "NO";
        }

        // 20181219 김수아 : 첨부파일 이미지 미리보기 사용자 컨피그
        MailGeneralVO mailGeneralVO = ezEmailService.getMailGeneral(userInfo.getTenantId(), userInfo.getId()).get(0);
        String previewMailImage = mailGeneralVO.getPreviewMailImage() == null ? "Y" : mailGeneralVO.getPreviewMailImage();
        
        // 2023-05-16 이사라 : NullPointerException 시큐어코딩
        String pAttachListHtml = "";
        String isAttach = "";
        String previewImageListHtml = "";
        String isIcalMail = "";
        
        
        if (CollectionUtils.isNotEmpty(bodyInfoList)) {
        	pAttachListHtml = bodyInfoList.get(1);
        	isAttach = bodyInfoList.get(4);
        	previewImageListHtml = bodyInfoList.get(5);
        	isIcalMail = bodyInfoList.get(6);
        }

		// AI 첨부파일 이름 최대 길이 - 기존 메일과 동일한 값 사용
		String attachFileNameMaxLength = ezCommonService.getTenantConfig("attachFileNameMaxLength", userInfo.getTenantId());
		// AI 사용여부 확인
		boolean useAI = aICommonUtil.checkUseAI(userInfo.getTenantId());
		// AI 챗봇 첨부파일 최대용량
		String aiAttachMBSize = "10";//ezCommonService.getTenantConfig("aiAttachMBSize", -99); // 모든 테넌트 공통 값

		model.addAttribute("useAI", useAI);
		model.addAttribute("attachFileNameMaxLength", attachFileNameMaxLength);
		model.addAttribute("aiAttachMBSize", aiAttachMBSize);

		model.addAttribute("url", url);
		model.addAttribute("htmlBody", htmlBody);
		model.addAttribute("pAttachListHtml", pAttachListHtml);
		model.addAttribute("pAttachListHtmlSub", pAttachListHtmlSub);
		model.addAttribute("isAttach", isAttach);
		model.addAttribute("sentDateMsg", sentDateMsg); // 전달, 회신 시 보낸 시간 
		model.addAttribute("memoFlag", memoFlag);
		model.addAttribute("previewImageListHtml", previewImageListHtml); //이미지 미리보기 
		model.addAttribute("previewMailImage", previewMailImage);
		model.addAttribute("unread", unread);
		model.addAttribute("isIcalMail", isIcalMail); // "" or "Y"
		
		logger.debug("previewContent ended.");
		
		return "ezEmail/mailPreviewContent";
	}	
	
	/**
	 * 메일 인쇄
	 */
	@RequestMapping(value="/ezEmail/mailPrint.do", method=RequestMethod.GET)
	public String mailPrint(@CookieValue("loginCookie") String loginCookie, Locale locale, HttpServletRequest request, Model model) throws Exception{
		logger.debug("mailPrint started.");
		
		String pSender = "";
		String pReciveDT = "";
		String pReciverTo = "";
		String pReciverCc = "";
		String pReciverBcc = "";
		String pSubject = "";
		String isAttach = "NO";
		String pAttachListHtml = "";
		String pBody = "";
		boolean isSentItems =false;
		
		List<String> userInfo = commonUtil.getUserIdAndPassword(loginCookie);
		String password  = userInfo.get(1);
		
		LoginVO loginInfo = commonUtil.userInfo(loginCookie);
		String domainName = ezCommonService.getTenantConfig("DomainName", loginInfo.getTenantId());
		String userEmail = loginInfo.getId() + "@" + domainName;
		Map<String, Object> extraMap = new HashMap<String, Object>();
		String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", loginInfo.getTenantId());

		if (useSharedMailbox.equals("YES")) {
			String shareId = request.getParameter("shareId");
			logger.debug("shareId=" + shareId);
			
			if (shareId != null) {
				if (!ezEmailService.checkUserShareId(loginInfo.getId(), shareId, loginInfo.getTenantId())) {
					model.addAttribute("mainContent", egovMessageSource.getMessage("ezEmail.lhm81", locale));
					
					logger.debug("the user cannot access the shareId.");
					logger.debug("mailPrint ended.");
					
					return "ezCommon/error";
				}
				
				userEmail = shareId + "@" + domainName;
				extraMap.put("shareId", shareId);
			}
		}
		
		logger.debug("userId=" + loginInfo.getId() + ",userEmail=" + userEmail);
		
		String userLang = loginInfo.getLang();
        String propertyValue = ezCommonService.getTenantConfig("UseShowEmailAddrOnPrint", loginInfo.getTenantId());
        
		String url = null;
		long uid = 0;
		String folderPath = null;
		
		if (request.getParameter("URL") != null) {
			url = request.getParameter("URL");
		} else if (request.getParameter("iptURL") != null) {
			url = request.getParameter("iptURL");
		}
		logger.debug("url=" +url);
		
		if (url != null) {
			int index = url.lastIndexOf(commonUtil.separator);
			if (index != -1) {
				folderPath = url.substring(0, index);
				uid = Long.parseLong(url.substring(index+1));
			}
		}
		
		IMAPAccess ia = null;
		try {
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userEmail, password, egovMessageSource, locale, ezEmailUtil);
			
			Folder f = ia.getFolder(folderPath);
			if (f == null || !f.exists()) {
				logger.error("Folder not found. folderPath=" + folderPath);
			} else {
				f.open(Folder.READ_ONLY);
				Message message = ((IMAPFolder)f).getMessageByUID(uid);
				
				if (message == null) {
					logger.error("Message not found. uid=" + uid);
				} else {
					if (message.getFrom() != null && message.getFrom().length > 0) {
						InternetAddress fromAddress = (InternetAddress)message.getFrom()[0];	
						String personName = fromAddress.getPersonal();
						personName = personName != null ? personName : "";
						String fromHeader = message.getHeader("From")[0];
						
						if (!ezEmailUtil.isPureAscii(fromHeader)) {
							byte[] rawBytes = personName.getBytes("iso-8859-1");
							
							personName = ezEmailUtil.decodeNonAsciiBytes(rawBytes);
						}
						
                        if (propertyValue.equals("YES") || propertyValue.equals("")) {
                            pSender = personName;                                  
                            pSender += fromAddress.getAddress() == null ? "" : "(" + fromAddress.getAddress() + ")";
	                    } else {
	                    	pSender = personName;                                  
	                    }						
					}
					logger.debug("From=" + pSender);
					
					Address[] toAddresses = message.getRecipients(RecipientType.TO);
					Address[] ccAddresses = message.getRecipients(RecipientType.CC);
					Address[] bccAddresses = message.getRecipients(RecipientType.BCC);

					if (toAddresses != null) {
						String toHeader = message.getHeader("To")[0];
						boolean isAscii = ezEmailUtil.isPureAscii(toHeader);
						
						for (Address address : toAddresses) {
							String personName = ((InternetAddress)address).getPersonal();
							personName = personName != null ? personName : "";
							
							if (!isAscii) {
								byte[] rawBytes = personName.getBytes("iso-8859-1");
								
								personName = ezEmailUtil.decodeNonAsciiBytes(rawBytes);								
							}

                            if (propertyValue.equals("YES") || propertyValue.equals("")) {
                                pReciverTo += personName;
                                pReciverTo += ((InternetAddress)address).getAddress() == null ? "\t" : "(" + ((InternetAddress)address).getAddress() + ")\t";                                                                      
                            } else {
                                pReciverTo += personName + "\t";
                            }							
						}
					}
					logger.debug("TO=" + pReciverTo);
					
					if (ccAddresses != null) {
						String ccHeader = message.getHeader("Cc")[0];
						boolean isAscii = ezEmailUtil.isPureAscii(ccHeader);
						
						for (Address address : ccAddresses) {
							String personName = ((InternetAddress)address).getPersonal();
							personName = personName != null ? personName : "";
							
							if (!isAscii) {
								byte[] rawBytes = personName.getBytes("iso-8859-1");
								
								personName = ezEmailUtil.decodeNonAsciiBytes(rawBytes);								
							}
							
							if (propertyValue.equals("YES") || propertyValue.equals("")) {
								pReciverCc += personName;
								pReciverCc += ((InternetAddress)address).getAddress() == null ? "\t" : "(" + ((InternetAddress)address).getAddress() + ")\t";
							} else {
								pReciverCc += personName + "\t";								
							}
						}
					}
					logger.debug("CC=" + pReciverCc);

					if (bccAddresses != null) {
						String bccHeader = message.getHeader("Bcc")[0];
						boolean isAscii = ezEmailUtil.isPureAscii(bccHeader);

						for (Address address : bccAddresses) {
							String personName = ((InternetAddress) address).getPersonal();
							personName = personName != null ? personName : "";

							if (!isAscii) {
								byte[] rawBytes = personName.getBytes(StandardCharsets.ISO_8859_1);

								personName = ezEmailUtil.decodeNonAsciiBytes(rawBytes);
							}

							if (propertyValue.equals("YES") || propertyValue.equals("")) {
								pReciverBcc += personName;
								pReciverBcc += ((InternetAddress) address).getAddress() == null ? "\t" : "(" + ((InternetAddress) address).getAddress() + ")\t";
							} else {
								pReciverBcc += personName + "\t";
							}
						}
					}
					logger.debug("BCC=" + pReciverBcc);

					// received date
					if (message.getReceivedDate() != null) {
						SimpleDateFormat sdFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");
						sdFormat.setTimeZone(TimeZone.getTimeZone("GMT"));
						pReciveDT = sdFormat.format(message.getReceivedDate());
						pReciveDT = commonUtil.getDateStringInUTC(pReciveDT, loginInfo.getOffset(), false);
					}
					logger.debug("pReciveDT=" + pReciveDT);
					
					pSubject = ezEmailUtil.getSubject(message);
					pSubject = pSubject == null ? "" : pSubject;
					pSubject = commonUtil.cleanValue(pSubject);
					
					logger.debug("pSubject=" + pSubject);
					
					
					extraMap.put("forPrint", true);
					List<String> bodyInfoList = ezEmailUtil.getBodyInfo(message, folderPath, uid, -1, null, locale, extraMap);
					pBody = bodyInfoList.get(0);
					
					// 아웃룩에서 메일 발송시 @page 태그로 인해 프린트화면 새로운 페이지로 넘어가버리는 문제 - 본문에서 class를 적용하지 않도록 수정 
					// 회신이 한번이라도 된다면 class="WordSection1" 새로 만든 메일이면 class=WordSection1 이므로 둘다 수정 되도록 함.
					pBody = pBody.replace("class=WordSection1", "class=WordSection1_escape");
					pBody = pBody.replace("class=\"WordSection1\"", "class=\"WordSection1_escape\"");
					
					pAttachListHtml = bodyInfoList.get(1);
					
					if (bodyInfoList.get(4).equals("OK")) {
						isAttach = "OK";
					}
					
					if (message.getFolder().getFullName().equals(ezEmailUtil.getSentFolderId(locale))) {
						isSentItems = true;
					}
					
				}
			}
		} catch (MessagingException e) {
			logger.error(e.getMessage(), e);
		} finally {
			if (ia != null) {
				ia.close();
			}
		}
		
		model.addAttribute("pSender", pSender);
		model.addAttribute("pReciveDT", pReciveDT);
		model.addAttribute("pReciverTo", pReciverTo);
		model.addAttribute("pReciverCc", pReciverCc);
		model.addAttribute("pReciverBcc", pReciverBcc);
		model.addAttribute("pSubject", pSubject);
		model.addAttribute("isAttach", isAttach);
		model.addAttribute("isSentItems", isSentItems);
		model.addAttribute("pAttachListHtml", pAttachListHtml);
		model.addAttribute("pBody", pBody);
		model.addAttribute("userLang", userLang);
		
		logger.debug("mailPrint ended.");
		
		return "ezEmail/mailPrint";
	}
	
	/**
	 * 첨부파일 삭제(메일읽기)
	 */
	@RequestMapping(value="/ezEmail/mailDelReadInterAttach.do", method=RequestMethod.POST, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String mailDelInterAttach(@CookieValue("loginCookie") String loginCookie, Locale locale, HttpServletRequest request, Model model) throws Exception{
		logger.debug("mailDelInterAttach started.");
		
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
				if (!ezEmailService.checkUserShareId(loginInfo.getId(), shareId, 1, loginInfo.getTenantId())) {
					logger.debug("the user cannot access the shareId.");
					logger.debug("mailDelInterAttach ended.");
					
					return "";
				}
				
				userEmail = shareId + "@" + domainName;
			}
		}
		
		logger.debug("userId=" + loginInfo.getId() + ",userEmail=" + userEmail);
		
		Document xmlDoc = commonUtil.convertRequestToDocument(request);
		String returnValue = "";
		if (xmlDoc != null){
			Element root = xmlDoc.getDocumentElement();
			String strFileId = root.getElementsByTagName("NAME").item(0).getTextContent();
			int fileId = Integer.parseInt(strFileId);

			String folderPath = null;
			long uid = 0;
			String url = root.getElementsByTagName("ITEMID").item(0).getTextContent();
			logger.debug("url=" + url);
			if (url != null) {
				int index = url.lastIndexOf("/");
				if (index != -1) {
					folderPath = url.substring(0, index);
					uid = Long.parseLong(url.substring(index + 1));
				}
			}
			returnValue = "<DATA><![CDATA[";

			SMTPAccess sa = SMTPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.SMTPPort"),
					userEmail, password);

			IMAPAccess ia = null;
			boolean isNewUserQuotaNeeded = false;
			boolean isThereUserLevelQuota = false;
			Double userQuota = 0.0;
			Double userWarn = 0.0;

			try {
				ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
						userEmail, password, egovMessageSource, locale, ezEmailUtil);

				if (ia != null){
					Folder f = ia.getFolder(folderPath != null ? folderPath : "");

					if (f == null || !f.exists()) {
						logger.error("Folder not found. folderPath=" + folderPath);
					} else {
						f.open(Folder.READ_WRITE);
						Message oldMessage = ((IMAPFolder)f).getMessageByUID(uid);

						if (oldMessage == null) {
							logger.error("oldMessage not found. uid=" + uid);
						} else {
							MimeMessage newMessage = ezEmailUtil.deleteAttach(sa, oldMessage, new int[] {fileId});
							if (newMessage == null) {
								logger.error("newMessage not created.");
							} else {
								// 지운 편지함으로 보낼 메시지의 크기가 Quota량을 초과하게 되면 Quota를 재조정한다.
								Double[] adjustQuotaData = ezEmailUtil.adjustUserQuotaForMessageMove(new Message[] {oldMessage},
										userEmail, domainName, ia);

								if (adjustQuotaData[0] != null) {
									isNewUserQuotaNeeded = true;

									userQuota = adjustQuotaData[0];
									userWarn = adjustQuotaData[1];
								}

								if (adjustQuotaData[2] != null) {
									isThereUserLevelQuota = true;
								}

								newMessage.setFlag(Flags.Flag.SEEN, true);
								AppendUID[] uids = ((IMAPFolder)f).appendUIDMessages(new Message[]{newMessage});
								returnValue += folderPath + "/" + uids[0].uid;
							}
							oldMessage.setFlag(Flags.Flag.DELETED, true);
						}

						f.close(true);
					}
				}
			} catch (MessagingException e) {
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

			returnValue += "]]></DATA>";
		}
		logger.debug("returnValue=" + returnValue);
		
		logger.debug("mailDelInterAttach ended.");
		return returnValue;
	}
	
	@RequestMapping(value="/ezEmail/mailReadBoard.do", method=RequestMethod.POST, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String mailReadBoard(@CookieValue("loginCookie") String loginCookie, Locale locale, @RequestBody String bodyData, HttpServletRequest request, Model model) throws Exception{
		logger.debug("mailReadBoard started.");
		
		Document xmldom = commonUtil.convertStringToDocument(bodyData != null ? bodyData : "");
		String url = xmldom.getElementsByTagName("URL").item(0).getTextContent();
		String attachLimit = xmldom.getElementsByTagName("ATTACHLIMIT").item(0).getTextContent();
		/* 2020-09-24 홍승비 - 메일게시 시 게시판과 커뮤니티 모듈을 구분  */
		String itemType = request.getParameter("itemType") == null ? "" : (String) request.getParameter("itemType");
		logger.debug("url=" + url + ",attachLimit=" + attachLimit);
		
		String folderPath = url.split("/")[0];
		String uidStr = url.split("/")[1];
		long uid = Long.parseLong(uidStr);
		
		List<String> userInfo = commonUtil.getUserIdAndPassword(loginCookie);
		String password  = userInfo.get(1);
		
		LoginVO loginInfo = commonUtil.userInfo(loginCookie);
		String domainName = ezCommonService.getTenantConfig("DomainName", loginInfo.getTenantId());
		String userAccount = loginInfo.getId() + "@" + domainName;
		Map<String, Object> extraMap = new HashMap<String, Object>();
		String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", loginInfo.getTenantId());

		if (useSharedMailbox.equals("YES")) {
			String shareId = request.getParameter("shareId");
			logger.debug("shareId=" + shareId);
			
			if (shareId != null) {
				if (!ezEmailService.checkUserShareId(loginInfo.getId(), shareId, loginInfo.getTenantId())) {
					logger.debug("the user cannot access the shareId.");
					logger.debug("mailReadBoard ended.");
					
					return "";
				}
				
				userAccount = shareId + "@" + domainName;
				extraMap.put("shareId", shareId);
			}
		}

		logger.debug("userId=" + loginInfo.getId() + ",userAccount=" + userAccount);
		
		StringBuilder sb = new StringBuilder();
		sb.append("<DATA>");
		
		IMAPAccess ia = null;
		try {
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userAccount, password, egovMessageSource, locale, ezEmailUtil);
			
			if (ia != null){
				Folder f = ia.getFolder(folderPath != null ? folderPath : "");

				if (f != null && f.exists()) {
					f.open(Folder.READ_ONLY);
					Message message = ((IMAPFolder)f).getMessageByUID(uid);

					if (message != null) {
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

						// subject
						String subject = ezEmailUtil.getSubject(message);
						if (subject != null && !subject.equals("")) {
							String[] rawHeaders = message.getHeader("subject");
							String rawHeader = rawHeaders[0];

							if (!ezEmailUtil.isPureAscii(rawHeader)) {
								byte[] rawBytes = rawHeader.getBytes("iso-8859-1");

								subject = ezEmailUtil.decodeNonAsciiBytes(rawBytes);
							}
						}
						sb.append("<SUBJECT><![CDATA[" + subject + "]]></SUBJECT>");

						// from
						Address[] arrFroms = message.getFrom();
						String fromStr = "";
						if (arrFroms != null) {
							fromStr = ezEmailUtil.getFromNameOrAddressOfMessage(message);
							fromStr = commonUtil.trimDoubleQuotes(fromStr);
						} else {
							String[] fromHeaders = message.getHeader("From");
							if (fromHeaders != null) {
								fromStr = MimeUtility.decodeText(message.getHeader("From")[0]);
							}
						}
						sb.append("<FROMNAME>" + fromStr + "</FROMNAME>");

						// received date
						String dateStr = "";
						Date date = message.getReceivedDate();
						if (date != null) {
							SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
							sdf.setTimeZone(TimeZone.getTimeZone("GMT"));
							String receivedDateStr = sdf.format(date);

							dateStr = commonUtil.getDateStringInUTC(receivedDateStr, loginInfo.getOffset(), false);
						}
						sb.append("<DATE><![CDATA[" + dateStr + "]]></DATE>");

						List<Map<String, String>> attachedFileList = new ArrayList<Map<String, String>>();
						List<String> bodyInfoList = ezEmailUtil.getBodyInfo(message, folderPath, uid, -1, attachedFileList, locale, extraMap);

						String htmlBody = bodyInfoList.get(0);
						htmlBody = EgovStringUtil.getSpclStrCnvr(htmlBody);
						sb.append("<HTMLDESCRIPTION>" + htmlBody + "</HTMLDESCRIPTION>");

						//첨부파일 관련
						if (attachedFileList.size() > 0) {
							float attachLimitF = Float.parseFloat(attachLimit) * 1024 * 1024;
							float size = 0;

							for (int i=0; i<attachedFileList.size(); i++) {
								size += Float.parseFloat(attachedFileList.get(i).get("size"));
							}

							if (size > attachLimitF) { //첨부파일 제한크기 초과
								sb.append("<OVERSIZE />");
							} else {

								sb.append("<ROOT><NODES>");

								/* 2020-09-24 홍승비 - 게시판과 커뮤니티 메일게시 시 첨부파일 업로드 경로 분리 */
								String uploadTempPath = "";
								if (itemType.equals("board")) {
									uploadTempPath = "upload_board.TEMPUPLOADFILE";
								} else if (itemType.equals("community")) {
									uploadTempPath = "upload_community.TEMPUPLOADFILE";
								}

								String realPath = commonUtil.getRealPath(request);
								String path = commonUtil.getUploadPath(uploadTempPath, loginInfo.getTenantId());

								String attach = "";

								for (int i=0; i<attachedFileList.size(); i++) {
									MimeBodyPart part = (MimeBodyPart)ezEmailUtil.getAttachPart(message, i + 1);

									if (part != null) {
										// 동일한 이름의 첨부파일을 처리할 수 있도록 GUID를 직접 생성하는 것으로 수정함. (기존에는 XML 패러메터로 넘어오는 값을 사용).
										String newGuid = UUID.randomUUID().toString();
										newGuid = "{" + newGuid + "}";

										String orgFileName = attachedFileList.get(i).get("filename");
										String fileName = newGuid + "_" + orgFileName;
										fileName = commonUtil.detectPathTraversal(fileName);

										File file = new File(realPath + path);
										if (!file.exists()) {
											file.mkdirs();
										}

										part.saveFile(realPath + path + commonUtil.separator + fileName);
										logger.debug(fileName + " is saved to " + realPath + path + " temporarily.");

										attach += "tempUploadFile" + commonUtil.separator + fileName + "|";

										sb.append("<NODE>");
										sb.append("<PUPLOADSN><![CDATA[" + fileName + "]]></PUPLOADSN>");
										sb.append("<RESULTUPLOADA><![CDATA[true]]></RESULTUPLOADA>");
										sb.append("<PFILENAME><![CDATA[" + orgFileName + "]]></PFILENAME>");
										sb.append("<FILESIZE><![CDATA[" + attachedFileList.get(i).get("size") + "]]></FILESIZE>");
										sb.append("<FILELOCATION><![CDATA[" + path + "]]></FILELOCATION>");
										sb.append("</NODE>");
									}
								}

								sb.append("</NODES></ROOT>");
								sb.append("<ATTACH><![CDATA[" + attach + "]]></ATTACH>");
							}

						}
					}
					f.close(false);
				}
			}
			
		} catch (MessagingException e) {
			logger.error(e.getMessage(), e);
		} finally {
			if (ia != null) {
				ia.close();
			}
		}
		
		sb.append("</DATA>");
		
		logger.debug("mailReadBoard ended.");
		
		return sb.toString();
	}
	
	@RequestMapping(value="/ezEmail/mailReadBoardDotNet.do", method=RequestMethod.POST, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String mailReadBoardDotNet(@CookieValue("loginCookie") String loginCookie, Locale locale, @RequestBody String bodyData, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception{
		logger.debug("mailReadBoardDotNet started.");
		
		/*Document xmldom = commonUtil.convertStringToDocument(bodyData);
		String url = xmldom.getElementsByTagName("URL").item(0).getTextContent();*/
		String url = request.getParameter("url");
		String newGuid = UUID.randomUUID().toString();
		newGuid = "{" + newGuid + "}";
		
		logger.debug("url=" + url);

		url = (url != null) ? url : "";
		String folderPath = url.split("/")[0];
		String uidStr = url.split("/")[1];
		long uid = Long.parseLong(uidStr);
		
		List<String> userInfo = commonUtil.getUserIdAndPassword(loginCookie);
		String password  = userInfo.get(1);
		
		LoginVO loginInfo = commonUtil.userInfo(loginCookie);
		String domainName = ezCommonService.getTenantConfig("DomainName", loginInfo.getTenantId());
		String userAccount = loginInfo.getId() + "@" + domainName;
		Map<String, Object> extraMap = new HashMap<String, Object>();
		String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", loginInfo.getTenantId());

		if (useSharedMailbox.equals("YES")) {
			String shareId = request.getParameter("shareId");
			logger.debug("shareId=" + shareId);
			
			if (shareId != null) {
				if (!ezEmailService.checkUserShareId(loginInfo.getId(), shareId, loginInfo.getTenantId())) {
					logger.debug("the user cannot access the shareId.");
					logger.debug("mailReadBoardDotNet ended.");
					
					return "";
				}
				
				userAccount = shareId + "@" + domainName;
				extraMap.put("shareId", shareId);
			}
		}
		
		logger.debug("userId=" + loginInfo.getId() + ",userAccount=" + userAccount);
		
		StringBuilder sb = new StringBuilder();
		sb.append("<DATA>");
		
		IMAPAccess ia = null;
		try {
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userAccount, password, egovMessageSource, locale, ezEmailUtil);

			if (ia != null){
				Folder f = ia.getFolder(folderPath != null ? folderPath : "");

				if (f != null && f.exists()) {
					f.open(Folder.READ_ONLY);
					Message message = ((IMAPFolder)f).getMessageByUID(uid);

					if (message != null) {
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

						// subject
						String subject = ezEmailUtil.getSubject(message);
						if (subject != null && !subject.equals("")) {
							String[] rawHeaders = message.getHeader("subject");
							String rawHeader = rawHeaders[0];

							if (!ezEmailUtil.isPureAscii(rawHeader)) {
								byte[] rawBytes = rawHeader.getBytes("iso-8859-1");

								subject = ezEmailUtil.decodeNonAsciiBytes(rawBytes);
							}
						}
						sb.append("<SUBJECT><![CDATA[" + subject + "]]></SUBJECT>");

						// from
						Address[] arrFroms = message.getFrom();
						String fromStr = "";
						if (arrFroms != null) {
							fromStr = ezEmailUtil.getFromNameOrAddressOfMessage(message);
							fromStr = commonUtil.trimDoubleQuotes(fromStr);
						} else {
							String[] fromHeaders = message.getHeader("From");
							if (fromHeaders != null) {
								fromStr = MimeUtility.decodeText(message.getHeader("From")[0]);
							}
						}
						sb.append("<FROMNAME>" + fromStr + "</FROMNAME>");

						// received date
						String dateStr = "";
						Date date = message.getReceivedDate();
						if (date != null) {
							SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
							sdf.setTimeZone(TimeZone.getTimeZone("GMT"));
							String receivedDateStr = sdf.format(date);

							dateStr = commonUtil.getDateStringInUTC(receivedDateStr, loginInfo.getOffset(), false);
						}
						sb.append("<DATE><![CDATA[" + dateStr + "]]></DATE>");

						List<Map<String, String>> attachedFileList = new ArrayList<Map<String, String>>();
						List<String> bodyInfoList = ezEmailUtil.getBodyInfo(message, folderPath, uid, -1, attachedFileList, locale, extraMap);

						String htmlBody = bodyInfoList.get(0);
						htmlBody = EgovStringUtil.getSpclStrCnvr(htmlBody);

						String serverUri = request.getScheme()
								+ "://"
								+ request.getServerName()
								+ ("http".equals(request.getScheme())
								&& request.getServerPort() == 80
								|| "https".equals(request.getScheme())
								&& request.getServerPort() == 443 ? "" : ":"
								+ request.getServerPort());

						htmlBody = htmlBody.replaceAll("/ezEmail/downloadInline.do\\?",
								serverUri + "/ezEmail/downloadInlineDotNet.do?userId=" + URLEncoder.encode(loginInfo.getId(), "UTF-8") + "&amp;");
						sb.append("<HTMLDESCRIPTION>" + htmlBody + "</HTMLDESCRIPTION>");

						//첨부파일 관련
						if (attachedFileList.size() > 0) {
//						float attachLimitF = Float.parseFloat(attachLimit) * 1024 * 1024;
							@SuppressWarnings("unused")
							float size = 0;

							for (int i=0; i<attachedFileList.size(); i++) {
								size += Float.parseFloat(attachedFileList.get(i).get("size"));
							}

//						if (size > attachLimitF) { //첨부파일 제한크기 초과
//							sb.append("<OVERSIZE />");
//						} else {

							sb.append("<ROOT><NODES>");

							String realPath = commonUtil.getRealPath(request);
							String path = "/Upload_BoardSTD/TempUploadFile";

							String attach = "";

							for (int i=0; i<attachedFileList.size(); i++) {
								MimeBodyPart part = (MimeBodyPart)ezEmailUtil.getAttachPart(message, i + 1);

								if (part != null) {
									String orgFileName = attachedFileList.get(i).get("filename");
									String fileName = newGuid + "_" + orgFileName;
									fileName = commonUtil.detectPathTraversal(fileName);

									File file = new File(realPath + path);
									if (!file.exists()) {
										file.mkdirs();
									}

									part.saveFile(realPath + path + commonUtil.separator + fileName);
									logger.debug(fileName + " is saved to " + realPath + path + " temporarily.");

									attach += "TempUploadFile" + commonUtil.separator + fileName + "|";

									sb.append("<NODE>");
									sb.append("<PUPLOADSN><![CDATA[" + fileName + "]]></PUPLOADSN>");
									sb.append("<RESULTUPLOADA><![CDATA[true]]></RESULTUPLOADA>");
									sb.append("<PFILENAME><![CDATA[" + orgFileName + "]]></PFILENAME>");
									sb.append("<FILESIZE><![CDATA[" + attachedFileList.get(i).get("size") + "]]></FILESIZE>");
									sb.append("<FILELOCATION><![CDATA[" + path + "]]></FILELOCATION>");
									sb.append("</NODE>");
								}
							}

							sb.append("</NODES></ROOT>");
							sb.append("<ATTACH><![CDATA[" + attach + "]]></ATTACH>");
//						}
						}
					}
					f.close(false);
				}
			}
			
		} catch (MessagingException e) {
			logger.error(e.getMessage(), e);
		} finally {
			if (ia != null) {
				ia.close();
			}
		}
		
		sb.append("</DATA>");
		
		String dotNetIntegration = ezCommonService.getTenantConfig("dotNetIntegration", loginInfo.getTenantId());
		
		if (dotNetIntegration.equals("YES")) {
			String dotNetUrl = ezCommonService.getTenantConfig("dotNetUrl", loginInfo.getTenantId());
			
			response.setHeader("Access-Control-Allow-Origin", dotNetUrl);
			response.setHeader("Access-Control-Allow-Credentials", "true");
			response.setHeader("Access-Control-Allow-Methods", "GET,POST");
			response.setHeader("Access-Control-Allow-Headers", "Content-Type");
		}
		
		logger.debug("mailReadBoardDotNet ended.");
		
		return sb.toString();
	}
	
	/**
	 * 보안메일 읽기화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/readSecureMail.do", method=RequestMethod.POST)
	public String readSecureMail(HttpServletRequest request, Model model) throws Exception{
		logger.debug("readSecureMail started.");
		
		IMAPAccess ia = null;
		FileOutputStream fos = null;
		FileInputStream fis = null;
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
		String subject = null;
		String dateStr = null;
		String readCountStr = null;
		String readDateStr = null;
		String title = null;
		String pIsCCFg = "Y";
		String secureKey = null;
		String securePassword = null;
		
		try {
			secureKey = request.getParameter("secureKey");
			boolean useKlibEncrypt = "YES".equalsIgnoreCase(config.getProperty("config.useKlibEncrypt"));
			if (secureKey != null){
				secureKey = ezEmailService.decryptSecureValue(secureKey,useKlibEncrypt);
			}
			securePassword = request.getParameter("securePassword");
			logger.debug("secureKey=" + secureKey + ",password=" + securePassword);

			if (secureKey == null){
				throw new Exception("SecureKey is null");
			}
			String[] secureArr = secureKey.split("/");
			String reader = secureArr[0];
			String secureId = secureArr[1];
			String sender = secureArr[2];
			logger.debug("reader=" + reader + ",secureId=" + secureId + ",sender=" + sender);

			// secureKey, securePassword는 메일 본문내용 호출에 쓰이기 때문에 다시 암호화 사용
			secureKey = request.getParameter("secureKey");
			securePassword = ezEmailService.encryptSecureValue(securePassword, useKlibEncrypt);
			
			int result = ezEmailService.checkSecureMailPassword(secureId, reader, securePassword);
			logger.debug("result=" + result);
			
			if (result != 0) {
				String message = null;
				
				String userId = sender.split("@")[0];
				String domainName = sender.split("@")[1];
				int tenantId = ezCommonService.getTenantIdByDomainName(domainName);
				String lang = ezCommonService.selectUserGetLang(userId, tenantId);
				Locale locale = new Locale(commonUtil.getTwoLetterLangFromLangNum(lang));
				logger.debug("tenantId=" + tenantId + ",lang=" + lang);
				
				switch (result) {
					case -1 : 
						message = egovMessageSource.getMessage("ezEmail.lhm50", locale);
						break;
					case -2 : 
						message = egovMessageSource.getMessage("ezEmail.lhm51", locale);
						break;
					case -3 : 
						message = egovMessageSource.getMessage("ezEmail.lhm52", locale);
						break;
					case -4 : 
						message = egovMessageSource.getMessage("ezEmail.lhm53", locale);
						break;
					default : 
						message = egovMessageSource.getMessage("ezEmail.lhm54", locale);
						break;
				}
				
				model.addAttribute("message", message);
				return "ezEmail/mailReadSecureDenial";
			}
			
			MailSecureVO secureInfo = ezEmailService.getSecureMailInfo(secureId, reader);
			logger.debug("secureInfo=" + secureInfo.toString());
			
			String userAccount = secureInfo.getUserAccount();
			String folderPath = secureInfo.getFolderPath();
			long uid = Long.parseLong(secureInfo.getMailUid());
			int maxReadCount = Integer.parseInt(secureInfo.getMaxReadCount());
			int readCount = Integer.parseInt(secureInfo.getReadCount());
			String maxReadDate = secureInfo.getMaxReadDate();
			logger.debug("userAccount=" + userAccount + ",folderPath=" + folderPath + ",uid=" + uid
					+ ",maxReadCount=" + maxReadCount + ",maxReadDate=" + maxReadDate + ",readCount=" + readCount);
			
			String userId = userAccount.split("@")[0];
			String domainName = userAccount.split("@")[1];
			int tenantId = ezCommonService.getTenantIdByDomainName(domainName);
			String lang = ezCommonService.selectUserGetLang(userId, tenantId);
			Locale locale = new Locale(commonUtil.getTwoLetterLangFromLangNum(lang));
			logger.debug("tenantId=" + tenantId + ",lang=" + lang);
			
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userAccount, jspw, egovMessageSource, locale, ezEmailUtil);
			Folder f = ia.getFolder(folderPath);
			
			if (f == null || !f.exists()) {
				logger.error("Folder not found. folderPath=" + folderPath);
			} else {
				f.open(Folder.READ_WRITE);
				Message message = ((IMAPFolder)f).getMessageByUID(uid);
				
				if (message == null) {
					logger.error("Message not found. uid=" + uid);
				} else {
					Multipart multipart = (Multipart)message.getContent();
					MimeBodyPart part = (MimeBodyPart)multipart.getBodyPart(2);
					
					String realPath = commonUtil.getRealPath(request);
					String pDirPath = realPath + commonUtil.getUploadPath("upload_mail.ROOT", tenantId) + commonUtil.separator + "tempFileUpload";
		        	
					File file = new File(pDirPath + commonUtil.separator + UUID.randomUUID().toString());
					fos = new FileOutputStream(file);
					part.saveFile(file);
					
					File decryptedFile = new File(pDirPath + commonUtil.separator + UUID.randomUUID().toString());
					if (!useKlibEncrypt) {
						egovFileScrty.cryptFile(Cipher.DECRYPT_MODE, file, decryptedFile);
					} else {
						byte[] bytes = commonUtil.readBytesFromFile(file.toPath());
						commonUtil.writeBytesToFile(decryptedFile.toPath(),klibUtil.decrypt(bytes));
					}
					
					// 임시파일 삭제
					if (file.delete()) {
						logger.debug("file is deleted. fileName=" + file.getName());
					}
					
					SMTPAccess sa = SMTPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.SMTPPort"),
							secureInfo.getUserAccount(), jspw);
					
					fis = new FileInputStream(decryptedFile);
					message = sa.readMimeMessage(fis);
					
					// 개별발송 header
					String eachMailstr = message.getHeader("X-JMocha-Each-Mail") == null ? "": message.getHeader("X-JMocha-Each-Mail")[0];
					boolean eachMail ="true".equalsIgnoreCase(eachMailstr);
					
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
					logger.debug("From=" + fromStr);
					
					// TO
					arrRecipientsTo = message.getRecipients(Message.RecipientType.TO);
					if(arrRecipientsTo != null){
						boolean toListme = false;
						
						for(int i=0; i<arrRecipientsTo.length; i++){
							if(((InternetAddress)arrRecipientsTo[i]).getAddress().equals(userAccount)){
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
							
							logger.debug("TO=" + name + ((InternetAddress)arrRecipientsTo[i]).getAddress());
							
							//개별발신일때는 reader만 to에 보이게 설정
							if (eachMail && reader.equalsIgnoreCase(((InternetAddress) arrRecipientsTo[i]).getAddress())) {
								toStr = getReceiverHTML(name, ((InternetAddress) arrRecipientsTo[i]).getAddress(), true);
								break;
							}
							
							if(toListme){
								if(((InternetAddress)arrRecipientsTo[i]).getAddress().equals(userAccount)){
									if(arrRecipientsTo.length > 1){
										toStr = getReceiverHTML(name, ((InternetAddress)arrRecipientsTo[i]).getAddress(), true) + "<span>&nbsp;(" + egovMessageSource.getMessage("ezEmail.t10000", locale) + arrRecipientsTo.length + egovMessageSource.getMessage("ezEmail.t10001", locale) + ")&nbsp;<img src='/images/expnd.gif'  style='cursor:pointer;' onclick='ShowHiddenTo(this);' align='absmiddle'></span>";
									} else {
										toStr = getReceiverHTML(name, ((InternetAddress)arrRecipientsTo[i]).getAddress(), true);
									}
								}
								if(toHiddenStr == null){
									toHiddenStr = getReceiverHTML(name, ((InternetAddress)arrRecipientsTo[i]).getAddress(), true);
								} else{
									toHiddenStr += " , " + getReceiverHTML(name, ((InternetAddress)arrRecipientsTo[i]).getAddress(), true);
								}
							} else {
								if(i == 0){
									if(arrRecipientsTo.length > 1){
										toStr = getReceiverHTML(name, ((InternetAddress)arrRecipientsTo[i]).getAddress(), true) + "<span>&nbsp;(" + egovMessageSource.getMessage("ezEmail.t10000", locale) + arrRecipientsTo.length + egovMessageSource.getMessage("ezEmail.t10001", locale) + ")&nbsp;<img src='/images/expnd.gif'  style='cursor:pointer;' onclick='ShowHiddenTo(this);' align='absmiddle'></span>";
									} else {
										toStr = getReceiverHTML(name, ((InternetAddress)arrRecipientsTo[i]).getAddress(), true);
									}
								}
								if(toHiddenStr == null){
									toHiddenStr = getReceiverHTML(name, ((InternetAddress)arrRecipientsTo[i]).getAddress(), true);
								} else {
									toHiddenStr += " , " + getReceiverHTML(name, ((InternetAddress)arrRecipientsTo[i]).getAddress(), true);
								}
							}
						}
					}
					
					// CC
					arrRecipientsCC = message.getRecipients(Message.RecipientType.CC);
					if(arrRecipientsCC != null){
						boolean ccListme = false;
						for(int i=0; i<arrRecipientsCC.length; i++){
							if(((InternetAddress)arrRecipientsCC[i]).getAddress().equals(userAccount)){
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

							logger.debug("CC=" + name + ((InternetAddress) arrRecipientsCC[i]).getAddress());

							//개별발신일때 자신이 참조자로 들어갔으면 TO자리에 자신을 넣어주는 작업
							if (eachMail) {
								String ccAddress = ((InternetAddress) arrRecipientsCC[i]).getAddress();
								if (reader.equalsIgnoreCase(ccAddress)) {
									toStr = getReceiverHTML(name, ccAddress, true);
									break;
								}
							} else {
								if (ccListme) {
									if (((InternetAddress) arrRecipientsCC[i]).getAddress().equals(userAccount)) {
										if (arrRecipientsCC.length > 1) {
											ccStr = getReceiverHTML(name, ((InternetAddress) arrRecipientsCC[i]).getAddress(), true) + "<span>&nbsp;(" + egovMessageSource.getMessage("ezEmail.t10000", locale) + arrRecipientsCC.length + egovMessageSource.getMessage("ezEmail.t10001", locale) + ")&nbsp;<img src='/images/expnd.gif'  style='cursor:pointer;' onclick='ShowHiddenCc(this);' align='absmiddle'></span>";
										} else {
											ccStr = getReceiverHTML(name, ((InternetAddress) arrRecipientsCC[i]).getAddress(), true);
										}
									}
									if (ccHiddenStr == null) {
										ccHiddenStr = getReceiverHTML(name, ((InternetAddress) arrRecipientsCC[i]).getAddress(), true);
									} else {
										ccHiddenStr += " , " + getReceiverHTML(name, ((InternetAddress) arrRecipientsCC[i]).getAddress(), true);
									}
								} else {
									if (i == 0) {
										if (arrRecipientsCC.length > 1) {
											ccStr = getReceiverHTML(name, ((InternetAddress) arrRecipientsCC[i]).getAddress(), true) + "<span>&nbsp;(" + egovMessageSource.getMessage("ezEmail.t10000", locale) + arrRecipientsCC.length + egovMessageSource.getMessage("ezEmail.t10001", locale) + ")&nbsp;<img src='/images/expnd.gif'  style='cursor:pointer;' onclick='ShowHiddenCc(this);' align='absmiddle'></span>";
										} else {
											ccStr = getReceiverHTML(name, ((InternetAddress) arrRecipientsCC[i]).getAddress(), true);
										}
									}
									if (ccHiddenStr == null) {
										ccHiddenStr = getReceiverHTML(name, ((InternetAddress) arrRecipientsCC[i]).getAddress(), true);
									} else {
										ccHiddenStr += " , " + getReceiverHTML(name, ((InternetAddress) arrRecipientsCC[i]).getAddress(), true);
									}
								}
							}
						}
					}
	
					if (ccStr == null || ccStr.equals("")) {
						pIsCCFg = "N";
					}

					// BCC : 숨은참조일때는 
					arrRecipientsBCC = message.getRecipients(Message.RecipientType.BCC);
					if(arrRecipientsBCC != null) {
						boolean bccListme = false;
						for (int i = 0; i < arrRecipientsBCC.length; i++) {
							if (((InternetAddress) arrRecipientsBCC[i]).getAddress().equals(userAccount)) {
								bccListme = true;
								break;
							}
						}

						String bccHeader = message.getHeader("BCc")[0];
						boolean isAscii = ezEmailUtil.isPureAscii(bccHeader);
						String name = null;

						for (int i = 0; i < arrRecipientsBCC.length; i++) {
							name = ((InternetAddress) arrRecipientsBCC[i]).getPersonal();
							if (name == null) {
								name = ((InternetAddress) arrRecipientsBCC[i]).getAddress();
							} else {
								if (!isAscii) {
									byte[] rawBytes = name.getBytes("iso-8859-1");

									name = ezEmailUtil.decodeNonAsciiBytes(rawBytes);
								} else {
									name = MimeUtility.decodeText(name);
								}

								name = commonUtil.trimDoubleQuotes(name);
							}

							logger.debug("BCC=" + name + ((InternetAddress) arrRecipientsBCC[i]).getAddress());

							//개별발신일때 자신이 숨은참조자로 들어갔으면 TO자리에 자신을 넣어주는 작업
							if (eachMail && reader.equalsIgnoreCase(((InternetAddress) arrRecipientsBCC[i]).getAddress())) {
								toStr = getReceiverHTML(name, ((InternetAddress) arrRecipientsBCC[i]).getAddress(), true);
								break;
							}
						}
					}
					
					// sent date
					date = message.getSentDate();
					if (date != null) {
						SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm (z)");
						dateStr = sdf.format(date);
					}
					logger.debug("dateStr=" + dateStr);
					
					// subject
					subject = ezEmailUtil.getSubject(message);
					if(subject == null || subject.trim().equals("")){
						subject = egovMessageSource.getMessage("ezEmail.kms03", locale);
					}
					
					subject = commonUtil.cleanValue(subject);
					title = egovMessageSource.getMessage("ezEmail.t565", locale) + subject;
					logger.debug("subject=" + subject);
					
					// readCountStr
					if (maxReadCount == 0) {
						readCountStr = egovMessageSource.getMessage("ezEmail.lhm67", locale);
					} else {
						readCountStr = maxReadCount + egovMessageSource.getMessage("ezEmail.lhm55", locale) 
							+ " <span style=\"color:red\">" + (maxReadCount - readCount - 1) + egovMessageSource.getMessage("ezEmail.lhm56", locale) + "</span>";
					}
					
					// readDateStr
					if (maxReadDate == null) {
						readDateStr = egovMessageSource.getMessage("ezEmail.lhm67", locale);
					} else {
						SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
						sdf.setTimeZone(TimeZone.getTimeZone("GMT"));
						date = sdf.parse(maxReadDate);
						sdf.applyPattern("yyyy-MM-dd HH:mm (z)");
						sdf.setTimeZone(TimeZone.getDefault());
						maxReadDate = sdf.format(date);
						
						readDateStr = "<span style=\"color:red\">" + maxReadDate + "</span> " + egovMessageSource.getMessage("ezEmail.lhm37", locale);
					}
					
					// 임시파일 삭제
					if (decryptedFile.delete()) {
						logger.debug("decryptedFile is deleted. fileName=" + decryptedFile.getName());
					}
					
					model.addAttribute("main.default.css", egovMessageSource.getMessage("main.default.css", locale));
					model.addAttribute("e1", egovMessageSource.getMessage("ezEmail.e1", locale));
					model.addAttribute("t63", egovMessageSource.getMessage("ezEmail.t63", locale));
					model.addAttribute("t161", egovMessageSource.getMessage("ezEmail.t161", locale));
					model.addAttribute("t704", egovMessageSource.getMessage("ezEmail.t704", locale));
					model.addAttribute("t66", egovMessageSource.getMessage("ezEmail.t66", locale));
					model.addAttribute("lhm65", egovMessageSource.getMessage("ezEmail.lhm65", locale));
					model.addAttribute("t555", egovMessageSource.getMessage("ezEmail.t555", locale));
					model.addAttribute("t556", egovMessageSource.getMessage("ezEmail.t556", locale));
					model.addAttribute("lhm66", egovMessageSource.getMessage("ezEmail.lhm66", locale));
				}
			}
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		} finally {
			if (fis != null) {
				try { fis.close();
				} catch (IOException e) {logger.debug("e.message=" + e.getMessage());
				} catch (Exception e) {logger.debug("e.message=" + e.getMessage());}
			}
			if (fos != null) {
				try { fos.close(); 
				} catch (IOException e) {logger.debug("e.message=" + e.getMessage());
				} catch (Exception e) {logger.debug("e.message=" + e.getMessage());}
			}
			if (ia != null) {
				try { ia.close(); 
				} catch (RuntimeException e) {logger.debug("e.message=" + e.getMessage());
				} catch (Exception e) {logger.debug("e.message=" + e.getMessage());}
			}
		}
		
		model.addAttribute("fromStr", fromStr);
		model.addAttribute("fromEmail", fromEmail);
		model.addAttribute("url", "");
		model.addAttribute("toStr", toStr);
		model.addAttribute("toHiddenStr", toHiddenStr);
		model.addAttribute("ccStr", ccStr);
		model.addAttribute("ccHiddenStr", ccHiddenStr);
		model.addAttribute("dateStr", dateStr);
		model.addAttribute("subject", subject);
		model.addAttribute("readCountStr", readCountStr);
		model.addAttribute("readDateStr", readDateStr);
		model.addAttribute("title", title);
		model.addAttribute("secureKey", secureKey);
		model.addAttribute("securePassword", securePassword);
		model.addAttribute("pIsCCFg", pIsCCFg);
		
		logger.debug("readSecureMail ended.");
		return "ezEmail/mailReadSecure";
	}
	
	/**
	 * 보안메일 첨부파일 다운로드 실행 함수
	 */
	@RequestMapping(value="/ezEmail/downloadSecureAttach.do", method=RequestMethod.GET)
	@ResponseBody
	public void downloadSecureAttach(HttpServletRequest request, HttpServletResponse response) throws Exception{
		logger.debug("downloadSecureAttach started.");
		
		IMAPAccess ia = null;
		FileOutputStream fos = null;
		FileInputStream fis = null;
		
		try {
			String secureKey = request.getParameter("secureKey");
			boolean useKlibEncrypt = "YES".equalsIgnoreCase(config.getProperty("config.useKlibEncrypt"));
			if (secureKey != null){
				secureKey = ezEmailService.decryptSecureValue(secureKey,useKlibEncrypt);
			}
			String securePassword = request.getParameter("securePassword");
			String indexStr = request.getParameter("index");
			String filename = request.getParameter("filename");
			logger.debug("secureKey=" + secureKey + ",securePassword=" + securePassword + ",indexStr=" + indexStr + ",filename=" + filename);

			if (secureKey == null){
				throw new Exception("SecureKey is null");
			}
			String reader = secureKey.split("/")[0];
			String secureId = secureKey.split("/")[1];
			logger.debug("reader=" + reader + ",secureId=" + secureId);
			
			int result = ezEmailService.checkSecureMailPassword(secureId, reader, securePassword);
			logger.debug("result=" + result);

			String readStatus = request.getParameter("readStatus");
			logger.debug("readStatus=" + readStatus);

			if (result == 0) {
				MailSecureVO secureInfo = ezEmailService.getSecureMailInfo(secureId, reader);
				String userAccount = secureInfo.getUserAccount();
				String folderPath = secureInfo.getFolderPath();
				String uidStr = secureInfo.getMailUid();
				long uid = Long.parseLong(uidStr);
				int index = Integer.parseInt(indexStr);
				logger.debug("userAccount=" + userAccount + ",folderPath=" + folderPath + ",uid=" + uid + ",index=" + index);
				
				String userId = userAccount.split("@")[0];
				String domainName = userAccount.split("@")[1];
				int tenantId = ezCommonService.getTenantIdByDomainName(domainName);
				String lang = ezCommonService.selectUserGetLang(userId, tenantId);
				Locale locale = new Locale(commonUtil.getTwoLetterLangFromLangNum(lang));
				logger.debug("tenantId=" + tenantId + ",lang=" + lang);
				
				ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
						userAccount, jspw, egovMessageSource, locale, ezEmailUtil);
		
				Folder f = ia.getFolder(folderPath);
				
				if (f == null || !f.exists()) {
					logger.error("Folder not found. folderPath=" + folderPath);
				} else {
					f.open(Folder.READ_ONLY);
					Message message = null;
					if(f.isOpen() && f instanceof IMAPFolder){
						message = ((IMAPFolder)f).getMessageByUID(uid);
					}
					
					if (message == null) {
						logger.error("Message not found. uid=" + uid);
					} else {
						
						Multipart multipart = (Multipart)message.getContent();
						MimeBodyPart originalPart = (MimeBodyPart)multipart.getBodyPart(2);
						
						String realPath = commonUtil.getRealPath(request);
						String pDirPath = realPath + commonUtil.getUploadPath("upload_mail.ROOT", tenantId) + commonUtil.separator + "tempFileUpload";
			        	
						File file = new File(pDirPath + commonUtil.separator + UUID.randomUUID().toString());
						File decryptedFile = new File(pDirPath + commonUtil.separator + UUID.randomUUID().toString());
						fos = new FileOutputStream(file);
						originalPart.saveFile(file);

						if (!useKlibEncrypt) {
							egovFileScrty.cryptFile(Cipher.DECRYPT_MODE, file, decryptedFile);
						} else {
							byte[] bytes = commonUtil.readBytesFromFile(file.toPath());
							commonUtil.writeBytesToFile(decryptedFile.toPath(),klibUtil.decrypt(bytes));
						}
						
						// 임시파일 삭제
						if (file.delete()) {
							logger.debug("file is deleted. fileName=" + file.getName());
						}
						
						SMTPAccess sa = SMTPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.SMTPPort"),
								secureInfo.getUserAccount(), jspw);
						
						fis = new FileInputStream(decryptedFile);
						message = sa.readMimeMessage(fis);
						
						Part part = null;
						if (index == -1) {
							part = message;
						} else {
							part = ezEmailUtil.getAttachPart(message, index);
						}
						
						if (part == null) {
							logger.error("AttachPart not found. AttachPartIndex=" + index);
						} else {
							response.setContentType(part.getContentType());
							
							filename = CommonUtil.getEncodedFileNameForDownload(request.getHeader("User-Agent"), filename);

							if ("Y".equals(readStatus)) {
								response.addHeader("content-disposition", "inline; filename=\"" + filename + "\"");
								logger.debug("content-disposition=" + "inline; filename=\"" + filename + "\"");
							} else {
								response.addHeader("content-disposition", "attachment; filename=\"" + filename + "\"");
								logger.debug("content-disposition=" + "attachment; filename=\"" + filename + "\"");
							}

							InputStream input = null;
							OutputStream output = null;

							try {
								input = part.getInputStream();
								output = response.getOutputStream();

								byte[] buffer = new byte[4096];
								int byteRead;

								while ((byteRead = input.read(buffer)) != -1) {
									output.write(buffer, 0, byteRead);
								}
							} catch(IOException e) {
								logger.debug("e.message=" + e.getMessage());
							} finally {
								if (ia != null) {
									ia.close();
								}
								if (input != null) {
									try { input.close(); } catch (IOException e) {logger.debug("e.message=" + e.getMessage());}
								}
								if (output != null) {
									try { output.flush(); } catch (IOException e) {logger.debug("e.message=" + e.getMessage());}
									try { output.close(); } catch (IOException e) {logger.debug("e.message=" + e.getMessage());}
								}
							}
						}

						// 임시파일 삭제
						if (decryptedFile.delete()) {
							logger.debug("decryptedFile is deleted. fileName=" + decryptedFile.getName());
						}
					}
				}
			}
		} catch (MessagingException e) {
			logger.error(e.getMessage(), e);
		} finally {
			if (fis != null) {
				try { fis.close(); 
				} catch (IOException e) {logger.debug("e.message=" + e.getMessage());
				} catch (Exception e) {logger.debug("e.message=" + e.getMessage());}
			}
			if (fos != null) {
				try { fos.close(); 
				} catch (IOException e) {logger.debug("e.message=" + e.getMessage());
				} catch (Exception e) {logger.debug("e.message=" + e.getMessage());}
			}
			if (ia != null) {
				try { ia.close(); 
				} catch (RuntimeException e) {logger.debug("e.message=" + e.getMessage());
				} catch (Exception e) {logger.debug("e.message=" + e.getMessage());}
			}
		}
		
		logger.debug("downloadSecureAttach ended.");
	}

	/**
	 * 보안메일 인라인 이미지 읽어오기 실행 함수
	 */
	@RequestMapping(value="/ezEmail/downloadSecureInline.do", method=RequestMethod.GET)
	@ResponseBody
	public void downloadSecureInline(HttpServletRequest request, HttpServletResponse response) throws Exception{
		logger.debug("downloadSecureInline started.");
		
		IMAPAccess ia = null;
		FileOutputStream fos = null;
		FileInputStream fis = null;
		
		try {
			String secureKey = request.getParameter("secureKey");
			boolean useKlibEncrypt = "YES".equalsIgnoreCase(config.getProperty("config.useKlibEncrypt"));
			if (secureKey != null){
				secureKey = ezEmailService.decryptSecureValue(secureKey,useKlibEncrypt);
			}
			String securePassword = request.getParameter("securePassword");
			String contentId = request.getParameter("contentId");
			logger.debug("secureKey=" + secureKey + ",securePassword=" + securePassword + ",contentId=" + contentId);
			if (secureKey == null){
				throw new Exception("SecureKey is null");
			}
			String reader = secureKey.split("/")[0];
			String secureId = secureKey.split("/")[1];
			logger.debug("reader=" + reader + ",secureId=" + secureId);
			
			int result = ezEmailService.checkSecureMailPassword(secureId, reader, securePassword);
			logger.debug("result=" + result);
			
			if (result == 0) {
				MailSecureVO secureInfo = ezEmailService.getSecureMailInfo(secureId, reader);
				String userAccount = secureInfo.getUserAccount();
				String folderPath = secureInfo.getFolderPath();
				String uidStr = secureInfo.getMailUid();
				long uid = Long.parseLong(uidStr);
				if (contentId != null){
					contentId = EgovStringUtil.getHtmlStrCnvr(contentId);
				}
				logger.debug("userAccount=" + userAccount + ",folderPath=" + folderPath + ",uid=" + uid + ",contentId=" + contentId);
				
				String userId = userAccount.split("@")[0];
				String domainName = userAccount.split("@")[1];
				int tenantId = ezCommonService.getTenantIdByDomainName(domainName);
				String lang = ezCommonService.selectUserGetLang(userId, tenantId);
				Locale locale = new Locale(commonUtil.getTwoLetterLangFromLangNum(lang));
				logger.debug("tenantId=" + tenantId + ",lang=" + lang);
				
				ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
						userAccount, jspw, egovMessageSource, locale, ezEmailUtil);
		
				Folder f = ia.getFolder(folderPath);
				if (f == null || !f.exists()) {
					logger.error("Folder not found. folderPath=" + folderPath);
				} else {
					f.open(Folder.READ_ONLY);
					Message message = null;
					if(f.isOpen() && f instanceof IMAPFolder){
						message = ((IMAPFolder)f).getMessageByUID(uid);
					}
					
					if (message == null) {
						logger.error("Message not found. uid=" + uid);
					} else {
						Multipart multipart = (Multipart)message.getContent();
						MimeBodyPart originalPart = (MimeBodyPart)multipart.getBodyPart(2);
						
						String realPath = commonUtil.getRealPath(request);
						String pDirPath = realPath + commonUtil.getUploadPath("upload_mail.ROOT", tenantId) + commonUtil.separator + "tempFileUpload";
			        	
						File file = new File(pDirPath + commonUtil.separator + UUID.randomUUID().toString());
						File decryptedFile = new File(pDirPath + commonUtil.separator + UUID.randomUUID().toString());
						fos = new FileOutputStream(file);
						originalPart.saveFile(file);

						if (!useKlibEncrypt) {
							egovFileScrty.cryptFile(Cipher.DECRYPT_MODE, file, decryptedFile);
						} else {
							byte[] bytes = commonUtil.readBytesFromFile(file.toPath());
							commonUtil.writeBytesToFile(decryptedFile.toPath(),klibUtil.decrypt(bytes));
						}
						
						// 임시파일 삭제
						if (file.delete()) {
							logger.debug("file is deleted. fileName=" + file.getName());
						}
						
						SMTPAccess sa = SMTPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.SMTPPort"),
								secureInfo.getUserAccount(), jspw);
						
						fis = new FileInputStream(decryptedFile);
						message = sa.readMimeMessage(fis);
						
						Part part = ezEmailUtil.getInlinePart(message, contentId);
						
						if (part == null) {
							logger.error("InlinePart not found. contentId=" + contentId);
						} else {
							response.setContentType(part.getContentType());
							response.addHeader("content-disposition", "inline");
							InputStream input = part.getInputStream();
							OutputStream output = response.getOutputStream();
							byte[] buffer = new byte[4096];
							int byteRead;
							try{
								while ((byteRead = input.read(buffer)) != -1) {
									output.write(buffer, 0, byteRead);
								}
							} catch(IOException e){
								try {
									output.close();
								} catch (IOException e1) {
									logger.debug("e.message=" + e1.getMessage());
								}
								
								if (ia != null) {
									ia.close();
								}
								
								return;
							}
		
							try {
								output.flush();
							} catch (IOException e) {
								logger.debug("e.message=" + e.getMessage());
							}
							
							try {
								output.close();
							} catch (IOException e) {
								logger.debug("e.message=" + e.getMessage());
							}
						}
						
						// 임시파일 삭제
						if (decryptedFile.delete()) {
							logger.debug("decryptedFile is deleted. fileName=" + decryptedFile.getName());
						}
					}
				}
			}
		} catch (MessagingException e) {
			logger.error(e.getMessage(), e);
		} finally {
			if (fis != null) {
				try { fis.close(); 
				} catch (IOException e) {logger.debug("e.message=" + e.getMessage());
				} catch (Exception e) {logger.debug("e.message=" + e.getMessage());}
			}
			if (fos != null) {
				try { fos.close();
				} catch (IOException e) {logger.debug("e.message=" + e.getMessage());
				} catch (Exception e) {logger.debug("e.message=" + e.getMessage());}
			}
			if (ia != null) {
				try { ia.close(); 
				} catch (RuntimeException e) {logger.debug("e.message=" + e.getMessage());
				} catch (Exception e) {logger.debug("e.message=" + e.getMessage());}
			}
		}
		
		logger.debug("downloadSecureInline ended.");
	}

	/**
	 * 보안메일 원본내용 읽기화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/readSecureMailContent.do", method=RequestMethod.POST)
	public String readSecureMailContent(HttpServletRequest request, Model model) throws Exception{
		logger.debug("readSecureMailContent started.");
		
		IMAPAccess ia = null;
		FileOutputStream fos = null;
		FileInputStream fis = null;
		List<String> bodyInfoList = null;
		String pAttachListHtmlSub = null;
		
		try {
			String secureKey = request.getParameter("secureKey");
			boolean useKlibEncrypt = "YES".equalsIgnoreCase(config.getProperty("config.useKlibEncrypt"));
			if (secureKey != null){
				secureKey = ezEmailService.decryptSecureValue(secureKey,useKlibEncrypt);
			
			}
			String securePassword = request.getParameter("securePassword");
			logger.debug("secureKey=" + secureKey + ",securePassword=" + securePassword);
			if (secureKey == null){
				throw new Exception("SecureKey is null");
			}
			String reader = secureKey.split("/")[0];
			String secureId = secureKey.split("/")[1];
			logger.debug("reader=" + reader + ",secureId=" + secureId);
			
			// secureKey는 메일 인라인이미지, 첨부파일 다운로드 호출에 쓰이기 때문에 secureKey를 다시 암호화한다.
			secureKey = request.getParameter("secureKey");
			
			int result = ezEmailService.checkSecureMailPassword(secureId, reader, securePassword);
			logger.debug("result=" + result);
			
			if (result == 0) {
				MailSecureVO secureInfo = ezEmailService.getSecureMailInfo(secureId, reader);
				logger.debug("secureInfo=" + secureInfo.toString());
				
				String userAccount = secureInfo.getUserAccount();
				String folderPath = secureInfo.getFolderPath();
				long uid = Long.parseLong(secureInfo.getMailUid());
				
				String userId = userAccount.split("@")[0];
				String domainName = userAccount.split("@")[1];
				int tenantId = ezCommonService.getTenantIdByDomainName(domainName);
				String lang = ezCommonService.selectUserGetLang(userId, tenantId);
				Locale locale = new Locale(commonUtil.getTwoLetterLangFromLangNum(lang));
				logger.debug("tenantId=" + tenantId + ",lang=" + lang);
				
				ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
						userAccount, jspw, egovMessageSource, locale, ezEmailUtil);
				Folder f = ia.getFolder(folderPath);
				
				if (f == null || !f.exists()) {
					logger.error("Folder not found. folderPath=" + folderPath);
				} else {
					f.open(Folder.READ_WRITE);
					
					Message message = ((IMAPFolder)f).getMessageByUID(uid);
					
					if (message == null) {
						logger.error("Message not found. uid=" + uid);
					} else {
						Multipart multipart = (Multipart)message.getContent();
						MimeBodyPart part = (MimeBodyPart)multipart.getBodyPart(2);
						
						String realPath = commonUtil.getRealPath(request);
						String pDirPath = realPath + commonUtil.getUploadPath("upload_mail.ROOT", tenantId) + commonUtil.separator + "tempFileUpload";
			        	
						File file = new File(pDirPath + commonUtil.separator + UUID.randomUUID().toString());
						fos = new FileOutputStream(file);
						part.saveFile(file);
						
						File decryptedFile = new File(pDirPath + commonUtil.separator + UUID.randomUUID().toString());
						
						if (!useKlibEncrypt) {
							egovFileScrty.cryptFile(Cipher.DECRYPT_MODE, file, decryptedFile);
						} else {
							byte[] bytes = commonUtil.readBytesFromFile(file.toPath());
							commonUtil.writeBytesToFile(decryptedFile.toPath(),klibUtil.decrypt(bytes));
						}
						
						// 임시파일 삭제
						if (file.delete()) {
							logger.debug("file is deleted. fileName=" + file.getName());
						}
						
						SMTPAccess sa = SMTPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.SMTPPort"),
								userAccount, jspw);
						
						fis = new FileInputStream(decryptedFile);
						message = sa.readMimeMessage(fis);
						
						bodyInfoList = ezEmailUtil.getBodyInfo(message, folderPath, uid, -1, null, false, false, locale, secureKey, securePassword);
						double size = Double.parseDouble(bodyInfoList.get(2));
						String strSize = ezEmailUtil.getSizeWithUnit(size);
						pAttachListHtmlSub = " - <b>" + bodyInfoList.get(3) + egovMessageSource.getMessage("ezEmail.t180", locale) + "</b>(" + strSize + ")";
						
						// 임시파일 삭제
						if (decryptedFile.delete()) {
							logger.debug("decryptedFile is deleted. fileName=" + decryptedFile.getName());
						}
					}
					
					f.close(true);
				}

				MailGeneralVO mailGeneralVO = ezEmailService.getMailGeneral(tenantId, userId).get(0);
				String previewMailImage = mailGeneralVO.getPreviewMailImage() == null ? "Y" : mailGeneralVO.getPreviewMailImage();

				String resultString = ezEmailService.updateSecureMailReaderInfo(secureId, reader);
				if (!resultString.equals("OK")) {
					//TODO
				}
				
				if (bodyInfoList != null) {
					model.addAttribute("htmlBody", bodyInfoList.get(0));
					model.addAttribute("pAttachListHtml", bodyInfoList.get(1));
					model.addAttribute("pAttachListHtmlSub", pAttachListHtmlSub);
					model.addAttribute("isAttach", bodyInfoList.get(4));
					model.addAttribute("previewImageListHtml", bodyInfoList.get(5)); //이미지 미리보기
					model.addAttribute("previewMailImage", previewMailImage);
				}
				
				model.addAttribute("e1", egovMessageSource.getMessage("ezEmail.e1", locale));
				model.addAttribute("t246", egovMessageSource.getMessage("main.t246", locale));
				model.addAttribute("t901", egovMessageSource.getMessage("ezEmail.t901", locale));
				model.addAttribute("t902", egovMessageSource.getMessage("ezEmail.t902", locale));
				model.addAttribute("t903", egovMessageSource.getMessage("ezEmail.t903", locale));
				model.addAttribute("t99000003", egovMessageSource.getMessage("ezEmail.t99000003", locale));
				model.addAttribute("t99000004", egovMessageSource.getMessage("ezEmail.t99000004", locale));
				model.addAttribute("t99000064", egovMessageSource.getMessage("ezEmail.t99000064", locale));
				model.addAttribute("t99000065", egovMessageSource.getMessage("ezEmail.t99000065", locale));
			}
		} catch (PatternSyntaxException e) {
			logger.error(e.getMessage(), e);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		} finally {
			if (fis != null) {
				try { fis.close(); 
				} catch (IOException e) {logger.debug("e.message=" + e.getMessage());
				} catch (Exception e) {logger.debug("e.message=" + e.getMessage());}
			}
			if (fos != null) {
				try { fos.close(); 
				} catch (RuntimeException e) {logger.debug("e.message=" + e.getMessage());
				} catch (Exception e) {logger.debug("e.message=" + e.getMessage());}
			}
			if (ia != null) {
				try { ia.close(); 
				} catch (RuntimeException e) {logger.debug("e.message=" + e.getMessage());
				} catch (Exception e) {logger.debug("e.message=" + e.getMessage());}
			}
		}
		
		logger.debug("readSecureMailContent ended.");
		return "ezEmail/mailReadContentSecure";
	}
	
	/**
	 * 보안메일 정보화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/secureMailInfo.do", method=RequestMethod.GET)
	public String secureMailInfo(@CookieValue("loginCookie") String loginCookie, Locale locale, HttpServletRequest request, Model model) throws Exception{
		logger.debug("secureMailInfo started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String url = request.getParameter("url");
		logger.debug("url=" + url);
		
		String mailId = userInfo.getId();
		String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", userInfo.getTenantId());

		if (useSharedMailbox.equals("YES")) {
			String shareId = request.getParameter("shareId");
			logger.debug("shareId=" + shareId);
			
			if (shareId != null) {
				if (!ezEmailService.checkUserShareId(userInfo.getId(), shareId, userInfo.getTenantId())) {
					logger.debug("the user cannot access the shareId.");
					logger.debug("mailReadBoard ended.");
					
					return "";
				}
				
				mailId = shareId;
			}
		}
		
		logger.debug("userId=" + userInfo.getId() + ",mailId=" + mailId);
		
		MailSecureVO secureInfo = ezEmailService.getSecureMailInfoWithPassword(mailId, userInfo.getTenantId(), url);
		
		// securePassword 복호화
		String securePassword = secureInfo.getPassword();
		boolean useKlibEncrypt = "YES".equalsIgnoreCase(config.getProperty("config.useKlibEncrypt"));
		securePassword = ezEmailService.decryptSecureValue(securePassword, useKlibEncrypt);
		secureInfo.setPassword(securePassword);
		
		String maxReadDate = secureInfo.getMaxReadDate();
		if (maxReadDate != null) {
			maxReadDate = commonUtil.getDateStringInUTC(maxReadDate, userInfo.getOffset(), false);
			secureInfo.setMaxReadDate(maxReadDate);
		}
		
		List<MailSecureReaderVO> secureReaderList = ezEmailService.getSecureMailReaderInfo(secureInfo.getSecureId());
		
		for (MailSecureReaderVO vo : secureReaderList) {
			vo.setReadDate(commonUtil.getDateStringInUTC(vo.getReadDate(), userInfo.getOffset(), false));
		}
		
		String offsetMin = commonUtil.getMinuteUTC(userInfo.getOffset());
		
		model.addAttribute("secureInfo", secureInfo);
		model.addAttribute("secureReaderList", secureReaderList);
		model.addAttribute("offsetMin", offsetMin);
		
		logger.debug("secureMailInfo ended.");
		return "ezEmail/mailSecureInfo";
	}
	
	/**
	 * Receiver HTML 문자열 반환 함수
	 */
	private String getReceiverHTML(String name, String address, boolean isSecureMail){
		String returnValue = null;
		
		if (isSecureMail) {
			returnValue = "<span title='" + (address == null? "" : EgovStringUtil.getSpclStrCnvr(address)) + "'>"
					+ (name == null ? "" : name) + "</span>";
		} else {
			returnValue = "<span style='cursor:pointer' title='" + (address == null? "" : EgovStringUtil.getSpclStrCnvr(address))
					+ "' onclick='show_personinfo(\"" + address + "\")'>"
					+ (name == null ? "" : name) + "</span>";
		}
		
		return returnValue;
	}
	
	/**
	 * MDN 메지시 전송 함수
	 */
	public void processAutoMDN(SMTPAccess sa, Message message, String myEmailAddress, String myName, int tenantId) {
		logger.debug("processAutoMDN started.");
		
		try {		
			String fromEmailAddress = ezEmailUtil.getFromEmailAddressOfMessage(message);
			
			logger.debug("myEmailAddress=" + myEmailAddress + ",fromEmailAddress=" + fromEmailAddress);
			
			int atSignIndex = fromEmailAddress.indexOf("@");
			
			if (fromEmailAddress.equals("") || atSignIndex == -1) {
				logger.debug("invalid fromEmailAddress=" + fromEmailAddress);
				return;
			}
			
			String fromEmailDomain = fromEmailAddress.substring(atSignIndex + 1);
			List<String> innerDomainList = ezEmailUtil.getInnerDomain(tenantId);
			
			logger.debug("fromEmailDomain=" + fromEmailDomain);
			
			if (!innerDomainList.contains(fromEmailDomain)) {
				logger.debug("different domain");
				logger.debug("processAutoMDN ended.");
				return;
			}
									
			String[] messageIds = message.getHeader("Message-ID");
			String[] mdnHeaders = message.getHeader("X-JMocha-Disp-Noti-To");
			
			if (messageIds != null && mdnHeaders != null) {				
				logger.debug("Sending an MDN...");
											
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
				replyMessage.setRecipient(RecipientType.TO, new InternetAddress(mdnHeaders[0], "", "UTF-8"));
										
				sa.sendMessageWithNewTransport(replyMessage);
				
				ezEmailUtil.setMDNSentFlag(message, true);
			}
		} catch (IndexOutOfBoundsException e) {
			logger.error(e.getMessage(), e);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("processAutoMDN ended.");
	}
	
	/**
	 *  편지함 모두 읽기
	 */
	@RequestMapping(value="/ezEmail/folderSetReadChange.do", method=RequestMethod.POST,
			produces="text/xml; charset=utf-8")
	@ResponseBody
	public String folderSetReadChange(@CookieValue("loginCookie") String loginCookie,
			HttpServletRequest request, Locale locale, Model model) throws Exception{
		logger.debug("folderSetReadChange started.");
		
		List<String> userIdAndPassword = commonUtil.getUserIdAndPassword(loginCookie);
		String password = userIdAndPassword.get(1);
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
		String userAccount = userInfo.getId() + "@" + domainName;
		String folderId = request.getParameter("url");
		String isRead = request.getParameter("isRead");
		String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", userInfo.getTenantId());

		if (useSharedMailbox.equals("YES")) {
			String shareId = request.getParameter("shareId");
			logger.debug("shareId=" + shareId);
			
			if (shareId != null) {
				if (!ezEmailService.checkUserShareId(userInfo.getId(), shareId, userInfo.getTenantId())) {
					logger.debug("the user cannot access the shareId.");
					logger.debug("folderSetReadChange ended.");
					
					return "";
				}
				
				userAccount = shareId + "@" + domainName;
			}
		}
		
		logger.debug("userId=" + userInfo.getId() + ",url=" + folderId + ",userAccount=" + userAccount);
		
		String returnData = "<DATA>OK</DATA>";
		
		IMAPAccess ia = null;
		
		try {
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"), userAccount, 
								password, egovMessageSource, locale, ezEmailUtil);

			if (ia != null){
				IMAPFolder sourceFolder = (IMAPFolder) ia.getFolder(folderId);
				if (sourceFolder == null){
					throw new Exception("SourceFolder is null");
				}
				sourceFolder.open(Folder.READ_WRITE);

				Message[] msgs = sourceFolder.getMessages();

				if (isRead.equals("TRUE")) {
					sourceFolder.setFlags(msgs, new Flags(Flags.Flag.SEEN), true);
				}
				else {
					sourceFolder.setFlags(msgs, new Flags(Flags.Flag.SEEN), false);
				}

				sourceFolder.close(true);
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
		logger.debug("folderSetReadChange started.");
		
		return returnData;
	}
	
	/**
	 * 메일 읽기 창에서 주소록에 추가 아이콘 클릭 시 나타나는 주소 추가 화면 출력
	 */
	@RequestMapping(value="/ezEmail/mailSelectAddress.do", method=RequestMethod.GET)
	public String mailSelectAddress(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Locale locale, Model model) throws Exception{
		logger.debug("mailSelectAddress started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String url = request.getParameter("url");
		String myEmail = userInfo.getEmail();
		String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", userInfo.getTenantId());

		if (useSharedMailbox.equals("YES")) {
			String shareId = request.getParameter("shareId");
			logger.debug("shareId=" + shareId);
			
			if (shareId != null) {
				if (!ezEmailService.checkUserShareId(userInfo.getId(), shareId, userInfo.getTenantId())) {
					model.addAttribute("mainContent", egovMessageSource.getMessage("ezEmail.lhm81", locale));
					
					logger.debug("the user cannot access the shareId.");
					logger.debug("mailSelectAddress ended.");
					
					return "ezCommon/error";
				} else {
					model.addAttribute("shareId", shareId);
				}
			}
		}
		
		model.addAttribute("url", url);
		model.addAttribute("myEmail", myEmail);
		
		logger.debug("mailSelectAddress ended.");
		return "ezEmail/mailSelectAddress";
	}
	
	/**
	 * 메일 주소 리스트 가져오는 함수
	 */
	@RequestMapping(value="/ezEmail/getMailAddressList.do", method=RequestMethod.POST)
	@ResponseBody
	public JSONObject getMailAddressList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Locale locale) throws Exception{
		logger.debug("getMailAddressList started.");
		Map<String, Object> result = new HashMap<String, Object>();
		
		String url = request.getParameter("url");
		logger.debug("url=" + url);
		
		try {
			url = (url != null) ? url : "";
			int index = url.lastIndexOf("/");
			String folderPath = url.substring(0, index);
			long uid = Long.parseLong(url.substring(index + 1));
			
			// get user credentials
			List<String> userCookieInfo = commonUtil.getUserIdAndPassword(loginCookie);
			String password = userCookieInfo.get(1);
			
			LoginVO userInfo = commonUtil.userInfo(loginCookie);
			String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
			String userAccount = userInfo.getId() + "@" + domainName;
			String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", userInfo.getTenantId());

			if (useSharedMailbox.equals("YES")) {
				String shareId = request.getParameter("shareId");
				logger.debug("shareId=" + shareId);
				
				if (shareId != null) {
					if (!ezEmailService.checkUserShareId(userInfo.getId(), shareId, userInfo.getTenantId())) {
						logger.debug("the user cannot access the shareId.");
						logger.debug("getMailAddressList ended.");
						
						result.put("status", "error");
						
						return new JSONObject(result);
					}
					
					userAccount = shareId + "@" + domainName;
				}
			}
			
			logger.debug("userId=" + userInfo.getId() + ",userAccount=" + userAccount);
			
			List<Map<String, String>> fromList = new ArrayList<Map<String, String>>();
			List<Map<String, String>> toList = new ArrayList<Map<String, String>>();
			List<Map<String, String>> ccList = new ArrayList<Map<String, String>>();
			List<Map<String, String>> bccList = new ArrayList<Map<String, String>>();
			Map<String, String> map = null;
			
			IMAPAccess ia = null;
			
			try {
				ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
						userAccount, password, egovMessageSource, locale, ezEmailUtil);
				if (ia != null){
					Folder f = ia.getFolder(folderPath != null ? folderPath : "");

					if (f == null || !f.exists()) {
						throw new Exception("Folder not found. folderPath=" + folderPath);
					}

					f.open(Folder.READ_WRITE);

					Message message = ((IMAPFolder) f).getMessageByUID(uid);

					if (message == null) {
						throw new Exception("Message not found. url=" + url);
					} else {
						// from
						Address[] fromArr = message.getFrom();

						String fromName = "";
						String fromEmail = "";

						if (fromArr != null) {
							fromName = ezEmailUtil.getFromNameOrAddressOfMessage(message);
							fromName = commonUtil.trimDoubleQuotes(fromName);

							fromEmail = ((InternetAddress) fromArr[0]).getAddress();
						} else {
							String[] fromHeaders = message.getHeader("From");
							if (fromHeaders != null) {
								fromName = MimeUtility.decodeText(message.getHeader("From")[0]);
							}
						}

						logger.debug("fromName=" + fromName + ",fromEmail=" + fromEmail);

						map = new HashMap<String, String>();
						map.put("name", fromName);
						map.put("email", fromEmail);

						fromList.add(map);

						// to
						Address[] toArr = message.getRecipients(Message.RecipientType.TO);

						if (toArr != null) {
							String toHeader = message.getHeader("To")[0];
							boolean isAscii = ezEmailUtil.isPureAscii(toHeader);
							String toName = null;
							String toEmail = null;

							for (int i = 0; i < toArr.length; i++) {
								toName = ((InternetAddress) toArr[i]).getPersonal();
								toEmail = ((InternetAddress) toArr[i]).getAddress();

								if (toName == null) {
									toName = ((InternetAddress) toArr[i]).getAddress();
								} else {
									if (!isAscii) {
										byte[] rawBytes = toName.getBytes("iso-8859-1");
										toName = ezEmailUtil.decodeNonAsciiBytes(rawBytes);
									} else {
										toName = MimeUtility.decodeText(toName);
									}

									toName = commonUtil.trimDoubleQuotes(toName);
								}

								map = new HashMap<String, String>();
								map.put("name", toName);
								map.put("email", toEmail);

								toList.add(map);
							}
						}

						// cc
						Address[] ccArr = message.getRecipients(Message.RecipientType.CC);

						if (ccArr != null) {
							String ccHeader = message.getHeader("Cc")[0];
							boolean isAscii = ezEmailUtil.isPureAscii(ccHeader);
							String ccName = null;
							String ccEmail = null;

							for (int i = 0; i < ccArr.length; i++) {
								ccName = ((InternetAddress) ccArr[i]).getPersonal();
								ccEmail = ((InternetAddress) ccArr[i]).getAddress();

								if (ccName == null) {
									ccName = ((InternetAddress) ccArr[i]).getAddress();
								} else {
									if (!isAscii) {
										byte[] rawBytes = ccName.getBytes("iso-8859-1");
										ccName = ezEmailUtil.decodeNonAsciiBytes(rawBytes);
									} else {
										ccName = MimeUtility.decodeText(ccName);
									}

									ccName = commonUtil.trimDoubleQuotes(ccName);
								}

								map = new HashMap<String, String>();
								map.put("name", ccName);
								map.put("email", ccEmail);

								ccList.add(map);
							}
						}

						// bcc
						Address[] bccArr = message.getRecipients(Message.RecipientType.BCC);

						if (bccArr != null) {
							String bccName = null;
							String bccEmail = null;

							for (int i = 0; i < bccArr.length; i++) {
								bccName = ((InternetAddress) bccArr[i]).getPersonal();
								bccEmail = ((InternetAddress) bccArr[i]).getAddress();

								if (bccName == null) {
									bccName = ((InternetAddress) bccArr[i]).getAddress();
								} else {
									bccName = MimeUtility.decodeText(bccName);
									bccName = commonUtil.trimDoubleQuotes(bccName);
								}

								map = new HashMap<String, String>();
								map.put("name", bccName);
								map.put("email", bccEmail);

								bccList.add(map);
							}
						}
					}

					f.close(true);

					Map<String, Object> data = new HashMap<String, Object>();

					data.put("from", fromList);
					data.put("to", toList);
					data.put("cc", ccList);
					data.put("bcc", bccList);

					result.put("status", "ok");
					result.put("data", data);
				}

			} catch (MessagingException e) {
				logger.error(e.getMessage(), e);
				result.put("status", "error");
			} finally {
				if (ia != null) {
					ia.close();
				}
			}
			
		} catch (IndexOutOfBoundsException e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
		}
		
		logger.debug("getMailAddressList ended.");
		return new JSONObject(result);
	}
	
	/**
	 * 메일 첨부파일 브라우저로 읽기
	 */
	@RequestMapping(value="/ezEmail/readAttachIamge.do")
	@ResponseBody
	public void readAttachIamge(@CookieValue("loginCookie") String loginCookie, Locale locale, HttpServletRequest request, HttpServletResponse response) throws Exception{
		logger.debug("readAttachIamge started.");
		
		// get user credentials
		List<String> userInfo = commonUtil.getUserIdAndPassword(loginCookie);
		String password  = userInfo.get(1);
		
		LoginVO loginInfo = commonUtil.userInfo(loginCookie);
		String domainName = ezCommonService.getTenantConfig("DomainName", loginInfo.getTenantId());
		String userEmail = loginInfo.getId() + "@" + domainName;
		
		String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", loginInfo.getTenantId());
		String shareId = StringUtils.defaultString(request.getParameter("shareId"), "");
		
		if (useSharedMailbox.equals("YES") && !Globals.APPR_MAIL_SHARED_ID.equalsIgnoreCase(shareId)) {
			//String shareId = request.getParameter("shareId");
			logger.debug("shareId=" + shareId);
			
			if (StringUtils.isNotBlank(shareId)) {
				if (!ezEmailService.checkUserShareId(loginInfo.getId(), shareId, loginInfo.getTenantId())) {
					logger.debug("the user cannot access the shareId.");
					logger.debug("downloadAttach ended.");
					
					return;
				}
				
				userEmail = shareId + "@" + domainName;
			}
		}
		
		if (StringUtils.isNotBlank(shareId) && Globals.APPR_MAIL_SHARED_ID.equalsIgnoreCase(shareId)) {
			userEmail = shareId + "@" + domainName;
		}
		
		logger.debug("userId=" + loginInfo.getId() + ",userEmail=" + userEmail);
		
		// retrieve the passed in parameters
		String folderPath = request.getParameter("folderPath");
		String strUid = request.getParameter("uid");
		long uid = strUid != null ? Long.parseLong(strUid) : 0;
		String filename = request.getParameter("filename");
		logger.debug("folderPath=" + folderPath + ",uid=" + uid + ",filename=" + filename);
		
		if (folderPath == null || strUid == null || filename == null) {
			logger.debug("readAttachIamge illegal arguments.");
			return;
		}
		
		String strIndex = request.getParameter("index");
		int index = -1;
		
		if (strIndex != null) {
			index = Integer.parseInt(strIndex);
		}
		logger.debug("index=" + index);
		
		String strOrder = request.getParameter("order");
		int order = 0;
		
		if (strOrder != null) {
			order = Integer.parseInt(strOrder);
		}
		
		logger.debug("order=" + order);
		
		String strDepth = request.getParameter("depth");
		int depth = 0;
		
		if (strDepth != null) {
			depth = Integer.parseInt(strDepth);
		}
		
		logger.debug("depth=" + depth);
		
		IMAPAccess ia = null;
		try {
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userEmail, password, egovMessageSource, locale, ezEmailUtil);
	
			Folder f = ia.getFolder(folderPath);
			
			if (f == null || !f.exists()) {
				logger.error("Folder not found. folderPath=" + folderPath);
			} else {
				f.open(Folder.READ_ONLY);
				Message message = null;
				if(f.isOpen() && f instanceof IMAPFolder){
					message = ((IMAPFolder)f).getMessageByUID(uid);
				}
				
				if (message == null) {
					logger.error("Message not found. uid=" + uid);
				} else {
					Part part = null;
					
					if (index == -1) {
						part = message;
					}
					else {
						part = ezEmailUtil.getAttachPart(message, index, order, depth);
					}
					
					if (part == null) {
						logger.error("AttachPart not found. AttachPartIndex=" + index);
					} else {
						response.setContentType(part.getContentType());
						
						filename = CommonUtil.getEncodedFileNameForDownload(request.getHeader("User-Agent"), filename);						
						
						String nfcFilename = commonUtil.normalizeFileName(filename);
						
						response.addHeader("content-disposition", "inline; filename=\"" + nfcFilename + "\"");
						logger.debug("content-disposition=" + "inline; filename=\"" + nfcFilename + "\"");
						
						InputStream input = null;
						OutputStream output = null;
						
						try {
							input = part.getInputStream();
							output = response.getOutputStream();
							
							byte[] buffer = new byte[4096];
							int byteRead;
							
							while ((byteRead = input.read(buffer)) != -1) {
								output.write(buffer, 0, byteRead);
							}
						} catch(IOException e) {
							logger.debug("e.message=" + e.getMessage());
						} finally {
							if (ia != null) {
								ia.close();
							}
							if (input != null) {
								try { input.close(); } catch (IOException e) {logger.debug("e.message=" + e.getMessage());}
							}
							if (output != null) {
								try { output.flush(); } catch (IOException e) {logger.debug("e.message=" + e.getMessage());}
								try { output.close(); } catch (IOException e) {logger.debug("e.message=" + e.getMessage());}
							}
						}
						
					}
				}
			}
		} catch (MessagingException e) {
			logger.error(e.getMessage(), e);
		} finally {
			if (ia != null) {
				ia.close();
			}
		}
		
		logger.debug("readAttachIamge ended.");
	}
	@RequestMapping(value="/ezEmail/attachFilePreview.do",method=RequestMethod.GET , produces="text/plain; charset=UTF-8")
	@ResponseBody
	public void attachFilePreview(HttpServletRequest request,HttpServletResponse response , @CookieValue("loginCookie") String loginCookie, Locale locale, Model model) throws Exception {
		logger.debug("attachFilePreview started.");
		
		String folderId = "";
		String mailId = "";
		String fileName = "";
		String fileIndex = "";
		
		if (request.getParameter("folderId") != null) {
			folderId = request.getParameter("folderId");
		}
		
		if (request.getParameter("mailId") != null) {
			mailId = request.getParameter("mailId");
		}
		
		if (request.getParameter("fileName") != null) {
			fileName = request.getParameter("fileName");
		}
		
		if (request.getParameter("fileIndex") != null) {
			fileIndex = request.getParameter("fileIndex");
		}
		
		logger.debug("folderId : {}, mailId : {}, fileName : {}, fileIndex : {}", folderId, mailId, fileName, fileIndex);

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		OutputStream output = null;
		Map<String, Object> result = mailFileDown(userInfo, folderId, mailId, fileIndex, fileName, userInfo.getId());

		Map<String, Object> data = (Map<String, Object>) result.get("data");
		
		String filename = (String) data.get("filename");
		byte[] bytes = (byte[]) data.get("bytes");
		output = response.getOutputStream();
		
		try {
			Decoder decoder = java.util.Base64.getDecoder();
			
			String useImageConvertServer = ezCommonService.getTenantConfig("useImageConvertServer", userInfo.getTenantId());
			
			if (useImageConvertServer.equals("1")) { //SAT
				response.setContentType("text/plain");
				
				filename = URLDecoder.decode(filename, "UTF-8");
				
				String realPath = commonUtil.getRealPath(request);
				String filePath = realPath + commonUtil.getUploadPath("upload_mail.ROOT", userInfo.getTenantId()) + commonUtil.separator + "tempFileUpload"
											+ commonUtil.separator + userInfo.getId();

				MessageDigest md2 = MessageDigest.getInstance("SHA-256");
				md2.update(filename.substring(0, filename.lastIndexOf(".")).getBytes());
				byte mdDate2[] = md2.digest();
				StringBuffer sb2 = new StringBuffer();
				for (int i = 0; i < mdDate2.length; i++) {
					sb2.append(Integer.toHexString((int) mdDate2[i] & 0x00ff));
				}
				String md5FileName = sb2.toString() + filename.substring(filename.lastIndexOf("."));
				
				File newFolder = new File(filePath != null ? filePath : "");
				if(!newFolder.exists()){
					newFolder.mkdirs();
				}
				
				File file = new File(commonUtil.detectPathTraversal(filePath + commonUtil.separator + md5FileName));
				// CWE-404 보안 취약점 대응
				try (FileOutputStream fos = new FileOutputStream(file)) {
					fos.write(bytes);
				}
				
				filePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + commonUtil.getUploadPath("upload_mail.ROOT", userInfo.getTenantId()) 
				+ commonUtil.separator + "tempFileUpload" + commonUtil.separator + userInfo.getId() + commonUtil.separator + md5FileName;
				String fileExt = filename.split("\\.")[filename.split("\\.").length - 1];
				
				logger.debug("filePath : " + filePath);
				logger.debug("fileName : " + filename);
				logger.debug("fileExt : " + fileExt);

				String SATimageConvertServerURL = ezCommonService.getTenantConfig("SATimageConvertServerURL", userInfo.getTenantId());
				
				//output.write(("http://jmocha.kaoni.com:8080/uFOCS3.0/viewer/document/docviewer.do" + 
				output.write((SATimageConvertServerURL + 
							"?filepath=" + URLEncoder.encode(filePath, "UTF-8").replace("+", "%20") +
							"&filename=" + URLEncoder.encode(filename, "UTF-8").replace("+", "%20") +
							"&fileext=" + URLEncoder.encode(fileExt, "UTF-8").replace("+", "%20") +
							"&viewerselect=image" +
							"&userid=" + userInfo.getId()).getBytes());
			}
			
		} catch (UnsupportedEncodingException e) {
			logger.error(e.getMessage(), e);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		} finally {
			output.flush();
			output.close();
		}
		
		logger.debug("attachFilePreview ended.");
	}
	
	public Map<String, Object> mailFileDown(LoginVO info, String folderId, String messageId, String index, String filename, String userId) throws Exception{

		InputStream input = null;
		IMAPAccess ia = null;
		Map<String, Object> result = new HashMap<>();

		try {
			String userEmail = info.getEmail();
			String password = jspw;
			String useMobileViewer = ezCommonService.getTenantConfig("useMobileViewer", info.getTenantId());
			String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", info.getTenantId());

			logger.debug("userEmail=" + userEmail);

			String ld = commonUtil.getTwoLetterLangFromLangNum(info.getLang());
			Locale locale = new Locale(ld);
			
			String folderPath = folderId;
			String strUid = messageId;
			long uid = strUid != null ? Long.parseLong(strUid) : 0;

			logger.debug("folderPath=" + folderPath + ",uid=" + uid + ",filename=" + filename);

			if (folderPath == null || strUid == null || filename == null) {
				logger.debug("downloadAttach illegal arguments.");

				result.put("status", "error");
				result.put("code", 1);
				result.put("data", "");

				return result;
			}

			String strIndex = index;
			int intIndex = -1;

			if (strIndex != null) {
				intIndex = Integer.parseInt(strIndex);
			}
			int order = 0;
			int depth = 0;
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userEmail, password, egovMessageSource, locale, ezEmailUtil);

			Folder f = ia.getFolder(folderPath);

			if (f == null || !f.exists()) {
				logger.error("Folder not found. folderPath=" + folderPath);
			} else {
				f.open(Folder.READ_ONLY);
				Message message = null;

				if (f.isOpen() && f instanceof IMAPFolder) {
					message = ((IMAPFolder)f).getMessageByUID(uid);
				}

				if (message == null) {
					logger.error("Message not found. uid=" + uid);

					result.put("status", "error");
					result.put("code", 1);
					result.put("data", "");
				} else {
					Part part = null;

					if (intIndex == -1) {
						part = message;
					} else {
						part = ezEmailUtil.getAttachPart(message, intIndex, order, depth);
					}
					if (part == null) {
						logger.error("AttachPart not found. AttachPartIndex=" + index);
					} else {
						try {
							input = part.getInputStream();

							byte[] bytes = IOUtils.toByteArray(input);

							Map<String, Object> data = new HashMap<>();

							data.put("bytes", bytes);
							data.put("filename",filename);
							data.put("filetype",part.getContentType());
							data.put("useMobileViewer", useMobileViewer);

							result.put("status", "ok");
							result.put("code", 0);
							result.put("data", data);
						} catch(Exception e) {
							logger.error(e.getMessage(), e);

							result.put("status", "error");
							result.put("code", 1);
							result.put("data", "");
						} finally {
							if (ia != null) {
								ia.close();
							}

							if (input != null) {
								try { input.close(); } catch (IOException e) {logger.debug("e.message=" + e.getMessage());}
							}
						}
					}
				}
			}
		} catch (MessagingException e) {
			logger.error(e.getMessage(), e);

			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		} finally {
			if (ia != null) {
				ia.close();
			}
		}
		return result;
	}
}
