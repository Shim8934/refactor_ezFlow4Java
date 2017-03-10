package egovframework.ezEKP.ezStatistics.web;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.w3c.dom.Document;
import org.w3c.dom.Node;

import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;

@Controller
public class EzStatisticsController {
	
	private static final Logger logger = LoggerFactory.getLogger(EzStatisticsController.class);
	
	@Autowired
	CommonUtil commonUtil;
	
	/**
	 * 통계 메인화면 호출 함수
	 */
	@RequestMapping(value="/ezStatistics/statisticsMain.do")
	public String showMain() throws Exception {		
		return "ezStatistics/statisticsMain";
	}
	
	/**
	 * 사용자 접속 통계, 사용자 브라우져 통계 Excel 내려받기 호출
	 */
	@RequestMapping(value = "/ezStatistics/saticGetXls.do")
	public void qstResultAnalysisSave(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception{
		logger.debug("qstResultAnalysisSave started");
		
		@SuppressWarnings("resource")
		HSSFWorkbook workbook = new HSSFWorkbook();
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
		pFileName = strDate+"_Report.xls";
		
		String StrAnalysisDate = request.getParameter("saveExcelData").trim().replaceAll("&nbsp;", "").replaceAll("\r\n", "").replaceAll("\n", "").replaceAll("\t", "");
		
		Document analysisData = commonUtil.convertStringToDocument(StrAnalysisDate);
		
		Node tableNode = analysisData.getElementsByTagName("table").item(0);
		Node tableHeadNode;
		Node tableBodyNode;
		
		sheet = workbook.createSheet("report");
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
		
		response.setHeader("Content-Disposition", "attachment; fileName=\"" + pFileName + ".xls\"");
		workbook.write(response.getOutputStream());
		
		logger.debug("qstResultAnalysisSave ended");
	}
	
	/**
	 * 메일 통계 Excel 내려받기 호출
	 */
	@RequestMapping(value = "/ezStatistics/saticGetXlsM.do")
	public void qstResultAnalysisSaveM(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception{
		logger.debug("qstResultAnalysisSaveM started");
		
		String headerFLAG = "";
		
		if (request.getParameter("headerFlag") != null) {
			headerFLAG = request.getParameter("headerFlag");
        }
		
		HSSFWorkbook workbook = new HSSFWorkbook();
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
		pFileName = strDate+"_Report.xls";
		
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
		
		logger.debug("qstResultAnalysisSaveM ended");

		workbook.close();
	}
	
	/**
	 * 사용자 OS 통계 Excel 내려받기 호출
	 */
	@RequestMapping(value = "/ezStatistics/UserOSsaticXls.do")
	public void getUserOSsaticXls(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception{
		logger.debug("getUserOSsaticXls started");
		
		HSSFWorkbook workbook = new HSSFWorkbook();
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
		pFileName = strDate+"_Report.xls";
		sheet = workbook.createSheet("report");
		
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
				row = sheet.createRow(6);
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
					row = sheet.createRow(j+7);
					Node tr = tableBodyNode.getChildNodes().item(j+1);
					
					for (int k=0; k<tr.getChildNodes().getLength(); k++) {
						cell = row.createCell(k);
						cell.setCellValue(tr.getChildNodes().item(k).getTextContent());
						cell.setCellStyle(bodyStyle);
					}
				}
			}
		}		
		
		response.setHeader("Content-Disposition", "attachment; fileName=\"" + pFileName + ".xls\"");
		workbook.write(response.getOutputStream());
		
		logger.debug("getUserOSsaticXls ended");

		workbook.close();
	}
}
