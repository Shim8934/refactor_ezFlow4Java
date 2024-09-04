package egovframework.ezEKP.ezNotification.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONArray;
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
import egovframework.ezEKP.ezNotification.service.EzNotificationService;
import egovframework.ezEKP.ezNotification.vo.EmergencyNotiPermissionVO;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Controller
public class EzNotificationAdminController {
	
    private static final Logger logger = LoggerFactory.getLogger(EzNotificationAdminController.class);
    
	@Autowired
	private CommonUtil commonUtil;
	
	@Resource(name = "EzCommonService")
	private EzCommonService ezCommonService;
	
	@Resource(name = "EzNotificationService")
	private EzNotificationService ezNotificationService;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Autowired
	private Properties config;
	
	@RequestMapping(value = "/admin/ezNotification/notificationMain.do", method=RequestMethod.GET, produces = "application/json;charset=utf-8")
	public String notificationMain(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("admin notificationMain started");
		//관리자 권한체크
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
				
		logger.debug("admin notificationMain ended");
		
		return "/admin/ezNotification/notificationMain";
	}
	
	@RequestMapping(value = "/admin/ezNotification/notificationLeft.do", method=RequestMethod.GET, produces = "application/json;charset=utf-8")
	public String notificationLeft(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("admin notificationLeft started");
		//관리자 권한체크
		logger.debug("admin notificationLeft ended");
		
		return "/admin/ezNotification/notificationLeft";
	}
	
	@RequestMapping(value = "/admin/ezNotification/notiSetting.do", method=RequestMethod.GET, produces = "application/json;charset=utf-8")
	public String notiSetting(HttpServletRequest request, Model model, @CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("admin notiSetting started");
			
		LoginVO user = commonUtil.checkAdmin(loginCookie);
		//관리자 권한 체크
		if (user == null) {
			return "cmm/error/adminDenied";
		}

		String notiStoragePeriod = ezCommonService.getTenantConfig("notiStoragePeriod", user.getTenantId());
		model.addAttribute("notiStoragePeriod", notiStoragePeriod);

		logger.debug("notiSetting ended.");
		
		return "/admin/ezNotification/storageSetting";
	}
	
	// 2024-04-01 한태훈 - 관리자 > 알림 보관기간 수정
	@ResponseBody
	@RequestMapping(value = "/admin/ezNotification/updateStoragePeriod.do", method=RequestMethod.POST)
	public String updateStoragePeriod(@CookieValue String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("updateStoragePeriod started.");
		//관리자 권한체크
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		try {
			String storagePeriod = request.getParameter("storagePeriod");
			ezNotificationService.updateStoragePeriod(storagePeriod, userInfo.getTenantId());
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			logger.debug("updateStoragePeriod ended.");
			return "fail";
		}

		logger.debug("updateStoragePeriod ended.");
		return "success";
	}
	

	@RequestMapping(value = "/admin/ezNotification/emergencyNotiSetting.do", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public String emergencyNotiSetting(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception{
		logger.debug("emergencyNotiSetting started.");
		
		//관리자 권한체크
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		logger.debug("emergencyNotiSetting ended.");
		return "/admin/ezNotification/emergencyNotiSetting";
	}
	
	@ResponseBody
	@RequestMapping(value = "/admin/ezNotification/getEmergencyNotiPermissions.do", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public String getEmergencyNotiPermissions(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception{
		logger.debug("getEmergencyNotiPermissions started.");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String result = "";
		String userId = userInfo.getId();
		String companyId = request.getParameter("companyId");
		String url = "/rest/ezNotification/company/list/emergency/permission/" + userId + "?companyId=" + companyId;
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.portalGwServerURL"), url, null, request, "get", null);
		String status = resultBody.get("status").toString();

		if (status.equals("ok")) {
			result = (String) resultBody.get("data");
		}
		
		logger.debug("getEmergencyNotiPermissions ended.");
		return result;
	}
	
	@RequestMapping(value = "/admin/ezNotification/selectTargetGroup.do", method = RequestMethod.GET)
	public String selectTargetGroup(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		logger.debug("selectTargetGroup started");

		LoginVO user = commonUtil.userInfo(loginCookie);
		String topId = request.getParameter("companyId");
		
		model.addAttribute("topid", topId);
		model.addAttribute("primary", user.getPrimary());
		model.addAttribute("companyID", topId);
		
		logger.debug("selectTargetGroup ended");
		return "/admin/ezNotification/selectTargetGroup";
	}
	
	@SuppressWarnings("unchecked")
	@ResponseBody
	@RequestMapping(value = "/admin/ezNotification/addEmergencyPermission.do", method = RequestMethod.POST)
	public String addEmergencyPermission(@CookieValue("loginCookie") String loginCookie, @RequestBody List<EmergencyNotiPermissionVO> dataList, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		logger.debug("addEmergencyPermission started");
		
		LoginVO user = commonUtil.userInfo(loginCookie);
		String userId = user.getId();
		String url = config.getProperty("config.notificationGWServerURL") + "/rest/ezNotification/emergency/add/permissions/" + userId;
		
		JSONArray jsonArray = new JSONArray();
		for (EmergencyNotiPermissionVO item : dataList) {
		    JSONObject itemObject = new JSONObject();
		    itemObject.put("cn", item.getCn());
		    itemObject.put("displayName", item.getDisplayName());
		    itemObject.put("displayName2", item.getDisplayName2());
		    itemObject.put("userType", item.getUserType());
		    itemObject.put("deptId", item.getDeptId());
		    itemObject.put("jobId", item.getJobId());
		    itemObject.put("roleId", item.getRoleId());
		    itemObject.put("companyId", item.getCompanyId());
		    itemObject.put("subDeptYn", item.getSubDeptYn());
		    jsonArray.add(itemObject);
		}
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(jsonArray, headers);

		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url);
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.POST, entity, String.class);
		
		JSONParser jp = new JSONParser();
		
		JSONObject resultBody = null;
		
		resultBody = (JSONObject) jp.parse(result.getBody());
		
		String status = resultBody.get("status").toString();

		logger.debug("addEmergencyPermission ended");
		return status;
	}
	
	@SuppressWarnings("unchecked")
	@ResponseBody
	@RequestMapping(value = "/admin/ezNotification/deleteEmergencyPermission.do", method = RequestMethod.POST)
	public String deleteEmergencyPermission(@CookieValue("loginCookie") String loginCookie, @RequestBody List<EmergencyNotiPermissionVO> dataList, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		logger.debug("deleteEmergencyPermission started");
		
		LoginVO user = commonUtil.userInfo(loginCookie);
		String userId = user.getId();
		String companyId = request.getParameter("companyId");
		String url = config.getProperty("config.notificationGWServerURL") + "/rest/ezNotification/emergency/delete/permissions/" + userId;
		
		JSONArray jsonArray = new JSONArray();
		for (EmergencyNotiPermissionVO item : dataList) {
		    JSONObject itemObject = new JSONObject();
		    itemObject.put("permissionCode", item.getPermissionCode());
		    jsonArray.add(itemObject);
		}
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(jsonArray, headers);

		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("companyId",companyId);
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.DELETE, entity, String.class);
		
		JSONParser jp = new JSONParser();
		
		JSONObject resultBody = null;
		
		resultBody = (JSONObject) jp.parse(result.getBody());
		
		String status = resultBody.get("status").toString();

		logger.debug("deleteEmergencyPermission ended");
		return status;
	}
	
	@ResponseBody
	@RequestMapping(value = "/admin/ezNotification/getEmergencyContent.do", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public String getEmergencyContent(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception{
		logger.debug("getEmergencyContent started.");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();
		String companyId = request.getParameter("companyId");
		String url = "/rest/ezNotification/company/get/emergency/content";
		String result = "";
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("companyId", companyId);
		paramMap.put("userId", userId);
		JSONObject resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.notificationGWServerURL"), url, paramMap, request, "get", null);
		String status = resultBody.get("status").toString();
		if (status.equals("ok")) {
			result = (String) resultBody.get("data");
		}
		logger.debug("getEmergencyContent ended.");
		return result;
	}
	
	@ResponseBody
	@RequestMapping(value = "/admin/ezNotification/addEmergencyCompanyContent.do", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	public String addEmergencyCompanyContent(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception{
		logger.debug("addEmergencyCompanyContent started.");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String userId = userInfo.getId();
		String companyId = request.getParameter("companyId");
		String emergencyContent = request.getParameter("emergencyContent");
		String url = "/rest/ezNotification/company/add/emergency/content";
		
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("companyId", companyId);
		paramMap.put("userId", userId);
		paramMap.put("emergencyContent", emergencyContent);
		
		JSONObject resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.notificationGWServerURL"), url, paramMap, request, "post", null);
		String status = resultBody.get("status").toString();

		logger.debug("addEmergencyCompanyContent ended.");
		return status;
	}
	
}
