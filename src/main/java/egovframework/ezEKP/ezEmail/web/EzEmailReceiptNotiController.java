package egovframework.ezEKP.ezEmail.web;

import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
import javax.mail.Address;
import javax.mail.Folder;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONArray;
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
import org.springframework.web.bind.annotation.ResponseBody;
import org.w3c.dom.Document;

import com.sun.mail.imap.IMAPFolder;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.logic.IMAPAccess;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezEmail.util.EzEmailUtil;
import egovframework.ezEKP.ezEmail.vo.MailCancelVO;
import egovframework.ezEKP.ezEmail.vo.MailReadVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

/**
 * @Description [Controller] 메일 수신확인
 * @author 오픈솔루션팀 이효민
 * @Modification Information
 * 
 *    수정일        수정자         수정내용
 *    ----------    ------    -------------------
 *    2016.05.25    이효민    신규작성
 *
 * @see
 */

@Controller
public class EzEmailReceiptNotiController extends EgovFileMngUtil {

	private static final Logger logger = LoggerFactory.getLogger(EzEmailReceiptNotiController.class);

	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;

	@Resource(name = "egovMessageSource")
	private EgovMessageSource egovMessageSource;

	@Autowired
	private EzEmailService ezEmailService;
	
	@Resource(name = "EzCommonService")
    private EzCommonService ezCommonService;
	
	@Autowired
	private EzEmailUtil ezEmailUtil;
	
	/**
	 * 메일 수신확인/회수 화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailReaderList.do")
	public String mailConfig(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		String url = request.getParameter("url") == null ? "" : request.getParameter("url");
		model.addAttribute("url", url);
		return "ezEmail/mailReaderList";
	}
	
	/**
	 * 메일 수신확인 리스트 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailGetReceiveList.do", produces="text/xml; charset=utf-8")
	@ResponseBody
	public String mailGetReceiveList(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, @RequestBody String bodyData) throws Exception{
		logger.debug("mailGetReceiveList started.");
		logger.debug("bodyData=" + bodyData);
		
		List<String> userInfo = commonUtil.getUserIdAndPassword(loginCookie);
		String password  = userInfo.get(1);
		
		LoginVO loginInfo = commonUtil.userInfo(loginCookie);
		
		String domainName = ezCommonService.getTenantConfig("DomainName", loginInfo.getTenantId());
		String userEmail = loginInfo.getId() + "@" + domainName;
		logger.debug("userEmail=" + userEmail);
		
		String returnValue = "";
		
		Document xmldom = commonUtil.convertStringToDocument(bodyData);
		String uidStr = xmldom.getElementsByTagName("MESSAGEID").item(0).getTextContent();
		uidStr = uidStr.split("/")[1];
		long uid = Long.parseLong(uidStr); 
		
		IMAPAccess ia = null;
		try {
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userEmail, password, egovMessageSource, locale);
			
			Folder folder = ia.getFolder(egovMessageSource.getMessage("ezEmail.t99000026", locale));
			folder.open(Folder.READ_ONLY);
			Message message = ((IMAPFolder)folder).getMessageByUID(uid);
			
			StringBuilder sb = new StringBuilder();
			sb.append("<DATA>");
			
			if (message == null) {
				logger.error("Message not found. uid=" + uid);
			} else {
				String messageId = ((MimeMessage)message).getMessageID() == null ? "" : ((MimeMessage)message).getMessageID();
				logger.debug("messageId = " + messageId);
				
				//TODO: 외부용 메일 처리
//				String outerReadCheck = "NONE";
//				if (message.ExtendedProperties.Count > 0) {
//              	OuterReadCheck = GetExtendedPropertyName(message, "X-READCHECK");
//          	}
				
				//get readList(수신확인)
				List<MailReadVO> readList = ezEmailService.getMailReadList(loginInfo.getTenantId(), loginInfo.getId(), messageId);
				
				//get cancelList(회수)
				List<MailCancelVO> cancelList = ezEmailService.getMailCancelList(messageId);
				
				//get all recipients from email message(메일)
				Address[] addresses = message.getAllRecipients();
				
				//get individualAliasList from recipients
				List<String> addressList = new ArrayList<String>();
				for (Address address : addresses) {
					if (((InternetAddress)address).getAddress() != null) {
						addressList.add(((InternetAddress)address).getAddress());
					}
				}
				Map<String, String> individualAliasList = ezEmailService.getIndividualAliasMap(addressList, loginInfo.getTenantId());
				
				List<String> tempMailList = new ArrayList<String>();
				
				//recipients from email message
				for (Address address : addresses) {
					String email = ((InternetAddress)address).getAddress();
					String name = ((InternetAddress)address).getPersonal() == null ? 
							((InternetAddress)address).getAddress() : ((InternetAddress)address).getPersonal();
					if (email != null) {
						sb.append("<ROW>");
						sb.append("<READEREMAIL><![CDATA[" + email + "]]></READEREMAIL>");
						sb.append("<READERNAME><![CDATA[" + name + "]]></READERNAME>");
						
						if (individualAliasList.containsKey(email)) { //individualAlias인 경우
							email = individualAliasList.get(email);
						}
						
						String readDate = "UNREAD";
						for (MailReadVO vo : readList) {
							if (vo.getReaderEmail().equals(email)) {
								readDate = commonUtil.getDateStringInUTC(vo.getReadDate(), loginInfo.getOffset(), false);
								break;
							}
						}
						sb.append("<READDATE><![CDATA[" + readDate + "]]></READDATE>");
						
						String status = "";
						for (MailCancelVO vo : cancelList) {
							if (vo.getReaderEmail().equals(email)) {
								if (vo.getStatus() != null && !vo.getStatus().equals("")) {
									status = vo.getStatus();
								} else {
									status = "0";
								}
								break;
							}
						}
						sb.append("<CANCEL><![CDATA[" + status + "]]></CANCEL>");
						
						sb.append("</ROW>");
						
						tempMailList.add(email);
					}
				}
				
				//readList
				for (MailReadVO vo : readList) {
					if (!tempMailList.contains(vo.getReaderEmail())) {
						String readerEmail = vo.getReaderEmail();
						String readerName = vo.getReaderName();
					
						sb.append("<ROW>");
						sb.append("<READEREMAIL><![CDATA[" + readerEmail + "]]></READEREMAIL>");
						sb.append("<READERNAME><![CDATA[" + readerName + "]]></READERNAME>");
						
						vo.setReadDate(commonUtil.getDateStringInUTC(vo.getReadDate(), loginInfo.getOffset(), false));
						sb.append("<READDATE><![CDATA[" + vo.getReadDate() + "]]></READDATE>");
						
						String status = "";
						for (MailCancelVO cvo : cancelList) {
							if (cvo.getReaderEmail().equals(vo.getReaderEmail())) {
								if (cvo.getStatus() != null && !cvo.getStatus().equals("")) {
									status = cvo.getStatus();
								} else {
									status = "0";
								}
								break;
							}
						}
						sb.append("<CANCEL><![CDATA[" + status + "]]></CANCEL>");
						
						sb.append("</ROW>");
						
						tempMailList.add(readerEmail);
					}
				}
				
				//cancelList
				for (MailCancelVO vo : cancelList) {
					if (!tempMailList.contains(vo.getReaderEmail())) {
						String readerEmail = vo.getReaderEmail();
						//TODO: 회수 저장할 때 이름도 저장, 가져올 때 이름도 가져오도록
						
						sb.append("<ROW>");
						sb.append("<READEREMAIL><![CDATA[" + readerEmail + "]]></READEREMAIL>");
						sb.append("<READERNAME><![CDATA[" + readerEmail + "]]></READERNAME>");
						sb.append("<READDATE><![CDATA[UNREAD]]></READDATE>");
						
						String status = "";
						if (vo.getStatus() != null && !vo.getStatus().equals("")) {
							status = vo.getStatus();
						} else {
							status = "0";
						}
						sb.append("<CANCEL><![CDATA[" + status + "]]></CANCEL>");
						
						sb.append("</ROW>");
					}
				}
				
				sb.append("<SUBJECT><![CDATA[" + message.getSubject() + "]]></SUBJECT>");
				
			}
			
	        folder.close(true);
	        
	        sb.append("</DATA>");
			returnValue = sb.toString();
	        
		} catch (MessagingException e) {
			returnValue = "<DATA>ERROR</DATA>";
			e.printStackTrace();
		} finally {
			if (ia != null) {
				ia.close();
			}
		}
		
		logger.debug("returnValue=" + returnValue);
		logger.debug("mailGetReceiveList ended.");
		
		return returnValue;
	}
	
	/**
	 * 메일 회수 실행 함수
	 */
	@RequestMapping(value="/ezEmail/mailCancelSend.do", produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String mailCancelSend(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, @RequestBody String bodyData) throws Exception{
		logger.debug("mailCancelSend started.");
		logger.debug("bodyData=" + bodyData);
		
		String localServerName = config.getProperty("config.COMPUTERNAME");
		
		List<String> userInfo = commonUtil.getUserIdAndPassword(loginCookie);
		String password  = userInfo.get(1);
		
		LoginVO loginInfo = commonUtil.userInfo(loginCookie);
		String domainName = ezCommonService.getTenantConfig("DomainName", loginInfo.getTenantId());
		String userAccount = loginInfo.getId() + "@" + domainName;
		logger.debug("userEmail=" + userAccount);
		
		Document xmldom = commonUtil.convertStringToDocument(bodyData);
		String url = xmldom.getElementsByTagName("URL").item(0).getTextContent();
		String folderPath = url.split("/")[0];
		String uidStr = url.split("/")[1];
		long uid = Long.parseLong(uidStr);
		
		//넘어온 folderPath가 보낸편지함이 아닐경우
		if (!folderPath.equals(egovMessageSource.getMessage("ezEmail.t99000026", locale))) {
			logger.debug(egovMessageSource.getMessage("ezEmail.t99000108", locale));
			logger.debug("mailCancelSend ended.");
			return egovMessageSource.getMessage("ezEmail.t99000108", locale);
		}
		
		String pEachCancel = "NO";
		if (xmldom.getElementsByTagName("EMAILADDRESS") != null && xmldom.getElementsByTagName("EMAILADDRESS").getLength() > 0) {
			pEachCancel = xmldom.getElementsByTagName("EMAILADDRESS").item(0).getTextContent();
			pEachCancel = URLDecoder.decode(pEachCancel, "UTF-8");
		}
		logger.debug("pEachCancel=" + pEachCancel);
		
		IMAPAccess ia = null;
		try {
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userAccount, password, egovMessageSource, locale);
			
			Folder folder = ia.getFolder(egovMessageSource.getMessage("ezEmail.t99000026", locale));
			folder.open(Folder.READ_ONLY);
			Message message = ((IMAPFolder)folder).getMessageByUID(uid);
			
			if (message == null) {
				logger.debug(egovMessageSource.getMessage("ezEmail.t99000109", locale));
				logger.debug("mailCancelSend ended.");
				return egovMessageSource.getMessage("ezEmail.t99000109", locale);
			}
			
			//메시지의 from이 user의 계정인지(또는 user의 alias mail)인지 검사
			String from = ((InternetAddress)message.getFrom()[0]).getAddress();
			logger.debug("from=" + from);
			
			List<String> userMailAliasList = ezEmailService.getIndividualAlias(userAccount);
			userMailAliasList.add(userAccount);
			
			boolean isUserFrom = false;
			for (String userMail : userMailAliasList) {
				if (userMail.equals(from)) {
					isUserFrom = true;
					break;
				}
			}
			
			if (!isUserFrom) {
				logger.debug(egovMessageSource.getMessage("ezEmail.t99000110", locale));
				logger.debug("mailCancelSend ended.");
				return egovMessageSource.getMessage("ezEmail.t99000110", locale);
			}
			
			//수신자 수가 max를 넘는 메일은 회수가 불가능
			int maxRecAllCount = 500;
			Address[] addresses = message.getAllRecipients();
			if (addresses.length > maxRecAllCount) {
				logger.debug(egovMessageSource.getMessage("ezEmail.t99000111", locale) + maxRecAllCount + egovMessageSource.getMessage("ezEmail.t99000112", locale));
				logger.debug("mailCancelSend ended.");
				return egovMessageSource.getMessage("ezEmail.t99000111", locale) + maxRecAllCount + egovMessageSource.getMessage("ezEmail.t99000112", locale);
			}
			
			String internetMessageId = ((MimeMessage)message).getMessageID();
			String subject = message.getSubject();
			
			//get arrAddress
			String[] arrAddress = null;
			if (pEachCancel.equals("NO")) {
				arrAddress = new String[addresses.length];
				for (int i=0; i<addresses.length; i++) {
					arrAddress[i] = ((InternetAddress)addresses[i]).getAddress();
				}
			} else {
				arrAddress = pEachCancel.split("\\|!\\|");
			}
			
			//alias address(부서 address, 개인 alias address 등)가 있으면 real address로 바꾼다.
			arrAddress = getMember(arrAddress);
			
			//get innerAddresses(내부사용자)
			List<String> innerAddresses = new ArrayList<String>();
			for (String address : arrAddress) {
				int index = address.indexOf("@");
				String domain = "";
				if (index > -1) {
					domain = address.substring(index + 1);
				}
				
				if (domain.equals(domainName)) {
					innerAddresses.add(address);
				}
			}
			
			//내부사용자 없을 경우 리턴
			if (innerAddresses.size() == 0) {
				logger.debug(egovMessageSource.getMessage("ezEmail.t99000113", locale));
				logger.debug("mailCancelSend ended.");
				return egovMessageSource.getMessage("ezEmail.t99000113", locale);
			}
			
			ezEmailService.setMailCancelSend(loginInfo.getTenantId(), internetMessageId, loginInfo.getId(), subject, localServerName, innerAddresses);
			
			folder.close(true);
			
		} catch (MessagingException e) {
			e.printStackTrace();
		} finally {
			if (ia != null) {
				ia.close();
			}
		}
		
		logger.debug("mailCancelSend ended.");
		
		return "OK";
	}
	
	public String[] getMember(String[] addresses) {
		String[] rValue = null;
		try {
			String inputParams = "";
			
			for (int i=0; i<addresses.length; i++) {
				if (i == 0) {
					inputParams = "address=" + URLEncoder.encode(addresses[i], "UTF-8");
				} else {
					inputParams += "&address=" + URLEncoder.encode(addresses[i], "UTF-8");
				}
			}
			
			logger.debug("inputParams=" + inputParams);
			
			String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaAccess/getAliasMail", inputParams);
			
			JSONParser parser = new JSONParser();
			JSONObject object = (JSONObject)parser.parse(strJson);
	        
	        if (object.get("resultCode").equals("OK")) {
	        	JSONArray array = (JSONArray)object.get("result");
	        	rValue = new String[array.size()];
	        	for (int i=0; i<array.size(); i++) {
	        		rValue[i] = array.get(i).toString();
	        	}
	        }
	        
        
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return rValue;
	}
	
}
