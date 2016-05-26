package egovframework.ezEKP.ezEmail.web;

import java.awt.image.BufferedImage;
import java.io.File;
import java.net.URLEncoder;
import java.util.List;
import java.util.Locale;
import java.util.Properties;
import java.util.UUID;

import javax.annotation.Resource;
import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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
	private EzOrganAdminService ezOrganAdminService;

	@Autowired
	private EzOrganService ezOrganService;

	@Autowired
	private EzEmailService ezEmailService;

	@Autowired
	private EzEmailUtil ezEmailUtil;

	/**
	 * 메일 수신확인/회수 화면 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailReaderList.do")
	public String mailConfig(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		String url = request.getParameter("url") == null ? "" : request.getParameter("url");
		url = URLEncoder.encode(url, "UTF-8");
		model.addAttribute("url", url);
		return "ezEmail/mailReaderList";
	}
	
	/**
	 * 메일 수신확인 리스트 호출 함수
	 */
	@RequestMapping(value="/ezEmail/mailGetReceiveList.do", produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String mailGetReceiveList(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		String returnValue = "";
		
		Document xmldom = commonUtil.convertRequestToDocument(request);
		String messageId = xmldom.getElementsByTagName("MESSAGEID").item(0).getTextContent();
		
		
		return returnValue;
	}
	
}
