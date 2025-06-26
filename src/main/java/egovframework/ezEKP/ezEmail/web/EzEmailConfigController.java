package egovframework.ezEKP.ezEmail.web;

import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.security.PrivateKey;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Objects;
import java.util.Optional;
import java.util.Properties;
import java.util.Set;
import java.util.TimeZone;

import javax.annotation.Resource;
import javax.mail.FetchProfile;
import javax.mail.Flags;
import javax.mail.Folder;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.UIDFolder;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.search.SearchTerm;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.XMLConstants;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

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
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.w3c.dom.*;

import com.sun.mail.pop3.POP3Folder;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.logic.IMAPAccess;
import egovframework.ezEKP.ezEmail.logic.POP3Access;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezEmail.util.EzEmailUtil;
import egovframework.ezEKP.ezEmail.vo.MailDeleteVO;
import egovframework.ezEKP.ezEmail.vo.MailDistributionVO;
import egovframework.ezEKP.ezEmail.vo.MailGeneralVO;
import egovframework.ezEKP.ezEmail.vo.MailPOP3VO;
import egovframework.ezEKP.ezEmail.vo.MailSharedMailboxVO;
import egovframework.ezEKP.ezEmail.vo.MailSignatureTemplateVO;
import egovframework.ezEKP.ezEmail.vo.MailSignatureVO;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;
import egovframework.let.utl.rest.JgwResult;
import egovframework.let.utl.rest.Rest;
import egovframework.let.utl.rest.Result;
import egovframework.let.utl.sim.service.EgovFileScrty;
import org.egovframe.rte.fdl.string.EgovStringUtil;

/**
 * @Description [Controller] 메일 환경설정
 * @author 오픈솔루션팀 이효민
 * @Modification Information
 * 
 *    수정일        수정자         수정내용
 *    ----------    ------    -------------------
 *    2016.05.10    이효민    신규작성
 *
 * @see
 */

@Controller
public class EzEmailConfigController extends EgovFileMngUtil {

	private static final Logger logger = LoggerFactory.getLogger(EzEmailConfigController.class);

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

	@Resource(name="crypto") 
	private EgovFileScrty egovFileScrty;
	
	@Autowired
	private EzOrganService ezOrganService;

	@Autowired
	private Rest rest;

	/**
	 * 메일 기본 환경설정 화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailConfig.do", method = RequestMethod.GET)
	public String mailConfig(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		logger.debug("mailConfig started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", userInfo.getTenantId());
		String useUserDefinedDL = ezCommonService.getTenantConfig("useUserDefinedDL", userInfo.getTenantId());
		
		if (useSharedMailbox.equals("YES")) {
			String shareId = request.getParameter("shareId");
			logger.debug("shareId=" + shareId);
			
			if (shareId != null) {
				if (!ezEmailService.checkUserShareId(userInfo.getId(), shareId, 4, userInfo.getTenantId())) {
					model.addAttribute("mainContent", egovMessageSource.getMessage("ezEmail.lhm81", locale));
					
					logger.debug("the user cannot access the shareId.");
					logger.debug("mailConfig ended.");
					
					return "ezCommon/error";
				} else {
					MailSharedMailboxVO shareInfo = ezEmailService.getSharedMailboxInfo(shareId, userInfo.getTenantId());
					
					model.addAttribute("shareId", shareId);
					model.addAttribute("shareName", shareInfo.getShareName());
				}
			}
		}
		
		if (useUserDefinedDL == null || useUserDefinedDL.trim().equals("")) {
			useUserDefinedDL = "NO";
		}
		
		String userEditor = "";
		String noneActiveX = "YES";
		String flag = request.getParameter("flag");
		String dotnetFlag = request.getParameter("dotnetFlag");
		
		userEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		String useEncryptZipForEmail = ezCommonService.getTenantConfig("UseEncryptZipForEmail", userInfo.getTenantId());
		if (useEncryptZipForEmail.equals("")) {
			useEncryptZipForEmail = "NO";
		}
		
		model.addAttribute("userId", userInfo.getId());
		model.addAttribute("useEncryptZipForEmail", useEncryptZipForEmail);
		model.addAttribute("userEditor", userEditor);
		model.addAttribute("noneActiveX", noneActiveX);
		model.addAttribute("useOnlyInnerMail", ezCommonService.getTenantConfig("UseOnlyInnerMail", userInfo.getTenantId()));
		model.addAttribute("flag", flag);
		model.addAttribute("dotnetFlag", dotnetFlag);
		model.addAttribute("userEditor", userEditor);
		model.addAttribute("useUserDefinedDL", useUserDefinedDL);
		model.addAttribute("useMailTag", "YES".equalsIgnoreCase(ezCommonService.getTenantConfig("useMailTag", userInfo.getTenantId())));

		logger.debug("mailConfig ended.");
		return "ezEmail/mailConfig";
	}

	/**
	 * 메일 기본 환경설정 내부 화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailGeneral.do", method = RequestMethod.GET)
	public String mailGeneral(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		logger.debug("mailGeneral started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		MailGeneralVO mailGeneralVO = ezEmailService.getMailGeneral(userInfo.getTenantId(), userInfo.getId()).get(0);

		String listCount = mailGeneralVO.getListCount() == null ? "" : mailGeneralVO.getListCount();
		String previewMode = mailGeneralVO.getPreviewMode() == null ? "OFF" : mailGeneralVO.getPreviewMode();
		String previewHListSize = mailGeneralVO.getPreviewHList() == null ? "50" : mailGeneralVO.getPreviewHList();
		String previewHContentSize = mailGeneralVO.getPreviewHContent() == null ? "50" : mailGeneralVO.getPreviewHContent();
		String previewWListSize = mailGeneralVO.getPreviewWList() == null ? "50" : mailGeneralVO.getPreviewWList();
		String previewWContentSize = mailGeneralVO.getPreviewWContent() == null ? "50" : mailGeneralVO.getPreviewWContent();
		String refreshInterval = mailGeneralVO.getRefreshInterval() == null ? "" : mailGeneralVO.getRefreshInterval();
		String keepDeleteLength = mailGeneralVO.getKeepDeleteLength() == null ? "" : mailGeneralVO.getKeepDeleteLength();
		String previewSubtree = mailGeneralVO.getPreviewSubTree() == null ? "" : mailGeneralVO.getPreviewSubTree();
		String textOption = mailGeneralVO.getTextOption();
		String mailSendObject = "";
		String previewMailImage = mailGeneralVO.getPreviewMailImage() == null ? "Y" : mailGeneralVO.getPreviewMailImage();
		String previewMail = mailGeneralVO.getPreviewMail() == null ? "N" : mailGeneralVO.getPreviewMail();
		String dotnetFlag = request.getParameter("dotnetFlag");
		String mailSearchPeriod = mailGeneralVO.getMailSearchPeriod() == null ? "sixMonth" : mailGeneralVO.getMailSearchPeriod();
		String defaultCursorPosition = mailGeneralVO.getDefaultCursorPosition() == null ? "recipient" : mailGeneralVO.getDefaultCursorPosition();
		String defaultSeparateSend = mailGeneralVO.getDefaultSeparateSend() == null ? "N" : mailGeneralVO.getDefaultSeparateSend();
		String useEachMailDefault = ezCommonService.getTenantConfig("useEachMailDefault", userInfo.getTenantId()) == null ? "NO" : ezCommonService.getTenantConfig("useEachMailDefault", userInfo.getTenantId()); // 메일 개별발신 디폴트 사용 여부(YES: 개별발송 사용, NO: 사용안함)
		String mailSendResult = mailGeneralVO.getMailSendResult() == null ? "failure" : mailGeneralVO.getMailSendResult();
		String primaryLang = ezCommonService.getTenantConfig("PrimaryLang", userInfo.getTenantId());
		String lang = userInfo.getLang();
		List<String> defaultFontFamilyList = Arrays.asList(egovMessageSource.getMessage("main.t0620", Locale.KOREA).split(";"));
		if (lang.equals("2")) {
			defaultFontFamilyList = Arrays.asList(egovMessageSource.getMessage("main.t0620", Locale.ENGLISH).split(";"));
		} else if (lang.equals("3")) {
			defaultFontFamilyList = Arrays.asList(egovMessageSource.getMessage("main.t0620", Locale.JAPAN).split(";"));
		} else if (lang.equals("4")) {
			defaultFontFamilyList = Arrays.asList(egovMessageSource.getMessage("main.t0620", Locale.CHINA).split(";"));
		} else if (lang.equals("5")) {
			defaultFontFamilyList = Arrays.asList(egovMessageSource.getMessage("main.t0620", new Locale("vi", "VN")).split(";"));
		} else if (lang.equals("6")) {
			defaultFontFamilyList = Arrays.asList(egovMessageSource.getMessage("main.t0620", new Locale("id", "ID")).split(";"));
		}
		List<String> defaultFontSizeList = Arrays.asList("8pt,9pt,10pt,11pt,12pt,13pt,14pt,16pt,18pt,20pt,24pt,30pt,36pt,54pt,72pt".split(","));
		String selfCcOption = mailGeneralVO.getSelfCcOption() == null ? "none" : mailGeneralVO.getSelfCcOption(); // 나를 항상 참조에 포함 선택. none : 사용안함(default) / cc : 나를 항상 참조에 포함 / bcc : 나를 항상 숨은참조에 포함

		String fontFamily = egovMessageSource.getMessage("main.t246", locale);
		String fontSize = "10pt";
		if (primaryLang.equals("1")) {
			String editorFontStyle = ezCommonService.getTenantConfig("editorFontStyle", userInfo.getTenantId());
			if (!editorFontStyle.equals("")) {
				fontFamily = editorFontStyle.split("\\|")[0];
				fontSize = editorFontStyle.split("\\|")[1];
			}
		}
		String editorFontFamily = mailGeneralVO.getEditorFontFamily() == null || mailGeneralVO.getEditorFontFamily().trim().isEmpty() ? fontFamily : mailGeneralVO.getEditorFontFamily();
		String editorFontSize = mailGeneralVO.getEditorFontSize() == null  || mailGeneralVO.getEditorFontSize().trim().isEmpty() ? fontSize : mailGeneralVO.getEditorFontSize();
		
		if (dotnetFlag != null) {
			dotnetFlag = commonUtil.stripTagSymbols(commonUtil.stripScriptTagsAndFunctions(dotnetFlag));
		}
		
		if (keepDeleteLength.equals("30")) {
			keepDeleteLength = "60";
		}
		
		String pMailSenderNM = mailGeneralVO.getMailSenderNm();
		
		if (pMailSenderNM == null) {
			pMailSenderNM = "";
		}
		
		String[] senderList = pMailSenderNM.split("\\|!\\-@\\-!\\|");
		for (int i=0; i<senderList.length; i++) {
			if (!(pMailSenderNM.indexOf("___") < 0)){
				if (senderList[i].startsWith("___")){
					mailSendObject += "<option value='" + senderList[i] + "' selected>" + senderList[i].substring(3) + " (default)</option>";
				} else {
					mailSendObject += "<option value='" + senderList[i] + "'>" + senderList[i] + "</option>";
				}
			} else {
				if (i == 0){
					mailSendObject += "<option value='" + senderList[i] + "' selected>" + senderList[i] + "</option>";
				} else {
					mailSendObject += "<option value='" + senderList[i] + "'>" + senderList[i] + "</option>";
				}
			}
		}
		
		String useOnlyInnerMail = ezCommonService.getTenantConfig("UseOnlyInnerMail", userInfo.getTenantId());
		String usePreviewSubTree = ezCommonService.getTenantConfig("UsePreviewSubTreeForEmail", userInfo.getTenantId());
		
		logger.debug("listCount=" + listCount + ",previewMode=" + previewMode  + ",previewHListSize=" + previewHListSize
				 + ",previewHContentSize=" + previewHContentSize + ",previewWListSize=" + previewWListSize + ",previewWContentSize=" + previewWContentSize
				 + ",refreshInterval=" + refreshInterval + ",keepDeleteLength=" + keepDeleteLength + ",mailSendObject=" + mailSendObject
				 + ",previewSubtree=" + previewSubtree + ",useOnlyInnerMail=" + useOnlyInnerMail + ",usePreviewSubTree=" + usePreviewSubTree
				 + ",previewMailImage=" + previewMailImage + ",previewMail=" + previewMail + ",textOption=" + textOption + ",mailSearchPeriod=" + mailSearchPeriod
				 + ",defaultCursorPosition=" + defaultCursorPosition + ",defaultSeparateSend=" + defaultSeparateSend + ",useEachMailDefault=" + useEachMailDefault
				 + ",mailSendResult=" + mailSendResult + ",primaryLang=" + primaryLang + ",editorFontFamily=" + editorFontFamily + ",editorFontSize=" + editorFontSize);
		
		model.addAttribute("listCount", listCount);
		model.addAttribute("previewMode", previewMode);
		model.addAttribute("previewHListSize", previewHListSize);
		model.addAttribute("previewHContentSize", previewHContentSize);
		model.addAttribute("previewWListSize", previewWListSize);
		model.addAttribute("previewWContentSize", previewWContentSize);
		model.addAttribute("refreshInterval", refreshInterval);
		model.addAttribute("keepDeleteLength", keepDeleteLength);
		model.addAttribute("mailSendObject", mailSendObject);
		model.addAttribute("useOnlyInnerMail", useOnlyInnerMail);
		model.addAttribute("previewSubTree", previewSubtree);
		model.addAttribute("usePreviewSubTree", usePreviewSubTree);
		model.addAttribute("previewMailImage", previewMailImage);
		model.addAttribute("previewMail", previewMail);
		model.addAttribute("textOption", textOption);
		model.addAttribute("mailSearchPeriod", mailSearchPeriod);
		model.addAttribute("mailSendResult", mailSendResult);
		model.addAttribute("dotnetFlag", dotnetFlag);
		model.addAttribute("defaultCursorPosition", defaultCursorPosition); // 메일쓰기창 기본 커서 위치/ recipient: 받는사람, content : 내용, subject : 제목
		model.addAttribute("defaultSeparateSend", defaultSeparateSend);
		model.addAttribute("useEachMailDefault", useEachMailDefault);
		model.addAttribute("editorFontFamily", editorFontFamily);
		model.addAttribute("editorFontSize", editorFontSize);
		model.addAttribute("primaryLang", primaryLang);
		model.addAttribute("defaultFontFamilyList", defaultFontFamilyList);
		model.addAttribute("defaultFontSizeList", defaultFontSizeList);
		model.addAttribute("selfCcOption", selfCcOption);

		logger.debug("mailGeneral ended.");
		
		return "ezEmail/mailGeneral";
	}
	
	/**
	 * 메일 보내는 사람이름을 수정하는 팝업 
	 */
	@RequestMapping(value="/ezEmail/mailExtSenderNM.do", method = RequestMethod.GET)
	public String mailExtSenderNM(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model) throws Exception{
		return "ezEmail/mailExtSenderNM";
	}


	/**
	 * 메일 환경 설정 저장 함수
	 */
	@RequestMapping(value="/ezEmail/mailGeneralSave.do", method=RequestMethod.POST,
			produces="text/xml; charset=utf-8")
	@ResponseBody
	public String mailGeneralSave(@CookieValue("loginCookie") String loginCookie,
			@RequestParam(value = "MODE", required = false) String mode,
			@RequestBody String bodyData, 
			Locale locale, 
			Model model) throws Exception {
		logger.debug("mailGeneralSave started.");		
		logger.debug("bodyData=" + bodyData);

		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		Document doc = commonUtil.convertStringToDocument(bodyData);

		String listCount = doc.getElementsByTagName("LISTCOUNT").item(0).getTextContent();
		
		if (!commonUtil.isIntNumber(listCount)) {
			return "";
		}
		
		String refreshInterval = doc.getElementsByTagName("REFRESHINTERVAL").item(0).getTextContent();
		
		if (!commonUtil.isIntNumber(refreshInterval)) {
			return "";
		}
		
		String keepDeleteLength = doc.getElementsByTagName("KEEPDELETELENGTH").item(0).getTextContent();
		
		if (!commonUtil.isIntNumber(keepDeleteLength)) {
			return "";
		}
		
		String previewMode = doc.getElementsByTagName("PREVIEWMODE").item(0).getTextContent();
		String previewWList = doc.getElementsByTagName("PREVIEWWLIST").item(0).getTextContent();

		if (!commonUtil.isIntNumber(previewWList)) {
			return "";
		}
		
		String previewWContent = doc.getElementsByTagName("PREVIEWWCONTENT").item(0).getTextContent();
		
		if (!commonUtil.isIntNumber(previewWContent)) {
			return "";
		}
		
		String previewHList = doc.getElementsByTagName("PREVIEWHLIST").item(0).getTextContent();

		if (!commonUtil.isIntNumber(previewHList)) {
			return "";
		}
		
		String previewHContent = doc.getElementsByTagName("PREVIEWHCONTENT").item(0).getTextContent();
		
		if (!commonUtil.isIntNumber(previewHContent)) {
			return "";
		}
		
		String previewMailImage = doc.getElementsByTagName("PREVIEWMAILIMAGE").item(0).getTextContent();
		String previewMail = doc.getElementsByTagName("PREVIEWMAIL").item(0).getTextContent();
		String textOption = doc.getElementsByTagName("TEXTOPTION").item(0).getTextContent();
		String mailSearchPeriod = doc.getElementsByTagName("MAILSEARCHPERIOD").item(0).getTextContent();
		String mailSendResult = doc.getElementsByTagName("MAILSENDRESULT").item(0).getTextContent();
		String mailSenderNm = "";
		String previewSubTree = "";
		String editorFontFamily = doc.getElementsByTagName("EDITORFONTFAMILY").item(0).getTextContent();
		String editorFontSize = doc.getElementsByTagName("EDITORFONTSIZE").item(0).getTextContent();
		
		String usePreviewSubTree = ezCommonService.getTenantConfig("UsePreviewSubTreeForEmail", userInfo.getTenantId());

		if (usePreviewSubTree.equals("YES")) {
			previewSubTree = doc.getElementsByTagName("PREVIEWSUBTREE").item(0).getTextContent();
		}

		if (mode != null && mode.equals("ALL")) {
			mailSenderNm = doc.getElementsByTagName("MAILSENDERNM").item(0).getTextContent();
		}
		
		String defaultCursorPosition = doc.getElementsByTagName("DEFAULTCURSORPOSITION").item(0).getTextContent();
		
		// 2024.09.09 한슬기 : 개별발신 기본 여부. 관리자 > 시스템 > 패라메터 > 개별발신 디폴트 사용이 '예'일 경우 사용자 개별발송 여부를 변경하지 않음
		String defaultSeparateSend = doc.getElementsByTagName("DEFAULTSEPARATESEND").item(0).getTextContent();
		if (StringUtils.isBlank(defaultSeparateSend)) {
			MailGeneralVO mailGeneralVO = ezEmailService.getMailGeneral(userInfo.getTenantId(), userInfo.getId()).get(0);
			defaultSeparateSend = StringUtils.defaultString(mailGeneralVO.getDefaultSeparateSend());
		}
		// 2025.02.11 한슬기 : 나를 항상 참조에 포함 선택. none : 사용안함(default) / cc : 나를 항상 참조에 포함 / bcc : 나를 항상 숨은참조에 포함
		String selfCcOption = doc.getElementsByTagName("SELFCCOPTION").item(0).getTextContent();

		logger.debug("userId=" + userInfo.getId() + ",listCount=" + listCount + ",refreshInterval=" + refreshInterval 
				+ ",keepDeleteLength=" + keepDeleteLength + ",previewMode=" + previewMode 
				+ ",previewWList=" + previewWList + ",previewWContent=" + previewWContent
				+ ",previewHList=" + previewHList + ",previewHContent=" + previewHContent
				+ ",mailSenderNm=" + mailSenderNm + ",previewSubTree=" + previewSubTree
				+ ",previewMailImage=" + previewMailImage + ",textOption=" + textOption
				+ ",mailSearchPeriod=" + mailSearchPeriod + ",defaultCursorPosition=" + defaultCursorPosition
				+ ",defaultSeparateSend=" + defaultSeparateSend	+ ",mailSendResult=" + mailSendResult
				+ ",previewMail=" +  previewMail 
				+ ",mailSendResult=" + mailSendResult
				+ ",editorFontFamily=" + editorFontFamily + ",editorFontSize=" + editorFontSize
				+ ",selfCcOption=" + selfCcOption
		);

		String rtnValue= "OK";

		try {
			MailGeneralVO mailGeneral = new MailGeneralVO();

			mailGeneral.setListCount(listCount);
			mailGeneral.setRefreshInterval(refreshInterval);
			mailGeneral.setKeepDeleteLength(keepDeleteLength);
			mailGeneral.setPreviewMode(previewMode);
			mailGeneral.setPreviewWList(previewWList);
			mailGeneral.setPreviewWContent(previewWContent);
			mailGeneral.setPreviewHList(previewHList);
			mailGeneral.setPreviewHContent(previewHContent);	
			mailGeneral.setMailSenderNm(mailSenderNm);
			mailGeneral.setPreviewSubTree(previewSubTree);
			mailGeneral.setPreviewMailImage(previewMailImage);
			mailGeneral.setPreviewMail(previewMail);
			mailGeneral.setTextOption(textOption);
			mailGeneral.setMailSearchPeriod(mailSearchPeriod);
			mailGeneral.setDefaultCursorPosition(defaultCursorPosition);
			mailGeneral.setDefaultSeparateSend(defaultSeparateSend);
			mailGeneral.setMailSendResult(mailSendResult);
			mailGeneral.setEditorFontFamily(editorFontFamily);
			mailGeneral.setEditorFontSize(editorFontSize);
			mailGeneral.setSelfCcOption(selfCcOption);

			ezEmailService.setMailGeneral(userInfo.getTenantId(), userInfo.getId(), mailGeneral, mode);
		} catch (RuntimeException e) {
			rtnValue = "ERROR:" + e.getMessage();
		} catch (Exception e) {
			rtnValue = "ERROR:" + e.getMessage();
		}

		logger.debug("rtnValue=" + rtnValue);
		logger.debug("mailGeneralSave ended.");
		
		return rtnValue;
	}

	/**
	 * 메일 기본 환경설정 내부 화면(용량) 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailGetUse.do", method=RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String mailGetUse(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		logger.debug("mailGetUse started.");
		
		// get user credentials
		List<String> userIdAndPassword = commonUtil.getUserIdAndPassword(loginCookie);
		String password = userIdAndPassword.get(1);		
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
		String userEmail = userInfo.getId() + "@" + domainName;
		
		String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", userInfo.getTenantId());
		
		if (useSharedMailbox.equals("YES")) {
			String shareId = request.getParameter("shareId");
			logger.debug("shareId=" + shareId);
			
			if (shareId != null) {
				if (!ezEmailService.checkUserShareId(userInfo.getId(), shareId, userInfo.getTenantId())) {
					logger.debug("the user cannot access the shareId.");
					logger.debug("mailGetUse ended.");
					
					return "";
				}
				
				userEmail = shareId + "@" + domainName;
			}
		}
		
		logger.debug("userId=" + userInfo.getId() + ",userEmail=" + userEmail);
		String data = "";
		try {
			String url = "/rest/ezPortal/portlets/mailGetUse";
			HashMap<String, Object> param = new HashMap<String, Object>();
			param.put("userEmail", userEmail);
			param.put("password", password);
			param.put("locale", locale);

			String mail2 = "";
			if (request.getAttribute("mail2")!=null){
				mail2 = (String) request.getAttribute("mail2");
			}

			logger.debug("mailGetUse mail2=" + mail2);
			JSONObject resultBody = commonUtil.getJsonFromRestApi(url, param, request, "get", null);
			if ("y".equalsIgnoreCase(mail2)){
				resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.MailServerURL2"), url, param, request, "get", null);
			}

			String result = resultBody.get("status").toString();

			if (result.equals("ok")) {
				data = String.valueOf(resultBody.get("data"));
			}
		} catch (NumberFormatException e) {
			logger.debug(e.getMessage());
			logger.error(e.getMessage(), e);
		} catch (Exception e) {
			logger.debug(e.getMessage());
			logger.error(e.getMessage(), e);
		}
		return data;
	}


	/**
	 * 메일 자동 전달 설정 화면 표시 함수
	 */
	@RequestMapping(value="/ezEmail/mailAutoForward.do", method=RequestMethod.GET)
	public String mailAutoForward(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		logger.debug("mailAutoForward stated.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
		String userEmail = userInfo.getId() + "@" + domainName;

		String forwardAddress = getMailForwardAddress(userEmail);

		model.addAttribute("userId", userInfo.getId());
		model.addAttribute("userEmail", userEmail);
		model.addAttribute("forwardAddress", forwardAddress);
		
		logger.debug("userEmail=" + userEmail + ",forwardAddress=" + forwardAddress);
		logger.debug("mailAutoForward ended.");
		
		return "ezEmail/mailAutoForward";
	}

	/**
	 * 메일 자동 전달 설정 함수
	 */
	@RequestMapping(value="/ezEmail/mailAutoForwardSave.do", method=RequestMethod.POST,
			produces="text/xml; charset=utf-8")
	@ResponseBody	
	public String mailAutoForwardSave(@CookieValue("loginCookie") String loginCookie, @RequestBody String bodyData, Locale locale, Model model) throws Exception {
		logger.debug("mailAutoForwardSave started.");		
		logger.debug("bodyData=" + bodyData);

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
		String userEmail = userInfo.getId() + "@" + domainName;
		String useBlockExternalForwardAddress = ezCommonService.getTenantConfig("useBlockExternalForwardAddress", userInfo.getTenantId()); 
		
		Document doc = commonUtil.convertStringToDocument(bodyData != null ? bodyData : "");

		String forwardAddress = doc.getElementsByTagName("ADDRESS").item(0).getTextContent();
		String checkMyAddress = forwardAddress;
		String strResult = "Error";
		
		List<String> realAddress = ezEmailService.aliasMailCheck(forwardAddress);
		if (realAddress != null && realAddress.size() > 0) {
			checkMyAddress = realAddress.get(0);
		}

		if (!checkMyAddress.equalsIgnoreCase(userEmail)) {
			try {				
				InternetAddress internetAddress = new InternetAddress(forwardAddress);
				
				if ("YES".equals(useBlockExternalForwardAddress)) {
					//2023-04-04 김대현 외부 주소 허용 여부
					String isInnerDomain = ezEmailService.checkInnerDomain(forwardAddress, userInfo.getTenantId());
					
					if (!"OK".equals(isInnerDomain)) {
						// 내부메일도메인리스트에 없는경우 등록 불가
						strResult = "BlockExternalAddress";
					} else {
						// 외부 주소 허용 && 내부메일도메인리스트에도 있는 경우 등록
						strResult = setMailForwardAddress(userEmail, internetAddress.getAddress());
					}
					
				} else {
					strResult = setMailForwardAddress(userEmail, internetAddress.getAddress());
				}
			} catch (AddressException e) {
				logger.debug("e.message=" + e.getMessage());
			}
		}
		else {
			strResult = "MINE";
		}

		String returnData = "<RESULT>" + strResult + "</RESULT>";
		
		logger.debug("returnData=" + returnData);
		logger.debug("mailAutoForwardSave ended.");

		return returnData;		
	}

	/**
	 * 메일 자동 전달 설정 함수
	 */
	@RequestMapping(value="/ezEmail/mailAutoForwardDelete.do", method=RequestMethod.POST,
			produces="text/xml; charset=utf-8")
	@ResponseBody	
	public String mailAutoForwardDelete(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model) throws Exception {
		logger.debug("mailAutoForwardDelete started.");		
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
		String userEmail = userInfo.getId() + "@" + domainName;

		String strResult = deleteMailForwardAddress(userEmail);

		String returnData = "<RESULT>" + strResult + "</RESULT>";
		
		logger.debug("returnData=" + returnData);
		logger.debug("mailAutoForwardDelete ended.");

		return returnData;		
	}	

	/**
	 * JMocha Gateway Server에 메일 자동 전달 설정 요청을 보내는 함수
	 */	
	private String setMailForwardAddress(String userEmail, String forwardAddress) {
		logger.debug("setMailForwardAddress started.");
		
		String result = "Error";

		try {
			String userIdParam = "userId=" + URLEncoder.encode(userEmail, "UTF-8");
			String forwardAddressParam = "forwardAddress=" + URLEncoder.encode(forwardAddress, "UTF-8");
			String inputParams = userIdParam + "&" + forwardAddressParam;

			logger.debug("inputParams=" + inputParams);

			String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaAccess/setMailForwardAddress";
			String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);

			logger.debug("response=" + response);

			if (response != null) {
				JSONParser jsonParser = new JSONParser();
				JSONObject responseObj = (JSONObject)jsonParser.parse(response);

				result = (String)responseObj.get("resultCode");		        		        				
			}						
		} catch (UnsupportedEncodingException e) {
			logger.error(e.getMessage(), e);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("result=" + result);
		logger.debug("setMailForwardAddress ended.");
		
		return result;
	}

	/**
	 * JMocha Gateway Server로부터 메일 자동 전달 설정을 읽는 함수
	 */		
	private String getMailForwardAddress(String userEmail) {
		logger.debug("getMailForwardAddress started.");
		
		String result = "";

		try {
			String userIdParam = "userId=" + URLEncoder.encode(userEmail, "UTF-8");
			String inputParams = userIdParam;

			logger.debug("inputParams=" + inputParams);

			String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaAccess/getMailForwardAddress";
			String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);

			logger.debug("response=" + response);

			if (response != null) {
				JSONParser jsonParser = new JSONParser();
				JSONObject responseObj = (JSONObject)jsonParser.parse(response);

				String resultCode = (String)responseObj.get("resultCode");

				if (resultCode.equalsIgnoreCase("OK")) {
					JSONArray resultArray = (JSONArray)responseObj.get("result");

					if (resultArray != null && resultArray.size() > 0) {
						result = (String)resultArray.get(0);
					}
				}				
			}						
		} catch (ParseException e) {
			logger.error(e.getMessage(), e);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("result=" + result);
		logger.debug("getMailForwardAddress ended.");
		
		return result;
	}

	/**
	 * JMocha Gateway Server에 메일 자동 전달 삭제 요청을 보내는 함수
	 */	
	private String deleteMailForwardAddress(String userEmail) {
		logger.debug("deleteMailForwardAddress started.");
		
		String result = "Error";

		try {
			String inputParams = "userId=" + URLEncoder.encode(userEmail, "UTF-8");
			logger.debug("inputParams=" + inputParams);

			String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaAccess/deleteMailForwardAddress";			
			String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);

			logger.debug("response=" + response);

			if (response != null) {
				JSONParser jsonParser = new JSONParser();
				JSONObject responseObj = (JSONObject)jsonParser.parse(response);

				result = (String)responseObj.get("resultCode");		        		        				
			}						
		} catch (ParseException e) {
			logger.error(e.getMessage(), e);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("result=" + result);
		logger.debug("deleteMailForwardAddress ended.");
		
		return result;
	}

	/**
	 * 메일 서명관리 화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailSignature.do", method=RequestMethod.GET)
	public String mailSignature(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		logger.debug("mailSignature started.");
		
		String signState = "0";
		String signature1 = "";
		String signature2 = "";
		String signature3 = "";
		String serverName = "";
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String userId = userInfo.getId();
		
		String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", userInfo.getTenantId());
		if (useSharedMailbox.equals("YES")) {
			String shareId = request.getParameter("shareId");
			logger.debug("shareId=" + shareId);
			
			if (shareId != null) {
				// 관리권한 체크 = 4
				if (!ezEmailService.checkUserShareId(userInfo.getId(), shareId, 4, userInfo.getTenantId())) {
					model.addAttribute("mainContent", egovMessageSource.getMessage("ezEmail.lhm81", locale));
					logger.debug("the user cannot access the shareId.");

					return "ezCommon/error";
				} else {
					userId = shareId;
					logger.debug("userId=" + userId);
					
					model.addAttribute("shareId", shareId);
				}
			}
		}
		
		MailSignatureVO mailSignatureVO = ezEmailService.getMailSignature(userInfo.getTenantId(), userId);
		
		String defaultFontAndSize = "style='font-size:13px;font-family:" + egovMessageSource.getMessage("main.t246", locale) + "'";
		
		String useSignatureTemplate = ezCommonService.getTenantConfig("useSignatureTemplate", userInfo.getTenantId());
		if (useSignatureTemplate == null || useSignatureTemplate.equals("")) {
			useSignatureTemplate = "NO";
		}
		
		if (useSignatureTemplate.equals("YES")) {
			// 서명 템플릿 선택 (보기)
			JSONArray returnJsonArr = new JSONArray();

			try {
				returnJsonArr = ezEmailService.selectAllSignatureTemplate(userInfo.getCompanyID(), Integer.toString(userInfo.getTenantId()));
				logger.debug("jsonArr=" + returnJsonArr);
			} catch (RuntimeException e) {
				logger.debug("e.message=" + e.getMessage());
			} catch (Exception e) {
				logger.debug("e.message=" + e.getMessage());
			}
			
			List<MailSignatureTemplateVO> resultList = new ArrayList<MailSignatureTemplateVO>();
			
			for (int i = 0; i < returnJsonArr.size(); i++) {
				JSONObject obj = (JSONObject) returnJsonArr.get(i);
				MailSignatureTemplateVO vo = new MailSignatureTemplateVO();
				vo.setDisplayname(obj.get("displayname").toString());
				vo.setDisplayname2(obj.get("displayname2").toString());
				vo.setSignNo(obj.get("signNo").toString());
				
				resultList.add(vo);
			}
			
			logger.debug("mailTemplateList=" + resultList);
			model.addAttribute("list", resultList);
		}
		
		
		//사용자 언어가 한국어이고 editorFontStyle값이 있을 경우 editorFontStyle값 적용
		if (userInfo.getLang().equals("1")) {
			String editorFontStyle = ezCommonService.getTenantConfig("editorFontStyle", userInfo.getTenantId());
			
			if (!editorFontStyle.equals("")) {
				String fontFamily = editorFontStyle.split("\\|")[0];
				String fontSize = editorFontStyle.split("\\|")[1];
				
				// 사용자가 메일환경설정에서 설정한 에디터 폰트 값이 있으면 그 값을 사용하고, 없으면 관리자페이지에서 설정한 에디터 폰트 사용
				MailGeneralVO mailGeneralVO = ezEmailService.getMailGeneral(userInfo.getTenantId(), userInfo.getId()).get(0);
				String editorFontFamily = mailGeneralVO.getEditorFontFamily() == null || mailGeneralVO.getEditorFontFamily().trim().isEmpty()? fontFamily : mailGeneralVO.getEditorFontFamily();
				String editorFontSize = mailGeneralVO.getEditorFontSize() == null || mailGeneralVO.getEditorFontSize().trim().isEmpty()? fontSize : mailGeneralVO.getEditorFontSize();
				
				defaultFontAndSize = "style='font-size:" + editorFontSize + ";font-family:" + editorFontFamily + "'";
			}
		}
		
		if (mailSignatureVO != null) {
			signState = mailSignatureVO.getUseFlag().trim();
			signature1 = EgovStringUtil.isEmpty(mailSignatureVO.getContent1()) ? "<div><p " + defaultFontAndSize + ">&nbsp;</p></div>" : mailSignatureVO.getContent1();
			signature2 = EgovStringUtil.isEmpty(mailSignatureVO.getContent2()) ? "<div><p " + defaultFontAndSize + ">&nbsp;</p></div>" : mailSignatureVO.getContent2();
			signature3 = EgovStringUtil.isEmpty(mailSignatureVO.getContent3()) ? "<div><p " + defaultFontAndSize + ">&nbsp;</p></div>" : mailSignatureVO.getContent3();
		} else {
			signature1 = "<div><p " + defaultFontAndSize + ">&nbsp;</p></div>";
			signature2 = "<div><p " + defaultFontAndSize + ">&nbsp;</p></div>";
			signature3 = "<div><p " + defaultFontAndSize + ">&nbsp;</p></div>";
		}

		serverName = userInfo.getServerName();

		logger.debug("signState : " + signState);
		logger.debug("signature1 : " + signature1);
		logger.debug("signature2 : " + signature2);
		logger.debug("signature3 : " + signature3);
		logger.debug("serverName : " + serverName);
		logger.debug("userId : " + userInfo.getId());
		logger.debug("userLang=" + userInfo.getPrimary());
		logger.debug("useSignatureTemplate=" + useSignatureTemplate);
		
		model.addAttribute("signState", signState);
		model.addAttribute("signature1", signature1);
		model.addAttribute("signature2", signature2);
		model.addAttribute("signature3", signature3);
		model.addAttribute("serverName", serverName);
		model.addAttribute("userId", userInfo.getId());
		model.addAttribute("userLang", userInfo.getPrimary());
		model.addAttribute("useSignatureTemplate", useSignatureTemplate);
		
		logger.debug("mailSignature ended.");
		
		return "ezEmail/mailSignature";
	}

	/**
	 * 메일 서명관리 저장 실행 함수
	 */
	@RequestMapping(value="/ezEmail/mailSignSave.do", method=RequestMethod.POST)
	@ResponseBody
	public String mailSignSave(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, @RequestBody String bodyData) throws Exception{
		logger.debug("mailSignSave started.");
		logger.debug("bodyData=" + bodyData);
		
		String rtnValue = "OK";
		
		Document xmlDoc = commonUtil.convertStringToDocument(bodyData != null ? bodyData : "");
		Element root = xmlDoc.getDocumentElement();
		Node tempNode = null;
		
		String pUseFlag = "";
		String pContent1 = "";
		String pContent2 = "";
		String pContent3 = "";
		String shareId = "";

		if (root.getElementsByTagName("USEFLAG") != null) {
			tempNode = root.getElementsByTagName("USEFLAG").item(0);
			if (tempNode != null && !tempNode.getTextContent().equals("")) {
				pUseFlag = tempNode.getTextContent();
			}
		}
		if (root.getElementsByTagName("CONTENT1") != null) {
			tempNode = root.getElementsByTagName("CONTENT1").item(0);
			if (tempNode != null && !tempNode.getTextContent().equals("")) {
				pContent1 = tempNode.getTextContent();
			}
		}
		if (root.getElementsByTagName("CONTENT2") != null) {
			tempNode = root.getElementsByTagName("CONTENT2").item(0);
			if (tempNode != null && !tempNode.getTextContent().equals("")) {
				pContent2 = tempNode.getTextContent();
			}
		}
		if (root.getElementsByTagName("CONTENT3") != null) {
			tempNode = root.getElementsByTagName("CONTENT3").item(0);
			if (tempNode != null && !tempNode.getTextContent().equals("")) {
				pContent3 = tempNode.getTextContent();
			}
		}
		if (root.getElementsByTagName("SHAREID") != null) {
			tempNode = root.getElementsByTagName("SHAREID").item(0);
			if (tempNode != null && !tempNode.getTextContent().equals("")) {
				shareId = tempNode.getTextContent();
			}
		}
		
		try {
			LoginVO userInfo = commonUtil.userInfo(loginCookie);
			String userId = userInfo.getId();
			
			if (shareId != null && !shareId.equals("")) {
				userId = shareId;
			}
			
			ezEmailService.setMailSignature(userInfo.getTenantId(), userId, pUseFlag, pContent1, pContent2, pContent3);
		} catch (RuntimeException e) {
			rtnValue = "ERROR : " + e.getMessage();
			logger.error("rtnValue=" + rtnValue);
		} catch (Exception e) {
			rtnValue = "ERROR : " + e.getMessage();
			logger.error("rtnValue=" + rtnValue);
		}
		
		logger.debug("mailSignSave ended.");
		
		return rtnValue;
	}

	/**
	 * 메일 자동삭제 화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailAutoDelete.do", method=RequestMethod.GET)
	public String mailAutoDelete(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		logger.debug("mailAutoDelete started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", userInfo.getTenantId());

		String userId = userInfo.getId();
		if (useSharedMailbox.equals("YES")) {
			String shareId = request.getParameter("shareId");
			logger.debug("shareId='" + shareId + "'");
			
			if (shareId != null) {
				if (!ezEmailService.checkUserShareId(userInfo.getId(), shareId, 4, userInfo.getTenantId())) {
					model.addAttribute("mainContent", egovMessageSource.getMessage("ezEmail.lhm81", locale));
					
					logger.debug("the user cannot access the shareId.");
					logger.debug("mailConfig ended.");
					
					return "ezCommon/error";
				} else {
					userId = shareId;
					model.addAttribute("shareId", shareId);
				}
			} 			
		}
		
		List<MailDeleteVO> list = ezEmailService.getMailDelete(userInfo.getTenantId(), userId);
		
		for (MailDeleteVO vo : list) {
			if (vo.getDeleteUnread().trim().equals("1")) {
				vo.setDeleteUnread("checked");
			}
		}
		
		model.addAttribute("list", list);
		
		logger.debug("mailAutoDelete ended.");
		
		return "ezEmail/mailAutoDelete";
	}

	/**
	 * 메일 편지함선택 화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailSelectFolder.do", method=RequestMethod.GET)
	public String mailSelectFolder(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		logger.debug("mailSelectFolder started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", userInfo.getTenantId());

		if (useSharedMailbox.equals("YES")) {
			String shareId = request.getParameter("shareId");
			logger.debug("shareId=" + shareId);
			
			if (shareId != null) {
				if (!ezEmailService.checkUserShareId(userInfo.getId(), shareId, 4, userInfo.getTenantId())) {
					model.addAttribute("mainContent", egovMessageSource.getMessage("ezEmail.lhm81", locale));
					
					logger.debug("the user cannot access the shareId.");
					logger.debug("mailSelectFolder ended.");
					
					return "ezCommon/error";
				} else {
					model.addAttribute("shareId", shareId);
				}
			}
		}
		
		logger.debug("mailSelectFolder ended.");
		return "ezEmail/mailSelectFolder";
	}

	/**
	 * 메일 자동삭제 조건추가 실행 함수
	 */
	@RequestMapping(value="/ezEmail/mailAutoDeleteAdd.do", method=RequestMethod.GET)
	public String mailAutoDeleteAdd(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request, 
			HttpServletResponse response, RedirectAttributes redirectAttribute) throws Exception{
		logger.debug("mailAutoDeleteAdd started.");
		
		String path = request.getParameter("path") == null ? "" : request.getParameter("path");
		String expireTimeStr = request.getParameter("expiretime") == null ? "" : request.getParameter("expiretime");
		int expireTime = expireTimeStr.equals("") ? 0 : Integer.parseInt(expireTimeStr);
		String deleteUnreadStr = request.getParameter("unread") == null ? "" : request.getParameter("unread");
		int deleteUnread = deleteUnreadStr.equals("") ? 0 : Integer.parseInt(deleteUnreadStr);
		String folderName = request.getParameter("foldername") == null ? "" : request.getParameter("foldername");

		String autoDeletionOption = request.getParameter("autoDeletionOption" ) == null ? "" : request.getParameter("autoDeletionOption");

		logger.debug("path=" + path + ",expireTime=" + expireTime
				 + ",deleteUnread=" + deleteUnread + ",folderName=" + folderName + ",autoDeletionOption=" + autoDeletionOption);

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", userInfo.getTenantId());
		String userId = userInfo.getId();
		
		if (useSharedMailbox.equals("YES")) {
			String shareId = request.getParameter("shareId");
			logger.debug("shareId=" + shareId);
			
			if (shareId != null && !shareId.equals("")) {
				if (!ezEmailService.checkUserShareId(userInfo.getId(), shareId, 4, userInfo.getTenantId())) {
					model.addAttribute("mainContent", egovMessageSource.getMessage("ezEmail.lhm81", locale));
					
					logger.debug("the user cannot access the shareId.");
					logger.debug("mailInboxRule ended.");
					
					return "ezCommon/error";
					
				} else {
					userId = shareId;
					redirectAttribute.addAttribute("shareId", shareId);
				}
			} 
		}
		// 2025.02.18 한슬기 : 편지함 메일 자동삭제 방식 선택옵션(지운편지함으로이동(default) : trash / 영구삭제 : permanently) 파라미터(autoDeletionOption) 추가
		ezEmailService.setMailDelete(userInfo.getTenantId(), userId, path, expireTime, deleteUnread, folderName, autoDeletionOption);
		
		logger.debug("mailAutoDeleteAdd ended. redirect to /ezEmail/mailAutoDelete.do");
		return "redirect:/ezEmail/mailAutoDelete.do";
	}

	/**
	 * 메일 자동삭제 조건삭제 실행 함수
	 */
	@RequestMapping(value="/ezEmail/mailAutoDeleteDelete.do", method=RequestMethod.GET)
	public String mailAutoDeleteDelete(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request, 
			HttpServletResponse response, RedirectAttributes redirectAttribute) throws Exception{
		logger.debug("mailAutoDeleteDelete started.");
		
		String folderPath = request.getParameter("folderPath");
		logger.debug("folderPath=" + folderPath);
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", userInfo.getTenantId());
		String userId = userInfo.getId();
		
		if (useSharedMailbox.equals("YES")) {
			String shareId = request.getParameter("shareId");
			logger.debug("shareId=" + shareId);
			
			if (shareId != null && !shareId.equals("")) {
				if (!ezEmailService.checkUserShareId(userInfo.getId(), shareId, 4, userInfo.getTenantId())) {
					model.addAttribute("mainContent", egovMessageSource.getMessage("ezEmail.lhm81", locale));
					
					logger.debug("the user cannot access the shareId.");
					logger.debug("mailInboxRule ended.");
					
					return "ezCommon/error";
					
				} else {
					userId = shareId;
					redirectAttribute.addAttribute("shareId", shareId);
				}
			}
		}
		
		ezEmailService.deleteMailDelete(userInfo.getTenantId(), userId, folderPath);
		
		logger.debug("mailAutoDeleteDelete ended. redirect to /ezEmail/mailAutoDelete.do");
		return "redirect:/ezEmail/mailAutoDelete.do";
	}

	/**
	 * 메일 자동분류 화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailInboxRule.do", method=RequestMethod.GET)
	public String mailInboxRule(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		logger.debug("mailInboxRule started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", userInfo.getTenantId());

		if (useSharedMailbox.equals("YES")) {
			String shareId = request.getParameter("shareId");
			logger.debug("shareId=" + shareId);
			
			if (shareId != null) {
				if (!ezEmailService.checkUserShareId(userInfo.getId(), shareId, 4, userInfo.getTenantId())) {
					model.addAttribute("mainContent", egovMessageSource.getMessage("ezEmail.lhm81", locale));
					
					logger.debug("the user cannot access the shareId.");
					logger.debug("mailInboxRule ended.");
					
					return "ezCommon/error";
				} else {
					model.addAttribute("shareId", shareId);
				}
			}
		}
		
		logger.debug("mailInboxRule ended.");
		return "ezEmail/mailInboxRule";
	}

	/**
	 * 메일 자동분류 룰 추가 화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailNewInboxRule.do", method=RequestMethod.GET)
	public String mailNewInboxRule(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		logger.debug("mailNewInboxRule started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", userInfo.getTenantId());
		String useBlockExternalForwardAddress = ezCommonService.getTenantConfig("useBlockExternalForwardAddress", userInfo.getTenantId());
		
		if (useSharedMailbox.equals("YES")) {
			String shareId = request.getParameter("shareId");
			logger.debug("shareId=" + shareId);
			
			if (shareId != null) {
				if (!ezEmailService.checkUserShareId(userInfo.getId(), shareId, 4, userInfo.getTenantId())) {
					model.addAttribute("mainContent", egovMessageSource.getMessage("ezEmail.lhm81", locale));
					
					logger.debug("the user cannot access the shareId.");
					logger.debug("mailNewInboxRule ended.");
					
					return "ezCommon/error";
				} else {
					MailSharedMailboxVO shareInfo = ezEmailService.getSharedMailboxInfo(shareId, userInfo.getTenantId());
					
					model.addAttribute("shareId", shareId);
					model.addAttribute("shareName", shareInfo.getShareName());
				}
			}
		}
		// 2023_04-05 메일환경설정>자동분류에서 useBlockExternalForwardAddress 사용유무 판단을 위해 담아줌
		model.addAttribute("useBlockExternalForwardAddress", useBlockExternalForwardAddress);
		
		logger.debug("mailNewInboxRule ended.");
		return "ezEmail/mailNewInboxRule";
	}

	/**
	 * 메일 자동분류 룰 추가/수정 실행 함수
	 */
	@RequestMapping(value="/ezEmail/mailSetInboxRule.do", method=RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String mailSetInboxRule(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		logger.debug("mailSetInboxRule started.");
		
		String mode = request.getParameter("mode");

		StringBuilder sb = new StringBuilder();

		Document doc = commonUtil.convertRequestToDocument(request);
		if (doc != null){
			String displayName = doc.getElementsByTagName("NAME").item(0).getTextContent();
			sb.append("displayName=" + URLEncoder.encode(displayName, "UTF-8"));
		}
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
		String userAccount = userInfo.getId() + "@" + domainName;
		String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", userInfo.getTenantId());
		
		if (useSharedMailbox.equals("YES")) {
			String shareId = request.getParameter("shareId");
			logger.debug("shareId=" + shareId);
			
			if (shareId != null) {
				if (!ezEmailService.checkUserShareId(userInfo.getId(), shareId, 4, userInfo.getTenantId())) {
					logger.debug("the user cannot access the shareId.");
					logger.debug("mailSetInboxRule ended.");
					
					return "";
				} else {
					userAccount = shareId + "@" + domainName;
				}
			}
		}
		
		logger.debug("userAccount=" + userAccount);
		sb.append("&userId=" + URLEncoder.encode(userAccount, "UTF-8"));

		String returnValue = "Error";
		if (doc != null){
			//condition
			Node condition = doc.getElementsByTagName("CONDITION").item(0);
			NodeList conRows = condition.getChildNodes();
			for (int i=0; i<conRows.getLength(); i++) {
				Node row = conRows.item(i);
				NodeList rowChilds = row.getChildNodes();

				for (int j=0; j<rowChilds.getLength(); j++) {
					if (rowChilds.item(j).getNodeName().equals("CONKIND")) {
						if (rowChilds.item(j).getTextContent().equals("null")) {
							break;
						}
						sb.append("&type=condition");
						sb.append("&kind=" + URLEncoder.encode(rowChilds.item(j).getTextContent().toLowerCase(), "UTF-8"));
					} else if (rowChilds.item(j).getNodeName().equals("CONVALUE")) {
						if (rowChilds.item(j).getTextContent().equals("null")) {
							sb.append("&value=");
						} else {
							sb.append("&value=" + URLEncoder.encode(rowChilds.item(j).getTextContent(), "UTF-8"));
						}
					}
				}
			}

			//action
			Node action = doc.getElementsByTagName("ACTION").item(0);
			NodeList actRows = action.getChildNodes();
			for (int i=0; i<actRows.getLength(); i++) {
				Node row = actRows.item(i);
				NodeList rowChilds = row.getChildNodes();

				for (int j=0; j<rowChilds.getLength(); j++) {
					if (rowChilds.item(j).getNodeName().equals("ACTKIND")) {
						if (rowChilds.item(j).getTextContent().equals("null")) {
							break;
						}
						sb.append("&type=action");
						sb.append("&kind=" + URLEncoder.encode(rowChilds.item(j).getTextContent().toLowerCase(), "UTF-8"));

						if (rowChilds.item(j).getTextContent().equalsIgnoreCase("IMPORTANCE")) {
							sb.append("&value=" + rowChilds.item(j+1).getTextContent().toLowerCase());
							break;
						} else if (rowChilds.item(j).getTextContent().equalsIgnoreCase("READ") || rowChilds.item(j).getTextContent().equalsIgnoreCase("DELETE")) {
							sb.append("&value=");
							break;
						}

					} else if (rowChilds.item(j).getNodeName().equals("ACTVALUE") || rowChilds.item(j).getNodeName().equals("URL")) {
						if (rowChilds.item(j).getTextContent().equals("null")) {
							sb.append("&value=");
						} else {
							sb.append("&value=" + URLEncoder.encode(rowChilds.item(j).getTextContent(), "UTF-8"));
						}
					}
				}
			}

			//exception
			Node exception = doc.getElementsByTagName("EXCEPTION").item(0);
			NodeList exptRows = exception.getChildNodes();
			for (int i=0; i<exptRows.getLength(); i++) {
				Node row = exptRows.item(i);
				NodeList rowChilds = row.getChildNodes();

				for (int j=0; j<rowChilds.getLength(); j++) {
					if (rowChilds.item(j).getNodeName().equals("EXPTKIND")) {
						if (rowChilds.item(j).getTextContent().equals("null")) {
							break;
						}
						sb.append("&type=exception");
						sb.append("&kind=" + URLEncoder.encode(rowChilds.item(j).getTextContent().toLowerCase(), "UTF-8"));
					} else if (rowChilds.item(j).getNodeName().equals("EXPTVALUE")) {
						if (rowChilds.item(j).getTextContent().equals("null")) {
							sb.append("&value=");
						} else {
							sb.append("&value=" + URLEncoder.encode(rowChilds.item(j).getTextContent(), "UTF-8"));
						}
					}
				}
			}

			String inputParams = sb.toString();
			logger.debug("inputParams=" + inputParams);

			String strJson = "";

			if ("NEW".equalsIgnoreCase(mode)) { //룰 추가
				strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaAccess/setInboxRule", inputParams);
			} else if ("MOD".equalsIgnoreCase(mode)) { //룰 수정
				String ruleId = doc.getElementsByTagName("ITEMID").item(0).getTextContent();
				inputParams += "&ruleId=" + URLEncoder.encode(ruleId, "UTF-8");

				strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaAccess/updateInboxRule", inputParams);
			}

			JSONParser parser = new JSONParser();
			JSONObject object = (JSONObject)parser.parse(strJson);

			if (object.get("resultCode") != null) {
				returnValue = "<DATA><![CDATA[" + object.get("resultCode").toString() + "]]></DATA>";
			}
		}
		
		logger.debug("returnValue=" + returnValue);
		logger.debug("mailSetInboxRule ended.");
		
		return returnValue;
	}

	/**
	 * 메일 자동분류 룰 리스트 추출 함수
	 */
	@RequestMapping(value="/ezEmail/mailGetInboxRule.do", method=RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String mailGetInboxRule(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		logger.debug("mailGetInboxRule started.");
		
		String returnValue = "Error";
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
		String userAccount = userInfo.getId() + "@" + domainName;
		String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", userInfo.getTenantId());
		
		if (useSharedMailbox.equals("YES")) {
			String shareId = request.getParameter("shareId");
			logger.debug("shareId=" + shareId);
			
			if (shareId != null) {
				if (!ezEmailService.checkUserShareId(userInfo.getId(), shareId, 4, userInfo.getTenantId())) {
					logger.debug("the user cannot access the shareId.");
					logger.debug("mailGetInboxRule ended.");
					
					return "";
				} else {
					userAccount = shareId + "@" + domainName;
				}
			}
		}
		
		logger.debug("userAccount=" + userAccount);
		
		String sortType = request.getParameter("sortType");
		
		if (sortType == null || sortType.equals("") || sortType.equals("undefined") || sortType.equals("PRIORITY")) {
			sortType = " ORDER BY PRIORITY";
		} else {
			sortType = " ORDER BY RULE_NAME " + sortType;
		}
		
		String inputParams = "userId=" + URLEncoder.encode(userAccount, "UTF-8") + "&sortType=" + URLEncoder.encode(sortType, "UTF-8");
		logger.debug("inputParams=" + inputParams);
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaAccess/getInboxRule", inputParams);

		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(strJson);
		
		if (object.get("resultCode").equals("OK")) {
			JSONArray array = (JSONArray)object.get("result");

			DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
			docFactory.setFeature("http://apache.org/xml/features/disallow-doctype-decl", true);
			docFactory.setFeature("http://xml.org/sax/features/external-general-entities", false);
			docFactory.setFeature("http://xml.org/sax/features/external-parameter-entities", false);
			docFactory.setAttribute(XMLConstants.ACCESS_EXTERNAL_DTD, "");
			docFactory.setAttribute(XMLConstants.ACCESS_EXTERNAL_SCHEMA, "");
			docFactory.setXIncludeAware(false);
			docFactory.setExpandEntityReferences(false);

			DocumentBuilder docBuilder = docFactory.newDocumentBuilder();

			Document doc = docBuilder.newDocument();
			Element data = doc.createElement("DATA");
			doc.appendChild(data);

			Map<Integer, Element> ruleMap = new HashMap<Integer, Element>();

			for (int i=0; i<array.size(); i++) {
				JSONObject obj = (JSONObject)array.get(i);

				if (!ruleMap.containsKey(Integer.parseInt(obj.get("ruleId").toString()))) {
					Element row = doc.createElement("ROWS");
					data.appendChild(row);

					Element id = doc.createElement("ID");
					id.appendChild(doc.createCDATASection(obj.get("ruleId").toString()));
					row.appendChild(id);

					Element name = doc.createElement("NAME");
					name.appendChild(doc.createCDATASection(obj.get("ruleName").toString()));
					row.appendChild(name);

					Element use = doc.createElement("USE");
					use.appendChild(doc.createCDATASection(obj.get("isUse").toString().toUpperCase()));
					row.appendChild(use);

					Element priority = doc.createElement("PRIORITY");
					priority.appendChild(doc.createCDATASection(obj.get("priority").toString()));
					row.appendChild(priority);

					Element condition = doc.createElement("CONDITION");
					row.appendChild(condition);

					Element action = doc.createElement("ACTION");
					row.appendChild(action);

					Element exception = doc.createElement("EXCEPTION");
					row.appendChild(exception);

					ruleMap.put(Integer.parseInt(obj.get("ruleId").toString()), row);
				}

				Element tRow = ruleMap.get(Integer.parseInt(obj.get("ruleId").toString()));
				Element tCondition = null;
				Element tAction = null;
				Element tException = null;

				NodeList rowChilds = tRow.getChildNodes();

				for (int j=0; j<rowChilds.getLength(); j++) {
					if (rowChilds.item(j).getNodeName().equalsIgnoreCase("CONDITION")) {
						tCondition = (Element)rowChilds.item(j);
					} else if (rowChilds.item(j).getNodeName().equalsIgnoreCase("ACTION")) {
						tAction = (Element)rowChilds.item(j);
					} else if (rowChilds.item(j).getNodeName().equalsIgnoreCase("EXCEPTION")) {
						tException = (Element)rowChilds.item(j);
					}
				}

				// 2023-05-16 이사라 : NullPointerException 시큐어코딩 - tCondition, tAction, tException
				if (obj.get("type").toString().equalsIgnoreCase("CONDITION") && !Objects.isNull(tCondition)) {
					//DOMAIN, SENDER, RECEIVER, SUBJECT, BODY, SUBJECTORBODY
					Element kind = doc.createElement("KIND");
					kind.appendChild(doc.createCDATASection(obj.get("kind").toString().toUpperCase()));
					tCondition.appendChild(kind);

					Element values = doc.createElement("VALUES");
					values.appendChild(doc.createCDATASection(obj.get("value").toString()));
					tCondition.appendChild(values);

				} else if (obj.get("type").toString().equalsIgnoreCase("ACTION") && !Objects.isNull(tAction)) {
					//DELETE, READ, IMPORTANCE, REDIRECTION, FORWARD, MOVE, COPY
					//SKIP : ASSIGNCATE, NONE, FORWARDATTACH, SENDSMS, SERVREPLY
					if (obj.get("kind").toString().equalsIgnoreCase("DELETE") || obj.get("kind").toString().equalsIgnoreCase("REDIRECTION")
							|| obj.get("kind").toString().equalsIgnoreCase("FORWARD") || obj.get("kind").toString().equalsIgnoreCase("TAG")) {
						Element kind = doc.createElement("KIND");
						kind.appendChild(doc.createCDATASection(obj.get("kind").toString().toUpperCase()));
						tAction.appendChild(kind);

						Element values = doc.createElement("VALUES");
						values.appendChild(doc.createCDATASection(obj.get("value").toString()));
						tAction.appendChild(values);

					} else if (obj.get("kind").toString().equalsIgnoreCase("IMPORTANCE")) {
						Element kind = doc.createElement("KIND");
						kind.appendChild(doc.createCDATASection(obj.get("kind").toString().toUpperCase()));
						tAction.appendChild(kind);

						Element values = doc.createElement("VALUES");
						values.appendChild(doc.createCDATASection(obj.get("value").toString().toUpperCase()));
						tAction.appendChild(values);

					} else if (obj.get("kind").toString().equalsIgnoreCase("READ")) {
						Element kind = doc.createElement("KIND");
						kind.appendChild(doc.createCDATASection(obj.get("kind").toString().toUpperCase()));
						tAction.appendChild(kind);

						Element values = doc.createElement("VALUES");
						values.appendChild(doc.createCDATASection("READ"));
						tAction.appendChild(values);

					} else if (obj.get("kind").toString().equalsIgnoreCase("MOVE") || obj.get("kind").toString().equalsIgnoreCase("COPY")) {
						Element kind = doc.createElement("KIND");
						kind.appendChild(doc.createCDATASection(obj.get("kind").toString().toUpperCase()));
						tAction.appendChild(kind);

						Element folderId = doc.createElement("FOLDERID");
						folderId.appendChild(doc.createCDATASection(obj.get("value").toString()));
						tAction.appendChild(folderId);

						Element folderName = doc.createElement("FOLDERNAME");

						String folderNameStr = (String)obj.get("value");
												
						folderNameStr = ezEmailUtil.getDisplayNameFromFolderId(folderNameStr, locale);
						
						if (folderNameStr.lastIndexOf(".") > -1) {
							folderNameStr = folderNameStr.substring(folderNameStr.lastIndexOf(".")+1);
						}
						
						folderName.appendChild(doc.createCDATASection(folderNameStr));
						tAction.appendChild(folderName);

						Element values = doc.createElement("VALUES");
						values.appendChild(doc.createCDATASection(obj.get("kind").toString().toUpperCase()));
						tAction.appendChild(values);
					}
				} else if (obj.get("type").toString().equalsIgnoreCase("EXCEPTION") && !Objects.isNull(tException)) {
					//DOMAIN, SENDER, RECEIVER, SUBJECT, BODY, SUBJECTORBODY
					Element kind = doc.createElement("KIND");
					kind.appendChild(doc.createCDATASection(obj.get("kind").toString().toUpperCase()));
					tException.appendChild(kind);

					Element values = doc.createElement("VALUES");
					values.appendChild(doc.createCDATASection(obj.get("value").toString()));
					tException.appendChild(values);
				}
			}

			returnValue = commonUtil.convertDocumentToString(doc);
		}
		
		logger.debug("returnValue=" + returnValue);
		logger.debug("mailGetInboxRule ended.");
		
		return returnValue;
	}

	/**
	 * 메일 자동분류 룰 삭제 실행 함수
	 */
	@RequestMapping(value="/ezEmail/mailDeleteInboxRule.do", method=RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String mailDeleteInboxRule(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		logger.debug("mailDeleteInboxRule started.");
		
		String returnValue = "Error";

		Document doc = commonUtil.convertRequestToDocument(request);

		String ruleId = "";
		if (doc != null){
			ruleId = doc.getElementsByTagName("RULEID").item(0).getTextContent();
		}

		String inputParams = "ruleId=" + URLEncoder.encode(ruleId, "UTF-8");
		logger.debug("inputParams=" + inputParams);
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaAccess/deleteInboxRule", inputParams);

		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(strJson);

		if (object.get("resultCode") != null) {
			returnValue = "<DATA><![CDATA[" + object.get("resultCode").toString() + "]]></DATA>";
		}
		
		logger.debug("returnValue=" + returnValue);
		logger.debug("mailDeleteInboxRule ended.");
		
		return returnValue;
	}

	/**
	 * 메일 자동분류 룰 우선순위 변경 실행 함수
	 */
	@RequestMapping(value="/ezEmail/mailSetRulePriority.do", method=RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String mailSetRulePriority(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		logger.debug("mailSetRulePriority started.");
		
		String returnValue = "Error";

		Document doc = commonUtil.convertRequestToDocument(request);
		if (doc != null){
			String aRuleId = doc.getElementsByTagName("ARULEID").item(0).getTextContent();
			String aPriority = doc.getElementsByTagName("APRIORITY").item(0).getTextContent();
			String bRuleId = doc.getElementsByTagName("BRULEID").item(0).getTextContent();
			String bPriority = doc.getElementsByTagName("BPRIORITY").item(0).getTextContent();

			String inputParams = "aRuleId=" + URLEncoder.encode(aRuleId, "UTF-8");
			inputParams += "&aPriority=" + URLEncoder.encode(aPriority, "UTF-8");
			inputParams += "&bRuleId=" + URLEncoder.encode(bRuleId, "UTF-8");
			inputParams += "&bPriority=" + URLEncoder.encode(bPriority, "UTF-8");
			logger.debug("inputParams=" + inputParams);

			String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaAccess/setRulePriority", inputParams);

			JSONParser parser = new JSONParser();
			JSONObject object = (JSONObject)parser.parse(strJson);

			if (object.get("resultCode") != null) {
				returnValue = "<DATA><![CDATA[" + object.get("resultCode").toString() + "]]></DATA>";
			}
		}
		
		logger.debug("returnValue=" + returnValue);
		logger.debug("mailSetRulePriority ended.");
		
		return returnValue;
	}

	/**
	 * 메일 자동분류 룰 사용여부 변경 실행 함수
	 */
	@RequestMapping(value="/ezEmail/mailSetRuleStatus.do", method=RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String mailSetRuleStatus(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		logger.debug("mailSetRuleStatus started.");
		
		String returnValue = "Error";

		Document doc = commonUtil.convertRequestToDocument(request);
		if (doc != null){
			String ruleId = doc.getElementsByTagName("RULEID").item(0).getTextContent();
			String status = doc.getElementsByTagName("STATUS").item(0).getTextContent().toLowerCase();

			String inputParams = "ruleId=" + URLEncoder.encode(ruleId, "UTF-8");
			inputParams += "&status=" + URLEncoder.encode(status, "UTF-8");
			logger.debug("inputParams=" + inputParams);
			String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaAccess/setRuleStatus", inputParams);

			JSONParser parser = new JSONParser();
			JSONObject object = (JSONObject)parser.parse(strJson);

			if (object.get("resultCode") != null) {
				returnValue = "<DATA><![CDATA[" + object.get("resultCode").toString() + "]]></DATA>";
			}
		}
		
		logger.debug("returnValue=" + returnValue);
		logger.debug("mailSetRuleStatus ended.");
		
		return returnValue;
	}

	/**
	 * 메일 자동분류 룰 자세히보기 화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailDetailInboxRule.do", method=RequestMethod.GET)
	public String mailDetailInboxRule(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		logger.debug("mailDetailInboxRule started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", userInfo.getTenantId());
		
		if (useSharedMailbox.equals("YES")) {
			String shareId = request.getParameter("shareId");
			logger.debug("shareId=" + shareId);
			
			if (shareId != null) {
				if (!ezEmailService.checkUserShareId(userInfo.getId(), shareId, 4, userInfo.getTenantId())) {
					model.addAttribute("mainContent", egovMessageSource.getMessage("ezEmail.lhm81", locale));
					
					logger.debug("the user cannot access the shareId.");
					logger.debug("mailDetailInboxRule ended.");
					
					return "ezCommon/error";
				} else {
					MailSharedMailboxVO shareInfo = ezEmailService.getSharedMailboxInfo(shareId, userInfo.getTenantId());
					
					model.addAttribute("shareId", shareId);
					model.addAttribute("shareName", shareInfo.getShareName());
				}
			}
		}
		
		logger.debug("mailDetailInboxRule ended.");
		return "ezEmail/mailDetailInboxRule";
	}

	/**
	 * 메일 부재중 설정 화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailOutOfOffice.do", method=RequestMethod.GET)
	public String mailOutOfOffice(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model) throws Exception{
		logger.debug("mailOutOfOffice started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String gOofState = "disabled";
		String gStartDate = "";
		String gEndDate = "";
		String gExternalAudience = "known";
		String gInternal = "";
		String gExternal = "";

		String userLang = userInfo.getLang();

		String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
		String userId = userInfo.getId() + "@" + domainName;

		String inputParams = "userId=" + URLEncoder.encode(userId, "UTF-8");
		logger.debug("inputParams=" + inputParams);
		
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaAccess/getOutOfOffice", inputParams);

		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(strJson);

		if (object.get("resultCode").equals("OK") && object.get("result") != null) {
			JSONObject resultObject = (JSONObject)object.get("result");
			gOofState = resultObject.get("oofState").toString();
			gStartDate = resultObject.get("startDate").toString();
			gEndDate = resultObject.get("endDate").toString();
			gExternalAudience = resultObject.get("externalAudience").toString();
			gInternal = resultObject.get("internal").toString();
			gExternal = resultObject.get("external").toString();
		}
		
		String offset = userInfo.getOffset();
		
		String offsetMin = commonUtil.getMinuteUTC(offset);
		
		if (!gOofState.equals("scheduled")) {
			//get UTC time
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			sdf.setTimeZone(TimeZone.getTimeZone("GMT"));
			String dateStr = sdf.format(new Date());
			
			//get user time from UTC time
			dateStr = commonUtil.getDateStringInUTC(dateStr, offset, false);
			logger.debug("userCurrentTime=" + dateStr);
			
			String date = dateStr.substring(0, 10);
			String hour = dateStr.substring(11, 13);
			
			gStartDate = EgovDateUtil.addYMDtoDayTime(date, hour + ":00", 0, 0, 0, 1, 0, "yyyy-MM-dd HH:mm");
			gEndDate = EgovDateUtil.addYMDtoDayTime(date, hour + ":00", 0, 0, 1, 0, 0, "yyyy-MM-dd HH:mm");
		} else {
			//set user time from UTC time
			gStartDate = commonUtil.getDateStringInUTC(gStartDate, offset, false);
			gEndDate = commonUtil.getDateStringInUTC(gEndDate, offset, false);
		}
		
		String useOnlyInnerMail = ezCommonService.getTenantConfig("UseOnlyInnerMail", userInfo.getTenantId());
		
		logger.debug("gOofState=" + gOofState + ",gStartDate=" + gStartDate + ",gEndDate=" + gEndDate
				 + ",gExternalAudience=" + gExternalAudience + ",gInternal=" + gInternal + ",gExternal=" + gExternal
				 + ",useOnlyInnerMail=" + useOnlyInnerMail);
		
		JSONArray jsonArr = ezEmailService.getMailOutOfOfficeTemplateList(userId); 
		logger.debug("jsonArr = " + jsonArr);
		
		model.addAttribute("templateList", jsonArr);
		model.addAttribute("offsetMin", offsetMin);
		model.addAttribute("gOofState", gOofState);
		model.addAttribute("gStartDate", gStartDate);
		model.addAttribute("gEndDate", gEndDate);
		model.addAttribute("gExternalAudience", gExternalAudience);
		model.addAttribute("gInternal", gInternal);
		model.addAttribute("gExternal", gExternal);
		model.addAttribute("useOnlyInnerMail", useOnlyInnerMail);
		model.addAttribute("userLang", userLang);
		
		logger.debug("mailOutOfOffice ended.");
		
		return "ezEmail/mailOutOfOffice";
	}

	/**
	 * 메일 부재중 설정 저장 함수
	 */
	@RequestMapping(value="/ezEmail/mailOutOfOfficeSave.do", method=RequestMethod.POST)
	@ResponseBody
	public String mailOutOfOfficeSave(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		logger.debug("mailOutOfOfficeSave started.");
		
		String returnValue = "ERROR";

		Document doc = commonUtil.convertRequestToDocument(request);
		if (doc != null){
			String oofState = doc.getElementsByTagName("OOFSTATE").item(0).getTextContent();
			String startDate = doc.getElementsByTagName("STARTDATE").item(0).getTextContent();
			String endDate = doc.getElementsByTagName("ENDDATE").item(0).getTextContent();
			String internal = doc.getElementsByTagName("INTERNAL").item(0).getTextContent();
			String external = doc.getElementsByTagName("EXTERNAL").item(0).getTextContent();
			String externalAudience = doc.getElementsByTagName("EXTERNALAUDIENCE").item(0).getTextContent();

			//set UTC time
			LoginVO userInfo = commonUtil.userInfo(loginCookie);
			String offset = userInfo.getOffset();
			startDate = commonUtil.getDateStringInUTC(startDate, offset, true);
			endDate = commonUtil.getDateStringInUTC(endDate, offset, true);

			String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
			String userId = userInfo.getId() + "@" + domainName;

			StringBuilder sb = new StringBuilder();
			sb.append("userId=" + URLEncoder.encode(userId, "UTF-8"));
			sb.append("&oofState=" + URLEncoder.encode(oofState, "UTF-8"));
			sb.append("&startDate=" + URLEncoder.encode(startDate, "UTF-8"));
			sb.append("&endDate=" + URLEncoder.encode(endDate, "UTF-8"));
			sb.append("&internal=" + URLEncoder.encode(internal, "UTF-8"));
			sb.append("&external=" + URLEncoder.encode(external, "UTF-8"));
			sb.append("&externalAudience=" + URLEncoder.encode(externalAudience, "UTF-8"));

			String inputParams = sb.toString();
			logger.debug("inputParams=" + inputParams);

			String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaAccess/setOutOfOffice", inputParams);

			JSONParser parser = new JSONParser();
			JSONObject object = (JSONObject)parser.parse(strJson);

			if (object.get("resultCode") != null) {
				returnValue = object.get("resultCode").toString();
			}
		}

		logger.debug("returnValue=" + returnValue);
		logger.debug("mailOutOfOfficeSave ended.");
		
		return returnValue;

	}

	/**
	 * 외부메일 설정 화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailPop3.do", method=RequestMethod.GET)
	public String mailPop3(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		logger.debug("mailPop3 started.");

		String publicModulus = egovFileScrty.getPbm();
		String publicExponent = "10001";
		
		String prm = egovFileScrty.getPrm();
		String pre = egovFileScrty.getPre();
		PrivateKey pk = EgovFileScrty.getPrivateKey(prm, pre);
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userLang = userInfo.getLang();
		List<MailPOP3VO> pop3VoList = ezEmailService.getMailPOP3(userInfo.getTenantId(), userInfo.getId());
		
		StringBuilder sb = new StringBuilder();
		sb.append("<DATA>");
		
		for (MailPOP3VO pop3Vo : pop3VoList) {

			String pop3UserId = EgovFileScrty.decryptRsa(pk, pop3Vo.getPop3UserId());
			String pop3Pw = EgovFileScrty.decryptRsa(pk, pop3Vo.getPop3Pw());

			String pop3SslYN = "false";
			if (pop3Vo.getPop3SslYN().equals("1")) {
				pop3SslYN = "true";
			}

			sb.append("<ROW>");
			sb.append("<POP3SERVER>" + pop3Vo.getPop3Server() + "</POP3SERVER>");
			sb.append("<POP3PORTNO>" + pop3Vo.getPop3PortNo() + "</POP3PORTNO>");
			sb.append("<POP3USERID>" + commonUtil.cleanValue(pop3UserId) + "</POP3USERID>");
			sb.append("<POP3PW>" + commonUtil.cleanValue(pop3Pw) + "</POP3PW>");
			sb.append("<SAVETO>" + pop3Vo.getSaveTo() + "</SAVETO>");
			sb.append("<DELETEYN>" + pop3Vo.getDeleteYN() + "</DELETEYN>");
			sb.append("<POP3SSLYN>" + pop3SslYN + "</POP3SSLYN>");
			sb.append("<SAVETOFOLDER>" + commonUtil.cleanValue(pop3Vo.getSaveTofolder()) + "</SAVETOFOLDER>");
			sb.append("</ROW>");
		}

		sb.append("</DATA>");
		String infoXML = sb.toString();
		
		String primaryLang = ezCommonService.getTenantConfig("PrimaryLang", userInfo.getTenantId());
		
		model.addAttribute("infoXML", infoXML);
		model.addAttribute("publicModulus", publicModulus);
		model.addAttribute("publicExponent", publicExponent);
		model.addAttribute("primaryLang", primaryLang);
		model.addAttribute("userLang", userLang);
		
		int pop3MaxFetchSize;
		
		try {
			String pop3MaxFetchSizeStr = ezCommonService.getTenantConfig("Pop3MaxFetchSize", userInfo.getTenantId());
			pop3MaxFetchSize = Optional.ofNullable(pop3MaxFetchSizeStr).map(Integer::parseInt).orElse(40);
		} catch (NumberFormatException ex) {
			pop3MaxFetchSize = 40;
		} catch (Exception ex) {
			pop3MaxFetchSize = 40;
		}
		
		String pop3MaxFetchSizeMessage = egovMessageSource.getMessageExtend("ezEmail.t500", new Object[] { pop3MaxFetchSize }, locale);
		
		model.addAttribute("pop3MaxFetchSizeMessage", pop3MaxFetchSizeMessage);
		
		logger.debug("infoXML=" + infoXML);
		logger.debug("publicModulus=" + publicModulus);
		logger.debug("publicExponent=" + publicExponent);
		logger.debug("primaryLang=" + primaryLang);
		logger.debug("userLang={}", userLang);
		logger.debug("mailPop3 ended.");
		
		return "ezEmail/mailPop3";
	}

	/**
	 * 외부메일 설정 저장 실행 함수
	 */
	@RequestMapping(value="/ezEmail/mailPop3Save.do", method=RequestMethod.POST)
	@ResponseBody
	public String mailPop3Save(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, @RequestBody String ret) throws Exception{
		logger.debug("mailPop3Save started.");
		
		String rtnVal = "OK";
		
		try {
			LoginVO userInfo = commonUtil.userInfo(loginCookie);
			ezEmailService.savePop3(userInfo.getTenantId(), userInfo.getId(), ret);
		} catch (RuntimeException e) {
			rtnVal = "ERROR";
			logger.error(e.getMessage());
			logger.error(e.getMessage(), e);
		} catch (Exception e) {
			rtnVal = "ERROR";
			logger.error(e.getMessage());
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("mailPop3Save ended.");
		return rtnVal;
	}

	/**
	 * 외부메일 설정 접속확인 실행 함수
	 */
	@RequestMapping(value="/ezEmail/mailPop3Connect.do", method=RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String mailPop3Connect(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, @RequestBody String bodyData) throws Exception{
		logger.debug("mailPop3Connect started.");
		logger.debug("bodyData=" + bodyData);
		
		String returnValue = "<DATA>ERROR</DATA>";

		Document doc = commonUtil.convertStringToDocument(bodyData);
		String server = doc.getElementsByTagName("SERVER").item(0).getTextContent();
		String port = doc.getElementsByTagName("PORT").item(0).getTextContent();
		String id = doc.getElementsByTagName("ID").item(0).getTextContent();
		String pw = doc.getElementsByTagName("PW").item(0).getTextContent();
		String useSsl = doc.getElementsByTagName("SSL").item(0).getTextContent();

		String prm = egovFileScrty.getPrm();
		String pre = egovFileScrty.getPre();
		PrivateKey pk = EgovFileScrty.getPrivateKey(prm, pre);

		id = EgovFileScrty.decryptRsa(pk, id);
		pw = EgovFileScrty.decryptRsa(pk, pw);

		POP3Access pa = null;
		try {
			pa = POP3Access.getInstance(server, port, id, pw, useSsl);
			if (pa.checkConnect()) {
				returnValue = "<DATA>OK</DATA>";
			}
		} catch (RuntimeException e) {
			logger.error(e.getMessage());
		} catch (Exception e) {
			logger.error(e.getMessage());
		} finally {
			if (pa != null) {
				pa.close();
			}
		}
		
		logger.debug("returnValue=" + returnValue);
		logger.debug("mailPop3Connect ended.");
		
		return returnValue;
	}

	/**
	 * 외부메일 확인 실행 함수
	 */
	@RequestMapping(value="/ezEmail/mailGetPop3.do", method=RequestMethod.GET)
	@ResponseBody
	public void mailGetPop3(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletResponse response) throws Exception{
		logger.debug("mailGetPop3 started.");
		
		List<String> userInfo = commonUtil.getUserIdAndPassword(loginCookie);
		String password  = userInfo.get(1);
		
		LoginVO loginInfo = commonUtil.userInfo(loginCookie);
		String domainName = ezCommonService.getTenantConfig("DomainName", loginInfo.getTenantId());
		String userEmail = loginInfo.getId() + "@" + domainName;
		logger.debug("userEmail=" + userEmail);
		
		response.setContentType("text/html; charset=utf-8");

		PrintWriter out = response.getWriter();
		out.write("<!DOCTYPE html><head>");
		out.write("<title>" + egovMessageSource.getMessage("ezEmail.t490", locale) + "</title>");
		out.write("<META HTTP-EQUIV='Content-Type' CONTENT='text/html; charset=utf-8'>");
		out.write("<link rel='stylesheet' href='/css/default.css' type=text/css>");
		out.write("<link rel='stylesheet' href='" + egovMessageSource.getMessage("main.default.css", locale) + "' type=text/css>");
		out.write("<script type='text/javascript' src='/js/mouseeffect.js'></script>"
				+ "</head>"
				+ "<body scroll=no class='popup'>");
		out.write("<h1>" + egovMessageSource.getMessage("ezEmail.t490", locale) + "</h1>");
		out.write("<div id='close'><ul><li><span onClick='window.close()'></span></li></ul>");
		out.write("</div>"
				+ "<script type='text/javascript'>"
				/*+ "selToggleList(document.getElementById('close'), 'ul', 'li', '0');"*/
				+ "</script>"
				+ "<a  class='imgbtn'><span onClick='location.reload()'>" + egovMessageSource.getMessage("ezEmail.ldh05", locale) + "</span></a>"				
				+ "<div class='nobox' id='status_view' style='background-color:#FFFFFF; border-style:solid; border-width:1px; border-color:#ddd; overflow-y:auto; height:265px; overflow-x:auto; width:98%; padding-top:5px; padding-left:5px; padding-right:3px; margin-top:7px;'>");
		out.write(egovMessageSource.getMessage("ezEmail.t491", locale));
		out.flush();

		String prm = egovFileScrty.getPrm();
		String pre = egovFileScrty.getPre();
		PrivateKey pk = EgovFileScrty.getPrivateKey(prm, pre);
		
		List<MailPOP3VO> pop3Settinglist = ezEmailService.getMailPOP3(loginInfo.getTenantId(), loginInfo.getId());
		
		if (pop3Settinglist.size() == 0) {
			out.write("<BR> " + egovMessageSource.getMessage("ezEmail.t504", locale)
					+ "<BR>" + egovMessageSource.getMessage("ezEmail.t505", locale) + " > "
					+ egovMessageSource.getMessage("ezEmail.t506", locale));
			out.write("<BR><BR> " + egovMessageSource.getMessage("ezEmail.t507", locale));
			
			out.write("<span id='forscroll'></span>"
					+ "</div>"
					+ "<script type='text/javascript'>"
					+ "forscroll.scrollIntoView(false);"
					+ "</script></body>");
			out.flush();

			out.close();
			
			logger.debug("<BR> " + egovMessageSource.getMessage("ezEmail.t504", locale)
			+ "<BR>" + egovMessageSource.getMessage("ezEmail.t505", locale) + " > "
			+ egovMessageSource.getMessage("ezEmail.t506", locale));
			
			logger.debug("mailGetPop3 ended.");
			return;
		}
		
		IMAPAccess ia = null;
		try {
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userEmail, password, egovMessageSource, locale, ezEmailUtil);
			
			for (MailPOP3VO vo : pop3Settinglist) {
				String boxId = vo.getSaveTo();
				String boxName = vo.getSaveTofolder();
				String host = vo.getPop3Server();
				String port = vo.getPop3PortNo();
				String useSsl = vo.getPop3SslYN(); //0,1
				String id = vo.getPop3UserId();
				String pw = vo.getPop3Pw();
				String deleteYN = vo.getDeleteYN(); //Y,N
	
				String dId = EgovFileScrty.decryptRsa(pk, id);
				String dPw = EgovFileScrty.decryptRsa(pk, pw);
	
				if (useSsl.equals("1")) {
					useSsl = "true";
				} else {
					useSsl = "false";
				}
	
				out.write("<BR><BR>" + egovMessageSource.getMessage("ezEmail.t492", locale) + host + ", "
						+ egovMessageSource.getMessage("ezEmail.t493", locale) + dId
						+ "<BR>" + egovMessageSource.getMessage("ezEmail.t494", locale) + boxName
						+ "<BR>" + egovMessageSource.getMessage("ezEmail.t495", locale));
				out.flush();
				
				logger.debug("<BR><BR>" + egovMessageSource.getMessage("ezEmail.t492", locale) + host + ", "
						+ egovMessageSource.getMessage("ezEmail.t493", locale) + dId
						+ "<BR>" + egovMessageSource.getMessage("ezEmail.t494", locale) + boxName
						+ "<BR>" + egovMessageSource.getMessage("ezEmail.t495", locale));
				
				POP3Access pa = null;
	
				try {
					pa = POP3Access.getInstance(host, port, dId, dPw, useSsl);
					if (!pa.checkConnect()) {
						out.write("<BR>" + egovMessageSource.getMessage("ezEmail.t269", locale) + egovMessageSource.getMessage("ezEmail.lhm08", locale));
						out.flush();
						
						logger.debug("<BR>" + egovMessageSource.getMessage("ezEmail.t269", locale) + egovMessageSource.getMessage("ezEmail.lhm08", locale));
					} else {
						final Folder folder = pa.getFolder(ezEmailUtil.getInboxFolderId());
	
						if (deleteYN.equals("Y")) {
							folder.open(Folder.READ_WRITE);
						} else {
							folder.open(Folder.READ_ONLY);
						}
	
						Message[] messages = folder.getMessages();
						int mailCount = messages.length;
	
						// pre-fetch fields needed for searching
						FetchProfile fp = new FetchProfile();
						fp.add(UIDFolder.FetchProfileItem.UID);
						folder.fetch(messages, fp);
						
						// Throw exception when the pop3 server does not support UIDL.
						String testUID = ((POP3Folder)folder).getUID(messages[0]);
						if (testUID == null) {
							throw new Exception("Unsupported");
						}
						
						List<String> messageIdList = ezEmailService.getMailPOP3List(loginInfo.getTenantId(), loginInfo.getId(), host, id);
						
						final Set<String> messageIds = new HashSet<String>(messageIdList);
						@SuppressWarnings("serial")
						SearchTerm searchTerm= new SearchTerm() {
							@Override
							public boolean match(Message message) {
								try {
									String thisUID = ((POP3Folder)folder).getUID(message); 
	
									if (!messageIds.contains(thisUID)) {
										return true;
									}
								} catch (MessagingException e) {
									logger.error(e.getMessage(), e);
								}
								return false;
							}
						};
						
						messages = folder.search(searchTerm);
						int newCount = messages.length;
	
						out.write("<BR>" + egovMessageSource.getMessage("ezEmail.t498", locale) + mailCount 
								+ "<BR>" + egovMessageSource.getMessage("ezEmail.t499", locale) + newCount);
						out.flush();
						
						logger.debug("<BR>" + egovMessageSource.getMessage("ezEmail.t498", locale) + mailCount 
								+ "<BR>" + egovMessageSource.getMessage("ezEmail.t499", locale) + newCount);
						
						int pop3MaxFetchSize;
						
						try {
							String pop3MaxFetchSizeStr = ezCommonService.getTenantConfig("Pop3MaxFetchSize", loginInfo.getTenantId());
							pop3MaxFetchSize = Optional.ofNullable(pop3MaxFetchSizeStr).map(Integer::parseInt).orElse(40);
						} catch (NumberFormatException ex) {
							pop3MaxFetchSize = 40;
						} catch (Exception ex) {
							pop3MaxFetchSize = 40;
						}
						
						if (newCount > pop3MaxFetchSize) {
							String message = "<BR>" + egovMessageSource.getMessageExtend("ezEmail.t500", new Object[] { pop3MaxFetchSize }, locale);
							out.write(message);
							out.flush();
							
							logger.debug(message);
							
							messages = Arrays.copyOfRange(messages, 0, pop3MaxFetchSize);
						}
						
						Folder innerFolder = null;
						try {
							innerFolder = ia.getFolder(boxId);
							innerFolder.open(Folder.READ_WRITE);
							
							List<String> pop3MessageId = new ArrayList<String>();
							
							for (int i=0; i<messages.length; i++) {
								if (i%10 == 0) {
									if (messages.length < i + 10) {
										out.write("<BR>" + (i+1) + " - " + messages.length + egovMessageSource.getMessage("ezEmail.t501", locale));
										logger.debug("<BR>" + (i+1) + " - " + messages.length + egovMessageSource.getMessage("ezEmail.t501", locale));
									}
									else {
										out.write("<BR>" + (i+1) + " - " + (i+10) + egovMessageSource.getMessage("ezEmail.t501", locale));
										logger.debug("<BR>" + (i+1) + " - " + (i+10) + egovMessageSource.getMessage("ezEmail.t501", locale));
									}
									out.flush();
								}
								
								//TODO: 편지함 존재여부, 용량초과 Exception은 for문 그만돌고 error message를 찍어줘야함.
								// 그 외의 Exception은 계속 for문을 돌면서 메일을 가져와야함.
								String messageId = ((POP3Folder)folder).getUID(messages[i]);
								try {
									innerFolder.appendMessages(new Message[]{messages[i]});
									if (deleteYN.equals("Y")) {
										messages[i].setFlag(Flags.Flag.DELETED, true);
									}
									
									pop3MessageId.add(messageId);
								} catch (MessagingException e) {
									out.write("<BR>" + egovMessageSource.getMessage("ezEmail.t497", locale) + "messageId=" + messageId);
									out.flush();
									logger.debug("<BR>" + egovMessageSource.getMessage("ezEmail.t497", locale)
										+ "messageId=" + messageId + ",subject=" + messages[i].getSubject());
									logger.error(e.getMessage(), e);
								}
								
							}
							
							ezEmailService.setMailPOP3List(loginInfo.getTenantId(), loginInfo.getId(), host, id, pop3MessageId);
							
						} catch (MessagingException e) {
							out.write("<BR>" + egovMessageSource.getMessage("ezEmail.t497", locale)
							+ egovMessageSource.getMessage("ezEmail.t502", locale));
							out.flush();
							
							logger.error("<BR>" + egovMessageSource.getMessage("ezEmail.t497", locale)
							+ egovMessageSource.getMessage("ezEmail.t502", locale));
							
							logger.error(e.getMessage(), e);
						} finally {
							if (innerFolder != null) {
								innerFolder.close(true);
							}
						}
						
						folder.close(true);
					}
					
				} catch (MessagingException e) {
					out.write("<BR>" + egovMessageSource.getMessage("ezEmail.t497", locale) + e.getMessage());
					out.flush();
					
					logger.error("<BR>" + egovMessageSource.getMessage("ezEmail.t497", locale) + e.getMessage());
					
					logger.error(e.getMessage(), e);
				} catch (Exception e) {
					out.write("<BR>" + egovMessageSource.getMessage("ezEmail.t497", locale) + e.getMessage());
					out.flush();
					
					logger.error("<BR>" + egovMessageSource.getMessage("ezEmail.t497", locale) + e.getMessage());
					
					logger.error(e.getMessage(), e);
				} finally {
					if (pa != null) {
						pa.close();
					}
				}
	
			}
		
		} catch (RuntimeException e) {
			out.write("<BR>" + egovMessageSource.getMessage("ezEmail.t497", locale) + e.getMessage());
			out.flush();
			
			logger.error("<BR>" + egovMessageSource.getMessage("ezEmail.t497", locale) + e.getMessage());
			
			logger.error(e.getMessage(), e);
		} catch (Exception e) {
			out.write("<BR>" + egovMessageSource.getMessage("ezEmail.t497", locale) + e.getMessage());
			out.flush();
			
			logger.error("<BR>" + egovMessageSource.getMessage("ezEmail.t497", locale) + e.getMessage());
			
			logger.error(e.getMessage(), e);
		} finally {
			if (ia != null) {
				ia.close();
			}
		}
		
		out.write("<BR><BR> " + egovMessageSource.getMessage("ezEmail.t507", locale));
		out.write("<span id='forscroll'></span>"
				+ "</div>"
				+ "<script type='text/javascript'>"
				+ "forscroll.scrollIntoView(false);"
				+ "</script></body>");
		out.flush();
		out.close();
		
		logger.debug("mailGetPop3 ended.");
	}
	
	
	/**
	 * 수신자 자동완성 및 이름 확인의 주소 순서 설정 화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailAddressSearchOrder.do")
	public String mailAddressSearchOrder(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		logger.debug("mailAddressSearchOrder started.");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String mailAddressSearchOrder =  ezCommonService.getUserConfigInfo(userInfo.getTenantId(), userInfo.getId(), "mailAddressSearchOrder");
		logger.debug("mailAddressSearchOrder = " + mailAddressSearchOrder);
		if (mailAddressSearchOrder.equals("")) {
			
			String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", userInfo.getTenantId());
			mailAddressSearchOrder = "organ;address;dl";
			if (useSharedMailbox.equalsIgnoreCase("yes")) {
				mailAddressSearchOrder = "organ;address;dl;shared";
			}
			
			ezCommonService.insertUserConfigInfo(userInfo.getTenantId(), userInfo.getId(), "mailAddressSearchOrder", mailAddressSearchOrder);
		}
		
		model.addAttribute("mailAddressSearchOrder", mailAddressSearchOrder);
		
		logger.debug("mailAddressSearchOrder ended.");
		
		return "ezEmail/mailAddressSearchOrder";
	}
	
	
	/**
	 * 수신자 자동완성 및 이름 확인의 주소 순서 수정
	 */
	@RequestMapping(value = "/ezEmail/setMailAddressSearchOrder.do", produces = "text/xml; charset=utf-8")
	public String setMailAddressSearchOrder(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model,
			HttpServletRequest request) throws Exception {
		logger.debug("setMailAddressSearchOrder started.");

		String mailAddressSearchOrder = request.getParameter("mailAddressSearchOrder");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		logger.debug("mailAddressSearchOrder = " + mailAddressSearchOrder);
		try {
			if ("".equalsIgnoreCase(mailAddressSearchOrder)) {
				model.addAttribute("data", "FAIL");
			} else {
				ezCommonService.updateUserConfigInfo(userInfo.getTenantId(), userInfo.getId(), "mailAddressSearchOrder", mailAddressSearchOrder);
				model.addAttribute("data", "OK");
			}
		} catch (RuntimeException e) {
			model.addAttribute("data", "FAIL");
		} catch (Exception e) {
			model.addAttribute("data", "FAIL");
		}

		logger.debug("setMailAddressSearchOrder ended.");
		return "json";
	}
	
	/**
	 * 사용자 정의 공용배포그룹  화면 호출
	 */
	@RequestMapping(value="/ezEmail/mailUserDistribution.do")
	public String mailUserDistribution(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		logger.debug("mailUserDistribution started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		model.addAttribute("userId", userInfo.getId());
		
		logger.debug("mailUserDistribution ended.");
		
		return "ezEmail/mailUserDistributionMain";
	}
	
	/**
	 * 사용자 정의 공용배포그룹 
	 * - 소유 공용배포그룹
	 */
	@RequestMapping(value="/ezEmail/mailUserDistributionOwner.do")
	public String mailUserDistributionOwner(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		logger.debug("mailUserDistributionOwner started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		model.addAttribute("userId", userInfo.getId());
		model.addAttribute("companyId", userInfo.getCompanyID());
		
		logger.debug("mailUserDistributionOwner ended.");
		return "ezEmail/mailUserDistributionOwner";
	}

	/**
	 * 사용자 정의 공용배포그룹 
	 * - 소속 공용배포그룹
	 */
	@RequestMapping(value="/ezEmail/mailUserDistributionInclude.do")
	public String mailUserDistributionInclude(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		logger.debug("mailUserDistributionInclude started.");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		model.addAttribute("userId", userInfo.getId());
		model.addAttribute("companyId", userInfo.getCompanyID());
		logger.debug("mailUserDistributionInclude ended.");
		
		return "ezEmail/mailUserDistributionInclude";
	}

	/**
	 * 사용자 정의 공용배포그룹 
	 * - 검색
	 */
	@RequestMapping(value="/ezEmail/mailUserDistributionSearch.do")
	public String mailUserDistributionSearch(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		logger.debug("mailUserDistributionSearch started.");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		model.addAttribute("userId", userInfo.getId());
		model.addAttribute("companyId", userInfo.getCompanyID());
		logger.debug("mailUserDistributionSearch ended.");
		
		return "ezEmail/mailUserDistributionSearch";
	}

	/**
	 * 사용자 정의 공용배포그룹 
	 * - 공용배포그룹 멤버 리스트 팝업 화면
	 */
	@RequestMapping(value="/ezEmail/mailDistributionMemberListPop.do")
	public String mailDistributionMemberListPop(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		logger.debug("mailDistributionMemberListPop started.");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		int tenantId = userInfo.getTenantId();
		String tenantDomain = ezCommonService.getTenantConfig("DomainName", tenantId);
		
		String cn = request.getParameter("cn") == null ? "" : request.getParameter("cn");
		
		MailDistributionVO dlVo = ezEmailService.getUserDistributionInfo(cn, tenantId);
		String dlCn = dlVo.getId();
		String dlName = dlVo.getName();
		String dlComp = dlVo.getCompanyId();
		String dlPolicy = dlVo.getDisclosurePolicy();
		String dlOwnerId = dlVo.getOwnerId();
		boolean ownerChk = dlOwnerId.equals(userInfo.getId()) ? true : false;
		logger.debug("dlCn=" + dlCn + ", dlName=" + dlName + ", dlComp=" + dlComp + ", dlPolicy=" + dlPolicy + ", dlOwnerId=" + dlOwnerId + ", ownerChk=" + ownerChk);
		
		int inCludedChk = ezEmailService.checkUserDistributionInCludedMember(tenantDomain, dlCn, userInfo.getId()); // 0:소속dl, -1:소속dl 아님
		if ((dlPolicy.equals("member") && inCludedChk == 0) || (dlPolicy.equals("private") && ownerChk)) {
			dlPolicy = "all";
		}
		
		int appliedChk = ezEmailService.checkUserDistributionApply(dlCn, tenantDomain, userInfo.getId()); // 0:가입신청, -1:가입신청 안함
		logger.debug("inCludedChk=" + inCludedChk + ", dlPolicy=" + dlPolicy + ", appliedChk=" + appliedChk);
		 
		Map<String, Object> memListInfo = createUserDistributionMemberListXML(dlCn, tenantDomain, dlComp, tenantId, userInfo.getPrimary(), dlPolicy, locale);
		
		model.addAttribute("cn", dlCn);
		model.addAttribute("dlName", dlName);
		model.addAttribute("dlCompanyId", dlComp);
		model.addAttribute("dlPolicy", dlPolicy);
		model.addAttribute("inCludedChk", inCludedChk);
		model.addAttribute("appliedChk", appliedChk);
		model.addAttribute("ownerChk", ownerChk);
		model.addAttribute("userId", userInfo.getId());
		model.addAttribute("memberListXML", memListInfo.get("returnData"));
		model.addAttribute("memberListCnt", memListInfo.get("returnMemCnt"));
		logger.debug("mailDistributionMemberListPop ended.");
		return "ezEmail/mailDistributionMemberListPopUp";
	}
	
	/**
	 * 사용자 정의 공용배포그룹 
	 * - 소유 공용배포그룹 리스트 출력
	 */
	@RequestMapping(value = "/ezEmail/mailGetUserDistribution.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String mailGetUserDistribution(
			@CookieValue("loginCookie") String loginCookie, Locale locale,
			Model model, HttpServletRequest request) throws Exception {
		logger.debug("mailGetUserDistribution started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		int tenantId = userInfo.getTenantId();
		String lang = userInfo.getPrimary();
		
		String returnData = "";
		
		String userId = request.getParameter("userId") == null ? userInfo.getId() : request.getParameter("userId");
		String companyId = request.getParameter("companyId") == null ? userInfo.getCompanyID() : request.getParameter("companyId"); 
		String userDLListType = request.getParameter("type") == null ? "owner" : request.getParameter("type");  // owner or include
		String showDLListType = request.getParameter("listType") == null ? "setting" : request.getParameter("listType");  // 메일환경설정, 수신자설정
		logger.debug("userId=" + userId + ", companyId=" + companyId + ", userDlListType=" + userDLListType);
		
		try {
			List<MailDistributionVO> dlList = new ArrayList<MailDistributionVO>();
			if (userDLListType.equals("owner")) {
				dlList = ezEmailService.getUserOwnerDistributionList(companyId, userInfo.getTenantId(), userId);
			} else {
				dlList = ezEmailService.getUserIncludedDistributionList(companyId, userInfo.getTenantId(), userId);
			}

			StringBuilder sb = new StringBuilder();
			sb.append("<LISTVIEWDATA><ROWS>");
			if (dlList != null && dlList.size() > 0) {
				for (MailDistributionVO dlVo : dlList) {
					OrganUserVO ownerInfo = ezOrganService.getUserInfo(dlVo.getOwnerId(), lang, tenantId);
					String ownerChk = dlVo.getOwnerId().equals(userId) ? "ownerChk_Y" : "ownerChk_N";
					String policy = dlVo.getDisclosurePolicy();
					String policyStr = policy.equals("all") ? "ezEmail.userDL21" : policy.equals("member") ? "ezEmail.userDL22" : "ezEmail.userDL23";
					policyStr = egovMessageSource.getMessage(policyStr, locale);
					
					String dlId = commonUtil.cleanValue(dlVo.getId());
					String dlName = commonUtil.cleanValue(dlVo.getName());
					String dlExplaination = commonUtil.cleanValue(dlVo.getExplaination());
					String dlMail = commonUtil.cleanValue(dlVo.getMail());
					String dlOwnerName = (ownerInfo != null) ? commonUtil.cleanValue(ownerInfo.getDisplayName()) : "";
					
					// commonUtil.cleanValue()
					if (showDLListType.equals("setting")) { // 메일 환경설정
						sb.append("<ROW>");
						sb.append("<CELL>");
							sb.append("<VALUE>" + dlId + "</VALUE>");
							sb.append("<DATA1>" + dlId + "</DATA1>");
							sb.append("<DATA2>" + dlName + "</DATA2>");
							sb.append("<DATA3>" + policy + "</DATA3>");
							sb.append("<DATA4>" + dlExplaination + "</DATA4>");
							sb.append("<DATA5>" + dlVo.getEndDate() + "</DATA5>");
							sb.append("<DATA6>" + ownerChk + "</DATA6>");
						sb.append("</CELL>");
						sb.append("<CELL><VALUE>" + dlName + "</VALUE></CELL>");
						if (!userDLListType.equals("owner")) { // 소속 dl일 경우 소유자 표시
							sb.append("<CELL><VALUE>" + dlOwnerName + "</VALUE></CELL>");
						}
						sb.append("<CELL><VALUE>" + policyStr + "</VALUE></CELL>");
						sb.append("<CELL><VALUE>" + dlExplaination + "</VALUE></CELL>");
						sb.append("<CELL><VALUE>" + dlVo.getEndDate() + "</VALUE></CELL>");
						sb.append("</ROW>");
					} else { // 수신자 설정 공용배포그룹
						sb.append("<ROW>");
						sb.append("<CELL>");
							sb.append("<VALUE>" + dlName + "</VALUE>");
							sb.append("<DATA1>" + dlId + "</DATA1>");
							sb.append("<DATA2>" + dlMail + "</DATA2>");
							sb.append("<DATA3>" + dlVo.getDisclosurePolicy() + "</DATA3>");
							sb.append("<DATA4>" + dlExplaination + "</DATA4>");
							sb.append("<DATA5>" + dlVo.getEndDate() + "</DATA5>");
							sb.append("<DATA6>" + ownerChk + "</DATA6>");
						sb.append("</CELL>");
						sb.append("</ROW>");
					}
				}
			} 
			sb.append("</ROWS></LISTVIEWDATA>");
			returnData = sb.toString();
			
		} catch (RuntimeException e) {
			returnData = "ERROR";
			logger.error(e.getMessage(), e);
		} catch (Exception e) {
			returnData = "ERROR";
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("mailGetUserDistribution ended.");
		return returnData;
	}
	
	/**
	 * 사용자 정의 공용배포그룹 
	 * - 소유자 변경 조직도 화면
	 */
	@RequestMapping(value="/ezEmail/mailUserDistributionSelectOwner.do")
	public String mailUserDistributionSelectOwner(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		logger.debug("mailUserDistributionSelectOwner started.");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String cChk = "0";
		if (userInfo.getRollInfo().indexOf("c=1") != -1) { // 전체 관리자
			cChk = "1";
		}

		model.addAttribute("userId", userInfo.getId());
		model.addAttribute("companyId", userInfo.getCompanyID());
		model.addAttribute("deptId", userInfo.getDeptID());
		model.addAttribute("cChk", cChk);
		logger.debug("mailUserDistributionSelectOwner ended.");
		
		return "ezEmail/mailUserDistributionSelectOwner";
	}
	
	
	/**
	 * 사용자 정의 공용배포그룹 
	 * - 가입신청 리스트
	 */
	@RequestMapping(value = "/ezEmail/mailUserDistributionApplyList.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String mailUserDistributionApplyList(
			@CookieValue("loginCookie") String loginCookie, Locale locale,
			Model model, @RequestBody String bodyData) throws Exception {
		logger.debug("mailUserDistributionApplyList started.");
		logger.debug("bodyData=" + bodyData);

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		int tenantId = userInfo.getTenantId();
		String lang = userInfo.getPrimary();
		String returnData = "";

		try {
			Document doc = commonUtil.convertStringToDocument(bodyData != null ? bodyData : "");
			String cn = doc.getElementsByTagName("CN").item(0).getTextContent() == null ? "" 
					: doc.getElementsByTagName("CN").item(0).getTextContent();
			logger.debug("cn=" + cn);

			JSONArray userDlApplyJSONArr = ezEmailService.getUserDistributionApplyList(cn, tenantId);
			
			if (userDlApplyJSONArr != null && userDlApplyJSONArr.size() > 0) {
				StringBuilder sb = new StringBuilder();
				sb.append("<LISTVIEWDATA><ROWS>");
				
				for (int i = 0; i < userDlApplyJSONArr.size(); i++) {
					JSONObject userObject = (JSONObject) userDlApplyJSONArr.get(i);
					
					String objId = (String) userObject.get("applicantId");
					String applicantDate = (String) userObject.get("applicantDate");
					logger.debug("objId=" + objId + ", applicantDate=" + applicantDate);
					
					OrganUserVO userVo = ezOrganService.getUserInfo(objId, lang, tenantId);
					String objName = commonUtil.cleanValue(userVo.getDisplayName());
					String objMail = commonUtil.cleanValue(userVo.getMail());
					
					OrganDeptVO deptVo = ezOrganService.getDeptInfo(userVo.getDepartment(), lang, tenantId);
					String objDept = commonUtil.cleanValue(deptVo.getDisplayName());
					logger.debug("objName=" + objName + ", objMail=" + objMail + ", objDept=" + objDept);
					
					sb.append("<ROW>");
					sb.append("<CELL>");
						sb.append("<VALUE>" + objName + "</VALUE>");
						sb.append("<DATA1>" + objId + "</DATA1>");
						sb.append("<DATA2>" + objName + "</DATA2>");
						sb.append("<DATA3>" + objMail + "</DATA3>");
						sb.append("<DATA4>" + objDept + "</DATA4>");
						sb.append("<DATA5>" + applicantDate + "</DATA5>");
					sb.append("</CELL>");
					sb.append("<CELL><VALUE>" + objMail + "</VALUE></CELL>");
					sb.append("<CELL><VALUE>" + objDept + "</VALUE></CELL>");
					sb.append("<CELL><VALUE>" + applicantDate + "</VALUE></CELL>");
					sb.append("</ROW>");
				}
				
				sb.append("</ROWS></LISTVIEWDATA>");
				returnData = sb.toString();
			}
			
		} catch (DOMException e) {
			returnData = "ERROR";
			logger.error(e.getMessage(), e);
		} catch (Exception e) {
			returnData = "ERROR";
			logger.error(e.getMessage(), e);
		}

		logger.debug("returnData=" + returnData);
		logger.debug("mailUserDistributionApplyList ended.");

		return returnData;
	}
	
	/**
	 * 사용자 정의 공용배포그룹 
	 * - 가입신청 반려
	 */
	@RequestMapping(value = "/ezEmail/refuseToApplyDL.do", method = RequestMethod.POST)
	@ResponseBody
	public String refuseToApplyDL(
			@CookieValue("loginCookie") String loginCookie, Locale locale,
			Model model, HttpServletRequest request) throws Exception {
		logger.debug("refuseToApplyDL started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String returnStr = "OK";
		int reasonCode = 0;
		
		String userId = request.getParameter("userId") == null ? userInfo.getId() : request.getParameter("userId");
		String cn = request.getParameter("cn") == null ? "" : request.getParameter("cn");
		
		try {
			reasonCode = ezEmailService.setUserDistributionApply(cn, userInfo.getTenantId(), userId, "del");
			logger.debug("reasonCode=" + reasonCode);
			
			if (reasonCode != 0) {
				returnStr = "ERROR";
			} else {
				List<String> toArr = new ArrayList<String>();
				toArr.add(userId);
				
				ezEmailService.sendUserDLMail(loginCookie, cn, "refuse", toArr);
			}
		} catch (RuntimeException e) {
			logger.error(e.getMessage(), e);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("refuseToApplyDL ended.");
		return returnStr;
	}
	
	/**
	 * 사용자 공용배포그룹 - 소속 공용배포그룹 탈퇴
	 */
	@RequestMapping(value = "/ezEmail/secessionDistribution.do", method = RequestMethod.POST)
	@ResponseBody
	public String secessionDistribution(
			@CookieValue("loginCookie") String loginCookie, Locale locale,
			Model model, HttpServletRequest request) throws Exception {
		logger.debug("secessionDistribution started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String returnStr = "OK";
		int reasonCode = 0;
		
		String userId = request.getParameter("userId") == null ? userInfo.getId() : request.getParameter("userId");
		String cn = request.getParameter("cn") == null ? "" : request.getParameter("cn");
		
		try {
			reasonCode = ezEmailService.secessionDistribution(userInfo.getTenantId(), cn, userId);
			logger.debug("reasonCode=" + reasonCode);
			
			if (reasonCode == -1) {
				returnStr = "EMPTY";
			} else if (reasonCode == -2) {
				returnStr = "NOT INCLUDE";
			}
		} catch (RuntimeException e) {
			logger.error(e.getMessage(), e);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("secessionDistribution ended.");
		return returnStr;
	}
	
	private Map<String, Object> createUserDistributionMemberListXML(String cn, String domain, String companyId, int tenantId, String primaryLang, String policy, Locale locale) throws Exception {
		logger.debug("cn=" + cn + ", domain=" + domain + ", companyId=" + companyId + ", tenantId=" + tenantId
				+ ", primaryLang=" + primaryLang + ", policy=" + policy);
		
		Map<String, Object> returnMap = new HashMap<String, Object>();
		int returnMemCnt = 0;
		String returnData = "";

		StringBuilder sb = new StringBuilder();
		sb.append("<LISTVIEWDATA><ROWS>");
		
		// all, member, private
		if (!policy.equals("all")) {
			String msg = policy.equals("private") ? "ezEmail.userDL31" : "ezEmail.userDL32";
			
			sb.append("<ROW>");
			sb.append("<CELL>");
				sb.append("<VALUE>" + egovMessageSource.getMessage(msg, locale) + "</VALUE>");
			sb.append("</CELL>");
			sb.append("</ROW>");
		} else { // all
			JSONArray resultArray = ezEmailService.getUserDistributionMemberList(domain, cn);
			if (resultArray != null){
				returnMemCnt = resultArray.size();

				for (int i = 0; i < returnMemCnt; i++) {
					JSONObject address = (JSONObject) resultArray.get(i);
					String pCn = (String) address.get("cn");
					String pCnDomain = pCn.substring(pCn.indexOf("@") + 1, pCn.length());
					String pClass = (String) address.get("class");
					String displayName = (String) address.get("displayName");
					String regDate = (String) address.get("regDate");

					if (domain.equals(pCnDomain)) {
						pCn = pCn.substring(0, pCn.indexOf("@"));
					} else {
						pClass = "distributionSub";
					}
					logger.debug("pCn=" + pCn + ", pClass=" + pClass + ", displayName=" + displayName + ", regDate=" + regDate);

					String dlName = displayName;
					String dlCn = pCn;
					String dlMail = pCn;
					String dlPClass = pClass;
					String dlDeptName = "";

					if (pClass.equals("group")) {
						OrganDeptVO dept = ezOrganService.getDeptInfo(pCn, primaryLang, tenantId);

						if (dept != null) { // 부서
							dlCn = dept.getCn();
							dlMail = dept.getMail();
							dlMail = dlMail.equals("") ? dlCn + "@" + pCnDomain : dlMail ;
							dlDeptName = "";
						} else { // 공용배포그룹
							MailDistributionVO dlVo = ezEmailService.getDistributionInfo(dlCn, tenantId);
							dlMail = dlVo.getMail();
							dlPClass = "distribution";
						}
					} else if (pClass.equals("user")) {
						OrganUserVO user = ezOrganService.getUserInfo(pCn, primaryLang, tenantId);

						if (user != null) {
							OrganDeptVO dept = ezOrganService.getDeptInfo(user.getDepartment(), primaryLang, tenantId);

							dlName = user.getDisplayName();
							dlMail = user.getMail();
							dlDeptName = dept.getDisplayName();
						}
					} else {//distribution_sub에서 가져오기(주소록, 직접입력)
						MailDistributionVO distributionSubVO = ezEmailService.getDistributionSub(cn, pCn, companyId, tenantId);

						if (distributionSubVO != null) {
							dlName = distributionSubVO.getName();
							dlMail = distributionSubVO.getMail();
						}
					}

					sb.append("<ROW>");
					sb.append("<CELL>");
					sb.append("<VALUE>" + commonUtil.cleanValue(dlName) + "</VALUE>");
					sb.append("<DATA1>" + commonUtil.cleanValue(dlCn) + "</DATA1>");
					sb.append("<DATA2>" + commonUtil.cleanValue(dlMail) + "</DATA2>");
					sb.append("<DATA3>" + commonUtil.cleanValue(dlPClass) + "</DATA3>");
					sb.append("</CELL>");
					sb.append("<CELL><VALUE>" + commonUtil.cleanValue(dlMail) + "</VALUE></CELL>");
					sb.append("<CELL><VALUE>" + commonUtil.cleanValue(dlDeptName) + "</VALUE></CELL>");
					sb.append("<CELL><VALUE>" + commonUtil.cleanValue(regDate) + "</VALUE></CELL>");
					sb.append("</ROW>");
				}
			}
		}

		sb.append("</ROWS></LISTVIEWDATA>");
		returnData = sb.toString();

		returnMap.put("returnData", returnData);
		returnMap.put("returnMemCnt", returnMemCnt);
		
		logger.debug("returnData=" + returnData);
		return returnMap;
	}
	
	/**
	 * 사용자 정의 공용배포그룹 
	 * - 검색
	 */
	@RequestMapping(value = "/ezEmail/searchUserDistribution.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String searchUserDistribution(
			@CookieValue("loginCookie") String loginCookie, Locale locale,
			Model model, HttpServletRequest request) throws Exception {
		logger.debug("searchUserDistribution started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		int tenantId = userInfo.getTenantId();
		String lang = userInfo.getPrimary();
		
		String returnData = "";
		
		String userId = request.getParameter("userId") == null ? userInfo.getId() : request.getParameter("userId");
		String searchValue = request.getParameter("searchValue");
		String searchRange = request.getParameter("searchRange") == null ? "" : request.getParameter("searchRange"); // 소유(owner), 소속(include), 전체(search)
		String showDLListType = request.getParameter("listType") == null ? "setting" : request.getParameter("listType");  // 메일환경설정(setting), 수신자설정(mailUser)
		logger.debug("userId=" + userId + ", searchValue=" + searchValue + ", searchRange=" + searchRange + ", showDLListType=" + showDLListType);
		
		String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());	
		
		try {
			List<MailDistributionVO> dlList = ezEmailService.userDistributionListSearch(domainName, searchRange, searchValue, userId);

			StringBuilder sb = new StringBuilder();
			sb.append("<LISTVIEWDATA><ROWS>");
			if (dlList != null && dlList.size() > 0) {
				for (MailDistributionVO dlVo : dlList) {
					OrganUserVO ownerInfo = ezOrganService.getUserInfo(dlVo.getOwnerId(), lang, tenantId);
					String ownerChk = dlVo.getOwnerId().equals(userId) ? "ownerChk_Y" : "ownerChk_N";
					String policy = dlVo.getDisclosurePolicy();
					String policyStr = policy.equals("all") ? "ezEmail.userDL21" : policy.equals("member") ? "ezEmail.userDL22" : "ezEmail.userDL23";
					policyStr = egovMessageSource.getMessage(policyStr, locale);
					
					String dlId = commonUtil.cleanValue(dlVo.getId());
					String dlName = commonUtil.cleanValue(dlVo.getName());
					String dlExplaination = commonUtil.cleanValue(dlVo.getExplaination());
					String dlMail = commonUtil.cleanValue(dlVo.getMail());
					String dlOwnerName = (ownerInfo == null || ownerInfo.getDisplayName() == null) ? "" : commonUtil.cleanValue(ownerInfo.getDisplayName());
					
					// commonUtil.cleanValue()
					if (showDLListType.equals("setting")) { // 메일 환경설정
						sb.append("<ROW>");
						sb.append("<CELL>");
							sb.append("<VALUE>" + dlId + "</VALUE>");
							sb.append("<DATA1>" + dlId + "</DATA1>");
							sb.append("<DATA2>" + dlName + "</DATA2>");
							sb.append("<DATA3>" + policy + "</DATA3>");
							sb.append("<DATA4>" + dlExplaination + "</DATA4>");
							sb.append("<DATA5>" + dlVo.getEndDate() + "</DATA5>");
							sb.append("<DATA6>" + ownerChk + "</DATA6>");
						sb.append("</CELL>");
						sb.append("<CELL><VALUE>" + dlName + "</VALUE></CELL>");
						sb.append("<CELL><VALUE>" + dlOwnerName + "</VALUE></CELL>");
						sb.append("<CELL><VALUE>" + policyStr + "</VALUE></CELL>");
						sb.append("<CELL><VALUE>" + dlExplaination + "</VALUE></CELL>");
						sb.append("<CELL><VALUE>" + dlVo.getEndDate() + "</VALUE></CELL>");
						sb.append("</ROW>");
					} else { // 수신자 설정 공용배포그룹
						sb.append("<ROW>");
						sb.append("<CELL>");
							sb.append("<VALUE>" + dlName + "</VALUE>");
							sb.append("<DATA1>" + dlId + "</DATA1>");
							sb.append("<DATA2>" + dlMail + "</DATA2>");
							sb.append("<DATA3>" + dlVo.getDisclosurePolicy() + "</DATA3>");
							sb.append("<DATA4>" + dlExplaination + "</DATA4>");
							sb.append("<DATA5>" + dlVo.getEndDate() + "</DATA5>");
							sb.append("<DATA6>" + ownerChk + "</DATA6>");
						sb.append("</CELL>");
						sb.append("</ROW>");
					}
				}
			} 
			sb.append("</ROWS></LISTVIEWDATA>");
			returnData = sb.toString();
			
		} catch (RuntimeException e) {
			returnData = "ERROR";
			logger.error(e.getMessage(), e);
		} catch (Exception e) {
			returnData = "ERROR";
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("searchUserDistribution ended.");
		return returnData;
	}
	
	/**
	 * 사용자 정의 공용배포그룹 
	 * - 가입신청 
	 */
	@RequestMapping(value = "/ezEmail/mailUserDistributionApply.do", method = RequestMethod.POST)
	@ResponseBody
	public String mailUserDistributionApply(@CookieValue("loginCookie") String loginCookie, Locale locale,
			Model model, HttpServletRequest request) throws Exception {
		logger.debug("mailUserDistributionApply started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String returnStr = "OK";
		int reasonCode = 0;
		
		String userId = request.getParameter("userId") == null ? userInfo.getId() : request.getParameter("userId");
		String cn = request.getParameter("cn") == null ? "" : request.getParameter("cn");
		String type = request.getParameter("type") == null ? "add" : request.getParameter("type");
		
		try {
			reasonCode = ezEmailService.setUserDistributionApply(cn, userInfo.getTenantId(), userId, type);
			logger.debug("reasonCode=" + reasonCode);
			
			if (reasonCode != 0) {
				returnStr = "ERROR";
			} else {
				returnStr = type.equals("add") ? "ADD" : "DELETE";
			}
		} catch (RuntimeException e) {
			logger.error(e.getMessage(), e);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("mailUserDistributionApply ended. returnStr=" + returnStr);
		return returnStr;
	}
	/**
	 * 환경설정 > 편지함 관리
	 */
	@RequestMapping(value="/ezEmail/folderQuotaAndManage.do")
	public String folderQuotaAndManage(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		logger.debug("folderQuotaAndManage started.");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String shareId = request.getParameter("shareId") == null ? "" : request.getParameter("shareId");
		
		String pDeleteBoxID = ezEmailUtil.getTrashFolderId(locale);
		String pDeleteBoxName = ezEmailUtil.getTrashFolderId(locale);
		String useEncryptZipForEmail = ezCommonService.getTenantConfig("UseEncryptZipForEmail", userInfo.getTenantId());
		if (useEncryptZipForEmail.equals("")) {
			useEncryptZipForEmail = "NO";
		}
		
		model.addAttribute("shareId", shareId);
		model.addAttribute("userId", userInfo.getId());
		model.addAttribute("useEncryptZipForEmail", useEncryptZipForEmail);
		model.addAttribute("pDeleteBoxID", pDeleteBoxID);
		model.addAttribute("pDeleteBoxName", pDeleteBoxName);
		
		logger.debug("folderQuotaAndManage ended.");
		
		return "ezEmail/mailFolderQuotaAndManage";
	}
	
	/**
	 * 환경설정 > 편지함 관리 -- 리스트 출력
	 */
	@RequestMapping(value="/ezEmail/folderQuotaList.do",
			method=RequestMethod.GET,
			produces="text/xml; charset=utf-8" )
	@ResponseBody	
	public String folderQuotaList(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		logger.debug("folderQuotaList started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String domain = ezCommonService.getTenantConfig("domainName", userInfo.getTenantId());
		String shareId = request.getParameter("shareId") == null ? "" : request.getParameter("shareId");
		String email = userInfo.getId() + "@" + domain;
		logger.debug("userId:'" + userInfo.getId() + "',shareId:'" + shareId + "'");
		
		if(shareId == null || !shareId.equals("")) {
			email = shareId + "@" + domain;
		}
		logger.debug("email:" + email);
		
		JSONArray returnJsonArr = new JSONArray();
		returnJsonArr = ezEmailService.getFolderQuota(email, locale);
		
		logger.debug("jsonArr" , returnJsonArr);
		logger.debug("folderQuotaList ended.");
		return returnJsonArr.toString();
	}
	
	/**
	 * 환경설정 >  편지함 관리 > 내보내기 - 기간설정
	 */
	@RequestMapping(value="/ezEmail/folderExportPeriod.do", method = RequestMethod.GET)
	public String folderExportPeriod(
			@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Locale locale, Model model) throws Exception {
		logger.debug("folderExportPeriod started.");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String offsetMin = commonUtil.getMinuteUTC(userInfo.getOffset());

		String folderName = request.getParameter("folderName");
		String folderNameSql = request.getParameter("folderNameSql");
		String folderMailCnt = request.getParameter("folderMailCnt");

		model.addAttribute("userInfo", userInfo);
		model.addAttribute("offsetMin", offsetMin);
		model.addAttribute("folderName", folderName);
		model.addAttribute("folderNameSql", folderNameSql);
		model.addAttribute("folderMailCnt", folderMailCnt);

		logger.debug("folderExportPeriod ended.");
		return "ezEmail/mailFolderExportPeriod";
	}

	/**
	 * 메일 부재중 설정 
	 * - 부재중 설정, 부재중 설정 템플릿 메뉴 포함된 메인 화면
	 */
	@RequestMapping(value="/ezEmail/mailOutOfOfficeMain.do", method = RequestMethod.GET)
	public String mailOutOfOfficeMain(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		logger.debug("mailOutOfOfficeMain start-ended");
		return "ezEmail/mailOutOfOfficeMain";
	}
	
	/**
	 * 메일 부재중 설정 
	 * - 부재중 설정 템플릿 메뉴 화면
	 */
	@RequestMapping(value="/ezEmail/mailOutOfOfficeTemplate.do", method = RequestMethod.GET)
	public String mailOutOfOfficeTemplate(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		logger.debug("mailOutOfOfficeTemplate started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		int tenantId = userInfo.getTenantId();
		
		String domain = ezCommonService.getTenantConfig("domainName", tenantId);
		
		String userEmail = userInfo.getId() + "@" + domain;
		logger.debug("userEmail=" + userEmail);
		
		JSONArray jsonArr = ezEmailService.getMailOutOfOfficeTemplateList(userEmail);
		logger.debug("jsonArr = " + jsonArr);
		
		model.addAttribute("templateList", jsonArr);
		
		logger.debug("mailOutOfOfficeTemplate ended.");		
		return "ezEmail/mailOutOfOfficeTemplate";
	}
	
	/**
	 * 메일 부재중 설정 템플릿 가져오기(리스트)
	 */
	@RequestMapping(value="/ezEmail/getMailOutOfOfficeTemplateList.do", method=RequestMethod.POST)
	@ResponseBody
	public JSONArray getMailOutOfOfficeTemplateList(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		logger.debug("getMailOutOfOfficeTemplateList started.");
	
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		int tenantId = userInfo.getTenantId();

		String domain = ezCommonService.getTenantConfig("domainName", tenantId);
		String userEmail = userInfo.getId() + "@" + domain;
		logger.debug("tenantId=" + tenantId + ", domain=" + domain + ", userEmai=" + userEmail);
		
		JSONArray jsonArr = ezEmailService.getMailOutOfOfficeTemplateList(userEmail); 
		logger.debug("jsonArr = " + jsonArr);
		
		logger.debug("getMailOutOfOfficeTemplateList ended.");		
		return jsonArr;
	}
	
	/**
	 * 메일 부재중 설정 템플릿 가져오기(개별)
	 */
	@RequestMapping(value="/ezEmail/getMailOutOfOfficeTemplate.do", method=RequestMethod.POST)
	@ResponseBody
	public JSONObject getMailOutOfOfficeTemplate(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		logger.debug("getMailOutOfOfficeTemplate started.");
	
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		int tenantId = userInfo.getTenantId();
		
		String domain = ezCommonService.getTenantConfig("domainName", tenantId);
		
		String userEmail = userInfo.getId() + "@" + domain;
		String displayName = request.getParameter("displayName");
		logger.debug("userEmail=" + userEmail + ", displayName=" + displayName);
		
		JSONObject oootemplate = ezEmailService.getMailOutOfOfficeTemplate(userEmail, displayName);
		
		logger.debug("getMailOutOfOfficeTemplate started.");
		return oootemplate;
	}
	
	/**
	 * 메일 부재중 설정 템플릿 저장 함수
	 */
	@RequestMapping(value="/ezEmail/saveMailOutOfOfficeTemplate.do", method=RequestMethod.POST)
	@ResponseBody
	public String saveMailOutOfOfficeTemplate(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		logger.debug("saveMailOutOfOfficeTemplate started.");

		String returnValue = "ERROR";
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		int tenantId = userInfo.getTenantId();

		String domain = ezCommonService.getTenantConfig("domainName", tenantId);
		String userEmail = userInfo.getId() + "@" + domain;
		logger.debug("tenantId=" + tenantId + ", domain=" + domain + ", userEmai=" + userEmail);

		String modDiplayName = request.getParameter("modDisplayName");
		String displayName = request.getParameter("displayName");
		String content = request.getParameter("content");
		String type = request.getParameter("type");
		type = type == null ? "add" : "mod";
		modDiplayName = type.equals("add") ? "" : modDiplayName;
		logger.debug("modDiplayName=" + modDiplayName + ", displayName=" + displayName + ", type=" + type);
		
		if (displayName == null || content == null) {
			returnValue = "DATA_ERROR";
		} else {
			int reseanCode = ezEmailService.saveMailOutOfOfficeTemplate(userEmail, modDiplayName, displayName, content, type);
			returnValue = reseanCode == -2 ? "DUPLICATE_NAME" : reseanCode != 0 ? "ERROR" : "OK";
		}

		logger.debug("returnValue=" + returnValue);
		logger.debug("saveMailOutOfOfficeTemplate ended.");
		
		return returnValue;

	}
	
	/**
	 * 메일 부재중 설정 템플릿 삭제 함수
	 */
	@RequestMapping(value="/ezEmail/deleteMailOutOfOfficeTemplate.do", method=RequestMethod.POST)
	@ResponseBody
	public String deleteMailOutOfOfficeTemplate(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		logger.debug("deleteMailOutOfOfficeTemplate started.");

		String returnValue = "ERROR";
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		int tenantId = userInfo.getTenantId();
		
		String domain = ezCommonService.getTenantConfig("domainName", tenantId);
		
		String userEmail = userInfo.getId() + "@" + domain;
		String displayName = request.getParameter("displayName");
		logger.debug("userEmail=" + userEmail + ", displayName=" + displayName);
		
		if (displayName == null || displayName.trim().equals("") || displayName.equals("none")) {
			logger.debug("Template DisplayName error.");
		}
		
		int reseanCode = ezEmailService.deleteMailOutOfOfficeTemplate(userEmail, displayName);
		returnValue = reseanCode != 0 ? "ERROR" : "OK";
		
		logger.debug("deleteMailOutOfOfficeTemplate started.");
		return returnValue;
	}

	@GetMapping("/ezEmail/mailTagConfig.do")
	public String mailTagConfig(@CookieValue String loginCookie, Model model, @RequestParam(required = false) String shareId) throws Exception {
		logger.debug("getMailTag started. shareId: {}", shareId);

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String domain = ezCommonService.getTenantConfig("domainName", userInfo.getTenantId());
		String userEmail = userInfo.getId() + "@" + domain;

		if (StringUtils.isNotBlank(shareId)) {
			userEmail = shareId + "@" + domain;
			model.addAttribute("shareId", shareId);
		}

		// 콘피그 가져오기
		JgwResult jgwResult = rest.jgw().url("/jMochaEzEmail/getTagConfig")
				.formParam("userAccount", userEmail)
				.exchangeJgwResult();
		logger.debug("jgw getTagConfig ended, success={}", jgwResult.succeeded());

		if (jgwResult.succeeded()) {
			model.addAttribute("config", jgwResult.getResult());
		}

		// 태그 목록 가져오기
		jgwResult = rest.jgw().url("/jMochaEzEmail/getUserTagList")
				.formParam("userAccount", userEmail)
				.exchangeJgwResult();
		logger.debug("jgw getUserTagList ended, success={}", jgwResult.succeeded());

		if (jgwResult.succeeded()) {
			model.addAttribute("tags", jgwResult.getResult());
		}

		logger.debug("getMailTag ended.");
		return "ezEmail/mailTagConfig";
	}

	@PostMapping("/ezEmail/setTagConfig.do")
	@ResponseBody
	public Result setTagConfig(@CookieValue String loginCookie, @RequestParam boolean enable, @RequestParam String orderBy, @RequestParam(required = false) String shareId) throws Exception {
		logger.debug("setTagConfig started. enable: {}, orderBy: {}, shareId: {}", enable, orderBy, shareId);
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String domain = ezCommonService.getTenantConfig("domainName", userInfo.getTenantId());
		String userEmail = userInfo.getId() + "@" + domain;

		if (StringUtils.isNotBlank(shareId)) {
			userEmail = shareId + "@" + domain;
		}

		JgwResult jgwResult = rest.jgw().url("/jMochaEzEmail/setTagConfig")
				.formParam("userAccount", userEmail)
				.formParam("enable", enable)
				.formParam("orderBy", orderBy)
				.exchangeJgwResult();
		logger.debug("jgw setTagConfig ended, success={}", jgwResult.succeeded());
		logger.debug("setTagConfig ended.");
		return jgwResult.succeeded() ? Result.success() : Result.failure();
	}

	@PostMapping("/ezEmail/setTagName.do")
	@ResponseBody
	public Result setTagName(@CookieValue String loginCookie, @RequestParam int tagIdx, @RequestParam String name, @RequestParam(required = false) String shareId) throws Exception {
		logger.debug("setTagName started. tagIdx: {}, name: {}, shareId: {}", tagIdx, name, shareId);
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String domain = ezCommonService.getTenantConfig("domainName", userInfo.getTenantId());
		String userEmail = userInfo.getId() + "@" + domain;

		if (StringUtils.isNotBlank(shareId)) {
			userEmail = shareId + "@" + domain;
		}

		JgwResult jgwResult = rest.jgw().url("/jMochaEzEmail/setTagName")
				.formParam("userAccount", userEmail)
				.formParam("tagIdx", tagIdx)
				.formParam("name", name)
				.exchangeJgwResult();
		logger.debug("jgw setTagName ended, success={}", jgwResult.succeeded());
		logger.debug("setTagName ended.", tagIdx, name);
		return jgwResult.succeeded() ? Result.successWithCode(jgwResult.getReasonCode()) : Result.failure();
	}

	@PostMapping("/ezEmail/deleteTag.do")
	@ResponseBody
	public Result deleteTag(@CookieValue String loginCookie, @RequestParam int tagIdx, @RequestParam(required = false) String shareId) throws Exception {
		logger.debug("deleteTag started. tagIdx: {}, shareId: {}", tagIdx, shareId);
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String domain = ezCommonService.getTenantConfig("domainName", userInfo.getTenantId());
		String userEmail = userInfo.getId() + "@" + domain;

		if (StringUtils.isNotBlank(shareId)) {
			userEmail = shareId + "@" + domain;
		}

		JgwResult jgwResult = rest.jgw().url("/jMochaEzEmail/deleteTag")
				// deleteTag.do를 직접 호출해서 다른 유저의 태그를 삭제하는 불법 행위를 방지하는 목적으로 로그인 된 계정에 해당되는 태그만 삭제하도록 함
				.formParam("userAccount", userEmail)
				.formParam("tagIdx", tagIdx)
				.exchangeJgwResult();
		logger.debug("jgw deleteTag ended, success={}", jgwResult.succeeded());
		logger.debug("deleteTag ended.");
		return jgwResult.succeeded() ? Result.success() : Result.failure();
	}
	
	@PostMapping("/ezEmail/checkBlockExternalAddress.do")
	@ResponseBody
	public String checkBlockExternalAddress(@CookieValue("loginCookie") String loginCookie, @RequestParam String forwardAddress) throws Exception {
		logger.debug("checkBlockExternalAddress started. forwardAddress = {}", forwardAddress);
	
		String result = "OK";
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		int tenantId = userInfo.getTenantId();
		
		try {
			result = ezEmailService.checkInnerDomain(forwardAddress, tenantId);
		} catch (RuntimeException e) {
			result = "ERROR";
			logger.error(e.getMessage(), e);
		} catch (Exception e) {
			result = "ERROR";
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("checkBlockExternalAddress ended.");
		return result;
	}
}
