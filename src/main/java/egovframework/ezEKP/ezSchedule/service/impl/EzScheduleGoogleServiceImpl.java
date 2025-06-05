package egovframework.ezEKP.ezSchedule.service.impl;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Properties;
import java.util.TimeZone;
import java.util.stream.Collectors;

import javax.annotation.Resource;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
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
import com.ibm.icu.util.Calendar;

import egovframework.ezEKP.ezSchedule.dao.EzScheduleDAO;
import egovframework.ezEKP.ezSchedule.service.EzScheduleGoogleService;
import egovframework.ezEKP.ezSchedule.vo.ScheduleInfoVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleTokenInfoVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.lang3.StringUtils;
import org.dmfs.rfc5545.recur.RecurrenceRule;
import org.dmfs.rfc5545.recur.RecurrenceRule.WeekdayNum;

@Service("EzScheduleGoogleService")
public class EzScheduleGoogleServiceImpl extends EgovAbstractServiceImpl implements EzScheduleGoogleService {
	
	@Autowired
	private Properties config;
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Resource(name="EzScheduleDAO")
	private EzScheduleDAO ezScheduleDAO;
	
	private final Logger logger = LoggerFactory.getLogger(EzScheduleGoogleServiceImpl.class);
	private final String APPLICATION_NAME  = "ezSchedule";
    private final JsonFactory JSON_FACTORY = GsonFactory.getDefaultInstance();
    private final String GOOGLE_SCHEDULE_TYPE  = "9";
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
	public List<ScheduleInfoVO> getGoogleScheduleList(String startDate, String endDate, String keyword, LoginVO userinfo, String memberId, String scheduleFlag, String memberName) throws Exception { 
		logger.debug("getGoogleScheduleList started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", userinfo.getId());
		map.put("v_COMPANYID", userinfo.getCompanyID());
		map.put("v_TENANTID", userinfo.getTenantId());
		
		ScheduleTokenInfoVO token = ezScheduleDAO.getScheduleTokenInfo(map);
		
		List<ScheduleInfoVO> resultList = new ArrayList<ScheduleInfoVO>();
		if (token != null && token.getGoogleAccessToken() != null && token.getGoogleRefreshToken() != null) {
			List<ScheduleInfoVO> delResultList = new ArrayList<ScheduleInfoVO>();
			List<ScheduleInfoVO> partResultList = new ArrayList<ScheduleInfoVO>();
			try {
				buildCalendarService(userinfo);
				
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				
				DateTime date1 = new DateTime(sdf.parse(startDate), TimeZone.getDefault());
				DateTime date2 = new DateTime(sdf.parse(endDate), TimeZone.getDefault());
		
				com.google.api.services.calendar.Calendar.Events events = service.events(); 
				
				com.google.api.services.calendar.model.Events eventList; 
				eventList = events.list("primary").setTimeMin(date1).setTimeMax(date2).setQ(keyword).execute();//.setSingleEvents(true)
				eventList.getNextSyncToken();
				
				List<Event> items = eventList.getItems();
				if (items.isEmpty()) {
					logger.debug("No upcoming events found.");
				} else {
					logger.debug("Upcoming googleEvents size : " + items.size());
					// 삭제된 반복일정 -> 하루 일정 -> 반복일정 구현하면서 삭제된 일정의 경우 제외하기 -> 수정된 일정에 대해 변경해주기
					List<Event> deletedRepetition = items.stream().filter(s -> s.getRecurringEventId() != null).filter(s->"cancelled".equals(s.getStatus())).collect(Collectors.toList()); 
					List<Event> partUpdate = items.stream().filter(s -> s.getRecurringEventId() != null).filter(s->"confirmed".equals(s.getStatus())).collect(Collectors.toList());
					List<Event> insert = items.stream().filter(s -> s.getRecurringEventId() == null).filter(s->"confirmed".equals(s.getStatus())).collect(Collectors.toList()); 
					
					for(Event event : deletedRepetition) {
						ScheduleInfoVO deleteEvent = convertEventForDelSchedule(userinfo, event);
						delResultList.add(deleteEvent);
					}
					for(Event event : partUpdate) {
						ScheduleInfoVO partUpdateEvent = convertEvent(userinfo, event);
						partResultList.add(partUpdateEvent);
					}
					for(Event event : insert) {
						ScheduleInfoVO insertEvent = convertEvent(userinfo, event);
						if(insertEvent.getRepetition() != null) {
							List<ScheduleInfoVO> partUpdateEvent = convertEventForPartUpdate(userinfo, insertEvent, partResultList, delResultList, startDate, endDate);
							resultList.addAll(partUpdateEvent);
						} else {
							resultList.add(insertEvent);
						}
					}
					
					// 삭제된 반복일정 정보에 대해 반영
					for(ScheduleInfoVO svo : delResultList) {
						resultList = resultList.stream()
												.filter(x -> !x.getGoogleId().equals(svo.getGoogleRecurringEventId()) && !x.getStartDate().equals(svo.getStartDate())).collect(Collectors.toList());
					}
					
					// 수정된 반복일정 중 기본 일정 정보가 없는 반복일정에 대해 반영
					for(ScheduleInfoVO svo : resultList) {
						partResultList = partResultList.stream().filter(x -> !x.getGoogleRecurringEventId().equals(svo.getGoogleId()) && !x.getStartDate().equals(svo.getStartDate())).collect(Collectors.toList());
					}
					resultList.addAll(partResultList);
					
				}
				logger.debug("getGoogleScheduleList ended ==> success");
			} catch (IOException e) {
				logger.error(e.getMessage(), e);
				logger.debug("getGoogleScheduleList ended ==> error");
			}
		} else {
			logger.debug("getGoogleScheduleList ended ==> no sync user");
		}
		return resultList;
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
			logger.error(e.getMessage(), e);
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
				// 2023-05-17 이사라 : NullPointerException 시큐어코딩
				String responseValue = Objects.isNull(response) ? "" : response.toPrettyString();
				logger.error(e.getMessage(), e);
				logger.debug("accessToken refresh error : " + responseValue);
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
	
	private ScheduleInfoVO convertEvent(LoginVO userInfo, Event event) throws Exception {
		ScheduleInfoVO svo = new ScheduleInfoVO();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		
		svo.setScheduleId(event.getId());
		svo.setGoogleId(event.getId()); // 구글일정아이디		
		svo.setScheduleType(GOOGLE_SCHEDULE_TYPE); // google type fixed		
		svo.setTitle(event.getSummary() != null && !event.getSummary().equals("") ? event.getSummary() : "(No Title)");		
		svo.setLocation(event.getLocation() != null ? (event.getLocation().length() > 49 ? event.getLocation().substring(0,49) : event.getLocation()) : null); // 50자까지만		
		
		svo.setOwnerId(userInfo.getId());
		svo.setOwnerName(userInfo.getDisplayName());
		svo.setOwnerName2(userInfo.getDisplayName2());
		
		svo.setCreatorId(userInfo.getId());
		svo.setCreatorName(userInfo.getDisplayName());
		svo.setCreatorName2(userInfo.getDisplayName2());
		
		svo.setModifierId(userInfo.getId());
		svo.setModifierName(userInfo.getDisplayName());
		svo.setModifierName2(userInfo.getDisplayName2());
		
		svo.setIsPublic(checkPublic(event) ? "N" : "Y");
		svo.setImportance("2");
		
		svo.setCreateDate(sdf.format(event.getCreated().getValue()));
		svo.setModifyDate(sdf.format(event.getUpdated().getValue()));
		
		setGoogleDate(event, svo, userInfo);		
			
		svo.setContent(event.getDescription());
		svo.setScheduleFlag("google");
		
		if (event.getRecurringEventId() != null) {
			svo.setGoogleRecurringEventId(event.getRecurringEventId());
			String updatedStartDate = "";
			boolean isAllday = (event.getOriginalStartTime().getDate() != null) ? true : false;
			DateTime originalStartTime = isAllday ? event.getOriginalStartTime().getDate() : event.getOriginalStartTime().getDateTime();
			updatedStartDate = sdf.format(originalStartTime.getValue()); 
			if (isAllday) {
				svo.setGoogleOriginalStartTime(originalStartTime + " 00:00:00");
			} else {
				svo.setGoogleOriginalStartTime(updatedStartDate);
			}
		}
		
		return svo;
	}
	
	private ScheduleInfoVO convertEventForDelSchedule(LoginVO userInfo, Event event) throws Exception {
		ScheduleInfoVO svo = new ScheduleInfoVO();
		
		logger.debug("DEL GOOGLE ID : " + event.getId());
		svo.setScheduleId(event.getId());
		svo.setGoogleId(event.getId());
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		
		boolean isAllday = (event.getOriginalStartTime().getDate() != null) ? true : false;
		DateTime originalStartTime = isAllday ? event.getOriginalStartTime().getDate() : event.getOriginalStartTime().getDateTime();
		String startDate = sdf.format(originalStartTime.getValue()); 
		
		svo.setStartDate(startDate);
		svo.setGoogleRecurringEventId(event.getRecurringEventId());
		
		return svo;
	}
	
	private List<ScheduleInfoVO> convertEventForPartUpdate(LoginVO userinfo, ScheduleInfoVO vo, List<ScheduleInfoVO> tList, List<ScheduleInfoVO> rList, String orgStartDate, String orgEndDate) throws Exception {
		List<ScheduleInfoVO> resultList = new ArrayList<ScheduleInfoVO>();
		List<ScheduleInfoVO> tempResultList = new ArrayList<ScheduleInfoVO>();
		
		String endDate = vo.getEndDate();
		String[] info = vo.getRepetition().split("\\|");
		if (!info[0].equals("0")) {
			endDate = orgEndDate;
		}
		if (endDate.compareTo(orgEndDate) > 0) {
			endDate = orgEndDate;
		}
		
		int maxCount = Integer.parseInt(info[0]);
		int count = 0;
		boolean isFirst = true;
		
		if (maxCount == 0) {
			maxCount = -1;
		}
										
		Calendar date_cal = Calendar.getInstance();
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
		SimpleDateFormat nsdf = new SimpleDateFormat("yyyy-MM-dd");
		
		Date scheduleStartDate = sdf.parse(vo.getStartDate());
		
		date_cal.setTime(scheduleStartDate);
		
		Calendar scheduleCalendar = Calendar.getInstance();
		scheduleCalendar.setTime(date_cal.getTime());
		
		Calendar firstDateOfThisCalendar = Calendar.getInstance();
		firstDateOfThisCalendar.setTime(sdf.parse(orgStartDate));
		
		Calendar lastDateOfCalendar = Calendar.getInstance();
		lastDateOfCalendar.setTime(sdf.parse(orgEndDate));
		
		Calendar calculatedScheduleEndDateCalendar = Calendar.getInstance();
		Calendar eDate_cal = Calendar.getInstance();
		eDate_cal.setTime(sdf.parse(endDate));
		
		switch (info[2]) {
			case "0" :
				while (true) {
					if (date_cal.compareTo(eDate_cal) > 0) break;
					//if (date_cal.compareTo(lastDateOfCalendar) > 0) break;
					if (maxCount == count) break;
					
					boolean generated = false;
					int dayOFWeek = date_cal.get(Calendar.DAY_OF_WEEK) - 1;

					if (info[3].equals("0")) {
						if (dayOFWeek != 0 && dayOFWeek != 6) {
							generated = true;
						}
					} else {
						generated = true;
					}

					if (generated) {
						count++;
						
						String calcuDate = nsdf.format(date_cal.getTime());

						if (calcuDate.compareTo(orgStartDate.substring(0,10)) >= 0 || calcuDate.compareTo(orgEndDate.substring(0,10)) <= 0) {	
							ScheduleInfoVO rVo = addRepeatRow(vo, date_cal.getTime(), count, info[1]);
							tempResultList.add(rVo);
						}
					}
					
					if (info[3].equals("0")) {
						date_cal.add(Calendar.DATE, 1);
					} else {
						date_cal.add(Calendar.DATE, Integer.parseInt(info[3]));
					}
				}
			break;
			case "1" :
				String isExistEndDate = info[0];
				String isAllday = info[1];
				String weeklyInterval = info[3];
				String dayInfo = info[4];
				
				List<Integer> repeatDayList = new ArrayList<Integer>();
				
				if(dayInfo != null && !dayInfo.trim().equals("")){
					char[] yoilArr = new char[info[4].length()];

					for (int j = 0; j < dayInfo.length(); j++) {
						yoilArr[j] = dayInfo.charAt(j);					
					}
					int yoiltoNumber;
					for (char yoil : yoilArr) {
						yoiltoNumber = yoil - 48;
						repeatDayList.add(yoiltoNumber); 
					}
				}
						
				int MAXSCHEDULECOUNT = 1000;
				//int weeklyMaxCount = maxCount;
				
				while (true) {
					if (scheduleCalendar.compareTo(lastDateOfCalendar) > 0) {
						calculatedScheduleEndDateCalendar.setTime(lastDateOfCalendar.getTime());
						calculatedScheduleEndDateCalendar.add(Calendar.DATE, (Integer.parseInt(weeklyInterval)) * 7);
						if(scheduleCalendar.compareTo(calculatedScheduleEndDateCalendar) > 0) {
							break;
						}
					}
					
					if (Integer.parseInt(isExistEndDate) > 0) {
						if (maxCount <= count) break;
					} 
					
					if (count > MAXSCHEDULECOUNT) {
						break;
					}
					
					if(isExistEndDate.equals("0")){ //isExistEndDate Code "0" : 종료일 있음
						for (int k = 0; k < repeatDayList.size(); k++) {
							count++;
							scheduleCalendar.set(Calendar.DAY_OF_WEEK,repeatDayList.get(k)+1);
							if (scheduleCalendar.getTime().compareTo(scheduleStartDate) >= 0 && scheduleCalendar.getTime().compareTo(sdf.parse(endDate)) <= 0) {
								ScheduleInfoVO rVo = addRepeatRow(vo, scheduleCalendar.getTime(), count, isAllday);									
								tempResultList.add(rVo);
							}
						}
					} else if (Integer.parseInt(isExistEndDate) > 0) { //isExistEndDate Code > 0 : 숫자만큼 일정을 반복
						for (int k = 0; k < repeatDayList.size(); k++) {
							count++;
							scheduleCalendar.set(Calendar.DAY_OF_WEEK,repeatDayList.get(k)+1);
							if (scheduleCalendar.getTime().compareTo(scheduleStartDate) >= 0 && scheduleCalendar.getTime().compareTo(sdf.parse(endDate)) <= 0) {
								if (maxCount >= count) {
									ScheduleInfoVO rVo = addRepeatRow(vo, scheduleCalendar.getTime(), count, isAllday);									
									tempResultList.add(rVo);
								} else {
									break;
								}
							} 
						}
					} else { //isExistEndDate Code "-1" : 종료일 없음
						for (int k = 0; k < repeatDayList.size(); k++) {
							count++;
							scheduleCalendar.set(Calendar.DAY_OF_WEEK,repeatDayList.get(k)+1);
							if (scheduleCalendar.getTime().compareTo(scheduleStartDate) >= 0 && scheduleCalendar.getTime().compareTo(sdf.parse(endDate)) <= 0) {
								ScheduleInfoVO rVo = addRepeatRow(vo, scheduleCalendar.getTime(), count, isAllday);									
								tempResultList.add(rVo);
							}
						}
					}
					scheduleCalendar.add(Calendar.DATE, (Integer.parseInt(weeklyInterval)) * 7);
				}						
			break;	
			
			case "2" :
				while (true) {
					int year = date_cal.get(Calendar.YEAR);
					int month = date_cal.get(Calendar.MONTH) + 1;

					if ((year >= eDate_cal.get(Calendar.YEAR) && month > eDate_cal.get(Calendar.MONTH) + 1) || year > eDate_cal.get(Calendar.YEAR)) break;
					if (maxCount == count) break;
					
					boolean generated = false;
					
					Calendar newCal = Calendar.getInstance();
					newCal.set(year, month-1, 1);
					if(info[1].equals("1")) {
						newCal.set(Calendar.HOUR_OF_DAY, 0);
						newCal.set(Calendar.MINUTE, 0);
						newCal.set(Calendar.SECOND, 0);
					}

					if (info[3].equals("1")) {
						newCal.add(Calendar.DATE, Integer.parseInt(info[5]) - 1);
					} else {
						int diff = Integer.parseInt(info[6]) - (newCal.get(Calendar.DAY_OF_WEEK) - 1);
						
						if (diff < 0) {
							diff += 7;									
						}								
						newCal.add(Calendar.DATE, diff);
						
						if (Integer.parseInt(info[5]) < 5) {
							newCal.add(Calendar.DATE, (Integer.parseInt(info[5]) - 1) * 7);
						} else {
							while (true) {
								newCal.add(Calendar.DATE, 7);
								
								if (newCal.get(Calendar.MONTH) + 1 != month) {
									newCal.add(Calendar.DATE, -7);
									break;
								}
							}
						}
					}

					if (newCal.get(Calendar.MONTH) + 1 == month && (!isFirst || newCal.get(Calendar.DATE) >= date_cal.get(Calendar.DATE))) {
						generated = true;
					}
					
					isFirst = false;

					if (generated) {
						count++;

						String calcuDate = nsdf.format(newCal.getTime());
						
						if (info[0].equals("0")) {
							if (calcuDate.compareTo(orgStartDate.substring(0,10)) >= 0 || calcuDate.compareTo(endDate.substring(0,10)) <= 0) {
								ScheduleInfoVO rVo = addRepeatRow(vo, newCal.getTime(), count, info[1]);
								tempResultList.add(rVo);
							}
						} else {
							if (calcuDate.compareTo(orgStartDate.substring(0,10)) >= 0 || calcuDate.compareTo(orgEndDate.substring(0,10)) <= 0) {
								ScheduleInfoVO rVo = addRepeatRow(vo, newCal.getTime(), count, info[1]);
								tempResultList.add(rVo);
							}
						}
					}
					
					date_cal.add(Calendar.DATE, 1 - date_cal.get(Calendar.DATE));
					date_cal.add(Calendar.MONTH, Integer.parseInt(info[4]));							
				}
			break;
			
			case "3" :
				while (true) {
					int year = date_cal.get(Calendar.YEAR);
					int month = Integer.parseInt(info[4]);
							
					if (year > lastDateOfCalendar.get(Calendar.YEAR)) break;
					if (maxCount == count) break;
					
					boolean generated = false;
					
					Calendar newCal = Calendar.getInstance();
					newCal.set(year, month-1, 1);
					
					if (info[3].equals("1")) {
						newCal.add(Calendar.DATE, Integer.parseInt(info[5]) - 1);
						
						if (info[5].equals("2")) {
							//음력으로 newCal 다시 만듬									
							if (!isFirst || newCal.compareTo(date_cal) >= 0) {
								generated = true;
							}
						}
					} else {
						int diff = Integer.parseInt(info[6]) - (newCal.get(Calendar.DAY_OF_WEEK) - 1); 
						
						if (diff < 0) {
							diff += 7;									
						}								
						newCal.add(Calendar.DATE, diff);
						
						if (Integer.parseInt(info[5]) < 5) {
							newCal.add(Calendar.DATE, (Integer.parseInt(info[5]) - 1) * 7);
						} else {
							while (true) {
								newCal.add(Calendar.DATE, 7);
								
								if (newCal.get(Calendar.MONTH) + 1 != month) {
									newCal.add(Calendar.DATE, -7);
									break;
								}
							}
						}
					}
					
					if (newCal.get(Calendar.MONTH) + 1 == month && (!isFirst || newCal.get(Calendar.DATE) >= date_cal.get(Calendar.DATE))) {
						generated = true;
					}
					
					isFirst = false;
					
					if (generated) {
						count++;
						
						String calcuDate = nsdf.format(newCal.getTime());
						
						if (info[0].equals("0")) {
							if (calcuDate.compareTo(orgStartDate.substring(0,10)) >= 0 || calcuDate.compareTo(endDate.substring(0,10)) <= 0 ) {
								ScheduleInfoVO rVo = addRepeatRow(vo, newCal.getTime(), count, info[1]);
								resultList.add(rVo);
							}
						} else {
							if (calcuDate.compareTo(orgStartDate.substring(0,10)) >= 0 || calcuDate.compareTo(orgEndDate.substring(0,10)) <= 0 ) {
								ScheduleInfoVO rVo = addRepeatRow(vo, newCal.getTime(), count, info[1]);
								resultList.add(rVo);
							}
						}
					}
					
					date_cal.add(Calendar.DATE, 1 - date_cal.get(Calendar.DATE));
					date_cal.add(Calendar.YEAR, 1);
				}						
			break;	
		}
		
		if (tempResultList != null) {
			resultList = realList(resultList, tempResultList, orgStartDate, orgEndDate);
		}
		
		for(ScheduleInfoVO svo : tList) {
			resultList.stream().filter(x -> x.getStartDate().equals(svo.getGoogleOriginalStartTime()) && x.getGoogleId().equals(svo.getGoogleRecurringEventId()))
											.findFirst()
											.ifPresent(x -> { x.setTitle(svo.getTitle()); x.setStartDate(svo.getStartDate()); x.setEndDate(svo.getEndDate()); x.setGoogleId(svo.getGoogleId()); });
		}
		
		return resultList;
	}
	
	public List<ScheduleInfoVO> realList(List<ScheduleInfoVO> resultList, List<ScheduleInfoVO> tempResultList, String startDate, String endDate) throws Exception {
		String vosDate = "";
		String voeDate = "";
		
		for (ScheduleInfoVO svo : tempResultList) {
			vosDate = svo.getStartDate();
			voeDate = svo.getEndDate();
			
			Calendar vosDate_cal = Calendar.getInstance();
			Calendar voeDate_cal = Calendar.getInstance();
			Calendar sDate_cal = Calendar.getInstance();
			Calendar eDate_cal = Calendar.getInstance();
			
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
			
			vosDate_cal.setTime(sdf.parse(vosDate));
			voeDate_cal.setTime(sdf.parse(voeDate));
			sDate_cal.setTime(sdf.parse(startDate));
			eDate_cal.setTime(sdf.parse(endDate));

			if (vosDate.substring(0,10).equals(voeDate.substring(0,10))) {
				if (vosDate_cal.compareTo(sDate_cal) >= 0 && voeDate_cal.compareTo(eDate_cal) <= 0) {
					resultList.add(svo);
				} 
			} else {
				if (voeDate_cal.compareTo(sDate_cal) < 0 || vosDate_cal.compareTo(eDate_cal) > 0) {
					
				} else {
					resultList.add(svo);
				}
			}
		}
		
		return resultList;
	}
	
	public ScheduleInfoVO addRepeatRow(ScheduleInfoVO vo, Date date, int count, String dateType) throws Exception {
		SimpleDateFormat nsdf = new SimpleDateFormat("yyyy-MM-dd");
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		ScheduleInfoVO innerVO = new ScheduleInfoVO();
		
		String dateTime1 = nsdf.format(date) + vo.getStartDate().substring(10);
		String dateTime2 = "";
		long repeatedScheduleOffset = vo.getRepeatedScheduleOffset();
		if (repeatedScheduleOffset != 0 && repeatedScheduleOffset > 86400000) {
			Calendar cal = Calendar.getInstance();
			
			if(repeatedScheduleOffset % 86400000 != 0) {
				cal.setTimeInMillis(date.getTime() + repeatedScheduleOffset);
			} else {
				cal.setTimeInMillis(date.getTime() + repeatedScheduleOffset - 1000);
			}
			dateTime2 = sdf.format(cal.getTime());
		} else {
			dateTime2 = nsdf.format(date) + vo.getEndDate().substring(10);
			if (dateTime1.compareTo(dateTime2) > 0) {
				Calendar cal = Calendar.getInstance();
				
				cal.setTime(date);
				cal.add(Calendar.DATE, 1);
				
				dateTime2 = nsdf.format(cal.getTime()) + vo.getEndDate().substring(10); 
			}
		}
		
		int newDateType = Integer.parseInt(dateType) + 1;
		
		BeanUtils.copyProperties(innerVO, vo);
				
		innerVO.setStartDate(dateTime1);
		innerVO.setEndDate(dateTime2);
		innerVO.setDateType(newDateType + "");
		innerVO.setRepeatCount(count);			
		innerVO.setRealEndDate(vo.getEndDate());

		return innerVO; 
	}
    
	private boolean checkPublic(Event event) {
		return event.getVisibility() != null && (event.getVisibility().equals("private") || event.getVisibility().equals("confidential"));
	}

	private void setGoogleDate(Event event, ScheduleInfoVO svo, LoginVO userInfo) throws Exception {
		boolean isAllday = (event.getStart().getDate() != null) ? true : false;
		boolean isOneday = false;
		if (isAllday) isOneday = checkOneday(event);
		DateTime googleStartDate = getGoogleDate(event.getStart(), isAllday);
		DateTime googleEndDate = getGoogleDate(event.getEnd(), isAllday);
		String googleStartDateTime = setGoogleTime(googleStartDate, false, isOneday , userInfo.getOffset());
		String googleEndDateTime = setGoogleTime(googleEndDate, true , isOneday, userInfo.getOffset());
		svo.setDateType(isAllday ? "2" : "1");
		svo.setStartDate(googleStartDateTime);
		svo.setEndDate(googleEndDateTime);
		
		if (event.getRecurrence() != null) {
			String recur = setRecur(event);
			RecurrenceRule rule = new RecurrenceRule(recur);
			String repetition = getRepetitionByRecurrenceRule(rule, isAllday, event, userInfo.getOffset(), userInfo.getTenantId(), userInfo.getCompanyID());
			svo.setRepetition(repetition);
			
			long repeatedScheduleOffset = googleEndDate.getValue() - googleStartDate.getValue();
			svo.setRepeatedScheduleOffset(repeatedScheduleOffset);
			if (repetition.startsWith("0")) {
				resetEndDate(svo, googleEndDate, rule, repetition, userInfo.getOffset());
			}
			svo.setDateType("3");
		}
	}
	
	public String getRepetitionByRecurrenceRule(RecurrenceRule rule, boolean isAllday, Event event, String offset, int tenantId, String companyId) throws Exception {	
		String[] info = new String[7];
		String repetition = "";
		
		setRepetitionInfoEndType(rule, info); //info[0]
		setRepetitionInfoTimeType(rule, info, isAllday); //info[1]
		
		logger.debug("rule.getFreq() : " + rule.getFreq().toString());
		switch (rule.getFreq().toString()) {
			case "DAILY":
				setRepetitionInfoDailyRepetition(rule, info);
				break;
			case "WEEKLY":
				setRepetitionInfoWeeklyRepetition(rule, info, isAllday, event, offset, tenantId, companyId);
				break;
			case "MONTHLY":
				setRepetitionInfoMonthlyRepetition(rule, info, isAllday, event);
				break;
			case "YEARLY":
				setRepetitionInfoYearlyRepetition(rule, info, isAllday, event);
				break;
			default:break;
		}
		
		ArrayList<String> list = new ArrayList<String>(Arrays.asList(info));
		repetition = list.stream().filter(StringUtils::isNotBlank).collect(Collectors.joining("|"));

		logger.debug("repetition : " + repetition);
		return repetition;
	}
	
	private void setRepetitionInfoEndType(RecurrenceRule rule, String[] info) {
		if (rule.getUntil() == null) { //종료일없음 or 회수지정
			info[0] =(rule.getCount() == null) ? "-1" : String.valueOf(rule.getCount());
		} else { //종료일있음
			info[0] = "0";
		}
	}
		
	private void setRepetitionInfoTimeType(RecurrenceRule rule, String[] info, boolean isAllday) {
		info[1] = isAllday ? "1" : "0";
	}
	
	private void setRepetitionInfoDailyRepetition(RecurrenceRule rule, String[] info) {
		info[2] = "0";
		info[3] = rule.getInterval() == -1 ? "1" : String.valueOf(rule.getInterval());
	}
	
	private void setRepetitionInfoWeeklyRepetition(RecurrenceRule rule, String[] info, boolean isAllday, Event event, String offset, int tenantId, String companyId) throws Exception {
		info[2] = "1";
		info[3] = rule.getInterval() == -1 ? "1" : String.valueOf(rule.getInterval());
		if (rule.getByDayPart() != null) {
			info[4] = "";
			for (WeekdayNum weekDay : rule.getByDayPart()) {
				info[4] += changeInfo(weekDay.weekday.name());
			}
			//정렬을 하는 이유는 요일의 순서가 오름차순이 아니면 ezScheduleService에 이 있는 getScheduleList 함수에서 잘못 표현된다.
			int[] dayNum = new int[info[4].length()];

			for (int j = 0; j < info[4].length(); j++) {
				dayNum[j] = info[4].charAt(j) - 48;					
			}
			
			Arrays.sort(dayNum);
			
			info[4] = "";
			for (int i = 0; i < dayNum.length; i++) {
				info[4] += String.valueOf(dayNum[i]);
			}
		}
	}
	
	private void setRepetitionInfoMonthlyRepetition(RecurrenceRule rule, String[] info, boolean isAllday, Event event) {
		SimpleDateFormat dateforsdf = new SimpleDateFormat("dd");
		Date startDate = new Date();
		Date startDateTime = new Date();
		if (isAllday) {
			startDate = new Date(event.getStart().getDate().getValue());
		} else {
			startDateTime = new Date(event.getStart().getDateTime().getValue());
		}
		
		info[2] = "2";
		if (rule.getByDayPart() == null) {
			info[3] = "1";
			info[4] = rule.getInterval() == -1 ? "1" : String.valueOf(rule.getInterval());
			info[5] = isAllday ? String.valueOf(Integer.parseInt(dateforsdf.format(startDate))) : String.valueOf(Integer.parseInt(dateforsdf.format(startDateTime)));
		} else {
			info[3] = "2";
			info[4] = rule.getInterval() == -1 ? "1" : String.valueOf(rule.getInterval());
			if (rule.getByDayPart().size() > 1) { //사이즈1이여야함
				return;
			} else {
				if (rule.getByDayPart().get(0).toString().indexOf("-1") > -1) { //매월마지막인지체크
					info[5] = "5";
					info[6] = changeInfo(rule.getByDayPart().get(0).toString().substring(1));
				} else {
					info[5] = rule.getByDayPart().get(0).toString().substring(0,1);
					info[6] = changeInfo(rule.getByDayPart().get(0).toString().substring(1));
				}
			}
		}
	}
	
	private void setRepetitionInfoYearlyRepetition(RecurrenceRule rule, String[] info, boolean isAllday, Event event) {
		SimpleDateFormat monthforsdf = new SimpleDateFormat("MM");
		SimpleDateFormat dateforsdf = new SimpleDateFormat("dd");
		
		Date startDate = new Date();
		Date startDateTime = new Date();
		if (isAllday) {
			startDate = new Date(event.getStart().getDate().getValue());
		} else {
			startDateTime = new Date(event.getStart().getDateTime().getValue());
		}
		
		info[2] = "3";
		
		//Setting info[4]
		if (rule.getInterval() == -1 || rule.getInterval() == 1) {
			info[4] = isAllday ? String.valueOf(Integer.parseInt(monthforsdf.format(startDate))) : String.valueOf(Integer.parseInt(monthforsdf.format(startDateTime)));
		} else { //반복주기가 1년보다 클 때
			logger.debug("Groupware yearly repetition`s Interval can`t over 1 year!!! Google`s yearly repetition Interval : " + rule.getInterval());
			return;
		}
		
		if (rule.getByDayPart() == null) {
			info[3] = "1";
			info[5] = isAllday ? String.valueOf(Integer.parseInt(dateforsdf.format(startDate))) : String.valueOf(Integer.parseInt(dateforsdf.format(startDateTime)));
		} else {
			info[3] = "2";
						
			if (rule.getByDayPart().get(0).toString().indexOf("-1") > -1) { //매월마지막인지체크
				info[5] = "5";
				info[6] = changeInfo(rule.getByDayPart().get(0).toString().substring(1));
			} else {
				info[5] = rule.getByDayPart().get(0).toString().substring(0,1);
				info[6] = changeInfo(rule.getByDayPart().get(0).toString().substring(1));
			}
		}
	}
	
	private String changeInfo(String weekday) {
		String result = "0";
		
		switch (weekday) {
			case "SU" : result = "0"; break;
			case "MO" : result = "1"; break;
			case "TU" : result = "2"; break;
			case "WE" : result = "3"; break;
			case "TH" : result = "4"; break;
			case "FR" : result = "5"; break;
			case "SA" : result = "6"; break;
			default : break;
		}
		
		return result;
	}

	private boolean checkOneday(Event event) {
		return event.getStart().getDate().getValue() == event.getEnd().getDate().getValue() ? true : false;
	}
	
	private DateTime getGoogleDate(EventDateTime googleStart, boolean isAllday) {
		DateTime googleStartDate = isAllday ? googleStart.getDate() : googleStart.getDateTime();
		return googleStartDate;
	}
	
	private String setGoogleTime(DateTime googleDate, boolean isEnd, boolean isOneday, String offset) throws ParseException {
		String googleDateTime = "";
		boolean isAllday = googleDate.isDateOnly();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		if (isAllday) {
			googleDateTime = googleDate + " 00:00:00";
			if (isEnd) {
				java.util.Calendar cal = java.util.Calendar.getInstance();
				cal.setTime(sdf.parse(googleDateTime));
				cal.add(java.util.Calendar.MINUTE, -1);
				googleDateTime = sdf.format(cal.getTime());
			}
		} else {
			if (isEnd) {
				java.util.Calendar cal = java.util.Calendar.getInstance();
				cal.setTime(sdf.parse(sdf.format(googleDate.getValue())));
				if (isOneday) {
					cal.add(java.util.Calendar.DATE, 1);
				}
				String googleEndAllDate = sdf.format(cal.getTime());
				googleDateTime = googleEndAllDate;
			} else {
				String googleStartAllDate = sdf.format(googleDate.getValue());			
				googleDateTime = googleStartAllDate;
			}
		}
		
		return googleDateTime;
	}
	
	private void resetEndDate(ScheduleInfoVO svo, DateTime googleEndDate, RecurrenceRule rule, String repetition, String offset) {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		SimpleDateFormat usdf = new SimpleDateFormat("yyyy-MM-dd");
		
		String untilDate = usdf.format(rule.getUntil().getTimestamp());
		String[] info = repetition.split("\\|");
		if (info[1].equals("1")) {
			untilDate += " 23:59:00";
		} else {
			String endTime = sdf.format(googleEndDate.getValue()).substring(10);
			untilDate += endTime;
		}
		svo.setEndDate(commonUtil.getDateStringInUTC(untilDate, offset, true));
	}

	private String setRecur(Event event) {
		String recur = "";
		if (event.getRecurrence().get(0).startsWith("RRULE:")) {
			recur = event.getRecurrence().get(0).substring(6);
		}
		return recur;
	}
	
	public Event getGoogleScheduleInfo(String googleid, LoginVO userInfo, String readFlag, String memberId) throws Exception {
		Map<String, Object> map = new HashMap<>();
		if (readFlag.equals("member")) {
			map.put("v_USERID", memberId);
		} else {
			map.put("v_USERID", userInfo.getId());
		}
		map.put("v_COMPANYID", userInfo.getCompanyID());
		map.put("v_TENANTID", userInfo.getTenantId());
		
		ScheduleTokenInfoVO token = ezScheduleDAO.getScheduleTokenInfo(map);

		if (token != null && token.getGoogleAccessToken() != null && token.getGoogleRefreshToken() != null) {
			try {
				buildCalendarService(userInfo);
				
				Event event = service.events().get("primary", googleid).execute();
				
				logger.debug("getGoogleSchedule ended ==> success");
				return event;
			} catch (IOException e) {
				logger.error(e.getMessage(), e);
				logger.debug("getGoogleSchedule ended ==> error");
				return null;
			}
		} else {
			logger.debug("getGoogleSchedule ended ==> no sync user");
			return null;
		}
	}

}
    
    