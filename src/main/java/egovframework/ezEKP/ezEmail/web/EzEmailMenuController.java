package egovframework.ezEKP.ezEmail.web;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.nio.charset.Charset;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Optional;
import java.util.Properties;
import java.util.Set;
import java.util.TimeZone;
import java.util.UUID;
import java.util.stream.Collectors;
import java.util.zip.ZipEntry;
import java.util.zip.ZipException;
import java.util.zip.ZipInputStream;
import java.util.zip.ZipOutputStream;

import javax.annotation.Resource;
import javax.mail.Flags;
import javax.mail.Folder;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import egovframework.ezEKP.ezEmail.vo.MailboxProgressVO;
import egovframework.let.utl.fcc.service.EgovStringUtil;
import org.apache.commons.codec.binary.Base64;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringEscapeUtils;
import org.apache.commons.lang3.StringUtils;
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
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
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
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.rest.JgwResult;
import egovframework.let.utl.rest.Rest;

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
	
	@Autowired
	private EzOrganAdminService ezOrganAdminService;

	@Autowired
	private EzOrganService ezOrganService;

	@Autowired
	private Rest rest;
	/**
	 * 메일 왼쪽화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailLeft.do", method = RequestMethod.GET)
	public String showMailLeft(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request, @RequestParam(name = "withoutnodeselect", defaultValue = "false") boolean withoutNodeSelect) throws Exception {
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
		String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", loginInfo.getTenantId());
		String useSpamSniper = ezCommonService.getTenantConfig("useSpamSniper", loginInfo.getTenantId());
		logger.debug("userEmail=" + userEmail + ",usePreviewSubTree=" + usePreviewSubTree + ",useBottomFrameOnly=" + useBottomFrameOnly 
				+ ",useMailBoxBackUp=" + useMailBoxBackUp + ",useMailReceiveScreen=" + useMailReceiveScreen + ",useSharedMailbox=" + useSharedMailbox);
		boolean useApprMail = commonUtil.checkTenantConfigBool(loginInfo.getTenantId(), "useApprMail", "false")
							? ezEmailUtil.useApprMailPolicy(loginInfo.getTenantId(), loginInfo.getCompanyID()) : false; // 2024-03-06 이사라 - 승인메일 사용 여부
        boolean isApprMailApprover = useApprMail ? ezEmailService.checkApprMailApprover(loginInfo.getTenantId(), loginInfo.getCompanyID(), loginInfo.getId()) : false; // 2024-03-06 이사라 - 승인자 여부 확인
		logger.debug("useApprMail={}, isApprMailApprover={}", useApprMail, isApprMailApprover);
        
		if (useMailReceiveScreen.equals("YES")) {
			model.addAttribute("useMailReceiveScreen", useMailReceiveScreen);
		}
		
		MailGeneralVO mailGeneralVO = ezEmailService.getMailGeneral(loginInfo.getTenantId(), loginInfo.getId()).get(0);
		
		if (usePreviewSubTree.equals("YES")) {
			String previewSubTree = mailGeneralVO.getPreviewSubTree();
			model.addAttribute("previewSubTree", previewSubTree);
		}
		
		LoginVO user = commonUtil.userInfo(loginCookie);
		
		StringBuilder rootFolderXML = new StringBuilder();
		StringBuilder rootAddressXML = new StringBuilder();
		
		// 전체메일
		try {
			String displayName = egovMessageSource.getMessage("email.allmail", locale);

			rootFolderXML.append("<node imgidx='1'");
			rootFolderXML.append(" caption='" + displayName + "'");
			rootFolderXML.append(" foldername='" + displayName + "'");
			rootFolderXML.append(" orgBoxName='0'");
			rootFolderXML.append(" fullcaption='_ALLMAIL'");
			rootFolderXML.append(" href='allMail'");
			rootFolderXML.append(" style='font-weight:bold'");

			rootFolderXML.append("></node>");
		} catch (Exception e) {
			logger.error("Error get unread message count: " + e.getMessage());
			logger.error(e.getMessage(), e);
		}
		
		IMAPAccess ia = null;
		try {
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userEmail, password, egovMessageSource, locale, ezEmailUtil);
			
			String useDefaultFoldersForLangOnly = ezCommonService.getTenantConfig("UseDefaultFoldersForLangOnly", loginInfo.getTenantId());
			boolean isUseDefaultFoldersForLangOnly = useDefaultFoldersForLangOnly.equals("YES") ? true : false;

			if (ia == null){
				throw new Exception("ia is null");
			}
			List<Folder> rootMailFolderList = ia.getTopLevelFolders(true, isUseDefaultFoldersForLangOnly);
			
			for (int i = 0, j = 0; i < rootMailFolderList.size(); i++) {
				Folder folder = rootMailFolderList.get(i);
				
				String folderId = folder.getName();
				String displayName = ezEmailUtil.getDisplayNameFromFolderId(folderId, locale);
				
				int folderUnreadMessageCount = folder.getUnreadMessageCount();
				
				rootFolderXML.append("<node imgidx='1'");
				
				if (folderUnreadMessageCount > 0) {
					rootFolderXML.append(" caption='" + displayName + "'");
					rootFolderXML.append(" foldercount='" + folderUnreadMessageCount + "'");
				} else {
					rootFolderXML.append(" caption='" + displayName + "'");
				}
				
				rootFolderXML.append(" foldername='" + displayName + "'");

				if (folderId.equalsIgnoreCase(ezEmailUtil.getInboxFolderId())) {
					rootFolderXML.append(" orgBoxName='1'");
					rootFolderXML.append(" fullcaption='_INBOX'"); //수정
				} else if (folderId.equalsIgnoreCase(ezEmailUtil.getSentFolderId(locale))) {
					rootFolderXML.append(" orgBoxName='2'");
					rootFolderXML.append(" fullcaption='_SENT'"); //수정
				} else if (folderId.equalsIgnoreCase(ezEmailUtil.getDraftsFolderId(locale))) {
					rootFolderXML.append(" orgBoxName='3'");
					rootFolderXML.append(" fullcaption='_DRAFT'"); //수정
				} else if (folderId.equalsIgnoreCase(ezEmailUtil.getTrashFolderId(locale))) {
					rootFolderXML.append(" orgBoxName='4'");
					rootFolderXML.append(" fullcaption='_DELETE'"); //수정
				} else if (folderId.equalsIgnoreCase(ezEmailUtil.getPersonalFolderId(locale))) {
					rootFolderXML.append(" orgBoxName='5'");
					rootFolderXML.append(" fullcaption='_PERSONAL'"); //수정
				} else if (folderId.equalsIgnoreCase(ezEmailUtil.getJunkFolderId(locale))) {
					rootFolderXML.append(" orgBoxName='6'");
					rootFolderXML.append(" fullcaption='_JUNK'"); //수정
				} else {
					rootFolderXML.append(" orgBoxName='" + ((j++) + 7) + "'");
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
		} catch (MessagingException e) {
			logger.error("Error get unread message count: " + e.getMessage());
			logger.error(e.getMessage(), e);	
		} catch (Exception e) {
			logger.error("Error get unread message count: " + e.getMessage());
			logger.error(e.getMessage(), e);
		} finally {
			if (ia != null) {
				ia.close();
			}
		}
		
		if (useSharedMailbox.equals("YES")) {
			List<Map<String, String>> shareInfoList = ezEmailService.getUserSharedMailboxList(loginInfo.getId(), true, loginInfo.getTenantId());
			model.addAttribute("shareInfoList", shareInfoList);
		}
		
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
		
		String spamSniperUrl = ezCommonService.getTenantConfig("spamSniperUrl", loginInfo.getTenantId());
		String spamSniperAuthKey = ezCommonService.getTenantConfig("spamSniperAuthKey", loginInfo.getTenantId());
		String spamSniperAuthIv = ezCommonService.getTenantConfig("spamSniperAuthIv", loginInfo.getTenantId());
		String spamSniperUnixTimeStr = ezCommonService.getTenantConfig("spamSniperUnixTime", loginInfo.getTenantId());
		long spamSniperUnixTime;

		try {
			spamSniperUnixTime = Long.parseLong(spamSniperUnixTimeStr);
		} catch (NumberFormatException ex) {
			spamSniperUnixTime = 0;
		}

		String cryptResult = "";
		if (useSpamSniper.equals("YES")) {
			cryptResult = ezEmailUtil.spamSniperEnc(loginInfo.getEmail(), spamSniperAuthKey, spamSniperAuthIv, spamSniperUnixTime);
			model.addAttribute("cryptResult", cryptResult);
		}
		
		model.addAttribute("useSpamSniper", useSpamSniper);
		model.addAttribute("spamSniperUrl", spamSniperUrl);
		model.addAttribute("mailServerAddress", mailServerAddress);
		model.addAttribute("rootFolderXML", rootFolderXML.toString());
		model.addAttribute("rootAddressXML", rootAddressXML.toString());
		model.addAttribute("funCode", funCode);
		model.addAttribute("subCode", subCode);
		model.addAttribute("usePreviewSubTree", usePreviewSubTree);
		model.addAttribute("useBottomFrameOnly", useBottomFrameOnly);
		model.addAttribute("useMailBoxBackUp", useMailBoxBackUp);
		model.addAttribute("useSharedMailbox", useSharedMailbox);
		model.addAttribute("refreshInterval", mailGeneralVO.getRefreshInterval());
		model.addAttribute("withoutNodeSelect", withoutNodeSelect);
		model.addAttribute("useApprMail", useApprMail); // 승인메일 정책에서 하나라도 사용이면 true
		model.addAttribute("isApprMailApprover", isApprMailApprover);
		
		String useBizmekaSpambox = ezCommonService.getTenantConfig("UseBizmekaSpambox", loginInfo.getTenantId());
		
		if (useBizmekaSpambox.equals("YES")) {
			String authString = userEmail + ".." + (System.currentTimeMillis()/1000 - 100*60);
			
			logger.debug("authString={}", authString);
			
			String credentialForBizmekaSpambox = ezEmailUtil.getCredentialForBizmekaSpambox(authString);
			
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
		model.addAttribute("dotNetIntegration", dotNetIntegration);
		
		
		boolean useSpamOut = "YES".equalsIgnoreCase(ezCommonService.getTenantConfig("useSpamOut", loginInfo.getTenantId()));
		model.addAttribute("useSpamOut", useSpamOut);
		
		if (useSpamOut) {
			String spamOutLoginURI = ezCommonService.getTenantConfig("spamOutLoginURI", loginInfo.getTenantId());
			String userEmailBase64 = new String(Base64.encodeBase64(userEmail.getBytes("UTF-8")), "UTF-8");
			String userParameter = URLEncoder.encode(userEmailBase64, "UTF-8");
			spamOutLoginURI = String.format(spamOutLoginURI, userParameter);
			logger.debug("userEmail {}, base64: {}, url encoded: {}", userEmail, userEmailBase64, userParameter);
			logger.debug("spam uri: {}", spamOutLoginURI);
			model.addAttribute("spamOutLoginURI", spamOutLoginURI);
		}

		// 메일 태그를 사용중인지 확인
		boolean useMailTag = "YES".equalsIgnoreCase(ezCommonService.getTenantConfig("useMailTag", loginInfo.getTenantId()));

		// 메일 태그를 사용한다면 사용자가 기능을 활성화 했는지 확인
		if (useMailTag) {
			try {
				logger.debug("jgw getTagConfig started.");
				JgwResult jgwTagConfig = rest.jgw().url("/jMochaEzEmail/getTagConfig").formParam("userAccount", userEmail).exchangeJgwResult();
				logger.debug("jgw getTagConfig ended, success={}", jgwTagConfig.succeeded());
				// 사용자가 기능을 활성화 했으면 true, 아니라면 false
				useMailTag = jgwTagConfig.succeeded() && jgwTagConfig.getResultAsJsonObject().get("enable").getAsBoolean();

				// 활성화된 사용자라면 태그 목록 가져오기
				if (useMailTag) {
					logger.debug("jgw getUserTagList started.");
					JgwResult jgwUserTagList = rest.jgw().url("/jMochaEzEmail/getUserTagList").formParam("userAccount", userEmail).exchangeJgwResult();
					logger.debug("jgw getUserTagList ended, success={}", jgwUserTagList.succeeded());

					if (jgwUserTagList.succeeded()) {
						model.addAttribute("tags", jgwUserTagList.getResult());
					}
				}
			} catch (RuntimeException e) {
				logger.error("jgw fetch error", e);
				useMailTag = false;
			} catch (Exception e) {
				logger.error("jgw fetch error", e);
				useMailTag = false;
			}
		}

		model.addAttribute("useMailTag", useMailTag);

		logger.debug("showMailLeft ended.");
		
		if(funCode.equals("2")) {
			return "ezAddress/addressLeft";
		}
		return "ezEmail/mailLeft";
	}
	
	/**
	 * 메일 폴더 리스트 정보 호출 함수
	 */
	@RequestMapping(value="/ezEmail/getFolderList.do", produces="text/xml; charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getFolderList(@CookieValue("loginCookie") String loginCookie, Locale locale, HttpServletRequest request) throws Exception {
		logger.debug("getFolderList started.");
		
		List<String> userInfo = commonUtil.getUserIdAndPassword(loginCookie);
		String password  = userInfo.get(1);
		
		LoginVO loginInfo = commonUtil.userInfo(loginCookie);
		String domainName = ezCommonService.getTenantConfig("DomainName", loginInfo.getTenantId());
		String userEmail = loginInfo.getId() + "@" + domainName;
		String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", loginInfo.getTenantId());

		if (useSharedMailbox.equals("YES")) {
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
		}
		
		logger.debug("userId=" + loginInfo.getId() + ",userEmail=" + userEmail);
		
		Document doc = commonUtil.convertRequestToDocument(request);
		if (doc != null){
			String folderName = doc.getElementsByTagName("URL").item(0).getTextContent();
			String bcount = doc.getElementsByTagName("BCOUNT").item(0).getTextContent();
			logger.debug("folderName=" + folderName);

			boolean isSubscribe = true;
			String folderManamger = request.getParameter("fm");

			if (folderManamger != null && folderManamger.equals("1")) {
				isSubscribe = false;
			}

			String allMail = StringUtils.defaultString(request.getParameter("am"), "n");
			boolean showAllMail = allMail.equalsIgnoreCase("y");

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
								subFolderXML.append(" caption='" + displayName + "'");
								subFolderXML.append(" foldercount='" + fd.getUnreadMessageCount() + "'");
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
					if (showAllMail) {
						// 전체메일
						try {
							String displayName = egovMessageSource.getMessage("email.allmail", locale);
							subFolderXML.append("<node imgidx='1'");
							subFolderXML.append(" caption='" + displayName + "'");
							subFolderXML.append(" foldername='" + displayName + "'");
							subFolderXML.append(" orgBoxName='0'");
							subFolderXML.append(" fullcaption='_ALLMAIL'");
							subFolderXML.append(" href='allMail'");

							subFolderXML.append("></node>");
						} catch (Exception e) {
							logger.error("Error get unread message count: " + e.getMessage());
							logger.error(e.getMessage(), e);
						}
					}

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
								subFolderXML.append(" caption='" + displayName + "'");
								subFolderXML.append(" foldercount='" + fd.getUnreadMessageCount() + "'");
							} else {
								subFolderXML.append(" caption='" + displayName + "'");
							}
						} else {
							subFolderXML.append(" caption='" + displayName + "'");
						}

						subFolderXML.append(" foldername='" + displayName + "'");

						if (folderId.equalsIgnoreCase(ezEmailUtil.getInboxFolderId())) {
							subFolderXML.append(" orgBoxName='1'");
							subFolderXML.append(" fullcaption='_INBOX'"); //수정
						} else if (folderId.equalsIgnoreCase(ezEmailUtil.getSentFolderId(locale))) {
							subFolderXML.append(" orgBoxName='2'");
							subFolderXML.append(" fullcaption='_SENT'"); //수정
						} else if (folderId.equalsIgnoreCase(ezEmailUtil.getDraftsFolderId(locale))) {
							subFolderXML.append(" orgBoxName='3'");
							subFolderXML.append(" fullcaption='_DRAFT'"); //수정
						} else if (folderId.equalsIgnoreCase(ezEmailUtil.getTrashFolderId(locale))) {
							subFolderXML.append(" orgBoxName='4'");
							subFolderXML.append(" fullcaption='_DELETE'"); //수정
						} else if (folderId.equalsIgnoreCase(ezEmailUtil.getPersonalFolderId(locale))) {
							subFolderXML.append(" orgBoxName='5'");
							subFolderXML.append(" fullcaption='_PERSONAL'"); //수정
						} else if (folderId.equalsIgnoreCase(ezEmailUtil.getJunkFolderId(locale))) {
							subFolderXML.append(" orgBoxName='6'");
							subFolderXML.append(" fullcaption='_JUNK'"); //수정
						} else {
							subFolderXML.append(" orgBoxName='" + ((j++) + 7) + "'");
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
				logger.error(e.getMessage(), e);
			} finally {
				if (ia != null) {
					ia.close();
				}
			}
			logger.debug("getFolderList ended.");
			return subFolderXML.toString();
		}else{
			logger.debug("getFolderList ended.");
			return null;
		}
	}
	
	/**
	 * 읽지않은 메시지 개수 정보 호출 함수
	 */
	@RequestMapping(value="/ezEmail/getFolderUnreadCount.do", produces="text/xml; charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getFolderUnreadCount(@CookieValue("loginCookie") String loginCookie, Locale locale, HttpServletRequest request) throws Exception {
		logger.debug("getFolderUnreadCount started.");
		
		List<String> userInfo = commonUtil.getUserIdAndPassword(loginCookie);
		String password  = userInfo.get(1);
		
		LoginVO loginInfo = commonUtil.userInfo(loginCookie);
		String domainName = ezCommonService.getTenantConfig("DomainName", loginInfo.getTenantId());
		String userEmail = loginInfo.getId() + "@" + domainName;
		
		Document doc = commonUtil.convertRequestToDocument(request);
		String folderName = null;
		int folderUnreadCount = 0;
		int totalUnreadCount = 0;

		if (doc != null){
			folderName = doc.getElementsByTagName("URL").item(0).getTextContent();
			logger.debug("folderName=" + folderName);

			String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", loginInfo.getTenantId());

			if (useSharedMailbox.equals("YES")) {
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
			}

			logger.debug("userId=" + loginInfo.getId() + ",userEmail=" + userEmail);

			IMAPAccess ia = null;

			try {
				ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
						userEmail, password, egovMessageSource, locale, ezEmailUtil);

				if (ia != null && !"allMail".equalsIgnoreCase(folderName)){
					folderUnreadCount = ia.getUnreadCount(folderName);
				} else if (ia != null) { // allMail - 전체메일
					List<String> folderNames = ia.getAllFolderNames();
					
					for (String name : folderNames) {
						folderUnreadCount += ia.getUnreadCount(name);
					}
				}
			} catch (RuntimeException e) {
				logger.error(e.getMessage(), e);
			} catch (Exception e) {
				logger.error(e.getMessage(), e);
			} finally {
				if (ia != null) {
					ia.close();
				}
			}

			totalUnreadCount = ezEmailService.getTotalUnreadCount(userEmail.split("@")[0], loginInfo.getTenantId());

		}
		String unreadCountXML =  String.format("<DATA><FOLDERUNREADCOUNT>%d</FOLDERUNREADCOUNT><TOTALUNREADCOUNT>%d</TOTALUNREADCOUNT></DATA>",
				folderUnreadCount, totalUnreadCount);

		logger.debug("getFolderUnreadCount ended.");
		
		return unreadCountXML;
	}
	
	/**
	 * 편지함들의 읽지않은 메시지 개수 정보 호출 함수
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/ezEmail/getUnreadCountAll.do", method=RequestMethod.POST, produces="application/json; charset=utf-8")
	@ResponseBody
	public JSONObject getUnreadCountAll(@CookieValue("loginCookie") String loginCookie, Locale locale, @RequestBody String bodyData) throws Exception {
		logger.debug("getUnreadCountAll started.");
		logger.debug("bodyData=" + bodyData);
		
		JSONObject resultObject = new JSONObject();
		String resultCode = "OK";
		IMAPAccess ia = null;
		
		try {
			JSONParser jsonParser = new JSONParser();
			JSONObject requestObject = (JSONObject) jsonParser.parse(bodyData);
			JSONArray requestMailboxList = (JSONArray) requestObject.get("mailboxList");
			
			List<String> userIdAndPassword = commonUtil.getUserIdAndPassword(loginCookie);
			String password  = userIdAndPassword.get(1);
			
			LoginVO userInfo = commonUtil.userInfo(loginCookie);
			String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
			String userAccount = userInfo.getId() + "@" + domainName;
			
			String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", userInfo.getTenantId());
			String shareId = null;
			
			if (useSharedMailbox.equals("YES")) {
				shareId = (String) requestObject.get("shareId");
				
				if (shareId != null) {
					logger.debug("shareId=" + shareId);
					
					if (!ezEmailService.checkUserShareId(userInfo.getId(), shareId, userInfo.getTenantId())) {
						logger.debug("the user cannot access the shareId.");
						logger.debug("getFolderUnreadCount ended.");
						
						throw new Exception("CANNOT_ACCESS_SHAREID");
					}
					
					userAccount = shareId + "@" + domainName;
				}
			}
			
			logger.debug("userId=" + userInfo.getId() + ",userAccount=" + userAccount);
			
			JSONObject unreadCountMap = new JSONObject();
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userAccount, password, egovMessageSource, locale, ezEmailUtil);

			if (ia != null){
				for (int i = 0; i < requestMailboxList.size(); i++) {
					String mailboxName = (String) requestMailboxList.get(i);
					unreadCountMap.put((mailboxName != null ? mailboxName : ""), ia.getUnreadCount(mailboxName));
				}
			}

			int totalUnreadCount = ezEmailService.getTotalUnreadCount(userInfo.getId(), userInfo.getTenantId());
			int totalUnreadCountInAllAccounts = totalUnreadCount;
			
			if (useSharedMailbox.equals("YES")) {
				List<Map<String, String>> shareInfoList = ezEmailService.getUserSharedMailboxList(userInfo.getId(), true, userInfo.getTenantId());
				resultObject.put("shareInfoList", shareInfoList);
				
				for (Map<String, String> item : shareInfoList) {
					String unreadCountStr = item.get("totalUnreadCount");
					
					if (unreadCountStr != null) {
						try {
							int unreadCountInShared = Integer.parseInt(unreadCountStr);
							
							totalUnreadCountInAllAccounts += unreadCountInShared;
						} catch (NumberFormatException ne) {
							logger.error(ne.getMessage(), ne);
						}
					}
				}
			}
			
			resultObject.put("shareId", shareId == null ? "" : shareId);
			resultObject.put("unreadCountMap", unreadCountMap);
			resultObject.put("totalUnreadCount", totalUnreadCount);
			resultObject.put("totalUnreadCountInAllAccounts", totalUnreadCountInAllAccounts);
		} catch (ParseException e) {
			resultCode = e.getMessage();
			logger.error(e.getMessage(), e);
		} catch (Exception e) {
			resultCode = e.getMessage();
			logger.error(e.getMessage(), e);
		} finally {
			if (ia != null) {
				ia.close();
			}
		}
		
		resultObject.put("resultCode", resultCode);
		
		logger.debug("resultObject=" + resultObject.toJSONString());
		logger.debug("getUnreadCountAll ended.");
		return resultObject;
	}
	
	/**
	 * PC에서 메일 가져오기 실행 함수
	 */
	@RequestMapping(value="/ezEmail/mailImportUpload.do", produces = "text/plain; charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String mailImportUpload(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, MultipartHttpServletRequest request) throws Exception{
		logger.debug("mailImportUpload started.");
		
		String strResult = "ERROR";
		
		List<String> userInfo = commonUtil.getUserIdAndPassword(loginCookie);
		String password  = userInfo.get(1);
		
		LoginVO loginInfo = commonUtil.userInfo(loginCookie);
		String domainName = ezCommonService.getTenantConfig("DomainName", loginInfo.getTenantId());
		String userEmail = loginInfo.getId() + "@" + domainName;
		String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", loginInfo.getTenantId());

		if (useSharedMailbox.equals("YES")) {
			String shareId = request.getParameter("shareId");
			logger.debug("shareId=" + shareId);
			
			if (shareId != null) {
				if (!ezEmailService.checkUserShareId(loginInfo.getId(), shareId, loginInfo.getTenantId())) {
					logger.debug("the user cannot access the shareId.");
					logger.debug("mailImportUpload ended.");
					
					return "";
				}
				
				userEmail = shareId + "@" + domainName;
			}
		}
		
		logger.debug("userId=" + loginInfo.getId() + ",userEmail=" + userEmail);
		
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

				if (ia != null){
					Folder folder = ia.getFolder(folderId != null ? folderId : "");

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
								} catch (IOException e) {logger.debug("e.message=" + e.getMessage());
								} catch (Exception e) {logger.debug("e.message=" + e.getMessage());}
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
				}
				
			} catch (MessagingException e) {
				strResult = "ERROR : " + e.getMessage();
				logger.error(e.getMessage(), e);
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
	 * 
	 * 사용하지 않는 코드(원래는 IE9에서 사용)여서 일단 method = RequestMethod.GET 로 수정함
	 */
	@RequestMapping(value="/ezEmail/mailImportUploadX.do", produces = "text/plain; charset=utf-8", method = RequestMethod.GET)
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
		String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", loginInfo.getTenantId());

		if (useSharedMailbox.equals("YES")) {
			String shareId = request.getParameter("shareId");
			logger.debug("shareId=" + shareId);
			
			if (shareId != null) {
				if (!ezEmailService.checkUserShareId(loginInfo.getId(), shareId, loginInfo.getTenantId())) {
					logger.debug("the user cannot access the shareId.");
					logger.debug("mailImportUploadX ended.");
					
					return "";
				}
				
				userEmail = shareId + "@" + domainName;
			}
		}
		
		logger.debug("userId=" + loginInfo.getId() + ",userEmail=" + userEmail);
		
		SMTPAccess sa = SMTPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.SMTPPort"),
				userEmail, password);
		
		IMAPAccess ia = null;
		try {
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userEmail, password, egovMessageSource, locale, ezEmailUtil);

			if (ia != null){
				Folder folder = ia.getFolder(folderId != null ? folderId : "");

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
			}
			
		} catch (MessagingException e) {
			strResult = "ERROR : " + e.getMessage();
			logger.error(e.getMessage(), e);
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
	@RequestMapping(value="/ezEmail/mailboxImportZip.do", method = RequestMethod.POST)
	public String mailboxImportZip(@CookieValue("loginCookie") String loginCookie, MultipartHttpServletRequest request, Locale locale, Model model) throws Exception{
		logger.debug("mailboxImportZip started.");

		//Session session = null;
		String userkey = request.getParameter("userkey");
		String encryptPw = request.getParameter("encryptPw");
		String retryPathId = commonUtil.detectPathTraversal(request.getParameter("tempId"));
		String folderPath = request.getParameter("folderPath");
		List<MultipartFile> multiFile = request.getFiles("file1");
		logger.debug("userkey=" + userkey + ",encryptPw=" + encryptPw + ",retryPathId=" + retryPathId + ",folderPath" + folderPath);

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		int tenantId = userInfo.getTenantId();
		String useEncryptZipForEmail = ezCommonService.getTenantConfig("UseEncryptZipForEmail", tenantId);
		logger.debug("useEncryptZipForEmail=" + useEncryptZipForEmail);
		
		String domainName = ezCommonService.getTenantConfig("DomainName", tenantId);
		String userAccount = userInfo.getId() + "@" + domainName;
		String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", userInfo.getTenantId());

		if (useSharedMailbox.equals("YES")) {
			String shareId = request.getParameter("shareId");
			logger.debug("shareId=" + shareId);
			
			if (shareId != null) {
				if (!ezEmailService.checkUserShareId(userInfo.getId(), shareId, userInfo.getTenantId())) {
					logger.debug("the user cannot access the shareId.");
					logger.debug("mailboxImportZip ended.");
					
					return "";
				}
				
				userAccount = shareId + "@" + domainName;
			}
		}
		
		logger.debug("userId=" + userInfo.getId() + ",userAccount=" + userAccount);
	
		String realPath = commonUtil.getRealPath(request);
		String tempFileUploadPath = realPath + commonUtil.getUploadPath("upload_mail.ROOT", tenantId) + commonUtil.separator + "tempFileUpload";

		Path transferPath = Paths.get(tempFileUploadPath, UUID.randomUUID() + ".zip");

		if (!Files.exists(transferPath.getParent())) {
			Files.createDirectories(transferPath.getParent());
		}

		Files.createFile(transferPath);
		multiFile.get(0).transferTo(transferPath.toFile());
		String zipFilePath = transferPath.toAbsolutePath().toString();

		String finalUserAccount = userAccount;
		new Thread(() -> {
		Thread.currentThread().setName("mailbox-import-zip-" + userInfo.getId() + "-" + folderPath);
		ZipInputStream zis = null;
		IMAPAccess ia = null;
		String returnValue = "OK";
		String returnTempId = "NONE";

		try {
			ezEmailService.setMailboxProgress(userkey, userInfo.getId(), "IMPORT", tenantId, 0);
			String importState = "";
			
			if (multiFile == null || multiFile.get(0) == null) {
				logger.error("Cannot find file."); 
				throw new Exception("Cannot find file.");
			}
			
			// 2017.11.21 코린도 - 암호화된 ZIP 파일 가져오기
			/*
			if (useEncryptZipForEmail.equals("YES") && !encryptPw.equals("") && !retryPathId.equals("NONE")) {
				File sourceFile = new File(tempFileUploadPath + commonUtil.separator + retryPathId + ".zip");
				String destFolderPath = tempFileUploadPath + commonUtil.separator + retryPathId;
	
				ZipFile zipFile = new ZipFile(sourceFile);
				zipFile.setPassword(encryptPw.toCharArray());
				zipFile.extractAll(destFolderPath);
				
				if (sourceFile.delete()) {
					logger.debug("encrypted zip file is deleted. path=" + sourceFile.getAbsolutePath());
				}
			}
			 */
			
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
			} catch (IOException e) {
				// CWE-404 보안 취약점 대응
				try {
					charset = Charset.forName("ms949");
					logger.debug("charset is changed as ms949.");
				} finally {
					if (zis1 != null) {
						try { zis1.closeEntry();
						} catch (ZipException ex) {logger.debug("e.message=" + ex.getMessage());
						} catch (Exception ex) {logger.debug("e.message=" + ex.getMessage());}
						try { zis1.close();
						} catch (ZipException ex) {logger.debug("e.message=" + ex.getMessage());
						} catch (Exception ex) {logger.debug("e.message=" + ex.getMessage());}
					}
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
			} catch (Exception e) {
				// CWE-404 보안 취약점 대응
				try {
					charset = Charset.forName("ms949");
					logger.debug("charset is changed as ms949.");
				} finally {
					if (zis1 != null) {
						try { zis1.closeEntry();
						} catch (ZipException ex) {logger.debug("e.message=" + ex.getMessage());
						} catch (Exception ex) {logger.debug("e.message=" + ex.getMessage());}
						try { zis1.close();
						} catch (ZipException ex) {logger.debug("e.message=" + ex.getMessage());
						} catch (Exception ex) {logger.debug("e.message=" + ex.getMessage());}
					}
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
					try { zis1.closeEntry();
					} catch (ZipException e) {logger.debug("e.message=" + e.getMessage());
					} catch (Exception e) {logger.debug("e.message=" + e.getMessage());}
					try { zis1.close(); 
					} catch (ZipException e) {logger.debug("e.message=" + e.getMessage());
					} catch (Exception e) {logger.debug("e.message=" + e.getMessage());}
					
					zis1 = null;
				}
			}
			
			logger.debug("messageCount=" + messageCount);
						
			List<String> userIdAndPassword = commonUtil.getUserIdAndPassword(loginCookie);
			String password  = userIdAndPassword.get(1);
			
			SMTPAccess sa = SMTPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.SMTPPort"),
					finalUserAccount, password);
	
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					finalUserAccount, password, egovMessageSource, locale, ezEmailUtil);

			if (ia == null){
				throw new Exception("Ia is null");
			}
			Folder folder = ia.getFolder(folderPath != null ? folderPath : "");
	
			if (folder == null || !folder.exists()) {
				logger.error("Folder not found. folderPath=" + folderPath);
			} else {
				folder.open(Folder.READ_WRITE);
				List<Message> messageList = new LinkedList<>();
				Message message = null;
				int count = 0;
				int emlCount = 0;
				long lastTime = System.currentTimeMillis();
				
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
	
						if (count % 50 == 0) {
							folder.appendMessages(messageList.toArray(new Message[0]));
							messageList.clear();
						}
	
						message = sa.readMimeMessage(zis);
						message.setFlag(Flags.Flag.SEEN, true);
						messageList.add(message);
						emlCount ++;
					} catch (MessagingException e) {
						logger.error(e.getMessage(), e);
						String exceptionMessage = e.getMessage();
						
						if (exceptionMessage.contains("NO APPEND failed. Save failed.")) {
							importState = "NO_APPEND";
							break;
						}
					} catch (Exception e) {
						logger.error(e.getMessage(), e);
						String exceptionMessage = e.getMessage();
						
						if (exceptionMessage.contains("NO APPEND failed. Save failed.")) {
							importState = "NO_APPEND";
							break;
						}
					}
	
					// 진행율 클라이언트에게 전송
					if (userkey != null) {
						
						long currTime = System.currentTimeMillis();
						long interval = currTime - lastTime;
	
						/*jsonObj.clear();
						jsonObj.put("status" , "progress"); 
						jsonObj.put("userkey", userkey);*/
	
						if (interval >= 2000) {
							/*jsonObj.put("percent", percent); 
							String json2 = jsonObj.toJSONString();*/
	
							try {
								int percent = (int)((double) count / (double) messageCount * 100.0);
								int resultInt = ezEmailService.updateMailboxProgress(userkey, Math.min(percent, 99));
								if (resultInt <= 0) { // websocket close되면 더 이상 실행하지 않도록. close될 때 mailboxProgress db 값을 삭제하기 때문에 0으로 close 여부 구분
									throw new IllegalStateException();
								}
								//handleMessage(json2, session);
							} catch (IllegalStateException e) {
								logger.error(e.getMessage(), e);
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
				
				if (!importState.equals("")) {
					throw new Exception(importState);
				}

				try {
					folder.appendMessages(messageList.toArray(new Message[0]));
				} catch (MessagingException e) {
					if (e.getMessage().contains("NO APPEND failed. Save failed.")) {
						throw new MessagingException("NO_APPEND");
					}
				}

				folder.close(true);
			}
		} catch (IOException e) {
			logger.error(e.getMessage(), e);
			String exceptionMessage = e.getMessage();
			
			if (exceptionMessage != null) {
				
				if (exceptionMessage.equals("encrypted ZIP entry not supported")) {
					returnValue = "NOT";
					
					if (useEncryptZipForEmail.equals("YES") && CollectionUtils.isNotEmpty(multiFile)) { // 암호화를 사용하면
						String guid = UUID.randomUUID().toString(); // 새 id를 만들어서
						File file = new File(tempFileUploadPath + commonUtil.separator + guid + ".zip"); // 파일을 생성하고
						try {
							multiFile.get(0).transferTo(file); // 멀티파일을 파일로 만들어준다.
						} catch (IOException ex) {
							throw new RuntimeException(ex);
						}

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
				} else if (exceptionMessage.equals("NO_APPEND")) {
					returnValue = "NO_APPEND";
				} else {
					returnValue = "ERROR";
				}
				
			} else {
				returnValue = "ERROR";
			}
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			String exceptionMessage = e.getMessage();
			
			if (exceptionMessage != null) {
				
				if (exceptionMessage.equals("encrypted ZIP entry not supported")) {
					returnValue = "NOT";
					
					if (useEncryptZipForEmail.equals("YES") && CollectionUtils.isNotEmpty(multiFile)) { // 암호화를 사용하면
						String guid = UUID.randomUUID().toString(); // 새 id를 만들어서
						File file = new File(tempFileUploadPath + commonUtil.separator + guid + ".zip"); // 파일을 생성하고
						try {
							multiFile.get(0).transferTo(file); // 멀티파일을 파일로 만들어준다.
						} catch (IOException ex) {
							throw new RuntimeException(ex);
						}

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
				} else if (exceptionMessage.equals("NO_APPEND")) {
					returnValue = "NO_APPEND";
				} else {
					returnValue = "ERROR";
				}
				
			} else {
				returnValue = "ERROR";
			}
		} finally {
			if (ia != null) {
				try { ia.close(); 
				} catch (RuntimeException e) {logger.debug("e.message=" + e.getMessage());
				} catch (Exception e) {logger.debug("e.message=" + e.getMessage());}
			}
			
			if (zis != null) {
				try { zis.closeEntry(); 
				} catch (ZipException e) {logger.debug("e.message=" + e.getMessage());
				} catch (Exception e) {logger.debug("e.message=" + e.getMessage());}
				try { zis.close(); 
				} catch (IOException e) {logger.debug("e.message=" + e.getMessage());
				} catch (Exception e) {logger.debug("e.message=" + e.getMessage());}
			}

			if ("NOT".equalsIgnoreCase(returnValue) && "NO".equalsIgnoreCase(useEncryptZipForEmail)) {
				returnValue = "NOTSUPPORT";
			}

			ezEmailService.updateMailboxProgressState(userkey, returnValue, returnTempId);
		}
	
		if (zipFilePath != null) {
			File zipFile = new File(zipFilePath);
			
			if (zipFile.exists()) {
				zipFile.delete();
				logger.debug("zip file is deleted. path=" + zipFilePath);
			}
		}
		}).start();
		// model.addAttribute("result", returnValue);
		model.addAttribute("userkey", userkey);
		// model.addAttribute("tempId", returnTempId);
		model.addAttribute("useEncryptZipForEmail", useEncryptZipForEmail);
	
		logger.debug("mailboxImportZip ended.");
		return "ezEmail/mailboxImportZip";
	}

	/**
	 * PC에 메일파일 저장하기 실행 함수
	 */
	@RequestMapping(value="/ezEmail/mailExport.do", method = RequestMethod.GET)
	@ResponseBody
	public void mailExport(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request, HttpServletResponse response) throws Exception{
		logger.debug("mailExport started.");
		
		List<String> userInfo = commonUtil.getUserIdAndPassword(loginCookie);
		String password  = userInfo.get(1);
		
		LoginVO loginInfo = commonUtil.userInfo(loginCookie);
		String domainName = ezCommonService.getTenantConfig("DomainName", loginInfo.getTenantId());
		String userEmail = loginInfo.getId() + "@" + domainName;
		String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", loginInfo.getTenantId());

		if (useSharedMailbox.equals("YES")) {
			String shareId = request.getParameter("shareId");
			logger.debug("shareId=" + shareId);
			
			if (shareId != null) {
				if (!ezEmailService.checkUserShareId(loginInfo.getId(), shareId, loginInfo.getTenantId())) {
					logger.debug("the user cannot access the shareId.");
					logger.debug("mailExport ended.");
					
					return;
				}
				
				userEmail = shareId + "@" + domainName;
			}
		}
		
		logger.debug("userId=" + loginInfo.getId() + ",userEmail=" + userEmail);
		
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

			if (ia != null){

				Folder folder = ia.getFolder(folderPath != null ? folderPath : "");

				// Chrome에서 message/rfc822 Type으로 내려 보내면
				// blocked a frame with origin from accessing a cross-origin frame
				// 오류가 발생해 application/octet-stream으로 변경함.
				String mimetype = "application/octet-stream";
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
							logger.debug("e.message=" + e.getMessage());
						} finally {
							if (outputStream != null) {
								outputStream.close();
							}
						}
					}

					folder.close(true);
				}
			}
			
		} catch (MessagingException e) {
			logger.error(e.getMessage(), e);
		} finally {
			if (ia != null) {
				ia.close();
			}
		}
		
		logger.debug("mailExport ended.");
	}
	
	/**
	 * 2022-12-29 이사라
	 * 검색된 메일파일을 zip파일로 서버에 저장하기 실행 함수
	 */
	@RequestMapping(value = "/ezEmail/searchedMailExportZip.do", method = RequestMethod.POST)
	@ResponseBody
	public String searchedMailExportZip(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model,
			@RequestBody JSONObject requestObject, HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		logger.debug("searchedMailExportZip started.");
		logger.debug("requestObject={}", requestObject);

		String returnValue = "";

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
		String userEmail = userInfo.getId() + "@" + domainName;

		String folderId = (String) requestObject.get("FOLDERID");
		String inboxName = egovMessageSource.getMessage("ezEmail.t644", locale);
		folderId = folderId.equals(inboxName) ? "INBOX" : folderId;
		boolean isAllMail = "allMail".equalsIgnoreCase(folderId);
		folderId =  isAllMail ? "INBOX////Personal folder" : folderId; // 전체메일은 받은편지함과 그 하위, 개인편지함과 그 하위의 모든 메일함에서 메일을 가져온다.
		String sortType = StringUtils.defaultIfBlank((String) requestObject.get("SORTTYPE"), "");
		String start = StringUtils.defaultIfBlank((String) requestObject.get("START"), "0");
		String end = StringUtils.defaultIfBlank((String) requestObject.get("END"), "0");
		String search = StringUtils.defaultIfBlank((String) requestObject.get("SEARCH"), "");
		String viewSelectIndex = StringUtils.defaultIfBlank((String) requestObject.get("VIEWSELECTINDEX"), "");
		String useSecureMailFilter = StringUtils.defaultIfBlank((String) requestObject.get("SECUREMAILFILTER"), "");
		String useCountryIP = ezCommonService.getTenantConfig("useCountryIP", userInfo.getTenantId());
		String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", userInfo.getTenantId());
		String useRDBOnlyMailList = ezCommonService.getTenantConfig("useRDBOnlyMailList", userInfo.getTenantId());
		String startDate = (String) requestObject.get("STARTDATE");
		String endDate = (String) requestObject.get("ENDDATE");
		String andorStatus = (String) requestObject.get("ANDORSTATUS");
		String attachStatus = (String) requestObject.get("ATTACHSTATUS");
		String tagName = StringUtils.defaultIfBlank((String) requestObject.get("TAGNAME"), "");
		boolean isRequireMailboxPath = !tagName.isEmpty();
		String shareId = "";
		int maxCount = requestObject.get("MAXCOUNT") == null ? 0 : (Integer) requestObject.get("MAXCOUNT");
		String userkey = (String) requestObject.get("USERKEY");

		List listCategory = (ArrayList) requestObject.get("CATEGORY");
		List listKeyword = (ArrayList) requestObject.get("KEYWORD");
		String[] categoryArray = new String[listCategory.size()];
		String[] keywordArray = new String[listKeyword.size()];

		for (int i = 0; i < listCategory.size(); i++) {
			categoryArray[i] = (String) listCategory.get(i);
		}

		for (int i = 0; i < listKeyword.size(); i++) {
			keywordArray[i] = (String) listKeyword.get(i);
		}

		if (startDate == null) {
			return "";
		}

		if (endDate == null) {
			return "";
		}

		SimpleDateFormat sdfForParsing = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		sdfForParsing.setTimeZone(TimeZone.getTimeZone("GMT"));

		Date startDateObj = startDate.equals("") ? null : sdfForParsing.parse(startDate);
		Date endDateObj = endDate.equals("") ? null
				: new Date(sdfForParsing.parse(endDate).getTime() + 60 * 60 * 24 * 1000);

		if (useSharedMailbox.equals("YES")) {
			shareId = (String) requestObject.get("SHAREDID");
			logger.debug("shareId=" + shareId);

			if (StringUtils.isNotBlank(shareId)) {
				if (!ezEmailService.checkUserShareId(userInfo.getId(), shareId, userInfo.getTenantId())) {
					logger.debug("the user cannot access the shareId.");
					logger.debug("getMailList ended.");

					return "";
				}

				userEmail = shareId + "@" + domainName;
			}
		}

		logger.debug("userId=" + userInfo.getId() + ",userEmail=" + userEmail + ",tenantId=" + userInfo.getTenantId()
				+ ",serverName=" + userInfo.getServerName() + ",folderId=" + folderId + ",sortType=" + sortType
				+ ",start=" + start + ",end=" + end + ",search=" + search + ",viewSelectIndex=" + viewSelectIndex
				+ ",useCountryIP=" + useCountryIP + ",useSecureMailFilter=" + useSecureMailFilter);

		boolean isUnreadOnly = false;
		boolean isImportantOnly = false;

		if (sortType.indexOf("\"urn:schemas:httpmail:read\" = false") >= 0) {
			isUnreadOnly = true;
		}

		if (sortType.indexOf("IMPORTANT") >= 0) {
			isImportantOnly = true;
		}

		logger.debug("isUnreadOnly=" + isUnreadOnly + ", isImportantOnly=" + isImportantOnly);

		String searchField = "";
		String searchValue = "";

		int index = search.indexOf("=");

		if (search.indexOf("=") > -1) {
			searchField = search.substring(0, index);
			searchValue = search.substring(index + 1);
		}

		logger.debug("searchField=" + searchField + ",searchValue=" + searchValue);

		String sortTypeSpecifier = null;
		boolean isAscending = sortType.endsWith("ASC") ? true : false;

		// subject
		if (sortType.indexOf(" ORDER BY \"http://schemas.microsoft.com/mapi/proptag/x0e1d001f\"") >= 0) {
			sortTypeSpecifier = "subject";
		}
		// sender
		else if (sortType.indexOf(" ORDER BY \"http://schemas.microsoft.com/mapi/sent_representing_name\"") >= 0) {
			sortTypeSpecifier = "sender";
		}
		// recipient
		else if (sortType.indexOf(" ORDER BY \"urn:schemas:httpmail:displayto\"") >= 0) {
			sortTypeSpecifier = "recipient";
		}
		// attachment
		else if (sortType.indexOf(" ORDER BY \"urn:schemas:httpmail:hasattachment\"") >= 0) {
			sortTypeSpecifier = "attachment";
		}
		// read/unread
		else if (sortType.indexOf(" ORDER BY \"http://schemas.microsoft.com/exchange/smallicon\"") >= 0) {
			sortTypeSpecifier = "readFlag";
		}
		// bookmark
		else if (sortType.indexOf(" ORDER BY \"http://schemas.microsoft.com/mapi/proptag/x10900003\"") >= 0) {
			sortTypeSpecifier = "flag";
		}
		// importance
		else if (sortType.indexOf(" ORDER BY \"http://schemas.microsoft.com/exchange/x-priority-long\"") >= 0) {
			sortTypeSpecifier = "importance";
		}
		// size
		else if (sortType.indexOf(" ORDER BY \"http://schemas.microsoft.com/mapi/proptag/x0e080003\"") >= 0) {
			sortTypeSpecifier = "size";
		}
		// received date
		else if (sortType.indexOf(" ORDER BY \"urn:schemas:httpmail:datereceived\"") >= 0
				|| sortType.indexOf(" ORDER BY \"http://schemas.microsoft.com/exchange/date-iso\"") >= 0) {
			sortTypeSpecifier = "receivedDate";
		}

		int startNo = Integer.parseInt(start);
		int endNo = Integer.parseInt(end);

		Map<String, Object> extraMap = new HashMap<String, Object>();
		extraMap.put("andorStatus", andorStatus);
		extraMap.put("attachStatus", attachStatus);
		extraMap.put("useSecureMailFilter", useSecureMailFilter.equals("1"));

		// 2020-07-16 김은실 - (사조그룹)내부·외부필터 내부기준 도메인
		if (sortType.indexOf("INTERNAL") >= 0 || sortType.indexOf("EXTERNAL") >= 0) {
			String inexternalFilter = sortType.indexOf("INTERNAL") >= 0 ? "internal" : "external";
			String mailInnerDomainStr = ezCommonService.getTenantConfig("MailInnerDomain", userInfo.getTenantId());

			extraMap.put("inexternalFilter", inexternalFilter);
			extraMap.put("mailInnerDomainStr", mailInnerDomainStr.isEmpty() ? domainName : mailInnerDomainStr);

			logger.debug("inexternalFilter=" + inexternalFilter + ", mailInnerDomainStr=" + mailInnerDomainStr);
		}

		try {
			if (useRDBOnlyMailList.equals("YES")) {
				boolean includeContent = false;

				if (viewSelectIndex.equals("1")) {
					includeContent = true;
				}

				List<Map<String, String>> mailList = ezEmailUtil.searchFolderUsingRDBOnly(userEmail, folderId,
						categoryArray, keywordArray, startDateObj, endDateObj, isAllMail, isUnreadOnly, isImportantOnly,
						sortTypeSpecifier, isAscending, startNo, endNo, false, extraMap, userInfo.getTenantId(),
						includeContent, tagName);

				Map<String, String[]> urlMap = new HashMap<>();
				Map<String, String> mailMap = new HashMap<>();

				for (Map<String, String> mail : mailList) {
					String mailIdInfo = mail.get("MAIL_ID");
					String mailbox = mailIdInfo.substring(0, mailIdInfo.lastIndexOf("/"));
					String mailId = mailIdInfo.substring(mailIdInfo.lastIndexOf("/") + 1);

					if (StringUtils.isBlank(mailMap.get(mailbox))) {
						mailMap.put(mailbox, mailId);
					} else {
						String mailIds = mailMap.get(mailbox);
						mailIds += ("," + mailId);
						mailMap.put(mailbox, mailIds);
					}
				}

				for (Entry<String, String> elem : mailMap.entrySet()) {
					String[] mailMapValue = { elem.getValue() };
					urlMap.put(elem.getKey(), mailMapValue);
				}

				String realPath = commonUtil.getRealPath(request);

				// 2023-07-10 이사라
				// maxCount는 진행율(%)를 출력하기 위해 필요한 값으로 mailId를 가져올때는 사용되지 않는다.
				// 0이 나오는 경우는 '메일환경설정> 편지함관리> 내보내기'에서 기간을 직접입력했을 때이며 이 경우에는 진행율을 정상적으로 출력하기 위해 mailList의 사이즈를 구해서 전달한다.
				if (maxCount == 0) {
					maxCount = mailList.size();
				}

				String finalShareId = shareId;
				int finalMaxCount = maxCount;
				new Thread(() -> {
					try {
						String guid = mailExportZipExcute(loginCookie, locale, finalShareId, urlMap, realPath, finalMaxCount, userkey);
						ezEmailService.updateMailboxProgressState(userkey, "SUCCESS", guid);
					} catch (Exception e) {
						logger.error("mailExportZipExecute err:", e);
						ezEmailService.updateMailboxProgressState(userkey, "ERROR", "");
					}
				}).start();
			}

		} catch (RuntimeException e) {
			logger.error(e.getMessage(), e);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}

		logger.debug("searchedMailExportZip ended.");
		return returnValue;
	}

	/**
	 * 2024-05-20 이사라
	 * 메일검색에서 검색된 메일파일을 zip파일로 서버에 저장하기 실행 함수
	 */
	@RequestMapping(value = "/ezEmail/searchedMailExportZipForAll.do", method = RequestMethod.POST)
	@ResponseBody
	public String searchedMailExportZipForAll(@CookieValue("loginCookie") String loginCookie, @RequestBody JSONObject requestObject, Locale locale, Model model, HttpServletRequest request) throws Exception {
		logger.debug("searchedMailExportZipForAll started.");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
		String userEmail = userInfo.getId() + "@" + domainName;
		String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", userInfo.getTenantId());
		String useRDBOnlyMailList = ezCommonService.getTenantConfig("useRDBOnlyMailList", userInfo.getTenantId());

		String mailFolder = (String) requestObject.get("MAILFOLDER");
		String startDate = (String) requestObject.get("STARTDATE");
		String endDate = (String) requestObject.get("ENDDATE");
		String andorStatus = (String) requestObject.get("ANDORSTATUS");
		String attachStatus = (String) requestObject.get("ATTACHSTATUS");
		String userkey = (String) requestObject.get("USERKEY");
		int maxCount = requestObject.get("MAXCOUNT") == null ? 0 : (Integer) requestObject.get("MAXCOUNT");
		int startIndex = 0;
		String shareId = (String) requestObject.get("SHAREID");

		if (useSharedMailbox.equals("YES")) {
			logger.debug("searchedMailExportZipForAll shareId=" + shareId);

			if (!StringUtils.isBlank(shareId)) {
				if (!ezEmailService.checkUserShareId(userInfo.getId(), shareId, userInfo.getTenantId())) {
					logger.debug("the user cannot access the shareId.");
					logger.debug("searchedMailExportZipForAll ended.");

					return "";
				} else {
					userEmail = shareId + "@" + domainName;
				}
			}
		}

		logger.debug("searchedMailExportZipForAll userId=" + userInfo.getId() + ",userEmail=" + userEmail);

		List listCategory = (ArrayList) requestObject.get("CATEGORY");
		List listKeyword = (ArrayList) requestObject.get("KEYWORD");
		String[] categoryArray = new String[listCategory.size()];
		String[] keywordArray = new String[listKeyword.size()];

		for (int i = 0; i < listCategory.size(); i++) {
			categoryArray[i] = (String) listCategory.get(i);
		}

		for (int i = 0; i < listKeyword.size(); i++) {
			keywordArray[i] = (String) listKeyword.get(i);
		}

		if (startDate == null) {
			return "";
		}

		if (endDate == null) {
			return "";
		}

		startDate = commonUtil.getDateStringInUTC(startDate, userInfo.getOffset(), true);
		endDate = commonUtil.getDateStringInUTC(endDate, userInfo.getOffset(), true);

		SimpleDateFormat sdfForParsing = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		sdfForParsing.setTimeZone(TimeZone.getTimeZone("GMT"));

		Date startDateObj = startDate.equals("") ? null : sdfForParsing.parse(startDate);
		Date endDateObj = endDate.equals("") ? null : new Date(sdfForParsing.parse(endDate).getTime() + 60*60*24*1000);

		// 가온누리에서 분석 결과 endDate가 없는 경우 null보다 현재 시각으로 지정하는 것이 성능이 훨씬 좋게 나와 추가함.
		if (endDateObj == null) {
			endDateObj = new Date();
		}

		String returnValue = "";
		IMAPAccess ia = null;

		try {
			int totalCount = 0;

			Map<String, Object> extraMap = new HashMap<String, Object>();
			extraMap.put("andorStatus", andorStatus);
			extraMap.put("attachStatus", attachStatus);

			if (useRDBOnlyMailList.equals("YES")) {
				String folderPath = "";

				if (!mailFolder.equals("ALL")) {
					folderPath = mailFolder;
				}

				List<Map<String, String>> mailList = ezEmailUtil.searchFolderUsingRDBOnly(userEmail, folderPath, categoryArray, keywordArray, startDateObj, endDateObj, true,
						false, false, "receivedDate", true, startIndex, maxCount, false, extraMap, userInfo.getTenantId(), false, "");

				totalCount = (int) extraMap.get("totalCount");
				logger.debug("searchedMailExportZipForAll totalCount=" + totalCount);

				Map<String, String[]> urlMap = new HashMap<>();
				Map<String, String> mailMap = new HashMap<>();

				for (Map<String, String> mail : mailList) {
					String mailIdInfo = mail.get("MAIL_ID");
					String mailbox = mailIdInfo.substring(0, mailIdInfo.lastIndexOf("/"));
					String mailId = mailIdInfo.substring(mailIdInfo.lastIndexOf("/") + 1);

					if (StringUtils.isBlank(mailMap.get(mailbox))) {
						mailMap.put(mailbox, mailId);
					} else {
						String mailIds = mailMap.get(mailbox);
						mailIds += ("," + mailId);
						mailMap.put(mailbox, mailIds);
					}
				}

				for (Entry<String, String> elem : mailMap.entrySet()) {
					String[] mailMapValue = { elem.getValue() };
					urlMap.put(elem.getKey(), mailMapValue);
				}

				String realPath = commonUtil.getRealPath(request);

				new Thread(() -> {
					try {
						String guid = mailExportZipExcute(loginCookie, locale, shareId, urlMap, realPath, maxCount, userkey);
						ezEmailService.updateMailboxProgressState(userkey, "SUCCESS", guid);
					} catch (Exception e) {
						logger.error("mailExportZipExecute err:", e);
						ezEmailService.updateMailboxProgressState(userkey, "ERROR", "");
					}
				}).start();
			}

		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}

		logger.debug("searchedMailExportZipForAll ended.");
		return returnValue;
	}

	/**
	 * 여러개의 메일파일을 zip파일로 서버에 저장하기 실행 함수
	 * 2022-12-29 이사라 : 중복코드를 피하기 위해 mailExportZipExcute 함수와 분리
	 */
	@RequestMapping(value="/ezEmail/mailExportZip.do", method = RequestMethod.POST)
	@ResponseBody
	public String mailExportZip(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request, HttpServletResponse response) throws Exception{
		logger.debug("mailExportZip started.");
		String returnValue = "";
		String shareId = request.getParameter("shareId") == null ? "" : request.getParameter("shareId");
		String realPath = commonUtil.getRealPath(request);
		Map<String, String[]> urlMap = request.getParameterMap();

		try {
			returnValue = mailExportZipExcute(loginCookie, locale, shareId, urlMap, realPath, 0, ""); // maxCount와 userkey가 불필요하여 디폴트 값을 넣어 줌
		} catch (RuntimeException e) {
			logger.error(e.getMessage(), e);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("mailExportZip ended.");
		return returnValue;
	}

	public String mailExportZipExcute(String loginCookie, Locale locale, String shareId, Map<String, String[]> urlMap, String realPath, int maxCount, String userkey) throws Exception {
		logger.debug("mailExportZipExcute started.");
		
		List<String> userIdAndPassword = commonUtil.getUserIdAndPassword(loginCookie);
		String password  = userIdAndPassword.get(1);
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
		String userAccount = userInfo.getId() + "@" + domainName;
		String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", userInfo.getTenantId());

		if (useSharedMailbox.equals("YES")) {
			//String shareId = request.getParameter("shareId"); // parameter로 받음
			logger.debug("shareId=" + shareId);
			
			if (StringUtils.isNotBlank(shareId)) {
				if (!ezEmailService.checkUserShareId(userInfo.getId(), shareId, userInfo.getTenantId())) {
					logger.debug("the user cannot access the shareId.");
					logger.debug("mailExportZipExcute ended.");
					
					return "";
				}
				
				userAccount = shareId + "@" + domainName;
			}
		}
		
		logger.debug("userId=" + userInfo.getId() + ",userAccount=" + userAccount);
		
		//Map<String, String[]> urlMap = request.getParameterMap(); // parameter로 받음
		Set<String> folderList = urlMap.keySet();
		logger.debug("folderList=" + folderList.toString());
		
		//String realPath = commonUtil.getRealPath(request); // parameter로 받음
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
		
		String returnValue = guid;

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
			int currCount = 1;
			long lastTime = System.currentTimeMillis();

			zos = new ZipOutputStream(new FileOutputStream(pDirTempPath + ".zip"), Charset.forName(charSet));
			
			if (StringUtils.isNotBlank(userkey)) {
				ezEmailService.setMailboxProgress(userkey, userInfo.getId(), "EXPORT", userInfo.getTenantId(), 0);
			}


			if (ia == null){
				throw new Exception("ia is null");
			}


			for (String folderPath : folderList) {
				String uids = urlMap.get(folderPath)[0];
				String[] uidArr = uids.split(",");
				logger.error("uids=" + uids);

				Folder folder = ia.getFolder(folderPath != null ? folderPath : "");

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

						// 진행율 클라이언트에게 전송
						if (StringUtils.isNotBlank(userkey) && maxCount > 0) {
							long currTime = System.currentTimeMillis();
							int interval = (int) (currTime - lastTime);
							int percent = (int) ((double) currCount / (double) maxCount * 100.0);

							if (interval >= 2000) {

								try {
									int resultInt = ezEmailService.updateMailboxProgress(userkey, Math.min(percent, 99));
									if (resultInt <= 0) {
										throw new IllegalStateException();
									}
								} catch (IllegalStateException e) {
									File file = new File(pDirTempPath + ".zip");

									if (file.exists()) {
										file.delete();
									}

									returnValue = "CANCEL";

									logger.error(e.getMessage(), e);
									break;
								}

								lastTime = currTime;
							}

							currCount = currCount + 1; // 현재 메일 카운트
						}
					}

					folder.close(true);
				}
			}
			
			zos.flush();
			zos.close();
			zos = null;
			
		} catch (NullPointerException e) {
			File file = new File(pDirTempPath + ".zip");
			returnValue = "";
			
			if (file.exists()) {
				file.delete();
			}
			
			logger.error(e.getMessage(), e);
		} catch (Exception e) {
			File file = new File(pDirTempPath + ".zip");
			returnValue = "";
			
			if (file.exists()) {
				file.delete();
			}
			
			logger.error(e.getMessage(), e);
		} finally {
			if (ia != null) {
				ia.close();
			}
			
			if (zos != null) {
				try {
					zos.close();
				} catch (ZipException e) {
					logger.error(e.getMessage(), e);
				} catch (Exception e) {
					logger.error(e.getMessage(), e);
				}
			}
		}
		
		logger.debug("mailExportZipExcute ended. returnValue=" + returnValue);
		return returnValue;
	}
	
	/**
	 * 특정 메일함의 모든 메일을 zip파일로 서버에 저장하기 실행 함수
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/ezEmail/mailboxExportZip.do", method = RequestMethod.POST)
	@ResponseBody
	public String mailboxExportZip(@CookieValue("loginCookie") String loginCookie, Locale locale,
				Model model, HttpServletRequest request, HttpServletResponse response) throws Exception{
		logger.debug("mailboxExportZip started.");
		
		String returnValue = "";
		
		List<String> userIdAndPassword = commonUtil.getUserIdAndPassword(loginCookie);
		final String password  = userIdAndPassword.get(1);
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		int tenantId = userInfo.getTenantId();
		String userId = userInfo.getId();
		String domainName = ezCommonService.getTenantConfig("DomainName", tenantId);
		String userAccount = userId + "@" + domainName;
		String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", tenantId);

		if (useSharedMailbox.equals("YES")) {
			String shareId = request.getParameter("shareId");
			logger.debug("shareId=" + shareId);
			
			if (shareId != null) {
				if (!ezEmailService.checkUserShareId(userInfo.getId(), shareId, userInfo.getTenantId())) {
					logger.debug("the user cannot access the shareId.");
					logger.debug("mailboxExportZip ended.");
					
					return "";
				}
				
				userAccount = shareId + "@" + domainName;
			}
		}
		
		logger.debug("userId=" + userInfo.getId() + ",userAccount=" + userAccount);
		
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
		String finalUserAccount = userAccount;
		String userkey = request.getParameter("userkey");

		new Thread(() -> {
		Thread.currentThread().setName("mailbox-export-zip-" + userInfo.getId() + "-" + folderPath);
		IMAPAccess ia = null;
		ZipOutputStream zos = null;
		Map<String, Integer> fileNameMap = new HashMap<String, Integer>();

		// Session session = null;
		boolean sessionFlag = true;

		try {
			ezEmailService.setMailboxProgress(userkey, userId, "EXPORT", tenantId, 0);
			String useEucKr = ezCommonService.getTenantConfig("UseMailZipEucKr", userInfo.getTenantId());
			String charSet = "utf-8";

			// utf-8로 압축했을 경우 윈도우 기본 프로그램으로 압축을 풀면 실패하여 euc-kr로 압축할 수 있도록 옵션처리했다.
			// UseMailZipEucKr이 YES일 경우 euc-kr로 압축한다.
			// 윈도우 기본 프로그램으로 압축을 풀기 위해 추가적으로 new ZipEntry("/" + fileName) 에서 "/"를 제거했다.
			if (useEucKr.equals("YES")) {
				charSet = "euc-kr";
			}

			logger.debug("Use encoding charSet=" + charSet);
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					finalUserAccount, password, egovMessageSource, locale, ezEmailUtil);
			
			File tempFile = new File(pDirTempPath + ".zip");
			if (tempFile.exists()) {
				tempFile.delete();
			}
			
			zos = new ZipOutputStream(new FileOutputStream(pDirTempPath + ".zip"), Charset.forName(charSet));

			if (ia == null){
				throw new Exception("ia is null");
			}
			Folder folder = ia.getFolder(folderPath != null ? folderPath : "");
			
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
					String fileName = ezEmailUtil.saveFilenameForm(userInfo, locale, message);
					//fileName = commonUtil.getUniqueFileName(fileName, fileNameMap);
					
					// fileName이 너무길면 entry name too long 오류 발생으로 150글자 이상이면 150글자까지만 남기고 뒤에 문자열은 삭제
					fileName = fileName.chars()
							.limit(150)
							.mapToObj(c -> String.valueOf((char) c))
							.collect(Collectors.joining()) + ".eml";

					// 2025-07-21 - 중복 name인 경우 (2) 카운트 붙이는 로직
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
						
						/*JSONObject jsonObj = new JSONObject();
						jsonObj.put("status", "progress");
						jsonObj.put("userkey", userkey);*/
						
						if (interval >= 2000) {
							/*jsonObj.put("percent", percent);
							String jsonStr = jsonObj.toJSONString();*/
							
							try {
								int resultInt = ezEmailService.updateMailboxProgress(userkey, Math.min(percent, 99));
								if (resultInt <= 0) {
									throw new IllegalStateException();
								}
								//handleMessage(jsonStr, session);
							} catch (IllegalStateException e) {
								File file = new File(pDirTempPath + ".zip");
								
								if (file.exists()) {
									file.delete();
								}

								ezEmailService.updateMailboxProgressState(userkey, "CANCEL", "");
								sessionFlag = false;
								
								logger.error(e.getMessage(), e);
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
				ezEmailService.updateMailboxProgressState(userkey, "SUCCESS", guid);
			} 
		} catch (NullPointerException e) {
			File file = new File(pDirTempPath + ".zip");
			
			if (file.exists()) {
				file.delete();
			}
			
			logger.error(e.getMessage(), e);
			ezEmailService.updateMailboxProgressState(userkey, "ERROR", "");
		} catch (Exception e) {
			File file = new File(pDirTempPath + ".zip");
			
			if (file.exists()) {
				file.delete();
			}
			
			logger.error(e.getMessage(), e);
			ezEmailService.updateMailboxProgressState(userkey, "ERROR", "");
		} finally {
			if (ia != null) {
				ia.close();
			}
			
			if (zos != null) {
				try {
					zos.close();
				} catch (ZipException e) {
					logger.error(e.getMessage(), e);
				} catch (Exception e) {
					logger.error(e.getMessage(), e);
				}
			}
		}
		}).start();
		
		logger.debug("mailboxExportZip ended. returnValue=" + returnValue);
		return returnValue;
	}
	
	/**
	 * 메일 zip파일 다운로드 실행 함수
	 */
	@RequestMapping(value="/ezEmail/downloadMailZip.do", method = RequestMethod.GET)
	@ResponseBody
	public void downloadMailZip(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request, HttpServletResponse response) throws Exception{
		logger.debug("downloadMailZip started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userEmail = userInfo.getEmail();
		String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", userInfo.getTenantId());

		if (useSharedMailbox.equals("YES")) {
			String shareId = request.getParameter("shareId");
			logger.debug("shareId=" + shareId);
			
			if (shareId != null) {
				if (!ezEmailService.checkUserShareId(userInfo.getId(), shareId, userInfo.getTenantId())) {
					logger.debug("the user cannot access the shareId.");
					logger.debug("downloadMailZip ended.");
					
					return;
				}
				
				OrganUserVO userVO = ezOrganAdminService.getUserInfo(shareId, userInfo.getPrimary(), userInfo.getTenantId());
				userEmail = userVO.getMail();
			}
		}
		
		logger.debug("userId=" + userInfo.getId() + ",userEmail=" + userEmail);
		
		String encryptPw = request.getParameter("encryptPw");
		String tempZipName = request.getParameter("temp");
		logger.debug("tempZipName=" + tempZipName);
		
		tempZipName = commonUtil.detectPathTraversal(tempZipName);
		
		String realPath = commonUtil.getRealPath(request);
		String pDirPath = realPath + commonUtil.getUploadPath("upload_mail.ROOT", userInfo.getTenantId());
		String filePath = pDirPath + commonUtil.separator + "tempFileUpload" + commonUtil.separator + tempZipName + ".zip";
		String folderPath = pDirPath + commonUtil.separator + "tempFileUpload" + commonUtil.separator + tempZipName;
		logger.debug("filePath=" + filePath);
		
		// 2017.11.21 코린도 - 암호화된 ZIP 파일 내보내기
		if (!"".equals(encryptPw)) {
			String zipFileName = ezEmailUtil.encryptZipFile(commonUtil.detectPathTraversal(filePath), commonUtil.detectPathTraversal(folderPath), encryptPw);
			downFile(request, response, zipFileName, userEmail + ".zip");
			
			File secureFile = new File(zipFileName);
			
			if (secureFile.delete()) {
				logger.debug("zip file is deleted. filePath=" + zipFileName);
			}
		} else {
			downFile(request, response, filePath, userEmail + ".zip");
		}
		
		File zipFile = new File(commonUtil.detectPathTraversal(filePath));
		
		if (zipFile.delete()) {
			logger.debug("zip file is deleted. path=" + filePath);
		}
		
		logger.debug("downloadMailZip ended.");
	}

	/**
	 * 메일함 zip파일 다운로드 실행 함수
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/ezEmail/downloadMailboxZip.do", method = RequestMethod.GET)
	@ResponseBody
	public void downloadMailboxZip(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request, HttpServletResponse response) throws Exception{
		logger.debug("downloadMailboxZip started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userEmail = userInfo.getEmail();
		String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", userInfo.getTenantId());

		if (useSharedMailbox.equals("YES")) {
			String shareId = request.getParameter("shareId");
			logger.debug("shareId=" + shareId);
			
			if (shareId != null) {
				if (!ezEmailService.checkUserShareId(userInfo.getId(), shareId, userInfo.getTenantId())) {
					logger.debug("the user cannot access the shareId.");
					logger.debug("downloadMailboxZip ended.");
					
					return;
				}
				
				OrganUserVO userVO = ezOrganAdminService.getUserInfo(shareId, userInfo.getPrimary(), userInfo.getTenantId());
				userEmail = userVO.getMail();
			}
		}
		
		logger.debug("userId=" + userInfo.getId() + ",userEmail=" + userEmail);
		
		String folderName = request.getParameter("folderName");
		String tempZipName = request.getParameter("temp");
		String encryptPw = request.getParameter("encryptPw");
		logger.debug("folderName=" + folderName + ",tempZipName=" + tempZipName + ", encryptPw=" + encryptPw);
		
		tempZipName = commonUtil.detectPathTraversal(tempZipName);
		
		String realPath = commonUtil.getRealPath(request);
		String pDirPath = realPath + commonUtil.getUploadPath("upload_mail.ROOT", userInfo.getTenantId());
		String filePath = pDirPath + commonUtil.separator + "tempFileUpload" + commonUtil.separator + tempZipName + ".zip";
		String folderPath = pDirPath + commonUtil.separator + "tempFileUpload" + commonUtil.separator + tempZipName;
		// String userkey = request.getParameter("userkey");
		logger.debug("filePath=" + filePath);
				
		// 2017.11.21 코린도 - 암호화된 ZIP 파일 내보내기
		if (!"".equals(encryptPw)) {
			String zipFileName = ezEmailUtil.encryptZipFile(commonUtil.detectPathTraversal(filePath), commonUtil.detectPathTraversal(folderPath), encryptPw);
			//handleMessage(jsonStr, session);
			downFile(request, response, zipFileName, userEmail + "_" + folderName + ".zip");
			
			File secureFile = new File(zipFileName);
			
			if (secureFile.delete()) {
				logger.debug(secureFile.getAbsolutePath() + ".zip file is deleted.");
			}
		} else {
			//handleMessage(jsonStr, session);
			downFile(request, response, filePath, userEmail + folderName + ".zip");
		}
		
		File zipFile = new File(commonUtil.detectPathTraversal(filePath));
		
		if (zipFile.delete()) {
			logger.debug(zipFile.getAbsolutePath() + ".zip file is deleted.");
		}
		
		logger.debug("downloadMailboxZip ended.");
	}
	
	/**
	 * zip파일 삭제 실행 함수
	 */
	@RequestMapping(value="/ezEmail/deleteZipFile.do", method = RequestMethod.POST)
	public String deleteZipFile(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request, HttpServletResponse response) throws Exception{
		logger.debug("deleteZipFile started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String temp = request.getParameter("temp");
		temp = commonUtil.detectPathTraversal(temp);
		String realPath = commonUtil.getRealPath(request);
		String pDirPath = commonUtil.getUploadPath("upload_mail.ROOT", userInfo.getTenantId());
		pDirPath = realPath + pDirPath;
		String pDirTempPath = pDirPath + commonUtil.separator + "tempFileUpload" + commonUtil.separator + temp;
		String tempId = request.getParameter("tempId");
		tempId = commonUtil.detectPathTraversal(tempId);
		String pDirEncZipTempPath = pDirPath + commonUtil.separator + "tempFileUpload" + commonUtil.separator + tempId;
		
		File file = new File(commonUtil.detectPathTraversal(pDirTempPath + ".zip"));
		
		if (file.exists()) {
			file.delete();
		}
		
		File tempFile = new File(commonUtil.detectPathTraversal(pDirEncZipTempPath + ".zip"));
		
		if (tempFile.exists()) {
			tempFile.delete();
			logger.debug("cancle file delete=" + tempFile.getName());
		}
		
		logger.debug("deleteZipFile ended.");
		
		return "json"; 
	}
    
    /**
	 * 편지함 내보내기 옵션(암호화확인) 화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailExportOption.do", method = RequestMethod.GET)
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
	@RequestMapping(value="/ezEmail/mailImportOption.do", method = RequestMethod.GET)
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
	
	/**
	 * 공유사서함의 email로 암호화
	 */
	@RequestMapping(value="/ezEmail/shareBoxSpam.do", method = RequestMethod.GET)
	@ResponseBody
	public JSONObject shareBoxSpam(
			@CookieValue("loginCookie") String loginCookie, 
			Locale locale, 
			Model model, 
			HttpServletRequest request) throws Exception{
		
		logger.debug("shareBoxSpam started.");
		
		Map<String, Object> resultObject = new HashMap<>();
		
		LoginVO loginInfo = commonUtil.userInfo(loginCookie);
		String shareId = request.getParameter("shareId");
		
		String mailAddress = ezOrganService.getPropertyValue(shareId, "mail", loginInfo.getTenantId());
		String spamSniperAuthKey = ezCommonService.getTenantConfig("spamSniperAuthKey", loginInfo.getTenantId());
		String spamSniperAuthIv = ezCommonService.getTenantConfig("spamSniperAuthIv", loginInfo.getTenantId());
		String spamSniperUnixTimeStr = ezCommonService.getTenantConfig("spamSniperUnixTime", loginInfo.getTenantId());
		long spamSniperUnixTime;

		try {
			spamSniperUnixTime = Long.parseLong(spamSniperUnixTimeStr);
		} catch (NumberFormatException ex) {
			spamSniperUnixTime = 0;
		}

		String cryptResult = ezEmailUtil.spamSniperEnc(mailAddress, spamSniperAuthKey, spamSniperAuthIv, spamSniperUnixTime);
		
		logger.debug("shareId=" + shareId + ",mailAddress=" + mailAddress + ",cryptResult" + cryptResult);
		
		resultObject.put("shareId", shareId);
		resultObject.put("cryptResult", cryptResult);
		
		logger.debug("shareBoxSpam ended.");
		return new JSONObject(resultObject);
	}
	
	@RequestMapping(value="/ezEmail/getMailboxProgress.do", method = RequestMethod.POST)
	@ResponseBody
	@SuppressWarnings("unchecked")
	public MailboxProgressVO getMailboxProgress(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		String userKey = request.getParameter("userKey");
		MailboxProgressVO mailboxProgress = ezEmailService.getMailboxProgress(userKey);
		return mailboxProgress;
	}
	
	@RequestMapping(value="/ezEmail/delMailboxProgress.do", method = RequestMethod.POST)
	@ResponseBody
	public void delMailboxProgress(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("delMailboxProgress stared.");

		String userKey = request.getParameter("userKey");
		logger.debug("userKey=" + userKey);
		
		int resultInt = ezEmailService.delMailboxProgress(userKey);
		
		logger.debug("delMailboxProgress ended. result=" + resultInt);
	}

	@RequestMapping(value="/ezEmail/getUserKey.do", method = RequestMethod.POST)
	@ResponseBody
	public String getUserKey(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getUserKey stared.");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();
		
		UUID uuid = UUID.randomUUID();
    	String userkey = userId + String.valueOf(uuid);
		
		logger.debug("getUserKey ended.");
		return userkey;
	}

	@RequestMapping(value = "/ezEmail/getOriginalEML.do", method = RequestMethod.GET)
	public String getEmlText(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model ,HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("getOriginText started.");

		List<String> userInfo = commonUtil.getUserIdAndPassword(loginCookie);
		String password  = userInfo.get(1);

		LoginVO loginInfo = commonUtil.userInfo(loginCookie);
		String domainName = ezCommonService.getTenantConfig("DomainName", loginInfo.getTenantId());
		String userEmail = loginInfo.getId() + "@" + domainName;
		String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", loginInfo.getTenantId());

		if ("YES".equals(useSharedMailbox)) {
			String shareId = request.getParameter("shareId");
			logger.debug("shareId=" + shareId);

			if (shareId != null) {
				if (!ezEmailService.checkUserShareId(loginInfo.getId(), shareId, loginInfo.getTenantId())) {
					logger.debug("the user cannot access the shareId.");
					logger.debug("mailExport ended.");

					return "";
				}

				userEmail = shareId + "@" + domainName;
			}
		}

		logger.debug("userId=" + loginInfo.getId() + ",userEmail=" + userEmail);

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

			String mimetype = "application/octet-stream";
			response.setContentType(mimetype);

			if (folder == null || !folder.exists()) {
				logger.error("Folder not found. folderPath=" + folderPath);
			} else {
				folder.open(Folder.READ_ONLY);
				Message message = ((IMAPFolder)folder).getMessageByUID(uid);

				if (message == null) {
					logger.error("Message not found. uid=" + uid);
				} else {

					try (ByteArrayOutputStream outputStream = new ByteArrayOutputStream()) {
						message.writeTo(outputStream);
						String emlText = outputStream.toString();

						//escape 처리
						emlText	= StringEscapeUtils.escapeHtml3(emlText);

						model.addAttribute("emlText", emlText);
					} catch (Exception e) {
						logger.error(e.getMessage(), e);
					}
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


		logger.debug("getOriginText ended.");
		return "ezEmail/mailOriginalEMLViewer";
	}
	
	 
}
