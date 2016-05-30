package egovframework.ezEKP.ezEmail.web;

import java.net.URLEncoder;
import java.util.List;
import java.util.Locale;
import java.util.Properties;

import javax.annotation.Resource;
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
		url = URLEncoder.encode(url, "UTF-8");
		model.addAttribute("url", url);
		return "ezEmail/mailReaderList";
	}
	
	/**
	 * 메일 수신확인 리스트 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailGetReceiveList.do", produces = "text/xml; charset=utf-8")
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
			
			/*
			<DATA>
			  <ROW>
			    <READDATE>0025-05-16 오전 12:00:00</READDATE>
			    <READEREMAIL>gisa1@opensol2014.com</READEREMAIL>
			    <READERNAME>gisa1</READERNAME>
			    <CANCEL>
			    </CANCEL>
			  </ROW>
			  <ROW>
			    <READEREMAIL><![CDATA[RAB1@opensol2014.com]]></READEREMAIL>
			    <READERNAME><![CDATA[부설연구소]]></READERNAME>
			    <READDATE><![CDATA[UNREAD]]></READDATE>
			    <CANCEL>
			    </CANCEL>
			  </ROW>
			  <ROW>
			    <READEREMAIL><![CDATA[OPENSOL@opensol2014.com]]></READEREMAIL>
			    <READERNAME><![CDATA[오픈솔루션팀]]></READERNAME>
			    <READDATE><![CDATA[UNREAD]]></READDATE>
			    <CANCEL>
			    </CANCEL>
			  </ROW>
			  <ROW>
			    <READEREMAIL><![CDATA[GJS@opensol2014.com]]></READEREMAIL>
			    <READERNAME><![CDATA[경영지원실]]></READERNAME>
			    <READDATE><![CDATA[UNREAD]]></READDATE>
			    <CANCEL>
			    </CANCEL>
			  </ROW>
			  <SUBJECT>test</SUBJECT>
			</DATA>
			*/
			StringBuilder sb = new StringBuilder();
			sb.append("<DATA>");
			
			//pUserId:userInfo.Email, pUserId2:userInfo.userId 이지만 우선 둘다 쿠키의 id@opensol2016.com으로 넣음.
			String userId = id + "@" + config.getProperty("config.DomainName");
			String userId2 = id + "@" + config.getProperty("config.DomainName");
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
						if (cvo.getReaderEmail().equals(email)) {
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
			sb.append("<DATA>");
			returnValue = sb.toString();
		}
		
        folder.close(true);
		ia.close();
		
		if (!returnValue.contains("DATA")) {
			returnValue = "<DATA>ERROR</DATA>";
		}
		
		return returnValue;
	}
	
}
