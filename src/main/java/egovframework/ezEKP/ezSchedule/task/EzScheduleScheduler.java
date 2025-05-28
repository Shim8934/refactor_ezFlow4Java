package egovframework.ezEKP.ezSchedule.task;

import java.net.URLEncoder;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.task.EzEmailScheduler;
import egovframework.ezEKP.ezEmail.util.EzEmailUtil;
import egovframework.ezEKP.ezSchedule.service.EzScheduleGoogleService;
import egovframework.ezEKP.ezSchedule.service.EzScheduleService;
import egovframework.ezEKP.ezSchedule.vo.ScheduleReminderVO;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.TenantVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Component
public class EzScheduleScheduler {
	
	@Autowired
	private EzEmailScheduler ezEmailScheduler;
	
	@Autowired
	private EzScheduleGoogleService googleService;
	
	@Autowired
	private CommonUtil commonUtil;
	
	private static final Logger logger = LoggerFactory.getLogger(EzScheduleScheduler.class);
	
	@Autowired
	private EzScheduleService ezScheduleService;

	@Autowired
	private EzCommonService ezCommonService;
	
	@Resource(name = "loginService")
    private LoginService loginService;
	
	@Autowired
	private Properties config;
	
	@Autowired
	private EzEmailUtil ezEmailUtil;
	
	@Scheduled(cron = "${config.cron.checkGoogleToken}")
	public void checkGoogleToken() throws Exception {
		logger.debug("checkGoogleToken started");
		
		//choose scheduler running server
		if (!ezEmailScheduler.preScheduler("checkGoogleToken")) {
			logger.debug("checkGoogleToken scheduler ended.");
			return;
		}
		
		googleService.checkGoogleToken("part");
		
		logger.debug("checkGoogleToken ended");
	}
	
	@Scheduled(cron = "${config.cron.checkReminder}")
	public void checkReminder() throws Exception {
		logger.debug("checkReminder started");
		
		String nowTimeStr = commonUtil.getTodayUTCTime("yyyy-MM-dd HH:mm");
		
		if (!ezEmailScheduler.preScheduler("checkReminder")) { 
			logger.debug("checkReminder ended."); 
			return; 
		}
		
		final int MAX_RETRIES = 3;
		
		List<TenantVO> tenantList = ezCommonService.getTenantList();
		for (TenantVO tenant : tenantList) {
			String dotNetTotalNotification = ezCommonService.getTenantConfig("dotNetTotalNotification", tenant.getTenantId());
			
			Map<String, List<ScheduleReminderVO>> returnMap = ezScheduleService.selectReminderScheList(nowTimeStr, tenant.getTenantId());
		    List<ScheduleReminderVO> reminderScheList = returnMap.get("reminderScheList");
		    
		    if (reminderScheList == null || reminderScheList.size() <= 0) {
				logger.debug("reminderScheList size is 0");
				logger.debug("checkReminder ended");
	        	return;
	        }
		    
			if (dotNetTotalNotification.equals("YES")) { // 닷넷 통합 알림 사용
				logger.debug("Remind by DotNetTotalNotification");
				String serverFlag = "dotNet";
			    try {
		            for (ScheduleReminderVO reminderSche : reminderScheList) {
		            	int retryCount = 0;
		            	String url = "/ezConn/scheduleRead.do?";
		            	int scheId = reminderSche.getScheduleId();
		            	int repeatcount = reminderSche.getRepeatCount();
		            	String date = reminderSche.getTodayDate();
		            	String type = reminderSche.getScheduleType();
		            	String datetype = reminderSche.getDateType();
		            	String startDate = reminderSche.getStartDate().substring(0,16);
		            	String endDate = reminderSche.getEndDate().substring(0,16);
		            	
		            	url += "scheduleid=" + scheId + "&repeatcount=" + repeatcount + "&date=" + date + "&type=" + type + "&datetype=" + datetype + "&startDate=" + startDate + "&endDate=" + endDate + "&mtype=monthList&serverFlag=" + serverFlag;
		            	boolean success = false;
		            	
		            	String primaryData = "";
		            	if (commonUtil.getPrimaryData(reminderSche.getLang(), reminderSche.getTenantId()).equals("1")) {
		            		primaryData = "1";
		            	} else {
		            		primaryData = "2";
		            	}
		            	
		            	String creatorName = primaryData.equals("1") ? reminderSche.getCreatorName() : reminderSche.getCreatorName2();
			            while (!success && retryCount < MAX_RETRIES) {
			            	try {
			            		String resultCode = "";
					    		
								String attendantIdParam = "userId=" + URLEncoder.encode(reminderSche.getOwnerId(), "UTF-8");
								String mainTypeParam = "type=" + URLEncoder.encode("schedule", "UTF-8");
								String subTypeParam = "subType=" + URLEncoder.encode("reminder", "UTF-8");
								String senderIdParam = "senderId=" + URLEncoder.encode(reminderSche.getCreatorId(), "UTF-8");
								String senderNameParam = "senderName=" + URLEncoder.encode(creatorName, "UTF-8");
							    
								String subjectParam = "subject=" + URLEncoder.encode(reminderSche.getTitle(), "UTF-8");
								String etcDataParam = "etcData=" + reminderSche.getScheduleId();
								String linkURLParam = "linkURL=" + URLEncoder.encode(url, "UTF-8");

								String mobileLinkURLParam = "mobileLinkURL=" + URLEncoder.encode(url, "UTF-8");
								String viewTypeParam = "viewType=" + URLEncoder.encode("popup", "UTF-8");
								String viewWidthParam = "viewWidth=" + URLEncoder.encode("730", "UTF-8");
								String viewHeightParam = "viewHeight=" + URLEncoder.encode("370", "UTF-8");
								
								String inputParams = attendantIdParam + "&" + mainTypeParam + "&" + subTypeParam + "&" + senderIdParam + "&";
							    inputParams += senderNameParam + "&" + subjectParam + "&" + etcDataParam + "&" + linkURLParam + "&";
							    inputParams += mobileLinkURLParam + "&" + viewTypeParam + "&" + viewWidthParam + "&" + viewHeightParam;
	            		
							    logger.debug("inputParams=" + inputParams);

								String requestURL = config.getProperty("config.JGwServerURL") + "/ezTalkGate/addNotificationETC";
								String webServiceResultResponse = ezEmailUtil.getWebServiceResult(requestURL, inputParams);

								logger.debug("response=" + webServiceResultResponse);

								if (webServiceResultResponse != null) {
									JSONParser jsonParser = new JSONParser();
									JSONObject responseObj = (JSONObject)jsonParser.parse(webServiceResultResponse);

									resultCode = (String)responseObj.get("resultCode");
									logger.debug("resultCode=" + resultCode);
								}	   
									   
		                        success = true;
			            	} catch (SQLException e) {
			            		logger.error(e.getMessage(), e);
			            		retryCount++;
			            		if (retryCount != MAX_RETRIES) {
			            			logger.debug("calling EZSP_NOTIFICATION_COMMON_INSERT AT checkReminder failed... retry " + retryCount);
			            			Thread.sleep(300);
			            		} else {
			            			logger.debug("calling EZSP_NOTIFICATION_COMMON_INSERT AT checkReminder failed after " + retryCount +"MaxRetryCounts. parameter(" +
			            			reminderSche.getOwnerId() + ", schedule, reminder, " + reminderSche.getCreatorId() + ", " + creatorName + ", "+
			            			reminderSche.getTitle() + ", " + reminderSche.getScheduleId() + ", " + url + ", " + url +", popup, 730, 370)");
			            		}
			            	}
			            }	
		            }
		        } catch (Exception e) { 
		        	logger.error(e.getMessage(), e);
		        }
			} else if(dotNetTotalNotification.equals("NO")){ // 자바 메일 알림 사용
				logger.debug("Remind by JavaMailNotice");
				for (ScheduleReminderVO reminderSche : reminderScheList) {
					try {
						ezScheduleService.sendReminderMail(reminderSche);
					} catch (Exception e) {
						logger.error(e.getMessage(), e);
						continue;
					}
				}
			}
			
			ezScheduleService.updateCompleteScheduleStatus(returnMap.get("reminderCompleteList"), tenant.getTenantId());
		}
		
		logger.debug("checkReminder ended");
	}
}