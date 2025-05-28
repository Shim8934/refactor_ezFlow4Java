package egovframework.ezEKP.ezStatistics.web;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import egovframework.ezEKP.ezOrgan.vo.OrganAuth;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.util.CellRangeAddress;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.w3c.dom.Document;
import org.w3c.dom.Node;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.ezEKP.ezStatistics.service.EzStatisticsAdminService;
import egovframework.ezEKP.ezStatistics.vo.StatApprVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;

/** 
 * @Description [Controller] 전자결재 통계
 * @author 오픈솔루션팀 황윤진
 * @Modification Information
 *
 *    수정일        수정자         수정내용
 *    ----------    ------    -------------------
 *    2016.11.24    황윤진         신규작성
 *
 * @see
 */

@Controller
public class EzStatisticsApprController {
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Resource(name = "EzOrganService")
	private EzOrganService ezOrganService;
	
	@Resource(name = "EzOrganAdminService")
	private EzOrganAdminService ezOrganAdminService;
	
	@Resource(name = "EzStatisticsAdminService")
	private EzStatisticsAdminService ezStatisticsAdminService;
	
	@Resource(name = "egovMessageSource")
    private EgovMessageSource egovMessageSource;
	
	private static final Logger logger = LoggerFactory.getLogger(EzStatisticsApprController.class);

	/**
		결재 통계 현황 호출
	 */
	@RequestMapping(value = "/ezStatistics/statisticsApprMain.do", method = RequestMethod.GET)
	public String statisticsApprMain(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("statisticsApprMain started");

		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		List<OrganDeptVO> resultList = ezOrganAdminService.getAdminCompanyList(userInfo.getId(), userInfo.getTenantId(), userInfo.getPrimary(), userInfo.getDeptID(), userInfo.getJobId());
		
		model.addAttribute("list", resultList);
		model.addAttribute("userCompany", userInfo.getCompanyID());
		model.addAttribute("userInfo", userInfo);

		logger.debug("statisticsApprMain ended");
		
		return "ezStatistics/statisticsApprMain";
	}
	
	/**
	 * 액셀저장
	 */
	@RequestMapping(value = "/ezStatistics/excelExportOut.do", method = RequestMethod.POST)
	@ResponseBody
	public void excelExportOut(@CookieValue("loginCookie") String loginCookie, HttpServletResponse response, HttpServletRequest request) throws IOException {
		logger.debug("excelExportOut started");

		/*LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		response.setContentType("application/vnd.ms-excel");
		response.setCharacterEncoding("UTF-8");
		response.addHeader("Content-Disposition", "attachment;filename=" + EgovDateUtil.getTodayTime().substring(0, 10) + "_" + userInfo.getDeptID() + ".xls");
		
		if (request.getParameter("saveExcelData") != null) {
			PrintWriter writer = response.getWriter();
			
			writer.println(request.getParameter("saveExcelData"));
		}*/
		
		// 2019-02-08 김민성 - 엑셀내려받기 workbook 형식 다운로드로 변경
		try (HSSFWorkbook workbook = new HSSFWorkbook()) {
		    HSSFSheet sheet;
		    
		    HSSFCellStyle headerStyle= workbook.createCellStyle();
		    headerStyle.setFillForegroundColor(HSSFColor.GREY_25_PERCENT.index);
		    headerStyle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
		    headerStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
		    headerStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
		    headerStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
		    headerStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
		    headerStyle.setAlignment(CellStyle.ALIGN_CENTER);
		      
		    HSSFCellStyle bodyStyle= workbook.createCellStyle();
		    bodyStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
		    bodyStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
		    bodyStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
		    bodyStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
		    bodyStyle.setAlignment(CellStyle.ALIGN_CENTER);
		      
		    Row row;
		    Cell cell;
		    
		    String pFileName = "";
		    String strDate = EgovDateUtil.getToday("-");
		    pFileName = strDate+"_Report";
		    
		    String StrAnalysisDate = request.getParameter("saveExcelData").trim().replaceAll("&nbsp;", "").replaceAll("\r\n", "").replaceAll("\n", "").replaceAll("\t", "");
		      
		    Document analysisData = commonUtil.convertStringToDocument(StrAnalysisDate);
		      
		    Node tableNode = analysisData.getElementsByTagName("table").item(0);
			Node tbody = tableNode.getChildNodes().item(0);
		    Node tableHeadNode1to6;
			Node tableHeadNode7to12;
			Node tableBodyNodeType;
			Node tableBodyNodeData1to6;
			Node tableBodyNodeData7to12;
		      
		    sheet = workbook.createSheet("report");
		      
		    tableHeadNode1to6 = tbody.getChildNodes().item(0);
			tableHeadNode7to12 = tbody.getChildNodes().item(3);
			tableBodyNodeType = tbody.getChildNodes().item(1);
			tableBodyNodeData1to6 = tbody.getChildNodes().item(2);
			tableBodyNodeData7to12 = tbody.getChildNodes().item(5);
	
			row = sheet.createRow(0);
			
			for (int i = 0; i < tableHeadNode1to6.getChildNodes().getLength() ; i++){
			
				cell = row.createCell(i*4);
				row.createCell(i*4+1).setCellStyle(headerStyle);
				row.createCell(i*4+2).setCellStyle(headerStyle);
				row.createCell(i*4+3).setCellStyle(headerStyle);
				cell.setCellValue(tableHeadNode1to6.getChildNodes().item(i).getTextContent());
				cell.setCellStyle(headerStyle);
				
			}
			
			row = sheet.createRow(1);
			
			for (int i = 0; i < tableBodyNodeType.getChildNodes().getLength() ; i++){
				
				cell = row.createCell(i);
				cell.setCellValue(tableBodyNodeType.getChildNodes().item(i).getTextContent());
				cell.setCellStyle(headerStyle);
				
			}
			
			row = sheet.createRow(2);
			
			for (int i = 0; i < tableBodyNodeData1to6.getChildNodes().getLength() ; i++){
			
				cell = row.createCell(i);
				cell.setCellValue(tableBodyNodeData1to6.getChildNodes().item(i).getTextContent());
				cell.setCellStyle(bodyStyle);
				
			}
			
			row = sheet.createRow(3);
			
			for (int i = 0; i < tableHeadNode7to12.getChildNodes().getLength() ; i++){
			
				cell = row.createCell(i*4);
				row.createCell(i*4+1).setCellStyle(headerStyle);
				row.createCell(i*4+2).setCellStyle(headerStyle);
				row.createCell(i*4+3).setCellStyle(headerStyle);
				cell.setCellValue(tableHeadNode7to12.getChildNodes().item(i).getTextContent());
				cell.setCellStyle(headerStyle);
				
			}
			
			row = sheet.createRow(4);
			
			for (int i = 0; i < tableBodyNodeType.getChildNodes().getLength() ; i++){
				
				cell = row.createCell(i);
				cell.setCellValue(tableBodyNodeType.getChildNodes().item(i).getTextContent());
				cell.setCellStyle(headerStyle);
				
			}
			
			row = sheet.createRow(5);
			
			for (int i = 0; i < tableBodyNodeData7to12.getChildNodes().getLength() ; i++){
				
				cell = row.createCell(i);
				cell.setCellValue(tableBodyNodeData7to12.getChildNodes().item(i).getTextContent());
				cell.setCellStyle(bodyStyle);
				
			}
			
			for (int i = 0; i < 6; i++) {
				
				sheet.addMergedRegion(new CellRangeAddress(0,0,i*4,i*4+3));
				sheet.addMergedRegion(new CellRangeAddress(3,3,i*4,i*4+3));
				 
			}
	
	
		    response.setHeader("Content-Disposition", "attachment; fileName=\"" + pFileName + ".xls\"");
		    workbook.write(response.getOutputStream());
		      
		    //workbook.close();
		}

		logger.debug("excelExportOut ended");
	}
	
	/**
	 * 결재 통계 현황 표출
	 */
	@RequestMapping(value = "/ezStatistics/getStatisticsAprMain.do", method=RequestMethod.POST, produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getStatisticsAprMain(@CookieValue("loginCookie") String loginCookie, StatApprVO statApprVO) {
		logger.debug("getStatisticsAprMain started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		statApprVO.setTenantID(userInfo.getTenantId());
		
		String result = ezStatisticsAdminService.getMainList(statApprVO);

		logger.debug("getStatisticsAprMain ended");
		
		return result;
	}
	
	/**
	 * 양식별 통계 현황 호출
	 */
	@RequestMapping(value = "/ezStatistics/statisticsMonForm.do", method = RequestMethod.GET)
	public String statisticsMonForm(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("statisticsMonForm started");

		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		List<OrganDeptVO> resultList = ezOrganAdminService.getAdminCompanyList(userInfo.getId(), userInfo.getTenantId(), userInfo.getPrimary(), userInfo.getDeptID(), userInfo.getJobId());
		
		model.addAttribute("list", resultList);
		model.addAttribute("userCompany", userInfo.getCompanyID());
		model.addAttribute("userInfo", userInfo);
		
		logger.debug("statisticsMonForm ended");
		
		return "ezStatistics/statisticsMonForm";
	}
	
	/**
	 * 양식별 통계 현황 표출
	 */
	@RequestMapping(value = "/ezStatistics/getStatisticsAprMon.do", method=RequestMethod.POST, produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getStatisticsAprMon(@CookieValue("loginCookie") String loginCookie, StatApprVO statApprVO) {
		logger.debug("getStatisticsAprMon started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		statApprVO.setTenantID(userInfo.getTenantId());
		
		String result = ezStatisticsAdminService.getCountList(statApprVO);

		logger.debug("getStatisticsAprMon ended");
		
		return result;
	}
	
	/**
	 * 양식 관련 통계 현황 표출
	 */
	@RequestMapping(value = "/ezStatistics/getFormInfo.do", method=RequestMethod.POST, produces ="text/xml;charset=utf-8")
	@ResponseBody
	public String getFormInfo(@CookieValue("loginCookie") String loginCookie, StatApprVO statApprVO) {
		logger.debug("getFormInfo started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		statApprVO.setTenantID(userInfo.getTenantId());
		//2018-10-02 김보미
		//statApprVO.setLang(userInfo.getLang());
		statApprVO.setLang(userInfo.getPrimary()); //formName은 1,2밖에 없음.
		
		String result = ezStatisticsAdminService.getFormInfo(statApprVO);

		logger.debug("getFormInfo ended");
		
		return result;
	}
	
	/**
	 * 부서별 결재처리시간 호출
	 */
	@RequestMapping(value = "/ezStatistics/statisticsTimeDept.do", method = RequestMethod.GET)
	public String statisticsTimeDept(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("statisticsTimeDept started");

		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		List<OrganDeptVO> deptVOs = ezOrganAdminService.getCompanyList(userInfo.getPrimary(), userInfo.getTenantId());
		
		StringBuilder companySel = new StringBuilder();
		
		for (OrganDeptVO vo : deptVOs) {
			if (userInfo.getRollInfo().indexOf("c=1") > -1 || vo.getCn().equals(userInfo.getCompanyID())) {
				companySel.append("<option value='" + vo.getCn() + "'>");
				companySel.append(vo.getDisplayName());
				companySel.append("</option>");
			}
		}
		
		String topid = "";
		
		if (userInfo.getRollInfo().indexOf("c=1") == -1) {
			topid = userInfo.getCompanyID();
		} else {
			topid = "Top/organ";
		}
		
		model.addAttribute("companyID", topid);					
		model.addAttribute("companySel", companySel);
		model.addAttribute("userInfo", userInfo);

		logger.debug("statisticsTimeDept ended");
		
		return "ezStatistics/statisticsTimeDept";
	}
	
	/**
	 * 부서별 통계 현황 호출
	 */
	@RequestMapping(value = "/ezStatistics/statisticsMonDept.do", method = RequestMethod.GET)
	public String statisticsMonDept(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("statisticsMonDept started");

		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		List<OrganDeptVO> resultList = ezOrganAdminService.getAdminCompanyList(userInfo.getId(), userInfo.getTenantId(), userInfo.getPrimary(), userInfo.getDeptID(), userInfo.getJobId());
		
		StringBuilder companySel = new StringBuilder();
		
		for (OrganDeptVO vo : resultList) {
			companySel.append("<option value='").append(vo.getCn()).append("'>")
					.append(vo.getDisplayName())
					.append("</option>");
		}
		
		OrganAuth organAuth = commonUtil.makeOrganAuth(userInfo.getId(), userInfo.getTenantId(), userInfo.getDeptID(), userInfo.getJobId());
		String topID = organAuth.isAuth(OrganAuth.AdminAuth.ADMIN_MASTER) ? "Top/organ" : userInfo.getCompanyID();
		
		model.addAttribute("companyID", topID);
		model.addAttribute("companySel", companySel);
		model.addAttribute("userInfo", userInfo);
		
		logger.debug("statisticsMonDept ended");
		
		return "ezStatistics/statisticsMonDept";
	}
	
	/**
	 * 결재처리시간 표출
	 */
	@RequestMapping(value = "/ezStatistics/getStatisticsAprTime.do", method=RequestMethod.POST, produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getStatisticsAprTime(@CookieValue("loginCookie") String loginCookie, StatApprVO statApprVO) {
		logger.debug("getStatisticsAprTime started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		statApprVO.setTenantID(userInfo.getTenantId());
		
		String result = ezStatisticsAdminService.getTimeList(statApprVO);
		
		logger.debug("getStatisticsAprTime ended");
		
		return result;
	}
	
	/**
	 * 이름중복체크 호출
	 */
	@RequestMapping(value = "/ezStatistics/checkName2.do", method = RequestMethod.GET)
	public String checkName2() {
		logger.debug("checkName2 started");

		logger.debug("checkName2 ended");
		
		return "ezStatistics/statisticsCheckName2";
	}
	
	/**
	 * 개인별 통계 현황 호출
	 */
	@RequestMapping(value = "/ezStatistics/statisticsMonUser.do", method = RequestMethod.GET)
	public String statisticsMonUser(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("statisticsMonUser started");

		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		List<OrganDeptVO> deptVOs = ezOrganAdminService.getCompanyList(userInfo.getPrimary(), userInfo.getTenantId());
		
		StringBuilder companySel = new StringBuilder();
		
		for (OrganDeptVO vo : deptVOs) {
			if (userInfo.getRollInfo().indexOf("c=1") > -1 || vo.getCn().equals(userInfo.getCompanyID())) {
				companySel.append("<option value='" + vo.getCn() + "'>");
				companySel.append(vo.getDisplayName());
				companySel.append("</option>");
			}
		}
		
		String topid = "";
		
		if (userInfo.getRollInfo().indexOf("c=1") == -1) {
			topid = userInfo.getCompanyID();
		} else {
			topid = "Top/organ";
		}
		
		model.addAttribute("companyID", topid);					
		model.addAttribute("companySel", companySel);
		model.addAttribute("userInfo", userInfo);
		
		logger.debug("statisticsMonUser ended");
		
		return "ezStatistics/statisticsMonUser";
	}
	
	/**
	 * 양식별 통계 현황 호출
	 */
	@RequestMapping(value = "/ezStatistics/statisticsTimeForm.do", method = RequestMethod.GET)
	public String statisticsTimeForm(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("statisticsTimeForm started");
		
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		List<OrganDeptVO> resultList = ezOrganAdminService.getAdminCompanyList(userInfo.getId(), userInfo.getTenantId(), userInfo.getPrimary(), userInfo.getDeptID(), userInfo.getJobId());
		
		model.addAttribute("list", resultList);
		model.addAttribute("userCompany", userInfo.getCompanyID());
		model.addAttribute("userInfo", userInfo);

		logger.debug("statisticsTimeForm ended");

		return "ezStatistics/statisticsTimeForm";
	}
	
	/**
	 * 개인별 결재처리 시간 호출
	 */
	@RequestMapping(value = "/ezStatistics/statisticsTimeUser.do", method = RequestMethod.GET)
	public String statisticsTimeUser(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("statisticsTimeUser started");
		
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		List<OrganDeptVO> deptVOs = ezOrganAdminService.getCompanyList(userInfo.getPrimary(), userInfo.getTenantId());
		
		StringBuilder companySel = new StringBuilder();
		
		for (OrganDeptVO vo : deptVOs) {
			if (userInfo.getRollInfo().indexOf("c=1") > -1 || vo.getCn().equals(userInfo.getCompanyID())) {
				companySel.append("<option value='" + vo.getCn() + "'>");
				companySel.append(vo.getDisplayName());
				companySel.append("</option>");
			}
		}
		
		String topid = "";
		
		if (userInfo.getRollInfo().indexOf("c=1") == -1) {
			topid = userInfo.getCompanyID();
		} else {
			topid = "Top/organ";
		}
		
		model.addAttribute("companyID", topid);					
		model.addAttribute("companySel", companySel);
		model.addAttribute("userInfo", userInfo);

		logger.debug("statisticsTimeUser ended");

		return "ezStatistics/statisticsTimeUser";
	}
	
	/**
	 * 양식별 통계 호출
	 */
	@RequestMapping(value = "/ezStatistics/statisticsForm.do", method = RequestMethod.GET)
	public String statisticsForm(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("statisticsForm started");

		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		List<OrganDeptVO> resultList = ezOrganAdminService.getAdminCompanyList(userInfo.getId(), userInfo.getTenantId(), userInfo.getPrimary(), userInfo.getDeptID(), userInfo.getJobId());
		
		model.addAttribute("list", resultList);
		model.addAttribute("userCompany", userInfo.getCompanyID());
		model.addAttribute("userInfo", userInfo);
		
		logger.debug("statisticsForm ended");

		return "ezStatistics/statisticsForm";
	}
	
	/**
	 * 통계 표출
	 */
	@RequestMapping(value = "/ezStatistics/getStatisticsAprSearch.do", method = RequestMethod.POST, produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getStatisticsAprSearch(@CookieValue("loginCookie") String loginCookie, StatApprVO statApprVO) {
		logger.debug("getStatisticsAprSearch started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		statApprVO.setTenantID(userInfo.getTenantId());
		statApprVO.setLang(userInfo.getLang());
		
		String result = ezStatisticsAdminService.getSearchList(statApprVO);
		
		logger.debug("getStatisticsAprSearch ended");
		
		return result;
	}
	
	/**
	 * 부서별 통계 호출
	 */
	@RequestMapping(value = "/ezStatistics/statisticsDept.do", method = RequestMethod.GET)
	public String statisticsDept(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("statisticsDept started");

		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		List<OrganDeptVO> deptVOs = ezOrganAdminService.getCompanyList(userInfo.getPrimary(), userInfo.getTenantId());
		
		StringBuilder companySel = new StringBuilder();
		
		for (OrganDeptVO vo : deptVOs) {
			if (userInfo.getRollInfo().indexOf("c=1") > -1 || vo.getCn().equals(userInfo.getCompanyID())) {
				companySel.append("<option value='" + vo.getCn() + "'>");
				companySel.append(vo.getDisplayName());
				companySel.append("</option>");
			}
		}
		
		String topid = "";
		
		if (userInfo.getRollInfo().indexOf("c=1") == -1) {
			topid = userInfo.getCompanyID();
		} else {
			topid = "Top/organ";
		}
		
		model.addAttribute("companyID", topid);					
		model.addAttribute("companySel", companySel);
		model.addAttribute("userInfo", userInfo);
		
		logger.debug("statisticsDept ended");

		return "ezStatistics/statisticsDept";
	}
	
	/**
	 * 개인별 통계 호출
	 */
	@RequestMapping(value = "/ezStatistics/statisticsUser.do", method = RequestMethod.GET)
	public String statisticsUser(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("statisticsUser started");

		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		List<OrganDeptVO> deptVOs = ezOrganAdminService.getCompanyList(userInfo.getPrimary(), userInfo.getTenantId());
		
		StringBuilder companySel = new StringBuilder();
		
		for (OrganDeptVO vo : deptVOs) {
			if (userInfo.getRollInfo().indexOf("c=1") > -1 || vo.getCn().equals(userInfo.getCompanyID())) {
				companySel.append("<option value='" + vo.getCn() + "'>");
				companySel.append(vo.getDisplayName());
				companySel.append("</option>");
			}
		}
		
		String topid = "";
		
		if (userInfo.getRollInfo().indexOf("c=1") == -1) {
			topid = userInfo.getCompanyID();
		} else {
			topid = "Top/organ";
		}
		
		model.addAttribute("companyID", topid);					
		model.addAttribute("companySel", companySel);
		model.addAttribute("userInfo", userInfo);

		logger.debug("statisticsUser ended");
		
		return "ezStatistics/statisticsUser";
	}
	/**
	 * 수동 통계 배치 동작
	 */
	@RequestMapping(value = "/ezStatistics/customApprStatisticsBatch.do", method = RequestMethod.GET)
	@ResponseBody
	public String customApprStatisticsBatch() throws Exception {
		logger.debug("customApprStatisticsBatch started");
		
		ezStatisticsAdminService.customApprStatisticsBatch();
		
		
		logger.debug("customApprStatisticsBatch ended");
		
		return "success";
	}

	/**
	 * 2021-02-23 박기범 : chartportlet용 통계 호출
	 */
	@RequestMapping(value = "/ezStatistics/getYearlyDocCount.do", method = RequestMethod.GET, produces = "text/xml;charset=utf-8")
	public String getYearlyDocCount(@CookieValue("loginCookie") String loginCookie, Model model) {
		logger.debug("getYearlyDocCount.do started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		JSONObject resultList = ezStatisticsAdminService.getYearlyDocCount(userInfo.getTenantId(), userInfo.getCompanyID());
		String result = resultList.get("result").toString();

		if (result.equals("true")) {
			model.addAttribute("result", "true");
			resultList.remove("result");
			model.addAttribute("data", resultList);
		} else {
			model.addAttribute("result", "false");
		}

		logger.debug("getYearlyDocCount,do ended");

		return "json";
	}
}
