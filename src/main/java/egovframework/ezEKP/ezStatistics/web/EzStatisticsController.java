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

import egovframework.ezEKP.ezQuestion.web.EzQuestionController;
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
	
	private static final Logger logger = LoggerFactory.getLogger(EzQuestionController.class);
	
	@Autowired
	CommonUtil commonUtil;
	
	/**
	 * 통계 메인화면 호출 함수
	 */
	@RequestMapping(value="/ezStatistics/statisticsMain.do")
	public String showMain() throws Exception {		
		return "ezStatistics/statisticsMain";
	}
	
	@RequestMapping(value = "/ezStatistics/saticGetXls.do")
	public void qstResultAnalysisSave(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception{
		
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

		for(int i=0; i<tableHeadNode.getChildNodes().getLength(); i++){
			cell = row.createCell(i);
			cell.setCellValue(tableHeadNode.getChildNodes().item(i).getTextContent());
			cell.setCellStyle(headerStyle);
		}
		
		for(int i=0; i<tableBodyNode.getChildNodes().getLength()-1; i++){
			row = sheet.createRow(i+1);
			Node tr = tableBodyNode.getChildNodes().item(i+1);
			
			for(int j=0; j<tr.getChildNodes().getLength(); j++){
				cell = row.createCell(j);
				cell.setCellValue(tr.getChildNodes().item(j).getTextContent());
				cell.setCellStyle(bodyStyle);
			}
		}
		
		
		response.setHeader("Content-Disposition", "attachment; fileName=\"" + pFileName + ".xls\"");
		workbook.write(response.getOutputStream());
	}
}
