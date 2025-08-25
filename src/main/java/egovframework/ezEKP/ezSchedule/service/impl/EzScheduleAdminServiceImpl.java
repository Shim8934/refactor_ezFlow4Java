package egovframework.ezEKP.ezSchedule.service.impl;

import java.io.IOException;
import java.io.InputStream;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.annotation.Resource;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import egovframework.ezEKP.ezSchedule.service.EzScheduleService;
import egovframework.ezEKP.ezSchedule.vo.ScheduleExecutiveVO;
import egovframework.let.user.login.vo.LoginVO;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.ezEKP.ezSchedule.dao.EzScheduleAdminDAO;
import egovframework.ezEKP.ezSchedule.service.EzScheduleAdminService;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.ezEKP.ezSchedule.vo.ScheduleGroupListVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleGroupVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleShareVO;
import org.springframework.web.multipart.MultipartFile;
import org.w3c.dom.Document;
import org.w3c.dom.NodeList;

@Service("EzScheduleAdminService")
public class EzScheduleAdminServiceImpl implements EzScheduleAdminService{
	private static final Logger logger = LoggerFactory.getLogger(EzScheduleAdminServiceImpl.class);
	
	@Resource(name="EzScheduleAdminDAO")
	private EzScheduleAdminDAO ezScheduleAdminDAO;
	
	@Resource(name="EzScheduleService")
	private EzScheduleService ezScheduleService;
	
	@Autowired
	private CommonUtil commonUtil;

	
	@Override
	public String scheduleGetShareManage(String lang, int tenantId, String companyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_LANGDATA", lang);
		map.put("v_TENANTID", tenantId);
		map.put("v_COMPANYID", companyID);
		
		List<ScheduleShareVO> list = ezScheduleAdminDAO.scheduleGetShareManage(map);
		
		StringBuilder sb = new StringBuilder("<DATA>");
		
		for (int i=0; i < list.size(); i++) {
			ScheduleShareVO vo = list.get(i);
			sb.append(commonUtil.getQueryResult(vo));
		}		
		sb.append("</DATA>");
				
		return sb.toString();
	}

	@Override
	public void scheduleDelShareDept(String id, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_ID", id);
		map.put("v_TENANTID", tenantId);
		
		ezScheduleAdminDAO.scheduleDelShareDept(map);
	}

	@Override
	public void scheduleSaveShareDept(String userID, String userName, String userName2, String deptID, String deptName, String deptName2, int tenantId, String companyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", userID);
		map.put("v_USERNAME", userName);
		map.put("v_USERNAME2", userName2);
		map.put("v_DEPTID", deptID);
		map.put("v_DEPTNAME", deptName);
		map.put("v_DEPTNAME2", deptName2);
		map.put("v_TENANTID", tenantId);
		map.put("v_COMPANYID", companyID);
		
		ezScheduleAdminDAO.scheduleSaveShareDept(map);
	}

	@Override
	public void scheduleDelHoliday(String holidayID, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_HOLIDAYID", holidayID);
		map.put("v_TENANTID", tenantId);
		
		ezScheduleAdminDAO.scheduleDelHoliday(map);
		
		logger.debug("deleted holidayID : " + holidayID);
	}

	@Override
	public void scheduleChangeHolidayUse(String holidayID, String isUse, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_HOLIDAYID", holidayID);
		map.put("v_ISUSE", isUse);
		map.put("v_TENANTID", tenantId);
		
		ezScheduleAdminDAO.scheduleChangeHolidayUse(map);		
	}

	@Override
	public String scheduleSaveHoliday(String holidayName, String holidayName2, String holidayFlag, String holidayDate, String holidayRepeat, String isSolar, String isRepeat, String isRest, String companyID, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_HOLIDAYNAME", holidayName);
		map.put("v_HOLIDAYNAME2", holidayName2);
		map.put("v_HOLIDAYFLAG", holidayFlag);
		map.put("v_HOLIDAYDATE", holidayDate);
		map.put("v_HOLIDAYREPEAT", holidayRepeat);
		map.put("v_ISSOLAR", isSolar);
		map.put("v_ISREPEAT", isRepeat);
		map.put("v_ISREST", isRest);
		map.put("v_COMPANYID", companyID);
		map.put("v_TENANTID", tenantId);
		
		String holidayID = ezScheduleAdminDAO.scheduleSaveHoliday(map);
		
		logger.debug("Inserted holidayID : " + holidayID);
	
		return holidayID;
	}

	@Override
	public void scheduleUpdateHoliday(String holidayName, String holidayName2, String holidayFlag, String holidayDate, String holidayRepeat, String isSolar, String isRepeat, String isRest, String companyID, int tenantId, String holidayID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_HOLIDAYNAME", holidayName);
		map.put("v_HOLIDAYNAME2", holidayName2);
		map.put("v_HOLIDAYFLAG", holidayFlag);
		map.put("v_HOLIDAYDATE", holidayDate);
		map.put("v_HOLIDAYREPEAT", holidayRepeat);
		map.put("v_ISSOLAR", isSolar);
		map.put("v_ISREPEAT", isRepeat);
		map.put("v_ISREST", isRest);
		map.put("v_COMPANYID", companyID);
		map.put("v_TENANTID", tenantId);		
		map.put("v_HOLIDAYID", holidayID);
		
		ezScheduleAdminDAO.scheduleUpdateHoliday(map);	
	}

	@Override
	public void scheduleInsertLunarUse(String companyID, String lunarUse, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_COMPANYID", companyID);
		map.put("v_LUNARUSE", lunarUse);
		map.put("v_TENANTID", tenantId);
				
		ezScheduleAdminDAO.scheduleInsertLunarUse(map);	
	}

	@Override
	public void scheduleUpdateLunarUse(String companyID, String lunarUse, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_COMPANYID", companyID);
		map.put("v_LUNARUSE", lunarUse);
		map.put("v_TENANTID", tenantId);
				
		ezScheduleAdminDAO.scheduleUpdateLunarUse(map);	
	}

	@Override
	public void scheduleInsertRegi(String companyID, String regi, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_COMPANYID", companyID);
		map.put("v_REGI", regi);
		map.put("v_TENANTID", tenantId);
				
		ezScheduleAdminDAO.scheduleInsertRegi(map);	
	}

	@Override
	public void scheduleUpdateRegi(String companyID, String regi, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_COMPANYID", companyID);
		map.put("v_REGI", regi);
		map.put("v_TENANTID", tenantId);
				
		ezScheduleAdminDAO.scheduleUpdateRegi(map);			
	}

	@Override
	public int scheduleShareCheck(String userID, String deptID, int tenantId, String companyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", userID);
		map.put("v_DEPTID", deptID);
		map.put("v_TENANTID", tenantId);
		map.put("v_COMPANYID", companyID);
				
		return ezScheduleAdminDAO.scheduleShareCheck(map);
	}
	

	@Override
	public List<ScheduleGroupListVO> getMyGroupList(String offset, String userID, int tenantID, String companyID, String searchType2, String searchValue, String startDate, String endDate) throws Exception {	
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", userID);
		map.put("v_TENANTID", tenantID);
		map.put("v_COMPANYID", companyID);
		map.put("v_SEARCHTYPE", searchType2);
		map.put("v_SEARCHVALUE", searchValue);
		map.put("v_STARTDATE", startDate);
		map.put("v_ENDDATE", endDate);
		map.put("offset", offset);
		
		List<ScheduleGroupListVO> gList = ezScheduleAdminDAO.getMyGroupList(map);
		
		return gList;
	}
	
	

	@Override
	public List<ScheduleGroupVO> getMyGroupList2 (String offset, String userId, int tenantId ,String companyID, String searchType2, String searchValue, String startDate, String endDate, int startRow, int maxItemPerPage, String primaryData) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", userId);
		map.put("v_TENANTID", tenantId);
		map.put("v_COMPANYID", companyID);
		map.put("v_SEARCHTYPE", searchType2);
		map.put("v_SEARCHVALUE", searchValue);
		map.put("v_STARTDATE", startDate);
		map.put("v_ENDDATE", endDate);
		map.put("v_STARTROW", startRow);
		map.put("v_MAXITEMPERPAGE", maxItemPerPage);
		map.put("offset", offset);
		map.put("v_PRIMARYDATA", primaryData);
	
		
		List<ScheduleGroupVO> gList = ezScheduleAdminDAO.getMyGroupList2(map);
		
		return gList;
	}

	@Override
	public int getMyGroupMemberListCnt(String groupId, String lang, int tenantId, String companyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_GROUPID", groupId);
		map.put("v_LANG", lang);
		map.put("v_TENANTID", tenantId);
		map.put("v_COMPANYID", companyID);
		
		int cnt = ezScheduleAdminDAO.getMyGroupMemberListCnt(map);
		
		return cnt;
	}

	@Override
	public String scheduleGetExecutiveList(String cn, String companyID, int tenantID, String offset, String keyword, String lang, String companyName) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("cn", cn);
		map.put("v_COMPANYID", companyID);
		map.put("v_TENANTID", tenantID);
		map.put("v_KEYWORD", keyword);
		map.put("v_LANG", lang);
		map.put("v_COMPANYNAME", companyName);

		List<ScheduleExecutiveVO> list = ezScheduleAdminDAO.scheduleGetExecutiveList(map);

		StringBuilder sb = new StringBuilder("<DATA>");

		for (int i=0; i < list.size(); i++) {
			ScheduleExecutiveVO vo = list.get(i);
			vo.setLastUpdate(commonUtil.getDateStringInUTC(vo.getLastUpdate(), offset, false));
			sb.append(commonUtil.getQueryResult(vo));
		}
		sb.append("</DATA>");

		return sb.toString();
	}

	@Override
	public void scheduleSaveExecutive(String userID, int priority, String usage, String createUser, String companyID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", userID);
		map.put("v_PRIORITY", priority);
		map.put("v_USAGE", usage);
		map.put("v_CREATEUSER", createUser);
		map.put("v_SYSDATE", commonUtil.getTodayUTCTime(""));
		map.put("v_TENANTID", tenantID);
		map.put("v_COMPANYID", companyID);

		ezScheduleAdminDAO.scheduleSaveExecutive(map);
	}

	@Override
	public void scheduleUpdateExecutive(String userID, int priority, String usage, String createUser, String companyID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", userID);
		map.put("v_PRIORITY", priority);
		map.put("v_USAGE", usage);
		map.put("v_CREATEUSER", createUser);
		map.put("v_SYSDATE", commonUtil.getTodayUTCTime(""));
		map.put("v_TENANTID", tenantID);
		map.put("v_COMPANYID", companyID);

		ezScheduleAdminDAO.scheduleUpdateExecutive(map);
	}

	@Override
	public void scheduleDelExecutive(String userID, String companyID, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", userID);
		map.put("v_TENANTID", tenantId);
		map.put("v_COMPANYID", companyID);

		ezScheduleAdminDAO.scheduleDelExecutive(map);

		logger.debug("deleted holidayID : " + userID);
	}

	@Override
	public void scheduleNumUpdateExecutive(String userID, int priority, String companyID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", userID);
		map.put("v_PRIORITY", priority);
		map.put("v_TENANTID", tenantID);
		map.put("v_COMPANYID", companyID);

		ezScheduleAdminDAO.scheduleUpdateExecutive(map);
	}

	@Override
	public String companyScheduleExcelUpload(String userID, MultipartFile uploadFile, String companyID, String companyName, String companyName2, LoginVO userInfo, String defaultPath, String content) throws Exception {

		try {
			DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
			DocumentBuilder builder = factory.newDocumentBuilder();
			Document doc = builder.newDocument();
			
			NodeList attach = doc.getElementsByTagName("");
			
			InputStream file = uploadFile.getInputStream();

			Workbook workbook = new XSSFWorkbook(file);

			int sheetCount = workbook.getNumberOfSheets();
			
			// 등록된 양식이 아닌지 먼저 체크 후 아닐 경우 업로드 취소
			for (int i = 0; i < sheetCount; i++) {
				Sheet sheet = workbook.getSheetAt(i);

				Row rowB01 = sheet.getRow(0);
				if (rowB01 == null || rowB01.getCell(1) == null) {
					return "{\"status\":\"FORM_ERROR\"}";
				}

				// 두 번째 셀 값 가져오기
				String valueB01 = rowB01.getCell(1).toString();

				if (!valueB01.startsWith("달력연도")) {
					return "{\"status\":\"FORM_ERROR\"}";
				}	
			}

			for (int i = 0; i < sheetCount; i++) {
				Sheet sheet = workbook.getSheetAt(i);
				
				Row yearRow = sheet.getRow(0);
				Cell yearCell = yearRow.getCell(1);
				String dateString = ((XSSFCell) yearCell).getRawValue();
				Pattern pattern = Pattern.compile("(\\d{4})년 (\\d{1,2})월");
				Matcher matcher = pattern.matcher(dateString);

				String year = "";
				String month = "";
				if (matcher.find()) {
					year = matcher.group(1);
					month = matcher.group(2);
				}
				
				List<List<String>> cellGroups = new ArrayList<>();
				
				// B3:H12, B13:C:14 영역 데이터
				for (int rowIndex = 2; rowIndex < 16; rowIndex += 2) {	// 2행씩 이동
					int colEndIndex = 8;
					if (rowIndex == 14) colEndIndex = 3;
					
					for (int colIndex = 1; colIndex < colEndIndex; colIndex++) {	// B열 부터 H열 까지 마지막 rowIndex 에서는 C열까지만 반복
						boolean checkValue = false;
						List<String> cellGroup = new ArrayList<>();
	
						for (int j = 0; j < 2; j++) {
							Row row = sheet.getRow(rowIndex + j);
	
							if (row != null) {
								Cell cell = row.getCell(colIndex);
								if (cell != null) {
									if (j == 0 && cell.getCellType() == Cell.CELL_TYPE_FORMULA) {
										String convertingData = convertingExcelDate(((XSSFCell) cell).getRawValue());
										//if (year.equals(convertingData.split("-")[0]) && month.equals(convertingData.split("-")[1]))
										cellGroup.add(convertingData);
									} else if (j == 1 && cell.getCellType() == Cell.CELL_TYPE_STRING) {
										if (!"".equals(cell.toString()) && cell.toString() != null) {
											// 일정 제목 데이터 100자 제한하기
											if (cell.toString().length() <= 100)
												checkValue = true;
										}
										cellGroup.add(cell.toString());
									}
								}
							}
						}
						// 일정 데이터가 있을 경우에만 넣어주기
 						if (checkValue) cellGroups.add(cellGroup);
					}
				}
				for (List<String> item : cellGroups) {
					String scheduleDate = item.get(0);
					String title = item.get(1);
					
					String startDate = scheduleDate + " 00:00";
					String endDate = scheduleDate + " 23:59";

					startDate = commonUtil.getDateStringInUTC(startDate, userInfo.getOffset(), true);
					endDate = commonUtil.getDateStringInUTC(endDate, userInfo.getOffset(), true);
					
					// 회사 일정 DB 인서트 작업
					ezScheduleService.insertSchedule(companyID, companyName, companyName2, userID, userInfo.getDisplayName(), userInfo.getDisplayName2(), "3", "2", "Y", "2", startDate, endDate, "", title, "", content, attach,
							null, null, null, null, null, defaultPath, userInfo.getTenantId(), companyID, "N", userInfo.getOffset(), userInfo.getLang());
				}
				
			}
			file.close();
		} catch (IOException e) {
			e.fillInStackTrace();
			
			return "{\"status\":\"ERROR\"}";
		}

		return "{\"status\":\"SUCCESS\"}";
	}

	public String convertingExcelDate(String excelSerialDate) {
		LocalDate excelStartDate = LocalDate.of(1900, 1, 1);	// 엑셀의 경우 1900년 01월 01일을 기준으로 계산됨
		
		LocalDate localDate = excelStartDate.plusDays(Integer.parseInt(excelSerialDate) - 2);
		
		String formattedDate = "";
		formattedDate = localDate.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
		
		return formattedDate;
	}
}

