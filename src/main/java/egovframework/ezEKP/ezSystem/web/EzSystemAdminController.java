package egovframework.ezEKP.ezSystem.web;

import java.net.InetAddress;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
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

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.vo.MailLetterBoxVO;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.ezEKP.ezSystem.service.EzSystemAdminService;
import egovframework.ezEKP.ezSystem.util.EzSystemUtil;
import egovframework.ezEKP.ezSystem.vo.AccessIdVO;
import egovframework.ezEKP.ezSystem.vo.ConnectionInfoVO;
import egovframework.ezEKP.ezSystem.vo.IPBandVO;
import egovframework.ezEKP.ezSystem.vo.SysParamVO;
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
	
	@Resource
	private EgovMessageSource egovMessageSource;
    
	@RequestMapping(value="/admin/ezSystem/systemMain.do")
	public String systemMain(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception{
		//관리자 권한체크
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		return "/ezSystem/systemMain";
	}

	
	@RequestMapping(value="/admin/ezSystem/systemLeftMenu.do")
	public String systemLeftMenu(Model model) throws Exception {
		
		return "/ezSystem/systemLeftMenu";
	}
	
	@RequestMapping(value="/admin/ezSystem/systemMainMenu.do")
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
		int licensedUserCount = 0;
		
		for (SysParamVO param : configList) {
			configMap.put(param.getName(), param.getValue());
			
			if (param.getName().equals("LicenseKey")) {
				String licenseKey = param.getValue();
				
				if (licenseKey != null && !licenseKey.equals("")) {
					try {
						// 라이센스키를 복호화한다.
						licenseKey = egovFileScrty.decryptAES(licenseKey);
						
						String items[] = licenseKey.split(":");
						
						if (items.length >= 2) {
							licensedUserCount = Integer.parseInt(items[1]);
						}						
					} catch (Exception e) {
					}					
				}
			}
		}
		
		int userCount = ezOrganAdminService.getUserCount(userInfo.getTenantId());
		
		// masteradmin 사용자를 제외하기 위해 1을 뺀다.
		userCount--;
		
		String dotNetIntegration = ezCommonService.getTenantConfig("dotNetIntegration", userInfo.getTenantId());
		boolean isDotNetAdmin = false;
		
		if (dotNetIntegration.equals("YES")) {
			if (userInfo.getRollInfo().indexOf("c=1") != -1 || userInfo.getRollInfo().indexOf("k=1") != -1) {
				isDotNetAdmin = true;
			}			
		}
		
		List<String> defaultFontFamilyList = Arrays.asList(egovMessageSource.getMessage("main.t0620", Locale.KOREA).split(";"));
		List<String> defaultFontSizeList = Arrays.asList("8px,9px,10px,11px,12px,13px,14px,16px,18px,20px,24px,30px,36px,54px,72px".split(","));
		String useAllUserOldMailDelete = ezCommonService.getTenantConfig("useAllUserOldMailDelete", userInfo.getTenantId());
		String useAllUserOldMailDeletePeriod = ezCommonService.getTenantConfig("useAllUserOldMailDeletePeriod", userInfo.getTenantId());
		
		model.addAttribute("configMap", configMap);
		model.addAttribute("licensedUserCount", licensedUserCount);
		model.addAttribute("userCount", userCount);
		model.addAttribute("isDotNetAdmin", isDotNetAdmin);
		model.addAttribute("defaultFontFamilyList", defaultFontFamilyList);
		model.addAttribute("defaultFontSizeList", defaultFontSizeList);
		model.addAttribute("useAllUserOldMailDelete", useAllUserOldMailDelete);
		model.addAttribute("useAllUserOldMailDeletePeriod", useAllUserOldMailDeletePeriod);
		
		logger.debug("systemMainMenu ended");
		
		return "/ezSystem/systemMainMenu";
	}
		
	@RequestMapping(value="/admin/ezSystem/updateSysParam.do", produces="application/json;charset=utf-8")
	@ResponseBody
	public String updateSysParam(@CookieValue("loginCookie") String loginCookie, Model model, @RequestBody List<Map<String, String>> list) throws Exception {
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "{\"msg\":\"fail\"}";
		}
		
		try {
			ezSystemAdminService.updateSysParam(userInfo.getTenantId(), list, userInfo.getLocale());
		} catch (Exception e) {
			return "{\"msg\":\"fail\"}";			
		}
		
		return "{\"msg\":\"success\"}";		
	}
	
	/**
	 * 로그인 로그내역 메인 호출
	 */
	@RequestMapping(value="/admin/ezSystem/systemLoginHist.do")
	public String systemLoginHist(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model) throws Exception {
		
		logger.debug("started systemLoginHistMain controller.");
		
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		String LoginMailLogKeepPeriod = ezCommonService.getTenantConfig("LoginMailLogKeepPeriod", userInfo.getTenantId());
		LoginMailLogKeepPeriod = LoginMailLogKeepPeriod.equals("") ? "3" : LoginMailLogKeepPeriod;
		
		String mailLogKeepPeriodMessage = egovMessageSource.getMessage("ezStatistics.t1065", locale);
		mailLogKeepPeriodMessage = String.format(mailLogKeepPeriodMessage, LoginMailLogKeepPeriod);
		
		model.addAttribute("mailLogKeepPeriodMessage", mailLogKeepPeriodMessage);
		
		logger.debug("ended systemLoginHistMain controller.");
		
		return "/ezSystem/systemLoginHist";
		
	}
	
	/**
	 * 로그인 로그내역 데이터 리스트 호출
	 */
	@RequestMapping(value="/admin/ezSystem/systemLoginHistList.do")
	public String systemLoginHistList(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest req,
			@RequestParam(required=false)String searchKeycode, @RequestParam(required=false)String searchKeyword,
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
		int startRow = (Integer.parseInt(currPage) - 1) * maxItemPerPage;
		
		if (currPage.equals("-1")) {
			startRow = -1;
		}

		String sysLang = ezCommonService.getTenantConfig("PrimaryLang", userInfo.getTenantId());

		if (userInfo.getLang().equals(sysLang))  {
			sysLang = "primary";
		}
		
		List<ConnectionInfoVO> loginHistList = ezSystemAdminService.getLoginHist(Integer.valueOf(userInfo.getTenantId()), 
				commonUtil.getMinuteUTC(offset), startRow, maxItemPerPage, searchKeycode, searchKeyword, sysLang, startDate, endDate);
		int itemCnt = ezSystemAdminService.getLoginHistCount(userInfo.getTenantId(), commonUtil.getMinuteUTC(offset), searchKeycode, searchKeyword, sysLang, startDate, endDate);
		
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
		model.addAttribute("startDate", startDate);
		model.addAttribute("endDate", endDate);
		
		logger.debug("ended systemLoginHistList controller.");
		
		return "json";
	}
	
	/*
	 * 엑셀 워크시트 생성 및 자동 다운로드 함수
	 */
	@SuppressWarnings("static-access")
	@RequestMapping(value = "/admin/ezSystem/systemLoginHistExcelExport.do")
	public void statisticsMailLogExcelExport(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request,
			String searchKeycode, String searchKeyword, String startDate, String endDate, Locale locale, HttpServletResponse response)  throws Exception {
		logger.debug("systemLoginHistExcelExport controller started.");
		
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		String offset = userInfo.getOffset();
		String currPage = request.getParameter("pageNum");
		
		int maxItemPerPage = 20; 
		int startRow = (Integer.parseInt(currPage) - 1) * maxItemPerPage;
		
		if (currPage.equals("-1")) {
			startRow = -1;
		}

		String sysLang = ezCommonService.getTenantConfig("PrimaryLang", userInfo.getTenantId());

		if (userInfo.getLang().equals(sysLang))  {
			sysLang = "primary";
		}
		
		List<ConnectionInfoVO> loginHistList = ezSystemAdminService.getLoginHist(Integer.valueOf(userInfo.getTenantId()), 
				commonUtil.getMinuteUTC(offset), startRow, maxItemPerPage, searchKeycode, searchKeyword, sysLang, startDate, endDate);
		int totalCount = ezSystemAdminService.getLoginHistCount(userInfo.getTenantId(), commonUtil.getMinuteUTC(offset), searchKeycode, searchKeyword, sysLang, startDate, endDate);
		
		/* 엑셀 만들기 */
		HSSFWorkbook workbook = new HSSFWorkbook();
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
		font.setBoldweight((short)font.BOLDWEIGHT_BOLD);
		headerStyle.setFont(font);
		
		row = sheet.createRow(0);
		cell = row.createCell(0);	
		cell.setCellValue(egovMessageSource.getMessage("ezSystem.x0032", locale) + " : " + startDate + " ~ " + endDate);
		cell = row.createCell(5);
		cell.setCellValue(egovMessageSource.getMessage("main.t252", locale) + " " + totalCount + egovMessageSource.getMessage("ezSystem.kyj2", locale));
		
		row = sheet.createRow(1);
		cell = row.createCell(0);	cell.setCellValue(egovMessageSource.getMessage("ezSystem.x0022", locale)); 
		cell.setCellStyle(headerStyle);
		cell = row.createCell(1);	cell.setCellValue(egovMessageSource.getMessage("ezSystem.x0023", locale)); 
		cell.setCellStyle(headerStyle);
		cell = row.createCell(2);	cell.setCellValue(egovMessageSource.getMessage("ezSystem.x0024", locale)); 
		cell.setCellStyle(headerStyle);
		cell = row.createCell(3);	cell.setCellValue(egovMessageSource.getMessage("ezSystem.x0025", locale)); 
		cell.setCellStyle(headerStyle);
		cell = row.createCell(4);	cell.setCellValue(egovMessageSource.getMessage("ezSystem.x0026", locale)); 
		cell.setCellStyle(headerStyle);
		cell = row.createCell(5);	cell.setCellValue(egovMessageSource.getMessage("ezSystem.x0027", locale)); 
		cell.setCellStyle(headerStyle);
		
		for (int i = 2; i < totalCount + 2; i++) {
			row = sheet.createRow(i);
			row.setHeight((short)300);
			int j = 2;
			
			if (sysLang.equals("primary")) {
				cell = row.createCell(0); cell.setCellValue((String) loginHistList.get(i-j).getUsernm());
				cell.setCellStyle(bodyStyle);
				cell = row.createCell(1); cell.setCellValue((String) loginHistList.get(i-j).getDeptnm());
				cell.setCellStyle(bodyStyle);
			} else {
				cell = row.createCell(0); cell.setCellValue((String) loginHistList.get(i-j).getUsernm2());
				cell.setCellStyle(bodyStyle);
				cell = row.createCell(1); cell.setCellValue((String) loginHistList.get(i-j).getDeptnm2());
				cell.setCellStyle(bodyStyle);
			}
			
			cell = row.createCell(2); cell.setCellValue((String) loginHistList.get(i-j).getConnectip());
			cell.setCellStyle(bodyStyle);
			cell = row.createCell(3); cell.setCellValue((String) loginHistList.get(i-j).getConnecttime());
			cell.setCellStyle(bodyStyle);
			cell = row.createCell(4); cell.setCellValue((String) loginHistList.get(i-j).getConnectbrowser());
			cell.setCellStyle(bodyStyle);
			cell = row.createCell(5); cell.setCellValue((String) loginHistList.get(i-j).getConnectos());
			cell.setCellStyle(bodyStyle);
			
			sheet.autoSizeColumn(i-1);
		}
		
		response.setCharacterEncoding("UTF-8");
		response.setHeader("Content-Disposition", "attachment; fileName=" + fileName + ".xls");
		response.setContentType("application/vnd.ms-excel");
		
		workbook.write(response.getOutputStream());
		workbook.close();
		
		logger.debug("systemLoginHistExcelExport controller ended.");
	}	
	
	/**
	 * 전체 서버 목록 가져오기.
	 * config.properties에 현재 포함 다른 서버 목록 전부 저장
	 * */
	@RequestMapping(value="/admin/ezSystem/sysREST.do")
	public String sysREST(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request , Model model) throws Exception {
		logger.debug("sysREST started.");
		
		//관리자 권한 체크
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
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
	@RequestMapping(value="/admin/ezSystem/sysMonitorREST.do")
	public String sysMonitorREST(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		logger.debug("sysMonitorREST started.");
		logger.debug("<<<serverSN : " + request.getParameter("serverSN"));
		
		//관리자 권한체크
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);	
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
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
	
	// 이하 재은 수정중
	@RequestMapping(value="/admin/ezSystem/systemIPManager.do")
	public String systemIPManager(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("systemIPManager started");
		
		//관리자 권한체크
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		logger.debug("systemIPManager ended");
		 
		return "/ezSystem/systemIPManager";
	}
	
	@RequestMapping(value="/ezSystem/systemIPBand.do")
	public String systemIPBand(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("systemIPBand started");
		
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		String useIPAccess = ezCommonService.getTenantConfig("useIPAccess", userInfo.getTenantId());
		
		if (useIPAccess == null || useIPAccess.equals("")) {
			useIPAccess = "NO"; // 기본값은 사용안함
		}
		
		List<OrganDeptVO> list = ezOrganAdminService.getCompanyList(userInfo.getPrimary(), userInfo.getTenantId());
		List<OrganDeptVO> resultList = new ArrayList<OrganDeptVO>();

		for (int i = 0; i < list.size(); i++) {
			OrganDeptVO vo = list.get(i);

			if (userInfo.getRollInfo().contains("c=1") || (userInfo.getRollInfo().contains("k=1") && vo.getCn().equals(userInfo.getCompanyID()))) {
				resultList.add(vo);
			}

		}
		
				
		model.addAttribute("useIPAccess", useIPAccess);
		model.addAttribute("rollInfo", userInfo.getRollInfo());
		
		logger.debug("systemIPBand ended");
		return "/ezSystem/systemIPBand";
	}
	
	@RequestMapping(value="/ezSystem/setUseIPAccess.do")
	public String setUseIPAccess(@CookieValue("loginCookie") String loginCookie, Model model, String allowResult) throws Exception {
		logger.debug("setUseIPAccess started");
		
		// input 체크된 값으로 전달되기 때문에 tbl_tenant_config value에 맞게 변경
		if (allowResult.equals("true")) {
			allowResult = "YES";
		} else {
			allowResult = "NO";
		}
		
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		ezSystemAdminService.updateSystemIPAllow(allowResult, userInfo.getTenantId());
		
		logger.debug("setUseIPAccess ended");
		return "/ezSystem/systemIPBand";
	}
	
	@ResponseBody
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/ezSystem/getAllIPBands.do")
	public JSONArray getAllIPBands(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("setUseIPAccess started");
		
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
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
		return returnJsonArr;
	}
	
	@ResponseBody
	@RequestMapping(value="/ezSystem/insertIPBand.do")
	public void insertIPBand(@CookieValue("loginCookie") String loginCookie, Model model, @ModelAttribute IPBandVO ipBand) throws Exception {
		logger.debug("insertIPBand started");
		
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		ezSystemAdminService.insertIPBand(userInfo.getTenantId(), ipBand.getIpAddress(), ipBand.getAccess(), ipBand.getExplanation() == null ? "" : ipBand.getExplanation());
		
		logger.debug("insertIPBand ended");
	}
	
	@ResponseBody
	@RequestMapping(value="/ezSystem/updateIPBand.do")
	public void updateIPBand(@CookieValue("loginCookie") String loginCookie, Model model, @ModelAttribute IPBandVO ipBand) throws Exception {
		logger.debug("updateIPBand started");
		logger.debug("ipNo=" + ipBand.getIpNo() + ", ipAddress=" + ipBand.getIpAddress() + ", access=" + ipBand.getAccess() + ", explanation=" + ipBand.getExplanation());
		
		ezSystemAdminService.updateIPBand(ipBand.getIpNo(), ipBand.getIpAddress(), ipBand.getAccess(), ipBand.getExplanation());
		
		logger.debug("updateIPBand ended");
	}
	
	@ResponseBody
	@RequestMapping(value="/ezSystem/deleteIPBand.do")
	public void deleteIPBand(@CookieValue("loginCookie") String loginCookie, Model model, String ipNo) throws Exception {
		logger.debug("deleteIPBand started");
		logger.debug("ipNo=" + ipNo);
		
		ezSystemAdminService.deleteIPBand(ipNo);
		
		logger.debug("deleteIPBand ended");
	}
	
	
	@RequestMapping(value="/ezSystem/systemIPBandEditPopup.do")
	public String systemIPBandEditPopup(@CookieValue("loginCookie") String loginCookie, Model model, String type, @ModelAttribute IPBandVO ipBand) throws Exception {
		logger.debug("systemIPBandEditPopup started");
		
		String ipAddress = "";
		String access = "";
		String explanation = "";
		
		if (type.equals("modify")) {
			IPBandVO getIPBand = ezSystemAdminService.getSystemIPBand(ipBand.getIpNo());
			
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
				
		logger.debug("systemIPBandEditPopup ended");
		return "/ezSystem/systemIPBandEditPopup";
	}
	 
	
	
	@RequestMapping(value="/ezSystem/systemIPAccessList.do")
	public String systemIPAccessList(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("systemIPAccessList started");
		
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
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
	@RequestMapping(value="/ezSystem/getAllAccessList.do")
	public JSONArray getAllAccessList(@CookieValue("loginCookie") String loginCookie, Model model, String companyID) throws Exception {
		logger.debug("getAllAccessList started");
		
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		List<AccessIdVO> userList = ezSystemAdminService.getAllAccessList(userInfo.getPrimary(), userInfo.getTenantId(), companyID);
		List<AccessIdVO> deptList = ezSystemAdminService.getAllAccessListDept(userInfo.getPrimary(), userInfo.getTenantId(), companyID);
		JSONArray returnJsonArr = new JSONArray();
		
		for (int i = 0; i < userList.size(); i++) {
			JSONObject obj = new JSONObject();
			obj.put("accessNo", userList.get(i).getAccessNo());
			obj.put("cn", userList.get(i).getCn());
			obj.put("department", userList.get(i).getDepartment());
			returnJsonArr.add(obj);
		}
		
		for (int i = 0; i < deptList.size(); i++) {
			JSONObject obj = new JSONObject();
			obj.put("accessNo", deptList.get(i).getAccessNo());
			obj.put("cn", deptList.get(i).getCn());
			obj.put("department", deptList.get(i).getDepartment());
			returnJsonArr.add(obj);
		}
		
		
		logger.debug("returnJsonArr=" + returnJsonArr.toJSONString());
		logger.debug("getAllAccessList ended");
		
		return returnJsonArr;
	}
	
	@SuppressWarnings("unchecked")
	@ResponseBody
	@RequestMapping(value="/ezSystem/getAllAccessListCom.do")
	public JSONArray getAllAccessListCom(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("getAllAccessListCom started");
		
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		List<String> allList = ezSystemAdminService.getAllAccessListCom(userInfo.getTenantId());
		JSONArray returnJsonArr = new JSONArray();
		
		for (int i = 0; i < allList.size(); i++) {
			JSONObject obj = new JSONObject();
			obj.put("cn", allList.get(i));
			returnJsonArr.add(obj);
		}
		
		
		logger.debug("returnJsonArr=" + returnJsonArr.toJSONString());
		logger.debug("getAllAccessListCom ended");
		
		return returnJsonArr;
	}
	
	
	
	@ResponseBody
	@RequestMapping(value="/ezSystem/insertAccessId")
	public void insertAccessId(@CookieValue("loginCookie") String loginCookie, Model model, String strCnList) throws Exception {
		logger.debug("insertAccessId started");
		
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		ezSystemAdminService.insertAccessId(userInfo.getTenantId(), strCnList);
		logger.debug("insertAccessId ended");
	}
	
	@ResponseBody
	@RequestMapping(value="/ezSystem/deleteAccessList.do")
	public void deleteAccessList(@CookieValue("loginCookie") String loginCookie, Model model, String accessNo) throws Exception {
		logger.debug("deleteAccessList started. accessNo=" + accessNo);
		
		ezSystemAdminService.deleteAccessId(accessNo);
		
		logger.debug("deleteAccessList ended");
	}
	
	@RequestMapping(value="/ezSystem/systemAddAccessList.do")
	public String systemAddAccessList(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("systemAddAccessList started");
		
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		String topID = userInfo.getCompanyID();
		
		if (userInfo.getRollInfo().indexOf("c=1") != -1) {
			topID = "Top";
		}
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("topID", topID);
		logger.debug("systemAddAccessList ended");
		return "/ezSystem/systemAddAccessList";
	}
	
	

}
