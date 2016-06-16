package egovframework.ezEKP.ezEmail.web;

import java.awt.image.BufferedImage;
import java.io.File;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;
import java.util.UUID;

import javax.annotation.Resource;
import javax.imageio.ImageIO;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

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
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

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
import egovframework.let.utl.fcc.service.EgovDateUtil;
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

		listCount = mailGeneralVO.getListCount();
		previewMode = mailGeneralVO.getPreviewMode();
		previewHListSize = mailGeneralVO.getPreviewHList();
		previewHContentSize = mailGeneralVO.getPreviewHContent();
		previewWListSize = mailGeneralVO.getPreviewWList();
		previewWContentSize = mailGeneralVO.getPreviewWContent();
		refreshInterval = mailGeneralVO.getRefreshInterval();
		keepDeleteLength = mailGeneralVO.getKeepDeleteLength();
		mailSendObject = "";

		if (keepDeleteLength.equals("30")) {
			keepDeleteLength = "60";
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
	 * 메일 환경 설정 저장 함수
	 */
	@RequestMapping(value="/ezEmail/mailGeneralSave.do",method=RequestMethod.POST,
			produces="text/xml; charset=utf-8")
	@ResponseBody
	public String mailGeneralSave(@CookieValue("loginCookie") String loginCookie,
			@RequestParam(value = "MODE", required = false) String mode,
			@RequestBody String bodyData, 
			Locale locale, 
			Model model) throws Exception {
		logger.debug("mailGeneralSave started");		
		logger.debug("bodyData=" + bodyData);

		Document doc = commonUtil.convertStringToDocument(bodyData);
		String userId = doc.getElementsByTagName("USERID").item(0).getTextContent();
		String listCount = doc.getElementsByTagName("LISTCOUNT").item(0).getTextContent();
		String refreshInterval = doc.getElementsByTagName("REFRESHINTERVAL").item(0).getTextContent();
		String keepDeleteLength = doc.getElementsByTagName("KEEPDELETELENGTH").item(0).getTextContent();
		String previewMode = doc.getElementsByTagName("PREVIEWMODE").item(0).getTextContent();
		String previewWList = doc.getElementsByTagName("PREVIEWWLIST").item(0).getTextContent();
		String previewWContent = doc.getElementsByTagName("PREVIEWWCONTENT").item(0).getTextContent();
		String previewHList = doc.getElementsByTagName("PREVIEWHLIST").item(0).getTextContent();
		String previewHContent = doc.getElementsByTagName("PREVIEWHCONTENT").item(0).getTextContent();
		String mailSenderNm = "";

		if (mode != null && mode.equals("ALL")) {
			mailSenderNm = doc.getElementsByTagName("MAILSENDERNM").item(0).getTextContent();
		}

		logger.debug("userId=" + userId + ",listCount=" + listCount + ",refreshInterval=" + refreshInterval 
				+ ",keepDeleteLength=" + keepDeleteLength + ",previewMode=" + previewMode 
				+ ",previewWList=" + previewWList + ",previewWContent=" + previewWContent
				+ ",previewHList=" + previewHList + ",previewHContent=" + previewHContent
				+ ",mailSenderNm=" + mailSenderNm
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

			ezEmailService.setMailGeneral(userId, mailGeneral);
		}
		catch (Exception e) {
			rtnValue = "ERROR:" + e.getMessage();
		}

		logger.debug("rtnValue=" + rtnValue);

		return rtnValue;
	}

	/**
	 * 메일 자동 전달 설정 화면 표시 함수
	 */
	@RequestMapping(value="/ezEmail/mailAutoForward.do")
	public String mailAutoForward(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		String userId = commonUtil.getUserIdAndPassword(loginCookie).get(0);
		String userEmail = userId + "@" + config.getProperty("config.DomainName");

		String forwardAddress = getMailForwardAddress(userEmail);

		model.addAttribute("userId", userId);
		model.addAttribute("userEmail", userEmail);
		model.addAttribute("forwardAddress", forwardAddress);

		return "ezEmail/mailAutoForward";
	}

	/**
	 * 메일 자동 전달 설정 함수
	 */
	@RequestMapping(value="/ezEmail/mailAutoForwardSave.do",method=RequestMethod.POST,
			produces="text/xml; charset=utf-8")
	@ResponseBody	
	public String mailAutoForwardSave(@CookieValue("loginCookie") String loginCookie, @RequestBody String bodyData, Locale locale, Model model) throws Exception {
		logger.debug("mailAutoForwardSave started");		
		logger.debug("bodyData=" + bodyData);

		String userId = commonUtil.getUserIdAndPassword(loginCookie).get(0);
		String userEmail = userId + "@" + config.getProperty("config.DomainName");

		Document doc = commonUtil.convertStringToDocument(bodyData);

		String forwardAddress = doc.getElementsByTagName("ADDRESS").item(0).getTextContent();

		String strResult = "Error";

		if (!forwardAddress.equalsIgnoreCase(userEmail)) {
			try {				
				InternetAddress InternetAddress = new InternetAddress(forwardAddress);
				strResult = setMailForwardAddress(userEmail, InternetAddress.getAddress());
			} catch (AddressException e) {
			}
		}
		else {
			strResult = "MINE";
		}

		String returnData = "<RESULT>" + strResult + "</RESULT>";

		logger.debug("mailAutoForwardSave ended");

		return returnData;		
	}

	/**
	 * 메일 자동 전달 설정 함수
	 */
	@RequestMapping(value="/ezEmail/mailAutoForwardDelete.do",method=RequestMethod.POST,
			produces="text/xml; charset=utf-8")
	@ResponseBody	
	public String mailAutoForwardDelete(@CookieValue("loginCookie") String loginCookie, @RequestBody String bodyData, Locale locale, Model model) throws Exception {
		logger.debug("mailAutoForwardDelete started");		
		logger.debug("bodyData=" + bodyData);

		String userId = commonUtil.getUserIdAndPassword(loginCookie).get(0);
		String userEmail = userId + "@" + config.getProperty("config.DomainName");

		String strResult = deleteMailForwardAddress(userEmail);

		String returnData = "<RESULT>" + strResult + "</RESULT>";

		logger.debug("mailAutoForwardDelete ended");

		return returnData;		
	}	

	/**
	 * JMocha Gateway Server에 메일 자동 전달 설정 요청을 보내는 함수
	 */	
	private String setMailForwardAddress(String userEmail, String forwardAddress) {
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
		} catch (Exception e) {
			e.printStackTrace();
		}

		return result;
	}

	/**
	 * JMocha Gateway Server로부터 메일 자동 전달 설정을 읽는 함수
	 */		
	private String getMailForwardAddress(String userEmail) {
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
		} catch (Exception e) {
			e.printStackTrace();
		}

		return result;
	}

	/**
	 * JMocha Gateway Server에 메일 자동 전달 삭제 요청을 보내는 함수
	 */	
	private String deleteMailForwardAddress(String userEmail) {
		String result = "Error";

		try {
			String userIdParam = "userId=" + URLEncoder.encode(userEmail, "UTF-8");
			String inputParams = userIdParam;

			logger.debug("inputParams=" + inputParams);

			String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaAccess/deleteMailForwardAddress";			
			String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);

			logger.debug("response=" + response);

			if (response != null) {
				JSONParser jsonParser = new JSONParser();
				JSONObject responseObj = (JSONObject)jsonParser.parse(response);

				result = (String)responseObj.get("resultCode");		        		        				
			}						
		} catch (Exception e) {
			e.printStackTrace();
		}

		return result;
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
	 * 메일 서명관리 ck에디터 이미지 업로드 호출 Method
	 */
	@RequestMapping(value = "/ezEmail/ckImageUpload.do")
	public String ckImageUpload() {
		return "ezEmail/ckImageUpload";
	}

	/**
	 * 메일 서명관리 ck에디터 업로드 화면 호출 Method
	 */
	@RequestMapping(value = "/ezEmail/ckUpload.do")
	public String ckUpload(MultipartHttpServletRequest request, Model model) throws Exception{
		MultipartFile multiFile = request.getFile("file1");
		String fileType = multiFile.getContentType().replace("\\", "/").split("/")[1];
		String filePath = config.getProperty("upload_mail.SIGNIMGS");
		String realPath = request.getServletContext().getRealPath("");
		String today = EgovDateUtil.getToday("");
		String fileName = UUID.randomUUID() + "." + fileType;

		File file = new File(realPath + filePath);
		if (!file.exists()) {
			file.mkdir();
		}

		filePath = filePath + commonUtil.separator + today;
		file = new File(realPath + filePath);
		if (!file.exists()) {
			file.mkdir();
		}

		int width = 0;
		int height = 0;

		writeUploadedFile(multiFile, fileName, realPath + filePath);

		File imageFile = new File(realPath + filePath + commonUtil.separator + fileName);			

		if (imageFile.exists()) {			
			BufferedImage bi = ImageIO.read(new File(realPath + filePath + commonUtil.separator + fileName));			    
			width = bi.getWidth();
			height = bi.getHeight();
		}

		model.addAttribute("imgPath", (filePath + commonUtil.separator + fileName +  "|!|" + width + "|!|" + height).replace("\\", "/"));

		return "ezEmail/ckUpload";
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

	/**
	 * 메일 자동삭제 조건추가 실행 함수
	 */
	@RequestMapping(value="/ezEmail/mailAutoDeleteAdd.do")
	@ResponseBody
	public String mailAutoDeleteAdd(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request, HttpServletResponse response) throws Exception{

		String userId = commonUtil.getUserIdAndPassword(loginCookie).get(0);

		String path = request.getParameter("path") == null ? "" : request.getParameter("path");
		String expireTimeStr = request.getParameter("expiretime") == null ? "" : request.getParameter("expiretime");
		int expireTime = expireTimeStr.equals("") ? 0 : Integer.parseInt(expireTimeStr);
		String deleteUnreadStr = request.getParameter("unread") == null ? "" : request.getParameter("unread");
		int deleteUnread = deleteUnreadStr.equals("") ? 0 : Integer.parseInt(deleteUnreadStr);
		String folderName = request.getParameter("foldername") == null ? "" : request.getParameter("foldername");

		ezEmailService.setMailDelete(userId, path, expireTime, deleteUnread, folderName);

		response.sendRedirect("/ezEmail/mailAutoDelete.do");
		return "";
	}

	/**
	 * 메일 자동삭제 조건추가 실행 함수
	 */
	@RequestMapping(value="/ezEmail/mailAutoDeleteDelete.do")
	@ResponseBody
	public String mailAutoDeleteDelete(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request, HttpServletResponse response) throws Exception{

		String userId = commonUtil.getUserIdAndPassword(loginCookie).get(0);

		String itemSeqStr = request.getParameter("itemseq") == null ? "" : request.getParameter("itemseq");
		int itemSeq = itemSeqStr.equals("") ? 0 : Integer.parseInt(itemSeqStr);

		ezEmailService.deleteMailDelete(userId, itemSeq);

		response.sendRedirect("/ezEmail/mailAutoDelete.do");
		return "";
	}

	/**
	 * 메일 자동분류 화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailInboxRule.do")
	public String mailInboxRule(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		return "ezEmail/mailInboxRule";
	}

	/**
	 * 메일 자동분류 분류추가 화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailNewInboxRule.do")
	public String mailNewInboxRule(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		return "ezEmail/mailNewInboxRule";
	}

	/**
	 * 메일 자동분류 분류추가 실행 함수
	 */
	@RequestMapping(value="/ezEmail/mailSetInboxRule.do", produces="text/xml; charset=utf-8")
	@ResponseBody
	public String mailSetInboxRule(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{

		String userId = commonUtil.getUserIdAndPassword(loginCookie).get(0);

		String mode = request.getParameter("mode");

		StringBuilder sb = new StringBuilder();

		Document doc = commonUtil.convertRequestToDocument(request);
		String displayName = doc.getElementsByTagName("NAME").item(0).getTextContent();
		sb.append("displayName=" + URLEncoder.encode(displayName, "UTF-8"));

		userId = userId + "@" + config.getProperty("config.DomainName");
		sb.append("&userId=" + URLEncoder.encode(userId, "UTF-8"));

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
					sb.append("&kind=" + URLEncoder.encode(rowChilds.item(j).getTextContent(), "UTF-8"));
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
					sb.append("&kind=" + URLEncoder.encode(rowChilds.item(j).getTextContent(), "UTF-8"));
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
					sb.append("&kind=" + URLEncoder.encode(rowChilds.item(j).getTextContent(), "UTF-8"));
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

		if (mode.equalsIgnoreCase("NEW")) {
			strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaAccess/setInboxRule", inputParams);
		} else if (mode.equalsIgnoreCase("DENIAL")) {
			//수신거부
		} else {
			//자동분류 수정
		}

		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(strJson);

		String returnValue = "Error";
		if (object.get("resultCode") != null) {
			returnValue = "<DATA><![CDATA[" + object.get("resultCode").toString() + "]]></DATA>";
		}

		return returnValue;
	}

	/**
	 * 메일 자동분류 분류추가 실행 함수
	 */
	@RequestMapping(value="/ezEmail/mailGetInboxRule.do", produces="text/xml; charset=utf-8")
	@ResponseBody
	public String mailGetInboxRule(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		String returnValue = "Error";
		
		String userId = commonUtil.getUserIdAndPassword(loginCookie).get(0);
		userId = userId + "@" + config.getProperty("config.DomainName");
		String inputParams = "userId=" + URLEncoder.encode(userId, "UTF-8");
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaAccess/getInboxRule", inputParams);

		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(strJson);
		if (object.get("result") != null) {
			JSONArray array = (JSONArray)object.get("result");

			DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
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
					use.appendChild(doc.createCDATASection(obj.get("isUse").toString()));
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
				
				if (obj.get("type").toString().equalsIgnoreCase("CONDITION")) {
					//DOMAIN, SENDER, RECEIVER, SUBJECT, BODY, SUBJECTORBODY
						Element kind = doc.createElement("KIND");
						kind.appendChild(doc.createCDATASection(obj.get("kind").toString()));
						tCondition.appendChild(kind);
						
						Element values = doc.createElement("VALUES");
						values.appendChild(doc.createCDATASection(obj.get("value").toString()));
						tCondition.appendChild(values);
						
				} else if (obj.get("type").toString().equalsIgnoreCase("ACTION")) {
					//DELETE, READ, IMPORTANCE, REDIRECTION, FORWARD, MOVE, COPY
					//SKIP : ASSIGNCATE, NONE, FORWARDATTACH, SENDSMS, SERVREPLY
					if (obj.get("kind").toString().equalsIgnoreCase("DELETE") || obj.get("kind").toString().equalsIgnoreCase("READ")
							|| obj.get("kind").toString().equalsIgnoreCase("IMPORTANCE") || obj.get("kind").toString().equalsIgnoreCase("REDIRECTION")
							|| obj.get("kind").toString().equalsIgnoreCase("FORWARD")) {
						Element kind = doc.createElement("KIND");
						kind.appendChild(doc.createCDATASection(obj.get("kind").toString()));
						tAction.appendChild(kind);
						
						Element values = doc.createElement("VALUES");
						values.appendChild(doc.createCDATASection(obj.get("value").toString()));
						tAction.appendChild(values);
						
					} else if (obj.get("kind").toString().equalsIgnoreCase("MOVE") || obj.get("kind").toString().equalsIgnoreCase("COPY")) {
						Element kind = doc.createElement("KIND");
						kind.appendChild(doc.createCDATASection(obj.get("kind").toString()));
						tAction.appendChild(kind);
						
						Element folderId = doc.createElement("FOLDERID");
						folderId.appendChild(doc.createCDATASection(obj.get("value").toString()));
						tAction.appendChild(folderId);
						
						Element folderName = doc.createElement("FOLDERNAME");
						
						String folderNameStr = (String)obj.get("value");
						if (folderNameStr.equals(egovMessageSource.getMessage("ezEmail.t99000084", locale))) {
							folderNameStr = egovMessageSource.getMessage("ezEmail.t99000025", locale);
						}
						if (folderNameStr.lastIndexOf(".") > -1) {
							folderNameStr = folderNameStr.substring(folderNameStr.lastIndexOf(".")+1);
						}
						folderName.appendChild(doc.createCDATASection(folderNameStr));
						tAction.appendChild(folderName);
						
						Element values = doc.createElement("VALUES");
						values.appendChild(doc.createCDATASection(obj.get("kind").toString()));
						tAction.appendChild(values);
					}
				} else if (obj.get("type").toString().equalsIgnoreCase("EXCEPTION")) {
					//DOMAIN, SENDER, RECEIVER, SUBJECT, BODY, SUBJECTORBODY
					Element kind = doc.createElement("KIND");
					kind.appendChild(doc.createCDATASection(obj.get("kind").toString()));
					tException.appendChild(kind);
					
					Element values = doc.createElement("VALUES");
					values.appendChild(doc.createCDATASection(obj.get("value").toString()));
					tException.appendChild(values);
				}
			}
			
			returnValue = commonUtil.convertDocumentToString(doc);
		}
		
		return returnValue;
	}

	/**
	 * 메일 자동분류 분류추가 실행 함수
	 */
	@RequestMapping(value="/ezEmail/mailDeleteInboxRule.do", produces="text/xml; charset=utf-8")
	@ResponseBody
	public String mailDeleteInboxRule(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		String returnValue = "Error";
		
		Document doc = commonUtil.convertRequestToDocument(request);
		String ruleId = doc.getElementsByTagName("RULEID").item(0).getTextContent();
		
		String inputParams = "ruleId=" + URLEncoder.encode(ruleId, "UTF-8");
		String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/jMochaAccess/deleteInboxRule", inputParams);
		
		JSONParser parser = new JSONParser();
		JSONObject object = (JSONObject)parser.parse(strJson);
		
		if (object.get("resultCode") != null) {
			returnValue = "<DATA><![CDATA[" + object.get("resultCode").toString() + "]]></DATA>";
		}

		return returnValue;
	}
	
}
