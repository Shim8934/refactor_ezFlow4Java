package egovframework.ezEKP.ezEmail.web;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;
import java.util.TimeZone;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import egovframework.let.utl.rest.JgwResult;
import egovframework.let.utl.rest.Rest;
import org.apache.commons.lang3.StringUtils;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.streaming.SXSSFCell;
import org.apache.poi.xssf.streaming.SXSSFRow;
import org.apache.poi.xssf.streaming.SXSSFSheet;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.codehaus.jackson.map.ObjectMapper;
import org.codehaus.jackson.type.TypeReference;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.w3c.dom.DOMException;
import org.w3c.dom.Document;
import org.w3c.dom.NodeList;

import com.google.gson.JsonObject;

import egovframework.ezEKP.ezSystem.service.EzSystemAdminService;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.Globals;
import egovframework.ezEKP.ezAddress.service.EzAddressService;
import egovframework.ezEKP.ezAddress.vo.AddressVO;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.logic.IMAPAccess;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezEmail.service.EzEmailUserAdminService;
import egovframework.ezEKP.ezEmail.util.EzEmailUtil;
import egovframework.ezEKP.ezEmail.vo.MailApprVO;
import egovframework.ezEKP.ezEmail.vo.MailColorVO;
import egovframework.ezEKP.ezEmail.vo.MailDistributionVO;
import egovframework.ezEKP.ezEmail.vo.MailSharedMailboxVO;
import egovframework.ezEKP.ezEmail.vo.MailSignatureTemplateVO;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.ezEKP.ezOrgan.vo.OrganJobVO;
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

	@Resource(name="EzSystemAdminService")
	private EzSystemAdminService ezSystemAdminService;

	@Autowired
	private Rest rest;
	
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
	@GetMapping(value = { "/admin/ezEmail/mailDistributionMain.do" })
	public String mailDistributionMain(
			@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("mailDistributionMain started.");

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
		model.addAttribute("companyId", auth.getCompanyID()); // default로 사용자의 회사 선택

		logger.debug("mailDistributionMain ended.");

		return "admin/ezEmail/mailDistributionMain";
	}

	/**
	 * 공용배포그룹관리 목록관리 화면 호출 함수
	 */
	@GetMapping(value = { "/admin/ezEmail/mailDistributionList.do" })
	public String mailDistributionList(
			@CookieValue("loginCookie") String loginCookie, Locale locale, @RequestParam String companyId, Model model) throws Exception {
		logger.debug("mailDistributionList started.");

		// 관리자 권한체크
		LoginVO auth = commonUtil.checkAdmin(loginCookie);
		if (auth == null) {
			return "cmm/error/adminDenied";
		}

		model.addAttribute("companyId", companyId);
		model.addAttribute("useOcs", config.getProperty("config.USE_OCS"));

		logger.debug("mailDistributionList ended.");

		return "admin/ezEmail/mailDistributionList";
	}

	/**
	 * 공용배포그룹관리 발송설정 호출 함수
	 */
	@GetMapping(value = { "/admin/ezEmail/mailDistributionSender.do" })
	public String mailDistributionSender(
			@CookieValue("loginCookie") String loginCookie, Locale locale, @RequestParam String companyId,
			Model model, HttpServletRequest request) throws Exception {
		logger.debug("mailDistributionSender started.");

		// 관리자 권한체크
		LoginVO auth = commonUtil.checkAdmin(loginCookie);
		if (auth == null) {
			return "cmm/error/adminDenied";
		}

		String useDistributionSender = ezCommonService.getCompanyConfig(auth.getTenantId(), companyId, "useDistributionSender");  // YES:NO

		model.addAttribute("useDistributionSender", useDistributionSender);
		model.addAttribute("companyId", companyId);

		logger.debug("mailDistributionSender ended.");

		return "admin/ezEmail/mailDistributionSender";
	}

	/**
	 * 공용배포그룹관리 발송설정 저장 함수
	 */
	@PostMapping(value = { "/admin/ezEmail/mailDistributionSenderSave.do" })
	@ResponseBody
	public String mailDistributionSenderSave(
			@CookieValue("loginCookie") String loginCookie,	@RequestParam String companyId, @RequestParam String configUpdate) {
		logger.debug("mailDistributionSenderSave started. companyId={}, configUpdate={}", companyId, configUpdate);

		// 관리자 권한체크
		LoginVO auth = commonUtil.checkAdmin(loginCookie);
		if (auth == null) {
			logger.debug("mailDistributionSenderSave ended. companyId={}, rollError", companyId);
			return "rollError";
		}

		// 로그인쿠키의 회사id와 전달 받은 회사id 비교 (표준적용 시 전체관리자 모드 고려필요)
		if (!auth.getCompanyID().equalsIgnoreCase(StringUtils.defaultString(companyId))) {
			logger.debug("mailDistributionSenderSave ended. companyId={}, compError", companyId);
			return "compError";
		}

		try {
			String useDistributionSender = ezCommonService.getCompanyConfig(auth.getTenantId(), companyId, "useDistributionSender");  // YES:NO

			// company config 새로 저장
			if (StringUtils.isBlank(useDistributionSender)) {
				ezCommonService.insertCompanyConfig(auth.getTenantId(), companyId, "useDistributionSender", configUpdate);
				logger.debug("mailDistributionSenderSave ended. companyId={}, ok", companyId);
				return "ok";
			}

			// DB 저장 값과 configUpdate가 다른 경우에만 저장
			if (!useDistributionSender.equalsIgnoreCase(configUpdate)) {
				ezCommonService.updateCompanyConfig(auth.getTenantId(), companyId, "useDistributionSender", configUpdate.toUpperCase());
			}

			logger.debug("mailDistributionSenderSave ended. companyId={}, ok", companyId);
			return "ok";

		} catch (Exception e) {
			logger.debug(e.getMessage(), e);
			return "error";
		}
	}
	
	/**
	 * 공용배포그룹관리 화면 호출 함수
	 
	@RequestMapping(value = "/admin/ezEmail/mailDistributionList.do", method = RequestMethod.GET)
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
	}*/

	/**
	 * 공용배포그룹 정보 호출 함수
	 */
	@RequestMapping(value = "/admin/ezEmail/mailGetDistribution.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String mailGetDistribution(
			@CookieValue("loginCookie") String loginCookie, Locale locale,
			Model model, @RequestBody String bodyData) throws Exception {
		logger.debug("mailGetDistribution started.");
		logger.debug("bodyData=" + bodyData);

		// 관리자 권한체크
		LoginVO auth = commonUtil.userInfo(loginCookie);
		if (auth.getRollInfo().indexOf("c=1") == -1 && auth.getRollInfo().indexOf("k=1") == -1) {
			String useUserDefinedDL = ezCommonService.getTenantConfig("useUserDefinedDL", auth.getTenantId());
			if (!useUserDefinedDL.equalsIgnoreCase("YES")) {
				return "cmm/error/adminDenied";
			}
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
						break;
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
							break;
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

		} catch (DOMException e) {
			logger.error(e.getMessage(), e);
		} catch (Exception e) {
			returnData = "ERROR";
			logger.error(e.getMessage(), e);
		}

		logger.debug("returnData=" + returnData);
		logger.debug("mailGetDistribution ended.");

		return returnData;
	}

	/**
	 * 공용배포그룹 추가 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezEmail/mailAddDistributionList.do", method = RequestMethod.GET)
	public String mailAddDistributionList(
			@CookieValue("loginCookie") String loginCookie, Locale locale,
			Model model, HttpServletRequest request) throws Exception {
		logger.debug("mailAddDistributionList started.");

		// 관리자 권한체크
		LoginVO auth = commonUtil.checkAdmin(loginCookie);
		LoginVO userVO = commonUtil.userInfo(loginCookie);
		String useUserDefinedDL = ezCommonService.getTenantConfig("useUserDefinedDL", userVO.getTenantId());
		String useShowAllCompanies = ezCommonService.getTenantConfig("useShowAllCompanies", userVO.getTenantId());
		if (auth == null) {
			if (!useUserDefinedDL.equalsIgnoreCase("YES")) {
				return "cmm/error/adminDenied";
			}
			auth = userVO;
		}

		String deptID = auth.getDeptID();
		String cn = request.getParameter("cn") == null ? "" : request
				.getParameter("cn");
		String textName = request.getParameter("name") == null ? "" : request
				.getParameter("name");
		String useOcs = config.getProperty("config.USE_OCS");
		String companyId = request.getParameter("companyId");
		String userDL =  request.getParameter("userDL");
		if (userDL == null ) { 
			userDL = ""; 
			useShowAllCompanies = "YES"; // 20220111 관리자페이지에서는 모든 회사 리스트 조회가능   사용자정의DL의 경우만 useShowAllCompanies 처리
		}
		String offsetMin = commonUtil.getMinuteUTC(auth.getOffset());
		
		int tenantId = auth.getTenantId();
		String mailDomain = ezCommonService.getCompanyConfig(tenantId, companyId, "DomainName");
		
		if (mailDomain.equals("")) {
			mailDomain = ezCommonService.getTenantConfig("DomainName", tenantId);
		}
		
		String companyMailDomain = mailDomain;
		String companyDomainList = ezCommonService.getCompanyConfig(tenantId, companyId, "MailInnerDomain");
		String[] domainList = companyDomainList.split(";");
		logger.debug("mailDomain=" + mailDomain + ", companyDomainList=" + companyDomainList);
		
		String distributionMail = "";
		
		String ownerId = "";
		String ownerName = "";
		String policy = "";
		String explain = "";
		String endDate = "";
		if (!cn.equals("")) { // 편집일 경우
			MailDistributionVO distributionVo = null;
			if (useUserDefinedDL.equalsIgnoreCase("YES") && !userDL.equals("")) {
				distributionVo = ezEmailService.getUserDistributionInfo(cn, tenantId);
				
				ownerId = distributionVo.getOwnerId();
				policy = distributionVo.getDisclosurePolicy();
				explain = distributionVo.getExplaination();
				endDate = distributionVo.getEndDate();
				OrganUserVO ownerVo = ezOrganService.getUserInfo(ownerId, auth.getPrimary(), tenantId);
				ownerName = ownerVo.getDisplayName();
				logger.debug("ownerId=" + ownerId + ", ownerName=" + ownerName + ", policy=" + policy + ", explain=" + explain 
						+ ", endDate=" + endDate);
			} else {
				distributionVo = ezEmailService.getDistributionInfo(cn, tenantId);
			}
			
			if (distributionVo != null) {	
				distributionMail = distributionVo.getMail();
				if (distributionMail != null){
					companyMailDomain = distributionMail.split("@")[1];
				}
			}
		}
		logger.debug("distributionMail=" + distributionMail + ", companyMailDomain=" + companyMailDomain);
		
		model.addAttribute("deptID", deptID);
		model.addAttribute("cn", cn);
		model.addAttribute("textName", textName);
		model.addAttribute("useOcs", useOcs);
		model.addAttribute("companyId", companyId);
		model.addAttribute("mailDomain", mailDomain);
		model.addAttribute("domainList", domainList);
		model.addAttribute("distributionMail", distributionMail);
		model.addAttribute("companyMailDomain", companyMailDomain);
		model.addAttribute("userDL", userDL);
		model.addAttribute("offsetMin", offsetMin);
		model.addAttribute("userId", auth.getId());
		model.addAttribute("userName", userVO.getDisplayName());
		model.addAttribute("useShowAllCompanies", useShowAllCompanies);
		
		model.addAttribute("ownerId", ownerId);
		model.addAttribute("ownerName", ownerName);
		model.addAttribute("policy", policy);
		model.addAttribute("endDate", endDate);
		model.addAttribute("explain", explain);
		
		String cChk = "0";
		
		if (auth.getRollInfo().indexOf("c=1") != -1) { // 전체 관리자
			cChk = "1";
		}
		
		model.addAttribute("cChk", cChk);
		
		logger.debug("mailAddDistributionList ended.");

		return "admin/ezEmail/mailAddDistributionList";
	}

	/**
	 * 공용배포그룹 추가 실행 함수
	 */
	@RequestMapping(value = "/admin/ezEmail/mailSaveDistributionList.do", produces = "text/html;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String mailSaveDistributionList(@CookieValue("loginCookie") String loginCookie, Locale locale,
			Model model, @RequestBody String bodyData) throws Exception {
		logger.debug("mailSaveDistributionList started.");
		logger.debug("bodyData=" + bodyData);

		// 관리자 권한체크
		LoginVO auth = commonUtil.checkAdmin(loginCookie);
		LoginVO userVO = commonUtil.userInfo(loginCookie);
		String useUserDefinedDL = ezCommonService.getTenantConfig("useUserDefinedDL", userVO.getTenantId());
		if (auth == null) {
			if (!useUserDefinedDL.equalsIgnoreCase("YES")) {
				return "cmm/error/adminDenied";
			}
			auth = userVO;
		}

		Document doc = commonUtil.convertStringToDocument(bodyData != null ? bodyData : "");
		String companyId = doc.getElementsByTagName("COMPID").item(0).getTextContent();
		String cn = doc.getElementsByTagName("CN").item(0).getTextContent();
		String name = doc.getElementsByTagName("NAME").item(0).getTextContent();
		String id = doc.getElementsByTagName("ID").item(0).getTextContent();
		String selectDomain = doc.getElementsByTagName("SELECTDOMAIN").item(0).getTextContent();
		selectDomain = selectDomain != null ? selectDomain : "";
		
		String ownerId = doc.getElementsByTagName("OWNERID").item(0) == null ? "" : doc.getElementsByTagName("OWNERID").item(0).getTextContent();
		String policy = doc.getElementsByTagName("POLICY").item(0) == null ? "" : doc.getElementsByTagName("POLICY").item(0).getTextContent();
		String explaination = doc.getElementsByTagName("EXPLAINATION").item(0) == null ? "" : doc.getElementsByTagName("EXPLAINATION").item(0).getTextContent();
		String endDate = doc.getElementsByTagName("ENDDATE").item(0) == null ? "" : doc.getElementsByTagName("ENDDATE").item(0).getTextContent();
		
		NodeList memberIdList = doc.getElementsByTagName("MEMBERID");
		NodeList addressIdList = doc.getElementsByTagName("ADDRESSID");
		NodeList addressNameList = doc.getElementsByTagName("ADDRESSNAME");
		NodeList addressMailList = doc.getElementsByTagName("ADDRESSMAIL");
		NodeList addressTypeList = doc.getElementsByTagName("ADDRESSTYPE");
		NodeList directMailList = doc.getElementsByTagName("DIRECTMAIL");
		NodeList directNameList = doc.getElementsByTagName("DIRECTNAME");
		
		int reasonCode = -100;
		String result = "ERROR";
		String setAliasResult = "ERROR";
		
		try {
			String bizmekaResult = "ERROR";
			int tenantID = auth.getTenantId();
			String useBizmekaSpambox = ezCommonService.getTenantConfig("UseBizmekaSpambox", tenantID);
			List<String> memberList = new ArrayList<String>();
			List<Map<String,String>> distributionSubList = new ArrayList<Map<String,String>>();
			Map<String,String> distributionSubMap = null;
			
			for (int i = 0; i < memberIdList.getLength(); i++) {
				String memberIdItem = memberIdList.item(i).getTextContent();
				
				/* = 공용배포그룹 조직도(직위)(직책) 탭 추가 =
				 * DL 구성원에 추가된 직위/직책은 memberIdList에 메일주소형태로 들어온다 (__직위아이디@도메인명)
				 * memberList에는 메일아이디만 들어가야하기 때문에 @도메인명 을 분리해준다
				 */
				if (memberIdItem.indexOf("@") > -1) {
					memberIdItem = memberIdItem.substring(0, memberIdItem.indexOf("@"));
				}
				
				memberList.add(memberIdItem);
			}
			
			// 주소록 distributionSubList에 추가
			for (int i = 0; i < addressTypeList.getLength(); i++) {
				String addressType = addressTypeList.item(i).getTextContent();
				
				// 주소록 타입이 그룹일 경우
				if (addressType.equals("MAILGROUP")) {
					AddressVO addressInfo =  ezAddressService.getAddressInfo(tenantID, auth.getPrimary(), addressIdList.item(i).getTextContent());
					String address = addressInfo.getsMemo();
				
					if (address != null && !address.trim().equals("")) {
						String[] addressRows = address.split(";");
						
						for (String addr : addressRows) {
							distributionSubMap = new HashMap<String, String>();
							String[] subRows = addr.split("<");
							String subName = subRows[0].replaceAll("\"", "");
							
							distributionSubMap.put("subName", subName);
							distributionSubMap.put("subEmail", subRows[1].substring(0, subRows[1].length() - 1));
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
			
			// 직접 입력 한 이름 distributionSubList에 추가
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
					String bizmekaAdminId = ezCommonService.getTenantConfig("bizmekaAdminId", tenantID);
					String bizmekaAdminPw = ezCommonService.getTenantConfig("bizmekaAdminPw", tenantID);
					String bizmekaCompanyId = ezCommonService.getTenantConfig("BizmekaCompanyId", tenantID);

					bizmekaResult = ezEmailUtil.bizmekaAddDistributionList(bizmekaAdminId, bizmekaAdminPw, bizmekaCompanyId, id, name, memberList);
					logger.debug("bizmekaResult=" + bizmekaResult);

					if (!bizmekaResult.equals("OK")) {
						throw new Exception("bizmekaAddDistributionList failed");
					}
				}

				reasonCode = ezEmailService.addDistributionList(id, name, memberList, distributionSubList, companyId, tenantID, selectDomain, ownerId, policy, explaination, endDate, loginCookie);
			// 기존 공용배포그룹을 수정하는 경우
			} else {
				if (useBizmekaSpambox.equals("YES")) {
					String bizmekaAdminId = ezCommonService.getTenantConfig("bizmekaAdminId", tenantID);
					String bizmekaAdminPw = ezCommonService.getTenantConfig("bizmekaAdminPw", tenantID);
					String bizmekaCompanyId = ezCommonService.getTenantConfig("BizmekaCompanyId", tenantID);

					bizmekaResult = ezEmailUtil.bizmekaEditDistributionList(bizmekaAdminId, bizmekaAdminPw, bizmekaCompanyId, id, name, memberList);

					logger.debug("bizmekaResult=" + bizmekaResult);

					if (!bizmekaResult.equals("OK")) {
						throw new Exception("bizmekaEditDistributionList failed");
					}
				}
								
				reasonCode = ezEmailService.updateDistributionList(cn, name, memberList, distributionSubList, companyId, tenantID, ownerId, policy, explaination, endDate, loginCookie);
			}
		} catch (NullPointerException e) {
			logger.error(e.getMessage(), e);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}

		if (reasonCode == 0) {
			result = "OK";
		} else if (reasonCode == -1) {
			result = "GROUP_NAME";
		} else if (reasonCode == -2) {
			result = "GROUP_ID";
		} else if (setAliasResult.equals("ERROR")) {
			result = "ALIAS_ERROR";
		}

		logger.debug("mailSaveDistributionList ended. result=" + result);
		return result;
	}

	/**
	 * 공용배포그룹 구성원 정보 호출 함수
	 */
	@RequestMapping(value = "/admin/ezEmail/mailViewDistributionList.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String mailViewDistributionList(
			@CookieValue("loginCookie") String loginCookie, Locale locale,
			Model model, @RequestBody String bodyData) throws Exception {
		logger.debug("mailViewDistributionList started.");

		String returnData = "";

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String domain = ezCommonService.getTenantConfig("DomainName",
				userInfo.getTenantId());
		String userLang = userInfo.getPrimary();
 
		Document doc = commonUtil.convertStringToDocument(bodyData != null ? bodyData : "");
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
			String mail = null;
			if (response != null) {
				JSONParser jsonParser = new JSONParser();
				JSONObject responseObj = (JSONObject) jsonParser
						.parse(response);

				String resultCode = (String) responseObj.get("resultCode");
		
				if (resultCode.equalsIgnoreCase("OK")) {
					resultArray = (JSONArray)responseObj.get("result");
					mail = (String)responseObj.get("mail");
				}
			}

			StringBuilder sb = new StringBuilder();
			sb.append("<DATA>");
			sb.append("<MAIL>" + mail + "</MAIL>");
			
			// 2023.05.26 한슬기 : 공용배포그룹정보 구성원 목록 정렬기능 추가(관리자->공용배포그룹관리->공용배포그룹구성원목록)
			if (resultArray != null) {
				List<Map<String, String>> distributionSortList = new ArrayList<>();

				// 화면에 보여줄 값들을 정렬하기 위해 distributionSortList에 데이터를 담아주는 반복문
				for (int i = 0; i < resultArray.size(); i++) {
					JSONObject address = (JSONObject) resultArray.get(i);
					String pCn = (String) address.get("cn"); // 메일 주소
					String primaryMail = (String) address.get("primaryMail"); // primary 메일주소
					String pCnDomain = pCn.substring(pCn.indexOf("@") + 1, pCn.length());
					String pClass = (String) address.get("class");
					String displayName = (String) address.get("displayName");
					
					if (domain.equals(pCnDomain)) {
						pCn = pCn.substring(0, pCn.indexOf("@"));
					} else {
						pClass = "distributionSub";
					}
					
					logger.debug("pCn : {}, pClass : {}, displayName : {}", pCn, pClass, displayName);

					Map<String, String> map = new HashMap<>();
					
					if ("group".equals(pClass)) {
						OrganDeptVO dept = ezOrganService.getDeptInfo(pCn, userInfo.getPrimary(), userInfo.getTenantId());
						
						map.put("CN", commonUtil.cleanValue(pCn));
						
						if (dept != null) {	// 부서일때
							map.put("CLASS", pClass);
							map.put("DISPLAYNAME", commonUtil.cleanValue(dept.getDisplayName()));
							map.put("MAIL", commonUtil.cleanValue(dept.getMail()));
							map.put("COMPANY", commonUtil.cleanValue(dept.getExtensionAttribute3()));
							map.put("DEPT", egovMessageSource.getMessage("ezOrgan.t68", locale));
							map.put("TITLE", egovMessageSource.getMessage("ezOrgan.t68", locale));
							
							distributionSortList.add(map);
							
						} else {	// 공용배포그룹일 때
							map.put("CLASS", "distribution");
							map.put("DISPLAYNAME", commonUtil.cleanValue(displayName));
							map.put("MAIL", commonUtil.cleanValue(primaryMail));
							map.put("COMPANY", "");
							map.put("DEPT", egovMessageSource.getMessage("ezEmail.t57", locale));
							map.put("TITLE", "");
							
							distributionSortList.add(map);
							
						}
						
					} else if ("user".equals(pClass)) { // user or jobmst
						OrganUserVO user = ezOrganAdminService.getUserInfo(pCn, userInfo.getPrimary(), userInfo.getTenantId());
						
						if (user != null) {	// 사원
							map.put("CLASS", pClass);
							map.put("CN", commonUtil.cleanValue(pCn));
							map.put("DISPLAYNAME", commonUtil.cleanValue(user.getDisplayName()));
							map.put("MAIL", commonUtil.cleanValue(user.getMail()));
							map.put("COMPANY", commonUtil.cleanValue(user.getCompany()));
							map.put("DEPT", commonUtil.cleanValue(user.getDescription()));
							map.put("TITLE", commonUtil.cleanValue(user.getTitle()));
							
							distributionSortList.add(map);
							
						} else if (pCn.substring(0,1).equalsIgnoreCase("_")) {	// 직위, 직책
							String jobId = pCn.split("__")[1]; // 직위,직책의 경우 메일아이디가 (__직위아이디)이기 때문에 (__)를 제외하여 직위아이디를 구한다
							OrganJobVO jobVO = ezOrganAdminService.getTitleByJobID(jobId, userLang, userInfo.getTenantId());
							
							String jobType = jobVO.getType(); // 001직위, 002직책
							String jobMail = pCn + "@" + pCnDomain;
							String jobTitle = jobType.equals("001") ? "main.t77" : "ezPersonal.t175"; 
							
							if (jobVO != null && !"".equals(jobVO.getJobID())) {	// 겸직
								map.put("CLASS", "jobmst");
								map.put("CN", commonUtil.cleanValue(jobVO.getJobID()));
								map.put("DISPLAYNAME", commonUtil.cleanValue(jobVO.getDisplayName()));
								map.put("MAIL", commonUtil.cleanValue(jobMail));
								map.put("COMPANY", "");
								map.put("DEPT", egovMessageSource.getMessage(jobTitle, locale));
								map.put("TITLE", jobType);
								
								distributionSortList.add(map);
								
							}
						}
						
					} else {	// 주소록, 직접입력(distribution_sub에서 가져오기)
						MailDistributionVO distributionSubVO = ezEmailService.getDistributionSub(cn, pCn, companyId, userInfo.getTenantId());
						
						if (distributionSubVO != null) {
							map.put("CLASS", pClass );
							map.put("CN", commonUtil.cleanValue(pCn));
							map.put("DISPLAYNAME", commonUtil.cleanValue(distributionSubVO.getName()));
							map.put("MAIL", commonUtil.cleanValue(distributionSubVO.getMail()));
							map.put("COMPANY", "");
							map.put("DEPT", commonUtil.cleanValue(distributionSubVO.getMail()));
							map.put("TITLE", "");
							
							distributionSortList.add(map);
							
						}
					}
				} // 값 담아주는 반복문 끝
				
				// 정렬시작(DISPLAYNAME기준으로 오름차순 정렬)
				Collections.sort(distributionSortList, new Comparator<Map<String, String>>() {
					@Override
					public int compare(Map<String, String> map1, Map<String, String> map2) {
						String displayName1 = map1.get("DISPLAYNAME");
						String displayName2 = map2.get("DISPLAYNAME");
						
						return displayName1.compareTo(displayName2);
						
					}
				}); // 정렬 끝 
				
				logger.debug("Sort Complete. distributionSortList : {}", distributionSortList);
				
				// 화면 그려주기
				for (int i = 0; i < distributionSortList.size(); i++) {
					Map<String, String> distributionSortGetI = distributionSortList.get(i);
					
					sb.append("<ROW>");
					sb.append("<CLASS>" + distributionSortGetI.get("CLASS") + "</CLASS>");
					sb.append("<CN>" + distributionSortGetI.get("CN") + "</CN>");
					sb.append("<DISPLAYNAME>"
							+ distributionSortGetI.get("DISPLAYNAME")
							+ "</DISPLAYNAME>");
					sb.append("<MAIL>"
							+ distributionSortGetI.get("MAIL")
							+ "</MAIL>");
					sb.append("<COMPANY>"
							+ distributionSortGetI.get("COMPANY")
							+ "</COMPANY>");
					sb.append("<DEPT>"
							+ distributionSortGetI.get("DEPT") + "</DEPT>");
					sb.append("<TITLE>"
							+ distributionSortGetI.get("TITLE") + "</TITLE>");
					sb.append("</ROW>");
					
				}	// 화면 그리기 끝
			}
			/* 원본 코드
			if (resultArray != null) {
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
									+ commonUtil.cleanValue(displayName)
									+ "</DISPLAYNAME>");
							sb.append("<MAIL>"
									+ commonUtil.cleanValue(cn)
									+ "</MAIL>");
							sb.append("<DEPT>"
									+ egovMessageSource.getMessage("ezEmail.t57",
											locale) + "</DEPT>");
							sb.append("</ROW>");
							}

					} else if (pClass.equals("user")) { // user or jobmst
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
						} else {
							String jobId        = pCn.split("__")[1]; // 직위/직책의 경우 메일아이디가 (__직위아이디)이기 때문에 (__)를 제외하여 직위아이디를 구한다
							OrganJobVO jobVO    = ezOrganAdminService.getTitleByJobID(jobId, userLang, userInfo.getTenantId());
							
							if (jobVO != null && !jobVO.getJobID().equals("")) {
								String jobType    = jobVO.getType(); // 001직위, 002직책
								String jobMail    = pCn + "@" + pCnDomain;
								String jobTitle   = jobType.equals("001") ? "main.t77" : "ezPersonal.t175"; 
								String jobClass   = "jobmst";
								logger.debug("jobType={}, jobMail={}", jobType, jobMail);
								
								sb.append("<ROW>");
								sb.append("<CLASS>" + jobClass + "</CLASS>");
								sb.append("<CN>" + commonUtil.cleanValue(jobVO.getJobID()) + "</CN>");
								sb.append("<DISPLAYNAME>"
										+ commonUtil.cleanValue(jobVO.getDisplayName())
										+ "</DISPLAYNAME>");
								sb.append("<MAIL>"
										+ commonUtil.cleanValue(jobMail)
										+ "</MAIL>");
								sb.append("<COMPANY></COMPANY>");
								sb.append("<DEPT>"
										+ egovMessageSource.getMessage(jobTitle, locale)
										+ "</DEPT>");
								sb.append("<TITLE>" // 구성원 목록 TR ATTRIBUTE JOBTYPE으로 사용
										+ jobType
										+ "</TITLE>");
								sb.append("</ROW>");
							}
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
			}*/

			sb.append("</DATA>");
			returnData = sb.toString();

		} catch (UnsupportedEncodingException e) {
			logger.error(e.getMessage(), e);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}

		logger.debug("mailViewDistributionList ended.");

		return returnData;
	}

	/**
	 * 공용배포그룹 삭제 실행 함수
	 */
	@RequestMapping(value = "/admin/ezEmail/mailDelDistributionList.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String mailDelDistributionList(
			@CookieValue("loginCookie") String loginCookie, Locale locale,
			Model model, @RequestBody String bodyData) throws Exception {
		logger.debug("mailDelDistributionList started.");
		logger.debug("bodyData=" + bodyData);

		// 관리자 권한체크
		LoginVO auth = commonUtil.checkAdmin(loginCookie);
		LoginVO userVO = commonUtil.userInfo(loginCookie);
		String useUserDefinedDL = ezCommonService.getTenantConfig("useUserDefinedDL", userVO.getTenantId());
		if (auth == null) {
			if (!useUserDefinedDL.equalsIgnoreCase("YES")) {
				return "cmm/error/adminDenied";
			}
			auth = userVO;
		}

		String result = "ERROR";
		if (bodyData != null) {
			Document doc = commonUtil.convertStringToDocument(bodyData);
			String cn = doc.getElementsByTagName("CN").item(0).getTextContent();
			// String companyId = doc.getElementsByTagName("COMPID").item(0).getTextContent();

			int tenantID = auth.getTenantId();

			String domain = ezCommonService.getTenantConfig("DomainName", tenantID);

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

					if (result.equals("OK")) {
						logger.debug("delete Alias address.");
						int delAliasResult = ezEmailService.deleteIndividualAlias(cn, tenantID);
						result = delAliasResult == -100 ? "ERROR" : result;
					}

				}

			} catch (UnsupportedEncodingException e) {
				logger.error(e.getMessage(), e);
			} catch (Exception e) {
				logger.error(e.getMessage(), e);
			}
		}

		logger.debug("result=" + result);
		logger.debug("mailDelDistributionList ended.");

		return result;
	}
	
	/**
	 * 공용배포그룹 조건별 검색
	 */
	@RequestMapping(value = "/admin/ezEmail/mailGetDistributionSearchByItem.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String mailGetDistributionSearchByItem(
			@CookieValue("loginCookie") String loginCookie, Locale locale,
			Model model, @RequestBody String bodyData) throws Exception {
		logger.debug("mailGetDistributionSearchByItem started.");

		// 관리자 권한체크
		LoginVO auth = commonUtil.checkAdmin(loginCookie);
		if (auth == null) {
			return "cmm/error/adminDenied";
		}

		String returnData = "";
		try {
			if (bodyData != null){
				Document doc = commonUtil.convertStringToDocument(bodyData);
				// String cn = doc.getElementsByTagName("CN").item(0).getTextContent();
				String companyId = doc.getElementsByTagName("COMPID").item(0).getTextContent();
				String searchType = doc.getElementsByTagName("SEARCHTYPE").item(0).getTextContent();
				String searchValue = doc.getElementsByTagName("SEARCHVALUE").item(0).getTextContent();
				int tenantID = auth.getTenantId();
				logger.debug("companyId=" + companyId + ", searchType=" + searchType + ",searchValue=" + searchValue);

				List<MailDistributionVO> distributionTotalList = null;
				if (searchValue == null || searchValue.equals("")) {
					//모든 공용배포그룹
					distributionTotalList = ezEmailService
							.getDistributionList(companyId, auth.getTenantId());
				} else {
					// 공용배포그룹 조건으로 검색
					distributionTotalList = ezEmailService
							.getDistributionSearchListByItem(companyId, tenantID, searchValue, searchType);
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
			}
		} catch (DOMException e) {
			logger.error(e.getMessage(), e);
		} catch (Exception e) {
			returnData = "ERROR";
			logger.error(e.getMessage(), e);
		}

		logger.debug("returnData=" + returnData);
		logger.debug("mailGetDistributionSearchByItem ended.");

		return returnData;
	}


	/**
	 * 공용배포그룹 엑셀 다운로드 실행 함수
	 */
	@RequestMapping(value = "/admin/ezEmail/mailExcelExportDistributionList.do", method = RequestMethod.GET)
	@ResponseBody
	public void mailExcelExportDistributionList(@CookieValue("loginCookie") String loginCookie, 
												  HttpServletRequest request, 
												  HttpServletResponse response, 
												  Locale locale) throws Exception {
		
		logger.debug("mailExcelExportDistributionList started.");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String domain = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
		int tenantId = userInfo.getTenantId();
		String primaryLang = userInfo.getPrimary();
		String userLang = userInfo.getPrimary();
		String companyId = request.getParameter("companyID");
		String[] dvGroupList = request.getParameterValues("dvGroupList");
		List<Map<String, String>> mailDistributionList = new ArrayList<>();

		for(int i=0; i<dvGroupList.length; i++) {
			String mail = null;
			String dlName = null;
			String dlCn = dvGroupList[i];
			JSONArray resultArray = null;
			JSONObject responseObj = ezEmailService.getDistributionMemberList(domain, dlCn);
			List<Map<String, String>> mailDistributionSortList = new ArrayList<>();

			if (responseObj != null) {
				String resultCode = (String) responseObj.get("resultCode");

				if (resultCode.equalsIgnoreCase("OK")) {
					resultArray = (JSONArray) responseObj.get("result");
					mail = (String) responseObj.get("mail");
					dlName = (String) responseObj.get("dlName");
				}
			}

			for (int j = 0; j < resultArray.size(); j++) {
				JSONObject info = (JSONObject) resultArray.get(j);
				String pCn = (String) info.get("cn"); // 메일주소
				String primaryMail = (String) info.get("primaryMail"); // primary 메일주소
				String pCnDomain = pCn.substring(pCn.indexOf("@") + 1, pCn.length());
				String pClass = (String) info.get("class");
				String displayName = (String) info.get("displayName");

				if (domain.equals(pCnDomain)) {
					pCn = pCn.substring(0, pCn.indexOf("@"));
				} else {
					pClass = "distributionSub";
				}

				Map<String, String> map = new HashMap<>();
				map.put("DLCN", dlCn); // 공용배포그룹 ID
				map.put("DLNM", dlName); // 공용배포그룹 이름
				map.put("DLMAIL", mail); // 공용배포그룹 Mail

				if ("group".equals(pClass)) { // 부서, 공용배포그룹
					map.put("CN", pCn);
					map.put("MAIL", primaryMail);
					map.put("DISPLAYNAME", displayName);
					mailDistributionSortList.add(map);

				} else if ("user".equals(pClass)) { // user or jobmst
					OrganUserVO user = ezOrganAdminService.getUserInfo(pCn, primaryLang, tenantId);

					if (user != null) {    // 사원
						map.put("CN", pCn);
						map.put("DISPLAYNAME", user.getDisplayName());
						map.put("MAIL", user.getMail());
						mailDistributionSortList.add(map);
					} else if (pCn.substring(0,1).equalsIgnoreCase("_")) {	// 직위, 직책
						String jobId = pCn.split("__")[1]; // 직위,직책의 경우 메일아이디가 (__직위아이디)이기 때문에 (__)를 제외하여 직위아이디를 구한다
						OrganJobVO jobVO = ezOrganAdminService.getTitleByJobID(jobId, userLang, tenantId);

						String jobType = jobVO.getType(); // 001직위, 002직책
						String jobMail = pCn + "@" + pCnDomain;
						String jobTitle = jobType.equals("001") ? "main.t77" : "ezPersonal.t175";

						if (jobVO != null && !"".equals(jobVO.getJobID())) {    // 겸직
							map.put("CN", jobVO.getJobID());
							map.put("DISPLAYNAME", jobVO.getDisplayName());
							map.put("MAIL", jobMail);
							mailDistributionSortList.add(map);
						}
					}

				} else {    // 주소록, 직접입력(distribution_sub에서 가져오기)
					MailDistributionVO distributionSubVO = ezEmailService.getDistributionSub(dlCn, pCn, companyId, userInfo.getTenantId());

					if (distributionSubVO != null) {
						map.put("CN", pCn);
						map.put("DISPLAYNAME", distributionSubVO.getName());
						map.put("MAIL", distributionSubVO.getMail());
						mailDistributionSortList.add(map);
					}
				}
			}

			mailDistributionSortList.sort(Comparator.comparing((Map<String, String> map) -> map.get("DISPLAYNAME")));
		
			for (Map<String, String> map : mailDistributionSortList) {
				Map<String, String> newMap = new HashMap<>(map);
				mailDistributionList.add(newMap);
			}
			
		}

		/* 엑셀 생성 */
		try (SXSSFWorkbook workbook = new SXSSFWorkbook()) {
			SXSSFSheet sheet = workbook.createSheet("MailDistributionList");
			SXSSFRow row = null;
			SXSSFCell cell = null;
			String[] dlHeaderArr = egovMessageSource.getMessage("ezEmail.khj01", locale).split(";");
			CellStyle headerStyle = workbook.createCellStyle();
			CellStyle bodyStyle = workbook.createCellStyle();

			String fileName = "MailDistributionList";
			
			// 시트 기본 열 넓이
			for(int c = 0 ; c < dlHeaderArr.length; c++){
				sheet.isColumnTrackedForAutoSizing(c);
				sheet.setColumnWidth(c, (sheet.getColumnWidth(c))+4000); //너비 더 넓게
			}

			// 폰트 설정
			Font font = workbook.createFont();
			font.setFontHeightInPoints((short) 11);
			font.setBold(Boolean.TRUE);
			headerStyle.setFont(font);

			// 헤더 스타일
			headerStyle.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
			headerStyle.setFillPattern(CellStyle.SOLID_FOREGROUND);
			headerStyle.setBorderBottom(CellStyle.BORDER_THIN);
			headerStyle.setBorderTop(CellStyle.BORDER_THIN);
			headerStyle.setBorderRight(CellStyle.BORDER_THIN);
			headerStyle.setBorderLeft(CellStyle.BORDER_THIN);
			headerStyle.setVerticalAlignment((short) 1);

			// 바디 스타일
			bodyStyle.setBorderBottom(CellStyle.BORDER_THIN);
			bodyStyle.setBorderTop(CellStyle.BORDER_THIN);
			bodyStyle.setBorderRight(CellStyle.BORDER_THIN);
			bodyStyle.setBorderLeft(CellStyle.BORDER_THIN);

			// 헤더 삽입
			row = sheet.createRow(0);
			for (int head = 0; head < dlHeaderArr.length; head++) {
				cell = row.createCell(head);
				cell.setCellStyle(headerStyle);
				cell.setCellValue(dlHeaderArr[head]);
			}

			// 바디 입력
			for (int nRow = 1; nRow < mailDistributionList.toArray().length + 1; nRow++) {
				row = sheet.createRow(nRow);

				Map<String, String> distributionSortGetI = mailDistributionList.get(nRow -1);

				String dlId = distributionSortGetI.get("DLCN");
				String dlNm = distributionSortGetI.get("DLNM");
				String dlMail = distributionSortGetI.get("DLMAIL");
				String userId = distributionSortGetI.get("CN");
				String userNm = distributionSortGetI.get("DISPLAYNAME");
				String userMail = distributionSortGetI.get("MAIL");


				String[] distributionList =  {dlId, dlNm, dlMail, userId, userNm, userMail};

				for (int nCell = 0; nCell < dlHeaderArr.length; nCell++) {
					cell = row.createCell(nCell);
					cell.setCellStyle(bodyStyle);
					cell.setCellValue(distributionList[nCell]);
				}
			}

			response.setCharacterEncoding("UTF-8");
			response.setHeader("Content-Disposition", "attachment; fileName=" + fileName + ".xlsx");
			response.setContentType("application/vnd.ms-excel");

			workbook.write(response.getOutputStream());
			workbook.close();

			logger.debug("mailExcelExportDistributionList ended.");
		} 
		
		catch (IllegalArgumentException e) {
			logger.error(e.getMessage(), e);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
	}

	/**
	 * 메일 기본설정 (관리자) 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezEmail/mailConfigColor.do", method = RequestMethod.GET)
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
	@RequestMapping(value = "/admin/ezEmail/mailColor.do", method = RequestMethod.GET)
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

		} catch (ParseException e) {
			logger.error(e.getMessage(), e);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
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
	@RequestMapping(value = "/admin/ezEmail/mailSaveColor.do", method = RequestMethod.POST)
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
			Document doc = commonUtil.convertStringToDocument(bodyData != null ? bodyData : "");
			String importanceColor = doc.getElementsByTagName("IMPORTANCE")
					.item(0).getTextContent();
			String inColor = doc.getElementsByTagName("INCOLOR").item(0)
					.getTextContent();
			String outColor = doc.getElementsByTagName("OUTCOLOR").item(0)
					.getTextContent();

			int tenantId = auth.getTenantId();

			ezEmailService.setMailColor(tenantId, importanceColor, inColor,
					outColor);

		} catch (DOMException e) {
			logger.error(e.getMessage(), e);
		} catch (Exception e) {
			returnValue = "ERROR:" + e.getMessage();
			logger.error(e.getMessage(), e);
		}

		logger.debug("returnValue=" + returnValue);
		logger.debug("mailSaveColor ended.");

		return returnValue;
	}

	/**
	 * 메일 디폴트 Quota (관리자) 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezEmail/mailDefaultQuota.do", method = RequestMethod.GET)
	public String mailDefaultQuota(
			@CookieValue("loginCookie") String loginCookie, Locale locale,
			Model model, HttpServletRequest request) throws Exception {
    	logger.debug("mailDefaultQuota started.");

		// 관리자 권한체크
		LoginVO auth = commonUtil.checkAdmin(loginCookie);

		if (auth == null) {
			return "cmm/error/adminDenied";
		}

		int j = 0;
		String companyId = auth.getCompanyID(); // 로그인한 관리자의 회사아이디
		List<OrganDeptVO> list = ezOrganAdminService.getCompanyList(auth.getPrimary(), auth.getTenantId());
		List<OrganDeptVO> resultList = new ArrayList<OrganDeptVO>();

		for (int i = 0; i < list.size(); i++) {
			OrganDeptVO vo = list.get(i);

			if (auth.getRollInfo().indexOf("c=1") > -1 || vo.getCn().equals(companyId)) {
				resultList.add(j++, vo);
			}
		}
		model.addAttribute("userCompany", companyId);
		model.addAttribute("list", resultList);

        logger.debug("mailDefaultQuota ended.");

		return "admin/ezEmail/mailDefaultQuota";
	}

	/**
	 * 회사별/디폴트 메일박스용량 리턴하는 함수
	 */
	@RequestMapping(value = "/admin/ezEmail/getDefaultQuota.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject getDefaultQuota(
			@CookieValue("loginCookie") String loginCookie, 
			HttpServletRequest request) throws Exception {
		logger.debug("getDefaultQuota started.");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
		
		String companyId = request.getParameter("companyId");
		
		Double[] returnedData;
		if (companyId.equals("*")) {
			returnedData = ezEmailUtil.getDefaultQuota(domainName);
		} else {
			returnedData = ezEmailUtil.getCompanyQuota(domainName, companyId);
		}
		
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("companyMax", returnedData[0] / 1024);
		jsonObj.put("companyWarn", returnedData[1] / 1024);
		
		logger.debug("getDefaultQuota ended.");
		return jsonObj;
	}

	/**
	 * 메일 디폴트 Quota 설정 함수
	 */
	@RequestMapping(value = "/admin/ezEmail/mailSaveDefaultQuota.do", method = RequestMethod.POST)
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
			String domainName = ezCommonService.getTenantConfig("DomainName", auth.getTenantId());

			Document doc = commonUtil.convertStringToDocument(bodyData != null ? bodyData : "");
			String companyId = doc.getElementsByTagName("COMPANYID").item(0).getTextContent();
			String maxStorage = doc.getElementsByTagName("MAXSTORAGE").item(0).getTextContent();
			String warnStorage = doc.getElementsByTagName("WARNSTORAGE").item(0).getTextContent();
			if (companyId.equals("*")) {
				ezEmailUtil.setDefaultQuota(domainName, maxStorage, warnStorage);
			} else {
				ezEmailUtil.setCompanyQuota(domainName, companyId, maxStorage, warnStorage);
			}
		} catch (DOMException e) {
			logger.error(e.getMessage(), e);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);

			returnValue = "ERROR";
		}

        logger.debug("mailSaveDefaultQuota ended.");

		return returnValue;
	}

	/**
	 * 회원별 메일함 사용용량 및 총용량
	 */
	@RequestMapping(value = "/admin/ezEmail/mailQuotaList.do", method = RequestMethod.GET)
	public String showMailBoxQuotaManaged(@CookieValue("loginCookie")String loginCookie, Model model) throws Exception {
		logger.debug("showMailBoxQuotaManaged started.");
		
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
	
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		int j = 0;
		String companyId = userInfo.getCompanyID();
		List<OrganDeptVO> list = ezOrganAdminService.getCompanyList(userInfo.getPrimary(), userInfo.getTenantId());
		List<OrganDeptVO> resultList = new ArrayList<OrganDeptVO>();
		
		for (int i = 0; i < list.size(); i++) {
			OrganDeptVO vo = list.get(i);
			
			if (userInfo.getRollInfo().indexOf("c=1") > -1 || vo.getCn().equals(companyId)) {
				resultList.add(j++, vo);
			}
		}
		
		model.addAttribute("list", resultList);
		model.addAttribute("companyId", companyId);

		logger.debug("showMailBoxQuotaManaged ended.");
		
		return "/admin/ezEmail/mailQuotaList";
	}

	@RequestMapping(value = "/admin/ezEmail/mailBoxQuotaUpdate.do", method = RequestMethod.GET)
	public String mailBoxQuotaUpdate(@CookieValue("loginCookie") String loginCookie,
			@RequestParam(required = false) String searchKeycode,
			@RequestParam(required = false) String searchKeyword,
			@RequestParam(required = false) boolean[] searchFor, HttpServletRequest req) throws Exception{
		logger.debug("mailBoxQuotaUpdate started.");

		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);

		String companyId = req.getParameter("companyId");
		String currPage = req.getParameter("pageNum");
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}

		int tenantID = userInfo.getTenantId();
		String email = null;
		IMAPAccess ia = null;
		Locale locale = Locale.getDefault();
		String password = jspw;
		String domain = ezCommonService.getTenantConfig("DomainName", tenantID);
		String mailServerAddress = config.getProperty("config.MailServerAddress");
		String iMAPPort = config.getProperty("config.IMAPPort");

		int maxItemPerPage = 20;
		int startRow = Math.multiplyExact(Math.subtractExact(Integer.parseInt(currPage), 1), maxItemPerPage);
		
		if (currPage != null && currPage.equals("-1")) {
			startRow = -1;
		}
		
		if (searchFor != null) {
			searchFor[1] = false;
		}
		
		// 전체사용자 검색후 update보다 검색된 사용자만 update하도록 수정
		// List<OrganUserVO> vo = ezOrganAdminService.getAllUserCnList(tenantID);
		List<OrganUserVO> vo = ezOrganAdminService.getUserList(userInfo.getTenantId(), startRow, 
				    maxItemPerPage, searchKeycode, searchKeyword, companyId, "", "", searchFor);

		for (OrganUserVO user : vo) {

			try {
				String cn = user.getCn();
				email = cn + "@" + domain;
				ia = IMAPAccess.getInstance(mailServerAddress, iMAPPort, email, password, egovMessageSource, locale, ezEmailUtil);

				if (ia != null){
					long[] storageUsageAndLimit = ia.getStorageUsageAndLimit();
					if (storageUsageAndLimit != null){
						long mailboxUsage = storageUsageAndLimit[0];
						long mailboxQuota = storageUsageAndLimit[1];

						ezOrganAdminService.updateProperty(cn, "mailboxusage", String.valueOf(mailboxUsage), "user", tenantID);
						ezOrganAdminService.updateProperty(cn, "mailboxquota", String.valueOf(mailboxQuota), "user", tenantID);
					}
				}
			} catch (NullPointerException e) {
				logger.error(e.getMessage(), e);
			} catch (Exception e) {
				logger.debug("error. user=" + email);
				logger.error(e.getMessage(), e);
			} finally {
				if (ia != null) {
					ia.close();
				}
			}
		}

		logger.debug("mailBoxQuotaUpdate ended.");
		return "json";
	}

	@RequestMapping(value = "/admin/ezEmail/mailBoxQuotaManageList.do", method = RequestMethod.POST)
	public String mailBoxQuotaManageList( @CookieValue("loginCookie") String loginCookie,
			Model model, HttpServletRequest req,
			@RequestParam(required = false) String searchKeycode,
			@RequestParam(required = false) String searchKeyword,
			@RequestParam(required = false) String sortColumn,
			@RequestParam(required = false) String sortType,
			@RequestParam(required = false) boolean[] searchFor) throws Exception {
		logger.debug("mailBoxQuotaManageList started.");

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
		int startRow = Math.multiplyExact(Math.subtractExact(Integer.parseInt(currPage), 1), maxItemPerPage);
		
		if (currPage.equals("-1")) {
			startRow = -1;
		}

		int dbName = "mysql".equals(globals.getProperty("Globals.DbType")) ? 1 : 2;
   		searchKeyword = commonUtil.getWildcardEscapedString(searchKeyword != null ? searchKeyword : "", dbName);

		List<ArrayList<String>> userList = new ArrayList<ArrayList<String>>();

		// 모든 사용자의 목록을 가져온다.
		List<OrganUserVO> userCnList;
		int itemCnt;
		
		// 사용률로 검색 시에 숫자가 아니면 빈 값으로 리턴하도록 처리
		try {
			if ("quota".equalsIgnoreCase(searchKeycode)) {
				Double.parseDouble(searchKeyword);
			}


			userCnList = ezOrganAdminService.getUserList(userInfo.getTenantId(), startRow,
						maxItemPerPage, (searchKeycode != null ? searchKeycode : ""), searchKeyword, companyId, (sortColumn != null ? sortColumn : ""), (sortType != null ? sortType : ""), searchFor);
			if(userCnList == null){
				throw new Exception("UserCnList is null");
			}
			itemCnt = ezOrganAdminService.getUserCount(userInfo.getTenantId(), searchKeycode, searchKeyword, searchFor, companyId);
		} catch (NullPointerException ex) {
			userCnList = new ArrayList<>();
			itemCnt = 0;
		} catch (Exception ex) {
			userCnList = new ArrayList<>();
			itemCnt = 0;
		}

		int totalPage = itemCnt / maxItemPerPage;
		
		if (itemCnt < 1) {
			totalPage = 1;
		}
		
		if ((totalPage * maxItemPerPage) != itemCnt && (itemCnt % maxItemPerPage) != 0) {
			totalPage = totalPage + 1;
		}
		
		currentPage = Math.min(currentPage, totalPage);
		
        IMAPAccess ia = null;
        Locale locale = Locale.getDefault();
        String password = jspw;
        String domain = ezCommonService.getTenantConfig("DomainName",userInfo.getTenantId());
        String mailServerAddress = config.getProperty("config.MailServerAddress");
        String iMAPPort = config.getProperty("config.IMAPPort");
        
        boolean primaryChk = userInfo.getPrimary().equals("1") ? true : false;

		// 각 사용자별로 처리한다.
		for (OrganUserVO organUser : userCnList) {				
			List<String> quaList = new ArrayList<String>();
			String userId = organUser.getCn();
			logger.debug("user = {}", userId);
			String department = primaryChk ? organUser.getDescription() : organUser.getDescription2();
			String displayname = primaryChk ? organUser.getDisplayName() : organUser.getDisplayName2();
			displayname = displayname + "(" + userId + ")";		
			
			quaList.add(0, userId);
			quaList.add(1, displayname);
			quaList.add(2, department.replaceAll("<", "&lt;").replaceAll(">", "&gt;"));
			long mailboxUsage = 0;
			long mailboxQuota = 0;

			try {
                String email = userId + "@" + domain;

                if ("quota".equalsIgnoreCase(searchKeycode)) {
                	// imap 과 약간의 차이가 있을 수 있으므로
                	mailboxQuota = (long) Double.parseDouble(organUser.getMailboxQuota());
					mailboxUsage = (long) Double.parseDouble(organUser.getMailboxUsage());
					logger.debug("get organUserVO, mailboxQuota=" + mailboxQuota + ", mailboxUsage=" + mailboxUsage);
				} else {
					// 퇴직자는 IMAP에 로그인 할 수 없으므로 db에 저장된 값으로 처리한다.
					if (organUser.getIsRetire() == 1) {
						mailboxQuota = organUser.getMailboxQuota() == null ? 0 : (long) Double.parseDouble(organUser.getMailboxQuota());
						mailboxUsage = organUser.getMailboxUsage() == null ? 0 : (long) Double.parseDouble(organUser.getMailboxUsage());
						logger.debug("get organUserVO, mailboxQuota=" + mailboxQuota + ", mailboxUsage=" + mailboxUsage);
					} else {
						ia = IMAPAccess.getInstance(mailServerAddress, iMAPPort, email, password, egovMessageSource, locale, ezEmailUtil);
						
						if (ia != null){
							long[] storageUsageAndLimit = ia.getStorageUsageAndLimit();
							if (storageUsageAndLimit != null){
								// 사용자의 현재 메일박스 스토리지 사용량과 쿼터(최대 할당량)을 구한다.
								mailboxUsage = storageUsageAndLimit[0]; // KBs
								mailboxQuota = storageUsageAndLimit[1]; // KBs
								logger.debug("get IMAP, mailboxQuota=" + mailboxQuota + ", mailboxUsage=" + mailboxUsage);
							}
						}
					}
				}

                quaList.add(3, String.valueOf(mailboxUsage));
                quaList.add(4, String.valueOf(mailboxQuota));
                userList.add((ArrayList<String>) quaList);
            } catch (NullPointerException e) {
                logger.error(e.getMessage(), e);
			} catch (Exception e) {
                logger.error(e.getMessage(), e);
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

		logger.debug("mailBoxQuotaManageList ended.");

		return "json";
	}

	/**
	 * 엑셀 워크시트 생성 및 자동 다운로드 함수
	 */
	@RequestMapping(value = "/admin/ezEmail/statisticsListExcelExport.do", method = RequestMethod.GET)
	@ResponseBody
	public void mailQuotaExcelExport(@CookieValue("loginCookie") String loginCookie, Model model,
			HttpServletRequest request,
			@RequestParam(required = false) String searchKeycode,
			@RequestParam(required = false) String searchKeyword,
			@RequestParam(required = false) String sortColumn,
			@RequestParam(required = false) String sortType,
			@RequestParam(required = false) boolean[] searchFor,
			HttpServletResponse response,
			Locale locale) throws Exception {
		logger.debug("mailQuotaExcelExport started.");

		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);

		if (userInfo == null) return;

		String companyId = request.getParameter("companyId");
		String currPage = request.getParameter("pageNum");

		int maxItemPerPage = 20;
		int startRow = Math.multiplyExact(Math.subtractExact(Integer.parseInt(currPage), 1), maxItemPerPage);
		
		if ("-1".equalsIgnoreCase(currPage)) {
			startRow = -1;
		}
		
		int dbName = "mysql".equals(globals.getProperty("Globals.DbType")) ? 1 : 2;
   		searchKeyword = commonUtil.getWildcardEscapedString(searchKeyword != null ? searchKeyword : "", dbName);

		// 모든 사용자의 목록을 가져온다.
		List<OrganUserVO> userCnList = ezOrganAdminService.getUserList(Integer.valueOf(userInfo.getTenantId()), 
									   startRow, maxItemPerPage, (searchKeycode != null ? searchKeycode : ""), (searchKeyword != null ? searchKeyword : ""), companyId, (sortColumn != null ? sortColumn : ""), (sortType != null ? sortType : ""), searchFor);

		if (userCnList != null){

			int totalCount = ezOrganAdminService.getUserCount(userInfo.getTenantId(), searchKeycode, searchKeyword, searchFor, companyId);

			List<ArrayList<String>> userList = new ArrayList<ArrayList<String>>();

			boolean primaryChk = userInfo.getPrimary().equals("1") ? true : false;

			// 각 사용자별로 처리한다.
			for (OrganUserVO organUser : userCnList) {
				List<String> quaList = new ArrayList<String>();
				String userId = organUser.getCn();
				String department = primaryChk ? organUser.getDescription() : organUser.getDescription2();
				String displayname = primaryChk ? organUser.getDisplayName() : organUser.getDisplayName2();
				displayname = displayname + "(" + userId + ")";

				quaList.add(0, userId);
				quaList.add(1, displayname);
				quaList.add(2, department);

				String mailboxUsage = String.valueOf(organUser.getMailboxUsage() != null ? Long.parseLong(organUser.getMailboxUsage()) / 1024 : 0);
				String mailboxQuota = String.valueOf(organUser.getMailboxQuota() != null ? Long.parseLong(organUser.getMailboxQuota()) / 1024 : 0);

				quaList.add(3, mailboxUsage);
				quaList.add(4, mailboxQuota);
				userList.add((ArrayList<String>) quaList);
			}

			/* 엑셀 만들기 */
			try (HSSFWorkbook workbook = new HSSFWorkbook()) {
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
				cell.setCellValue(egovMessageSource.getMessage("main.t252",locale) + " " + totalCount +
						egovMessageSource.getMessage("ezSystem.kyj2",locale));

				row = sheet.createRow(1);
				cell = row.createCell(0);
				cell.setCellValue(egovMessageSource.getMessage("ezEmail.lsd04",locale));
				cell.setCellStyle(headerStyle);
				cell = row.createCell(1);
				cell.setCellValue(egovMessageSource.getMessage("ezStatistics.t113",locale));
				cell.setCellStyle(headerStyle);
				cell = row.createCell(2);
				cell.setCellValue(egovMessageSource.getMessage("ezEmail.lsd02",locale));
				cell.setCellStyle(headerStyle);
				cell = row.createCell(3);
				cell.setCellValue(egovMessageSource.getMessage("ezEmail.lsd03",locale));
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

				logger.debug("mailQuotaExcelExport controller ended.");
			}
		}
	}
	
	/**
	 * 공유사서함관리 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezEmail/showSharedMailboxList.do", method = RequestMethod.GET)
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
	@RequestMapping(value = "/admin/ezEmail/getSharedMailboxList.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
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
		} catch (UnsupportedEncodingException e) {
			logger.error(e.getMessage(), e);
		} catch (Exception e) {
			returnData = "ERROR";
			logger.error(e.getMessage(), e);
		}

		logger.debug("getSharedMailboxList ended.");
		return returnData;
	}
	
	/**
	 * 공유사서함 정보 호출 함수
	 */
	@RequestMapping(value = "/admin/ezEmail/getSharedMailboxInfo.do", method = RequestMethod.POST)
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
			String lang = auth.getPrimary();
			int tenantId = auth.getTenantId();
			logger.debug("userId={}, shareId={}, tenantId={}, lang={}", userId, shareId, tenantId, lang);
			
			MailSharedMailboxVO sharedMailboxInfo = ezEmailService.getSharedMailboxInfo(shareId, auth.getTenantId(), lang);
			
			model.addAttribute("sharedMailboxInfo", sharedMailboxInfo);
		} catch (UnsupportedEncodingException e) {
			logger.error(e.getMessage(), e);
		} catch (Exception e) {
			resultCode = "ERROR";
			logger.error(e.getMessage(), e);
		}

		model.addAttribute("resultCode", resultCode);
		
		logger.debug("getSharedMailboxInfo ended.");
		return "json";
	}
	

	/**
	 * 공유사서함 삭제 실행 함수
	 */
	@RequestMapping(value = "/admin/ezEmail/delSharedMailbox.do", method = RequestMethod.POST)
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
			
			if (userExists == 0 && shareId != null) { // 이메일 계정이 존재하지 않음.
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
							
				// String bizmekaResult = "ERROR";
				
				try {
					/* 비즈메카 연동은 우선 생각하지 않는다. -> 필요할 때 논의 후 구현!
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
					*/
										
					// 로컬 시스템 계정을 삭제한다.
					if (shareId != null){
						ezOrganAdminService.deleteDBData(shareId, "user", tenantId);
					}
				} catch (RuntimeException e) {
					logger.debug(e.getMessage(), e);
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
				rc = ezEmailUserAdminService.removeUser(mailAddr);
				logger.debug("removeUser rc=" + rc);
				
				// 해당 사용자의 메일박스들을 모두 제거한다.
				rc = ezEmailUserAdminService.removeUserAllMailboxes(mailAddr);
				logger.debug("removeUserAllMailboxes rc=" + rc);
				
				// 해당 사용자의 개인주소록 및 주소록 관련 설정을 모두 제거한다.
				rc = ezAddressService.removeUserAddress(mailAddr);
				logger.debug("removeUserAddress rc=" + rc);
			}
		
		} catch (NullPointerException e) {
			logger.debug(e.getMessage(), e);
		} catch (Exception e) {
			resultCode = "ERROR";
			logger.error(e.getMessage(), e);
		}
		
		model.addAttribute("resultCode", resultCode);
		
		logger.debug("delSharedMailbox ended. resultCode=" + resultCode);
		return "json";
	}
	
	/**
	 * 공유사서함 추가 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezEmail/showAddSharedMailbox.do", method = RequestMethod.GET)
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
		
		String companyDomainList = ezCommonService.getCompanyConfig(tenantId, compId, "MailInnerDomain");
		String[] domainList = companyDomainList.split(";");
		logger.debug("mailDomain=" + mailDomain + ", companyDomainList=" + companyDomainList);
		
		String companyMailDomain = mailDomain;
		String sharedMailboxMail = "";
		if (shareId != null && !shareId.equals("")) { // 편집일 경우
			OrganUserVO sharedMailbox = ezOrganAdminService.getUserInfo(shareId, auth.getPrimary(), tenantId);
			sharedMailboxMail = sharedMailbox.getMail();
			companyMailDomain = sharedMailboxMail.split("@")[1];
		}
		logger.debug("sharedMailboxMail=" + sharedMailboxMail);
		
		model.addAttribute("shareId", shareId);
		model.addAttribute("deptId", deptId);
		model.addAttribute("compId", compId);
		model.addAttribute("mailDomain", mailDomain);
		model.addAttribute("domainList", domainList);
		model.addAttribute("sharedMailboxMail", sharedMailboxMail);
		model.addAttribute("companyMailDomain", companyMailDomain);
		
		logger.debug("showAddSharedMailbox ended.");
		return "admin/ezEmail/addSharedMailbox";
	}
	
	/**
	 * 공유사서함 추가 실행 함수
	 */
	@RequestMapping(value = "/admin/ezEmail/addSharedMailbox.do", method = RequestMethod.POST)
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
			String oriPass = (String)jsonObj.get("password");
			JSONArray userList = (JSONArray)jsonObj.get("userList");
			int userListSize = userList.size();
			String selectDomain = (String)jsonObj.get("selectDomain");
			logger.debug("shareId=" + shareId + ",shareName=" + shareName + ",compId=" + compId + ",userListSize=" + userListSize + ", selectDomain=" + selectDomain);
			
			int tenantId = auth.getTenantId();
			String domain = ezCommonService.getTenantConfig("DomainName", tenantId);
			String companyDomain = ezCommonService.getCompanyConfig(tenantId, compId, "DomainName");
			logger.debug("tenantId=" + tenantId + ",domain=" + domain + ",companyDomain=" + companyDomain); 
			
			String setDomain = !selectDomain.equals("") ? selectDomain : companyDomain;
			logger.debug("##### setDomain=" + setDomain);
			
			// 공유사서함 부서가 존재하는지 확인
			String deptId = "shared_mailbox_" + compId;
			OrganDeptVO deptVO = ezOrganService.getDeptInfo(deptId, auth.getPrimary(), tenantId);
			
			// 공유사서함 부서가 없으면 생성
			if (deptVO == null) {
				String deptName = egovMessageSource.getMessage("ezEmail.sharedMailbox02", locale);
				String mailAddr = deptId + "@" + domain;
				
				int rc = ezEmailUserAdminService.addGroup(mailAddr);
				
				if (rc == 0) { // addGroup 성공
					// String bizmekaResult = "ERROR";
					
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
						
					} catch (RuntimeException e) {
						logger.error(e.getMessage(), e);
					} catch (Exception e) {
						logger.error(e.getMessage(), e);
						
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
			
			if (!setDomain.isEmpty() && !setDomain.equals(domain)) { 
				String newMailAddr = shareId + "@" + setDomain;				
				String returnValue = ezEmailService.checkIndividualAlias(newMailAddr, tenantId);
				
				if (!returnValue.equals("OK")) {
					logger.debug("create sharedMailbox account failed. '" + shareId + "' ID is already used.");
					resultCode = "DUPLICATE";
					
					model.addAttribute("resultCode", resultCode);
					logger.debug("addSharedMailbox ended. resultCode=" + resultCode);
					return "json";					
				}
			}			
			
			String mailAddr = shareId + "@" + domain;
			
			// 이메일 시스템에 계정을 생성한다.
			int rc = ezEmailUserAdminService.addUser(mailAddr, oriPass);
			logger.debug("addUser rc=" + rc);
			
			// [국립암센터] POP3/IMAP 사용 설정
			String usePOP3Default = ezCommonService.getTenantConfig("usePOP3Default", auth.getTenantId());
			String useIMAPDefault = ezCommonService.getTenantConfig("useIMAPDefault", auth.getTenantId());

			JgwResult jgwResult = rest.jgw().url("/jMochaEzEmail/setPOP3IMAPConfig")
					.formParam("user_name", mailAddr)
					.formParam("usePOP3Default", usePOP3Default)
					.formParam("useIMAPDefault", useIMAPDefault)
					.exchangeJgwResult();

			if (rc == 0) { // addUser 성공
				// 해당 User가 속한 부서의 Group Email 주소에 User를 등록한다.
				String groupAddr = deptId + "@" + domain;
				rc = ezEmailUserAdminService.updateGroupAdd(groupAddr, mailAddr);
				logger.debug("updateGroupAdd rc=" + rc);
				
				if (rc == 0) { // updateGroup 성공
					// String bizmekaResult = "ERROR";
					
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
					} catch (RuntimeException e){
						logger.error(e.getMessage(), e);
					} catch (Exception e) { // Exception이 발생하면 취소 처리를 한다.
						logger.error(e.getMessage(), e);
						
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
				// 2021-12-16 이사라 : 오류 메시지 분리
				if (rc == -2) {			// -2 : alias 이메일과 중복,
					resultCode = "ALIAS_EMAIL_DUPLICATE";
				} else if (rc == -1) {	// -1 : 사용자 이메일 중복 (tbl_usermaster와 중복체크)
					resultCode = "EMAIL_DUPLICATE";
				} else {
					resultCode = "EMAIL_ERROR";
				}
				model.addAttribute("resultCode", resultCode);
				logger.debug("addSharedMailbox ended. resultCode=" + resultCode);
				return "json";
			}
			
			// 회사별 이메일 도메인명이 설정되어 있으면 tbl_tenant_config에 있는 DomainName 대신에
			// 해당 도메인명을 사용해 이메일 주소를 생성한다.
			String companyDomainName = ezCommonService.getCompanyConfig(tenantId, compId, "DomainName");
			logger.debug("companyDomainName=" + companyDomainName);
			logger.debug("setDomain=" + setDomain);

			if (!setDomain.isEmpty() && !setDomain.equals(domain)) {
				String newMailAddr = shareId + "@" + setDomain;
				
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
			
		} catch (ParseException e) {
			logger.error(e.getMessage(), e);
		} catch (Exception e) {
			resultCode = "ERROR";
			logger.error(e.getMessage(), e);
		}
		
		model.addAttribute("resultCode", resultCode);
		
		logger.debug("addSharedMailbox ended. resultCode=" + resultCode);
		return "json";
	}
	
	/**
	 * 공유사서함 수정 실행 함수
	 */
	@RequestMapping(value = "/admin/ezEmail/modSharedMailbox.do", method = RequestMethod.POST)
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
			
		} catch (ParseException e) {
			logger.error(e.getMessage(), e);
		} catch (Exception e) {
			resultCode = "ERROR";
			logger.error(e.getMessage(), e);
		}
		
		model.addAttribute("resultCode", resultCode);
		
		logger.debug("modSharedMailbox ended. resultCode=" + resultCode);
		return "json";
	}
	
	@SuppressWarnings("unused")
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
		} catch (RuntimeException e) {
			logger.error(e.getMessage(), e);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
	}
	
	/**
	 * 공유사서함 조건별 검색
	 */
	@RequestMapping(value = "/admin/ezEmail/getSharedMailboxListSearchByItem.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getSharedMailboxListSearch(@CookieValue("loginCookie") String loginCookie, Locale locale, HttpServletRequest request, Model model) throws Exception {
		logger.debug("getSharedMailboxListSearch started.");
		
		String returnData = "";
		
		try {
			// 관리자 권한체크
			LoginVO auth = commonUtil.checkAdmin(loginCookie);
			
			if (auth == null) {
				returnData = "NO_PERMISSION";
				logger.debug("getSharedMailboxListSearch ended. returnData=" + returnData);
				
				return returnData;
			}
			
			String userId = auth.getId();
			String compId = request.getParameter("compId");
			int tenantId = auth.getTenantId();
			String searchType = request.getParameter("searchType");
			String searchValue = request.getParameter("searchValue");
			logger.debug("userId=" + userId + ",compId=" + compId + ",tenantId=" + tenantId + ",searchType=" + searchType 
					+ ",searchValue=" + searchValue);
			
			List<MailSharedMailboxVO> sharedMailboxList = ezEmailService.getSharedMailboxListSearchByItem(compId, auth.getTenantId(), searchType, searchValue);
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
		} catch (UnsupportedEncodingException e) {
			logger.error(e.getMessage(), e);
		} catch (Exception e) {
			returnData = "ERROR";
			logger.error(e.getMessage(), e);
		}

		logger.debug("getSharedMailboxListSearch ended.");
		return returnData;
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
		} catch (IndexOutOfBoundsException e) {
			logger.error(e.getMessage(), e);
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
			if (ia != null){
				ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
						userEmail, password, egovMessageSource, locale, ezEmailUtil);

				// 기본 폴더들이 없을 때 생성한다.
				ia.getTopLevelFolders(true, false);
			}
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
	@RequestMapping(value = "/admin/ezEmail/signatureMain.do", method = RequestMethod.GET)
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

			if (userInfo.getRollInfo().contains("c=1") || userInfo.getRollInfo().contains("k=1") && vo.getCn().equals(userInfo.getCompanyID())) {
				resultList.add(vo);
			}

		}

		model.addAttribute("list", resultList);
		model.addAttribute("userLang", userInfo.getPrimary());
		model.addAttribute("userInfo", userInfo);

		logger.debug("signatureMainView ended.");

		return "admin/ezEmail/signatureMain";

	}
	
	/**
	 * 서명 템플릿 목록 조회
	 * 
	 * @param companyId
	 * @return : JSONArray
	 */
	@RequestMapping(value = "/admin/ezEmail/readSignList.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONArray readSignList(@CookieValue("loginCookie") String loginCookie, String companyId, HttpServletResponse response, Model model) throws Exception {
		logger.debug("readSignList started.");
		logger.debug("companyId=" + companyId);
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		JSONArray returnJsonArr = new JSONArray();

		try {
			returnJsonArr = ezEmailService.selectAllSignatureTemplate(companyId, Integer.toString(userInfo.getTenantId()));
			logger.debug("jsonArr=" + returnJsonArr);
		} catch (UnsupportedEncodingException e) {
			logger.error(e.getMessage(), e);
		} catch (Exception e) {
			logger.debug("e.message=" + e.getMessage());
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
	@RequestMapping(value = "/admin/ezEmail/searchSignList.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONArray searchSignList(@CookieValue("loginCookie") String loginCookie, String companyId, String search, HttpServletResponse response, Model model) throws Exception {
		logger.debug("searchSignList started.");
		search = URLDecoder.decode(search, "UTF-8");
		logger.debug("companyId=" + companyId);
		logger.debug("search=" + search);
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		JSONArray returnJsonArr = new JSONArray();

		try {
			returnJsonArr = ezEmailService.selectSearchSignatureTemplate(companyId, Integer.toString(userInfo.getTenantId()), search, userInfo.getPrimary());
			logger.debug("jsonArr=" + returnJsonArr);
		} catch (RuntimeException e) {
			logger.debug("e.message=" + e.getMessage());
		} catch (Exception e) {
			logger.debug("e.message=" + e.getMessage());
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
	@RequestMapping(value = "/admin/ezEmail/deleteSignTemplate.do", method = RequestMethod.POST)
	@ResponseBody
	public void deleteSignTemplate(@CookieValue("loginCookie") String loginCookie, String signNo, HttpServletResponse response, Model model) throws Exception {
		logger.debug("deleteSignTemplate started.");
		logger.debug("signNo=" + signNo);

		try {
			ezEmailService.deleteSignatureTemplate(signNo);
		} catch (UnsupportedEncodingException e) {
			logger.debug(e.getMessage(), e);
		} catch (Exception e) {
			 logger.error(e.getMessage(), e);
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
	@RequestMapping(value = "/admin/ezEmail/signaturePreview.do", method = RequestMethod.POST)
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
			
		} catch (IndexOutOfBoundsException e) {
			logger.debug("e.message=" + e.getMessage());
		} catch (Exception e) {
			logger.debug("e.message=" + e.getMessage());
		}
		
		logger.debug("signaturePreview ended.");
		return returnJsonArr;
	}
	
	/**
	 * 서명 템플릿 추가,수정 팝업 화면
	 */
	@RequestMapping(value = "/admin/ezEmail/signEditPopUp.do", method = RequestMethod.GET)
	public String signEditPopUp(
			@CookieValue("loginCookie") String loginCookie, Locale locale, String paramSignNo, String type, String companyId, Model model) throws Exception {
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
				
			} catch (IndexOutOfBoundsException e) {
				logger.debug("e.message=" + e.getMessage());
			} catch (Exception e) {
				logger.debug("e.message=" + e.getMessage());
			}
		} 
		
		String primary = ezCommonService.getTenantConfig("LangPrimary" + userInfo.getLang(), userInfo.getTenantId());
		String secondary = ezCommonService.getTenantConfig("LangSecondary" + userInfo.getLang(), userInfo.getTenantId());
		
		model.addAttribute("editor", ezCommonService.getTenantConfig("EDITOR",userInfo.getTenantId()));
		model.addAttribute("defaultFontAndSize", defaultFontAndSize);
		model.addAttribute("signNo", signNo);
		model.addAttribute("content", content);
		model.addAttribute("displayname", displayname);
		model.addAttribute("displayname2", displayname2);
		model.addAttribute("type", type);
		model.addAttribute("companyId", companyId);
		model.addAttribute("primary", primary);
		model.addAttribute("secondary", secondary);

		logger.debug("signNo=" + signNo + ", content=" + content + ", displayname=" + displayname + ", displayname2=" + displayname2);
		logger.debug("signEditPopUp ended.");
		return "admin/ezEmail/signatureEditPopUp";
	}
	
	/**
	 * 서명 템플릿 추가
	 * 
	 * @param String loginCookie, Model model
	 */
	@RequestMapping(value = "/admin/ezEmail/setSignatureTemplate.do", method = RequestMethod.POST)
	@ResponseBody
	public void setSignatureTemplate(@CookieValue("loginCookie") String loginCookie, @ModelAttribute MailSignatureTemplateVO signTemplate, String type, String companyId) throws Exception {
		logger.debug("setSignatureTemplate started.");
		logger.debug("signTemplate=" + signTemplate);
		logger.debug("type=" + type + ", companyId=" + companyId);
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		if (companyId == null || companyId.equals("")) {
			companyId = userInfo.getCompanyID();
		}
		
		try {
			if (type != null && type.equals("add")) {
				signTemplate.setCompanyId(companyId);
				signTemplate.setTenantId(Integer.toString(userInfo.getTenantId()));
				ezEmailService.addSignatureTemplate(signTemplate);
			} else {
				ezEmailService.setSignatureTemplate(signTemplate);
			}
			
		} catch (RuntimeException e) {
			 logger.error(e.getMessage(), e);	
		} catch (Exception e) {
			 logger.error(e.getMessage(), e);
		}

		logger.debug("setSignatureTemplate ended.");

	}
	
	/**
	 * 서명 템플릿 미리보기
	 * 
	 * @param String loginCookie, Model model
	 */
	@RequestMapping(value = "/admin/ezEmail/signaturePreviewContent.do", method = RequestMethod.POST)
	public String signaturePreviewContent(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		logger.debug("signaturePreviewContent started.");
		
		// 관리자 권한체크
		LoginVO auth = commonUtil.checkAdmin(loginCookie);
		if (auth == null) {
			return "cmm/error/adminDenied";
		}
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		OrganUserVO vo = ezOrganAdminService.getUserInfo(userInfo.getId(), "1", userInfo.getTenantId());
		
		JsonObject jsonObj = new JsonObject();
		jsonObj.addProperty("name", vo.getDisplayName1());
		jsonObj.addProperty("engName", vo.getDisplayName2());
		jsonObj.addProperty("email", vo.getMail());
		jsonObj.addProperty("company", vo.getCompany1());
		jsonObj.addProperty("engCompany", vo.getCompany2());
		jsonObj.addProperty("department", vo.getDescription1());
		jsonObj.addProperty("title", vo.getTitle1() == null ? "" : vo.getTitle1());
		jsonObj.addProperty("position", vo.getExtensionAttribute101() == null ? "" : vo.getExtensionAttribute101());
		jsonObj.addProperty("officePhone", vo.getTelephoneNumber() == null ? "" : vo.getTelephoneNumber());
		jsonObj.addProperty("homePhone", vo.getHomePhone() == null ? "" : vo.getHomePhone());
		jsonObj.addProperty("fax", vo.getFacsimileTelephoneNumber() == null ? "" : vo.getFacsimileTelephoneNumber());
		jsonObj.addProperty("mobile", vo.getMobile() == null ? "" : vo.getMobile());
		jsonObj.addProperty("zipCode", vo.getPostalCode() == null ? "" : vo.getPostalCode());
		jsonObj.addProperty("address", vo.getStreetAddress() == null ? "" : vo.getStreetAddress());
		jsonObj.addProperty("birth", vo.getBirth() == null ? "" : vo.getBirth());
		jsonObj.addProperty("empNo", vo.getExtensionAttribute14() == null ? "" : vo.getExtensionAttribute14());

		model.addAttribute("userObj", jsonObj);
		
		logger.debug("signaturePreviewContent ended.");
		return "admin/ezEmail/signaturePreview";

	}

	/**
	 * 수취인안내설정 관리 화면(copyright)
	 * 
	 */
	@RequestMapping(value = "/admin/ezEmail/mailCopyright.do", method = RequestMethod.GET)
	public String mailCopyright(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		logger.debug("mailCopyright started.");
		
		// 관리자 권한체크
		LoginVO auth = commonUtil.checkAdmin(loginCookie);
		if (auth == null) {
			return "cmm/error/adminDenied";
		}
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		List<OrganDeptVO> list = ezOrganAdminService.getCompanyList(userInfo.getPrimary(), userInfo.getTenantId());
		List<OrganDeptVO> resultList = new ArrayList<OrganDeptVO>();

		for (int i = 0; i < list.size(); i++) {
			OrganDeptVO vo = list.get(i);

			if (userInfo.getRollInfo().contains("c=1") || userInfo.getRollInfo().contains("k=1") && vo.getCn().equals(userInfo.getCompanyID())) {
				resultList.add(vo);
			}
		}
		
		model.addAttribute("companyId", userInfo.getCompanyID());
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("list", resultList);
		
		logger.debug("mailCopyright ended.");
		return "admin/ezEmail/mailCopyright";
	}
	
	/**
	 * 수취인안내설정 데이터 가져오기(copyright)
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/admin/ezEmail/mailCopyrightData.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject mailCopyrightData(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		logger.debug("mailCopyrightData started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String companyId = request.getParameter("companyId");
		logger.debug("companyId=" + companyId);
		
		String useCopyright =  ezCommonService.getCompanyConfig(userInfo.getTenantId(), companyId, "useCopyright"); // 수취인안내설정 사용여부
		
		if (useCopyright.equals("")) {
			useCopyright = "NO";
		}
		
		logger.debug("useCopyright=" + useCopyright);
		
		String copyrightText = ezEmailUserAdminService.getCopyrightText(userInfo.getTenantId(), companyId);
		
		if (copyrightText == null) {
			copyrightText = "";
		}
		
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("useCopyright", useCopyright);
		jsonObj.put("copyrightText", copyrightText);

		logger.debug("mailCopyrightData ended.");
		return jsonObj;
	}
	
	/**
	 * 수취인안내설정 저장(copyright)
	 * 
	 */
	@RequestMapping(value = "/admin/ezEmail/mailCopyrightSave.do", method = RequestMethod.POST)
	@ResponseBody
	public String mailCopyrightSave(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		logger.debug("mailCopyrightSave started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String copyrightText = request.getParameter("copyrightText");
		String useCopyright = request.getParameter("useCopyright");
		String companyId = request.getParameter("companyId");
		String returnValue = "ERROR";
		
		int rc = ezEmailUserAdminService.saveMailCopyright(copyrightText, useCopyright, userInfo.getTenantId(), companyId);
		
		if (rc == 0) {
			returnValue = "OK";
		}
		
		logger.debug("mailCopyrightSave ended.");
		return returnValue;
	}
	
	/**
	 * 전체 도메인 관리 화면 
	 */
	@RequestMapping(value = "/admin/ezEmail/multiDomain.do")
	public String multiDomainMain(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		logger.debug("multiDomainMain started.");
		
		// 전체 권한체크
		LoginVO user = commonUtil.userInfo(loginCookie);
		if (user.getRollInfo().indexOf("c=1") == -1) {
			return "cmm/error/adminDenied";
		}
		
		logger.debug("multiDomainMain ended.");
		return "admin/ezEmail/multiDomainMain";
	}
	
	/**
	 * 전체 도메인 추가 팝업 화면
	 */
	@RequestMapping(value = "/admin/ezEmail/addMultiDomainPopUp.do")
	public String addMultiDomainPopUp(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		logger.debug("addMultiDomainMainPopUp started.");
		
		// 전체 권한체크
		LoginVO user = commonUtil.userInfo(loginCookie);
		if (user.getRollInfo().indexOf("c=1") == -1) {
			return "cmm/error/adminDenied";
		}
		
		logger.debug("addMultiDomainMainPopUp ended.");
		return "admin/ezEmail/addMultiDomainPopUp";
	}
	

	/**
	 * 전체 도메인 리스트
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/admin/ezEmail/getMultiDomainList.do")
	@ResponseBody
	public JSONObject getMultiDomainList(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		logger.debug("getMultiDomainList started.");
		
		LoginVO user = commonUtil.userInfo(loginCookie);
		int tenantId = user.getTenantId();
		String innerDomain = ezEmailService.getMultiDomainList(tenantId);
		String tenantDomain = ezCommonService.getTenantConfig("DomainName", tenantId);
		
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("innerDomain", innerDomain);
		jsonObj.put("tenantDomain", tenantDomain);
		
		logger.debug("getMultiDomainList ended.");
		return jsonObj;
	}
	
	/**
	 * 전체 도메인 추가
	 */
	@RequestMapping(value = "/admin/ezEmail/addMultiDomain.do")
	@ResponseBody
	public int addMultiDomain(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		logger.debug("addMultiDomain started.");
		
		LoginVO user = commonUtil.userInfo(loginCookie);
		int tenantId = user.getTenantId();
		String domain = request.getParameter("domain");
		
		int reasonCode = ezEmailService.addMultiDomain(tenantId, domain);

		logger.debug("addMultiDomain ended.");
		return reasonCode;
	}

	/**
	 * 전체 도메인 삭제
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/admin/ezEmail/delMultiDomain.do")
	@ResponseBody
	public JSONObject delMultiDomain(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		logger.debug("delMultiDomain started.");
		
		LoginVO user = commonUtil.userInfo(loginCookie);
		int tenantId = user.getTenantId();
		String delDomain = request.getParameter("delDomain");
		String saveDomainList = request.getParameter("saveDomainList");
		
		int reasonCode = 0;
		
		List<OrganDeptVO> companylist = ezOrganAdminService.getCompanyList(user.getPrimary(), tenantId);
		String propertyName = "MailInnerDomain";
		
		String resultCompany = "";
		for(OrganDeptVO companyVO : companylist) {
			String companyId = companyVO.getCn();
			String companyName = companyVO.getDisplayName();
			String innerDomainList = ezEmailService.getCompanyConfig(tenantId, companyId, propertyName);
			logger.debug("companyId=" + companyId + "companyName=" + companyName + ", innerDomainList=" + innerDomainList);
			
			String[] innerDomainArr = innerDomainList.split(";");
			
			for (String innerDomain : innerDomainArr) {
				if (delDomain != null && delDomain.equals(innerDomain)) {
					logger.debug("companyName=" + companyName);
					reasonCode = 1;
					resultCompany += resultCompany.equals("") ? companyName : ", " + companyName;
					break;
				}
			}
		}

		if (reasonCode == 0) {
			reasonCode = ezEmailService.delMultiDomain(tenantId, delDomain, saveDomainList);
		}
		
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("reasonCode", reasonCode);
		jsonObj.put("result", resultCompany);
		
		logger.debug("delMultiDomain ended.");
		return jsonObj;
	}
	
	/**
	 * 회사 도메인 관리 화면
	 */
	@RequestMapping(value = "/admin/ezEmail/companyMultiDomain.do")
	public String companyMultiDomain(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		logger.debug("companyMultiDomain started.");
		
		// 관리자 권한체크
		LoginVO auth = commonUtil.checkAdmin(loginCookie);
		LoginVO user = commonUtil.userInfo(loginCookie);
		if (auth == null) {
			return "cmm/error/adminDenied";
		}
		
		String companyId = user.getCompanyID();
		List<OrganDeptVO> companylist = ezOrganAdminService.getCompanyList(user.getPrimary(), user.getTenantId());
   		List<OrganDeptVO> resultList = new ArrayList<OrganDeptVO>();
		
		for (int i = 0; i < companylist.size(); i++) {
			OrganDeptVO vo = companylist.get(i);			
			
			if (user.getRollInfo().indexOf("c=1") > -1 || (user.getRollInfo().indexOf("k=1") > -1 && vo.getCn().equals(user.getCompanyID()))) {
				resultList.add(vo);
			}
		}

		model.addAttribute("companyId", companyId);
		model.addAttribute("companylist", resultList);
		
		logger.debug("companyMultiDomain started.");
		return "admin/ezEmail/companyMultiDomainMain";
	}
	
	/**
	 * 회사 도메인 리스트
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/admin/ezEmail/getCompanyMultiDomainList.do")
	@ResponseBody
	public JSONObject getCompanyMultiDomainList(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		logger.debug("getCompanyMultiDomainList started.");
		
		LoginVO user = commonUtil.userInfo(loginCookie);
		int tenantId = user.getTenantId();
		String companyId = request.getParameter("companyId");
		companyId = companyId == null ?  user.getCompanyID() : companyId;
		
		String innerDomain = ezEmailService.getCompanyConfig(tenantId, companyId, "MailInnerDomain");
		String primaryDomain = ezEmailService.getCompanyConfig(tenantId, companyId, "DomainName");
		
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("primaryDomain", primaryDomain);
		jsonObj.put("innerDomain", innerDomain);
		
		logger.debug("getCompanyMultiDomainList ended.");
		return jsonObj;
	}
	
	/**
	 * 회사 도메인 저장
	 */
	@RequestMapping(value = "/admin/ezEmail/saveCompanyMultiDomain.do")
	@ResponseBody
	public int saveCompanyMultiDomain(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		logger.debug("saveCompanyMultiDomain started.");
		
		LoginVO user = commonUtil.userInfo(loginCookie);
		int tenantId = user.getTenantId();
		String companyId = request.getParameter("companyId");
		companyId = companyId == null ?  user.getCompanyID() : companyId;
		String primaryDomain = request.getParameter("primaryDomain");
		String saveDomainList = request.getParameter("saveDomainList");
		
		int reasonCode = ezEmailService.saveCompanyMultiDomain(tenantId, companyId, primaryDomain, saveDomainList);

		logger.debug("saveCompanyMultiDomain ended.");
		return reasonCode;
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

	/**
	 * 조직도관리 메인화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezEmail/adminMailMain.do", method = RequestMethod.GET)
	public String organMain(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception{
		logger.debug("adminMailMain started.");
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);

		if (userInfo == null) {
			logger.debug("portalMain accessDenied.");
			return "cmm/error/adminDenied";
		} else {
			logger.debug("adminMailMain ended.");
			return "admin/ezEmail/adminMailMain";
		}
	}
	
	/**
	 * 조직도관리 왼쪽화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezEmail/adminMailLeft.do", method = RequestMethod.GET)
	public String organLeft(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		LoginVO user = commonUtil.userInfo(loginCookie);
		String dotNetIntegration = ezCommonService.getTenantConfig("dotNetIntegration", user.getTenantId());
		String cChk = "0";
		String kChk = "0";
		
		if (user.getRollInfo().indexOf("c=1") != -1) { // 전체 관리자
			cChk = "1";
		}
		
		if (user.getRollInfo().indexOf("k=1") != -1) { // 회사 관리자
			kChk = "1";
		}
		
		// set useLetter
		String useLetter = ezCommonService.getTenantConfig("useLetter", user.getTenantId());
		if (useLetter == null || useLetter.equals("")) {
			useLetter = "NO";
		}
				
		logger.debug("useLetter=" + useLetter);
		
		String useSignatureTemplate = ezCommonService.getTenantConfig("useSignatureTemplate", user.getTenantId());
		if (useSignatureTemplate == null || useSignatureTemplate.equals("")) {
			useSignatureTemplate = "NO";
		}
		
		logger.debug("useSignatureTemplate=" + useSignatureTemplate);
		
		String useCopyrightMenu = ezCommonService.getTenantConfig("useCopyrightMenu", user.getTenantId());
		if (useCopyrightMenu.equals("")) {
			useCopyrightMenu = "NO";
		}
		logger.debug("useCopyrightMenu=" + useCopyrightMenu);
		
		String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", user.getTenantId());
		boolean useApprMail = commonUtil.checkTenantConfigBool(user.getTenantId(), "useApprMail", "false");

		String UseDisablePopImap = ezCommonService.getTenantConfig("UseDisablePopImap", user.getTenantId());
		
		model.addAttribute("dotNetIntegration", dotNetIntegration);
		model.addAttribute("useLetter", useLetter);
		model.addAttribute("useSignatureTemplate", useSignatureTemplate);
		model.addAttribute("useSharedMailbox", useSharedMailbox);
		model.addAttribute("cChk", cChk);
		model.addAttribute("kChk", kChk);
		model.addAttribute("useCopyrightMenu", useCopyrightMenu);
		model.addAttribute("useApprMail", useApprMail);
		model.addAttribute("UseDisablePopImap", UseDisablePopImap);
		model.addAttribute("lang", user.getLang());
		
		return "admin/ezEmail/adminMailLeft";
	}

    /**
     * 승인메일 :
	 * 전체메일승인 메인페이지
	 */
	@RequestMapping(value = {"/admin/ezEmail/appr/allHands/main.do" }, method = RequestMethod.GET)
	public String apprAllHandsMain(@CookieValue("loginCookie")String loginCookie, Model model, HttpServletRequest request) 
			throws Exception {
		logger.debug("apprAllHandsMain started.");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		List<OrganDeptVO> list 			= ezOrganAdminService.getCompanyList(userInfo.getPrimary(), userInfo.getTenantId());
		List<OrganDeptVO> resultList 	= new ArrayList<OrganDeptVO>();

		for (int i = 0; i < list.size(); i++) {
			OrganDeptVO vo = list.get(i);

			if (userInfo.getRollInfo().contains("c=1") || (userInfo.getRollInfo().contains("k=1") && vo.getCn().equals(userInfo.getCompanyID()))) {
				resultList.add(vo);
			}

		}

		model.addAttribute("userInfo", userInfo);
		model.addAttribute("list", resultList);
		
		logger.debug("apprAllHandsMain ended.");
		return "admin/ezEmail/apprAllHandsMain";
	}
	
    /**
     * 승인메일 : 
	 * 전체메일승인 > 승인정책관리 페이지, 메일승인관리 > 승인정책 페이지
	 */
	@RequestMapping(value = {"/admin/ezEmail/appr/allHands/policy.do", "/admin/ezEmail/appr/policy.do"}, method = RequestMethod.GET)
	public String apprPolicy(@CookieValue("loginCookie")String loginCookie, Model model, HttpServletRequest request) throws Exception {
		logger.debug("apprPolicy started.");

		boolean isAllHandsPage = request.getRequestURI().contains("/allHands/");
		logger.debug("isAllHandsPage={}", isAllHandsPage);
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userCompanyId = userInfo.getCompanyID();
		int tenantId = userInfo.getTenantId();
		logger.debug("tenantId={}, userCompanyId={}", tenantId, userCompanyId);
		
		// Parameter ...
		String companyId = StringUtils.defaultIfBlank(request.getParameter("companyId"), userCompanyId);
		logger.debug("companyId={}", companyId);

		Map<String, Object> configMap = new HashMap<String, Object>();
		if (isAllHandsPage) {
			configMap.put("useApprMailAllHands", "UNUSED"); // 전사메일 발송 시 승인기능 사용여부 : USAGE|UNUSED, default:UNUSED
		} else {
			configMap.put("useApprMailOut", "UNUSED"); // 외부로 메일 발송 시 승인기능 사용여부 : USAGE|USAGE_ATTACH|UNUSED, default:UNUSED
			configMap.put("useApprMailIn", "UNUSED"); // 내부로 메일 발송 시 승인기능 사용여부 : USAGE|USAGE_ATTACH|UNUSED, default:UNUSED
		}

		configMap.forEach((k,v) -> {
			try {
				String configValue = StringUtils.defaultIfBlank(ezCommonService.getCompanyConfig(tenantId, companyId, k), (String) v);
				model.addAttribute(k, configValue);
				logger.debug("{}:{}", k, configValue);
			} catch (Exception e) {
				logger.error(e.getMessage(), e);
			}
		});
		
		model.addAttribute("companyId", companyId);
		
		String rePage =  isAllHandsPage ? "admin/ezEmail/apprAllHandsPolicy" : "admin/ezEmail/apprPolicy";
		logger.debug("apprPolicy ended.");
		return rePage;
	}
	
    /**
     * 승인메일 : 
	 * 승인정책 저장
	 */
	@RequestMapping(value = {"/admin/ezEmail/appr/allHands/setPolicy.do", "/admin/ezEmail/appr/setPolicy.do"}, method = RequestMethod.POST)
	@ResponseBody
	public String apprSetPolicy(@CookieValue("loginCookie")String loginCookie, Model model, Locale locale, HttpServletRequest request) throws Exception {
		logger.debug("apprSetPolicy started.");

		boolean isAllHandsPage = request.getRequestURI().contains("/allHands/");
		logger.debug("isAllHandsPage={}", isAllHandsPage);
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		int tenantId = userInfo.getTenantId();
		logger.debug("tenantId={}", tenantId);

		// Parameter ...
		String companyId = request.getParameter("companyId");
		String policyData = request.getParameter("policyData");
		logger.debug("companyId={}, policyData={}", companyId, policyData);
		
		Map<String, String> configMap = new HashMap<String, String>();
		if (isAllHandsPage) {
			configMap.put("ALLHANDS", "useApprMailAllHands");
		} else {
			configMap.put("OUT", "useApprMailOut");
			configMap.put("IN", "useApprMailIn");
		}
		
		Map<String, String> policyDataMap = new ObjectMapper().readValue(policyData,new TypeReference<Map<String,String>> (){});	
		policyDataMap.forEach((k,v) -> {
			String realKey = configMap.get(k);
			logger.debug("{} {}:{}", realKey, k, v);
			
			try {
				// 승인메일 공유사서함 생성 (메일 발송시에도 체크하여 생성하지만 여러 사람이 동시에 생성할 가능성이 있어 동시에 적용할 가능성이 적은 설정변경 시에 생성될 수 있도록 수정, 단 사용함으로 변경할 떄만)
				if (v.toUpperCase().contains("USAGE")) { 
					ezEmailUtil.getApprSharedMailBox(tenantId, locale);
				}
				
				String hasConfig = ezCommonService.getCompanyConfig(tenantId, companyId, realKey);
				
				if (StringUtils.isEmpty(hasConfig))  {
					ezCommonService.insertCompanyConfig(tenantId, companyId, realKey, v);
				} else {
					ezCommonService.updateCompanyConfig(tenantId, companyId, realKey, v);
				}
			} catch (Exception e) {
				logger.error(e.getMessage(), e);
			}
		});
		
		logger.debug("apprSetPolicy ended.");
		return "OK";
    }
	
	/**
	 * 승인메일 : 
	 * 전사승인메일 > 승인대기목록 페이지
	 */
	@RequestMapping(value = {"/admin/ezEmail/appr/allHands/pending.do" }, method = RequestMethod.GET)
	public String apprAllHandsPending(@CookieValue("loginCookie")String loginCookie, @RequestParam String startNum, Model model, HttpServletRequest request)
			throws Exception {
		logger.debug("apprAllHandsPending started.");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		int tenantId = userInfo.getTenantId();
		String userCompanyId = userInfo.getCompanyID();
		String userId = userInfo.getId();
		String lang = userInfo.getLang();
		Locale locale = userInfo.getLocale();
		String type = "pending"; // 대기
		String type2 = "apprCompPending"; // 대기

		// Parameter ...
		String companyId = StringUtils.defaultIfBlank(request.getParameter("companyId"), userCompanyId);
		logger.debug("companyId={}", companyId);
		
		int pageBlockSize = 10;

		// set model
		model.addAttribute("shareId", Globals.APPR_MAIL_SHARED_ID);
		model.addAttribute("lang", userInfo.getLang());
		model.addAttribute("companyId", companyId);
		model.addAttribute("userId", userInfo.getId());
		model.addAttribute("pageBlockSize", pageBlockSize);

		logger.debug("apprAllHandsPending ended.");
		return "admin/ezEmail/apprAllHandsPending";
	}
	
    /**
     * 승인메일 : 
	 * 전사승인메일 > 승인로그 페이지
	 */
	@RequestMapping(value = {"/admin/ezEmail/appr/allHands/completeLog.do" }, method = RequestMethod.GET)
	public String apprAllHandsCompleteLog(@CookieValue("loginCookie")String loginCookie, @RequestParam String startNum, Model model, HttpServletRequest request) 
			throws Exception {
		logger.debug("apprAllHandsCompleteLog started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		int tenantId = userInfo.getTenantId();
		String userCompanyId = userInfo.getCompanyID();
		String userId = userInfo.getId();
		String lang = userInfo.getLang();
		Locale locale = userInfo.getLocale();
		String type = "complete"; // 완료
		String type2 = "apprCompLog"; // 완료

		// Parameter ...
		String companyId = StringUtils.defaultIfBlank(request.getParameter("companyId"), userCompanyId);
		logger.debug("companyId={}", companyId);
		
		int pageBlockSize = 10;

		// set model
		model.addAttribute("shareId", Globals.APPR_MAIL_SHARED_ID);
		model.addAttribute("lang", userInfo.getLang());
		model.addAttribute("companyId", companyId);
		model.addAttribute("userId", userInfo.getId());
		model.addAttribute("pageBlockSize", pageBlockSize);

		logger.debug("apprAllHandsCompleteLog ended.");
		return "admin/ezEmail/apprAllHandsCompleteLog";
	}

    /**
     * 승인메일 :
	 * 메일승인관리 메인페이지
	 */
	@RequestMapping(value = {"/admin/ezEmail/appr/main.do" }, method = RequestMethod.GET)
	public String apprMain(@CookieValue("loginCookie")String loginCookie, Model model, HttpServletRequest request) 
			throws Exception {
		logger.debug("apprMain started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		List<OrganDeptVO> list 			= ezOrganAdminService.getCompanyList(userInfo.getPrimary(), userInfo.getTenantId());
		List<OrganDeptVO> resultList 	= new ArrayList<OrganDeptVO>();

		for (int i = 0; i < list.size(); i++) {
			OrganDeptVO vo = list.get(i);

			if (userInfo.getRollInfo().contains("c=1") || (userInfo.getRollInfo().contains("k=1") && vo.getCn().equals(userInfo.getCompanyID()))) {
				resultList.add(vo);
			}

		}

		model.addAttribute("userInfo", userInfo);
		model.addAttribute("list", resultList);
		
		logger.debug("apprMain ended.");
		return "admin/ezEmail/apprMain";
	}

    /**
     * 승인메일 :
	 * 메일승인관리 > 승인관리자 페이지
	 */
	@RequestMapping(value = {"/admin/ezEmail/appr/manager.do" }, method = RequestMethod.GET)
	public String apprManager(@CookieValue("loginCookie")String loginCookie, Model model, HttpServletRequest request) 
			throws Exception {
		logger.debug("apprManager started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userCompanyId = userInfo.getCompanyID();
		int tenantId = userInfo.getTenantId();
		logger.debug("tenantId={}, userCompanyId={}", tenantId, userCompanyId);

		// Parameter ...
		String companyId = StringUtils.defaultIfBlank(request.getParameter("companyId"), userCompanyId);
		logger.debug("companyId={}", companyId);
		
		model.addAttribute("companyId", companyId);
		
		logger.debug("apprManager ended.");
		return "admin/ezEmail/apprManager";
	}

    /**
     * 승인메일 :
	 * 메일승인관리 > 승인관리자 > 발송허용 도메인 추가 페이지
	 */
	@RequestMapping(value = {"/admin/ezEmail/appr/allowDomainPopUp.do" }, method = RequestMethod.GET)
	public String allowDomainPopUp(@CookieValue("loginCookie")String loginCookie, Model model, HttpServletRequest request) 
			throws Exception {
		logger.debug("allowDomainPopUp started.");
		logger.debug("allowDomainPopUp ended.");
		return "admin/ezEmail/apprAllowDomainPopUp";
	}
	
	/**
     * 승인메일 :
	 * 발송허용 도메인 리스트 가져오기
	 */
	@RequestMapping(value = {"/admin/ezEmail/appr/getAllowDomainList.do" }, method = RequestMethod.POST)
	@ResponseBody
	public List<String> apprGetAllowDomainList(@CookieValue("loginCookie")String loginCookie, Model model, HttpServletRequest request) 
			throws Exception {
		logger.debug("apprGetAllowDomainList started.");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		int tenantId = userInfo.getTenantId();
		logger.debug("tenantId={}", tenantId);

		// Parameter ...
		String companyId = request.getParameter("companyId");
		logger.debug("companyId={}", companyId);
		
		List<String> allowedDomainList = ezEmailService.getApprAllowedDomainList(tenantId, companyId);
		logger.debug("allowed={}", allowedDomainList);
		
		logger.debug("apprGetAllowDomainList ended.");
		return allowedDomainList;
	}

    /**
     * 승인메일 :
	 * 발송허용 도메인 추가
	 */
	@RequestMapping(value = {"/admin/ezEmail/appr/addAllowDomain.do" }, method = RequestMethod.POST)
	@ResponseBody
	public String apprAddAllowDomain(@CookieValue("loginCookie")String loginCookie, Model model, HttpServletRequest request) 
			throws Exception {
		logger.debug("apprAddAllowDomain started.");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		int tenantId = userInfo.getTenantId();
		logger.debug("tenantId={}", tenantId);

		// Parameter ...
		String companyId = request.getParameter("companyId");
		String domainName = request.getParameter("domainName");
		logger.debug("companyId={}, domainName={}", companyId, domainName);

		int resultInt = ezEmailService.insertApprAllowedDomain(tenantId, companyId, domainName);

		String returnStr = (resultInt == -1) ? "DUPLICATION" : "OK";
		
		logger.debug("apprAddAllowDomain ended.");
		return returnStr;
	}

    /**
     * 승인메일 :
	 * 발송허용 도메인 삭제
	 */
	@RequestMapping(value = {"/admin/ezEmail/appr/deleteAllowDomain.do" }, method = RequestMethod.POST)
	@ResponseBody
	public String apprDeleteAllowDomain(@CookieValue("loginCookie")String loginCookie, Model model, HttpServletRequest request) 
			throws Exception {
		logger.debug("apprAddAllowDomain started.");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		int tenantId = userInfo.getTenantId();
		logger.debug("tenantId={}", tenantId);

		// Parameter ...
		String companyId = request.getParameter("companyId");
		String[] domainList = request.getParameterValues("domainList[]");
		logger.debug("companyId={}, domainList={}", companyId, domainList);

		int resultInt = ezEmailService.deleteApprAllowedDomain(tenantId, companyId, domainList);
		
		if (resultInt < 0) { throw new Exception(); }
		
		logger.debug("apprAddAllowDomain ended.");
		return "OK";
	}

    /**
     * 승인메일 :
	 * 메일승인관리 > 승인관리자 > 승인자/예외자 추가 페이지
	 */
	@RequestMapping(value = {"/admin/ezEmail/appr/addApproverPopUp.do", "/admin/ezEmail/appr/addExceptionUserPopUp.do" }, method = RequestMethod.GET)
	public String apprManagerUser(@CookieValue("loginCookie")String loginCookie, Model model, HttpServletRequest request) 
			throws Exception {
		logger.debug("apprManager started.");
		
		String popUpType = request.getRequestURI().contains("/addApproverPopUp.do") ? "approver" : "exception";

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userCompanyId = userInfo.getCompanyID();

		// Parameter ...
		String companyId = StringUtils.defaultIfBlank(request.getParameter("companyId"), userCompanyId);
		
		model.addAttribute("popUpType", popUpType);
		model.addAttribute("companyId", companyId);
		
		logger.debug("apprManager ended.");
		return "admin/ezEmail/apprUserSettingPopUp";
	}

	/**
     * 승인메일 :
	 * 승인자/예외자 리스트 가져오기
	 */
	@RequestMapping(value = {"/admin/ezEmail/appr/getApproverList.do", "/admin/ezEmail/appr/getExceptionUserList.do"}, method = RequestMethod.POST)
	@ResponseBody
	public List<Map<String, String>> apprGetApprUserList(@CookieValue("loginCookie")String loginCookie, Model model, HttpServletRequest request) 
			throws Exception {
		logger.debug("apprGetApprUserList started.");

		boolean isApprover = request.getRequestURI().contains("/getApproverList.do");
		logger.debug("isApprover={}", isApprover);
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String lang = userInfo.getPrimary();
		int tenantId = userInfo.getTenantId();
		logger.debug("tenantId={}", tenantId);

		// Parameter ...
		String companyId = request.getParameter("companyId");
		logger.debug("companyId={}", companyId);
		
		List<String> userList = new ArrayList<String>();
		if (isApprover) {
			userList = ezEmailService.getApproverList(tenantId, companyId);
		} else {
			userList = ezEmailService.getExceptionUserList(tenantId, companyId);
		}
		logger.debug("userList={}", userList);
		
		List<Map<String, String>> reUserList = new ArrayList<Map<String,String>>();
		if (userList != null && userList.size() > 0) {
			for(String user : userList) {
				OrganUserVO userVO = ezOrganService.getUserInfo(user, lang, tenantId);
				String uCn 			= (userVO != null) ? userVO.getCn() 			: user;
				String uName 		= (userVO != null) ? userVO.getDisplayName() 	: "retire";
				String uDeptId 		= (userVO != null) ? userVO.getDepartment() 	: "null";
				String uDeptName 	= (userVO != null) ? userVO.getDescription() 	: "null";
				String uTitle 		= (userVO != null) ? userVO.getTitle() 			: "null";
				
				Map<String, String> map = new HashMap<String, String>();
				map.put("userId", uCn);
				map.put("userName", uName);
				map.put("deptId", uDeptId);
				map.put("deptName", uDeptName);
				map.put("userTitle", uTitle);
				
				reUserList.add(map);
			}
		}

		logger.debug("apprGetApprUserList ended.");
		return reUserList;
	}

	/**
     * 승인메일 :
	 * 승인자 리스트 검색
	 */
	@RequestMapping(value = {"/admin/ezEmail/appr/getApproverSearchList.do"}, method = RequestMethod.POST)
	@ResponseBody
	public List<Map<String, String>> apprGetApprUserSearchList(@CookieValue("loginCookie")String loginCookie, Model model, HttpServletRequest request) 
			throws Exception {
		logger.debug("apprGetApprUserSearchList started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String lang = userInfo.getPrimary();
		int tenantId = userInfo.getTenantId();
		logger.debug("tenantId={}", tenantId);

		// Parameter ...
		String companyId = request.getParameter("companyId");
		String searchType = request.getParameter("searchType");
		String searchValue = request.getParameter("searchValue");
		logger.debug("companyId={}, searchType={}, searchValue={}", companyId);
		
		List<OrganUserVO> userList = ezEmailService.getApproverSearchList(tenantId, companyId, lang, searchType, searchValue);
		logger.debug("userList={}", userList);
		
		List<Map<String, String>> reUserList = new ArrayList<Map<String,String>>();
		if (userList != null && userList.size() > 0) {
			for(OrganUserVO userVO : userList) {
				
				Map<String, String> map = new HashMap<String, String>();
				map.put("userId", 		userVO.getCn());
				map.put("userName", 	userVO.getDisplayName());
				map.put("deptId", 		userVO.getDepartment());
				map.put("deptName", 	userVO.getDescription());
				map.put("userTitle", 	userVO.getTitle());
				
				reUserList.add(map);
			}
		}

		logger.debug("apprGetApprUserSearchList ended.");
		return reUserList;
	}

    /**
     * 승인메일 :
	 * 승인자/예외자 추가
	 */
	@RequestMapping(value = {"/admin/ezEmail/appr/addApprover.do", "/admin/ezEmail/appr/addExceptionUser.do"}, method = RequestMethod.POST)
	@ResponseBody
	public String apprAddApprUser(@CookieValue("loginCookie")String loginCookie, Model model, HttpServletRequest request) 
			throws Exception {
		logger.debug("apprAddApprUser started.");

		boolean isApprover = request.getRequestURI().contains("/addApprover.do");
		logger.debug("isApprover={}", isApprover);
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		int tenantId = userInfo.getTenantId();
		logger.debug("tenantId={}", tenantId);

		// Parameter ...
		String companyId = request.getParameter("companyId");
		String[] userList = request.getParameterValues("userList[]");
		logger.debug("companyId={}, userList={}", companyId, userList);

		int resultInt = 0;
		if (isApprover) {
			resultInt = ezEmailService.resetApprover(tenantId, companyId, userList);
		} else {
			resultInt = ezEmailService.resetExceptionUser(tenantId, companyId, userList);
		}

		if (resultInt < 0) { throw new Exception(); }
		
		logger.debug("apprAddApprUser ended.");
		return "OK";
	}

    /**
     * 승인메일 :
	 * 승인자/예외자 삭제
	 */
	@RequestMapping(value = {"/admin/ezEmail/appr/deleteApprover.do", "/admin/ezEmail/appr/deleteExceptionUser.do"}, method = RequestMethod.POST)
	@ResponseBody
	public String apprDeleteApprUser(@CookieValue("loginCookie")String loginCookie, Model model, HttpServletRequest request) 
			throws Exception {
		logger.debug("apprDeleteApprUser started.");

		boolean isApprover = request.getRequestURI().contains("/deleteApprover.do");
		logger.debug("isApprover={}", isApprover);

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		int tenantId = userInfo.getTenantId();
		logger.debug("tenantId={}", tenantId);

		// Parameter ...
		String companyId = request.getParameter("companyId");
		String[] userList = request.getParameterValues("userList[]");
		logger.debug("companyId={}, userList={}", companyId, userList);

		int resultInt = 0;
		if (isApprover) {
			resultInt = ezEmailService.deleteApprover(tenantId, companyId, userList);
		} else {
			resultInt = ezEmailService.deleteExceptionUser(tenantId, companyId, userList);
		}
		
		if (resultInt < 0) { throw new Exception(); }
		
		logger.debug("apprDeleteApprUser ended.");
		return "OK";
	}
	
    /**
     * 승인메일 :
	 * 메일승인관리 > 승인로그
	 */
	@RequestMapping(value = {"/admin/ezEmail/appr/completeLog.do" }, method = RequestMethod.GET)
	public String apprCompleteLog(@CookieValue("loginCookie")String loginCookie, @RequestParam String startNum, Model model, HttpServletRequest request) 
			throws Exception {
		logger.debug("apprCompleteLog started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		int tenantId = userInfo.getTenantId();
		String userCompanyId = userInfo.getCompanyID();
		String userId = userInfo.getId();
		String lang = userInfo.getLang();
		Locale locale = userInfo.getLocale();
		String type = "complete"; // 완료
		String type2 = "apprLog"; // 완료

		// Parameter ...
		String companyId = StringUtils.defaultIfBlank(request.getParameter("companyId"), userCompanyId);
		logger.debug("companyId={}", companyId);
		
		// 페이지네이션
		int pageMax = 0;
		int pageStartNum = 1;
		int listCount =  20; // 고정
		int pageBlockSize = 10;

		if (StringUtils.isNotBlank(startNum)) {
			pageStartNum = Integer.parseInt(startNum);
		}

		logger.debug("apprCompleteLog id={}, type={}, tenantId={}, companyId={}, lang={}, pageStartNum={}, listCount={}", 
				userId, type, tenantId, companyId, lang, pageStartNum, listCount);

		JSONArray resultArry = new JSONArray();

		try {
			JSONArray array = ezEmailService.getAdminApprMailList(tenantId, companyId, type, userId, lang, pageStartNum, listCount);
			/*JSONArray array2 = ezEmailService.setUTCtoUserTime(array, userInfo.getOffset(), tenantId);
			JSONArray array3 = ezEmailService.setHref(array2);
			resultArry = ezEmailService.setStateByLocale(array3, locale);*/
			resultArry = ezEmailService.formatApprEmail(array, userInfo.getOffset(), tenantId, locale);

			int pageTotalCount = ezEmailService.getAdminApprMailListCount(tenantId, companyId, type2, userId);
			pageMax = (int) Math.ceil((double) pageTotalCount / listCount);

		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}

		// set model
		model.addAttribute("shareId", Globals.APPR_MAIL_SHARED_ID);
		model.addAttribute("lang", userInfo.getLang());
		model.addAttribute("companyId", companyId);
		model.addAttribute("userId", userInfo.getId());
		model.addAttribute("resultArry", resultArry);
		model.addAttribute("pageStartNum", pageStartNum);
		model.addAttribute("pageMax", pageMax);
		model.addAttribute("pageBlockSize", pageBlockSize);
		
		logger.debug("apprCompleteLog ended.");
		return "admin/ezEmail/apprCompleteLog";
	}
	
    /**
     * 승인메일 : 
	 * 승인대기목록 리스트 가져오기
	 */
	@RequestMapping(value = {"/admin/ezEmail/appr/allHands/getPendingList.do"}, method = RequestMethod.POST)
    @ResponseBody
    public JSONObject apprAllHandsGetPendingList(@CookieValue("loginCookie")String loginCookie, Model model, HttpServletRequest request) 
			throws Exception {
		logger.debug("apprAllHandsGetPendingList started.");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		int tenantId = userInfo.getTenantId();
		String userCompanyId = userInfo.getCompanyID();
		String userId = userInfo.getId();
		String lang = userInfo.getLang();
		String offset = userInfo.getOffset();
		Locale locale = userInfo.getLocale();
		String type = "pending"; // 대기
		String type2 = "apprCompPending"; // 대기
		logger.debug("tenantId={}, userCompanyId={}, userId={}, lang={}, locale={}, type={}, type2={}",
				tenantId, userCompanyId, userId, lang, locale, type, type2);

		// param
		String companyId = StringUtils.defaultIfBlank(request.getParameter("companyId"), userCompanyId);
		String startNum = StringUtils.defaultIfBlank(request.getParameter("startNum"), "1");
		logger.debug("companyId={}, startNum={}", companyId, startNum);

		// 페이지네이션
		int pageMax = 0;
		int pageStartNum = Integer.parseInt(startNum);
		int listCount =  20; // 고정
		int pageTotalCount = 0;
		logger.debug("pageStartNum={}, listCount={}", pageStartNum, listCount);

		// 로그 리스트
		JSONArray logList = new JSONArray();
		try {
			JSONArray array = ezEmailService.getAdminCompApprMailList(tenantId, companyId, type, userId, lang, pageStartNum, listCount);
			/*JSONArray array2 = ezEmailService.setUTCtoUserTime(array, offset, tenantId);
			JSONArray array3 = ezEmailService.setHref(array2);
			logList = ezEmailService.setStateByLocale(array3, locale);*/
			logList = ezEmailService.formatApprEmail(array, offset, tenantId, locale);

			pageTotalCount = ezEmailService.getAdminApprMailListCount(tenantId, companyId, type2, userId);
			pageMax = (int) Math.ceil((double) pageTotalCount / listCount);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}

		JSONObject returnData = new JSONObject();
		returnData.put("shareId", Globals.APPR_MAIL_SHARED_ID);
		returnData.put("lang", lang);
		returnData.put("companyId", companyId);
		returnData.put("userId", userId);
		returnData.put("resultArry", logList);
		returnData.put("pageStartNum", pageStartNum);
		returnData.put("pageMax", pageMax);
		returnData.put("totalCnt", pageTotalCount);
		
		logger.debug("apprAllHandsGetPendingList ended.");
        return returnData;
	}
	
    /**
     * 승인메일 : 
	 * 전사 승인메일 발송승인
	 */
	@RequestMapping(value = {"/admin/ezEmail/appr/allHands/setApproval.do"}, method = RequestMethod.POST)
	@ResponseBody
	public String apprAllHandsSetApproval(@CookieValue("loginCookie")String loginCookie, @RequestBody MailApprVO request) 
			throws Exception {
		logger.debug("apprAllHandsSetApproval started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();
		int tenantId = userInfo.getTenantId();
		String companyId = userInfo.getCompanyID();
		String domainName = ezCommonService.getTenantConfig("DomainName", tenantId);
        logger.debug("apprSetApproval userId={}, tenantId={}, companyId={}, domainName={}", userId, tenantId, companyId, domainName);
        
		String returnValue = "OK";
		int errorInt = 0; // 오류난 개수
		// param
		String[] hrefArray = request.getHrefArray();

		// 데이터 수집 단계
		List<Map<String, Object>> approvalDataList = new ArrayList<>();

		try {
			for(String encryptedHref : hrefArray) {
				// decrypt & mailbox/uid
				String href = egovFileScrty.decryptAES(encryptedHref);
				String hrefUserId = href.split("/")[0].replaceFirst("^Sent\\.", "");
				long uid = Long.parseLong(href.split("/")[1]);

				// 신청자 정보
				String applicantId = hrefUserId;
				String applicantEmail = hrefUserId + "@" + domainName;
				OrganUserVO applicantVO = ezOrganAdminService.getUserInfo(hrefUserId, "1", tenantId);
				if (applicantVO != null) {
					applicantId = applicantVO.getCn();
					applicantEmail = applicantId + "@" + domainName;
				}

				logger.debug("apprSetApproval userId={}, href={}, hrefUserId={}, uid={}, applicantId={}, applicantEmail={}",
						userId, href, hrefUserId, uid, applicantId, applicantEmail);
				// 데이터 생성
				Map<String, Object> approvalData = new HashMap<>();
				approvalData.put("tenantId", tenantId);
				approvalData.put("companyId", companyId);
				approvalData.put("uid", uid);
				approvalData.put("applicantId", applicantId);
				approvalData.put("applicantEmail", applicantEmail);
				approvalData.put("state", "pending");
				approvalData.put("apprMailFlag", "comp");

				approvalDataList.add(approvalData);
			}

			// 메일이 대기 상태인지 check
			int checkMail = ezEmailService.checkApprHistoryMultiple(tenantId, companyId, userId, approvalDataList);
			if (checkMail > 0) { // 1: 이미 처리된 메일이 있음
				return "DONE";
			}

			// 처리 단계
			for (Map<String, Object> approvalData : approvalDataList) {
				int resultInt = ezEmailService.setApprCompMailApproval(loginCookie, (String) approvalData.get("applicantEmail"), (Long) approvalData.get("uid"));
				if (resultInt != 0) {
					errorInt++;
				}
			}

			if (errorInt > 0) {
				returnValue = "ERROR_" + errorInt;
			}

		} catch (Exception e) {
			logger.error("apprSetApproval error", e);
			returnValue = "Exception";
		}
        
		logger.debug("returnValue=" + returnValue);
		logger.debug("apprAllHandsSetApproval ended.");
		
		return returnValue;
	}
	
	/**
	 * 승인메일 :
	 * 전사 승인메일 발송거부 요청 화면
	 */
	@RequestMapping(value = "/admin/ezEmail/appr/allHands/setReject.do", method = RequestMethod.GET)
	public String apprSetReject(@CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("apprSetReject started & ended. userId={}", commonUtil.userInfo(loginCookie).getId());

		return "admin/ezEmail/apprRejectPopUp";
	}

    /**
     * 승인메일 : 
	 * 전사 승인메일 발송거부 action
	 */
	@RequestMapping(value = {"/admin/ezEmail/appr/allHands/setRejectAction.do"}, method = RequestMethod.POST)
	@ResponseBody
	public String apprAllHandsSetReject(@CookieValue("loginCookie")String loginCookie, @RequestBody MailApprVO request) throws Exception {
		logger.debug("apprAllHandsSetReject started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();
		int tenantId = userInfo.getTenantId();
		String companyId = userInfo.getCompanyID();
		logger.debug("tenantId={}, companyId={}", tenantId, companyId);

        String domainName = ezCommonService.getTenantConfig("DomainName", tenantId);
        
		String returnValue = "OK";
		int errorInt = 0; // 오류난 개수
		// param
		String[] hrefArray = request.getHrefArray();
	    String memo = request.getMemo().replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("&", "&amp;");

		// 데이터 수집 단계
		List<Map<String, Object>> approvalDataList = new ArrayList<>();

		try {
			for(String encryptedHref : hrefArray) {
				// decrypt & mailbox/uid
				String href = egovFileScrty.decryptAES(encryptedHref);
				String hrefUserId = href.split("/")[0].replaceFirst("^Sent\\.", "");
				long uid = Long.parseLong(href.split("/")[1]);
				
				// 신청자 정보
				String applicantId = hrefUserId;
				String applicantEmail = hrefUserId + "@" + domainName;
				OrganUserVO applicantVO = ezOrganAdminService.getUserInfo(hrefUserId, "1", tenantId);
				if (applicantVO != null) {
					applicantId = applicantVO.getCn();
					applicantEmail = applicantId + "@" + domainName;
				}
	
				logger.debug("apprAllHandsSetReject userId={}, href={}, hrefUserId={}, uid={}, applicantId={}, applicantEmail={}",
						userId, href, hrefUserId, uid, applicantId, applicantEmail);

				// 데이터 생성
				Map<String, Object> approvalData = new HashMap<>();
				approvalData.put("tenantId", tenantId);
				approvalData.put("companyId", companyId);
				approvalData.put("uid", uid);
				approvalData.put("applicantId", applicantId);
				approvalData.put("applicantEmail", applicantEmail);
				approvalData.put("state", "pending");
				approvalData.put("apprMailFlag", "comp");

				approvalDataList.add(approvalData);
			}

			// 메일이 대기 상태인지 check
			int checkMail = ezEmailService.checkApprHistoryMultiple(tenantId, companyId, userId, approvalDataList);
			if (checkMail > 0) { // 1: 이미 처리된 메일이 있음
				return "DONE";
			}

			// 처리 단계
			for (Map<String, Object> approvalData : approvalDataList) {
				int resultInt = ezEmailService.setApprCompMailReject(loginCookie, (String) approvalData.get("applicantEmail"), (Long) approvalData.get("uid"), memo);
				if (resultInt != 0) {
					errorInt++;
				}
			}
			
			if (errorInt > 0) {
				returnValue = "ERROR_" + errorInt;
			}
		} catch (Exception e) {
			logger.error("apprSetApproval error", e);
			returnValue = "Exception";
		}	
        
		logger.debug("returnValue=" + returnValue);
		logger.debug("apprAllHandsSetReject ended.");
		
		return returnValue;
	}
	
    /**
     * 승인메일 : 
	 * 전체메일승인 > 승인로그 목록 리스트 가져오기
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = {"/admin/ezEmail/appr/allHands/getCompleteLogList.do"}, method = RequestMethod.POST)
	@ResponseBody
	public JSONObject apprAllHandsGetCompleteLogList(@CookieValue("loginCookie")String loginCookie, Model model, HttpServletRequest request) 
			throws Exception {
		logger.debug("apprAllHandsGetCompleteLogList started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		int tenantId = userInfo.getTenantId();
		String userCompanyId = userInfo.getCompanyID();
		String userId = userInfo.getId();
		String lang = userInfo.getLang();
		String offset = userInfo.getOffset();
		Locale locale = userInfo.getLocale();
		logger.debug("tenantId={}, userCompanyId={}, userId={}, lang={}, locale={}",
				tenantId, userCompanyId, userId, lang, locale);
		
		// param
		String companyId = StringUtils.defaultIfBlank(request.getParameter("companyId"), userCompanyId);
		String startNum = StringUtils.defaultIfBlank(request.getParameter("startNum"), "1");
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String sDate = StringUtils.isNotBlank(request.getParameter("sDate")) ? 
						sdf.format(new Date(request.getParameter("sDate"))) : null;
		String eDate = StringUtils.isNotBlank(request.getParameter("eDate")) ? 
				sdf.format(new Date(request.getParameter("eDate"))) : null;
		logger.debug("companyId={}, startNum={}, sDate={}, eDate={}", companyId, startNum, sDate, eDate);
		
		// 페이지네이션
		int pageMax = 0;
		int pageStartNum = Integer.parseInt(startNum);
		int listCount =  20; // 고정
		int pageTotalCount = 0;
		logger.debug("pageStartNum={}, listCount={}", pageStartNum, listCount);

		// 로그 리스트
		List<Map<String, String>> logList = new ArrayList<Map<String,String>>();
		try {
			logList = ezEmailService.getApprCompMailHistorySearchList(tenantId, companyId, lang, locale, offset, sDate, eDate, pageStartNum, listCount);
			pageTotalCount = ezEmailService.getApprCompMailHistorySearchListCnt(tenantId, companyId, sDate, eDate);
			pageMax = (int) Math.ceil((double) pageTotalCount / listCount);
			logger.debug("pageMax={}, logList Size={}", pageMax, logList.size());
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}

		
		JSONObject returnData = new JSONObject();
		returnData.put("shareId", Globals.APPR_MAIL_SHARED_ID);
		returnData.put("lang", lang);
		returnData.put("companyId", companyId);
		returnData.put("userId", userId);
		returnData.put("resultArry", logList);
		returnData.put("pageStartNum", pageStartNum);
		returnData.put("pageMax", pageMax);
		returnData.put("totalCnt", pageTotalCount);
		
		logger.debug("apprAllHandsGetCompleteLogList ended.");
		return returnData;
	}
	
    /**
     * 승인메일 : 
	 * 승인로그 검색 리스트 가져오기
	 */
	@RequestMapping(value = {"/admin/ezEmail/appr/allHands/getCompleteLogListSearch.do"}, method = RequestMethod.POST)
	public void apprAllHandsGetCompleteLogListSearch(@CookieValue("loginCookie")String loginCookie, Model model, HttpServletRequest request) 
			throws Exception {
		logger.debug("apprAllHandsGetCompleteLogListSearch started.");
		logger.debug("apprAllHandsGetCompleteLogListSearch ended.");
	}
	
    /**
     * 승인메일 : 
	 * 전체메일 > 승인로그 엑셀 다운로드
	 */
	@RequestMapping(value = {"/admin/ezEmail/appr/allHands/getCompleteLogListDownload.do"}, method = RequestMethod.POST)
	@ResponseBody
	public void apprAllHandsGetCompleteLogListDownload(@CookieValue("loginCookie")String loginCookie, Model model, Locale locale, HttpServletRequest request, HttpServletResponse response) 
			throws Exception {
		logger.debug("apprAllHandsGetCompleteLogListDownload started.");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userCompanyId = userInfo.getCompanyID();
		String lang = userInfo.getLang();
		String offset = userInfo.getOffset();
		int tenantId = userInfo.getTenantId();
		logger.debug("userCompanyId={}, tenantId={}", userCompanyId, tenantId);
		
		String companyId = StringUtils.defaultIfEmpty(request.getParameter("companyId"), userCompanyId);

		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String sDate = StringUtils.isNotBlank(request.getParameter("sDate")) ? 
						sdf.format(new Date(request.getParameter("sDate"))) : null;
		String eDate = StringUtils.isNotBlank(request.getParameter("eDate")) ? 
				sdf.format(new Date(request.getParameter("eDate"))) : null;
		logger.debug("companyId={}, sDate={}, eDate={}", companyId, sDate, eDate);
		
		// 검색 조건에 맞는 리스트 가져오기
		List<Map<String, String>> logList = ezEmailService.getApprCompMailHistorySearchList(tenantId, companyId, lang, locale, offset, sDate, eDate);
		List<Map<String, String>> userCntList = ezEmailService.getApprCompMailHistorySearchUserCnt(tenantId, companyId, lang, sDate, eDate);

		try (HSSFWorkbook workbook = new HSSFWorkbook()) {
			ezEmailUtil.apprLogExcelExport(workbook, locale, "logs_allHands", "userStatistics_allHands", logList, userCntList);
			
			String fileName = "apprMailLog_allHands";
			if (sDate != null && eDate != null) {
				fileName += sDate + "~" + eDate;
			}
			
			response.setCharacterEncoding("UTF-8");
			response.setHeader("Content-Disposition", "attachment; fileName=" + fileName.replaceAll("\r", "").replaceAll("\n", "") + ".xls");
			response.setContentType("application/vnd.ms-excel");
			
			workbook.write(response.getOutputStream());
			//workbook.close();
		} catch(Exception e) {
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("apprAllHandsGetCompleteLogListDownload ended.");
	}
	
    /**
     * 승인메일 : 
	 * 전체메일승인 > 승인로그 삭제
	 */
	@RequestMapping(value = {"/admin/ezEmail/appr/allHands/deleteCompleteLogList.do"}, method = RequestMethod.POST)
	@ResponseBody
	public String apprAllHandsDeleteCompleteLogList(@CookieValue("loginCookie")String loginCookie, @RequestBody MailApprVO request) 
			throws Exception {
		logger.debug("apprAllHandsDeleteCompleteLogList started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();
		int tenantId = userInfo.getTenantId();
		logger.debug("tenantId={}", tenantId);

        String domainName = ezCommonService.getTenantConfig("DomainName", tenantId);
        
		String returnValue = "OK";
		int errorInt = 0; // 오류난 개수
		// param
		String[] hrefArray = request.getHrefArray();

		for(String encryptedHref : hrefArray) {
			// decrypt & mailbox/uid
			String href = egovFileScrty.decryptAES(encryptedHref);
			String hrefUserId = href.split("/")[0].replaceFirst("^Sent\\.", "");
			long uid = Long.parseLong(href.split("/")[1]);
			
			// 신청자 정보
			OrganUserVO applicantVO = ezOrganAdminService.getUserInfo(hrefUserId, "1", tenantId);
			String applicantId = applicantVO.getCn();
			String applicantEmail = applicantId + "@" + domainName;
			
			logger.debug("apprAllHandsDeleteCompleteLogList userId={}, href={}, hrefUserId={}, uid={}, applicantId={}, applicantEmail={}",
					userId, href, hrefUserId, uid, applicantId, applicantEmail);
			
			int resultInt = ezEmailService.setApprCompMailDelete(loginCookie, applicantEmail, uid);

	        if (resultInt != 0) {
	        	errorInt++;
	        }
		}
		
		if (errorInt > 0) {
			returnValue = "ERROR_" + errorInt;
		}
		
		logger.debug("apprAllHandsDeleteCompleteLogList ended. userId={}, returnValue={}", userId, returnValue);
		
		return returnValue;
	}

    /**
     * 승인메일 :
	 * 예외자 리스트 가져오기
	 */
	@RequestMapping(value = {"/admin/ezEmail/appr/getExceptionUserList.do" }, method = RequestMethod.GET)
	public void apprGetExceptionUserList(@CookieValue("loginCookie")String loginCookie, Model model, HttpServletRequest request) 
			throws Exception {
		logger.debug("apprGetExceptionUserList started.");
		logger.debug("apprGetExceptionUserList ended.");
	}

    /**
     * 승인메일 : 
	 * (일반메일)승인로그 목록 리스트 가져오기
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = {"/admin/ezEmail/appr/getCompleteLogList.do"}, method = RequestMethod.POST)
	@ResponseBody
	public JSONObject apprGetCompleteLogList(@CookieValue("loginCookie")String loginCookie, Model model, HttpServletRequest request) 
			throws Exception {
		logger.debug("apprGetCompleteLogList started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		int tenantId = userInfo.getTenantId();
		String userCompanyId = userInfo.getCompanyID();
		String userId = userInfo.getId();
		String lang = userInfo.getLang();
		String offset = userInfo.getOffset();
		Locale locale = userInfo.getLocale();
		logger.debug("tenantId={}, userCompanyId={}, userId={}, lang={}, locale={}",
				tenantId, userCompanyId, userId, lang, locale);
		
		// param
		String companyId = StringUtils.defaultIfBlank(request.getParameter("companyId"), userCompanyId);
		String startNum = StringUtils.defaultIfBlank(request.getParameter("startNum"), "1");
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String sDate = StringUtils.isNotBlank(request.getParameter("sDate")) ? 
						sdf.format(new Date(request.getParameter("sDate"))) : null;
		String eDate = StringUtils.isNotBlank(request.getParameter("eDate")) ? 
				sdf.format(new Date(request.getParameter("eDate"))) : null;
		logger.debug("companyId={}, startNum={}, sDate={}, eDate={}", companyId, startNum, sDate, eDate);
		
		// 페이지네이션
		int pageMax = 0;
		int pageStartNum = Integer.parseInt(startNum);
		int listCount =  20; // 고정
		int pageTotalCount = 0;
		logger.debug("pageStartNum={}, listCount={}", pageStartNum, listCount);

		// 로그 리스트
		JSONArray logList = new JSONArray();
		try {
			logList = ezEmailService.getApprMailHistorySearchList(tenantId, companyId, lang, locale, offset, sDate, eDate, pageStartNum, listCount);
			pageTotalCount = ezEmailService.getApprMailHistorySearchListCnt(tenantId, companyId, sDate, eDate);
			pageMax = (int) Math.ceil((double) pageTotalCount / listCount);
			logger.debug("pageMax={}, logList Size={}", pageMax, logList.size());
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}

		
		JSONObject returnData = new JSONObject();
		returnData.put("shareId", Globals.APPR_MAIL_SHARED_ID);
		returnData.put("lang", lang);
		returnData.put("companyId", companyId);
		returnData.put("userId", userId);
		returnData.put("resultArry", logList);
		returnData.put("pageStartNum", pageStartNum);
		returnData.put("pageMax", pageMax);
		returnData.put("totalCnt", pageTotalCount);
		
		logger.debug("apprGetCompleteLogList ended.");
		return returnData;
	}
	
    /**
     * 승인메일 : 
	 * (일반메일)승인로그 검색 리스트 가져오기
	 */
	@RequestMapping(value = {"/admin/ezEmail/appr/getCompleteLogListSearch.do"}, method = RequestMethod.POST)
	public void apprGetCompleteLogListSearch(@CookieValue("loginCookie")String loginCookie, Model model, HttpServletRequest request) 
			throws Exception {
		logger.debug("apprGetCompleteLogListSearch started.");
		logger.debug("apprGetCompleteLogListSearch ended.");
	}
	
    /**
     * 승인메일 : 
	 * 메일승인관리 > 승인로그 엑셀 다운로드
	 */
	@RequestMapping(value = {"/admin/ezEmail/appr/getCompleteLogListDownload.do"}, method = RequestMethod.POST)
	public void apprGetCompleteLogListDownload(@CookieValue("loginCookie")String loginCookie, Model model, Locale locale, HttpServletRequest request, HttpServletResponse response) 
			throws Exception {
		logger.debug("apprGetCompleteLogListDownload started.");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userCompanyId = userInfo.getCompanyID();
		String lang = userInfo.getLang();
		String offset = userInfo.getOffset();
		int tenantId = userInfo.getTenantId();
		logger.debug("userCompanyId={}, tenantId={}", userCompanyId, tenantId);
		
		String companyId = StringUtils.defaultIfEmpty(request.getParameter("companyId"), userCompanyId);

		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		@SuppressWarnings("deprecation")
		String sDate = StringUtils.isNotBlank(request.getParameter("sDate")) ? 
						sdf.format(new Date(request.getParameter("sDate"))) : null;
		String eDate = StringUtils.isNotBlank(request.getParameter("eDate")) ? 
				sdf.format(new Date(request.getParameter("eDate"))) : null;
		logger.debug("companyId={}, sDate={}, eDate={}", companyId, sDate, eDate);
		
		// 검색 조건에 맞는 리스트 가져오기
		List<Map<String, String>> logList = ezEmailService.getApprMailHistorySearchList(tenantId, companyId, lang, locale, offset, sDate, eDate);
		List<Map<String, String>> userCntList = ezEmailService.getApprMailHistorySearchUserCnt(tenantId, companyId, lang, sDate, eDate);

		try (HSSFWorkbook workbook = new HSSFWorkbook()) {
			ezEmailUtil.apprLogExcelExport(workbook, locale, "logs", "userStatistics", logList, userCntList);
			
			String fileName = "apprMailLog_";
			if (sDate != null && eDate != null) {
				fileName += sDate + "~" + eDate;
			}
			
			response.setCharacterEncoding("UTF-8");
			response.setHeader("Content-Disposition", "attachment; fileName=" + fileName.replaceAll("\r", "").replaceAll("\n", "") + ".xls");
			response.setContentType("application/vnd.ms-excel");
			
			workbook.write(response.getOutputStream());
			//workbook.close();
		} catch(Exception e) {
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("apprGetCompleteLogListDownload ended.");
	}
	/**
	 * 메일 POP3/IMAP 설정 화면
	 */
	@RequestMapping(value = "/admin/ezEmail/adminConfigPOP3IMAP.do", method = RequestMethod.GET)
	public String configPOP3IMAP(
			@CookieValue("loginCookie") String loginCookie, Locale locale,
			Model model, HttpServletRequest request) throws Exception {
		logger.debug("configPOP3IMAP started.");

		// 관리자 권한체크
		LoginVO auth = commonUtil.checkAdmin(loginCookie);
		if (auth == null) {
			return "cmm/error/adminDenied";
		}

		String usePOP3 = ezCommonService.getTenantConfig("usePOP3Default", auth.getTenantId());
		String useIMAP = ezCommonService.getTenantConfig("useIMAPDefault", auth.getTenantId());

		model.addAttribute("usePOP3", usePOP3);
		model.addAttribute("useIMAP", useIMAP);

		logger.debug("configPOP3IMAP ended.");

		return "admin/ezEmail/adminConfigPOP3IMAP";
	}

	/**
	 * 메일 POP3/IMAP 설정 저장
	 */
	@RequestMapping(value = "/admin/ezEmail/saveConfigPOP3IMAP.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject saveConfigPOP3IMAP (@CookieValue("loginCookie")String loginCookie, Model model, HttpServletRequest request, @RequestBody Map<String, Object> requestBody)
			throws Exception {
		logger.debug("saveConfigPOP3IMAP started.");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		List<Map<String, String>> list = (List<Map<String, String>>) requestBody.get("paramArray");

		boolean pop3AllUser = Boolean.parseBoolean(requestBody.get("pop3AllUser").toString());
		boolean imapAllUser = Boolean.parseBoolean(requestBody.get("imapAllUser").toString());

		String usePOP3Default = list.get(0).get("value");
		String useIMAPDefault = list.get(1).get("value");
		String tenantDomain = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());

		JgwResult jgwResult = rest.jgw().url("/jMochaEzEmail/updateAllUserPOP3IMAP")
				.formParam("usePOP3Default", usePOP3Default)
				.formParam("useIMAPDefault", useIMAPDefault)
				.formParam("pop3AllUser", pop3AllUser)
				.formParam("imapAllUser", imapAllUser)
				.formParam("tenantDomain", tenantDomain)
				.exchangeJgwResult();

		ezSystemAdminService.updateSysParam(userInfo.getTenantId(), list, userInfo.getLocale(), userInfo.getCompanyID());

		JSONObject returnData = new JSONObject();

		String result = "OK";
		if (!jgwResult.succeeded()) {
			result = "ERROR";
		}
		returnData.put("status", result);

		logger.debug("saveConfigPOP3IMAP ended.");
		return returnData;
	}
}
