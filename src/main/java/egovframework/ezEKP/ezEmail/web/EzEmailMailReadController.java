package egovframework.ezEKP.ezEmail.web;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Properties;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.annotation.Resource;
import javax.mail.Address;
import javax.mail.Flags.Flag;
import javax.mail.Folder;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Multipart;
import javax.mail.Part;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimePart;
import javax.mail.internet.MimeUtility;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.w3c.dom.Document;

import com.sun.mail.imap.IMAPFolder;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezEmail.logic.IMAPAccess;
import egovframework.ezEKP.ezEmail.util.EzEmailUtil;
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
public class EzEmailMailReadController {

	private static final Logger logger = LoggerFactory.getLogger(EzEmailMailReadController.class);

	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;

	@Autowired
	private EzEmailUtil ezEmailUtil;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource; 
	
	/**
	 * 메일 읽기화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailRead.do")
	public String readMail(@CookieValue("loginCookie") String loginCookie, Locale locale, HttpServletRequest request, Model model) throws Exception{
		// get user credentials
		List<String> userInfo = commonUtil.getUserIdAndPassword(loginCookie);
		String id = userInfo.get(0);
		String password  = userInfo.get(1);

		String url = request.getParameter("URL");
		//url = new String(url.getBytes("ISO-8859-1"),"UTF-8");
		long uid = 0;
		String folderPath = null;
		if(url != null){
			int index = url.lastIndexOf("/");
			if(index != -1){
				folderPath = url.substring(0, index);
				uid = Long.parseLong(url.substring(index+1));
			}
		}
		
		String pnFlag = "N";
		if (request.getParameter("PNFlag") != null) {
			pnFlag = request.getParameter("PNFlag");
		}
		
		String contentClass = request.getParameter("CONTENTCLASS");

		IMAPAccess ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
				id+"@"+config.getProperty("config.DomainName"), password, egovMessageSource, locale);
		Folder f = ia.getFolder(folderPath);
		
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
		boolean isSentItems = false;
		String pIsCCFg = "Y";
		
		if(f != null){
			f.open(Folder.READ_WRITE);
			
			Message message = null;
			if(f.isOpen() && f instanceof IMAPFolder){
				message = ((IMAPFolder)f).getMessageByUID(uid);
			}
			if(message != null){
				// From
				arrFroms = message.getFrom();
				if(arrFroms != null){
					fromStr = ((InternetAddress)arrFroms[0]).getPersonal();
					if(fromStr == null){
						fromStr = ((InternetAddress)arrFroms[0]).getAddress();
					}
					else{
						fromStr = MimeUtility.decodeText(fromStr);
						fromStr = commonUtil.trimDoubleQuotes(fromStr);
					}
					fromEmail = ((InternetAddress)arrFroms[0]).getAddress();
				}
				else{
					String[] fromHeaders = message.getHeader("From");
					if(fromHeaders != null){
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
					String name = null;
					for(int i=0; i<arrRecipientsTo.length; i++){
						name = ((InternetAddress)arrRecipientsTo[i]).getPersonal();
						if(name == null){
							name = ((InternetAddress)arrRecipientsTo[i]).getAddress();
						}
						else{
							name = MimeUtility.decodeText(name);
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
					String name = null;
					for(int i=0; i<arrRecipientsCC.length; i++){
						name = ((InternetAddress)arrRecipientsCC[i]).getPersonal();
						if(name == null) {
							name = ((InternetAddress)arrRecipientsCC[i]).getAddress();
						} else {
							name = MimeUtility.decodeText(name);
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
			}
			f.close(true);
		}
		ia.close();
		
		model.addAttribute("fromStr", fromStr);
		model.addAttribute("fromEmail", fromEmail);
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
		model.addAttribute("isSentItems", isSentItems);
		model.addAttribute("pnFlag", pnFlag);
		model.addAttribute("pIsCCFg", pIsCCFg);
		System.out.println(pIsCCFg);
		return "ezEmail/mailRead";
	}
	
	/**
	 * 메일 본문 내용 화면 정보 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailReadContent.do")
	public String readMailContent(@CookieValue("loginCookie") String loginCookie, Locale locale, HttpServletRequest request, Model model) throws Exception{
		// get user credentials
		List<String> userInfo = commonUtil.getUserIdAndPassword(loginCookie);
		String id = userInfo.get(0);
		String password = userInfo.get(1);

		long uid = Long.parseLong(request.getParameter("iptURL"));
		String folderPath = request.getParameter("iptFolderPath");

		IMAPAccess ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
				id+"@"+config.getProperty("config.DomainName"), password, egovMessageSource, locale);
		Folder f = ia.getFolder(folderPath);

		List<String> bodyInfoList = null;
		String pAttachListHtmlSub = "";
		if(f != null){
			f.open(Folder.READ_ONLY);
			Message message = null;
			if(f.isOpen() && f instanceof IMAPFolder){
				message = ((IMAPFolder)f).getMessageByUID(uid);
			}
			if(message != null){
				bodyInfoList = getBodyInfo(message, folderPath, uid);
				double size = Double.parseDouble(bodyInfoList.get(2));
				String strSize = ezEmailUtil.getSizeWithUnit(size);
				pAttachListHtmlSub = " - <b>" + bodyInfoList.get(3) + egovMessageSource.getMessage("ezEmail.t180", locale) + "</b>(" + strSize + ")";
			}
		}
		ia.close();
		
		model.addAttribute("htmlBody", bodyInfoList.get(0));
		model.addAttribute("pAttachListHtml", bodyInfoList.get(1));
		model.addAttribute("pAttachListHtmlSub", pAttachListHtmlSub);
		model.addAttribute("isAttach", bodyInfoList.get(4));
		
		return "ezEmail/mailReadContent";
	}
	
	/**
	 * 메일 첨부파일 다운로드 실행 함수
	 */
	@RequestMapping(value="/ezEmail/downloadAttach.do")
	public void downloadAttach(@CookieValue("loginCookie") String loginCookie, Locale locale, HttpServletRequest request, HttpServletResponse response) throws Exception{
		List<String> userInfo = commonUtil.getUserIdAndPassword(loginCookie);
		String id = userInfo.get(0);
		String password  = userInfo.get(1);

		String folderPath = request.getParameter("folderPath");
		String strUid = request.getParameter("uid");
		long uid = 0;
		if(strUid != null){
			uid = Long.parseLong(strUid);
		}
		String filename = request.getParameter("filename");
		if(filename != null){
			filename = URLDecoder.decode(filename, "UTF-8");
		}
		String strIndex = request.getParameter("index");
		int index = -1;
		if(strIndex != null){
			index = Integer.parseInt(strIndex);
		}
		IMAPAccess ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
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
					part = getAttachPart(message, filename, index);
				}
				if(part != null){
					response.setContentType(part.getContentType());
					response.addHeader("content-disposition", "attachment; filename=" + URLEncoder.encode(filename,"UTF-8"));
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
						ia.close();
						return;
					}
					output.flush();
					output.close();
				}
			}
		}
		ia.close();
	}

	/**
	 * 메일 인라인 이미지 읽어오기 실행 함수
	 */
	@RequestMapping(value="/ezEmail/downloadInline.do")
	public void downloadInline(@CookieValue("loginCookie") String loginCookie, Locale locale, HttpServletRequest request, HttpServletResponse response) throws Exception{
		List<String> userInfo = commonUtil.getUserIdAndPassword(loginCookie);
		String id = userInfo.get(0);
		String password  = userInfo.get(1);

		String folderPath = request.getParameter("folderPath");
		String strUid = request.getParameter("uid");
		long uid = 0;
		if(strUid != null){
			uid = Long.parseLong(strUid);
		}
		String contentId = request.getParameter("contentId");
		if(contentId != null){
			contentId = URLDecoder.decode(contentId, "UTF-8");
			contentId = EgovStringUtil.getHtmlStrCnvr(contentId);
		}	

		IMAPAccess ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
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
						ia.close();
						return;
					}
					output.flush();
					output.close();
				}
			}
		}

	}

	/**
	 * 미리보기 메일 정보 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailPrevShow.do")
	public void mailPrevShow(@CookieValue("loginCookie") String loginCookie, Locale locale, HttpServletRequest request, HttpServletResponse response) throws Exception{
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
			int index = url.lastIndexOf("/");
			if(index != -1){
				folderPath = url.substring(0, index);
				uid = Long.parseLong(url.substring(index+1));
			}
		}
		logger.debug(folderPath);

		IMAPAccess ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
				id+"@"+config.getProperty("config.DomainName"), password, egovMessageSource, locale);
		Folder f = ia.getFolder(folderPath);
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
		if(f != null){
			f.open(Folder.READ_WRITE);
			Message message = null;
			if(f.isOpen() && f instanceof IMAPFolder){
				message = ((IMAPFolder)f).getMessageByUID(uid);
			}
			if(message != null){
				arrFroms = message.getFrom();
				if(arrFroms != null){
					fromStr = ((InternetAddress)arrFroms[0]).getPersonal();
					if(fromStr == null){
						fromStr = ((InternetAddress)arrFroms[0]).getAddress();
					} else {
						fromStr = MimeUtility.decodeText(fromStr);
					}
					fromEmail = ((InternetAddress)arrFroms[0]).getAddress();
				} else {
					String[] fromHeaders = message.getHeader("From");
					if(fromHeaders != null){
						fromStr = MimeUtility.decodeText(message.getHeader("From")[0]);
					}
				}
				arrRecipientsTo = message.getRecipients(Message.RecipientType.TO);
				if(arrRecipientsTo != null){
					InternetAddress iAddress = null;
					String name = null;
					for(int i=0; i<arrRecipientsTo.length; i++){
						iAddress = ((InternetAddress)arrRecipientsTo[i]);
						name = iAddress.getPersonal();
						if (name == null) {
							name = iAddress.getAddress();
						}
						else {
							name = MimeUtility.decodeText(name);
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
					String name = null;
					for(int i=0; i<arrRecipientsCC.length; i++){
						iAddress = ((InternetAddress)arrRecipientsCC[i]);
						name = iAddress.getPersonal();
						if (name == null) {
							name = iAddress.getAddress();
						}
						else {
							name = MimeUtility.decodeText(name);
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
		ia.close();
		
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
		sb.append("<HTMLDESCRIPTION><![CDATA["+"]]></HTMLDESCRIPTION>"); //?
		sb.append("<COMMENT><![CDATA["+"]]></COMMENT>"); //?
		sb.append("<IMPORTANCE><![CDATA["+importance+"]]></IMPORTANCE>");
		sb.append("<SENSITIVITY><![CDATA["+"Normal"+"]]></SENSITIVITY>"); //?
		sb.append("<HASEMBEDED><![CDATA["+0+"]]></HASEMBEDED>"); //?
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
		List<String> userInfo = commonUtil.getUserIdAndPassword(loginCookie);
		String id = userInfo.get(0);
		String password  = userInfo.get(1);
		String url = request.getParameter("iptURL");
		long uid = 0;
		String folderPath = null;
		if(url != null){
			int index = url.lastIndexOf("/");
			if(index != -1){
				folderPath = url.substring(0, index);
				uid = Long.parseLong(url.substring(index+1));
			}
		}

		IMAPAccess ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
				id+"@"+config.getProperty("config.DomainName"), password, egovMessageSource, locale);
		Folder f = ia.getFolder(folderPath);

		List<String> bodyInfoList = null;
		String pAttachListHtmlSub = "";
		if(f != null){
			f.open(Folder.READ_ONLY);
			Message message = null;
			if(f.isOpen() && f instanceof IMAPFolder){
				message = ((IMAPFolder)f).getMessageByUID(uid);
			}
			if(message != null){
				bodyInfoList = getBodyInfo(message, folderPath, uid);
				double size = Double.parseDouble(bodyInfoList.get(2));
				String strSize = ezEmailUtil.getSizeWithUnit(size);
				pAttachListHtmlSub = " - <b>" + bodyInfoList.get(3) + egovMessageSource.getMessage("ezEmail.t180", locale) + "</b>(" + strSize + ")";

			}
		}
		ia.close();
		model.addAttribute("htmlBody", bodyInfoList.get(0));
		model.addAttribute("pAttachListHtml", bodyInfoList.get(1));
		model.addAttribute("pAttachListHtmlSub", pAttachListHtmlSub);
		model.addAttribute("isAttach", bodyInfoList.get(4));
		return "ezEmail/mailPreviewContent";
	}
	
	/**
	 * 메일 Multipart 정보 반환 함수
	 */
	private List<String> getBodyInfo(Part part, String folderPath, long uid){
		List<String> resultList = new ArrayList<String>();
		try {
			String htmlBody = "";
			String pAttachListHtml = "";
			String filesize = "0";
			String filecnt = "0";
			String isAttach = "";
			
			logger.debug("##content type##" + part.getContentType() + ", ##disposition##" + part.getDisposition());
			
			// process for the case where the message only consists of a single attachment (not multi-part).
			if (part.getDisposition()!=null && part.getDisposition().equalsIgnoreCase(Part.ATTACHMENT)){
				logger.debug("contentType=" + part.getContentType());
				
				String filename = part.getFileName();
				double size = part.getSize();
				String[] encodingHeaders = part.getHeader("Content-Transfer-Encoding");
				if (encodingHeaders != null && encodingHeaders.length > 0) {
					String encodingName = encodingHeaders[0];
					logger.debug("Content-Transfer-Encoding=" + encodingName);
					if (encodingName.equalsIgnoreCase("base64")) {
						// decrease the size because base64 increases the size to 4/3 times.
						size = (int)(size*0.75); 
					}
				}										
				String strSize = ezEmailUtil.getSizeWithUnit(size);
				
				if (filename == null) {
					filename = "";
				} else{
					filename = MimeUtility.decodeText(filename);
				}
				String aitem = "/ezEmail/downloadAttach.do?mode=Attach&folderPath="+URLEncoder.encode(folderPath,"UTF-8")+"&uid="+uid+"&filename="+URLEncoder.encode(filename,"UTF-8");
				pAttachListHtml += " <li><span onclick=\"DownloadPC(this);\" _filehref='" + aitem + "' _filesize='" + size + "' _filename='" + filename + "' id='MailAttachDownloadItems' name='MailAttachDownloadItems' style='cursor:pointer;' ><img src='/images/icon_adddownload.gif' width='16' height='16'></span>";
				pAttachListHtml += " <span onclick=\"DownloadAttach('" + aitem + "');\"><span onmouseover=this.style.color='#164aad' onmouseout=this.style.color='#666' style='cursor:pointer' >" + filename + " (" + strSize + ")</span></span>";
				pAttachListHtml += " <span class='icon_rbtn' fileid='fileID(추후수정)' onclick=\"AttachFile_Delete(this);\"><img src='/images/icon_reddelete.gif' width='16' height='16'></span></li>";
				isAttach = "OK";
				filesize = (Double.parseDouble(filesize) + size) + "";
				filecnt = (Integer.parseInt(filecnt) + 1) + "";
			} else if(part.isMimeType("text/html")){
				String strContent = part.getContent().toString();
				
				// process in-line images
				int index1 = -1;
				int index2 = -1;
				while((index1 = strContent.indexOf("src=\"cid:")) > -1 || (index2 = strContent.indexOf("src='cid:")) > -1){
					char quoteChar;
					int index;
					if (index1 > -1) {
						quoteChar = '"';
						index = index1;
					}
					else {
						quoteChar = '\'';
						index = index2;
					}
					
					int lastindex = index+9;
					while(true){
						if(lastindex>=strContent.length()){
							lastindex = -1;
							break;
						}						
						char c = strContent.charAt(lastindex);
						if(c == quoteChar){
							break;
						}
						++lastindex;
					}
					if(lastindex == -1){
						break;
					}
					String cid = strContent.substring(index+9, lastindex);
					String contentId = "<"+cid+">";
					String orgSrc = "src=" + quoteChar + "cid:" + cid + quoteChar;
					strContent = strContent.replace(orgSrc, "src=\"/ezEmail/downloadInline.do?mode=inlineimage&folderPath="+URLEncoder.encode(folderPath,"UTF-8")+"&uid="+uid+"&contentId="+URLEncoder.encode(contentId,"UTF-8") + "\"");						
				}
				htmlBody += strContent;
				
				htmlBody = stripScriptTags(htmlBody);
				htmlBody = addTargetBlank(htmlBody);				
			} else if(part.isMimeType("text/plain")){
				String strContent = part.getContent().toString();
				htmlBody += strContent.replaceAll("\r\n", "<br />").replaceAll("\r", "<br />").replaceAll("\n", "<br />");	
				
				htmlBody = changeURLsToAnchorTags(htmlBody);	
				htmlBody = stripScriptTags(htmlBody);
				htmlBody = addTargetBlank(htmlBody);
			} else if(part.isMimeType("multipart/alternative")){
				Multipart mp = (Multipart)part.getContent();
				int count = mp.getCount();
				Part p = null;
				for (int i = 0; i < count; i++) {
					p = mp.getBodyPart(i);
					logger.debug("contentType=" + p.getContentType());
					if(!p.isMimeType("text/plain")){
						List<String> tempList = getBodyInfo(p, folderPath, uid);
						htmlBody += tempList.get(0);
						pAttachListHtml += tempList.get(1);
						filesize = (Double.parseDouble(filesize) + Double.parseDouble(tempList.get(2))) + "";
						filecnt = (Integer.parseInt(filecnt) + Integer.parseInt(tempList.get(3))) + "";
						if(tempList.get(4).equals("OK")){
							isAttach = "OK";
						}
					}
				}
				if(htmlBody.equals("")){
					for (int i = 0; i < count; i++) {
						p = mp.getBodyPart(i);
						if(p.isMimeType("text/plain")){
							htmlBody += p.getContent().toString();
						}
					}
				}
			} else if (part.isMimeType("multipart/mixed")) { //재귀
				Multipart mp = (Multipart)part.getContent();
				int count = mp.getCount();
				Part p = null;
				for (int i = 0; i < count; i++) {
					p = mp.getBodyPart(i);
					if(p.getDisposition()!=null && p.getDisposition().equalsIgnoreCase(Part.ATTACHMENT)){
						logger.debug("contentType=" + p.getContentType());

						String filename = p.getFileName();
						double size = p.getSize();
						String[] encodingHeaders = p.getHeader("Content-Transfer-Encoding");
						if (encodingHeaders != null && encodingHeaders.length > 0) {
							String encodingName = encodingHeaders[0];
							logger.debug("Content-Transfer-Encoding=" + encodingName);
							if (encodingName.equalsIgnoreCase("base64")) {
								// decrease the size because base64 increases the size to 4/3 times.
								size = (int)(size*0.75); 
							}
						}						
						String strSize = ezEmailUtil.getSizeWithUnit(size);
						
						if (filename == null){
							filename = "";
						} else {
							filename = MimeUtility.decodeText(filename);
						}
						String aitem = "/ezEmail/downloadAttach.do?mode=Attach&folderPath="+URLEncoder.encode(folderPath,"UTF-8")+"&uid="+uid+"&filename="+URLEncoder.encode(filename,"UTF-8")+"&index="+i;
						pAttachListHtml += " <li><span onclick=\"DownloadPC(this);\" _filehref='" + aitem + "' _filesize='" + size + "' _filename='" + filename + "' id='MailAttachDownloadItems' name='MailAttachDownloadItems' style='cursor:pointer;' ><img src='/images/icon_adddownload.gif' width='16' height='16'></span>";
						pAttachListHtml += " <span onclick=\"DownloadAttach('" + aitem + "');\"><span onmouseover=this.style.color='#164aad' onmouseout=this.style.color='#666' style='cursor:pointer' >" + filename + " (" + strSize + ")</span></span>";
						pAttachListHtml += " <span class='icon_rbtn' fileid='fileID(추후수정)' onclick=\"AttachFile_Delete(this);\"><img src='/images/icon_reddelete.gif' width='16' height='16'></span></li>";
						isAttach = "OK";
						filesize = (Double.parseDouble(filesize) + size) + "";
						filecnt = (Integer.parseInt(filecnt) + 1) + "";
					} else {
						List<String> tempList = getBodyInfo(p, folderPath, uid);
						htmlBody += tempList.get(0);
						pAttachListHtml += tempList.get(1);
						filesize = (Double.parseDouble(filesize) + Double.parseDouble(tempList.get(2))) + "";
						filecnt = (Integer.parseInt(filecnt) + Integer.parseInt(tempList.get(3))) + "";
						if(tempList.get(4).equals("OK")){
							isAttach = "OK";
						}
					}
				}
			} else if(part.isMimeType("multipart/related")){
				Multipart mp = (Multipart)part.getContent();
				int count = mp.getCount();
				for(int i = 0; i < count; i++) {
					Part p = mp.getBodyPart(i);
					if(!p.isMimeType("text/plain") && !(p.getDisposition()!=null && p.getDisposition().equalsIgnoreCase(Part.INLINE))){
						List<String> tempList = getBodyInfo(p, folderPath, uid);
						htmlBody += tempList.get(0);
						pAttachListHtml += tempList.get(1);
						filesize = (Double.parseDouble(filesize) + Double.parseDouble(tempList.get(2))) + "";
						filecnt = (Integer.parseInt(filecnt) + Integer.parseInt(tempList.get(3))) + "";
						if(tempList.get(4).equals("OK")){
							isAttach = "OK";
						}
					}
				}
			} else if(part.isMimeType("multipart/*")){
				Multipart mp = (Multipart)part.getContent();
				int count = mp.getCount();
				for(int i = 0; i < count; i++) {
					Part p = mp.getBodyPart(i);
					List<String> tempList = getBodyInfo(p, folderPath, uid);
					htmlBody += tempList.get(0);
					pAttachListHtml += tempList.get(1);
					filesize = (Double.parseDouble(filesize) + Double.parseDouble(tempList.get(2))) + "";
					filecnt = (Integer.parseInt(filecnt) + Integer.parseInt(tempList.get(3))) + "";
					if(tempList.get(4).equals("OK")){
						isAttach = "OK";
					}
				}
			} else if(part.isMimeType("message/rfc822")){
				
			}
			
			resultList.add(htmlBody);
			resultList.add(pAttachListHtml);
			resultList.add(filesize);
			resultList.add(filecnt);
			resultList.add(isAttach);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return resultList;
	}
	
	/**
	 * 메일 첨부파일 Part 반환 함수
	 */
	private Part getAttachPart(Part part, String filename, int index) throws MessagingException, IOException{
		if(part.isMimeType("multipart/mixed")){
			Part p = ((Multipart)part.getContent()).getBodyPart(index);
			if(p.getDisposition()!=null && p.getDisposition().equalsIgnoreCase(Part.ATTACHMENT)){
				if(p.getFileName()!=null && MimeUtility.decodeText(p.getFileName()).equals(filename)){
					return p;
				}
			}
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

	/**
	 * change an http or https URL to an anchor tag in a text/plain message 
	 * so that the user can click on it
	 */	
	private String changeURLsToAnchorTags(String src) {
		Pattern p = Pattern.compile("(https?://[^ <$]+)");
		Matcher m = p.matcher(src);
		
		StringBuffer result = new StringBuffer();
		while (m.find()) {
			m.appendReplacement(result, String.format("<a href=\"%s\">%s</a>", m.group(1), m.group(1)));
		}
		m.appendTail(result);
		
		return result.toString();		
	}

	/** 
	 * strip <object>,<applet>,<script> tags
	 */	
	private String stripScriptTags(String src) {
		Pattern p = Pattern.compile("<(object|applet|script).*?>|</(object|applet|script).*?>", Pattern.CASE_INSENSITIVE | Pattern.DOTALL);
		Matcher m = p.matcher(src);
		src = m.replaceAll("");
				
		return src;		
	}
	
	/** 
	 * add target="_blank" to an anchor tag
	 */	
	private String addTargetBlank(String src) {
		Pattern p = Pattern.compile("<a (.*?)>", Pattern.CASE_INSENSITIVE | Pattern.DOTALL);
		Matcher m = p.matcher(src);
				
		StringBuffer result = new StringBuffer();
		while (m.find()) {
			String att = m.group(1);
			if (att.toLowerCase().indexOf("target=") < 0) {
				m.appendReplacement(result, "<a " + att + " target=\"_blank\">");
			}
		}
		m.appendTail(result);
		
		return result.toString();		
	}	
	
}
