package egovframework.ezEKP.ezAttitude.service.impl;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

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
import egovframework.ezEKP.ezAttitude.vo.JournalAuthorVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Service("EzAttitudeService")
public class EzAttitudeServiceImpl implements EzAttitudeService{
	private static final Logger LOGGER = LoggerFactory.getLogger(EzAttitudeServiceImpl.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private EzAttitudeDAO ezAttitudeDAO;

	@Override
	public AttitudeVO getAttitudeInfo(String attitudeId, String offset, int tenantId) throws Exception {
		LOGGER.debug("getAttitudeInfo started");
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("attitudeId", attitudeId);
		map.put("offsetMin", commonUtil.getMinuteUTC(offset));
		map.put("tenantId", tenantId);
		
		AttitudeVO attitudeVO = ezAttitudeDAO.getAttitudeInfo(map);
		LOGGER.debug("getAttitudeInfo ended");
		return attitudeVO;
	}

	@Override
	public void insertAttitude(String writerId, String deptId, String startDate,
			String endDate, String region, String mobile, String bizsub, String content,
			String ip, String typeId, String dateType, String offset, String companyId, int tenantId) throws Exception {
		LOGGER.debug("insertAttitude started");
		Map<String, Object> map = new HashMap<String, Object>();
		
		boolean isDefaultAtti = false;
		map.put("writerId", writerId);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		if (typeId.equals("A01") || typeId.equals("A03")) {
			startDate = commonUtil.getTodayUTCTime("");
			
			if (typeId.equals("A01")) {
				//사용자별 근태설정이 있는 지 검사
				String isValue = ezAttitudeDAO.getIsAttitudeUserConf(map);
				map.put("isValue", isValue);
				
				AttitudeUserConfigVO resultVO = ezAttitudeDAO.getAttitudeConfTime(map);
				
				String compareDate = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), offset, false).substring(11);
				String resultConfDate = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime("yyyy-MM-dd") + " " + resultVO.getWorkStartTime() + ":00", offset, false).substring(11);
				
				LOGGER.debug("isValue : " + isValue + "////////" + resultVO.getWorkStartTime());
				//시간을 비교해서 근태설정 시간보다 늦으면 지각 처리
				
				SimpleDateFormat f = new SimpleDateFormat("HH:mm:ss");
				
				Date userConfTime = f.parse(resultConfDate);
				Date userInTime = f.parse(compareDate);
				
				if (userInTime.after(userConfTime)) { //지각인 경우
					typeId = "A02";
				}
			}
			
			isDefaultAtti = true;
		}
		
		map.put("deptId", deptId);
		map.put("startDate", startDate);
		map.put("endDate", endDate);
		map.put("region", region);
		map.put("mobile", mobile);
		map.put("bizSub", bizsub);
		map.put("content", content);
		map.put("ipAddress", ip);
		map.put("typeId", typeId);
		map.put("offsetMin", commonUtil.getMinuteUTC(offset));
		map.put("isDefaultAtti", isDefaultAtti); // 출근, 퇴근과 다른 기타 근태의 insert쿼리를 다르게 하기 위해 적용
		map.put("dateType", dateType);
		
		ezAttitudeDAO.insertAttitude(map);
		LOGGER.debug("insertAttitude ended");
	}

	@Override
	public List<AttitudeVO> getAttitudeList(String pidList, String deptIdList, String yrmh,
		String typeId, String startDate, String endDate, String offset, int tenantId, String deptFlag) throws Exception {
		LOGGER.debug("getAttitudeList started");
		Map<String, Object> map = new HashMap<String,Object>();
		//if써서 하루꺼를 가져오려는 건지 한달꺼를 가져오려는 건지를 구분해야 될 꺼 같다.
		//일단 하루치를 가져오는 것 부터
		//true면 UTC false면 local
		String offsetMin = commonUtil.getMinuteUTC(offset);
		//startDate와 endDate가 없는 경우 당일의 근태를  출력
		LOGGER.debug("typeId :" + typeId);
		if (startDate.equals("") && endDate.equals("")) {
			String localDate = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), offset, false).split(" ")[0];
			startDate = localDate + " 00:00:00";
			endDate = localDate + " 23:59:59";
		} else { //startDate와 endDate가 있는 경우 한달의 근태를 출력 
			startDate = startDate + " 00:00:00";
			endDate = endDate + " 23:59:59";
		}
		
		String[] pidListArr = pidList.split(",");
		String[] deptIdArr = deptIdList.split(",");
		
		map.put("startDate", startDate);
		map.put("endDate", endDate);
		map.put("tenantId", tenantId);
		map.put("offsetMin", offsetMin);
		if (!typeId.trim().equals("")){
			map.put("typeId", typeId);
		}
		if (!pidList.trim().equals("")){
			map.put("pidListArr", pidListArr);
		}
		if (!deptIdList.trim().equals("")){
			map.put("deptIdArr", deptIdArr);
		}
	
		List<AttitudeVO> resultList = ezAttitudeDAO.getAttitudeList(map);
		
		LOGGER.debug("getAttitudeList ended");
		return resultList;
	}

	@Override
	public List<AttitudeStatisVO> getAttitudeStatisticsList(String pidList, String deptIdList, String offset,
			String startDate, String endDate, int tenantId, String deptFlag) throws Exception {
		LOGGER.debug("getAttitudeStatisticsList started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		String offsetMin = commonUtil.getMinuteUTC(offset);
		String[] pidListArr = pidList.split(",");
		String[] deptIdArr = deptIdList.split(",");

		map.put("offsetMin", offsetMin);
		map.put("startDate", startDate);
		map.put("endDate", endDate);
		map.put("tenantId", tenantId);
		
		if (!pidList.trim().equals("")){
			map.put("pidListArr", pidListArr);
		}
		if (!deptIdList.trim().equals("")){
			map.put("deptIdArr", deptIdArr);
		}
		
		LOGGER.debug("getAttitudeStatisticsList ended");
		return ezAttitudeDAO.getAttitudeStatisList(map);
	}

	@Override
	public List<AttitudeTypeVO> getAttitudeTypeList(String companyId, String isuse, String isAdmin, String statistics, int tenantId) throws Exception {
		LOGGER.debug("getAttitudeTypeList started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		map.put("isuse", isuse);
		map.put("isAdmin", isAdmin);
		map.put("statistics", statistics);
		
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
	public void updateAttitude(String attitudeId, String startDate,
			String endDate, String region, String mobile, String bizSub, String content, 
			String offset, String ip, String typeId, String dateType, int tenantId) throws Exception {
		LOGGER.debug("updateAttitude started");
		
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
		
		ezAttitudeDAO.updateAttitude(map);
		
		LOGGER.debug("updateAttitude ended");
	}

	@Override
	public void deleteAttitude(String attitudeId, int tenantId)
			throws Exception {
		LOGGER.debug("deleteAttitude started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("attitudeId", attitudeId);
		map.put("tenantId", tenantId);
		
		ezAttitudeDAO.deleteAttitude(map);
		LOGGER.debug("deleteAttitude ended");
		
	}

	@Override
	public void insertAttitudeApplication(String attitudeId, String writerId,
			String writerName, String writerName2, String writerTitle,
			String writerTitle2, String writerDeptId, String writerDeptName,
			String writerDeptName2, String changeDate, String changeTime,
			String content, String companyId, int tenantId) throws Exception {
		// TODO Auto-generated method stub
		LOGGER.debug("insertAttitudeApplication started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
//		map.put("", );
//		map.put("", );
//		map.put("", );
//		map.put("", );
//		map.put("", );
//		map.put("", );
//		map.put("", );
//		map.put("", );
//		map.put("", );
//		map.put("", );
//		map.put("", );
//		map.put("", );
//		map.put("", );
//		map.put("", );
//		map.put("", );
		
		LOGGER.debug("insertAttitudeApplication ended");
	}

	@Override
	public String getAttitudeApplStatus(String attitudeId, int tenantId)
			throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void updateAttitudeApplicationApproval(String attitudeId,
			String apprUserId, String apprUserName, String apprUserName2,
			String apprStatus, int tenantId) throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void deptExcelDownload(String downMode, String pidList, int tenantId)
			throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	public List<Map<String, String>> getDeptAttitudeList(String pidList,
			int tenantId) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

//	@Override
//	public void updateAttitudeUserConfig(int tenantID, String userID,
//			String workStartTime, String workEndTime) throws Exception {
//		// TODO Auto-generated method stub
//		
//	}
//
//	@Override
//	public void insertAttitudeUserConfig(int tenantID, String companyID,
//			String userID, String workStartTime, String workEndTime)
//			throws Exception {
//		// TODO Auto-generated method stub
//		
//	}
	
	@Override
	public void saveAttitudeUserConfig(String selectUserId, String workStartTime, String workEndTime, String offSet, int tenantId) throws Exception {
		LOGGER.debug("saveAttitudeUserConfig started");
		LOGGER.debug("selectUserId = " + selectUserId + " || workStartTime = " + workStartTime + " || workEndTime = " + workEndTime);
		
		String today =  commonUtil.getTodayUTCTime("yyyy-MM-dd");
		String startDate = commonUtil.getDateStringInUTC(today + " " + workStartTime, offSet, true);
		String endDate = commonUtil.getDateStringInUTC(today + " " + workEndTime, offSet, true);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("tenantId", tenantId);
		map.put("userId", selectUserId);
		map.put("workStartTime", startDate.substring(11));
		map.put("workEndTime", endDate.substring(11));
		
		ezAttitudeDAO.saveAttitudeUserConfig(map);
		
		LOGGER.debug("saveAttitudeUserConfig ended");
	}

	@Override
	public void updateAttitudeApplication(String attitudeId, String changeTime,
			String content, String companyId, int tenantId) throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	public AttitudeApplicationVO getAttitudeApplicationInfo(int tenantId,
			String companyId, String attitudeId) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void deleteAttitudeApplication(String attitudeId, int tenantId)
			throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	public List<AttitudeApplicationVO> getUserAttitudeApplicationList(
			String userId, int tenantId, String writeName, String apprUserName,
			String startDate, String endDate, String statusType)
			throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<AttitudeApplicationVO> getAttitudeApplicationList(int tenantId,
			String writeName, String apprUserName, String deptName,
			String startDate, String endDate, String statusType)
			throws Exception {
		// TODO Auto-generated method stub
		return null;
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
	public void updateAttitudeConfig(JSONObject jsonParam)
			throws Exception {
		LOGGER.debug("updateAttitudeConfig started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("tenantId", jsonParam.get("tenantId").toString());
		map.put("companyId", jsonParam.get("companyId").toString());
		map.put("workStartTime", jsonParam.get("workStartTime").toString());
		map.put("workEndTime", jsonParam.get("workEndTime").toString());
		map.put("closedDay", jsonParam.get("closedDay").toString());
		map.put("attitudeModAppl", jsonParam.get("attitudeModAppl").toString());
		map.put("closedDateAttitude", jsonParam.get("closedDateAttitude").toString());
		map.put("confSetDate", jsonParam.get("confSetDate").toString());
		
		ezAttitudeDAO.updateAttitudeConfig(map);
		
		LOGGER.debug("updateAttitudeConfig ended");
	}

	@Override
	public void updateAttitudeTypeConfig(String typeConfigList, String companyId,
			int tenantId) throws Exception {
		LOGGER.debug("updateAttitudeTypeConfig started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		
		String[] typeList = typeConfigList.split(";");
		
		for (int i = 0; i < typeList.length; i++) {
			
			String[] typeInfo = typeList[i].split(",");
			
			LOGGER.debug("typeId = " + typeInfo[0]);
			
			map.put("typeId", typeInfo[0]);
			map.put("isuse", typeInfo[1]);
			
			ezAttitudeDAO.updateAttitudeTypeConfig(map);
		}
		
		LOGGER.debug("updateAttitudeTypeConfig ended");
	}

	@Override
	public void insertAttitudeType(String typeId, String typeName, String typeName2,
			String imgPath, int tenantId,
			String companyId) throws Exception {
		LOGGER.debug("insertAttitudeType started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("typeId", typeId);
		map.put("typeName", typeName);
		if(!typeName2.equals("") || typeName2 != null){
			map.put("typeName2", typeName2);
		}
		if(!imgPath.equals("") || imgPath != null){
			int idx = imgPath.lastIndexOf("/");
			imgPath = imgPath.substring(idx+1);
			map.put("imgPath", imgPath);
		}
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		
		ezAttitudeDAO.insertAttitudeType(map);
		
		LOGGER.debug("insertAttitudeType ended");
	}
	
	@Override
	public void insertAttitudeTypeIcon(String typeId, String fileName,
			String realPath, int tenantId) throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	public AttitudeTypeVO getAttitudeTypeInfo(int tenantId, String companyId,
			String typeId) throws Exception {
		LOGGER.debug("getAttitudeTypeInfo started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("typeId", typeId);
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		
		LOGGER.debug("getAttitudeTypeInfo ended");
		return ezAttitudeDAO.getAttitudeTypeInfo(map);
	}

	@Override
	public void updateAttitudeType(String typeId, String typeName, String typeName2,
			String imgPath, int tenantId, String companyId) throws Exception {
		LOGGER.debug("updateAttitudeType started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		int idx = imgPath.lastIndexOf("/");
		imgPath = imgPath.substring(idx+1);
		
		map.put("typeId", typeId);
		map.put("typeName", typeName);
		map.put("typeName2", typeName2);
		map.put("imgPath", imgPath);
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		
		ezAttitudeDAO.updateAttitudeType(map);
		
		LOGGER.debug("updateAttitudeType ended");
	}

	@Override
	public List<AttitudeUserConfigVO> getAttitudeUserConfigList(int tenantId, String companyId,
			String searchUserName, String searchDeptName, String searchTitle, String searchStartTime,
			String searchEndTime, String searchCompareValue, String pageNum, String listSize,
			String orderCell, String orderOption, String offsetMin) throws Exception {
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
		map.put("searchCompareValue", searchCompareValue);
		map.put("limit", limit);
		map.put("listSize", listSize);
		map.put("orderCell", orderCell);
		map.put("orderOption", orderOption);
		map.put("offsetMin", offsetMin);
		
		List<AttitudeUserConfigVO> resultList = ezAttitudeDAO.getAttitudeUserConfigList(map);
		
		LOGGER.debug("getAttitudeUserConfigList ended. resultList size = " + resultList.size());
		
		return resultList;
	}

	@Override
	public AttitudeUserConfigVO getAttitudeUserConfigInfo(String selectUserId, String offsetMin, int tenantId) throws Exception {
		LOGGER.debug("getAttitudeUserConfigInfo started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("selectUserId", selectUserId);
		map.put("offsetMin", offsetMin);
		map.put("tenantId", tenantId);
		
		AttitudeUserConfigVO vo = ezAttitudeDAO.getAttitudeUserConfigInfo(map);
		
		LOGGER.debug("getAttitudeUserConfigInfo ended");
		
		return vo;
	}

	@Override
	public List<AttitudeDeptVO> getCompanyList(String lang, int tenantId) throws Exception{
		LOGGER.debug("getCompanyList started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("lang", lang);
		map.put("tenantId", tenantId);
		
		List<AttitudeDeptVO> companyList = ezAttitudeDAO.getCompanyList(map);
		
		LOGGER.debug("getCompanyList ended");
		
		return companyList;
	}

	@Override
	public String getAttitudeUserConfigCount(int tenantId, String companyId, String searchUserName, String searchDeptName,
			String searchTitle, String searchStartTime, String searchEndTime, String searchCompareValue, String offsetMin) throws Exception {
		LOGGER.debug("getAttitudeUserConfigListCount started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		map.put("searchUserName", searchUserName);
		map.put("searchDeptName", searchDeptName);
		map.put("searchTitle", searchTitle);
		map.put("searchStartTime", searchStartTime);
		map.put("searchEndTime", searchEndTime);
		map.put("searchCompareValue", searchCompareValue);
		map.put("offsetMin", offsetMin);
		
		String totalCount = ezAttitudeDAO.getAttitudeUserConfigCount(map);
		
		LOGGER.debug("getAttitudeUserConfigListCount ended. totalCount = " + totalCount);
		
		return totalCount;
	}

	@Override
	public List<AttitudeApplicationVO> getUsersModiyAtt(String companyId, int tenantId,
			String userId, String startDate, String endDate, String apprUserName, String writerName, String writerDeptName, String sysLang, 
			String offset,String startPoint, String endPoint, String type, String order, String adminFlag, String checkAdmin) throws Exception {
		LOGGER.debug("getUsersModiyAtt started");
		
		if (adminFlag == null) {
			adminFlag = "false";
		}
		
		if (checkAdmin == null) {
			checkAdmin = "false";
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		if (!adminFlag.trim().equals("true")){
			map.put("userId", userId);
		} else if (checkAdmin.equals("false")) {
			String[] deptIdList = {"approval"};
			map.put("deptIdList", deptIdList);
		}
		map.put("startDate", startDate);
		map.put("endDate", endDate);
		map.put("apprUserName", apprUserName);
		map.put("writerName", writerName);
		map.put("writerDeptName", writerDeptName);
		map.put("sysLang", sysLang);
		map.put("offset", offset);
		map.put("startPoint", startPoint);
		map.put("endPoint", endPoint);
		map.put("type", type);
		if (order !=null) {
			map.put("order", order.trim());
		}
		
		List<AttitudeApplicationVO> attAppList = ezAttitudeDAO.getUsersModiyAtt(map); 
		
		LOGGER.debug("getUsersModiyAtt started");
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
	public int getUsersModiyAttCount(String companyId, int tenantId,
			String userId, String startDate, String endDate,
			String apprUserName, String writerName , String writerDeptName,String sysLang, String offset, String type, String adminFlag, String checkAdmin)
			throws Exception {
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		if (adminFlag == null) {
			adminFlag = "false";
		}
		
		if (checkAdmin == null) {
			checkAdmin = "false";
		}
		
		LOGGER.debug("checkAdmin : " + checkAdmin);
		LOGGER.debug("adminFlag : " + adminFlag);
		
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		if (!adminFlag.trim().equals("true")){
			map.put("userId", userId);
		} else if (checkAdmin.equals("false")) {
			LOGGER.debug("#############################################false true####################################");
			String[] deptIdList = {"approval"};
			map.put("deptIdList", deptIdList);
		}
		map.put("startDate", startDate);
		map.put("endDate", endDate);
		map.put("apprUserName", apprUserName);
		map.put("writerName", writerName);
		map.put("writerDeptName", writerDeptName);
		map.put("sysLang", sysLang);
		map.put("offset", offset);
		map.put("type", type);
		
		int attAppListCount = ezAttitudeDAO.getUsersModiyAttCount(map);
		
		return attAppListCount;
	}

	@Override
	public List<HolidayVO> getHolidayList(String companyId, int tenantId)
			throws Exception {
		LOGGER.debug("getHolidayList started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		List<HolidayVO> holidayList = ezAttitudeDAO.getHolidayList(map);
		
		LOGGER.debug("getHolidayList ended");
		return holidayList;
	}

	
	@Override
	public List<JournalAuthorVO> getDeptUserList(String tenantId, String key,
			String value) throws Exception {
		LOGGER.debug("getDeptUserList started");
		
		HashMap<String, String> map = new HashMap<String, String>();
		
		map.put("tenantId", tenantId);
		map.put("key", key);
		map.put("value", value);
		
		List<JournalAuthorVO> userList = ezAttitudeDAO.getDeptUserList(map);
		
		LOGGER.debug("getDeptUserList ended");
		return userList;
	}
	
	@Override
	public void delUsersModifyAtt(String companyId, int tenantId, String[] ids) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("ids", ids);
		map.put("delFlag", "1"); //0:삭제안함, 1:삭제
		map.put("modappl", "0");
		
		ezAttitudeDAO.delUsersModifyAtt(map);
		ezAttitudeDAO.attAppUpdate(map);
	}

	@Override
	public List<DeptViewVO> getDeptViewList(String userId, String companyId,
			String tenantId) throws Exception {
		LOGGER.debug("getDeptViewList started");
		
	    HashMap<String, String> map = new HashMap<String, String>();
	    
	    map.put("tenantId", tenantId);
	    map.put("userId", userId);
	    map.put("companyId", companyId);
	    
	    List<DeptViewVO> deptList = ezAttitudeDAO.getDeptViewList(map);
	    
	    LOGGER.debug("getDeptViewList ended");
	    return deptList;
	}

	@Override
	public void deleteAttitudeUserConfig(int tenantId, String selecUserList)
			throws Exception {
		LOGGER.debug("deleteAttitudeUserConfig started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("tenantId", tenantId);
		
		String[] userIdList = selecUserList.split(",");
		
		for (int i = 0; i < userIdList.length; i++) {
			
			LOGGER.debug("userId = " + userIdList[i]);
			
			map.put("userId", userIdList[i]);
			
			ezAttitudeDAO.deleteAttitudeUserConfig(map);
		}
		
		LOGGER.debug("deleteAttitudeUserConfig ended");
	}
	
	@Override
	public AttitudeApplicationVO attModAppDetail(String companyId,
			int tenantId, String userId, String attModId, String offset) throws Exception {
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("userId", userId);
		map.put("attModId", attModId);
		map.put("offset", offset);
		
		return ezAttitudeDAO.attModAppDetail(map);
	}

	@Override
	public void attModAppModify(String companyId,
			int tenantId, String userId, String attModId, String offset,
			String content, String changeDate) throws Exception {
			
		Map<String, Object> map = new HashMap<String, Object>();

		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("userId", userId);
		map.put("attModId", attModId);
		map.put("offset", offset);
		map.put("content", content);
		map.put("changeDate", changeDate);
		
		ezAttitudeDAO.attModAppModify(map);
	}
	
	@Override
	public void attSaveAppModify(String attitudeId, String companyId,
			int tenantId, String userId, String writerName, String writerName2, String writerTitle
			, String writerTitle2, String writerDeptId, String writerDeptName, String writerDeptName2
			,String changeDate, String delFlag, String content,String offset) throws Exception {
			
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
		map.put("delFlag", delFlag);
		map.put("content", content);
		map.put("apprStatus", "0");
		map.put("offset", offset);
		map.put("modappl", "1");
		
		ezAttitudeDAO.attSaveAppModify(map);
		ezAttitudeDAO.addUsersModifyAttHistoryFirst(map);
		ezAttitudeDAO.attAppUpdate(map);
	}

	@Override
	public List<AdminAttitudeVO> getAttitudeList2(String searchUserName, String searchDeptName, String searchTitle, String searchStartDate, String searchEndDate, String searchAttitudeType, String orderCell, String orderOption, String offset, String pageNum, String listSize, String companyId, int tenantId) throws Exception {
		LOGGER.debug("getAttitudeList2 started");
		
		String offsetMin = commonUtil.getMinuteUTC(offset);
		int limit = 0;
		
		if (pageNum != null && !pageNum.equals("")) {
			limit = (Integer.valueOf(pageNum) - 1) * Integer.valueOf(listSize);
		}
		
		//날짜
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Calendar cal = Calendar.getInstance();
		
		if (searchStartDate.equals("") && searchEndDate.equals("")) {
			String localDate = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), offset, false).substring(0, 10);
			
			searchStartDate = localDate + " 00:00:00";
			searchEndDate = localDate + " 23:59:59";
			
			Date startDate = sdf.parse(searchStartDate);
			
			cal = Calendar.getInstance();
			cal.setTime(startDate);
			cal.add(Calendar.DAY_OF_MONTH, -7);
			
			searchStartDate = commonUtil.getDateStringInUTC(sdf.format(cal.getTime()), offset, true);
			searchEndDate = commonUtil.getDateStringInUTC(searchEndDate, offset, true);
		} else {
			if (searchStartDate.equals("")) {
				searchStartDate = commonUtil.getDateStringInUTC(searchStartDate + " 00:00:00", offset, true);
			}
			
			if (searchEndDate.equals("")) {
				searchEndDate = commonUtil.getDateStringInUTC(searchEndDate + " 23:59:59", offset, true);
			}
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("searchUserName", searchUserName);
		map.put("searchDeptName", searchDeptName);
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
		map.put("limit", limit != 0 ? limit : null);

		List<AdminAttitudeVO> resultList = ezAttitudeDAO.getAttitudeList2(map);

		LOGGER.debug("getAttitudeList2 ended. resultList size = " + resultList.size());
		
		return resultList;
	}

	@Override
	public String getAttitudeCount2(String searchUserName, String searchDeptName, String searchTitle, String searchStartDate,
			String searchEndDate, String searchAttitudeType,String offset, String companyId, int tenantId) throws Exception {
		LOGGER.debug("getAttitudeCount2 started.");
		
		String offsetMin = commonUtil.getMinuteUTC(offset);
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Calendar cal = Calendar.getInstance();
		
		if (searchStartDate.equals("") && searchEndDate.equals("")) {
			String localDate = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), offset, false).substring(0, 10);
			
			searchStartDate = localDate + " 00:00:00";
			searchEndDate = localDate + " 23:59:59";
			
			Date startDate = sdf.parse(searchStartDate);
			
			cal = Calendar.getInstance();
			cal.setTime(startDate);
			cal.add(Calendar.DAY_OF_MONTH, -7);
			
			searchStartDate = commonUtil.getDateStringInUTC(sdf.format(cal.getTime()), offset, true);
			searchEndDate = commonUtil.getDateStringInUTC(searchEndDate, offset, true);
		} else {
			if (searchStartDate.equals("")) {
				searchStartDate = commonUtil.getDateStringInUTC(searchStartDate + " 00:00:00", offset, true);
			}
			
			if (searchEndDate.equals("")) {
				searchEndDate = commonUtil.getDateStringInUTC(searchEndDate + " 23:59:59", offset, true);
			}
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("searchUserName", searchUserName);
		map.put("searchDeptName", searchDeptName);
		map.put("searchTitle", searchTitle);
		map.put("searchAttitudeType", searchAttitudeType);
		map.put("searchStartDate", searchStartDate);
		map.put("searchEndDate", searchEndDate);
		map.put("offsetMin", offsetMin);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		String result = ezAttitudeDAO.getAttitudeCount2(map);
		
		LOGGER.debug("getAttitudeCount2 end. result = " + result);
		
		return result;
	}
	
	@Override
	public String getAttitudeAbsentCount(String searchUserName, String searchDeptName, String searchTitle, String searchStartDate, String searchEndDate, String offset, String companyId, int tenantId) throws Exception {
		LOGGER.debug("getAttitudeAbsentCount started.");
		
		String offsetMin = commonUtil.getMinuteUTC(offset);
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Calendar cal = Calendar.getInstance();
		
		if (searchStartDate.equals("") && searchEndDate.equals("")) {
			String localDate = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), offset, false).substring(0, 10);
			
			searchStartDate = localDate + " 00:00:00";
			searchEndDate = localDate + " 23:59:59";
			
			Date startDate = sdf.parse(searchStartDate);
			
			cal = Calendar.getInstance();
			cal.setTime(startDate);
			cal.add(Calendar.DAY_OF_MONTH, -7);
			
			searchStartDate = commonUtil.getDateStringInUTC(sdf.format(cal.getTime()), offset, true);
			searchEndDate = commonUtil.getDateStringInUTC(searchEndDate, offset, true);
		} else {
			if (searchStartDate.equals("")) {
				searchStartDate = commonUtil.getDateStringInUTC(searchStartDate + " 00:00:00", offset, true);
			}
			
			if (searchEndDate.equals("")) {
				searchEndDate = commonUtil.getDateStringInUTC(searchEndDate + " 23:59:59", offset, true);
			}
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("searchUserName", searchUserName);
		map.put("searchDeptName", searchDeptName);
		map.put("searchTitle", searchTitle);
		map.put("searchStartDate", searchStartDate);
		map.put("searchEndDate", searchEndDate);
		map.put("offsetMin", offsetMin);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		String result = ezAttitudeDAO.getAttitudeAbsentCount(map);
		
		LOGGER.debug("getAttitudeAbsentCount ended. result = " + result);
		
		return "";
	}
	
	@Override
	public List<AdminAttitudeVO> getAttitudeAbsentList(String searchUserName, String searchDeptName, String searchTitle, String searchStartDate, String searchEndDate, String orderCell, String orderOption, String offset, String pageNum, String listSize, String companyId, int tenantId) throws Exception {
		LOGGER.debug("getAttitudeAbsentList started.");
		
		String offsetMin = commonUtil.getMinuteUTC(offset);
		int limit = 0;
		
		if (pageNum != null && !pageNum.equals("")) {
			limit = (Integer.valueOf(pageNum) - 1) * Integer.valueOf(listSize);
		}
		
		//날짜
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Calendar cal = Calendar.getInstance();
		
		if (searchStartDate.equals("") && searchEndDate.equals("")) {
			String localDate = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), offset, false).substring(0, 10);
			
			searchStartDate = localDate + " 00:00:00";
			searchEndDate = localDate + " 23:59:59";
			
			Date startDate = sdf.parse(searchStartDate);
			
			cal = Calendar.getInstance();
			cal.setTime(startDate);
			cal.add(Calendar.DAY_OF_MONTH, -7);
			
			searchStartDate = commonUtil.getDateStringInUTC(sdf.format(cal.getTime()), offset, true);
			searchEndDate = commonUtil.getDateStringInUTC(searchEndDate, offset, true);
		} else {
			if (searchStartDate.equals("")) {
				searchStartDate = commonUtil.getDateStringInUTC(searchStartDate + " 00:00:00", offset, true);
			}
			
			if (searchEndDate.equals("")) {
				searchEndDate = commonUtil.getDateStringInUTC(searchEndDate + " 23:59:59", offset, true);
			}
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("searchUserName", searchUserName);
		map.put("searchDeptName", searchDeptName);
		map.put("searchTitle", searchTitle);
		map.put("searchStartDate", searchStartDate);
		map.put("searchEndDate", searchEndDate);
		map.put("orderCell", orderCell);
		map.put("orderOption", orderOption);
		map.put("listSize", listSize);
		map.put("offsetMin", offsetMin);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("limit", limit != 0 ? limit : null);

		List<AdminAttitudeVO> resultList = ezAttitudeDAO.getAttitudeAbsentList(map);
		
		LOGGER.debug("getAttitudeAbsentList ended.");
		
		return null;
	}

	@Override
	public void changeUsersModifyAtt(String companyId, int tenantId,
			String[] ids, String changeStatus, String userId, String userName, String userName2) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		map.put("ids", ids);
		map.put("changeStatus", changeStatus);
		map.put("apprDate",commonUtil.getTodayUTCTime(""));
		map.put("userId",userId);
		map.put("displayName",userName);
		map.put("displayName2",userName2);
		LOGGER.debug("############################commonUtil.getTodayUTCTime: "  + commonUtil.getTodayUTCTime("") + userName + userName2);
		//승인, 반려 기록
		ezAttitudeDAO.changeUsersModifyAtt(map);
		
		//사용자의 기존 지각 상태의 근태 수정
		ezAttitudeDAO.changeUsersAtt(map);
		
		//수정이 완료 되면 히스토리 기록
		ezAttitudeDAO.addUsersModifyAttHistory(map);
	}

	@Override
	public List<AttitudeAuthorVO> getAttitudeAuthList(int tenantId,
			String companyId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		
		return ezAttitudeDAO.getAttitudeAuthList(map);
	}

	@Override
	public void deleteAttitudeAuth(String selectUserId, int tenantId,
			String companyId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("selectUserId", selectUserId);
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		
		ezAttitudeDAO.deleteAttitudeAuth(map);
	}
	
	@Override
	public List<AttitudeApplicationVO> attModGetHistory(String companyId,
			int tenantId, String userId, String attModId, String offset)
			throws Exception {
		LOGGER.debug("attModGetHistory started");
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("userId", userId);
		map.put("attModId", attModId);
		map.put("offset", offset);
		
		List<AttitudeApplicationVO> attAppList = ezAttitudeDAO.attModGetHistory(map); 
		
		LOGGER.debug("attModGetHistory ended");
		return attAppList;
	}
	
	@Override
	public void saveAttitudeAuthDept(int tenantId, String companyId,
			String selectedUser, String deptIds) throws Exception {
		LOGGER.debug("saveAttitudeAuthDept started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyId", companyId);
		map.put("selectUserId", selectedUser);
		map.put("tenantId", tenantId);

		ezAttitudeDAO.deleteAttitudeAuth(map);

		String[] deptList = deptIds.split(",");

		for (int i = 0; i < deptList.length; i++) {
			map.put("deptId", deptList[i]);

			ezAttitudeDAO.insertAttitudeAuth(map);
		}

		LOGGER.debug("saveAttitudeAuthDept ended");
	}

	@Override
	public List<AttitudeAuthorVO> getAttitudeAuthDeptList(int tenantId,
			String userId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("userId", userId);
		map.put("tenantId", tenantId);
		
		return ezAttitudeDAO.getAttitudeAuthDeptList(map);
	}

	@Override
	public List<AttitudeStatisVO> getAttitudeUserStatistics(String userId,
			String offset, String startDate, String endDate, int tenantId)
			throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		String offsetMin = commonUtil.getMinuteUTC(offset);

		map.put("userId", userId);
		map.put("offsetMin", offsetMin);
		map.put("startDate", startDate);
		map.put("endDate", endDate);
		map.put("tenantId", tenantId);
		
		return ezAttitudeDAO.getAttitudeUserStatistics(map);
	}
}