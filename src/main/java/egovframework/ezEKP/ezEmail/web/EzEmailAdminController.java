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
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
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
	private EzOrganService ezOrganService;
	
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
	@RequestMapping(value="/admin/ezEmail/mailGetDistribution.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String mailGetDistribution(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		String returnData = "";
		
		Document doc = commonUtil.convertRequestToDocument(request);
		String companyId = doc.getElementsByTagName("COMPID").item(0).getTextContent();
		
		try {
			String inputParams = "companyId=" + URLEncoder.encode(companyId, "UTF-8");

			logger.debug("inputParams=" + inputParams);

			String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaAccess/getDistributionList";			
			String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);

			logger.debug("response=" + response);
			
			JSONArray resultArray = null;
			
			if (response != null) {
				JSONParser jsonParser = new JSONParser();
				JSONObject responseObj = (JSONObject)jsonParser.parse(response);
				
				String resultCode = (String)responseObj.get("resultCode");
				
				if (resultCode.equalsIgnoreCase("OK")) {
					resultArray = (JSONArray)responseObj.get("result");
				}
			}
			
			StringBuilder sb = new StringBuilder();
			sb.append("<LISTVIEWDATA><ROWS>");

			if (resultArray != null) {
				for (int i = 0; i < resultArray.size(); i++) {
					sb.append("<ROW><CELL>");
					
					Map<String, String> rowObject = (Map<String, String>)resultArray.get(i);
					
					for (String colName : rowObject.keySet()) {
						String colValue = rowObject.get(colName);
						sb.append("<" + colName + ">");
						sb.append(colValue);
						sb.append("</" + colName + ">");
					}
					
					sb.append("</CELL></ROW>");
				}
			}
			
			sb.append("</ROWS></LISTVIEWDATA>");
			
			returnData = sb.toString();
			
		} catch (Exception e) {
			returnData = "ERROR";
			e.printStackTrace();
		}

		return returnData;
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
	
	/**
	 * 공용배포그룹 추가 실행 함수
	 */
	@RequestMapping(value="/admin/ezEmail/mailSaveDistributionList.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String mailSaveDistributionList(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		Document doc = commonUtil.convertRequestToDocument(request);
		String companyId = doc.getElementsByTagName("COMPID").item(0).getTextContent();
		String cn = doc.getElementsByTagName("CN").item(0).getTextContent();
		String name = doc.getElementsByTagName("NAME").item(0).getTextContent();
		String id = doc.getElementsByTagName("ID").item(0).getTextContent();
		NodeList memberIdList = doc.getElementsByTagName("MEMBERID");
		
		String domain = config.getProperty("config.DomainName");
		String result = "ERROR";
		
		try {
			if (cn == null || cn.equals("")) {
				String inputParams = "companyId=" + URLEncoder.encode(companyId, "UTF-8")
								   + "&name=" + URLEncoder.encode(name, "UTF-8")
								   + "&id=" + URLEncoder.encode(id, "UTF-8")
								   + "&domain=" + URLEncoder.encode(domain, "UTF-8");

				for (int i=0; i<memberIdList.getLength(); i++) {
					inputParams += "&memberId=" + URLEncoder.encode(memberIdList.item(i).getTextContent(), "UTF-8");
				}

				logger.debug("inputParams=" + inputParams);

				String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaAccess/setDistributionList";			
				String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);

				logger.debug("response=" + response);

				if (response != null) {
					JSONParser jsonParser = new JSONParser();
					JSONObject responseObj = (JSONObject)jsonParser.parse(response);

					result = (String)responseObj.get("resultCode");
				}

			} else {
				String inputParams = "companyId=" + URLEncoder.encode(companyId, "UTF-8")
				+ "&cn=" + URLEncoder.encode(cn, "UTF-8")
				+ "&name=" + URLEncoder.encode(name, "UTF-8")
				+ "&id=" + URLEncoder.encode(id, "UTF-8")
				+ "&domain=" + URLEncoder.encode(domain, "UTF-8");

				for (int i=0; i<memberIdList.getLength(); i++) {
					inputParams += "&memberId=" + URLEncoder.encode(memberIdList.item(i).getTextContent(), "UTF-8");
				}

				logger.debug("inputParams=" + inputParams);

				String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaAccess/updateDistributionList";			
				String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);

				logger.debug("response=" + response);

				if (response != null) {
					JSONParser jsonParser = new JSONParser();
					JSONObject responseObj = (JSONObject)jsonParser.parse(response);

					result = (String)responseObj.get("resultCode");
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return result;
	}
	
	/**
	 * 공용배포그룹 구성원 정보 호출 함수
	 */
	@RequestMapping(value="/admin/ezEmail/mailViewDistributionList.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String mailViewDistributionList(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		String returnData = "";
		
		Document doc = commonUtil.convertRequestToDocument(request);
		String cn = doc.getElementsByTagName("CN").item(0).getTextContent();
		String domain = config.getProperty("config.DomainName");
		
		try {
			String inputParams = "cn=" + URLEncoder.encode(cn, "UTF-8")
							   + "&domain=" + URLEncoder.encode(domain, "UTF-8");
			
			logger.debug("inputParams=" + inputParams);
			
			String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaAccess/getDistribution";
			String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
			
			logger.debug("response=" + response);
			
			JSONArray resultArray = null;
			
			if (response != null) {
				JSONParser jsonParser = new JSONParser();
				JSONObject responseObj = (JSONObject)jsonParser.parse(response);

				String resultCode = (String)responseObj.get("resultCode");
				
				if (resultCode.equalsIgnoreCase("OK")) {
					resultArray = (JSONArray)responseObj.get("result");
				}
			}
			
			StringBuilder sb = new StringBuilder();
			sb.append("<DATA>");
			
			for (int i=0; i<resultArray.size(); i++) {
				JSONObject address = (JSONObject)resultArray.get(i);
				String pCn = (String)address.get("cn");
				pCn = pCn.substring(0, pCn.indexOf("@"));
				String pClass = (String)address.get("class");
				
				logger.debug("pCn=" + pCn + ", pClass=" + pClass);
				
				if(pClass.equals("group")) {
					OrganDeptVO dept = ezOrganService.getDeptInfo(pCn, config.getProperty("config.primary"));
					sb.append("<ROW>");
					sb.append("<CLASS>" + pClass + "</CLASS>");
					sb.append("<CN>" + pCn + "</CN>");
					sb.append("<DISPLAYNAME>" + dept.getDisplayName() + "</DISPLAYNAME>");
					sb.append("<MAIL>" + dept.getMail() + "</MAIL>");
					sb.append("<COMPANY>" + dept.getExtensionAttribute3() + "</COMPANY>");
					sb.append("<DEPT>" + egovMessageSource.getMessage("ezOrgan.t68", locale) + "</DEPT>");
					sb.append("<TITLE>" + egovMessageSource.getMessage("ezOrgan.t68", locale) + "</TITLE>");
					sb.append("</ROW>");
				
				} else {
					OrganUserVO user = ezOrganAdminService.getUserInfo(pCn, config.getProperty("config.primary"));
					sb.append("<ROW>");
					sb.append("<CLASS>" + pClass + "</CLASS>");
					sb.append("<CN>" + pCn + "</CN>");
					sb.append("<DISPLAYNAME>" + user.getDisplayName() + "</DISPLAYNAME>");
					sb.append("<MAIL>" + user.getMail() + "</MAIL>");
					sb.append("<COMPANY>" + user.getCompany() + "</COMPANY>");
					sb.append("<DEPT>" + user.getDescription() + "</DEPT>");
					sb.append("<TITLE>" + user.getTitle() + "</TITLE>");
					sb.append("</ROW>");
				}
				
			}
			
			sb.append("</DATA>");
			
			returnData = sb.toString();
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return returnData;
	}
	
	/**
	 * 공용배포그룹 삭제 실행 함수
	 */
	@RequestMapping(value="/admin/ezEmail/mailDelDistributionList.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String mailDelDistributionList(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		Document doc = commonUtil.convertRequestToDocument(request);
		String cn = doc.getElementsByTagName("CN").item(0).getTextContent();
		String domain = config.getProperty("config.DomainName");
		String result = "ERROR";
		
		try {
			String inputParams = "cn=" + URLEncoder.encode(cn, "UTF-8")
							   + "&domain=" + URLEncoder.encode(domain, "UTF-8");
			
			logger.debug("inputParams=" + inputParams);
			
			String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaAccess/deleteDistribution";
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
	
}
