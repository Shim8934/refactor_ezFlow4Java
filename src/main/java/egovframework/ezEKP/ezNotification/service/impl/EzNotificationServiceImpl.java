package egovframework.ezEKP.ezNotification.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringEscapeUtils;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezNotification.dao.EzNotificationDAO;
import egovframework.ezEKP.ezNotification.service.EzNotificationService;
import egovframework.ezEKP.ezNotification.vo.NotificationVO;
import egovframework.ezEKP.ezPersonal.service.EzPersonalService;
import egovframework.ezEKP.ezPersonal.type.NotiPlatform;
import egovframework.ezEKP.ezPersonal.type.NotiType;
import egovframework.let.utl.fcc.service.CommonUtil;

@Service("EzNotificationService")
public class EzNotificationServiceImpl implements EzNotificationService {
	@Resource(name = "EzNotificationDAO")
	private EzNotificationDAO ezNotificationDAO;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	 private static final Logger logger = LoggerFactory.getLogger(EzNotificationService.class);
	
	@Autowired
	private Properties config;
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private EzCommonService ezCommonService;
	
	@Autowired
	private EzPersonalService ezPersonalService;
	
	
	@Autowired
	private EzEmailService ezEmailService;
	
	// 2024-03-28 한태훈 - 통합알림 > 알림 데이터 삽입. 
	@Override
	public void addRealTimeNoti(String recipientId, String senderId, String senderName, String mainType, String subType, String notiContent, String regDate, String etcData, String linkUrl, String linkUrlMobile, String viewType, String viewWidth,	String viewHeight, int tenantId, String companyId) throws Exception {
		logger.debug("addRealTimeNoti started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("recipientId", recipientId);
		map.put("senderId", senderId);
		map.put("senderName", senderName);
		map.put("mainType", mainType);
		map.put("subType", subType);
		map.put("notiContent", notiContent);
		map.put("regDate", regDate);
		map.put("etcData", etcData);
		map.put("linkUrl", linkUrl);
		map.put("linkUrlMobile", linkUrlMobile);
		map.put("viewType", viewType);
		map.put("viewWidth", viewWidth == null || viewWidth == "" ? null : viewWidth);
		map.put("viewHeight", viewHeight == null || viewHeight == "" ? null : viewHeight);
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		ezNotificationDAO.insertUserNoti(map);
		
		logger.debug("addRealTimeNoti ended");
	}
	
	// 2024-03-28 한태훈 - 통합알림 > 알림 리스트 총 개수 가져오기.
	@Override
	public int getTotalNotiListCnt(String userId, String mode, String companyId, int tenantId) throws Exception {
		logger.debug("getTotalNotiListCnt started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("mode", mode);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		logger.debug("getTotalNotiListCnt ended");
		
		return ezNotificationDAO.getTotalNotiListCnt(map);
		
	}
	
	// 2024-03-28 한태훈 - 통합알림 > 사용자 개별 알림 읽음 또는 삭제.
	@Override
	public void updateNoti(String notiSeq, String mode, String processDate, String companyId, int tenantId) throws Exception {
		logger.debug("updateNoti started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("notiSeq", notiSeq);
		map.put("mode", mode.toUpperCase());
		map.put("processDate", processDate);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		ezNotificationDAO.updateNoti(map);
		
		logger.debug("updateNoti ended");
	}
	
	// 2024-03-28 한태훈 - 통합알림 > 사용자 전체 알림 읽음 또는 삭제.
	@Override
	public void updateNotiAll(String userId, String mode, String processDate, String companyId, int tenantId) throws Exception {
		logger.debug("updateNotiAll started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("mode", mode.toUpperCase());
		map.put("processDate", processDate);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		ezNotificationDAO.updateNotiAll(map);
		
		logger.debug("updateNotiAll ended");
	}
	
	// 2024-03-28 한태훈 - 통합알림 > 검색 알림 리스트 총 개수 가져오기.
	@Override
	public int getTotalSearchNotiListCnt(String userId, String mode, String isRead, String notiFilter, String keyWord, String companyId, int tenantId) throws Exception {
		logger.debug("getTotalSearchNotiListCnt started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("mode", mode);
		map.put("isRead", isRead);
		String[] notiFilterList = notiFilter.split("\\|"); 
		map.put("notiFilterList", notiFilterList);
		map.put("keyWord", keyWord);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		logger.debug("getTotalSearchNotiListCnt ended");
		
		return ezNotificationDAO.getTotalSearchNotiListCnt(map);
	}
	
	// 2024-03-28 한태훈 - 통합알림 > 검색 알림 리스트 가져오기.
	@Override
	public List<NotificationVO> getSearchNotiList(String userId, Integer lastNotiSeq, int rowCount, String isRead, String notiFilter, String keyWord, int tenantId, String companyId, String offSet) throws Exception {
		logger.debug("getSearchNotiList started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("lastNotiSeq", lastNotiSeq);
		map.put("rowCount", rowCount);
		map.put("isRead", isRead);
		String[] notiFilterList = notiFilter.split("\\|"); 
		map.put("notiFilterList", notiFilterList);
		map.put("keyWord", keyWord);
		map.put("offSet", offSet);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		List<NotificationVO> notiList =  ezNotificationDAO.getSearchNotiList(map);
		
		logger.debug("getSearchNotiList ended");
		
		return notiList;
	}
	
	// 2024-03-28 한태훈 - 통합알림 > 알림 전송
	@SuppressWarnings("unchecked")
	@Override
	public String sendNoti(HttpServletRequest request, String senderId, String senderName, String recipientIdList, String mainType, String subType, String notiContent, String viewType, String viewWidth, String viewHeight, String linkUrl, String linkUrlMobile, String etcData) throws Exception {
		logger.debug("sendNoti started");
		String status = "";
		
		String gwServerUrl = config.getProperty("config.notificationGWServerURL");
		String url = gwServerUrl + "/rest/ezNotification/notiSend/" + senderId;
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		headers.set("Content-type", "application/json;charset=UTF-8");
		
		JSONObject jsonParam = new JSONObject();
		jsonParam.put("senderName", senderName);
		jsonParam.put("recipientIdList", recipientIdList);
		jsonParam.put("mainType", mainType);
		jsonParam.put("subType", subType);
		jsonParam.put("notiContent", notiContent);
		jsonParam.put("viewType", viewType);
		jsonParam.put("viewWidth", viewWidth);
		jsonParam.put("viewHeight", viewHeight);
		jsonParam.put("linkUrl", linkUrl);
		jsonParam.put("linkUrlMobile", linkUrlMobile);
		jsonParam.put("etcData", etcData);
		
		HttpEntity<?> entity = new HttpEntity<>(jsonParam.toJSONString(), headers);
		RestTemplate rest = new RestTemplate();
		ResponseEntity<String> result = rest.postForEntity(url, entity, String.class);
		
		JSONParser jp = new JSONParser();
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		 resultBody.get("status").toString();
		
		logger.debug("sendNoti ended");
		
		return status;
	}
	
	@Override
	public void sendNoti(String senderId, String senderName, String recipientIdList, String mainType, String subType, String notiContent, String viewType, String viewWidth, String viewHeight, String linkUrl, String linkUrlMobile, String etcData, int tenantId, String companyId) throws Exception {
		String notiName = "";
		String resultStr = "";
		String regDate = commonUtil.getTodayUTCTime("yyyy-MM-dd HH:mm:ss");
		
		if (subType != null && !subType.equals("")) {
			notiName = mainType + "_" + subType;
		} else {
			notiName = mainType;
		}

		NotiType notiType = null;
		int mainTypeIntValue = -1;
		int subTypeIntValue = 0;
		if (!mainType.equals("ETC") && (etcData == null || etcData.indexOf("notChkSetting") < 0)) {
			notiType = NotiType.fromString(notiName);
			mainTypeIntValue = notiType.mainType();
			subTypeIntValue = subType != "" ? notiType.subType() : 0;
		}
		
		String[] recipientIdArr = recipientIdList.split(";;");
		
		String useEzTalkNotification = ezCommonService.getTenantConfig("useEzTalkNotification", tenantId);
		boolean useMobilePush = useEzTalkNotification.equals("YES") ? true : false;
		
		for (String recipientId : recipientIdArr) {
			try {
				logger.debug("recipientId : " + recipientId);
				
				String pushNotiContent = notiContent;
				resultStr += recipientId + ":";
				
				boolean useTotalNoti = false;
				
				if ((etcData != null && etcData.indexOf("notChkSetting") >= 0) || mainType.equals("ETC")) {
					useTotalNoti = true;
				} else {
					if (!ezPersonalService.hasNotiDiableItem(recipientId, notiType, NotiPlatform.TOTAL_NOTI, tenantId)) {
						useTotalNoti = true;
					}
					
					if (mainType.equals("APPROVAL")) { // 결재 모듈 사용 여부 조건 추가 필요. (우리 결재 모듈 사용시 에만 false)
						useMobilePush = false; // 결재는 푸시 알림 기능이 존재.
					}
				}
				
				if (useTotalNoti) {
					addRealTimeNoti(recipientId, senderId, senderName, mainType, subType, notiContent, regDate, etcData, linkUrl, linkUrlMobile, viewType, viewWidth, viewHeight, tenantId, companyId);
					resultStr += "{total:ok,";
				} else {
					resultStr += "{total:notUse,";
				}
				
				if (useMobilePush) {
					
					int tempMainTypeIntValue = mainTypeIntValue;
					
					boolean mobilePushSuccess = ezEmailService.addEzTalkNotification(recipientId, senderName, StringEscapeUtils.unescapeHtml4(pushNotiContent), tempMainTypeIntValue + "", subTypeIntValue + "", linkUrlMobile);
					
					if (mobilePushSuccess) {
						resultStr += "mobile:ok};";
					} else {
						resultStr += "mobile:fail or notUse};";
					}
					
				} else {
					resultStr += "mobile:notUse};";
				}
									
			} catch (Exception e) {
				logger.debug(e.getMessage());
				resultStr += "fail;";
				continue;
			}
		}
		
		logger.debug("realtime noti status : ok, {}", resultStr);
		
		logger.debug("sendNoti ended");
	}
	
	// 2024-03-28 한태훈 - 통합알림 > 모바일 리스트 가져오기
	@Override
	public List<NotificationVO> getSearchNotiListForMobile(String userId, int lastNotiSeq, int rowCount, String isRead, String notiFilter, String keyWord, int tenantId, String companyId, String offSet) throws Exception {
		logger.debug("getSearchNotiListForMobile started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("lastNotiSeq", lastNotiSeq);
		map.put("rowCount", rowCount);
		map.put("isRead", isRead);
		String[] notiFilterList = notiFilter.split("\\|"); 
		map.put("notiFilterList", notiFilterList);
		map.put("keyWord", keyWord);
		map.put("offSet", offSet);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		List<NotificationVO> notiList =  ezNotificationDAO.getSearchNotiListForMobile(map);
		
		logger.debug("getSearchNotiListForMobile ended");
		
		return notiList;
	}
	
	// 2024-03-28 한태훈 관리자 - 알림 > 보관설정 알림 기간 업데이트
	@Override
	public void updateStoragePeriod(String storagePeriod, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("storagePeriod", storagePeriod);
		map.put("tenantId", tenantId);
		ezNotificationDAO.updateStoragePeriod(map);
	}
	
	// 2024-03-28 한태훈 관리자 - 알림 > 보관기간 지난 알림 삭제
	@Override
	public void deleteOldNotification(String notiStoragePeriod, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		String nowDate = commonUtil.getTodayUTCTime("yyyy-MM-dd HH:mm:ss");
		map.put("nowDate", nowDate);
		map.put("notiStoragePeriod", notiStoragePeriod);
		map.put("tenantId", tenantId);
		map.put("offSet", 540); // 한국 서버 기준 기본값 540분 설정
		ezNotificationDAO.deleteOldNotification(map);
	}

	// 2024-03-28 한태훈 - 통합알림 > 새로운 알림 수신 확인 (polling 방식으로 실시간 알림 구현시 사용)
	@Override
	public int getNewNotiCnt(String userId, String pollStime, String pollEtime, String companyId, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("pollStime", pollStime);
		map.put("pollEtime", pollEtime);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		return ezNotificationDAO.getNewNotiCnt(map);
	}

	@Override
	public boolean isJavaApprovalUse(String companyId, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		return ezNotificationDAO.isJavaApprovalUse(map);
	}

}
