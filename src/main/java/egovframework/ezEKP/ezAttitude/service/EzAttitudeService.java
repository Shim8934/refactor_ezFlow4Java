package egovframework.ezEKP.ezAttitude.service;

public interface EzAttitudeService {
	
	//근태신청 등록
	
	//근태수정현황 리스트 출력 - 검색(승인자명, 기간), 정렬(전체, 진행, 승인, 반려)
	//public list<근태수정VO> getUserModifyAttitudeList(String userID, int tenantID, String apprUserName, String startDate, String endDate, String statusType) throws Exception;	
	//근태수정신청 상세보기 조회
	//public 근태수정VO getModifyAttitudeInfo(int tenantID, String companyID, String attitudeID)
	//근태수정신청 삭제
	//public void deleteModifyAttitude(String attitudeID, int tenantID) throws Exception;	
	//근태수정신청 수정 - vo로 가져가도 괜찮으려나
	//public void updateModifyAttitude(근태수정VO 근태수정Info) throws Exception;
	//근태신청관리현황 리스트 출력
	//public list<근태수정VO> getModifyAttitudeList(int tenantID, String writeName, String apprUserName,String deptName, String startDate, String endDate, String statusType) throws Exception;
	//근태규율 정보 출력
	//public attitudeConfigVO getAttitudeConfig(int tenantID, String companyID) throws Exception;
	//근태규율 정보 저장
	//public void updateAttitudeConfig(attitudeConfigVO attitudeConfigInfo) throws Exception;
	//근태유형관리 리스트 출력
	//public list<map<String, String>> getAttitudeTypeList(int tenantID, String companyID) throws Exception;
	//근태유형관리 설정 저장(사용여부)
	//public void updateAttitudeType(attitudeTypeVO attitudeTypeInfo) throws Exception;
	//근태유형관리 유형추가
	//public void insertAttitudeType(attitudeTypeVO attitudeTypeInfo) throws Exception;
	//근태유형관리 유형정보조회
	//public attitudeTypeVO getAttitudeTypeInfo(int tenantID, String companyID, String typeID) throws Exception;
	//근태유형관리 유형수정
	
}
