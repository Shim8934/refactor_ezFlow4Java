package egovframework.ezMobile.ezEmail.web;

import java.net.URI;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;
import java.util.UUID;

import javax.annotation.Resource;
import javax.mail.Address;
import javax.mail.Flags;
import javax.mail.Folder;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.InternetHeaders;
import javax.mail.internet.MimeMessage;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import com.google.gson.Gson;
import com.sun.mail.dsn.DispositionNotification;
import com.sun.mail.dsn.MultipartReport;
import com.sun.mail.imap.IMAPFolder;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.logic.IMAPAccess;
import egovframework.ezEKP.ezEmail.logic.SMTPAccess;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezEmail.util.EzEmailUtil;
import egovframework.ezEKP.ezEmail.vo.MailCancelVO;
import egovframework.ezEKP.ezEmail.vo.MailReadVO;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.ezMobile.ezOption.service.MOptionService;
import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovStringUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

/** 
 * @Description [Controller] 메일
 * @author 오픈솔루션팀 이효민
 * @Modification Information
 *
 *    수정일        수정자         수정내용
 *    ----------    ------    -------------------
 *    2017.06.13    이효민    신규작성
 *
 * @see
 */

@Controller
public class MEmailController extends EgovFileMngUtil {
	
	private static final Logger logger = LoggerFactory.getLogger(MEmailController.class);
	
	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;
	
	@Resource(name="crypto") 
	private EgovFileScrty egovFileScrty;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Resource(name="EzCommonService")
	private EzCommonService ezCommonService;
	
	@Autowired
	private EzEmailService ezEmailService;
	
	@Autowired
	private EzOrganAdminService ezOrganAdminService;
	
	@Resource(name="MOptionService")
	private MOptionService mOptionService;
	
	@Autowired
	private EzEmailUtil ezEmailUtil;
	
	/**
	 * 모바일 메인 > 편지함 리스트 정보 표출 함수
	 */
	@RequestMapping(value = "/mobile/ezEmail/getFolderList.do")
	public String getFolderList(HttpServletRequest request, ModelMap modelMap, @CookieValue("loginCookie") String loginCookie, HttpServletResponse response, 
								Locale locale) throws Exception {
		logger.debug("getFolderList started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String folderId = "";
		
		if (request.getParameter("FolderId") != null) {
		folderId = request.getParameter("FolderId");
		}
		
		String gwServerUrl = config.getProperty("config.mobileGwServerURL");		
		String url = gwServerUrl + "/mobile/ezemail/folders-list/users/" + userInfo.getId();
				
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());

		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("folderId", folderId);
		//folderId가 ""이면 전체 폴더 조회. 있으면 하위폴더 조회 ex)INBOX -> 받은 편지함 하위 폴더 전체 리턴.
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp = new JSONParser();

		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		
		String status = resultBody.get("status").toString();
		
		JSONArray mailFolderList = new JSONArray();
		
		if (status.equals("ok")) {
			mailFolderList = (JSONArray) resultBody.get("data");
			
			modelMap.addAttribute("folderListCnt", mailFolderList.size());
			modelMap.addAttribute("folderList", mailFolderList);
		}

		
		System.out.println(mailFolderList);			
		logger.debug("getFolderList ended.");
		
		return "mobile/ezEmail/mMailFolderList";
	}
	
	/**
	 * 모바일 편지함 > 편지함 정보 표출 함수
	 */
	@RequestMapping(value = "/mobile/ezEmail/mailMain.do")
	public String mailMain(HttpServletRequest request, ModelMap modelMap, @CookieValue("loginCookie") String loginCookie, HttpServletResponse response, Locale locale) throws Exception {
		logger.debug("mailMain started.");
		
		String folderId = "INBOX";
		String start = "0";
		String end = "9";
		String search = "";
		String filter = "";
		int unReadCount = 0;
		//search Parameter에는 SUBJECT=검색어 라고 하면 제목으로 검색
		//filter에는  isUnreadOnly(읽지 않은 메일), isImportantOnly(중요 메일) 중 1개만 전달이 가능하다.
		if (request.getParameter("FolderId") != null) {
			folderId = request.getParameter("FolderId");
		}
		
		if (request.getParameter("start") != null) {
			start = request.getParameter("start");
		}
		
		if (request.getParameter("end") != null) {
			end = request.getParameter("end");
		}
		
		if (request.getParameter("search") != null) {
			search = request.getParameter("search");
		}
		
		if (request.getParameter("filter") != null) {
			filter = request.getParameter("filter");
		}
		
		logger.debug("getMailList started.");
		
		logger.debug("folderId = " + folderId + "start = " + start + "end = " + end 
				+ "search = " + search + "filter = " + filter);
		
		String gwServerUrl = config.getProperty("config.mobileGwServerURL");		
		String url = gwServerUrl + "/mobile/ezemail/folders/" + folderId + "/mails/users/rkd1395";
				
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
			
		HttpEntity<?> entity = new HttpEntity<>(headers);
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("start", start)
				.queryParam("end", end)
				.queryParam("search", search)
				.queryParam("filter", filter)
				.queryParam("folderId4sub", filter);
		
		//search Parameter에는 SUBJECT=검색어 라고 하면 제목으로 검색
		//filter에는  isUnreadOnly(읽지 않은 메일), isImportantOnly(중요 메일) 중 1개만 전달이 가능하다.
		
		RestTemplate rest = new RestTemplate();

		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);

		JSONParser jp = new JSONParser();
		
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());

		String status = resultBody.get("status").toString();

		JSONObject data = new JSONObject();
		JSONArray messages = new JSONArray();
		int unreadCount = 0;
		JSONArray folderList = new JSONArray();
	
		if (status.equals("ok")) {
			
			data = (JSONObject) resultBody.get("data");
			messages = (JSONArray) data.get("messageJsonArray");
			unreadCount = Integer.parseInt(data.get("unreadCount").toString());
			folderList = (JSONArray) data.get("folderList");
			String title = (String) data.get("folderId");
			
			modelMap.addAttribute("MessagesListCnt", messages.size());
			modelMap.addAttribute("MessagesList", messages);
			modelMap.addAttribute("unReadCount", unreadCount);
			modelMap.addAttribute("folderList", folderList);
			modelMap.addAttribute("title", title);
			
		}
						
		logger.debug("getMailList ended.");
		
		return "/mobile/ezEmail/mMailMain";
	}
	
	@RequestMapping(value="/mobile/ezEmail/mailGetList.do",method=RequestMethod.GET, produces="application/json; charset=UTF-8")
	@ResponseBody
	public JSONObject getMobileMailList(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie,@RequestBody String bodyData, Locale locale, ModelMap modelMap) throws Exception {
		
		String folderId = "INBOX";
		String start = "0";
		String end = "9";
		String search = "";
		String filter = "";
	
		//search Parameter에는 SUBJECT=검색어 라고 하면 제목으로 검색
		//filter에는  isUnreadOnly(읽지 않은 메일), isImportantOnly(중요 메일) 중 1개만 전달이 가능하다.
		if (request.getParameter("FolderId") != null) {
			folderId = request.getParameter("FolderId");
		}
		
		if (request.getParameter("start") != null) {
			start = request.getParameter("start");
		}
		
		if (request.getParameter("end") != null) {
			end = request.getParameter("end");
		}
		
		if (request.getParameter("search") != null) {
			search = request.getParameter("search");
		}
		
		if (request.getParameter("filter") != null) {
			filter = request.getParameter("filter");
		}
		
		logger.debug("getMailList started.");
		
		logger.debug("folderId = " + folderId + "start = " + start + "end = " + end 
				+ "search = " + search + "filter = " + filter);
		
		String gwServerUrl = config.getProperty("config.mobileGwServerURL");		
		String url = gwServerUrl + "/mobile/ezemail/folders/" + folderId + "/mails/users/rkd1395";
				
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
			
		HttpEntity<?> entity = new HttpEntity<>(headers);
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("start", start)
				.queryParam("end", end)
				.queryParam("search", search)
				.queryParam("filter", filter);
		
		//search Parameter에는 SUBJECT=검색어 라고 하면 제목으로 검색
		//filter에는  isUnreadOnly(읽지 않은 메일), isImportantOnly(중요 메일) 중 1개만 전달이 가능하다.
		
		RestTemplate rest = new RestTemplate();

		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);

		JSONParser jp = new JSONParser();
		
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());

		String status = resultBody.get("status").toString();
		
		JSONObject data = new JSONObject();
		
		JSONArray messages = new JSONArray();
		
		int unReadCount = 0;
		if (status.equals("ok")) {
			data = (JSONObject) resultBody.get("data");
			unReadCount = Integer.parseInt(data.get("unreadCount").toString());
			messages = (JSONArray) data.get("messageJsonArray");
			modelMap.addAttribute("MessagesListCnt", messages.size());
			modelMap.addAttribute("MessagesList", messages);
		}
				
		modelMap.addAttribute("MessageList", messages);		
		
		logger.debug("getMailList ended.");
		JSONObject MessageAndCount = new JSONObject();
		MessageAndCount.put("messages", messages);
		MessageAndCount.put("unReadCount", unReadCount);
		MessageAndCount.put("folderId", folderId);
		
		return MessageAndCount;
	}
	
	@RequestMapping(value="/mobile/ezEmail/mailMoveMessage.do",method=RequestMethod.GET ,produces="text/plain;charset=utf-8")
	@ResponseBody
	public String mailMoveMessage(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, @RequestBody String bodyData, 
			Locale locale, Model model) throws Exception {
		logger.debug("mailMoveMessage started.");
		
		String returnValue = "ERROR";

		String gwServerUrl = config.getProperty("config.mobileGwServerURL");		
		String url = gwServerUrl + "/mobile/ezemail/folders/INBOX/mails/221/move/users/rkd1395";
				
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());

//		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
//				.queryParam("folderId", "INBOX");
		
		URI uri = URI.create(url);
		
		RestTemplate rest = new RestTemplate();
		
		JSONObject jsonObject = new JSONObject();
		jsonObject.put("mfolderId", "보낸 편지함");

	    HttpEntity<JSONObject> entity = new HttpEntity(jsonObject, headers);

	    ResponseEntity<String> responseEntity = rest.exchange(uri, HttpMethod.PUT, entity, String.class);
		
	    JSONParser jp = new JSONParser();
	    
		System.out.println(responseEntity.getBody());
		
		JSONObject resultBody = (JSONObject) jp.parse(responseEntity.getBody());
				
		model.addAttribute("returnValue", returnValue);		
						
		logger.debug("mailMoveCopyMessage ended. returnVal = " + returnValue);
		
		return resultBody.toJSONString();
	}
	
	@RequestMapping(value="/mobile/ezEmail/mailCopyMessage.do",method=RequestMethod.GET , produces="text/plain;charset=utf-8")
	@ResponseBody
	public String mailCopyMessage(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, Locale locale, Model model) throws Exception {
		logger.debug("mailCopyMessage started.");
		
		String gwServerUrl = config.getProperty("config.mobileGwServerURL");		
		String url = gwServerUrl + "/mobile/ezemail/folders/INBOX/mails/223/copy/users/rkd1395";
				
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());	

//		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
//				.queryParam("folderId", "INBOX");
		
		URI uri = URI.create(url);
		
		JSONObject jsonObject = new JSONObject();
		jsonObject.put("toFolderID", "보낸 편지함");
		
		HttpEntity<JSONObject> entity = new HttpEntity(jsonObject, headers);
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> responseEntity = rest.exchange(uri, HttpMethod.POST, entity, String.class);
		
		JSONParser jp = new JSONParser();
		
		JSONObject resultBody = (JSONObject) jp.parse(responseEntity.getBody());
		
		model.addAttribute("mailFolderList", resultBody);		
						
		logger.debug("mailMoveCopyMessage ended. returnVal = " + resultBody);
		
		return resultBody.toJSONString();
	}
	
	@RequestMapping(value="/mobile/ezEmail/mailDownloadFile.do",method=RequestMethod.GET , produces="text/plain;charset=utf-8")
	@ResponseBody
	public String mailDownloadFile(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, Locale locale, Model model) throws Exception {
		logger.debug("mailDownloadFile started.");
		
		String gwServerUrl = config.getProperty("config.mobileGwServerURL");		
		String url = gwServerUrl + "/mobile/ezemail/folders/INBOX/mails/230/attach/1/users/rkd1395";
				
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
//		headers.setAccept(Arrays.asList(MediaType.APPLICATION_OCTET_STREAM));
		headers.set("Content-Type","application/json");
		headers.set("x-user-host", request.getServerName());

		HttpEntity<?> entity = new HttpEntity<>(headers);

		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("filename", "antlr-2.7.7.jar");

		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp = new JSONParser();
		
//		JSONObject resultBody = result.getBody();
//		
//		model.addAttribute("download", resultBody);		
//						
//		logger.debug("mailDownloadFile ended. returnVal data = " + resultBody.get("data"));
//		
		return "승공";
	}
	
	@RequestMapping(value = "/mobile/ezEmail/getSignList.do", produces = "text/plain;charset=utf-8")
	@ResponseBody
	public String getSignList(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie, HttpServletResponse response, Locale locale) throws Exception {
		logger.debug("getFolderList started.");
		
		String userId = "rkd1395";
		
		String gwServerUrl = config.getProperty("config.mobileGwServerURL");		
		String url = gwServerUrl + "/mobile/ezemail/sign/users/" + userId;
				
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());		

		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url);
//				.queryParam("folderId", "INBOX");
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		//signList가 1개도 없으면  null

		JSONParser jp = new JSONParser();
		
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		
		model.addAttribute("mailSignList", resultBody);		
		
		logger.debug("getFolderList ended.");

		return resultBody.toJSONString();
	}
	
	@RequestMapping(value="/mobile/ezEmail/mailDelete.do",method=RequestMethod.GET, produces="text/plain;charset=utf-8")
	@ResponseBody
	public String mailDelete(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, @RequestBody String bodyData, 
			Locale locale, Model model) throws Exception {
		logger.debug("mailDeleteMessage started.");
		
		String gwServerUrl = config.getProperty("config.mobileGwServerURL");		
		String url = gwServerUrl + "/mobile/ezemail/folders/INBOX/mails/224/users/rkd1395";
				
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());	
		
		URI uri = URI.create(url);
		
		JSONObject jsonobject = new JSONObject();
		
		HttpEntity<JSONObject> entity = new HttpEntity(jsonobject, headers);
//		HttpEntity entity = new HttpEntity(headers);
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> responseEntity = rest.exchange(uri, HttpMethod.DELETE, entity, String.class);
		
		JSONParser jp = new JSONParser();
		
		JSONObject resultBody = (JSONObject) jp.parse(responseEntity.getBody());
		
		model.addAttribute("mailFolderList", resultBody);		
						
		logger.debug("mailDeleteMessage ended.");
		
		return resultBody.toJSONString();
	}
	
	@RequestMapping(value="/mobile/ezEmail/mailMailList.do",method=RequestMethod.GET, produces="text/plain;charset=utf-8")
	@ResponseBody
	public String mailMailList(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, @RequestBody String bodyData, 
			Locale locale, Model model) throws Exception {
		logger.debug("mailDeleteMessage started.");
		
		String gwServerUrl = config.getProperty("config.mobileGwServerURL");		
		String url = gwServerUrl + "/mobile/ezemail/main/mail-list/users/"+"rkd1395";
				
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());	
		
		URI uri = URI.create(url);
		
		JSONObject jsonobject = new JSONObject();
		
		HttpEntity<JSONObject> entity = new HttpEntity(jsonobject, headers);
//		HttpEntity entity = new HttpEntity(headers);
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> responseEntity = rest.exchange(uri, HttpMethod.GET, entity, String.class);
		
		JSONParser jp = new JSONParser();
		
		JSONObject resultBody = (JSONObject) jp.parse(responseEntity.getBody());
		
		model.addAttribute("mailFolderList", resultBody);		
						
		logger.debug("mailDeleteMessage ended.");
		
		return resultBody.toJSONString();
	}
	
	@RequestMapping(value="/mobile/ezEmail/mailRead.do",method=RequestMethod.GET, produces="text/plain;charset=utf-8")
	@ResponseBody
	public String mobileReadMail(@CookieValue("loginCookie") String loginCookie, Locale locale, HttpServletRequest request, Model model) throws Exception {
		logger.debug("mailDeleteMessage started.");
		
		String folderId = "";
		String messageId = "";
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		if (request.getParameter("folderId") != null) {
			folderId = request.getParameter("folderId");
		} else {
			return "no folderId";
		}
		
		if (request.getParameter("messageId") != null) {
			messageId = request.getParameter("messageId");
		} else {
			return "no messageId";
		}

		logger.debug("folderId = " + folderId + ", messageId = " + messageId);
		
		String gwServerUrl = config.getProperty("config.mobileGwServerURL");		
		String url = gwServerUrl + "/mobile/ezemail/folders/" + folderId + "/mails/" + messageId + "/users/" + userInfo.getId();
				
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());	
		
		URI uri = URI.create(url);
		
		JSONObject jsonobject = new JSONObject();
		
		HttpEntity<JSONObject> entity = new HttpEntity(jsonobject, headers);
//		HttpEntity entity = new HttpEntity(headers);
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> responseEntity = rest.exchange(uri, HttpMethod.GET, entity, String.class);
		
		JSONParser jp = new JSONParser();
		
		JSONObject resultBody = (JSONObject) jp.parse(responseEntity.getBody());
		
		model.addAttribute("mailFolderList", resultBody);		
						
		logger.debug("mailDeleteMessage ended.");
		
		return resultBody.toJSONString();
	
	}
	
	@RequestMapping(value="/mobile/ezEmail/mailReadContent.do")
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
						userEmail, password, egovMessageSource, locale);
				
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
						bodyInfoList = ezEmailUtil.getBodyInfo(message, folderPath, uid, -1, null, false, locale);
						double size = Double.parseDouble(bodyInfoList.get(2));
						String strSize = ezEmailUtil.getSizeWithUnit(size);
						pAttachListHtmlSub = " - <b>" + bodyInfoList.get(3) + egovMessageSource.getMessage("ezEmail.t180", locale) + "</b>(" + strSize + ")";
						
						if (!folderPath.equals(egovMessageSource.getMessage("ezEmail.t99000026", locale))) {
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
								
								processAutoMDN(sa, message, userEmail, userVO.getDisplayName());
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
		
		model.addAttribute("htmlBody", bodyInfoList.get(0));
		model.addAttribute("pAttachListHtml", bodyInfoList.get(1));
		model.addAttribute("pAttachListHtmlSub", pAttachListHtmlSub);
		model.addAttribute("isAttach", bodyInfoList.get(4));
		model.addAttribute("url", url);
		model.addAttribute("rejectKeyWord", rejectKeyWord);
		
		logger.debug("readMailContent ended.");
		
		return "ezEmail/mailReadContent";
	}

	@RequestMapping(value="/mobile/ezEmail/mailGetReceiveList.do")
		public String mailGetReceiveList(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, @RequestBody String bodyData) throws Exception{
			//차후에 StringBuilder 모두 삭제 예정
			logger.debug("mailGetReceiveList started.");
			bodyData = URLDecoder.decode(bodyData,"UTF-8");
			logger.debug("bodyData=" + bodyData);
			
			List<String> userInfo = commonUtil.getUserIdAndPassword(loginCookie);
			String password  = userInfo.get(1);
			
			LoginVO loginInfo = commonUtil.userInfo(loginCookie);
			
			String domainName = ezCommonService.getTenantConfig("DomainName", loginInfo.getTenantId());
			String userEmail = loginInfo.getId() + "@" + domainName;
			logger.debug("userEmail=" + userEmail);
			
			String returnValue = "";
			
			String uidStr = bodyData.split("=")[1];
			uidStr = uidStr.split("/")[1];
			long uid = Long.parseLong(uidStr); 
			JSONObject readJSON = new JSONObject();
	
			
			IMAPAccess ia = null;
			try {
				ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
						userEmail, password, egovMessageSource, locale);
				
				Folder folder = ia.getFolder(egovMessageSource.getMessage("ezEmail.t99000026", locale));
				folder.open(Folder.READ_ONLY);
				Message message = ((IMAPFolder)folder).getMessageByUID(uid);
				
				StringBuilder sb = new StringBuilder();
				
				StringBuilder unreadSb = new StringBuilder();
				JSONObject unreadJSON = new JSONObject();
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
					
					//get aliasAddressList from recipients
					List<String> addressList = new ArrayList<String>();
					for (Address address : addresses) {
						if (((InternetAddress)address).getAddress() != null) {
							addressList.add(((InternetAddress)address).getAddress());
						}
					}
					Map<String, String> aliasAddressList = ezEmailService.getAliasAddressMap(addressList, loginInfo.getTenantId());
					
					List<String> tempMailList = new ArrayList<String>();
					
					//recipients from email message
					for (Address address : addresses) {
						String email = ((InternetAddress)address).getAddress();
						String name = ((InternetAddress)address).getPersonal() == null ? 
								((InternetAddress)address).getAddress() : ((InternetAddress)address).getPersonal();
						if (email != null) {
							StringBuilder tempSb = new StringBuilder();
							JSONObject tempJSON = new JSONObject();
							tempSb.append("<ROW>");
							tempJSON.put("READEREMAIL",email);
							tempSb.append("<READEREMAIL><![CDATA[" + email + "]]></READEREMAIL>");
							tempJSON.put("READERNAME",name);
							tempSb.append("<READERNAME><![CDATA[" + name + "]]></READERNAME>");
							
							if (aliasAddressList.containsKey(email)) { //Alias주소인 경우
								email = aliasAddressList.get(email);
							}
							
							String readDate = "UNREAD";
							for (MailReadVO vo : readList) {
								if (vo.getReaderEmail().equals(email)) {
									readDate = commonUtil.getDateStringInUTC(vo.getReadDate(), loginInfo.getOffset(), false);
									break;
								}
							}
							tempSb.append("<READDATE><![CDATA[" + readDate + "]]></READDATE>");
							tempJSON.put("READDATE",readDate);
							
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
							tempJSON.put("CANCEL",status);
	
							tempSb.append("</ROW>");
	
							if (readDate.equals("UNREAD")) {
								unreadSb.append(tempSb.toString());
								unreadJSON.put("tempJSON", tempJSON);
							} else {
								sb.append(tempSb.toString());
								readJSON.put("tempJSON", tempJSON);
							}
							
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
							readJSON.put("READEREMAIL", readerEmail);
							sb.append("<READERNAME><![CDATA[" + readerName + "]]></READERNAME>");
							readJSON.put("READERNAME", readerName);
							vo.setReadDate(commonUtil.getDateStringInUTC(vo.getReadDate(), loginInfo.getOffset(), false));
							sb.append("<READDATE><![CDATA[" + vo.getReadDate() + "]]></READDATE>");
							readJSON.put("READDATE", vo.getReadDate());
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
							readJSON.put("CANCEL", status);
							sb.append("</ROW>");
							
							tempMailList.add(readerEmail);
						}
					}
					
					//cancelList
					for (MailCancelVO vo : cancelList) {
						if (!tempMailList.contains(vo.getReaderEmail())) {
							String readerEmail = vo.getReaderEmail();
							
							unreadSb.append("<ROW>");
							unreadSb.append("<READEREMAIL><![CDATA[" + readerEmail + "]]></READEREMAIL>");
							unreadJSON.put("READEREMAIL", readerEmail);
							unreadSb.append("<READERNAME><![CDATA[" + readerEmail + "]]></READERNAME>");
							unreadJSON.put("READERNAME", readerEmail);
							unreadSb.append("<READDATE><![CDATA[UNREAD]]></READDATE>");
							unreadJSON.put("READDATE", "UNREAD");
							
							String status = "";
							if (vo.getStatus() != null && !vo.getStatus().equals("")) {
								status = vo.getStatus();
							} else {
								status = "0";
							}
							unreadSb.append("<CANCEL><![CDATA[" + status + "]]></CANCEL>");
							unreadJSON.put("CANCEL", status);
							unreadSb.append("</ROW>");
						}
					}
					
					sb.append(unreadSb.toString());
					readJSON.put("unreadJSON",unreadJSON);
					sb.append("<SUBJECT><![CDATA[" + message.getSubject() + "]]></SUBJECT>");
					readJSON.put("SUBJECT", message.getSubject());
					
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
			model.addAttribute("readJSON", readJSON);
			return "json";
		}
	
	@RequestMapping(value="/mobile/ezEmail/mMailWrite.do")
	public String mailWrite(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, Locale locale, Model model, @RequestBody String bodyData) throws Exception{
		
		MCommonVO info = mOptionService.commonInfo(request.getServerName(), "rkd1395");
		String domainName = ezCommonService.getTenantConfig("DomainName", info.getTenantId());
		String userEmail = info.getUserId() + "@" + domainName;
		
		String gwServerUrl = config.getProperty("config.mobileGwServerURL");		
		String url = gwServerUrl + "/mobile/ezemail/sign/users/rkd1395";
				
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());		

		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url);
//				.queryParam("folderId", "INBOX");
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<JSONObject> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, JSONObject.class);
		//signList가 1개도 없으면  null

		JSONObject resultBody = result.getBody();
		
		model.addAttribute("mailSignList", resultBody);		
		model.addAttribute("sender", userEmail);

		return "/mobile/ezEmail/mMailWrite";
	}
	
	@RequestMapping(value="/mobile/ezEmail/mailSetStatus.do",method=RequestMethod.GET ,produces="text/plain;charset=utf-8")
	@ResponseBody
	public String mailSetReadStatus(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, @RequestBody String bodyData, 
			Locale locale, Model model) throws Exception {
		
		String gwServerUrl = config.getProperty("config.mobileGwServerURL");		
		String url = gwServerUrl + "/mobile/ezemail/folders/INBOX/mails/222/users/rkd1395";
				
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());	
		
		URI uri = URI.create(url);
		
		JSONObject jsonObject = new JSONObject();
		jsonObject.put("isRead", "TRUE");
		//TRUE면 읽은 상태 FALSE면 읽지 않은 상태로 변경.
		
		HttpEntity<JSONObject> entity = new HttpEntity(jsonObject, headers);
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> responseEntity = rest.exchange(uri, HttpMethod.PUT, entity, String.class);
		
		JSONParser jp = new JSONParser();
		
		JSONObject resultBody = (JSONObject) jp.parse(responseEntity.getBody());
		
		model.addAttribute("mailFolderList", resultBody);		
						
		logger.debug("mailMoveCopyMessage ended. returnVal = " + resultBody);
		
		return resultBody.toJSONString();

	}
	
	@RequestMapping(value="/mobile/ezEmail/mailSendMessage.do",method=RequestMethod.POST ,produces="text/plain;charset=utf-8")
	@ResponseBody
	public String mailSendMessage(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, @RequestBody JSONObject InputJsonObject, 
			Locale locale, Model model) throws Exception {
		logger.debug("mailSend started");
		String gwServerUrl = config.getProperty("config.mobileGwServerURL");		
		String url = gwServerUrl + "/mobile/ezemail/mail-send/users/rkd1395";
		logger.debug("InputJsonObject : " + InputJsonObject);		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());	
		
		URI uri = URI.create(url);
		
		JSONObject jsonObject = new JSONObject();
		
		jsonObject.put("subject", InputJsonObject.get("subject"));
		jsonObject.put("to", InputJsonObject.get("to"));
		jsonObject.put("cc", InputJsonObject.get("cc"));
		jsonObject.put("bcc", InputJsonObject.get("bcc"));
		jsonObject.put("textbody", InputJsonObject.get("textbody"));
		jsonObject.put("from", InputJsonObject.get("from"));
//		jsonObject.put("displayName", "'강민석' <rkd1395@svn.opensol2014.com>");
		jsonObject.put("stateName", UUID.randomUUID().toString());
		//jsonObject.put("charsert", "");
		//jsonObject.put("htmlbody", "");
		
		HttpEntity<JSONObject> entity = new HttpEntity(jsonObject, headers);
		logger.debug("mailSend jsonObject = " + jsonObject.toJSONString());
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> responseEntity = rest.exchange(uri, HttpMethod.POST, entity, String.class);
		
		JSONParser jp = new JSONParser();
		
		JSONObject resultBody = (JSONObject) jp.parse(responseEntity.getBody());
								
		logger.debug("mailSend ended. returnVal = " + resultBody);
		
		return resultBody.toJSONString();

	}
	
	@RequestMapping(value="/mobile/ezEmail/mailSaveMessage.do",method=RequestMethod.POST ,produces="text/plain;charset=utf-8")
	@ResponseBody
	public String mailSaveMessage(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, @RequestBody JSONObject InputJsonObject, 
			Locale locale, Model model) throws Exception {
		
		logger.debug("mailsave started");
		String gwServerUrl = config.getProperty("config.mobileGwServerURL");		
		String url = gwServerUrl + "/mobile/ezemail/mail-save/users/rkd1395";
				
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());	
		
		URI uri = URI.create(url);
		
		JSONObject jsonObject = new JSONObject();
		
		jsonObject.put("subject", InputJsonObject.get("subject"));
		jsonObject.put("to", InputJsonObject.get("to"));
		jsonObject.put("cc", InputJsonObject.get("cc"));
		jsonObject.put("bcc", InputJsonObject.get("bcc"));
		jsonObject.put("textbody", InputJsonObject.get("textbody"));
		jsonObject.put("from", InputJsonObject.get("from"));
		//jsonObject.put("displayName", "'강민석' <rkd1395@svn.opensol2014.com>");
		jsonObject.put("stateName", UUID.randomUUID().toString());
		//jsonObject.put("charsert", "");
		//jsonObject.put("htmlbody", "");
		
		HttpEntity<JSONObject> entity = new HttpEntity(jsonObject, headers);
		logger.debug("mailSend jsonObject = " + jsonObject.toJSONString());
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> responseEntity = rest.exchange(uri, HttpMethod.POST, entity, String.class);
		
		JSONParser jp = new JSONParser();
		
		JSONObject resultBody = (JSONObject) jp.parse(responseEntity.getBody());
								
		logger.debug("mailsave ended. returnVal = " + resultBody);
		
		return resultBody.toJSONString();

	}
	
	private String getReceiverHTML(String name, String address){
		return "<span style='cursor:pointer' title='" + (address==null?"":EgovStringUtil.getSpclStrCnvr(address)) + "' onclick='show_personinfo(\"" + address + "\")'>" + (name==null?"":EgovStringUtil.getSpclStrCnvr(name)) + "</span>";
	}
	
	private void processAutoMDN(SMTPAccess sa, Message message, String myEmailAddress, String myName) {
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
			String myEmailDomain = myEmailAddress.substring(myEmailAddress.indexOf("@") + 1);
			
			logger.debug("fromEmailDomain=" + fromEmailDomain + ",myEmailDomain=" + myEmailDomain);
			
			if (!fromEmailDomain.equalsIgnoreCase(myEmailDomain)) {
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
	
}