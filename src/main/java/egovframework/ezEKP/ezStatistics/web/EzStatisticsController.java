package egovframework.ezEKP.ezStatistics.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezStatistics.service.EzStatisticsAdminService;
import egovframework.ezEKP.ezStatistics.vo.StatApprVO;
import egovframework.let.user.login.vo.LoginVO;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Row;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.w3c.dom.Document;
import org.w3c.dom.Node;

import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;

/** 
 * @Description [Controller] 통계
 * @author 오픈솔루션팀 이동호
 * @Modification Information
 *
 *    수정일        수정자         수정내용
 *    ----------    ------    -------------------
 *    2016.06.27    이동호             신규작성
 *
 * @see
 */

@Controller
public class EzStatisticsController {
	
	private static final Logger logger = LoggerFactory.getLogger(EzStatisticsController.class);
	
	@Autowired
	CommonUtil commonUtil;

	@Resource(name = "EzStatisticsAdminService")
	private EzStatisticsAdminService ezStatisticsAdminService;

	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	/**
	 * 통계 메인화면 호출 함수
	 */
	@RequestMapping(value="/ezStatistics/statisticsMain.do", method = RequestMethod.GET)
	public String showMain() throws Exception {		
		return "ezStatistics/statisticsMain";
	}
	
	/**
	 * 사용자 통계 Excel 내려받기 호출 함수
	 */
	@RequestMapping(value = {"/ezStatistics/saticGetXls.do", "/ezStatistics/UserOSsaticXls.do"}, method = RequestMethod.POST)
	@ResponseBody
	public void qstResultAnalysisSave(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception{
		logger.debug("qstResultAnalysisSave started");
		
		String headerFLAG = "";
		
		if (request.getParameter("headerFlag") != null) {
			headerFLAG = request.getParameter("headerFlag");
        }
		
		try (HSSFWorkbook workbook = new HSSFWorkbook()) {
			HSSFSheet sheet;
			
			HSSFCellStyle headerStyle= workbook.createCellStyle();
			headerStyle.setFillForegroundColor(HSSFColor.GREY_25_PERCENT.index);
			headerStyle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
			headerStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
			headerStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
			headerStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
			headerStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
			
			HSSFCellStyle bodyStyle= workbook.createCellStyle();
			bodyStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
			bodyStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
			bodyStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
			bodyStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
			
			Row row;
			Cell cell;
			
			String pFileName = "";
			String strDate = EgovDateUtil.getToday("-");
			pFileName = strDate+"_Report";
			sheet = workbook.createSheet("report");
			
			if (headerFLAG.equals("")) {
				String StrAnalysisDate = request.getParameter("saveExcelData").trim().replaceAll("&nbsp;", "").replaceAll("\r\n", "").replaceAll("\n", "").replaceAll("\t", "");
	
				Document analysisData = commonUtil.convertStringToDocument(StrAnalysisDate);
				
				Node tableNode = analysisData.getElementsByTagName("table").item(0);
				Node tableHeadNode;
				Node tableBodyNode;
				
				tableHeadNode = tableNode.getChildNodes().item(0).getChildNodes().item(0);
				tableBodyNode = tableNode.getChildNodes().item(0);
				
				row = sheet.createRow(0);
				
				for (int i=0; i<tableHeadNode.getChildNodes().getLength(); i++) {
					cell = row.createCell(i);
					cell.setCellValue(tableHeadNode.getChildNodes().item(i).getTextContent());
					cell.setCellStyle(headerStyle);
				}
				
				for (int i=0; i<tableBodyNode.getChildNodes().getLength()-1; i++) {
					row = sheet.createRow(i+1);
					Node tr = tableBodyNode.getChildNodes().item(i+1);
					
					for (int j=0; j<tr.getChildNodes().getLength(); j++) {
						cell = row.createCell(j);
						cell.setCellValue(tr.getChildNodes().item(j).getTextContent());
						cell.setCellStyle(bodyStyle);
					}
				}
			} else {
				String StrAnalysisDate[] = request.getParameter("saveExcelData").trim().replaceAll("&nbsp;", "").replaceAll("\r\n", "").replaceAll("\n", "").replaceAll("\t", "").split("_");
				
				for (int i=0; i<StrAnalysisDate.length; i++) {
					Document analysisData = commonUtil.convertStringToDocument(StrAnalysisDate[i]);
	
					Node tableNode = analysisData.getElementsByTagName("table").item(0);
					Node tableHeadNode;
					Node tableBodyNode;
					
					tableHeadNode = tableNode.getChildNodes().item(0).getChildNodes().item(0);
					tableBodyNode = tableNode.getChildNodes().item(0);
					
					if (i == 0) {
						row = sheet.createRow(0);				
					} else {
						row = sheet.createRow(8);
					}
					
					for (int j=0; j<tableHeadNode.getChildNodes().getLength(); j++) {
						cell = row.createCell(j);
						cell.setCellValue(tableHeadNode.getChildNodes().item(j).getTextContent());
						cell.setCellStyle(headerStyle);
					}
					
					if (i == 0) {
						for (int j=0; j<tableBodyNode.getChildNodes().getLength()-1; j++) {
							row = sheet.createRow(j+1);
							Node tr = tableBodyNode.getChildNodes().item(j+1);
							
							for (int k=0; k<tr.getChildNodes().getLength(); k++) {
								cell = row.createCell(k);
								cell.setCellValue(tr.getChildNodes().item(k).getTextContent());
								cell.setCellStyle(bodyStyle);
							}
						}				
					} else {
						for (int j=0; j<tableBodyNode.getChildNodes().getLength()-1; j++) {
							row = sheet.createRow(j+9);
							Node tr = tableBodyNode.getChildNodes().item(j+1);
							
							for (int k=0; k<tr.getChildNodes().getLength(); k++) {
								cell = row.createCell(k);
								cell.setCellValue(tr.getChildNodes().item(k).getTextContent());
								cell.setCellStyle(bodyStyle);
							}
						}
					}
				}		
			}
	
			response.setHeader("Content-Disposition", "attachment; fileName=\"" + pFileName + ".xls\"");
			workbook.write(response.getOutputStream());
			
			//workbook.close();
		}
		
		logger.debug("qstResultAnalysisSave ended");
	}
	
	/**
	 * 메일 통계 Excel 내려받기 호출 함수
	 */
	@RequestMapping(value = "/ezStatistics/saticGetXlsM.do", method = RequestMethod.POST)
	@ResponseBody
	public void qstResultAnalysisSaveM(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception{
		logger.debug("qstResultAnalysisSaveM started");
		
		String headerFLAG = "";
		
		if (request.getParameter("headerFlag") != null) {
			headerFLAG = request.getParameter("headerFlag");
        }
		
		try (HSSFWorkbook workbook = new HSSFWorkbook()) {
			HSSFSheet sheet;
			
			HSSFCellStyle headerStyle= workbook.createCellStyle();
			headerStyle.setFillForegroundColor(HSSFColor.GREY_25_PERCENT.index);
			headerStyle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
			headerStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
			headerStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
			headerStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
			headerStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
			
			HSSFCellStyle bodyStyle= workbook.createCellStyle();
			bodyStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
			bodyStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
			bodyStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
			bodyStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
			
			Row row;
			Cell cell;
			
			String pFileName = "";
			String strDate = EgovDateUtil.getToday("-");
			pFileName = strDate+"_Report";
			
			String StrAnalysisDate = request.getParameter("saveExcelData").trim().replaceAll("&nbsp;", "").replaceAll("\r\n", "").replaceAll("\n", "").replaceAll("\t", "");
			
			Document analysisData = commonUtil.convertStringToDocument(StrAnalysisDate);
			
			Node tableNode = analysisData.getElementsByTagName("table").item(0);
			Node tableHeadNode;
			Node tableBodyNode;
			
			sheet = workbook.createSheet("report");
			tableHeadNode = tableNode.getChildNodes().item(0).getChildNodes().item(0);
			tableBodyNode = tableNode.getChildNodes().item(0);
			
			row = sheet.createRow(0);
			cell = row.createCell(0);
			cell.setCellValue(tableHeadNode.getChildNodes().item(0).getTextContent());
			cell = row.createCell(1);
			cell.setCellValue(tableBodyNode.getChildNodes().item(1).getChildNodes().item(0).getTextContent());
			
			row = sheet.createRow(1);
			for (int i=0; i<tableHeadNode.getChildNodes().getLength()-1; i++) {
				cell = row.createCell(i);
				cell.setCellValue(tableHeadNode.getChildNodes().item(i+1).getTextContent());
				cell.setCellStyle(headerStyle);
			}
			
			for (int i=0; i<tableBodyNode.getChildNodes().getLength()-1; i++) {
				row = sheet.createRow(i+2);
				Node tr = tableBodyNode.getChildNodes().item(i+1);
				
				for (int j=0; j<tr.getChildNodes().getLength(); j++) {
					if (i==0) {
						if (j+1<tr.getChildNodes().getLength()) {
							cell = row.createCell(j);
							cell.setCellValue(tr.getChildNodes().item(j+1).getTextContent());
						}
					} else {
						cell = row.createCell(j);
						cell.setCellValue(tr.getChildNodes().item(j).getTextContent());
					}
					if (headerFLAG.equals("TRUE")) {
						if (i != 1) {
							cell.setCellStyle(bodyStyle);
						} else {
							cell.setCellStyle(headerStyle);
						}
					} else {
						if (i != 2) {
							cell.setCellStyle(bodyStyle);
						} else {
							cell.setCellStyle(headerStyle);
						}
					}
				}
			}
			
			response.setHeader("Content-Disposition", "attachment; fileName=\"" + pFileName + ".xls\"");
			workbook.write(response.getOutputStream());
			
			//workbook.close();
		}
		
		logger.debug("qstResultAnalysisSaveM ended");
	}
	
	/**
	 * 전자결재 통계 Excel 내려받기 호출 함수
	 * 양식별, 부서별, 개인별 통계 현황
	 */
	@RequestMapping(value = "/ezStatistics/saticGetXlsA.do", method = RequestMethod.POST)
	@ResponseBody
	public void qstResultAnalysisSaveA(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception{
		logger.debug("qstResultAnalysisSaveA started");
		
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
		
		logger.debug("qstResultAnalysisSaveA ended");
	}
	
	/**
    * 결재 통계 - 양식별/부서별/개인별 Excel 내려받기 호출 함수
    */
   @RequestMapping(value = "/ezStatistics/saticGetXlsApproval.do", method = RequestMethod.POST)
   @ResponseBody
   public void qstResultAnalysisSaveApproval(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception{
      logger.debug("qstResultAnalysisSaveApproval started");
      
      try (HSSFWorkbook workbook = new HSSFWorkbook()) {
	      HSSFSheet sheet;
	      
	      HSSFCellStyle headerStyle= workbook.createCellStyle();
	      headerStyle.setFillForegroundColor(HSSFColor.GREY_25_PERCENT.index);
	      headerStyle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
	      headerStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
	      headerStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
	      headerStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
	      headerStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
	      
	      HSSFCellStyle bodyStyle= workbook.createCellStyle();
	      bodyStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
	      bodyStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
	      bodyStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
	      bodyStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
	      
	      Row row;
	      Cell cell;
	      
	      String pFileName = "";
	      String strDate = EgovDateUtil.getToday("-");
	      pFileName = strDate+"_Report";
	      
	      String StrAnalysisDate = request.getParameter("saveExcelData").trim().replaceAll("&nbsp;", "").replaceAll("\r\n", "").replaceAll("\n", "").replaceAll("\t", "");
	      
	      Document analysisData = commonUtil.convertStringToDocument(StrAnalysisDate);
	      
	      Node tableNode = analysisData.getElementsByTagName("table").item(0);
	      Node tBody = tableNode.getChildNodes().item(0);
	      Node tableHeadNode;
	      Node tableBodyNode;
	      
	      sheet = workbook.createSheet("report");
	      
	      tableHeadNode = tBody.getChildNodes().item(0);
	      tableBodyNode = tBody.getChildNodes().item(1);
	
		  row = sheet.createRow(0);
		  for (int i = 0; i < tableHeadNode.getChildNodes().getLength() ; i++){
			  cell = row.createCell(i);
			  cell.setCellValue(tableHeadNode.getChildNodes().item(i).getTextContent());
			  cell.setCellStyle(headerStyle);
		  }
	
		  row = sheet.createRow(1);
		  for (int i = 0; i < tableBodyNode.getChildNodes().getLength() ; i++){
		 	  cell = row.createCell(i);
			  cell.setCellValue(tableBodyNode.getChildNodes().item(i).getTextContent());
			  cell.setCellStyle(bodyStyle);
		  }
	
	      response.setHeader("Content-Disposition", "attachment; fileName=\"" + pFileName + ".xls\"");
	      workbook.write(response.getOutputStream());
	      
	      //workbook.close();
      }
      
      logger.debug("qstResultAnalysisSaveApproval ended");
   }
	   
   /**
    * 결재 통계 - 양식별/부서별/개인별 결재처리 시간 Excel 내려받기 호출 함수
    */
   @RequestMapping(value = "/ezStatistics/saticGetXlsApprovalTime.do", method = RequestMethod.POST)
   @ResponseBody
   public void qstResultAnalysisSaveApprovalTime(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception{
      logger.debug("qstResultAnalysisSaveApprovalTime started");
      
      try (HSSFWorkbook workbook = new HSSFWorkbook()) {
	      HSSFSheet sheet;
	      
	      HSSFCellStyle headerStyle= workbook.createCellStyle();
	      headerStyle.setFillForegroundColor(HSSFColor.GREY_25_PERCENT.index);
	      headerStyle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
	      headerStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
	      headerStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
	      headerStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
	      headerStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
	      
	      HSSFCellStyle bodyStyle= workbook.createCellStyle();
	      bodyStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
	      bodyStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
	      bodyStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
	      bodyStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
	      
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
		  Node tableBodyNodeData1to6;
		  Node tableBodyNodeData7to12;
	
	      sheet = workbook.createSheet("report");
	      tableHeadNode1to6 = tbody.getChildNodes().item(0);
		  tableHeadNode7to12 = tbody.getChildNodes().item(2);
		  tableBodyNodeData1to6 = tbody.getChildNodes().item(1);
		  tableBodyNodeData7to12 = tbody.getChildNodes().item(3);
	
		  row = sheet.createRow(0);
		  for (int i = 0; i < tableHeadNode1to6.getChildNodes().getLength() ; i++){
			  cell = row.createCell(i);
			  cell.setCellValue(tableHeadNode1to6.getChildNodes().item(i).getTextContent());
			  cell.setCellStyle(headerStyle);
		  }
	
		  row = sheet.createRow(1);
		  for (int i = 0; i < tableBodyNodeData1to6.getChildNodes().getLength() ; i++){
		 	  cell = row.createCell(i);
			  cell.setCellValue(tableBodyNodeData1to6.getChildNodes().item(i).getTextContent());
			  cell.setCellStyle(bodyStyle);
		  }
		  
		  row = sheet.createRow(2);
		  for (int i = 0; i < tableHeadNode7to12.getChildNodes().getLength() ; i++){
			  cell = row.createCell(i);
			  cell.setCellValue(tableHeadNode7to12.getChildNodes().item(i).getTextContent());
			  cell.setCellStyle(headerStyle);
		  }
	
		  row = sheet.createRow(3);
		  for (int i = 0; i < tableBodyNodeData7to12.getChildNodes().getLength() ; i++){
		 	  cell = row.createCell(i);
			  cell.setCellValue(tableBodyNodeData7to12.getChildNodes().item(i).getTextContent());
			  cell.setCellStyle(bodyStyle);
		  }
	
	      response.setHeader("Content-Disposition", "attachment; fileName=\"" + pFileName + ".xls\"");
	      workbook.write(response.getOutputStream());
	      
	      //workbook.close();
      }
      
      logger.debug("qstResultAnalysisSaveApprovalTime ended");
   }

   /**
	 * 전자결재 통계 Excel 내려받기 호출 함수
	 * 양식별, 부서별, 개인별 통계 현황
	 */
	@RequestMapping(value = "/ezStatistics/saticGetXlsTotalA.do", method = RequestMethod.POST)
	@ResponseBody
	public void qstResultAnalysisSaveTotalA(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception{
		logger.debug("qstResultAnalysisSaveTotalA started");
	
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
			Node tableHeadNode1to12;
			Node tableBodyNodeType;
			Node tableBodyNodeData1to12;
			
			sheet = workbook.createSheet("report");
			tableHeadNode1to12 = tbody.getChildNodes().item(0);
			tableBodyNodeType = tbody.getChildNodes().item(1);
			tableBodyNodeData1to12 = tbody.getChildNodes().item(2);
			
			row = sheet.createRow(0);
			
			for (int i = 0; i < tableHeadNode1to12.getChildNodes().getLength() ; i++){
				
				if (i != 0) {
					
				cell = row.createCell((i-1)*4+1);
				row.createCell((i-1)*4+2).setCellStyle(headerStyle);
				row.createCell((i-1)*4+3).setCellStyle(headerStyle);
				row.createCell((i-1)*4+4).setCellStyle(headerStyle);
				
				} else {
					
					cell = row.createCell(i);
				}
				
				cell.setCellValue(tableHeadNode1to12.getChildNodes().item(i).getTextContent());
				cell.setCellStyle(headerStyle);
			}
			row = sheet.createRow(1);
			
			for (int i = 0; i < tableBodyNodeType.getChildNodes().getLength() ; i++){
			
				cell = row.createCell(i);
				cell.setCellValue(tableBodyNodeType.getChildNodes().item(i).getTextContent());
				cell.setCellStyle(headerStyle);
				
			}
			
			row = sheet.createRow(2);
			
			for (int i = 0; i < tableBodyNodeData1to12.getChildNodes().getLength() ; i++){
			
				cell = row.createCell(i);
				cell.setCellValue(tableBodyNodeData1to12.getChildNodes().item(i).getTextContent());
				cell.setCellStyle(bodyStyle);
				
			}
			
			for (int i = 0; i < 12; i++) {
				 sheet.addMergedRegion(new CellRangeAddress(0,0,i*4+1,i*4+4));
			}
			
			response.setHeader("Content-Disposition", "attachment; fileName=\"" + pFileName + ".xls\"");
			workbook.write(response.getOutputStream());
			
			//workbook.close();
		}
		
		logger.debug("qstResultAnalysisSaveTotalA ended");
	}
	
	/**
	 * 근태 통계 Excel 내려받기 호출 함수
	 */
	@RequestMapping(value = "/ezStatistics/saticGetXlsWA.do", method = RequestMethod.POST)
	@ResponseBody
	public void qstResultAnalysisSaveWA(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception{
		logger.debug("qstResultAnalysisSaveM started");
		
		try (HSSFWorkbook workbook = new HSSFWorkbook()) {
			HSSFSheet sheet;
			
			HSSFCellStyle headerStyle= workbook.createCellStyle();
			headerStyle.setFillForegroundColor(HSSFColor.GREY_25_PERCENT.index);
			headerStyle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
			headerStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
			headerStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
			headerStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
			headerStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
			
			HSSFCellStyle bodyStyle= workbook.createCellStyle();
			bodyStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
			bodyStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
			bodyStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
			bodyStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
			
			Row row;
			Cell cell;
			
			String pFileName = "";
			String strDate = EgovDateUtil.getToday("-");
			pFileName = strDate+"_Report";
			
			String StrAnalysisDate = request.getParameter("saveExcelData").trim().replaceAll("&nbsp;", "").replaceAll("\r\n", "").replaceAll("\n", "").replaceAll("\t", "");
			
			Document analysisData = commonUtil.convertStringToDocument(StrAnalysisDate);
			
			Node tableNode = analysisData.getElementsByTagName("table").item(0);
			Node tableHeadNode;
			Node tableBodyNode;
			
			sheet = workbook.createSheet("report");
			tableHeadNode = tableNode.getChildNodes().item(0).getChildNodes().item(0);
			tableBodyNode = tableNode.getChildNodes().item(0);
			
			row = sheet.createRow(0);
			cell = row.createCell(0);
			cell.setCellValue(tableHeadNode.getChildNodes().item(0).getTextContent());
			cell = row.createCell(1);
			cell.setCellValue(tableBodyNode.getChildNodes().item(1).getChildNodes().item(0).getTextContent());
			
			row = sheet.createRow(1);
			for (int i=0; i<tableHeadNode.getChildNodes().getLength()-1; i++) {
				cell = row.createCell(i);
				cell.setCellValue(tableHeadNode.getChildNodes().item(i+1).getTextContent());
				cell.setCellStyle(headerStyle);
			}
			
			for (int i=0; i<tableBodyNode.getChildNodes().getLength()-1; i++) {
				row = sheet.createRow(i+2);
				Node tr = tableBodyNode.getChildNodes().item(i+1);
				
				for (int j=0; j<tr.getChildNodes().getLength(); j++) {
					if (i == 0) {
						if (j+1<tr.getChildNodes().getLength()) {
							cell = row.createCell(j);
							cell.setCellValue(tr.getChildNodes().item(j+1).getTextContent());
						}
					} else {
						cell = row.createCell(j);
						cell.setCellValue(tr.getChildNodes().item(j).getTextContent());
					}
	
					if (i == 1) {
						cell.setCellStyle(headerStyle);
					} else {
						cell.setCellStyle(bodyStyle);
					}
				}
			}
			
			response.setHeader("Content-Disposition", "attachment; fileName=\"" + pFileName + ".xls\"");
			workbook.write(response.getOutputStream());
			
			//workbook.close();
		}
		
		logger.debug("qstResultAnalysisSaveM ended");
	}

	/**
	 * call yearlyDocCount
	 */
	@RequestMapping(value = "/ezStatistics/callYearlyDocCount.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String callYearlyDocCount(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request,Model model, @RequestBody String xmlPara) throws Exception{
		logger.debug("callYearlyDocCount started  "+ xmlPara);

		StatApprVO statApprVO = new StatApprVO();

		ezStatisticsAdminService.yearlyDocCount(statApprVO);

		logger.debug("callYearlyDocCount ended ");

		return "success";
	}

	@RequestMapping(value = "/ezStatistics/saveExcel.do", method = RequestMethod.POST)
	@ResponseBody
	public void saveExcel(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String StrAnalysisDate = request.getParameter("saveExcelData").trim().replaceAll("&nbsp;", "")
				.replaceAll("\r\n", "").replaceAll("\n", "").replaceAll("\t", "");
		String fileName = egovMessageSource.getMessage("ezStatistics.pgb02", userInfo.getLocale());
		commonUtil.downloadHtmlTableAsExcel(StrAnalysisDate, response, fileName);
	}
}
