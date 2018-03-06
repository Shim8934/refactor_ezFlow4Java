package egovframework.ezEKP.ezAttitude.service;

import java.util.List;
import java.util.Map;

import egovframework.ezEKP.ezAttitude.vo.AttitudeApplicationVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeConfigVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeTypeVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeUserConfigVO;

public interface EzAttitudeService {
	public Object getAttitudeInfo(String userId, String date, String typeId, int tenantId) throws Exception;
	
	public int insertAttitude(String writerId, String deptId, String startdate, String enddate, String starttime, String endtime, String region,
			String mobile, String bizsub, String content, String ip, String typeId, String companyId, int tenantId) throws Exception;
	
	public List<Object> getAttitudeList(String pidList, String yrmh, String typeId, int tenantId) throws Exception;
	
	public List<Object> getAttitudeStatisticsList(String pidList, String yrmh, int tenantId) throws Exception;
	
	public List<AttitudeTypeVO> getAttitudeTypeList(String companyId, int tenantId) throws Exception;
	
	public String getWriteFormHtml(String formId, int tenantId) throws Exception;
	
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
	
	//조즥도
	
	public AttitudeApplicationVO getAttitudeApplicationInfo(int tenantId, String companyId, String attitudeId) throws Exception;
	
	public void deleteAttitudeApplication(String attitudeId, int tenantId) throws Exception;
	
	public List<AttitudeApplicationVO> getUserAttitudeApplicationList(String userId, int tenantId, String writeName, String apprUserName, String startDate, String endDate, String statusType) throws Exception;

	public List<AttitudeApplicationVO> getAttitudeApplicationList(int tenantId, String writeName, String apprUserName, String deptName, String startDate, String endDate, String statusType) throws Exception;
	
	public AttitudeConfigVO getAttitudeConfig(int tenantId, String companyId) throws Exception;
	
	public void updateAttitudeConfig(AttitudeConfigVO attitudeConfigInfo) throws Exception;
	
	public void updateAttitudeTypeConfig(String typeId, String isUse, int tenantId, String companyId) throws Exception;
	
	public void insertAttitudeType(String typeName, String typeName2, String imgPath, String formId, String parentId, int tenantId, String companyId) throws Exception;
	
	public AttitudeTypeVO getAttitudeTypeInfo(int tenantId, String companyId, String typeId) throws Exception;
	
	public void updateAttitudeType(String typeName, String typeName2, String imgPath, int tenantId, String companyId) throws Exception;
	
	public List<AttitudeUserConfigVO> getAttitudeUserConfigList(int tenantId, String companyId, String userName, String deptName) throws Exception;
	
	public AttitudeUserConfigVO getAttitudeUserConfigInfo(int tenantId, String companyId, String userId) throws Exception;
	
	public void updateAttitudeUserConfig(int tenantId, String userId, String workStartTime, String workEndTime) throws Exception;
	
	public void insertAttitudeUserConfig(int tenantId, String companyId, String userId, String workStartTime, String workEndTime) throws Exception;
	
}
