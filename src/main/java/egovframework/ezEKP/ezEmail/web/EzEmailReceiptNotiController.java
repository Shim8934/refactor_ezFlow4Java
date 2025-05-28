package egovframework.ezEKP.ezEmail.web;

import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Comparator;
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

import org.apache.commons.lang3.StringUtils;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
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

import com.sun.mail.imap.IMAPFolder;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.logic.IMAPAccess;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezEmail.service.EzEmailUserAdminService;
import egovframework.ezEKP.ezEmail.util.EzEmailUtil;
import egovframework.ezEKP.ezEmail.vo.MailCancelVO;
import egovframework.ezEKP.ezEmail.vo.MailReadVO;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.ezEKP.ezSystem.service.EzSystemAdminService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

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
	
	@Autowired
	private EzOrganAdminService ezOrganAdminService;
	
	@Resource(name = "EzCommonService")
    private EzCommonService ezCommonService;
	
	@Resource(name="EzSystemAdminService")
	private EzSystemAdminService ezSystemAdminService;
	
	@Autowired
	private EzEmailUtil ezEmailUtil;
	
	@Resource(name="crypto") 
    private EgovFileScrty egovFileScrty;

	@Resource(name="EzEmailUserAdminService")
	private EzEmailUserAdminService ezEmailUserAdminService;
	
	/**
	 * 메일 수신확인/회수 화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailReaderList.do", method = RequestMethod.GET)
	public String mailReaderList(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		logger.debug("mailReaderList started.");
		
		String url = request.getParameter("url") == null ? "" : request.getParameter("url");
		LoginVO loginInfo = commonUtil.userInfo(loginCookie);
		String isReadDelete = ezCommonService.getTenantConfig("IS_READ_DELETE", loginInfo.getTenantId());
		String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", loginInfo.getTenantId());

		if (useSharedMailbox.equals("YES")) {
			String shareId = request.getParameter("shareId");
			logger.debug("shareId=" + shareId);
			
			if (shareId != null) {
				if (!ezEmailService.checkUserShareId(loginInfo.getId(), shareId, 2, loginInfo.getTenantId())) {
					model.addAttribute("mainContent", egovMessageSource.getMessage("ezEmail.lhm81", locale));
					
					logger.debug("the user cannot access the shareId.");
					logger.debug("mailReaderList ended.");
					
					return "ezCommon/error";
				} else {
					model.addAttribute("shareId", shareId);
				}
			}
		}
		
		model.addAttribute("isReadDelete", isReadDelete);
		model.addAttribute("url", url);
		
		logger.debug("mailReaderList ended.");
		return "ezEmail/mailReaderList";
	}
	
	/**
	 * 메일 수신확인 리스트 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailGetReceiveList.do", produces="text/xml; charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String mailGetReceiveList(
			@CookieValue("loginCookie") String loginCookie,
			HttpServletRequest request,
			Locale locale, 
			Model model, 
			@RequestBody String bodyData) throws Exception{
		logger.debug("mailGetReceiveList started.");
		logger.debug("bodyData=" + bodyData);
		
		List<String> userInfo = commonUtil.getUserIdAndPassword(loginCookie);
		String password  = userInfo.get(1);
		
		LoginVO loginInfo = commonUtil.userInfo(loginCookie);
		
		String domainName = ezCommonService.getTenantConfig("DomainName", loginInfo.getTenantId());
		String userEmail = loginInfo.getId() + "@" + domainName;
		String mailId = loginInfo.getId();
		String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", loginInfo.getTenantId());

		if (useSharedMailbox.equals("YES")) {
			String shareId = request.getParameter("shareId");
			logger.debug("shareId=" + shareId);
			
			if (shareId != null) {
				if (!ezEmailService.checkUserShareId(loginInfo.getId(), shareId, 2, loginInfo.getTenantId())) {
					logger.debug("the user cannot access the shareId.");
					logger.debug("mailGetReceiveList ended.");
					
					return "";
				}
				
				mailId = shareId;
				userEmail = shareId + "@" + domainName;
			}
		}
		
		logger.debug("userId=" + loginInfo.getId() + ",userEmail=" + userEmail);
		
		String returnValue = "";
		
		Document xmldom = commonUtil.convertStringToDocument(bodyData != null ? bodyData : "");
		String uidStr = xmldom.getElementsByTagName("MESSAGEID").item(0).getTextContent();
		uidStr = uidStr.split("/")[1];
		long uid = Long.parseLong(uidStr); 
		
		IMAPAccess ia = null;
		try {
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userEmail, password, egovMessageSource, locale, ezEmailUtil);

			if (ia == null){
				throw new Exception("ia is null");
			}
			Folder folder = ia.getFolder(ezEmailUtil.getSentFolderId(locale));
			if (folder == null){
				throw new Exception("Folder is null");
			}
			folder.open(Folder.READ_ONLY);
			Message message = ((IMAPFolder)folder).getMessageByUID(uid);

			StringBuilder sb = new StringBuilder();
			StringBuilder unreadSb = new StringBuilder();

			sb.append("<DATA>");

			if (message == null) {
				logger.error("Message not found. uid=" + uid);
			} else {
				String messageId = ((MimeMessage)message).getMessageID() == null ? "" : ((MimeMessage)message).getMessageID();
				logger.debug("messageId = " + messageId);

				// get readList(수신확인)
				// readList의 reader 주소에는 alias 주소가 들어올 수 있다.
				List<MailReadVO> readList = ezEmailService.getMailReadList(loginInfo.getTenantId(), mailId, messageId);

				// get cancelList(회수)
				//cancelList의 reader 주소에는 real(account) 주소만 들어온다.
				List<MailCancelVO> cancelList = ezEmailService.getMailCancelList(messageId);

				// get all recipients from email message(메일)
				// addresses에는 alias 주소가 들어올 수 있다.
				Address[] addresses = message.getAllRecipients();

				// get aliasAddressMap from addresses and readList
				// alias 주소가 들어올 수 있는 addresses와 readList reader 주소로부터 real 주소를 가져온다.
				List<String> addressList = new ArrayList<String>();

				for (Address address : addresses) {
					if (((InternetAddress)address).getAddress() != null) {
						addressList.add(((InternetAddress)address).getAddress());
					}
				}

				for (MailReadVO vo : readList) {
					addressList.add(vo.getReaderEmail());
				}

				Map<String, String> aliasAddressMap = ezEmailService.getAliasAddressMap(addressList, loginInfo.getTenantId());

				// tempMailList는 중복을 제거하기 위해 이미 처리한 메일주소를 담는다. 메일주소는 real 주소로만 들어간다.
				List<String> tempMailList = new ArrayList<String>();

				// recipients from email message
				for (Address address : addresses) {
					String email = ((InternetAddress)address).getAddress();
					String name = ((InternetAddress)address).getPersonal() == null ?
							((InternetAddress)address).getAddress() : ((InternetAddress)address).getPersonal();
					if (email != null) {
						StringBuilder tempSb = new StringBuilder();

						tempSb.append("<ROW>");
						tempSb.append("<READEREMAIL><![CDATA[" + email + "]]></READEREMAIL>");
						tempSb.append("<READERNAME><![CDATA[" + name + "]]></READERNAME>");

						// 메일 수신자의 주소가 alias 주소인 경우 real(account) 주소로 바꾼다.
						if (aliasAddressMap.containsKey(email)) {
							email = aliasAddressMap.get(email);
						}

						String readDate = "UNREAD";

						for (MailReadVO vo : readList) {

							// readList의 reader 주소가 alias 주소인 경우 real(account) 주소로 바꾸어 비교한다.
							if (aliasAddressMap.containsKey(vo.getReaderEmail())) {
								if (aliasAddressMap.get(vo.getReaderEmail()).equals(email)) {
									readDate = commonUtil.getDateStringInUTC(vo.getReadDate(), loginInfo.getOffset(), false);
									break;
								}
							} else {
								if (vo.getReaderEmail().equals(email)) {
									readDate = commonUtil.getDateStringInUTC(vo.getReadDate(), loginInfo.getOffset(), false);
									break;
								}
							}
						}

						tempSb.append("<READDATE><![CDATA[" + readDate + "]]></READDATE>");

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

						tempSb.append("<CANCEL><![CDATA[" + status + "]]></CANCEL>");
						tempSb.append("</ROW>");

						if (readDate.equals("UNREAD")) {
							unreadSb.append(tempSb.toString());
						} else {
							sb.append(tempSb.toString());
						}

						tempMailList.add(email);
					}
				}
				
				// readList
				for (MailReadVO vo : readList) {
					String realEmailAddress = vo.getReaderEmail();

					// readList의 reader 주소가 alias 주소인 경우 real(account) 주소로 바꾸어 비교한다.
					if (aliasAddressMap.containsKey(realEmailAddress)) {
						realEmailAddress = aliasAddressMap.get(realEmailAddress);
					}

					if (!tempMailList.contains(realEmailAddress)) {
						String readerEmail = vo.getReaderEmail();
						String readerName = vo.getReaderName();

						sb.append("<ROW>");
						sb.append("<READEREMAIL><![CDATA[" + readerEmail + "]]></READEREMAIL>");
						sb.append("<READERNAME><![CDATA[" + readerName + "]]></READERNAME>");

						vo.setReadDate(commonUtil.getDateStringInUTC(vo.getReadDate(), loginInfo.getOffset(), false));
						sb.append("<READDATE><![CDATA[" + vo.getReadDate() + "]]></READDATE>");

						String status = "";
						for (MailCancelVO cvo : cancelList) {
							if (cvo.getReaderEmail().equals(realEmailAddress)) {
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

						tempMailList.add(realEmailAddress);
					}
				}

				String companyDomainName = ezCommonService.getCompanyConfig(loginInfo.getTenantId(), loginInfo.getCompanyID(), "DomainName");

				cancelList.sort(Comparator.comparing(MailCancelVO::getReaderName));
				
				// cancelList
				for (MailCancelVO vo : cancelList) {
					if (!tempMailList.contains(vo.getReaderEmail())) {
						String readerEmail = vo.getReaderEmail();
						String readerName = vo.getReaderName() == null ? readerEmail : vo.getReaderName();
						String primaryEmail = vo.getPrimaryEmail();
						String status = "";

						if (vo.getStatus() != null && !vo.getStatus().equals("")) {
							status = vo.getStatus();
						} else {
							status = "0";
						}

						logger.debug("cancelled email readerEmail=" + readerEmail);

						// 회사별 이메일 도메인명이 설정되어 있으면 Account 이메일 주소 대신에 Primary 이메일 주소로 표시한다.
						if (!companyDomainName.isEmpty()) {
							if (primaryEmail != null && !primaryEmail.isEmpty()) {
								readerEmail = primaryEmail;
							}
						}
						unreadSb.append("<ROW>")
								.append("<READEREMAIL><![CDATA[").append(readerEmail).append("]]></READEREMAIL>")
								.append("<READERNAME><![CDATA[").append(readerName).append("]]></READERNAME>")
								.append("<READDATE><![CDATA[UNREAD]]></READDATE>")
								.append("<CANCEL><![CDATA[").append(status).append("]]></CANCEL>")
								.append("</ROW>");
					}
				}

				sb.append(unreadSb.toString());
				sb.append("<SUBJECT><![CDATA[" + message.getSubject() + "]]></SUBJECT>");

			}

	        folder.close(true);
	        
	        sb.append("</DATA>");
			returnValue = sb.toString();
	        
		} catch (MessagingException e) {
			returnValue = "<DATA>ERROR</DATA>";
			logger.error(e.getMessage(), e);
		} catch (Exception e) {
			returnValue = "<DATA>ERROR</DATA>";
			logger.error(e.getMessage(), e);
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
	@RequestMapping(value="/ezEmail/mailCancelSend.do", produces = "text/xml; charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String mailCancelSend(
			@CookieValue("loginCookie") String loginCookie, 
			HttpServletRequest request,
			Locale locale, 
			Model model, 
			@RequestBody String bodyData) throws Exception{
		logger.debug("mailCancelSend started.");
		logger.debug("bodyData=" + bodyData);
		
		List<String> userInfo = commonUtil.getUserIdAndPassword(loginCookie);
		String password  = userInfo.get(1);
		
		LoginVO loginInfo = commonUtil.userInfo(loginCookie);
		String domainName = ezCommonService.getTenantConfig("DomainName", loginInfo.getTenantId());
		String userAccount = loginInfo.getId() + "@" + domainName;
		String mailId = loginInfo.getId();
		String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", loginInfo.getTenantId());
		String pGubun = request.getParameter("gubun");
		if (useSharedMailbox.equals("YES")) {
			String shareId = request.getParameter("shareId");
			logger.debug("shareId=" + shareId);
			
			if (shareId != null) {
				if (!ezEmailService.checkUserShareId(loginInfo.getId(), shareId, 2, loginInfo.getTenantId())) {
					logger.debug("the user cannot access the shareId.");
					logger.debug("mailCancelSend ended.");
					
					return "";
				}
				
				mailId = shareId;
				userAccount = shareId + "@" + domainName;
			}
		}
		
		logger.debug("userId=" + loginInfo.getId() + ",userAccount=" + userAccount);
		
		Document xmldom = commonUtil.convertStringToDocument(bodyData != null ? bodyData : "");
		String url = xmldom.getElementsByTagName("URL").item(0).getTextContent();
		String folderPath = url.split("/")[0];
		String uidStr = url.split("/")[1];
		long uid = Long.parseLong(uidStr);
		
		// 넘어온 folderPath가 보낸편지함이 아닐 경우
		if (!folderPath.equals(ezEmailUtil.getSentFolderId(locale))) {
			logger.debug(egovMessageSource.getMessage("ezEmail.lhm22", locale));
			logger.debug("mailCancelSend ended.");
			return egovMessageSource.getMessage("ezEmail.lhm22", locale);
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
					userAccount, password, egovMessageSource, locale, ezEmailUtil);
			
			Folder folder = ia.getFolder(ezEmailUtil.getSentFolderId(locale));
			if (folder != null){
				folder.open(Folder.READ_ONLY);
				Message message = ((IMAPFolder)folder).getMessageByUID(uid);

				if (message == null) {
					logger.debug(egovMessageSource.getMessage("ezEmail.lhm23", locale));
					logger.debug("mailCancelSend ended.");
					return egovMessageSource.getMessage("ezEmail.lhm23", locale);
				}

				// 메시지의 sender가 user의 계정(또는 user의 alias mail)인지 검사 > 아래 real address로 변경하여 주석처리
				//String from = ((InternetAddress)message.getFrom()[0]).getAddress();
				
				// 사용자의 real address인 X-JMocha-Disp-Noti-To 헤더 값으로 처리
				String from =  message.getHeader("X-JMocha-Disp-Noti-To")[0];
				logger.debug("from=" + from);

				List<String[]> aliasAddressList = ezEmailService.getAliasAddress(mailId, loginInfo.getTenantId(), "YES", "NO");

				boolean isUserFrom = false;
				for (String[] address : aliasAddressList) {
					if (address[0].equals(from)) {
						isUserFrom = true;
						break;
					}
				}

				if (!isUserFrom) {
					logger.debug(egovMessageSource.getMessage("ezEmail.lhm24", locale));
					logger.debug("mailCancelSend ended.");
					return egovMessageSource.getMessage("ezEmail.lhm24", locale);
				}


				// get arrAddress
				List<String> addressList = new ArrayList<String>();

				if (pEachCancel.equals("NO")) {
					Address[] addresses = message.getAllRecipients();

					for (Address address : addresses) {
						addressList.add(((InternetAddress)address).getAddress());
					}
				} else {
					String[] arrAddress = pEachCancel.split("\\|!\\|");

					for (String address : arrAddress) {
						addressList.add(address);
					}
				}

				// get innerAddresses(내부사용자)
				List<String> innerDomainList = ezEmailUtil.getInnerDomain(loginInfo.getTenantId());
				List<String> innerAddresses = new ArrayList<String>();

				for (String address : addressList) {
					int index = address.indexOf("@");
					String domain = "";

					if (index > -1) {
						domain = address.substring(index + 1);
					}

					for (int i = 0; i < innerDomainList.size(); i++) {
						if (domain.equals(innerDomainList.get(i))) {
							innerAddresses.add(address);
							break;
						}
					}
				}

				// 내부사용자 없을 경우 리턴
				if (innerAddresses.size() == 0) {
					logger.debug(egovMessageSource.getMessage("ezEmail.lhm27", locale));
					logger.debug("mailCancelSend ended.");
					return egovMessageSource.getMessage("ezEmail.lhm27", locale);
				}

				String messageId = ((MimeMessage)message).getMessageID();
				String subject = message.getSubject();

				ezEmailUserAdminService.setMailCancelSend(loginInfo.getTenantId(), loginInfo.getPrimary(), messageId, mailId, subject, innerAddresses, locale, pGubun);

				folder.close(true);
			}
			
		} catch (MessagingException e) {
			logger.error(e.getMessage(), e);
		} finally {
			if (ia != null) {
				ia.close();
			}
		}
		
		logger.debug("mailCancelSend ended.");
		
		return "OK";
	}
	
	@RequestMapping(value="/ezEmail/readExternalRecipient.do", method = RequestMethod.GET)
	@ResponseBody
	public String readExternalRecipient(Model model, HttpServletRequest request) throws Exception {
		logger.debug("readExternalRecipient started.");
		
		// 암호화된 수신자 정보
		String recipientReadKey = request.getParameter("key");
		
		if (recipientReadKey == null) {
			recipientReadKey = "";
		}
		
		logger.debug("encrypted recipientReadKey=" + recipientReadKey);
		
		// 복호화: 발신자/메세지ID/수신자/수신자이름
		recipientReadKey = egovFileScrty.decryptAES(recipientReadKey);
		logger.debug("decrypted recipientReadKey=" + recipientReadKey);
		
		String[] readInfoArray = recipientReadKey.split("/", -1);
		
		if (readInfoArray.length != 4) {
			logger.debug("readInfoArray length is not 4");
			logger.debug("readExternalRecipient ended.");
			
			return "";
		}
		
		// 파라미터 설정
		String senderAddress = readInfoArray[0];
		String messageId = readInfoArray[1];
		String readerAddress = readInfoArray[2];
		String readerName = readInfoArray[3];
				
		logger.debug("senderAddress=" + senderAddress);
		logger.debug("messageId=" + messageId);
		logger.debug("readerAddress=" + readerAddress);
		logger.debug("readerName=" + readerName);
		
		List<String> senderAddressList = new ArrayList<String>();
		senderAddressList.add(senderAddress);
				
		// alias address인 경우 real address로 바꾼다.
		senderAddressList = getMember(senderAddressList);
		
		if (senderAddressList.size() == 1) {
			senderAddress = (String)senderAddressList.get(0);
			
			logger.debug("Real senderAddress=" + senderAddress);
		}
		
		// 수신 여부를 체크하기 위해서 두개만 넣음 (getMailReadList 스펙)
		StringBuilder inputParams = new StringBuilder();
		inputParams.append("userId=").append(URLEncoder.encode(senderAddress, "UTF-8"))
			.append("&messageId=").append(URLEncoder.encode(messageId, "UTF-8"));
		
		logger.debug("getMailReadList inputParams=" + inputParams);
		
		// 수신자 리스트 목록 API 호출
		String checkResultJsonStr = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaEzEmail/getMailReadList", inputParams.toString());
		
		JSONParser jsonParser = new JSONParser();
		JSONObject checkResultJson = (JSONObject) jsonParser.parse(checkResultJsonStr);
		JSONArray readList = (JSONArray) checkResultJson.get("result");
		JSONObject readInfoJson;
		
		// 수신을 이미 했다면 return
		for (Object readInfoObject : readList) {
			readInfoJson = (JSONObject) readInfoObject;
		
			if (readerAddress.equals(readInfoJson.get("readerEmail"))) {
				logger.debug("setMailReadInfo skip.");
				logger.debug("readExternalRecipient ended.");
				return "";
			}
		}
		
		// 수신 확인 API 호출
		inputParams.append("&readerEmail=").append(URLEncoder.encode(readerAddress, "UTF-8"))
			.append("&readerName=").append(URLEncoder.encode(readerName, "UTF-8"));
		
		String resultJsonStr = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaEzEmail/setMailReadInfo", inputParams.toString());

		logger.debug("result="+resultJsonStr);		
		logger.debug("readExternalRecipient ended.");
		return "";
	}
	
	public List<String> getMember(List<String> addressList) {
		List<String> resultList = new ArrayList<String>();
		
		try {
			String inputParams = null;
			
			for (String address : addressList) {
				if (inputParams == null) {
					inputParams = "address=" + URLEncoder.encode(address, "UTF-8");
				} else {
					inputParams += "&address=" + URLEncoder.encode(address, "UTF-8");
				}
			}
			
			logger.debug("inputParams=" + inputParams);
			
			String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaAccess/getAliasMail", inputParams);
			
			JSONParser parser = new JSONParser();
			JSONObject object = (JSONObject)parser.parse(strJson);
	        
	        if (object.get("resultCode").equals("OK")) {
	        	JSONArray array = (JSONArray)object.get("result");
	        	
	        	if (array != null) { 
	        		int len = array.size();
	        		for (int i=0; i<len; i++){ 
	        			resultList.add((String)array.get(i));
	        		} 
	        	} 
	        	
	        }
        
		} catch (ParseException e) {
			logger.error(e.getMessage(), e);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		
		return resultList;
	}
	
}
