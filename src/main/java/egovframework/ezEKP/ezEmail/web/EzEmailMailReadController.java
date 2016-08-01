package egovframework.ezEKP.ezEmail.web;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.URI;
import java.net.URLDecoder;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Properties;

import javax.annotation.Resource;
import javax.mail.Address;
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
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimePart;
import javax.mail.internet.MimeUtility;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.codec.binary.Base64;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

import com.sun.mail.dsn.DispositionNotification;
import com.sun.mail.dsn.MultipartReport;
import com.sun.mail.imap.AppendUID;
import com.sun.mail.imap.IMAPFolder;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezEmail.logic.IMAPAccess;
import egovframework.ezEKP.ezEmail.logic.SMTPAccess;
import egovframework.ezEKP.ezEmail.util.EzEmailUtil;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovStringUtil;

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
	private EzOrganAdminService ezOrganAdminService;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource; 
	
	/**
	 * 메일 읽기화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailRead.do")
	public String readMail(@CookieValue("loginCookie") String loginCookie, Locale locale, HttpServletRequest request, Model model) throws Exception {
		// get user credentials
		List<String> userInfo = commonUtil.getUserIdAndPassword(loginCookie);
		String id = userInfo.get(0);
		String password  = userInfo.get(1);

		// retrieve the passed in parameters
		String url = request.getParameter("iptURL");
		if (url == null) {
			url = request.getParameter("URL");
		}
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
		String useEzKMS = config.getProperty("config.Use_ezKMS") == null ? "" : config.getProperty("config.Use_ezKMS");
		IMAPAccess ia = null;
		
		try {
			
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					id+"@"+config.getProperty("config.DomainName"), password, egovMessageSource, locale);
			Folder f = ia.getFolder(folderPath);
			
			if(f != null){
				f.open(Folder.READ_WRITE);
				
				Message message = null;
				if(f.isOpen() && f instanceof IMAPFolder){
					message = ((IMAPFolder)f).getMessageByUID(uid);
				}
				
				if (message != null) {
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
					
					// TO
					arrRecipientsTo = message.getRecipients(Message.RecipientType.TO);
					if(arrRecipientsTo != null){
						boolean toListme = false;
						for(int i=0; i<arrRecipientsTo.length; i++){
							if(((InternetAddress)arrRecipientsTo[i]).getAddress().equals(id+"@"+config.getProperty("config.DomainName"))){
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
							
							if(toListme){
								if(((InternetAddress)arrRecipientsTo[i]).getAddress().equals(id+"@"+config.getProperty("config.DomainName"))){
									if(arrRecipientsTo.length > 1){
										toStr = getReceiverHTML(name, ((InternetAddress)arrRecipientsTo[i]).getAddress()) + "<span>&nbsp;(" + egovMessageSource.getMessage("ezEmail.t10000", locale) + arrRecipientsTo.length + egovMessageSource.getMessage("ezEmail.t10001", locale) + ")&nbsp;<img src='/images/expnd.gif'  style='cursor:hand;' onclick='ShowHiddenTo(this);' align='absmiddle'></span>";
									} else {
										toStr = getReceiverHTML(name, ((InternetAddress)arrRecipientsTo[i]).getAddress());
									}
								}
								if(toHiddenStr == null){
									toHiddenStr = getReceiverHTML(name, ((InternetAddress)arrRecipientsTo[i]).getAddress());
								} else{
									toHiddenStr += " , " + getReceiverHTML(name, ((InternetAddress)arrRecipientsTo[i]).getAddress());
								}
							} else {
								if(i == 0){
									if(arrRecipientsTo.length > 1){
										toStr = getReceiverHTML(name, ((InternetAddress)arrRecipientsTo[i]).getAddress()) + "<span>&nbsp;(" + egovMessageSource.getMessage("ezEmail.t10000", locale) + arrRecipientsTo.length + egovMessageSource.getMessage("ezEmail.t10001", locale) + ")&nbsp;<img src='/images/expnd.gif'  style='cursor:hand;' onclick='ShowHiddenTo(this);' align='absmiddle'></span>";
									} else {
										toStr = getReceiverHTML(name, ((InternetAddress)arrRecipientsTo[i]).getAddress());
									}
								}
								if(toHiddenStr == null){
									toHiddenStr = getReceiverHTML(name, ((InternetAddress)arrRecipientsTo[i]).getAddress());
								} else {
									toHiddenStr += " , " + getReceiverHTML(name, ((InternetAddress)arrRecipientsTo[i]).getAddress());
								}
							}
						}
					}
	
					// CC
					arrRecipientsCC = message.getRecipients(Message.RecipientType.CC);
					if(arrRecipientsCC != null){
						boolean ccListme = false;
						for(int i=0; i<arrRecipientsCC.length; i++){
							if(((InternetAddress)arrRecipientsCC[i]).getAddress().equals(id+"@"+config.getProperty("config.DomainName"))){
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
							
							if (ccListme) {
								if (((InternetAddress)arrRecipientsCC[i]).getAddress().equals(id+"@"+config.getProperty("config.DomainName"))) {
									if (arrRecipientsCC.length > 1) {
										ccStr = getReceiverHTML(name, ((InternetAddress)arrRecipientsCC[i]).getAddress()) + "<span>&nbsp;(" + egovMessageSource.getMessage("ezEmail.t10000", locale) + arrRecipientsCC.length + egovMessageSource.getMessage("ezEmail.t10001", locale) + ")&nbsp;<img src='/images/expnd.gif'  style='cursor:hand;' onclick='ShowHiddenCc(this);' align='absmiddle'></span>";
									} else {
										ccStr = getReceiverHTML(name, ((InternetAddress)arrRecipientsCC[i]).getAddress());
									}
								}
								if (ccHiddenStr == null) {
									ccHiddenStr = getReceiverHTML(name, ((InternetAddress)arrRecipientsCC[i]).getAddress());
								} else {
									ccHiddenStr += " , " + getReceiverHTML(name, ((InternetAddress)arrRecipientsCC[i]).getAddress());
								}
							} else {
								if (i == 0) {
									if (arrRecipientsCC.length > 1) {
										ccStr = getReceiverHTML(name, ((InternetAddress)arrRecipientsCC[i]).getAddress()) + "<span>&nbsp;(" + egovMessageSource.getMessage("ezEmail.t10000", locale) + arrRecipientsCC.length + egovMessageSource.getMessage("ezEmail.t10001", locale) + ")&nbsp;<img src='/images/expnd.gif'  style='cursor:hand;' onclick='ShowHiddenCc(this);' align='absmiddle'></span>";
									} else {
										ccStr = getReceiverHTML(name, ((InternetAddress)arrRecipientsCC[i]).getAddress());
									}
								}
								if (ccHiddenStr == null) {
									ccHiddenStr = getReceiverHTML(name, ((InternetAddress)arrRecipientsCC[i]).getAddress());
								} else {
									ccHiddenStr += " , " + getReceiverHTML(name, ((InternetAddress)arrRecipientsCC[i]).getAddress());
								}
							}
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
							if (i != 0) {
								bccStr += ", ";
							}
							bccStr += getReceiverHTML(name, ((InternetAddress)arrRecipientsBCC[i]).getAddress());
						}
					}
					
					if (ccStr == null || ccStr.equals("")) {
						pIsCCFg = "N";
					}
					
					// received date
					date = message.getReceivedDate();
					if (date != null) {
						dateStr = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault()).format(date);
					}
	
					// subject
					subject = message.getSubject();
					
					if (subject != null && !subject.equals("")) {
						String[] rawHeaders = message.getHeader("subject");
						String rawHeader = rawHeaders[0];
						
						if (!ezEmailUtil.isPureAscii(rawHeader)) {
							byte[] rawBytes = rawHeader.getBytes("iso-8859-1");
							
							subject = ezEmailUtil.decodeNonAsciiBytes(rawBytes);
						}
					}
					
					if (subject != null) {
						title = egovMessageSource.getMessage("ezEmail.t565", locale) + subject;
					}
					
					if (!message.isSet(Flag.SEEN)) {
						message.setFlag(Flag.SEEN, true);
						pReadFlag = "N";
					}
					
					if (message.getFolder().getFullName().equals(egovMessageSource.getMessage("ezEmail.t99000026", locale))) {
						isSentItems = true;
					}
					
					if (message.getFolder().getFullName().equals(egovMessageSource.getMessage("ezEmail.t99000028", locale))) {
						isDelete = "BDELETE";
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
		model.addAttribute("pnFlag", pnFlag);
		model.addAttribute("pIsCCFg", pIsCCFg);
		model.addAttribute("useEzKMS", useEzKMS);
		
		return "ezEmail/mailRead";
	}
	
	/**
	 * 메일 본문 내용 화면 정보 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailReadContent.do")
	public String readMailContent(@CookieValue("loginCookie") String loginCookie, Locale locale, HttpServletRequest request, Model model) throws Exception {
		String rejectKeyWord = "";
		
		// get user credentials
		List<String> userInfo = commonUtil.getUserIdAndPassword(loginCookie);
		String id = userInfo.get(0);
		String password = userInfo.get(1);

		// retrieve user info from db.
		OrganUserVO userVO = ezOrganAdminService.getUserInfo(id, "1"); //추후 lang(두번째 파라미터) 수정
		
		// retrieve the passed in parameters
		long uid = Long.parseLong(request.getParameter("iptURL"));
		String folderPath = request.getParameter("iptFolderPath");
		String url = folderPath + "/" + request.getParameter("iptURL");
		
		String myEmailAddress = id+"@"+config.getProperty("config.DomainName");
		
		IMAPAccess ia = null;
		List<String> bodyInfoList = null;
		String pAttachListHtmlSub = null;
		
		try {
		
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
													myEmailAddress, password, egovMessageSource, locale);
			Folder f = ia.getFolder(folderPath);
			
			if (f != null) {
				f.open(Folder.READ_ONLY);
				Message message = null;
				
				if (f.isOpen() && f instanceof IMAPFolder) {
					message = ((IMAPFolder)f).getMessageByUID(uid);
				}
				
				if (message != null) {
					bodyInfoList = ezEmailUtil.getBodyInfo(message, folderPath, uid, -1, null, false);
					double size = Double.parseDouble(bodyInfoList.get(2));
					String strSize = ezEmailUtil.getSizeWithUnit(size);
					pAttachListHtmlSub = " - <b>" + bodyInfoList.get(3) + egovMessageSource.getMessage("ezEmail.t180", locale) + "</b>(" + strSize + ")";
					
					if (!folderPath.equals(egovMessageSource.getMessage("ezEmail.t99000026", locale))) {
						// send an MDN to the sender.
						if (!ezEmailUtil.hasMDNSentFlag(message)) {
							logger.debug("MDNSentFlag isn't set");
							
							SMTPAccess sa = SMTPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.SMTPPort"),
																	myEmailAddress, password);
							
							processAutoMDN(sa, message, myEmailAddress, userVO.getDisplayName());
						}
						else {
							logger.debug("MDNSentFlag is set");
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
		
		model.addAttribute("htmlBody", bodyInfoList.get(0));
		model.addAttribute("pAttachListHtml", bodyInfoList.get(1));
		model.addAttribute("pAttachListHtmlSub", pAttachListHtmlSub);
		model.addAttribute("isAttach", bodyInfoList.get(4));
		model.addAttribute("url", url);
		model.addAttribute("rejectKeyWord", rejectKeyWord);
		
		return "ezEmail/mailReadContent";
	}
	
	/**
	 * 메일 웹페이지로 보기 수행 함수
	 */
	@RequestMapping(value="/ezEmail/mailReadOriginal.do")
	public String readMailOriginal(@CookieValue("loginCookie") String loginCookie, Locale locale, HttpServletRequest request, Model model) throws Exception{
		// get user credentials
		List<String> userInfo = commonUtil.getUserIdAndPassword(loginCookie);
		String id = userInfo.get(0);
		String password = userInfo.get(1);

		// retrieve the passed in parameters
		String url = request.getParameter("url");
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
					id+"@"+config.getProperty("config.DomainName"), password, egovMessageSource, locale);
			Folder f = ia.getFolder(folderPath);
			
			if (f != null) {
				f.open(Folder.READ_ONLY);
				Message message = null;
				
				if (f.isOpen() && f instanceof IMAPFolder){
					message = ((IMAPFolder)f).getMessageByUID(uid);
				}
				
				if (message != null) {
					bodyInfoList = ezEmailUtil.getBodyInfo(message, folderPath, uid, -1, null, false);
				}
			}
		} catch (MessagingException e) {
			e.printStackTrace();
		} finally {
			if (ia != null) {
				ia.close();
			}
		}
		
		model.addAttribute("htmlBody", bodyInfoList.get(0));
		
		return "ezEmail/mailReadOriginal";
	}
	
	/**
	 * 메일 첨부파일 다운로드 실행 함수
	 */
	@RequestMapping(value="/ezEmail/downloadAttach.do")
	public void downloadAttach(@CookieValue("loginCookie") String loginCookie, Locale locale, HttpServletRequest request, HttpServletResponse response) throws Exception{
		// get user credentials
		List<String> userInfo = commonUtil.getUserIdAndPassword(loginCookie);
		String id = userInfo.get(0);
		String password  = userInfo.get(1);

		// retrieve the passed in parameters
		String folderPath = request.getParameter("folderPath");
		String strUid = request.getParameter("uid");
		long uid = strUid != null ? Long.parseLong(strUid) : 0;
		String filename = request.getParameter("filename");
		if(filename != null){
			filename = URLDecoder.decode(filename, "UTF-8");
		}
		String strIndex = request.getParameter("index");
		logger.debug("strIndex=" + strIndex);
		int index = -1;
		if(strIndex != null){
			index = Integer.parseInt(strIndex);
		}
		
		IMAPAccess ia = null;
		try {
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					id+"@"+config.getProperty("config.DomainName"), password, egovMessageSource, locale);
	
			Folder f = ia.getFolder(folderPath);
			if(f != null){
				f.open(Folder.READ_ONLY);
				Message message = null;
				if(f.isOpen() && f instanceof IMAPFolder){
					message = ((IMAPFolder)f).getMessageByUID(uid);
				}
				if(message != null){
					Part part = null;
					if(index == -1){
						part = message;
					}
					else{
						part = getAttachPart(message, index);
					}
					if(part != null){
						response.setContentType(part.getContentType());
						
						filename = CommonUtil.getEncodedFileNameForDownload(request.getHeader("User-Agent"), filename);						
						response.addHeader("content-disposition", "attachment; filename=\"" + filename + "\"");
						
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
						
						output.flush();
						output.close();
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
		
	}
	
	/**
	 * 메일 대용량 첨부파일 다운로드 실행 함수
	 */
	@RequestMapping(value="/ezEmail/downloadAttachCommon.do", produces = "text/xml; charset=utf-8")
	public void downloadAttachCommon(Locale locale, HttpServletRequest request, HttpServletResponse response) throws Exception {
		String fileId = request.getParameter("fileid") == null ? "" : request.getParameter("fileid");
		String fileDate = request.getParameter("filedate") == null ? "" : request.getParameter("filedate");
		
		String pDirPath = config.getProperty("upload_mail.ROOT");
		String realPath = config.getProperty("data_root");
		pDirPath = realPath + pDirPath;
		String xmlPath = pDirPath + commonUtil.separator + fileDate + commonUtil.separator + fileId;
		
		//get original filename from text file
		String fileName = "";
		File originalNameFile = new File(xmlPath + "__.txt");
		if (originalNameFile.exists()) {
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
		
		downFile(request, response, xmlPath, fileName);
	}
	
	/**
	 * 메일 인라인 이미지 읽어오기 실행 함수
	 */
	@RequestMapping(value="/ezEmail/downloadInline.do")
	public void downloadInline(@CookieValue("loginCookie") String loginCookie, Locale locale, HttpServletRequest request, HttpServletResponse response) throws Exception{
		// get user credentials
		List<String> userInfo = commonUtil.getUserIdAndPassword(loginCookie);
		String id = userInfo.get(0);
		String password  = userInfo.get(1);

		// retrieve the passed in parameters
		String folderPath = request.getParameter("folderPath");
		String strUid = request.getParameter("uid");
		long uid = strUid != null ? Long.parseLong(strUid) : 0;
		String contentId = request.getParameter("contentId");
		if(contentId != null){
			contentId = URLDecoder.decode(contentId, "UTF-8");
			contentId = EgovStringUtil.getHtmlStrCnvr(contentId);
		}	
		
		IMAPAccess ia = null;
		try {
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					id+"@"+config.getProperty("config.DomainName"), password, egovMessageSource, locale);
	
			Folder f = ia.getFolder(folderPath);
			if(f != null){
				f.open(Folder.READ_ONLY);
				Message message = null;
				if(f.isOpen() && f instanceof IMAPFolder){
					message = ((IMAPFolder)f).getMessageByUID(uid);
				}
				if(message != null){
					Part part = getInlinePart(message, contentId);
					if(part != null){
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
						output.flush();
						output.close();
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
	}

	/**
	 * 미리보기 메일 정보 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailPrevShow.do")
	public void mailPrevShow(@CookieValue("loginCookie") String loginCookie, Locale locale, HttpServletRequest request, HttpServletResponse response) throws Exception{
		// get user credentials
		List<String> userInfo = commonUtil.getUserIdAndPassword(loginCookie);
		String id = userInfo.get(0);
		String password  = userInfo.get(1);

		StringBuilder sbXml = new StringBuilder();
		char[] charBuffer = new char[128];
		int bytesRead=0;
		while ( (bytesRead = request.getReader().read(charBuffer)) != -1 ) {
			sbXml.append(charBuffer, 0, bytesRead);
		}
		Document doc = commonUtil.convertStringToDocument(sbXml.toString());
		String url = doc.getElementsByTagName("URL").item(0).getTextContent();
		long uid = 0;
		String folderPath = null;
		if(url != null){
			int index = url.lastIndexOf(commonUtil.separator);
			if(index != -1){
				folderPath = url.substring(0, index);
				uid = Long.parseLong(url.substring(index+1));
			}
		}
		logger.debug(folderPath);
		
		Address[] arrFroms = null;
		Address[] arrRecipientsTo = null;
		Address[] arrRecipientsCC = null;
		Address[] arrRecipientsBCC = null;
		Date date = null;
		String fromStr = null;
		String fromEmail = null;
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
					id+"@"+config.getProperty("config.DomainName"), password, egovMessageSource, locale);
			Folder f = ia.getFolder(folderPath);
			
			if (f != null) {
				f.open(Folder.READ_WRITE);
				Message message = null;
				
				if (f.isOpen() && f instanceof IMAPFolder) {
					message = ((IMAPFolder)f).getMessageByUID(uid);
				}
				
				if (message != null) {					
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
	
					date = message.getReceivedDate();
					if(date != null){
						dateStr = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault()).format(date);
					}
						
					subject = message.getSubject();
					
					if (subject != null && !subject.equals("")) {
						String[] rawHeaders = message.getHeader("subject");
						String rawHeader = rawHeaders[0];
						
						// 표준을 지키지 않고 Non-Ascii 문자가 사용된 경우엔 직접 디코딩을 처리한다.
						if (!ezEmailUtil.isPureAscii(rawHeader)) {
							byte[] rawBytes = rawHeader.getBytes("iso-8859-1");
							
							subject = ezEmailUtil.decodeNonAsciiBytes(rawBytes);
						}
					}
					
					if(!message.isSet(Flag.SEEN)){
						unread = 1;
					}
					message.setFlag(Flag.SEEN, true);
					
					String[] headers = message.getHeader("importance");
					String header = headers != null ? headers[0] : "normal";
					if (header.equalsIgnoreCase("high")) {
						importance = 2;
					} else if (header.equalsIgnoreCase("low")) {
						importance = 0;
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
		sb.append("<UNREAD><![CDATA["+unread+"]]></UNREAD>");
		sb.append("<DATE><![CDATA["+dateStr+"]]></DATE>");
		sb.append("<FROM><![CDATA["+fromStr+"]]></FROM>");
		sb.append("<FROMEMAIL><![CDATA["+fromEmail+"]]></FROMEMAIL>");
		sb.append("<FROMNAME><![CDATA["+fromStr+"]]></FROMNAME>");
		sb.append("<TO><![CDATA["+toStr+"]]></TO>");
		sb.append("<CC><![CDATA["+ccStr+"]]></CC>");
		sb.append("<BCC><![CDATA["+bccStr+"]]></BCC>");
		sb.append("<SUBJECT><![CDATA["+subject+"]]></SUBJECT>");
		sb.append("<HTMLDESCRIPTION><![CDATA["+"]]></HTMLDESCRIPTION>");
		sb.append("<COMMENT><![CDATA["+"]]></COMMENT>");
		sb.append("<IMPORTANCE><![CDATA["+importance+"]]></IMPORTANCE>");
		sb.append("<SENSITIVITY><![CDATA["+"Normal"+"]]></SENSITIVITY>");
		sb.append("<HASEMBEDED><![CDATA["+0+"]]></HASEMBEDED>");
		sb.append("<ITEMID><![CDATA["+url+"]]></ITEMID>");
		sb.append("<CONTENTCLASS><![CDATA["+"]]></CONTENTCLASS>");
		sb.append("</DATA>");

		response.setContentType("text/xml; charset=utf-8");
		response.getWriter().print(sb.toString());
	}
	
	/**
	 * 미리보기 메일 본문 내용 화면 정보 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailPreviewContent.do")
	public String previewContent(@CookieValue("loginCookie") String loginCookie, Locale locale, HttpServletRequest request, Model model) throws Exception{
		// get user credentials
		List<String> userInfo = commonUtil.getUserIdAndPassword(loginCookie);
		String id = userInfo.get(0);
		String password  = userInfo.get(1);
		
		// retrieve user info from db.
		OrganUserVO userVO = ezOrganAdminService.getUserInfo(id, "1"); //추후 lang(두번째 파라미터) 수정
		
		// retrieve the passed in parameters
		String url = request.getParameter("iptURL");
		long uid = 0;
		String folderPath = null;
		if (url != null) {
			int index = url.lastIndexOf(commonUtil.separator);
			if (index != -1) {
				folderPath = url.substring(0, index);
				uid = Long.parseLong(url.substring(index+1));
			}
		}

		String myEmailAddress = id+"@"+config.getProperty("config.DomainName");
		
		List<String> bodyInfoList = null;
		String pAttachListHtmlSub = "";
		IMAPAccess ia = null;
		
		try {
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
													myEmailAddress, password, egovMessageSource, locale);
			Folder f = ia.getFolder(folderPath);
	
			if (f != null) {
				f.open(Folder.READ_ONLY);
				Message message = null;
				if (f.isOpen() && f instanceof IMAPFolder) {
					message = ((IMAPFolder)f).getMessageByUID(uid);
				}
				if (message != null) {
					bodyInfoList = ezEmailUtil.getBodyInfo(message, folderPath, uid, -1, null, false);
					double size = Double.parseDouble(bodyInfoList.get(2));
					String strSize = ezEmailUtil.getSizeWithUnit(size);
					pAttachListHtmlSub = " - <b>" + bodyInfoList.get(3) + egovMessageSource.getMessage("ezEmail.t180", locale) + "</b>(" + strSize + ")";
	
					if (!folderPath.equals(egovMessageSource.getMessage("ezEmail.t99000026", locale))) {
						// send an MDN to the sender.
						if (!ezEmailUtil.hasMDNSentFlag(message)) {
							logger.debug("MDNSentFlag isn't set");
							
							SMTPAccess sa = SMTPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.SMTPPort"),
																	myEmailAddress, password);
							
							processAutoMDN(sa, message, myEmailAddress, userVO.getDisplayName());
						}
						else {
							logger.debug("MDNSentFlag is set");
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
		
		model.addAttribute("url", url);
		model.addAttribute("htmlBody", bodyInfoList.get(0));
		model.addAttribute("pAttachListHtml", bodyInfoList.get(1));
		model.addAttribute("pAttachListHtmlSub", pAttachListHtmlSub);
		model.addAttribute("isAttach", bodyInfoList.get(4));
		
		return "ezEmail/mailPreviewContent";
	}	
	
	/**
	 * 메일 인쇄
	 */
	@RequestMapping(value="/ezEmail/mailPrint.do")
	public String mailPrint(@CookieValue("loginCookie") String loginCookie, Locale locale, HttpServletRequest request, Model model) throws Exception{
		String pSender = "";
		String pReciveDT = "";
		String pReciverTo = "";
		String pReciverCc = "";
		String pSubject = "";
		String isAttach = "NO";
		String pAttachListHtml = "";
		String pBody = "";
		
		String url = null;
		long uid = 0;
		String folderPath = null;
		
		if (request.getParameter("URL") != null) {
			url = request.getParameter("URL");
		} else if (request.getParameter("iptURL") != null) {
			url = request.getParameter("iptURL");
		}
		
		if (url != null) {
			int index = url.lastIndexOf(commonUtil.separator);
			if (index != -1) {
				folderPath = url.substring(0, index);
				uid = Long.parseLong(url.substring(index+1));
			}
		}
		
		List<String> userInfo = commonUtil.getUserIdAndPassword(loginCookie);
		String id = userInfo.get(0);
		String password  = userInfo.get(1);
		
		IMAPAccess ia = null;
		try {
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					id+"@"+config.getProperty("config.DomainName"), password, egovMessageSource, locale);
			
			Folder f = ia.getFolder(folderPath);
			if (f != null) {
				f.open(Folder.READ_ONLY);
				Message message = ((IMAPFolder)f).getMessageByUID(uid);
				
				if (message != null) {
					
					if (message.getFrom() != null && message.getFrom().length > 0) {
						InternetAddress fromAddress = (InternetAddress)message.getFrom()[0];	
						String personName = fromAddress.getPersonal();
						personName = personName != null ? personName : "";
						String fromHeader = message.getHeader("From")[0];
						
						if (!ezEmailUtil.isPureAscii(fromHeader)) {
							byte[] rawBytes = personName.getBytes("iso-8859-1");
							
							personName = ezEmailUtil.decodeNonAsciiBytes(rawBytes);
						}						
						
						pSender = personName;												
						pSender += fromAddress.getAddress() == null ? "" : "(" + fromAddress.getAddress() + ")";
					}
					
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
							
							pReciverTo += personName;
							pReciverTo += ((InternetAddress)address).getAddress() == null ? "\t" : "(" + ((InternetAddress)address).getAddress() + ")\t";
						}
					}
					
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
							
							pReciverCc += personName;
							pReciverCc += ((InternetAddress)address).getAddress() == null ? "\t" : "(" + ((InternetAddress)address).getAddress() + ")\t";
						}
					}
					
					if (message.getReceivedDate() != null) {
						SimpleDateFormat sdFormat = new SimpleDateFormat("yyyy-MM-dd a h:mm:ss");
						pReciveDT = sdFormat.format(message.getReceivedDate());
					}
					
					pSubject = message.getSubject() == null ? "" : message.getSubject();
					
					if (pSubject != null && !pSubject.equals("")) {
						String[] rawHeaders = message.getHeader("subject");
						String rawHeader = rawHeaders[0];
						
						if (!ezEmailUtil.isPureAscii(rawHeader)) {
							byte[] rawBytes = rawHeader.getBytes("iso-8859-1");
							
							pSubject = ezEmailUtil.decodeNonAsciiBytes(rawBytes);
						}
					}
					
					List<String> bodyInfoList = ezEmailUtil.getBodyInfo(message, folderPath, uid, -1, null, true);
					pBody = bodyInfoList.get(0);
					pAttachListHtml = bodyInfoList.get(1);
					
					if (bodyInfoList.get(4).equals("OK")) {
						isAttach = "OK";
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
		model.addAttribute("pAttachListHtml", pAttachListHtml);
		model.addAttribute("pBody", pBody);
		
		return "ezEmail/mailPrint";
	}
	
	/**
	 * 메일읽기 - 첨부파일 삭제
	 */
	@RequestMapping(value="/ezEmail/mailDelReadInterAttach.do", produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String mailDelInterAttach(@CookieValue("loginCookie") String loginCookie, Locale locale, HttpServletRequest request, Model model) throws Exception{
		List<String> userInfo = commonUtil.getUserIdAndPassword(loginCookie);
		String id = userInfo.get(0);
		String password  = userInfo.get(1);
		
		Document xmlDoc = commonUtil.convertRequestToDocument(request);
		Element root = xmlDoc.getDocumentElement();
		
		String strFileId = root.getElementsByTagName("NAME").item(0).getTextContent();
		int fileId = Integer.parseInt(strFileId);
		
		String folderPath = null;
		long uid = 0;
		String url = root.getElementsByTagName("ITEMID").item(0).getTextContent();
		if (url != null) {
			int index = url.lastIndexOf("/");
			if (index != -1) {
				folderPath = url.substring(0, index);
				uid = Long.parseLong(url.substring(index + 1));
			}
		}
		
		String returnValue = "<DATA><![CDATA[";
		
		SMTPAccess sa = SMTPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.SMTPPort"),
				id+"@"+config.getProperty("config.DomainName"), password);
		
		IMAPAccess ia = null;
		try {
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					id+"@"+config.getProperty("config.DomainName"), password, egovMessageSource, locale);
			
			Folder folder = ia.getFolder(folderPath);
			folder.open(Folder.READ_WRITE);
			Message oldMessage = ((IMAPFolder)folder).getMessageByUID(uid);
			
			if (oldMessage != null) {
				MimeMessage newMessage = ezEmailUtil.deleteAttach(sa, oldMessage, new int[] {fileId});
				if (newMessage != null) {
					newMessage.setFlag(Flags.Flag.SEEN, true);
					AppendUID[] uids = ((IMAPFolder)folder).appendUIDMessages(new Message[]{newMessage});
					returnValue += folderPath + "/" + uids[0].uid;
				}
				oldMessage.setFlag(Flags.Flag.DELETED, true);
			}
			
			folder.close(true);
		} catch (MessagingException e) {
			e.printStackTrace();
		} finally {
			if (ia != null) {
				ia.close();
			}
		}
		
		returnValue += "]]></DATA>";
		
		return returnValue;
	}
	
	
	/**
	 * 메일 첨부파일 Part 반환 함수
	 */
	private Part getAttachPart(Part part, int index) throws MessagingException, IOException {
		if (part.isMimeType("multipart/*")){
			Part p = ((Multipart)part.getContent()).getBodyPart(index);
			
			return p;
		}
		
		return null;
	}
	
	/**
	 * 메일 인라인 이미지 Part 반환 함수
	 */
	private Part getInlinePart(Part part, String contentId) throws MessagingException, IOException{
		if(part.isMimeType("multipart/related")){
			Multipart mp = (Multipart)part.getContent();
			int count = mp.getCount();
			for (int i = 0; i < count; i++) {
				Part p = mp.getBodyPart(i);
				if(p instanceof MimePart){
					if(((MimePart)p).getContentID()!=null && ((MimePart)p).getContentID().equals(contentId)){
						return p;
					}
				}
			}
		} else if(part.isMimeType("multipart/*")){
			Multipart mp = (Multipart)part.getContent();
			int count = mp.getCount();
			Part p = null;
			for (int i = 0; i < count; i++) {
				p = getInlinePart(mp.getBodyPart(i), contentId);
				if(p != null){
					return p;
				}
			}
		}
		return null;
	}
	
	/**
	 * Receiver HTML 문자열 반환 함수
	 */
	private String getReceiverHTML(String name, String address){
		return "<span style='cursor:pointer' title='" + (name==null?"":EgovStringUtil.getSpclStrCnvr(name)) + "' onclick='show_personinfo(\"" + address + "\")'>" + (name==null?"":EgovStringUtil.getSpclStrCnvr(name)) + "</span>";
	}
	
	private void processAutoMDN(SMTPAccess sa, Message message, String myEmailAddress, String myName) {
		try {		
			String fromEmailAddress = ezEmailUtil.getFromEmailAddressOfMessage(message);
			
			int atSignIndex = fromEmailAddress.indexOf("@");
			
			if (fromEmailAddress.equals("") || atSignIndex == -1) {
				logger.debug("invalid fromEmailAddress=" + fromEmailAddress);
				return;
			}
			
			String fromEmailDomain = fromEmailAddress.substring(atSignIndex + 1);
			String myEmailDomain = myEmailAddress.substring(myEmailAddress.indexOf("@") + 1);
			
			logger.debug("fromEmailDomain=" + fromEmailDomain + ",myEmailDomain=" + myEmailDomain);
			
			if (!fromEmailDomain.equalsIgnoreCase(myEmailDomain)) {
				logger.debug("different domain");
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
				
				h.addHeader("Reporting-UA", "JMocha Mail 0.1");
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
	}
	
}
