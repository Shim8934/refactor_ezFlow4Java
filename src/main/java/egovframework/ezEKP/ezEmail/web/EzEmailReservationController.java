package egovframework.ezEKP.ezEmail.web;

import java.io.File;
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

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezEmail.util.EzEmailUtil;
import egovframework.ezEKP.ezEmail.vo.MailReservationVO;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
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
public class EzEmailReservationController extends EgovFileMngUtil {

	private static final Logger logger = LoggerFactory.getLogger(EzEmailReservationController.class);

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
	 * 메일 예약발송 화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailReservation.do")
	public String mailReservation(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		//TODO: draftUrl, useEditor, useIE11Browser, noneActiveX setting
		String draftUrl = "";
		String useEditor = "";
		String useIE11Browser = "";
		String noneActiveX = "";
		
		String userId = commonUtil.getUserIdAndPassword(loginCookie).get(0);
		String domainName = config.getProperty("config.DomainName");
		List<MailReservationVO> list = ezEmailService.getMailReserved(userId + "@" + domainName);
		
		model.addAttribute("draftUrl", draftUrl);
		model.addAttribute("useEditor", useEditor);
		model.addAttribute("useIE11Browser", useIE11Browser);
		model.addAttribute("noneActiveX", noneActiveX);
		model.addAttribute("list", list);
		
		return "ezEmail/mailReservation";
	}
	
	/**
	 * 예약발송메일 삭제 함수
	 */
	@RequestMapping(value="/ezEmail/mailDeleteReservedMail.do")
	@ResponseBody
	public String mailDeleteReservedMail(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		String messageId = request.getParameter("messageid") == null ? "" : request.getParameter("messageid");
		ezEmailService.deleteMailReserved(messageId);
		
		String realPath = request.getServletContext().getRealPath("");
		String pDirPath = config.getProperty("upload_mail.RESERVED_MAIL_PATH");
		pDirPath = realPath + pDirPath;
		File f = new File(pDirPath + commonUtil.separator + messageId + ".eml");
		
		if (f.exists()) {
			f.delete();
		}
		
		return "";
	}
	
	
	/**
	 * 예약발송메일 수정 화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailEdit.do")
	public String mailEdit(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		return "ezEmail/mailEdit";
	}
}
