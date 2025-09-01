package egovframework.ezEKP.ezSystem.web;

import java.io.File;
import java.net.InetAddress;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Objects;
import java.util.Optional;
import java.util.Properties;
import java.util.stream.Collectors;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.BooleanUtils;
import egovframework.ezEKP.ezOrgan.vo.OrganAuth;
import egovframework.ezEKP.ezOrgan.vo.OrganAuth.AdminAuth;
import org.apache.commons.lang3.StringUtils;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
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
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.HandlerMapping;
import org.w3c.dom.Document;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezNotification.service.EzNotificationService;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.ezEKP.ezSystem.service.EzSystemAdminService;
import egovframework.ezEKP.ezSystem.util.EzSystemUtil;
import egovframework.ezEKP.ezSystem.vo.AccessIdVO;
import egovframework.ezEKP.ezSystem.vo.ConnectionInfoVO;
import egovframework.ezEKP.ezSystem.vo.CountryVO;
import egovframework.ezEKP.ezSystem.vo.DeptChangeInfoVO;
import egovframework.ezEKP.ezSystem.vo.IPBandVO;
import egovframework.ezEKP.ezSystem.vo.ModuleSizeVO;
import egovframework.ezEKP.ezSystem.vo.PasswordPolicyVO;
import egovframework.ezEKP.ezSystem.vo.PermissionInfoVO;
import egovframework.ezEKP.ezSystem.vo.SysParamVO;
import egovframework.ezEKP.ezSystem.vo.SystemConfigTypeVO;
import egovframework.ezEKP.ezSystem.vo.SystemConfigVO;
import egovframework.ezEKP.ezSystem.vo.UserChangeInfoVO;
import egovframework.let.main.vo.MainVO;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;


@Controller
public class EzSystemAdminController {

	private static final Logger logger = LoggerFactory.getLogger(EzSystemAdminController.class);
	
	@Autowired
	private Properties config;
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private EzCommonService ezCommonService;
	
	@Resource(name="EzSystemAdminService")
	private EzSystemAdminService ezSystemAdminService;
	
    @Resource(name="crypto") 
    private EgovFileScrty egovFileScrty;
	
	@Autowired
	private EzOrganAdminService ezOrganAdminService;
	
	@Autowired
	private EzNotificationService ezNotificationService;

	@Resource
	private EgovMessageSource egovMessageSource;
	
	/** LoginService */
	@Resource(name = "loginService")
    private LoginService loginService;
    
	@RequestMapping(value="/admin/ezSystem/systemMain.do", method = RequestMethod.GET)
	public String systemMain(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception{
		//관리자 권한체크
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		return "/ezSystem/systemMain";
	}

	
	@RequestMapping(value="/admin/ezSystem/systemLeftMenu.do", method = RequestMethod.GET)
	public String systemLeftMenu(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);

		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}

		logger.debug("tenantID=" + userInfo.getTenantId());
		
		//관리자 권한체크
		String cChk = "0";
		if (userInfo.getRollInfo().indexOf("c=1") != -1) { // 전체 관리자
			cChk = "1";
		}
		model.addAttribute("cChk", cChk);
		
		String useFidoAccessMenu = ezCommonService.getTenantConfig("useFidoAccessMenu", userInfo.getTenantId());

		if (useFidoAccessMenu == null || useFidoAccessMenu.equals("")) {
			useFidoAccessMenu = "NO";
		}
		
		String useIPAccessMenu = ezCommonService.getTenantConfig("useIPAccessMenu", userInfo.getTenantId());
		
		if (useIPAccessMenu == null || useIPAccessMenu.equals("")) {
			useIPAccessMenu = "NO";
		}
		
		String useModuleUsage = ezCommonService.getTenantConfig("useModuleUsage", userInfo.getTenantId());
		if(userInfo == null || useModuleUsage == null || useModuleUsage.equals("")) {
			useModuleUsage = "NO";
		}
		
		String useSystemMonitor = ezCommonService.getTenantConfig("useSystemMonitor", userInfo.getTenantId());
		
		model.addAttribute("useIPAccessMenu", useIPAccessMenu);
		model.addAttribute("useFidoAccessMenu", useFidoAccessMenu);
		model.addAttribute("useModuleUsage", useModuleUsage);
		model.addAttribute("useSystemMonitor", useSystemMonitor);		
		
		logger.debug("useIPAccessMenu=" + useIPAccessMenu);
		
		return "/ezSystem/systemLeftMenu";
	}
	
	@RequestMapping(value="/admin/ezSystem/systemMainMenu.do", method = RequestMethod.GET)
	public String systemMainMenu(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("systemMainMenu started");
		
		//관리자 권한체크
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		logger.debug("tenantID=" + userInfo.getTenantId());
		
		Map<String, String> configMap = new HashMap<String, String>();
		List<SysParamVO> configList = ezSystemAdminService.getSysParam(userInfo.getTenantId());
		String systemDomain = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
		int licensedUserCount = 0;
		
		for (SysParamVO param : configList) {
			configMap.put(param.getName(), param.getValue());
			
			if (param.getName().equals("LicenseKey")) {
				String licenseKey = param.getValue();
				licensedUserCount = Integer.parseInt(getLicenseDomainAndCount(licenseKey).get(1));
			}
		}
		if (configMap.get("useSession") == null || configMap.get("useSession").equals("")) {
			configMap.put("useSession", "0");
		}
		if (configMap.get("useSessionMobile") == null || configMap.get("useSessionMobile").equals("")) {
			configMap.put("useSessionMobile", "0");
		}
		
		int userCount = ezOrganAdminService.getUserCount(userInfo.getTenantId());
		
		// masteradmin 사용자를 제외하기 위해 1을 뺀다.
		userCount--;
		// 승인메일 공유사서함이 있으면 해당 계정은 라이센스에서 제외
		Boolean apprSharedExist = BooleanUtils.toBoolean(ezOrganAdminService.userCheck("__approved_mail", userInfo.getTenantId()));
		if (apprSharedExist) {
			userCount--;
		}
		
		String dotNetIntegration = ezCommonService.getTenantConfig("dotNetIntegration", userInfo.getTenantId());
		boolean isDotNetAdmin = false;
		
		if (dotNetIntegration.equals("YES")) {
			if (userInfo.getRollInfo().indexOf("c=1") != -1 || userInfo.getRollInfo().indexOf("k=1") != -1) {
				isDotNetAdmin = true;
			}			
		}
		
		String lang = userInfo.getLang();
		List<String> defaultFontFamilyList = Arrays.asList(egovMessageSource.getMessage("main.t0620", Locale.KOREA).split(";")); 
		
		// 2023-08-30 황인경 - 관리자 > 시스템 > 패러미터 > 에디터 폰트 > 다국어 처리
		if (lang.equals("2")) {
			defaultFontFamilyList = Arrays.asList(egovMessageSource.getMessage("main.t0620", Locale.ENGLISH).split(";"));
		} else if (lang.equals("3")) {
			defaultFontFamilyList = Arrays.asList(egovMessageSource.getMessage("main.t0620", Locale.JAPAN).split(";"));
		} 
		
		List<String> defaultFontSizeList = Arrays.asList("8pt,9pt,10pt,11pt,12pt,13pt,14pt,16pt,18pt,20pt,24pt,30pt,36pt,54pt,72pt".split(","));
		String useAllUserOldMailDelete = ezCommonService.getTenantConfig("useAllUserOldMailDelete", userInfo.getTenantId());
		String useAllUserOldMailDeletePeriod = ezCommonService.getTenantConfig("useAllUserOldMailDeletePeriod", userInfo.getTenantId());
		String usePortalAutoRefreshInterval = ezCommonService.getTenantConfig("usePortalAutoRefreshInterval", userInfo.getTenantId());
		String useExternalMailServer = ezCommonService.getTenantConfig("useExternalMailServer", userInfo.getTenantId());
		if (useExternalMailServer == null || useExternalMailServer.equals("")) {
			useExternalMailServer = "NO";
		}
		String usePortal = ezCommonService.getTenantConfig("Use_Portal", userInfo.getTenantId());
		Integer notiPollingInterval = Integer.parseInt(ezCommonService.getTenantConfig("notiPollingInterval", userInfo.getTenantId())) / (1000 * 60);
		String zipEncMenu = ezCommonService.getTenantConfig("zipEncMenu", userInfo.getTenantId());

		model.addAttribute("dotNetIntegration", dotNetIntegration);
		model.addAttribute("configMap", configMap);
		model.addAttribute("licensedUserCount", licensedUserCount);
		model.addAttribute("userCount", userCount);
		model.addAttribute("isDotNetAdmin", isDotNetAdmin);
		model.addAttribute("defaultFontFamilyList", defaultFontFamilyList);
		model.addAttribute("defaultFontSizeList", defaultFontSizeList);
		model.addAttribute("useAllUserOldMailDelete", useAllUserOldMailDelete);
		model.addAttribute("useAllUserOldMailDeletePeriod", useAllUserOldMailDeletePeriod);
		model.addAttribute("usePortalAutoRefreshInterval", usePortalAutoRefreshInterval);
		model.addAttribute("useExternalMailServer", useExternalMailServer);
		model.addAttribute("usePortal", usePortal);
		model.addAttribute("systemDomain", systemDomain);
		model.addAttribute("notiPollingInterval", notiPollingInterval);
		model.addAttribute("zipEncMenu", zipEncMenu);

		String packageType = commonUtil.getPackageType(userInfo.getTenantId());
		model.addAttribute("packageType", packageType);

		logger.debug("systemMainMenu ended");
		
		return "/ezSystem/systemMainMenu";
	}
		
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/admin/ezSystem/updateSysParam.do", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	@ResponseBody
	public JSONObject updateSysParam(@CookieValue("loginCookie") String loginCookie, Model model,
			@RequestBody List<Map<String, String>> list) throws Exception {
		
		logger.debug("started updateSysParam controller.");
		
		JSONObject obj = new JSONObject();
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		int tenantId = (userInfo == null) ? -1 : userInfo.getTenantId();

		if (tenantId == -1) {
			obj.put("msg", "fail");
			return obj;
		} else {
			String systemDomain = ezCommonService.getTenantConfig("DomainName", tenantId);
			String msg = "";
			String licenseDomain = "";

			for (Map<String, String> param : list) {
				if ("LicenseKey".equals(param.get("name"))) {
					String licenseKey = param.get("value");
					licenseDomain = getLicenseDomainAndCount(licenseKey).get(0);
					break;
				}
			}
			
			if (!(licenseDomain.equals(systemDomain)) && !(licenseDomain.isEmpty())) {	//20211005 이희원 - 라이센스도메인과 시스템도메인 비교해서 유효성검사
				obj.put("licenseDomain", licenseDomain);
				obj.put("msg", "domainFail");
				return obj;
			// 2023-05-17 이사라 : NullPointerException 시큐어코딩
			} else if (!Objects.isNull(userInfo)) {
				try {
					ezSystemAdminService.updateSysParam(tenantId, list, userInfo.getLocale(), userInfo.getCompanyID());
					msg = "success";
				} catch (Exception e) {
					msg = "fail";
				}
			}

			obj.put("msg", msg);
		}
		
		logger.debug("ended updateSysParam controller.");
		
		return obj;
	}

	// 20211005 이희원 - 라이센스키를 복호화하여 도메인과 카운트 추출
	public ArrayList<String> getLicenseDomainAndCount(String licenseKey) throws Exception {

		logger.debug("getLicenseDomainAndCount started");

		ArrayList<String> decryptResult = new ArrayList<>();
		String licenseDomain = "";
		String licensedUserCount = "0";
		
		if ((licenseKey != null) && !(licenseKey.equals(""))) {
			try {
				licenseKey = egovFileScrty.decryptAES(licenseKey);
				String items[] = licenseKey.split(":");

				if (items.length >= 2) {
					licenseDomain = items[0];
					licensedUserCount = items[1];
				}
			} catch (Exception e) {
				logger.error(e.getMessage(), e);
			}
		}
		
		decryptResult.add(licenseDomain);
		decryptResult.add(licensedUserCount);
		
		logger.debug("getLicenseDomainAndCount ended");

		return decryptResult;
	}
	
	/**
	 * 로그인 로그내역 메인 호출
	 */
	@RequestMapping(value="/admin/ezSystem/systemLoginHist.do", method = RequestMethod.GET)
	public String systemLoginHist(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model) throws Exception {
		
		logger.debug("started systemLoginHistMain controller.");
		
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		String companyId = userInfo.getCompanyID();
		
		String LoginMailLogKeepPeriod = ezCommonService.getTenantConfig("LoginMailLogKeepPeriod", userInfo.getTenantId());
		LoginMailLogKeepPeriod = LoginMailLogKeepPeriod.equals("") ? "3" : LoginMailLogKeepPeriod;
		
		String mailLogKeepPeriodMessage = egovMessageSource.getMessage("ezStatistics.t1065", locale);
		mailLogKeepPeriodMessage = String.format(mailLogKeepPeriodMessage, LoginMailLogKeepPeriod);
		
		model.addAttribute("mailLogKeepPeriodMessage", mailLogKeepPeriodMessage);

		List<OrganDeptVO> adminCompanyList = ezOrganAdminService.getAdminCompanyList(userInfo.getId(), userInfo.getTenantId(), userInfo.getPrimary(), userInfo.getDeptID(), userInfo.getJobId());
		OrganAuth organAuth = commonUtil.makeOrganAuth(userInfo.getId(), userInfo.getTenantId(), userInfo.getDeptID(), userInfo.getJobId());

		String isMasterAdmin = organAuth.isAuth(AdminAuth.ADMIN_MASTER) ? "y" : "";
		
		model.addAttribute("list", adminCompanyList);
		model.addAttribute("companyId", companyId);
		model.addAttribute("isMasterAdmin", isMasterAdmin);
		
		logger.debug("ended systemLoginHistMain controller.");
		
		return "/ezSystem/systemLoginHist";
		
	}
	
	/**
	 * 로그인 로그내역 데이터 리스트 호출
	 */
	@RequestMapping(value="/admin/ezSystem/systemLoginHistList.do", method = RequestMethod.POST)
	public String systemLoginHistList(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest req,
			@RequestParam(required=false)String searchKeycode, @RequestParam(required=false)String searchKeyword,
			@RequestParam(required=false)String searchKeycodeForStatus,
			@RequestParam(required=false)String startDate, @RequestParam(required=false)String endDate) throws Exception {
		
		logger.debug("started systemLoginHistList controller.");
		
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		String offset = userInfo.getOffset();
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
		
		/*
		 * 2018.11.21 김수아
		 * (전체관리자) 회사선택 후 선택한 회사의 로그인 히스토리가 나오도록 변경 
		 */
		String companyId = req.getParameter("companyId"); // 선택된 회사
		
		/*
		 * 2017.07.26 강민석
		 * 로그인 히스토리에는 자신의 회사만 나오도록 수정
		 * */
		//String companyId = userInfo.getCompanyID();
		logger.debug("companyId : " + companyId);

		String sysLang = ezCommonService.getTenantConfig("PrimaryLang", userInfo.getTenantId());

		if (userInfo.getLang().equals(sysLang))  {
			sysLang = "primary";
		}
		
		searchKeyword = searchKeyword.replace("%", "\\%").replace("_", "\\_");
		List<ConnectionInfoVO> loginHistList = ezSystemAdminService.getLoginHist(Integer.valueOf(userInfo.getTenantId()), 
				commonUtil.getMinuteUTC(offset), startRow, maxItemPerPage, searchKeycode, searchKeyword, searchKeycodeForStatus, sysLang, startDate, endDate, companyId);
		
		// 로그인 ip의 국가를 표시하기 위함 
		String systemLang = userInfo.getLang();
		String systemCountryName = "";
		String systemCountryCode = ezCommonService.getTenantConfig("systemCountryCode", userInfo.getTenantId());
		
		for(int i= 0; i < loginHistList.size(); i++){
			String ip = loginHistList.get(i).getConnectip();
			String countryName = "";
			String countryCode = "";
			
			if (ip.equals("0:0:0:0:0:0:0:1")) {
				ip = "127.0.0.1";
			}
			
			systemCountryName = commonUtil.getTwoLetterLangFromLangNum(systemLang, "ko");
			
			if (ip != null && !ip.equals("")) {
				if (commonUtil.checkLocalIP(ip)) {
					countryCode = systemCountryCode;
				} else {
					List<CountryVO> countryVo = commonUtil.getCountryInfo(ip);
					if (countryVo.size() == 0 ) {
						countryName = "?";
					} else {
						countryCode = countryVo.get(0).getCountryCode();
					}
				}
			} else {
				countryName = "?";
			}
			
			// 2023-05-25 이사라 : 시큐어코딩 문자열 비교 오류 수정
			if (!"?".equals(countryName)) {
				Locale localeCountry = new Locale(systemCountryName, countryCode);
				countryName = localeCountry.getDisplayCountry(localeCountry);
				countryName = countryName.replaceAll(" ", "");
			}
			loginHistList.get(i).setConnectCountryName(countryName);
			
		}
			
		int itemCnt = ezSystemAdminService.getLoginHistCount(userInfo.getTenantId(), commonUtil.getMinuteUTC(offset), searchKeycode, searchKeyword, searchKeycodeForStatus, sysLang, startDate, endDate, companyId);
		
		int totalPage = itemCnt / maxItemPerPage ;
		
		if (itemCnt < 1) {
			totalPage = 1;
		} 
		
		if ((totalPage * maxItemPerPage) != itemCnt && (itemCnt % maxItemPerPage) != 0) {
			totalPage = totalPage + 1 ;
		}
		
		currentPage = Math.min(currentPage, totalPage);	
		model.addAttribute("loginHistList", loginHistList); 
		model.addAttribute("lang", sysLang);
		model.addAttribute("currPage", currentPage);
		model.addAttribute("totalPage", totalPage);
		model.addAttribute("itemCnt", itemCnt);
		model.addAttribute("searchKeyword", searchKeyword);
		model.addAttribute("searchKeycode", searchKeycode);
		model.addAttribute("searchKeycodeForStatus", searchKeycodeForStatus);
		model.addAttribute("startDate", startDate);
		model.addAttribute("endDate", endDate);
		
		logger.debug("ended systemLoginHistList controller.");
		
		return "json";
	}
	
	/**
	 * 로그인 로그내역 메인 호출
	 */
	@RequestMapping(value="/ezSystem/systemLoginHist.do", method = RequestMethod.GET)
	public String systemLoginHistNotAdmin(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model) throws Exception {
		
		logger.debug("started systemLoginHistMain controller.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		String companyId = userInfo.getCompanyID();
		
		String LoginMailLogKeepPeriod = ezCommonService.getTenantConfig("LoginMailLogKeepPeriod", userInfo.getTenantId());
		LoginMailLogKeepPeriod = LoginMailLogKeepPeriod.equals("") ? "3" : LoginMailLogKeepPeriod;
		
		String mailLogKeepPeriodMessage = egovMessageSource.getMessage("ezStatistics.t1065", locale);
		mailLogKeepPeriodMessage = String.format(mailLogKeepPeriodMessage, LoginMailLogKeepPeriod);
		
		model.addAttribute("mailLogKeepPeriodMessage", mailLogKeepPeriodMessage);
		model.addAttribute("companyId", companyId);
		
		logger.debug("ended systemLoginHistMain controller.");
		
		return "/ezSystem/systemLoginHistNotAdmin";
		
	}
	
	/**
	 * 로그인 로그내역 데이터 리스트 호출
	 */
	@RequestMapping(value="/ezSystem/systemLoginHistList.do", method = RequestMethod.POST)
	public String systemLoginHistListNotAdmin(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest req,
			@RequestParam(required=false)String searchKeycode, @RequestParam(required=false)String searchKeyword,
			@RequestParam(required=false)String searchKeycodeForStatus,
			@RequestParam(required=false)String startDate, @RequestParam(required=false)String endDate) throws Exception {
		
		logger.debug("started systemLoginHistList controller.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String offset = userInfo.getOffset();
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
		
		/*
		 * 2018.11.21 김수아
		 * (전체관리자) 회사선택 후 선택한 회사의 로그인 히스토리가 나오도록 변경 
		 */
		String companyId = req.getParameter("companyId"); // 선택된 회사
		
		/*
		 * 2017.07.26 강민석
		 * 로그인 히스토리에는 자신의 회사만 나오도록 수정
		 * */
		//String companyId = userInfo.getCompanyID();
		logger.debug("companyId : " + companyId);
		
		String sysLang = ezCommonService.getTenantConfig("PrimaryLang", userInfo.getTenantId());
		
		if (userInfo.getLang().equals(sysLang))  {
			sysLang = "primary";
		}
		searchKeyword = searchKeyword.replace("%", "\\%").replace("_", "\\_");
		List<ConnectionInfoVO> loginHistList = ezSystemAdminService.getLoginHistNotAdmin(Integer.valueOf(userInfo.getTenantId()), 
				commonUtil.getMinuteUTC(offset), startRow, maxItemPerPage, searchKeycode, searchKeyword, searchKeycodeForStatus, sysLang, 
				startDate, endDate, companyId, userInfo.getId());
		
		// 로그인 ip의 국가를 표시하기 위함 
		String systemLang = userInfo.getLang();
		String systemCountryName = "";
		String systemCountryCode = ezCommonService.getTenantConfig("systemCountryCode", userInfo.getTenantId());
		
		for(int i= 0; i < loginHistList.size(); i++){
			String ip = loginHistList.get(i).getConnectip();
			String countryName = "";
			String countryCode = "";
			
			if (ip.equals("0:0:0:0:0:0:0:1")) {
				ip = "127.0.0.1";
			}
			
			systemCountryName = commonUtil.getTwoLetterLangFromLangNum(systemLang, "ko");
			
			if (ip != null && !ip.equals("")) {
				if (commonUtil.checkLocalIP(ip)) {
					countryCode = systemCountryCode;
				} else {
					List<CountryVO> countryVo = commonUtil.getCountryInfo(ip);
					if (countryVo.size() == 0 ) {
						countryName = "?";
					} else {
						countryCode = countryVo.get(0).getCountryCode();
					}
				}
			} else {
				countryName = "?";
			}
			
			// 2023-05-25 이사라 : 시큐어코딩 문자열 비교 오류 수정
			if (!"?".equals(countryName)) {
				Locale localeCountry = new Locale(systemCountryName, countryCode);
				countryName = localeCountry.getDisplayCountry(localeCountry);
				countryName = countryName.replaceAll(" ", "");
			}
			loginHistList.get(i).setConnectCountryName(countryName);
			
		}
		
		int itemCnt = ezSystemAdminService.getLoginHistCountNotAdmin(userInfo.getTenantId(), commonUtil.getMinuteUTC(offset), 
				searchKeycode, searchKeyword, searchKeycodeForStatus, sysLang, startDate, endDate, companyId, userInfo.getId());
		
		int totalPage = itemCnt / maxItemPerPage ;
		
		if (itemCnt < 1) {
			totalPage = 1;
		} 
		
		if ((totalPage * maxItemPerPage) != itemCnt && (itemCnt % maxItemPerPage) != 0) {
			totalPage = totalPage + 1 ;
		}
		
		currentPage = Math.min(currentPage, totalPage);	
		model.addAttribute("loginHistList", loginHistList); 
		model.addAttribute("lang", sysLang);
		model.addAttribute("currPage", currentPage);
		model.addAttribute("totalPage", totalPage);
		model.addAttribute("itemCnt", itemCnt);
		model.addAttribute("searchKeyword", searchKeyword);
		model.addAttribute("searchKeycode", searchKeycode);
		model.addAttribute("searchKeycodeForStatus", searchKeycodeForStatus);
		model.addAttribute("startDate", startDate);
		model.addAttribute("endDate", endDate);
		
		logger.debug("ended systemLoginHistList controller.");
		
		return "json";
	}
	
	/*
	 * 엑셀 워크시트 생성 및 자동 다운로드 함수
	 * 2021-12-30 이사라 : 로그아웃시간, 상태 추가
	 */
	@RequestMapping(value = "/admin/ezSystem/systemLoginHistExcelExport.do", method = RequestMethod.GET)
	@ResponseBody
	public void statisticsMailLogExcelExport(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request,
			String searchKeycode, String searchKeyword, String searchKeycodeForStatus, String startDate, String endDate, Locale locale, HttpServletResponse response)  throws Exception {
		logger.debug("systemLoginHistExcelExport controller started.");
		
		LoginVO userInfoUser = commonUtil.userInfo(loginCookie);
		
		String offset = userInfoUser.getOffset();
		String currPage = request.getParameter("pageNum");
		String config = request.getParameter("config");	// 사용자화면에서도 사용하기 위해
		if (config == null) {
			config = "";
		}
		logger.debug("config=" + config);
		
		int maxItemPerPage = 20; 
		int startRow = Math.multiplyExact(Math.subtractExact(Integer.parseInt(currPage), 1), maxItemPerPage);
		
		if (currPage.equals("-1")) {
			startRow = -1;
		}

		String companyId = request.getParameter("companyId"); // 선택된 회사
		
		String sysLang = ezCommonService.getTenantConfig("PrimaryLang", userInfoUser.getTenantId());

		if (userInfoUser.getLang().equals(sysLang))  {
			sysLang = "primary";
		}
		
		searchKeyword = searchKeyword.replace("%", "\\%").replace("_", "\\_");
		List<ConnectionInfoVO> loginHistList = new ArrayList<ConnectionInfoVO>();
		int totalCount = 0;
		if (config.equals("u")){
			loginHistList = ezSystemAdminService.getLoginHistNotAdmin(Integer.valueOf(userInfoUser.getTenantId()), 
					commonUtil.getMinuteUTC(offset), startRow, maxItemPerPage, searchKeycode, searchKeyword, searchKeycodeForStatus, sysLang, 
					startDate, endDate, companyId, userInfoUser.getId());
			totalCount = ezSystemAdminService.getLoginHistCountNotAdmin(userInfoUser.getTenantId(), commonUtil.getMinuteUTC(offset), 
					searchKeycode, searchKeyword, searchKeycodeForStatus, sysLang, startDate, endDate, companyId, userInfoUser.getId());
		} else {
			loginHistList = ezSystemAdminService.getLoginHist(Integer.valueOf(userInfoUser.getTenantId()), 
					commonUtil.getMinuteUTC(offset), startRow, maxItemPerPage, searchKeycode, searchKeyword, searchKeycodeForStatus,sysLang, startDate, endDate, companyId);
			totalCount = ezSystemAdminService.getLoginHistCount(userInfoUser.getTenantId(), commonUtil.getMinuteUTC(offset), searchKeycode, searchKeyword, searchKeycodeForStatus, sysLang, startDate, endDate, companyId);
		}
		
		/* 엑셀 만들기 */
		try (HSSFWorkbook workbook = new HSSFWorkbook()) {
			HSSFSheet sheet = workbook.createSheet("LoginLogList");
			
			Row row = null;
			Cell cell = null;
			
			String fileName = "";
			fileName = startDate +"_"+ endDate + "_LoginLogList";
			
			HSSFCellStyle headerStyle = workbook.createCellStyle();
			headerStyle.setFillForegroundColor(HSSFColor.GREY_25_PERCENT.index);
			headerStyle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
			headerStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
			headerStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
			headerStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
			headerStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
			headerStyle.setVerticalAlignment((short)1);
			
			HSSFCellStyle bodyStyle = workbook.createCellStyle();
			bodyStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
			bodyStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
			bodyStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
			bodyStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
	
			HSSFFont font = workbook.createFont();
			font.setBoldweight((short)HSSFFont.BOLDWEIGHT_BOLD);
			headerStyle.setFont(font);
			
			String histHeader = config.equals("u") ? egovMessageSource.getMessage("ezSystem.ksaLoginHistUser", locale) : egovMessageSource.getMessage("ezSystem.ksaLoginHistAdmin", locale);
			String[] histHeaderArr = histHeader.split(";");
			int histHeaderLen = histHeaderArr.length;
			
			row = sheet.createRow(0);
			cell = row.createCell(0);	
			cell.setCellValue(egovMessageSource.getMessage("ezSystem.x0032", locale) + " : " + startDate + " ~ " + endDate);
			cell = row.createCell(histHeaderLen-1);
			cell.setCellValue(egovMessageSource.getMessage("main.t252", locale) + " " + totalCount + egovMessageSource.getMessage("ezSystem.kyj2", locale));
			
			row = sheet.createRow(1);
			for (int i = 0; i < histHeaderLen; i ++) {
				cell = row.createCell(i);	cell.setCellValue(histHeaderArr[i]); 
				cell.setCellStyle(headerStyle);
			}
			
			String systemLang = userInfoUser.getLang();
			String systemCountryName = "";
			String systemCountryCode = ezCommonService.getTenantConfig("systemCountryCode", userInfoUser.getTenantId());
			
			for (int i = 2; i < totalCount + 2; i++) {
				row = sheet.createRow(i);
				row.setHeight((short)300);
				int j = 2;
				
				ConnectionInfoVO infoVo = loginHistList.get(i-j);
				String userName = infoVo.getUsernm() + "(" + infoVo.getUserid() + ")";
				String userDeptName = infoVo.getDeptnm();
				String userCompanyName = infoVo.getCompanynm();
				if (!sysLang.equals("primary")) {
					userName = infoVo.getUsernm2() + "(" + infoVo.getUserid() + ")";
					userDeptName = infoVo.getDeptnm2();
					userCompanyName = infoVo.getCompanynm2();
				}
				
				// countryIP 관련 국가명 표시 위함 시작.
				String ip = loginHistList.get(i-j).getConnectip();
				String countryName = "";
				String countryCode = "";
				
				if (ip.equals("0:0:0:0:0:0:0:1")) {
					ip = "127.0.0.1";
				}
				
				systemCountryName = commonUtil.getTwoLetterLangFromLangNum(systemLang, "ko");
				
				if (ip != null && !ip.equals("")) {
					if (commonUtil.checkLocalIP(ip)) {
						countryCode = systemCountryCode;
					} else {
						List<CountryVO> countryVo = commonUtil.getCountryInfo(ip);
						if (countryVo.size() == 0 ) {
							countryName = "?";
						} else {
							countryCode = countryVo.get(0).getCountryCode();
						}
					}
				} else {
					countryName = "?";
				}
				
				if (!"?".equals(countryName)) {
					Locale localeCountry = new Locale(systemCountryName, countryCode);
					countryName = localeCountry.getDisplayCountry(localeCountry);
					countryName = countryName.replaceAll(" ", "");
				}
				loginHistList.get(i-j).setConnectCountryName(countryName);
				// countryIP 관련 국가명 표시 위함 끝.
				
				String userConnectIp = infoVo.getConnectip() + "(" + loginHistList.get(i-j).getConnectCountryName() + ")";
				String userConnectTime = infoVo.getConnecttime();
				String userDisconnectTime = infoVo.getDisconnecttime();
				String userConnectBrowser = infoVo.getConnectbrowser();
				String userConnectOS = infoVo.getConnectos();
				String userStatus = infoVo.getStatus() == null ? "Y" : infoVo.getStatus();
				
				userStatus = userStatus.equals("Y") ? egovMessageSource.getMessage("ezSystem.ls04", locale) : egovMessageSource.getMessage("ezSystem.ls05", locale);
				
				//if (userStatus !) {
					
				//}
				
				String[] userHist = null;
				
				if (config.equals("u")){
					userHist = new String [] {userName,userDeptName,userConnectIp,userConnectTime,userDisconnectTime,userConnectBrowser,userConnectOS,userStatus};
				} else {
					userHist = new String [] {userName,userDeptName,userCompanyName,userConnectIp,userConnectTime,userDisconnectTime,userConnectBrowser,userConnectOS,userStatus};
				}
				
				for (int k = 0; k < histHeaderLen; k ++) {
					cell = row.createCell(k);	cell.setCellValue((String) userHist[k]); 
					cell.setCellStyle(bodyStyle);
				}
				
				sheet.autoSizeColumn(i-1);
			}
			
			response.setCharacterEncoding("UTF-8");
			response.setHeader("Content-Disposition", "attachment; fileName=" + fileName + ".xls");
			response.setContentType("application/vnd.ms-excel");
			
			workbook.write(response.getOutputStream());
			//workbook.close();
		}
		
		logger.debug("systemLoginHistExcelExport controller ended.");
	}	
	
	/**
	 * 전체 서버 목록 가져오기.
	 * config.properties에 현재 포함 다른 서버 목록 전부 저장
	 * */
	@RequestMapping(value = {"/admin/ezSystem/sysREST.do", "/gCloud/sysREST.do"}, method=RequestMethod.GET)
	public String sysREST(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request , Model model) throws Exception {
		logger.debug("sysREST started.");
		
		String requestURL = (String) request.getAttribute(HandlerMapping.PATH_WITHIN_HANDLER_MAPPING_ATTRIBUTE);
		
		if (requestURL.indexOf("admin/ezSystem") > -1) {
			//관리자 권한 체크
			LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
			
			if (userInfo == null) {
				return "cmm/error/adminDenied";
			}
			
			model.addAttribute("cloudFlag", false);
		} else {
			model.addAttribute("cloudFlag", true);
		}
		
		InetAddress local = InetAddress.getLocalHost();
		String localIP = local.getHostAddress();		
		logger.debug("localIP : " + localIP);		
		
		String serverName = request.getServerName();
		String curServer = config.getProperty("config.curServer");
	
		/**
		 * config.properties에 있는 서버 목록 불러오기
		 * */
		int n = 1;
		ArrayList<String> serverList = new ArrayList<String>();
		ArrayList<String> getServerList = new ArrayList<String>();
		while (true) {
			// 1. 첫 번째 서버 정보의 갯수가 1, 정보가 존재하지 않는 경우
			// 2. 정보가 더이상 존재하지 않는 경우
			// 3. 그 외는 serverList에 저장
			//logger.debug("server name : " + config.getProperty("config.SysServer" + n) );
			if (n == 1 && config.getProperty("config.SysServer" + n) == null) {
				logger.debug("Empty serverlist in configProperties.");
				getServerList.add("EMPTY");
				break;
			} else if (config.getProperty("config.SysServer" + n) == null) {
				logger.debug("Searching serverlist is ending.");
				break;
			} else {
				getServerList.add(config.getProperty("config.SysServer" + n));
				n ++;
			}
		}

		serverList = ezSystemAdminService.getServerInfo(localIP, config.getProperty("config." + curServer) ,serverName, getServerList);

		model.addAttribute("serverList", serverList);
		model.addAttribute("curServer", curServer);
		
		logger.debug("sysREST ended.");		
		return "/ezSystem/sysMonitor";
	}

	/**
	 * 선택된 서버의 CPU, 메모리, 네트워크 등 정보 가져오기
	 * */
	@RequestMapping(value = {"/admin/ezSystem/sysMonitorREST.do", "/gCloud/sysMonitorREST.do"}, method=RequestMethod.POST)
	public String sysMonitorREST(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		logger.debug("sysMonitorREST started.");
		logger.debug("<<<serverSN : " + request.getParameter("serverSN"));
		
		String requestURL = (String) request.getAttribute(HandlerMapping.PATH_WITHIN_HANDLER_MAPPING_ATTRIBUTE);
		
		if (requestURL.indexOf("admin/ezSystem") > -1) {
			//관리자 권한체크
			LoginVO userInfo = commonUtil.checkAdmin(loginCookie);	
			
			if (userInfo == null) {
				return "cmm/error/adminDenied";
			}		
		}
		
		InetAddress local = InetAddress.getLocalHost();
		String localIP = local.getHostAddress();		
		logger.debug("localIP : " + localIP);		
		
		String serverName = request.getServerName();
		String serverSN = request.getParameter("serverSN"); //0부터 찍힘
		String hostInfo = "config.SysServer" + serverSN; 
		String address = config.getProperty(hostInfo);		
		String curServer = request.getParameter("curServer");
		boolean chkServer; 
		
		// 현재 서버와 조회하는 서버가 같을 경우
		if (curServer.equalsIgnoreCase("SysServer"+serverSN)) {
			chkServer = true;
		} else {
			chkServer = false;
		}
		
		String result = ezSystemAdminService.getSysMonitorInfo(localIP, serverName, address, chkServer);

		/**
		 * RESTful API로 받아온 데이터를 가공해서 던짐
		 * */
		JSONParser parser = new JSONParser();
		JSONObject jObj = (JSONObject) parser.parse(result);
		JSONArray jArr = (JSONArray) jObj.get("getSysMonitorInfo");

		logger.debug(jArr.get(0).toString());
		logger.debug(jArr.get(1).toString());
		logger.debug(jArr.get(2).toString());
		logger.debug(jArr.get(3).toString());
		logger.debug(jArr.get(4).toString());
		logger.debug(jArr.get(5).toString());
		
		model.addAttribute("osInfo", jArr.get(0).toString());
		model.addAttribute("cpuInfo", jArr.get(1).toString());
		model.addAttribute("memoryInfo", jArr.get(2).toString());
		model.addAttribute("fileSysInfoList", jArr.get(3).toString());
		model.addAttribute("diskioInfo", jArr.get(4).toString());
		model.addAttribute("netTrafficList", jArr.get(5).toString());
		
		logger.debug("sysMonitorREST ended.");
		
		return "json";
	}
	
	/**
	 * 타 서버에서 이 서버로 RESTful로 접근할 때 발생
	 * 서버리스트 정보 가져오기
	 * */
	@RequestMapping(value="/ezSystem/util/getSysInfo", method=RequestMethod.POST)
	@ResponseBody
	public String getSysInfo () throws Exception {
		
		logger.debug("inner getSysInfo start.");
		
		String result = "";
		InetAddress local = InetAddress.getLocalHost();
		String localIP = local.getHostAddress();		
		logger.debug("localIP : " + localIP);		
		
		String serverList = EzSystemUtil.getSysInfo(localIP);
		
		if (serverList.equalsIgnoreCase(null)) {
			result ="FALSE";
		} else {
			result = serverList;
		}
		
		logger.debug("getSysInfo end.");
		
		return result;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/ezSystem/util/getSysMonitorInfo", method=RequestMethod.POST)
	@ResponseBody
	public String getSysMonitorInfo () throws Exception {
		
		logger.debug("inner getSysMonitorInfo start.");
		
		JSONObject jObj = new JSONObject();
		JSONArray jArr = new JSONArray();
		
		InetAddress local = InetAddress.getLocalHost();
		String localIP = local.getHostAddress();		
		logger.debug("localIP : " + localIP);
		
		String osInfo = EzSystemUtil.getSysInfo(localIP);
		String cpuInfo = EzSystemUtil.getCpuInfo(localIP);
		String memoryInfo = EzSystemUtil.getMemoryInfo(localIP);
		String fileSysInfoList  = EzSystemUtil.getFileSysInfo(localIP);
		String diskioInfo = EzSystemUtil.getDiskioInfo(localIP);
		String netTrafficList = EzSystemUtil.getNetDataInfo(localIP);
		
		jArr.add(osInfo);
		jArr.add(cpuInfo);
		jArr.add(memoryInfo);
		jArr.add(fileSysInfoList);
		jArr.add(diskioInfo);
		jArr.add(netTrafficList);
		
		jObj.put("getSysMonitorInfo", jArr);
		
		logger.debug("getSysMonitorInfo end.");
		
		return jObj.toString();
	}

	@RequestMapping(value="/admin/ezSystem/systemIPManager.do", method=RequestMethod.GET)
	public String systemIPManager(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("systemIPManager started");
		
		//관리자 권한체크
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);

		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}

		String useIPAccess = ezCommonService.getTenantConfig("useIPAccess", userInfo.getTenantId());

		model.addAttribute("useIPAccess", useIPAccess);
		model.addAttribute("rollInfo", userInfo.getRollInfo());

		logger.debug("systemIPManager ended");
		 
		return "/ezSystem/systemIPManager";
	}
	
	@RequestMapping(value="/ezSystem/systemIPCountryAccessList.do", method=RequestMethod.GET)
	public String systemIPCountryAccessList(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("systemIPCountryAccessList started");
		
		//관리자 권한체크
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);

		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}

		String realPath = request.getSession().getServletContext().getRealPath("/");
		List<CountryVO> countryList = countryVOList(null, userInfo.getLang(), realPath);
		
		model.addAttribute("countryList", countryList);
		logger.debug("systemIPCountryAccessList ended");
		 
		return "/ezSystem/systemIPCountryAccessList";
	}
	
	/*
	 * 접속 허용 국가 리스트
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/ezSystem/getAccessCountryList.do", method=RequestMethod.POST)
	public String getAccessCountryList(@CookieValue("loginCookie") String loginCookie, Model model, 
			HttpServletRequest request) throws Exception {
		logger.debug("getAccessCountryList started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String realPath = request.getSession().getServletContext().getRealPath("/");

		String countryCodeList = ezSystemAdminService.getAccessCountryList(userInfo.getTenantId()); // 허용 국가코드 리스트
		
		if (!countryCodeList.trim().equals("")) {
			String [] countryCodeArr = countryCodeList.split(";");
			logger.debug("countryCodeList=" + countryCodeList + ", countryCodeArrLen=" + countryCodeArr.length);

			List<CountryVO> countryList = countryVOList(countryCodeArr, userInfo.getLang(), realPath);
			logger.debug("countryList= " + countryList.size());
			
			JSONArray returnJsonArr = new JSONArray();
			for (CountryVO vo : countryList) {
				JSONObject putObj = new JSONObject();
				putObj.put("countryCode", vo.getCountryCode()); // 국가코드
				putObj.put("countryName", vo.getCountryName()); // 국가명
				putObj.put("imagePath", vo.getImagePath()); // 이미지
				
				returnJsonArr.add(putObj);
			}
			logger.debug("returnJsonArr=" + returnJsonArr.toString());
			
			model.addAttribute("data", returnJsonArr);
		} 
		
		logger.debug("getAccessCountryList ended");
		
		return "json";
	}
	
	/*
	 * 접속 허용 국가 저장
	 */
	@RequestMapping(value="/ezSystem/saveAccessCountryList.do", method=RequestMethod.POST)
	@ResponseBody
	public String saveAccessCountryList(@CookieValue("loginCookie") String loginCookie, Model model, 
			HttpServletRequest request) throws Exception {
		logger.debug("saveAccessCountryList started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String result = "OK";
		if (userInfo.getRollInfo().indexOf("c=1") == -1) {
			result = "PERMISSION_ERROR";
			return result;
		}
		
		String saveCountryList = request.getParameter("saveList");
		logger.debug("saveCountryList=" + saveCountryList);

		int tenantID = userInfo.getTenantId();

		String useIPAccess = ezCommonService.getTenantConfig("useIPAccess", tenantID);
		result = ezSystemAdminService.isExistSystemAccess(saveCountryList, "country", useIPAccess, tenantID);

		if ("success".equalsIgnoreCase(result)){
			ezSystemAdminService.setAccessCountry(userInfo.getTenantId(), saveCountryList);
			logger.debug("setAccessCountry success");
		}
		
		logger.debug("saveAccessCountryList ended");
		return result;
	}
	
	
	@RequestMapping(value="/ezSystem/systemIPBand.do", method=RequestMethod.GET)
	public String systemIPBand(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("systemIPBand started");
		
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);

		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}

		String useIPAccess = ezCommonService.getTenantConfig("useIPAccess", userInfo.getTenantId());
		
		if (useIPAccess == null || useIPAccess.equals("")) {
			useIPAccess = "NO"; // 기본값은 사용안함
		}
				
		model.addAttribute("useIPAccess", useIPAccess);
		model.addAttribute("rollInfo", userInfo.getRollInfo());
		
		logger.debug("systemIPBand ended");
		return "/ezSystem/systemIPBand";
	}
	
	@RequestMapping(value="/ezSystem/setUseIPAccess.do", method=RequestMethod.POST)
	@ResponseBody
	public String setUseIPAccess(@CookieValue("loginCookie") String loginCookie, Model model, String allowResult) throws Exception {
		logger.debug("setUseIPAccess started");
		
		// input 체크된 값으로 전달되기 때문에 tbl_tenant_config value에 맞게 변경
		if (allowResult.equals("true")) {
			allowResult = "YES";
		} else {
			allowResult = "NO";
		}
		
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);

		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}

		if (allowResult.equalsIgnoreCase("YES")){
			List<String> userList = ezSystemAdminService.getAllAccessListCom(userInfo.getTenantId());
			String countryCodeList = ezSystemAdminService.getAccessCountryList(userInfo.getTenantId());
			List<IPBandVO> ipList = ezSystemAdminService.getAllIPBand(userInfo.getTenantId());
			int accessIp = 0;
			for(int i = 0; i < ipList.size(); i++) {
				if ("YES".equalsIgnoreCase(ipList.get(i).getAccess())){
					accessIp += 1;
				}
			}

			if (userList.size() == 0 && "".equalsIgnoreCase(countryCodeList) && accessIp ==0){
				return "setAccess";
			}
		}

		ezSystemAdminService.updateSystemIPAllow(allowResult, userInfo.getTenantId());
		
		logger.debug("setUseIPAccess ended");
		return "/ezSystem/systemIPBand";
	}
	
	@ResponseBody
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/ezSystem/getAllIPBands.do", method=RequestMethod.POST)
	public ResponseEntity<JSONArray> getAllIPBands(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("setUseIPAccess started");
		
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);

		if (userInfo == null) {
			logger.debug("setUseIPAccess accessDenied");

			return ResponseEntity.status(HttpStatus.FORBIDDEN).body(new JSONArray());
		}

		List<IPBandVO> list = ezSystemAdminService.getAllIPBand(userInfo.getTenantId());
		
		if (list == null) {
			return null;
		}
		
		JSONArray returnJsonArr = new JSONArray();
		
		for (int i = 0; i < list.size(); i++) {
			JSONObject obj = new JSONObject();
			obj.put("ipNo", list.get(i).getIpNo());
			obj.put("ipAddress", list.get(i).getIpAddress());
			obj.put("access", list.get(i).getAccess());
			obj.put("explanation", list.get(i).getExplanation());
			returnJsonArr.add(obj);
		}
		
		logger.debug("returnJsonArr=" + returnJsonArr.toJSONString());
		logger.debug("getAllIPBands ended");
		return ResponseEntity.ok().body(returnJsonArr);
	}
	
	@ResponseBody
	@RequestMapping(value="/ezSystem/insertIPBand.do", method=RequestMethod.POST)
	public ResponseEntity<Void> insertIPBand(@CookieValue("loginCookie") String loginCookie, @ModelAttribute IPBandVO ipBand) throws Exception {
		logger.debug("insertIPBand started");
		
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);

		if (userInfo == null) {
			logger.debug("insertIPBand accessDenied");

			return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
		}

		ezSystemAdminService.insertIPBand(userInfo.getTenantId(), ipBand.getIpAddress(), ipBand.getAccess(), ipBand.getExplanation() == null ? "" : ipBand.getExplanation());
		
		logger.debug("insertIPBand ended");
		return ResponseEntity.noContent().build();
	}
	
	@ResponseBody
	@RequestMapping(value="/ezSystem/updateIPBand.do", method=RequestMethod.POST)
	public void updateIPBand(@CookieValue("loginCookie") String loginCookie, Model model, @ModelAttribute IPBandVO ipBand) throws Exception {
		logger.debug("updateIPBand started");
		logger.debug("ipNo=" + ipBand.getIpNo() + ", ipAddress=" + ipBand.getIpAddress() + ", access=" + ipBand.getAccess() + ", explanation=" + ipBand.getExplanation());
		
		ezSystemAdminService.updateIPBand(ipBand.getIpNo(), ipBand.getIpAddress(), ipBand.getAccess(), ipBand.getExplanation());
		
		logger.debug("updateIPBand ended");
	}
	
	@ResponseBody
	@RequestMapping(value="/ezSystem/deleteIPBand.do", method=RequestMethod.POST)
	public String deleteIPBand(@CookieValue("loginCookie") String loginCookie, Model model, String ipNo) throws Exception {
		logger.debug("deleteIPBand started");
		logger.debug("ipNo=" + ipNo);

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		int tenantID = userInfo.getTenantId();

		String useIPAccess = ezCommonService.getTenantConfig("useIPAccess", tenantID);
		String result = ezSystemAdminService.isExistSystemAccess(ipNo, "ip", useIPAccess, tenantID);

		if ("success".equalsIgnoreCase(result)){
			ezSystemAdminService.deleteIPBand(ipNo);
			logger.debug("deleteIPBand success");
		}
		
		logger.debug("deleteIPBand ended");

		return result;
	}
	
	
	@RequestMapping(value="/ezSystem/systemIPBandEditPopup.do", method=RequestMethod.GET)
	public String systemIPBandEditPopup(@CookieValue("loginCookie") String loginCookie, Model model,
			@ModelAttribute IPBandVO ipBand, HttpServletRequest request) throws Exception {
		logger.debug("systemIPBandEditPopup started");
		
		String type = request.getParameter("type");
		String pageType = request.getParameter("pageType"); // pageType=adminIpAccess
		pageType = pageType == null ? "" : pageType;
		
		String ipAddress = "";
		String access = "";
		String explanation = "";
		
		if (type.equals("modify")) {
			IPBandVO getIPBand = null;
			if (pageType.equals("adminIpAccess")) { // 관리자 IP 제한
				getIPBand = ezSystemAdminService.getSystemAdminIPBand(ipBand.getIpNo());
			} else if (pageType.equals("fidoAuthentication")) { //Fido인증 관리
				getIPBand = ezSystemAdminService.getSystemFidoIPBand(ipBand.getIpNo());
			} else {
				getIPBand = ezSystemAdminService.getSystemIPBand(ipBand.getIpNo());
			}
			
			ipAddress = getIPBand.getIpAddress();
			access = getIPBand.getAccess();
			explanation = getIPBand.getExplanation();
			explanation = explanation.replaceAll("\\\\", "\\\\\\\\");
			
			logger.debug("explanation=" + explanation);
		}
		
		model.addAttribute("ipNo", ipBand.getIpNo() == null ? "" : ipBand.getIpNo());
		model.addAttribute("ipAddress", ipAddress);
		model.addAttribute("access", access);
		model.addAttribute("explanation", explanation);
		model.addAttribute("type", type);
		model.addAttribute("pageType", pageType);
				
		logger.debug("systemIPBandEditPopup ended");
		return "/ezSystem/systemIPBandEditPopup";
	}
	 
	
	
	@RequestMapping(value="/ezSystem/systemIPAccessList.do", method=RequestMethod.GET)
	public String systemIPAccessList(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("systemIPAccessList started");
		
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);

		if(userInfo == null) {
			return "cmm/error/adminDenied";
		}

		List<OrganDeptVO> list = ezOrganAdminService.getCompanyList(userInfo.getPrimary(), userInfo.getTenantId());
		List<OrganDeptVO> resultList = new ArrayList<OrganDeptVO>();

		for (int i = 0; i < list.size(); i++) {
			OrganDeptVO vo = list.get(i);

			if (userInfo.getRollInfo().contains("c=1") || (userInfo.getRollInfo().contains("k=1") && vo.getCn().equals(userInfo.getCompanyID()))) {
				resultList.add(vo);
			}

		}

		model.addAttribute("userInfo", userInfo);
		model.addAttribute("list", resultList);
				
		logger.debug("systemIPAccessList ended");
		return "/ezSystem/systemIPAccessList";
	}
	
	
	@SuppressWarnings("unchecked")
	@ResponseBody
	@RequestMapping(value="/ezSystem/getAllAccessList.do", method=RequestMethod.POST)
	public ResponseEntity<JSONArray> getAllAccessList(@CookieValue("loginCookie") String loginCookie, String companyID) throws Exception {
		logger.debug("getAllAccessList started");
		
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);

		if (userInfo == null) {
			logger.debug("getAllAccessList accessDenied");

			return ResponseEntity.status(HttpStatus.FORBIDDEN).body(new JSONArray());
		}

		List<AccessIdVO> userList = ezSystemAdminService.getAllAccessList(userInfo.getPrimary(), userInfo.getTenantId(), companyID);
		List<AccessIdVO> deptList = ezSystemAdminService.getAllAccessListDept(userInfo.getPrimary(), userInfo.getTenantId(), companyID);
		JSONArray returnJsonArr = new JSONArray();
		
		for (int i = 0; i < userList.size(); i++) {
			JSONObject obj = new JSONObject();
			obj.put("accessNo", userList.get(i).getAccessNo());
			obj.put("cn", userList.get(i).getCn());
			obj.put("name", userList.get(i).getName());
			obj.put("department", userList.get(i).getDepartment());
			returnJsonArr.add(obj);
		}
		
		for (int i = 0; i < deptList.size(); i++) {
			JSONObject obj = new JSONObject();
			obj.put("accessNo", deptList.get(i).getAccessNo());
			obj.put("cn", deptList.get(i).getCn());
			obj.put("name", deptList.get(i).getName());
			obj.put("department", deptList.get(i).getDepartment());
			returnJsonArr.add(obj);
		}
		
		
		logger.debug("returnJsonArr=" + returnJsonArr.toJSONString());
		logger.debug("getAllAccessList ended");

		return ResponseEntity.ok().body(returnJsonArr);
	}
	
	@SuppressWarnings("unchecked")
	@ResponseBody
	@RequestMapping(value="/ezSystem/getAllAccessListCom.do", method=RequestMethod.POST)
	public ResponseEntity<JSONArray> getAllAccessListCom(@CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("getAllAccessListCom started");
		
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);

		if (userInfo == null) {
			logger.debug("getAllAccessListCom accessDenied");

			return ResponseEntity.status(HttpStatus.FORBIDDEN).body(new JSONArray());
		}

		List<String> allList = ezSystemAdminService.getAllAccessListCom(userInfo.getTenantId());
		JSONArray returnJsonArr = new JSONArray();
		
		for (int i = 0; i < allList.size(); i++) {
			JSONObject obj = new JSONObject();
			obj.put("cn", allList.get(i));
			returnJsonArr.add(obj);
		}
		
		
		logger.debug("returnJsonArr=" + returnJsonArr.toJSONString());
		logger.debug("getAllAccessListCom ended");
		
		return ResponseEntity.ok().body(returnJsonArr);
	}
	
	
	
	@ResponseBody
	@RequestMapping(value="/ezSystem/insertAccessId", method=RequestMethod.POST)
	public ResponseEntity<Void> insertAccessId(@CookieValue("loginCookie") String loginCookie, String strCnList) throws Exception {
		logger.debug("insertAccessId started");
		
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);

		if (userInfo == null) {
			logger.debug("insertAccessId accessDenied");

			return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
		}

		ezSystemAdminService.insertAccessId(userInfo.getTenantId(), strCnList);
		logger.debug("insertAccessId ended");

		return ResponseEntity.noContent().build();
	}
	
	@ResponseBody
	@RequestMapping(value="/ezSystem/deleteAccessList.do", method=RequestMethod.POST)
	public String deleteAccessList(@CookieValue("loginCookie") String loginCookie, Model model, String accessNo) throws Exception {
		logger.debug("deleteAccessList started. accessNo=" + accessNo);

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		int tenantID = userInfo.getTenantId();

		String useIPAccess = ezCommonService.getTenantConfig("useIPAccess", tenantID);
		String result = ezSystemAdminService.isExistSystemAccess(accessNo, "id", useIPAccess, tenantID);

		if ("success".equalsIgnoreCase(result)){
			ezSystemAdminService.deleteAccessId(accessNo);
			logger.debug("deleteAccessList success");
		}
		
		logger.debug("deleteAccessList ended");
		return result;
	}
	
	@RequestMapping(value="/ezSystem/systemAddAccessList.do", method=RequestMethod.GET)
	public String systemAddAccessList(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		logger.debug("systemAddAccessList started");
		
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);

		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}

		String topID = userInfo.getCompanyID();
		String companyId = request.getParameter("companyId");
		String adminChk = "false";
		topID = companyId;

		if (userInfo.getRollInfo().indexOf("c=1") != -1) {
			adminChk = "true";
		}
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("topID", topID);
		model.addAttribute("adminChk", adminChk);
		
		logger.debug("systemAddAccessList ended");
		return "/ezSystem/systemAddAccessList";
	}
	
	// 세션 있는지 확인 후 없으면 추가
	// 2018-11-16일 추가
	@RequestMapping(value="/admin/ezSystem/checkUseSession.do", method=RequestMethod.GET, produces="application/json;charset=utf-8")
	@ResponseBody
	public String checkUseSession(Locale locale, @ModelAttribute("loginVO") LoginVO loginVO, HttpSession session, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		logger.debug("checkUseSession started");

		String serverName = request.getServerName();
        
		int tenantId = loginService.getTenantId(serverName);
		
		// 20190828 김수아 : 세션 유지 시간 모바일 추가하면서 수정
		Map<String, String> sessionConfig = new HashMap<String, String>();
		sessionConfig.put("useSession", ezCommonService.getTenantConfig("useSession", tenantId));
		sessionConfig.put("useSessionMobile", ezCommonService.getTenantConfig("useSessionMobile", tenantId));
		
		// tenant_config 테이블에 useSession row 없으면 추가
		for (String key : sessionConfig.keySet()) {
			if (sessionConfig.get(key).equals("")) {
				String configName = key.equals("useSessionMobile") ? "세션 유지 시간(모바일)" : "세션 유지 시간";
				
				Map<String, Object> sessionParam = new HashMap<String, Object>();
				
				sessionParam.put("tenantID", tenantId);
				sessionParam.put("confName", key);
	    		sessionParam.put("property_value", "0");
				sessionParam.put("description", "세션 유지 시간. 단, 0이면 세션 사용 안함");
				sessionParam.put("config_name", configName);
				sessionParam.put("config_type", "일반");
				
				String regdate = commonUtil.getTodayUTCTime("");
				
				sessionParam.put("regdate", regdate);
				
				ezCommonService.insertUseSession(sessionParam);
			}
		}
		
		logger.debug("checkUseSession ended");
		return "";
	}
	
	@RequestMapping(value = "/admin/ezSystem/systemModuleMonitor.do", method=RequestMethod.GET)
	public String systemModuleMonitor(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String packageType = commonUtil.getPackageType(userInfo.getTenantId());
		
		model.addAttribute("packageType", packageType);
		
		return "/ezSystem/systemModuleMonitor";
	}
	
	@RequestMapping(value = "/admin/ezSystem/getModuleMonitor.do", method=RequestMethod.GET)
	public ResponseEntity<ModuleSizeVO> getModuleMonitor(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("systemModuleMonitorOMS started");
		
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);

		if (userInfo == null) {
			logger.debug("systemModuleMonitorOMS accessDenied");

			return ResponseEntity.status(HttpStatus.FORBIDDEN).body(new ModuleSizeVO());
		}
		
		String useModuleUsage = ezCommonService.getTenantConfig("useModuleUsage", userInfo.getTenantId());
		String packageType = commonUtil.getPackageType(userInfo.getTenantId());
		
		ModuleSizeVO moduleSizeVO = null;

		if(useModuleUsage != null && useModuleUsage.equalsIgnoreCase("yes")) {
			List<String> moduleNames = null;

			switch (packageType) {
			case CommonUtil.PT_STANDARD:
				moduleNames = Arrays.asList("mail", "schedule", "board", "approval", "community", "resource");
				break;
			case CommonUtil.PT_BASIC:
				moduleNames = Arrays.asList("mail", "schedule", "board");
				break;
			case CommonUtil.PT_MAIL:
				moduleNames = Arrays.asList("mail");
				break;
			}

			String realPath = commonUtil.getRealPath(request);

			moduleSizeVO = ezSystemAdminService.getModuleUsage(moduleNames, realPath, userInfo);
		}
		
		logger.debug("systemModuleMonitorOMS ended");
		
		return ResponseEntity.ok()
				.contentType(new MediaType("application", "json", StandardCharsets.UTF_8))
				.body(moduleSizeVO);
	}
	
	@RequestMapping(value = "/admin/ezSystem/multiLoginManager.do", method = RequestMethod.GET)
	public String multiLoginManager(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("multiLoginManager started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		int tenantID = userInfo.getTenantId();
		String companyID = userInfo.getCompanyID();
		
		// 현재 유저 회사의 멀티로그인 사용여부 (default : YES)
		String useMultiLogin = ezCommonService.getCompanyConfig(tenantID, companyID, "useMultiLogin");
		useMultiLogin = Optional.ofNullable(useMultiLogin).filter(StringUtils::isNotEmpty).orElse("YES");
		
		// 회사리스트
		List<OrganDeptVO> adminCompanyList = ezOrganAdminService.getAdminCompanyList(userInfo.getId(), tenantID, userInfo.getPrimary(), userInfo.getDeptID(), userInfo.getJobId());

		model.addAttribute("companyID", companyID);
		model.addAttribute("companyList", adminCompanyList);
		model.addAttribute("useMultiLogin", useMultiLogin);
		
		logger.debug("multiLoginManager ended");
		
		return "/ezSystem/multiLoginManager";
	}
	
	@RequestMapping(value = "/admin/ezSystem/companyMultiLoginType.do", method = RequestMethod.GET)
	public ResponseEntity<String> getCompanyMultiLoginType(@CookieValue("loginCookie") String loginCookie, @RequestParam String companyID) throws Exception {
		logger.debug("getCompanyMultiLoginType started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		// 선택 회사의 멀티로그인 사용여부 (default : YES)
		String useMultiLogin = ezCommonService.getCompanyConfig(userInfo.getTenantId(), companyID, "useMultiLogin");
		useMultiLogin = Optional.ofNullable(useMultiLogin).filter(StringUtils::isNotEmpty).orElse("YES");
		
		logger.debug("getCompanyMultiLoginType ended");
		
		return ResponseEntity.ok()
				.body(useMultiLogin);
	}
	
	@RequestMapping(value = "/admin/ezSystem/companyMultiLoginType.do", method = RequestMethod.POST)
	public ResponseEntity<String> setCompanyMultiLoginType(@CookieValue("loginCookie") String loginCookie, @RequestParam String companyID, @RequestParam String multiLoginType) throws Exception {
		logger.debug("setCompanyMultiLoginType started");
		
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);

		if (userInfo == null) {
			logger.debug("setCompanyMultiLoginType accessDenied");

			return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
		}

		int tenantID = userInfo.getTenantId();

		String useMultiLogin = ezCommonService.getCompanyConfig(tenantID, companyID, "useMultiLogin");

		ezSystemAdminService.setMultiLoginType(multiLoginType, tenantID, companyID, useMultiLogin);
		
		logger.debug("setCompanyMultiLoginType ended");
		
		return ResponseEntity.ok()
				.body("");
	}
	
	// 관리자 ip제한 화면
	@RequestMapping(value="/admin/ezSystem/systemAdminIPManager.do", method=RequestMethod.GET)
	public String systemAdminIPManager(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("systemAdminIPManager started");
		
		//관리자 권한체크
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}

		String rollInfo = userInfo.getRollInfo();
		boolean adminChk = rollInfo.indexOf("c=1") > -1;
		
		String useAdminIPAccess = ezCommonService.getTenantConfig("useAdminIPAccess", userInfo.getTenantId());
		useAdminIPAccess = useAdminIPAccess.equals("") ? "NO" : useAdminIPAccess;
		logger.debug("useAdminIPAccess=" + useAdminIPAccess);
		
		model.addAttribute("useAdminIPAccess", useAdminIPAccess); 
		model.addAttribute("adminChk", adminChk);     
		logger.debug("systemAdminIPManager ended");
		 
		return "/ezSystem/systemAdminIPManager";
	}
	
	// 관리자 ip제한 사용여부 설정
	@RequestMapping(value="/ezSystem/setUseAdminIPAccess.do", method=RequestMethod.POST)
	@ResponseBody
	public String setUseAdminIPAccess(@CookieValue("loginCookie") String loginCookie, boolean allowResult) throws Exception {
		logger.debug("setUseAdminIPAccess started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		if (!userInfo.getRollInfo().contains("c=1")) {
			return "adminFail";
		}

		ezSystemAdminService.updateSystemAdminIPAllow(allowResult ? "YES" : "NO", userInfo.getTenantId());
		
		logger.debug("setUseAdminIPAccess ended");
		return "OK";
	}
	
	// 관리자 IP 리스트 화면
	@RequestMapping(value="/ezSystem/systemAdminIPBand.do", method=RequestMethod.GET)
	public String systemAdminIPBand(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("systemAdminIPBand started");
		
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);

		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		String useAdminIPAccess = ezCommonService.getTenantConfig("useAdminIPAccess", userInfo.getTenantId());
		useAdminIPAccess = useAdminIPAccess.equals("") ? "NO" : useAdminIPAccess;
		logger.debug("useAdminIPAccess=" + useAdminIPAccess);
		
		String rollInfo = userInfo.getRollInfo();
		Boolean rollChk = rollInfo.indexOf("c=1") == -1 ? false : true;
		logger.debug("rollChk=" + rollChk);
		
		model.addAttribute("useAdminIPAccess", useAdminIPAccess);
		model.addAttribute("rollChk", rollChk);
		model.addAttribute("rollInfo", rollInfo);
		
		logger.debug("systemAdminIPBand ended");
		return "/ezSystem/systemAdminIPBand";
	}
	
	// 관리자 IP 리스트
	@ResponseBody
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/ezSystem/getAdminAccessIPBand.do", method=RequestMethod.POST)
	public ResponseEntity<JSONArray> getAdminAccessIPBand(@CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("getAdminAccessIPBand started");
		
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);

		if (userInfo == null) {
			logger.debug("getAdminAccessIPBand accessDenied");

			return ResponseEntity.status(HttpStatus.FORBIDDEN).body(new JSONArray());
		}

		int tenantId = userInfo.getTenantId();
		
		List<IPBandVO> list = ezSystemAdminService.getAdminAccessIPBand(tenantId);
		if (list == null) {
			return null;
		}
		
		JSONArray returnJsonArr = new JSONArray();

		for (IPBandVO ipVo : list) {
			JSONObject obj = new JSONObject();
			
			obj.put("ipNo", ipVo.getIpNo());
			obj.put("ipAddress", ipVo.getIpAddress());
			obj.put("access", ipVo.getAccess());
			obj.put("explanation", ipVo.getExplanation());
			
			returnJsonArr.add(obj);
		}

		logger.debug("returnJsonArr=" + returnJsonArr.toJSONString());
		logger.debug("getAdminAccessIPBand ended");
		return ResponseEntity.ok().body(returnJsonArr);
	}
	
	// 관리자 IP제한 - ip 추가
	@ResponseBody
	@RequestMapping(value="/ezSystem/insertAdminIPBand.do", method=RequestMethod.POST)
	public ResponseEntity<Void> insertAdminIPBand(@CookieValue("loginCookie") String loginCookie, @ModelAttribute IPBandVO ipBand) throws Exception {
		logger.debug("insertAdminIPBand started");
		
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);

		if (userInfo == null) {
			logger.debug("insertAdminIPBand accessDenied");

			return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
		}

		String ipBandExplaination = ipBand.getExplanation() == null ? "" : ipBand.getExplanation();
		
		ezSystemAdminService.insertAdminIPBand(userInfo.getTenantId(), ipBand.getIpAddress(), ipBand.getAccess(), ipBandExplaination);
		
		logger.debug("insertAdminIPBand ended");
		return ResponseEntity.noContent().build();
	}

	// 관리자 IP제한 - ip 수정
	@ResponseBody
	@RequestMapping(value="/ezSystem/updateAdminIPBand.do", method=RequestMethod.POST)
	public void updateAdminIPBand(@CookieValue("loginCookie") String loginCookie, Model model, @ModelAttribute IPBandVO ipBand) throws Exception {
		logger.debug("updateAdminIPBand started");
		logger.debug("ipNo=" + ipBand.getIpNo() + ", ipAddress=" + ipBand.getIpAddress() + ", access=" + ipBand.getAccess() + ", explanation=" + ipBand.getExplanation());
		
		ezSystemAdminService.updateAdminIPBand(ipBand.getIpNo(), ipBand.getIpAddress(), ipBand.getAccess(), ipBand.getExplanation());
		
		logger.debug("updateAdminIPBand ended");
	}

	// 관리자 IP제한 - ip 삭제
	@ResponseBody
	@RequestMapping(value="/ezSystem/deleteAdminIPBand.do", method=RequestMethod.POST, produces="text/plain")
	public String deleteAdminIPBand(@CookieValue("loginCookie") String loginCookie, Model model, String ipNo) throws Exception {
		logger.debug("deleteAdminIPBand started");
		logger.debug("ipNo=" + ipNo);

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		int tenantID = userInfo.getTenantId();
		String useAdminIpAccess = ezCommonService.getTenantConfig("useAdminIPAccess", tenantID);

		int isExist = ezSystemAdminService.isExistSystemAdminIPBand(ipNo);
		if ("YES".equalsIgnoreCase(useAdminIpAccess) && (0==isExist)) {
			return "noExist";
		}

		ezSystemAdminService.deleteAdminIPBand(ipNo);
		
		return "OK";
	}

	/**
	 * 암호 정책 관리 화면
	 * */
	@RequestMapping(value = "/admin/ezSystem/passwordPolicyMain.do", method = RequestMethod.GET)
	public String passwordPolicyMain(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("passwordPolicyMain started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		int tenantID = userInfo.getTenantId();
		String companyID = userInfo.getCompanyID();
		
		// 회사리스트
		List<OrganDeptVO> adminCompanyList = ezOrganAdminService.getAdminCompanyList(userInfo.getId(), tenantID, userInfo.getPrimary(), userInfo.getDeptID(), userInfo.getJobId());
		OrganAuth organAuth = commonUtil.makeOrganAuth(userInfo.getId(), userInfo.getTenantId(), userInfo.getDeptID(), userInfo.getJobId());

		boolean isDotNetAdmin = false;
		String dotNetIntegration = ezCommonService.getTenantConfig("dotNetIntegration", userInfo.getTenantId());
		
		if (dotNetIntegration.equals("YES")) {
			isDotNetAdmin = organAuth.isAuth(AdminAuth.ADMIN_MASTER) || organAuth.isAuth(AdminAuth.COMPANY_MANAGER);
		}
		
		model.addAttribute("companyID", companyID);
		model.addAttribute("companyList", adminCompanyList);
		model.addAttribute("isDotNetAdmin", isDotNetAdmin);
		
		logger.debug("passwordPolicyMain ended.");
		return "/ezSystem/systemPwPolicyManager";
	}
	
	/**
	 * 회사별 암호 정책관리
	 */
	@RequestMapping(value = "/admin/ezSystem/getPasswordPolicy.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getPasswordPolicy(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("getPasswordPolicy started.");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		int tenantId = userInfo.getTenantId();
		String companyId = userInfo.getCompanyID();
		Map<String, Object> returnMap = new HashMap<String, Object>();
		
		String reCompanyId = request.getParameter("companyId");
		if (reCompanyId != null && !reCompanyId.equals("")) {
			companyId = reCompanyId;
		}
		logger.debug("tenantId=" + tenantId + ", companyId=" + companyId);
		
		String expirePassPeriod = ezCommonService.getCompanyConfig(tenantId, companyId, "ExpirePassPeriod"); // 암호 만료기간
		expirePassPeriod = expirePassPeriod.equals("") ? "0" : expirePassPeriod;
		String maxAllowedCountOfLoginFail = ezCommonService.getCompanyConfig(tenantId, companyId, "MaxAllowedCountOfLoginFail"); // 암호 최대 오류 횟수
		maxAllowedCountOfLoginFail = maxAllowedCountOfLoginFail.equals("") ? "0" : maxAllowedCountOfLoginFail;
		String loginLockedDuration = ezCommonService.getCompanyConfig(tenantId, companyId, "LoginLockedDuration"); // 계정 잠금 처리 시간
		loginLockedDuration = loginLockedDuration.equals("") ? "0" : loginLockedDuration;
		String useChkPrevPwd = ezCommonService.getCompanyConfig(tenantId, companyId, "useChkPrevPwd"); // 2021-11-10 이사라 : 가장 최근 암호 사용 금지 여부
		useChkPrevPwd = useChkPrevPwd.equals("") ? "NO" : useChkPrevPwd;
		String rememberPWCount = ezCommonService.getCompanyConfig(tenantId, companyId, "RememberPWCount"); // 2024-07-16 김대현 : 기억할 암호 수
		rememberPWCount = rememberPWCount.equals("") ? "1" : rememberPWCount;
		String usePasswordPatternPolicy = ezCommonService.getCompanyConfig(tenantId, companyId, "UsePasswordPatternPolicy"); // 암호 정책관리 사용여부
		usePasswordPatternPolicy = usePasswordPatternPolicy.equals("") ? "NO" : usePasswordPatternPolicy;
		logger.debug("expirePassPeriod=" + expirePassPeriod + ", maxAllowedCountOfLoginFail=" + maxAllowedCountOfLoginFail 
				+ ", usePasswordPatternPolicy=" + usePasswordPatternPolicy);
		
		Map<String, Object> pwPolicyMap = ezSystemAdminService.getPwPolicy(tenantId, companyId);

		returnMap.put("expirePassPeriod", expirePassPeriod);
		returnMap.put("maxAllowedCountOfLoginFail", maxAllowedCountOfLoginFail);
		returnMap.put("LoginLockedDuration", loginLockedDuration);
		returnMap.put("useChkPrevPwd", useChkPrevPwd); // 2021-11-10 이사라 : 추가
		returnMap.put("rememberPWCount", rememberPWCount);
		returnMap.put("usePasswordPatternPolicy", usePasswordPatternPolicy);
		returnMap.put("pwPolicyMap", pwPolicyMap);
		logger.debug("return :: " + returnMap.toString());
		
		logger.debug("getPasswordPolicy ended.");
		return returnMap;
	}

	/**
	 * 회사별 암호 정책 문구
	 */
	@RequestMapping(value = "/admin/ezSystem/getPasswordPolicyExplain.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getPasswordPolicyExplain(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getPasswordPolicyExplain started.");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String companyId = userInfo.getCompanyID();
		Map<String, Object> returnMap = new HashMap<String, Object>();

		String reCompanyId = request.getParameter("companyId");
		if (reCompanyId != null && !reCompanyId.equals("")) {
			companyId = reCompanyId;
		}
		logger.debug("tenantId=" + userInfo.getTenantId() + ", companyId=" + companyId);
		
		String pwPolicyExplain = commonUtil.getPwPolicyExplain(companyId, userInfo.getTenantId(), userInfo.getLocale());
		
		returnMap.put("pwPolicyExplain", pwPolicyExplain);
		
		logger.debug("getPasswordPolicyExplain ended.");
		
		return returnMap;
	}
	
	/**
	 * 암호 정책 저장
	 * */
	@RequestMapping(value = "/admin/ezSystem/updatePasswordPolicy.do", method = RequestMethod.POST)
	@ResponseBody
	public String updatePasswordPolicy(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		logger.debug("updatePasswordPolicy started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		int tenantID = userInfo.getTenantId();
		
		String data = request.getParameter("data");
		logger.debug("data=" + data);
		
		JSONParser jsonParse = new JSONParser();
		JSONObject dataObj = new JSONObject();
		dataObj = (JSONObject) jsonParse.parse(data);
		
		String companyId = (String) dataObj.get("companyId");
		List<Map<String, String>> configList =  new ObjectMapper().readValue(dataObj.get("setConfig").toString(), 
				new TypeReference<List<Map<String,Object>>> (){});
		Map<String, String> patternTypeMap = new ObjectMapper().readValue(dataObj.get("patternType").toString(), 
				new TypeReference<Map<String,String>> (){});	
		List<Map<String, Object>> patternSetting = new ObjectMapper().readValue(dataObj.get("patternSetting").toString(),  
				new TypeReference<List<Map<String,Object>>> (){});

		PasswordPolicyVO pwPolicyVo = new PasswordPolicyVO();
		pwPolicyVo.setCompanyId(companyId);
		ezSystemAdminService.updateCompanyConfigParam(tenantID, configList, companyId);
		ezSystemAdminService.updatePwPolicy(tenantID, companyId, patternTypeMap, patternSetting);
		
		return "";
	}
	
	private List<CountryVO> countryVOList(String[] countryCodeList, String userLang, String realPath)
			throws Exception {
		logger.debug("CountryVOList started");
		
		List<CountryVO> countryList = new ArrayList<CountryVO>();
		String countryIconFolder = "/images/countryIcon32/";
		String countryQuestionIcon = countryIconFolder + "qm.png";
		String lang = "";
		
		lang = commonUtil.getTwoLetterLangFromLangNum(userLang);
		
		String[] countries = Locale.getISOCountries();
		if (countryCodeList != null && countryCodeList.length != 0) {
			countries = countryCodeList;
		}
		logger.debug("countries Count=" + countries.length);
		
		for (String country : countries) {
			Locale locale = new Locale(lang, country);

			CountryVO countryVO = new CountryVO();
			countryVO.setCountryCode(country); // 국가코드
			countryVO.setCountryName(locale.getDisplayCountry(locale));
			
			if (realPath != null && !realPath.isEmpty()) { // path 없으면 이미지 경로 X
				// 국기가 없으면 물음표 국기 표시
				String printImage = countryQuestionIcon;
				try {
					String countryIconPath = countryIconFolder + country.toLowerCase() + ".png";
					File f = new File(realPath + countryIconPath);
					printImage = f.exists() ? countryIconPath : printImage; 
					//logger.debug("printImage=" + printImage);
					
					countryVO.setImagePath(printImage); // 이미지 경로
				} catch (Exception e) {
					logger.error(e.getMessage(), e);
				}
			}
			
			countryList.add(countryVO);
			// logger.debug(countryVO.toString());
		}
		
		
		Collections.sort(countryList);
		
		logger.debug("CountryVOList ended");
		return countryList;
	}

	/**
	 * 관리자메뉴 접속내역 메인 호출
	 * 2022-01-11 이사라
	 */
	@RequestMapping(value="/admin/ezSystem/systemAdminAccessHist.do", method = RequestMethod.GET)
	public String systemAdminAccessHist(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model) throws Exception {
		
		logger.debug("started systemAdminAccessHist controller.");
		
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		String companyId = userInfo.getCompanyID();
		int tenantId = userInfo.getTenantId();
		
		String loginMailLogKeepPeriod = ezCommonService.getTenantConfig("LoginMailLogKeepPeriod", tenantId);
		loginMailLogKeepPeriod = loginMailLogKeepPeriod.equals("") ? "3" : loginMailLogKeepPeriod;
		
		String mailLogKeepPeriodMessage = egovMessageSource.getMessage("ezStatistics.t1065", locale);
		mailLogKeepPeriodMessage = String.format(mailLogKeepPeriodMessage, loginMailLogKeepPeriod);
		
		model.addAttribute("mailLogKeepPeriodMessage", mailLogKeepPeriodMessage);
		
		List<OrganDeptVO> list = ezOrganAdminService.getCompanyList(userInfo.getPrimary(), tenantId);
		List<OrganDeptVO> resultList = new ArrayList<OrganDeptVO>();
		int j = 0;
		boolean isMasterAdmin = userInfo.getRollInfo().contains("c=1");
		
		for (int i = 0; i < list.size(); i++) {
			OrganDeptVO vo = list.get(i);

			if (isMasterAdmin || vo.getCn().equals(companyId)) {
				resultList.add(j++, vo);
			}
		}
		
		model.addAttribute("list", resultList);
		model.addAttribute("companyId", companyId);
		model.addAttribute("isMasterAdmin", isMasterAdmin);
		
		logger.debug("ended systemAdminAccessHist controller.");
		
		return "/ezSystem/systemAdminAccessHist";
		
	}
	
	/**
	 * 관리자메뉴 접속내역 데이터 리스트 호출
	 * 2022-01-11 이사라
	 */
	@RequestMapping(value="/admin/ezSystem/systemAdminAccessHistList.do", method = RequestMethod.POST)
	public String systemAdminAccessHistList(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest req,
			@RequestParam(required=false)String searchKeycode, @RequestParam(required=false)String searchKeyword, 
			@RequestParam(required=false)String searchKeycodeForRoll,
			@RequestParam(required=false)String startDate, @RequestParam(required=false)String endDate) throws Exception {
		
		logger.debug("started systemAdminAccessHistList controller.");
		
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}

		int tenantId = userInfo.getTenantId();
		
		String offset = userInfo.getOffset();
		String currPage = req.getParameter("pageNum");
		
		if (StringUtils.isBlank(currPage)) {
			currPage = "1";
		}
		
		int maxItemPerPage = 20; 
		int currentPage = Integer.parseInt(currPage);
		int startRow = (Integer.parseInt(currPage) - 1) * maxItemPerPage;
		
		if (currPage.equals("-1")) {
			startRow = -1;
		}
		
		/*
		 * 2018.11.21 김수아
		 * (전체관리자) 회사선택 후 선택한 회사의 로그인 히스토리가 나오도록 변경 
		 */
		String companyId = req.getParameter("companyId"); // 선택된 회사
		
		/*
		 * 2017.07.26 강민석
		 * 로그인 히스토리에는 자신의 회사만 나오도록 수정
		 * */
		//String companyId = userInfo.getCompanyID();
		logger.debug("companyId : " + companyId);

		String sysLang = ezCommonService.getTenantConfig("PrimaryLang", tenantId);

		if (userInfo.getLang().equals(sysLang))  {
			sysLang = "primary";
		}
		
		searchKeyword = searchKeyword.replace("%", "\\%").replace("_", "\\_");
		List<MainVO> adminAccessHistList = ezSystemAdminService.getAdminAccessHist(Integer.valueOf(tenantId),
				commonUtil.getMinuteUTC(offset), startRow, maxItemPerPage, searchKeycode, searchKeyword, searchKeycodeForRoll, sysLang, startDate, endDate, companyId);
		
		// 로그인 ip의 국가를 표시하기 위함 
		String systemLang = userInfo.getLang();
		String systemCountryName = "";
		String systemCountryCode = ezCommonService.getTenantConfig("systemCountryCode", tenantId);
		
		for (MainVO vo : adminAccessHistList) {
			String ip = vo.getAccessip();
			String countryName = "";
			String countryCode = "";
			
			if (ip.equals("0:0:0:0:0:0:0:1")) {
				ip = "127.0.0.1";
			}
			
			systemCountryName = commonUtil.getTwoLetterLangFromLangNum(systemLang, "ko");
			
			if (ip != null && !ip.equals("")) {
				if (commonUtil.checkLocalIP(ip)) {
					countryCode = systemCountryCode;
				} else {
					List<CountryVO> countryVo = commonUtil.getCountryInfo(ip);
					if (countryVo.size() == 0 ) {
						countryName = "?";
					} else {
						countryCode = countryVo.get(0).getCountryCode();
					}
				}
			} else {
				countryName = "?";
			}
			
			if (!"?".equals(countryName)) {
				Locale localeCountry = new Locale(systemCountryName, countryCode);
				countryName = localeCountry.getDisplayCountry(localeCountry);
				countryName = countryName.replaceAll(" ", "");
			}
			vo.setCountryName(countryName);
		}
			
		int itemCnt = ezSystemAdminService.getAdminAccessHistCount(tenantId, commonUtil.getMinuteUTC(offset), searchKeycode, searchKeyword, searchKeycodeForRoll, sysLang, startDate, endDate, companyId);
		
		int totalPage = itemCnt / maxItemPerPage ;
		
		if (itemCnt < 1) {
			totalPage = 1;
		} 
		
		if ((totalPage * maxItemPerPage) != itemCnt && (itemCnt % maxItemPerPage) != 0) {
			totalPage = totalPage + 1 ;
		}
		
		currentPage = Math.min(currentPage, totalPage);	
		model.addAttribute("adminAccessHist", adminAccessHistList); 
		model.addAttribute("lang", sysLang);
		model.addAttribute("currPage", currentPage);
		model.addAttribute("totalPage", totalPage);
		model.addAttribute("itemCnt", itemCnt);
		model.addAttribute("searchKeyword", searchKeyword);
		model.addAttribute("searchKeycode", searchKeycode);
		model.addAttribute("startDate", startDate);
		model.addAttribute("endDate", endDate);
		
		logger.debug("ended systemAdminAccessHistList controller.");
		
		return "json";
	}
	
	/*
	 * 엑셀 워크시트 생성 및 자동 다운로드 함수
	 * 2022-01-11 이사라
	 */
	@RequestMapping(value = "/admin/ezSystem/systemAccessHistExcelExport.do", method = RequestMethod.GET)
	@ResponseBody
	public void statisticsAdminAccessLogExcelExport(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request,
			String searchKeycode, String searchKeyword, String searchKeycodeForRoll, String startDate, String endDate, Locale locale, HttpServletResponse response)  throws Exception {
		logger.debug("systemAccessHistExcelExport controller started.");
		
		LoginVO userInfoUser = commonUtil.userInfo(loginCookie);
		
		int tenantId = userInfoUser.getTenantId();
		String offset = userInfoUser.getOffset();
		String currPage = request.getParameter("pageNum");
		
		int maxItemPerPage = 20; 
		int startRow = (Integer.parseInt(currPage) - 1) * maxItemPerPage;
		
		if (currPage.equals("-1")) {
			startRow = -1;
		}

		String companyId = request.getParameter("companyId"); // 선택된 회사
		String sysLang = ezCommonService.getTenantConfig("PrimaryLang", tenantId);

		if (userInfoUser.getLang().equals(sysLang))  {
			sysLang = "primary";
		}
		
		searchKeyword = searchKeyword.replace("%", "\\%").replace("_", "\\_");
		List<MainVO> accessHistList = new ArrayList<MainVO>();
		int totalCount = 0;
		
		accessHistList = ezSystemAdminService.getAdminAccessHist(Integer.valueOf(tenantId), 
				commonUtil.getMinuteUTC(offset), startRow, maxItemPerPage, searchKeycode, searchKeyword, searchKeycodeForRoll, sysLang, startDate, endDate, companyId);
		totalCount = ezSystemAdminService.getAdminAccessHistCount(tenantId, commonUtil.getMinuteUTC(offset), searchKeycode, searchKeyword, searchKeycodeForRoll, sysLang, startDate, endDate, companyId);
		
		
		/* 엑셀 만들기 */
		try (HSSFWorkbook workbook = new HSSFWorkbook()) {
			HSSFSheet sheet = workbook.createSheet("AccessAdminLogList");
			
			Row row = null;
			Cell cell = null;
			
			String fileName = "";
			fileName = startDate +"_"+ endDate + "_AdminAccessLogList";
			
			HSSFCellStyle headerStyle = workbook.createCellStyle();
			headerStyle.setFillForegroundColor(HSSFColor.GREY_25_PERCENT.index);
			headerStyle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
			headerStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
			headerStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
			headerStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
			headerStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
			headerStyle.setVerticalAlignment((short)1);
			
			HSSFCellStyle bodyStyle = workbook.createCellStyle();
			bodyStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
			bodyStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
			bodyStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
			bodyStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
	
			HSSFFont font = workbook.createFont();
			font.setBoldweight((short)HSSFFont.BOLDWEIGHT_BOLD);
			headerStyle.setFont(font);
			
			String histHeader = egovMessageSource.getMessage("ezSystem.lsAccessHistAdmin", locale);
			String[] histHeaderArr = histHeader.split(";");
			int histHeaderLen = histHeaderArr.length;
			
			row = sheet.createRow(0);
			cell = row.createCell(0);	
			cell.setCellValue(egovMessageSource.getMessage("ezSystem.x0032", locale) + " : " + startDate + " ~ " + endDate);
			cell = row.createCell(histHeaderLen-1);
			cell.setCellValue(egovMessageSource.getMessage("main.t252", locale) + " " + totalCount + egovMessageSource.getMessage("ezSystem.kyj2", locale));
			
			row = sheet.createRow(1);
			for (int i = 0; i < histHeaderLen; i ++) {
				cell = row.createCell(i);	cell.setCellValue(histHeaderArr[i]); 
				cell.setCellStyle(headerStyle);
			}
			
			String systemLang = userInfoUser.getLang();
			String systemCountryName = "";
			String systemCountryCode = ezCommonService.getTenantConfig("systemCountryCode", tenantId);
			
			for (int i = 2; i < totalCount + 2; i++) {
				row = sheet.createRow(i);
				row.setHeight((short)300);
				int j = 2;
				
				MainVO infoVo = accessHistList.get(i-j);
				String userName = infoVo.getUsernm() + "(" + infoVo.getUserid() + ")";
				String userDeptName = infoVo.getDeptnm();
				String userCompanyName = infoVo.getCompanynm();
				if (!sysLang.equals("primary")) {
					userName = infoVo.getUsernm2() + "(" + infoVo.getUserid() + ")";
					userDeptName = infoVo.getDeptnm2();
					userCompanyName = infoVo.getCompanynm2();
				}
				
				// countryIP 관련 국가명 표시 위함 시작.
				String ip = accessHistList.get(i-j).getAccessip();
				String countryName = "";
				String countryCode = "";
				
				if (ip.equals("0:0:0:0:0:0:0:1")) {
					ip = "127.0.0.1";
				}
				
				systemCountryName = commonUtil.getTwoLetterLangFromLangNum(systemLang, "ko");
				
				if (ip != null && !ip.equals("")) {
					if (commonUtil.checkLocalIP(ip)) {
						countryCode = systemCountryCode;
					} else {
						List<CountryVO> countryVo = commonUtil.getCountryInfo(ip);
						if (countryVo.size() == 0 ) {
							countryName = "?";
						} else {
							countryCode = countryVo.get(0).getCountryCode();
						}
					}
				} else {
					countryName = "?";
				}
				
				if (!"?".equals(countryName)) {
					Locale localeCountry = new Locale(systemCountryName, countryCode);
					countryName = localeCountry.getDisplayCountry(localeCountry);
					countryName = countryName.replaceAll(" ", "");
				}
				accessHistList.get(i-j).setCountryName(countryName);
				// countryIP 관련 국가명 표시 위함 끝.
				
				String accessIp = infoVo.getAccessip() + "(" + accessHistList.get(i-j).getCountryName() + ")";
				String accessTime = infoVo.getAccesstime();
				String accessBrowser = infoVo.getAccessbrowser();
				String accessOS = infoVo.getAccessos();
				String adminType = infoVo.getAdmintype();
				
				if (adminType.indexOf("c=1") > -1 && adminType.indexOf("k=1") > -1) {
					adminType = egovMessageSource.getMessage("ezSystem.ls10", locale);
				} else if (adminType.indexOf("c=1") > -1) {
					adminType = egovMessageSource.getMessage("ezOrgan.t291", locale);
				} else {
					adminType = egovMessageSource.getMessage("ezOrgan.t293", locale); 
				}
				
				String[] accessHist = null;
				accessHist = new String [] {userName, userDeptName, userCompanyName, accessIp, accessTime, accessBrowser, accessOS, adminType};
				
				for (int k = 0; k < histHeaderLen; k ++) {
					cell = row.createCell(k);	cell.setCellValue((String) accessHist[k]); 
					cell.setCellStyle(bodyStyle);
				}
				
				sheet.autoSizeColumn(i-1);
			}
			
			response.setCharacterEncoding("UTF-8");
			response.setHeader("Content-Disposition", "attachment; fileName=" + fileName + ".xls");
			response.setContentType("application/vnd.ms-excel");
			
			workbook.write(response.getOutputStream());
			//workbook.close();
		}
		
		logger.debug("systemAccessHistExcelExport controller ended.");
	}	

	/**
	 * 권한 변경 히스토리 메인 호출
	 * 2022-01-18 이사라
	 */
	@RequestMapping(value = "/admin/ezSystem/permissionChangeHist.do", method = RequestMethod.GET)
	public String permissionChangeHist(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model)
			throws Exception {

		logger.debug("started permissionChangeHist controller.");

		LoginVO user = commonUtil.checkAdmin(loginCookie);

		if (user == null) {
			return "cmm/error/adminDenied";
		}

		String companyId = user.getCompanyID();
		int tenantId = user.getTenantId();

		/*
		 * 보존 기간이 있을 경우 아래 주석 해제 후 필요 시 수정 String loginMailLogKeepPeriod = ezCommonService.getTenantConfig("LoginMailLogKeepPeriod", tenantId);
		 * loginMailLogKeepPeriod = loginMailLogKeepPeriod.equals("") ? "3" : loginMailLogKeepPeriod;
		 *
		 * String mailLogKeepPeriodMessage = egovMessageSource.getMessage("ezStatistics.t1065", locale);
		 * mailLogKeepPeriodMessage = String.format(mailLogKeepPeriodMessage, loginMailLogKeepPeriod);
		 *
		 * model.addAttribute("mailLogKeepPeriodMessage", mailLogKeepPeriodMessage);
		 */

		List<OrganDeptVO> adminCompanyList = ezOrganAdminService.getAdminCompanyList(user.getId(), tenantId, user.getPrimary(), user.getDeptID(), user.getJobId());
		OrganAuth organAuth = commonUtil.makeOrganAuth(user.getId(), user.getTenantId(), user.getDeptID(), user.getJobId());
		boolean isMasterAdmin = organAuth.isAuth(AdminAuth.ADMIN_MASTER);

		// 관리자 구분 셀렉트박스 적용
		String approvalFlag		= ezCommonService.getTenantConfig("ApprovalFlag" ,tenantId);
		boolean approvalForDoc	= ezCommonService.getTenantConfig("approvalForDoc" ,tenantId).equalsIgnoreCase("Y");
		boolean use_attitude	= !ezCommonService.getTenantConfig("use_attitude" ,tenantId).equalsIgnoreCase("NO");
		boolean useWebfolder	= ezCommonService.getTenantConfig("useWebfolder" ,tenantId).equalsIgnoreCase("YES");
		boolean useBoard		= !ezCommonService.getTenantConfig("useBoard" ,tenantId).equalsIgnoreCase("NO");
		boolean useSurvey		= !ezCommonService.getTenantConfig("useSurvey" ,tenantId).equalsIgnoreCase("NO");
		boolean useSchedule		= ezCommonService.getTenantConfig("useSchedule" ,tenantId).equalsIgnoreCase("YES");
		String packageType		= commonUtil.getPackageType(tenantId);

		model.addAttribute("approvalFlag", approvalFlag);
		model.addAttribute("approvalForDoc", approvalForDoc);
		model.addAttribute("use_attitude", use_attitude);
		model.addAttribute("useWebfolder", useWebfolder);
		model.addAttribute("packageType", packageType);
		model.addAttribute("useBoard", useBoard);
		model.addAttribute("useSurvey", useSurvey);
		model.addAttribute("list", adminCompanyList);
		model.addAttribute("companyId", companyId);
		model.addAttribute("isMasterAdmin", isMasterAdmin);
		model.addAttribute("useSchedule", useSchedule); // 일정관리 모듈 사용여부(사용 : true)

		logger.debug("ended permissionChangeHist controller.");

		return "/ezSystem/permissionChangeHist";

	}

	/**
	 * 권한 변경 히스토리 리스트 호출
	 * 2022-01-18 이사라
	 */
	@RequestMapping(value = "/admin/ezSystem/permissionChangeHistList.do", method = RequestMethod.POST)
	public String permissionChangeHistList(@CookieValue("loginCookie") String loginCookie, Model model,
			HttpServletRequest req, @RequestParam(required = false) String searchKeycode,
			@RequestParam(required = false) String searchKeyword,
			@RequestParam(required = false) String searchKeycodeForRoll,
			@RequestParam(required = false) String startDate, @RequestParam(required = false) String endDate)
			throws Exception {

		logger.debug("started permissionChangeHistList controller.");

		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);

		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}

		int tenantId = userInfo.getTenantId();
		boolean isMasterAdmin = userInfo.getRollInfo().contains("c=1"); // 전체관리자
		String offset = userInfo.getOffset();
		String currPage = req.getParameter("pageNum");

		if (StringUtils.isBlank(currPage)) {
			currPage = "1";
		}

		int maxItemPerPage = 20;
		int currentPage = Integer.parseInt(currPage);
		int startRow = (Integer.parseInt(currPage) - 1) * maxItemPerPage;

		if (currPage.equals("-1")) {
			startRow = -1;
		}

		String companyId = req.getParameter("companyId"); // 선택된 회사
		logger.debug("companyId : " + companyId);

		String sysLang = ezCommonService.getTenantConfig("PrimaryLang", tenantId);

		if (userInfo.getLang().equals(sysLang)) {
			sysLang = "primary";
		}

		searchKeyword = searchKeyword.replace("%", "\\%").replace("_", "\\_");
		List<PermissionInfoVO> permissionChHistList = ezSystemAdminService.getPermissionChHist(
				Integer.valueOf(tenantId), commonUtil.getMinuteUTC(offset), startRow, maxItemPerPage, searchKeycode,
				searchKeyword, searchKeycodeForRoll, sysLang, startDate, endDate, companyId, isMasterAdmin);

		// 로그인 ip의 국가를 표시하기 위함
		String systemLang = userInfo.getLang();
		String systemCountryName = "";
		String systemCountryCode = ezCommonService.getTenantConfig("systemCountryCode", tenantId);

		for (PermissionInfoVO vo : permissionChHistList) {
			String ip = vo.getAuthorizerIp();
			String countryName = "";
			String countryCode = "";

			if (ip.equals("0:0:0:0:0:0:0:1")) {
				ip = "127.0.0.1";
			}

			systemCountryName = commonUtil.getTwoLetterLangFromLangNum(systemLang, "ko");

			if (StringUtils.isNotBlank(ip)) {
				if (commonUtil.checkLocalIP(ip)) {
					countryCode = systemCountryCode;
				} else {
					List<CountryVO> countryVo = commonUtil.getCountryInfo(ip);
					if (countryVo.size() == 0) {
						countryName = "?";
					} else {
						countryCode = countryVo.get(0).getCountryCode();
					}
				}
			} else {
				countryName = "?";
			}

			if (!"?".equals(countryName)) {
				Locale localeCountry = new Locale(systemCountryName, countryCode);
				countryName = localeCountry.getDisplayCountry(localeCountry);
				countryName = countryName.replaceAll(" ", "");
			}
			vo.setCountryName(countryName);
		}

		int itemCnt = ezSystemAdminService.getPermissionChHistCount(tenantId, commonUtil.getMinuteUTC(offset),
				searchKeycode, searchKeyword, searchKeycodeForRoll, sysLang, startDate, endDate, companyId, isMasterAdmin);
		int totalPage = itemCnt / maxItemPerPage;

		if (itemCnt < 1) {
			totalPage = 1;
		}

		if ((totalPage * maxItemPerPage) != itemCnt && (itemCnt % maxItemPerPage) != 0) {
			totalPage = totalPage + 1;
		}

		currentPage = Math.min(currentPage, totalPage);
		model.addAttribute("permissionChHistList", permissionChHistList);
		model.addAttribute("lang", sysLang);
		model.addAttribute("currPage", currentPage);
		model.addAttribute("totalPage", totalPage);
		model.addAttribute("itemCnt", itemCnt);
		model.addAttribute("searchKeyword", searchKeyword);
		model.addAttribute("searchKeycode", searchKeycode);
		model.addAttribute("startDate", startDate);
		model.addAttribute("endDate", endDate);

		logger.debug("ended permissionChangeHistList controller.");

		return "json";
	}

	/*
	 * 엑셀 워크시트 생성 및 자동 다운로드 함수
	 * 2022-01-24 이사라
	 */
	@RequestMapping(value = "/admin/ezSystem/permissionChHistExcelExport.do", method = RequestMethod.GET)
	@ResponseBody
	public void statisticsPermissionChHistExcelExportExcelExport(@CookieValue("loginCookie") String loginCookie,
			HttpServletRequest request, String searchKeycode, String searchKeyword, String searchKeycodeForRoll,
			String startDate, String endDate, Locale locale, HttpServletResponse response) throws Exception {
		logger.debug("permissionChHistExcelExport controller started.");

		LoginVO user = commonUtil.userInfo(loginCookie);

		int tenantId = user.getTenantId();
		boolean isMasterAdmin = user.getRollInfo().contains("c=1"); // 전체관리자
		String offset = user.getOffset();
		String currPage = request.getParameter("pageNum");

		int maxItemPerPage = 20;
		int startRow = (Integer.parseInt(currPage) - 1) * maxItemPerPage;

		if (currPage.equals("-1")) {
			startRow = -1;
		}

		String companyId = request.getParameter("companyId"); // 선택된 회사
		String sysLang = ezCommonService.getTenantConfig("PrimaryLang", tenantId);

		if (user.getLang().equals(sysLang)) {
			sysLang = "primary";
		}

		searchKeyword = searchKeyword.replace("%", "\\%").replace("_", "\\_");
		List<PermissionInfoVO> permissionChHist = new ArrayList<PermissionInfoVO>();
		int totalCount = 0;

		permissionChHist = ezSystemAdminService.getPermissionChHist(Integer.valueOf(tenantId),
				commonUtil.getMinuteUTC(offset), startRow, maxItemPerPage, searchKeycode, searchKeyword,
				searchKeycodeForRoll, sysLang, startDate, endDate, companyId, isMasterAdmin);
		totalCount = ezSystemAdminService.getPermissionChHistCount(tenantId, commonUtil.getMinuteUTC(offset),
				searchKeycode, searchKeyword, searchKeycodeForRoll, sysLang, startDate, endDate, companyId, isMasterAdmin);

		/* 엑셀 만들기 */
		HSSFWorkbook workbook = new HSSFWorkbook();
		HSSFSheet sheet = workbook.createSheet("permissionChangeHistory");

		Row row = null;
		Cell cell = null;

		String fileName = "";
		fileName = startDate + "_" + endDate + "_permissionChangeHistory";

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

		String histHeader = egovMessageSource.getMessage("ezOrgan.lsPermissionChHist", locale);
		String[] histHeaderArr = histHeader.split(";");
		int histHeaderLen = histHeaderArr.length;

		row = sheet.createRow(0);
		cell = row.createCell(0);
		cell.setCellValue(egovMessageSource.getMessage("ezSystem.x0032", locale) + " : " + startDate + " ~ " + endDate);
		cell = row.createCell(histHeaderLen - 1);
		cell.setCellValue(egovMessageSource.getMessage("main.t252", locale) + " " + totalCount
				+ egovMessageSource.getMessage("ezSystem.kyj2", locale));

		row = sheet.createRow(1);
		for (int i = 0; i < histHeaderLen; i++) {
			cell = row.createCell(i);
			cell.setCellValue(histHeaderArr[i]);
			cell.setCellStyle(headerStyle);
		}

		String systemLang = user.getLang();
		String systemCountryName = "";
		String systemCountryCode = ezCommonService.getTenantConfig("systemCountryCode", tenantId);

		for (int i = 2; i < totalCount + 2; i++) {
			row = sheet.createRow(i);
			row.setHeight((short) 300);
			int j = 2;

			// countryIP 관련 국가명 표시 위함 시작.
			String ip = permissionChHist.get(i - j).getAuthorizerIp();
			String countryName = "";
			String countryCode = "";

			if (ip.equals("0:0:0:0:0:0:0:1")) {
				ip = "127.0.0.1";
			}

			systemCountryName = commonUtil.getTwoLetterLangFromLangNum(systemLang, "ko");

			if (StringUtils.isNotBlank(ip)) {
				if (commonUtil.checkLocalIP(ip)) {
					countryCode = systemCountryCode;
				} else {
					List<CountryVO> countryVo = commonUtil.getCountryInfo(ip);
					if (countryVo.size() == 0) {
						countryName = "?";
					} else {
						countryCode = countryVo.get(0).getCountryCode();
					}
				}
			} else {
				countryName = "?";
			}

			if (!"?".equals(countryName)) {
				Locale localeCountry = new Locale(systemCountryName, countryCode);
				countryName = localeCountry.getDisplayCountry(localeCountry);
				countryName = countryName.replaceAll(" ", "");
			}
			permissionChHist.get(i - j).setCountryName(countryName);
			// countryIP 관련 국가명 표시 위함 끝.

			PermissionInfoVO infoVo = permissionChHist.get(i - j);

			String userName = infoVo.getUserNm() + "(" + infoVo.getUserId() + ")";
			String userDeptName = infoVo.getDeptNm();
			String userCompanyName = infoVo.getCompanyNm();
			String authorizedTime = infoVo.getAuthorizedTime();
			String adminType = infoVo.getAdminType();
			String status = infoVo.getStatus().equalsIgnoreCase("Y") ? egovMessageSource.getMessage("ezOrgan.ls07", locale) : egovMessageSource.getMessage("ezOrgan.ls08", locale);
			String authorizer = infoVo.getAuthorizerNm() + "(" + infoVo.getAuthorizerId() + ")";
			String authorizerIp = infoVo.getAuthorizerIp() + "(" + permissionChHist.get(i - j).getCountryName() + ")";

			if (!sysLang.equals("primary")) {
				userName = infoVo.getUserNm2() + "(" + infoVo.getUserId() + ")";
				userDeptName = infoVo.getDeptNm2();
				userCompanyName = infoVo.getCompanyNm2();
				authorizer = infoVo.getAuthorizerNm2() + "(" + infoVo.getAuthorizerId() + ")";
			}

			if (adminType.contains("c=")) {
				adminType = egovMessageSource.getMessage("ezOrgan.t291", locale);
			} else if (adminType.contains("k=")) {
				adminType = egovMessageSource.getMessage("ezOrgan.t293", locale);
			} else if (adminType.contains("g=")) {
				adminType = egovMessageSource.getMessage("ezOrgan.t295", locale);
			} else if (adminType.contains("a=")) {
				adminType = egovMessageSource.getMessage("ezOrgan.t292", locale);
			} else if (adminType.contains("i=")) {
				adminType = egovMessageSource.getMessage("ezOrgan.t294", locale);
			} else if (adminType.contains("n=")) {
				adminType = egovMessageSource.getMessage("ezOrgan.t297", locale);
			} else if (adminType.contains("l=")) {
				adminType = egovMessageSource.getMessage("ezOrgan.t296", locale);
			} else if (adminType.contains("w=")) {
				adminType = egovMessageSource.getMessage("ezOrgan.t301", locale);
			} else if (adminType.contains("m=")) {
				adminType = egovMessageSource.getMessage("ezOrgan.t300", locale);
				} else if (adminType.contains("q=")) {
				adminType = egovMessageSource.getMessage("ezOrgan.lhj1", locale);
				} else if (adminType.contains("f=")) {
				adminType = egovMessageSource.getMessage("ezOrgan.t303", locale);
			} else if (adminType.contains("e=")) {
				adminType = egovMessageSource.getMessage("ezOrgan.kbm01", locale);
			} else {
				adminType = egovMessageSource.getMessage("ezOrgan.t9904", locale);
			}

			String[] permissionHist = null;
			permissionHist = new String[] { userName, userDeptName, userCompanyName, authorizedTime, adminType, status,
					authorizer, authorizerIp };

			for (int k = 0; k < histHeaderLen; k++) {
				cell = row.createCell(k);
				cell.setCellValue((String) permissionHist[k]);
				cell.setCellStyle(bodyStyle);
			}

			sheet.autoSizeColumn(i - 1);
		}

		response.setCharacterEncoding("UTF-8");
		response.setHeader("Content-Disposition", "attachment; fileName=" + fileName + ".xls");
		response.setContentType("application/vnd.ms-excel");

		workbook.write(response.getOutputStream());
		workbook.close();

		logger.debug("permissionChHistExcelExport controller ended.");
	}

	@RequestMapping(value = "/admin/ezSystem/systemFileExtension.do", method=RequestMethod.GET)
	public String fileExtension(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("fileExtension controller started.");

		// 관리자 권한체크
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);

		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}

		logger.debug("tenantID={}", userInfo.getTenantId());

		List<String> fileExtension = ezSystemAdminService.getFileExtension(userInfo.getTenantId());
		logger.debug("fileExtension={}", fileExtension);

		model.addAttribute("fileExtension",JSONArray.toJSONString(fileExtension));

		logger.debug("fileExtension controller ended.");
		return "/ezSystem/systemFileExtension";
	}

	@RequestMapping(value = "/admin/ezSystem/updateFileExtension.do")
	@ResponseBody
	public String updateFileExtension(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request, @RequestParam(value = "updateFileExtension[]") ArrayList<String> updateFileExtension) throws Exception {
		logger.debug("updateFileExtension controller started");

		// 관리자 권한체크
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);

		if (userInfo == null) {
			return "adminDenied";
		}

		logger.debug("tenantID={}",userInfo.getTenantId());
		int tenantId = userInfo.getTenantId();
		
		String message = "fail";

		try {
			message = ezSystemAdminService.updateFileExtension(tenantId, updateFileExtension);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}

		logger.debug("updateFileExtension controller ended");
		return message;
	}
	
	
	

	/*
	 * 사용자 변경 히스토리 메인 호출 
	 * 2023-07-03 장혜연
	 */
	@RequestMapping(value = "/admin/ezSystem/systemUserChangeHist.do", method = RequestMethod.GET)
	public String userChangeHistory(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model) throws Exception {
		
		logger.debug("started userChangeHistory controller.");

		LoginVO user = commonUtil.checkAdmin(loginCookie);

		if (user == null) {
			return "cmm/error/adminDenied";
		}

		String companyId = user.getCompanyID();
		List<OrganDeptVO> adminCompanyList = ezOrganAdminService.getAdminCompanyList(user.getId(), user.getTenantId(), user.getPrimary(), user.getDeptID(), user.getJobId());
		OrganAuth organAuth = commonUtil.makeOrganAuth(user.getId(), user.getTenantId(), user.getDeptID(), user.getJobId());
		boolean isMasterAdmin = organAuth.isAuth(AdminAuth.ADMIN_MASTER);

		model.addAttribute("list", adminCompanyList);
		model.addAttribute("companyId", companyId);
		model.addAttribute("isMasterAdmin", isMasterAdmin);

		logger.debug("ended userChangeHistory controller.");

		
		
		return "/ezSystem/systemUserChangeHist"; 
	}
	
	
	/**
	 * 사용자 변경 히스토리 데이터 리스트 호출
	 * 2023-07-03 장혜연
	 */
	@RequestMapping(value = "/admin/ezSystem/userChangeHistList.do", method = RequestMethod.POST)
	public String userChangeHistList(@CookieValue("loginCookie") String loginCookie, Model model,
			HttpServletRequest req, @RequestParam(required = false) String searchKeycode,
			@RequestParam(required = false) String searchKeyword,
			@RequestParam(required = false) String searchKeycodeForType,
			@RequestParam(required = false) String startDate, @RequestParam(required = false) String endDate)
			throws Exception {

		logger.debug("started userChangeHistList controller.");

		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);

		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}

		int tenantId = userInfo.getTenantId();
		boolean isMasterAdmin = userInfo.getRollInfo().contains("c=1"); // 전체관리자
		String offset = userInfo.getOffset();
		String currPage = req.getParameter("pageNum");

		if (StringUtils.isBlank(currPage)) {
			currPage = "1";
		}

		int maxItemPerPage = 20;
		int currentPage = Integer.parseInt(currPage);
		int startRow = (Integer.parseInt(currPage) - 1) * maxItemPerPage;

		if (currPage.equals("-1")) {
			startRow = -1;
		}

		String companyId = req.getParameter("companyId"); // 선택된 회사
		logger.debug("companyId : " + companyId);

		String sysLang = ezCommonService.getTenantConfig("PrimaryLang", tenantId);

		if (userInfo.getLang().equals(sysLang)) {
			sysLang = "primary";
		}

		searchKeyword = searchKeyword.replace("%", "\\%").replace("_", "\\_");
		logger.debug("serchkeyword : {}", searchKeyword);
		List<UserChangeInfoVO> userChangeHistList = ezSystemAdminService.getUserChHistList(
				Integer.valueOf(tenantId), commonUtil.getMinuteUTC(offset), startRow, maxItemPerPage, searchKeyword, 
				searchKeycode, searchKeycodeForType, sysLang, startDate, endDate, companyId, isMasterAdmin);
		
		// 로그인 ip의 국가를 표시하기 위함
		String systemLang = userInfo.getLang();
		String systemCountryName = "";
		String systemCountryCode = ezCommonService.getTenantConfig("systemCountryCode", tenantId);

		for (UserChangeInfoVO vo : userChangeHistList) {
			String ip = vo.getExecutorIp();
			String countryName = "";
			String countryCode = "";
			logger.debug("ip : {} ", vo.getExecutorIp());	
			
			if(!"".equals(ip) || "null".equals(ip)) {
				
				if (ip.equals("0:0:0:0:0:0:0:1")) {
					ip = "127.0.0.1";
				}
	
				systemCountryName = commonUtil.getTwoLetterLangFromLangNum(systemLang, "ko");
	
				if (StringUtils.isNotBlank(ip)) {
					if (commonUtil.checkLocalIP(ip)) {
						countryCode = systemCountryCode;
					} else {
						List<CountryVO> countryVo = commonUtil.getCountryInfo(ip);
						if (countryVo.size() == 0) {
							countryName = "?";
						} else {
							countryCode = countryVo.get(0).getCountryCode();
						}
					}
				} else {
					countryName = "?";
				}
	
				if (countryName != "?") {
					Locale localeCountry = new Locale(systemCountryName, countryCode);
					countryName = localeCountry.getDisplayCountry(localeCountry);
					countryName = countryName.replaceAll(" ", "");
				}
				vo.setCountryName(countryName);
			
			}else {
				vo.setExecutorIp("");
			}
		}
		
		int itemCnt = ezSystemAdminService.getUserChHistListCount(tenantId, commonUtil.getMinuteUTC(offset),
				searchKeyword, searchKeycode, searchKeycodeForType, sysLang, startDate, endDate, companyId, isMasterAdmin);
		int totalPage = itemCnt / maxItemPerPage;
		
		if (itemCnt < 1) {
			totalPage = 1;
		}
		
		if ((totalPage * maxItemPerPage) != itemCnt && (itemCnt % maxItemPerPage) != 0) {
			totalPage = totalPage + 1;
		}

	
		
		currentPage = Math.min(currentPage, totalPage);
		model.addAttribute("userChangeHistList", userChangeHistList);
		model.addAttribute("lang", sysLang);
		model.addAttribute("currPage", currentPage);
		model.addAttribute("totalPage", totalPage);
		model.addAttribute("itemCnt", itemCnt);
		model.addAttribute("searchKeyword", searchKeyword);
		model.addAttribute("searchKeycode", searchKeycode);
		model.addAttribute("startDate", startDate);
		model.addAttribute("endDate", endDate);

		
		logger.debug("ended userChangeHistList controller.");

		return "json";
	}

	
	
	/*
	 * 엑셀 워크시트 생성 및 자동 다운로드 함수
	 * 2023-07-03 장혜연
	 */
	@RequestMapping(value = "/admin/ezSystem/userChageHistExcelExport.do", method = RequestMethod.GET)
	@ResponseBody
	public void userChageHistExcelExport (@CookieValue("loginCookie") String loginCookie,
			HttpServletRequest request, String searchKeycode, String searchKeyword, String searchKeycodeForType,
			String startDate, String endDate, Locale locale, HttpServletResponse response) throws Exception {
		logger.debug("userChageHistExcelExport controller started.");

		LoginVO user = commonUtil.userInfo(loginCookie);

		int tenantId = user.getTenantId();
		boolean isMasterAdmin = user.getRollInfo().contains("c=1"); // 전체관리자
		String offset = user.getOffset();
		String currPage = request.getParameter("pageNum");

		int maxItemPerPage = 20;
		int startRow = (Integer.parseInt(currPage) - 1) * maxItemPerPage;

		if (currPage.equals("-1")) {
			startRow = -1;
		}

		String companyId = request.getParameter("companyId"); // 선택된 회사
		String sysLang = ezCommonService.getTenantConfig("PrimaryLang", tenantId);

		if (user.getLang().equals(sysLang)) {
			sysLang = "primary";
		}

		searchKeyword = searchKeyword.replace("%", "\\%").replace("_", "\\_");
		List<UserChangeInfoVO> userChangeHist = new ArrayList<UserChangeInfoVO>();
		int totalCount = 0;

		userChangeHist = ezSystemAdminService.getUserChHistList(Integer.valueOf(tenantId),
				commonUtil.getMinuteUTC(offset), startRow, maxItemPerPage, searchKeyword, searchKeycode,
				searchKeycodeForType, sysLang, startDate, endDate, companyId, isMasterAdmin);
		totalCount = ezSystemAdminService.getUserChHistListCount(tenantId, commonUtil.getMinuteUTC(offset),
				searchKeyword, searchKeycode, searchKeycodeForType, sysLang, startDate, endDate, companyId, isMasterAdmin);
		
		/* 엑셀 만들기 */
		try (HSSFWorkbook workbook = new HSSFWorkbook()) {
			HSSFSheet sheet = workbook.createSheet("userChangeHistory");
	
			Row row = null;
			Cell cell = null;
	
			String fileName = "";
			fileName = startDate + "_" + endDate + "_userChangeHistory";
	
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
	
			String histHeader = egovMessageSource.getMessage("ezSystem.jhyUserChangeHistory", locale);
			String[] histHeaderArr = histHeader.split(";");
			int histHeaderLen = histHeaderArr.length;
	
			row = sheet.createRow(0);
			cell = row.createCell(0);
			cell.setCellValue(egovMessageSource.getMessage("ezSystem.x0032", locale) + " : " + startDate + " ~ " + endDate);
			cell = row.createCell(histHeaderLen - 1);
			cell.setCellValue(egovMessageSource.getMessage("main.t252", locale) + " " + totalCount
					+ egovMessageSource.getMessage("ezSystem.kyj2", locale));
	
			row = sheet.createRow(1);
			for (int i = 0; i < histHeaderLen; i++) {
				cell = row.createCell(i);
				cell.setCellValue(histHeaderArr[i]);
				cell.setCellStyle(headerStyle);
			}
	
			String systemLang = user.getLang();
			String systemCountryName = "";
			String systemCountryCode = ezCommonService.getTenantConfig("systemCountryCode", tenantId);
	
			for (int i = 2; i < totalCount + 2; i++) {
				row = sheet.createRow(i);
				row.setHeight((short) 300);
				int j = 2;
	
				// countryIP 관련 국가명 표시 위함 시작.
				String ip = userChangeHist.get(i - j).getExecutorIp();
				String countryName = "";
				String countryCode = "";
	
				if (ip.equals("0:0:0:0:0:0:0:1")) {
					ip = "127.0.0.1";
				}
	
				systemCountryName = commonUtil.getTwoLetterLangFromLangNum(systemLang, "ko");
	
				if (StringUtils.isNotBlank(ip)) {
					if (commonUtil.checkLocalIP(ip)) {
						countryCode = systemCountryCode;
					} else {
						List<CountryVO> countryVo = commonUtil.getCountryInfo(ip);
						if (countryVo.size() == 0) {
							countryName = "?";
						} else {
							countryCode = countryVo.get(0).getCountryCode();
						}
					}
				} else {
					countryName = "?";
				}
	
				if (!"?".equals(countryName)) {
					Locale localeCountry = new Locale(systemCountryName, countryCode);
					countryName = localeCountry.getDisplayCountry(localeCountry);
					countryName = countryName.replaceAll(" ", "");
				}
				userChangeHist.get(i - j).setCountryName(countryName);
				// countryIP 관련 국가명 표시 위함 끝.
	
				UserChangeInfoVO infoVo = userChangeHist.get(i - j);
	
				String userName = infoVo.getUserNm() + "(" + infoVo.getUserId() + ")";
				String userDeptName = infoVo.getDeptNm();
				String userCompanyName = infoVo.getCompanyNm();
				String updateTime = infoVo.getUpdatedt();
				String targetDeptName = infoVo.getTargetDeptNm();
				String updateType = ""; 
					switch(infoVo.getUpdateType()) {
						case "add" : updateType = egovMessageSource.getMessage("ezSystem.jhy03", locale); break;
						case "retire" : updateType = egovMessageSource.getMessage("ezSystem.jhy04", locale); break;
						case "delete" : updateType = egovMessageSource.getMessage("ezSystem.jhy05", locale); break;
						case "restore" : updateType = egovMessageSource.getMessage("ezSystem.lhw01", locale); break;
						case "mvDept" : updateType = egovMessageSource.getMessage("ezSystem.jhy06", locale); break;
						case "grantAddJob" : updateType = egovMessageSource.getMessage("ezSystem.jhy07", locale); break;
						case "clearAddJob" : updateType = egovMessageSource.getMessage("ezSystem.jhy08", locale); break;
					}
				
				String executor = egovMessageSource.getMessage("ezSystem.jhy09", locale);
				String executorIp = "";
				
				if (!infoVo.getExecutorId().equals("ez_sync")) {
						executor = infoVo.getExecutorNm() + "(" + infoVo.getExecutorId() + ")";
						executorIp = infoVo.getExecutorIp() + "(" + userChangeHist.get(i - j).getCountryName() + ")";					
				}	
			
	
				if (!sysLang.equals("primary")) {
					userName = infoVo.getUserNm2() + "(" + infoVo.getUserId() + ")";
					userDeptName = infoVo.getDeptNm2();
					userCompanyName = infoVo.getCompanyNm2();
					targetDeptName = infoVo.getTargetDeptNm2(); 
					executor = infoVo.getExecutorNm2() + "(" + infoVo.getExecutorId() + ")";
				}
	
				String[] userChHist = null;
				userChHist = new String[] { userName, userDeptName, userCompanyName, updateTime, targetDeptName, updateType,
						executor, executorIp };
	
				for (int k = 0; k < histHeaderLen; k++) {
					cell = row.createCell(k);
					cell.setCellValue((String) userChHist[k]);
					cell.setCellStyle(bodyStyle);
				}
	
				sheet.autoSizeColumn(i - 1);
			}
	
			response.setCharacterEncoding("UTF-8");
			response.setHeader("Content-Disposition", "attachment; fileName=" + fileName + ".xls");
			response.setContentType("application/vnd.ms-excel");
	
			workbook.write(response.getOutputStream());
			//workbook.close();
		}

		logger.debug("userChageHistExcelExport ended.");
	}
	
	
	/*
	 * 사용자 변경 히스토리 메인 호출 
	 * 2023-07-03 장혜연
	 */
	@RequestMapping(value = "/admin/ezSystem/systemDeptChangeHist.do", method = RequestMethod.GET)
	public String deptChangeHistory(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model) throws Exception {
		
		logger.debug("started deptChangeHistory controller.");

		LoginVO user = commonUtil.checkAdmin(loginCookie);

		if (user == null) {
			return "cmm/error/adminDenied";
		}

		String companyId = user.getCompanyID();
		int tenantId = user.getTenantId();

		List<OrganDeptVO> adminCompanyList = ezOrganAdminService.getAdminCompanyList(user.getId(), user.getTenantId(), user.getPrimary(), user.getDeptID(), user.getJobId());
		OrganAuth organAuth = commonUtil.makeOrganAuth(user.getId(), user.getTenantId(), user.getDeptID(), user.getJobId());
		boolean isMasterAdmin = organAuth.isAuth(AdminAuth.ADMIN_MASTER);

		model.addAttribute("list", adminCompanyList);
		model.addAttribute("companyId", companyId);
		model.addAttribute("isMasterAdmin", isMasterAdmin);

		logger.debug("ended deptChangeHistory controller.");

		return "/ezSystem/systemDeptChangeHist";
	}
	
	/**
	 * 부서 변경 히스토리 데이터 리스트 호출
	 * 2023-07-03 장혜연
	 */
	@RequestMapping(value = "/admin/ezSystem/deptChangeHistList.do", method = RequestMethod.POST)
	public String deptChangeHistList(@CookieValue("loginCookie") String loginCookie, Model model,
			HttpServletRequest req, @RequestParam(required = false) String searchKeycode,
			@RequestParam(required = false) String searchKeyword,
			@RequestParam(required = false) String searchKeycodeForType,
			@RequestParam(required = false) String startDate, @RequestParam(required = false) String endDate)
			throws Exception {

		logger.debug("started deptChangeHistList controller.");

		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);

		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}

		int tenantId = userInfo.getTenantId();
		boolean isMasterAdmin = userInfo.getRollInfo().contains("c=1"); // 전체관리자
		String offset = userInfo.getOffset();
		String currPage = req.getParameter("pageNum");

		if (StringUtils.isBlank(currPage)) {
			currPage = "1";
		}

		int maxItemPerPage = 20;
		int currentPage = Integer.parseInt(currPage);
		int startRow = (Integer.parseInt(currPage) - 1) * maxItemPerPage;

		if (currPage.equals("-1")) {
			startRow = -1;
		}

		String companyId = req.getParameter("companyId"); // 선택된 회사
		logger.debug("companyId : " + companyId);

		String sysLang = ezCommonService.getTenantConfig("PrimaryLang", tenantId);

		if (userInfo.getLang().equals(sysLang)) {
			sysLang = "primary";
		}

		searchKeyword = searchKeyword.replace("%", "\\%").replace("_", "\\_");
		logger.debug("serchkeyword : {}", searchKeyword);
		List<DeptChangeInfoVO> deptChangeHistList = ezSystemAdminService.getDeptChHistList(
				Integer.valueOf(tenantId), commonUtil.getMinuteUTC(offset), startRow, maxItemPerPage, searchKeyword, 
				searchKeycode, searchKeycodeForType, sysLang, startDate, endDate, companyId, isMasterAdmin);
		
		// 로그인 ip의 국가를 표시하기 위함
		String systemLang = userInfo.getLang();
		String systemCountryName = "";
		String systemCountryCode = ezCommonService.getTenantConfig("systemCountryCode", tenantId);

		for (DeptChangeInfoVO vo : deptChangeHistList) {
			String ip = vo.getExecutorIp();
			String countryName = "";
			String countryCode = "";
			logger.debug("ip : {} ", vo.getExecutorIp());	
			
			if(!"".equals(ip) || "null".equals(ip)) {
				
				if (ip.equals("0:0:0:0:0:0:0:1")) {
					ip = "127.0.0.1";
				}
	
				switch (systemLang) {
				case "1":
					systemCountryName = "ko";
					break;
				case "2":
					systemCountryName = "en";
					break;
				case "3":
					systemCountryName = "ja";
					break;
				case "4":
					systemCountryName = "zh";
					break;
				default:
					systemCountryName = "ko";
					break;
				}
	
				if (StringUtils.isNotBlank(ip)) {
					if (commonUtil.checkLocalIP(ip)) {
						countryCode = systemCountryCode;
					} else {
						List<CountryVO> countryVo = commonUtil.getCountryInfo(ip);
						if (countryVo.size() == 0) {
							countryName = "?";
						} else {
							countryCode = countryVo.get(0).getCountryCode();
						}
					}
				} else {
					countryName = "?";
				}
	
				if (countryName != "?") {
					Locale localeCountry = new Locale(systemCountryName, countryCode);
					countryName = localeCountry.getDisplayCountry(localeCountry);
					countryName = countryName.replaceAll(" ", "");
				}
				vo.setCountryName(countryName);
			
			}else {
				vo.setExecutorIp("");
			}
		}
		
		int itemCnt = ezSystemAdminService.getDeptChHistListCount(tenantId, commonUtil.getMinuteUTC(offset),
				searchKeyword, searchKeycode, searchKeycodeForType, sysLang, startDate, endDate, companyId, isMasterAdmin);
		int totalPage = itemCnt / maxItemPerPage;
		
		if (itemCnt < 1) {
			totalPage = 1;
		}
		
		if ((totalPage * maxItemPerPage) != itemCnt && (itemCnt % maxItemPerPage) != 0) {
			totalPage = totalPage + 1;
		}

	
		
		currentPage = Math.min(currentPage, totalPage);
		model.addAttribute("deptChangeHistList", deptChangeHistList);
		model.addAttribute("lang", sysLang);
		model.addAttribute("currPage", currentPage);
		model.addAttribute("totalPage", totalPage);
		model.addAttribute("itemCnt", itemCnt);
		model.addAttribute("searchKeyword", searchKeyword);
		model.addAttribute("searchKeycode", searchKeycode);
		model.addAttribute("startDate", startDate);
		model.addAttribute("endDate", endDate);

		
		logger.debug("ended deptChangeHistList controller.");

		return "json";
	}
	
	/*
	 * 엑셀 워크시트 생성 및 자동 다운로드 함수
	 * 2024-03-15 장혜연
	 */
	@RequestMapping(value = "/admin/ezSystem/deptChageHistExcelExport.do", method = RequestMethod.GET)
	@ResponseBody
	public void deptChageHistExcelExport (@CookieValue("loginCookie") String loginCookie,
			HttpServletRequest request, String searchKeycode, String searchKeyword, String searchKeycodeForType,
			String startDate, String endDate, Locale locale, HttpServletResponse response) throws Exception {
		logger.debug("deptChageHistExcelExport started.");

		LoginVO user = commonUtil.userInfo(loginCookie);

		int tenantId = user.getTenantId();
		boolean isMasterAdmin = user.getRollInfo().contains("c=1"); // 전체관리자
		String offset = user.getOffset();
		String currPage = request.getParameter("pageNum");

		int maxItemPerPage = 20;
		int startRow = (Integer.parseInt(currPage) - 1) * maxItemPerPage;

		if (currPage.equals("-1")) {
			startRow = -1;
		}

		String companyId = request.getParameter("companyId"); // 선택된 회사
		String sysLang = ezCommonService.getTenantConfig("PrimaryLang", tenantId);

		if (user.getLang().equals(sysLang)) {
			sysLang = "primary";
		}

		searchKeyword = searchKeyword.replace("%", "\\%").replace("_", "\\_");
		List<DeptChangeInfoVO> deptChangeHist = new ArrayList<DeptChangeInfoVO>();
		int totalCount = 0;
		
		
		String fileName = startDate + "_" + endDate + "_deptChangeHistory";
		
		deptChangeHist = ezSystemAdminService.getDeptChHistList(Integer.valueOf(tenantId),
				commonUtil.getMinuteUTC(offset), startRow, maxItemPerPage, searchKeyword, searchKeycode,
				searchKeycodeForType, sysLang, startDate, endDate, companyId, isMasterAdmin);
		totalCount = ezSystemAdminService.getDeptChHistListCount(tenantId, commonUtil.getMinuteUTC(offset),
				searchKeyword, searchKeycode, searchKeycodeForType, sysLang, startDate, endDate, companyId, isMasterAdmin);
		
		String deptNm = "";
		String parentNm = "";
		String compNm = "";
		String updateType = "";
		String executorNm = "";
		String countryName = "";
		String countryCode = "";
		String systemCountryName = "";
		List<List<String>> rowDeptValue = new ArrayList<List<String>>();

		for (DeptChangeInfoVO deptInfo : deptChangeHist) {
			String targetNm = "";
			List<String> cellDeptValue = new ArrayList<>();

			updateType = deptInfo.getUpdateType();

			deptNm = deptInfo.getDeptNm() + "(" + deptInfo.getDeptId() + ")";
			parentNm = deptInfo.getParentDeptNm() + "(" + deptInfo.getParentDeptId() + ")";
			compNm = deptInfo.getCompanyNm();
			executorNm = deptInfo.getExecutorNm() + "(" + deptInfo.getExecutorId() + ")";
			if ("nameChange".equals(updateType)) {
				targetNm = deptInfo.getTargetDeptNm() + "/" + deptInfo.getParentDeptNm();
			} else if ("move".equals(updateType)) {
				targetNm = deptInfo.getDeptNm() + "/" + deptInfo.getTargetDeptNm();
			}

			if (!"primary".equals(sysLang)) {
				deptNm = deptInfo.getDeptNm2() + "(" + deptInfo.getDeptId() + ")";
				parentNm = deptInfo.getParentDeptNm2() + "(" + deptInfo.getParentDeptId() + ")";
				compNm = deptInfo.getCompanyNm2();
				executorNm = deptInfo.getExecutorNm2() + "(" + deptInfo.getExecutorId() + ")";
				if ("nameChange".equals(updateType)) {
					targetNm = deptInfo.getTargetDeptNm2() + "/" + deptInfo.getParentDeptNm2();
				} else if ("move".equals(updateType)) {
					targetNm = deptInfo.getDeptNm2() + "/" + deptInfo.getTargetDeptNm2();
				}
			}

			switch (updateType) {
			case "add":
				updateType = egovMessageSource.getMessage("ezSystem.jhy03", locale);
				break;
			case "move":
				updateType = egovMessageSource.getMessage("ezWebFolder.t282", locale);
				break;
			case "delete":
				updateType = egovMessageSource.getMessage("ezSystem.jhy05", locale);
				break;
			case "nameChange":
				updateType = egovMessageSource.getMessage("ezSystem.jhy15", locale);
				break;
			case "abolition":
				updateType = egovMessageSource.getMessage("ezSystem.jhy13", locale);
				break;
			}

			String ip = deptInfo.getExecutorIp().equals("0:0:0:0:0:0:0:1") ? "127.0.0.1" : deptInfo.getExecutorIp();

			switch (user.getLang()) {
			case "1": systemCountryName = "ko"; break;
			case "2": systemCountryName = "en"; break;
			case "3": systemCountryName = "ja"; break;
			case "4": systemCountryName = "zh"; break;
			default: systemCountryName = "ko"; break;
			}

			if (StringUtils.isNotBlank(ip)) {
				if (commonUtil.checkLocalIP(ip)) {
					countryCode = ezCommonService.getTenantConfig("systemCountryCode", tenantId);
				} else if (commonUtil.getCountryInfo(ip).size() > 0) {
					countryCode = commonUtil.getCountryInfo(ip).get(0).getCountryCode();
				}
			}

			if (!"".equals(countryCode)) {
				Locale localeCountry = new Locale(systemCountryName, countryCode);
				countryName = localeCountry.getDisplayCountry(localeCountry);
				countryName = countryName.replaceAll(" ", "");
			}

			cellDeptValue.add(deptNm);
			cellDeptValue.add(parentNm);
			cellDeptValue.add(compNm);
			cellDeptValue.add(deptInfo.getUpdatedt());
			cellDeptValue.add(targetNm);
			cellDeptValue.add(updateType);
			cellDeptValue.add(executorNm);
			if (!"".equals(countryName)) {
				cellDeptValue.add(ip + "(" + countryName + ")");
			} else {
				cellDeptValue.add(ip);
			}

			rowDeptValue.add(cellDeptValue);
		}

		SXSSFRow row = null;
		SXSSFCell cell = null;
		String[] histHeaderArr = egovMessageSource.getMessage("ezSystem.jhyDeptChangeHistory", locale).split(";");

		try (SXSSFWorkbook workbook = new SXSSFWorkbook(totalCount + 2)) {
			SXSSFSheet sheet = workbook.createSheet("deptChangeHistory");
			CellStyle headerStyle = workbook.createCellStyle();
			CellStyle bodyStyle = workbook.createCellStyle();

			// 시트 기본 열 넓이
			sheet.setDefaultColumnWidth(20);

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

			// 1행 - 조회한 기간, count 입력
			row = sheet.createRow(0);
			cell = row.createCell(0);
			cell.setCellStyle(bodyStyle);
			cell.setCellValue(egovMessageSource.getMessage("ezSystem.x0032", locale) + " : " + startDate + " ~ " + endDate);
			cell = row.createCell(histHeaderArr.length - 1);
			cell.setCellStyle(bodyStyle);
			cell.setCellValue(egovMessageSource.getMessage("main.t252", locale) + " " + totalCount + egovMessageSource.getMessage("ezSystem.kyj2", locale));

			// 2행 - 헤더 입력
			row = sheet.createRow(1);
			for (int head = 0; head < histHeaderArr.length; head++) {
				cell = row.createCell(head);
				cell.setCellStyle(headerStyle);
				cell.setCellValue(histHeaderArr[head]);
			}

			// 3행 ~ - 바디 입력 
			for (int nRow = 2; nRow < totalCount + 2; nRow++) {
				row = sheet.createRow(nRow);

				for (int nCell = 0; nCell < histHeaderArr.length; nCell++) {
					cell = row.createCell(nCell);
					cell.setCellStyle(bodyStyle);
					cell.setCellValue(rowDeptValue.get(nRow - 2).get(nCell));
				}
			}
			response.setCharacterEncoding("UTF-8");
			response.setHeader("Content-Disposition", "attachment; fileName=" + fileName + ".xlsx");
			response.setContentType("application/vnd.ms-excel");

			workbook.write(response.getOutputStream());
			workbook.close();
		};
		logger.debug("deptChageHistExcelExport ended.");
	}

	/**
	 * 접속자 목록 메인 호출
	 * 2024-05-21 장혜연
	 */
	@RequestMapping(value="/admin/ezSystem/systemConnectorHist.do", method = RequestMethod.GET)
	public String systemConnectorList(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model) throws Exception {

		logger.debug("started systemConnectorList controller.");

		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);

		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}

		String companyId = userInfo.getCompanyID();

		String LoginMailLogKeepPeriod = ezCommonService.getTenantConfig("LoginMailLogKeepPeriod",
				userInfo.getTenantId());
		LoginMailLogKeepPeriod = LoginMailLogKeepPeriod.equals("") ? "3" : LoginMailLogKeepPeriod;

		String mailLogKeepPeriodMessage = egovMessageSource.getMessage("ezStatistics.t1065", locale);
		mailLogKeepPeriodMessage = String.format(mailLogKeepPeriodMessage, LoginMailLogKeepPeriod);

		model.addAttribute("mailLogKeepPeriodMessage", mailLogKeepPeriodMessage);

		List<OrganDeptVO> list = ezOrganAdminService.getCompanyList(userInfo.getPrimary(), userInfo.getTenantId());
		List<OrganDeptVO> resultList = new ArrayList<OrganDeptVO>();
		int j = 0;

		for (int i = 0; i < list.size(); i++) {
			OrganDeptVO vo = list.get(i);

			if (userInfo.getRollInfo().indexOf("c=1") > -1 || vo.getCn().equals(userInfo.getCompanyID())) {
				resultList.add(j++, vo);
			}
		}

		String isMasterAdmin = "";
		if (userInfo.getRollInfo().indexOf("c=1") != -1) { // 전체관리자
			isMasterAdmin = "y";
		}

		model.addAttribute("list", resultList);
		model.addAttribute("companyId", companyId);
		model.addAttribute("isMasterAdmin", isMasterAdmin);

		logger.debug("ended systemConnectorList controller.");

		return "/ezSystem/systemConnectorHist";

	}

	/**
	 * 접속자 데이터 목록 호출
	 * 2024-05-21 장혜연
	 */
	@RequestMapping(value="/admin/ezSystem/systemConnectorList.do", method = RequestMethod.POST)
	public String systemConnectorList(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest req,
			@RequestParam(required=false)String searchKeycode, @RequestParam(required=false)String searchKeyword,
			@RequestParam(required=false)String startDate, @RequestParam(required=false)String endDate) throws Exception {

		logger.debug("started systemConnectorList controller.");

		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);

		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		String offset = userInfo.getOffset();
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

		/*
		 * 2018.11.21 김수아 (전체관리자) 회사선택 후 선택한 회사의 로그인 히스토리가 나오도록 변경
		 */
		String companyId = req.getParameter("companyId"); // 선택된 회사

		/*
		 * 2017.07.26 강민석 로그인 히스토리에는 자신의 회사만 나오도록 수정
		 */
		// String companyId = userInfo.getCompanyID();
		logger.debug("companyId : " + companyId);

		String sysLang = ezCommonService.getTenantConfig("PrimaryLang", userInfo.getTenantId());

		if (userInfo.getLang().equals(sysLang)) {
			sysLang = "primary";
		}

		searchKeyword = searchKeyword.replace("%", "\\%").replace("_", "\\_");
		List<ConnectionInfoVO> loginHistList = ezSystemAdminService.getConnectorList(
				Integer.valueOf(userInfo.getTenantId()), commonUtil.getMinuteUTC(offset), startRow, maxItemPerPage,
				searchKeycode, searchKeyword, sysLang, startDate, endDate, companyId);

		int itemCnt = ezSystemAdminService.getConnectorListCount(userInfo.getTenantId(),
				commonUtil.getMinuteUTC(offset), searchKeycode, searchKeyword, sysLang, startDate, endDate, companyId);

		int totalPage = itemCnt / maxItemPerPage;

		if (itemCnt < 1) {
			totalPage = 1;
		}

		if ((totalPage * maxItemPerPage) != itemCnt && (itemCnt % maxItemPerPage) != 0) {
			totalPage = totalPage + 1;
		}

		currentPage = Math.min(currentPage, totalPage);
		model.addAttribute("loginHistList", loginHistList);
		model.addAttribute("lang", sysLang);
		model.addAttribute("currPage", currentPage);
		model.addAttribute("totalPage", totalPage);
		model.addAttribute("itemCnt", itemCnt);
		model.addAttribute("searchKeyword", searchKeyword);
		model.addAttribute("searchKeycode", searchKeycode);
		model.addAttribute("startDate", startDate);
		model.addAttribute("endDate", endDate);

		logger.debug("ended systemConnectorList controller.");

		return "json";
	}

	/*
	 * 엑셀 워크시트 생성 및 자동 다운로드 함수
	 * 2024-05-21 장혜연
	 */
	@RequestMapping(value = "/admin/ezSystem/systemConnHistExcelExport.do", method = RequestMethod.GET)
	@ResponseBody
	public void connectorHistExcelExport (@CookieValue("loginCookie") String loginCookie,
			HttpServletRequest request, String searchKeycode, String searchKeyword,
			String startDate, String endDate, Locale locale, HttpServletResponse response) throws Exception {
		logger.debug("connectorHistExcelExport started.");

		LoginVO user = commonUtil.userInfo(loginCookie);

		int tenantId = user.getTenantId();
		String offset = user.getOffset();
		String currPage = request.getParameter("pageNum");

		int maxItemPerPage = 20;
		int startRow = (Integer.parseInt(currPage) - 1) * maxItemPerPage;

		if (currPage.equals("-1")) {
			startRow = -1;
		}

		String companyId = request.getParameter("companyId"); // 선택된 회사
		String sysLang = ezCommonService.getTenantConfig("PrimaryLang", tenantId);

		if (user.getLang().equals(sysLang)) {
			sysLang = "primary";
		}

		searchKeyword = searchKeyword.replace("%", "\\%").replace("_", "\\_");
		List<ConnectionInfoVO> connectorList = new ArrayList<ConnectionInfoVO>();
		int totalCount = 0;

		String fileName = startDate + "_" + endDate + "_connectorHistory";

		connectorList = ezSystemAdminService.getConnectorList(Integer.valueOf(tenantId),
				commonUtil.getMinuteUTC(offset), startRow, maxItemPerPage, searchKeycode, searchKeyword, sysLang,
				startDate, endDate, companyId);
		totalCount = ezSystemAdminService.getConnectorListCount(tenantId, commonUtil.getMinuteUTC(offset),
				searchKeycode, searchKeyword, sysLang, startDate, endDate, companyId);

		String userNm = "";
		String deptNm = "";
		String compNm = "";

		List<List<String>> rowDeptValue = new ArrayList<List<String>>();

		for (ConnectionInfoVO connInfo : connectorList) {
			List<String> cellDeptValue = new ArrayList<>();

			userNm = connInfo.getUsernm() + "(" + connInfo.getUserid() + ")";
			deptNm = connInfo.getDeptnm();
			compNm = connInfo.getCompanynm();

			if (!"primary".equals(sysLang)) {
				userNm = connInfo.getUsernm2() + "(" + connInfo.getUserid() + ")";
				deptNm = connInfo.getDeptnm2();
				compNm = connInfo.getCompanynm2();
			}

			cellDeptValue.add(userNm);
			cellDeptValue.add(deptNm);
			cellDeptValue.add(compNm);

			rowDeptValue.add(cellDeptValue);
		}

		SXSSFRow row = null;
		SXSSFCell cell = null;
		String[] histHeaderArr = egovMessageSource.getMessage("ezSystem.jhyConnectorHistory", locale).split(";");

		try (SXSSFWorkbook workbook = new SXSSFWorkbook(totalCount + 2)) {
			SXSSFSheet sheet = workbook.createSheet("connectorHistory");
			CellStyle headerStyle = workbook.createCellStyle();
			CellStyle bodyStyle = workbook.createCellStyle();

			// 시트 기본 열 넓이
			sheet.setDefaultColumnWidth(20);

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

			// 1행 - 조회한 기간, count 입력
			row = sheet.createRow(0);
			cell = row.createCell(0);
			cell.setCellStyle(bodyStyle);
			cell.setCellValue(
					egovMessageSource.getMessage("ezSystem.x0032", locale) + " : " + startDate + " ~ " + endDate);
			cell = row.createCell(histHeaderArr.length - 1);
			cell.setCellStyle(bodyStyle);
			cell.setCellValue(egovMessageSource.getMessage("main.t252", locale) + " " + totalCount
					+ egovMessageSource.getMessage("ezSystem.kyj2", locale));

			// 2행 - 헤더 입력
			row = sheet.createRow(1);
			for (int head = 0; head < histHeaderArr.length; head++) {
				cell = row.createCell(head);
				cell.setCellStyle(headerStyle);
				cell.setCellValue(histHeaderArr[head]);
			}

			// 3행 ~ - 바디 입력
			for (int nRow = 2; nRow < totalCount + 2; nRow++) {
				row = sheet.createRow(nRow);

				for (int nCell = 0; nCell < histHeaderArr.length; nCell++) {
					cell = row.createCell(nCell);
					cell.setCellStyle(bodyStyle);
					cell.setCellValue(rowDeptValue.get(nRow - 2).get(nCell));
				}
			}
			response.setCharacterEncoding("UTF-8");
			response.setHeader("Content-Disposition", "attachment; fileName=" + fileName + ".xlsx");
			response.setContentType("application/vnd.ms-excel");

			workbook.write(response.getOutputStream());
			workbook.close();
		}
		;
		logger.debug("connectorHistExcelExport ended.");
	}

	@RequestMapping(value = "/admin/ezSystem/resetUserSettings.do", method = RequestMethod.GET)
	public String resetUserSettings(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception{
		logger.debug("resetUserSettings started.");

		LoginVO user = commonUtil.checkAdmin(loginCookie);
		//관리자 권한 체크
		if (user == null) {
			return "cmm/error/adminDenied";
		}

		model.addAttribute("type", request.getParameter("type"));

		logger.debug("resetUserSettings ended.");
		return "/ezSystem/systemResetUserSettings";
	}

	@ResponseBody
	@RequestMapping(value = "/admin/ezSystem/allUserResetFrame.do", method=RequestMethod.POST)
	public String allUserResetFrame(@CookieValue String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("allUserResetFrame started.");
		//관리자 권한체크
		LoginVO user = commonUtil.checkAdmin(loginCookie);

		if (user == null) {
			return "cmm/error/adminDenied";
		}

		try {
			ezSystemAdminService.resetThemeAllUser();
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			logger.debug("allUserResetFrame ended.");
			return "fail";
		}

		logger.debug("allUserResetFrame ended.");
		return "success";
	}

	@ResponseBody
	@RequestMapping(value = "/admin/ezSystem/allUserResetPortlet.do", method=RequestMethod.POST)
	public String allUserResetPortlet(@CookieValue String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("allUserResetPortlet started.");
		//관리자 권한체크
		LoginVO user = commonUtil.checkAdmin(loginCookie);

		if (user == null) {
			return "cmm/error/adminDenied";
		}

		try {
			ezSystemAdminService.resetPortletAllUser();
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			logger.debug("resetPortletAllUser ended.");
			return "fail";
		}

		logger.debug("allUserResetPortlet ended.");
		return "success";
	}
	
	/**
	 * 시스템 SYSTEM CONFIG 메뉴 호출 함수
	 */
	@RequestMapping(value = "/admin/ezSystem/systemConfigList.do", method = RequestMethod.GET)	
	public String systemConfigList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception{
	    logger.debug("systemConfigList started.");
	    
		LoginVO user = commonUtil.checkAdmin(loginCookie);
		//관리자 권한 체크
		if (user == null) {
			return "cmm/error/adminDenied";
		}
		model.addAttribute("isAdmin", user.getRollInfo().indexOf("c=1") > -1);
		model.addAttribute("lang", user.getLang());
		
		logger.debug("systemConfigList ended.");
		
		return "/ezSystem/systemConfigList";
	}
	
	/**
	 * 시스템 SYSTEM CONFIG 리스트 호출 함수
	 */
	@RequestMapping(value = "/admin/ezSystem/getSystemConfigList.do", method = RequestMethod.POST, produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getSystemConfigList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception{
	    logger.debug("getSystemConfigList started.");
	    
        LoginVO userInfo = commonUtil.userInfo(loginCookie);
        int tenantID = userInfo.getTenantId();
        String useLang = commonUtil.getPrimaryData(userInfo.getLang(), userInfo.getTenantId());
        logger.debug("tenantID=" + tenantID);
	    
        String companyID = request.getParameter("companyID");
        String typeCode = request.getParameter("typeCode");
		String searchValue = request.getParameter("searchValue");
		int pageNum = Integer.parseInt(request.getParameter("pageNum"));
		int pageSize = Integer.parseInt(request.getParameter("pageSize"));		
        
		searchValue = searchValue.replace("%", "\\%").replace("_", "\\_");
		
        int cnt = ezSystemAdminService.getSystemConfigListCount(searchValue, typeCode, companyID, tenantID);
        int totalPages  = (cnt + pageSize - 1) / pageSize;
        pageNum = pageNum > totalPages ? totalPages : pageNum;
        pageNum = pageNum == 0         ? 1          : pageNum;

        int startRow  = (pageNum - 1) * pageSize;
        logger.debug("searchValue=" + searchValue + ",pageNum=" + pageNum
                + ",pageSize=" + pageSize + ",startRow=" + startRow + ",totalCount=" + cnt);
        
        List<SystemConfigVO> list = ezSystemAdminService.getSystemConfigList(searchValue, typeCode, commonUtil.getMinuteUTC(userInfo.getOffset()), startRow, pageSize, companyID, tenantID);
        
		StringBuilder result = new StringBuilder("<LISTVIEWDATA>");
		result.append("<ROWS>");
		result.append("<TOTALCNT>");
		result.append(cnt);
		result.append("</TOTALCNT>");
        
        for (int i = 0; i < list.size(); i++) {
        	SystemConfigVO vo = list.get(i);
        	
        	result.append("<ROW>");
        	result.append("<CELL>");
        	result.append("<VALUE>" + commonUtil.cleanValue(vo.getCode()) + "</VALUE>");
            result.append("<DATA1>" + commonUtil.cleanValue(vo.getCode()) + "</DATA1>");
            result.append("<DATA2>" + commonUtil.cleanValue(vo.getTypeCode()) + "</DATA2>");
            if (useLang.equals("1")) {
            	result.append("<DATA3>" + commonUtil.cleanValue(vo.getTypeName()) + "</DATA3>");
            } else {
            	result.append("<DATA3>" + commonUtil.cleanValue(vo.getTypeName2()) + "</DATA3>");
            }
            result.append("<DATA4>" + commonUtil.cleanValue(vo.getCodeValue()) + "</DATA4>");
            result.append("<DATA5>" + commonUtil.cleanValue(vo.getDescription()) + "</DATA5>");
            result.append("<DATA6>" + commonUtil.cleanValue(vo.getWriterid()) + "</DATA6>");
            result.append("<DATA7>" + commonUtil.cleanValue(vo.getWritername()) + "</DATA7>");
            result.append("<DATA8>" + commonUtil.cleanValue(vo.getWritedate()) + "</DATA8>");
            result.append("<DATA9>" + commonUtil.cleanValue(vo.getIsDeleteBlock()) + "</DATA9>");
            result.append("</CELL>");
            result.append("<CELL>");
            result.append("<VALUE>" + commonUtil.cleanValue(vo.getCode()) + "</VALUE>");
            result.append("</CELL>");
            result.append("<CELL>");
            if (useLang.equals("1")) {
            	result.append("<VALUE>" + commonUtil.cleanValue(vo.getTypeName()) + "</VALUE>");
            } else {
            	result.append("<VALUE>" + commonUtil.cleanValue(vo.getTypeName2()) + "</VALUE>");
            }
            result.append("</CELL>");
            result.append("<CELL>");
            result.append("<VALUE>" + commonUtil.cleanValue(vo.getCodeValue()) + "</VALUE>");
            result.append("</CELL>");
            result.append("<CELL>");
            result.append("<VALUE>" + commonUtil.cleanValue(vo.getDescription()) + "</VALUE>");
            result.append("</CELL>");
            result.append("<CELL>");
            result.append("<VALUE>" + commonUtil.cleanValue(vo.getWritername()) + "</VALUE>");
            result.append("</CELL>");
            result.append("<CELL>");
            result.append("<VALUE>" + commonUtil.cleanValue(vo.getWritedate().substring(0, 10)) + "</VALUE>");
            result.append("</CELL>");
            result.append("<CELL>");
            result.append("<VALUE>" + commonUtil.cleanValue(vo.getIsDeleteBlock().toUpperCase().equals("Y") ? "O" : "X") + "</VALUE>");
            result.append("</CELL>");
            result.append("</ROW>");
        }
        result.append("</ROWS>");
        result.append("</LISTVIEWDATA>");
        
        logger.debug("getSystemConfigList ended.");
        
		return result.toString();
	}
	
	/**
	 * 시스템 SYSTEM CONFIG 리스트 호출 함수
	 */
	@RequestMapping(value = "/admin/ezSystem/getSystemConfigListPopup.do", method = RequestMethod.POST, produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getSystemConfigListPopup(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception{
	    logger.debug("getSystemConfigListPopup started.");
	    
        LoginVO userInfo = commonUtil.userInfo(loginCookie);
        int tenantID = userInfo.getTenantId();
        
        logger.debug("tenantID=" + tenantID);
	    String companyID = request.getParameter("companyID");
	    String typeCode = request.getParameter("typeCode");
		String searchValue = request.getParameter("searchValue");
		int pageNum = Integer.parseInt(request.getParameter("pageNum"));
		int pageSize = Integer.parseInt(request.getParameter("pageSize"));		
        
        
		searchValue = searchValue.replace("%", "\\%").replace("_", "\\_");
		
        int cnt = ezSystemAdminService.getSystemConfigListCountPopup(searchValue, typeCode, companyID, tenantID);
        
        int totalPages  = (cnt + pageSize - 1) / pageSize;
        pageNum = pageNum > totalPages ? totalPages : pageNum;
        pageNum = pageNum == 0         ? 1          : pageNum;

        int startRow  = (pageNum - 1) * pageSize;
        int endRow = Math.multiplyExact(pageSize, pageNum);
        logger.debug("searchValue=" + searchValue + ",pageNum=" + pageNum
                + ",pageSize=" + pageSize + ",startRow=" + startRow + ",endRow=" + endRow
                + ",totalCount=" + cnt);
        
        List<SystemConfigVO> list = ezSystemAdminService.getSystemConfigListPopup(searchValue, typeCode, commonUtil.getMinuteUTC(userInfo.getOffset()), startRow, pageSize, companyID, tenantID);
        
		StringBuilder result = new StringBuilder("<LISTVIEWDATA>");
		result.append("<ROWS>");
		result.append("<TOTALCNT>");
		result.append(cnt);
		result.append("</TOTALCNT>");
        
        for (int i = 0; i < list.size(); i++) {
        	SystemConfigVO vo = list.get(i);
        	
        	result.append("<ROW>");
        	result.append("<CELL>");
        	result.append("<VALUE>" + commonUtil.cleanValue(vo.getCode()) + "</VALUE>");
            result.append("<DATA1>" + commonUtil.cleanValue(vo.getCode()) + "</DATA1>");
            result.append("<DATA2>" + commonUtil.cleanValue(vo.getCodeValue()) + "</DATA2>");
            result.append("<DATA3>" + commonUtil.cleanValue(vo.getDescription()) + "</DATA3>");
            result.append("<DATA4>" + commonUtil.cleanValue(vo.getWriterid()) + "</DATA4>");
            result.append("<DATA5>" + commonUtil.cleanValue(vo.getWritername()) + "</DATA5>");
            result.append("<DATA6>" + commonUtil.cleanValue(vo.getWritedate()) + "</DATA6>");
            result.append("</CELL>");
            result.append("<CELL>");
            result.append("<VALUE>" + commonUtil.cleanValue(vo.getCode()) + "</VALUE>");
            result.append("</CELL>");
            result.append("<CELL>");
            result.append("<VALUE>" + commonUtil.cleanValue(vo.getCodeValue()) + "</VALUE>");
            result.append("</CELL>");
            result.append("<CELL>");
            result.append("<VALUE>" + commonUtil.cleanValue(vo.getDescription()) + "</VALUE>");
            result.append("</CELL>");
            result.append("<CELL>");
            result.append("<VALUE>" + commonUtil.cleanValue(vo.getWritername()) + "</VALUE>");
            result.append("</CELL>");
            result.append("<CELL>");
            result.append("<VALUE>" + commonUtil.cleanValue(vo.getWriterid()) + "</VALUE>");
            result.append("</CELL>");
            result.append("<CELL>");
            result.append("<VALUE>" + commonUtil.cleanValue(vo.getWritedate()) + "</VALUE>");
            result.append("</CELL>");
            result.append("</ROW>");
        }
        result.append("</ROWS>");
        result.append("</LISTVIEWDATA>");
        
        logger.debug("getSystemConfigListPopup ended.");
        
		return result.toString();
	}
	
	/**
	 * 시스템 SYSTEM CONFIG 메뉴 호출 함수
	 */
	@RequestMapping(value = "/admin/ezSystem/addSystemConfig.do", method = RequestMethod.GET)	
	public String addSystemConfig(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, String CODE) throws Exception{
	    logger.debug("addSystemConfig started.");
	    
	    SystemConfigVO configVO = null;
	    String sFlag = "add";
	    String companyID = request.getParameter("companyID");
	    LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
	    String useLang = commonUtil.getPrimaryData(userInfo.getLang(), userInfo.getTenantId());
		
	    //관리자 권한체크
  		LoginVO adminChk = commonUtil.checkAdmin(loginCookie);

  		if (adminChk == null) {
  			return "cmm/error/adminDenied";
  		}
	    
		if (CODE != null) {
			configVO = ezSystemAdminService.getSystemConfig(CODE, commonUtil.getMinuteUTC(userInfo.getOffset()), companyID, userInfo.getTenantId());
			sFlag = "mod";
			String mode = request.getParameter("mode");
			if (mode != null && mode.equals("view")) {
				sFlag = "view";
			}
		}
		
		List<SystemConfigTypeVO> configTypeList = ezSystemAdminService.getSystemConfigTypeListNotXml("", commonUtil.getMinuteUTC(userInfo.getOffset()), 0, 0, "ALL", companyID, userInfo.getTenantId());
		model.addAttribute("configTypeList", configTypeList);
		model.addAttribute("flag", sFlag);
		model.addAttribute("configVO", configVO);
		model.addAttribute("companyID", companyID);
		model.addAttribute("useLang", useLang);
		
		logger.debug("addSystemConfig ended.");
		
		return "/ezSystem/addSystemConfig";
	}
	
	/**
	 * 시스템 SYSTEM CONFIG 삭제 호출 함수
	 */
	@RequestMapping(value="/admin/ezSystem/deletesyStemConfig.do", method=RequestMethod.POST)
	@ResponseBody
	public String deleteSystemConfig(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, String[] CODE) throws Exception {
		logger.debug("deleteSystemConfig started");
		logger.debug("CODE=" + CODE);
		
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		// 관리자 권한 체크
		if (userInfo == null) {
			return "ERROR";
		}
		
		String result = "";
		String companyID = request.getParameter("companyID");
		
		if (CODE != null) {
			for (int i = 0; i < CODE.length; i++) {
				String sCode = CODE[i];
				try {
					ezSystemAdminService.deletesyStemConfig(sCode, companyID, userInfo.getTenantId());
					
					result = "OK";
				} catch (Exception e) { // Exception이 발생하면 취소 처리를 한다.
					logger.error(e.getMessage(), e);
					result = "ERROR";
				}
			}
		} else {
			result = "OK";
		}
		
		logger.debug("deleteSystemConfig ended");
		
		return result;
	}
	
	/**
	 * 시스템 SYSTEM CONFIG 등록/수정 호출 함수
	 */
	@RequestMapping(value="/admin/ezSystem/saveSystemConfig.do", method=RequestMethod.POST, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String saveSystemConfig(@CookieValue("loginCookie") String loginCookie,@RequestBody String data) throws Exception {
		logger.debug("saveSystemConfig started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		Document doc = commonUtil.convertStringToDocument(data);
		String flag;
		flag = doc.getElementsByTagName("FLAG").item(0).getTextContent();
		// 관리자 권한 체크
		if (userInfo == null) {
			return "ERROR";
		}
		
		String result = "";
		
		if (flag.equals("add")) {
			result = ezSystemAdminService.insertStemConfig(doc, userInfo.getId(), userInfo.getDisplayName(), userInfo.getTenantId());
		} else if (flag.equals("mod")){
			// 수정
			result = ezSystemAdminService.updateStemConfig(doc, userInfo.getId(), userInfo.getDisplayName(), userInfo.getTenantId());
		}
		
		logger.debug("saveSystemConfig ended");
		
		return result;
	}
	
	@RequestMapping(value = "/admin/ezSystem/getSystemConfigTypeList.do", method = RequestMethod.GET, produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getSystemConfigType(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, String CODE) throws Exception{
	    logger.debug("getSystemConfigType started.");
	    LoginVO userInfo = commonUtil.userInfo(loginCookie);
	    String companyID = request.getParameter("companyID");
	    
	    String searchValue = request.getParameter("searchValue");
	    String searchMode = request.getParameter("mode");
	    String systemConfigTypeList = "";
	    if (searchMode != null && searchMode.equals("ALL")) {
	    	systemConfigTypeList = ezSystemAdminService.getSystemConfigTypeList(searchValue, commonUtil.getMinuteUTC(userInfo.getOffset()), 0, 0, searchMode, userInfo.getPrimary(), companyID, userInfo.getTenantId());
	    } else {
	    	int pageNum = Integer.parseInt(request.getParameter("pageNum"));
	    	int pageSize = Integer.parseInt(request.getParameter("pageSize"));		
	    	
	    	int cnt = ezSystemAdminService.getSystemConfigTypeListCount(searchValue, companyID, userInfo.getTenantId());
	    	int totalPages  = (cnt + pageSize - 1) / pageSize;
	    	pageNum = pageNum > totalPages ? totalPages : pageNum;
	    	pageNum = pageNum == 0         ? 1          : pageNum;
	    	
	    	int startRow  = (pageNum - 1) * pageSize;
	    	searchValue = searchValue.replace("%", "\\%").replace("_", "\\_");
	    	
	    	systemConfigTypeList = ezSystemAdminService.getSystemConfigTypeList(searchValue, commonUtil.getMinuteUTC(userInfo.getOffset()), startRow, pageSize, searchMode, userInfo.getPrimary(), companyID, userInfo.getTenantId());
	    }
	    
		logger.debug("getSystemConfigType ended.");
	
		return systemConfigTypeList;
	}
	
	@RequestMapping(value = "/admin/ezSystem/editSystemConfigType.do", method = RequestMethod.GET)
	public String editSystemConfigType(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception{
		logger.debug("editSystemConfigType started.");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String companyID = request.getParameter("companyID");
		
		model.addAttribute("companyID", companyID);
		
		logger.debug("editSystemConfigType ended.");
		return "/ezSystem/editSystemConfigType";
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/admin/ezSystem/deleteSystemConfigType.do", method=RequestMethod.POST)
	@ResponseBody
	public String deleteSystemConfigType(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, @RequestBody Map<String, Object> data) throws Exception {
		logger.debug("deleteSystemConfig started");
		
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		// 관리자 권한 체크
		if (userInfo == null) {
			return "ERROR";
		}
		
		String result = "";
		List<String> typeCodes = (List<String>) data.get("typeCodes");
		String companyID = (String) data.get("companyID");
		
		for(int i = 0; i < typeCodes.size(); i++) {
			String typeCode = typeCodes.get(i);
			try {
				ezSystemAdminService.deleteSystemConfigType(typeCode, companyID, userInfo.getTenantId());
				result = "OK";
			} catch (Exception e) { // Exception이 발생하면 취소 처리를 한다.
				logger.error(e.getMessage(), e);
				result = "ERROR";
			}
		}
		
		logger.debug("deleteSystemConfig ended");
		
		return result;
	}
	
	@ResponseBody
	@RequestMapping(value="/admin/ezSystem/checkDuplicateCode.do", method=RequestMethod.GET, produces = "text/xml;charset=utf-8")
	public String checkDuplicateCode(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("checkDuplicateCode started");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String code = request.getParameter("code");
		String companyID = request.getParameter("companyID");
		String result = ezSystemAdminService.checkDuplicateCode(code, userInfo.getTenantId(), companyID);
		
		logger.debug("checkDuplicateCode ended");
		return result;
	}
	
	@RequestMapping(value = "/admin/ezSystem/addSystemConfigType.do", method = RequestMethod.GET)
	public String addSystemConfigType(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception{
		logger.debug("editSystemConfigType started.");
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		String companyID = request.getParameter("companyID");
		String typeCode = request.getParameter("typeCode");
		String flag = "";
		if (typeCode == null || typeCode.equals("")) {
			flag = "add";
		} else {
			SystemConfigTypeVO configTypeVO = ezSystemAdminService.getSystemConfigType(typeCode, commonUtil.getMinuteUTC(userInfo.getOffset()), companyID, userInfo.getTenantId());
			model.addAttribute("configTypeVO", configTypeVO);
			flag = "mod";
		}
		model.addAttribute("companyID", companyID);
		model.addAttribute("flag", flag);
		
		logger.debug("addSystemConfigType ended.");
		return "/ezSystem/addSystemConfigType";
	}
	
	@ResponseBody
	@RequestMapping(value="/admin/ezSystem/checkDuplicateTypeCode.do", method=RequestMethod.GET, produces = "text/xml;charset=utf-8")
	public String checkDuplicateTypeCode(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("checkDuplicateTypeCode started");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String typeCode = request.getParameter("typeCode");
		String companyID = request.getParameter("companyID");
		String result = ezSystemAdminService.checkDuplicateTypeCode(typeCode, userInfo.getTenantId(), companyID);
		
		logger.debug("checkDuplicateTypeCode ended");
		return result;
	}
	
	@RequestMapping(value="/admin/ezSystem/saveSystemConfigTypeCode.do", method=RequestMethod.POST, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String saveSystemConfigTypeCode(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, SystemConfigTypeVO data) throws Exception {
		logger.debug("saveSystemConfigTypeCode started");
		
		String result = "";
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		// 관리자 권한 체크
		if (userInfo == null) {
			return "ERROR";
		}
		String flag = request.getParameter("flag");
		String companyID = request.getParameter("companyID");
		String typeCode = request.getParameter("typeCode");
		String typeName = request.getParameter("typeName");
		String typeName2 = request.getParameter("typeName2");
		String description = request.getParameter("description");
		
		if (flag.equals("add")) {
			ezSystemAdminService.insertSystemConfigType(typeCode, typeName, typeName2, description, userInfo.getId(), userInfo.getDisplayName(), userInfo.getDisplayName2(), userInfo.getTenantId(), companyID);
		} else {
			// 수정
			ezSystemAdminService.updateSystemConfigType(typeCode, typeName, typeName2, description, userInfo.getId(), userInfo.getDisplayName(), userInfo.getDisplayName2(), userInfo.getTenantId(), companyID);
		}
		
		result = "OK";
		logger.debug("saveSystemConfigTypeCode ended");
		
		return result;
	}
	
	@RequestMapping(value="/admin/ezSystem/disableDeleteSystemConfig.do", method=RequestMethod.POST)
	@ResponseBody
	public String disableDeleteSystemConfig(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, String[] CODE) throws Exception {
		logger.debug("disableDeleteSystemConfig started");
		logger.debug("CODE=" + CODE);
		
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		// 관리자 권한 체크
		if (userInfo == null) {
			return "ERROR";
		}
		
		String result = "";
		String companyID = request.getParameter("companyID");
		
		for(int i=0; i < CODE.length; i++) {
			String sCode = CODE[i];
			try {
				ezSystemAdminService.disableDeleteSystemConfig(sCode, companyID, userInfo.getTenantId());
				
				result = "OK";
			} catch (Exception e) { // Exception이 발생하면 취소 처리를 한다.
				logger.error(e.getMessage(), e);
				result = "ERROR";
			}
		}
		
		logger.debug("disableDeleteSystemConfig ended");
		
		return result;
	}

	//FIDO인증관리 메인 호출	
	@RequestMapping(value="/admin/ezSystem/fidoAuthenticationManager.do", method=RequestMethod.GET)
	public String fidoAuthenticationManager(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("fidoAuthenticationManager started");

		//관리자 권한체크
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}

		int tenantId = userInfo.getTenantId();
		String companyId = userInfo.getCompanyID();
		String rollInfo = userInfo.getRollInfo();
		boolean adminChk = rollInfo.indexOf("c=1") > -1;

		List<OrganDeptVO> list = ezOrganAdminService.getCompanyList(userInfo.getPrimary(), tenantId);
		List<OrganDeptVO> resultList = new ArrayList<>();

		int j = 0;
		boolean isMasterAdmin = userInfo.getRollInfo().contains("c=1");

		for (OrganDeptVO vo : list) {
			if (isMasterAdmin || vo.getCn().equals(companyId)) {
				resultList.add(j++, vo);
			}
		}

		model.addAttribute("adminChk", adminChk);
		model.addAttribute("list", resultList);
		model.addAttribute("companyId", companyId);

		logger.debug("fidoAuthenticationManager ended");

		return "/ezSystem/systemFidoManager";
	}

	//FIDO인증관리 사용여부
	@ResponseBody
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/ezSystem/getFidoUseConfig.do", method=RequestMethod.POST)
	public String getFidoUseConfig(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getFidoUseConfig started");

		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		String companyId = request.getParameter("companyID");

		String result = ezCommonService.getCompanyConfig(userInfo.getTenantId(), companyId, "useFidoSession");

		logger.debug("getFidoUseConfig ended");
		return result;
	}

	//FIDO인증관리 사용여부 설정 변경
	@ResponseBody
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/ezSystem/setFidoUseConfig.do", method=RequestMethod.POST)
	public String setFidoUseConfig(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("setFidoUseConfig started");

		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		String companyId = request.getParameter("companyID");
		String propertyValue = request.getParameter("propertyValue");

		String result = ezCommonService.getCompanyConfig(userInfo.getTenantId(), companyId, "useFidoSession");

		if (StringUtils.isNotEmpty(propertyValue)) {
			if (StringUtils.isNotEmpty(result)){
				ezCommonService.updateCompanyConfig(userInfo.getTenantId(), companyId, "useFidoSession", propertyValue);
			} else {
				ezCommonService.insertCompanyConfig(userInfo.getTenantId(), companyId, "useFidoSession", propertyValue);
			}
		}

		logger.debug("setFidoUseConfig ended");
		return result;
	}

	//FIDO인증관리 IP리스트 화면
	@RequestMapping(value="/ezSystem/systemFidoIPBand.do", method=RequestMethod.GET)
	public String systemFidoIPBand(@CookieValue("loginCookie") String loginCookie, Model model, @RequestParam String companyId) throws Exception {
		logger.debug("systemAdminIPBand started");

		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);

		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}

		companyId = Optional.ofNullable(companyId).orElseGet(() -> userInfo.getCompanyID());

		model.addAttribute("companyId", companyId);

		logger.debug("systemFidoIPBand ended");
		return "/ezSystem/systemFidoIPBand";
	}
	
	//FIDO인증관리 IP리스트
	@ResponseBody
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/ezSystem/getfidoIPBandList.do", method=RequestMethod.POST)
	public ResponseEntity<JSONArray> getfidoIPBandList(@CookieValue("loginCookie") String loginCookie, @RequestBody Map<String, Object> paramMap) throws Exception {
		logger.debug("getfidoIPBandList started");

		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);

		if (userInfo == null) {
			logger.debug("getfidoIPBandList accessDenied");

			return ResponseEntity.status(HttpStatus.FORBIDDEN).body(new JSONArray());
		}

		int tenantId = userInfo.getTenantId();
		String companyId = Optional.ofNullable(paramMap.get("companyId").toString()).orElseGet(() -> userInfo.getCompanyID()); // 선택된 회사

		List<IPBandVO> ipList = ezSystemAdminService.getFidoAuthenticList(tenantId, companyId);

		if (ipList == null) {
			return null;
		}

		JSONArray returnJsonArr = new JSONArray();

		for (IPBandVO ipVo : ipList) {
			JSONObject obj = new JSONObject();

			obj.put("ipNo", ipVo.getIpNo());
			obj.put("ipAddress", ipVo.getIpAddress());
			obj.put("access", ipVo.getAccess());
			obj.put("explanation", ipVo.getExplanation());

			returnJsonArr.add(obj);
		}

		logger.debug("returnJsonArr=" + returnJsonArr.toJSONString());
		logger.debug("getfidoIPBandList ended");
		return ResponseEntity.ok().body(returnJsonArr);
	}

	// FIDO인증관리 IP제한 - ip 추가
	@ResponseBody
	@RequestMapping(value="/ezSystem/insertFidoIPBand.do", method=RequestMethod.POST)
	public ResponseEntity<Void> insertFidoIPBand(@CookieValue("loginCookie") String loginCookie, @ModelAttribute IPBandVO ipBand) throws Exception {
		logger.debug("insertFidoIPBand started");

		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);

		if (userInfo == null) {
			logger.debug("insertFidoIPBand accessDenied");

			return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
		}

		String ipBandExplaination = ipBand.getExplanation() == null ? "" : ipBand.getExplanation();

		ezSystemAdminService.insertFidoIPBand(userInfo.getTenantId(), ipBand.getCompanyId(), ipBand.getIpAddress(), ipBand.getAccess(), ipBandExplaination);

		logger.debug("insertFidoIPBand ended");
		return ResponseEntity.noContent().build();
	}
	
	// FIDO인증관리 IP제한 - ip 수정
	@ResponseBody
	@RequestMapping(value="/ezSystem/updateFidoIPBand.do", method=RequestMethod.POST)
	public void updateFidoIPBand(@ModelAttribute IPBandVO ipBand) throws Exception {
		logger.debug("updateFidoIPBand started");
		logger.debug("ipNo=" + ipBand.getIpNo() + ", ipAddress=" + ipBand.getIpAddress() + ", explanation=" + ipBand.getExplanation());

		ezSystemAdminService.updateFidoIPBand(ipBand.getIpNo(), ipBand.getIpAddress(), ipBand.getAccess(), ipBand.getExplanation());

		logger.debug("updateFidoIPBand ended");
	}

	// FIDO인증관리 IP제한 - ip 삭제
	@ResponseBody
	@RequestMapping(value="/ezSystem/deleteFidoIPBand.do", method=RequestMethod.POST)
	public void deleteFidoIPBand(String ipNo) throws Exception {
		logger.debug("deleteFidoIPBand started");
		logger.debug("ipNo=" + ipNo);

		ezSystemAdminService.deleteFidoIPBand(ipNo);

		logger.debug("deleteFidoIPBand ended");
	}
	
}
