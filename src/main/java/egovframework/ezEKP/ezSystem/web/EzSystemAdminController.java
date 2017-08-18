package egovframework.ezEKP.ezSystem.web;

import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

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
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezStatistics.web.EzStatisticsMailMainController;
import egovframework.ezEKP.ezSystem.service.EzSystemAdminService;
import egovframework.ezEKP.ezSystem.vo.ConnectionInfoVO;
import egovframework.ezEKP.ezSystem.vo.SysParamVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

@Controller
public class EzSystemAdminController {

	private static final Logger logger = LoggerFactory.getLogger(EzStatisticsMailMainController.class);
	
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
		
		model.addAttribute("configMap", configMap);
		model.addAttribute("licensedUserCount", licensedUserCount);
		model.addAttribute("userCount", userCount);
		
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

		if ( userInfo.getLang().equals(sysLang))  {
			sysLang = userInfo.getLang();
		}
		
		List<ConnectionInfoVO> loginHistList = ezSystemAdminService.getLoginHist(Integer.valueOf(userInfo.getTenantId()), 
				commonUtil.getMinuteUTC(offset), startRow, maxItemPerPage, searchKeycode, searchKeyword, sysLang, startDate, endDate);
		
		int itemCnt = ezSystemAdminService.getLoginHistCount(userInfo.getTenantId(), commonUtil.getMinuteUTC(offset), searchKeycode, searchKeyword, sysLang, startDate, endDate);
		int totalPage = itemCnt / maxItemPerPage ;
		
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
	
	/**
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

		if ( userInfo.getLang().equals(sysLang))  {
			sysLang = userInfo.getLang();
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
		
		for (int i = 1; i < totalCount + 1; i++) {
			row = sheet.createRow(i);
			row.setHeight((short)300);
			
			if (sysLang.equals("1")) {
				cell = row.createCell(0); cell.setCellValue((String) loginHistList.get(i-1).getUsernm()); 
				cell.setCellStyle(bodyStyle);
				cell = row.createCell(1); cell.setCellValue((String) loginHistList.get(i-1).getDeptnm()); 
				cell.setCellStyle(bodyStyle);
			} else {
				cell = row.createCell(0); cell.setCellValue((String) loginHistList.get(i-1).getUsernm2()); 
				cell.setCellStyle(bodyStyle);
				cell = row.createCell(1); cell.setCellValue((String) loginHistList.get(i-1).getDeptnm2()); 
				cell.setCellStyle(bodyStyle);
			}
			
			cell = row.createCell(2); cell.setCellValue((String) loginHistList.get(i-1).getConnectip()); 
			cell.setCellStyle(bodyStyle);
			cell = row.createCell(3); cell.setCellValue((String) loginHistList.get(i-1).getConnecttime());
			cell.setCellStyle(bodyStyle);
			cell = row.createCell(4); cell.setCellValue((String) loginHistList.get(i-1).getConnectbrowser());
			cell.setCellStyle(bodyStyle);
			cell = row.createCell(5); cell.setCellValue((String) loginHistList.get(i-1).getConnectos());
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
	
}
