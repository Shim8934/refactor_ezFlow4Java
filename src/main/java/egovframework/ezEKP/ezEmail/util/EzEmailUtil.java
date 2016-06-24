package egovframework.ezEKP.ezEmail.util;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.TimeZone;
import java.util.concurrent.TimeUnit;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.mail.Address;
import javax.mail.BodyPart;
import javax.mail.FetchProfile;
import javax.mail.Flags;
import javax.mail.Folder;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Multipart;
import javax.mail.Part;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimePart;
import javax.mail.internet.MimeUtility;
import javax.mail.search.AndTerm;
import javax.mail.search.BodyTerm;
import javax.mail.search.DateTerm;
import javax.mail.search.ReceivedDateTerm;
import javax.mail.search.SearchTerm;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

import com.sun.mail.imap.IMAPFolder;

import egovframework.ezEKP.ezEmail.logic.IMAPAccess;

/** 
 * @Description [Utility] 메일 관련 유틸리티
 * @author 오픈솔루션팀 이동호
 * @Modification Information
 *
 *    수정일        수정자         수정내용
 *    ----------    ------    -------------------
 *    2016.04.22    이동호    신규작성
 *
 * @see
 */

@Component
public class EzEmailUtil {

	private static final Logger logger = LoggerFactory.getLogger(EzEmailUtil.class);
	
	/**
	 * returns a string containing size with a size unit(MB or KB or B) 
	 */
	public String getSizeWithUnit(double size) {
		String strSize;
		
		if (size > 1024 * 1024) {
			size = size / 1024.0 / 1024.0;
			strSize = String.format("%.1fMB", size);
		} else if (size > 1024) {
			size = size / 1024.0;
			strSize = String.format("%dKB", (int)size);
		} else {
			strSize = size + "B";
		}

		return strSize;
	}
	
	public String getFromNameOrAddressOfMessage(Message message) {
		String addressStr = "";
		
		try {
			Address[] addresses = message.getFrom();
			
			if (addresses != null && addresses.length > 0) {
				addressStr = ((InternetAddress)addresses[0]).getPersonal(); // name part
				if (addressStr == null) {
					addressStr = ((InternetAddress)addresses[0]).getAddress(); // email address part
				}
				else {
					// decoding is needed for the name part
					// ex) =?UTF-8?B?44WC44WC?=
					//     =?utf-8?B?Z2lzYTE=?=
					//     =?ks_c_5601-1987?B?uei03iC1x8H2IL7KwL06IHRlc3Q=?=
					addressStr = MimeUtility.decodeText(addressStr);
				}
			}			
			// in case there is only a name with no email address
			else {
				String[] fromHeaders = message.getHeader("From");
				if (fromHeaders != null) {
					addressStr = MimeUtility.decodeText(fromHeaders[0]);
				}
			}			
		} catch (MessagingException e) {
		} catch (UnsupportedEncodingException e) {			
		}		
		
		return addressStr;
	}
	
	public String getFromEmailAddressOfMessage(Message message) {
		String addressStr = "";
		
		try {
			Address[] addresses = message.getFrom();
			
			if (addresses != null && addresses.length > 0) {
				addressStr = ((InternetAddress)addresses[0]).getAddress(); // email address part
			}			
		} 
		catch (MessagingException e) {			
		}
		
		return addressStr;
	}
	
	public String getFullFromAddressOfMessage(Message message) {
		String fullFromAddressStr = "";
		
		try {
			Address[] addresses = message.getFrom();			
			StringBuilder addressBuilder = new StringBuilder();
			
			if (addresses != null && addresses.length > 0) {
				Address address = addresses[0];
				String addressStr = ((InternetAddress)address).getAddress(); // email address part				
				String name = ((InternetAddress)address).getPersonal(); // name part
				if (name != null) {
					name = MimeUtility.decodeText(name);
					
					addressBuilder.append(name + " <" + addressStr + ">");					
				}
				else {
					addressBuilder.append(addressStr + " <" + addressStr + ">");
				}				
				
				fullFromAddressStr = addressBuilder.toString();
			}			
			// in case there is only a name with no email address
			else {
				String[] fromHeaders = message.getHeader("From");
				if (fromHeaders != null) {
					fullFromAddressStr = MimeUtility.decodeText(fromHeaders[0]);
				}
			}			
		} catch (MessagingException e) {
		} 
		catch (UnsupportedEncodingException e) {			
		}		
		
		return fullFromAddressStr;
	}
	
	public String getStringListOfNameOrAddressOfAddresses(Address[] addresses) {
		String stringList = "";
		
		if (addresses != null) {
			StringBuilder addressBuilder = new StringBuilder();
			
			for (Address address : addresses) {
				String addressStr = ((InternetAddress)address).getPersonal(); // name part
				if (addressStr == null) {
					addressStr = ((InternetAddress)address).getAddress(); // email address part
				}
				else {
					// decoding is needed for the name part
					try {
						addressStr = MimeUtility.decodeText(addressStr);
					} catch (UnsupportedEncodingException e) {
					}
				}						
				addressBuilder.append(addressStr);
				addressBuilder.append("; ");
			}
			
			stringList = addressBuilder.toString();
			stringList = stringList.substring(0, stringList.length() - 2);	
		}
		
		return stringList;
	}
	
	/**
	 * returns a comma separated string list containing the passed-in addresses. 
	 */
	public String getStringListOfAddresses(Address[] addresses) {
		String stringList = "";
		
		if (addresses != null) {
			StringBuilder addressBuilder = new StringBuilder();
			for (Address address : addresses) {
				String addressStr = ((InternetAddress)address).getAddress(); // email address part				
				String name = ((InternetAddress)address).getPersonal(); // name part
				if (name != null) {
					try {
						name = MimeUtility.decodeText(name);
					} catch (UnsupportedEncodingException e) {
					}
					
					addressBuilder.append(name + " <" + addressStr + ">");					
				}
				else {
					addressBuilder.append(addressStr + " <" + addressStr + ">");
				}
				
				addressBuilder.append(",");
			}
			stringList = addressBuilder.toString();
			stringList = stringList.substring(0, stringList.length() - 1);
		}
		
		return stringList;
	}
	
	/**
	 * 메일 Multipart 정보 반환 함수
	 */
	public List<String> getBodyInfo(Part part, String folderPath, long uid, 
			int bodyPartIndex, List<Map<String, String>> attachedFileList, boolean forPrint){
		List<String> resultList = new ArrayList<String>();
		
		try {
			String htmlBody = "";
			String pAttachListHtml = "";
			String filesize = "0";
			String filecnt = "0";
			String isAttach = "";
			
			logger.debug("##content type##" + part.getContentType() + ", ##disposition##" + part.getDisposition());
			
			if (part.getDisposition()!=null && part.getDisposition().equalsIgnoreCase(Part.ATTACHMENT)){
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
				String strSize = getSizeWithUnit(size);
				
				filename = (filename != null) ? MimeUtility.decodeText(filename) : "";
				
				if (attachedFileList != null) {
					Map<String, String> attachedFileInfo = new HashMap<String, String>();
					attachedFileInfo.put("filename", filename);
					attachedFileInfo.put("size", String.valueOf(size));
					attachedFileList.add(attachedFileInfo);
				}
				
				if (forPrint) {
					pAttachListHtml += "<span style='cursor:pointer;'><img src='/images/icon_adddownload.gif' width='16' height='16'></span>";
					pAttachListHtml += "<span><span onmouseover=this.style.color='#164aad' onmouseout=this.style.color='#666' style='cursor:pointer' >";
					pAttachListHtml += filename + " (" + strSize + ")</span></span></br>";
				} else {
					String aitem = "/ezEmail/downloadAttach.do?mode=Attach&folderPath="+URLEncoder.encode(folderPath,"UTF-8")+"&uid="+uid+"&filename="+URLEncoder.encode(filename,"UTF-8")+"&index="+bodyPartIndex;
					pAttachListHtml += " <li><span onclick=\"DownloadAttach('" + aitem + "');\" _filehref='" + aitem + "' _filesize='" + size + "' _filename='" + filename + "' id='MailAttachDownloadItems' name='MailAttachDownloadItems' style='cursor:pointer;' ><img src='/images/icon_adddownload.gif' width='16' height='16'></span>";
					pAttachListHtml += " <span onclick=\"DownloadAttach('" + aitem + "');\"><span onmouseover=this.style.color='#164aad' onmouseout=this.style.color='#666' style='cursor:pointer' >" + filename + " (" + strSize + ")</span></span>";
					pAttachListHtml += " <span class='icon_rbtn' fileid='fileID(추후수정)' onclick=\"AttachFile_Delete(this);\"><img src='/images/icon_reddelete.gif' width='16' height='16'></span></li>";
				}
				
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
						List<String> tempList = getBodyInfo(p, folderPath, uid, -1, attachedFileList, forPrint);
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
					List<String> tempList = getBodyInfo(p, folderPath, uid, i, attachedFileList, forPrint);
					htmlBody += tempList.get(0);
					pAttachListHtml += tempList.get(1);
					filesize = (Double.parseDouble(filesize) + Double.parseDouble(tempList.get(2))) + "";
					filecnt = (Integer.parseInt(filecnt) + Integer.parseInt(tempList.get(3))) + "";
					if(tempList.get(4).equals("OK")){
						isAttach = "OK";
					}
				}
			} else if(part.isMimeType("multipart/related")){
				Multipart mp = (Multipart)part.getContent();
				int count = mp.getCount();
				for(int i = 0; i < count; i++) {
					Part p = mp.getBodyPart(i);
					if(!p.isMimeType("text/plain") && !(p.getDisposition()!=null && p.getDisposition().equalsIgnoreCase(Part.INLINE))){
						List<String> tempList = getBodyInfo(p, folderPath, uid, -1, attachedFileList, forPrint);
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
					List<String> tempList = getBodyInfo(p, folderPath, uid, i, attachedFileList, forPrint);
					htmlBody += tempList.get(0);
					pAttachListHtml += tempList.get(1);
					filesize = (Double.parseDouble(filesize) + Double.parseDouble(tempList.get(2))) + "";
					filecnt = (Integer.parseInt(filecnt) + Integer.parseInt(tempList.get(3))) + "";
					if(tempList.get(4).equals("OK")){
						isAttach = "OK";
					}
				}
			} else if(part.isMimeType("message/rfc822")){
				Message nestedMessage = (Message)part.getContent();
				
				double size = part.getSize();
				String strSize = getSizeWithUnit(size);
				
				String filename = nestedMessage.getSubject();
				filename = (filename != null) ? filename + ".eml" : "ForwardedMessage.eml";
				String aitem = "/ezEmail/downloadAttach.do?mode=Attach&folderPath="+URLEncoder.encode(folderPath,"UTF-8")+"&uid="+uid+"&filename="+URLEncoder.encode(filename,"UTF-8")+"&index="+bodyPartIndex;
				
				if (forPrint) {
					pAttachListHtml += "<span style='cursor:pointer;'><img src='/images/icon_adddownload.gif' width='16' height='16'></span>";
					pAttachListHtml += "<span><span onmouseover=this.style.color='#164aad' onmouseout=this.style.color='#666' style='cursor:pointer' >";
					pAttachListHtml += filename + " (" + strSize + ")</span></span></br>";
				} else {
					pAttachListHtml += " <li><span onclick=\"DownloadAttach('" + aitem + "');\" _filehref='" + aitem + "' _filesize='" + size + "' _filename='" + filename + "' id='MailAttachDownloadItems' name='MailAttachDownloadItems' style='cursor:pointer;' ><img src='/images/icon_adddownload.gif' width='16' height='16'></span>";
					pAttachListHtml += " <span onclick=\"DownloadAttach('" + aitem + "');\"><span onmouseover=this.style.color='#164aad' onmouseout=this.style.color='#666' style='cursor:pointer' >" + filename + " (" + strSize + ")</span></span>";
					pAttachListHtml += " <span class='icon_rbtn' fileid='fileID(추후수정)' onclick=\"AttachFile_Delete(this);\"><img src='/images/icon_reddelete.gif' width='16' height='16'></span></li>";
				}
				
				isAttach = "OK";
				filesize = (Double.parseDouble(filesize) + size) + "";
				filecnt = (Integer.parseInt(filecnt) + 1) + "";				
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
	 * searches an open folder for messages matching the specified criterion. 
	 */
	public Message[] searchFolder(
			Folder folder, 
			String searchField, 
			final String searchValue,
			Date startDate,
			Date endDate,
			boolean searchSubFolder,
			SearchTerm existingSearchTerm
			) throws Exception {
		Message[] messages = folder.getMessages();
		
		SearchTerm sTerm = existingSearchTerm; 
		
		if (sTerm == null) {
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
			        	String from = getFullFromAddressOfMessage(message);
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
							String to = getStringListOfAddresses(addresses);
							
							if (!to.equals("")) {
								sb.append(to);
							}
							
							// retrieve the CC addresses from the message.
							addresses = message.getRecipients(Message.RecipientType.CC);
							String cc = getStringListOfAddresses(addresses);
							
							if (!cc.equals("")) {
								if (!to.equals("")) {
									sb.append(",");
								}
								
								sb.append(cc);
							}
							
							// retrieve the BCC addresses from the message.
							addresses = message.getRecipients(Message.RecipientType.BCC);
							String bcc = getStringListOfAddresses(addresses);
	
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
			else if (searchField.equalsIgnoreCase("CONTENT")) {
				sTerm = new BodyTerm(searchValue);
			}
		}
		
		if (sTerm != null) {
			// pre-fetch fields needed for searching
			if (!searchField.equalsIgnoreCase("CONTENT")) {
				FetchProfile fp = new FetchProfile();
				fp.add(FetchProfile.Item.ENVELOPE);
				folder.fetch(messages, fp);
			}
			
			if (startDate != null) {
				sTerm = new AndTerm(sTerm, new ReceivedDateTerm(DateTerm.GE, startDate));
			}

			if (endDate != null) {
				sTerm = new AndTerm(sTerm, new ReceivedDateTerm(DateTerm.LT, endDate));
			}
			
			messages = folder.search(sTerm);
			
			Folder[] subFolders = folder.list();
			
			// search the sub folders and combine the results.			
			if (searchSubFolder) {
				for (Folder subFolder : subFolders) {
					subFolder.open(Folder.READ_ONLY);
					Message[] subMessages = searchFolder(subFolder, searchField, searchValue, startDate, endDate, searchSubFolder, sTerm);
					
					if (subMessages.length > 0) {
					   int mainLen = messages.length;
					   int subLen = subMessages.length;
					   Message[] combined = new Message[mainLen + subLen];
					   System.arraycopy(messages, 0, combined, 0, mainLen);
					   System.arraycopy(subMessages, 0, combined, mainLen, subLen);	
					   
					   messages = combined;
					}
				}
			}
		}		
		else {
			return null;
		}
		
		return messages;
	}
	
	public boolean copyInlineParts(Part src, Multipart dest) throws MessagingException, IOException {
		if (src.isMimeType("multipart/related")) {
			Multipart mp = (Multipart)src.getContent();
			int count = mp.getCount();
			boolean isAdded = false;
			for (int i = 0; i < count; i++) {
				BodyPart p = mp.getBodyPart(i);
				
				if (p instanceof MimePart) {
					if (((MimePart)p).getContentID() != null) {
						dest.addBodyPart(p);	
						isAdded = true;
					}
				}				
			}
			
			return isAdded;
		} 
		else if (src.isMimeType("multipart/*")) {
			Multipart mp = (Multipart)src.getContent();
			int count = mp.getCount();
			for (int i = 0; i < count; i++) {
				BodyPart p = mp.getBodyPart(i);
				
				if (copyInlineParts(p, dest)) {
					return true;
				}
			}
		}
		
		return false;
	}
	
	/**
	 * 메일 리스트 정렬 실행 함수
	 */
	public void sortMessages(Folder folder, Message[] messages, String sortTypeSpecifier, boolean isAscending) throws Exception {
		logger.debug("sortTypeSpecifier=" + sortTypeSpecifier + ",isAscending=" + isAscending);
		
		Comparator<Message> comparator = null;
		
		// subject
		if (sortTypeSpecifier.equals("subject")) {
			comparator = new IMAPAccess.MessageSubjectComparator();
			
			if (!isAscending) {
				comparator = Collections.reverseOrder(comparator);
			}
			
			// pre-fetch fields needed for sorting
			FetchProfile fp = new FetchProfile();
			fp.add(FetchProfile.Item.ENVELOPE);
			folder.fetch(messages, fp);			
		}
		// sender
		else if (sortTypeSpecifier.equals("sender")) {
			comparator = new IMAPAccess.MessageAddressComparator(true);
			
			if (!isAscending) {
				comparator = Collections.reverseOrder(comparator);
			}
			
			// pre-fetch fields needed for sorting
			FetchProfile fp = new FetchProfile();
			fp.add(FetchProfile.Item.ENVELOPE);
			folder.fetch(messages, fp);
		}		
		// recipient
		else if (sortTypeSpecifier.equals("recipient")) {
			comparator = new IMAPAccess.MessageAddressComparator(false);
			
			if (!isAscending) {
				comparator = Collections.reverseOrder(comparator);
			}
			
			// pre-fetch fields needed for sorting
			FetchProfile fp = new FetchProfile();
			fp.add(FetchProfile.Item.ENVELOPE);
			folder.fetch(messages, fp);
		}				
		// attachment
		else if (sortTypeSpecifier.equals("attachment")) {
			comparator = new IMAPAccess.MessageAttachmentComparator();
			
			if (!isAscending) {
				comparator = Collections.reverseOrder(comparator);
			}
			
			// pre-fetch fields needed for sorting
			FetchProfile fp = new FetchProfile();
			fp.add(FetchProfile.Item.CONTENT_INFO);
			fp.add(IMAPFolder.FetchProfileItem.INTERNALDATE);
			folder.fetch(messages, fp);
		}				
		// read/unread
		else if (sortTypeSpecifier.equals("readFlag")) {
			comparator = new IMAPAccess.MessageUnreadComparator();
			
			if (!isAscending) {
				comparator = Collections.reverseOrder(comparator);
			}
			
			// pre-fetch fields needed for sorting
			FetchProfile fp = new FetchProfile();
			fp.add(FetchProfile.Item.FLAGS);
			fp.add(IMAPFolder.FetchProfileItem.INTERNALDATE);
			folder.fetch(messages, fp);
		}		
		// bookmark
		else if (sortTypeSpecifier.equals("flag")) {
			comparator = new IMAPAccess.MessageFlaggedComparator();
			
			if (!isAscending) {
				comparator = Collections.reverseOrder(comparator);
			}
			
			// pre-fetch fields needed for sorting
			FetchProfile fp = new FetchProfile();
			fp.add(FetchProfile.Item.FLAGS);
			fp.add(IMAPFolder.FetchProfileItem.INTERNALDATE);
			folder.fetch(messages, fp);
		}								
		// importance
		else if (sortTypeSpecifier.equals("importance")) {
			comparator = new IMAPAccess.MessagePriorityComparator();
			
			if (!isAscending) {
				comparator = Collections.reverseOrder(comparator);
			}
								
			// pre-fetch fields needed for sorting
			FetchProfile fp = new FetchProfile();
			fp.add(IMAPFolder.FetchProfileItem.HEADERS);
			fp.add(IMAPFolder.FetchProfileItem.INTERNALDATE);
			folder.fetch(messages, fp);
		}								
		// size
		else if (sortTypeSpecifier.equals("size")) {
			comparator = new IMAPAccess.MessageSizeComparator();
			
			if (!isAscending) {
				comparator = Collections.reverseOrder(comparator);
			}
			
			// pre-fetch fields needed for sorting
			FetchProfile fp = new FetchProfile();
			fp.add(FetchProfile.Item.SIZE);
			fp.add(IMAPFolder.FetchProfileItem.INTERNALDATE);
			folder.fetch(messages, fp);
		}			
		// received date
		else if (sortTypeSpecifier.equals("receivedDate")) {
			comparator = new IMAPAccess.MessageReceivedDateComparator();
			
			if (!isAscending) {
				comparator = Collections.reverseOrder(comparator);
			}
			
			// pre-fetch fields needed for sorting
			FetchProfile fp = new FetchProfile();
			fp.add(IMAPFolder.FetchProfileItem.INTERNALDATE);
			folder.fetch(messages, fp);
		}			
		
		if (comparator != null) {			
			Arrays.sort(messages, comparator);
		}
	}
	
	public boolean copyAllPartsInMultipart(Part src, Multipart dest) throws MessagingException, IOException {
		if (src.isMimeType("multipart/*")) {
			Multipart mp = (Multipart)src.getContent();
			int count = mp.getCount();
			for (int i = 0; i < count; i++) {
				BodyPart p = mp.getBodyPart(i);
				
				dest.addBodyPart(p);										
			}
			
			return true;
		} 
		
		return false;
	}
	
	/**
	 * returns an array of long of size 2.
	 * first element is hour of time offset and
	 * second element is minute of time offset
	 */
	public long[] getTimeOffsetInHourAndMinute() {
		TimeZone tz = TimeZone.getDefault();
		long hours = TimeUnit.MILLISECONDS.toHours(tz.getRawOffset());
		long minutes = TimeUnit.MILLISECONDS.toMinutes(tz.getRawOffset())
						- TimeUnit.HOURS.toMinutes(hours);	
		
		long[] timeOffset = new long[2];
		timeOffset[0] = hours;
		timeOffset[1] = minutes;
		
		return timeOffset;
	}
	
	/**
	 * sends an HTTP POST request and returns the response. 
	 */
	public String getWebServiceResult(String urlString, String inputParams) throws Exception {
		String result = null;
		
		URL url = new URL(urlString);
		HttpURLConnection conn = (HttpURLConnection) url.openConnection();
		conn.setDoOutput(true);
		conn.setRequestMethod("POST");
		conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded; charset=utf-8");	
		
		if (inputParams != null) {
			OutputStream os = conn.getOutputStream();
			os.write(inputParams.getBytes());
			os.flush();
		}
		
		if (conn.getResponseCode() == HttpURLConnection.HTTP_OK) {
			BufferedReader br = new BufferedReader(
										new InputStreamReader(conn.getInputStream())
										);

			StringBuilder sb = new StringBuilder();
			String output;

			while ((output = br.readLine()) != null) {
				sb.append(output);
			}
			
			result = sb.toString();
			
			conn.disconnect();							
		}
		else {
			Exception e = new RuntimeException("Failed : HTTP error code : " + conn.getResponseCode());			
			
			throw e;
		} 
		
		return result;
	}    
	
	public boolean hasForwardedFlag(Message message) throws MessagingException {
		boolean isForwarded = false;
		String[] flags = message.getFlags().getUserFlags();	
		
		for (String flag : flags) {
			if (flag.equals("$Forwarded")) {
				isForwarded = true;
				break;
			}
		}

		return isForwarded;
	}
	
	public void setForwardedFlag(Message message, boolean isSet) throws MessagingException {
		Flags forwardedFlag = new Flags("$Forwarded");
		
		message.setFlags(forwardedFlag, isSet);
	}

	public boolean hasMDNSentFlag(Message message) throws MessagingException {
		boolean isMDNSent = false;
		String[] flags = message.getFlags().getUserFlags();		
		
		for (String flag : flags) {
			if (flag.equals("$MDNSent")) {
				isMDNSent = true;
				break;
			}
		}

		return isMDNSent;
	}
	
	public void setMDNSentFlag(Message message, boolean isSet) throws MessagingException {
		Flags mdnSentFlag = new Flags("$MDNSent");
		
		message.setFlags(mdnSentFlag, isSet);
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


