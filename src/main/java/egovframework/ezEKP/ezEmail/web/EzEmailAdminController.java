package egovframework.ezEKP.ezEmail.web;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.PrintWriter;
import java.net.URLEncoder;
import java.security.PrivateKey;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;
import java.util.Set;
import java.util.UUID;

import javax.annotation.Resource;
import javax.imageio.ImageIO;
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

import com.sun.mail.pop3.POP3Folder;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezEmail.logic.IMAPAccess;
import egovframework.ezEKP.ezEmail.logic.POP3Access;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezEmail.util.EzEmailUtil;
import egovframework.ezEKP.ezEmail.vo.MailDeleteVO;
import egovframework.ezEKP.ezEmail.vo.MailGeneralVO;
import egovframework.ezEKP.ezEmail.vo.MailPOP3VO;
import egovframework.ezEKP.ezEmail.vo.MailSignatureVO;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;
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
public class EzEmailAdminController {

	private static final Logger logger = LoggerFactory.getLogger(EzEmailAdminController.class);

	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;

	@Resource(name = "egovMessageSource")
	private EgovMessageSource egovMessageSource;

	@Autowired
	private EzEmailService ezEmailService;
	
	@Autowired
	private EzOrganAdminService ezOrganAdminService;
	
	@Autowired
	private EzEmailUtil ezEmailUtil;

	@Resource(name="crypto") 
	private EgovFileScrty egovFileScrty;

	/**
	 * 공용배포그룹관리 화면 호출 함수
	 */
	@RequestMapping(value="/admin/ezEmail/mailDistributionList.do")
	public String mailDistributionList(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		LoginVO user = commonUtil.userInfo(loginCookie);		
		
		//관리자 권한체크
		boolean auth = commonUtil.checkAdmin(loginCookie);
		if (!auth) {
			return "cmm/error/adminDenied";
		}
		
		String lang = config.getProperty("config.primary");
		List<OrganDeptVO> list = ezOrganAdminService.getCompanyList(lang);
		
		StringBuilder listCompany = new StringBuilder();
		for (OrganDeptVO vo : list) {
			if (user.getRollInfo().indexOf("c=1") > -1 || vo.getCn().equals(user.getCompanyID())) {
				listCompany.append("<option value='" + vo.getCn() + "'>");
				listCompany.append(vo.getDisplayName());
				listCompany.append("</option>");
			}
		}
		
		model.addAttribute("listCompany", listCompany);
		model.addAttribute("useOcs", config.getProperty("config.USE_OCS"));
		
		return "admin/ezEmail/mailDistributionList";
	}
	
	/**
	 * 공용배포그룹 정보 호출 함수
	 */
	@RequestMapping(value="/admin/ezEmail/mailGetDistribution.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String mailGetDistribution(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		//TODO
		return "";
	}
	
	/**
	 * 공용배포그룹 추가 화면 호출 함수
	 */
	@RequestMapping(value="/admin/ezEmail/mailAddDistributionList.do")
	public String mailAddDistributionList(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		LoginVO user = commonUtil.userInfo(loginCookie);
		
		String deptID = user.getDeptID();
		String cn = request.getParameter("cn") == null ? "" : request.getParameter("cn");
		String textName = request.getParameter("name") == null ? "" : request.getParameter("name");
		String useOcs = config.getProperty("config.USE_OCS");
		
		model.addAttribute("deptID", deptID);
		model.addAttribute("cn", cn);
		model.addAttribute("textName", textName);
		model.addAttribute("useOcs", useOcs);
		
		return "admin/ezEmail/mailAddDistributionList";
	}
	
}
