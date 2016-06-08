package egovframework.ezEKP.ezEmail.web;

import java.io.StringReader;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Properties;

import javax.annotation.Resource;
import javax.json.Json;
import javax.json.JsonArray;
import javax.json.JsonObject;
import javax.json.JsonReader;
import javax.json.JsonValue;
import javax.mail.Address;
import javax.mail.Folder;
import javax.mail.Message;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.w3c.dom.Document;

import com.sun.mail.imap.IMAPFolder;
import com.sun.mail.imap.IMAPMessage;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezEmail.logic.IMAPAccess;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezEmail.task.EzEmailAsync;
import egovframework.ezEKP.ezEmail.util.EzEmailUtil;
import egovframework.ezEKP.ezEmail.vo.MailCancelVO;
import egovframework.ezEKP.ezEmail.vo.MailReadVO;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
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
	private EzOrganAdminService ezOrganAdminService;

	@Autowired
	private EzOrganService ezOrganService;

	@Autowired
	private EzEmailService ezEmailService;

	@Autowired
	private EzEmailUtil ezEmailUtil;
	
	@Autowired
	private EzEmailAsync ezEmailAsync;
	
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
	public String mailGetReceiveList(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		List<String> userInfo = commonUtil.getUserIdAndPassword(loginCookie);
		String id = userInfo.get(0);
		String password  = userInfo.get(1);
		
		String returnValue = "";
		
		Document xmldom = commonUtil.convertRequestToDocument(request);
		String uidStr = xmldom.getElementsByTagName("MESSAGEID").item(0).getTextContent();
		uidStr = uidStr.split("/")[1];
		long uid = Long.parseLong(uidStr); 
		
		IMAPAccess ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
				id+"@"+config.getProperty("config.DomainName"), password, egovMessageSource, locale);
		
		Folder folder = ia.getFolder(egovMessageSource.getMessage("ezEmail.t99000026", locale));
		folder.open(Folder.READ_ONLY);
		Message message = ((IMAPFolder)folder).getMessageByUID(uid);
		
		if (message != null) {
			String messageId = ((MimeMessage)message).getMessageID() == null ? "" : ((MimeMessage)message).getMessageID();
			String outerReadCheck = "NONE"; //외부용 관련 변수
			
			//TODO: 외부용 메일 처리
//			if (message.ExtendedProperties.Count > 0)
//            {
//                OuterReadCheck = GetExtendedPropertyName(message, "X-READCHECK");
//            }
			
			StringBuilder sb = new StringBuilder();
			sb.append("<DATA>");
			
			//pUserId:userInfo.Email, pUserId2:userInfo.userId 이지만 우선 둘다 쿠키의 id@opensol2016.com으로 넣음.
			String userId = id + "@" + config.getProperty("config.DomainName");
			String userId2 = id + "@" + config.getProperty("config.DomainName");
			logger.debug("messageId = " + messageId);
			List<MailReadVO> readList = ezEmailService.getMailReadList(userId, userId2, messageId, outerReadCheck);
			
			List<MailCancelVO> cancelList = ezEmailService.getMailCancelList(messageId);
			
			for (MailReadVO vo : readList) {
				sb.append("<ROW>");
				sb.append("<READEREMAIL><![CDATA[" + vo.getReaderEmail() + "]]></READEREMAIL>");
				sb.append("<READERNAME><![CDATA[" + vo.getReaderName() + "]]></READERNAME>");
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
			}
			
			Address[] addresses = message.getAllRecipients();
			for (Address address : addresses) {
				String email = ((InternetAddress)address).getAddress();
				String name = ((InternetAddress)address).getPersonal() == null ? 
						((InternetAddress)address).getAddress() : ((InternetAddress)address).getPersonal();
						
				if (email != null) {
					boolean flag = false;
					for (MailReadVO vo : readList) {
						if (email.equals(vo.getReaderEmail())) {
							flag = true;
							break;
						}
					}
					
					if (flag) {
						continue;
					}
					
					sb.append("<ROW>");
					sb.append("<READEREMAIL><![CDATA[" + email + "]]></READEREMAIL>");
					sb.append("<READERNAME><![CDATA[" + name + "]]></READERNAME>");
					sb.append("<READDATE><![CDATA[UNREAD]]></READDATE>");
					
					String status = "";
					for (MailCancelVO cvo : cancelList) {
						if (cvo.getReaderEmail() != null && cvo.getReaderEmail().equals(email)) {
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
				}
				
			}
			
			sb.append("<SUBJECT><![CDATA[" + message.getSubject() + "]]></SUBJECT>");
			sb.append("</DATA>");
			returnValue = sb.toString();
		}
		
        folder.close(true);
		ia.close();
		
		if (!returnValue.contains("DATA")) {
			returnValue = "<DATA>ERROR</DATA>";
		}
		
		return returnValue;
	}
	
	/**
	 * 메일 회수 실행 함수
	 */
	@RequestMapping(value="/ezEmail/mailCancelSend.do", produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String mailCancelSend(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		String strError = "";
		String localServerName = config.getProperty("config.COMPUTERNAME");
		
		List<String> userInfo = commonUtil.getUserIdAndPassword(loginCookie);
		String id = userInfo.get(0);
		String password  = userInfo.get(1);
		
		Document xmldom = commonUtil.convertRequestToDocument(request);
		String url = xmldom.getElementsByTagName("URL").item(0).getTextContent();
		String folderPath = url.split("/")[0];
		String uidStr = url.split("/")[1];
		long uid = Long.parseLong(uidStr); 
		
		//넘어온 folderPath가 보낸편지함이 아닐경우
		if (!folderPath.equals(egovMessageSource.getMessage("ezEmail.t99000026", locale))) {
			return "메일 회수는 보낸편지함의 메일만 가능합니다.";
		}
		
		String pEachCancel = "NO";
		if (xmldom.getElementsByTagName("EMAILADDRESS") != null && xmldom.getElementsByTagName("EMAILADDRESS").getLength() > 0) {
			pEachCancel = xmldom.getElementsByTagName("EMAILADDRESS").item(0).getTextContent();
			pEachCancel = URLDecoder.decode(pEachCancel, "UTF-8");
		}
		
		String emailAddress = id + "@" + config.getProperty("config.DomainName");
		
		IMAPAccess ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
				id+"@"+config.getProperty("config.DomainName"), password, egovMessageSource, locale);
		
		Folder folder = ia.getFolder(egovMessageSource.getMessage("ezEmail.t99000026", locale));
		folder.open(Folder.READ_ONLY);
		Message message = ((IMAPFolder)folder).getMessageByUID(uid);
		
		if (message == null) {
			return "삭제 하려는 원본 메일이 보낸 편지함에 없습니다.\r\n직전발송한 메일 회수인 경우 잠시 후 다시 시도 하여 주십시오.";
		}
		
		String from = ((InternetAddress)message.getFrom()[0]).getAddress();
		if (!from.equals(emailAddress)) {
			return "메일 회수는 자신이 보낸메일만 가능합니다.";
		}
		
		int maxRecAllCount = 500;
		Address[] addresses = message.getAllRecipients();
		if (addresses.length > maxRecAllCount) {
			return "메일 회수는 수신자 수가 " + maxRecAllCount + " 명 이상인 메일은 회수 할 수 없습니다.";
		}
		
		String internetMessageId = ((IMAPMessage)message).getMessageID();
		String subject = message.getSubject();
		
		DateFormat sdFormat = new SimpleDateFormat("yyyyMMdd");
		String createDate = sdFormat.format(message.getSentDate());
		
		String isInsert = ezEmailService.checkDoubleMailReceive(emailAddress, subject, createDate, internetMessageId, localServerName);
		logger.debug("isInsert = " + isInsert);
		
		if (pEachCancel.equals("NO")) {
			
			String[] arrAddress = new String[addresses.length];
			for (int i=0; i<addresses.length; i++) {
				arrAddress[i] = ((InternetAddress)addresses[i]).getAddress();
			}
			
			arrAddress = getMember(arrAddress);
			
			//내부사용자 추출
			List<String> innerAddresses = new ArrayList<String>();
			for (String address : arrAddress) {
				int index = address.indexOf("@");
				String domain = "";
				if (index > -1) {
					domain = address.substring(index + 1);
				}
				if (domain.equals(config.getProperty("config.DomainName"))) {
					innerAddresses.add(address);
				}
			}
			
			if (isInsert == null) {
				isInsert = ezEmailService.insertMailReceiveInfo(emailAddress, subject, createDate, internetMessageId, localServerName, "");
			}
			
			if (innerAddresses.size() == 0) {
				return "메일회수신청 하였으나 내부 사용자가 포함되어 있지 않습니다.";
			}
			
			for (String address : innerAddresses) {
				ezEmailService.insertMailReceiveDetailInfo(Integer.parseInt(isInsert), address);
			}
			
			//회수처리 함수 호출(비동기)
			ezEmailAsync.cancelMailDelete(isInsert);
		} else {
			String[] emailAddressArray = pEachCancel.split("\\|!\\|");
			
			emailAddressArray = getMember(emailAddressArray);
			
			//내부사용자 추출
			List<String> innerAddresses = new ArrayList<String>();
			for (String address : emailAddressArray) {
				int index = address.indexOf("@");
				String domain = "";
				if (index > -1) {
					domain = address.substring(index + 1);
				}
				if (domain.equals(config.getProperty("config.DomainName"))) {
					innerAddresses.add(address);
				}
			}
			
			if (isInsert == null) {
				isInsert = ezEmailService.insertMailReceiveInfo(emailAddress, subject, createDate, internetMessageId, localServerName, "");
			}
			
			if (innerAddresses.size() == 0) {
				return "메일회수신청 하였으나 내부 사용자가 포함되어 있지 않습니다.";
			}
			
			for (String address : innerAddresses) {
				ezEmailService.insertMailReceiveDetailInfo(Integer.parseInt(isInsert), address);
			}
			
			//회수처리 함수 호출(비동기)
			ezEmailAsync.cancelMailDelete(isInsert);
		}
		
		folder.close(true);
		ia.close();
		
		
		
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
			JsonReader reader = null;
			reader = Json.createReader(new StringReader(strJson));
	        JsonObject jo = reader.readObject();
	        
	        if (jo.get("result") != null) {
	        	JsonArray result = (JsonArray)jo.get("result");
	        	rValue = new String[result.size()];
	        	for (int i=0; i<result.size(); i++) {
	        		rValue[i] = result.get(i).toString().replaceAll("\"", "");
	        	}
	        }
	        
	        reader.close();
        
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return rValue;
	}
	
}
