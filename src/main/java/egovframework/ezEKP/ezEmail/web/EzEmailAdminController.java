package egovframework.ezEKP.ezEmail.web;

import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.RichTextString;
import org.apache.poi.ss.usermodel.Row;
import org.apache.tomcat.jni.User;
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
import org.w3c.dom.Document;
import org.w3c.dom.NodeList;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezAddress.service.EzAddressService;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.logic.IMAPAccess;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezEmail.service.EzEmailUserAdminService;
import egovframework.ezEKP.ezEmail.util.EzEmailUtil;
import egovframework.ezEKP.ezEmail.vo.MailColorVO;
import egovframework.ezEKP.ezEmail.vo.MailDistributionVO;
import egovframework.ezEKP.ezEmail.vo.MailSharedMailboxVO;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.ezEKP.ezSystem.vo.ConnectionInfoVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.user.login.vo.TenantVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

/**
 * @Description [Controller] 메일 환경설정
 * @author 오픈솔루션팀 이효민
 * @Modification Information
 * 
 *               수정일 수정자 수정내용 ---------- ------ ------------------- 2016.05.10
 *               이효민 신규작성
 *
 * @see
 */

@Controller
public class EzEmailAdminController {

	private static final Logger logger = LoggerFactory
			.getLogger(EzEmailAdminController.class);

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
	private EzEmailUserAdminService ezEmailUserAdminService;
	
	@Autowired
	private EzAddressService ezAddressService;
	
	@Resource(name = "jspw")
	private String jspw;

	@Resource(name = "EzCommonService")
	private EzCommonService ezCommonService;

	@Autowired
	private EzEmailUtil ezEmailUtil;

	@Resource(name = "crypto")
	private EgovFileScrty egovFileScrty;
	
	@Autowired
	private Properties globals;

	/**
	 * 공용배포그룹관리 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezEmail/mailDistributionList.do")
	public String mailDistributionList(
			@CookieValue("loginCookie") String loginCookie, Locale locale,
			Model model, HttpServletRequest request) throws Exception {
		logger.debug("mailDistributionList started.");

		// 관리자 권한체크
		LoginVO auth = commonUtil.checkAdmin(loginCookie);
		if (auth == null) {
			return "cmm/error/adminDenied";
		}

		List<OrganDeptVO> list = ezOrganAdminService.getCompanyList(
				auth.getPrimary(), auth.getTenantId());

		List<OrganDeptVO> resultList = new ArrayList<OrganDeptVO>();
		
		for (int i = 0 ; i < list.size() ; i++) {
			OrganDeptVO vo = list.get(i);
			
			if (auth.getRollInfo().indexOf("c=1") > -1 || vo.getCn().equals(auth.getCompanyID())) {
				resultList.add(vo);
			}
		}
		
		model.addAttribute("list", resultList);
		model.addAttribute("userCompany", auth.getCompanyID());
		model.addAttribute("useOcs", config.getProperty("config.USE_OCS"));
		
		logger.debug("mailDistributionList ended.");

		return "admin/ezEmail/mailDistributionList";
	}

	/**
	 * 공용배포그룹 정보 호출 함수
	 */
	@RequestMapping(value = "/admin/ezEmail/mailGetDistribution.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String mailGetDistribution(
			@CookieValue("loginCookie") String loginCookie, Locale locale,
			Model model, @RequestBody String bodyData) throws Exception {
		logger.debug("mailGetDistribution started.");
		logger.debug("bodyData=" + bodyData);

		// 관리자 권한체크
		LoginVO auth = commonUtil.checkAdmin(loginCookie);
		if (auth == null) {
			return "cmm/error/adminDenied";
		}

		String returnData = "";

		try {
			Document doc = commonUtil.convertStringToDocument(bodyData);
			String companyId = doc.getElementsByTagName("COMPID").item(0)
					.getTextContent();
			String cn = doc.getElementsByTagName("CN").item(0).getTextContent() == null ? "" 
					: doc.getElementsByTagName("CN").item(0).getTextContent();
			//모든 공용배포그룹
			List<MailDistributionVO> distributionTotalList = ezEmailService
					.getDistributionList(companyId, auth.getTenantId());
			
			logger.debug("cn=" + cn);
			
			if (cn != null && !cn.equals("null") && !cn.isEmpty()) {
				//cn을 포함하는 공용배포그룹
				List<MailDistributionVO> distributionSearchList = ezEmailService
						.getDistributioUpperList(cn, auth.getTenantId());
				
				for (MailDistributionVO vo : distributionSearchList) {
					distributionTotalList.remove(vo);
				}
			}
			
			StringBuilder sb = new StringBuilder();
			sb.append("<LISTVIEWDATA><ROWS>");

			for (MailDistributionVO vo : distributionTotalList) {
				sb.append("<ROW><CELL>");

				sb.append("<VALUE>");
				sb.append(commonUtil.cleanValue(vo.getName()));
				sb.append("</VALUE>");

				sb.append("<DATA1>");
				sb.append(commonUtil.cleanValue(vo.getId()));
				sb.append("</DATA1>");

				sb.append("<DATA2>");
				sb.append(commonUtil.cleanValue(vo.getMail()));
				sb.append("</DATA2>");

				sb.append("</CELL></ROW>");
			}

			sb.append("</ROWS></LISTVIEWDATA>");

			returnData = sb.toString();

		} catch (Exception e) {
			returnData = "ERROR";
			e.printStackTrace();
		}

		logger.debug("returnData=" + returnData);
		logger.debug("mailGetDistribution ended.");

		return returnData;
	}

	/**
	 * 공용배포그룹 추가 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezEmail/mailAddDistributionList.do")
	public String mailAddDistributionList(
			@CookieValue("loginCookie") String loginCookie, Locale locale,
			Model model, HttpServletRequest request) throws Exception {
		logger.debug("mailAddDistributionList started.");

		// 관리자 권한체크
		LoginVO auth = commonUtil.checkAdmin(loginCookie);
		if (auth == null) {
			return "cmm/error/adminDenied";
		}

		String deptID = auth.getDeptID();
		String cn = request.getParameter("cn") == null ? "" : request
				.getParameter("cn");
		String textName = request.getParameter("name") == null ? "" : request
				.getParameter("name");
		String useOcs = config.getProperty("config.USE_OCS");
		String companyId = request.getParameter("companyId");

		model.addAttribute("deptID", deptID);
		model.addAttribute("cn", cn);
		model.addAttribute("textName", textName);
		model.addAttribute("useOcs", useOcs);
		model.addAttribute("companyId", companyId);
		
		logger.debug("mailAddDistributionList ended.");

		return "admin/ezEmail/mailAddDistributionList";
	}

	/**
	 * 공용배포그룹 추가 실행 함수
	 */
	@RequestMapping(value = "/admin/ezEmail/mailSaveDistributionList.do", produces = "text/html;charset=utf-8")
	@ResponseBody
	public String mailSaveDistributionList(
			@CookieValue("loginCookie") String loginCookie, Locale locale,
			Model model, @RequestBody String bodyData) throws Exception {
		logger.debug("mailSaveDistributionList started.");
		logger.debug("bodyData=" + bodyData);

		// 관리자 권한체크
		LoginVO auth = commonUtil.checkAdmin(loginCookie);
		if (auth == null) {
			return "cmm/error/adminDenied";
		}

		Document doc = commonUtil.convertStringToDocument(bodyData);
		String companyId = doc.getElementsByTagName("COMPID").item(0)
				.getTextContent();
		String cn = doc.getElementsByTagName("CN").item(0).getTextContent();
		String name = doc.getElementsByTagName("NAME").item(0).getTextContent();
		String id = doc.getElementsByTagName("ID").item(0).getTextContent();
		NodeList memberIdList = doc.getElementsByTagName("MEMBERID");

		int tenantID = auth.getTenantId();

		String domain = ezCommonService.getTenantConfig("DomainName", tenantID);

		int reasonCode = -100;
		String result = "ERROR";
		String bizmekaResult = "ERROR";

		try {
			String useBizmekaSpambox = ezCommonService.getTenantConfig(
					"UseBizmekaSpambox", tenantID);

			// 새 공용배포그룹 등록하는 경우
			if (cn == null || cn.equals("")) {
				if (useBizmekaSpambox.equals("YES")) {
					String bizmekaAdminId = ezCommonService.getTenantConfig(
							"bizmekaAdminId", tenantID);
					String bizmekaAdminPw = ezCommonService.getTenantConfig(
							"bizmekaAdminPw", tenantID);
					String bizmekaCompanyId = ezCommonService.getTenantConfig(
							"BizmekaCompanyId", tenantID);

					List<String> memberList = new ArrayList<String>();

					for (int i = 0; i < memberIdList.getLength(); i++) {
						memberList.add(memberIdList.item(i).getTextContent());
					}

					bizmekaResult = ezEmailUtil.bizmekaAddDistributionList(
							bizmekaAdminId, bizmekaAdminPw, bizmekaCompanyId,
							id, name, memberList);

					logger.debug("bizmekaResult=" + bizmekaResult);

					if (!bizmekaResult.equals("OK")) {
						throw new Exception("bizmekaAddDistributionList failed");
					}
				}
				
				String inputParams = "companyId="
						+ URLEncoder.encode(companyId, "UTF-8") + "&name="
						+ URLEncoder.encode(name, "UTF-8") + "&id="
						+ URLEncoder.encode(id, "UTF-8") + "&domain="
						+ URLEncoder.encode(domain, "UTF-8");

				for (int i = 0; i < memberIdList.getLength(); i++) {
					inputParams += "&memberId="
							+ URLEncoder.encode(memberIdList.item(i)
									.getTextContent(), "UTF-8");
				}

				String companyDomainName = ezCommonService.getCompanyConfig(tenantID, companyId, "DomainName");
				
				// 회사별 이메일 도메인명이 설정되어 있으면 해당 도메인명을 기반으로 한 이메일 주소를 함께 전달한다.								
				if (!companyDomainName.isEmpty()) {
					String email = id + "@" + companyDomainName;
					
					inputParams += "&email=" + URLEncoder.encode(email, "UTF-8");
				}
				
				logger.debug("inputParams=" + inputParams);

				String requestURL = config.getProperty("config.JGwServerURL")
						+ "/jMochaAccess/setDistributionList";
				String response = ezEmailUtil.getWebServiceResult(requestURL,
						inputParams);

				logger.debug("response=" + response);

				if (response != null) {
					JSONParser jsonParser = new JSONParser();
					JSONObject responseObj = (JSONObject) jsonParser
							.parse(response);

					String resultCode = (String) responseObj.get("resultCode");
					if (resultCode.equals("OK")) {
						reasonCode = ((Long) responseObj.get("reasonCode"))
								.intValue();
					}
				}
				// 기존 공용배포그룹을 수정하는 경우
			} else {
				if (useBizmekaSpambox.equals("YES")) {
					String bizmekaAdminId = ezCommonService.getTenantConfig(
							"bizmekaAdminId", tenantID);
					String bizmekaAdminPw = ezCommonService.getTenantConfig(
							"bizmekaAdminPw", tenantID);
					String bizmekaCompanyId = ezCommonService.getTenantConfig(
							"BizmekaCompanyId", tenantID);

					List<String> memberList = new ArrayList<String>();

					for (int i = 0; i < memberIdList.getLength(); i++) {
						memberList.add(memberIdList.item(i).getTextContent());
					}

					bizmekaResult = ezEmailUtil.bizmekaEditDistributionList(
							bizmekaAdminId, bizmekaAdminPw, bizmekaCompanyId,
							id, name, memberList);

					logger.debug("bizmekaResult=" + bizmekaResult);

					if (!bizmekaResult.equals("OK")) {
						throw new Exception(
								"bizmekaEditDistributionList failed");
					}
				}

				String inputParams = "companyId="
						+ URLEncoder.encode(companyId, "UTF-8") + "&cn="
						+ URLEncoder.encode(cn, "UTF-8") + "&name="
						+ URLEncoder.encode(name, "UTF-8") + "&id="
						+ URLEncoder.encode(id, "UTF-8") + "&domain="
						+ URLEncoder.encode(domain, "UTF-8");

				for (int i = 0; i < memberIdList.getLength(); i++) {
					inputParams += "&memberId="
							+ URLEncoder.encode(memberIdList.item(i)
									.getTextContent(), "UTF-8");
				}

				String companyDomainName = ezCommonService.getCompanyConfig(tenantID, companyId, "DomainName");
				
				// 회사별 이메일 도메인명이 설정되어 있으면 해당 도메인명을 기반으로 한 이메일 주소를 함께 전달한다.								
				if (!companyDomainName.isEmpty()) {
					String email = id + "@" + companyDomainName;
					
					inputParams += "&email=" + URLEncoder.encode(email, "UTF-8");
				}
				
				logger.debug("inputParams=" + inputParams);

				String requestURL = config.getProperty("config.JGwServerURL")
						+ "/jMochaAccess/updateDistributionList";
				String response = ezEmailUtil.getWebServiceResult(requestURL,
						inputParams);

				logger.debug("response=" + response);

				if (response != null) {
					JSONParser jsonParser = new JSONParser();
					JSONObject responseObj = (JSONObject) jsonParser
							.parse(response);

					String resultCode = (String) responseObj.get("resultCode");
					if (resultCode.equals("OK")) {
						reasonCode = ((Long) responseObj.get("reasonCode"))
								.intValue();
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		if (reasonCode == 0) {
			result = "OK";
		} else if (reasonCode == -1) {
			result = "GROUP_NAME";
		} else if (reasonCode == -2) {
			result = "GROUP_ID";
		}

		logger.debug("result=" + result);
		logger.debug("mailSaveDistributionList ended.");

		return result;
	}

	/**
	 * 공용배포그룹 구성원 정보 호출 함수
	 */
	@RequestMapping(value = "/admin/ezEmail/mailViewDistributionList.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String mailViewDistributionList(
			@CookieValue("loginCookie") String loginCookie, Locale locale,
			Model model, @RequestBody String bodyData) throws Exception {
		logger.debug("mailViewDistributionList started.");

		String returnData = "";

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String domain = ezCommonService.getTenantConfig("DomainName",
				userInfo.getTenantId());

		Document doc = commonUtil.convertStringToDocument(bodyData);
		String cn = doc.getElementsByTagName("CN").item(0).getTextContent();

		try {
			String inputParams = "cn=" + URLEncoder.encode(cn, "UTF-8")
					+ "&domain=" + URLEncoder.encode(domain, "UTF-8");

			logger.debug("inputParams=" + inputParams);

			String requestURL = config.getProperty("config.JGwServerURL")
					+ "/jMochaAccess/getDistribution";
			String response = ezEmailUtil.getWebServiceResult(requestURL,
					inputParams);

			logger.debug("response=" + response);

			JSONArray resultArray = null;

			if (response != null) {
				JSONParser jsonParser = new JSONParser();
				JSONObject responseObj = (JSONObject) jsonParser
						.parse(response);

				String resultCode = (String) responseObj.get("resultCode");
		
				if (resultCode.equalsIgnoreCase("OK")) {
					resultArray = (JSONArray) responseObj.get("result");
				}
			}

			StringBuilder sb = new StringBuilder();
			sb.append("<DATA>");

			for (int i = 0; i < resultArray.size(); i++) {
				JSONObject address = (JSONObject) resultArray.get(i);
				String pCn = (String) address.get("cn");
				pCn = pCn.substring(0, pCn.indexOf("@"));
				String pClass = (String) address.get("class");
				String displayName = (String) address.get("displayName"); //

				logger.debug("pCn=" + pCn + ", pClass=" + pClass + ", displayName=" + displayName);

				if (pClass.equals("group")) {
					OrganDeptVO dept = ezOrganService.getDeptInfo(pCn,
							userInfo.getPrimary(), userInfo.getTenantId());
					if (dept != null) {
						sb.append("<ROW>");
						sb.append("<CLASS>" + pClass + "</CLASS>");
						sb.append("<CN>" + commonUtil.cleanValue(pCn) + "</CN>");
						sb.append("<DISPLAYNAME>"
								+ commonUtil.cleanValue(dept.getDisplayName())
								+ "</DISPLAYNAME>");
						sb.append("<MAIL>"
								+ commonUtil.cleanValue(dept.getMail())
								+ "</MAIL>");
						sb.append("<COMPANY>"
								+ commonUtil.cleanValue(dept
										.getExtensionAttribute3())
								+ "</COMPANY>");
						sb.append("<DEPT>"
								+ egovMessageSource.getMessage("ezOrgan.t68",
										locale) + "</DEPT>");
						sb.append("<TITLE>"
								+ egovMessageSource.getMessage("ezOrgan.t68",
										locale) + "</TITLE>");
						sb.append("</ROW>");
					} else {
						sb.append("<ROW>");
						sb.append("<CLASS>" + "distribution" + "</CLASS>");
						sb.append("<CN>" + commonUtil.cleanValue(pCn) + "</CN>");
						sb.append("<DISPLAYNAME>"
								+ displayName
								+ "</DISPLAYNAME>");
						sb.append("<MAIL>"
								+ commonUtil.cleanValue(cn)
								+ "</MAIL>");
						sb.append("<DEPT>"
								+ egovMessageSource.getMessage("ezEmail.t57",
										locale) + "</DEPT>");
						sb.append("</ROW>");
						}

				} else {
					OrganUserVO user = ezOrganAdminService.getUserInfo(pCn,
							userInfo.getPrimary(), userInfo.getTenantId());
					if (user != null) {
						sb.append("<ROW>");
						sb.append("<CLASS>" + pClass + "</CLASS>");
						sb.append("<CN>" + commonUtil.cleanValue(pCn) + "</CN>");
						sb.append("<DISPLAYNAME>"
								+ commonUtil.cleanValue(user.getDisplayName())
								+ "</DISPLAYNAME>");
						sb.append("<MAIL>"
								+ commonUtil.cleanValue(user.getMail())
								+ "</MAIL>");
						sb.append("<COMPANY>"
								+ commonUtil.cleanValue(user.getCompany())
								+ "</COMPANY>");
						sb.append("<DEPT>"
								+ commonUtil.cleanValue(user.getDescription())
								+ "</DEPT>");
						sb.append("<TITLE>"
								+ commonUtil.cleanValue(user.getTitle())
								+ "</TITLE>");
						sb.append("</ROW>");
					}
				}
			}

			sb.append("</DATA>");
			returnData = sb.toString();

		} catch (Exception e) {
			e.printStackTrace();
		}

		logger.debug("mailViewDistributionList ended.");

		return returnData;
	}

	/**
	 * 공용배포그룹 삭제 실행 함수
	 */
	@RequestMapping(value = "/admin/ezEmail/mailDelDistributionList.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String mailDelDistributionList(
			@CookieValue("loginCookie") String loginCookie, Locale locale,
			Model model, @RequestBody String bodyData) throws Exception {
		logger.debug("mailDelDistributionList started.");
		logger.debug("bodyData=" + bodyData);

		// 관리자 권한체크
		LoginVO auth = commonUtil.checkAdmin(loginCookie);
		if (auth == null) {
			return "cmm/error/adminDenied";
		}

		Document doc = commonUtil.convertStringToDocument(bodyData);
		String companyId = doc.getElementsByTagName("COMPID").item(0)
				.getTextContent();		
		String cn = doc.getElementsByTagName("CN").item(0).getTextContent();

		int tenantID = auth.getTenantId();

		String domain = ezCommonService.getTenantConfig("DomainName", tenantID);

		String result = "ERROR";
		String bizmekaResult = "ERROR";

		try {
			String useBizmekaSpambox = ezCommonService.getTenantConfig(
					"UseBizmekaSpambox", tenantID);

			if (useBizmekaSpambox.equals("YES")) {
				String bizmekaAdminId = ezCommonService.getTenantConfig(
						"bizmekaAdminId", tenantID);
				String bizmekaAdminPw = ezCommonService.getTenantConfig(
						"bizmekaAdminPw", tenantID);
				String bizmekaCompanyId = ezCommonService.getTenantConfig(
						"BizmekaCompanyId", tenantID);

				bizmekaResult = ezEmailUtil.bizmekaDeleteDistributionList(
						bizmekaAdminId, bizmekaAdminPw, bizmekaCompanyId, cn);

				logger.debug("bizmekaResult=" + bizmekaResult);

				if (!bizmekaResult.equals("OK")) {
					throw new Exception("bizmekaDeleteDistributionList failed");
				}
			}

			String inputParams = "cn=" + URLEncoder.encode(cn, "UTF-8")
					+ "&domain=" + URLEncoder.encode(domain, "UTF-8");

			String companyDomainName = ezCommonService.getCompanyConfig(tenantID, companyId, "DomainName");
			
			// 회사별 이메일 도메인명이 설정되어 있으면 해당 도메인명을 기반으로 한 이메일 주소를 함께 전달한다.								
			if (!companyDomainName.isEmpty()) {
				String email = cn + "@" + companyDomainName;
				
				inputParams += "&email=" + URLEncoder.encode(email, "UTF-8");
			}
			
			logger.debug("inputParams=" + inputParams);

			String requestURL = config.getProperty("config.JGwServerURL")
					+ "/jMochaAccess/deleteDistribution";
			String response = ezEmailUtil.getWebServiceResult(requestURL,
					inputParams);

			logger.debug("response=" + response);

			if (response != null) {
				JSONParser jsonParser = new JSONParser();
				JSONObject responseObj = (JSONObject) jsonParser
						.parse(response);

				result = (String) responseObj.get("resultCode");
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		logger.debug("result=" + result);
		logger.debug("mailDelDistributionList ended.");

		return result;
	}

	/**
	 * 메일 기본설정 (관리자) 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezEmail/mailConfigColor.do")
	public String mailConfigColor(
			@CookieValue("loginCookie") String loginCookie, Locale locale,
			Model model, HttpServletRequest request) throws Exception {
		logger.debug("mailConfigColor started.");

		// 관리자 권한체크
		LoginVO auth = commonUtil.checkAdmin(loginCookie);
		if (auth == null) {
			return "cmm/error/adminDenied";
		}

        logger.debug("mailConfigColor ended.");

		return "admin/ezEmail/mailConfigColor";
	}

	/**
	 * 메일 색상설정 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezEmail/mailColor.do")
	public String mailColor(@CookieValue("loginCookie") String loginCookie,
			Locale locale, Model model, HttpServletRequest request)
			throws Exception {
		logger.debug("mailColor started.");

		// 관리자 권한체크
		LoginVO auth = commonUtil.checkAdmin(loginCookie);
		if (auth == null) {
			return "cmm/error/adminDenied";
		}

		String importanceColor = "#ff0000";
		String inColor = "#808080";
		String outColor = "#0080ff";

		try {
			MailColorVO mailColor = null;

			mailColor = ezEmailService.getMailColor(auth.getTenantId());

			if (mailColor != null) {
				importanceColor = mailColor.getImportanceColor();
				inColor = mailColor.getInmailColor();
				outColor = mailColor.getOutmailColor();
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		model.addAttribute("importanceColor", importanceColor);
		model.addAttribute("inColor", inColor);
		model.addAttribute("outColor", outColor);

		logger.debug("importanceColor=" + importanceColor + ",inColor="
				+ inColor + ",outColor=" + outColor);
		logger.debug("mailColor ended.");

		return "admin/ezEmail/mailColor";
	}

	/**
	 * 메일 색상설정 저장 실행 함수
	 */
	@RequestMapping(value = "/admin/ezEmail/mailSaveColor.do")
	@ResponseBody
	public String mailSaveColor(@CookieValue("loginCookie") String loginCookie,
			Locale locale, Model model, @RequestBody String bodyData)
			throws Exception {
		logger.debug("mailSaveColor started.");
		logger.debug("bodyData=" + bodyData);

		// 관리자 권한체크
		LoginVO auth = commonUtil.checkAdmin(loginCookie);
		if (auth == null) {
			return "cmm/error/adminDenied";
		}

		String returnValue = "OK";

		try {
			Document doc = commonUtil.convertStringToDocument(bodyData);
			String importanceColor = doc.getElementsByTagName("IMPORTANCE")
					.item(0).getTextContent();
			String inColor = doc.getElementsByTagName("INCOLOR").item(0)
					.getTextContent();
			String outColor = doc.getElementsByTagName("OUTCOLOR").item(0)
					.getTextContent();

			int tenantId = auth.getTenantId();

			ezEmailService.setMailColor(tenantId, importanceColor, inColor,
					outColor);

		} catch (Exception e) {
			returnValue = "ERROR:" + e.getMessage();
			e.printStackTrace();
		}

		logger.debug("returnValue=" + returnValue);
		logger.debug("mailSaveColor ended.");

		return returnValue;
	}

	/**
	 * 메일 디폴트 Quota (관리자) 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezEmail/mailDefaultQuota.do")
	public String mailDefaultQuota(
			@CookieValue("loginCookie") String loginCookie, Locale locale,
			Model model, HttpServletRequest request) throws Exception {
    	logger.debug("mailDefaultQuota started.");

		// 관리자 권한체크
		LoginVO auth = commonUtil.checkAdmin(loginCookie);

		if (auth == null) {
			return "cmm/error/adminDenied";
		}

		String domainName = ezCommonService.getTenantConfig("DomainName",
				auth.getTenantId());

		Double[] returnedData = ezEmailUtil.getDefaultQuota(domainName);

		model.addAttribute("defaultMax", returnedData[0] / 1024);
		model.addAttribute("defaultWarn", returnedData[1] / 1024);

        logger.debug("mailDefaultQuota ended.");

		return "admin/ezEmail/mailDefaultQuota";
	}

	/**
	 * 메일 디폴트 Quota 설정 함수
	 */
	@RequestMapping(value = "/admin/ezEmail/mailSaveDefaultQuota.do")
	@ResponseBody
	public String mailSaveDefaultQuota(
			@CookieValue("loginCookie") String loginCookie, Locale locale,
			Model model, @RequestBody String bodyData) throws Exception {
    	logger.debug("mailSaveDefaultQuota started.");

		// 관리자 권한체크
		LoginVO auth = commonUtil.checkAdmin(loginCookie);

		if (auth == null) {
			return "Permission Denied";
		}

		String returnValue = "True";

		try {
			String domainName = ezCommonService.getTenantConfig("DomainName",
					auth.getTenantId());

			Document doc = commonUtil.convertStringToDocument(bodyData);
			String maxStorage = doc.getElementsByTagName("MAXSTORAGE").item(0)
					.getTextContent();
			String warnStorage = doc.getElementsByTagName("WARNSTORAGE")
					.item(0).getTextContent();

			ezEmailUtil.setDefaultQuota(domainName, maxStorage, warnStorage);
		} catch (Exception e) {
			e.printStackTrace();

			returnValue = "ERROR";
		}

        logger.debug("mailSaveDefaultQuota ended.");

		return returnValue;
	}

	/**
	 * 회원별 메일함 사용용량 및 총용량
	 */

	@RequestMapping(value = "/admin/ezEmail/mailQuotaList.do")
	public String statisticsList_view(@CookieValue("loginCookie")String loginCookie, Model model) throws Exception {
		
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		String companyId = userInfo.getCompanyID();
		List<OrganDeptVO> list = ezOrganAdminService.getCompanyList(userInfo.getPrimary(), userInfo.getTenantId());
		List<OrganDeptVO> resultList = new ArrayList<OrganDeptVO>();
		int j = 0;
		
		for (int i = 0; i < list.size(); i++) {
			OrganDeptVO vo = list.get(i);			

			if (userInfo.getRollInfo().indexOf("c=1") > -1 || vo.getCn().equals(companyId)) {
				resultList.add(j++, vo);
			}
		}
		
		model.addAttribute("list", resultList);
		model.addAttribute("companyId", companyId);
		
		return "/admin/ezEmail/mailQuotaList";
	}

	@RequestMapping(value = "/admin/ezEmail/statistics_userList.do")
	public String statisticsList( @CookieValue("loginCookie") String loginCookie, Model model,
								  HttpServletRequest req,@RequestParam(required = false) String searchKeycode, 
								  @RequestParam(required = false) String searchKeyword) throws Exception {

		logger.debug("started statisticsList controller.");

		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		String companyId = req.getParameter("companyId");
		String currPage = req.getParameter("pageNum");
		
		if (currPage == null || currPage.equals("")) {
			currPage = "1";
		}

		int maxItemPerPage = 20; 
		int currentPage = Integer.parseInt(currPage);
		int startRow = (Integer.parseInt(currPage) - 1) * maxItemPerPage;
		
		if (currPage.equals("-1")) {
			startRow = -1;
		}
		
		int dbName = globals.getProperty("Globals.DbType").equals("mysql") ? 1 : 2;
   		searchKeyword = commonUtil.getWildcardEscapedString(searchKeyword, dbName);
   		
		int itemCnt = ezOrganAdminService.getUserCount(userInfo.getTenantId(), searchKeycode, searchKeyword, companyId);

		int totalPage = itemCnt / maxItemPerPage;

		if (itemCnt < 1) {
			totalPage = 1;
		}

		if ((totalPage * maxItemPerPage) != itemCnt && (itemCnt % maxItemPerPage) != 0) {
			totalPage = totalPage + 1;
		}

		currentPage = Math.min(currentPage, totalPage);

		List<ArrayList<String>> userList = new ArrayList<ArrayList<String>>();
		
		// 모든 사용자의 목록을 가져온다.
		List<OrganUserVO> userCnList = ezOrganAdminService.getUserList(userInfo.getTenantId(), startRow, 
									    maxItemPerPage, searchKeycode, searchKeyword, companyId);
		
		IMAPAccess ia = null;
		Locale locale = Locale.getDefault();
		String password = jspw;
		String domain = ezCommonService.getTenantConfig("DomainName",userInfo.getTenantId());
		String mailServerAddress = config.getProperty("config.MailServerAddress");
		String iMAPPort = config.getProperty("config.IMAPPort");
		
		// 각 사용자별로 처리한다.
		for (OrganUserVO organUser : userCnList) {				
			List<String> quaList = new ArrayList<String>();
			String userId = organUser.getCn();
			String department = organUser.getDescription();
			String displayname = organUser.getDisplayName();
			displayname = displayname + "(" + userId + ")";		
			
			quaList.add(0, userId);
			quaList.add(1, displayname);
			quaList.add(2, department);

			try {
				String email = userId + "@" + domain;
				logger.debug("email=" + email);
				
				ia = IMAPAccess.getInstance(mailServerAddress, iMAPPort, email, password, egovMessageSource, locale, ezEmailUtil);
	
				long[] storageUsageAndLimit = ia.getStorageUsageAndLimit();
	
				// 사용자의 현재 메일박스 스토리지 사용량과 쿼터(최대 할당량)을 구한다.
				long mailboxUsage = storageUsageAndLimit[0]; // KBs
				long mailboxQuota = storageUsageAndLimit[1]; // KBs
			
				quaList.add(3, String.valueOf(mailboxUsage));
				quaList.add(4, String.valueOf(mailboxQuota));
				userList.add((ArrayList<String>) quaList);
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                if (ia != null) {
                    ia.close();
                }
            }
		}

		model.addAttribute("userList", userList);
		model.addAttribute("currPage", currentPage);
		model.addAttribute("totalPage", totalPage);
		model.addAttribute("itemCnt", itemCnt);
		model.addAttribute("searchKeyword", searchKeyword);
		model.addAttribute("searchKeycode", searchKeycode);

		logger.debug("ended statisticsList controller.");

		return "json";
	}

	/**
	 * 엑셀 워크시트 생성 및 자동 다운로드 함수
	 */
	@SuppressWarnings("static-access")
	@RequestMapping(value = "/admin/ezEmail/statisticsListExcelExport.do")
	public void MailQuotaExcelExport(@CookieValue("loginCookie") String loginCookie,Model model,
			  						 HttpServletRequest request,String searchKeycode,String searchKeyword,
			  						 HttpServletResponse response)throws Exception {
		
		logger.debug("MailQuotaExcelExport controller started.");

		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		String companyId = request.getParameter("companyId");
		String currPage = request.getParameter("pageNum");

		int maxItemPerPage = 20;
		int startRow = (Integer.parseInt(currPage) - 1) * maxItemPerPage;
		
		if (currPage.equals("-1")) {
			startRow = -1;
		}
		
		int dbName = globals.getProperty("Globals.DbType").equals("mysql") ? 1 : 2;
   		searchKeyword = commonUtil.getWildcardEscapedString(searchKeyword, dbName);

		// 모든 사용자의 목록을 가져온다.
		List<OrganUserVO> userCnList = ezOrganAdminService.getUserList(Integer.valueOf(userInfo.getTenantId()), 
									   startRow, maxItemPerPage, searchKeycode, searchKeyword, companyId);
		
		int totalCount = ezOrganAdminService.getUserCount(userInfo.getTenantId(), searchKeycode, searchKeyword, companyId);
		
		List<ArrayList<String>> userList = new ArrayList<ArrayList<String>>();

		IMAPAccess ia = null;
		Locale locale = Locale.getDefault();
		String password = jspw;
		String domain = ezCommonService.getTenantConfig("DomainName",userInfo.getTenantId());
		String mailServerAddress = config.getProperty("config.MailServerAddress");
		String iMAPPort = config.getProperty("config.IMAPPort");
		
		// 각 사용자별로 처리한다.
		for (OrganUserVO organUser : userCnList) {
			List<String> quaList = new ArrayList<String>();
			String userId = organUser.getCn();
			String department = organUser.getDescription();
			String displayname = organUser.getDisplayName();
			displayname = displayname + "(" + userId + ")";	
				
			quaList.add(0, userId);
			quaList.add(1, displayname);
			quaList.add(2, department);
				
			try {
				String email = userId + "@" + domain;
				
				ia = IMAPAccess.getInstance(mailServerAddress, iMAPPort, email, password, egovMessageSource, locale, ezEmailUtil);

				long[] storageUsageAndLimit = ia.getStorageUsageAndLimit();
	
				// 사용자의 현재 메일박스 스토리지 사용량과 쿼터(최대 할당량)을 구한다.
				long mailboxUsage = storageUsageAndLimit[0]/1024; // KBs to MB
				long mailboxQuota = storageUsageAndLimit[1]/1024; // KBs to MB
					
				quaList.add(3, String.valueOf(mailboxUsage));
				quaList.add(4, String.valueOf(mailboxQuota));
				userList.add((ArrayList<String>) quaList);
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				if (ia != null) {
					ia.close();
				}
			}
		}
		
		/* 엑셀 만들기 */
		HSSFWorkbook workbook = new HSSFWorkbook();
		HSSFSheet sheet = workbook.createSheet("MailQuotaList");
			
		Row row = null;
		Cell cell = null;
	
		String fileName = "";
		fileName = "MailQuotaList";
	
		HSSFCellStyle headerStyle = workbook.createCellStyle();
		headerStyle.setFillForegroundColor(HSSFColor.GREY_25_PERCENT.index);
		headerStyle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
		headerStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
		headerStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
		headerStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
		headerStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
		headerStyle.setVerticalAlignment((short) 1);
			
		HSSFCellStyle bodyStyle = workbook.createCellStyle();
		bodyStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
		bodyStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
		bodyStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
		bodyStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
	
		HSSFFont font = workbook.createFont();
		font.setBoldweight((short) font.BOLDWEIGHT_BOLD);
		headerStyle.setFont(font);

		row = sheet.createRow(0);
		cell = row.createCell(0);
		cell.setCellValue(egovMessageSource.getMessage("main.t252") + " " + totalCount + 
						  egovMessageSource.getMessage("ezSystem.kyj2"));
	
		row = sheet.createRow(1);
		cell = row.createCell(0);
		cell.setCellValue(egovMessageSource.getMessage("ezEmail.lsd04"));
		cell.setCellStyle(headerStyle);
		cell = row.createCell(1);
		cell.setCellValue(egovMessageSource.getMessage("ezStatistics.t113"));
		cell.setCellStyle(headerStyle);
		cell = row.createCell(2);
		cell.setCellValue(egovMessageSource.getMessage("ezEmail.lsd02"));
		cell.setCellStyle(headerStyle);
		cell = row.createCell(3);
		cell.setCellValue(egovMessageSource.getMessage("ezEmail.lsd03"));
		cell.setCellStyle(headerStyle);
	
		for (int i = 2; i < userList.size() + 2; i++) {
			row = sheet.createRow(i);
			row.setHeight((short) 300);
			int j = 2;
			cell = row.createCell(0);
			cell.setCellValue((String) userList.get(i - j).get(1));
			cell.setCellStyle(bodyStyle);
			cell = row.createCell(1);
			cell.setCellValue((String) userList.get(i - j).get(2));
			cell.setCellStyle(bodyStyle);
			cell = row.createCell(2);
			cell.setCellValue((String) userList.get(i - j).get(3));
			cell.setCellStyle(bodyStyle);
			cell = row.createCell(3);
			cell.setCellValue((String) userList.get(i - j).get(4));
			cell.setCellStyle(bodyStyle);
	
		}
		
		for (int i = 0; i < 4; i++) {
			sheet.autoSizeColumn(i);
		}
		
		response.setCharacterEncoding("UTF-8");
		response.setHeader("Content-Disposition", "attachment; fileName=" + fileName + ".xls");
		response.setContentType("application/vnd.ms-excel");
	
		workbook.write(response.getOutputStream());
		workbook.close();
	
		logger.debug("MailQuotaExcelExport controller ended.");
	}
	
	/**
	 * 공유사서함관리 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezEmail/showSharedMailboxList.do")
	public String showSharedMailboxList(
			@CookieValue("loginCookie") String loginCookie, Locale locale,
			Model model, HttpServletRequest request) throws Exception {
		logger.debug("showSharedMailboxList started.");

		// 관리자 권한체크
		LoginVO auth = commonUtil.checkAdmin(loginCookie);
		if (auth == null) {
			return "cmm/error/adminDenied";
		}

		List<OrganDeptVO> list = ezOrganAdminService.getCompanyList(auth.getPrimary(), auth.getTenantId());
		List<OrganDeptVO> resultList = new ArrayList<OrganDeptVO>();
		
		for (int i = 0 ; i < list.size(); i++) {
			OrganDeptVO vo = list.get(i);
			
			if (auth.getRollInfo().indexOf("c=1") > -1 || vo.getCn().equals(auth.getCompanyID())) {
				resultList.add(vo);
			}
		}
		
		model.addAttribute("list", resultList);
		model.addAttribute("userCompany", auth.getCompanyID());
		model.addAttribute("useOcs", config.getProperty("config.USE_OCS"));
		
		logger.debug("showSharedMailboxList ended.");

		return "admin/ezEmail/sharedMailboxList";
	}
	
	/**
	 * 회사별 공유사서함 리스트 호출 함수
	 */
	@RequestMapping(value = "/admin/ezEmail/getSharedMailboxList.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getSharedMailboxList(@CookieValue("loginCookie") String loginCookie, Locale locale, HttpServletRequest request, Model model) throws Exception {
		logger.debug("getSharedMailboxList started.");
		
		String returnData = "";
		
		try {
			// 관리자 권한체크
			LoginVO auth = commonUtil.checkAdmin(loginCookie);
			
			if (auth == null) {
				returnData = "NO_PERMISSION";
				logger.debug("getSharedMailboxInfo ended. returnData=" + returnData);
				
				return returnData;
			}
			
			String userId = auth.getId();
			String compId = request.getParameter("compId");
			int tenantId = auth.getTenantId();
			logger.debug("userId=" + userId + ",compId=" + compId + ",tenantId=" + tenantId);
			
			List<MailSharedMailboxVO> sharedMailboxList = ezEmailService.getSharedMailboxList(compId, auth.getTenantId());
			logger.debug("sharedMailboxList size=" + sharedMailboxList.size());
			
			StringBuilder sb = new StringBuilder();
			sb.append("<LISTVIEWDATA><ROWS>");

			for (MailSharedMailboxVO vo : sharedMailboxList) {
				sb.append("<ROW><CELL>");

				sb.append("<VALUE>");
				sb.append(commonUtil.cleanValue(vo.getShareName()));
				sb.append("</VALUE>");

				sb.append("<DATA1>");
				sb.append(commonUtil.cleanValue(vo.getShareId()));
				sb.append("</DATA1>");

				sb.append("</CELL></ROW>");
			}

			sb.append("</ROWS></LISTVIEWDATA>");
			
			returnData = sb.toString();
		} catch (Exception e) {
			returnData = "ERROR";
			e.printStackTrace();
		}

		logger.debug("getSharedMailboxList ended.");
		return returnData;
	}
	
	/**
	 * 공유사서함 정보 호출 함수
	 */
	@RequestMapping(value = "/admin/ezEmail/getSharedMailboxInfo.do")
	public String getSharedMailboxInfo(@CookieValue("loginCookie") String loginCookie, Locale locale, HttpServletRequest request, Model model) throws Exception {
		logger.debug("getSharedMailboxInfo started.");

		String resultCode = "OK";

		try {
			// 관리자 권한체크
			LoginVO auth = commonUtil.checkAdmin(loginCookie);
			
			if (auth == null) {
				model.addAttribute("resultCode", "NO_PERMISSION");
				logger.debug("getSharedMailboxInfo ended.");
				return "json";
			}
			
			String userId = auth.getId();
			String shareId = request.getParameter("shareId");
			int tenantId = auth.getTenantId();
			logger.debug("userId=" + userId + ",shareId=" + shareId + ",tenantId=" + tenantId);
			
			MailSharedMailboxVO sharedMailboxInfo = ezEmailService.getSharedMailboxInfo(shareId, auth.getTenantId());
			
			model.addAttribute("sharedMailboxInfo", sharedMailboxInfo);
		} catch (Exception e) {
			resultCode = "ERROR";
			e.printStackTrace();
		}

		model.addAttribute("resultCode", resultCode);
		
		logger.debug("getSharedMailboxInfo ended.");
		return "json";
	}
	

	/**
	 * 공유사서함 삭제 실행 함수
	 */
	@RequestMapping(value = "/admin/ezEmail/delSharedMailbox.do")
	public String delSharedMailbox(@CookieValue("loginCookie") String loginCookie, Locale locale, HttpServletRequest request, Model model) throws Exception {
		logger.debug("delSharedMailbox started.");
		
		String resultCode = "OK";
		
		try {
			// 관리자 권한체크
			LoginVO auth = commonUtil.checkAdmin(loginCookie);
			
			if (auth == null) {
				resultCode = "NO_PERMISSION";
				model.addAttribute("resultCode", resultCode);
				logger.debug("delSharedMailbox ended. resultCode=" + resultCode);
				
				return "json";
			}
			
			String shareId = request.getParameter("shareId");
			int tenantId = auth.getTenantId();
			String domain = ezCommonService.getTenantConfig("DomainName", tenantId);
			String mailAddr = shareId + "@" + domain;
	        logger.debug("shareId=" + shareId + ",tenantId=" + tenantId + ",mailAddr=" + mailAddr);
			
	        // 해당 공유사서함의 공유자를 모두 제거한다.
			String delResult =  ezEmailService.delSharedMailboxAllUser(shareId, tenantId);
	        
			if (!delResult.equals("OK")) {
				logger.debug("delSharedMailboxAllUser failed.");
				
				resultCode = "EMAIL_ERROR";
				model.addAttribute("resultCode", resultCode);
				logger.debug("delSharedMailbox ended. resultCode=" + resultCode);
				
				return "json";
			}
			
			// 이메일 계정이 있는 지 확인한다.
			int userExists = ezEmailUserAdminService.checkUserExists(mailAddr);
			int rc = 0;
			
			logger.debug("userExists=" + userExists);
			
			if (userExists == 0) { // 이메일 계정이 존재하지 않음.
				// 로컬 시스템 계정을 삭제한다.
				ezOrganAdminService.deleteDBData(shareId, "user", tenantId);
			} else if (userExists == 1 || userExists == 2) { // 1은 유효한 이메일 계정. 2는 퇴직자 계정.
				List<String> distributionList = null;
				String groupAddr = null;
				
				if (userExists == 1) { // 유효한 이메일 계정이 존재함.						
					// 먼저 퇴직자 처리를 수행한다. 로컬 계정 삭제가 실패할 경우 복구를 위해.
					rc = ezEmailUserAdminService.retireUser(mailAddr);
					logger.debug("retireUser rc=" + rc);
					
					if (rc == 0) {
						// 사용자가 속한 부서의 Group Email 주소를 구한다.
						OrganUserVO userVO = ezOrganAdminService.getUserInfo(shareId, auth.getPrimary(), tenantId);
						groupAddr = userVO.getDepartment() + "@" + domain;
						
						// 부서의 Group Email 주소로부터 해당 User를 제거한다.
						rc = ezEmailUserAdminService.updateGroupDel(groupAddr, mailAddr);
						logger.debug("updateGroupDel rc=" + rc);
						
						if (rc == -100) { // Group Email 주소에서 제거 실패함.(부모(그룹)나 자식(유저)를 찾지 못한 경우는 성공으로 취급함)
							ezEmailUserAdminService.restoreUser(mailAddr);
							logger.debug("removing the user '" + mailAddr + "' from its group email failed.");
							
							resultCode = "EMAIL_ERROR";
							model.addAttribute("resultCode", resultCode);
							logger.debug("delSharedMailbox ended. resultCode=" + resultCode);
							
							return "json";
						}
						
						// 사용자가 속한 공용배포그룹의 Group Email 주소 목록을 구한다.
						distributionList = ezEmailUserAdminService.getUserDistributionList(mailAddr);
						
						for (String dist : distributionList) {
							logger.debug("dist=" + dist);
							
							// 공용배포그룹의 Group Email 주소로부터 해당 User를 제거한다.
							rc = ezEmailUserAdminService.updateGroupDel(dist, mailAddr);	
							
							logger.debug("updateGroupDel rc=" + rc);							
						}						
					} else {
						logger.debug("retiring the user '" + mailAddr + "' failed.");
						
						resultCode = "EMAIL_ERROR";
						model.addAttribute("resultCode", resultCode);
						logger.debug("delSharedMailbox ended. resultCode=" + resultCode);
						
						return "json";
					}
				}
							
				String bizmekaResult = "ERROR";
				
				try {
					String useBizmekaSpambox = ezCommonService.getTenantConfig("UseBizmekaSpambox", tenantId);
					
					// 비즈메카와 연동된 경우에는 비즈메카 API를 이용해 비즈메카 사용자 계정을 삭제한다.
					if (useBizmekaSpambox.equals("YES")) {
						String bizmekaAdminId = ezCommonService.getTenantConfig("bizmekaAdminId", tenantId);
						String bizmekaAdminPw = ezCommonService.getTenantConfig("bizmekaAdminPw", tenantId);
						String bizmekaCompanyId = ezCommonService.getTenantConfig("BizmekaCompanyId", tenantId);
						
						bizmekaResult = ezEmailUtil.bizmekaDeleteUser(bizmekaAdminId, bizmekaAdminPw, bizmekaCompanyId, shareId);		
						
						logger.debug("bizmekaResult=" + bizmekaResult);
						
						if (!bizmekaResult.equals("OK")) {
							throw new Exception("bizmekaDeleteUser failed");
						}						
					}
										
					// 로컬 시스템 계정을 삭제한다.
					ezOrganAdminService.deleteDBData(shareId, "user", tenantId);
				} catch (Exception e) {
					if (userExists == 1) { // 유효한 이메일 계정이었으면 복구 처리를 수행한다.
						if (distributionList != null) {
							for (String dist : distributionList) {
								logger.debug("dist=" + dist);
								
								// 공용배포그룹의 Group Email 주소에 해당 User를 추가한다.
								rc = ezEmailUserAdminService.updateGroupAdd(dist, mailAddr);	
								logger.debug("updateGroupAdd rc=" + rc);							
							}													
						}
						
						ezEmailUserAdminService.updateGroupAdd(groupAddr, mailAddr);
						ezEmailUserAdminService.restoreUser(mailAddr);							
					}
					
					resultCode = "EMAIL_ERROR";
					model.addAttribute("resultCode", resultCode);
					logger.debug("delSharedMailbox ended. resultCode=" + resultCode);
					
					return "json";
				}
				
				// 아래 과정에서 에러가 발생하면 복구할 수는 없지만, 이미 유효한 계정이 아니므로
				// 저장 공간은 차지하지만 해당 계정이 사용되지는 않는다. 
				
				// 퇴직자 계정을 삭제한다.
				ezEmailUserAdminService.removeUser(mailAddr);
				
				// 해당 사용자의 메일박스들을 모두 제거한다.
				ezEmailUserAdminService.removeUserAllMailboxes(mailAddr);
				
				// 해당 사용자의 개인주소록 및 주소록 관련 설정을 모두 제거한다.
				ezAddressService.removeUserAddress(mailAddr);
			}
		
		} catch (Exception e) {
			resultCode = "ERROR";
			e.printStackTrace();
		}
		
		model.addAttribute("resultCode", resultCode);
		
		logger.debug("delSharedMailbox ended. resultCode=" + resultCode);
		return "json";
	}
}
