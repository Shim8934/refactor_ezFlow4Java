package egovframework.ezEKP.ezAttitude.service.impl;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.bouncycastle.asn1.x509.qualified.TypeOfBiometricData;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ibm.icu.text.SimpleDateFormat;

import egovframework.ezEKP.ezAttitude.dao.EzAttitudeDAO;
import egovframework.ezEKP.ezAttitude.vo.DeptViewVO;
import egovframework.ezEKP.ezAttitude.service.EzAttitudeService;
import egovframework.ezEKP.ezAttitude.vo.AttitudeApplicationVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeConfigVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeDeptVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeFormVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeStatisVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeTypeVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeUserConfigVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeVO;
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
	public Object getAttitudeInfo(String userId, String date, String typeId,
			int tenantId) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void insertAttitude(String writerId, String deptId, String startDate,
			String endDate, String region, String mobile, String bizsub, String content,
			String ip, String typeId, String dateType, String companyId, int tenantId) throws Exception {
		LOGGER.debug("insertAttitude started");
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("writerId", writerId);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		if (typeId.equals("A01") || typeId.equals("A02")) {
			startDate = commonUtil.getTodayUTCTime("");
			
			if (typeId.equals("A01")) {
				//사용자별 근태설정이 있는 지 검사
				String isValue = ezAttitudeDAO.getIsAttitudeUserConf(map);
				map.put("isValue", isValue);
				
				AttitudeUserConfigVO resultVO = ezAttitudeDAO.getAttitudeConfTime(map);
				
				String compareDate = commonUtil.getTodayUTCTime("HH:mm");
				
				LOGGER.debug("isValue : " + isValue + "////////" + resultVO.getWorkStartTime());
				//시간을 비교해서 근태설정 시간보다 늦으면 지각 처리
				SimpleDateFormat f = new SimpleDateFormat("HH:mm");
				
				Date userConfTime = f.parse(resultVO.getWorkStartTime());
				Date userInTime = f.parse(compareDate);
				
				if (userInTime.after(userConfTime)) { //지각인 경우
					typeId = "A03";
				}
				
			}
		}
		
		map.put("deptId", deptId);
		map.put("startDate",  startDate);
		map.put("endDate", endDate);
		map.put("region", region);
		map.put("mobile", mobile);
		map.put("bizSub", bizsub);
		map.put("content", content);
		map.put("ipAddress", ip);
		map.put("typeId", typeId);
		map.put("dateType", dateType);
		
		ezAttitudeDAO.insertAttitude(map);
		LOGGER.debug("insertAttitude ended");
	}

	@Override
	public List<AttitudeVO> getAttitudeList(String pidList, String yrmh,
		String typeId, String startDate, String endDate, String offset, int tenantId) throws Exception {
		LOGGER.debug("getAttitudeList started");
		Map<String, Object> map = new HashMap<String,Object>();
		//if써서 하루꺼를 가져오려는 건지 한달꺼를 가져오려는 건지를 구분해야 될 꺼 같다.
		//일단 하루치를 가져오는 것 부터
		//true면 UTC false면 local
		String offsetMin = commonUtil.getMinuteUTC(offset);
		//startDate와 endDate가 없는 경우 당일의 근태를  출력
		LOGGER.debug("startDate : " + (startDate == null) + "startDate : " + (startDate.equals("")));
		if (startDate.equals("") && endDate.equals("")) {
			String localDate = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), offset, false).split(" ")[0];
			startDate = localDate + " 00:00:00";
			endDate = localDate + " 23:59:59";
		} else { //startDate와 endDate가 있는 경우 한달의 근태를 출력 
			startDate = startDate + " 00:00:00";
			endDate = endDate + " 23:59:59";
		}
		
		map.put("startDate", startDate);
		map.put("endDate", endDate);
		map.put("tenantId", tenantId);
		map.put("offsetMin", offsetMin);
		map.put("typeId", typeId);
		map.put("pidList", pidList);
		
		List<AttitudeVO> resultList = ezAttitudeDAO.getAttitudeList(map);
		
		LOGGER.debug("getAttitudeList ended");
		return resultList;
	}

	@Override
	public List<AttitudeStatisVO> getAttitudeStatisticsList(String pidList, String offset,
			String startDate, String endDate, int tenantId) throws Exception {
		LOGGER.debug("getAttitudeStatisticsList started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		String offsetMin = commonUtil.getMinuteUTC(offset);
		map.put("pidList", pidList);
		map.put("offsetMin", offsetMin);
		map.put("startDate", startDate);
		map.put("endDate", endDate);
		map.put("tenantId", tenantId);
		
		
		LOGGER.debug("getAttitudeStatisticsList ended");
		return ezAttitudeDAO.getAttitudeStatisList(map);
	}

	@Override
	public List<AttitudeTypeVO> getAttitudeTypeList(String companyId,
			String isuse, String isAdmin, int tenantId) throws Exception {
		LOGGER.debug("getAttitudeTypeList started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		map.put("isuse", isuse);
		map.put("isAdmin", isAdmin);
		
		LOGGER.debug("getAttitudeTypeList ended");
		
		return ezAttitudeDAO.getAttitudeTypeList(map);
	}

	@Override
	public String getWriteFormHtml(String formId, int tenantId)
			throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void updateAttitude(String attitudeId, String startdate,
			String enddate, String starttime, String endtime, String region,
			String mobile, String bizsub, String content, String ip,
			String typeId, String companyId, int tenantId) throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void deleteAttitude(String attitudeId, int tenantId)
			throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void insertAttitudeApplication(String attitudeId, String writerId,
			String writerName, String writerName2, String writerTitle,
			String writerTitle2, String writerDeptId, String writerDeptName,
			String writerDeptName2, String changeDate, String changeTime,
			String content, String companyId, int tenantId) throws Exception {
		// TODO Auto-generated method stub
		
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
	public void saveAttitudeUserConfig(int tenantId, String userConfInfoList, String offSet)
			throws Exception {
		LOGGER.debug("saveAttitudeUserConfig started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("tenantId", tenantId);
		
		String[] userConfList = userConfInfoList.split(";");
		
		for (int i = 0; i < userConfList.length; i++) {
			
			String[] userInfo = userConfList[i].split(",");
			
			LOGGER.debug("userId = " + userInfo[0]);
			
			map.put("userId", userInfo[0]);
			//시간셋팅
			String today =  commonUtil.getTodayUTCTime("yyyy-MM-dd");
			
			String startDate = commonUtil.getDateStringInUTC(today + " " + userInfo[1], offSet, true);
			String endDate = commonUtil.getDateStringInUTC(today + " " + userInfo[2], offSet, true);
			
			int startIdx = startDate.indexOf(" ");
			int endIdx = endDate.indexOf(" ");
			
			map.put("workStartTime", startDate.substring(startIdx + 1));
			map.put("workEndTime", endDate.substring(endIdx + 1));
			
			//insert & update
			ezAttitudeDAO.saveAttitudeUserConfig(map);
		}
				
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
			String imgPath, String formId, int tenantId,
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
//		map.put("typeName2", typeName2);
//		map.put("imgPath", imgPath);
		map.put("formId", formId);
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
	public List<AttitudeUserConfigVO> getAttitudeUserConfigList(int tenantId,
			String companyId, String searchUserName, String searchDeptName, String pageNum, 
			String listSize, String order, String offsetMin)
			throws Exception {
		LOGGER.debug("getAttitudeUserConfigList started");
		Map<String, Object> map = new HashMap<String, Object>();
		
		int limit = (Integer.valueOf(pageNum) - 1) * Integer.valueOf(listSize);
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		map.put("searchUserName", searchUserName);
		map.put("searchDeptName", searchDeptName);
		map.put("limit", limit);
		map.put("listSize", listSize);
		map.put("order", order.trim());
		map.put("offsetMin", offsetMin);
		
		List<AttitudeUserConfigVO> resultList = ezAttitudeDAO.getAttitudeUserConfigList(map);
		LOGGER.debug("getAttitudeUserConfigList ended");
		return resultList;
	}

	@Override
	public List<AttitudeUserConfigVO> getAttitudeUserConfigInfo(int tenantId,
			String companyId, String userId, String offsetMin) throws Exception {
		LOGGER.debug("getAttitudeUserConfigInfo started");
		
		List<AttitudeUserConfigVO> userList = new ArrayList<AttitudeUserConfigVO>();
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		map.put("offsetMin", offsetMin);
		
		String[] userIdList = userId.split(","); 
		
		for (int i = 0; i < userIdList.length; i++) {
			map.put("userId", userIdList[i]);
			
			AttitudeUserConfigVO vo = new AttitudeUserConfigVO();
			vo = ezAttitudeDAO.getAttitudeUserConfigInfo(map);
			if (vo != null) {
				userList.add(vo);
			}
		}
		LOGGER.debug("getAttitudeUserConfigInfo ended");
		return userList;
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
	public String getAttitudeUserConfigCount(int tenantId,
			String companyId, String searchUserName, String searchDeptName)
			throws Exception {
		LOGGER.debug("getAttitudeUserConfigListCount started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		map.put("searchUserName", searchUserName);
		map.put("searchDeptName", searchDeptName);
		
		String totalCount = ezAttitudeDAO.getAttitudeUserConfigCount(map);
		
		LOGGER.debug("getAttitudeUserConfigListCount ended");
		return totalCount;
	}

	@Override
	public List<AttitudeApplicationVO> getUsersModiyAtt(String companyId, int tenantId,
			String userId, String startDate, String endDate, String apprUserName, String sysLang, String offset,String startPoint, String endPoint, String type) throws Exception {
		LOGGER.debug("getUsersModiyAtt started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("userId", userId);
		map.put("startDate", startDate);
		map.put("endDate", endDate);
		map.put("apprUserName", apprUserName);
		map.put("sysLang", sysLang);
		map.put("offset", offset);
		map.put("startPoint", startPoint);
		map.put("endPoint", endPoint);
		map.put("type", type);
		
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
			String apprUserName, String sysLang, String offset, String type)
			throws Exception {
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("userId", userId);
		map.put("startDate", startDate);
		map.put("endDate", endDate);
		map.put("apprUserName", apprUserName);
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
		
		ezAttitudeDAO.delUsersModifyAtt(map);
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
}
