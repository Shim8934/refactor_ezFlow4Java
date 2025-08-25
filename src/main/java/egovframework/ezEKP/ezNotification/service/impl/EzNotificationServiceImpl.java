package egovframework.ezEKP.ezNotification.service.impl;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;
import java.util.Set;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
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
import egovframework.ezEKP.ezNotification.dao.EzNotificationDAO;
import egovframework.ezEKP.ezNotification.service.EzNotificationService;
import egovframework.ezEKP.ezNotification.vo.EmergencyNotiItemVO;
import egovframework.ezEKP.ezNotification.vo.EmergencyNotiPermissionVO;
import egovframework.ezEKP.ezNotification.vo.NotiRecipientVO;
import egovframework.ezEKP.ezNotification.vo.NotificationVO;
import egovframework.ezEKP.ezOrgan.vo.OrganAuth;
import egovframework.ezEKP.ezOrgan.vo.OrganAuth.AdminAuth;
import egovframework.let.utl.fcc.service.CommonUtil;

@Service("EzNotificationService")
public class EzNotificationServiceImpl extends EgovAbstractServiceImpl implements EzNotificationService {
	@Resource(name = "EzNotificationDAO")
	private EzNotificationDAO ezNotificationDAO;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	 private static final Logger logger = LoggerFactory.getLogger(EzNotificationService.class);
	
	@Autowired
	private Properties config;
	
	@Autowired
	private CommonUtil commonUtil;
	
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
	public String sendNoti(HttpServletRequest request, String senderId, String senderName, List<Map<String, Object>> recipient, String mainType, String subType, String notiContent, String viewType, String viewWidth, String viewHeight, String linkUrl, String linkUrlMobile, String etcData) throws Exception {
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
		jsonParam.put("recipient", recipient);
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
	
	@SuppressWarnings("unchecked")
	@Override
	public String sendNoti(String senderId, String senderName, List<Map<String, Object>> recipient, String mainType, String subType, String notiContent, String viewType, String viewWidth, String viewHeight, String linkUrl, String linkUrlMobile, String etcData) throws Exception {
		JSONObject jsonParam = new JSONObject();
		jsonParam.put("senderName", senderName);
		jsonParam.put("recipient", recipient);
		jsonParam.put("mainType", mainType);
		jsonParam.put("subType", subType);
		jsonParam.put("notiContent", notiContent);
		jsonParam.put("viewType", viewType);
		jsonParam.put("viewWidth", viewWidth);
		jsonParam.put("viewHeight", viewHeight);
		jsonParam.put("linkUrl", linkUrl);
		jsonParam.put("linkUrlMobile", linkUrlMobile);
		jsonParam.put("etcData", etcData);
		
		String jsonParamString = jsonParam.toString();
		HttpURLConnection connection = null;
		String result = "";
		try {
		    URL url = new URL(config.getProperty("config.notificationGWServerURL") + "/rest/ezNotification/notiSend/" + senderId);
		    connection = (HttpURLConnection) url.openConnection();
		    
		    connection.setRequestMethod("POST");
		    
		    connection.setRequestProperty("Content-Type", "application/json; utf-8");
	        connection.setRequestProperty("Accept", "application/json");
	        connection.setRequestProperty("x-user-host", url.getHost()); // 어차피 127.0.0.1이나 localhost라서 그냥 사용..
	        connection.setDoOutput(true);
	        
	        try (OutputStream os = connection.getOutputStream()) {
	            byte[] input = jsonParamString.getBytes("utf-8");
	            os.write(input, 0, input.length);
	        }
	        
	        try (BufferedReader br = new BufferedReader(new InputStreamReader(connection.getInputStream(), "utf-8"))) {
	            StringBuilder response = new StringBuilder();
	            String line;
	            while ((line = br.readLine()) != null) {
	                response.append(line.trim());
	            }
	            
	            JSONParser jp = new JSONParser();
	            JSONObject resultBody = (JSONObject) jp.parse(response.toString());
	    		result = resultBody.get("status").toString();
	    		
	            //int responseCode = connection.getResponseCode();
	        }
		} catch(Exception e) {
			logger.error(e.getMessage(), e);
			throw e;
		} finally {
			if (connection != null) {
                connection.disconnect(); // 연결 종료
            }
		}
		
		return result;
	}
	
	// 2024-03-28 한태훈 - 통합알림 > 모바일 리스트 가져오기
	@Override
	public List<NotificationVO> getSearchNotiListForMobile(String userId, Integer lastNotiSeq, int rowCount, String isRead, String notiFilter, String keyWord, int tenantId, String companyId, String offSet, String lang) throws Exception {
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
		map.put("lang", lang);
		
		List<NotificationVO> notiList =  ezNotificationDAO.getSearchNotiListForMobile(map);
		
		logger.debug("getSearchNotiListForMobile ended");
		
		return notiList;
	}
	
	// 2024-03-28 한태훈 관리자 - 알림 > 보관설정 알림 기간 업데이트
	@Override
	public void updateStoragePeriod(String storagePeriod, int tenantId) throws Exception {
		logger.debug("updateStoragePeriod started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("storagePeriod", storagePeriod);
		map.put("tenantId", tenantId);
		ezNotificationDAO.updateStoragePeriod(map);
		
		logger.debug("updateStoragePeriod ended");
	}
	
	// 2024-03-28 한태훈 관리자 - 알림 > 보관기간 지난 알림 삭제
	@Override
	public void deleteOldNotification(String notiStoragePeriod, int tenantId) throws Exception {
		logger.debug("deleteOldNotification started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		String nowDate = commonUtil.getTodayUTCTime("yyyy-MM-dd HH:mm:ss");
		map.put("nowDate", nowDate);
		map.put("notiStoragePeriod", notiStoragePeriod);
		map.put("tenantId", tenantId);
		map.put("offSet", 540); // 한국 서버 기준 기본값 540분 설정
		ezNotificationDAO.deleteOldNotification(map);
		
		logger.debug("deleteOldNotification ended");
	}

	// 2024-03-28 한태훈 - 통합알림 > 새로운 알림 수신 확인 (polling 방식으로 실시간 알림 구현시 사용)
	@Override
	public int getNewNotiCnt(String userId, String pollStime, String pollEtime, String companyId, int tenantId) throws Exception {
		logger.debug("getNewNotiCnt started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("pollStime", pollStime);
		map.put("pollEtime", pollEtime);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		logger.debug("getNewNotiCnt ended");
		return ezNotificationDAO.getNewNotiCnt(map);
	}

	@Override
	public boolean isJavaApprovalUse(String companyId, int tenantId) throws Exception {
		logger.debug("isJavaApprovalUse started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		logger.debug("isJavaApprovalUse ended");
		return ezNotificationDAO.isJavaApprovalUse(map);
	}

	@Override
	public String getEmergencyPermissionList(String useLang, Locale locale, String companyId, int tenantId) throws Exception {
		logger.debug("getEmergencyPermissionList started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		List<EmergencyNotiPermissionVO> permissionList = ezNotificationDAO.getEmergencyPermissionList(map);
		
		StringBuilder result = new StringBuilder("<LISTVIEWDATA>");
		result.append("<ROWS>");
        
        for (int i = 0; i < permissionList.size(); i++) {
        	EmergencyNotiPermissionVO vo = permissionList.get(i);
        	result.append("<ROW>");
        	result.append("<CELL>");
        	String gubun = "";
    		switch (vo.getUserType()) {
			case "PERSON":
				gubun = egovMessageSource.getMessage("ezNotification.hth91", locale);
				break;
			case "DEPT":
				if (vo.getSubDeptYn().equals("Y")) {
					gubun = egovMessageSource.getMessage("ezNotification.hth92", locale);
				} else {
					gubun = egovMessageSource.getMessage("ezNotification.hth93", locale);
				}
				break;
			case "JIKWI":
				gubun = egovMessageSource.getMessage("ezNotification.hth94", locale);
				break;
			case "JIKCHEK":
				gubun = egovMessageSource.getMessage("ezNotification.hth95", locale);
				break;
			case "GROUP":
				gubun = egovMessageSource.getMessage("ezNotification.hth96", locale);
				break;
			}
        	result.append("<VALUE>" + gubun + "</VALUE>");
        	result.append("<DATA1>" + commonUtil.cleanValue(vo.getPermissionCode()) + "</DATA1>");
        	result.append("<DATA2>" + commonUtil.cleanValue(vo.getCn()) + "</DATA2>");
            result.append("<DATA3>" + commonUtil.cleanValue(vo.getUserType()) + "</DATA3>");
           	result.append("<DATA4>" + commonUtil.cleanValue(vo.getDeptId()) + "</DATA4>");
            result.append("<DATA5>" + commonUtil.cleanValue(vo.getJobId()) + "</DATA5>");
            result.append("<DATA6>" + commonUtil.cleanValue(vo.getRoleId()) + "</DATA6>");
            result.append("<DATA7>" + commonUtil.cleanValue(vo.getSubDeptYn()) + "</DATA7>");
        	result.append("</CELL>");
        	result.append("<CELL>");
        	if (useLang.equals("1")) {
        		result.append("<VALUE>" + commonUtil.cleanValue(vo.getDisplayName()) + "</VALUE>");
        	} else {
        		result.append("<VALUE>" + commonUtil.cleanValue(vo.getDisplayName2()) + "</VALUE>");
        	}
            result.append("</CELL>");
            result.append("<CELL>");
            if (useLang.equals("1")) {
            	result.append("<VALUE>" + commonUtil.cleanValue(vo.getDeptName()) + "</VALUE>");
            } else {
            	result.append("<VALUE>" + commonUtil.cleanValue(vo.getDeptName2()) + "</VALUE>");
            }
            result.append("</CELL>");
            result.append("<CELL>");
            if (useLang.equals("1")) {
            	result.append("<VALUE>" + commonUtil.cleanValue(vo.getTitle()) + "</VALUE>");
            } else {
            	result.append("<VALUE>" + commonUtil.cleanValue(vo.getTitle2()) + "</VALUE>");
            }
            result.append("</CELL>");
            result.append("<CELL>");
            if (useLang.equals("1")) {
            	result.append("<VALUE>" + commonUtil.cleanValue(vo.getRoleName()) + "</VALUE>");
            } else {
            	result.append("<VALUE>" + commonUtil.cleanValue(vo.getRoleName2()) + "</VALUE>");
            }
            result.append("</CELL>");
           
            result.append("</ROW>");
        }
        result.append("</ROWS>");
        result.append("</LISTVIEWDATA>");
        
        logger.debug("getEmergencyPermissionList ended");
		return result.toString();
	}

	@Override
	public void addEmergencyPermission(List<EmergencyNotiPermissionVO> permissionList, int tenantId) throws Exception {
		logger.debug("addEmergencyPermission started");
		
		for (int i = 0; i < permissionList.size(); i ++) {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("tenantId", tenantId);
			map.put("cn", permissionList.get(i).getCn());
			map.put("userType", permissionList.get(i).getUserType());
			map.put("deptId", permissionList.get(i).getDeptId());
			map.put("jobId", permissionList.get(i).getJobId());
			map.put("roleId", permissionList.get(i).getRoleId());
			map.put("subDeptYn", permissionList.get(i).getSubDeptYn());
			String companyId = permissionList.get(i).getCompanyId();
			if (permissionList.get(i).getUserType().equals("DEPT")) {
				companyId = ezNotificationDAO.selecetCompanyIdByDeptId(map);
			}
			
			map.put("companyId", companyId);
			map.put("nowDate", commonUtil.getTodayUTCTime("yyyy-MM-dd HH:mm:ss"));
			String permissionCode = ezNotificationDAO.selectEmergencyPermission(map);
			if (permissionCode == null) {
				ezNotificationDAO.addEmergencyPermission(map);
			} else {
				map.put("permissionCode", permissionCode);
				ezNotificationDAO.updateEmergencyPermission(map);
			}
		}
		
		logger.debug("addEmergencyPermission ended");
	}

	@Override
	public void deleteEmergencyPermission(List<EmergencyNotiPermissionVO> permissionList, String companyId, int tenantId) throws Exception {
		logger.debug("deletePermission started");
		
		for (int i = 0; i < permissionList.size(); i ++) {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("companyId", companyId);
			map.put("tenantId", tenantId);
			map.put("permissionCode", permissionList.get(i).getPermissionCode());
			ezNotificationDAO.deleteEmergencyPermission(map);
		}
		
		logger.debug("deletePermission ended");
	}

	@Override
	public String getEmergencyContent(String companyId, int tenantId) throws Exception {
		logger.debug("getEmergencyContent started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		logger.debug("getEmergencyContent ended");
		return ezNotificationDAO.getEmergencyContent(map);
	}

	@Override
	public void addEmergencyCompanyContent(String userId, String emergencyContent, String companyId, int tenantId) throws Exception {
		logger.debug("addEmergencyCompanyContent started");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("emergencyContent", emergencyContent);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("writerId", userId);
		map.put("nowDate", commonUtil.getTodayUTCTime("yyyy-MM-dd HH:mm:ss"));
		ezNotificationDAO.addEmergencyCompanyContent(map);
		logger.debug("addEmergencyCompanyContent ended");
	}

	@Override
	public String checkEmergencyPermission(String rollInfo, String userId, String deptId, String deptPath, String jobId, String roleId, String companyId, int tenantId) throws Exception {
		logger.debug("checkEmergencyPermission started");
		String adminFlag = "false";
		
		OrganAuth organAuth = commonUtil.makeOrganAuth(userId, tenantId, deptId, jobId);
		
		if (organAuth.isAuth(AdminAuth.ADMIN_MASTER)) {
			adminFlag = "emergencyAdmin";
		} else if (organAuth.isAuth(AdminAuth.COMPANY_MANAGER)){
			adminFlag = "emergencyAdmin";
		} else {
			boolean adminCheck = false;
			Map<String, Object> map = new HashMap<String, Object>();
			String[] deptPathList = deptPath.split(","); 
			map.put("companyId", companyId);
			map.put("tenantId", tenantId);
			map.put("userId", userId);
			map.put("deptId", deptId);
			map.put("jobId", jobId);
			map.put("roleId", roleId);
			map.put("deptPathList", deptPathList);
			if (!adminCheck) {
				map.put("userType", "PERSON");
				adminCheck = ezNotificationDAO.checkEmergencyPermission(map);
			}
			
			if (!adminCheck) {
				map.put("userType", "DEPT");
				adminCheck = ezNotificationDAO.checkEmergencyPermission(map);
			}
			
			if (!adminCheck) {
				map.put("userType", "JIKWI");
				adminCheck = ezNotificationDAO.checkEmergencyPermission(map);
			}
			
			if (!adminCheck) {
				map.put("userType", "JIKCHEK");
				adminCheck = ezNotificationDAO.checkEmergencyPermission(map);
			}
			
			if (!adminCheck) {
				map.put("userType", "GROUP");
				adminCheck = ezNotificationDAO.checkEmergencyGroupPermission(map);
			}
			
			if (adminCheck) {
				adminFlag = "emergencyAdmin";
			}
		}
		
		logger.debug("checkEmergencyPermission ended");
		return adminFlag;
	}

	@Override
	public Set<NotiRecipientVO> getNotiRecipientList(List<Map<String, Object>> recipient, int tenantId) throws Exception {
		logger.debug("getNotiRecipientList started");
		Set<NotiRecipientVO> notiIdSet = new HashSet<NotiRecipientVO> ();
		
		for (Map<String, Object> notiTarget : recipient) {
			String userType = (String) notiTarget.get("userType");
			String cn = (String) notiTarget.get("cn");
			NotiRecipientVO notiRecipient = new NotiRecipientVO();
			notiRecipient.setCn(cn);
			
			if (userType.equals("PERSON")) {
				String companyId = (String) notiTarget.get("companyId");
				notiRecipient.setCompanyId(companyId);
				notiIdSet.add(notiRecipient);
			} else if (userType.equals("DEPT")) {
				String subDeptYn = (String) notiTarget.get("subDeptYn");
				Map <String, Object> map = new HashMap <String, Object>();
				map.put("cn", cn);
				map.put("subDeptYn", subDeptYn);
				map.put("tenantId", tenantId);
				List<NotiRecipientVO> deptMemberList = ezNotificationDAO.getNotiRecipientByDeptId(map);
				notiIdSet.addAll(deptMemberList);
			}
		}
		
		logger.debug("getNotiRecipientList ended");
		return notiIdSet;
	}

	@Override
	public int addEmergencyNotiItem(String userId, String notiTitle, String notiBody, String companyId, int tenantId) throws Exception {
		logger.debug("addEmergencyNotiItem started");
		
		Map<String, Object> map = new HashMap<String, Object> ();
		map.put("writerId", userId);
		map.put("notiTitle", notiTitle);
		map.put("notiBody", notiBody);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("nowDate", commonUtil.getTodayUTCTime("yyyy-MM-dd HH:mm:ss"));
		
		int notiId = ezNotificationDAO.addEmergencyNotiItem(map);
		
		logger.debug("addEmergencyNotiItem ended");
		
		return notiId;
	}

	@Override
	public EmergencyNotiItemVO getEmergencyNotiItem(String emergencyItemId, String offSet, int tenantId) throws Exception {
		logger.debug("getEmergencyNotiItem started");
		
		Map<String, Object> map = new HashMap<String, Object> ();
		map.put("emergencyItemId", emergencyItemId);
		map.put("tenantId", tenantId);
		map.put("offSet", offSet);
		
		logger.debug("getEmergencyNotiItem ended");
		EmergencyNotiItemVO emergencyItem = ezNotificationDAO.getEmergencyNotiItem(map);
		if (emergencyItem != null) {
			String imgUrl = emergencyItem.getWriterPhoto();
			String userPhoto = "";
			if (imgUrl != null && !imgUrl.equals("")) {
				userPhoto = commonUtil.getUploadPath("upload_personal.PHOTO", tenantId) + commonUtil.separator + imgUrl;
			}
			emergencyItem.setWriterPhoto(userPhoto);
		}
		
		return emergencyItem;
		
	}

	@Override
	public void deleteEmergencyNoti(String notiId, int tenantId) throws Exception {
		logger.debug("deleteEmergencyNoti started");
		
		Map<String, Object> map = new HashMap<String, Object> ();
		map.put("notiId", notiId);
		map.put("tenantId", tenantId);
		
		logger.debug("deleteEmergencyNoti ended");
		
		ezNotificationDAO.deleteEmergencyNoti(map);
	}

}
