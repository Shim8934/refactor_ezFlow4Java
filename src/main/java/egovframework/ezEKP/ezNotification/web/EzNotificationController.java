package egovframework.ezEKP.ezNotification.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezNotification.vo.NotificationVO;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezOrgan.vo.OrganAuth;
import egovframework.ezEKP.ezOrgan.vo.OrganAuth.AdminAuth;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Controller
public class EzNotificationController {
	
    private static final Logger logger = LoggerFactory.getLogger(EzNotificationController.class);
    
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
	@Resource(name = "EzCommonService")
	private EzCommonService ezCommonService;
	
	@Resource(name = "loginService")
    private LoginService loginService;
	
	@Resource(name = "EzOrganService")
    private EzOrganService ezOrganService;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	
	// 2024-03-28 한태훈 - 통합알림 > 통합알림 수신 리스트 팝업창
	@RequestMapping(value = "/ezNotification/notificationMain.do", method=RequestMethod.GET)
	public String notificationMain(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("notificationMain started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		model.addAttribute("deptID", userInfo.getDeptID());
		model.addAttribute("userID", userInfo.getId());
		
		logger.debug("notificationMain ended");
		
		return "/ezNotification/notificationMain";
	}
	
	@ResponseBody
	@RequestMapping(value = "/ezNotification/checkEmergencyPermission.do", method=RequestMethod.GET, produces = "application/json;charset=utf-8")
	public String emergencyNotiPermissionCheck(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("emergencyNotiPermissionCheck started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		String url = "/rest/ezNotification/emergency/permission/check";
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("companyId", userInfo.getCompanyID());
		paramMap.put("userId", userInfo.getId());
		paramMap.put("roleInfo", userInfo.getRollInfo());
		paramMap.put("deptId", userInfo.getDeptID());
		paramMap.put("jobId", userInfo.getJobId());
		paramMap.put("roleId", userInfo.getRoleId());
		paramMap.put("deptPath",userInfo.getDeptPathCode());
		JSONObject resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, paramMap, request, "get", null);
		String status = resultBody.get("status").toString();
		String adminFlag = "false";
		if (status.equals("ok")) {
			adminFlag = (String) resultBody.get("data");
		}
		
		logger.debug("emergencyNotiPermissionCheck ended");
		return adminFlag;
	}
	
	// 2024-03-28 한태훈 - 통합알림 > 통합알림 전송.
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ezNotification/notiSend.do", method=RequestMethod.POST)
	@ResponseBody
	public JSONObject sendNoti(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, @RequestBody NotificationVO notiData) throws Exception {
		logger.debug("sendNoti started");
		
		String gwServerUrl = config.getProperty("config.notificationGWServerURL");
		String senderId = notiData.getSenderId();
		String url = gwServerUrl + "/rest/ezNotification/notiSend/" + senderId;
		List<Map<String, Object>> recipient = notiData.getRecipient();
		String senderName = notiData.getSenderName();
		String notiContent = notiData.getNotiContent();
		String mainType = notiData.getMainType();
		String subType = notiData.getSubType();
		String linkUrl = notiData.getLinkUrl();
		String linkUrlMobile = notiData.getLinkUrlMobile();
		String etcData = notiData.getEtcData();
		String viewType = notiData.getViewType();
		String viewWidth = notiData.getViewWidth();
		String viewHeight = notiData.getViewHeight();

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
		
		logger.debug("sendNoti end");
		
		return resultBody;
	}
	
	// 2024-03-28 한태훈 - 통합알림 > 사용자 개별 알림 읽음 또는 삭제
	@RequestMapping(value = "/ezNotification/updateNoti.do", method=RequestMethod.POST)
	@ResponseBody
	public String updateNoti(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("updateNoti started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String gwServerUrl = config.getProperty("config.notificationGWServerURL");
		String notiSeq = request.getParameter("notiSeq");
		String mode = request.getParameter("mode");
		String url = gwServerUrl + "/rest/ezNotification/updateNoti/" + notiSeq;
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("userId", userInfo.getId())
				.queryParam("mode", mode);
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.POST, entity, String.class);
		
		JSONParser jp = new JSONParser();
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		
		String status = resultBody.get("status").toString();
		
		logger.debug("updateNoti ended");
		
		return status;
	}
	
	// 2024-03-28 한태훈 - 통합알림 > 사용자 전체 알림 읽음 또는 삭제
	@RequestMapping(value = "/ezNotification/updateNotiAll.do", method=RequestMethod.POST)
	@ResponseBody
	public String updateNotiAll(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("updateNotiAll started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String gwServerUrl = config.getProperty("config.notificationGWServerURL");
		String mode = request.getParameter("mode");
		String url = gwServerUrl + "/rest/ezNotification/" + userInfo.getId() + "/updateNotiAll";
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("mode", mode);
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.POST, entity, String.class);
		
		JSONParser jp = new JSONParser();
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		
		String status = resultBody.get("status").toString();
		
		logger.debug("updateNotiAll ended");
		return status;
	}
	
	// 2024-03-28 한태훈 - 통합알림 > 알림 검색.
	@RequestMapping(value = "/ezNotification/searchNoti.do", method=RequestMethod.GET, produces = "application/json;charset=utf-8")
	@ResponseBody
	public JSONObject searchNoti(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("searchNoti started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String gwServerUrl = config.getProperty("config.notificationGWServerURL");
		String url = gwServerUrl + "/rest/ezNotification/" + userInfo.getId() + "/searchNoti";
		
		String isRead = request.getParameter("isRead");
		String notiFilter = request.getParameter("notiFilter");
		String keyWord = request.getParameter("keyWord");
		String lastNotiSeq = request.getParameter("lastNotiSeq");
		String notiListCnt = request.getParameter("notiListCnt");
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("isRead", isRead)
				.queryParam("notiFilter", notiFilter)
				.queryParam("keyWord", keyWord)
				.queryParam("lastNotiSeq", lastNotiSeq)
				.queryParam("notiListCnt", notiListCnt);
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp = new JSONParser();
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		String status = resultBody.get("status").toString();
		JSONObject resultJson = new JSONObject();
		
		if (status.equals("ok")) {
			resultJson = (JSONObject) resultBody.get("data");
		}
		
		logger.debug("searchNoti ended");
		
		return resultJson;
	}
	
	// 2024-03-28 한태훈 - 통합알림 > 읽지않은 알림 개수 가져오기.
	@RequestMapping(value = "/ezNotification/getUnreadNotiCnt.do", method=RequestMethod.GET, produces = "application/json;charset=utf-8")
	@ResponseBody
	public String getUnreadNotiCnt(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("getUnreadNotiCnt started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String gwServerUrl = config.getProperty("config.notificationGWServerURL");
		String url = gwServerUrl + "/rest/ezNotification/" + userInfo.getId() + "/unreadNotiCnt";
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url);
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp = new JSONParser();
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		String status = resultBody.get("status").toString();
		String unreadNotiCnt = "";
		
		if (status.equals("ok")) {
			unreadNotiCnt = resultBody.get("data").toString();
		}
		
		logger.debug("getUnreadNotiCnt ended");
		
		return unreadNotiCnt;
	}
	
	// 2024-03-28 한태훈 - 통합알림 > 새 알림 개수 가져오기.
	@RequestMapping(value = "/ezNotification/getNewNotiCnt.do", method=RequestMethod.GET, produces = "application/json;charset=utf-8")
	@ResponseBody
	public JSONObject getNewNotiCnt(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getNewNotiCnt started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String gwServerUrl = config.getProperty("config.notificationGWServerURL");
		String url = gwServerUrl + "/rest/ezNotification/" + userInfo.getId() + "/newNotiCnt";
		
		String lastNotiPollTime = request.getParameter("lastNotiPollTime");
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("lastNotiPollTime", lastNotiPollTime);
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp = new JSONParser();
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		String status = resultBody.get("status").toString();
		JSONObject returnData = new JSONObject();
		
		if (status.equals("ok")) {
			returnData = (JSONObject) resultBody.get("data");
		}
		
		logger.debug("getNewNotiCnt ended");
		
		return returnData;
	}
	
	@RequestMapping(value = "/ezNotification/emergencyNoti.do", method=RequestMethod.GET)
	public String emergencyNotiMain(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("emergencyNotiMain started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String userId = userInfo.getId();
		String companyId = userInfo.getCompanyID();
		String url = "/rest/ezNotification/company/get/emergency/content";
		String notiCompanyContent = "";
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("companyId", companyId);
		paramMap.put("userId", userId);
		JSONObject resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.notificationGWServerURL"), url, paramMap, request, "get", null);
		String status = resultBody.get("status").toString();
		if (status.equals("ok")) {
			notiCompanyContent = (String) resultBody.get("data");
		}
		model.addAttribute("notiCompanyContent", notiCompanyContent);
		
		logger.debug("emergencyNotiMain ended");
		
		return "/ezNotification/emergencyNotiMain";
	}
	
	@RequestMapping(value = "/ezNotification/notiSelectReceiver.do", method=RequestMethod.GET)
	public String notiSelectReceiver(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("notiSelectReceiver started");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String topID = "";
        String selCompany = userInfo.getCompanyID();
		String primary = ezCommonService.getTenantConfig("LangPrimary" + userInfo.getLang(), userInfo.getTenantId());
		String secondary = ezCommonService.getTenantConfig("LangSecondary" + userInfo.getLang(), userInfo.getTenantId());
		String deptTreeTopId = "";

		OrganAuth organAuth = commonUtil.makeOrganAuth(userInfo.getId(), userInfo.getTenantId(), userInfo.getDeptID(), userInfo.getJobId());
		
		if (organAuth.isAuth(AdminAuth.ADMIN_MASTER)) {
			topID = "Top";
			deptTreeTopId = topID + "/organ";
		} else {
			topID = selCompany;
			deptTreeTopId = topID;
		}

		model.addAttribute("topID", topID);
		model.addAttribute("use_ocs", "");
		model.addAttribute("userID", userInfo.getId());
		model.addAttribute("selCompany", selCompany);
		model.addAttribute("primary", primary);
		model.addAttribute("secondary", secondary);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("deptTreeTopId", deptTreeTopId);
		model.addAttribute("primary", commonUtil.getPrimaryData(userInfo.getLang(), userInfo.getTenantId()));
		logger.debug("notiSelectReceiver ended");
		
		return "/ezNotification/notiSelectReceiver";
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ezNotification/sendEmergencyNoti.do", method=RequestMethod.POST)
	@ResponseBody
	public String sendEmergencyNoti(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, @RequestBody NotificationVO notiData) throws Exception {
		logger.debug("sendEmergencyNoti started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String gwServerUrl = config.getProperty("config.notificationGWServerURL");
		String senderId = userInfo.getId();
		String senderName = userInfo.getDisplayName();
		String notiContent = notiData.getNotiContent();
		String notiBody = notiData.getNotiBody();
		
		String result = "ok";
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		headers.set("Content-type", "application/json;charset=UTF-8");
		
		String emergencyContentUrl = "/rest/ezNotification/emergency/notiItem/" + senderId;
		
		JSONObject jsonEmergencyParam = new JSONObject();
		jsonEmergencyParam.put("notiBody", notiBody);
		jsonEmergencyParam.put("companyId", userInfo.getCompanyID());
		jsonEmergencyParam.put("notiContent", notiContent);
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.notificationGWServerURL"), emergencyContentUrl, null, request, "post", jsonEmergencyParam);
		long emergencyItemId = 0;
		String status = resultBody.get("status").toString();
		if (status.equals("ok")) {
			emergencyItemId = (long) resultBody.get("data");
			
			String notiSendUrl = gwServerUrl + "/rest/ezNotification/notiSend/" + senderId;
			List<Map<String, Object>> recipient = notiData.getRecipient();

			JSONObject jsonParam = new JSONObject();
			jsonParam.put("senderName", senderName);
			jsonParam.put("recipient", recipient);
			jsonParam.put("mainType", "NOTI");
			jsonParam.put("subType", "EMERGENCY");
			jsonParam.put("notiContent", notiContent);
			jsonParam.put("viewType", "layer");
			jsonParam.put("viewWidth", "700");
			jsonParam.put("viewHeight", "400");
			jsonParam.put("linkUrl", "/ezNotification/emergencyNotiItem.do?emergencyItemId=" + emergencyItemId);
			jsonParam.put("linkUrlMobile", "/mobile/ezNotification/emergencyNotiItem.do?emergencyItemId=" + emergencyItemId);
			jsonParam.put("etcData", "notChkSetting");
			
			HttpEntity<?> notiEntity = new HttpEntity<>(jsonParam.toJSONString(), headers);
			RestTemplate notirest = new RestTemplate();
			
			ResponseEntity<String> resultNoti = notirest.postForEntity(notiSendUrl, notiEntity, String.class);
			
			JSONParser jp = new JSONParser();
			JSONObject notiResultBody = (JSONObject) jp.parse(resultNoti.getBody());
			
			String notiStatus = notiResultBody.get("status").toString();
			if (!notiStatus.equals("ok")) {
				result = "false";
			}
		} else {
			result = "false";
		}
		
		logger.debug("sendEmergencyNoti end");
		
		return result;
	}
	
	@RequestMapping(value = "/ezNotification/emergencyNotiItem.do", method=RequestMethod.GET)
	public String emergencyNotiItem(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("emergencyNotiItem started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String emergencyItemId = request.getParameter("emergencyItemId");
		
		String userId = userInfo.getId();
		String companyId = userInfo.getCompanyID();
		String url = "/rest/ezNotification/user/get/emergency/item";
		
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("companyId", companyId);
		paramMap.put("userId", userId);
		paramMap.put("emergencyItemId", emergencyItemId);
		
		String adminFlag = "N";
		LoginVO adminChk = commonUtil.checkAdmin(loginCookie);
		if (adminChk != null) {
			adminFlag = "Y";
		}
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.notificationGWServerURL"), url, paramMap, request, "get", null);
		String status = resultBody.get("status").toString();
		JSONObject resultData = new JSONObject();
		if (status.equals("ok")) {
			resultData = (JSONObject) resultBody.get("data");
			model.addAttribute("emergencyNotiItem", resultData.get("emergencyNotiItem"));
		} else if (status.equals("empty")) {
			model.addAttribute("messageContent", egovMessageSource.getMessage("ezMain.delete.hth01", userInfo.getLocale()));
			logger.debug("emergencyNotiItem ended");
			return "/ezNotification/emergencyError";
		}
		
		model.addAttribute("adminFlag", adminFlag);
		model.addAttribute("userId", userInfo.getId());
		model.addAttribute("lang", commonUtil.getPrimaryData(userInfo.getLang(), userInfo.getTenantId()));
		
		logger.debug("emergencyNotiItem ended");
		return "/ezNotification/emergencyNotiItem";
	}
	
	@ResponseBody
	@RequestMapping(value = "/ezNotification/deleteEmergencyNoti.do", method=RequestMethod.POST)
	public String deleteEmergencyNoti(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("deleteEmergencyNoti started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String emergencyItemId = request.getParameter("notiId");
		
		String userId = userInfo.getId();
		String url = "/rest/ezNotification/user/delete/emergency/item";
		
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("userId", userId);
		paramMap.put("emergencyItemId", emergencyItemId);
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.notificationGWServerURL"), url, paramMap, request, "delete", null);
		String status = resultBody.get("status").toString();
		
		logger.debug("deleteEmergencyNoti ended");
		return status;
	}
	
	
}
