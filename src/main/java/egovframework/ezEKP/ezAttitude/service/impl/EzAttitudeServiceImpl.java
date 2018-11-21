package egovframework.ezEKP.ezAttitude.service.impl;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.mail.internet.InternetAddress;

import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.w3c.dom.Document;

import com.ibm.icu.text.DecimalFormat;
import com.ibm.icu.text.SimpleDateFormat;
import com.ibm.icu.util.Calendar;

import egovframework.ezEKP.ezAttitude.dao.EzAttitudeDAO;
import egovframework.ezEKP.ezAttitude.service.EzAttitudeService;
import egovframework.ezEKP.ezAttitude.vo.AdminAttitudeVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeApplicationVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeAuthorVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeConfigVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeDeptVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeFormVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeStatisVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeTypeVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeUserConfigVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeVO;
import egovframework.ezEKP.ezAttitude.vo.DeptViewVO;
import egovframework.ezEKP.ezAttitude.vo.HolidayVO;
import egovframework.ezEKP.ezAttitude.vo.ModApplHistoryVO;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezOrgan.dao.EzOrganDAO;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.KoreanLunarCalendar;

@Service("EzAttitudeService")
public class EzAttitudeServiceImpl implements EzAttitudeService{
	private static final Logger LOGGER = LoggerFactory.getLogger(EzAttitudeServiceImpl.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private EzEmailService ezEmailService;
	
	@Autowired
	private EzAttitudeDAO ezAttitudeDAO;
	
	@Resource(name = "EzOrganDAO")
	private EzOrganDAO ezOrganDAO;
	
	@Override
	public AttitudeVO getAttitudeInfo(String attitudeId, String offset, String lang, int tenantId) throws Exception {
		LOGGER.debug("getAttitudeInfo started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("attitudeId", attitudeId);
		map.put("offsetMin", commonUtil.getMinuteUTC(offset));
		if (lang.equals("1")) {
			lang = "";
		}
		map.put("lang", lang);
		map.put("tenantId", tenantId);
		
		AttitudeVO attitudeVO = ezAttitudeDAO.getAttitudeInfo(map);
		
		LOGGER.debug("getAttitudeInfo ended");
		
		return attitudeVO;
	}

	@Override
	public void insertAttitude(String writerId, String deptId, String startDate,
			String endDate, String region, String mobile, String bizsub, String content,
			String ip, String typeId, String dateType, String offset, String companyId, int tenantId, String mode, String adminId) throws Exception {
		LOGGER.debug("insertAttitude started");
		
		if (mode == null) {
			mode = "";
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("writerId", writerId);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		if (typeId.equals("A01") || typeId.equals("A03")) {
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
		
		LOGGER.debug("insertAttitude ended");
	}

	@Override
	public List<AttitudeVO> getAttitudeList(String pidList, String deptIdList, String yrmh,
		String typeId, String startDate, String endDate, String offset, String deptFlag, String lang, int tenantId) throws Exception {
		LOGGER.debug("getAttitudeList started");
		
		Map<String, Object> map = new HashMap<String,Object>();
		
		//startDate와 endDate가 없는 경우 당일의 근태를  출력
		if (startDate.equals("") && endDate.equals("")) {
			String localDate = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), offset, false).split(" ")[0];
			startDate = localDate + " 00:00:00";
			endDate = localDate + " 23:59:59";
		} else if (!startDate.equals("") && endDate.equals("")) {
			endDate = startDate + " 23:59:59"; 
			startDate = startDate + " 00:00:00";
		} else {
			startDate = startDate + " 00:00:00";
			endDate = endDate + " 23:59:59";
		}
		
		map.put("startDate", startDate);
		map.put("endDate", endDate);
		map.put("tenantId", tenantId);
		if (lang.equals("1")) {
			lang = "";
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
		
		LOGGER.debug("getAttitudeList ended");
		
		return resultList;
	}

	@Override
	public List<AttitudeStatisVO> getAttitudeStatisticsList(String pidList, String deptIdList, String offset,
			String startDate, String endDate, int tenantId, String deptFlag) throws Exception {
		LOGGER.debug("getAttitudeStatisticsList started");
		
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
		
		LOGGER.debug("getAttitudeStatisticsList ended");
		return ezAttitudeDAO.getAttitudeStatisList(map);
	}

	@Override
	public List<AttitudeTypeVO> getAttitudeTypeList(String companyId, String isuse, String isAdmin, String statistics, int tenantId, String primary) throws Exception {
		LOGGER.debug("getAttitudeTypeList started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		map.put("isuse", isuse);
		map.put("isAdmin", isAdmin);
		map.put("statistics", statistics);
		if (primary.equals("1")) {
			primary = "";
		}
		map.put("primary", primary);
		
		LOGGER.debug("getAttitudeTypeList ended");
		
		return ezAttitudeDAO.getAttitudeTypeList(map);
	}

	@Override
	public AttitudeFormVO getFormBody(String typeId, String companyId, int tenantId)
			throws Exception {
		LOGGER.debug("getFormBody started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("typeId", typeId);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		LOGGER.debug("getFormBody ended");
		
		return ezAttitudeDAO.getFormBody(map);
	}

	@Override
	public void updateAttitude(String attitudeId, String startDate, String endDate, String region,
			String mobile, String bizSub, String content, String offset, String ip, String typeId, String dateType, String mode, AttitudeVO attVO, String adminId, MCommonVO info, MCommonVO userInfo, int tenantId, String companyId) throws Exception{
		LOGGER.debug("updateAttitude started");
		
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
		
		if (mode.equals("admin")) {
			map.put("modappl", "3");
		}
		
		ezAttitudeDAO.updateAttitude(map);
		
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
		
		LOGGER.debug("updateAttitude ended");
	}

	@Override
	public void deleteAttitude(String attitudeId, int tenantId, String mode, AttitudeVO attitudeVO, String offset, MCommonVO info, MCommonVO userInfo)
			throws Exception {
		LOGGER.debug("deleteAttitude started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("attitudeId", attitudeId);
		map.put("tenantId", tenantId);
		
		if (mode.equals("admin")) {
			LOGGER.debug("admin history write");
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
		
		LOGGER.debug("deleteAttitude ended");
	}

	@Override
	public void editAttitudeUserConfig(String selectedUserIdList, String workStartTime, String workEndTime, String gubun, String offSet, String companyId, int tenantId) throws Exception {
		LOGGER.debug("editAttitudeUserConfig started");
		LOGGER.debug("selectedUserIdList = " + selectedUserIdList + " || workStartTime = " + workStartTime + " || workEndTime = " + workEndTime + " || gubun = " + gubun);
		
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
		
		LOGGER.debug("saveAttitudeUserConfig ended");
	}
	@Override
	public void editAttitudeDeptConfig(String selectDeptIds, String workStartTime, String workEndTime, String gubun, String offSet, String companyId, int tenantId) throws Exception {
		LOGGER.debug("editAttitudeUserConfig started");
		LOGGER.debug("selectDeptId = " + selectDeptIds + " || workStartTime = " + workStartTime + " || workEndTime = " + workEndTime + " || gubun = " + gubun);
		
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
		
		LOGGER.debug("saveAttitudeUserConfig ended");
	}

	@Override
	public AttitudeConfigVO getAttitudeConfig(int tenantId, String companyId)
			throws Exception {
		LOGGER.debug("getAttitudeConfig started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		
		LOGGER.debug("getAttitudeConfig ended");
		
		return ezAttitudeDAO.getAttitudeConfig(map);
	}

	@Override
	public void updateAttitudeConfig(String workStartTime, String workEndTime, String closedDay, String attitudeModAppl, String closedDateAttitude, String confSetDate, String companyId, int tenantId) throws Exception {
		LOGGER.debug("updateAttitudeConfig started");
		
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
		
		LOGGER.debug("updateAttitudeConfig ended");
	}

	@Override
	public void updateAttitudeTypeConfig(String typeConfigList, String companyId, int tenantId) throws Exception {
		LOGGER.debug("updateAttitudeTypeConfig started");
		LOGGER.debug("typeConfigList = " + typeConfigList);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		
		for (String typeInfoList : typeConfigList.split(";")) {
			String[] typeInfo = typeInfoList.split(",");
			
			map.put("typeId", typeInfo[0]);
			map.put("isuse", typeInfo[1]);
			
			ezAttitudeDAO.updateAttitudeTypeConfig(map);
		}
		
		LOGGER.debug("updateAttitudeTypeConfig ended");
	}

	@Override
	public boolean insertAttitudeType(String typeName, String typeName2, int tenantId, String companyId, String primary) throws Exception {
		LOGGER.debug("insertAttitudeType started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("typeName", typeName);
		map.put("typeName2", typeName2);
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		
		List<AttitudeTypeVO> list = getAttitudeTypeList(companyId, "", "1", "", tenantId, primary);
		
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
		
		LOGGER.debug("insertAttitudeType ended");
		
		return result;
	}

	@Override
	public AttitudeTypeVO getAttitudeTypeInfo(int tenantId, String companyId, String typeId) throws Exception {
		LOGGER.debug("getAttitudeTypeInfo started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("typeId", typeId);
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		
		AttitudeTypeVO result = ezAttitudeDAO.getAttitudeTypeInfo(map);
		
		LOGGER.debug("getAttitudeTypeInfo ended");
		
		return result;
	}

	@Override
	public void updateAttitudeType(String typeId, String typeName, String typeName2,
			int tenantId, String companyId) throws Exception {
		LOGGER.debug("updateAttitudeType started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("typeId", typeId);
		map.put("typeName", typeName);
		map.put("typeName2", typeName2);
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		
		ezAttitudeDAO.updateAttitudeType(map);
		
		LOGGER.debug("updateAttitudeType ended");
	}

	@Override
	public List<AttitudeUserConfigVO> getAttitudeUserConfigList(int tenantId, String companyId,
			String searchUserName, String searchDeptName, String searchTitle, String searchStartTime,
			String searchEndTime, String searchGubun, String pageNum, String listSize,
			String orderCell, String orderOption, String offsetMin, String primary) throws Exception {
		LOGGER.debug("getAttitudeUserConfigList started");
		
		int limit = (Integer.valueOf(pageNum) - 1) * Integer.valueOf(listSize);
		
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
		map.put("listSize", listSize);
		map.put("orderCell", orderCell);
		map.put("orderOption", orderOption);
		map.put("offsetMin", offsetMin);
		map.put("startRow", limit + 1);
		map.put("endRow", limit + Integer.valueOf(listSize));
		if (primary.equals("1")) {
			primary = "";
		}
		map.put("primary", primary);
		
		List<AttitudeUserConfigVO> resultList = ezAttitudeDAO.getAttitudeUserConfigList(map);
		
		LOGGER.debug("getAttitudeUserConfigList ended. resultList size = " + resultList.size());
		
		return resultList;
	}

	@Override
	public AttitudeUserConfigVO getAttitudeUserConfigInfo(String selectedUserIdList, String offsetMin, String companyId, int tenantId) throws Exception {
		LOGGER.debug("getAttitudeUserConfigInfo started");
		
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
		
		LOGGER.debug("getAttitudeUserConfigInfo ended");
		
		return vo;
	}

	@Override
	public List<AttitudeDeptVO> getCompanyList(String lang, int tenantId, String userId) throws Exception{
		LOGGER.debug("getCompanyList started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		if (lang.equals("1")) {
			lang = "";
		}
		
		map.put("lang", lang);
		map.put("tenantId", tenantId);
		map.put("userId", userId);
		
		List<AttitudeDeptVO> companyList = ezAttitudeDAO.getCompanyList(map);
		
		LOGGER.debug("getCompanyList ended");
		
		return companyList;
	}

	@Override
	public String getAttitudeUserConfigCount(int tenantId, String companyId, String searchUserName, String searchDeptName,
			String searchTitle, String searchStartTime, String searchEndTime, String searchGubun, String offsetMin) throws Exception {
		LOGGER.debug("getAttitudeUserConfigListCount started");
		
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
		
		LOGGER.debug("getAttitudeUserConfigListCount ended. totalCount = " + totalCount);
		
		return totalCount;
	}

	@Override
	public List<AttitudeApplicationVO> getUsersModiyAtt(String companyId, int tenantId,
			String userId, String startDate, String endDate, String apprUserName, String writerName, String writerDeptName, String lang, 
			String offset,String startPoint, String endPoint, String type, String order, String adminFlag, String checkAdmin, String deptId, List<String> deptIdList) throws Exception {
		LOGGER.debug("getUsersModiyAtt started");
		
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
		map.put("startPoint", startPoint);
		map.put("endPoint", endPoint);
		map.put("type", type);
		if (startPoint != null && endPoint != null && !startPoint.equals("") && !endPoint.equals("")) {
			map.put("startRow", Integer.valueOf(startPoint) + 1);
			map.put("endRow", Integer.valueOf(startPoint) + endPoint);
		}
		
		if (adminFlag.equals("false")){
			map.put("userId", userId);
		}
		if (order !=null) {
			map.put("order", order.trim());
		}
		
		List<AttitudeApplicationVO> attAppList = ezAttitudeDAO.getUsersModiyAtt(map); 
		
		LOGGER.debug("getUsersModiyAtt ended");
		
		return attAppList;
	}
	
	@Override
	public String getAttitudeTypeMaxTypeId(String companyId, int tenantId)
			throws Exception {
		LOGGER.debug("getAttitudeTypeMaxTypeId started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);

		LOGGER.debug("getAttitudeTypeMaxTypeId ended");

		return ezAttitudeDAO.getAttitudeTypeMaxTypeId(map);
	}
	
	@Override
	public List<AttitudeFormVO> getAttitudeFormList(int tenantId) throws Exception {
		LOGGER.debug("getAttitudeFormList started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("tenantId", tenantId);

		LOGGER.debug("getAttitudeFormList ended");

		return ezAttitudeDAO.getAttitudeFormList(map);
	}

	@Override
	public int getUsersModiyAttCount(String companyId, int tenantId, String userId, String startDate, String endDate,
			String apprUserName, String writerName , String writerDeptName, String lang, String offset, String type, String deptId, List<String> deptIdList,String adminFlag, String checkAdmin) throws Exception {
		LOGGER.debug("getUsersModiyAttCount started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		LOGGER.debug("checkAdmin : " + checkAdmin);
		LOGGER.debug("adminFlag : " + adminFlag);
		
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
		
		LOGGER.debug("getUsersModiyAttCount ended");
		
		return attAppListCount;
	}

	@Override
	public List<HolidayVO> getHolidayList(String isRest, String companyId, int tenantId) throws Exception {
		LOGGER.debug("getHolidayList started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("isRest", isRest);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		List<HolidayVO> holidayList = ezAttitudeDAO.getHolidayList(map);
		
		LOGGER.debug("getHolidayList ended");
		
		return holidayList;
	}
	
	@Override
	public int delUsersModifyAtt(String companyId, int tenantId, String[] ids) throws Exception {
		LOGGER.debug("delUsersModifyAtt started");
		
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

		LOGGER.debug("delUsersModifyAtt ended");
		
		return data;
	}

	@Override
	public List<DeptViewVO> getDeptViewList(String userId, String companyId,
			int tenantId, String primary) throws Exception {
		LOGGER.debug("getDeptViewList started");
		
	    Map<String, Object> map = new HashMap<String, Object>();
	    
	    map.put("tenantId", tenantId);
	    map.put("userId", userId);
	    map.put("companyId", companyId);
		if (primary.equals("1")) {
			primary = "";
		}
	    map.put("primary", primary);
	    
	    List<DeptViewVO> deptList = ezAttitudeDAO.getDeptViewList(map);
	    
	    LOGGER.debug("getDeptViewList ended");
	    return deptList;
	}

	@Override
	public AttitudeApplicationVO attModAppDetail(String attModId, String offset, String applCnt, String lang, String companyId, int tenantId) throws Exception {
		LOGGER.debug("attModAppDetail started");
		
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
		
		LOGGER.debug("attModAppDetail ended");
		
		return ezAttitudeDAO.attModAppDetail(map);
	}

	@Override
	public int attModAppModify(String companyId,
			int tenantId, String userId, String attModId, String offset,
			String content, String changeDate) throws Exception {
		LOGGER.debug("attModAppModify started");
		
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
		
		LOGGER.debug("attModAppModify ended");
		
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
		LOGGER.debug("attSaveAppModify started");
		
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
		
		LOGGER.debug("attSaveAppModify ended");
		
		return "success";
	}

	@Override
	public List<AdminAttitudeVO> getAttitudeList2(String searchUserName, String searchDeptName, String searchTitle, String searchStartDate, String searchEndDate, String searchAttitudeType, String orderCell, String orderOption, String offset, String pageNum, String listSize, String companyId, int tenantId, String searchDeptId, List<String> deptIdList, String primary) throws Exception {
		LOGGER.debug("getAttitudeList2 started");
		
		String offsetMin = commonUtil.getMinuteUTC(offset);
		int limit = 0;
		
		if (pageNum != null && !pageNum.equals("")) {
			limit = (Integer.valueOf(pageNum) - 1) * Integer.valueOf(listSize);
		}
		
		searchStartDate = commonUtil.getDateStringInUTC(searchStartDate + " 00:00:00", offset, true);
		searchEndDate = commonUtil.getDateStringInUTC(searchEndDate + " 23:59:59", offset, true);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("searchUserName", searchUserName);
		map.put("searchDeptName", searchDeptName);
		map.put("searchDeptId", searchDeptId);
		map.put("searchTitle", searchTitle);
		map.put("searchAttitudeType", searchAttitudeType);
		map.put("searchStartDate", searchStartDate);
		map.put("searchEndDate", searchEndDate);
		map.put("orderCell", orderCell);
		map.put("orderOption", orderOption);
		map.put("listSize", listSize);
		map.put("offsetMin", offsetMin);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("limit", limit);
		map.put("deptIdList", deptIdList);
		map.put("startRow", limit + 1);
		map.put("endRow", limit + Integer.valueOf(listSize));
		if (primary.equals("1")) {
			primary = "";
		}
		map.put("primary", primary);

		List<AdminAttitudeVO> resultList = ezAttitudeDAO.getAttitudeList2(map);

		LOGGER.debug("getAttitudeList2 ended. resultList size = " + resultList.size());
		
		return resultList;
	}

	@Override
	public String getAttitudeCount2(String searchUserName, String searchDeptName, String searchTitle, String searchStartDate,
			String searchEndDate, String searchAttitudeType,String offset, String companyId, int tenantId, String searchDeptId, List<String> deptIdList) throws Exception {
		LOGGER.debug("getAttitudeCount2 started.");
		
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
		
		LOGGER.debug("getAttitudeCount2 end. result = " + result);
		
		return result;
	}
	
	@Override
	public JSONObject getAttitudeAbsentedList(String searchUserName, String searchDeptName, String searchTitle, String searchStartDate, String searchEndDate, String searchDeptId, String pageNum, String listSize, String orderCell, String orderOption, String duplicated, String userLang, String offset, String companyId, int tenantId, List<String> deptIdList, String primary) throws Exception {
		LOGGER.debug("getAttitudeAbsentedList started.");
		
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
		if (primary.equals("1")) {
			primary = "";
		}
		map.put("primary", primary);
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Calendar cal = Calendar.getInstance();
		
		Date startDate = sdf.parse(searchStartDate);
		cal.setTime(startDate);
		
		List<AdminAttitudeVO> totalList = new ArrayList<AdminAttitudeVO>();
		
		for (String tempDate : checkHoliday(searchStartDate, searchEndDate, userLang, companyId, tenantId)) {
			LOGGER.debug("tempDateTime = " + tempDate);
			
			map.put("searchStartDate", commonUtil.getDateStringInUTC(tempDate + " 00:00:00", offset, true));
			map.put("searchEndDate", commonUtil.getDateStringInUTC(tempDate + " 23:59:59", offset, true));
			
			List<AdminAttitudeVO> resultList = ezAttitudeDAO.getAttitudeAbsentList(map);
			totalList.addAll(resultList);
			
			LOGGER.debug("resultList size = " + resultList.size());
		}
		
		if (duplicated.equals("distinct")) {
			HashSet<AdminAttitudeVO> listSet = new HashSet<AdminAttitudeVO>(totalList);
			totalList = new ArrayList<AdminAttitudeVO>(listSet);
			LOGGER.debug("duplicate totalList size = " + totalList.size());
		} else {
			LOGGER.debug("distinct totalList size = " + totalList.size());
		}
		
		LOGGER.debug("sorting started.");
		
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
		
		LOGGER.debug("sorting ended.");
		
		JSONObject data = new JSONObject();
		data.put("totalCount", totalList.size());
		
		LOGGER.debug("paging started.");
		
		if (listSize != "") {
			int size = Integer.valueOf(listSize);
			int limit = (Integer.valueOf(pageNum) - 1) * size;
			
			if (totalList.size() < limit + size) {
				LOGGER.debug("1page param = " + limit + ", " + totalList.size());
				totalList = totalList.subList(limit, totalList.size());
			} else {
				LOGGER.debug("2page param = " + limit + ", " + (limit + size));
				totalList = totalList.subList(limit, limit + size);
			}
		}
		
		LOGGER.debug("paging ended. pageSize = " + totalList.size());
		
		data.put("list", totalList);
		
		LOGGER.debug("getAttitudeAbsentedList ended.");
		
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
		LOGGER.debug("checkHoliday started.");
		LOGGER.debug("startDate = " + checkStartDate + " || endDate = " + checkEndDate + " || userLang = " + userLang);
		
		/*2018-05-08 이효진 holidayList 생성*/
		//회사 기념일
		List<HolidayVO> holidayList = getHolidayList("rest", companyId, tenantId);
		//근태휴무일
		AttitudeConfigVO attitudeConfig = getAttitudeConfig(tenantId, companyId);
		String checkDay[] = attitudeConfig.getClosedDay().split(",");
		//국가공휴일
		KoreanLunarCalendar koreaCalendar = KoreanLunarCalendar.getInstance();
		
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
		
		//음력 -> 양력변환
		DecimalFormat df = new DecimalFormat("00");
		String startYear = checkStartDate.substring(0, 4);
		String endYear = checkEndDate.substring(0, 4);
		
		for (HolidayVO vo1 : holidayList) {
			if (vo1.getIsSolar() == 0) {
				String lunarDate = vo1.getHolidayDate();
				
				koreaCalendar.setLunarDate(Integer.parseInt(lunarDate.substring(0, 4)), Integer.parseInt(lunarDate.substring(5, 7)), Integer.parseInt(lunarDate.substring(8, 10)), true);
				vo1.setHolidayDate(koreaCalendar.getSolarYear() + "-" + df.format(koreaCalendar.getSolarMonth()) + "-" + df.format(koreaCalendar.getSolarDay()));
			}
			
			String voYear = vo1.getHolidayDate().substring(0, 4);
			
			if (vo1.getIsRepeat() == 1) {
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
						
						holidayList.add(vo2);
					}
				}
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
						
						break;
					}
				case 2:
					if (checkDay[1].equals("1")) {
						break;
					} else {
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
						
						break;
					}
				case 3:
					if (checkDay[2].equals("1")) {
						break;
					} else {
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
						
						break;
					}
				case 4:
					if (checkDay[3].equals("1")) {
						break;
					} else {
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
						
						break;
					}
				case 5:
					if (checkDay[4].equals("1")) {
						break;
					} else {
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
						
						break;
					}
				case 6:
					if (checkDay[5].equals("1")) {
						break;
					} else {
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
						
						break;
					}
				case 7:
					if (checkDay[6].equals("1")) {
						break;
					} else {
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
						
						break;
					}
				}
			}
			
			cal.add(Calendar.DAY_OF_MONTH, 1);
			
			if (tempDate.equals(checkEndDate)) {
				break;
			}
		};
		
		LOGGER.debug("checkHoliday ended.");
		
		return result;
	}
	
	/* 현재는 메일 작성창을 띄우므로 사용하지 않고 있음.
	@Override
	public void absentedListSendMail(List<AdminAttitudeVO> duplicatedList, List<AdminAttitudeVO> distinctList, String loginCookie, String startDate, String endDate, String fromName, String fromEmail) throws Exception {
		LOGGER.debug("absentedListSendMail started.");
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
		
		LOGGER.debug("absentedListSendMail ended.");
	}
	*/

	@Override
	public void changeUsersModifyAtt(String companyId, int tenantId,
			String ids, String changeStatus, String userId, String userName, String userName2, String offSet) throws Exception {
		LOGGER.debug("changeUsersModifyAtt started.");
		
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
		LOGGER.debug("changeUsersModifyAtt ended.");
	}

	@Override
	public List<AttitudeAuthorVO> getAttitudeAuthList(int tenantId,
			String companyId, String primary) throws Exception {
		LOGGER.debug("getAttitudeAuthList started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		if (primary.equals("1")) {
			primary = "";
		}
		map.put("primary", primary);
		
		LOGGER.debug("getAttitudeAuthList ended.");
		
		return ezAttitudeDAO.getAttitudeAuthList(map);
	}

	@Override
	public void deleteAttitudeAuth(String selectUserId, int tenantId,
			String companyId) throws Exception {
		LOGGER.debug("deleteAttitudeAuth started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("selectUserId", selectUserId);
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		
		ezAttitudeDAO.deleteAttitudeAuth(map);
		
		LOGGER.debug("deleteAttitudeAuth ended.");
	}
	
	@Override
	public List<AttitudeApplicationVO> attModGetHistory(String attModId, String userId, String offset, String lang, String companyId, int tenantId) throws Exception {
		LOGGER.debug("attModGetHistory started");
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("userId", userId);
		map.put("attModId", attModId);
		map.put("offset", offset);
		if (lang.equals("1")) {
			lang = "";
		}
		map.put("lang", lang);
		
		List<AttitudeApplicationVO> attAppList = ezAttitudeDAO.attModGetHistory(map); 
		
		LOGGER.debug("attModGetHistory ended");
		return attAppList;
	}
	
	@Override
	public void saveAttitudeAuthDept(int tenantId, String companyId,
			String selectedUser, String deptIds, String authTypes) throws Exception {
		LOGGER.debug("saveAttitudeAuthDept started");

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

		LOGGER.debug("saveAttitudeAuthDept ended");
	}

	@Override
	public List<AttitudeAuthorVO> getAttitudeAuthDeptList(int tenantId, String companyId,
			String userId, String isAllDept, String primary) throws Exception {
		LOGGER.debug("getAttitudeAuthDeptList started");
		
		List<AttitudeAuthorVO> list = new ArrayList<AttitudeAuthorVO>();
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("userId", userId);
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		if (primary.equals("1")) {
			primary = "";
		}
		map.put("primary", primary);
		
		if (!isAllDept.equals("Y")) {
			list = ezAttitudeDAO.getAttitudeAuthDeptList(map);
		} else {
			map.put("isAllDept", isAllDept);
			list = ezAttitudeDAO.getCompanyDeptList(map);
		}
		
		LOGGER.debug("getAttitudeAuthDeptList ended");
		
		return list;
	}
	
	@Override
	public List<AttitudeAuthorVO> getAttitudeAuthDeptList_hyo(int tenantId, String companyId, String userId, String rollInfo, String userAuthType, String listAuthType, String comFlag) throws Exception {
		LOGGER.debug("getAttitudeAuthDeptList started.");
		
		if (userAuthType == null || userAuthType.equals("")) {
			if (rollInfo.contains("c=1") || rollInfo.contains("k=1") || rollInfo.contains("a1=1")) {
				// 전체, 회사, 근태관리자 -> 모든부서 관리권한
				userAuthType = "all";
			} else if (rollInfo.contains("g=1")) {
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
		
		LOGGER.debug("userId = " + userId + " || userAuthType = " + userAuthType + " || listAuthType = " + listAuthType + " || comFlag = " + comFlag);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		map.put("userAuthType", userAuthType);
		map.put("listAuthType", listAuthType);
		map.put("comFlag", comFlag);
		
		List<AttitudeAuthorVO> list = ezAttitudeDAO.getAttitudeAuthDeptList_hyo(map);
		
		LOGGER.debug("getAttitudeAuthDeptList ended.");
		
		return list;
	}

	@Override
	public List<AttitudeStatisVO> getAttitudeUserStatistics(String userId, String deptId,
			String offset, String year, String typeId, int tenantId)
			throws Exception {
		LOGGER.debug("getAttitudeUserStatistics started.");

		Map<String, Object> map = new HashMap<String, Object>();
		
		String startTime = "-01 00:00:00";
		
		map.put("userId", userId);
		map.put("deptId", deptId);
		map.put("offsetMin", commonUtil.getMinuteUTC(offset));
		map.put("year", year);
		map.put("startTime", startTime);
		map.put("typeId", typeId);
		map.put("tenantId", tenantId);
		
		List<AttitudeStatisVO> list = new ArrayList<AttitudeStatisVO>();
		for (int months = 1; months < 13; months++) {
			Calendar cal = Calendar.getInstance();
			cal.set(Integer.valueOf(year), months - 1, 1);
			
			String endTime = "-" + cal.getActualMaximum(Calendar.DAY_OF_MONTH) + " 23:59:59";
			map.put("endTime", endTime);
			map.put("months", months);
			
			AttitudeStatisVO vo = ezAttitudeDAO.getAttitudeUserStatistics(map);
			if (vo != null) {
				list.add(vo);
			} else {
				AttitudeStatisVO vo2 = new AttitudeStatisVO();
				vo2.setCount("0");
				vo2.setTypeId(typeId);
				vo2.setStatMonth(String.valueOf(months));
				list.add(vo2);
			}
		}
		
		LOGGER.debug("getAttitudeUserStatistics ended.");
		
		return list;
	}

	@Override
	public List<AttitudeAuthorVO> getCompanyDeptList(String userId,
			String companyId, int tenantId) throws Exception {
		LOGGER.debug("getCompanyDeptList started");
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("userId", userId);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		LOGGER.debug("getCompanyDeptList ended");
		
		return ezAttitudeDAO.getCompanyDeptList(map);
		
	}
	
	@Override
	public String deleteAttitudeType(String typeId, int tenantId, String companyId) throws Exception {
		LOGGER.debug("deleteAttitudeType started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("typeId", typeId);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		String result = "false";
		
		if (ezAttitudeDAO.checkUseAttitudeType(map) == 0) {
			ezAttitudeDAO.deleteAttitudeType(map);
			
			result = "true";
		}
		
		LOGGER.debug("deleteAttitudeType ended.");
		
		return result;
	}
	
	@Override
	public List<ModApplHistoryVO> getAttitudeHistoryList(String searchUserName, String searchDeptName, String searchTitle, String searchStartDate, String searchEndDate, String orderCell, String orderOption, String offset, String pageNum, String listSize, String companyId, int tenantId, String deptId, List<String> deptIdList, String primary) throws Exception {
		LOGGER.debug("getAttitudeHistoryList started");
		
		int limit = 0;
		
		if (pageNum != null && !pageNum.equals("")) {
			limit = (Integer.valueOf(pageNum) - 1) * Integer.valueOf(listSize);
		}
		
		searchStartDate = commonUtil.getDateStringInUTC(searchStartDate + " 00:00:00", offset, true);
		searchEndDate = commonUtil.getDateStringInUTC(searchEndDate + " 23:59:59", offset, true);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("searchUserName", searchUserName);
		map.put("searchDeptName", searchDeptName);
		map.put("deptId", deptId);
		map.put("searchTitle", searchTitle);
		map.put("searchStartDate", searchStartDate);
		map.put("searchEndDate", searchEndDate);
		map.put("orderCell", orderCell);
		map.put("orderOption", orderOption);
		map.put("listSize", listSize);
		map.put("offsetMin", commonUtil.getMinuteUTC(offset));
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("limit", limit);
		map.put("deptIdList", deptIdList);
		if (primary.equals("1")) {
			primary = "";
		}
		map.put("primary", primary);
		map.put("row_startNum", (limit + 1));
		map.put("row_endNum", (limit + Integer.valueOf(listSize)));

		List<ModApplHistoryVO> resultList = ezAttitudeDAO.getAttitudeHistoryList(map);

		LOGGER.debug("getAttitudeHistoryList ended. resultList size = " + resultList.size());
		
		return resultList;
	}

	@Override
	public String getAttitudeHistoryCount(String searchUserName, String searchDeptName, String searchTitle, String searchStartDate,
			String searchEndDate, String offset, String companyId, int tenantId, String deptId, List<String> deptIdList) throws Exception {
		LOGGER.debug("getAttitudeHistoryCount started.");
		
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
		
		LOGGER.debug("getAttitudeHistoryCount end. result = " + result);
		
		return result;
	}

	@Override
	public void insertAdminAttHistory(String writerId, String deptId,
			String startDate, String endDate, String region, String mobile,
			String bizSub, String content, String ip, String typeId,
			String dateType, String offset, String companyId, int tenantId,
			String adminId) throws Exception {
		
		LOGGER.debug("insertAdminAttHistory started.");
		
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
		
		LOGGER.debug("insertAdminAttHistory ended.");
	}
	
	@Override
	public String getSearchList(String pSearchList, String pCellList, String pPropList, String pClass, int pLimit, String primary, int tenantID) throws Exception {
		LOGGER.debug("getSearchList started");
		
        String[] searchParemeta = null;
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
        
        if (!pSearchList.equals("")){
            pSearchList = pSearchList.replace(";;", "##");
            pSearchList = pSearchList.replace("::", "@@");
            searchList = pSearchList.split("##");
            searchParemeta = new String[searchList.length];
            
            LOGGER.debug("searchList.length=" + searchList.length);
            
            for (i = 0; i < searchList.length; i++){      	
                searchInfo = searchList[i].split("@@");

                if (i == 0){
                    // 수정(2007.06.26) : 검색 시 특정 필드(이름/부서명/직위)의 경우 Primary/Secondary 값을 모두 검색하도록 수정
                    //searchParemeta[i] = searchInfo[1].replace("[", "[[]").replace("%", "[%]").replace("_", "[_]");
                	
                	//수정(2017-01-23)
                	// 검색 시 _가 들어간 문자가 검색이 안되어, [_]로 replace하는부분 제거
                	searchParemeta[i] = searchInfo[1].replaceAll("%", "\\\\%").replaceAll("'", "\\\\'");
                	
                    if (checkSearchField(searchInfo[0])){
                        if (searchInfo[0].toUpperCase().equals("DISPLAYNAME") && searchParemeta[0].toString().equals("/")){
                            strSQL = strSQL + " WHERE (" + searchInfo[0].toLowerCase() + " = '" + searchParemeta[i] + "' OR " + searchInfo[0].toLowerCase() + "2 = '" + searchParemeta[i] + "')";
                            searchParemeta[0] = searchParemeta[0].substring(0, searchParemeta[0].length() - 1);
                        }else{
                            strSQL = strSQL + " WHERE (" + searchInfo[0].toLowerCase() + " LIKE  '%" + searchParemeta[i] + "%' OR " + searchInfo[0].toLowerCase() + "2 LIKE '%" + searchParemeta[i] + "%')";
                        }
                    }else{
                        if (searchInfo[0].indexOf("EXACT_") == 0){
                            strSQL = strSQL + " WHERE " + searchInfo[0].substring(6).toLowerCase() + "='" + searchParemeta[i] + "' ";
                        }else if (searchInfo[0].indexOf("LEFT_") == 0){
                            strSQL = strSQL + " WHERE " + searchInfo[0].substring(5).toLowerCase() + " LIKE '" + searchParemeta[i] + "%' ";
                        }else if (searchInfo[0].indexOf("RIGHT_") == 0){
                            strSQL = strSQL + " WHERE " + searchInfo[0].substring(5).toLowerCase() + " LIKE '%" + searchParemeta[i] + "%'";
                    	}else{
                            strSQL = strSQL + " WHERE " + searchInfo[0].toLowerCase() + " LIKE '%" + searchParemeta[i] + "%'";
                    	}
                    }
                }else{
                    // 수정(2007.06.26) : 검색 시 특정 필드(이름/부서명/직위)의 경우 Primary/Secondary 값을 모두 검색하도록 수정
                    searchParemeta[i] = searchInfo[1].replaceAll("%", "\\\\%").replaceAll("'", "\\\\'");
                    
                    if (checkSearchField(searchInfo[0])){
                        strSQL = strSQL + " AND (" + searchInfo[0].toLowerCase() + " LIKE  '%" + searchParemeta[i] + "%' OR " + searchInfo[0].toLowerCase() + "2 LIKE '%" + searchParemeta[i] + "%')";
                    }else{
                        if (searchInfo[0].indexOf("EXACT_") == 0){
                            strSQL = strSQL + " AND " + searchInfo[0].substring(6).toLowerCase() + "='" + searchParemeta[i] + "' ";
                        }else if (searchInfo[0].indexOf("LEFT_") == 0){
                            strSQL = strSQL + " AND " + searchInfo[0].substring(5).toLowerCase() + " LIKE '" + searchParemeta[i] + " %' ";
                        }else if (searchInfo[0].indexOf("RIGHT_") == 0){
                            strSQL = strSQL + " AND " + searchInfo[0].substring(5).toLowerCase() + " LIKE '%" + searchParemeta[i] + "%'";
                        }else{
                            strSQL = strSQL + " AND " + searchInfo[0].toLowerCase() + " LIKE '%" + searchParemeta[i] + "%'";
                        }
                    }
                }
            }
        }        
        
        if (pClass.equals("user") || pClass.equals("all")){
            strSQL = strSQL.replace("cn", "a.cn");
            strSQL = strSQL.replace("title", "a.title");
                        
            type = "U";
        }else{
        	type = "G";
        }

        Map<String, Object> map = new HashMap<String, Object>();
                
        map.put("strSQL", strSQL + strSize);
        map.put("strSQLForMySQL", strSQL);
        map.put("strSizeForMySQL", strSizeForMySQL);
        map.put("type", type);
        map.put("class", pClass);
        map.put("v_TENANT_ID", tenantID);
        
        LOGGER.debug("strSQL=" + strSQL);
        
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

		LOGGER.debug("getSearchList ended");
		
		return memberlist2.toString();
	}
	
    @Override
    public String getSearchListPagination(String pSearchList, String pCellList, String pPropList, String pClass, int pLimit, String pLangCode, String page, int tenantID, List<String> deptIdList) throws Exception {
    	LOGGER.debug("getSearchListPagination started");
    	
        String strSQL="";
        int i=0;
        String[] SearchList;
        String[] SearchInfo;
        String ListInfo="";
        String[] SearchParemeta=null;
        String type = "";
        StringBuilder memberlist2 = null;
        try {
	        if (!pSearchList.equals("")){
	               pSearchList = pSearchList.replace(";;", "##");
	               pSearchList = pSearchList.replace("::", "@@");
	               SearchList  = pSearchList.split("##");
	               
	               SearchParemeta = new String[SearchList.length];
	               
	               LOGGER.debug("searchList.length=" + SearchList.length);
	               
	               for(i = 0; i < SearchList.length; i++){
	                   SearchInfo = SearchList[i].split("@@");
	                   
	                   if(i == 0){
	                       // 수정(2007.06.26) : 검색 시 특정 필드(이름/부서명/직위)의 경우 Primary/Secondary 값을 모두 검색하도록 수정
	                       SearchParemeta[i] = SearchInfo[1].replaceAll("%", "\\\\%").replaceAll("'", "\\\\'").toLowerCase();
	                       if (checkSearchField(SearchInfo[0])){
	                           if (SearchInfo[0].toUpperCase().equals("DISPLAYNAME") && SearchParemeta[0].toString().equals(":")){
	                               strSQL = strSQL + " WHERE (" + SearchInfo[0].toLowerCase() + " = UPPER('" + SearchParemeta[i] + "') OR " + SearchInfo[0].toLowerCase() + "2 = UPPER('" + SearchParemeta[i] + "'))";
	                               SearchParemeta[0] = SearchParemeta[0].substring(0, SearchParemeta[0].length() - 1);
	                           }
	                           else{
	                               strSQL = strSQL + " WHERE (" + SearchInfo[0].toLowerCase() + " LIKE  '%" + SearchParemeta[i] + "%' OR " + SearchInfo[0].toLowerCase() + "2 LIKE '%" + SearchParemeta[i] + "%')";
	                       }
	                   }
	                   else{
	                       if (SearchInfo[0].indexOf("EXACT_") == 0)
	                           strSQL = strSQL + " WHERE " + SearchInfo[0].substring(6).toLowerCase() + "=UPPER('" + SearchParemeta[i] + "') ";
	                       else if (SearchInfo[0].indexOf("LEFT_") == 0)
	                           strSQL = strSQL + " WHERE " + SearchInfo[0].substring(5).toLowerCase() + " LIKE '" + SearchParemeta[i] + "%' ";
	                       else if (SearchInfo[0].indexOf("RIGHT_") == 0)
	                           strSQL = strSQL + " WHERE " + SearchInfo[0].substring(5).toLowerCase() + " LIKE '%" + SearchParemeta[i] + "%'";
	                       else
	                           strSQL = strSQL + " WHERE " + SearchInfo[0].toLowerCase() + " LIKE '%" + SearchParemeta[i] + "%'";
	                   }
	               }
	                   else{
	                       // 수정(2007.06.26) : 검색 시 특정 필드(이름/부서명/직위)의 경우 Primary/Secondary 값을 모두 검색하도록 수정
	                       SearchParemeta[i] = SearchInfo[1].replaceAll("%", "\\\\%").replaceAll("'", "\\\\'").toLowerCase();
	                       if (checkSearchField(SearchInfo[0]))
	                       {
	                           strSQL = strSQL + " AND (" + SearchInfo[0].toLowerCase() + " LIKE  '%" + SearchParemeta[i] + "%' OR " + SearchInfo[0].toLowerCase() + "2 LIKE '%" + SearchParemeta[i] + "%')";
	                       }
	                       else
	                       {
	                           if (SearchInfo[0].indexOf("EXACT_") == 0)
	                               strSQL = strSQL + " AND " + SearchInfo[0].substring(6).toLowerCase() + "=UPPER('" + SearchParemeta[i] + "') ";
	                           else if (SearchInfo[0].indexOf("LEFT_") == 0)
	                               strSQL = strSQL + " AND " + SearchInfo[0].substring(5).toLowerCase() + " LIKE '" + SearchParemeta[i] + "%' ";
	                           else if (SearchInfo[0].indexOf("RIGHT_") == 0)
	                               strSQL = strSQL + " AND " + SearchInfo[0].substring(5).toLowerCase() + " LIKE '%" + SearchParemeta[i] + "%'";
	                           else
	                               strSQL = strSQL + " AND " + SearchInfo[0].toLowerCase() + " LIKE '%" + SearchParemeta[i] + "%'";
	                       }
	                   }
	               }
	            }
	        
	        if (pClass.equals("user") || pClass.equals("all")){
	             strSQL = strSQL.replace("cn", "a.cn");
	             strSQL = strSQL.replace("title", "a.title");
	                          
	             type = "U";
	        }
	        else{
	            type = "G";
	        }
	
	        if(page.equals(null) || page.equals("")){
	            page = "1";
	        }
	        
	         int startRow = (Integer.parseInt(page) - 1) * 50 + 1;
	         int endRow = Integer.parseInt(page) * 50 + 1;
	         
	         Map<String , Object> map = new HashMap<String , Object>();
	                  
	         map.put("strSQL" , strSQL);
	         map.put("deptIdList", deptIdList);
	         map.put("type", type);
	         map.put("class", pClass);
	         map.put("startRow", startRow);
	         map.put("endRow", endRow);
	         map.put("v_TENANT_ID", tenantID);
	         map.put("startRowForMySQL", startRow - 1);
	         map.put("count", 50);              
	         
	         LOGGER.debug("strSQL=" + strSQL);
	         
	         List<OrganDeptVO> list = ezAttitudeDAO.attOrganSearchList(map);
	         
	         if(pClass.equals("user")){
	        	 int totalcount = ezAttitudeDAO.getSearchListCount(map);
	             memberlist2 = new StringBuilder("<LISTVIEWDATA>");
	             memberlist2.append("<TOTALCOUNT>" + totalcount + "</TOTALCOUNT><ROWS>");
	         }else{
	             memberlist2 = new StringBuilder("<LISTVIEWDATA><ROWS>");
	         }
	       
	
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
	                    map1.put("v_LANGDATA", pLangCode);
	                    map1.put("v_TENANT_ID", tenantID);
	                    
	                    result = ezOrganDAO.getTBLUserMaster(map1);                 
	                }else{
	                    map1.put("v_CN", organVO.getCn());
	                    map1.put("v_LANGDATA", pLangCode);
	                    map1.put("v_TENANT_ID", tenantID);
	                    
	                    result = ezOrganDAO.getTBLDeptMaster(map1);                 
	                }
	                
	                sb.append(commonUtil.getQueryResult(result));
	                sb.append("</DATA>");

	                ListInfo = getMemberInfo(sb.toString(), pCellList, pPropList, "", organVO.getType());
	                memberlist2.append(ListInfo);
	            }           
	        }
	        memberlist2.append("</ROWS></LISTVIEWDATA>");
        } catch (Exception e) {
        	e.printStackTrace();
        	memberlist2 = new StringBuilder("<LISTVIEWDATA>");
            memberlist2.append("<TOTALCOUNT>" + "0" + "</TOTALCOUNT><ROWS>");
            memberlist2.append("</ROWS></LISTVIEWDATA>");
        }
        LOGGER.debug("getSearchListPagination ended");
        
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
        }catch (Exception Ex){ }
        return bRet;
    }
    
    private String getMemberInfo(String pXMLString, String pCellList, String pPropList, String pMemberID, String pCategory) {		
        LOGGER.debug("getMemberInfo started");
        LOGGER.debug("pCellList=" + pCellList + ",pPropList=" + pPropList + ",pMemberID=" + pMemberID 
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
            
            LOGGER.debug("cellList["+i+"]=" + celllist[i]);
            
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

        LOGGER.debug("nodeInfo=" + nodeInfo);
        LOGGER.debug("getMemberInfo ended");
        
        return nodeInfo.toString();        
    }
    
    public String convertAddandConvert(String pClass, String pProvValue) {
	    LOGGER.debug("convertAddandConvert started");
	    LOGGER.debug("pClass=" + pClass + ",pProvValue=" + pProvValue);
	    
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
        
        LOGGER.debug("addPopList=" + addPopList);
        LOGGER.debug("convertAddandConvert ended");
        
        return addPopList;              
    }
    
    private String addPropList(String pType, String pAttribute) {
    	LOGGER.debug("addPropList started");
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
        
        LOGGER.debug("addPropList ended");
        
        return strRet;
    }
    
    @Override
    public String getIsAttitude(String typeId, String writerId, String startDate, String offset, String companyId, int tenantId) throws Exception {
    	LOGGER.debug("getIsAttitude started");
    	
    	if (typeId.equals("A01") || typeId.equals("A02")) {
    		typeId = "A01,A02";
    	} else if (typeId.equals("A03") || typeId.equals("A08")) {
    		typeId = "A03,A08";
    	}
    	
    	if (startDate.equals("")) {
			startDate = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), offset, false);
    	}
    	
    	Map<String,Object> map = new HashMap<String, Object>();
    	map.put("typeIdArr", typeId.split(","));
    	map.put("writerId", writerId);
    	map.put("offsetMin", commonUtil.getMinuteUTC(offset));
    	map.put("companyId", companyId);
    	map.put("tenantId", tenantId);
		map.put("checkStartDate", startDate.split(" ")[0]);
		
		LOGGER.debug("getIsAttitude ended");

		return ezAttitudeDAO.getIsAttitude(map);
    }

	@Override
	public List<AttitudeAuthorVO> getDeptUserList(int tenantId, String key, String value, String companyId, String lang) throws Exception {
		LOGGER.debug("getDeptUserList started");
		
		HashMap<String, Object> map = new HashMap<String, Object>();
		
		map.put("tenantId", tenantId);
		map.put("key", key);
		map.put("value", value);
		map.put("companyId", companyId);
		if (lang.equals("1")) {
			lang = "";
		}
		map.put("lang", lang);
		
		LOGGER.debug("getDeptUserList ended");
		
		return ezAttitudeDAO.getDeptUserList(map);
	}
}