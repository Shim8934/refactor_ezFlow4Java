package egovframework.ezEKP.ezNotification.dao;

import java.util.List;
import java.util.Map;
import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezNotification.vo.EmergencyNotiItemVO;
import egovframework.ezEKP.ezNotification.vo.EmergencyNotiPermissionVO;
import egovframework.ezEKP.ezNotification.vo.NotiRecipientVO;
import egovframework.ezEKP.ezNotification.vo.NotificationVO;
import org.egovframe.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzNotificationDAO")
public class EzNotificationDAO extends EgovAbstractDAO {
	// 2024-03-28 한태훈 - 통합알림 > 사용자 알림 데이터 삽입
	public void insertUserNoti(Map<String, Object> map) throws Exception {
		insert("EzNotificationDAO.insertUserNoti", map);
	}
	
	// 2024-03-28 한태훈 - 통합알림 > 알림 총 개수 가져오기
	public int getTotalNotiListCnt(Map<String, Object> map) throws Exception {
		return (Integer) select("EzNotificationDAO.getTotalNotiListCnt", map);
	}
	
	// 2024-03-28 한태훈 - 통합알림 > 사용자 개별 알림 읽음 또는 삭제
	public void updateNoti(Map<String, Object> map) throws Exception {
		update("EzNotificationDAO.updateNoti", map);
	}

	// 2024-03-28 한태훈 - 통합알림 > 사용자 전체 알림 읽음 또는 삭제
	public void updateNotiAll(Map<String, Object> map) throws Exception {
		update("EzNotificationDAO.updateNotiAll", map);		
	}
	
	// 2024-03-28 한태훈 - 통합알림 > 알림 검색 리스트 총 개수 가져오기
	public int getTotalSearchNotiListCnt(Map<String, Object> map) throws Exception {
		return (Integer) select("EzNotificationDAO.getTotalSearchNotiListCnt", map);
	}
	
	// 2024-03-28 한태훈 - 통합알림 > 알림 검색 리스트 가져오기
	@SuppressWarnings("unchecked")
	public List<NotificationVO> getSearchNotiList(Map<String, Object> map) throws Exception {
		return (List<NotificationVO>) list("EzNotificationDAO.getSearchNotiList", map);
	}
	
	// 2024-03-28 한태훈 - 통합알림 > 모바일 알림 검색 리스트 가져오기
	@SuppressWarnings("unchecked")
	public List<NotificationVO> getSearchNotiListForMobile(Map<String, Object> map) throws Exception {
		return (List<NotificationVO>) list("EzNotificationDAO.getSearchNotiListForMobile", map);
	}
	
	// 2024-03-28 한태훈- 관리자 > 알림 > 보관설정 알림 기간 업데이트 
	public void updateStoragePeriod(Map<String, Object> map) throws Exception {
		update("EzNotificationAdminDAO.updateStoragePeriod", map);		
	}
	
	// 2024-03-28 한태훈 - 통합알림 > 보관기간 지난 알림 삭제
	public void deleteOldNotification(Map<String, Object> map) throws Exception {
		delete("EzNotificationAdminDAO.deleteOldNotification", map);		
	}
	
	// 2024-03-28 한태훈 - 통합알림 > 새 알림 개수 가져오기
	public int getNewNotiCnt(Map<String, Object> map) throws Exception {
		return (Integer) select("EzNotificationDAO.getNewNotiCnt", map);
	}
	
	public boolean isJavaApprovalUse(Map<String, Object> map) throws Exception {
		return (boolean) select("EzNotificationDAO.isJavaApprovalUse", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<EmergencyNotiPermissionVO> getEmergencyPermissionList(Map<String, Object> map) throws Exception {
		return (List<EmergencyNotiPermissionVO>) list("EzNotificationDAO.getEmergencyPermissionList", map);
	}

	public void addEmergencyPermission(Map<String, Object> map) throws Exception {
		insert("EzNotificationDAO.addEmergencyPermission", map);
	}
	
	public void updateEmergencyPermission(Map<String, Object> map) throws Exception {
		update("EzNotificationDAO.updateEmergencyPermission", map);
	}

	public void deleteEmergencyPermission(Map<String, Object> map) throws Exception {
		delete("EzNotificationDAO.deleteEmergencyPermission", map);
	}

	public String selectEmergencyPermission(Map<String, Object> map) throws Exception {
		return (String) select("EzNotificationDAO.selectEmergencyPermission", map);
	}

	public String getEmergencyContent(Map<String, Object> map) throws Exception {
		return (String) select("EzNotificationDAO.getEmergencyContent", map);
	}

	public void addEmergencyCompanyContent(Map<String, Object> map) throws Exception {
		insert("EzNotificationDAO.addEmergencyCompanyContent", map);
	}

	public boolean checkEmergencyPermission(Map<String, Object> map) throws Exception {
		return (boolean) select("EzNotificationDAO.checkEmergencyPermission", map);
	}

	public boolean checkEmergencyGroupPermission(Map<String, Object> map) throws Exception{
		return (boolean) select("EzNotificationDAO.checkEmergencyGroupPermission", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<NotiRecipientVO> getNotiRecipientByDeptId(Map<String, Object> map) throws Exception {
		return (List<NotiRecipientVO>) list("EzNotificationDAO.getNotiRecipientByDeptId", map);
	}

	public int addEmergencyNotiItem(Map<String, Object> map) throws Exception {
		return (int) insert("EzNotificationDAO.addEmergencyNotiItem", map);
	}

	public EmergencyNotiItemVO getEmergencyNotiItem(Map<String, Object> map) throws Exception {
		return (EmergencyNotiItemVO) select("EzNotificationDAO.getEmergencyNotiItem", map);
	}

	public void deleteEmergencyNoti(Map<String, Object> map) throws Exception {
		delete("EzNotificationDAO.deleteEmergencyNoti", map);
	}

	public String selecetCompanyIdByDeptId(Map<String, Object> map) throws Exception {
		return (String) select("EzNotificationDAO.selecetCompanyIdByDeptId", map);
	}

}
