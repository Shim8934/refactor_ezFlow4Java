package egovframework.ezEKP.ezAttitude.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.ezEKP.ezAttitude.dao.EzAttitudeDAO;
import egovframework.ezEKP.ezAttitude.service.EzAttitudeService;
import egovframework.ezEKP.ezAttitude.vo.AttitudeApplicationVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeConfigVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeDeptVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeTypeVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeUserConfigVO;
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
	public int insertAttitude(String writerId, String deptId, String startdate,
			String enddate, String starttime, String endtime, String region,
			String mobile, String bizsub, String content, String ip,
			String typeId, String companyId, int tenantId) throws Exception {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public List<Object> getAttitudeList(String pidList, String yrmh,
			String typeId, int tenantId) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<Object> getAttitudeStatisticsList(String pidList, String yrmh,
			int tenantId) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<AttitudeTypeVO> getAttitudeTypeList(String companyId,
			int tenantId) throws Exception {
		LOGGER.debug("getAttitudeTypeList started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		
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

	@Override
	public void updateAttitudeUserConfig(int tenantID, String userID,
			String workStartTime, String workEndTime) throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void insertAttitudeUserConfig(int tenantID, String companyID,
			String userID, String workStartTime, String workEndTime)
			throws Exception {
		// TODO Auto-generated method stub
		
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
	public void updateAttitudeTypeConfig(String typeId, String isUse,
			int tenantId, String companyId) throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void insertAttitudeType(String typeName, String typeName2,
			String imgPath, String formId, String parentId, int tenantId,
			String companyId) throws Exception {
		// TODO Auto-generated method stub
		
	}
	
	@Override
	public void insertAttitudeTypeIcon(String typeId, String fileName,
			String realPath, int tenantId) throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	public AttitudeTypeVO getAttitudeTypeInfo(int tenantId, String companyId,
			String typeId) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void updateAttitudeType(String typeName, String typeName2,
			String imgPath, int tenantId, String companyId) throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	public List<AttitudeUserConfigVO> getAttitudeUserConfigList(int tenantId,
			String companyId, String searchUserName, String searchDeptName, String pageNum, String listSize)
			throws Exception {
		LOGGER.debug("getAttitudeUserConfigList started");
		Map<String, Object> map = new HashMap<String, Object>();
		
		int limit = (Integer.valueOf(pageNum) - 1) * 10;
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		map.put("searchUserName", searchUserName);
		map.put("searchDeptName", searchDeptName);
		map.put("limit", limit);
		map.put("listSize", listSize);
		
		List<AttitudeUserConfigVO> resultList = ezAttitudeDAO.getAttitudeUserConfigList(map);
		LOGGER.debug("getAttitudeUserConfigList ended");
		return resultList;
	}

	@Override
	public AttitudeUserConfigVO getAttitudeUserConfigInfo(int tenantId,
			String companyId, String userId) throws Exception {
		// TODO Auto-generated method stub
		return null;
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
}
