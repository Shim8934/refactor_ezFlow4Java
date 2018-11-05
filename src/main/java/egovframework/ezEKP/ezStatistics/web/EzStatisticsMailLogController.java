
package egovframework.ezEKP.ezStatistics.web;

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
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.ss.util.Region;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.util.EzEmailUtil;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.ezEKP.ezStatistics.service.EzStatisticsAdminService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

/** 
 * @Description [Controller] 메일 수발신 로그내역
 * @author 오픈솔루션팀 김유진
 * @Modification Information
 *
 *    수정일        		수정자             수정내용
 *    ----------    ------    -------------------
 *    2017.07.18    김유진             신규작성
 *    2017.07.19    김유진             엑셀 내려받기 함수 구현 
 *
 * @see
 */

@Controller
public class EzStatisticsMailLogController {

	private static final Logger logger = LoggerFactory.getLogger(EzStatisticsMailLogController.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private EzEmailUtil ezEmailUtil;
	
	@Autowired
	private Properties config;
	
	@Autowired
	private EzStatisticsAdminService ezStatisticsAdminService;
	
	@Autowired
	private EzOrganAdminService ezOrganAdminService;
	
	@Autowired
	private EzCommonService ezCommonService;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	/**
	 * 메일 수신 내역 메인 호출 
	 */
	@RequestMapping(value = "/ezStatistics/statisticsMailRecieveLogList.do")
	public String getStatMailRecieveLogMain(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model)throws Exception {
		logger.debug("getStatMailRecieveLogMain started.");
		
		// 관리자 로그인 체크
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie); 
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		String LoginMailLogKeepPeriod = ezCommonService.getTenantConfig("LoginMailLogKeepPeriod", userInfo.getTenantId());
		LoginMailLogKeepPeriod = LoginMailLogKeepPeriod.equals("") ? "3" : LoginMailLogKeepPeriod;
		
		String mailLogKeepPeriodMessage = egovMessageSource.getMessage("ezStatistics.t1065", locale);
		mailLogKeepPeriodMessage = String.format(mailLogKeepPeriodMessage, LoginMailLogKeepPeriod);
		
		model.addAttribute("mailLogKeepPeriodMessage", mailLogKeepPeriodMessage);
		
		logger.debug("getStatMailRecieveLogMain ended.");
		
		return "/ezStatistics/statisticsMailRecieveLog";
	}
	
	/**
	 * 메일 발신 내역 메인 호출
	 */
	@RequestMapping(value = "/ezStatistics/statisticsMailSendLogList.do")
	public String getStatMailSendLogMain(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model) throws Exception {
		logger.debug("getStatMailSendLogMain started.");
		
		// 관리자 로그인 체크
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie); 
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		String LoginMailLogKeepPeriod = ezCommonService.getTenantConfig("LoginMailLogKeepPeriod", userInfo.getTenantId());
		LoginMailLogKeepPeriod = LoginMailLogKeepPeriod.equals("") ? "3" : LoginMailLogKeepPeriod;
		
		String mailLogKeepPeriodMessage = egovMessageSource.getMessage("ezStatistics.t1065", locale);
		mailLogKeepPeriodMessage = String.format(mailLogKeepPeriodMessage, LoginMailLogKeepPeriod);
		
		model.addAttribute("mailLogKeepPeriodMessage", mailLogKeepPeriodMessage);
		
		logger.debug("getStatMailSendLogMain ended.");
		
		return "/ezStatistics/statisticsMailSendLog";
	}

	
	/**
	 * 메일 수발신 데이터 리스트 호출
	 */
	@RequestMapping(value = "/ezStatistics/statisticsMailLogList.do")
	public String getStatMailLogList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		
		logger.debug("getStatMailLogList controller started.");
		// 관리자 로그인 체크
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie); 
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		String tenantId = String.valueOf(userInfo.getTenantId()); 
		String pageNo = request.getParameter("pageNo");
		int pageSize = 20;
		
		int currentPage = Integer.parseInt(pageNo);
		
		if ( Integer.valueOf(pageNo) != -1 ) {
			pageNo = String.valueOf((Integer.parseInt(pageNo) -1) * pageSize);
		}
		
		String mailLogType = request.getParameter("mailLogType");
		String searchStartTime = request.getParameter("searchStartTime")  + "00:00:00";
		String searchEndTime = request.getParameter("searchEndTime") + "23:59:59";
		String searchField = request.getParameter("searchField");
		String searchValue = request.getParameter("searchValue");
		String isPrimaryLang = "2";
		String sysLang = ezCommonService.getTenantConfig("PrimaryLang", userInfo.getTenantId());
		String startDate = request.getParameter("searchStartTime");
		String endDate = request.getParameter("searchEndTime");
		
		
		if (!searchStartTime.isEmpty()) {
			searchStartTime = searchStartTime.replaceAll("[^0-9]", "");
		}
		
		if (!searchEndTime.isEmpty()) {
			searchEndTime = searchEndTime.replaceAll("[^0-9]", "");
		}

		if (sysLang.equals(userInfo.getLang())) {
			isPrimaryLang = sysLang;
		} else { 
			isPrimaryLang = userInfo.getLang();
		}

		Map<String, Object> resultMap = ezStatisticsAdminService.getMailLogList(tenantId, pageNo, String.valueOf(pageSize), 
				mailLogType, searchStartTime, searchEndTime, searchField, searchValue, isPrimaryLang);
		
		@SuppressWarnings("unchecked")
		List<Map<String, Object>> mailLogList = (List<Map<String, Object>>) resultMap.get("mailLogList");
		
		String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
		String companyDomainName = ezCommonService.getCompanyConfig(userInfo.getTenantId(), userInfo.getCompanyID(), "DomainName");
		
		// 회사별 이메일 도메인명이 설정되어 있으면 Account 이메일 주소 대신에 Primary 이메일 주소로 표시한다.								
		if (!companyDomainName.isEmpty()) {
			for (Map<String, Object> item : mailLogList) {
				String senderEmail = (String)item.get("senderEmail");				
	        	String senderEmailId = null;
	        	String senderEmailDomain = null;
	        	
        		int atSignIndex = senderEmail.indexOf("@");
        		
        		if (atSignIndex != -1) {
        			senderEmailId = senderEmail.substring(0, atSignIndex);
        			senderEmailDomain = senderEmail.substring(atSignIndex + 1);
        			
        			if (senderEmailDomain.equals(domainName)) {
        				OrganUserVO senderInfo = ezOrganAdminService.getUserInfo(senderEmailId, userInfo.getPrimary(), userInfo.getTenantId());
        				
        				if (senderInfo != null && senderInfo.getMail() != null) {
        					senderEmail = senderInfo.getMail();
        					
        					item.put("senderEmail", senderEmail);
        				}
        			}
        		}
				
				String recipientEmail = (String)item.get("recipientEmail");				
	        	String recipientEmailId = null;
	        	String recipientEmailDomain = null;
	        	
        		atSignIndex = recipientEmail.indexOf("@");
        		
        		if (atSignIndex != -1) {
        			recipientEmailId = recipientEmail.substring(0, atSignIndex);
        			recipientEmailDomain = recipientEmail.substring(atSignIndex + 1);
        			
        			if (recipientEmailDomain.equals(domainName)) {
        				OrganUserVO recipientInfo = ezOrganAdminService.getUserInfo(recipientEmailId, userInfo.getPrimary(), userInfo.getTenantId());
        				
	        			if (recipientInfo != null && recipientInfo.getMail() != null) {
	        				recipientEmail = recipientInfo.getMail();
	        				
	        				item.put("recipientEmail", recipientEmail);
	        			}
        			}        			
        		}				
			}
		}
		
		int totalCount = (int) resultMap.get("totalCount");
		int totalPage = totalCount / pageSize;
		
		if ((totalPage * pageSize) != totalCount && (totalCount % pageSize) != 0) {
			totalPage = totalPage + 1;
		}
		
		currentPage = Math.min(currentPage, totalPage);
		
		model.addAttribute("mailLogList", mailLogList);
		model.addAttribute("totalCount", totalCount);
		model.addAttribute("totalPage", totalPage);
		model.addAttribute("currentPage", currentPage);
		model.addAttribute("searchField", searchField);
		model.addAttribute("searchValue", searchValue);
		model.addAttribute("isPrimaryLang", isPrimaryLang);
		model.addAttribute("startDate", startDate);
		model.addAttribute("endDate", endDate);
		
		logger.debug("getStatMailLogList controller ended.");
		
		return "json";
	}
	

	/**
	 * 엑셀 내려받기 함수 
	 */
	@RequestMapping(value = "/ezStatistics/statisticsMailLogExcelExport.do")
	public void statisticsMailLogExcelExport(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Locale locale)  throws Exception {
		logger.debug("statisticsMailLogExcelExport started.");
		
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		String tenantId = String.valueOf(userInfo.getTenantId());
		String mailLogType = request.getParameter("mailLogType");
		String searchStartTime = request.getParameter("searchStartTime")  + "00:00:00";
		String searchEndTime = request.getParameter("searchEndTime") + "23:59:59";
		String startDate = request.getParameter("searchStartTime");
		String endDate = request.getParameter("searchEndTime");
		String searchField = request.getParameter("searchField");
		String searchValue = request.getParameter("searchValue");
		String isPrimaryLang = "2";
		String pageNo = request.getParameter("pageNo");
		String pageSize = request.getParameter("pageSize");
		String sysLang = ezCommonService.getTenantConfig("PrimaryLang", userInfo.getTenantId());
		
		if (!searchStartTime.isEmpty()) {
			searchStartTime = searchStartTime.replaceAll("[^0-9]", "");
		}
		
		if (!searchEndTime.isEmpty()) {
			searchEndTime = searchEndTime.replaceAll("[^0-9]", "");
		}
		
		if (userInfo.getLang().equals(sysLang)) {
			isPrimaryLang = userInfo.getLang();
		} else { 
			isPrimaryLang = sysLang;
		}

		Map<String, Object> resultMap = ezStatisticsAdminService.getMailLogList(tenantId, pageNo, String.valueOf(pageSize), 
				mailLogType, searchStartTime, searchEndTime, searchField, searchValue, isPrimaryLang);
		
		@SuppressWarnings("unchecked")
		List<Map<String, Object>> mailLogList = (List<Map<String, Object>>) resultMap.get("mailLogList");
		int totalCount = mailLogList.size();
		
		// 엑셀 워크시트 생성 및 자동 다운로드 
		HSSFWorkbook workbook = new HSSFWorkbook();
		HSSFSheet sheet = workbook.createSheet("MailLog");
		
		Row row = null;
		Cell cell = null;
		
		String fileName = "";
		fileName = startDate +"_"+ endDate + "_MailLogList";

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
		
		row = sheet.createRow(0);
		
		sheet.addMergedRegion(CellRangeAddress.valueOf("B1:D1"));
		sheet.addMergedRegion(CellRangeAddress.valueOf("E1:F1"));
		sheet.addMergedRegion(CellRangeAddress.valueOf("G1:G2"));
		sheet.addMergedRegion(CellRangeAddress.valueOf("H1:H2"));
		sheet.addMergedRegion(CellRangeAddress.valueOf("I1:I2"));
		
		// 상단
		if (mailLogType.equals("sendAll")) {
			
			cell = row.createCell(0);	cell.setCellValue(egovMessageSource.getMessage("ezStatistics.t1051", locale));
			cell.setCellStyle(headerStyle);
			cell = row.createCell(1);	cell.setCellValue(egovMessageSource.getMessage("ezStatistics.t1053", locale));
			cell.setCellStyle(headerStyle);
			cell = row.createCell(4);	cell.setCellValue(egovMessageSource.getMessage("ezStatistics.t1054", locale));
			cell.setCellStyle(headerStyle);
			cell = row.createCell(6);	cell.setCellValue(egovMessageSource.getMessage("ezStatistics.t1056", locale));
			cell.setCellStyle(headerStyle);
			cell = row.createCell(7);	cell.setCellValue(egovMessageSource.getMessage("ezStatistics.t1057", locale));
			cell.setCellStyle(headerStyle);
			cell = row.createCell(8);	cell.setCellValue(egovMessageSource.getMessage("ezStatistics.t1058", locale));
			cell.setCellStyle(headerStyle);

			row = sheet.createRow(1);
			
			cell = row.createCell(0); cell.setCellValue(egovMessageSource.getMessage("ezStatistics.t214", locale)); // 시간
			cell.setCellStyle(headerStyle);
			cell = row.createCell(1); cell.setCellValue(egovMessageSource.getMessage("ezStatistics.t1068", locale)); // 이름
			cell.setCellStyle(headerStyle);
			cell = row.createCell(2); cell.setCellValue(egovMessageSource.getMessage("ezStatistics.t1055", locale)); // 이메일주소
			cell.setCellStyle(headerStyle);
			cell = row.createCell(3); cell.setCellValue(egovMessageSource.getMessage("ezStatistics.t83", locale)); // 부서명
			cell.setCellStyle(headerStyle);
			cell = row.createCell(4); cell.setCellValue(egovMessageSource.getMessage("ezStatistics.t1068", locale)); // 이름
			cell.setCellStyle(headerStyle);
			cell = row.createCell(5); cell.setCellValue(egovMessageSource.getMessage("ezStatistics.t1055", locale)); // 이메일주소
			cell.setCellStyle(headerStyle);
			
		} else {
			
			cell = row.createCell(0);	cell.setCellValue(egovMessageSource.getMessage("ezStatistics.t1050", locale)); 
			cell.setCellStyle(headerStyle);
			cell = row.createCell(1);	cell.setCellValue(egovMessageSource.getMessage("ezStatistics.t1054", locale));
			cell.setCellStyle(headerStyle);
			cell = row.createCell(4);	cell.setCellValue(egovMessageSource.getMessage("ezStatistics.t1053", locale));
			cell.setCellStyle(headerStyle);
			cell = row.createCell(6);	cell.setCellValue(egovMessageSource.getMessage("ezStatistics.t1056", locale));
			cell.setCellStyle(headerStyle);
			cell = row.createCell(7);	cell.setCellValue(egovMessageSource.getMessage("ezStatistics.t1057", locale));
			cell.setCellStyle(headerStyle);
			cell = row.createCell(8);	cell.setCellValue(egovMessageSource.getMessage("ezStatistics.t1058", locale));
			cell.setCellStyle(headerStyle);
			
			row = sheet.createRow(1);
			
			cell = row.createCell(0); cell.setCellValue(egovMessageSource.getMessage("ezStatistics.t214", locale));
			cell.setCellStyle(headerStyle);
			cell = row.createCell(1); cell.setCellValue(egovMessageSource.getMessage("ezStatistics.t1068", locale)); 
			cell.setCellStyle(headerStyle);
			cell = row.createCell(2); cell.setCellValue(egovMessageSource.getMessage("ezStatistics.t1055", locale));
			cell.setCellStyle(headerStyle);
			cell = row.createCell(3); cell.setCellValue(egovMessageSource.getMessage("ezStatistics.t83", locale));
			cell.setCellStyle(headerStyle);
			cell = row.createCell(4); cell.setCellValue(egovMessageSource.getMessage("ezStatistics.t1068", locale));
			cell.setCellStyle(headerStyle);
			cell = row.createCell(5); cell.setCellValue(egovMessageSource.getMessage("ezStatistics.t1055", locale));
			cell.setCellStyle(headerStyle);
			
		}
		
		cell = row.createCell(6); cell.setCellStyle(headerStyle);
		cell = row.createCell(7); cell.setCellStyle(headerStyle);
		cell = row.createCell(8); cell.setCellStyle(headerStyle);
		
		for (int i = 0; i < totalCount; i++) {
			row = sheet.createRow(i+2);
			row.setHeight((short)300);
			
			Map<String, Object> mailLog = mailLogList.get(i);
			
			cell = row.createCell(0);
			cell.setCellValue((String) mailLog.get("LogTime"));
			cell.setCellStyle(bodyStyle);

			if (mailLogType.equals("sendAll")) {
				cell = row.createCell(1);
				cell.setCellValue((String) mailLog.get("senderName"));
				cell.setCellStyle(bodyStyle);
				
				cell = row.createCell(2);
				cell.setCellValue((String) mailLog.get("senderEmail"));
				cell.setCellStyle(bodyStyle);
				
				cell = row.createCell(3);
				cell.setCellValue((String) mailLog.get("senderDeptName"));
				cell.setCellStyle(bodyStyle);
				
				cell = row.createCell(4);
				cell.setCellValue((String) mailLog.get("recipientName"));
				cell.setCellStyle(bodyStyle);
				
				cell = row.createCell(5);
				cell.setCellValue((String) mailLog.get("recipientEmail"));
				cell.setCellStyle(bodyStyle);
			} else {
				cell = row.createCell(1);
				cell.setCellValue((String) mailLog.get("recipientName"));
				cell.setCellStyle(bodyStyle);
				cell = row.createCell(2);
				cell.setCellValue((String) mailLog.get("recipientEmail"));
				cell.setCellStyle(bodyStyle);
				cell = row.createCell(3);
				cell.setCellValue((String) mailLog.get("recipientDeptName"));
				cell.setCellStyle(bodyStyle);
				cell = row.createCell(4);
				cell.setCellValue((String) mailLog.get("senderName"));
				cell.setCellStyle(bodyStyle);
				cell = row.createCell(5);
				cell.setCellValue((String) mailLog.get("senderEmail"));
				cell.setCellStyle(bodyStyle);
			}

			cell = row.createCell(6);
			cell.setCellValue((String) mailLog.get("subject"));
			cell.setCellStyle(bodyStyle);
			cell = row.createCell(7);
			cell.setCellValue((String) mailLog.get("attachedFileName"));
			cell.setCellStyle(bodyStyle);
			cell = row.createCell(8);
			cell.setCellValue((String) mailLog.get("mailSize"));
			cell.setCellStyle(bodyStyle);
			
			//sheet.autoSizeColumn(i-1);
		}
		
		for (int i = 0; i < 9; i++) {
			sheet.autoSizeColumn(i);
			//sheet.setColumnWidth(i, sheet.getColumnWidth(i) + 1000);
		}
		
		response.setCharacterEncoding("UTF-8");
		response.setHeader("Content-Disposition", "attachment; fileName=" + fileName + ".xls");
		response.setContentType("application/vnd.ms-excel");
		
		workbook.write(response.getOutputStream());
		workbook.close();
		
		logger.debug("statisticsMailLogExcelExport ended.");
	}
}
