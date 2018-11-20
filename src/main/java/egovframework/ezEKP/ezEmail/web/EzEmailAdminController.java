package egovframework.ezEKP.ezEmail.web;

import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;
import java.util.TimeZone;
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
import org.apache.poi.ss.usermodel.Row;
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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.w3c.dom.Document;
import org.w3c.dom.NodeList;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezAddress.service.EzAddressService;
import egovframework.ezEKP.ezAddress.vo.AddressVO;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.logic.IMAPAccess;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezEmail.service.EzEmailUserAdminService;
import egovframework.ezEKP.ezEmail.util.EzEmailUtil;
import egovframework.ezEKP.ezEmail.vo.MailColorVO;
import egovframework.ezEKP.ezEmail.vo.MailDistributionVO;
import egovframework.ezEKP.ezEmail.vo.MailSharedMailboxVO;
import egovframework.ezEKP.ezEmail.vo.MailLetterBoxVO;
import egovframework.ezEKP.ezEmail.vo.MailSignatureTemplateVO;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.let.user.login.vo.LoginVO;
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
	
	@Autowired
	private EzAddressService ezAddressService;

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
				List<MailDistributionVO> distributionUpperList = ezEmailService
						.getDistributioUpperList(cn, auth.getTenantId());
				
				int totalSzie = distributionTotalList.size();
				
				logger.debug("totalSzie=" + totalSzie);
				
				//공용배포그룹 전체 리스트에서 자기 자신 제외
				for (int i = totalSzie - 1 ; i >= 0; i--) {
					String totalId = distributionTotalList.get(i).getId();
					
					if (totalId.equals(cn)) {
						distributionTotalList.remove(i);
					}
					
				}
				
				totalSzie = distributionTotalList.size();
				int upperSize = distributionUpperList.size();
				
				logger.debug("totalSzie=" + totalSzie + ",upperSize=" + upperSize);
				
				//공용배포그룹에서 자기를 포함하는 공용배포그룹 제외
				for (int i = totalSzie - 1 ; i >= 0; i--) {
					String totalId = distributionTotalList.get(i).getId();
					
					for (int j = upperSize - 1; j >= 0; j--) {
						String upperId = distributionUpperList.get(j).getId();
						
						if (totalId.equals(upperId)) {
							distributionTotalList.remove(i);
						}
						
					}
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
		NodeList addressIdList = doc.getElementsByTagName("ADDRESSID");
		NodeList addressNameList = doc.getElementsByTagName("ADDRESSNAME");
		NodeList addressMailList = doc.getElementsByTagName("ADDRESSMAIL");
		NodeList addressTypeList = doc.getElementsByTagName("ADDRESSTYPE");
		NodeList directMailList = doc.getElementsByTagName("DIRECTMAIL");
		NodeList directNameList = doc.getElementsByTagName("DIRECTNAME");

		int tenantID = auth.getTenantId();
		String domain = ezCommonService.getTenantConfig("DomainName", tenantID);
		
		int reasonCode = -100;
		String result = "ERROR";
		String bizmekaResult = "ERROR";
		String inputParams = "";
		String requestURL = "";
		String response = "";
		List<Map<String,String>> distributionSubList = null;
		AddressVO addressInfo = null;
		Map<String,String> distributionSubMap = null;
				
		try {
			String companyDomainName = ezCommonService.getCompanyConfig(tenantID, companyId, "DomainName");			
			String useBizmekaSpambox = ezCommonService.getTenantConfig(
					"UseBizmekaSpambox", tenantID);

			distributionSubList = new ArrayList<Map<String,String>>();
			
			//주소록 distributionSubList에 추가
			for (int i = 0; i < addressTypeList.getLength(); i++) {
				String addressType = addressTypeList.item(i).getTextContent();
				
				//주소록 타입이 그룹일 경우
				if (addressType.equals("MAILGROUP")) {
					addressInfo =  ezAddressService.getAddressInfo(tenantID, auth.getPrimary(), addressIdList.item(i).getTextContent());
					String address = addressInfo.getsMemo();
				
					if (address != null && !address.trim().equals("")) {
						String[] addressRows = address.split(";");
						
						for (String addr : addressRows) {
							distributionSubMap = new HashMap<String, String>();
							String[] subRows = addr.split("<");
							String subName = subRows[0].replaceAll("\"", "");
							
							distributionSubMap.put("subName", subName);
							distributionSubMap.put("subEmail", subRows[1].substring(0, subRows[1].length() -1));
							distributionSubList.add(distributionSubMap);
						}
					}					
				} else if (addressType.equals("MAIL")) {
					distributionSubMap = new HashMap<String, String>();
					distributionSubMap.put("subName", addressNameList.item(i).getTextContent());
					distributionSubMap.put("subEmail", addressMailList.item(i).getTextContent());
					distributionSubList.add(distributionSubMap);
				}
			}
			
			//직접 입력 한 이름 distributionSubList에 추가
			for (int i = 0; i < directMailList.getLength(); i++) {
				if (directNameList.getLength() > 0) {
					distributionSubMap = new HashMap<String, String>();
					distributionSubMap.put("subName", directNameList.item(i).getTextContent());
					distributionSubMap.put("subEmail", directMailList.item(i).getTextContent());
					distributionSubList.add(distributionSubMap);
				}
			}
			
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
							
				inputParams = "companyId="
						+ URLEncoder.encode(companyId, "UTF-8") + "&name="
						+ URLEncoder.encode(name, "UTF-8") + "&id="
						+ URLEncoder.encode(id, "UTF-8") + "&domain="
						+ URLEncoder.encode(domain, "UTF-8");
				
				// 공용배포그룹 맴버가 조직도 or 공용그룹인 경우
				for (int i = 0; i < memberIdList.getLength(); i++) {
					inputParams += "&memberId="
							+ URLEncoder.encode(memberIdList.item(i)
									.getTextContent(), "UTF-8");
				}					
								
				// 공용배포그룹 멤버가 주소록 or 직접입력인 경우
				for (int i = 0; i < distributionSubList.size(); i++) {
					String subName = distributionSubList.get(i).get("subName");
					String subEmail = distributionSubList.get(i).get("subEmail");
					inputParams += "&subName=" + URLEncoder.encode(subName, "UTF-8") 
								+ "&subEmail=" + URLEncoder.encode(subEmail, "UTF-8");
				}
				
				// 회사별 이메일 도메인명이 설정되어 있으면 해당 도메인명을 기반으로 한 이메일 주소를 함께 전달한다.								
				if (!companyDomainName.isEmpty()) {
					String email = id + "@" + companyDomainName;
					
					inputParams += "&email=" + URLEncoder.encode(email, "UTF-8");
				}
				
				logger.debug("inputParams=" + inputParams);
				
				requestURL = config.getProperty("config.JGwServerURL")
						+ "/jMochaAccess/setDistributionList";
				response = ezEmailUtil.getWebServiceResult(requestURL,
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
								
				inputParams = "companyId="
						+ URLEncoder.encode(companyId, "UTF-8") + "&cn="
						+ URLEncoder.encode(cn, "UTF-8") + "&name="
						+ URLEncoder.encode(name, "UTF-8") + "&id="
						+ URLEncoder.encode(id, "UTF-8") + "&domain="
						+ URLEncoder.encode(domain, "UTF-8");
				
				// 공용배포그룹 맴버가 조직도 or 공용그룹인 경우
				for (int i = 0; i < memberIdList.getLength(); i++) {
					inputParams += "&memberId="
							+ URLEncoder.encode(memberIdList.item(i)
									.getTextContent(), "UTF-8");
				}
								
				// 공용배포그룹 멤버가 주소록 or 직접입력인 경우
				for (int i = 0; i < distributionSubList.size(); i++) {
					String subName = distributionSubList.get(i).get("subName");
					String subEmail = distributionSubList.get(i).get("subEmail");
					
					inputParams += "&subName=" + URLEncoder.encode(subName, "UTF-8") 
								+ "&subEmail=" + URLEncoder.encode(subEmail, "UTF-8");
				}
				
				// 회사별 이메일 도메인명이 설정되어 있으면 해당 도메인명을 기반으로 한 이메일 주소를 함께 전달한다.								
				if (!companyDomainName.isEmpty()) {
					String email = id + "@" + companyDomainName;
					
					inputParams += "&email=" + URLEncoder.encode(email, "UTF-8");
				}
				
				logger.debug("inputParams=" + inputParams);

				requestURL = config.getProperty("config.JGwServerURL")
						+ "/jMochaAccess/updateDistributionList";
				response = ezEmailUtil.getWebServiceResult(requestURL,
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
		String companyId = doc.getElementsByTagName("COMPID").item(0)
				.getTextContent();

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
				String pCnDomain = pCn.substring(pCn.indexOf("@") + 1, pCn.length());
				String pClass = (String) address.get("class");
				String displayName = (String) address.get("displayName"); //
				
				if (domain.equals(pCnDomain)) {
					pCn = pCn.substring(0, pCn.indexOf("@"));
				} else {
					pClass = "distributionSub";
				}
				
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

				} else if (pClass.equals("user")) {
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
				} else {//distribution_sub에서 가져오기(주소록, 직접입력)
					MailDistributionVO distributionSubVO = ezEmailService.getDistributionSub(cn, pCn, companyId, userInfo.getTenantId());
					
					if (distributionSubVO != null) {
						sb.append("<ROW>");
						sb.append("<CLASS>" + pClass + "</CLASS>");
						sb.append("<CN>" + commonUtil.cleanValue(pCn) + "</CN>");
						sb.append("<DISPLAYNAME>"
								+ commonUtil.cleanValue(distributionSubVO.getName())
								+ "</DISPLAYNAME>");
						sb.append("<MAIL>"
								+ commonUtil.cleanValue(distributionSubVO.getMail())
								+ "</MAIL>");
						sb.append("<DEPT>"
								+ commonUtil.cleanValue(distributionSubVO.getMail())
								+ "</DEPT>");
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
		String cn = doc.getElementsByTagName("CN").item(0).getTextContent();
		String companyId = doc.getElementsByTagName("COMPID").item(0).getTextContent();

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
		font.setBoldweight((short) HSSFFont.BOLDWEIGHT_BOLD);
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
	
	/**
	 * 공유사서함 추가 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezEmail/showAddSharedMailbox.do")
	public String showAddSharedMailbox(
			@CookieValue("loginCookie") String loginCookie, Locale locale, HttpServletRequest request, Model model) throws Exception {
		logger.debug("showAddSharedMailbox started.");

		// 관리자 권한체크
		LoginVO auth = commonUtil.checkAdmin(loginCookie);
		
		if (auth == null) {
			return "cmm/error/adminDenied";
		}

		String deptId = auth.getDeptID();
		String compId = request.getParameter("compId");
		String shareId = request.getParameter("shareId");
		int tenantId = auth.getTenantId();
		
		String mailDomain = ezCommonService.getCompanyConfig(tenantId, compId, "DomainName");
		
		if (mailDomain.equals("")) {
			mailDomain = ezCommonService.getTenantConfig("DomainName", tenantId);
		}
		
		model.addAttribute("shareId", shareId);
		model.addAttribute("deptId", deptId);
		model.addAttribute("compId", compId);
		model.addAttribute("mailDomain", mailDomain);
		
		logger.debug("showAddSharedMailbox ended.");
		return "admin/ezEmail/addSharedMailbox";
	}
	
	/**
	 * 공유사서함 추가 실행 함수
	 */
	@RequestMapping(value = "/admin/ezEmail/addSharedMailbox.do")
	public String addSharedMailbox(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, @RequestBody String bodyData) throws Exception {
		logger.debug("addSharedMailbox started.");
		logger.debug("bodyData=" + bodyData);
		
		String resultCode = "OK";
		
		try {
			// 관리자 권한체크
			LoginVO auth = commonUtil.checkAdmin(loginCookie);
			
			if (auth == null) {
				resultCode = "NO_PERMISSION";
				model.addAttribute("resultCode", resultCode);
				logger.debug("addSharedMailbox ended. resultCode=" + resultCode);
				
				return "json";
			}
			
			JSONParser jsonParser = new JSONParser();
	    	JSONObject jsonObj = (JSONObject) jsonParser.parse(bodyData);
			
	    	String shareId = (String)jsonObj.get("shareId");
			String shareName = (String)jsonObj.get("shareName");
			String compId = (String)jsonObj.get("compId");
			JSONArray userList = (JSONArray)jsonObj.get("userList");
			int userListSize = userList.size();
			logger.debug("shareId=" + shareId + ",shareName=" + shareName + ",compId=" + compId + ",userListSize=" + userListSize);
			
			int tenantId = auth.getTenantId();
			String domain = ezCommonService.getTenantConfig("DomainName", tenantId);
			String companyDomain = ezCommonService.getCompanyConfig(tenantId, compId, "DomainName");
			logger.debug("tenantId=" + tenantId + ",domain=" + domain + ",companyDomain=" + companyDomain); 
			
			// 공유사서함 부서가 존재하는지 확인
			String deptId = "shared_mailbox_" + compId;
			OrganDeptVO deptVO = ezOrganService.getDeptInfo(deptId, auth.getPrimary(), tenantId);
			
			// 공유사서함 부서가 없으면 생성
			if (deptVO == null) {
				String deptName = egovMessageSource.getMessage("ezEmail.sharedMailbox02", locale);
				String mailAddr = deptId + "@" + domain;
				
				int rc = ezEmailUserAdminService.addGroup(mailAddr);
				
				if (rc == 0) { // addGroup 성공
					String bizmekaResult = "ERROR";
					
					// insertDBData_dept 실패했을 경우 JMocha에서 부서 다시 삭제
					try {
						
						/* 비즈메카 연동은 우선 생각하지 않는다. -> 필요할 때 논의 후 구현!
						String useBizmekaSpambox = ezCommonService.getTenantConfig("UseBizmekaSpambox", tenantId);
						
						if (useBizmekaSpambox.equals("YES")) {
							String bizmekaAdminId = ezCommonService.getTenantConfig("bizmekaAdminId", tenantId);
							String bizmekaAdminPw = ezCommonService.getTenantConfig("bizmekaAdminPw", tenantId);
							String bizmekaCompanyId = ezCommonService.getTenantConfig("BizmekaCompanyId", tenantId);
							
							// 비즈메카에서는 회사 밑에 공유사서함 부서를 생성한다
							String parentDeptId = bizmekaCompanyId;
							
							bizmekaResult = ezEmailUtil.bizmekaAddDept(bizmekaAdminId, bizmekaAdminPw, bizmekaCompanyId, 
													deptId, deptName, parentDeptId);		
							
							logger.debug("bizmekaResult=" + bizmekaResult);
							
							if (!bizmekaResult.equals("OK")) {
								throw new Exception("bizmekaAddDept failed");
							}
						} */
						
						OrganDeptVO vo = new OrganDeptVO();
						
						vo.setTenantId(tenantId);
						vo.setCn(deptId);
						vo.setDisplayName(deptName);
						
						// 우선은 공유사서함 부서를 회사 하위에 생성한다. 
						vo.setParentCn(compId);
						
						// 인사연동 시 공유사서함 부서를 폐지시키지 않기 위해 manualFlag를 Y로 설정한다.
						vo.setManualFlag("Y");
						
						// 공유사서함 부서는 company domain 적용하지 않기로 함
//						String newMailAddr = getEmailAddressBasedOnCompanyDomainName(mailAddr, deptId, compId, tenantId);
						vo.setMail(mailAddr);
						
						ezOrganAdminService.insertDBData_dept(vo);
						
						// 조직도에 나타나게 하지 않기 위해 상위부서 정보를 없앤다.
						ezOrganAdminService.updateProperty(deptId, "EXTENSIONATTRIBUTE1", "", "dept", tenantId);
						ezOrganAdminService.updateProperty(deptId, "DEPTLEVEL", "2", "dept", tenantId);
						ezOrganAdminService.updateProperty(deptId, "DEPT_CD_PATH", deptId, "dept", tenantId);
						
					} catch (Exception e) {
						e.printStackTrace();
						
						ezEmailUserAdminService.removeGroup(mailAddr);	
						logger.debug("create sharedMailbox dept failed.");
						
						resultCode = "ERROR";
						model.addAttribute("resultCode", resultCode);
						logger.debug("addSharedMailbox ended. resultCode=" + resultCode);
						return "json";
					}
				} else {
					logger.debug("create sharedMailbox dept failed.");
					
					resultCode = "EMAIL_ERROR";
					model.addAttribute("resultCode", resultCode);
					logger.debug("addSharedMailbox ended. resultCode=" + resultCode);
					return "json";
				}
			}
			
			// 라이센스키 확인 (공유사서함 계정도 라이센스의 유저 수에 포함된다.)
			String checkResult = checkLicenseKey(tenantId, domain);
			
			if (!checkResult.equals("OK")) {
				logger.debug("create sharedMailbox failed. check license key!");
				resultCode = checkResult;
				
				model.addAttribute("resultCode", resultCode);
				logger.debug("addSharedMailbox ended. resultCode=" + resultCode);
				return "json";
			}
			
			// JMocha Mail Server가 계정이 소문자로 저장될 필요가 있어 
	        // 사용자 아이디를 무조건 소문자로 변환한다.
	        // 소문자로 저장되기만 하면 메일 수신 시에는 발신자가 대소문자를 혼합해서 보내도
	        // 수신에 문제는 없다.
			shareId = shareId.toLowerCase();
			
			// 사용자, 부서, 퇴직자, 회사 상관없이 기존에 사용되는 아이디를 체크한다.
			// 공용배포그룹ID, 메일ID(alias 메일ID 포함)로 이미 사용중인지도 체크한다.
			int cnt = ezOrganAdminService.userCheck(shareId, tenantId);
			logger.debug("cnt=" + cnt);
			
			if (cnt > 0) {
				logger.debug("create sharedMailbox account failed. '" + shareId + "' ID is already used.");
				resultCode = "DUPLICATE";
				
				model.addAttribute("resultCode", resultCode);
				logger.debug("addSharedMailbox ended. resultCode=" + resultCode);
				return "json";
			}
			
			String mailAddr = shareId + "@" + domain;
			
			// 이메일 시스템에 계정을 생성한다.
			// 비밀번호는 랜덤하게 설정한다.
			String oriPass = UUID.randomUUID().toString().replace("-", "").substring(0, 12) + "!@#";
			
			int rc = ezEmailUserAdminService.addUser(mailAddr, oriPass);
			logger.debug("addUser rc=" + rc);
			
			if (rc == 0) { // addUser 성공
				// 해당 User가 속한 부서의 Group Email 주소에 User를 등록한다.					
				String groupAddr = deptId + "@" + domain;					
				rc = ezEmailUserAdminService.updateGroupAdd(groupAddr, mailAddr);
				logger.debug("updateGroupAdd rc=" + rc);
				
				if (rc == 0) { // updateGroup 성공												
					String bizmekaResult = "ERROR";
					
					// insertDBData_user 실패했을 경우 JMocha에서 계정 다시 삭제.
					try {
						/* 비즈메카 연동은 우선 생각하지 않는다. -> 필요할 때 논의 후 구현!
						String useBizmekaSpambox = ezCommonService.getTenantConfig("UseBizmekaSpambox", tenantId);
						
						if (useBizmekaSpambox.equals("YES")) {
							String bizmekaAdminId = ezCommonService.getTenantConfig("bizmekaAdminId", tenantId);
							String bizmekaAdminPw = ezCommonService.getTenantConfig("bizmekaAdminPw", tenantId);
							String bizmekaCompanyId = ezCommonService.getTenantConfig("BizmekaCompanyId", tenantId);
							String parentDeptId = deptId;
							
							bizmekaResult = ezEmailUtil.bizmekaAddUser(bizmekaAdminId, bizmekaAdminPw, bizmekaCompanyId, shareId, "", 
												shareName, parentDeptId);		
							
							logger.debug("bizmekaResult=" + bizmekaResult);
							
							if (!bizmekaResult.equals("OK")) {
								throw new Exception("bizmekaAddUser failed");
							}
						} */
						
						OrganUserVO vo = new OrganUserVO();
						
						vo.setTenantId(tenantId);
						vo.setCn(shareId);
						vo.setDisplayName(shareName);
						vo.setParentCn(deptId);
						vo.setMail(mailAddr);
						
						// 인사연동 시 공유사서함 계정을 퇴직처리 시키지 않기 위해 manualFlag를 Y로 설정한다.
						vo.setManualFlag("Y");
						
						String userPrincipalName = shareId + "@" + domain;
						vo.setUpnName(userPrincipalName);
						
						String pass = EgovFileScrty.encryptPassword(oriPass, shareId);
						vo.setPassword(pass);
						
						// 로컬 시스템에 해당 User의 계정을 생성한다.
						ezOrganAdminService.insertDBData_user(vo, oriPass);
						
						String useStandardFolderId = config.getProperty("config.useStandardFolderId");
						
						if (useStandardFolderId != null && useStandardFolderId.equals("YES")) {							
							createDefaultFolders(loginCookie, mailAddr, locale);
						}
						
					} catch (Exception e) { // Exception이 발생하면 취소 처리를 한다.
						e.printStackTrace();
						
						ezEmailUserAdminService.updateGroupDel(groupAddr, mailAddr);
						ezEmailUserAdminService.removeUser(mailAddr);
						logger.debug("create sharedMailbox failed.");
						
						resultCode = "ERROR";
						model.addAttribute("resultCode", resultCode);
						logger.debug("addSharedMailbox ended. resultCode=" + resultCode);
						return "json";
					}
				} else {
					// 부서의 Group Email 주소로의 등록에 실패하면 해당 User를 삭제하고 에러를 반환한다.
					ezEmailUserAdminService.removeUser(mailAddr);
					logger.debug("create sharedMailbox failed. updateGroupAdd failed.");
					
					resultCode = "EMAIL_ERROR";
					model.addAttribute("resultCode", resultCode);
					logger.debug("addSharedMailbox ended. resultCode=" + resultCode);
					return "json";
				}
			} else {
				logger.debug("create sharedMailbox failed. addUser failed.");
				
				resultCode = "EMAIL_ERROR";
				model.addAttribute("resultCode", resultCode);
				logger.debug("addSharedMailbox ended. resultCode=" + resultCode);
				return "json";
			}
			
			// 회사별 이메일 도메인명이 설정되어 있으면 tbl_tenant_config에 있는 DomainName 대신에
			// 해당 도메인명을 사용해 이메일 주소를 생성한다.
			String companyDomainName = ezCommonService.getCompanyConfig(tenantId, compId, "DomainName");
			logger.debug("companyDomainName=" + companyDomainName);

			if (!companyDomainName.isEmpty()) {
				String newMailAddr = shareId + "@" + companyDomainName;
				
				List<String> mailList = new ArrayList<>();
				mailList.add(newMailAddr);
				
				String setAliasResult = ezEmailService.setIndividualAlias(shareId, tenantId, newMailAddr, mailList);
				
				if (!setAliasResult.equals("OK")) {
					logger.debug("set SharedMailbox Alias address failed.");
					
					resultCode = "ERROR";
					model.addAttribute("resultCode", resultCode);
					logger.debug("addSharedMailbox ended. resultCode=" + resultCode);
					return "json";
				}
			}
			
			// 공유자가 있을 경우 공유자 등록
			if (userListSize > 0) {
				String setUsersResult = ezEmailService.setSharedMailboxUsers(shareId, userList, tenantId);
				
				if (!setUsersResult.equals("OK")) {
					logger.debug("setSharedMailboxUsers failed.");
					
					resultCode = "ERROR";
					model.addAttribute("resultCode", resultCode);
					logger.debug("addSharedMailbox ended. resultCode=" + resultCode);
					return "json";
				}
			}
			
		} catch (Exception e) {
			resultCode = "ERROR";
			e.printStackTrace();
		}
		
		model.addAttribute("resultCode", resultCode);
		
		logger.debug("addSharedMailbox ended. resultCode=" + resultCode);
		return "json";
	}
	
	/**
	 * 공유사서함 수정 실행 함수
	 */
	@RequestMapping(value = "/admin/ezEmail/modSharedMailbox.do")
	public String modSharedMailbox(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, @RequestBody String bodyData) throws Exception {
		logger.debug("modSharedMailbox started.");
		logger.debug("bodyData=" + bodyData);
		
		String resultCode = "OK";
		
		try {
			// 관리자 권한체크
			LoginVO auth = commonUtil.checkAdmin(loginCookie);
			
			if (auth == null) {
				resultCode = "NO_PERMISSION";
				model.addAttribute("resultCode", resultCode);
				logger.debug("modSharedMailbox ended. resultCode=" + resultCode);
				
				return "json";
			}
			
			JSONParser jsonParser = new JSONParser();
	    	JSONObject jsonObj = (JSONObject) jsonParser.parse(bodyData);
			
	    	String shareId = (String)jsonObj.get("shareId");
			String shareName = (String)jsonObj.get("shareName");
			String compId = (String)jsonObj.get("compId");
			JSONArray userList = (JSONArray)jsonObj.get("userList");
			int userListSize = userList.size();
			int tenantId = auth.getTenantId();
			logger.debug("shareId=" + shareId + ",shareName=" + shareName + ",compId=" + compId + ",userListSize=" + userListSize + ",tenantId=" + tenantId);
			
			SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			date.setTimeZone(TimeZone.getTimeZone("GMT"));
			String nowDate = date.format(new Date());
			
			// 공유사서함이 있는지 확인
			OrganUserVO sharedMailbox = ezOrganAdminService.getUserInfo(shareId, auth.getPrimary(), tenantId);
			
			if (sharedMailbox == null || !sharedMailbox.getDepartment().equals("shared_mailbox_" + compId)) {
				logger.debug("sharedMailbox is not exists.");
				
				resultCode = "ERROR";
				model.addAttribute("resultCode", resultCode);
				logger.debug("modSharedMailbox ended. resultCode=" + resultCode);
				return "json";
			}
			
			// 공유사서함 이름 변경 (업데이트 날짜도 변경)
			ezOrganAdminService.updateProperty(shareId, "DISPLAYNAME", shareName, "user", tenantId);
			ezOrganAdminService.updateProperty(shareId, "DISPLAYNAME2", shareName, "user", tenantId);
			ezOrganAdminService.updateProperty(shareId, "updateDT", nowDate, "user", tenantId);
			
			// 공유자 수정
			String setUsersResult = resultCode = ezEmailService.setSharedMailboxUsers(shareId, userList, tenantId);
			
			if (!setUsersResult.equals("OK")) {
				logger.debug("setSharedMailboxUsers failed.");
				
				resultCode = "ERROR";
				model.addAttribute("resultCode", resultCode);
				logger.debug("modSharedMailbox ended. resultCode=" + resultCode);
				return "json";
			}
			
		} catch (Exception e) {
			resultCode = "ERROR";
			e.printStackTrace();
		}
		
		model.addAttribute("resultCode", resultCode);
		
		logger.debug("modSharedMailbox ended. resultCode=" + resultCode);
		return "json";
	}
	
	private void removeEmailAddressBasedOnCompanyDomainName(String cn, String compId, int tenantId) {
		try {
			String companyDomainName = ezCommonService.getCompanyConfig(tenantId, compId, "DomainName");
			logger.debug("companyDomainName=" + companyDomainName);

			// 회사별 이메일 도메인명이 설정되어 있으면 해당 도메인명을 기반으로 한 이메일 주소를 james_recipient_rewrite 테이블에서 제거한다.								
			if (!companyDomainName.isEmpty()) {
				logger.debug("Removing Email Address based on companyDomainName...");
				
				String newMailAddr = cn + "@" + companyDomainName;
				
				// 해당 주소를 james_recipient_rewrite 테이블에서 제거한다.
				ezEmailUserAdminService.removeGroup(newMailAddr);					
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	private String checkLicenseKey(int tenantID, String domain) throws Exception {
		String licenseKey = ezCommonService.getTenantConfig("LicenseKey", tenantID);
		
		logger.debug("licenseKey=" + licenseKey);
		
		// 입력된 라이센스키가 발견되지 않는 경우
		if (licenseKey == null || licenseKey.equals("")) {
			logger.debug("No License Key is found.");
			
			return "NO_LICENSE_KEY";
		}
		
		try {
			// 라이센스키를 복호화한다.
			licenseKey = egovFileScrty.decryptAES(licenseKey);
		} catch (Exception e) {
			logger.debug("License Key Decryption failed.");
			
			return "INVALID_LICENSE_KEY";
		}
		
		logger.debug("Decrypted licenseKey=" + licenseKey);
		
		String items[] = licenseKey.split(":");
		
		if (items.length < 2) {
			logger.debug("Number of License Key Items is less than 2");
			
			return "INVALID_LICENSE_KEY";					
		}
		
		String licensedDomainName = items[0];
		
		if (!licensedDomainName.equals(domain)) {
			logger.debug("licensedDomainName=" + licensedDomainName + ",domain=" + domain);
			
			return "INVALID_LICENSE_KEY";										
		}
		
		String licensedUserCountStr = items[1];
		
		int licensedUserCount = 0; 
				
		try {
			licensedUserCount = Integer.parseInt(licensedUserCountStr);
		} catch (NumberFormatException e) {
			logger.debug("Parsing Licensed User Count failed.");
			
			return "INVALID_LICENSE_KEY";										
		}
		
		int userCount = ezOrganAdminService.getUserCount(tenantID);
		
		// masteradmin 사용자를 제외하기 위해 1을 뺀다.
		userCount--;
		
		logger.debug("licensedUserCount=" + licensedUserCount + ",userCount=" + userCount);
				
		if (licensedUserCount <= userCount) {
			logger.debug("Maximum User Count already reached");
			
			return "MAX_USER_REACHED";															
		}
		
		return "OK";
	}
	
	private void createDefaultFolders(String loginCookie, String userEmail, Locale locale) throws Exception {
		String password = commonUtil.getUserIdAndPassword(loginCookie).get(1);		
		IMAPAccess ia = null;
		
        try {
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userEmail, password, egovMessageSource, locale, ezEmailUtil);
						
			// 기본 폴더들이 없을 때 생성한다.
			ia.getTopLevelFolders(true, false);			
		} finally {
			if (ia != null) {
				ia.close();
				ia = null;
			}
		}
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
		
		// 관리자 권한체크
		LoginVO auth = commonUtil.checkAdmin(loginCookie);
		if (auth == null) {
			return "cmm/error/adminDenied";
		}

		List<OrganDeptVO> list = ezOrganAdminService.getCompanyList(userInfo.getPrimary(), userInfo.getTenantId());
		List<OrganDeptVO> resultList = new ArrayList<OrganDeptVO>();

		for (int i = 0; i < list.size(); i++) {
			OrganDeptVO vo = list.get(i);

			if (userInfo.getRollInfo().contains("k=1") && vo.getCn().equals(userInfo.getCompanyID())) {
				resultList.add(vo);
			}

		}

		model.addAttribute("list", resultList);
		model.addAttribute("userLang", userInfo.getPrimary());

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
			returnJsonArr = ezEmailService.selectSearchSignatureTemplate(companyId, Integer.toString(userInfo.getTenantId()), search, userInfo.getPrimary());
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
			
			if (obj != null) {
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
			}
			
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
        
        LoginVO userInfo = commonUtil.userInfo(loginCookie);
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
		model.addAttribute("editor", ezCommonService.getTenantConfig("EDITOR",userInfo.getTenantId()));
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
	public String signaturePreviewContent(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		logger.debug("signaturePreviewContent started.");
		
		// 관리자 권한체크
		LoginVO auth = commonUtil.checkAdmin(loginCookie);
		if (auth == null) {
			return "cmm/error/adminDenied";
		}
		
		String content = request.getParameter("content");
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
