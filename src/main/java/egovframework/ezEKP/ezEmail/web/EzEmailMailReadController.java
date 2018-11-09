package egovframework.ezEKP.ezEmail.web;

import java.io.File;
import java.io.FileFilter;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.charset.Charset;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;
import java.util.TimeZone;
import java.util.UUID;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import javax.annotation.Resource;
import javax.crypto.Cipher;
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
import javax.mail.internet.InternetAddress;
import javax.mail.internet.InternetHeaders;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeUtility;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.codec.binary.Base64;
import org.apache.commons.io.filefilter.PrefixFileFilter;
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
import org.w3c.dom.Document;
import org.w3c.dom.Element;

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
import egovframework.ezEKP.ezEmail.vo.MailSecureReaderVO;
import egovframework.ezEKP.ezEmail.vo.MailSecureVO;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovStringUtil;
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
	
	/**
	 * 메일 읽기화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailRead.do")
	public String readMail(@CookieValue("loginCookie") String loginCookie, Locale locale, HttpServletRequest request, Model model) throws Exception {
		logger.debug("readMail started.");
		
		// get user credentials
		List<String> userInfo = commonUtil.getUserIdAndPassword(loginCookie);
		String password = userInfo.get(1);
		
		LoginVO loginInfo = commonUtil.userInfo(loginCookie);
		String domainName = ezCommonService.getTenantConfig("DomainName", loginInfo.getTenantId());
		String userEmail = loginInfo.getId() + "@" + domainName;
		String useReSend = ezCommonService.getTenantConfig("useReSend", loginInfo.getTenantId());
		logger.debug("userEmail=" + userEmail);
		
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
		
		String contentClass = request.getParameter("CONTENTCLASS");

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
		
		try {
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userEmail, password, egovMessageSource, locale, ezEmailUtil);
			Folder f = ia.getFolder(folderPath);
			
			if (f == null || !f.exists()) {
				logger.error("Folder not found. folderPath=" + folderPath);
			} else {
				f.open(Folder.READ_WRITE);
				
				Message message = null;
				if(f.isOpen() && f instanceof IMAPFolder){
					message = ((IMAPFolder)f).getMessageByUID(uid);
				}
				
				if (message == null) {
					logger.error("Message not found. uid=" + uid);
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
						if (fromEmail.equals("a@a.com")){
							fromEmail = "";
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
										toStr = getReceiverHTML(name, ((InternetAddress)arrRecipientsTo[i]).getAddress(), false) + "<span>&nbsp;(" + egovMessageSource.getMessage("ezEmail.t10000", locale) + arrRecipientsTo.length + egovMessageSource.getMessage("ezEmail.t10001", locale) + ")&nbsp;<img src='/images/expnd.gif'  style='cursor:pointer;' onclick='ShowHiddenTo(this);' align='absmiddle'></span>";
									} else {
										toStr = getReceiverHTML(name, ((InternetAddress)arrRecipientsTo[i]).getAddress(), false);
									}
								}
								if(toHiddenStr == null){
									toHiddenStr = getReceiverHTML(name, ((InternetAddress)arrRecipientsTo[i]).getAddress(), false);
								} else {
									toHiddenStr += " , " + getReceiverHTML(name, ((InternetAddress)arrRecipientsTo[i]).getAddress(), false);
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
						//	}
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
					
					if(subject == null || subject.trim().equals("")){
						subject = egovMessageSource.getMessage("ezEmail.kms03", locale);
					}
					
					subject = commonUtil.cleanValue(subject);
					title = egovMessageSource.getMessage("ezEmail.t565", locale) + subject;
					
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
				}
				
				f.close(true);
			}
		} catch (MessagingException e) {
			e.printStackTrace();
		} finally {
			if (ia != null) {
				ia.close();
			}
		}
		
		String dotNetIntegration = ezCommonService.getTenantConfig("dotNetIntegration", loginInfo.getTenantId());
		String dotNetUrl = ezCommonService.getTenantConfig("dotNetUrl", loginInfo.getTenantId());
				
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
		
		logger.debug("readMail ended.");
		
		return "ezEmail/mailRead";
	}
	
	/**
	 * 메일 본문 내용 화면 정보 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailReadContent.do")
	public String readMailContent(@CookieValue("loginCookie") String loginCookie, Locale locale, HttpServletRequest request, Model model) throws Exception {
		logger.debug("readMailContent started.");
		
		String rejectKeyWord = "";
		
		// get user credentials
		List<String> userCookieInfo = commonUtil.getUserIdAndPassword(loginCookie);
		String password = userCookieInfo.get(1);
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
		String userEmail = userInfo.getId() + "@" + domainName;
		logger.debug("userEmail=" + userEmail);
		
		// retrieve the passed in parameters
		long uid = Long.parseLong(request.getParameter("iptURL"));
		String folderPath = request.getParameter("iptFolderPath");
		String url = folderPath + "/" + request.getParameter("iptURL");
		logger.debug("url=" + url);
		
		IMAPAccess ia = null;
		List<String> bodyInfoList = null;
		String pAttachListHtmlSub = null;
        boolean retryFlag = false;
        int retryCount = 1; // 메일 읽기 실패 시 재시도 횟수        
        
        do {		
    		try {
    			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
    					userEmail, password, egovMessageSource, locale, ezEmailUtil);
    			
                if (retryFlag) {
                    retryFlag = false;
                }
    			
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
    				} else {
    					bodyInfoList = ezEmailUtil.getBodyInfo(message, folderPath, uid, -1, null, false, false, locale, null, null);
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
    							OrganUserVO userVO = ezOrganAdminService.getUserInfo(userInfo.getId(), userInfo.getPrimary(), userInfo.getTenantId());
    							
    							SMTPAccess sa = SMTPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.SMTPPort"),
    									userEmail, password);
    							
    							processAutoMDN(sa, message, userInfo.getEmail(), userVO.getDisplayName(), userInfo.getTenantId());
    						}
    						else {
    							logger.debug("MDNSentFlag is set");
    						}
    					}
    				}
    			}
    		} catch (Exception e) { 
    			e.printStackTrace();
    			
                retryFlag = true;
                --retryCount;
                
                if (retryCount > -1) {
                    logger.debug("Message read fail. Retry...");
                    
                    try {
                        Thread.sleep(1000);
                    } catch (Exception ex) {}
                }                   			
    		} finally {
    			if (ia != null) {
    				ia.close();
    			}
    		}
        } while (retryFlag && retryCount > -1);		
		
        String htmlBody = bodyInfoList.get(0);
        Pattern p = Pattern.compile("<base\\s+href.*?>", Pattern.CASE_INSENSITIVE | Pattern.DOTALL);
		Matcher m = p.matcher(htmlBody);
		htmlBody = m.replaceAll("");
		htmlBody = htmlBody.replace("{", "%7B").replace("}", "%7D");
		
		// 2018-08-03 황윤호 추가
        String memoFlag = "";
        if (ezCommonService.getTenantConfig("useMemo", userInfo.getTenantId()).equalsIgnoreCase("YES")) {
        	memoFlag = "YES";
        } else {
        	memoFlag = "NO";
        }
        
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
		
		logger.debug("readMailContent ended.");
		
		return "ezEmail/mailReadContent";
	}
	
	/**
	 * 메일 웹페이지로 보기 수행 함수
	 */
	@RequestMapping(value="/ezEmail/mailReadOriginal.do")
	public String readMailOriginal(@CookieValue("loginCookie") String loginCookie, Locale locale, HttpServletRequest request, Model model) throws Exception{
		logger.debug("readMailOriginal started.");
		
		// get user credentials
		List<String> userInfo = commonUtil.getUserIdAndPassword(loginCookie);
		String password = userInfo.get(1);
		
		LoginVO loginInfo = commonUtil.userInfo(loginCookie);
		String domainName = ezCommonService.getTenantConfig("DomainName", loginInfo.getTenantId());
		String userEmail = loginInfo.getId() + "@" + domainName;
		logger.debug("userEmail=" + userEmail);
		
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
			Folder f = ia.getFolder(folderPath);
			
			if (f == null || !f.exists()) {
				logger.error("Folder not found. folderPath=" + folderPath);
			} else {
				f.open(Folder.READ_ONLY);
				Message message = null;
				
				if (f.isOpen() && f instanceof IMAPFolder){
					message = ((IMAPFolder)f).getMessageByUID(uid);
				}
				
				if (message == null) {
					logger.error("Message not found. uid=" + uid);
				} else {
					bodyInfoList = ezEmailUtil.getBodyInfo(message, folderPath, uid, -1, null, false, false, locale, null, null);
				}
			}
		} catch (MessagingException e) {
			e.printStackTrace();
		} finally {
			if (ia != null) {
				ia.close();
			}
		}
		
		String htmlBody = bodyInfoList.get(0).replace("{", "%7B").replace("}", "%7D");
		model.addAttribute("htmlBody", htmlBody);
		
		logger.debug("readMailOriginal ended.");
		
		return "ezEmail/mailReadOriginal";
	}
	
	/**
	 * 일반 첨부파일시 모두저장 클릭시 호출되는 메서드 (압축파일 내려받기) 
	 */
	@RequestMapping(value="/ezEmail/downloadAttachAll.do", produces="text/plain; charset=UTF-8")
	public void downloadAttachAll(@CookieValue("loginCookie") String loginCookie, Locale locale, 
			HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("downloadAttachAll started.");
		
		// get user credentials
		List<String> userIdAndPassword = commonUtil.getUserIdAndPassword(loginCookie);
		String password = userIdAndPassword.get(1);
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
		String userEmail = userInfo.getId() + "@" + domainName;
		logger.debug("userEmail=" + userEmail);
		
		// retrieve the passed in parameters
		String folderPath = URLDecoder.decode(request.getParameter("folderPath"), "utf-8");
		String strUid = URLDecoder.decode(request.getParameter("uid"), "utf-8");
		String params = request.getParameter("params");
		
		logger.debug("params=" + params);
		
		String param[] = params.split("&");
		String filename[] = new String[param.length / 2];
		String strIndex[] = new String[param.length / 2];
		
		int j = 0, k = 0;

		for (int i = 0; i < param.length; i++) {
			
			String tmpStr[] = param[i].split("=");
			
			if (i % 2 == 0) {
				filename[j] = URLDecoder.decode(tmpStr[1], "utf-8");
				j++;
			} else {
				strIndex[k] = tmpStr[1];
				k++;
			}
		}
		
		long uid = strUid != null ? Long.parseLong(strUid) : 0;
		logger.debug("folderPath=" + folderPath + ",uid=" + uid);
		
		if (folderPath == null || strUid == null || filename == null || strIndex == null) {
			logger.debug("downloadAttachAll illegal arguments.");
			return;
		}
		
		Integer idx[] = new Integer[strIndex.length];
		
		if (strIndex != null) {

			for (int i = 0; i < strIndex.length; i++) {
				idx[i] = Integer.parseInt(strIndex[i]);
			}
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
			Folder f = ia.getFolder(folderPath);
			
			if (f == null || !f.exists()) {
				logger.debug("folder not found. folderPath=" + folderPath);
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
							part = ezEmailUtil.getAttachPart(message, idx[i]);

							if (part == null) {
								logger.debug("attachpart not found. AttachPartIndex=" + idx[i]);
							} else {
								InputStream input = null;
								
								try {
									filename[i] = MimeUtility.decodeText(filename[i]);
									filename[i] = filename[i].replaceAll("[\\\\/:*?\"<>|]", "_")
												 .replaceAll("[\\t\\r\\n\\v\\f]", "")
												 .replaceAll("[+]", " ");
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
									e.printStackTrace();
								} finally {
									if (input != null) {
										try {
											input.close();
										} catch (Exception e) {
										}
									}
								}
							}
						}
					}
				}
			}
			
			f.close(true);
			
			zos.flush();
			zos.close();
			zos = null;

			File file = new File(pDirTempPath + ".zip");
			
			if (file.exists()) {
				downFile(request, response, pDirTempPath + ".zip", downFileName);
				file.delete();
			}

		} catch (Exception e) {
			File file = new File(pDirTempPath + ".zip");
			
			if (file.exists()) {
				file.delete();
			}
			
		} finally {
			if (ia != null) {
				ia.close();
			}
			
			if (zos != null) {
				try {
					zos.close();
				} catch (Exception e) {
				}
			}
		}
		
		logger.debug("downloadAttachAll ended.");
	}
	
	/**
	 * 메일 첨부파일 다운로드 실행 함수
	 */
	@RequestMapping(value="/ezEmail/downloadAttach.do")
	public void downloadAttach(@CookieValue("loginCookie") String loginCookie, Locale locale, HttpServletRequest request, HttpServletResponse response) throws Exception{
		logger.debug("downloadAttach started.");
		
		// get user credentials
		List<String> userInfo = commonUtil.getUserIdAndPassword(loginCookie);
		String password  = userInfo.get(1);
		
		LoginVO loginInfo = commonUtil.userInfo(loginCookie);
		String domainName = ezCommonService.getTenantConfig("DomainName", loginInfo.getTenantId());
		String userEmail = loginInfo.getId() + "@" + domainName;
		logger.debug("userEmail=" + userEmail);
		
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
						part = ezEmailUtil.getAttachPart(message, index);
					}
					
					if (part == null) {
						logger.error("AttachPart not found. AttachPartIndex=" + index);
					} else {
						response.setContentType(part.getContentType());
						
						filename = CommonUtil.getEncodedFileNameForDownload(request.getHeader("User-Agent"), filename);						
						
						String nfcFilename = commonUtil.normalizeFileName(filename);
						
						response.addHeader("content-disposition", "attachment; filename=\"" + nfcFilename + "\"");
						logger.debug("content-disposition=" + "attachment; filename=\"" + nfcFilename + "\"");
						
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
		} catch (MessagingException e) {
			e.printStackTrace();
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
	@RequestMapping(value="/ezEmail/downloadAttachCommon.do", produces = "text/xml; charset=utf-8")
	public void downloadAttachCommon(HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("downloadAttachCommon started.");
		
		String fileId = request.getParameter("fileid") == null ? "" : request.getParameter("fileid");
		String fileDate = request.getParameter("filedate") == null ? "" : request.getParameter("filedate");
		String tenantIdStr = request.getParameter("tid") == null ? "0" : request.getParameter("tid");
			
		int tenantId = Integer.parseInt(tenantIdStr);
		String serverLang = ezCommonService.getTenantConfig("PrimaryLang", tenantId);
		Locale locale = new Locale(commonUtil.getTwoLetterLangFromLangNum(serverLang));
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
		} catch (Exception e) {
			e.printStackTrace();
			
			response.setContentType("text/plain; charset=utf-8");
			response.getWriter().print(egovMessageSource.getMessage("ezEmail.lhm14", locale));
		}
		
		logger.debug("downloadAttachCommon ended.");
	}
	
	/**
	 * 메일 인라인 이미지 읽어오기 실행 함수
	 */
	@RequestMapping(value="/ezEmail/downloadInline.do")
	public void downloadInline(@CookieValue("loginCookie") String loginCookie, Locale locale, HttpServletRequest request, HttpServletResponse response) throws Exception{
		logger.debug("downloadInline started.");
		
		// get user credentials
		List<String> userInfo = commonUtil.getUserIdAndPassword(loginCookie);
		String password  = userInfo.get(1);
		
		LoginVO loginInfo = commonUtil.userInfo(loginCookie);
		String domainName = ezCommonService.getTenantConfig("DomainName", loginInfo.getTenantId());
		String userEmail = loginInfo.getId() + "@" + domainName;
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
							}
							
							if (ia != null) {
								ia.close();
							}
							
							return;
						}

						try {
							output.flush();
						} catch (IOException e) {
						}
						
						try {
							output.close();
						} catch (IOException e) {
						}
					}
				}
			}
		} catch (MessagingException e) {
			e.printStackTrace();
		} finally {
			if (ia != null) {
				ia.close();
			}
		}
		
		logger.debug("downloadInline ended.");
	}
	
	@RequestMapping(value="/ezEmail/downloadInlineDotNet.do")
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
							}
							
							if (ia != null) {
								ia.close();
							}
							
							return;
						}

						try {
							output.flush();
						} catch (IOException e) {
						}
						
						try {
							output.close();
						} catch (IOException e) {
						}
					}
				}
			}
		} catch (MessagingException e) {
			e.printStackTrace();
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
	@RequestMapping(value="/ezEmail/mailPrevShow.do")
	public void mailPrevShow(@CookieValue("loginCookie") String loginCookie, Locale locale, HttpServletRequest request, HttpServletResponse response) throws Exception{
		logger.debug("mailPrevShow started.");
		
		// get user credentials
		List<String> userInfo = commonUtil.getUserIdAndPassword(loginCookie);
		String password  = userInfo.get(1);
		
		LoginVO loginInfo = commonUtil.userInfo(loginCookie);
		String domainName = ezCommonService.getTenantConfig("DomainName", loginInfo.getTenantId());
		String userEmail = loginInfo.getId() + "@" + domainName;
		logger.debug("userEmail=" + userEmail);
		
		Document doc = commonUtil.convertRequestToDocument(request);
		String url = doc.getElementsByTagName("URL").item(0).getTextContent();
		logger.debug("url=" + url);
		
		long uid = 0;
		String folderPath = null;
		if(url != null){
			int index = url.lastIndexOf(commonUtil.separator);
			if(index != -1){
				folderPath = url.substring(0, index);
				uid = Long.parseLong(url.substring(index + 1));
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
		
		try {
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userEmail, password, egovMessageSource, locale, ezEmailUtil);
			Folder f = ia.getFolder(folderPath);
			
			if (f == null || !f.exists()) {
				logger.error("Folder not found. folderPath=" + folderPath);
			} else {
				f.open(Folder.READ_WRITE);
				Message message = null;
				
				if (f.isOpen() && f instanceof IMAPFolder) {
					message = ((IMAPFolder)f).getMessageByUID(uid);
				}
				
				if (message == null) {
					logger.error("Message not found. uid=" + uid);
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
					} else {
						String[] fromHeaders = message.getHeader("From");
						if (fromHeaders != null) {
							fromStr = MimeUtility.decodeText(message.getHeader("From")[0]);
						}
					}
					logger.debug("From=" + fromStr);
					
					arrRecipientsTo = message.getRecipients(Message.RecipientType.TO);
					if(arrRecipientsTo != null){
						InternetAddress iAddress = null;
						String toHeader = message.getHeader("To")[0];
						boolean isAscii = ezEmailUtil.isPureAscii(toHeader);												
						String name = null;
						
						for(int i=0; i<arrRecipientsTo.length; i++){
							iAddress = ((InternetAddress)arrRecipientsTo[i]);
							name = iAddress.getPersonal();
							if (name == null) {
								name = iAddress.getAddress();
							}
							else {
								// 표준을 지키지 않고 Non-Ascii 문자가 사용된 경우엔 직접 디코딩을 처리한다.
								if (!isAscii) {
									byte[] rawBytes = name.getBytes("iso-8859-1");
									
									name = ezEmailUtil.decodeNonAsciiBytes(rawBytes);								
								}
								else {								
									name = MimeUtility.decodeText(name);
								}
							}
							
							if (i != 0) {
								toStr += ";";
	                        }												
							toStr += "\""+name+"\" <"+iAddress.getAddress()+">";
						}
					}
					logger.debug("TO=" + toStr);
					
					arrRecipientsCC = message.getRecipients(Message.RecipientType.CC);
					if(arrRecipientsCC != null){
						InternetAddress iAddress = null;
						String ccHeader = message.getHeader("Cc")[0];
						boolean isAscii = ezEmailUtil.isPureAscii(ccHeader);																		
						String name = null;
						
						for(int i=0; i<arrRecipientsCC.length; i++){
							iAddress = ((InternetAddress)arrRecipientsCC[i]);
							name = iAddress.getPersonal();
							if (name == null) {
								name = iAddress.getAddress();
							}
							else {
								// 표준을 지키지 않고 Non-Ascii 문자가 사용된 경우엔 직접 디코딩을 처리한다.
								if (!isAscii) {
									byte[] rawBytes = name.getBytes("iso-8859-1");
									
									name = ezEmailUtil.decodeNonAsciiBytes(rawBytes);								
								}
								else {																
									name = MimeUtility.decodeText(name);
								}
							}
							
							if (i != 0) {
								ccStr += ";";
	                        }
							ccStr += "\""+name+"\" <"+iAddress.getAddress()+">";
						}
					}
					logger.debug("CC=" + ccStr);
					
					arrRecipientsBCC = message.getRecipients(Message.RecipientType.BCC);
					if(arrRecipientsBCC != null){
						InternetAddress iAddress = null;
						String name = null;
						for(int i=0; i<arrRecipientsBCC.length; i++){
							iAddress = ((InternetAddress)arrRecipientsBCC[i]);
							name = iAddress.getPersonal();
							if (name == null) {
								name = iAddress.getAddress();
							}
							else {
								name = MimeUtility.decodeText(name);
							}
							
							if (i != 0) {
								bccStr += ";";
	                        }						
							bccStr += "\""+name+"\" <"+iAddress.getAddress()+">";
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
					String[] importanceHeaders = message.getHeader("X-Priority");
					if (importanceHeaders != null) {
						logger.debug("X-Priority=" + importanceHeaders[0]);
						switch (importanceHeaders[0]) {
				            case "5": importance = 0;
				                break;
				            case "3": importance = 1;
				                break;
				            case "1": importance = 2;
				                break;
				            default: importance = 1;
				                break;
				        }
					}
					logger.debug("importance=" + importance);
					
					if(!message.isSet(Flag.SEEN)){
						unread = 1;
						message.setFlag(Flag.SEEN, true);
						logger.debug("Message's seen flag changed to true.");
					}
				}
				f.close(true);
			}
		} catch (MessagingException e) {
			e.printStackTrace();
		} finally {
			if (ia != null) {
				ia.close();
			}
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
		sb.append("<CONTENTCLASS><![CDATA[" + "]]></CONTENTCLASS>");
		sb.append("</DATA>");

		response.setContentType("text/xml; charset=utf-8");
		
		// skyblue0o0 20180402 : 특정 유니코드 문자 포함 시 xml파싱 에러나서 빈칸으로 치환
		response.getWriter().print(sb.toString().replaceAll("[\\u0000-\\u0008\\u000B-\\u000C\\u000E-\\u001F]", " "));
		
		logger.debug("mailPrevShow ended.");
	}
	
	/**
	 * 미리보기 메일 본문 내용 화면 정보 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailPreviewContent.do")
	public String previewContent(@CookieValue("loginCookie") String loginCookie, Locale locale, HttpServletRequest request, Model model) throws Exception{
		logger.debug("previewContent started.");
		
		// get user credentials
		List<String> userCookieInfo = commonUtil.getUserIdAndPassword(loginCookie);
		String password  = userCookieInfo.get(1);
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
		String userEmail = userInfo.getId() + "@" + domainName;
		logger.debug("userEmail=" + userEmail);
		
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
        
        do {
    		try {
    			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
    					userEmail, password, egovMessageSource, locale, ezEmailUtil);
    			
    			if (retryFlag) {
    			    retryFlag = false;
    			}
    			
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
    				} else {
    					bodyInfoList = ezEmailUtil.getBodyInfo(message, folderPath, uid, -1, null, false, false, locale, null, null);
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
    							OrganUserVO userVO = ezOrganAdminService.getUserInfo(userInfo.getId(), userInfo.getPrimary(), userInfo.getTenantId());
    							
    							SMTPAccess sa = SMTPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.SMTPPort"),
    									userEmail, password);
    							
    							processAutoMDN(sa, message, userInfo.getEmail(), userVO.getDisplayName(), userInfo.getTenantId());
    						}
    						else {
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
    		} catch (Exception e) {
    			e.printStackTrace();
    			
                retryFlag = true;
                --retryCount;
                
                if (retryCount > -1) {
                    logger.debug("Message read fail. Retry...");
                    
                    try {
                        Thread.sleep(1000);
                    } catch (Exception ex) {}
                }    			
    		} finally {
    			if (ia != null) {
    				ia.close();
    			}
    		}        
        } while (retryFlag && retryCount > -1);		
		
        String htmlBody = bodyInfoList.get(0);
        Pattern p = Pattern.compile("<base\\s+href.*?>", Pattern.CASE_INSENSITIVE | Pattern.DOTALL);
		Matcher m = p.matcher(htmlBody);
		htmlBody = m.replaceAll("");
		htmlBody = htmlBody.replace("{", "%7B").replace("}", "%7D");
        		
		// 2018-08-03 황윤호 추가
        String memoFlag = "";
        if (ezCommonService.getTenantConfig("useMemo", userInfo.getTenantId()).equalsIgnoreCase("YES")) {
        	memoFlag = "YES";
        } else {
        	memoFlag = "NO";
        }
		
		logger.debug("readMailContent ended.");
		model.addAttribute("url", url);
		model.addAttribute("htmlBody", htmlBody);
		model.addAttribute("pAttachListHtml", bodyInfoList.get(1));
		model.addAttribute("pAttachListHtmlSub", pAttachListHtmlSub);
		model.addAttribute("isAttach", bodyInfoList.get(4));
		model.addAttribute("sentDateMsg", sentDateMsg); // 전달, 회신 시 보낸 시간 
		model.addAttribute("memoFlag", memoFlag);
		
		logger.debug("previewContent ended.");
		
		return "ezEmail/mailPreviewContent";
	}	
	
	/**
	 * 메일 인쇄
	 */
	@RequestMapping(value="/ezEmail/mailPrint.do")
	public String mailPrint(@CookieValue("loginCookie") String loginCookie, Locale locale, HttpServletRequest request, Model model) throws Exception{
		logger.debug("mailPrint started.");
		
		String pSender = "";
		String pReciveDT = "";
		String pReciverTo = "";
		String pReciverCc = "";
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
		logger.debug("userEmail=" + userEmail);
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
						/**
						 * 인쇄할 때 보낸 사람, 받는 사람, 참조에 메일 주소가 없는 경우(a@a.com)
						 * 메일 주소가 나타나지 않도록 처리
						 */
						
                        if (propertyValue.equals("YES") || propertyValue.equals("")) {
                            pSender = personName;                                  
                            pSender += fromAddress.getAddress() == null || ((InternetAddress)fromAddress).getAddress().equals("a@a.com") ? "" : "(" + fromAddress.getAddress() + ")";
	                    } else {
	                    	pSender = personName;                                  
	                    }						
					}
					logger.debug("From=" + pSender);
					
					Address[] toAddresses = message.getRecipients(RecipientType.TO);
					Address[] ccAddresses = message.getRecipients(RecipientType.CC);
					
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
                                pReciverTo += ((InternetAddress)address).getAddress() == null || ((InternetAddress)address).getAddress().equals("a@a.com") ? "\t" : "(" + ((InternetAddress)address).getAddress() + ")\t";                                                                      
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
								pReciverCc += ((InternetAddress)address).getAddress() == null || ((InternetAddress)address).getAddress().equals("a@a.com") ? "\t" : "(" + ((InternetAddress)address).getAddress() + ")\t";
							} else {
								pReciverCc += personName + "\t";								
							}
						}
					}
					logger.debug("CC=" + pReciverCc);
					
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
					
					List<String> bodyInfoList = ezEmailUtil.getBodyInfo(message, folderPath, uid, -1, null, true, false, locale, null, null);
					pBody = bodyInfoList.get(0);
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
			e.printStackTrace();
		} finally {
			if (ia != null) {
				ia.close();
			}
		}
		
		model.addAttribute("pSender", pSender);
		model.addAttribute("pReciveDT", pReciveDT);
		model.addAttribute("pReciverTo", pReciverTo);
		model.addAttribute("pReciverCc", pReciverCc);
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
	@RequestMapping(value="/ezEmail/mailDelReadInterAttach.do", produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String mailDelInterAttach(@CookieValue("loginCookie") String loginCookie, Locale locale, HttpServletRequest request, Model model) throws Exception{
		logger.debug("mailDelInterAttach started.");
		
		List<String> userInfo = commonUtil.getUserIdAndPassword(loginCookie);
		String password  = userInfo.get(1);
		
		LoginVO loginInfo = commonUtil.userInfo(loginCookie);
		String domainName = ezCommonService.getTenantConfig("DomainName", loginInfo.getTenantId());
		String userEmail = loginInfo.getId() + "@" + domainName;
		logger.debug("userEmail=" + userEmail);
		
		Document xmlDoc = commonUtil.convertRequestToDocument(request);
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
		
		String returnValue = "<DATA><![CDATA[";
		
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
			
			Folder f = ia.getFolder(folderPath);
			
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
		} catch (MessagingException e) {
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
		
		returnValue += "]]></DATA>";
		logger.debug("returnValue=" + returnValue);
		
		logger.debug("mailDelInterAttach ended.");
		return returnValue;
	}
	
	@RequestMapping(value="/ezEmail/mailReadBoard.do", produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String mailReadBoard(@CookieValue("loginCookie") String loginCookie, Locale locale, @RequestBody String bodyData, HttpServletRequest request, Model model) throws Exception{
		logger.debug("mailReadBoard started.");
		
		Document xmldom = commonUtil.convertStringToDocument(bodyData);
		String url = xmldom.getElementsByTagName("URL").item(0).getTextContent();
		String newGuid = xmldom.getElementsByTagName("NEWGUID").item(0).getTextContent();
		String attachLimit = xmldom.getElementsByTagName("ATTACHLIMIT").item(0).getTextContent();
		logger.debug("url=" + url + ",newGuid=" + newGuid + ",attachLimit=" + attachLimit);
		
		String folderPath = url.split("/")[0];
		String uidStr = url.split("/")[1];
		long uid = Long.parseLong(uidStr);
		
		List<String> userInfo = commonUtil.getUserIdAndPassword(loginCookie);
		String password  = userInfo.get(1);
		
		LoginVO loginInfo = commonUtil.userInfo(loginCookie);
		String domainName = ezCommonService.getTenantConfig("DomainName", loginInfo.getTenantId());
		String userAccount = loginInfo.getId() + "@" + domainName;
		
		StringBuilder sb = new StringBuilder();
		sb.append("<DATA>");
		
		IMAPAccess ia = null;
		try {
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userAccount, password, egovMessageSource, locale, ezEmailUtil);
			
			Folder f = ia.getFolder(folderPath);
			
			if (f.exists()) {
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
					List<String> bodyInfoList = ezEmailUtil.getBodyInfo(message, folderPath, uid, -1, attachedFileList, false, false, locale, null, null);
					
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

							String realPath = commonUtil.getRealPath(request);
							String path = commonUtil.getUploadPath("upload_board.TEMPUPLOADFILE", loginInfo.getTenantId());

							String attach = ""; 

							for (int i=0; i<attachedFileList.size(); i++) {
								MimeBodyPart part = (MimeBodyPart)ezEmailUtil.getAttachPart(message, i + 1);

								if (part != null) {
									String orgFileName = attachedFileList.get(i).get("filename");
									String fileName = newGuid + "_" + orgFileName;

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
			
		} catch (MessagingException e) {
			e.printStackTrace();
		} finally {
			if (ia != null) {
				ia.close();
			}
		}
		
		sb.append("</DATA>");
		
		logger.debug("mailReadBoard ended.");
		
		return sb.toString();
	}
	
	@RequestMapping(value="/ezEmail/mailReadBoardDotNet.do", produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String mailReadBoardDotNet(@CookieValue("loginCookie") String loginCookie, Locale locale, @RequestBody String bodyData, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception{
		logger.debug("mailReadBoardDotNet started.");
		
		Document xmldom = commonUtil.convertStringToDocument(bodyData);
		String url = xmldom.getElementsByTagName("URL").item(0).getTextContent();
		String newGuid = UUID.randomUUID().toString();
		newGuid = "{" + newGuid + "}";
		
		logger.debug("url=" + url);
		
		String folderPath = url.split("/")[0];
		String uidStr = url.split("/")[1];
		long uid = Long.parseLong(uidStr);
		
		List<String> userInfo = commonUtil.getUserIdAndPassword(loginCookie);
		String password  = userInfo.get(1);
		
		LoginVO loginInfo = commonUtil.userInfo(loginCookie);
		String domainName = ezCommonService.getTenantConfig("DomainName", loginInfo.getTenantId());
		String userAccount = loginInfo.getId() + "@" + domainName;
		
		StringBuilder sb = new StringBuilder();
		sb.append("<DATA>");
		
		IMAPAccess ia = null;
		try {
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userAccount, password, egovMessageSource, locale, ezEmailUtil);
			
			Folder f = ia.getFolder(folderPath);
			
			if (f.exists()) {
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
					List<String> bodyInfoList = ezEmailUtil.getBodyInfo(message, folderPath, uid, -1, attachedFileList, false, false, locale, null, null);
					
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
			
		} catch (MessagingException e) {
			e.printStackTrace();
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
	@RequestMapping(value="/ezEmail/readSecureMail.do")
	public String readSecureMail(HttpServletRequest request, Model model) throws Exception{
		logger.debug("readSecureMail started.");
		
		IMAPAccess ia = null;
		FileOutputStream fos = null;
		FileInputStream fis = null;
		Address[] arrFroms = null;
		Address[] arrRecipientsTo = null;
		Address[] arrRecipientsCC = null;
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
			secureKey = egovFileScrty.decryptAES(secureKey);
			securePassword = request.getParameter("securePassword");
			logger.debug("secureKey=" + secureKey + ",password=" + securePassword);
			
			String[] secureArr = secureKey.split("/");
			String reader = secureArr[0];
			String secureId = secureArr[1];
			String sender = secureArr[2];
			logger.debug("reader=" + reader + ",secureId=" + secureId + ",sender=" + sender);
			
			// secureKey는 메일 본문내용 호출에 쓰이기 때문에 secureKey를 다시 암호화한다.
			secureKey = egovFileScrty.encryptAES(secureKey);
			
			// securePassword는 암호 체크와 메일 본문내용 호출에 쓰이기 때문에 securePassword를 다시 암호화한다.
			securePassword = egovFileScrty.encryptAES(securePassword);
			
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
					fos.close();
					fos = null;
					
					File decryptedFile = new File(pDirPath + commonUtil.separator + UUID.randomUUID().toString());
					egovFileScrty.cryptFile(Cipher.DECRYPT_MODE, file, decryptedFile);
					
					// 임시파일 삭제
					if (file.delete()) {
						logger.debug("file is deleted. fileName=" + file.getName());
					}
					
					SMTPAccess sa = SMTPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.SMTPPort"),
							secureInfo.getUserAccount(), jspw);
					
					fis = new FileInputStream(decryptedFile);
					message = sa.readMimeMessage(fis);
					
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
							
							logger.debug("CC=" + name + ((InternetAddress)arrRecipientsCC[i]).getAddress());
							
							if (ccListme) {
								if (((InternetAddress)arrRecipientsCC[i]).getAddress().equals(userAccount)) {
									if (arrRecipientsCC.length > 1) {
										ccStr = getReceiverHTML(name, ((InternetAddress)arrRecipientsCC[i]).getAddress(), true) + "<span>&nbsp;(" + egovMessageSource.getMessage("ezEmail.t10000", locale) + arrRecipientsCC.length + egovMessageSource.getMessage("ezEmail.t10001", locale) + ")&nbsp;<img src='/images/expnd.gif'  style='cursor:pointer;' onclick='ShowHiddenCc(this);' align='absmiddle'></span>";
									} else {
										ccStr = getReceiverHTML(name, ((InternetAddress)arrRecipientsCC[i]).getAddress(), true);
									}
								}
								if (ccHiddenStr == null) {
									ccHiddenStr = getReceiverHTML(name, ((InternetAddress)arrRecipientsCC[i]).getAddress(), true);
								} else {
									ccHiddenStr += " , " + getReceiverHTML(name, ((InternetAddress)arrRecipientsCC[i]).getAddress(), true);
								}
							} else {
								if (i == 0) {
									if (arrRecipientsCC.length > 1) {
										ccStr = getReceiverHTML(name, ((InternetAddress)arrRecipientsCC[i]).getAddress(), true) + "<span>&nbsp;(" + egovMessageSource.getMessage("ezEmail.t10000", locale) + arrRecipientsCC.length + egovMessageSource.getMessage("ezEmail.t10001", locale) + ")&nbsp;<img src='/images/expnd.gif'  style='cursor:pointer;' onclick='ShowHiddenCc(this);' align='absmiddle'></span>";
									} else {
										ccStr = getReceiverHTML(name, ((InternetAddress)arrRecipientsCC[i]).getAddress(), true);
									}
								}
								if (ccHiddenStr == null) {
									ccHiddenStr = getReceiverHTML(name, ((InternetAddress)arrRecipientsCC[i]).getAddress(), true);
								} else {
									ccHiddenStr += " , " + getReceiverHTML(name, ((InternetAddress)arrRecipientsCC[i]).getAddress(), true);
								}
							}
						}
					}
	
					if (ccStr == null || ccStr.equals("")) {
						pIsCCFg = "N";
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
					
					model.addAttribute("c1", egovMessageSource.getMessage("ezEmail.c1", locale));
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
			e.printStackTrace();
			//TODO
		} finally {
			if (fis != null) {
				try { fis.close(); } catch (Exception e) {}
			}
			if (fos != null) {
				try { fos.close(); } catch (Exception e) {}
			}
			if (ia != null) {
				try { ia.close(); } catch (Exception e) {}
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
	@RequestMapping(value="/ezEmail/downloadSecureAttach.do")
	public void downloadSecureAttach(HttpServletRequest request, HttpServletResponse response) throws Exception{
		logger.debug("downloadSecureAttach started.");
		
		IMAPAccess ia = null;
		FileOutputStream fos = null;
		FileInputStream fis = null;
		
		try {
			String secureKey = request.getParameter("secureKey");
			secureKey = egovFileScrty.decryptAES(secureKey);
			String securePassword = request.getParameter("securePassword");
			String indexStr = request.getParameter("index");
			String filename = request.getParameter("filename");
			logger.debug("secureKey=" + secureKey + ",securePassword=" + securePassword + ",indexStr=" + indexStr + ",filename=" + filename);
			
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
						fos.close();
						fos = null;
						
						egovFileScrty.cryptFile(Cipher.DECRYPT_MODE, file, decryptedFile);
						
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
							response.addHeader("content-disposition", "attachment; filename=\"" + filename + "\"");
							logger.debug("content-disposition=" + "attachment; filename=\"" + filename + "\"");
							
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
						
						// 임시파일 삭제
						if (decryptedFile.delete()) {
							logger.debug("decryptedFile is deleted. fileName=" + decryptedFile.getName());
						}
					}
				}
			}
		} catch (MessagingException e) {
			//TODO
			
			e.printStackTrace();
		} finally {
			if (fis != null) {
				try { fis.close(); } catch (Exception e) {}
			}
			if (fos != null) {
				try { fos.close(); } catch (Exception e) {}
			}
			if (ia != null) {
				try { ia.close(); } catch (Exception e) {}
			}
		}
		
		logger.debug("downloadSecureAttach ended.");
	}

	/**
	 * 보안메일 인라인 이미지 읽어오기 실행 함수
	 */
	@RequestMapping(value="/ezEmail/downloadSecureInline.do")
	public void downloadSecureInline(HttpServletRequest request, HttpServletResponse response) throws Exception{
		logger.debug("downloadSecureInline started.");
		
		IMAPAccess ia = null;
		FileOutputStream fos = null;
		FileInputStream fis = null;
		
		try {
			String secureKey = request.getParameter("secureKey");
			secureKey = egovFileScrty.decryptAES(secureKey);
			String securePassword = request.getParameter("securePassword");
			String contentId = request.getParameter("contentId");
			logger.debug("secureKey=" + secureKey + ",securePassword=" + securePassword + ",contentId=" + contentId);
			
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
				contentId = EgovStringUtil.getHtmlStrCnvr(contentId);
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
						fos.close();
						fos = null;
						
						egovFileScrty.cryptFile(Cipher.DECRYPT_MODE, file, decryptedFile);
						
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
								}
								
								if (ia != null) {
									ia.close();
								}
								
								return;
							}
		
							try {
								output.flush();
							} catch (IOException e) {
							}
							
							try {
								output.close();
							} catch (IOException e) {
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
			//TODO
			
			e.printStackTrace();
		} finally {
			if (fis != null) {
				try { fis.close(); } catch (Exception e) {}
			}
			if (fos != null) {
				try { fos.close(); } catch (Exception e) {}
			}
			if (ia != null) {
				try { ia.close(); } catch (Exception e) {}
			}
		}
		
		logger.debug("downloadSecureInline ended.");
	}

	/**
	 * 보안메일 원본내용 읽기화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/readSecureMailContent.do")
	public String readSecureMailContent(HttpServletRequest request, Model model) throws Exception{
		logger.debug("readSecureMailContent started.");
		
		IMAPAccess ia = null;
		FileOutputStream fos = null;
		FileInputStream fis = null;
		List<String> bodyInfoList = null;
		String pAttachListHtmlSub = null;
		
		try {
			String secureKey = request.getParameter("secureKey");
			secureKey = egovFileScrty.decryptAES(secureKey);
			String securePassword = request.getParameter("securePassword");
			logger.debug("secureKey=" + secureKey + ",securePassword=" + securePassword);
			
			String reader = secureKey.split("/")[0];
			String secureId = secureKey.split("/")[1];
			logger.debug("reader=" + reader + ",secureId=" + secureId);
			
			// secureKey는 메일 인라인이미지, 첨부파일 다운로드 호출에 쓰이기 때문에 secureKey를 다시 암호화한다.
			secureKey = egovFileScrty.encryptAES(secureKey);
			
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
						fos.close();
						fos = null;
						
						File decryptedFile = new File(pDirPath + commonUtil.separator + UUID.randomUUID().toString());
						egovFileScrty.cryptFile(Cipher.DECRYPT_MODE, file, decryptedFile);
						
						// 임시파일 삭제
						if (file.delete()) {
							logger.debug("file is deleted. fileName=" + file.getName());
						}
						
						SMTPAccess sa = SMTPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.SMTPPort"),
								userAccount, jspw);
						
						fis = new FileInputStream(decryptedFile);
						message = sa.readMimeMessage(fis);
						
						bodyInfoList = ezEmailUtil.getBodyInfo(message, null, 0, -1, null, false, false, locale, secureKey, securePassword);
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
				
				String resultString = ezEmailService.updateSecureMailReaderInfo(secureId, reader);
				if (!resultString.equals("OK")) {
					//TODO
				}
				
				model.addAttribute("htmlBody", bodyInfoList.get(0));
				model.addAttribute("pAttachListHtml", bodyInfoList.get(1));
				model.addAttribute("pAttachListHtmlSub", pAttachListHtmlSub);
				model.addAttribute("isAttach", bodyInfoList.get(4));
				
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
		} catch (Exception e) {
			e.printStackTrace();
			//TODO
		} finally {
			if (fis != null) {
				try { fis.close(); } catch (Exception e) {}
			}
			if (fos != null) {
				try { fos.close(); } catch (Exception e) {}
			}
			if (ia != null) {
				try { ia.close(); } catch (Exception e) {}
			}
		}
		
		logger.debug("readSecureMailContent ended.");
		return "ezEmail/mailReadContentSecure";
	}
	
	/**
	 * 보안메일 정보화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/secureMailInfo.do")
	public String secureMailInfo(@CookieValue("loginCookie") String loginCookie, Locale locale, HttpServletRequest request, Model model) throws Exception{
		logger.debug("secureMailInfo started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String url = request.getParameter("url");
		logger.debug("url=" + url);
		
		MailSecureVO secureInfo = ezEmailService.getSecureMailInfoWithPassword(userInfo.getId(), userInfo.getTenantId(), url);
		
		// securePassword 복호화
		String securePassword = secureInfo.getPassword();
		securePassword = egovFileScrty.decryptAES(securePassword);
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
		/**
		 * 메일 주소가 없을 경우('a@a.com') 
		 * 마우스 오버를 해도 메일 주소가 나타나지 않도록 처리.
		 **/
		if (address.equals("a@a.com")) { 
			address = "";
		}
		
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
			String[] mdnHeaders = message.getHeader("Disposition-Notification-To");
			
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
										
				sa.sendMessageWithNewTransport(replyMessage);
				
				ezEmailUtil.setMDNSentFlag(message, true);
			}
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		
		logger.debug("processAutoMDN ended.");
	}
	
	/**
	 *  편지함 모두 읽기
	 */
	@RequestMapping(value="/ezEmail/folderSetReadChange.do",method=RequestMethod.POST,
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
		
		
		logger.debug("url: " + folderId);
		logger.debug("userAccount=" + userAccount);
			
		
		String returnData = "<DATA>OK</DATA>";
		
		IMAPAccess ia = null;
		
		try {
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"), userAccount, 
								password, egovMessageSource, locale, ezEmailUtil);
			
			IMAPFolder sourceFolder = (IMAPFolder) ia.getFolder(folderId);
			sourceFolder.open(Folder.READ_WRITE);
			
			Message[] msgs = sourceFolder.getMessages();
			
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
		logger.debug("folderSetReadChange started.");
		
		return returnData;
	}
	
	/**
	 * 메일 읽기 창에서 주소록에 추가 아이콘 클릭 시 나타나는 주소 추가 화면 출력
	 */
	@RequestMapping(value="/ezEmail/mailSelectAddress.do")
	public String mailSelectAddress(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception{
		logger.debug("mailSelectAddress started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String url = request.getParameter("url");
		String myEmail = userInfo.getEmail();
		
		model.addAttribute("url", url);
		model.addAttribute("myEmail", myEmail);
		
		logger.debug("mailSelectAddress ended.");
		return "ezEmail/mailSelectAddress";
	}
	
	/**
	 * 메일 주소 리스트 가져오는 함수
	 */
	@RequestMapping(value="/ezEmail/getMailAddressList.do")
	@ResponseBody
	public String getMailAddressList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Locale locale) throws Exception{
		logger.debug("getMailAddressList started.");
		Map<String, Object> result = new HashMap<String, Object>();
		
		String url = request.getParameter("url");
		logger.debug("url=" + url);
		
		try {
			int index = url.lastIndexOf("/");
			String folderPath = url.substring(0, index);
			long uid = Long.parseLong(url.substring(index + 1));
			
			// get user credentials
			List<String> userCookieInfo = commonUtil.getUserIdAndPassword(loginCookie);
			String password = userCookieInfo.get(1);
			
			LoginVO userInfo = commonUtil.userInfo(loginCookie);
			String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
			String userAccount = userInfo.getId() + "@" + domainName;
			
			List<Map<String, String>> fromList = new ArrayList<Map<String, String>>();
			List<Map<String, String>> toList = new ArrayList<Map<String, String>>();
			List<Map<String, String>> ccList = new ArrayList<Map<String, String>>();
			List<Map<String, String>> bccList = new ArrayList<Map<String, String>>();
			Map<String, String> map = null;
			
			IMAPAccess ia = null;
			
			try {
				ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
						userAccount, password, egovMessageSource, locale, ezEmailUtil);
				Folder f = ia.getFolder(folderPath);
				
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
			} catch (MessagingException e) {
				e.printStackTrace();
				result.put("status", "error");
			} finally {
				if (ia != null) {
					ia.close();
				}
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
		}
		
		logger.debug("getMailAddressList ended.");
		return new JSONObject(result).toString();
	}
}
