package egovframework.ezEKP.ezNotification.web;

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
	
	// 2024-03-28 한태훈 - 통합알림 > 통합알림 전송.
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ezNotification/notiSend.do", method=RequestMethod.POST)
	@ResponseBody
	public JSONObject sendNoti(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, @RequestBody NotificationVO notiData) throws Exception {
		logger.debug("sendNoti started");
		
		String gwServerUrl = config.getProperty("config.notificationGWServerURL");
		String senderId = notiData.getSenderId();
		String url = gwServerUrl + "/rest/ezNotification/notiSend/" + senderId;
		String recipientIdList = notiData.getRecipientIdList();
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
	@RequestMapping(value = "/ezNotification/searchNoti.do", method=RequestMethod.GET)
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
	@RequestMapping(value = "/ezNotification/getUnreadNotiCnt.do", method=RequestMethod.GET)
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
	@RequestMapping(value = "/ezNotification/getNewNotiCnt.do", method=RequestMethod.GET)
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
	
}
