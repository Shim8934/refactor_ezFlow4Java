
package egovframework.ezMobile.ezEmail.web;

import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileFilter;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.StringReader;
import java.io.UnsupportedEncodingException;
import java.net.URI;
import java.net.URLConnection;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Base64;
import java.util.Base64.Decoder;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Optional;
import java.util.Properties;
import java.util.Set;
import java.util.Spliterator;
import java.util.TimeZone;
import java.util.UUID;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.regex.PatternSyntaxException;
import java.util.stream.StreamSupport;

import javax.activation.DataHandler;
import javax.activation.FileDataSource;
import javax.annotation.Resource;
import javax.json.JsonException;
import javax.mail.Address;
import javax.mail.BodyPart;
import javax.mail.FetchProfile;
import javax.mail.Flags;
import javax.mail.Flags.Flag;
import javax.mail.Folder;
import javax.mail.FolderNotFoundException;
import javax.mail.Header;
import javax.mail.Message;
import javax.mail.Message.RecipientType;
import javax.mail.MessagingException;
import javax.mail.Multipart;
import javax.mail.Part;
import javax.mail.Transport;
import javax.mail.UIDFolder;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import javax.mail.internet.MimePart;
import javax.mail.internet.MimeUtility;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import com.fasterxml.jackson.databind.ObjectMapper;
import egovframework.ezEKP.ezEmail.service.EzEmailUserAdminService;
import com.google.gson.JsonElement;
import egovframework.ezEKP.ezEmail.util.EmailImportance;
import egovframework.ezEKP.ezEmail.vo.IcalVO;
import egovframework.let.user.login.vo.LoginSimpleVO;
import egovframework.let.utl.fcc.service.EgovDateUtil;
import egovframework.let.utl.rest.Rest;
import egovframework.let.utl.rest.Result;
import net.fortuna.ical4j.model.component.VEvent;
import net.fortuna.ical4j.model.parameter.Cn;
import net.fortuna.ical4j.model.parameter.PartStat;
import net.fortuna.ical4j.model.property.Attendee;
import net.fortuna.ical4j.model.property.CalScale;
import net.fortuna.ical4j.model.property.Location;
import net.fortuna.ical4j.model.property.Method;
import net.fortuna.ical4j.model.property.Organizer;
import net.fortuna.ical4j.model.property.ProdId;
import net.fortuna.ical4j.model.property.Uid;
import net.fortuna.ical4j.model.property.Version;
import org.apache.commons.io.FilenameUtils;
import org.apache.commons.io.IOUtils;

import egovframework.let.utl.fcc.service.EgovDateUtil;
import egovframework.let.utl.rest.JgwResult;
import egovframework.let.utl.rest.Result;
import egovframework.let.utl.sim.service.EgovFileScrty;

import org.apache.commons.io.filefilter.PrefixFileFilter;
import org.apache.commons.lang3.BooleanUtils;
import org.apache.commons.lang3.StringUtils;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import com.nimbusds.jose.util.IntegerUtils;
import com.sun.mail.imap.AppendUID;
import com.sun.mail.imap.IMAPFolder;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EzFileMngUtil;
import egovframework.com.cmm.service.Globals;
import egovframework.ezEKP.ezAddress.service.EzAddressService;
import egovframework.ezEKP.ezAddress.vo.AddressFolderVO;
import egovframework.ezEKP.ezAddress.vo.AddressVO;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.logic.IMAPAccess;
import egovframework.ezEKP.ezEmail.logic.SMTPAccess;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezEmail.util.EzEmailUtil;
import egovframework.ezEKP.ezEmail.vo.MailCancelVO;
import egovframework.ezEKP.ezEmail.vo.MailColorVO;
import egovframework.ezEKP.ezEmail.vo.MailDistributionVO;
import egovframework.ezEKP.ezEmail.vo.MailGeneralVO;
import egovframework.ezEKP.ezEmail.vo.MailReadVO;
import egovframework.ezEKP.ezEmail.vo.MailSharedMailboxUserVO;
import egovframework.ezEKP.ezEmail.vo.MailSharedMailboxVO;
import egovframework.ezEKP.ezEmail.vo.MailSignatureVO;
import egovframework.ezEKP.ezEmail.web.EzEmailMailReadController;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.ezMobile.ezEmail.service.MEmailService;
import egovframework.ezMobile.ezOption.service.MOptionService;
import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.ezMobile.ezOption.vo.MOptionVO;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovStringUtil;
import net.htmlparser.jericho.Renderer;
import net.htmlparser.jericho.Source;
import org.xml.sax.InputSource;

import org.xml.sax.InputSource;

@RestController
public class MEmailGWController extends EzFileMngUtil {

private static final Logger logger = LoggerFactory.getLogger(MEmailGWController.class);
	
	private static final String MOBILE_FILEROOT_DOWNLOAD_URL = "/mobile/ezCommon/mFileDown.do?fileName=*.INLINE.*&amp;filePath=/fileroot";

	// dhlee : 20221027 - 사이냅 웹에디터를 사용하는 닷넷 모바일에서 이미지 업로드를 지원하기 위해 Upload_Common 폴더 관련 처리를 추가함.
	private static final Pattern MOBILE_DOWNLOAD_IMAGE_PATTERN
		= Pattern.compile("src=\"/mobile/ezCommon/mFileDown.do\\?fileName=\\*\\.INLINE\\.\\*&amp;filePath=(/fileroot/[^\"]*)|src=\".*?(/Upload_Common/.*?)\"");

	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;
	
	@Resource(name="loginService")
	private LoginService loginService;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Autowired
	private EzEmailUtil ezEmailUtil;
	
	@Autowired
	private EzEmailService ezEmailService;
	
	@Autowired
	private EzOrganService ezOrganService;
	
	@Autowired
	private EzAddressService ezAddressService;
	
	@Autowired
	private EzOrganAdminService ezOrganAdminService;
	
	@Autowired
	private EzEmailMailReadController ezEmailMailReadController;

	@Resource(name="crypto") 
    private EgovFileScrty egovFileScrty;
	
	@Resource(name="MOptionService")
	private MOptionService mOptionService;
	
	@Resource(name = "EzCommonService")
    private EzCommonService ezCommonService;
	
	@Resource(name = "MEmailService")
	private MEmailService MEmailService;
	
	@Resource(name = "jspw")
    private String jspw;

	@Resource(name="EzEmailUserAdminService")
	private EzEmailUserAdminService ezEmailUserAdminService;
    
	@Autowired
	private Rest rest;
    
	/**
	 * 모바일 G/W 이메일 [GET] 왼쪽 슬라이드 메뉴에 편지함 목록 조회, 메일 이동 시 편지함 목록 출력
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezemail/folders-list/users/{userId:.+}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public Object mMailFolderList(HttpServletRequest request, @PathVariable String userId, @RequestParam(value="folderId", required=false) String folderId) {
		logger.debug("MOBILE G/W MAIL mMailFolderList started.");		
		logger.debug("userId=" + userId + ",folderId=" + folderId);
		
		JSONObject result = new JSONObject();
		IMAPAccess ia = null;
		
		try {
			if (folderId == null) {
				folderId = "";
			}
			
			if (!folderId.equals("")) {
				folderId = URLDecoder.decode(folderId, "UTF-8");
				
				logger.debug("decoded folderId=" + folderId);
			}
		
			JSONArray mailFolderList = new JSONArray();
		
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			String domainName = ezCommonService.getTenantConfig("DomainName", info.getTenantId());
			String userEmail = info.getUserId() + "@" + domainName;
			String password = jspw;
			String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", info.getTenantId());
			
			String ld = commonUtil.getTwoLetterLangFromLangNum(info.getLang());
			Locale locale = new Locale(ld);
			
			logger.debug("locale : ," + locale.getDisplayLanguage());

			// 전체메일
			if (StringUtils.isBlank(folderId)) {
				JSONObject folderAll = new JSONObject();
				String displayName = egovMessageSource.getMessage("email.allmail", locale);

				folderAll.put("name", displayName);
				folderAll.put("fullName", "ALLMAIL");
				folderAll.put("unReadCount", "");
				folderAll.put("hasSub", false);

				mailFolderList.add(folderAll);
			}
			// 편지함
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userEmail, password, egovMessageSource, locale, ezEmailUtil);
			
			List<Folder> subMailFolder = null;

			if (ia != null){
				if (!folderId.equals("")) {
					subMailFolder = ia.getSubFolders(folderId, true);
				} else {
					logger.debug("getTopLevelFolders");

					String useDefaultFoldersForLangOnly = ezCommonService.getTenantConfig("UseDefaultFoldersForLangOnly", info.getTenantId());
					boolean isUseDefaultFoldersForLangOnly = useDefaultFoldersForLangOnly.equals("YES") ? true : false;

					subMailFolder = ia.getTopLevelFolders(true, isUseDefaultFoldersForLangOnly);
				}
			}
			logger.debug("subMailFolder size = " + subMailFolder.size());
			
			JSONObject folder = null;
			
			for (int i = 0; i < subMailFolder.size(); i++) {
				Folder f = subMailFolder.get(i);
				
				String displayName = ezEmailUtil.getDisplayNameFromFolderId(f.getName(), locale);
				
				folder = new JSONObject();
				
				folder.put("name", displayName);				
				folder.put("fullName", f.getFullName());
				folder.put("unReadCount", f.getUnreadMessageCount());
				
				if (f.listSubscribed().length > 0) {
					folder.put("hasSub", true);
				} else {
					folder.put("hasSub", false);
				}
				
				mailFolderList.add(folder);
			}
			
			int totalUnreadCount = ezEmailService.getTotalUnreadCount(info.getUserId(), info.getTenantId());

			boolean useApprMail = commonUtil.checkTenantConfigBool(info.getTenantId(), "useApprMail", "false")
					? ezEmailUtil.useApprMailPolicy(info.getTenantId(), info.getCompanyId()) : false; // 2024-03-06 이사라 - 승인메일 사용 여부
			boolean isApprMailApprover = useApprMail ? ezEmailService.checkApprMailApprover(info.getTenantId(), info.getCompanyId(), info.getUserId()) : false;

			// 사용자가 메일 태그를 사용하는지 확인
			boolean useMailTag = ezEmailUtil.checkUseMailTag(info.getTenantId(),userEmail);
			
			JSONObject data = new JSONObject();
			data.put("mailFolderList", mailFolderList);
			data.put("useSharedMailbox", useSharedMailbox);
			data.put("totalUnreadCount", totalUnreadCount);
			data.put("useApprMail", useApprMail);
			data.put("isApprMailApprover", isApprMailApprover);
			data.put("useMailTag", useMailTag);
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", data);			
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");			
		} finally {
			if (ia != null) {
				ia.close();
			}
		}
		
		logger.debug("MOBILE G/W MAIL mMailFolderList ended.");
		
		return result;
	}
	
	/**
	 * 모바일 G/W 이메일 [GET] 왼쪽 슬라이드 메뉴에 공유 편지함 목록 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezemail/shared-folders-list/users/{userId:.+}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public Object mMailSharedFolderList(HttpServletRequest request, @PathVariable String userId) {
		logger.debug("MOBILE G/W MAIL mMailSharedFolderList started.");		
		logger.debug("userId=" + userId);
		
		JSONObject result = new JSONObject();
		IMAPAccess ia = null;
		
		try {
			JSONObject data = new JSONObject();
			JSONArray shareMailInfoList = new JSONArray();
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			String domainName = ezCommonService.getTenantConfig("DomainName", info.getTenantId());
			
			List<Map<String, String>> sharedMailBoxList = ezEmailService.getUserSharedMailboxList(info.getUserId(), true, info.getTenantId());
			
			for (int i = 0; i < sharedMailBoxList.size(); i++) {
				JSONObject shareMailInfo = new JSONObject();
				JSONArray mailFolderList = new JSONArray();
				String shareId = sharedMailBoxList.get(i).get("shareId");
				String deletePermission = sharedMailBoxList.get(i).get("deletePermission");
				String sendPermission = sharedMailBoxList.get(i).get("sendPermission");
				String shareName = sharedMailBoxList.get(i).get("shareName");
				String mail = sharedMailBoxList.get(i).get("mail");
				String compId = sharedMailBoxList.get(i).get("compId");
				String totalUnreadCount = sharedMailBoxList.get(i).get("totalUnreadCount");
				String userEmail = shareId + "@" + domainName;
				String password = jspw;

				String ld = commonUtil.getTwoLetterLangFromLangNum(info.getLang());
				Locale locale = new Locale(ld);

				logger.debug("locale : ," + locale.getDisplayLanguage());

				ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"), userEmail, password, egovMessageSource, locale, ezEmailUtil);

				List<Folder> subMailFolder = null;

				logger.debug("getTopLevelFolders");

				String useDefaultFoldersForLangOnly = ezCommonService.getTenantConfig("UseDefaultFoldersForLangOnly", info.getTenantId());
				boolean isUseDefaultFoldersForLangOnly = useDefaultFoldersForLangOnly.equals("YES") ? true : false;

				// 전체메일
				JSONObject folderAll = new JSONObject();
				String displayNameAll = egovMessageSource.getMessage("email.allmail", locale);

				folderAll.put("name", displayNameAll);
				folderAll.put("fullName", "ALLMAIL");
				folderAll.put("unReadCount", "");
				folderAll.put("hasSub", false);

				mailFolderList.add(folderAll);
				
				// 편지함
				if (ia != null){
					subMailFolder = ia.getTopLevelFolders(true, isUseDefaultFoldersForLangOnly);

					JSONObject folder = null;
					for (int j = 0; j < subMailFolder.size(); j++) {
						Folder f = subMailFolder.get(j);

						String displayName = ezEmailUtil.getDisplayNameFromFolderId(f.getName(), locale);

						folder = new JSONObject();

						folder.put("name", displayName);
						folder.put("fullName", f.getFullName());
						folder.put("unReadCount", f.getUnreadMessageCount());

						if (f.listSubscribed().length > 0) {
							folder.put("hasSub", true);
						} else {
							folder.put("hasSub", false);
						}
						mailFolderList.add(folder);
					}
				}

				MOptionVO opt = mOptionService.optionInfo(shareId, info.getTenantId());
				if(opt == null) {
					logger.debug("shareID insertOption start");
					mOptionService.insertOption(shareId, info.getOffSet(), info.getLang(), "D", "10", "N", info.getTenantId());
					opt = mOptionService.optionInfo(shareId, info.getTenantId());

					logger.debug("opt: " + opt.toString());
				}
				
				boolean useMailTag = ezEmailUtil.checkUseMailTag(info.getTenantId(),userEmail);
				
				shareMailInfo.put("mailFolderList", mailFolderList);
				shareMailInfo.put("shareId", shareId);
				shareMailInfo.put("deletePermission", deletePermission);
				shareMailInfo.put("sendPermission", sendPermission);
				shareMailInfo.put("shareName", shareName);
				shareMailInfo.put("mail", mail);
				shareMailInfo.put("compId", compId);
				shareMailInfo.put("totalUnreadCount", totalUnreadCount);
				shareMailInfo.put("useMailTag", useMailTag);
				shareMailInfoList.add(shareMailInfo);
			}
			data.put("shareMailInfoList", shareMailInfoList);

			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", data);			
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");			
		} finally {
			if (ia != null) {
				ia.close();
			}
		}
		
		logger.debug("MOBILE G/W MAIL mMailSharedFolderList ended.");
		
		return result;
	}
	
	/**
	 * 유저의 공유 사서함 권한 가져오기
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezemail/users/{userId:.+}/share/{shareId:.+}", method=RequestMethod.GET, produces="application/json;charset=utf-8")
	public Object getShareMailBoxPermissionInfo(HttpServletRequest request, @PathVariable String userId, @PathVariable String shareId) {		
		logger.debug("MOBILE G/W MAIL getShareMailBoxPermissionInfo started.");
		logger.debug("userId=" + userId + "shareId=" + shareId);
		
		JSONObject result = new JSONObject();
        try {
        	String serverName = request.getHeader("x-user-host");
    		MCommonVO info = mOptionService.commonInfo(serverName, userId);
			
    		MailSharedMailboxUserVO shareMailBoxPermissionInfo = ezEmailService.getSharedMailboxPermissionInfo(shareId, info.getTenantId(), info.getUserId());
			
        	JSONObject permissionInfo = new JSONObject();;
        	permissionInfo.put("shareId", shareMailBoxPermissionInfo.getShareId());
        	permissionInfo.put("deletePermission", shareMailBoxPermissionInfo.getDeletePermission());
        	permissionInfo.put("sendPermission", shareMailBoxPermissionInfo.getSendPermission());
        	permissionInfo.put("shareName", shareMailBoxPermissionInfo.getShareName());
            
            result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", permissionInfo);	

		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");	
		
		}
        
		logger.debug("MOBILE G/W MAIL getShareMailBoxPermissionInfo ended.");
		
		return result;
	}
	
	/**
	 * 모바일 G/W 이메일 [GET] (받은,보낸,임시,지운,개인,기타) 편지함 메일 리스트
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezemail/folders/{folderId}/mails/users/{userId:.+}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public Object mMailFolderMailList(HttpServletRequest request, @PathVariable String folderId, @PathVariable String userId, 
			@RequestParam(value="start", required=true) String start,
			@RequestParam(value="end", required=true) String end,
			@RequestParam(value="searchField", required=false) String searchField,
			@RequestParam(value="search", required=false) String search,
			@RequestParam(value="searchPeriod", required=false) String searchPeriod,
			@RequestParam(value="filter", required=false) String filter,
			@RequestParam(value="startDate", required=false) String startDate,
			@RequestParam(value="endDate", required=false) String endDate,
			@RequestParam(value="includeSubFolders", required=false) String includeSubFolders,
			@RequestParam(value="tagName", required = false) String tagName) {
		logger.debug("MOBILE G/W MAIL mMailFolderMailList started.");
		logger.debug("folderId=" + folderId + ",userId=" + userId + ",start=" + start + ",end=" + end);
		logger.debug("searchField=" + searchField + ",search=" + search  + ",searchPeriod=" + searchPeriod + ",filter=" + filter);
		logger.debug("startDate=" + startDate + ",endDate=" + endDate);
		logger.debug("includeSubFolders=" + includeSubFolders);

		JSONObject result = new JSONObject();
        IMAPAccess ia = null;
		
		try {
			if (searchField == null) {
				searchField = "";
			}
			
			if (search == null) {
				search = "";
			}
			
			if (searchPeriod == null) {
				searchPeriod = "";
			}

			if (filter == null) {
				filter = "";
			}

			if (startDate == null) {
				startDate = "";
			}
			
			if (endDate == null) {
				endDate = "";
			}
			
			if (includeSubFolders == null) {
				includeSubFolders = "";
			}

			if (tagName == null) {
				tagName = "";
			}
			
			folderId = URLDecoder.decode(folderId, "UTF-8");
			
			JSONArray messageJsonArray = new JSONArray();
			
			Date sd = null;
			Date ed = null;
			
			boolean senderReceiverFlag = false;
			
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			String domainName = ezCommonService.getTenantConfig("DomainName", info.getTenantId());
			String userEmail = info.getUserId() + "@" + domainName;
			String password = jspw;
       
			String ld = commonUtil.getTwoLetterLangFromLangNum(info.getLang());
			Locale locale = new Locale(ld);
			
			// String inboxName = egovMessageSource.getMessage("ezEmail.t644", locale);
			String sendName = ezEmailUtil.getSentFolderId(locale);
			String tempName = ezEmailUtil.getDraftsFolderId(locale);
			
	        folderId = ezEmailUtil.getFolderIdFromDisplayName(folderId, locale);
	        
	        logger.debug("sendName : " + sendName + ", tempName : " + tempName);
	        
	        senderReceiverFlag = folderId.equals(sendName) || folderId.equals(tempName) ? true : false;
	        
	        logger.debug("folderId : " + folderId + ", senderReceiverFlag : " + senderReceiverFlag);

			// 2023-02-14 이사라 - 모바일은 기간 선택 시 직접입력이 없기 때문에 오늘날짜 기준으로 검색기간을 설정
			if (!searchPeriod.equals("")) {
				String now = LocalDate.now().toString().concat(" 00:00:00");
				startDate = adjustDate(now, searchPeriod);
			}

			if (!startDate.equals("")) {
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				
				sd = sdf.parse(startDate);
			}
	        
			if (!endDate.equals("")) {
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

				ed = sdf.parse(endDate);
			}
	        
	        folderId = URLDecoder.decode(folderId, "UTF-8");
			
			if (folderId.equalsIgnoreCase("tag")) {
				folderId = "";
			}
	        
	        logger.debug("userID : " + userId + ",folderId : " + folderId + ",start : " + start 
	        		+ ",end : " + end + ",search : " + search + ",startDate : " + sd + ",endDate : " + ed); 
	        
	        Message[] messages = null;
			
			logger.debug("userEmail : " + userEmail);
				        
	        boolean isUnreadOnly = false;
	        boolean isImportantOnly = false;
	        boolean searchSubFolder = false;
	        int totalCount = 0;
	        int startNo = 0;
			int endNo = 0;
			
	        if (filter.equals("isUnreadOnly")) {
	        	isUnreadOnly = true;
	        } else if (filter.equals("isImportantOnly")) {
	        	isImportantOnly = true;
	        }
	        
	        if (includeSubFolders.equals("1")) {
	        	searchSubFolder = true;
	        }
	        
        	String searchValue = search;
        	
        	if (searchField.isEmpty()) {
        		// 검색어가 없을 때는 검색 필드를 설정하지 않는다.
        		if (!searchValue.isEmpty()) {
        			searchField = "SUBJECT&FROM";
        		}
				
				if (senderReceiverFlag) {
					// 검색어가 없을 때는 검색 필드를 설정하지 않는다.
					if (!searchValue.isEmpty()) {
						searchField = "SUBJECT&TO";
					}
				}
			}
			
        	startNo = Integer.parseInt(start);
			endNo = Integer.parseInt(end);
			int listCount = endNo - startNo;
			
			if (listCount < 0) {
				listCount = 0;
			}
			
			Map<String, Object> extraMap = new HashMap<String, Object>();
			
			if (ed == null) {
				ed = new Date();
			}
			
			// 2023-02-14 이사라 - 검색기간의 디폴트 기간을 메일 환경설정에서 설정한 값으로 세팅하기 위해 추가
			MailGeneralVO mailGeneral = ezEmailService.getMailGeneral(info.getTenantId(), info.getUserId()).get(0);
			String generalMailSearchPeriod = mailGeneral.getMailSearchPeriod();
			logger.debug("generalMailSearchPeriod=" + generalMailSearchPeriod);

			result.put("generalMailSearchPeriod", generalMailSearchPeriod);

			String useRDBOnlyMailList = ezCommonService.getTenantConfig("useRDBOnlyMailList", info.getTenantId());
			
			if (useRDBOnlyMailList.equals("YES")) {
				int mailboxMailCount = 0;
				int mailboxUnreadMailCount = 0;				
				boolean includeContent = false;
				String folderIdParam = "ALLMAIL".equalsIgnoreCase(folderId) ? "INBOX////Personal folder" : folderId; // 전체메일은 받은편지함과 그 하위, 개인편지함과 그 하위의 모든 메일함에서 메일을 가져온다.

				List<Map<String, String>> mailList = ezEmailUtil.searchFolderUsingRDBOnly(userEmail, folderIdParam, new String[]{searchField}, new String[]{searchValue}, sd, ed, searchSubFolder, 
						isUnreadOnly, isImportantOnly, "receivedDate", false, startNo, listCount, true, extraMap, info.getTenantId(), includeContent, tagName);
				
				totalCount = (int)extraMap.get("totalCount");
				mailboxMailCount = (int)extraMap.get("mailboxMailCount");
				mailboxUnreadMailCount = (int)extraMap.get("mailboxUnreadMailCount");
				
				logger.debug("totalCount=" + totalCount + ",mailboxMailCount=" + mailboxMailCount + ",mailboxUnreadMailCount=" + mailboxUnreadMailCount);
					        	
				for (Map<String, String> mailInfo : mailList) {
					JSONObject messageJson = new JSONObject();
									        
					String mailId = mailInfo.get("MAIL_ID");
					String[] mailIdArr = mailId.split("/");
					
					messageJson.put("href", mailId);
					messageJson.put("folderId", mailIdArr[0]);
					messageJson.put("messageId", mailIdArr[1]);
					
					// 각 메일별로 편지함 이름을 담는다.
					String folderNameEach = mailIdArr[0].matches(".*\\..*")
							? mailIdArr[0].split("\\.")[mailIdArr[0].split("\\.").length - 1]
							: ezEmailUtil.getDisplayNameFromFolderId(mailIdArr[0], locale);
					messageJson.put("folderName", folderNameEach);

					// importance
					int importance = 1;
					
					// 메일 중요도
					try {
						importance = Integer.parseInt(mailInfo.get("IMPORTANCE"));
					} catch (Exception ex) {						
					}
					
					messageJson.put("importance", importance);
					
					// Flagged is used for bookmark
					int flagged = 0;
					
					if ("1".equals(mailInfo.get("MAIL_IS_FLAGGED"))) {
						flagged = 1;
					}
					
					messageJson.put("flag", flagged);
					
					if (filter.equals("isImportantOnly") && flagged != 1) {
						continue;
					}
					
					// attachment
					boolean isAttached = "1".equals(mailInfo.get("HAS_ATTACH"));
					int attached = isAttached ? 1 : 0;
					messageJson.put("attach", attached);
					
					String addressStr = "";
					Address[] addresses = null;
					
					if (!senderReceiverFlag) {
						addressStr = ezEmailUtil.getNameOrAddress(mailInfo.get("SENDER"));
					// in case of Sent mailbox
					} else {
						// To, Cc, Bcc를 모두 포함한다.
						String recipientsStr = mailInfo.get("RECIPIENT");
						
						if (!recipientsStr.isEmpty()) {
							// To, Cc, Bcc를 분리한다.(||로 구분됨.)
							String[] recipientsArr = recipientsStr.split("\\|\\|", 3);		
							
							if (!recipientsArr[0].isEmpty()) {
								String[] toStrArr = recipientsArr[0].split("; ");
								
								for (String toStr : toStrArr) {
									toStr = toStr.trim();
									String[] tokens = toStr.split(" <");
									String toName = tokens[0]; 
																	
									addressStr += toName;
									addressStr += "; ";									
								}
								
								addressStr = addressStr.substring(0, addressStr.length() - 2);								
							}
						}						
					}
					
					messageJson.put("sender", addressStr);
					messageJson.put("fromemail", ezEmailUtil.getAddress(mailInfo.get("SENDER")));

					// subject
					String subject = mailInfo.get("SUBJECT");								
					subject = (subject != null) ? subject : "";
					
					if (subject == null || subject.trim().equals("")) {
						subject = egovMessageSource.getMessage("ezEmail.kms03", locale);
					}
									
					messageJson.put("subject", subject);
					
					// received date
					SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");					
					Date receivedDate = sdf2.parse(mailInfo.get("MAIL_DATE"));
					
					SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
					sdf.setTimeZone(TimeZone.getTimeZone("GMT"));
					
					String receivedDateStr = sdf.format(receivedDate);
					
					receivedDateStr = commonUtil.getDateStringInUTC(receivedDateStr, info.getOffSet(), false);
					
					String receivedDateStr2 = receivedDateStr.substring(0,receivedDateStr.length()-3);
					
					messageJson.put("receivedt", receivedDateStr);
					messageJson.put("receivedt2", receivedDateStr2);
					
					// size
					String mailSize = "";
					
					try {
						int size = Integer.parseInt(mailInfo.get("MAIL_SIZE"));

						if (size < 1000) {
							mailSize = size + "B";
						} else {
							size = Math.round((float) size / 1024);

							if (size > 1000) {
								size = Math.round((float) size / 1024);
								mailSize = size + "MB";
							} else {
								mailSize = size + "KB";
							}
						}

					} catch (Exception ex) {						
					}
					
					messageJson.put("size", mailSize);
					
					// read/unread
					int readFlag = "1".equals(mailInfo.get("MAIL_IS_SEEN")) ? 1 : 0;
					messageJson.put("read", readFlag);
					
					if (filter.equals("isUnreadOnly") && readFlag == 1) {
						continue;
					}
					
					if ("1".equals(mailInfo.get("MAIL_IS_ANSWERED"))) {
						messageJson.put("contentclass","REPLY");
					} else {
						boolean isForwarded = "1".equals(mailInfo.get("MAIL_IS_FORWARDED"));
						
						if (isForwarded) {
							messageJson.put("contentclass", "FORWARD");
						} else {
							messageJson.put("contentclass", "IPM.Note");
						}
					}

					// secureMail
					messageJson.put("securedMail", "1".equals(mailInfo.get("MAIL_IS_SECURED")));

					// isEach
					messageJson.put("isEach", "1".equals(mailInfo.get("MAIL_SENT_IN_EACH")));

					if (!endDate.equals(receivedDateStr)) {
						messageJsonArray.add(messageJson);
					}
				}
				
				String[] folderIdArr = folderId.split("\\.");
				String folderName = folderIdArr[folderIdArr.length - 1];
				
				folderName = ezEmailUtil.getDisplayNameFromFolderId(folderName, locale);
				
				// set importanceColor
				String importanceColor = "#ff0000";
				MailColorVO mailColor = ezEmailService.getMailColor(info.getTenantId());
				
				if (mailColor != null && mailColor.getImportanceColor() != null) {
					importanceColor = mailColor.getImportanceColor();
				}
				
				String hackingMailReport = ezCommonService.getTenantConfig("useHackingMailReport", info.getTenantId());
				
				boolean useHackingMailReport = hackingMailReport.equalsIgnoreCase("YES") ? true : false;
				
				JSONObject data = new JSONObject();
				
				data.put("messageJsonArray", messageJsonArray);
				data.put("importanceColor", importanceColor);
				data.put("unreadCount", mailboxUnreadMailCount);
				data.put("fullCount", mailboxMailCount);
				data.put("optionCount", totalCount);
				data.put("folderName", folderName);
				data.put("includeSubFolders", includeSubFolders);
				data.put("useHackingMailReport", useHackingMailReport);
				
				result.put("status", "ok");
				result.put("code", 0);			
				result.put("data", data);				
			} else {
				ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
						userEmail, password, egovMessageSource, locale, ezEmailUtil);
				if (ia == null){
					throw new Exception("ia is null");
				}
				Folder folder = ia.getFolder(folderId);		
				folder.open(Folder.READ_ONLY);
				
				messages = ezEmailUtil.searchFolder(ia, userEmail, folder, searchField, searchValue, sd, ed, searchSubFolder, 
						isUnreadOnly, isImportantOnly, "receivedDate", false, startNo, listCount, true, extraMap, info.getTenantId(), "");
				
				totalCount = (int)extraMap.get("totalCount");
				logger.debug("totalCount=" + totalCount);
	        	
				for (Message message : messages) {
					JSONObject messageJson = new JSONObject();
					
					Folder f = message.getFolder();
					UIDFolder uidFolder = (UIDFolder) f;
					String fName = f.getFullName();
				        
					messageJson.put("href", fName + "/" + uidFolder.getUID(message));
					messageJson.put("folderId", fName);
					messageJson.put("messageId", uidFolder.getUID(message));
					messageJson.put("fromemail", "");
									
					// importance
					String[] headers = message.getHeader("X-Priority");
					String header = headers != null ? headers[0] : "normal";
					int importance = 1;
					
					// startsWith is used since
					// there are cases like X-Priority: 1 (Highest) generated by Thunderbird.
					if (header.startsWith("1")) {
						importance = 2;
					}
					else if (header.startsWith("5")) {
						importance = 0;
					}
					
					messageJson.put("importance", importance);
					
					// Flagged is used for bookmark
					int flagged = 0;
					
					if (message.isSet(Flags.Flag.FLAGGED)) {
						flagged = 1;
					}
					
					messageJson.put("flag", flagged);
					
					if (filter.equals("isImportantOnly") && flagged != 1) {
						continue;
					}
					
					// attachment
					boolean isAttached = IMAPAccess.hasAttachment(message);
					int attached = isAttached ? 1 : 0;
					messageJson.put("attach", attached);
					
					String addressStr = "";
					Address[] addresses = null;
					
					if (!senderReceiverFlag) {
						addressStr = ezEmailUtil.getFromNameOrAddressOfMessage(message);
					// in case of Sent mailbox	
					} else {
						addresses = message.getRecipients(Message.RecipientType.TO);
						
						if (addresses != null) {
							String toHeader = message.getHeader("To")[0];
							boolean isAscii = ezEmailUtil.isPureAscii(toHeader);
							
							StringBuilder addressBuilder = new StringBuilder();
							
							for (Address address : addresses) {
								addressStr = ((InternetAddress)address).getPersonal(); // name part
								if (addressStr == null) {
									addressStr = ((InternetAddress)address).getAddress(); // email address part
								} else {
									if (!isAscii) {
										byte[] rawBytes = addressStr.getBytes("iso-8859-1");
										
										addressStr = ezEmailUtil.decodeNonAsciiBytes(rawBytes);								
									} else {
										// decoding is needed for the name part
										addressStr = MimeUtility.decodeText(addressStr);
									}
								}		
								
								addressBuilder.append(addressStr);
								addressBuilder.append("; ");
							}
							
							addressStr = addressBuilder.toString();
							addressStr = addressStr.substring(0, addressStr.length() - 2);
						}								
					}
					
					messageJson.put("sender", addressStr);
								
					// subject
					String subject = ezEmailUtil.getSubject(message);								
					subject = (subject != null) ? subject : "";
					
					if (subject == null || subject.trim().equals("")) {
						subject = egovMessageSource.getMessage("ezEmail.kms03", locale);
					}
									
					messageJson.put("subject", subject);
					
					// received date
					Date receivedDate = message.getReceivedDate();
					SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
					sdf.setTimeZone(TimeZone.getTimeZone("GMT"));
					
					String receivedDateStr = sdf.format(receivedDate);
					
					receivedDateStr = commonUtil.getDateStringInUTC(receivedDateStr, info.getOffSet(), false);
					
					String receivedDateStr2 = receivedDateStr.substring(0,receivedDateStr.length()-3);
					
					messageJson.put("receivedt", receivedDateStr);
					messageJson.put("receivedt2", receivedDateStr2);
					
					// size
					int size = message.getSize();
					
					String mailSize = "";
					
					if (size < 1000) {
						mailSize = size + "B";
					} else {
						size = Math.round((float) size / 1024);
						
						if (size > 1000) {
							size = Math.round((float) size / 1024);
							mailSize = size + "MB";
						} else {
							mailSize = size + "KB";
						}
					}
					
					messageJson.put("size", mailSize);
					
					// read/unread
					int readFlag = message.isSet(Flags.Flag.SEEN) ? 1 : 0;
					messageJson.put("read", readFlag);
					
					if (filter.equals("isUnreadOnly") && readFlag == 1) {
						continue;
					}
					
					if (message.isSet(Flags.Flag.ANSWERED)) {
						messageJson.put("contentclass","REPLY");
					} else {
						boolean isForwarded = ezEmailUtil.hasForwardedFlag(message);
						
						if (isForwarded) {
							messageJson.put("contentclass", "FORWARD");
						} else {
							messageJson.put("contentclass", "IPM.Note");
						}
					}
					
					if (!endDate.equals(receivedDateStr)) {
						messageJsonArray.add(messageJson);
					}
				}
				
				String folderName = folder.getName();
				
				folderName = ezEmailUtil.getDisplayNameFromFolderId(folderName, locale);
				
				folder.close(false);
				
				// set importanceColor
				String importanceColor = "#ff0000";
				MailColorVO mailColor = ezEmailService.getMailColor(info.getTenantId());
				
				if (mailColor != null && mailColor.getImportanceColor() != null) {
					importanceColor = mailColor.getImportanceColor();
				}
				String hackingMailReport = ezCommonService.getTenantConfig("useHackingMailReport", info.getTenantId());

				boolean useHackingMailReport = hackingMailReport.equalsIgnoreCase("YES") ? true : false;

				JSONObject data = new JSONObject();
				
				data.put("messageJsonArray", messageJsonArray);
				data.put("importanceColor", importanceColor);
				data.put("unreadCount", folder.getUnreadMessageCount());
				data.put("fullCount", folder.getMessageCount());
				data.put("optionCount", totalCount);
				data.put("folderName", folderName);
				data.put("includeSubFolders", includeSubFolders);
				data.put("useHackingMailReport", useHackingMailReport);
				
				result.put("status", "ok");
				result.put("code", 0);			
				result.put("data", data);
			}
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");			
		} finally {
			if (ia != null) {
				ia.close();
			}
		}
		
		logger.debug("MOBILE G/W MAIL mMailFolderMailList ended.");		

		return result;
	}
	
	/**
	 * 모바일 G/W 이메일 [GET] 메일 쓰기에 필요한 옵션 정보 조회
	 */
	@RequestMapping(value="/mobile/ezemail/mail-write/option", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	@ResponseBody
	public void mMailWriteOption(HttpServletRequest request) throws Exception {
		logger.debug("MOBILE G/W MAIL mMailWriteOption started.");
//		String serverName = request.getHeader("x-user-host");
//		MCommonVO info = mOptionService.commonInfo(serverName, userId);
		
//		LoginVO loginInfo = commonUtil.userInfo(loginCookie);
//		OrganUserVO userInfo = ezOrganAdminService.getUserInfo(info.getUserId(), info.getLang(), info.getTenantId());
		logger.debug("MOBILE G/W MAIL mMailWriteOption ended.");		
	}
	
	/**
	 * 모바일 G/W 이메일 [POST] 쓰기
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezemail/write/users/{userId:.+}", method= RequestMethod.POST, produces="application/json;charset=utf-8")
	public Object mMailWrite(HttpServletRequest request, @PathVariable String userId, @RequestBody JSONObject jsonObject){
		logger.debug("MOBILE G/W MAIL mMailWrite started.");
		logger.debug("userId=" + userId + ",jsonObject=" + jsonObject);
		
		JSONObject result = new JSONObject();
		IMAPAccess ia = null;
		
		try {
			String orgFromEmail = "";
			String from = "";
			String to = "";
			String cc = "";
			String bcc = "";
			
			//String body = "";
			String tempBody = "";
			String bodyValue = "";
			
			String subject = "";
			String url = "";
			String attach = "";
			String importance = "1";
			String isEach = "FALSE";
			String bodyType = "0";
			String replySendTime = "0";
			String replyReadTime = "";
			String delaySendDate = "";
			String unread = "";
			@SuppressWarnings("unused")
			String reSendFlag = "N";
			String folderPath = "";
						
			String fileUploadType = "";
			String newWindowId = "";
			
			String cmd = "";
			String folderId = "";
			String messageId = "";
			String textOption = "";
			String defaultFontAndSize = "";
			
			// 기본 서명 HTML
			String signValue = "";
			
			if (jsonObject.get("cmd") != null) {
				cmd = (String) jsonObject.get("cmd");
			}
			
			if (jsonObject.get("folderId") != null) {
				folderId = (String) jsonObject.get("folderId");
			}
			
			if (jsonObject.get("messageId") != null) {
				messageId = (String) jsonObject.get("messageId");
			}
			
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			String domainName = ezCommonService.getTenantConfig("DomainName", info.getTenantId());
			String mailAttachLimit = ezCommonService.getTenantConfig("MailAttachLimit", info.getTenantId());
			String totBigSizeMailAttachLimit = ezCommonService.getTenantConfig("totBigSizeMailAttachLimit", info.getTenantId());
			String mUseMailAddrAutoComplete = ezCommonService.getTenantConfig("mobileUseMailAddrAutoComplete", info.getTenantId());
			String isDefaultReceiptExternal = ezCommonService.getTenantConfig("isDefaultReceiptExternal", info.getTenantId());
			String useReceiptExternal = ezCommonService.getTenantConfig("useReceiptExternal", info.getTenantId());
			String useOnlyInnerMail = ezCommonService.getTenantConfig("UseOnlyInnerMail", info.getTenantId());
			String useAutoZipEnc = ezCommonService.getTenantConfig("useAutoZipEnc", info.getTenantId());
			String useFileExtension = ezCommonService.getTenantConfig("USE_FileExtension", info.getTenantId());
			
			// 2025.02.17 한슬기 : 나를 항상 참조에 포함 옵션(none: 사용안함, cc: 참조에 항상 포함, bcc: 숨은참조에 항상 포함)
			MailGeneralVO mailGeneralVO = ezEmailService.getMailGeneral(info.getTenantId(), info.getUserId()).get(0);
			String selfCcOption = mailGeneralVO.getSelfCcOption() == null ? "none" : mailGeneralVO.getSelfCcOption();
			String lang = info.getLang() == null ? "1" : info.getLang();
			String userName = "1".equals(lang) ? info.getUserName() :
					(info.getUserName2() == null || info.getUserName2().isEmpty() ? info.getUserName() : info.getUserName2());
			String deptName = "1".equals(lang) ? info.getDeptName() :
					(info.getDeptName2() == null || info.getDeptName2().isEmpty() ? info.getDeptName() : info.getDeptName2());

			if (useReceiptExternal.equals("YES")) {
				replyReadTime = "YES".equalsIgnoreCase(isDefaultReceiptExternal) ? "2" : "1";
			} else {
				replyReadTime = "1";
			}

			String attachFileNameMaxLength = ezCommonService.getTenantConfig("attachFileNameMaxLength", info.getTenantId());
			if (attachFileNameMaxLength.equals("")) {
				attachFileNameMaxLength = "100"; // default
			}
			OrganUserVO userVO = ezOrganAdminService.getUserInfo(info.getUserId(), info.getPrimary(), info.getTenantId());
			
			String userEmail = info.getUserId() + "@" + domainName;
			String fromEmail = userVO.getMail();
			
			String password = jspw;

			int tenantID = 0;
			tenantID = info.getTenantId();
			
			String ld = commonUtil.getTwoLetterLangFromLangNum(info.getLang());
			Locale locale = new Locale(ld);
			
			String msgto = "";
			
			if (request.getParameter("msgto") != null) {
				msgto = request.getParameter("msgto").trim().replaceAll("&lt;", "<").replaceAll("&gt;", ">").replaceAll("&quot;", "\"");
			}

            if (jsonObject.get("msgTo") != null) {
                msgto = (String) jsonObject.get("msgTo");
            }

			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userEmail, password, egovMessageSource, locale, ezEmailUtil);

			if (ia == null){
				throw new Exception("ia is null");
			}
			ia.makeTopLevelFolders();

			if (!messageId.equals("") && !folderId.equals("")) {
				long uid = 0;

				folderPath = URLDecoder.decode(folderId, "UTF-8");
				
				logger.debug("cmd : " + cmd +", folderId : " + folderId + ", messageId : " +  messageId);
				
				uid = Long.parseLong(messageId);
				
				logger.debug("tenantID=" + tenantID + ",userId=" + userId);
				
				folderPath = ezEmailUtil.getFolderIdFromDisplayName(folderPath, locale);
				
	    		Folder orgFolder = ia.getFolder(folderPath);
	    		orgFolder.open(Folder.READ_ONLY);       
	    		
				// retrieve the Drafts folder name
	        	String draftsFolderName = ezEmailUtil.getDraftsFolderId(locale);
	    		
	        	// retrieve the Sent folder name
	        	String sentFolderName = ezEmailUtil.getSentFolderId(locale);
	        	
	    		// retrieve the specified message.
				Message orgMessage = ((IMAPFolder)orgFolder).getMessageByUID(uid);
				
				if (orgMessage != null) {
					logger.debug("orgMessage not null");
					
					// 20190530 조진호 - 회신, 전체회신, 전달, 임시저장 일 때는 원래의 메일의 text type을 가져온다.
					if(ezEmailUtil.isHtmlMessage(orgMessage)) { 
						textOption = "HTML";
					} else {
						textOption = "PLAIN";
					}
					
		        	// in case of editing a message in Drafts folder.
		        	if (folderPath.equals(draftsFolderName) && cmd.equals("EDIT")) {		        		
		        		if (orgMessage.getFrom() != null && orgMessage.getFrom()[0] != null) {
		        			from = ((InternetAddress)orgMessage.getFrom()[0]).getAddress();
							orgFromEmail = from;
		        		}
		        		
						// retrieve the TO addresses from the message.
						Address[] addresses = orgMessage.getRecipients(Message.RecipientType.TO);
						to = ezEmailUtil.getStringListOfAddresses(addresses, true);
						
						// retrieve the CC addresses from the message.
						addresses = orgMessage.getRecipients(Message.RecipientType.CC);
						cc = ezEmailUtil.getStringListOfAddresses(addresses, true);
						
						// retrieve the BCC addresses from the message.
						addresses = orgMessage.getRecipients(Message.RecipientType.BCC);
						bcc = ezEmailUtil.getStringListOfAddresses(addresses, true);
						
						// retrieve the subject from the message.
						subject = ezEmailUtil.getSubject(orgMessage);
						subject = (subject != null) ? subject : "";
						
						Map<String, Object> extraMap = new HashMap<String, Object>();
						extraMap.put("shareId", info.getUserId());
						
						// analyze the message and retrieve the attached file list.
						List<Map<String, String>> attachedFileList = new ArrayList<Map<String, String>>();
						List<String> bodyInfoList = ezEmailUtil.getBodyInfo(orgMessage, folderPath, uid, -1, attachedFileList, locale, extraMap);					
						tempBody = bodyInfoList.get(0);
						
						if (attachedFileList.size() > 0) {
			                StringBuilder attachXmlList = new StringBuilder("<ROOT><NODES>");	
			                
							for (int i = 0; i < attachedFileList.size(); i++) {
								Map<String, String> fileInfo = attachedFileList.get(i);
								
				                attachXmlList.append("<NODE>");
				                //TODO : <PUPLOADSN>" + (i + 1) + "</PUPLOADSN> 으로 수정(인덱스로 파일 지울 때)
				                attachXmlList.append("<PUPLOADSN>" + EgovStringUtil.getSpclStrCnvr(fileInfo.get("filename")) + "</PUPLOADSN>");
				                attachXmlList.append("<RESULTUPLOADA>true</RESULTUPLOADA>");
				                attachXmlList.append("<PFILENAME>" + EgovStringUtil.getSpclStrCnvr(fileInfo.get("filename")) + "</PFILENAME>");
				                attachXmlList.append("<FILESIZE>" + fileInfo.get("size") + "</FILESIZE>");
				                attachXmlList.append("<FILELOCATION>" + uid + "</FILELOCATION>");
				                attachXmlList.append("<PBIGFILEUPLOAD>N</PBIGFILEUPLOAD>");
				                attachXmlList.append("</NODE>");
							}
							
			                attachXmlList.append("</NODES></ROOT>");						
			                attach = attachXmlList.toString();	
						}
			        // in case of resending						
		        	} else if (folderPath.equals(sentFolderName) && cmd.equals("RESEND") && !msgto.equals("")) {
		        		//임시보관함에 메시지 임시저장
		        		SMTPAccess sa = SMTPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.SMTPPort"),
		        				userEmail, password, info.getEmail());
		        		MimeMessage resendMessage = sa.createMimeMessage();
		        		
		        		resendMessage.setFlag(Flags.Flag.SEEN, true);
		        		
		        		if (orgMessage.isMimeType("multipart/related")) {
			        		MimeMultipart relatedPart = new MimeMultipart("related");
			        		
			        		if (ezEmailUtil.copyInlineParts(orgMessage, relatedPart, false)) {
			        			resendMessage.setContent(relatedPart);
			        		} else {
			        			resendMessage.setText("placeholder");
			        		}	        					        		
	        			} else if (orgMessage.isMimeType("multipart/*")) {
			                MimeMultipart mixedPart = new MimeMultipart();
			                
			                ezEmailUtil.copyAllPartsInMultipart(orgMessage, mixedPart);
			                
			                resendMessage.setContent(mixedPart);	    
	        			} else {
	        				resendMessage.setText("placeholder");
	        			}
		        		
		        		Folder draftsFolder = ia.getFolder(draftsFolderName);
		        		draftsFolder.open(Folder.READ_WRITE);       
		        		long draftUID = 0;
		        		AppendUID[] uids = ((IMAPFolder)draftsFolder).appendUIDMessages(new Message[]{resendMessage});
		        		
		        		if (uids != null && uids[0] != null) {
		        			draftUID = uids[0].uid;
		        		}
		        		
		        		url = String.valueOf(draftUID);
		        		logger.debug("draftUID=" + draftUID);
		        		draftsFolder.close(true);
		        		//END: 임시보관함에 메시지 임시저장
		        		
		        		reSendFlag = "Y";
		        		
		        		Address[] addresses = orgMessage.getAllRecipients();
		        		
		        		for (Address address : addresses) {
		        			if (((InternetAddress)address).getAddress().equalsIgnoreCase(msgto)) {
								to = ezEmailUtil.getStringListOfAddresses(new Address[]{address}, true);
								break;
		        			} else {
                                // 재작성시 메세지에서 발신인, 수신인을 뽑아내어 넣어준다.
                                if (msgto.equals("")) {
                                    addresses = orgMessage.getRecipients(Message.RecipientType.TO);
                                    String[] rawHeaders = orgMessage.getHeader("From");
                                    String rawHeader = rawHeaders != null ? rawHeaders[0] : "";
									orgFromEmail = rawHeader;

                                    boolean isPureAscii = ezEmailUtil.isPureAscii(rawHeader);

                                    if (isPureAscii) {
                                        rawHeaders = orgMessage.getHeader("To");
                                        rawHeader = rawHeaders != null ? rawHeaders[0] : "";
                                        isPureAscii = ezEmailUtil.isPureAscii(rawHeader);
                                    }

                                    to = ezEmailUtil.getStringListOfAddresses(addresses, isPureAscii);

                                    // retrieve the CC addresses from the reply message.
                                    addresses = orgMessage.getRecipients(Message.RecipientType.CC);

                                    if (addresses != null) {
                                        rawHeaders = orgMessage.getHeader("Cc");
                                        rawHeader = rawHeaders != null ? rawHeaders[0] : "";
                                        cc = ezEmailUtil.getStringListOfAddresses(addresses, ezEmailUtil.isPureAscii(rawHeader));
                                    }

                                    // retrieve the BCC addresses from the reply message.
                                    addresses = orgMessage.getRecipients(Message.RecipientType.BCC);
                                    bcc = ezEmailUtil.getStringListOfAddresses(addresses, true);

                                    break;
                                }
                            }
		        		}
		        		
		        		subject = orgMessage.getSubject();
						subject = (subject != null) ? subject : "";
						
						Map<String, Object> extraMap = new HashMap<String, Object>();
						extraMap.put("shareId", info.getUserId());
						
						List<Map<String, String>> attachedFileList = new ArrayList<Map<String, String>>();		            
						List<String> bodyInfoList = ezEmailUtil.getBodyInfo(orgMessage, folderPath, uid, -1, attachedFileList, locale, extraMap);					
						bodyValue = bodyInfoList.get(0);
		        		
		        		if (attachedFileList.size() > 0) {
			                StringBuilder attachXmlList = new StringBuilder("<ROOT><NODES>");	
			                
							for (int i = 0; i < attachedFileList.size(); i++) {
								Map<String, String> fileInfo = attachedFileList.get(i);
								
				                attachXmlList.append("<NODE>");
				                //TODO : <PUPLOADSN>" + (i + 1) + "</PUPLOADSN> 으로 수정(인덱스로 파일 지울 때)
				                attachXmlList.append("<PUPLOADSN>" + EgovStringUtil.getSpclStrCnvr(fileInfo.get("filename")) + "</PUPLOADSN>");
				                attachXmlList.append("<RESULTUPLOADA>true</RESULTUPLOADA>");
				                attachXmlList.append("<PFILENAME>" + EgovStringUtil.getSpclStrCnvr(fileInfo.get("filename")) + "</PFILENAME>");
				                attachXmlList.append("<FILESIZE>" + fileInfo.get("size") + "</FILESIZE>");
				                attachXmlList.append("<FILELOCATION>" + uid + "</FILELOCATION>");
				                attachXmlList.append("<PBIGFILEUPLOAD>N</PBIGFILEUPLOAD>");
				                attachXmlList.append("</NODE>");
							}
							
			                attachXmlList.append("</NODES></ROOT>");						
			                attach = attachXmlList.toString();				                
						}
		        		
		                unread = orgMessage.isSet(Flags.Flag.SEEN) ? "1" : "0";
		                
		                //this._posttype = ((int)orgmesg.Sensitivity).ToString();
			        // in case of replying		        		
		        	} else if (cmd.equals("REPLY") || cmd.equals("REPLYALL") || cmd.equals("FORWARD")) {
		        		Message replyMessage = null; 
		        		
		        		// reply call is needed to create 'References' & 'In-Reply-To' headers.
		        		if (cmd.equals("REPLY") || cmd.equals("FORWARD")) {
		        			replyMessage = orgMessage.reply(false);
		        		} else {
		        			replyMessage = orgMessage.reply(true);
		        		}
		        		
		        		// ANSWERED flag needs to be cleared since the above reply method sets it.
		        		orgMessage.setFlag(Flags.Flag.ANSWERED, false);
		        		
		        		replyMessage.setFlag(Flags.Flag.SEEN, true);
	
		        		if (cmd.equals("FORWARD")) {
		        			if (orgMessage.isMimeType("multipart/related")) {
				        		MimeMultipart relatedPart = new MimeMultipart("related");
				        		
				        		if (ezEmailUtil.copyInlineParts(orgMessage, relatedPart, true)) {
				        			replyMessage.setContent(relatedPart);
				        		} else {
				        			replyMessage.setText("placeholder");
				        		}	        					        		
		        			} else if (orgMessage.isMimeType("multipart/*")) {
				        		boolean isThereHtmlPart = ezEmailUtil.hasHtmlPart(orgMessage);
				        		// text/html 파트가 없으면 인라인 이미지 파트를 첨부파일 파트로 변환한다.(이미지를 첨부로 대신 표시하기 위해)
				        		boolean convertInlineImageToAttachment = isThereHtmlPart ? false : true;
				        		
				        		logger.debug("convertInlineImageToAttachment=" + convertInlineImageToAttachment);
		        						        				
				                MimeMultipart mixedPart = new MimeMultipart();
				                
				                ezEmailUtil.copyAllPartsInMultipart(orgMessage, mixedPart, convertInlineImageToAttachment);
				                
				                replyMessage.setContent(mixedPart);	    
		        			} else {
		        				replyMessage.setText("placeholder");
		        			}
		        		} else {
			        		MimeMultipart relatedPart = new MimeMultipart("related");
			        		
			        		if (ezEmailUtil.copyInlineParts(orgMessage, relatedPart, false)) {
			        			replyMessage.setContent(relatedPart);
			        		} else {
			        			replyMessage.setText("placeholder");
			        		}	        		
		        		}
	
		        		defaultFontAndSize = "style='font-size:13px;font-family:" + egovMessageSource.getMessage("main.t246", locale) + "'";
		        		
		        		//사용자 언어가 한국어이고 editorFontStyle값이 있을 경우 editorFontStyle값 적용
		        		if (info.getLang().equals("1")) {
		        			String editorFontStyle = ezCommonService.getTenantConfig("editorFontStyle", info.getTenantId());
		        			
		        			if (!editorFontStyle.equals("")) {
		        				String fontFamily = editorFontStyle.split("\\|")[0];
		        				String fontSize = editorFontStyle.split("\\|")[1];
		        				
		        				defaultFontAndSize = "style='font-size:" + fontSize + ";font-family:" + fontFamily + "'";
		        			}
		        		}
		        		
		        		Address[] addresses = null;
		        		
		        		if (cmd.equals("REPLY") || cmd.equals("REPLYALL")) {
							// retrieve the TO addresses from the reply message.
							addresses = replyMessage.getRecipients(Message.RecipientType.TO);
							String[] rawHeaders = orgMessage.getHeader("From");
							String rawHeader = rawHeaders != null ? rawHeaders[0] : "";		
							boolean isPureAscii = ezEmailUtil.isPureAscii(rawHeader);
							
							if (isPureAscii) {
								rawHeaders = orgMessage.getHeader("To");
								rawHeader = rawHeaders != null ? rawHeaders[0] : "";
								isPureAscii = ezEmailUtil.isPureAscii(rawHeader);
							}
							
							to = ezEmailUtil.getStringListOfAddresses(addresses, isPureAscii);
	
							// retrieve the CC addresses from the reply message.
							addresses = replyMessage.getRecipients(Message.RecipientType.CC);
							
							if (addresses != null) {
								rawHeaders = orgMessage.getHeader("Cc");
								rawHeader = rawHeaders != null ? rawHeaders[0] : "";																					
								cc = ezEmailUtil.getStringListOfAddresses(addresses, ezEmailUtil.isPureAscii(rawHeader));
							}
							
							// retrieve the BCC addresses from the reply message.
							addresses = replyMessage.getRecipients(Message.RecipientType.BCC);
							bcc = ezEmailUtil.getStringListOfAddresses(addresses, true);
		        		}
						
						// retrieve the subject from the message.
						subject = ezEmailUtil.getSubject(orgMessage);
						
						if (subject != null && !subject.equals("")) {
							String[] rawHeaders = orgMessage.getHeader("subject");
							String rawHeader = rawHeaders[0];
							
							// if the subject contains Non-Ascii characters(violating the standard), 
							// try to decode it by examining the characters.							
							if (!ezEmailUtil.isPureAscii(rawHeader)) {
								byte[] rawBytes = rawHeader.getBytes("iso-8859-1");
								
								subject = ezEmailUtil.decodeNonAsciiBytes(rawBytes);
							}
						}
						
						subject = (subject != null) ? subject : "";
						String reStr = ""; 
								
						if (cmd.equals("REPLY") || cmd.equals("REPLYALL")) {		
							reStr = egovMessageSource.getMessage("ezEmail.t5111", locale);
						} else if (cmd.equals("FORWARD")) {
							reStr = egovMessageSource.getMessage("ezEmail.t5131", locale);
						}
						
						if (!subject.startsWith(reStr)) {
							subject = reStr + ": " + subject;
						}
		        		
						// retrieve the TO addresses from the original message.
						addresses = orgMessage.getRecipients(Message.RecipientType.TO);
						String[] rawHeaders = orgMessage.getHeader("To");
						String rawHeader = rawHeaders != null ? rawHeaders[0] : "";													
						String orgTo = ezEmailUtil.getStringListOfAddresses(addresses, ezEmailUtil.isPureAscii(rawHeader));
						
						// retrieve the CC addresses from the original message.
						addresses = orgMessage.getRecipients(Message.RecipientType.CC);
						rawHeaders = orgMessage.getHeader("Cc");
						rawHeader = rawHeaders != null ? rawHeaders[0] : "";																			
						String orgCc = ezEmailUtil.getStringListOfAddresses(addresses, ezEmailUtil.isPureAscii(rawHeader));
						
			            StringBuilder sb = new StringBuilder();
			            
			            //set received date
			            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss ( z )");
			            String offset = info.getOffSet();
			            
			            if (offset == null || offset.indexOf("|") == -1) {
			    			logger.error("Check the offset. Offset is null or offset format is wrong.");
			    		} else {
			    			String[] offsetArr = offset.split("\\|");
			    			sdf.setTimeZone(TimeZone.getTimeZone("GMT" + offsetArr[1]));
			    		}
			            
			            
			            String orgMessageSubject = ezEmailUtil.getSubject(orgMessage);	
			            
						if (orgMessageSubject != null && !orgMessageSubject.equals("")) {
							rawHeaders = orgMessage.getHeader("subject");
							rawHeader = rawHeaders[0];
							
							// if the subject contains Non-Ascii characters(violating the standard), 
							// try to decode it by examining the characters.							
							if (!ezEmailUtil.isPureAscii(rawHeader)) {
								byte[] rawBytes = rawHeader.getBytes("iso-8859-1");
								
								orgMessageSubject = ezEmailUtil.decodeNonAsciiBytes(rawBytes);
							}
						}	
						
						sb.append("<hr tabindex=\"-1\">");
						if (textOption.equalsIgnoreCase("HTML")) {
				            sb.append(String.format("<p " + defaultFontAndSize + "><b>%s : </b> %s</p>", egovMessageSource.getMessage("ezEmail.t703", locale), EgovStringUtil.getSpclStrCnvr(ezEmailUtil.getFullFromAddressOfMessage(orgMessage))));
							sb.append(String.format("<p " + defaultFontAndSize + "><b>%s : </b> %s</p>", egovMessageSource.getMessage("ezEmail.t704", locale), sdf.format(orgMessage.getReceivedDate()).replace("GMT", "")));
				            sb.append(String.format("<p " + defaultFontAndSize + "><b>%s : </b> %s</p>", egovMessageSource.getMessage("ezEmail.t705", locale), EgovStringUtil.getSpclStrCnvr(orgTo)));
				            sb.append(String.format("<p " + defaultFontAndSize + "><b>%s : </b> %s</p>", egovMessageSource.getMessage("ezEmail.t706", locale), EgovStringUtil.getSpclStrCnvr(orgCc)));
							sb.append(String.format("<p " + defaultFontAndSize + "><b>%s : </b> %s</p><br/><br/>", egovMessageSource.getMessage("ezEmail.t707", locale), EgovStringUtil.getSpclStrCnvr(orgMessageSubject)));
							
						} else if (textOption.equalsIgnoreCase("PLAIN")) {
							defaultFontAndSize = "style='font-size:13px;font-family:" + egovMessageSource.getMessage("main.t246", locale) + "'";
							sb.append("<p " + defaultFontAndSize + ">&nbsp;</p>");
				            sb.append(String.format("<p " + defaultFontAndSize + ">%s :  %s</p>", egovMessageSource.getMessage("ezEmail.t703", locale), EgovStringUtil.getSpclStrCnvr(ezEmailUtil.getFullFromAddressOfMessage(orgMessage))));
							sb.append(String.format("<p " + defaultFontAndSize + ">%s :  %s</p>", egovMessageSource.getMessage("ezEmail.t704", locale), sdf.format(orgMessage.getReceivedDate()).replace("GMT", "")));
				            sb.append(String.format("<p " + defaultFontAndSize + ">%s :  %s</p>", egovMessageSource.getMessage("ezEmail.t705", locale), EgovStringUtil.getSpclStrCnvr(orgTo)));
				            sb.append(String.format("<p " + defaultFontAndSize + ">%s :  %s</p>", egovMessageSource.getMessage("ezEmail.t706", locale), EgovStringUtil.getSpclStrCnvr(orgCc)));
							sb.append(String.format("<p " + defaultFontAndSize + ">%s :  %s</p><br/><br/>", egovMessageSource.getMessage("ezEmail.t707", locale), EgovStringUtil.getSpclStrCnvr(orgMessageSubject)));
							
						}
						
						Map<String, Object> extraMap = new HashMap<String, Object>();
						extraMap.put("shareId", info.getUserId());
						
						// analyze the message and retrieve the attached file list.
						List<Map<String, String>> attachedFileList = new ArrayList<Map<String, String>>();		            
						List<String> bodyInfoList = ezEmailUtil.getBodyInfo(orgMessage, folderPath, uid, -1, attachedFileList, locale, extraMap);					
						String tmphtmlbody = bodyInfoList.get(0);
			            
						bodyValue = sb.toString() + tmphtmlbody;
			            
			            // 원본 메일 내용에 메일 서명 존재 시 변환 처리
		                if (bodyValue.contains("id=\"MailSignSent\"") || bodyValue.contains("id=MailSignSent")) {
		                	bodyValue = bodyValue.replaceAll("MailSignSent", "MailSignSent___send");
		                	bodyValue = bodyValue.replaceAll("kaoni_sign1", "kaoni_sign1___send");
		                	bodyValue = bodyValue.replaceAll("kaoni_sign2", "kaoni_sign2___send");
		                	bodyValue = bodyValue.replaceAll("kaoni_sign3", "kaoni_sign3___send");
		                }
		                
		                bodyValue = bodyValue.replaceAll("ORGMAIL_CONTENT", "ORGMAIL_CONTENT___send");
		                bodyValue = bodyValue.replaceAll("div id=\"MailSign\"", "div ");
		                
		                bodyValue = bodyValue.replaceAll("id=msgbody", "");
	
		                if (cmd.equals("REPLY") || cmd.equals("REPLYALL") || cmd.equals("FORWARD")) {
		                	bodyValue = bodyValue.replaceAll("class=&quot;FIELD&quot;", "");
		                	bodyValue = bodyValue.replaceAll("class=FIELD", "");
		                	if (textOption.equalsIgnoreCase("HTML")) {
		                		bodyValue = "<body free>" + bodyValue + "</body>";
							}
		                }
		                
		                //임시보관함에 저장
		        		Folder draftsFolder = ia.getFolder(draftsFolderName);
		        		draftsFolder.open(Folder.READ_WRITE);       
		        		
		        		long draftUID = 0;
		        		AppendUID[] uids = ((IMAPFolder)draftsFolder).appendUIDMessages(new Message[]{replyMessage});
		        		
		        		if (uids != null && uids[0] != null) {
		        			draftUID = uids[0].uid;
		        		}
		        		
		        		url = String.valueOf(draftUID);
		        		
		        		logger.debug("draftUID=" + draftUID);
		        		
		        		draftsFolder.close(true);
		                
		        		//첨부파일 정보 추출
		        		if (cmd.equals("FORWARD")) {
							if (attachedFileList.size() > 0) {
				                StringBuilder attachXmlList = new StringBuilder("<ROOT><NODES>");	
				                
								for (int i = 0; i < attachedFileList.size(); i++) {
									Map<String, String> fileInfo = attachedFileList.get(i);
									
					                attachXmlList.append("<NODE>");
					                //TODO : <PUPLOADSN>" + (i + 1) + "</PUPLOADSN> 으로 수정(인덱스로 파일 지울 때)
					                attachXmlList.append("<PUPLOADSN>" + EgovStringUtil.getSpclStrCnvr(fileInfo.get("filename")) + "</PUPLOADSN>");
					                attachXmlList.append("<RESULTUPLOADA>true</RESULTUPLOADA>");
					                attachXmlList.append("<PFILENAME>" + EgovStringUtil.getSpclStrCnvr(fileInfo.get("filename")) + "</PFILENAME>");
					                attachXmlList.append("<FILESIZE>" + fileInfo.get("size") + "</FILESIZE>");
					                attachXmlList.append("<FILELOCATION>" + uid + "</FILELOCATION>");
					                attachXmlList.append("<PBIGFILEUPLOAD>N</PBIGFILEUPLOAD>");
					                attachXmlList.append("</NODE>");
								}
								
				                attachXmlList.append("</NODES></ROOT>");						
				                attach = attachXmlList.toString();				                
							}											            	
			            }		        		
		        	}
		        	
		        	//set importance
		        	if (cmd.equals("EDIT")) {
		        		logger.debug("EDIT MODE : set mail option start");
		        		
		        		if (orgMessage.getHeader("X-Priority") != null) {
		        			String tempImportance = orgMessage.getHeader("X-Priority")[0];
		        			
		        			if (tempImportance.equals("1")) {
		        				importance = "2";
		        			} else if (tempImportance.equals("5")) {
		        				importance = "0";
		        			} else {
		        				importance = "1";
		        			}
		        		}
		        		
		        		logger.debug("importance=" + importance);
		        	
		        		//set isEachMail
		        		if (orgMessage.getHeader("X-JMocha-Each-Mail") != null) {
		        			isEach = orgMessage.getHeader("X-JMocha-Each-Mail")[0];
		        		}
		        		
		        		//set bodyType
		        		if (orgMessage.getHeader("Content-Type") != null) {
		        			String tempBodyType = orgMessage.getHeader("Content-Type")[0];
		        			
		        			if (tempBodyType.split(";")[0].trim().equals("text/plain")) {
		        				bodyType = "1";
		        			} else if ( tempBodyType.split(";")[0].trim().equals("multipart/alternative")) {
		        				bodyType = "0";
		        			}
		        		}
		        		
		        		if (orgMessage.getHeader("Return-Receipt-To") != null) {
		        			replySendTime = "1";
		        		} else {
		        			replySendTime = "0";
		        		}

						if (orgMessage.getHeader("X-JMocha-Disp-Noti-To") == null) {
							replyReadTime = "0";
						}
		        	
		        		if (orgMessage.getHeader("Delivery-Date") != null) {
		        			delaySendDate = orgMessage.getHeader("Delivery-Date")[0].trim();
		        		} else {
		        			delaySendDate = "";
		        		}
		        		
		        		logger.debug("EDIT MODE : set mail option end");
		        	}
				}
				
				orgFolder.close(true);
			}
			
			// 발신가능한 메일주소 리스트
			String useFromAddress = StringUtils.defaultIfBlank(ezCommonService.getTenantConfig("Use_FromAddress", info.getTenantId()), "NO");
			String useDistributionSender = StringUtils.defaultIfBlank(ezCommonService.getCompanyConfig(info.getTenantId(), info.getCompanyId(), "useDistributionSender"), "NO");
			JSONArray jsonList = new JSONArray();
			List<String[]> fromAddressList = new ArrayList<>();

			if ("YES".equalsIgnoreCase(useFromAddress) || "YES".equalsIgnoreCase(useDistributionSender)) {
				fromAddressList = ezEmailService.getAliasAddress(info.getUserId(), info.getTenantId(), useFromAddress, useDistributionSender);
			}
			// useFromAddress이 NO인 경우에는 primary mail 주소를 jgw에서 가져오지 않기 때문에 추가 함
			if ("NO".equalsIgnoreCase(useFromAddress)) {
				fromAddressList.add(0, new String[]{info.getEmail(),"",""});
			}

			// 모바일에서 primary로 select할 수 있도록 type 값 변경 : primary, alias
			for (String[] address : fromAddressList) {
				if (info.getEmail().trim().equals(address[0])) {
					address[1] = "p"; //primary
				} else {
					address[1] = "a"; //alias
				}
			}

			// jsonList에 key:value 형태로 입력
			for (String[] address : fromAddressList) {
				JSONObject json = new JSONObject();
				json.put("email", address[0]);
				json.put("type", address[1]);
				json.put("name", address[2]);
				jsonList.add(json);
			}
			// 발신가능한 메일주소 리스트 end

			/*String fromAddressHtml = "";
			
			if (useFromAddress != null) {
				if ("YES".equalsIgnoreCase(useFromAddress) || "YES".equalsIgnoreCase(useDistributionSender)) {
					List<String[]> fromAddressList = ezEmailService.getAliasAddress(info.getUserId(), info.getTenantId(), useFromAddress, useDistributionSender);
					
					if (fromAddressList.size() < 2) {
						useFromAddress = "NO";
					} else {
						StringBuilder sb = new StringBuilder();
						sb.append("<select id='ex_select' onchange='fromAddressChange(this.value)'>");
						
						boolean isValidFrom = false;
						
						for (String[] address : fromAddressList) {
							if (from.equals(address[0])) {
								isValidFrom = true;
								break;
							}
						}
						
						if (!isValidFrom) {
							from = userEmail;
						}
						
						for (String[] address : fromAddressList) {
							if (from.equals(address[0])) {
								sb.append("<option value='" + address[0] + "' selected>" + address[0] + "</option>");
							} else {
								sb.append("<option value='" + address[0] + "'>" + address[0] + "</option>");
							}
						}
						
						sb.append("</select>");
						sb.append("<label for='ex_select'>" + from + "</label>");
						
						fromAddressHtml = sb.toString();
					}
				}
			} else {
				useFromAddress = "NO";
			}*/
			
			String dotNetIntegration = ezCommonService.getTenantConfig("dotNetIntegration", info.getTenantId());
			
			if (dotNetIntegration.equals("YES")) {
				String mobileDownloadInline = config.getProperty("config.MobileDownloadInline");
							
				if (bodyValue != null && !bodyValue.isEmpty()) {
					bodyValue = bodyValue.replace("/ezEmail/downloadInline.do", mobileDownloadInline);
				}
				
				if (tempBody != null && !tempBody.isEmpty()) {
					tempBody = tempBody.replace("/ezEmail/downloadInline.do", mobileDownloadInline);
				}
			}
			
			MailSignatureVO mailSignature = ezEmailService.getMailSignature(tenantID, info.getUserId());
			String mailSignUseFlag = Optional.ofNullable(mailSignature)
					.map(MailSignatureVO::getUseFlag)
					.orElse("0");

			switch (mailSignUseFlag) {
			case "1":
				signValue = mailSignature.getContent1();
				break;
			case "2":
				signValue = mailSignature.getContent2();
				break;
			case "3":
				signValue = mailSignature.getContent3();
				break;
			}
			
			signValue = convertFilerootToMobileDownloadURL(signValue);

			JSONObject data = new JSONObject();
	        data.put("orgFromEmail",orgFromEmail);
	        data.put("fromEmail",fromEmail);
	        data.put("fromAddressList",jsonList);
			data.put("to", to);
			data.put("cc", cc);
			data.put("bcc", bcc);
			data.put("subject", subject);
			data.put("encodedSubject", EgovStringUtil.getSpclStrCnvr(subject));
			data.put("url", url);
			data.put("attach", attach);
			data.put("folderPath", folderPath);
			data.put("importance", importance);
			data.put("isEach", isEach);
			data.put("bodyType", bodyType);
			data.put("replySendTime", replySendTime);
			data.put("replyReadTime", replyReadTime);
			data.put("delaySendDate", delaySendDate);
			data.put("unread", unread);
			data.put("bodyValue", bodyValue);
			data.put("fileUploadType", fileUploadType);
			data.put("tempBody", tempBody);
			data.put("newWindowId", newWindowId);
			data.put("serverName", serverName);
			data.put("useFromAddress", useFromAddress);
			//data.put("fromAddressHtml", fromAddressHtml);
			data.put("mailAttachLimit", mailAttachLimit);
			data.put("useOnlyInnerMail", useOnlyInnerMail);
			data.put("useReceiptExternal", useReceiptExternal);
			data.put("isDefaultReceiptExternal", isDefaultReceiptExternal);
			data.put("mUseMailAddrAutoComplete", mUseMailAddrAutoComplete); //20180712 조진호 - 모바일에서 수신자 자동완성기능 사용여부
			data.put("attachFileNameMaxLength", attachFileNameMaxLength); //20190114 조진호 - 첨부파일명 길이제한
			data.put("defaultFontAndSize", defaultFontAndSize); //20190510 조진호 - 기본 글씨 속성
			data.put("textOption", textOption); //20190530 조진호 - textMode
			data.put("signUseFlag", mailSignUseFlag); // 기본 서명 플래그 값
			data.put("signValue", signValue); // 기본 서명 HTML
			data.put("totBigSizeMailAttachLimit", totBigSizeMailAttachLimit);// 대용량 첨부파일의 최대 크기
			data.put("useAutoZipEnc", useAutoZipEnc);// 메일쓰기창 첨부파일 업로드 zip 암호 설정 여부
			data.put("selfCcOption", selfCcOption); // 나를 항상 참조에 포함 옵션(none: 사용안함, cc: 참조에 항상 포함, bcc: 숨은참조에 항상 포함)
			data.put("userName", userName);
			data.put("deptName", deptName);
			data.put("useFileExtension", useFileExtension);
			
	        result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", data);			
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			
			if (e.getMessage().indexOf("NO APPEND failed.") > -1) {
//				model.addAttribute("overQuota", true);
				
				result.put("status", "error");
				result.put("code", 1);			
				result.put("data", "");
			}
		} finally {
			if (ia != null) {
				ia.close();        	
			}
		}

		logger.debug("MOBILE G/W MAIL mMailWrite ended.");	
		
		return result;
	}
	
	/**
	 * 모바일 G/W 이메일 [POST] 첨부파일 업로드
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezemail/mails/attachs/users/{userId:.+}", method= RequestMethod.POST, produces="application/json;charset=utf-8")
	public Object mMailFileUpload(HttpServletRequest request, @PathVariable String userId, @RequestBody JSONObject jsonObject) throws Exception {
		logger.debug("MOBILE G/W MAIL mMailFileUpload started.");
		logger.debug("userId=" + userId);

//		logger.debug("####" + jsonObject.toJSONString() +"####");
		
		JSONParser jp = new JSONParser();
		jsonObject = (JSONObject) jp.parse(jsonObject.toJSONString());
		
		JSONObject result = new JSONObject();
		
		try {
			String tempFolderName = "";
			String zipPassword = jsonObject.get("zipPassword") != null ? (String) jsonObject.get("zipPassword") : "";
			boolean zipFileUploadCheck = false;
			boolean checkZipFileEncrypted = false;
			boolean needZipEncryption = zipPassword != null && !zipPassword.isEmpty();
			JSONArray fileArray = new JSONArray();
			int cnt = 0;
			//int maxsize = 10*1024*1024; // 10MB
			
			if (jsonObject.get("tempFolderName") != null) {
				tempFolderName = (String) jsonObject.get("tempFolderName");
			}
			
			if (jsonObject.get("fileArray") != null) {
				fileArray = (JSONArray) jsonObject.get("fileArray");
			}
			
			if (jsonObject.get("cnt") != null) {
				cnt =  ((Long) jsonObject.get("cnt")).intValue();
			}
		/*
			if (jsonObject.get("maxsize") != null) {
				maxsize =  ((Long) jsonObject.get("maxsize")).intValue();
			}
		*/
			logger.debug("####" + tempFolderName + "####");
			logger.debug("####" + cnt + "####");
			logger.debug("####" + zipPassword + "####");
//			logger.debug("####" + maxsize + "####");
			
			String serverName = request.getHeader("x-user-host");
			
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			
			String strXML = "";
			String strXML2 = "";
			String xmlList = "";
			String realPath = commonUtil.getRealPath(request);
			String[] pFileName = new String[cnt];
			Long[] fileSize = new Long[cnt];
			String[] fileLocation = new String[cnt];
			String[] resultUpload = new String[cnt];
			String[] sGUID = new String[cnt];
			String[] sFileTitle = new String[cnt];
			String[] sExt = new String[cnt];
			String pDirTempPath = "";
			long totalFileSize = 0; // 첨부파일 총 용량을 체크할 변수

			String useExtension = ezCommonService.getTenantConfig("USE_FileExtension", info.getTenantId());
			String useAutoZipEnc = ezCommonService.getTenantConfig("useAutoZipEnc", info.getTenantId());
		
			if (useExtension == null) {
				useExtension = "";
			}
		
			if (((JSONObject)fileArray.get(0)).get("originalFilename") != null && StringUtils.isNotBlank((String)((JSONObject)fileArray.get(0)).get("originalFilename"))) {
				boolean isEmpty = false;
				String _pFileName = "";
				
				for (int i = 0; i < cnt; i++) {
					_pFileName = (String) ((JSONObject)fileArray.get(i)).get("originalFilename");
					
					// 폴더 패스를 제외한 파일명을 구한다.
					if (_pFileName.indexOf(commonUtil.separator) > 0) {
						_pFileName = _pFileName.split(commonUtil.separator)[_pFileName.split(commonUtil.separator).length - 1];
					}
					
					pFileName[i] = _pFileName;
					
					// 확장자를 구한다.
					if (pFileName[i].lastIndexOf(".") > -1) {
						sFileTitle[i] = pFileName[i].substring(0, pFileName[i].lastIndexOf("."));
						sExt[i] = pFileName[i].substring(pFileName[i].lastIndexOf(".") + 1);
					} else {
						sFileTitle[i] = pFileName[i];
						sExt[i] = "";
					}

					if(sExt[i].equals("zip")) {
						zipFileUploadCheck = true;
					}
					
					if (((Long)((JSONObject)fileArray.get(i)).get("fileSize")).intValue() == 0) {
						isEmpty = true;
						break;
					}
					totalFileSize += ((Long)((JSONObject)fileArray.get(i)).get("fileSize")).intValue() ;
				}
				
				if (isEmpty) {
					return "OVERFLOW";
				}
			}

			// 대용량 첨부 파일 크기 제한보다 첨부 파일 총 용량이 높을 경우 다운로드를 실행하지 않는다.
			long bigMaxSize = 0;
			String bigMaxSizeStr = ezCommonService.getTenantConfig("totBigSizeMailAttachLimit", info.getTenantId());
			bigMaxSize = Long.parseLong(bigMaxSizeStr)*1024*1024; // mega byte -> byte

			if (bigMaxSize != 0 && totalFileSize > bigMaxSize) {
				logger.debug("totalFileSize is over bigMaxSize. Return OVERFLOW.");
				return "OVERFLOW";
			}

			// 각 파일마다 저장할 파일명으로 사용할 UUID를 할당하고 원 파일의 확장자를 붙인다.
			for (int i = 0; i < cnt; i++) {
				sGUID[i] = UUID.randomUUID().toString() + "." + sExt[i];
			}

			strXML = "<ROOT><NODES>";
			String pDirPath = commonUtil.getUploadPath("upload_mail.ROOT", info.getTenantId());
			pDirPath = realPath + pDirPath;
		
			// check the upload mail root folder and create it if it doesn't exist.
			File uploadMailRootFolder = new File(pDirPath);
			
			if (!uploadMailRootFolder.exists()) {
				logger.debug("creating uploadMailRootFolder=" + uploadMailRootFolder);
				
				uploadMailRootFolder.mkdirs();
			}

			// bigSizeMailAttachLimit : 메일의 일반 첨부파일이 대용량 첨부파일로 변경되는 크기
			long bigSizeMailAttachLimit = 0;
			String bigSizeMailAttachLimitStr = ezCommonService.getTenantConfig("BigSizeMailAttachLimit", info.getTenantId());
			bigSizeMailAttachLimit = Long.parseLong(bigSizeMailAttachLimitStr)*1024*1024; // mega byte -> byte

			// 일반 첨부파일 총용량을 넘어섰을 경우, 에러 메시지와 구분자를 보내준다.
			if (totalFileSize > bigSizeMailAttachLimit) {
				result.put("status", "error");
				result.put("code", 1);
				result.put("isBigYN", "Y");

				logger.debug("In case of big attachment. resutle = {}", result);

				return result;
				// 일반 첨부 파일
			} else {
				logger.debug("In case of common attachment.");

				for (int i = 0; i < cnt; i++) {
					fileSize[i] = (Long) ((JSONObject)fileArray.get(i)).get("fileSize");

					pDirTempPath = pDirPath + commonUtil.separator + "tempFileUpload";

					File f = new File(pDirTempPath); // tempFileUpload 만들어주고

					if (!f.exists()) {
						f.mkdirs();
					}

					// 허용하는 확장자가 아닌 경우 저장하지 않는다.
					// dhlee : 20220527 - 파일 업로드 시 .으로 끝나는 파일(예: .jsp.)이 무조건 업로드 허용되는 문제 수정
					if ((sExt[i].isEmpty() || useExtension.toLowerCase().indexOf(sExt[i].toLowerCase()) == -1) && !useExtension.equals("*")) {
						resultUpload[i] = "denied";
					} else {
						// 업로드된 파일 데이터를 위에서 할당한 UUID를 이름으로 하는 파일로 저장한다.
						mobileMailWriteUploadedFile((String)((JSONObject)fileArray.get(i)).get("bytes"), sGUID[i], pDirTempPath);

						fileLocation[i] = pDirTempPath + commonUtil.separator + sGUID[i];
						resultUpload[i] = "true";

						if(useAutoZipEnc.equals("YES")) {
							File f1 = new File(fileLocation[i]);

							if (zipFileUploadCheck) {
								checkZipFileEncrypted = ezEmailUtil.checkZipEncrypted(f1);
							}

							if (needZipEncryption && !checkZipFileEncrypted) {
								String zipPath = ezEmailUtil.createEncryptZipFile(f1, pFileName[i], zipPassword, pDirTempPath);

								if (zipPath != null) {
									fileLocation[i] = zipPath;  // 암호화된 zip 경로로 업데이트
									pFileName[i] = new File(zipPath).getName();
								}
							}
						}
					}

					String pBigFileUpload = "N";

					boolean isAutoZipEnc = !checkZipFileEncrypted && "YES".equals(useAutoZipEnc);
					String fileIdentifier = isAutoZipEnc ? pFileName[i] : sGUID[i];

					strXML2 += "<NODE><PUPLOADSN><![CDATA[" + fileIdentifier + "]]></PUPLOADSN>";
					strXML2 += "<RESULTUPLOADA><![CDATA[" + resultUpload[i] + "]]></RESULTUPLOADA>";
					strXML2 += "<PFILENAME><![CDATA[" + pFileName[i] + "]]></PFILENAME>";
					strXML2 += "<FILESIZE><![CDATA[" + fileSize[i] + "]]></FILESIZE>";
					strXML2 += "<FILELOCATION><![CDATA[" + fileIdentifier + "]]></FILELOCATION>";
					strXML2 += "<PBIGFILEUPLOAD><![CDATA[" + pBigFileUpload + "]]></PBIGFILEUPLOAD>";
					
					if (zipFileUploadCheck) {
						strXML2 += "<CHECKZIPENCRYPTED><![CDATA[" + checkZipFileEncrypted + "]]></CHECKZIPENCRYPTED>";
					}
					
					strXML2 += "</NODE>";

					pDirTempPath = "";
				}
			}
			
			strXML += strXML2 + "</NODES></ROOT>";

			String xmlPath = pDirPath + commonUtil.separator + "templist";
	        File f = new File(xmlPath);
	        
	        if (!f.exists()) {
				f.mkdirs();
	        }

	        // 클라이언트가 지정한 UUID인 tempFolderName을 이름으로 하는 첨부파일 목록 저장용 파일을 구한다.
	        xmlPath += commonUtil.separator + tempFolderName + ".txt";
	        
	        logger.debug("###" + xmlPath + "###");
	        
	        f = new File(xmlPath);
	        
	        if (f.exists()) {
	        	String tempXmlList = "";
	        	
	        	try (InputStreamReader isr = new InputStreamReader(new FileInputStream(f)); 
	        			BufferedReader br = new BufferedReader(isr)) {
		        	int read = 0;
		        	
					while ((read = br.read()) != -1) {
						tempXmlList += (char)read;
					}
					
					Document xmldom = commonUtil.convertStringToDocument(tempXmlList);
					Document xmldom2 = commonUtil.convertStringToDocument(strXML);
	
		            NodeList nodeList = xmldom.getElementsByTagName("NODES");
		            NodeList nodeList2 = xmldom2.getElementsByTagName("NODE");
		            
		            for (int i = 0; i < nodeList2.getLength(); i++) {
		            	nodeList.item(0).appendChild(xmldom.importNode(nodeList2.item(i), true));
		            }
		            
					try (OutputStreamWriter osw = new OutputStreamWriter(new FileOutputStream(f))) {
						osw.write(commonUtil.convertDocumentToString(xmldom));
						String crlf = System.getProperty("line.separator");
						osw.append(crlf + crlf);
					} catch (Exception ex) {
						throw ex;
					}
		            
		            xmlList = strXML;		            
	        	} catch(Exception e) {
	        		logger.error(e.getMessage(), e);
	        		
	        		result.put("status", "error");
	    			result.put("code", 1);			
	    			result.put("data", "");	
	        	} finally {
	        		/*if (br != null) {
	        			br.close();
	        		}
	        		
	        		if (isr != null) {
	        			isr.close();
	        		}
	        		
	        		if (osw != null) {
	        			osw.close();
	        		}*/
	        	}	        	
	        } else {
	        	//OutputStreamWriter osw = null;
	        	
	        	try (OutputStreamWriter osw = new OutputStreamWriter(new FileOutputStream(f))) {
	        		osw.write(strXML);
	        		String crlf = System.getProperty("line.separator");
	        		osw.append(crlf + crlf);
	        		xmlList = strXML;	        		
	        	} catch(Exception e) {
	        		logger.error(e.getMessage(), e);
	        	} finally {
	        		/*if (osw != null) {
	        			osw.close();
	        		}*/
	        	}
	        }
	        
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", xmlList);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");	
		}
		
		logger.debug("mMailFileUpload result=" + result);
		logger.debug("MOBILE G/W MAIL mMailFileUpload ended.");
			
		return result;
	}

	/**
	 * 메일 대용량 첨부파일 다운로드 실행 함수
	 */
	@RequestMapping(value="/mobile/ezEmail/mails/downloadAttachCommon.do", method=RequestMethod.GET, produces = "text/xml; charset=utf-8")
	public void downloadAttachCommon(HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("MOBILE G/W downloadAttachCommon started.");

		String fileId = request.getParameter("fileid") == null ? "" : request.getParameter("fileid");
		fileId = commonUtil.detectPathTraversal(fileId);
		String fileDate = request.getParameter("filedate") == null ? "" : request.getParameter("filedate");
		fileDate = commonUtil.detectPathTraversal(fileDate);
		String tenantIdStr = request.getParameter("tid");
		tenantIdStr = (tenantIdStr == null || tenantIdStr.trim().equals("")) ? "0" : tenantIdStr;
		tenantIdStr = commonUtil.detectPathTraversal(tenantIdStr);
		int tenantId = Integer.parseInt(tenantIdStr);

		// 2023-08-02 이사라 - 브라우저 언어로 메시지 표출을 위해 수정
		String acceptLanguage = request.getHeader("Accept-Language"); // ex) Accept-Language: en-US,en;q=0.9,ko;q=0.8,id;q=0.7
		String twoLetterLang = "";
		String lang = "";

		if (StringUtils.isNotBlank(acceptLanguage)) {
			twoLetterLang = acceptLanguage.substring(0, 2);
			lang = commonUtil.getLangNumFromTwoLetterLang(twoLetterLang, tenantId);
		}

		// 브라우저 언어가 표준지원 언어가 아닐 경우 시스템 언어로 설정
		if (StringUtils.isBlank(lang)) {
			lang = ezCommonService.getTenantConfig("PrimaryLang", tenantId);
		}

		Locale locale = new Locale(commonUtil.getTwoLetterLangFromLangNum(lang));

		String realPath = commonUtil.getRealPath(request);
		String pDirPath = realPath + commonUtil.getUploadPath("upload_mail.ROOT", tenantId);

		// 2018-10-08 분리된 대용량파일(largeFile) 폴더 사용 여부
		String useSeparatedLargeFileFolder = ezCommonService.getTenantConfig("useSeparatedLargeFileFolder", tenantId);

		if (useSeparatedLargeFileFolder.equals("YES")) {
			pDirPath += commonUtil.separator + "largeFile";
		}

		String realFilePath = pDirPath + commonUtil.separator + fileDate;

		try {
			// get fileId with extension
			fileId = fileId.substring(0, 36);
			File directory = new File(realFilePath);
			File[] files = directory.listFiles((FileFilter) new PrefixFileFilter(fileId));

			// 대용량 첨부파일의 기간이 만료되었을 경우
			if (files == null) {
				response.setContentType("text/plain; charset=utf-8");
				response.getWriter().print(egovMessageSource.getMessage("main.t4", locale));

				return;
			} else {
				//대용량 첨부파일 다운로드 횟수 제한 처리 2020-03-10 홍대표.
				String exceededFilelimit = ezEmailService.checkBigAttachDownloadCount(fileId, tenantId);
				if (exceededFilelimit != null) {
					response.setContentType("text/plain; charset=utf-8");
					response.getWriter().print(egovMessageSource.getMessageExtend("ezEmail.hdp05", new Object[] {exceededFilelimit}, locale));

					return;
				} else {
					ezEmailService.updateBigAttachDownloadCount(fileId, tenantId);
				}
			}

			for (int i = 0; i < files.length; i++) {
				if (!files[i].getName().endsWith("__.txt")) {
					fileId = files[i].getName();
					break;
				}
			}

			realFilePath = realFilePath + commonUtil.separator + fileId;
			logger.debug("realFilePath=" + realFilePath);

			// get original filename from text file
			String fileName = "";
			File originalNameFile = new File(realFilePath + "__.txt");

			if (!originalNameFile.exists()) {
				logger.error("originalNameFile not found. filePath=" + realFilePath + "__.txt");
			} else {
				InputStreamReader isr = null;
				try {
					isr = new InputStreamReader(new FileInputStream(originalNameFile));
					int read = 0;
					while ((read = isr.read()) != -1) {
						fileName += (char)read;
					}
				} finally {
					if (isr != null) {
						isr.close();
					}
				}
			}

			if (fileName.equals("")) {
				fileName = fileId;
			}
			else {
				fileName = new String(org.apache.commons.codec.binary.Base64.decodeBase64(fileName), "UTF-8");
			}

			logger.debug("originalFileName=" + fileName);

			downFile(request, response, realFilePath, fileName);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);

			response.setContentType("text/plain; charset=utf-8");
			response.getWriter().print(egovMessageSource.getMessage("ezEmail.lhm14", locale));
		}

		logger.debug("MOBILE G/W downloadAttachCommon ended.");
	}

	/**
	 * 모바일 G/W 이메일 [POST] 대용량 첨부파일 업로드
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezemail/mails/attachs/bigAttachUpload/{userId:.+}", method= RequestMethod.POST)
	public Object mMailBigFileUpload(@PathVariable String userId, MultipartHttpServletRequest request) throws Exception {
		logger.debug("MOBILE G/W MAIL mMailBigFileUpload started.");
		logger.debug("userId=" + userId);

		String strXML = "";
		String strXML2 = "";
		String folderDate = "";
		String tempFolderName = "";
		String zipPassword = request.getParameter("zipPassword");
		boolean zipFileUploadCheck = false;
		boolean checkZipFileEncrypted = false;
		boolean needZipEncryption = zipPassword != null && !zipPassword.isEmpty();
		String xmlList = "";

		JSONObject result = new JSONObject();

		try {
			List<MultipartFile> multiFile = request.getFiles("fileToUpload");
			int cnt = 0;

			if (request.getParameter("cnt") != null && !request.getParameter("cnt").equals("")) {
				cnt = Integer.parseInt(request.getParameter("cnt"));
			}

			if (cnt == 0) {
				logger.debug("NODATA, cnt={}", cnt);

				result.put("status", "error");
				result.put("code", 1);
				result.put("data", "");

				return result;
			}

			String realPath = commonUtil.getRealPath(request);
			String[] pFileName = new String[cnt];
			Long[] fileSize = new Long[cnt];
			String[] fileLocation = new String[cnt];
			String[] resultUpload = new String[cnt];
			String[] sGUID = new String[cnt];
			String pBigFileUpload = "";
			String[] sFileTitle = new String[cnt];
			String[] sExt = new String[cnt];
			String pDirTempPath = "";

			if (StringUtils.isNotEmpty(request.getParameter("tempFolderName"))) {
				tempFolderName = request.getParameter("tempFolderName");
				tempFolderName = commonUtil.detectPathTraversal(tempFolderName);
			} else {
				logger.debug("NODATA tempFolderName");

				result.put("status", "error");
				result.put("code", 1);
				result.put("data", "");

				return result;
			}

			if (multiFile == null) {
				logger.debug("NODATA multiFile");

				result.put("status", "error");
				result.put("code", 1);
				result.put("data", "");

				return result;
			}

			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);

			String useExtension = ezCommonService.getTenantConfig("USE_FileExtension", info.getTenantId());
			String useAutoZipEnc = ezCommonService.getTenantConfig("useAutoZipEnc", info.getTenantId());

			if (useExtension == null) {
				useExtension = "";
			}

			long bigMaxSize = 0;
			String bigMaxSizeStr = ezCommonService.getTenantConfig("totBigSizeMailAttachLimit", info.getTenantId());
			bigMaxSize = Long.parseLong(bigMaxSizeStr)*1024*1024; // byte -> mega byte

			// multiFile이 존재한다면,
			if (multiFile.get(0).getOriginalFilename() != null && StringUtils.isNotBlank(multiFile.get(0).getOriginalFilename())){
				boolean isEmpty = false;
				String _pFileName = "";
				long totalFileSize = 0;

				// 파일명과 확장자를 구한다.
				for (int i = 0; i < cnt; i++) {
					// postman으로 테스트 시 파일명이 한글일 경우 파일명이 깨지는 오류가 있어 해당 처리
					// 비즈메카고도화 - URL 인코딩해서 보내주심
					_pFileName = URLDecoder.decode(multiFile.get(i).getOriginalFilename(), "UTF-8");
					// _pFileName = new String(_pFileName.getBytes("8859_1"),"UTF-8");
					totalFileSize += multiFile.get(i).getSize();

					// 폴더 경로를 제외한 파일명만을 구한다.
					if (_pFileName.indexOf(commonUtil.separator) > 0) {
						_pFileName = _pFileName.split(commonUtil.separator)[_pFileName.split(commonUtil.separator).length - 1];
					}

					pFileName[i] = _pFileName;

					// 파일 확장자를 구한다.
					if (pFileName[i].lastIndexOf(".") > -1) {
						sFileTitle[i] = pFileName[i].substring(0, pFileName[i].lastIndexOf("."));
						sExt[i] = pFileName[i].substring(pFileName[i].lastIndexOf(".") + 1);
					} else {
						sFileTitle[i] = pFileName[i];
						sExt[i] = "";
					}

					if (multiFile.get(i).getSize() == 0) {
						isEmpty = true;
					}

					if(sExt[i].equals("zip")) {
						zipFileUploadCheck = true;
					}
				}

				if (totalFileSize > bigMaxSize) {
					logger.debug("OVERFLOW totalFileSize > bigMaxSize");

					result.put("status", "error");
					result.put("code", 1);
					result.put("data", "");

					return "result";
				}

				if (isEmpty) {
					logger.debug("OVERFLOW isEmpty");

					result.put("status", "error");
					result.put("code", 1);
					result.put("data", "");

					return result;
				}
			}

			for (int i = 0; i < cnt; i++) {
				sGUID[i] = UUID.randomUUID().toString() + "." + sExt[i];
			}

		   /*
			if (request.getParameter("isBigSize") != null) {
				isBigSize = Long.parseLong(request.getParameter("isBigSize"));
			}
			*/

			strXML = "<ROOT><NODES>";
			String pDirPath = commonUtil.getUploadPath("upload_mail.ROOT", info.getTenantId());
			pDirPath = realPath + pDirPath;

			// check the upload mail root folder and create it if it doesn't exist.
			File uploadMailRootFolder = new File(pDirPath);

			if (!uploadMailRootFolder.exists()) {
				logger.debug("creating uploadMailRootFolder=" + uploadMailRootFolder);

				uploadMailRootFolder.mkdirs();
			}

			// 2018-10-08 분리된 대용량파일(largeFile) 폴더 사용 여부
			String largeFilePath = pDirPath;
			String useSeparatedLargeFileFolder = ezCommonService.getTenantConfig("useSeparatedLargeFileFolder", info.getTenantId());

			if (useSeparatedLargeFileFolder.equals("YES")) {
				largeFilePath += commonUtil.separator + "largeFile";
			}

			// 대용량 첨부 파일의 경우
			for (int i = 0; i < cnt; i++) {
				fileSize[i] = multiFile.get(i).getSize();

				String pDate = EgovDateUtil.getToday("");
				folderDate = pDate;
				pDirTempPath = largeFilePath + commonUtil.separator + pDate; // 날짜까지 생성
				File file = new File(pDirTempPath);

				if (!file.exists()) {
					file.mkdirs();
				}

				pBigFileUpload = "Y";

				pFileName[i] = commonUtil.normalizeFileName(pFileName[i]);

				String base64OrgFileName = org.apache.commons.codec.binary.Base64.encodeBase64String(pFileName[i].getBytes("UTF-8"));
				FileOutputStream fos = null;

				try {
					// 대용량 첨부 파일명을 저장하는 파일
					File f = new File(commonUtil.detectPathTraversal(pDirTempPath + commonUtil.separator + sGUID[i] + "__.txt"));
					fos = new FileOutputStream(f);
					fos.write(base64OrgFileName.getBytes("ISO-8859-1"));
				} catch (Exception e) {
					throw e;
				} finally {
					if (fos != null) {
						fos.close();
					}
				}

				File f = new File(pDirTempPath);

				if (!f.exists()) {
					f.mkdirs();
				}

				//bigMaxSize는 대용량 첨부 파일 다운로드가 가능한 최대한 사이즈
				if (fileSize[i] > bigMaxSize && bigMaxSize != 0) {
					resultUpload[i] = "overflow";
				} else {
					// dhlee : 20220527 - 파일 업로드 시 .으로 끝나는 파일(예: .jsp.)이 무조건 업로드 허용되는 문제 수정
					if ((sExt[i].isEmpty() || useExtension.toLowerCase().indexOf(sExt[i].toLowerCase()) == -1) && !useExtension.equals("*")) {
						resultUpload[i] = "denied";
					} else {
						// Multipart 형식으로 업로드된 파일을 복사한다.
						writeUploadedFile(multiFile.get(i), sGUID[i], pDirTempPath);
						fileLocation[i] = pDirTempPath + commonUtil.separator + sGUID[i];
						resultUpload[i] = "true";

						if(useAutoZipEnc.equals("YES")) {
							File f1 = new File(fileLocation[i]);

							if (zipFileUploadCheck) {
								checkZipFileEncrypted = ezEmailUtil.checkZipEncrypted(f1);
							}

							if (needZipEncryption && !checkZipFileEncrypted) {
								String zipPath = ezEmailUtil.createEncryptZipFile(f1, pFileName[i], zipPassword, pDirTempPath);

								if (zipPath != null) {
									fileLocation[i] = zipPath;  // 암호화된 zip 경로로 업데이트
									pFileName[i] = new File(zipPath).getName();
								}
							}
						}
					}

					boolean isAutoZipEnc = !checkZipFileEncrypted && "YES".equals(useAutoZipEnc);
					String fileIdentifier = isAutoZipEnc ? pFileName[i] : sGUID[i];
					String fileLocationValue;

					if ("Y".equals(pBigFileUpload)) {
						fileLocationValue = folderDate + "|!|" + fileIdentifier;
					} else {
						fileLocationValue = fileIdentifier;
					}
					
					// 업로드된 파일에 대한 정보를 XML 형식으로 클라이언트에게 반환한다.
					strXML2 += "<NODE><PUPLOADSN><![CDATA[" + fileIdentifier + "]]></PUPLOADSN>";
					strXML2 += "<RESULTUPLOADA><![CDATA[" + resultUpload[i] + "]]></RESULTUPLOADA>";
					strXML2 += "<PFILENAME><![CDATA[" + pFileName[i] + "]]></PFILENAME>";
					strXML2 += "<FILESIZE><![CDATA[" + fileSize[i] + "]]></FILESIZE>";
					strXML2 += "<FILELOCATION><![CDATA[" + fileLocationValue + "]]></FILELOCATION>";
					strXML2 += "<PBIGFILEUPLOAD><![CDATA[" + pBigFileUpload + "]]></PBIGFILEUPLOAD>";

					if (zipFileUploadCheck) {
						strXML2 += "<CHECKZIPENCRYPTED><![CDATA[" + checkZipFileEncrypted + "]]></CHECKZIPENCRYPTED>";
					}
					
					strXML2 += "</NODE>";
				}
				pDirTempPath = "";
			}

			strXML += strXML2 + "</NODES></ROOT>";

			String xmlPath = pDirPath + commonUtil.separator + "templist";
			File f = new File(xmlPath);

			if (!f.exists()) {
				f.mkdirs();
			}

			// 클라이언트가 지정한 UUID인 tempFolderName을 이름으로 하는 첨부파일 목록 저장용 파일을 구한다.
			xmlPath += commonUtil.separator + tempFolderName + ".txt";
			logger.debug("###" + xmlPath + "###");

			f = new File(xmlPath);

			if (f.exists()) {
				String tempXmlList = "";
				InputStreamReader isr = null;
				BufferedReader br = null;
				OutputStreamWriter osw = null;

				try {
					isr = new InputStreamReader(new FileInputStream(f));
					br = new BufferedReader(isr);
					int read = 0;

					while ((read = br.read()) != -1) {
						tempXmlList += (char)read;
					}

					Document xmldom = commonUtil.convertStringToDocument(tempXmlList);
					Document xmldom2 = commonUtil.convertStringToDocument(strXML);

					NodeList nodeList = xmldom.getElementsByTagName("NODES");
					NodeList nodeList2 = xmldom2.getElementsByTagName("NODE");

					for (int i=0; i<nodeList2.getLength(); i++) {
						nodeList.item(0).appendChild(xmldom.importNode(nodeList2.item(i), true));
					}

					osw = new OutputStreamWriter(new FileOutputStream(f));
					osw.write(commonUtil.convertDocumentToString(xmldom));
					String crlf = System.getProperty("line.separator");
					osw.append(crlf+crlf);

					xmlList = strXML;
				} catch(Exception e) {
					logger.error(e.getMessage(), e);

					result.put("status", "error");
					result.put("code", 1);
					result.put("data", "");
				} finally {
					IOUtils.closeQuietly(osw);

					if (br != null) {
						br.close();
					}
					if (isr != null) {
						isr.close();
					}
					/*if (osw != null) {
						osw.close();
					}*/
				}

			} else {
				OutputStreamWriter osw = null;

				try {
					osw = new OutputStreamWriter(new FileOutputStream(f));
					osw.write(strXML);
					String crlf = System.getProperty("line.separator");
					osw.append(crlf+crlf);
					xmlList = strXML;
				} catch(Exception e) {
					logger.error(e.getMessage(), e);

				} finally {
					if (osw != null) {
						osw.close();
					}
				}
			}

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", xmlList);

		} catch (Exception e) {
			logger.error(e.getMessage(), e);

			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}

		logger.debug("mMailBigFileUpload result=" + result);
		logger.debug("MOBILE G/W MAIL mMailBigFileUpload ended.");
		return result;
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezemail/mails/attachsmail/users/{userId:.+}", method= RequestMethod.POST, produces="application/json;charset=utf-8")
	@ResponseBody
	public Object mailInterAttach(HttpServletRequest request, @PathVariable String userId, @RequestBody JSONObject jsonObject) throws Exception {
		logger.debug("MOBILE G/W MAIL mailInterAttach started.");
		logger.debug("userId=" + userId + ",jsonObject=" + jsonObject);
		
		String returnValue = "";
		String cmd = "";
	    
		JSONObject result = new JSONObject();
		
		try {		
			String xmldomString = "";
			String realPath = commonUtil.getRealPath(request);
			
			if (jsonObject.get("xmldom") != null) {
				xmldomString = (String) jsonObject.get("xmldom");
			}
			
			String serverName = request.getHeader("x-user-host");
			
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			String domainName = ezCommonService.getTenantConfig("DomainName", info.getTenantId());
			String userEmail = info.getUserId() + "@" + domainName;
			String password = jspw;
			
			String ld = commonUtil.getTwoLetterLangFromLangNum(info.getLang());
			Locale locale = new Locale(ld);	
			
			Document xmldom = commonUtil.convertStringToDocument(xmldomString);
			cmd = xmldom.getElementsByTagName("CMD").item(0).getTextContent();
			String uidStr = xmldom.getElementsByTagName("URL").item(0).getTextContent();
			
			NodeList bigs = xmldom.getElementsByTagName("BIG");
			boolean hasAttachFile = false;
			
			if (bigs != null) {
				for (int i = 0; i < bigs.getLength(); i++) {
					if (bigs.item(i).getTextContent().equals("N")) {
					    // 일반첨부파일이 있는 경우
						hasAttachFile = true;
						break;
					}
				}
			}
			
			long uid = 0;
			
			if (uidStr != null && !uidStr.equals("")) {
				uid = Long.parseLong(uidStr);
			}
			
//			String realPath = commonUtil.getRealPath(request);
			String pDirPath = commonUtil.getUploadPath("upload_mail.ROOT", info.getTenantId());
			pDirPath = realPath + pDirPath;
			String pDirTempPath = realPath + commonUtil.getUploadPath("upload_mail.ROOT", info.getTenantId()) + commonUtil.separator + "tempFileUpload";
			
			MimeMessage newMessage = null;
			IMAPAccess ia = null;
			Folder folder = null;
			Multipart multipart = null;
			
			try {
				// 일반 첨부 파일이 있는 경우
				if (hasAttachFile) {
					SMTPAccess sa = SMTPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.SMTPPort"),
							userEmail, password, info.getEmail());
					
					// 첨부파일들을 추가하여 임시 보관함에 저장할 메시지를 생성한다.
					newMessage = sa.createMimeMessage();
					
					ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
							userEmail, password, egovMessageSource, locale, ezEmailUtil);
					
					// 임시 보관함 폴더 오픈 
					folder = ia.getFolder(ezEmailUtil.getDraftsFolderId(locale));
					folder.open(Folder.READ_WRITE);
					
					// 첨부파일 Part들을 삽입할 Multipart를 생성한다.
					multipart = new MimeMultipart();
				}
				
				if (cmd.equals("ADD")) {
					NodeList fileNodes = xmldom.getElementsByTagName("FILE");
					
					// 임시 보관함에 이미 기존 메시지가 있는 경우, 해당 메시지의 파트들을 새 메시지에 병합한다.
					if (hasAttachFile && uid != 0) {
					    // 임시 보관함에 있는 메시지를 가져온다.
						Message oldMessage = ((IMAPFolder)folder).getMessageByUID(uid);
						
						if (oldMessage != null) {
						    // 기존 메시지가 Multipart인 경우 처리
							if (oldMessage.getContent() instanceof Multipart) {
								Multipart mp = (Multipart)oldMessage.getContent();
								int count = mp.getCount();
								BodyPart p = null;
								
								// 임시 보관함에 있는 메시지가 multipart/related일 때는 새롭게 related 파트로 구성한 다음
								// 새 메시지의 서브 파트로 추가한다.
								if (oldMessage.isMimeType("multipart/related")) {
									logger.debug("oldMessage is multipart/related");
								    
									Multipart relatedPart = new MimeMultipart("related");
									
									for (int i = 0; i < count; i++) {
										p = mp.getBodyPart(i);
										relatedPart.addBodyPart(p);
									}
									
									MimeBodyPart wrap = new MimeBodyPart();
									wrap.setContent(relatedPart);
									multipart.addBodyPart(wrap, 0);
								} else if (oldMessage.isMimeType("multipart/alternative")) {
									logger.debug("oldMessage is multipart/alternative");
								    
		                            Multipart alternativePart = new MimeMultipart("alternative");
		                            
		                            for (int i = 0; i < count; i++) {
		                                p = mp.getBodyPart(i);
		                                alternativePart.addBodyPart(p);
		                            }
		                            
		                            MimeBodyPart wrap = new MimeBodyPart();
		                            wrap.setContent(alternativePart);
		                            multipart.addBodyPart(wrap, 0);							    
								} else {
									for (int i = 0; i < count; i++) {
										p = mp.getBodyPart(i);
										multipart.addBodyPart(p);
									}
								}
							}
							
							// 기존 메시지의 모든 헤더를 적용한다.
							Enumeration<Header> e = oldMessage.getAllHeaders();
							while(e.hasMoreElements()){
								Header header = e.nextElement();
								newMessage.setHeader(header.getName(), header.getValue());
							}
							
							// 기존 메시지를 제거한다.
							oldMessage.setFlag(Flags.Flag.DELETED, true);
						}
					}
					
					// 새로 업로드된 파일들을 새 메시지에 추가한다.
					for (int i = 0; i < fileNodes.getLength(); i++) {
						Node subNode = fileNodes.item(i);
						NodeList childNodes = subNode.getChildNodes();
						String fileName = childNodes.item(0).getTextContent();
						String path = childNodes.item(1).getTextContent();
						String bigBool = childNodes.item(2).getTextContent();
						
						// 일반첨부파일의 경우
						if (hasAttachFile && bigBool.equals("N")) {
						    // 첨부파일을 삽입할 Part를 생성한다.
							BodyPart messageBodyPart = new MimeBodyPart();
							
					        File f = new File(pDirTempPath + commonUtil.separator + path);
					        FileDataSource source = new FileDataSource(pDirTempPath + commonUtil.separator + path);
					        messageBodyPart.setDataHandler(new DataHandler(source));
					        
					        // MimeUtility.encodeText is needed to encode a file name in UTF-8 explicitly, 
					        // otherwise, a wrong encoding may be used on some systems(linux, etc)
					        String encodedFileName = MimeUtility.encodeText(fileName, "UTF-8", null);
					        
							// folding a filename is done manually since BodyPart.setFileName method encodes it based on RFC 2231.
							// and some mailers (Daum, etc) may not understand it.			        
					        encodedFileName = MimeUtility.fold(0, encodedFileName);
					        messageBodyPart.setHeader("Content-Disposition", "attachment;\r\n\tfilename=\"" + encodedFileName + "\"");
					        
					        // 첨부파일 Content-Type의 디폴트는 application/octet-stream로 설정한다.
					        String contentType = "application/octet-stream";
					        
					        // 첨부파일의 Content-Type을 구한다.
					        if (Files.probeContentType(f.toPath()) != null) {
					        	contentType = Files.probeContentType(f.toPath());
					        } else {
					        	if (path.substring(path.lastIndexOf(".")).equalsIgnoreCase(".eml")) {
					        		contentType = "message/rfc822";
					        	}
					        }
					        
					        messageBodyPart.setHeader("Content-Type", contentType);

							if (multipart != null && messageBodyPart != null){
								// Multipart에 첨부파일 Part를 삽입한다.
								multipart.addBodyPart(messageBodyPart);
							}

					        //TODO: fileName parameter를 attachCount로 바꿔야 할것같음. 또는 (filename, attachCount).
					        //메일에서 첨부파일 삭제할 때 attachCount 필요함.
					        childNodes.item(4).setTextContent(fileName);
					        
						} else {
							if (!path.equals("")) {
								String[] newPath = path.split("\\|!\\|");
								childNodes.item(1).setTextContent(newPath[1]);
								childNodes.item(4).setTextContent(newPath[0] + commonUtil.separator + newPath[1]);
							}
						}
					}
					
					if (hasAttachFile) {
						newMessage.setContent(multipart);
						newMessage.setFlag(Flags.Flag.SEEN, true);
						AppendUID[] uids = ((IMAPFolder)folder).appendUIDMessages(new Message[]{newMessage});
						xmldom.getElementsByTagName("URL").item(0).setTextContent(String.valueOf(uids[0].uid));
					} else {
						if (uid == 0) {
							xmldom.getElementsByTagName("URL").item(0).setTextContent("");
						} else {
							xmldom.getElementsByTagName("URL").item(0).setTextContent(String.valueOf(uid));
						}
					}
		    		
					// 처리가 완료된 일반첨부파일 원본 파일들을 삭제한다.				
					for (int i = 0; i < fileNodes.getLength(); i++) {
						Node subNode = fileNodes.item(i);
						NodeList childNodes = subNode.getChildNodes();
						
		                if (childNodes.item(2).getTextContent().equals("N")) {
		                	File file = new File(pDirTempPath + commonUtil.separator + childNodes.item(1).getTextContent());
		                	
		                    if (file.exists()) {
		                    	file.delete();
		                    }
		                }
		            }
				}
				
				if (hasAttachFile) {
			        folder.close(true);
				}
				
				returnValue = commonUtil.convertDocumentToString(xmldom);				
			} catch (MessagingException e) {
				returnValue = e.getMessage();
				logger.error(e.getMessage(), e);
				
				result.put("status", "error");
				result.put("code", 1);			
				result.put("data", "");
			} finally {
				if (ia != null) {
					ia.close();
				}
			}
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", returnValue);			
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		}
		
		logger.debug("mailInterAttach result=" + result);
		logger.debug("MOBILE G/W MAIL mailInterAttach ended.");
		
		return result;
	}
	
	/**
	 * 일반 첨부파일 삭제 실행 함수
	 */
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezemail/mails/deletesmail/users/{userId:.+}", method= RequestMethod.POST, produces="application/json;charset=utf-8")
	@ResponseBody
	public Object mailDelInterAttach(HttpServletRequest request, @PathVariable String userId, @RequestBody JSONObject jsonObject) throws Exception {
		logger.debug("MOBILE G/W MAIL mailDelInterAttach started.");
		logger.debug("mailDelInterAttach userId=" + userId + ",jsonObject=" + jsonObject);
				
		String returnValue = "";
	    
		JSONObject result = new JSONObject();
		
		try {		
			String serverName = request.getHeader("x-user-host");
			
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			String domainName = ezCommonService.getTenantConfig("DomainName", info.getTenantId());
			String userEmail = info.getUserId() + "@" + domainName;
			String password = jspw;
			
			String ld = commonUtil.getTwoLetterLangFromLangNum(info.getLang());
			Locale locale = new Locale(ld);
			
			returnValue = "<DATA><![CDATA[";
			
			String xmldomString = "";
			
			if (jsonObject.get("xmldom") != null) {
				xmldomString = (String) jsonObject.get("xmldom");
			}
			
			Document xmlDoc = commonUtil.convertStringToDocument(xmldomString);
			Element root = xmlDoc.getDocumentElement();
			
			long uid = 0;
			
			if (root.getElementsByTagName("ITEMID") != null) {
				String uidStr = root.getElementsByTagName("ITEMID").item(0).getTextContent();
				
				if (uidStr != null && !uidStr.trim().equals("")) {
					uid = Long.parseLong(uidStr);
				}
			}

			if (uid != 0) {
				NodeList rows = root.getElementsByTagName("ROW");

				if (rows != null && rows.item(0) != null) {
					SMTPAccess sa = SMTPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.SMTPPort"),
							userEmail, password, info.getEmail());

					IMAPAccess ia = null;
					try {
						ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
								userEmail, password, egovMessageSource, locale, ezEmailUtil);
						
						if (ia != null){
							Folder folder = ia.getFolder(ezEmailUtil.getDraftsFolderId(locale));
							folder.open(Folder.READ_WRITE);
							Message oldMessage = ((IMAPFolder)folder).getMessageByUID(uid);

							if (oldMessage != null) {

								//TODO: rows에 filename대신 index넣기,
								//deleteAttach(SMTPAccess sa, Message oldMessage, int[] index) 부르기

								MimeMessage newMessage = sa.createMimeMessage();
								Multipart multipart = new MimeMultipart();

								Multipart mp = (Multipart)oldMessage.getContent();
								int count = mp.getCount();
								BodyPart p = null;

								for (int i = 0; i < count; i++) {
									p = mp.getBodyPart(i);

									int length = rows.getLength();
									boolean isRemoved = false;

									if (p.getDisposition() != null && p.getDisposition().equalsIgnoreCase(Part.ATTACHMENT)) {
										for (int j = 0; j < length; j++) {
											String mailFileName = MimeUtility.decodeText(p.getFileName());

											if (rows.item(j).getFirstChild().getTextContent().equals(mailFileName)) {
												isRemoved = true;
												break;
											}
										}
									}

									if (!isRemoved) {
										multipart.addBodyPart(p);
									}
								}

								Enumeration<Header> e = oldMessage.getAllHeaders();

								while (e.hasMoreElements()) {
									Header header = e.nextElement();
									newMessage.setHeader(header.getName(), header.getValue());
								}
								//

								if (multipart.getCount() != 0) {
									newMessage.setContent(multipart);
									newMessage.setFlag(Flags.Flag.SEEN, true);
									AppendUID[] uids = ((IMAPFolder)folder).appendUIDMessages(new Message[]{newMessage});
									returnValue += uids[0].uid;
								}

								oldMessage.setFlag(Flags.Flag.DELETED, true);

							}

							folder.close(true);
						}
					} catch (MessagingException e) {
						logger.error(e.getMessage(), e);
					} finally {
						if (ia != null) {
							ia.close();
						}
					}
				}
			}
			
			returnValue += "]]></DATA>";
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", returnValue);			
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		}
				
		logger.debug("mailDelInterAttach result=" + result);
		logger.debug("MOBILE G/W MAIL mailDelInterAttach ended.");
		
		return result;
	}

	/**
	 * 대용량 첨부파일 삭제 실행 함수
	 */

	@RequestMapping(value="/mobile/ezemail/mails/deletesmail/big/users/{userId:.+}", method= RequestMethod.POST, produces="application/json;charset=utf-8")
	@ResponseBody
	public Result mailDelBigAttach(HttpServletRequest request, @PathVariable String userId, @RequestBody JSONObject jsonObject) throws Exception {
		logger.debug("MOBILE G/W MAIL mailDelBigAttach started.");
		logger.debug("mailDelBigAttach userId={}, jsonObject={}", userId, jsonObject);

		Result result = null;

		try {
			String serverName = request.getHeader("x-user-host");
			String attachName = (String) jsonObject.get("attachName");
			String tempFolderName = (String) jsonObject.get("tempFolderName");

			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			String realPath = commonUtil.getRealPath(request);
			String pDirPath = realPath + commonUtil.getUploadPath("upload_mail.ROOT", info.getTenantId());
			String xmlPath = pDirPath + commonUtil.separator + "templist" + commonUtil.separator + tempFolderName + ".txt";

			// 2018-10-08 분리된 대용량파일(largeFile) 폴더 사용 여부
			String largeFilePath = pDirPath;
			String useSeparatedLargeFileFolder = ezCommonService.getTenantConfig("useSeparatedLargeFileFolder", info.getTenantId());

			if (useSeparatedLargeFileFolder.equals("YES")) {
				largeFilePath += commonUtil.separator + "largeFile";
			}

			File templistFile = new File(xmlPath);
			if (templistFile.exists()) {
				StringBuilder strXml = new StringBuilder();
				try (InputStreamReader isr = new InputStreamReader(Files.newInputStream(templistFile.toPath()))) {
					int read = 0;
					while ((read = isr.read()) != -1) {
						strXml.append((char) read);
					}
				}

				Document xmlDom = commonUtil.convertStringToDocument(strXml.toString());
				NodeList nodeList = xmlDom.getElementsByTagName("NODE");

				if (nodeList != null) {
					for (int i = 0; i < nodeList.getLength(); i++) {
						if (xmlDom.getElementsByTagName("PFILENAME").item(i).getTextContent().equals(attachName)
								&& xmlDom.getElementsByTagName("PBIGFILEUPLOAD").item(i).getTextContent().equals("Y")) {
							String fileLocation = nodeList.item(i).getChildNodes().item(4).getTextContent();
							String[] fileLocationArray = fileLocation.split("\\|!\\|");
							String pRealFilePath = largeFilePath + commonUtil.separator + fileLocationArray[0] + commonUtil.separator + fileLocationArray[1];
							pRealFilePath = commonUtil.detectPathTraversal(pRealFilePath);

							File bigAttachFile = new File(pRealFilePath);

							if (bigAttachFile.exists()) {
								bigAttachFile.delete();
								File bigAttachNameFile = new File(pRealFilePath + "__.txt");
								bigAttachNameFile.delete();
							}

							nodeList.item(i).getParentNode().removeChild(nodeList.item(i));
						}
					}
				}

				String strXml2 = commonUtil.convertDocumentToString(xmlDom);
				logger.debug("strXml : {}", strXml);
				logger.debug("strXml2 : {}", strXml2);

				try (OutputStreamWriter osw = new OutputStreamWriter(Files.newOutputStream(templistFile.toPath()), StandardCharsets.UTF_8)) {
					osw.write(strXml2);
				}
			}

			result = Result.success();
		} catch (Exception e) {
			logger.error("mailDelBigAttach error:", e);
			result = Result.failureWithCode(1);
		}

		logger.debug("mailDelBigAttach result={}", result);
		logger.debug("MOBILE G/W MAIL mailDelBigAttach ended.");

		return result;
	}

	/**
	 * 모바일 G/W 이메일 [POST] 메일발송(send) & 임시보관함 저장(save)
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezemail/mail-send/users/{userId:.+}", method= RequestMethod.POST, produces="application/json;charset=utf-8")
	public Object mMailSend(HttpServletRequest request, @PathVariable String userId, @RequestBody JSONObject jsonObject) {
		logger.debug("MOBILE G/W MAIL mMailSend started.");
		logger.debug("userId=" + userId);

		JSONObject result = new JSONObject();

		try {
			boolean retryFlag = false;
			int retryCount = 1; // 메일 발송 실패 시 재시도 횟수
			long draftUID = 0;
			long sentFolderMessageUID = 0;
			boolean mailSendCompleted = false;
			boolean invalidAddressesError = false; // 잘못된 메일주소가 존재할 경우 true
//			logger.debug(jsonObject.toJSONString());
			
			String importance = "3";
			
			String subject = "";
			String to = "";
			String cc = "";
			String bcc = "";
			String textBody = "";
			String from = "";
			String charset = "";
			@SuppressWarnings("unused")
			String htmlbody = "";
			String displayName = "";
			String stateName = "";
			String url = "";
			String orgFolderId = "";
			String orgMessageId = "";
			String cmd = "";
			String mailcmd = "";
			String replyReadTime = "";
			String textOption = "";
			List<Map<String, Object>> addressCheck = null;
			String tempFolderName = null;
			boolean apprmail = false; // 승인메일 정책에 걸려 승인메일 신청인 경우 true, 승인메일 프로세스를 타지 않을 경우 false
			String apprmailType = ""; // 승인메일 정책 종류. ALL_HANDS:전사메일 승인 신청, NORMAL(all_hands외 문자들):일반메일 승인 신청
			String apprmailApprover = ""; // 승인메일 승인자 CN

			JSONParser jp = new JSONParser();
			jsonObject = (JSONObject) jp.parse(jsonObject.toJSONString());

			if (jsonObject.get("subject") != null) {
				subject = (String) jsonObject.get("subject");
			}

			if (jsonObject.get("tempFolderName") != null) {
				tempFolderName = (String) jsonObject.get("tempFolderName");
			}
			
			if (jsonObject.get("to") != null) {
				to = (String) jsonObject.get("to");
			}
			
			if (jsonObject.get("cc") != null) {
				cc = (String) jsonObject.get("cc");
			}
			
			if (jsonObject.get("bcc") != null) {
				bcc = (String) jsonObject.get("bcc");
			}
			
			if (jsonObject.get("textbody") != null) {
				textBody = (String) jsonObject.get("textbody");
			}
			
			if (jsonObject.get("from") != null) {
				from = (String) jsonObject.get("from");
			}
			
			if (jsonObject.get("charset") != null) {
				charset = (String) jsonObject.get("charset");
			}
			
			if (jsonObject.get("htmlbody") != null) {
				htmlbody = (String) jsonObject.get("htmlbody");
			}
			
			if (jsonObject.get("displayName") != null) {
				displayName = (String) jsonObject.get("displayName");
			}
			
			if (jsonObject.get("stateName") != null) {
				stateName = (String) jsonObject.get("stateName");
			}
			
			if (jsonObject.get("importance") != null) {
				importance = (String) jsonObject.get("importance");
			}
			
			if (jsonObject.get("url") != null) {
				url = (String) jsonObject.get("url");
			}
			
			if (jsonObject.get("orgFolderId") != null) {
				orgFolderId = (String) jsonObject.get("orgFolderId");
			}
			
			if (jsonObject.get("orgMessageId") != null) {
				orgMessageId = (String) jsonObject.get("orgMessageId");
			}
			
			if (jsonObject.get("cmd") != null) {
				cmd = (String) jsonObject.get("cmd");
			}
			
			if (jsonObject.get("mailcmd") != null) {
				mailcmd = (String) jsonObject.get("mailcmd");
			}
						
			if (jsonObject.get("replyReadTime") != null) {
				replyReadTime = (String) jsonObject.get("replyReadTime");
			}
			
			if (jsonObject.get("textOption") != null) {
				textOption = (String) jsonObject.get("textOption");
			}
			
			apprmail = BooleanUtils.toBoolean((String)jsonObject.get("apprmail")); // 승인메일 프로세스 태움 여부
			apprmailType = StringUtils.defaultIfBlank((String)jsonObject.get("apprmailType"), ""); // 승인메일 종류. ALL_HANDS:전사메일 승인 신청, NORMAL(all_hands외 문자들):일반메일 승인 신청
			apprmailType = (!"ALL_HANDS".equalsIgnoreCase(apprmailType)) ? "NORMAL" : "ALL_HANDS";
			apprmailApprover = StringUtils.defaultIfBlank((String)jsonObject.get("apprmailApprover"), ""); // 승인메일 승인자 CN
			
			boolean isSending = "SEND".equalsIgnoreCase(cmd);
			String realPath = commonUtil.getRealPath(request);
	
			logger.debug("subject = {}, to = {}, cc = {}, bcc = {}, from = {}"
					+ ", charset = {}, displayName = {}, stateName = {}, url = {}, cmd = {}"
					+ ", orgFolderId = {}, orgMessageId = {}, mailcmd = {}, replyReadTime = {}"
					+ ", apprmail={}, apprmailType={}, apprmailApprover={}"
					, subject, to, cc, bcc, from
					, charset, displayName, stateName, url, cmd
					, orgFolderId, orgMessageId, mailcmd, replyReadTime
					, apprmail, apprmailType, apprmailApprover); 
					
			String serverName = request.getHeader("x-user-host");
		
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			String domainName = ezCommonService.getTenantConfig("DomainName", info.getTenantId());
			String https = "YES".equals(ezCommonService.getTenantConfig("USE_HTTPS", info.getTenantId())) ? "https://" : "http://";
			String serverNameByTenantId = ezCommonService.getTenantConfig("serverName", info.getTenantId());
			String userEmail = info.getUserId() + "@" + domainName;
			String password = jspw;
			
			String ld = commonUtil.getTwoLetterLangFromLangNum(info.getLang());
			Locale locale = new Locale(ld);
			
			// 승인메일 공유사서함 계정
			String apprSharedMailBox = "";
			if (apprmail) {
				apprSharedMailBox = ezEmailUtil.getApprSharedMailBox(info.getTenantId(), locale, password);
				
				if ("APPR_ERROR".equals(apprSharedMailBox)) {
					throw new Exception("APPR_ERROR");
				} else {
					//mailId = apprSharedMailBox; // 보안메일일 경우 보안메일 테이블에 저장되기 위해 승인메일 공유사서함 아이디로 변경
					apprSharedMailBox = apprSharedMailBox + "@" + domainName;
				}
				
				logger.debug("apprmail apprSharedMailBox={}", apprSharedMailBox);
			}
			
			SMTPAccess sa = SMTPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.SMTPPort"),
					userEmail, password, info.getEmail());
		
			String pResult = null;
			IMAPAccess ia = null;
		
			do {
				try {
					ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
							userEmail, password, egovMessageSource, locale, ezEmailUtil, apprSharedMailBox);
					
					// 메일 발송 재시도일 경우 draftUID의 메일을 지우고 retryFlag와 draftUID를 초기화한다.
					if (retryFlag) {
						if (draftUID != 0) {
							Folder draftFolder = null;
    					
							try {
								draftFolder = ia.getFolder(ezEmailUtil.getDraftsFolderId(locale));
								draftFolder.open(Folder.READ_WRITE);
								Message draftMessage = ((IMAPFolder)draftFolder).getMessageByUID(draftUID);
								draftMessage.setFlag(Flags.Flag.DELETED, true);
								draftFolder.close(true);
								draftFolder = null;
    		        		
								logger.debug("draftUID message deleted successfully during retry.");
							} catch (Exception e) {
								logger.error("Failed to delete draftUID message during retry. draftUID=" + draftUID);
								
								result.put("status", "error");
			        			result.put("code", 1);			
			        			result.put("data", "");
							} finally {
								if (draftFolder != null) {
									try {
    								draftFolder.close(true);
									} catch (Exception e) {
										result.put("status", "error");
					        			result.put("code", 1);			
					        			result.put("data", "");
									}
									draftFolder = null;
								}
							}
						}
				    
					    // 보낸편지함에 저장된 이후 Exception이 발생하여 Retry하는 경우 보낸편지함에 있는 메시지를 삭제한다.
					    if (sentFolderMessageUID != 0) {
	                        Folder sentFolder = null;
	                        try {
	                            sentFolder = ia.getFolder(ezEmailUtil.getSentFolderId(locale), apprmail);
	                            sentFolder.open(Folder.READ_WRITE);
	                            Message sentMessage = ((IMAPFolder)sentFolder).getMessageByUID(sentFolderMessageUID);
	                            sentMessage.setFlag(Flags.Flag.DELETED, true);
	                            sentFolder.close(true);
	                            sentFolder = null;
	                            
	                            logger.debug("sentFolderMessageUID message deleted successfully during retry.");
	                        } catch (Exception e) {
	                            logger.error("Failed to delete sentFolderMessageUID message during retry. sentFolderMessageUID=" + sentFolderMessageUID);
	                            result.put("status", "error");
	                			result.put("code", 1);			
	                			result.put("data", "");
	                        } finally {
	                            if (sentFolder != null) {
	                                try {
	                                    sentFolder.close(true);
	                                } catch (Exception e) {
	                                	result.put("status", "error");
	                        			result.put("code", 1);			
	                        			result.put("data", "");
	                                }
	                                
	                                sentFolder = null;
	                            }
	                        }				        
					    }
						
						retryFlag = false;
						draftUID = 0;
						sentFolderMessageUID = 0;
					} // if (retryFlag) {

					if (ia == null){
						throw new Exception("ia is null");
					}

					// 편지함 용량 체크
					long[] storageUsageAndLimit = ia.getStorageUsageAndLimit();
					double mailboxUsage = storageUsageAndLimit[0]; // in KBs
					double mailboxQuota = storageUsageAndLimit[1]; // in KBs
					
					logger.debug("mailboxUsage=" + mailboxUsage + ",mailboxQuota=" + mailboxQuota);
					
					if (mailboxUsage >= mailboxQuota) {
						throw new Exception("OVERQUOTA");
					}
				
					// MIME Message를 생성한다.
					MimeMessage message = sa.createMimeMessage();
					
					// 메일 From,TO,CC,BCC
					InternetAddress internetAddress = new InternetAddress();
					String name = "";
					String address = "";
					
					// From
					logger.debug("from=" + from);
					
					String pattern = "\"?([^\"]*)\"? <([^<>]+)>";
					Pattern r = Pattern.compile(pattern);
					Matcher m = r.matcher(from);
					
					if (m.find()) {
						name = m.group(1);
						address = m.group(2);
						internetAddress.setPersonal(name, "UTF-8");
						internetAddress.setAddress(address);
						message.setFrom(internetAddress);
					}
				
					// To
					logger.debug("to=" + to);
					
					m = r.matcher(to);
					addressCheck = new ArrayList<Map<String, Object>>();
					
					while (m.find()) {
						name = m.group(1);
						address = m.group(2);
						internetAddress.setPersonal(name, "UTF-8");
						internetAddress.setAddress(address);
						message.addRecipient(RecipientType.TO, internetAddress);
						
						Map<String, Object> autoAddress = new HashMap<String, Object>();
						autoAddress.put("name", name);
						autoAddress.put("address", address);
						addressCheck.add(autoAddress);
					}
					
					// Cc
					logger.debug("cc=" + cc);
					
					m = r.matcher(cc);
					
					while (m.find()) {
						name = m.group(1);
						address = m.group(2);
						internetAddress.setPersonal(name, "UTF-8");
						internetAddress.setAddress(address);
						message.addRecipient(RecipientType.CC, internetAddress);
						
						Map<String, Object> autoAddress = new HashMap<String, Object>();
						autoAddress.put("name", name);
						autoAddress.put("address", address);
						addressCheck.add(autoAddress);
					}
					
					// Bcc
					logger.debug("bcc=" + bcc);
					
					m = r.matcher(bcc);
					
					while (m.find()) {
						name = m.group(1);
						address = m.group(2);
						internetAddress.setPersonal(name, "UTF-8");
						internetAddress.setAddress(address);
						message.addRecipient(RecipientType.BCC, internetAddress);
						
						Map<String, Object> autoAddress = new HashMap<String, Object>();
						autoAddress.put("name", name);
						autoAddress.put("address", address);
						addressCheck.add(autoAddress);
					}				
					
					// 메일 제목
					message.setSubject(subject, "UTF-8");
								
					Multipart alternativePart = null;
		        
					// 메일 본문 및 타입
					MimeBodyPart content = new MimeBodyPart();
					
					String defaultFontAndSize = "style='font-size:13px;font-family:" + egovMessageSource.getMessage("main.t246", locale) + "'";
					
					//사용자 언어가 한국어이고 editorFontStyle값이 있을 경우 editorFontStyle값 적용
					if (info.getLang().equals("1")) {
						String editorFontStyle = ezCommonService.getTenantConfig("editorFontStyle", info.getTenantId());
						
						if (!editorFontStyle.isEmpty()) {
							String fontFamily = editorFontStyle.split("\\|")[0];
							String fontSize = editorFontStyle.split("\\|")[1];
							
							defaultFontAndSize = "style='font-size:" + fontSize + ";font-family:" + fontFamily + "'";
						}
					}
					
					logger.debug("defaultFontAndSize=" + defaultFontAndSize);
					
					//inline image 처리
					MimeMultipart relatedPart = null;
					Set<String> contentIdSet = new HashSet<String>();

					if (textOption.equalsIgnoreCase("HTML")) {
						// 모바일에서 보내오는 서명의 이미지들을 relatedPart 로 넣기
						List<MimeBodyPart> imageParts = new LinkedList<>();

						appendBigAttachesHtml: if (StringUtils.isNotEmpty(tempFolderName)) {
							// 클라이언트가 지정한 UUID인 tempFolderName을 이름으로 하는 첨부파일 목록 저장용 파일을 구한다.
							String pDirPath = realPath + commonUtil.getUploadPath("upload_mail.ROOT", info.getTenantId());
							String xmlPath = pDirPath + commonUtil.separator + "templist" + commonUtil.separator + tempFolderName + ".txt";
							File templistFile = new File(xmlPath);

							if (templistFile.exists()) {
								String protocol = ezCommonService.getTenantConfig("USE_HTTPS", info.getTenantId()).equalsIgnoreCase("YES") ? "https" : "http";
								String bigSizeAttachLimitCount = ezCommonService.getTenantConfig("MailBigSizeAttachLimitCount", info.getTenantId());
								String pBigAttachDownloadDay = ezCommonService.getTenantConfig("BigSizeMailAttachDelDay", info.getTenantId());
								String bigSizeAttachDownloadLimitCount = ezCommonService.getTenantConfig("MailBigSizeAttachDownloadLimitCount", info.getTenantId());
								String mailLinkHostname = "";
								ArrayList<Map<String,Object>> fileInfoList = new ArrayList<>();

								if (ezCommonService.getTenantConfig("useMailLinkHostname", info.getTenantId()).equalsIgnoreCase("YES")) {
									mailLinkHostname = ezCommonService.getTenantConfig("mailLinkHostname", info.getTenantId());
								}

								String pBigAttachDownloadPeriod = EgovDateUtil.getToday("/") + " ~ " + EgovDateUtil.addDay(EgovDateUtil.getToday("/"), Integer.parseInt(pBigAttachDownloadDay), "yyyy/MM/dd");
								int pBigAttachLimitCount = bigSizeAttachLimitCount == null || bigSizeAttachLimitCount.equals("") ? 0 : Integer.parseInt(bigSizeAttachLimitCount);
								int pBigAttachDownloadLimitCount = bigSizeAttachDownloadLimitCount == null || bigSizeAttachDownloadLimitCount.equals("") ? 0 : Integer.parseInt(bigSizeAttachDownloadLimitCount);

								StringBuilder html = new StringBuilder();
								html.append( "<div id='_BigAttachListHtml' style='width:100%;'><table width='100%' border='0' cellspacing='0' cellpadding='0' style='font-size:x-small;margin-bottom:10px;'>" +
										"<tr>" +
										"<td colspan='2' style='color:#333;font-weight:bold; padding:0px; margin:0px 0px 1px 0px; height:20px;border-bottom:1px solid #dadada;font-size:12px;'><img src='" + protocol + "://" + mailLinkHostname + "/images/icon_addfile.gif' width='7' height='12' style='margin-right:5px;'>"+ egovMessageSource.getMessage("ezEmail.Nam23", locale)+ "</td>" +
										"</tr>");

								StringBuilder strXml = new StringBuilder();
                                try (InputStreamReader isr = new InputStreamReader(Files.newInputStream(templistFile.toPath()))) {
                                    int read = 0;
                                    while ((read = isr.read()) != -1) {
                                        strXml.append((char) read);
                                    }
                                }

								Document xmlDom = commonUtil.convertStringToDocument(strXml.toString());
								NodeList nodeList = xmlDom.getElementsByTagName("NODE");

								if (nodeList != null) {
									String strTarget = "target=''";
									boolean hasBigAttach = false;

									for (int i = 0; i < nodeList.getLength(); i++) {
										if ("N".equalsIgnoreCase(xmlDom.getElementsByTagName("PBIGFILEUPLOAD").item(i).getChildNodes().item(0).getNodeValue())) {
											continue;
										}

										hasBigAttach = true;
										String fileName = xmlDom.getElementsByTagName("PFILENAME").item(i).getChildNodes().item(0).getNodeValue();
										fileName = fileName.replaceAll("&", "&amp;");

										String fileId = xmlDom.getElementsByTagName("PUPLOADSN").item(i).getChildNodes().item(0).getNodeValue();
										String fileSize = xmlDom.getElementsByTagName("FILESIZE").item(i).getChildNodes().item(0).getNodeValue();
										String fileLocation = xmlDom.getElementsByTagName("FILELOCATION").item(i).getChildNodes().item(0).getNodeValue();
										String fileDate = fileLocation.split("\\|!\\|")[0];
										String strFileExt = fileName.substring(fileName.lastIndexOf("."));
										String defaultFileSize = fileSize;
										
										strFileExt = strFileExt.toLowerCase();
										fileSize = commonUtil.getSizeWithUnit(Integer.parseInt(fileSize));

										String emailHref = protocol + "://" + mailLinkHostname + "/ezEmail/downloadAttachCommon.do?fileid=" + fileId + "&filedate=" + fileDate + "&tid=" + info.getTenantId();
										html.append("<tr>" +
												"<td colspan='2' style='border-left:1px solid #dadada;border-right:1px solid #dadada;border-bottom:1px solid #dadada;  line-height:18px; padding:5px 10px 5px 10px; margin:0px;list-style:none;'>" +
												"<a href='" + emailHref + "' " + strTarget + " style='color:#333333; text-decoration: none;'><img src='" + protocol + "://" + mailLinkHostname + "/images/icon_adddownload.gif' width='16' height='16'  style='margin-right:8px; cursor:pointer;vertical-align:middle' border='0'/></a>" +
												"<a id='BigSizeFileLink' href='" + emailHref + "' " + strTarget + " style='color:#333333; text-decoration: none;font-size:12px;'>" + fileName + " (" + fileSize + ")</a></td>" +
												"</tr>");

										Map<String,Object> fileInfoMap = new HashMap<String,Object>();

										String uploadDate = pBigAttachDownloadPeriod.split(" ~ ")[0].trim();

										fileInfoMap.put("fileId",fileId.substring(0, 36));
										fileInfoMap.put("fileName",fileName);
										fileInfoMap.put("fileSize",defaultFileSize);
										fileInfoMap.put("uploadDate",uploadDate);

										fileInfoList.add(fileInfoMap);
									}

									if (!hasBigAttach) {
										break appendBigAttachesHtml;
									}
								}

								String strXml2 = commonUtil.convertDocumentToString(xmlDom);
								logger.debug("strXml : "+strXml);
								logger.debug("strXml2 : "+strXml2);

                                try (OutputStreamWriter osw = new OutputStreamWriter(Files.newOutputStream(templistFile.toPath()), StandardCharsets.UTF_8)) {
                                    osw.write(strXml2);
                                }

								html.append("<tr>" +
										"<td width='50%' style='font-size:11px; font-weight:normal; color:#666666; padding-left:10px; margin:0px; border-bottom:1px solid #dadada;border-left:1px solid #dadada; background:#f6f6f6; height:25px; line-height:25px;'>" + egovMessageSource.getMessage("ezEmail.Nam19", locale) + "<span style='color:#FF0000 ;'>" + pBigAttachDownloadPeriod + "</span></td>" +
										"<td width='50%' align='right' style='font-size:11px; font-weight:normal; color:#666666; padding-right:10px; margin:0px; border-bottom:1px solid #dadada;border-right:1px solid #dadada; background:#f6f6f6; height:25px; line-height:25px;'>" + egovMessageSource.getMessage("ezEmail.Nam20", locale) + "<span style='color:#FF0000 ;'>" + pBigAttachDownloadDay + egovMessageSource.getMessage("ezEmail.Nam21", locale) +"</span>"+egovMessageSource.getMessage("ezEmail.Nam22", locale));

								if (pBigAttachDownloadLimitCount == 1) {
									html.append(" / " + "" + " <span style='color:#FF0000 ;'>" + pBigAttachDownloadLimitCount + "</span>" + egovMessageSource.getMessage("ezEmail.Nam18", locale));
								} else if (pBigAttachDownloadLimitCount > 1) {
									html.append(" / " + "" + " <span style='color:#FF0000 ;'>" + pBigAttachDownloadLimitCount + "</span>" + egovMessageSource.getMessage("ezEmail.Nam18", locale));
								}

								html.append("</div></td></tr></table></div>");

								ezEmailService.setBigAttachCountInfo(fileInfoList,pBigAttachDownloadLimitCount,info.getTenantId(),info.getUserId());

								textBody = html + textBody;
							}
						}

						Matcher imageMatcher = MOBILE_DOWNLOAD_IMAGE_PATTERN.matcher(textBody);
						StringBuffer sb = new StringBuffer();

						while (imageMatcher.find()) {
							// dhlee : 20221027 - 사이냅 웹에디터를 사용하는 닷넷 모바일에서 이미지 업로드를 지원하기 위해 Upload_Common 폴더 관련 처리를 추가함.
							String extractedPath = imageMatcher.group(1) != null ? imageMatcher.group(1) : imageMatcher.group(2);
							String imagePath = realPath + extractedPath;
							File imageFile = new File(imagePath);
							if (imageFile.exists()) {
								String imageExt = FilenameUtils.getExtension(imageFile.getName());
								String imageName = UUID.randomUUID().toString() + "." + imageExt;
	
								String cid = imageName + "@12345678.87654321";
								String cidWithBrackets = "<" + cid + ">";
	
								String contentType = null;
	
								try (FileInputStream is = new FileInputStream(imageFile)) {
									contentType = URLConnection.guessContentTypeFromStream(is);
								} catch(FileNotFoundException e) {
									logger.error(e.getMessage(), e);
								} catch(Exception e) {
									logger.error(e.getMessage(), e);
								}
	
								if (contentType == null) {
									contentType = Files.probeContentType(imageFile.toPath());
								}
	
								MimeBodyPart imagePart = new MimeBodyPart();
								FileDataSource fileSource = new FileDataSource(imageFile);
	
								imagePart.setDataHandler(new DataHandler(fileSource));
								imagePart.setFileName(imageName);
								imagePart.setHeader("Content-Type", contentType);
								imagePart.setContentID(cidWithBrackets);
								imagePart.setDisposition(Part.INLINE);
	
								imageParts.add(imagePart);

								// dhlee : 20221027 - 사이냅 웹에디터를 사용하는 닷넷 모바일에서 이미지 업로드를 지원하기 위해 Upload_Common 폴더 관련 처리를 추가함.
								if (imageMatcher.group(1) == null ) {
									cid = cid + "\"";
								}
	
								imageMatcher.appendReplacement(sb, "src=\"cid:" + cid);
							}
						}

						textBody = imageMatcher.appendTail(sb).toString();

						// 모드가 SEND 일 때는 메일 서명 div의 id를 MailSignSent로 바꾼다.
						if (isSending) {
							textBody = textBody.replace("div id=\"MailSign\"", "div id=\"MailSignSent\"");
						}

						// p태그에 기본 폰트를 적용한다.
						textBody = textBody.replace("<p>", "<p " + defaultFontAndSize + ">");
						
			            content.setContent(textBody, "text/html; charset=utf-8");
			
			            // multipart/alternative로 구성한다.
		                alternativePart = new MimeMultipart("alternative");
			            
		                // text/plain 파트를 구성한다.
			            MimeBodyPart textPlainPart = new MimeBodyPart();
			            
			            // HTML 태그들을 제거한 Plain Text로 변환한다. 
			            Source htmlSource = new Source(textBody);
			            Renderer htmlRend = new Renderer(htmlSource);
			            textPlainPart.setText(htmlRend.toString(), "utf-8");	
			            
			            // text/plain 파트를 추가한다.
			            alternativePart.addBodyPart(textPlainPart);

						if (imageParts.isEmpty()) {
							// text/html 파트를 추가한다. content가 text/html 파트를 갖고 있다.
							alternativePart.addBodyPart(content);
						} else {
							// 이미지가 있을 때 related part를 구성한다.
							MimeBodyPart wrap = new MimeBodyPart();
							relatedPart = new MimeMultipart("related");

							relatedPart.addBodyPart(content);

							for (MimeBodyPart imagePart : imageParts) {
								relatedPart.addBodyPart(imagePart);
							}

							wrap.setContent(relatedPart);
							alternativePart.addBodyPart(wrap);
						}
//			            
			            message.setContent(alternativePart);
					} else if (textOption.equalsIgnoreCase("PLAIN")) {
						message.setContent(textBody, "text/plain; charset=utf-8");
	                	content.setContent(textBody, "text/plain; charset=utf-8");
					}
					
				
					// 메일 중요도
					switch (importance) { // 2: High, 1: Normal, 0: Low
			            case "0": message.setHeader("X-Priority", "5");
			                break;
			            case "1": message.setHeader("X-Priority", "3");
			                break;
			            case "2": message.setHeader("X-Priority", "1");
			                break;
			            default: message.setHeader("X-Priority", "3");
			                break;
			        }

					// 추적(배달되면 알림)
					logger.debug("replyReadTime=" + replyReadTime);
					if (replyReadTime.equals("0")) {
						message.setHeader("Return-Receipt-To", ((InternetAddress)message.getFrom()[0]).getAddress());
					}

			        // 추적(수신확인)
			        logger.debug("replyReadTime=" + replyReadTime);
			        if (replyReadTime.equals("1") || replyReadTime.equals("2")) {
			        	//message.setHeader("X-JMocha-Disp-Noti-To", ((InternetAddress)message.getFrom()[0]).getAddress());
			        	message.setHeader("X-JMocha-Disp-Noti-To", userEmail); // mdn은 사용자의 real address로 입력
			        }

					// 추적(외부 수신확인)
					if (replyReadTime.equals("2")) {
						message.setHeader("X-JMocha-Ext-Receipt", "1");
						message.setHeader("X-JMocha-Ext-ServerName", https + serverNameByTenantId);
					}
		        
			        // SentDate 설정
			        message.setSentDate(Calendar.getInstance().getTime());
			        
			        // User-Agent 설정
			        message.setHeader("User-Agent", "JMocha Mail 1.0");	        
			        		        
			        
		            // 임시 보관함에 메시지가 있는 경우 해당 메시지와 병합 작업을 수행한다.
			        Message oldMessage = null;
			        long uid = 0;
			        
			        Folder draftFolder = ia.getFolder(ezEmailUtil.getDraftsFolderId(locale));
			        draftFolder.open(Folder.READ_WRITE);
			        
			        logger.debug("url=" + url);
			        
			        if (!url.trim().equals("") || !orgMessageId.trim().equals("")) {
			        	if (!url.trim().equals("")){
			        		uid = Long.parseLong(url);
			        	} else if (!orgMessageId.trim().equals("")){
			        		uid = Long.parseLong(orgMessageId);
			        	}
			        	
			        	MimeMultipart mixedPart = new MimeMultipart();
						
						if (uid != 0) {
						    // 임시 보관함에 있는 기존 메시지를 불러온다.
							oldMessage = ((IMAPFolder)draftFolder).getMessageByUID(uid);
							
							if (oldMessage != null) {
								// copy existing headers that are needed.
								String[] headers = oldMessage.getHeader("References");
								
								if (headers != null) {
									message.setHeader("References", headers[0]);
								}
								
								headers = oldMessage.getHeader("In-Reply-To");
								
								if (headers != null) {
									message.setHeader("In-Reply-To", headers[0]);
								}
								
								// 기존 메시지가 Multipart 메시지일 경우의 처리
								if (oldMessage.getContent() instanceof Multipart) {
									String mobileDownloadInline = "/ezEmail/downloadInline.do";
									String dotNetIntegration = ezCommonService.getTenantConfig("dotNetIntegration", info.getTenantId());
									
									if (dotNetIntegration.equals("YES")) {
										mobileDownloadInline = config.getProperty("config.MobileDownloadInline");
									}
									
								    // 기존 메시지의 Multipart를 불러온다.
									Multipart mp = (Multipart)oldMessage.getContent();
									int count = mp.getCount();
									BodyPart p = null;
									boolean hasAttach = false;
									
									// Multipart의 각 Part별 처리를 수행한다.
									for (int i = 0; i < count; i++) {
										p = mp.getBodyPart(i);
										
										while (true) {
										    // Part가 Related Part일 경우의 처리
		    								if (alternativePart != null && p.isMimeType("multipart/related")) {
		    									logger.debug("Part is multipart/related");
		    								    
		    									hasAttach = true;
		    									
		    									logger.debug("relatedPart=" + relatedPart);
		    									
		    									if (relatedPart == null) {
		    										relatedPart = new MimeMultipart("related");
		    										    							
		    					                    MimeBodyPart wrap = new MimeBodyPart();
		    					                    wrap.setContent(relatedPart);
		    					                    alternativePart.removeBodyPart(1);
		    					                    alternativePart.addBodyPart(wrap, 1);
		    									}
		    									// new related part is already created by the above routine
		    									// for adding new in-line images.
		    									else {
		    										relatedPart.removeBodyPart(0);
		    									}
		    									
		    									// 기존 메시지의 Related Part와 병합한다.
		    									Multipart existingRelatedPart = (Multipart)p.getContent();
		    									int existingRelatedPartCount = existingRelatedPart.getCount();
		    									BodyPart existingRelatedSubPart = null;
		    									
		    									for (int j = 0; j < existingRelatedPartCount; j++) {
		    									    existingRelatedSubPart = existingRelatedPart.getBodyPart(j);
		    										
		    										if (existingRelatedSubPart instanceof MimePart) {
		    										    String contentId = ((MimePart)existingRelatedSubPart).getContentID();
		    										    logger.debug("Existing ContentId=" + contentId);
		    										    
		    											if (contentId != null && !contentIdSet.contains(contentId)) {
		    												logger.debug("Adding ContentId=" + contentId);
		    											    
		    												relatedPart.addBodyPart(existingRelatedSubPart);						
		    											}
		    										}				
		    									}
		    									
		    									String bodyContent = content.getContent().toString();
		    									bodyContent = convertDownloadInlineImageURLtoCid(bodyContent, mobileDownloadInline);							
		    									content.setContent(bodyContent, "text/html; charset=utf-8");
		    									relatedPart.addBodyPart(content, 0);
		    									
		    									removeUnusedInlineImagePart(relatedPart);
		    								}
		    								// Part가 Alternative Part일 경우의 처리
		    								else if (alternativePart != null && p.isMimeType("multipart/alternative")) {
		    									logger.debug("Part is multipart/alternative");
		    								    
		    								    hasAttach = true;
		    								    
		                                        Multipart existingAlternativePart = (Multipart)p.getContent();
		                                        int existingAlternativePartCount = existingAlternativePart.getCount();
		                                        BodyPart existingAlternativeSubPart = null;
		                                        boolean isRelatedFound = false;
		                                        
		                                        for (int j = 0; j < existingAlternativePartCount; j++) {
		                                            existingAlternativeSubPart = existingAlternativePart.getBodyPart(j);
		                                            
		                                            if (existingAlternativeSubPart instanceof MimePart) {
		                                                // Alternative Part 안에 Related Part가 있는 경우에 대한 처리
		                                                if (existingAlternativeSubPart.isMimeType("multipart/related")) {
		                                                    isRelatedFound = true;
		                                                    break;
		                                                }
		                                            }               
		                                        }						
		                                        
		                                        if (isRelatedFound) {
		                                            // p를 발견된 related 파트로 변경하여 루프의 시작 부분에 있는 related 파트 처리 부분으로 제어를 옮긴다.
		                                            p = existingAlternativeSubPart;
		                                            continue;
		                                        }
		                                    }								
		                                    // there are cases where an in-line image part doesn't have
		                                    // a Content-Disposition header, but has a Content-ID header.    								
		    								else if (p instanceof MimePart 
		    								        && ((MimePart)p).getContentID() != null) {
		    								    String contentId = ((MimePart)p).getContentID();
		    								    logger.debug("Existing ContentId=" + contentId);
		    								    
		    								    if (!contentIdSet.contains(contentId)) {
		    								    	logger.debug("Adding ContentId=" + contentId);
		    								        
		    								        mixedPart.addBodyPart(p);
		    								    }
		    								}											
		    								// Content-Disposition 헤더가 없이 첨부된 파일이 있어
		    								// Content-Type이 application으로 시작하는 경우도 추가함 
		    								// 예) Content-Type: application/octet-stream;
		    								//         name="=?utf-8?B?NDExMDAwODE1OS5QREY=?="
		    							    //    Content-Transfer-Encoding: base64	    								
		    								else if (p.getDisposition() != null || p.isMimeType("application/*")) { 
		    									mixedPart.addBodyPart(p);
		    									
		    									// 첨부파일 파트인 경우
		    									if ((p.getDisposition() != null && p.getDisposition().equalsIgnoreCase(Part.ATTACHMENT))
		    											|| p.isMimeType("application/*")) {
		    										hasAttach = true;
		    									}
		    								}
		    								// Part가 message 인 경우, 즉 메일이 첨부된 경우
		    								else if (p.isMimeType("message/*")) {
		    								    logger.debug("Part is message");
		    								    
		    									mixedPart.addBodyPart(p);
		    									hasAttach = true;
		    								}							
		    								
		    								break;
										}
									}
									
									// 기존 메시지에 첨부파일이 있거나 Alternative Part 혹은 Related Part가 있는 경우의 처리
									if (hasAttach) {
										if (alternativePart != null) {
											MimeBodyPart wrap = new MimeBodyPart();
											wrap.setContent(alternativePart);
											mixedPart.addBodyPart(wrap, 0);
										} else {
											mixedPart.addBodyPart(content, 0);
										}							
										
										message.setContent(mixedPart);							
									}
									// 기존 메시지가 Related Part일 경우의 처리
									else if (oldMessage.isMimeType("multipart/related")) {
									    logger.debug("oldMessage is multipart/related");
									    logger.debug("relatedPart=" + relatedPart);
										
		                                if (alternativePart != null) {								
		    								// 새로 추가되는 이미지 파트들을 추가한다.
		    								// 기존 메시지의 이미지 파트들은 위에서 이미 mixedPart에 추가되어 있다.
		    								// a new related part is already created by the above routine
		    								// for adding new in-line images.						
		    								if (relatedPart != null) {
		    									relatedPart.removeBodyPart(0);
		    									
		    									BodyPart relatedSubPart = null;
		    									for (int i = 0; i < relatedPart.getCount(); i++) {
		    										relatedSubPart = relatedPart.getBodyPart(i);
		    										mixedPart.addBodyPart(relatedSubPart);
		    									}
		    								}
		    								
		    								// 기존 메시지가 Related Part인 경우는 첨부파일이 없는 경우이므로 mixed가 아니다.
		    								// this mixedPart is actually a related part.
		    								mixedPart.setSubType("related");
		    								
		    								String bodyContent = content.getContent().toString();																
		                                    bodyContent = convertDownloadInlineImageURLtoCid(bodyContent, mobileDownloadInline);                          
		                                    content.setContent(bodyContent, "text/html; charset=utf-8");                            
		                                    mixedPart.addBodyPart(content, 0);
		                                    
		                                    removeUnusedInlineImagePart(mixedPart);
		                                                                        
		                                    MimeBodyPart wrap = new MimeBodyPart();
		                                    wrap.setContent(mixedPart);
		                                    alternativePart.removeBodyPart(1);
		                                    alternativePart.addBodyPart(wrap, 1);                                                                               
		                                } 
									}									
								}					
							}
						}
			        }        
			        
			        // mailboxUsage + messageSize >= mailboxQuota인 경우 OVERQUOTA Exception
			        CountOutputStream cos = null;
			        double messageSize = 0;
			        
			        try {
			        	cos = new CountOutputStream();
			        	message.writeTo(cos);
			        	messageSize = cos.getSize() / 1024.0;
			        } catch (Exception e) {
			        	logger.error(e.getMessage(), e);
			        	
			        	result.put("status", "error");
	        			result.put("code", 1);			
	        			result.put("data", "");
			        } finally {
			        	try { 
			        		cos.close(); 
			        	} catch (Exception e) {
				        	result.put("status", "error");
		        			result.put("code", 1);			
		        			result.put("data", "");
	        			}
			        }
			        
			        logger.debug("mailboxUsage=" + mailboxUsage + ", messageSize=" + messageSize + ", mailboxQuota=" + mailboxQuota);
			        
			        if (mailboxUsage + messageSize >= mailboxQuota) {
						throw new Exception("OVERQUOTA");
					}
			        
			        // messageSize가 maxMessageSize 넘을 경우 OVERMESSAGESIZE Exception
			        int maxMessageSize = ezEmailService.getMaxMessageSize(info.getTenantId());
			        
			        if (maxMessageSize > 0 && messageSize > maxMessageSize) {
			        	double maxMessageSizeD = maxMessageSize / 1024.0;
			        	maxMessageSizeD = Math.round(maxMessageSizeD * 10) / 10;
			        	
			        	double messageSizeD = messageSize / 1024.0;
			        	messageSizeD = Math.round(messageSizeD * 10) / 10;
			        	
			        	throw new Exception("OVERMESSAGESIZE:" + maxMessageSizeD + "MB:" + messageSizeD + "MB");
			        }
			        
			        if (cmd.equalsIgnoreCase("SAVE")) {
			        	logger.debug("Saving the message");
			        	
			    		message.setFlag(Flags.Flag.SEEN, true);
			    		AppendUID[] uids = ((IMAPFolder)draftFolder).appendUIDMessages(new Message[]{message});
			    		
			    		if (uids != null && uids[0] != null) {
			    			draftUID = uids[0].uid;
			    		} 
			    	
			            // this deletion code block has been moved here because
			            // it needs to be kept in Drafts if an error occurs during the above process.
			            if (oldMessage != null) {
			            	oldMessage.setFlag(Flags.Flag.DELETED, true);
			            }		        
			        } else if (cmd.equalsIgnoreCase("SEND")) {
			        	logger.debug("Sending the message");
			        	
	                    Folder sentFolder = ia.getFolder(ezEmailUtil.getSentFolderId(locale), apprmail);
	                    		        			                            
	                    message.setFlag(Flags.Flag.SEEN, true);
			            
			            // mailSendCompleted가 true인 경우는 메일 전송까지 완료된 이후에 Exception이 발생하여 Retry하는 경우이다.
			            // 이 경우에는 이미 보낸편지함에 저장된 메일이 있으므로 보낸편지함에 다시 저장하지 않는다.
			            if (mailSendCompleted == false) {
				            // 편지함 용량 초과 메세지 확인을 위해 임시저장
		                    // 본래는 임시보관함에 미리 저장해두고 성공했을 시 임시보관함에 있는 메일을 보낸메일함으로 복사하였으나
				            // 보낸메일함에 바로 저장하는 것으로 변경함.
		                    AppendUID[] uids = ((IMAPFolder)sentFolder).appendUIDMessages(new Message[]{message});
		                    if (uids != null && uids[0] != null) {
		                        sentFolderMessageUID = uids[0].uid;
		                    } 
			            }
			            			            	
		                // this deletion code block has been moved here because
		                // it needs to be kept in Drafts if an error occurs during the above process.
		                if (oldMessage != null) {
		                	oldMessage.setFlag(Flags.Flag.DELETED, true);
		                }
	
		                // mailSendCompleted가 true인 경우는 Transport.send가 완료된 이후에 예외가 발생하여 Retry하는 경우이다.
		                // 이 경우에는 메일을 다시 전송하지 않는다.
		                if (mailSendCompleted == false) {
		                	if (!apprmail) {
		                		Transport.send(message);
		                	} else {
		                		// 승인메일 로그 저장
		                		try {
		                			Map<String, Object> paramMap = new HashMap<String, Object>();
		                			paramMap.put("lang", info.getLang());
		                			paramMap.put("primary", info.getPrimary());
		                			paramMap.put("locale", locale);
		                			paramMap.put("companyId", info.getCompanyId());
		                			
			                		if ("ALL_HANDS".equalsIgnoreCase(apprmailType)) {
			                			ezEmailService.applyApprCompMail(info.getUserId(), info.getTenantId(), paramMap, sentFolderMessageUID, message);
			                		} else {
			                			ezEmailService.applyApprMail(info.getUserId(), info.getTenantId(), paramMap, sentFolderMessageUID, message, apprmailApprover);
			                		}
								} catch (Exception e) {
									String eMsg = e.getMessage();
									logger.error(eMsg, e);
									// APPR_ERROR_ALLHANDS_NOT_EXIST:회사관리자가 없는 경우, APPR_ERROR_NORMAL_NOT_EXIST:승인자가 없는 경우
									if (!eMsg.contains("APPR_ERROR")) {eMsg = "APPR_ERROR"; }
									
		                			throw new Exception(eMsg + "_" + sentFolderMessageUID);
								}
		                	}

		                	sentFolderMessageUID = 0;
			            	mailSendCompleted = true;
		                }
			            				                	            				        					            
			            // set the ANSWERED flag of the original message to indicate it has been replied.
			            if (mailcmd.equals("REPLY") || mailcmd.equals("REPLYALL") || mailcmd.equals("FORWARD")) {
		    				String orgMsgFolderPath = orgFolderId;
		    				long orgMsgUid = Long.parseLong(orgMessageId);
	
		    				logger.debug("orgMsgFolderPath=" + orgMsgFolderPath + ",orgMsgUid=" + orgMsgUid);
		    				
		    		        Folder orgMsgFolder = ia.getFolder(orgMsgFolderPath);
		    		        orgMsgFolder.open(Folder.READ_WRITE);
		    				
		    		        Message orgMessage = ((IMAPFolder)orgMsgFolder).getMessageByUID(orgMsgUid);
	    		        	
		    		        if (mailcmd.equals("REPLY") || mailcmd.equals("REPLYALL")) {
		    		        	orgMessage.setFlag(Flags.Flag.ANSWERED, true);
		    		        	ezEmailUtil.setForwardedFlag(orgMessage, false);
		    		        }
		    		        else {
		    		        	ezEmailUtil.setForwardedFlag(orgMessage, true);
		    		        	orgMessage.setFlag(Flags.Flag.ANSWERED, false);
		    		        }

		    		        // 전달, 회신
	    		        	ezEmailUtil.setSentDateFlag(orgMessage, true);
	    		        	
		    		        orgMsgFolder.close(true);
			            }
				        
				        // file system의 templist txt파일 삭제
			            if (!stateName.isEmpty()) {
					        String pDirPath = realPath + commonUtil.getUploadPath("upload_mail.ROOT", info.getTenantId()) + commonUtil.separator + "templist";
					        pDirPath += commonUtil.separator + stateName + ".txt";
					        File f = new File(pDirPath);
					        
					        if (f.exists()) {
					        	f.delete();
					        }			        
			            }
			        }
			        		        
			        draftFolder.close(true);
			        
			        pResult = "<RESULT>OK</RESULT>";
			        pResult += "<MESSAGEID><![CDATA[" + draftUID + "]]></MESSAGEID>";	
			        
					if (!cmd.equalsIgnoreCase("SAVE")) {
						// 2024-11-13 김은실 : 최근 사용 주소 테이블에(jmocha_address_last_sent) insert.
						try {
							ezAddressService.insertLastSentEmailAddresses(addressCheck, info.getTenantId(), info.getUserId());
							/* MEmailGWController.java> mMailSend()에는 shareId가 딱히 없음.
							 * shareId가 있었다면 ezEmailService.checkUserShareId 체크를 했었어야 함. */
						} catch (NullPointerException e) {
							logger.debug("insertLastSentEmailAddresses insert fail.");
							logger.error(e.getMessage(), e);
						} catch (Exception e) {
							logger.debug("insertLastSentEmailAddresses insert fail.");
							logger.error(e.getMessage(), e);
						}

						// useAutoSaveMailAddress가 YES일 경우, 외부수신자의 메일주소를 개인주소록에 자동 저장 (코린도)
						String autoSaveAddress = ezCommonService.getTenantConfig("useAutoSaveMailAddress", info.getTenantId());

						if (autoSaveAddress.equals("YES")) {
							try {
								ezEmailUtil.outerMailInsertAddress(addressCheck,info.getUserId(),info.getTenantId(),
										userEmail,info.getUserName(),info.getUserName2());
							} catch (Exception e) {
								logger.debug("AutoEmailUtil insert fail.");
								logger.error(e.getMessage(), e);
							}
						}
					}
			        
				} catch (Exception e) {
					logger.error(e.getMessage(), e);
					
					if (e.getMessage().indexOf("OVERQUOTA") > -1 || e.getMessage().indexOf("OVERMESSAGESIZE") > -1) {
						logger.error("mailInterSend : " + e.getMessage());
						
						pResult = e.getMessage();
						
						result.put("status", "error");
		    			result.put("code", 1);			
		    			result.put("data", pResult);
					} else if (e.getMessage().indexOf("Invalid Addresses") > -1) {
						pResult = e.getMessage();
						String cause = e.getCause().toString();
						
						String pattern = "Unknown user: ([\\S]+)";
						Pattern r = Pattern.compile(pattern);
						Matcher m = r.matcher(cause);
						pResult = "Invalid Addresses:";
						
						int index = 1000;
						
						while (m.find()) {
							// 1000번 이상 반복되면 break한다.
							--index;
							if (index < 0) {
								logger.error("Stop finding invalid addresses, because over 1000 times.");
								break;
							}
							
							pResult += m.group(1) + "|";
						}
						
						invalidAddressesError = true;
						pResult = pResult.substring(0, pResult.length() - 1);
						result.put("status", "error");
		    			result.put("code", 1);			
		    			result.put("data", pResult);
					} else if(e.getMessage().indexOf("APPR_LOG_ERROR") > -1) {
						// 승인메일 로그 저장 시에 오류 발생 시, 공유사서함에 저장된 메일 삭제하기 위해서 추가
						String[] emsg = e.getMessage().split("_");
						mailSendCompleted = false;
						sentFolderMessageUID = Long.parseLong(emsg[emsg.length-1]);
						pResult = "APPR_ERROR";
					} else { // retry
						logger.error(e.getMessage(), e);
						
						retryFlag = true;
						--retryCount;
						
						if (retryCount > -1) {
							logger.debug("Message send fail. Retry...");
							
							try {
								Thread.sleep(1000);
							} catch (Exception ex) {}
						} else {
							// 더이상 retry를 하지 않으므로 리턴 메시지를 세팅한다.
							pResult = e.getMessage();
						}
					}
					
					// return result;
				} finally {
					if (ia != null) {
						ia.close();
						ia = null;
					}
				}			
			} while (retryFlag && retryCount > -1);
		
		    // 보낸편지함에 메일이 저장되었지만 메일 전송이 성공하지 못했다면 해당 메일을 삭제한다.
		    if (mailSendCompleted == false && sentFolderMessageUID != 0) {
                Folder sentFolder = null;
                        
                try {
                    Thread.sleep(1000);
                    
                    ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
                            userEmail, password, egovMessageSource, locale, ezEmailUtil, apprSharedMailBox);                
                    
                    sentFolder = ia.getFolder(ezEmailUtil.getSentFolderId(locale), apprmail);
                    sentFolder.open(Folder.READ_WRITE);
                    Message sentMessage = ((IMAPFolder)sentFolder).getMessageByUID(sentFolderMessageUID);
                    sentMessage.setFlag(Flags.Flag.DELETED, true);
                    sentFolder.close(true);
                    sentFolder = null;
                    
                    logger.debug("sentFolderMessageUID message deleted successfully.");
                    
                    /*result.put("status", "ok");
        			result.put("code", 0);			
        			result.put("data", ""); */       			
                } catch (Exception e) {
                	logger.error(e.getMessage(), e);
                	
        			/*result.put("status", "error");
        			result.put("code", 1);			
        			result.put("data", "");*/
        			
                    logger.error("Failed to delete sentFolderMessageUID message. sentFolderMessageUID=" + sentFolderMessageUID);
                } finally {
                    if (sentFolder != null) {
                        try {
                            sentFolder.close(true);
                        } catch (Exception e) {
							logger.error(e.getMessage(), e);
						}
                        
                        sentFolder = null;
                    }
                    
                    if (ia != null) {
                        ia.close();
                        ia = null;
                    }                    
                }                                           
		    }
				    		    
			logger.debug("mailInterSend ended. pResult=" + pResult);

			logger.debug("invalidAddressesError={}", invalidAddressesError);
			if (result != null && !"error".equalsIgnoreCase((String) result.get("status")) ) {
				result.put("status", "ok");
				result.put("code", 0);			
				result.put("data", "");
			}
			/*if (!invalidAddressesError){
				result.put("status", "ok");
				result.put("code", 0);			
				result.put("data", "");		
			}*/
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");		
		}
		
		logger.debug("mailInterSend ended. result=" + result);
		logger.debug("MOBILE G/W MAIL mMailSend ended.");
		
		return result;
	}
	
	/**
	 * 모바일 G/W 이메일 [GET] 메일 읽기
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezemail/folders/{folderId}/mails/{messageId}/users/{userId:.+}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public Object mMailRead(HttpServletRequest request, @PathVariable String folderId, @PathVariable String messageId, @PathVariable String userId) throws Exception {
		logger.debug("MOBILE G/W MAIL mMailRead started.");
		logger.debug("folderId=" + folderId + ",messageId=" + messageId + ",userId=" + userId);
				
		JSONObject result = new JSONObject();
		JSONObject mail = new JSONObject();
		IMAPAccess ia = null;
		List<Map<String, String>> attachedFileList = new ArrayList<Map<String, String>>();
		
		try {		
			folderId = URLDecoder.decode(folderId, "UTF-8");
			
			// get user credentials
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			String domainName = ezCommonService.getTenantConfig("DomainName", info.getTenantId());
			String userEmail = info.getUserId() + "@" + domainName;
			String password = jspw;
			
			String ld = commonUtil.getTwoLetterLangFromLangNum(info.getLang());
			Locale locale = new Locale(ld);
			
			String useMobileViewer = ezCommonService.getTenantConfig("useMobileViewer", info.getTenantId());
			String pAttachListHtmlSub = null;
			
			List<String> bodyInfoList = null;
			
			logger.debug("userEmail=" + userEmail);
			
			// retrieve the passed in parameters
			
			long uid = Long.parseLong(messageId);
			
			String pnFlag = "N";
	
			Address[] arrFroms = null;
			Address[] arrRecipientsTo = null;
			Address[] arrRecipientsCC = null;
			Address[] arrRecipientsBCC = null;
			Date date = null;
			String fromStr = null;
			String fromEmail = null;
			String toStr = null;
			String toHiddenStr = null;
			String toMobileStr = "";
			String toList = "";
			String ccStr = null;
			String ccHiddenStr = null;
			String ccMobileStr = "";
			String ccList = "";
			String bccStr = "";
			String bccMobileStr = "";
			String bccList = "";
			String subject = null;
			String dateStr = null;
			String title = null;
			String pReadFlag = "Y";
			String isDelete = "BMOVE";
			boolean isSentItems = false;
			String pIsCCFg = "Y";
			String flagged = "0";
			boolean useMailTag = false;
			String[] tags = null;
		
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userEmail, password, egovMessageSource, locale, ezEmailUtil);
			Folder f = ia.getFolder(folderId);
			
			if (f == null || !f.exists()) {
				logger.error("Folder not found. folderPath=" + folderId);
			} else {
				f.open(Folder.READ_WRITE);
				
				logger.debug("folderId = " + folderId + ", uid = " + uid);
				
				Message message = null;
				
				if (f.isOpen() && f instanceof IMAPFolder) {
					message = ((IMAPFolder)f).getMessageByUID(uid);
				}
				
				if (message == null) {
					//to-do 메일이 없습니다. 와 같은 문구를  보내주고 싶은데 아마 메일이 있는지 체크하는 메소드를 다시 만들어야 할 거 같다.
					logger.error("Message not found. uid=" + uid);
					result.put("status", "ok");
					result.put("code", 0);			
					result.put("data", "");
					
					return result;
				} else {
					FetchProfile fp = new FetchProfile();
					
					fp.add(FetchProfile.Item.ENVELOPE);
					fp.add(IMAPFolder.FetchProfileItem.INTERNALDATE);
					fp.add(FetchProfile.Item.SIZE);
					fp.add(FetchProfile.Item.FLAGS);
					fp.add("Subject");
					fp.add("From");
					fp.add("To");
					fp.add("Cc");
					fp.add("Bcc");
					
					Message[] fetchMessages = new Message[] {message};
					f.fetch(fetchMessages, fp);
					
					// From
					arrFroms = message.getFrom();
					
					if (arrFroms != null) {
						fromStr = ezEmailUtil.getFromNameOrAddressOfMessage(message);
						fromStr = commonUtil.trimDoubleQuotes(fromStr);
								
						fromEmail = ((InternetAddress)arrFroms[0]).getAddress();

						// 2025-09-17 김은실: 메일읽기 시 From주소 등 웹과 모바일이 처리가 통일되지않아 누락 가능성이 높다. 나중에 한번 응집처리가 필요해보임. (웹) /ezEmail/mailRead.do (모바일) this
						if (fromStr.equals(fromEmail)) {
							List<String> mailAddrList = ezEmailUtil.mailAddrNameParse(fromStr, fromEmail);
							fromStr = mailAddrList.get(0);
							fromEmail = mailAddrList.get(1);
						}
					} else {
						String[] fromHeaders = message.getHeader("From");
						
						if (fromHeaders != null) {
							fromStr = MimeUtility.decodeText(message.getHeader("From")[0]);
						}
					}
					
					logger.debug("From=" + fromStr);
					
					// TO
					arrRecipientsTo = message.getRecipients(Message.RecipientType.TO);
					
					if (arrRecipientsTo != null) {
						boolean toListme = false;
						for (int i = 0; i < arrRecipientsTo.length; i++) {
							if (((InternetAddress)arrRecipientsTo[i]).getAddress().equals(userEmail)) {
								toListme = true;
								break;
							}
						}
						
						String toHeader = message.getHeader("To")[0];
						boolean isAscii = ezEmailUtil.isPureAscii(toHeader);						
						String name = null;
						
						for (int i = 0; i < arrRecipientsTo.length; i++) {
							name = ((InternetAddress)arrRecipientsTo[i]).getPersonal();
							
							if (name == null) {
								name = ((InternetAddress)arrRecipientsTo[i]).getAddress();
							} else {
								if (!isAscii) {
									byte[] rawBytes = name.getBytes("iso-8859-1");
									
									name = ezEmailUtil.decodeNonAsciiBytes(rawBytes);								
								} else {
									name = MimeUtility.decodeText(name);
								}
								
								name = commonUtil.trimDoubleQuotes(name);
							}
							
							logger.debug("TO=" + name + ((InternetAddress)arrRecipientsTo[i]).getAddress());
							
							if (toListme) {
								if (((InternetAddress)arrRecipientsTo[i]).getAddress().equals(userEmail)) {
									if (arrRecipientsTo.length > 1) {
										toStr = getReceiverHTML(name, ((InternetAddress)arrRecipientsTo[i]).getAddress()) + "<span>&nbsp;(" + egovMessageSource.getMessage("ezEmail.t10000", locale) + arrRecipientsTo.length + egovMessageSource.getMessage("ezEmail.t10001", locale) + ")&nbsp;<img src='/images/expnd.gif'  style='cursor:pointer;' onclick='ShowHiddenTo(this);' align='absmiddle'></span>";
									} else {
										toStr = getReceiverHTML(name, ((InternetAddress)arrRecipientsTo[i]).getAddress());
									}
								}
								
								if (toHiddenStr == null) {
									toHiddenStr = getReceiverHTML(name, ((InternetAddress)arrRecipientsTo[i]).getAddress());
								} else {
									toHiddenStr += " , " + getReceiverHTML(name, ((InternetAddress)arrRecipientsTo[i]).getAddress());
								}
							} else {
								if (i == 0) {
									if (arrRecipientsTo.length > 1) {
										toStr = getReceiverHTML(name, ((InternetAddress)arrRecipientsTo[i]).getAddress()) + "<span>&nbsp;(" + egovMessageSource.getMessage("ezEmail.t10000", locale) + arrRecipientsTo.length + egovMessageSource.getMessage("ezEmail.t10001", locale) + ")&nbsp;<img src='/images/expnd.gif'  style='cursor:pointer;' onclick='ShowHiddenTo(this);' align='absmiddle'></span>";
									} else {
										toStr = getReceiverHTML(name, ((InternetAddress)arrRecipientsTo[i]).getAddress());
									}
								}
								
								if (toHiddenStr == null) {
									toHiddenStr = getReceiverHTML(name, ((InternetAddress)arrRecipientsTo[i]).getAddress());
								} else {
									toHiddenStr += " , " + getReceiverHTML(name, ((InternetAddress)arrRecipientsTo[i]).getAddress());
								}
							}
							
							if (i == arrRecipientsTo.length - 1) {
								toMobileStr +=  getMobileReceiverHTML(name, ((InternetAddress)arrRecipientsTo[i]).getAddress());
							} else {
								toMobileStr +=  getMobileReceiverHTML(name, ((InternetAddress)arrRecipientsTo[i]).getAddress()) + "&nbsp;,&nbsp;";
							}
							
							// HTML 태그가 없는 To 정보
							if (toList.equals("")) {
								toList = name + " <" + ((InternetAddress)arrRecipientsTo[i]).getAddress() + ">";
							} else {
								toList += "," + name + " <" + ((InternetAddress)arrRecipientsTo[i]).getAddress() + ">";
							}															
						}
					}
					
					// CC
					arrRecipientsCC = message.getRecipients(Message.RecipientType.CC);
					if (arrRecipientsCC != null) {
						boolean ccListme = false;
						
						for (int i=0; i<arrRecipientsCC.length; i++) {
							if (((InternetAddress)arrRecipientsCC[i]).getAddress().equals(userEmail)) {
								ccListme = true;
								break;
							}
						}
						
						String ccHeader = message.getHeader("Cc")[0];
						boolean isAscii = ezEmailUtil.isPureAscii(ccHeader);												
						String name = null;
						
						for (int i=0; i<arrRecipientsCC.length; i++) {
							name = ((InternetAddress)arrRecipientsCC[i]).getPersonal();
							
							if (name == null) {
								name = ((InternetAddress)arrRecipientsCC[i]).getAddress();
							} else {
								if (!isAscii) {
									byte[] rawBytes = name.getBytes("iso-8859-1");
									
									name = ezEmailUtil.decodeNonAsciiBytes(rawBytes);								
								} else {								
									name = MimeUtility.decodeText(name);
								}
								
								name = commonUtil.trimDoubleQuotes(name);
							}
							
							logger.debug("CC=" + name + ((InternetAddress)arrRecipientsCC[i]).getAddress());
							
							if (ccListme) {
								if (((InternetAddress)arrRecipientsCC[i]).getAddress().equals(userEmail)) {
									if (arrRecipientsCC.length > 1) {
										ccStr = getReceiverHTML(name, ((InternetAddress)arrRecipientsCC[i]).getAddress()) + "<span>&nbsp;(" + egovMessageSource.getMessage("ezEmail.t10000", locale) + arrRecipientsCC.length + egovMessageSource.getMessage("ezEmail.t10001", locale) + ")&nbsp;<img src='/images/expnd.gif'  style='cursor:pointer;' onclick='ShowHiddenCc(this);' align='absmiddle'></span>";
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
										ccStr = getReceiverHTML(name, ((InternetAddress)arrRecipientsCC[i]).getAddress()) + "<span>&nbsp;(" + egovMessageSource.getMessage("ezEmail.t10000", locale) + arrRecipientsCC.length + egovMessageSource.getMessage("ezEmail.t10001", locale) + ")&nbsp;<img src='/images/expnd.gif'  style='cursor:pointer;' onclick='ShowHiddenCc(this);' align='absmiddle'></span>";
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
							
							if (i == arrRecipientsCC.length - 1) {
								ccMobileStr +=  getMobileReceiverHTML(name, ((InternetAddress)arrRecipientsCC[i]).getAddress());
							} else {
								ccMobileStr +=  getMobileReceiverHTML(name, ((InternetAddress)arrRecipientsCC[i]).getAddress()) + "&nbsp;,&nbsp;";
							}
							
							// HTML 태그가 없는 CC 정보
							if (ccList.equals("")) {
								ccList = name + " <" + ((InternetAddress)arrRecipientsCC[i]).getAddress() + ">";
							} else {
								ccList += "," + name + " <" + ((InternetAddress)arrRecipientsCC[i]).getAddress() + ">";
							}																						
						}
					}
	
					// BCC
					arrRecipientsBCC = message.getRecipients(Message.RecipientType.BCC);
					if (arrRecipientsBCC != null) {
						String name = null;
						
						for (int i = 0; i < arrRecipientsBCC.length; i++) {
							name = ((InternetAddress)arrRecipientsBCC[i]).getPersonal();
							
							if (name == null) {
								name = ((InternetAddress)arrRecipientsBCC[i]).getAddress();
							} else {
								name = MimeUtility.decodeText(name);
								name = commonUtil.trimDoubleQuotes(name);
							}
							
							logger.debug("BCC=" + name + ((InternetAddress)arrRecipientsBCC[i]).getAddress());
							
							if (i != 0) {
								bccStr += ", ";
							}
							
							bccStr += getReceiverHTML(name, ((InternetAddress)arrRecipientsBCC[i]).getAddress());
							
							if (i == arrRecipientsBCC.length - 1) {
								bccMobileStr +=  getMobileReceiverHTML(name, ((InternetAddress)arrRecipientsBCC[i]).getAddress());
							} else {
								bccMobileStr +=  getMobileReceiverHTML(name, ((InternetAddress)arrRecipientsBCC[i]).getAddress()) + "&nbsp;,&nbsp;";
							}
							
							// HTML 태그가 없는 BCC 정보
							if (bccList.equals("")) {
								bccList = name + " <" + ((InternetAddress)arrRecipientsBCC[i]).getAddress() + ">";
							} else {
								bccList += "," + name + " <" + ((InternetAddress)arrRecipientsBCC[i]).getAddress() + ">";
							}																													
						}
					}
					
					if (ccStr == null || ccStr.equals("")) {
						pIsCCFg = "N";
					}
					
					// received date
					date = message.getReceivedDate();
					
					if (date != null) {
						SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
						sdf.setTimeZone(TimeZone.getTimeZone("GMT"));
						String receivedDateStr = sdf.format(date);
						
						dateStr = commonUtil.getDateStringInUTC(receivedDateStr, info.getOffSet(), false);
					}
					
					logger.debug("dateStr=" + dateStr);
					
					// subject
					subject = ezEmailUtil.getSubject(message);
					
					logger.debug("subject=" + subject);
					
					if (subject != null) {
						title = egovMessageSource.getMessage("ezEmail.t565", locale) + subject;
					}
					
					if (message.getFolder().getFullName().equals(ezEmailUtil.getSentFolderId(locale))) {
						isSentItems = true;
					}
					
					if (message.getFolder().getFullName().equals(ezEmailUtil.getTrashFolderId(locale))) {
						isDelete = "BDELETE";
					}
					
					if (!message.isSet(Flag.SEEN)) {
						pReadFlag = "N";
						message.setFlag(Flag.SEEN, true);
						logger.debug("Message's seen flag changed to true.");
					}
					
					if (message.isSet(Flags.Flag.FLAGGED)) {
						flagged = "1";
					}
					
					mail.put("flag", flagged);
					mail.put("folderName", f.getName());
					
					Map<String, Object> extraMap = new HashMap<String, Object>();
					extraMap.put("mobile", true);
					extraMap.put("shareId", info.getUserId());

					// ical 응답 조회
					String icalStatus = ezEmailUtil.getIcalStatusFlag(message);
					extraMap.put("icalStatus", icalStatus);
					
					bodyInfoList = ezEmailUtil.getBodyInfo(message, folderId, uid, -1, attachedFileList, locale, extraMap);

					double size = Double.parseDouble(bodyInfoList.get(2));
					String strSize = ezEmailUtil.getSizeWithUnit(size);
					pAttachListHtmlSub = bodyInfoList.get(3) + egovMessageSource.getMessage("ezEmail.t180", locale) + " (" + strSize + ")";
					
					if (!folderId.equals(ezEmailUtil.getSentFolderId(locale))) {
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
							OrganUserVO userVO = ezOrganAdminService.getUserInfo(info.getUserId(), info.getLang(), info.getTenantId());
							
							SMTPAccess sa = SMTPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.SMTPPort"),
									userEmail, password, info.getEmail());
							
							ezEmailMailReadController.processAutoMDN(sa, message, userEmail, userVO.getDisplayName(), info.getTenantId());
						} else {
							logger.debug("MDNSentFlag is set");
						}
					}
				}
				
				f.close(true);
				
				useMailTag = ezEmailUtil.checkUseMailTag(info.getTenantId(),userEmail);
				
				try {
					tags = ezEmailUtil.getTagList(userEmail, folderId, uid);
				} catch (Exception e) {
					logger.error("get tag error:", e);
				}
			}
			
			logger.debug(toMobileStr);
			logger.debug(toStr);
			logger.debug(ccMobileStr);
			logger.debug(ccStr);
			
			mail.put("fromStr", fromStr);
			mail.put("fromEmail", fromEmail);
			mail.put("toStr", toStr);
			mail.put("toHiddenStr", toHiddenStr);
			mail.put("toMobileStr", toMobileStr);
			mail.put("toList", toList);
			mail.put("ccStr", ccStr);
			mail.put("ccHiddenStr", ccHiddenStr);
			mail.put("ccMobileStr", ccMobileStr);
			mail.put("ccList", ccList);
			mail.put("bccStr", bccStr);
			mail.put("bccMobileStr", bccMobileStr);
			mail.put("bccList", bccList);
			mail.put("dateStr", dateStr);
			mail.put("subject", subject);
			mail.put("title", title);
			mail.put("folderId", folderId);
			mail.put("uid", uid);
			mail.put("pReadFlag", pReadFlag);
			mail.put("isDelete", isDelete);
			mail.put("isSentItems", isSentItems);
			mail.put("pnFlag", pnFlag);
			mail.put("pIsCCFg", pIsCCFg);
			mail.put("useMobileViewer", useMobileViewer);
			mail.put("useMailTag",useMailTag);
			mail.put("tags", tags);
			
			if (bodyInfoList != null) { 
				String htmlBody = bodyInfoList.get(0);
				String dotNetIntegration = ezCommonService.getTenantConfig("dotNetIntegration", info.getTenantId());
				
				if (dotNetIntegration.equals("YES")) {
					String mobileDownloadInline = config.getProperty("config.MobileDownloadInline");
										
					htmlBody = htmlBody.replace("/ezEmail/downloadInline.do", mobileDownloadInline);
				}
				
				mail.put("htmlBody", htmlBody);
				mail.put("pAttachListHtmlSub", pAttachListHtmlSub);
				mail.put("pAttachListHtml", bodyInfoList.get(1));
				mail.put("isAttach", bodyInfoList.get(4));
			}
			
			mail.put("attachedFileList", attachedFileList);
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", mail);			
		} catch (MessagingException e) {
			logger.error(e.getMessage(), e);
			
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");			
		} finally {
			if (ia != null) {
				ia.close();
			}
		}
				
//		logger.debug("mMailRead result=" + result);
	
		logger.debug("MOBILE G/W MAIL mMailRead ended.");		
		
		return result;		
	}
	
	/**
	 * 모바일 G/W 이메일 [GET] 파일 다운로드
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezemail/folders/{folderId}/mails/{messageId}/attach/{index}/users/{userId:.+}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public Object mMailFileDown(HttpServletRequest request,
			@PathVariable String folderId, @PathVariable String messageId, @PathVariable String index, @PathVariable String userId) throws Exception {
		logger.debug("MOBILE G/W MAIL mMailFileDown started.");
		folderId = URLDecoder.decode(folderId);
		logger.debug("folderId=" + folderId + ",messageId=" + messageId + ",userId=" + userId + ",index=" + index);
		
		String filename = "";
		String strOrder = "";
		String strDepth = "";
		
		InputStream input = null;
		IMAPAccess ia = null;
		JSONObject result = new JSONObject();
				
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			String domainName = ezCommonService.getTenantConfig("DomainName", info.getTenantId());
			String userEmail = info.getUserId() + "@" + domainName;
			String password = jspw;
			String useMobileViewer = ezCommonService.getTenantConfig("useMobileViewer", info.getTenantId());
			String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", info.getTenantId());
			String shareId = request.getParameter("shareId");

			if (useSharedMailbox.equals("YES") && !Globals.APPR_MAIL_SHARED_ID.equalsIgnoreCase(shareId)) {
				logger.debug("shareId=" + shareId + ", userId=" + userId + ", info.getUserId=" + info.getUserId());

				if (shareId != null && !shareId.equals("")) {
					if (!ezEmailService.checkUserShareId(userId, shareId, 0, info.getTenantId())) {
						logger.debug("the user cannot access the shareId.");

						result.put("status", "error");
						result.put("code", 1);
						result.put("data", "");
					}

					userEmail = shareId + "@" + domainName;
				}
			}

			// 승인메일
			if (StringUtils.isNotBlank(shareId) && Globals.APPR_MAIL_SHARED_ID.equalsIgnoreCase(shareId)) {
				userEmail = shareId + "@" + domainName;
			}
			
			logger.debug("userEmail=" + userEmail);
			
			String ld = commonUtil.getTwoLetterLangFromLangNum(info.getLang());
			Locale locale = new Locale(ld);
			
			// retrieve the passed in parameters
			String folderPath = folderId;
			String strUid = messageId;
			long uid = strUid != null ? Long.parseLong(strUid) : 0;
			filename = request.getParameter("filename");
			strOrder = request.getParameter("order");
			strDepth = request.getParameter("depth");
			
			logger.debug("folderPath=" + folderPath + ",uid=" + uid + ",filename=" + filename
							+ ",strOrder=" + strOrder + ",strDepth=" + strDepth);
			
			if (folderPath == null || strUid == null || filename == null) {
				logger.debug("downloadAttach illegal arguments.");
				
				result.put("status", "error");
				result.put("code", 1);			
				result.put("data", "");
				
				return result;
			}
			
			String strIndex = index;
			int intIndex = -1;
			
			if (strIndex != null) {
				intIndex = Integer.parseInt(strIndex);
			}
			
			logger.debug("index=" + intIndex);

			int order = 0;
			
			if (strOrder != null) {
				order = Integer.parseInt(strOrder);
			}
			
			logger.debug("order=" + order);

			int depth = 0;
			
			if (strDepth != null) {
				depth = Integer.parseInt(strDepth);
			}
			
			logger.debug("depth=" + depth);
			
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userEmail, password, egovMessageSource, locale, ezEmailUtil);
			
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
					
					result.put("status", "error");
					result.put("code", 1);			
					result.put("data", "");
				} else {
					Part part = null;
					
					if (intIndex == -1) {
						part = message;
					} else {
						part = ezEmailUtil.getAttachPart(message, intIndex, order, depth);
					}
					
					if (part == null) {
						logger.error("AttachPart not found. AttachPartIndex=" + index);
					} else {
//						logger.debug("content-disposition=" + "attachment; filename=\"" + filename + "\"");
						
						try {
							input = part.getInputStream();
					
							byte[] bytes = IOUtils.toByteArray(input);
							
							JSONObject data = new JSONObject();
																				
							data.put("bytes", bytes);
							data.put("filename",filename);
							data.put("filetype",part.getContentType());
							data.put("useMobileViewer", useMobileViewer);
							
							result.put("status", "ok");
							result.put("code", 0);			
							result.put("data", data);							
						} catch(Exception e) {
							logger.error(e.getMessage(), e);
							
							result.put("status", "error");
							result.put("code", 1);			
							result.put("data", "");
						} finally {
							if (ia != null) {
								ia.close();
							}
							
							if (input != null) {
								try { input.close(); } catch (IOException e) {logger.debug("e.message=" + e.getMessage());}
							}
						}						
					}
				}
			}
		} catch (MessagingException e) {
			logger.error(e.getMessage(), e);
			
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
		} finally {
			if (ia != null) {
				ia.close();
			}
		}
		
		logger.debug("MOBILE G/W MAIL mMailFileDown ended.");
		
		return result;
	}
	
	/**
	 * 메일 인라인 이미지 읽어오기 실행 함수
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezemail/folders/{folderId}/mails/{messageId}/inlineattach/{index}/users/{userId:.+}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public Object downloadInline(HttpServletRequest request,
			@PathVariable String folderId, @PathVariable String messageId, @PathVariable String index, @PathVariable String userId) throws Exception {
		logger.debug("MOBILE G/W MAIL downloadInline started.");
		folderId = URLDecoder.decode(folderId, "UTF-8");
		logger.debug("folderId=" + folderId + ",messageId=" + messageId + ",userId=" + userId + ",index=" + index);
		
		InputStream input = null;
		IMAPAccess ia = null;
		JSONObject result = new JSONObject();
		
		// get user credentials
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			String domainName = ezCommonService.getTenantConfig("DomainName", info.getTenantId());
			String userEmail = info.getUserId() + "@" + domainName;
			String password = jspw;
			
			logger.debug("userEmail=" + userEmail);
		
			String ld = commonUtil.getTwoLetterLangFromLangNum(info.getLang());
			Locale locale = new Locale(ld);
			
			// retrieve the passed in parameters
			String folderPath = folderId;
			String strUid = messageId;
			long uid = strUid != null ? Long.parseLong(strUid) : 0;
			String contentId = index;
			
			if (contentId != null) {
				contentId = EgovStringUtil.getHtmlStrCnvr(contentId);
			}	
		
			logger.debug("folderPath=" + folderPath + ",uid=" + uid + ",contentId=" + contentId);
				
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userEmail, password, egovMessageSource, locale, ezEmailUtil);

			if (ia != null){
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
						Part part = ezEmailUtil.getInlinePart(message, contentId);

						if (part == null) {
							logger.error("InlinePart not found. contentId=" + contentId);
						} else {
							input = part.getInputStream();
							byte[] bytes = IOUtils.toByteArray(input);

							JSONObject data = new JSONObject();

							data.put("bytes", bytes);
							data.put("filetype",part.getContentType());

							result.put("status", "ok");
							result.put("code", 0);
							result.put("data", data);
						}
					}
				}
			}

		} catch (MessagingException e) {
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");
			
			return result;
		} finally {
			if (ia != null) {
				ia.close();
			}
		}
		
		logger.debug("MOBILE G/W MAIL downloadInline ended.");
		
		return result;
	}
	
	/**
	 * 모바일 G/W 이메일 [PUT] 메일 이동 
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezemail/folders/{folderId:.+}/mails/{messageId:.+}/users/{userId:.+}/copy_move", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
	public Object mMailMove(HttpServletRequest request, @PathVariable String folderId, @PathVariable String messageId, @PathVariable String userId,
			@RequestBody JSONObject jsonobject) throws Exception {
		logger.debug("MOBILE G/W MAIL mMailMove started.");
		
		JSONObject result = new JSONObject();
		
		IMAPAccess ia = null;
		
		try {
			
			String uniqueId =  messageId;
			String mfolderId = folderId;
			String cmd = (String) jsonobject.get("cmd");
			
			logger.debug("uniqueId, mfolderId, cmd = " + uniqueId + "," + mfolderId + "," + cmd);
			
//			if (uniqueId.endsWith(",")) {
//				uniqueId = uniqueId.substring(0, uniqueId.length() - 1);
//			}
			
			String[] MsgIdArray = uniqueId.split(",");		
			long[] uids = new long[MsgIdArray.length];
			
			for (int i = 0; i < MsgIdArray.length; i++) {
				uids[i] = Long.parseLong(MsgIdArray[i]);
			}
				
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			String domainName = ezCommonService.getTenantConfig("DomainName", info.getTenantId());
			String userEmail = info.getUserId() + "@" + domainName;
			String password = jspw;

			String ld = commonUtil.getTwoLetterLangFromLangNum(info.getLang());
			Locale locale = new Locale(ld);
			
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userEmail, password, egovMessageSource, locale, ezEmailUtil);
					
			if (ia != null){
				IMAPFolder sourceFolder = (IMAPFolder)ia.getFolder(folderId);
				sourceFolder.open(Folder.READ_WRITE);

				Message[] messages = sourceFolder.getMessagesByUID(uids);

				IMAPFolder movefolder = (IMAPFolder)ia.getFolder(mfolderId);

				String useImapMoveCommand = ezCommonService.getTenantConfig("useImapMoveCommand", info.getTenantId());

				// 20210315 조진호 - 메일 이동 및 복사 기능 구분 추가
				if (cmd.equalsIgnoreCase("move")) {
					if (useImapMoveCommand.equals("YES")) {
						sourceFolder.moveUIDMessages(messages, movefolder);
					} else {
						sourceFolder.copyUIDMessages(messages, movefolder);

						sourceFolder.setFlags(messages, new Flags(Flags.Flag.DELETED), true);
					}
				} else if (cmd.equalsIgnoreCase("copy")) {
					sourceFolder.copyUIDMessages(messages, movefolder);
				}

				sourceFolder.close(true);
			}
		
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", "success");			
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "fail");			
		} finally {
			if (ia != null) {
				ia.close();
			}
		}
				
		logger.debug("MOBILE G/W MAIL mMailMove ended.");		
		
		return result;
	}
	
	/**
	 * 모바일 G/W 이메일 [PUT] 읽은 상태 변경
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezemail/users/{userId:.+}", method= RequestMethod.PUT, produces="application/json;charset=utf-8")
	public Object mMailStatusChange(HttpServletRequest request, @PathVariable String userId,
			@RequestBody JSONObject jsonobject) throws Exception {
		logger.debug("MOBILE G/W MAIL mMailStatusChange started. userId={}", userId);
		
		JSONObject result = new JSONObject();
		
		IMAPAccess ia = null;
		
		try {
			String messageId = (String) jsonobject.get("mails");
			String[] folderAndMsgIdArray = messageId.split(",");
			Map<String, long[]> folderIdUids = ezEmailUtil.getFolderIdUid(folderAndMsgIdArray);
			
			/* 전체메일 - 다중편지함 지원으로 ezEmailUtil.getFolderIdUid 사용, 아래 주석
			String uniqueId =  messageId;
						
			String[] MsgIdArray = uniqueId.split(",");		
			long[] uids = new long[MsgIdArray.length];
			
			for (int i = 0; i < MsgIdArray.length; i++) {
				uids[i] = Long.parseLong(MsgIdArray[i]);
			}*/
		
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			String domainName = ezCommonService.getTenantConfig("DomainName", info.getTenantId());
			String userEmail = info.getUserId() + "@" + domainName;			
			String password = jspw;

			String ld = commonUtil.getTwoLetterLangFromLangNum(info.getLang());
			Locale locale = new Locale(ld);
			
			logger.debug("userEmail=" + userEmail);
		        
			String isRead = (String) jsonobject.get("isRead");
			//TRUE면 읽은 상태로  FALSE면 읽지 않은 상태로 변경.			
	
			//logger.debug("folderId=" + folderId);		
								
			try {
				ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
						userEmail, password, egovMessageSource, locale, ezEmailUtil);

				if (ia != null){
					for (String folderId : folderIdUids.keySet()) {
						long[] uids = folderIdUids.get(folderId);
						IMAPFolder sourceFolder = (IMAPFolder) ia.getFolder(folderId);
						sourceFolder.open(Folder.READ_WRITE);

						Message[] msgs = sourceFolder.getMessagesByUID(uids);

						if (isRead.equals("TRUE")) {
							sourceFolder.setFlags(msgs, new Flags(Flags.Flag.SEEN), true);
						} else {
							sourceFolder.setFlags(msgs, new Flags(Flags.Flag.SEEN), false);
						}

						sourceFolder.close(true);
					}
				}
				
				result.put("status", "ok");
				result.put("code", 0);			
				result.put("data", "success");				
			} catch (Exception e) {
				logger.error(e.getMessage(), e);
				
				result.put("status", "error");
				result.put("code", 1);			
				result.put("data", "fail");				
			} finally {
				if (ia != null) {
					ia.close();
				}
			}	
			
			logger.debug("MOBILE G/W MAIL mMailStatusChange ended.");		
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		
		return result;
	}
	
	/**
	 * 모바일 G/W 이메일 [DELETE] 메일 삭제
	 * @return 
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezemail/users/{userId:.+}/delete", method= RequestMethod.DELETE, produces="application/json;charset=utf-8")
	public Object mMailDelete(HttpServletRequest request, @PathVariable String userId, @RequestBody JSONObject jsonObject) throws Exception {
		logger.debug("MOBILE G/W MAIL mMailDelete started. userId={}", userId);
			
		JSONObject result = new JSONObject();
		
		IMAPAccess ia = null;
		
		// get user credentials
		try {			
			//folderId = URLDecoder.decode(folderId, "UTF-8");
			
			boolean permanentlyDelete = false;

			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			String domainName = ezCommonService.getTenantConfig("DomainName", info.getTenantId());
			String userEmail = info.getUserId() + "@" + domainName;
			String password = jspw;
			String mailId = "";
		
			String ld = commonUtil.getTwoLetterLangFromLangNum(info.getLang());
			Locale locale = new Locale(ld);
			
			/*if (folderId.equals(ezEmailUtil.getTrashFolderId(locale))) {
				permanentlyDelete = true;
			}*/

			if (jsonObject.get("mails") != null) {
				mailId = (String) jsonObject.get("mails");
			}
			
			String[] folderAndMsgIdArray = mailId.split(",");
			Map<String, long[]> folderIdUids = ezEmailUtil.getFolderIdUid(folderAndMsgIdArray);
			
			/*String[] MsgIdArray = messageId.split(",");		
			long[] uids = new long[MsgIdArray.length];
			
			for (int i = 0; i < MsgIdArray.length; i++) {
				uids[i] = Long.parseLong(MsgIdArray[i]);
			}
		
			logger.debug("folderId=" + folderId);*/

			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userEmail, password, egovMessageSource, locale, ezEmailUtil);
						
			if (ia != null) {
				for (String folderId : folderIdUids.keySet()) {
					long[] uids = folderIdUids.get(folderId);
					IMAPFolder sourceFolder = (IMAPFolder) ia.getFolder(folderId);
					sourceFolder.open(Folder.READ_WRITE);

					if (folderId.equals(ezEmailUtil.getTrashFolderId(locale))) {
						permanentlyDelete = true;
					}

					Message[] deleteMsgs = null;

					deleteMsgs = sourceFolder.getMessagesByUID(uids);

					String useImapMoveCommand = ezCommonService.getTenantConfig("useImapMoveCommand", info.getTenantId());
					IMAPFolder deletedFolder = (IMAPFolder) ia.getFolder(ezEmailUtil.getTrashFolderId(locale));

					if (useImapMoveCommand.equals("YES")) {
						if (!permanentlyDelete) {
							sourceFolder.moveUIDMessages(deleteMsgs, deletedFolder);
						} else {
							sourceFolder.setFlags(deleteMsgs, new Flags(Flags.Flag.DELETED), true);
						}
					} else {
						if (!permanentlyDelete) {
							sourceFolder.copyUIDMessages(deleteMsgs, deletedFolder);
						}

						sourceFolder.setFlags(deleteMsgs, new Flags(Flags.Flag.DELETED), true);
					}

					sourceFolder.close(true);
				}
			}
							
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", "success");			
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "fail");			
		} finally {
			if (ia != null) {
				ia.close();		
			}
		}
		
		logger.debug("mMailDelete result=" + result);
		logger.debug("MOBILE G/W MAIL mMailDelete ended.");		
		
		return result;
	}

	/**
	 * 모바일 G/W 이메일 [POST] 해킹메일 의심 신고 
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezemail/reportHackingMail/users/{userId:.+}", method= RequestMethod.POST, produces="application/json;charset=utf-8")
	public Object reportHackingMail(HttpServletRequest request, @RequestBody Map<String, String> requestBody, @PathVariable String userId) throws Exception {
		logger.debug("MOBILE G/W MAIL reportHackingMail started. userId={}", userId);
		
		//logger.debug("folderId=" + folderId + ",messageId=" + messageId + ",userId=" + userId);
		JSONObject result = new JSONObject();
		IMAPAccess ia = null;

		try {
			//folderId = URLDecoder.decode(folderId, "UTF-8");
			
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			String domainName = ezCommonService.getTenantConfig("DomainName", info.getTenantId());
			String userEmail = info.getUserId() + "@" + domainName;
			String password = jspw;
			
			String ld = commonUtil.getTwoLetterLangFromLangNum(info.getLang());
			Locale locale = new Locale(ld);
			
			String reportMessage = (String) Optional.ofNullable(requestBody.get("reportMessage")).orElse((""));
			String mailId = (String) Optional.ofNullable(requestBody.get("mailId")).orElse((""));

			String[] folderAndMsgIdArray = mailId.split(",");
			Map<String, long[]> folderIdUids = ezEmailUtil.getFolderIdUid(folderAndMsgIdArray);

			/* 전체메일 - 다중편지함 지원으로 ezEmailUtil.getFolderIdUid 사용, 아래 주석
			String[] MsgIdArray = messageId.split(",");
			long[] uids = new long[MsgIdArray.length];

			for (int i = 0; i < MsgIdArray.length; i++) {
				uids[i] = Long.parseLong(MsgIdArray[i]);
			}*/
			
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userEmail, password, egovMessageSource, locale, ezEmailUtil);

			if (ia != null) {
				for (String folderId : folderIdUids.keySet()) {
					long[] uids = folderIdUids.get(folderId);
					IMAPFolder sourceFolder = (IMAPFolder) ia.getFolder(folderId);
					sourceFolder.open(Folder.READ_WRITE);

					//관리자 계정으로 발송 로직 시작
					//From 
					InternetAddress from = new InternetAddress();
					from.setPersonal(info.getUserName(), "UTF-8");
					from.setAddress(info.getEmail());

					String adminID = ezCommonService.getTenantConfig("HackingAdminID", info.getTenantId());

					String adminIDAddress = null;
					String adminIDDomain = null;
					OrganUserVO adminVO = null;

					//To
					InternetAddress to = new InternetAddress();

					if (adminID.contains("@")) {
						to.setPersonal(adminID, "UTF-8");
						to.setAddress(adminID);
					} else {
						adminVO = ezOrganService.getUserInfo(adminID, info.getLang(), info.getTenantId());
						if (adminVO != null) {
							to.setPersonal(adminVO.getDisplayName(), "UTF-8");
							to.setAddress(adminVO.getMail());
						}
					}

					for (int i = 0; i < uids.length; i++) {
						Message message = sourceFolder.getMessageByUID(uids[i]);

						String subject = "[" + egovMessageSource.getMessage("ezEmail.zno000", locale) + "]" + message.getSubject();

						//해킹 의심메일 송신자
						Address[] arrFroms = message.getFrom();
						String fromStr = ((InternetAddress) arrFroms[0]).getAddress();

						//해킹 의심메일 수신일
						Date receivedDate = message.getReceivedDate();
						SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
						sdf.setTimeZone(TimeZone.getTimeZone("GMT"));
						String receivedDateStr = sdf.format(receivedDate);
						receivedDateStr = commonUtil.getDateStringInUTC(receivedDateStr, info.getOffSet(), false);

						String content = " <table cellpadding='0' cellspacing='0' style='width:100%;margin:0;padding:0;border-bottom: 1px solid #f3f3f3; padding-bottom: 10px;'>"
								+ "		<tbody>";
						content += "<tr><td width='70' style='padding-bottom:9px;font-size:14px;color:#696969; vertical-align: top;'>"
								+ egovMessageSource.getMessage("ezEmail.t707", locale)
								+ "</td>"
								+ "<td style='padding-bottom:9px;font-size:14px; color:#000;'>"
								+ message.getSubject()
								+ "</td></tr>";
						content += " <tr><td width='70' style='padding-bottom:9px;font-size:14px; color:#696969; vertical-align: top;'>"
								+ egovMessageSource.getMessage("ezEmail.t656", locale)
								+ "</td>"
								+ "<td style='padding-bottom:9px;font-size:14px;color:#000;'>"
								+ fromStr
								+ "</td></tr>";
						content += "<tr><td width='70' style='padding-bottom:9px;font-size:14px; color:#696969; vertical-align: top;'>"
								+ egovMessageSource.getMessage("ezEmail.t657", locale)
								+ "</td>"
								+ "<td style='padding-bottom:9px;font-size:14px;color:#000;vertical-align:top'>"
								+ receivedDateStr
								+ "</td></tr>";
						content += "</tbody></table>";
						content += "<div class='mail_txtArea' style='margin-top: 15px; font-size: 14px;'>"
								+ reportMessage
								+ "</div>";

						// 해킹의심메일 .eml 첨부
						String mailSubject = ezEmailUtil.getSubject(message);

						if (mailSubject.trim().equals("")) {
							mailSubject = egovMessageSource.getMessage("ezEmail.kms03", locale);
						}

						String senderAddress = ezEmailUtil.getFromEmailAddressOfMessage(message);

						if (senderAddress.trim().equals("")) {
							senderAddress = egovMessageSource.getMessage("ezQuestion.t56", locale);
						}

						String senderName = ezEmailUtil.getFromNameOrAddressOfMessage(message);

						if (senderName.trim().equals("")) {
							senderName = egovMessageSource.getMessage("ezQuestion.t56", locale);
						}

						Date sentDate = message.getSentDate();
						String dateStrExceptTime = "";

						if (sentDate == null) {
							dateStrExceptTime = egovMessageSource.getMessage("ezQuestion.t56", locale);
						} else {
							sdf.setTimeZone(TimeZone.getTimeZone("GMT"));
							String sentDateStr = sdf.format(sentDate);
							sentDateStr = commonUtil.getDateStringInUTC(sentDateStr, info.getOffSet(), false);
							dateStrExceptTime = sentDateStr.substring(0, 10);
						}
						senderName = senderName.replaceAll("[\\\\/:*?\"<>|]", "_").replaceAll("[\\t\\r\\n\\v\\f\\u00a0]", "");
						mailSubject = subject.replaceAll("[\\\\/:*?\"<>|]", "_").replaceAll("[\\t\\r\\n\\v\\f\\u00a0]", "");
						String fileName = dateStrExceptTime + "_" + senderName + "_[" + senderAddress + "]_" + mailSubject + ".eml";

						ByteArrayInputStream inputStream = null;
						ByteArrayOutputStream outputStream = new ByteArrayOutputStream();

						String pReadFlag = "Y";

						// 선택 된 해킹 의심 메일이 안읽은 메일이면
						if (!message.isSet(Flags.Flag.SEEN)) {
							pReadFlag = "N";
						}

						try {
							message.writeTo(outputStream);

							boolean isRead = pReadFlag.equalsIgnoreCase("Y");
							message.setFlag(Flags.Flag.SEEN, isRead);

							inputStream = new ByteArrayInputStream(outputStream.toByteArray());
						} catch (IOException e) {
							logger.error(e.getMessage(), e);
						} finally {
							if (inputStream != null) {
								inputStream.close();
							}
							if (outputStream != null) {
								outputStream.close();
							}
						}

						ezEmailService.sendMail(userEmail, password, info.getLocale(), from, new InternetAddress[]{to}, null, null, subject, content, false, EmailImportance.NORMAL, fileName, "message/rfc822", inputStream);

					}
					// 해킹의심메일 관리자 계정으로 발송 로직 끝

					// 해당 메일을 사용자의 정크메일 함으로 이동
					Message[] messages = sourceFolder.getMessagesByUID(uids);
					IMAPFolder moveFolder = (IMAPFolder) ia.getFolder(ezEmailUtil.getJunkFolderId(info.getLocale()));

					String useImapMoveCommand = ezCommonService.getTenantConfig("useImapMoveCommand", info.getTenantId());

					if (useImapMoveCommand.equals("YES")) {
						sourceFolder.moveUIDMessages(messages, moveFolder);
					}
					sourceFolder.close(true);
				}
			}
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "success");
		} catch (Exception e) {
			logger.error(e.getMessage(), e);

			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "fail");
		} finally {
			if (ia != null) {
				ia.close();
			}
		}
		logger.debug("MOBILE G/W MAIL reportHackingMail ended.");

		return result;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezemail/folders/{folderId}/tempmail/{messageId}/users/{userId:.+}", method= RequestMethod.DELETE, produces="application/json;charset=utf-8")
	public Object mTempMailDelete(HttpServletRequest request, @PathVariable String folderId, @PathVariable String messageId, @PathVariable String userId) throws Exception {
		logger.debug("MOBILE G/W MAIL mTempMailDelete started.");
		logger.debug("folderId=" + folderId + ",messageId=" + messageId + ",userId=" + userId);
			
		JSONObject result = new JSONObject();
		
		IMAPAccess ia = null;

		try {
			
			folderId = URLDecoder.decode(folderId, "UTF-8");
			
			@SuppressWarnings("unused")
			boolean permanentlyDelete = true;

			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			String domainName = ezCommonService.getTenantConfig("DomainName", info.getTenantId());
			String userEmail = info.getUserId() + "@" + domainName;
			String password = jspw;
		
			String ld = commonUtil.getTwoLetterLangFromLangNum(info.getLang());
			Locale locale = new Locale(ld);
			
			if (folderId.equals(ezEmailUtil.getTrashFolderId(locale))) {
				permanentlyDelete = true;
			}
			
			String[] MsgIdArray = messageId.split(",");		
			long[] uids = new long[MsgIdArray.length];
			
			for (int i = 0; i < MsgIdArray.length; i++) {
				uids[i] = Long.parseLong(MsgIdArray[i]);
			}
		
			logger.debug("folderId=" + folderId);

			// 지정된 folderId가 사용자 언어에 따른 '임시 보관함'과 동일한 경우 표준 폴더 아이디를 사용해야 하는지
			// 여부를 확인한다. ezMobile에서 임시 보관함의 메일을 삭제할 때 언어에 따른 이름을 보내도록 되어 있어서
			// 아래 코드를 추가함.
			if (folderId.equals(egovMessageSource.getMessage("ezEmail.t646", locale))) {
				folderId = ezEmailUtil.getDraftsFolderId(locale);
			}
			
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userEmail, password, egovMessageSource, locale, ezEmailUtil);
						
			if (ia != null){
				IMAPFolder sourceFolder = (IMAPFolder)ia.getFolder(folderId);
				sourceFolder.open(Folder.READ_WRITE);

				Message deleteMsgs = null;

				deleteMsgs = ((IMAPFolder)sourceFolder).getMessageByUID(Long.parseLong(messageId));

				if (deleteMsgs != null) {
					deleteMsgs.setFlag(Flags.Flag.DELETED, true);
				}

				sourceFolder.close(true);
			}
					
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", "success");			
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "fail");			
		} finally {
			if (ia != null) {
				ia.close();		
			}
		}
		
		logger.debug("MOBILE G/W MAIL mTempMailDelete ended.");		
		
		return result;
	}
	 
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezemail/write/checkname/users/{userId:.+}", method= RequestMethod.POST,  produces="application/json;charset=utf-8")
	public Object mailNameCheck(HttpServletRequest request, @PathVariable String userId, @RequestBody JSONObject jsonObject) {		
		logger.debug("MOBILE G/W MAIL mailNameCheck started.");
		logger.debug("userId=" + userId + ",jsonObject=" + jsonObject);
		
		String organXML = "";
        String dlXML = "";
        String addressXML = "";
        String sharedMailboxXML = "";
		
        JSONObject data = new JSONObject();
        JSONObject result = new JSONObject();
        
        try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
											
			String pOrganSearchList = "";
			String pOrganCellList = "displayname";
			String pOrganPropList = "company;description;title;mail;extensionAttribute3";
			String pOrganListType = "all";
			String pDLSearchList = "";
			String pAddressFilter = "";
			String pSharedMailboxSearchList = "";
	
			if (jsonObject.get("pOrganSearchList") != null) {
				pOrganSearchList = (String) jsonObject.get("pOrganSearchList");
			}
			
			if (jsonObject.get("pOrganCellList") != null) {
				pOrganCellList = (String) jsonObject.get("pOrganCellList");
			}
			
			if (jsonObject.get("pOrganPropList") != null) {
				pOrganPropList = (String) jsonObject.get("pOrganPropList");
			}
			
			if (jsonObject.get("pOrganListType") != null) {
				pOrganListType = (String) jsonObject.get("pOrganListType");
			}
			
			if (jsonObject.get("pDLSearchList") != null) {
				pDLSearchList = (String) jsonObject.get("pDLSearchList");
			}
						
			if (jsonObject.get("pAddressFilter") != null) {
				pAddressFilter = (String) jsonObject.get("pAddressFilter");
			}
			
			if (jsonObject.get("pSharedMailboxSearchList") != null) {
				pSharedMailboxSearchList = (String) jsonObject.get("pSharedMailboxSearchList");
			}
						
			String useShowAllCompanies = ezCommonService.getTenantConfig("useShowAllCompanies", info.getTenantId());
			
	        // useShowAllCompanies가 YES이면 Company ID를 ""로 세트하여 그룹사 전체 조직도를 대상으로 검색하도록 한다.
	        String orgCompanyId = info.getCompanyId();
	        
	        if (useShowAllCompanies.equals("YES")) {
	        	info.setCompanyId("");
	        }
			
			if (!pOrganSearchList.isEmpty()) {								
				organXML = getOrganSearch(pOrganSearchList, pOrganCellList, pOrganPropList, pOrganListType, info);				
			}
			
			if (!pDLSearchList.isEmpty()) {
				dlXML = getOrganDLSearch(pDLSearchList, info);
			}

	        if (useShowAllCompanies.equals("YES")) {
	        	// Company ID를 본래값으로 복원한다.
	        	info.setCompanyId(orgCompanyId);
	        }				
			
			if (!pAddressFilter.isEmpty()) {
				addressXML = getAddressSearchInfo(pAddressFilter, info);
			}
			
			if (!pSharedMailboxSearchList.isEmpty()) {
				sharedMailboxXML = getSharedMailboxSearch(pSharedMailboxSearchList, info);
			}
			
			// 20190619 조진호 - 메일 주소 검색 대상 순서 변경 추가
			String mailAddressSearchOrder =  ezCommonService.getUserConfigInfo(info.getTenantId(), info.getUserId(), "mailAddressSearchOrder");
						
	        
	        data.put("organXML", organXML);
	        data.put("dlXML", dlXML);
	        data.put("addressXML", addressXML);
	        data.put("sharedMailboxXML", sharedMailboxXML);
	        data.put("mailAddressSearchOrder", mailAddressSearchOrder);
	        
	        result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", data);			
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "fail");			
		}
        
        logger.debug("MOBILE G/W MAIL mailNameCheck ended.");
        
        return result;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezemail/users/{userId:.+}/addressbook", method= RequestMethod.POST,  produces="application/json;charset=utf-8")
	public Object searchAddressBook(HttpServletRequest request, @PathVariable String userId, @RequestBody JSONObject jsonObject) {		
		logger.debug("MOBILE G/W MAIL searchAddressBook started.");
		logger.debug("userId=" + userId + ",jsonObject=" + jsonObject);
		
        String addressXML = "";
		
        JSONObject data = new JSONObject();
        JSONObject result = new JSONObject();
		
        try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
									
			String searchTarget = "";
			String filterName = "";
			String filterValue = "";
			int start = 0;
			int end = 99;
			
			if (jsonObject.get("searchTarget") != null) {
				searchTarget = (String)jsonObject.get("searchTarget");
			}
			
			if (jsonObject.get("filterName") != null) {
				filterName = (String)jsonObject.get("filterName");
			}

			if (jsonObject.get("filterValue") != null) {
				filterValue = (String)jsonObject.get("filterValue");
			}
			
			if (jsonObject.get("start") != null) {
				start =  ((Integer)jsonObject.get("start")).intValue();
			}

			if (jsonObject.get("end") != null) {
				end =  ((Integer)jsonObject.get("end")).intValue();
			}
			
			int[] searchCount = {0, 0};
			
			if (!searchTarget.isEmpty() && !filterName.isEmpty()) {
				addressXML = getAddressSearch(searchTarget, filterName, filterValue, info,
						start, end - start + 1, searchCount);	
			}
			
	        data.put("addressXML", addressXML);
	        data.put("fullCount", searchCount[0]);	        
	        data.put("optionCount", searchCount[1]);
	        
	        result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", data);			
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "fail");			
		}
        
		logger.debug("MOBILE G/W MAIL searchAddressBook ended.");
		
		return result;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezemail/users/{userId:.+}/addressbook", method= RequestMethod.PUT,  produces="application/json;charset=utf-8")
	public Object addAddress(HttpServletRequest request, @PathVariable String userId, @RequestBody JSONObject jsonObject) {		
		logger.debug("MOBILE G/W MAIL addAddress started.");
		logger.debug("userId=" + userId + ",jsonObject=" + jsonObject);
		
        JSONObject result = new JSONObject();
		
        try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
								
			String ownerId = "";
			String folderType = "";
			String sName = "";
			String sCompany = "";
			String sDept = "";
			String sTitle = "";
			String sEmail = "";
			String sCompanyPhone = "";
			String sMobile = "";
			String sMemo = "";
			String folderId = "";
			String sFurigana = "";
			
			if (jsonObject.get("folderType") != null) {
				folderType = (String)jsonObject.get("folderType");
			}
			
			if (jsonObject.get("folderId") != null) {
				folderId = (String)jsonObject.get("folderId");
			}
			
			if (jsonObject.get("sName") != null) {
				sName = (String)jsonObject.get("sName");
			}

			if (jsonObject.get("sCompany") != null) {
				sCompany = (String)jsonObject.get("sCompany");
			}
			
			if (jsonObject.get("sDept") != null) {
				sDept = (String)jsonObject.get("sDept");
			}
			
			if (jsonObject.get("sTitle") != null) {
				sTitle = (String)jsonObject.get("sTitle");
			}

			if (jsonObject.get("sEmail") != null) {
				sEmail = (String)jsonObject.get("sEmail");
			}
			
			if (jsonObject.get("sCompanyPhone") != null) {
				sCompanyPhone = (String)jsonObject.get("sCompanyPhone");
			}
			
			if (jsonObject.get("sMobile") != null) {
				sMobile = (String)jsonObject.get("sMobile");
			}

			if (jsonObject.get("sMemo") != null) {
				sMemo = (String)jsonObject.get("sMemo");
			}
			
			if (jsonObject.get("sFurigana") != null) {
				sFurigana = (String)jsonObject.get("sFurigana");
			}
			
			if (!folderType.isEmpty()) {				
				if (folderType.equals("C")) {
					ownerId = info.getCompanyId();
				} else if (folderType.equals("D")) {
					ownerId = info.getDeptId();
				} else {
					ownerId = info.getUserId();
				}
				
				ezAddressService.insertAddress(info.getTenantId(), ownerId, folderId, info.getUserId(),
						info.getUserName(), info.getUserName2(), sName, sEmail, sCompany, sDept,
						sTitle, sCompanyPhone, "", sMobile, "", "", "", "", "", sMemo, "P", sFurigana);
				
		        result.put("status", "ok");
				result.put("code", 0);			
				result.put("data", "success");
			} else {
				result.put("status", "error");
				result.put("code", 2);			
				result.put("data", "fail");							
			}
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "fail");			
		}
        
		logger.debug("MOBILE G/W MAIL addAddress ended.");
		
		return result;
	}

	// 모바일 메일 읽기창에서 송신자를 insert
	@RequestMapping(value="/mobile/ezemail/users/{userId:.+}/addressSave", method= RequestMethod.POST,  produces="application/json;charset=utf-8")
	public Object addressSave(HttpServletRequest request, @PathVariable String userId, @RequestBody JSONObject jsonObject) {
		logger.debug("MOBILE G/W MAIL addressSave started.");
		logger.debug("userId=" + userId + ",jsonObject=" + jsonObject);

		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);

			String ownerId = "";
			String folderType = "";
			String sName = "";
			String sCompany = "";
			String sDept = "";
			String sTitle = "";
			String sEmail = "";
			String sCompanyPhone = "";
			String sMobile = "";
			String sMemo = "";
			String folderId = "";
			String sFurigana = "";

			if (jsonObject.get("folderType") != null) {
				folderType = (String)jsonObject.get("folderType");
			}

			if (jsonObject.get("folderId") != null) {
				folderId = (String)jsonObject.get("folderId");
			}

			if (jsonObject.get("sName") != null) {
				sName = (String)jsonObject.get("sName");
			}

			if (jsonObject.get("sCompany") != null) {
				sCompany = (String)jsonObject.get("sCompany");
			}

			if (jsonObject.get("sDept") != null) {
				sDept = (String)jsonObject.get("sDept");
			}

			if (jsonObject.get("sTitle") != null) {
				sTitle = (String)jsonObject.get("sTitle");
			}

			if (jsonObject.get("sEmail") != null) {
				sEmail = (String)jsonObject.get("sEmail");
			}

			if (jsonObject.get("sCompanyPhone") != null) {
				sCompanyPhone = (String)jsonObject.get("sCompanyPhone");
			}

			if (jsonObject.get("sMobile") != null) {
				sMobile = (String)jsonObject.get("sMobile");
			}

			if (jsonObject.get("sMemo") != null) {
				sMemo = (String)jsonObject.get("sMemo");
			}

			if (jsonObject.get("sFurigana") != null) {
				sFurigana = (String)jsonObject.get("sFurigana");
			}

			if (!folderType.isEmpty()) {

				// ownerId가 없으면 디비에서 구하기.
				if (ownerId.trim().equals("")) {
					if (folderId.equals("0")) {
						if (folderType.equals("C")) {
							ownerId = info.getCompanyId();
						} else if (folderType.equals("D")) {
							ownerId = info.getDeptId();
						} else {
							ownerId = info.getUserId();
						}
					}
					else {
						AddressFolderVO folderInfo = ezAddressService.getFolderInfo(folderId);
						ownerId = folderInfo.getOwnerId();
					}
				}

				boolean isDuplicate = ezAddressService.checkDuplicateAddress(info.getTenantId(), ownerId, sEmail.trim());
				if (isDuplicate) {
					result.put("status", "error");
					result.put("code", 3);
					result.put("data", "duplicate");

					return result;
				}

				String useAnyoneEdit = ezCommonService.getTenantConfig("UseAnyoneEdit", info.getTenantId());
				logger.debug("useAnyoneEdit="+ useAnyoneEdit);

				// UseAnyoneEdit이 YES가 아닐 경우 관리자인지 체크
				if (!useAnyoneEdit.equals("YES")) {
					if (folderType.equals("C")) {
						if (!(info.getRollInfo().indexOf("c=1") > -1 || info.getRollInfo().indexOf("k=1") > -1)) {
							return "NO_AUTHORITY_C";
						}
					} else if (folderType.equals("D")) {
						if (!(info.getRollInfo().indexOf("c=1") > -1 || info.getRollInfo().indexOf("k=1") > -1 || info.getRollInfo().indexOf("g=1") > -1)) {
							return "NO_AUTHORITY_D";
						}
					}
				}

				ezAddressService.insertAddress(info.getTenantId(), ownerId, folderId, info.getUserId(),
						info.getUserName(), info.getUserName2(), sName, sEmail, sCompany, sDept,
						sTitle, sCompanyPhone, "", sMobile, "", "", "", "", "", sMemo, "P", sFurigana);

				result.put("status", "ok");
				result.put("code", 0);
				result.put("data", "success");
			} else {
				result.put("status", "error");
				result.put("code", 2);
				result.put("data", "fail");
			}
		} catch (Exception e) {
			logger.error(e.getMessage(), e);

			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "fail");
		}

		logger.debug("MOBILE G/W MAIL addressSave ended.");

		return result;
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/mobile/ezemail/users/{userId:.+}/mailRequestDenial", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject mailRequestDenial(HttpServletRequest request, @PathVariable String userId, @RequestBody JSONObject jsonObject) {
		logger.debug("MOBILE G/W MAIL mailRequestDenial started.");
		logger.debug("uesrId={}", userId);

		JSONObject result = new JSONObject();

		try {
			String senderAddress = (String) jsonObject.get("senderAddress");
			String senderName = (String) jsonObject.get("senderName");
			String shareId = (String) jsonObject.get("shareId");

			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);

			StringBuilder sb = new StringBuilder();

			String domainName = ezCommonService.getTenantConfig("DomainName", info.getTenantId());
			String userEmail = info.getUserId() + "@" + domainName;

			// 공유 사서함일 경우
            if (StringUtils.isNotBlank(shareId)) {
				logger.debug("shared=" + shareId);
				userEmail = shareId + "@" + domainName;
			}

			logger.debug("userEmail=" + userEmail);

			sb.append("userId=" + URLEncoder.encode(userEmail, "UTF-8"));

			if (senderName == null) {
				senderName = senderAddress;
			}

			String address = senderName +" "+ "<" + senderAddress + ">";
			address = address.replaceAll(":", "");

			String ld = commonUtil.getTwoLetterLangFromLangNum(info.getLang());
			Locale locale = new Locale(ld);

			if (senderAddress != null) {
				String ezEmailMsg = egovMessageSource.getMessage("ezEmail.t270", locale);
				String displayName = address + " " + ezEmailMsg;

				// 2025-09-17 김은실: 규칙이름이 100자가 넘어갈 경우 메일주소만 넣기. "RULE_NAME" NVARCHAR2(100) //ORA-12899: value too large for column "JMOCHA_INBOX_RULE"."RULE_NAME" (actual: 114, maximum: 100)
				displayName = (100 < displayName.length())? senderAddress + " " + ezEmailMsg : displayName;

				sb.append("&displayName=" + URLEncoder.encode(displayName, "UTF-8"));
				sb.append("&rejectId=" + URLEncoder.encode(senderAddress, "UTF-8"));
			}

			String inputParams = sb.toString();
			logger.debug("inputParams=" + inputParams);

			String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaAccess/setRejectRule", inputParams);

			JSONParser parser = new JSONParser();
			result = (JSONObject)parser.parse(strJson);

		} catch (Exception e){
			logger.error(e.getMessage(), e);
			result.put("resultCode", "ERROR");
		}

		logger.debug("result = {}", result.get("resultCode").toString());
		logger.debug("MOBILE G/W MAIL mailRequestDenial ended.");

		return result;
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezemail/users/{userId:.+}/addressbook/{addressId:.+}", method=RequestMethod.GET, produces="application/json;charset=utf-8")
	public Object getAddressInfo(HttpServletRequest request, @PathVariable String userId, @PathVariable String addressId) {		
		logger.debug("MOBILE G/W MAIL getAddressInfo started.");
		logger.debug("userId=" + userId + ",addressId=" + addressId);
		
        JSONObject result = new JSONObject();
		
        try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
										       
			AddressVO addressInfo = ezAddressService.getAddressInfo(
										info.getTenantId(),
										info.getPrimary(),
										addressId
										);
			
	        result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", addressInfo);			
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "fail");			
		}
        
		logger.debug("MOBILE G/W MAIL getAddressInfo ended.");
		
		return result;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezemail/users/{userId:.+}/addressbook/{addressId:.+}", method=RequestMethod.DELETE, produces="application/json;charset=utf-8")
	public Object deleteAddressInfo(HttpServletRequest request, @PathVariable String userId, @PathVariable String addressId) {		
		logger.debug("MOBILE G/W MAIL deleteAddressInfo started.");
		logger.debug("userId=" + userId + ",addressId=" + addressId);
		
        JSONObject result = new JSONObject();
		
        try {
        	String[] addressIds = new String[]{addressId};
        	ezAddressService.deleteAddress(addressIds);
			
	        result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", "success");			
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "fail");			
		}
        
		logger.debug("MOBILE G/W MAIL deleteAddressInfo ended.");
		
		return result;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezemail/users/{userId:.+}/addressbook/{addressId:.+}", method=RequestMethod.PUT, produces="application/json;charset=utf-8")
	public Object updateAddressInfo(HttpServletRequest request, @PathVariable String userId, @PathVariable String addressId, @RequestBody JSONObject jsonObject) {		
		logger.debug("MOBILE G/W MAIL updateAddressInfo started.");
		
		JSONObject result = new JSONObject();
		
        try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
								
			@SuppressWarnings("unused")
			String ownerId = "";
			String folderType = "";
			String sName = "";
			String sCompany = "";
			String sDept = "";
			String sTitle = "";
			String sEmail = "";
			String sCompanyPhone = "";
			String sMobile = "";
			String sMemo = "";
			@SuppressWarnings("unused")
			String folderId = "";
			String sFurigana = "";
			
			if (jsonObject.get("folderType") != null) {
				folderType = (String)jsonObject.get("folderType");
			}
			
			if (jsonObject.get("folderId") != null) {
				folderId = (String)jsonObject.get("folderId");
			}
			
			if (jsonObject.get("sName") != null) {
				sName = (String)jsonObject.get("sName");
			}

			if (jsonObject.get("sCompany") != null) {
				sCompany = (String)jsonObject.get("sCompany");
			}
			
			if (jsonObject.get("sDept") != null) {
				sDept = (String)jsonObject.get("sDept");
			}
			
			if (jsonObject.get("sTitle") != null) {
				sTitle = (String)jsonObject.get("sTitle");
			}

			if (jsonObject.get("sEmail") != null) {
				sEmail = (String)jsonObject.get("sEmail");
			}
			
			if (jsonObject.get("sCompanyPhone") != null) {
				sCompanyPhone = (String)jsonObject.get("sCompanyPhone");
			}
			
			if (jsonObject.get("sMobile") != null) {
				sMobile = (String)jsonObject.get("sMobile");
			}

			if (jsonObject.get("sMemo") != null) {
				sMemo = (String)jsonObject.get("sMemo");
			}
			
			if (jsonObject.get("sFurigana") != null) {
				sFurigana = (String)jsonObject.get("sFurigana");
			}
			
			if (!folderType.isEmpty()) {				
				if (folderType.equals("C")) {
					ownerId = info.getCompanyId();
				} else if (folderType.equals("D")) {
					ownerId = info.getDeptId();
				} else {
					ownerId = info.getUserId();
				}
				
				ezAddressService.updateAddress(info.getTenantId(), addressId, info.getUserId(), info.getUserName(), info.getUserName2(), 
						sName, sEmail, sCompany, sDept, sTitle, sCompanyPhone, "", sMobile, "", "", "", "", "", sMemo, sFurigana);
				
		        result.put("status", "ok");
				result.put("code", 0);			
				result.put("data", "success");
			} else {
				result.put("status", "error");
				result.put("code", 2);			
				result.put("data", "fail");							
			}
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "fail");			
		}
		logger.debug("MOBILE G/W MAIL updateAddressInfo ended.");
		
		return result;
	}
	
	/**
	 * 메일 책갈피 지정 실행 함수
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezemail/users/{userId:.+}/setFlag", method= RequestMethod.POST, produces="application/json;charset=utf-8")
	public Object mailSetFlag(HttpServletRequest request, @PathVariable String userId, @RequestBody JSONObject jsonObject) throws Exception {
		logger.debug("MOBILE G/W MAIL mailSetFlag started. userId={}", userId);

		String returnData = "";
		
	    JSONObject result = new JSONObject();
	     
	    IMAPAccess ia = null;
	     
	    String setCmd = "toggle";
		String mailId = "";
		
		if (jsonObject.get("setCmd") != null) {
			setCmd = (String) jsonObject.get("setCmd");
		}

		if (jsonObject.get("mails") != null) {
			mailId = (String) jsonObject.get("mails");
		}
	    
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			String domainName = ezCommonService.getTenantConfig("DomainName", info.getTenantId());
			String userEmail = info.getUserId() + "@" + domainName;
			String password = jspw;
			String ld = commonUtil.getTwoLetterLangFromLangNum(info.getLang());
			Locale locale = new Locale(ld);
			
			logger.debug("mailSetFlag userEmail={}, mailId={}", userEmail, mailId);
			
			String uniqueId = mailId;
			String[] folderAndMsgIdArray = uniqueId.split(",");
			Map<String, long[]> folderIdUids = ezEmailUtil.getFolderIdUid(folderAndMsgIdArray);
			
			/* 전체메일 - 다중편지함 지원으로 ezEmailUtil.getFolderIdUid 사용, 아래 주석
			long[] uids = null;
			
			if (uniqueId.endsWith(",")) {
				uniqueId = uniqueId.substring(0, uniqueId.length() - 1);
			}
			
			String[] messageIdArray = uniqueId.split(",");
						
			uids = new long[messageIdArray.length];
			
			for (int i = 0; i < messageIdArray.length; i++) {
				String msgId = messageIdArray[messageIdArray.length - i - 1];
				uids[i] = Long.parseLong(msgId);
			}
			
			logger.debug("folderId=" + folderId + "uniqueId=" + uniqueId);	*/	

			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
				userEmail, password, egovMessageSource, locale, ezEmailUtil);
				
			if (ia != null) {
				for (String folderId : folderIdUids.keySet()) {
					long[] uids = folderIdUids.get(folderId);
					IMAPFolder sourceFolder = (IMAPFolder) ia.getFolder(folderId);
					sourceFolder.open(Folder.READ_WRITE);

					Message[] msgs = sourceFolder.getMessagesByUID(uids);

					for (int i = 0; i < msgs.length; i++) {
						Message msg = msgs[i];

						if (setCmd.equals("toggle")) {
							if (msg.isSet(Flags.Flag.FLAGGED)) {
								msg.setFlag(Flags.Flag.FLAGGED, false);
								returnData = "DEL";
							} else {
								msg.setFlag(Flags.Flag.FLAGGED, true);
								returnData = "NEW";
							}
						} else if (setCmd.equals("set")) {
							msg.setFlag(Flags.Flag.FLAGGED, true);
							returnData = "NEW";
						} else if (setCmd.equals("reset")) {
							msg.setFlag(Flags.Flag.FLAGGED, false);
							returnData = "DEL";
						}
					}

					sourceFolder.close(true);
				}
			}
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", returnData);			
		} catch (Exception e) {
			returnData = "ERROR : " + e.getMessage();
			
			logger.error(e.getMessage(), e);
			
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", returnData);			
		}  finally {
			if (ia != null) {
				ia.close();
			}
		}
		
		logger.debug("MOBILE G/W MAIL mailSetFlag ended.");
		
		return result;				
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value={"/mobile/ezemail/users/{userId:.+}/quota", "/mobile/ezemail/users/{userId:.+}/quota/{shareId:.+}"}, method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public Object getQuotaInfo(HttpServletRequest request, @PathVariable String userId, @PathVariable(value = "shareId", required = false) String shareId) throws Exception {
		logger.debug("MOBILE G/W MAIL getQuotaInfo started.");
		logger.debug("userId=" + userId);
			
		JSONObject data = new JSONObject();
		JSONObject result = new JSONObject();
		
		IMAPAccess ia = null;

		try {			
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			String domainName = ezCommonService.getTenantConfig("DomainName", info.getTenantId());
			String userEmail = info.getUserId() + "@" + domainName;
			String password = jspw;
		
			Locale locale = new Locale("ko");	
	
			String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", info.getTenantId());
			
			if (useSharedMailbox.equals("YES") && shareId != null) {
				if(!ezEmailService.checkUserShareId(info.getUserId(), shareId, info.getTenantId())) {
					logger.debug("the user cannot access the shareId.");
					logger.debug("mailGetUse ended.");

					return "";
				}
				userEmail = shareId + "@" + domainName;
			}
			
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userEmail, password, egovMessageSource, locale, ezEmailUtil);
			if (ia != null){
				long[] storageUsageAndLimit = ia.getStorageUsageAndLimit();

				double mailboxUsage = storageUsageAndLimit[0]; // in KBs
				double mailboxQuota = storageUsageAndLimit[1]; // in KBs

				logger.debug("mailboxUsage=" + mailboxUsage + ",mailboxQuota=" + mailboxQuota);

				data.put("mailboxUsage", mailboxUsage);
				data.put("mailboxQuota", mailboxQuota);
			}
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", data);			
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");			
		} finally {
			if (ia != null) {
				ia.close();		
			}
		}
		
		logger.debug("MOBILE G/W MAIL getQuotaInfo ended.");		
		
		return result;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezemail/users/{userId:.+}/config", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public Object getConfigInfo(HttpServletRequest request, @PathVariable String userId) throws Exception {
		logger.debug("MOBILE G/W MAIL getConfigInfo started.");
		logger.debug("userId=" + userId);
			
		JSONObject data = new JSONObject();
		JSONObject result = new JSONObject();
		
		IMAPAccess ia = null;

		try {			
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
		
			// retrieve the mail general settings from DB.
			MailGeneralVO mailGeneral = ezEmailService.getMailGeneral(info.getTenantId(), info.getUserId()).get(0);

			logger.debug("mailGeneral=" + mailGeneral);
			
			data.put("listCount", mailGeneral.getListCount());
			data.put("textOption", mailGeneral.getTextOption());
											
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", data);			
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");			
		} finally {
			if (ia != null) {
				ia.close();		
			}
		}
		
		logger.debug("MOBILE G/W MAIL getConfigInfo ended.");		
		
		return result;
	}
	
	/**
	 * 사원 Organ 정보 호출 함수
	 */
	private String getOrganSearch(String pSearchList, String pCellList, String pPropList, String pListType, MCommonVO userInfo) {
		String pResult = "";
		
        try {
            pResult = ezOrganService.getSearchListOR(pSearchList, pCellList, pPropList, pListType, 100, userInfo.getPrimary(), userInfo.getTenantId(), userInfo.getCompanyId());
        } catch (Exception e) {
        	logger.error(e.getMessage(), e);
        	
            pResult = "EXCEPTION";
        }
        
        return pResult;
    }
	
	/**
	 * 공용배포그룹 정보 호출 함수
	 */
	private String getOrganDLSearch(String pSearchList, MCommonVO userInfo) {
        String returnData = "";
        
        try {
        	String searchValue = pSearchList.split("::")[1];
        	
			List<MailDistributionVO> distributionList = ezEmailService.getDistributionSearchList(userInfo.getCompanyId(), userInfo.getTenantId(), searchValue);
			
			StringBuilder sb = new StringBuilder();
			sb.append("<LISTVIEWDATA><ROWS>");

			for (MailDistributionVO vo : distributionList) {
				sb.append("<ROW><CELL>");
				
				sb.append("<VALUE>");
				sb.append(commonUtil.cleanValue(vo.getName()));
				sb.append("</VALUE>");
				
				sb.append("<DATA1>group</DATA1>");
				
				sb.append("<DATA2>");
				sb.append(commonUtil.cleanValue(vo.getId()));
				sb.append("</DATA2>");
				
				sb.append("<DATA3>");
				sb.append(commonUtil.cleanValue(vo.getMail()));
				sb.append("</DATA3>");
				
				sb.append("</CELL></ROW>");
			}
			
			sb.append("</ROWS></LISTVIEWDATA>");
			
			returnData = sb.toString();			
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			
			returnData = "EXCEPTION";
		}
        
        return returnData;
    }
	
	/**
	 * 주소록 정보 호출 함수
	 */
	private String getAddressSearch(String searchTarget, String filterName, String filterValue, MCommonVO userInfo,
					int start, int count, int[] searchCount) {
		logger.debug("getAddressSearch started");
		logger.debug("getAddressSearch searchTarget=" + searchTarget + ",filterName=" + filterName
				+ ",filterValue=" + filterValue + ",start=" + start + ",count=" + count);
		
        String returnValue = "";
        String name = "";
        
        try {
        	String[] ownerIds = null;
        	List<String> ownerIdList = new ArrayList<>();
        	
        	if (searchTarget.equalsIgnoreCase("all")) {
                ownerIds = new String[]{userInfo.getCompanyId(), userInfo.getDeptId(), userInfo.getUserId()};        		
        	} else {
	        	if (searchTarget.contains("company")) {
	        		ownerIdList.add(userInfo.getCompanyId());
	        	}
	        	
	        	if (searchTarget.contains("department")) {
	        		ownerIdList.add(userInfo.getDeptId());
	        	}
	        	
	        	if (searchTarget.contains("personal")) {
	        		ownerIdList.add(userInfo.getUserId());
	        	}
	        	
	        	ownerIds = ownerIdList.toArray(new String[0]);
        	}
            
        	for (String ownerId : ownerIds) {
        		logger.debug("getAddressSearch ownerId=" + ownerId);
        	}
        	
            String pFilter = filterName + "," + filterValue;
                        
            searchCount[0] = ezAddressService.getSearchCount(userInfo.getTenantId(), ownerIds, filterName + ",");
            searchCount[1] = ezAddressService.getSearchCount(userInfo.getTenantId(), ownerIds, pFilter);            
            
            List<AddressVO> addressInfoList = ezAddressService.getSearchList(userInfo.getTenantId(), ownerIds, "", pFilter, count, start);
            
            StringBuilder sb = new StringBuilder();
            sb.append("<LISTVIEWDATA><ROWS>");
            for (AddressVO addressInfo : addressInfoList) {
            	sb.append("<ROW>");
            	sb.append("<STYPE>" + (addressInfo.getsType() == null ? "" : addressInfo.getsType()) + "</STYPE>");
            	sb.append("<ADDRESSID>" + (addressInfo.getAddressId() == null ? "" : addressInfo.getAddressId()) + "</ADDRESSID>");
            	if (addressInfo.getsName() != null) {
            		name = commonUtil.cleanValue(addressInfo.getsName().toString());
            	} else {
            		name = "";
            	}
            	sb.append("<SNAME>" + name + "</SNAME>");
            	sb.append("<FOLDERTYPE>DB</FOLDERTYPE>");
            	sb.append("<SEMAIL>" + (addressInfo.getsEmail() == null ? "" : commonUtil.cleanValue(addressInfo.getsEmail())) + "</SEMAIL>");
            	sb.append("<SCOMPANY>" + (addressInfo.getsCompany() == null ? "" : commonUtil.cleanValue(addressInfo.getsCompany())) + "</SCOMPANY>");
            	sb.append("<SDEPT>" + (addressInfo.getsDept() == null ? "" : commonUtil.cleanValue(addressInfo.getsDept())) + "</SDEPT>");
            	sb.append("<STITLE>" + (addressInfo.getsTitle() == null ? "" : commonUtil.cleanValue(addressInfo.getsTitle())) + "</STITLE>");
            	sb.append("<SCOMPANYPHONE>" + (addressInfo.getsCompanyPhone() == null ? "" : commonUtil.cleanValue(addressInfo.getsCompanyPhone())) + "</SCOMPANYPHONE>");
            	sb.append("<SMOBILE>" + (addressInfo.getsMobile() == null ? "" : commonUtil.cleanValue(addressInfo.getsMobile())) + "</SMOBILE>");
            	sb.append("</ROW>");
            }
            sb.append("</ROWS></LISTVIEWDATA>");
            returnValue = sb.toString();
        } catch (Exception e) {
        	logger.error(e.getMessage(), e);
            
        	returnValue = "EXCEPTION";
        }
        
        logger.debug("getAddressSearch ended");
        
        return returnValue;
    }
	
	private String getAddressSearchInfo(String pFilter, MCommonVO userInfo) {
        String returnValue = "";
        try {
            String[] ownerIds = new String[]{userInfo.getCompanyId(), userInfo.getDeptId(), userInfo.getUserId()};
            pFilter = "S_NAME;S_EMAIL," + pFilter;
            
            List<AddressVO> addressInfoList = ezAddressService.getSearchList(userInfo.getTenantId(), ownerIds, "", pFilter, 100, 0);
            
            StringBuilder sb = new StringBuilder();
            sb.append("<LISTVIEWDATA><ROWS>");
            
            for (AddressVO addressInfo : addressInfoList) {
            	if (addressInfo.getsEmail() != null || !"".equalsIgnoreCase(addressInfo.getsEmail())) {
            		sb.append("<ROW>");
                	sb.append("<STYPE>" + (addressInfo.getsType() == null ? "" : addressInfo.getsType()) + "</STYPE>");
                	sb.append("<ADDRESSID>" + (addressInfo.getAddressId() == null ? "" : addressInfo.getAddressId()) + "</ADDRESSID>");
                	sb.append("<SNAME>" + (addressInfo.getsName() == null ? "" : commonUtil.cleanValue(addressInfo.getsName())) + "</SNAME>");
                	sb.append("<FOLDERTYPE>DB</FOLDERTYPE>");
                	sb.append("<SEMAIL>" + (addressInfo.getsEmail() == null ? "" : commonUtil.cleanValue(addressInfo.getsEmail())) + "</SEMAIL>");
                	sb.append("<SCOMPANY>" + (addressInfo.getsCompany() == null ? "" : commonUtil.cleanValue(addressInfo.getsCompany())) + "</SCOMPANY>");
                	sb.append("<SDEPT>" + (addressInfo.getsDept() == null ? "" : commonUtil.cleanValue(addressInfo.getsDept())) + "</SDEPT>");
                	sb.append("<STITLE>" + (addressInfo.getsTitle() == null ? "" : commonUtil.cleanValue(addressInfo.getsTitle())) + "</STITLE>");
                	sb.append("</ROW>");
            	}
            }
            
            sb.append("</ROWS></LISTVIEWDATA>");
            returnValue = sb.toString();
        } catch (Exception e) {
        	logger.error(e.getMessage(), e);
        	returnValue = "EXCEPTION";
        }
        return returnValue;
    }
	
	/**
	 * 주소록 정보 호출 함수 (folderID로 호출)
	 */
	private String getAddressSearch(String searchTarget, String filterName, String filterValue, MCommonVO userInfo,
					int start, int count, int[] searchCount, String folderID) {
		logger.debug("getAddressSearch started");
		logger.debug("getAddressSearch searchTarget=" + searchTarget + ",filterName=" + filterName
				+ ",filterValue=" + filterValue + ",start=" + start + ",count=" + count + ",folderID=" + folderID);
		
        String returnValue = "";
        String pFilter = "";
        List<AddressVO> addressInfoList = null;
        
        try {
        	// 메일쓰기 > 받는사람 > 주소록 검색 시 사용
        	if (searchTarget.equals("all")) {
            	String[] ownerIds = null;
            	List<String> ownerIdList = new ArrayList<>();
            	
            	if (searchTarget.equalsIgnoreCase("all")) {
                    ownerIds = new String[]{userInfo.getCompanyId(), userInfo.getDeptId(), userInfo.getUserId()};        		
            	} else {
    	        	if (searchTarget.contains("company")) {
    	        		ownerIdList.add(userInfo.getCompanyId());
    	        	}
    	        	
    	        	if (searchTarget.contains("department")) {
    	        		ownerIdList.add(userInfo.getDeptId());
    	        	}
    	        	
    	        	if (searchTarget.contains("personal")) {
    	        		ownerIdList.add(userInfo.getUserId());
    	        	}
    	        	
    	        	ownerIds = ownerIdList.toArray(new String[0]);
            	}
                
            	for (String ownerId : ownerIds) {
            		logger.debug("getAddressSearch ownerId=" + ownerId);
            	}
            	
            	pFilter = filterName + "," + filterValue;
            	
            	searchCount[0] = ezAddressService.getSearchCount(userInfo.getTenantId(), ownerIds, filterName + ",");
                searchCount[1] = ezAddressService.getSearchCount(userInfo.getTenantId(), ownerIds, pFilter);   
            	
            	// start와 end(getAddressSearch를 호출 하는 곳에서 +1을 해주어 count값은 1로 넘어온다)값이 각각 0으로 넘어오는 경우 전체리스트를 출력하기 위해 count에 searchCount 대입 
                if(start == 0 && count == 1){
                	count = searchCount[1];
                }
                // 끝
                
                addressInfoList = ezAddressService.getSearchList(userInfo.getTenantId(), ownerIds, "", pFilter, count, start);
        	} else { // 폴더 id가 필요한 주소록에서 사용
            	String ownerId = "";
            	
            	if (searchTarget.contains("company")) {
            		ownerId = userInfo.getCompanyId();
            	} else if (searchTarget.contains("department")) {
            		ownerId = userInfo.getDeptId();
            	} else if (searchTarget.contains("personal")) {
            		ownerId = userInfo.getUserId();
            	}
            	
            	pFilter = filterName + "," + filterValue;
            	
            	searchCount[0] = ezAddressService.getAddressCount(userInfo.getTenantId(), folderID, ownerId, pFilter);
                searchCount[1] = ezAddressService.getAddressCount(userInfo.getTenantId(), folderID, ownerId, pFilter);
        		
                
                // start와 end(getAddressSearch를 호출 하는 곳에서 +1을 해주어 count값은 1로 넘어온다)값이 각각 0으로 넘어오는 경우 전체리스트를 출력하기 위해 count에 searchCount 대입 
                if(start == 0 && count == 1){
                	count = searchCount[1];
                }
                // 끝
                
                addressInfoList = ezAddressService.getAddressList(userInfo.getTenantId(), folderID, ownerId, "", pFilter, count, start);
        	}

            StringBuilder sb = new StringBuilder();
            sb.append("<LISTVIEWDATA><ROWS>");
            for (AddressVO addressInfo : addressInfoList) {
            	sb.append("<ROW>");
            	sb.append("<STYPE>" + (addressInfo.getsType() == null ? "" : addressInfo.getsType()) + "</STYPE>");
            	sb.append("<ADDRESSID>" + (addressInfo.getAddressId() == null ? "" : addressInfo.getAddressId()) + "</ADDRESSID>");
            	sb.append("<SNAME>" + (addressInfo.getsName() == null ? "" : commonUtil.cleanValue(addressInfo.getsName())) + "</SNAME>");
            	sb.append("<FOLDERTYPE>DB</FOLDERTYPE>");
            	sb.append("<SEMAIL>" + (addressInfo.getsEmail() == null ? "" : commonUtil.cleanValue(addressInfo.getsEmail())) + "</SEMAIL>");
            	sb.append("<SCOMPANY>" + (addressInfo.getsCompany() == null ? "" : commonUtil.cleanValue(addressInfo.getsCompany())) + "</SCOMPANY>");
            	sb.append("<SDEPT>" + (addressInfo.getsDept() == null ? "" : commonUtil.cleanValue(addressInfo.getsDept())) + "</SDEPT>");
            	sb.append("<STITLE>" + (addressInfo.getsTitle() == null ? "" : commonUtil.cleanValue(addressInfo.getsTitle())) + "</STITLE>");
            	sb.append("<SCOMPANYPHONE>" + (addressInfo.getsCompanyPhone() == null ? "" : commonUtil.cleanValue(addressInfo.getsCompanyPhone())) + "</SCOMPANYPHONE>");
            	sb.append("<SMOBILE>" + (addressInfo.getsMobile() == null ? "" : commonUtil.cleanValue(addressInfo.getsMobile())) + "</SMOBILE>");
            	sb.append("</ROW>");
            }
            sb.append("</ROWS></LISTVIEWDATA>");
            returnValue = sb.toString();
        } catch (Exception e) {
        	logger.error(e.getMessage(), e);
        	
        	returnValue = "EXCEPTION";
        }
        
        logger.debug("getAddressSearch ended");
        
        return returnValue;
    }
	
	/**
	 * 주소록 정보 호출 함수 (addressType로 호출)
	 */
	private String getFilterAddressSearch(String searchTarget, String filterName, String filterValue, MCommonVO userInfo,
					int start, int count, int[] searchCount, String folderID, String addressType) {
		logger.debug("getFilterAddressSearch started");
		logger.debug("getFilterAddressSearch searchTarget=" + searchTarget + ",filterName=" + filterName
				+ ",filterValue=" + filterValue + ",start=" + start + ",count=" + count + ",folderID=" + folderID
				+ ",addressType=" + addressType);
		
        String returnValue = "";
       
        try {
        	
        	String[] ownerIds = null;
        	List<String> ownerIdList = new ArrayList<>();
        	
        	if (searchTarget.equalsIgnoreCase("all")) {
                ownerIds = new String[]{userInfo.getCompanyId(), userInfo.getDeptId(), userInfo.getUserId()};        		
        	} else {
	        	if (searchTarget.contains("company")) {
	        		ownerIdList.add(userInfo.getCompanyId());
	        	}
	        	
	        	if (searchTarget.contains("department")) {
	        		ownerIdList.add(userInfo.getDeptId());
	        	}
	        	
	        	if (searchTarget.contains("personal")) {
	        		ownerIdList.add(userInfo.getUserId());
	        	}
	        	
	        	ownerIds = ownerIdList.toArray(new String[0]);
        	}
            
        	for (String ownerId : ownerIds) {
        		logger.debug("getAddressSearch ownerId=" + ownerId);
        	}
        	
            String pFilter = filterName + "," + filterValue;
                        
            searchCount[0] = ezAddressService.getFilterAddressSearchCount(userInfo.getTenantId(), folderID, ownerIds, filterName + ",", addressType);
            searchCount[1] = ezAddressService.getFilterAddressSearchCount(userInfo.getTenantId(), folderID, ownerIds, pFilter, addressType);            
            
            // start와 end(getAddressSearch를 호출 하는 곳에서 +1을 해주어 count값은 1로 넘어온다)값이 각각 0으로 넘어오는 경우 전체리스트를 출력하기 위해 count에 searchCount 대입 
            if(start == 0 && count == 1){
            	count = searchCount[1];
            }
            // 끝
            
            List<AddressVO> addressInfoList = ezAddressService.getFilterAddressSearchList(userInfo.getTenantId(), folderID, ownerIds, "", pFilter, count, start, addressType);
            
            StringBuilder sb = new StringBuilder();
            sb.append("<LISTVIEWDATA><ROWS>");
            for (AddressVO addressInfo : addressInfoList) {
            	sb.append("<ROW>");
            	sb.append("<STYPE>" + (addressInfo.getsType() == null ? "" : addressInfo.getsType()) + "</STYPE>");
            	sb.append("<ADDRESSID>" + (addressInfo.getAddressId() == null ? "" : addressInfo.getAddressId()) + "</ADDRESSID>");
            	sb.append("<SNAME>" + (addressInfo.getsName() == null ? "" : commonUtil.cleanValue(addressInfo.getsName())) + "</SNAME>");
            	sb.append("<FOLDERTYPE>DB</FOLDERTYPE>");
            	sb.append("<SEMAIL>" + (addressInfo.getsEmail() == null ? "" : commonUtil.cleanValue(addressInfo.getsEmail())) + "</SEMAIL>");
            	sb.append("<SCOMPANY>" + (addressInfo.getsCompany() == null ? "" : commonUtil.cleanValue(addressInfo.getsCompany())) + "</SCOMPANY>");
            	sb.append("<SDEPT>" + (addressInfo.getsDept() == null ? "" : commonUtil.cleanValue(addressInfo.getsDept())) + "</SDEPT>");
            	sb.append("<STITLE>" + (addressInfo.getsTitle() == null ? "" : commonUtil.cleanValue(addressInfo.getsTitle())) + "</STITLE>");
            	sb.append("<SCOMPANYPHONE>" + (addressInfo.getsCompanyPhone() == null ? "" : commonUtil.cleanValue(addressInfo.getsCompanyPhone())) + "</SCOMPANYPHONE>");
            	sb.append("<SMOBILE>" + (addressInfo.getsMobile() == null ? "" : commonUtil.cleanValue(addressInfo.getsMobile())) + "</SMOBILE>");
            	sb.append("</ROW>");
            }
            sb.append("</ROWS></LISTVIEWDATA>");
            returnValue = sb.toString();
        } catch (Exception e) {
        	logger.error(e.getMessage(), e);
        	
        	returnValue = "EXCEPTION";
        }
        
        logger.debug("getFilterAddressSearch ended");
        
        return returnValue;
    }
	
	private String convertDownloadInlineImageURLtoCid(String htmlStr, String downloadInlineUri) {
		downloadInlineUri = downloadInlineUri.replace(".", "\\.");
		String regex = "src=\"" + downloadInlineUri + ".*?contentId=%3C(.*?)%3E.*?\"";				
		Pattern pat = Pattern.compile(regex, Pattern.CASE_INSENSITIVE | Pattern.DOTALL);
		Matcher mat = pat.matcher(htmlStr);
				
		StringBuffer result = new StringBuffer();
		while (mat.find()) {
			String cid = mat.group(1);
			try {
				cid = URLDecoder.decode(cid, "UTF-8");
			} catch (UnsupportedEncodingException e) {
				logger.error(e.getMessage(), e);
			}
			mat.appendReplacement(result, Matcher.quoteReplacement("src=\"cid:" + cid + "\""));
		}
		mat.appendTail(result);
		
		return result.toString();	
	}
	
	private void removeUnusedInlineImagePart(Multipart relatedPart) {
		try {
			String htmlStr = relatedPart.getBodyPart(0).getContent().toString();
			int count = relatedPart.getCount() - 1;
			
			for (int i = count; i >= 1; i--) {
				MimeBodyPart bp = (MimeBodyPart)relatedPart.getBodyPart(i);
				
				if (bp.getDisposition() != null) {
					String contentID = bp.getContentID();
					
					if (contentID != null && contentID.length() > 2) {
						contentID = contentID.substring(1, contentID.length() - 1);
						if (htmlStr.indexOf("src=\"cid:" + contentID) < 0) {
							logger.debug("this inline image isn't used. contentID=" + contentID);
							relatedPart.removeBodyPart(i);
						}
					}
				}
			}
		} catch (IOException e) {
			logger.error(e.getMessage(), e);
		} catch (MessagingException e) {
			logger.error(e.getMessage(), e);
		}
	}
	
	private String getReceiverHTML(String name, String address){
		return "<span style='cursor:pointer' title='" + (address==null?"":EgovStringUtil.getSpclStrCnvr(address)) + "' onclick='show_personinfo(\"" + address + "\")'>" + (name==null?"":EgovStringUtil.getSpclStrCnvr(name)) + "</span>";
	}
	
	private String getMobileReceiverHTML(String name, String address){
		return "<span style='display:inline-block' title='" + (address==null?"":EgovStringUtil.getSpclStrCnvr(address)) + "'>" + (name==null?"":EgovStringUtil.getSpclStrCnvr(name)) + "</span>";
	}
		
	public class CountOutputStream extends OutputStream {
	    int size;
		
	    public int getSize() {
	    	return size;
	    }
	    
	    @Override
	    public void write(byte[] b, int off, int len) {
	    	size += len;
	    }

	    @Override
	    public void write(int b) {
	    	size += 1;
	    }

	    @Override
	    public void write(byte[] b) throws IOException {
	    	size += b.length;
	    }
	}
	
	/**
     * 첨부파일을 서버에 저장한다.
     *
     * @param stordFilePath
     * @param newName
     * @param stordFilePath
     * @throws Exception
     */
    public void mobileMailWriteUploadedFile(String bytearray, String newName, String stordFilePath) throws Exception {
    	logger.debug("mobileMailWriteUploadedFile");
    	
		InputStream stream = null;
		OutputStream bos = null;
		String stordFilePathReal = (stordFilePath == null ? "" : stordFilePath);
		
		try {
//		    stream = file.getInputStream();
		    File cFile = new File(stordFilePathReal);
	
		    if (!cFile.isDirectory()) {
				boolean _flag = cFile.mkdirs();
				
				if (!_flag) {
				    throw new IOException("Directory creation Failed ");
				}
		    }
	
		    bos = new FileOutputStream(stordFilePathReal + File.separator + newName);
		    
		    logger.debug("###" + stordFilePathReal + File.separator + newName + "###");
		    
		    Decoder decoder = Base64.getDecoder();
		    bos.write(decoder.decode(bytearray));
		} catch (FileNotFoundException fnfe) {
			logger.debug("fnfe: {}", fnfe);
		} catch (IOException ioe) {
			logger.debug("ioe: {}", ioe);
		} catch (Exception e) {
			logger.debug("e: {}", e);
		} finally {
		    if (bos != null) {
				try {
				    bos.close();
				} catch (Exception ignore) {
					logger.debug("IGNORED: {}", ignore.getMessage());
				}
		    }
		    
		    if (stream != null) {
				try {
				    stream.close();
				} catch (Exception ignore) {
					logger.debug("IGNORED: {}", ignore.getMessage());
				}
		    }
		}
    }
	
    /**
	 * 주소록 최상위 폴더 호출
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezemail/users/{userId:.+}/addressTopFolder", method=RequestMethod.GET, produces="application/json;charset=utf-8")
	public Object getAddressTopFolder(HttpServletRequest request, @PathVariable String userId) {		
		logger.debug("MOBILE G/W MAIL getAddressTopFolder started.");
		logger.debug("userId=" + userId);
		
		JSONObject result = new JSONObject();
		JSONArray jsonList = new JSONArray();
        try {
        	String serverName = request.getHeader("x-user-host");
    		MCommonVO info = mOptionService.commonInfo(serverName, userId);
    		String ld = commonUtil.getTwoLetterLangFromLangNum(info.getLang());
			Locale locale = new Locale(ld);	
        	
        	Map<String, String> map = ezAddressService.getTopFolderSubCount(info.getTenantId(), info.getUserId(), info.getDeptId(), info.getCompanyId());
        	
        	JSONObject folderInfo = null;
        	
            for( Map.Entry<String, String> entry : map.entrySet() ) {
            	folderInfo = new JSONObject();
                String key = entry.getKey();
                String subFolderCount = entry.getValue();
                String addressName = "";
                int rowNum = 0;
                if(key.equalsIgnoreCase("P"))
                {
                	addressName = egovMessageSource.getMessage("ezAddress.t145", locale);
                	rowNum = 1;
                }
                else if(key.equalsIgnoreCase("D"))
                {
                	addressName = egovMessageSource.getMessage("ezAddress.t146", locale);
                	rowNum = 2;
                }
                else if(key.equalsIgnoreCase("C"))
                {
                	addressName = egovMessageSource.getMessage("ezAddress.t147", locale);
                	rowNum = 3;
                }
                folderInfo.put("addressFolderID", "0");
                folderInfo.put("topFolderID", key);
                folderInfo.put("subFolderCount", subFolderCount);
                folderInfo.put("addressFolderName", addressName);
                folderInfo.put("rowNum", rowNum);
                jsonList.add(folderInfo);
            }
            
            // jgw-server에서 map에 담겨져 리턴이 되다보니 순서가 무의미 해져, 따로 개인 > 부서 > 회사 순으로 정렬
            Collections.sort(jsonList, new Comparator<JSONObject>() {
                @Override
                public int compare(JSONObject jsonObjectA, JSONObject jsonObjectB) {
                    int compare = 0;
                    try
                    {
                        int keyA = (int) jsonObjectA.get("rowNum");
                        int keyB = (int) jsonObjectB.get("rowNum");
                        compare = Integer.compare(keyA, keyB);
                    }
                    catch(JsonException e)
                    {
                        logger.error(e.getMessage(), e);
                    }
                    return compare;
                }
            });
            result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", jsonList);	

		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", "");	
		
		}
        
		logger.debug("MOBILE G/W MAIL getAddressTopFolder ended.");
		
		return result;
	}
	
	/**
	 * 주소록 하위 폴더 호출
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezemail/users/{userId:.+}/addressSubFolder", method=RequestMethod.GET, produces="application/json;charset=utf-8")
	public Object getAddressSubFolder(HttpServletRequest request, @PathVariable String userId) {		
		logger.debug("MOBILE G/W MAIL getAddressSubFolder started.");
		logger.debug("userId=" + userId);
		
		JSONObject result = new JSONObject();
		JSONArray jsonList = new JSONArray();
        try {
        	String serverName = request.getHeader("x-user-host");
    		MCommonVO info = mOptionService.commonInfo(serverName, userId);
			String rootFolderID= request.getParameter("rootFolderID");
			String topFolderID= request.getParameter("topFolderID");
			String pOwnerID = "";

			if("P".equalsIgnoreCase(topFolderID))
			{
				pOwnerID = info.getUserId();
			}
			else if("D".equalsIgnoreCase(topFolderID))
			{
				pOwnerID = info.getDeptId();
			}
			else if("C".equalsIgnoreCase(topFolderID))
			{
				pOwnerID = info.getCompanyId();
			}
			else
			{
				
			}
			
			List<AddressFolderVO> subFolderInfo = ezAddressService.getSubTreeInfo(info.getTenantId(), rootFolderID, pOwnerID);
        	
        	JSONObject folderInfo = null;
        	for (AddressFolderVO vo : subFolderInfo){
        		folderInfo = new JSONObject();
        		folderInfo.put("addressFolderID", vo.getFolderId());
                folderInfo.put("subFolderCount", vo.getChildCount());
                folderInfo.put("addressFolderName", vo.getFolderName());
                jsonList.add(folderInfo);
        	}
            
            result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", jsonList);	

		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");	
		}
        
		logger.debug("MOBILE G/W MAIL getAddressSubFolder ended.");
		
		return result;
	}
	
	/**
	 * 주소록 상위 폴더 호출
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezemail/users/{userId:.+}/addressHighFolder", method=RequestMethod.GET, produces="application/json;charset=utf-8")
	public Object getAddressHighFolder(HttpServletRequest request, @PathVariable String userId) {		
		logger.debug("MOBILE G/W MAIL getAddressHighFolder started.");
		logger.debug("userId=" + userId);
		
		JSONObject result = new JSONObject();
		JSONArray jsonList = new JSONArray();
        try {
        	String serverName = request.getHeader("x-user-host");
    		MCommonVO info = mOptionService.commonInfo(serverName, userId);
			String folderID = request.getParameter("folderID");
			String topFolderID = request.getParameter("topFolderID");
			String pOwnerID = "";
			
			if("P".equalsIgnoreCase(topFolderID))
			{
				pOwnerID = info.getUserId();
			}
			else if("D".equalsIgnoreCase(topFolderID))
			{
				pOwnerID = info.getDeptId();
			}
			else if("C".equalsIgnoreCase(topFolderID))
			{
				pOwnerID = info.getCompanyId();
			}
			else
			{
				
			}
			
			List<AddressFolderVO> highFolderInfo = ezAddressService.getHighTreeInfo(info.getTenantId(), folderID, pOwnerID);
        	
        	JSONObject folderInfo = null;
        	for (AddressFolderVO vo : highFolderInfo){
        		folderInfo = new JSONObject();
        		folderInfo.put("addressFolderID", vo.getFolderId());
                folderInfo.put("subFolderCount", vo.getChildCount());
                folderInfo.put("addressFolderName", vo.getFolderName());
                folderInfo.put("level", vo.getLevel());
                folderInfo.put("parentFolderID", vo.getParentId());
                jsonList.add(folderInfo);
        	}
            
            result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", jsonList);	

		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");	
		
		}
        
		logger.debug("MOBILE G/W MAIL getAddressHighFolder ended.");
		
		return result;
	}
	
	/**
	 * 주소록 하위 폴더 호출
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezemail/users/{userId:.+}/addressLowFolder", method=RequestMethod.GET, produces="application/json;charset=utf-8")
	public Object getAddressLowFolder(HttpServletRequest request, @PathVariable String userId) {		
		logger.debug("MOBILE G/W MAIL getAddressLowFolder started.");
		logger.debug("userId=" + userId);
		
		JSONObject result = new JSONObject();
		JSONArray jsonList = new JSONArray();
        try {
        	String serverName = request.getHeader("x-user-host");
    		MCommonVO info = mOptionService.commonInfo(serverName, userId);
			String folderID= request.getParameter("folderID");
			String topFolderID = request.getParameter("topFolderID");
			String pOwnerID = "";
			
			if("P".equalsIgnoreCase(topFolderID))
			{
				pOwnerID = info.getUserId();
			}
			else if("D".equalsIgnoreCase(topFolderID))
			{
				pOwnerID = info.getDeptId();
			}
			else if("C".equalsIgnoreCase(topFolderID))
			{
				pOwnerID = info.getCompanyId();
			}
			else
			{
				
			}
			
			List<AddressFolderVO> highFolderInfo = ezAddressService.getLowTreeInfo(info.getTenantId(), folderID, pOwnerID);
        	
        	JSONObject folderInfo = null;
        	for (AddressFolderVO vo : highFolderInfo){
        		folderInfo = new JSONObject();
        		folderInfo.put("addressFolderID", vo.getFolderId());
                folderInfo.put("subFolderCount", vo.getChildCount());
                folderInfo.put("addressFolderName", vo.getFolderName());
                folderInfo.put("level", vo.getLevel());
                folderInfo.put("parentFolderID", vo.getParentId());
                jsonList.add(folderInfo);
        	}
            
            result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", jsonList);	

		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");	
		
		}
        
		logger.debug("MOBILE G/W MAIL getAddressLowFolder ended.");
		
		return result;
	}
	
	/**
	 * 주소록 해당 폴더의 리스트 호출
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezemail/users/{userId:.+}/subAddressbook", method= RequestMethod.POST,  produces="application/json;charset=utf-8")
	public Object subAddressbook(HttpServletRequest request, @PathVariable String userId, @RequestBody JSONObject jsonObject) {		
		logger.debug("MOBILE G/W MAIL subAddressbook started.");
		logger.debug("userId=" + userId + ",jsonObject=" + jsonObject);
		
        String addressXML = "";
		
        JSONObject data = new JSONObject();
        JSONObject result = new JSONObject();
		
        try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
									
			String searchTarget = "";
			String filterName = "";
			String filterValue = "";
			String folderID = "";
			int start = 0;
			int end = 99;
			
			if (jsonObject.get("searchTarget") != null) {
				searchTarget = (String)jsonObject.get("searchTarget");
			}
			
			if (jsonObject.get("filterName") != null) {
				filterName = (String)jsonObject.get("filterName");
			}

			if (jsonObject.get("filterValue") != null) {
				filterValue = (String)jsonObject.get("filterValue");
			}
			
			if (jsonObject.get("folderID") != null) {
				folderID =  (String)jsonObject.get("folderID");
			}
			
			if (jsonObject.get("start") != null) {
				start =  ((Integer)jsonObject.get("start")).intValue();
			}

			if (jsonObject.get("end") != null) {
				end =  ((Integer)jsonObject.get("end")).intValue();
			}
			
			int[] searchCount = {0, 0};
			
			if (!filterName.isEmpty()) {
				addressXML = getAddressSearch(searchTarget, filterName, filterValue, info,
						start, end - start + 1, searchCount, folderID);	
			}
			
	        data.put("addressXML", addressXML);
	        data.put("fullCount", searchCount[0]);	        
	        data.put("optionCount", searchCount[1]);
	        
	        result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", data);			
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "fail");			
		}
        
		logger.debug("MOBILE G/W MAIL subAddressbook ended.");
		
		return result;
	}
	
	/**
	 * 주소록 해당 폴더의 리스트 호출
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezemail/users/{userId:.+}/filterAddressbook", method= RequestMethod.POST,  produces="application/json;charset=utf-8")
	public Object filterAddressbook(HttpServletRequest request, @PathVariable String userId, @RequestBody JSONObject jsonObject) {		
		logger.debug("MOBILE G/W MAIL filterAddressbook started.");
		logger.debug("userId=" + userId + ",jsonObject=" + jsonObject);
		
        String addressXML = "";
		
        JSONObject data = new JSONObject();
        JSONObject result = new JSONObject();
		
        try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
									
			String searchTarget = "";
			String filterName = "";
			String filterValue = "";
			String folderID = "";
			String addressType = "";
			int start = 0;
			int end = 99;
			
			if (jsonObject.get("searchTarget") != null) {
				searchTarget = (String)jsonObject.get("searchTarget");
			}
			
			if (jsonObject.get("filterName") != null) {
				filterName = (String)jsonObject.get("filterName");
			}

			if (jsonObject.get("filterValue") != null) {
				filterValue = (String)jsonObject.get("filterValue");
			}
			
			if (jsonObject.get("folderID") != null) {
				folderID =  (String)jsonObject.get("folderID");
			}
			
			if (jsonObject.get("start") != null) {
				start =  ((Integer)jsonObject.get("start")).intValue();
			}

			if (jsonObject.get("end") != null) {
				end =  ((Integer)jsonObject.get("end")).intValue();
			}
			
			if (jsonObject.get("addressType") != null) {
				addressType =  (String)jsonObject.get("addressType");
			}
			
			int[] searchCount = {0, 0};
			
			if (!filterName.isEmpty()) {
				addressXML = getFilterAddressSearch(searchTarget, filterName, filterValue, info,
						start, end - start + 1, searchCount, folderID, addressType);	
			}
			
	        data.put("addressXML", addressXML);
	        data.put("fullCount", searchCount[0]);	        
	        data.put("optionCount", searchCount[1]);
	        
	        result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", data);			
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "fail");			
		}
        
		logger.debug("MOBILE G/W MAIL filterAddressbook ended.");
		
		return result;
	}
	
	/**
	 * 수신자 자동완성 기능
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezemail/autoCompleteList/users/{userId:.+}", method= RequestMethod.POST,  produces="application/json;charset=utf-8")
	public Object autoCompleteList(HttpServletRequest request, @PathVariable String userId, @RequestBody JSONObject requestJsonObject) {		
		logger.debug("MOBILE G/W MAIL autoCompleteList started.");
		logger.debug("userId=" + userId + ",jsonObject=" + requestJsonObject);

        JSONObject data = new JSONObject();
        JSONObject result = new JSONObject();
        String searchValue = (String)requestJsonObject.get("searchValue");
        String pOrganSearchList = "displayname::" + searchValue + ";;mail::" + searchValue;
		String pOrganCellList = "displayname";
		String pOrganPropList = "company;description;title;mail;extensionAttribute3;displayName2";
		String pOrganListType = "all";
		String pDLSearchList = "displayname::" + searchValue;
		String pAddressFilter = searchValue;
        try {
        	String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			String ld = commonUtil.getTwoLetterLangFromLangNum(info.getLang());
			Locale locale = new Locale(ld);
			
        	Document organXML = commonUtil.convertStringToDocument(
					getOrganSearch(pOrganSearchList, pOrganCellList, pOrganPropList, pOrganListType, info));
			Document dlXML = commonUtil.convertStringToDocument(getOrganDLSearch(pDLSearchList, info));
			Document addressXML = commonUtil.convertStringToDocument(getAddressSearchInfo(pAddressFilter, info));

			HashMap<String, Object> jsonObject = null;
			List<Object> jsonList = new ArrayList<Object>();

			NodeList organRow = organXML.getElementsByTagName("ROW");
			for (int i = 0; i < organRow.getLength(); i++) {
				Element row = (Element) organRow.item(i);
				NodeList organList = row.getElementsByTagName("CELL");
				Element organCell = (Element) organList.item(0);
				if (organCell.getElementsByTagName("DATA6").item(0) != null 
						&& !organCell.getElementsByTagName("DATA6").item(0).getTextContent().trim().equals("")) {
					jsonObject = new HashMap<String, Object>();
					jsonObject.put("name", organCell.getElementsByTagName("VALUE").item(0).getTextContent());
					jsonObject.put("title", organCell.getElementsByTagName("DATA5").item(0).getTextContent());
					jsonObject.put("description", organCell.getElementsByTagName("DATA4").item(0).getTextContent());
					jsonObject.put("mail", organCell.getElementsByTagName("DATA6").item(0).getTextContent());
					jsonObject.put("type", "");
					jsonObject.put("href", "");
					jsonList.add(jsonObject);
				}
			}

			NodeList dlRow = dlXML.getElementsByTagName("ROW");
			for (int i = 0; i < dlRow.getLength(); i++) {
				Element row = (Element) dlRow.item(i);
				NodeList dlList = row.getElementsByTagName("CELL");
				Element dlCell = (Element) dlList.item(0);
				if (dlCell.getElementsByTagName("DATA3").item(0) != null 
						&& !dlCell.getElementsByTagName("DATA3").item(0).getTextContent().trim().equals("")) {
					jsonObject = new HashMap<String, Object>();
					jsonObject.put("name", dlCell.getElementsByTagName("VALUE").item(0).getTextContent());
					jsonObject.put("title", "");
					jsonObject.put("description", egovMessageSource.getMessage("ezEmail.t593", locale));
					jsonObject.put("mail", dlCell.getElementsByTagName("DATA3").item(0).getTextContent());
					jsonObject.put("type", "");
					jsonObject.put("href", "");
					jsonList.add(jsonObject);
				}
			}

			NodeList addressRow = addressXML.getElementsByTagName("ROW");
			for (int i = 0; i < addressRow.getLength(); i++) {
				Element row = (Element) addressRow.item(i);
				if(row.getElementsByTagName("SEMAIL").item(0) != null
						&& !row.getElementsByTagName("SEMAIL").item(0).getTextContent().trim().equals("")){
					jsonObject = new HashMap<String, Object>();
					jsonObject.put("name", row.getElementsByTagName("SNAME").item(0).getTextContent());
					jsonObject.put("title", "");
					jsonObject.put("description", egovMessageSource.getMessage("ezEmail.t99000041", locale));
					jsonObject.put("mail", row.getElementsByTagName("SEMAIL").item(0).getTextContent());
					jsonObject.put("type", row.getElementsByTagName("STYPE").item(0).getTextContent());
					jsonObject.put("href", row.getElementsByTagName("ADDRESSID").item(0).getTextContent() + "|!|" + row.getElementsByTagName("STYPE").item(0).getTextContent());
					jsonList.add(jsonObject);
				}
			}
	        data.put("susinList", jsonList);
	        
	        result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", data);			
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "fail");			
		}
        
		logger.debug("MOBILE G/W MAIL autoCompleteList ended.");
		
		return result;
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/mobile/ezemail/recpCheck/{messageId}/users/{userId:.+}",
                    method = RequestMethod.POST,
                    produces = "application/json;charset=utf-8")
    public Object recpCheckMail(HttpServletRequest request,
                                @RequestBody JSONObject getData,
                                @PathVariable String messageId,
                                @PathVariable String userId) {
	    logger.debug("MOBILE G/W MAIL recpCheckMail started.");
        logger.debug("userId=" + userId + "getData=" + getData);

        JSONObject returnObj = new JSONObject();
        IMAPAccess ia = null;

        try {
            JSONArray dataArray = new JSONArray();

            String serverName = request.getHeader("x-user-host");
            MCommonVO userInfo = mOptionService.commonInfo(serverName, userId);
            String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
            String userEmail = userInfo.getUserId() + "@" + domainName;
            String mailId = userInfo.getUserId();
            String password = jspw;
            String lang = commonUtil.getTwoLetterLangFromLangNum(userInfo.getLang());
            Locale locale = new Locale(lang);
            Long uid = Long.parseLong(messageId);

            String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", userInfo.getTenantId());
			String isReadDelete = ezCommonService.getTenantConfig("IS_READ_DELETE", userInfo.getTenantId());

            if (useSharedMailbox.equals("YES")) {
                String shareId = (String) getData.get("shareId");
                logger.debug("shareId=" + shareId + ", userId=" + userId + ", userInfo.getUserId=" + userInfo.getUserId());

                if (shareId != null && !shareId.equals("")) {
                    if (!ezEmailService.checkUserShareId(userInfo.getUserId(), shareId, 2, userInfo.getTenantId())) {
                        logger.debug("the user cannot access the shareId.");
                        logger.debug("mailGetReceiveList ended.");

                        return "";
                    }

                    mailId = shareId;
                    userEmail = shareId + "@" + domainName;
                }
            }

            logger.debug("userEmail=" + userEmail + ", uid=" + uid);

            ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
                    userEmail, password, egovMessageSource, locale, ezEmailUtil);
			if (ia == null){
				throw new Exception("ia is null");
			}
            Folder f = ia.getFolder(ezEmailUtil.getSentFolderId(locale));
            f.open(Folder.READ_ONLY);
            Message message = ((IMAPFolder)f).getMessageByUID(uid);

            if (message == null) {
                logger.debug("message not found. uid=" + uid);

                returnObj.put("data", "");
                returnObj.put("status", "ok");
                returnObj.put("code", 2);
            } else {

                String mimeMassageId = ((MimeMessage)message).getMessageID() == null ?
                                                "" : ((MimeMessage)message).getMessageID();
                logger.debug("mimeMessageId=" + mimeMassageId);

                // get readList(수신확인)
                List<MailReadVO> readList = ezEmailService.getMailReadList(userInfo.getTenantId(), mailId, mimeMassageId);

                // get cancelList(회수)
                List<MailCancelVO> cancelList = ezEmailService.getMailCancelList(mimeMassageId);

                // get all recipients from email message
                Address[] addresses = message.getAllRecipients();

                // get aliasAddressMap from addresses and readList
                List<String> addressList = new ArrayList<String>();

                for (Address address : addresses) {
                    if (((InternetAddress)address).getAddress() != null) {
                        addressList.add(((InternetAddress)address).getAddress());
                    }
                }

                for (MailReadVO mailReadObj : readList) {
                    addressList.add(mailReadObj.getReaderEmail());
                }

                Map<String, String> aliasAddressMap = ezEmailService.getAliasAddressMap(addressList, userInfo.getTenantId());

                // 이미 처리한 메일 주소 리스트
                List<String> tempMailList = new ArrayList<String>();

                // recipients from mail message
                for (Address address : addresses) {
                    String email = ((InternetAddress)address).getAddress();
                    String name = ((InternetAddress)address).getPersonal() == null ?
                            ((InternetAddress)address).getAddress() : ((InternetAddress)address).getPersonal();

                    if (email != null) {
                        JSONObject recpJson = new JSONObject();

                        recpJson.put("email", email);
                        recpJson.put("name", name);

                        if (aliasAddressMap.containsKey(email)) {
                            email = aliasAddressMap.get(email);
                        }

                        String readDate = "unread";

                        for (MailReadVO vo : readList) {

                            if (aliasAddressMap.containsKey(vo.getReaderEmail())) {

                                if (aliasAddressMap.get(vo.getReaderEmail()).equalsIgnoreCase(email)) {
                                    readDate = commonUtil.getDateStringInUTC(vo.getReadDate(), userInfo.getOffSet(), false);
                                    break;
                                }
                            } else {

                                if (vo.getReaderEmail().equalsIgnoreCase(email)) {
                                    readDate = commonUtil.getDateStringInUTC(vo.getReadDate(), userInfo.getOffSet(), false);
                                    break;
                                }
                            }
                        }

                        recpJson.put("date", readDate);

                        String status = "";

                        for (MailCancelVO vo : cancelList) {

                            if (vo.getReaderEmail().equalsIgnoreCase(email)) {

                                if (vo.getStatus() != null && !vo.getStatus().equalsIgnoreCase("")) {
                                    status = vo.getStatus();
                                } else {
                                    status = "0";
                                }

                                break;
                            }
                        }

                        recpJson.put("cancel", status);
                        // 중복제거를 위한 처리한 메일주소들을 담는다.
                        tempMailList.add(email);
                        dataArray.add(recpJson);
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
                        JSONObject recpJson = new JSONObject();

                        String readerEmail = vo.getReaderEmail();
                        String readerName = vo.getReaderName();

                        recpJson.put("email", readerEmail);
                        recpJson.put("name", readerName);
                        vo.setReadDate(commonUtil.getDateStringInUTC(vo.getReadDate(), userInfo.getOffSet(), false));
                        recpJson.put("date", vo.getReadDate());

                        String status = "";

                        for (MailCancelVO mailCancelVO : cancelList) {

                            if (mailCancelVO.getReaderEmail().equalsIgnoreCase(realEmailAddress)) {

                                if (mailCancelVO.getStatus() != null && !mailCancelVO.getStatus().equals("")) {
                                    status = mailCancelVO.getStatus();
                                } else {
                                    status = "0";
                                }

                                break;
                            }
                        }

                        recpJson.put("cancel", status);
                        tempMailList.add(realEmailAddress);
                        dataArray.add(recpJson);
                    }
                }

                String companyDomainName = ezCommonService.getCompanyConfig(userInfo.getTenantId(), userInfo.getCompanyId(), "DomainName");

                // cancelList
                for (MailCancelVO vo : cancelList) {

                    if (!tempMailList.contains(vo.getReaderEmail())) {
                        JSONObject recpJson = new JSONObject();
                        String readerEmail = vo.getReaderEmail();
                        String readerName = vo.getReaderName() == null ? readerEmail : vo.getReaderName();
						String primaryEmail = vo.getPrimaryEmail();
                        String status = "";
						
                        if (vo.getStatus() != null && !vo.getStatus().equals("")) {
                            status = vo.getStatus();
                        } else {
                            status = "0";
                        }

                        logger.debug("canceled email readerEmail=" + readerEmail);

                        // 회사별 이메일 도메인명이 설정되어 있으면 Account 이메일 주소 대신에 Primary 이메일 주소로 표시한다.
						if (!companyDomainName.isEmpty()) {
							if (primaryEmail != null && !primaryEmail.isEmpty()) {
								readerEmail = primaryEmail;
							}
						}

                        recpJson.put("email", readerEmail);
                        recpJson.put("name", readerName);
                        recpJson.put("date", "unread");
                        recpJson.put("cancel", status);

                        dataArray.add(recpJson);
                    }
                }

                returnObj.put("isReadDelete", isReadDelete);
                returnObj.put("subject", message.getSubject());
                returnObj.put("data", dataArray);
                returnObj.put("status", "ok");
                returnObj.put("code", 0);
            }

            f.close(true);

        } catch (Exception e) {
            logger.error(e.getMessage(), e);

            returnObj.put("data", "fail");
            returnObj.put("status", "error");
            returnObj.put("code", 1);
        } finally {
            if (ia != null) {
                ia.close();
            }
        }

        logger.debug("returnValue=" + returnObj.toJSONString());
	    logger.debug("MOBILE G/W MAIL recpCheckMail ended.");

	    return returnObj;
    }

	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/mobile/ezemail/mailCancel/{messageId}/users/{userId:.+}",
			method = RequestMethod.POST,
			produces = "application/json;charset=utf-8")
	public Object mMailCancel(HttpServletRequest request,
								@RequestBody JSONObject getData,
								@PathVariable String messageId,
								@PathVariable String userId) {
		logger.debug("MOBILE G/W MAIL mMailCancel started.");
		
		logger.debug("userId=" + userId + "getData=" + getData);
		logger.debug("messageId=" + messageId);
		
		JSONObject returnObj = new JSONObject();
		IMAPAccess ia = null;
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO userInfo = mOptionService.commonInfo(serverName, userId);
			String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
			String userEmail = userInfo.getUserId() + "@" + domainName;
			String mailId = userInfo.getUserId();
			String password = jspw;
			String lang = commonUtil.getTwoLetterLangFromLangNum(userInfo.getLang());
			Locale locale = new Locale(lang);
			Long uid = Long.parseLong(messageId);
			String pGubun = (String) getData.get("pGubun");
			
			List<String> cancelMailAddress = (List<String>) getData.get("cancelMailAddress");
			
			logger.debug("cancelMailAddress : " + cancelMailAddress);
			
			String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", userInfo.getTenantId());
			String isReadDelete = ezCommonService.getTenantConfig("IS_READ_DELETE", userInfo.getTenantId());

			if (useSharedMailbox.equals("YES")) {
				String shareId = (String) getData.get("shareId");
				logger.debug("shareId=" + shareId + ", userId=" + userId + ", userInfo.getUserId=" + userInfo.getUserId());

				if (shareId != null && !shareId.equals("")) {
					if (!ezEmailService.checkUserShareId(userInfo.getUserId(), shareId, 2, userInfo.getTenantId())) {
						logger.debug("the user cannot access the shareId.");
						logger.debug("mailGetReceiveList ended.");

						returnObj.put("status", "fail");
						returnObj.put("code", 1);

						return returnObj;
					}

					mailId = shareId;
					userEmail = shareId + "@" + domainName;
				}
			}

			logger.debug("userEmail=" + userEmail + ", uid=" + uid);

			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userEmail, password, egovMessageSource, locale, ezEmailUtil);
			
			if (ia == null) {
				throw new Exception("ia is null");
			}
			Folder f = ia.getFolder(ezEmailUtil.getSentFolderId(locale));
			
			if(f == null) {
				throw new Exception("folder is null");
			}
			f.open(Folder.READ_ONLY);
			Message message = ((IMAPFolder) f).getMessageByUID(uid);
			
			if (message == null) {
				logger.debug(egovMessageSource.getMessage("ezEmail.lhm24", locale));
				logger.debug("mailCancelSend ended.");

				returnObj.put("message", egovMessageSource.getMessage("ezEmail.lhm24", locale));
				returnObj.put("status", "error");
				returnObj.put("code", -1);

				return returnObj;
			}
			String from = ((InternetAddress)message.getFrom()[0]).getAddress();
			logger.debug("from=" + from);

			List<String[]> aliasAddressList = ezEmailService.getAliasAddress(mailId, userInfo.getTenantId(), "YES", "NO");

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
				
				returnObj.put("message", egovMessageSource.getMessage("ezEmail.lhm24", locale));
				returnObj.put("status", "error");
				returnObj.put("code", -1);

				return returnObj;
			}
			
			// 전체회수인 경우
			if (pGubun.toLowerCase().equals("all") && cancelMailAddress.size() == 0) {
				Address[] addresses = message.getAllRecipients();
				
				for (Address address : addresses) {
					cancelMailAddress.add(((InternetAddress)address).getAddress());
				}
			}
			
			// 내부사용자 확인
			List<String> innerDomainList = ezEmailUtil.getInnerDomain(userInfo.getTenantId());
			List<String> innerAddresses = new ArrayList<String>();

			for (String address : cancelMailAddress) {
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
				
				returnObj.put("message", egovMessageSource.getMessage("ezEmail.lhm27", locale));
				returnObj.put("status", "error");
				returnObj.put("code", -1);

				return returnObj;
			}
	
			String pEachCancel = !pGubun.toLowerCase().equals("all") ? "EACH" : "ALL";
			
			ezEmailUserAdminService.setMailCancelSend(userInfo.getTenantId(), userInfo.getPrimary(), ((MimeMessage)message).getMessageID(), mailId, message.getSubject(), innerAddresses, locale, pEachCancel);
			
			f.close(true);
			returnObj.put("message", "success");
			returnObj.put("status", "ok");
			returnObj.put("code", 0);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			returnObj.put("status", "fail");
			returnObj.put("code", 1);
		} finally {
			if (ia != null) {
				ia.close();
			}
		}
		
		logger.debug("MOBILE G/W MAIL mMailCancel ended.");
		
		return returnObj;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/mobile/ezemail/sign/users/{userId:.+}",
			method = RequestMethod.GET,
			produces = "application/json;charset=utf-8")
	public JSONObject getUserSignatureList(HttpServletRequest request, @PathVariable String userId) {
		logger.debug("MOBILE G/W MAIL getUserSignatureList started.");
		logger.debug("uesrId={}", userId);

		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO userInfo = mOptionService.commonInfo(serverName, userId);

			MailSignatureVO mailSignature = ezEmailService.getMailSignature(userInfo.getTenantId(), userInfo.getUserId());

			// fileroot를 모바일 다운로드 URL로 변경
			if (mailSignature != null) {
				mailSignature.setContent1(convertFilerootToMobileDownloadURL(mailSignature.getContent1()));
				mailSignature.setContent2(convertFilerootToMobileDownloadURL(mailSignature.getContent2()));
				mailSignature.setContent3(convertFilerootToMobileDownloadURL(mailSignature.getContent3()));
			}

			result.put("data", mailSignature);
			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);

			result.put("data", "fail");
			result.put("status", "error");
			result.put("code", 1);
		}

		logger.debug("MOBILE G/W MAIL getUserSignatureList ended.");

		return result;
	}

	/** 
	 * 승인메일 : 정책 체크
	 * @param userId
	 * @param hasAttach(첨부파일 유무) : true or false
	 * @param msgTo : ex) "김" <kim@jtest01.ktbizoffice.com>, "김수아" <tndk19@jtest01.ktbizoffice.com> 형태
	 * @param msgCC
	 * @param msgBCC
	 * @param shareId : 공유사서함 아이디 (공유사서함 계정이라면)
	 * @return data: OK:조건에 걸리지 않음, ALL_HANDS:전사메일 조건에 걸림, EXTERNAL:외부발송메일, EXTERNAL_ATTACH:외부발송메일_첨부파일, INNER:내부발송메일, INNER_ATTACH:내부발송메일_첨부파일
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/mobile/ezemail/appr/checkApprPolicy/{userId:.+}",
			method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject checkApprPolicy(HttpServletRequest request, @PathVariable String userId, @RequestBody JSONObject jsonObject) {
		logger.debug("MOBILE G/W MAIL checkApprPolicy started.");
		logger.debug("uesrId={}", userId);

		JSONObject result = new JSONObject();
		String returnStr = "OK";  // OK, ALL_HANDS:전사메일, EXTERNAL:외부발송메일, EXTERNAL_ATTACH:외부발송메일_첨부파일, INNER:내부발송메일, INNER_ATTACH:내부발송메일_첨부파일
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO userInfo = mOptionService.commonInfo(serverName, userId);
			String userCn = userInfo.getUserId();
			String companyId 	= userInfo.getCompanyId();
			int tenantId 		= userInfo.getTenantId();
			logger.debug("userCn={}, companyId={}, tenantId={}", userCn, companyId, tenantId);

			// Parameter ... 
			Boolean hasAttach 	= BooleanUtils.toBoolean((String) jsonObject.get("hasAttach")); 		// 첨부파일 유무
			String msgTo 		= StringUtils.defaultIfBlank((String) jsonObject.get("msgTo"), ""); 	// 받는사람
			String msgCC 		= StringUtils.defaultIfBlank((String) jsonObject.get("msgCC"), ""); 	// 참조
			String msgBCC 		= StringUtils.defaultIfBlank((String) jsonObject.get("msgBCC"), ""); 	// 숨은참조
			String shareId 		= StringUtils.defaultIfBlank((String) jsonObject.get("shareId"), ""); 	// 공유사서함 아이디 (공유사서함 계정이라면)
			logger.debug("hasAttach={}, msgTo={}, msgCC={}, msgBCC={}", hasAttach, msgTo, msgCC, msgBCC);
			
			List<String> msgRecipients = new ArrayList<String>(){{add(msgTo); add(msgCC); add(msgBCC);}};
			String chkUserId = StringUtils.defaultIfEmpty(shareId, userCn);
			logger.debug("chkUserId={}", chkUserId);

			// getPolicy
			String useApprMailAllHands 	= StringUtils.defaultIfBlank(ezCommonService.getCompanyConfig(tenantId, companyId, "useApprMailAllHands"), "UNUSED"); 	// 전사메일 (USAGE|UNUSED)
			String useApprMailOut 		= StringUtils.defaultIfBlank(ezCommonService.getCompanyConfig(tenantId, companyId, "useApprMailOut"), "UNUSED"); 		// 외부로 발송되는 메일 (USAGE|USAGE_ATTACH|UNUSED)
			String useApprMailIn 		= StringUtils.defaultIfBlank(ezCommonService.getCompanyConfig(tenantId, companyId, "useApprMailIn"), "UNUSED"); 		// 내부로 발송되는 메일 (USAGE|USAGE_ATTACH|UNUSED)
			boolean isExceptionUser		= ezEmailService.checkExceptionUser(tenantId, companyId, chkUserId);
			logger.debug("useApprMailAllHands={}, useApprMailIn={}, useApprMailOut={}, isExceptionUser={}"
					, useApprMailAllHands, useApprMailIn, useApprMailOut, isExceptionUser);
			
			// domain
			Set<String> domainSet = new HashSet<String>(); // 수신자 도메인 리스트 
			List<String> recipients = new ArrayList<String>(); // 수신자 리스트
			
			String pattern = "\"?([^\"]*)\"? <([^<>]+)>";
			Pattern r = Pattern.compile(pattern);
			for (String s : msgRecipients) {
				Matcher m = r.matcher(s);
				while (m.find()) {
					String address = m.group(2);
					String domain = address.substring(address.indexOf('@') + 1);
					
					domainSet.add(domain);
					recipients.add(address);
				}
			}
			logger.debug("domainSet={}", domainSet);
			
			// 조건 체크
			boolean policyChk = true;// boolean allHands = true; boolean innerMail = true; boolean outerMail = true;
			/*
			 * 1. 전사메일 발송 시 승인메일 프로세스 사용 여부 확인 후 수신자에 전사메일이 포함 되어있는지 체크
			 * 2. 허용도메인으로 구성되어있는지 체크
			 * 3. 외부메일 발송 시 승인메일 프로세스 사용여부 && 예외자인지 확인 후 외부메일이 포함되어있는지, 전체/첨부파일메일 포함 체크
			 * 4. 내부메일 발송 시 승인메일 프로세스 사용여부 && 예외자인지 확인 후 내부메일이 포함되어있는지, 전체/첨부파일메일 포함 체크
			 */
			do {
				// 전사메일 ----------------------------------------------------------
				if (!"UNUSED".equalsIgnoreCase(useApprMailAllHands)) {
					for (String addr : recipients) {
						if(ezEmailUtil.isCompanyMail(addr, tenantId)) {
							policyChk = false;
							returnStr = "ALL_HANDS";
							logger.debug("useApprMailAllHands policy. addr={}", addr);
							break;
						}
					}
					if (!policyChk) {break; }
				}

				// 허용도메인---------------------------------------------------------
				List<String> allowedDomainList = ezEmailService.getApprAllowedDomainList(tenantId, companyId);
				Set<String> allowedDomainSet = new HashSet<String>(allowedDomainList); // 허용도메인 리스트

				Set<String> domainSetClone = new HashSet<String>(){{addAll(domainSet);}};
				domainSetClone.removeAll(allowedDomainSet); // 수신자도메인과 허용도메인을 차집합
				if (domainSetClone.size() == 0) {
					policyChk = false;
					logger.debug("allowedDomain policy.");
					break;
				}
				
				// 일반메일 ----------------------------------------------------------
				String mailInnerDomain = ezCommonService.getTenantConfig("MailInnerDomain", tenantId);
				Set<String> innerDomainSet = new HashSet<String>(Arrays.asList(mailInnerDomain.split(";"))); // 시스템에서 사용하는 도메인 리스트 (내부도메인)
				logger.debug("innerDomainSet={}", innerDomainSet);
				
				// 외부메일 발송 조건 체크
				if (!"UNUSED".equalsIgnoreCase(useApprMailOut) && !isExceptionUser) {
					Set<String> externalDomain = new HashSet<String>(){{addAll(domainSet);}};
					externalDomain.removeAll(innerDomainSet); // 수신자도메인과 내부도메인을 차집합하여 외부로 발송되는 도메인 추출
					logger.debug("externalDomain={}", externalDomain);
					
					if (externalDomain.size() > 0) {
						if ("USAGE".equalsIgnoreCase(useApprMailOut)) { // 모든 메일인 경우
							policyChk = false;
							returnStr = "EXTERNAL";
						} else if ("USAGE_ATTACH".equalsIgnoreCase(useApprMailOut) && hasAttach) { // 조건이 첨부파일 포함인 메일인 경 우
							policyChk = false;
							returnStr = "EXTERNAL_ATTACH";
						}
						logger.debug("useApprMailOut policy.");
					}
					if (!policyChk) {break; }
				}
				
				// 내부메일 발송 조건 체크
				if (!"UNUSED".equalsIgnoreCase(useApprMailIn) &&  !isExceptionUser) {
					Set<String> innerDomain = new HashSet<String>(){{addAll(domainSet);}};
					innerDomain.retainAll(innerDomainSet); // 수신자도메인과 내부도메인을 교집합하여 내부 도메인 추출
					logger.debug("innerDomain={}", innerDomain);
					
					if (innerDomain.size() > 0) {
						if ("USAGE".equalsIgnoreCase(useApprMailIn)) { // 모든 메일인 경우
							policyChk = false;
							returnStr = "INNER";
						} else if ("USAGE_ATTACH".equalsIgnoreCase(useApprMailIn) && hasAttach) { // 조건이 첨부파일 포함인 메일인 경우
							policyChk = false;
							returnStr = "INNER_ATTACH";
						}
						logger.debug("useApprMailIn policy.");
					}
					if (!policyChk) {break; }
				}
				
				policyChk = false;
			} while (policyChk); // 1번만 도는 while
			
			result.put("data", returnStr);
			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);

			result.put("data", "fail");
			result.put("status", "error");
			result.put("code", 1);
		}

		logger.debug("MOBILE G/W MAIL checkApprPolicy ended.");

		return result;
	}
	
	/**
	 * 승인메일 : 승인자 목록 조회
	 * @param userId
	 * @param (검색일 경우) searchType : displayname(이름), deptname(부서명), title(직위), deptId(부서아이디)
	 * @param (검색일 경우) searchValue : 검색어
	 * @return data: {
	 * 		approverList : 승인자 리스트 (userId, userName, deptId, deptName, title)
	 * 		approverAccount : 부서내 승인자 아이디 (1개)
	 * 		approverCount : 부서내 승인자 개수
	 * }
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value={"/mobile/ezemail/appr/getApproverList/{userId:.+}", "/mobile/ezemail/appr/getApproverListSearch/{userId:.+}"},
			method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject getApproverList(HttpServletRequest request, @PathVariable String userId, @RequestBody JSONObject jsonObject) {
		boolean isSearch = request.getRequestURI().contains("/getApproverListSearch");
		logger.debug("MOBILE G/W MAIL getApproverList started. isSearch={}", isSearch);
		logger.debug("uesrId={}", userId);

		JSONObject result = new JSONObject();
        JSONObject returnData = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO userInfo = mOptionService.commonInfo(serverName, userId);
			String userCn = userInfo.getUserId();
			String companyId 	= userInfo.getCompanyId();
			String deptId 		= userInfo.getDeptId();
			String lang 		= userInfo.getPrimary();
			int tenantId 		= userInfo.getTenantId();
			logger.debug("userCn={}, companyId={}, deptId={}, lang={}, tenantId={}", userCn, companyId, deptId, lang, tenantId);

			List<OrganUserVO> userList = new ArrayList<OrganUserVO>();
			if (isSearch) { // 승인자 검색
				String searchType = StringUtils.defaultIfBlank((String) jsonObject.get("searchType"), "");
				String searchValue = StringUtils.defaultIfBlank((String) jsonObject.get("searchValue"), "");
				
				userList = ezEmailService.getApproverSearchList(tenantId, companyId, lang, searchType, searchValue);
			} else { // 승인자 리스트
				userList = ezEmailService.getApproverList(tenantId, companyId, lang);
			}
			
			List<Map<String, String>> reUserList = new ArrayList<Map<String,String>>();
			if (userList != null && userList.size() > 0) {
				for(OrganUserVO userVO : userList) {
					
					Map<String, String> map = new HashMap<String, String>();
					map.put("userId", 		userVO.getCn());
					map.put("userName", 	userVO.getDisplayName());
					map.put("deptId", 		userVO.getDepartment());
					map.put("deptName", 	userVO.getDescription());
					map.put("title", 		userVO.getTitle());
					
					reUserList.add(map);
				}
			}
			
			// 부서내 승인자 리스트
			List<OrganUserVO> approverList = ezEmailService.getApproverSearchList(tenantId, companyId, lang, "deptId", deptId);
			
			int approverCount 		= approverList.size(); 	// 부서내 승인자 개수
			String approverAccount 	= (approverCount > 0) ? approverList.get(0).getCn() : ""; // 승인자 아이디
			logger.debug("approverAccount={}, approverCount={}", approverAccount, approverCount);
			
			returnData.put("approverList", reUserList);
			returnData.put("approverAccount", approverAccount);
			returnData.put("approverCount", approverCount);
			
			result.put("data", returnData);
			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);

			result.put("data", "fail");
			result.put("status", "error");
			result.put("code", 1);
		}

		logger.debug("MOBILE G/W MAIL getApproverList ended.");

		return result;
	}
	
	/**
	 * 승인메일 : 발송 승인대기 목록 조회
	 * @param userId
	 * @param start : 몇 번째 메일부터 가져올지 지정 (1부터 시작)
	 * @param end : 몇 번째 메일까지 가져올지 지정
	 * @return data: {
	 * 		listTotalCount : 목록 총 개수
	 * 		list : 목록 리스트
	 * }
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value={"/mobile/ezemail/appr/getPendingList/{userId:.+}"},
			method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject getApprMailPendingList(HttpServletRequest request, @PathVariable String userId, @RequestBody JSONObject jsonObject) {
		logger.debug("MOBILE G/W MAIL getApprMailPendingList started.");
		logger.debug("uesrId={}", userId);

		JSONObject result = new JSONObject();
        JSONObject returnData = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO userInfo = mOptionService.commonInfo(serverName, userId);
			String userCn 		= userInfo.getUserId();
			String companyId 	= userInfo.getCompanyId();
			String lang 		= userInfo.getPrimary();
			int tenantId 		= userInfo.getTenantId();
			logger.debug("userCn={}, companyId={}, lang={}, tenantId={}", userCn, companyId, lang, tenantId);

			String domainName = ezCommonService.getTenantConfig("DomainName", tenantId);
			
			String type = "approver";
			int start 	= Integer.parseInt(StringUtils.defaultIfBlank((String) jsonObject.get("start"), "1"));
			int end 	= Integer.parseInt(StringUtils.defaultIfBlank((String) jsonObject.get("end"), "20"));
			logger.debug("start={}, end={}", start, end);

			// jgw 서버에서 리스트 받아오기
			JSONArray array 	= ezEmailService.getApprMailList(tenantId, companyId, type, userCn, lang, start, end, domainName);
			/*JSONArray array2 	= ezEmailService.setUTCtoUserTime(array, userInfo.getOffSet(), tenantId);

			JSONArray resultArry = new JSONArray();
			resultArry 			= ezEmailService.setHref(array2);*/
			JSONArray resultArray = ezEmailService.formatApprEmail(array, userInfo.getOffSet(), tenantId, null);

			int listTotalCount = ezEmailService.getApprMailListCount(tenantId, companyId, type, userCn);

			returnData.put("listTotalCount", listTotalCount);
			returnData.put("list", resultArray);
			
			result.put("data", returnData);
			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);

			result.put("data", "fail");
			result.put("status", "error");
			result.put("code", 1);
		}

		logger.debug("MOBILE G/W MAIL getApprMailPendingList ended.");

		return result;
	}
	
	/**
	 * 승인메일 : 발송 완료 목록 조회
	 * @param userId
	 * @param start : 몇 번째 메일부터 가져올지 지정 (1부터 시작)
	 * @param end : 몇 번째 메일까지 가져올지 지정
	 * @return data: {
	 * 		listTotalCount : 목록 총 개수
	 * 		list : 목록 리스트
	 * }
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value={"/mobile/ezemail/appr/getCompleteList/{userId:.+}"},
			method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject getApprMailCompleteList(HttpServletRequest request, @PathVariable String userId, @RequestBody JSONObject jsonObject) {
		logger.debug("MOBILE G/W MAIL getApprMailCompleteList started.");
		logger.debug("uesrId={}", userId);

		JSONObject result = new JSONObject();
        JSONObject returnData = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO userInfo = mOptionService.commonInfo(serverName, userId);
			String userCn		= userInfo.getUserId();
			String companyId 	= userInfo.getCompanyId();
			String lang 		= userInfo.getPrimary();
			int tenantId 		= userInfo.getTenantId();
			String ld = commonUtil.getTwoLetterLangFromLangNum(userInfo.getLang());
			Locale locale = new Locale(ld);
			logger.debug("userCn={}, companyId={}, lang={}, tenantId={}, locale={}", userCn, companyId, lang, tenantId, locale);

			String domainName = ezCommonService.getTenantConfig("DomainName", tenantId);
			
			String type = "complete";
			int start 	= Integer.parseInt(StringUtils.defaultIfBlank((String) jsonObject.get("start"), "1"));
			int end 	= Integer.parseInt(StringUtils.defaultIfBlank((String) jsonObject.get("end"), "20"));
			logger.debug("start={}, end={}", start, end);
			/*int listCount = end - (start-1);
				listCount = (listCount < 0) ? 0 : listCount;
			logger.debug("start={}, end={}, listCount={}", start, end, listCount);*/

			// jgw 서버에서 리스트 받아오기
			JSONArray array 	= ezEmailService.getApprMailList(tenantId, companyId, type, userCn, lang, start, end, domainName);
			JSONArray resultArray = ezEmailService.formatApprEmail(array, userInfo.getOffSet(), tenantId, locale);
			/*JSONArray array2 	= ezEmailService.setUTCtoUserTime(array, userInfo.getOffSet(), tenantId);
			JSONArray array3	= ezEmailService.setHref(array2);

			JSONArray resultArry = new JSONArray();
			resultArry = ezEmailService.setStateByLocale(array3, locale);*/

			int listTotalCount = ezEmailService.getApprMailListCount(tenantId, companyId, type, userCn);

			returnData.put("listTotalCount", listTotalCount);
			returnData.put("list", resultArray);
			
			result.put("data", returnData);
			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);

			result.put("data", "fail");
			result.put("status", "error");
			result.put("code", 1);
		}

		logger.debug("MOBILE G/W MAIL getApprMailCompleteList ended.");

		return result;
	}
	
	/**
	 * 승인메일 : 발송요청 목록 조회
	 * @param userId
	 * @param start : 몇 번째 메일부터 가져올지 지정 (1부터 시작)
	 * @param end : 몇 번째 메일까지 가져올지 지정
	 * @return data: {
	 * 		listTotalCount : 목록 총 개수
	 * 		list : 목록 리스트
	 * }
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value={"/mobile/ezemail/appr/getRequestList/{userId:.+}"},
			method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject getApprMailRequestList(HttpServletRequest request, @PathVariable String userId, @RequestBody JSONObject jsonObject) {
		logger.debug("MOBILE G/W MAIL getApprMailRequestList started.");
		logger.debug("uesrId={}", userId);

		JSONObject result = new JSONObject();
        JSONObject returnData = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO userInfo = mOptionService.commonInfo(serverName, userId);
			String userCn		= userInfo.getUserId();
			String companyId 	= userInfo.getCompanyId();
			String lang 		= userInfo.getPrimary();
			int tenantId 		= userInfo.getTenantId();
			String ld = commonUtil.getTwoLetterLangFromLangNum(userInfo.getLang());
			Locale locale = new Locale(ld);
			logger.debug("userCn={}, companyId={}, lang={}, tenantId={}, locale={}", userCn, companyId, lang, tenantId, locale);

			String domainName = ezCommonService.getTenantConfig("DomainName", tenantId);

			String type = "user";
			int start 	= Integer.parseInt(StringUtils.defaultIfBlank((String) jsonObject.get("start"), "1"));
			int end 	= Integer.parseInt(StringUtils.defaultIfBlank((String) jsonObject.get("end"), "20"));
			String shareId 	= (String) jsonObject.get("shareId");
			logger.debug("start={}, end={}, shareId={}", start, end, shareId);

			String vUserId = StringUtils.defaultIfBlank(shareId, userCn);
			
			// jgw 서버에서 리스트 받아오기
			JSONArray array = ezEmailService.getApprMailList(tenantId, companyId, type, vUserId, lang, start, end, domainName);
			JSONArray resultArray = ezEmailService.formatApprEmail(array, userInfo.getOffSet(), tenantId, locale);
			/*JSONArray array2 = ezEmailService.setUTCtoUserTime(array, userInfo.getOffSet(), tenantId);
			JSONArray array3 = ezEmailService.setApprover(array2, locale);

			JSONArray resultArry = new JSONArray();
			resultArry = ezEmailService.setHref(array3);*/

			int listTotalCount = ezEmailService.getApprMailListCount(tenantId, companyId, type, vUserId);

			returnData.put("listTotalCount", listTotalCount);
			returnData.put("list", resultArray);
			
			result.put("data", returnData);
			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);

			result.put("data", "fail");
			result.put("status", "error");
			result.put("code", 1);
		}

		logger.debug("MOBILE G/W MAIL getApprMailRequestList ended.");

		return result;
	}
	
	/**
	 * 승인메일 : 발송 승인
	 * @param userId
	 * @param href: String[] 발송 승인할 메일 href
	 * @return data: OK: 성공 or ERROR_{count}: 실패한 개수
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value={"/mobile/ezemail/appr/setApproval/{userId:.+}"},
			method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject setApprMailApproval(HttpServletRequest request, @PathVariable String userId, @RequestBody JSONObject jsonObject) {
		logger.debug("MOBILE G/W MAIL setApprMailApproval started.");
		logger.debug("uesrId={}", userId);

		JSONObject result = new JSONObject();
		String returnValue = "OK";
		int errorInt = 0; // 오류난 개수

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO userInfo = mOptionService.commonInfo(serverName, userId);
			int tenantId 		= userInfo.getTenantId();
			String userCn 		= userInfo.getUserId();
			String companyId 	= userInfo.getCompanyId();
			String lang 		= userInfo.getPrimary();
			String ld = commonUtil.getTwoLetterLangFromLangNum(userInfo.getLang());
			Locale locale = new Locale(ld);
			String domainName = ezCommonService.getTenantConfig("DomainName", tenantId);
			logger.debug("userCn={}, tenantId={}, companyId={}, lang={}, locale={}, domainName={}", userCn, tenantId, companyId, lang, locale, domainName);
			
			// param
			List<String> hrefArray = (ArrayList<String>) jsonObject.get("href");

			// 데이터 수집 단계
			List<Map<String, Object>> approvalDataList = new ArrayList<>();

			for(String encryptedHref : hrefArray) {
				// decrypt & mailbox/uid
				String href = egovFileScrty.decryptAES(encryptedHref);
				String hrefUserId = href.split("/")[0].replaceFirst("^Sent\\.", "");
				long uid = Long.parseLong(href.split("/")[1]);
				
				// 신청자 정보
				String applicantId = hrefUserId;
				String applicantEmail = hrefUserId + "@" + domainName;
				OrganUserVO applicantVO = ezOrganAdminService.getUserInfo(hrefUserId, "1", tenantId);
				if (applicantVO != null) {
					applicantId = applicantVO.getCn();
					applicantEmail = applicantId + "@" + domainName;
				}

				String applicantLang = ezCommonService.selectUserGetLang(applicantId, tenantId);
				Locale applicantLocale = StringUtils.isNotBlank(applicantLang) ? commonUtil.getLocalFromLang(applicantLang) : Locale.getDefault();

				logger.debug("apprSetApproval userCn={}, href={}, hrefUserId={}, uid={}, applicantId={}, applicantEmail={}, applicantLang={}, applicantLocale={}",
						userCn, href, hrefUserId, uid, applicantId, applicantEmail, applicantLang, applicantLocale);

				// 승인 데이터 생성
				Map<String, Object> approvalData = new HashMap<>();
				approvalData.put("tenantId", tenantId);
				approvalData.put("companyId", companyId);
				approvalData.put("lang", applicantLang);
				approvalData.put("locale", applicantLocale);
				approvalData.put("uid", uid);
				approvalData.put("applicantId", applicantId);
				approvalData.put("applicantEmail", applicantEmail);
				approvalData.put("state", "pending");
				approvalData.put("apprMailFlag", "normal");

				approvalDataList.add(approvalData);
			}

			// 메일이 대기 상태인지 check
			int checkMail = ezEmailService.checkApprHistoryMultiple(tenantId, companyId, userId, approvalDataList);

			if (checkMail == 1) {
				returnValue = "DONE"; // 1: 이미 처리된 메일이 있음
			} else {
				// 처리 단계
				for (Map<String, Object> approvalData : approvalDataList) {
					int resultInt = ezEmailService.setApprMailApproval(userCn, tenantId, approvalData, (String) approvalData.get("applicantEmail"), (Long) approvalData.get("uid"));
	
					if (resultInt != 0) {
						errorInt++;
					}
				}
				
				if (errorInt > 0) {
					returnValue = "ERROR_" + errorInt;
				}
			}
			
			result.put("data", returnValue);
			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);

			result.put("data", "fail");
			result.put("status", "error");
			result.put("code", 1);
			
			returnValue = "ERROR";
		}

		logger.debug("MOBILE G/W MAIL setApprMailApproval ended. returnValue={}", returnValue);

		return result;
	}
	
	/**
	 * 승인메일 : 발송 거부
	 * @param userId
	 * @param jsonObject.href: String[] 발송 거부할 메일 href
	 * @return data: OK: 성공 or ERROR_{count}: 실패한 개수
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value={"/mobile/ezemail/appr/setReject/{userId:.+}"},
			method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject setApprMailReject(HttpServletRequest request, @PathVariable String userId, @RequestBody JSONObject jsonObject) {
		logger.debug("MOBILE G/W MAIL setApprMailReject started.");
		logger.debug("uesrId={}", userId);

		JSONObject result = new JSONObject();
		String returnValue = "OK";
		int errorInt = 0; // 오류난 개수

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO userInfo = mOptionService.commonInfo(serverName, userId);
			int tenantId 		= userInfo.getTenantId();
			String userCn		= userInfo.getUserId();
			String companyId 	= userInfo.getCompanyId();
			String lang 		= userInfo.getPrimary();
			String ld = commonUtil.getTwoLetterLangFromLangNum(userInfo.getLang());
			Locale locale = new Locale(ld);
			String domainName = ezCommonService.getTenantConfig("DomainName", tenantId);
			logger.debug("tenantId={}, companyId={}, lang={}, locale={}, domainName={}", tenantId, companyId, lang, locale, domainName);
			
			// param
			List<String> hrefArray = (ArrayList<String>) jsonObject.get("href");
		    String memo = StringUtils.defaultIfBlank((String) jsonObject.get("memo"), "");
		    memo = memo.replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("&", "&amp;");

			// 데이터 수집 단계
			List<Map<String, Object>> approvalDataList = new ArrayList<>();

		    for(String encryptedHref : hrefArray) {
				// decrypt & mailbox/uid
				String href = egovFileScrty.decryptAES(encryptedHref);
				String hrefUserId = href.split("/")[0].replaceFirst("^Sent\\.", "");
				long uid = Long.parseLong(href.split("/")[1]);
				
				// 신청자 정보
				String applicantId = hrefUserId;
				String applicantEmail = hrefUserId + "@" + domainName;
				OrganUserVO applicantVO = ezOrganAdminService.getUserInfo(hrefUserId, "1", tenantId);
				if (applicantVO != null) {
					applicantId = applicantVO.getCn();
					applicantEmail = applicantId + "@" + domainName;
				}

				String applicantLang = ezCommonService.selectUserGetLang(applicantId, tenantId);
				Locale applicantLocale = StringUtils.isNotBlank(applicantLang) ? commonUtil.getLocalFromLang(applicantLang) : Locale.getDefault();
				
				logger.debug("apprSetRejectAction userCn={}, href={}, hrefUserId={}, uid={}, applicantId={}, applicantEmail={}, applicantLang={}, applicantLocale={}",
						userCn, href, hrefUserId, uid, applicantId, applicantEmail, applicantLang, applicantLocale);

				// 승인 데이터 생성
				Map<String, Object> approvalData = new HashMap<>();
				approvalData.put("tenantId", tenantId);
				approvalData.put("companyId", companyId);
				approvalData.put("lang", applicantLang);
				approvalData.put("locale", applicantLocale);
				approvalData.put("uid", uid);
				approvalData.put("applicantId", applicantId);
				approvalData.put("applicantEmail", applicantEmail);
				approvalData.put("state", "pending");
				approvalData.put("apprMailFlag", "normal");

				approvalDataList.add(approvalData);
			}

			// 메일이 대기 상태인지 check
			int checkMail = ezEmailService.checkApprHistoryMultiple(tenantId, companyId, userId, approvalDataList);

			if (checkMail == 1) {
				returnValue = "DONE"; // 1: 이미 처리된 메일이 있음
			} else {
				// 처리 단계
				for (Map<String, Object> approvalData : approvalDataList) {
					int resultInt = ezEmailService.setApprMailReject(userCn, tenantId, approvalData, (String) approvalData.get("applicantEmail"), (Long) approvalData.get("uid"), memo);

					if (resultInt != 0) {
						errorInt++;
					}
				}
			}
			
			if (errorInt > 0) {
				returnValue = "ERROR_" + errorInt;
			}
			
			result.put("data", returnValue);
			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);

			result.put("data", "fail");
			result.put("status", "error");
			result.put("code", 1);
			
			returnValue = "ERROR";
		}

		logger.debug("MOBILE G/W MAIL setApprMailReject ended. returnValue={}", returnValue);

		return result;
	}
	
	/**
	 * 승인메일 : 신청 취소
	 * @param userId
	 * @param href: String[] 발송 취소할 메일 href
	 * @return data: OK: 성공 or ERROR_{count}: 실패한 개수
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value={"/mobile/ezemail/appr/setCancel/{userId:.+}"},
			method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject setApprMailCancel(HttpServletRequest request, @PathVariable String userId, @RequestBody JSONObject jsonObject) {
		logger.debug("MOBILE G/W MAIL setApprMailCancel started.");
		logger.debug("uesrId={}", userId);

		JSONObject result = new JSONObject();
		String returnValue = "OK";

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO userInfo = mOptionService.commonInfo(serverName, userId);
			int tenantId 		= userInfo.getTenantId();
			String userCn		= userInfo.getUserId();
			String companyId 	= userInfo.getCompanyId();
			String lang 		= userInfo.getPrimary();
			String ld = commonUtil.getTwoLetterLangFromLangNum(userInfo.getLang());
			Locale locale = new Locale(ld);
			String domainName = ezCommonService.getTenantConfig("DomainName", tenantId);
			logger.debug("tenantId={}, companyId={}, lang={}, locale={}, domainName={}", tenantId, companyId, lang, locale, domainName);
			
			// param
			String href = StringUtils.defaultIfBlank((String) jsonObject.get("href"), "");
			href = egovFileScrty.decryptAES(href);
			String hrefUserId = href.split("/")[0].replaceFirst("^Sent\\.", "");
			long uid = Long.parseLong(href.split("/")[1]);
			
			// 신청자 정보
			OrganUserVO applicantVO = ezOrganAdminService.getUserInfo(hrefUserId, "1", tenantId);
			String applicantId = applicantVO.getCn();
			String applicantEmail = applicantId + "@" + domainName;
			logger.debug("apprSetCancel userId={}, href={}, hrefUserId={}, uid={}, applicantId={}, applicantEmail={}",
					userCn, href, hrefUserId, uid, applicantId, applicantEmail);
	        
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("companyId", companyId);
			map.put("lang", lang);
			map.put("locale", locale);

			// 데이터 수집 단계
			List<Map<String, Object>> approvalDataList = new ArrayList<>();
			Map<String, Object> approvalData = new HashMap<>();
			approvalData.put("tenantId", tenantId);
			approvalData.put("companyId", companyId);
			approvalData.put("lang", lang);
			approvalData.put("locale", locale);
			approvalData.put("uid", uid);
			approvalData.put("applicantId", applicantId);
			approvalData.put("applicantEmail", applicantEmail);
			approvalData.put("state", "pending");

			approvalDataList.add(approvalData);

			// 메일이 대기 상태인지 check
			int checkMail = ezEmailService.checkApprHistoryAll(tenantId, companyId, userId, approvalDataList);

			if (checkMail == 1) {
				returnValue = "DONE"; // 1: 이미 처리된 메일이 있음
			} else {
				int resultInt = ezEmailService.setApprMailCancel(tenantId, map, applicantEmail, uid);

				if (resultInt != 0) {
					returnValue = "ERROR";
				}
			}
			
			result.put("data", returnValue);
			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);

			result.put("data", "fail");
			result.put("status", "error");
			result.put("code", 1);
			
			returnValue = "ERROR";
		}

		logger.debug("MOBILE G/W MAIL setApprMailCancel ended. returnValue={}", returnValue);

		return result;
	}

	/**
	 * 승인메일 : 읽기화면
	 * @param userId
	 * @param href: String[] 발송 취소할 메일 href
	 * @return data: OK: 성공 or ERROR_{count}: 실패한 개수
	 * 
	 * /mobile/ezemail/appr/setCancel/{userId:.+}
	 * /mobile/ezemail/folders/{folderId}/mails/{messageId}/users/{userId:.+}
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezemail/appr/mailRead/{userId:.+}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public Object apprMailRead(HttpServletRequest request, @PathVariable String userId) throws Exception {
		logger.debug("MOBILE G/W MAIL apprMailRead started.");
				
		JSONObject result = new JSONObject();
		JSONObject mail = new JSONObject();
		IMAPAccess ia = null;
		List<Map<String, String>> attachedFileList = new ArrayList<Map<String, String>>();
		
		try {		
			// get user credentials
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			int tenantId = info.getTenantId();
			String userCn = info.getUserId();
			String ld = commonUtil.getTwoLetterLangFromLangNum(info.getLang());
			Locale locale = new Locale(ld);
			logger.debug("tenantId={}", tenantId);
			String mailURL = request.getParameter("mailURL");
			mailURL = URLDecoder.decode(mailURL, "UTF-8");
			logger.debug("mailUrl={}", mailURL);
			
			// tenantConfig
			String domainName = ezCommonService.getTenantConfig("DomainName", tenantId);
			String useMobileViewer = ezCommonService.getTenantConfig("useMobileViewer", tenantId);
			
			// 승인메일
			String shareId = Globals.APPR_MAIL_SHARED_ID; // 승인메일 공유사서함 아이디
			String userEmail = shareId + "@" + domainName; // 승인메일 계정
			String password = jspw;
			logger.debug("shareId={}, userEmail={}", shareId, userEmail);

			// fixed param
			String pnFlag = "N";
			
			String pAttachListHtmlSub = null;
			
			List<String> bodyInfoList = null;
			
			// retrieve the passed in parameters

			String url = egovFileScrty.decryptAES(mailURL);
			logger.debug("url={}", url);
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
			logger.debug("folderPath={}, uid={}", folderPath, uid);
			
			Address[] arrFroms = null;
			Address[] arrRecipientsTo = null;
			Address[] arrRecipientsCC = null;
			Address[] arrRecipientsBCC = null;
			Date date = null;
			String fromStr = null;
			String fromEmail = null;
			String toStr = null;
			String toHiddenStr = null;
			String toMobileStr = "";
			String toList = "";
			String ccStr = null;
			String ccHiddenStr = null;
			String ccMobileStr = "";
			String ccList = "";
			String bccStr = "";
			String bccMobileStr = "";
			String bccList = "";
			String subject = null;
			String dateStr = null;
			String title = null;
			String pReadFlag = "Y";
			String isDelete = "BMOVE";
			boolean isSentItems = false;
			String pIsCCFg = "Y";
			String flagged = "0";
		
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userEmail, password, egovMessageSource, locale, ezEmailUtil);
			Folder f = ia.getFolder(folderPath);
			
			if (f == null || !f.exists()) {
				logger.error("Folder not found. folderPath={}", folderPath);
			} else {
				f.open(Folder.READ_WRITE);
				
				Message message = null;
				if (f.isOpen() && f instanceof IMAPFolder) {
					message = ((IMAPFolder)f).getMessageByUID(uid);
				}
				
				if (message == null) {
					//to-do 메일이 없습니다. 와 같은 문구를  보내주고 싶은데 아마 메일이 있는지 체크하는 메소드를 다시 만들어야 할 거 같다.
					logger.error("Message not found. uid={}", uid);
					result.put("status", "ok");
					result.put("code", 0);			
					result.put("data", "");
					
					return result;
				} else {
					FetchProfile fp = new FetchProfile();
					
					fp.add(FetchProfile.Item.ENVELOPE);
					fp.add(IMAPFolder.FetchProfileItem.INTERNALDATE);
					fp.add(FetchProfile.Item.SIZE);
					fp.add(FetchProfile.Item.FLAGS);
					fp.add("Subject");
					fp.add("From");
					fp.add("To");
					fp.add("Cc");
					fp.add("Bcc");
					
					Message[] fetchMessages = new Message[] {message};
					f.fetch(fetchMessages, fp);
					
					// From
					arrFroms = message.getFrom();
					if (arrFroms != null) {
						fromStr = ezEmailUtil.getFromNameOrAddressOfMessage(message);
						fromStr = commonUtil.trimDoubleQuotes(fromStr);
								
						fromEmail = ((InternetAddress)arrFroms[0]).getAddress();
					} else {
						String[] fromHeaders = message.getHeader("From");
						
						if (fromHeaders != null) {
							fromStr = MimeUtility.decodeText(message.getHeader("From")[0]);
						}
					}
					logger.debug("From={}", fromStr);
					
					// TO
					arrRecipientsTo = message.getRecipients(Message.RecipientType.TO);
					if (arrRecipientsTo != null) {
						boolean toListme = false;
						for (int i = 0; i < arrRecipientsTo.length; i++) {
							if (((InternetAddress)arrRecipientsTo[i]).getAddress().equals(userEmail)) {
								toListme = true;
								break;
							}
						}
						
						String toHeader = message.getHeader("To")[0];
						boolean isAscii = ezEmailUtil.isPureAscii(toHeader);						
						String name = null;
						
						for (int i = 0; i < arrRecipientsTo.length; i++) {
							name = ((InternetAddress)arrRecipientsTo[i]).getPersonal();
							
							if (name == null) {
								name = ((InternetAddress)arrRecipientsTo[i]).getAddress();
							} else {
								if (!isAscii) {
									byte[] rawBytes = name.getBytes("iso-8859-1");
									
									name = ezEmailUtil.decodeNonAsciiBytes(rawBytes);								
								} else {
									name = MimeUtility.decodeText(name);
								}
								
								name = commonUtil.trimDoubleQuotes(name);
							}
							logger.debug("TO=" + name + ((InternetAddress)arrRecipientsTo[i]).getAddress());
							
							if (toListme) {
								if (((InternetAddress)arrRecipientsTo[i]).getAddress().equals(userEmail)) {
									if (arrRecipientsTo.length > 1) {
										toStr = getReceiverHTML(name, ((InternetAddress)arrRecipientsTo[i]).getAddress()) + "<span>&nbsp;(" + egovMessageSource.getMessage("ezEmail.t10000", locale) + arrRecipientsTo.length + egovMessageSource.getMessage("ezEmail.t10001", locale) + ")&nbsp;<img src='/images/expnd.gif'  style='cursor:pointer;' onclick='ShowHiddenTo(this);' align='absmiddle'></span>";
									} else {
										toStr = getReceiverHTML(name, ((InternetAddress)arrRecipientsTo[i]).getAddress());
									}
								}
								
								if (toHiddenStr == null) {
									toHiddenStr = getReceiverHTML(name, ((InternetAddress)arrRecipientsTo[i]).getAddress());
								} else {
									toHiddenStr += " , " + getReceiverHTML(name, ((InternetAddress)arrRecipientsTo[i]).getAddress());
								}
							} else {
								if (i == 0) {
									if (arrRecipientsTo.length > 1) {
										toStr = getReceiverHTML(name, ((InternetAddress)arrRecipientsTo[i]).getAddress()) + "<span>&nbsp;(" + egovMessageSource.getMessage("ezEmail.t10000", locale) + arrRecipientsTo.length + egovMessageSource.getMessage("ezEmail.t10001", locale) + ")&nbsp;<img src='/images/expnd.gif'  style='cursor:pointer;' onclick='ShowHiddenTo(this);' align='absmiddle'></span>";
									} else {
										toStr = getReceiverHTML(name, ((InternetAddress)arrRecipientsTo[i]).getAddress());
									}
								}
								
								if (toHiddenStr == null) {
									toHiddenStr = getReceiverHTML(name, ((InternetAddress)arrRecipientsTo[i]).getAddress());
								} else {
									toHiddenStr += " , " + getReceiverHTML(name, ((InternetAddress)arrRecipientsTo[i]).getAddress());
								}
							}
							
							if (i == arrRecipientsTo.length - 1) {
								toMobileStr +=  getMobileReceiverHTML(name, ((InternetAddress)arrRecipientsTo[i]).getAddress());
							} else {
								toMobileStr +=  getMobileReceiverHTML(name, ((InternetAddress)arrRecipientsTo[i]).getAddress()) + "&nbsp;,&nbsp;";
							}
							
							// HTML 태그가 없는 To 정보
							if (toList.equals("")) {
								toList = name + " <" + ((InternetAddress)arrRecipientsTo[i]).getAddress() + ">";
							} else {
								toList += "," + name + " <" + ((InternetAddress)arrRecipientsTo[i]).getAddress() + ">";
							}															
						}
					}
					
					// CC
					arrRecipientsCC = message.getRecipients(Message.RecipientType.CC);
					if (arrRecipientsCC != null) {
						boolean ccListme = false;
						
						for (int i=0; i<arrRecipientsCC.length; i++) {
							if (((InternetAddress)arrRecipientsCC[i]).getAddress().equals(userEmail)) {
								ccListme = true;
								break;
							}
						}
						
						String ccHeader = message.getHeader("Cc")[0];
						boolean isAscii = ezEmailUtil.isPureAscii(ccHeader);												
						String name = null;
						
						for (int i=0; i<arrRecipientsCC.length; i++) {
							name = ((InternetAddress)arrRecipientsCC[i]).getPersonal();
							
							if (name == null) {
								name = ((InternetAddress)arrRecipientsCC[i]).getAddress();
							} else {
								if (!isAscii) {
									byte[] rawBytes = name.getBytes("iso-8859-1");
									
									name = ezEmailUtil.decodeNonAsciiBytes(rawBytes);								
								} else {								
									name = MimeUtility.decodeText(name);
								}
								
								name = commonUtil.trimDoubleQuotes(name);
							}
							
							logger.debug("CC=" + name + ((InternetAddress)arrRecipientsCC[i]).getAddress());
							
							if (ccListme) {
								if (((InternetAddress)arrRecipientsCC[i]).getAddress().equals(userEmail)) {
									if (arrRecipientsCC.length > 1) {
										ccStr = getReceiverHTML(name, ((InternetAddress)arrRecipientsCC[i]).getAddress()) + "<span>&nbsp;(" + egovMessageSource.getMessage("ezEmail.t10000", locale) + arrRecipientsCC.length + egovMessageSource.getMessage("ezEmail.t10001", locale) + ")&nbsp;<img src='/images/expnd.gif'  style='cursor:pointer;' onclick='ShowHiddenCc(this);' align='absmiddle'></span>";
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
										ccStr = getReceiverHTML(name, ((InternetAddress)arrRecipientsCC[i]).getAddress()) + "<span>&nbsp;(" + egovMessageSource.getMessage("ezEmail.t10000", locale) + arrRecipientsCC.length + egovMessageSource.getMessage("ezEmail.t10001", locale) + ")&nbsp;<img src='/images/expnd.gif'  style='cursor:pointer;' onclick='ShowHiddenCc(this);' align='absmiddle'></span>";
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
							
							if (i == arrRecipientsCC.length - 1) {
								ccMobileStr +=  getMobileReceiverHTML(name, ((InternetAddress)arrRecipientsCC[i]).getAddress());
							} else {
								ccMobileStr +=  getMobileReceiverHTML(name, ((InternetAddress)arrRecipientsCC[i]).getAddress()) + "&nbsp;,&nbsp;";
							}
							
							// HTML 태그가 없는 CC 정보
							if (ccList.equals("")) {
								ccList = name + " <" + ((InternetAddress)arrRecipientsCC[i]).getAddress() + ">";
							} else {
								ccList += "," + name + " <" + ((InternetAddress)arrRecipientsCC[i]).getAddress() + ">";
							}																						
						}
					}
	
					// BCC
					arrRecipientsBCC = message.getRecipients(Message.RecipientType.BCC);
					if (arrRecipientsBCC != null) {
						String name = null;
						
						for (int i = 0; i < arrRecipientsBCC.length; i++) {
							name = ((InternetAddress)arrRecipientsBCC[i]).getPersonal();
							
							if (name == null) {
								name = ((InternetAddress)arrRecipientsBCC[i]).getAddress();
							} else {
								name = MimeUtility.decodeText(name);
								name = commonUtil.trimDoubleQuotes(name);
							}
							
							logger.debug("BCC=" + name + ((InternetAddress)arrRecipientsBCC[i]).getAddress());
							
							if (i != 0) {
								bccStr += ", ";
							}
							
							bccStr += getReceiverHTML(name, ((InternetAddress)arrRecipientsBCC[i]).getAddress());
							
							if (i == arrRecipientsBCC.length - 1) {
								bccMobileStr +=  getMobileReceiverHTML(name, ((InternetAddress)arrRecipientsBCC[i]).getAddress());
							} else {
								bccMobileStr +=  getMobileReceiverHTML(name, ((InternetAddress)arrRecipientsBCC[i]).getAddress()) + "&nbsp;,&nbsp;";
							}
							
							// HTML 태그가 없는 BCC 정보
							if (bccList.equals("")) {
								bccList = name + " <" + ((InternetAddress)arrRecipientsBCC[i]).getAddress() + ">";
							} else {
								bccList += "," + name + " <" + ((InternetAddress)arrRecipientsBCC[i]).getAddress() + ">";
							}																													
						}
					}
					
					if (ccStr == null || ccStr.equals("")) {
						pIsCCFg = "N";
					}
					
					// received date
					date = message.getReceivedDate();
					if (date != null) {
						SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
						sdf.setTimeZone(TimeZone.getTimeZone("GMT"));
						String receivedDateStr = sdf.format(date);
						
						dateStr = commonUtil.getDateStringInUTC(receivedDateStr, info.getOffSet(), false);
					}
					logger.debug("dateStr=" + dateStr);
					
					// subject
					subject = ezEmailUtil.getSubject(message);
					logger.debug("subject=" + subject);
					
					if (subject != null) {
						title = egovMessageSource.getMessage("ezEmail.t565", locale) + subject;
					}
					
					if (message.getFolder().getFullName().equals(ezEmailUtil.getSentFolderId(locale))) {
						isSentItems = true;
					}
					
					if (message.getFolder().getFullName().equals(ezEmailUtil.getTrashFolderId(locale))) {
						isDelete = "BDELETE";
					}
					
					if (!message.isSet(Flag.SEEN)) {
						pReadFlag = "N";
						message.setFlag(Flag.SEEN, true);
						logger.debug("Message's seen flag changed to true.");
					}
					
					if (message.isSet(Flags.Flag.FLAGGED)) {
						flagged = "1";
					}
					
					mail.put("flag", flagged);
					mail.put("folderName", f.getName());
					
					Map<String, Object> extraMap = new HashMap<String, Object>();
					extraMap.put("mobile", true);
					extraMap.put("shareId", shareId);
					
					bodyInfoList = ezEmailUtil.getBodyInfo(message, folderPath, uid, -1, attachedFileList, locale, extraMap);

					double size = Double.parseDouble(bodyInfoList.get(2));
					String strSize = ezEmailUtil.getSizeWithUnit(size);
					pAttachListHtmlSub = bodyInfoList.get(3) + egovMessageSource.getMessage("ezEmail.t180", locale) + " (" + strSize + ")";
					
					if (!folderPath.equals(ezEmailUtil.getSentFolderId(locale))) {
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
							OrganUserVO userVO = ezOrganAdminService.getUserInfo(info.getUserId(), info.getLang(), info.getTenantId());
							
							SMTPAccess sa = SMTPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.SMTPPort"),
									userEmail, password, info.getEmail());
							
							ezEmailMailReadController.processAutoMDN(sa, message, userEmail, userVO.getDisplayName(), info.getTenantId());
						} else {
							logger.debug("MDNSentFlag is set");
						}
					}
				}
				
				f.close(true);				
			}
			
			logger.debug(toMobileStr);
			logger.debug(toStr);
			logger.debug(ccMobileStr);
			logger.debug(ccStr);
			
			mail.put("fromStr", fromStr);
			mail.put("fromEmail", fromEmail);
			mail.put("toStr", toStr);
			mail.put("toHiddenStr", toHiddenStr);
			mail.put("toMobileStr", toMobileStr);
			mail.put("toList", toList);
			mail.put("ccStr", ccStr);
			mail.put("ccHiddenStr", ccHiddenStr);
			mail.put("ccMobileStr", ccMobileStr);
			mail.put("ccList", ccList);
			mail.put("bccStr", bccStr);
			mail.put("bccMobileStr", bccMobileStr);
			mail.put("bccList", bccList);
			mail.put("dateStr", dateStr);
			mail.put("subject", subject);
			mail.put("title", title);
			mail.put("folderId", folderPath);
			mail.put("uid", uid);
			mail.put("pReadFlag", pReadFlag);
			mail.put("isDelete", isDelete);
			mail.put("isSentItems", isSentItems);
			mail.put("pnFlag", pnFlag);
			mail.put("pIsCCFg", pIsCCFg);
			mail.put("useMobileViewer", useMobileViewer);
			
			if (bodyInfoList != null) { 
				String htmlBody = bodyInfoList.get(0);
				String dotNetIntegration = ezCommonService.getTenantConfig("dotNetIntegration", info.getTenantId());
				
				if (dotNetIntegration.equals("YES")) {
					String mobileDownloadInline = config.getProperty("config.MobileDownloadInline");
										
					htmlBody = htmlBody.replace("/ezEmail/downloadInline.do", mobileDownloadInline);
				}
				
				mail.put("htmlBody", htmlBody);
				mail.put("pAttachListHtmlSub", pAttachListHtmlSub);
				mail.put("pAttachListHtml", bodyInfoList.get(1));
				mail.put("isAttach", bodyInfoList.get(4));
			}
			
			mail.put("attachedFileList", attachedFileList);
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", mail);			
		} catch (MessagingException e) {
			logger.error(e.getMessage(), e);
			
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");			
		} finally {
			if (ia != null) {
				ia.close();
			}
		}
	
		logger.debug("MOBILE G/W MAIL apprMailRead ended.");		
		
		return result;		
	}

	/**
	 * 공유사서함 정보 호출 함수
	 */
	private String getSharedMailboxSearch(String pSearchList, MCommonVO userInfo) {
        String returnData = "";
        
        try {
        	String searchValue = pSearchList.split("::")[1];
        	
			List<MailSharedMailboxVO> sharedMailboxList = ezEmailService.getSharedMailboxSearchList(userInfo.getCompanyId(), userInfo.getTenantId(), searchValue);
			
			StringBuilder sb = new StringBuilder();
			sb.append("<LISTVIEWDATA><ROWS>");

			for (MailSharedMailboxVO vo : sharedMailboxList) {
				sb.append("<ROW><CELL>");
				
				sb.append("<VALUE>");
				sb.append(commonUtil.cleanValue(vo.getShareName()));
				sb.append("</VALUE>");
				
				sb.append("<DATA1>group</DATA1>");
				
				sb.append("<DATA2>");
				sb.append(commonUtil.cleanValue(vo.getShareId()));
				sb.append("</DATA2>");
				
				sb.append("<DATA3>");
				sb.append(commonUtil.cleanValue(vo.getShareMail()));
				sb.append("</DATA3>");
				
				sb.append("<DATA4>");
				sb.append(commonUtil.cleanValue(vo.getCompanyName()));
				sb.append("</DATA4>");
				
				sb.append("</CELL></ROW>");
			}
			
			sb.append("</ROWS></LISTVIEWDATA>");
			
			returnData = sb.toString();
			
		} catch (Exception e) {
			returnData = "EXCEPTION";
			logger.error(e.getMessage(), e);
		}
        
        return returnData;
    }

	private String convertFilerootToMobileDownloadURL(String html) {
		if (StringUtils.isEmpty(html)) {
			return "";
		}

		return html.replace("/fileroot", MOBILE_FILEROOT_DOWNLOAD_URL);
	}

	private String adjustDate(String date, String period) throws Exception {
		logger.debug("adjustDate started. date={}, period={}", date, period);

		SimpleDateFormat dtFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String result = "";
		int year = 0;
		int month = 0;
		int week = 0;

		switch (period) {
			case "oneWeek":
				week = -1;
				break;
			case "oneMonth":
				month = -1;
				break;
			case "threeMonth":
				month = -3;
				break;
			case "sixMonth":
				month = -6;
				break;
			case "oneYear":
				year = -1;
				break;
			case "all":
				break;
		}

		Calendar cal = Calendar.getInstance();
		Date dt = dtFormat.parse(date);
		cal.setTime(dt);
		cal.add(Calendar.YEAR, year);
		cal.add(Calendar.MONTH, month);
		cal.add(Calendar.DATE, 7 * week);

		result = dtFormat.format(cal.getTime());
		logger.debug("adjustDate ended. result={}", result);

		return result;
	}

	/**
	 * 모바일 G/W 이메일 [GET] 열람 차단 메일 확인
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezemail/checkBlockedMail/folders/{folderId}/mails/{messageId}/users/{userId:.+}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public Object checkBlockedMail(HttpServletRequest request, @PathVariable String folderId, @PathVariable String messageId, @PathVariable String userId) throws Exception {
		logger.debug("MOBILE G/W MAIL checkBlockedMail started.");
		logger.debug("folderId=" + folderId + ",messageId=" + messageId + ",userId=" + userId);

		JSONObject result = new JSONObject();
		IMAPAccess ia = null;

		int blockedMail = 0;
		
		try {
			JSONObject data = new JSONObject();
			folderId = URLDecoder.decode(folderId, "UTF-8");
			
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			String domainName = ezCommonService.getTenantConfig("DomainName", info.getTenantId());
			String userEmail = info.getUserId() + "@" + domainName;
			String password = jspw;

			String useRDBOnlyMailList = ezCommonService.getTenantConfig("useRDBOnlyMailList", info.getTenantId());

			String ld = commonUtil.getTwoLetterLangFromLangNum(info.getLang());
			Locale locale = new Locale(ld);
			
			long uid = Long.parseLong(messageId);
			
			Map<String, String> mailInfo = null;
			
			if (useRDBOnlyMailList.equals("YES")) {
				mailInfo = ezEmailUtil.getMailInfo(userEmail, folderId, uid);
				
				if (mailInfo == null) {
					logger.error("Message not found. uid=" + uid);
					result.put("status", "error");
					result.put("code", 1);
					result.put("data", "");
					return result;
				}
			}
			
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userEmail, password, egovMessageSource, locale, ezEmailUtil);
			
			if (ia != null) {
				Folder f = ia.getFolder(folderId != null ? folderId : "");
				if (f == null || !f.exists()) {
					logger.error("Folder not found. folderPath=" + folderId);
				} else {
					f.open(Folder.READ_WRITE);

					logger.debug("folderId = " + folderId + ", uid = " + uid);

					Message message = null;

					if (f.isOpen() && f instanceof IMAPFolder) {
						message = ((IMAPFolder) f).getMessageByUID(uid);
						if (message != null) {

							logger.debug("message=" + message);

							String[] messageIds = message.getHeader("Message-ID");
							logger.debug("Message-ID=" + messageIds[0]);

							blockedMail = ezEmailService.checkBlockedMailByMessageId(messageIds[0]);

							logger.debug("blockedMail=" + blockedMail);
							
							data.put("blockedMail", blockedMail);
							
							result.put("status", "ok");
							result.put("code", 0);
							result.put("data", data);
						}
					}
				}
			}
		} catch (Exception e){
			logger.error(e.getMessage(), e);
			
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		} finally {
			if (ia != null) {
				ia.close();
			}
		}
		return result;
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(value="/mobile/ezemail/getTaglist/users/{userId:.+}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public Object mMailTagList(HttpServletRequest request, @PathVariable String userId) throws Exception {
		logger.debug("MOBILE G/W MAIL mMailTagList started.");
		logger.debug("userId=" + userId);

		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			String domainName = ezCommonService.getTenantConfig("DomainName", info.getTenantId());
			
			String userEmail = userId + "@" + ezCommonService.getTenantConfig("DomainName", info.getTenantId());

			Rest.RestBuilder jgwRestBuilder = rest.jgw().url("/jMochaEzEmail/getUserTagList").formParam("userAccount", userEmail);

			JgwResult jgwResult = jgwRestBuilder.exchangeJgwResult();
			
			logger.debug("jgw getUserTagFromMail userEmail: {}, jgwResultCode: {}", userEmail, jgwResult.getResultCode());

			JSONObject data = new JSONObject();
			
			if (jgwResult.succeeded()) {
				data.put("tags", jgwResult.getResult());
			}
			
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", data);
		} catch (PatternSyntaxException e) {
			logger.error(e.getMessage(), e);

			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			
		} catch (Exception e) {
			logger.error(e.getMessage(), e);

			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}

		logger.debug("MOBILE G/W MAIL mMailTagList ended.");
		return result;
	}

	@RequestMapping(value="/mobile/ezemail/addTag/users/{userId:.+}", method= RequestMethod.POST, produces="application/json;charset=utf-8")
	public Object mMailAddTag(HttpServletRequest request, @PathVariable String userId,  @RequestBody JSONObject jsonObject) throws Exception {
		logger.debug("MOBILE G/W MAIL mMailAddTag started.");
		String folderPath = "";
		Long mailUid = 0L;
		String tagName = "";
		
		if (jsonObject.get("folderPath") != null) {
			folderPath = (String) jsonObject.get("folderPath");
		}

		if (jsonObject.get("mailUid") != null) {
			mailUid = Long.parseLong(jsonObject.get("mailUid").toString());
		}

		if (jsonObject.get("tagName") != null) {
			tagName = (String) jsonObject.get("tagName");
		}

		JSONObject result = new JSONObject();

		try {

			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			String domainName = ezCommonService.getTenantConfig("DomainName", info.getTenantId());

			String userAccount = userId + "@" + domainName;

			IMAPAccess ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"), userAccount, jspw, egovMessageSource, Locale.KOREAN, ezEmailUtil);
			if (ia != null){
				Folder mailbox = ia.getFolder(folderPath);

				if (mailbox == null || !mailbox.exists()) {
					throw new FolderNotFoundException(mailbox, "not exists folder: " + folderPath);
				}

				mailbox.open(Folder.READ_WRITE);
				Message message = ((IMAPFolder) mailbox).getMessageByUID(mailUid);
				tagName = tagName.trim().replaceAll("\\s", "_");
				ezEmailUtil.setTagFlag(message, userAccount, tagName, true);
				mailbox.close(true);
			}
			
			result.put("status", "ok");
			result.put("code", 0);
		} catch (MessagingException e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
		}
		
		logger.debug("MOBILE G/W MAIL mMailAddTag ended.");
		return result;
	}

	@RequestMapping(value="/mobile/ezemail/deleteTag/users/{userId:.+}", method= RequestMethod.DELETE, produces="application/json;charset=utf-8")
	public Object mMailDeleteTag(HttpServletRequest request, @PathVariable String userId,  @RequestBody JSONObject jsonObject) throws Exception {
		logger.debug("MOBILE G/W MAIL mMailDeleteTag started.");
		String folderPath = "";
		Long mailUid = 0L;
		String tagName = "";

		if (jsonObject.get("folderPath") != null) {
			folderPath = (String) jsonObject.get("folderPath");
		}

		if (jsonObject.get("mailUid") != null) {
			mailUid = Long.parseLong(jsonObject.get("mailUid").toString());
		}

		if (jsonObject.get("tagName") != null) {
			tagName = (String) jsonObject.get("tagName");
		}

		JSONObject result = new JSONObject();

		try {

			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			String domainName = ezCommonService.getTenantConfig("DomainName", info.getTenantId());

			String userAccount = userId + "@" + domainName;

			JgwResult deleteResult = rest.jgw().url("/jMochaEzEmail/deleteTagFromMail")
					.formParam("userAccount", userAccount)
					.formParam("folderPath", folderPath)
					.formParam("mailUid", mailUid)
					.formParam("tagName", tagName)
					.exchangeJgwResult();
			logger.debug("jgw deleteTagFromMail result: {}", deleteResult);
			
			if (deleteResult.succeeded()) {
				result.put("status", "ok");
				result.put("code", 0);
				
			} else {
				result.put("status", "error");
				result.put("code", 1);
			}
			
		} catch (MessagingException e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
		}

		logger.debug("MOBILE G/W MAIL mMailDeleteTag ended.");
		return result;
	}

	@RequestMapping(value="/mobile/ezemail/sendIcalResponseMail/users/{userId:.+}", method= RequestMethod.POST, produces="application/json;charset=utf-8")
	@ResponseBody
	public Object mSendIcalResponseMail(HttpServletRequest request, @PathVariable String userId,  @RequestBody IcalVO icalVO) throws Exception {
		logger.debug("MOBILE G/W MAIL mSendIcalResponseMail started.");

		String eventUid = Optional.ofNullable(icalVO.getUid()).map(Uid::getValue).map(s -> s.replaceFirst("^UID:", "").trim()).orElse("");
		boolean isAllDay = icalVO.isDtAllDay();
		Date startDt = icalVO.toStartDate();
		Date endDt = icalVO.toEndDate();
		String summary = icalVO.getSummaryStr();
		String organizer = icalVO.getOrganizerCn();
		String status = icalVO.getStatus();
		String orgUrl = icalVO.getUidStr();
		String location = icalVO.getLocationStr();

		String serverName = request.getHeader("x-user-host");
		MCommonVO info = mOptionService.commonInfo(serverName, userId);
		String domainName = ezCommonService.getTenantConfig("DomainName", info.getTenantId());
		String userEmail = info.getUserId() + "@" + domainName;

		JSONObject result = new JSONObject();

		// 초대받은 이벤트 정보
		logger.debug("eventUid = {}, isAllDay = {}, startDt = {}, endDt = {}, summary = {}, organizer = {}, status = {}, location = {}", eventUid, isAllDay, startDt, endDt, summary, organizer, status, location);

		VEvent event = ezEmailUtil.createTimeEvent(isAllDay, startDt, endDt, summary, eventUid);

		event.getProperties().add(Method.REPLY); // 응답 메일 표시

		Organizer organizer1 = new Organizer(URI.create("mailto:" + organizer));
		event.getProperties().add(organizer1);

		logger.debug("event= {}", event);
		PartStat partStat = "DECLINED".equalsIgnoreCase(status) ? PartStat.DECLINED :
				"TENTATIVE".equalsIgnoreCase(status) ? PartStat.TENTATIVE :
						PartStat.ACCEPTED;

		// 참석자 추가 (응답 상태 설정)
		Attendee attendee = new Attendee(URI.create("mailto:" + userEmail));
		attendee.getParameters().add(partStat); // '수락' 상태 설정
		attendee.getParameters().add(new Cn(info.getUserName()));

		event.getProperties().add(attendee);
		event.getProperties().add(new Location(location));

		// 캘린더 객체 생성
		net.fortuna.ical4j.model.Calendar calendar = new net.fortuna.ical4j.model.Calendar();
		calendar.getProperties().add(Version.VERSION_2_0);
		calendar.getProperties().add(CalScale.GREGORIAN);
		calendar.getProperties().add(new ProdId("-//Example Corp//iCal4j 3.0//EN"));
		calendar.getProperties().add(Method.REPLY);
		calendar.getComponents().add(event);

		String password = jspw;
		SMTPAccess sa = SMTPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.SMTPPort"), userEmail, password);

		// 메일 작성
		MimeMessage message = sa.createMimeMessage();
		message.setFrom(new InternetAddress(userEmail));
		message.addRecipient(Message.RecipientType.TO, new InternetAddress(organizer));
		message.setSubject(summary);

		// iCalendar 첨부
		MimeBodyPart calendarPart = new MimeBodyPart();
		calendarPart.setHeader("Content-Class", "urn:content-classes:calendarmessage");
		calendarPart.setHeader("Content-Type", "text/calendar; charset=UTF-8; method=REPLY");
		calendarPart.setHeader("Content-Disposition", "inline");
		calendarPart.setContent(calendar.toString(), "text/calendar; charset=UTF-8; method=REPLY");

		MimeBodyPart textPart = new MimeBodyPart();
		textPart.setText("일정 응답 메일입니다.", "utf-8");

		MimeMultipart multipart = new MimeMultipart("alternative");
		multipart.addBodyPart(textPart);
		multipart.addBodyPart(calendarPart);
		message.setContent(multipart);

		IcalVO vo = new IcalVO();
		vo.setUidStr(eventUid);
		vo.setAttendeeStr(userEmail);
		vo.setStatus(status);

		IMAPAccess ia = null;
		try {
			// 메일 전송
			Transport.send(message);

			String ld = commonUtil.getTwoLetterLangFromLangNum(info.getLang());
			Locale locale = new Locale(ld);

			// 응답 정보 저장
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userEmail, password, egovMessageSource, locale, ezEmailUtil);

			int index = orgUrl.lastIndexOf("/");

			if (index != -1) {
				String orgMsgFolderPath = orgUrl.substring(0, index);
				long orgMsgUid = Long.parseLong(orgUrl.substring(index + 1));

				logger.debug("orgMsgFolderPath=" + orgMsgFolderPath + ",orgMsgUid=" + orgMsgUid);

				Folder orgMsgFolder = ia.getFolder(orgMsgFolderPath);
				orgMsgFolder.open(Folder.READ_WRITE);

				Message orgMessage = ((IMAPFolder) orgMsgFolder).getMessageByUID(orgMsgUid);

				if (orgMessage != null) {
					if (!ezEmailUtil.hasIcalEventUidFlag(orgMessage)) {
						ezEmailUtil.setIcalEventUidFlag(orgMessage, true, eventUid);
					}

					ezEmailUtil.setIcalStatusFlag(orgMessage, true, status);
					ezEmailUtil.setIcalResponseDtFlag(orgMessage, true);

				}

				orgMsgFolder.close(true);

				result.put("status", "ok");
				result.put("code", 0);
			}
		} catch (MessagingException e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
		} finally {
			if (ia != null) {
				ia.close();
				ia = null;
			}
		}
		logger.debug("calendar = {}", calendar.toString());
		logger.debug("MOBILE G/W MAIL mSendIcalResponseMail ended.");
		return result;
	}
	
}
