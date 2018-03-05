package egovframework.ezEKP.ezAttitude.service;

import java.util.List;
import java.util.Map;

import egovframework.ezEKP.ezAttitude.vo.AttitudeTypeVO;

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
	
	public void updateAttitudeApplication(String attitudeId, String changeDate, String changeTime, String content, String companyId, int tenantId) throws Exception;
	
	public void updateAttitudeApplicationApproval(String attitudeId, String apprUserId, String apprUserName, String apprUserName2, String apprStatus, 
			int tenantId) throws Exception;
	
	public void deptExcelDownload(String downMode, String pidList, int tenantId) throws Exception;
	
	//25번 리스트보기 출력
	public List<Map<String, String>> getDeptAttitudeList(String pidList, int tenantId) throws Exception;
	
	//조즥도
	
	//근태신청 등록
	//public void insertModifyAttitude(ModifyAttitudeVO modifyAttitudeInfo) throws Exception;
	
	//근태수정현황 리스트 출력 - 검색(승인자명, 기간), 정렬(전체, 진행, 승인, 반려)
	//public list<ModifyAttitudeVO> getUserModifyAttitudeList(String userID, int tenantID, String apprUserName, String startDate, String endDate, String statusType) throws Exception;
	
	//근태수정신청 상세보기 조회
	//public ModifyAttitudeVO getModifyAttitudeInfo(int tenantID, String companyID, String attitudeID)
	
	//근태수정신청 삭제
	//public void deleteModifyAttitude(String attitudeID, int tenantID) throws Exception;
	
	//근태수정신청 수정 - vo로 가져가도 괜찮으려나
	//public void updateModifyAttitude(ModifyAttitudeVO modifyAttitudeInfo) throws Exception;
	
	//근태신청관리현황 리스트 출력
	//public list<ModifyAttitudeVO> getModifyAttitudeList(int tenantID, String writeName, String apprUserName,String deptName, String startDate, String endDate, String statusType) throws Exception;
	
	//근태규율 정보 출력
	//public AttitudeConfigVO getAttitudeConfig(int tenantID, String companyID) throws Exception;
	
	//근태규율 정보 저장
	//public void updateAttitudeConfig(AttitudeConfigVO attitudeConfigInfo) throws Exception;
	
	//근태유형관리 리스트 출력
	//public List<map<String, String>> getAttitudeTypeList(int tenantID, String companyID) throws Exception;
	
	//근태유형관리 설정 저장(사용여부)
	//public void updateAttitudeTypeConfig(AttitudeTypeVO attitudeTypeInfo) throws Exception;
	
	//근태유형관리 유형추가
	//public void insertAttitudeType(AttitudeTypeVO attitudeTypeInfo) throws Exception;
	
	//근태유형관리 유형정보조회
	//public AttitudeTypeVO getAttitudeTypeInfo(int tenantID, String companyID, String typeID) throws Exception;
	
	//근태유형관리 유형수정
	//public void updateAttitudeType(AttitudeTypeVO attitudeTypeInfo) throws Exception;
}
