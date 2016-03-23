package egovframework.ezEKP.ezEmail.web;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Properties;

import javax.annotation.Resource;
import javax.mail.Address;
import javax.mail.Folder;
import javax.mail.Message;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeUtility;
import javax.servlet.http.HttpServletRequest;

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
		
		long uid = Long.parseLong(request.getParameter("URL"));
		String pnFlag = request.getParameter("PNFlag");
		String contentClass = request.getParameter("CONTENTCLASS");
		String folderName = "INBOX";
		
		IMAPAccess ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
				id+"@"+config.getProperty("config.DomainName"), password, egovMessageSource);
		Folder f = ia.getFolder(folderName);
		Address[] arrFroms = null;
		Address[] arrRecipientsTo = null;
		Address[] arrRecipientsCC = null;
		Address[] arrRecipientsBCC = null;
		Date date = null;
		String fromStr = null;
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
						if(name != null){
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
						if(name != null){
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
				
			}
			f.close(true);
		}
		ia.close();
		model.addAttribute("fromStr", fromStr);
		model.addAttribute("toStr", toStr);
		model.addAttribute("toHiddenStr", toHiddenStr);
		model.addAttribute("ccStr", ccStr);
		model.addAttribute("ccHiddenStr", ccHiddenStr);
		model.addAttribute("bccStr", bccStr);
		model.addAttribute("dateStr", dateStr);
		model.addAttribute("subject", subject);
		model.addAttribute("title", title);
		return "ezEmail/mailRead";
	}
	
	@RequestMapping(value="/ezEmail/mailReadContent.do")
	public String readMailContent(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception{
		
		return "ezEmail/mailReadContent";
	}
	
	private String getReceiverHTML(String name, String address)
    {
        return "<span style='cursor:pointer' title='" + (name==null?"":EgovStringUtil.getSpclStrCnvr(name)) + "' onclick='show_personinfo(\"" + address + "\")'>" + (name==null?"":EgovStringUtil.getSpclStrCnvr(name)) + "</span>";
    }
	
}
