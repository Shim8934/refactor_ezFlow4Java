package egovframework.ezEKP.ezEmail.web;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.charset.Charset;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;
import java.util.Set;
import java.util.TimeZone;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;
import java.util.zip.ZipOutputStream;

import javax.annotation.Resource;
import javax.mail.Flags;
import javax.mail.Flags.Flag;
import javax.mail.Folder;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.websocket.OnClose;
import javax.websocket.OnError;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.PathParam;
import javax.websocket.server.ServerEndpoint;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.w3c.dom.Document;

import com.sun.mail.imap.IMAPFolder;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezAddress.service.EzAddressService;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.logic.IMAPAccess;
import egovframework.ezEKP.ezEmail.logic.SMTPAccess;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezEmail.util.EzEmailUtil;
import egovframework.ezEKP.ezEmail.vo.MailGeneralVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.ClientUtil;
import egovframework.let.utl.fcc.service.CommonUtil;
import net.lingala.zip4j.core.ZipFile;
/** 
 * @Description [Controller] 메일 메뉴
 * @author 오픈솔루션팀 이효민
 * @Modification Information
 *
 *    수정일                       수정자              수정내용
 *    ----------    ------    -------------------
 *    2016.04.14    이효민              신규작성
 *    2017.08.25    김유진              웹 소켓 적용
 *    2017.11.20    김유진              코린도 관련 개발 추가
 *
 * @see
 */

@ServerEndpoint(value = "/websocket/{getID}")
@Controller
public class EzEmailMenuController extends EgovFileMngUtil {
	
	private static final Logger logger = LoggerFactory.getLogger(EzEmailMenuController.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;

	@Autowired
	private EzAddressService ezAddressService;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;  
	
	@Resource(name = "EzCommonService")
    private EzCommonService ezCommonService;
	
	@Autowired
	private EzEmailUtil ezEmailUtil;
	
	@Autowired
	private EzEmailService ezEmailService;
	
	// 웹소켓 커넥션은 인스턴스가 싱글톤이 아니기 때문에 힙에 생성되는 1개의 인스턴스 Map을 공유할 수 있도록 Static으로 선언하였다. 
	private static Map<String, Session> sessionMap = new ConcurrentHashMap<>();
	
	
	/**
	 * 메일 왼쪽화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailLeft.do")
	public String showMailLeft(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception {
		logger.debug("showMailLeft started.");
		
		List<String> userInfo = commonUtil.getUserIdAndPassword(loginCookie);
		String password  = userInfo.get(1);
		
		LoginVO loginInfo = commonUtil.userInfo(loginCookie);
		String domainName = ezCommonService.getTenantConfig("DomainName", loginInfo.getTenantId());
		String userEmail = loginInfo.getId() + "@" + domainName;
		String usePreviewSubTree = ezCommonService.getTenantConfig("UsePreviewSubTreeForEmail", loginInfo.getTenantId());
		String useBottomFrameOnly = ezCommonService.getTenantConfig("useBottomFrameOnly", loginInfo.getTenantId());
		String useMailBoxBackUp = ezCommonService.getTenantConfig("UseMailBoxBackUp", loginInfo.getTenantId());
		String useMailReceiveScreen = ezCommonService.getTenantConfig("useMailReceiveScreen", loginInfo.getTenantId());
		logger.debug("userEmail=" + userEmail + ",usePreviewSubTree=" + usePreviewSubTree + ",useBottomFrameOnly=" + useBottomFrameOnly + ",useMailBoxBackUp=" + useMailBoxBackUp + ",useMailReceiveScreen=" + useMailReceiveScreen);
		
		if (useMailReceiveScreen.equals("YES")) {
			model.addAttribute("useMailReceiveScreen", useMailReceiveScreen);
		}
		
		if (usePreviewSubTree.equals("YES")) {
			MailGeneralVO mailGeneralVO = ezEmailService.getMailGeneral(loginInfo.getTenantId(), loginInfo.getId()).get(0);
			String previewSubTree = mailGeneralVO.getPreviewSubTree();
			model.addAttribute("previewSubTree", previewSubTree);
		}
		
		LoginVO user = commonUtil.userInfo(loginCookie);
		
		StringBuilder rootFolderXML = new StringBuilder();
		StringBuilder rootAddressXML = new StringBuilder();
		
		IMAPAccess ia = null;
		try {
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userEmail, password, egovMessageSource, locale, ezEmailUtil);
			
			String useDefaultFoldersForLangOnly = ezCommonService.getTenantConfig("UseDefaultFoldersForLangOnly", loginInfo.getTenantId());
			boolean isUseDefaultFoldersForLangOnly = useDefaultFoldersForLangOnly.equals("YES") ? true : false;
			
			List<Folder> rootMailFolderList = ia.getTopLevelFolders(true, isUseDefaultFoldersForLangOnly);
			
			for (int i = 0, j = 0; i < rootMailFolderList.size(); i++) {
				Folder folder = rootMailFolderList.get(i);
				
				String folderId = folder.getName();
				String displayName = ezEmailUtil.getDisplayNameFromFolderId(folderId, locale);
				
				int folderUnreadMessageCount = folder.getUnreadMessageCount();
				
				rootFolderXML.append("<node imgidx='1'");
				
				if (folderUnreadMessageCount > 0) {
					rootFolderXML.append(" caption='" + displayName + "(" + folderUnreadMessageCount + ")'");
				} else {
					rootFolderXML.append(" caption='" + displayName + "'");
				}
				
				rootFolderXML.append(" foldername='" + displayName + "'");

				if (folderId.equalsIgnoreCase(ezEmailUtil.getInboxFolderId())) {
					rootFolderXML.append(" orgBoxName='0'");
					rootFolderXML.append(" fullcaption='_INBOX'"); //수정
				} else if (folderId.equalsIgnoreCase(ezEmailUtil.getSentFolderId(locale))) {
					rootFolderXML.append(" orgBoxName='1'");
					rootFolderXML.append(" fullcaption='_SENT'"); //수정
				} else if (folderId.equalsIgnoreCase(ezEmailUtil.getDraftsFolderId(locale))) {
					rootFolderXML.append(" orgBoxName='2'");
					rootFolderXML.append(" fullcaption='_DRAFT'"); //수정
				} else if (folderId.equalsIgnoreCase(ezEmailUtil.getTrashFolderId(locale))) {
					rootFolderXML.append(" orgBoxName='3'");
					rootFolderXML.append(" fullcaption='_DELETE'"); //수정
				} else if (folderId.equalsIgnoreCase(ezEmailUtil.getPersonalFolderId(locale))) {
					rootFolderXML.append(" orgBoxName='4'");
					rootFolderXML.append(" fullcaption='_PERSONAL'"); //수정
				} else if (folderId.equalsIgnoreCase(ezEmailUtil.getJunkFolderId(locale))) {
					rootFolderXML.append(" orgBoxName='5'");
					rootFolderXML.append(" fullcaption='_JUNK'"); //수정
				} else {
					rootFolderXML.append(" orgBoxName='" + ((j++) + 6) + "'");
					rootFolderXML.append(" fullcaption='_NONE'"); //수정
				}

				rootFolderXML.append(" href='" + folder.getFullName() + "'"); //수정
				
				if (folder.listSubscribed().length > 0) {
					rootFolderXML.append(" hassub='1'");
				}
				
				if (folderUnreadMessageCount > 0) {
					rootFolderXML.append(" style='font-weight:bold'");
				}
				
				rootFolderXML.append("></node>");
			}
		} catch (Exception e) {
			logger.error("Error get unread message count: " + e.getMessage());
			e.printStackTrace();
		} finally {
			if (ia != null) {
				ia.close();
			}
		}
		
		List<Map<String, String>> shareInfoList = ezEmailService.getUserSharedMailboxList(loginInfo.getId(), loginInfo.getTenantId());
		
		Map<String, String> map = ezAddressService.getTopFolderSubCount(loginInfo.getTenantId(), loginInfo.getId(), loginInfo.getDeptID(), loginInfo.getCompanyID());
		
		String pHasSub = "";
		String dHasSub = "";
		String cHasSub = "";
		
		if (map != null) {
			if (map.get("P") != null && !map.get("P").equals("0")) {
				pHasSub = "1";
			}
			if (map.get("D") != null && !map.get("D").equals("0")) {
				dHasSub = "1";
			}
			if (map.get("C") != null && !map.get("C").equals("0")) {
				cHasSub = "1";
			}
		}
		
		rootAddressXML.append("<tree>");
		rootAddressXML.append("<nodes>");
        String xmlFormat = "<node imgidx=\"%s\" caption=\"%s\" ownerid=\"%s\" type=\"%s\" folderid=\"%s\" changekey=\"%s\" hassub=\"%s\"></node>";
        rootAddressXML.append(String.format(xmlFormat, "1", egovMessageSource.getMessage("ezEmail.t99000038", locale), user.getId(), "P", "0", "", pHasSub));
        rootAddressXML.append(String.format(xmlFormat, "1", egovMessageSource.getMessage("ezEmail.t99000039", locale), user.getDeptID(), "D", "0", "", dHasSub));
        rootAddressXML.append(String.format(xmlFormat, "1", egovMessageSource.getMessage("ezEmail.t99000040", locale), user.getCompanyID(), "C", "0", "", cHasSub));
        rootAddressXML.append("</nodes>");
        rootAddressXML.append("</tree>");
        
		String mailServerAddress = config.getProperty("config.MailServerAddress");
		
		String funCode = "1";
		
		if (request.getParameter("funCode") != null) {
			funCode = request.getParameter("funCode");
		}

		String subCode = "1";
		
		if (request.getParameter("subCode") != null) {
			subCode = request.getParameter("subCode");
		}
		
		model.addAttribute("mailServerAddress", mailServerAddress);
		model.addAttribute("rootFolderXML", rootFolderXML.toString());
		model.addAttribute("rootAddressXML", rootAddressXML.toString());
		model.addAttribute("funCode", funCode);
		model.addAttribute("subCode", subCode);
		model.addAttribute("usePreviewSubTree", usePreviewSubTree);
		model.addAttribute("useBottomFrameOnly", useBottomFrameOnly);
		model.addAttribute("useMailBoxBackUp", useMailBoxBackUp);
		model.addAttribute("shareInfoList", shareInfoList);
		
		String useBizmekaSpambox = ezCommonService.getTenantConfig("UseBizmekaSpambox", loginInfo.getTenantId());
		
		if (useBizmekaSpambox.equals("YES")) {
			String credentialForBizmekaSpambox = ezEmailUtil.getCredentialForBizmekaSpambox(userEmail);
			
			model.addAttribute("useBizmekaSpambox", useBizmekaSpambox);
			model.addAttribute("credentialForBizmekaSpambox", credentialForBizmekaSpambox);
		}
		
		model.addAttribute("useOnlyInnerMail", ezCommonService.getTenantConfig("UseOnlyInnerMail", loginInfo.getTenantId()));
		
       	String operatorMailAddress = ezCommonService.getCompanyConfig(loginInfo.getTenantId(), loginInfo.getCompanyID(), "operatorMailId");
       	
		String companyDomainName = ezCommonService.getCompanyConfig(loginInfo.getTenantId(), loginInfo.getCompanyID(), "DomainName");
		
		// 회사별 이메일 도메인명이 설정되어 있으면 해당 도메인명을 기반으로 한 이메일 주소를 사용한다.								
		if (!companyDomainName.isEmpty()) {
			operatorMailAddress += "@" + companyDomainName;
		} else {
			operatorMailAddress += "@" + domainName;
		}
       	
        List<String> aliasMailList = ezEmailService.aliasMailCheck(operatorMailAddress);
       	
        if (aliasMailList.size() > 0) {
        	model.addAttribute("operatorMailAddress", operatorMailAddress);
        }
        
		String dotNetIntegration = ezCommonService.getTenantConfig("dotNetIntegration", loginInfo.getTenantId());
		boolean isDotNetAdmin = false;
		
		if (dotNetIntegration.equals("YES")) {
			if (loginInfo.getRollInfo().indexOf("c=1") != -1 || loginInfo.getRollInfo().indexOf("k=1") != -1) {
				isDotNetAdmin = true;
			}			
		}
		String pDeleteBoxID = ezEmailUtil.getTrashFolderId(locale);
		
		model.addAttribute("isDotNetAdmin", isDotNetAdmin);
		model.addAttribute("pDeleteBoxID", pDeleteBoxID);
		
		logger.debug("showMailLeft ended.");
		
		return "ezEmail/mailLeft";
	}
	
	/**
	 * 메일 폴더 리스트 정보 호출 함수
	 */
	@RequestMapping(value="/ezEmail/getFolderList.do", produces="text/xml; charset=utf-8")
	@ResponseBody
	public String getFolderList(@CookieValue("loginCookie") String loginCookie, Locale locale, HttpServletRequest request) throws Exception {
		logger.debug("getFolderList started.");
		
		List<String> userInfo = commonUtil.getUserIdAndPassword(loginCookie);
		String password  = userInfo.get(1);
		
		LoginVO loginInfo = commonUtil.userInfo(loginCookie);
		String domainName = ezCommonService.getTenantConfig("DomainName", loginInfo.getTenantId());
		String userEmail = loginInfo.getId() + "@" + domainName;
		
		String shareId = request.getParameter("shareId");
		logger.debug("shareId=" + shareId);
		
		if (shareId != null) {
			if (!ezEmailService.checkUserShareId(loginInfo.getId(), shareId, loginInfo.getTenantId())) {
				logger.debug("the user cannot access the shareId.");
				logger.debug("getFolderList ended.");
				
				return "";
			}
			
			userEmail = shareId + "@" + domainName;
		}
		
		logger.debug("userEmail=" + userEmail);
		
		Document doc = commonUtil.convertRequestToDocument(request);
		String folderName = doc.getElementsByTagName("URL").item(0).getTextContent();
		String bcount = doc.getElementsByTagName("BCOUNT").item(0).getTextContent();
		logger.debug("folderName=" + folderName);
		
		boolean isSubscribe = true;
		String folderManamger = request.getParameter("fm");
		
		if (folderManamger != null && folderManamger.equals("1")) {
			isSubscribe = false;
		}
		
		StringBuilder subFolderXML = new StringBuilder();
		
		IMAPAccess ia = null;
		try {
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userEmail, password, egovMessageSource, locale, ezEmailUtil);
			List<Folder> subMailFolder = null;
			
			if (!folderName.equals("")) {
				subMailFolder = ia.getSubFolders(folderName, isSubscribe);
				
				for (int i = 0; i < subMailFolder.size(); i++) {
					Folder fd = subMailFolder.get(i);
					
					String folderId = fd.getName();
					String displayName = ezEmailUtil.getDisplayNameFromFolderId(folderId, locale);
					
					subFolderXML.append("<node imgidx='1'");
					
					if (bcount.equals("-1")) {
						if (fd.getUnreadMessageCount() > 0) {
							subFolderXML.append(" caption='" + displayName + "(" + fd.getUnreadMessageCount() + ")'");
						} else {
							subFolderXML.append(" caption='" + displayName + "'");
						}
					} else {
						subFolderXML.append(" caption='" + displayName + "'");
					}
					
					subFolderXML.append(" foldername='" + displayName + "'");
					subFolderXML.append(" orgBoxName='" + i + "'");
					subFolderXML.append(" fullcaption='_NONE'"); //수정
					subFolderXML.append(" href='" + fd.getFullName() + "'");
					
					if (!isSubscribe) {
						if (fd.isSubscribed()) {
							subFolderXML.append(" subscribe='1'");
						} else {
							subFolderXML.append(" subscribe='0'");
						}
						
						if (fd.list().length > 0) {
							subFolderXML.append(" hassub='1'");
						}
					} else {
						if (fd.listSubscribed().length > 0) {
							subFolderXML.append(" hassub='1'");
						}
					}
					
					if (bcount.equals("-1")) {
						if (fd.getUnreadMessageCount() > 0) {
							subFolderXML.append(" style='font-weight:bold'");
						}
					}
					
					subFolderXML.append("></node>");
				}
			} else {
				String useDefaultFoldersForLangOnly = ezCommonService.getTenantConfig("UseDefaultFoldersForLangOnly", loginInfo.getTenantId());
				boolean isUseDefaultFoldersForLangOnly = useDefaultFoldersForLangOnly.equals("YES") ? true : false;
				
				subMailFolder = ia.getTopLevelFolders(isSubscribe, isUseDefaultFoldersForLangOnly);
				
				for (int i = 0, j = 0; i < subMailFolder.size(); i++) {
					Folder fd = subMailFolder.get(i);
					String folderId = fd.getName();
					String displayName = ezEmailUtil.getDisplayNameFromFolderId(folderId, locale);
					
					subFolderXML.append("<node imgidx='1'");
					
					if (bcount.equals("-1")) {
						if (fd.getUnreadMessageCount() > 0) {
							subFolderXML.append(" caption='" + displayName + "(" + fd.getUnreadMessageCount() + ")'");
						} else {
							subFolderXML.append(" caption='" + displayName + "'");
						}
					} else {
						subFolderXML.append(" caption='" + displayName + "'");
					}
					
					subFolderXML.append(" foldername='" + displayName + "'");

					if (folderId.equalsIgnoreCase(ezEmailUtil.getInboxFolderId())) {
						subFolderXML.append(" orgBoxName='0'");
						subFolderXML.append(" fullcaption='_INBOX'"); //수정
					} else if (folderId.equalsIgnoreCase(ezEmailUtil.getSentFolderId(locale))) {
						subFolderXML.append(" orgBoxName='1'");
						subFolderXML.append(" fullcaption='_SENT'"); //수정
					} else if (folderId.equalsIgnoreCase(ezEmailUtil.getDraftsFolderId(locale))) {
						subFolderXML.append(" orgBoxName='2'");
						subFolderXML.append(" fullcaption='_DRAFT'"); //수정
					} else if (folderId.equalsIgnoreCase(ezEmailUtil.getTrashFolderId(locale))) {
						subFolderXML.append(" orgBoxName='3'");
						subFolderXML.append(" fullcaption='_DELETE'"); //수정
					} else if (folderId.equalsIgnoreCase(ezEmailUtil.getPersonalFolderId(locale))) {
						subFolderXML.append(" orgBoxName='4'");
						subFolderXML.append(" fullcaption='_PERSONAL'"); //수정
					} else if (folderId.equalsIgnoreCase(ezEmailUtil.getJunkFolderId(locale))) {
						subFolderXML.append(" orgBoxName='5'");
						subFolderXML.append(" fullcaption='_JUNK'"); //수정
					} else {
						subFolderXML.append(" orgBoxName='" + ((j++) + 6) + "'");
						subFolderXML.append(" fullcaption='_NONE'"); //수정
					}

					subFolderXML.append(" href='" + fd.getFullName() + "'");
					
					if (!isSubscribe) {
						if (fd.isSubscribed()) {
							subFolderXML.append(" subscribe='1'");
						} else {
							subFolderXML.append(" subscribe='0'");
						}
						
						if (fd.list().length > 0) {
							subFolderXML.append(" hassub='1'");
						}
					} else {
						if (fd.listSubscribed().length > 0) {
							subFolderXML.append(" hassub='1'");
						}
					}
					
					if (bcount.equals("-1")) {
						if (fd.getUnreadMessageCount() > 0) {
							subFolderXML.append(" style='font-weight:bold'");
						}
					}
					
					subFolderXML.append("></node>");
				}
			}
			
		} catch (MessagingException e) {
			e.printStackTrace();
		} finally {
			if (ia != null) {
				ia.close();
			}
		}
		
		logger.debug("getFolderList ended.");
		
		return subFolderXML.toString();
	}
	
	/**
	 * 읽지않은 메시지 개수 정보 호출 함수
	 */
	@RequestMapping(value="/ezEmail/getFolderUnreadCount.do", produces="text/xml; charset=utf-8")
	@ResponseBody
	public String getFolderUnreadCount(@CookieValue("loginCookie") String loginCookie, Locale locale, HttpServletRequest request) throws Exception {
		logger.debug("getFolderUnreadCount started.");
		
		List<String> userInfo = commonUtil.getUserIdAndPassword(loginCookie);
		String password  = userInfo.get(1);
		
		LoginVO loginInfo = commonUtil.userInfo(loginCookie);
		String domainName = ezCommonService.getTenantConfig("DomainName", loginInfo.getTenantId());
		String userEmail = loginInfo.getId() + "@" + domainName;
		
		Document doc = commonUtil.convertRequestToDocument(request);
		String folderName = doc.getElementsByTagName("URL").item(0).getTextContent();
		logger.debug("folderName=" + folderName);
		
		if (doc.getElementsByTagName("SHAREID").item(0) != null) {
			String shareId = doc.getElementsByTagName("SHAREID").item(0).getTextContent();
			logger.debug("shareId=" + shareId);
			
			if (!ezEmailService.checkUserShareId(loginInfo.getId(), shareId, loginInfo.getTenantId())) {
				logger.debug("the user cannot access the shareId.");
				logger.debug("getFolderUnreadCount ended.");
				
				return "";
			}
			
			userEmail = shareId + "@" + domainName;
		}
		
		logger.debug("userEmail=" + userEmail);
		
		IMAPAccess ia = null;
		String unreadCountXML = null;
		
		try {
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userEmail, password, egovMessageSource, locale, ezEmailUtil);
			unreadCountXML = "<DATA>" + ia.getUnreadCount(folderName) + "</DATA>";
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (ia != null) {
				ia.close();
			}
		}
		
		logger.debug("getFolderUnreadCount ended.");
		
		return unreadCountXML;
	}
	
	/**
	 * PC에서 메일 가져오기 화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailImport.do")
	public String mailImport(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		logger.debug("mailImport started.");
		
		String browser = ClientUtil.getClientInfo(request, "browser");
		boolean isCrossBrowser = browser.equals("IE9") ? false : true;
		
		model.addAttribute("isCrossBrowser", isCrossBrowser);
		
		logger.debug("mailImport ended.");
		
		return "ezEmail/mailImport";
	}
	
	/**
	 * PC에서 메일 가져오기 실행 함수
	 */
	@RequestMapping(value="/ezEmail/mailImportUpload.do", produces = "text/plain; charset=utf-8")
	@ResponseBody
	public String mailImportUpload(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, MultipartHttpServletRequest request) throws Exception{
		logger.debug("mailImportUpload started.");
		
		String strResult = "ERROR";
		
		List<String> userInfo = commonUtil.getUserIdAndPassword(loginCookie);
		String password  = userInfo.get(1);
		
		LoginVO loginInfo = commonUtil.userInfo(loginCookie);
		String domainName = ezCommonService.getTenantConfig("DomainName", loginInfo.getTenantId());
		String userEmail = loginInfo.getId() + "@" + domainName;
		logger.debug("userEmail=" + userEmail);
		
		List<MultipartFile> multiFile = request.getFiles("file1");
		String folderId = request.getParameter("folderid");
		logger.debug("folderId=" + folderId);
		
		if (multiFile != null) {
			
			SMTPAccess sa = SMTPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.SMTPPort"),
					userEmail, password);
			
			IMAPAccess ia = null;
			InputStream inputStream = null;
			MimeMessage message = null;
			
			try {
				ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
						userEmail, password, egovMessageSource, locale, ezEmailUtil);
				
				Folder folder = ia.getFolder(folderId);
				
				if (folder == null || !folder.exists()) {
					logger.error("Folder not found. folderId=" + folderId);
				} else {
					folder.open(Folder.READ_WRITE);
					
					Message[] messages = new Message[multiFile.size()];
					
					for (int i=0; i<multiFile.size(); i++) {
						try {
							inputStream = multiFile.get(i).getInputStream();
							message = sa.readMimeMessage(inputStream);
							message.setFlag(Flags.Flag.SEEN, true);
							logger.debug("subject=" + message.getSubject());
						} finally {
							try {
								inputStream.close();
							} catch (Exception e) {} 
						}
						
						if (message != null) {
							messages[i] = message;
						}
					}
					
					folder.appendMessages(messages);
					folder.close(true);
					
					logger.debug("mail import Success. messages size=" + messages.length);
					strResult = "OK";
				}
				
			} catch (MessagingException e) {
				strResult = "ERROR : " + e.getMessage();
				e.printStackTrace();
			} finally {
				if (ia != null) {
					ia.close();
				}
			}
		}
		
		logger.debug("mailImportUpload ended. strResult=" + strResult);
		return strResult;
	}
	
	/**
	 * PC에서 메일 가져오기 실행 함수(ActiveX)
	 */
	@RequestMapping(value="/ezEmail/mailImportUploadX.do", produces = "text/plain; charset=utf-8")
	@ResponseBody
	public String mailImportUploadX(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		logger.debug("mailImportUploadX started.");
		
		String strResult = "ERROR";
		
		String sFileTitle = request.getParameter("name");
        String sExt = request.getParameter("ext");
        String folderId = request.getParameter("dir");
		
        logger.debug("sFileTitle=" + sFileTitle + ",sExt=" + sExt + ",folderId=" + folderId);
        
        if (sFileTitle == null || sExt == null || !sExt.toLowerCase().equals("eml") || folderId == null) {
        	return strResult;
        }
        
        List<String> userInfo = commonUtil.getUserIdAndPassword(loginCookie);
		String password  = userInfo.get(1);
        
		LoginVO loginInfo = commonUtil.userInfo(loginCookie);
		String domainName = ezCommonService.getTenantConfig("DomainName", loginInfo.getTenantId());
		String userEmail = loginInfo.getId() + "@" + domainName;
		logger.debug("userEmail=" + userEmail);
		
		SMTPAccess sa = SMTPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.SMTPPort"),
				userEmail, password);
		
		IMAPAccess ia = null;
		try {
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userEmail, password, egovMessageSource, locale, ezEmailUtil);
			
			Folder folder = ia.getFolder(folderId);
			
			if (folder == null || !folder.exists()) {
				logger.error("Folder not found. folderId=" + folderId);
			} else {
				folder.open(Folder.READ_WRITE);
				
				InputStream inputStream = request.getInputStream();
				MimeMessage message = sa.readMimeMessage(inputStream);
				inputStream.close();
				
				message.setFlag(Flags.Flag.SEEN, true);
				
				folder.appendMessages(new Message[]{message});
				folder.close(true);
				
				strResult = "OK";
			}
			
		} catch (MessagingException e) {
			strResult = "ERROR : " + e.getMessage();
			e.printStackTrace();
		} finally {
			if (ia != null) {
				ia.close();
			}
		}
        
		logger.debug("strResult=" + strResult);
		logger.debug("mailImportUploadX ended.");
		
		return strResult;
	}
	
	/**
	 * PC에서 메일함(메일파일묶음) 가져오기 실행 함수
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/ezEmail/mailboxImportZip.do")
	public String mailboxImportZip(@CookieValue("loginCookie") String loginCookie, MultipartHttpServletRequest request, Locale locale, Model model) throws Exception{
		logger.debug("mailboxImportZip started.");
	
		String returnValue = "OK";
		String returnTempId = "NONE";
	
		Session session = null;
		String zipFilePath = null;
		String userkey = request.getParameter("userkey");
		String encryptPw = request.getParameter("encryptPw");
		String retryPathId = request.getParameter("tempId");
		String folderPath = request.getParameter("folderPath");
		List<MultipartFile> multiFile = request.getFiles("file1");
		logger.debug("userkey=" + userkey + ",encryptPw=" + encryptPw + ",retryPathId=" + retryPathId + ",folderPath" + folderPath);
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		int tenantId = userInfo.getTenantId();
		String useEncryptZipForEmail = ezCommonService.getTenantConfig("UseEncryptZipForEmail", tenantId);
		logger.debug("useEncryptZipForEmail=" + useEncryptZipForEmail);
		
		String domainName = ezCommonService.getTenantConfig("DomainName", tenantId);
		String userAccount = userInfo.getId() + "@" + domainName;
		logger.debug("userAccount=" + userAccount);
	
		String realPath = commonUtil.getRealPath(request);
		String tempFileUploadPath = realPath + commonUtil.getUploadPath("upload_mail.ROOT", tenantId) + commonUtil.separator + "tempFileUpload";
		
		ZipInputStream zis = null;
		IMAPAccess ia = null;
		
		try {
			if (multiFile == null || multiFile.get(0) == null) {
				logger.error("Cannot find file."); 
				throw new Exception("Cannot find file.");
			}
			
			// 2017.11.21 코린도 - 암호화된 ZIP 파일 가져오기
			if (useEncryptZipForEmail.equals("YES") && !encryptPw.equals("") && !retryPathId.equals("NONE")) {
				File sourceFile = new File(tempFileUploadPath + commonUtil.separator + retryPathId + ".zip");
				String destFolderPath = tempFileUploadPath + commonUtil.separator + retryPathId;
	
				ZipFile zipFile = new ZipFile(sourceFile);
				zipFile.setPassword(encryptPw.toCharArray());
				zipFile.extractAll(destFolderPath);
				
				if (sourceFile.delete()) {
					logger.debug("encrypted zip file is deleted. path=" + sourceFile.getAbsolutePath());
				}
				
				zipFilePath = zipFolder(destFolderPath, retryPathId, true);
			}
			
			// UTF-8로 읽어 에러가 날 경우가 있어 미리 체크한다. 에러가 나면 EUC-KR로 읽도록 한다.
			// 메일의 갯수를 확인한다.
			Charset charset = Charset.forName("UTF-8");
			
			InputStream fis = null;
			ZipInputStream zis1 = null;
			int messageCount = 0;
			
			try {
				if (zipFilePath != null) {
					fis = new FileInputStream(zipFilePath);
				} else {
					fis = multiFile.get(0).getInputStream();
				}
				
				zis1 = new ZipInputStream(fis, charset);
				
				while (zis1.getNextEntry() != null) {
					messageCount++;
				}
			} catch (Exception e) {
				charset = Charset.forName("EUC-KR");
				logger.debug("charset is changed as EUC-KR.");
				
				if (zis1 != null) {
					try { zis1.closeEntry(); } catch (Exception e1) {}
					try { zis1.close(); } catch (Exception e1) {}
				}
				
				if (zipFilePath != null) {
					fis = new FileInputStream(zipFilePath);
				} else {
					fis = multiFile.get(0).getInputStream();
				}
				
				messageCount = 0;
				
				zis1 = new ZipInputStream(fis, charset);
				
				while (zis1.getNextEntry() != null) {
					messageCount++;
				}
			} finally {
				if (zis1 != null) {
					try { zis1.closeEntry(); } catch (Exception e1) {}
					try { zis1.close(); } catch (Exception e1) {}
					
					zis1 = null;
				}
			}
			
			logger.debug("messageCount=" + messageCount);
			
			// 유저정보를 키로 가지고있는 세션맵에서 메세지 보낼 세션정보를 확인한다.
			if (userkey != null) {
				session = sessionMap.get(userkey);
				logger.info("[WebSocket] mailBoxImportZip Started. SessionMap Size = "+ sessionMap.size() + " userkey=" + userkey + 
						" SessionId=" + session.getId() + " SessionInfo=" + session.getBasicRemote());
			}
			
			List<String> userIdAndPassword = commonUtil.getUserIdAndPassword(loginCookie);
			String password  = userIdAndPassword.get(1);
			
			SMTPAccess sa = SMTPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.SMTPPort"),
					userAccount, password);
	
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userAccount, password, egovMessageSource, locale, ezEmailUtil);
	
			Folder folder = ia.getFolder(folderPath);
	
			if (folder == null || !folder.exists()) {
				logger.error("Folder not found. folderPath=" + folderPath);
			} else {
				folder.open(Folder.READ_WRITE);
				List<Message> messageList = new ArrayList<Message>();
				Message message = null;
				int count = 0;
				int emlCount = 0;
				long lastTime = System.currentTimeMillis();
	
				JSONObject jsonObj = new JSONObject();
				
				if (zipFilePath != null) {
					fis = new FileInputStream(zipFilePath);
				} else {
					fis = multiFile.get(0).getInputStream();
				}
				
				zis = new ZipInputStream(fis, charset);
				ZipEntry ze = zis.getNextEntry();
				
				while (ze != null) {
					count++;
	
					try {
						if (!ze.getName().endsWith(".eml")) {
							throw new Exception("this is not eml file. fileName=" + ze.getName());
						}
	
						if (count % 20 == 0) {
							folder.appendMessages(messageList.toArray(new Message[0]));
							messageList = new ArrayList<Message>();
	
							System.gc();
						}
	
						message = sa.readMimeMessage(zis);
						message.setFlag(Flags.Flag.SEEN, true);
						messageList.add(message);
						emlCount ++;
					} catch (Exception e) {
						e.printStackTrace();
					}
	
					// 진행율 클라이언트에게 전송
					if (userkey != null) {
						
						int percent = (int)((double) count / (double) messageCount * 100.0);
						long currTime = System.currentTimeMillis();
						int interval = (int) (currTime - lastTime);
	
						jsonObj.clear();
						jsonObj.put("status" , "progress"); 
						jsonObj.put("userkey", userkey);
	
						if (interval >= 2000) {
							jsonObj.put("percent", percent); 
							String json2 = jsonObj.toJSONString();
	
							try {
								handleMessage(json2, session);
							} catch (IllegalStateException e) {
								e.printStackTrace();
								break;
							}
							
							lastTime = currTime;
						}
					}
	
					ze = zis.getNextEntry();
				}
	
				logger.debug("count=" + count);
				logger.debug("emlCount=" + emlCount);
				
				// 압축파일 내에 eml파일이 없을 경우
				if (emlCount == 0) {
					logger.debug("emlCount is 0.");
					throw new Exception("ZEROEML");
				}
				
				folder.appendMessages(messageList.toArray(new Message[0]));
				folder.close(true);
			}
		} catch (Exception e) {
			String exceptionMessage = e.getMessage();
			
			if (exceptionMessage != null) {
				
				if (exceptionMessage.equals("encrypted ZIP entry not supported")) {
					returnValue = "NOT";
					
					if (useEncryptZipForEmail.equals("YES")) { // 암호화를 사용하면
						String guid = UUID.randomUUID().toString(); // 새 id를 만들어서
						File file = new File(tempFileUploadPath + commonUtil.separator + guid + ".zip"); // 파일을 생성하고
						multiFile.get(0).transferTo(file); // 멀티파일을 파일로 만들어준다. 
	
						returnTempId = guid;
					}
					
				} else if (exceptionMessage.endsWith("empty or null password provided for AES Decryptor")) {
					logger.error("empty or null password provided for AES Decryptor.");
					returnValue = "NULL";
					returnTempId = retryPathId;
				} else if (exceptionMessage.contains("Wrong Password for file")) {
					logger.error("Wrong Password for file.");
					returnValue = "DIFF";
					returnTempId = retryPathId;
				} else if (exceptionMessage.equals("MALFORMED")) {
					logger.error("MALFORMED.");
					returnValue = "ABORT";
				} else if (exceptionMessage.equals("ZEROEML")) {
					returnValue = "ZEROEML";
				} else {
					returnValue = "ERROR";
					e.printStackTrace();
				}
				
			} else {
				returnValue = "ERROR";
				e.printStackTrace();
			}
			
		} finally {
			if (ia != null) {
				try { ia.close(); } catch (Exception e) {}
			}
			
			if (zis != null) {
				try { zis.closeEntry(); } catch (Exception e) {}
				try { zis.close(); } catch (Exception e) {}
			}
		}
	
		if (zipFilePath != null) {
			File zipFile = new File(zipFilePath);
			
			if (zipFile.exists()) {
				zipFile.delete();
				logger.debug("zip file is deleted. path=" + zipFilePath);
			}
		}
	
		model.addAttribute("result", returnValue);
		model.addAttribute("userkey", userkey);
		model.addAttribute("tempId", returnTempId);
		model.addAttribute("useEncryptZipForEmail", useEncryptZipForEmail);
	
		logger.debug("mailboxImportZip ended.");
		return "ezEmail/mailboxImportZip";
	}

	/**
	 * PC에 메일파일 저장하기 실행 함수
	 */
	@RequestMapping(value="/ezEmail/mailExport.do")
	public void mailExport(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request, HttpServletResponse response) throws Exception{
		logger.debug("mailExport started.");
		
		List<String> userInfo = commonUtil.getUserIdAndPassword(loginCookie);
		String password  = userInfo.get(1);
		
		LoginVO loginInfo = commonUtil.userInfo(loginCookie);
		String domainName = ezCommonService.getTenantConfig("DomainName", loginInfo.getTenantId());
		String userEmail = loginInfo.getId() + "@" + domainName;
		logger.debug("userEmail=" + userEmail);
		
		String url = request.getParameter("url");
		logger.debug("url=" + url);
		
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
		try {
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userEmail, password, egovMessageSource, locale, ezEmailUtil);
			
			Folder folder = ia.getFolder(folderPath);
			
			String mimetype = "message/rfc822";	
			response.setContentType(mimetype);
			
			if (folder == null || !folder.exists()) {
				logger.error("Folder not found. folderPath=" + folderPath);
			} else {
				folder.open(Folder.READ_ONLY);
				Message message = ((IMAPFolder)folder).getMessageByUID(uid);
				
				if (message == null) {
					logger.error("Message not found. uid=" + uid);
				} else {
					String fileName = ezEmailUtil.saveFilenameForm(loginInfo, locale, message) + ".eml";
					fileName = CommonUtil.getEncodedFileNameForDownload(request.getHeader("User-Agent"), fileName);
					logger.debug("fileName=" + fileName);
					response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
					
					OutputStream outputStream = null;
					
					try{
						response.setContentLength(message.getSize());
						
						outputStream = response.getOutputStream();
						message.writeTo(outputStream);
						
					} catch(IOException e){
					} finally {
						if (outputStream != null) {
							outputStream.close();
						}
					}
				}
				
				folder.close(true);
			}
			
		} catch (MessagingException e) {
			e.printStackTrace();
		} finally {
			if (ia != null) {
				ia.close();
			}
		}
		
		logger.debug("mailExport ended.");
	}
	
	/**
	 * 여러개의 메일파일을 zip파일로 서버에 저장하기 실행 함수
	 */
	@RequestMapping(value="/ezEmail/mailExportZip.do")
	@ResponseBody
	public String mailExportZip(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request, HttpServletResponse response) throws Exception{
		logger.debug("mailExportZip started.");
		
		String returnValue = "";
		
		List<String> userIdAndPassword = commonUtil.getUserIdAndPassword(loginCookie);
		String password  = userIdAndPassword.get(1);
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
		String userAccount = userInfo.getId() + "@" + domainName;
		logger.debug("userAccount=" + userAccount);
		
		Map<String, String[]> urlMap = request.getParameterMap();
		Set<String> folderList = urlMap.keySet();
		logger.debug("folderList=" + folderList.toString());
		
		String realPath = commonUtil.getRealPath(request);
		String pDirPath = commonUtil.getUploadPath("upload_mail.ROOT", userInfo.getTenantId());
		pDirPath = realPath + pDirPath;
		String guid = UUID.randomUUID().toString();
		String tempFileUploadPath = pDirPath + commonUtil.separator + "tempFileUpload";
		String pDirTempPath = tempFileUploadPath + commonUtil.separator + guid;
		String useEucKr = ezCommonService.getTenantConfig("UseMailZipEucKr", userInfo.getTenantId());
		String charSet = "utf-8";
		
		// utf-8로 압축했을 경우 윈도우 기본 프로그램으로 압축을 풀면 실패하여 euc-kr로 압축할 수 있도록 옵션처리했다.
		// UseMailZipEucKr이 YES일 경우 euc-kr로 압축한다.
		// 윈도우 기본 프로그램으로 압축을 풀기 위해 추가적으로 new ZipEntry("/" + fileName) 에서 "/"를 제거했다. 
		if (useEucKr.equals("YES")) {
			charSet = "euc-kr";
		}
		
		logger.debug("Use encoding charSet=" + charSet);
		
		IMAPAccess ia = null;
		ZipOutputStream zos = null;
		Map<String, Integer> fileNameMap = new HashMap<String, Integer>();
		
		try {
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userAccount, password, egovMessageSource, locale, ezEmailUtil);
			
			File tempFile = new File(pDirTempPath + ".zip");
			
			if (tempFile.exists()) {
				tempFile.delete();
			}
			
			tempFile = new File(tempFileUploadPath);
			
			if (!tempFile.exists()) {
				tempFile.mkdirs();
			}
			
			boolean isRead = false;
			zos = new ZipOutputStream(new FileOutputStream(pDirTempPath + ".zip"), Charset.forName(charSet));
			
			for (String folderPath : folderList) {
				String uids = urlMap.get(folderPath)[0];
				String[] uidArr = uids.split(",");
				
				Folder folder = ia.getFolder(folderPath);
				
				if (folder == null || !folder.exists()) {
					logger.error("Folder not found. folderPath=" + folderPath);
				} else {
					folder.open(Folder.READ_ONLY);
					
					for (String uid : uidArr) {
						Message message = ((IMAPFolder)folder).getMessageByUID(Long.parseLong(uid));
						
						if (message == null) {
							logger.error("Message not found. uid=" + uid);
							
						} else {
							String fileName = ezEmailUtil.saveFilenameForm(userInfo, locale, message) + ".eml";
							fileName = commonUtil.getUniqueFileName(fileName, fileNameMap);
							
							ZipEntry zipEntry = new ZipEntry(fileName);
							zos.putNextEntry(zipEntry);
							
							// message.writeTo 시 읽은 메일이 되므로 읽지 않은 메일이면 읽지않음으로 다시 설정한다.
							isRead = message.isSet(Flags.Flag.SEEN);
							
							message.writeTo(zos);

							if (!isRead) {
								message.setFlag(Flags.Flag.SEEN, false);
							}

							zos.closeEntry();
						}
					}
					
					folder.close(true);
				}
			}
			
			zos.flush();
			zos.close();
			zos = null;
			
			returnValue = guid;
		} catch (Exception e) {
			File file = new File(pDirTempPath + ".zip");
			
			if (file.exists()) {
				file.delete();
			}
			
			e.printStackTrace();
		} finally {
			if (ia != null) {
				ia.close();
			}
			
			if (zos != null) {
				try {
					zos.close();
				} catch (Exception e) {
				}
			}
		}
		
		logger.debug("mailExportZip ended. returnValue=" + returnValue);
		return returnValue;
	}
	
	/**
	 * 특정 메일함의 모든 메일을 zip파일로 서버에 저장하기 실행 함수
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/ezEmail/mailboxExportZip.do")
	@ResponseBody
	public String mailboxExportZip(@CookieValue("loginCookie") String loginCookie, Locale locale,
				Model model, HttpServletRequest request, HttpServletResponse response) throws Exception{
		logger.debug("mailboxExportZip started.");
		
		String returnValue = "";
		
		List<String> userIdAndPassword = commonUtil.getUserIdAndPassword(loginCookie);
		String password  = userIdAndPassword.get(1);
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
		String userAccount = userInfo.getId() + "@" + domainName;
		logger.debug("userAccount=" + userAccount);
		
		String folderPath = request.getParameter("folderPath");
		logger.debug("folderPath=" + folderPath);
		
		String realPath = commonUtil.getRealPath(request);
		String pDirPath = commonUtil.getUploadPath("upload_mail.ROOT", userInfo.getTenantId());
		pDirPath = realPath + pDirPath;
		String tempFileUploadPath = pDirPath + commonUtil.separator + "tempFileUpload";
		
		File f = new File(tempFileUploadPath);
		
		if (!f.exists()) {
			f.mkdirs();
		}
		
		String guid = UUID.randomUUID().toString();
		String pDirTempPath = tempFileUploadPath + commonUtil.separator + guid;
		String useEucKr = ezCommonService.getTenantConfig("UseMailZipEucKr", userInfo.getTenantId());
		String charSet = "utf-8";
		
		// utf-8로 압축했을 경우 윈도우 기본 프로그램으로 압축을 풀면 실패하여 euc-kr로 압축할 수 있도록 옵션처리했다.
		// UseMailZipEucKr이 YES일 경우 euc-kr로 압축한다.
		// 윈도우 기본 프로그램으로 압축을 풀기 위해 추가적으로 new ZipEntry("/" + fileName) 에서 "/"를 제거했다. 
		if (useEucKr.equals("YES")) {
			charSet = "euc-kr";
		}
		
		logger.debug("Use encoding charSet=" + charSet);
		
		IMAPAccess ia = null;
		ZipOutputStream zos = null;
		Map<String, Integer> fileNameMap = new HashMap<String, Integer>();
		
		Session session = null;
		boolean sessionFlag = true;
		String userkey = request.getParameter("userkey");
		
		// 유저정보를 키로 가지고있는 세션맵에서 메세지 보낼 세션정보를 가지고온다.
		if (userkey != null) {
			session = sessionMap.get(userkey);
			logger.debug("[WebSocket] mailBoxExportZip Started. SessionMap Size = "+ sessionMap.size() + " userkey=" + userkey + " SessionId=" + session.getId() + " SessionInfo=" + session.getBasicRemote());
		}
		
		try {
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userAccount, password, egovMessageSource, locale, ezEmailUtil);
			
			File tempFile = new File(pDirTempPath + ".zip");
			if (tempFile.exists()) {
				tempFile.delete();
			}
			
			zos = new ZipOutputStream(new FileOutputStream(pDirTempPath + ".zip"), Charset.forName(charSet));
			Folder folder = ia.getFolder(folderPath);
			
			if (folder == null || !folder.exists()) {
				logger.error("Folder not found. folderPath=" + folderPath);
			} else {
				folder.open(Folder.READ_ONLY);

				Message[] messages = ((IMAPFolder)folder).getMessages();
				
				boolean isRead = false;
				int messageCount = messages.length; // 총 메일 갯수
				int currCount = 1;
				long lastTime = System.currentTimeMillis();
				
				for (Message message : messages) {
					String fileName = ezEmailUtil.saveFilenameForm(userInfo, locale, message) + ".eml";
					fileName = commonUtil.getUniqueFileName(fileName, fileNameMap);
					
					ZipEntry zipEntry = new ZipEntry(fileName);
					zos.putNextEntry(zipEntry);
					
					// message.writeTo 시 읽은 메일이 되므로 읽지 않은 메일이면 읽지않음으로 다시 설정한다.
					isRead = message.isSet(Flags.Flag.SEEN);
					
					message.writeTo(zos);

					if (!isRead) {
						message.setFlag(Flags.Flag.SEEN, false);
					}
					
					zos.closeEntry();

					// 진행율 클라이언트에게 전송
					if (userkey != null) {
						long currTime = System.currentTimeMillis();
						int interval = (int) (currTime - lastTime);
						int percent = (int)((double) currCount / (double) messageCount * 100.0 );
						
						JSONObject jsonObj = new JSONObject();
						jsonObj.put("status", "progress");
						jsonObj.put("userkey", userkey);
						
						if (interval >= 2000) {
							jsonObj.put("percent", percent);
							String jsonStr = jsonObj.toJSONString();
							
							try {
								handleMessage(jsonStr, session);
							} catch (IllegalStateException e) {
								File file = new File(pDirTempPath + ".zip");
								
								if (file.exists()) {
									file.delete();
								}
								
								returnValue = "CANCEL";
								sessionFlag = false;
								
								e.printStackTrace();
								break;
							} 
							lastTime = currTime;
						}
						currCount = currCount + 1; // 현재 메일 카운트
					}
				}
				
				folder.close(true);
			}
			
			zos.flush();
			zos.close();
			zos = null;
			
			/* 추후 암호화 내보내기 방식 변경
			AESEncrypterBC encrypter = new AESEncrypterBC();
			encrypter.init("1", 0);
			String tempZipFileName = new File(pDirTempPath).getAbsoluteFile().getParent() 
					+ File.separator + "tempencrypted.zip";
			AesZipFileEncrypter enc = new AesZipFileEncrypter(tempZipFileName, encrypter);
			enc.add(new File(pDirTempPath + ".zip"), "1");
			
			new File(pDirTempPath + ".zip").delete();
			new File(tempZipFileName).renameTo(new File(pDirTempPath + ".zip"));
			*/
			
			if (sessionFlag == true) {
				returnValue = guid;
			} 
		} catch (Exception e) {
			File file = new File(pDirTempPath + ".zip");
			
			if (file.exists()) {
				file.delete();
			}
			
			e.printStackTrace();
		} finally {
			if (ia != null) {
				ia.close();
			}
			
			if (zos != null) {
				try {
					zos.close();
				} catch (Exception e) {
				}
			}
		}
		
		logger.debug("mailboxExportZip ended. returnValue=" + returnValue);
		return returnValue;
	}
	
	/**
	 * 메일 zip파일 다운로드 실행 함수
	 */
	@RequestMapping(value="/ezEmail/downloadMailZip.do")
	public void downloadMailZip(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request, HttpServletResponse response) throws Exception{
		logger.debug("downloadMailZip started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
		String userAccount = userInfo.getId() + "@" + domainName;
		logger.debug("userAccount=" + userAccount);
		
		String encryptPw = request.getParameter("encryptPw");
		String tempZipName = request.getParameter("temp");
		logger.debug("tempZipName=" + tempZipName);
		
		String realPath = commonUtil.getRealPath(request);
		String pDirPath = realPath + commonUtil.getUploadPath("upload_mail.ROOT", userInfo.getTenantId());
		String filePath = pDirPath + commonUtil.separator + "tempFileUpload" + commonUtil.separator + tempZipName + ".zip";
		String folderPath = pDirPath + commonUtil.separator + "tempFileUpload" + commonUtil.separator + tempZipName;
		logger.debug("filePath=" + filePath);
		
		// 2017.11.21 코린도 - 암호화된 ZIP 파일 내보내기
		if (!encryptPw.equals("")) {
			String zipFileName = ezEmailUtil.encryptZipFile(filePath, folderPath, encryptPw);
			downFile(request, response, zipFileName, userAccount + ".zip");
			
			File secureFile = new File(zipFileName);
			
			if (secureFile.delete()) {
				logger.debug("zip file is deleted. filePath=" + zipFileName);
			}
		} else {
			downFile(request, response, filePath, userAccount + ".zip");
		}
		
		File zipFile = new File(filePath);
		
		if (zipFile.delete()) {
			logger.debug("zip file is deleted. path=" + filePath);
		}
		
		logger.debug("downloadMailZip ended.");
	}

	/**
	 * 메일함 zip파일 다운로드 실행 함수
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/ezEmail/downloadMailboxZip.do")
	public void downloadMailboxZip(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request, HttpServletResponse response) throws Exception{
		logger.debug("downloadMailboxZip started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
		String userAccount = userInfo.getId() + "@" + domainName;
		logger.debug("userAccount=" + userAccount);
		
		String folderName = request.getParameter("folderName");
		String tempZipName = request.getParameter("temp");
		String encryptPw = request.getParameter("encryptPw");
		logger.debug("folderName=" + folderName + ",tempZipName=" + tempZipName + ", encryptPw=" + encryptPw);
		
		String realPath = commonUtil.getRealPath(request);
		String pDirPath = realPath + commonUtil.getUploadPath("upload_mail.ROOT", userInfo.getTenantId());
		String filePath = pDirPath + commonUtil.separator + "tempFileUpload" + commonUtil.separator + tempZipName + ".zip";
		String folderPath = pDirPath + commonUtil.separator + "tempFileUpload" + commonUtil.separator + tempZipName;
		String userkey = request.getParameter("userkey");
		logger.debug("filePath=" + filePath);
		
		Session session = sessionMap.get(userkey);
		JSONObject jsonObj = new JSONObject();
		
		jsonObj.put("status", "end");
		jsonObj.put("userkey", userkey);
		String jsonStr = jsonObj.toJSONString();
		
		// 2017.11.21 코린도 - 암호화된 ZIP 파일 내보내기
		if (!encryptPw.equals("")) {
			String zipFileName = ezEmailUtil.encryptZipFile(filePath, folderPath, encryptPw);
			handleMessage(jsonStr, session);
			downFile(request, response, zipFileName, userAccount + "_" + folderName + ".zip");
			
			File secureFile = new File(zipFileName);
			
			if (secureFile.delete()) {
				logger.debug(secureFile.getAbsolutePath() + ".zip file is deleted.");
			}
		} else {
			handleMessage(jsonStr, session);
			downFile(request, response, filePath, userAccount + "_" + folderName + ".zip");
		}
		
		File zipFile = new File(filePath);
		
		if (zipFile.delete()) {
			logger.debug(zipFile.getAbsolutePath() + ".zip file is deleted.");
		}
		
		logger.debug("downloadMailboxZip ended.");
	}
	
	/**
	 * zip파일 삭제 실행 함수
	 */
	@RequestMapping(value="/ezEmail/deleteZipFile.do")
	public String deleteZipFile(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request, HttpServletResponse response) throws Exception{
		logger.debug("deleteZipFile started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String temp = request.getParameter("temp");
		String realPath = commonUtil.getRealPath(request);
		String pDirPath = commonUtil.getUploadPath("upload_mail.ROOT", userInfo.getTenantId());
		pDirPath = realPath + pDirPath;
		String pDirTempPath = pDirPath + commonUtil.separator + "tempFileUpload" + commonUtil.separator + temp;
		String tempId = request.getParameter("tempId");
		String pDirEncZipTempPath = pDirPath + commonUtil.separator + "tempFileUpload" + commonUtil.separator + tempId;
		
		File file = new File(pDirTempPath + ".zip");
		
		if (file.exists()) {
			file.delete();
		}
		
		File tempFile = new File(pDirEncZipTempPath + ".zip");
		
		if (tempFile.exists()) {
			tempFile.delete();
			logger.debug("cancle file delete=" + tempFile.getName());
		}
		
		logger.debug("deleteZipFile ended.");
		
		return "json"; 
	}

	/**
	 * 웹소켓 처음 커넥션 맺을 때 호출되는 함수
	 */
    @SuppressWarnings("unchecked")
	@OnOpen
    public void handleOpen(Session session, @PathParam("getID") String getID){
    	logger.debug("[WebSocket] handleOpen started. onOpen called. WebSocket Connected.");
    	
    	// 세션에 연결한 유저ID에 고유문자를 붙여서 메세지전송 대상의 유저를 구별하는 유일한 값을 부여한다.
    	UUID uuid = UUID.randomUUID();
    	String userkey = getID + String.valueOf(uuid);
        
    	// 특정유저의 세션을 Map에 보관한다.
        sessionMap.put(userkey, session);
        session = sessionMap.get(userkey);
        
        JSONObject jsonObj = new JSONObject();
        jsonObj.put("status", "start");
        jsonObj.put("userkey", userkey);
        
        String jsonStr = jsonObj.toJSONString();
        
        try {
        	// 클라이언트 연결을 확인하고 시작을 알린다.(유저의 고유문자를 전송)
        	this.handleMessage(jsonStr, session);
        } catch (Exception e) {
        	logger.debug("[WebSocket] handleOpen error occured.");
        	e.printStackTrace();
        }
        
        logger.debug("[Websocket] userKey="+ userkey + ", sessionId=" + session.getId() + ", sessionInfo=" + session.getBasicRemote());
        logger.debug("[Websocket] sessionMap size=" + sessionMap.size() + ", this=" + this);
        logger.debug("[WebSocket] handleOpen ended.");
    }


    /**
     * 웹소켓 클라이언트와 메세지 송수신시 호출되는 함수
     */
	@SuppressWarnings("unchecked")
	@OnMessage
    public void handleMessage(String jsonStr, Session session) throws Exception{
		JSONObject sendObj = new JSONObject();
		JSONObject recObj = new JSONObject();
		JSONParser jsonParser = new JSONParser();
		
		recObj = (JSONObject) jsonParser.parse(jsonStr);
		String userkey = (String) recObj.get("userkey");
		
		if ( recObj.get("status").equals("start")) {
			session = sessionMap.get(userkey);
			sendObj.put("status", "transferStart");
			sendObj.put("userkey", userkey);
			jsonStr = sendObj.toJSONString();
			session.getBasicRemote().sendText(jsonStr);
		} else if (recObj.get("status").equals("progress") || recObj.get("status").equals("end")) {
			session.getBasicRemote().sendText(jsonStr);
		}
    }

    /**
     * 웹소켓 커넥션 종료시 호출 함수
     */
    @OnClose
    public void handleClose(Session session) throws IOException{
    	logger.debug("[WebSocket] handleClose started. onClose called. WebSocket Disconnected." + session.getId());
    	
    	for (String userkey : sessionMap.keySet()) {
    		Session tempSession = sessionMap.get(userkey);
    		if (session == tempSession) {
    			logger.debug("userkey=" + userkey + " session is found" );
    			sessionMap.remove(userkey);
    			break;
    		}
    	}
    	
    	logger.debug("[WebSocket] sessionMap size=" + sessionMap.size());
    	logger.debug("[WebSocket] handleClose ended.");
    }

    /**
     * 웹소켓 커넥션 에러시 호출 함수
     * @param e
     */
    @OnError
    public void handleError(Throwable e){
        e.printStackTrace();
    }
    
    /**
	 * 편지함 내보내기 옵션(암호화확인) 화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailExportOption.do")
	public String mailExportOption(
			@CookieValue("loginCookie") String loginCookie, 
			Locale locale, 
			Model model, 
			HttpServletRequest request) throws Exception{
		logger.debug("mailExportOption started.");
		
		String exportType = request.getParameter("exportType");

		model.addAttribute("exportType", exportType);
		
		logger.debug("exportType=" + exportType);
		logger.debug("mailExportOption ended.");
		
		return "ezEmail/mailExportOption";
	}
	
	/**
	 * 편지함 가져오기 옵션(암호화확인) 화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailImportOption.do")
	public String mailImportOption(
			@CookieValue("loginCookie") String loginCookie, 
			Locale locale, 
			Model model, 
			HttpServletRequest request) throws Exception{
		logger.debug("mailImportOption started.");
		
		String tempId = request.getParameter("tempId");
		String userkey = request.getParameter("userkey");
		
		model.addAttribute("tempId", tempId);
		model.addAttribute("userkey", userkey);
		
		logger.debug("mailImportOption ended.");
		return "ezEmail/mailImportOption";
	}
	
}
