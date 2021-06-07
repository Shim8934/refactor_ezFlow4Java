package egovframework.ezEKP.ezSchedule.service.impl;

import java.io.IOException;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

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
import com.google.api.client.googleapis.javanet.GoogleNetHttpTransport;
import com.google.api.client.http.HttpTransport;
import com.google.api.client.json.JsonFactory;
import com.google.api.client.json.gson.GsonFactory;
import com.google.api.services.calendar.CalendarScopes;
import com.google.auth.oauth2.GoogleCredentials;
import com.google.auth.oauth2.UserCredentials;

import egovframework.ezEKP.ezSchedule.dao.EzScheduleDAO;
import egovframework.ezEKP.ezSchedule.service.EzScheduleGoogleService;
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
	
	private final Logger logger = LoggerFactory.getLogger(CalendarQuickstart.class);
	
    private final JsonFactory JSON_FACTORY = GsonFactory.getDefaultInstance();
    
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
		String redirectURI = config.getProperty("config.redirectURI");
		String clientSecret = config.getProperty("config.clientSecret");
		
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
    
}
    
    