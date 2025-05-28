package egovframework.ezEKP.ezNotification.service;

import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;

import egovframework.ezEKP.ezNotification.vo.EmergencyNotiItemVO;
import egovframework.ezEKP.ezNotification.vo.EmergencyNotiPermissionVO;
import egovframework.ezEKP.ezNotification.vo.NotiRecipientVO;
import egovframework.ezEKP.ezNotification.vo.NotificationVO;

public interface EzNotificationService {
	// 2024-03-28 한태훈 - 통합알림 > 알림 데이터 삽입
	public void addRealTimeNoti(String recipientId, String senderId, String senderName, String mainType, String subType, String notiContent, String regDate, String etcData, String linkUrl, String linkUrlMobile, String viewType, String viewWidth, String viewHeight, int tenantId, String companyId) throws Exception;
	
	// 2024-03-28 한태훈 - 통합알림 > 알림 리스트 총 개수 가져오기
	public int getTotalNotiListCnt(String userId, String mode, String companyId, int tenantId) throws Exception;

	// 2024-03-28 한태훈 - 통합알림 > 사용자 개별 알림 읽음 또는 삭제
	public void updateNoti(String notiSeq, String mode, String processDate, String companyId, int tenantId) throws Exception;
	
	// 2024-03-28 한태훈 - 통합알림 > 사용자 전체 알림 읽음 또는 삭제
	public void updateNotiAll(String userId, String mode, String processDate, String companyId, int tenantId) throws Exception;
	
	// 2024-03-28 한태훈 - 통합알림 > 검색 알림 리스트 총 개수 가져오기
	public int getTotalSearchNotiListCnt(String userId, String mode, String isRead, String notiFilter, String keyWord, String companyId, int tenantId) throws Exception;
	
	// 2024-03-28 한태훈 - 통합알림 > 검색 알림 리스트 가져오기
	public List<NotificationVO> getSearchNotiList(String userId, Integer lastNotiSeq, int rowCount, String isRead, String notiFilter, String keyWord, int tenantId, String companyId, String offSet) throws Exception;
	
	// 2024-03-28 한태훈 - 통합알림 > 알림 전송
	public String sendNoti(HttpServletRequest request, String senderId, String senderName, List<Map<String, Object>> recipient, String mainType, String subType, String notiContent, String viewType, String viewWidth, String viewHeight, String linkUrl, String linkUrlMobile, String etcData) throws Exception;
	
	// 2024-05-13 한태훈 - 통합알림 > 알림 전송 (request 사용 못하는 경우 스케줄러 이용시)
	public String sendNoti(String senderId, String senderName, List<Map<String, Object>> recipient, String mainType, String subType, String notiContent, String viewType, String viewWidth, String viewHeight, String linkUrl, String linkUrlMobile, String etcData) throws Exception;
	
	// 2024-03-28 한태훈 - 통합알림 > 모바일 리스트 가져오기
	public List<NotificationVO> getSearchNotiListForMobile(String userId, Integer lastNotiSeq, int rowCount, String isRead, String notiFilter, String keyWord, int tenantId, String companyId, String offSet, String lang) throws Exception;

	// 2024-03-28 한태훈 관리자 - 알림 > 보관설정 알림 기간 업데이트 
	public void updateStoragePeriod(String storagePeriod, int tenantId) throws Exception;
	
	// 2024-03-28 한태훈 관리자 - 알림 > 보관기간 지난 알림 삭제 
	public void deleteOldNotification(String notiStoragePeriod, int tenantId) throws Exception;
	
	// 2024-03-28 한태훈 - 통합알림 > 새로운 알림 개수 확인
	public int getNewNotiCnt(String userId, String pollSTime, String pollETime, String companyId, int tenantId) throws Exception;

	public boolean isJavaApprovalUse(String companyId, int tenantId) throws Exception;

	public String getEmergencyPermissionList(String useLang, Locale locale, String companyId, int tenantId) throws Exception;

	public void addEmergencyPermission(List<EmergencyNotiPermissionVO> permissionList, int tenantId) throws Exception;

	public void deleteEmergencyPermission(List<EmergencyNotiPermissionVO> permissionList, String companyId, int tenantId) throws Exception;

	public String getEmergencyContent(String companyId, int tenantId) throws Exception;

	public void addEmergencyCompanyContent(String userId, String emergencyContent, String companyId, int tenantId) throws Exception;

	public String checkEmergencyPermission(String rollInfo, String userId, String deptId, String deptPath, String jobId, String roleId, String companyId, int tenantId) throws Exception;

	public Set<NotiRecipientVO> getNotiRecipientList(List<Map<String, Object>> recipient, int tenantId) throws Exception;

	public int addEmergencyNotiItem(String userId, String notiTitle, String notiBody, String companyId, int tenantId) throws Exception;

	public EmergencyNotiItemVO getEmergencyNotiItem(String emergencyItemId, String offSet, int tenantId) throws Exception;

	public void deleteEmergencyNoti(String notiId, int tenantId) throws Exception;

}
