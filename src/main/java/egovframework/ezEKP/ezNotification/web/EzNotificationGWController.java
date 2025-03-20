package egovframework.ezEKP.ezNotification.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Optional;
import java.util.Properties;
import java.util.Set;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringEscapeUtils;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezNotification.service.EzNotificationService;
import egovframework.ezEKP.ezNotification.vo.EmergencyNotiItemVO;
import egovframework.ezEKP.ezNotification.vo.EmergencyNotiPermissionVO;
import egovframework.ezEKP.ezNotification.vo.NotiRecipientVO;
import egovframework.ezEKP.ezNotification.vo.NotificationVO;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezPersonal.service.EzPersonalService;
import egovframework.ezEKP.ezPersonal.type.NotiPlatform;
import egovframework.ezEKP.ezPersonal.type.NotiType;
import egovframework.ezMobile.ezOption.service.MOptionService;
import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.utl.fcc.service.CommonUtil;

/** 
 * @Description [RestController] 통합 알림
 * @author 솔루션2팀 한태훈
 *  *
 *    수정일        수정자         수정내용
 *    ----------    ------    -------------------
 *    2023.10.31    한태훈    신규작성
 *
 * @see
 */

@SuppressWarnings("unchecked")
@RestController
public class EzNotificationGWController {
	
    private static final Logger logger = LoggerFactory.getLogger(EzNotificationController.class);
    
	@Autowired
	private CommonUtil commonUtil;
	
	@Resource(name = "EzCommonService")
	private EzCommonService ezCommonService;
	
	@Resource(name = "MOptionService")
	private MOptionService mOptionService;
	
	@Resource(name = "EzPersonalService")
	private EzPersonalService ezPersonalService;
	
	@Autowired
	private EzNotificationService ezNotificationService;
	
	@Autowired
	private EzEmailService ezEmailService;
	
	@Resource(name = "loginService")
    private LoginService loginService;
	
	@Autowired
	private EzOrganService ezOrganService;
	
	@Autowired
	private EgovMessageSource egovMessageSource;
	
	@Autowired
	private Properties config;
	
	// 2024-03-28 한태훈 - 통합알림 > 알림 전송 
	@RequestMapping(value = "/rest/ezNotification/notiSend/{senderId:.+}", method=RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject notiSend(@PathVariable String senderId, HttpServletRequest request, @RequestBody NotificationVO notiVO) throws Exception {
		logger.debug("G/W EzNotification [POST /rest/ezNotification/notiSend/{senderId}] started.");
		
		JSONObject result = new JSONObject();
		String resultStr = "";
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, senderId);
			String regDate = commonUtil.getTodayUTCTime("yyyy-MM-dd HH:mm:ss");
			String senderName = notiVO.getSenderName();
			String notiContent = notiVO.getNotiContent();
			List<Map<String, Object>> recipient = notiVO.getRecipient();
			if (recipient == null) {
				logger.debug("realtime noti status : error, recipientIdList is empty.");
				logger.debug("G/W EzNotification [POST /rest/ezNotification/notiSend/{senderId}] ended.");
			}
			
			if (notiVO.getMainType() == null || notiVO.getMainType().equals("")) {
				logger.debug("realtime noti status : error, mainType is empty.");
				logger.debug("G/W EzNotification [POST /rest/ezNotification/notiSend/{senderId}] ended.");
			}
			
			String mainType = notiVO.getMainType().toUpperCase();
			String subType = Optional.ofNullable(notiVO.getSubType()).map(String::toUpperCase).orElse(null);
			String linkUrl = notiVO.getLinkUrl();
			String linkUrlMobile = notiVO.getLinkUrlMobile();
			String etcData = notiVO.getEtcData();
			String viewType = notiVO.getViewType();
			String viewWidth = notiVO.getViewWidth();
			String viewHeight = notiVO.getViewHeight();
			
			logger.debug("mainType : {}, subType : {}, etcData : {}", mainType, subType, etcData);
			
			/* 링크 주소 유효성 검증 시 필요
			if (!checkValidLink(linkUrl, linkUrlMobile)) {
				result.put("status", "error");
				result.put("data","notAllowed");
				result.put("code", "-1");
				logger.debug("Abnormal access was detected at [POST /rest/ezNotification/notiSend/{senderId}]");
				logger.debug("linkUrl : {}, linkUrlMobile : {}", linkUrl, linkUrlMobile);
				logger.debug("G/W EzNotification [POST /rest/ezNotification/notiSend/{senderId}] ended.");
				return result;
			}
			*/
			
			// 자바 결재 모듈을 사용할 때 true, 아닐 때 false (결재 모바일 푸시 알림은 따로 보내고 있기 때문에 자바 모듈로 결재 알림 발송 시에 모바일 알림은 제외함.) 
			boolean useJavaApproval = ezNotificationService.isJavaApprovalUse(info.getCompanyId(), info.getTenantId());
			
			String notiName = "";
			
			if (subType != null && mainType.equals("APPROVAL") && useJavaApproval &&
				(subType.equals("ARRIVE") || subType.equals("GONGRAM") || subType.equals("CIRCULATION")
				|| subType.equals("BORYU") || subType.equals("BALSONG") || subType.equals("SUSIN")
				|| subType.equals("JIJUNG") || subType.equals("BEBU") || subType.equals("REJIJUNG")
				|| subType.equals("REBEBU")	|| subType.equals("DEFAULT"))) {
				notiName = mainType + "_" + "ARRIVE";
			} else if (subType != null && !subType.equals("")) {
				notiName = mainType + "_" + subType;
			} else {
				notiName = mainType;
			}

			NotiType notiType = null;
			
			String subTypeForMobilePush = "0";
			if (!mainType.equals("ETC") && (etcData == null || etcData.indexOf("notChkSetting") < 0)) {
				notiType = NotiType.fromString(notiName);
				subTypeForMobilePush = subType != "" ? notiType.subType() + "" : "0";
			}
			
			String primaryLang = ezCommonService.getTenantConfig("PrimaryLang", info.getTenantId());
			Locale locale = new Locale(commonUtil.getTwoLetterLangFromLangNum(primaryLang));
			
			String mainTypeForMobilePush = "";
			String pushNotiContent = StringEscapeUtils.unescapeHtml4(notiContent);
			switch (mainType) {
			case "MAIL" :
				pushNotiContent = "[" + egovMessageSource.getMessage("ezNotification.type.ksy01", locale) + "] " + pushNotiContent;
			case "APPROVAL":
				pushNotiContent = "[" + egovMessageSource.getMessage("ezNotification.type.hth01", locale) + "] " + pushNotiContent;
				mainTypeForMobilePush = "2";
				break;
			case "BOARD":
				pushNotiContent = "[" + egovMessageSource.getMessage("ezNotification.type.hth02", locale) + "] " + pushNotiContent;
				mainTypeForMobilePush = "51";
				break;
			case "SCHEDULE":
				pushNotiContent = "[" + egovMessageSource.getMessage("ezNotification.type.hth03", locale) + "] " + pushNotiContent;
				mainTypeForMobilePush = "6011";
				break;
			case "RESOURCE":
				pushNotiContent = "[" + egovMessageSource.getMessage("ezNotification.type.hth04", locale) + "] " + pushNotiContent;
				mainTypeForMobilePush = "6021";
				break;
			case "SURVEY":
				pushNotiContent = "[" + egovMessageSource.getMessage("ezNotification.type.hth05", locale) + "] " + pushNotiContent;
				mainTypeForMobilePush = "6031";
				break;
			case "POLL":
				pushNotiContent = "[" + egovMessageSource.getMessage("ezNotification.type.hth06", locale) + "] " + pushNotiContent;
				mainTypeForMobilePush = "6041";
				break;
			case "COMMUNITY":
				pushNotiContent = "[" + egovMessageSource.getMessage("ezNotification.type.hth07", locale) + "] " + pushNotiContent;
				mainTypeForMobilePush = "6051";
				break;
			case "WEBFOLDER":
				pushNotiContent = "[" + egovMessageSource.getMessage("ezNotification.type.hth08", locale) + "] " + pushNotiContent;
				mainTypeForMobilePush = "6061";
				break;
			case "JOURNAL":
				pushNotiContent = "[" + egovMessageSource.getMessage("ezNotification.type.hth09", locale) + "] " + pushNotiContent;
				mainTypeForMobilePush = "6071";
				break;
			case "NOTI":
				pushNotiContent = "[" + egovMessageSource.getMessage("ezNotification.type.hth10", locale) + "] " + pushNotiContent;
				mainTypeForMobilePush = "6001";
				break;
			default:
				mainTypeForMobilePush = "6001";
				break;
			}
			
			Set<NotiRecipientVO> recipientList = ezNotificationService.getNotiRecipientList(recipient, info.getTenantId());
			
			String useEzTalkNotification = ezCommonService.getTenantConfig("useEzTalkNotification", info.getTenantId());
			
			boolean useMobilePushCompany = useEzTalkNotification.equals("YES") ? true : false;
			if (mainType.equals("APPROVAL") && useJavaApproval) { // 결재 모듈 사용 여부 조건 추가 필요. (우리 결재 모듈 사용시 에만 false)
				useMobilePushCompany = false; // 결재는 푸시 알림 기능이 존재.
			}
			
			for (NotiRecipientVO recipientVO : recipientList) {
				try {
					String recipientId = recipientVO.getCn();
					String companyId = Optional.ofNullable(recipientVO.getCompanyId()).orElse(info.getCompanyId());
					logger.debug("recipientId : " + recipientId);
					
					resultStr += recipientId + ":";
					
					boolean useTotalNoti = false;
					boolean useMobilePushUser = false;
					
					if ((etcData != null && etcData.indexOf("notChkSetting") >= 0) || mainType.equals("ETC")) {
						useTotalNoti = true;
						useMobilePushUser = true;
					} else {
						if (!ezPersonalService.hasNotiDiableItem(recipientId, notiType, NotiPlatform.TOTAL_NOTI, info.getTenantId())) {
							useTotalNoti = true;
						}
						
						if (!ezPersonalService.hasNotiDiableItem(recipientId, notiType, NotiPlatform.MOBILE_WEBAPP, info.getTenantId())) {
							useMobilePushUser = true;
						}
					}
					
					if (useTotalNoti) {
						ezNotificationService.addRealTimeNoti(recipientId, senderId, senderName, mainType, subType, notiContent, regDate, etcData, linkUrl, linkUrlMobile, viewType, viewWidth, viewHeight, info.getTenantId(), companyId);
						resultStr += "{total:ok,";
					} else {
						resultStr += "{total:notUse,";
					}
					
					if (useMobilePushCompany && useMobilePushUser && !mainType.equals("MAIL")) {
						boolean mobilePushSuccess = ezEmailService.addEzTalkNotification(recipientId, senderName, pushNotiContent, mainTypeForMobilePush, subTypeForMobilePush, linkUrlMobile);
						
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
			
			result.put("status", "ok");
			result.put("data", resultStr);
			result.put("code", 0);
			logger.debug("realtime noti status : ok, {}", resultStr);
			logger.debug("G/W EzNotification [POST /rest/ezNotification/notiSend/{senderId}] ended.");
			
			return result;
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", resultStr);
			logger.debug("realtime noti status : error, {}", resultStr);
			logger.debug("G/W EzNotification [POST /rest/ezNotification/notiSend/{senderId}] ended.");
			return result;
		}
	}
	
	// 2024-03-28 한태훈 - 통합알림 > 사용자 개별 알림 읽음 또는 삭제
	@RequestMapping(value = "/rest/ezNotification/updateNoti/{notiSeq:.+}", method=RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject updateNoti(@PathVariable String notiSeq, HttpServletRequest request) throws Exception {
		logger.debug("G/W EzNotification [POST /rest/ezNotification/updateNoti/{notiSeq}] started.");
		JSONObject result = new JSONObject();
		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			String mode = request.getParameter("mode");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			ezNotificationService.updateNoti(notiSeq, mode, commonUtil.getTodayUTCTime("yyyy-MM-dd HH:mm:ss"), info.getCompanyId(), info.getTenantId());
			result.put("status", "ok");
			result.put("code", 0);
			logger.debug("G/W EzNotification [POST /rest/ezNotification/updateNoti/{notiSeq}] ended.");
			return result;
			
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			logger.debug("G/W EzNotification [POST /rest/ezNotification/updateNoti/{notiSeq}] ended.");
			return result;
		}
	}
	
	// 2024-03-28 한태훈 - 통합알림 > 사용자 전체 알림 읽음 또는 삭제
	@RequestMapping(value = "/rest/ezNotification/{userId:.+}/updateNotiAll", method=RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject updateNotiAll(@PathVariable String userId, HttpServletRequest request) throws Exception {
		logger.debug("G/W EzNotification [POST /rest/ezNotification/{userId}/updateNotiAll] started.");
		JSONObject result = new JSONObject();
		try {
			String serverName = request.getHeader("x-user-host");
			String mode = request.getParameter("mode");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			ezNotificationService.updateNotiAll(userId, mode, commonUtil.getTodayUTCTime("yyyy-MM-dd HH:mm:ss"), info.getCompanyId(), info.getTenantId());
			result.put("status", "ok");
			result.put("code", 0);
			logger.debug("G/W EzNotification [POST /rest/ezNotification/{userId}/updateNotiAll] ended.");
			return result;
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			logger.debug("G/W EzNotification [POST /rest/ezNotification/{userId}/updateNotiAll] ended.");
			return result;
		}
		
	}
	
	// 2024-03-28 한태훈 - 통합알림 > 사용자 알림 검색
	@RequestMapping(value = "/rest/ezNotification/{userId:.+}/searchNoti", method=RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject searchNoti(@PathVariable String userId, HttpServletRequest request) throws Exception {
		logger.debug("G/W EzNotification [GET /rest/ezNotification/{userId}/searchNoti] started.");
		JSONObject result = new JSONObject();
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			int notiListCnt = Integer.parseInt(request.getParameter("notiListCnt"));
			String isRead = request.getParameter("isRead");
			String notiFilter = request.getParameter("notiFilter");
			String keyWord = request.getParameter("keyWord");
			Integer lastNotiSeq = request.getParameter("lastNotiSeq").isEmpty() ? null : Integer.parseInt(request.getParameter("lastNotiSeq"));
			String companyId = info.getCompanyId();
			int tenantId = info.getTenantId();
			String mode = "ALL";
			int totalListCnt = ezNotificationService.getTotalSearchNotiListCnt(userId, mode, isRead, notiFilter, keyWord, companyId, tenantId);
			mode = "NOTREAD";
			int notReadListCnt = ezNotificationService.getTotalSearchNotiListCnt(userId, mode, isRead, notiFilter, keyWord, companyId, tenantId);
			mode = "NOTREAD";
			int notReadTotalListCnt = ezNotificationService.getTotalNotiListCnt(userId, mode, companyId, tenantId);
			
			int rowCount = notiListCnt;
			
			List<NotificationVO> searchList = ezNotificationService.getSearchNotiList(userId, lastNotiSeq, rowCount, isRead, notiFilter, keyWord, tenantId, companyId, commonUtil.getMinuteUTC(info.getOffSet()));
			Map<String, Object> resultMap = new HashMap<String, Object> ();
			resultMap.put("notiList", searchList);
			resultMap.put("totalListCnt", totalListCnt);
			resultMap.put("notReadListCnt", notReadListCnt);
			resultMap.put("notReadTotalListCnt", notReadTotalListCnt);
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", resultMap);
			logger.debug("G/W EzNotification [GET /rest/ezNotification/{userId}/searchNoti] ended.");
			return result;
			
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			logger.debug("G/W EzNotification [GET /rest/ezNotification/{userId}/searchNoti] ended.");
			return result;
		}
		
	}
	
	// 2024-03-28 한태훈 - 통합알림 > 읽지 않은 알림 개수 구하기
	@RequestMapping(value = "/rest/ezNotification/{userId:.+}/unreadNotiCnt", method=RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject unreadNotiCnt(@PathVariable String userId, HttpServletRequest request) throws Exception {
		logger.debug("G/W EzNotification [GET /rest/ezNotification/{userId}/unreadNotiCnt] started.");
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			String companyId = info.getCompanyId();
			int tenantId = info.getTenantId();
			String mode = "NOTREAD";
			int notReadTotalListCnt = ezNotificationService.getTotalNotiListCnt(userId, mode, companyId, tenantId);
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", notReadTotalListCnt + "");
			logger.debug("G/W EzNotification [GET /rest/ezNotification/{userId}/unreadNotiCnt] ended.");
			return result;
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			logger.debug("G/W EzNotification [GET /rest/ezNotification/{userId}/unreadNotiCnt] ended.");
			return result;
		}
		
	}
	
	// 2024-03-28 한태훈 - 통합알림 > 새로운 알림 카운트 개수 구하기
	@RequestMapping(value = "/rest/ezNotification/{userId:.+}/newNotiCnt", method=RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getNewNotiCnt(@PathVariable String userId, HttpServletRequest request) throws Exception {
		logger.debug("G/W EzNotification [GET /rest/ezNotification/{userId}/newNotiCnt] started.");
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			String companyId = info.getCompanyId();
			int tenantId = info.getTenantId();
			String pollSTime = request.getParameter("lastNotiPollTime");
			String pollETime = commonUtil.getTodayUTCTime("yyyy-MM-dd HH:mm:ss");
			int newNotiCnt = ezNotificationService.getNewNotiCnt(userId, pollSTime, pollETime, companyId, tenantId);
			String mode = "NOTREAD";
			int notReadTotalListCnt = ezNotificationService.getTotalNotiListCnt(userId, mode, companyId, tenantId);
			Map <String, Object> returnMap = new HashMap<String, Object> ();
			returnMap.put("newNotiCnt", newNotiCnt);
			returnMap.put("lastNotiPollTime", pollETime);
			returnMap.put("notReadNotiCnt", notReadTotalListCnt);
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", returnMap);
			logger.debug("G/W EzNotification [GET /rest/ezNotification/{userId}/newNotiCnt] ended.");
			return result;
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			logger.debug("G/W EzNotification [GET /rest/ezNotification/{userId}/newNotiCnt] ended.");
			return result;
		}
	}
	
	/**
	 * 모바일 G/W 통합알림 [GET] 알림 리스트
	 */
	@RequestMapping(value = "/mobile/ezNotification/getNotiList/{userId:.+}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getMobileNotiList(@PathVariable String userId, HttpServletRequest request) throws Exception {
		logger.debug("G/W MNotification [GET /mobile/ezNotification/getNotiList/{userId:.+}] starts");
		
		JSONObject result = new JSONObject();
		
		try {
			Map<String, Object> resultMap = new HashMap<String, Object>();
			
			String serverName = request.getHeader("x-user-host");			
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			String isRead = request.getParameter("isRead");
			String notiFilter = request.getParameter("notiFilter");
			String keyWord = request.getParameter("keyWord");
			Integer lastNotiSeq = request.getParameter("lastNotiSeq").isEmpty() ? null : Integer.parseInt(request.getParameter("lastNotiSeq"));
			int rowCount = Integer.parseInt(request.getParameter("notiListCnt"));
			String mode = "ALL";
			int totalListCnt = ezNotificationService.getTotalSearchNotiListCnt(userId, mode, isRead, notiFilter, keyWord, info.getCompanyId(), info.getTenantId());
			mode = "NOTREAD";
			int notReadListCnt = ezNotificationService.getTotalSearchNotiListCnt(userId, mode, isRead, notiFilter, keyWord, info.getCompanyId(), info.getTenantId());
			List<NotificationVO> notiList = ezNotificationService.getSearchNotiListForMobile(userId, lastNotiSeq, rowCount, isRead, notiFilter, keyWord, info.getTenantId(), info.getCompanyId(), commonUtil.getMinuteUTC(info.getOffSet()));
			
			if (!notiList.isEmpty()) {
				for (NotificationVO noti : notiList) {
					String content = noti.getNotiContent();
					if (content != null && !content.trim().isEmpty()) {
						noti.setNotiContent(commonUtil.convertTagSymbols(content));
					}
				}
			}
			
			resultMap.put("notiList", notiList);
			resultMap.put("totalListCnt", totalListCnt);
			resultMap.put("notReadListCnt", notReadListCnt);
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("data", resultMap);
			logger.debug("G/W MNotification [GET /mobile/ezNotification/getNotiList/{userId:.+}] ended");
			
			return result;
			
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");		
			logger.error(e.getMessage(), e);
			logger.debug("G/W MNotification [GET /mobile/ezNotification/getNotiList/{userId:.+}] ended");
			
			return result;
		}		
	}
	
	// 2024-03-28 한태훈 - 통합알림 > 모바일 알림 새로고침 주기
	@RequestMapping(value = "/rest/ezNotification/notiPollInterval/{userId:.+}", method= RequestMethod.GET, produces="application/json;charset=utf-8")
	public JSONObject getNotiPollInterval(@PathVariable String userId, HttpServletRequest request) throws Exception {
		logger.debug("G/W MNotification [GET /rest/ezNotification/notiPollInterval] starts");
		
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");			
			MCommonVO info = mOptionService.commonInfo(serverName, userId);
			String notiPollInterval = ezCommonService.getTenantConfig("notiPollingInterval", info.getTenantId());
			result.put("status", "ok");
			result.put("code", 0);			
			result.put("notiPollInterval", notiPollInterval);
			logger.debug("G/W MNotification [GET /rest/ezNotification/notiPollInterval] ended");
			
			return result;
			
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);			
			result.put("data", "");		
			logger.error(e.getMessage(), e);
			logger.debug("G/W MNotification [GET /rest/ezNotification/notiPollInterval] ended");
			
			return result;
		}		
	}
	
	/* linkURL 및 linkMobileURL 유효성 검증 체크 시 필요. config.allowedURLsForNotiLink 에 띄어쓰기로 구분
	private boolean checkValidLink(String linkUrl, String linkUrlMobile) throws Exception {
		boolean isAllowed = false;
		
		String[] allowedURLs = config.getProperty("config.allowedURLsForNotiLink").split(" ");
		boolean linkUrlCheck = false;
		boolean linkUrlMobileCheck = false;
		for (String allowedURL : allowedURLs) {
			if (!linkUrlCheck && linkUrl == null || linkUrl.equals("") || checkStartWith(linkUrl, allowedURL)) {
				linkUrlCheck = true;
			}
			
			if (!linkUrlMobileCheck && linkUrlMobile == null || linkUrlMobile.equals("") || checkStartWith(linkUrlMobile, allowedURL)) {
				linkUrlMobileCheck = true;
			}
			
			if (linkUrlCheck && linkUrlMobileCheck) {
				break;
			}
		}
		
		if (linkUrlCheck && linkUrlMobileCheck) {
			isAllowed = true;
		}
		
		return isAllowed;
	}
	
	private boolean checkStartWith(String linkUrl, String allowedURL)  throws Exception {
		boolean startWith = false;
		if (linkUrl.trim().indexOf("http://" + allowedURL) == 0 || linkUrl.trim().indexOf("https://" + allowedURL) == 0) {
			startWith = true;
		}
		
		return startWith;
	}
	*/
	
	// 2024-07-24 한태훈 - 통합알림 > 긴급공지 권한 리스트 가져오기
	@RequestMapping(value = "/rest/ezNotification/company/list/emergency/permission/{userId:.+}", method=RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getEmergencyPermissionList(HttpServletRequest request, @PathVariable String userId) throws Exception {
		logger.debug("G/W EzNotification [GET /rest/ezNotification/company/list/emergency/permission] started.");
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			String companyId = request.getParameter("companyId");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			int tenantId = info.getTenantId();
			Locale locale = new Locale(commonUtil.getTwoLetterLangFromLangNum(info.getLang()));
			
			String permissionListXml = ezNotificationService.getEmergencyPermissionList(commonUtil.getPrimaryData(info.getLang(), tenantId), locale, companyId, tenantId);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", permissionListXml);
			logger.debug("G/W EzNotification [GET /rest/ezNotification/company/list/emergency/permission] ended.");
			return result;
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			logger.debug("G/W EzNotification [GET /rest/ezNotification/company/list/emergency/permission] ended.");
			return result;
		}
	}
	
	@RequestMapping(value = "/rest/ezNotification/emergency/add/permissions/{userId:.+}", method=RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject addEmergencyPermission(HttpServletRequest request, @PathVariable String userId, @RequestBody List<EmergencyNotiPermissionVO> permissionList) throws Exception {
		logger.debug("G/W EzNotification [GET /rest/ezNotification/emergency/add/permissions/{userId}] started.");
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			int tenantId = info.getTenantId();
			
			ezNotificationService.addEmergencyPermission(permissionList, tenantId);
			
			result.put("status", "ok");
			result.put("code", 0);
			logger.debug("G/W EzNotification [GET /rest/ezNotification/emergency/add/permissions/{userId}] ended.");
			return result;
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			logger.debug("G/W EzNotification [GET /rest/ezNotification/emergency/add/permissions/{userId}] ended.");
			return result;
		}
	}
	
	@RequestMapping(value = "/rest/ezNotification/emergency/delete/permissions/{userId:.+}", method=RequestMethod.DELETE, produces = "application/json;charset=utf-8")
	public JSONObject deleteEmergencyPermission(HttpServletRequest request, @PathVariable String userId, @RequestBody List<EmergencyNotiPermissionVO> permissionList) throws Exception {
		logger.debug("G/W EzNotification [GET /rest/ezNotification/emergency/delete/permissions/{userId}] started.");
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			String companyId = request.getParameter("companyId");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			int tenantId = info.getTenantId();
			
			ezNotificationService.deleteEmergencyPermission(permissionList, companyId, tenantId);
			
			result.put("status", "ok");
			result.put("code", 0);
			logger.debug("G/W EzNotification [GET /rest/ezNotification/emergency/delete/permissions/{userId}] ended.");
			return result;
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			logger.debug("G/W EzNotification [GET /rest/ezNotification/emergency/delete/permissions/{userId}] ended.");
			return result;
		}
	}
	
	@RequestMapping(value = "/rest/ezNotification/company/get/emergency/content", method=RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getEmergencyContent(HttpServletRequest request) throws Exception {
		logger.debug("G/W EzNotification [GET /rest/ezNotification/company/get/emergency/content] started.");
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			String companyId = request.getParameter("companyId");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			int tenantId = info.getTenantId();
			
			String emergencyContent	= ezNotificationService.getEmergencyContent(companyId, tenantId);		
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", emergencyContent);
			logger.debug("G/W EzNotification [GET /rest/ezNotification/company/get/emergency/content] ended.");
			return result;
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			logger.debug("G/W EzNotification [GET /rest/ezNotification/company/get/emergency/content] ended.");
			return result;
		}
	}
	
	@RequestMapping(value = "/rest/ezNotification/company/add/emergency/content", method=RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject addEmergencyCompanyContent(HttpServletRequest request) throws Exception {
		logger.debug("G/W EzNotification [POST /rest/ezNotification/company/add/emergency/content] started.");
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			String companyId = request.getParameter("companyId");
			String emergencyContent = request.getParameter("emergencyContent");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			int tenantId = info.getTenantId();
			
			ezNotificationService.addEmergencyCompanyContent(userId, emergencyContent, companyId, tenantId);		
			result.put("status", "ok");
			result.put("code", 0);
			logger.debug("G/W EzNotification [GET /rest/ezNotification/company/add/emergency/content] ended.");
			return result;
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			logger.debug("G/W EzNotification [GET /rest/ezNotification/company/add/emergency/content] ended.");
			return result;
		}
	}
	
	@RequestMapping(value = "/rest/ezNotification/emergency/permission/check", method=RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject checkEmergencyPermission(HttpServletRequest request) throws Exception {
		logger.debug("G/W EzNotification [GET /rest/ezNotification/emergency/permission/check] started.");
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			int tenantId = info.getTenantId();
			
			String deptId = request.getParameter("deptId") == null ? info.getDeptId() : request.getParameter("deptId");
			String roleInfo = request.getParameter("roleInfo") == null ? info.getRollInfo() : request.getParameter("roleInfo");
			String jobId = request.getParameter("jobId") == null ? info.getJobId() : request.getParameter("jobId");
			String roleId = request.getParameter("roleId") == null ? info.getRoleId() : request.getParameter("roleId");
			String companyId = request.getParameter("companyId") == null ? info.getCompanyId() : request.getParameter("companyId");
			String deptPath = request.getParameter("deptPath") == null ? ezOrganService.getDeptPath(deptId, tenantId) : request.getParameter("deptPath");
			
			String adminFlag = ezNotificationService.checkEmergencyPermission(roleInfo, userId, deptId, deptPath, jobId, roleId, companyId, tenantId);		
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", adminFlag);
			logger.debug("G/W EzNotification [GET /rest/ezNotification/emergency/permission/check] ended.");
			return result;
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			logger.debug("G/W EzNotification [GET /rest/ezNotification/emergency/permission/check] ended.");
			return result;
		}
	}
	
	@RequestMapping(value = "/rest/ezNotification/emergency/notiItem/{userId:.+}", method=RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject addEmergencyNotiContent(HttpServletRequest request, @PathVariable String userId, @RequestBody NotificationVO notiContent) throws Exception {
		logger.debug("G/W EzNotification [POST /rest/ezNotification/emergency/notiItem/] started.");
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			String companyId = notiContent.getCompanyId();
			String notiTitle = notiContent.getNotiContent();
			String notiBody = notiContent.getNotiBody();
			
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			int tenantId = info.getTenantId();
			
			int notiId = ezNotificationService.addEmergencyNotiItem(userId, notiTitle, notiBody, companyId, tenantId);		
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", notiId);
			logger.debug("G/W EzNotification [POST /rest/ezNotification/emergency/notiItem/] ended.");
			return result;
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			logger.debug("G/W EzNotification [POST /rest/ezNotification/emergency/notiItem/] ended.");
			return result;
		}
	}
	
	@RequestMapping(value = "/rest/ezNotification/user/get/emergency/item", method=RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getEmergencyNotiItem(HttpServletRequest request) throws Exception {
		logger.debug("G/W EzNotification [GET /rest/ezNotification/user/get/emergency/item] started.");
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			String emergencyItemId = request.getParameter("emergencyItemId");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			int tenantId = info.getTenantId();
			
			JSONObject data = new JSONObject();
			
			EmergencyNotiItemVO emergencyNotiItem = ezNotificationService.getEmergencyNotiItem(emergencyItemId, commonUtil.getMinuteUTC(info.getOffSet()), tenantId);
			
			if (emergencyNotiItem == null) {
				result.put("status", "empty");
				result.put("code", -1);
				result.put("data", "");
				return result;
			}
			data.put("emergencyNotiItem", emergencyNotiItem);
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
			logger.debug("G/W EzNotification [GET /rest/ezNotification/user/get/emergency/item] ended.");
			return result;
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			logger.debug("G/W EzNotification [GET /rest/ezNotification/user/get/emergency/item] ended.");
			return result;
		}
	}
	
	@RequestMapping(value = "/rest/ezNotification/user/delete/emergency/item", method=RequestMethod.DELETE, produces = "application/json;charset=utf-8")
	public JSONObject deleteEmergencyNoti(HttpServletRequest request) throws Exception {
		logger.debug("G/W EzNotification [DELETE /rest/ezNotification/user/delete/emergency/item] started.");
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			String notiId = request.getParameter("emergencyItemId");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			int tenantId = info.getTenantId();
			
			ezNotificationService.deleteEmergencyNoti(notiId, tenantId);
			
			result.put("status", "ok");
			result.put("code", 0);
			logger.debug("G/W EzNotification [DELETE /rest/ezNotification/user/delete/emergency/item] ended.");
			return result;
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			logger.debug("G/W EzNotification [DELETE /rest/ezNotification/user/delete/emergency/item] ended.");
			return result;
		}
	}
	
}

