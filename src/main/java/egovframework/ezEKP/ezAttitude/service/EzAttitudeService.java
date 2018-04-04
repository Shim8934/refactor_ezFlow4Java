package egovframework.ezEKP.ezAttitude.service;

import java.util.List;
import java.util.Map;

import org.json.simple.JSONObject;

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
import egovframework.ezEKP.ezAttitude.vo.DeptViewVO;

public interface EzAttitudeService {
	public Object getAttitudeInfo(String userId, String date, String typeId, int tenantId) throws Exception;
	
	public void insertAttitude(String writerId, String deptId, String startDate, String endDate, String region,
			String mobile, String bizSub, String content, String ip, String typeId, String dateType, String companyId, int tenantId) throws Exception;
	
	public List<AttitudeVO> getAttitudeList(String pidList, String yrmh, String typeId, String startDate, String endDate, String offset, int tenantId) throws Exception;
	
	public List<AttitudeStatisVO> getAttitudeStatisticsList(String pidList, String offset, String startDate, String endDate, int tenantId) throws Exception;
	
	public List<AttitudeTypeVO> getAttitudeTypeList(String companyId, String isuse, String isAdmin, int tenantId) throws Exception;
	
	public String getFormBody(String typeId, int tenantId) throws Exception;
	
	public void updateAttitude(String attitudeId, String startdate, String enddate, String starttime, String endtime, String region,
			String mobile, String bizsub, String content, String ip, String typeId, String companyId, int tenantId) throws Exception;
	
	public void deleteAttitude(String attitudeId, int tenantId) throws Exception;
	
	//메일로 발송하는 부분.... 전자결재 부분보고 알아보자 AND 상세부분
	
	public void insertAttitudeApplication(String attitudeId, String writerId, String writerName, String writerName2, String writerTitle,
			String writerTitle2, String writerDeptId, String writerDeptName, String writerDeptName2, String changeDate, String changeTime,
			String content, String companyId, int tenantId) throws Exception;
	
	public String getAttitudeApplStatus(String attitudeId, int tenantId) throws Exception;
	
	public void updateAttitudeApplication(String attitudeId, String changeTime, String content, String companyId, int tenantId) throws Exception;
	
	public void updateAttitudeApplicationApproval(String attitudeId, String apprUserId, String apprUserName, String apprUserName2, String apprStatus, 
			int tenantId) throws Exception;
	
	public void deptExcelDownload(String downMode, String pidList, int tenantId) throws Exception;
	
	public List<Map<String, String>> getDeptAttitudeList(String pidList, int tenantId) throws Exception;
	
	public AttitudeApplicationVO getAttitudeApplicationInfo(int tenantId, String companyId, String attitudeId) throws Exception;
	
	public void deleteAttitudeApplication(String attitudeId, int tenantId) throws Exception;
	
	public List<AttitudeApplicationVO> getUserAttitudeApplicationList(String userId, int tenantId, String writeName, String apprUserName, String startDate, String endDate, String statusType) throws Exception;

	public List<AttitudeApplicationVO> getAttitudeApplicationList(int tenantId, String writeName, String apprUserName, String deptName, String startDate, String endDate, String statusType) throws Exception;
	
	public AttitudeConfigVO getAttitudeConfig(int tenantId, String companyId) throws Exception;
	
	public void updateAttitudeConfig(JSONObject jsonParam) throws Exception;
	
	public void updateAttitudeTypeConfig(String typeConfigList, String companyId, int tenantId) throws Exception;
	
	public void insertAttitudeType(String typeId, String typeName, String typeName2, String imgPath, String formId, int tenantId, String companyId) throws Exception;
	
	public void insertAttitudeTypeIcon(String typeId, String fileName, String realPath, int tenantId) throws Exception;
	
	public AttitudeTypeVO getAttitudeTypeInfo(int tenantId, String companyId, String typeId) throws Exception;
	
	public void updateAttitudeType(String typeId, String typeName, String typeName2, String imgPath, int tenantId, String companyId) throws Exception;
	
	public List<AttitudeUserConfigVO> getAttitudeUserConfigList(int tenantId, String companyId, String searchUserName, String searchDeptName, String pageNum, String listSize, String order, String offsetMin) throws Exception;
	
	public List<AttitudeUserConfigVO> getAttitudeUserConfigInfo(int tenantId, String companyId, String userId, String offsetMin) throws Exception;
	
//	public void updateAttitudeUserConfig(int tenantId, String userId, String workStartTime, String workEndTime) throws Exception;
	
//	public void insertAttitudeUserConfig(int tenantId, String companyId, String userId, String workStartTime, String workEndTime) throws Exception;
	
	public void saveAttitudeUserConfig(int tenantId, String userConfInfoList, String offSet) throws Exception;
	
	public List<AttitudeDeptVO> getCompanyList(String lang, int tenantId) throws Exception;
	
	public String getAttitudeUserConfigCount(int tenantId, String companyId, String searchUserName, String searchDeptName) throws Exception;
	
	public List<AttitudeApplicationVO> getUsersModiyAtt(String companyId, int tenantId, String userId, String startDate, String endDate, String apprUserName, String sysLang, String offSet, String startPoint, String endPoint, String type) throws Exception;

	public String getAttitudeTypeMaxTypeId(String companyId, int tenantId) throws Exception;

	public List<AttitudeFormVO> getAttitudeFormList(int tenantId) throws Exception;

	public int getUsersModiyAttCount(String companyId, int tenantId, String userId, String startDate, String endDate, String apprUserName, String sysLang, String offSet, String type) throws Exception;
	
	public List<HolidayVO> getHolidayList(String companyId, int tenantId) throws Exception;

	public List<JournalAuthorVO> getDeptUserList(String tenantId, String key,	String value) throws Exception;

	public void delUsersModifyAtt(String companyId, int tenantId, String[] ids) throws Exception;

	public List<DeptViewVO> getDeptViewList(String userId, String companyId, String tenantId) throws Exception;

	public void deleteAttitudeUserConfig(int tenantId, String selecUserList) throws Exception;
	
	public AttitudeApplicationVO attModAppDetail(String companyId, int tenantId, String userId, String attModId, String offset) throws Exception;
}
