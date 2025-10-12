package egovframework.ezEKP.ezNotification.task;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.List;
import java.util.Properties;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezNotification.service.EzNotificationService;
import egovframework.let.user.login.vo.TenantVO;

@Component
public class EzNotificationScheduler {
	
	private static final Logger logger = LoggerFactory.getLogger(EzNotificationScheduler.class);
	
	@Autowired
	private Properties config;
	
	@Autowired
	private EzNotificationService ezNotificationService;
	
	@Autowired
	private EzCommonService ezCommonService;

	// 2024-03-28 한태훈 - 통합알림 > 보관기간 지난 알림 삭제
	@Scheduled(cron = "${config.cron.deleteOldNotification}")
	public void deleteOldNotification() throws Exception {
		logger.debug("deleteOldNotification started");
		
		//choose scheduler running server
		if (!preScheduler("ezportal_deleteOldNotification")) {
			logger.debug("deleteOldNotification scheduler ended.");
			return;
		}
		
		List<TenantVO> tenantList = ezCommonService.getTenantList();
		for (TenantVO tenantVO : tenantList) {
			String notiStoragePeriod = ezCommonService.getTenantConfig("notiStoragePeriod", tenantVO.getTenantId());
			ezNotificationService.deleteOldNotification(notiStoragePeriod, tenantVO.getTenantId());
		}
		
		logger.debug("deleteOldNotification ended");
	}
	
	public boolean preScheduler(String scheduler) {
		logger.debug("preScheduler started.");
		
		boolean isSchedulerServer = false;
		
		if (config.getProperty("config.Run_Scheduler").equals("YES")) {
			logger.debug("Elect scheduler server.");
			try {
				//set SchedulerServer
				String server = config.getProperty("config.SchedulerServer");
								
				String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaAccess/setSchedulerServer";
				
				String schedulerParam = "scheduler=" + URLEncoder.encode(scheduler, "UTF-8");
				String serverParam = "server=" + URLEncoder.encode(server, "UTF-8");
				
				String inputParams = schedulerParam + "&" + serverParam;
				logger.debug("inputParams=" + inputParams);
				
				String response = getWebServiceResult(requestURL, inputParams);		
				logger.debug("response=" + response);
				
				//sleep 20 seconds
				logger.debug(scheduler + " is sleeping...");
				Thread.sleep(20000);
				
				//get SchedulerServer
				requestURL = config.getProperty("config.JGwServerURL") + "/jMochaAccess/getSchedulerServer";
				
				inputParams = schedulerParam;
				logger.debug("inputParams=" + inputParams);
				
				response = getWebServiceResult(requestURL, inputParams);
				logger.debug("response=" + response);
				
				JSONParser parser = new JSONParser();
				JSONObject object = (JSONObject)parser.parse(response);
		        
		        if (object.get("resultCode").equals("OK") && ((Long)object.get("reasonCode")).intValue() == 0) {
		        	String schedulerServer = (String)object.get("result");
		        	
		        	if (schedulerServer.equals(server)) {
		        		isSchedulerServer = true;
		        		logger.debug("This is elected as a scheduler server.");
		        	} else {
		        		logger.debug("This is not elected.");
		        	}
		        } else {
		        	logger.error("Cannot get SchedulerServer.");
		        }
				
			} catch (Exception e) {
				logger.error(e.getMessage(), e);
			}
		} else {
			logger.debug("config.Run_Scheduler property is not YES.");
		}
		
		logger.debug("preScheduler ended.");
		
		return isSchedulerServer;
	}
	
	public String getWebServiceResult(String urlString, String inputParams) throws Exception {
		logger.debug("urlString=" + urlString);
		
		String result = null;
		
		URL url = new URL(urlString);
		HttpURLConnection conn = null;
		BufferedReader br = null;
				
		try {
			conn = (HttpURLConnection) url.openConnection();
			
			// POST 방식으로 요청한다.
			conn.setDoOutput(true);
			conn.setRequestMethod("POST");
			conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded; charset=utf-8");	
			
			// 입력 패러메터값이 있는 경우엔 HTTP Body로 출력한다.
			if (inputParams != null) {
				OutputStream os = conn.getOutputStream();
				// UTF-8로 인코딩한다.
				os.write(inputParams.getBytes("UTF-8"));
				os.flush();
			}
			
			if (conn.getResponseCode() == HttpURLConnection.HTTP_OK) {
				// Response Body를 UTF-8로서 디코딩한다.			
				br = new BufferedReader(
							new InputStreamReader(conn.getInputStream(),"UTF-8")
							);
	
				StringBuilder sb = new StringBuilder();
				String output;
				
				while ((output = br.readLine()) != null) {
					sb.append(output);
				}
				
				result = sb.toString();
				
				conn.disconnect();		
				conn = null;
			} else {
				Exception e = new RuntimeException("Failed : HTTP error code : " + conn.getResponseCode());			
				
				throw e;
			} 
		} finally {
			if (br != null) {
				br.close();
			}
			
			if (conn != null) {
				conn.disconnect();
				conn = null;
			}
		}
		
		return result;
	}    
}