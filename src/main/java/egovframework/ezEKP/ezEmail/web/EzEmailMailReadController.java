package egovframework.ezEKP.ezEmail.web;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Properties;

import javax.annotation.Resource;
import javax.mail.Address;
import javax.mail.Flags.Flag;
import javax.mail.Folder;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Multipart;
import javax.mail.Part;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
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

import com.sun.mail.imap.IMAPFolder;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezEmail.logic.IMAPAccess;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovStringUtil;

@Controller
public class EzEmailMailReadController {

	private static final Logger logger = LoggerFactory.getLogger(EzEmailMailReadController.class);

	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;

	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource; 

	@RequestMapping(value="/ezEmail/mailRead.do")
	public String readMail(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception{
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
		logger.debug(folderPath);
		String pnFlag = request.getParameter("PNFlag");
		String contentClass = request.getParameter("CONTENTCLASS");

		IMAPAccess ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
				id+"@"+config.getProperty("config.DomainName"), password, egovMessageSource);
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
		String bccStr = null;
		String subject = null;
		String dateStr = null;
		String title = null;
		if(f != null){
			f.open(Folder.READ_ONLY);
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
					}
					else{
						fromStr = MimeUtility.decodeText(fromStr);
					}
					fromEmail = ((InternetAddress)arrFroms[0]).getAddress();
				}
				else{
					String[] fromHeaders = message.getHeader("From");
					if(fromHeaders != null){
						fromStr = MimeUtility.decodeText(message.getHeader("From")[0]);
					}
				}
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
						}
						if(toListme){
							if(((InternetAddress)arrRecipientsTo[i]).getAddress().equals(id+"@"+config.getProperty("config.DomainName"))){
								if(arrRecipientsTo.length > 1){
									toStr = getReceiverHTML(name, ((InternetAddress)arrRecipientsTo[i]).getAddress()) + "<span>&nbsp;(" + egovMessageSource.getMessage("ezEmail.t10000") + arrRecipientsTo.length + egovMessageSource.getMessage("ezEmail.t10001") + ")&nbsp;<img src='/images/expnd.gif'  style='cursor:hand;' onclick='ShowHiddenTo(this);' align='absmiddle'></span>";
								}
								else{
									toStr = getReceiverHTML(name, ((InternetAddress)arrRecipientsTo[i]).getAddress());
								}
							}
							if(toHiddenStr == null){
								toHiddenStr = getReceiverHTML(name, ((InternetAddress)arrRecipientsTo[i]).getAddress());
							}
							else{
								toHiddenStr += " , " + getReceiverHTML(name, ((InternetAddress)arrRecipientsTo[i]).getAddress());
							}
						}
						else{
							if(i == 0){
								if(arrRecipientsTo.length > 1){
									toStr = getReceiverHTML(name, ((InternetAddress)arrRecipientsTo[i]).getAddress()) + "<span>&nbsp;(" + egovMessageSource.getMessage("ezEmail.t10000") + arrRecipientsTo.length + egovMessageSource.getMessage("ezEmail.t10001") + ")&nbsp;<img src='/images/expnd.gif'  style='cursor:hand;' onclick='ShowHiddenTo(this);' align='absmiddle'></span>";
								}
								else{
									toStr = getReceiverHTML(name, ((InternetAddress)arrRecipientsTo[i]).getAddress());
								}
							}
							if(toHiddenStr == null){
								toHiddenStr = getReceiverHTML(name, ((InternetAddress)arrRecipientsTo[i]).getAddress());
							}
							else{
								toHiddenStr += " , " + getReceiverHTML(name, ((InternetAddress)arrRecipientsTo[i]).getAddress());
							}
						}
					}
				}

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
						if(name == null){
							name = ((InternetAddress)arrRecipientsCC[i]).getAddress();
						}
						else{
							name = MimeUtility.decodeText(name);
						}
						if(ccListme){
							if(((InternetAddress)arrRecipientsCC[i]).getAddress().equals(id+"@"+config.getProperty("config.DomainName"))){
								if(arrRecipientsCC.length > 1){
									ccStr = getReceiverHTML(name, ((InternetAddress)arrRecipientsCC[i]).getAddress()) + "<span>&nbsp;(" + egovMessageSource.getMessage("ezEmail.t10000") + arrRecipientsCC.length + egovMessageSource.getMessage("ezEmail.t10001") + ")&nbsp;<img src='/images/expnd.gif'  style='cursor:hand;' onclick='ShowHiddenCc(this);' align='absmiddle'></span>";
								}
								else{
									ccStr = getReceiverHTML(name, ((InternetAddress)arrRecipientsCC[i]).getAddress());
								}
							}
							if(ccHiddenStr == null){
								ccHiddenStr = getReceiverHTML(name, ((InternetAddress)arrRecipientsCC[i]).getAddress());
							}
							else{
								ccHiddenStr += " , " + getReceiverHTML(name, ((InternetAddress)arrRecipientsCC[i]).getAddress());
							}
						}
						else{
							if(i == 0){
								if(arrRecipientsCC.length > 1){
									ccStr = getReceiverHTML(name, ((InternetAddress)arrRecipientsCC[i]).getAddress()) + "<span>&nbsp;(" + egovMessageSource.getMessage("ezEmail.t10000") + arrRecipientsCC.length + egovMessageSource.getMessage("ezEmail.t10001") + ")&nbsp;<img src='/images/expnd.gif'  style='cursor:hand;' onclick='ShowHiddenCc(this);' align='absmiddle'></span>";
								}
								else{
									ccStr = getReceiverHTML(name, ((InternetAddress)arrRecipientsCC[i]).getAddress());
								}
							}
							if(ccHiddenStr == null){
								ccHiddenStr = getReceiverHTML(name, ((InternetAddress)arrRecipientsCC[i]).getAddress());
							}
							else{
								ccHiddenStr += " , " + getReceiverHTML(name, ((InternetAddress)arrRecipientsCC[i]).getAddress());
							}
						}
					}
				}

				arrRecipientsBCC = message.getRecipients(Message.RecipientType.BCC);
				if(arrRecipientsBCC != null){
					String name = null;
					for(int i=0; i<arrRecipientsBCC.length; i++){
						name = ((InternetAddress)arrRecipientsBCC[i]).getPersonal();
						if(name != null){
							name = MimeUtility.decodeText(name);
						}
						if(i != 0){
							bccStr += ", ";
						}
						bccStr += "<span style='cursor:pointer' title='" + name + "' onclick='show_personinfo(\"" +
								((InternetAddress)arrRecipientsBCC[i]).getAddress() + "\")'>" + (name==null?"":EgovStringUtil.getSpclStrCnvr(name)) + "</span>";
					}
				}

				date = message.getReceivedDate();
				if(date != null){
					dateStr = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault()).format(date);
				}

				subject = message.getSubject();
				if(subject != null){
					title = egovMessageSource.getMessage("ezEmail.t565") + subject;
				}

				message.setFlag(Flag.SEEN, true);
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
		return "ezEmail/mailRead";
	}

	@RequestMapping(value="/ezEmail/mailReadContent.do")
	public String readMailContent(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception{
		List<String> userInfo = commonUtil.getUserIdAndPassword(loginCookie);
		String id = userInfo.get(0);
		String password  = userInfo.get(1);

		long uid = Long.parseLong(request.getParameter("iptURL"));
		String folderPath = request.getParameter("iptFolderPath");


		IMAPAccess ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
				id+"@"+config.getProperty("config.DomainName"), password, egovMessageSource);
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
				int size = Integer.parseInt(bodyInfoList.get(2));
				String strSize = "";
				if (size > 1024 * 1024)
				{
					size = size / 1024 / 1024;
					strSize = size + "MB";
				}
				else if (size > 1024)
				{
					size = size / 1024;
					strSize = size + "KB";
				}
				else
					strSize = size + "B";
				pAttachListHtmlSub = " - <b>" + bodyInfoList.get(3) + egovMessageSource.getMessage("ezEmail.t180") + "</b>(" + strSize + ")";

			}
		}
		ia.close();
		model.addAttribute("htmlBody", bodyInfoList.get(0));
		model.addAttribute("pAttachListHtml", bodyInfoList.get(1));
		model.addAttribute("pAttachListHtmlSub", pAttachListHtmlSub);
		model.addAttribute("isAttach", bodyInfoList.get(4));
		return "ezEmail/mailReadContent";
	}

	public List<String> getBodyInfo(Part part, String folderPath, long uid){
		List<String> resultList = new ArrayList<String>();
		try {
			String htmlBody = "";
			String pAttachListHtml = "";
			String filesize = "0";
			String filecnt = "0";
			String isAttach = "";
			System.out.println("##content type##" + part.getContentType() + ", ##disposition##" + part.getDisposition());
			if(part.getDisposition()!=null && part.getDisposition().equalsIgnoreCase(Part.ATTACHMENT)){
				System.out.println(part.getContentType());
				String strSize = "";
				String filename = part.getFileName();
				int size = part.getSize();
				if (size > 1024 * 1024)
				{
					size = size / 1024 / 1024;
					strSize = size + "MB";
				}
				else if (size > 1024)
				{
					size = size / 1024;
					strSize = size + "KB";
				}
				else
					strSize = size + "B";

				if (filename == null){
					filename = "";
				}
				else{
					filename = MimeUtility.decodeText(filename);
				}
				String aitem = "/ezEmail/downloadAttach.do?mode=Attach&folderPath="+URLEncoder.encode(folderPath,"UTF-8")+"&uid="+uid+"&filename="+URLEncoder.encode(filename,"UTF-8");
				pAttachListHtml += " <li><span onclick=\"DownloadPC(this);\" _filehref='" + aitem + "' _filesize='" + part.getSize() + "' _filename='" + filename + "' id='MailAttachDownloadItems' name='MailAttachDownloadItems' style='cursor:pointer;' ><img src='/images/icon_adddownload.gif' width='16' height='16'></span>";
				pAttachListHtml += " <span onclick=\"DownloadAttach('" + aitem + "');\"><span onmouseover=this.style.color='#164aad' onmouseout=this.style.color='#666' style='cursor:pointer' >" + filename + " (" + strSize + ")</span></span>";
				pAttachListHtml += " <span class='icon_rbtn' fileid='fileID(추후수정)' onclick=\"AttachFile_Delete(this);\"><img src='/images/icon_reddelete.gif' width='16' height='16'></span></li>";
				isAttach = "OK";
				filesize = (Integer.parseInt(filesize) + part.getSize()) + "";
				filecnt = (Integer.parseInt(filecnt) + 1) + "";
			}
			else if(part.isMimeType("text/html")){
				String strContent = part.getContent().toString();
				while(strContent.contains("src=\"cid:") || strContent.contains("src='cid:")){
					if(strContent.contains("src=\"cid:")){
						int index = strContent.indexOf("src=\"cid:");
						if(index == -1){
							break;
						}
						int lastindex = index+9;
						while(true){
							char c = strContent.charAt(lastindex);
							if(c == '"'){
								break;
							}
							if(lastindex>=strContent.length()){
								lastindex = -1;
								break;
							}
							++lastindex;
						}
						if(lastindex == -1){
							break;
						}
						String cid = strContent.substring(index+9, lastindex);
						String contentId = "<"+cid+">";
						strContent = strContent.replace("src=\"cid:" + cid + "\"", "src=/ezEmail/downloadInline.do?mode=inlineimage&folderPath="+URLEncoder.encode(folderPath,"UTF-8")+"&uid="+uid+"&contentId="+URLEncoder.encode(contentId,"UTF-8"));
					}
					else if(strContent.contains("src='cid:")){
						int index = strContent.indexOf("src='cid:");
						if(index == -1){
							break;
						}
						int lastindex = index+9;
						while(true){
							char c = strContent.charAt(lastindex);
							if(c == '\''){
								break;
							}
							if(lastindex>=strContent.length()){
								lastindex = -1;
								break;
							}
							++lastindex;
						}
						if(lastindex == -1){
							break;
						}
						String cid = strContent.substring(index+9, lastindex);
						String contentId = "<"+cid+">";
						strContent = strContent.replace("src='cid:" + cid + "'", "src=/ezEmail/downloadInline.do?mode=inlineimage&folderPath="+URLEncoder.encode(folderPath,"UTF-8")+"&uid="+uid+"&contentId="+URLEncoder.encode(contentId,"UTF-8"));
					}
				}
				htmlBody += strContent;
			}
			else if(part.isMimeType("text/plain")){
				String strContent = part.getContent().toString();
				htmlBody += strContent.replaceAll("\r\n", "<br />").replaceAll("\r", "<br />").replaceAll("\n", "<br />");
			}
			else if(part.isMimeType("multipart/alternative")){
				Multipart mp = (Multipart)part.getContent();
				int count = mp.getCount();
				Part p = null;
				for (int i = 0; i < count; i++) {
					p = mp.getBodyPart(i);
					System.out.println(p.getContentType());
					if(!mp.getBodyPart(i).isMimeType("text/plain")){
						List<String> tempList = getBodyInfo(mp.getBodyPart(i), folderPath, uid);
						htmlBody += tempList.get(0);
						pAttachListHtml += tempList.get(1);
						filesize = (Integer.parseInt(filesize) + Integer.parseInt(tempList.get(2))) + "";
						filecnt = (Integer.parseInt(filecnt) + Integer.parseInt(tempList.get(3))) + "";
						if(tempList.get(4).equals("OK")){
							isAttach = "OK";
						}
					}
				}
				if(htmlBody.equals("")){
					for (int i = 0; i < count; i++) {
						p = mp.getBodyPart(i);
						if(mp.getBodyPart(i).isMimeType("text/plain")){
							htmlBody += p.getContent().toString();
						}
					}
				}
			}
			else if (part.isMimeType("multipart/mixed")) { //재귀
				Multipart mp = (Multipart)part.getContent();
				int count = mp.getCount();
				for (int i = 0; i < count; i++) {
					if(mp.getBodyPart(i).getDisposition()!=null && mp.getBodyPart(i).getDisposition().equalsIgnoreCase(Part.ATTACHMENT)){
						System.out.println(mp.getBodyPart(i).getContentType());
						String strSize = "";
						String filename = mp.getBodyPart(i).getFileName();
						int size = mp.getBodyPart(i).getSize();
						if (size > 1024 * 1024)
						{
							size = size / 1024 / 1024;
							strSize = size + "MB";
						}
						else if (size > 1024)
						{
							size = size / 1024;
							strSize = size + "KB";
						}
						else
							strSize = size + "B";

						if (filename == null){
							filename = "";
						}
						else{
							filename = MimeUtility.decodeText(filename);
						}
						String aitem = "/ezEmail/downloadAttach.do?mode=Attach&folderPath="+URLEncoder.encode(folderPath,"UTF-8")+"&uid="+uid+"&filename="+URLEncoder.encode(filename,"UTF-8")+"&index="+i;
						pAttachListHtml += " <li><span onclick=\"DownloadPC(this);\" _filehref='" + aitem + "' _filesize='" + mp.getBodyPart(i).getSize() + "' _filename='" + filename + "' id='MailAttachDownloadItems' name='MailAttachDownloadItems' style='cursor:pointer;' ><img src='/images/icon_adddownload.gif' width='16' height='16'></span>";
						pAttachListHtml += " <span onclick=\"DownloadAttach('" + aitem + "');\"><span onmouseover=this.style.color='#164aad' onmouseout=this.style.color='#666' style='cursor:pointer' >" + filename + " (" + strSize + ")</span></span>";
						pAttachListHtml += " <span class='icon_rbtn' fileid='fileID(추후수정)' onclick=\"AttachFile_Delete(this);\"><img src='/images/icon_reddelete.gif' width='16' height='16'></span></li>";
						isAttach = "OK";
						filesize = (Integer.parseInt(filesize) + mp.getBodyPart(i).getSize()) + "";
						filecnt = (Integer.parseInt(filecnt) + 1) + "";
					}
					else{
						List<String> tempList = getBodyInfo(mp.getBodyPart(i), folderPath, uid);
						htmlBody += tempList.get(0);
						pAttachListHtml += tempList.get(1);
						filesize = (Integer.parseInt(filesize) + Integer.parseInt(tempList.get(2))) + "";
						filecnt = (Integer.parseInt(filecnt) + Integer.parseInt(tempList.get(3))) + "";
						if(tempList.get(4).equals("OK")){
							isAttach = "OK";
						}
					}
				}
			}
			else if(part.isMimeType("multipart/related")){
				Multipart mp = (Multipart)part.getContent();
				int count = mp.getCount();
				for(int i = 0; i < count; i++) {
					Part p = mp.getBodyPart(i);
					if(!p.isMimeType("text/plain") && !(p.getDisposition()!=null && p.getDisposition().equalsIgnoreCase(Part.INLINE))){
						List<String> tempList = getBodyInfo(p, folderPath, uid);
						htmlBody += tempList.get(0);
						pAttachListHtml += tempList.get(1);
						filesize = (Integer.parseInt(filesize) + Integer.parseInt(tempList.get(2))) + "";
						filecnt = (Integer.parseInt(filecnt) + Integer.parseInt(tempList.get(3))) + "";
						if(tempList.get(4).equals("OK")){
							isAttach = "OK";
						}
					}
				}
			}
			else if(part.isMimeType("multipart/*")){
				Multipart mp = (Multipart)part.getContent();
				int count = mp.getCount();
				for(int i = 0; i < count; i++) {
					List<String> tempList = getBodyInfo(mp.getBodyPart(i), folderPath, uid);
					htmlBody += tempList.get(0);
					pAttachListHtml += tempList.get(1);
					filesize = (Integer.parseInt(filesize) + Integer.parseInt(tempList.get(2))) + "";
					filecnt = (Integer.parseInt(filecnt) + Integer.parseInt(tempList.get(3))) + "";
					if(tempList.get(4).equals("OK")){
						isAttach = "OK";
					}
				}
			}
			else{
				htmlBody += part.getContent().toString();
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

	@RequestMapping(value="/ezEmail/downloadAttach.do")
	public void downloadAttach(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception{
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
				id+"@"+config.getProperty("config.DomainName"), password, egovMessageSource);

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

	@RequestMapping(value="/ezEmail/downloadInline.do")
	public void downloadInline(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception{
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
				id+"@"+config.getProperty("config.DomainName"), password, egovMessageSource);

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
		}
		else if(part.isMimeType("multipart/*")){
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

	private String getReceiverHTML(String name, String address){
		return "<span style='cursor:pointer' title='" + (name==null?"":EgovStringUtil.getSpclStrCnvr(name)) + "' onclick='show_personinfo(\"" + address + "\")'>" + (name==null?"":EgovStringUtil.getSpclStrCnvr(name)) + "</span>";
	}

}
