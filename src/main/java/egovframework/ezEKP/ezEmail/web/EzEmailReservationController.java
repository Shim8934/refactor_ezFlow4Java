package egovframework.ezEKP.ezEmail.web;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.*;

import javax.annotation.Resource;
import javax.mail.Flags;
import javax.mail.Folder;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.servlet.http.HttpServletRequest;

import com.sun.mail.imap.AppendUID;
import com.sun.mail.imap.IMAPFolder;
import egovframework.ezEKP.ezEmail.logic.IMAPAccess;
import egovframework.ezEKP.ezEmail.logic.SMTPAccess;
import egovframework.ezEKP.ezEmail.util.EzEmailUtil;
import egovframework.ezEKP.ezEmail.vo.MailWriteProcessVO;
import egovframework.let.utl.fcc.service.EzFAL;
import org.apache.commons.lang3.StringUtils;
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
import org.w3c.dom.Element;
import org.w3c.dom.Node;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EzFileMngUtil;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezEmail.vo.MailReservationVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

/**
 * @Description [Controller] 메일 예약발송관리
 * @author 오픈솔루션팀 이효민
 * @Modification Information
 * 
 *    수정일        수정자         수정내용
 *    ----------    ------    -------------------
 *    2016.05.18    이효민    신규작성
 *
 * @see
 */

@Controller
public class EzEmailReservationController extends EzFileMngUtil {

	private static final Logger logger = LoggerFactory.getLogger(EzEmailReservationController.class);

	@Autowired
	private CommonUtil commonUtil;

	@Resource(name = "egovMessageSource")
	private EgovMessageSource egovMessageSource;

	@Autowired
	private EzEmailService ezEmailService;
	
	@Resource(name = "EzCommonService")
    private EzCommonService ezCommonService;
    @Autowired
    private EzEmailUtil ezEmailUtil;

	@Resource(name = "jspw")
	private String jspw;

	@Autowired
	private Properties config;

	/**
	 * 메일 예약발송 화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailReservation.do", method = RequestMethod.GET)
	public String mailReservation(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		logger.debug("mailReservation started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		String shareId = request.getParameter("shareId");
		String mailId = StringUtils.isBlank(shareId)? userInfo.getId() : shareId;
		
		String draftUrl = "";
		String useEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		String noneActiveX = "YES";
		
		List<MailReservationVO> list = ezEmailService.getMailReserved(userInfo.getTenantId(), mailId);
		
		for (MailReservationVO vo : list) {
			vo.setSendDate(commonUtil.getDateStringInUTC(vo.getSendDate(), userInfo.getOffset(), false));
		}
		
		model.addAttribute("shareId", shareId);
		model.addAttribute("draftUrl", draftUrl);
		model.addAttribute("useEditor", useEditor);
		model.addAttribute("noneActiveX", noneActiveX);
		model.addAttribute("list", list);
		
		logger.debug("mailReservation ended.");
		return "ezEmail/mailReservation";
	}

	/**
	 * 예약발송메일 삭제 함수
	 */
	@RequestMapping(value="/ezEmail/mailDeleteReservedMail.do", method = RequestMethod.POST)
	@ResponseBody
	public String mailDeleteReservedMail(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		logger.debug("mailDeleteReservedMail started.");
		
		String messageId = request.getParameter("messageid") == null ? "" : request.getParameter("messageid");
		messageId = commonUtil.detectPathTraversal(messageId);
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
		String userEmail = userInfo.getId() + "@" + domainName;

		String realPath = commonUtil.getRealPath(request);
		String pDirPath = commonUtil.getUploadPath("upload_mail.RESERVED_MAIL_PATH", userInfo.getTenantId());
		pDirPath = realPath + pDirPath;
		EzFAL.EzFile f = new EzFAL.EzFile(pDirPath + commonUtil.separator + messageId + ".eml");

		String password = jspw;
		Message savedMessage = null;
		FileInputStream fis = null;

		IMAPAccess ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
				userEmail, password, egovMessageSource, locale, ezEmailUtil);
		SMTPAccess sa = SMTPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.SMTPPort"),
				userEmail, password);

		try {
			fis = new FileInputStream(f);
			savedMessage = sa.readMimeMessage(fis); // MimeMessage
			savedMessage.setFlag(Flags.Flag.SEEN, true);

			Folder draftsFolder = ia.getFolder(ezEmailUtil.getDraftsFolderId(locale));

			draftsFolder.open(Folder.READ_WRITE);

			draftsFolder.appendMessages(new Message[]{savedMessage});

			draftsFolder.close(true);
		} catch (MessagingException | IOException e) {
			logger.error("IOException has occurred");
			logger.error(e.getMessage(), e);
		} finally {
			if (fis != null) fis.close();
			if (ia != null) ia.close();
		}

		ezEmailService.deleteMailReserved(messageId);
		
		if (f.exists()) {
			f.delete();
			logger.debug(pDirPath + commonUtil.separator + messageId + ".eml deleted.");
		}

		logger.debug("mailDeleteReservedMail ended.");
		
		return "";
	}

	/**
	 * 예약발송메일 수정 화면 호출 함수
	 * : /ezEmail/mailWrite.do 로 통합함.
	 */
	
	/**
	 * 예약발송메일 DB 체크 함수
	 */
	@RequestMapping(value="/ezEmail/reservedMailCheck.do", method = RequestMethod.POST)
	@ResponseBody
	public String reservedMailCheck(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, @RequestBody String bodyData) throws Exception{
		logger.debug("reservedMailCheck started.");
		logger.debug("bodyData=" + bodyData);
		
		String returnValue = "<DATA>MAIL-NOT-EXISTS</DATA>";
		if (bodyData != null){
			Document xmlDoc = commonUtil.convertStringToDocument(bodyData);
			Element root = xmlDoc.getDocumentElement();
			String messageId  = "";
			Node tempNode = null;

			if (root.getElementsByTagName("MESSAGEID") != null) {
				tempNode = root.getElementsByTagName("MESSAGEID").item(0);
				if (tempNode != null) {
					messageId = tempNode.getTextContent();
				}
			}

			if (messageId != null && !messageId.equals("")) {
				String reservedTime = ezEmailService.getMailReservedTime(messageId);

				if (reservedTime != null) {
					returnValue = "<DATA>MAIL-EXISTS</DATA>";
				}
			}
		}
		
		logger.debug("returnValue=" + returnValue);
		logger.debug("reservedMailCheck ended.");
		
		return returnValue;
	}
	
	/**
	 * 메일 메시지 화면 화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailMessage.do", method = RequestMethod.GET)
	public String mailMessage(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		logger.debug("mailMessage started.");
		
		String pReservedSaveTime = "";
		String pCDOMessageID = "";
		LoginVO loginInfo = commonUtil.userInfo(loginCookie);
		if (request.getParameter("messageid") != null && !request.getParameter("messageid").trim().equals("")) { 
			pCDOMessageID = request.getParameter("messageid").trim();
			
			pReservedSaveTime = ezEmailService.getMailReservedTime(pCDOMessageID);
			
			//utc에서 timezone으로 시간변경
			pReservedSaveTime = commonUtil.getDateStringInUTC(pReservedSaveTime, loginInfo.getOffset(), false);
			
			Calendar cal = Calendar.getInstance();
			cal.add(Calendar.MINUTE, 30);
			Date currentTime = cal.getTime();

			SimpleDateFormat transFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");
			Date reservedSaveTime = transFormat.parse(pReservedSaveTime);

			//예약발송 시간 30분 전에는 수정 불가
			if (reservedSaveTime.before(currentTime)) { 
				model.addAttribute("pMessage", egovMessageSource.getMessage("ezEmail.lhm07", locale));
				logger.debug(egovMessageSource.getMessage("ezEmail.lhm07", locale));
			}
		}
		logger.debug("mailMessage ended.");
		return "ezEmail/mailMessage";
	}
	@RequestMapping(value="/ezEmail/getServerTime.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, String> getServerTime(@CookieValue("loginCookie") String loginCookie) throws Exception {
		String utcDate = commonUtil.getTodayUTCTime("");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String nowDate = commonUtil.getDateStringInUTC(utcDate, userInfo.getOffset(), false);

		Map<String, String> result = new HashMap<>();
		result.put("serverTime", nowDate);
		return result;
	}
}
