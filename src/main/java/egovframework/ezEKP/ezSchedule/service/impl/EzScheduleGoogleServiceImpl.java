package egovframework.ezEKP.ezSchedule.service.impl;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.TimeZone;

import javax.annotation.Resource;

import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.google.api.client.auth.oauth2.AuthorizationCodeRequestUrl;
import com.google.api.client.auth.oauth2.TokenResponse;
import com.google.api.client.googleapis.auth.oauth2.GoogleAuthorizationCodeFlow;
import com.google.api.client.googleapis.auth.oauth2.GoogleClientSecrets;
import com.google.api.client.googleapis.auth.oauth2.GoogleClientSecrets.Details;
import com.google.api.client.googleapis.auth.oauth2.GoogleRefreshTokenRequest;
import com.google.api.client.googleapis.javanet.GoogleNetHttpTransport;
import com.google.api.client.http.HttpRequestInitializer;
import com.google.api.client.http.HttpTransport;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.JsonFactory;
import com.google.api.client.json.gson.GsonFactory;
import com.google.api.client.util.DateTime;
import com.google.api.services.calendar.CalendarScopes;
import com.google.api.services.calendar.model.Event;
import com.google.api.services.calendar.model.EventDateTime;
import com.google.auth.http.HttpCredentialsAdapter;
import com.google.auth.oauth2.AccessToken;
import com.google.auth.oauth2.GoogleCredentials;
import com.google.auth.oauth2.UserCredentials;

import egovframework.ezEKP.ezSchedule.dao.EzScheduleDAO;
import egovframework.ezEKP.ezSchedule.service.EzScheduleGoogleService;
import egovframework.ezEKP.ezSchedule.vo.ScheduleInfoVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleTokenInfoVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Service("EzScheduleGoogleService")
public class EzScheduleGoogleServiceImpl implements EzScheduleGoogleService {
	
	@Autowired
	private Properties config;
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Resource(name="EzScheduleDAO")
	private EzScheduleDAO ezScheduleDAO;
	
	private final Logger logger = LoggerFactory.getLogger(EzScheduleGoogleServiceImpl.class);
	private final String APPLICATION_NAME  = "ezSchedule";
    private final JsonFactory JSON_FACTORY = GsonFactory.getDefaultInstance();
    private com.google.api.services.calendar.Calendar service;
    private HttpTransport httpTransport = null;
    GoogleAuthorizationCodeFlow flow  = null;
    GoogleClientSecrets clientSecrets = null;
    
	@Override
	public String getIsSync(LoginVO userInfo) throws Exception {
		String sync = ezScheduleDAO.getIsSync(userInfo);
		logger.debug("sync : " + sync);
		return sync;
	}
    
	@Override
    public String authorize() throws Exception {
		String clientId = config.getProperty("config.clientId");
		String clientSecret = config.getProperty("config.clientSecret");
		String redirectURI = config.getProperty("config.redirectURI");
		
		AuthorizationCodeRequestUrl authorizationUrl = null;
		if (flow == null) {
			Details web = new Details();
			web.setClientId(clientId);
			web.setClientSecret(clientSecret);
			clientSecrets = new GoogleClientSecrets().setWeb(web);
			httpTransport = GoogleNetHttpTransport.newTrustedTransport();
			flow = new GoogleAuthorizationCodeFlow.Builder(httpTransport, JSON_FACTORY, clientSecrets,
					Collections.singleton(CalendarScopes.CALENDAR)).setAccessType("offline").build();
		}
		
		authorizationUrl  = flow.newAuthorizationUrl().setRedirectUri(redirectURI);
		String requestURL = authorizationUrl.build() + "&prompt=consent";
		logger.debug("Google Calendar Authorization Url->" + requestURL);
		return requestURL;
    }
    
	@Override
	@SuppressWarnings("unchecked")
	public JSONObject getReturnMessage(String code, String userID, String companyID, int tenantID) {
		String redirectURI = config.getProperty("config.redirectURI");
		
		JSONObject result = new JSONObject();
		
		try {
			TokenResponse response = flow.newTokenRequest(code).setRedirectUri(redirectURI).execute();
			String googleAccessToken  = response.getAccessToken();
			String googleRefreshToken = response.getRefreshToken();
			
			logger.debug("AccessToken  : " + googleAccessToken);
			logger.debug("RefreshToken : " + googleRefreshToken);
			
			result.put("googleAccessToken", googleAccessToken);
			result.put("googleRefreshToken", googleRefreshToken);
			result.put("code", 0);
		} catch (Exception e) {
			logger.warn("Exception while handling OAuth2 callback (" + e.getMessage() + ")." + " Redirecting to google connection status page.");
			String message = "Exception while handling OAuth2 callback (" + e.getMessage() + ")." + " Redirecting to google connection status page.";
			result.put("code", 1);
			result.put("errorMessage", message);
		}
		
		return result;
	}

    @Override
	public List<ScheduleInfoVO> getGoogleScheduleList(String startDate, String endDate, LoginVO userinfo, String memberId, String scheduleFlag, String memberName) throws Exception { 
		logger.debug("getGoogleScheduleList started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", userinfo.getId());
		map.put("v_COMPANYID", userinfo.getCompanyID());
		map.put("v_TENANTID", userinfo.getTenantId());
		
		ScheduleTokenInfoVO token = ezScheduleDAO.getScheduleTokenInfo(map);
		
		if (token != null && token.getGoogleAccessToken() != null && token.getGoogleRefreshToken() != null) {
			List<ScheduleInfoVO> resultList = new ArrayList<ScheduleInfoVO>();
			try {
				buildCalendarService(userinfo);
				
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				
				DateTime date1 = new DateTime(sdf.parse(startDate), TimeZone.getDefault());
				DateTime date2 = new DateTime(sdf.parse(endDate), TimeZone.getDefault());
		
				com.google.api.services.calendar.Calendar.Events events = service.events(); 
				
				com.google.api.services.calendar.model.Events eventList; 
				eventList = events.list("primary").setTimeMin(date1).setTimeMax(date2).execute();//.setSingleEvents(true)
				eventList.getNextSyncToken();
				
				List<Event> items = eventList.getItems();
				if (items.isEmpty()) {
					logger.debug("No upcoming events found.");
				} else {
					for (Event event : items) {
						logger.debug("event: " + event.toString());
		
						ScheduleInfoVO svo = new ScheduleInfoVO();
						svo.setScheduleId(event.getId()); // 구글일정아이디
						svo.setOwnerId(scheduleFlag.equals("member") ? memberId : userinfo.getId());
						if (scheduleFlag.equals("member")) {
							svo.setOwnerName(memberName);
						} else {
							svo.setOwnerName(scheduleFlag.equals("mobile") ? userinfo.getDisplayName1() : userinfo.getDisplayName());
						}
						svo.setOwnerName2(userinfo.getDisplayName2());
						svo.setCreatorId(scheduleFlag.equals("member") ? memberId : userinfo.getId());
						if (scheduleFlag.equals("member")) {
							svo.setCreatorName(memberName);
						} else {
							svo.setCreatorName(scheduleFlag.equals("mobile") ? userinfo.getDisplayName1() : userinfo.getDisplayName());
						}
						svo.setCreatorName2(userinfo.getDisplayName2());
						svo.setModifierId(scheduleFlag.equals("member") ? memberId : userinfo.getId());
						if (scheduleFlag.equals("member")) {
							svo.setModifierName(memberName);
						} else {
							svo.setModifierName(scheduleFlag.equals("mobile") ? userinfo.getDisplayName1() : userinfo.getDisplayName());
						}
						svo.setModifierName2(userinfo.getDisplayName2());
						
						String isPublic = "Y";
						if (event.getVisibility() != null && (event.getVisibility().equals("private") || event.getVisibility().equals("confidential"))) {
							isPublic = "N";
						}
						svo.setCreateDate(sdf.format(event.getCreated().getValue()));
						svo.setIsPublic(isPublic);
						svo.setScheduleType("1");
						svo.setTitle(event.getSummary() == null ? "(No Title)" : event.getSummary());
						svo.setLocation(event.getLocation());
						svo.setImportance("2");
						svo.setScheduleFlag("google");
						
						EventDateTime googleStartDate = event.getStart();
						
						if (event.getStart().getDate() == null) {
							svo.setDateType("1");
							long googleStartUTCTime    = googleStartDate.getDateTime().getValue() - (googleStartDate.getDateTime().getTimeZoneShift() * 60000L);
							String googleStartDateTime = sdf.format(googleStartUTCTime);
							String utcStartDateTime    = commonUtil.getDateStringInUTC(googleStartDateTime, userinfo.getOffset(), false);
							svo.setStartDate(utcStartDateTime);
							EventDateTime googleEndDate = event.getEnd();
							long googleEndUTCTime       = googleEndDate.getDateTime().getValue() - (googleStartDate.getDateTime().getTimeZoneShift() * 60000L);
							String googleEndDateTime    = sdf.format(googleEndUTCTime);
							String utcEndDateTime       = commonUtil.getDateStringInUTC(googleEndDateTime, userinfo.getOffset(), false);
							svo.setEndDate(utcEndDateTime);
						} else {
							svo.setDateType("2");
							String googleStartAllDate = sdf.format(event.getStart().getDate().getValue());
							String utcStartDate = commonUtil.getDateStringInUTC(googleStartAllDate, userinfo.getOffset(), true);
							svo.setStartDate(utcStartDate);
							svo.setEndDate(utcStartDate);
						}
						
						resultList.add(svo);
				    }
				}
				logger.debug("getGoogleScheduleList ended ==> success");
			} catch (IOException e) {
				e.printStackTrace();
				logger.debug("getGoogleScheduleList ended ==> error");
				return null;
			}
			return resultList;
		} else {
			logger.debug("getGoogleScheduleList ended ==> no sync user");
			return null;
		}
		
	}
	
	private void buildCalendarService(LoginVO userInfo) throws Exception {
		String clientId = config.getProperty("config.clientId");
		String clientSecret = config.getProperty("config.clientSecret");
		
		try {
			HttpTransport httpTransport = new NetHttpTransport(); 
			
			Map<String, Object> map = new HashMap<String, Object>();		
			map.put("v_USERID", userInfo.getId()); 
			map.put("v_COMPANYID", userInfo.getCompanyID());
			map.put("v_TENANTID", userInfo.getTenantId());
			
			ScheduleTokenInfoVO token = ezScheduleDAO.getScheduleTokenInfo(map);
			
			AccessToken tokens = new AccessToken(token.getGoogleAccessToken(), new Date());
			GoogleCredentials credential = UserCredentials.newBuilder()
											.setClientId(clientId)
											.setClientSecret(clientSecret)
											.setRefreshToken(token.getGoogleRefreshToken())
											.setAccessToken(tokens)
											.build();
			
			HttpRequestInitializer initializer = new HttpCredentialsAdapter(credential);
			
			service = new com.google.api.services.calendar.Calendar.Builder(httpTransport, JSON_FACTORY, initializer) 
						.setApplicationName(APPLICATION_NAME).build(); 
			
			logger.debug("user : " + userInfo.getId());
			logger.debug("accessToken : " + credential.getAccessToken());
			logger.debug("refreshToken : " + token.getGoogleRefreshToken());
			logger.debug("buildCalendarService success");
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	@Override
    public void checkGoogleToken(String type) throws Exception {
    	String clientId = config.getProperty("config.clientId");
    	String clientSecret = config.getProperty("config.clientSecret");
    	
    	String todayUtcTime = commonUtil.getTodayUTCTime("yyyy-MM-dd HH:mm:ss");
    	logger.debug("Google Check todayUtcTime : " + todayUtcTime);
    	
    	Map<String, Object> map = new HashMap<>();
		map.put("v_TODAYUTCTIME", todayUtcTime);
		
		List<ScheduleTokenInfoVO> tokenList;
		if (type.equals("all")) {
			tokenList = ezScheduleDAO.getAllGoogleToken(map);
		} else {
			tokenList = ezScheduleDAO.getExpiredGoogleToken(map);
		}
		
		for (ScheduleTokenInfoVO token : tokenList) {
			TokenResponse response = null;
			try {
				logger.debug("만료된 userId: " + token.getUserID());
				logger.debug("old accessToken : " + token.getGoogleAccessToken());
				
				response = new GoogleRefreshTokenRequest(new NetHttpTransport(), new GsonFactory(), token.getGoogleRefreshToken(), clientId, clientSecret).execute();
				
				logger.debug("new accessToken : " + response.getAccessToken());
				
				updateGoogleAccessTokenInfo(response.getAccessToken(), token.getUserID(), token.getCompanyID(), token.getTenantID());
			} catch (Exception e) {
				e.printStackTrace();
				logger.debug("accessToken refresh error : " + response.toPrettyString());
			}
		}
    }
    
    public void updateGoogleAccessTokenInfo(String accessToken, String userID, String companyID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_TODAYUTCTIME", commonUtil.getTodayUTCTime("yyyy-MM-dd HH:mm:ss"));
		map.put("v_GOOGLEACCESSTOKEN", accessToken);
		map.put("v_USERID", userID);
		map.put("v_COMPANYID", companyID);
		map.put("v_TENANTID", tenantID);
		
		ezScheduleDAO.updateGoogleTokenInfo(map);
	}
}
    
    