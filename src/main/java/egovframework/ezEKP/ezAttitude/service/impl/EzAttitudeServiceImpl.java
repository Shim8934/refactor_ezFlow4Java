package egovframework.ezEKP.ezAttitude.service.impl;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;
import javax.mail.internet.InternetAddress;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.w3c.dom.Document;

import com.ibm.icu.text.DecimalFormat;
import com.ibm.icu.text.SimpleDateFormat;
import com.ibm.icu.util.Calendar;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGService;
import egovframework.ezEKP.ezAttitude.dao.EzAttitudeDAO;
import egovframework.ezEKP.ezAttitude.service.EzAttitudeService;
import egovframework.ezEKP.ezAttitude.util.ExcelCellRef;
import egovframework.ezEKP.ezAttitude.vo.AdminAttitudeVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeAnnualVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeApplicationVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeAuthorVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeConfigVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeDeptVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeFormVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeStatisVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeTypeVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeUserConfigVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeVO2;
import egovframework.ezEKP.ezAttitude.vo.DeptViewVO;
import egovframework.ezEKP.ezAttitude.vo.HolidayVO;
import egovframework.ezEKP.ezAttitude.vo.ModApplHistoryVO;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezOrgan.dao.EzOrganDAO;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.ezEKP.ezPersonal.service.EzPersonalService;
import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.KoreanLunarCalendar;

@Service("EzAttitudeService")
public class EzAttitudeServiceImpl extends EgovAbstractServiceImpl implements EzAttitudeService{
	private static final Logger logger = LoggerFactory.getLogger(EzAttitudeServiceImpl.class);
	private static final int defaultAnnualHolidayCnt = 15; // 기본 연차 발생 수
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private EzCommonService ezCommonService;
	
	@Autowired
	private EzOrganService ezOrganService;
	
	@Autowired
	private EzEmailService ezEmailService;
	
	@Autowired
	private EzPersonalService ezPersonalService;
	
	@Autowired
	private EzApprovalGService ezApprovalGService;
	
	@Autowired
	private EzAttitudeDAO ezAttitudeDAO;
	
	@Autowired
	private EgovMessageSource messageSource;
	
	@Resource(name = "EzOrganDAO")
	private EzOrganDAO ezOrganDAO;
	
	@Resource(name = "excelCellRef")
	private ExcelCellRef excelCellRef;
		
	@Override
	public AttitudeVO getAttitudeInfo(String attitudeId, String offset, String lang, String companyId, int tenantId) throws Exception {
		logger.debug("getAttitudeInfo started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("attitudeId", attitudeId);
		map.put("offsetMin", commonUtil.getMinuteUTC(offset));
		if (lang.equals("1")) {
			lang = "";
		}
		map.put("lang", lang);
		map.put("tenantId", tenantId);
		
		AttitudeVO attitudeVO = ezAttitudeDAO.getAttitudeInfo(map);
		AttitudeApplicationVO annualCanVO = new AttitudeApplicationVO(); 
		if (attitudeVO.getAnnualApprStatus().equals("1") && attitudeVO.getModAppl().equals("1")) {
			Map<String, Object> map2 = new HashMap<String, Object>();
			map2.put("companyId", companyId);
			map2.put("tenantId", tenantId);
			map2.put("attModId", attitudeId);
			map2.put("offset", commonUtil.getMinuteUTC(offset));
			map2.put("lang", lang);
			annualCanVO = ezAttitudeDAO.annCanAppDetail(map2);
			attitudeVO.setContent(annualCanVO.getContent());
		}
		
		logger.debug("getAttitudeInfo ended");
		
		return attitudeVO;
	}

	@Override
	public void insertAttitude(String writerId, String deptId, String startDate,
			String endDate, String region, String mobile, String bizsub, String content,
			String ip, String typeId, String dateType, String offset, String companyId, int tenantId, String mode, String adminId, String attendType, String latitude, String longitude) throws Exception {
		logger.debug("insertAttitude started");
		
		if (mode == null) {
			mode = "";
		}
		
		if (attendType == null) {
			attendType = "0";
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("writerId", writerId);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("offsetMin", commonUtil.getMinuteUTC(offset));
		
		String workStatus = null;
		if (typeId.equals("A01") || typeId.equals("A03") || typeId.equals("A25")) {
			if (!mode.equals("admin")) {
				startDate = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), offset, false);
				
				if (typeId.equals("A01")) {
					//사용자별 근태설정이 있는 지 검사
					String isValue = ezAttitudeDAO.getIsAttitudeUserConf(map);
					map.put("isValue", isValue);
					
					AttitudeUserConfigVO resultVO = ezAttitudeDAO.getAttitudeConfTime(map);
					
					String compareDate = startDate.substring(11);
					String resultConfDate = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime("yyyy-MM-dd") + " " + resultVO.getWorkStartTime() + ":00", offset, false).substring(11);
					
					SimpleDateFormat f = new SimpleDateFormat("HH:mm:ss");
					
					Date userConfTime = f.parse(resultConfDate);
					Date userInTime = f.parse(compareDate);
					
					if (userInTime.after(userConfTime)) { //지각인 경우
						typeId = "A02";
					}
				} else {
					//2020-08-06 김정언 - 일근무/반근무 추가
					String startDate2 = "";
					if(typeId.equals("A25")) {
						startDate2 = commonUtil.getDayBefore(startDate.split(" ")[0]);
					} else {
						startDate2 = startDate.split(" ")[0];
					}
					map.put("startDate2", startDate2);
					//출근/지각 시간 체크
					String attitudeTime = ezAttitudeDAO.getAttitudeTime(map);
					
					long minutes = commonUtil.getTimeDifference(attitudeTime.split("\\.")[0], startDate);
					
					if(minutes >= 480) {
						workStatus = "D";
					} else if (minutes >= 240) {
						workStatus = "H";						
					}
				}
				
			} else {
				startDate += ":00";
			}
		}
		
		content = content.replaceAll("\'", "&#39;").replaceAll("(\r\n|\r|\n|\n\r)", " ");
		
		map.put("typeId", typeId);
		map.put("offsetMin", commonUtil.getMinuteUTC(offset));
		map.put("deptId", deptId);
		map.put("startDate", startDate);
		map.put("endDate", endDate);
		map.put("region", region);
		map.put("mobile", mobile);
		map.put("bizSub", bizsub);
		map.put("content", content);
		map.put("ipAddress", ip);
		map.put("dateType", dateType);
		map.put("modappl", mode.equals("admin") ? "3" : "0");
		map.put("attendType", attendType);
		if(attendType.equals("1")) {
			map.put("latitude", latitude);
			map.put("longitude", longitude);
		}
		if(typeId.equals("A03") || typeId.equals("A25")){
			map.put("workStatus", workStatus);
		}
		
		ezAttitudeDAO.insertAttitude(map);
		
		if (mode.equals("admin")) {
			map.put("adminId", adminId);
			map.put("apprDate", commonUtil.getTodayUTCTime(""));
			
			ezAttitudeDAO.insertAdminAttHistory(map);
			
			if (typeId.equals("A01") || typeId.equals("A02")) {
				map.put("applDate", commonUtil.getTodayUTCTime(""));
				map.put("originDate", startDate);
				map.put("changeDate", startDate);
				
				ezAttitudeDAO.adminAttSaveAppMod(map);
			}
		}
		
		logger.debug("insertAttitude ended");
	}

	@Override
	public List<AttitudeVO> getAttitudeList(String pidList, String deptIdList, String yrmh,
		String typeId, String startDate, String endDate, String offset, String deptFlag, String lang,String companyId, int tenantId) throws Exception {
		logger.debug("getAttitudeList started");
		
		Map<String, Object> map = new HashMap<String,Object>();
		
		//startDate와 endDate가 없는 경우 당일의 근태를  출력
		if (startDate.equals("") && endDate.equals("")) {
			String localDate = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), offset, false).split(" ")[0];
			startDate = localDate + " 00:00:00";
			endDate = localDate + " 23:59:59";
		} else if (!startDate.equals("") && endDate.equals("")) {
			endDate = startDate + " 23:59:59"; 
			startDate = startDate + " 00:00:00";
		} else if (typeId.equals("A25")) {
			String dayAfter = commonUtil.getDayAfter(startDate);
			
			//전날 퇴근한 경우
			startDate = dayAfter + " 00:00:00";
			endDate = dayAfter + " 23:59:59";
		} else {
			startDate = startDate + " 00:00:00";
			endDate = endDate + " 23:59:59";
		}

		map.put("startDate", startDate);
		map.put("endDate", endDate);
		map.put("tenantId", tenantId);
		if (lang.equals("1")) {
			lang = "";
		} else {
			lang = "2";
		}
		map.put("lang", lang);
		map.put("offsetMin", commonUtil.getMinuteUTC(offset));
		
		if (!typeId.trim().equals("")){
			map.put("typeId", typeId);
		}
		if (!pidList.trim().equals("")){
			map.put("pidListArr", pidList.split(","));
		}
		if (!deptIdList.trim().equals("")){
			map.put("deptIdArr", deptIdList.split(","));
		}
	
		List<AttitudeVO> resultList = ezAttitudeDAO.getAttitudeList(map);
		
		for (int i = 0; i < resultList.size() ; i++) {
			resultList.get(i).setBizSub(commonUtil.cleanValue(resultList.get(i).getBizSub()));
			resultList.get(i).setMobile(commonUtil.cleanValue(resultList.get(i).getMobile()));
			resultList.get(i).setRegion(commonUtil.cleanValue(resultList.get(i).getRegion()));
		}
		
		if(deptFlag.equals("true") && typeId.trim().equals("") && startDate.compareTo(commonUtil.getTodayUTCTime("")) <= 0) {
			
			map.put("companyId", companyId);
			map.put("searchStartDate", startDate);
			map.put("searchEndDate", endDate);
			map.put("searchDeptId", deptIdList.split(",")[0]);
			
			if (checkHoliday2(startDate.substring(0,10), endDate.substring(0,10), companyId, tenantId).size() < 1) {				
				List<AdminAttitudeVO> absentresultList = ezAttitudeDAO.getAttitudeAbsentList(map);
				
				if(!absentresultList.isEmpty()) {
					for(AdminAttitudeVO v : absentresultList) {
						AttitudeVO a = new AttitudeVO();
						a.setTypeId(v.getTypeId());
						a.setTypeName(v.getTypeName());
						a.setWriterId(v.getWriterId());
						a.setWriterName(v.getUserName());
						a.setTenantId(v.getTenantId());
						resultList.add(a);
					}
				}
			}
		} 
		logger.debug("getAttitudeList ended");
		
		return resultList;
	}

	@Override
	public List<AttitudeStatisVO> getAttitudeStatisticsList(String pidList, String deptIdList, String offset,
			String startDate, String endDate, int tenantId, String deptFlag) throws Exception {
		logger.debug("getAttitudeStatisticsList started");
		
		Map<String, Object> map = new HashMap<String, Object>();

		map.put("offsetMin", commonUtil.getMinuteUTC(offset));
		map.put("startDate", startDate);
		map.put("endDate", endDate);
		map.put("tenantId", tenantId);
		
		if (!pidList.trim().equals("")){
			map.put("pidListArr", pidList.split(","));
		}
		if (!deptIdList.trim().equals("")){
			map.put("deptIdArr", deptIdList.split(","));
		}
		
		logger.debug("getAttitudeStatisticsList ended");
		return ezAttitudeDAO.getAttitudeStatisList(map);
	}

	@Override
	public List<AttitudeTypeVO> getAttitudeTypeList(String companyId, String isuse, String isAdmin, String statistics, String typeIdArr, int tenantId, String primary, String type) throws Exception {
		logger.debug("getAttitudeTypeList started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		map.put("isuse", isuse);
		map.put("isAdmin", isAdmin);
		map.put("statistics", statistics);
		map.put("type", type);
		map.put("typeIdArr", (!"".equalsIgnoreCase(typeIdArr) ? typeIdArr.split(",") : ""));
		if (primary.equals("1")) {
			primary = "";
		}
		map.put("primary", primary);
		
		logger.debug("getAttitudeTypeList ended");
		
		return ezAttitudeDAO.getAttitudeTypeList(map);
	}

	@Override
	public AttitudeFormVO getFormBody(String typeId, String companyId, int tenantId, String lang) throws Exception {
		logger.debug("getFormBody started");
		
		if (lang.equals("1")) {
			lang = "";
		}else {
			lang = "2";
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("lang", lang);
		map.put("typeId", typeId);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		logger.debug("getFormBody ended");
		
		return ezAttitudeDAO.getFormBody(map);
	}

	@Override
	public void updateAttitude(String attitudeId, String startDate, String endDate, String region,
			String mobile, String bizSub, String content, String offset, String ip, String typeId, String dateType, String mode, AttitudeVO attVO, String adminId, 
			MCommonVO info, MCommonVO userInfo, int tenantId, String companyId, String latitude, String longitude) throws Exception{
		logger.debug("updateAttitude started");
		
		content = content.replaceAll("\'", "&#39;").replaceAll("(\r\n|\r|\n|\n\r)", " ");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("attitudeId", attitudeId);
		map.put("startDate", startDate);
		map.put("endDate", endDate);
		map.put("region", region);
		map.put("mobile", mobile);
		map.put("bizSub", bizSub);
		map.put("content", content);
		map.put("offsetMin", commonUtil.getMinuteUTC(offset));
		map.put("ipAddress", ip);
		map.put("typeId", typeId);
		map.put("dateType", dateType);
		map.put("tenantId", tenantId);
		map.put("companyId", attVO.getCompanyId());
		map.put("latitude", latitude);
		map.put("longitude", longitude);
		
		if (mode.equals("admin")) {
			map.put("modappl", "3");
		}
		
		ezAttitudeDAO.updateAttitude(map);
		
		if(startDate != null && !mode.equals("admin")) {	
			if(typeId.equals("A03") || typeId.equals("A25")) {				
				//2020-08-06 김정언 - 일근무/반근무 추가
				map.put("writerId", adminId);
				String workStatus = null;
				String startDate2 = "";
				if(typeId.equals("A25")) {
					startDate2 = commonUtil.getDayBefore(startDate.split(" ")[0]);
				} else {
					startDate2 = startDate.split(" ")[0];
				}
				map.put("startDate2", startDate2);
				//출근/지각 시간 체크
				String attitudeTime = ezAttitudeDAO.getAttitudeTime(map);
				
				long minutes = commonUtil.getTimeDifference(attitudeTime.split("\\.")[0], startDate);
				
				if(minutes >= 480) {
					workStatus = "D";
				} else if (minutes >= 240) {
					workStatus = "H";						
				}
				
				map.put("workStatus", workStatus);
				ezAttitudeDAO.updateWorkStatus(map);
			}
		}
		
		if (mode.equals("admin")) {
			map.put("attVO", attVO);
			map.put("adminId", adminId);
			map.put("adminCompanyId", companyId);
			map.put("apprDate", commonUtil.getTodayUTCTime(""));
			map.put("userInfo", userInfo);
			map.put("adminInfo", info);
			
			ezAttitudeDAO.insertAdminAttHistory2(map);
			
			/**관리자가 수정한 것 중에 기존 타입이 A02인 경우
			 * 지각 수정신청까지 신경써줘야한다.
			 * 신청 상태의 신청내역은 반려로 바꾸고 지금 반영된 부분은
			 * 신청내역에 승인으로 기록한다.
			 */
			if (attVO.getTypeId().equals("A02") || (attVO.getTypeId().equals("A01") && !attVO.getModAppl().equals("0"))) {
				map.put("attModId", attitudeId);
				map.put("offset", commonUtil.getMinuteUTC(offset));
				
				String apprStatus = ezAttitudeDAO.checkModApplStatus(map);
				//가장 마지막에 신청한 근태수정신청내역이 신청 상태가 아닐 경우
				if (apprStatus != null) {
					if (!apprStatus.equals("0")) {
						
					} else {
						//마지막에 신청한 근태수정신청이 신청상태인 경우
						map.put("ids", attitudeId);
						map.put("changeStatus", "ret");
						map.put("apprDate", commonUtil.getTodayUTCTime(""));
						
						ezAttitudeDAO.adminChangeUsersModAtt(map);
					}
				}
				
				map.put("applDate", commonUtil.getTodayUTCTime(""));
				map.put("originDate", attVO.getStartDate());
				map.put("changeDate", startDate);
				
				ezAttitudeDAO.adminAttSaveAppMod(map);
			}
		}
		
		logger.debug("updateAttitude ended");
	}

	@Override
	public void deleteAttitude(String attitudeId, int tenantId, String mode, AttitudeVO attitudeVO, String offset, MCommonVO info, MCommonVO userInfo)
			throws Exception {
		logger.debug("deleteAttitude started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("attitudeId", attitudeId);
		map.put("tenantId", tenantId);
		
		if (mode.equals("admin")) {
			logger.debug("admin history write");
			//정보 읽어와서 히스토리에 삭제라고 기록할거
			map.put("attVO", attitudeVO);
			map.put("adminId", info.getUserId());
			map.put("apprDate", commonUtil.getTodayUTCTime(""));
			map.put("offsetMin", commonUtil.getMinuteUTC(offset));
			map.put("adminInfo", info);
			map.put("userInfo", userInfo);
			ezAttitudeDAO.insertAdminAttHistory3(map);
		}
		
		ezAttitudeDAO.deleteAttitude(map);
		
		logger.debug("deleteAttitude ended");
	}

	@Override
	public void editAttitudeUserConfig(String selectedUserIdList, String workStartTime, String workEndTime, String gubun, String offSet, String companyId, int tenantId) throws Exception {
		logger.debug("editAttitudeUserConfig started");
		logger.debug("selectedUserIdList = " + selectedUserIdList + " || workStartTime = " + workStartTime + " || workEndTime = " + workEndTime + " || gubun = " + gubun);
		
		String today =  commonUtil.getTodayUTCTime("yyyy-MM-dd");
		String startDate = commonUtil.getDateStringInUTC(today + " " + workStartTime, offSet, true);
		String endDate = commonUtil.getDateStringInUTC(today + " " + workEndTime, offSet, true);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		map.put("workStartTime", startDate.substring(11));
		map.put("workEndTime", endDate.substring(11));
		
		if (gubun.equals("0")) {
			map.put("selectedUserIdList", selectedUserIdList.split(", "));
			
			ezAttitudeDAO.deleteAttitudeUserConfig(map);
		} else {
			for (String selectedUserId : selectedUserIdList.split(", ")) {
				map.put("selectedUserId", selectedUserId);
				
				ezAttitudeDAO.saveAttitudeUserConfig(map);
			}
		}
		
		logger.debug("saveAttitudeUserConfig ended");
	}
	@Override
	public void editAttitudeDeptConfig(String selectDeptIds, String workStartTime, String workEndTime, String gubun, String offSet, String companyId, int tenantId) throws Exception {
		logger.debug("editAttitudeUserConfig started");
		logger.debug("selectDeptId = " + selectDeptIds + " || workStartTime = " + workStartTime + " || workEndTime = " + workEndTime + " || gubun = " + gubun);
		
		String today =  commonUtil.getTodayUTCTime("yyyy-MM-dd");
		String startDate = commonUtil.getDateStringInUTC(today + " " + workStartTime, offSet, true);
		String endDate = commonUtil.getDateStringInUTC(today + " " + workEndTime, offSet, true);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		map.put("workStartTime", startDate.substring(11));
		map.put("workEndTime", endDate.substring(11));
		
		if (gubun.equals("0")) {
			map.put("selectDeptId", selectDeptIds.split(","));
			
			ezAttitudeDAO.deleteAttitudeDeptConfig(map);
		} else {
			for (String selectDeptId : selectDeptIds.split(",")) {
				
				map.put("selectDeptId", selectDeptId);
				
				ezAttitudeDAO.saveAttitudeDeptConfig(map);
			}
		}
		
		logger.debug("saveAttitudeUserConfig ended");
	}

	@Override
	public AttitudeConfigVO getAttitudeConfig(int tenantId, String companyId)
			throws Exception {
		logger.debug("getAttitudeConfig started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		
		logger.debug("getAttitudeConfig ended");
		
		return ezAttitudeDAO.getAttitudeConfig(map);
	}

	@Override
	public void updateAttitudeConfig(String workStartTime, String workEndTime, String closedDay, String attitudeModAppl, String closedDateAttitude, String confSetDate, String companyId, int tenantId) throws Exception {
		logger.debug("updateAttitudeConfig started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		map.put("workStartTime", workStartTime);
		map.put("workEndTime", workEndTime);
		map.put("closedDay", closedDay);
		map.put("attitudeModAppl", attitudeModAppl);
		map.put("closedDateAttitude", closedDateAttitude);
		map.put("confSetDate", confSetDate);
		
		ezAttitudeDAO.updateAttitudeConfig(map);
		
		logger.debug("updateAttitudeConfig ended");
	}

	@Override
	public void updateAttitudeTypeConfig(String typeConfigList, String companyId, int tenantId) throws Exception {
		logger.debug("updateAttitudeTypeConfig started");
		logger.debug("typeConfigList = " + typeConfigList);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		
		for (String typeInfoList : typeConfigList.split(";")) {
			String[] typeInfo = typeInfoList.split(",");
			
			map.put("typeId", typeInfo[0]);
			map.put("isuse", typeInfo[1]);
			
			ezAttitudeDAO.updateAttitudeTypeConfig(map);
		}
		
		logger.debug("updateAttitudeTypeConfig ended");
	}

	@Override
	public boolean insertAttitudeType(String typeName, String typeName2, int tenantId, String companyId, String primary) throws Exception {
		logger.debug("insertAttitudeType started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("typeName", typeName);
		map.put("typeName2", typeName2);
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		
		List<AttitudeTypeVO> list = getAttitudeTypeList(companyId, "", "1", "" , "", tenantId, primary, "");
		
		boolean result = false;
		
		if (list.size() < 15) {
			String MaxTypeId = getAttitudeTypeMaxTypeId(companyId, tenantId);
			String typeId = "";
			
			if (MaxTypeId.length() == 1) {
				typeId = "A0" + MaxTypeId;
			} else {
				typeId = "A" + MaxTypeId;
			}
			
			map.put("typeId", typeId);
			ezAttitudeDAO.insertAttitudeType(map);
			
			result = true;
		}
		
		logger.debug("insertAttitudeType ended");
		
		return result;
	}

	@Override
	public AttitudeTypeVO getAttitudeTypeInfo(int tenantId, String companyId, String typeId) throws Exception {
		logger.debug("getAttitudeTypeInfo started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("typeId", typeId);
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		
		AttitudeTypeVO result = ezAttitudeDAO.getAttitudeTypeInfo(map);
		
		logger.debug("getAttitudeTypeInfo ended");
		
		return result;
	}

	@Override
	public void updateAttitudeType(String typeId, String typeName, String typeName2,
			int tenantId, String companyId) throws Exception {
		logger.debug("updateAttitudeType started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("typeId", typeId);
		map.put("typeName", typeName);
		map.put("typeName2", typeName2);
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		
		ezAttitudeDAO.updateAttitudeType(map);
		
		logger.debug("updateAttitudeType ended");
	}

	@Override
	public List<AttitudeUserConfigVO> getAttitudeUserConfigList(int tenantId, String companyId,
			String searchUserName, String searchDeptName, String searchTitle, String searchStartTime,
			String searchEndTime, String searchGubun, String pageNum, String listSize,
			String orderCell, String orderOption, String offsetMin, String primary) throws Exception {
		logger.debug("getAttitudeUserConfigList started");
		
		int limit = (Integer.parseInt(pageNum) - 1) * Integer.parseInt(listSize);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		map.put("searchUserName", searchUserName);
		map.put("searchDeptName", searchDeptName);
		map.put("searchTitle", searchTitle);
		map.put("searchStartTime", searchStartTime);
		map.put("searchEndTime", searchEndTime);
		map.put("searchGubun", searchGubun);
		map.put("limit", limit);
		map.put("listSize", Integer.parseInt(listSize));
		map.put("orderCell", orderCell.toUpperCase()); // 이름(DISPLAYNAME), 직위(TITLE), 부서(DESCRIPTION), 근무시간(WORKSTARTTIME), 구분(GUBUN)
		map.put("orderOption", orderOption.toUpperCase()); // ASC, DESC
		map.put("offsetMin", offsetMin);
		map.put("startRow", limit + 1);
		map.put("endRow", limit + Integer.parseInt(listSize));
		if (primary.equals("1")) {
			primary = "";
		}
		map.put("primary", primary);
		
		List<AttitudeUserConfigVO> resultList = ezAttitudeDAO.getAttitudeUserConfigList(map);
		
		logger.debug("getAttitudeUserConfigList ended. resultList size = " + resultList.size());
		
		return resultList;
	}

	@Override
	public AttitudeUserConfigVO getAttitudeUserConfigInfo(String selectedUserIdList, String offsetMin, String companyId, int tenantId) throws Exception {
		logger.debug("getAttitudeUserConfigInfo started");
		
		String userType = "";
		
		if (selectedUserIdList.split(", ").length == 1) {
			userType = "user";
		} else {
			userType = "list";
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("selectedUserId", selectedUserIdList);
		map.put("userType", userType);
		map.put("offsetMin", offsetMin);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		AttitudeUserConfigVO vo = ezAttitudeDAO.getAttitudeUserConfigInfo(map);
		
		logger.debug("getAttitudeUserConfigInfo ended");
		
		return vo;
	}

	@Override
	public List<AttitudeDeptVO> getCompanyList(String lang, int tenantId, String userId) throws Exception{
		logger.debug("getCompanyList started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		if (lang.equals("1")) {
			lang = "";
		}
		
		map.put("lang", lang);
		map.put("tenantId", tenantId);
		map.put("userId", userId);
		
		List<AttitudeDeptVO> companyList = ezAttitudeDAO.getCompanyList(map);
		
		logger.debug("getCompanyList ended");
		
		return companyList;
	}

	@Override
	public String getAttitudeUserConfigCount(int tenantId, String companyId, String searchUserName, String searchDeptName,
			String searchTitle, String searchStartTime, String searchEndTime, String searchGubun, String offsetMin) throws Exception {
		logger.debug("getAttitudeUserConfigListCount started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		map.put("searchUserName", searchUserName);
		map.put("searchDeptName", searchDeptName);
		map.put("searchTitle", searchTitle);
		map.put("searchStartTime", searchStartTime);
		map.put("searchEndTime", searchEndTime);
		map.put("searchGubun", searchGubun);
		map.put("offsetMin", offsetMin);
		
		String totalCount = ezAttitudeDAO.getAttitudeUserConfigCount(map);
		
		logger.debug("getAttitudeUserConfigListCount ended. totalCount = " + totalCount);
		
		return totalCount;
	}

	@Override
	public List<AttitudeApplicationVO> getUsersModiyAtt(String companyId, int tenantId,
			String userId, String startDate, String endDate, String apprUserName, String writerName, String writerDeptName, String lang, 
			String offset,String startPoint, String endPoint, String type, String order, String adminFlag, String checkAdmin, String deptId, List<String> deptIdList) throws Exception {
		logger.debug("getUsersModiyAtt started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("searchDeptId", deptId);
		map.put("deptIdList", deptIdList);
		map.put("startDate", startDate);
		map.put("endDate", endDate);
		map.put("apprUserName", apprUserName);
		map.put("writerName", writerName);
		map.put("writerDeptName", writerDeptName);
		if (lang.equals("1")) {
			lang = "";
		}
		map.put("lang", lang);
		map.put("offset", offset);
		
		if (startPoint != null) {
			map.put("startPoint", Integer.parseInt(startPoint));
		}
		if (endPoint != null) {
			map.put("endPoint", Integer.parseInt(endPoint));
		}
		
		map.put("type", type);
		
		if (startPoint != null && endPoint != null && !startPoint.equals("") && !endPoint.equals("")) {
			map.put("startRow", Integer.parseInt(startPoint) + 1);
			map.put("endRow", Integer.parseInt(startPoint) + Integer.parseInt(endPoint));
		}
		
		if (adminFlag.equals("false")) {
			map.put("userId", userId);
		}
		
		/* 2024-07-23 홍승비 - SQL Injection 수정 > $ 기호 제거, 정렬 조건 분리 */
		// 일자(START_DATE), 신청자(WRITER_NAME), 신청부서(WRITER_DEPT_NAME), 승인상태(APPR_STATUS), 승인자(APPR_USER_NAME), 신청일자(APPL_DATE)
		if (order != null && !order.trim().equals("")) {
			map.put("orderColumn", order.trim().split(" ")[0]);
			map.put("orderSort", order.trim().split(" ")[1]);
		}
		
		List<AttitudeApplicationVO> attAppList = ezAttitudeDAO.getUsersModiyAtt(map); 
		
		logger.debug("getUsersModiyAtt ended");
		
		return attAppList;
	}
	
	@Override
	public String getAttitudeTypeMaxTypeId(String companyId, int tenantId)
			throws Exception {
		logger.debug("getAttitudeTypeMaxTypeId started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);

		logger.debug("getAttitudeTypeMaxTypeId ended");

		return ezAttitudeDAO.getAttitudeTypeMaxTypeId(map);
	}
	
	@Override
	public List<AttitudeFormVO> getAttitudeFormList(int tenantId) throws Exception {
		logger.debug("getAttitudeFormList started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("tenantId", tenantId);

		logger.debug("getAttitudeFormList ended");

		return ezAttitudeDAO.getAttitudeFormList(map);
	}

	@Override
	public int getUsersModiyAttCount(String companyId, int tenantId, String userId, String startDate, String endDate,
			String apprUserName, String writerName , String writerDeptName, String lang, String offset, String type, String deptId, List<String> deptIdList,String adminFlag, String checkAdmin) throws Exception {
		logger.debug("getUsersModiyAttCount started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		logger.debug("checkAdmin : " + checkAdmin);
		logger.debug("adminFlag : " + adminFlag);
		
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("searchDeptId", deptId);
		map.put("deptIdList", deptIdList);
		map.put("startDate", startDate);
		map.put("endDate", endDate);
		map.put("apprUserName", apprUserName);
		map.put("writerName", writerName);
		map.put("writerDeptName", writerDeptName);
		if (lang.equals("1")) {
			lang = "";
		}
		map.put("lang", lang);
		map.put("offset", offset);
		map.put("type", type);
		
		if (adminFlag.equals("false")) {
			map.put("userId", userId);
		}
		
		int attAppListCount = ezAttitudeDAO.getUsersModiyAttCount(map);
		
		logger.debug("getUsersModiyAttCount ended");
		
		return attAppListCount;
	}

	@Override
	public List<HolidayVO> getHolidayList(String isRest, String companyId, int tenantId) throws Exception {
		logger.debug("getHolidayList started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("isRest", isRest);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		List<HolidayVO> holidayList = ezAttitudeDAO.getHolidayList(map);
		
		logger.debug("getHolidayList ended");
		
		return holidayList;
	}
	
	@Override
	public int delUsersModifyAtt(String companyId, int tenantId, String[] ids) throws Exception {
		logger.debug("delUsersModifyAtt started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("ids", ids);
		
		int modAppl = 0;
		int data = 1;
		
		for (int i = 0; i < ids.length; i++) {
			map.put("attitudeId", ids[i]);
			map.put("attModId", ids[i]);
			modAppl = ezAttitudeDAO.getAttModApp(map);
			if (modAppl == 1) {
				map.put("modappl", "0");
			} else if (modAppl == 2) {
				map.put("modappl", "3");
			}
			String apprStatus = ezAttitudeDAO.checkModApplStatus(map);
			if (apprStatus != null && !apprStatus.equals("0")) {
				data = 0;
				continue;
			} else {
				/*근태 수정신청 삭제.*/
				ezAttitudeDAO.delUsersModifyAtt(map);
				/*근태 수정신청이 삭제되고 원본 근태에 대해 수정신청 개수가 0개 일 때 원본 근태를 수정 가능한 상태로 변경.*/
				ezAttitudeDAO.resetAttModApp(map);
			}
		}

		logger.debug("delUsersModifyAtt ended");
		
		return data;
	}

	@Override
	public List<DeptViewVO> getDeptViewList(String userId, String companyId,
			int tenantId, String primary) throws Exception {
		logger.debug("getDeptViewList started");
		
	    Map<String, Object> map = new HashMap<String, Object>();
	    
	    map.put("tenantId", tenantId);
	    map.put("userId", userId);
	    map.put("companyId", companyId);
		if (primary.equals("1")) {
			primary = "";
		}
	    map.put("primary", primary);
	    
	    List<DeptViewVO> deptList = ezAttitudeDAO.getDeptViewList(map);
	    
	    logger.debug("getDeptViewList ended");
	    return deptList;
	}

	@Override
	public AttitudeApplicationVO attModAppDetail(String attModId, String offset, String applCnt, String lang, String companyId, int tenantId) throws Exception {
		logger.debug("attModAppDetail started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("attModId", attModId);
		map.put("offset", offset);
		map.put("applCnt", applCnt);
		if (lang.equals("1")) {
			lang = "";
		}
		map.put("lang", lang);
		
		logger.debug("attModAppDetail ended");
		
		return ezAttitudeDAO.attModAppDetail(map);
	}

	@Override
	public int attModAppModify(String companyId,
			int tenantId, String userId, String attModId, String offset,
			String content, String changeDate) throws Exception {
		logger.debug("attModAppModify started");
		
		content = content.replaceAll("\'", "&#39;").replaceAll("(\r\n|\r|\n|\n\r)", " ");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("userId", userId);
		map.put("attModId", attModId);
		map.put("offset", offset);
		map.put("content", content);
		map.put("changeDate", changeDate);
		map.put("applDate", commonUtil.getTodayUTCTime(""));
		
		String apprStatus = ezAttitudeDAO.checkModApplStatus(map);
		
		logger.debug("attModAppModify ended");
		
		if (apprStatus != null && apprStatus.equals("0")) {
			return ezAttitudeDAO.attModAppModify(map);
		} else {
			return 0;
		}
	}
	
	@Override
	public String attSaveAppModify(String attitudeId, String companyId,
			int tenantId, String userId, String writerName, String writerName2, String writerTitle
			, String writerTitle2, String writerDeptId, String writerDeptName, String writerDeptName2
			,String changeDate, String delFlag, String content,String offset, String originDate) throws Exception {
		logger.debug("attSaveAppModify started");
		
		content = content.replaceAll("\'", "&#39;").replaceAll("(\r\n|\r|\n|\n\r)", " ");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("attitudeId", attitudeId);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("writerId", userId);
		map.put("writerName", writerName);
		map.put("writerName2", writerName2);
		map.put("writerTitle", writerTitle);
		map.put("writerTitle2", writerTitle2);
		map.put("writerDeptId", writerDeptId);
		map.put("writerDeptName", writerDeptName);
		map.put("writerDeptName2", writerDeptName2);
		map.put("changeDate", changeDate);
		map.put("originDate", originDate);
		map.put("delFlag", delFlag);
		map.put("content", content);
		map.put("apprStatus", "0");
		map.put("offset", offset);
		map.put("modappl", "1");
		map.put("applDate", commonUtil.getTodayUTCTime(""));
		
		/*이미 신청된 항목이 있는지, 
		 * 이미 신청된 항목의 상태가 
		 * 승인, 반려 상태인지 확인
		 * */
		
		int modAppl = ezAttitudeDAO.getAttModApp(map);
		
		if (modAppl == 0 || modAppl == 4) {
			map.put("modappl", "1");
		} else if (modAppl == 3) {
			map.put("modappl", "2");
		}
		//신청된 항목이 존재 할 때
		if (modAppl == 1 || modAppl == 2) {
			return "fail";
		}
		
		/*근태수정신청 저장*/
		ezAttitudeDAO.attSaveAppModify(map);
		/*attitude modappl수정*/
		ezAttitudeDAO.setAttModApp(map);
		
		logger.debug("attSaveAppModify ended");
		
		return "success";
	}

	@Override
	public List<AdminAttitudeVO> getAttitudeList2(String searchUserName, String searchDeptName, String searchTitle, String searchStartDate, String searchEndDate, String searchAttitudeType, String orderCell, String orderOption, String offset, String pageNum, String listSize, String companyId, int tenantId, String searchDeptId, List<String> deptIdList, String primary) throws Exception {
		logger.debug("getAttitudeList2 started");
		
		String offsetMin = commonUtil.getMinuteUTC(offset);
		Map<String, Object> map = new HashMap<String, Object>();
		
		int limit = 0;
		if (pageNum != null && !pageNum.equals("")) {
			limit = (Integer.parseInt(pageNum) - 1) * Integer.parseInt(listSize);
			
			map.put("startRow", limit + 1);
			map.put("endRow", limit + Integer.parseInt(listSize));
		}
		
		searchStartDate = commonUtil.getDateStringInUTC(searchStartDate + " 00:00:00", offset, true);
		searchEndDate = commonUtil.getDateStringInUTC(searchEndDate + " 23:59:59", offset, true);
		
		map.put("searchUserName", searchUserName);
		map.put("searchDeptName", searchDeptName);
		map.put("searchDeptId", searchDeptId);
		map.put("searchTitle", searchTitle);
		map.put("searchAttitudeType", searchAttitudeType);
		map.put("searchStartDate", searchStartDate);
		map.put("searchEndDate", searchEndDate);
		map.put("orderCell", orderCell.toUpperCase());
		map.put("orderOption", orderOption.toUpperCase());
		map.put("listSize", StringUtils.isBlank(listSize) ? null : Integer.parseInt(listSize));
		map.put("offsetMin", offsetMin);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("limit", limit);
		map.put("deptIdList", deptIdList);

		if (primary.equals("1")) {
			primary = "";
		}
		map.put("primary", primary);

		List<AdminAttitudeVO> resultList = ezAttitudeDAO.getAttitudeList2(map);

		logger.debug("getAttitudeList2 ended. resultList size = " + resultList.size());
		
		return resultList;
	}

	@Override
	public String getAttitudeCount2(String searchUserName, String searchDeptName, String searchTitle, String searchStartDate,
			String searchEndDate, String searchAttitudeType,String offset, String companyId, int tenantId, String searchDeptId, List<String> deptIdList) throws Exception {
		logger.debug("getAttitudeCount2 started.");
		
		String offsetMin = commonUtil.getMinuteUTC(offset);
		
		searchStartDate = commonUtil.getDateStringInUTC(searchStartDate + " 00:00:00", offset, true);
		searchEndDate = commonUtil.getDateStringInUTC(searchEndDate + " 23:59:59", offset, true);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("searchUserName", searchUserName);
		map.put("searchDeptName", searchDeptName);
		map.put("searchTitle", searchTitle);
		map.put("searchAttitudeType", searchAttitudeType);
		map.put("searchStartDate", searchStartDate);
		map.put("searchEndDate", searchEndDate);
		map.put("searchDeptId", searchDeptId);
		map.put("offsetMin", offsetMin);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("deptIdList", deptIdList);
		
		String result = ezAttitudeDAO.getAttitudeCount2(map);
		
		logger.debug("getAttitudeCount2 end. result = " + result);
		
		return result;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public JSONObject getAttitudeAbsentedList(String searchUserName, String searchDeptName, String searchTitle, String searchStartDate, String searchEndDate, String searchDeptId, String pageNum, String listSize, String orderCell, String orderOption, String duplicated, String userLang, String offset, String companyId, int tenantId, List<String> deptIdList, String primary) throws Exception {
		logger.debug("getAttitudeAbsentedList started.");
		
		String offsetMin = commonUtil.getMinuteUTC(offset);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("searchUserName", searchUserName);
		map.put("searchDeptName", searchDeptName);
		map.put("searchTitle", searchTitle);
		map.put("searchDeptId", searchDeptId);
		map.put("offsetMin", offsetMin);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("deptIdList", deptIdList);
		if (userLang.equals("1")) {
			userLang = "";
		} else {
			userLang = "2";
		}
		map.put("lang", userLang);
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Calendar cal = Calendar.getInstance();
		
		Date startDate = sdf.parse(searchStartDate);
		cal.setTime(startDate);
		
		List<AdminAttitudeVO> totalList = new ArrayList<AdminAttitudeVO>();
		
		for (String tempDate : checkHoliday(searchStartDate, searchEndDate, userLang, companyId, tenantId)) {
			logger.debug("tempDateTime = " + tempDate);
			
			map.put("searchStartDate", commonUtil.getDateStringInUTC(tempDate + " 00:00:00", offset, true));
			map.put("searchEndDate", commonUtil.getDateStringInUTC(tempDate + " 23:59:59", offset, true));
			
			List<AdminAttitudeVO> resultList = ezAttitudeDAO.getAttitudeAbsentList(map);
			totalList.addAll(resultList);
			
			logger.debug("resultList size = " + resultList.size());
		}
		
		if (duplicated.equals("distinct")) {
			HashSet<AdminAttitudeVO> listSet = new HashSet<AdminAttitudeVO>(totalList);
			totalList = new ArrayList<AdminAttitudeVO>(listSet);
			logger.debug("duplicate totalList size = " + totalList.size());
		} else {
			logger.debug("distinct totalList size = " + totalList.size());
		}
		
		logger.debug("sorting started.");
		
		switch (orderCell) {
		case "displayname" :
			Collections.sort(totalList, new Comparator<AdminAttitudeVO>() {
				@Override
				public int compare(AdminAttitudeVO o1, AdminAttitudeVO o2) {
					return o1.getUserName().compareTo(o2.getUserName());
				}
			});
			
			break;
		case "title" :
			Collections.sort(totalList, new Comparator<AdminAttitudeVO>() {
				@Override
				public int compare(AdminAttitudeVO o1, AdminAttitudeVO o2) {
					return o1.getUserTitle().compareTo(o2.getUserTitle());
				}
			});
			
			break;
		case "description":
			Collections.sort(totalList, new Comparator<AdminAttitudeVO>() {
				@Override
				public int compare(AdminAttitudeVO o1, AdminAttitudeVO o2) {
					return o1.getDeptName().compareTo(o2.getDeptName());
				}
			});
			
			break;
		case "startdate":
			Collections.sort(totalList, new Comparator<AdminAttitudeVO>() {
				@Override
				public int compare(AdminAttitudeVO o1, AdminAttitudeVO o2) {
					return o1.getStartDate().compareTo(o2.getStartDate());
				}
			});
			
			break;
		default:
			//startdate 역순
			Collections.sort(totalList, new Comparator<AdminAttitudeVO>() {
				@Override
				public int compare(AdminAttitudeVO o1, AdminAttitudeVO o2) {
					return o2.getStartDate().compareTo(o1.getStartDate());
				}
			});
			
			break;
		}
		
		if (orderOption.equals("DESC")) {
			Collections.reverse(totalList);
		}
		
		logger.debug("sorting ended.");
		
		JSONObject data = new JSONObject();
		data.put("totalCount", totalList.size());
		
		logger.debug("paging started.");
		
		if (!listSize.equals("")) {
			int size = Integer.parseInt(listSize);
			int limit = (Integer.parseInt(pageNum) - 1) * size;
			
			if (totalList.size() < limit + size) {
				logger.debug("1page param = " + limit + ", " + totalList.size());
				totalList = totalList.subList(limit, totalList.size());
			} else {
				logger.debug("2page param = " + limit + ", " + (limit + size));
				totalList = totalList.subList(limit, limit + size);
			}
		}
		
		logger.debug("paging ended. pageSize = " + totalList.size());
		
		data.put("list", totalList);
		
		logger.debug("getAttitudeAbsentedList ended.");
		
		return data;
	}
	
	/**
	 * YYYY-MM-dd
	 * 
	 * @param checkStartDate 시작일
	 * @param checkEndDate 종료일
	 * @param userLang userInfo.lang
	 * @param companyId
	 * @param tenantId
	 * @return 국가,회사,근태 휴무일을 제외한 날짜 dateString arrary
	 * @throws Exception
	 */
	public List<String> checkHoliday(String checkStartDate, String checkEndDate, String userLang, String companyId, int tenantId) throws Exception {
		logger.debug("checkHoliday started.");
		logger.debug("startDate = " + checkStartDate + " || endDate = " + checkEndDate + " || userLang = " + userLang);
		
		/*2018-05-08 이효진 holidayList 생성*/
		//회사 기념일
		List<HolidayVO> holidayList = getHolidayList("rest", companyId, tenantId);
		//임시 저장
		List<HolidayVO> tempHolidayList = new ArrayList<HolidayVO>();
		//근태휴무일
		AttitudeConfigVO attitudeConfig = getAttitudeConfig(tenantId, companyId);
		String checkDay[] = attitudeConfig.getClosedDay().split(",");
		//국가공휴일
		KoreanLunarCalendar koreaCalendar = KoreanLunarCalendar.newInstance();
		
		//2019-01-15 일정관리 법정공휴일 기능 추가로 주석처리.
		/*
		String nationHoliday[] = null;
		
		if (userLang.equals("1")) {
			nationHoliday = koreaCalendar.HOLIDAY_KOREA;
		} else if (userLang.equals("3")) {
			nationHoliday = koreaCalendar.HOLIDAY_JAPAN;
		} else {
			nationHoliday = koreaCalendar.HOLIDAY_KOREA;
		}
		
		for (String holiday : nationHoliday) {
			String temp[] = holiday.split(", ");
			
			HolidayVO vo = new HolidayVO();
			vo.setHolidayDate(checkStartDate.substring(0,4) + "-" + temp[2] + "-" + temp[3]);
			vo.setHolidayName(temp[0]);
			vo.setHolidayName2(temp[1]);
			vo.setIsRepeat(1);
			vo.setIsSolar(temp[4].equals("1") ? 1 : 0);
			vo.setUseCompany(companyId);
			
			holidayList.add(vo);
		}
		*/
		
		//음력 -> 양력변환
		DecimalFormat df = new DecimalFormat("00");
		String startYear = checkStartDate.substring(0, 4);
		String endYear = checkEndDate.substring(0, 4);
		
		for (HolidayVO vo1 : holidayList) {
			if (vo1.getIsSolar() == 0) {//음력일 경우
				String lunarDate = vo1.getHolidayDate();
				
				koreaCalendar.setLunarDate(Integer.parseInt(lunarDate.substring(0, 4)), Integer.parseInt(lunarDate.substring(5, 7)), Integer.parseInt(lunarDate.substring(8, 10)), false);
				if(!startYear.equals(String.valueOf(koreaCalendar.getSolarYear()))) {
					koreaCalendar.setLunarDate(Integer.parseInt(startYear), Integer.parseInt(lunarDate.substring(5, 7)), Integer.parseInt(lunarDate.substring(8, 10)), false);
				}
				
				vo1.setHolidayDate(koreaCalendar.getSolarYear() + "-" + df.format(koreaCalendar.getSolarMonth()) + "-" + df.format(koreaCalendar.getSolarDay()));
			}
			
			if (vo1.getHolidayFlag() != null && vo1.getHolidayFlag().equals("Y")) {
				String voYear = vo1.getHolidayRepeat().split("\\|")[0];
				
				if (vo1.getIsRepeat() == 1) {//반복일 경우
					if (startYear.equals(endYear)) {
						if (!startYear.equals(voYear)) {
							vo1.setHolidayRepeat(vo1.getHolidayRepeat().replace(voYear, startYear));
						}
					} else {
						if (!startYear.equals(voYear)) {
							vo1.setHolidayRepeat(vo1.getHolidayRepeat().replace(voYear, startYear));
						}
						
						if (!endYear.equals(voYear)) {
							HolidayVO vo2 = new HolidayVO();
							vo2.setHolidayRepeat(vo1.getHolidayRepeat().replace(startYear, endYear));
							
							SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
							
							Calendar cal = Calendar.getInstance();

							cal.set(Calendar.YEAR, Integer.parseInt(vo1.getHolidayRepeat().split("\\|")[0]));				
							
							cal.set(Calendar.MONTH, (Integer.parseInt(vo1.getHolidayRepeat().split("\\|")[1]) - 1));
							
							if (vo1.getHolidayRepeat().split("\\|")[2].equals("5")) {
								Calendar cal2 = Calendar.getInstance();
								cal2.set(Integer.parseInt(vo1.getHolidayRepeat().split("\\|")[0]), Integer.parseInt(vo1.getHolidayRepeat().split("\\|")[1]) - 1, cal.getActualMaximum(Calendar.DATE));
								cal.set(Calendar.WEEK_OF_MONTH, cal2.get(Calendar.WEEK_OF_MONTH));
							} else {
								cal.set(Calendar.WEEK_OF_MONTH, Integer.parseInt(vo1.getHolidayRepeat().split("\\|")[2]));
							}
							
							//요일					
							int temp = Integer.parseInt(vo1.getHolidayRepeat().split("\\|")[3]) - cal.get(Calendar.DAY_OF_WEEK) + 1;
							cal.set(Calendar.DAY_OF_WEEK, cal.get(Calendar.DAY_OF_WEEK) + temp);

							//첫째 주의 첫 요일이 해당요일보다크면 + 7을 해준다.
							Calendar cal3 = Calendar.getInstance();
							cal3.set(Integer.parseInt(vo1.getHolidayRepeat().split("\\|")[0]), Integer.parseInt(vo1.getHolidayRepeat().split("\\|")[1]) - 1, 1);
							
							int MonthfirstDay = cal3.get(Calendar.DAY_OF_WEEK);
							
							if (!vo1.getHolidayRepeat().split("\\|")[2].equals("5") && MonthfirstDay > Integer.parseInt(vo1.getHolidayRepeat().split("\\|")[3])) {
								cal.add(Calendar.DATE, 7);
							}
							
							vo2.setHolidayDate(formatter.format(cal.getTime()));
							
							tempHolidayList.add(vo2);
						}
					}
				}
				
				SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
				
				Calendar cal = Calendar.getInstance();

				cal.set(Calendar.YEAR, Integer.parseInt(vo1.getHolidayRepeat().split("\\|")[0]));				
				
				cal.set(Calendar.MONTH, (Integer.parseInt(vo1.getHolidayRepeat().split("\\|")[1]) - 1));
				
				if (vo1.getHolidayRepeat().split("\\|")[2].equals("5")) {
					Calendar cal2 = Calendar.getInstance();
					cal2.set(Integer.parseInt(vo1.getHolidayRepeat().split("\\|")[0]), Integer.parseInt(vo1.getHolidayRepeat().split("\\|")[1]) - 1, cal.getActualMaximum(Calendar.DATE));
					cal.set(Calendar.WEEK_OF_MONTH, cal2.get(Calendar.WEEK_OF_MONTH));
				} else {
					cal.set(Calendar.WEEK_OF_MONTH, Integer.parseInt(vo1.getHolidayRepeat().split("\\|")[2]));
				}
				
				//요일					
				int temp = Integer.parseInt(vo1.getHolidayRepeat().split("\\|")[3]) - cal.get(Calendar.DAY_OF_WEEK) + 1;
				cal.set(Calendar.DAY_OF_WEEK, cal.get(Calendar.DAY_OF_WEEK) + temp);

				//첫째 주의 첫 요일이 해당요일보다크면 + 7을 해준다.
				Calendar cal3 = Calendar.getInstance();
				cal3.set(Integer.parseInt(vo1.getHolidayRepeat().split("\\|")[0]), Integer.parseInt(vo1.getHolidayRepeat().split("\\|")[1]) - 1, 1);
				
				int MonthfirstDay = cal3.get(Calendar.DAY_OF_WEEK);
				
				if (!vo1.getHolidayRepeat().split("\\|")[2].equals("5") && MonthfirstDay > Integer.parseInt(vo1.getHolidayRepeat().split("\\|")[3])) {
					cal.add(Calendar.DATE, 7);
				}
				
				vo1.setHolidayDate(formatter.format(cal.getTime()));
				
			} else {
				String voYear = vo1.getHolidayDate().substring(0, 4);
				
				if (vo1.getIsRepeat() == 1) {//반복일 경우
					if (startYear.equals(endYear)) {
						if (!startYear.equals(voYear)) {
							vo1.setHolidayDate(vo1.getHolidayDate().replace(voYear, startYear));
						}
					} else {
						if (!startYear.equals(voYear)) {
							vo1.setHolidayDate(vo1.getHolidayDate().replace(voYear, startYear));
						}
						
						if (!endYear.equals(voYear)) {
							HolidayVO vo2 = new HolidayVO();
							vo2.setHolidayDate(vo1.getHolidayDate().replace(startYear, endYear));
							
							tempHolidayList.add(vo2);
						}
					}
				}
			}
			
		}
		
		if (tempHolidayList != null) {
			for (HolidayVO vo3 : tempHolidayList) {
				holidayList.add(vo3);
			}
		}
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Calendar cal = Calendar.getInstance();
		
		Date startDate = sdf.parse(checkStartDate);
		cal.setTime(startDate);
		
		String tempDate = "";
		boolean isContained = true;
		
		List<String> result = new ArrayList<String>();
		
		while (true) {
			isContained = true;
			tempDate = sdf.format(cal.getTime());
			
			if (!result.contains(tempDate)) {
				switch (cal.get(Calendar.DAY_OF_WEEK)) {
				case 1:
					if (checkDay[0].equals("1")) {
						break;
					} else {
						if (holidayList.size() > 0) {
							for (HolidayVO vo1 : holidayList) {
								if (vo1.getHolidayDate().substring(0, 10).equals(tempDate)) {
									isContained = true;
									break;
								} else {
									isContained = false;
								}
							}
							
							if (!isContained) {
								result.add(tempDate);
							}
						} else {
							result.add(tempDate);							
						}
						
						break;
					}
				case 2:
					if (checkDay[1].equals("1")) {
						break;
					} else {
						if (holidayList.size() > 0) {
							for (HolidayVO vo1 : holidayList) {
								if (vo1.getHolidayDate().substring(0, 10).equals(tempDate)) {
									isContained = true;
									break;
								} else {
									isContained = false;
								}
							}
							
							if (!isContained) {
								result.add(tempDate);
							}
						} else {
							result.add(tempDate);							
						}
						
						break;
					}
				case 3:
					if (checkDay[2].equals("1")) {
						break;
					} else {
						if (holidayList.size() > 0) {
							for (HolidayVO vo1 : holidayList) {
								if (vo1.getHolidayDate().substring(0, 10).equals(tempDate)) {
									isContained = true;
									break;
								} else {
									isContained = false;
								}
							}
							
							if (!isContained) {
								result.add(tempDate);
							}
						} else {
							result.add(tempDate);							
						}
						
						break;
					}
				case 4:
					if (checkDay[3].equals("1")) {
						break;
					} else {
						if (holidayList.size() > 0) {
							for (HolidayVO vo1 : holidayList) {
								if (vo1.getHolidayDate().substring(0, 10).equals(tempDate)) {
									isContained = true;
									break;
								} else {
									isContained = false;
								}
							}
							
							if (!isContained) {
								result.add(tempDate);
							}
						} else {
							result.add(tempDate);							
						}
						
						break;
					}
				case 5:
					if (checkDay[4].equals("1")) {
						break;
					} else {
						if (holidayList.size() > 0) {
							for (HolidayVO vo1 : holidayList) {
								if (vo1.getHolidayDate().substring(0, 10).equals(tempDate)) {
									isContained = true;
									break;
								} else {
									isContained = false;
								}
							}
							
							if (!isContained) {
								result.add(tempDate);
							}
						} else {
							result.add(tempDate);							
						}
						
						break;
					}
				case 6:
					if (checkDay[5].equals("1")) {
						break;
					} else {
						if (holidayList.size() > 0) {
							for (HolidayVO vo1 : holidayList) {
								if (vo1.getHolidayDate().substring(0, 10).equals(tempDate)) {
									isContained = true;
									break;
								} else {
									isContained = false;
								}
							}
							
							if (!isContained) {
								result.add(tempDate);
							}
						} else {
							result.add(tempDate);							
						}
						
						break;
					}
				case 7:
					if (checkDay[6].equals("1")) {
						break;
					} else {
						if (holidayList.size() > 0) {
							for (HolidayVO vo1 : holidayList) {
								if (vo1.getHolidayDate().substring(0, 10).equals(tempDate)) {
									isContained = true;
									break;
								} else {
									isContained = false;
								}
							}
							
							if (!isContained) {
								result.add(tempDate);
							}
						} else {
							result.add(tempDate);							
						}
						
						break;
					}
				}
			}
			
			cal.add(Calendar.DAY_OF_MONTH, 1);
			
			if (tempDate.equals(checkEndDate)) {
				break;
			}
		};
		
		logger.debug("checkHoliday ended.");
		
		return result;
	}
	
	/* 현재는 메일 작성창을 띄우므로 사용하지 않고 있음.
	@Override
	public void absentedListSendMail(List<AdminAttitudeVO> duplicatedList, List<AdminAttitudeVO> distinctList, String loginCookie, String startDate, String endDate, String fromName, String fromEmail) throws Exception {
		logger.debug("absentedListSendMail started.");
		//메일발송
		//title, body(미입력자 리스트 html로) 만들어서 전송
		String subject = "[공지]근태미입력자 공지";
		String memo = "<p>해당 메일을 받은 사원은 " + startDate + " ~ " + endDate + " 중 근태를 미입력한 사원입니다.</p>"
				+ "<p>확인 후 근태를 등록해주시기 바랍니다.</p>"
				+ "<p>근태 수정 권한은  각 본부장님 또는 근태관리자, 경영지원실에 있사오니, 근태관리자 및 본부장님의 부재로 인해 근태 수정이 어려우신 경우 경영지원실로 메일 바랍니다.</p>"
				+ "<p>근태는 매년 인사평가에 반영되는 사항이기에 차일까지 반드시 수정 부탁 드리겠습니다.</p>";
		
		String table = "<table style='border-collapse:collapse; width:800px;'>"
				+ "<thead><tr>"
				+ "<th style='text-align:left; border:1px solid #666; background-color: #f8f8fa;'>이름</th>"
				+ "<th style='text-align:left; border:1px solid #666; background-color: #f8f8fa;'>직위</th>"
				+ "<th style='text-align:left; border:1px solid #666; background-color: #f8f8fa;'>부서</th>"
				+ "<th style='text-align:left; border:1px solid #666; background-color: #f8f8fa;'>날짜</th>" 
				+ "</thead><tbody>";
		
		for (AdminAttitudeVO vo : duplicatedList) {
			table += "<tr><td style='border:1px solid #666'>" + vo.getUserName()+ " </td>"
					+ "<td style='border:1px solid #666'>" + vo.getUserTitle() + "</td>"
					+ "<td style='border:1px solid #666'>" + vo.getDeptName() + "</td>"
					+ "<td style='border:1px solid #666'>" + vo.getStartDate() + "</td></tr>";
		}
		
		table += "</tbody></table>";
		memo += table;
		
		InternetAddress from = new InternetAddress(fromEmail, fromName);
		InternetAddress[] to = new InternetAddress[distinctList.size()];
		int i = 0;
		
		for (AdminAttitudeVO distinctVO : distinctList) {
			String emailAdress = "";
			
			if (distinctVO.getUserEmail() != null && distinctVO.getUserEmail() != "") {
				emailAdress = distinctVO.getUserEmail().split("@")[1];
			} else {
				emailAdress = fromEmail.split("@")[1];
			}
			
			InternetAddress temp = new InternetAddress(distinctVO.getWriterId() + "@" + emailAdress, distinctVO.getUserName());
			
			to[i] = temp;
			i++;
		}
		
		ezEmailService.sendMail(loginCookie, from, to, null, null, subject, memo, false);
		
		logger.debug("absentedListSendMail ended.");
	}
	*/

	@Override
	public void changeUsersModifyAtt(String companyId, int tenantId,
			String ids, String changeStatus, String userId, String userName, String userName2, String offSet) throws Exception {
		logger.debug("changeUsersModifyAtt started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		String offsetMin = commonUtil.getMinuteUTC(offSet);
		
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		map.put("ids", ids.split("_")[0]);
		map.put("attModId", ids.split("_")[0]);
		
		if (ids.split("_").length > 1) {
			map.put("applCnt", ids.split("_")[1]);
		}
		map.put("changeStatus", changeStatus);
		map.put("offsetMin", offsetMin);
		map.put("offset", offsetMin);
		map.put("apprDate",commonUtil.getTodayUTCTime(""));
		map.put("userId",userId);
		map.put("displayName",userName);
		map.put("displayName2",userName2);
		
		String apprStatus = ezAttitudeDAO.checkModApplStatus(map);
		//신청상태가 아니면 return
		if (apprStatus != null && !apprStatus.equals("0")) {
			return;
		}
		
		ezAttitudeDAO.changeUsersModifyAtt(map);
		
		//승인일 때 사용자의 기존 지각 상태의 근태 시간 상태 수정
		if(changeStatus.equals("appr")){
			ezAttitudeDAO.changeUsersAtt(map);

			//사용자의 기존 지각 상태의 근태 유형 수정
			AttitudeApplicationVO vo = ezAttitudeDAO.attDetail(map);
			String startDate = vo.getOriginDate();
			startDate = startDate.split(" ")[1];
	
			Map<String, Object> map1 = new HashMap<String, Object>();
			
			//boolean isDefaultAtti = false;
			map1.put("writerId", vo.getWriterId());
			map1.put("companyId", companyId);
			map1.put("tenantId", tenantId);
			
			String isValue = ezAttitudeDAO.getIsAttitudeUserConf(map1);
			map1.put("isValue", isValue);
			
			AttitudeUserConfigVO resultVO = ezAttitudeDAO.getAttitudeConfTime(map1);
			String resultConfDate = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime("yyyy-MM-dd") + " " + resultVO.getWorkStartTime() + ":00", offSet, false).substring(11);

			SimpleDateFormat f = new SimpleDateFormat("HH:mm:ss");
			
			Date userConfTime = f.parse(resultConfDate);
			Date userInTime = f.parse(startDate);
			
			String typeId = "A01";
			if (userInTime.after(userConfTime)) { //지각인 경우
				typeId = "A02";
			}			
			map.put("typeId", typeId);
			
			ezAttitudeDAO.changeUsersAttType(map);
			
			//승인일 때 attitude의 modappl상태값 변경 3(수정상태)
			map.put("attitudeId", ids.split("_")[0]);
			map.put("modappl", 3);
			ezAttitudeDAO.setAttModApp(map);
		} else if (changeStatus.equals("ret")) {
			map.put("attitudeId", ids.split("_")[0]);
			int modAppl = ezAttitudeDAO.getAttModApp(map);
			
			if (modAppl == 1) {
				map.put("modappl", 4);
			} else if (modAppl == 2) {
				map.put("modappl", 3);
			}
			ezAttitudeDAO.setAttModApp(map);
		}
		logger.debug("changeUsersModifyAtt ended.");
	}

	@Override
	public List<AttitudeAuthorVO> getAttitudeAuthList(int tenantId,
			String companyId, String primary) throws Exception {
		logger.debug("getAttitudeAuthList started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		if (primary.equals("1")) {
			primary = "";
		}
		map.put("primary", primary);
		
		logger.debug("getAttitudeAuthList ended.");
		
		return ezAttitudeDAO.getAttitudeAuthList(map);
	}

	@Override
	public void deleteAttitudeAuth(String selectUserId, int tenantId,
			String companyId) throws Exception {
		logger.debug("deleteAttitudeAuth started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("selectUserId", selectUserId);
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		
		ezAttitudeDAO.deleteAttitudeAuth(map);
		
		logger.debug("deleteAttitudeAuth ended.");
	}
	
	@Override
	public List<AttitudeApplicationVO> attModGetHistory(String attModId, String userId, String offset, String lang, String companyId, int tenantId) throws Exception {
		logger.debug("attModGetHistory started");
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("userId", userId);
		if (attModId.indexOf("_") > 0) {
			attModId = attModId.split("_")[0];
		}
		map.put("attModId", attModId);
		map.put("offset", offset);
		if (lang.equals("1")) {
			lang = "";
		}
		map.put("lang", lang);
		
		List<AttitudeApplicationVO> attAppList = ezAttitudeDAO.attModGetHistory(map); 
		
		logger.debug("attModGetHistory ended");
		return attAppList;
	}
	
	@Override
	public void saveAttitudeAuthDept(int tenantId, String companyId,
			String selectedUser, String deptIds, String authTypes) throws Exception {
		logger.debug("saveAttitudeAuthDept started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyId", companyId);
		map.put("selectUserId", selectedUser);
		map.put("tenantId", tenantId);

		ezAttitudeDAO.deleteAttitudeAuth(map);

		String[] deptIdList = deptIds.split(",");
		String[] deptAuthList = authTypes.split(",");

		for (int i = 0; i < deptIdList.length; i++) {
			map.put("deptId", deptIdList[i]);
			map.put("deptAuth", deptAuthList[i]);

			ezAttitudeDAO.insertAttitudeAuth(map);
		}

		logger.debug("saveAttitudeAuthDept ended");
	}

	@Override
	public List<AttitudeAuthorVO> getAttitudeAuthDeptList(int tenantId, String companyId,
			String userId, String isAllDept, String lang) throws Exception {
		logger.debug("getAttitudeAuthDeptList started");
		
		List<AttitudeAuthorVO> list = new ArrayList<AttitudeAuthorVO>();
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("userId", userId);
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		map.put("lang", lang);
		
		if (!isAllDept.equals("Y")) {
			list = ezAttitudeDAO.getAttitudeAuthDeptList(map);
		} else {
			map.put("isAllDept", isAllDept);
			list = ezAttitudeDAO.getCompanyDeptList(map);
		}
		
		logger.debug("getAttitudeAuthDeptList ended");
		
		return list;
	}
	
	@Override
	public List<AttitudeAuthorVO> getAttitudeAuthDeptList_hyo(int tenantId, String companyId, String userId, String rollInfo, String userAuthType, String listAuthType, String comFlag, String primary) throws Exception {
		logger.debug("getAttitudeAuthDeptList_hyo started.");
		
		if (userAuthType == null || userAuthType.equals("")) {
			if (commonUtil.isAdmin(userId, tenantId, rollInfo, "c;k;e")) {
				// 전체, 회사, 근태관리자 -> 모든부서 관리권한
				userAuthType = "all";
			} else if (commonUtil.isAdmin(userId, tenantId, rollInfo, "g")) {
				// 부서관리자 -> 자기부서 관리권한 + 권한테이블
				userAuthType = "dept";
			} else {
				// 일반사용자 -> 권한테이블
				userAuthType = "";
			}
		}
		
		if (listAuthType == null || listAuthType.equals("")) {
			// all:관리+열람, M:관리, R:열람
			listAuthType = "all";
		}
		
		if (primary.equals("1")) {
			primary = "";
		}
		
		logger.debug("userId = " + userId + " || userAuthType = " + userAuthType + " || listAuthType = " + listAuthType + " || comFlag = " + comFlag);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		map.put("userAuthType", userAuthType);
		map.put("listAuthType", listAuthType);
		map.put("comFlag", comFlag);
		map.put("primary", primary);
		map.put("permissionBasisDeptYN", ezCommonService.getTenantConfig("permissionBasisDeptYN", tenantId));
		
		List<AttitudeAuthorVO> list = ezAttitudeDAO.getAttitudeAuthDeptList_hyo(map);
		
		logger.debug("getAttitudeAuthDeptList_hyo ended.");
		
		return list;
	}

	@Override
	public List<AttitudeStatisVO> getAttitudeUserStatistics(String userId, String deptId,
			String offset, String year, String typeId, int tenantId)
			throws Exception {
		logger.debug("getAttitudeUserStatistics started.");

		Map<String, Object> map = new HashMap<String, Object>();
		
		String startTime = "01 00:00:00";
		
		map.put("userId", userId);
		map.put("deptId", deptId);
		map.put("offsetMin", commonUtil.getMinuteUTC(offset));
		map.put("typeId", typeId);
		map.put("tenantId", tenantId);
		
		List<AttitudeStatisVO> list = new ArrayList<AttitudeStatisVO>();
		for (int months = 1; months < 13; months++) {
			Calendar cal = Calendar.getInstance();
			cal.set(Integer.parseInt(year), months - 1, 1);
			
			String endTime = cal.getActualMaximum(Calendar.DAY_OF_MONTH) + " 23:59:59";
			map.put("startDate", year + "-" + months + "-" + startTime);
			map.put("endDate", year + "-" + months + "-" + endTime);
			
			AttitudeStatisVO vo = ezAttitudeDAO.getAttitudeUserStatistics(map);
			if (vo != null) {
				list.add(vo);
				vo.setStatMonth(String.valueOf(months));
			} else {
				AttitudeStatisVO vo2 = new AttitudeStatisVO();
				vo2.setCount("0");
				vo2.setTypeId(typeId);
				vo2.setStatMonth(String.valueOf(months));
				list.add(vo2);
			}
			logger.debug("getAttitudeUserStatistics startDate = " + year + "-" + months + "-" + startTime + ", endDate = " + year + "-" + months + "-" + endTime + ", count = " + (vo != null ? vo.getCount() : "0"));
		}
		
		logger.debug("getAttitudeUserStatistics ended.");
		
		return list;
	}

	@Override
	public List<AttitudeAuthorVO> getCompanyDeptList(String userId,
			String companyId, int tenantId) throws Exception {
		logger.debug("getCompanyDeptList started");
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("userId", userId);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		logger.debug("getCompanyDeptList ended");
		
		return ezAttitudeDAO.getCompanyDeptList(map);
		
	}
	
	@Override
	public String deleteAttitudeType(String typeId, int tenantId, String companyId) throws Exception {
		logger.debug("deleteAttitudeType started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("typeId", typeId);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		String result = "false";
		
		if (ezAttitudeDAO.checkUseAttitudeType(map) == 0) {
			ezAttitudeDAO.deleteAttitudeType(map);
			
			result = "true";
		}
		
		logger.debug("deleteAttitudeType ended.");
		
		return result;
	}
	
	@Override
	public List<ModApplHistoryVO> getAttitudeHistoryList(String searchUserName, String searchDeptName, String searchTitle, String searchStartDate, String searchEndDate, String orderCell, String orderOption, String offset, String pageNum, String listSize, String companyId, int tenantId, String deptId, List<String> deptIdList, String primary) throws Exception {
		logger.debug("getAttitudeHistoryList started");
		
		Map<String, Object> map = new HashMap<String, Object>();

		int limit = 0;
		if (pageNum != null && !pageNum.equals("")) {
			limit = (Integer.parseInt(pageNum) - 1) * Integer.parseInt(listSize);
			map.put("startRow", (limit + 1));
			map.put("endRow", (limit + Integer.parseInt(listSize)));
		}
		
		searchStartDate = commonUtil.getDateStringInUTC(searchStartDate + " 00:00:00", offset, true);
		searchEndDate = commonUtil.getDateStringInUTC(searchEndDate + " 23:59:59", offset, true);
		
		map.put("searchUserName", searchUserName);
		map.put("searchDeptName", searchDeptName);
		map.put("deptId", deptId);
		map.put("searchTitle", searchTitle);
		map.put("searchStartDate", searchStartDate);
		map.put("searchEndDate", searchEndDate);
		map.put("orderCell", orderCell.toUpperCase());
		map.put("orderOption", orderOption.toUpperCase());
		map.put("listSize", StringUtils.isBlank(listSize) ? null : Integer.parseInt(listSize));
		map.put("offsetMin", commonUtil.getMinuteUTC(offset));
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("limit", limit);
		map.put("deptIdList", deptIdList);
		if (primary.equals("1")) {
			primary = "";
		}
		map.put("primary", primary);

		List<ModApplHistoryVO> resultList = ezAttitudeDAO.getAttitudeHistoryList(map);

		logger.debug("getAttitudeHistoryList ended. resultList size = " + resultList.size());
		
		return resultList;
	}

	@Override
	public String getAttitudeHistoryCount(String searchUserName, String searchDeptName, String searchTitle, String searchStartDate,
			String searchEndDate, String offset, String companyId, int tenantId, String deptId, List<String> deptIdList) throws Exception {
		logger.debug("getAttitudeHistoryCount started.");
		
		searchStartDate = commonUtil.getDateStringInUTC(searchStartDate + " 00:00:00", offset, true);
		searchEndDate = commonUtil.getDateStringInUTC(searchEndDate + " 23:59:59", offset, true);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("searchUserName", searchUserName);
		map.put("searchDeptName", searchDeptName);
		map.put("searchTitle", searchTitle);
		map.put("searchStartDate", searchStartDate);
		map.put("searchEndDate", searchEndDate);
		map.put("deptId", deptId);
		map.put("offsetMin", commonUtil.getMinuteUTC(offset));
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("deptIdList", deptIdList);
		
		String result = ezAttitudeDAO.getAttitudeHistoryCount(map);
		
		logger.debug("getAttitudeHistoryCount end. result = " + result);
		
		return result;
	}

	@Override
	public void insertAdminAttHistory(String writerId, String deptId,
			String startDate, String endDate, String region, String mobile,
			String bizSub, String content, String ip, String typeId,
			String dateType, String offset, String companyId, int tenantId,
			String adminId) throws Exception {
		
		logger.debug("insertAdminAttHistory started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("writerId", writerId);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("deptId", deptId);
		map.put("startDate", startDate);
		map.put("endDate", endDate);
		map.put("region", region);
		map.put("mobile", mobile);
		map.put("bizSub", bizSub);
		map.put("content", content);
		map.put("ipAddress", ip);
		map.put("typeId", typeId);
		map.put("adminId", adminId);
		map.put("offsetMin", commonUtil.getMinuteUTC(offset));
		map.put("dateType", dateType);
		
		logger.debug("insertAdminAttHistory ended.");
	}
	
	/* 2024-07-25 홍승비 - 미사용 메서드 주석처리 */
	/*
	@Override
	public String getSearchList(String pSearchList, String pCellList, String pPropList, String pClass, int pLimit, String primary, int tenantID) throws Exception {
		logger.debug("getSearchList started");
		
        String[] searchParam = null;
        String[] searchList;
        String[] searchInfo;
        String listInfo = "";
        String strSize = "";
        String strSizeForMySQL = "";
        String strSQL = "";        
        String type = "";        
        int i = 0;
        
        if (pLimit != 0) {
            strSize = " AND ROWNUM <= " + pLimit;
            strSizeForMySQL = " LIMIT " + pLimit;
        }
        
        if (!pSearchList.equals("")) {
            pSearchList = pSearchList.replace(";;", "##");
            pSearchList = pSearchList.replace("::", "@@");
            searchList = pSearchList.split("##");
            searchParam = new String[searchList.length];
            
            logger.debug("searchList.length=" + searchList.length);
            
            for (i = 0; i < searchList.length; i++) {      	
                searchInfo = searchList[i].split("@@");
                searchParam[i] = searchInfo[1].replace("'", "\\'");
                String escapedSearchParam = searchInfo[1].replace("%", "\\%").replace("'", "\\'");

                if (i == 0) {
                    if (checkSearchField(searchInfo[0])) {
                        if (searchInfo[0].toUpperCase().equals("DISPLAYNAME") && searchParam[0].toString().equals("/")) {
                            strSQL = strSQL + " WHERE (" + searchInfo[0].toLowerCase() + " = '" + searchParam[i] + "' OR " + searchInfo[0].toLowerCase() + "2 = '" + searchParam[i] + "')";
                            searchParam[0] = searchParam[0].substring(0, searchParam[0].length() - 1);
                        } else {
                            strSQL = strSQL + " WHERE (" + searchInfo[0].toLowerCase() + " LIKE  '%" + escapedSearchParam + "%' OR " + searchInfo[0].toLowerCase() + "2 LIKE '%" + escapedSearchParam + "%')";
                        }
                    } else {
                        if (searchInfo[0].indexOf("EXACT_") == 0) {
                            strSQL = strSQL + " WHERE " + searchInfo[0].substring(6).toLowerCase() + "='" + searchParam[i] + "' ";
                        } else if (searchInfo[0].indexOf("LEFT_") == 0) {
                            strSQL = strSQL + " WHERE " + searchInfo[0].substring(5).toLowerCase() + " LIKE '" + escapedSearchParam + "%' ";
                        } else if (searchInfo[0].indexOf("RIGHT_") == 0) {
                            strSQL = strSQL + " WHERE " + searchInfo[0].substring(5).toLowerCase() + " LIKE '%" + escapedSearchParam + "%'";
                    	} else {
                            strSQL = strSQL + " WHERE " + searchInfo[0].toLowerCase() + " LIKE '%" + escapedSearchParam + "%'";
                    	}
                    }
                }else{
                    if (checkSearchField(searchInfo[0])) {
                        strSQL = strSQL + " AND (" + searchInfo[0].toLowerCase() + " LIKE  '%" + escapedSearchParam + "%' OR " + searchInfo[0].toLowerCase() + "2 LIKE '%" + escapedSearchParam + "%')";
                    } else {
                        if (searchInfo[0].indexOf("EXACT_") == 0) {
                            strSQL = strSQL + " AND " + searchInfo[0].substring(6).toLowerCase() + "='" + searchParam[i] + "' ";
                        } else if (searchInfo[0].indexOf("LEFT_") == 0) {
                            strSQL = strSQL + " AND " + searchInfo[0].substring(5).toLowerCase() + " LIKE '" + escapedSearchParam + " %' ";
                        } else if (searchInfo[0].indexOf("RIGHT_") == 0) {
                            strSQL = strSQL + " AND " + searchInfo[0].substring(5).toLowerCase() + " LIKE '%" + escapedSearchParam + "%'";
                        } else {
                            strSQL = strSQL + " AND " + searchInfo[0].toLowerCase() + " LIKE '%" + escapedSearchParam + "%'";
                        }
                    }
                }
            }
        }        
        
        if (pClass.equals("user") || pClass.equals("all")) {
            strSQL = strSQL.replace("cn", "a.cn");
            strSQL = strSQL.replace("title", "a.title");
                        
            type = "U";
        } else {
        	type = "G";
        }

        Map<String, Object> map = new HashMap<String, Object>();
                
        map.put("strSQL", strSQL + strSize);
        map.put("strSQLForMySQL", strSQL);
        map.put("strSizeForMySQL", strSizeForMySQL);
        map.put("type", type);
        map.put("class", pClass);
        map.put("v_TENANT_ID", tenantID);
        
        logger.debug("strSQL=" + strSQL);
        
        List<OrganDeptVO> list = ezOrganDAO.organSearch(map);
        
        StringBuilder memberlist2 = new StringBuilder("<LISTVIEWDATA><ROWS>");
        
		for(int j=0; j < list.size(); j++){
			Map<String, Object> map1 = new HashMap<String, Object>();			
			OrganDeptVO organVO = list.get(j);
			Object result = null;			
			
			if(!organVO.getCn().equals("") && organVO.getCn() != null){
				StringBuilder sb = new StringBuilder();
				sb.append("<DATA>");
				
				if(organVO.getType().equals("user")){
					map1.put("v_CN", organVO.getCn());
	        		map1.put("v_DEPTCD", organVO.getDisplayName());
	        		map1.put("v_LANGDATA", primary);
	        		map1.put("v_TENANT_ID", tenantID);
	        		
	        		result = ezOrganDAO.getTBLUserMaster(map1);	        		
	        	}else{
	        		map1.put("v_CN", organVO.getCn());
					map1.put("v_LANGDATA", primary);
					map1.put("v_TENANT_ID", tenantID);
					
					result = ezOrganDAO.getTBLDeptMaster(map1);	        		
				}
				
				sb.append(commonUtil.getQueryResult(result));
				sb.append("</DATA>");
				
				listInfo = getMemberInfo(sb.toString(), pCellList, pPropList, "", organVO.getType());
				memberlist2.append(listInfo);
			}			
		}
		memberlist2.append("</ROWS></LISTVIEWDATA>");

		logger.debug("getSearchList ended");
		
		return memberlist2.toString();
	}
	*/
	
    @Override
    public String getSearchListPagination(String pSearchList, String pCellList, String pPropList, String pClass, int pLimit, String pLangCode, String page, int tenantID, List<String> deptIdList) throws Exception {
    	logger.debug("getSearchListPagination started");

    	String searchColumn;
    	String searchParam = "";
    	String ListInfo = "";
    	StringBuilder memberlist2 = null;
    	Map<String , Object> map = new HashMap<String , Object>();

    	try {
    		// 2024-07-25 기준으로 근태입력관리 > 근태입력대상 설정 기능의 조직도 검색조건은 하나만 전달됨 (검색칼럼::검색어 형태) 
    		if (!pSearchList.equals("")) {
    			/* 2024-07-25 홍승비 - SQL Injection 수정 > 검색조건을 전체 문자열이 아닌 map으로 전달하도록 수정, 불필요한 검색분기 제거 (전부 LIKE로 비교) */
    			searchColumn = pSearchList.split("::")[0].toUpperCase(); // 검색칼럼
    			searchParam = pSearchList.split("::")[1].replace("%", "\\%").replace("'", "\\'"); // 검색조건 값 (검색어)
    			
    			map.put("v_SEARCHCOL", searchColumn);
    			map.put("v_SEARCHPARAM", searchParam);
    		}
    		
    		if (page == null || page.equals("")) {
    			page = "1";
    		}
    		
    		int startRow = (Integer.parseInt(page) - 1) * 50 + 1;
    		int endRow = Integer.parseInt(page) * 50 + 1;
    		
    		map.put("deptIdList", deptIdList);
    		map.put("startRow", startRow);
    		map.put("endRow", endRow);
    		map.put("v_TENANT_ID", tenantID);
    		map.put("startRowForMySQL", startRow - 1);
    		map.put("count", 50);
    		
    		List<OrganDeptVO> list = ezAttitudeDAO.attOrganSearchList(map);

			int totalcount = ezAttitudeDAO.getSearchListCount(map);
			memberlist2 = new StringBuilder("<LISTVIEWDATA>");
			memberlist2.append("<TOTALCOUNT>" + totalcount + "</TOTALCOUNT><ROWS>");

    		for (int j = 0; j < list.size(); j++) {
    			Map<String, Object> map1 = new HashMap<String, Object>();           
    			OrganDeptVO organVO = list.get(j);
    			Object result = null;           
    			
    			if (organVO.getCn() != null && !organVO.getCn().equals("")) {
    				StringBuilder sb = new StringBuilder();
    				sb.append("<DATA>");
    				
    				// 검색한 결과 
					map1.put("v_CN", organVO.getCn());
					map1.put("v_DEPTCD", organVO.getDisplayName()); // 사용자명이 아닌 부서ID를 전달
					map1.put("v_LANGDATA", pLangCode);
					map1.put("v_TENANT_ID", tenantID);
					
					/* 2024-07-25 홍승비 - 겸직 사용자 검색 분기 추가 (기존 type 파라미터를 USER, ADDJOB으로 구분 / JOBID(직책ID), ROLEID(직위ID) 추가) */
					if (organVO.getType().equals("ADDJOB")) {
						map1.put("IS_ADDJOB", "Y");
						map1.put("JOBID", organVO.getJobId());
    					map1.put("ROLEID", organVO.getRoleId());
					}
					
					result = ezOrganDAO.getTBLUserMaster(map1);
					
    				sb.append(commonUtil.getQueryResult(result));
    				sb.append("</DATA>");
    				
    				ListInfo = getMemberInfo(sb.toString(), pCellList, pPropList, "", "user");
    				memberlist2.append(ListInfo);
    			}
    		}
    		
    		memberlist2.append("</ROWS></LISTVIEWDATA>");
    	} catch (Exception e) {
    		logger.error(e.getMessage(), e);
    		memberlist2 = new StringBuilder("<LISTVIEWDATA>");
    		memberlist2.append("<TOTALCOUNT>" + "0" + "</TOTALCOUNT><ROWS>");
    		memberlist2.append("</ROWS></LISTVIEWDATA>");
    	}
    	
    	logger.debug("getSearchListPagination ended");
    	return memberlist2.toString();
    }
    
    public boolean checkSearchField(String pFieldName){
		boolean bRet = false;
		
        try{
            switch (pFieldName.toUpperCase()){
                case "DISPLAYNAME":
                    bRet = true;
                    break;
                case "DESCRIPTION":
                    bRet = true;
                    break;
                case "TITLE":
                    bRet = true;
                    break;
            }
        }catch (Exception e){logger.debug("e.message=" + e.getMessage());}
        return bRet;
    }
    
    private String getMemberInfo(String pXMLString, String pCellList, String pPropList, String pMemberID, String pCategory) {		
        logger.debug("getMemberInfo started");
        logger.debug("pCellList=" + pCellList + ",pPropList=" + pPropList + ",pMemberID=" + pMemberID 
                + ",pCategory=" + pCategory);

	    Document doc = commonUtil.convertStringToDocument(pXMLString);
        StringBuilder nodeInfo = new StringBuilder("<ROW>");
        String[] celllist = pCellList.split(";");
        String cellvalue = "";
        pPropList = convertAddandConvert(pCategory, pPropList);

        for (int i = 0; i < celllist.length; i++) {
        	cellvalue = "";

            if (!pMemberID.equals("") && pCategory.equals("user") && (doc.getElementsByTagName("DEPARTMENT") != null && !pMemberID.equals(doc.getElementsByTagName("DEPARTMENT").item(0).getTextContent()))) {
            	switch (celllist[i].toLowerCase()) {
                case "department":
                    cellvalue = pMemberID;
                    break;
                case "description":
                    cellvalue = doc.getElementsByTagName("DESCRIPTION").item(0).getTextContent();
                    break;
                case "title":
                    if (doc.getElementsByTagName("TITLE") != null && !doc.getElementsByTagName("TITLE").item(0).getTextContent().equals("")) {
                        cellvalue = doc.getElementsByTagName("TITLE").item(0).getTextContent();
                        String[] sublist = cellvalue.split(";");
                        cellvalue = "";

                        for (String subinfo : sublist) {
                            String[] subinfolist = subinfo.split(":");
                            if (subinfolist[0].equals(pMemberID) && subinfolist.length > 1) {                                
                                cellvalue = subinfolist[1];
                                break;
                            }
                        }
                    }
                    break;
                }
            }
            
            logger.debug("cellList["+i+"]=" + celllist[i]);
            
              if (cellvalue == null || cellvalue.equals("")) { 
                if (celllist[i] != null && !celllist[i].equals("")) {
                    if (doc.getElementsByTagName(celllist[i].toUpperCase()).item(0) != null) {
                    	if (!doc.getElementsByTagName(celllist[i].toUpperCase()).item(0).getTextContent().equals("")) {
                    		cellvalue = doc.getElementsByTagName(celllist[i].toUpperCase()).item(0).getTextContent();
                    	}
                    } else {
                         cellvalue = "";
                    }
                } else {
                    cellvalue = "";
                }
            }

            nodeInfo.append("<CELL><VALUE>" + commonUtil.cleanValue(cellvalue) + "</VALUE>");

            if (i == 0) {
                String strNode = "";
                
                if (doc.getElementsByTagName("CN").item(0) != null) {
                    strNode = doc.getElementsByTagName("CN").item(0).getTextContent();
                }
                
                nodeInfo.append("<DATA1>" + pCategory + "</DATA1><DATA2>" + strNode + "</DATA2>");

                if (!pPropList.equals("")) {
                    String[] proplist = pPropList.split(";");
                    String propvalue;
                    
                    for (int j = 0; j < proplist.length; j++) {
                        if (doc.getElementsByTagName(proplist[j].toUpperCase()) != null && doc.getElementsByTagName(proplist[j].toUpperCase()).item(0) != null) {
                            propvalue = doc.getElementsByTagName(proplist[j].toUpperCase()).item(0).getTextContent();
                        } else {
                            propvalue = "";
                        }
                        
                        nodeInfo.append("<DATA" + (j + 3) + ">" + commonUtil.cleanValue(propvalue) + "</DATA" + (j + 3) + ">");
                    }
                }
            }
            
            nodeInfo.append("</CELL>");
        }
        
        nodeInfo.append("</ROW>");

        logger.debug("nodeInfo=" + nodeInfo);
        logger.debug("getMemberInfo ended");
        
        return nodeInfo.toString();        
    }
    
    public String convertAddandConvert(String pClass, String pProvValue) {
	    logger.debug("convertAddandConvert started");
	    logger.debug("pClass=" + pClass + ",pProvValue=" + pProvValue);
	    
        String[] arryProvValue = pProvValue.split(";");
        String returnValue = "";
        String addPopList = pProvValue;
        
        for (int i = 0; i < arryProvValue.length; i++) {
            returnValue = "";
            returnValue = addPropList(pClass, arryProvValue[i]);
            
            if (!returnValue.equals("")) {
            	addPopList = addPopList + ";" + returnValue;
            }
        }
        
        logger.debug("addPopList=" + addPopList);
        logger.debug("convertAddandConvert ended");
        
        return addPopList;              
    }
    
    private String addPropList(String pType, String pAttribute) {
    	logger.debug("addPropList started");
    	String strRet = "";

        if (!pType.equals("user")) {
            // 부서
            switch (pAttribute.toUpperCase()) {
                case "DISPLAYNAME": strRet = "displayName1;displayName2";
                    break;
                case "DESCRIPTION": strRet = "description1;description2";
                    break;
                case "COMPANY": strRet = "company1;company2";
                    break;
                default: strRet = "";
                    break;
            }
        } else {
        	//사용자
            switch (pAttribute.toUpperCase()) {
                case "DISPLAYNAME": strRet = "displayName1;displayName2";
                    break;
                case "DESCRIPTION": strRet = "description1;description2";
                    break;
                case "COMPANY": strRet = "company1;company2";
                    break;
                case "TITLE": strRet = "title1;title2";
                    break;
                case "EXTENSIONATTRIBUTE10": strRet = "extensionAttribute101;extensionAttribute102";
                    break;
                case "UPNNAME":
                    strRet = "upnName";
                    break;
                default: strRet = "";
                    break;
            }
        }
        
        logger.debug("addPropList ended");
        
        return strRet;
    }
    
    @Override
    public String getIsAttitude(String typeId, String writerId, String startDate, String offset, String companyId, int tenantId, String isOutCheck) throws Exception {
    	logger.debug("getIsAttitude started");
    	Map<String,Object> map = new HashMap<String, Object>();
    	
    	if (startDate.equals("")) {
			startDate = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), offset, false);
    	}
    	
    	if (typeId.equals("A01") || typeId.equals("A02")) {
    		typeId = "A01,A02";
    	} 
    	else if (typeId.equals("A03") && !isOutCheck.equals("true")) {// 퇴근은 여러번 찍을 수 있으므로 조회시 조퇴여부만 확인한다.
    		typeId = "A08";
    	}
    	else if (typeId.equals("A03") && isOutCheck.equals("true")) {// 퇴근은 여러번 찍을 수 있으므로 등록시 퇴근여부만 확인한다.
    		typeId = "A03";
    		map.put("typeId", typeId);
    		map.put("isOutCheck", isOutCheck);
    	}
    	else if (typeId.equals("A08")) {
    		typeId = "A03,A08";
    	}
    	//2020-06-03 김정언 : 새벽 퇴근 기능 추가
    	else if(typeId.equals("A26")) { //전날 출근이 찍혀 있는지 확인한다.
    		typeId = "A01,A02";
    		startDate = commonUtil.getDayBefore(startDate.split(" ")[0]);
    	}
    	else if(typeId.equals("A25")) { //전날 퇴근이 찍혀 있는지 확인한다.
    		typeId = "A03,A08";
    		startDate = commonUtil.getDayBefore(startDate.split(" ")[0]);
    	}
    	else if(typeId.equals("A27")) { //오늘 날짜로 전날 퇴근이 찍혀 있는지 확인한다.
    		typeId = "A25";
    	}

    	map.put("typeIdArr", typeId.split(","));
    	map.put("writerId", writerId);
    	map.put("offsetMin", commonUtil.getMinuteUTC(offset));
    	map.put("companyId", companyId);
    	map.put("tenantId", tenantId);
		map.put("checkStartDate", startDate.split(" ")[0]);
		
		logger.debug("getIsAttitude ended");

		return ezAttitudeDAO.getIsAttitude(map);
    }

	@Override
	public List<AttitudeAuthorVO> getDeptUserList(int tenantId, String key, String value, String companyId, String lang) throws Exception {
		logger.debug("getDeptUserList started");
		
		HashMap<String, Object> map = new HashMap<String, Object>();
		
		map.put("tenantId", tenantId);
		map.put("key", key.toUpperCase());
		map.put("value", value);
		map.put("companyId", companyId);
		if (lang.equals("1")) {
			lang = "";
		}
		map.put("lang", lang);
		
		logger.debug("getDeptUserList ended");
		
		return ezAttitudeDAO.getDeptUserList(map);
	}

	@Override
	public String getAttitudeAnnualListCount(String searchUserName,
			String searchDeptName, String searchTitle, String offsetMin, String companyId, int tenantId, String primary) throws Exception {
		logger.debug("getAttitudeAnnualListCount started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		map.put("searchUserName", searchUserName);
		map.put("searchDeptName", searchDeptName);
		map.put("searchTitle", searchTitle);
		map.put("offsetMin", offsetMin);
		if (primary.equals("1")) {
			primary = "";
		}
		map.put("primary", primary);
		
		String totalCount = ezAttitudeDAO.getAttitudeAnnualListCount(map);
		
		logger.debug("getAttitudeAnnualListCount ended. totalCount = " + totalCount);
		
		return totalCount;
	}

	@Override
	public List<AttitudeAnnualVO> getAttitudeAnnualList(String searchUserName,
			String searchDeptName, String searchTitle, String orderCell, String orderOption, String offsetMin,
			String pageNum, String listSize, String companyId, int tenantId,
			String primary, String startDate, String endDate) throws Exception {
		logger.debug("getAttitudeAnnualList started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		if (StringUtils.isNotBlank(pageNum)) {
			int limit = 0;
			limit = (Integer.valueOf(pageNum) - 1) * Integer.valueOf(listSize);
			map.put("limit", limit);
			map.put("startRow", limit + 1);
			map.put("endRow", limit + Integer.valueOf(listSize));
		}
		
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		map.put("searchUserName", searchUserName);
		map.put("searchDeptName", searchDeptName);
		map.put("searchTitle", searchTitle);
		map.put("listSize", StringUtils.isBlank(listSize) ? 0 : Integer.parseInt(listSize));
		map.put("orderCell", orderCell.toUpperCase());
		map.put("orderOption", orderOption.toUpperCase());
		map.put("offsetMin", offsetMin);
		
		if (primary.equals("1")) {
			primary = "";
		}
		map.put("primary", primary);
		String searchStartTime = startDate + " 00:00:00";
		String searchEndTime = endDate + " 23:59:59";
		
		map.put("searchStartTime", searchStartTime);
		map.put("searchEndTime", searchEndTime);
		
		List<AttitudeAnnualVO> resultList = ezAttitudeDAO.getAttitudeAnnualList(map);
		
		logger.debug("getAttitudeAnnualList ended. resultList size = " + resultList.size());
		
		return resultList;
	}
	
	@Override
	public void changeAllAnnual(Map<String, Object> map) throws Exception {
		logger.debug("changeAllAnnual started");

		List<Map<String, Object>> userList = ezAttitudeDAO.getUserList(map);
		
		String annualCnt = (String) map.get("annualCnt");
		String changeUserId = (String) map.get("changeUserId");
		String changeReason = (String) map.get("changeReason");
		
		if (userList != null) {
			for (Map<String, Object> userMap : userList) {
				userMap.put("annualCnt", annualCnt);
				userMap.put("changeUserId", changeUserId);
				userMap.put("changeReason", changeReason);
				changeAnnual(userMap);
			}
		}
		
		logger.debug("changeAllAnnual ended");
	}
	
	@Override
	public void changeAnnual(Map<String, Object> map) throws Exception {
		logger.debug("changeAnnual started");
		
		ezAttitudeDAO.insertAnnualHistory(map);
		if (ezAttitudeDAO.getSimpleAnnualCnt(map) == 0) {
			ezAttitudeDAO.insertAnnual(map);
		} else {
			//ezAttitudeDAO.changeAnnualHistory(map);
			ezAttitudeDAO.changeAnnual(map);
		}
		
		logger.debug("changeAnnual ended");
	}
	
	@Override
	public void excelChangeAnnual(Map<String, Object> map) throws Exception {
		logger.debug("excelChangeAnnual started");
		
		//2020-01-08 김은석 추가 엑셀업로드시 기존의 히스토리는 전부 삭제
		ezAttitudeDAO.deleteAnnualHistory(map);
		ezAttitudeDAO.insertAnnualHistory(map);
		
		if (ezAttitudeDAO.getSimpleAnnualCnt(map) == 0) {
			ezAttitudeDAO.excelInsertAnnual(map);
		} else {
			//ezAttitudeDAO.changeAnnualHistory(map);
			ezAttitudeDAO.excelChangeAnnual(map);
		}
		//2020-01-08 김은석 추가 TBL_ATTITUDE_ANNUAL 업데이트 후 변경된 연차로 history 테이블에서 수정
		ezAttitudeDAO.updateAnnualHistory(map);
		
		logger.debug("excelChangeAnnual ended");
	}
	
	@Override
	public AttitudeAnnualVO getAnnualCnt(Map<String, Object> map) throws Exception {
		logger.debug("getAnnualCnt started");

		AttitudeAnnualVO result = ezAttitudeDAO.getAnnualCnt(map);
		
		logger.debug("getAnnualCnt ended");
		
		return result;
	}

	@Override
	public List<Map<String, Object>> getAnnualHistoryList(Map<String, Object> map) throws Exception {
		logger.debug("getAnnualHistoryList started");
		
		List<Map<String, Object>> result = ezAttitudeDAO.getAnnualHistoryList(map);
		
		logger.debug("getAnnualHistoryList ended");
		
		return result;
	}

	@Override
	public List<AdminAttitudeVO> getUserAnnual(String userId, String primary, String offset, String startDate, String endDate, String orderCell, String orderOption, String secondYear, String companyId, int tenantId) throws Exception {
		logger.debug("getUserAnnual started");
		
		Map<String, Object> map = new HashMap<String, Object>();

		String startTime = startDate + " 00:00:00";
		String endTime = endDate + " 23:59:59";
		
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		map.put("orderCell", orderCell.toUpperCase());
		map.put("orderOption", orderOption.toUpperCase());
		map.put("startTime", startTime);
		map.put("endTime", endTime);
		map.put("offsetMin", commonUtil.getMinuteUTC(offset));
		if (primary.equals("1")) {
			primary = "";
		} else {
			primary = "2";
		}
		map.put("primary", primary);
		map.put("userId", userId);
		
		List<AdminAttitudeVO> list = ezAttitudeDAO.getUserAnnual(map);
		
		if (secondYear.equals("Y") || secondYear.equals("T")) {
			Map<String, Object> map2 = new HashMap<String, Object>();
			map2.put("userId", userId);
			map2.put("companyId", companyId);
			map2.put("tenantId", tenantId);
			map2.put("offsetMin", commonUtil.getMinuteUTC(offset));
			
			if (primary.equals("1")) {
				primary = "";
			}
			map2.put("primary", primary);
			
			String searchStartTime = null;
			
			if (secondYear.equals("Y")) {
				searchStartTime = (Integer.parseInt(startDate.substring(0, 4)) - 1) + startDate.substring(4, 10) + " 00:00:00";
			} else {
				searchStartTime = (Integer.parseInt(startDate.substring(0, 4)) - 2) + startDate.substring(4, 10) + " 00:00:00";
			}
			String searchEndTime = (Integer.parseInt(endDate.substring(0, 4)) - 1) + endDate.substring(4, 10) + " 23:59:59";
			
			map2.put("searchStartTime", searchStartTime);
			map2.put("searchEndTime", searchEndTime);
			
			AttitudeAnnualVO v = getAnnualCnt(map2);
			
			double useAnnualCnt = Double.parseDouble(v.getUseAnnualCnt());
			if (useAnnualCnt > 11.0) {
				useAnnualCnt = 11.0;
			}
			double totalAnnualCnt = Double.parseDouble(v.getTotalAnnualCnt());
			if (v.getJoinDate() != null) {
				list.get(0).setTotalAnnualCnt(totalAnnualCnt - useAnnualCnt + "");
			}
		}
		
		logger.debug("getUserAnnual ended.");
		
		return list;
	}

	@Override
	public String annualExcelUpload(List<Map<String, Object>> excelList, String changeUserId, String companyId, int tenantId, String changeReason, String flagCheck, Locale locale) throws Exception {
		logger.debug("annualExcelUpload started");
		
		Map<String, Object> excelVo = null;
		Map<String, Object> map1 = null;
		Map<String, Object> map2 = null;
		String joinDate = null;
		String userId = null;
		String totalAnnualCnt = null;
		int userCnt = 0;
		
		for (int i=1; i<excelList.size(); i++) {
			
			excelVo = excelList.get(i);
			userId = (String) excelVo.get("A");
			joinDate = (String) excelVo.get("B");
			totalAnnualCnt = (String) excelVo.get("C");
			
			if (!excelCellRef.nullCheck(excelCellRef.validateCheck(i+1, messageSource.getMessage("ezAttitude.t289", locale), joinDate, 10, "4", locale))) {
				return excelCellRef.validateCheck(i+1, messageSource.getMessage("ezAttitude.t289", locale), joinDate, 10, "4", locale);
			}
			if (!excelCellRef.nullCheck(excelCellRef.validateCheck(i+1, messageSource.getMessage("ezEmail.t263", locale), userId, 80, "2", locale))) {
				return excelCellRef.validateCheck(i+1, messageSource.getMessage("ezEmail.t263", locale), userId, 80, "2", locale);
			}
			if (!excelCellRef.nullCheck(excelCellRef.validateCheck(i+1, messageSource.getMessage("ezAttitude.t239", locale), totalAnnualCnt, 8, "3", locale))) {
				return excelCellRef.validateCheck(i+1, messageSource.getMessage("ezAttitude.t239", locale), totalAnnualCnt, 5, "3", locale);
			}
			
			map1 = new HashMap<String, Object>();
			map1.put("userId", userId);
			map1.put("companyId", companyId);
			map1.put("tenantId", tenantId);
			if (ezAttitudeDAO.getUserList(map1) != null) {
				userCnt = ezAttitudeDAO.getUserList(map1).size();
			}
			
			if (userCnt == 0) {
				return i+1 + messageSource.getMessage("ezAttitude.t319", locale) + userId + messageSource.getMessage("ezAttitude.t326", locale);
			}
		}
		
		for (int i=1; i<excelList.size(); i++) {
			excelVo = excelList.get(i);
			
			map2 = new HashMap<String, Object>();
			map2.put("userId", excelVo.get("A"));
			map2.put("joinDate", excelVo.get("B"));
			map2.put("annualCnt", excelVo.get("C"));
			map2.put("companyId", companyId);
			map2.put("tenantId", tenantId);
			map2.put("changeUserId", changeUserId);
			map2.put("changeReason", changeReason);
			map2.put("flagCheck", flagCheck);
			
			excelChangeAnnual(map2);
		}
		
		logger.debug("annualExcelUpload started");
		return messageSource.getMessage("ezAttitude.t327", locale);
	}
	
	@Override
	public Map<String, Object> getMonthlyAnnualList(String userId, String offset, String startDate, String endDate, int tenantId) throws Exception {
		logger.debug("getMonthlyAnnualList started");
		
		Map<String, Object> map = new HashMap<String, Object>();

		map.put("offsetMin", commonUtil.getMinuteUTC(offset));
		map.put("userId", userId);
		map.put("startDate", startDate);
		map.put("endDate", endDate);
		map.put("tenantId", tenantId);
		
		logger.debug("getMonthlyAnnualList ended");
		return ezAttitudeDAO.getMonthlyAnnualList(map);
	}
	
	@Override
	public String saveCancelAnnual(String attitudeId, String companyId,
			int tenantId, String userId, String writerName, String writerName2, String writerTitle
			, String writerTitle2, String writerDeptId, String writerDeptName, String writerDeptName2
			, String delFlag, String content,String offset) throws Exception {
		logger.debug("saveCancelAnnual started");
		
		content = content.replaceAll("\'", "&#39;").replaceAll("(\r\n|\r|\n|\n\r)", " ");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("attitudeId", attitudeId);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("writerId", userId);
		map.put("writerName", writerName);
		map.put("writerName2", writerName2);
		map.put("writerTitle", writerTitle);
		map.put("writerTitle2", writerTitle2);
		map.put("writerDeptId", writerDeptId);
		map.put("writerDeptName", writerDeptName);
		map.put("writerDeptName2", writerDeptName2);
		map.put("delFlag", delFlag);
		map.put("content", content);
		map.put("apprStatus", "0");
		map.put("offset", offset);
		map.put("modappl", "1");
		map.put("applDate", commonUtil.getTodayUTCTime(""));
		
		/*이미 신청된 항목이 있는지, 
		 * 이미 신청된 항목의 상태가 
		 * 승인, 반려 상태인지 확인
		 * */
		
		int modAppl = ezAttitudeDAO.getAttModApp(map);
		if (modAppl == 0) {
			modAppl = 1;
		} else if (modAppl == 4){
			modAppl = 2;
		}
		
		map.put("modappl", modAppl);
		
		/*근태수정신청 저장*/
		ezAttitudeDAO.saveCancelAnnual(map);
		/*attitude modappl수정*/
		ezAttitudeDAO.setAttModApp(map);
		/*근태정보 가져오기*/
		//getAttitudeInfo(attitudeId, offset, "", tenantId);
		logger.debug("saveCancelAnnual ended");
		
		return "success";
	}
	
	@Override
	public List<Map<String, Object>> getTenantCompanyId() throws Exception {
		return ezAttitudeDAO.getTenantCompanuId();
	}

	@Override
	public List<Map<String, Object>> getJoinDateUserList(String yesterday, String companyId, int tenantId) throws Exception {
		logger.debug("getJoinDateUserList started");
		
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("yesterday", yesterday);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		logger.debug("getJoinDateUserList ended");
		
		return ezAttitudeDAO.getJoinDateUserList(map);
	}
	
	@Override
	public void updateAnnualHoliday(Map<String, Object> map) throws Exception {
		logger.debug("updateAnnualHoliday started");
		
		String companyId = (String)map.get("companyId");
		int tenantId = Integer.parseInt(String.valueOf(map.get("tenantId")));
		String joinDate = (String)map.get("joinDate");
		String today = commonUtil.getTodayUTCTime("yyyy-MM-dd");

		int workingDayCnt = checkHoliday(joinDate, today, "1", companyId, tenantId).size(); //workingDayCnt : 소정근로일수
		float attendanceDay = (float) ezAttitudeDAO.getAttendanceDay(map); //attendanceDay : 출근일
		float attendanceRate = (float) ((attendanceDay / workingDayCnt) * 100.0); // 출근율
		
		if (attendanceRate >= 80.0) {
			map.put("holidayCnt", defaultAnnualHolidayCnt); // 기본 연차(15개) 발생
		} else {
			int monthlyHolidayCnt = ezAttitudeDAO.getMonthlyHolidayCnt(map); // DB에서 1년 차에 월차 개념으로 발생한 연차 개수 가져오기 (MONTHLY_HOLIDAY_CNT)
			map.put("holidayCnt", monthlyHolidayCnt);
		}

		map.put("attendanceRateCondition","1");
		
		ezAttitudeDAO.updateAnnualHoliday(map); // MONTHLY_HOLIDAY_CNT에서 가져온 값을 ANNUAL_HOLIDAY_CNT에 넣어주기

		setAnnualHistory(map);
		
		logger.debug("updateAnnualHoliday ended");
	}
	
	public int getExceedAnnualCnt(Map<String, Object> map) throws Exception {
		
		int AnnualCnt = 0;
		
		for (int i = 1; i < 13; i++) {
		
			String today = commonUtil.getTodayUTCTime("yyyy-MM-dd");
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			Date setDate = sdf.parse(today);
			Calendar cal = Calendar.getInstance();
			cal.setTime(setDate);
			cal.add(Calendar.DATE, -1);
			cal.add(Calendar.MONTH, -i+1);
			
			String MonthAgo1 = sdf.format(cal.getTime());
			cal.add(Calendar.MONTH, -1);
			String MonthAgo2 = sdf.format(cal.getTime());
			
			map.put("oneMonthAgo",MonthAgo2);
			map.put("oneDayAgo", MonthAgo1);
			
			int workingDayCnt = checkHoliday(MonthAgo2, MonthAgo1, "1", (String)map.get("companyId"), Integer.parseInt(String.valueOf(map.get("tenantId")))).size();
			int attendanceDay = ezAttitudeDAO.getAttendanceDay(map);
			
			if (workingDayCnt <= attendanceDay) {
				AnnualCnt++;
			}
		}
		
		return AnnualCnt;
	}
	
	@Override
	public void updateExceedAnnualHoliday(Map<String,Object> map) throws Exception {
		logger.debug("updateExceedAnnualHoliday started");
		
		String today = commonUtil.getTodayUTCTime("yyyy-MM-dd");
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Date setDate = sdf.parse(today);
		Calendar cal = Calendar.getInstance();
		cal.setTime(setDate);
		cal.add(Calendar.YEAR, -1);
		String beforeOneYear = sdf.format(cal.getTime());
		
		map.put("oneMonthAgo",beforeOneYear);
		map.put("oneDayAgo", today);
		
		int annualHolidayCnt = 0;
		int workingDayCnt = checkHoliday(beforeOneYear, today, "1", (String)map.get("companyId"), Integer.parseInt(String.valueOf(map.get("tenantId")))).size();
		float attendanceDay = (float) ezAttitudeDAO.getAttendanceDay(map);
		float attendanceRate = (float) ((attendanceDay / workingDayCnt) * 100.0);

		// 출근율이 80% 이상일 때
		if (attendanceRate >= 80.0) {
			
			int workingMonthCnt = Integer.parseInt((String)map.get("workingMonthCnt"));
			annualHolidayCnt = defaultAnnualHolidayCnt + (int) (workingMonthCnt / 12 - 1) / 2;
			annualHolidayCnt = annualHolidayCnt > 25 ? 25 : annualHolidayCnt; // 3년 차부터 연차는 최대 25개를 넘을 수 없기 때문에 25개를 초과할 시 25로 설정
			
		// 출근율이 80% 미만일 때
		} else {
			annualHolidayCnt = getExceedAnnualCnt(map); // 전년도의 출근율을 계산하여 월차의 개념으로 연차를 발생시킴
		}
		
		// 입사한지 2년이 됐을 때 남아있는 월차는 모두 0으로 초기화해준다.
		map.put("holidayCnt", 0);
		map.put("attendanceRateCondition","3");
		setAnnualHistory(map);
		ezAttitudeDAO.updateAnnualHoliday(map);

		
		map.put("holidayCnt", annualHolidayCnt);
		map.put("attendanceRateCondition","1");
		
		ezAttitudeDAO.updateAnnualHoliday(map);
		
		setAnnualHistory(map);
		
		logger.debug("updateExceedAnnualHoliday ended");
	}
	
	public void setAnnualHistory(Map<String, Object> map){
		logger.debug("setAnnualHistory started");

		map.put("annualCnt", map.get("holidayCnt"));
		if (map.get("attendanceRateCondition").equals("3")) {
			map.put("changeReason",messageSource.getMessage("ezAttitude.t281"));
		} else {
			map.put("changeReason",messageSource.getMessage("ezAttitude.t280") + map.get("holidayCnt") + "일");
		}
		map.put("changeUserId","system");
		map.put("companyId",map.get("companyId"));
		map.put("tenantId",map.get("tenantId"));
		
		try {
				ezAttitudeDAO.changeAnnualHistory(map);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}

		logger.debug("setAnnualHistory ended");
	}
	
	@Override
	public void updateFiscalYearAnnualHoliday(Map<String, Object> map) throws Exception {
		logger.debug("updateFiscalYearAnnualHoliday started");
		
		List<Map<String, Object>> list = ezAttitudeDAO.getJoinDateUserList(map);
		
		for (Map<String, Object> m : list) {
			
			if(m.get("joinDate") != null && m.get("workingMonthCnt") != null) {
				
				int workingMonthCnt = Integer.parseInt(String.valueOf(m.get("workingMonthCnt")));
				SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy");
				String year = sdf2.format(new Date());
				String date1 = (String)m.get("joinDate");
				String date2 = year + "-" + ((String)map.get("initialDate")).substring(((String)map.get("initialDate")).indexOf("-") + 1);
				String roundOffRule = (String)map.get("roundOffRule");
				
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
				Date joinDate = sdf.parse(date1);
				Date initialDate = sdf.parse(date2);
				
				// 입사 후 처음으로 맞이하는 기산일은 12개월을 넘을 수 없음
				// 첫 기산일 이후에는 3년 차 연차 발생계산법 사용
				if (workingMonthCnt < 12) {
					
					double calDate = joinDate.getTime() - initialDate.getTime();
					double calDatetoDays = Math.abs(calDate / (24 * 60 * 60 * 1000)); 
					double annualHolidayCnt = Math.floor((15.0 * calDatetoDays / 365.0 * 10 )) / 10.0;
					
					if (roundOffRule.equals("1")) {
						double demicalHoliday = Math.round(((annualHolidayCnt % 1) * 10) ) / 10.0;
						if (demicalHoliday > 0.5) {
							annualHolidayCnt = (int)Math.round(annualHolidayCnt);
						} else if (demicalHoliday > 0.0 && demicalHoliday < 0.5) {
							annualHolidayCnt = (int)annualHolidayCnt + 0.5;
						}
						
					} else {
						annualHolidayCnt = (int)Math.ceil(annualHolidayCnt);
					}
					
					m.put("holidayCnt", annualHolidayCnt);
					m.put("attendanceRateCondition","1");
					
					ezAttitudeDAO.updateAnnualHoliday(m);
					setAnnualHistory(m);
					
				} else {
					
					Calendar cal = Calendar.getInstance();
					cal.setTime(initialDate);
					cal.add(Calendar.YEAR, -1);
					String beforeOneYearInitialDate = sdf.format(cal.getTime());
					
					int workingDayCnt = checkHoliday(beforeOneYearInitialDate, sdf.format(initialDate), "1", (String)m.get("companyId"), Integer.parseInt(String.valueOf(m.get("tenantId")))).size();
					float attendanceDay = (float) ezAttitudeDAO.getAttendanceDay(m);
					float attendanceRate = (float) ((attendanceDay / workingDayCnt) * 100.0);
					
					int annualHolidayCnt = 0;

					if (attendanceRate >= 80.0) {
						annualHolidayCnt = defaultAnnualHolidayCnt + (int)(workingMonthCnt / 12 - 1) / 2;
						annualHolidayCnt = annualHolidayCnt > 25 ? 25 : annualHolidayCnt; // 연차는 최대 25개를 넘을 수 없기 때문에 25개를 초과할 시 25로 설정
					} else {
						annualHolidayCnt = getExceedAnnualCnt(m); // 전년도의 출근율을 계산하여 월차의 개념으로 연차를 발생시킴
					}
					
					// 3년 차일 때 연차, 월차 0으로 초기화 후 계산한 연차를 DB에 넣어줌
					if (workingMonthCnt > 24) {
						m.put("holidayCnt", 0);
						m.put("attendanceRateCondition","3");
						setAnnualHistory(m);
						ezAttitudeDAO.updateAnnualHoliday(m);
					}
				
					m.put("holidayCnt", annualHolidayCnt);
					m.put("attendanceRateCondition","1");
					
					ezAttitudeDAO.updateAnnualHoliday(m);
					setAnnualHistory(m);
				}
			}
		}
		logger.debug("updateFiscalYearAnnualHoliday ended");
	}
	
	@Override
	public void updateMonthlyHoliday(Map<String, Object> map) throws Exception {
		logger.debug("updateMonthlyHoliday started");
		logger.debug("userId = " + map.get("userId") + " || joinDate = " + map.get("joinDate"));
		String companyId = (String)map.get("companyId");
		int tenantId = Integer.parseInt(String.valueOf(map.get("tenantId")));
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String today = sdf.format(new Date());
		Date setDate = sdf.parse(today);
		Calendar cal = Calendar.getInstance();
		cal.setTime(setDate);
		cal.add(Calendar.DATE, -1);
		String oneDayAgo = sdf.format(cal.getTime());
		cal.add(Calendar.MONTH, -1);
		String oneMonthAgo = sdf.format(cal.getTime());
		
		map.put("oneMonthAgo",oneMonthAgo);
		map.put("oneDayAgo", oneDayAgo);
		
		int userAbsentCnt = ezAttitudeDAO.checkAbsentDay(map); // DB에서 결근한 날 가져오기
		/*
		 * userAttendanceCnt = 전 달 소정근로일수
		 * monthWorkingDayCnt =  전 달 사용자 실제 출근일수
		 * */
		int userAttendanceCnt = checkHoliday(oneMonthAgo, oneDayAgo, "1", companyId, tenantId).size();
		int monthWorkingDayCnt = ezAttitudeDAO.getAttendanceDay(map);
		
		// 결근일과 실제사용자 출근일과 출근해야하는 날을 비교하여 월차 생성
		// 전달에 결근일이 하루라도 있으면 개근이 아니므로 월차가 생성되지 않는다.
		if (userAbsentCnt == 0 && (userAttendanceCnt <= monthWorkingDayCnt)) {
			@SuppressWarnings("unused")
			int monthlyHolidayCnt = ezAttitudeDAO.getMonthlyHolidayCnt(map);
			map.put("holidayCnt",  +1);
			map.put("attendanceRateCondition","2");
			
			ezAttitudeDAO.updateAnnualHoliday(map);

			setAnnualHistory(map);
			
		}
	
		logger.debug("updateMonthlyHoliday ended");
	
	}
	
	@Override
	public void extinctionMonthlyHoliday(Map<String, Object> map) throws Exception {
		logger.debug("extinctionMonthlyHoliday started");
		
		double totalAnnualCnt = 0.0;
		for ( Map<String, Object> m : ezAttitudeDAO.getuserAnnualCnt(map)) {
			// typeId가 연차라면 1을 곱해서 totalAnuualCnt에 누적하고, 연차가 아니라면 0.5를 곱하여 누적
			totalAnnualCnt += ((String)m.get("typeId")).equals("A11") ? Double.parseDouble((String.valueOf(m.get("cnt")))) * 1.0 : Double.parseDouble((String.valueOf(m.get("cnt")))) * 0.5;
		}
		
		double userMonthlyHolidayCnt = ezAttitudeDAO.getMonthlyHolidayCnt(map) - totalAnnualCnt;
		int workingMonthCnt = Integer.parseInt((String)map.get("workingMonthCnt"));
		
		if (userMonthlyHolidayCnt >= (double)(workingMonthCnt - (workingMonthCnt - 12.0 ) * 2.0)) { 
			@SuppressWarnings("unused")
			int monthlyHolidayCnt = ezAttitudeDAO.getMonthlyHolidayCnt(map);
			map.put("holidayCnt", -1);
			map.put("attendanceRateCondition","2");
			ezAttitudeDAO.updateAnnualHoliday(map);
			
			setAnnualHistory(map);
		}
		
		logger.debug("extinctionMonthlyHoliday ended");
	}

	@Override
	public int deleteCancelAnnual(String companyId, int tenantId, String attitudeId) throws Exception {
		logger.debug("deleteCancelAnnual started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		int modAppl = 0;
		int data = 1;
		
		map.put("attitudeId", attitudeId);
		map.put("attModId", attitudeId);
		modAppl = ezAttitudeDAO.getAttModApp(map);
		map.put("modappl",modAppl);
		//ezAttitudeDAO.getAnnCanHistory
		if (modAppl == 1) {
			map.put("modappl", "0");
		} else if (modAppl == 2) {
			map.put("modappl", "4");
		}
		String apprStatus = ezAttitudeDAO.checkCanApplStatus(map);
		if (apprStatus != null && !apprStatus.equals("0")) {
			data = 0;
			
		} else {
			/*근태 수정신청 삭제.*/
			ezAttitudeDAO.delCanAppl(map);
			/*근태 수정신청이 삭제되고 원본 근태에 대해 수정신청 개수가 0개 일 때 원본 근태를 수정 가능한 상태로 변경.*/
			ezAttitudeDAO.resetAttModApp(map);
		}

		logger.debug("deleteCancelAnnual ended");
		
		return data;
	}
	
	@Override
	public String sendMailToReference(AttitudeVO vo, String attitudeId, String idList, HttpServletRequest request, String loginCookie, LoginVO userInfo, String orgCompanyID, int tenantID) throws Exception {
		
		logger.debug("sendMailToReference started.");
		
		String result = "";
		
		InternetAddress from = new InternetAddress();
		from.setPersonal(userInfo.getDisplayName(), "UTF-8");
		from.setAddress(userInfo.getEmail());
		
		String[] ids = idList.split(",");
		
		InternetAddress[] to = new InternetAddress[ids.length];
		
		for(int i = 0; i < ids.length; i++) {
			String targetUserID = ids[i];
			String targetUserName = "";
			String targetUserEmail = "";
			// String targetUserDeptID = "";
			// String targetUserCompanyID = "";
			
			targetUserEmail = ezOrganService.getPropertyValue(targetUserID, "mail", tenantID);
			targetUserName = ezOrganService.getPropertyValue(targetUserID, "displayName", tenantID);
			
			InternetAddress tempTo = new InternetAddress();
			tempTo.setPersonal(targetUserName, "UTF-8");
			tempTo.setAddress(targetUserEmail);
			
			logger.debug("target : " + targetUserID + "/" + targetUserName + "/" + targetUserEmail);
			
			to[i] = tempTo;
			
		}
		
		String attitudeDate = "";
		String startDate = vo.getStartDate().substring(0, 10);
		String endDate = vo.getEndDate().substring(0, 10);
		if(vo.getTypeId().equals("A11")) {
			
			attitudeDate = startDate.split("-")[0] + messageSource.getMessage("ezAttitude.t66", userInfo.getLocale()) + startDate.split("-")[1] + messageSource.getMessage("ezAttitude.t67", userInfo.getLocale()) + startDate.split("-")[2] + messageSource.getMessage("ezAttitude.t68", userInfo.getLocale()) + 
					" ~ " + endDate.split("-")[0] + messageSource.getMessage("ezAttitude.t66", userInfo.getLocale()) + endDate.split("-")[1] + messageSource.getMessage("ezAttitude.t67", userInfo.getLocale()) + endDate.split("-")[2] + messageSource.getMessage("ezAttitude.t68", userInfo.getLocale());
		} else  {
			attitudeDate = startDate.split("-")[0] + messageSource.getMessage("ezAttitude.t66", userInfo.getLocale()) + startDate.split("-")[1] + messageSource.getMessage("ezAttitude.t67", userInfo.getLocale()) + startDate.split("-")[2] + messageSource.getMessage("ezAttitude.t68", userInfo.getLocale());
		}
		
    	String Subject = "";
    	StringBuffer bodyContent = new StringBuffer();
    	
    	Subject = "["+messageSource.getMessage("ezAttitude.t314", userInfo.getLocale())+"]" + " " + attitudeDate; //[연차취소신청알림] + attitudeDate
    	
    	bodyContent.append("<DIV id=\"msgBody\" style=\"font-size: 13px; font-family: " + messageSource.getMessage("main.t246", userInfo.getLocale()) + ";\" name=\"urn:schemas:httpmail:textdescription\">");
    	bodyContent.append("<table width='750' cellpadding='0' cellspacing='0' border='0' ><tr align='left'><td>");
    	bodyContent.append("<span style='font-size:13pt;'>" + messageSource.getMessage("ezAttitude.t112", userInfo.getLocale()) + messageSource.getMessage("ezQuestion.t910030", userInfo.getLocale()) + ": " + attitudeDate + "</span><br>");
    	bodyContent.append("<span style='font-size:13pt;'>" + messageSource.getMessage("ezAttitude.t35", userInfo.getLocale()) + ": " + vo.getTypeName() + "</span><br>");
    	bodyContent.append("<span style='font-size:13pt;'>" + messageSource.getMessage("ezAttitude.t147", userInfo.getLocale()) + ": " + userInfo.getDisplayName() + "</span><br>");
    	bodyContent.append("<span style='font-size:13pt;'>" + messageSource.getMessage("ezAttitude.t108", userInfo.getLocale()) + ": " + commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), userInfo.getOffset(), false) + "</span><br>");
    	bodyContent.append("</td></tr></table></DIV>");

    	ezEmailService.sendMail(loginCookie, from, to, null, null, Subject, bodyContent.toString(), false);
		
    	logger.debug("sendMailToReference ended.");
		return result;
	}
	
	@Override
	public int getUsersCancelAnnCount(String companyId, int tenantId, String userId, String startDate, String endDate,
			String apprUserName, String writerName , String writerDeptName, String lang, String offset, String type, String deptId, List<String> deptIdList,String adminFlag, String checkAdmin) throws Exception {
		logger.debug("getUsersCancelAnnCount started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		logger.debug("checkAdmin : " + checkAdmin);
		logger.debug("adminFlag : " + adminFlag);
		
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("searchDeptId", deptId);
		map.put("deptIdList", deptIdList);
		map.put("startDate", startDate);
		map.put("endDate", endDate);
		map.put("apprUserName", apprUserName);
		map.put("writerName", writerName);
		map.put("writerDeptName", writerDeptName);
		if (lang.equals("1")) {
			lang = "";
		}
		map.put("lang", lang);
		map.put("offset", offset);
		map.put("type", type);
		
		if (adminFlag.equals("false")) {
			map.put("userId", userId);
		}
		
		int attAppListCount = ezAttitudeDAO.getUsersCancelAnnCount(map);
		
		logger.debug("getUsersCancelAnnCount ended");
		
		return attAppListCount;
	}
	
	@Override
	public List<AttitudeApplicationVO> getUsersCancelAnn(String companyId, int tenantId,
			String userId, String startDate, String endDate, String apprUserName, String writerName, String writerDeptName, String lang, 
			String offset,String startPoint, String endPoint, String type, String order, String adminFlag, String checkAdmin, String deptId, List<String> deptIdList) throws Exception {
		logger.debug("getUsersCancelAnn started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("searchDeptId", deptId);
		map.put("deptIdList", deptIdList);
		map.put("startDate", startDate);
		map.put("endDate", endDate);
		map.put("apprUserName", apprUserName);
		map.put("writerName", writerName);
		map.put("writerDeptName", writerDeptName);
		if (lang.equals("1")) {
			lang = "";
		}
		map.put("lang", lang);
		map.put("offset", offset);
		
		if (startPoint != null) {
			map.put("startPoint", Integer.parseInt(startPoint));
		}
		if (endPoint != null) {
			map.put("endPoint", Integer.parseInt(endPoint));
		}
		
		map.put("type", type);
		
		if (startPoint != null && endPoint != null && !startPoint.equals("") && !endPoint.equals("")) {
			map.put("startRow", Integer.parseInt(startPoint) + 1);
			map.put("endRow", Integer.parseInt(startPoint) + Integer.parseInt(endPoint));
		}
		
		if (adminFlag.equals("false")) {
			map.put("userId", userId);
		}
		
		/* 2024-07-23 홍승비 - SQL Injection 수정 > $ 기호 제거, 정렬 조건 분리 */
		// 휴가일자(START_DATE), 신청자(WRITER_NAME), 신청부서(WRITER_DEPT_NAME), 휴가유형(TYPE_NAME), 승인상태(APPR_STATUS), 승인자(APPR_USER_NAME), 신청일자(APPL_DATE)
		if (order != null && !order.trim().equals("")) {
			map.put("orderColumn", order.trim().split(" ")[0]);
			map.put("orderSort", order.trim().split(" ")[1]);
		}
		
		List<AttitudeApplicationVO> attAppList = ezAttitudeDAO.getUsersCancelAnn(map); 
		
		logger.debug("getUsersCancelAnn ended");
		
		return attAppList;
	}
	
	@Override
	public AttitudeApplicationVO annCanAppDetail(String attModId, String offset, String applCnt, String lang, String companyId, int tenantId) throws Exception {
		logger.debug("annCanAppDetail started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("attModId", attModId);
		map.put("offset", offset);
		map.put("applCnt", applCnt);
		if (lang.equals("1")) {
			lang = "";
		}
		map.put("lang", lang);
		
		logger.debug("annCanAppDetail ended");
		
		return ezAttitudeDAO.annCanAppDetail(map);
	}
	
	@Override
	public void changeUsersCancelAnn(String companyId, int tenantId, String ids, String changeStatus, String userId, String userName, String userName2, String offSet) throws Exception {
		logger.debug("changeUsersCancelAnn started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		String offsetMin = commonUtil.getMinuteUTC(offSet);
		
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		map.put("ids", ids.split("_")[0]);
		map.put("attModId", ids.split("_")[0]);
		map.put("attitudeId", ids.split("_")[0]);
		
		if (ids.split("_").length > 1) {
			map.put("applCnt", ids.split("_")[1]);
		}
		map.put("changeStatus", changeStatus);
		map.put("offsetMin", offsetMin);
		map.put("offset", offsetMin);
		map.put("apprDate",commonUtil.getTodayUTCTime(""));
		map.put("userId",userId);
		map.put("displayName",userName);
		map.put("displayName2",userName2);
		
		String apprStatus = ezAttitudeDAO.checkCanApplStatus(map);
		//신청상태가 아니면 return
		if (apprStatus != null && !apprStatus.equals("0")) {
			return;
		}
		
		ezAttitudeDAO.changeUsersCancelAnn(map);
		
		//승인일 때 사용자의 연차일정 삭제
		if(changeStatus.equals("appr")){
			map.put("modappl", 5);
			ezAttitudeDAO.setAttModApp(map);
			
		} else if (changeStatus.equals("ret")) {
			int modAppl = ezAttitudeDAO.getAttModApp(map);
			
			if (modAppl == 1 || modAppl == 2) {
				map.put("modappl", 4);
			} 
//			else if (modAppl == 2) {
//				map.put("modappl", 3);
//			}
			ezAttitudeDAO.setAttModApp(map);
		}
		logger.debug("changeUsersCancelAnn ended.");
	}
	
	@Override
	public List<AttitudeApplicationVO> getAnnCanHistory(String attModId, String userId, String offset, String lang, String companyId, int tenantId) throws Exception {
		logger.debug("getAnnCanHistory started");
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("userId", userId);
		if (attModId.indexOf("_") > 0) {
			attModId = attModId.split("_")[0];
		}
		map.put("attModId", attModId);
		map.put("offset", offset);
		if (lang.equals("1")) {
			lang = "";
		}
		map.put("lang", lang);
		
		List<AttitudeApplicationVO> attAppList = ezAttitudeDAO.getAnnCanHistory(map); 
		
		logger.debug("getAnnCanHistory ended");
		return attAppList;
	}
	
	@Override
	public void saveJoinDate(Map<String, Object> map) throws Exception {
		logger.debug("saveJoinDate started");
		
		if(ezAttitudeDAO.getSimpleAnnualCnt(map) == 0) {
			ezAttitudeDAO.saveJoinDate(map);
		} else {
			ezAttitudeDAO.modifyJoinDate(map);
		}
		
		logger.debug("saveJoinDate ended");
	}
	
	@Override
	public int approvalGConn(String userId, String deptId, String content, String mobile, String attitudeTypeList, String startDateList, String endDateList, String startTimeList, String endTimeList, String docId, String offset, String companyId, int tenantId) throws Exception {
		logger.debug("approvalGConn started");
		
		String[] attitudeTypeList2 = attitudeTypeList.split(",");
		String[] startDateList2 = startDateList.split(",");
		String[] endDateList2 = endDateList.split(",");
		content = content.replaceAll("\'", "&#39;").replaceAll("(\r\n|\r|\n|\n\r)", " ");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("offsetMin", commonUtil.getMinuteUTC(offset));
		map.put("region", "");
		map.put("mobile", mobile);
		map.put("bizSub", "");
		map.put("content", content);
		map.put("ipAddress", "");
		map.put("dateType", "4");
		map.put("modappl", "0");
		map.put("writerId", userId);
		map.put("deptId", deptId);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		//근태등록
		for (int i = 0; i < attitudeTypeList2.length; i++) {
			String startDate = "";
			String endDate = "";
			
			if(attitudeTypeList2[i].equals("A21")){
				String[] startTimeList2 = startTimeList.split(",");
				String[] endTimeList2 = endTimeList.split(",");
				
				startDate = startDateList2[i] + " " + startTimeList2[i]; 
				endDate = endDateList2[i] + " " + endTimeList2[i];
			}else{
				startDate = startDateList2[i] + " " + "00:00:00"; 
				endDate = endDateList2[i] + " " + "23:59:59";
			}
			
			map.put("typeId", attitudeTypeList2[i]);
			map.put("startDate", startDate);
			map.put("endDate", endDate);
			
			int attitudeId = ezAttitudeDAO.insertAttitude(map);
			
			//임시로 지정..
			String aprStatus = "0";
			
			//연동테이블에 insert
			insertApprovalGConnInfo(String.valueOf(attitudeId), userId, docId, aprStatus, companyId, tenantId);
		}
		logger.debug("approvalGConn ended");
		return 0;
	}
	
	private void insertApprovalGConnInfo(String attitudeId, String userId, String docId, String aprStatus, String companyId, int tenantId) throws Exception  {
		logger.debug("insertApprovalGConnInfo started");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("attitudeId", attitudeId);
		map.put("userId", userId);
		map.put("docId", docId);
		map.put("aprStatus", aprStatus);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		ezAttitudeDAO.insertApprovalGConnInfo(map);
		logger.debug("insertApprovalGConnInfo ended");
	}

	@Override
	public int updateApprovalGConnInfo(String aprStatus, String userId, String docId,	String companyId, int tenantId) throws Exception {
		logger.debug("updateApprovalGConnInfo started");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("docId", docId);
		map.put("aprStatus", aprStatus);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		List<String> attitudeIdList = ezAttitudeDAO.getApprovalGConnAttitudeList(map);
		if (attitudeIdList != null) {			
			ezAttitudeDAO.updateApprovalGConnInfo(map);
		}
		logger.debug("updateApprovalGConnInfo ended");
		return 0;
	}

	@Override
	public int deleteApprovalGConnInfo(String userId, String type, String docId, String companyId, int tenantId) throws Exception {
		logger.debug("deleteApprovalGConnInfo started");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("docId", docId);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		boolean isContinue = true;
		if (type.equals("hesong")) {
			isContinue = false;
			String hesongType = "";
			String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", tenantId);
			
			if (!approvalFlag.equals("G")) {
				hesongType = ezApprovalGService.getCode2Name("SA25", "001", companyId, "1", tenantId);				
				if (hesongType.equals("2")) {//기안자한테 돌아가는 경우
					isContinue = true;
				}
			}
		}
		
		if (isContinue) {			
			//docId가지고 있는 attitudeId를 받아온다.
			List<String> attitudeIdList = ezAttitudeDAO.getApprovalGConnAttitudeList(map);
			if (attitudeIdList != null) {
				for (int i = 0; i < attitudeIdList.size(); i++) {
					map.put("attitudeId", attitudeIdList.get(i));
					ezAttitudeDAO.deleteAttitude(map);		
				}			
			}
		}
		logger.debug("deleteApprovalGConnInfo ended");
		return 0;
	}
	
	@Override
	public Map<String, Object> getAttitudeAnnualConfig(int tenantId, String companyId) throws Exception {
		logger.debug("getAttitudeAnnualConfig started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		
		logger.debug("getAttitudeAnnualConfig ended");
		
		return ezAttitudeDAO.getAttitudeAnnualConfig(map);
	}
	
	@Override
	public void updateAnnualConfig(Map<String, Object> map) throws Exception {
		logger.debug("updateAnnualConfig started");
		
		if(ezAttitudeDAO.getAttitudeAnnualConfig(map) == null) {
			ezAttitudeDAO.insertAnnualConfig(map);
		} else {
			ezAttitudeDAO.updateAnnualConfig(map);
		}
		
		logger.debug("updateAnnualConfig ended");
		
	}
	
	@Override
	public Map<String, Object> getJoinDate(int tenantId, String companyId, String userId) throws Exception {
		logger.debug("getJoinDate started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		map.put("userId", userId);
		
		logger.debug("getJoinDate ended");
		
		return ezAttitudeDAO.getJoinDate(map);
	}
	
	@Override
	public List<Map<String, Object>> getAttitudeAprInfo(String attitudeId, String lang, int tenantId, String companyId) throws Exception {
		logger.debug("getAttitudeAprInfo started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("attitudeId", attitudeId);
		if (lang.equals("1")) {
			lang = "";
		}
		map.put("lang", lang);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		logger.debug("getAttitudeAprInfo ended");
		
		return ezAttitudeDAO.getAttitudeAprInfo(map);
	}
	
	/**
	 * 근태일, 휴무일  dateString List
	 */
	@Override
	public List<String> getDisabledDays(String primary, String offset, String year, String month, String paramStartDate, String paramEndDate, String userId, String companyId, int tenantId) throws Exception {		
		logger.debug("getDisabledDays started");
		
		List<String> resultList = new ArrayList<>();
		
		//사용자 근태 리스트(disabled되어야할....datetype이 4인것과 결근인 근태) 가져오기
		@SuppressWarnings("unused")
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
		Calendar cal = Calendar.getInstance();
		if (year != null && !year.equals("")) {
			cal.set(Integer.valueOf(year), Integer.valueOf(month) - 1, 1);
		}
		
		String startDate = "";
		String endDate = "";
		if (paramStartDate.equals("")) {
			startDate = year + "-" + month + "-01";
			endDate = year + "-" + month + "-" + cal.getActualMaximum(Calendar.DAY_OF_MONTH);
		} else {
			
			paramStartDate = paramStartDate.split("-")[1].split("").length == 1 ? "0" + paramStartDate.split("-")[1]: paramStartDate;
			paramStartDate = paramStartDate.split("-")[2].split("").length == 1 ? "0" + paramStartDate.split("-")[2]: paramStartDate;
			paramEndDate = paramEndDate.split("-")[1].split("").length == 1 ? "0" + paramEndDate.split("-")[1]: paramEndDate;
			paramEndDate = paramEndDate.split("-")[2].split("").length == 1 ? "0" + paramEndDate.split("-")[2]: paramEndDate;
			
			startDate = paramStartDate;
			endDate = paramEndDate;
		}

		resultList = checkHoliday2(startDate, endDate, companyId, tenantId);
		
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("tenantId", tenantId);
        map.put("companyId", companyId);
        map.put("offsetMin", commonUtil.getMinuteUTC(offset));
        map.put("startDate", startDate + " 00:00:00");
        map.put("endDate", endDate + " 23:59:59");
        map.put("writerId", userId);
        
        //startdate - enddate를 이용해서 해당 일자 안의 기념일, 근태등록날 date를 string타입으로 list에 담아 반환.
        List<AttitudeVO> attitudeList = ezAttitudeDAO.getDisabledAttitudeList(map);
        for (AttitudeVO vo : attitudeList) {
    		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    		
    		Date checkStartDate = sdf.parse(vo.getStartDate());
    		cal.setTime(checkStartDate);
    		
    		String tempDate = "";
    		while (true) {
    			tempDate = sdf.format(cal.getTime());//startdate에서 enddate까지 증가되는 변수
    			
    			if (!resultList.contains(tempDate)) {//리스트에 이미 존재하지 않으면
    				resultList.add(tempDate);							
    			}	
    			
    			if (vo.getEndDate() != null && !vo.getEndDate().equals("")) {
    				if (tempDate.equals(vo.getEndDate().substring(0, 10))) {
    					break;
    				}    				
    			} else {
    				break;
    			}
    			cal.add(Calendar.DAY_OF_MONTH, 1);
    		}
        }
        
        
        logger.debug("getDisabledDays ended");
		return resultList;
	}
	
	/**
	 * YYYY-MM-dd
	 * 
	 * @param checkStartDate 시작일
	 * @param checkEndDate 종료일
	 * @param userLang userInfo.lang
	 * @param companyId
	 * @param tenantId
	 * @return 국가,회사,근태 휴무일 날짜 dateString arrary
	 * @throws Exception
	 */
	public List<String> checkHoliday2(String checkStartDate, String checkEndDate,  String companyId, int tenantId) throws Exception {
		logger.debug("checkHoliday2 started.");
		logger.debug("startDate = " + checkStartDate + " || endDate = " + checkEndDate);
		
		//회사 기념일
		List<HolidayVO> holidayList = getHolidayList("rest", companyId, tenantId);
		//임시 저장
		List<HolidayVO> tempHolidayList = new ArrayList<HolidayVO>();
		//근태휴무일
		AttitudeConfigVO attitudeConfig = getAttitudeConfig(tenantId, companyId);
		String checkDay[] = attitudeConfig.getClosedDay().split(",");
		//음력을 위한
		KoreanLunarCalendar koreaCalendar = KoreanLunarCalendar.newInstance();
		
		
		//음력 -> 양력변환
		DecimalFormat df = new DecimalFormat("00");
		String startYear = checkStartDate.substring(0, 4);
		String endYear = checkEndDate.substring(0, 4);
		
		for (HolidayVO vo1 : holidayList) {
			if (vo1.getIsSolar() == 0) {//음력일 경우
				String lunarDate = vo1.getHolidayDate();
				
				koreaCalendar.setLunarDate(Integer.parseInt(lunarDate.substring(0, 4)), Integer.parseInt(lunarDate.substring(5, 7)), Integer.parseInt(lunarDate.substring(8, 10)), false);
				if(!startYear.equals(String.valueOf(koreaCalendar.getSolarYear()))) {
					koreaCalendar.setLunarDate(Integer.parseInt(startYear), Integer.parseInt(lunarDate.substring(5, 7)), Integer.parseInt(lunarDate.substring(8, 10)), false);
				}

				vo1.setHolidayDate(koreaCalendar.getSolarYear() + "-" + df.format(koreaCalendar.getSolarMonth()) + "-" + df.format(koreaCalendar.getSolarDay()));
			}
			
			if (vo1.getHolidayFlag() != null && vo1.getHolidayFlag().equals("Y")) {
				String voYear = vo1.getHolidayRepeat().split("\\|")[0];
				
				if (vo1.getIsRepeat() == 1) {//반복일 경우
					if (startYear.equals(endYear)) {
						if (!startYear.equals(voYear)) {
							vo1.setHolidayRepeat(vo1.getHolidayRepeat().replace(voYear, startYear));
						}
					} else {
						if (!startYear.equals(voYear)) {
							vo1.setHolidayRepeat(vo1.getHolidayRepeat().replace(voYear, startYear));
						}
						
						if (!endYear.equals(voYear)) {
							HolidayVO vo2 = new HolidayVO();
							vo2.setHolidayRepeat(vo1.getHolidayRepeat().replace(startYear, endYear));
							
							SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
							
							Calendar cal = Calendar.getInstance();

							cal.set(Calendar.YEAR, Integer.parseInt(vo1.getHolidayRepeat().split("\\|")[0]));				
							
							cal.set(Calendar.MONTH, (Integer.parseInt(vo1.getHolidayRepeat().split("\\|")[1]) - 1));
							
							if (vo1.getHolidayRepeat().split("\\|")[2].equals("5")) {
								Calendar cal2 = Calendar.getInstance();
								cal2.set(Integer.parseInt(vo1.getHolidayRepeat().split("\\|")[0]), Integer.parseInt(vo1.getHolidayRepeat().split("\\|")[1]) - 1, cal.getActualMaximum(Calendar.DATE));
								cal.set(Calendar.WEEK_OF_MONTH, cal2.get(Calendar.WEEK_OF_MONTH));
							} else {
								cal.set(Calendar.WEEK_OF_MONTH, Integer.parseInt(vo1.getHolidayRepeat().split("\\|")[2]));
							}
							
							//요일					
							int temp = Integer.parseInt(vo1.getHolidayRepeat().split("\\|")[3]) - cal.get(Calendar.DAY_OF_WEEK) + 1;
							cal.set(Calendar.DAY_OF_WEEK, cal.get(Calendar.DAY_OF_WEEK) + temp);

							//첫째 주의 첫 요일이 해당요일보다크면 + 7을 해준다.
							Calendar cal3 = Calendar.getInstance();
							cal3.set(Integer.parseInt(vo1.getHolidayRepeat().split("\\|")[0]), Integer.parseInt(vo1.getHolidayRepeat().split("\\|")[1]) - 1, 1);
							
							int MonthfirstDay = cal3.get(Calendar.DAY_OF_WEEK);
							
							if (!vo1.getHolidayRepeat().split("\\|")[2].equals("5") && MonthfirstDay > Integer.parseInt(vo1.getHolidayRepeat().split("\\|")[3])) {
								cal.add(Calendar.DATE, 7);
							}
							
							vo2.setHolidayDate(formatter.format(cal.getTime()));
							
							tempHolidayList.add(vo2);
						}
					}
				}
				
				SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
				
				Calendar cal = Calendar.getInstance();

				cal.set(Calendar.YEAR, Integer.parseInt(vo1.getHolidayRepeat().split("\\|")[0]));				
				
				cal.set(Calendar.MONTH, (Integer.parseInt(vo1.getHolidayRepeat().split("\\|")[1]) - 1));
				
				if (vo1.getHolidayRepeat().split("\\|")[2].equals("5")) {
					Calendar cal2 = Calendar.getInstance();
					cal2.set(Integer.parseInt(vo1.getHolidayRepeat().split("\\|")[0]), Integer.parseInt(vo1.getHolidayRepeat().split("\\|")[1]) - 1, cal.getActualMaximum(Calendar.DATE));
					cal.set(Calendar.WEEK_OF_MONTH, cal2.get(Calendar.WEEK_OF_MONTH));
				} else {
					cal.set(Calendar.WEEK_OF_MONTH, Integer.parseInt(vo1.getHolidayRepeat().split("\\|")[2]));
				}
				
				//요일					
				int temp = Integer.parseInt(vo1.getHolidayRepeat().split("\\|")[3]) - cal.get(Calendar.DAY_OF_WEEK) + 1;
				cal.set(Calendar.DAY_OF_WEEK, cal.get(Calendar.DAY_OF_WEEK) + temp);

				//첫째 주의 첫 요일이 해당요일보다크면 + 7을 해준다.
				Calendar cal3 = Calendar.getInstance();
				cal3.set(Integer.parseInt(vo1.getHolidayRepeat().split("\\|")[0]), Integer.parseInt(vo1.getHolidayRepeat().split("\\|")[1]) - 1, 1);
				
				int MonthfirstDay = cal3.get(Calendar.DAY_OF_WEEK);
				
				if (!vo1.getHolidayRepeat().split("\\|")[2].equals("5") && MonthfirstDay > Integer.parseInt(vo1.getHolidayRepeat().split("\\|")[3])) {
					cal.add(Calendar.DATE, 7);
				}
				
				vo1.setHolidayDate(formatter.format(cal.getTime()));
				
			} else {
				String voYear = vo1.getHolidayDate().substring(0, 4);
				
				if (vo1.getIsRepeat() == 1) {//반복일 경우
					if (startYear.equals(endYear)) {
						if (!startYear.equals(voYear)) {
							vo1.setHolidayDate(vo1.getHolidayDate().replace(voYear, startYear));
						}
					} else {
						if (!startYear.equals(voYear)) {
							vo1.setHolidayDate(vo1.getHolidayDate().replace(voYear, startYear));
						}
						
						HolidayVO vo2 = new HolidayVO();
						vo2.setHolidayDate(vo1.getHolidayDate().replace(startYear, endYear));
							
						tempHolidayList.add(vo2);
					}
				}
			}
			
		}
		
		if (tempHolidayList != null) {
			for (HolidayVO vo3 : tempHolidayList) {
				holidayList.add(vo3);
			}
		}
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Calendar cal = Calendar.getInstance();
		
		Date startDate = sdf.parse(checkStartDate);
		cal.setTime(startDate);
		
		String tempDate = "";
		@SuppressWarnings("unused")
		boolean isContained = true;
		
		List<String> result = new ArrayList<String>();
		
		while (true) {
			isContained = true;
			tempDate = sdf.format(cal.getTime());
			
			if (!result.contains(tempDate)) {
				switch (cal.get(Calendar.DAY_OF_WEEK)) {
				case 1:
					if (checkDay[0].equals("1")) {
						result.add(tempDate);
						break;
					} else {
						if (holidayList.size() > 0) {
							for (HolidayVO vo1 : holidayList) {
								if (vo1.getHolidayDate().substring(0, 10).equals(tempDate)) {
									result.add(tempDate);
									break;
								}
							}
						}
						break;
					}
				case 2:
					if (checkDay[1].equals("1")) {
						result.add(tempDate);
						break;
					} else {
						if (holidayList.size() > 0) {
							for (HolidayVO vo1 : holidayList) {
								if (vo1.getHolidayDate().substring(0, 10).equals(tempDate)) {
									result.add(tempDate);
									break;
								}
							}
						}
						break;
					}
				case 3:
					if (checkDay[2].equals("1")) {
						result.add(tempDate);
						break;
					} else {
						if (holidayList.size() > 0) {
							for (HolidayVO vo1 : holidayList) {
								if (vo1.getHolidayDate().substring(0, 10).equals(tempDate)) {
									result.add(tempDate);
									break;
								}
							}
						}
						break;
					}
				case 4:
					if (checkDay[3].equals("1")) {
						result.add(tempDate);
						break;
					} else {
						if (holidayList.size() > 0) {
							for (HolidayVO vo1 : holidayList) {
								if (vo1.getHolidayDate().substring(0, 10).equals(tempDate)) {
									result.add(tempDate);
									break;
								}
							}
						}
						break;
					}
				case 5:
					if (checkDay[4].equals("1")) {
						result.add(tempDate);
						break;
					} else {
						if (holidayList.size() > 0) {
							for (HolidayVO vo1 : holidayList) {
								if (vo1.getHolidayDate().substring(0, 10).equals(tempDate)) {
									result.add(tempDate);
									break;
								}
							}
						}
						break;
					}
				case 6:
					if (checkDay[5].equals("1")) {
						result.add(tempDate);
						break;
					} else {
						if (holidayList.size() > 0) {
							for (HolidayVO vo1 : holidayList) {
								if (vo1.getHolidayDate().substring(0, 10).equals(tempDate)) {
									result.add(tempDate);
									break;
								}
							}
						}
						break;
					}
				case 7:
					if (checkDay[6].equals("1")) {
						result.add(tempDate);
						break;
					} else {
						if (holidayList.size() > 0) {
							for (HolidayVO vo1 : holidayList) {
								if (vo1.getHolidayDate().substring(0, 10).equals(tempDate)) {
									result.add(tempDate);
									break;
								}
							}
						}
						break;
					}
				}
			}
			
			if (tempDate.equals(checkEndDate)) {
				break;
			}
			cal.add(Calendar.DAY_OF_MONTH, 1);
		};
		
		logger.debug("checkHoliday2 ended.");
		
		return result;
	}
	
	/**
	 * 근태일, 휴무일  dateString List
	 */
	@Override
	public List<String> getHoliDays(String primary, String offset, String year, String month, String paramStartDate, String paramEndDate, String userId, String companyId, int tenantId) throws Exception {		
		logger.debug("getHoliDays started");
		
		String startDate = "";
		String endDate = "";
		
		@SuppressWarnings("unused")
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
		Calendar cal = Calendar.getInstance();
		if (year != null && !year.equals("")) {
			cal.set(Integer.valueOf(year), Integer.valueOf(month) - 1, 1);
		}
		
		if (paramStartDate.equals("")) {
			startDate = year + "-" + month + "-01";
			endDate = year + "-" + month + "-" + cal.getActualMaximum(Calendar.DAY_OF_MONTH);
		} else {
			
			paramStartDate = paramStartDate.split("-")[1].split("").length == 1 ? "0" + paramStartDate.split("-")[1]: paramStartDate;
			paramStartDate = paramStartDate.split("-")[2].split("").length == 1 ? "0" + paramStartDate.split("-")[2]: paramStartDate;
			paramEndDate = paramEndDate.split("-")[1].split("").length == 1 ? "0" + paramEndDate.split("-")[1]: paramEndDate;
			paramEndDate = paramEndDate.split("-")[2].split("").length == 1 ? "0" + paramEndDate.split("-")[2]: paramEndDate;
			
			startDate = paramStartDate;
			endDate = paramEndDate;
		}
			
		List<String> resultList = checkHoliday2(startDate, endDate, companyId, tenantId);
        
        logger.debug("getHoliDays ended");
		return resultList;
	}

	/**
	 * 사용자 근태현황에 일근무, 반근무 자동 세팅
	 * @throws Exception 
	 */
	@Override
	public void autoSetDailyWork() throws Exception {
		logger.debug("autoSetDailyWork started");
		/* 사용자들의 출근(지각)/퇴근(조퇴)을 가져와서 AttitudeVO2에 넣어주기 */
		List<AttitudeVO> attitudeList = new ArrayList<AttitudeVO>();
		attitudeList = ezAttitudeDAO.getAttitudeList3();
		
		logger.info("######attitudeList=" + attitudeList.toString());
		
		List<AttitudeVO2> attitudeList2 = new ArrayList<AttitudeVO2>();
		AttitudeVO2 avo = null;
		boolean flag = true;
		for (int i = 0; i < attitudeList.size() ; i++) {
			if(flag == true){
				avo = new AttitudeVO2();
				flag = false;
			}
			
			if(i + 1 < attitudeList.size()){
				//다음 행과 비교하여 날짜가 같고 사용자의 이름이 같을 경우
				if(attitudeList.get(i).getStartDate().split(" ")[0].equals(attitudeList.get(i + 1).getStartDate().split(" ")[0]) && attitudeList.get(i).getWriterId().equals(attitudeList.get(i + 1).getWriterId())){
					avo.setWriterId(attitudeList.get(i).getWriterId());
					avo.setCompanyId(attitudeList.get(i).getCompanyId());
					avo.setTenantId(attitudeList.get(i).getTenantId());
					
					if(attitudeList.get(i).getTypeId().equals("A01")) { //출근
						avo.setInAttitudeId(attitudeList.get(i).getAttitudeId());
						avo.setStartDate(attitudeList.get(i).getStartDate().split("\\.")[0]);
						avo.setInModAppl(attitudeList.get(i).getModAppl());
					}else if(attitudeList.get(i).getTypeId().equals("A02")) { //지각
						avo.setInAttitudeId(attitudeList.get(i).getAttitudeId());
						avo.setStartDate(attitudeList.get(i).getStartDate().split("\\.")[0]);
						avo.setInModAppl(attitudeList.get(i).getModAppl());
					}else if(attitudeList.get(i).getTypeId().equals("A03")) { //퇴근
						avo.setOutAttitudeId(attitudeList.get(i).getAttitudeId());
						avo.setEndDate(attitudeList.get(i).getStartDate().split("\\.")[0]);
						avo.setOutModAppl(attitudeList.get(i).getModAppl());
						avo.setWorkStatus(attitudeList.get(i).getWorkStatus());
					}else if(attitudeList.get(i).getTypeId().equals("A25")) { //전일퇴근
						avo.setOutAttitudeId(attitudeList.get(i).getAttitudeId());
						String[] startDate = attitudeList.get(i).getStartDate().split(" ");
						String dayAfter = commonUtil.getDayAfter(startDate[0]);
						avo.setEndDate(dayAfter + " " + startDate[1].split("\\.")[0]);
						avo.setOutModAppl(attitudeList.get(i).getModAppl());
						avo.setWorkStatus(attitudeList.get(i).getWorkStatus());
					}else if(attitudeList.get(i).getTypeId().equals("A08")) { //조퇴
						avo.setOutAttitudeId(attitudeList.get(i).getAttitudeId());
						avo.setEndDate(attitudeList.get(i).getStartDate().split("\\.")[0]);
						avo.setOutModAppl(attitudeList.get(i).getModAppl());
						avo.setWorkStatus(attitudeList.get(i).getWorkStatus());
					}
				} else {						
					//날짜와 사용자의 이름이 다를 경우
					avo.setWriterId(attitudeList.get(i).getWriterId());
					avo.setCompanyId(attitudeList.get(i).getCompanyId());
					avo.setTenantId(attitudeList.get(i).getTenantId());
					
					if(attitudeList.get(i).getTypeId().equals("A01")) { //출근
						avo.setInAttitudeId(attitudeList.get(i).getAttitudeId());
						avo.setStartDate(attitudeList.get(i).getStartDate().split("\\.")[0]);
						avo.setInModAppl(attitudeList.get(i).getModAppl());
					}else if(attitudeList.get(i).getTypeId().equals("A02")) { //지각
						avo.setInAttitudeId(attitudeList.get(i).getAttitudeId());
						avo.setStartDate(attitudeList.get(i).getStartDate().split("\\.")[0]);
						avo.setInModAppl(attitudeList.get(i).getModAppl());
					}else if(attitudeList.get(i).getTypeId().equals("A03")) { //퇴근
						avo.setOutAttitudeId(attitudeList.get(i).getAttitudeId());
						avo.setEndDate(attitudeList.get(i).getStartDate().split("\\.")[0]);
						avo.setOutModAppl(attitudeList.get(i).getModAppl());
						avo.setWorkStatus(attitudeList.get(i).getWorkStatus());
					}else if(attitudeList.get(i).getTypeId().equals("A25")) { //전일퇴근
						avo.setOutAttitudeId(attitudeList.get(i).getAttitudeId());
						String[] startDate = attitudeList.get(i).getStartDate().split(" ");
						String dayAfter = commonUtil.getDayAfter(startDate[0]);
						avo.setEndDate(dayAfter + " " + startDate[1].split("\\.")[0]);
						avo.setOutModAppl(attitudeList.get(i).getModAppl());
						avo.setWorkStatus(attitudeList.get(i).getWorkStatus());
					}else if(attitudeList.get(i).getTypeId().equals("A08")) { //조퇴
						avo.setOutAttitudeId(attitudeList.get(i).getAttitudeId());
						avo.setEndDate(attitudeList.get(i).getStartDate().split("\\.")[0]);
						avo.setOutModAppl(attitudeList.get(i).getModAppl());
						avo.setWorkStatus(attitudeList.get(i).getWorkStatus());
					}
					
					attitudeList2.add(avo);
					flag = true;					
				}
			} else { //마지막 것은 비교하지 않는다.
				avo.setWriterId(attitudeList.get(i).getWriterId());
				avo.setCompanyId(attitudeList.get(i).getCompanyId());
				avo.setTenantId(attitudeList.get(i).getTenantId());
				
				if(attitudeList.get(i).getTypeId().equals("A01")) { //출근
					avo.setInAttitudeId(attitudeList.get(i).getAttitudeId());
					avo.setStartDate(attitudeList.get(i).getStartDate().split("\\.")[0]);
					avo.setInModAppl(attitudeList.get(i).getModAppl());
				}else if(attitudeList.get(i).getTypeId().equals("A02")) { //지각
					avo.setInAttitudeId(attitudeList.get(i).getAttitudeId());
					avo.setStartDate(attitudeList.get(i).getStartDate().split("\\.")[0]);
					avo.setInModAppl(attitudeList.get(i).getModAppl());
				}else if(attitudeList.get(i).getTypeId().equals("A03")) { //퇴근
					avo.setOutAttitudeId(attitudeList.get(i).getAttitudeId());
					avo.setEndDate(attitudeList.get(i).getStartDate().split("\\.")[0]);
					avo.setOutModAppl(attitudeList.get(i).getModAppl());
					avo.setWorkStatus(attitudeList.get(i).getWorkStatus());
				}else if(attitudeList.get(i).getTypeId().equals("A25")) { //전일퇴근
					avo.setOutAttitudeId(attitudeList.get(i).getAttitudeId());
					String[] startDate = attitudeList.get(i).getStartDate().split(" ");
					String dayAfter = commonUtil.getDayAfter(startDate[0]);
					avo.setEndDate(dayAfter + " " + startDate[1].split("\\.")[0]);
					avo.setOutModAppl(attitudeList.get(i).getModAppl());
					avo.setWorkStatus(attitudeList.get(i).getWorkStatus());
				}else if(attitudeList.get(i).getTypeId().equals("A08")) { //조퇴
					avo.setOutAttitudeId(attitudeList.get(i).getAttitudeId());
					avo.setEndDate(attitudeList.get(i).getStartDate().split("\\.")[0]);
					avo.setOutModAppl(attitudeList.get(i).getModAppl());
					avo.setWorkStatus(attitudeList.get(i).getWorkStatus());
				}
				
				attitudeList2.add(avo);
			}
		}
		logger.info("######attitudeList2=" + attitudeList2.toString());
		/* end */
		
		/* AttitudeVO2에 들어있는 출근(지각)/퇴근(조퇴) 시간을 비교하여 workstatus 변경해주기 */
		for (int i = 0; i < attitudeList2.size() ; i++) {
			if(attitudeList2.get(i).getStartDate() != null && attitudeList2.get(i).getEndDate() != null){				
				
				if(attitudeList2.get(i).getWorkStatus() == null || attitudeList2.get(i).getInModAppl().equals("3") || attitudeList2.get(i).getOutModAppl().equals("3")) { //workstatus가 null이거나 inModAppl이 3이거나 outModAppl이 3인 데이터의 workstatus 변경			
					long minutes = commonUtil.getTimeDifference(attitudeList2.get(i).getStartDate(), attitudeList2.get(i).getEndDate());
					
					String workStatus = null;
					if(minutes >= 480) {
						workStatus = "D";
					} else if (minutes >= 240) {
						workStatus = "H";						
					}

					Map<String, Object> map = new HashMap<String, Object>();				
					map.put("workStatus", workStatus);
					map.put("attitudeId", attitudeList2.get(i).getOutAttitudeId());
					map.put("companyId", attitudeList2.get(i).getCompanyId());
					map.put("tenantId", attitudeList2.get(i).getTenantId());
					ezAttitudeDAO.updateWorkStatus(map);
				}
				
			}
		}
		/* end */
		logger.debug("autoSetDailyWork ended");
	}
}