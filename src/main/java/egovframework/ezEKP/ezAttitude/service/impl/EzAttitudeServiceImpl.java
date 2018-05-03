package egovframework.ezEKP.ezAttitude.service.impl;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
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
		
		content = content.replaceAll("\'", "&#39;").replaceAll("(\r\n|\r|\n|\n\r)", " ");
		
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
	public int delUsersModifyAtt(String companyId, int tenantId, String[] ids) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("ids", ids);
		map.put("modappl", "0");
		
		int data = 1;
		int modCnt = 0;
		
		for (int i = 0; i < ids.length; i++) {
			map.put("attModId", ids[i]);
			AttitudeApplicationVO aav = ezAttitudeDAO.attModAppDetail(map);
			if (!aav.getApprStatus().equals("0")) {
				data = 0;
				continue;
			} else {
				/*근태 수정신청 삭제.*/
				ezAttitudeDAO.delUsersModifyAtt(map);
				/*근태 수정신청이 삭제되고 원본 근태에 대해 수정신청 개수가 0개 일 때 원본 근태를 수정 가능한 상태로 변경.*/
				modCnt = ezAttitudeDAO.getAttsModAttCount(map);
				map.put("modCnt", modCnt);
				LOGGER.debug("!#!@#!#!@#!@#!@#@# : " + modCnt);
				if (modCnt == 0) {
					ezAttitudeDAO.resetAttModApp(map);
				}
			}
		}

		return data;
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
			int tenantId, String userId, String attModId, String offset, String applCnt) throws Exception {
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("userId", userId);
		map.put("attModId", attModId);
		map.put("offset", offset);
		map.put("applCnt", applCnt);
		
		return ezAttitudeDAO.attModAppDetail(map);
	}

	@Override
	public int attModAppModify(String companyId,
			int tenantId, String userId, String attModId, String offset,
			String content, String changeDate) throws Exception {
			
		content = content.replaceAll("\'", "&#39;").replaceAll("(\r\n|\r|\n|\n\r)", " ");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("userId", userId);
		map.put("attModId", attModId);
		map.put("offset", offset);
		map.put("content", content);
		map.put("changeDate", changeDate);
		
		AttitudeApplicationVO aav = ezAttitudeDAO.attModAppDetail(map);
		
		if (aav.getApprStatus().equals("0")) {
			return ezAttitudeDAO.attModAppModify(map);
		} else {
			return 0;
		}
	}
	
	@Override
	public void attSaveAppModify(String attitudeId, String companyId,
			int tenantId, String userId, String writerName, String writerName2, String writerTitle
			, String writerTitle2, String writerDeptId, String writerDeptName, String writerDeptName2
			,String changeDate, String delFlag, String content,String offset, String originDate) throws Exception {
			
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
		
		/*근태수정신청 저장*/
		ezAttitudeDAO.attSaveAppModify(map);
		/*근태수정신청이 된 항목 달력에 노란색 표시*/
		ezAttitudeDAO.setAttModApp(map);
	}

	@Override
	public List<AdminAttitudeVO> getAttitudeList2(String searchUserName, String searchDeptName, String searchTitle, String searchStartDate, String searchEndDate, String searchAttitudeType, String orderCell, String orderOption, String offset, String pageNum, String listSize, String companyId, int tenantId) throws Exception {
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

		List<AdminAttitudeVO> resultList = ezAttitudeDAO.getAttitudeList2(map);

		LOGGER.debug("getAttitudeList2 ended. resultList size = " + resultList.size());
		
		return resultList;
	}

	@Override
	public String getAttitudeCount2(String searchUserName, String searchDeptName, String searchTitle, String searchStartDate,
			String searchEndDate, String searchAttitudeType,String offset, String companyId, int tenantId) throws Exception {
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
		map.put("offsetMin", offsetMin);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		String result = ezAttitudeDAO.getAttitudeCount2(map);
		
		LOGGER.debug("getAttitudeCount2 end. result = " + result);
		
		return result;
	}
	
	@Override
	public List<AdminAttitudeVO> getAttitudeAbsentList(String searchUserName, String searchDeptName, String searchTitle, String searchStartDate, String searchEndDate, String orderCell, String orderOption, String offset, String companyId, int tenantId) throws Exception {
		LOGGER.debug("getAttitudeAbsentList started.");
		
		String offsetMin = commonUtil.getMinuteUTC(offset);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("searchUserName", searchUserName);
		map.put("searchDeptName", searchDeptName);
		map.put("searchTitle", searchTitle);
		map.put("offsetMin", offsetMin);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Calendar cal = Calendar.getInstance();
		
		Date startDate = sdf.parse(searchStartDate);
		cal.setTime(startDate);
		
		String tempDateTime = "";
		
		List<AdminAttitudeVO> totalList = new ArrayList<AdminAttitudeVO>();
		
		/* 2018-05-01 이효진 추후개선 미입력자이거말고 어떠케뽑는지 모르겟어서 */
		while (true) {
			tempDateTime = sdf.format(cal.getTime());
			
			map.put("searchStartDate", commonUtil.getDateStringInUTC(tempDateTime + " 00:00:00", offset, true));
			map.put("searchEndDate", commonUtil.getDateStringInUTC(tempDateTime + " 23:59:59", offset, true));
			
			List<AdminAttitudeVO> resultList = ezAttitudeDAO.getAttitudeAbsentList(map);
			
			LOGGER.debug("resultList size = " + resultList.size());
			
			totalList.addAll(resultList);
			cal.add(Calendar.DAY_OF_MONTH, 1);
			
			if (tempDateTime.equals(searchEndDate)) {
				break;
			}
		};
		
		LOGGER.debug("totalList size = " + totalList.size());
		
		HashSet<AdminAttitudeVO> listSet = new HashSet<AdminAttitudeVO>(totalList);
		totalList = new ArrayList<AdminAttitudeVO>(listSet);
		
		LOGGER.debug("distinct totalList size = " + totalList.size());
		
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
		default:
			break;
		}
		
		if (orderOption.equals("DESC")) {
			Collections.reverse(totalList);
		}
		
		LOGGER.debug("sorting ended.");
		
		LOGGER.debug("getAttitudeAbsentList ended. size = " + totalList.size());
		
		return totalList;
	}

	@Override
	public void changeUsersModifyAtt(String companyId, int tenantId,
			String ids, String changeStatus, String userId, String userName, String userName2, String offSet) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		String offsetMin = commonUtil.getMinuteUTC(offSet);
		
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		map.put("ids", ids.split("_")[0]);
		
		if (ids.split("_").length > 1) {
			map.put("applCnt", ids.split("_")[1]);
		}
		map.put("changeStatus", changeStatus);
		map.put("offsetMin", offsetMin);
		map.put("apprDate",commonUtil.getTodayUTCTime(""));
		map.put("userId",userId);
		map.put("displayName",userName);
		map.put("displayName2",userName2);
		
		String typeId = "A01";
		//승인, 반려 기록
		ezAttitudeDAO.changeUsersModifyAtt(map);
		
		//승인일 때 사용자의 기존 지각 상태의 근태 시간 상태 수정
		if(changeStatus.equals("appr")){
			ezAttitudeDAO.changeUsersAtt(map);

			//사용자의 기존 지각 상태의 근태 유형 수정
			AttitudeApplicationVO vo = ezAttitudeDAO.attDetail(map);
			String startDate = vo.getOriginDate();
			startDate = startDate.split(" ")[1];
	
			Map<String, Object> map1 = new HashMap<String, Object>();
			
	//		boolean isDefaultAtti = false;
			map1.put("writerId", vo.getWriterId());
			map1.put("companyId", companyId);
			map1.put("tenantId", tenantId);
			
			String isValue = ezAttitudeDAO.getIsAttitudeUserConf(map1);
			map1.put("isValue", isValue);
			
			AttitudeUserConfigVO resultVO = ezAttitudeDAO.getAttitudeConfTime(map1);
			String resultConfDate = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime("yyyy-MM-dd") + " " + resultVO.getWorkStartTime() + ":00", offSet, false).substring(11);
			
			LOGGER.debug("startDate : " + startDate);
			LOGGER.debug("resultConfDate : " + resultConfDate);
			
			SimpleDateFormat f = new SimpleDateFormat("HH:mm:ss");
			
			Date userConfTime = f.parse(resultConfDate);
			Date userInTime = f.parse(startDate);
			
			if (userInTime.after(userConfTime)) { //지각인 경우
				typeId = "A02";
			}
			
			map.put("typeId", typeId);
			ezAttitudeDAO.changeUsersAttType(map);
		}
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
			String userId, String isGAdmin) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("userId", userId);
		map.put("tenantId", tenantId);
		
		return ezAttitudeDAO.getAttitudeAuthDeptList(map);
	}

	@Override
	public List<AttitudeStatisVO> getAttitudeUserStatistics(String userId, String deptId,
			String offset, String year, String typeId, int tenantId)
			throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		String offsetMin = commonUtil.getMinuteUTC(offset);
		
		String startTime = "-01 00:00:00";
		
		map.put("userId", userId);
		map.put("deptId", deptId);
		map.put("offsetMin", offsetMin);
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
		
		return list;
	}
	
	
	
	
	
	/** 2018-05-02 미입력자 정렬*/
	class ascName implements Comparator<AdminAttitudeVO> {
		@Override
		public int compare(AdminAttitudeVO o1, AdminAttitudeVO o2) {
			return o1.getUserName().compareTo(o2.getUserName());
		}
	}
	
	class descName implements Comparator<AdminAttitudeVO> {
		@Override
		public int compare(AdminAttitudeVO o1, AdminAttitudeVO o2) {
			return o2.getUserName().compareTo(o1.getUserName());
		}
	}
	
	class ascTitle implements Comparator<AdminAttitudeVO> {
		@Override
		public int compare(AdminAttitudeVO o1, AdminAttitudeVO o2) {
			return o1.getUserTitle().compareTo(o2.getUserTitle());
		}
	}
	
	class descTitle implements Comparator<AdminAttitudeVO> {
		@Override
		public int compare(AdminAttitudeVO o1, AdminAttitudeVO o2) {
			return o2.getUserTitle().compareTo(o1.getUserTitle());
		}
	}
	
	class ascDeptName implements Comparator<AdminAttitudeVO> {
		@Override
		public int compare(AdminAttitudeVO o1, AdminAttitudeVO o2) {
			return o1.getDeptName().compareTo(o2.getDeptName());
		}
	}
	
	class descDeptName implements Comparator<AdminAttitudeVO> {
		@Override
		public int compare(AdminAttitudeVO o1, AdminAttitudeVO o2) {
			return o2.getDeptName().compareTo(o1.getDeptName());
		}
	}

	@Override
	public List<JournalAuthorVO> getCompanyDeptList(String userId,
			String companyId, int tenantId) {
		LOGGER.debug("getCompanyDeptList started");
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("userId", userId);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		LOGGER.debug("getCompanyDeptList ended");
		
		return ezAttitudeDAO.getCompanyDeptList(map);
		
	}
}