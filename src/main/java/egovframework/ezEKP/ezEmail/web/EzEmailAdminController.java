package egovframework.ezEKP.ezEmail.web;

import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;
import java.util.UUID;

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
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.w3c.dom.Document;
import org.w3c.dom.NodeList;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.logic.IMAPAccess;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezEmail.util.EzEmailUtil;
import egovframework.ezEKP.ezEmail.vo.MailColorVO;
import egovframework.ezEKP.ezEmail.vo.MailDistributionVO;
import egovframework.ezEKP.ezEmail.vo.MailLetterBoxVO;
import egovframework.ezEKP.ezEmail.vo.MailSignatureTemplateVO;
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
	 * 서명 템플릿 메인화면 호출 함수
	 * 
	 * @param String loginCookie, Model model
	 * @return String
	 */
	@RequestMapping(value = "/admin/ezEmail/signatureMain.do")
	public String signatureMainView(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("signatureMainView started.");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		List<OrganDeptVO> list = ezOrganAdminService.getCompanyList(userInfo.getPrimary(), userInfo.getTenantId());
		List<OrganDeptVO> resultList = new ArrayList<OrganDeptVO>();

		for (int i = 0; i < list.size(); i++) {
			OrganDeptVO vo = list.get(i);

			if (userInfo.getRollInfo().contains("k=1") && vo.getCn().equals(userInfo.getCompanyID())) {
				resultList.add(vo);
			}

		}

		model.addAttribute("list", resultList);

		logger.debug("signatureMainView ended.");

		return "admin/ezEmail/signatureMain";

	}
	
	/**
	 * 서명 템플릿 목록 조회
	 * 
	 * @param companyId
	 * @return : JSONArray
	 */
	@RequestMapping("/admin/ezEmail/readSignList.do")
	@ResponseBody
	public JSONArray readSignList(@CookieValue("loginCookie") String loginCookie, String companyId, HttpServletResponse response, Model model) throws Exception {
		logger.debug("readSignList started.");
		logger.debug("companyId=" + companyId);
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		JSONArray returnJsonArr = new JSONArray();

		try {
			returnJsonArr = ezEmailService.selectAllSignatureTemplate(companyId, Integer.toString(userInfo.getTenantId()));
			logger.debug("jsonArr=" + returnJsonArr);
		} catch (Exception e) {
			// e.printStackTrace();
		}
		
		logger.debug("readSignList ended.");
		return returnJsonArr;
	}
	
	/**
	 * 서명 템플릿 목록 검색
	 * 
	 * @param companyId, search
	 * @return : JSONArray
	 */
	@RequestMapping("/admin/ezEmail/searchSignList.do")
	@ResponseBody
	public JSONArray searchSignList(@CookieValue("loginCookie") String loginCookie, String companyId, String search, HttpServletResponse response, Model model) throws Exception {
		logger.debug("searchSignList started.");
		logger.debug("companyId=" + companyId);
		logger.debug("search=" + search);
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		JSONArray returnJsonArr = new JSONArray();

		try {
			returnJsonArr = ezEmailService.selectSearchSignatureTemplate(companyId, Integer.toString(userInfo.getTenantId()), search);
			logger.debug("jsonArr=" + returnJsonArr);
		} catch (Exception e) {
			// e.printStackTrace();
		}
		
		logger.debug("searchSignList ended.");
		return returnJsonArr;
	}
	
	/**
	 * 서명 템플릿 삭제
	 * 
	 * @param companyId, signNo
	 * @return : void
	 */
	@RequestMapping("/admin/ezEmail/deleteSignTemplate.do")
	@ResponseBody
	public void deleteSignTemplate(@CookieValue("loginCookie") String loginCookie, String signNo, HttpServletResponse response, Model model) throws Exception {
		logger.debug("deleteSignTemplate started.");
		logger.debug("signNo=" + signNo);

		try {
			ezEmailService.deleteSignatureTemplate(signNo);
		} catch (Exception e) {
			 e.printStackTrace();
		}
		
		logger.debug("deleteSignTemplate ended.");
	}
	
	/**
	 * 서명 템플릿 개별 조회
	 * 
	 * @param companyId, signNo
	 * @return : void
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping("/admin/ezEmail/signaturePreview.do")
	@ResponseBody
	public JSONArray signaturePreview(@CookieValue("loginCookie") String loginCookie, String signNo, HttpServletResponse response, Model model) throws Exception {
		logger.debug("signaturePreview started.");
		logger.debug("signNo=" + signNo);
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		OrganUserVO vo = ezOrganAdminService.getUserInfo(userInfo.getId(), "1", userInfo.getTenantId());
		String content = "";

		JSONArray returnJsonArr = new JSONArray();

		try {
			
			returnJsonArr = ezEmailService.selectOneSignatureTemplate(signNo);
			JSONObject obj = (JSONObject) returnJsonArr.get(0);
			content = obj.get("content").toString();
			content = replaceUserInfo(vo, content);
			
			JSONObject newObj = new JSONObject();
			
			// content replace 메소드 후 리턴
			newObj.put("signNo", obj.get("signNo").toString());
			newObj.put("content", content);
			newObj.put("displayname", obj.get("displayname").toString());
			newObj.put("displayname2", obj.get("displayname2").toString());
			
			returnJsonArr = new JSONArray();
			returnJsonArr.add(newObj);
			
			
			logger.debug("jsonArr=" + returnJsonArr);
		} catch (Exception e) {
			// e.printStackTrace();
		}
		
		logger.debug("signaturePreview ended.");
		return returnJsonArr;
	}
	
	/**
	 * 서명 템플릿 추가,수정 팝업 화면
	 */
	@RequestMapping("/admin/ezEmail/signEditPopUp.do")
	public String signEditPopUp(
			@CookieValue("loginCookie") String loginCookie, Locale locale, String paramSignNo, String type, Model model) throws Exception {
		logger.debug("signEditPopUp started.");
		logger.debug("signNo=" + paramSignNo + ", type=" + type);
		
		String signNo = "";
		String content = "";
		String displayname = "";
		String displayname2 = "";
		String defaultFontAndSize = "style='font-size:13px;font-family:" + egovMessageSource.getMessage("main.t246", locale) + "'";
        logger.debug("defaultFontAndSize=" + defaultFontAndSize);
        
		// 관리자 권한체크
		LoginVO auth = commonUtil.checkAdmin(loginCookie);
		if (auth == null) {
			return "cmm/error/adminDenied";
		}
		
		if (type.equals("modify")) { 
			JSONArray returnJsonArr = new JSONArray();
			
			try {
				returnJsonArr = ezEmailService.selectOneSignatureTemplate(paramSignNo);
				logger.debug("jsonArr=" + returnJsonArr);
				
				JSONObject obj = (JSONObject) returnJsonArr.get(0);
				signNo = obj.get("signNo").toString();
				content = obj.get("content").toString();
				displayname = obj.get("displayname").toString();
				displayname2 = obj.get("displayname2").toString();
				
			} catch (Exception e) {
				// e.printStackTrace();
			}
		} 
		model.addAttribute("defaultFontAndSize", defaultFontAndSize);
		model.addAttribute("signNo", signNo);
		model.addAttribute("content", content);
		model.addAttribute("displayname", displayname);
		model.addAttribute("displayname2", displayname2);
		model.addAttribute("type", type);

		logger.debug("signNo=" + signNo + ", content=" + content + ", displayname=" + displayname + ", displayname2=" + displayname2);
		logger.debug("signEditPopUp ended.");
		return "admin/ezEmail/signatureEditPopUp";
	}
	
	/**
	 * 서명 템플릿 추가
	 * 
	 * @param String loginCookie, Model model
	 */
	@RequestMapping(value = "/admin/ezEmail/setSignatureTemplate.do")
	@ResponseBody
	public void setSignatureTemplate(@CookieValue("loginCookie") String loginCookie, @ModelAttribute MailSignatureTemplateVO signTemplate, String type) throws Exception {
		logger.debug("setSignatureTemplate started.");
		logger.debug("signTemplate=" + signTemplate);
		logger.debug("type=" + type);
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		try {
			if (type.equals("add")) {
				signTemplate.setCompanyId(userInfo.getCompanyID());
				signTemplate.setTenantId(Integer.toString(userInfo.getTenantId()));
				ezEmailService.addSignatureTemplate(signTemplate);
			} else {
				ezEmailService.setSignatureTemplate(signTemplate);
			}
			
		} catch (Exception e) {
			 e.printStackTrace();
		}

		logger.debug("setSignatureTemplate ended.");

	}
	
	/**
	 * 서명 템플릿 미리보기
	 * 
	 * @param String loginCookie, Model model
	 */
	@RequestMapping(value = "/admin/ezEmail/signaturePreviewContent.do")
	public String signaturePreviewContent(@CookieValue("loginCookie") String loginCookie, Model model, String content) throws Exception {
		logger.debug("signaturePreviewContent started.");
		logger.debug("content=" + content);
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		OrganUserVO vo = ezOrganAdminService.getUserInfo(userInfo.getId(), "1", userInfo.getTenantId());
		content = replaceUserInfo(vo, content);
		
		model.addAttribute("content", content);

		logger.debug("signaturePreviewContent ended.");
		return "admin/ezEmail/signaturePreview";

	}
	
	private String replaceUserInfo(OrganUserVO _vo, String content) {
		content = content.replace("${company}", _vo.getCompany1()).replace("${engCompany}", _vo.getCompany2()).replace("${name}", _vo.getDisplayName1()).replace("${engName}", _vo.getDisplayName2())
				.replace("${department}", _vo.getDescription1()).replace("${email}", _vo.getMail()).replace("${title}", _vo.getTitle1() == null ? "" : _vo.getTitle1())
				.replace("${position}", _vo.getExtensionAttribute101() == null ? "" : _vo.getExtensionAttribute101()).replace("${officePhone}", _vo.getTelephoneNumber() == null ? "" : _vo.getTelephoneNumber())
				.replace("${homePhone}", _vo.getHomePhone() == null ? "" : _vo.getHomePhone()).replace("${fax}", _vo.getFacsimileTelephoneNumber() == null ? "" : _vo.getFacsimileTelephoneNumber())
				.replace("${mobile}", _vo.getMobile() == null ? "" : _vo.getMobile()).replace("${zipCode}", _vo.getPostalCode() == null ? "" : _vo.getPostalCode()).replace("${address}", _vo.getStreetAddress() == null ? "" : _vo.getStreetAddress())
				.replace("${birth}", _vo.getBirth() == null ? "" : _vo.getBirth()).replace("${empNo}", _vo.getExtensionAttribute14() == null ? "" : _vo.getExtensionAttribute14());
	
		return content;
	}
	
}
