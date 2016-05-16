package egovframework.ezEKP.ezEmail.web;

import java.util.List;
import java.util.Locale;
import java.util.Properties;

import javax.annotation.Resource;
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
import org.w3c.dom.Element;
import org.w3c.dom.Node;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezEmail.util.EzEmailUtil;
import egovframework.ezEKP.ezEmail.vo.MailDeleteVO;
import egovframework.ezEKP.ezEmail.vo.MailGeneralVO;
import egovframework.ezEKP.ezEmail.vo.MailSignatureVO;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.rte.fdl.string.EgovStringUtil;

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
	private EzOrganAdminService ezOrganAdminService;

	@Autowired
	private EzOrganService ezOrganService;

	@Autowired
	private EzEmailService ezEmailService;

	@Autowired
	private EzEmailUtil ezEmailUtil;

	/**
	 * 메일 기본 환경설정 화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailConfig.do")
	public String mailConfig(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		String userEditor = "";
		String userIE11Browser = "";
		String noneActiveX = "YES";
		String blockedSenders = "";
		
		if ((request.getHeader("User-Agent").contains("rv:11") || request.getHeader("User-Agent").contains("Trident/7.0"))
				&& config.getProperty("config.IE11EDITOR").equals("CK")) {
			userIE11Browser = "CK";
		}
        
		userEditor = config.getProperty("config.EDITOR");
		blockedSenders = config.getProperty("config.BlockedSenders");
		
		model.addAttribute("userEditor", userEditor);
		model.addAttribute("userIE11Browser", userIE11Browser);
		model.addAttribute("noneActiveX", noneActiveX);
		model.addAttribute("blockedSenders", blockedSenders);
		
		return "ezEmail/mailConfig";
	}
	
	/**
	 * 메일 기본 환경설정 내부 화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailGeneral.do")
	public String mailGeneral(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		String userId = commonUtil.getUserIdAndPassword(loginCookie).get(0);
		MailGeneralVO mailGeneralVO = ezEmailService.getMailGeneral(userId).get(0);
		
		String listCount = "";
		String previewMode = "OFF";
		String previewHListSize = "50";
		String previewHContentSize = "50";
		String previewWListSize = "50";
		String previewWContentSize = "50";
		String refreshInterval = "";
		String keepDeleteLength = "";
		String mailSendObject = "";
		
		if (mailGeneralVO == null) {
			listCount = "30";
			refreshInterval = "300";
			keepDeleteLength = "0";
		} else {
			listCount = EgovStringUtil.isEmpty(mailGeneralVO.getListCount()) ? "30" : mailGeneralVO.getListCount();
			previewMode = EgovStringUtil.isEmpty(mailGeneralVO.getPreviewMode()) ? "OFF" : mailGeneralVO.getPreviewMode();
			previewHListSize = EgovStringUtil.isEmpty(mailGeneralVO.getPreviewHList()) ? "50" : mailGeneralVO.getPreviewHList();
			previewHContentSize = EgovStringUtil.isEmpty(mailGeneralVO.getPreviewHContent()) ? "50" : mailGeneralVO.getPreviewHContent();
			previewWListSize = EgovStringUtil.isEmpty(mailGeneralVO.getPreviewWList()) ? "50" : mailGeneralVO.getPreviewWList();
			previewWContentSize = EgovStringUtil.isEmpty(mailGeneralVO.getPreviewWContent()) ? "50" : mailGeneralVO.getPreviewWContent();
			refreshInterval = EgovStringUtil.isEmpty(mailGeneralVO.getRefreshInterval()) ? "300" : mailGeneralVO.getRefreshInterval();
			keepDeleteLength = EgovStringUtil.isEmpty(mailGeneralVO.getKeepDeleteLength()) ? "0" : mailGeneralVO.getKeepDeleteLength();
			mailSendObject = "";
			
			if (keepDeleteLength.equals("30")) {
				keepDeleteLength = "60";
			}
		}
		
		//TODO: userinfo.DisplayName2 가져오기.
		String pmailSenderNM = EgovStringUtil.isEmpty(mailGeneralVO.getMailSenderNm()) ? "" : mailGeneralVO.getMailSenderNm();
		//_PmailSenderNM = string.IsNullOrEmpty(xmldom.SelectSingleNode("DATA/MAILSENDERNM").InnerText) ? userinfo.DisplayName2 : xmldom.SelectSingleNode("DATA/MAILSENDERNM").InnerText;
		
		String[] senderList = pmailSenderNM.split("\\|!\\-@\\-!\\|");
		for (String pSenderNM : senderList) {
			mailSendObject += "<option value='" + pSenderNM + "'>" + pSenderNM + "</option>";
		}
		
		model.addAttribute("listCount", listCount);
		model.addAttribute("previewMode", previewMode);
		model.addAttribute("previewHListSize", previewHListSize);
		model.addAttribute("previewHContentSize", previewHContentSize);
		model.addAttribute("previewWListSize", previewWListSize);
		model.addAttribute("previewWContentSize", previewWContentSize);
		model.addAttribute("refreshInterval", refreshInterval);
		model.addAttribute("keepDeleteLength", keepDeleteLength);
		model.addAttribute("mailSendObject", mailSendObject);
		
		return "ezEmail/mailGeneral";
	}
	
	/**
	 * 메일 서명관리 화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailSignatureCK.do")
	public String mailSignatureCK(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		String signState = "0";
		String signature1 = "";
		String signature2 = "";
		String signature3 = "";
		String serverName = "";
		
		String userId = commonUtil.getUserIdAndPassword(loginCookie).get(0);
		
		MailSignatureVO mailSignatureVO = ezEmailService.getMailSignature(userId, "A");
		
		if (mailSignatureVO != null) {
            signState = mailSignatureVO.getUseFlag().trim();
            signature1 = EgovStringUtil.isEmpty(mailSignatureVO.getContent1()) ? "<div>&nbsp;</div>" : mailSignatureVO.getContent1();
            signature2 = EgovStringUtil.isEmpty(mailSignatureVO.getContent2()) ? "<div>&nbsp;</div>" : mailSignatureVO.getContent2();
            signature3 = EgovStringUtil.isEmpty(mailSignatureVO.getContent3()) ? "<div>&nbsp;</div>" : mailSignatureVO.getContent3();
        } else {
            signature1 = "<div>&nbsp;</div>";
            signature2 = "<div>&nbsp;</div>";
            signature3 = "<div>&nbsp;</div>";

        }
		
		serverName = config.getProperty("config.ServerName");
		
		logger.debug("signState : " + signState);
		logger.debug("signature1 : " + signature1);
		logger.debug("signature2 : " + signature2);
		logger.debug("signature3 : " + signature3);
		logger.debug("serverName : " + serverName);
		logger.debug("userId : " + userId);
		
		model.addAttribute("signState", signState);
		model.addAttribute("signature1", signature1);
		model.addAttribute("signature2", signature2);
		model.addAttribute("signature3", signature3);
		model.addAttribute("serverName", serverName);
		model.addAttribute("userId", userId);
		
		return "ezEmail/mailSignatureCK";
	}
	
	/**
	 * 메일 서명관리 저장 실행 함수
	 */
	@RequestMapping(value="/ezEmail/mailSignSave.do")
	@ResponseBody
	public String mailSignSave(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		Document xmlDoc = commonUtil.convertRequestToDocument(request);
		Element root = xmlDoc.getDocumentElement();
		Node tempNode = null;
		
		String pUserID = "";
		String pUseFlag = "";
		String pContent1 = "";
		String pContent2 = "";
		String pContent3 = "";
		
		if (root.getElementsByTagName("USERID") != null) {
			tempNode = root.getElementsByTagName("USERID").item(0);
			if (tempNode != null && !tempNode.getTextContent().equals("")) {
				pUserID = tempNode.getTextContent();
			}
		}
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
		
		ezEmailService.setMailSignature(pUserID, pUseFlag, pContent1, pContent2, pContent3);
		
		return "";
	}
	
	/**
	 * 메일 자동삭제 화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailAutoDelete.do")
	public String mailAutoDelete(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		String userId = commonUtil.getUserIdAndPassword(loginCookie).get(0);
		List<MailDeleteVO> list = ezEmailService.getMailDelete(userId);
		
		for (MailDeleteVO vo : list) {
			if (vo.getDeleteUnread().trim().equals("1")) {
				vo.setDeleteUnread("checked");
			}
		}
		
		model.addAttribute("list", list);
		
		return "ezEmail/mailAutoDelete";
	}
	
	/**
	 * 메일 편지함선택 화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailSelectFolder.do")
	public String mailSelectFolder(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		return "ezEmail/mailSelectFolder";
	}
}
